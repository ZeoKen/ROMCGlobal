RedPacketProxy = class("RedPacketProxy", pm.Proxy)
RedPacketProxy.Instance = nil
RedPacketProxy.NAME = "RedPacketProxy"

function RedPacketProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RedPacketProxy.NAME
  if RedPacketProxy.Instance == nil then
    RedPacketProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RedPacketProxy:Init()
  self.contents = {}
  self.receiveInfo = {}
  self.availableMap = {}
  self.gvgPlayers = {}
  self.blessedPlayers = {}
  self.blessSelectedMap = {}
end

function RedPacketProxy:RecvRedPacketInfo(data)
  if data.bRedPacketExist then
    local guid = data.strRedPacketID
    local serverContent = data.content
    self:UpdateRedPacketContent(guid, serverContent)
    if data.bRedPacketUsable then
      local receiveItems = {}
      if data.receive_multi_items then
        for i = 1, #data.receive_multi_items do
          local item = {}
          item.itemid = data.receive_multi_items[i].itemid
          item.group_count = data.receive_multi_items[i].group_count
          receiveItems[i] = item
        end
      end
      self.receiveInfo[guid] = {
        receiveMoney = data.thisReceiveMoney,
        receiveItems = receiveItems
      }
      self:UpdateAvailableMap(guid, false)
      local channel = ChatRoomProxy.Instance:GetChatRoomChannel()
      ChatRoomProxy.Instance:CheckRedPacketRedTip(channel)
    end
  end
end

function RedPacketProxy:UpdateRedPacketContent(guid, serverContent)
  local content = self.contents[guid]
  if not content then
    content = {}
    self.contents[guid] = content
  end
  content.redPacketCFGID = serverContent.redPacketCFGID
  content.overtime = serverContent.overtime
  content.restMoney = serverContent.restMoney
  content.restNum = serverContent.restNum
  content.totalMoney = serverContent.totalMoney
  content.totalNum = serverContent.totalNum
  content.receivedInfos = serverContent.receivedInfos
  content.restMultiItems = serverContent.rest_multi_items
end

function RedPacketProxy:CheckIfReceived(redPacketGUID)
  return self.receiveInfo[redPacketGUID] ~= nil
end

function RedPacketProxy:IsRedPacketContentExist(redPacketGUID)
  return self:GetRedPacketContent(redPacketGUID) ~= nil
end

function RedPacketProxy:GetRedPacketContent(redPacketGUID)
  return self.contents[redPacketGUID]
end

function RedPacketProxy:GetReceivedInfo(redPacketGUID)
  return self.receiveInfo[redPacketGUID]
end

function RedPacketProxy:UpdateAvailableMap(redPacketGUID, available)
  self.availableMap[redPacketGUID] = available
end

function RedPacketProxy:IsRedPacketCanReceive(redPacketGUID)
  return self.availableMap[redPacketGUID]
end

function RedPacketProxy:SetGVGPlayerInfos(redPacketGUID, gvgPlayers, blessedPlayers)
  self:SetGVGPlayers(redPacketGUID, gvgPlayers)
  self:SetBlessedPlayers(redPacketGUID, blessedPlayers)
end

function RedPacketProxy:SetGVGPlayers(redPacketGUID, players)
  if not players then
    return
  end
  local infos = self.gvgPlayers[redPacketGUID]
  if not infos then
    infos = {}
    self.gvgPlayers[redPacketGUID] = infos
    for i = 1, #players do
      infos[i] = players[i]
    end
  end
end

function RedPacketProxy:SetBlessedPlayers(redPacketGUID, players)
  if not players then
    return
  end
  local infos = self.blessedPlayers[redPacketGUID]
  if not infos then
    infos = {}
    self.blessedPlayers[redPacketGUID] = infos
    for i = 1, #players do
      infos[i] = players[i]
    end
  end
end

function RedPacketProxy:IsMyselfBlessed(redPacketGUID)
  local players = self.blessedPlayers[redPacketGUID]
  if players then
    return TableUtility.ArrayFindIndex(players, Game.Myself.data.id) > 0
  end
  return false
end

function RedPacketProxy:GetGVGPlayerNum(redPacketGUID)
  local players = self.gvgPlayers[redPacketGUID]
  return players and #players or 0
end

function RedPacketProxy:IsMyselfQualifiedToReceiveGVGRedPacket(redPacketGUID)
  local players = self.gvgPlayers[redPacketGUID]
  if players then
    return TableUtility.ArrayFindIndex(players, Game.Myself.data.id) > 0
  end
  return true
end

function RedPacketProxy:GetBlessedPlayerNum(redPacketGUID)
  local players = self.blessedPlayers[redPacketGUID]
  return players and #players or 0
end

function RedPacketProxy:SetBlessSelect(redPacketId, charId, select)
  if not self.blessSelectedMap[redPacketId] then
    self.blessSelectedMap[redPacketId] = {}
  end
  self.blessSelectedMap[redPacketId][charId] = select
end

function RedPacketProxy:IsBlessSelected(redPacketId, charId)
  if self.blessSelectedMap[redPacketId] then
    return self.blessSelectedMap[redPacketId][charId]
  end
  return false
end

function RedPacketProxy:ClearBlessSelectState(redPacketId)
  self.blessSelectedMap[redPacketId] = nil
end

function RedPacketProxy:GetGVGNewMaxRedPacketNum()
  local blessAddNum = GameConfig.GvgNewConfig.red_packet_praise_add or 1
  local maxMercenaryMemberNum = GameConfig.Guild.MaxMercenaryMemberCount
  local maxGuildLevel = GuildProxy.Instance:GetGuildMaxLevel()
  local maxGuildMemberNum = Table_Guild[maxGuildLevel] and Table_Guild[maxGuildLevel].MemberNum or 100
  local maxBlessNum = 0
  if GameConfig.GvgNewConfig.citytype_data then
    for _, v in pairs(GameConfig.GvgNewConfig.citytype_data) do
      maxBlessNum = math.max(v.praise_red_packet_cnt, maxBlessNum)
    end
  end
  return maxGuildMemberNum + maxMercenaryMemberNum + maxBlessNum * blessAddNum
end

function RedPacketProxy:GetGVGNewRedPacketMultiItemRawNum(gvgPlayerNum, blessNum, maxRedPacketNum, item_count, group_count)
  local ratio = (gvgPlayerNum + blessNum) / maxRedPacketNum
  return item_count * math.floor(group_count * ratio)
end
