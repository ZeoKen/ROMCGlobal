autoImport("MainViewPlayerFaceCell")
local BaseCell = autoImport("BaseCell")
DisneyQTEMemberCell = class("DisneyQTEMemberCell", BaseCell)

function DisneyQTEMemberCell:Init()
  DisneyQTEMemberCell.super.Init(self)
  local teamHead = self:FindGO("TeamHead")
  self.teamHead = MainViewPlayerFaceCell.new(teamHead)
  self.teamHead:SetMinDepth(40)
  self.teamHead:SetHeadIconPos(false)
  self.headData = HeadImageData.new()
end

function DisneyQTEMemberCell:SetData(data)
  self.data = data
  local isEmpty = data == MyselfTeamData.EMPTY_STATE
  if isEmpty then
  end
  local hasData = type(data) == "table"
  if hasData then
    self.id = self.data.id
  end
  self:_UpdateHeadIcon()
end

function DisneyQTEMemberCell:_UpdateHeadIcon(update)
  if type(self.data) ~= "table" then
    self.teamHead:SetData(nil)
    return
  end
  if update then
    self.data = update
  end
  self.headData:Reset()
  self.headData:TransByTeamMemberData(self.data, true)
  local monsterID = DisneyStageProxy.Instance:GetHeroId(self.id)
  local isMemberDataInStage = self.data.mapid == 1900079
  local canFindNPlayerInScene = SceneCreatureProxy.FindCreature(self.id) ~= nil
  if isMemberDataInStage and canFindNPlayerInScene and monsterID then
    local ori_name = self.headData.name
    local ori_profession = self.headData.profession
    local ori_level = self.headData.level
    self.headData:TransByNpcData(monsterID and Table_Npc[monsterID])
    self.headData.name = ori_name
    self.headData.profession = ori_profession
    self.headData.level = ori_level
  end
  self.teamHead:SetData(self.headData)
end
