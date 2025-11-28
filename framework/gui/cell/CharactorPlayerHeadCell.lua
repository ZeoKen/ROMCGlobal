autoImport("PlayerFaceCell")
autoImport("MainViewHeadIconCell")
CharactorPlayerHeadCell = class("CharactorPlayerHeadCell", PlayerFaceCell)
local tempV3 = LuaVector3.Zero()

function CharactorPlayerHeadCell:Init()
  self.lvmat = "%s"
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  if self.proIcon then
    self.proIcon.transform.localPosition = tempV3
  end
  if self.proColor then
    self.proColor.width = 38
    self.proColor.height = 38
    self.proColor.spriteName = "new-com_icon_career_b"
    self.proColor.transform.localPosition = tempV3
  end
  self.name = self:FindComponent("name", UILabel)
  if self.name then
    self.nameObj = self.name.gameObject
  end
  self.level = self:FindComponent("level", UILabel)
  self.vip = self:FindComponent("vip", UILabel)
  self.hp = self:FindComponent("hp", UISlider)
  self.mp = self:FindComponent("mp", UISlider)
  self.levelBg = self:FindGO("bg_head")
  self.leadsymbol1 = self:FindGO("leadsymbol1")
  self.leadsymbol2 = self:FindGO("leadsymbol2")
  self.groupleadsymbol1 = self:FindGO("GroupLeadSymbol1")
  self.groupleadsymbol2 = self:FindGO("GroupLeadSymbol2")
  self:InitHeadIconCell()
  self:UpdateHeadIconPos()
  local frameObj = self:FindGO("PlayerFrameCell")
  if frameObj then
    self.frame = FrameCell.new(frameObj)
  end
  self.zoneid = self:FindComponent("Zone", UILabel)
  self:InitSymbols()
  self:AddCellClickEvent()
end

function CharactorPlayerHeadCell:InitHeadIconCell()
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
end

function CharactorPlayerHeadCell:SetPlayerPro(data)
  MainViewPlayerFaceCell.super.SetPlayerPro(self, data)
  self.proIcon.width = 28
end

function CharactorPlayerHeadCell:SetTeamLeaderSymbol(jobType, isLeaderTeamInGroup)
  if isLeaderTeamInGroup == nil then
    local myTeamData = TeamProxy.Instance.myTeam
    isLeaderTeamInGroup = myTeamData and myTeamData:IsLeaderTeamInGroup()
  end
  if self.leadsymbol1 then
    local isLeader = jobType == SessionTeam_pb.ETEAMJOB_LEADER
    self.leadsymbol1:SetActive((isLeader and not isLeaderTeamInGroup) == true)
    if self.groupleadsymbol1 then
      self.groupleadsymbol1:SetActive((isLeaderTeamInGroup and isLeader) == true)
    end
  end
  if self.leadsymbol2 then
    local isTmpLeader = jobType == SessionTeam_pb.ETEAMJOB_TEMPLEADER and not self.data.offline
    self.leadsymbol2:SetActive((isTmpLeader and not isLeaderTeamInGroup) == true)
    if self.groupleadsymbol2 then
      self.groupleadsymbol2:SetActive((isLeaderTeamInGroup and isTmpLeader) == true)
    end
  end
end
