autoImport("PlayerFaceCell")
autoImport("MainViewHeadIconCell")
MainViewPlayerFaceCell = class("MainViewPlayerFaceCell", PlayerFaceCell)
local tempV3 = LuaVector3.Zero()

function MainViewPlayerFaceCell:Init()
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
  if self.hp then
    self.hp_foreground = self:FindComponent("foreground", UISprite, self.hp.gameObject)
  end
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
  self.prestigeGO = self:FindGO("PrestigeLevelBG")
  if self.prestigeGO then
    self.prestigeBg = self.prestigeGO:GetComponent(UIMultiSprite)
    self.prestigeLevel = self:FindGO("PrestigeLevel", self.prestigeGO):GetComponent(UILabel)
  end
  self:InitSymbols()
  self:AddCellClickEvent()
end

function MainViewPlayerFaceCell:InitHeadIconCell()
  self.headIconCell = MainViewHeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
end

function MainViewPlayerFaceCell:SetHeadIconPos(isUp)
  if isUp then
    self.headIconCell:SetIconLoaclPosXYZ(-2.5, -59, 0)
  else
    self.headIconCell:SetIconLoaclPosXYZ(-2.5, -59, 0)
  end
end

function MainViewPlayerFaceCell:SetPlayerPro(data)
  MainViewPlayerFaceCell.super.SetPlayerPro(self, data)
  self.proIcon.width = 28
end

function MainViewPlayerFaceCell:SetTeamLeaderSymbol(jobType, isLeaderTeamInGroup)
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

function MainViewPlayerFaceCell:updateGmeInfo()
  if self.headIconCell ~= nil then
    self.headIconCell:onTeamUpdate()
  end
end

function MainViewPlayerFaceCell:onEnterTeam()
  if self.headIconCell ~= nil then
    self.headIconCell:onEnterTeam()
  end
end

function MainViewPlayerFaceCell:UpdateHp(value, updateBuffHpBg)
  MainViewPlayerFaceCell.super.UpdateHp(self, value)
  if self.hp_foreground then
    if updateBuffHpBg == true then
      self.hp_foreground.spriteName = "new-com_bg_line_05"
      self.hp_foreground.color = LuaGeometry.GetTempColor(0.996078431372549, 0.803921568627451, 0.19215686274509805, 1)
    elseif updateBuffHpBg == false then
      self.hp_foreground.spriteName = "new-com_bg_line_02"
      self.hp_foreground.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    end
  end
end

function MainViewPlayerFaceCell:ShowEffect()
  if self.headIconCell then
    self.headIconCell:ShowEffect()
  end
end

function MainViewPlayerFaceCell:ClearEffect()
  if self.headIconCell then
    self.headIconCell:ClearEffect()
  end
end
