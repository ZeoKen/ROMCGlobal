autoImport("WrapTagListCtrl")
autoImport("GuestVisitDataCombineCell")
MessageBoardTracePage = class("MessageBoardTracePage", SubView)
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
MessageBoardTracePage.SelectHead = "MessageBoardTraceEvent_SelectHead"

function MessageBoardTracePage:Init()
  self:InitTagDatas()
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function MessageBoardTracePage:InitTagDatas()
  self.dateListTags = {}
  local msgData = MessageBoardProxy.Instance:GetGuestTraceList()
  for i = 1, #msgData do
    local single = msgData[i]
    self.dateListTags[#self.dateListTags + 1] = {
      dataList = single.dataList,
      time = single.time
    }
  end
end

function MessageBoardTracePage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdEventItemQueryHomeCmd, self.UpdateGuestTraces)
end

function MessageBoardTracePage:AddEvts()
  self:TryOpenHelpViewById(8000004, nil, self:FindGO("BtnHelp"))
  self:AddClickEvent(self.leftIndicator, function()
    self:ClickLeftIndicator()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:ClickRightIndicator()
  end)
  self.traceListCtrl:AddEventListener(MessageBoardTracePage.SelectHead, self.HandleClickHead, self)
end

function MessageBoardTracePage:InitUI()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  if not self.furniture then
    LogUtility.Error("Cannot get furniture when initializing MessageTipPage!")
  end
  self.gameObject = self:FindGO("MessageBoardTracePage")
  local totalVisit = self:FindGO("TotalVisitNum")
  self.totalVisitNum = self:FindGO("labTotalScore", totalVisit):GetComponent(UILabel)
  local todayVisit = self:FindGO("TodayVisitNum")
  self.todayVisitNum = self:FindGO("labTodayScore", todayVisit):GetComponent(UILabel)
  self.pageNumText = self:FindGO("PageLabel"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.tip.text = ZhString.MessageBoardView_TraceTip
  local pageCtrl = self:FindGO("PageCtrl")
  self.leftIndicator = self:FindGO("LeftIndicator", pageCtrl)
  self.leftIndicatorIcon = self.leftIndicator:GetComponent(UISprite)
  self.leftIndicatorCollider = self.leftIndicator:GetComponent(BoxCollider)
  self.rightIndicator = self:FindGO("RightIndicator", pageCtrl)
  self.rightIndicatorIcon = self.rightIndicator:GetComponent(UISprite)
  self.rightIndicatorCollider = self.rightIndicator:GetComponent(BoxCollider)
  self.noneTip = self:FindGO("NoneTip")
  self.traceListCtrl = WrapTagListCtrl.new(self:FindGO("VisitDataWrap"), GuestVisitDataCombineCell, "GuestVisitDataCombineCell", WrapListCtrl_Dir.Vertical)
  self.curPage = 1
  self.totalCount = 0
  self.visitCount = 0
  self.dayVisitCount = 0
  self.totalVisitNum.text = self.visitCount
  self.todayVisitNum.text = self.dayVisitCount
  self.tipData = {}
end

function MessageBoardTracePage:InitView()
  helplog("MessageBoardTracePage：InitView")
  self:RefreshIndicator()
  self.traceListCtrl:SetTagList(self.dateListTags, self.GetItemDataByTag, self)
end

function MessageBoardTracePage:GetItemDataByTag(tagData)
  helplog("TagData's datalist Length", #tagData.dataList)
  return tagData.dataList
end

function MessageBoardTracePage:OnSwitch(isOpen)
  helplog("MessageBoardTracePage:OnSwitch")
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_EVENT_QUERY, self.furniture.data.id, 0)
end

function MessageBoardTracePage:UpdateGuestTraces()
  self:InitTagDatas()
  self:UpdateInfos()
  self.traceListCtrl:SetTagList(self.dateListTags, self.GetItemDataByTag, self)
  self.traceListCtrl:UpdateList(true)
  self:RefreshIndicator()
end

function MessageBoardTracePage:UpdateInfos()
  self.curPage = MessageBoardProxy.Instance.curPage + 1
  self.totalCount = MessageBoardProxy.Instance.totalCount
  self.visitCount = MessageBoardProxy.Instance.visitCount
  self.dayVisitCount = MessageBoardProxy.Instance.dayVisitCount
  helplog(self.curPage, self.totalCount, self.visitCount, self.dayVisitCount)
  self.totalVisitNum.text = self.visitCount
  self.todayVisitNum.text = self.dayVisitCount
end

function MessageBoardTracePage:RefreshIndicator()
  helplog("RefreshIndicator")
  local refreshNum = GameConfig.Home.homeMsgBoard.RefreshNum or 50
  local maxPage = math.ceil(self.totalCount / refreshNum)
  if maxPage == 0 then
    maxPage = 1
  end
  if self.curPage == 1 then
    self.leftIndicatorIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
    self.leftIndicatorCollider.enabled = false
  else
    self.leftIndicatorIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.leftIndicatorCollider.enabled = true
  end
  if self.curPage == maxPage then
    self.rightIndicatorIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
    self.rightIndicatorCollider.enabled = false
  else
    self.rightIndicatorIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.rightIndicatorCollider.enabled = true
  end
  local str = self.curPage .. "/" .. maxPage
  self.pageNumText.text = str
end

function MessageBoardTracePage:ClickLeftIndicator()
  local targetPage = self.curPage - 1
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_EVENT_QUERY, self.furniture.data.id, targetPage - 1)
end

function MessageBoardTracePage:ClickRightIndicator()
  local targetPage = self.curPage + 1
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_EVENT_QUERY, self.furniture.data.id, targetPage - 1)
end

function MessageBoardTracePage:HandleClickHead(cellctl)
  local data = cellctl.data
  if data.guid == Game.Myself.data.id then
    return
  end
  local charid = data.user.charid
  if not charid or charid == 0 then
    redlog("该玩家charid不存在！")
  end
  local playerData = PlayerTipData.new()
  playerData:SetByGuestVisitData(cellctl.data.user)
  self.funckeys = FriendProxy.Instance:IsFriend(charid) and playerTipFunc_Friend or playerTipFunc
  FunctionPlayerTip.Me():CloseTip()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellctl.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60})
  TableUtility.TableClear(self.tipData)
  self.tipData.playerData = playerData
  self.tipData.funckeys = self.funckeys
  playerTip:SetData(self.tipData)
end

function MessageBoardTracePage:OnEnter()
  MessageBoardTracePage.super.OnEnter(self)
end

function MessageBoardTracePage:OnExit()
  MessageBoardTracePage.super.OnExit(self)
end
