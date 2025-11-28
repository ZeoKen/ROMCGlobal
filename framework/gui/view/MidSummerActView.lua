autoImport("MidSummerHeartCell")
autoImport("MidSummerRelationshipCell")
autoImport("MidSummerGiftCell")
MidSummerActView = class("MidSummerActView", BaseView)
MidSummerActView.ViewType = UIViewType.NormalLayer
local texObjStaticNameMap = {
  Moon = "Midsummer_bg_moon"
}
local picIns, actIns, tickManager
local dialogTickId, giftLongPressTickId, npcPlayshowTickId = 289, 623, 384
local dialogPeriod, npcFirstPlayshowInterval, npcNormalPlayshowInterval = 3000, 5000, 15000

function MidSummerActView:Init()
  if not picIns then
    picIns = PictureManager.Instance
    actIns = MidSummerActProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddEvts()
end

function MidSummerActView:InitData()
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  local viewData = self.viewdata.viewdata
  if viewData and viewData.id then
    self.id = viewData.id
    self.cfg = GameConfig.FavoriteActivity[self.id]
    self.sData = actIns:GetStaticData(self.id)
  else
    LogUtility.Error("Wrong gActivity id while initializing MidSummerActView!")
    return
  end
  self.heartData = {}
  for i = 1, self.cfg.HeartMax do
    self.heartData[i] = true
  end
  self.giftItemIds = {}
  for id, _ in pairs(self.cfg.GiftItem) do
    TableUtility.ArrayPushBack(self.giftItemIds, id)
  end
  table.sort(self.giftItemIds)
end

function MidSummerActView:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.title = self:FindComponent("Title", UILabel)
  self.leftTween = self:FindComponent("Left", TweenPosition)
  self.rightTween = self:FindComponent("Right", TweenPosition)
  self.heartGrid = self:FindComponent("HeartGrid", UIGrid)
  self.favorabilitySlider = self:FindComponent("Favorability", UISlider)
  self.favorabilityLabel = self:FindComponent("FavorabilityLabel", UILabel)
  self.npcNameLabel = self:FindComponent("NpcName", UILabel)
  self.periodLabel = self:FindComponent("PeriodLabel", UILabel)
  self.effContainer = self:FindGO("EffContainer")
  self.giftBtnSp = self:FindComponent("GiftBtn", UISprite)
  self.desireGrid = self:FindComponent("DesireGrid", UIGrid)
  self.relationshipGrid = self:FindComponent("RelationshipGrid", UIGrid)
  self.giftCtrlTween = self:FindComponent("GiftCtrl", TweenPosition)
  self.giftGrid = self:FindComponent("GiftGrid", UIGrid)
  self.dialogCtrl = self:FindGO("DialogCtrl")
  self.dialogCtrlTweenPos = self.dialogCtrl:GetComponent(TweenPosition)
  self.dialogCtrlTweenScale = self.dialogCtrl:GetComponent(TweenScale)
  self.dialogCtrlTweenAlpha = self.dialogCtrl:GetComponent(TweenAlpha)
  self.dialogBg = self.dialogCtrl:GetComponent(UISprite)
  self.dialogLine = self:FindGO("DialogLine")
  self.dialogLabel = self:FindComponent("DialogLabel", UILabel)
  self.dialogExtraLabelGo = self:FindGO("DialogExtraLabel")
  self.emojiContainer = self:FindGO("EmojiContainer")
  self.desireRedTip = self:FindGO("DesireRedTip")
  self.relationshipRedTip = self:FindGO("RelationshipRedTip")
  self.collider = self:FindGO("Collider")
end

function MidSummerActView:InitView()
  self.title.text = self.cfg.activityName or ""
  self.heartCtrl = ListCtrl.new(self.heartGrid, MidSummerHeartCell, "MidSummerHeartCell")
  self.desireCtrl = ListCtrl.new(self.desireGrid, MidSummerDesireCell, "MidSummerDesireCell")
  self.desireCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickDesireCell, self)
  self.relationshipCtrl = ListCtrl.new(self.relationshipGrid, MidSummerRelationshipCell, "MidSummerRelationshipCell")
  self.relationshipCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickDesireCell, self)
  self.periodLabel.text = actIns:GetActivityTimeText(self.id)
  self.giftListCtrl = ListCtrl.new(self.giftGrid, MidSummerGiftCell, "MidSummerGiftCell")
  self.giftListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickGift, self)
  self.giftListCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressGift, self)
  self:InitSceneModel()
end

function MidSummerActView:InitSceneModel()
  self.objSceneModelRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIModel("MidSummerActScene"))
  GameObject.DontDestroyOnLoad(self.objSceneModelRoot)
  self.objSceneModelRoot.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.objModelParent = self:FindGO("RolePos", self.objSceneModelRoot)
  self.modelTween = self.objModelParent:GetComponent(TweenTransform)
  self.tsfCameraPos = self:FindGO("CameraPos", self.objSceneModelRoot).transform
  UIManagerProxy.Instance:RefitSceneModel(self.tsfCameraPos, self:FindGO("Reloading_BG", self.objSceneModelRoot).transform)
end

function MidSummerActView:AddEvts()
  self:AddClickEvent(self.giftBtnSp.gameObject, function()
    self:SwitchGiftMode(not self.isGiftMode)
  end)
  self:AddButtonEvent("ReturnBtn", function()
    self:SwitchGiftMode(false)
  end)
  self:AddButtonEvent("DesireToggle", function()
    self:OnClickDesireToggle()
  end)
  self:AddButtonEvent("RelationshipToggle", function()
    self:OnClickRelationshipToggle()
  end)
  self:AddButtonEvent("GiftHelpBtn", function()
    self:OpenHelpView(35077)
  end)
  self:AddButtonEvent("OneClickBtn", function()
    actIns:GiveAllGift()
  end)
  self:AddButtonEvent("ModelClickZone", function()
    self:OnClickModel()
  end)
  self:AddListenEvt(ServiceEvent.ItemFavoriteInteractItemCmd, self.OnRecvInteract)
  self:AddListenEvt(ServiceEvent.ItemFavoriteQueryItemCmd, self.OnRecvQuery)
  self:AddListenEvt(ServiceEvent.ItemFavoriteGiveItemCmd, self.OnRecvGift)
  self:AddListenEvt(ServiceEvent.ItemFavoriteRewardItemCmd, self.OnRecvReward)
  self:AddListenEvt(ServiceEvent.ItemFavoriteDesireConditionItemCmd, self.OnRecvDesireCond)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.OnRecvGlobalAct)
end

function MidSummerActView:OnEnter()
  MidSummerActView.super.OnEnter(self)
  actIns:SetShowingActivity(self.id)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  self:OnClickDesireToggle()
  self:UpdateData()
  self:PlayUIEffect(EffectMap.UI.DressingModelFeather, self.effContainer, nil, function(obj, args, assetEffect)
    assetEffect:ResetLocalScaleXYZ(0.7, 0.7, 0.7)
  end)
  self:SwitchCameraToModel()
end

function MidSummerActView:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  self:ResetCameraToDefault()
  self:DestroyModel()
  self:DestroyEmoji()
  tickManager:ClearTick(self)
  actIns:ClearShowingActivity()
  LeanTween.cancel(self.favorabilitySlider.gameObject)
  if self.objSceneModelRoot then
    LuaGameObject.DestroyObject(self.objSceneModelRoot)
    self.objSceneModelRoot = nil
  end
  MidSummerActView.super.OnExit(self)
end

function MidSummerActView:OnRecvDesireCond()
  self:UpdateData()
end

function MidSummerActView:OnRecvGift()
  self:UpdateData()
end

function MidSummerActView:OnRecvInteract()
  self:UpdateData()
end

function MidSummerActView:OnRecvQuery()
  self:UpdateData()
end

function MidSummerActView:OnRecvReward()
  self:UpdateData()
end

function MidSummerActView:OnItemUpdate()
  self:UpdateGift()
end

function MidSummerActView:OnRecvGlobalAct()
  if not actIns:CheckActivityValid(self.id) then
    self:CloseSelf()
  end
end

function MidSummerActView:OnClickModel()
  actIns.npcEncounter = true
  local exClickTime = self.clickModelTime or 0
  self.clickModelTime = ServerTime.CurClientTime()
  if self.clickModelTime - exClickTime < self.cfg.TapCD * 1000 then
    MsgManager.ShowMsgByIDTable(49)
  else
    actIns:Interact()
    self:PlayRelationDialog()
  end
end

function MidSummerActView:OnClickDesireToggle()
  self.desireGrid.gameObject:SetActive(true)
  self.relationshipGrid.gameObject:SetActive(false)
  self:UpdateDesire()
  self.desireCtrl:ResetPosition()
end

function MidSummerActView:OnClickRelationshipToggle()
  self.desireGrid.gameObject:SetActive(false)
  self.relationshipGrid.gameObject:SetActive(true)
  self:UpdateRelationship()
  self.relationshipCtrl:ResetPosition()
end

function MidSummerActView:OnClickGift(data)
  actIns:GiveOneGift(data)
end

function MidSummerActView:OnClickDesireCell(cell)
  actIns:GetReward(cell.data.id)
end

function MidSummerActView:OnLongPressGift(param)
  local state, data = param[1], param[2]
  if state then
    tickManager:CreateTick(0, 100, function(self)
      self:OnClickGift(data)
    end, self, giftLongPressTickId)
  else
    tickManager:ClearTick(self, giftLongPressTickId)
  end
end

function MidSummerActView:UpdateFavorability()
  local dData = actIns:GetDesireData(self.id)
  local level = dData.level or 0
  for i = 1, #self.heartData do
    self.heartData[i] = i <= level
  end
  self.heartCtrl:ResetDatas(self.heartData)
  local isFull = level >= self.cfg.HeartMax
  self.favorabilityLabel.gameObject:SetActive(not isFull)
  if isFull then
    self.favorabilitySlider.value = 1
  else
    local exp, max = dData.exp or 0, self.cfg.HeartNum
    self.favorabilityLabel.text = string.format("%s/%s", exp, max)
    LeanTween.sliderNGUI(self.favorabilitySlider, self.favorabilitySlider.value, exp / max, 0.3)
  end
end

function MidSummerActView:UpdateData()
  self:UpdateFavorability()
  self:TryUpdateNpc()
  self:UpdateDesire()
  self:UpdateRelationship()
  self:UpdateGift()
  self:TryPlayEncounterDialog()
end

function MidSummerActView:UpdateDesire()
  local data, hasComplete = actIns:GetDesireStaticDatas(self.id)
  self.desireCtrl:ResetDatas(data, nil, false)
  self.desireRedTip:SetActive(hasComplete)
end

function MidSummerActView:UpdateRelationship()
  local data, hasComplete = actIns:GetRelationshipStaticDatas(self.id)
  self.relationshipCtrl:ResetDatas(data, nil, false)
  self.relationshipRedTip:SetActive(hasComplete)
end

function MidSummerActView:UpdateGift()
  local num = 0
  for _, id in pairs(self.giftItemIds) do
    num = num + BagProxy.Instance:GetItemNumByStaticID(id, GameConfig.PackageMaterialCheck.favorite_pack)
  end
  self.giftListCtrl:ResetDatas(self.giftItemIds)
end

function MidSummerActView:TryUpdateNpc()
  local dData = actIns:GetDesireData()
  if not next(dData) then
    return
  end
  local exNpc = self.npcId
  self.relationLevel, self.relationCfg = actIns:GetCurrentRelationLevelAndConfig()
  if not self.relationCfg then
    LogUtility.Warning("There must be sth wrong with relation!!!")
    return
  end
  self.npcId, self.relationNpcDialogs = self.relationCfg[2], self.relationCfg[3]
  if self.npcId ~= exNpc then
    if exNpc then
      self.collider:SetActive(true)
      self:PlayUIEffect(EffectMap.UI.MidSummerAct_Change, self.effContainer, true)
      tickManager:CreateOnceDelayTick(3000, self._UpdateNpc, self)
    else
      self:_UpdateNpc()
    end
  end
end

function MidSummerActView:_UpdateNpc()
  self.npcNameLabel.text = Table_Npc[self.npcId].NameZh
  self:DestroyModel()
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  self.role = Asset_Role_UI.Create(parts)
  self.role:SetParent(self.objModelParent.transform, false)
  self.role:SetLayer(Game.ELayer.Outline)
  self.role:SetPosition(LuaGeometry.Const_V3_zero)
  self.role:SetEulerAngleY(180)
  self.role:SetScale(1)
  self.role:SetEpNodesDisplay(true)
  self.role:RegisterWeakObserver(self)
  Asset_RoleUtility.SetNpcRoleParts(self.npcId, parts)
  self.role:Redress(parts, true)
  Asset_Role.DestroyPartArray(parts)
  tickManager:CreateTick(npcFirstPlayshowInterval, npcNormalPlayshowInterval, self.PlayPlayshow, self, npcPlayshowTickId)
  self:ShowDialog()
  tickManager:CreateOnceDelayTick(1000, function(self)
    self.collider:SetActive(false)
  end, self)
end

function MidSummerActView:DestroyModel()
  if self.role and self.role:Alive() then
    self.role:SetEpNodesDisplay(false)
    self.role:Destroy()
  end
  self.role = nil
  tickManager:ClearTick(self, npcPlayshowTickId)
end

function MidSummerActView:ObserverDestroyed(obj)
  if obj == self.role then
    self.role:UnregisterWeakObserver(self)
    self.role = nil
  end
end

function MidSummerActView:TryPlayEncounterDialog()
  local dData = actIns:GetDesireData()
  if not next(dData) then
    return
  end
  if dData.level > 0 or 0 < dData.exp then
    return
  end
  if actIns.npcEncounter then
    return
  end
  self:ShowDialog(self.cfg.TapTips)
end

function MidSummerActView:PlayEmoji(emojiName)
  self:DestroyEmoji()
  local resID = ResourcePathHelper.Emoji(emojiName)
  if resID == self.resID and not Slua.IsNull(self.emoji) then
    return
  end
  self.resID = resID
  self.emoji = Game.AssetManager_UI:CreateSceneUIAsset(resID, self.emojiContainer)
  if not self.emoji then
    LogUtility.WarningFormat("CANNOT FIND EMOJI:{0}", emojiName)
    return
  end
  UIUtil.ChangeLayer(self.emoji, self.gameObject.layer)
  self.emoji.gameObject:SetActive(true)
  pcall(function()
    local anim = self.emoji:GetComponent(SkeletonAnimation)
    anim.AnimationName = "ui_animation"
    anim:Reset()
    anim.loop = true
    SpineLuaHelper.PlayAnim(anim, "ui_animation", nil)
  end)
end

function MidSummerActView:DestroyEmoji()
  if self.resID and not Slua.IsNull(self.emoji) then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resID, self.emoji)
  end
  self.resID = nil
  self.emoji = nil
end

local restoreAnimCallback = function(id, self)
  self:_PlayCharacterAction(Asset_Role.ActionName.Idle)
end

function MidSummerActView:PlayCharacterAction(actionName, callback, callbackArg)
  self:_PlayCharacterAction(actionName, callback or restoreAnimCallback, callbackArg or self)
end

function MidSummerActView:_PlayCharacterAction(actionName, callback, callbackArg)
  if not self.role or not actionName then
    return
  end
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  params[7] = callback
  params[8] = callbackArg
  self.role:PlayActionRaw(params)
end

function MidSummerActView:PlayPlayshow()
  if not self.role then
    return
  end
  if self.role.actionRaw ~= Asset_Role.ActionName.Idle then
    return
  end
  self:PlayCharacterAction(Asset_Role.ActionName.PlayShow)
end

function MidSummerActView:PlayRelationDialog()
  if not self.relationNpcDialogs or not next(self.relationNpcDialogs) then
    return
  end
  local rnd = math.clamp(Game.Myself.data:GetRandom() % #self.relationNpcDialogs + 1, 1, #self.relationNpcDialogs)
  local dialog = DialogUtil.GetDialogData(self.relationNpcDialogs[rnd])
  if dialog then
    self:ShowDialog(dialog.Text, true)
    local emojiId = dialog.Emoji
    if emojiId then
      self:PlayEmoji(Table_Expression[emojiId] and Table_Expression[emojiId].NameEn)
    end
    local actionId = dialog.Action and dialog.Action.actionid
    if actionId then
      self:PlayCharacterAction(Table_ActionAnime[actionId] and Table_ActionAnime[actionId].Name)
    end
  end
end

function MidSummerActView:SwitchGiftMode(isGiftMode)
  local exMode = self.isGiftMode
  self.isGiftMode = isGiftMode and true or false
  if self.isGiftMode ~= exMode then
    self.tweens = self.tweens or {
      self.leftTween,
      self.rightTween,
      self.giftCtrlTween,
      self.modelTween
    }
    for _, t in pairs(self.tweens) do
      self:PlayTween(t, self.isGiftMode)
    end
  end
end

function MidSummerActView:SwitchCameraToModel()
  if self.ltInitCamera then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      if not self.initRetryCount then
        self.initRetryCount = 0
      end
      self.initRetryCount = self.initRetryCount + 1
      if self.initRetryCount > 9 then
        LogUtility.Error("无法找到CameraController，重试10次失败，无法打开活动页面！")
        self:CloseSelf()
        return
      end
      self.ltInitCamera = tickManager:CreateOnceDelayTick(self.initRetryCount * 100, function(self)
        self.ltInitCamera = nil
        self:SwitchCameraToModel()
      end, self, 98989)
      return
    end
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  if not self.cameraController then
    LogUtility.Error("在主摄像机上寻找CameraController失败。")
    self:CloseSelf()
    return
  end
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  self.cameraController.applyCurrentInfoPause = true
  self.cameraController.enabled = false
  self.vecCameraPosRecord:Set(LuaGameObject.GetPosition(self.tsfCameraWorld))
  self.quaCameraRotRecord:Set(LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.tsfCameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.tsfCameraPos))
  self.cameraWorld.fieldOfView = 20
end

function MidSummerActView:ResetCameraToDefault()
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.cameraWorld and not LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.tsfCameraWorld.position = self.vecCameraPosRecord
    self.tsfCameraWorld.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self:CameraReset()
    end
  end
end

function MidSummerActView:PlayTween(tween, isForward, onFinished)
  if isForward == nil then
    isForward = true
  end
  local actionName = isForward and "PlayForward" or "PlayReverse"
  tween.enabled = true
  tween[actionName](tween)
  tween:ResetToBeginning()
  tween[actionName](tween)
  tween:SetOnFinished(onFinished)
end

function MidSummerActView:ShowDialog(text, autoHide)
  tickManager:ClearTick(self, dialogTickId)
  if StringUtil.IsEmpty(text) then
    self.dialogCtrl:SetActive(false)
    return
  end
  self.dialogCtrl:SetActive(true)
  self.dialogLabel.text = text
  local canGain = actIns:CheckCanGainFavorability(self.id)
  self.dialogLine:SetActive(not canGain)
  self.dialogExtraLabelGo:SetActive(not canGain)
  tickManager:CreateOnceDelayTick(33, function(self)
    local h = self.dialogLabel.height + 24
    if not canGain then
      h = h + 33
    end
    self.dialogBg.height = h
    self.dialogLabel.transform.localPosition = LuaGeometry.GetTempVector3(0, h - 15)
  end, self)
  if autoHide then
    tickManager:CreateOnceDelayTick(dialogPeriod, function(self)
      self:HideDialog()
    end, self, dialogTickId)
  end
  self:PlayTween(self.dialogCtrlTweenPos)
  self:PlayTween(self.dialogCtrlTweenAlpha)
  self:PlayTween(self.dialogCtrlTweenScale)
end

function MidSummerActView:HideDialog()
  self:PlayTween(self.dialogCtrlTweenAlpha, false)
  self:DestroyEmoji()
end

function MidSummerActView:OpenHelpView(id)
  id = id or EnvChannel.IsReleaseBranch() and 35076 or 35078
  local linkInfos = ActivityEventProxy.Instance:GetTapTapLinkInfo()
  local url
  if id ~= nil and linkInfos ~= nil then
    local types = GameConfig.TapTapLink[id]
    if types ~= nil then
      for _, info in pairs(linkInfos) do
        for _, v in pairs(types) do
          if info.activitytype == v then
            url = info.url
          end
        end
      end
    end
  end
  if not StringUtil.IsEmpty(url) then
    Application.OpenURL(url)
  else
    local data = Table_Help[id]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
    end
  end
end
