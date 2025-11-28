BattlePassPreviewCell = class("BattlePassPreviewCell", BaseCell)

function BattlePassPreviewCell:Init()
  BattlePassPreviewCell.super.Init(self)
  self:FindObjs()
end

function BattlePassPreviewCell:FindObjs()
  self.title = self:FindComponent("title", UILabel)
  self.container = self:FindComponent("container", UIGrid)
  self.itemlist = UIGridListCtrl.new(self.container, BagItemCell, "BagItemCell")
  self.itemlist:AddEventListener(MouseEvent.MouseClick, function(owner, cell)
    self:PassEvent(MouseEvent.MouseClick, cell)
  end, self)
  self.toggleBg = self:FindGO("togglebg")
  self.toggleButton = self:FindGO("toggle")
  self:AddClickEvent(self.toggleButton, function()
    self:ToggleShow()
  end)
end

function BattlePassPreviewCell:SetData(data)
  self.data = data
  if data == 0 then
    self.toggleLines = 1
    self.sdata = {
      Name = ZhString.ServantBattlePassView_text5,
      NormalLevel = BattlePassProxy.Instance.maxBpLevel
    }
  else
    self.toggleLines = 2
    self.sdata = BattlePassProxy.Instance.UpgradeDepositItem[data]
  end
  self.title.text = string.format(ZhString.ServantBattlePassView_text6, self.sdata.Name)
  self.toggleShow = nil
  self:ToggleShow(false)
end

function BattlePassPreviewCell:ToggleShow(show)
  if show then
    self.toggleShow = show
  end
  if self.toggleShow then
    self.toggleShow = false
    self.toggleButton.transform.localPosition = LuaGeometry.GetTempVector3(0, -63, 0)
    self.toggleButton.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  else
    self.toggleShow = true
    self.toggleButton.transform.localPosition = LuaGeometry.GetTempVector3(0, -61, 0)
    self.toggleButton.transform.localScale = LuaGeometry.GetTempVector3(1, -1, 1)
  end
  if not self.rewards then
    local rewardTab, condLevel = {}
    if self.sdata.NormalLevel and 0 < self.sdata.NormalLevel then
      condLevel = self.sdata.Condition and self.sdata.Condition.NormalLevel or 0
      local re1, re2 = BattlePassProxy.Instance:GetRewardInfoByLevelRange(BitUtil.setbit(0, 1), condLevel + 1, self.sdata.NormalLevel, false, true)
      rewardTab = BattlePassProxy.MergeRewardInfoTable(rewardTab, re2)
    end
    if self.sdata.AdvLevel and 0 < self.sdata.AdvLevel then
      condLevel = self.sdata.Condition and self.sdata.Condition.AdvLevel or 0
      local re1, re2 = BattlePassProxy.Instance:GetRewardInfoByLevelRange(BitUtil.setbit(0, 2), condLevel + 1, self.sdata.AdvLevel, false, true)
      rewardTab = BattlePassProxy.MergeRewardInfoTable(rewardTab, re2)
    end
    if self.sdata.SuLevel and 0 < self.sdata.SuLevel then
      condLevel = self.sdata.Condition and self.sdata.Condition.SuLevel or 0
      local re1, re2 = BattlePassProxy.Instance:GetRewardInfoByLevelRange(BitUtil.setbit(0, 3), condLevel + 1, self.sdata.SuLevel, false, true)
      rewardTab = BattlePassProxy.MergeRewardInfoTable(rewardTab, re2)
    end
    self.rewards = BattlePassProxy.GetSortedItemListByRewardInfoTable(rewardTab)
  end
  local ShowCount, lines = self.container.maxPerLine * self.toggleLines, self.toggleLines
  if not self.toggleShow and ShowCount < #self.rewards then
    local rewards = {}
    for i = 1, ShowCount do
      rewards[i] = self.rewards[i]
    end
    self.itemlist:ResetDatas(rewards)
  else
    self.itemlist:ResetDatas(self.rewards)
    lines = math.ceil(#self.rewards / self.container.maxPerLine)
  end
  self.toggleBg.transform.localPosition = LuaGeometry.GetTempVector3(0, -98 * (lines - 1), 0)
  self:PassEvent(BattlePassEvent.PreviewToggleShow, self)
end
