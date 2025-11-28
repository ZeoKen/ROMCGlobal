autoImport("UserSaveInfoData")
BranchInfoSaveProxy = class("BranchInfoSaveProxy", pm.Proxy)
BranchInfoSaveProxy.Instance = nil
BranchInfoSaveProxy.NAME = "BranchInfoSaveProxy"

function BranchInfoSaveProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BranchInfoSaveProxy.NAME
  if BranchInfoSaveProxy.Instance == nil then
    BranchInfoSaveProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.recordDatas = {}
end

function BranchInfoSaveProxy:HasInfo()
  return self.hasDetailedInfo
end

function BranchInfoSaveProxy:HasRecordData(id)
  return self.recordDatas[id] ~= nil
end

function BranchInfoSaveProxy:RecvUpdateBranchInfoUserCmd(data)
  self.hasDetailedInfo = data.has_detail and data.has_detail ~= 0
  for i = 1, #data.datas do
    local sdata = data.datas[i]
    local single = UserSaveInfoData.new(sdata)
    self.recordDatas[sdata.id] = single
  end
end

function BranchInfoSaveProxy:ClearDetailInfo()
  self.hasDetailedInfo = nil
  TableUtility.TableClear(self.recordDatas)
end

function BranchInfoSaveProxy:GetProfession(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProfession()
end

function BranchInfoSaveProxy:GetHeroFeatureLv(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetHeroFeatureLv()
end

function BranchInfoSaveProxy:GetRoleID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id].roleid
end

function BranchInfoSaveProxy:GetRoleName(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id].rolename
end

function BranchInfoSaveProxy:GetUnusedSkillPoint(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUnusedSkillPoint()
end

function BranchInfoSaveProxy:GetProfessionSkill(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProfessionSkill()
end

function BranchInfoSaveProxy:GetEquipedSkills(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetEquipedSkills()
end

function BranchInfoSaveProxy:GetEquipedAutoSkills(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetEquipedAutoSkills()
end

function BranchInfoSaveProxy:GetBeingSkill(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingSkill()
end

function BranchInfoSaveProxy:GetBeingInfo(id, beingid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingInfo(beingid)
end

function BranchInfoSaveProxy:GetBeingsArray(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetBeingsArray()
end

function BranchInfoSaveProxy:GetUsedPoints(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUsedPoints()
end

function BranchInfoSaveProxy:GetLearnItemCost(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetLearnItemCost()
end

function BranchInfoSaveProxy:GetJobLevel(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetJobLevel()
end

function BranchInfoSaveProxy:GetProfessionType(id)
  if not self.recordDatas[id] then
    return nil
  end
  local profession = self.recordDatas[id]:GetProfession()
  profession = Table_Class[profession]
  return profession and profession.Type or 0
end

function BranchInfoSaveProxy:GetProfessionTypeBranch(id)
  if not self.recordDatas[id] then
    return nil
  end
  local profession = self.recordDatas[id]:GetProfession()
  profession = Table_Class[profession]
  return profession and profession.TypeBranch or 0
end

function BranchInfoSaveProxy:GetAstrobleByID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetAstroble()
end

function BranchInfoSaveProxy:GetUserDataByID(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetUserData()
end

function BranchInfoSaveProxy:GetProps(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetProps()
end

function BranchInfoSaveProxy:GetUsersaveData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]
end

function BranchInfoSaveProxy:GetActiveStars(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetActiveStars()
end

function BranchInfoSaveProxy:GetContribute(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetContribute()
end

function BranchInfoSaveProxy:GetGoldMedal(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetGoldMedal()
end

function BranchInfoSaveProxy:GetSkillData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetSkillData()
end

function BranchInfoSaveProxy:GetPersonalArtifactId(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetPersonalArtifactId()
end

function BranchInfoSaveProxy:GetGemData(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetGemData()
end

function BranchInfoSaveProxy:GetSkillOpts(id, opts, skillid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetSkillOpts(opts, skillid)
end

function BranchInfoSaveProxy:GetMultiSkillInvalidOption(id, optionType, skillid)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetMultiSkillInvalidOption(optionType, skillid)
end

function BranchInfoSaveProxy:GetExtract(id)
  if not self.recordDatas[id] then
    return nil
  end
  return self.recordDatas[id]:GetExtractData()
end

function BranchInfoSaveProxy:GetEquipInfo(id, bagType)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetRoleEquipsSaveDatas(bagType)
end

function BranchInfoSaveProxy:GetMasterSkillProfessData(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetMasterSkillProfessData()
end

function BranchInfoSaveProxy:GetEquipMasterSkillFamilyId(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetEquipMasterSkillFamilyId()
end

function BranchInfoSaveProxy:GetInheritSkillProfessDatas(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetInheritSkillProfessDatas()
end

function BranchInfoSaveProxy:GetInheritSkillLoadSkills(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetInheritSkillLoadSkills()
end

function BranchInfoSaveProxy:GetExtendedCostPoints(id)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetExtendedCostPoints()
end

function BranchInfoSaveProxy:GetTotalCostPointAttrs(id, costPoint)
  if not self.recordDatas[id] then
    return
  end
  return self.recordDatas[id]:GetTotalCostPointAttrs(costPoint)
end

function BranchInfoSaveProxy:GetRecordEquipUnloadCards(id)
  local equipInfo = self:GetEquipInfo(id, BagProxy.BagType.RoleEquip)
  local unloadCards = FunctionMultiProfession.Me():GetEquipsUnloadCards(equipInfo)
  return unloadCards
end

function BranchInfoSaveProxy:GetRecordEquipCardsUnloadMoney(id)
  local unloadCards = self:GetRecordEquipUnloadCards(id)
  local money = 0
  local config = GameConfig.EquipRecover.Card
  for i = 1, #unloadCards do
    local card = unloadCards[i]
    money = money + config[card.staticData.Quality]
  end
  return money
end
