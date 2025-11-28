AbyssBossHeadCell = class("AbyssBossHeadCell", BaseCell)
local tempPos = LuaVector3()

function AbyssBossHeadCell:Init()
  self:FindObjs()
end

function AbyssBossHeadCell:FindObjs()
  self.natureIcon = self:FindComponent("natureIcon", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.mask = self:FindGO("mask")
  self.progress = self:FindComponent("progress", UILabel)
  self:AddCellClickEvent()
end

function AbyssBossHeadCell:SetData(data)
  self.monsterId = data.npcID
  self.data = data
  local config = Table_Monster[self.monsterId]
  if config then
    IconManager:SetFaceIcon(config.Icon, self.icon)
  else
    IconManager:SetFaceIcon("common", self.icon)
  end
  if data.summon_process and data.summon_process >= 0 and self.monsterId == 0 then
    self.progress.text = string.format("%d%%", data.summon_process)
    self.mask:SetActive(true)
  else
    self.progress.text = ""
    self.mask:SetActive(false)
  end
end

function AbyssBossHeadCell:OnClick()
  local cmdArgs = {}
  cmdArgs.targetMapID = SceneProxy.Instance:GetCurMapID()
  local mPos = self.data:GetPos()
  LuaVector3.Better_Set(tempPos, mPos[1], mPos[2], mPos[3])
  cmdArgs.targetPos = tempPos
  cmdArgs.npcID = self.monsterId
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  Game.Myself:Client_SetMissionCommand(cmd)
end
