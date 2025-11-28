BlindMaskView = class("BlindMaskView", ContainerView)
BlindMaskView.ViewType = UIViewType.BlindLayer
local tempVector3 = LuaVector3(0, 0, 0)

function BlindMaskView:OnExit()
  MyselfData.BlindMaskViewInstance = nil
  TimeTickManager.Me():ClearTick(self)
  BlindMaskView.super.OnExit(self)
end

function BlindMaskView:Init()
  MyselfData.BlindMaskViewInstance = self
  self.curAlpha = 0
  self:AddEvts()
  self:FindObjs()
  self:InitShow()
end

function BlindMaskView:AddEvts()
  self:AddListenEvt(MyselfEvent.UpdateAttrEffect, self.UpdateAttrEffect)
  self:AddListenEvt(PVEEvent.RaidPuzzle_RefreshDarkMask, self.UpdateAttrEffect)
end

function BlindMaskView:FindObjs()
  self.maskTexGO = self:FindGO("BlindMask")
  self.maskTex = self.maskTexGO:GetComponent(UITexture)
end

function BlindMaskView:InitShow()
  local offsetTotal = 1
  self.offsetHalf = offsetTotal / 2
  self.size = 1.5
  self.rect = Rect(0, 0, 1, 1)
  self.aspectRatio = Screen.width / Screen.height
  if self:InitMaskTexture() then
    TimeTickManager.Me():CreateTick(0, 33, self.FollowMyself, self)
  end
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self:ResetEffect(viewdata.BgEffect, viewdata.BgColor)
  else
    self:RefreshStatus()
  end
end

function BlindMaskView:ResetEffect(BgEffect, BgColor)
  if self.effectBG and self.effectBG:Alive() then
    self.effectBG:Destroy()
  end
  self.effectBG = nil
  if BgEffect then
    local effectContainer = self:FindGO("EffectContainer")
    self.effectBG = self:PlayUIEffect(BgEffect, effectContainer)
  end
  if BgColor then
    local result, color = ColorUtil.TryParseHexString(BgColor)
    if result then
      if color.a == 0 then
        self.maskTexGO:SetActive(false)
      else
        self.maskTexGO:SetActive(true)
        self.maskTex.color = color
      end
    end
  end
  self:RefreshStatus()
end

function BlindMaskView:RefreshStatus()
  local tarAlpha = 1
  local raidPuzzleAlpha = RaidPuzzleManager.Me():GetDarkMaskAlpha()
  if raidPuzzleAlpha then
    self.size = 2
  else
    self.size = 1.5
  end
  if not Game.Myself.data.attrEffect3:BlindnessState() then
    tarAlpha = raidPuzzleAlpha
    if tarAlpha then
      self.maskTex.color = LuaGeometry.GetTempColor(0, 0, 0, self.curAlpha or 1)
    end
  end
  if not tarAlpha or tarAlpha <= 0 then
    self:CloseSelf()
    return
  end
  if tarAlpha == self.curAlpha then
    return
  end
  TweenAlpha.Begin(self.maskTex.gameObject, 2, tarAlpha).method = 3
  self.curAlpha = tarAlpha
end

function BlindMaskView:InitMaskTexture()
  local assetRole = Game.Myself.assetRole
  if assetRole == nil then
    return false
  end
  local mainCamera = Camera.main
  if mainCamera == nil then
    return false
  end
  LuaVector3.Better_Set(tempVector3, assetRole:GetCPOrRootPosition(RoleDefines_CP.Face))
  local screenPos = mainCamera:WorldToScreenPoint(tempVector3)
  self:SetMaskPos(screenPos.x, screenPos.y, self.aspectRatio * self.size, self.size)
  return true
end

function BlindMaskView:SetMaskRect(x, y, width, height)
  self.rect.x = x
  self.rect.y = y
  self.rect.width = width
  self.rect.height = height
  self.maskTex.uvRect = self.rect
end

function BlindMaskView:SetMaskPos(posx, posy, width, height)
  if width == nil then
    width = self.aspectRatio * self.size
  end
  if height == nil then
    height = self.size
  end
  local x = self.offsetHalf - posx / Screen.width * width
  local y = self.offsetHalf - posy / Screen.height * height
  self:SetMaskRect(x, y, width, height)
end

function BlindMaskView:FollowMyself()
  local assetRole = Game.Myself.assetRole
  if assetRole == nil then
    return false
  end
  local mainCamera = Camera.main
  if mainCamera == nil then
    return false
  end
  LuaVector3.Better_Set(tempVector3, assetRole:GetCPOrRootPosition(RoleDefines_CP.Face))
  local screenPos = mainCamera:WorldToScreenPoint(tempVector3)
  self:SetMaskPos(screenPos.x, screenPos.y)
end

function BlindMaskView:UpdateAttrEffect()
  self:RefreshStatus()
end
