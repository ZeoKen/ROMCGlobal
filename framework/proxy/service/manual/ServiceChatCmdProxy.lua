autoImport("ServiceChatCmdAutoProxy")
ServiceChatCmdProxy = class("ServiceChatCmdProxy", ServiceChatCmdAutoProxy)
ServiceChatCmdProxy.Instance = nil
ServiceChatCmdProxy.NAME = "ServiceChatCmdProxy"

function ServiceChatCmdProxy:ctor(proxyName)
  if ServiceChatCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceChatCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceChatCmdProxy.Instance = self
  end
end

function ServiceChatCmdProxy:RecvPlayExpressionChatCmd(data)
  FunctionPlayerHead.Me():PlayEmoji(data)
end

function ServiceChatCmdProxy:RecvQueryUserInfoChatCmd(data)
  local charid = data.charid
  local msgId = data.msgid
  local type = data.type
  self.userInfo = self.userInfo or {}
  if nil == self.userInfo[charid] then
    self.userInfo[charid] = ByteArray()
  end
  self.userInfo[charid]:AddMergeByte(Slua.ToBytes(data.data.data))
  if data.data.over then
    local newData = {}
    newData.charid = charid
    newData.msgid = msgId
    newData.type = type
    newData.info = {}
    local bytes = self.userInfo[charid]:MergeByte()
    if bytes then
      PbMgr.DecodeMsgByName("Cmd.QueryUserInfo", Slua.ToString(bytes), newData.info)
    end
    if type == ChatCmd_pb.EUSERINFOTYPE_CHAT then
      if msgId and 0 < msgId then
        MsgManager.ShowMsgByIDTable(msgId)
      elseif nil ~= next(newData.info) then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PlayerDetailView,
          viewdata = {
            dataInfo = newData.info
          }
        })
      end
    end
    self:Notify(ServiceEvent.ChatCmdQueryUserInfoChatCmd, newData)
    self.userInfo[charid] = nil
  end
end

function ServiceChatCmdProxy:CallChatCmd(channel, str, desID, voice, voicetime, msgid, msgover, photo, expression, loveconfession)
  if channel == ChatChannelEnum.World and MyselfProxy.Instance:RoleLevel() < GameConfig.System.chat_world_reqlv then
    MsgManager.ShowMsgByID(77)
    return
  end
  local _ChatRoomProxy = ChatRoomProxy.Instance
  if _ChatRoomProxy:CheckSoliloquize(channel, str, desID) then
    return
  end
  str = _ChatRoomProxy:StripSymbols(str)
  local items
  str, items = _ChatRoomProxy:TryParseItemCodeToItemData(str)
  str = _ChatRoomProxy:TryParseTeamGoalCode(str)
  if voice then
    msgid = ChatRoomProxy.Instance:GetVoiceId()
    if msgid ~= nil then
      local byteArray = ByteArray(voice, 20000)
      local splitLength = byteArray:GetSplitLength()
      helplog("CallChatCmd : voice : {0} , splitLength : {1}", tostring(#voice), tostring(splitLength))
      for i = 1, splitLength do
        local splitByte = byteArray:GetSplitArrayByIndex(i - 1)
        local splitByteStr = Slua.ToString(splitByte)
        local isOver = false
        if i == splitLength then
          isOver = true
          ServiceChatCmdProxy.super.CallChatCmd(self, channel, str, desID, splitByteStr, voicetime, msgid, isOver, photo, expression, nil, items, loveconfession)
          ServiceChatCmdProxy.Instance:CallGetVoiceIDChatCmd()
        else
          ServiceChatCmdProxy.super.CallChatCmd(self, nil, "", nil, splitByteStr, nil, msgid, isOver, photo, expression, nil, items, loveconfession)
        end
      end
    end
  else
    ServiceChatCmdProxy.super.CallChatCmd(self, channel, str, desID, voice, voicetime, msgid, msgover, photo, expression, nil, items, loveconfession)
  end
end

function ServiceChatCmdProxy:RecvChatRetCmd(data)
  if PostcardProxy.Instance:ServerRecv_ChatRetCmd(data) then
    return
  end
  xdlog("聊天记录更新", data.channel)
  if not ChatRoomProxy.IsChatPhotoEnable(data.channel) and data.photo and data.photo.source and data.photo.sourceid and data.photo.source ~= 0 and data.photo.sourceid ~= 0 then
    return
  end
  if data.voiceid ~= nil and data.voicetime ~= 0 and ApplicationInfo.NeedOpenVoiceSend() == false then
    return
  end
  for i = 1, #GameConfig.ChatRoom.BlackList do
    if data.channel == GameConfig.ChatRoom.BlackList[i] and not TeamProxy.Instance:IsInMyGroup(data.id) and FriendProxy.Instance:IsBlacklist(data.id) then
      return
    end
  end
  if ChatRoomProxy.Instance:GetServerState(data.channel) == BarrageStateEnum.Off and data.serverid ~= MyselfProxy.Instance:GetServerId() then
    return
  end
  local chat = ChatRoomProxy.Instance:RecvChatMessage(data)
  ChatZoomProxy.Instance:InQueueInputMessage(chat)
  Game.ChatSystemManager:AddNotifyChat(chat:GetChannel())
end

function ServiceChatCmdProxy:RecvUserReturnChatRoomRecordCmd(data)
end

function ServiceChatCmdProxy:RecvQueryVoiceUserCmd(data)
  helplog("RecvQueryVoiceUserCmd")
  if self.queryVoice == nil then
    self.queryVoice = {}
  end
  if self.queryVoice[data.msgid] == nil then
    self.queryVoice[data.msgid] = ByteArray()
  end
  self.queryVoice[data.msgid]:AddMergeByte(Slua.ToBytes(data.voice))
  if data.msgover then
    helplog("RecvQueryVoiceUserCmd data.msgover")
    local newData = {}
    newData.voiceid = data.voiceid
    newData.voice = Slua.ToString(self.queryVoice[data.msgid]:MergeByte())
    newData.path = ChatRoomProxy.Instance:RecvChatSpeech(newData)
    self:Notify(ServiceEvent.ChatCmdQueryVoiceUserCmd, newData)
    self.queryVoice[data.msgid] = nil
  end
end

function ServiceChatCmdProxy:RecvBarrageMsgChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdBarrageMsgChatCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.ChatCmdBarrageMsgChatCmd, data)
end

function ServiceChatCmdProxy:CallQueryItemData(guid, data)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.QueryItemData.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = ChatCmd_pb.QueryItemData()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  end
end

function ServiceChatCmdProxy:CallGetVoiceIDChatCmd(id)
  ChatRoomProxy.Instance:ResetVoiceId()
  ServiceChatCmdProxy.super.CallGetVoiceIDChatCmd(self, id)
end

function ServiceChatCmdProxy:RecvGetVoiceIDChatCmd(data)
  ChatRoomProxy.Instance:RecvGetVoiceIDChatCmd(data.id)
  self:Notify(ServiceEvent.ChatCmdGetVoiceIDChatCmd, data)
end

function ServiceChatCmdProxy:RecvLoveLetterNtf(data)
  StarProxy.Instance:RecvLoveLetterNtf(data)
  self:Notify(ServiceEvent.ChatCmdLoveLetterNtf, data)
end

function ServiceChatCmdProxy:RecvNpcChatNtf(data)
  ChatRoomProxy.Instance:RecvNpcChatNtf(data)
  self:Notify(ServiceEvent.ChatCmdNpcChatNtf, data)
end

function ServiceChatCmdProxy:RecvQueryRealtimeVoiceIDCmd(data)
  GVoiceProxy.Instance:RecvQueryRealtimeVoiceIDCmd(data)
  self:Notify(ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd, data)
end

function ServiceChatCmdProxy:RecvSystemBarrageChatCmd(data)
  BarrageProxy.Instance:RecvSystemBarrageChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdSystemBarrageChatCmd, data)
end

function ServiceChatCmdProxy:RecvQueryFavoriteExpressionChatCmd(data)
  ChatRoomProxy.Instance:RecvQueryFavoriteExpression(data)
  self:Notify(ServiceEvent.ChatCmdQueryFavoriteExpressionChatCmd, data)
end

function ServiceChatCmdProxy:RecvUpdateFavoriteExpressionChatCmd(data)
  ChatRoomProxy.Instance:RecvUpdateFavoriteExpression(data)
  self:Notify(ServiceEvent.ChatCmdUpdateFavoriteExpressionChatCmd, data)
end

function ServiceChatCmdProxy:RecvExpressionChatCmd(data)
  ChatRoomProxy.Instance:RecvExpressionChatCmd(data)
  self:Notify(ServiceEvent.ChatCmdExpressionChatCmd, data)
end

function ServiceChatCmdProxy:RecvFaceShowChatCmd(data)
  local target = SceneCreatureProxy.FindCreature(data.charid)
  if target then
    target.assetRole:SetExpression(data.id, true)
  end
end

function ServiceChatCmdProxy:RecvReceiveRedPacketRet(data)
  RedPacketProxy.Instance:RecvRedPacketInfo(data)
  self:Notify(ServiceEvent.ChatCmdReceiveRedPacketRet, data)
end

function ServiceChatCmdProxy:RecvQueryGuildRedPacketChatCmd(data)
  ChatRoomProxy.Instance:RecvQueryGuildRedPacketChat(data)
  self:Notify(ServiceEvent.ChatCmdCheckRecvRedPacketChatCmd, data)
end

function ServiceChatCmdProxy:RecvCheckRecvRedPacketChatCmd(data)
  ChatRoomProxy.Instance:RecvCheckRedPacket(data)
  self:Notify(ServiceEvent.ChatCmdCheckRecvRedPacketChatCmd, data)
end
