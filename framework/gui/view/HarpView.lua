HarpView = class("HarpView", BaseView)
HarpView.ViewType = UIViewType.NormalLayer
local hideType = {hideClickSound = true, hideClickEffect = false}
local clickEffect = "Collection_HuashenHarp"
local soundList = {
  [1] = {
    SE = AudioMap.UI.Music_1,
    sound = "Do"
  },
  [2] = {
    SE = AudioMap.UI.Music_2,
    sound = "Re"
  },
  [3] = {
    SE = AudioMap.UI.Music_3,
    sound = "Mi"
  },
  [4] = {
    SE = AudioMap.UI.Music_4,
    sound = "Fa"
  },
  [5] = {
    SE = AudioMap.UI.Music_5,
    sound = "So"
  },
  [6] = {
    SE = AudioMap.UI.Music_6,
    sound = "La"
  },
  [7] = {
    SE = AudioMap.UI.Music_7,
    sound = "Xi"
  }
}

function HarpView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function HarpView:FindObjs()
  self.clickEffectHandler = {}
  self.stringEffectHandler = {}
  self.effectHandlerRoot = self:FindGO("effectContainer")
  self.Do = self:FindGO("Do")
  self.Re = self:FindGO("Re")
  self.Mi = self:FindGO("Mi")
  self.Fa = self:FindGO("Fa")
  self.So = self:FindGO("So")
  self.La = self:FindGO("La")
  self.Xi = self:FindGO("Xi")
  self.clickEffectHandlerRoot = self:FindGO("clickEffectHandler", self.effectHandlerRoot)
  self.stringEffectHandlerRoot = self:FindGO("stringEffectHandler", self.effectHandlerRoot)
  for i = 1, 7 do
    self.clickEffectHandler[i] = self:FindGO("effectHandler" .. i, self.clickEffectHandlerRoot)
    self.stringEffectHandler[i] = self:FindGO("effectHandler" .. i, self.stringEffectHandlerRoot)
  end
  self.scrollView = self:FindComponent("scrollView", UIScrollView)
  self.bgTexture = self:FindComponent("BG", UITexture)
  self.harpTexture = self:FindComponent("HarpTexture", UITexture)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
end

function HarpView:AddEvts()
  self:AddClickEvent(self.Do, function()
    self:PlaySoundEffect(1)
  end, hideType)
  self:AddClickEvent(self.Re, function()
    self:PlaySoundEffect(2)
  end, hideType)
  self:AddClickEvent(self.Mi, function()
    self:PlaySoundEffect(3)
  end, hideType)
  self:AddClickEvent(self.Fa, function()
    self:PlaySoundEffect(4)
  end, hideType)
  self:AddClickEvent(self.So, function()
    self:PlaySoundEffect(5)
  end, hideType)
  self:AddClickEvent(self.La, function()
    self:PlaySoundEffect(6)
  end, hideType)
  self:AddClickEvent(self.Xi, function()
    self:PlaySoundEffect(7)
  end, hideType)
  self:AddCloseButtonEvent()
  
  function self.scrollView.onDragStarted()
    self:OnClickStart()
  end
  
  function self.scrollView.onStoppedMoving()
    self:OnClickEnd()
  end
end

function HarpView:InitView()
  self.lastMousePosX = 0
  self.lastMousePosY = 0
  PictureManager.Instance:SetUI("persona_pic_bottom", self.bgTexture)
  PictureManager.Instance:SetUI("Adventure_bg_harp", self.harpTexture)
  self:PlayEffectByFullPath(EffectMap.Maps.Harp, self.effectHandlerRoot)
end

local tempVector3 = LuaVector3.Zero()

function HarpView:PlaySoundEffect(clickSound)
  local path = soundList[clickSound] and soundList[clickSound].SE
  self:PlayUISound(path)
  local effectHandlerPos = self.clickEffectHandler[clickSound].transform.localPosition
  local _, effectY = self:GetScreenTouchedPos()
  LuaVector3.Better_Set(tempVector3, effectHandlerPos.x, effectY - 50, effectHandlerPos.z)
  self.clickEffectHandler[clickSound].transform.localPosition = tempVector3
  if soundList[clickSound] then
    self:PlayUIEffect(clickEffect, self.clickEffectHandler[clickSound], true)
    self:PlayEffectByFullPath(EffectMap.Maps.Harp02, self.stringEffectHandler[clickSound], true)
  end
end

function HarpView:OnClickStart()
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 20, self.Sweep, self)
  end
end

function HarpView:OnClickEnd()
  TimeTickManager.Me():ClearTick(self)
  self.timeTick = nil
end

function HarpView:Sweep()
  local positionX, positionY = self:GetScreenTouchedPos()
  if math.abs(positionX - self.lastMousePosX) <= 23 then
    return
  end
  local offsetX = positionX
  if -205 <= offsetX and offsetX <= -175 then
    self:PlaySoundEffect(1)
  elseif -123 <= offsetX and offsetX <= -93 then
    self:PlaySoundEffect(2)
  elseif -60 <= offsetX and offsetX <= -28 then
    self:PlaySoundEffect(3)
  elseif -7 <= offsetX and offsetX <= 23 then
    self:PlaySoundEffect(4)
  elseif 45 <= offsetX and offsetX <= 75 then
    self:PlaySoundEffect(5)
  elseif 96 <= offsetX and offsetX <= 126 then
    self:PlaySoundEffect(6)
  elseif 139 <= offsetX and offsetX <= 169 then
    self:PlaySoundEffect(7)
  end
  self.lastMousePosX = positionX
  self.lastMousePosY = positionY
end

function HarpView:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    if not ApplicationInfo.IsRunOnEditor() then
      LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    end
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function HarpView:OnExit()
  PictureManager.Instance:UnLoadUI("persona_pic_bottom", self.bgTexture)
  PictureManager.Instance:UnLoadUI("Adventure_bg_harp", self.harpTexture)
  TimeTickManager.Me():ClearTick(self)
  self.timeTick = nil
  HarpView.super.OnExit(self)
end
