autoImport("SocialData")
autoImport("ChatMessageData")
autoImport("PresetMsgData")
autoImport("PermissionUtil")
ChatRoomProxy = class("ChatRoomProxy", pm.Proxy)
ChatRoomProxy.Instance = nil
ChatRoomProxy.NAME = "ChatRoomProxy"
local ChatChannelEnum_Recruit = 100
ChatChannelEnum = {
  All = GameConfig.ChatRoom.MainView[1],
  Current = ChatCmd_pb.ECHAT_CHANNEL_ROUND,
  Team = ChatCmd_pb.ECHAT_CHANNEL_TEAM,
  Guild = ChatCmd_pb.ECHAT_CHANNEL_GUILD,
  Private = ChatCmd_pb.ECHAT_CHANNEL_FRIEND,
  World = ChatCmd_pb.ECHAT_CHANNEL_WORLD,
  System = ChatCmd_pb.ECHAT_CHANNEL_SYS,
  Zone = ChatCmd_pb.ECHAT_CHANNEL_ROOM,
  Chat = ChatCmd_pb.ECHAT_CHANNEL_CHAT,
  Return = ChatCmd_pb.ECHAT_CHANNEL_USERRETURN_ROOM,
  Recruit = ChatChannelEnum_Recruit,
  ReserveRoom = ChatCmd_pb.ECHAT_CHANNEL_RESERVE_ROOM,
  GVG = ChatCmd_pb.ECHAT_CHANNEL_GVG
}
ChatTypeEnum = {
  MySelfMessage = "MySelfMessage",
  SomeoneMessage = "SomeoneMessage",
  SystemMessage = "SystemMessage",
  MyselfRedPacket = "MyselfRedPacket",
  SomeoneRedPacket = "SomeoneRedPacket",
  MyselfRecruit = "MyselfRecruit",
  SomeoneRecruit = "SomeoneRecruit"
}
ChatRoleEnum = {Pet = 1, Npc = 2}
BarrageStateEnum = {Off = 0, On = 1}
ChatRoomProxy.ExpressionType = {
  Action = ChatCmd_pb.EFAVORITEEXPRESSION_ACTION,
  Emoji = ChatCmd_pb.EFAVORITEEXPRESSION_EMOJI,
  RoleExpression = 10086
}
ChatRoomProxy.ItemCodeRepl = "{il=Item}"
ChatRoomProxy.ItemCodeReplPattern = "({il=Item})"
ChatRoomProxy.ItemNormal = "({(.-)})"
ChatRoomProxy.ItemCodeSymbol = ";"
ChatRoomProxy.ItemNormalLabel = "{%s}"
ChatRoomProxy.ItemBBCodeLabel = "[c][colortext]{[url=%s][u]%s[/u][/url]}[-][/c]"
ChatRoomProxy.ItemColorLabel = "[c][%s]{[url=%s][u]%s[/u][/url]}[-][/c]"
ChatRoomProxy.TreasureCodeString = "{ts="
ChatRoomProxy.TreasureCode = "({ts=(.-)})"
ChatRoomProxy.ExpressionType = {
  Action = ChatCmd_pb.EFAVORITEEXPRESSION_ACTION,
  Emoji = ChatCmd_pb.EFAVORITEEXPRESSION_EMOJI
}
local JumpSpeechRecognizer = function()
  if GmeVoiceProxy.Instance:IsInRoom() then
    MsgManager.ShowMsgByID(43108)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SpeechRecognizerView
  })
end

function ChatRoomProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ChatRoomProxy.NAME
  if ChatRoomProxy.Instance == nil then
    ChatRoomProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end

function ChatRoomProxy:Init()
  self.channelNames = {
    ZhString.Chat_current,
    ZhString.Chat_team,
    ZhString.Chat_guild,
    ZhString.Chat_friend,
    ZhString.Chat_world,
    ZhString.Chat_map,
    ZhString.Chat_system,
    nil,
    nil,
    nil,
    ZhString.Chat_return,
    [ChatChannelEnum.ReserveRoom] = ZhString.Chat_reserveroom,
    [ChatChannelEnum.GVG] = "GVG"
  }
  self.channelColor = {
    "[A2D9FF]",
    "[1ED2F8]",
    "[3FB953]",
    "[F43DFF]",
    "[E59118]",
    "[D8000D]",
    "[FCDD4F]",
    nil,
    nil,
    nil,
    "[00FF00]",
    [ChatChannelEnum.ReserveRoom] = "[F14135]",
    [ChatChannelEnum.GVG] = "[73d44d]"
  }
  self.speechMaxNums = 50
  self.presetTextMaxNums = 50
  self.chatContents = {
    [ChatChannelEnum.Current] = {},
    [ChatChannelEnum.Team] = {},
    [ChatChannelEnum.Guild] = {},
    [ChatChannelEnum.GVG] = {},
    [ChatChannelEnum.Private] = {},
    [ChatChannelEnum.World] = {},
    [ChatChannelEnum.System] = {},
    [ChatChannelEnum.Return] = {},
    [ChatChannelEnum.ReserveRoom] = {}
  }
  self.scrollScreenMaxNums = 20
  self.scrollScreenContents = {}
  self.privateChatList = {}
  self.privateChatContent = {}
  self.textEmojiData = {}
  self.presetTextData = {}
  self.itemDataList = {}
  self.autoSpeech = {}
  self.privateChatSpeech = {}
  self.barrageState = {
    [ChatChannelEnum.Team] = BarrageStateEnum.On,
    [ChatChannelEnum.Guild] = BarrageStateEnum.On,
    [ChatChannelEnum.GVG] = BarrageStateEnum.On,
    [ChatChannelEnum.Chat] = BarrageStateEnum.On,
    [ChatChannelEnum.ReserveRoom] = BarrageStateEnum.On
  }
  self.barrageContent = {}
  self.serverState = {
    [ChatChannelEnum.World] = BarrageStateEnum.On
  }
  self.itemInfo = {}
  self.isEditorPresetText = false
  self.isInitialize = false
  self.curChatId = 0
  self.curPrivateChatId = 0
  self:ResetAutoSpeechChannel()
  self.localTable = {}
  self.localData = {}
  self.favoriteExpressions = {}
  self.emojiExpressions = {}
  self.actionExpressions = {}
  self.roleExpressions = {}
  self.inStageEmojiExpressions = {}
  self.inStageActionExpressions = {}
  self:InitExpressionTexts()
  self.isUnlockRoleExpressionsDirty = true
  self.channelRedPacketCheckMap = {}
end

function ChatRoomProxy:AddEvts()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Quit, self.SaveChat, self)
  eventManager:AddEventListener(AppStateEvent.BackToLogo, self.SaveChat, self)
  eventManager:AddEventListener(AppStateEvent.Pause, self.SaveChatContent, self)
  eventManager:AddEventListener(AppStateEvent.Focus, self.SaveChatContent, self)
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.PlayerMapChange, self)
end

function ChatRoomProxy:PlayerMapChange(mapInfo)
  if not mapInfo then
    return nil
  end
  local mapId = mapInfo.data
  local data = Table_Map[mapId]
  if not data then
    LogUtility.Error(string.format("[%s] PlayerMapChange() Error : mapId = %s is not exist in Table_Map!", self.__cname, tostring(mapId)))
    return nil
  end
  if data.Type == 6 and self.mapId ~= mapId then
    self:ResetLastChatTime(ChatChannelEnum.World)
    self:ResetLastSameChatTimeText(ChatChannelEnum.World)
  end
  self.mapId = mapId
end

function ChatRoomProxy:RecvChatMessage(data)
  local chat = ChatMessageData.CreateAsArray(data)
  local channel = chat:GetChannel()
  self:HandleItemCode(chat)
  self:HandleSpeech(chat, channel)
  self:HandleShareItem(chat)
  self:HandleLoveConfession(chat)
  self:UpdateChatContents(chat, channel)
  self:UpdatePrivateChatContents(chat, channel)
  self:UpdateScrollScreenContents(chat, channel)
  self:UpdateKeywordContents(chat, channel)
  self:UpdateBarrageContents(chat, channel)
  self:UpdateChatRedPacket(chat, channel)
  return chat
end

function ChatRoomProxy:HandleShareItem(data)
  local share_data = data.share_data
  if share_data and #share_data.items > 0 then
    local str = string.format("[url=%s%d][u]%s[/u][/url]", "shareitem;", share_data.type, GameConfig.Share.WorldChatText[share_data.type] or "")
    data:SetStr(str)
  end
end

function ChatRoomProxy:HandleItemCode(data)
  local str = data:GetStr()
  if data and str then
    str = self:TryParseItemCodeToNormal(str, true, data.items)
    str = self:TryParseTreasureCodeToNormal(str)
    str = self:TryParseTeamGoalCode(str)
    data:SetStr(str)
  end
end

function ChatRoomProxy:HandleLoveConfession(data)
  if data.isSelf then
    return
  end
  local str = data:GetStr()
  local loveconfession = data.love_confession or 0
  if loveconfession == 1 then
    local str = string.format("[url=%s;%d;%d;%s][u]%s%s[/u][/url]", "lovechallenge", loveconfession, data:GetId(), data:GetName(), str, ZhString.LoveChallenge_ClickToBattle)
    data:SetStr(str)
  elseif loveconfession == 2 then
    local str = string.format("[url=%s;%d;%d;%s][u]%s%s[/u][/url]", "lovechallenge", loveconfession, data:GetId(), data:GetName(), str, ZhString.LoveChallenge_ClickToBless)
    data:SetStr(str)
    self:AddKeywordEffect(10, data)
  end
end

function ChatRoomProxy:HandleSpeech(data, channel)
  local voiceid = data:GetVoiceid()
  if data and channel and voiceid and voiceid ~= 0 then
    if self:IsAutoSpeech(channel) and #self.autoSpeech <= self.speechMaxNums then
      table.insert(self.autoSpeech, voiceid)
      if #self.autoSpeech == 1 and FunctionChatSpeech.Me():GetVoiceController() ~= nil and not FunctionChatSpeech.Me():GetVoiceController():IsPlaying() then
        self:CallFirstSpeech()
      end
    end
    if channel == ChatChannelEnum.Private then
      if #self.privateChatSpeech >= GameConfig.ChatRoom.PrivateVoice then
        table.remove(self.privateChatSpeech, 1)
      end
      table.insert(self.privateChatSpeech, voiceid)
    end
  end
end

function ChatRoomProxy:UpdateChatContents(data, channel)
  local temp = self.chatContents[channel]
  if temp then
    local maxCount = GameConfig.ChatRoom.ChatMaxCount[channel] or 200
    if maxCount <= #temp then
      ReusableObject.Destroy(temp[1])
      table.remove(temp, 1)
    end
    table.insert(temp, data)
  end
end

function ChatRoomProxy:UpdatePrivateChatContents(data, channel)
  if channel == ChatChannelEnum.Private then
    local chatId = data:GetChatId()
    if self.privateChatList[chatId] == nil then
      Game.SocialManager:AddDataByChatMessage(chatId, data)
      local tempArray = ReusableTable.CreateArray()
      tempArray[1] = chatId
      ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
      ReusableTable.DestroyArray(tempArray)
    end
    self:AddUnreadCount(chatId)
    self:SetChatTime(chatId, math.floor(ServerTime.CurServerTime()))
    local list = self.privateChatContent[chatId]
    if list == nil then
      list = {}
      self.privateChatContent[chatId] = list
    end
    self:AddPrivateChatTip(list, data)
    table.insert(list, data)
    if self:IsLoadedLocalFile(chatId) then
      FunctionChatIO.Me():AddSaveCache(chatId, data)
    end
    self:ShowRedTip(data)
  end
end

function ChatRoomProxy:UpdateScrollScreenContents(data, channel)
  if data.isHideInSimplify then
    return
  end
  if self.chatContents[channel] then
    if #self.scrollScreenContents >= self.scrollScreenMaxNums then
      table.remove(self.scrollScreenContents, 1)
    end
    table.insert(self.scrollScreenContents, data)
  end
end

function ChatRoomProxy:UpdateKeywordContents(data, channel)
  local cellType = data:GetCellType()
  if cellType and cellType == ChatTypeEnum.SystemMessage then
    return
  end
  local index = self:IsKeyword(data:GetStr(), channel)
  if index ~= -1 then
    self:AddKeywordEffect(index, data)
  end
end

function ChatRoomProxy:UpdateBarrageContents(data, channel)
  local cellType = data:GetCellType()
  if cellType and cellType == ChatTypeEnum.SystemMessage then
    return
  end
  if data:GetExpressionId() ~= 0 then
    return
  end
  local state = self:GetBarrageState(channel)
  if state == BarrageStateEnum.On then
    table.insert(self.barrageContent, data)
    ChatRoomProxy.GetChatBarrageViewInstance():AddBarrage()
  end
end

function ChatRoomProxy.GetChatBarrageViewInstance()
  if ChatRoomProxy.ChatBarrageViewInstance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatBarrageView
    })
  end
  return ChatRoomProxy.ChatBarrageViewInstance
end

function ChatRoomProxy:LoadDataByPlayerTip(data)
  if data.id and data.id ~= 0 and self.privateChatList[data.id] == nil then
    Game.SocialManager:AddDataByPlayerTip(data)
  end
end

function ChatRoomProxy:AddSaveCache(chatId, list)
  if self:IsLoadedLocalFile(chatId) then
    return
  end
  for i = 1, #list do
    FunctionChatIO.Me():AddSaveCache(chatId, list[i])
  end
end

function ChatRoomProxy:LoadLocalDataById(chatId)
  if not self:IsLoadedLocalFile(chatId) then
    local list = self.privateChatContent[chatId]
    if list ~= nil then
      self:AddSaveCache(chatId, list)
    end
    local datas = FunctionChatIO.Me():ReadChatContentById(chatId)
    if datas and 0 < #datas then
      if list == nil then
        list = {}
        self.privateChatContent[chatId] = list
      end
      local data
      local maxCount = GameConfig.ChatRoom.ChatMaxCount[ChatChannelEnum.Private]
      for i = 1, #datas do
        data = datas[i]
        TableUtility.TableClear(self.localData)
        self.localData.chatId = chatId
        self.localData.str = data.str
        self.localData.id = data.id
        self.localData.time = data.time
        self.localData.voiceid = data.audioId
        self.localData.voicetime = data.audioLength
        self.localData.channel = ChatChannelEnum.Private
        local expressionId = data.expressionId
        if expressionId ~= nil and 0 < expressionId then
          self.localData.expression = {}
          self.localData.expression.type = ChatRoomProxy.ExpressionType.Emoji
          self.localData.expression.id = expressionId
        end
        local chat = ChatMessageData.CreateAsArray(self.localData)
        local photo = data.photo
        if photo ~= nil and photo ~= "" then
          chat:SetPhotoInfo(photo)
        end
        local postcard = data.postcard
        if postcard ~= nil and postcard ~= "" then
          chat:SetPostcardInfo(postcard)
        end
        self:AddPrivateChatTip(list, chat)
        if maxCount <= #list then
          ReusableObject.Destroy(list[1])
          table.remove(list, 1)
        end
        local insertPos = math.min(i, #list + 1)
        table.insert(list, insertPos, chat)
      end
    end
    FunctionChatIO.Me():SaveChatContent()
  end
end

function ChatRoomProxy:SaveChat()
  for k, v in pairs(self.privateChatContent) do
    self:AddSaveCache(k, v)
  end
  FunctionChatIO.Me():SaveChatContent()
  FunctionChatIO.Me():SaveChatList(self.privateChatList)
end

function ChatRoomProxy:SaveChatContent(note)
  if note.data then
    FunctionChatIO.Me():SaveChatContent()
  end
end

function ChatRoomProxy:AddPrivateChatTip(list, curData)
  local curTime = curData:GetTime()
  local curDate = os.date("*t", curTime)
  local lastData = list[#list]
  local tip
  if lastData == nil then
    tip = self:GetPrivateChatDateTimeTip(curDate.year, curDate.month, curDate.day, curDate.hour, curDate.min)
  else
    local EnumSystem = ChatTypeEnum.SystemMessage
    if lastData:GetCellType() == EnumSystem or curData:GetCellType() == EnumSystem then
      return
    end
    local lastTime = lastData:GetTime()
    if curTime - lastTime < 120 then
      return
    end
    local isMix = false
    local lastDate = os.date("*t", lastTime)
    if curDate.day ~= lastDate.day or curDate.month ~= lastDate.month or curDate.year ~= lastDate.year then
      isMix = true
    end
    if isMix then
      tip = self:GetPrivateChatDateTimeTip(curDate.year, curDate.month, curDate.day, curDate.hour, curDate.min)
    else
      tip = string.format(ZhString.Chat_TimeTip, curDate.hour, curDate.min)
      tip = string.format([[

%s]], tip)
    end
  end
  self:AddPrivateChatTipMessage(list, tip)
end

function ChatRoomProxy:AddPrivateChatTipMessage(list, str)
  local EnumPrivate = ChatChannelEnum.Private
  if #list >= GameConfig.ChatRoom.ChatMaxCount[EnumPrivate] then
    ReusableObject.Destroy(list[1])
    table.remove(list, 1)
  end
  local localTable = self.localTable
  TableUtility.TableClear(localTable)
  localTable.str = str
  localTable.channel = EnumPrivate
  localTable.cellType = ChatTypeEnum.SystemMessage
  localTable.alignment = 2
  list[#list + 1] = ChatMessageData.CreateAsArray(localTable)
end

function ChatRoomProxy:GetPrivateChatDateTimeTip(year, month, day, hour, min)
  local date = string.format(ZhString.Chat_DateTip, year, month, day)
  local time = string.format(ZhString.Chat_TimeTip, hour, min)
  return string.format([[

%s
%s]], time, date)
end

function ChatRoomProxy:GetScrollScreenContents()
  return self.scrollScreenContents
end

function ChatRoomProxy:GetMessagesByChannel(channel)
  if channel then
    if channel == ChatChannelEnum.Recruit then
      local datas = TeamProxy.Instance:GetRecruitTeamList()
      return datas
    end
    return self.chatContents[channel]
  end
  return nil
end

function ChatRoomProxy:GetPrivateMessagesByGuid(chatId)
  if chatId then
    if self.privateChatContent[chatId] == nil then
      self.privateChatContent[chatId] = {}
    end
    return self.privateChatContent[chatId]
  end
  return nil
end

function ChatRoomProxy:InitTextEmoji()
  for k, v in pairs(Table_ChatEmoji) do
    if v.Type == 1 then
      table.insert(self.textEmojiData, v.id)
    end
  end
  table.sort(self.textEmojiData, function(l, r)
    return l < r
  end)
end

function ChatRoomProxy:InitPresetText()
  for k, v in pairs(Table_ChatEmoji) do
    if v.Type == 2 then
      table.insert(self.presetTextData, PresetMsgData.new(v.Emoji))
    end
  end
end

function ChatRoomProxy:RecvPresetMsgCmd(data)
  if self.isInitialize then
    return
  end
  self:InitTextEmoji()
  if #data.msgs > 0 then
    for i = 1, #data.msgs do
      table.insert(self.presetTextData, PresetMsgData.new(data.msgs[i]))
    end
  else
    self:InitPresetText()
  end
  self.isInitialize = true
end

function ChatRoomProxy:AddPrivateChatList(socialData)
  local id = socialData.guid
  self.privateChatList[id] = socialData
  local localChatList = FunctionChatIO.Me():ReadChatListById(id)
  if localChatList then
    socialData:SetUnreadCount(localChatList.unreadCount)
    socialData:SetChatTime(localChatList.chatTime)
  end
end

function ChatRoomProxy:RemovePrivateChatList(guid)
  self.privateChatList[guid] = nil
end

function ChatRoomProxy:RemovePrivateChat(index)
  local list = self:GetPrivateChatList(true)
  if 0 < index and index <= #list then
    ServiceSessionSocialityProxy.Instance:CallRemoveRelation(list[index].id, SocialManager.PbRelation.Chat)
    self.privateChatList[list[index].id] = nil
  end
end

function ChatRoomProxy:GetPrivateChatList(isSort)
  ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
  TableUtility.TableClear(self.localTable)
  for k, v in pairs(self.privateChatList) do
    if v ~= nil then
      table.insert(self.localTable, v)
    end
  end
  if isSort then
    local relation = SocialManager.SocialRelation.Chat
    table.sort(self.localTable, function(l, r)
      if l.chatTime ~= r.chatTime and l.chatTime ~= nil and r.chatTime ~= nil then
        return l.chatTime > r.chatTime
      else
        return l:GetCreatetime(relation) > r:GetCreatetime(relation)
      end
    end)
  end
  return self.localTable
end

function ChatRoomProxy:AddUnreadCount(chatId)
  if self.privateChatList[chatId] then
    self.privateChatList[chatId]:AddUnreadCount()
  else
  end
end

function ChatRoomProxy:ResetUnreadCount(chatId)
  if chatId == nil or chatId == 0 then
    return
  end
  if self.privateChatList[chatId] then
    self.privateChatList[chatId]:ResetUnreadCount()
  else
  end
end

function ChatRoomProxy:IsClearUnreadCount()
  local count = 0
  for k, v in pairs(self.privateChatList) do
    if v.unreadCount then
      count = count + v.unreadCount
      if count ~= 0 then
        return false
      end
    end
  end
  return true
end

function ChatRoomProxy:SetChatTime(chatId, time)
  local data = self.privateChatList[chatId]
  if data ~= nil then
    data:SetChatTime(time)
  end
end

function ChatRoomProxy:IsLoadedLocalFile(chatId)
  return FunctionChatIO.Me().isLoadedContent[chatId]
end

function ChatRoomProxy:CanPrivateTalk()
  return #self:GetPrivateChatList() > 0
end

function ChatRoomProxy:AddSystemMessage(channelId, content, params, removeTime, id, targetid, isHideInSimplify, userInfo)
  local tryParse, isError
  if params then
    tryParse, isError = MsgParserProxy.Instance:TryParse(content, unpack(params))
  end
  if EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name and isError then
    return
  end
  TableUtility.TableClear(self.localTable)
  self.localTable.channel = channelId
  self.localTable.str = tryParse or content
  self.localTable.str = MsgParserProxy.Instance:ParseIlItemInfo(self.localTable.str)
  self.localTable.str = MsgParserProxy.Instance:ReplaceIconInfo(self.localTable.str)
  self.localTable.cellType = ChatTypeEnum.SystemMessage
  self.localTable.removeTime = removeTime
  self.localTable.id = id
  self.localTable.targetid = targetid
  if isHideInSimplify ~= nil then
    self.localTable.isHideInSimplify = isHideInSimplify
  else
    self.localTable.isHideInSimplify = channelId ~= ChatChannelEnum.System
  end
  if userInfo then
    local sysMsgUserInfo = {}
    self.localTable.sysMsgUserInfo = sysMsgUserInfo
    sysMsgUserInfo.charid = userInfo.charid
    sysMsgUserInfo.name = userInfo.name
    sysMsgUserInfo.guildid = userInfo.guildid
    sysMsgUserInfo.guildname = userInfo.guildname
    sysMsgUserInfo.gender = userInfo.gender
    sysMsgUserInfo.profession = userInfo.profession
    sysMsgUserInfo.level = userInfo.level
    sysMsgUserInfo.hair = userInfo.hair
    sysMsgUserInfo.haircolor = userInfo.haircolor
    sysMsgUserInfo.body = userInfo.body
    sysMsgUserInfo.eye = userInfo.eye
    sysMsgUserInfo.clothcolor = userInfo.clothcolor
    sysMsgUserInfo.head = userInfo.head
    sysMsgUserInfo.back = userInfo.back
    sysMsgUserInfo.face = userInfo.face
    sysMsgUserInfo.tail = userInfo.tail
    sysMsgUserInfo.mount = userInfo.mount
    sysMsgUserInfo.mouth = userInfo.mouth
    sysMsgUserInfo.lefthand = userInfo.lefthand
    sysMsgUserInfo.righthand = userInfo.righthand
    sysMsgUserInfo.portrait = userInfo.portrait
    sysMsgUserInfo.homeid = userInfo.homeid
    sysMsgUserInfo.accid = userInfo.accid
    sysMsgUserInfo.portrait_frame = userInfo.portrait_frame
    sysMsgUserInfo.blink = userInfo.blink
    sysMsgUserInfo.appellation = userInfo.appellation
  end
  local chat = self:RecvChatMessage(self.localTable)
  if channelId == ChatChannelEnum.Zone then
    ChatZoomProxy.Instance:InQueueInputMessage(chat)
  end
  GameFacade.Instance:sendNotification(ChatRoomEvent.SystemMessage, chat)
end

function ChatRoomProxy:SetCurrentPrivateChatId(id)
  self.curPrivateChatId = id
end

function ChatRoomProxy:GetCurrentPrivateChatId()
  return self.curPrivateChatId
end

function ChatRoomProxy:SetCurrentChatChannel(channel)
  self.curChatChannel = channel
end

function ChatRoomProxy:GetChatRoomChannel()
  if self.curChatChannel == nil or self.curChatChannel == ChatChannelEnum.All then
    self.curChatChannel = ChatChannelEnum.World
  end
  return self.curChatChannel
end

function ChatRoomProxy:GetScrollScreenChannel()
  if self.curChatChannel == nil or not self:IsScrollScreenChannel(self.curChatChannel) then
    self.curChatChannel = ChatChannelEnum.All
  end
  return self.curChatChannel
end

function ChatRoomProxy:IsScrollScreenChannel(channel)
  for i = 1, #GameConfig.ChatRoom.MainView do
    if channel == GameConfig.ChatRoom.MainView[i] then
      return true
    end
  end
  return false
end

function ChatRoomProxy:IsKeyword(word, channel)
  for k, v in pairs(Table_KeywordAnimation) do
    if v.Keyword then
      if string.find(word, v.Keyword) then
        if v.Type then
          local channelType = string.split(v.Type, ",")
          for i = 1, #channelType do
            if tonumber(channelType[i]) == channel then
              return k
            end
          end
        else
          errorLog("ChatRoomProxy IsKeyword : Type = nil")
        end
      end
    else
      errorLog("ChatRoomProxy IsKeyword : Keyword = nil")
    end
  end
  return -1
end

function ChatRoomProxy:AddKeywordEffect(index, message)
  local data = Table_KeywordAnimation[index]
  if data then
    if data.startTime and data.endTime then
      local serverTime = ServerTime.CurServerTime() * 0.001
      if serverTime >= data.startTime and serverTime <= data.endTime then
        GameFacade.Instance:sendNotification(ChatRoomEvent.KeywordEffect, {data = data, message = message})
      end
    else
      GameFacade.Instance:sendNotification(ChatRoomEvent.KeywordEffect, {data = data, message = message})
    end
  else
    errorLog(string.format("ChatRoomProxy AddKeywordEffect : Table_KeywordAnimation[%s] is nil", tostring(index)))
  end
end

function ChatRoomProxy:GetChatItemInfo()
  TableUtility.TableClear(self.itemInfo)
  local items = BagProxy.Instance.roleEquip:GetItems()
  for _, item in pairs(items) do
    table.insert(self.itemInfo, item)
  end
  local shadow_items = BagProxy.Instance.shadowBagData:GetItems()
  for _, item in pairs(shadow_items) do
    table.insert(self.itemInfo, item)
  end
  local bag = BagProxy.Instance.bagData:GetItems()
  for i = 1, #bag do
    table.insert(self.itemInfo, bag[i])
  end
  return self.itemInfo
end

local concatTable = {}

function ChatRoomProxy:TryParseItemData(itemData)
  if itemData == nil then
    return ""
  end
  local result = "{il=%s}"
  local default = "0"
  local content = ""
  local temp = ""
  TableUtility.ArrayClear(concatTable)
  if itemData.id then
    temp = tostring(itemData.id)
  else
    temp = default
  end
  concatTable[1] = temp
  if itemData.staticData and itemData.staticData.id then
    temp = tostring(itemData.staticData.id)
  else
    temp = default
  end
  concatTable[2] = ChatRoomProxy.ItemCodeSymbol .. temp
  content = table.concat(concatTable)
  return string.format(result, content)
end

function ChatRoomProxy:TryParseItemDataToNormal(itemData)
  if itemData and itemData.staticData and itemData.staticData.NameZh then
    return string.format(ChatRoomProxy.ItemNormalLabel, itemData.staticData.NameZh)
  end
  return nil
end

function ChatRoomProxy:TryParseTeamGoalToString(teamGoalID)
  if teamGoalID then
    local teamGoalStaticData = Table_TeamGoals[teamGoalID]
    if teamGoalStaticData then
      return string.format(ChatRoomProxy.ItemNormalLabel, teamGoalStaticData.NameZh .. ZhString.TeamFindPopUp_ReplyForTeam)
    end
  end
  return nil
end

function ChatRoomProxy:TryParseItemCodeToNormal(content, isBBCode, items)
  if content == nil or type(content) == "table" then
    return content
  end
  if not items or string.find(content, ChatRoomProxy.ItemCodeReplPattern) == nil then
    return content
  end
  local count = 0
  local retCount = content:gsub(ChatRoomProxy.ItemCodeReplPattern, function(s)
    count = count + 1
    local item = items[count]
    local id = item and tonumber(item[2])
    local data = id and Table_Item[id]
    local cardLv = item and item[3] and tonumber(item[3]) or 0
    if data then
      local name = 0 < cardLv and "+" .. cardLv .. data.NameZh or data.NameZh
      if isBBCode then
        return string.format(ChatRoomProxy.ItemBBCodeLabel, item[1] .. ";" .. item[2], name)
      else
        return string.format(ChatRoomProxy.ItemNormalLabel, name)
      end
    end
    return false
  end)
  return retCount
end

function ChatRoomProxy:TryParseItemCodeToItemData(content)
  if content == nil then
    return nil
  end
  content = string.gsub(content, "{il=", "{ il=")
  local items
  for str, name in string.gmatch(content, ChatRoomProxy.ItemNormal) do
    local data = self:GetItemData(name)
    if data ~= nil then
      local split = string.split(content, str)
      if 1 < #split then
        TableUtility.ArrayClear(concatTable)
        concatTable[1] = split[1]
        for i = 2, #split do
          if i == 2 then
            concatTable[i] = ChatRoomProxy.ItemCodeRepl .. split[i]
          else
            concatTable[i] = str .. split[i]
          end
        end
        content = table.concat(concatTable)
      end
      items = items or {}
      table.insert(items, {
        guid = data.id,
        id = data.staticData.id
      })
    end
  end
  return content, items
end

function ChatRoomProxy:TryParseTeamGoalFromStr(str)
  for k, v in pairs(Table_TeamGoals) do
    if string.find(str, v.NameZh) then
      return v.type, v.id
    end
  end
  return nil
end

function ChatRoomProxy:TryParseTeamGoalCode(content)
  if not content then
    return nil
  end
  for str, name in string.gmatch(content, ChatRoomProxy.ItemNormal) do
    local goal, id = self:TryParseTeamGoalFromStr(name)
    if goal then
      local teamGoalStaticData = Table_TeamGoals[id]
      if teamGoalStaticData then
        return string.format(ChatRoomProxy.ItemBBCodeLabel, goal, teamGoalStaticData.NameZh .. ZhString.TeamFindPopUp_ReplyForTeam)
      end
    end
  end
  return content
end

function ChatRoomProxy:GetItemData(name)
  local index = 0
  local itemData
  for i = 1, #self.itemDataList do
    local data = self.itemDataList[i]
    if data.staticData and data.staticData.NameZh and name == data.staticData.NameZh then
      itemData = data
      index = i
      break
    end
  end
  if index ~= 0 then
    table.remove(self.itemDataList, index)
  end
  return itemData
end

function ChatRoomProxy:AddItemData(data)
  table.insert(self.itemDataList, data)
end

function ChatRoomProxy:ResetItemDataList()
  TableUtility.TableClear(self.itemDataList)
end

function ChatRoomProxy:ResetAutoSpeechChannel()
  self.autoSpeechChannel = {}
  local setting = FunctionPerformanceSetting.Me():GetSetting()
  for k, v in pairs(setting.autoPlayChatChannel) do
    table.insert(self.autoSpeechChannel, tonumber(v))
  end
end

function ChatRoomProxy:IsAutoSpeech(channel)
  for i = 1, #self.autoSpeechChannel do
    if channel == self.autoSpeechChannel[i] then
      return true
    end
  end
  return false
end

function ChatRoomProxy:AutoSpeechFinish()
  if #self.autoSpeech > 0 then
    table.remove(self.autoSpeech, 1)
  end
  LogUtility.Info("AutoSpeechFinish")
  self:CallFirstSpeech()
end

function ChatRoomProxy:CallFirstSpeech()
  if #self.autoSpeech > 0 then
    ServiceChatCmdProxy.Instance:CallQueryVoiceUserCmd(self.autoSpeech[1])
  else
    FunctionChatSpeech.Me():GetVoiceController():Stop()
  end
end

function ChatRoomProxy:ResetAutoSpeech()
  TableUtility.TableClear(self.autoSpeech)
end

function ChatRoomProxy:IsPrivateSpeech(voiceid)
  for i = 1, #self.privateChatSpeech do
    if voiceid == self.privateChatSpeech[i] then
      return true
    end
  end
  return false
end

function ChatRoomProxy:RecvChatSpeech(data)
  local path
  if self:IsPrivateSpeech(data.voiceid) then
    local bytes = Slua.ToBytes(data.voice)
    path = FunctionChatIO.Me():SavePrivateChatSpeech(data.voiceid, bytes)
  else
    local bytes = Slua.ToBytes(data.voice)
    path = FunctionChatIO.Me():SaveChatSpeech(data.voiceid, bytes)
  end
  return path
end

function ChatRoomProxy:SetBarrageState(channel, state)
  self.barrageState[channel] = state
end

function ChatRoomProxy:GetBarrageState(channel)
  local state = self.barrageState[channel]
  if state == nil then
    return BarrageStateEnum.Off
  end
  return state
end

function ChatRoomProxy:GetBarrageContent()
  return self.barrageContent
end

function ChatRoomProxy:SetServerState(channel, state)
  self.serverState[channel] = state
end

function ChatRoomProxy:GetServerState(channel)
  local state = self.serverState[channel]
  if state == nil then
    return BarrageStateEnum.On
  end
  return state
end

function ChatRoomProxy:IsPlayerSpeak(channel)
  for i = 1, #GameConfig.ChatRoom.PlayerSpeak do
    if channel == GameConfig.ChatRoom.PlayerSpeak[i] then
      return true
    end
  end
  return false
end

function ChatRoomProxy:IsShowRedTip(data)
  local chatId
  local myId = Game.Myself.data.id
  local targetid = data:GetTargetid()
  local id = data:GetId()
  if targetid and targetid ~= myId then
    chatId = targetid
  elseif id then
    chatId = id
  end
  if id == myId then
    return false
  elseif data:GetCellType() == ChatTypeEnum.SystemMessage then
    return false
  elseif chatId == self.curPrivateChatId then
    return false
  end
  return true
end

function ChatRoomProxy:ShowRedTip(data)
  if self:IsShowRedTip(data) then
    local chatId = data:GetChatId()
    local pChatBtnState = 0
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
    for k, v in pairs(self.privateChatList) do
      if k == chatId and v.unreadCount > 1 then
        pChatBtnState = 1
      end
    end
    GameFacade.Instance:sendNotification(ChatRoomEvent.HavePrivateChatMsg, pChatBtnState)
  else
    GameFacade.Instance:sendNotification(ChatRoomEvent.UpdatePrivateChatRed)
  end
end

function ChatRoomProxy:ClearRedTip()
  if self:IsClearUnreadCount() then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
    GameFacade.Instance:sendNotification(ChatRoomEvent.HavePrivateChatMsg)
  end
end

function ChatRoomProxy:CheckRedTip()
  if self:IsClearUnreadCount() then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
  else
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
  end
  GameFacade.Instance:sendNotification(ChatRoomEvent.HavePrivateChatMsg)
end

function ChatRoomProxy:RecvGetVoiceIDChatCmd(id)
  self.voiceId = id
end

function ChatRoomProxy:GetVoiceId()
  return self.voiceId
end

function ChatRoomProxy:ResetVoiceId()
  self.voiceId = nil
end

function ChatRoomProxy:StripSymbols(content)
  if content then
    local isStripSymbols = true
    local lastContent
    while isStripSymbols do
      lastContent = content
      content = NGUIText.StripSymbols(content)
      if content == lastContent then
        isStripSymbols = false
      end
    end
  end
  return content
end

function ChatRoomProxy:CheckSoliloquize(channel, content, desID)
  local soliloquizeChats = GameConfig.ChatRoom.soliloquizeChats
  for i = 1, #soliloquizeChats do
    if channel == soliloquizeChats[i] and FunctionMaskWord.Me():CheckMaskWord(content, GameConfig.MaskWord.Chat) then
      local soliloquizeTemp = ReusableTable.CreateTable()
      soliloquizeTemp.id = Game.Myself.data.id
      soliloquizeTemp.targetid = desID
      soliloquizeTemp.voiceid = 0
      soliloquizeTemp.voicetime = 0
      soliloquizeTemp.channel = channel
      soliloquizeTemp.str = content
      self:TryCreateChatMessage(soliloquizeTemp)
      ReusableTable.DestroyAndClearTable(soliloquizeTemp)
      return true
    end
  end
  return false
end

function ChatRoomProxy:TryCreateChatMessage(data)
  local chat = self:RecvChatMessage(data)
  self:sendNotification(ServiceEvent.ChatCmdChatRetCmd, chat)
  return chat
end

function ChatRoomProxy:TryRecognizer()
  self.requestCode = FunctionPermission.Me():RequestRecordAudioPermission()
  if self.requestCode == 0 then
    JumpSpeechRecognizer()
  end
  return true
end

function ChatRoomProxy:RequestPermission(requestCode)
  if self.requestCode == requestCode then
    JumpSpeechRecognizer()
  end
end

function ChatRoomProxy:TryParseTreasureCodeToNormal(content)
  if content == nil or type(content) == "table" then
    return content
  end
  if string.find(content, self.TreasureCodeString) == nil then
    return content
  end
  TableUtility.TableClear(self.localTable)
  for str, code in string.gmatch(content, self.TreasureCode) do
    local data = {}
    data.str = str
    data.code = code
    table.insert(self.localTable, data)
  end
  for i = 1, #self.localTable do
    local str = self.localTable[i].str
    local code = self.localTable[i].code
    local split = string.split(content, str)
    if 1 < #split then
      local temp = string.format(self.ItemBBCodeLabel, code, ZhString.GuildTreasure_ChatTip)
      TableUtility.ArrayClear(concatTable)
      concatTable[1] = split[1]
      for i = 2, #split do
        concatTable[i] = temp .. split[i]
      end
      content = table.concat(concatTable)
    end
  end
  return content
end

function ChatRoomProxy:RecvNpcChatNtf(data)
  local channel = data.channel
  if channel == ChatChannelEnum.System or channel == ChatChannelEnum.Private or channel == ChatChannelEnum.Zone then
    return
  end
  local npcid = data.npcid
  local npcdata = Table_Npc[npcid]
  if npcdata then
    local chat = ReusableTable.CreateTable()
    local headData = HeadImageData.new()
    headData:TransByNpcData(npcdata)
    chat.id = data.npcguid
    chat.name = headData.name
    chat.channel = channel
    chat.roleType = ChatRoleEnum.Npc
    chat.voiceid = 0
    chat.voicetime = 0
    local str = ""
    local msg = Table_Sysmsg[data.msgid]
    if msg ~= nil then
      str = msg.Text
    else
      str = data.msg
    end
    local param = ReusableTable.CreateArray()
    for i = 1, #data.params do
      TableUtility.ArrayPushBack(param, data.params[i].param)
    end
    str = MsgParserProxy.Instance:TryParse(str, unpack(param))
    ReusableTable.DestroyAndClearArray(param)
    chat.str = str
    local chatData = self:TryCreateChatMessage(chat)
    chatData:TransByHeadImageData(headData)
    ReusableTable.DestroyAndClearTable(chat)
  end
end

function ChatRoomProxy:InitExpressionTexts()
  self.expressionTexts = {}
  local t, id, ht
  if not Table_ExpressionText then
    return
  end
  for _, data in pairs(Table_ExpressionText) do
    t = data.ExpressionType
    id = data.ExpressionID
    ht = data.HasTarget > 0 and true or false
    self.expressionTexts[t] = self.expressionTexts[t] or {}
    self.expressionTexts[t][id] = self.expressionTexts[t][id] or {}
    self.expressionTexts[t][id][ht] = self.expressionTexts[t][id][ht] or {}
    TableUtility.ArrayPushBack(self.expressionTexts[t][id][ht], data)
  end
end

function ChatRoomProxy:GetRandomExpressionTextId(t, id, hasTarget)
  if not t or not id then
    LogUtility.Error("ArgumentNilException")
    return
  end
  if not self.expressionTexts or not next(self.expressionTexts) then
    LogUtility.Error("Cannot find any expression text")
    return
  end
  hasTarget = hasTarget and true or false
  if not (self.expressionTexts[t] and self.expressionTexts[t][id]) or not self.expressionTexts[t][id][hasTarget] then
    LogUtility.WarningFormat("Cannot get expression texts when type = {0}, id = {1} and hasTarget = {2}", t, id, hasTarget)
    return
  end
  local textDataArr = self.expressionTexts[t][id][hasTarget]
  local randomNum = math.clamp(Game.Myself.data:GetRandom() % #textDataArr + 1, 1, #textDataArr)
  return textDataArr[randomNum].id
end

function ChatRoomProxy:RecvQueryFavoriteExpression(data)
  TableUtility.TableClear(self.favoriteExpressions)
  if not data.expression then
    return
  end
  for _, element in pairs(data.expression) do
    self.favoriteExpressions[element.pos] = ChatRoomProxy._GetNewExpressionData(element.type, element.id)
  end
end

function ChatRoomProxy:RecvUpdateFavoriteExpression(data)
  if not self.favoriteExpressions then
    LogUtility.Error("Received UpdateFavoriteExpressionChatCmd even before favoriteExpression had been established!")
    return
  end
  local pos
  if data.updates then
    for _, element in pairs(data.updates) do
      pos = element.pos
      self.favoriteExpressions[pos] = self.favoriteExpressions[pos] or {}
      ChatRoomProxy._UpdateExpressionData(self.favoriteExpressions[pos], element.type, element.id)
    end
  end
  if data.dels then
    for _, element in pairs(data.dels) do
      pos = element.pos
      if not self.favoriteExpressions[pos] then
        LogUtility.WarningFormat("Cannot find favoriteExpression data while pos = {0}, type = {1} and id = {2}", pos, element.type, element.id)
      else
        self.favoriteExpressions[pos] = nil
      end
    end
  end
end

local getPbFavoriteExpression = function(type, id, pos)
  local expression = NetConfig.PBC and {} or ChatCmd_pb.FavoriteExpression()
  expression.type = type
  expression.id = id
  expression.pos = pos
  return expression
end

function ChatRoomProxy:CallUpdateFavoriteExpression(tempFavoriteExpressions)
  if type(tempFavoriteExpressions) ~= "table" then
    LogUtility.Error("Cannot find tempFavoriteExpressions!")
    return
  end
  local i, origData, tempData = 1
  local updates, dels = ReusableTable.CreateArray(), ReusableTable.CreateArray()
  while true do
    origData = self.favoriteExpressions[i]
    tempData = tempFavoriteExpressions[i]
    if not (origData or tempData) then
      break
    end
    if not origData then
      table.insert(updates, getPbFavoriteExpression(tempData.type, tempData.id, i))
    elseif not tempData then
      table.insert(dels, getPbFavoriteExpression(origData.type, origData.id, i))
    elseif origData.id ~= tempData.id or origData.type ~= tempData.type then
      table.insert(updates, getPbFavoriteExpression(tempData.type, tempData.id, i))
    end
    i = i + 1
  end
  ServiceChatCmdProxy.Instance:CallUpdateFavoriteExpressionChatCmd(updates, dels)
  ReusableTable.DestroyAndClearArray(updates)
  ReusableTable.DestroyAndClearArray(dels)
end

function ChatRoomProxy:SetUnlockActionsDirty()
  self.isUnlockActionsDirty = true
end

function ChatRoomProxy:SetUnlockEmojisDirty()
  self.isUnlockEmojisDirty = true
end

function ChatRoomProxy:SetUnlockRoleExpressionsDirty()
  self.isUnlockRoleExpressionsDirty = true
end

function ChatRoomProxy:GetEmojiExpressions()
  if MyselfProxy.Instance:GetDressUp() ~= 0 then
    self:TryInitInStageEmojiExpressions()
    return self.inStageEmojiExpressions
  else
    self:TryUpdateUnlockEmojiExpressions()
    return self.emojiExpressions
  end
end

function ChatRoomProxy:GetActionExpressions()
  if MyselfProxy.Instance:GetDressUp() ~= 0 then
    self:TryInitInStageActionExpressions()
    return self.inStageActionExpressions
  else
    self:TryUpdateUnlockActionExpressions()
    return self.actionExpressions
  end
end

function ChatRoomProxy:GetRoleExpressions()
  self:TryUpdateUnlockRoleExpressions()
  return self.roleExpressions
end

local expressionSortFunc = function(a, b)
  return a.id < b.id
end

function ChatRoomProxy:TryInitInStageEmojiExpressions()
  if next(self.inStageEmojiExpressions) then
    return
  end
  for _, data in pairs(Table_Expression) do
    if Game.Config_UnlockEmojiIds[data.id] == 1 then
      ChatRoomProxy._InsertNewExpressionData(self.inStageEmojiExpressions, ChatRoomProxy.ExpressionType.Emoji, data.id, data.NameEn)
    end
  end
  table.sort(self.inStageEmojiExpressions, expressionSortFunc)
end

function ChatRoomProxy:TryInitInStageActionExpressions()
  if next(self.inStageActionExpressions) then
    return
  end
  local assetRole = Game.Myself.assetRole
  if not assetRole then
    return
  end
  for _, data in pairs(Table_ActionAnime) do
    if data.Type == 2 and Game.Config_UnlockActionIds[data.id] == 1 and assetRole:HasActionRaw(data.Name) then
      ChatRoomProxy._InsertNewExpressionData(self.inStageActionExpressions, ChatRoomProxy.ExpressionType.Action, data.id, data.Name)
    end
  end
  table.sort(self.inStageActionExpressions, expressionSortFunc)
end

function ChatRoomProxy:TryUpdateUnlockEmojiExpressions()
  if not self.isUnlockEmojisDirty then
    return
  end
  local emojiMap = MyselfProxy.Instance:GetUnlockEmojiMap()
  ChatRoomProxy._UpdateUnlockExpressions(self.emojiExpressions, ChatRoomProxy.ExpressionType.Emoji, Table_Expression, function(data)
    return emojiMap[data.id]
  end)
  self.isUnlockEmojisDirty = false
end

function ChatRoomProxy:TryUpdateUnlockActionExpressions()
  if not self.isUnlockActionsDirty then
    return
  end
  local assetRole = Game.Myself.assetRole
  local actionMap = MyselfProxy.Instance:GetUnlockActionMap()
  ChatRoomProxy._UpdateUnlockExpressions(self.actionExpressions, ChatRoomProxy.ExpressionType.Action, Table_ActionAnime, function(data)
    return data.Type == 2 and actionMap[data.id] == 1 and assetRole and assetRole:HasActionRaw(data.Name)
  end)
  self.isUnlockActionsDirty = false
end

function ChatRoomProxy:TryUpdateUnlockRoleExpressions()
  if not self.isUnlockRoleExpressionsDirty then
    return
  end
  ChatRoomProxy._UpdateUnlockExpressions(self.roleExpressions, ChatRoomProxy.ExpressionType.RoleExpression, Table_RoleExpression, function(data)
    return data.Hide ~= 1
  end)
  self.isUnlockRoleExpressionsDirty = false
end

function ChatRoomProxy._UpdateUnlockExpressions(expressions, expressionType, staticTable, dataValidPredicate)
  if type(expressions) ~= "table" then
    LogUtility.Error("You cannot do UpdateUnlockExpressions while expressions is not a table")
    return
  end
  local oldCount, newCount = #expressions, 0
  for _, data in pairs(staticTable) do
    if dataValidPredicate(data) then
      newCount = newCount + 1
      if expressions[newCount] then
        ChatRoomProxy._UpdateExpressionData(expressions[newCount], expressionType, data.id)
      else
        ChatRoomProxy._InsertNewExpressionData(expressions, expressionType, data.id)
      end
    end
  end
  for i = newCount + 1, oldCount do
    expressions[i] = nil
  end
  table.sort(expressions, expressionSortFunc)
end

function ChatRoomProxy._GetNewExpressionData(type, id, name)
  local d = {}
  ChatRoomProxy._UpdateExpressionData(d, type, id, name)
  return d
end

function ChatRoomProxy._InsertNewExpressionData(datas, expressionType, id, name)
  if type(datas) ~= "table" then
    LogUtility.Error("You're trying to insert new expression data while datas is not a table!")
    return
  end
  table.insert(datas, ChatRoomProxy._GetNewExpressionData(expressionType, id, name))
end

function ChatRoomProxy._UpdateExpressionData(data, expressionType, id, name)
  if type(data) ~= "table" then
    LogUtility.Error("You're trying to update expression data which is not a table!")
    return
  end
  TableUtility.TableClear(data)
  data.type = expressionType
  data.id = id
  data.name = name or ChatRoomProxy._GetExpressionName(expressionType, id)
end

function ChatRoomProxy._GetExpressionName(expressionType, id)
  if expressionType == ChatRoomProxy.ExpressionType.Emoji then
    return Table_Expression[id] and Table_Expression[id].NameEn
  elseif expressionType == ChatRoomProxy.ExpressionType.Action then
    return Table_ActionAnime[id] and Table_ActionAnime[id].Name
  elseif expressionType == ChatRoomProxy.ExpressionType.RoleExpression then
    return Table_RoleExpression[id] and Table_RoleExpression[id].Icon
  end
end

function ChatRoomProxy:CallExpressionChatCmd(channel, t, id, targetData)
  local msgId = self:GetRandomExpressionTextId(t, id, targetData)
  if not msgId then
    return
  end
  local sender = Game.Myself.data:GetName()
  local target = targetData and (targetData.GetName and targetData:GetName() or targetData.name) or ""
  ServiceChatCmdProxy.Instance:CallExpressionChatCmd(channel, Game.Myself.data.id, targetData and targetData.id, msgId, sender, target)
  return msgId
end

function ChatRoomProxy:RecvExpressionChatCmd(data)
  local text = ChatRoomProxy.MakeExpressionText(data.msgid, data.sendername, data.targetname)
  if not text then
    return
  end
  local m = data.msgid
  local t = m and Table_ExpressionText[m] and Table_ExpressionText[m].ExpressionType
  if t == ChatRoomProxy.ExpressionType.Action then
    self:AddSystemMessage(data.channel, text, nil, nil, data.id, data.targetid, false)
  end
end

local remove002Chara = function(str)
  return str and str:gsub("\002", "")
end

function ChatRoomProxy.MakeExpressionText(text, senderName, targetName)
  if not text then
    LogUtility.Error("ArgumentNilException: text")
    return
  end
  local textData = type(text) ~= "number" and text or Table_ExpressionText[text]
  if not textData then
    LogUtility.WarningFormat("Cannot find ExpressionText data with param 'text' = {0}", text)
    return
  end
  local myName = remove002Chara(Game.Myself.data:GetName())
  local nameYou = OverSea.LangManager.Instance():GetLangByKey(ZhString.Chat_You)
  if remove002Chara(senderName) == myName then
    senderName = nameYou
  elseif remove002Chara(targetName) == myName then
    targetName = nameYou
  end
  local result = string.gsub(type(textData) == "string" and OverSea.LangManager.Instance():GetLangByKey(textData) or OverSea.LangManager.Instance():GetLangByKey(textData.Msg), "$A", senderName or "")
  result = string.gsub(result, "$B", targetName or "")
  return result
end

local lastChatTime = {}
local lastSameChatTime = {}
local lastSameChatString = {}

function ChatRoomProxy:CheckoutChatCooldown(channel)
  if channel == ChatChannelEnum.World then
    local time = lastChatTime[channel] or 0
    return ChatRoomProxy.GetServerTime() - time > GameConfig.Chat.WorldChat.DiffWordCD
  else
    return true
  end
end

function ChatRoomProxy:SetLastChatTime(guid, channel, time)
  if not self:CheckoutIsMyself(guid) then
    return nil
  end
  if channel == ChatChannelEnum.World then
    lastChatTime[channel] = time or ChatRoomProxy.GetServerTime()
  end
end

function ChatRoomProxy:ResetLastChatTime(channel)
  if channel == ChatChannelEnum.World then
    lastChatTime[channel] = 0
  end
end

function ChatRoomProxy:CheckoutSameChatCooldown(channel, content)
  local text
  if type(content) == "number" then
    local data = Table_Expression[content]
    if data then
      text = data.id .. data.NameZh
    else
      LogUtility.Error(string.format("[%s] CheckoutSameChatCooldown() Error : id = %s is not exist in Table_Expression!", self.__cname, tostring(content)))
    end
  else
    text = content
  end
  if channel == ChatChannelEnum.World then
    if lastSameChatString[channel] ~= text then
      return true
    end
    local time = lastSameChatTime[channel] or 0
    return ChatRoomProxy.GetServerTime() - time > GameConfig.Chat.WorldChat.SameWordCD
  else
    return true
  end
end

function ChatRoomProxy:SetLastSameChatTimeText(guid, channel, content, time)
  if not self:CheckoutIsMyself(guid) then
    return nil
  end
  local text
  if type(content) == "number" then
    local data = Table_Expression[content]
    if data then
      text = data.id .. data.NameZh
    else
      LogUtility.Error(string.format("[%s] SetLastSameChatTimeText() Error : id = %s is not exist in Table_Expression!", self.__cname, tostring(content)))
    end
  else
    text = content
  end
  if channel == ChatChannelEnum.World then
    lastSameChatTime[channel] = time or ChatRoomProxy.GetServerTime()
    lastSameChatString[channel] = text
  end
end

function ChatRoomProxy:ResetLastSameChatTimeText(channel)
  if channel == ChatChannelEnum.World then
    lastSameChatTime[channel] = 0
    lastSameChatString[channel] = nil
  end
end

function ChatRoomProxy:CheckoutIsMyself(guid)
  return Game.Myself.data.id == guid
end

function ChatRoomProxy.GetServerTime()
  return ServerTime.CurServerTime() * 0.001
end

local lastChatPhotoTime = {}

function ChatRoomProxy.IsChatPhotoEnable(channel)
  if channel and GameConfig.ChatPhotoSettings and GameConfig.ChatPhotoSettings[channel] then
    return GameConfig.ChatPhotoSettings[channel].enable and GameConfig.ChatPhotoSettings[channel].enable == 1
  end
end

function ChatRoomProxy:SetLastChatPhotoTime(channel)
  lastChatPhotoTime[channel] = UnityRealtimeSinceStartup
end

function ChatRoomProxy:CheckChatPhotoDailyTimes(channel)
  local dailySent = 0
  if channel == ChatChannelEnum.Guild then
    dailySent = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_CHAT_GUILDPHOTO) or 0
  end
  local dailyLimit = GameConfig.ChatPhotoSettings and GameConfig.ChatPhotoSettings[channel] and GameConfig.ChatPhotoSettings[channel].dailyLimit
  if dailyLimit and dailySent >= dailyLimit then
    return false
  end
  return true
end

function ChatRoomProxy:CheckChatPhotoCoolDown(channel)
  local cd = GameConfig.ChatPhotoSettings and GameConfig.ChatPhotoSettings[channel] and GameConfig.ChatPhotoSettings[channel].cd
  local lastTime = lastChatPhotoTime[channel]
  if lastTime and cd > UnityRealtimeSinceStartup - lastTime then
    return false
  end
  return true
end

function ChatRoomProxy:RecvUserReturnEnterChatRoomCmd(data)
  self.returnChatRoomVald = data.success
  ChatRoomProxy.Instance:SetCurrentChatChannel(ChatChannelEnum.Return)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    force = false
  })
end

function ChatRoomProxy:RecvUserReturnLeaveChatRoomCmd(data)
  self.returnChatRoomVald = false
end

function ChatRoomProxy:GetReturnRoomChatValid()
  return self.returnChatRoomVald or false
end

function ChatRoomProxy:RecvQueryGuildRedPacketChat(data)
  if data.msgs then
    table.sort(data.msgs, function(l, r)
      return l.timestamp < r.timestamp
    end)
    for i = 1, #data.msgs do
      local chat = data.msgs[i]
      self:RecvChatMessage(chat)
    end
  end
end

function ChatRoomProxy:UpdateChatRedPacket(chat, channel)
  local redPacketGuid = chat:GetRedPacketGUID()
  if redPacketGuid and (channel == ChatChannelEnum.Guild or channel == ChatChannelEnum.GVG) then
    local available = chat:CheckRedPacketCanReceive()
    RedPacketProxy.Instance:UpdateAvailableMap(redPacketGuid, available)
    if available then
      if not self.channelRedPacketCheckMap[channel] then
        self.channelRedPacketCheckMap[channel] = {}
      end
      table.insert(self.channelRedPacketCheckMap[channel], chat)
      self:UpdateRedPacketRedTip(channel, true)
    end
  end
end

function ChatRoomProxy:UpdateRedPacketRedTip(channel, enable)
  local tipId
  if channel == ChatChannelEnum.Guild then
    tipId = GameConfig.RedPacket.RedTip and GameConfig.RedPacket.RedTip.Guild
  elseif channel == ChatChannelEnum.GVG then
    tipId = GameConfig.RedPacket.RedTip and GameConfig.RedPacket.RedTip.GVG
  end
  if enable then
    RedTipProxy.Instance:UpdateRedTip(tipId)
  else
    RedTipProxy.Instance:RemoveWholeTip(tipId)
  end
end

function ChatRoomProxy:CheckChannelRedPackets()
  for channel, chats in pairs(self.channelRedPacketCheckMap) do
    if 0 < #chats then
      local redPackets = {}
      for i = 1, #chats do
        local redPacketGuid = chats[i]:GetRedPacketGUID()
        local info = {}
        info.redpack_guid = redPacketGuid
        info.senderid = chats[i]:GetId()
        redPackets[#redPackets + 1] = info
      end
      ServiceChatCmdProxy.Instance:CallCheckRecvRedPacketChatCmd(channel, redPackets)
    end
  end
end

function ChatRoomProxy:RecvCheckRedPacket(data)
  for i = 1, #data.red_packs do
    local redPacket = data.red_packs[i]
    RedPacketProxy.Instance:UpdateAvailableMap(redPacket.redpack_guid, redPacket.can_recv)
  end
  self:CheckRedPacketRedTip(data.channel)
end

function ChatRoomProxy:CheckRedPacketRedTip(channel)
  local chats = self.channelRedPacketCheckMap[channel]
  if chats then
    for i = #chats, 1, -1 do
      local guid = chats[i]:GetRedPacketGUID()
      if not RedPacketProxy.Instance:IsRedPacketCanReceive(guid) then
        table.remove(chats, i)
      end
    end
    self:UpdateRedPacketRedTip(channel, 0 < #chats)
  end
end
