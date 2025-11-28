TransferFightRankPopUp = class("TransferFightRankPopUp", BaseView)
autoImport("TransferFightRankCell")
TransferFightRankPopUp.ViewType = UIViewType.NormalLayer

function TransferFightRankPopUp:Init()
  self:FindObjs()
  self:AddButtonEvts()
  self:AddViewEvts()
  self:UpdateList()
end

function TransferFightRankPopUp:FindObjs()
  local myScore = self:FindGO("MyScore")
  self.myScore = self:FindComponent("labScore", UILabel, myScore)
  local objRank = self:FindGO("labRank", myScore)
  local objIcon = self:FindGO("sprRankBG", objRank)
  self.myRank = {
    gameObject = objRank,
    label = objRank:GetComponent(UILabel),
    objBG = objIcon,
    sprBG = objIcon:GetComponent(UISprite)
  }
  self.myName = self:FindComponent("labName", UILabel, myScore)
  self.leftTime = self:FindGO("labLeftTime"):GetComponent(UILabel)
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, TransferFightRankCell, "TransferFightRankCell")
end

function TransferFightRankPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:ClickButtonLeave()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave"), function()
    self:ClickButtonLeave()
  end)
end

function TransferFightRankPopUp:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
end

function TransferFightRankPopUp:ClickButtonLeave()
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
  self:CloseSelf()
end

function TransferFightRankPopUp:HandleLoadScene()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    self:CloseSelf()
  end
end

function TransferFightRankPopUp:UpdateList()
  self.tickMg = TimeTickManager.Me()
  local viewdata = PvpProxy.Instance:GetTransferFightResult()
  if viewdata ~= nil then
    local ranks = viewdata.rank
    self.listReports:ResetDatas(ranks)
    self.myScore.text = viewdata.myScore
    self.myRank.label.text = viewdata.myRank
    if viewdata.myRank and viewdata.myRank < 4 then
      self.myRank.label.enabled = false
      self.myRank.sprBG.enabled = true
      self.myRank.sprBG.spriteName = "Guild_icon_NO" .. viewdata.myRank
    else
      self.myRank.label.enabled = true
      self.myRank.sprBG.enabled = false
    end
    self.myName.text = Game.Myself.data:GetName() or "-"
    self.starttime = ServerTime.CurServerTime() / 1000
    self.tickMg:ClearTick(self)
    self.tickMg:CreateTick(0, 500, self.updateCountDownTime, self)
  end
end

function TransferFightRankPopUp:updateCountDownTime()
  local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
  local leftTime = 20
  if pastTime >= leftTime then
    self.tickMg:ClearTick(self)
  end
  leftTime = leftTime - pastTime
  if leftTime < 0 then
    leftTime = 0
  end
  leftTime = math.floor(leftTime)
  local m = math.floor(leftTime / 60)
  local sd = leftTime - m * 60
  local leftTimeStr = string.format("%02d:%02d", m, sd)
  self.leftTime.text = leftTimeStr .. ZhString.ActivityData_Finish
end

function TransferFightRankPopUp:OnExit()
  self.tickMg:ClearTick(self)
  TransferFightRankPopUp.super.OnExit(self)
end
