SevenRoyalFamiliesProxy = class("SevenRoyalFamiliesProxy", pm.Proxy)

function SevenRoyalFamiliesProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "SevenRoyalFamiliesProxy"
  if SevenRoyalFamiliesProxy.Instance == nil then
    SevenRoyalFamiliesProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadSceneEvent.FinishLoadScene, self.PlayerMapChange, self)
end

function SevenRoyalFamiliesProxy:Init()
  self.evidenceData = {}
  self.characterSecret = {}
  self.unlockCharacter = {}
  self.skillInfos = {}
  self.skillStaticDatas = {}
  self.evidenceToolList = {}
  self.staticEvidenceTool = {}
  self:InitRelation()
  self:InitStaticSkillData()
  self:InitStaticToolList()
  self.dataInited = false
end

function SevenRoyalFamiliesProxy:InitRelation()
  if not Table_Relation then
    return
  end
  if not self.relationData then
    self.relationData = {}
  end
  for k, v in pairs(Table_Relation) do
    if v.State == 0 then
      xdlog("设置关系", v.From, v.To, v.Name)
      if v.From ~= 0 then
        if not self.relationData[v.From] then
          self.relationData[v.From] = {}
        end
        if v.To ~= 0 then
          self.relationData[v.From][v.To] = {
            State = v.State,
            Name = v.Name
          }
        end
      end
    end
  end
  self:RefreshUnlockCharacter()
end

function SevenRoyalFamiliesProxy:GetRelation()
  if not self.relationData then
    self:InitRelation()
  end
  return self.relationData
end

function SevenRoyalFamiliesProxy:RecvEvidenceQueryCmd(data)
  TableUtility.TableClear(self.evidenceData)
  self.dataInited = true
  local evidences = data.evidences
  if evidences and 0 < #evidences then
    for i = 1, #evidences do
      local single = evidences[i]
      local data = {}
      data.id = single.id
      data.unlockMessage = {}
      TableUtility.TableShallowCopy(data.unlockMessage, single.unlock_message)
      self.evidenceData[single.id] = data
    end
  else
    redlog("没证物")
  end
  self.nextHint = data.next_hint
  self.lastHintCD = data.last_hint_cd
  self:RefreshEvidenceTool()
end

function SevenRoyalFamiliesProxy:RefreshEvidenceTool()
  if not self.evidenceData then
    return
  end
  local curUsedList = {}
  for k, v in pairs(self.evidenceData) do
    local config = Table_Evidence[k]
    local totalMessage = config and config.Messages
    local unlockMessage = v.unlockMessage
    if totalMessage and unlockMessage then
      for i = 1, #unlockMessage do
        local single = unlockMessage[i]
        for j = 1, #totalMessage do
          if totalMessage[j].id == single and totalMessage[j].toolId then
            if not self.evidenceToolList[totalMessage[j].toolId] then
              self.evidenceToolList[totalMessage[j].toolId] = 1
            else
              self.evidenceToolList[totalMessage[j].toolId] = self.evidenceToolList[totalMessage[j].toolId] + 1
            end
          end
        end
      end
    end
  end
end

function SevenRoyalFamiliesProxy:RecvEvidencehintCmd(data)
  if not data then
    return
  end
  self.nextHint = data.next_hint
  self.lastHintCD = data.hint_cd
end

function SevenRoyalFamiliesProxy:RecvUnlockEvidenceMessageCmd(data)
  local evidenceId = data.evidence_id
  local messageId = data.message_id
  if self.evidenceData and self.evidenceData[evidenceId] then
    local data = self.evidenceData[evidenceId]
    local curUnlockMessage = data.unlockMessage
    if curUnlockMessage and 0 < #curUnlockMessage then
      if TableUtility.ArrayFindIndex(curUnlockMessage, messageId) == 0 then
        xdlog("增量线索解锁", messageId)
        table.insert(curUnlockMessage, messageId)
      end
    else
      xdlog("新增线索", messageId, evidenceId)
      local messages = {}
      messages[1] = messageId
      data.unlockMessage = messages
    end
  end
end

function SevenRoyalFamiliesProxy:RecvNewEvidenceUpdateCmd(data)
  local evidenceIds = data.evidence_ids
  if evidenceIds and 0 < #evidenceIds then
    for i = 1, #evidenceIds do
      local id = evidenceIds[i]
      local data = {}
      data.id = id
      data.isNew = true
      self.evidenceData[id] = data
      xdlog("解锁新增证物", id)
    end
  end
end

function SevenRoyalFamiliesProxy:SetEvidenceNew(id, bool)
  if self.evidenceData[id] then
    self.evidenceData[id].isNew = bool
  end
end

function SevenRoyalFamiliesProxy:RefreshUnlockCharacter()
  if not self.relationData then
    return
  end
  for k, v in pairs(self.relationData) do
    if not self.unlockCharacter[k] then
      self.unlockCharacter[k] = 1
    end
    for m, n in pairs(v) do
      if not self.unlockCharacter[m] then
        self.unlockCharacter[m] = 1
      end
    end
  end
end

function SevenRoyalFamiliesProxy:RecvQueryCharacterInfoCmd(data)
  local relations = data.relations
  if relations and 0 < #relations then
    for i = 1, #relations do
      local single = relations[i]
      local id = single.id
      for k, v in pairs(Table_Relation) do
        if v.RelationID == id and single.state == v.State then
          if v.From ~= 0 and not self.relationData[v.From] then
            self.relationData[v.From] = {}
          end
          xdlog("设置解锁关系", v.From, v.To, v.Name)
          if v.To ~= 0 then
            self.relationData[v.From][v.To] = {
              State = v.State,
              Name = v.Name
            }
          end
          break
        end
      end
    end
    self:RefreshUnlockCharacter()
  end
  local characters = data.characters
  if characters and 0 < #characters then
    for i = 1, #characters do
      local single = characters[i]
      if not self.characterSecret[single.character_id] then
        self.characterSecret[single.character_id] = {}
      end
      local data = {
        id = single.character_id
      }
      data.unlockSecrets = {}
      TableUtility.TableShallowCopy(data.unlockSecrets, single.unlock_secrets)
      self.characterSecret[single.character_id] = data
    end
  end
end

function SevenRoyalFamiliesProxy:RecvEnlightSecretCmd(data)
  local success = data.success
  local characterId = data.character_id
  local secretId = data.secret_id
  xdlog("解锁", success, characterId, secretId)
  if not self.characterSecret[characterId] then
    redlog("角色未解锁", characterId)
    return
  end
  local unlockSecret = self.characterSecret[characterId].unlockSecrets
  if unlockSecret and #unlockSecret then
    for i = 1, #unlockSecret do
      local single = unlockSecret[i]
      if single.secret_id == secretId then
        xdlog("设置已解锁", secretId, success)
        single.lighted = success
        break
      end
    end
  end
end

function SevenRoyalFamiliesProxy:GetCharacterSecret(characterid)
  if not self.characterSecret[characterid] then
    return
  end
  return self.characterSecret[characterid]
end

function SevenRoyalFamiliesProxy:RecvSkillPerceptAbilityNtf(data)
  local skills = data.skills
  if skills and 0 < #skills then
    for i = 1, #skills do
      local skill = skills[i]
      local data = {
        id = skill.skill,
        lv = skill.lv,
        state = skill.state
      }
      self.skillInfos[skill.skill] = data
    end
  end
end

function SevenRoyalFamiliesProxy:RecvSkillPerceptAbilityLvUpCmd(data)
  local skillid = data.skill
  local lv = data.count or 0
  if self.skillInfos[skillid] then
    self.skillInfos[skillid].lv = self.skillInfos[skillid].lv + lv
    xdlog("技能提升了等级", skillid, lv)
  end
end

function SevenRoyalFamiliesProxy:GetSkillInfo(skillId)
  if self.skillInfos[skillId] then
    return self.skillInfos[skillId]
  end
end

function SevenRoyalFamiliesProxy:InitStaticSkillData()
  if Table_SkillPerceptAbility then
    for k, v in pairs(Table_SkillPerceptAbility) do
      if v.SkillID then
        if not self.skillStaticDatas[v.SkillID] then
          self.skillStaticDatas[v.SkillID] = {}
        end
        self.skillStaticDatas[v.SkillID][v.Lv] = v
      end
    end
  end
end

function SevenRoyalFamiliesProxy:InitStaticToolList()
  for k, v in pairs(Table_Evidence) do
    local messages = v.Messages
    if messages and 0 < #messages then
      for i = 1, #messages do
        local toolId = messages[i].toolid
        if toolId then
          if not self.staticEvidenceTool[toolId] then
            xdlog("静态工具数据", toolId)
            self.staticEvidenceTool[toolId] = 1
          else
            self.staticEvidenceTool[toolId] = self.staticEvidenceTool[toolId] + 1
          end
        end
      end
    end
  end
end

function SevenRoyalFamiliesProxy:CallSkillInfos()
  ServiceSkillProxy.Instance:CallSkillPerceptAbilityNtf()
end

function SevenRoyalFamiliesProxy:PlayerMapChange()
  local curMapId = Game.MapManager:GetMapID()
  local config = GameConfig.SevenRoyalFamilies
  if config and config.ApperceiveMapID and TableUtility.ArrayFindIndex(config.ApperceiveMapID, curMapId) > 0 then
    self:CallSkillInfos()
  end
end

function SevenRoyalFamiliesProxy:IsDataInited()
  return self.dataInited
end

function SevenRoyalFamiliesProxy:InitTestData()
  self.skillInfos[1] = {id = 1, lv = 2}
  self.skillInfos[2] = {id = 2, lv = 0}
end
