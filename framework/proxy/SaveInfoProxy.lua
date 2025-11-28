SaveInfoProxy = class("SaveInfoProxy", pm.Proxy)
SaveInfoProxy.Instance = nil
SaveInfoProxy.NAME = "SaveInfoProxy"
SaveInfoEnum = {
  Branch = SceneUser2_pb.ETypeBranch,
  Record = SceneUser2_pb.ETypeRecord
}

function SaveInfoProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SaveInfoProxy.NAME
  if SaveInfoProxy.Instance == nil then
    SaveInfoProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.savedLastTab = 1
  self.savedLastBranchID = -1
end

local _BranchInfoSaveProxy = BranchInfoSaveProxy
local _MultiProfessionSaveProxy = MultiProfessionSaveProxy

function SaveInfoProxy:CheckHasInfo(type)
  if not self:HasInfo(type) then
    ServiceNUserProxy.Instance:CallQueryProfessionDataDetailUserCmd(type)
  end
end

function SaveInfoProxy:HasInfo(type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:HasInfo()
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:HasInfo()
  end
end

function SaveInfoProxy:GetHeroFeatureLv(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetHeroFeatureLv(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetHeroFeatureLv(id)
  end
end

function SaveInfoProxy:GetPersonalArtifactId(save_id, save_type)
  local search_result, id
  if save_type == SaveInfoEnum.Branch then
    search_result, id = BranchInfoSaveProxy.Instance:GetPersonalArtifactId(save_id)
  elseif save_type == SaveInfoEnum.Record then
    search_result, id = MultiProfessionSaveProxy.Instance:GetPersonalArtifactId(save_id)
  end
  return search_result, id
end

function SaveInfoProxy:SetSavedTabIndex(index)
  self.savedLastTab = index
end

function SaveInfoProxy:GetSavedTabIndex()
  return self.savedLastTab
end

function SaveInfoProxy:SetSavedLastBranchID(branch)
  self.savedLastBranchID = branch
end

function SaveInfoProxy:GetSavedLastBranchID()
  return self.savedLastBranchID
end

function SaveInfoProxy:GetProfession(id, type)
  if type == SaveInfoEnum.Branch then
    local pId = _BranchInfoSaveProxy.Instance:GetProfession(id)
    if pId % 10 == 1 and Table_Class[pId].TypeBranch ~= id then
      for k, v in pairs(Table_Class) do
        if v.TypeBranch == id and v.IsOpen then
          return v.id
        end
      end
    end
    return _BranchInfoSaveProxy.Instance:GetProfession(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetProfession(id)
  end
end

function SaveInfoProxy:GetRoleID(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetRoleID(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetRoleID(id)
  end
end

function SaveInfoProxy:GetRoleName(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetRoleName(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetRoleName(id)
  end
end

function SaveInfoProxy:GetUnusedSkillPoint(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetUnusedSkillPoint(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetUnusedSkillPoint(id)
  end
end

function SaveInfoProxy:GetProfessionSkill(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetProfessionSkill(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetProfessionSkill(id)
  end
end

function SaveInfoProxy:GetEquipedSkills(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetEquipedSkills(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetEquipedSkills(id)
  end
end

function SaveInfoProxy:GetEquipedAutoSkills(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetEquipedAutoSkills(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetEquipedAutoSkills(id)
  end
end

function SaveInfoProxy:GetBeingSkill(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetBeingSkill(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetBeingSkill(id)
  end
end

function SaveInfoProxy:GetBeingInfo(id, beingid, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetBeingInfo(id, beingid)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetBeingInfo(id, beingid)
  end
end

function SaveInfoProxy:GetBeingsArray(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetBeingsArray(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetBeingsArray(id)
  end
end

function SaveInfoProxy:GetUsedPoints(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetUsedPoints(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetUsedPoints(id)
  end
end

function SaveInfoProxy:GetJobLevel(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetJobLevel(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetJobLevel(id)
  end
end

function SaveInfoProxy:GetProfessionType(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetProfessionType(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetProfessionType(id)
  end
end

function SaveInfoProxy:GetProfessionTypeBranch(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetProfessionTypeBranch(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetProfessionTypeBranch(id)
  end
end

function SaveInfoProxy:GetAstrobleByID(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetAstrobleByID(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetAstrobleByID(id)
  end
end

function SaveInfoProxy:GetUserDataByID(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetUserDataByID(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetUserDataByID(id)
  end
end

function SaveInfoProxy:GetProps(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetProps(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetProps(id)
  end
end

function SaveInfoProxy:GetUsersaveData(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetUsersaveData(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetUsersaveData(id)
  end
end

function SaveInfoProxy:GetSkillData(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetSkillData(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetSkillData(id)
  end
end

function SaveInfoProxy:GetGemData(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetGemData(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetGemData(id)
  end
end

function SaveInfoProxy:GetSkillOpts(id, type, opts, skillid)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetSkillOpts(id, opts, skillid)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetSkillOpts(id, opts, skillid)
  end
end

function SaveInfoProxy:GetMultiSkillInvalidOption(id, type, opts, skillid)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetMultiSkillInvalidOption(id, opts, skillid)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetMultiSkillInvalidOption(id, opts, skillid)
  end
end

function SaveInfoProxy:GetMasterSkillProfessData(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetMasterSkillProfessData(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetMasterSkillProfessData(id)
  end
end

function SaveInfoProxy:GetEquipMasterSkillFamilyId(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetEquipMasterSkillFamilyId(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetEquipMasterSkillFamilyId(id)
  end
end

function SaveInfoProxy:GetInheritSkillProfessDatas(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetInheritSkillProfessDatas(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetInheritSkillProfessDatas(id)
  end
end

function SaveInfoProxy:GetInheritSkillLoadSkills(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetInheritSkillLoadSkills(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetInheritSkillLoadSkills(id)
  end
end

function SaveInfoProxy:GetExtendedCostPoints(id, type)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetExtendedCostPoints(id)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetExtendedCostPoints(id)
  end
end

function SaveInfoProxy:GetTotalCostPointAttrs(id, type, costPoint)
  if type == SaveInfoEnum.Branch then
    return _BranchInfoSaveProxy.Instance:GetTotalCostPointAttrs(id, costPoint)
  elseif type == SaveInfoEnum.Record then
    return _MultiProfessionSaveProxy.Instance:GetTotalCostPointAttrs(id, costPoint)
  end
end
