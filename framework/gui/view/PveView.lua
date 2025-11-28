local _BattleTimeData, _EntranceProxy, _RedTipProxy, _PictureManager
local _PopUpItemConfig = {}
local _ChallengeRedColor = Color(0.8941176470588236, 0.34901960784313724, 0.23921568627450981, 1)
local _NewBlackColor = Color(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
local _PveGroupTogColor = {
  [1] = Color(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1),
  [2] = Color(0.5176470588235295, 0.6431372549019608, 0.8352941176470589, 1)
}
local _PveGroupTogSp = {
  [1] = "recharge_btn_1",
  [2] = "recharge_btn_3"
}
local _sweepBtn = {
  sp = {"com_btn_1", "com_btn_13"},
  lab = {
    Color(0.06274509803921569, 0.16470588235294117, 0.5490196078431373, 1),
    Color(0.36470588235294116, 0.3568627450980392, 0.3568627450980392, 1)
  }
}
local labelBgHeight = 48
local labelBgHeight_Extra = 73
local dropTexture = "Novicecopy_diaoluo_bg2"
local _PveConfig = GameConfig.Pve
local _AddPlayTimeItmeID = _PveConfig and _PveConfig.AddPlayTimeItemId and _PveConfig.AddPlayTimeItemId[1]
local ERedSys = SceneTip_pb.EREDSYS_PVERAID_ACHIEVE
local _HearwearShortcutPowerId = 4099
local MVPCostTime = GameConfig.BossScene and GameConfig.BossScene.MVPTimeCost or 3600
local MiniCostTime = GameConfig.BossScene and GameConfig.BossScene.MiniTimeCost or 1800
local EContentType = {
  RecommendPlayerNum = 1,
  LeftRewardCount = 2,
  CostTime = 3,
  EquipRate = 4
}
autoImport("PveEntranceData")
autoImport("PveTypeCell")
autoImport("PveDropItemCell")
autoImport("PveMonsterCell")
autoImport("PveDifficultyCell")
autoImport("PveBossCell")
autoImport("HappyShopBuyItemCell")
autoImport("PveMonsterTextureCell")
autoImport("PveAffixSubview")
autoImport("HeroRoadView")
autoImport("SweepTicketUtil")
PveView = class("PveView", ContainerView)
PveView.ViewType = UIViewType.NormalLayer

function PveView:Init()
  _EntranceProxy = PveEntranceProxy.Instance
  _RedTipProxy = RedTipProxy.Instance
  _PictureManager = PictureManager.Instance
  _BattleTimeData = BattleTimeDataProxy.Instance
  self.root = self:FindGO("Root")
  self.root:SetActive(false)
  self.loadingRoot = self:FindGO("LoadingRoot")
  self.loadingRoot:SetActive(true)
  self:AddEvt()
  self:InitBuyItemCell()
end

function PveView:InitRaidRoot()
  self.raidRoot = {}
  self.raidRoot[PveRaidType.Headwear] = self.headwearRoot
  self.raidRoot[PveRaidType.InfiniteTower] = self.endlessTowerRoot
  self.raidRoot[PveRaidType.Rugelike] = self.roguelikeRoot
  self.raidRoot[PveRaidType.StarArk] = self.starArkRoot
  self.raidRoot[PveRaidType.SpaceTimeIllusion] = self.starArkRoot
  self.raidTipRoot = self:FindGO("RaidTipRoot")
  self.raidTipLab = self:FindComponent("Tip", UILabel, self.raidTipRoot)
end

function PveView:_InitRaidTypeFunc()
  self.raidFunc = {}
  self.raidFunc[PveRaidType.Headwear] = self._updateHeadWear
  self.raidFunc[PveRaidType.InfiniteTower] = self._updateEndlessTower
  self.raidFunc[PveRaidType.PveCard] = self._updatePveCard
  self.raidFunc[PveRaidType.Rugelike] = self._updateRugelike
  self.raidFunc[PveRaidType.EquipUpgrade] = self._updateExtraLayer
  self.raidFunc[PveRaidType.Crack] = self._updateCrack
  self.raidFunc[PveRaidType.StarArk] = self.UpdateAffix
  self.raidFunc[PveRaidType.SpaceTimeIllusion] = self.UpdateAffix
  self.twoDifficultyModeRaid = {}
  for k, v in pairs(Game.difficultyRaidMap) do
    self.twoDifficultyModeRaid[k] = 1
  end
  self.twoDifficultyModeRaid[PveRaidType.Boss] = 1
  self.raidTip = {}
  self.raidTip[PveRaidType.Headwear] = 1
  self.raidTip[PveRaidType.PveCard] = 1
  self.raidTip[PveRaidType.InfiniteTower] = 1
  self.raidTip[PveRaidType.EquipUpgrade] = 1
  self.raidTip[PveRaidType.Crack] = 1
  self.sweepFunc = {}
  self.sweepFunc[PveRaidType.PveCard] = self._DoSweep_PveCard
  self.sweepFunc[PveRaidType.Crack] = self._DoSweep_Crack
  self.sweepFunc[PveRaidType.StarArk] = self._DoSweep_StarArk
end

function PveView:UpdateMultiReward()
  if not self.curData then
    return
  end
  local multiply = _EntranceProxy:TryGetRewardMultiply(self.curData.id)
  if multiply then
    self:Show(self.multiRewardLab)
    self.multiRewardLab.text = "x" .. tostring(multiply)
  else
    self:Hide(self.multiRewardLab)
  end
end

function PveView:UpdateCurRaidRoot()
  if not self.curData then
    return
  end
  if self.curRaidRoot then
    self:Hide(self.curRaidRoot)
  end
  local type = self.curData.staticEntranceData.raidType
  if self.raidRoot[type] then
    self.curRaidRoot = self.raidRoot[type]
    self:Show(self.curRaidRoot)
  end
  self.raidTipRoot:SetActive(nil ~= self.raidTip[type])
  local updateCall = self.raidFunc[type]
  if nil ~= updateCall then
    updateCall(self, self.curIsOpen)
  end
  self:_updateDifficultyMode(type)
end

function PveView:_updateDifficultyMode(type)
  local isTwoDifficulty = self.twoDifficultyModeRaid[type]
  local isBoss = self.curData.staticEntranceData:IsBoss()
  self.difficultyModeTog1Lab.text = isBoss and ZhString.Pve_BossTog1 or ZhString.Pve_Tog1
  self.difficultyModeTog2Lab.text = isBoss and ZhString.Pve_BossTog2 or ZhString.Pve_Tog2
  if self.isTwoDifficultyMode == isTwoDifficulty then
    return
  end
  self.isTwoDifficultyMode = isTwoDifficulty
  local clip = self.difficultyPanel.baseClipRegion
  if isTwoDifficulty then
    self:Show(self.difficultyModeRoot)
    self.difficultyPanel.transform.localPosition = LuaGeometry.GetTempVector3(244, 208, 0)
    self.difficultyPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 628, 130)
  else
    self:Hide(self.difficultyModeRoot)
    self.difficultyPanel.transform.localPosition = LuaGeometry.GetTempVector3(170, 208, 0)
    self.difficultyPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 782, 130)
  end
  self.difficultyPanel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
end

function PveView:_Init()
  self:FindObj()
  self:AddUIEvts()
  self:_InitRaidTypeFunc()
end

function PveView:FindObj()
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.raidHelpBtn = self:FindGO("RaidHelpTip", self.nameLab.gameObject)
  local rootBg = self:FindGO("RootBg")
  local rewardRoot = self:FindGO("DropRoot", self.root)
  self.multiRewardLab = self:FindComponent("MultiRewardLab", UILabel, self.rewardRoot)
  local dropRewardLab = self:FindComponent("Label", UILabel, self.rewardRoot)
  dropRewardLab.text = ZhString.Pve_DropReward
  self.dropBgTex = self:FindComponent("DropTex", UITexture, rewardRoot)
  _PictureManager:SetUI(dropTexture, self.dropBgTex)
  self.matchBtn = self:FindGO("MatchBtn")
  self.matchBtnSp = self.matchBtn:GetComponent(UISprite)
  self.matchBtnLab = self:FindComponent("Label", UILabel, self.matchBtn)
  self.matchBtnLab.text = ZhString.Pve_Match
  self.challengeBtn = self:FindGO("ChallengeBtn")
  self.challengeBtnSp = self.challengeBtn:GetComponent(UISprite)
  self:AddOrRemoveGuideId(self.challengeBtn, 489)
  self:AddOrRemoveGuideId(self.challengeBtn, 493)
  self.challengeBtnLab = self:FindComponent("Label", UILabel, self.challengeBtn)
  self.challengeBtnLab.text = ZhString.Pve_Challenge
  self.shopBtn = self:FindGO("ShopBtn")
  self.shopBtnLab = self:FindComponent("Label", UILabel, self.shopBtn)
  self.shopBtnLab.text = ZhString.Pve_Shop
  self.publishBtn = self:FindGO("PublishBtn")
  self.initialPublishXAxis = self.publishBtn.transform.localPosition.x
  self.publishBtnSp = self.publishBtn:GetComponent(UISprite)
  self.publishBtnLab = self:FindComponent("Label", UILabel, self.publishBtn)
  self.recommendPlayerNumLab = self:FindComponent("RecommendPlayerNum", UILabel)
  self.challengeNumLab = self:FindComponent("ChallengeNum", UILabel)
  self.raidTypeSv = self:FindComponent("PveScrollView", UIScrollView)
  self.raidTypeTable = self:FindComponent("RaidTypeTable", UITable)
  self.pveWraplist = UIGridListCtrl.new(self.raidTypeTable, PveTypeCell, "PveTypeCell")
  self.pveWraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickRaidTypeCell, self)
  self.itemScrollViewPanel = self:FindComponent("ItemScrollView", UIPanel)
  local itemGrid = self:FindComponent("ItemGrid", UIGrid, self.itemScrollViewPanel.gameObject)
  self.itemCtl = UIGridListCtrl.new(itemGrid, PveDropItemCell, "PveDropItemCell")
  self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  self.difficultyPanel = self:FindComponent("DiffScrollView", UIPanel, self.root)
  self.difficultyGrid = self:FindComponent("DifficultyGrid", UIGrid, self.difficultyPanel.gameObject)
  self.difficultyCtl = UIGridListCtrl.new(self.difficultyGrid, PveDifficultyCell, "PveDifficultyCell")
  self.difficultyCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDifficulty, self)
  self.resetFubenBtn = self:FindGO("PVE_ResetBtn")
  self:AddClickEvent(self.resetFubenBtn, function()
    self:OnClickPveResetBtn()
  end)
  self.sweepBtn = self:FindGO("SweepBtn", self.root)
  self.extraSweepRoot = self:FindGO("ExtraSweepRoot", self.root)
  self.labelBg = self:FindComponent("LabelBg", UISprite, self.root)
  self.leftSweepText = self:FindComponent("LeftSweepText", UILabel, self.extraSweepRoot)
  self.sweepCostText = self:FindComponent("SweepCostTimeText", UILabel, self.extraSweepRoot)
  self.initialSweepXAxis = self.sweepBtn.transform.localPosition.x
  self:AddClickEvent(self.sweepBtn, function()
    if self.call_lock then
      MsgManager.ShowMsgByID(49)
      return
    end
    if SweepTicketUtil.HasSweepTicket() and not self.curData:IsFree() then
      if SweepTicketUtil.CheckSweepTicketValid(self.costTime, self.curData:IsFree(), function(ignoreSufficientTime, ignoreMsg)
        return self:CheckSweepValid(ignoreSufficientTime, ignoreMsg)
      end) then
        SweepTicketUtil.HandleSweepTicketSweep(self.costTime, function(ticketCount, requiredTime, noTimeCost)
          self:ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost)
        end, function(ticketCount, requiredTime)
          self:ShowSweepTicketOverflowConfirm(ticketCount, requiredTime)
        end)
      else
        self:TrySweep()
      end
      return
    end
    self:TrySweep()
  end)
  self.sweepSp = self.sweepBtn:GetComponent(UISprite)
  self.sweepBtnLab = self:FindComponent("Label", UILabel, self.sweepBtn)
  self:InitMonster()
  self:InitStar()
  self:InitStarArk()
  self:InitServerMergeObj()
  self:InitLeftTimeTip()
  self:AddOrRemoveGuideId(self.checkBtn.gameObject, 1028)
  self:InitPveCard()
  self:InitRoguelike()
  self:InitBoss()
  self:InitEndlessTower()
  self:InitHeadwear()
  self:InitRaidRoot()
  self:InitDifficultyMode()
  self:InitContentFunc()
  self:InitActivityInfo()
  self.heroRoadViewRoot = self:FindGO("HeroRoadRoot")
  self.astralGraphBtn = self:FindGO("AstralGraphBtn")
  self:AddClickEvent(self.astralGraphBtn, function()
    if AstralProxy.Instance:IsSeasonNotOpen() then
      MsgManager.ShowMsgByID(43581)
      return
    end
    local config = GameConfig.Astral
    local menuId = config and config.GraphMenuID
    if FunctionUnLockFunc.Me():CheckCanOpen(menuId, true) then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AstralDestinyGraphView
      })
    end
  end)
  self:RegisterRedTipCheck(10771, self.astralGraphBtn, 8)
  self:RegisterRedTipCheck(10772, self.astralGraphBtn, 8)
  self.astralPrayBtn = self:FindGO("AstralPrayBtn")
  self:AddClickEvent(self.astralPrayBtn, function()
    if AstralProxy.Instance:IsSeasonEnd() then
      MsgManager.ShowMsgByID(43567)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstralPrayPopUp,
      viewdata = self.curData.staticEntranceData.groupid
    })
  end)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ASTRAL_NEW_SEASON_PRAY, self.astralPrayBtn, 8)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    if AstralProxy.Instance:IsSeasonEnd() then
      MsgManager.ShowMsgByID(43567)
      return
    end
    local shortcutId = GameConfig.Astral and GameConfig.Astral.LevelGroupShortcut and GameConfig.Astral.LevelGroupShortcut[self.curData.staticEntranceData.groupid]
    if shortcutId then
      FuncShortCutFunc.Me():CallByID(shortcutId)
      self:CloseSelf()
    end
  end)
  self.roguelikeSkillHandbookBtn = self:FindGO("RoguelikeSkillHandbookBtn")
  self:AddClickEvent(self.roguelikeSkillHandbookBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeSkillHandbookView
    })
  end)
end

function PveView:InitContentFunc()
  self.setContentFunc = {}
  self.setContentFunc[EContentType.RecommendPlayerNum] = self._SetContent_RecommendPlayerNum
  self.setContentFunc[EContentType.LeftRewardCount] = self._SetContent_LeftRewardCount
  self.setContentFunc[EContentType.CostTime] = self._SetContent_CostTime
  self.setContentFunc[EContentType.EquipRate] = self._SetContent_EquipRate
end

function PveView:OnDragModelTexture(go, delta)
  self.modelTexture:RotateModel(delta)
end

function PveView:ToNextMonster()
  if self.monstersData and #self.monstersData <= 1 then
    return
  end
  if self.monsterIndex >= #self.monstersData then
    self.monsterIndex = 1
  else
    self.monsterIndex = self.monsterIndex + 1
  end
  self:SetMonsterData()
end

function PveView:ToPreMonster()
  if self.monstersData and #self.monstersData <= 1 then
    return
  end
  if 1 >= self.monsterIndex then
    self.monsterIndex = #self.monstersData
  else
    self.monsterIndex = self.monsterIndex - 1
  end
  self:SetMonsterData()
end

function PveView:InitMonster()
  local monsterRoot = self:FindGO("MonsterRoot")
  self.modelTextureObj = self:FindGO("ModelTexture", monsterRoot)
  self.modelTextureUI = self:FindComponent("ModelTextureUI", UITexture, monsterRoot)
  self:Hide(self.modelTextureUI)
  self.modelColider = self:FindGO("ModelTextureColider", monsterRoot)
  self.modelTexture = PveMonsterTextureCell.new(self.modelTextureObj)
  self:AddDragEvent(self.modelColider, function(go, delta)
    self:OnDragModelTexture(go, delta)
  end)
  self.nextMonsterBtn = self:FindGO("NextMonsterBtn", monsterRoot)
  self.preMonsterBtn = self:FindGO("PreMonsterBtn", monsterRoot)
  self:AddClickEvent(self.nextMonsterBtn, function()
    self:ToNextMonster()
  end)
  self:AddClickEvent(self.preMonsterBtn, function()
    self:ToPreMonster()
  end)
  self.monsterNameLab = self:FindComponent("Name", UILabel, monsterRoot)
  self.monsterNature = self:FindComponent("Nature", UISprite, monsterRoot)
  self.monsterDetailBtn = self:FindGO("MonsterDetailBtn", monsterRoot)
  self:AddClickEvent(self.monsterDetailBtn, function()
    if nil ~= self.curMonsterId then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveMonsterPopUp,
        viewdata = {
          monsterIndex = self.monsterIndex,
          monstersData = self.monstersData
        }
      })
    end
  end)
end

function PveView:InitStar()
  self.starRoot = self:FindGO("StarRoot", self.root)
  self.stars = {}
  for i = 1, 3 do
    local msp = self:FindGO("Star" .. i):GetComponent(UIMultiSprite)
    table.insert(self.stars, msp)
  end
  self.checkBtn = self:FindGO("CheckBtn", self.root)
  self.checkBtnLab = self:FindComponent("Label", UILabel, self.checkBtn)
  self.checkBtnLab.text = ZhString.Pve_CheckAchievement
  self:Hide(self.starRoot)
end

function PveView:InitStarArk()
  self.starArkRoot = self:FindGO("StarArkRoot", self.root)
  self.checkAffixBtn = self:FindGO("CheckAffixBtn", self.root)
  self.affixBuffs = {}
  for i = 1, 3 do
    self.affixBuffs[i] = self:FindComponent("Buff" .. i, UISprite, self.checkAffixBtn)
  end
  self:AddClickEvent(self.checkAffixBtn, function(go)
    if not self.affixSubview then
      local root = self:FindGO("AffixSubViewRoot")
      self.affixSubview = self:AddSubView("PveAffixSubview", PveAffixSubview, root)
    end
    self.affixSubview:UpdateAffixData(self.curData:GetActiveAffix(), self.curData:GetDetailActiveAffix())
    self.affixSubview:OnShow()
  end)
end

function PveView:UpdateArkBuff()
  if not self.curData then
    return
  end
  local activeAffixs = self.curData:GetActiveAffix()
  for i = 1, 3 do
    if activeAffixs[i] then
      self:Show(self.affixBuffs[i])
      IconManager:SetSkillIcon(activeAffixs[i].staticData.Icon, self.affixBuffs[i])
      self.affixBuffs[i]:SetMaskPath(UIMaskConfig.SkillMask)
      self.affixBuffs[i].OpenMask = true
      self.affixBuffs[i].OpenCompress = true
    else
      self:Hide(self.affixBuffs[i])
    end
  end
end

function PveView:InitLeftTimeTip()
  self.leftTimeTip = self:FindGO("LeftTimeTip", self.root)
  self.leftTimeBord = self:FindGO("LeftTimeBord", self.leftTimeTip)
  self.leftTimeBordBg = self:FindComponent("LTBg", UISprite, self.leftTimeBord)
  self.leftTimeLine = self:FindGO("Sprite", self.leftTimeBordBg.gameObject)
  self:AddClickEvent(self.leftTimeTip, function(go)
    self.leftTimeBord:SetActive(not self.leftTimeBord.activeSelf)
    self:UpdateLeftTimeInfo()
  end)
  self.battleTimeLabel = self:FindComponent("BattleTImeLabel", UILabel, self.leftTimeBord)
  self.playTimeLabel = self:FindComponent("PlayTimeLabel", UILabel, self.leftTimeBord)
end

function PveView:InitPveCard()
  self.pveCard_addMaxCountBtn = self:FindComponent("PVE_Card_AddMaxCountBtn", UISprite)
  self.pveCard_addMaxCountBtnSp = self:FindComponent("Sprite", UISprite, self.pveCard_addMaxCountBtn.gameObject)
  self:AddClickEvent(self.pveCard_addMaxCountBtn.gameObject, function()
    self:OnClickPveCardAddMaxCnt()
  end)
end

function PveView:InitBoss()
  self.bossGrid = self:FindComponent("BossGrid", UIGrid, self.root)
  self.bossCtl = UIGridListCtrl.new(self.bossGrid, PveBossCell, "PveBossCell")
  self.bossCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickPveBossCell, self)
end

function PveView:InitRoguelike()
  self.roguelikeRoot = self:FindGO("RogulikeRoot", self.root)
  self.roguelikeLoadBtn = self:FindGO("RoguelikeLoadBtn")
  local rogueLikeLab = self:FindComponent("Label", UILabel, self.roguelikeLoadBtn)
  rogueLikeLab.text = ZhString.Pve_Roguelike_Load
  self.roguelikeLoadBtn:SetActive(false)
  self:AddClickEvent(self.roguelikeLoadBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeDungeonView
    })
  end)
end

function PveView:InitEndlessTower()
  self.endlessTowerRoot = self:FindGO("EndlessTowerRoot", self.root)
  self.endlessTowerLaunchBtn = self:FindGO("LaunchBtn", self.endlessTowerRoot)
  local endlessTowerLaunchLab = self:FindComponent("Label", UILabel, self.endlessTowerLaunchBtn)
  endlessTowerLaunchLab.text = ZhString.Pve_Launch
  self:AddClickEvent(self.endlessTowerLaunchBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveViewEndlessPopUp
    })
  end)
end

function PveView:InitHeadwear()
  self.headwearRoot = self:FindGO("HeadwearRoot", self.root)
  self.headwearShopBtn = self:FindGO("HeadwearShopBtn", self.headwearRoot)
  local headwearShopLab = self:FindComponent("Label", UILabel, self.headwearShopBtn)
  local headwearShopIcon = self:FindComponent("Icon", UISprite, self.headwearShopBtn)
  headwearShopLab.text = ZhString.Pve_Headwear_Shop
  self:AddClickEvent(self.headwearShopBtn, function()
    self:OnClickHeadwear()
  end)
  self:Hide(self.headwearRoot)
end

function PveView:InitDifficultyMode()
  self.difficultyModeRoot = self:FindGO("DifficultyModeRoot")
  local group = self:FindGO("Group")
  self.difficultyModeTog1Lab = self:FindComponent("Tog1", UILabel, group)
  self:AddClickEvent(self.difficultyModeTog1Lab.gameObject, function()
    self:OnDifficultyChange(Pve_Difficulty_Type.Normal)
  end)
  self.difficultyModeTog1Bg = self:FindComponent("SpriteBg", UISprite, self.difficultyModeTog1Lab.gameObject)
  self.difficultyModeTog2Lab = self:FindComponent("Tog2", UILabel, group)
  self:AddClickEvent(self.difficultyModeTog2Lab.gameObject, function()
    self:OnDifficultyChange(Pve_Difficulty_Type.Difficult)
  end)
  self.difficultyModeTog2Bg = self:FindComponent("SpriteBg", UISprite, self.difficultyModeTog2Lab.gameObject)
end

function PveView:OnDifficultyChange(diff_mode)
  if self.curDifficultyMode == diff_mode then
    return
  end
  local isBoss = self.curData.staticEntranceData:IsBoss()
  local bossDiffs
  if isBoss then
    bossDiffs = self.curData:GetServerBoss(diff_mode)
    if #bossDiffs == 0 then
      MsgManager.ShowMsgByID(43290)
      return
    end
  end
  self.curDifficultyMode = diff_mode
  self:_updateGroupTog()
  if isBoss then
    self:ReInitBossDiffRaid(bossDiffs)
    self.monsterIndex = 1
    self:UpdateRewardMonster()
  else
    self:InitDifficultyRaid()
  end
end

function PveView:InitDifficultyRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, self.curDifficultyMode)
  self.difficultyCtl:ResetDatas(diffs)
  if not self:ChooseBestFit(diffs) then
    self:UpdateViewData(diffs[1])
  end
  self:ChooseDiff(self.curData.staticEntranceData.staticDifficulty)
end

function PveView:OnClickHeadwear()
  local shortCutData = Table_ShortcutPower[_HearwearShortcutPowerId]
  if not shortCutData then
    return
  end
  local npcFunctionData = Table_NpcFunction[shortCutData.Event.npcfuncid]
  if npcFunctionData then
    local groupId = self.curData.staticEntranceData.groupid
    local endCall = function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveView,
        viewdata = {initialGroupId = groupId}
      })
    end
    FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, shortCutData.Event.param, endCall)
  end
end

local BattleTimeStringColor = {
  "[41c419]%s[-]",
  "[ffc945]%s[-]",
  "[cf1c0f]%s[-]"
}

function PveView:UpdateLeftTimeInfo()
  local playTimeLen = _BattleTimeData:UsedPlayTime()
  local playTotalTimeLen = _BattleTimeData:TotalPlayTime()
  local str = _BattleTimeData:UseDailyPlayTime() and ZhString.PveView_PlayTime_Daily or ZhString.PveView_PlayTime
  self.playTimeLabel.text = string.format(str, playTimeLen, playTotalTimeLen)
  self.leftTimeLine:SetActive(not ISNoviceServerType)
  self.battleTimeLabel.gameObject:SetActive(not ISNoviceServerType)
  self.leftTimeBordBg.height = ISNoviceServerType and 105 or 165
  if not ISNoviceServerType then
    local timeLen = _BattleTimeData:Timelen()
    local timeTotal = _BattleTimeData:TotalTimeLen()
    local status = _BattleTimeData:GetStatus()
    local str = ZhString.PveView_BattleTime
    self.battleTimeLabel.text = string.format(str, string.format(BattleTimeStringColor[status], timeLen), timeTotal)
  end
end

function PveView:InitServerMergeObj()
  self.serverMergeBtn1 = self:FindGO("ServerMergeBtn", self.matchBtn)
  self.serverMergeBtn1_Icon = self:FindGO("ProcessIcon", self.serverMergeBtn1):GetComponent(UIMultiSprite)
  self.serverMergeBtn2 = self:FindGO("ServerMergeBtn", self.challengeBtn)
  self.serverMergeBtn2_Icon = self:FindGO("ProcessIcon", self.serverMergeBtn2):GetComponent(UIMultiSprite)
  self.raidCombinedPart = self:FindGO("RaidCombinedInfo")
  self.closecomp = self.raidCombinedPart:GetComponent(CloseWhenClickOtherPlace)
  self.raidCombinedBG = self:FindGO("Bg", self.raidCombinedPart):GetComponent(UISprite)
  
  function self.closecomp.callBack()
    self.raidCombinedPart:SetActive(false)
  end
  
  self.raidCombinedGrid = self:FindGO("Table", self.raidCombinedPart):GetComponent(UITable)
  self.raidCombinedTipLabel = self:FindGO("RaidCombinedTipLabel", self.raidCombinedPart):GetComponent(UILabel)
  self.raidCombinedTipLabel.text = ZhString.Pve_RaidCombinedTip
  self.processPart = self:FindGO("Process", self.raidCombinedPart)
  self.processTip = self:FindGO("ProcessTip", self.processPart):GetComponent(UILabel)
  self.processTip.text = ZhString.Pve_PassedPlayer
  self.processLabel = self:FindGO("ProcessLabel", self.processPart):GetComponent(UILabel)
  self.waitProcess = self:FindGO("WaitProcess", self.raidCombinedPart)
  self.waitProcessLabel = self:FindGO("ProcessLabel", self.waitProcess):GetComponent(UILabel)
  self.waitProcessLabel.text = ZhString.Pve_WaitProcess
  self.waitCountDown = self:FindGO("WaitCountDown", self.raidCombinedPart)
  self.waitCountDownLabel = self:FindGO("WaitCountDownLabel", self.waitCountDown):GetComponent(UILabel)
  self.processSliderGO = self:FindGO("ProcessSlider", self.raidCombinedPart)
  self.processSlider = self.processSliderGO:GetComponent(UISlider)
  self.raidCombinedPart:SetActive(false)
end

function PveView:InitActivityInfo()
  self.activityEndTime = self:FindComponent("ActivityEndTime", UILabel)
end

function PveView:UpdateActivityInfo()
  local end_time = self.curData and self.curData:GetActivityEndTime()
  if not end_time then
    self:Hide(self.activityEndTime)
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(end_time - cur_time)
  if 0 < day then
    self:Show(self.activityEndTime)
    self.activityEndTime.text = string.format(ZhString.PveView_EndTime_DayHour, day, hour)
  elseif 0 < hour then
    self:Show(self.activityEndTime)
    self.activityEndTime.text = string.format(ZhString.PveView_EndTime_Hour, hour)
  elseif 0 < min then
    self:Show(self.activityEndTime)
    self.activityEndTime.text = string.format(ZhString.PveView_EndTime_Min, min)
  else
    self:Hide(self.activityEndTime)
  end
end

function PveView:InitBuyItemCell()
  self.happyShopPanel = self:FindGO("HappyShopPanel")
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"), self.happyShopPanel)
  if not go then
    return
  end
  go.transform.localPosition = LuaGeometry.GetTempVector3(185, 40, 0)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:Hide()
  local shopCfg = _PveConfig.AddPlayTimeDepositeId
  if shopCfg then
    local sType, sId = next(shopCfg)
    if sType and sId and type(sId) == "table" then
      HappyShopProxy.Instance:InitShop(Game.Myself, sId[1], sType)
    end
  end
end

function PveView:OnClickPveCardAddMaxCnt()
  local d = BagProxy.Instance:GetItemByStaticID(_AddPlayTimeItmeID)
  if not d then
    d = BagProxy.Instance:GetItemByStaticID(_AddPlayTimeItmeID, BagProxy.BagType.Storage)
    d = d or BagProxy.Instance:GetItemByStaticID(_AddPlayTimeItmeID, BagProxy.BagType.Barrow)
  end
  if d then
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        self.pveCard_addMaxCountBtnSp
      },
      applyClose = true,
      callback = function()
        BattleTimeDataProxy.QueryBattleTimelenUserCmd()
      end
    }
    sdata.funcConfig = FunctionItemFunc.GetItemFuncIds(_AddPlayTimeItmeID)
    self:ShowItemTip(sdata, self.pveCard_addMaxCountBtnSp, NGUIUtil.AnchorSide.Right, {210, 300})
  else
    local shopCfg = _PveConfig.AddPlayTimeDepositeId
    if shopCfg then
      local sType, sId = next(shopCfg)
      if sType and sId and type(sId) == "table" then
        HappyShopProxy.Instance:InitShop(Game.Myself, sId[1], sType)
        local shopData = ShopProxy.Instance:GetShopDataByTypeId(sType, sId[1])
        if shopData then
          local goods = shopData:GetGoods()
          for k, good in pairs(goods) do
            if good.id == sId[2] then
              self.buyCell:Show()
              self.buyCell:SetData(good)
              HappyShopProxy.Instance:SetSelectId(good.id)
              return
            end
          end
        end
      end
    end
  end
end

function PveView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:CancelLockCall()
    end, self)
  end
end

function PveView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function PveView:_DoSweep_PveCard(raidid, groupid, use_sweep_ticket)
  if not LocalSaveProxy.Instance:GetDontShowAgain(28112) then
    local desc = ZhString.PveShenYu .. GameConfig.CardRaid.cardraid_DifficultyName[raidid]
    MsgManager.DontAgainConfirmMsgByID(28112, function()
      ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
      FunctionPlayerPrefs.Me():SetInt("PveQuickFinish_LastDataTime", os.time())
    end, nil, nil, desc)
  else
    ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
  end
end

function PveView:_DoSweep_Crack(raidid, groupid, use_sweep_ticket)
  local msgID = self.timeType == BattleTimeDataProxy.ETime.BATTLE and 43113 or 43214
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(msgID)
  if not dont and not self:HasDifferenceTime() and not self.curData:IsFree() and BattleTimeDataProxy.Instance:CheckSwitchOn(self.timeType) then
    MsgManager.DontAgainConfirmMsgByID(msgID, function()
      ServiceFuBenCmdProxy.Instance:CallQuickFinishCrackRaidFubenCmd(raidid, use_sweep_ticket)
    end, nil, nil, self.needCostTime or tostring(self.costTime // 60))
  else
    ServiceFuBenCmdProxy.Instance:CallQuickFinishCrackRaidFubenCmd(raidid, use_sweep_ticket)
  end
end

function PveView:_DoSweep_Default(raidid, groupid, use_sweep_ticket)
  local msgID = self.timeType == BattleTimeDataProxy.ETime.BATTLE and 43113 or 43214
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(msgID)
  if not dont and not self:HasDifferenceTime() and not self.curData:IsFree() and BattleTimeDataProxy.Instance:CheckSwitchOn(self.timeType) then
    MsgManager.DontAgainConfirmMsgByID(msgID, function()
      ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, self.curBossId, use_sweep_ticket)
    end, nil, nil, self.needCostTime or tostring(self.costTime // 60))
  else
    ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, self.curBossId, use_sweep_ticket)
  end
end

function PveView:_DoSweep_StarArk(raidid, groupid, use_sweep_ticket)
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(30004)
  if not dont then
    local staticDifficulty = self.curData.staticEntranceData.staticDifficulty
    local diff = GameConfig.CardRaid.cardraid_DifficultyName[staticDifficulty] or tostring(staticDifficulty)
    local grade = self.curData:GetGradeDesc()
    MsgManager.DontAgainConfirmMsgByID(30004, function()
      ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
    end, nil, nil, diff, grade)
  else
    ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
  end
end

function PveView:ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost)
  SweepTicketUtil.ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost, function(use_sweep_ticket)
    self:DoSweep(use_sweep_ticket)
  end)
end

function PveView:ShowSweepTicketOverflowConfirm(ticketCount, requiredTime)
  SweepTicketUtil.ShowSweepTicketOverflowConfirm(ticketCount, requiredTime, function(use_sweep_ticket)
    self:DoSweep(use_sweep_ticket)
  end)
end

function PveView:TrySweep()
  if not self:CheckSweepValid() then
    return
  end
  self:LockCall()
  self:ConfirmOption(function()
    self:DoSweep(false)
  end)
end

function PveView:CheckSweepValid(ignoreSufficientTime, ignoreMsg)
  if not self.curData then
    return false
  end
  if self.curData:IsFree() then
    return true
  end
  local entranceData = self.curData.staticEntranceData
  local type = entranceData.raidType
  if not self:CanQuick() then
    if not ignoreMsg then
      local msg = GameConfig.Pve and GameConfig.Pve.SweepInvalidMsg and GameConfig.Pve.SweepInvalidMsg[type] or 43114
      MsgManager.ShowMsgByID(msg)
    end
    return false
  end
  if not ignoreSufficientTime and self.sufficientTime ~= BattleTimeDataProxy.ETime.PLAY then
    MsgManager.ShowMsgByID(43115)
    return false
  end
  return true
end

function PveView:DoSweep(use_sweep_ticket)
  if not self.curData then
    return
  end
  local entranceData = self.curData.staticEntranceData
  local type = entranceData.raidType
  local raidid = entranceData.difficultyRaid
  local groupid = entranceData.groupid
  local func = self.sweepFunc[type] or self._DoSweep_Default
  if func then
    func(self, raidid, groupid, use_sweep_ticket)
  end
end

function PveView:OnClickShopBtn()
  if not self.curData then
    return
  end
  if not self.curData.staticEntranceData:HasShopConfig() then
    return
  end
  local shop_id, shop_type = self.curData.staticEntranceData.shopid, self.curData.staticEntranceData.shoptype
  HappyShopProxy.Instance:InitShop(nil, shop_id, shop_type)
  local groupId = self.curData.staticEntranceData.groupid
  local endCall = function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveView,
      viewdata = {initialGroupId = groupId}
    })
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {onExit = endCall})
end

function PveView:AddUIEvts()
  self:AddClickEvent(self.publishBtn, function()
    if not self.curIsOpen then
      self:ShowUnlockMsg()
      return
    end
    FunctionPve.Me():OnClickPublish()
  end)
  self:AddClickEvent(self.shopBtn, function()
    self:OnClickShopBtn()
  end)
  self:AddClickEvent(self.matchBtn, function()
    if self.curData.staticEntranceData:IsAstral() and AstralProxy.Instance:IsSeasonEnd() then
      MsgManager.ShowMsgByID(43567)
      return
    end
    if not self.curIsOpen then
      self:ShowUnlockMsg()
      return
    end
    if self.curData.staticEntranceData:IsThanatos() then
      if FunctionPve.Me():DoMatch() then
        self:CloseSelf()
      end
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveMatchPopup,
        viewdata = {
          raidName = self.curData.staticEntranceData.name,
          confirmCallback = function(ai, heal)
            if FunctionPve.Me():DoMatch(ai, heal) then
              self:CloseSelf()
            end
          end
        }
      })
    end
  end)
  self:AddClickEvent(self.challengeBtn, function()
    if not self.curIsOpen then
      self:ShowUnlockMsg()
      return
    end
    local guideParam = FunctionGuide.Me():tryTakeCustomGuideParam(nil, "fake_crackraid")
    if guideParam then
      self:CloseSelf()
      return
    end
    if not (self.curData and self.curData.staticEntranceData:IsHeadWear()) or not _BattleTimeData:CheckBattleTimelen(true) then
    end
    self:ConfirmOption(function()
      if FunctionPve.Me():DoChallenge() then
        self:CloseSelf()
      end
    end)
  end)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    if self.curData then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveAchievementPopup,
        viewdata = {
          id = self.curData.id
        }
      })
    end
  end)
  self:AddClickEvent(self.serverMergeBtn1, function()
    self.raidCombinedPart:SetActive(true)
    self:ShowRaidCombinedProcess()
  end)
  self:AddClickEvent(self.serverMergeBtn2, function()
    self.raidCombinedPart:SetActive(true)
    self:ShowRaidCombinedProcess()
  end)
end

function PveView:OnEnter()
  FunctionPve.DoQuery()
  PveView.super.OnEnter(self)
end

function PveView:OnExit()
  PveView.super.OnExit(self)
  _PictureManager:UnLoadUI(dropTexture, self.dropBgTex)
  FunctionPve.Me():ClearClientData()
  TimeTickManager.Me():ClearTick(self)
  if self.pveWraplist then
    self.pveWraplist:Destroy()
  end
  if self.affixSubview then
    self.affixSubview:OnDestroy()
  end
end

function PveView:InitCatalog()
  if self._initCatalog then
    return
  end
  self._initCatalog = true
  self.loadingRoot:SetActive(false)
  self:_Init()
  self.initialGroupId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.initialGroupId
  self.initialCrackId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.initialCrackId
  self.targetData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.targetData
  self.catalogAllData = self.targetData or _EntranceProxy:GetCatalogAll()
  self.filterPanel = self:FindComponent("FilterPanel", UIPanel)
  self.filterColider = self:FindComponent("ItemTabs", BoxCollider, self.filterPanel.gameObject)
  self.filterColider.enabled = true
  self.filterArrow = self:FindComponent("tabsArrow", UISprite, self.filterColider.gameObject)
  self.raidTypeTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if not self.fromNpc and self.selectTab ~= data then
      self.selectTab = data
      self:OnTabChange(self.selectTab)
      self.fromNpc = nil ~= self.targetData
      self.filterColider.enabled = not self.fromNpc
      self.filterArrow.enabled = not self.fromNpc
    end
  end, self, self.filterPanel.depth + 2)
  self:InitFilter()
end

function PveView:ClickCrackCell(entranceid)
  local cells = self.pveWraplist:GetCells()
  local cell
  for i = 1, #cells do
    if cells[i].data and cells[i].data.staticEntranceData and cells[i].data.staticEntranceData:IsCrack() then
      cell = cells[i]
      break
    end
  end
  if cell then
    local guideCrackCell = cell:GetGridCellById(entranceid)
    if guideCrackCell then
      cell:OnClickCrackCell(guideCrackCell)
    end
  end
end

function PveView:_TryResetPveGridCellDragSv()
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  if not cells then
    return
  end
  local sv = self.raidTypeSv
  for i = 1, #cells do
    cells[i]:TrySetDragScrollView(sv)
  end
end

function PveView:OnTabChange(selectTab)
  self.selectTab = selectTab
  local catalog = selectTab.Catalog
  local result
  if catalog == 0 then
    result = self.catalogAllData
  else
    result = _EntranceProxy:GetCatalogData(catalog)
  end
  if 0 < #result then
    local crack_retEntranceId, guide_retEntranceGroupId = self:addGuideData(result)
    self.pveWraplist:ResetDatas(result)
    self:_TryResetPveGridCellDragSv()
    self.pveWraplist:ResetPosition()
    local cells = self.pveWraplist:GetCells()
    if not crack_retEntranceId and not guide_retEntranceGroupId and not self.initialGroupId and not self.initialCrackId then
      self:OnClickRaidTypeCell(cells[1], true)
      return
    end
    local initialTypeCell, guideTypeCell
    for i = 1, #cells do
      if cells[i].data then
        if self.initialGroupId and cells[i].data.staticEntranceData and cells[i].data.staticEntranceData.groupid == self.initialGroupId then
          guideTypeCell = cells[i]
          break
        end
        if self.initialCrackId or crack_retEntranceId then
          if cells[i].data.staticEntranceData and cells[i].data.staticEntranceData:IsCrack() then
            guideTypeCell = cells[i]
            break
          end
        elseif cells[i].data.staticEntranceData and cells[i].data.staticEntranceData.groupid == guide_retEntranceGroupId then
          guideTypeCell = cells[i]
          break
        end
      end
    end
    guideTypeCell = guideTypeCell or cells[1]
    self:OnClickRaidTypeCell(guideTypeCell, true)
    if self.initialCrackId then
      self:ClickCrackCell(self.initialCrackId)
    elseif crack_retEntranceId then
      self:ClickCrackCell(crack_retEntranceId)
    end
    local pveWrapScrollView = self.pveWraplist.scrollView
    local panel = pveWrapScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, guideTypeCell.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    pveWrapScrollView:MoveRelative(offset)
  end
end

function PveView:InitFilter()
  TableUtility.ArrayClear(_PopUpItemConfig)
  for k, v in pairs(_PveConfig.Catalog) do
    local data = {}
    data.Name = v
    data.Catalog = k
    table.insert(_PopUpItemConfig, data)
  end
  self.raidTypeTabs:SetData(_PopUpItemConfig)
  local vCatalog = self.viewdata.viewdata and self.viewdata.viewdata.catalog
  local catalogStr = vCatalog and _PveConfig.Catalog[vCatalog]
  if catalogStr then
    self.raidTypeTabs:SetValue(catalogStr)
  end
end

function PveView:OnClickRewardItem(cellctl)
  local data = cellctl.data
  if data == PveDropItemCell.Empty then
    return
  end
  if cellctl and cellctl ~= self.chooseReward then
    local stick = cellctl.icon
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function PveView:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function PveView:OnClickDifficulty(cell)
  local data = cell.data
  if not data then
    return
  end
  if data == PveEntranceProxy.EmptyDiff then
    return
  end
  if self.curData and self.curData.id == data.id then
    return
  end
  self:UpdateViewData(data)
  self:ChooseDiff(data.staticEntranceData.staticDifficulty)
  self:ShowRaidCombinedProcess()
end

function PveView:CanQuick()
  if not self.curData then
    return
  end
  if self.curBossId and self.curBossId > 0 then
    return PveEntranceProxy.Instance:CheckBossCanQuick(self.curBossId)
  end
  return self.curData:GetQuick()
end

function PveView:OnClickPveBossCell(cell)
  local data = cell.data
  if not data then
    return
  end
  if not self.curData then
    return
  end
  if self.curBossId == data then
    return
  end
  self.curBossId = data
  FunctionPve.Me():SetServerBossid(data)
  self.costTime = self.curData:GetStaticCostTime()
  self.monsterIndex = 1
  self:UpdateRewardMonster()
  self:ChooseBoss(data)
  self:UpdateOptionBtn()
  self:UpdateContentLabel()
end

function PveView:UpdateViewData(data)
  if self.curData and data and self.curData.id == data.id then
    return
  end
  self.curData = data
  TipsView.Me():TryShowGeneralHelpByHelpId(self.curData.staticEntranceData.staticData.HelpID, self.raidHelpBtn)
  self.curIsOpen = _EntranceProxy:IsOpen(data.id)
  local isBoss = data.staticEntranceData:IsBoss()
  if not isBoss then
    self.curBossId = nil
    self.initialBossDifficulty = nil
    FunctionPve.Me():SetServerBossid(nil)
    self.costTime = data:GetStaticCostTime()
  end
  FunctionPve.Me():SetCurPve(data.staticEntranceData)
  self.nameLab.text = data.staticEntranceData.name
  local isRoadOfHero = data.staticEntranceData:IsRoadOfHero()
  self.root:SetActive(not isRoadOfHero)
  self.heroRoadViewRoot:SetActive(isRoadOfHero)
  if not isRoadOfHero then
    self:UpdateOptionBtn()
    self:UpdateContentLabel()
    self.monsterIndex = 1
    self:UpdateRewardMonster()
    self:UpdateAchieve()
    self:UpdateCurRaidRoot()
    self:UpdateAstral()
    self:UpdateActivityInfo()
    self.roguelikeSkillHandbookBtn:SetActive(data.staticEntranceData:IsSpaceTimeIllusion())
  end
end

local BattleTimeStringColor = {
  [1] = "[555b6e]%d[-]",
  [2] = "[E4593D]%d[-]"
}
local _LeftRewardZhString = {
  [PveRaidType.GuildRaid] = ZhString.PveView_LeftTime_Boss,
  [PveRaidType.DeadBoss] = ZhString.PveView_LeftTime_DeadBoss
}

function PveView:_SetContent_RecommendPlayerNum(param, label)
  label.color = _NewBlackColor
  self.pveCard_addMaxCountBtn.gameObject:SetActive(false)
  label.text = string.format(ZhString.Pve_RecommendPlayerNum, param)
end

function PveView:_SetContent_LeftRewardCount(_, label)
  label.color = _NewBlackColor
  local raidType = self.curData.staticEntranceData.raidType
  local leftRewardStr = _LeftRewardZhString[raidType] or ZhString.PveView_LeftTime_Common
  local left = self.curData:GetLeftRewardTime(true)
  local max = self.curData:GetMaxChallengeCnt(true)
  label.text = string.format(leftRewardStr, left, max)
  if left <= 0 then
    label.color = _ChallengeRedColor
  end
end

function PveView:_SetContent_CostTime(_, label)
  label.color = _NewBlackColor
  if not self.costTime then
    return
  end
  self.pveCard_addMaxCountBtn.gameObject:SetActive(self.curIsOpen == true and nil ~= _AddPlayTimeItmeID)
  self.sufficientTime = BattleTimeDataProxy.ETime.BATTLE
  local timeType
  if ISNoviceServerType then
    timeType = BattleTimeDataProxy.ETime.PLAY
    local battleTime = _BattleTimeData:GetLeftTime(timeType, true)
    if battleTime >= self.costTime then
      self.sufficientTime = BattleTimeDataProxy.ETime.PLAY
    end
  else
    timeType = _BattleTimeData:GetGameTimeSetting()
    local battleTime = _BattleTimeData:GetLeftTime(timeType, true)
    if battleTime >= self.costTime then
      self.sufficientTime = BattleTimeDataProxy.ETime.PLAY
    else
      local repTimeType = BattleTimeDataProxy.ReverseType[timeType]
      local repBattleTime = _BattleTimeData:GetLeftTime(repTimeType, true)
      if repBattleTime >= self.costTime then
        self.sufficientTime = BattleTimeDataProxy.ETime.PLAY
        timeType = repTimeType
      end
    end
  end
  self.timeType = timeType
  local str = timeType == BattleTimeDataProxy.ETime.PLAY and ZhString.PveView_CostPlayTime or ZhString.PveEntranceContent_3
  if self.curData and self.curData:IsFree() then
    label.text = string.format(str, ZhString.PveView_FreeTime)
  else
    label.text = string.format(str, string.format(BattleTimeStringColor[self.sufficientTime], self.costTime // 60))
  end
  ColorUtil.WhiteUIWidget(label)
  self:SetDifferenceTime()
  if self:HasDifferenceTime() then
    self.sufficientTime = BattleTimeDataProxy.ETime.PLAY
  end
end

function PveView:_SetContent_EquipRate(param, label)
  label.color = _NewBlackColor
  local max_challengeCount = param
  local server_challengeCount = ISNoviceServerType and PveEntranceProxy.Instance:GetCrackPassTime() or self.curData:GetPassTime()
  local str = ISNoviceServerType and ZhString.PveEntranceContent_4_Novice or ZhString.PveEntranceContent_4
  local num = math.max(max_challengeCount - server_challengeCount, 0)
  label.text = string.format(str, num, max_challengeCount)
  if max_challengeCount <= server_challengeCount then
    label.color = _ChallengeRedColor
  end
end

function PveView:SetContentLabel(type, param, label)
  local setFunc = type and self.setContentFunc[type]
  if setFunc then
    setFunc(self, param, label)
  end
end

function PveView:SetDifferenceTime()
  self.differenceCostTime = nil
  if self.costTime and not ISNoviceServerType then
    local time = _BattleTimeData:GetLeftTime(nil, true)
    if 0 < time and time < self.costTime then
      local timeType = _BattleTimeData:GetGameTimeSetting()
      local reverseTime = _BattleTimeData:GetLeftTime(BattleTimeDataProxy.ReverseType[timeType], true)
      if reverseTime + time >= self.costTime then
        self.differenceCostTime = (self.costTime - time) // 60
      end
    end
  end
end

function PveView:HasDifferenceTime()
  return nil ~= self.differenceCostTime and self.costTime ~= nil
end

function PveView:UpdateContentLabel()
  if self.curData then
    self.recommendPlayerNumLab.text = ""
    self.challengeNumLab.text = ""
    self:SetContentLabel(self.curData.staticEntranceData.staticData.RecommendPlayerNum, self.curData.staticEntranceData.staticData.PlayerNumCount, self.recommendPlayerNumLab)
    self:SetContentLabel(self.curData.staticEntranceData.staticData.ChallengeContent, self.curData.staticEntranceData.staticData.ChallengeCount, self.challengeNumLab)
  end
end

function PveView:UpdateRewardMonster()
  self:UpdateItemDropList()
  self:UpdateMonsterModel()
end

function PveView:ShowUnlockMsg()
  if not self.curData then
    return
  end
  local unlockMsg = self.curData.staticEntranceData.unlockMsgId
  if unlockMsg and unlockMsg ~= 0 then
    MsgManager.ShowMsgByID(unlockMsg)
  else
    redlog("策划未配置 unlockMsgId.  PveRaidEntrance表ID ： ", id)
  end
end

function PveView:UpdateOptionBtn()
  local id = self.curData and self.curData.id
  if not id then
    return
  end
  local open = self.curIsOpen
  if not open then
    self:ShowUnlockMsg()
  end
  self:UpdateMultiReward()
  self.shopBtn:SetActive(self.curData.staticEntranceData:HasShopConfig() and open)
  local goalid = self.curData.staticEntranceData.staticData.Goal or 0
  self:_UpdateSweep()
  self:_UpdateChallenge(open)
  self:_UpdatePublish(open)
  self:_UpdateMatch(open, goalid)
end

function PveView:_UpdateChallenge(open)
  self.challengeBtnSp.spriteName = open and "com_btn_2" or "com_btn_13"
  self.challengeBtnLab.effectColor = open and ColorUtil.ButtonLabelOrange or Color(0.36470588235294116, 0.3568627450980392, 0.3568627450980392, 1)
end

function PveView:_UpdatePublish(open)
  if not self.curData then
    return
  end
  local show_publish = self.curData:CheckPublishShow()
  if show_publish then
    self:Show(self.publishBtn)
    self.publishBtnSp.spriteName = open and _sweepBtn.sp[1] or _sweepBtn.sp[2]
    self.publishBtnLab.effectColor = open and _sweepBtn.lab[1] or _sweepBtn.lab[2]
  else
    self:Hide(self.publishBtn)
  end
end

function PveView:_UpdateMatch(open, goal)
  if 0 < goal then
    self:Show(self.matchBtn)
    self.matchBtnSp.spriteName = open and _sweepBtn.sp[1] or _sweepBtn.sp[2]
    self.matchBtnLab.effectColor = open and _sweepBtn.lab[1] or _sweepBtn.lab[2]
  else
    self:Hide(self.matchBtn)
  end
end

local Sweep_PublicXAxis = {
  [PveRaidType.Headwear] = 1,
  [PveRaidType.Thanatos] = 1,
  [PveRaidType.MultiBoss] = 1,
  [PveRaidType.Comodo] = 1
}

function PveView:_UpdateSweep()
  local sweep_open = self.curData:CheckSweepShow()
  self.sweepBtn:SetActive(sweep_open)
  local bgHeight
  if sweep_open then
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.sweepBtn)
    local raid_type = self.curData.staticEntranceData.raidType
    x = nil ~= Sweep_PublicXAxis[raid_type] and self.initialPublishXAxis or self.initialSweepXAxis
    LuaGameObject.SetLocalPositionGO(self.sweepBtn, x, y, z)
    if self:CanQuick() then
      ColorUtil.WhiteUIWidget(self.sweepSp)
      self.sweepSp.spriteName = _sweepBtn.sp[1]
      self.sweepBtnLab.effectColor = _sweepBtn.lab[1]
    else
      self.sweepSp.spriteName = _sweepBtn.sp[2]
      self.sweepBtnLab.effectColor = _sweepBtn.lab[2]
    end
    local check_leftSweepShow = self.curData:CheckExtraSweepShow()
    if check_leftSweepShow then
      local max = self.curData:GetConfigMaxChallengeCount() - 1
      local pass_time = self.curData:GetPassTime() - 1
      local left = math.max(0, max - pass_time)
      self:Show(self.extraSweepRoot)
      self.leftSweepText.text = string.format(ZhString.PveView_LeftTime_Sweep, left, max)
      self.leftSweepText.color = left <= 0 and _ChallengeRedColor or _NewBlackColor
      self:_SetContent_CostTime(nil, self.sweepCostText)
      bgHeight = labelBgHeight_Extra
    else
      self:Hide(self.extraSweepRoot)
      bgHeight = labelBgHeight
    end
  else
    self:Hide(self.extraSweepRoot)
    bgHeight = labelBgHeight
  end
  self.labelBg.height = bgHeight
  local reset = self.curData.staticEntranceData.staticData.MaxResetTime or 0
  self.resetFubenBtn:SetActive(sweep_open and 0 < reset)
end

function PveView:UpdateRaidCombinedBtn()
  local id = self.curData and self.curData.id
  if not id then
    return
  end
  local status = _EntranceProxy:GetRaidCombinedStatus(id)
  xdlog("副本进度同步", status, id)
  self.serverMergeBtn1:SetActive(status == 1 or status == 2 or status == 3)
  self.serverMergeBtn1_Icon.CurrentState = status - 1
  self.serverMergeBtn2:SetActive(status == 1 or status == 2 or status == 3)
  self.serverMergeBtn2_Icon.CurrentState = status - 1
end

function PveView:_updatePveCard(open)
  if self.curData.staticEntranceData:IsHardMode() and not self.curData:IsPickup() then
    self:Show(self.raidTipRoot)
    local cur_layer = self.curData.staticEntranceData.difficultyIgoreType
    local max_layer = _EntranceProxy:GetCurMaxPickupLayer(self.curData.staticEntranceData.groupid, self.curDifficultyMode, cur_layer)
    if max_layer == cur_layer then
      self.raidTipLab.text = string.format(ZhString.Pve_CardDesc_Single, cur_layer)
    else
      self.raidTipLab.text = string.format(ZhString.Pve_CardDesc, max_layer, cur_layer)
    end
  else
    self:Hide(self.raidTipRoot)
  end
end

function PveView:_updateRugelike(open)
  self.roguelikeLoadBtn:SetActive(open)
end

function PveView:_updateCrack(open)
  if ISNoviceServerType and not self.curData.isFirstPass then
    self:Show(self.raidTipRoot)
    self.raidTipLab.text = ZhString.Pve_CrackDesc
  else
    self:Hide(self.raidTipRoot)
  end
end

function PveView:_updateEndlessTower(open)
  if ISNoviceServerType then
    self:Hide(self.endlessTowerRoot)
  else
    self:Show(self.endlessTowerRoot)
    self.endlessTowerLaunchBtn:SetActive(open)
  end
  local rewardLayer = PveEntranceProxy.Instance:GetEndlessRewardLayer()
  if rewardLayer and 0 < rewardLayer then
    self.raidTipLab.text = string.format(ZhString.Pve_EndlessTowerTip_Layer, rewardLayer)
  else
    self.raidTipLab.text = ZhString.Pve_EndlessTowerTip
  end
end

function PveView:_updateHeadWear(open)
  self.headwearShopBtn:SetActive(open)
  self.raidTipLab.text = ZhString.Pve_Headwear_Tip
end

function PveView:_updateGroupTog()
  local isnormal = self.curDifficultyMode == Pve_Difficulty_Type.Normal
  self.difficultyModeTog1Bg.spriteName = isnormal and _PveGroupTogSp[1] or _PveGroupTogSp[2]
  self.difficultyModeTog2Bg.spriteName = isnormal and _PveGroupTogSp[2] or _PveGroupTogSp[1]
  self.difficultyModeTog1Lab.color = isnormal and _PveGroupTogColor[1] or _PveGroupTogColor[2]
  self.difficultyModeTog2Lab.color = isnormal and _PveGroupTogColor[2] or _PveGroupTogColor[1]
end

function PveView:UpdateServerInfoData()
  self:InitCatalog()
  self:UpdateTypeUnlock()
  if self.curData and self.curData.staticEntranceData:IsRoadOfHero() then
    return
  end
  self:UpdateContentLabel()
  self:UpdateDiff()
  self:UpdateMultiReward()
  self:_UpdateSweep()
end

function PveView:UpdateAffix()
  if self.affixSubview then
    self.affixSubview:UpdateView()
  end
  self:UpdateArkBuff()
end

function PveView:UpdateDiff()
  if not self.curData then
    return
  end
  if self.curData.staticEntranceData:IsBoss() then
    if self.bossCtl then
      local diffs = self.curData:GetServerBoss(self.curDifficultyMode)
      self.bossCtl:ResetDatas(diffs)
    end
  else
    if not self.difficultyCtl then
      return
    end
    local type = self.curData.staticEntranceData.raidType
    local layer
    if self.twoDifficultyModeRaid[type] then
      layer = self.curDifficultyMode
    end
    local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, layer)
    self.difficultyCtl:ResetDatas(diffs)
  end
end

function PveView:UpdateTypeUnlock()
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateUnlock()
  end
end

function PveView:ReverseCrack(force_reverse)
  self.gridTypeCell:ReverseCrack(force_reverse)
  self.pveWraplist:Layout()
end

function PveView:OnClickRaidTypeCell(cell, auto)
  local pveData = cell.data
  if not pveData then
    return
  end
  local entranceData = pveData.staticEntranceData
  local isGridType = entranceData:IsCrack() or entranceData:IsBoss() or entranceData:IsRoadOfHero() or entranceData:IsAstral() or entranceData:IsMemoryRaid()
  local clickSameTypeCell = self.curData and self.curData.staticEntranceData.groupid == entranceData.groupid
  local clickDiffRaid = self.curData and self.curData.staticEntranceData.raidType ~= entranceData.raidType
  if clickSameTypeCell or clickDiffRaid then
    if isGridType then
      if clickDiffRaid and self.gridTypeCell then
        self:ReverseCrack(true)
      end
      self.gridTypeCell = cell
      if not auto then
        self:ReverseCrack()
      end
    end
    if not clickDiffRaid then
      return
    end
  end
  local isNew = _RedTipProxy:IsNew(ERedSys, entranceData.groupid)
  if isNew then
    _RedTipProxy:RegisterUI(ERedSys, self.checkBtn, 8, {-6, -2})
  else
    _RedTipProxy:UnRegisterUI(ERedSys, self.checkBtn)
  end
  if isGridType then
    self.gridTypeCell = cell
  end
  self:UpdateViewData(pveData)
  self:SetChooseRaidType(entranceData.id)
  local raidType = self.curData.staticEntranceData.raidType
  self.bossGrid.gameObject:SetActive(entranceData:IsBoss())
  self.difficultyGrid.gameObject:SetActive(not entranceData:IsBoss())
  if self.twoDifficultyModeRaid[raidType] then
    if entranceData:IsBoss() then
      self.curDifficultyMode = Pve_Difficulty_Type.Normal
      self:ReInitBossDiffRaid()
    else
      local temp_difficulty
      local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, Pve_Difficulty_Type.Difficult)
      for i = #diffs, 1, -1 do
        if type(diffs[i]) == "table" and PveEntranceProxy.Instance:IsOpen(diffs[i].id) then
          temp_difficulty = Pve_Difficulty_Type.Difficult
          break
        end
      end
      self.curDifficultyMode = temp_difficulty or Pve_Difficulty_Type.Normal
      self:InitDifficultyRaid()
    end
    self:_updateGroupTog()
  else
    self.curDifficultyMode = nil
    if entranceData:IsRoadOfHero() then
      if not self.heroRoadSubView then
        self.heroRoadSubView = self:AddSubView("HeroRoadView", HeroRoadView)
      end
      self.heroRoadSubView:RefreshView(entranceData.groupid)
    else
      self:InitDiffRaid()
    end
  end
end

function PveView:InitDiffRaid()
  local diffs = _EntranceProxy:GetDifficultyData(self.curData.staticEntranceData.groupid, self.curDifficultyMode)
  self.difficultyCtl:ResetDatas(diffs)
  self:ChooseBestFit(diffs)
  self:ChooseDiff(self.curData.staticEntranceData.staticDifficulty)
end

function PveView:ReInitBossDiffRaid(diffData)
  local diffs = diffData or self.curData:GetServerBoss(self.curDifficultyMode)
  self.bossCtl:ResetDatas(diffs)
  self.bossCtl:ResetPosition()
  local cells = self.bossCtl:GetCells()
  if cells and 0 < #cells then
    self.monsterIndex = 1
    self:OnClickPveBossCell(cells[1])
  end
end

function PveView:ChooseBestFit(diffs)
  self.difficultyCtl:ResetPosition()
  local diffCells = self.difficultyCtl:GetCells()
  for i = #diffs, 1, -1 do
    if self.initialEntranceData and self.initialEntranceData.id == diffs[i].id or type(diffs[i]) == "table" and diffs[i]:CheckPass() and diffs[i].open or type(diffs[i]) == "table" and diffs[i]:CheckAccPass() then
      if 4 < i then
        local diffScrollView = self.difficultyCtl.scrollView
        local panel = diffScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, diffCells[i].gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(offset.x, 0, 0)
        diffScrollView:MoveRelative(offset)
      end
      if self.curData.staticEntranceData:IsAstral() then
        local diff = i < #diffs and diffs[i + 1] ~= PveEntranceProxy.EmptyDiff and diffs[i + 1] or diffs[i]
        self:UpdateViewData(diff)
      else
        self:UpdateViewData(diffs[i])
      end
      return true
    end
  end
  return false
end

function PveView:SetChooseRaidType(id)
  if not self.pveWraplist then
    return
  end
  local cells = self.pveWraplist:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end

function PveView:ChooseDiff(id)
  local cells = self.difficultyCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end

function PveView:ChooseBoss(id)
  local cells = self.bossCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(id)
  end
end

function PveView:UpdateItemDropList()
  if not self.curData then
    return
  end
  local hasRewardTip = nil ~= self.raidTip[self.curData.staticEntranceData.raidType]
  local result = self.curData:TryGetExtraRewards() or {}
  local dropItems = self.curData:GetAllRewards(self.curBossId)
  TableUtil.InsertArray(result, dropItems)
  local emptyNum = 15 - #result
  if 0 < emptyNum then
    for i = 1, emptyNum do
      result[#result + 1] = PveDropItemCell.Empty
    end
  end
  self.itemCtl:ResetDatas(result)
  local buffID = ReturnActivityProxy.Instance:GetReturnBufferID()
  if buffID and Game.Myself.data:HasBuffID(buffID) then
    local buffConfig = Table_Buffer[buffID]
    local buffEffect = buffConfig and buffConfig.BuffEffect
    local baseMuliply, jobMultiply = buffEffect.BaseExpPer, buffEffect.JobExpPer
    local cells = self.itemCtl:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data.staticData then
        if cells[i].data.staticData.id == 300 then
          cells[i]:SetReturnExtra(1 + baseMuliply)
        elseif cells[i].data.staticData.id == 400 then
          cells[i]:SetReturnExtra(1 + jobMultiply)
        end
      end
    end
  end
  self.itemCtl:ResetPosition()
end

function PveView:UpdateMonsterModel()
  if not self.curData then
    return
  end
  self.monstersData = self.curData:GetMonsters(self.curBossId)
  if not self.monstersData then
    return
  end
  local count = #self.monstersData
  self:SetMonsterData()
  self.nextMonsterBtn:SetActive(1 < count)
  self.preMonsterBtn:SetActive(1 < count)
end

function PveView:SetMonsterData()
  if not self.monsterIndex then
    return
  end
  self.curMonsterId = self.monstersData[self.monsterIndex]
  self.monsterDetailBtn:SetActive(nil ~= Table_PveMonsterPreview[self.curMonsterId])
  local raidTypeConfig = GameConfig.Pve.RaidType[self.curData.staticEntranceData.groupid]
  if not raidTypeConfig then
    redlog("未配置 GameConfig.Pve.RaidType，错误GroupID", self.curData.staticEntranceData.groupid)
    return
  end
  local modelTex = raidTypeConfig.modelTexture
  local name = Table_Monster[self.curMonsterId] and Table_Monster[self.curMonsterId].NameZh or ""
  local natureIcon = Table_Monster[self.curMonsterId] and Table_Monster[self.curMonsterId].Nature or ""
  self.monsterNameLab.text = string.format(ZhString.Pve_MonsterIndex, self.monsterIndex, #self.monstersData, name)
  IconManager:SetUIIcon(natureIcon, self.monsterNature)
  self.monsterNameLab.gameObject:SetActive(self.curMonsterId ~= nil)
  self.monsterNature.gameObject:SetActive(self.curMonsterId ~= nil)
  self.modelTexture:SetData(self.curMonsterId, modelTex)
end

function PveView:AddEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPveCardOpenStateFubenCmd, self.UpdateServerInfoData)
  self:AddListenEvt(PVEEvent.SyncPvePassInfo, self.UpdateServerInfoData)
  self:AddListenEvt(PVEEvent.AutoCreatTeamForInvite, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.UserEventDepositCardInfo, self.UpdateMonthCard)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleTimelen)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, self.HandleSyncPvePassInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd, self.HandleAddPveCardTimes)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd, self.UpdateAchieve)
  self:AddListenEvt(ServiceEvent.RaidCmdQueryRaidServerCombinedCmd, self.UpdateRaidCombinedBtn)
  self:AddListenEvt(ServiceEvent.SceneTipGameTipCmd, self.UpdateRedTips)
  self:AddListenEvt(PVEEvent.EndlessLaunchSuccess, self.CloseSelf)
  self:AddListenEvt(UICloseEvent.CloseSubView, self.CloseSelf)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.HandleQueryShopConfig)
end

function PveView:UpdateAchieve()
  if not self.curData then
    return
  end
  local needShowAchievement = #self.curData.staticEntranceData.staticData.ShowAchievement > 0
  self.starRoot:SetActive(needShowAchievement)
  self.checkBtn:SetActive(needShowAchievement)
  if not needShowAchievement then
    return
  end
  local achievesCount = _EntranceProxy:GetGroupAchieve(self.curData.staticEntranceData.groupid)
  for i = 1, 3 do
    if i <= achievesCount then
      self.stars[i].CurrentState = 0
    else
      self.stars[i].CurrentState = 1
    end
  end
end

function PveView:HandleSyncPvePassInfo()
  if self.curData and self.curData.staticEntranceData:IsRoadOfHero() then
    if self.heroRoadSubView then
      self.heroRoadSubView:RefreshView(self.curData.staticEntranceData.groupid)
    end
  else
    self:HandleAddPveCardTimes()
  end
end

function PveView:HandleAddPveCardTimes()
  self:UpdateContentLabel()
  self:UpdateLeftTimeInfo()
end

function PveView:ShowRaidCombinedProcess()
  local raidid = self.curData.id
  if not raidid then
    return
  end
  local status, raidCombinedInfo = _EntranceProxy:GetRaidCombinedStatus(raidid)
  TimeTickManager.Me():ClearTick(self, 2)
  if status == ServerMergeStatus.InProcess then
    self.processPart:SetActive(true)
    self.waitProcess:SetActive(false)
    self.waitCountDown:SetActive(false)
    self.processSliderGO:SetActive(true)
    self.processSlider.value = raidCombinedInfo.passnum / raidCombinedInfo.neednum
    self.processLabel.text = raidCombinedInfo.passnum .. "/" .. raidCombinedInfo.neednum
  elseif status == ServerMergeStatus.Wait then
    self.processPart:SetActive(false)
    self.waitProcess:SetActive(true)
    self.waitCountDown:SetActive(false)
    self.processSliderGO:SetActive(true)
    self.processSlider.value = 1
  elseif status == ServerMergeStatus.CountDown then
    self.processPart:SetActive(false)
    self.waitProcess:SetActive(false)
    self.waitCountDown:SetActive(true)
    self.processSliderGO:SetActive(false)
    self.raidCombinedTimestamp = raidCombinedInfo.opentick
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshRaidCombinedCountDown, self, 2)
  else
    self.raidCombinedPart:SetActive(false)
    return
  end
  self.raidCombinedGrid:Reposition()
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.raidCombinedGrid.gameObject.transform)
  local height = bound.size.y + 74
  self.raidCombinedBG.height = height
end

function PveView:RefreshRaidCombinedCountDown()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.raidCombinedTimestamp)
  if leftDay <= 0 and leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    TimeTickManager.Me():ClearTick(self, 2)
    self:UpdateOptionBtn()
    self:ShowRaidCombinedProcess()
  else
    self.waitCountDownLabel.text = string.format(ZhString.Pve_CountDown, leftDay, leftHour, leftMin, leftSec)
  end
end

function PveView:HandleTimelen(note)
  self:UpdateLeftTimeInfo()
  self:UpdateContentLabel()
  if self.heroRoadSubView then
    self.heroRoadSubView:RefreshView()
  end
end

function PveView:UpdateMonthCard(data)
end

function PveView:addGuideData(list)
  local guideParam = FunctionGuide.Me():tryTakeCustomGuideParam(nil, "trace_crackraid")
  local crack_list = _EntranceProxy:GetAllCrackPveData()
  local crack_retEntranceId, guide_retEntranceGroupId
  if guideParam then
    if guideParam.fitlevel then
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      local recommendMaxLv = 0
      local recommendLevel
      for k, entranceData in pairs(crack_list) do
        recommendLevel = entranceData.staticEntranceData.staticData.RecommendLv
        if mylv > recommendLevel and recommendMaxLv < recommendLevel then
          recommendMaxLv = recommendLevel
          crack_retEntranceId = entranceData.id
        end
      end
    elseif guideParam.groupid then
      for k, entranceData in pairs(crack_list) do
        if entranceData.staticEntranceData and entranceData.staticEntranceData.staticData and entranceData.staticEntranceData.staticData.GroupId == guideParam.groupid then
          crack_retEntranceId = entranceData.id
          break
        end
      end
    end
    if crack_retEntranceId then
      return crack_retEntranceId
    end
  end
  if GameConfig.SpecialGuide_Pve_QuestId == nil or 0 >= #GameConfig.SpecialGuide_Pve_QuestId then
    return nil, nil
  end
  local questData
  for _, v in ipairs(GameConfig.SpecialGuide_Pve_QuestId) do
    questData = FunctionGuide.Me():checkHasGuide(v)
    if questData then
      break
    end
  end
  if questData ~= nil then
    local guideId = questData.params.guideID
    local tbGuide = Table_GuideID[guideId]
    if tbGuide ~= nil and tbGuide.SpecialID then
      for k, entranceData in pairs(crack_list) do
        if entranceData.groupid == tbGuide.SpecialID then
          crack_retEntranceId = entranceData.id
          break
        end
      end
      if crack_retEntranceId and 0 < crack_retEntranceId then
        return crack_retEntranceId
      end
      for k, v in pairs(list) do
        if v.staticEntranceData and v.staticEntranceData.staticData ~= nil and v.staticEntranceData.staticData.GroupId == tbGuide.SpecialID then
          v.staticEntranceData.guideButtonId = tbGuide.ButtonID
          v.questData = questData
          guide_retEntranceGroupId = v.staticEntranceData.staticData.GroupId
          break
        end
      end
    end
  end
  return nil, guide_retEntranceGroupId
end

function PveView:ConfirmOption(handler)
  if self:HasDifferenceTime() then
    local timeType = _BattleTimeData:GetGameTimeSetting()
    local id = timeType == BattleTimeDataProxy.ETime.PLAY and 43242 or 43243
    MsgManager.ConfirmMsgByID(id, handler, nil, nil, self.differenceCostTime)
    return
  end
  handler()
end

function PveView:UpdateRedTips()
  local cells = self.pveWraplist and self.pveWraplist:GetCells()
  if cells then
    for _, cell in ipairs(cells) do
      cell:UpdateRedtip()
    end
  end
end

function PveView:OnClickPveResetBtn()
  if PveEntranceProxy.Instance:CanResetRaidFuben(self.curData.id) then
    MsgManager.ConfirmMsgByID(26279, function()
      ServiceFuBenCmdProxy.Instance:CallResetRaidFubenCmd()
    end, nil, nil)
  end
end

function PveView:_updateExtraLayer()
  local showKillBoss = self.curData.staticEntranceData.showKillBoss
  if showKillBoss and 0 < showKillBoss then
    self:Show(self.raidTipRoot)
    local kill_boss_num = self.curData.kill_boss_num
    self.raidTipLab.text = string.format(ZhString.Pve_BossProgressDesc, kill_boss_num, showKillBoss)
  else
    self:Hide(self.raidTipRoot)
  end
end

function PveView:HandleMyDataChange()
  if self.heroRoadSubView then
    self.heroRoadSubView:HandleMyDataChange()
  end
end

function PveView:HandleQueryShopConfig()
  if self.heroRoadSubView then
    self.heroRoadSubView:HandleQueryShopConfig()
  end
end

function PveView:UpdateAstral()
  local isAstral = self.curData.staticEntranceData:IsAstral()
  self.astralGraphBtn:SetActive(isAstral)
  self.astralPrayBtn:SetActive(isAstral)
  self.challengeBtn:SetActive(not isAstral)
  self.gotoBtn:SetActive(isAstral)
end
