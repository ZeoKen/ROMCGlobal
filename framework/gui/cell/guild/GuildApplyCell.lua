local BaseCell = autoImport("BaseCell")
GuildApplyCell = class("GuildApplyCell", BaseCell)
GuildApplyCell.DoProgress = "GuildApplyCell_DoProgress"
GuildApplyCell.SelectHead = "GuildApplyCell_SelectHead"
GuildApplyCell.ShowDetail = "GuildApplyCell_ShowDetail"
autoImport("PlayerFaceCell")

function GuildApplyCell:Init()
  self.headCell = self:FindGO("PlayerHeadCell")
  self.headCell = PlayerFaceCell.new(self.headCell)
  self.name = self:FindComponent("Name", UILabel)
  self.lv = self:FindComponent("Level", UILabel)
  self.sex = self:FindComponent("GenderIcon", UISprite)
  self.tip = self:FindComponent("AddGuildInfo", UILabel)
  self.serverGO = self:FindGO("ServerGO")
  self.serverID = self:FindGO("ServerId"):GetComponent(UILabel)
  self.zoneGo = self:FindGO("ZoneGO")
  self.zoneId = self:FindGO("ZoneId"):GetComponent(UILabel)
  self:AddClickEvent(self.headCell.headIconCell.clickObj.gameObject, function()
    self:PassEvent(GuildApplyCell.SelectHead, self)
  end)
  local searchButton = self:FindGO("SearchBtn")
  self:AddClickEvent(searchButton, function(go)
    self:PassEvent(GuildApplyCell.ShowDetail, self)
  end)
  local agreeButton = self:FindGO("AgreeBtn")
  self:AddClickEvent(agreeButton, function(go)
    self:PassEvent(GuildApplyCell.DoProgress, {self, true})
  end)
  local refuseButton = self:FindGO("RefuseBtn")
  self:AddClickEvent(refuseButton, function(go)
    self:PassEvent(GuildApplyCell.DoProgress, {self, false})
  end)
end

function GuildApplyCell:SetData(data)
  self.data = data
  if data then
    local headData = HeadImageData.new()
    headData:TransByGuildMemberData(data)
    self.headCell:SetData(headData)
    self.name.text = data.name
    self.lv.text = string.format("Lv.%s", data.baselevel)
    self.sex.spriteName = data:IsBoy() and "friend_icon_man" or "friend_icon_woman"
    if data:IsMercenaryApply() then
      self.tip.text = ZhString.GuildApplyListMercenary
    else
      self.tip.text = ZhString.GuildApplyListMember
    end
    if data.serverid and data.serverid ~= 0 and data.serverid ~= GuildProxy.Instance:GetMyGuildServerId() then
      self.zoneGo:SetActive(false)
      self.serverGO:SetActive(true)
      self.serverID.text = data.serverid
    elseif data.zoneid and data.zoneid ~= 0 and data.zoneid ~= ChangeZoneProxy.Instance:GetSimpleZoneId(GuildProxy.Instance:GetMyGuildZoneId()) then
      self.serverGO:SetActive(false)
      self.zoneGo:SetActive(true)
      self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
    else
      self.serverGO:SetActive(false)
      self.zoneGo:SetActive(false)
    end
  end
end
