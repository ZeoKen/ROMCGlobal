using("RO.RoleAvatar")
autoImport("Appellation")
autoImport("Occupation")
local MyselfProxy = class("MyselfProxy", pm.Proxy)
MyselfProxy.Instance = nil
MyselfProxy.NAME = "MyselfProxy"
local FakeNormalAtk = GameConfig.FakeNormalAtk

function MyselfProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MyselfProxy.NAME
  if MyselfProxy.Instance == nil then
    MyselfProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.selectAutoNormalAtk = true
  self.failPassPersonalEndlessTower = false
end

function MyselfProxy:onRegister()
  self.myself = nil
  self.vars = nil
  self.buffers = nil
  self.buffAttr = nil
  self.buffersProps = RolePropsContainer.CreateAsTable()
  self.extraProps = RolePropsContainer.CreateAsTable()
  self:ClearProps()
  self.buffAttr = {}
  self.traceItems = {}
  self.equipPosStateTimeMap, self.equipPosOnCdEndTimeMap, self.equipPosEffectTimeMap = {}, {}, {}
  self.unlockActionIds = {}
  self.unlockEmojiIds = {}
  self:InitPropsTab()
  self.debtDatas = {}
  self.accvars = nil
end

function MyselfProxy:_GetEquipPosKey(pos, is_shadow)
  if is_shadow then
    return "shadow_" .. pos
  else
    return "normal_" .. pos
  end
end

function MyselfProxy:_ParseEquipPosKey(key)
  if string.find(key, "shadow_") == 1 then
    local pos = tonumber(string.sub(key, 8))
    return pos, true
  else
    local pos = tonumber(string.sub(key, 8))
    return pos, false
  end
end

function MyselfProxy:ClearProps()
  if self.buffersProps then
    for _, o in pairs(self.buffersProps.configs) do
      self.buffersProps:SetValueById(o.id, 0)
    end
  end
  if self.extraProps then
    for _, o in pairs(self.extraProps.configs) do
      self.extraProps:SetValueById(o.id, 0)
    end
  end
end

function MyselfProxy:CurMaxJobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CUR_MAXJOB) or 0
end

function MyselfProxy:AllProfessionMaxJobLv()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION_MAXJOB) or 0
end

function MyselfProxy:onRemove()
  self.buffersProps:Destroy()
  self.buffersProps = nil
  self.extraProps:Destroy()
  self.extraProps = nil
end

function MyselfProxy:SetUserRolesInfo(snapShotUserInfo)
  if self.snapShotUserInfo == nil then
    self.snapShotUserInfo = {}
  else
    TableUtility.TableClear(self.snapShotUserInfo)
  end
  local client_datas = {}
  local server_datas = snapShotUserInfo.data
  self.roleNameValid = {}
  for i = 1, #server_datas do
    local server_data = server_datas[i]
    local snapShotDataPB = {}
    snapShotDataPB.id = server_data.id
    snapShotDataPB.baselv = server_data.baselv
    snapShotDataPB.hair = server_data.hair
    snapShotDataPB.haircolor = server_data.haircolor
    snapShotDataPB.lefthand = server_data.lefthand
    snapShotDataPB.righthand = server_data.righthand
    snapShotDataPB.body = server_data.body
    snapShotDataPB.head = server_data.head
    snapShotDataPB.back = server_data.back
    snapShotDataPB.face = server_data.face
    snapShotDataPB.tail = server_data.tail
    snapShotDataPB.mount = server_data.mount
    snapShotDataPB.eye = server_data.eye
    snapShotDataPB.partnerid = server_data.partnerid
    snapShotDataPB.portrait = server_data.portrait
    snapShotDataPB.mouth = server_data.mouth
    snapShotDataPB.clothcolor = server_data.clothcolor
    snapShotDataPB.name = server_data.name
    snapShotDataPB.sequence = server_data.sequence
    snapShotDataPB.isopen = server_data.isopen
    snapShotDataPB.deletetime = server_data.deletetime
    snapShotDataPB.gender = server_data.gender
    snapShotDataPB.profession = server_data.profession
    snapShotDataPB.name_invalid = server_data.name_invalid
    self.roleNameValid[snapShotDataPB.id] = snapShotDataPB.name_invalid
    snapShotDataPB.delete_marks = server_data.delete_marks
    table.insert(client_datas, snapShotDataPB)
  end
  self.snapShotUserInfo.data = client_datas
  self.snapShotUserInfo.lastselect = snapShotUserInfo.lastselect
  self.snapShotUserInfo.deletechar = snapShotUserInfo.deletechar
  self.snapShotUserInfo.deletecdtime = snapShotUserInfo.deletecdtime
  self.snapShotUserInfo.maincharid = snapShotUserInfo.maincharid
  self.snapShotUserInfo.area = snapShotUserInfo.area
end

function MyselfProxy:GetUserRolesInfo()
  return self.snapShotUserInfo
end

function MyselfProxy:IsCurRoleNameInValid()
  local myselfid = Game.Myself and Game.Myself.data and Game.Myself.data.id
  return myselfid and self.roleNameValid[myselfid] == true
end

function MyselfProxy:GetZenyDebt()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZENY_DEBT) or 0
end

function MyselfProxy:GetROB()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
end

function MyselfProxy:GetPvpColor()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVP_COLOR)
end

function MyselfProxy:GetGold()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GOLD) or 0
end

function MyselfProxy:GetDiamond()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DIAMOND) or 0
end

function MyselfProxy:GetGarden()
  return BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
end

function MyselfProxy:GetLaboratory()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LABORATORY) or 0
end

function MyselfProxy:RoleLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) or 0
end

function MyselfProxy:JobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL) or 0
end

function MyselfProxy:JobExp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBEXP) or 0
end

function MyselfProxy:GetMyProfession()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION) or 0
end

function MyselfProxy:GetMyGuildScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILD_SCORE) or 0
end

function MyselfProxy:GetMasterJobLevel()
  local jobLevel = self:JobLevel()
  local jobLevelConfig = Table_JobLevel[jobLevel]
  if jobLevelConfig and jobLevelConfig.MasterLv and jobLevelConfig.MasterLv > 0 then
    return jobLevelConfig.ShowLevel
  end
  return 0
end

function MyselfProxy:GetMaxMasterJobLevel()
  local maxJobLevel = self:CurMaxJobLevel()
  for i = maxJobLevel, 1, -1 do
    local config = Table_JobLevel[i]
    if config.MasterLv and config.MasterLv > 0 then
      return config.ShowLevel
    end
  end
end

function MyselfProxy:GetTwelvePVPCamp()
  if self:InOb() then
    return FuBenCmd_pb.EGROUPCAMP_RED
  else
    return Game.Myself.data:GetTwelvePVPCamp()
  end
end

function MyselfProxy:UpdateObPosition(playerId, x, y, z, div)
  if self:IsObTarget(playerId) and Game.Myself then
    Game.Myself:Client_PlaceXYZTo(x, y, z, div)
  end
end

function MyselfProxy:InOb()
  return PvpObserveProxy.Instance:IsRunning()
end

function MyselfProxy:IsObTarget(id)
  return PvpObserveProxy.Instance:IsAttachingPlayer(id)
end

function MyselfProxy:GetMyProfessionType()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.Type or 0
end

function MyselfProxy:GetMyProfessionTypeBranch()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TypeBranch or 0
end

function MyselfProxy:GetMyProfessionSpecial()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.IsSpecialJob == 1
end

function MyselfProxy:GetMyRace()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.Race
end

function MyselfProxy:GetTwelvePvpCoin()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.TWELVEPVP_COIN) or 0
end

function MyselfProxy:GetMyProfessionName()
  return ProfessionProxy.GetProfessionName(self:GetMyProfession(), self:GetMySex())
end

function MyselfProxy:IsHero()
  return ProfessionProxy.IsHero(self:GetMyProfession())
end

function MyselfProxy:GetMyMapID()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MAPID) or 0
end

function MyselfProxy:GetServantStarCount()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SERVANT_CHALLENGE_EXP) or 0
end

function MyselfProxy:GetMySex()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
end

function MyselfProxy:GetMyServantID()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
end

function MyselfProxy:GetServantDialogIconCFG()
  local id = self:GetMyServantID()
  local cfg = GameConfig.Servant.dialogID_Icon
  if id and id ~= 0 and cfg and cfg[id] then
    return cfg[id]
  end
end

function MyselfProxy:GetZoneId()
  local myself = Game.Myself
  if myself then
    local userdata = myself.data.userdata
    return ChangeZoneProxy.Instance:GetZoneId(userdata:Get(UDEnum.ZONEID), userdata:Get(UDEnum.REAL_ZONEID))
  end
  return 0
end

function MyselfProxy:IsInPvpZone()
  local zoneid = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
  return ChangeZoneProxy.Instance:IsPvpZone(zoneid)
end

function MyselfProxy:GetZoneString()
  return ChangeZoneProxy.Instance:ZoneNumToString(self:GetZoneId())
end

function MyselfProxy:GetServerId()
  return FunctionLogin.Me():GetLineGroup() or 1
end

function MyselfProxy:IsSameServer(serverid)
  return serverid == self:GetServerId()
end

function MyselfProxy:GetMyTradeGroup()
  return ChangeZoneProxy.Instance:GetTradeGroupID(self:GetServerId()) or 0
end

function MyselfProxy:IsSameTradeGroup(groupid)
  return self:GetMyTradeGroup() == groupid
end

function MyselfProxy:GetQuota()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
end

function MyselfProxy:GetQuotaLock()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA_LOCK) or 0
end

function MyselfProxy:GetHasCharge()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HASCHARGE) or 0
end

function MyselfProxy:GetMyselfFashionHide()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MYSELF_FASHION_HIDE) or 0
end

function MyselfProxy:GetQueryType()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYTYPE) or 0
end

function MyselfProxy:GetQueryWeddingType()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUERYWEDDINGTYPE) or 0
end

function MyselfProxy:GetPvpCoin()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVPCOIN) or 0
end

function MyselfProxy:GetLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LOTTERY) or 0
end

function MyselfProxy:GetBcatDiamond()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BCAT_DIAMOND) or 0
end

function MyselfProxy:GetGuildHonor()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILDHONOR) or 0
end

function MyselfProxy:GetServantFavorability()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FAVORABILITY) or 0
end

function MyselfProxy:GetBoothScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BOOTH_SCORE) or 0
end

function MyselfProxy:GetExpRaidScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE) or 0
end

function MyselfProxy:GetExpRaidScoreInRaid()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE_RAID) or 0
end

function MyselfProxy:GetBeingCount()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BEING_COUNT) or 1
end

function MyselfProxy:GetContribution()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CONTRIBUTE) or 0
end

function MyselfProxy:GetBindContribution()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BIND_CONTRIBUTE) or 0
end

function MyselfProxy:GetDressUp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DRESSUP) or 0
end

function MyselfProxy:GetFreeLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FREELOTTERY) or 0
end

function MyselfProxy:GetGagTime()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GAGTIME) or 0
end

function MyselfProxy:IsInGagTime()
  local time = self:GetGagTime()
  if time == 0 then
    return false
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  if time < serverTime then
    return false
  end
  return true, time - serverTime
end

function MyselfProxy:GetOfflineStamp()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.AFK_FUNCTIME) or 0
end

function MyselfProxy:GetAfkRemainingTime()
  local seconds = self:GetOfflineStamp() - ServerTime.CurServerTime() / 1000
  if seconds < 0 then
    seconds = 0
  end
  return seconds
end

function MyselfProxy:GetAfkStatus()
  local remainingTime = self:GetAfkRemainingTime()
  if remainingTime <= 0 then
    return true, 0
  end
  return false, remainingTime
end

function MyselfProxy:ResetMyBornPos(x, y, z)
  LogUtility.Info("bornPos.." .. x .. " " .. y .. " " .. z)
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  end
end

function MyselfProxy:ResetMyPos(x, y, z, isgomap)
  if isgomap == nil then
    isgomap = false
  end
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  else
    LogUtility.Info("尝试重置位置，但未找到myself")
  end
end

function MyselfProxy:SetProps(UserAttrSyncCmd, update)
  self:setExtraProps(UserAttrSyncCmd.pointattrs, update)
  if Game.Myself then
    Game.Myself:Server_SetUserDatas(UserAttrSyncCmd.datas, not update)
    Game.Myself:Server_SetAttrs(UserAttrSyncCmd.attrs)
  end
end

function MyselfProxy:InitNMyself(data)
  if Game.Myself == nil then
    local myData = MyselfData.CreateAsTable(data)
    Game.Myself = NMyselfPlayer.CreateAsTable(myData)
    GAME_MYSELF_GUID = Game.Myself.data.id
  end
  FunctionSkillEnableCheck.Me():SetMySelf(Game.Myself)
end

function MyselfProxy:SetMySelfCurRole(data)
  if not self.myself then
    self:InitNMyself(data)
  end
  FunctionPlayerPrefs.Me():InitUser(data.id)
  LocalSaveProxy.Instance:InitDontShowAgain()
  LocalSaveProxy.Instance:InitWorldBossSaveList()
  LocalSaveProxy.Instance:InitBannerDontShowAgain()
  FunctionPerformanceSetting.Me():Load()
  if PQTL_Manager.Instance then
    PQTL_Manager.Instance.MyselfGUID = data.id
  end
end

function MyselfProxy:InitRole(data)
  local p = self.myself or MySelfPlayer.new(data.id)
  p.name = data.name
  p.roleInfo.ID = data.id
  p:ResetPropToRoleInfo()
  return p
end

function MyselfProxy:SetChooseRoleId(id)
  self.chooseRoleId = id
end

function MyselfProxy:GetChooseRoleId()
  return self.chooseRoleId
end

function MyselfProxy:SetShortCuts(shortCuts)
  if shortCuts ~= nil then
    for i = 1, #shortCuts do
    end
  end
end

function MyselfProxy:RecvVarUpdate(data)
  if self.vars == nil then
    self.vars = {}
  end
  if self.accvars == nil then
    self.accvars = {}
  end
  if data ~= nil and data.vars ~= nil then
    local vars = data.vars
    local varslen = #vars
    for i = 1, varslen do
      local single = vars[i]
      if single then
        local varData = self.vars[single.type]
        if not varData then
          varData = {
            type = single.type,
            time = single.time
          }
          self.vars[single.type] = varData
        end
        varData.value = single.value
      end
    end
  end
  if data ~= nil and data.accvars ~= nil then
    local accvars = data.accvars
    local acclen = #accvars
    for i = 1, acclen do
      local single = accvars[i]
      if single then
        local accvarData = self.accvars[single.type]
        if not accvarData then
          accvarData = {
            type = single.type,
            time = single.time
          }
          self.accvars[single.type] = accvarData
        end
        accvarData.value = single.value
      end
    end
  end
end

function MyselfProxy:getVarByType(type)
  if self.vars == nil then
    return
  end
  return self.vars[type]
end

function MyselfProxy:getVarValueByType(type)
  if not self.vars or not type then
    return
  end
  return self.vars[type] and self.vars[type].value
end

function MyselfProxy:GetAccVarByType(type)
  if self.accvars == nil then
    return
  end
  return self.accvars[type]
end

function MyselfProxy:GetAccVarValueByType(type)
  if not self.accvars then
    return
  end
  return self.accvars[type] and self.accvars[type].value
end

function MyselfProxy:RecvBufferUpdate(data)
  printRed("MyselfProxy:RecvBufferUpdate( data )")
  self.buffers = self.buffers or {}
  local updateBffs = {}
  local addBffs = {}
  if data.buff then
    for i = 1, #data.buff do
      local single = data.buff[i]
      if self.buffers[single.id] then
        local data = {}
        data.id = single.id
        data.oldLayer = self.buffers[single.id]
        data.newLayer = single.layer
        table.insert(updateBffs, data)
      else
        table.insert(addBffs, single)
      end
      self.buffers[single.id] = single.layer
    end
  end
  for i = 1, #updateBffs do
    local single = updateBffs[i]
    local buffData = Table_Buffer[single.id]
    local effect = buffData.BuffEffect
    local newLayer = single.newLayer
    local oldLayer = single.oldLayer
    if effect.type == "AttrChange" then
      for j, w in pairs(effect) do
        local prop = self.buffersProps[j]
        if j ~= "type" and prop and type(w) == "number" then
          local oldValue = self.buffersProps:GetValueByName(j)
          local deltaValue = (newLayer - oldLayer) * w
          if prop.propVO.isPercent then
            deltaValue = deltaValue * 1000
            oldValue = oldValue * 1000
          end
          local value = oldValue + deltaValue
          self.buffersProps:SetValueByName(j, value)
          self.buffAttr[j] = value
        end
      end
    end
  end
  for i = 1, #addBffs do
    local single = addBffs[i]
    local buffData = Table_Buffer[single.id]
    if buffData == nil or buffData.BuffEffect == nil then
      break
    end
    local effect = buffData.BuffEffect
    local v = single.layer
    if effect.type == "AttrChange" then
      for j, w in pairs(effect) do
        if j ~= "type" and type(w) == "number" then
          local prop = self.buffersProps[j]
          if prop then
            local oldValue = self.buffersProps:GetValueByName(j)
            local deltaValue = w * v
            if prop.propVO.isPercent then
              deltaValue = deltaValue * 1000
              oldValue = oldValue * 1000
            end
            local vl = deltaValue + oldValue
            self.buffersProps:SetValueByName(j, vl)
            self.buffAttr[j] = vl
          end
        end
      end
    end
  end
end

function MyselfProxy:setExtraProps(props, update)
  if props ~= nil and 0 < #props then
    for i = 1, #props do
      if props[i] ~= nil then
        self.extraProps:SetValueById(props[i].type, props[i].value)
      end
    end
  end
end

function MyselfProxy:checkProfessionIsOpenById(profession)
  self:checkProfessionIsOpenByProfessionData(Table_Class[profession])
  return false
end

function MyselfProxy:checkProfessionIsOpenByProfessionData(professionData)
  return false
end

function MyselfProxy:initAllTitle(data)
  self.appellations = {}
  local titles = data.title_datas
  for i = 1, #titles do
    local title = titles[i]
    local Appellation = Appellation.new(title.id, title.title_type, title.createtime)
    self.appellations[#self.appellations + 1] = Appellation
  end
end

function MyselfProxy:newTitle(data)
  local titleData = data.title_data
  local id = data.charid
  if id == Game.Myself.data.id then
    local Appellation = Appellation.new(titleData.id, titleData.title_type, titleData.createtime)
    for i = 1, #self.appellations do
      local title = self.appellations[i]
      if title.id == Appellation.id then
        self.appellations[i] = Appellation
        return
      end
    end
    self.appellations[#self.appellations + 1] = Appellation
  end
  if titleData.title_type == UserEvent_pb.ETITLE_TYPE_MANNUAL then
    local creature = NSceneUserProxy.Instance:Find(id)
    if creature then
      GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, creature, SceneUserEvent.AppellationUp)
    end
  end
end

function MyselfProxy:GetCurManualAppellation()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_MANNUAL and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end

function MyselfProxy:GetCurFoodCookerApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODCOOKER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end

function MyselfProxy:GetCurFoodTasteApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODTASTER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end

function MyselfProxy:getAppellationById(id)
  if not id then
    return
  end
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.id == id then
      return title
    end
  end
end

function MyselfProxy:SetTraceItem(updates, dels)
  if updates then
    for i = 1, #updates do
      local upItem = updates[i]
      self.traceItems[upItem.itemid] = upItem
    end
  end
  if dels then
    for i = 1, #dels do
      local delid = dels[i]
      self.traceItems[delid] = nil
    end
  end
end

function MyselfProxy:GetTraceItems()
  local result = {}
  for _, item in pairs(self.traceItems) do
    table.insert(result, item)
  end
  return result
end

function MyselfProxy:GetTraceItemByItemId(itemid)
  return self.traceItems[itemid]
end

function MyselfProxy:SetUnlockActionIdMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockActionIds[id] = 1
  end
end

function MyselfProxy:GetUnlockActionMap()
  return self.unlockActionIds
end

function MyselfProxy:SetUnlockEmojiMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockEmojiIds[id] = 1
  end
end

function MyselfProxy:GetUnlockEmojiMap()
  return self.unlockEmojiIds
end

function MyselfProxy:HasJobBreak()
  if GameConfig.SystemForbid.Peak then
    return false
  end
  local _FunctionUnLockFunc = FunctionUnLockFunc.Me()
  return _FunctionUnLockFunc:CheckCanOpen(450) or _FunctionUnLockFunc:CheckCanOpen(453)
end

function MyselfProxy:HasJobNewBreak()
  return FunctionUnLockFunc.Me():CheckCanOpen(451)
end

function MyselfProxy:HasMaxJobBreak()
  return self:HasJobBreak() and self:CurMaxJobLevel() >= GameConfig.Dead.max_peaklv or false
end

function MyselfProxy:UpdateRandomFunc(array, beginIndex, endIndex)
  if nil ~= self.myself then
    self.myself:UpdateRandomFunc(array, beginIndex, endIndex)
  end
  if nil ~= Game.Myself then
    Game.Myself.data:UpdateRandomFunc(array, beginIndex, endIndex)
  end
end

function MyselfProxy:Server_SetEquipPos_StateTime(server_EquipPosDatas)
  local logStr = "脱卸装备:"
  for i = 1, #server_EquipPosDatas do
    local d = server_EquipPosDatas[i]
    local key = self:_GetEquipPosKey(d.pos, d.is_shadow)
    local ld = self.equipPosStateTimeMap[key]
    if ld == nil then
      ld = {}
      self.equipPosStateTimeMap[key] = ld
    end
    ld.offstarttime = d.offstarttime
    ld.offendtime = d.offendtime
    ld.offduration = d.offendtime - d.offstarttime
    ld.protecttime = d.protecttime
    ld.protectalways = d.protectalways
    ld.is_shadow = d.is_shadow
    logStr = logStr .. string.format("部位:%s || 脱卸开始时间:%s 脱卸结束时间:%s 装备保护时间:%s 装备永久保护:%s", tostring(d.pos), os.date("%m月%d日%H点%M分%S秒", d.offstarttime), os.date("%m月%d日%H点%M分%S秒", d.offendtime), os.date("%m月%d日%H点%M分%S秒", d.protecttime), tostring(d.protectalways))
    logStr = logStr .. "\n"
  end
  helplog(logStr)
  FunctionBuff.Me():UpdateOffingEquipBuff()
  FunctionBuff.Me():UpdateProtectEquipBuff()
end

function MyselfProxy:GetEquipPos_StateTime(site, is_shadow)
  local key = self:_GetEquipPosKey(site, is_shadow)
  return self.equipPosStateTimeMap[key]
end

function MyselfProxy:IsEquipPosInOffing(site, is_shadow)
  local stateTime = self:GetEquipPos_StateTime(site, is_shadow)
  if stateTime and stateTime.offendtime and stateTime.offendtime > 0 then
    return 0 < ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000)
  end
  return false
end

function MyselfProxy:GetOffingEquipPoses()
  local offPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    local pos, is_shadow = self:_ParseEquipPosKey(k)
    if self:IsEquipPosInOffing(pos, is_shadow) then
      table.insert(offPoses, {pos = pos, is_shadow = is_shadow})
    end
  end
  table.sort(offPoses, function(a, b)
    if a.pos == b.pos then
      return (a.is_shadow and 1 or 0) < (b.is_shadow and 1 or 0)
    end
    return a.pos < b.pos
  end)
  return offPoses
end

function MyselfProxy:IsEquipPosInProtecting(site, is_shadow)
  local stateTime = self:GetEquipPos_StateTime(site, is_shadow)
  if stateTime then
    if stateTime.protectalways > 0 then
      return true
    end
    if stateTime.protecttime and 0 < stateTime.protecttime then
      return 0 < ServerTime.ServerDeltaSecondTime(stateTime.protecttime * 1000)
    end
  end
  return false
end

function MyselfProxy:HandleRelieveCd(data)
  self.reliveStamp = data.time + ServerTime.CurServerTime() / 1000
  self.reliveName = data.name
end

function MyselfProxy:ClearReliveCd()
  self.reliveStamp = nil
  self.reliveName = nil
end

function MyselfProxy:HandleRelieveFubenCd(data)
  self.reliveFubenCD = data.next_relive_time
end

function MyselfProxy:ClearReliveFubenCd()
  self.reliveFubenCD = nil
end

function MyselfProxy:GetProtectEquipPoses()
  local protectPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    local pos, is_shadow = self:_ParseEquipPosKey(k)
    if self:IsEquipPosInProtecting(pos, is_shadow) then
      table.insert(protectPoses, {pos = pos, is_shadow = is_shadow})
    end
  end
  table.sort(protectPoses, function(a, b)
    if a.pos == b.pos then
      return (a.is_shadow and 1 or 0) < (b.is_shadow and 1 or 0)
    end
    return a.pos < b.pos
  end)
  return protectPoses
end

function MyselfProxy:IsUnlockAstrolabe()
  local panelId = PanelConfig.AstrolabeView.id
  return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(panelId)
end

function MyselfProxy:SetDebts(data)
  TableUtility.ArrayClear(self.debtDatas)
  if not data.acc_items then
    return
  end
  local accItems = data.acc_items
  for i = 1, #accItems do
    local single = accItems[i].base
    local data = {
      id = single.id,
      num = single.count,
      type = 1
    }
    self.debtDatas[#self.debtDatas + 1] = data
  end
end

local debtsResult = {}

function MyselfProxy:GetDebts()
  TableUtility.ArrayClear(debtsResult)
  for i = 1, #self.debtDatas do
    debtsResult[#debtsResult + 1] = self.debtDatas[i]
  end
  local zenyDebt = self:GetZenyDebt()
  if 0 < zenyDebt then
    local data = {
      id = GameConfig.MoneyId.Zeny,
      num = zenyDebt,
      type = 3
    }
    debtsResult[#debtsResult + 1] = data
  end
  return debtsResult
end

function MyselfProxy:InitPropsTab()
  self.propTabConfigs = {}
  local PropTabConfig = GameConfig.PropTabConfig
  if not PropTabConfig then
    return
  end
  local propsTable = Table_RoleData
  for k, v in pairs(propsTable) do
    local class = v.class
    if class then
      local propTab = PropTabConfig[class]
      if propTab then
        local propConfigData = self.propTabConfigs[class] or {
          desc = propTab.desc,
          name = propTab.name,
          props = {},
          upLimitProps = {},
          id = propTab.id
        }
        local props = propConfigData.props
        local upLimitProps = propConfigData.upLimitProps
        if GameConfig.Charactor_InfoShow_Limit and GameConfig.Charactor_InfoShow_Limit[v.id] then
          upLimitProps[#upLimitProps + 1] = v
        else
          props[#props + 1] = v
        end
        self.propTabConfigs[class] = propConfigData
      end
    end
  end
  for k, v in pairs(self.propTabConfigs) do
    local props = v.props
    table.sort(props, function(l, r)
      return l.order < r.order
    end)
    local upLimitProps = v.upLimitProps
    table.sort(upLimitProps, function(l, r)
      return l.order < r.order
    end)
  end
end

function MyselfProxy:GetTotalNeedBaseExp()
  local userData = Game.Myself.data.userdata
  local roleExp = userData:Get(UDEnum.ROLEEXP) or 0
  local tempExpNeed = 0
  local tempLevel = self:RoleLevel()
  local maxLevel = userData:Get(UDEnum.ROLELEVEL_MAX) or Table_BaseLevel[#Table_BaseLevel].id
  while tempLevel < maxLevel do
    local nextBaseLevel = Table_BaseLevel[tempLevel + 1]
    if nextBaseLevel then
      tempExpNeed = tempExpNeed + nextBaseLevel.NeedExp
      tempLevel = tempLevel + 1
    else
      break
    end
  end
  tempExpNeed = tempExpNeed - roleExp
  return tempExpNeed
end

function MyselfProxy:GetTotalNeedJobExp()
  local userData = Game.Myself.data.userdata
  local nowJob = Game.Myself.data:GetCurOcc()
  local maxJobLevel = userData:Get(UDEnum.CUR_MAXJOB) or 0
  local tempJobExpNeed = 0
  local tempJobLevel = nowJob.level
  local isHero = ProfessionProxy.IsHero(nowJob.profession)
  while maxJobLevel > tempJobLevel do
    local nextJobLevel = Table_JobLevel[tempJobLevel + 1]
    if nextJobLevel then
      local nextExpValue = isHero and Table_JobLevel[tempJobLevel + 1].HeroJobExp or Table_JobLevel[tempJobLevel + 1].JobExp
      tempJobExpNeed = tempJobExpNeed + nextExpValue
      tempJobLevel = tempJobLevel + 1
    else
      break
    end
  end
  tempJobExpNeed = tempJobExpNeed - nowJob.exp
  return tempJobExpNeed
end

function MyselfProxy:SyncEquipPosOnCd(datas)
  if not datas then
    return
  end
  local element
  local curServerTime = ServerTime.CurServerTime() / 1000
  for i = 1, #datas do
    element = datas[i]
    if 1 > element.time - curServerTime then
      self.equipPosOnCdEndTimeMap[element.pos] = curServerTime + 1
    else
      self.equipPosOnCdEndTimeMap[element.pos] = element.time
    end
  end
end

function MyselfProxy:GetEquipPosOnCdTime(pos)
  local endTime = self.equipPosOnCdEndTimeMap[pos]
  if not endTime then
    return
  end
  local delta = ServerTime.ServerDeltaSecondTime(endTime * 1000)
  if delta <= 0 then
    self.equipPosOnCdEndTimeMap[pos] = nil
    return
  end
  return delta
end

local NOT_YET_SHADOWEQUIP = CommonFun.PackType == nil

function MyselfProxy:SyncEquipPosEffectTime(data)
  if not data then
    return
  end
  local info = self.equipPosEffectTimeMap[data.pos]
  if not info then
    info = {}
    self.equipPosEffectTimeMap[data.pos] = info
  end
  if NOT_YET_SHADOWEQUIP or data.type == CommonFun.PackType.EPACKTYPE_EQUIP then
    info.EQUIP = {
      data.end_time,
      data.total_cd
    }
  elseif data.type == CommonFun.PackType.EPACKTYPE_SHADOWEQUIP then
    info.SHADOW = {
      data.end_time,
      data.total_cd
    }
  end
end

function MyselfProxy:GetEquipPosEffectTime(pos, isViceEquip)
  local info = self.equipPosEffectTimeMap[pos]
  if not info then
    return
  end
  if NOT_YET_SHADOWEQUIP then
    isViceEquip = false
  end
  local time
  if isViceEquip then
    time = info.SHADOW
  else
    time = info.EQUIP
  end
  if not time then
    return
  end
  local endTime = time and time[1]
  if not endTime then
    return
  end
  local delta = ServerTime.ServerDeltaSecondTime(endTime)
  if delta <= 0 then
    if isViceEquip then
      info.SHADOW = nil
    else
      info.EQUIP = nil
    end
    return
  end
  return delta, time[2] / 1000
end

function MyselfProxy:GetOtherPlayerEquipHide()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HIDEOTHER) or 0
end

function MyselfProxy:SetQuestRepairMode(bool)
  xdlog("任务修复模式", bool)
  self.questRepairModeOn = bool
  GameFacade.Instance:sendNotification(QuestEvent.QuestRepairMode, self.questRepairModeOn)
end

function MyselfProxy:SetTargetAndPos(data)
  if data and data.sign then
    self.targetGuid = data.guid
    self.targetPos = ProtolUtility.S2C_Vector3(data.pos)
  else
    self.targetGuid = nil
    if self.targetPos then
      self.targetPos:Destroy()
      self.targetPos = nil
    end
  end
end

function MyselfProxy:GetTargetAndPos()
  return self.targetGuid, self.targetPos
end

function MyselfProxy:SetMaxBullets(value)
  self.maxBulltes = value
end

function MyselfProxy:SetCurBullets(value)
  self.curBulltes = value
end

function MyselfProxy:GetCurBullets(value)
  return self.curBulltes or 0
end

function MyselfProxy:GetMyDefaultTeamRole()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TeamFunction and profession.TeamFunction.default
end

function MyselfProxy:GetMyTeamRoles()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.TeamFunction and profession.TeamFunction.selects or _EmptyTable
end

function MyselfProxy:GetWantedBaseLv(extraExp)
  if extraExp <= 0 then
    return 0, 0
  end
  local myRoleLv = self:RoleLevel()
  local roleExp = Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLEEXP)
  extraExp = extraExp + roleExp
  local baseData
  local upgradeLv = 0
  while 0 < extraExp do
    myRoleLv = myRoleLv + 1
    baseData = Table_BaseLevel[myRoleLv]
    if not baseData then
      return upgradeLv, 0
    end
    if extraExp < baseData.NeedExp then
      return upgradeLv, 0 < upgradeLv and extraExp or extraExp - roleExp
    end
    extraExp = extraExp - baseData.NeedExp
    upgradeLv = upgradeLv + 1
  end
end

function MyselfProxy:GetWantedJobLv(extraExp)
  if extraExp <= 0 then
    return 0, 0
  end
  local pro = self:GetMyProfession()
  local cur_lv = self:JobLevel()
  local cur_max = self:CurMaxJobLevel()
  local refactoryLv, cur_max = Occupation.GetMyFixedJobLevelWithMax_Refactory(cur_lv, cur_max, pro)
  local curOcc = Game.Myself.data:GetCurOcc()
  local isHero = ProfessionProxy.IsHero(pro)
  extraExp = extraExp + curOcc.exp
  local jobData
  local upgradeLv = 0
  while 0 < extraExp do
    cur_lv = cur_lv + 1
    if cur_max <= refactoryLv + upgradeLv then
      return upgradeLv, 0
    end
    jobData = Table_JobLevel[cur_lv]
    local curLeveljobExp = isHero and jobData.HeroJobExp or jobData.JobExp or 0
    if extraExp < curLeveljobExp then
      return upgradeLv, 0 < upgradeLv and extraExp or extraExp - curOcc.exp
    end
    extraExp = extraExp - (isHero and jobData.HeroJobExp or jobData.JobExp or 0)
    upgradeLv = upgradeLv + 1
  end
end

function MyselfProxy:UpdateSpeedUp(server_data)
  self.month_card_effect = server_data.month_card_effect
  self.exp_item_branchs = {}
  if server_data.exp_item_branchs then
    for i = 1, #server_data.exp_item_branchs do
      local typeBranch = server_data.exp_item_branchs[i]
      self.exp_item_branchs[i] = typeBranch
    end
  end
  self.in_max_profession = server_data.in_max_profession
  self.server_open_day = server_data.server_open_day
  if not self.speedUpMap then
    self.speedUpMap = {}
  end
  TableUtility.TableClear(self.speedUpMap)
  for i = 1, #server_data.base_speedup do
    local serverData = server_data.base_speedup[i]
    local id = serverData.etype * 1000 + 1
    self.speedUpMap[id] = serverData.addper
  end
  for i = 1, #server_data.job_speedup do
    local serverData = server_data.job_speedup[i]
    local id = serverData.etype * 1000 + 2
    self.speedUpMap[id] = serverData.addper
  end
  for i = 1, #server_data.gem_speedup do
    local serverData = server_data.gem_speedup[i]
    local id = serverData.etype * 1000 + 3
    self.speedUpMap[id] = serverData.addper
  end
end

function MyselfProxy:GetSpeedUpRatioById(id)
  if self.speedUpMap then
    return self.speedUpMap[id] or 0
  end
  return 0
end

function MyselfProxy:GetSpeedUpTotalRatioByType(type)
  local totalRatio = 0
  for id, ratio in pairs(self.speedUpMap) do
    if id % 1000 == type then
      totalRatio = totalRatio + ratio
    end
  end
  return totalRatio
end

function MyselfProxy:GetSpeedUpRatioByWhereAndType(where, type)
  local speedUpRatio = 0
  local key = ""
  if type == 1 then
    key = "base"
  elseif type == 2 then
    key = "job"
  end
  local where_to_methods = GameConfig.SpeedUp.where_to_methods[key] and GameConfig.SpeedUp.where_to_methods[key][where]
  if where_to_methods then
    for i = 1, #where_to_methods do
      local etype = where_to_methods[i]
      local id = etype * 1000 + type
      speedUpRatio = speedUpRatio + self:GetSpeedUpRatioById(id)
    end
  end
  return speedUpRatio
end

function MyselfProxy:RecvSyncInterferenceData(data)
  self:ReinitInterferenceProps()
  if data then
    local adds = data.adds
    if adds then
      if not self.interferenceProps_Add then
        self.interferenceProps_Add = {}
      end
      for i = 1, #adds do
        self.interferenceProps_Add[adds[i].type] = adds[i].value or 0
      end
      EventManager.Me():DispatchEvent(MyselfEvent.InterferenceValueChange)
    end
    local reduces = data.reduces
    if reduces then
      if not self.interferenceProps_Reduce then
        self.interferenceProps_Reduce = {}
      end
      for i = 1, #reduces do
        self.interferenceProps_Reduce[reduces[i].type] = reduces[i].value or 0
      end
    end
    local tar_reduces = data.tar_reduces
    if tar_reduces then
      if not self.interferenceProps_TargetReduce then
        self.interferenceProps_TargetReduce = {}
      end
      for i = 1, #tar_reduces do
        local charid = tar_reduces[i].charid or 0
        self.interferenceProps_TargetReduce[charid] = tar_reduces[i].total_value
        local scenePlayer = NSceneUserProxy.Instance:Find(charid)
        if scenePlayer then
          local sceneUI = scenePlayer:GetSceneUI()
          if sceneUI then
            sceneUI.roleBottomUI:UpdateExecutePart()
          end
        end
      end
    end
  else
    EventManager.Me():DispatchEvent(MyselfEvent.InterferenceValueChange)
  end
end

function MyselfProxy:GetTarInterferenceValue(targetID)
  if not self.interferenceProps_TargetReduce or not targetID then
    return 0
  end
  return self.interferenceProps_TargetReduce[targetID] or 0
end

function MyselfProxy:GetMyInterferenceValue()
  if not self.interferenceProps_Add then
    return 0
  end
  local iValue = 0
  for _, value in pairs(self.interferenceProps_Add) do
    iValue = iValue + value
  end
  return iValue
end

function MyselfProxy:GetMyInterferenceValueByType(typeID)
  if not typeID then
    return 0
  end
  local add = self.interferenceProps_Add and self.interferenceProps_Add[typeID] or 0
  local reduce = self.interferenceProps_Reduce and self.interferenceProps_Reduce[typeID] or 0
  return add - reduce
end

function MyselfProxy:ReinitInterferenceProps()
  if self.interferenceProps_Add then
    TableUtility.TableClear(self.interferenceProps_Add)
  else
    self.interferenceProps_Add = {}
  end
  if self.interferenceProps_Reduce then
    TableUtility.TableClear(self.interferenceProps_Reduce)
  else
    self.interferenceProps_Reduce = {}
  end
  if self.interferenceProps_TargetReduce then
    TableUtility.TableClear(self.interferenceProps_TargetReduce)
  else
    self.interferenceProps_TargetReduce = {}
  end
end

function MyselfProxy:IsProfessionSpeedUp(pro)
  if not self.exp_item_branchs then
    return false
  end
  if ProfessionProxy.IsDoramRace(pro) then
    return TableUtility.ArrayFindIndex(self.exp_item_branchs, 81) > 0
  end
  local config = Table_Class[pro]
  if config then
    local isFirstDepth = ProfessionProxy.GetJobDepth(pro) == 1
    local param = isFirstDepth and config.Type or config.TypeBranch
    return TableUtility.ArrayFindByPredicate(self.exp_item_branchs, function(v, args)
      local branch = isFirstDepth and math.floor(v / 10) or v
      return branch == args
    end, param) ~= nil
  end
  return false
end

function MyselfProxy:IsItemBaseSpeedUpWorked()
  local id = ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM * 1000 + 1
  local addper = self:GetSpeedUpRatioById(id)
  return 0 < addper
end

local HeinrichWeaponPos = {7, 1}

function MyselfProxy:GetHeinrichWeaponPos(poses)
  local class = self:GetMyProfession()
  if not ProfessionProxy.ShieldPosCanEquipWeapon(class, Game.Myself) then
    return poses
  end
  return HeinrichWeaponPos
end

function MyselfProxy:GetFakeNormalAtkID()
  if Game.Myself.data:CheckEnergyBuffFull() then
    return 2734001
  end
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf(myPro)
  return FakeNormalAtk and FakeNormalAtk[myTypeBranch]
end

function MyselfProxy:GetTotalAddBasePoint(from, to)
  local tempPoint = 0
  from = from + 1
  while to >= from do
    local last = Table_BaseLevel[from]
    if last then
      tempPoint = tempPoint + last.AddPoint
      from = from + 1
    else
      break
    end
  end
  return tempPoint
end

function MyselfProxy:RecvLevelUPQueue(lvType, from)
  local lvUpMap = self.lvUpMap or {}
  if not lvType or lvUpMap[lvType] then
    return
  end
  lvUpMap[lvType] = from
  self.lvUpMap = lvUpMap
end

function MyselfProxy:PopLevelUPData(lvType)
  if not self.lvUpMap then
    return
  end
  local data, lvType
  if lvType then
    data = self.lvUpMap[lvType]
    self.lvUpMap[lvType] = nil
  end
  if data == nil then
    lvType, data = next(self.lvUpMap)
    if data then
      self.lvUpMap[lvType] = nil
    end
  end
  return data, lvType
end

function MyselfProxy:PeekLevelUPData(lvType)
  if not self.lvUpMap then
    return false
  end
  if lvType then
    if not self.lvUpMap[lvType] then
      return next(self.lvUpMap) ~= nil
    end
    return self.lvUpMap[lvType] ~= nil
  end
  return next(self.lvUpMap) ~= nil
end

function MyselfProxy:CheckLevelUPData(lvType)
  if not lvType or not self.lvUpMap then
    return false
  end
  return self.lvUpMap[lvType] ~= nil
end

function MyselfProxy:ClearLevelUPQueue()
  if not self.lvUpMap then
    return
  end
  TableUtility.TableClear(self.lvUpMap)
end

function MyselfProxy:IsProfessionCook()
  local class = self:GetMyProfession()
  return ProfessionProxy.Cook == class
end

function MyselfProxy:IsProfessionAlinia()
  local class = self:GetMyProfession()
  return ProfessionProxy.Elynia == class
end

function MyselfProxy:SetSendMarksInfo(data)
  if not self.marksMap then
    self.marksMap = {}
  else
    TableUtility.TableClear(self.marksMap)
  end
  if not self.markSkill then
    self.markSkill = {}
  else
    TableUtility.TableClear(self.markSkill)
  end
  if data.buffid == 0 then
    return
  end
  if data and data.guids then
    local guids = data.guids
    for i = 1, #guids do
      self.marksMap[guids[i]] = true
    end
  end
  self.markBuff = data.buffid
  local buffConfig = Table_Buffer[self.markBuff]
  if not buffConfig or not buffConfig.BuffEffect then
    return
  end
  local skills = buffConfig.BuffEffect.SkillID
  for i = 1, #skills do
    self.markSkill[skills[i]] = true
  end
end

function MyselfProxy:CheckInMarks(skillid, guid)
  if not self.markSkill or not self.markSkill[skillid] then
    return false
  end
  if not self.marksMap then
    return false
  end
  return self.marksMap[guid]
end

function MyselfProxy:GetMarkParam(targetCreature)
  local per = 0
  if self.markBuff then
    local launPer = Table_Buffer[self.markBuff].BuffEffect.LaunPer
    per = CommonFun.calcBuffValue(Game.Myself.data, targetCreature and targetCreature.data, launPer.type, launPer.a, launPer.b, launPer.c, launPer.d, 0, 0)
  end
  return per
end

function MyselfProxy:SyncBuffSource(data)
  if data.datas then
    local guid = data.guid
    local datas = data.datas
    if guid == Game.Myself.data.id then
      Game.Myself.data:SyncBuffSource(datas)
      return
    end
    local creature = SceneCreatureProxy.FindCreature(guid)
    if creature and creature.data then
      creature.data:SyncBuffSource(datas)
      return
    end
  end
end

return MyselfProxy
