autoImport("TeamPwsRewardPopUp")
autoImport("TripleTeamPwsRewardCell")
autoImport("TripleTeamPwsTargetCell")
TripleTeamPwsRewardPopUp = class("TripleTeamPwsRewardPopUp", TeamPwsRewardPopUp)
TripleTeamPwsRewardPopUp.ViewType = UIViewType.PopUpLayer
local TabEnum = {Reward = 1, Target = 2}
local SelectCol = "B36B24"
local UnselectCol = "3E59A7"

function TripleTeamPwsRewardPopUp:Init()
  TripleTeamPwsRewardPopUp.super.Init(self)
  self.targetDatas = {}
  self:InitData()
  ServiceMatchCCmdProxy.Instance:CallTriplePvpQuestQueryCmd()
end

function TripleTeamPwsRewardPopUp:InitData()
  for _, data in pairs(Table_TripleTeamPwsRewards) do
    self.rewardDatas[#self.rewardDatas + 1] = data
  end
  table.sort(self.rewardDatas, function(l, r)
    return l.id < r.id
  end)
  for _, data in pairs(Table_TriplePvpTask) do
    self.targetDatas[#self.targetDatas + 1] = data
  end
  table.sort(self.targetDatas, function(l, r)
    return l.id < r.id
  end)
end

function TripleTeamPwsRewardPopUp:FindObjs()
  TripleTeamPwsRewardPopUp.super.FindObjs(self)
  self.closeBtn = self:FindGO("CloseButton")
  self.mask = self:FindGO("Mask")
  self.rewardBtnSp = self:FindComponent("RewardBtn", UIMultiSprite)
  self.rewardBtnLabel = self:FindComponent("Label", UILabel, self.rewardBtnSp.gameObject)
  self.rewardList = self:FindGO("RewardList")
  self:AddTabChangeEvent(self.rewardBtnSp.gameObject, self.rewardList, TabEnum.Reward)
  self.targetBtnSp = self:FindComponent("TargetBtn", UIMultiSprite)
  self.targetBtnLabel = self:FindComponent("Label", UILabel, self.targetBtnSp.gameObject)
  self.targetList = self:FindGO("TargetList")
  self:AddTabChangeEvent(self.targetBtnSp.gameObject, self.targetList, TabEnum.Target)
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32619, helpBtn)
  self.gotoBtn = self:FindGO("GotoButton")
  self:AddClickEvent(self.gotoBtn, function()
    FuncShortCutFunc.Me():CallByID(8348)
    self:CloseSelf()
  end)
end

function TripleTeamPwsRewardPopUp:InitList()
  local grid = self:FindComponent("rewardContainer", UIGrid)
  self.listRewards = UIGridListCtrl.new(grid, TripleTeamPwsRewardCell, "TripleTeamPwsRewardCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  grid = self:FindComponent("TargetGrid", UIGrid)
  self.targetListCtrl = UIGridListCtrl.new(grid, TripleTeamPwsTargetCell, "TripleTeamPwsTargetCell")
  self.targetListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function TripleTeamPwsRewardPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdTriplePvpQuestQueryCmd, self.HandleQueryTripleTeamPwsTarget)
end

function TripleTeamPwsRewardPopUp:AddButtonEvts()
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.mask, function()
    self:ClickEmpty()
  end)
end

function TripleTeamPwsRewardPopUp:OnEnter()
  TeamPwsRewardPopUp.super.OnEnter(self)
end

function TripleTeamPwsRewardPopUp:TabChangeHandler(key)
  if self.tab == key then
    return
  end
  self.tab = key
  self.rewardList:SetActive(self.tab == TabEnum.Reward)
  self.targetList:SetActive(self.tab == TabEnum.Target)
  if self.tab == TabEnum.Reward then
    self.listRewards:ResetDatas(self.rewardDatas)
    self:SetButtonState(self.rewardBtnSp, self.rewardBtnLabel, 1)
    self:SetButtonState(self.targetBtnSp, self.targetBtnLabel, 0)
  elseif self.tab == TabEnum.Target then
    self.targetListCtrl:ResetDatas(self.targetDatas)
    self:SetButtonState(self.rewardBtnSp, self.rewardBtnLabel, 0)
    self:SetButtonState(self.targetBtnSp, self.targetBtnLabel, 1)
  end
end

function TripleTeamPwsRewardPopUp:SetButtonState(sp, label, state)
  state = state or 0
  sp.CurrentState = state
  local colStr = state == 1 and SelectCol or UnselectCol
  local _, c = ColorUtil.TryParseHexString(colStr)
  label.color = c
end

function TripleTeamPwsRewardPopUp:HandleQueryTripleTeamPwsTarget()
  self:TabChangeHandler(TabEnum.Reward)
end
