autoImport("BaseCell")
autoImport("HeadIconCell")
RedPacketReceiverCell = class("RedPacketReceiverCell", BaseCell)
local jobLabelColor = {
  [ChatChannelEnum.Guild] = "0090ff",
  [ChatChannelEnum.GVG] = "239500"
}
local centerBtnPosY = -3.3

function RedPacketReceiverCell:Init()
  self.headContainer = self:FindGO("HeadContainer")
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.guildNameLabel = self:FindComponent("GuildName", UILabel)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.jobLabel = self:FindComponent("Job", UILabel)
  self.chooseBtn = self:FindGO("chooseBtn")
  self:AddClickEvent(self.chooseBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
    self:SetSelectState(true)
  end)
  self.selectedBtn = self:FindGO("selectedBtn")
end

function RedPacketReceiverCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  if data.guid then
    self.id = data.guid
    self.nameLabel.text = data.name
    self.guildNameLabel.text = data.guildname
    self.levelLabel.text = "Lv." .. data.level
    self.headIcon = HeadIconCell.new()
    self.headIcon:CreateSelf(self.headContainer)
    self.headIcon:SetScale(0.6)
    self.headIcon:SetMinDepth(1)
    self:SetEvent(self.headIcon.clickObj.gameObject, function()
      self:PassEvent(FriendEvent.SelectHead, self)
    end)
    local headData = Table_HeadImage[data.portrait]
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
      self.headIcon:SetPortraitFrame(data.portraitframe)
      self.headIcon:SetAfkIcon(AfkProxy.ParseIsAfk(data.afk))
    else
      self.headIcon:SetData(data)
    end
  elseif data.guildData then
    self.id = data.id
    self.nameLabel.text = data.name
    self.guildNameLabel.text = data.guildData.name
    self.levelLabel.text = "Lv." .. data.baselevel
    self.headIcon = HeadIconCell.new()
    self.headIcon:CreateSelf(self.headContainer)
    self.headIcon:SetScale(0.6)
    self.headIcon:SetMinDepth(1)
    self:SetEvent(self.headIcon.clickObj.gameObject, function()
      self:PassEvent(FriendEvent.SelectHead, self)
    end)
    local headData = HeadImageData.new()
    headData:TransByGuildMemberData(data)
    self.headIcon:SetData(headData.iconData)
  else
    self.job = data.job
    self.num = data.num
    local name
    if data.job then
      local guildData = GuildProxy.Instance:DoIHaveMercenaryGuild() and GuildProxy.Instance:GetMyMercenaryGuildData() or GuildProxy.Instance.myGuildData
      name = guildData:GetJobName(data.job)
    else
      name = ZhString.RedPacket_AllMembers
    end
    self.jobLabel.text = string.format("%s(%s)", name, data.num)
    data.name = name
    local _, color = ColorUtil.TryParseHexString(jobLabelColor[data.channel])
    self.jobLabel.color = color
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.chooseBtn)
    y = centerBtnPosY
    LuaGameObject.SetLocalPositionGO(self.chooseBtn, x, y, z)
    LuaGameObject.SetLocalPositionGO(self.selectedBtn, x, y, z)
  end
end

function RedPacketReceiverCell:SetSelectState(state)
  self.chooseBtn:SetActive(not state)
  self.selectedBtn:SetActive(state)
end
