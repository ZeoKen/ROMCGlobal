local Ignore_InputFocus_Cmd = {send = 1, esc_close = 2}
local facade
local notify = function(notificationName, body, type)
  if facade == nil then
    facade = GameFacade.Instance
  end
  facade:sendNotification(notificationName, body, type)
end
local Func_HasUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  return hasNode
end
local Func_HasOtherUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return
  end
  local hasNode = UIManagerProxy.Instance:HasOtherUINode(panelConfig)
  return hasNode
end
local OpenViewMutex = {}
local Func_HasMutexUI = function(panelid)
  local mutex = OpenViewMutex[panelid]
  if not mutex then
    return false
  end
  for k, v in pairs(OpenViewMutex) do
    if k ~= panelid and v == mutex and Func_HasUI(k) then
      return true
    end
  end
end
local Func_CheckNoModal = function()
  local popCount = UIManagerProxy.Instance:GetModalPopCount()
  if popCount <= 0 then
    return true
  end
end
local Func_CloseUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if not hasNode then
    return false
  end
  notify(UIEvent.CloseUI, PanelProxy.Instance:GetViewType(panelid))
  return true
end
local Func_PopCloseUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if not hasNode then
    return false
  end
  local tryCount = 0
  while UIManagerProxy.Instance:HasUINode(panelConfig) and tryCount < 15 do
    UIManagerProxy.CSPopView(true)
    tryCount = tryCount + 1
  end
  notify(UIEvent.CloseUI, PanelProxy.Instance:GetViewType(panelid))
  return true
end
local Func_OpenUI = function(panelid, viewdata)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if hasNode then
    return false
  end
  notify(UIEvent.JumpPanel, {view = panelConfig, viewdata = viewdata})
  return true
end
local HotKeyCmd = {}
HotKeyCmd.Type = {
  Forward = "forward",
  Toggle = "toggle",
  Reverse = "reverse"
}

function HotKeyCmd.use_shortskill(data)
  helplog("use_shortskill")
  notify(HotKeyEvent.UseShortCutSkill, data.Param)
  return true
end

function HotKeyCmd.change_shortskill(data)
  helplog("change_shortskill")
  notify(HotKeyEvent.SwitchShortCutSkillIndex, data.Param)
  return true
end

function HotKeyCmd.use_shortitem(data)
  helplog("use_shortitem")
  notify(HotKeyEvent.UseShortCutItem, data.Param)
  return true
end

function HotKeyCmd.auto_battle(data)
  helplog("auto_battle")
  local dtype = data.Type
  if dtype == HotKeyCmd.Type.Toggle then
    local isAuto = Game.AutoBattleManager.on
    if isAuto then
      Game.AutoBattleManager:AutoBattleOff()
    else
      Game.AutoBattleManager:AutoBattleOn()
      if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance:GetCurrentEquipedAutoSkills()) then
        MsgManager.DontAgainConfirmMsgByID(1712)
      end
    end
  elseif dtype == HotKeyCmd.Type.Forward then
    Game.AutoBattleManager:AutoBattleOn()
  elseif dtype == HotKeyCmd.Type.Reverse then
    Game.AutoBattleManager:AutoBattleOff()
  end
  return true
end

local _HandleOpenComPanelIds = function(com_panelid)
  for i = 1, #com_panelid do
    if Func_OpenUI(com_panelid[i]) then
      return true
    end
  end
  return false
end
local _HandleCloseComPanelIds = function(com_panelid)
  local panelProxy = PanelProxy.Instance
  local uiManagerProxy = UIManagerProxy.Instance
  local closeTypes = {}
  for i = 1, #com_panelid do
    local panelid = com_panelid[i]
    local data = panelProxy:GetData(panelid)
    if data == nil then
      redlog(string.format("PanelID:%s Get Data Error!!", panelid))
    end
    local suc = pcall(function()
      if uiManagerProxy:HasUINode(data) then
        local viewType = panelProxy:GetViewType(panelid)
        if viewType then
          table.insert(closeTypes, viewType)
        end
      end
    end)
    if not suc then
      redlog(string.format("PanelID:%s Check Error!!", panelid))
    end
  end
  if #closeTypes == 0 then
    return false
  end
  table.sort(closeTypes, function(v1, v2)
    return v1.depth > v2.depth
  end)
  notify(UIEvent.CloseUI, closeTypes[1])
  return true
end

function HotKeyCmd.open_view(data)
  helplog("open_view")
  local param = data.Param
  local dtype = data.Type
  if param.panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not Func_OpenUI(param.panelid) then
        Func_CloseUI(param.panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return Func_OpenUI(param.panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return Func_CloseUI(param.panelid)
    end
  elseif param.com_panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not _HandleOpenComPanelIds(param.com_panelid) then
        _HandleCloseComPanelIds(param.com_panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return _HandleOpenComPanelIds(param.com_panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return _HandleCloseComPanelIds(param.com_panelid)
    end
  end
  return false
end

function HotKeyCmd.close_view(data)
  helplog("close_view")
  local param = data.Param
  local dtype = data.Type
  if param.panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not Func_CloseUI(param.panelid) then
        Func_OpenUI(param.panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return Func_CloseUI(param.panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return Func_OpenUI(param.panelid)
    end
  elseif param.com_panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not _HandleCloseComPanelIds(param.com_panelid) then
        _HandleOpenComPanelIds(param.com_panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return _HandleCloseComPanelIds(panel.com_panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return _HandleOpenComPanelIds(panel.com_panelid)
    end
  end
  return false
end

function HotKeyCmd.esc_back(data)
  local popCount = UIManagerProxy.Instance:GetModalPopCount()
  if popCount <= 0 then
    return false
  end
  UIManagerProxy.CSPopView()
  return true
end

function HotKeyCmd.open_map(data)
  helplog("open_map")
  local bigWorldNodePassCheck = Game.MapManager:IsCurBigWorld() and UIManagerProxy.Instance:HasUINode(PanelConfig.BWMiniMapView)
  if not bigWorldNodePassCheck and (UIManagerProxy.Instance:HasAnyLayerMaskOn() or UIManagerProxy.Instance:LayerHasAnyNodeShow(UIViewType.NormalLayer) or Func_HasMutexUI(PanelConfig.BWMiniMapView.id)) then
    return false
  end
  notify(HotKeyEvent.OpenMap, data.Type)
  return true
end

function HotKeyCmd.open_teamview(data)
  if NewbieCollegeProxy.Instance.IsInFakeTeam then
    return
  end
  local panelConfig = TeamProxy.Instance:IHaveTeam() and PanelConfig.TeamMemberListPopUp or PanelConfig.TeamFindPopUp
  if UIManagerProxy.Instance:HasAnyLayerMaskOn() or Func_HasOtherUI(panelConfig.id) then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if data.Type == HotKeyCmd.Type.Forward then
    if hasNode then
      return false
    end
    notify(UIEvent.JumpPanel, {view = panelConfig})
    return true
  elseif data.Type == HotKeyCmd.Type.Toggle then
    if hasNode then
      local viewType = PanelProxy.Instance:GetViewType(panelConfig.id)
      notify(UIEvent.CloseUI, viewType)
    else
      if Func_HasMutexUI(panelConfig.id) then
        return false
      end
      notify(UIEvent.JumpPanel, {view = panelConfig})
    end
    return true
  elseif data.Type == HotKeyCmd.Type.Reverse then
    if not hasNode then
      return false
    end
    local viewType = PanelProxy.Instance:GetViewType(panelConfig.id)
    notify(UIEvent.CloseUI, viewType)
    return false
  end
  if not TeamProxy.Instance:IHaveTeam() then
    if Func_HasMutexUI(PanelConfig.TeamFindPopUp.id) then
      return false
    end
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.TeamFindPopUp
    })
  else
    if Func_HasMutexUI(PanelConfig.TeamMemberListPopUp.id) then
      return false
    end
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.TeamMemberListPopUp
    })
  end
  return true
end

function HotKeyCmd.attack(data)
end

function HotKeyCmd.move(data)
end

function HotKeyCmd.choose(data)
end

function HotKeyCmd.send(data)
  helplog("send")
  notify(HotKeyEvent.Send)
  return true
end

function HotKeyCmd.open_view2(data)
  helplog("open_view2")
  local param = data.Param
  local dtype = data.Type
  if param.panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if Func_HasUI(param.panelid) then
        if param.panelid == 181 then
          notify(HotKeyEvent.CloseChatRoom)
        else
          UIManagerProxy.Instance:ReturenToMainView()
        end
        return true
      else
        if UIManagerProxy.Instance:HasAnyLayerMaskOn() or Func_HasOtherUI(param.panelid) ~= false then
          return false
        end
        if Func_HasMutexUI(param.panelid) then
          return false
        end
        local viewdata = {}
        if param.panelid == 181 then
          viewdata.isSelected = true
        end
        return Func_OpenUI(param.panelid, viewdata)
      end
    elseif dtype == HotKeyCmd.Type.Forward then
      if not (not UIManagerProxy.Instance:HasAnyLayerMaskOn() or Func_HasUI(param.panelid)) or Func_HasOtherUI(param.panelid) ~= false then
        return false
      end
      if Func_HasMutexUI(param.panelid) then
        return false
      end
      return Func_OpenUI(param.panelid)
    elseif dtype == HotKeyCmd.Type.Reverse and Func_HasUI(param.panelid) then
      UIManagerProxy.Instance:ReturenToMainView()
      return true
    end
  end
  return false
end

function HotKeyCmd.esc_close(data)
  local popCount = UIManagerProxy.Instance:GetModalPopCount()
  if popCount <= 0 then
    return false
  end
  if Game.WindowsEscPanel then
    for _, panelid in ipairs(Game.WindowsEscPanel) do
      if Func_HasUI(panelid) then
        Func_CloseUI(panelid)
      end
    end
  end
  return true
end

function HotKeyCmd.dialog(eventname)
  local hasDialogView = UIManagerProxy.Instance:HasUINodeByClassName("DialogView") or UIManagerProxy.Instance:HasUINodeByClassName("ExtendDialogView")
  if not hasDialogView then
    return false
  end
  local hasPlotStoryView = UIManagerProxy.Instance:HasUINodeByClassName("PlotStoryView") or UIManagerProxy.Instance:HasUINodeByClassName("PlotStoryTopView")
  local hasWeakDialogView = UIManagerProxy.Instance:HasUINodeByClassName("WeakDialogView")
  if UIManagerProxy.Instance:GetModalPopCount() > 1 and not hasPlotStoryView and not hasWeakDialogView then
    return false
  end
  helplog(eventname)
  notify(eventname)
  return true
end

function HotKeyCmd.player_action(data)
  if not Func_CheckNoModal() then
    return false
  end
  helplog("player_action")
  local action_id = data.Param and data.Param.id
  autoImport("UIEmojiView")
  UIEmojiView.PlayActionTypeEmoji(action_id)
  return true
end

function HotKeyCmd.lock_target(data)
  if not Func_CheckNoModal() or not UIManagerProxy.Instance:HasUINodeByClassName("MainView") then
    return false
  end
  helplog("lock_target")
  notify(HotKeyEvent.AimMonsterSelectTarget)
  return true
end

function HotKeyCmd.follow(data)
  helplog("follow")
  notify(HotKeyEvent.FollowSelectMember)
  return true
end

function HotKeyCmd.select_member(data)
  if not UIManagerProxy.Instance:HasUINodeByClassName("MainView") or not UIManagerProxy.Instance:IsLayerActive(UIViewType.MainLayer) then
    return false
  end
  helplog("select_member")
  notify(HotKeyEvent.SelectMember, data.Param)
  return true
end

function HotKeyCmd.open_chatview(data)
  if not Func_CheckNoModal() or not UIManagerProxy.Instance:HasUINodeByClassName("MainView") then
    return false
  end
  helplog("open_chatview")
  notify(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    force = false
  })
  return true
end

function HotKeyCmd.open_auto_battle_cfg(data)
  if not Func_CheckNoModal() or not UIManagerProxy.Instance:HasUINodeByClassName("MainView") then
    return false
  end
  helplog("open_auto_battle_cfg")
  notify(HotKeyEvent.OpenAutoBattleConfig)
  return true
end

function HotKeyCmd.interact(data)
  if HotKeyCmd.close_popview(data) then
    return true
  end
  if HotKeyCmd.dialog(HotKeyEvent.DialogPushOn) then
    return true
  end
  helplog("interact")
  notify(HotKeyEvent.Interact)
  return true
end

function HotKeyCmd.select_option(data)
  if HotKeyCmd.dialog(HotKeyEvent.DialogSelectOption) then
    return true
  end
  helplog("select_option")
  notify(HotKeyEvent.SelectOption)
  return true
end

function HotKeyCmd.close_popview(data)
  if not UIManagerProxy.Instance:HasUINodeByClassName("PopUp10View") and not UIManagerProxy.Instance:HasUINodeByClassName("SystemUnLockView") then
    return false
  end
  helplog("close_popview")
  notify(HotKeyEvent.ClosePopView)
  return true
end

function HotKeyCmd.quest_guide(data)
  if not Func_CheckNoModal() or not UIManagerProxy.Instance:HasUINodeByClassName("MainView") then
    return false
  end
  helplog("quest_guide")
  notify(HotKeyEvent.QuestGuide)
  return true
end

HotKeyManager = class("HotKeyManager")
local inputKey, inited

function HotKeyManager:ctor()
  self:Init()
end

function HotKeyManager:Init()
  if inited then
    return
  end
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  inputKey = Game.InputKey
  if inputKey == nil then
    return
  end
  inputKey.IsEnable = true
  inputKey.IsEnableMoveAxis = true
  HotKeyManager.Running = false
  inited = true
  self:LoadHotKeyCustomConfig()
  self:RegisterHotKey()
end

local keyCodeNameCache
local Get_KeyCodeName = function(keyCode)
  if not keyCodeNameCache then
    keyCodeNameCache = {}
  end
  local name = keyCodeNameCache[keyCode]
  if name == nil then
    name = inputKey:GetKeyCodeName(keyCode)
    keyCodeNameCache[keyCode] = name
  end
  return name
end
HotKeyManager.GetKeyCodeName = Get_KeyCodeName
local WindowsHotKey_KeyMap, WindowsMouse_KeyMap, WindowsHotKey_CustomConfig, WindowsHotKeyId_UpArrow, WindowsHotKeyId_DownArrow, WindowsHotKeyId_LeftArrow, WindowsHotKeyId_RightArrow, WindowsHotKey_DisableMap
local Init_WindowsHotKey_KeyMap = function(refresh)
  if WindowsHotKey_KeyMap ~= nil and not refresh then
    return
  end
  local last_WindowsHotKey_KeyMap
  if WindowsHotKey_KeyMap ~= nil and refresh then
    last_WindowsHotKey_KeyMap = table.deepcopy(WindowsHotKey_KeyMap)
  end
  OpenViewMutex = {}
  local keyMap = {}
  local customConfig, hotKeySet1, hotKeySet2
  for id, data in pairs(Table_WindowsHotKey) do
    if data.Cmd == "move_up" then
      WindowsHotKeyId_UpArrow = id
    elseif data.Cmd == "move_down" then
      WindowsHotKeyId_DownArrow = id
    elseif data.Cmd == "move_left" then
      WindowsHotKeyId_LeftArrow = id
    elseif data.Cmd == "move_right" then
      WindowsHotKeyId_RightArrow = id
    end
    customConfig = WindowsHotKey_CustomConfig[id]
    hotKeySet1 = customConfig and customConfig[1] and Get_KeyCodeName(customConfig[1]) or data.Hotkey
    hotKeySet2 = customConfig and customConfig[2] and Get_KeyCodeName(customConfig[2])
    if hotKeySet1 and hotKeySet1 ~= "" then
      local t = keyMap[hotKeySet1]
      if t == nil then
        t = {}
        keyMap[hotKeySet1] = t
      end
      table.insert(t, data)
    end
    if hotKeySet2 and hotKeySet2 ~= "" then
      local t = keyMap[hotKeySet2]
      if t == nil then
        t = {}
        keyMap[hotKeySet2] = t
      end
      table.insert(t, data)
    end
    if data.Param and data.Param.view_mutex and data.Param.panelid then
      if type(data.Param.panelid) == "table" then
        for i = 1, #data.Param.panelid do
          OpenViewMutex[data.Param.panelid[i]] = data.Param.view_mutex
        end
      else
        OpenViewMutex[data.Param.panelid] = data.Param.view_mutex
      end
    end
  end
  WindowsHotKey_KeyMap = {}
  WindowsMouse_KeyMap = {}
  WindowsHotKey_DisableMap = {}
  local dataSortFunc = function(da, db)
    return da.id < db.id
  end
  local keyCode = KeyCode
  for key, datas in pairs(keyMap) do
    table.sort(datas, dataSortFunc)
    local keys = string.split(key, "+")
    local isKey = true
    for i = 1, #keys do
      local codeEnum = keyCode[keys[i]]
      if codeEnum == nil then
        isKey = false
        WindowsMouse_KeyMap[key] = datas
        break
      end
      keys[i] = codeEnum
    end
    if isKey then
      local enumKey = table.concat(keys, "+")
      WindowsHotKey_KeyMap[enumKey] = datas
    end
  end
  if refresh then
    if last_WindowsHotKey_KeyMap == nil then
      return
    end
    local cmpFunc = function(dsa, dsb)
      if dsa == nil or dsb == nil then
        return false
      end
      if #dsa ~= #dsb then
        return false
      end
      for i = 1, #dsa do
        if dsa[i].id ~= dsb[i].id then
          return false
        end
      end
      return true
    end
    local diff_unreg, diff_reg = {}, {}
    for key, datas in pairs(WindowsHotKey_KeyMap) do
      if last_WindowsHotKey_KeyMap[key] == nil then
        diff_reg[key] = datas
      elseif not cmpFunc(datas, last_WindowsHotKey_KeyMap[key]) then
        diff_unreg[key] = datas
        diff_reg[key] = datas
      end
    end
    for key, datas in pairs(last_WindowsHotKey_KeyMap) do
      if WindowsHotKey_KeyMap[key] == nil then
        diff_unreg[key] = datas
      end
    end
    return diff_unreg, diff_reg
  end
end

function HotKeyManager.ExcuteHotKeyEvent(key1, key2)
  if not HotKeyManager.Running then
    redlog("HotKeyManager Not In Running")
    return
  end
  if WindowsHotKey_KeyMap == nil then
    redlog("HotKeyManager Not Init")
    return
  end
  local enumKey = ""
  if key1 and key1 ~= 0 then
    enumKey = tostring(key1)
  end
  if key2 and key2 ~= 0 then
    enumKey = key1 .. "+" .. key2
  end
  if HotKeyManager.InEditMode and enumKey ~= "27" then
    redlog("HotKeyManager Is In EditMode")
    return
  end
  local datas = WindowsHotKey_KeyMap[enumKey]
  if datas == nil then
    error("not find hotKey:" .. enumKey)
    return
  end
  for i = 1, #datas do
    if HotKeyManager.ExcuteCmdByData(datas[i]) then
      return
    end
  end
end

function HotKeyManager.ExcuteCmdByData(data)
  local cmd = data.Cmd
  if WindowsHotKey_DisableMap and WindowsHotKey_DisableMap[data.id] then
    return false
  end
  if UICamera.inputHasFocus and not Ignore_InputFocus_Cmd[cmd] then
    redlog("Foucsing Input")
    return false
  end
  local event = HotKeyCmd[cmd]
  if event and event(data) then
    return true
  end
end

function HotKeyManager:RegisterHotKey(refresh)
  local config = Table_WindowsHotKey
  if config == nil then
    return
  end
  local diff_unreg, diff_reg
  if WindowsHotKey_KeyMap == nil or refresh then
    diff_unreg, diff_reg = Init_WindowsHotKey_KeyMap(refresh)
  end
  if diff_unreg and diff_reg then
    for keyEnum, datas in pairs(diff_unreg) do
      local keys = string.split(keyEnum, "+")
      for _, data in pairs(datas) do
        if data.id == WindowsHotKeyId_UpArrow or data.id == WindowsHotKeyId_DownArrow or data.id == WindowsHotKeyId_LeftArrow or data.id == WindowsHotKeyId_RightArrow then
          inputKey:UngisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]))
          inputKey:UngisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]))
        end
      end
      if #keys == 1 then
        inputKey:Ungister(RO.InputKey.KeyState.Down, tonumber(keys[1]))
      elseif #keys == 2 then
        inputKey:Ungister(RO.InputKey.KeyState.Down, tonumber(keys[1]), tonumber(keys[2]))
      end
    end
    for keyEnum, datas in pairs(diff_reg) do
      local keys = string.split(keyEnum, "+")
      local isMoveAxis = false
      for _, data in pairs(datas) do
        if data.id == WindowsHotKeyId_UpArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), false, true)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), false, true)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_DownArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), false, false)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), false, false)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_LeftArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), true, false)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), true, false)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_RightArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), true, true)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), true, true)
          isMoveAxis = true
        end
      end
      if not isMoveAxis then
        if #keys == 1 then
          inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), HotKeyManager.ExcuteHotKeyEvent)
        elseif #keys == 2 then
          inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), tonumber(keys[2]), HotKeyManager.ExcuteHotKeyEvent)
        end
      end
    end
  else
    for keyEnum, datas in pairs(WindowsHotKey_KeyMap) do
      local keys = string.split(keyEnum, "+")
      local isMoveAxis = false
      for _, data in pairs(datas) do
        if data.id == WindowsHotKeyId_UpArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), false, true)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), false, true)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_DownArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), false, false)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), false, false)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_LeftArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), true, false)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), true, false)
          isMoveAxis = true
        elseif data.id == WindowsHotKeyId_RightArrow then
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Down, tonumber(keys[1]), true, true)
          inputKey:RegisterMoveAxis(RO.InputKey.KeyState.Press, tonumber(keys[1]), true, true)
          isMoveAxis = true
        end
      end
      if not isMoveAxis then
        if #keys == 1 then
          inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), HotKeyManager.ExcuteHotKeyEvent)
        elseif #keys == 2 then
          inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), tonumber(keys[2]), HotKeyManager.ExcuteHotKeyEvent)
        end
      end
    end
  end
end

function HotKeyManager:Launch()
  self:Init()
  if HotKeyManager.Running then
    return
  end
  if inputKey then
    inputKey.IsEnable = true
  end
  HotKeyManager.Running = true
end

function HotKeyManager:Shutdown()
  if not inited then
    return
  end
  if not HotKeyManager.Running then
    return
  end
  HotKeyManager.Running = false
  if inputKey then
    inputKey.IsEnable = false
  end
  keyCodeNameCache = nil
end

function HotKeyManager:SetEnable(isEnable)
  if not inited then
    return
  end
  if inputKey then
    inputKey.IsEnable = isEnable ~= nil and isEnable == true
  end
  HotKeyManager.Running = isEnable ~= nil and isEnable == true
end

function HotKeyManager:SetMoveAxisEnable(enable)
  if not HotKeyManager.Running then
    return
  end
  if inputKey then
    inputKey.IsMoveAxisEnable = enable ~= nil and enable == true
  end
end

function HotKeyManager:SetHotKeyEnable(id, enable)
  if not WindowsHotKey_DisableMap then
    return
  end
  WindowsHotKey_DisableMap[id] = not enable
end

local SAVE_KEY = {
  WindowsHotKeyPref_Full = "WindowsHotKeyPref_Full",
  WindowsHotKeyPref_Move = "WindowsHotKeyPref_Move"
}

function HotKeyManager:LoadHotKeyCustomConfig()
  local customRaw = PlayerPrefs.GetString(SAVE_KEY.WindowsHotKeyPref_Full, "{}")
  WindowsHotKey_CustomConfig = loadstring("return " .. customRaw)()
end

function HotKeyManager:SetHotKeyCustom(hotkey_id, keycode, index)
  index = index or 1
  local customConfig, hotKeySet = WindowsHotKey_CustomConfig[hotkey_id]
  if not customConfig then
    customConfig = {}
    WindowsHotKey_CustomConfig[hotkey_id] = customConfig
  end
  if index == 1 then
    customConfig[1] = keycode
  elseif index == 2 then
    customConfig[2] = keycode
  end
end

function HotKeyManager:GetHotKeyCustom(hotkey_id, index)
  index = index or 1
  local customConfig, hotKeySet = WindowsHotKey_CustomConfig[hotkey_id]
  if index == 1 then
    hotKeySet = customConfig and customConfig[1] and Get_KeyCodeName(customConfig[1])
    if not hotKeySet then
      hotKeySet = Table_WindowsHotKey[hotkey_id]
      hotKeySet = hotKeySet and hotKeySet.Hotkey
    end
  elseif index == 2 then
    hotKeySet = customConfig and customConfig[2] and Get_KeyCodeName(customConfig[2])
  end
  return hotKeySet
end

function HotKeyManager:SaveHotKeyCustomConfig()
  local customRaw = TableUtil.ToStringEx(WindowsHotKey_CustomConfig)
  PlayerPrefs.SetString(SAVE_KEY.WindowsHotKeyPref_Full, customRaw)
  PlayerPrefs.Save()
end

function HotKeyManager:ApplyCustomConfig()
  self:RegisterHotKey(true)
end

function HotKeyManager:ResetCustomConfigToDefault()
  WindowsHotKey_CustomConfig = {}
  self:SaveHotKeyCustomConfig()
end

function HotKeyManager:GenerateAllHotKeyInfo()
  local hotKeyInfo = {}
  for hotkey_id, hotKeySet in pairs(Table_WindowsHotKey) do
    if hotKeySet.LimitType ~= "inner" then
      local hotKeyInfoItem = {}
      hotKeyInfoItem.staticData = hotKeySet
      hotKeyInfoItem.id = hotkey_id
      hotKeyInfoItem.name = hotKeySet.Name or hotKeySet.Cmd or ""
      hotKeyInfoItem.hotKey = self:GetHotKeyCustom(hotkey_id)
      hotKeyInfoItem.hotKey2 = self:GetHotKeyCustom(hotkey_id, 2)
      hotKeyInfoItem.hotKeyCode = KeyCode[hotKeyInfoItem.hotKey]
      hotKeyInfoItem.hotKeyCode2 = KeyCode[hotKeyInfoItem.hotKey2]
      hotKeyInfoItem.select = 0
      table.insert(hotKeyInfo, hotKeyInfoItem)
    end
  end
  table.sort(hotKeyInfo, function(a, b)
    if a.staticData and b.staticData and a.staticData.sort and b.staticData.sort then
      return a.staticData.sort < b.staticData.sort
    end
    return a.id < b.id
  end)
  return hotKeyInfo
end

function HotKeyManager:RefreshAllHotKeyInfo(info)
  for _, v in pairs(info) do
    local hotKeyInfoItem = v
    if hotKeyInfoItem then
      local hotkey_id = v.id
      hotKeyInfoItem.hotKey = self:GetHotKeyCustom(hotkey_id)
      hotKeyInfoItem.hotKey2 = self:GetHotKeyCustom(hotkey_id, 2)
      hotKeyInfoItem.hotKeyCode = KeyCode[hotKeyInfoItem.hotKey]
      hotKeyInfoItem.hotKeyCode2 = KeyCode[hotKeyInfoItem.hotKey2]
    end
  end
end

function HotKeyManager:EnterCheckKeyMode(checkAction)
  HotKeyManager.Running = false
  inputKey:SetCheckKeyAction(function(key1, key2)
    if checkAction then
      checkAction(key1, key2)
    end
  end)
end

function HotKeyManager:ExitCheckKeyMode()
  HotKeyManager.Running = true
  inputKey:ClearCheckKeyAction()
end

function HotKeyManager:UpdateEnableMoveAxisDirty()
  return not UIManagerProxy.Instance:HasAnyLayerMaskOn()
end

function HotKeyManager:SetEnableMoveAxisDirty()
  if not inited then
    return
  end
  inputKey.IsEnableMoveAxisDirty = true
end

function HotKeyManager:DebugPrint()
  redlog("WindowsHotKey_KeyMap")
  for k, v in pairs(WindowsHotKey_KeyMap) do
    redlog("WindowsHotKey_KeyMap", k, Get_KeyCodeName(tonumber(k)), TableUtil.ToStringEx(v))
  end
  redlog("WindowsHotKey_CustomConfig")
  for k, v in pairs(WindowsHotKey_CustomConfig) do
    redlog("WindowsHotKey_CustomConfig", k, TableUtil.ToStringEx(v))
  end
  redlog("WindowsHotKeyId_UpArrow", WindowsHotKeyId_UpArrow)
  redlog("WindowsHotKeyId_DownArrow", WindowsHotKeyId_DownArrow)
  redlog("WindowsHotKeyId_LeftArrow", WindowsHotKeyId_LeftArrow)
  redlog("WindowsHotKeyId_RightArrow", WindowsHotKeyId_RightArrow)
end
