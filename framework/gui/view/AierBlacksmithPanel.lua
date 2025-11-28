autoImport("AierBlacksmithQuestCell")
autoImport("AierBlacksmithSubQuestCell")
autoImport("AierBlacksmithHelpCell")
autoImport("AierBlacksmithMonsterGridCell")
autoImport("AierBlacksmithLevelRewardCell")
autoImport("AierBlacksmithDetailSubTabCell")
autoImport("AierBlacksmithWantedCell")
autoImport("AierBlacksmithRewardListPopUp")
AierBlacksmithPanel = class("AierBlacksmithPanel", ContainerView)
AierBlacksmithPanel.ViewType = UIViewType.NormalLayer
local _Filter = 22

function AierBlacksmithPanel:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self:RefreshNpcData()
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self:InitView()
  self:AddEvents()
end

function AierBlacksmithPanel:RefreshNpcData()
  local npcid = AierBlacksmithProxy.Instance:Query_MainNpcID()
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcid)
  if npcs and 0 < #npcs then
    self.npcdata = npcs[1]
  else
    self.npcdata = nil
  end
end

function AierBlacksmithPanel:InitView()
  self.mainPage = self:FindGO("MainPage")
  local levelReward = self:FindGO("left", self.mainPage)
  self.levellevelLb = self:FindComponent("UserTitle", UILabel, levelReward)
  self.levelRewardListSv = self:FindComponent("rewardSv", UIScrollView, levelReward)
  self.levelRewardListGrid = self:FindComponent("rewardGrid", UIGrid, levelReward)
  self.levelRewardListCtl = UIGridListCtrl.new(self.levelRewardListGrid, AierBlacksmithLevelRewardCell, "AierBlacksmithLevelRewardCell")
  self.levelRewardListCtl:AddEventListener(MouseEvent.MouseClick, self._LevelRewardInfo_OnClickRewardItem, self)
  self.bottom = self:FindGO("bottom", self.mainPage)
  self.dLv = self:FindComponent("lvLb", UILabel, self.bottom)
  self.donateProgress = self:FindComponent("progressBar", UISlider, self.bottom)
  self.donateMatIcon = self:FindComponent("resicon", UISprite, self.bottom)
  local itemIcon = Table_Item[AierBlacksmithProxy.Instance.configData.UpgradeCostItem]
  itemIcon = itemIcon and itemIcon.Icon or ""
  IconManager:SetItemIcon(itemIcon, self.donateMatIcon)
  self.donateProgressText = self:FindComponent("resLb", UILabel, self.bottom)
  self.donateProgressEffect = self:FindGO("donateProgressEffect")
  self.upgradeBtn = self:FindGO("UpgradeButton")
  self:AddClickEvent(self.upgradeBtn, function()
    self:DoUpgradeBlacksmith()
  end)
  self:RegisterRedTipCheck(GameConfig.Smithy.UpgradeRedTip, self.upgradeBtn, 39, {-10, -3})
  self.lvMaxed = self:FindGO("lvMaxed")
  self.reward = self:FindGO("Reward")
  self.rewardPopupContainer = self:FindGO("PopupContainer", self.reward)
  local rewardBtn = self:FindGO("RewardButton")
  self:AddClickEvent(rewardBtn, function()
    self:ShowRewardPopup()
  end)
  self.rewardIcon = self:FindComponent("icon", UISprite, self.reward)
  self.toDetailBtn = self:FindGO("toDetailBtn")
  self.toEquipBtn = self:FindGO("toEquipBtn")
  self:AddClickEvent(self.toDetailBtn, function()
    self:ToDetailPage()
  end)
  self:AddClickEvent(self.toEquipBtn, function()
    self:GotoQuenchCombineView()
  end)
  self.detailPage = self:FindGO("DetailPage")
  local detailBackBtn = self:FindGO("CloseButton", self.detailPage)
  self:AddClickEvent(detailBackBtn, function()
    self:ToMainPage()
  end)
  self.detailSubTitleLb = self:FindComponent("UserTitle", UILabel, self.detailPage)
  self.subTabGrid = self:FindGO("activityGrid", self.detailPage)
  self.uiGridOfSubTabs = self.subTabGrid:GetComponent(UIGrid)
  if self.listControllerOfSubTabs == nil then
    self.listControllerOfSubTabs = UIGridListCtrl.new(self.uiGridOfSubTabs, AierBlacksmithDetailSubTabCell, "AierBlacksmithDetailSubTabCell")
  end
  self.PAGE_todayquest = self:FindGO("_todayquest", self.detailPage)
  local linkBtn = self:FindGO("LinkBtn", self.PAGE_todayquest)
  self:AddClickEvent(linkBtn, function()
    self:todayquest_GotoQuestView()
  end)
  self.todayquest_questListSv = self:FindComponent("commonSv", UIScrollView, self.PAGE_todayquest)
  self.todayquest_questGrid = self:FindGO("questGrid", self.PAGE_todayquest):GetComponent(UIGrid)
  self.todayquest_questListCtl = UIGridListCtrl.new(self.todayquest_questGrid, AierBlacksmithQuestCell, "AierBlacksmithQuestCell")
  self.todayquest_questListCtl:AddEventListener(MouseEvent.MouseClick, self.todayquest_HandleClickQuestBtn, self)
  self.todayquest_helperBar = self:FindGO("HelpBar", self.PAGE_todayquest)
  self.todayquest_useHelpBtn = self:FindGO("UseButton", self.PAGE_todayquest)
  self.todayquest_useHelpBtn_Lb = self:FindComponent("Label", UILabel, self.todayquest_useHelpBtn)
  self:AddClickEvent(self.todayquest_useHelpBtn, function()
    self:todayquest_UseHelper()
  end)
  self.todayquest_helperGrid = self:FindGO("Grid", self.todayquest_helperBar):GetComponent(UIGrid)
  self.todayquest_helperListCtl = UIGridListCtrl.new(self.todayquest_helperGrid, AierBlacksmithHelpCell, "AierBlacksmithHelpCell")
  self.todayquest_helperListCtl:AddEventListener(MouseEvent.MouseClick, self.todayquest_HandleClickHelper, self)
  self.todayquest_waittext = self:FindGO("waittext", self.PAGE_todayquest)
  self.PAGE_subquest = self:FindGO("_subquest", self.detailPage)
  self.subquest_questListSv = self:FindComponent("commonSv", UIScrollView, self.PAGE_subquest)
  self.subquest_questGrid = self:FindGO("questGrid", self.PAGE_subquest):GetComponent(UIGrid)
  self.subquest_questListCtl = UIGridListCtrl.new(self.subquest_questGrid, AierBlacksmithSubQuestCell, "AierBlacksmithQuestCell")
  self.subquest_questListCtl:AddEventListener(MouseEvent.MouseClick, self.subquest_HandleClickQuestBtn, self)
  self.subquest_waittext = self:FindGO("waittext", self.PAGE_subquest)
  self.PAGE_todaywanted = self:FindGO("_todaywanted", self.detailPage)
  self.todaywanted_cellGrid = self:FindGO("GridPost", self.PAGE_todaywanted):GetComponent(UIGrid)
  self.todaywanted_wantedList = UIGridListCtrl.new(self.todaywanted_cellGrid, AierBlacksmithWantedCell, "AierBlacksmithWantedCell")
  self.todaywanted_pageLb = self:FindComponent("pageNum", UILabel, self.PAGE_todaywanted)
  self.todaywanted_wantedBgs = {}
  for i = 1, 6 do
    self.todaywanted_wantedBgs[i] = self:FindGO("PBG" .. i, self.detailPage)
  end
  self.todaywanted_prevBtn = self:FindGO("prevBtn", self.PAGE_todaywanted)
  self.todaywanted_nextBtn = self:FindGO("nextBtn", self.PAGE_todaywanted)
  self.TodayWanted_curpage = 1
  self:AddClickEvent(self.todaywanted_prevBtn, function()
    self:todaywanted_SwitchPage(self.TodayWanted_curpage - 1)
  end)
  self:AddClickEvent(self.todaywanted_nextBtn, function()
    self:todaywanted_SwitchPage(self.TodayWanted_curpage + 1)
  end)
  self.PAGE_xxxxxx = self:FindGO("_xxxxxx", self.detailPage)
end

function AierBlacksmithPanel:AddEvents()
  self:AddListenEvt(ServiceEvent.SceneManorSmithInfoManorCmd, self.On_SceneManorSmithInfoManorCmd)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.On_SceneManorSmithInfoManorCmd)
  self:AddListenEvt(ServiceEvent.SceneManorSmithLevelUpManorCmd, self.On_SceneManorSmithLevelUpManorCmd)
  self:AddListenEvt(ServiceEvent.SceneManorSmithAcceptQuestManorCmd, self.On_SceneManorSmithAcceptQuestManorCmd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.On_ItemUpdate)
end

function AierBlacksmithPanel:InitSceneModel()
  if self.objSceneModelRoot then
    return
  end
  self.objSceneModelRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIModel("AierBlacksmithScene"))
  GameObject.DontDestroyOnLoad(self.objSceneModelRoot)
  self.objSceneModelRoot.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.objModelParent = self:FindGO("RolePos", self.objSceneModelRoot)
  self.tsfCameraPos = self:FindGO("CameraPos", self.objSceneModelRoot).transform
  UIManagerProxy.Instance:RefitSceneModel(self.tsfCameraPos, self:FindGO("Reloading_BG", self.objSceneModelRoot).transform)
end

local PlayShowName = Asset_Role.ActionName.PlayShow
local IdleActionName = "attack_wait"

function AierBlacksmithPanel:InitNpcModel()
  local npcid = AierBlacksmithProxy.Instance:Query_MainNpcID()
  local sdata = Table_Npc[npcid]
  self:DestroyNpcModel()
  local npcParts = Asset_RoleUtility.CreateNpcRoleParts(sdata.id)
  npcParts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  self.role = Asset_Role_UI.Create(npcParts, nil, function()
    self:NpcPlayDialog(GameConfig.Smithy.Behavior.dialog_welcome_normal)
    self:NpcPlayAction(GameConfig.Smithy.Behavior.action_welcome_normal)
  end)
  self.role:SetParent(self.objModelParent.transform, false)
  self.role:SetLayer(Game.ELayer.Outline)
  local showPos = sdata.LoadShowPose
  if showPos and #showPos == 3 then
    self.role:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
  else
    self.role:SetPosition(LuaGeometry.Const_V3_zero)
  end
  if sdata.LoadShowRotate then
    self.role:SetEulerAngleY(sdata.LoadShowRotate)
  else
    self.role:SetEulerAngleY(180)
  end
  local otherScale = sdata.LoadShowSize or sdata.Scale or sdata.Shape and GameConfig.UIModelScale[sdata.Shape] or 1
  self.role:SetScale(otherScale)
  self.role:SetEpNodesDisplay(true)
  Asset_RoleUtility.SetNpcRoleParts(self.npcId, npcParts)
  self.role:Redress(npcParts, true)
  self:NpcPlayDialog(GameConfig.Smithy.Behavior.dialog_welcome_normal)
  self:NpcPlayAction(GameConfig.Smithy.Behavior.action_welcome_normal)
  Asset_Role.DestroyPartArray(npcParts)
end

local restoreAnimCallback = function(id, self)
  self:_PlayCharacterAction(IdleActionName)
end

function AierBlacksmithPanel:PlayCharacterAction(actionName, callback, callbackArg)
  self:_PlayCharacterAction(actionName, callback or restoreAnimCallback, callbackArg or self)
end

function AierBlacksmithPanel:_PlayCharacterAction(actionName, callback, callbackArg)
  if not (self.npcdata and self.npcdata.assetRole) or not actionName then
    return
  end
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  params[7] = callback
  params[8] = callbackArg
  self.npcdata.assetRole:PlayActionRaw(params)
end

function AierBlacksmithPanel:DestroyNpcModel()
  if self.role and self.role:Alive() then
    self.role:SetEpNodesDisplay(false)
    self.role:Destroy()
  end
  self.role = nil
  TimeTickManager.Me():ClearTick(self, npcPlayshowTickId)
end

function AierBlacksmithPanel:SwitchCameraToModel()
  if self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      if not self.errorOccured then
        self.objBtnEmoji:SetActive(false)
        self.objRotateRole:SetActive(false)
        self.errorOccured = true
      end
      self.initRetryCount = self.initRetryCount + 1
      if self.initRetryCount > 9 then
        LogUtility.Error("无法找到CameraController，重试10次失败，将无法使用表情功能！")
        return
      end
      self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
        self.ltInitCamera = nil
        self:SwitchCameraToModel()
      end, self, 3)
      return
    end
  end
  if self.errorOccured then
    self.objBtnEmoji:SetActive(true)
    self.objRotateRole:SetActive(true)
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  else
    LogUtility.Error("没有在主摄像机上找到CameraController！")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.tsfCameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.tsfCameraPos))
  self.cameraWorld.fieldOfView = 20
  self.isCameraOnModel = true
end

function AierBlacksmithPanel:ResetCameraToDefault()
  if not self.isCameraOnModel then
    return
  end
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
      self:UpdateCameraViewPort(0)
    end
  end
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function AierBlacksmithPanel:UpdateCameraViewPort(duration)
  local mount = BagProxy.Instance:GetRoleEquipBag():GetMount()
  self:CameraRotateToMe(false, mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort, nil, nil, duration)
end

function AierBlacksmithPanel:ToMainPage()
  self.mainPage:SetActive(true)
  self.detailPage:SetActive(false)
  self:RefreshMainPage()
end

function AierBlacksmithPanel:ToDetailPage()
  self.mainPage:SetActive(false)
  self.detailPage:SetActive(true)
  self:RefreshDetailPage()
end

function AierBlacksmithPanel:GotoQuenchCombineView()
  self:SetPushToStack(true)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {initialGroupId = 22}
  })
end

function AierBlacksmithPanel:RefreshPanel()
  AierBlacksmithProxy.Instance:RedTip_Update()
  if self.mainPage.activeSelf then
    self:RefreshMainPage()
  end
  if self.detailPage.activeSelf then
    self:RefreshDetailPage()
  end
end

function AierBlacksmithPanel:RefreshMainPage()
  if not self.mainPage.activeSelf then
    return
  end
  self:_RefreshMain_LevelInfo()
  self:_RefreshMain_LevelRewardInfo()
end

function AierBlacksmithPanel:RefreshDetailPage()
  if not self.detailPage.activeSelf then
    return
  end
  if not self.detailPageSubInited then
    self.listControllerOfSubTabs:ResetDatas(GameConfig.Smithy.DetailPages)
    local cells = self.listControllerOfSubTabs:GetCells()
    for i = 1, #cells do
      local singleCell = cells[i]
      self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
    end
    self:TabChangeHandler(cells[1])
    self.detailPageSubInited = true
  else
    self:refreshCategoryClick(self.detailSubTab)
  end
end

function AierBlacksmithPanel:ShowRewardPopup()
  if not self.levelListPage then
    self.levelListPage = self:AddSubView("AierBlacksmithRewardListPopUp", AierBlacksmithRewardListPopUp)
  end
  self.levelListPage:SetActive(true)
  self.levelListPage:AdjustScrollView()
end

function AierBlacksmithPanel:DoUpgradeBlacksmith()
  AierBlacksmithTestMe.Me():CallSmithLevelUpManorCmd()
end

function AierBlacksmithPanel:DoUseHelperAcceptQuest()
  AierBlacksmithTestMe.Me():CallSmithAcceptQuestManorCmd(0, 0)
end

function AierBlacksmithPanel:On_SceneManorSmithInfoManorCmd(_)
  self:RefreshPanel()
end

function AierBlacksmithPanel:On_SceneManorSmithLevelUpManorCmd(_)
  self:RefreshNpcData()
  if AierBlacksmithProxy.Instance:TryPlayUpgradeBehavior(self.viewdata and self.viewdata.viewdata) then
  else
    self:RefreshPanel()
    if not self.levelUpActionCd then
      self:NpcPlayDialog(GameConfig.Smithy.Behavior.dialog_upgrade)
      self:NpcPlayAction(GameConfig.Smithy.Behavior.action_upgrade)
      self.levelUpActionCd = true
      TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
        self.levelUpActionCd = nil
      end, self)
    end
  end
end

function AierBlacksmithPanel:On_SceneManorSmithAcceptQuestManorCmd(_)
  self:RefreshPanel()
end

function AierBlacksmithPanel:On_ItemUpdate()
  if not self.mainPage.activeSelf then
    return
  end
  self:_RefreshMain_LevelInfo()
end

function AierBlacksmithPanel:OnEnter()
  AierBlacksmithPanel.super.OnEnter(self)
  AierBlacksmithTestMe.Me():CallSmithInfoManorCmd()
  AierBlacksmithTestMe.Me():CallReqPeriodicMonsterUserEvent()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if self.npcdata and self.npcdata.assetRole then
    local npcTrans = self.npcdata.assetRole.completeTransform
    if npcTrans then
      self.cameraProjectionChanged = true
      local cameraMode = FunctionCameraEffect.Me():GetCurCameraMode()
      local viewPort, rotation, rotateOffset, focusOffset
      if cameraMode == FunctionCameraEffect.CameraMode.Lock then
        viewPort = LuaVector3.New(0.5, 0.4, 3)
        rotation = LuaVector3.New(-1.3048, 278, 0.329)
        rotateOffset = LuaVector3.New(0, 3.5, 0)
        focusOffset = LuaVector3.New(-0.475, 0.7, 0.345)
      else
        viewPort = LuaVector3.New(0, 0, 0)
        rotation = LuaVector3.New(-1.3048, 278, 0.329)
        rotateOffset = LuaVector3.New(0, 3.5, 0)
        focusOffset = LuaVector3.New(2.52, 0.93, 0.105)
      end
      self:CameraFaceTo(npcTrans, viewPort, rotation, nil, rotateOffset, nil, focusOffset, true)
      self.cameraController:FieldOfViewTo(55, CameraConfig.UI_Duration, nil)
      FunctionSceneFilter.Me():StartFilter(_Filter)
      TimeTickManager.Me():CreateOnceDelayTick(CameraConfig.UI_Duration * 1000, function(owner, deltaTime)
        self:NpcPlayDialog(GameConfig.Smithy.Behavior.dialog_welcome_normal)
        self:NpcPlayAction(GameConfig.Smithy.Behavior.action_welcome_normal)
      end, self)
    end
  else
    self:CameraRotateToMe()
  end
  self:ToMainPage()
end

function AierBlacksmithPanel:OnExit()
  if self.cameraProjectionChanged then
    self:CameraReset(0)
    FunctionSceneFilter.Me():EndFilter(_Filter)
  else
    self:CameraReset()
  end
  TimeTickManager.Me():ClearTick(self)
  AierBlacksmithPanel.super.OnExit(self)
end

function AierBlacksmithPanel:_RefreshMain_LevelInfo()
  local lv = AierBlacksmithProxy.Instance.proxyData.level or 0
  self.dLv.text = string.format("%02d", lv)
  local max_lv = AierBlacksmithProxy.Instance.configData.MaxLevel
  local next_lv = math.min(lv + 1, max_lv)
  local needCount = AierBlacksmithProxy.Instance:Query_UpgradeNeedItemCount(next_lv)
  local haveCount = AierBlacksmithProxy.Instance:Query_UpgradeItemCount()
  self.donateProgressText.text = string.format("%d/%d", haveCount, needCount)
  local p = needCount <= 0 and 1 or math.min(haveCount / needCount, 1)
  self.donateProgress.value = p
  UIUtil.TempSetButtonStyle(1 <= p and 4 or 0, self.upgradeBtn)
  if lv >= max_lv then
    self.upgradeBtn:SetActive(false)
    self.lvMaxed:SetActive(true)
  else
    self.upgradeBtn:SetActive(true)
    self.lvMaxed:SetActive(false)
  end
  local nextReward = AierBlacksmithProxy.Instance:Query_NextLevelReward()
  nextReward = nextReward and nextReward.item and nextReward.item[1]
  if nextReward then
    self.rewardIcon.gameObject:SetActive(true)
    IconManager:SetItemIcon(nextReward.id, self.rewardIcon)
  else
    self.rewardIcon.gameObject:SetActive(false)
  end
end

function AierBlacksmithPanel:_RefreshMain_LevelRewardInfo()
  local sss = {}
  local maxLevel = #Table_SmithLevel
  for i = 1, maxLevel do
    sss[#sss + 1] = Table_SmithLevel[i]
  end
  local reward_lv = AierBlacksmithProxy.Instance.proxyData.reward_level or 0
  self.levellevelLb.text = string.format(ZhString.ItemTip_PetEgg_Level, tostring(reward_lv))
  self.levelRewardListCtl:ResetDatas(sss)
  self:_LevelRewardInfo_AdjustScrollView()
end

function AierBlacksmithPanel:_LevelRewardInfo_AdjustScrollView()
  self.levelRewardListSv:ResetPosition()
  local cells = self.levelRewardListCtl:GetCells()
  local targetCell
  for i = 1, #cells do
    local cell = cells[i]
    if not cell:CheckIsFinish() then
      if not targetCell then
        targetCell = cell
      elseif targetCell.sortOrder > cell.sortOrder then
        targetCell = cell
      end
    end
  end
  if not targetCell then
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.levelRewardListSv.panel.cachedTransform, targetCell.gameObject.transform)
  local offset = self.levelRewardListSv.panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.levelRewardListSv:MoveRelative(offset)
end

function AierBlacksmithPanel:_LevelRewardInfo_OnClickRewardItem(cellctl)
  local data = cellctl.data
  if data == nil then
    return
  end
  if cellctl and cellctl ~= self._LevelRewardInfo_clickRewardItem then
    local stick = cellctl.iconSp
    if data then
      local callback = function()
        self:_LevelRewardInfo_CancelClickRewardItem()
      end
      local sdata = {
        itemdata = ItemData.new("Booth", cellctl.itemid),
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {310, 0})
    end
    self._LevelRewardInfo_clickRewardItem = cellctl
  else
    self:_LevelRewardInfo_CancelClickRewardItem()
  end
end

function AierBlacksmithPanel:_LevelRewardInfo_CancelClickRewardItem()
  self._LevelRewardInfo_clickRewardItem = nil
  self:ShowItemTip()
end

function AierBlacksmithPanel:NpcPlayDialog(randist)
  if not self.npcdata then
    return
  end
  if not randist or type(randist) == "table" and #randist == 0 then
    return
  end
  local talkid = type(randist) ~= "table" and randist or randist[math.random(#randist)]
  local msg = talkid and DialogUtil.GetDialogData(talkid) and DialogUtil.GetDialogData(talkid).Text
  local sceneUI = self.npcdata:GetSceneUI()
  if sceneUI and msg then
    sceneUI.roleTopUI:Speak(msg, self.npcdata, true)
  end
end

function AierBlacksmithPanel:NpcPlayAction(randist)
  if not randist or type(randist) == "table" and #randist == 0 then
    return
  end
  local actionname = type(randist) ~= "table" and randist or randist[math.random(#randist)]
  if actionname then
    self:PlayCharacterAction(actionname)
  end
end

function AierBlacksmithPanel:TabChangeHandler(cell)
  if self.detailSubTab ~= cell.data.Tab then
    AierBlacksmithPanel.super.TabChangeHandler(self, cell)
    self.detailSubTab = cell.data.Tab
    self:handleCategoryClick(cell)
  end
end

function AierBlacksmithPanel:refreshCategoryClick(tab)
  tab = tab or self.detailSubTab or 1
  local cells = self.listControllerOfSubTabs:GetCells()
  local cell = cells[tab]
  self:handleCategoryClick(cell)
end

function AierBlacksmithPanel:handleCategoryClick(cell)
  local cells = self.listControllerOfSubTabs:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
  local data = cell.data
  self.detailSubTab = data.Tab
  local cfg = GameConfig.Smithy.DetailPages[self.detailSubTab]
  self["SubTabClick_" .. cfg.Func](self, cfg)
end

function AierBlacksmithPanel:SubTabClick_TodayQuest(cfg)
  self.detailSubTitleLb.text = cfg.Text
  self.PAGE_todayquest:SetActive(true)
  self.PAGE_subquest:SetActive(false)
  self.PAGE_todaywanted:SetActive(false)
  self:todayquest_RefreshSubPage()
end

function AierBlacksmithPanel:SubTabClick_SubQuest(cfg)
  self.detailSubTitleLb.text = cfg.Text
  self.PAGE_todayquest:SetActive(false)
  self.PAGE_subquest:SetActive(true)
  self.PAGE_todaywanted:SetActive(false)
  self:subquest_RefreshSubPage()
end

function AierBlacksmithPanel:SubTabClick_TodayWanted(cfg)
  self.detailSubTitleLb.text = cfg.Text
  self.PAGE_todayquest:SetActive(false)
  self.PAGE_subquest:SetActive(false)
  self.PAGE_todaywanted:SetActive(true)
  self:todaywanted_RefreshSubPage()
end

function AierBlacksmithPanel:SubTabClick_xxxxx(cfg)
  self:SetPushToStack(true)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {initialCrackId = 140}
  })
end

function AierBlacksmithPanel:todayquest_RefreshSubPage()
  self:todayquest_QuestList()
  self:todayquest_HelperList()
end

function AierBlacksmithPanel:todayquest_GotoQuestView()
  self:SetPushToStack(true)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.QuestTracePanel
  })
end

function AierBlacksmithPanel:todayquest_HandleClickQuestBtn(cell)
  self:NpcPlayDialog(GameConfig.Smithy.Behavior.dialog_accept_quest)
  self:NpcPlayAction(GameConfig.Smithy.Behavior.action_accept_quest)
  local questStatus = cell.data.quest_state
  if questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_ACCEPTED then
    local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(cell.data.questid)
    if not questData then
      return
    end
    if questData.staticData and questData.staticData.Params and questData.staticData.Params.ifAccessFc then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id)
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, cell.data.questid)
      AierBlacksmithTestMe.Me():CallSmithInfoManorCmd()
    else
      GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, questData)
      self:CloseSelf()
    end
  elseif questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_HELPED then
  elseif questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_DONE then
  else
    AierBlacksmithTestMe.Me():CallSmithAcceptQuestManorCmd(cell.data.questid)
  end
end

function AierBlacksmithPanel:todayquest_HandleClickHelper(cell)
  if cell and cell.data and not cell.data.unlocked then
    MsgManager.FloatMsgTableParam(nil, string.format(ZhString.AierBlacksmith_UnlockWhenLv, cell.data.lv))
  end
end

function AierBlacksmithPanel:todayquest_HelperList()
  local all_partners = AierBlacksmithProxy.Instance:Query_AllNpcList()
  if all_partners and 0 < #all_partners then
    self.todayquest_helperBar:SetActive(true)
    self.todayquest_helperListCtl:ResetDatas(all_partners)
  else
    self.todayquest_helperBar:SetActive(false)
  end
  local has_pending_quest = AierBlacksmithProxy.Instance:Query_GetFirstCanAcceptQuest()
  local has_free_helper = AierBlacksmithProxy.Instance:Query_GetFirstFreeHelper()
  local ct1, ct2 = AierBlacksmithProxy.Instance:Query_HelperCountInfo()
  self.todayquest_useHelpBtn_Lb.text = ZhString.AierBlacksmithBtn_Help .. ct1 .. "/" .. ct2
  local style = has_pending_quest and has_free_helper and 4 or 0
  UIUtil.TempSetButtonStyle(style, self.todayquest_useHelpBtn)
end

function AierBlacksmithPanel:todayquest_QuestList()
  local quests = AierBlacksmithProxy.Instance.proxyData.quests
  self.todayquest_questListCtl:ResetDatas(quests)
  self.todayquest_questListSv:ResetPosition()
  self.todayquest_waittext:SetActive(#quests == 0)
end

function AierBlacksmithPanel:todayquest_UseHelper()
  local pending_quest, is_accepted = AierBlacksmithProxy.Instance:Query_GetFirstCanAcceptQuest()
  local free_helper = AierBlacksmithProxy.Instance:Query_GetFirstFreeHelper()
  if pending_quest and free_helper then
    if is_accepted then
      local questinfo
      for _, v in pairs(Table_SmithQuest) do
        if v.QuestID == pending_quest.questid then
          questinfo = v
          break
        end
      end
      local questname = questinfo and questinfo.Desc or ""
      MsgManager.ConfirmMsgByID(626, function()
        AierBlacksmithTestMe.Me():CallSmithAcceptQuestManorCmd(pending_quest.questid, free_helper.npcid)
      end, nil, nil, questname)
    else
      AierBlacksmithTestMe.Me():CallSmithAcceptQuestManorCmd(pending_quest.questid, free_helper.npcid)
    end
  end
end

function AierBlacksmithPanel:subquest_RefreshSubPage()
  AierBlacksmithProxy.Instance:Query_SubQuestInfo()
  local quests = AierBlacksmithProxy.Instance.proxyData.sub_quests
  self.subquest_questListCtl:ResetDatas(quests)
  self.subquest_questListSv:ResetPosition()
  self.subquest_waittext:SetActive(#quests == 0)
end

function AierBlacksmithPanel:subquest_HandleClickQuestBtn(cell)
  local all_quests, _data = cell.data.ids
  for i = 1, #all_quests do
    _data = QuestProxy.Instance:GetQuestDataBySameQuestID(all_quests[i])
    if _data then
      break
    end
  end
  if _data then
    GameFacade.Instance:sendNotification(QuestEvent.QuestTraceSwitch, _data)
    self:CloseSelf()
  elseif cell.data.info and cell.data.info.shortcutpowerID and cell.data.info.shortcutpowerID ~= 0 then
    FuncShortCutFunc.Me():CallByID(cell.data.info.shortcutpowerID)
    self:CloseSelf()
  end
end

function AierBlacksmithPanel:todaywanted_SwitchPage(page)
  local pageCnt = AierBlacksmithProxy.Instance:Query_MonsterPeriodicRewardPageCount()
  page = math.clamp(page, 1, pageCnt)
  if self.TodayWanted_curpage ~= page then
    self.TodayWanted_curpage = page
    self:todaywanted_RefreshSubPage()
  end
end

function AierBlacksmithPanel:todaywanted_RefreshSubPage()
  local pageCnt = AierBlacksmithProxy.Instance:Query_MonsterPeriodicRewardPageCount()
  self.todaywanted_pageLb.text = tostring(self.TodayWanted_curpage)
  UIUtil.TempSetButtonStyle(self.TodayWanted_curpage > 1 and 2 or 0, self.todaywanted_prevBtn)
  UIUtil.TempSetButtonStyle(pageCnt > self.TodayWanted_curpage and 2 or 0, self.todaywanted_nextBtn)
  local pageData = AierBlacksmithProxy.Instance:Query_MonsterPeriodicRewardPage(self.TodayWanted_curpage)
  self.todaywanted_wantedList:ResetDatas(pageData)
  local pageCellCnt = #pageData
  for i = 1, 6 do
    self.todaywanted_wantedBgs[i]:SetActive(i <= pageCellCnt)
  end
end
