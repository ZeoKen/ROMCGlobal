FunctionUnLockFunc = class("FunctionUnLockFunc")
autoImport("ConditionCheck")
LockFuncReason = {MenuLock = "MenuLock", Interface = "Interface"}
MenuUnlockType = {View = 1, NpcFunction = 2}
local SpeicalMenuIds = {
  Astrolabe = {5001, 5002},
  EvaluateLink = {9007},
  MenuUnlock = {9651},
  ServantHire = {3050},
  NoviceTarget2023 = {9696},
  PrestigeSkill = {18630}
}
FunctionUnLockFunc.ClientInputForbiddenType = {
  ClientStartIndex = 50,
  ChatRoom = 50,
  BoothName = 51,
  TeamOption_Name = 52,
  TeamOption_Desc = 53
}

function FunctionUnLockFunc.Me()
  if nil == FunctionUnLockFunc.me then
    FunctionUnLockFunc.me = FunctionUnLockFunc.new()
  end
  return FunctionUnLockFunc.me
end

function FunctionUnLockFunc:ctor()
  self.menuData = {}
  self:InitMenuUnLock()
  self:InitInterfaceData()
  self.enterBtnsMap = {}
  self.ErrorFuncStateList = {}
  self.ErrorFuncTimeList = {}
end

function FunctionUnLockFunc:InitMenuUnLock()
  for key, data in pairs(Table_Menu) do
    local mData = self.menuData[key]
    if not mData then
      mData = {}
      mData.checker = ConditionCheck.new()
      self.menuData[key] = mData
    end
    mData.staticData = data
    mData.checker:SetReason(LockFuncReason.MenuLock)
  end
  if BranchMgr.IsJapan() then
    SpeicalMenuIds.EvaluateLink[#SpeicalMenuIds.EvaluateLink + 1] = 10009932
  end
end

function FunctionUnLockFunc:GetMenuId(menuData)
  if menuData then
    if menuData.staticData then
      return menuData.staticData.id
    elseif menuData.interfaceData then
      return menuData.interfaceData.id
    end
  end
end

function FunctionUnLockFunc:GetMenuData(menuid)
  return self.menuData[menuid]
end

function FunctionUnLockFunc:GetMenuDataByPanelID(panelId, unlockType)
  for _, mData in pairs(self.menuData) do
    if mData.staticData and mData.staticData.PanelID == panelId and mData.staticData.type == unlockType then
      return mData
    end
    if mData.interfaceData and mData.interfaceData.PanelID == panelId then
      return mData
    end
  end
end

function FunctionUnLockFunc:InitInterfaceData()
  self.propMap = {}
  for _, iData in pairs(Table_InterfaceOpen) do
    if iData.Condition and iData.Condition.Prop then
      if iData.Condition.Prop.VarName then
        self.propMap[iData.Condition.Prop.VarName] = 1
      end
      if iData.PanelID then
        local mData = self:GetMenuDataByPanelID(iData.PanelID, MenuUnlockType.View)
        if not mData then
          local key = "Interface" .. iData.PanelID
          mData = {}
          mData.checker = ConditionCheck.new()
          self.menuData[key] = mData
          iData.id = key
        end
        mData.interfaceData = iData
        self:SetReason(self:GetMenuId(mData), LockFuncReason.Interface)
      end
    end
  end
end

function FunctionUnLockFunc:SetReason(menuid, reason)
  local menuData = self.menuData[menuid]
  if menuData then
    menuData.checker:SetReason(reason)
  end
end

function FunctionUnLockFunc:RemoveReason(menuid, reason)
  local mData = self.menuData[menuid]
  if mData then
    mData.checker:RemoveReason(reason)
    return mData.checker:HasReason()
  end
  return false
end

function FunctionUnLockFunc:ClearUselessButton()
  for key, buttons in pairs(self.enterBtnsMap) do
    for i = #buttons, 1, -1 do
      if Game.GameObjectUtil:ObjectIsNULL(buttons[i]) then
        table.remove(buttons, i)
      end
    end
    if #buttons == 0 then
      self.enterBtnsMap[key] = nil
    end
  end
end

function FunctionUnLockFunc:RegisteEnterBtn(menuid, button)
  local mData = self.menuData[menuid]
  if mData and mData.staticData.Enterhide == 1 and not self:CheckCanOpen(menuid) then
    local buttonMap = self.enterBtnsMap[menuid]
    if not buttonMap then
      self.enterBtnsMap[menuid] = {}
      buttonMap = self.enterBtnsMap[menuid]
    end
    table.insert(buttonMap, button)
    button.gameObject:SetActive(false)
  end
  self:ClearUselessButton()
end

function FunctionUnLockFunc:RegisteEnterBtnByPanelID(panelid, button)
  local data = self:GetMenuDataByPanelID(panelid, MenuUnlockType.View)
  if data then
    self:RegisteEnterBtn(self:GetMenuId(data), button)
  end
end

function FunctionUnLockFunc:UnRegisteEnterBtn(menuid)
  local buttons = self.enterBtnsMap[menuid]
  if buttons then
    for _, button in pairs(buttons) do
      if not Game.GameObjectUtil:ObjectIsNULL(button) then
        button.gameObject:SetActive(true)
      end
    end
    self.enterBtnsMap[menuid] = nil
    GameFacade.Instance:sendNotification(UIMenuEvent.UnRegisitButton)
  end
end

function FunctionUnLockFunc:CheckCanOpen(menuid, withTip)
  if menuid == nil then
    return true
  end
  local menuData = self.menuData[menuid]
  if menuData then
    local open = not menuData.checker:HasReason()
    if withTip and not open then
      self:ErrorMsg(menuid)
    end
    return open
  end
  return false
end

function FunctionUnLockFunc:CheckCanOpenByPanelId(panelId, withTip, unlockType)
  unlockType = unlockType or MenuUnlockType.View
  local menuData = self:GetMenuDataByPanelID(panelId, unlockType)
  if menuData then
    return self:CheckCanOpen(self:GetMenuId(menuData), withTip)
  end
  return true
end

function FunctionUnLockFunc:ErrorMsg(menuid)
  local mData = self:GetMenuData(menuid)
  if mData then
    local msgid, params
    local reasons = mData.checker.reasons
    if type(reasons) == "table" then
      local _, reason = next(reasons)
      if reason == LockFuncReason.MenuLock then
        msgid = mData.staticData.sysMsg.id
        params = mData.staticData.sysMsg.params
      elseif reason == LockFuncReason.Interface and mData.interfaceData then
        msgid = mData.interfaceData.SysMsgID.id
        params = mData.interfaceData.SysMsgID.params
      end
    end
    if msgid then
      MsgManager.ShowMsgByIDTable(msgid, params)
    end
  end
end

function FunctionUnLockFunc:UnlockuSpecialMenuId(menuid)
  local Func_FindKey = TableUtil.FindKeyByValue
  if Func_FindKey(SpeicalMenuIds.Astrolabe, menuid) then
    if self:UnLockMenu(menuid) then
      AstrolabeProxy.Instance:UnlockPlateByMenuId(menuid)
      GameFacade.Instance:sendNotification(SystemUnLockEvent.UnlockAstrolabe, menuid)
    end
    return true
  elseif self:IsEvaluateLinkType(menuid) then
    if not ApplicationInfo.IsWindows() and self:UnLockMenu(menuid) then
      local sysMsg = Table_Menu[menuid].sysMsg
      if sysMsg and sysMsg.id then
        MsgManager.ConfirmMsgByID(sysMsg.id, function()
          AppBundleConfig.JumpToAppReview()
        end, nil, nil)
      else
        self:_TryDoEvaluateLink(menuid)
      end
    end
    return true
  elseif Func_FindKey(SpeicalMenuIds.MenuUnlock, menuid) then
    if self:UnLockMenu(menuid) then
      local manager_UnlockObj = Game.GameObjectManagers[Game.GameObjectType.MenuUnlockObj]
      manager_UnlockObj:UpdateGameobjectByMenuId(menuid, true)
    end
    return true
  elseif Func_FindKey(SpeicalMenuIds.ServantHire, menuid) then
    if self:UnLockMenu(menuid) then
      FunctionClientGuide.Me():StartGuide("hireservant")
    end
  elseif Func_FindKey(SpeicalMenuIds.NoviceTarget2023, menuid) then
    if self:UnLockMenu(menuid) and not ISNoviceServerType then
      FunctionClientGuide.Me():StartGuide("novicetarget2023")
    end
  elseif Func_FindKey(SpeicalMenuIds.PrestigeSkill, menuid) then
    if self:UnLockMenu(menuid) then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CharactorProfessSkill
      })
    end
    return false
  elseif self:IsPrestigeUnlockMenu(menuid) then
    return false
  end
  return false
end

function FunctionUnLockFunc:IsEvaluateLinkType(menuid)
  local config = Table_Menu[menuid]
  if config and config.type == 6 then
    return true
  end
  return false
end

function FunctionUnLockFunc:_TryDoEvaluateLink(menuid)
  if not BranchMgr.IsChina() then
    if BranchMgr.IsSEA() or BranchMgr.IsEU() then
      OverseaHostHelper:TXWYTrackEvent("job1")
    else
      OverseaHostHelper:AFTrack("1次転職完了")
    end
  end
  if ApplicationInfo.IsRunOnEditor() then
    MsgManager.RecommendScoreMsgTableParm(menuid)
  end
  local BundleID = AppBundleConfig.BundleID
  if GameConfig.BundleIDs and TableUtility.ArrayFindIndex(GameConfig.BundleIDs, BundleID) > 0 then
    MsgManager.RecommendScoreMsgTableParm(menuid)
  end
  local manager_UnlockObj = Game.GameObjectManagers[Game.GameObjectType.MenuUnlockObj]
  manager_UnlockObj:UpdateGameobjectByMenuId(menuid, b)
end

function FunctionUnLockFunc:UnLockMenu(menuid)
  if not self:RemoveReason(menuid, LockFuncReason.MenuLock) then
    Game.FacadeManager:Notify(UIMenuEvent.UnlockMenu)
    return true
  end
  return false
end

function FunctionUnLockFunc:LockMenu(menuid)
  self:SetReason(menuid, LockFuncReason.MenuLock)
  GameFacade.Instance:sendNotification(UIMenuEvent.LockMenu)
end

function FunctionUnLockFunc:CheckProp(prop)
  if not prop or not self.propMap[prop.propVO.name] then
    return
  end
  for _, mData in pairs(self.menuData) do
    if mData.interfaceData then
      local condition = mData.interfaceData.Condition
      if condition.Prop and condition.Prop.VarName == prop.propVO.name then
        if prop:GetValue() == condition.Prop.value then
          self:RemoveReason(self:GetMenuId(mData), LockFuncReason.Interface)
        else
          self:SetReason(self:GetMenuId(mData), LockFuncReason.Interface)
        end
      end
    end
  end
end

function FunctionUnLockFunc:GetPanelConfigById(panelid)
  if not self.panelConfigMap then
    self.panelConfigMap = {}
    for _, config in pairs(PanelConfig) do
      self.panelConfigMap[config.id] = config
    end
  end
  return self.panelConfigMap[panelid]
end

function FunctionUnLockFunc.CheckForbiddenByFuncState(type_name, args)
  local _fobidden = Game[type_name]
  if _fobidden then
    if args then
      if _fobidden[args] then
        return not FunctionUnLockFunc.checkFuncStateValid(_fobidden[args])
      else
        return false
      end
    else
      return not FunctionUnLockFunc.checkFuncStateValid(_fobidden)
    end
  else
    return false
  end
end

function FunctionUnLockFunc.CheckNpcIsForbiddenByFuncState(npcID)
  local cacheMap = Game.Config_FuncStateNpcMap
  local id = cacheMap and cacheMap[npcID]
  if id and Table_FuncState[id] then
    return not FunctionUnLockFunc.checkFuncStateValid(id)
  end
  return false
end

function FunctionUnLockFunc.checkFuncStateValid(id)
  local funcState = Table_FuncState[id]
  if funcState == nil then
    if not FunctionUnLockFunc.Me().ErrorFuncStateList[id] then
      redlog("Table_FuncState 数据不存在,错误ID： ", id)
      FunctionUnLockFunc.Me().ErrorFuncStateList[id] = 1
    end
    return false
  end
  local validtime = Table_FuncTime[funcState.TimeID]
  if nil == validtime then
    if not FunctionUnLockFunc.Me().ErrorFuncTimeList[id] then
      redlog("Table_FuncTime不存在，错误ID： ", funcState.TimeID)
      FunctionUnLockFunc.Me().ErrorFuncTimeList[id] = 1
    end
    return false
  end
  local curServer = FunctionLogin.Me():getCurServerData()
  local curServerID = curServer and curServer.linegroup or 1
  local serverTime = ServerTime.CurServerTime() / 1000
  if 0 ~= TableUtility.ArrayFindIndex(funcState.ServerID, curServerID) and serverTime > validtime.StartTimeStamp and serverTime < validtime.EndTimeStamp then
    return false
  end
  return true
end

function FunctionUnLockFunc:TestServerInputFunc()
  self.ignoreClientInput = true
end

function FunctionUnLockFunc:ForbidInput(param)
  if not param then
    return
  end
  if param < FunctionUnLockFunc.ClientInputForbiddenType.ClientStartIndex and self.ignoreClientInput then
    return
  end
  local funcStateId = Game.Config_InputFuncState[param]
  if funcStateId and not FunctionUnLockFunc.checkFuncStateValid(funcStateId) then
    MsgManager.ShowMsgByIDTable(34024)
    return true
  end
end

function FunctionUnLockFunc.checkFuncTimeValid(timeID)
  local timeConfig = Table_FuncTime[timeID]
  if not timeConfig then
    return false
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  local curServer = FunctionLogin.Me():getCurServerData()
  local curServerID = curServer.linegroup or 1
  if serverTime > timeConfig.StartTimeStamp and serverTime < timeConfig.EndTimeStamp then
    return false
  end
  return true
end

function FunctionUnLockFunc:GetRelatedMenuIDByMenuID(menuList, menuid)
  local menuConfig = Table_Menu[menuid]
  if menuConfig then
    local condition = menuConfig.Condition
    if condition and condition.menu then
      local checkType = condition.menu[1]
      if checkType == 0 or checkType == 1 then
        for i = 2, #condition.menu do
          local singleMenu = condition.menu[i]
          if not self:CheckCanOpen(singleMenu) then
            self:GetRelatedMenuIDByMenuID(menuList, condition.menu[i])
          end
        end
      end
    else
      table.insert(menuList, menuid)
    end
  end
end

function FunctionUnLockFunc:IsPrestigeUnlockMenu(menuid)
  local config = GameConfig.Prestige.PrestigeUnlockMenu
  if not config then
    return false
  end
  for version, id in pairs(config) do
    if id == menuid and self:UnLockMenu(menuid) then
      GameFacade.Instance:sendNotification(UIMenuEvent.UnlockPrestige)
      return true
    end
  end
end
