local baseCell = autoImport("BaseCell")
AnnounceQuestPanelTeamMemberPortrail = class("AnnounceClassmateShowCell", baseCell)

function AnnounceQuestPanelTeamMemberPortrail:Init()
  self:initView()
end

function AnnounceQuestPanelTeamMemberPortrail:initView()
  local teamHead = self:FindGO("TeamHead")
  self.teamHead = PlayerFaceCell.new(teamHead)
  self.teamHead:SetMinDepth(40)
  self.headData = HeadImageData.new()
  if self.gameObject then
    local scale = LuaVector3.One()
    LuaVector3.Mul(scale, 0.4)
    self.gameObject.transform.localScale = scale
  end
end

function AnnounceQuestPanelTeamMemberPortrail:SetData(data)
  self.headData:Reset()
  self.headData:TransByTeamMemberData(data)
  self.teamHead:SetData(self.headData)
end
