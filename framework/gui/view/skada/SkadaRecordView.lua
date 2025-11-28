autoImport("HeadIconCell")
autoImport("SkadaRecordCell")
autoImport("SkadaHistoryRecordCell")
SkadaRecordView = class("SkadaRecordView", BaseView)
SkadaRecordView.ViewType = UIViewType.NormalLayer
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}
local texName_HistoryTopBG = "Analysis_bg"

function SkadaRecordView:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
  self.playerTipOffset = {-20, 14}
  self.analysisViewData = {}
  self.playerTipInitData = {}
  self.playerTipData = PlayerTipData.new()
end

function SkadaRecordView:FindObjs()
  self:ClearHistoryRankInfos()
  local l_objTopRanksRoot = self:FindGO("TopRanks")
  self.texHistoryTopBG = self:FindComponent("texTopRanksBG", UITexture, l_objTopRanksRoot)
  self.objBtnDeleteHistoty = self:FindGO("BtnDeleteHistory", l_objTopRanksRoot)
  self.arrTopRanks = {}
  local singleRankRoot
  for i = 1, 3 do
    singleRankRoot = self:FindGO("Rank" .. i, l_objTopRanksRoot)
    if not singleRankRoot then
      LogUtility.Error("Cannot Find Rank" .. i)
    end
    self.arrTopRanks[i] = SkadaHistoryRecordCell.new(singleRankRoot)
  end
  local l_objRankListRoot = self:FindGO("TodayRanksList")
  self.objNoneTip = self:FindGO("NoneTip", l_objRankListRoot)
  self.objBtnDeleteRank = self:FindGO("BtnDeleteRank", l_objRankListRoot)
  self.listRecords = WrapListCtrl.new(self:FindGO("recordsContainer", l_objRankListRoot), SkadaRecordCell, "SkadaRecordCell", WrapListCtrl_Dir.Vertical)
end

function SkadaRecordView:AddButtonEvt()
  local help_go = self:FindGO("BtnHelp")
  self:RegistShowGeneralHelpByHelpID(PanelConfig.SkadaRecordView.id, help_go)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.objBtnDeleteHistoty, function()
    self:ClickClearRecord(2)
  end)
  self:AddClickEvent(self.objBtnDeleteRank, function()
    self:ClickClearRecord(1)
  end)
end

function SkadaRecordView:AddViewEvt()
  self.listRecords:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
  self.listRecords:AddEventListener(SkadaRecordCell.ClickDetail, self.ClickCellDetail, self)
  for i = 1, #self.arrTopRanks do
    self.arrTopRanks[i]:AddEventListener(MouseEvent.MouseClick, self.ClickHistoryRankHead, self)
  end
end

function SkadaRecordView:HandleQuerySkadaDataHomeCCmd()
  local historyRankDatas = HomeProxy.Instance:GetSkadaHistoryMax()
  for i = 1, #self.arrTopRanks do
    self.arrTopRanks[i]:SetData(historyRankDatas[i])
  end
  local todayRankDatas = HomeProxy.Instance:GetSkadaTodayMax()
  self.objNoneTip:SetActive(#todayRankDatas < 1)
  self.listRecords:ResetDatas(todayRankDatas)
  self.listRecords:ResetPosition()
end

function SkadaRecordView:ClickClearRecord(clearType)
  MsgManager.ConfirmMsgByID(40540, function()
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodClear, self.myFurnitureID, clearType)
  end)
end

function SkadaRecordView:ClickHistoryRankHead(cellCtl)
  self:ShowPlayerTip(cellCtl, cellCtl.headIcon.frameSp)
end

function SkadaRecordView:ClickCellHead(cellCtl)
  self:ShowPlayerTip(cellCtl, cellCtl.widgetTipPos)
end

function SkadaRecordView:ShowPlayerTip(clickedCell, widget)
  if clickedCell == self.curCell or clickedCell.data.charid == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = clickedCell
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(widget, NGUIUtil.AnchorSide.TopRight, self.playerTipOffset)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipData:SetByDamageUserData(clickedCell.data)
  self.playerTipInitData.playerData = self.playerTipData
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(self.playerTipData.id) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(widget.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:CloseSelf()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function SkadaRecordView:ClickCellDetail(cellCtl)
  TableUtility.TableClear(self.analysisViewData)
  self.analysisViewData.skadaData = cellCtl.data
  self.analysisViewData.furnitureID = self.myFurnitureID
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SkadaAnalysisPopup,
    viewdata = self.analysisViewData
  })
end

function SkadaRecordView:ClearHistoryRankInfos()
  if not self.arrTopRanks then
    return
  end
  for index, topRank in pairs(self.arrTopRanks) do
    topRank:OnCellDestroy()
  end
  self.arrTopRanks = nil
end

function SkadaRecordView:OnEnter()
  SkadaRecordView.super.OnEnter(self)
  EventManager.Me():AddEventListener(HomeEvent.QuerySkadaData, self.HandleQuerySkadaDataHomeCCmd, self)
  PictureManager.Instance:SetHome(texName_HistoryTopBG, self.texHistoryTopBG)
  local isMyHome = HomeManager.Me():IsAtMyselfHome() == true
  self.objBtnDeleteRank:SetActive(isMyHome)
  self.objBtnDeleteHistoty:SetActive(isMyHome)
  self.myNpcID = self.viewdata and self.viewdata.viewdata
  local nCreature = self.myNpcID and NSceneNpcProxy.Instance:Find(self.myNpcID)
  self.myFurnitureID = nCreature and nCreature.data:GetRelativeFurnitureID()
  if not self.myFurnitureID then
    LogUtility.Error(string.format("没有找到npcid: %s的对应家具ID！", tostring(self.myNpcID)))
    self:CloseSelf()
    return
  end
  EventManager.Me():DispatchEvent(HomeEvent.SkadaRecordOver, self.myNpcID)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodOver, self.myFurnitureID)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodQuery, self.myFurnitureID)
end

function SkadaRecordView:OnExit()
  PictureManager.Instance:UnLoadHome(texName_HistoryTopBG, self.texHistoryTopBG)
  EventManager.Me():RemoveEventListener(HomeEvent.QuerySkadaData, self.HandleQuerySkadaDataHomeCCmd, self)
  SkadaRecordView.super.OnExit(self)
end

function SkadaRecordView:OnDestroy()
  self:ClearHistoryRankInfos()
  self.listRecords:Destroy()
  SkadaRecordView.super.OnDestroy(self)
end
