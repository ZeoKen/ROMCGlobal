local BaseCell = autoImport("BaseCell")
GuildRecruitCell = class("GuildRecruitCell", BaseCell)

function GuildRecruitCell:Init()
  self:FindObjs()
end

function GuildRecruitCell:FindObjs()
  self.dottedUnderline = self:FindGO("dot")
end

function GuildRecruitCell:SetData(data)
end
