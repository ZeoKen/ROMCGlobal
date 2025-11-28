MainViewThanatosSecondPage = class("MainViewThanatosSecondPage", SubMediatorView)
local cmdArgs = {}
local LabelOffset = 32

function MainViewThanatosSecondPage:Show(tarObj)
  self:TryInit()
  self:UpdateView()
  MainViewThanatosSecondPage.super.Show(self, tarObj)
  self.isIn = true
  FunctionBuff.Me():AddInterest(self.ConfigThanatos.MortalBuff)
  self:ReParent()
  ServiceFuBenCmdProxy.Instance:CallQueryTeamGroupRaidUserInfo()
end

function MainViewThanatosSecondPage:Hide(target)
  MainViewThanatosSecondPage.super.Hide(self, target)
  self.isIn = false
  self.inited = false
  FunctionBuff.Me():RemoveInterest(self.ConfigThanatos.MortalBuff)
end

function MainViewThanatosSecondPage:Init()
  self:AddViewEvts()
end

function MainViewThanatosSecondPage:TryInit()
  if not self.loaded then
    local container = self:FindGO("MainViewThanatosPage")
    self:ReLoadPerferb("view/MainViewThanatosSecondPage")
    self:ResetParent(container)
    self.loaded = true
  end
  if not self.inited then
    self:InitConfig()
    self:FindObjs()
    self:InitView()
  end
end

function MainViewThanatosSecondPage:InitConfig()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  if tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
    self.attentionBuffs = self.ConfigThanatos.AttentionBuffID
    self.bossID = tgConfig.BossID[1]
    self.raidname = tgConfig.NameZh
  end
end

function MainViewThanatosSecondPage:FindObjs()
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.keyRoot = self:FindGO("KeyRoot")
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.hpPercent = self:FindGO("HPPercent"):GetComponent(UILabel)
  self.keyPercent = self:FindGO("KeyPercent"):GetComponent(UILabel)
end

function MainViewThanatosSecondPage:InitView()
  local headicon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  local config = Table_Monster[self.bossID]
  IconManager:SetFaceIcon(config.Icon, headicon)
  self:AddButtonEvent("MagicHeadCell", function()
    local npc = NSceneNpcProxy.Instance:Find(self.magicCubeGuid)
    if npc then
      local pos = npc:GetPosition()
      cmdArgs.targetMapID = SceneProxy.Instance:GetCurMapID()
      cmdArgs.targetPos = LuaGeometry.GetTempVector3(pos[1] or 0, pos[2] or 0, pos[3] or 0)
      cmdArgs.npcID = self.bossID
      local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
      Game.Myself:Client_SetMissionCommand(cmd)
    end
  end)
end

function MainViewThanatosSecondPage:AddViewEvts()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamGroupRaidUpdateChipNum, self.HandleUpdateKey)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
end

function MainViewThanatosSecondPage:ResetParent(parent)
  if not parent then
    return
  end
  self.trans:SetParent(parent.transform, false)
end

function MainViewThanatosSecondPage:UpdateView()
  self.title.text = self.raidname
  self:UpdateHP()
  self:UpdateKey()
end

function MainViewThanatosSecondPage:UpdateHP()
  local magicCube = NSceneNpcProxy.Instance:Find(self.magicCubeGuid)
  local value = 1
  if magicCube ~= nil then
    local props = magicCube.data.props
    value = props:GetPropByName("Hp"):GetValue() / props:GetPropByName("MaxHp"):GetValue()
  end
  self:UpdateHPValue(value)
  self:ShowKey(value <= self.ConfigThanatos.MagicStateThirdHpPer)
end

function MainViewThanatosSecondPage:UpdateHPValue(value)
  self.hpProgress.value = value
  self.hpPercent.text = string.format("%d%%", value * 100)
end

function MainViewThanatosSecondPage:UpdateKey(key)
  self.keyPercent.text = string.format("%d/%d", key or 0, self.ConfigThanatos.MagicKeyMaxCount)
end

function MainViewThanatosSecondPage:ShowKey(isShow)
  if self.keyRoot.activeSelf ~= isShow then
    self.keyRoot:SetActive(isShow)
    local offset = -LabelOffset
    if isShow then
      offset = LabelOffset
      self:UpdateKey()
    end
    self.bg.height = self.bg.height + offset
  end
end

function MainViewThanatosSecondPage:HandleAddNpc(note)
  if not self.isIn then
    return
  end
  if self.magicCubeGuid ~= nil then
    return
  end
  local data = note.body
  if data then
    local npcData
    for i = 1, #data do
      npcData = data[i].data
      if npcData.staticData.id == self.bossID then
        self.magicCubeGuid = npcData.id
        self.gameObject:SetActive(true)
        self:UpdateHP()
      end
    end
  end
  if self.magicCubeGuid == nil and self.gameObject.activeSelf then
    self.gameObject:SetActive(false)
  end
end

function MainViewThanatosSecondPage:HandleRemoveNpc(note)
  if not self.isIn then
    return
  end
  if self.magicCubeGuid == nil then
    return
  end
  local data = note.body
  if data then
    for i = 1, #data do
      if data[i] == self.magicCubeGuid then
        self.magicCubeGuid = nil
        self.gameObject:SetActive(false)
      end
    end
  end
end

function MainViewThanatosSecondPage:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  if self.magicCubeGuid == nil then
    return
  end
  local data = note.body
  if data and data.guid == self.magicCubeGuid and #data.attrs > 0 then
    self:UpdateHP()
  end
end

function MainViewThanatosSecondPage:HandleUpdateKey(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    self:UpdateKey(data.chipnum)
  end
end

function MainViewThanatosSecondPage:HandleBuff(note)
  if not self.isIn then
    return
  end
  if self.magicCubeGuid == nil then
    return
  end
  local data = note.body
  if data and data.guid == self.magicCubeGuid then
    local updates = data.updates
    for i = 1, #updates do
      if updates[i].id == self.ConfigThanatos.MortalBuff then
        self:UpdateHPValue(0)
      end
    end
  end
end

function MainViewThanatosSecondPage:ReParent()
  local thanatosParent = self.gameObject.transform.parent
  local raidinfoParent = Game.GameObjectUtil:DeepFindChild(thanatosParent.gameObject, "RaidInfo")
  self.gameObject.transform.parent = raidinfoParent.gameObject.transform
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end
