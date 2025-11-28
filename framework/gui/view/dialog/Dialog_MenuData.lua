Dialog_MenuData = class("Dialog_MenuData")
Dialog_MenuData_Type = {
  NpcFunc = 1,
  Task = 2,
  CustomFunc = 3,
  Option = 4,
  PveRaidEntrance = 5
}

function Dialog_MenuData:ctor()
  self:Reset()
end

function Dialog_MenuData:Reset()
  self:Set_Name("")
  self:Set_CloseDialogWhenClick(true)
end

function Dialog_MenuData:Set_Name(name)
  self.name = name
end

function Dialog_MenuData:Set_State(state)
  self.state = state
end

function Dialog_MenuData:Set_CloseDialogWhenClick(closeDialog)
  self.closeDialog = closeDialog
end

function Dialog_MenuData:Set_WaitCloseDialogWhenClick(waitClose)
  self.waitClose = waitClose
end

function Dialog_MenuData:Set_CusetomClickCall(clickCall, clickCallParam)
  self.menuType = Dialog_MenuData_Type.CustomFunc
  self.clickCall = clickCall
  self.clickCallParam = clickCallParam
end

function Dialog_MenuData:Set_ByNpcFunctionConfig(typeid, param, paramname, npcinfo, endfunc)
  self.menuType = Dialog_MenuData_Type.NpcFunc
  local isImplemented = FunctionNpcFunc.Me():getFunc(typeid)
  if not isImplemented then
    self:Set_State(NpcFuncState.InActive)
    return
  end
  local isOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(typeid, false, MenuUnlockType.NpcFunction)
  if not isOpen then
    self:Set_State(NpcFuncState.InActive)
    return
  end
  self.npcFuncData = Table_NpcFunction[typeid]
  if self.npcFuncData == nil then
    self:Set_State(NpcFuncState.InActive)
    return
  end
  if self.npcFuncData.Parama.HideButton and self.npcFuncData.Parama.HideButton == 1 then
    self:Set_State(NpcFuncState.InActive)
    return
  end
  if FunctionNpcFunc.Me():CheckFuncStatelist(typeid) then
    self:Set_State(NpcFuncState.InActive)
    return
  end
  local state, othername = FunctionNpcFunc.Me():CheckFuncState(self.npcFuncData.NameEn, npcinfo, param, typeid)
  self:Set_State(state)
  if othername then
    self:Set_Name(othername)
  elseif paramname then
    self:Set_Name(paramname)
  else
    self:Set_Name(self.npcFuncData.NameZh)
  end
  self.param = param
  self.key = self.npcFuncData.NameEn
  self.endfunc = endfunc
end

function Dialog_MenuData:Set_ByTask(task)
  self.menuType = Dialog_MenuData_Type.Task
  local sData = task.staticData
  if sData.Prefixion and sData.Prefixion ~= "" then
    self:Set_Name(string.format("[%s]%s", sData.Prefixion, sData.Name))
  else
    self:Set_Name(task.staticData.Name)
  end
  self.task = task
end

function Dialog_MenuData:Set_ByOption(option)
  self.menuType = Dialog_MenuData_Type.Option
  self.name = option.text
  self.optionid = option.id
end

function Dialog_MenuData:SetIcon_ByOption(iconPath)
  self.icon = iconPath
end

function Dialog_MenuData:Set_ByPveRaidEntrance(pvePassInfo)
  self.menuType = Dialog_MenuData_Type.PveRaidEntrance
  local name = pvePassInfo.staticEntranceData.name
  local difficultyName = pvePassInfo.staticEntranceData:GetDifficultyDesc()
  name = string.format("%s %s", name, difficultyName)
  self:Set_Name(name)
  if not pvePassInfo.open then
    self:Set_State(NpcFuncState.Grey)
  else
    self:Set_State(NpcFuncState.Active)
  end
  self.pvePassInfo = pvePassInfo
end
