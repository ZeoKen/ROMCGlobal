autoImport("ChatItemCell")
RedPacketItemCell = class("RedPacketItemCell", ChatItemCell)

function RedPacketItemCell:SetData(data)
  self.data = data
  if data then
    ChatItemCell.super.SetData(self, data)
  end
end

function RedPacketItemCell:SetUseItemInvalid(data)
  local invalid = self:CheckIfItemInvalid(data)
  self:SetInvalid(invalid)
end

function RedPacketItemCell:CheckIfItemInvalid(data)
  local config = Table_RedPacket[data.redPacketData.staticId]
  if not config then
    return true
  end
  local curChannel = ChatRoomProxy.Instance:GetChatRoomChannel()
  if curChannel == ChatChannelEnum.GVG and GuildProxy.Instance:DoIHaveMercenaryGuild() then
    return true
  end
  local invalid = TableUtility.ArrayFindIndex(config.channel, curChannel) == 0
  return invalid
end
