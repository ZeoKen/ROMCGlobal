PostcardProxy = class("PostcardProxy", pm.Proxy)
PostcardProxy.Instance = nil
PostcardProxy.NAME = "PostcardProxy"
autoImport("PostcardData")

function PostcardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PostcardProxy.NAME
  if PostcardProxy.Instance == nil then
    PostcardProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:PreprocessConfigData()
  self:ResetProxyData()
  self:AddEvts()
end

function PostcardProxy:PreprocessConfigData()
  self.configData = self.configData or {}
  TableUtility.TableClear(self.configData)
end

function PostcardProxy:AddEvts()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.Listen_PlayerMapChange, self)
end

function PostcardProxy:Listen_PlayerMapChange(mapInfo)
  if not mapInfo then
    return nil
  end
  local mapId = mapInfo.data
end

function PostcardProxy:ResetProxyData()
  self.proxyData = self.proxyData or {}
  TableUtility.TableClear(self.proxyData)
  self.proxyData.cards = {}
  self.proxyData.receive_cards = {}
end

function PostcardProxy:GetSendPostcardData()
  if not self.sendPostcardData then
    self.sendPostcardData = PostcardData.new()
  end
  return self.sendPostcardData
end

function PostcardProxy:ClearSendPostcardData()
  self.sendPostcardData = nil
end

function PostcardProxy:GetReceivePostcardData()
  return self.receivePostcardData
end

function PostcardProxy:ServerRecv_UpdatePostcardCmd(data)
  if data.change and #data.change > 0 then
    for i = 1, #data.change do
      local id = data.change[i].id
      local exist = self:Query_GetPostcardById(id)
      if exist then
        exist:Tex_ResetDlInfo()
        exist:Server_SetData(data.change[i])
      end
    end
  end
  if data.add and data.add.id ~= 0 then
    if not self.proxyData.cards then
      self.proxyData.cards = {}
    end
    local card = PostcardData.new()
    card:Server_SetData(data.add)
    self:ReceiveCards_CheckSave(card)
    TableUtility.ArrayPushBack(self.proxyData.cards, card)
  end
  if data.del and data.del ~= 0 and self.proxyData.cards then
    local rm, card
    for i = 1, #self.proxyData.cards do
      if self.proxyData.cards[i].id == data.del then
        rm = i
        break
      end
    end
    if rm then
      card = self.proxyData.cards[rm]
      card:Dispose()
      card:Operate_Del()
      table.remove(self.proxyData.cards, rm)
    end
  end
end

function PostcardProxy:ServerRecv_PostcardListCmd(data)
  if not self.proxyData.cards then
    self.proxyData.cards = {}
  end
  TableUtility.ArrayClear(self.proxyData.cards)
  local card
  for i = 1, #data.postcards do
    card = PostcardData.new()
    card:Server_SetData(data.postcards[i])
    TableUtility.ArrayPushBack(self.proxyData.cards, card)
  end
end

function PostcardProxy:ServerRecv_ChatRetCmd(data)
  if not (self.sendPostcardData and data) or not data.postcard then
    return
  end
  if PostcardTestMe.Me():Simu_ReceiveSelfSentPostcardChatMsg() then
    local ori_from = data.id
    local ori_to = data.targetid
    data.id = ori_to
    data.targetid = ori_from
    data.postcard.from_char = ori_to
    data.postcard.from_name = "test"
    GameFacade.Instance:sendNotification(ServiceEvent.PhotoCmdSendPostcardCmd, nil)
    return false
  end
  if data.postcard.from_char == Game.Myself.data.id and data.postcard.url == self.sendPostcardData.url then
    data.postcard = {}
    data.str = GameConfig.Postcard.ChatMsg
    GameFacade.Instance:sendNotification(ServiceEvent.PhotoCmdSendPostcardCmd, nil)
    return false
  end
end

function PostcardProxy:ServerRecv_SavePostcardCmd(data)
end

function PostcardProxy:ServerRecv_DelPostcardCmd(data)
end

function PostcardProxy:Query_GetAllPostcards()
  return self.proxyData.cards
end

function PostcardProxy:Query_GetPostcardById(id, include_receive_cards)
  for _, v in pairs(self.proxyData.cards) do
    if v.id == id then
      return v
    end
  end
  if include_receive_cards then
    for _, v in pairs(self.proxyData.receive_cards) do
      if v.temp_receive_id == id then
        return v
      end
    end
  end
end

function PostcardProxy:Query_GetReceivePostcardById(id)
  for _, v in pairs(self.proxyData.receive_cards) do
    if v.temp_receive_id == id then
      return v
    end
  end
end

function PostcardProxy:Query_GetSaveCount()
  local saveCount = 0
  for _, v in pairs(self.proxyData.cards) do
    if v.type ~= EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
      saveCount = saveCount + 1
    end
  end
  return saveCount
end

function PostcardProxy:ReceiveCards_Save(postcard)
  self:ReceiveCards_Add(postcard)
  postcard.pending_save = true
  PostcardTestMe.Me():CallSavePostcardCmd(postcard:ToPostcardItem())
end

function PostcardProxy:ReceiveCards_CheckSave(newAddInfo)
  local card
  for _, v in pairs(self.proxyData.receive_cards) do
    if v.pending_save and v.url == newAddInfo.url and v.type == newAddInfo.type and v.source == newAddInfo.source and v.sender == newAddInfo.sender and v.style == newAddInfo.style and v.content == newAddInfo.content then
      card = v
      break
    end
  end
  if card then
    if card.type == EPOSTCARDTYPE.EPOSTCARD_PLAYER then
      MsgManager.ShowMsgByID(43368)
    end
    card:Operate_Save()
    self:ReceiveCards_Del(card)
  end
end

function PostcardProxy:ReceiveCards_Add(postcard)
  if postcard and postcard.temp_receive_id then
    local exist = self:Query_GetReceivePostcardById(postcard.temp_receive_id)
    if not exist then
      TableUtility.ArrayPushBack(self.proxyData.receive_cards, postcard)
    end
  end
end

function PostcardProxy:ReceiveCards_Del(postcard)
  if self.proxyData.receive_cards then
    local rm
    for i = 1, #self.proxyData.receive_cards do
      if self.proxyData.receive_cards[i].temp_receive_id == postcard.temp_receive_id then
        rm = i
        break
      end
    end
    if rm then
      table.remove(self.proxyData.receive_cards, rm)
    end
  end
  postcard:Dispose()
  postcard:Operate_Del()
end

PostcardTestMe = class("PostcardTestMe")
local TEST = false
local server_delay = 1000

function PostcardTestMe.Me()
  if nil == PostcardTestMe.me then
    PostcardTestMe.me = PostcardTestMe.new()
  end
  return PostcardTestMe.me
end

function PostcardTestMe:ctor()
  self:___GenerateData()
end

function PostcardTestMe:___GenerateData()
  if not TEST then
    return
  end
end

function PostcardTestMe:CallSendPostcardCmd(info, target)
  if TEST then
    local data = {}
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServiceChatCmdProxy.Instance:RecvChatRetCmd(data)
    end, self)
  else
    ServicePhotoCmdProxy.Instance:CallSendPostcardCmd(info, target)
  end
end

function PostcardTestMe:CallPostcardListCmd()
  if TEST then
    local data = {}
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServicePhotoCmdProxy.Instance:RecvPostcardListCmd(data)
    end, self)
  else
    ServicePhotoCmdProxy.Instance:CallPostcardListCmd()
  end
end

function PostcardTestMe:CallSavePostcardCmd(id)
  if TEST then
    local data = {}
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServicePhotoCmdProxy.Instance:RecvUpdatePostcardCmd(data)
    end, self)
  else
    ServicePhotoCmdProxy.Instance:CallSavePostcardCmd(id)
  end
end

function PostcardTestMe:CallDelPostcardCmd(id)
  if TEST then
    local data = {}
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServicePhotoCmdProxy.Instance:RecvUpdatePostcardCmd(data)
    end, self)
  else
    ServicePhotoCmdProxy.Instance:CallDelPostcardCmd(id)
  end
end

function PostcardTestMe:Simu_ReceiveSelfSentPostcardChatMsg()
  return false
end
