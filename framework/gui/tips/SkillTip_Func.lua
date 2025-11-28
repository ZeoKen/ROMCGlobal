autoImport("SkillSelectFuncSubTip")
autoImport("SkillMultiSelectCell")
autoImport("SkillSpecialCell")
autoImport("SkillSubSkillListCell")
autoImport("SkillSubSelectMountCell")
autoImport("SkillSubSelectSkillListCell")
autoImport("SkillSubSelectSelectMountCell")
autoImport("SkillTipItemCostCell")
local none_opt = 0
local normalAtkCheck_opt = 9999
local skillautoQueue_opt = 9998
local skillQuickRide_opt = 10086
local skillAutoLock_opt = 10087
local skillAutoReload_opt = 10088
local tmpPos = LuaVector3(0, 0, 0)
local tempList = {}
local tempList2 = {}
local GetBuffSkillListData = function(tip, optionType, skillid)
  local id
  local _CommonFun = CommonFun
  local _SkillOptionManager = Game.SkillOptionManager
  local data = SkillProxy.Instance:GetLearnedSkills()
  for k, v in pairs(data) do
    id = v[#v]:GetID()
    if _CommonFun.CheckBuffListSkill(tip.data:GetID(), id) and not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) and not v[#v].shadow then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
end
local GetBuffSkillListCount = function(tip)
  return tip.data:GetSubSkillCount()
end
local GetSelectMountData = function(tip, optionType, skillid)
  local id
  local _BagProxy = BagProxy.Instance
  local _SkillOptionManager = Game.SkillOptionManager
  local list = _BagProxy:GetMountPetsID()
  for i = 1, #list do
    id = list[i]
    if not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
  list = _BagProxy:GetBagItemsByType(90)
  for i = 1, #list do
    id = list[i].id
    if not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
end
local GetPioneerSkillListData = function(tip, optionType, skillid)
  local sortid, id
  local _SkillProxy = SkillProxy.Instance
  local _SkillOptionManager = Game.SkillOptionManager
  local list = tip.data:GetPioneerSkill()
  for i = 1, #list do
    sortid = list[i]
    id = sortid * 1000 + 1
    if _SkillProxy:HasLearnedSkillBySort(sortid) and not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
  list = tip.data:GetUnlearnedPioneerSkill()
  if list and 0 < #list then
    for i = 1, #list do
      id = list[i]
      if not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
        tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
      end
    end
  end
end
local GetPioneerSkillListCount = function(tip)
  return tip.data:GetPioneerSkillCount()
end
local CheckReplaceSkillValid = function(id)
  local data = Table_Skill[id]
  if data ~= nil then
    local combineSkill = data.Logic_Param.combine_skill
    if combineSkill ~= nil then
      local _SkillProxy = SkillProxy.Instance
      for i = 1, #combineSkill do
        if not _SkillProxy:HasLearnedSkillBySort(combineSkill[i]) then
          return false
        end
      end
      return true
    end
  end
  return false
end
local GetReplaceSkillListData = function(tip, optionType, skillid)
  local id
  local _SkillOptionManager = Game.SkillOptionManager
  local data = tip.data:GetReplaceSkill()
  for k, v in pairs(data) do
    id = k * 1000 + 1
    if CheckReplaceSkillValid(id) and not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
end
local CheckReplaceSkillListRemove = function(sortID)
  if CDProxy.Instance:SkillIsInCD(sortID) then
    MsgManager.ShowMsgByID(40604)
    return false
  end
  return true
end
local GetSuperPositionSkillData = function(tip, optionType, skillid)
  local sortid, id
  local _SkillProxy = SkillProxy.Instance
  local _SkillOptionManager = Game.SkillOptionManager
  local list = tip.data:GetSuperPositionSkill()
  for i = 1, #list do
    sortid = list[i]
    id = sortid * 1000 + 1
    if _SkillProxy:HasLearnedSkillBySort(sortid) and not _SkillOptionManager:IsInSkillOption(optionType, skillid, id) then
      tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
    end
  end
end
local GetSuperPositionSkillCount = function(tip)
  return tip.data:GetSuperPositionSkillCount()
end
local GetDelMultiTrapData = function(tip, optionType, skillid)
  local sortid, id
  local _SkillProxy = SkillProxy.Instance
  local _SkillOptionManager = Game.SkillOptionManager
  local list = tip.data:GetDelMultiTrapData()
  local skill
  for i = 1, #list do
    sortid = list[i]
    skill = _SkillProxy:GetLearnedSkillBySortID(sortid)
    if skill then
      id = skill:GetID()
      if not _SkillOptionManager:IsInSkillOption(optionType, skillid, sortid) then
        tip.subSkillSelectList[#tip.subSkillSelectList + 1] = id
      end
    end
  end
end
local GetDelMultiTrapDataCount = function(tip)
  return tip.data:GetDelMultiTrapDataCount()
end
SkillTip.FuncTipType = {
  SubSkills = 1,
  Select = 2,
  MultiSelect = 3,
  Rune = 4,
  ItemCost = 5,
  SubSkillsReadOnly = 6
}
SkillTip.FuncForbidMap = {}

function SkillTip.SetForbidFunc(isForbid, type)
  local value = isForbid or nil
  if type then
    SkillTip.FuncForbidMap[type] = value
  else
    for k, v in pairs(SkillTip.FuncTipType) do
      SkillTip.FuncForbidMap[v] = value
    end
  end
end

function SkillTip.IsTypeAvailable(type)
  return not SkillTip.FuncForbidMap[type]
end

function SkillTip:FindFunc()
  self.funcGO = self:FindGO("Func")
  if self.funcGO then
    self.funcWidget = self.funcGO:GetComponent(UIWidget)
    self:AddToUpdateAnchors(self.funcWidget)
  end
end

function SkillTip:ShowHideFunc()
  self.funcCheck_opt = nil
  self.funcOptions_opt = nil
  self.funcSub_opt = nil
  local bgHeight = self:_SubSkillFunc() or 0
  bgHeight = self:_MultiSelectFunc(bgHeight)
  bgHeight = self:_SelectFunc(bgHeight)
  bgHeight = self:_RuneFunc(bgHeight)
  bgHeight = self:_ItemCostFunc(bgHeight)
  if 0 < bgHeight then
    self:UpdateContainer(bgHeight)
  else
    self.containerTrans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  end
end

function SkillTip:CheckSpecialModified()
  self:CheckMultiSelectModified()
  self:CheckSelectModified()
  self:CheckRuneModified()
end

function SkillTip:_MultiSelectFunc(bgHeight)
  bgHeight = bgHeight or 0
  local tip = self.multiSelectTip
  self.multiSelectDatas = nil
  self.funcCheck_opt = none_opt
  if SkillTip.IsTypeAvailable(SkillTip.FuncTipType.MultiSelect) and self.data:CheckFuncOpen(SkillItemData.FuncType.Normal) then
    if tip == nil then
      local obj = self:LoadPreferb("tip/SkillSelectTip", self.funcGO, true)
      tip = SkillSelectFuncSubTip.new(obj)
      tip:Init(SkillMultiSelectCell, "SkillMultiSelectCell", self.ClickMultiSelect, self)
      self.multiSelectTip = tip
    end
    tip.trans.localPosition = LuaGeometry.GetTempVector3(0, -bgHeight, 0)
    self.multiSelectDatas = {}
    local datas = self.multiSelectDatas
    local _SkillOptionManager = Game.SkillOptionManager
    if self.data:GetID() == Game.Myself.data:GetAttackSkillIDAndLevel() or self.data:IsFakeNormalAtk() then
      self.funcCheck_opt = normalAtkCheck_opt
      local data = {}
      data.text = self.data:IsFakeNormalAtk() and ZhString.SkillTip_Fake_NormalAtkLabel or ZhString.SkillTip_NormalAtkLabel
      data.select = MyselfProxy.Instance.selectAutoNormalAtk
      datas[#datas + 1] = data
    end
    if self.data.id == GameConfig.SkillAutoQueueID[1] then
      self.funcCheck_opt = skillautoQueue_opt
      local data = {}
      data.text = GameConfig.SkillAutoQueueID[2]
      data.select = _SkillOptionManager:GetSkillOption_AutoQueue() == 0
      datas[#datas + 1] = data
    end
    if self.data.id == GameConfig.SkillQuickRideID[1] then
      self.funcCheck_opt = skillQuickRide_opt
      local data = {}
      data.text = GameConfig.SkillQuickRideID[2]
      data.select = _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.QuickRide) == 0
      datas[#datas + 1] = data
    end
    local funcCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoLockBossID
    if funcCfg and self.data.id == funcCfg[1] then
      self.funcCheck_opt = skillAutoLock_opt
      local data = {}
      if not ISNoviceServerType then
        data.text = funcCfg[2]
        data.select = _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss) == 0
        datas[#datas + 1] = data
      end
      data = {}
      data.text = funcCfg[3]
      data.select = _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp) == 0
      datas[#datas + 1] = data
      data = {}
      data.text = funcCfg[4]
      data.select = _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini) == 0
      datas[#datas + 1] = data
    end
    local catSkillCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.CatSkillAutoCastID
    if catSkillCfg and 0 < TableUtility.ArrayFindIndex(catSkillCfg, self.data.sortID) then
      self.funcCheck_opt = catSkillAutoCast_opt
      local data = {}
      data.text = ZhString.SkillTip_AutoCast
      data.select = MercenaryCatProxy.Instance:IsCatSkillAutoCast(self.data.sortID)
      datas[#datas + 1] = data
    end
    local reloadCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoReload
    if reloadCfg and self.data.id == reloadCfg[1] then
      self.funcCheck_opt = skillAutoReload_opt
      local sOption = _SkillOptionManager:GetSkillOption_AutoReload()
      local data = {}
      data.text = reloadCfg[2][1]
      data.select = sOption // 10 == 0
      datas[#datas + 1] = data
      data.isToggle = true
      data = {}
      data.text = reloadCfg[2][2]
      data.select = sOption // 10 == 1
      datas[#datas + 1] = data
      data.isToggle = true
      data = {}
      data.text = reloadCfg[2][3]
      data.select = sOption // 10 == 2
      datas[#datas + 1] = data
      data.isToggle = true
    end
    local contractCfg = GameConfig.ChasmContract
    if contractCfg and self.data:GetSortID() == math.floor(contractCfg[1] / 1000) then
      local e = SkillOptionManager.OptionEnum.AbyssContract
      self.funcCheck_opt = e
      local data = {
        text = contractCfg[2],
        select = _SkillOptionManager:GetSkillOption(e) == 0
      }
      datas[#datas + 1] = data
    end
    local logicParam = self.data.staticData.Logic_Param
    local buffer = logicParam.select_buff_ids
    if buffer and 1 < logicParam.select_num then
      self.funcCheck_opt = SkillOptionManager.OptionEnum.SelectBuffs
      local skillid = self:_GetMultiSkillOptionSkillid(self.funcCheck_opt)
      for i = 1, #buffer do
        local data = {}
        data.id = buffer[i]
        data.text = Table_Buffer[data.id].BuffName
        data.select = _SkillOptionManager:IsInSkillOption(self.funcCheck_opt, skillid, data.id)
        datas[#datas + 1] = data
      end
    end
    local skilltype = self.data.staticData.SkillType
    if self.data:NeedSwitchToggle() then
      self.funcCheck_opt = SkillOptionManager.OptionEnum.SwitchSkill
      local SwitchTarget = GameConfig.SkillFunc and GameConfig.SkillFunc.SwitchTarget
      local data = {}
      data.sortID = self.data:GetSortID()
      data.text = SwitchTarget and SwitchTarget[data.sortID] or ZhString.SkillSwitcher
      data.select = _SkillOptionManager:GetSkillOption_Switch(self.data:GetSortID())
      datas[#datas + 1] = data
    end
    tip:UpdateTip(datas)
    self:_SelectMultis(datas)
    bgHeight = bgHeight + tip:GetRealBgHeight()
  elseif tip ~= nil then
    tip:Hide()
  end
  return bgHeight
end

function SkillTip:_SelectMultis(datas)
  local opt = self.funcCheck_opt
  if self:_IsMultiSkillOption(opt) then
    local list = Game.SkillOptionManager:GetMultiSkillOption(opt, self:_GetMultiSkillOptionSkillid(opt))
    if list ~= nil then
      for i = 1, #list do
        self:_SelectMulti(list[i])
      end
    end
    local maxCount = self:_GetMultiSkillOptionMaxCount(opt)
    local count = list ~= nil and #list or 0
    if maxCount > count then
      local id
      for i = 1, #datas do
        id = datas[i].id
        if self:_SelectMulti(id) then
          count = count + 1
        end
        if count == maxCount then
          break
        end
      end
    end
  end
end

function SkillTip:_SelectMulti(id)
  local cell = self:_GetSelectedMultiCell(id)
  if cell then
    cell:SetSelect(true)
    return true
  end
  return false
end

function SkillTip:ClickMultiSelect(cell)
  if SkillProxy.Instance:IsMultiSave() then
    return false
  end
  local tip = self.multiSelectTip
  if tip == nil then
    return false
  end
  local data = cell.data
  if data then
    local isSelect = not data.select
    if not data.isToggle then
      if isSelect == true then
        local count = tip:GetSelectedCount()
        local maxCount = self:_GetMultiSkillOptionMaxCount(self.funcCheck_opt)
        if count >= maxCount then
          return false
        end
      end
    else
      local Tcells = tip:GetToggleCells()
      if Tcells then
        for i = 1, #Tcells do
          if Tcells[i] ~= cell then
            Tcells[i]:SetSelect(not isSelect)
          end
        end
      end
    end
    cell:SetSelect(isSelect)
  end
  return true
end

function SkillTip:CheckMultiSelectModified()
  local datas = self.multiSelectDatas
  if datas == nil then
    return
  end
  if #datas == 0 then
    return
  end
  local opt = self.funcCheck_opt
  if opt == normalAtkCheck_opt then
    local isSelect = datas[1].select
    if MyselfProxy.Instance.selectAutoNormalAtk ~= isSelect then
      ServiceNUserProxy.Instance:CallSetNormalSkillOptionUserCmd(isSelect and 1 or 0)
    end
  elseif opt == skillautoQueue_opt then
    local isSelect = datas[1].select
    local _SkillOptionManager = Game.SkillOptionManager
    if _SkillOptionManager:GetSkillOption_AutoQueue() == 0 ~= isSelect then
      _SkillOptionManager:SetSkillOption_AutoQueue(isSelect)
    end
  elseif opt == skillQuickRide_opt then
    local isSelect = datas[1].select
    local _SkillOptionManager = Game.SkillOptionManager
    if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.QuickRide) == 0 ~= isSelect then
      _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.QuickRide, isSelect and 0 or 1)
    end
  elseif opt == skillAutoLock_opt then
    if not ISNoviceServerType then
      local isSelect = datas[1].select
      local _SkillOptionManager = Game.SkillOptionManager
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss, isSelect and 0 or 1)
      end
      isSelect = datas[2].select
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp, isSelect and 0 or 1)
      end
      isSelect = datas[3].select
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini, isSelect and 0 or 1)
      end
    else
      local isSelect = true
      local _SkillOptionManager = Game.SkillOptionManager
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss, isSelect and 0 or 1)
      end
      isSelect = datas[1].select
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp, isSelect and 0 or 1)
      end
      isSelect = datas[2].select
      if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini) == 0 ~= isSelect then
        _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini, isSelect and 0 or 1)
      end
    end
  elseif opt == catSkillAutoCast_opt then
    local isSelect = datas[1].select
    if MercenaryCatProxy.Instance:IsCatSkillAutoCast(self.data.sortID) ~= isSelect then
      MercenaryCatProxy.Instance:SetCatSkillAutoCast(self.data.sortID, isSelect)
    end
  elseif opt == skillAutoReload_opt then
    local selectRes = datas[1].select and 0 or datas[2].select and 1 or 2
    local _SkillOptionManager = Game.SkillOptionManager
    local sOption = _SkillOptionManager:GetSkillOption_AutoReload()
    local result = selectRes * 10
    if result ~= sOption then
      _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AutoReload, result)
    end
  elseif opt == SkillOptionManager.OptionEnum.AbyssContract then
    local isSelect = datas[1].select
    local _SkillOptionManager = Game.SkillOptionManager
    if _SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AbyssContract) == 0 ~= isSelect then
      _SkillOptionManager:SetSkillOption(SkillOptionManager.OptionEnum.AbyssContract, isSelect and 0 or 1)
    end
  elseif opt == SkillOptionManager.OptionEnum.SwitchSkill then
    local isSelect = datas[1].select
    local skillid = datas[1].sortID
    local _SkillOptionManager = Game.SkillOptionManager
    _SkillOptionManager:SetSkillOption_Switch(skillid, isSelect)
  elseif self:_IsMultiSkillOption(opt) then
    local tip = self.multiSelectTip
    if tip ~= nil then
      self:_AskSetMultiSkillOption(opt, tip:GetSelectedList(), tip:GetExtraParam() and 1 or 0)
    end
  end
end

function SkillTip:_GetSelectedMultiCell(id)
  local tip = self.multiSelectTip
  if tip ~= nil then
    return self:_GetSelectedCell(tip:GetListCtrl(), id)
  end
end

function SkillTip:_SelectFunc(bgHeight)
  bgHeight = bgHeight or 0
  local tip = self.selectTip
  if SkillTip.IsTypeAvailable(SkillTip.FuncTipType.Select) and self.data:CheckFuncOpen(SkillItemData.FuncType.Option) then
    if tip == nil then
      local obj = self:LoadPreferb("tip/SkillSelectTip", self.funcGO, true)
      tip = SkillSelectFuncSubTip.new(obj)
      tip:Init(SkillSpecialCell, "SkillSpecialCell", self.ClickSelectOption, self)
      self.selectTip = tip
    end
    tip.trans.localPosition = LuaGeometry.GetTempVector3(0, -bgHeight, 0)
    local datas = {}
    local logicParam = self.data.staticData.Logic_Param
    local _OptionEnum = SkillOptionManager.OptionEnum
    local being = logicParam.being_ids
    if being then
      self.funcOptions_opt = _OptionEnum.SummonBeing
      for i = 1, #being do
        local data = {
          id = being[i]
        }
        data.RuneName = string.format(ZhString.SkillTip_OptionSummon, Table_Being[data.id].Name)
        datas[#datas + 1] = data
      end
    end
    local skill = logicParam.skill_opt_ids
    if skill then
      self.funcOptions_opt = logicParam.skill_opt_type
      for i = 1, #skill do
        local data = {
          id = skill[i]
        }
        data.RuneName = Table_Skill[data.id * 1000 + 1].NameZh
        datas[#datas + 1] = data
      end
    end
    skill = logicParam.skill_opt_learn
    if skill then
      self.funcOptions_opt = logicParam.skill_opt_type
      for i = 1, #skill do
        if SkillProxy.Instance:HasLearnedSkillBySort(skill[i]) then
          local data = {
            id = skill[i]
          }
          data.RuneName = Table_Skill[data.id * 1000 + 1].NameZh
          datas[#datas + 1] = data
        end
      end
    end
    local element = logicParam.element_ids
    if element then
      self.funcOptions_opt = _OptionEnum.SummonElement
      for i = 1, #element do
        local data = {
          id = element[i]
        }
        data.RuneName = string.format(ZhString.SkillTip_OptionSummon, Table_Monster[data.id].NameZh)
        datas[#datas + 1] = data
      end
      if Game.Myself.data.extraElementID then
        local extraElementsConfig = Table_Buffer[Game.Myself.data.extraElementID]
        if extraElementsConfig then
          local extraElements = extraElementsConfig.BuffEffect.element_ids
          for i = 1, #extraElements do
            local data = {
              id = extraElements[i]
            }
            data.RuneName = string.format(ZhString.SkillTip_OptionSummon, Table_Monster[data.id].NameZh)
            datas[#datas + 1] = data
          end
        end
      end
    end
    local buffer = logicParam.select_buff_ids
    if buffer and logicParam.select_num == 1 then
      self.funcOptions_opt = _OptionEnum.SelectBuffs
      for i = 1, #buffer do
        local data = {
          id = buffer[i]
        }
        data.RuneName = Table_Buffer[data.id].BuffName
        datas[#datas + 1] = data
      end
    end
    local fakeDeadConfig = GameConfig.SkillFakeDead
    if self.data.id == fakeDeadConfig.ID then
      self.funcOptions_opt = _OptionEnum.FakeDead
      local values = fakeDeadConfig.Values
      local text = fakeDeadConfig.Text
      for i = 1, #values do
        local data = {
          id = values[i]
        }
        data.RuneName = string.format(text, values[i])
        datas[#datas + 1] = data
      end
    end
    skill = logicParam.companion_skill_ids
    if skill then
      self.funcOptions_opt = _OptionEnum.Companion_Skill
      for i = 1, #skill do
        local data = {
          id = skill[i]
        }
        data.RuneName = Table_Skill[data.id * 1000 + 1].NameZh
        datas[#datas + 1] = data
      end
    end
    local extraOptions = self.data:HasExtraOption() and {} or nil
    if extraOptions then
      extraOptions.isToggle = false
      local hasExtra = Game.SkillOptionManager:GetExtraOptions(self.data.id // 1000)
      extraOptions.select = hasExtra and hasExtra == 1 or false
      extraOptions.text = ZhString.SkillTip_ExtraOptions
      extraOptions.switchTeammate = true
      extraOptions.opt = self.funcOptions_opt
      extraOptions.sortID = self.data.sortID
    end
    tip:UpdateTip(datas, nil, extraOptions)
    self:_SelectOptions(datas)
    bgHeight = tip:GetRealBgHeight() + bgHeight
  elseif tip ~= nil then
    tip:Hide()
  end
  return bgHeight
end

function SkillTip:_SelectOptions(datas)
  local opt = self.funcOptions_opt
  if self:_IsMultiSkillOption(opt) then
    local list = Game.SkillOptionManager:GetMultiSkillOption(opt, self:_GetMultiSkillOptionSkillid(opt))
    if list ~= nil then
      for i = 1, #list do
        self:_SelectOption(list[i])
      end
    end
    local maxCount = self:_GetMultiSkillOptionMaxCount(opt)
    local count = list ~= nil and #list or 0
    if maxCount > count then
      local id
      for i = 1, #datas do
        id = datas[i].id
        if self:_SelectOption(id) then
          count = count + 1
        end
        if count == maxCount then
          break
        end
      end
    end
  else
    local selectID = Game.SkillOptionManager:GetSkillOption(opt)
    if selectID == 0 then
      selectID = opt ~= SkillOptionManager.OptionEnum.Companion_Skill and datas[1].id or datas[2].id
    end
    self:_SelectOption(selectID)
  end
end

function SkillTip:_SelectOption(id)
  local cell = self:_GetSelectedOptionCell(id)
  if cell then
    cell:Select()
    return true
  end
  return false
end

function SkillTip:ClickSelectOption(cell)
  local id = cell.data.id
  local list = self.selectTip:GetSelectedList(true)
  if TableUtility.ArrayFindIndex(list, id) > 0 then
    return false
  end
  local previousSelect
  if self:_IsMultiSkillOption(self.funcOptions_opt) then
    local selectID = list[1]
    if selectID ~= nil then
      previousSelect = self:_GetSelectedOptionCell(selectID)
    end
  else
    previousSelect = self:_GetSelectedOptionCell()
  end
  if previousSelect == nil or id ~= previousSelect.data.id then
    if previousSelect then
      previousSelect:UnSelect()
      TableUtility.ArrayRemove(list, previousSelect.data.id)
    end
    cell:Select()
    TableUtility.ArrayPushBack(list, id)
    return true
  end
  return false
end

function SkillTip:CheckSelectModified()
  local opt = self.funcOptions_opt
  local _SkillOptionManager = Game.SkillOptionManager
  if self:_IsMultiSkillOption(opt) then
    local tip = self.selectTip
    if tip ~= nil then
      self:_AskSetMultiSkillOption(opt, tip:GetSelectedList(true), tip:GetExtraParam() and 1 or 0)
    end
  else
    local cell = self:_GetSelectedOptionCell()
    if cell then
      local id = cell.data.id
      if id ~= _SkillOptionManager:GetSkillOption(opt) then
        _SkillOptionManager:SetSkillOption(opt, id)
      end
    end
  end
end

function SkillTip:_GetSelectedOptionCell(id)
  local tip = self.selectTip
  if tip ~= nil then
    return self:_GetSelectedCell(tip:GetListCtrl(), id)
  end
end

function SkillTip:_RuneFunc(bgHeight)
  bgHeight = bgHeight or 0
  local tip = self.runeTip
  if SkillTip.IsTypeAvailable(SkillTip.FuncTipType.Rune) and self.data:CheckFuncOpen(SkillItemData.FuncType.Rune) then
    if tip == nil then
      local obj = self:LoadPreferb("tip/SkillRuneTip", self.funcGO, true)
      tip = SkillSelectFuncSubTip.new(obj)
      tip:Init(SkillSpecialCell, "SkillSpecialCell", self.ClickSpecialEffect, self)
      self.specialCheck = self:FindGO("SpecialCheckMark", obj)
      local specialLabel = self:FindGO("RuneSpecialTitle", obj):GetComponent(UILabel)
      specialLabel.text = ZhString.SkillTip_RuneSpecialEnabelTitle
      local checkBtn = self:FindGO("SpecialCheck", obj)
      self:AddClickEvent(checkBtn, function()
        self:ClickSpecialCheck()
      end)
      self.runeTip = tip
    end
    tip.trans.localPosition = LuaGeometry.GetTempVector3(0, -bgHeight, 0)
    self.specialCheck:SetActive(self.data:GetEnableSpecialEffect())
    local selectSpecials = self.data:GetRuneSelectSpecials()
    tip:UpdateTip(selectSpecials, 1)
    local cell = self:_GetSelectedSpecialCell(self.data:GetSpecialID())
    if cell then
      cell:Select()
    end
    self:_HandleSpecialCellsEnable()
    bgHeight = tip:GetRealBgHeight() + bgHeight
  elseif tip ~= nil then
    tip:Hide()
  end
  self:_HandleSpecials()
  return bgHeight
end

function SkillTip:ClickSpecialCheck()
  if SkillProxy.Instance:IsMultiSave() then
    return false
  end
  self.specialCheck:SetActive(not self.specialCheck.activeSelf)
  self:_HandleSpecialCellsEnable()
  self:_HandleSpecials()
  return true
end

function SkillTip:ClickSpecialEffect(cell)
  local previousSelect = self:_GetSelectedSpecialCell()
  if previousSelect == nil or cell.data.id ~= previousSelect.data.id then
    if previousSelect then
      previousSelect:UnSelect()
    end
    cell:Select()
    self:_HandleSpecials()
    return true
  end
  return false
end

function SkillTip:_HandleSpecialCellsEnable()
  local tip = self.runeTip
  if tip == nil then
    return
  end
  local listCtrl = tip:GetListCtrl()
  if listCtrl == nil then
    return
  end
  local cells = listCtrl:GetCells()
  if cells then
    local enabled = self.specialCheck.activeSelf
    for i = 1, #cells do
      cells[i]:SetEnable(enabled)
    end
  end
end

function SkillTip:CheckRuneModified()
  if self.specialCheck == nil then
    return
  end
  if self.data:GetEnableSpecialEffect() ~= self.specialCheck.activeSelf then
    local currentBeingData = CreatureSkillProxy.Instance:GetSelectSkillBeingData()
    ServiceSkillProxy.Instance:CallSelectRuneSkillCmd(self.data.id, 0, self.specialCheck.activeSelf, currentBeingData and currentBeingData.id or 0)
  end
  local cell = self:_GetSelectedSpecialCell()
  if cell and cell.data.id ~= self.data:GetSpecialID() then
    local currentBeingData = CreatureSkillProxy.Instance:GetSelectSkillBeingData()
    ServiceSkillProxy.Instance:CallSelectRuneSkillCmd(self.data.id, cell.data.id, self.specialCheck.activeSelf, currentBeingData and currentBeingData.id or 0)
  end
end

function SkillTip:_GetSelectedSpecialCell(id)
  local tip = self.runeTip
  if tip ~= nil then
    return self:_GetSelectedCell(tip:GetListCtrl(), id)
  end
end

function SkillTip:_ItemCostFunc(bgHeight)
  bgHeight = bgHeight or 0
  local tip = self.itemCostTip
  local isShowTip = SkillTip.IsTypeAvailable(SkillTip.FuncTipType.ItemCost)
  local nextStaticData
  if isShowTip then
    if self.data.learned then
      nextStaticData = Table_Skill[self.data:GetNextID()]
    else
      nextStaticData = self.data.staticData
    end
    if nextStaticData and nextStaticData.ItemCost and 0 < #nextStaticData.ItemCost then
      for i = 1, #nextStaticData.ItemCost do
        if nextStaticData.ItemCost[i].id == 12903 then
          isShowTip = false
          break
        end
      end
    else
      isShowTip = false
    end
  end
  if isShowTip then
    if tip == nil then
      local obj = self:LoadPreferb("tip/SkillItemCostTip", self.funcGO, true)
      tip = SkillSelectFuncSubTip.new(obj)
      tip:Init(SkillTipItemCostCell, "SkillTipItemCostCell", self.ClickItemCostCell, self)
      tip:ResetParams(94, 30, 165, 2)
      self.itemCostTip = tip
    end
    tip.trans.localPosition = LuaGeometry.GetTempVector3(0, -bgHeight, 0)
    tip:UpdateTip(nextStaticData and nextStaticData.ItemCost or 0, 0.33)
    bgHeight = tip:GetRealBgHeight() + bgHeight
  elseif tip ~= nil then
    tip:Hide()
  end
  return bgHeight
end

function SkillTip:GetItemCostCells()
  return self.itemCostTip and self.itemCostTip:GetCells()
end

function SkillTip:ClickItemCostCell(cell)
end

function SkillTip:_SubSkillFunc()
  local data = self.data
  local _OptionEnum = SkillOptionManager.OptionEnum
  if data:HasSubSkill() then
    self.funcSub_opt = _OptionEnum.BuffSkillList
  elseif data:GetPioneerSkill() ~= nil or data:GetUnlearnedPioneerSkill() ~= nil then
    self.funcSub_opt = _OptionEnum.PioneerSkillList
  elseif data:GetReplaceSkill() ~= nil then
    self.funcSub_opt = _OptionEnum.ReplaceSkillList
  elseif data:GetSuperPositionSkill() then
    self.funcSub_opt = _OptionEnum.SuperPositionSkill
  elseif data:GetDelMultiTrapData() then
    self.funcSub_opt = _OptionEnum.DelMultiTrap
  end
  local readOnlyMode = SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkillsReadOnly) and not SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkills)
  if (SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkills) or readOnlyMode) and self.funcSub_opt ~= nil then
    if self.funcSubConfig == nil then
      self.funcSubConfig = {
        [_OptionEnum.BuffSkillList] = {
          Cell = SkillSubSkillListCell,
          SelectCell = SkillSubSelectSkillListCell,
          Data = GetBuffSkillListData,
          Count = GetBuffSkillListCount
        },
        [_OptionEnum.SelectMount] = {
          Cell = SkillSubSelectMountCell,
          SelectCell = SkillSubSelectSelectMountCell,
          Data = GetSelectMountData
        },
        [_OptionEnum.PioneerSkillList] = {
          Cell = SkillSubSkillListCell,
          SelectCell = SkillSubSelectSkillListCell,
          Data = GetPioneerSkillListData,
          Count = GetPioneerSkillListCount
        },
        [_OptionEnum.ReplaceSkillList] = {
          Cell = SkillSubSkillListCell,
          SelectCell = SkillSubSelectSkillListCell,
          Data = GetReplaceSkillListData,
          RemoveSkill = CheckReplaceSkillListRemove
        },
        [_OptionEnum.SuperPositionSkill] = {
          Cell = SkillSubSkillListCell,
          SelectCell = SkillSubSelectSkillListCell,
          Data = GetSuperPositionSkillData,
          Count = GetSuperPositionSkillCount
        },
        [_OptionEnum.DelMultiTrap] = {
          Cell = SkillSubSkillListCell,
          SelectCell = SkillSubSelectSkillListCell,
          Data = GetDelMultiTrapData,
          Count = GetDelMultiTrapDataCount
        }
      }
    end
    local cellCtrl = self.funcSubConfig[self.funcSub_opt].Cell
    if self.subSkillTip == nil then
      self.subSkillTip = self:LoadPreferb("tip/SubSkillTip", self.funcGO, true)
      self.subSkillBg = self:FindGO("SubSkillBg", self.subSkillTip):GetComponent(UISprite)
      self.mountTip = self:FindGO("MountTip")
      local subSkillGrid = self:FindGO("SubSkills", self.subSkillTip):GetComponent(UIGrid)
      self.subSkillList = ListCtrl.new(subSkillGrid, cellCtrl, "SkillSubCell")
      self.subSkillList:AddEventListener(SkillEvent.AddSubSkill, self.ClickAddSubSkill, self)
      self.subSkillList:AddEventListener(SkillEvent.RemoveSubSkill, self.ClickRemoveSubSkill, self)
      local _EventManager = EventManager.Me()
      _EventManager:AddEventListener(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, self.HandleSkillOptionUpdate, self)
      _EventManager:AddEventListener(SkillEvent.SkillUpdate, self.HandleSkillUpdate, self)
    elseif self.subSkillList.cellCtrl ~= cellCtrl then
      self.subSkillList:ResetDatas(_EmptyTable, true)
      self.subSkillList.cellCtrl = cellCtrl
    end
    self.subSkillTip:SetActive(true)
    if self.funcSub_opt == _OptionEnum.SelectMount then
      self.mountTip:SetActive(true)
      local trans = self.subSkillList.layoutCtrl.transform
      trans.localPosition = LuaGeometry.GetTempVector3(0, trans.localPosition.y)
    else
      self.mountTip:SetActive(false)
      local trans = self.subSkillList.layoutCtrl.transform
      trans.localPosition = LuaGeometry.GetTempVector3(-128, trans.localPosition.y)
    end
    local inuseSubSkillCount = self:UpdateSubSkill()
    if (not inuseSubSkillCount or inuseSubSkillCount == 0) and readOnlyMode then
      if self.subSkillTip ~= nil then
        self.subSkillTip:SetActive(false)
      end
      return
    end
    return self.subSkillBg.height - 34
  elseif self.subSkillTip ~= nil then
    self.subSkillTip:SetActive(false)
  end
end

function SkillTip:ClickAddSubSkill(cell)
  if not SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkills) then
    return
  end
  self:TryInitSubSkill()
  local subSkillTrans = self.subSkillRoot.transform
  if self.gameObject.transform.localPosition.x > 0 then
    subSkillTrans.localPosition = LuaGeometry.GetTempVector3(50 - self.bg.width, subSkillTrans.localPosition.y)
  else
    subSkillTrans.localPosition = LuaGeometry.GetTempVector3(self.bg.width - 50, subSkillTrans.localPosition.y)
  end
  self.closecomp.enabled = false
  self.closecomp.enabled = true
end

function SkillTip:ClickRemoveSubSkill(cell)
  if not SkillTip.IsTypeAvailable(SkillTip.FuncTipType.SubSkills) then
    return
  end
  local data = cell.data
  if data ~= nil then
    local opt = self.funcSub_opt
    local check = self.funcSubConfig[opt].RemoveSkill
    if check ~= nil and not check(self.data:GetSortID()) then
      return
    end
    TableUtility.ArrayClear(tempList)
    TableUtility.ArrayClear(tempList2)
    local subSkill
    for i = 1, #self.subSkillData do
      subSkill = self.subSkillData[i]
      if subSkill.skillid ~= -1 and subSkill.skillid ~= data then
        if not subSkill.valid and (opt ~= SkillOptionManager.OptionEnum.SuperPositionSkill or opt ~= SkillOptionManager.OptionEnum.DelMultiTrap) then
          tempList2[#tempList2 + 1] = subSkill.skillid
        else
          tempList[#tempList + 1] = subSkill.skillid
        end
      end
    end
    Game.SkillOptionManager:AskSetMultiSkillOption(opt, self:_GetMultiSkillOptionSkillid(opt), tempList, tempList2)
  end
end

function SkillTip:TryInitSubSkill()
  if self.subSkillSelectList == nil then
    self.subSkillSelectList = {}
    self.subSkillRoot = self:FindGO("SubSkillRoot", self.container)
    local container = self:FindGO("Container", self.subSkillRoot)
    local cell = self.funcSubConfig[self.funcSub_opt].SelectCell
    self.subSkillHelper = WrapListCtrl.new(container, cell, "SkillSubSelectCell", WrapListCtrl_Dir.Vertical)
    self.subSkillHelper:AddEventListener(MouseEvent.MouseClick, self.SelectSubSkill, self)
    self.subSkillRoot:SetActive(true)
    self:UpdateSelectSubSkill()
  end
end

function SkillTip:SelectSubSkill(cell)
  local data = cell.data
  if data then
    TableUtility.ArrayClear(tempList)
    TableUtility.ArrayClear(tempList2)
    local subSkill
    for i = 1, #self.subSkillData do
      subSkill = self.subSkillData[i]
      if subSkill and subSkill.skillid ~= -1 then
        if not subSkill.valid then
          tempList2[#tempList2 + 1] = subSkill.skillid
        else
          tempList[#tempList + 1] = subSkill.skillid
        end
      end
    end
    tempList[#tempList + 1] = data
    if #tempList > self:GetSubSkillCount() then
      return
    end
    local opt = self.funcSub_opt
    Game.SkillOptionManager:AskSetMultiSkillOption(opt, self:_GetMultiSkillOptionSkillid(opt), tempList, tempList2)
  end
end

function SkillTip:UpdateSubSkill()
  if self.funcSub_opt ~= nil then
    if self.subSkillData == nil then
      self.subSkillData = {}
    else
      TableUtility.ArrayClear(self.subSkillData)
    end
    local opt = self.funcSub_opt
    local subSkillList, subSkillInvalidList
    if not SkillProxy.Instance:IsMultiSave() then
      subSkillList = Game.SkillOptionManager:GetMultiSkillOption(opt, self:_GetMultiSkillOptionSkillid(opt))
      subSkillInvalidList = Game.SkillOptionManager:GetMultiSkillInvalidOption(opt, self:_GetMultiSkillOptionSkillid(opt))
    else
      local multiSaveId, multiSaveType = SkillProxy.Instance:GetMultiSave()
      local skillid = self:_GetMultiSkillOptionSkillid(self.funcCheck_opt)
      subSkillList = SaveInfoProxy.Instance:GetSkillOpts(multiSaveId, multiSaveType, opt, skillid)
      subSkillInvalidList = SaveInfoProxy.Instance:GetMultiSkillInvalidOption(multiSaveId, multiSaveType, opt, skillid)
    end
    local sortid, skill
    local _SkillProxy = SkillProxy.Instance
    if subSkillList ~= nil then
      for i = 1, #subSkillList do
        local single = {}
        single.skillid = subSkillList[i]
        single.valid = true
        if opt == SkillOptionManager.OptionEnum.SuperPositionSkill then
          local count = self.data:GetSuperPositionSkillCount()
          single.valid = i <= count
        elseif opt == SkillOptionManager.OptionEnum.DelMultiTrap then
          sortid = subSkillList[i]
          skill = _SkillProxy:GetLearnedSkillBySortID(sortid)
          single.skillid = skill and skill:GetID() or 0
          local count = self.data:GetDelMultiTrapDataCount()
          single.valid = i <= count
        end
        self.subSkillData[#self.subSkillData + 1] = single
      end
    end
    if subSkillInvalidList ~= nil then
      for i = 1, #subSkillInvalidList do
        local single = {}
        single.skillid = subSkillInvalidList[i]
        single.valid = false
        self.subSkillData[#self.subSkillData + 1] = single
      end
    end
    for i = #self.subSkillData + 1, self:GetSubSkillCount() do
      local single = {}
      single.skillid = -1
      self.subSkillData[#self.subSkillData + 1] = single
    end
    self.subSkillList:ResetDatas(self.subSkillData)
    return subSkillList and #subSkillList or 0
  end
end

function SkillTip:UpdateSelectSubSkill()
  if self.subSkillSelectList == nil then
    return
  end
  TableUtility.ArrayClear(self.subSkillSelectList)
  local optionType = self.funcSub_opt
  local config = self.funcSubConfig[optionType]
  if config ~= nil and config.Data ~= nil then
    local skillid = self:_GetMultiSkillOptionSkillid(optionType)
    config.Data(self, optionType, skillid)
  end
  self.subSkillHelper:ResetDatas(self.subSkillSelectList)
end

function SkillTip:HandleSkillUpdate()
  if self.funcSub_opt == SkillOptionManager.OptionEnum.ReplaceSkillList then
    self:UpdateCurrentInfo(self.data:GetExtraStaticData())
    self:Layout()
    self.scroll:ResetPosition()
  end
end

function SkillTip:HandleSkillOptionUpdate()
  self:UpdateSubSkill()
  self:UpdateSelectSubSkill()
end

function SkillTip:GetSubSkillCount()
  local config = self.funcSubConfig[self.funcSub_opt]
  if config ~= nil and config.Count ~= nil then
    if SkillProxy.Instance:GetLearnedSkill(50069001) ~= nil then
      redlog("技能扩容2个")
      return config.Count(self) + 2
    end
    return config.Count(self)
  end
  return 1
end

function SkillTip:_IsMultiSkillOption(opt)
  local _OptionEnum = SkillOptionManager.OptionEnum
  return opt == _OptionEnum.SummonBeing or opt == _OptionEnum.SelectBuffs
end

function SkillTip:_GetMultiSkillOptionMaxCount(opt)
  local _OptionEnum = SkillOptionManager.OptionEnum
  if opt == _OptionEnum.SummonBeing then
    return MyselfProxy.Instance:GetBeingCount()
  end
  if opt == _OptionEnum.SelectBuffs then
    return self.data.staticData.Logic_Param.select_num or 1
  end
  if opt == skillAutoLock_opt then
    local funcCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoLockBossID
    return funcCfg and #funcCfg - 1 or 3
  end
  if opt == skillAutoReload_opt then
    local funcCfg = GameConfig.SkillFunc and GameConfig.SkillFunc.AutoReload
    return funcCfg and #funcCfg or 3
  end
  return 1
end

function SkillTip:_AskSetMultiSkillOption(opt, selectList, param1)
  local needAsk = false
  local id = self:_GetMultiSkillOptionSkillid(opt)
  local _SkillOptionManager = Game.SkillOptionManager
  local list = _SkillOptionManager:GetMultiSkillOption(opt, id)
  if list ~= nil then
    for i = 1, #selectList do
      if TableUtility.ArrayFindIndex(list, selectList[i]) == 0 then
        needAsk = true
        break
      end
    end
  else
    needAsk = true
  end
  if needAsk then
    _SkillOptionManager:AskSetMultiSkillOption(self.funcOptions_opt, id, selectList, nil, nil, param1)
  end
end

function SkillTip:_GetMultiSkillOptionSkillid(opt)
  local _OptionEnum = SkillOptionManager.OptionEnum
  if opt == _OptionEnum.SummonBeing then
    return 0
  end
  if opt == _OptionEnum.PioneerSkillList then
    return self.data.sortID
  end
  if opt == _OptionEnum.ReplaceSkillList then
    return self.data.id
  end
  if opt == _OptionEnum.SuperPositionSkill then
    return self.data.sortID
  end
  if opt == _OptionEnum.DelMultiTrap then
    return self.data.sortID
  end
  if opt == _OptionEnum.SelectBuffs then
    return self.data.sortID
  end
  return self.data:GetID()
end

function SkillTip:UpdateContainer(height)
  self.containerTrans.localPosition = LuaGeometry.GetTempVector3(0, height / 2 - 20)
end

function SkillTip:_GetSelectedCell(list, id)
  local cells = list:GetCells()
  if cells then
    local cell
    for i = 1, #cells do
      cell = cells[i]
      if id ~= nil then
        if id == cell.data.id then
          return cell
        end
      elseif cell:IsSelect() then
        return cell
      end
    end
  end
  return nil
end
