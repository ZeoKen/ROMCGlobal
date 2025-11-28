LogicManager_Myself_Userdata = class("LogicManager_Myself_Userdata", LogicManager_Player_Userdata)

function LogicManager_Myself_Userdata:ctor()
  LogicManager_Myself_Userdata.super.ctor(self)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_CURID, self.MusicBoxInfoChange)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_START, self.MusicBoxInfoChange)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_LOOP, self.MusicBoxInfoChange)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ZONEID, self.UpdateZoneId)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REAL_ZONEID, self.UpdateZoneId)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NORMALSKILL_OPTION, self.UpdateNormalSkillOption)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.SetProfession)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CONTRIBUTE, self.UpdateContribute)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BIND_CONTRIBUTE, self.UpdateContribute)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MARITAL, self.UpdateMarital)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_WEAPONPET_EXP, self.UpdateWeaponPetExp)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NIGHTMARE, self.UpdateNightmare)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TWELVEPVP_COIN, self.UpdateTwelvePvp_Coin)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_CURID, self.MusicBoxInfoChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_START, self.MusicBoxInfoChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_LOOP, self.MusicBoxInfoChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ROLEEXP, self.BaseExpChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ZONEID, self.UpdateZoneId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REAL_ZONEID, self.UpdateZoneId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SILVER, self.UpdateZeny)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_FAVORABILITY, self.UpdateServantFavor)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NORMALSKILL_OPTION, self.UpdateNormalSkillOption)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CONTRIBUTE, self.UpdateContribute)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BIND_CONTRIBUTE, self.UpdateContribute)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MARITAL, self.UpdateMarital)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_COOKER_LV, self.UpdateCookLv)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TASTER_LV, self.UpdateTasterLv)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BEING_COUNT, self.UpdateBeingCount)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SERVANTID, self.UpdateServantID)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BATTLEPASS_LV, self.UpdateBattlePassLv)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BATTLEPASS_EXP, self.UpdateBattlePassExp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BATTLEPASS_COIN, self.UpdateBattlePassCoin)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_WEAPONPET_EXP, self.UpdateWeaponPetExp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NIGHTMARE, self.UpdateNightmare)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HIDEOTHER, self.UpdatePlayerFashion)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TWELVEPVP_COIN, self.UpdateTwelvePvp_Coin)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_GUILD_SCORE, self.UpdateMyGuildScore)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NOVICE_TARGET_POINT, self.UpdateNoviceTargetPoint)
  self:RemoveUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DIR)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PORTRAIT_FRAME, self.UpdatePortraitFrame)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MONSTER_PORTRAIT, self.UpdatePortraitFrame)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PORTRAIT, self.UpdatePortraitFrame)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_LOTTERY, self.UpdateLottery)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_KILLERNAME, self.UpdateKillName)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SERVANT_CHALLENGE_EXP, self.UpdateServantChallengeExp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_AUTOSELL, self.UpdateAutoSell)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SKILL_POINT, self.UpdateAddPointNotice)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TOTALPOINT, self.UpdateAddPointNotice)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RECALL_TIME, self.UpdateRecallTime)
  self.spProfessionHandler = {
    [111] = self.TryShowBullets,
    [601] = self.TryShowFrenzy,
    [661] = self.TryShowFeather,
    [681] = self.TryUpdateHeinrich,
    [771] = self.TryUpdateSunShine
  }
end

function LogicManager_Myself_Userdata:SetProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:HandlerAssetRoleSuffixMap()
  AstrolabeProxy.Instance:InitProfessionPlate_PropData(newValue)
  LogicManager_Myself_Userdata.super.SetProfession(self, ncreature, userDataID, oldValue, newValue)
  self:HandleProfessionEffect(ncreature, userDataID, oldValue, newValue)
end

function LogicManager_Myself_Userdata:HandleProfessionEffect(ncreature, userDataID, oldValue, newValue)
  local oldbranch = ProfessionProxy.GetTypeBranchFromProf(oldValue) or 0
  local newbranch = ProfessionProxy.GetTypeBranchFromProf(newValue) or 0
  local spHandler = self.spProfessionHandler[oldbranch]
  if spHandler then
    spHandler(self, ncreature, userDataID, oldbranch, newbranch)
  end
  if oldbranch ~= newbranch then
    spHandler = self.spProfessionHandler[newbranch]
    if spHandler then
      spHandler(self, ncreature, userDataID, oldbranch, newbranch)
    end
  end
end

function LogicManager_Myself_Userdata:CheckDressDirty(ncreature)
  if self.changeDressDirty then
    self.changeDressDirty = false
    ncreature:ReDress()
    GameFacade.Instance:sendNotification(MyselfEvent.ChangeDress)
    EventManager.Me():PassEvent(MyselfEvent.ChangeDress)
  end
end

function LogicManager_Myself_Userdata:_Die(ncreature, isSet)
  LogicManager_Myself_Userdata.super._Die(self, ncreature, isSet)
end

function LogicManager_Myself_Userdata:_Revive(ncreature, oldValue)
  if oldValue == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD and ncreature.assetRole:IsPlayingAction(Asset_Role.ActionName.Die) then
    ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Idle)
  end
  ncreature:Server_ReviveCmd()
end

function LogicManager_Myself_Userdata:_FakeDie(ncreature)
  FunctionSystem.InterruptMyself()
  ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Die, 1, false, true)
end

function LogicManager_Myself_Userdata:UpdateProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateProfession()
  GameFacade.Instance:sendNotification(MyselfEvent.MyProfessionChange)
  EventManager.Me():PassEvent(MyselfEvent.MyProfessionChange)
  FunctionItemCompare.Me():TryCompare()
  AstrolabeProxy.Instance:InitProfessionPlate_PropData(newValue)
  self:HandleProfessionEffect(ncreature, userDataID, oldValue, newValue)
end

function LogicManager_Myself_Userdata:MusicBoxInfoChange(ncreature, userDataID, oldValue, newValue)
  local soundid = ncreature.data.userdata:Get(UDEnum.MUSIC_CURID)
  local starttime = ncreature.data.userdata:Get(UDEnum.MUSIC_START)
  local playTimes = ncreature.data.userdata:Get(UDEnum.MUSIC_LOOP) == 1 and 0 or 1
  local force = not PlotAudioProxy.Instance:CheckPlayStatus()
  FunctionMusicBox.Me():SetMusic(soundid, starttime, playTimes, force)
end

function LogicManager_Myself_Userdata:UpdateJobExpLevel(ncreature, userDataID, oldValue, newValue)
  LogicManager_Myself_Userdata.super.UpdateJobExpLevel(self, ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.JobExpChange)
end

function LogicManager_Myself_Userdata:BaseExpChange(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.BaseExpChange)
end

function LogicManager_Myself_Userdata:UpdateZoneId(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ZoneIdChange)
end

function LogicManager_Myself_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  LogicManager_Myself_Userdata.super.UpdateRoleLevel(self, ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.LevelUp)
  if newValue == 120 then
    FunctionTyrantdb.Instance:trackEvent("#BaseLevel_120", nil)
  end
  FunctionActivity.Me():UpdateNowMapTraceInfo()
  if oldValue < newValue and not MyselfProxy.Instance:CheckLevelUPData(SceneUserEvent.BaseLevelUp) then
    MyselfProxy.Instance:RecvLevelUPQueue(SceneUserEvent.BaseLevelUp, oldValue)
    if not UIManagerProxy.Instance:HasUINode(PanelConfig.LevelUpPanel) then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LevelUpPanel,
        viewdata = {
          from = oldValue,
          to = newValue,
          lvType = SceneUserEvent.BaseLevelUp
        }
      })
    else
      GameFacade.Instance:sendNotification(SceneUserEvent.Me_LevelUp, {
        from = oldValue,
        to = newValue,
        lvType = SceneUserEvent.BaseLevelUp
      }, SceneUserEvent.BaseLevelUp)
    end
  end
end

function LogicManager_Myself_Userdata:UpdateJobLevel(ncreature, userDataID, oldValue, newValue, bytes, changeJob)
  LogicManager_Myself_Userdata.super.UpdateJobLevel(self, ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.LevelUp)
  local check, oldJobLV, newJobLV = self:CheckShowJobLevel(oldValue, newValue)
  local node = UIManagerProxy.Instance:GetNodeByPanelConfig(PanelConfig.SkillView)
  if check and not changeJob and not MyselfProxy.Instance:CheckLevelUPData(SceneUserEvent.JobLevelUp) and (not node or not node:IsShow()) then
    MyselfProxy.Instance:RecvLevelUPQueue(SceneUserEvent.JobLevelUp, oldJobLV)
    if not UIManagerProxy.Instance:HasUINode(PanelConfig.LevelUpPanel) then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LevelUpPanel,
        viewdata = {
          from = oldJobLV,
          to = newJobLV,
          lvType = SceneUserEvent.JobLevelUp
        }
      })
    else
      GameFacade.Instance:sendNotification(SceneUserEvent.Me_LevelUp, {
        from = oldJobLV,
        to = newJobLV,
        lvType = SceneUserEvent.JobLevelUp
      }, SceneUserEvent.JobLevelUp)
    end
  end
end

function LogicManager_Myself_Userdata:CheckShowJobLevel(oldValue, newValue)
  if MyselfProxy.Instance:IsHero() then
    return oldValue < newValue, oldValue, newValue
  else
    local oldConfig = Table_JobLevel[oldValue]
    local newConfig = Table_JobLevel[newValue]
    local oldJobLV = oldConfig.MasterLv and oldConfig.MasterLv > 0 and oldValue - 160 or oldConfig.ShowLevel
    local newJobLV = newConfig.MasterLv and newConfig.MasterLv > 0 and newValue - 160 or newConfig.ShowLevel
    return oldJobLV < newJobLV, oldJobLV, newJobLV
  end
end

function LogicManager_Myself_Userdata:UpdateZeny(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ZenyChange)
end

function LogicManager_Myself_Userdata:UpdateServantFavor(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ServantFavorChange)
end

function LogicManager_Myself_Userdata:UpdateNormalSkillOption(ncreature, userDataID, oldValue, newValue)
  MyselfProxy.Instance.selectAutoNormalAtk = newValue == 1
end

function LogicManager_Myself_Userdata:UpdateContribute(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ContributeChange)
end

function LogicManager_Myself_Userdata:UpdateCookLv(ncreature, userDataID, oldValue, newValue)
  FunctionFood.MyCookerLvChange(oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.CookerLvChange)
end

function LogicManager_Myself_Userdata:UpdateTasterLv(ncreature, userDataID, oldValue, newValue)
  FunctionFood.MyTasterLvChange(oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.TasterLvChange)
end

function LogicManager_Myself_Userdata:UpdateMarital(ncreature, userDataID, oldValue, newValue)
  WeddingProxy.Instance:UpdateMarital(oldValue, newValue)
end

function LogicManager_Myself_Userdata:UpdateOnStageHiding(ncreature, userDataID, oldValue, newValue)
  FunctionStage.Me():SetMyStageState(newValue)
  local needOpen = oldValue == 0 and newValue ~= 0
  if needOpen then
    local myself = Game.Myself
    myself:Client_SetAutoBattle(false)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.StageView
    })
  elseif newValue == 0 then
    EventManager.Me():PassEvent(StageEvent.CloseStageUI, self)
  end
end

function LogicManager_Myself_Userdata:UpdateTrain(ncreature, userDataID, oldValue, newValue)
end

function LogicManager_Myself_Userdata:UpdateBeingCount(ncreature, userDataID, oldValue, newValue)
  EventManager.Me():PassEvent(PetEvent.Being_CountChange)
end

function LogicManager_Myself_Userdata:UpdateServantID(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ServantID)
end

function LogicManager_Myself_Userdata:UpdateMyGuildScore(ncreature, userDataID, oldValue, newValue)
  GuildProxy.Instance:TryResetMyGuildScore(oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.GuildScoreChange)
end

function LogicManager_Myself_Userdata:UpdateBattlePassLv(ncreature, userDataID, oldValue, newValue)
  BattlePassProxy.Instance:UpdateBattlePassLv(oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.BattlePassLevelChange)
end

function LogicManager_Myself_Userdata:UpdateBattlePassExp(ncreature, userDataID, oldValue, newValue)
  BattlePassProxy.Instance:UpdateBattlePassExp(oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.BattlePassExpChange)
end

function LogicManager_Myself_Userdata:UpdateBattlePassCoin(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.BattlePassCoinChange)
end

function LogicManager_Myself_Userdata:UpdateNightmare(ncreature, userDataID, oldValue, newValue)
  local levelCfg = GameConfig.Nightmare and GameConfig.Nightmare.LevelRange
  if not levelCfg then
    return
  end
  local lastNightmareLv = Game.Myself:GetNightmareLevel()
  local nightmareLevel
  for i = 1, #levelCfg do
    if newValue >= levelCfg[i][1] and newValue <= levelCfg[i][2] then
      nightmareLevel = i
      break
    end
  end
  if not nightmareLevel and newValue > levelCfg[#levelCfg][1] then
    nightmareLevel = #levelCfg
  end
  nightmareLevel = nightmareLevel or 0
  Game.Myself:SetNightmareLevel(nightmareLevel)
  if lastNightmareLv ~= nightmareLevel then
    Game.Myself:PlayNightmareEffect(nightmareLevel)
  end
end

function LogicManager_Myself_Userdata:UpdateWeaponPetExp(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.WeaponPetExpChange)
end

function LogicManager_Myself_Userdata:UpdateSex(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.SexChange)
end

function LogicManager_Myself_Userdata:UpdateTwelvePvpCamp(ncreature, userDataID, oldValue, newValue)
  if oldValue ~= newValue then
    EventManager.Me():PassEvent(MyselfEvent.TwelvePvpCampChange)
  end
end

function LogicManager_Myself_Userdata:UpdatePlayerFashion(ncreature, userDataID, oldValue, newValue)
  NSceneUserProxy.Instance:UpdatePlayerFashion()
end

function LogicManager_Myself_Userdata:UpdateNoviceTargetPoint(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.NoviceTargetPointChange)
end

function LogicManager_Myself_Userdata:TryShowBullets(ncreature, userDataID, oldbranch, newbranch)
  if oldbranch ~= newbranch then
    local sceneUI = Game.Myself:GetSceneUI() or nil
    if sceneUI then
      if oldbranch == 111 then
        sceneUI.roleBottomUI:ShowBullets(false)
      elseif newbranch == 111 then
        sceneUI.roleBottomUI:ShowBullets(true)
      end
    end
  end
end

function LogicManager_Myself_Userdata:UpdatePortraitFrame(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(CreatureEvent.PortraitFrame_Change, ncreature)
end

function LogicManager_Myself_Userdata:UpdateLottery(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.LotteryChange)
end

function LogicManager_Myself_Userdata:UpdateKillName(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.KillNameChange)
end

function LogicManager_Myself_Userdata:UpdateServantChallengeExp(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.ServantChallengeExpChange)
end

function LogicManager_Myself_Userdata:UpdateAutoSell(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(MyselfEvent.AutoSell)
end

local Hero_SanityBuff = GameConfig.SkillCommon.Hero_SanityBuff or 136400

function LogicManager_Myself_Userdata:TryShowFrenzy(ncreature, userDataID, oldbranch, newbranch)
  local myself = Game.Myself
  local sceneUI = myself:GetSceneUI() or nil
  if sceneUI then
    local bufflayer = myself.data:GetBuffLayer(Hero_SanityBuff) or 0
    if newbranch == 601 then
      sceneUI.roleBottomUI:ShowFrenzy(true)
      myself.data:UpdateFrenzyBuff(Hero_SanityBuff, bufflayer)
    elseif oldbranch == 601 then
      if not newbranch then
        sceneUI.roleBottomUI:ShowFrenzy(true)
        myself.data:UpdateFrenzyBuff(Hero_SanityBuff, bufflayer)
      else
        sceneUI.roleBottomUI:ShowFrenzy(false)
      end
    end
  end
end

local Hero_FeatherBuff = GameConfig.SkillCommon.Hero_FeatherBuff or 137392

function LogicManager_Myself_Userdata:TryShowFeather(ncreature, userDataID, oldbranch, newbranch)
  local myself = Game.Myself
  local sceneUI = myself:GetSceneUI() or nil
  if sceneUI then
    local bufflayer = myself.data:GetBuffLayer(Hero_FeatherBuff) or 0
    if newbranch == 661 then
      sceneUI.roleBottomUI:ShowFeather(true)
      myself.data:UpdateFeatherBuff(Hero_FeatherBuff, bufflayer)
    elseif oldbranch == 661 then
      if not newbranch then
        sceneUI.roleBottomUI:ShowFeather(true)
        myself.data:UpdateFeatherBuff(Hero_FeatherBuff, bufflayer)
      else
        sceneUI.roleBottomUI:ShowFeather(false)
      end
    end
  end
end

function LogicManager_Myself_Userdata:SetMountForm(ncreature, userDataID, oldValue, newValue)
  if LogicManager_Myself_Userdata.super.SetMountForm(self, ncreature, userDataID, oldValue, newValue) then
    EventManager.Me():PassEvent(MyselfEvent.OnMountFormChange)
  end
end

local Heinrich_EnergyBuff = 137710

function LogicManager_Myself_Userdata:TryUpdateHeinrich(ncreature, userDataID, oldbranch, newbranch)
  local myself = Game.Myself
  local sceneUI = myself:GetSceneUI() or nil
  if sceneUI then
    local bufflayer = myself.data:GetBuffLayer(Heinrich_EnergyBuff) or 0
    if newbranch == 681 then
      sceneUI.roleBottomUI:ShowEnergy(true)
      myself.data:UpdateEnergyBuff(Heinrich_EnergyBuff, bufflayer)
      myself:LaunchUpdateNormalAtk()
    elseif oldbranch == 681 then
      if not newbranch then
        sceneUI.roleBottomUI:ShowEnergy(true)
        myself.data:UpdateEnergyBuff(Heinrich_EnergyBuff, bufflayer)
        myself:LaunchUpdateNormalAtk()
      else
        sceneUI.roleBottomUI:ShowEnergy(false)
        myself:ShutDownUpdateNormalAtk()
      end
    end
  end
end

function LogicManager_Myself_Userdata:UpdateAddPointNotice(ncreature, userDataID, oldValue, newValue)
  if oldValue ~= newValue then
    GameFacade.Instance:sendNotification(MyselfEvent.LevelUp)
  end
end

function LogicManager_Myself_Userdata:UpdateRecallTime()
  GameFacade.Instance:sendNotification(MyselfEvent.RecallTimeChange)
end

local Hero_SolarBuff = 139610

function LogicManager_Myself_Userdata:TryUpdateSunShine(ncreature, userDataID, oldbranch, newbranch)
  local myself = Game.Myself
  local sceneUI = myself:GetSceneUI() or nil
  if sceneUI then
    local bufflayer = myself.data:GetBuffLayer(Hero_SolarBuff) or 0
    if newbranch == 771 then
      sceneUI.roleBottomUI:ShowSolarEnergy(true)
      myself.data:UpdateSolarEnergyBuff(Hero_SolarBuff, bufflayer)
    elseif oldbranch == 771 then
      if not newbranch then
        sceneUI.roleBottomUI:ShowSolarEnergy(true)
        myself.data:UpdateSolarEnergyBuff(Hero_SolarBuff, bufflayer)
      else
        sceneUI.roleBottomUI:ShowSolarEnergy(false)
      end
    end
  end
end
