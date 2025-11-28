autoImport("ItemData")
local BaseCell = autoImport("BaseCell")
GuildEventCell = class("GuildEventCell", BaseCell)
local GUILD_TREASURE_EVENT_ID = 25

function GuildEventCell:Init()
  self.time = self:FindComponent("Time", UILabel)
  self.line = self:FindComponent("line", UIWidget)
  self.event = self:FindComponent("Event", UILabel)
  self:AddClickEvent(self.event.gameObject, function()
    if self.data then
      local eventID = self.data.type
      local time = self.data.time
      if self.data.type == GUILD_TREASURE_EVENT_ID then
        local queryID = self.data.id
        helplog("CallQueryTreasureResultGuildCmd--> queryID: ", queryID)
        ServiceGuildCmdProxy.Instance:CallQueryTreasureResultGuildCmd(queryID)
      end
    end
  end)
  self.clickUrl = self.event:GetComponent(UILabelClickUrl)
  if self.clickUrl then
    function self.clickUrl.callback(url)
      self:OnClickUrl(url)
    end
  end
end

function GuildEventCell:SetData(data)
  if data then
    self.data = data
    self.gameObject:SetActive(true)
    self:FormatTimeStr(data.time)
    self:FormatIncidentStr(data.type, data.params)
  else
    self.gameObject:SetActive(false)
  end
end

function GuildEventCell:FormatTimeStr(time)
  local nowDateInfo = os.date("*t", ServerTime.CurServerTime() / 1000)
  local timeDateInfo = os.date("*t", time)
  if nowDateInfo.month > timeDateInfo.month or nowDateInfo.year > timeDateInfo.year then
    self.time.text = ZhString.GuildEventCell_TimeTipMonth
  else
    local deltaDay = nowDateInfo.yday - timeDateInfo.yday
    if 1 < deltaDay then
      self.time.text = string.format(ZhString.GuildEventCell_TimeTipDay, deltaDay)
    elseif deltaDay == 1 then
      self.time.text = ZhString.GuildEventCell_TimeTipYestaday
    else
      self.time.text = string.format("%02d:%02d", timeDateInfo.hour, timeDateInfo.min)
    end
  end
end

local content
local strFormat = string.format

function GuildEventCell:FormatIncidentStr(incidentType, params)
  local incidentConfig = incidentType and Table_Guild_Incident[incidentType]
  if incidentConfig then
    if params then
      content = MsgParserProxy.Instance:TryParse(incidentConfig.txt, unpack(params))
    else
      content = incidentConfig.txt
    end
    if incidentType == GUILD_TREASURE_EVENT_ID then
      content = strFormat(ZhString.GuildEventCell_GuildTreasure, content)
    else
      content = MsgParserProxy.Instance:ParseIlItemInfo(content)
    end
    self.event.text = content
  else
    self.event.text = strFormat("Type:%s not find in Table_Guild_Incident.", tostring(incidentType))
  end
  self.event:ProcessText()
  self.time:UpdateAnchors()
  self.line:UpdateAnchors()
end

local itemTipData = {
  funcConfig = {}
}
local tipOffset = {20, -80}

function GuildEventCell:OnClickUrl(url)
  local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
  local urlType = split[1]
  if urlType == "configitem" then
    local itemId = split[2]
    if type(itemId) == "string" then
      itemId = tonumber(itemId)
    end
    if not self.tipItemData then
      self.tipItemData = ItemData.new("GuildEventCell", itemId)
    else
      self.tipItemData:ResetData("GuildEventCell", itemId)
    end
    itemTipData.itemdata = self.tipItemData
    self:ShowItemTip(itemTipData, self.event, NGUIUtil.AnchorSide.Center, tipOffset)
  end
end
