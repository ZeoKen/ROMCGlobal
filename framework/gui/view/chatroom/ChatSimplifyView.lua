ChatSimplifyView = class("ChatSimplifyView", SubView)
local dotNormal = Color(1, 1, 1, 0.5)
local tempV3 = LuaVector3.Zero()
local tempV2 = LuaVector2.Zero()

function ChatSimplifyView:OnExit()
  self.chatCenterOnChild.onCenter = nil
  self.scrollView.onStoppedMoving = nil
  self.panel.onClipMove = nil
end

function ChatSimplifyView:Init(initParama)
  self.gameObject = initParama.gameObject
  self:FindObj()
  self:AddEvt()
  self:AddViewEvt()
  self:InitShow(initParama)
end

function ChatSimplifyView:FindObj()
  local go = self:FindGO("ChatGrid")
  self.chatGrid = go:GetComponent(UIGrid)
  self.chatCenterOnChild = go:GetComponent(UICenterOnChild)
  self.scrollViewGo = self:FindGO("ChatScrollView")
  self.scrollView = self.scrollViewGo:GetComponent(UIScrollView)
  self.panel = self.scrollViewGo:GetComponent(UIPanel)
end

function ChatSimplifyView:AddEvt()
  function self.chatCenterOnChild.onCenter(centeredObject)
    self:CenterOnDot(centeredObject)
  end
  
  function self.scrollView.onStoppedMoving()
    self.canSpring = true
  end
  
  function self.panel.onClipMove(panel)
    if self.canSpring == false then
      return
    end
    local config = GameConfig.ChatRoom.MainView
    self.startChannel = config[1]
    local endChannel = config[#config]
    local springChannel = ChatRoomProxy.Instance:GetScrollScreenChannel()
    if springChannel ~= nil and springChannel ~= self.startChannel and springChannel ~= endChannel then
      return
    end
    local currentTouch = UICamera.currentTouch
    if currentTouch == nil then
      return
    end
    local totalDelta = currentTouch.totalDelta.x
    local nextPageThreshold = self.chatCenterOnChild.nextPageThreshold
    if nextPageThreshold >= math.abs(totalDelta) then
      return
    end
    if springChannel == self.startChannel and totalDelta > nextPageThreshold then
      self:SpringToChannel(endChannel)
    elseif springChannel == endChannel and totalDelta < -nextPageThreshold then
      self:SpringToChannel(self.startChannel)
    end
  end
end

function ChatSimplifyView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd, self.UpdateChatRoom)
  self:AddListenEvt(ChatRoomEvent.ChangeChannel, self.ChangeChannel)
  self:AddListenEvt(ChatRoomEvent.SystemMessage, self.UpdateChatRoom)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnLeaveChatRoomCmd, self.HandleCloseReturnChatChannel)
  self:AddListenEvt(GuildEvent.EnterMercenary, self.HandleGVG)
  self:AddListenEvt(GuildEvent.ExitMercenary, self.HandleGVG)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGVG)
end

function ChatSimplifyView:InitShow(initParama)
  self.list = {}
  self.chatDotList = {}
  local config = GameConfig.ChatRoom.MainView
  self.startChannel = config[1]
  self.maxOffset = (#config - 1) * self.chatGrid.cellWidth
  local clipOffset = self.panel.clipOffset
  LuaVector2.Better_Set(tempV2, clipOffset.x, clipOffset.y)
  self.chatCtl = UIGridListCtrl.new(self.chatGrid, initParama.chatCellCtrl, initParama.chatCellPfb)
  self:UpdateChat()
  self.dotTable = self:FindGO("DotTable"):GetComponent(UITable)
  local dotAll = self:FindGO("ChatDotCell1"):GetComponent(UISprite)
  self.chatDotList[ChatChannelEnum.All] = dotAll
  for i = 2, #config do
    local name = "ChatDotCell"
    local dot = self:LoadCellPfb(name, name .. i, self.dotTable.gameObject)
    local dotSprite = dot:GetComponent(UISprite)
    self.chatDotList[config[i]] = dotSprite
  end
  if not self:IsShowGVG() then
    self.chatDotList[ChatChannelEnum.GVG].gameObject:SetActive(false)
  end
  self.dotTable:Reposition()
  ColorUtil.WhiteUIWidget(dotAll)
  self.lastDotSp = dotAll
end

function ChatSimplifyView:CenterOnDot(centeredObject)
  self.lastDotSp.color = dotNormal
  for i = 1, #self.chatCtl:GetCells() do
    local cell = self.chatCtl:GetCells()[i]
    if cell.gameObject == centeredObject then
      local dot = self.chatDotList[cell.data]
      ColorUtil.WhiteUIWidget(dot)
      self.lastDotSp = dot
      ChatRoomProxy.Instance:SetCurrentChatChannel(cell.data)
      if cell.data == self.startChannel then
        cell:Update()
      end
      return
    end
  end
end

function ChatSimplifyView:SpringToChannel(channel)
  local cell = self:GetCellByChannel(channel)
  if cell then
    self.canSpring = false
    local trans = cell.trans
    LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalPosition(trans))
    LuaVector2.Better_Set(tempV2, tempV3[1], tempV2[2])
    self.panel.clipOffset = tempV2
    LuaVector3.Better_Set(tempV3, tempV3[1] * -1, tempV3[2], tempV3[3])
    self.panel.transform.localPosition = tempV3
    SpringPanel.Begin(self.scrollViewGo, tempV3, 1)
    self:CenterOnDot(cell.gameObject)
  end
end

function ChatSimplifyView:UpdateChat()
  TableUtility.ArrayShallowCopy(self.list, GameConfig.ChatRoom.MainView)
  local isShowGVG = self:IsShowGVG()
  if not isShowGVG then
    TableUtility.ArrayRemove(self.list, ChatChannelEnum.GVG)
  end
  self.chatCtl:ResetDatas(self.list)
end

function ChatSimplifyView:UpdateChatRoom(note)
  if note then
    local data = note.body
    if data then
      self:UpdateChatByChannel(data:GetChannel())
    end
  end
end

function ChatSimplifyView:UpdateChatByChannel(channel)
  local cellList = self.chatCtl:GetCells()
  if ChatRoomProxy.Instance:GetScrollScreenChannel() == self.startChannel then
    cellList[1]:SetData(GameConfig.ChatRoom.MainView[1])
  end
  for i = 1, #cellList do
    local cell = cellList[i]
    if cell.data and cell.data == channel then
      cell:Update()
    end
  end
end

function ChatSimplifyView:ChangeChannel()
  local channel = ChatRoomProxy.Instance:GetScrollScreenChannel()
  local cell = self:GetCellByChannel(channel)
  if cell then
    self.canSpring = false
    self.chatCenterOnChild:CenterOn(cell.trans)
  end
end

function ChatSimplifyView:GetCellByChannel(channel)
  local cells = self.chatCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data == channel then
      return cell
    end
  end
  return nil
end

function ChatSimplifyView:LoadCellPfb(cellPfb, cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfb))
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.name = cName
  return cellpfb
end

function ChatSimplifyView:ShowDot(isShow)
  self.dotTable.gameObject:SetActive(isShow)
end

function ChatSimplifyView:HandleCloseReturnChatChannel()
  xdlog("ChatSimplifyView:HandleCloseReturnChatChnenle")
  ChatRoomProxy.Instance:GetScrollScreenChannel()
end

function ChatSimplifyView:IsShowGVG()
  local _GuildProxy = GuildProxy.Instance
  if _GuildProxy:DoIHaveMercenaryGuild() then
    return true
  end
  local num = _GuildProxy:GetMyGuildMercenaryCount()
  if num ~= nil and 0 < num then
    return true
  end
  return false
end

function ChatSimplifyView:HandleGVG()
  local count = #self.list
  TableUtility.ArrayShallowCopy(self.list, GameConfig.ChatRoom.MainView)
  local isShowGVG = self:IsShowGVG()
  local channel = ChatChannelEnum.GVG
  if not isShowGVG then
    TableUtility.ArrayRemove(self.list, channel)
  end
  local curCount = #self.list
  if count ~= curCount then
    self.chatCtl:ResetDatas(self.list)
    local dot = self.chatDotList[channel]
    dot.gameObject:SetActive(isShowGVG)
    self.dotTable.repositionNow = true
    local curChannel = ChatRoomProxy.Instance:GetChatRoomChannel()
    if count > curCount and curChannel == channel then
      self:SpringToChannel(self.startChannel)
    else
      self:SpringToChannel(curChannel)
    end
  end
end
