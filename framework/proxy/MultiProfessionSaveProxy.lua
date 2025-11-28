autoImport("UserSaveInfoData")
autoImport("UserSaveSlotData")
autoImport("AstrolMaterialData")
MultiProfessionSaveProxy = class("MultiProfessionSaveProxy", pm.Proxy)
MultiProfessionSaveProxy.Instance = nil
MultiProfessionSaveProxy.NAME = "MultiProfessionSaveProxy"

function MultiProfessionSaveProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MultiProfessionSaveProxy.NAME
  if MultiProfessionSaveProxy.Instance == nil then
    MultiProfessionSaveProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.slotDatas = {}
  self.recordDatas = {}
end

function MultiProfessionSaveProxy:HasInfo()
  return self.recordDatas and next(self.recordDatas) or self.recvServerInfo
end

function MultiProfessionSaveProxy:RecvUpdateRecordInfoUserCmd(serverdata)
  local _records = serverdata.records
  for i = 1, #_records do
    local single = UserSaveInfoData.new(_records[i])
    self.recordDatas[single.id] = single
    local n = #self.slotDatas
    for i = 1, n do
      if self.slotDatas[i].id == single.id then
        self.slotDatas[i]:ResetRecordTime(single.recordtime)
        self.slotDatas[i]:SetRecordName(single.recordname)
      end
    end
    self.recvServerInfo = true
  end
  local _slots = serverdata.slots
  local _delete = serverdata.delete_ids
  for i = 1, #_delete do
    for k, v in pairs(self.recordDatas) do
      if _delete[i] == v.id then
        self.recordDatas[k] = nil
      end
    end
    local t = #self.slotDatas
    for k = 1, t do
      if self.slotDatas[k].id == _delete[i] then
        self.slotDatas[k]:ResetRecordTime(0)
      end
    end
  end
  if #self.slotDatas == 0 then
    for i = 1, #_slots do
      local temp = UserSaveSlotData.new(_slots[i])
      self.slotDatas[i] = temp
      if self.recordDatas[temp.id] then
        self.slotDatas[i]:ResetRecordTime(self.recordDatas[i].recordtime)
        self.slotDatas[i]:SetRecordName(self.recordDatas[i].recordname)
      end
    end
  else
    for i = 1, #_slots do
      local temp = UserSaveSlotData.new(_slots[i])
      for j = 1, #self.slotDatas do
        if self.slotDatas[j] and self.slotDatas[j].id == temp.id then
          self.slotDatas[j] = temp
          if self.recordDatas[temp.id] then
            self.slotDatas[j]:ResetRecordTime(self.recordDatas[temp.id].recordtime)
            self.slotDatas[j]:SetRecordName(self.recordDatas[temp.id].recordname)
          end
        end
      end
    end
  end
  self.CardExpiration = serverdata.card_expiretime
  self:CheckTimeValidation()
  self.costMap = {}
  if serverdata.astrol_data then
    local l = #serverdata.astrol_data
    local temp
    for i = 1, l do
      temp = AstrolMaterialData.new(serverdata.astrol_data[i])
      self.costMap[temp.charid] = temp
    end
  end
  self:DoInitSlotIndex()
end

function MultiProfessionSaveProxy:CheckTimeValidation()
  if self.slotDatas then
    local n = #self.slotDatas
    for i = 1, n do
      if self.slotDatas[i].Type == SceneUser2_pb.ESLOT_MONTH_CARD then
        if self.slotDatas[i].status == 1 and self.CardExpiration == 0 then
          self.slotDatas[i].status = 0
        elseif self.slotDatas[i].status == 0 and self.CardExpiration > 0 then
          self.slotDatas[i].status = 1
        end
      end
    end
  end
end

function MultiProfessionSaveProxy:GetCardExpiration()
  return self.CardExpiration
end

function MultiProfessionSaveProxy:SortUserSave()
  table.sort(self.slotDatas, function(l, r)
    local l_status = l.status
    local r_status = r.status
    if l_status == r_status then
      if l_status == 1 then
        return l.recordTime > r.recordTime
      elseif l_status == 0 then
        if l.type == r.type then
          return l.id < r.id
        else
          return l.type > r.type
        end
      end
    else
      return l_status > r_status
    end
  end)
end

function MultiProfessionSaveProxy:UpdateStatus(slotid, status)
  for i = 1, #self.slotDatas do
    if self.slotDatas[i].id == slotid then
      self.slotDatas[i]:UpdateSlotStatus(status)
    end
  end
end

function MultiProfessionSaveProxy:GetDefaultRecord()
  if self.slotDatas[1] then
    return self.slotDatas[1].id
  end
end

function MultiProfessionSaveProxy:GetCurrentSlotStatus(selectedID)
  if self.slotDatas then
    local n = #self.slotDatas
    for i = 1, n do
      if self.slotDatas[i].id == selectedID then
        return self.slotDatas[i].status
      end
    end
  else
    return 0
  end
end

function MultiProfessionSaveProxy:GetProfession(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProfession()
end

function MultiProfessionSaveProxy:GetHeroFeatureLv(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetHeroFeatureLv()
end

function MultiProfessionSaveProxy:GetRoleID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id].roleid
end

function MultiProfessionSaveProxy:GetRoleName(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id].rolename
end

function MultiProfessionSaveProxy:GetUnusedSkillPoint(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUnusedSkillPoint()
end

function MultiProfessionSaveProxy:GetProfessionSkill(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProfessionSkill()
end

function MultiProfessionSaveProxy:GetEquipedSkills(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetEquipedSkills()
end

function MultiProfessionSaveProxy:GetEquipedAutoSkills(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetEquipedAutoSkills()
end

function MultiProfessionSaveProxy:GetBeingSkill(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingSkill()
end

function MultiProfessionSaveProxy:GetBeingInfo(id, beingid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingInfo(beingid)
end

function MultiProfessionSaveProxy:GetBeingsArray(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingsArray()
end

function MultiProfessionSaveProxy:GetUsedPoints(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUsedPoints()
end

function MultiProfessionSaveProxy:GetJobLevel(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetJobLevel()
end

function MultiProfessionSaveProxy:GetFixedJobLevel(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetFixedJobLevel()
end

function MultiProfessionSaveProxy:GetProfessionType(id)
  if not self.recordDatas[id] then
    return nil
  end
  local profession = self.recordDatas[id]:GetProfession()
  profession = Table_Class[profession]
  return profession and profession.Type or 0
end

function MultiProfessionSaveProxy:GetProfessionTypeBranch(id)
  if not self.recordDatas[id] then
    return nil
  end
  local profession = self.recordDatas[id]:GetProfession()
  profession = Table_Class[profession]
  return profession and profession.TypeBranch or 0
end

function MultiProfessionSaveProxy:GetAstrobleByID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetAstroble()
end

function MultiProfessionSaveProxy:GetActiveStars(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetActiveStars()
end

function MultiProfessionSaveProxy:GetUserDataByID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUserData()
end

function MultiProfessionSaveProxy:GetProps(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProps()
end

function MultiProfessionSaveProxy:GetUsersaveData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]
end

function MultiProfessionSaveProxy:GetContribute(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetContribute()
end

function MultiProfessionSaveProxy:GetGoldMedal(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetGoldMedal()
end

function MultiProfessionSaveProxy:GetSkillData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetSkillData()
end

function MultiProfessionSaveProxy:GetPersonalArtifactId(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetPersonalArtifactId()
end

function MultiProfessionSaveProxy:GetGemData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetGemData()
end

function MultiProfessionSaveProxy:GetEquipInfo(id, bagType)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetRoleEquipsSaveDatas(bagType)
end

function MultiProfessionSaveProxy:GetMasterSkillProfessData(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetMasterSkillProfessData()
end

function MultiProfessionSaveProxy:GetEquipMasterSkillFamilyId(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetEquipMasterSkillFamilyId()
end

function MultiProfessionSaveProxy:GetInheritSkillProfessDatas(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetInheritSkillProfessDatas()
end

function MultiProfessionSaveProxy:GetInheritSkillLoadSkills(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetInheritSkillLoadSkills()
end

function MultiProfessionSaveProxy:GetExtendedCostPoints(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetExtendedCostPoints()
end

function MultiProfessionSaveProxy:GetTotalCostPointAttrs(id, costPoint)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetTotalCostPointAttrs(costPoint)
end

function MultiProfessionSaveProxy:GetGemCountDesc(id)
  local skillCount, attrCount = GemProxy.GetSkillAndAttrGemCountDescFromItemDatas(self:GetGemData(id))
  return string.format(ZhString.Gem_CountLabelFormat, skillCount, GemProxy.Instance.pageSkillGemMaxCount), string.format(ZhString.Gem_CountLabelFormat, attrCount, GemProxy.Instance.pageAttrGemMaxCount)
end

function MultiProfessionSaveProxy:GetSkillOpts(id, opts, skillid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetSkillOpts(opts, skillid)
end

function MultiProfessionSaveProxy:Clear()
  if self.slotDatas ~= nil then
    TableUtility.TableClear(self.slotDatas)
  end
  if self.recordDatas ~= nil then
    TableUtility.TableClear(self.recordDatas)
  end
  self.recvServerInfo = false
  self.loadRecordCtx = nil
end

function MultiProfessionSaveProxy:GetMultiSkillInvalidOption(id, optionType, skillid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetMultiSkillInvalidOption(optionType, skillid)
end

function MultiProfessionSaveProxy:ClearDetailInfo()
  self.recvServerInfo = false
  if self.recordDatas then
    TableUtility.TableClear(self.recordDatas)
  end
end

function MultiProfessionSaveProxy:GetExtract(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetExtractData()
end

function MultiProfessionSaveProxy:RecvProfessionRecordSimpleData(serverData)
  if not serverData or not serverData.records then
    return
  end
  if not self.professionSimpleData then
    self.professionSimpleData = {}
  end
  TableUtility.ArrayClear(self.professionSimpleData)
  for _, record in ipairs(serverData.records) do
    table.insert(self.professionSimpleData, {
      id = record.id,
      charid = record.charid,
      charname = record.charname,
      profession = record.profession,
      recordname = record.recordname
    })
  end
  EventManager.Me():PassEvent(YmirEvent.OnSimpleRecordDataUpdated, self.professionSimpleData)
end

function MultiProfessionSaveProxy:GetProfessionRecordSimpleData()
  return self.professionSimpleData
end

function MultiProfessionSaveProxy:GetProfessionRecordSimpleDataById(id)
  if self.professionSimpleData then
    for _, data in ipairs(self.professionSimpleData) do
      if data.id == id then
        return data
      end
    end
  end
end

function MultiProfessionSaveProxy:ClearProfessionRecordSimpleData()
  self.professionSimpleData = {}
end

function MultiProfessionSaveProxy:GetSavedRecordId()
  return self.savedRecordId or self:GetDefaultRecord()
end

function MultiProfessionSaveProxy:SetSavedRecordId(saveId)
  self.savedRecordId = saveId
end

function MultiProfessionSaveProxy:UpdateSlotIndexInfo(serverData)
  if serverData and serverData.slot_indexs then
    if not self.saveLocalIndexes then
      self.saveLocalIndexes = {}
    end
    local dirty = false
    for _, indexx in ipairs(serverData.slot_indexs) do
      local ori = self.saveLocalIndexes[indexx.slot_id]
      if not ori or ori ~= indexx.index then
        self.saveLocalIndexes[indexx.slot_id] = indexx.index
        dirty = true
      end
    end
    if dirty then
      EventManager.Me():PassEvent(ChangeProfessionPanelEvent.UpdateSlotIndex)
    end
  end
end

function MultiProfessionSaveProxy:DoSwapSlotIndex(slot_a, slot_b)
  if not self.saveLocalIndexes then
    self.saveLocalIndexes = {}
  end
  if #self.saveLocalIndexes == 0 then
    self:DoInitSlotIndex(true)
  end
  local idx_a = self.saveLocalIndexes[slot_a]
  local idx_b = self.saveLocalIndexes[slot_b]
  if not idx_a or not idx_b then
    return
  end
  self.saveLocalIndexes[slot_a] = idx_b
  self.saveLocalIndexes[slot_b] = idx_a
  self:DoSyncSlotIndex()
  EventManager.Me():PassEvent(ChangeProfessionPanelEvent.UpdateSlotIndex)
end

function MultiProfessionSaveProxy:DoInitSlotIndex(noSync)
  if not self.saveLocalIndexes then
    self.saveLocalIndexes = {}
  end
  local dirtyCount = 0
  for i = 1, #self.slotDatas do
    local slot = self.slotDatas[i]
    if slot.status == 0 and slot.type == SceneUser2_pb.ESLOT_BUY then
      break
    end
    if not self.saveLocalIndexes[slot.id] then
      dirtyCount = dirtyCount + 1
      self.saveLocalIndexes[slot.id] = dirtyCount + #self.saveLocalIndexes
    end
  end
  local tempsort = {}
  for k, v in pairs(self.saveLocalIndexes) do
    tempsort[#tempsort + 1] = {slot = k, index = v}
  end
  table.sort(tempsort, function(a, b)
    return a.index < b.index
  end)
  for i = 1, #tempsort do
    if self.saveLocalIndexes[tempsort[i].slot] ~= i then
      self.saveLocalIndexes[tempsort[i].slot] = i
      dirtyCount = dirtyCount + 1
    end
  end
  if 0 < dirtyCount and noSync ~= true then
    self:DoSyncSlotIndex()
  end
end

function MultiProfessionSaveProxy:DoSyncSlotIndex()
  local indexes = {}
  for k, v in pairs(self.saveLocalIndexes) do
    local cmd = PbMgr.CreateNewMsgByName("Cmd.RecordSlotIndex")
    cmd.slot_id = k
    cmd.index = v
    indexes[#indexes + 1] = cmd
  end
  ServiceSceneUser3Proxy.Instance:CallUpdateRecordSlotIndex(indexes)
end

function MultiProfessionSaveProxy:GetFirstEmptySlotByIndexOrder()
  local emptys = {}
  for i = 1, #self.slotDatas do
    local slot = self.slotDatas[i]
    if slot.status == 0 and slot.type == SceneUser2_pb.ESLOT_BUY then
      break
    end
    if slot.status == 1 and slot.recordTime == 0 then
      emptys[#emptys + 1] = slot.id
    end
  end
  if 0 < #emptys then
    table.sort(emptys, function(l, r)
      return (self.saveLocalIndexes[l] or 99999) < (self.saveLocalIndexes[r] or 99999)
    end)
    return emptys[1]
  end
end

function MultiProfessionSaveProxy:LoadRecordByMapRule(recordId, isChangeCard, changeCardMoney)
  local canChangeProf, canChangeEquip = ProfessionProxy.CanChangeProfession4NewPVPRule()
  self.loadRecordCtx = {}
  self.loadRecordCtx.only_equip = not canChangeProf
  self.loadRecordCtx.pre_prof = MyselfProxy.Instance:GetMyProfession()
  local prof = self:GetProfession(recordId)
  if self.loadRecordCtx.only_equip and self.loadRecordCtx.pre_prof ~= prof or canChangeEquip == false then
    MsgManager.ShowMsgByIDTable(25388)
    self.loadRecordCtx = nil
    return
  end
  ServiceNUserProxy.Instance:CallLoadRecordUserCmd(recordId, self.loadRecordCtx.only_equip, isChangeCard, changeCardMoney)
end

function MultiProfessionSaveProxy:LoadRecordByMapRule_OnRecv(recordname, zenycost)
  if self.loadRecordCtx then
    if self.loadRecordCtx.only_equip then
      MsgManager.ShowMsgByIDTable(25392, {recordname, zenycost})
    else
      MsgManager.ShowMsgByIDTable(25393, {recordname, zenycost})
    end
  end
  self.loadRecordCtx = nil
end

function MultiProfessionSaveProxy:GetRecordEquipUnloadCards(id)
  local equipInfo = self:GetEquipInfo(id, BagProxy.BagType.RoleEquip)
  local unloadCards = FunctionMultiProfession.Me():GetEquipsUnloadCards(equipInfo)
  return unloadCards
end

function MultiProfessionSaveProxy:GetRecordEquipCardsUnloadMoney(id)
  local unloadCards = self:GetRecordEquipUnloadCards(id)
  local money = 0
  local config = GameConfig.EquipRecover.Card
  for i = 1, #unloadCards do
    local card = unloadCards[i]
    money = money + config[card.staticData.Quality]
  end
  return money
end
