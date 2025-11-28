autoImport("TeamPwsRewardCell")
TeamPwsRewardPopUp = class("TeamPwsRewardPopUp", BaseView)
TeamPwsRewardPopUp.ViewType = UIViewType.PopUpLayer

function TeamPwsRewardPopUp:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.proxy = viewdata and viewdata.proxy or CupMode6v6Proxy.Instance
  self.rewardDatas = {}
  self:FindObjs()
  self:InitList()
  self:AddViewEvts()
  self:AddButtonEvts()
end

function TeamPwsRewardPopUp:FindObjs()
  self.labMyName = self:FindComponent("labMyName", UILabel)
  self.labMyScore = self:FindComponent("labMyScore", UILabel)
  self.labMyRank = self:FindComponent("labMyRank", UILabel)
  self.sprMyLevel = self:FindComponent("sprMyLevel", UISprite)
  self.emptyTipGO = self:FindGO("EmptyTip")
  self.emptyTipLabel = self.emptyTipGO:GetComponent(UILabel)
  self.emptyTipLabel.text = ZhString.CupMode_NotOpen
end

function TeamPwsRewardPopUp:InitList()
  self.listRewards = UIGridListCtrl.new(self:FindComponent("rewardContainer", UIGrid), TeamPwsRewardCell, "TeamPwsRewardCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function TeamPwsRewardPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
end

function TeamPwsRewardPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:ClickEmpty()
  end)
  self:AddClickEvent(self:FindGO("FindNpcButton"), function()
    local useless, config = next(GameConfig.PvpTeamRaid)
    FuncShortCutFunc.Me():CallByID(config.RewardNpcShortCut)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChasingViewLayer)
    self:CloseSelf()
  end)
end

function TeamPwsRewardPopUp:HandleQueryTeamPwsTeamInfo(note)
  local curSeason = self.proxy.season
  if not curSeason then
    local teamInfoData = note.body
    curSeason = teamInfoData and teamInfoData.season
  end
  if not curSeason then
    self.emptyTipGO:SetActive(true)
    return
  end
  self.emptyTipGO:SetActive(false)
  TableUtility.TableClear(self.rewardDatas)
  if Table_TeamPwsRewards then
    for id, data in pairs(Table_TeamPwsRewards) do
      if data.Season == curSeason then
        self.rewardDatas[#self.rewardDatas + 1] = data
      end
    end
    table.sort(self.rewardDatas, function(l, r)
      return l.id < r.id
    end)
  end
  self.listRewards:ResetDatas(self.rewardDatas)
  if #self.rewardDatas == 0 then
    self.emptyTipGO:SetActive(true)
  end
end

function TeamPwsRewardPopUp:ClickItem(item)
  local tab = ReusableTable.CreateTable()
  tab.itemdata = item.data
  
  function tab.callback()
    self.itemTipShow = false
  end
  
  self:ShowItemTip(tab, item.icon, NGUIUtil.AnchorSide.Left, {-168, -28})
  ReusableTable.DestroyAndClearTable(tab)
  self.itemTipShow = true
end

function TeamPwsRewardPopUp:ClickEmpty()
  if self.itemTipShow then
    self:ShowItemTip()
    self.itemTipShow = false
  else
    self:CloseSelf()
  end
end

function TeamPwsRewardPopUp:OnEnter()
  TeamPwsRewardPopUp.super.OnEnter(self)
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
end

function TeamPwsRewardPopUp:OnExit()
  TeamPwsRewardPopUp.super.OnExit(self)
end
