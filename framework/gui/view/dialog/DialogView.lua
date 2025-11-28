DialogView = class("DialogView", ContainerView)
DialogView.ViewType = UIViewType.DialogLayer
autoImport("Dialog_MenuData")
autoImport("NpcMenuBtnCell")
autoImport("DialogCell")
autoImport("EndLessTowerCountDownInfo")
autoImport("TimeTickDialogView")
local specialNpcCameraMap, specialNpcCameraVPMap, specialNpcCameraRotMap

function DialogView.ShowNPCDialog(dialogId, npcId, callback)
  local dialogData = DialogUtil.GetDialogData(dialogId)
  if not dialogData or not dialogData.Text then
    return false
  end
  local npcInfo = NSceneNpcProxy.Instance:Find(npcId)
  if not npcInfo then
    return false
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      dialogData.Text
    },
    npcinfo = npcInfo,
    callback = callback
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  return true
end

function DialogView:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end

function DialogView:Init()
  self:InitView()
  self:MapEvent()
end

function DialogView:InitView()
  self.menu = self:FindGO("Menu")
  self.menuSprite = self.menu:GetComponent(UISprite)
  local bottom = self:FindGO("Anchor_bottom")
  local activeH = Game.GameObjectUtil:GetUIActiveHeight(self.gameObject)
  bottom.transform.localPosition = LuaGeometry.GetTempVector3(0, -activeH / 2, 0)
  self.top = self:FindGO("Anchor_Top")
  self.top.transform.localPosition = LuaGeometry.GetTempVector3(0, activeH / 2, 0)
  local obj = self:LoadPreferb("cell/DialogCell", self:FindGO("Anchor_bottom"))
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.dialogCtl = DialogCell.new(obj)
  self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDialogEvent, self)
  self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView)
  self.grid = self:FindChild("MenuGrid", self.menu):GetComponent(UIGrid)
  self.menuCtl = UIGridListCtrl.new(self.grid, NpcMenuBtnCell, "NpcMenuBtnCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self)
  self.Purikura = self:FindGO("Purikura", bottom)
  if self.Purikura then
    self.Purikura_UITexture = self.Purikura:GetComponent(UITexture)
  end
  self.npcModel = self:FindGO("NPCModel", bottom)
  if self.npcModel then
    self.npcModelTexture = self:FindGO("npcTexture"):GetComponent(UITexture)
    self.modelRoot = self:FindGO("ModelRoot")
  end
end

function DialogView:ClickDialogEvent()
  if self.clickDialogFunc and self.clickDialogFuncData then
    local cellData = self.clickDialogFuncData
    local npcinfo = self:GetCurNpc()
    if cellData.closeDialog == true then
      if cellData.waitClose ~= nil then
        self.optionWait = cellData.waitClose
      end
      self:CloseSelf()
    end
    if cellData.clickCall then
      local stay = cellData.clickCall(npcinfo, cellData.clickCallParam)
      if cellData.closeDialog ~= true and stay == false then
        self:CloseSelf()
      end
    end
    return
  end
  local preDialog = self.dialogInfo and self.dialogIndex and self.dialogInfo[self.dialogIndex]
  if preDialog and StringUtil.IsEmpty(preDialog.Option) and self.forceClickMenu ~= true then
    self:PlayUISound(AudioMap.UI.DialogClick)
    self:DialogGoUpdate()
  end
end

function DialogView:ResetViewData()
  self.defaultDialog = nil
  self.dialoglist = nil
  self.dialognpcs = nil
  self.tasks = nil
  self.callback = nil
  self.callbackData = nil
  self.camera = nil
  self.cameraVP = nil
  self.cameraRot = nil
  self.wait = nil
  self.questId = nil
  self.showPurikura = nil
  self.specialMarks = nil
  self.turnToMe = nil
  if self.questParams then
    TableUtility.ArrayClear(self.questParams)
  else
    self.questParams = {}
  end
  self.addconfig = nil
  self.addleft = nil
  self.addfunc = nil
  self.custommenudata = nil
  self.npcguid = nil
  self.npcdata = nil
  self.optionid = nil
  self.dialogInfo = nil
  self.dialogIndex = nil
  self.dialogend = false
  self.subViewId = nil
  self.optionWait = 0
  self.midShowFunc = nil
  self.midShowFuncParam = nil
  self.midHideFunc = nil
  self.forceClickMenu = false
  self.clickDialogFunc = nil
  self.clickDialogFuncData = nil
  self.isCFEffectActive = nil
  self.keepVisitRef = nil
  self.forceNotify = false
  self.keepOpen = nil
  self.noFocus = nil
  self.isExtendDialog = nil
  self.pveRaidEntrances = nil
end

function DialogView:ReloadView()
  self:ResetViewData()
  self:UpdateViewData()
  self:UpdateShow()
end

function DialogView:OnEnter()
  DialogView.super.OnEnter(self)
  EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.CloseSelf, self)
  self:ResetViewData()
  self:UpdateViewData()
  local npcinfo = self:GetCurNpc()
  if self:IsSyncSceneVisit() and npcinfo and not QuestProxy.Instance:CheckVisitNpcAvailable(npcinfo.data.id, Game.Myself.data.id) then
    MsgManager.ShowMsgByID(43345)
    self:CloseSelf()
    return
  end
  self:UpdateShow()
  self.gameObject:SetActive(true)
  if npcinfo then
    if not specialNpcCameraMap then
      specialNpcCameraMap = {}
      if GameConfig.TechTreeDialogCamera then
        for _, id in pairs(GameConfig.TechTreeDialogCamera) do
          specialNpcCameraMap[id] = CameraConfig.NPC_Dialog_TechTree_ViewPort_Z
        end
      end
    end
    local npcRootTrans = npcinfo.assetRole.completeTransform
    if npcRootTrans and not self.noFocus then
      local viewPort = CameraConfig.NPC_Dialog_ViewPort
      self.camera = self.camera or specialNpcCameraMap[npcinfo.data.staticData.id]
      if type(self.camera) == "number" then
        viewPort = Vector3(viewPort.x, viewPort.y, self.camera)
      end
      if self.cameraVP then
        viewPort = Vector3(self.cameraVP[1], self.cameraVP[2], self.cameraVP[3])
      end
      local duration = CameraConfig.NPC_Dialog_DURATION
      if self.cameraRot then
        local rotation = Vector3(self.cameraRot[1], self.cameraRot[2], self.cameraRot[3])
        local ctf = self:CameraFocusAndRotateTo(npcRootTrans, viewPort, rotation, duration)
        FunctionCameraEffect.Me():SetDialogViewEffect(ctf)
      else
        local focusOffset = LuaVector3.Zero()
        if npcinfo.data.staticData.CameraOffset then
          LuaVector3.Better_Set(focusOffset, 0, npcinfo.data.staticData.CameraOffset, 0)
        end
        local ctf = self:CameraFocusOnNpc(npcRootTrans, viewPort, duration, nil, focusOffset)
        FunctionCameraEffect.Me():SetDialogViewEffect(ctf)
      end
      self:ShowCameraEffect(self.nowDialogData, duration)
    end
  end
  if self.turnToMe and npcinfo then
    npcinfo:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, Game.Myself.data.id)
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, npcinfo.data.id)
  end
  local midShowFunc = self.viewdata.midShowFunc
  if midShowFunc then
    self.midHideFunc = midShowFunc(self.gameObject, self.viewdata.midShowFuncParam)
  end
  if not self.keepVisitRef then
    FunctionVisitNpc.Me():AddVisitRef()
  end
  if Game.MapManager:IsRaidMode() and not Game.MapManager:IsInGuildMap() then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, false)
  end
  Game.PerformanceManager:LODHigh()
end

function DialogView:ShowCameraEffect(dialogData, duration)
  if dialogData then
    local speakerID = 0
    if self.showPurikura and self.showPurikura == 2 then
      speakerID = self.npcdata and self.npcdata.id or 0
    else
      speakerID = dialogData.Speaker or 0
    end
    if speakerID == 0 then
    else
      local npcData = Table_Npc[speakerID]
      if npcData and npcData.Purikura then
        self:SetNpcPurikura(npcData.Purikura)
        goto lbl_54
        local filterId = npcData.Filter or 9
        local cfData = Table_CameraFilters[filterId]
        if cfData then
          self.isCFEffectActive = true
          CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cfData.FilterName, cfData.SpecialEffectsName, false, duration)
        end
      end
    end
  end
  ::lbl_54::
end

function DialogView:UpdateViewData()
  self.defaultDialog = self.viewdata.defaultDialog
  self.dialoglist = self.viewdata.dialoglist
  self.dialognpcs = self.viewdata.dialognpcs
  self.tasks = self.viewdata.tasks
  self.callback = self.viewdata.callback
  self.callbackData = self.viewdata.callbackData
  self.callbacQuestScope = self.viewdata.questScope
  self.camera = self.viewdata.camera
  self.cameraVP = self.viewdata.cameraVP
  self.cameraRot = self.viewdata.cameraRot
  self.wait = self.viewdata.wait
  self.questId = self.viewdata.questId
  self.addconfig = self.viewdata.addconfig
  self.addleft = self.viewdata.addleft
  self.addfunc = self.viewdata.addfunc
  self.subViewId = self.viewdata.subViewId
  self.forceClickMenu = self.viewdata.forceClickMenu
  self.custommenudata = self.viewdata.custommenudata
  self.showPurikura = self.viewdata.showPurikura
  self.clickDialogFunc = self.viewdata.clickDialogFunc
  self.specialMarks = self.viewdata.specialMarks
  self.turnToMe = self.viewdata.turnToMe
  self.keepVisitRef = self.viewdata.keepVisitRef
  self.forceNotify = self.viewdata.forceNotify
  self.keepOpen = self.viewdata.keepOpen
  self.noFocus = self.viewdata.noFocus
  self.isExtendDialog = self.viewdata.isExtendDialog
  local npcinfo = self.viewdata.npcinfo
  if npcinfo ~= nil then
    self.npcguid = npcinfo.data.id
    self.npcdata = npcinfo.data.staticData
    if self.npcCachePos == nil then
      local p = npcinfo:GetPosition()
      self.npcCachePos = LuaVector3(p.x, p.y, p.z)
    end
    Game.Myself:UpdateEpNodeDisplay(true)
  end
  self.dialogInfo = {}
  self.dialogIndex = 1
  self:UpdateQuestParams()
  self.pveRaidEntrances = self.viewdata.pveRaidEntrances
end

function DialogView:GetCurNpc()
  if self.npcguid then
    return SceneCreatureProxy.FindCreature(self.npcguid)
  end
  return nil
end

function DialogView:UpdateQuestParams()
  if self.questId then
    local questdata = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
    if questdata and questdata.names then
      TableUtility.ArrayShallowCopy(self.questParams, questdata.names)
    end
  end
end

function DialogView:UpdateShow()
  if self.dialognpcs ~= nil and type(self.dialognpcs) == "table" then
    for _, id in pairs(self.dialognpcs) do
      local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), id)
      if npc ~= nil then
        FunctionVisitNpc.Me():NpcTurnToMe(npc)
      end
    end
  end
  if self.dialoglist then
    self:UpdateDialoglst(self.dialoglist)
  else
    self:UpdateDefaultDialog()
  end
end

function DialogView:UpdateDialoglst(dialoglist)
  if 0 < #dialoglist then
    local dlst = {}
    for i = 1, #dialoglist do
      local dilg, data = dialoglist[i]
      if type(dilg) == "number" then
        data = DialogUtil.GetDialogData(dilg)
      elseif type(dilg) == "string" then
        data = {
          id = 0,
          Text = dilg,
          SubViewId = self.subViewId
        }
        if self.npcdata then
          data.Speaker = self.npcdata.id
        end
      elseif type(dilg) == "table" then
        data = {
          id = 0,
          Text = dilg.Text,
          ViceText = dilg.ViceText
        }
        if self.npcdata then
          data.Speaker = self.npcdata.id
        end
      end
      if data then
        table.insert(dlst, data)
      else
        errorLog(string.format("%s not config", dialoglist[i]))
      end
    end
    self.dialogInfo = dlst
    self:UpdateDialog()
  else
    self:CloseSelf()
  end
end

function DialogView:UpdateDefaultDialog()
  if self.npcdata then
    local defaultDialogConfig = self.defaultDialog
    if defaultDialogConfig == nil then
      defaultDialogConfig = self.npcdata.DefaultDialog
    end
    if type(defaultDialogConfig) == "number" then
      defaultDialogConfig = DialogUtil.GetDialogData(defaultDialogConfig)
    end
    if defaultDialogConfig then
      local configs = {}
      if self.npcdata then
        configs = self.npcdata.NpcFunction
      end
      self.dialogInfo = {defaultDialogConfig}
      self:UpdateDialog(configs, self.tasks)
    else
      local configs = self.npcdata.NpcFunction
      local tempData = {
        id = 1,
        Speaker = self.npcdata.id,
        Text = "……",
        NoSpeak = 1
      }
      self.dialogInfo = {tempData}
      self:UpdateDialog(configs, self.tasks)
    end
  else
    self:CloseSelf()
  end
end

function DialogView:UpdateDialog(config, tasks)
  if #self.dialogInfo > 0 then
    self.nowDialogData = self.dialogInfo[self.dialogIndex]
    if self.nowDialogData then
      self.dialogCtl:SetData(self.nowDialogData, self.questParams, self.npcguid, self.isExtendDialog)
      local optionTime = self.nowDialogData.OptionTime
      if self.nowDialogData.Option and self.nowDialogData.Option ~= "" then
        local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(self.nowDialogData.Option))
        if 0 < #optionConfig then
          self:UpdateMenu(config, tasks, optionConfig, optionTime)
        end
      else
        self:UpdateMenu(config, tasks, nil)
      end
      self:UpdateDialogSubView(self.nowDialogData.SubViewId)
      self.menuSprite.enabled = self.nowDialogData.Text ~= ""
      if self.Purikura then
        if self:GetCurNpc() ~= nil or self.showPurikura then
          if self.showPurikura and self.showPurikura == 1 then
            local npcData = Table_Npc[self.nowDialogData.Speaker]
            self:SetNpcPurikura(npcData and npcData.Purikura)
          else
            self:SetNpcPurikura(self.npcdata and self.npcdata.Purikura)
          end
        else
          self.Purikura:SetActive(false)
        end
      end
      if optionTime and 0 < #optionTime then
        if not self.timeTickDialogSubView then
          self.timeTickDialogSubView = self:AddSubView("TimeTickDialogView", TimeTickDialogView, nil, optionTime)
        else
          self.timeTickDialogSubView:ResetData(optionTime[1], optionTime[2])
        end
      else
        self:RemoveTimeTickDialogSubView()
      end
      if ApplicationInfo.IsRunOnWindowns() then
        local cells = self.menuCtl:GetCells()
        if #cells == 0 or not self.menu.activeSelf then
          self.dialogCtl:RegisterHotKeyTip()
        else
          self.dialogCtl:UnregisterHotKeyTip()
        end
      end
    else
      errorLog("Not Find Dialog")
      self:CloseSelf()
    end
  else
    self.nowDialogData = nil
  end
end

function DialogView:SetNpcPurikura(name)
  if not self.Purikura then
    return
  end
  if self.npclihui_cache_name == name then
    return
  end
  self:RemoveNpcPurikura()
  self.Purikura:SetActive(false)
  if name ~= "" and name ~= nil then
    self.npclihui_cache_name = name
    PictureManager.Instance:SetNPCLiHui(name, self.Purikura_UITexture)
    self.Purikura:SetActive(true)
  end
end

function DialogView:RemoveNpcPurikura()
  if not self.Purikura_UITexture then
    return
  end
  if self.npclihui_cache_name ~= "" and self.npclihui_cache_name ~= nil then
    PictureManager.Instance:UnLoadNPCLiHui(self.npclihui_cache_name, self.Purikura_UITexture)
    self.npclihui_cache_name = nil
    self.Purikura_UITexture.mainTexture = nil
  end
end

function DialogView:UpdateDialogSubView(subId)
  self:RemoveDialogSubView()
  if subId == nil then
    return
  end
  self.nowSubId = subId
  local subPage_Class = SubViewMap.Instance:GetSubView(subId)
  local subPage = self:AddSubView(subId, subPage_Class)
  if subPage.OnEnter then
    subPage:OnEnter(subId, self)
  end
end

function DialogView:RemoveDialogSubView()
  if self.nowSubId == nil then
    return
  end
  self:RemoveSubView(self.nowSubId)
  self.nowSubId = nil
end

function DialogView:RemoveTimeTickDialogSubView()
  if self.timeTickDialogSubView then
    self:RemoveSubView("TimeTickDialogView")
    self.timeTickDialogSubView = nil
  end
end

function DialogView:DialogGoUpdate()
  self.dialogend = self.dialogIndex == #self.dialogInfo
  self.dialogIndex = self.dialogIndex + 1
  if self.dialogIndex <= #self.dialogInfo then
    self:UpdateDialog()
  elseif not self.addleft then
    self:CloseSelf()
  end
end

local tempArray = {}

function DialogView:UpdateMenu(configs, tasks, option, optionTime)
  if not self.menuData then
    self.menuData = {}
  else
    TableUtility.ArrayClear(self.menuData)
  end
  if tasks then
    for i = 1, #tasks do
      if tasks[i] then
        if tasks[i].staticData then
          local taskMenuData = Dialog_MenuData.new()
          taskMenuData:Set_ByTask(tasks[i])
          table.insert(self.menuData, taskMenuData)
        else
          errorLog(string.format("Task:%s Not Have StaticData", tasks[i].id))
        end
      end
    end
  end
  if self.pveRaidEntrances then
    for i = 1, #self.pveRaidEntrances do
      local diff = self.pveRaidEntrances[i]
      local menuData = Dialog_MenuData.new()
      menuData:Set_ByPveRaidEntrance(diff)
      table.insert(self.menuData, menuData)
    end
  elseif configs or self.addconfig then
    TableUtility.ArrayClear(tempArray)
    if configs then
      TableUtility.ArrayShallowCopy(tempArray, configs)
    end
    if self.addconfig then
      for i = 1, #self.addconfig do
        table.insert(tempArray, self.addconfig[i])
      end
    end
    for i = 1, #tempArray do
      local typeid, param, name, endfunc = tempArray[i].type, tempArray[i].param, tempArray[i].name, tempArray[i].endfunc
      local npcfunc_menuData = Dialog_MenuData.new()
      npcfunc_menuData:Set_ByNpcFunctionConfig(typeid, param, name, self:GetCurNpc(), endfunc)
      table.insert(self.menuData, npcfunc_menuData)
    end
  end
  if option then
    for i = 1, #option do
      local option_menuData = Dialog_MenuData.new()
      option_menuData:Set_ByOption(option[i])
      table.insert(self.menuData, option_menuData)
    end
  end
  if self.addfunc then
    for i = 1, #self.addfunc do
      local addFunc = self.addfunc[i]
      if addFunc.event and addFunc.NameZh then
        local addfunc_menuData = Dialog_MenuData.new()
        addfunc_menuData:Set_Name(addFunc.NameZh)
        addfunc_menuData:Set_CloseDialogWhenClick(addFunc.closeDialog)
        addfunc_menuData:Set_WaitCloseDialogWhenClick(addFunc.waitClose)
        addfunc_menuData:Set_CusetomClickCall(addFunc.event, addFunc.eventParam)
        table.insert(self.menuData, addfunc_menuData)
      end
    end
  end
  if self.clickDialogFunc then
    local addFunc = self.clickDialogFunc
    if addFunc.event then
      local addfunc_menuData = Dialog_MenuData.new()
      addfunc_menuData:Set_Name(addFunc.NameZh or "")
      addfunc_menuData:Set_CloseDialogWhenClick(addFunc.closeDialog)
      addfunc_menuData:Set_WaitCloseDialogWhenClick(addFunc.waitClose)
      addfunc_menuData:Set_CusetomClickCall(addFunc.event, addFunc.eventParam)
      self.clickDialogFuncData = addfunc_menuData
    end
  end
  if self.custommenudata then
    for i = 1, #self.custommenudata do
      table.insert(self.menuData, self.custommenudata[i])
    end
  end
  if self.addleft then
    local addleft_menuData = Dialog_MenuData.new()
    addleft_menuData:Set_CusetomClickCall()
    addleft_menuData:Set_CloseDialogWhenClick(true)
    addleft_menuData:Set_Name(ZhString.DialogView_Left)
    table.insert(self.menuData, addleft_menuData)
  end
  self:UpdateMenuCtl(nil, optionTime)
end

function DialogView:RegisterMenuEvent(btnGO, optionid, needReplace)
  if btnGO == nil or optionid == nil then
    redlog("btnGO or optionid is nil")
    return
  end
  local menuDataDirty = false
  local optionData, m
  for i = #self.menuData, 1, -1 do
    m = self.menuData[i]
    if m.optionid == optionid then
      optionData = m
      if needReplace then
        menuDataDirty = true
        table.remove(self.menuData, i)
      end
      break
    end
  end
  local func = function()
    if optionData == nil then
      self:CloseSelf()
    else
      self:DoMenuEvent(optionData)
    end
  end
  self:AddClickEvent(btnGO, func)
  if menuDataDirty then
    self:UpdateMenuCtl()
  end
end

function DialogView:UpdateMenuCtl(menuData, optionTime)
  if optionTime and 0 < #optionTime then
    self.menu:SetActive(false)
    return
  end
  self.menu:SetActive(true)
  DialogUtil.SetViewMenuCtlByMenuData(self.menu, self.menuCtl, menuData or self.menuData)
  local cells, greyCount = self.menuCtl:GetCells(), 0
  for _, c in pairs(cells) do
    if c.style == NpcMenuBtnCell.Style.Grey then
      greyCount = greyCount + 1
    end
  end
  if 0 < greyCount and greyCount == #cells then
    self:HandleAllGreyMenu()
  end
  if ApplicationInfo.IsRunOnWindowns() then
    TimeTickManager.Me():CreateOnceDelayTick(100, function()
      self:SelectMenu(1)
    end, self)
  end
end

function DialogView:ClickMenuEvent(cellCtl)
  local cellData = cellCtl.data
  if not cellData then
    return
  end
  self:DoMenuEvent(cellData)
end

function DialogView:DoMenuEvent(cellData)
  local menuType = cellData.menuType
  local npcinfo = self:GetCurNpc()
  if menuType == Dialog_MenuData_Type.NpcFunc then
    self.dialogend = true
    local stay = FunctionNpcFunc.Me():DoNpcFunc(cellData.npcFuncData, npcinfo, cellData.param, cellData.endfunc)
    if not stay then
      DialogView.super.CloseSelf(self)
    end
  elseif menuType == Dialog_MenuData_Type.Option then
    self.optionid = cellData.optionid
    if self.optionid == 0 then
      redlog("Optionid == 0  dialogGoUpdate")
      self:DialogGoUpdate()
    elseif self.keepOpen then
      if self.callback then
        local ret = self.callback(self.callbackData, self.optionid, true, self.callbacQuestScope)
        self.callback = nil
        self.callbackData = nil
        if ret then
          self.dialogend = true
          self:CloseSelf()
        end
      end
    else
      self.dialogend = true
      xdlog("OptionId exist, closeself", self.optionid)
      self:CloseSelf()
    end
  elseif menuType == Dialog_MenuData_Type.Task then
    if cellData.task then
      if self.callback then
        self.callback(cellData.task.id, self.optionid, nil, self.callbacQuestScope)
      end
      FunctionVisitNpc.Me():ExcuteQuestEvent(npcinfo, cellData.task)
    end
  elseif menuType == Dialog_MenuData_Type.CustomFunc then
    if cellData.closeDialog == true then
      if cellData.waitClose ~= nil then
        self.optionWait = cellData.waitClose
      end
      self:CloseSelf()
    end
    if cellData.clickCall then
      local stay = cellData.clickCall(npcinfo, cellData.clickCallParam)
      if cellData.closeDialog ~= true and stay == false then
        self:CloseSelf()
      end
    end
  elseif menuType == Dialog_MenuData_Type.PveRaidEntrance then
    if AstralProxy.Instance:IsSeasonEnd() then
      MsgManager.ShowMsgByID(43567)
      return
    end
    local entranceData = cellData.pvePassInfo.staticEntranceData
    FunctionPve.Me():SetCurPve(entranceData)
    local costTime = entranceData.staticData.TimeCost
    if costTime and not ISNoviceServerType then
      local _BattleTimeDataProxy = BattleTimeDataProxy.Instance
      local differenceCostTime = _BattleTimeDataProxy:GetDifferenceCostTime(costTime)
      if differenceCostTime then
        local timeType = _BattleTimeDataProxy:GetGameTimeSetting()
        local id = timeType == BattleTimeDataProxy.ETime.PLAY and 43242 or 43243
        MsgManager.ConfirmMsgByID(id, function()
          if FunctionPve.Me():DoChallenge() then
            self:CloseSelf()
          end
        end, nil, nil, differenceCostTime)
      end
    elseif FunctionPve.Me():DoChallenge() then
      self:CloseSelf()
    end
  elseif menuType == Dialog_MenuData_Type.ChangeMaterial then
  end
end

function DialogView:MapEvent()
  self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.HandleUpdateMap2d)
  self:AddListenEvt(DialogEvent.AddMenuEvent, self.HandleAddMenuEvent)
  self:AddListenEvt(ServiceEvent.NUserRequireNpcFuncUserCmd, self.HandleRequireNpcFuncUserCmd)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs)
  self:AddListenEvt(DialogEvent.NpcFuncStateChange, self.HandleNpcFuncStateChange)
  self:AddListenEvt(DialogEvent.AddUpdateSetTextCall, self.HandleAddUpdateSetTextCall)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleRecvLogin)
  self:AddListenEvt(CarrierEvent.MyCarrierStart, self.CloseSelf)
  self:AddListenEvt(DialogEvent.CloseDialog, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SceneGoToUserCmd, self.HandleGoToUserCmd)
  self:AddListenEvt(SceneUserEvent.NpcSyncMove, self.HandleNpcMove)
  self:AddListenEvt(QuestEvent.DelDahuangEvent, self.HandleDahuangEventDel)
  self:AddListenEvt(ServiceEvent.PhotoCmdBoardQueryAwardPhotoCmd, self.HandlePhotoCmdBoardQueryAwardPhoto)
  self:AddListenEvt(ServiceEvent.SceneTipGameTipCmd, self.HandleSceneTipGameTipCmd)
  self:AddListenEvt(HotKeyEvent.DialogPushOn, self.HandleHotKeyDialogPushOn)
  self:AddListenEvt(HotKeyEvent.DialogSelectOption, self.HandleHotKeyDialogSelectOption)
  self:AddListenEvt(PVEEvent.SyncPvePassInfo, self.HandleSyncPvePassInfo)
end

function DialogView:HandleRecvLogin(note)
  self:CloseSelf()
end

function DialogView:HandleAddUpdateSetTextCall(note)
  self.dialogCtl:Set_UpdateSetTextCall(note.body[1], note.body[2])
end

function DialogView:HandleNpcFuncStateChange(note)
  local changeFuncs = note.body
  for i = 1, #changeFuncs do
    local cache = changeFuncs[i]
    local menuData, index
    for j = #self.menuData, 1, -1 do
      if self.menuData[j].key == cache.key then
        menuData = self.menuData[j]
        index = j
        break
      end
    end
    if menuData then
      menuData:Set_State(cache.state)
    end
  end
  self:UpdateMenuCtl()
end

function DialogView:HandleRemoveNpcs(note)
  local npcs = note.body
  if npcs and 0 < #npcs then
    for i = 1, #npcs do
      if self.npcguid == npcs[i] then
        self:CloseSelf()
      end
    end
  end
end

function DialogView:HandleNpcMove(note)
  local id = note.body
  if id == self.npcguid then
    local target = self:GetCurNpc()
    if target == nil then
      self:CloseSelf()
    end
    if LuaVector3.Distance_Square(self.npcCachePos, target:GetPosition()) > 0.01 then
      self:CloseSelf()
    end
  end
end

function DialogView:HandleUpdateMap2d(note)
  local npcinfo = self:GetCurNpc()
  if npcinfo then
    local npc = FunctionVisitNpc.Me():GetTarget()
    if npc ~= npcinfo then
      DialogView.super.CloseSelf(self)
    end
  end
end

function DialogView:HandleAddMenuEvent(note)
  local config = note.body
  if config == nil then
    return
  end
  local npcinfo = self:GetCurNpc()
  local dialog_menuData = Dialog_MenuData.new()
  dialog_menuData:Set_ByNpcFunctionConfig(config.type, config.param, config.name, npcinfo)
  table.insert(self.menuData, 1, dialog_menuData)
  helplog("HandleAddMenuEvent 3", dialog_menuData.state, config.type, config.param, config.name, npcinfo)
  self:UpdateMenuCtl()
end

function DialogView:HandleRequireNpcFuncUserCmd(note)
  local data = note.body
  local npcinfo = self:GetCurNpc()
  if data == nil or npcinfo == nil then
    return
  end
  local functions = data.functions
  if functions then
    for i = 1, #functions do
      local config = StringUtil.Json2Lua(functions[i])
      if type(config) == "table" then
        local dialog_menuData = Dialog_MenuData.new()
        dialog_menuData:Set_ByNpcFunctionConfig(config.type, config.param, config.name, npcinfo)
        table.insert(self.menuData, 1, dialog_menuData)
      end
    end
    self:UpdateMenuCtl()
  end
end

function DialogView:HandleAllGreyMenu()
  local npcInfo = self:GetCurNpc()
  if npcInfo then
    local npcSId = npcInfo.data.staticData.id
    if npcSId == 9312 then
      self.menu:SetActive(false)
      self.dialogCtl:SetContext(ZhString.DialogView_DeadBoss_AllComplete)
    end
  end
end

function DialogView:HandleDahuangEventDel(note)
  local delList = note.body
  if delList then
    for i = 1, #delList do
      local single = delList[i]
      if single == self.specialMarks then
        self:CloseSelf()
        return
      end
    end
  end
end

function DialogView:HandleGoToUserCmd(note)
  if self.questId then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
    if questData and questData.params and questData.params.forceFailJump then
      ServiceQuestProxy.Instance:CallResetSingleQuestCmd(self.questId)
      self.callBack = nil
      self.callbackData = nil
      self:CloseSelf()
    end
  end
end

function DialogView:HandlePhotoCmdBoardQueryAwardPhoto(note)
  local cells = self.menuCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].UpdateRedTip then
        cells[i]:UpdateRedTip()
      end
    end
  end
end

function DialogView:HandleSceneTipGameTipCmd(note)
  local cells = self.menuCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].UpdateRedTip then
        cells[i]:UpdateRedTip()
      end
    end
  end
end

function DialogView:HandleHotKeyDialogPushOn(note)
  local cells = self.menuCtl:GetCells()
  if 0 < #cells then
    local cell = cells[self.selectMenuIndex]
    if cell ~= nil then
      self:ClickMenuEvent(cell)
    end
  else
    self:ClickDialogEvent()
  end
end

function DialogView:HandleHotKeyDialogSelectOption()
  local cells = self.menuCtl:GetCells()
  local length = #cells
  if length == 0 then
    return
  end
  local index = self.selectMenuIndex + 1
  if index > #cells then
    index = 1
  end
  self:SelectMenu(index)
end

function DialogView:HandleSyncPvePassInfo()
  if self.pveRaidEntrances then
    self:UpdateMenu()
  end
end

function DialogView:RemoveLeanTween()
  if self.lt then
    self.lt:Destroy()
  end
  self.lt = nil
end

function DialogView:CheckOptionValid()
  local curOption = self.optionid or 0
  local cells = self.menuCtl:GetCells()
  local optionList = {}
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].optionid then
        table.insert(optionList, cells[i].optionid)
      end
    end
  end
  if 0 < #optionList then
    return TableUtility.ArrayFindIndex(optionList, curOption)
  else
    return true
  end
end

function DialogView:CloseSelf()
  if self.dialogend and self.callback ~= nil and self:CheckOptionValid() then
    self.callback(self.callbackData, self.optionid, true, self.callbacQuestScope)
    self.callback = nil
    self.callbackData = nil
  end
  self.gameObject:SetActive(false)
  local wait = self.wait or self.optionWait or 0
  if 0 < wait then
    self:RemoveLeanTween()
    self.lt = TimeTickManager.Me():CreateOnceDelayTick(wait * 1000, function(owner, deltaTime)
      DialogView.super.CloseSelf(self)
      Game.Myself:UpdateEpNodeDisplay(false)
    end, self)
  else
    DialogView.super.CloseSelf(self)
    Game.Myself:UpdateEpNodeDisplay(false)
  end
end

function DialogView:OnExit()
  Game.PerformanceManager:ResetLOD()
  self.menuScrollView:DisableSpring()
  EventManager.Me():RemoveEventListener(LoadSceneEvent.BeginLoadScene, self.CloseSelf, self)
  self:RemoveDialogSubView()
  self:RemoveTimeTickDialogSubView()
  DialogView.super.OnExit(self)
  if Game.MapManager:IsRaidMode() then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, true)
  end
  if not self.keepVisitRef then
    FunctionVisitNpc.Me():RemoveVisitRef(self:IsSyncSceneVisit())
  end
  FunctionNpcFunc.Me():ClearUpdateCheck()
  if self.callback ~= nil and self.forceNotify then
    self.callback(self.callbackData, nil, false, self.callbacQuestScope)
    self.callback = nil
    self.callbackData = nil
  end
  if type(self.midHideFunc) == "function" then
    self.midHideFunc()
    self.midHideFunc = nil
  end
  self.dialogCtl:OnExit()
  local ignoreFocus = self.nowDialogData and self.nowDialogData.IgnoreFocus and self.nowDialogData.IgnoreFocus == 1
  if not ignoreFocus then
    self:CameraReset()
  end
  self:RemoveLeanTween()
  if self.dialognpcs ~= nil and type(self.dialognpcs) == "table" then
    for _, id in pairs(self.dialognpcs) do
      local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), id)
      if npc ~= nil then
        FunctionVisitNpc.Me():NpcTurnBack(npc)
      end
    end
  end
  self:RemoveNpcPurikura()
  local cells = self.menuCtl:GetCells()
  for i = 1, #cells do
    Game.HotKeyTipManager:RemoveHotKeyTip(5, cells[i].bg)
  end
  self.menuCtl:RemoveAll()
  self.menu:SetActive(false)
  if self.isCFEffectActive then
    CameraFilterProxy.Instance:CFQuit()
  end
  self.menuScrollView.transform.localPosition = LuaGeometry.GetTempVector3(-150, 119, 0)
  self.menuScrollView.panel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
end

function DialogView:IsSyncSceneVisit()
  if self.questId then
    local questdata = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
    if questdata and questdata.params and questdata.params.is_single then
      return true
    end
  end
  return false
end

function DialogView:SelectMenu(index)
  local cells = self.menuCtl:GetCells()
  if #cells == 0 then
    return
  end
  for i = 1, #cells do
    if i ~= index then
      Game.HotKeyTipManager:RemoveHotKeyTip(5, cells[i].bg)
    end
  end
  local cell = cells[index]
  if cell ~= nil then
    self.selectMenuIndex = index
    helplog("SelectMenu", index)
    Game.HotKeyTipManager:RegisterHotKeyTip(5, cell.bg, NGUIUtil.AnchorSide.TopLeft, {7, -8})
    self.menuCtl:ScrollToIndex(index, true)
  end
end
