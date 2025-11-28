MessageTipPage = class("MessageTipPage", SubView)
autoImport("UIGridListCtrl")
autoImport("MessageBoardCell")
autoImport("MessageCell")

function MessageTipPage:Init()
  self:InitUI()
  self:InitData()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
  self:MapEvent()
end

function MessageTipPage:InitUI()
  self.gameObject = self:FindGO("MessageTipPage")
  self.editOwnerMsgBtn = self:FindGO("BtnEditOwnerMsg")
  self.inputOwnerMsg = self:FindComponent("OwnerMsg", UIInput)
  local messagePanel = self:FindGO("MessagePanel")
  self.leaveMsgBtn = self:FindGO("LeaveMessageBtn", messagePanel)
  self.batchManageBtn = self:FindGO("BatchManageBtn", messagePanel)
  self.delBtn = self:FindGO("DeleteBtn", messagePanel)
  self.cancelBtn = self:FindGO("CancelBtn", messagePanel)
  self.delBtn.gameObject:SetActive(false)
  self.cancelBtn.gameObject:SetActive(false)
  self.leftIndicator = self:FindGO("leftIndicator", messagePanel)
  self.rightIndicator = self:FindGO("rightIndicator", messagePanel)
  self.chooseAll = self:FindGO("chooseAll", messagePanel)
  self.chooseAllTog = self:FindComponent("checkBoxBg", UIToggle)
  self.chooseAll.gameObject:SetActive(false)
  self.messageNumLabel = self:FindGO("MessageNumLabel"):GetComponent(UILabel)
  self.grid = self:FindComponent("MessageContainer", UIGrid)
  self.messageList = UIGridListCtrl.new(self.grid, MessageBoardCell, "MessageBoardCell")
  self.messageList:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.messageDetail = self:FindGO("MessageDetail")
  self.messageDetail.gameObject:SetActive(false)
  self.gridGo = self:FindGO("DetailBtnGrid", self.messageDetail)
  self.detailBtnGrid = self:FindComponent("DetailBtnGrid", UIGrid)
  self.sendBtn = self:FindGO("SendBtn", self.gridGo)
  self.deleteThisMsgBtn = self:FindGO("DeleteBtn", self.gridGo)
  self.closeDetailBtn = self:FindGO("CloseDetailBtn", self.messageDetail)
  self.messageGrid = self:FindGO("MessageGrid", self.messageDetail)
  self.messageTable = self.messageGrid:GetComponent(UITable)
  self.inputMessage = self:FindComponent("NewMessage", UIInput)
  self.editMessageBtn = self:FindGO("EditMessageBtn")
  self.messageTextList = UIGridListCtrl.new(self.messageTable, MessageCell, "MessageCell")
  
  function self.inputOwnerMsg.label.onChange()
    self.messageTable:Reposition()
  end
  
  self.editMode = false
  self.curPageNum = 0
  self.currentMsgNum = 0
  self.totalPageNum = 1
  self.curHouseData = HomeProxy.Instance:GetCurHouseData()
end

function MessageTipPage:InitData()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  if not self.furniture then
    LogUtility.Error("Cannot get furniture when initializing MessageTipPage!")
  end
end

function MessageTipPage:AddEvts()
  self:TryOpenHelpViewById(8000003, nil, self:FindGO("BtnHelp"))
  self:AddClickEvent(self.closeDetailBtn, function()
    self:CloseDetailPanel()
  end)
  self:AddClickEvent(self.editOwnerMsgBtn, function(go)
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_HOME) then
      return
    end
    self.inputOwnerMsg.isSelected = not self.inputOwnerMsg.isSelected
  end)
  self:AddSelectEvent(self.inputOwnerMsg, function(go, state)
    if state then
      return
    end
    if self.curHouseData and self.curHouseData.ownerMsg ~= self.inputOwnerMsg.value then
      self:SetOwnerMessage()
    end
  end)
  self:AddClickEvent(self.leftIndicator, function()
    self:ClickLeftIndicator()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:ClickRightIndicator()
  end)
  self:AddButtonEvent("chooseAll", function()
    self.chooseAllTog.value = not self.chooseAllTog.value
    local cells = self.messageList:GetCells()
    for i = 1, #cells do
      cells[i]:SetToggleValue(self.chooseAllTog.value)
    end
  end)
  self:AddClickEvent(self.batchManageBtn, function()
    self.editMode = true
    self.leaveMsgBtn.gameObject:SetActive(false)
    self.delBtn.gameObject:SetActive(true)
    self.cancelBtn.gameObject:SetActive(true)
    self.batchManageBtn.gameObject:SetActive(false)
    self.chooseAll.gameObject:SetActive(true)
    self.leftIndicator.gameObject:SetActive(false)
    self.rightIndicator.gameObject:SetActive(false)
    local cells = self.messageList:GetCells()
    for i = 1, #cells do
      cells[i]:SetCheckBoxShown(true)
    end
  end)
  self:AddClickEvent(self.leaveMsgBtn, function()
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_HOME) then
      return
    end
    self:showDetailPanel()
  end)
  self:AddClickEvent(self.editMessageBtn, function()
    if not self.validStatus then
      redlog("屏蔽中")
      MsgManager.ShowMsgByIDTable(40571)
      return
    else
      helplog("未屏蔽，正常使用")
    end
    self.inputMessage.isSelected = not self.inputMessage.isSelected
  end)
  self:AddClickEvent(self.delBtn, function()
    MsgManager.ConfirmMsgByID(40575, function()
      local tempArray = {}
      local cells = self.messageList:GetCells()
      for i = 1, #cells do
        local single = cells[i]
        if single.checkbox.value == true then
          table.insert(tempArray, single.time)
        end
      end
      redlog("申请批量删除")
      ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.DelMessage, self.furniture.data.id, nil, nil, nil, tempArray)
    end)
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self.editMode = false
    self.leaveMsgBtn.gameObject:SetActive(true)
    self.delBtn.gameObject:SetActive(false)
    self.cancelBtn.gameObject:SetActive(false)
    self.batchManageBtn.gameObject:SetActive(true)
    self.chooseAll.gameObject:SetActive(false)
    self:RefreshIndicator()
    self.chooseAllTog.value = false
    local cells = self.messageList:GetCells()
    for i = 1, #cells do
      cells[i]:SetCheckBoxShown(false)
    end
  end)
  self:AddClickEvent(self.sendBtn, function()
    if not self.validStatus then
      helplog("屏蔽功能")
      MsgManager.ShowMsgByIDTable(40570)
      return
    else
      helplog("未屏蔽")
    end
    local str = self.inputMessage.value
    local time
    if self.curCell then
      time = self.curCell.data.time
    else
      redlog("请求新增纸片消息")
      time = nil
    end
    helplog("输入内容", str, "时间戳", time)
    local sendMsgSuccess = self:leaveMessage()
    if sendMsgSuccess then
      ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.AddMessage, self.furniture.data.id, time, nil, str, nil)
      self:CloseDetailPanel()
    end
  end)
  self:AddClickEvent(self.deleteThisMsgBtn, function()
    redlog("申请删除一条")
    MsgManager.ConfirmMsgByID(40573, function()
      local times = {}
      table.insert(times, self.curCell.time)
      ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.DelMessage, self.furniture.data.id, nil, nil, nil, times)
      self:CloseDetailPanel()
    end)
  end)
  EventDelegate.Add(self.inputMessage.onChange, function()
    local str = self.inputMessage.value
    local length = StringUtil.Utf8len(str)
    if length > GameConfig.Home.homeMsgBoard.ReplyWords_max then
      self.inputMessage.value = StringUtil.getTextByIndex(str, 1, GameConfig.Home.homeMsgBoard.ReplyWords_max)
      MsgManager.ShowMsgByID(28010)
    end
  end)
end

function MessageTipPage:AddViewEvts()
  self:AddListenEvt(MouseEvent.MouseClick, self.ClickItem)
  self:AddListenEvt(ServiceEvent.HomeCmdOptUpdateHomeCmd, self.UpdateHomeInfo)
  self:AddListenEvt(ServiceEvent.HomeCmdOptUpdateHomeCmd, self.CheckAvailableUpdate)
end

function MessageTipPage:InitView()
  self:UpdateBtns()
  self:RefreshIndicator()
end

function MessageTipPage:MapEvent()
  self:AddListenEvt(ServiceEvent.HomeCmdBoardItemQueryHomeCmd, self.UpdateMessageTipList)
  self:AddListenEvt(ServiceEvent.HomeCmdBoardItemUpdateHomeCmd, self.RecvBoardItemUpdateCmd)
  self:AddListenEvt(ServiceEvent.HomeCmdBoardMsgUpdateHomeCmd, self.RecvBoardMsgUpdateCmd)
end

function MessageTipPage:OnSwitch()
  self:UpdateHomeInfo()
  helplog("MessageTipPage:OnSwitch,furniture id ", self.furniture.data.id)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, 0)
end

function MessageTipPage:CheckAvailableUpdate(data)
  if data.body.data == BaseHouseData.HouseOptType.BoardOpen then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, 0)
  end
end

function MessageTipPage:UpdateBtns()
  local houseData = HomeProxy.Instance:GetCurHouseData()
  if HomeManager.Me():IsAtMyselfHome() then
    self.editOwnerMsgBtn.gameObject:SetActive(true)
    self.batchManageBtn.gameObject:SetActive(true)
    self.deleteThisMsgBtn.gameObject:SetActive(true)
    self.detailBtnGrid:Reposition()
  else
    self.editOwnerMsgBtn.gameObject:SetActive(false)
    self.batchManageBtn.gameObject:SetActive(false)
    self.deleteThisMsgBtn.gameObject:SetActive(false)
    self.detailBtnGrid:Reposition()
  end
end

function MessageTipPage:ClickLeftIndicator()
  local targetPage = self.curPageNum - 1
  helplog("targetPage:", targetPage)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, targetPage)
end

function MessageTipPage:ClickRightIndicator()
  local targetPage = self.curPageNum + 1
  helplog("targetPage:", targetPage)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, targetPage)
end

function MessageTipPage:ClickItem(cell)
  helplog("ClickItem")
  self.curCell = cell
  self.msgDetailData = cell.data
  self:showDetailPanel(self.msgDetailData)
end

function MessageTipPage:UpdateHomeInfo()
  helplog("UpdateHomeInfo")
  local houseData = HomeProxy.Instance:GetCurHouseData()
  self.inputOwnerMsg.value = houseData.ownerMsg
end

function MessageTipPage:UpdateMessageTipList()
  if self.messageDetail.gameObject.activeInHierarchy then
    self.messageDetail.gameObject:SetActive(false)
  end
  self.validStatus = MessageBoardProxy.Instance:GetValidStatus()
  local messageTipList = MessageBoardProxy.Instance:GetMessageTipList()
  self.currentMsgNum = MessageBoardProxy.Instance:GetMessageCount()
  self.curPageNum = MessageBoardProxy.Instance:GetPageNum()
  self.messageNumLabel.text = string.format(ZhString.MessageBoardView_MessageNum, self.currentMsgNum)
  helplog("获取到的总消息数量和当前页数", self.currentMsgNum, self.curPageNum)
  self.messageList:ResetDatas(messageTipList)
  local cells = self.messageList:GetCells()
  for i = 1, #cells do
    cells[i]:SetCheckBoxShown(self.editMode)
  end
  self:RefreshIndicator()
end

function MessageTipPage:RecvBoardItemUpdateCmd(data)
  if self.messageDetail.gameObject.activeInHierarchy then
    self.messageDetail.gameObject:SetActive(false)
  end
  local serverDatas = data.body
  if self.msgDetailData ~= nil and serverDatas.dels and #serverDatas.dels > 0 then
    for i = 1, #serverDatas.dels do
      if serverDatas.dels[i] == self.msgDetailData.time then
        MsgManager.ShowMsgByIDTable(40574)
      end
    end
  end
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, self.curPageNum)
end

function MessageTipPage:RecvBoardMsgUpdateCmd()
  if self.messageDetail.gameObject.activeInHierarchy then
    self.messageDetail.gameObject:SetActive(false)
  end
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_BOARD_QUERY, self.furniture.data.id, self.curPageNum)
end

function MessageTipPage:RefreshIndicator()
  local pageNum = math.ceil(self.currentMsgNum / 18)
  if pageNum == 0 then
    pageNum = 1
  end
  self.totalPageNum = pageNum
  helplog("页数相关", self.totalPageNum, pageNum)
  if 1 < self.curPageNum + 1 then
    self.leftIndicator.gameObject:SetActive(true)
  else
    self.leftIndicator.gameObject:SetActive(false)
  end
  if self.curPageNum + 1 < self.totalPageNum then
    self.rightIndicator.gameObject:SetActive(true)
  else
    self.rightIndicator.gameObject:SetActive(false)
  end
end

function MessageTipPage:showDetailPanel(data)
  if data then
    self.messageDetail.gameObject:SetActive(true)
    local messages = data.items
    helplog(#messages)
    local result = {}
    for i = #messages, 1, -1 do
      local single = messages[i]
      table.insert(result, single)
    end
    self.messageTextList:ResetDatas(result)
    if HomeManager.Me():IsAtMyselfHome() then
      self.deleteThisMsgBtn.gameObject:SetActive(true)
    else
      self.deleteThisMsgBtn.gameObject:SetActive(false)
    end
    self.detailBtnGrid:Reposition()
  else
    self.curCell = nil
    self.msgDetailData = nil
    self.messageDetail.gameObject:SetActive(true)
    self.messageTextList:ResetDatas()
    self.deleteThisMsgBtn.gameObject:SetActive(false)
    self.detailBtnGrid:Reposition()
    redlog("Create a new MessageTip")
  end
  self.messageTable:Reposition()
end

function MessageTipPage:CloseDetailPanel()
  self.msgDetailData = nil
  self.messageDetail.gameObject:SetActive(false)
  local str = ""
  self.inputMessage.value = str
end

function MessageTipPage:SetOwnerMessage()
  local name = self.inputOwnerMsg.value
  if name == "" then
    MsgManager.ShowMsgByIDTable(40550)
    self.inputOwnerMsg.value = self.curHouseData and self.curHouseData.ownerMsg or ""
    return
  end
  local length = StringUtil.Utf8len(name)
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(40551)
    self.inputOwnerMsg.label.color = ColorUtil.NGUILabelRed
    return
  end
  if length > GameConfig.System.homesign_max then
    MsgManager.ShowMsgByIDTable(40552, {
      GameConfig.System.homesign_max
    })
    name = StringUtil.getTextByIndex(name, 1, GameConfig.System.homesign_max)
    self.inputOwnerMsg.value = name
  end
  helplog("CallOptUpdateHomeCmd", name)
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.OwnerMsg, nil, nil, name)
end

function MessageTipPage:leaveMessage()
  local msg = self.inputMessage.value
  if msg == "" then
    MsgManager.ShowMsgByIDTable(40550)
    self.inputMessage.value = ""
    return false
  end
  local length = StringUtil.Utf8len(msg)
  if FunctionMaskWord.Me():CheckMaskWord(msg, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(40551)
    self.inputMessage.label.color = ColorUtil.NGUILabelRed
    return false
  end
  if length > GameConfig.Home.homeMsgBoard.ReplyWords_max then
    MsgManager.ShowMsgByIDTable(40553, {
      GameConfig.Home.homeMsgBoard.ReplyWords_max
    })
    msg = StringUtil.getTextByIndex(msg, 1, GameConfig.Home.homeMsgBoard.ReplyWords_max)
    self.inputMessage.value = msg
    return false
  end
  if self.msgDetailData ~= nil then
    helplog("self.msgDetailData.num", #self.msgDetailData.items)
    if #self.msgDetailData.items >= GameConfig.Home.homeMsgBoard.ReplyNum_max then
      redlog("数量超过限制")
      MsgManager.ShowMsgByIDTable(40554)
      return false
    end
  end
  return true
end
