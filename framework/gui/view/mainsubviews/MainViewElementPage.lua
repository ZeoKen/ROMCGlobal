MainViewElementPage = class("MainViewElementPage", MainViewDungeonInfoSubPage)
local EmotionSymbol = GameConfig.ElementRaid and GameConfig.ElementRaid.EmotionSymbol or {}

function MainViewElementPage:Init()
  self:ReLoadPerferb("view/MainViewElementPage")
  self:MapViewListener()
  self:InitUI()
  self:Refresh()
end

function MainViewElementPage:InitUI()
  self.count = self:FindComponent("Count", UILabel)
  self.icons = {}
  for i = 1, 5 do
    self.icons[i] = self:FindComponent("icon" .. i, UISprite)
  end
  self.reviveCount = self:FindComponent("ReviveCount", UILabel)
  self.leftMonsterCount = self:FindComponent("LeftMonsterCount", UILabel)
  self.dammageButton = self:FindGO("DammageButton")
  self:AddClickEvent(self.dammageButton, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ElementStaticsView
    })
  end)
end

function MainViewElementPage:MapViewListener()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncEmotionFactorsFuBenCmd, self.Refresh)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateRevive)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncMonsterCountFuBenCmd, self.UpdateMonsterCount)
end

function MainViewElementPage:UpdateRevive(note)
  local revive, maxRevive = DungeonProxy.Instance:GetReviveCount()
  self.reviveCount.text = string.format(ZhString.MainViewElementPage_ReviveCount, math.max(0, maxRevive - revive), maxRevive)
end

function MainViewElementPage:UpdateMonsterCount()
  self.leftMonsterCount.text = string.format(ZhString.MainViewElementPage_LeftMonsterCount, DungeonProxy.Instance:GetLeftMonsterCount())
end

function MainViewElementPage:Refresh(note)
  self.count.text = DungeonProxy.Instance:GetEmotion_totalFactor()
  local factors = DungeonProxy.Instance:GetEmotionFactors() or {}
  for i = 1, #factors do
    local id = factors[i] and factors[i][1]
    local symbol = id and EmotionSymbol[id]
    if symbol then
      self.icons[i].gameObject:SetActive(true)
      IconManager:SetUIIcon(symbol, self.icons[i])
    else
      self.icons[i].gameObject:SetActive(false)
    end
  end
  for i = #factors + 1, 5 do
    self.icons[i].gameObject:SetActive(false)
  end
end

function MainViewElementPage:OnEnter()
  MainViewElementPage.super.OnEnter(self)
  redlog("MainViewElementPage OnEnter")
end

function MainViewElementPage:OnExit()
  MainViewElementPage.super.OnExit(self)
  redlog("MainViewElementPage OnExit")
end
