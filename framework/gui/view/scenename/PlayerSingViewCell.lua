local BaseCell = autoImport("BaseCell")
PlayerSingViewCell = reusableClass("PlayerSingViewCell", BaseCell)
PlayerSingViewCell.PoolSize = 50
PlayerSingViewCell.resId = ResourcePathHelper.UIPrefab_Cell("PlayerSingViewCell")

function PlayerSingViewCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function PlayerSingViewCell:DoConstruct(asArray, args)
  self._alive = true
  local followTarget = args[1]
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PlayerSingViewCell.resId, followTarget)
  self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)
  if not self:ObjIsNil(self.gameObject) and not self:ObjIsNil(followTarget) then
    self.gameObject.transform:SetParent(followTarget.transform, false)
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    self.processSlider = self:FindComponent("ProcessSlider", Slider)
  end
end

function PlayerSingViewCell:Deconstruct(asArray)
  if not self:ObjIsNil(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PlayerSingViewCell.resId, self.gameObject)
  end
  self.canvasGroup = nil
  self.gameObject = nil
  self.processSlider = nil
  self._alive = false
end

function PlayerSingViewCell:Alive()
  return self._alive
end

function PlayerSingViewCell:SetData(creature)
  self:initData()
  self.id = creature.data.id
  self.processTime = creature.skill:GetCastTime(creature)
  self:SetActive(true)
  self:startProcess()
end

function PlayerSingViewCell:initData()
  self.processSlider.value = 0
  self.processTime = 0
end

function PlayerSingViewCell:startProcess()
  LeanTween.cancel(self.processSlider.gameObject)
  LeanTween.sliderUGUI(self.processSlider, 0, 1, self.processTime):setOnComplete(function()
    self:stopProcess()
  end)
end

function PlayerSingViewCell:stopProcess()
  self:SetActive(false)
  self.id = nil
  if self.processSlider ~= nil then
    self.processSlider.value = 0
  end
  self.processTime = 0
  self.skillid = nil
end

function PlayerSingViewCell:delayProcess()
  self:stopProcess()
end

function PlayerSingViewCell:SetActive(visible)
  if not self.canvasGroup then
    return
  end
  if self.processTime == 0 or not self.id then
    return
  end
  self.canvasGroup.alpha = visible and 1 or 0
end

function PlayerSingViewCell:SetSyncData(creature)
  self:initData()
  self.id = creature.data.id
  local chantinfo = creature:GetChantSkill()
  if not chantinfo then
    return
  end
  self.startime = chantinfo.starttime or 0
  self.processTime = creature:GetChantSkillTime()
  self.skillid = chantinfo.skillid or 0
  self:SetActive(true)
  self:StartSyncProcess()
end

function PlayerSingViewCell:StartSyncProcess()
  if self.processTime > 0 and 0 < self.startime then
    local delta = ServerTime.CurServerTime() / 1000 - self.startime
    delta = 0 < delta and delta or 0
    local lefttime = self.processTime - delta
    if 0 < delta and 0 < lefttime then
      LeanTween.cancel(self.processSlider.gameObject)
      LeanTween.sliderUGUI(self.processSlider, delta / self.processTime, 1, lefttime):setOnComplete(function()
        self:stopProcess()
      end)
    end
  end
end

function PlayerSingViewCell:SetHeartLockData(creature, processtime)
  self:initData()
  self.id = creature.data.id
  self.processTime = processtime
  self:SetActive(true)
  self:startProcess()
end
