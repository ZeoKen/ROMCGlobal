GuildMemberBifrostInfoCell = class("GuildMemberBifrostInfoCell", BaseCell)

function GuildMemberBifrostInfoCell:Init()
  self:FindObjs()
  self.isActive = true
end

function GuildMemberBifrostInfoCell:FindObjs()
  self.objLine = self:FindGO("objLine")
  self.labname = self:FindComponent("labName", UILabel)
  self.labRank = self:FindComponent("labRank", UILabel)
  self.labToday = self:FindComponent("labToday", UILabel)
  self.labTotal = self:FindComponent("labTotal", UILabel)
  self.root = self:FindGO("Root")
end

local color = Color(0.20392156862745098, 0.5137254901960784, 1.0, 1)

function GuildMemberBifrostInfoCell:SetData(data)
  self.data = data
  if data then
    self.root:SetActive(true)
    self.id = data.guildid
    self.labname.text = data.name
    self.labRank.text = data.rank
    self.labToday.text = data.dayscore
    self.labTotal.text = data.totalscore
  else
    self.root:SetActive(false)
  end
end

function GuildMemberBifrostInfoCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
