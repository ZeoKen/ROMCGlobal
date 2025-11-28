Creature_SceneTopUI = reusableClass("Creature_SceneTopUI")
Creature_SceneTopUI.PoolSize = 50
autoImport("SceneFloatMsgQueueCtrl")
autoImport("SceneFloatMessage")
autoImport("SceneEmojiCell")
autoImport("SceneCountDownInfo")
autoImport("NSceneSpeakCell")
autoImport("NSceneTopFuncWord")
autoImport("NSceneTopFuncWord_TrainEscort")
autoImport("SceneSiegeCarInfo")
autoImport("SceneComodoBuildingProduce")
autoImport("SceneDoubleActionReady")
autoImport("SceneCursorInfo")
autoImport("SceneTopPoint")
autoImport("SceneNpcAlert")
autoImport("SceneTopGvGCooking")
autoImport("SceneCoinCell")
autoImport("SceneSummonProgress")
autoImport("SceneGetReward")
local FindCreature = function(id)
  local creature = NSceneNpcProxy.Instance:GetClientNpc(id)
  if not creature then
    creature = SceneCreatureProxy.FindCreature(id)
    creature = creature or NSceneNpcProxy.Instance:GetClientNpcByGUID(id)
  end
  return creature
end
local cellData = {}
local TIMEDISKMOVE_RUN = SceneSkill_pb.TIMEDISKMOVE_RUN
local TIMEDISKMOVE_SUSPEND = SceneSkill_pb.TIMEDISKMOVE_SUSPEND
local TIMEDISKMOVE_DEL = SceneSkill_pb.TIMEDISKMOVE_DEL

function Creature_SceneTopUI:ctor()
  Creature_SceneTopUI.super.ctor(self)
  self.followParents = {}
  self.floatMsgArray = {}
end

function Creature_SceneTopUI:Update(time, deltaTime)
  self:UpdateRoleCountDownInfo(time, deltaTime)
end

function Creature_SceneTopUI:ActiveSceneUI(maskPlayerUIType, active)
  if maskPlayerUIType == MaskPlayerUIType.Emoji then
    self.emojiActive = active
    if self.spineCell then
      self.spineCell:Active(active)
    end
  elseif maskPlayerUIType == MaskPlayerUIType.TopFrame then
    if self.topFuncCell then
      self.topFuncActive = nil
      self.topFuncCell:Active(active)
    else
      self.topFuncActive = active
    end
    self:isVisibleGvGCookingInfo(active)
  elseif maskPlayerUIType == MaskPlayerUIType.ChatSkillWord then
    self.speakActive = active
    if self.speakSkillCell then
      self.speakSkillCell:Active(active)
    end
    if self.topSingUI then
      self.topSingUI:SetActive(active)
    end
    if self.speakCell then
      if not active and self.speakCell.isStatic and not SceneFilterProxy.Instance:IsForceMaskChat() then
        return
      end
      self.speakCell:Active(active)
    end
  elseif maskPlayerUIType == MaskPlayerUIType.QuestUI then
    self.questSymbolActive = active
    self:ActiveQuestSymbolEffect(active)
  elseif maskPlayerUIType == MaskPlayerUIType.FloatRoleTop then
    self.floatMsgActive = active
  elseif maskPlayerUIType == MaskPlayerUIType.GiftSymbol and self.giftSymbol then
    self.giftSymbol:SetActive(active)
  end
end

function Creature_SceneTopUI:ActiveQuestSymbolEffect(b)
  if self.questEffectSymbol then
    if b then
      self.questEffectSymbol:ResetLocalPositionXYZ(0, 30, 0)
    else
      self.questEffectSymbol:ResetLocalPositionXYZ(0, 10000, 0)
    end
  end
end

function Creature_SceneTopUI:PlaySceneUIEffect(id, once, callback, callArgs, creature)
  local container = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if nil == container then
    errorLog("QuestSymbol not find container!!", self.creatureId)
    return
  end
  local path = ResourcePathHelper.UIEffect(id)
  if once then
    return Asset_Effect.PlayOneShotOn(path, container.transform, callback, callArgs)
  else
    return Asset_Effect.PlayOn(path, container.transform, callback, callArgs)
  end
end

function Creature_SceneTopUI._CreateQuestEffectCall(effectHandle, self)
  Game.GameObjectUtil:ChangeLayersRecursively(effectHandle.gameObject, "SceneUI")
  self:ActiveQuestSymbolEffect(self.questSymbolActive)
end

function Creature_SceneTopUI:PlayQuestEffectSymbol(symbolType)
  if not symbolType or self.symbolType == symbolType then
    return
  end
  self:RemoveQuestEffectSymbol()
  local config = QuestSymbolConfig[symbolType]
  local effectId = config and config.SceneSymbol
  if effectId then
    local effect = self:PlaySceneUIEffect(effectId, false, Creature_SceneTopUI._CreateQuestEffectCall, self)
    if effect then
      effect:RegisterWeakObserver(self)
      effect:ResetLocalPositionXYZ(0, 30, 0)
      self.questEffectSymbol = effect
      self.symbolType = symbolType
    else
      helplog("QuestEffectSymbol Play Fail")
    end
  end
end

function Creature_SceneTopUI:RemoveQuestEffectSymbol()
  if self.questEffectSymbol then
    self.questEffectSymbol:Destroy()
    self.questEffectSymbol = nil
  end
  self.symbolType = nil
end

function Creature_SceneTopUI:PlayMonsterShotFocusSymbol()
  if not self.monsterShotFocusSymbol then
    local effect = self:PlaySceneUIEffect("Eff_shot_LittleGame", false, function(effectHandle, self)
      Game.GameObjectUtil:ChangeLayersRecursively(effectHandle.gameObject, "SceneUI")
    end, self)
    if effect then
      effect:RegisterWeakObserver(self)
      effect:ResetLocalPositionXYZ(0, -40, 0)
      effect:ResetLocalScaleXYZ(100, 100, 100)
      self.monsterShotFocusSymbol = effect
    else
      helplog("MonsterShotFocusSymbol Play Fail")
    end
  end
end

function Creature_SceneTopUI:RemoveMonsterShotFocusSymbol()
  if self.monsterShotFocusSymbol then
    self.monsterShotFocusSymbol:Destroy()
    self.monsterShotFocusSymbol = nil
  end
end

function Creature_SceneTopUI._CreateSceneTopFuncWord(asset, args)
  local self = args[1]
  local text = args[2]
  local icon = args[3]
  local clickFunc = args[4]
  local clickArgs = args[5]
  self.asyncCreateTopFunc = false
  TableUtility.ArrayClear(cellData)
  cellData[1] = asset
  cellData[2] = text
  cellData[3] = icon
  cellData[4] = clickFunc
  cellData[5] = clickArgs
  cellData[6] = FindCreature(self.creatureId)
  self.topFuncCell = NSceneTopFuncWord.CreateAsArray(cellData)
  TableUtility.ArrayClear(cellData)
  if self.topFuncActive ~= nil then
    self.topFuncCell:Active(self.topFuncActive)
    self.topFuncActive = nil
  end
end

function Creature_SceneTopUI._CreateSceneTopFunc_ArgsDeleter(args)
  ReusableTable.DestroyAndClearArray(args)
end

function Creature_SceneTopUI:SetTopFuncFrame(text, icon, clickFunc, clickArgs, creature, sceneUIType)
  self:RemoveTopFuncFrame()
  sceneUIType = sceneUIType or SceneUIType.RoleTopInfo
  local follow = self:GetSceneUITopFollow(sceneUIType, creature)
  if nil == follow then
    return
  end
  if self.asyncCreateTopFunc then
    return
  end
  self.asyncCreateTopFunc = true
  local args = ReusableTable.CreateArray()
  args[1] = self
  args[2] = text
  args[3] = icon
  args[4] = clickFunc
  args[5] = clickArgs
  Game.CreatureUIManager:AsyncCreateUIAsset(self.creatureId, NSceneTopFuncWord.ResID, follow, Creature_SceneTopUI._CreateSceneTopFuncWord, args, Creature_SceneTopUI._CreateSceneTopFunc_ArgsDeleter)
end

function Creature_SceneTopUI:RemoveTopFuncFrame()
  if self.asyncCreateTopFunc then
    Game.CreatureUIManager:RemoveCreatureWaitUI(self.creatureId, NSceneTopFuncWord.ResID)
    self.asyncCreateTopFunc = nil
  end
  if self.topFuncCell then
    self.topFuncCell:Destroy()
    self.topFuncCell = nil
  end
end

function Creature_SceneTopUI._CreateSceneTopFuncWord_TrainEscort(asset, args)
  local self = args[1]
  local texts = args[2]
  local icons = args[3]
  local clickFunc = args[4]
  local clickArgs = args[5]
  self.asyncCreateTopFunc = false
  TableUtility.ArrayClear(cellData)
  cellData[1] = asset
  cellData[2] = texts
  cellData[3] = icons
  cellData[4] = clickFunc
  cellData[5] = clickArgs
  cellData[6] = FindCreature(self.creatureId)
  self.topFuncCell = NSceneTopFuncWord_TrainEscort.CreateAsArray(cellData)
  TableUtility.ArrayClear(cellData)
  if self.topFuncActive ~= nil then
    self.topFuncCell:Active(self.topFuncActive)
    self.topFuncActive = nil
  end
end

function Creature_SceneTopUI._CreateSceneTopFunc_TrainEscort_ArgsDeleter(args)
  ReusableTable.DestroyAndClearArray(args)
end

function Creature_SceneTopUI:SetTopFuncFrame_TrainEscort(texts, icons, clickFunc, clickArgs, creature, sceneUIType)
  self:RemoveTopFuncFrame_TrainEscort()
  sceneUIType = sceneUIType or SceneUIType.RoleTopInfo
  local follow = self:GetSceneUITopFollow(sceneUIType, creature)
  if nil == follow then
    return
  end
  if self.asyncCreateTopFunc then
    return
  end
  self.asyncCreateTopFunc = true
  local args = ReusableTable.CreateArray()
  args[1] = self
  args[2] = texts
  args[3] = icons
  args[4] = clickFunc
  args[5] = clickArgs
  Game.CreatureUIManager:AsyncCreateUIAsset(self.creatureId, NSceneTopFuncWord_TrainEscort.ResID, follow, Creature_SceneTopUI._CreateSceneTopFuncWord_TrainEscort, args, Creature_SceneTopUI._CreateSceneTopFunc_TrainEscort_ArgsDeleter)
end

function Creature_SceneTopUI:RemoveTopFuncFrame_TrainEscort()
  if self.asyncCreateTopFunc then
    Game.CreatureUIManager:RemoveCreatureWaitUI(self.creatureId, NSceneTopFuncWord_TrainEscort.ResID)
    self.asyncCreateTopFunc = nil
  end
  if self.topFuncCell then
    self.topFuncCell:Destroy()
    self.topFuncCell = nil
  end
end

function Creature_SceneTopUI:ShowViewPhotoStandEmoji()
  self:Speak(GameConfig.PhotoBoard.ViewText)
  if self.speakCell then
    self.speakCell:_Cancel_DelayDestroy()
  end
end

function Creature_SceneTopUI:HideViewPhotoStandEmoji()
  if self.speakCell then
    self.speakCell:SetActive(false)
  end
end

function Creature_SceneTopUI:SetRoleCountDownInfo(text, time)
  local follow = self:GetSceneUITopFollow(SceneUIType.SpeakWord, creature)
  if nil == follow then
    return nil
  end
  if self.sceneCountDownInfo == nil then
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = text
    args[3] = time
    self.sceneCountDownInfo = SceneCountDownInfo.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  else
    self.sceneCountDownInfo:ReSetInfo(text, time)
  end
  if self.countDownTick == nil then
    self.countDownTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRoleCountDownInfo, self, 111)
  end
end

function Creature_SceneTopUI:UpdateRoleCountDownInfo(time, deltatime)
  if self.sceneCountDownInfo == nil then
    return
  end
  local delta = self.sceneCountDownInfo:GetDelta()
  if delta == nil or delta < 0 then
    self:RemoveRoleCountDownInfo()
    return
  end
  self.sceneCountDownInfo:UpdateInfo()
end

function Creature_SceneTopUI:RemoveRoleCountDownInfo()
  if self.countDownTick then
    TimeTickManager.Me():ClearTick(self, 111)
  end
  self.countDownTick = nil
  if self.sceneCountDownInfo then
    self.sceneCountDownInfo:Destroy()
  end
  self.sceneCountDownInfo = nil
end

local PATH_GIFT_HELPFUNC = ResourcePathHelper.EffectUI

function Creature_SceneTopUI:SetTopGiftSymbol(symbolName, clickEvent, clickEventParam)
  if self.giftSymbol then
    return
  end
  local container = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo)
  self.giftPath = PATH_GIFT_HELPFUNC(symbolName)
  self.giftSymbol = Game.AssetManager_UI:CreateSceneUIAsset(self.giftPath, container.transform)
  self.giftSymbol:SetActive(true)
  self.giftSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-20, 20)
  self.giftSymbol.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.giftSymbol.transform.localScale = LuaGeometry.Const_V3_one
  local creatuerid = self.creatureId
  UGUIEventListener.Get(self.giftSymbol).onClick = function(go)
    if UICamera.isOverUI then
      return
    end
    if clickEvent then
      clickEvent(clickEventParam, creatuerid)
    end
  end
end

function Creature_SceneTopUI:RemoveTopGiftSymbol()
  if not Slua.IsNull(self.giftSymbol) then
    self.giftSymbol:SetActive(false)
    Game.GOLuaPoolManager:AddToSceneUIPool(self.giftPath, self.giftSymbol)
    self.giftSymbol = nil
    self.giftPath = nil
  end
end

function Creature_SceneTopUI:ActiveSceneTopMsg(active)
end

function Creature_SceneTopUI:FloatRoleTopMsgById(msgid, param)
  if msgid and Table_Sysmsg[msgid] then
    self:FloatTopMsg(Table_Sysmsg[msgid].Text, param)
  end
end

local floatParams = {}
local floatInterval = 500.0

function Creature_SceneTopUI:FloatTopMsg(msg, param)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopFloatMsg)
  if nil == follow then
    return
  end
  if not self.floatMsgQueue then
    TableUtility.ArrayClear(floatParams)
    floatParams[1] = 20
    floatParams[2] = floatInterval
    floatParams[3] = self._DoFloatTopMsg
    floatParams[4] = self
    self.floatMsgQueue = SceneFloatMsgQueueCtrl.CreateAsArray(floatParams)
  end
  local data = {}
  data[1] = follow
  data[2] = SceneFloatMessageType.Exp
  data[3] = msg
  data[4] = param
  self.floatMsgQueue:Add(data)
end

function Creature_SceneTopUI:_DoFloatTopMsg(data)
  if not self.floatMsgActive then
    return
  end
  for k, floatMsg in pairs(self.floatMsgArray) do
    if floatMsg:IsHide() then
      floatMsg:SetData(data)
      return
    end
  end
  local floatMsg = SceneFloatMessage.CreateAsArray(data)
  floatMsg:RegisterWeakObserver(self)
  table.insert(self.floatMsgArray, floatMsg)
end

function Creature_SceneTopUI:DestroyFloatMsgObj()
  for i = #self.floatMsgArray, 1, -1 do
    if self.floatMsgArray[i] then
      self.floatMsgArray[i]:Destroy()
    end
  end
end

function Creature_SceneTopUI:Speak(msg, creature, isStatic)
  if not self.speakActive and (not isStatic or SceneFilterProxy.Instance:IsForceMaskChat()) then
    return
  end
  creature = creature or FindCreature(self.creatureId)
  if not creature then
    return
  end
  local follow = self:GetSceneUITopFollow(SceneUIType.SpeakWord, creature)
  if nil == follow then
    return nil
  end
  if isStatic and creature and creature.maskDistance then
    isStatic = false
  end
  if not self.speakCell then
    TableUtility.ArrayClear(cellData)
    cellData[1] = follow
    cellData[2] = creature
    cellData[3] = false
    cellData[4] = isStatic
    self.speakCell = NSceneSpeakCell.CreateAsArray(cellData)
    TableUtility.ArrayClear(cellData)
  end
  if not creature:IsDressEnable() then
    return
  end
  self.speakCell:SetData(MsgParserProxy.Instance:DoParse(msg))
end

function Creature_SceneTopUI:SpeakSkill(msg, creature, destroyDelay)
  if not self.speakActive then
    return
  end
  creature = creature or FindCreature(self.creatureId)
  local follow = self:GetSceneUITopFollow(SceneUIType.SpeakWord, creature)
  if nil == follow then
    return nil
  end
  if not self.speakSkillCell then
    TableUtility.ArrayClear(cellData)
    cellData[1] = follow
    cellData[2] = creature
    cellData[3] = true
    self.speakSkillCell = NSceneSpeakCell.CreateAsArray(cellData)
    TableUtility.ArrayClear(cellData)
  end
  creature = creature or FindCreature(self.creatureId)
  if not creature or creature.data.id ~= self.creatureId then
    return
  end
  if not creature:IsDressEnable() then
    return
  end
  self.speakSkillCell:SetData(msg, destroyDelay)
  return self.speakSkillCell
end

function Creature_SceneTopUI:PeGiftActiveSelf(var)
  if Slua.IsNull(self.giftSymbol) or not self.giftSymbol then
    return
  end
  self.giftSymbol:SetActive(var)
end

function Creature_SceneTopUI:PlayEmojiById(emojiId)
  local emojiData = Table_Expression[emojiId]
  if emojiData then
    self:PlayEmoji(emojiData.NameEn)
  end
end

function Creature_SceneTopUI:PlayEmoji(name, depth, loopCount, creature)
  if not self.emojiActive then
    return
  end
  if name == nil then
    return
  end
  loopCount = loopCount or 2
  creature = creature or FindCreature(self.creatureId)
  if not creature or creature.data.id ~= self.creatureId then
    return
  end
  if not creature:IsDressEnable() then
    return
  end
  if creature.data.creatureType == Creature_Type.Me then
    depth = 2
  else
    depth = 1
  end
  self:PlayTopSpine(ResourcePathHelper.SceneEmoji(name), "animation", loopCount, depth, creature)
end

function Creature_SceneTopUI:SpineAnimEnd()
  self:DestroySpine()
end

function Creature_SceneTopUI:PlayTopSpine(path, animationName, loopCount, depth, creature)
  if self.spineCell then
    self:DestroySpine()
  end
  local emoji_Parent = self:GetSceneUITopFollow(SceneUIType.Emoji, creature)
  TableUtility.ArrayClear(cellData)
  cellData[1] = emoji_Parent
  cellData[2] = path
  cellData[3] = depth
  cellData[4] = animationName
  cellData[5] = loopCount
  cellData[6] = Creature_SceneTopUI.SpineAnimEnd
  cellData[7] = self
  self.spineCell = SceneEmojiCell.CreateAsArray(cellData)
  TableUtility.ArrayClear(cellData)
end

function Creature_SceneTopUI:DestroySpine()
  if self.spineCell then
    self.spineCell:Destroy()
    self.spineCell = nil
  end
end

function Creature_SceneTopUI:SetTopPointSymbol(text)
  local container = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo)
  if not container then
    return
  end
  self:RemoveTopPointSymbol()
  local args = ReusableTable.CreateArray()
  args[1] = container
  args[2] = text
  self.sceneTopPoint = SceneTopPoint.CreateAsArray(args)
  ReusableTable.DestroyAndClearArray(args)
end

function Creature_SceneTopUI:RemoveTopPointSymbol()
  if self.sceneTopPoint then
    self.sceneTopPoint:Destroy()
  end
  self.sceneTopPoint = nil
end

local topFocusUIData = {}

function Creature_SceneTopUI:createOrGetTopFocusUI()
  local topFocusUIParent = self:GetSceneUITopFollow(SceneUIType.PhotoFocus)
  if not self.topFocusUI then
    TableUtility.ArrayClear(topFocusUIData)
    topFocusUIData[1] = SceneTopFocusUI.FocusType.Creature
    topFocusUIData[2] = topFocusUIParent
    topFocusUIData[3] = self.creatureId
    self.topFocusUI = SceneTopFocusUI.CreateAsArray(topFocusUIData)
    TableUtility.ArrayClear(topFocusUIData)
  end
  return self.topFocusUI
end

function Creature_SceneTopUI:DestroyTopFocusUI()
  if self.topFocusUI then
    ReusableObject.Destroy(self.topFocusUI)
  end
  self.topFocusUI = nil
end

function Creature_SceneTopUI:createOrGetTopSingUI()
  local creature = FindCreature(self.creatureId)
  if creature then
    local topSingUIParent
    if creature:GetCreatureType() == Creature_Type.Npc then
      if creature.data:IsMonster() then
        topSingUIParent = self:GetSceneUITopFollow(SceneUIType.MonsterBottomInfo)
      else
        topSingUIParent = self:GetSceneUITopFollow(SceneUIType.NpcBottomInfo)
      end
    else
      topSingUIParent = self:GetSceneUITopFollow(SceneUIType.PlayerBottomInfo)
    end
    if not self.topSingUI then
      TableUtility.ArrayClear(topFocusUIData)
      topFocusUIData[1] = topSingUIParent
      self.topSingUI = PlayerSingViewCell.CreateAsArray(topFocusUIData)
      TableUtility.ArrayClear(topFocusUIData)
    end
    local sceneUI = creature:GetSceneUI()
    local maskSingIndex = creature:IsUIMask(MaskPlayerUIType.ChatSkillWord) or nil
    local mask = maskSingIndex ~= nil
    if self.topSingUI then
      self.topSingUI:SetActive(not mask)
    end
    return self.topSingUI
  end
end

function Creature_SceneTopUI:DestroyTopSingUI()
  if self.topSingUI then
    ReusableObject.Destroy(self.topSingUI)
  end
  self.topSingUI = nil
end

function Creature_SceneTopUI:GetSceneUITopFollow(type, creature)
  if not type then
    return
  end
  creature = creature or FindCreature(self.creatureId)
  if not creature then
    errorLog("Depand-On-Creature is Destroy!", self.creatureId)
    creature = FindCreature(self.creatureId)
    return
  end
  local follow = self.followParents[type]
  if not follow then
    local container = SceneUIManager.Instance:GetSceneUIContainer(type)
    if container then
      local name
      if creature:GetCreatureType() == Creature_Type.Npc then
        name = creature.data.staticData.NameZh
      else
        name = creature.data.name
      end
      local follow = GameObject(orginStringFormat("RoleTopFollow_%s", tostring(name)))
      local followTransform = follow.transform
      followTransform:SetParent(container.transform, false)
      follow.layer = container.layer
      creature:Client_RegisterFollow(followTransform, nil, RoleDefines_EP.Top, nil, nil, nil, true)
      self.followParents[type] = follow
    end
  else
    creature:Client_RegisterFollow(follow.transform, nil, RoleDefines_EP.Top, nil, nil, nil, true)
  end
  return self.followParents[type]
end

function Creature_SceneTopUI:UnregisterSceneUITopFollows()
  for key, follow in pairs(self.followParents) do
    if not LuaGameObject.ObjectIsNull(follow) then
      Game.RoleFollowManager:UnregisterFollow(follow.transform)
      GameObject.Destroy(follow)
    end
    self.followParents[key] = nil
  end
end

function Creature_SceneTopUI:SetSiegeCarInfo(creature, campid)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if not follow then
    return nil
  end
  if not self.sceneSiegeCarInfo then
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = campid
    self.sceneSiegeCarInfo = SceneSiegeCarInfo.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    local container = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
    if nil == container then
      error("SiegeCarInfo not find container!!")
      return
    end
  end
end

function Creature_SceneTopUI:UpdateSiegeCarPoint(speed)
  if not self.sceneSiegeCarInfo then
    return
  end
  self.sceneSiegeCarInfo:UpdateCarPoint(speed)
end

function Creature_SceneTopUI:UpdateSiegeCarPushNum(count)
  if not self.sceneSiegeCarInfo then
    return
  end
  self.sceneSiegeCarInfo:UpdatePushNum(count)
end

function Creature_SceneTopUI:RemoveSiegeCarInfo()
  if self.sceneSiegeCarInfo then
    self.sceneSiegeCarInfo:Destroy()
  end
  self.sceneSiegeCarInfo = nil
end

function Creature_SceneTopUI:FloatGoldMsg(msg, param)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopFloatMsg)
  if not follow then
    return
  end
  if not self.floatMsgQueue then
    TableUtility.ArrayClear(floatParams)
    floatParams[1] = 20
    floatParams[2] = floatInterval
    floatParams[3] = self._DoFloatTopMsg
    floatParams[4] = self
    self.floatMsgQueue = SceneFloatMsgQueueCtrl.CreateAsArray(floatParams)
  end
  local data = {}
  data[1] = follow
  data[2] = SceneFloatMessageType.TwelvePVPGold
  data[3] = msg
  self.floatMsgQueue:Add(data)
end

function Creature_SceneTopUI:UpdateComodoBuildingProduce()
  if self.sceneComodoBuildingProduce then
    self.sceneComodoBuildingProduce:Update()
  else
    creature = creature or FindCreature(self.creatureId)
    local follow = self:GetSceneUITopFollow(SceneUIType.Emoji, creature)
    if not follow then
      return
    end
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = creature and creature.data.staticData.id
    self.sceneComodoBuildingProduce = SceneComodoBuildingProduce.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function Creature_SceneTopUI:RemoveComodoBuildingProduce()
  if self.sceneComodoBuildingProduce then
    self.sceneComodoBuildingProduce:Destroy()
    self.sceneComodoBuildingProduce = nil
  end
end

function Creature_SceneTopUI:UpdateDoubleActionReady(buffId, isActive)
  self.doubleActionReadyBuffMap = self.doubleActionReadyBuffMap or {}
  self.doubleActionReadyBuffMap[buffId] = isActive or nil
  self:_UpdateDoubleActionReady()
end

function Creature_SceneTopUI:_UpdateDoubleActionReady()
  local buffId = next(self.doubleActionReadyBuffMap)
  if self.sceneDoubleActionReady then
    if buffId then
      self.sceneDoubleActionReady:Update(buffId)
    else
      self:RemoveDoubleActionReady()
    end
  elseif buffId and self.creatureId ~= Game.Myself.data.id then
    creature = creature or FindCreature(self.creatureId)
    local follow = self:GetSceneUITopFollow(SceneUIType.Emoji, self.creature)
    if not follow then
      return
    end
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = self.creatureId
    args[3] = buffId
    self.sceneDoubleActionReady = SceneDoubleActionReady.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function Creature_SceneTopUI:RemoveDoubleActionReady()
  if self.sceneDoubleActionReady then
    self.sceneDoubleActionReady:Destroy()
    self.sceneDoubleActionReady = nil
  end
  self.doubleActionReadyBuffMap = nil
end

function Creature_SceneTopUI:SetCursorInfo(creature)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if not follow then
    return nil
  end
  if not self.sceneCursorInfo and not self.cursorValue then
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[3] = self
    self.sceneCursorInfo = SceneCursorInfo.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    local container = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
    if nil == container then
      error("Cursorinfo not find container!!")
      return
    end
  end
end

function Creature_SceneTopUI:UpdateCursorInfo(value, creature)
  if not self.sceneCursorInfo then
    self:SetCursorInfo(creature)
    self.cursorValue = value
  end
  if self.sceneCursorInfo then
    self.sceneCursorInfo:UpdateValue(value)
  end
end

function Creature_SceneTopUI:PlaySceneEffect(path, once, callback, callArgs, creature)
  local container = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if nil == container then
    error("QuestSymbol not find container!!")
    return
  end
  if once then
    return Asset_Effect.PlayOneShotOn(path, container.transform, callback, callArgs)
  else
    return Asset_Effect.PlayOn(path, container.transform, callback, callArgs)
  end
end

function Creature_SceneTopUI:RemoveCursorInfo()
  if self.sceneCursorInfo then
    self.sceneCursorInfo:Destroy()
  end
  self.sceneCursorInfo = nil
  self.cursorValue = nil
end

function Creature_SceneTopUI:SetAlertInfo(creature)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if not follow then
    return nil
  end
  if not self.sceneNpcAlert then
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[3] = self
    self.sceneNpcAlert = SceneNpcAlert.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function Creature_SceneTopUI:UpdateLowValue(value, creature)
  if not self.sceneNpcAlert then
    self:SetAlertInfo(creature)
  end
  if self.sceneNpcAlert then
    self.sceneNpcAlert:UpdateLowValue(value)
  end
end

function Creature_SceneTopUI:UpdateHighValue(value, creature)
  if not self.sceneNpcAlert then
    self:SetAlertInfo(creature)
  end
  if self.sceneNpcAlert then
    self.sceneNpcAlert:UpdateHighValue(value)
  end
end

function Creature_SceneTopUI:RemoveSceneNpcAlert()
  if self.sceneNpcAlert then
    self.sceneNpcAlert:Destroy()
    self.sceneNpcAlert = nil
  end
end

function Creature_SceneTopUI:SetGvGCookingInfo(creature)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if not follow then
    return nil
  end
  if not self.sceneNpcGvGCooking then
    self.sceneNpcGvGCooking = SceneTopGvGCooking.CreateAsArray(follow)
  end
end

function Creature_SceneTopUI:UpdateGvGCookingInfo(creature)
  if not self.sceneNpcGvGCooking then
    self:SetGvGCookingInfo(creature)
  end
  if self.sceneNpcGvGCooking then
    self.sceneNpcGvGCooking:updateInfo()
  end
end

function Creature_SceneTopUI:isVisibleGvGCookingInfo(value)
  if self.sceneNpcGvGCooking ~= nil then
    self.sceneNpcGvGCooking:isVisible(value)
  end
end

function Creature_SceneTopUI:RemoveGvGCookingInfo()
  if self.sceneNpcGvGCooking then
    self.sceneNpcGvGCooking:Destroy()
    self.sceneNpcGvGCooking = nil
  end
end

function Creature_SceneTopUI:SetCreature(creature)
  self.creatureId = creature.data.id
end

function Creature_SceneTopUI:UpdateEBFCoinSceneUI(coin)
  if not self.sceneCoin then
    local follow = self:GetSceneUITopFollow(SceneUIType.EBFCoin)
    if not follow then
      return
    end
    self.sceneCoin = SceneCoinCell.CreateAsArray(follow)
  end
  self.sceneCoin:SetData(coin)
end

function Creature_SceneTopUI:RemoveEBFCoinSceneUI()
  if self.sceneCoin then
    self.sceneCoin:Destroy()
    self.sceneCoin = nil
  end
end

function Creature_SceneTopUI:ShowEBFCoinSceneUI()
  if self.sceneCoin then
    self.sceneCoin:SetActive(true)
  end
end

function Creature_SceneTopUI:HideEBFCoinSceneUI()
  if self.sceneCoin then
    self.sceneCoin:SetActive(false)
  end
end

function Creature_SceneTopUI:SetSummonProgress(creature, area, mapstepId)
  local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopEffect, creature)
  if not follow then
    return nil
  end
  if not self.sceneSummonProgress then
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = self.creatureId
    args[3] = mapstepId
    args[4] = area
    self.sceneSummonProgress = SceneSummonProgress.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function Creature_SceneTopUI:UpdateSummonProgress(progress, npcID)
  if not self.sceneSummonProgress then
    return
  end
  self.sceneSummonProgress:SetData(progress, npcID)
end

function Creature_SceneTopUI:RemoveSummonProgress()
  if self.sceneSummonProgress then
    self.sceneSummonProgress:Destroy()
  end
  self.sceneSummonProgress = nil
end

local accessFunc = function(self)
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  Game.Myself:Client_AccessTarget(FindCreature(self.creatureId))
end

function Creature_SceneTopUI:CreateGetReward()
  if not self.sceneGetReward then
    local follow = self:GetSceneUITopFollow(SceneUIType.RoleTopInfo)
    if not follow then
      return
    end
    local args = ReusableTable.CreateArray()
    args[1] = follow
    args[2] = accessFunc
    args[3] = self
    self.sceneGetReward = SceneGetReward.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function Creature_SceneTopUI:UpdateGetReward(icon, rewardCount)
  if not self.sceneGetReward then
    self:CreateGetReward()
  end
  self.sceneGetReward:SetData(icon, rewardCount)
end

function Creature_SceneTopUI:RemoveGetReward()
  if self.sceneGetReward then
    self.sceneGetReward:Destroy()
    self.sceneGetReward = nil
  end
end

function Creature_SceneTopUI:DoConstruct(asArray, creature)
  self:SetCreature(creature)
  self.emojiActive = true
  self.speakActive = true
  self.questSymbolActive = true
  self.floatMsgActive = true
  if creature:GetCreatureType() == Creature_Type.Npc and creature.data:IsNpc() then
    local npcData = creature.data.staticData
    if npcData.FnDesc and npcData.FnDesc ~= "" and npcData.FnIcon and npcData.FnIcon ~= "" then
      self:SetTopFuncFrame(npcData.FnDesc, npcData.FnIcon, accessFunc, self, creature)
    end
  end
end

function Creature_SceneTopUI:DoDeconstruct(asArray)
  self.topFuncActive = nil
  if self.speakCell then
    self.speakCell:Destroy()
    self.speakCell = nil
  end
  if self.speakSkillCell then
    self.speakSkillCell:Destroy()
    self.speakSkillCell = nil
  end
  if self.floatMsgQueue then
    self.floatMsgQueue:Destroy()
    self.floatMsgQueue = nil
  end
  self:DestroySpine()
  self:DestroyTopSingUI()
  self:DestroyTopFocusUI()
  self:DestroyFloatMsgObj()
  self:RemoveTopFuncFrame()
  self:RemoveTopGiftSymbol()
  self:RemoveQuestEffectSymbol()
  self:RemoveRoleCountDownInfo()
  self:RemoveSiegeCarInfo()
  self:RemoveComodoBuildingProduce()
  self:RemoveDoubleActionReady()
  self:RemoveCursorInfo()
  self:RemoveGvGCookingInfo()
  self:RemoveEBFCoinSceneUI()
  self:RemoveSummonProgress()
  self:RemoveGetReward()
  self:UnregisterSceneUITopFollows()
end

function Creature_SceneTopUI:ObserverDestroyed(obj)
  local questEffectSymbol = self.questEffectSymbol
  if obj == questEffectSymbol then
    self.questEffectSymbol = nil
    self.symbolType = nil
  end
  for i = #self.floatMsgArray, 1, -1 do
    if self.floatMsgArray[i] == obj then
      table.remove(self.floatMsgArray, i)
      break
    end
  end
end
