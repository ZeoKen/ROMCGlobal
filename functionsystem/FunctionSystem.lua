using("UnityEngine")
using("Ghost.Utils")
using("RO")
require("Script.Main.Import")
autoImport("oop")
autoImport("LuaConfig")
autoImport("ZhString")
autoImport("DelegateUtil")
FunctionSystem = {
  roleIdleAIMap = {},
  extraInputListener = DelegateUtil.new()
}

function FunctionSystem.InterruptMyself(ignoreSkill, ignoreMove)
  local myself = Game.Myself
  if myself == nil or myself:IsDead() then
    return false
  end
  local inputManager = InputManager.Instance
  if nil ~= inputManager and not ignoreMove then
    inputManager:Interrupt()
  end
  myself.ai:TryBreakAll(UnityTime, UnityDeltaTime, myself, ignoreSkill, ignoreMove)
  return true
end

function FunctionSystem.WeakInterruptMyself(ignoreAction)
  local myself = Game.Myself
  if myself == nil or myself:IsDead() then
    return false
  end
  local inputManager = InputManager.Instance
  if nil ~= inputManager then
    inputManager:Interrupt()
  end
  myself.ai:WeakBreak(UnityTime, UnityDeltaTime, myself, ignoreAction)
  return true
end

function FunctionSystem.InterruptMyselfAll()
  FunctionSystem.InterruptMyself()
  FunctionSystem.InterruptMyselfAI()
end

function FunctionSystem.InterruptMyselfAI()
  FunctionSystem.InterruptMyFollow()
  FunctionSystem.InterruptMyAutoBattle()
  FunctionSystem.InterruptMyMissionCommand()
end

function FunctionSystem.InterruptMyFollow()
  ServiceNUserProxy.Instance:CallFollowerUser(0)
  Game.Myself:Client_SetFollowLeader(0)
end

function FunctionSystem.InterruptMyAutoBattle()
  Game.AutoBattleManager:AutoBattleOff()
end

function FunctionSystem.InterruptMyMissionCommand()
  Game.Myself:Client_SetMissionCommand(nil)
end

function FunctionSystem.InterruptCreature(creature)
  if creature:IsDead() then
    return false
  end
  creature.ai:BreakAll(UnityTime, UnityDeltaTime, creature)
  return true
end

function FunctionSystem.SetExtraInputListener(owner, listener, interruptedCallback, immediately)
  FunctionSystem.extraInputListener:SetDelegate(owner, function()
    local inputManager = InputManager.Instance
    if nil == inputManager then
      return false
    end
    if inputManager:IsCurrentExtraInputListener(listener) then
      return false
    end
    inputManager:SetExtraInputListener(listener, immediately)
    return true
  end, interruptedCallback)
end

function FunctionSystem.ClearExtraInputListener(owner, listener)
  FunctionSystem.extraInputListener:ClearDelegate(owner, function()
    local inputManager = InputManager.Instance
    if nil == inputManager then
      return
    end
    inputManager:ClearExtraInputListener(listener)
  end)
end

autoImport("FunctionUnLockFunc")
autoImport("AutoBattle")
autoImport("AutoBattleManager")
autoImport("FunctionSceneItemCommand")
autoImport("FunctionBuff")
autoImport("FunctionCameraEffect")
autoImport("FunctionCameraAdditiveEffect")
autoImport("CameraAdditiveEffectManager")
autoImport("FunctionSkillTargetPointLauncher")
autoImport("FunctionCDCommand")
autoImport("FunctionBus")
autoImport("FunctionCheck")
autoImport("FunctionVisibleSkill")
autoImport("FunctionPlayerUI")
autoImport("FunctionSceneFilter")
autoImport("FunctionPurify")
autoImport("FunctionDungeon")
autoImport("FunctionBGMCmd")
autoImport("FunctionSkillSimulate")
autoImport("FunctionSelectCharacter")
autoImport("FunctionNewCreateRole")
autoImport("FunctionPhoto")
autoImport("FunctionScenicSpot")
autoImport("FunctionSkillEnableCheck")
autoImport("FunctionMapEnd")
autoImport("FunctionGuide")
autoImport("FunctionQuest")
autoImport("FunctionQuestDisChecker")
autoImport("FunctionGuideChecker")
autoImport("FunctionClientGuide")
autoImport("FunctionDamageNum")
autoImport("FunctionSkill")
autoImport("FunctionNetError")
autoImport("FunctionGameState")
autoImport("FunctionItemFunc")
autoImport("FunctionNpcFunc")
autoImport("FunctionPlayerTip")
autoImport("FunctionBarrage")
autoImport("FunctionChatIO")
autoImport("FunctionChatSpeech")
autoImport("FunctionAppStateMonitor")
autoImport("FunctionChangeScene")
autoImport("FunctionItemCompare")
autoImport("FunctionFirstTime")
autoImport("FuncShortCutFunc")
autoImport("FunctionMusicBox")
autoImport("FunctionPlayerPrefs")
autoImport("FunctionTransform")
autoImport("FunctionXO")
autoImport("FunctionTeam")
autoImport("FunctionVisitNpc")
autoImport("FunctionRepairSeal")
autoImport("FunctionLogin")
autoImport("FunctionPlayerHead")
autoImport("FunctionPerformanceSetting")
autoImport("FunctionTest")
autoImport("FunctionItemTrade")
autoImport("FunctionPreload")
autoImport("FunctionGuild")
autoImport("FunctionMaskWord")
autoImport("FunctionDialogEvent")
autoImport("FunctionShakeTree")
autoImport("FunctionMonster")
autoImport("FunctionTempItem")
autoImport("FunctionActivity")
autoImport("FunctionSecurity")
autoImport("FunctionDonateItem")
autoImport("FunctionFood")
autoImport("FunctionPet")
autoImport("FunctionEquipPosState")
autoImport("FunctionWedding")
autoImport("FunctionStage")
autoImport("HomeManager")
autoImport("FunctionFurnitureFunc")
autoImport("FunctionPermission")
autoImport("FunctionSaveToDCIM")
autoImport("FunctionAppForward")
autoImport("FunctionPlotCmd")
autoImport("FunctionCloudFile")
autoImport("FunctionPhotoStorage")
autoImport("FunctionUtility")
autoImport("GuildPictureManager")
autoImport("FunctionServerForbidTable")
autoImport("FunctionVideoStorage")
autoImport("FunctionQuestUIChecker")
autoImport("FunctionSniperMode")
autoImport("FunctionLocalActivity")
autoImport("FunctionShadowBricks")
autoImport("FunctionLottery")
autoImport("FunctionQTE")
autoImport("FunctionLottery")
autoImport("FunctionPvpObserver")
autoImport("DynamicSceneBottomUIPool")
autoImport("FunctionMindLocker")
autoImport("SgAIManager")
autoImport("FunctionAutoHealing")
autoImport("FunctionPhotoStand")
autoImport("FunctionPostcardTex")
autoImport("FunctionMultiProfession")
autoImport("FunctionBatteryCannon")
autoImport("FunctionTrainEscort")
autoImport("FunctionAnonymous")
autoImport("FunctionAstral")
autoImport("FunctionAbyssLake")
autoImport("FunctionAbyssDragon")
