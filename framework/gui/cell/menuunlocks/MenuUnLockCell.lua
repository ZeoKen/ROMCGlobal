local BaseCell = autoImport("BaseCell")
MenuUnLockCell = class("MenuUnLockCell", BaseCell)

function MenuUnLockCell:Init()
  self:InitUI()
end

function MenuUnLockCell:InitUI()
  local effect1 = self:FindComponent("effect1", ChangeRqByTex)
  local ePaht1 = ResourcePathHelper.UIEffect("3SystemUnlock")
  ePaht1 = ResourcePathHelper.Effect(ePaht1)
  local go = self:LoadPreferb_ByFullPath(ePaht1, effect1.transform)
  effect1.excute = true
  local effect2 = self:FindComponent("effect2", ChangeRqByTex)
  local ePaht2 = ResourcePathHelper.UIEffect("4SystemUnlock_Qutie")
  ePaht2 = ResourcePathHelper.Effect(ePaht2)
  local go = self:LoadPreferb_ByFullPath(ePaht2, effect2.transform)
  effect2.excute = true
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.animHelper = self.animHelper.animatorHelper
  self:AddAnimatorEvent()
end

function MenuUnLockCell:IsShowed()
  return self.isShowed
end

function MenuUnLockCell:ResetAnim()
  self.isShowed = false
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ItemPopShowTimeLim * 1000, function(owner, deltaTime)
    self.isShowed = true
  end, self)
end

function MenuUnLockCell:PlayHide()
  if self.isShowed then
    self.animHelper:Play("UnLockAnim2", 1, false)
  end
end

function MenuUnLockCell:AddAnimatorEvent()
  function self.animHelper.loopCountChangedListener(state, oldLoopCount, newLoopCount)
    if not self.isShowed then
    end
    if state:IsName("UnLockAnim2") then
      self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
    end
  end
end

function MenuUnLockCell:SetData(data)
  self.data = data
  self:ResetAnim()
  local config = self.data.data
  local atlasStr
  local iconStr = "icon_pvp"
  if config and config.Icon then
    atlasStr, iconStr = next(config.Icon)
  end
  if atlasStr == "itemicon" then
    IconManager:SetItemIcon(iconStr, self.icon)
    self.icon:MakePixelPerfect()
  elseif atlasStr == "skillicon" then
    IconManager:SetSkillIcon(iconStr, self.icon)
    self.icon:MakePixelPerfect()
  elseif atlasStr == "uiicon" then
    IconManager:SetUIIcon(iconStr, self.icon)
    self.icon:MakePixelPerfect()
  else
    self.icon.spriteName = iconStr
    self.icon:MakePixelPerfect()
    self.icon.width = self.icon.width * 1.2
    self.icon.height = self.icon.height * 1.2
  end
  local msg = config.Tip
  if config.event then
    if config.event.type == "scenery" then
      local _, viewindex = next(config.event.parama)
      if viewindex and Table_Viewspot[viewindex] then
        local pointName = Table_Viewspot[viewindex].SpotName
        msg = string.format(msg, pointName)
      end
    elseif config.event.type == "unlockmanual" then
      local viewindex = config.event.param[2]
      if viewindex then
        local mapName = Table_Map[viewindex].CallZh
        msg = string.format(msg, mapName)
      end
    end
  end
  self.tip.text = msg
  self.animHelper:Play("UnLockAnim", 1, false)
  self:PlayUISound(AudioMap.Maps.FunctionOpen)
end

function MenuUnLockCell:OnCellDestroy()
  self.animHelper.loopCountChangedListener = nil
end
