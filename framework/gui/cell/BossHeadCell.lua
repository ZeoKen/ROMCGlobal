local BaseCell = autoImport("BaseCell")
BossHeadCell = class("BossHeadCell", BaseCell)

function BossHeadCell:Init()
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.hpPercent = self:FindGO("hpPercent"):GetComponent(UILabel)
  self.headicon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  self.bossName = self:FindGO("bossName"):GetComponent(UILabel)
  self:AddCellClickEvent()
end

function BossHeadCell:SetData(staticID, guid)
  if staticID and guid then
    self.bossGuid = guid
    self.staticID = staticID
    local bossConfig = Table_Monster[staticID]
    IconManager:SetFaceIcon(bossConfig.Icon, self.headicon)
    self.bossName.text = bossConfig.NameZh
  end
end

local tempPos = LuaVector3()

function BossHeadCell:OnClick()
  local creature = NSceneNpcProxy.Instance:Find(self.bossGuid)
  if creature then
    local cmdArgs = {}
    cmdArgs.targetMapID = SceneProxy.Instance:GetCurMapID()
    LuaVector3.Better_Set(tempPos, creature:GetPosition()[1], creature:GetPosition()[2], creature:GetPosition()[3])
    cmdArgs.targetPos = tempPos
    cmdArgs.npcID = self.bossID
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
    Game.Myself:Client_SetMissionCommand(cmd)
  end
end

function BossHeadCell:UpdateHP(bossguid)
  if bossguid ~= self.bossGuid then
    return
  end
  local bossCreature = NSceneNpcProxy.Instance:Find(self.bossGuid)
  if bossCreature ~= nil then
    local props = bossCreature.data.props
    local maxHP = props:GetPropByName("MaxHp"):GetValue()
    if maxHP and maxHP ~= 0 then
      local value = props:GetPropByName("Hp"):GetValue() / maxHP
      self.hpProgress.value = value
      self.hpPercent.text = string.format("%d%%", value * 100)
    end
  else
    self.hpProgress.value = 0
    self.hpPercent.text = "0%"
  end
end
