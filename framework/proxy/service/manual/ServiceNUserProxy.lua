local test = autoImport("ServiceNUserAutoProxy")
autoImport("SSPUploadStatusManager")
autoImport("NetIngUnionWallPhoto_ScenicSpot")
autoImport("NetIngUnionWallPhoto_Personal")
autoImport("NetIngScenicSpotPhotoNew")
autoImport("NetIngPersonalPhoto")
autoImport("NetIngUnionLogo")
autoImport("NetIngMarryPhoto")
ServiceNUserProxy = class("ServiceNUserProxy", ServiceNUserAutoProxy)
ServiceNUserProxy.Instance = nil
ServiceNUserProxy.NAME = "ServiceNUserProxy"

function ServiceNUserProxy:ctor(proxyName)
  if ServiceNUserProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNUserProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNUserProxy.Instance = self
  end
end

function ServiceNUserProxy:RecvSysMsg(data)
  if data and data.id == 2654 then
    self:Notify(FunctionNewCreateRoleEvent.ESYSTEMMSG_ID_TEXT_ADVERTISE, {
      body = ErrorUserCmd_pb.REG_ERR_NAME_INVALID
    })
  elseif not FunctionCheck.Me():CheckSysMsg() then
    return
  end
  if data.id == 989 then
    self:Notify(ServiceEvent.NUserSysMsg, data)
  end
  if data.delay ~= 0 then
    local tempData = ReusableTable.CreateTable()
    local params = ReusableTable.CreateTable()
    tempData.id = data.id
    tempData.type = data.type
    for i = 1, #data.params do
      local localData = {}
      localData.param = data.params[i].param
      localData.subparams = data.params[i].subparams
      params[i] = localData
    end
    tempData.params = params
    tempData.act = data.act
    tempData.delay = data.delay
    if data.user then
      tempData.user = clone(data.user)
    end
    self.timeTickId = self.timeTickId == nil and 1 or self.timeTickId + 1
    TimeTickManager.Me():CreateOnceDelayTick(data.delay, function(owner, deltaTime)
      self:ShowSysMsg(tempData)
      for i = 1, #tempData.params do
        params[i] = tempData.params[i].param
      end
      ReusableTable.DestroyAndClearTable(tempData.params)
      ReusableTable.DestroyAndClearTable(tempData)
    end, self, self.timeTickId)
  else
    self:ShowSysMsg(data)
  end
end

function ServiceNUserProxy:getMultLanContent(serverData, key, language)
  if serverData[key] and serverData[key] ~= "" then
    return OverSea.LangManager.Instance():GetLangByKey(serverData[key])
  end
  local lanData = serverData.langparams
  if not lanData then
    return ""
  end
  local param
  local englishParam = ""
  for i = 1, #lanData do
    local single = lanData[i]
    if single.language == language then
      param = single.param
    end
    if single.language == 10 then
      englishParam = single.param
    end
  end
  return param or englishParam
end

function ServiceNUserProxy:getTranslateStr(serverData)
  if not serverData or BranchMgr.IsChina() then
    return serverData
  end
  local transStr = OverSea.LangManager.Instance():GetLangByKey(serverData)
  if serverData == transStr then
    local has_space = string.match(serverData, " ")
    transStr = OverSea.LangManager.Instance():GetLangByKey(serverData:gsub(" ", ""))
    if has_space then
      transStr = transStr .. " "
    end
  end
  return transStr
end

function ServiceNUserProxy:ShowSysMsg(data)
  local params
  if data.params ~= nil and #data.params > 0 then
    params = {}
    local language = ApplicationInfo.GetSystemLanguage()
    for i = 1, #data.params do
      local param = data.params[i]
      if param.subparams and 0 < #param.subparams then
        local sb = LuaStringBuilder.CreateAsTable()
        for j = 1, #param.subparams do
          sb:Append(self:getTranslateStr(param.subparams[j]))
        end
        params[i] = sb:ToString()
        sb:Destroy()
      else
        params[i] = self:getMultLanContent(param, "param", language)
      end
    end
  end
  if data.type == SceneUser2_pb.EMESSAGETYPE_FRAME then
    if data.act == SceneUser2_pb.EMESSAGEACT_DEL then
      MsgManager.RemoveMsgByIDTable(data.id)
    else
      local id = 0
      if Game.Myself ~= nil then
        id = Game.Myself.data.id
      end
      MsgManager.ShowMsgByIDTable(data.id, params, id, nil, data.user)
    end
  elseif data.type == SceneUser2_pb.EMESSAGETYPE_GETEXP then
    SceneUIManager.Instance:FloatRoleTopMsgById(Game.Myself.data.id, data.id, params)
  elseif data.type == SceneUser2_pb.EMESSAGETYPE_TIME_DOWN or data.type == SceneUser2_pb.EMESSAGETYPE_TIME_DOWN_NOT_CLEAR then
    if data.act == SceneUser2_pb.EMESSAGEACT_ADD then
      MsgManager.ShowMsgByIDTable(data.id, params, data.id)
      FloatingPanel.Instance:SetCountDownRemoveOnChangeScene(data.id, data.type == SceneUser2_pb.EMESSAGETYPE_TIME_DOWN)
    else
      UIUtil.EndSceenCountDown(data.id)
    end
  elseif data.type == SceneUser2_pb.EMESSAGETYPE_MIDDLE_SHOW then
    FloatingPanel.Instance:FloatingMidEffect(data.id)
  end
end

function ServiceNUserProxy:ReturnToHomeCity(auto)
  local myValue = Game.Myself.data:GetDownID()
  if myValue and myValue ~= 0 then
    MsgManager.ShowMsgByIDTable(43545)
    return
  end
  local skillId = GameConfig.NewRole.riskskill[2]
  if not SkillProxy.Instance:SkillCanBeUsedByID(skillId, true) then
    MsgManager.ShowMsgByIDTable(42057)
    return
  end
  if not auto then
    Game.Myself:Client_SetFollowLeader(0)
  end
  FunctionSkill.Me():TryUseSkill(skillId)
end

function ServiceNUserProxy:ManualGoCity(id)
  Game.Myself:Client_SetFollowLeader(0)
  error("Go City 已经不能使用，请检查并且屏蔽调用")
  self:CallGoCity(id)
end

function ServiceNUserProxy:AutoGoCity(id)
  error("Go City 已经不能使用，请检查并且屏蔽调用")
  self:CallGoCity(id)
end

function ServiceNUserProxy:CallSetDirection(dir)
  local handInHand, beMaster = Game.Myself:IsHandInHand()
  if handInHand and not beMaster then
    return
  end
  dir = GeometryUtils.UniformAngle(dir)
  ServiceNUserProxy.super.CallSetDirection(self, self:ToServerFloat(dir))
end

function ServiceNUserProxy:CallExitPosUserCmd(pos, exitid, mapid)
  if not NetConfig.PBC then
    local msg = SceneUser2_pb.ExitPosUserCmd()
    msg.pos.x = pos.x
    msg.pos.y = pos.y
    msg.pos.z = pos.z
    msg.mapid = mapid
    if exitid ~= nil then
      msg.exitid = exitid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitPosUserCmd.id
    local msgParam = {}
    msgParam.pos = {}
    msgParam.pos.x = pos.x
    msgParam.pos.y = pos.y
    msgParam.pos.z = pos.z
    msgParam.mapid = mapid
    if exitid ~= nil then
      msgParam.exitid = exitid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNUserProxy:RecvExitPosUserCmd(data)
  Game.AreaTrigger_ExitPoint:ResumeSyncMove()
end

function ServiceNUserProxy:RecvNpcDataSync(data)
  UserProxy.Instance:UpdateRoleData(data)
  self:Notify(ServiceEvent.NUserNpcDataSync, data)
end

function ServiceNUserProxy:RecvUserActionNtf(data)
  self:Notify(ServiceEvent.NUserUserActionNtf, data)
end

function ServiceNUserProxy:RecvUserBuffNineSyncCmd(data)
  FunctionBuff.Me():ServerSyncBuff(data)
end

function ServiceNUserProxy:RecvVarUpdate(data)
  autoImport("FoundElfPopup")
  FoundElfPopup.TryGetFoundElfNumChange(data)
  MyselfProxy.Instance:RecvVarUpdate(data)
  self:Notify(ServiceEvent.NUserVarUpdate, data)
end

function ServiceNUserProxy:RecvUserNineSyncCmd(data)
  UserProxy.Instance:UpdateRoleData(data)
  self:Notify(ServiceEvent.NUserUserNineSyncCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.NUserUserNineSyncCmd, data)
end

function ServiceNUserProxy:RecvMenuList(data)
  local functionUnLockFunc = FunctionUnLockFunc.Me()
  local id
  for i = 1, #data.list do
    id = data.list[i]
    functionUnLockFunc:UnLockMenu(id)
    functionUnLockFunc:UnRegisteEnterBtn(id)
  end
  if data.dellist then
    for i = 1, #data.dellist do
      id = data.dellist[i]
      functionUnLockFunc:LockMenu(id)
    end
  end
  AdventureDataProxy.Instance:NewMenusAdd(data.list)
  self:Notify(ServiceEvent.NUserMenuList, data)
end

function ServiceNUserProxy:RecvNewMenu(data)
  local functionUnLockFunc = FunctionUnLockFunc.Me()
  local listUnlock, listMenu, config, id
  local noshow = data.noshow
  for i = 1, #data.list do
    id = data.list[i]
    functionUnLockFunc:UnRegisteEnterBtn(id)
    if noshow then
      functionUnLockFunc:UnLockMenu(id)
    end
    if not functionUnLockFunc:UnlockuSpecialMenuId(id) then
      config = Table_Menu[id]
      if config then
        if config.type == 3 then
          listMenu = listMenu or {}
          listMenu[#listMenu + 1] = id
        else
          listUnlock = listUnlock or {}
          listUnlock[#listUnlock + 1] = id
        end
      else
        errorLog("no Table_Menu config id " .. id)
      end
    end
  end
  if listUnlock and 0 < #listUnlock and not noshow then
    self:Notify(UIEvent.ShowUI, {
      viewname = "SystemUnLockView"
    })
    self:Notify(SystemUnLockEvent.NUserNewMenu, {
      list = listUnlock,
      animplay = data.animplay
    })
  end
  if listMenu and 0 < #listMenu and not noshow then
    self:Notify(UIEvent.ShowUI, {
      viewname = "PopUp10View"
    })
    self:Notify(PopUp10View.NUserNewMenu, {
      list = listMenu,
      animplay = data.animplay
    })
  end
  AdventureDataProxy.Instance:NewMenusAdd(data.list)
  EventManager.Me():PassEvent(ServiceEvent.NUserNewMenu, data.list)
  self:Notify(ServiceEvent.NUserNewMenu, data)
  WildMvpProxy.Instance:RecvNewMenu(data.list)
end

function ServiceNUserProxy:RecvTeamInfoNine(data)
  local player = NSceneUserProxy.Instance:Find(data.userid)
  if player then
    local teamProxy = TeamProxy.Instance
    if teamProxy:IHaveTeam() then
      player:Camp_SetIsInMyTeam(teamProxy:IsInMyTeam(data.userid))
    end
  end
end

function ServiceNUserProxy:RecvUsePortrait(data)
  self:Notify(ServiceEvent.NUserUsePortrait, data)
end

function ServiceNUserProxy:RecvUseFrame(data)
  self:Notify(ServiceEvent.NUserUseFrame, data)
end

function ServiceNUserProxy:RecvQueryPortraitListUserCmd(data)
  ChangeHeadProxy.Instance:RecvQueryPortraitList(data)
  self:Notify(ServiceEvent.NUserQueryPortraitListUserCmd, data)
end

function ServiceNUserProxy:RecvUpdatePortraitFrame(data)
  helplog("Recv-->NewPortraitFrame")
  ChangeHeadProxy.Instance:RecvUpdatePortraitFrame(data)
  self:Notify(ServiceEvent.NUserUpdatePortraitFrame, data)
end

local notifyChatMsg = function(role, data, text, icon)
  local staticData = role.data and role.data.staticData
  if not staticData then
    return
  end
  local cdata = ReusableTable.CreateTable()
  cdata.id = data.guid
  cdata.portraitImage = icon or staticData.Icon
  local userdata = role.data.userdata
  cdata.baselevel = userdata:Get(UDEnum.ROLELEVEL) or 0
  cdata.channel = ChatChannelEnum.Current
  cdata.str = text
  cdata.name = role.data.name
  cdata.roleType = ChatRoleEnum.Pet
  cdata.voiceid = 0
  cdata.voicetime = 0
  ChatRoomProxy.Instance:TryCreateChatMessage(cdata)
  ReusableTable.DestroyAndClearTable(cdata)
end
local notifyPetChatMsg = function(role, data, text)
  local petid = role.data and role.data.staticData and role.data.staticData.id
  local petInfo = petid and PetProxy.Instance:GetMyPetInfoData(petid)
  if not petInfo then
    return
  end
  notifyChatMsg(role, data, text, petInfo:GetHeadIcon())
end
local talkInfoParam = {}

function ServiceNUserProxy:RecvTalkInfo(data)
  local dialog = DialogUtil.GetDialogData(data.talkid)
  if dialog ~= nil then
    if dialog.Text == "" then
      local role = SceneCreatureProxy.FindCreature(data.guid) or {}
      self:Notify(EmojiEvent.PlayEmoji, {
        roleid = data.guid,
        emoji = dialog.Emoji
      })
    else
      local role = SceneCreatureProxy.FindCreature(data.guid)
      if role then
        TableUtility.ArrayClear(talkInfoParam)
        for i = 1, #data.params do
          local msgParam = data.params[i]
          table.insert(talkInfoParam, msgParam.param)
        end
        local text = ""
        if #talkInfoParam == 0 then
          text = dialog.Text
        else
          text = string.format(dialog.Text, unpack(talkInfoParam))
        end
        local sceneUI = role:GetSceneUI()
        if sceneUI then
          sceneUI.roleTopUI:Speak(text, role, true)
        end
        if role.IsMyPet and role:IsMyPet() then
          notifyPetChatMsg(role, data, text)
        end
        local creatureData = role.data
        if creatureData and creatureData.IsSkada and creatureData:IsSkada() then
          notifyChatMsg(role, data, text)
        end
      end
    end
  end
  self:Notify(ServiceEvent.NUserTalkInfo, data)
end

function ServiceNUserProxy:RecvQueryShopGotItem(data)
  HappyShopProxy.Instance:UpdateQueryShopGotItem(data)
  self:Notify(ServiceEvent.NUserQueryShopGotItem, data)
end

function ServiceNUserProxy:RecvUpdateShopGotItem(data)
  HappyShopProxy.Instance:UpdateShopGotItem(data)
  AfricanPoringProxy.Instance:RecvUpdateShopGotItem(data)
  NewRechargeProxy.Ins:RefreshCombinePackInfo_OnGotItem(data)
  self:Notify(ServiceEvent.NUserUpdateShopGotItem, data)
  EventManager.Me():PassEvent(ServiceEvent.NUserUpdateShopGotItem, data)
  NewRechargeProxy.Ins:Shop_UpdateOneZenyGoodsBuyInfo(data)
end

local setOriginalHair = function(id)
  ShopDressingProxy.Instance.originalHair = id
end
local setOriginalHairColor = function(id)
  ShopDressingProxy.Instance.originalHairColor = id
end
local setOriginalEye = function(id)
  ShopDressingProxy.Instance:SetOriginalEye(id)
end
local setOriginalClothColor = function(id)
  ShopDressingProxy.Instance.originalBodyColor = id
end
local _userDressingConfig = {
  [SceneUser2_pb.EDRESSTYPE_HAIR] = {
    effect = EffectMap.Maps.HairChange_success,
    func = setOriginalHair
  },
  [SceneUser2_pb.EDRESSTYPE_HAIRCOLOR] = {
    effect = EffectMap.Maps.HairColored_success,
    func = setOriginalHairColor
  },
  [SceneUser2_pb.EDRESSTYPE_EYE] = {
    effect = EffectMap.Maps.EyeLenses_success,
    func = setOriginalEye
  },
  [SceneUser2_pb.EDRESSTYPE_CLOTH] = {
    effect = EffectMap.Maps.ClothGraffiti,
    func = setOriginalClothColor
  }
}

function ServiceNUserProxy:RecvUseDressing(data)
  local t, id = data.type, data.id
  local isMe = data.charid == Game.Myself.data.id
  local effect = _userDressingConfig[t].effect
  if isMe then
    _userDressingConfig[t].func(id)
    local fakeRole = ShopDressingProxy.Instance:GetFakeRole()
    if fakeRole then
      fakeRole:PlayEffectOneShotOn(effect, RoleDefines_EP.Top)
    end
    self:Notify(ServiceEvent.NUserUseDressing, data)
    MsgManager.ShowMsgByID(42000)
  else
    local scenePlayer = NSceneUserProxy.Instance:Find(data.charid)
    if scenePlayer and scenePlayer.assetRole then
      scenePlayer.assetRole:PlayEffectOneShotOn(effect, RoleDefines_EP.Top)
    end
  end
end

function ServiceNUserProxy:RecvNewDressing(data)
  ShopDressingProxy.Instance:RecvNewDressing(data)
  self:Notify(ServiceEvent.NUserNewDressing, data)
end

function ServiceNUserProxy:RecvDressingListUserCmd(data)
  ShopDressingProxy.Instance:RecvDressingListUserCmd(data)
  self:Notify(ServiceEvent.NUserDressingListUserCmd, data)
end

function ServiceNUserProxy:RecvOpenUI(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = data.id,
    viewdata = {
      ui = data.ui
    }
  })
end

function ServiceNUserProxy:RecvDbgSysMsg(data)
  MsgManager.FloatMsgTableParam(nil, data.content)
end

function ServiceNUserProxy:RecvCallNpcFuncCmd(data)
  local tmp
  if data.funparam and data.funparam ~= "" then
    tmp = TableUtil.unserialize(data.funparam)
  end
  local func = FunctionNpcFunc.Me():getFunc(data.type)
  if func ~= nil then
    func(nil, tmp)
  end
end

function ServiceNUserProxy:RecvModelShow(data)
  local list = {}
  table.insert(list, data)
  FloatAwardView.gmAddItemDatasToShow(list)
end

function ServiceNUserProxy:RecvSoundEffectCmd(data)
  local pos = data.pos
  local delay = data.delay
  local se = data.se
  local playPos
  if pos ~= nil and pos.x and pos.y and pos.z then
    playPos = PosUtil.DevideVector3(pos.x, pos.y, pos.z)
  end
  if nil ~= delay and 0 < delay then
    self.timeTickId = self.timeTickId == nil and 1 or self.timeTickId + 1
    TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
      if playPos.magnitude ~= 0 then
        AudioUtility.PlayOneShotAt_Path(resPath, playPos.x, playPos.y, playPos.z, AudioSourceType.SCENE)
      else
        AudioUtility.PlayOneShot2D_Path(resPath)
      end
    end, self, self.timeTickId)
  elseif playPos.magnitude ~= 0 then
    AudioUtility.PlayOneShotAt_Path(se, playPos.x, playPos.y, playPos.z, AudioSourceType.SCENE)
  else
    AudioUtility.PlayOneShot2D_Path(se)
  end
end

function ServiceNUserProxy:RecvPresetMsgCmd(data)
  ChatRoomProxy.Instance:RecvPresetMsgCmd(data)
end

function ServiceNUserProxy:RecvQueryFighterInfo(data)
  Game.Myself.data:UpdateJobDatas(data.fighters)
  self:Notify(ServiceEvent.NUserQueryFighterInfo, data)
end

function ServiceNUserProxy:RecvGameTimeCmd(data)
  self:Notify(ServiceEvent.NUserGameTimeCmd, data)
  SceneProxy.Instance:SetGameTime(data)
end

local CDTypeSkill = SceneUser2_pb.CD_TYPE_SKILL
local skillCD_IdMap = {}

function ServiceNUserProxy:RecvCDTimeUserCmd(data)
  local needSendEvent = false
  local needSendEvent2 = false
  local _CDProxy = CDProxy.Instance
  local cdData
  if data.isall then
    local list = data.list
    if #list == 0 then
      _CDProxy:ClearSkillCD()
    else
      local hasSkillCD
      for i = 1, #list do
        cdData = list[i]
        if cdData.id and cdData.type == CDTypeSkill then
          skillCD_IdMap[cdData.id / 1000] = list[i]
          hasSkillCD = true
        end
      end
      if hasSkillCD then
        local map = _CDProxy:GetCDMapByType(CDTypeSkill)
        if map ~= nil then
          for sortid, cddata in pairs(map) do
            if not skillCD_IdMap[sortid] or sortid ~= -1 then
              needSendEvent2 = needSendEvent2 or true
              _CDProxy:RemoveSkillCD(sortid)
            end
          end
        end
      end
      TableUtility.TableClear(skillCD_IdMap)
    end
    _CDProxy:ClearSkillDelayCD()
  end
  for i = 1, #data.list do
    cdData = data.list[i]
    if cdData.type == SceneUser2_pb.CD_TYPE_SKILL then
      needSendEvent = _CDProxy:Server_AddSkillCD(cdData.id, cdData.time, data.isall, cdData.coldtime, cdData.lefttimes, cdData.maxtimes, cdData.is_tobreak_skill)
    elseif cdData.type == SceneUser2_pb.CD_TYPE_SKILLDEALY then
      _CDProxy:Server_AddSkillDelayCD(cdData.id, cdData.time)
    else
      _CDProxy:AddCD(cdData.type, cdData.id, cdData.time)
      FunctionCDCommand.Me():Refresh()
      if cdData.type == SceneUser2_pb.CD_TYPE_ITEMGROUP then
        GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
      elseif cdData.type == SceneUser2_pb.CD_TYPE_TRAINACTION then
        GameFacade.Instance:sendNotification(InteractNpcEvent.FlowerCarPhotographActionCDUpdate)
      end
    end
  end
  if needSendEvent or needSendEvent2 then
    GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
  end
end

function ServiceNUserProxy:RecvChangeBgmCmd(data)
  local type = data.type
  if type == ProtoCommon_pb.EBGM_TYPE_QUEST then
    if data.play then
      if data.bgm and data.bgm ~= "" then
        FunctionBGMCmd.Me():PlayMissionBgm(data.bgm, data.times)
      end
    else
      FunctionBGMCmd.Me():StopMissionBgm()
    end
  elseif type == ProtoCommon_pb.EBGM_TYPE_ACTIVITY then
    if data.play then
      if data.bgm and data.bgm ~= "" then
        FunctionBGMCmd.Me():PlayActivityBgm(data.bgm, data.times)
      end
    else
      FunctionBGMCmd.Me():StopActivityBgm()
    end
  elseif type == ProtoCommon_pb.EBGM_TYPE_REPLACE and data.bgm and data.bgm ~= "" then
    FunctionBGMCmd.Me():ReplaceCurrentBgm(data.bgm)
  end
end

function ServiceNUserProxy:RecvUserBarrageMsgCmd(data)
  self:Notify(ServiceEvent.NUserUserBarrageMsgCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.NUserUserBarrageMsgCmd, data)
end

function ServiceNUserProxy:RecvPhoto(data)
  local player = SceneCreatureProxy.FindCreature(data.guid)
  if player and player:GetCreatureType() ~= Creature_Type.Me then
    player:Server_CameraFlash()
  end
end

function ServiceNUserProxy:RecvShakeScreen(data)
  self:Notify(ServiceEvent.NUserShakeScreen, data)
  local range = data.maxamplitude / 100
  local duration = data.msec / 1000
  local curve = data.shaketype
  CameraAdditiveEffectManager.Me():StartShake(range, duration, curve)
end

function ServiceNUserProxy:RecvQueryShortcut(data)
  ShortCutProxy.Instance:SetShortCuts(data.list)
  self:Notify(ServiceEvent.NUserQueryShortcut, data)
end

function ServiceNUserProxy:CallPutShortcut(item)
  ServiceNUserProxy.super.CallPutShortcut(self, item)
end

function ServiceNUserProxy:RecvPutShortcut(data)
  ShortCutProxy.Instance:SetShortCut(data.item)
  self:Notify(ServiceEvent.NUserPutShortcut, data)
end

function ServiceNUserProxy:RecvNpcChangeAngle(data)
  local target = SceneCreatureProxy.FindCreature(data.guid)
  if target and data.targetid ~= 0 then
    target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, data.targetid)
  elseif target then
    target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, data.angle)
  end
end

function ServiceNUserProxy:RecvGoToListUserCmd(data)
  WorldMapProxy.Instance:RecvGoToListUser(data)
  self:Notify(ServiceEvent.NUserGoToListUserCmd, data)
end

function ServiceNUserProxy:RecvNewTransMapCmd(data)
  local activeMaps = data.mapid
  if activeMaps and not table.IsEmpty(activeMaps) then
    for i = 1, #activeMaps do
      WorldMapProxy.Instance:AddActiveMap(activeMaps[i])
    end
  end
  self:Notify(ServiceEvent.NUserNewTransMapCmd, data)
end

function ServiceNUserProxy:RecvDeathTransferListCmd(data)
  WorldMapProxy.Instance:RecvDeathTransferList(data)
  self:Notify(ServiceEvent.NUserDeathTransferListCmd, data)
end

function ServiceNUserProxy:RecvNewDeathTransferCmd(data)
  if data.transferId then
    WorldMapProxy.Instance:AddDeathTransferPoint(data)
  end
  self:Notify(ServiceEvent.NUserNewDeathTransferCmd, data)
end

function ServiceNUserProxy:CallGoToGearUserCmd(mapid, type, otherids, noBreakFollow)
  if type == SceneUser2_pb.EGoToGearType_Single and not noBreakFollow then
    Game.Myself:Client_SetFollowLeader(0)
  end
  ServiceNUserProxy.super.CallGoToGearUserCmd(self, mapid, type, otherids)
end

function ServiceNUserProxy:RecvLaboratoryUserCmd(data)
  InstituteChallengeProxy.Instance:RecvLaboratory(data)
  self:Notify(ServiceEvent.NUserLaboratoryUserCmd, data)
end

function ServiceNUserProxy:RecvExchangeProfession(data)
  if data.type == SceneUser2_pb.ETypeBranch or data.type == SceneUser2_pb.ETypeRecord then
    UserProxy.Instance:ChangeSave(data)
  else
    local role = SceneCreatureProxy.FindCreature(data.guid)
    if role ~= nil and not data.no_bgm then
      role:PlayChangeJob()
    end
  end
  UserProxy.Instance:RoleChangeObj(data)
  self:Notify(ServiceEvent.NUserExchangeProfession, data)
end

function ServiceNUserProxy:RecvSceneryUserCmd(data)
  self:Notify(ServiceEvent.NUserSceneryUserCmd, data)
  FunctionScenicSpot.Me():ResetValidScenicSpots(data.scenerys)
end

function ServiceNUserProxy:RecvUserAutoHitCmd(data)
  if data.charid then
    local creature = SceneCreatureProxy.FindCreature(data.charid)
    if creature and creature.roleAgent then
      local myself = MyselfProxy.Instance.myself
      if myself.roleAgent.idleOrHited then
        SkillUtils.Attack(myself.roleAgent, creature.roleAgent)
      end
    end
  end
  self:Notify(ServiceEvent.NUserUserAutoHitCmd, data)
end

function ServiceNUserProxy:RecvQueryMapArea(data)
  local areas = data.areas
  for i = 1, #areas do
    local mapid = areas[i]
    WorldMapProxy.Instance:ActiveMapAreaData(mapid)
  end
  self:Notify(ServiceEvent.NUserQueryMapArea, data)
end

function ServiceNUserProxy:RecvNewMapAreaNtf(data)
  if data.area then
    WorldMapProxy.Instance:ActiveMapAreaData(data.area, true, true)
  end
  self:Notify(ServiceEvent.NUserNewMapAreaNtf, data)
end

function ServiceNUserProxy:RecvTowerCurLayerSync(data)
  printGreen("Recv-->TowerCurLayerSync", data)
  self:Notify(ServiceEvent.NUserTowerCurLayerSync, data)
end

function ServiceNUserProxy:RecvBuffForeverCmd(data)
  MyselfProxy.Instance:RecvBufferUpdate(data)
  printGreen("RecvBufferUpdate")
  self:Notify(ServiceEvent.NUserBuffForeverCmd, data)
end

function ServiceNUserProxy:RecvQueryShow(data)
  MyselfProxy.Instance:SetUnlockActionIdMap(data.actionid)
  MyselfProxy.Instance:SetUnlockEmojiMap(data.expression)
  ChatRoomProxy.Instance:SetUnlockActionsDirty()
  ChatRoomProxy.Instance:SetUnlockEmojisDirty()
  self:Notify(ServiceEvent.NUserQueryShow, data)
end

function ServiceNUserProxy:RecvQueryMusicList(data)
  self.musicList = self.musicList or {}
  TableUtility.TableClear(self.musicList)
  local element
  for i = 1, #data.items do
    element = data.items[i]
    table.insert(self.musicList, {
      guid = element.guid,
      musicid = element.musicid,
      playername = element.name,
      staticData = Table_MusicBox[element.musicid],
      starttime = element.starttime,
      index = i
    })
  end
  ServiceNUserProxy.super.RecvQueryMusicList(self, data)
end

function ServiceNUserProxy:RecvQueryTraceList(data)
  MyselfProxy.Instance:SetTraceItem(data.items)
  self:Notify(ServiceEvent.NUserQueryTraceList, data)
end

function ServiceNUserProxy:CallUpdateTraceList(updates, dels)
  MyselfProxy.Instance:SetTraceItem(updates, dels)
  updates = updates or {}
  local traceUpdates = {}
  for i = 1, #updates do
    if updates[i] then
      local pbItem = SceneUser2_pb.TraceItem()
      pbItem.itemid = updates[i].itemid
      pbItem.monsterid = updates[i].monsterid
      table.insert(traceUpdates, pbItem)
    end
  end
  dels = dels or {}
  ServiceNUserProxy.super.CallUpdateTraceList(self, traceUpdates, dels)
end

function ServiceNUserProxy:CallInviteJoinHandsUserCmd(charid, masterid, mastername, sign, time)
  ServiceNUserProxy.super.CallInviteJoinHandsUserCmd(self, charid, masterid, mastername, sign, time)
end

function ServiceNUserProxy:RecvInviteJoinHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteJoinHandsUserCmd, data)
end

function ServiceNUserProxy:CallJoinHandsUserCmd(masterid, sign, time)
  ServiceNUserProxy.super.CallJoinHandsUserCmd(self, masterid, sign, time)
end

function ServiceNUserProxy:CallBreakUpHandsUserCmd()
  ServiceNUserProxy.super.CallBreakUpHandsUserCmd(self)
end

function ServiceNUserProxy:RecvUploadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadSceneryPhotoUserCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.NUserUploadSceneryPhotoUserCmd, data)
end

function ServiceNUserProxy:RecvDownloadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserDownloadSceneryPhotoUserCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.NUserDownloadSceneryPhotoUserCmd, data)
  local urls = data.urls
  for i = 1, #urls do
    local url = urls[i]
    if url.type == SceneUser2_pb.EALBUMTYPE_SCENERY then
      NetIngUnionWallPhoto_ScenicSpot.Ins():SetUserPathOfServer(url.char_url)
      NetIngUnionWallPhoto_ScenicSpot.Ins():SetUserPathOfServer_Account(url.acc_url)
      NetIngScenicSpotPhotoNew.Ins():SetUserPathOfServerNew(url.acc_url)
      NetIngScenicSpotPhotoNew.Ins():SetUserPathOfServer(url.char_url)
    elseif url.type == SceneUser2_pb.EALBUMTYPE_PHOTO then
      NetIngUnionWallPhoto_Personal.Ins():SetUserPathOfServer(url.char_url)
      NetIngPersonalPhoto.Ins():SetUserPathOfServer(url.char_url)
    elseif url.type == SceneUser2_pb.EALBUMTYPE_GUILD_ICON then
      NetIngUnionLogo.Ins():SetUnionPathOfServer(url.char_url)
    elseif url.type == SceneUser2_pb.EALBUMTYPE_WEDDING then
      NetIngMarryPhoto.Ins():SetUserPathOfServer(url.char_url)
    elseif url.type == SceneUser2_pb.EALBUMTYPE_STAGE then
      NetIngStagePhoto.Ins():SetUserPathOfServer(url.acc_url)
    end
  end
end

function ServiceNUserProxy:CallGotoLaboratoryUserCmd(funid)
  printGreen(string.format("Call-->GotoLaboratoryUserCmd(funid:%s)", tostring(funid)))
  ServiceNUserProxy.super.CallGotoLaboratoryUserCmd(self, funid)
end

function ServiceNUserProxy:CallQueryUserInfoUserCmd(charid, teamid, blink)
  printGreen(string.format("Call-->QueryUserInfoUserCmd(charid:%s)", tostring(charid)))
  ServiceNUserProxy.super.CallQueryUserInfoUserCmd(self, charid, teamid, blink)
end

function ServiceNUserProxy:RecvQueryUserInfoUserCmd(data)
  local playerid = data.charid
  local role = NSceneUserProxy.Instance:Find(playerid)
  if role then
    role.data:SetBlink(data.blink == true)
  end
  self:Notify(ServiceEvent.NUserQueryUserInfoUserCmd, data)
end

function ServiceNUserProxy:RecvCountDownTickUserCmd(data)
  helplog("RecvCountDownTickUserCmd~~~~~~~~~", data.tick, data.time, data.sign, data.extparam)
  if data.tick ~= 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DungeonCountDownView,
      viewdata = data
    })
  else
    self:Notify(ServiceEvent.NUserCountDownTickUserCmd, data)
  end
end

function ServiceNUserProxy:CallShakeTreeUserCmd(npcid, result)
  printGreen(string.format("CallShakeTreeUserCmd(npcid:%s)", npcid))
  ServiceNUserProxy.super.CallShakeTreeUserCmd(self, npcid, result)
end

function ServiceNUserProxy:RecvShakeTreeUserCmd(data)
  printOrange(string.format("Recv ShakeTreeUserCmd(result:%s)", tostring(data.result)))
  FunctionShakeTree.Me():AfterShakeTree(data.result)
  self:Notify(ServiceEvent.NUserShakeTreeUserCmd, data)
end

function ServiceNUserProxy:RecvTreeListUserCmd(data)
  self:Notify(ServiceEvent.NUserTreeListUserCmd, data)
end

function ServiceNUserProxy:RecvItemMusicNtfUserCmd(data)
  local isAdd = data.add
  local path = data.uri
  local music_Limit_Time = 20
  if isAdd then
    FunctionBGMCmd.Me():PlayMissionBgm(path, music_Limit_Time)
  else
    FunctionBGMCmd.Me():StopMissionBgm()
  end
  self:Notify(ServiceEvent.NUserItemMusicNtfUserCmd, data)
end

function ServiceNUserProxy:RecvQueryZoneStatusUserCmd(data)
  LogUtility.Info("RecvQueryZoneStatusUserCmd")
  ChangeZoneProxy.Instance:RecvQueryZoneStatus(data)
  self:Notify(ServiceEvent.NUserQueryZoneStatusUserCmd, data)
end

function ServiceNUserProxy:RecvOperateQueryUserCmd(data)
  local npc = NSceneNpcProxy.Instance:Find(data.npcid)
  if npc then
    local ret = data.ret or 1
    local config = GameConfig.Activity.GetIceCreamtable
    local resultStr = config[ret] or config[1]
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {resultStr},
      npcinfo = npc
    }
    self:Notify(UIEvent.ShowUI, viewdata)
  end
end

function ServiceNUserProxy:CallFollowerUser(userid, eType, followRecvCallBack)
  helplog("Call-->FollowerUser", userid, eType)
  ServiceNUserProxy.super.CallFollowerUser(self, userid, eType)
  self.followRecvCallBack = followRecvCallBack
end

function ServiceNUserProxy:RecvFollowerUser(data)
  helplog("Recv-->FollowerUser", data.userid, data.eType)
  if self.followRecvCallBack then
    self.followRecvCallBack(data.userid, data.eType)
    self.followRecvCallBack = nil
  end
  self:Notify(ServiceEvent.NUserFollowerUser, data)
end

function ServiceNUserProxy:CallGoMapFollowUserCmd(mapid, charid)
  helplog("Call-->GoMapFollowUserCmd", mapid, charid)
  ServiceNUserProxy.super.CallGoMapFollowUserCmd(self, mapid, charid)
end

function ServiceNUserProxy.GetTransCatId()
  local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), 1015)
  if npc then
    return npc.data.id
  end
end

function ServiceNUserProxy:RecvHandStatusUserCmd(data)
  helplog("Recv-->HandStatusUserCmd", data.masterid, data.followid, data.build, data.type)
  local role = SceneCreatureProxy.FindCreature(data.followid)
  if role then
    if data.type == 1 then
      role:Server_SetDoubleAction(data.masterid, data.build)
    else
      role:Server_SetHandInHand(data.masterid, data.build)
    end
  else
    redlog(string.format("not find Creature:%s", data and tostring(data.followid) or ""))
  end
  self:Notify(ServiceEvent.NUserHandStatusUserCmd, data)
end

function ServiceNUserProxy:RecvBeFollowUserCmd(data)
  Game.Myself:Client_SetFollower(data.userid, data.eType)
  self:Notify(ServiceEvent.NUserBeFollowUserCmd, data)
end

function ServiceNUserProxy:RecvCheckSeatUserCmd(data)
  if not data.success then
    Game.SceneSeatManager:TryGetOffSeat(Game.Myself, data.seatid)
  end
  self:Notify(ServiceEvent.NUserCheckSeatUserCmd, data)
end

function ServiceNUserProxy:RecvNtfSeatUserCmd(data)
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  if nil ~= creature then
    if data.isseatdown then
      creature:Server_GetOnSeat(data.seatid, nil, data.furn_guid)
    else
      creature:Server_GetOffSeat(data.seatid, nil, data.furn_guid)
    end
  end
  self:Notify(ServiceEvent.NUserNtfSeatUserCmd, data)
end

function ServiceNUserProxy:CallSceneryUserCmd(mapid, scenerys)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.SceneryUserCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if scenerys ~= nil then
      msgParam.scenerys = {}
      for i = 1, #scenerys do
        local scene = SceneUser2_pb.Scenery()
        scene.sceneryid = scenerys[i].sceneryid
        if scenerys[i].charid then
          scene.charid = scenerys[i].charid
        end
        table.insert(msgParam.scenerys, scene)
      end
    end
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser2_pb.SceneryUserCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if scenerys ~= nil then
      for i = 1, #scenerys do
        local scene = SceneUser2_pb.Scenery()
        scene.sceneryid = scenerys[i].sceneryid
        if scenerys[i].charid then
          scene.charid = scenerys[i].charid
        end
        table.insert(msg.scenerys, scene)
      end
    end
    self:SendProto(msg)
  end
end

function ServiceNUserProxy:RecvUnsolvedSceneryNtfUserCmd(data)
  local ids = data.ids
  if ids and 0 < #ids then
    helplog("RecvUnsolvedSceneryNtfUserCmd:", #ids)
    SSPUploadStatusManager.Ins():SyncUploadStatusToGameServer(ids)
  end
  self:Notify(ServiceEvent.NUserUnsolvedSceneryNtfUserCmd, data)
end

function ServiceNUserProxy:RecvNtfVisibleNpcUserCmd(data)
  NSceneNpcProxy.Instance:NtfVisibleNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfVisibleNpcUserCmd, data)
end

function ServiceNUserProxy:RecvUpyunAuthorizationCmd(data)
  self:Notify(ServiceEvent.NUserUpyunAuthorizationCmd, data)
  local partAuthValue = data.authvalue
  local authValue = "Basic " .. partAuthValue
  CloudServer.AUTH_VALUE = authValue
  CloudFile.UpYunServer.AUTH_VALUE = authvalue
end

function ServiceNUserProxy:CallTransformPreDataCmd()
  ServiceNUserProxy.super.CallTransformPreDataCmd(self)
end

function ServiceNUserProxy:RecvTransformPreDataCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.NUserTransformPreDataCmd, data)
end

function ServiceNUserProxy:RecvInviteFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteFollowUserCmd, data)
end

function ServiceNUserProxy:CallEnterCapraActivityCmd()
  ServiceNUserProxy.super.CallEnterCapraActivityCmd(self)
end

function ServiceNUserProxy:RecvShowSeatUserCmd(data)
  Game.SceneSeatManager:SetSeatsDisplay(data.seatid, data.show == SceneUser2_pb.SEAT_SHOW_VISIBLE)
end

function ServiceNUserProxy:RecvSpecialEffectCmd(data)
  helplog("开始场景剧情:", data.dramaid, os.date("%Y-%m-%d-%H-%M-%S", data.starttime), os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime() / 1000))
  Game.PlotStoryManager:StartScenePlot(data.dramaid, data.starttime)
end

function ServiceNUserProxy:RecvMarriageProposalCmd(data)
  helplog("Recv-->MarriageProposalCmd", data.charid, data.itemid)
  FunctionWedding.Me():AddCourtshipDistanceCheck(data.masterid, data.itemid)
  self:Notify(ServiceEvent.NUserMarriageProposalCmd, data)
end

function ServiceNUserProxy:CallMarriageProposalReplyCmd(masterid, reply, time, sign)
  helplog("Call-->MarriageProposalReplyCmd", masterid, reply, time, sign)
  ServiceNUserProxy.super.CallMarriageProposalReplyCmd(self, masterid, reply, time, sign)
end

function ServiceNUserProxy:RecvMarriageProposalSuccessCmd(data)
  WeddingProxy.Instance:Set_Courtship_PlayerId(data.charid, data.ismaster)
  local cameraId = GameConfig.Wedding.Courtship_CameraId or 1
  local panelData = {
    view = PanelConfig.PhotographPanel,
    viewdata = {cameraId = cameraId}
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, panelData)
  self:Notify(ServiceEvent.NUserMarriageProposalSuccessCmd, data)
end

function ServiceNUserProxy:CallTwinsActionUserCmd(userid, actionid, etype, sponsor)
  helplog("Call-->TwinsActionUserCmd", userid, actionid, etype, sponsor)
  ServiceNUserProxy.super.CallTwinsActionUserCmd(self, userid, actionid, etype, sponsor)
end

function ServiceNUserProxy:RecvTwinsActionUserCmd(data)
  helplog("Recv-->TwinsActionUserCmd", data.userid, data.actionid, data.etype, data.sponsor)
  self:Notify(ServiceEvent.NUserTwinsActionUserCmd, data)
end

function ServiceNUserProxy:RecvRecommendServantUserCmd(data)
  ServantRecommendProxy.Instance:HandleRecommendData(data)
  ActivityIntegrationProxy.Instance:UpdateSignInRedtip()
  self:Notify(ServiceEvent.NUserRecommendServantUserCmd, data)
end

function ServiceNUserProxy:RecvServantReservationUserCmd(data)
  helplog("女仆预约数据。Recv-->ServantReservationUserCmd", data.opt, #data.datas)
  ServantCalendarProxy.Instance:UpdateReservation(data.opt, data.datas)
  self:Notify(ServiceEvent.NUserServantReservationUserCmd, data)
end

function ServiceNUserProxy:RecvServantRewardStatusUserCmd(data)
  ServantRecommendProxy.Instance:HandleRewardStatus(data.items)
  self:Notify(ServiceEvent.NUserServantRewardStatusUserCmd, data)
end

function ServiceNUserProxy:CallCheckRelationUserCmd(charid, etype)
  self.super:CallCheckRelationUserCmd(charid, etype)
end

function ServiceNUserProxy:RecvCheckRelationUserCmd(data)
  StarProxy.Instance:RecvCheckRelationUserCmd(data)
  self:Notify(ServiceEvent.NUserCheckRelationUserCmd, data)
end

function ServiceNUserProxy:CallProfessionQueryUserCmd(items)
  self.manualCall = true
  ServiceNUserProxy.super.CallProfessionQueryUserCmd(self, items)
end

function ServiceNUserProxy:RecvProfessionQueryUserCmd(data)
  ProfessionProxy.Instance:RecvProfessionQueryUserCmd({body = data})
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_ProfessionDatas) do
    if v.iscurrent then
      ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
    end
  end
  self:Notify(ServiceEvent.NUserProfessionQueryUserCmd, data)
  EventManager.Me():PassEvent(EquipRecommendMainNewEvent.RecvProfessionQueryUserCmd, data)
  if not self.manualCall then
    GameFacade.Instance:sendNotification(MultiProfessionEvent.OpenPanel)
  else
    self.manualCall = false
  end
end

function ServiceNUserProxy:CallProfessionBuyUserCmd(branch, success)
  ServiceNUserProxy.super.CallProfessionBuyUserCmd(self, branch, success)
end

function ServiceNUserProxy:RecvProfessionBuyUserCmd(data)
  ProfessionProxy.Instance:RecvProfessionBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionBuyUserCmd, data)
end

function ServiceNUserProxy:CallProfessionChangeUserCmd(branch, success, changeCard, changeCardMoney)
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    return
  end
  if ProfessionProxy.Instance.server_novice_branch_convert_patch then
    local server_novice_branch = ProfessionProxy.Instance.server_novice_branch_convert_patch[branch]
    if server_novice_branch then
      branch = server_novice_branch
    end
  end
  local curBranch = ProfessionProxy.Instance:GetCurTypeBranch()
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if curBranch ~= branch then
    if etype == PvpProxy.Type.TeamPwsChampion and matchStatus and matchStatus.ismatch then
      MsgManager.ShowMsgByID(26293)
      return
    elseif etype == PvpProxy.Type.TeamPws and matchStatus and matchStatus.ismatch then
      MsgManager.ShowMsgByID(26293)
      return
    end
  end
  ServiceNUserProxy.super.CallProfessionChangeUserCmd(self, branch, success, changeCard)
end

function ServiceNUserProxy:RecvClearProfessionDataDetailUserCmd(data)
  BranchInfoSaveProxy.Instance:ClearDetailInfo(data)
  MultiProfessionSaveProxy.Instance:ClearDetailInfo()
  self:Notify(ServiceEvent.NUserClearProfessionDataDetailUserCmd, data)
end

function ServiceNUserProxy:RecvProfessionChangeUserCmd(data)
  self:TempFix_FashionEquipBug()
  MsgManager.ShowMsgByIDTable(25394, {
    MyselfProxy.Instance:GetMyProfessionName(),
    data.zenycost
  })
  self:Notify(ServiceEvent.NUserProfessionChangeUserCmd, data)
end

function ServiceNUserProxy:TempFix_FashionEquipBug()
  local fashionBag = BagProxy.Instance.fashionBag
  local items = fashionBag:GetItems()
  local serviceItemProxy = ServiceItemProxy.Instance
  for i = 1, #items do
    if not items[i]:CanEquip() then
      serviceItemProxy:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, nil, items[i].staticData.id)
    end
  end
end

function ServiceNUserProxy:RecvUpdateBranchInfoUserCmd(data)
  ProfessionProxy.Instance:RecvUpdateBranchInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateBranchInfoUserCmd, data)
end

function ServiceNUserProxy:CallInviteWithMeUserCmd(sendid, time, reply, sign)
  self.super:CallInviteWithMeUserCmd(sendid, time, reply, sign)
end

function ServiceNUserProxy:RecvUpdateRecordInfoUserCmd(data)
  MultiProfessionSaveProxy.Instance:RecvUpdateRecordInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateRecordInfoUserCmd, data)
end

function ServiceNUserProxy:CallSaveRecordUserCmd(slotid, recordName)
  self.super:CallSaveRecordUserCmd(slotid, recordName)
end

function ServiceNUserProxy:RecvSaveRecordUserCmd(slotid, recordName)
  self.super:RecvSaveRecordUserCmd(slotid, recordName)
end

function ServiceNUserProxy:CallBuyRecordSlotUserCmd(slotid)
  self.super:CallBuyRecordSlotUserCmd(slotid)
end

function ServiceNUserProxy:CallChangeRecordNameUserCmd(slotid, recordName)
  self.super:CallChangeRecordNameUserCmd(slotid, recordName)
end

function ServiceNUserProxy:CallLoadRecordUserCmd(slotid, only_equip, changeCard, changeCardMoney)
  local curBranch = MyselfProxy.Instance:GetMyProfessionTypeBranch()
  local targetProf = MultiProfessionSaveProxy.Instance:GetProfession(slotid)
  local targetTypeBranch = targetProf and ProfessionProxy.GetTypeBranchFromProf(targetProf)
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if curBranch ~= targetTypeBranch then
    if etype == PvpProxy.Type.TeamPwsChampion and matchStatus and matchStatus.ismatch then
      MsgManager.ShowMsgByID(26293)
      return
    elseif etype == PvpProxy.Type.TeamPws and matchStatus and matchStatus.ismatch then
      MsgManager.ShowMsgByID(26293)
      return
    end
  end
  self.super:CallLoadRecordUserCmd(slotid, only_equip, changeCard)
end

function ServiceNUserProxy:RecvLoadRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserLoadRecordUserCmd, data)
  local rid = MultiProfessionSaveProxy.Instance:GetRoleID(data.slotid)
  local record = MultiProfessionSaveProxy.Instance:GetUsersaveData(data.slotid)
  local simpleRecord = MultiProfessionSaveProxy.Instance:GetProfessionRecordSimpleDataById(data.slotid)
  rid = rid or simpleRecord and simpleRecord.charid
  if Game.Myself.data.id ~= rid then
    PlayerPrefs.SetString(ServiceLoginUserCmdProxy.toswitchroleid, tostring(rid))
    PlayerPrefs.SetString(ServiceLoginUserCmdProxy.saveID, tostring(data))
    PlayerPrefs.Save()
    Game.Me():BackToSwitchRole()
    return
  end
  MultiProfessionSaveProxy.Instance:LoadRecordByMapRule_OnRecv(record.recordname, data.zenycost)
end

function ServiceNUserProxy:CallDeleteRecordUserCmd(slotid)
  self.super:CallDeleteRecordUserCmd(slotid)
end

function ServiceNUserProxy:RecvDressUpLineUpUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpLineUpUserCmd, data)
  redlog("RecvDressUpLineUpUserCmd")
end

function ServiceNUserProxy:CallDressUpLineUpUserCmd(stageid, mode, enter)
  self.super:CallDressUpLineUpUserCmd(stageid, mode, enter)
  redlog("CallDressUpLineUpUserCmd", stageid, mode, enter)
end

function ServiceNUserProxy:CallQueryStageUserCmd(stageid, info)
  self.super:CallQueryStageUserCmd(stageid, info)
  redlog("CallQueryStageUserCmd", stageid)
end

function ServiceNUserProxy:RecvQueryStageUserCmd(data)
  self.super:RecvQueryStageUserCmd(data)
  StageProxy.Instance:RecvStageInfo(data)
  local len = 0
  if data.info then
    len = #data.info
    if len == 3 then
      StageProxy.Instance:ShowDialog()
    end
  end
  self:Notify(ServiceEvent.NUserQueryStageUserCmd, data)
  redlog("RecvQueryStageUserCmd")
end

function ServiceNUserProxy:CallDressUpModelUserCmd(stageid, type, value)
  self.super:CallDressUpModelUserCmd(stageid, type, value)
  redlog("CallDressUpModelUserCmd", stageid, type, value)
end

function ServiceNUserProxy:RecvDressUpModelUserCmd(data)
  redlog("RecvDressUpModelUserCmd")
  self:Notify(ServiceEvent.NUserDressUpModelUserCmd, data)
end

function ServiceNUserProxy:CallDressUpHeadUserCmd(type, value, puton)
  self.super:CallDressUpHeadUserCmd(type, value, puton)
  redlog("CallDressUpHeadUserCmd", type, value, puton)
end

function ServiceNUserProxy:RecvDressUpHeadUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpHeadUserCmd, data)
end

function ServiceNUserProxy:RecvDressUpStageUserCmd(data)
  StageProxy.Instance:RecvStageReplce(data)
  self:Notify(ServiceEvent.NUserDressUpStageUserCmd, data)
end

function ServiceNUserProxy:CallBoothReqUserCmd(name, oper, success)
  if oper == BoothProxy.OperEnum.Open then
    local pos = Game.Myself:GetPosition()
    local range = GameConfig.Booth.booth_range
    local squareRange = range * range
    local player = NSceneUserProxy.Instance:FindUserInRange(pos, range, function(v)
      return v:IsInBooth()
    end)
    if player ~= nil then
      MsgManager.ShowMsgByID(25707)
    end
  end
  ServiceNUserProxy.super:CallBoothReqUserCmd(name, oper, success)
end

function ServiceNUserProxy:RecvBoothReqUserCmd(data)
  BoothProxy.Instance:RecvBoothReqUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothReqUserCmd, data)
end

function ServiceNUserProxy:RecvBoothInfoSyncUserCmd(data)
  BoothProxy.Instance:RecvBoothInfoSyncUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothInfoSyncUserCmd, data)
end

function ServiceNUserProxy:RecvGrowthServantUserCmd(data)
  ServantRecommendProxy.Instance:HandleServantImproveData(data)
  self:Notify(ServiceEvent.NUserGrowthServantUserCmd, data)
end

function ServiceNUserProxy:RecvCheatTagStatUserCmd(data)
  AAAManager.Me():RecvCheatTagStat(data)
  self.super:RecvCheatTagStatUserCmd(data)
end

function ServiceNUserProxy:CallClickPosList(clickPosList)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ClickPosList.id
    local msgParam = {}
    if clickPosList then
      msgParam.clickbuttonpos = {}
      for i = 1, #clickPosList do
        local clickPosMsg = {}
        clickPosMsg.button = clickPosList[i].button
        clickPosMsg.pos = clickPosList[i].pos
        clickPosMsg.count = clickPosList[i].count
        table.insert(msgParam.clickbuttonpos, clickPosMsg)
      end
    end
    self:SendProto2(msgId, msgParam)
  else
    local listMsg = SceneUser2_pb.ClickPosList()
    if clickPosList then
      for i = 1, #clickPosList do
        local clickPosMsg = SceneUser2_pb.ClickButtonPos()
        clickPosMsg.button = clickPosList[i].button
        clickPosMsg.pos = clickPosList[i].pos
        clickPosMsg.count = clickPosList[i].count
        table.insert(listMsg.clickbuttonpos, clickPosMsg)
      end
    end
    self:SendProto(listMsg)
  end
end

function ServiceNUserProxy:RecvUnlockFrameUserCmd(data)
  BarrageProxy.Instance:RecvUnlockFrameUserCmd(data)
  self:Notify(ServiceEvent.NUserUnlockFrameUserCmd, data)
end

function ServiceNUserProxy:CallBeatPoriUserCmd(start, success)
  self.super:CallBeatPoriUserCmd(start, success)
end

function ServiceNUserProxy:RecvBeatPoriUserCmd(data)
  self:Notify(ServiceEvent.NUserBeatPoriUserCmd, data)
end

function ServiceNUserProxy:CallClickPosList(clickPosList)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ClickPosList.id
    local msgParam = {}
    if clickPosList then
      msgParam.clickbuttonpos = {}
      for i = 1, #clickPosList do
        local clickPosMsg = {}
        clickPosMsg.button = clickPosList[i].button
        clickPosMsg.pos = clickPosList[i].pos
        clickPosMsg.count = clickPosList[i].count
        table.insert(msgParam.clickbuttonpos, clickPosMsg)
      end
    end
    self:SendProto2(msgId, msgParam)
  else
    local listMsg = SceneUser2_pb.ClickPosList()
    if clickPosList then
      for i = 1, #clickPosList do
        local clickPosMsg = SceneUser2_pb.ClickButtonPos()
        clickPosMsg.button = clickPosList[i].button
        clickPosMsg.pos = clickPosList[i].pos
        clickPosMsg.count = clickPosList[i].count
        table.insert(listMsg.clickbuttonpos, clickPosMsg)
      end
    end
    self:SendProto(listMsg)
  end
end

function ServiceNUserProxy:RecvSignInUserCmd(data)
  if data.type == SceneUser2_pb.ESIGNINTYPE_DAILY then
    NewServerSignInProxy.Instance:RecvSignInResult(data.success)
  elseif data.type == SceneUser2_pb.ESIGNINTYPE_ACTIVITY then
    ActivitySignInProxy.Instance:RecvSignInResult(data.success)
  end
  self:Notify(ServiceEvent.NUserSignInUserCmd, data)
end

function ServiceNUserProxy:RecvSignInNtfUserCmd(data)
  if data.type == SceneUser2_pb.ESIGNINTYPE_DAILY then
    NewServerSignInProxy.Instance:RecvSignInNotify(data.count, data.issign, data.isshowed)
  elseif data.type == SceneUser2_pb.ESIGNINTYPE_ACTIVITY then
    ActivitySignInProxy.Instance:RecvSignInNotify(data.count, data.issign, data.isshowed)
  end
  self:Notify(ServiceEvent.NUserSignInNtfUserCmd, data)
end

function ServiceNUserProxy:RecvKFCHasEnrolledUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCHasEnrolledUserCmd, data)
end

function ServiceNUserProxy:RecvKFCEnrollReplyUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollReplyUserCmd, data)
end

function ServiceNUserProxy:RecvKFCEnrollUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollUserCmd, data)
end

function ServiceNUserProxy:RecvKFCEnrollCodeUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollCodeUserCmd, data)
end

function ServiceNUserProxy:RecvKFCShareUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCShareUserCmd, data)
end

function ServiceNUserProxy:RecvReadyToMapUserCmd(data)
  FunctionChangeScene.Me():ClientLoadInAdvence(data)
end

function ServiceNUserProxy:RecvServerInfoNtf(data)
  ChangeZoneProxy.Instance:RecvServerInfoNtf(data)
end

function ServiceNUserProxy:CallAltmanRewardUserCmd(passtime, items, getrewardid)
  self.super:CallAltmanRewardUserCmd(passtime, items, getrewardid)
end

function ServiceNUserProxy:RecvAltmanRewardUserCmd(data)
  DungeonProxy.Instance:RecvAltmanRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserAltmanRewardUserCmd, data)
end

function ServiceNUserProxy:RecvReadyToMapUserCmd(data)
  FunctionChangeScene.Me():ClientLoadInAdvence(data)
end

function ServiceNUserProxy:RecvUnlockFrameUserCmd(data)
  BarrageProxy.Instance:RecvUnlockFrameUserCmd(data)
  self:Notify(ServiceEvent.NUserUnlockFrameUserCmd, data)
end

function ServiceNUserProxy:RecvServantRecEquipUserCmd(data)
  self:Notify(ServiceEvent.NUserServantRecEquipUserCmd, data)
end

function ServiceNUserProxy:RecvPrestigeNtfUserCmd(data)
  PrestigeProxy.Instance:RecvPrestigeNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserPrestigeNtfUserCmd, data)
end

function ServiceNUserProxy:RecvPrestigeGiveUserCmd(data)
  self:Notify(ServiceEvent.NUserPrestigeGiveUserCmd, data)
end

function ServiceNUserProxy:RecvUpdateGameHealthLevelUserCmd(data)
  if Game.GameHealthProtector then
    Game.GameHealthProtector:UpdateStatus(data)
  end
  self:Notify(ServiceEvent.NUserUpdateGameHealthLevelUserCmd, data)
end

function ServiceNUserProxy:RecvFishway2KillBossInformUserCmd(data)
  if Game.GameHealthProtector then
    Game.GameHealthProtector:RecvFishway2KillBossInformUserCmd(data)
  end
  self:Notify(ServiceEvent.NUserFishway2KillBossInformUserCmd, data)
end

function ServiceNUserProxy:RecvShowViechleUserCmd(data)
  local manager = Game.GameObjectManagers[Game.GameObjectType.InteractNpc]
  if data.isall then
    manager:ShowAll(data.show)
  else
    manager:ShowInteractObject(data.npcid, data.show)
  end
end

function ServiceNUserProxy:CallHighRefineAttrUserCmd(posType, levelType, value)
  ServiceNUserProxy.super.CallHighRefineAttrUserCmd(self, posType, levelType - 1, value)
end

function ServiceNUserProxy:RecvHighRefineAttrUserCmd(data)
  BlackSmithProxy.Instance:RecvHighRefineAttr(data)
  self:Notify(ServiceEvent.NUserHighRefineAttrUserCmd, data)
end

function ServiceNUserProxy:RecvHeadwearNpcUserCmd(data)
  HeadwearRaidProxy.Instance:RecvHeadwearNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearNpcUserCmd, data)
end

function ServiceNUserProxy:RecvHeadwearRoundUserCmd(data)
  HeadwearRaidProxy.Instance:RecvHeadwearRoundUserCmd(data)
  self:Notify(ServiceEvent.NUserHeadwearRoundUserCmd, data)
end

function ServiceNUserProxy:RecvHeadwearEndUserCmd(data)
  HeadwearRaidProxy.Instance:DoEnd()
  self:Notify(ServiceEvent.NUserHeadwearEndUserCmd, data)
end

function ServiceNUserProxy:RecvServantStatisticsUserCmd(data)
  ServantRaidStatProxy.Instance:RecvServantStatisticsUserCmd(data)
  self:Notify(ServiceEvent.NUserServantStatisticsUserCmd, data)
end

function ServiceNUserProxy:RecvServantStatisticsMailUserCmd(data)
  ServantRaidStatProxy.Instance:RecvServantStatisticsMailUserCmd(data)
  self:Notify(ServiceEvent.NUserServantStatisticsMailUserCmd, data)
end

function ServiceNUserProxy:RecvFastTransGemQueryUserCmd(data)
  ProfessionProxy.Instance:RecvFastTransGemQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserFastTransGemQueryUserCmd, data)
end

function ServiceNUserProxy:RecvBuildDataQueryUserCmd(data)
  BFBuildingProxy.Instance:RecvBuildDataQueryUserCmd(data)
  ServiceNUserProxy.super.RecvBuildDataQueryUserCmd(self, data)
end

function ServiceNUserProxy:RecvBuildContributeUserCmd(data)
  BFBuildingProxy.Instance:RecvBuildContributeUserCmd(data)
  ServiceNUserProxy.super.RecvBuildContributeUserCmd(self, data)
end

function ServiceNUserProxy:RecvBuildOperateUserCmd(data)
  BFBuildingProxy.Instance:RecvBuildOperateUserCmd(data)
  ServiceNUserProxy.super.RecvBuildOperateUserCmd(self, data)
end

function ServiceNUserProxy:RecvNightmareAttrQueryUserCmd(data)
  BFBuildingProxy.Instance:RecvNightmareAttrQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserNightmareAttrQueryUserCmd, data)
end

function ServiceNUserProxy:RecvNightmareAttrGetUserCmd(data)
  BFBuildingProxy.Instance:RecvNightmareAttrGetUserCmd(data)
  self:Notify(ServiceEvent.NUserNightmareAttrGetUserCmd, data)
end

function ServiceNUserProxy:RecvPaySignNtfUserCmd(data)
  PaySignProxy.Instance:RecvPaySignNtfUser(data.infos)
  self:Notify(ServiceEvent.NUserPaySignNtfUserCmd, data)
end

function ServiceNUserProxy:RecvPaySignBuyUserCmd(data)
  PaySignProxy.Instance:UpdatePayInfo(data.activityid, data.info)
  self:Notify(ServiceEvent.NUserPaySignBuyUserCmd, data)
end

function ServiceNUserProxy:RecvPaySignRewardUserCmd(data)
  PaySignProxy.Instance:UpdatePayInfo(data.activityid, data.info)
  self:Notify(ServiceEvent.NUserPaySignRewardUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionQueryUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionQueryUserCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.NUserExtractionQueryUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionOperateUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionOperateUserCmd(data)
  redlog("RecvExtractionOperateUserCmd")
  self:Notify(ServiceEvent.NUserExtractionOperateUserCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.NUserExtractionOperateUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionActiveUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionActiveUserCmd(data)
  redlog("RecvExtractionActiveUserCmd")
  self:Notify(ServiceEvent.NUserExtractionActiveUserCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.NUserExtractionActiveUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionRemoveUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionRemoveUserCmd(data)
  self:Notify(ServiceEvent.NUserExtractionRemoveUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionGridBuyUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionGridBuyUserCmd(data)
  redlog("RecvExtractionGridBuyUserCmd")
  self:Notify(ServiceEvent.NUserExtractionGridBuyUserCmd, data)
end

function ServiceNUserProxy:RecvExtractionRefreshUserCmd(data)
  AttrExtractionProxy.Instance:RecvExtractionRefreshUserCmd(data)
  ServiceNUserProxy.super.RecvExtractionRefreshUserCmd(self, data)
end

function ServiceNUserProxy:RecvGrouponQueryUserCmd(data)
  redlog("Recv------> GrouponQueryUserCmd")
  GrouponProxy.Instance:RecvGrouponInfo(data)
  self:Notify(ServiceEvent.NUserGrouponQueryUserCmd, data)
end

function ServiceNUserProxy:RecvGrouponBuyUserCmd(data)
  redlog("Recv---------->GrouponBuyUserCmd ")
  GrouponProxy.Instance:RecvGrouponInfo(data)
  self:Notify(ServiceEvent.NUserGrouponBuyUserCmd, data)
end

function ServiceNUserProxy:RecvGrouponRewardUserCmd(data)
  GrouponProxy.Instance:RecvGrouponInfo(data)
  self:Notify(ServiceEvent.NUserGrouponRewardUserCmd, data)
end

function ServiceNUserProxy:RecvNtfPlayActUserCmd(data)
  redlog("RecvNtfPlayActUserCmd", TableUtil:TableToStr(data))
  NewContentPushProxy.Instance:InitPushContentData(data)
end

function ServiceNUserProxy:RecvNoviceTargetUpdateUserCmd(data)
  SignIn21Proxy.Instance:RecvNoviceTargetUpdate(data.datas, data.dels, data.day)
  NoviceTarget2023Proxy.Instance:RecvNoviceTargetUpdate(data.datas, data.dels, data.day)
  ServiceNUserProxy.super.RecvNoviceTargetUpdateUserCmd(self, data)
end

function ServiceNUserProxy:RecvNoviceTargetRewardUserCmd(data)
  NoviceTarget2023Proxy.Instance:RecvNoviceTargetProgressReward(data.datas)
  ServiceNUserProxy.super.RecvNoviceTargetRewardUserCmd(self, data)
end

function ServiceNUserProxy:RecvSetBoKiStateUserCmd(data)
  BokiProxy.Instance:HandleSetBoKiStateUserCmd(data.state)
  self:Notify(ServiceEvent.NUserSetBoKiStateUserCmd, data)
end

function ServiceNUserProxy:RecvCloseDialogMaskUserCmd(data)
  redlog("RecvCloseDialogMaskUserCmd")
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogMaskLayer)
  self:Notify(ServiceEvent.NUserCloseDialogMaskUserCmd, data)
end

function ServiceNUserProxy:RecvCloseDialogCameraUserCmd(data)
  redlog("RecvCloseDialogCameraUserCmd")
  FunctionCameraEffect.Me():EndDialogViewEffect()
  self:Notify(ServiceEvent.NUserCloseDialogCameraUserCmd, data)
end

function ServiceNUserProxy:RecvQueryMapMonsterRefreshInfo(data)
  redlog("RecvQueryMapMonsterRefreshInfo")
  MonsterInfoProxy.Instance:RecvMonsterBatchInfo(data)
  self:Notify(ServiceEvent.NUserQueryMapMonsterRefreshInfo, data)
end

function ServiceNUserProxy:RecvHideUIUserCmd(data)
  redlog("隐藏UI")
  GameFacade.Instance:sendNotification(MainViewEvent.NewPlayerHide, data)
  self:Notify(ServiceEvent.NUserHideUIUserCmd, data)
end

function ServiceNUserProxy:RecvSetCameraUserCmd(data)
  FunctionCameraEffect.Me():HandleManualCameraSetting(data)
  self:Notify(ServiceEvent.NUserSetCameraUserCmd, data)
end

function ServiceNUserProxy:RecvActivityDonateQueryUserCmd(data)
  DonateProxy.Instance:HandleRecvDonateTime(data)
  self:Notify(ServiceEvent.NUserActivityDonateQueryUserCmd, data)
end

function ServiceNUserProxy:RecvActivityDonateRewardUserCmd(data)
  DonateProxy.Instance:HandleRecvDonate(data)
  self:Notify(ServiceEvent.NUserActivityDonateRewardUserCmd, data)
end

function ServiceNUserProxy:RecvHappyValueUserCmd(data)
  xdlog("RecvHappyValueUserCmd -- 迪士尼全服欢乐值信息")
  DisneyProxy.Instance:RecvHappyValueUserCmd(data)
  self:Notify(ServiceEvent.NUserHappyValueUserCmd, data)
end

function ServiceNUserProxy:RecvSendTargetPosUserCmd(data)
  MyselfProxy.Instance:SetTargetAndPos(data)
  self:Notify(ServiceEvent.NUserSendTargetPosUserCmd, data)
end

function ServiceNUserProxy:RecvBattleTimelenUserCmd(data)
  BattleTimeDataProxy.Instance:HandleRecvBattleTimelenUserCmd(data)
  ServiceNUserProxy.super.RecvBattleTimelenUserCmd(self, data)
end

function ServiceNUserProxy:RecvNewSetOptionUserCmd(data)
  if data.type == SceneUser2_pb.EOPTIONTYPE_STORMBOSS_LUCKY then
    WildMvpProxy.Instance:HandleLuckySettingResult(data)
  end
  self:Notify(ServiceEvent.NUserNewSetOptionUserCmd, data)
end

function ServiceNUserProxy:RecvSendMarksInfoUserCmd(data)
  MyselfProxy.Instance:SetSendMarksInfo(data)
  self:Notify(ServiceEvent.NUserSendMarksInfoUserCmd, data)
end

function ServiceNUserProxy:RecvUserSyncBuffFromUserCmd(data)
  MyselfProxy.Instance:SyncBuffSource(data)
  self:Notify(ServiceEvent.NUserUserSyncBuffFromUserCmd, data)
end
