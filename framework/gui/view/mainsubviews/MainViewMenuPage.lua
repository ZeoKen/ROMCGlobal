autoImport("GainWayTip")
autoImport("SystemUnLockView")
autoImport("TeamPwsMatchPopUp")
autoImport("MatchPreparePopUp")
autoImport("GroupOnMarkView")
MainViewMenuPage = class("MainViewMenuPage", SubView)
autoImport("PveInvitePopUp")
autoImport("PveGroupInvitePopUp")
autoImport("MainViewButtonCell")
autoImport("PersonalPicturePanel")
autoImport("DoujinshiButtonCell")
autoImport("RememberLoginUtil")
autoImport("DownloadCell")
local CameraBtnStyles = {
  [1] = {
    iconActive = true,
    text = "",
    Msg = ZhString.LockCameraCtl
  },
  [2] = {
    iconActive = false,
    text = "2.5D",
    Msg = ZhString.Half3DCtl
  },
  [3] = {
    iconActive = false,
    text = "3D",
    Msg = ZhString.Real3DCtl
  }
}
local IsCameraOptionUnlock = function(optType)
  local mapID = Game.MapManager:GetMapID()
  local cameraLock = Table_Map[mapID] and Table_Map[mapID].CameraLock
  cameraLock = cameraLock or 0
  return cameraLock & 1 << optType - 1 == 0
end
local redTip_LotteryActivity = SceneTip_pb.EREDSYS_LOTTERY_ACTIVITY
local redTip_LotteryFree = SceneTip_pb.EREDSYS_LOTTERY_FREE
local redTip_DailyReward = SceneTip_pb.EREDSYS_LOTTERY_DAILY_REWARD

function MainViewMenuPage:Init()
  self:InitUI()
  self:MapViewInterests()
end

local PREFAB_RES_PATH = "part/MainViewMoreBord"
local tempVector3 = LuaVector3.Zero()
local tempRot = LuaQuaternion()

function MainViewMenuPage:InitMoreBord()
  self.moreBtn = self:FindGO("MoreButton")
  self:RegisterGuideTarget(ClientGuide.TargetType.mainview_morebutton, self.moreBtn)
  self.bordParent = self:FindGO("MoreBordParent")
  self.moreBord = self:FindGO("MoreBord", self.bordParent)
  if self.moreBord == nil then
    self.moreBord = self:LoadPreferb(PREFAB_RES_PATH, self.bordParent, true)
  end
  self.container:RegisterChildPopObj(self.moreBord)
  self.moreBord:SetActive(false)
  self:RegisterGuideTarget(ClientGuide.TargetType.mainview_morebord, self.moreBord)
  local DoujinshiNode = self:FindGO("DoujinshiNode")
  self:AddClickEvent(self.moreBtn, function()
    self:PlayUISound(GameConfig.UIAudio.More)
    local miniMap = self.container.miniMapPage
    if miniMap.bigmapWindow.active and not miniMap:ActiveMapBord(false) then
      return
    end
    DoujinshiNode.gameObject:SetActive(false)
    if self.addCreditNode then
      self.addCreditNode:SetActive(false)
    end
    if self.moreBord.activeSelf then
      self:HideMoreBord()
    else
      self:ShowMoreBord()
    end
  end, {hideClickSound = true})
  self.clickOtherPlace = self.moreBord:GetComponent(CloseWhenClickOtherPlace)
  
  function self.clickOtherPlace.callBack()
    self:ResizeMoreBordBg()
  end
  
  self.moreBord_Bg = self:FindComponent("Background", UISprite, self.moreBord)
end

function MainViewMenuPage:ShowMoreBord()
  self:ResizeMoreBordBg()
  self.moreBord:SetActive(true)
end

function MainViewMenuPage:HideMoreBord()
  self.moreBord:SetActive(false)
end

function MainViewMenuPage:ResizeMoreBordBg()
  local cellCount = 0
  local cells = self:GetMoreButtonCells()
  for i = 1, #cells do
    if cells[i] and cells[i].gameObject and cells[i].gameObject.activeSelf then
      cellCount = cellCount + 1
    end
  end
  self.moreBord_Bg.width = 48 + 109 * math.min(cellCount, 4)
  self.moreBord_Bg.height = math.ceil(cellCount / 4) * 101 + 53
end

function MainViewMenuPage:InitUI()
  self:InitMoreBord()
  self.moreGrid = self:FindComponent("Grid", UIGrid, self.moreBord)
  self.topRFuncGrid = self:FindComponent("TopRightFunc", UIGrid)
  self.topRFuncGrid2 = self:FindComponent("TopRightFunc2", UIGrid)
  self.disneyMusicEntrance = self:FindGO("DisneyMusicEntrance")
  self.disneyMusicEntranceLab = self:FindComponent("Label", UILabel, self.disneyMusicEntrance)
  self.disneyMusicEntranceLab.effectStyle = UILabel.Effect.Outline8
  self.disneyMusicEntranceLab.effectColor = Color(1.0, 0.3607843137254902, 0.011764705882352941, 0.5)
  self.rewardBtn = self:FindGO("RewardButton")
  self.newMail = self:FindComponent("NewMail", UISprite)
  self.tempAlbumButton = self:FindGO("TempAlbumButton")
  self.exchangeShopPos = self:FindGO("ExchangeShopPos")
  self.exchangeShopButton = self:FindGO("ExchangeShopBtn")
  self.exchangeShopEffCtn = self:FindGO("exchangeBtnEffectContainer")
  self.exchangeShopLabel = self:FindGO("Label", self.exchangeShopButton):GetComponent(UILabel)
  self.exchangeShopLabel.text = ZhString.MainviewMenu_ExchangeShop
  self.bagBtn = self:FindGO("BagButton")
  local bagBtnSp = self.bagBtn:GetComponent(UISprite)
  Game.HotKeyTipManager:RegisterHotKeyTip(37, bagBtnSp, NGUIUtil.AnchorSide.TopLeft, {12, -12})
  self:RegisterGuideTarget(ClientGuide.TargetType.mainview_bagbutton, self.bagBtn)
  self.bagBtnSprite = self:FindGO("Sprite", self.bagBtn):GetComponent(GradientUISprite)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ASTRAL_NEW_FASHION, self.bagBtn, 42)
  self.autoBattleButton = self:FindGO("AutoBattleButton")
  self.glandStatusButton = self:FindGO("GlandStatusButton")
  self.glandStatusButtonLab = self:FindComponent("Label", UILabel, self.glandStatusButton)
  self:AddClickEvent(self.glandStatusButton, function(go)
    if GvgProxy.Instance:CheckInSettleTime() then
      ServiceGuildCmdProxy.Instance:CallGvgSettleReqGuildCmd()
    else
      RedTipProxy.Instance:RemoveWholeTip(10773)
      self:ToView(PanelConfig.GLandStatusCombineView, {index = 2})
    end
  end)
  self.guildDateBattleBtn = self:FindGO("GuildDateBattleBtn")
  self.guildDateBattleLab = self:FindComponent("Label", UILabel, self.guildDateBattleBtn)
  self:AddClickEvent(self.guildDateBattleBtn, function(go)
    GuildDateBattleProxy.Instance:TryOpenEntrance()
  end)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GVG_FIRE, self.glandStatusButton, 42)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_EXCELLENT_REWARD, self.glandStatusButton, 42)
  self.button2Grid = self:FindGO("Button2Grid")
  self.addCreditButton = self.container.activityPage.addCreditButton
  self.addCreditNode = self.container.activityPage.addCreditNode
  self.addCreditGrid = self.container.activityPage.addCreditGrid
  self.addCreditGridBg = self.container.activityPage.addCreditGridBg
  self:InitButtonGrid()
  self:InitMenuButton()
  self:InitActivityButton()
  self:InitTeamPwsMatchButton()
  self:InitMoroccSealButton()
  self:InitSignInButton()
  self:InitGroupRaidButton()
  self:InitOnMarkButton()
  self:InitTransferProfButton()
  self:InitSignIn21Button()
  self:InitCameraSettingBtn()
  self:InitGMESettingBtn()
  self:InitKFC()
  self:InitActivityBtn()
  self:InitPocketLottery()
  self:UpdateLotteryActBtn()
  self:UpdateTopic()
  self:InitManorInfoButton()
  self:InitNewPveInvite()
  self:InitSevenRoyalFamilyTreeButton()
  self:InitBattlePassBtn()
  self:InitDailyDepositBtn()
  self:InitQuestManual()
  self:InitBoliGold()
  self:InitAfricanPoringBtn()
  self:AddClickEvent(self.rewardBtn, function(go)
    self:ToView(PanelConfig.PostView)
  end)
  self:AddClickEvent(self.disneyMusicEntrance, function(go)
    local _disneyMgr = DisneyStageProxy.Instance
    if _disneyMgr:IsInMusic() then
      self:ToView(PanelConfig.DisneyMusicView)
    elseif _disneyMgr:IsInPrepare() then
      self:ToView(PanelConfig.DisneyTeamView)
    end
  end)
  self:AddClickEvent(self.tempAlbumButton, function(go)
    self:ToView(PanelConfig.TempPersonalPicturePanel)
  end)
  self:AddClickEvent(self.exchangeShopButton, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ExchangeShopView
    })
  end)
  self:AddButtonEvent("CloseMore", nil, {hideClickSound = true})
  self:AddButtonEvent("CloseMap", nil, {hideClickSound = true})
  self:AddButtonEvent("BagButton", function()
    self:PlayUISound(GameConfig.UIAudio.Package)
    if not SgAIManager.Me().m_isInBattle then
      if Game.Myself.forbidUseItem then
        MsgManager.ShowMsgByID(43578)
        return
      end
      self:ToView(PanelConfig.Bag)
    else
      MsgManager.ShowMsgByID(42084)
    end
  end, {hideClickSound = true})
  self:AddOrRemoveGuideId(self.moreBtn, 102)
  self:AddOrRemoveGuideId(self.bagBtn, 103)
  self.tempBagButton = self:FindGO("TempBagButton")
  self.tempBagWarning = self:FindGO("Warning", self.tempBagButton)
  self.tempBagNumLabel = self:FindGO("TempBagLabel", self.tempBagButton):GetComponent(UILabel)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PACK_TEMP, self.tempBagButton, 42)
  self:AddClickEvent(self.tempBagButton, function(go)
    self:ToView(PanelConfig.TempPackageView)
  end)
  self.hkBtn = self:FindGO("HouseKeeperButton")
  local hkBtnSp = self.hkBtn:GetComponent(UISprite)
  Game.HotKeyTipManager:RegisterHotKeyTip(39, hkBtnSp, NGUIUtil.AnchorSide.TopLeft, {12, -12})
  self:RegisterGuideTarget(ClientGuide.TargetType.mainview_servantbutton, self.hkBtn)
  self.servantIcon = self:FindComponent("Sprite", GradientUISprite, self.hkBtn)
  self:AddOrRemoveGuideId(self.hkBtn, 515)
  self:UpdateServantIcon()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_GROWTH, self.hkBtn, 42)
  RedTipProxy.Instance:RegisterUIByGroupID(12, self.hkBtn, 42)
  RedTipProxy.Instance:RegisterUIByGroupID(11, self.hkBtn, 42)
  local hkLabel = self:FindComponent("Label", UILabel, self.hkBtn)
  hkLabel.text = ZhString.MainviewMenu_HouseKeeper
  local data = FunctionUnLockFunc.Me():GetMenuDataByPanelID(1620, MenuUnlockType.View)
  if data then
    FunctionUnLockFunc.Me():RegisteEnterBtn(FunctionUnLockFunc.Me():GetMenuId(data), self.hkBtn)
  end
  self:AddButtonEvent("HouseKeeperButton", function()
    if Game.MapManager:IsPVPMode_PoringFight() or Game.MapManager:IsPVPMode_TransferFight() then
      MsgManager.ShowMsgByIDTable(3606)
      return
    end
    self:PlayUISound(GameConfig.UIAudio.Servant)
    if MyselfProxy.Instance:GetMyServantID() ~= 0 then
      self:ToView(PanelConfig.ServantNewMainView, {isChange = true})
    else
      self:ToView(PanelConfig.ChooseServantView)
    end
  end, {hideClickSound = true})
  self:InitBooth()
  self:InitActivityPuzzleButton()
  self.worldBossBtn = self:FindGO("WorldBossBtn")
  self.worldBossBtn:SetActive(false)
  self.worldBossTipAnchor = self:FindGO("WorldbossTipAnchor"):GetComponent(UIWidget)
  self.str = ""
  self.worldBossMap = ""
  self.time = self:FindGO("worldBossCd"):GetComponent(UILabel)
  self.worldBossTime = 0
  self:UpdateReservationTick()
  self:CheckPeddlerShopOpen()
  self:CheckOneZenyGoodsCanBuy()
  self:QueryBokiData()
  self:ForceReName()
  self:InitCustomRoomButton()
  self:UpdateShopHotBtn()
  self:InitAccumulativeShop()
  self:RefreshDailyLoginBtn()
  self:RefreshNoviceRechargeBtn()
  self:InitDownloadUIButton()
  self.antiAddictionSp = self:FindGO("AntiAddiction")
  self:InitTripleTeamPwsMatchBtn()
  self:InitAbyssDragonBtn()
end

function MainViewMenuPage:UpdateDisneyMusicState()
  local _disneyMgr = DisneyStageProxy.Instance
  local inMusic = _disneyMgr:IsInMusic()
  local inPrepare = _disneyMgr:IsInPrepare()
  self.disneyMusicEntrance:SetActive(inMusic or inPrepare)
  if inMusic then
    self.disneyMusicEntranceLab.text = ZhString.DisneyMusical_MainViewEntrance
  elseif inPrepare then
    self.disneyMusicEntranceLab.text = ZhString.DisneyMusical_MainViewTeamEntrance
  else
    self.disneyMusicEntranceLab.text = ""
  end
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:ForceReName()
  if MyselfProxy.Instance:IsCurRoleNameInValid() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoleChangeNamePopUp,
      viewdata = {force = true}
    })
  end
end

function MainViewMenuPage:UpdateServantIcon()
  self.hkBtn:SetActive(true)
  self.topRFuncGrid:Reposition()
  local servantID = MyselfProxy.Instance:GetMyServantID()
  local servantGender
  if servantID ~= 0 then
    local servantCfg = Table_Npc[servantID]
    if servantCfg then
      servantGender = servantCfg.Gender or 1
    end
  else
    servantGender = 1
  end
  if servantGender == 1 then
    IconManager:SetUIIcon("tab_icon_62", self.servantIcon)
  else
    IconManager:SetUIIcon("tab_icon_66", self.servantIcon)
  end
end

function MainViewMenuPage:UpdateReservationTick()
  if ServantCalendarProxy.Instance:CheckReservationDateValid() then
    if not self.reservationTimeTick then
      self.reservationTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDialogForServation, self, 31)
    end
  elseif self.reservationTimeTick then
    TimeTickManager.Me():ClearTick(self, 31)
    self.reservationTimeTick = nil
  end
end

local TIMESTAMP = GameConfig.Servant.playNpcTalkTimeStamp or 120
local SERVANT_VOICE = GameConfig.Servant.StefanieReservationVoice
local weakDialog = {}

function MainViewMenuPage:UpdateDialogForServation()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local bookData = ServantCalendarProxy.Instance:GetBookingData()
  for timeKey, acts in pairs(bookData) do
    for i = 1, #acts do
      local year = tonumber(os.date("%Y", timeKey))
      local month = tonumber(os.date("%m", timeKey))
      local day = tonumber(os.date("%d", timeKey))
      local actData = CalendarActivityData.new(year, month, day)
      local starttimestamp, actName
      if nil == Table_ServantCalendar[acts[i]] then
        starttimestamp = timeKey
        actName = ServantCalendarProxy.Instance:GetConsoleName(acts[i])
      else
        actData:SetStaticActData(acts[i])
        starttimestamp = actData:GetStartTimeStamp()
        actName = actData:GetActName()
      end
      if starttimestamp - math.floor(curServerTime) == TIMESTAMP then
        local cfg = MyselfProxy.Instance:GetServantDialogIconCFG()
        if not cfg or #cfg <= 0 then
          return
        end
        local dialogID = cfg[1]
        if dialogID then
          local dialog = DialogUtil.GetDialogData(dialogID)
          TableUtility.TableClear(weakDialog)
          weakDialog.Speaker = dialog.Speaker
          weakDialog.Text = string.format(dialog.Text, actName)
          self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
          if not StringUtil.IsEmpty(SERVANT_VOICE) then
            FunctionPlotCmd.Me():PlayNpcVisitVocal(SERVANT_VOICE)
          end
        end
      end
    end
  end
end

function MainViewMenuPage:ResetDepth(gameObject)
  local _UISprite = gameObject:GetComponent(UISprite)
  local activity_texture = self:FindGO("activity_texture", gameObject)
  local activity_label = self:FindGO("activity_label", gameObject)
  local holderSp = self:FindGO("holderSp", gameObject)
  local activity_texture_UITexture = activity_texture:GetComponent(UITexture)
  local activity_label_UILabel = activity_label:GetComponent(UILabel)
  local holderSp_UISprite = holderSp:GetComponent(UISprite)
  _UISprite.depth = _UISprite.depth + 30
  activity_texture_UITexture.depth = activity_texture_UITexture.depth + 30
  activity_label_UILabel.depth = activity_label_UILabel.depth + 30
  holderSp_UISprite.depth = holderSp_UISprite.depth + 30
end

function MainViewMenuPage:ResetSomeDoujinshiBtn()
  local inClassicPvp = Game.MapManager:IsPveMode_Arena()
  local inPvpZone = MyselfProxy.Instance:IsInPvpZone()
  local inSchool = self:RefreshSchoolMapLimit()
  local servantID = MyselfProxy.Instance:GetMyServantID()
  local forbiddenByServant = servantID == 0 and inSchool
  local noviceCommunityMenuOpen = FunctionUnLockFunc.Me():CheckCanOpen(self.noviceCommunityMenuid)
  if inClassicPvp or inPvpZone or inSchool or not noviceCommunityMenuOpen then
    self.DoujinshiButton:SetActive(false)
    self.activityPuzzleBtn:SetActive(false)
  else
    local isJp = BranchMgr.IsJapan()
    self.DoujinshiButton:SetActive(GameConfig.System.ShieldMaskDoujinshi ~= 1)
  end
end

function MainViewMenuPage:InitActivityBtn()
  self.TopRightFunc = self:FindGO("TopRightFunc")
  self.DoujinshiButton = self:FindGO("DoujinshiButton", self.TopRightFunc)
  self.ActivityNode = self:FindGO("ActivityNode", self.TopRightFunc)
  local closeWhenNotClickUIComp = self.ActivityNode:GetComponent("CloseWhenNotClickUI")
  closeWhenNotClickUIComp.enabled = false
  if GameConfig.System.ShieldMaskDoujinshi == 1 then
    self:Hide(self.DoujinshiButton)
    self:Hide(self.ActivityNode)
    return
  else
    self:Hide(self.ActivityNode)
    self:Show(self.DoujinshiButton)
  end
  self:RegisterRedTipCheck(45, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(PeddlerShopProxy.WholeRedTipID, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(702, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(703, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(704, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(705, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(706, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_NOTEBOOK, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(MiniROProxy.MiniRORedTipID, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_DISNEY_GUIDE, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FAVORITE_REWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_QUESTIONNAIRE_LOGIN, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_DONATIONACTIVITY, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_USERRETURN_QUEST_AWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_USERRETURN_LOGIN_AWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNACTIVITY_NORMAL, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_RETURNINVITE_AWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ACT_BP, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(ActivityFlipCardProxy.RedTipId, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(BattlePassProxy.WholeRedTipID, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(AccumulativeShopProxy.RedTipID, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_ACT_REWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_EVENT_ACT_REWARD, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(10757, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(ActivitySelfChooseProxy.RedTipId, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(ActivityExchangeProxy.RedTipId, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MISSION_REWARD, self.DoujinshiButton, 17)
  self.noviceCommunityMenuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.NoviceCommunity or 6100
  FunctionUnLockFunc.Me():RegisteEnterBtn(self.noviceCommunityMenuid, self.DoujinshiButton)
  self.Label_UILabel = self:FindGO("Label", self.DoujinshiButton):GetComponent(UILabel)
  self.Label_UILabel.text = ZhString.MainviewMenu_ChuXinSheQu
  self.DoujinshiNode = self:FindGO("DoujinshiNode")
  self.DoujinshiNode.gameObject:SetActive(false)
  self.container:RegisterChildPopObj(self.DoujinshiNode)
  self.doujinshiGrid = self:FindComponent("ContentCt", UIGrid, self.DoujinshiNode)
  self.doujinshiGridBg = self:FindComponent("bg", UISprite, self.DoujinshiNode)
  ServiceActHitPollyProxy.Instance:CallActityHitPollySync()
  self:RefreshHitPolly()
  self:RefreshMiniRO()
  self.paySignObj = {}
  self:UpdatePaySignActBtn()
  self.grouponButton = {}
  self:UpdateGrouponBtn()
  self:RefreshDisneyGuide()
  self:RefreshPlayerSurveyBtn()
  self:RefreshReturnActivityBtn()
  self:InitPlayerRefluxActButton()
  self:RefreshDailyLoginBtn()
  local mCfg = GameConfig.RideLottery[1]
  if mCfg then
    self.activityMountObj = self.container.activityPage:CreateDoujinshiButton(mCfg.MountActivty_Name, mCfg.MountActivty_Icon, function(go)
      if self:CheckMountLotteryValidation() then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "MountLotteryView"
        })
      else
        MsgManager.ShowMsgByID(25832)
      end
    end)
  end
  local pushContentCfg = GameConfig.PushContent
  if pushContentCfg then
    self.pushContentObj = self.container.activityPage:CreateDoujinshiButton(pushContentCfg.name, pushContentCfg.icon, function(go)
      if self:CheckPushContentValidation() then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "NewContentPushView"
        })
      end
    end)
  end
  self:ActivitySignInBut()
  local pCfg = PeddlerShopProxy.Instance:GetCfg()
  if pCfg then
    self.peddlerShopBtn = self.container.activityPage:CreateDoujinshiButton(pCfg.name, pCfg.icon, function()
      self:ToView(PanelConfig.PeddlerShop)
    end)
    self:RegisterRedTipCheck(PeddlerShopProxy.WholeRedTipID, self.peddlerShopBtn, 39)
  end
  self.activityRecallObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityButtonCell"))
  self.activityRecallObj.transform:SetParent(self.doujinshiGrid.transform, false)
  self.activityRecallObj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self:ResetDepth(self.activityRecallObj)
  self.activityRecall = DoujinshiButtonCell.new(self.activityRecallObj)
  local mCfg = GameConfig.Recall
  if mCfg then
    local mData = {
      name = mCfg.RecalllabelText,
      icon = mCfg.RecallIcon
    }
    self.activityRecall:SetData(mData)
  end
  self:AddClickEvent(self.activityRecallObj, function(go)
    if self:CheckActivityRecallOpen() then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "RecallPrivilegeView"
      })
    else
      MsgManager.ShowMsgByID(25832)
    end
  end)
  local webCommunity = GameConfig.WebCommunity
  if webCommunity then
    self.webCommunityButton = self.container.activityPage:CreateDoujinshiButton(webCommunity.labelText, webCommunity.iconSprite, function(go)
      OverseaHostHelper:OpenWebView(webCommunity.webUrl)
    end)
  end
  self:AddClickEvent(self.DoujinshiButton, function(go)
    if self:ShowDoujinContent() then
      self:PlayUISound(GameConfig.UIAudio.Doujin)
    end
  end, {hideClickSound = true})
  self.DoujinshiWorkBtnButton = self:FindGO("DoujinshiWorkBtnButton", self.DoujinshiNode)
  self.DoujinshiWorkBtnButton:SetActive(false)
  self:InitSupplyDepot()
  self:InitTapTapActivityBtn()
  self.userReturnInviteButton = {}
  self:RefreshUserReturnInvite()
  self.newPartnerButton = {}
  self:RefreshNewPartnerAct()
  self.recommendActButton = {}
  self:RefreshRecommendAct()
  self.previewsalerole = nil
  self:PreviewSaleRole()
  self:InitBattleFundBtn()
  self.doujinshiGrid:Reposition()
end

function MainViewMenuPage:ShowDoujinContent()
  if Game.MapManager:IsPVPMode_PoringFight() or Game.MapManager:IsPVPMode_TransferFight() then
    MsgManager.ShowMsgByIDTable(3606)
    return false
  end
  if self.pushContentObj then
    self.pushContentObj:SetActive(self:CheckPushContentValidation())
  end
  if GameConfig.System.ShieldMaskDoujinshi == 1 then
    return false
  end
  if self.activityButtonCellObj then
    self.activityButtonCellObj:SetActive(self:CheckPuzzleValidation())
  end
  if self.activityMountObj then
    self.activityMountObj:SetActive(self:CheckMountLotteryValidation())
  end
  if self.activityRecallObj then
    self.activityRecallObj:SetActive(self:CheckActivityRecallOpen())
  end
  if self.peddlerShopBtn then
    self.peddlerShopBtn:SetActive(self:CheckPeddlerShopOpen())
  end
  self:UpdateSupplyDepotBtn()
  self:UpdateJournalBtn()
  self:UpdateMidSummerAct()
  self:UpdateCrowdfundingAct()
  self:UpdateRefluxActButton()
  self:UpdateBattleFundBtn()
  self:UpdateDailyDepositBtn()
  self:UpdateBoliGold()
  self:UpdateAfricanPoringBtn()
  self:ActivitySignInBut()
  self:UpdateActivityIntegrationBtns()
  self:UpdateCommunityIntegrationBtn()
  self:UpdateTimeLimitQuestReward()
  if self.DoujinshiNode.gameObject.activeInHierarchy then
    self.DoujinshiNode.gameObject:SetActive(false)
  else
    self.DoujinshiNode.gameObject:SetActive(true)
    self:ResizeDoujinContent()
  end
  self.doujinshiGrid:Reposition()
  return true
end

function MainViewMenuPage:ResizeDoujinContent()
  if not self.doujinshiGrid or not self.doujinshiGridBg then
    return
  end
  local childCount = self.doujinshiGrid.transform.childCount
  local activeChildCount = 0
  for i = 0, childCount - 1 do
    local tempChild = self.doujinshiGrid.transform:GetChild(i)
    if tempChild and tempChild.gameObject.activeSelf then
      activeChildCount = activeChildCount + 1
    end
  end
  self.doujinshiGridBg.width = 50 + 105 * activeChildCount
  local row, column
  if 4 < activeChildCount then
    row = 4
  else
    row = activeChildCount
  end
  self.doujinshiGridBg.width = 62 + 105 * row
  column = math.ceil(activeChildCount / 4)
  self.doujinshiGridBg.height = 62 + 100 * column
  self.doujinshiGrid.repositionNow = true
end

function MainViewMenuPage:ActivitySignInBut()
  local ins = ActivitySignInProxy.Instance
  local sCfg = ins.isSignInNotifyReceived and ins:GetNowConfigData()
  if sCfg and not self.activitySignInBtn then
    if not BranchMgr.IsJapan() then
      self.activitySignInBtn = self.container.activityPage:CreateDoujinshiButton(sCfg.Title, sCfg.BtnIcon, function()
        self.DoujinshiNode.gameObject:SetActive(false)
        self:ToView(PanelConfig.ActivitySignInMapView)
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_ACTIVITY)
      end)
    else
      self.activitySignInBtn = self:CreatePocketLotteryButton(sCfg.Title, sCfg.BtnIcon)
      self.activitySignInBtn.name = "activitySignInBtn"
      self.activitySignInBtn:SetActive(true)
      self:AddClickEvent(self.activitySignInBtn, function()
        self:ToView(PanelConfig.ActivitySignInMapView)
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_ACTIVITY)
        self:SetAddCreditNodeActive(false)
      end)
      self.addCreditGrid:Reposition()
    end
    self:TryRegisterActivitySignInRedTipCheck()
  elseif not sCfg and self.activitySignInBtn then
    GameObject.DestroyImmediate(self.activitySignInBtn)
    self.activitySignInBtn = nil
  end
  if self.doujinshiGrid then
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:RefreshMiniRO()
  local activityData = MiniROProxy.Instance:GetActivityData()
  if activityData == nil then
    if self.miniROObj then
      self.miniROObj:SetActive(false)
      self.topRFuncGrid2:Reposition()
    end
    return
  end
  if nil == self.miniROObj then
    if BranchMgr.IsJapan() then
      self.miniROObj = self:CreatePocketLotteryButton(activityData.featureData.activityName, activityData.featureData.activityIcon)
      self.miniROObj.name = "miniROObj"
      self:AddClickEvent(self.miniROObj, function()
        self:_onClickMiniRO()
        self:SetAddCreditNodeActive(false)
      end)
      self.addCreditGrid:Reposition()
    else
      self.miniROObj = self.container.activityPage:CreateDoujinshiButton(activityData.featureData.activityName, activityData.featureData.activityIcon, function(go)
        self:_onClickMiniRO()
      end)
    end
  else
    self.miniROObj:SetActive(true)
    self.topRFuncGrid2:Reposition()
  end
  self:RegisterRedTipCheck(MiniROProxy.MiniRORedTipID, self.miniROObj, 39)
end

function MainViewMenuPage:RefreshDisneyGuide()
  local config = DisneyStageProxy.Instance:GetGuildeConfig()
  if not config then
    if self.overviewDisneyGuideBtn then
      self.overviewDisneyGuideBtn:SetActive(false)
      self.topRFuncGrid2:Reposition()
      self:RepositionTopRFuncGrid2()
    end
    return
  end
  if nil == self.overviewDisneyGuideBtn then
    if not BranchMgr.IsJapan() then
      self.overviewDisneyGuideBtn = self.container.activityPage:CreateDoujinshiButton(config.activityName, config.activityIcon, function(go)
        self:_onClickDisneyGuide()
      end)
    else
      self.overviewDisneyGuideBtn = self:CreatePocketLotteryButton(config.activityName, config.activityIcon)
      self.overviewDisneyGuideBtn.name = "overviewDisneyGuideBtn"
      self:AddClickEvent(self.overviewDisneyGuideBtn, function()
        self:_onClickDisneyGuide()
        self:SetAddCreditNodeActive(false)
      end)
      self.addCreditGrid:Reposition()
    end
  else
    self.overviewDisneyGuideBtn:SetActive(true)
  end
  self.topRFuncGrid2:Reposition()
  self:RepositionTopRFuncGrid2()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_DISNEY_GUIDE, self.overviewDisneyGuideBtn, 39)
end

function MainViewMenuPage:_onClickDisneyGuide()
  if DisneyStageProxy.Instance:IsGuideActRunning() then
    self:ToView(PanelConfig.DisneyActivityOverview)
  else
    MsgManager.ShowMsgByID(40973)
    self.overviewDisneyGuideBtn:SetActive(false)
    self.topRFuncGrid2:Reposition()
  end
end

function MainViewMenuPage:_onClickMiniRO()
  if MiniROProxy.Instance:IsActivityDateValid() then
    self:ToView(PanelConfig.MiniROView)
  else
    MsgManager.ShowMsgByID(40973)
    self.miniROObj:SetActive(false)
    self.topRFuncGrid2:Reposition()
    MiniROProxy.Instance:SetActivityData(nil)
  end
end

function MainViewMenuPage:RefreshHitPolly()
  local cfg = ActivityHitPollyProxy.Instance:GetActivityCFG()
  if nil == cfg then
    return
  end
  if BranchMgr.IsJapan() then
    if ActivityHitPollyProxy.Instance:IsActivityDateValid() then
      if self.HitPollyBtn4JP == nil then
        self.HitPollyBtn4JP = self:CreatePocketLotteryButton(cfg.activityName, cfg.activityIcon)
        self:AddClickEvent(self.HitPollyBtn4JP, function(go)
          self:_onClickHitPolly(true)
          self:SetAddCreditNodeActive(false)
        end)
      end
      self.addCreditGrid:Reposition()
      self:RegisterRedTipCheck(702, self.HitPollyBtn4JP, 39)
    end
  else
    if nil == self.hitPollyObj then
      self.hitPollyObj = self.container.activityPage:CreateDoujinshiButton(cfg.activityName, cfg.activityIcon, function(go)
        self:_onClickHitPolly()
      end)
    end
    self:RegisterRedTipCheck(702, self.hitPollyObj, 39)
  end
end

function MainViewMenuPage:_onClickHitPolly(isJp)
  if ActivityHitPollyProxy.Instance:IsActivityDateValid() then
    self:ToView(PanelConfig.ActivityHitPollyView)
  else
    MsgManager.ShowMsgByID(40973)
    if isJp then
      self.HitPollyBtn4JP:SetActive(false)
      self.addCreditGrid:Reposition()
    else
      self.hitPollyObj:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
  end
end

function MainViewMenuPage:RefreshRememberLoginBtn()
  if not RememberLoginProxy.Instance:CheckoutIsOpen() then
    if self.rememberLoginBtn then
      self.rememberLoginBtn:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
    return nil
  end
  if not self.rememberLoginBtn then
    local config = GameConfig.FestivalSignin[RememberLoginUtil.ConfigID]
    if not config then
      LogUtility.Error(string.format("[%s] RefreshRememberLoginBtn() Error : GameConfig.FestivalSignin[%d] == nil!", self.__cname, RememberLoginUtil.ConfigID))
      return nil
    end
    self.rememberLoginBtn = self.container.activityPage:CreateDoujinshiButton(config.ActivityName, config.ActivityIcon, function(go)
      self:_onClickRememberLoginShop()
    end)
  else
    self.rememberLoginBtn:SetActive(true)
  end
  self.doujinshiGrid:Reposition()
end

function MainViewMenuPage:_onClickRememberLoginShop()
  if RememberLoginProxy.Instance:CheckoutIsOpen() then
    self:ToView(PanelConfig.RememberLoginView)
  else
    MsgManager.ShowMsgByID(40973)
    if self.rememberLoginBtn then
      self.rememberLoginBtn:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
  end
end

function MainViewMenuPage:RefreshPlayerSurveyBtn()
  local curSurvey = PlayerSurveyProxy.Instance:InitCurSurvey()
  if not curSurvey then
    if self.playerSurveyBtn then
      self.playerSurveyBtn:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
    return
  end
  if nil == self.playerSurveyBtn then
    local config = Table_Questionnaire[curSurvey]
    local name = config and config.Name or "问卷"
    self.playerSurveyBtn = self.container.activityPage:CreateDoujinshiButton(name, "Questionnaire_icon_01", function(go)
      self:_onClickPlayerSurvey()
    end)
  else
    self.playerSurveyBtn:SetActive(true)
  end
  self.doujinshiGrid:Reposition()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_QUESTIONNAIRE_LOGIN, self.playerSurveyBtn, 39)
end

function MainViewMenuPage:_onClickPlayerSurvey()
  if PlayerSurveyProxy.Instance:checkSurveyValid() then
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_QUESTIONNAIRE_LOGIN)
    self:ToView(PanelConfig.PlayerSurveyView)
  else
    MsgManager.ShowMsgByID(40973)
    self.playerSurveyBtn:SetActive(false)
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:HandleRecvDaySignInActivityCmd()
  self:RefreshDailyLoginBtn()
  self:RefreshNoviceRechargeBtn()
end

function MainViewMenuPage:RefreshDailyLoginBtn()
  if not GameConfig.FestivalSignin then
    return
  end
  if not self.dailyLoginBtn then
    self.dailyLoginBtn = {}
  end
  for k, v in pairs(GameConfig.FestivalSignin) do
    local redtipID
    if v.Newbie and v.Newbie == 1 then
      redtipID = SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE
    else
      redtipID = SceneTip_pb.EREDSYS_SIGNACTIVITY_NORMAL
    end
    local hotPotInfo = DailyLoginProxy.Instance:GetDaySignInActivity(k)
    if (not v.Newbie or v.Newbie ~= 1) and hotPotInfo then
      if not self.dailyLoginBtn[k] then
        if not BranchMgr.IsJapan() then
          self.dailyLoginBtn[k] = self.container.activityPage:CreateDoujinshiButton(v.ActivityName, v.ActivityIcon, function(go)
            self:_onClickDailyLoginBtn(k)
          end)
          self.doujinshiGrid:Reposition()
        else
          self.dailyLoginBtn[k] = self:CreatePocketLotteryButton(v.ActivityName, v.ActivityIcon)
          self:AddClickEvent(self.dailyLoginBtn[k], function(go)
            self:_onClickDailyLoginBtn(k)
          end)
          self.addCreditGrid:Reposition()
        end
        self.dailyLoginBtn[k]:SetActive(true)
      end
      self:RegisterRedTipCheck(redtipID, self.dailyLoginBtn[k], 39)
      if hotPotInfo.redtip then
        RedTipProxy.Instance:UpdateRedTip(redtipID)
      else
        RedTipProxy.Instance:RemoveWholeTip(redtipID)
      end
    elseif self.dailyLoginBtn[k] then
      self.dailyLoginBtn[k]:SetActive(false)
      RedTipProxy.Instance:RemoveWholeTip(redtipID)
    end
  end
end

function MainViewMenuPage:_onClickDailyLoginBtn(activityid)
  if not activityid then
    redlog("无活动ID")
    return
  end
  if not DailyLoginProxy.Instance:GetDaySignInActivity(activityid) then
    redlog("活动已关闭  强制隐藏图标")
    if self.dailyLoginBtn[activityid] then
      self.dailyLoginBtn[activityid]:SetActive(false)
      return
    end
  end
  local config = GameConfig.FestivalSignin[activityid]
  local isNewbie = config.Newbie and config.Newbie == 1 or false
  if isNewbie then
    self:ToView(PanelConfig.DayloginAnniversaryPanel, {id = activityid})
  else
    self:ToView(PanelConfig.DayloginNewbiePanel, {id = activityid})
  end
end

function MainViewMenuPage:RefreshReturnActivityBtn()
  if not ReturnActivityProxy.Instance:GetActivityEnterValid() then
    if self.returnActivityBtn then
      self.returnActivityBtn:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
    return
  end
  if nil == self.returnActivityBtn then
    local config = GameConfig.Return.Common
    local name = config and config.ActivityName or "老玩家回归"
    local icon = config and config.ActivityIcon or "tab_icon_113"
    self.returnActivityBtn = self.container.activityPage:CreateDoujinshiButton(name, icon, function(go)
      self:_onClickReturnActivity()
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_USERRETURN_QUEST_AWARD, self.returnActivityBtn, 39)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_USERRETURN_LOGIN_AWARD, self.returnActivityBtn, 39)
  else
    self.returnActivityBtn:SetActive(true)
  end
  self.doujinshiGrid:Reposition()
end

function MainViewMenuPage:_onClickReturnActivity()
  if ReturnActivityProxy.Instance:GetActivityEnterValid() then
    self:ToView(PanelConfig.ReturnActivityPanel)
  else
    MsgManager.ShowMsgByID(41105)
    if self.returnActivityBtn then
      self.returnActivityBtn:SetActive(false)
      self.doujinshiGrid:Reposition()
    end
  end
end

function MainViewMenuPage:InitMenuButton()
  self.menuCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self:InitMenuDatas()
end

function MainViewMenuPage:InitEmojiButton()
  self.ButtonGrid2 = self:FindGO("Button2Grid")
  self.ButtonGrid2_UIGrid = self.ButtonGrid2:GetComponent(UIGrid)
  local emojiButton = self:FindGO("EmojiButton")
  self.emojiButton = emojiButton
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, emojiButton)
  self:AddClickEvent(emojiButton, function()
    self:ClickEmojiButton()
  end)
end

function MainViewMenuPage:ClickEmojiButton()
  if not self.isEmojiShow then
    self:ToView(PanelConfig.ChatEmojiView)
  else
    self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
  end
end

function MainViewMenuPage:InitCameraSettingBtn()
  self.cameraPart = self:FindGO("CameraPart")
  self.cameraBtn = self:FindGO("CameraBtn")
  self.cameraSp = self.cameraBtn:GetComponent(UISprite)
  self.cameraLabel = self:FindGO("Label", self.cameraBtn):GetComponent(UILabel)
  self.cameraIcon = self:FindGO("Sprite", self.cameraBtn)
  self.cameraForbid = self:FindGO("prohibit", self.cameraBtn)
  self.cameraTweenScale = self.cameraBtn:GetComponent(TweenScale)
  self.cameraGridObj = self:FindGO("CameraGrid")
  self.cameraGridTweenPos = self.cameraGridObj:GetComponent(TweenPosition)
  self.cameraGridTweenAlpha = self.cameraGridObj:GetComponent(TweenAlpha)
  self.cameraGridTweenPos:ResetToBeginning()
  self.cameraGridTweenAlpha:ResetToBeginning()
  self.cameraBtns = {}
  for i = 2, 3 do
    self.cameraBtns[i] = {}
    self.cameraBtns[i].obj = self:FindGO("Button" .. i, self.cameraGridObj)
    self.cameraBtns[i].objSp = self.cameraBtns[i].obj:GetComponent(UISprite)
    self.cameraBtns[i].forbid = self:FindGO("prohibit", self.cameraBtns[i].obj)
    self.cameraBtns[i].icon = self:FindGO("Icon", self.cameraBtns[i].obj)
    self.cameraBtns[i].label = self:FindGO("Label", self.cameraBtns[i].obj):GetComponent(UILabel)
  end
  self.cameraBG = self:FindGO("CameraBg"):GetComponent(UISprite)
  self.cameraBGTweenWidth = self:FindGO("CameraBg"):GetComponent(TweenWidth)
  self.arrow = self:FindGO("CameraArrow")
  self.arrowTweenPos = self.arrow:GetComponent(TweenPosition)
  self.arrowTweenPos:ResetToBeginning()
  self.arrowIcon = self.arrow:GetComponent(UISprite)
  self.cameraGridShow = false
  self.cameraLock = 0
  self.curCameraChoose = 0
  self:AddClickEvent(self.cameraBtn, function()
    self.cameraGridShow = not self.cameraGridShow
    self:RefreshCameraGrid()
  end)
  self:AddClickEvent(self.arrow, function()
    self.cameraGridShow = not self.cameraGridShow
    self:RefreshCameraGrid()
  end)
  for i = 2, 3 do
    self:AddClickEvent(self.cameraBtns[i].obj, function()
      self.cameraGridShow = not self.cameraGridShow
      self:RefreshCameraGrid()
      local clickType = self.cameraBtns[i].camOpt
      local unlock = IsCameraOptionUnlock(clickType)
      if not unlock then
        MsgManager.FloatMsg("", ZhString.CameraFobidTip .. CameraBtnStyles[clickType].Msg)
        return
      end
      self.curCameraChoose = clickType
      self:ClickCameraBtn(clickType)
    end)
  end
  self:RefreshCameraChange()
end

function MainViewMenuPage:ClickCameraBtn(type)
  if type == 1 then
    FunctionPerformanceSetting.Me():SetLockCamera(true)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(true)
  elseif type == 2 then
    FunctionPerformanceSetting.Me():SetLockCamera(false)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(true)
  else
    FunctionPerformanceSetting.Me():SetLockCamera(false)
    FunctionPerformanceSetting.Me():SetLockFreeCameraVert(false)
  end
  FunctionPerformanceSetting.Me().oldSetting = nil
  FunctionPerformanceSetting.Me():Save()
  Game.MapManager:UpdateCameraState(CameraController.Instance)
  self:RefreshCameraChange()
  self.cameraTweenScale:ResetToBeginning()
  self.cameraTweenScale:PlayForward()
end

function MainViewMenuPage:RefreshCameraGrid()
  if self.cameraGridShow then
    self.cameraGridTweenPos:PlayForward()
    self.cameraGridTweenAlpha:PlayForward()
    self.cameraBGTweenWidth:PlayForward()
    self.arrowTweenPos:PlayForward()
    tempVector3[3] = 90
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
    self.arrowIcon.transform.localRotation = tempRot
  else
    self.cameraGridTweenPos:PlayReverse()
    self.cameraGridTweenAlpha:PlayReverse()
    self.cameraBGTweenWidth:PlayReverse()
    self.arrowTweenPos:PlayReverse()
    tempVector3[3] = -90
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
    self.arrowIcon.transform.localRotation = tempRot
  end
end

function MainViewMenuPage:RefreshCameraChange()
  local curCameraType = FunctionCameraEffect.Me():GetCurCameraMode()
  self.cameraOptions = {}
  for i = 1, 3 do
    if curCameraType ~= i then
      table.insert(self.cameraOptions, i)
    end
  end
  local mapid = Game.MapManager:GetMapID()
  if Table_Map[mapid] then
    self.cameraLock = Table_Map[mapid].CameraLock or 0
  else
    self.cameraLock = 0
  end
  local cameraBtn, cameraBtnStyle, camOpt, isUnlock
  for i = 1, #self.cameraOptions do
    camOpt = self.cameraOptions[i]
    cameraBtn = self.cameraBtns[i + 1]
    cameraBtn.camOpt = camOpt
    cameraBtnStyle = CameraBtnStyles[camOpt]
    cameraBtn.label.text = cameraBtnStyle.text
    cameraBtn.icon:SetActive(cameraBtnStyle.iconActive)
    isUnlock = IsCameraOptionUnlock(camOpt)
    cameraBtn.forbid:SetActive(not isUnlock)
    cameraBtn.objSp.alpha = isUnlock and 1 or 0.7
  end
  local curCameraBtnStyle = CameraBtnStyles[curCameraType]
  self.cameraIcon:SetActive(curCameraBtnStyle.iconActive)
  self.cameraLabel.text = curCameraBtnStyle.text
  self.curCameraChoose = 0
end

function MainViewMenuPage:HandlePlayerMapChange()
  self:HandleMapChangeCameraSwitch()
  self:ResetSomeDoujinshiBtn()
  self:InitManorInfoButton()
  self:InitSevenRoyalFamiliesEvidenceBookButton()
  self:InitSevenRoyalFamilyTreeButton()
  self:RefreshTechTreeBtn()
  self:RefreshNewbieTechTreeBtn()
  self:RefreshWildMvpBtn()
  self:RefreshNoviceRechargeBtn()
  self:RefreshAnniversary2023Btn()
  local servantID = MyselfProxy.Instance:GetMyServantID()
  if not FunctionUnLockFunc.Me():CheckCanOpen(3050) then
    return
  end
  if servantID == 0 then
    local banned = self:RefreshSchoolMapLimit()
    self.hkBtn:SetActive(not banned)
  elseif not self.hkBtn.activeSelf then
    self.hkBtn:SetActive(true)
    self.topRFuncGrid:Reposition()
  end
  if MyselfProxy.Instance.failPassPersonalEndlessTower then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ImproveShortCutView
    })
  end
end

function MainViewMenuPage:HandleMapChangeCameraSwitch()
  self.curCameraChoose = 0
  self.cameraTweenScale:PlayForward()
  Game.MapManager:UpdateCameraState(CameraController.Instance)
  self:RefreshCameraChange()
end

function MainViewMenuPage:HandleCameraSettingShow()
  self.cameraPart:SetActive(true)
end

function MainViewMenuPage:HandleCameraSettingHide()
  self.cameraPart:SetActive(false)
end

function MainViewMenuPage:InitGMESettingBtn()
  autoImport("MainViewGMEPartVirtualCell")
  local go = self:FindGO("GMEPart")
  if MainViewGMEPartVirtualCell.USE_NEW_GME_PART then
    MainViewGMEPartVirtualCell.new(go)
  else
    go:SetActive(false)
    self.ButtonGrid_UIGrid:Reposition()
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewMenuPage:InitSetView()
  self.SetView_CloseButton = self:FindGO("CloseButton", self.SetView)
  self.SetView_MainBoard = self:FindGO("MainBoard", self.SetView)
  self.SetView_MainBoard_MainPage = self:FindGO("MainPage", self.SetView_MainBoard)
  self.SetView_MainBoard_MainPage_CloseBtn = self:FindGO("CloseBtn", self.SetView_MainBoard_MainPage)
  self.TeamChannelToggle = self:FindGO("TeamChannelToggle")
  self.TeamChannelToggle_UIToggle = self:FindGO("TeamChannelToggle"):GetComponent(UIToggle)
  self.GuildChannelToggle = self:FindGO("GuildChannelToggle")
  self.GuildChannelToggle_UIToggle = self:FindGO("GuildChannelToggle"):GetComponent(UIToggle)
  self.GuildChannel = self:FindGO("GuildChannel")
  self.GuildChannel_UILabel = self:FindGO("GuildChannel"):GetComponent(UILabel)
  self.GuildChannel_UILabel.text = ZhString.VoiceString.GuildChannel
  self:AddClickEvent(self.SetView_CloseButton, function()
    self.SetView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.SetView_MainBoard_MainPage_CloseBtn, function()
    self.SetView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.TeamChannelToggle_UIToggle.gameObject, function(obj)
    if self.LastToggleIsTeamToggle == true then
      return
    end
    self.LastToggleIsTeamToggle = true
    GVoiceProxy.Instance:SwitchChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
  end)
  self:AddClickEvent(self.GuildChannelToggle_UIToggle.gameObject, function(obj)
    if self.LastToggleIsTeamToggle == false then
      return
    end
    self.LastToggleIsTeamToggle = false
    GVoiceProxy.Instance:SwitchChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
  end)
end

function MainViewMenuPage:InitButtonGrid()
  self.SetView = self:FindGO("SetView")
  if self.SetView then
    self.SetView.gameObject:SetActive(false)
    self:InitSetView()
  end
  self.ButtonGrid = self:FindGO("ButtonGrid")
  self.ButtonGrid_UIGrid = self.ButtonGrid:GetComponent(UIGrid)
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid:Reposition()
  end
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateWorldBossTip(note)
  if note and note.body then
    local worldBossData = note.body
    if not worldBossData.open then
      self.worldBossBtn:SetActive(false)
    else
      local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.DeadBoss or 9
      local menuOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
      if menuOpen then
        self.worldBossBtn:SetActive(true)
        if worldBossData.mapid and Table_Map[worldBossData.mapid] then
          self.worldBossMap = Table_Map[worldBossData.mapid].NameZh
        end
        self.str = string.format(ZhString.MVP_WorldBoss_Tip, self.worldBossMap)
        self:AddClickEvent(self.worldBossBtn, function()
          self.normalTip = TipManager.Instance:ShowNormalTip(self.str, self.worldBossTipAnchor, NGUIUtil.AnchorSide.Center, {-135, 62})
        end)
        if worldBossData.time then
          self.worldBossTime = worldBossData.time
          if self.bosstimeTick == nil then
            self.bosstimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateWorldbossTick, self, 11)
          end
        end
      end
    end
    self.topRFuncGrid2:Reposition()
  end
end

function MainViewMenuPage:UpdateWorldbossTick()
  local time = self.worldBossTime
  if time == 0 then
    if self.bosstimeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, 11)
      self.bosstimeTick = nil
      self.time.text = ZhString.Boss_Show
    end
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(deltaTime)
  if deltaTime <= 0 then
    if self.bosstimeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, 11)
      self.bosstimeTick = nil
      self.time.text = ZhString.Boss_Show
    end
  else
    self.time.text = string.format("%02d:%02d", min, sec)
  end
end

function MainViewMenuPage:ResetWorldBossTip()
  self.worldBossBtn:SetActive(false)
end

function MainViewMenuPage:EnterVoiceChannel(data)
  if self.VoiceFuncSprite1_UISprite then
    if GVoiceProxy.Instance.LastMicState_IsMicOpen == false then
      self.VoiceFuncSprite1_UISprite.spriteName = "ui_microphone_b_JM"
    else
      self.VoiceFuncSprite1_UISprite.spriteName = "ui_microphone_c_JM"
    end
    if GVoiceProxy.Instance.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
      self.VoiceFuncSprite2_UISprite.spriteName = "com_txt2_voice2"
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(true)
    elseif GVoiceProxy.Instance.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
      self.VoiceFuncSprite2_UISprite.spriteName = "com_txt_voice2"
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(true)
    else
      self.VoiceFuncSprite2_UISprite.gameObject:SetActive(false)
    end
  end
end

function MainViewMenuPage:InitActivityButton()
  self.activityCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell")
  self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self:UpdateActivityDatas()
end

function MainViewMenuPage:InitBooth()
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.BoothShopping or 9
  local unlock = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
  if not unlock then
    self:_StartBooth(1)
  end
  local _Booth = GameConfig.Booth
  FunctionSceneFilter.Me():StartFilter(_Booth.booth_screenFilterID)
  local currentState, time = self:_TryGetMainViewBooth()
  if currentState ~= 1 and ServerTime.CurServerTime() > time + _Booth.shoppingMode_reset * 1000 then
    LocalSaveProxy.Instance:SetMainViewBooth(1)
  end
  self:UpdateBoothInfo()
end

function MainViewMenuPage:InitKFC()
  self.KFCBtn = self:FindGO("KFCBtn")
  if KFCARCameraProxy.Instance:CheckDateValidByBranch() or KFCARCameraProxy.Instance:SelfTest() then
    self.KFCBtn.gameObject:SetActive(true)
  else
    self.KFCBtn.gameObject:SetActive(false)
  end
  self:AddClickEvent(self.KFCBtn, function()
    KFCARCameraProxy.Instance:JumpPanel()
  end)
end

function MainViewMenuPage:InitPocketLottery()
  if not BranchMgr.IsJapan() then
    return
  end
  self:InitMountLotteryEntrance()
  self:InitSupplyDepot()
  self:InitPushContent()
  self:RefreshMiniRO()
  self:ActivitySignInBut()
  self:RefreshDisneyGuide()
  self:RefreshHitPolly()
  self:InitSignInButton(true)
  self:UpdateMidSummerAct()
  self.signInButton.transform:SetParent(self.addCreditGrid.transform, false)
  local sprite = self:FindComponent("Sprite", UISprite, self.signInButton)
  sprite.height = 72
  self:ResetPocketLotteryButtonDepth(self.signInButton)
  self.addCreditGrid:Reposition()
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:GetMoreButtonCells(excludeInActive)
  local ret = {}
  local allCells = self.menuCtl:GetCells()
  for i = 1, #allCells do
    if not allCells[i].platHide then
      if not excludeInActive then
        table.insert(ret, allCells[i])
      elseif allCells[i].gameobject.activeSelf then
        table.insert(ret, allCells[i])
      end
    end
  end
  return ret
end

function MainViewMenuPage:PocketLotteryChangeLocationOfButtons()
  if not BranchMgr.IsJapan() then
    return
  end
  self.DoujinshiButton.transform:SetParent(self.moreGrid.transform, false)
  local doujinshiBgSprite = self.DoujinshiButton:GetComponent(UISprite)
  doujinshiBgSprite.depth = 6
  self:UnLockMenuButton()
end

function MainViewMenuPage:InitMountLotteryEntrance()
  local mCfg = GameConfig.RideLottery[1]
  if mCfg then
    if not self:CheckMountLotteryValidation() then
      return
    end
    self.mountLotteryBut = self:CreatePocketLotteryButton(mCfg.MountActivty_Name, mCfg.MountActivty_Icon)
    self:AddClickEvent(self.mountLotteryBut, function()
      self:ToView(PanelConfig.MountLotteryView)
      self:SetAddCreditNodeActive(false)
    end)
  end
end

function MainViewMenuPage:UpdateTopic()
  local topic_config = GameConfig.Topic
  if not topic_config then
    redlog("未找到课题配置GameConfig.Topic")
    return
  end
  if not self.topicInited then
    self.topic = self:FindComponent("TopicBtn", UISprite, self.topRFuncGrid2.gameObject)
    RedTipProxy.Instance:RegisterUIByGroupID(15, self.topic.gameObject, 42)
    self.topicSp = self:FindComponent("Sprite", UISprite, self.topic.gameObject)
    self:AddClickEvent(self.topic.gameObject, function(go)
      self:ToView(PanelConfig.NoviceTarget2023View)
    end)
    IconManager:SetUIIcon(topic_config.activityIcon, self.topicSp)
    self.topicSp:MakePixelPerfect()
    self.topicLab = self:FindComponent("Label", UILabel, self.topic.gameObject)
    self.topicLab.text = topic_config.activityName
    self.topicInited = true
  end
  local menuid = topic_config.openMenu
  if menuid then
    local isOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
    if isOpen then
      self:Show(self.topic)
    else
      self:Hide(self.topic)
      FunctionUnLockFunc.Me():RegisteEnterBtn(menuid, self.topic)
    end
  else
    self:Hide(self.topic)
  end
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateLotteryActBtn()
  local actData = LotteryProxy.Instance:GetAllActiveLottery()
  if not next(actData) then
    return
  end
  local lotteryActConfig = GameConfig.Lottery.activity
  if not lotteryActConfig then
    redlog("未找到配置GameConfig.Lottery.activity")
    return
  end
  local menuID = GameConfig.Lottery and GameConfig.Lottery.MenuID
  if menuID and not FunctionUnLockFunc.Me():CheckCanOpen(menuID) then
    return
  end
  self.lotteryActObjs = self.lotteryActObjs or {}
  local redTipMgr = RedTipProxy.Instance
  self:RegisterRedTipCheck(redTip_LotteryActivity, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(redTip_DailyReward, self.DoujinshiButton, 17)
  if redTipMgr:HasRedTipParam(redTip_LotteryFree) then
    self:RegisterRedTipCheck(redTip_LotteryFree, self.DoujinshiButton, 17)
  end
  for i = 1, #actData do
    local t = actData[i].lotteryType
    if lotteryActConfig[t] and not actData[i]:CheckIsInEntrance() then
      if actData[i].open then
        if nil == self.lotteryActObjs[t] then
          if BranchMgr.IsJapan() then
            self.lotteryActObjs[t] = self:CreatePocketLotteryButton(lotteryActConfig[t].activityName, lotteryActConfig[t].activityIcon)
            self:AddClickEvent(self.lotteryActObjs[t], function(go)
              if redTipMgr:IsNew(redTip_LotteryActivity, t) then
                redTipMgr:SeenNew(redTip_LotteryActivity, t)
              end
              if LotteryProxy.IsNewMixLottery(t) and not actData[i]:CheckTimeValid() then
                MsgManager.ShowMsgByID(40973)
                GameObject.DestroyImmediate(self.lotteryActObjs[t])
                self.lotteryActObjs[t] = nil
                self:UpdateGrid()
              else
                FunctionLottery.Me():OpenNewLotteryByType(t)
              end
            end)
          else
            self.lotteryActObjs[t] = self.container.activityPage:CreateDoujinshiButton(lotteryActConfig[t].activityName, lotteryActConfig[t].activityIcon, function(go)
              if redTipMgr:IsNew(redTip_LotteryActivity, t) then
                redTipMgr:SeenNew(redTip_LotteryActivity, t)
              end
              if LotteryProxy.IsNewMixLottery(t) and not actData[i]:CheckTimeValid() then
                MsgManager.ShowMsgByID(40973)
                GameObject.DestroyImmediate(self.lotteryActObjs[t])
                self.lotteryActObjs[t] = nil
                self:UpdateGrid()
              else
                FunctionLottery.Me():OpenNewLotteryByType(t)
              end
            end)
          end
        end
        self:_tryRegisterLotteryRedTip(redTip_LotteryActivity, t, self.lotteryActObjs[t])
        self:_tryRegisterLotteryRedTip(redTip_LotteryFree, t, self.lotteryActObjs[t])
        self:_tryRegisterLotteryRedTip(redTip_DailyReward, t, self.lotteryActObjs[t])
      elseif self.lotteryActObjs[t] then
        GameObject.DestroyImmediate(self.lotteryActObjs[t])
        self.lotteryActObjs[t] = nil
      end
    else
      redlog("未找到配置GameConfig.Lottery.activity  id: ", t)
    end
  end
  self:UpdateEntranceLottery()
  self:UpdateGrid()
end

function MainViewMenuPage:UpdateEntranceLottery()
  local entrance_config = GameConfig.Lottery.entrance
  if not entrance_config then
    return
  end
  if LotteryProxy.Instance:CheckHasLotteryEntrance() then
    if not self.lotteryEntranceObj then
      self.lotteryEntranceObj = self.container.activityPage:CreateDoujinshiButton(entrance_config.activityName, entrance_config.activityIcon, function(go)
        FunctionLottery.Me():OpenLotteryEntrance()
      end)
    end
    local datas = LotteryProxy.Instance:GetEntranceLotteryActs()
    local type
    for i = 1, #datas do
      type = datas[i].lotteryType
      self:_tryRegisterLotteryRedTip(redTip_LotteryActivity, type, self.lotteryEntranceObj)
      self:_tryRegisterLotteryRedTip(redTip_LotteryFree, type, self.lotteryEntranceObj)
      self:_tryRegisterLotteryRedTip(redTip_DailyReward, type, self.lotteryEntranceObj)
    end
  elseif self.lotteryEntranceObj then
    GameObject.DestroyImmediate(self.lotteryEntranceObj)
    self.lotteryEntranceObj = nil
  end
end

function MainViewMenuPage:UpdateGrid()
  if BranchMgr.IsJapan() then
    self.addCreditGrid:Reposition()
  else
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:_tryRegisterLotteryRedTip(redtip_type, param_id, obj)
  local redTipMgr = RedTipProxy.Instance
  local isNew = redTipMgr:IsNew(redtip_type, param_id)
  if isNew then
    self:RegisterRedTipCheck(redtip_type, obj, 39)
  else
    self:UnRegisterSingleRedTipCheck(redtip_type, obj)
  end
end

local ZenyIcon = "tab_icon_60"
local forbidFlag = FunctionNewRecharge.isWindowsZenyShopForbid()
local specialMainViewButtonTypeMap = {
  [4] = MainViewButtonType.MVP,
  [15] = MainViewButtonType.PVE,
  [16] = MainViewButtonType.PROFESSION
}
local _MainViewButtonType4RedTip = {
  [MainViewButtonType.Menu] = 1,
  [MainViewButtonType.MVP] = 1,
  [MainViewButtonType.PVE] = 1,
  [MainViewButtonType.PROFESSION] = 1
}

function MainViewMenuPage:InitMenuDatas()
  self.mainButtonDatas = {}
  local isValid
  for k, v in pairs(Table_MainViewButton) do
    isValid = v.icon ~= ZenyIcon or not forbidFlag
    if isValid then
      local data = {}
      data.type = specialMainViewButtonTypeMap[k] or MainViewButtonType.Menu
      data.staticData = v
      table.insert(self.mainButtonDatas, data)
    end
  end
  table.sort(self.mainButtonDatas, function(a, b)
    if a.staticData.sortid == b.staticData.sortid then
      return a.staticData.id < b.staticData.id
    else
      return a.staticData.sortid < b.staticData.sortid
    end
  end)
  self.menuCtl:ResetDatas(self.mainButtonDatas)
  local cells = self:GetMoreButtonCells()
  local tutorState = TutorProxy.Instance:GetFuncState()
  for i = 1, #cells do
    local cdata = cells[i].data
    if nil ~= cdata and nil ~= _MainViewButtonType4RedTip[cdata.type] then
      local go = cells[i].gameObject
      local data = cdata.staticData
      if data then
        if data.id == 7 and not tutorState then
          data.redtiptype = {34}
          data.GroupID = {}
        end
        local branch = BranchMgr.GetBranchName()
        if data.id == 11 and GameConfig.AuthUserInfo and GameConfig.AuthUserInfo.CountryCode[branch] then
          data.redtiptype = {
            GameConfig.AuthUserInfo.PhoneRedTip,
            GameConfig.AuthUserInfo.MailRedTip
          }
        end
        if data.redtiptype and #data.redtiptype > 0 then
          self:RegisterRedTipCheckByIds(data.redtiptype, self.moreBtn, 42)
          self:RegisterRedTipCheckByIds(data.redtiptype, go, 42)
        end
        if data.GroupID and #data.GroupID > 0 then
          for i = 1, #data.GroupID do
            local groupId = data.GroupID[i]
            RedTipProxy.Instance:RegisterUIByGroupID(groupId, self.moreBtn, 42)
            RedTipProxy.Instance:RegisterUIByGroupID(groupId, go, 42)
          end
        end
        local success, errorMsg = xpcall(FunctionUnLockFunc.RegisteEnterBtnByPanelID, debug.traceback, FunctionUnLockFunc.Me(), data.panelid, go)
        if not success then
          Debug.LogError(string.format("Menu注册失败. panelID:%s\n%s", data.panelid, errorMsg))
        end
        local guideId = data.guideiconID
        if guideId then
          self:AddOrRemoveGuideId(go, guideId)
        end
      end
    end
    if cdata then
      local sdata = cdata.staticData
      local hotkey_id
      local offset = {20, -20}
      if sdata.panelid == PanelConfig.CharactorProfessSkill.id then
        hotkey_id = 40
      elseif sdata.panelid == PanelConfig.MultiProfessionNewView.id then
        hotkey_id = 41
        offset = {10, -10}
      elseif sdata.panelid == PanelConfig.PveView.id then
        hotkey_id = 42
      elseif sdata.panelid == PanelConfig.BossView.id then
        hotkey_id = 43
      elseif sdata.panelid == PanelConfig.AdventurePanel.id then
        hotkey_id = 44
      elseif sdata.panelid == PanelConfig.FriendMainView.id then
        hotkey_id = 45
      elseif sdata.panelid == PanelConfig.GuildInfoView.id then
        hotkey_id = 46
      elseif sdata.panelid == PanelConfig.PhotographPanel.id then
        hotkey_id = 47
      elseif sdata.panelid == PanelConfig.PvpContainerView.id then
        hotkey_id = 48
      elseif sdata.panelid == PanelConfig.HomeMainView.id then
        hotkey_id = 49
      elseif sdata.panelid == PanelConfig.SetView.id then
        hotkey_id = 57
      elseif sdata.panelid == PanelConfig.MercenaryCatView.id then
        hotkey_id = 51
      elseif sdata.panelid == PanelConfig.PersonalPicturePanel.id then
        hotkey_id = 52
      elseif sdata.panelid == PanelConfig.CreateChatRoom.id then
        hotkey_id = 53
      elseif sdata.panelid == PanelConfig.PostView.id then
        hotkey_id = 54
      end
      if hotkey_id then
        Game.HotKeyTipManager:RegisterHotKeyTip(hotkey_id, cells[i].sprite, NGUIUtil.AnchorSide.TopLeft, offset)
      end
    end
  end
  self:RefreshGuildRedTip()
  self:RefreshQuestManualTip()
  self:RefreshSignIn21Tip()
  self:ResetMenuButtonPosition()
end

function MainViewMenuPage:RefreshMoreMenuDatas()
  local cells = self:GetMoreButtonCells()
  for i = 1, #cells do
    local cdata = cells[i].data
    if nil ~= cdata and nil ~= _MainViewButtonType4RedTip[cdata.type] then
      local go = cells[i].gameObject
      local data = cdata.staticData
      if data then
        local success, errorMsg = xpcall(FunctionUnLockFunc.RegisteEnterBtnByPanelID, debug.traceback, FunctionUnLockFunc.Me(), data.panelid, go)
        if not success then
          Debug.LogError(string.format("Menu注册失败. panelID:%s\n%s", data.panelid, errorMsg))
        end
      end
    end
  end
  self:ResetMenuButtonPosition()
end

function MainViewMenuPage:UpdateActivityDatas()
  self.activityDatas = {}
  for _, aData in pairs(Table_OperationActivity) do
    if aData.Type == 1 then
      local data = {}
      data.type = MainViewButtonType.Activity
      data.staticData = aData
      table.insert(self.activityDatas, data)
    end
  end
  self.activityCtl:ResetDatas(self.activityDatas)
  self:ResetMenuButtonPosition()
end

function MainViewMenuPage:ClickButton(cellctl)
  self:DoMoreButtonByData(cellctl.data)
end

function MainViewMenuPage:DoMoreButtonByData(data)
  if data then
    local sData = data.staticData
    if sData.Sound and sData.Sound ~= "" then
      self:PlayUISound(sData.Sound)
    end
    if data.type == MainViewButtonType.Menu then
      if sData.panelid == PanelConfig.GuildInfoView.id then
        helplog("MainViewMenuPage:click guild")
        if self.delayGildTimer then
          MsgManager.FloatMsg(nil, ZhString.TouchSoFast)
          return
        elseif BranchMgr.IsSEA() then
          self.delayGildTimer = TimeTickManager.Me():CreateOnceDelayTick(10000, function(owner, deltaTime)
            self.delayGildTimer = nil
          end, self, 10000)
        end
      end
      if sData.panelid == PanelConfig.PhotographPanel.id then
        if self.isEmojiShow then
          self.isEmojiShow = false
          self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
        end
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
      elseif sData.panelid == PanelConfig.CreateChatRoom.id then
        local handed, handowner = Game.Myself:IsHandInHand()
        if handed and not handowner then
          MsgManager.ShowMsgByIDTable(824)
          return
        end
        if Game.Myself:IsInBooth() then
          MsgManager.ShowMsgByID(25708)
          return
        end
        local isInGagTime, time = MyselfProxy.Instance:IsInGagTime()
        if isInGagTime then
          MsgManager.ShowMsgByID(92, math.floor(time / 60))
          return
        end
        if Game.MapManager:CheckForbiddenChatRoom() then
          MsgManager.ShowMsgByID(25311)
          return
        end
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
      elseif sData.panelid == PanelConfig.PvpContainerView.id then
        if PvpProxy.Instance:IsSelfInPvp() then
          MsgManager.ShowMsgByID(951)
        elseif DojoProxy.Instance:IsSelfInDojo() then
          MsgManager.ShowMsgByID(983)
        elseif Game.Myself:IsDead() then
          MsgManager.ShowMsgByID(2500)
        elseif Game.Myself:IsInBooth() then
          MsgManager.ShowMsgByID(25708)
        elseif Game.MapManager:IsPvPMode_TeamTwelve() then
          MsgManager.ShowMsgByID(26257)
        else
          self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
        end
      elseif sData.panelid == PanelConfig.LinePanel.id then
        Application.OpenURL("https://line.me/R/ti/p/fbIXz8W-lH")
      elseif sData.panelid == PanelConfig.TeamFindPopUp.id then
        self:PlayUISound(GameConfig.UIAudio.Team)
        if NewbieCollegeProxy.Instance.IsInFakeTeam then
          return
        end
        if not TeamProxy.Instance:IHaveTeam() then
          self:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.TeamFindPopUp
          })
        else
          self:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.TeamMemberListPopUp
          })
        end
      elseif sData.panelid == PanelConfig.ZenyShopGachaCoin.id then
        FunctionNewRecharge.Instance():OpenUIDefaultPage()
        NewRechargeProxy.Instance:CallClientPayLog(101)
      elseif sData.panelid == PanelConfig.NoviceTarget2023View.id then
        if not NoviceTarget2023Proxy.Instance:CheckServerDataValid() then
          MsgManager.ShowMsgByID(1056)
        else
          self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
        end
      elseif sData.panelid == PanelConfig.SetView.id then
        if ApplicationInfo.IsRunOnWindowns() then
          self:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.PCSetView
          })
        else
          self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
        end
      elseif sData.panelid == PanelConfig.AstralDestinyGraphView.id then
        local config = GameConfig.Astral
        local menuId = config and config.GraphMenuID
        if FunctionUnLockFunc.Me():CheckCanOpen(menuId, true) then
          if AstralProxy.Instance:IsSeasonNotOpen() then
            MsgManager.ShowMsgByID(43581)
            return
          end
          self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
        end
      else
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
      end
      self:Hide(self.moreBord)
    elseif data.type == MainViewButtonType.Activity then
      local sData = data.staticData
      self:ToView(PanelConfig.TempActivityView, {Config = sData})
    elseif data.type == MainViewButtonType.MVP then
      local sData = data.staticData
      if not StringUtil.IsEmpty(sData.Sound) then
        AudioUtility.PlayOneShot2D_Path(sData.Sound)
      end
      self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
      self:Hide(self.moreBord)
    elseif data.type == MainViewButtonType.PVE then
      if Game.MapManager:IsPvpMode_DesertWolf() then
        MsgManager.ShowMsgByID(26230)
      else
        local sData = data.staticData
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid))
        redlog("MainViewButtonType.PVE", sData.panelid)
        self:Hide(self.moreBord)
      end
    elseif data.type == MainViewButtonType.PROFESSION then
      local myselfData = Game.Myself.data
      local sData = data.staticData
      SaveInfoProxy.Instance:SetSavedLastBranchID(-1)
      if myselfData:IsTransformed() then
        if not myselfData:IsHideCancelTransformBtn() then
          MsgManager.ConfirmMsgByID(924, function()
            ServiceUserEventProxy.Instance:CallDelTransformUserEvent()
            self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
          end, nil, nil)
        else
          MsgManager.ShowMsgByID(27009)
        end
      else
        self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
      end
      self:Hide(self.moreBord)
    end
  end
end

function MainViewMenuPage:ResetMenuButtonPosition()
  self.moreGrid.repositionNow = true
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewMenuPage:HandleUpdatetemScene()
  local bRet = AdventureDataProxy.Instance:HasTempSceneryExsit()
  if bRet then
    self:Show(self.tempAlbumButton)
  else
    self:Hide(self.tempAlbumButton)
  end
end

function MainViewMenuPage:HandleExchangeShopBtnEffect()
  self.exchangeShopPos:SetActive(ExchangeShopProxy.Instance:CanOpen())
  self.topRFuncGrid2.repositionNow = true
end

function MainViewMenuPage:UpdateRewardButton()
  if not self.rewardBtn.activeSelf then
    self.rewardBtn:SetActive(true)
  end
  local newpost = PostProxy.Instance:GetNewPost()
  self.rewardBtn.gameObject:SetActive(0 < #newpost)
  self.newMail.gameObject:SetActive(0 < #newpost)
  self.newMail:MakePixelPerfect()
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateBagNum()
  if not self.bagNum then
    self.bagNum = self:FindComponent("BagNum", UILabel, self.bagBtn)
  end
  local bagData = BagProxy.Instance.bagData
  local bagItems = bagData:GetItemsWithoutNoPile()
  local uplimit = bagData:GetUplimit()
  local bagItemNum = #bagItems
  if 0 < uplimit and uplimit <= bagItemNum then
    self.bagNum.gameObject:SetActive(true)
    self.bagNum.text = bagItemNum .. "/" .. uplimit
  else
    self.bagNum.gameObject:SetActive(false)
  end
end

local _noamalTempBagLabColor = "656687"
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
  return nil
end
local _redShowRate = GameConfig.PackMail and GameConfig.PackMail.RedShowRate or 90
local _showCount = GameConfig.PackMail and GameConfig.PackMail.showCount or 100

function MainViewMenuPage:UpdateTempBagButton()
  local tempBagdatas = BagProxy.Instance.tempBagData:GetItems()
  local tempBagLimit = BagProxy.Instance.tempBagData:GetUplimit()
  local hasDelWarnning = false
  for i = 1, #tempBagdatas do
    if tempBagdatas[i]:GetDelWarningState() then
      hasDelWarnning = true
      break
    end
  end
  if #tempBagdatas >= _showCount then
    self.tempBagNumLabel.text = #tempBagdatas .. "/" .. tempBagLimit
    local rate = #tempBagdatas / tempBagLimit
    if rate > _redShowRate / 100 then
      self.tempBagNumLabel.effectStyle = UILabel.Effect.None
      ColorUtil.RedLabel(self.tempBagNumLabel)
    else
      self.tempBagNumLabel.effectStyle = UILabel.Effect.Outline8
      local c = _ParseColor(_noamalTempBagLabColor)
      if c then
        self.tempBagNumLabel.effectColor = c
      end
      ColorUtil.WhiteUIWidget(self.tempBagNumLabel)
    end
    self:Show(self.tempBagNumLabel)
  else
    self:Hide(self.tempBagNumLabel)
  end
  self.tempBagWarning:SetActive(hasDelWarnning)
  self.tempBagButton:SetActive(0 < #tempBagdatas)
  if self.ButtonGrid2_UIGrid then
    self.ButtonGrid2_UIGrid:Reposition()
  end
end

function MainViewMenuPage:ToView(viewconfig, viewdata)
  if viewconfig and viewconfig.id == 83 then
    PersonalPicturePanel.ViewType = UIViewType.NormalLayer
  end
  if viewconfig.id == 2700 then
    NewRechargeProxy.Instance:CallClientPayLog(114)
  elseif viewconfig.id == 2500 then
    NewRechargeProxy.Instance:CallClientPayLog(116)
  elseif viewconfig.id == 5310 then
    NewRechargeProxy.Instance:CallClientPayLog(121)
  end
  self:sendNotification(UIEvent.JumpPanel, {view = viewconfig, viewdata = viewdata})
end

function MainViewMenuPage:MapViewInterests()
  self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync)
  self:AddListenEvt(MainViewEvent.EmojiBtnClick, self.ClickEmojiButton)
  self:AddListenEvt(MyselfEvent.DeathStatus, self.HandleDeathBegin)
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
  self:AddListenEvt(ServiceEvent.SessionMailQueryAllMail, self.UpdateRewardButton)
  self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdateRewardButton)
  self:AddListenEvt(ServiceEvent.ItemQueryPackMailItemCmd, self.UpdateRewardButton)
  self:AddListenEvt(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd, self.HandleUpdatetemScene)
  self:AddListenEvt(UIMenuEvent.UnRegisitButton, self.UnLockMenuButton)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.HandleNewMenu)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleOpenGuildCmd, self.UpdateGuildDateBattleBtn)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.UpdateGuildDateBattleBtn)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.UpdateGuildDateBattleBtn)
  self:AddListenEvt(ItemEvent.TempBagUpdate, self.UpdateTempBagButton)
  self:AddListenEvt(TempItemEvent.TempWarnning, self.UpdateTempBagButton)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBagNum)
  self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.UpdateBagNum)
  self:AddListenEvt(MainViewEvent.MenuActivityOpen, self.HandleUpdateActivity)
  self:AddListenEvt(MainViewEvent.MenuActivityClose, self.HandleUpdateActivity)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleUpdateMatchInfo)
  self:AddListenEvt(MainViewEvent.UpdateMatchBtn, self.HandleUpdateMatchInfo)
  self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.CloseMatchInfo)
  self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, self.HandleUpdateMatchInfo)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseTeamPwsInfo)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HandleUpdateMatchInfo)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.CloseTeamPwsInfo)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_ShutDown, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdSyncMatchInfoCCmd, self.HandleUpdateMatchInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdMidMatchPrepareMatchCCmd, self.HandleUpdateMidMatch)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdatePublishTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdatePublishTeamInfo)
  self:AddListenEvt(ServiceEvent.MatchCCmdSyncMatchHeadInfoMatchCCmd, self.HandleUpdatePvpMatchInfo)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, self.HandleGvgOpenFireGuildCmd)
  self:AddListenEvt(GVGEvent.GVG_FinalFightLaunch, self.UpdateGvgOpenFireButton)
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.UpdateGvgOpenFireButton)
  self:AddListenEvt(MainViewEvent.UpdateTutorMatchBtn, self.UpdateTutorMatchInfo)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd, self.RecvChatCmdQueryRealtimeVoiceIDCmd)
  self:AddListenEvt(PVEEvent.CancelInvite, self.UpdateNewPveInvite)
  self:AddListenEvt(PVEEvent.BeginInvite, self.UpdateNewPveInvite)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.RecvSessionTeamExitTeam)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.RecvGuildCmdExitGuildGuildCmd)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRewardNtfGuildCmd, self.RefreshGuildRedTip)
  self:AddListenEvt(ServiceEvent.BossCmdWorldBossNtf, self.UpdateWorldBossTip)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.ResetWorldBossTip)
  self:AddListenEvt(ExchangeShopEvent.ExchangeShopShow, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateExchangeShopData, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.SessionShopResetExchangeShopDataShopCmd, self.HandleExchangeShopBtnEffect)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleSignInNotify)
  self:AddListenEvt(ServiceEvent.NUserPaySignRewardUserCmd, self.HandlePaySignReward)
  self:AddListenEvt(NewServerSignInEvent.MapViewClose, self.HandleNewServerSignInMapClose)
  self:AddListenEvt(MoroccTimeEvent.ActivityOpen, self.HandleOpenMoroccAct)
  self:AddListenEvt(MoroccTimeEvent.ActivityClose, self.HandleCloseMoroccAct)
  self:AddListenEvt(MoroccTimeEvent.NoNextActivity, self.HandleNoNextMoroccAct)
  self:AddListenEvt(ServiceEvent.ItemLotteryActivityNtfCmd, self.UpdateLotteryActBtn)
  self:AddListenEvt(ServiceEvent.NUserServantReservationUserCmd, self.UpdateReservationTick)
  self:AddListenEvt(ServiceEvent.TeamGroupRaidInviteConfirmRaidTeamGroupCmd, self.StartOnMarkTick)
  self:AddListenEvt(GroupOnMarkEvent.CloseMiniBtn, self.CloseGroupOnMarkBtn)
  self:AddListenEvt(ServiceEvent.ActHitPollyActityHitPollySync, self.RefreshHitPolly)
  self:AddListenEvt(UIMenuEvent.UnlockMenu, self.HandleUnlockMenu)
  self:AddListenEvt(UIMenuEvent.LockMenu, self.HandleLockMenu)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(MyselfEvent.ServantID, self.UpdateServantIcon)
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamPvpInviteMatchCmd, self.UpdateInviteMatch)
  self:AddListenEvt(PVPEvent.TeamPws_ClearInviteMatch, self.UpdateInviteReplyMatch)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.UpdateTimeLimitActButton)
  self:AddListenEvt(PVEEvent.MiniGameMonsterQA_Shutdown, self.ShowTopFuncGrid)
  self:AddListenEvt(PVEEvent.MiniGameMonsterQA_Launch, self.HideTopFuncGrid)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_Shutdown, self.ShowTopFuncGrid)
  self:AddListenEvt(PVEEvent.MiniGameMonsterShot_Launch, self.HideTopFuncGrid)
  self:AddListenEvt(NewContentPushEvent.ShowDoujinshi, self.ShowDoujinContent)
  self:AddListenEvt(NewContentPushEvent.Push, self.UpdateJPNewContentPush)
  self:AddListenEvt(MainViewEvent.HideMapForbidNode, self.OnHideMapForbidNode)
  self:AddListenEvt(MainViewEvent.ShowMapForbidNode, self.OnShowMapForbidNode)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(MainViewEvent.RefreshCameraStatus, self.refreshCameraStatus)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandlePlayerMapChange)
  self:AddListenEvt(SetEvent.CameraCtrlChange, self.RefreshCameraChange)
  self:AddListenEvt(PlotStoryViewEvent.StartPlot, self.HandleCameraSettingHide)
  self:AddListenEvt(PlotStoryViewEvent.EndPlot, self.HandleCameraSettingShow)
  self:AddListenEvt(ActivityPuzzleEvent.ActivityOpen, self.HandleOpenPuzzle)
  self:AddListenEvt(ActivityPuzzleEvent.ActivityClose, self.HandleOpenPuzzle)
  self:AddListenEvt(GuideEvent.OnForceGuideStart, self.DisableClickOtherPlace)
  self:AddListenEvt(GuideEvent.OnForceGuideEnd, self.EnableClickOtherPlace)
  self:AddListenEvt(GuideEvent.OnGuideEnd, self.EnableClickOtherPlace)
  self:AddListenEvt(MountLotteryEvent.ActivityOpen, self.HandleMountLotteryActivity)
  self:AddListenEvt(MountLotteryEvent.ActivityClose, self.HandleMountLotteryActivity)
  self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleProfessionChange)
  self:AddListenEvt(DisneyEvent.DisneyMusicStatusChanged, self.UpdateDisneyMusicState)
  self:AddListenEvt(MyselfEvent.ObservationModeStart, self.HandleObservationModeStart)
  self:AddListenEvt(MyselfEvent.ObservationModeEnd, self.HandleObservationModeEnd)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninActivityCmd, self.HandleRecvDaySignInActivityCmd)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInviteActivityNtfCmd, self.RefreshUserReturnInvite)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.UpdateNoviceShopBtn)
  self:AddListenEvt(ServiceEvent.SceneUser3AccumDepositInfo, self.UpdateAccumulativeShopBtn)
  self:AddListenEvt(ServiceEvent.SceneUser3AccumDepositReward, self.UpdateAccumulativeShopBtn)
  self:AddListenEvt(NoviceShop.RefreshBtn, self.UpdateNoviceShopBtn)
  self:AddListenEvt(AccumulativeShop.RefreshBtn, self.UpdateAccumulativeShopBtn)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.UpdateActivityEvent)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventUserDataNtf, self.UpdateQuestionnaireBtn)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.OnDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.OnDemoRaidShutdown)
  self:AddListenEvt(ServiceEvent.UserEventTimeLimitIconEvent, self.UpdateShopHotBtn)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassNoviceBPTargetUpdateCmd, self.UpdateNoviceBattlePassBtn)
  self:AddListenEvt(ServiceEvent.QuestQueryQuestHeroQuestCmd, self.PreviewSaleRole)
  self:AddListenEvt(ServiceEvent.QuestUpdateQuestHeroQuestCmd, self.PreviewSaleRole)
  self:AddListenEvt(ServiceEvent.ActivityCmdMissionRewardInfoSyncCmd, self.UpdateTimeLimitQuestReward, self)
  self:AddListenEvt(ServiceEvent.QuestUpdateQuestStoryIndexQuestCmd, self.UpdateTimeLimitQuestReward, self)
  self:AddListenEvt(ServiceEvent.QuestAbyssDragonOnOffQuestCmd, self.InitAbyssDragonBtn)
end

function MainViewMenuPage:HandleRedTipUpdate(note)
  local data = note.body
  if data and data.id then
    self:UpdateMainViewRedTipRegister(data.id)
  end
end

local _lotteryTip = {
  [SceneTip_pb.EREDSYS_LOTTERY_ACTIVITY] = 1,
  [SceneTip_pb.EREDSYS_LOTTERY_FREE] = 1,
  [SceneTip_pb.EREDSYS_LOTTERY_DAILY_REWARD] = 1
}

function MainViewMenuPage:UpdateMainViewRedTipRegister(redtipId)
  if nil ~= _lotteryTip[redtipId] then
    if self.lotteryActObjs then
      for t, lotteryActObj in pairs(self.lotteryActObjs) do
        self:_tryRegisterLotteryRedTip(redtipId, t, lotteryActObj)
      end
    end
    if self.lotteryEntranceObj then
      local datas = LotteryProxy.Instance:GetEntranceLotteryActs()
      for i = 1, #datas do
        self:_tryRegisterLotteryRedTip(redtipId, datas[i].lotteryType, self.lotteryEntranceObj)
      end
    end
    if not RedTipProxy.Instance:HasRedTipParam(SceneTip_pb.EREDSYS_LOTTERY_FREE) then
      self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_LOTTERY_FREE, self.DoujinshiButton)
    end
    if not RedTipProxy.Instance:HasRedTipParam(SceneTip_pb.EREDSYS_LOTTERY_DAILY_REWARD) then
      self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_LOTTERY_DAILY_REWARD, self.DoujinshiButton)
    end
    if not RedTipProxy.Instance:HasRedTipParam(SceneTip_pb.EREDSYS_LOTTERY_ACTIVITY) then
      self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_LOTTERY_ACTIVITY, self.DoujinshiButton)
    end
  end
end

function MainViewMenuPage:HandleProfessionChange()
  self:UpdateMainViewRedTipRegister(707)
  self:UpdateMoreBordClassIcon()
end

function MainViewMenuPage:HandleObservationModeStart()
  self:HideTopFuncGrid()
  self.button2Grid:SetActive(false)
end

function MainViewMenuPage:HandleObservationModeEnd()
  self:ShowTopFuncGrid()
  self.button2Grid:SetActive(true)
end

function MainViewMenuPage:UpdateInviteMatch(note)
  local cancel = note.body.iscancel
  self.inviteMatchBtn:SetActive(not cancel)
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateInviteReplyMatch()
  self.inviteMatchBtn:SetActive(false)
end

function MainViewMenuPage:UpdateTimeLimitActButton()
  self:UpdateMidSummerAct()
  self:UpdateCrowdfundingAct()
  self:UpdatePaySignActBtn()
  self:UpdateGrouponBtn()
  self:RefreshMiniRO()
  self:RefreshDisneyGuide()
  self:RefreshUserReturnInvite()
  self:RefreshNewPartnerAct()
  self:RefreshRecommendAct()
  self:RefreshAnniversary2023Btn()
end

function MainViewMenuPage:RefreshUserReturnInvite()
  local invitationCfg = GameConfig.Invitation
  local invitationCfgID
  if invitationCfg then
    for k, v in pairs(invitationCfg) do
      local isOpen = ReturnActivityProxy.Instance:IsUserReturnInviteValid(k)
      if isOpen then
        invitationCfgID = k
        if self.userReturnInviteButton[invitationCfgID] == nil then
          self.userReturnInviteButton[invitationCfgID] = self.container.activityPage:CreateDoujinshiButton(invitationCfg[invitationCfgID].ActivityName, invitationCfg[invitationCfgID].ActivityIcon, function(go)
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.OldPlayerPanel,
              viewdata = {invitationid = invitationCfgID}
            })
          end)
        end
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_RETURNINVITE_AWARD, self.userReturnInviteButton[invitationCfgID], 39)
      elseif self.userReturnInviteButton and self.userReturnInviteButton[k] then
        self.userReturnInviteButton[k]:SetActive(false)
        self.doujinshiGrid:Reposition()
      end
    end
  end
end

function MainViewMenuPage:RefreshRecommendAct()
  local recommendActCfg = GameConfig.RecommendAct
  local recommendActCfgID
  if recommendActCfg then
    for k, v in pairs(recommendActCfg) do
      local isOpen = ReturnActivityProxy.Instance:IsRecommendActOpen(k)
      if isOpen then
        recommendActCfgID = k
        if self.recommendActButton[recommendActCfgID] == nil then
          self.recommendActButton[recommendActCfgID] = self:CreateDoujinshiButton(recommendActCfg[recommendActCfgID].ActivityName, recommendActCfg[recommendActCfgID].ActivityIcon, function(go)
            GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.OldPlayerOverSeaPanel,
              viewdata = {recommendActid = recommendActCfgID}
            })
          end)
        end
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_RECOMMEND, self.recommendActButton[recommendActCfgID], 39)
      elseif self.recommendActButton and self.recommendActButton[k] then
        self.recommendActButton[k]:SetActive(false)
        self.doujinshiGrid:Reposition()
      end
    end
  end
end

function MainViewMenuPage:PreviewSaleRole()
  local open = QuestProxy.Instance:IsPreviewSaleRoleTaskOpen()
  if open then
    if self.previewsalerole == nil then
      local cfg = GameConfig.PreviewSaleRole
      self.previewsalerole = self.container.activityPage:CreateDoujinshiButton(cfg.name, cfg.icon, function(go)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PreviewSaleRoleTaskView,
          viewdata = {}
        })
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_QUESTHERO)
      end)
    end
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_QUESTHERO, self.previewsalerole, 39)
  elseif self.previewsalerole then
    self.previewsalerole:SetActive(false)
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:UpdatePaySignActBtn()
  local cfg = GameConfig.PaySign
  if cfg then
    for actid, tab in pairs(cfg) do
      local open = PaySignProxy.Instance:ActRealOpen(actid)
      if open then
        if nil == self.paySignObj[actid] then
          if not BranchMgr.IsJapan() then
            self.paySignObj[actid] = self.container.activityPage:CreateDoujinshiButton(tab.activityName, tab.activityIcon, function(go)
              if open then
                if PaySignProxy.Instance:CheckPurchased(actid) then
                  ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PAY_SIGN_BUY)
                  self:ToView(PanelConfig.PaySignRewardView, {id = actid})
                else
                  self:ToView(PanelConfig.PaySignEntryView, {id = actid})
                end
              else
                MsgManager.ShowMsgByID(40973)
              end
            end)
          else
            self.paySignObj[actid] = self:CopyGameObject(self.signInButton, self.topRFuncGrid2)
            self.paySignObj[actid].name = "paySignActiBtn"
            self:SetSpriteAndLabel(self.paySignObj[actid], tab.activityIcon, tab.activityName, true)
            self:AddClickEvent(self.paySignObj[actid], function()
              if open then
                if PaySignProxy.Instance:CheckPurchased(actid) then
                  ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PAY_SIGN_BUY)
                  self:ToView(PanelConfig.PaySignRewardView, {id = actid})
                else
                  self:ToView(PanelConfig.PaySignEntryView, {id = actid})
                end
              else
                MsgManager.ShowMsgByID(40973)
              end
            end)
            self:RepositionTopRFuncGrid2()
          end
        end
        self:RegisterRedTipCheck(703, self.paySignObj[actid], 39)
        self:RegisterRedTipCheck(704, self.paySignObj[actid], 39)
      elseif self.paySignObj and self.paySignObj[actid] then
        GameObject.DestroyImmediate(self.paySignObj[actid])
        self.paySignObj[actid] = nil
      end
    end
    if not BranchMgr.IsJapan() then
      self.doujinshiGrid:Reposition()
    end
  end
end

function MainViewMenuPage:UpdateGrouponBtn()
  local grouponCfg = GameConfig.Groupon
  local primeActivityID
  if grouponCfg then
    for k, v in pairs(grouponCfg) do
      local isOpen = GrouponProxy.Instance:ActRealOpen(k)
      if isOpen then
        primeActivityID = k
        if self.grouponButton[primeActivityID] == nil then
          self.grouponButton[primeActivityID] = self.container.activityPage:CreateDoujinshiButton(grouponCfg[primeActivityID].activityName, grouponCfg[primeActivityID].activityIcon, function(go)
            local grouponOpen = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ACTIVITY_GROUPON_OPEN) or 0
            if grouponOpen ~= 0 then
              GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
                view = PanelConfig.GroupPurchaseView,
                viewdata = {type = 2, actid = primeActivityID}
              })
              ServiceNUserProxy.Instance:CallGrouponQueryUserCmd(primeActivityID)
            else
              GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
                view = PanelConfig.GroupPurchaseView,
                viewdata = {type = 1, actid = primeActivityID}
              })
            end
          end)
        end
        self:RegisterRedTipCheck(705, self.grouponButton[primeActivityID], 39)
        self:RegisterRedTipCheck(706, self.grouponButton[primeActivityID], 39)
      elseif self.grouponButton and self.grouponButton[k] then
        self.grouponButton[k]:SetActive(false)
        self.doujinshiGrid:Reposition()
      end
    end
  end
end

function MainViewMenuPage:HandleNewMenu(note)
  if TableUtility.TableFindKey(note.body.list, GameConfig.SystemOpen_MenuId.BoothShopping) then
    self:_StartBooth(1)
  end
  if TableUtility.TableFindKey(note.body.list, 6300) then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_FUNCTION_OPENING)
  end
end

function MainViewMenuPage:HandleUnlockMenu()
  self:UpdateMatchInfo()
  self:InitTransferProfButton()
  self:InitSignIn21Button()
  self:InitSevenRoyalFamiliesEvidenceBookButton()
  self:InitSevenRoyalFamilyTreeButton()
  self:RefreshTechTreeBtn()
  self:RefreshNewbieTechTreeBtn()
  self:RefreshWildMvpBtn()
  self:RefreshNoviceRechargeBtn()
  self:RefreshAnniversary2023Btn()
  self:InitBattlePassBtn()
  self:UpdateLotteryActBtn()
  self:UpdateActivityIntegrationBtns()
end

function MainViewMenuPage:HandleLockMenu()
  self:InitTransferProfButton()
  self:InitSignIn21Button()
  self:InitSevenRoyalFamilyTreeButton()
  self:InitSevenRoyalFamiliesEvidenceBookButton()
  self:RefreshTechTreeBtn()
  self:UpdateTopic()
  self:RefreshNewbieTechTreeBtn()
  self:RefreshWildMvpBtn()
  self:RefreshNoviceRechargeBtn()
  self:RefreshAnniversary2023Btn()
  self:RefreshMoreMenuDatas()
end

function MainViewMenuPage:HandleMyDataChange()
  self:InitSignIn21ButtonHint()
end

function MainViewMenuPage:HandleVarUpdate()
  self:RefreshPlayerSurveyBtn()
  self:RefreshReturnActivityBtn()
end

function MainViewMenuPage:RecvGuildCmdExitGuildGuildCmd(data)
  RedTipProxy.Instance:RemoveWholeTip(46)
end

function MainViewMenuPage:RecvSessionTeamExitTeam(data)
  self:UpdatePublishTeamInfo()
  if self.groupOnMarkBtn then
    GroupRaidProxy.Instance:ResetGroupOnMarkStatus()
    self:CloseGroupOnMarkBtn()
  end
end

function MainViewMenuPage:RecvChatCmdQueryRealtimeVoiceIDCmd(data)
end

function MainViewMenuPage:HandleMapLoaded(note)
  self:UpdateMatchInfo()
  self:UpdateTutorMatchInfo()
  self:UpdateBoothInfo()
  self:CheckDelayJump()
  self:UpdateGuildDateBattleBtn()
  self:RefreshDepositRedTip()
  self:RefreshPeddlerShopRedTip()
  self:RefreshHitPolly()
  self:RefreshMiniRO()
  self:RefreshDisneyGuide()
  FunctionPve.Me():CheckDelayInvite()
  if self.matchInfo_cancelBord == nil then
    return
  end
  self.matchInfo_cancelBord:SetActive(false)
end

function MainViewMenuPage:UpdateNewPveInvite()
  self.pveInviteBtn:SetActive(FunctionPve.Me():IsInviting())
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:HandleGvgOpenFireGuildCmd(note)
  self:UpdateGvgOpenFireButton()
end

function MainViewMenuPage:UpdateGvgOpenFireButton()
  if Game.MapManager:IsGvgMode_Droiyan() then
    self.glandStatusButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  local b = GvgProxy.Instance:IsGvgFlagShow()
  self.glandStatusButton:SetActive(b == true)
  self.topRFuncGrid2:Reposition()
  if GvgProxy.Instance:CheckInSettleTime() then
    self:AddGvgMetalTick()
  else
    self:RemoveGvgMetalTick()
    self.glandStatusButtonLab.text = ZhString.GvgFlagName
  end
end

function MainViewMenuPage:AddGvgMetalTick()
  if self.gvgMetalTick then
    return
  end
  self.gvgMetalTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateGvgMetalTick, self, 53)
end

function MainViewMenuPage:RemoveGvgMetalTick()
  if not self.gvgMetalTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 53)
  self.gvgMetalTick = nil
end

function MainViewMenuPage:_UpdateGvgMetalTick()
  local settleTime = GvgProxy.Instance:GetSettleTime()
  local leftTime = settleTime - ServerTime.CurServerTime() / 1000
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.glandStatusButtonLab.text = string.format(ZhString.GvgFlagNameTimeFormat, min, sec)
end

function MainViewMenuPage:UpdateGuildDateBattleBtn()
  local hasGuild = GuildProxy.Instance:IHaveGuild()
  if hasGuild and GuildDateBattleProxy.Instance:NeedShow() then
    self:Show(self.guildDateBattleBtn)
    self:AddGuildDateTick()
  else
    self:RemoveGuildDateTick()
    self:Hide(self.guildDateBattleBtn)
  end
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:AddGuildDateTick()
  if self.guildDateTick then
    return
  end
  self.guildDateTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateGuildDateTick, self, 54)
end

function MainViewMenuPage:_UpdateGuildDateTick_Preview()
  local start_time = GuildDateBattleProxy.Instance:GetStartTime()
  if not start_time then
    self:RemoveGuildDateTick()
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local leftTime = start_time - cur_time
  if 0 < leftTime then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
    self.guildDateBattleLab.text = string.format(ZhString.GuildDateFormat_Preview, min, sec)
  else
    self:RemoveGuildDateTick()
  end
end

function MainViewMenuPage:_UpdateGuildDateTick_Open()
  local end_time = GuildDateBattleProxy.Instance:GetEndTime()
  if not end_time then
    self:RemoveGuildDateTick()
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local leftTime = end_time - cur_time
  if 0 < leftTime then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
    self.guildDateBattleLab.text = string.format(ZhString.GuildDateFormat, min, sec)
  else
    self:RemoveGuildDateTick()
  end
end

function MainViewMenuPage:_UpdateGuildDateTick()
  if GuildDateBattleProxy.Instance:IsInPreview() then
    self:_UpdateGuildDateTick_Preview()
  else
    self:_UpdateGuildDateTick_Open()
  end
end

function MainViewMenuPage:RemoveGuildDateTick()
  if not self.guildDateTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 54)
  self.guildDateTick = nil
end

local tempV3 = LuaVector3()

function MainViewMenuPage:InitMatchInfo()
  if self.matchInfoButton == nil then
    self.matchInfoButton = self:FindGO("MatchInfoButton")
    self.matchInfoIcon = self:FindComponent("Sprite", UISprite, self.matchInfoButton)
    self.inMatchLabel = self:FindGO("Label", self.matchInfoButton):GetComponent(UILabel)
    self.matchInfo_cancelBord = self:FindGO("CancelBord")
    self.matchInfo_cancelBord_Bg = self:FindComponent("Bg", UISprite, self.matchInfo_cancelBord)
    self.matchInfo_cancelBord = self:FindGO("CancelBord")
    self:AddClickEvent(self.matchInfoButton, function()
      local etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo()
      local isMatching, isfighting
      if etype == PvpProxy.Type.MvpFight or etype == PvpProxy.Type.PoringFight then
        isMatching = matchStatus.ismatch
        isfighting = matchStatus.isfighting
      end
      if isMatching then
        LuaVector3.Better_Set(tempV3, LuaGameObject.GetPosition(self.matchInfoButton.transform))
        self.matchInfo_cancelBord.transform.position = tempV3
        LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalPosition(self.matchInfo_cancelBord.transform))
        LuaVector3.Better_Set(tempV3, tempV3[1], tempV3[2] - 115, tempV3[3])
        self.matchInfo_cancelBord.transform.localPosition = tempV3
        self.matchInfo_cancelBord:SetActive(true)
        self.inMatchLabel.gameObject:SetActive(true)
        self.inMatchLabel.text = ZhString.MVPMatch_InMatch
      elseif isfighting then
        ServiceMatchCCmdProxy.Instance:CallJoinFightingCCmd(PvpProxy.Type.MvpFight)
        self.inMatchLabel.gameObject:SetActive(true)
        self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
      else
        self.matchInfo_cancelBord:SetActive(false)
        self.inMatchLabel.gameObject:SetActive(false)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.MvpMatchView
        })
      end
    end)
    self.matchInfo_cancelButton = self:FindGO("CancelMatchButton", self.matchInfo_cancelBord)
    self:AddClickEvent(self.matchInfo_cancelButton, function(go)
      self:ClickCancelMatch()
    end)
    self:AddListenEvt(XDEUIEvent.CreditNodeBack, function()
      self:SetAddCreditNodeActive(not self.addCreditNode.activeSelf)
    end)
  end
end

local descArgs = {}
local TEAM_LV_FORMAT = "Lv.%s +"
local TEAM_PUBLISH_ARGS_FORMAT = [[
%s
%s]]

function MainViewMenuPage:UpdatePublishTeamInfo()
  local myTeam = TeamProxy.Instance.myTeam
  if nil == self.publishInfoButton then
    self.publishInfoButton = self:FindGO("PublishInfoButton")
    self.publishIcon = self:FindComponent("Sprite", UISprite, self.publishInfoButton)
    self.publishLab = self:FindGO("Label", self.publishInfoButton):GetComponent(UILabel)
    self.publishContainer = self:FindGO("PublishContainer")
    self.cancelPublishBtn = self:FindGO("CancelPublish")
    self.publishDesc = self:FindComponent("PublishDescLab", UILabel)
    self:AddClickEvent(self.publishInfoButton, function(go)
      if self.publishContainer.activeSelf then
        self:Hide(self.publishContainer)
      else
        self:Show(self.publishContainer)
      end
    end)
    self:AddClickEvent(self.cancelPublishBtn, function()
      if TeamProxy.Instance:IHaveGroup() and not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
        MsgManager.ShowMsgByID(39101)
        return
      end
      if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
        MsgManager.ShowMsgByID(374)
        return
      end
      local changeOption = {}
      local teamStateOption = {
        type = SessionTeam_pb.ETEAMDATA_STATE,
        value = SessionTeam_pb.ETEAMSTATE_FREE
      }
      table.insert(changeOption, teamStateOption)
      ServiceSessionTeamProxy.Instance:CallSetTeamOption(nil, changeOption)
    end)
  end
  if not myTeam or myTeam.state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH and myTeam.state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP then
    self:Hide(self.publishInfoButton)
    self.topRFuncGrid2:Reposition()
    return
  end
  self.publishLab.text = ZhString.TeamMemberListPopUp_Publish
  self:Show(self.publishInfoButton)
  self:Hide(self.publishContainer)
  descArgs[1] = Table_TeamGoals[myTeam.type].NameZh
  descArgs[2] = string.format(TEAM_LV_FORMAT, tostring(myTeam.minlv))
  self.publishDesc.text = string.format(TEAM_PUBLISH_ARGS_FORMAT, descArgs[1], descArgs[2])
  self.topRFuncGrid2:Reposition()
end

local Match_CancelMsgId_Map = {
  [PvpProxy.Type.PoringFight] = 3610,
  [PvpProxy.Type.MvpFight] = 7311,
  [PvpProxy.Type.TransferFight] = 3610
}

function MainViewMenuPage:InitTeamPwsMatchButton()
  self.inviteMatchBtn = self:FindGO("InviteMatchBtn")
  self.pwsInviteMatchLab = self:FindComponent("Label", UILabel, self.inviteMatchBtn)
  self.pwsInviteMatchLab.text = ZhString.TeamPws_InviteLab
  self.inviteMatchBtn:SetActive(false)
  self:AddClickEvent(self.inviteMatchBtn, function()
    local etype = PvpProxy.Instance:InviteMatchType()
    if etype then
      MatchPreparePopUp.Show(etype)
    end
  end)
  self.teamPwsMatchButton = self:FindGO("TeamPwsMatchBtn")
  self.labTeamPwsMatchBtn = self:FindComponent("Label", UILabel, self.teamPwsMatchButton)
  self.sprTeamPwsPreCountDown = self:FindComponent("CountDownCircle", UISprite, self.teamPwsMatchButton)
  TeamPwsMatchPopUp.Anchor = self.teamPwsMatchButton.transform
  MatchPreparePopUp.Anchor = self.teamPwsMatchButton.transform
  self:AddClickEvent(self.teamPwsMatchButton, function()
    self:OnClickTeamPwsMatchBtn()
  end)
end

function MainViewMenuPage:OnClickTeamPwsMatchBtn()
  local status, etype = PvpProxy.Instance:GetCurMatchStatus()
  if status then
    if status.isprepare then
      MatchPreparePopUp.Show(etype)
    elseif status.ismatch then
      TeamPwsMatchPopUp.Show(etype)
    end
  else
    LogUtility.Error("未找到匹配状态信息！")
    self:CloseTeamPwsInfo()
  end
end

function MainViewMenuPage:InitMoroccSealButton()
  self.moroccSealButton = self:FindGO("MoroccSealButton")
  local isMorrocTime = MoroccTimeProxy.Instance:IsInMorrocTime()
  self.moroccSealButton:SetActive(isMorrocTime)
  if not isMorrocTime then
    return
  end
  local moroccSealButtonLabel = self:FindComponent("Label", UILabel, self.moroccSealButton)
  moroccSealButtonLabel.text = ZhString.MoroccSeal_ButtonLabel
  local moroccTimeData = MoroccTimeProxy.Instance:GetCurrentMoroccTimeData()
  self:SetMoroccSealButtonState(moroccTimeData ~= nil)
  self:AddClickEvent(self.moroccSealButton, function()
    self:ToView(PanelConfig.MoroccTimePopUp)
  end)
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:SetMoroccSealButtonState(isOpen)
  local sprite = self:FindComponent("Sprite", UISprite, self.moroccSealButton)
  sprite.spriteName = isOpen and "Mrc_open" or "Mrc_close"
  local hintEffectGO = self:FindGO("GlowHint4", self.moroccSealButton)
  if not hintEffectGO and BranchMgr.IsChina() then
    local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
    hintEffectGO = Game.AssetManager_UI:CreateAsset(hintResPath, self.moroccSealButton)
    hintEffectGO.transform.localScale = LuaGeometry.Const_V3_one
  end
  hintEffectGO:SetActive(isOpen)
end

function MainViewMenuPage:HandleOpenMoroccAct()
  if self.moroccSealButton and not self.moroccSealButton.activeSelf then
    self:InitMoroccSealButton()
  else
    self:SetMoroccSealButtonState(true)
  end
end

function MainViewMenuPage:HandleCloseMoroccAct()
  self:SetMoroccSealButtonState(false)
end

function MainViewMenuPage:HandleNoNextMoroccAct()
  self.moroccSealButton:SetActive(false)
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:InitSignInButton(isShow)
  self.signInButton = self:FindGO("SignInButton")
  if not BranchMgr.IsJapan() then
    local signInButtonLabel = self:FindComponent("Label", UILabel, self.signInButton)
    signInButtonLabel.text = ZhString.NewServerSignIn_ButtonLabel
    local isShow = NewServerSignInProxy.Instance:IsSignInNotifyReceived()
    self.signInButton:SetActive(isShow)
    self.signInButtonEnabled = isShow
    if isShow then
      self:TryRegisterSignInRedTipCheck()
    end
    self:AddClickEvent(self.signInButton, function(go)
      if not self.signInButtonEnabled then
        return
      end
      if self.signInHintEffectGO and self.signInHintEffectGO.activeInHierarchy then
        GameObject.Destroy(self.signInHintEffectGO)
        self.signInHintEffectGO = nil
      end
      self:ToView(PanelConfig.NewServerSignInMapView)
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_DAY)
    end)
    self.topRFuncGrid2:Reposition()
    local menuId = GameConfig.SystemOpen_MenuId.NewSignIn
    if menuId then
      FunctionUnLockFunc.Me():RegisteEnterBtn(menuId, self.signInButton)
    end
  else
    if self.signInButton.name ~= "SignInButtonJp" then
      self.signInButton:SetActive(false)
      self.topRFuncGrid2:Reposition()
    end
    if isShow and isShow == true then
      if self.signInButton.name ~= "SignInButtonJp" then
        local sprite = self:FindComponent("Sprite", UISprite, self.signInButton)
        self.signInButton = self:CreatePocketLotteryButton(ZhString.NewServerSignIn_ButtonLabel, "new-main_icon_daliy")
        self.signInButton.name = "SignInButtonJp"
        local newsprite = self:FindComponent("Sprite", UISprite, self.signInButton)
        newsprite.atlas = sprite.atlas
        newsprite.spriteName = sprite.spriteName
        newsprite:MakePixelPerfect()
      end
      local isShow = NewServerSignInProxy.Instance:IsSignInNotifyReceived()
      self.signInButton:SetActive(isShow)
      self.signInButtonEnabled = isShow
      if isShow then
        self:TryRegisterSignInRedTipCheck()
      end
      self:AddClickEvent(self.signInButton, function(go)
        if not self.signInButtonEnabled then
          return
        end
        self:SetAddCreditNodeActive(false)
        self:ToView(PanelConfig.NewServerSignInMapView)
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_DAY)
      end)
      local menuId = GameConfig.SystemOpen_MenuId.NewSignIn
      if menuId then
        FunctionUnLockFunc.Me():RegisteEnterBtn(menuId, self.signInButton)
      end
    end
  end
end

function MainViewMenuPage:TryRegisterSignInRedTipCheck()
  if not self.signInButton then
    return
  end
  if NewServerSignInProxy.Instance.isTodaySigned then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_DAY)
  else
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNIN_DAY, self.signInButton, 39)
  end
end

function MainViewMenuPage:TryRegisterActivitySignInRedTipCheck()
  if not self.activitySignInBtn then
    return
  end
  if not ActivitySignInProxy.Instance.isTodaySigned then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNIN_ACTIVITY, self.activitySignInBtn, 39)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNIN_ACTIVITY, self.DoujinshiButton, 17)
  end
end

function MainViewMenuPage:ClickCancelMatch()
  if self.matchType == nil then
    return
  end
  local msgId = Match_CancelMsgId_Map[self.matchType]
  if msgId == nil then
    return
  end
  MsgManager.ConfirmMsgByID(msgId, function()
    ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(self.matchType)
  end, nil, nil)
  self.matchInfo_cancelBord:SetActive(false)
end

function MainViewMenuPage:ClickMatchGotoButton()
  local actData = FunctionActivity.Me():GetActivityData(GameConfig.PoliFire.PoringFight_ActivityId or 111)
  if actData then
    FuncShortCutFunc.Me():CallByID(actData.traceId)
  end
  self.matchInfo_cancelBord:SetActive(false)
end

function MainViewMenuPage:HandleUpdateMatchInfo(note)
  self:UpdateMatchInfo()
end

function MainViewMenuPage:CloseMatchInfo()
  self.matchInfoButton:SetActive(false)
end

function MainViewMenuPage:CloseTeamPwsInfo()
  TimeTickManager.Me():ClearTick(self, 1)
  self.teamPwsMatchButton:SetActive(false)
  local isOpen = self:_CheckTripleTeamPwsMatchOpen()
  self.tripleTeamPwsMatchBtn:SetActive(isOpen)
  self:RepositionTopRFuncGrid2()
  PvpProxy.Instance:ClearTeamPwsPreInfo()
  PvpProxy.Instance:ClearTeamPwsMatchInfo()
end

local MatchInfoSprite_Map = {
  [PvpProxy.Type.PoringFight] = "new-main_icon_matching",
  [PvpProxy.Type.MvpFight] = "new_main_icon_mvp2",
  [PvpProxy.Type.TransferFight] = "new_main_icon_GVG"
}

function MainViewMenuPage:UpdateMatchInfo(activityType)
  TimeTickManager.Me():ClearTick(self, 1)
  if Game.MapManager:IsPVPMode_MvpFight() or Game.MapManager:IsPVEMode_ExpRaid() then
    self.matchInfoButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  if Game.MapManager:IsPVPMode_TeamPws() then
    self.teamPwsMatchButton:SetActive(false)
    self.topRFuncGrid2:Reposition()
    return
  end
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    local btnActive
    if etype ~= PvpProxy.Type.MvpFight and etype ~= PvpProxy.Type.PoringFight then
      btnActive = matchStatus.ismatch or matchStatus.isprepare
    else
      btnActive = false
    end
    if etype == PvpProxy.Type.Triple then
      local isOpen = self:_CheckTripleTeamPwsMatchOpen()
      self.tripleTeamPwsMatchBtn:SetActive(not btnActive and isOpen)
      local curCount = PvpProxy.Instance:GetTriplePwsMatchCurHeadCount()
      local needCount = PvpProxy.Instance:GetTriplePwsMatchNeedHeadCount()
      self.labTeamPwsMatchBtn.text = string.format(ZhString.Triple_Matching, curCount, needCount)
    else
      self.labTeamPwsMatchBtn.text = matchStatus.isprepare and ZhString.TeamPws_Preparing or ZhString.TeamPws_InMatch
    end
    if self.teamPwsMatchButton.activeSelf ~= btnActive then
      self.teamPwsMatchButton:SetActive(btnActive)
      if btnActive then
        self:OnClickTeamPwsMatchBtn()
      end
    end
    self.robot_rest_time, self.robot_match_time = PvpProxy.Instance:GetRobotTime(etype)
    if not matchStatus.isprepare and self.robot_match_time and self.robot_match_time > 0 then
      self.robot_rest_time = self.robot_rest_time or 0
      self.robot_pvetype = etype
      TimeTickManager.Me():CreateTick(0, 33, self.UpdateRobotTime, self, 51)
    else
      TimeTickManager.Me():ClearTick(self, 51)
    end
    self.sprTeamPwsPreCountDown.gameObject:SetActive(matchStatus.isprepare or false)
    if matchStatus.isprepare then
      self.maxTeamPwsPrepareTime = GameConfig.teamPVP.Countdown
      self.teamPwsStartPrepareTime = PvpProxy.Instance:GetTeamPwsPreStartTime()
      if self.teamPwsStartPrepareTime then
        TimeTickManager.Me():CreateTick(0, 33, self.UpdateTeamPwsPrepareTime, self, 1)
      else
        self.sprTeamPwsPreCountDown.fillAmount = 0
      end
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
    end
  else
    TimeTickManager.Me():ClearTick(self, 51)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
    self:CloseTeamPwsInfo()
  end
  self:UpdateMVP_PoringInfo()
end

function MainViewMenuPage:HandleUpdateMidMatch()
  if PvpProxy.Instance:IsInPreparation() then
    self.labTeamPwsMatchBtn.text = ZhString.MidMatching
  end
end

function MainViewMenuPage:UpdateMVP_PoringInfo()
  local etype, matchStatus
  etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo()
  local active, isfighting
  if matchStatus then
    active = matchStatus.ismatch
    isfighting = matchStatus.isfighting
  else
  end
  self.matchType = etype
  self:InitMatchInfo()
  self.matchInfoIcon.spriteName = MatchInfoSprite_Map[etype] or ""
  local mvpActData
  local menuId = GameConfig.SystemOpen_MenuId.MVPBattle
  if menuId then
    if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      mvpActData = FunctionActivity.Me():GetActivityData(GameConfig.MvpBattle.ActivityID)
    end
  else
    mvpActData = FunctionActivity.Me():GetActivityData(GameConfig.MvpBattle.ActivityID)
  end
  local pollyActData = FunctionActivity.Me():GetActivityData(GameConfig.PoliFire.PoringFight_ActivityId)
  local transferFightActData = FunctionActivity.Me():GetActivityData(9999)
  local actIsOpen = mvpActData or pollyActData or transferFightActData
  local isInMatch = self.matchType == PvpProxy.Type.MvpFight or self.matchType == PvpProxy.Type.PoringFight
  isInMatch = isInMatch and (active or isfighting)
  if actIsOpen and isInMatch then
    self.matchInfoIcon.spriteName = MatchInfoSprite_Map[etype] or ""
    self.matchInfoButton:SetActive(true)
  elseif mvpActData then
    self.matchInfoButton:SetActive(true)
    self.matchInfoIcon.spriteName = "new_main_icon_mvp2"
  else
    self.matchInfoButton:SetActive(false)
    self:RepositionTopRFuncGrid2()
    return
  end
  self.matchInfoIcon:MakePixelPerfect()
  if self.matchInfoIcon.spriteName == "new_main_icon_mvp2" or self.matchInfoIcon.spriteName == "new_main_icon_GVG" then
    self.matchInfoIcon.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  else
    self.matchInfoIcon.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
  self:Show(self.inMatchLabel)
  if etype == PvpProxy.Type.MvpFight or etype == PvpProxy.Type.PoringFight or etype == PvpProxy.Type.TransferFight then
    if active then
      self.inMatchLabel.text = ZhString.MVPMatch_InMatch
    elseif isfighting then
      self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
    else
      self:Hide(self.inMatchLabel)
    end
  else
    self:Hide(self.inMatchLabel)
  end
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateTeamPwsPrepareTime()
  local curTime = (ServerTime.CurServerTime() - self.teamPwsStartPrepareTime) / 1000
  local leftTime = math.max(self.maxTeamPwsPrepareTime - curTime, 0)
  self.sprTeamPwsPreCountDown.fillAmount = leftTime / self.maxTeamPwsPrepareTime
  if leftTime == 0 then
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function MainViewMenuPage:UpdateRobotTime()
  if ServerTime.CurServerTime() / 1000 >= self.robot_match_time and self.robot_pvetype then
    if not TeamPwsMatchPopUp.Instance or not TeamPwsMatchPopUp.Instance.isShow then
      TeamPwsMatchPopUp.Show(self.robot_pvetype)
    end
    TimeTickManager.Me():ClearTick(self, 51)
  end
end

function MainViewMenuPage:HandleUpdateActivity(note)
  local activityType = note.body
  if not activityType then
    return
  end
  local cells = self.activityCtl:GetCells()
  for i = 1, #cells do
    local data = cells[i].data
    if data.type == MainViewButtonType.Activity and data.staticData.id == activityType then
      cells[i]:UpdateActivityState()
      break
    end
  end
  self:ResetMenuButtonPosition()
end

function MainViewMenuPage:GetSkillButton()
  if not self.skillButton then
    local buttons = self.activityCtl:GetCells()
    for i = 1, #buttons do
      local buttonData = buttons[i].data
      if buttonData.panelid == PanelConfig.CharactorProfessSkill.id then
        self.skillButton = buttons[i].gameObject
      end
    end
  end
  return self.skillButton
end

local colorGray = LuaColor.Gray()
local colorWhite = LuaColor.White()

function MainViewMenuPage:HandleDeathBegin(note)
  self.bagBtnSprite.gradientTop = colorGray
  self.bagBtnSprite.gradientBottom = colorGray
  self.bagBtn:GetComponent(BoxCollider).enabled = false
  Game.HotKeyManager:SetHotKeyEnable(37, false)
  local skillButton = self:GetSkillButton()
  if skillButton then
    self:SetTextureGrey(skillButton)
    skillButton:GetComponent(BoxCollider).enabled = false
  end
end

function MainViewMenuPage:HandleReliveStatus(note)
  self.bagBtnSprite.gradientTop = LuaGeometry.GetTempColor(0.8509803921568627, 1, 0.9882352941176471, 1)
  self.bagBtnSprite.gradientBottom = LuaGeometry.GetTempColor()
  self.bagBtn:GetComponent(BoxCollider).enabled = true
  Game.HotKeyManager:SetHotKeyEnable(37, true)
  self:FindComponent("Label", UILabel, self.bagBtn).effectColor = LuaGeometry.GetTempColor(0.12156862745098039, 0.14901960784313725, 0.23137254901960785, 0.5)
  local skillButton = self:GetSkillButton()
  if skillButton then
    self:SetTextureColor(skillButton, colorWhite, true)
    skillButton:GetComponent(BoxCollider).enabled = true
    self:FindComponent("Label", UILabel, skillButton).effectColor = LuaGeometry.GetTempColor(0.03529411764705882, 0.10588235294117647, 0.35294117647058826)
  end
  GvgProxy.Instance:SetReviveMethod(nil)
end

function MainViewMenuPage:HandleEmojiShowSync(note)
  self.isEmojiShow = note.body
end

function MainViewMenuPage:UnLockMenuButton(id)
  self.moreGrid.repositionNow = true
  self.topRFuncGrid.repositionNow = true
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid:Reposition()
    self.ButtonGrid_UIGrid.repositionNow = true
  end
  self:InitSignInButton()
  self:UpdateMatchInfo()
  self:UpdateBoothInfo()
end

function MainViewMenuPage:OnEnter()
  MainViewMenuPage.super.OnEnter(self)
  self:UpdateRewardButton()
  self:UpdateTempBagButton()
  self:UpdateBagNum()
  self:RegisterBagBtnRedTip()
  self:HandleUpdatetemScene()
  self:HandleSignInNotify()
  self:UpdateMatchInfo()
  self:UpdatePublishTeamInfo()
  self:UpdateGvgOpenFireButton()
  self:UpdateDisneyMusicState()
  self:HandleExchangeShopBtnEffect()
  self:UpdateNewPveInvite()
  self:UpdateNoviceShopBtn()
  self:UpdateAccumulativeShopBtn()
  self:UpdateActivityEvent()
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
  ServiceQuestProxy.Instance:CallQueryQuestHeroQuestCmd()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if UIManagerProxy.Instance:IsLockAndroidKey() then
      return
    end
    if self.moreBord.gameObject.activeInHierarchy then
      self.moreBord.gameObject:SetActive(false)
    else
      local callback = UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback()
      callback()
    end
  end)
end

function MainViewMenuPage:OnShow()
  self.active = true
  self:UpdateGroupOnMarkBtn()
  self.ButtonGrid_UIGrid:Reposition()
  self.ButtonGrid_UIGrid.repositionNow = true
  self.topRFuncGrid2:Reposition()
  self.topRFuncGrid:Reposition()
end

function MainViewMenuPage:OnHide()
  self.active = false
  self.moreBord:SetActive(false)
  if self.DoujinshiNode then
    self.DoujinshiNode.gameObject:SetActive(false)
  end
end

function MainViewMenuPage:RepositionTopRFuncGrid2()
  if not self.active then
    return
  end
  self.topRFuncGrid2:Reposition()
  self:Hide(self.topRFuncGrid2)
  self:Show(self.topRFuncGrid2)
end

function MainViewMenuPage:RegisterBagBtnRedTip()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.bagBtn, 42)
  self:RegisterRedTipCheck(FunctionTempItem.UseIntervalRedTip, self.bagBtn, 42)
end

function MainViewMenuPage:OnExit()
  if self.puzzletimeTick then
    TimeTickManager.Me():ClearTick(self, 30)
    self.puzzletimeTick = nil
  end
  if self.reservationTimeTick then
    TimeTickManager.Me():ClearTick(self, 31)
    self.reservationTimeTick = nil
  end
  TimeTickManager.Me():ClearTick(self, 41)
  if self.delayGildTimer then
    self.delayGildTimer:Destroy()
    self.delayGildTimer = nil
  end
  self:RemoveGvgMetalTick()
  self:ClearTripleTeamPwsMatchCheckTimeTick()
  MainViewMenuPage.super.OnExit(self)
end

function MainViewMenuPage:UpdateTutorMatchInfo()
  if not self.tutorMatchInfoBtn then
    self.tutorMatchInfoBtn = self:FindGO("TutorMatchInfoBtn")
  end
  if not self.tutorMatchInfoBtn then
    return
  end
  local status = TutorProxy.Instance:GetTutorMatStatus()
  if status == TutorProxy.TutorMatchStatus.Start then
    self.tutorMatchInfoBtn:SetActive(true)
  else
    self.tutorMatchInfoBtn:SetActive(false)
  end
  self.topRFuncGrid2:Reposition()
  self:AddClickEvent(self.tutorMatchInfoBtn, function()
    if TutorProxy.Instance:CanAsStudent() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TutorMatchView,
        viewdata = TutorType.Tutor
      })
    elseif TutorProxy.Instance:CanAsTutor() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TutorMatchView,
        viewdata = TutorType.Student
      })
    end
  end)
end

function MainViewMenuPage:UpdateBoothInfo()
  local _BoothProxy = BoothProxy.Instance
  local isShow = _BoothProxy:CanMapBooth()
  if isShow and not FunctionPerformanceSetting.Me():GetWalkAround() then
    FunctionSceneFilter.Me():StartFilter(GameConfig.Booth.screenFilterID)
  end
end

function MainViewMenuPage:_TryGetMainViewBooth()
  local info = LocalSaveProxy.Instance:GetMainViewBooth()
  local split = string.split(info, "_")
  if 1 < #split then
    return tonumber(split[1]), tonumber(split[2])
  end
  return 1, ServerTime.CurServerTime()
end

function MainViewMenuPage:_StartBooth(currentState)
  LocalSaveProxy.Instance:SetMainViewBooth(currentState)
  self:UpdateBoothInfo()
end

function MainViewMenuPage:RefreshGuildRedTip()
  helplog("run -> MainViewMenuPage:RefreshGuildRedTip")
  local hasReward = GuildProxy.Instance:GetRewardState()
  if hasReward then
    helplog("GuildRewardState is true")
    RedTipProxy.Instance:UpdateRedTip(46)
  else
    RedTipProxy.Instance:RemoveWholeTip(46)
  end
end

function MainViewMenuPage:RefreshDepositRedTip()
  NewRechargeProxy.Instance:RequestQueryShopItem()
end

function MainViewMenuPage:RefreshPeddlerShopRedTip()
  if self:CheckPeddlerShopOpen() then
    PeddlerShopProxy.Instance:UpdateWholeRedTip()
  end
end

function MainViewMenuPage:CheckPuzzleValidation()
  return ActivityPuzzleProxy.Instance:IsActivityRunning()
end

function MainViewMenuPage:HandleSignInNotify(note)
  self:TryRegisterSignInRedTipCheck()
  self:TryRegisterActivitySignInRedTipCheck()
  self:ActivitySignInBut()
  if note and note.body.type == SceneUser2_pb.ESIGNINTYPE_DAILY and self.signInHintEffectGO then
    GameObject.Destroy(self.signInHintEffectGO)
    self.signInHintEffectGO = nil
  end
end

function MainViewMenuPage:HandlePaySignReward()
  self.DoujinshiNode.gameObject:SetActive(false)
  self:UpdatePaySignActBtn()
end

function MainViewMenuPage:HandleNewServerSignInMapClose()
  local signedCount = NewServerSignInProxy.Instance.signedCount
  if signedCount >= NewServerSignInProxy.Instance.maxDayCount then
    self.signInButtonEnabled = false
    self:TryCreateSignInHintAsset()
    local ta = TweenAlpha.Begin(self.signInButton, 1.5, 0)
    ta.delay = 0.2
    ta:SetOnFinished(function()
      self.signInButton:SetActive(false)
      self.topRFuncGrid2:Reposition()
      NewServerSignInProxy.Instance:SetSignInNotifyNeverReceived()
    end)
  elseif signedCount == 0 or signedCount == 1 and NewServerSignInProxy.Instance.isTodaySigned then
    self:TryCreateSignInHintAsset()
  end
end

function MainViewMenuPage:TryCreateSignInHintAsset()
  if self.isSignInHintCreated then
    return
  end
  local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
  self.signInHintEffectGO = Game.AssetManager_UI:CreateAsset(hintResPath, self:FindGO("EffContainer", self.signInButton))
  self.signInHintEffectGO.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.isSignInHintCreated = true
end

function MainViewMenuPage:CreatePocketLotteryButton(name, spriteName)
  local button = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MainViewButtonCellJP"))
  if not self.addCreditGrid then
    self:InitAddCreditButton()
  end
  button.transform:SetParent(self.addCreditGrid.transform, false)
  self:SetSpriteAndLabel(button, spriteName, name)
  self:ResetPocketLotteryButtonDepth(button)
  return button
end

function MainViewMenuPage:SetSpriteAndLabel(cellGO, spriteName, labelText, _makePixel)
  if _makePixel == nil then
  end
  local makePixel = _makePixel
  local sprite = self:FindComponent("Sprite", UISprite, cellGO)
  if sprite then
    IconManager:SetUIIcon(spriteName, sprite)
    if makePixel then
      sprite:MakePixelPerfect()
    end
  end
  local label = self:FindComponent("Label", UILabel, cellGO)
  if label then
    label.text = labelText
  end
end

function MainViewMenuPage:ResetPocketLotteryButtonDepth(cellGO)
  local bgSprite = cellGO:GetComponent(UISprite)
  bgSprite.depth = 37
  local sprite = self:FindComponent("Sprite", UISprite, cellGO)
  sprite.depth = 38
  local label = self:FindComponent("Label", UILabel, cellGO)
  label.depth = 39
end

function MainViewMenuPage:SetAddCreditNodeActive(isActive)
  isActive = isActive or false
  self.addCreditNode:SetActive(isActive)
  if self.addCreditNode.activeInHierarchy then
    local activeChildren = self.addCreditGrid:GetComponentsInChildren(UIButton, false)
    if type(activeChildren) ~= "table" then
      return
    end
    local row, column
    if 4 < #activeChildren then
      row = 4
    else
      row = #activeChildren
    end
    self.addCreditGridBg.width = 62 + 105 * row
    column = math.ceil(#activeChildren / 4)
    self.addCreditGridBg.height = 62 + 100 * column
    self.addCreditGrid:Reposition()
  end
end

function MainViewMenuPage:InitGroupRaidButton()
  self.groupRaidButton = self:FindGO("GroupRaidButton")
  if self.groupRaidButton then
    self.groupRaidButton:SetActive(false)
  end
end

function MainViewMenuPage:InitNewPveInvite()
  self.pveInviteBtn = self:FindGO("NewPveInviteBtn")
  local pveInviteLab = self:FindComponent("Label", UILabel, self.pveInviteBtn)
  pveInviteLab.text = ZhString.Pve_Invite_MainViewText
  PveInvitePopUp.Anchor = self.pveInviteBtn.transform
  PveGroupInvitePopUp.Anchor = self.pveInviteBtn.transform
  self:AddClickEvent(self.pveInviteBtn, function()
    FunctionPve.Me():TryOpenInviteView()
  end)
end

function MainViewMenuPage:CheckMountLotteryValidation()
  return true == MountLotteryProxy.Instance:CheckMountActivity()
end

function MainViewMenuPage:CheckPushContentValidation()
  return #NewContentPushProxy.Instance:GetPushContentIds() > 0
end

function MainViewMenuPage:CheckActivityRecallOpen()
  local time1 = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RECALL_PRIVILEGE_TIME)
  local time2 = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_RECALL_PRIVILEGE_TIME)
  if not time1 or not time2 then
    return false
  end
  if time1 == time2 and time1 ~= 0 then
    return true
  else
    return false
  end
end

function MainViewMenuPage:CheckPeddlerShopOpen()
  PeddlerShopProxy.Instance:QueryShopConfig()
  return PeddlerShopProxy.Instance:CheckOpen()
end

function MainViewMenuPage:CheckOneZenyGoodsCanBuy()
  NewRechargeProxy.Instance:RequestQueryShopItem()
end

function MainViewMenuPage:CheckBattlePassValidation()
  return true
end

function MainViewMenuPage:QueryBokiData()
  BokiProxy.Instance:InitData()
end

function MainViewMenuPage:CheckDelayJump()
  if GroupRaidProxy.Instance.delayOnMarkJump then
    FunctionNpcFunc.JumpPanel(PanelConfig.GroupOnMarkView)
  end
end

function MainViewMenuPage:InitOnMarkButton()
  self.groupOnMarkBtn = self:FindGO("GroupOnMarkBtn")
  GroupOnMarkView.Anchor = self.groupOnMarkBtn.transform
  self:AddClickEvent(self.groupOnMarkBtn, function()
    self:OnClickGroupOnMarkBtn()
  end)
end

function MainViewMenuPage:OnClickGroupOnMarkBtn()
  local status = GroupRaidProxy.Instance:IsWaitOnMark()
  if status then
    GroupOnMarkView.Show()
  end
end

function MainViewMenuPage:CloseGroupOnMarkBtn()
  self.groupOnMarkBtn:SetActive(false)
  self.topRFuncGrid2:Reposition()
end

local prepareTime = 30

function MainViewMenuPage:StartOnMarkTick()
  if not self.groupOnMarkTick then
    self.groupOnMarkTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateOnMarkTick, self, 21)
    self:UpdateGroupOnMarkBtn()
  else
    TimeTickManager.Me():ClearTick(self, 21)
    self.groupOnMarkTick = nil
    self.groupOnMarkTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateOnMarkTick, self, 21)
    self:UpdateGroupOnMarkBtn()
  end
end

function MainViewMenuPage:UpdateGroupOnMarkBtn()
  self.groupOnMarkBtn:SetActive(GroupRaidProxy.Instance:IsWaitOnMark())
  self.groupOnMarkBtn:SetActive(GroupRaidProxy.Instance:IsWaitOnMark() and nil ~= self.groupOnMarkTick)
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:UpdateOnMarkTick()
  local time = GroupRaidProxy.Instance:GetOnMarkStarttime()
  if time == 0 or not time then
    if self.groupOnMarkTick ~= nil then
      TimeTickManager.Me():ClearTick(self, 21)
      self.groupOnMarkTick = nil
      GroupRaidProxy.Instance:ResetGroupOnMarkStatus()
      self:UpdateGroupOnMarkBtn()
    end
    return
  end
  local curTime = (ServerTime.CurServerTime() - time) / 1000
  if curTime >= prepareTime and self.groupOnMarkTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 21)
    self.groupOnMarkTick = nil
    GroupRaidProxy.Instance:ResetGroupOnMarkStatus()
    self:UpdateGroupOnMarkBtn()
  end
end

function MainViewMenuPage:RefreshQuestManualTip()
  local tipId = 301
  if not FunctionUnLockFunc.Me():CheckCanOpen(6300) then
    RedTipProxy.Instance:RemoveWholeTip(tipId)
    return
  end
  local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_FUNCTION_OPENING)
  if isInRed then
    RedTipProxy.Instance:UpdateRedTip(tipId)
  else
    RedTipProxy.Instance:RemoveWholeTip(tipId)
  end
end

function MainViewMenuPage:RefreshSignIn21Tip()
  do return end
  if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.NoviceTargetPointCFG.MenuID) then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_NOVICE_TARGET)
  end
end

function MainViewMenuPage:ShowTopFuncGrid()
  if self.topRFuncGrid and self.topRFuncGrid.gameObject then
    self.topRFuncGrid.gameObject:SetActive(true)
  end
  if self.topRFuncGrid2 and self.topRFuncGrid2.gameObject then
    self.topRFuncGrid2.gameObject:SetActive(true)
  end
end

function MainViewMenuPage:HideTopFuncGrid()
  if self.topRFuncGrid and self.topRFuncGrid.gameObject then
    self.topRFuncGrid.gameObject:SetActive(false)
  end
  if self.topRFuncGrid2 and self.topRFuncGrid2.gameObject then
    self.topRFuncGrid2.gameObject:SetActive(false)
  end
end

function MainViewMenuPage:InitActivityPuzzleButton()
  local puzzleCfg = GameConfig.ActivityPuzzle
  self.activityPuzzleBtn = self:FindGO("ActivityPuzzleBtn")
  if BranchMgr.IsJapan() then
    self.activityPuzzleBtn:SetActive(false)
    self.activityButtonCellObj = self:CreatePocketLotteryButton(puzzleCfg.labelText, puzzleCfg.iconSprite)
    self.activityButtonCellObj:SetActive(self:CheckPuzzleValidation())
    self:AddClickEvent(self.activityButtonCellObj, function(go)
      self:OpenPuzzleView()
      self:SetAddCreditNodeActive(false)
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PUZZLE, self.activityButtonCellObj, 39)
    self.addCreditGrid:Reposition()
  else
    self.activityPuzzleBtn:SetActive(false)
    self.activityButtonCellObj = self.container.activityPage:CreateDoujinshiButton(puzzleCfg.labelText, puzzleCfg.iconSprite, function(go)
      self:OpenPuzzleView()
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PUZZLE, self.activityButtonCellObj, 39)
  end
end

function MainViewMenuPage:OpenPuzzleView()
  if self:CheckPuzzleValidation() then
    ServiceUserEventProxy.Instance:CallActivityPointUserEvent()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ActivityPuzzleView
    })
  else
    MsgManager.ShowMsgByID(25832)
  end
end

function MainViewMenuPage:HandleOpenPuzzle()
  if BranchMgr.IsJapan() then
  end
end

function MainViewMenuPage:refreshCameraStatus()
  local setting = FunctionPerformanceSetting.Me()
  if setting:GetSetting().disableFreeCamera then
    self.cameraLabel.text = "Lock"
  elseif setting:GetSetting().disableFreeCameraVert then
    self.cameraLabel.text = "2.5D"
  else
    self.cameraLabel.text = "3D"
  end
end

function MainViewMenuPage:UpdateJournalBtn()
  if GameConfig.Journal then
    local journalId = JournalProxy.Instance.currentJournalId
    local config = GameConfig.Journal[journalId]
    if config then
      if not self.journalBtnObj then
        self.journalBtnObj = self.container.activityPage:CreateDoujinshiButton(config.activityName, config.activityIcon, function()
          self:OpenJournalView()
        end)
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_NOTEBOOK, self.journalBtnObj, 39)
      else
        self.journalBtnObj:SetActive(true)
      end
    elseif self.journalBtnObj then
      self.journalBtnObj:SetActive(false)
    end
  end
end

function MainViewMenuPage:OpenJournalView()
  self:ToView(PanelConfig.JournalView)
end

function MainViewMenuPage:InitSupplyDepot()
  if GameConfig.TimeLimitShop then
    if not BranchMgr.IsJapan() then
      self:RegisterRedTipCheck(SupplyDepotProxy.RedTipID, self.DoujinshiButton, 17)
      self.supplyDepotObj, self.supplyDepotCtrl = self.container.activityPage:CreateDoujinshiButton(nil, nil, function(go)
        if not SupplyDepotProxy.Instance:IsActive() then
          MsgManager.ShowMsgByID(40973)
          return
        end
        self.DoujinshiNode.gameObject:SetActive(false)
        self:ToView(PanelConfig.SupplyDepotView)
        RedTipProxy.Instance:RemoveWholeTip(SupplyDepotProxy.RedTipID)
      end)
      self:RegisterRedTipCheck(SupplyDepotProxy.RedTipID, self.supplyDepotObj, 39)
      FunctionUnLockFunc.Me():RegisteEnterBtn(8103, self.supplyDepotObj)
    else
      local proxy = SupplyDepotProxy.Instance
      local isActRunning = proxy:IsActive()
      local config = proxy:GetConfig()
      if config and isActRunning then
        self.supplyDepotObj = self:CreatePocketLotteryButton(config.activityName, config.activityIcon)
        self.supplyDepotObj.name = "supplyDepotObj"
        self.supplyDepotObj:SetActive(true)
        FunctionUnLockFunc.Me():RegisteEnterBtn(8103, self.supplyDepotObj)
        self:AddClickEvent(self.supplyDepotObj, function()
          self:ToView(PanelConfig.SupplyDepotView)
          RedTipProxy.Instance:RemoveWholeTip(SupplyDepotProxy.RedTipID)
          self:SetAddCreditNodeActive(false)
        end)
        self:RegisterRedTipCheck(SupplyDepotProxy.RedTipID, self.supplyDepotObj, 39)
        self.addCreditGrid:Reposition()
      elseif self.supplyDepotObj then
        self.supplyDepotObj:SetActive(false)
      end
    end
  end
end

function MainViewMenuPage:InitPlayerRefluxActButton()
  local proxy = PlayerRefluxProxy.Instance
  local isActRunning = proxy:IsActive()
  local config = proxy:GetConfigMap()
  if not config then
    return
  end
  local isrecallUser = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_RECALL_USER) or -1
  helplog("isrecallUser ==== ", MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_RECALL_USER))
  local activityIcon = ""
  local activityName = ""
  local redTip = {
    PlayerRefluxProxy.RedInvite,
    PlayerRefluxProxy.RedRECALL
  }
  if isrecallUser <= 0 then
    activityIcon = config.ActivityIcon
    activityName = config.ActivityName
  else
    activityIcon = config.ReturnIcon
    activityName = config.ReturnName
  end
  if not BranchMgr.IsJapan() then
    self:RegisterRedTipCheckByIds(redTip, self.DoujinshiButton, 17)
    self.playerRefluxObj, self.playerRefluxObjCtrl = self.container.activityPage:CreateDoujinshiButton(activityName, activityIcon, function(go)
      if not PlayerRefluxProxy.Instance:IsActive() then
        MsgManager.ShowMsgByID(40973)
        return
      end
      self.DoujinshiNode.gameObject:SetActive(false)
      proxy:CallUserInviteInfoCmd()
    end)
    self:RegisterRedTipCheckByIds(redTip, self.playerRefluxObj, 39)
  else
  end
end

function MainViewMenuPage:RefreshNewPartnerAct()
  local proxy = NewPartnerActProxy.Instance
  local config = proxy:GetConfigMap()
  if config then
    if self.newPartnerButton[proxy.actId] == nil then
      self.newPartnerButton[proxy.actId] = self:CreateDoujinshiButton(config.ActivityName, config.ActivityIcon, function(go)
        proxy:CallNewPartnerCmd()
      end)
    end
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_NEWPARTNER, self.newPartnerButton[proxy.actId], 39)
  elseif self.newPartnerButton and self.newPartnerButton[proxy.actIdk] then
    self.newPartnerButton[proxy.actId]:SetActive(false)
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:UpdateRefluxActButton()
  if self.playerRefluxObj == nil then
    return
  end
  local proxy = PlayerRefluxProxy.Instance
  local isActRunning = proxy:IsActive()
  local config = proxy:GetConfigMap()
  if not isActRunning or not config then
    self.playerRefluxObj:SetActive(false)
  end
end

function MainViewMenuPage:InitPushContent()
  if not BranchMgr.IsJapan() then
    return
  end
  local pushContentCfg = GameConfig.PushContent
  if pushContentCfg then
    self.pushContentObj = self:CreatePocketLotteryButton(pushContentCfg.name, pushContentCfg.icon)
    self.pushContentObj.name = "pushContentObj"
    self:AddClickEvent(self.pushContentObj, function()
      if self:CheckPushContentValidation() then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "NewContentPushView"
        })
        self:SetAddCreditNodeActive(false)
      end
    end)
    self.pushContentObj:SetActive(self:CheckPushContentValidation())
    self.addCreditGrid:Reposition()
  end
end

function MainViewMenuPage:UpdateJPNewContentPush()
  if BranchMgr.IsJapan() then
    if self.pushContentObj then
      self.pushContentObj:SetActive(self:CheckPushContentValidation())
    end
    self.addCreditGrid:Reposition()
  end
end

function MainViewMenuPage:UpdateSupplyDepotBtn()
  if GameConfig.TimeLimitShop then
    local proxy = SupplyDepotProxy.Instance
    local isActRunning = proxy:IsActive()
    local config = proxy:GetConfig()
    if config and isActRunning and FunctionUnLockFunc.Me():CheckCanOpen(8103) then
      self.supplyDepotObj:SetActive(true)
      if not BranchMgr.IsJapan() then
        self.supplyDepotCtrl:SetData({
          name = config.activityName,
          icon = config.activityIcon
        })
      else
        self:SetSpriteAndLabel(self.supplyDepotObj, config.activityIcon, config.activityName)
      end
    else
      self.supplyDepotObj:SetActive(false)
    end
  end
end

function MainViewMenuPage:UpdateMidSummerAct()
  local ins = MidSummerActProxy.Instance
  local actMap = ins.activityMap
  if not next(actMap) then
    if self.midSummerActBtnMap then
      for _, obj in pairs(self.midSummerActBtnMap) do
        GameObject.DestroyImmediate(obj)
      end
      self.midSummerActBtnMap = nil
    end
    if not BranchMgr.IsJapan() then
      self.doujinshiGrid:Reposition()
    else
      self.addCreditGrid:Reposition()
    end
    return
  end
  local map, canShow, obj, config = self.midSummerActBtnMap
  for id, _ in pairs(actMap) do
    canShow, obj = ins:CheckActivityValid(id), map and map[id]
    config = GameConfig.FavoriteActivity and GameConfig.FavoriteActivity[id]
    if canShow and config and not obj then
      local upId = id
      if not BranchMgr.IsJapan() then
        obj = self.container.activityPage:CreateDoujinshiButton(config.activityName, config.activityIcon, function()
          if not MidSummerActProxy.Instance:CheckActivityValid(upId) then
            return
          end
          MidSummerActProxy.Instance:Query(upId)
          self:ToView(PanelConfig.MidSummerActView, {id = upId})
        end)
      else
        obj = self:CreatePocketLotteryButton(config.activityName, config.activityIcon)
        self:AddClickEvent(obj, function()
          if not MidSummerActProxy.Instance:CheckActivityValid(upId) then
            return
          end
          MidSummerActProxy.Instance:Query(upId)
          self:ToView(PanelConfig.MidSummerActView, {id = upId})
          self:SetAddCreditNodeActive(false)
        end)
      end
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FAVORITE_REWARD, obj, 39)
    elseif not canShow and obj then
      GameObject.DestroyImmediate(obj)
      obj = nil
    end
    map = map or {}
    map[id] = obj
  end
  if map then
    for id, _ in pairs(map) do
      if not actMap[id] then
        GameObject.DestroyImmediate(map[id])
        map[id] = nil
      end
    end
  end
  self.midSummerActBtnMap = map
  if not BranchMgr.IsJapan() then
    self.doujinshiGrid:Reposition()
  else
    self.addCreditGrid:Reposition()
  end
end

function MainViewMenuPage:UpdateCrowdfundingAct()
  local ins = CrowdfundingActProxy.Instance
  local actMap = ins.activityMap
  if not next(actMap) then
    if self.crowdfundingActBtnMap then
      for _, obj in pairs(self.crowdfundingActBtnMap) do
        GameObject.DestroyImmediate(obj)
      end
      self.crowdfundingActBtnMap = nil
    end
    self:UpdateGrid()
    return
  end
  local map, canShow, obj, config = self.crowdfundingActBtnMap
  for id, _ in pairs(actMap) do
    canShow, obj = ins:CheckActivityValid(id), map and map[id]
    config = GameConfig.DonationActivity and GameConfig.DonationActivity[id]
    if canShow and config and not obj then
      local upId = id
      obj = self.container.activityPage:CreateDoujinshiButton(config.activityName, config.activityIcon, function()
        if not CrowdfundingActProxy.Instance:CheckActivityValid(upId) then
          return
        end
        self:ToView(PanelConfig.CrowdfundingActView, {id = upId})
      end)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_DONATIONACTIVITY, obj, 39)
    elseif not canShow and obj then
      GameObject.DestroyImmediate(obj)
      obj = nil
    end
    map = map or {}
    map[id] = obj
  end
  if map then
    for id, _ in pairs(map) do
      if not actMap[id] then
        GameObject.DestroyImmediate(map[id])
        map[id] = nil
      end
    end
  end
  self.crowdfundingActBtnMap = map
  self.doujinshiGrid:Reposition()
end

function MainViewMenuPage:InitActivityCalendarBtn()
  if BranchMgr.IsJapan() then
    self.activityCalendarBtn = self:CreatePocketLotteryButton(ZhString.Servant_Recommend_CalendarBtnName, "tab_icon_12")
    self:AddClickEvent(self.activityCalendarBtn, function(go)
      self:ToView(PanelConfig.ActivityCalendarView)
    end)
    self.addCreditGrid:Reposition()
  else
    self.activityCalendarBtn = self.container.activityPage:CreateDoujinshiButton(ZhString.Servant_Recommend_CalendarBtnName, "tab_icon_12", function(go)
      self:ToView(PanelConfig.ActivityCalendarView)
    end)
    self.activityCalendarBtn:SetActive(true)
  end
  if self.doujinshiGrid then
    self.doujinshiGrid:Reposition()
  end
end

local announceRedTipId = 10605

function MainViewMenuPage:InitTapTapActivityBtn()
  if BackwardCompatibilityUtil.CompatibilityMode_V58 then
    return
  end
  local config = GameConfig.TapTapActivity
  if not config or self.objBtnTapTap then
    return
  end
  self:RegisterRedTipCheck(config.RedTipID, self.DoujinshiButton, 17)
  self.objBtnTapTap = self.container.activityPage:CreateDoujinshiButton(config.BtnName, config.BtnIcon, function(go)
    FunctionLoginAnnounce.Me().isAnnounced = false
    FunctionTapMoment.GetInstance():OpenMoment(0)
    RedTipProxy.Instance:RemoveWholeTip(config.RedTipID)
    RedTipProxy.Instance:RemoveWholeTip(announceRedTipId)
  end)
  self:RegisterRedTipCheck(config.RedTipID, self.objBtnTapTap, 39)
  FunctionTapMoment.GetInstance():SetCallback(20000, function(code, msg)
    self:RefreshTapTapActivityBtn(code, msg)
  end)
  TimeTickManager.Me():CreateTick(0, 600000, self.FetchNotification, self, 41)
end

function MainViewMenuPage:FetchNotification()
  FunctionTapMoment.GetInstance():GetNoticeData()
end

function MainViewMenuPage:RefreshTapTapActivityBtn(code, msg)
  helplog("RefreshTapTapActivityBtn:", code, msg)
  local config = GameConfig.TapTapActivity
  if not config or "0" == msg or nil == msg then
    return
  end
  self:RegisterRedTipCheck(announceRedTipId, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(announceRedTipId, self.objBtnTapTap, 39)
  RedTipProxy.Instance:UpdateRedTip(announceRedTipId)
end

function MainViewMenuPage:InitTransferProfButton()
  local canShow = FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.SystemOpen_MenuId.ClassShowUI)
  if canShow and not self.transferProfButton then
    self.transferProfButton = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.transferProfButton.name = "TransferProfButton"
    self:SetSpriteAndLabel(self.transferProfButton, "new-main_icon_transfer", ZhString.MainviewMenu_TransferProf)
    self.transferProfButton:SetActive(true)
    self:AddClickEvent(self.transferProfButton, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TransferProfPreview
      })
    end)
    self:AddOrRemoveGuideId(self.transferProfButton, 200)
  elseif not canShow and self.transferProfButton then
    GameObject.DestroyImmediate(self.transferProfButton)
    self.transferProfButton = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:InitSignIn21Button()
  do return end
  local canShow = FunctionUnLockFunc.Me():CheckCanOpen(9921)
  if canShow and not self.signIn21Button then
    self.signIn21Button = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.signIn21Button.name = "SignIn21Button"
    self:SetSpriteAndLabel(self.signIn21Button, "new-main_icon_21days", ZhString.MainviewMenu_SignIn21)
    self.signIn21Button:SetActive(true)
    self:AddClickEvent(self.signIn21Button, function()
      if SignIn21Proxy.Instance:IsAllTargetComplete() then
        MsgManager.ConfirmMsgByID(41406, function()
          FuncShortCutFunc.Me():CallByID(8063)
        end)
      else
        FunctionItemFunc.TwentyOneDaysDevelop()
      end
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_TARGET, self.signIn21Button, 42)
    self:InitSignIn21ButtonHint()
  elseif not canShow and self.signIn21Button then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_TARGET, self.signIn21Button)
    GameObject.DestroyImmediate(self.signIn21Button)
    self.signIn21Button = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:InitSignIn21ButtonHint()
  do return end
  if not self.signIn21Button then
    return
  end
  local level, _ = SignIn21Proxy.Instance:GetLevelAndProgressFromTargetPoint()
  local container = self:FindGO("EffContainer", self.signIn21Button)
  local hintEffectGO = self:FindGO(EffectMap.UI.SignIn21Hint, container)
  local isShow = level ~= nil and level < GameConfig.NoviceTargetPointCFG.HighlightLevel
  if not hintEffectGO and isShow then
    local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.SignIn21Hint)
    hintEffectGO = Game.AssetManager_UI:CreateAsset(hintResPath, container)
    hintEffectGO.transform.localScale = LuaGeometry.Const_V3_one
  elseif hintEffectGO and not isShow then
    GameObject.DestroyImmediate(hintEffectGO)
  end
end

function MainViewMenuPage:InitManorInfoButton()
  local raidId = Game.MapManager:GetRaidID()
  local canShow = raidId == GameConfig.Manor.RaidID
  if canShow and not self.manorBtn then
    self.manorBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.manorBtn.name = "ManorButton"
    self:SetSpriteAndLabel(self.manorBtn, "new-main_icon_Partner-Handbook", ZhString.MainviewMenu_Manor)
    self.manorBtn:SetActive(true)
    self:AddClickEvent(self.manorBtn, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.DisneyFriendsInfoPanel
      })
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MANOR_PARTNER_STORY, self.manorBtn, 42)
  elseif not canShow and self.manorBtn then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_MANOR_PARTNER_STORY, self.manorBtn)
    GameObject.DestroyImmediate(self.manorBtn)
    self.manorBtn = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:InitSevenRoyalFamilyTreeButton()
  local curMapId, config = Game.MapManager:GetMapID(), GameConfig.Family
  local canShow = config ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(config.MenuID) and TableUtility.ArrayFindIndex(config.IconShowMap, curMapId) > 0
  if canShow and not self.sevenRoyalFamilyTreeBtn then
    self.sevenRoyalFamilyTreeBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.sevenRoyalFamilyTreeBtn.name = "SevenRoyalFamilyTreeButton"
    self:SetSpriteAndLabel(self.sevenRoyalFamilyTreeBtn, config.Icon, config.IconText)
    self.sevenRoyalFamilyTreeBtn:SetActive(true)
    self:AddClickEvent(self.sevenRoyalFamilyTreeBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SevenRoyalFamilyTreeView
      })
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FAMILY_REWARD, self.sevenRoyalFamilyTreeBtn, 42)
  elseif not canShow and self.sevenRoyalFamilyTreeBtn then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_FAMILY_REWARD, self.sevenRoyalFamilyTreeBtn)
    GameObject.DestroyImmediate(self.sevenRoyalFamilyTreeBtn)
    self.sevenRoyalFamilyTreeBtn = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:InitSevenRoyalFamiliesEvidenceBookButton()
  local curMapId = Game.MapManager:GetMapID()
  local config = GameConfig.SevenRoyalFamilies
  local canShow = config ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(18056) and TableUtility.ArrayFindIndex(config.MapID, curMapId) > 0
  if canShow and not self.evidenceBookBtn then
    self.evidenceBookBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.evidenceBookBtn.name = "EvidenceBookBookButton"
    self:SetSpriteAndLabel(self.evidenceBookBtn, config.Icon or "new-main_icon_21days", config.IconText or "证据手册")
    self.evidenceBookBtn:SetActive(true)
    self:AddClickEvent(self.evidenceBookBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.DetectiveMainPanel
      })
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SECRET_ENLIGHT, self.evidenceBookBtn, 42)
    ServiceSkillProxy.Instance:CallSkillPerceptAbilityNtf()
    self:AddOrRemoveGuideId(self.evidenceBookBtn, 202)
  elseif not canShow and self.evidenceBookBtn then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_SECRET_ENLIGHT, self.evidenceBookBtn)
    GameObject.DestroyImmediate(self.evidenceBookBtn)
    self.evidenceBookBtn = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:RefreshTechTreeBtn()
  if not TechTreeProxy.Instance:CheckTechTreeUnlock() then
    return
  end
  local curMapId = Game.MapManager:GetMapID()
  local config = GameConfig.TechTree
  local canShow = config and config.IconShowMap and TableUtility.ArrayFindIndex(config.IconShowMap, curMapId) > 0 or false
  if canShow and not self.techTreeBtn then
    self.techTreeBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
    self.techTreeBtn.name = "TechTreeBtn"
    self:SetSpriteAndLabel(self.techTreeBtn, config.MainIcon or "tab_icon_126", config.IconText or "科技树")
    self.techTreeBtn:SetActive(true)
    self:AddClickEvent(self.techTreeBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TechTreeContainerView,
        viewdata = {treeId = 3}
      })
    end)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TECHTREE_LEVEL_AWARD, self.techTreeBtn, 42)
    self:AddOrRemoveGuideId(self.techTreeBtn, 504)
  elseif not canShow and self.techTreeBtn then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_TECHTREE_PRODUCE, self.techTreeBtn)
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_TECHTREE_LEVEL_AWARD, self.techTreeBtn)
    RedTipProxy.Instance:UnRegisterUI(SceneTip_pb.EREDSYS_TECHTREE_LEVEL_AWARD, self.techTreeBtn)
    GameObject.DestroyImmediate(self.techTreeBtn)
    self.techTreeBtn = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:RefreshNewbieTechTreeBtn()
  local config = GameConfig.NoviceTechTree
  if not config then
    return
  end
  local menuid = config and config.MainIconMenu
  if not menuid or not FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
    return
  end
  local hideMenuid = config and config.MainIconMenuDelete
  local menuHide = hideMenuid and FunctionUnLockFunc.Me():CheckCanOpen(hideMenuid) or false
  local curMapId = Game.MapManager:GetMapID()
  local mapShow = not config.IconShowMap or TableUtility.ArrayFindIndex(config.IconShowMap, curMapId) > 0 or false
  if mapShow and not menuHide then
    if not self.newbieTechTreeBtn then
      self.newbieTechTreeBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
      self.newbieTechTreeBtn.name = "NewbieTechTreeBtn"
      self:SetSpriteAndLabel(self.newbieTechTreeBtn, config.MainIcon or "tab_icon_126", config.IconText or "依米尔之心", true)
      self.newbieTechTreeBtn:SetActive(true)
      self:AddClickEvent(self.newbieTechTreeBtn, function()
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.NewbieTechTreeContainerView
        })
      end)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEWBIETECHTREE_LEVEL_AWARD, self.newbieTechTreeBtn, 42)
      self:AddOrRemoveGuideId(self.newbieTechTreeBtn, 476)
      self:RegisterGuideTarget(ClientGuide.TargetType.mainview_techtreebutton, self.newbieTechTreeBtn)
    end
  elseif self.newbieTechTreeBtn then
    self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_NEWBIETECHTREE_LEVEL_AWARD, self.newbieTechTreeBtn)
    GameObject.DestroyImmediate(self.newbieTechTreeBtn)
    self.newbieTechTreeBtn = nil
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:RefreshNoviceRechargeBtn()
  local menuID = GameConfig.NoviceActivity and GameConfig.NoviceActivity.NoviceSignInMenu or 6100
  if not FunctionUnLockFunc.Me():CheckCanOpen(menuID) then
    return
  end
  local showBtn = self:CheckNoviceRechargeEntrance()
  if showBtn then
    if not self.noviceRechargeBtn then
      self.noviceRechargeBtn = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
      self.noviceRechargeBtn.name = "NoviceRechargeBtn"
      local config = GameConfig.NoviceActivity
      self:SetSpriteAndLabel(self.noviceRechargeBtn, config and config.MainIcon or "tab_icon_125", config and config.IconText or "初心福利", true)
      self.noviceRechargeBtn:SetActive(true)
      self:AddClickEvent(self.noviceRechargeBtn, function()
        if self:CheckNoviceRechargeEntrance() then
          self:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.NoviceCombineView
          })
        end
      end)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE, self.noviceRechargeBtn, 42)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_BP, self.noviceRechargeBtn, 42)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FIRST_DEPOSIT, self.noviceRechargeBtn, 42)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NOVICE_CHARGE, self.noviceRechargeBtn, 42)
    end
    if NoviceShopProxy.Instance:UpdateaRewardTip() then
      RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_FIRST_DEPOSIT)
    else
      RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_FIRST_DEPOSIT)
    end
    if not self.noviceRechargeTick then
      self.noviceRechargeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateNoviceRechargeTick, self, SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE)
    end
  else
    if self.noviceRechargeBtn then
      GameObject.DestroyImmediate(self.noviceRechargeBtn)
      self.noviceRechargeBtn = nil
    end
    if self.noviceRechargeTick then
      TimeTickManager.Me():ClearTick(self, SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE)
      self.noviceRechargeTick = nil
    end
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:CheckNoviceRechargeEntrance()
  if DailyLoginProxy.Instance:isNoviceLoginOpen() then
    return true
  end
  if NoviceBattlePassProxy.Instance:IsNoviceBPAvailable() then
    return true
  end
  if NoviceShopProxy.Instance:isShopOpen() then
    return true
  end
  if NoviceRechargeProxy.Instance:GetActValid() then
    return true
  end
  return false
end

function MainViewMenuPage:UpdateNoviceRechargeTick()
  local isValid = self:CheckNoviceRechargeEntrance()
  if not isValid then
    redlog("时间结束")
    self:RefreshNoviceRechargeBtn()
  end
end

function MainViewMenuPage:OnHideMapForbidNode()
  self.topRFuncGrid.gameObject:SetActive(false)
  self.topRFuncGrid2.gameObject:SetActive(false)
end

function MainViewMenuPage:OnShowMapForbidNode()
  self.topRFuncGrid.gameObject:SetActive(true)
  self.topRFuncGrid2.gameObject:SetActive(true)
end

function MainViewMenuPage:HandleHideUIUserCmd(note)
  local data = note.body
  local on = data.open
  if on and on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 6) > 0 then
      self.topRFuncGrid.gameObject:SetActive(false)
      self.topRFuncGrid2.gameObject:SetActive(false)
    end
    if 0 < TableUtility.ArrayFindIndex(data.id, 5) then
      self.ButtonGrid:SetActive(false)
    end
  else
    self.topRFuncGrid.gameObject:SetActive(true)
    self.topRFuncGrid2.gameObject:SetActive(true)
    self.ButtonGrid:SetActive(true)
  end
end

function MainViewMenuPage:EnableClickOtherPlace()
  if self.clickOtherPlace then
    self.clickOtherPlace.enabled = true
  end
end

function MainViewMenuPage:DisableClickOtherPlace()
  if self.clickOtherPlace then
    self.clickOtherPlace.enabled = false
  end
end

function MainViewMenuPage:RefreshSchoolMapLimit()
  local curMap = Game.MapManager:GetMapID()
  local config = GameConfig.Quest.QuestHideMapGroup
  if not config then
    return false
  end
  local v = config[1]
  if v.map and #v.map > 0 then
    for i = 1, #v.map do
      if v.map[i] == curMap then
        return true
      end
    end
  end
  return false
end

function MainViewMenuPage:HandleMountLotteryActivity()
  if self.activityMountObj then
    self.activityMountObj:SetActive(self:CheckMountLotteryValidation())
    self:ResizeDoujinContent()
    self.doujinshiGrid:Reposition()
    return
  elseif self.mountLotteryBut and self.addCreditGrid then
    self.mountLotteryBut:SetActive(self:CheckMountLotteryValidation())
    local activeChildren = self.addCreditGrid:GetComponentsInChildren(UIButton, false)
    if type(activeChildren) ~= "table" then
      return
    end
    local row, column
    row = 4 < #activeChildren and 4 or #activeChildren
    self.addCreditGridBg.width = 62 + 105 * row
    column = math.ceil(#activeChildren / 4)
    self.addCreditGridBg.height = 62 + 100 * column
    self.addCreditGrid:Reposition()
    return
  end
end

function MainViewMenuPage:InitCustomRoomButton()
  self.customRoomButtonGO = self:FindGO("CustomRoomButton")
  self:UpdateCustomRoomButton()
  self:AddClickEvent(self.customRoomButtonGO, function()
    self:OnCustomRoomClicked()
  end)
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.UpdateCustomRoomButton)
  self.customRoomReadyButtonGO = self:FindGO("CustomRoomReadyButton")
  self:UpdateCustomRoomReadyButton()
  self:AddClickEvent(self.customRoomReadyButtonGO, function()
    self:OnCustomroomReadyClicked()
  end)
  self:AddDispatcherEvt(CustomRoomEvent.OnReadyStart, self.UpdateCustomRoomReadyButton)
  self:AddDispatcherEvt(CustomRoomEvent.OnReadyEnd, self.UpdateCustomRoomReadyButton)
end

function MainViewMenuPage:OnCustomRoomClicked()
  PvpCustomRoomProxy.Instance:OpenRoomInfoPopup()
end

function MainViewMenuPage:UpdateCustomRoomButton()
  self.customRoomButtonGO:SetActive(PvpCustomRoomProxy.Instance:GetCurrentRoomData() ~= nil)
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:OnCustomroomReadyClicked()
  if PvpCustomRoomProxy.Instance:IsReadyActive() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsCustomRoomReadyPopup
    })
  end
end

function MainViewMenuPage:UpdateCustomRoomReadyButton()
  self.customRoomReadyButtonGO:SetActive(PvpCustomRoomProxy.Instance:IsReadyActive())
  self.topRFuncGrid2:Reposition()
end

function MainViewMenuPage:InitAccumulativeShop()
  local proxy = AccumulativeShopProxy.Instance
  local endtime = proxy:GetEndDate() or 0
  if not self.accumulativeShopBtn then
    local name = GameConfig.AccumDeposit.ActivityName
    self.accumulativeShopBtn = self.container.activityPage:CreateDoujinshiButton(name, GameConfig.AccumDeposit.ActivityIcon, function(go)
      local lt = (AccumulativeShopProxy.Instance:GetEndDate() or 0) - ServerTime.CurServerTime() / 1000
      if lt <= 0 then
        MsgManager.ShowMsgByID(40973)
        if self.accumulativeShopBtn then
          self.accumulativeShopBtn:SetActive(false)
          RedTipProxy.Instance:RemoveWholeTip(AccumulativeShopProxy.RedTipID)
          if self.doujinshiGrid then
            self.doujinshiGrid:Reposition()
          end
        end
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AccumulativeShopView
      })
    end)
  end
  if self.doujinshiGrid then
    self.doujinshiGrid:Reposition()
  end
  self:RegisterRedTipCheck(AccumulativeShopProxy.RedTipID, self.accumulativeShopBtn, 39)
  if self.accumulativeShopBtn then
    local lefttime = endtime - ServerTime.CurServerTime() / 1000
    if 0 < lefttime then
      self.accumulativeShopBtn:SetActive(true)
    else
      self.accumulativeShopBtn:SetActive(false)
      RedTipProxy.Instance:RemoveWholeTip(AccumulativeShopProxy.RedTipID)
      return
    end
    if proxy:UpdateaRewardTip() or proxy:UpdateRedTip() then
      RedTipProxy.Instance:UpdateRedTip(AccumulativeShopProxy.RedTipID)
    else
      RedTipProxy.Instance:RemoveWholeTip(AccumulativeShopProxy.RedTipID)
    end
  end
end

function MainViewMenuPage:UpdateNoviceShopBtn()
  self:RefreshNoviceRechargeBtn()
end

function MainViewMenuPage:UpdateAccumulativeShopBtn()
  self:InitAccumulativeShop()
end

function MainViewMenuPage:UpdateQuestionnaireBtn()
  if not self.questionnaireBtn then
    local endTime, name = ActivityEventProxy.Instance:GetQuestionnaireInfo()
    endTime = endTime and endTime.endTime
    if endTime then
      name = string.format(ZhString.NpcMenuBtnCell_EndTimeFormat, os.date("%m/%d %H:%M", endTime))
    else
      name = ZhString.Auction_MainViewEndName
    end
    name = string.format([=[
%s
[c][6dccff]%s[-][/c]]=], GameConfig.QuestionnaireScore.Name, name)
    self.questionnaireBtn = self.container.activityPage:CreateDoujinshiButton(name, GameConfig.QuestionnaireScore.Icon, function(go)
      local info = ActivityEventProxy.Instance:GetQuestionnaireInfo()
      local lt = (info and info.endTime or 0) - ServerTime.CurServerTime() / 1000
      if lt <= 0 then
        MsgManager.ShowMsgByID(40973)
        if self.questionnaireBtn then
          self.questionnaireBtn:SetActive(false)
          RedTipProxy.Instance:RemoveWholeTip(GameConfig.QuestionnaireScore.RedTipID)
          if self.doujinshiGrid then
            self.doujinshiGrid:Reposition()
          end
        end
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.QuestionnaireScoreView,
        viewdata = {questionnaire = info}
      })
    end)
  end
  if self.doujinshiGrid then
    self.doujinshiGrid:Reposition()
  end
  self:RegisterRedTipCheck(GameConfig.QuestionnaireScore.RedTipID, self.questionnaireBtn, 39)
  if self.questionnaireBtn then
    local info = ActivityEventProxy.Instance:GetQuestionnaireInfo()
    local st = info and ServerTime.CurServerTime() / 1000 - info.beginTime or 0
    local lt = info and info.endTime - ServerTime.CurServerTime() / 1000 or 0
    local finished = ActivityEventProxy.Instance:CheckQuestionnaireFinished()
    if 0 < st and 0 < lt and not finished then
      self.questionnaireBtn:SetActive(true)
      ActivityEventProxy.Instance:CheckQuestionnaireVisitedToday()
    else
      self.questionnaireBtn:SetActive(false)
      RedTipProxy.Instance:RemoveWholeTip(GameConfig.QuestionnaireScore.RedTipID)
      return
    end
  end
end

function MainViewMenuPage:UpdateActivityEvent()
  self:UpdateQuestionnaireBtn()
  self:UpdateAntiAddiction()
  self:UpdateTimeLimitQuestReward()
end

function MainViewMenuPage:RefreshLotteryBannerBtn()
  if BranchMgr.IsJapan() then
    local btn = self:CreatePocketLotteryButton(ZhString.LotteryBanner_ActivityName, "tab_icon_132")
    self:AddClickEvent(btn, function(go)
      self:_onClickLotteryBanner()
      self:SetAddCreditNodeActive(false)
    end)
    self.addCreditGrid:Reposition()
  else
    if nil == self.lotteryBannerBtn then
      local name = ZhString.LotteryBanner_ActivityName
      self.lotteryBannerBtn = self.container.activityPage:CreateDoujinshiButton(name, "tab_icon_132", function(go)
        self:_onClickLotteryBanner()
      end)
    else
      self.lotteryBannerBtn:SetActive(true)
    end
    self.doujinshiGrid:Reposition()
  end
end

function MainViewMenuPage:UpdateShopHotBtn()
  if self.hotShop == nil then
    self.hotShop = self:FindGO("HotShop")
  end
  if not FunctionUnLockFunc.Me():CheckCanOpen(self.noviceCommunityMenuid) then
    self.hotShop:SetActive(false)
    return
  end
  local showTimeLimitIcon = NewRechargeProxy.Ins:GetShowTimeLimitIcon()
  local hotTabs = GameConfig.NewRecharge.Tabs[4]
  local innerTab
  if hotTabs and hotTabs.Inner and type(showTimeLimitIcon) == "number" and 0 < showTimeLimitIcon then
    for i = 1, #hotTabs.Inner do
      local params = hotTabs.Inner[i].Params
      if params then
        for k, v in pairs(params) do
          if v == showTimeLimitIcon then
            innerTab = hotTabs.Inner[i].ID
            break
          end
        end
      end
      if innerTab then
        break
      end
    end
  end
  if innerTab then
    self.hotShop:SetActive(true)
    self:RepositionTopRFuncGrid2()
    self:AddClickEvent(self.hotShop, function()
      NewRechargeProxy.Instance:readyTriggerEventId(103)
      NewRechargeProxy.Instance:setIsRecordEvent(true)
      FunctionNewRecharge.Instance():OpenUIDefaultPage(innerTab)
      ServiceUserEventProxy.Instance:CallTimeLimitIconEvent()
      self.hotShop:SetActive(false)
      self:RepositionTopRFuncGrid2()
    end)
  else
    self.hotShop:SetActive(false)
    self:RepositionTopRFuncGrid2()
  end
end

function MainViewMenuPage:_onClickLotteryBanner()
  self:ToView(PanelConfig.LotteryBannerView)
end

function MainViewMenuPage:InitBattleFundBtn()
  if GameConfig.BattleFund then
    local proxy = BattleFundProxy.Instance
    local isActRunning = proxy:IsActive()
    local config = proxy:GetConfig()
    local menuId = config and config.MenuId
    local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuId)
    local activityIcon = config and config.ActivityIcon
    local activityName = config and config.ActivityName or ZhString.BattleFundActivityName
    self.battleFundObj, self.battleFundCtrl = self.container.activityPage:CreateDoujinshiButton(activityName, activityIcon, function(go)
      if not BattleFundProxy.Instance:IsActive() then
        MsgManager.ShowMsgByID(40973)
        return
      end
      self.DoujinshiNode.gameObject:SetActive(false)
      self:ToView(PanelConfig.BattleFundView)
      RedTipProxy.Instance:RemoveWholeTip(BattleFundProxy.RedTipID)
    end)
    self:RegisterRedTipCheck(BattleFundProxy.RedTipID, self.DoujinshiButton, 17)
    self:RegisterRedTipCheck(BattleFundProxy.RedTipID, self.battleFundObj, 39)
    FunctionUnLockFunc.Me():RegisteEnterBtn(menuId, self.battleFundObj)
    if isActRunning and canOpen then
      self.battleFundObj:SetActive(true)
    else
      self.battleFundObj:SetActive(false)
    end
  end
end

function MainViewMenuPage:UpdateBattleFundBtn()
  if GameConfig.BattleFund then
    local proxy = BattleFundProxy.Instance
    local isActRunning = proxy:IsActive()
    local config = proxy:GetConfig()
    local activityIcon = config and config.ActivityIcon
    local activityName = config and config.ActivityName or ZhString.BattleFundActivityName
    local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(config and config.MenuId)
    if isActRunning and canOpen then
      self.battleFundObj:SetActive(true)
      if not BranchMgr.IsJapan() then
        self.battleFundCtrl:SetData({name = activityName, icon = activityIcon})
      else
        self:SetSpriteAndLabel(self.battleFundObj, activityIcon, activityName)
      end
    else
      self.battleFundObj:SetActive(false)
    end
  end
end

function MainViewMenuPage:OnDemoRaidLaunch()
  self:HideTopFuncGrid()
end

function MainViewMenuPage:OnDemoRaidShutdown()
  self:ShowTopFuncGrid()
end

function MainViewMenuPage:InitBattlePassBtn()
  local battlePassConfig = GameConfig.BattlePass
  local menuID = battlePassConfig and battlePassConfig.MenuID
  if menuID and not FunctionUnLockFunc.Me():CheckCanOpen(menuID) then
    return
  end
  if battlePassConfig and not self.battlePassObj then
    local event = function(go)
      if self:CheckBattlePassValidation() then
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "ServantBattlePassView"
        })
      end
    end
    local hotKeyParent
    if BranchMgr.IsJapan() then
      self.battlePassObj = self:CreatePocketLotteryButton(battlePassConfig.Name, battlePassConfig.Icon)
      self:AddClickEvent(self.battlePassObj, event)
      hotKeyParent = self:FindComponent("Sprite", UISprite, self.battlePassObj)
    else
      self.battlePassObj = self.container.activityPage:CreateDoujinshiButton(battlePassConfig.Name, battlePassConfig.Icon, event)
      hotKeyParent = self:FindComponent("holderSp", UISprite, self.battlePassObj)
    end
    self:RegisterRedTipCheck(BattlePassProxy.WholeRedTipID, self.battlePassObj, 39)
    Game.HotKeyTipManager:RegisterHotKeyTip(55, hotKeyParent, NGUIUtil.AnchorSide.TopLeft)
  end
end

function MainViewMenuPage:UpdateActivityIntegrationBtns()
  if not GameConfig.ActivityIntegration then
    return
  end
  if not self.actIntegerBtns then
    self.actIntegerBtns = {}
  end
  for groupid, config in pairs(GameConfig.ActivityIntegration) do
    if (not config.MenuID or FunctionUnLockFunc.Me():CheckCanOpen(config.MenuID)) and ActivityIntegrationProxy.Instance:CheckGroupValid(groupid) then
      if not self.actIntegerBtns[groupid] then
        if not BranchMgr.IsJapan() then
          self.actIntegerBtns[groupid] = self.container.activityPage:CreateDoujinshiButton(config.ActivityName, config.ActivityIcon, function(go)
            self:_onClickActivityIntegrationBtn(groupid)
          end)
          self.doujinshiGrid:Reposition()
        else
          self.actIntegerBtns[groupid] = self:CreatePocketLotteryButton(config.ActivityName, config.ActivityIcon)
          self:AddClickEvent(self.actIntegerBtns[groupid], function(go)
            self:_onClickActivityIntegrationBtn(groupid)
          end)
          self.addCreditGrid:Reposition()
        end
        self.actIntegerBtns[groupid]:SetActive(true)
      end
      local bpID = ActivityIntegrationProxy.Instance:GetBPActID(groupid)
      if bpID then
        local isNew = RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_ACT_BP, bpID)
        if isNew then
          self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ACT_BP, self.actIntegerBtns[groupid], 39, nil, nil, bpID)
        else
          self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_ACT_BP, self.actIntegerBtns[groupid])
        end
      end
      local flipCardId = ActivityIntegrationProxy.Instance:GetFlipCardActID(groupid)
      if flipCardId then
        local isNew = RedTipProxy.Instance:IsNew(ActivityFlipCardProxy.RedTipId, flipCardId)
        if isNew then
          self:RegisterRedTipCheck(ActivityFlipCardProxy.RedTipId, self.actIntegerBtns[groupid], 39, nil, nil, flipCardId)
        else
          self:UnRegisterSingleRedTipCheck(ActivityFlipCardProxy.RedTipId, self.actIntegerBtns[groupid])
        end
      end
      local signInActID = ActivityIntegrationProxy.Instance:GetSuperSignInActID(groupid)
      if signInActID and 0 < #signInActID then
        self:UnRegisterSingleRedTipCheck(10757, self.actIntegerBtns[groupid])
        for i = 1, #signInActID do
          local isNew = RedTipProxy.Instance:IsNew(10757, signInActID[i])
          if isNew then
            self:RegisterRedTipCheck(10757, self.actIntegerBtns[groupid], 39, nil, nil, signInActID[i])
          end
        end
      end
      local challengeActIDs = ActivityIntegrationProxy.Instance:GetNewServerChallengeActID(groupid)
      if challengeActIDs and 0 < #challengeActIDs then
        self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE, self.actIntegerBtns[groupid])
        for i = 1, #challengeActIDs do
          local isNew = RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE, challengeActIDs[i])
          if isNew then
            self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE, self.actIntegerBtns[groupid], 39, nil, nil, challengeActIDs[i])
            self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE, self.DoujinshiButton, 17)
          end
        end
      end
      local yearMemoryID = ActivityIntegrationProxy.Instance:GetYearMemoryActID(groupid)
      if yearMemoryID then
        local isNew = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY)
        if isNew then
          self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, self.actIntegerBtns[groupid], 39)
        else
          self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, self.actIntegerBtns[groupid])
        end
      end
      local selfChooseActId = ActivityIntegrationProxy.Instance:GetSelfChooseActID(groupid)
      if selfChooseActId then
        local isNew = RedTipProxy.Instance:IsNew(ActivitySelfChooseProxy.RedTipId, selfChooseActId)
        if isNew then
          self:RegisterRedTipCheck(ActivitySelfChooseProxy.RedTipId, self.actIntegerBtns[groupid], 39, nil, nil, selfChooseActId)
        else
          self:UnRegisterSingleRedTipCheck(ActivitySelfChooseProxy.RedTipId, self.actIntegerBtns[groupid])
        end
      end
      local exchangeActIds = ActivityIntegrationProxy.Instance:GetExchangeActIDs(groupid)
      if exchangeActIds then
        self:UnRegisterSingleRedTipCheck(ActivityExchangeProxy.RedTipId, self.actIntegerBtns[groupid])
        for i = 1, #exchangeActIds do
          local exchangeActId = exchangeActIds[i]
          local isNew = RedTipProxy.Instance:IsNew(ActivityExchangeProxy.RedTipId, exchangeActId)
          if isNew then
            self:RegisterRedTipCheck(ActivityExchangeProxy.RedTipId, self.actIntegerBtns[groupid], 39, nil, nil, exchangeActId)
          end
        end
      end
    elseif self.actIntegerBtns[groupid] then
      self.actIntegerBtns[groupid]:SetActive(false)
    end
  end
end

function MainViewMenuPage:_onClickActivityIntegrationBtn(groupid)
  if not groupid then
    return
  end
  if not ActivityIntegrationProxy.Instance:CheckGroupValid(groupid) then
    redlog("活动已关闭  强制隐藏图标")
    if self.actIntegerBtns[groupid] then
      self.actIntegerBtns[groupid]:SetActive(false)
      return
    end
  end
  self:ToView(PanelConfig.ActivityIntegrationView, {group = groupid})
end

function MainViewMenuPage:UpdateCommunityIntegrationBtn()
  local config = GameConfig.CommunityIntegration
  if not config then
    return
  end
  if CommunityIntegrationProxy.Instance:CheckEntranceValid() then
    if not self.communityIntegrationBtn then
      if not BranchMgr.IsJapan() then
        self.communityIntegrationBtn = self.container.activityPage:CreateDoujinshiButton(config.ActivityName, config.ActivityIcon, function(go)
          self:_onClickCommunityIntegrationBtn()
        end)
      else
        self.communityIntegrationBtn = self:CreatePocketLotteryButton(config.ActivityName, config.ActivityIcon)
        self:AddClickEvent(self.communityIntegrationBtn, function(go)
          self:_onClickCommunityIntegrationBtn()
        end)
      end
    end
    self.communityIntegrationBtn:SetActive(true)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GLOBAL_ACT_REWARD, self.communityIntegrationBtn, 39)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_EVENT_ACT_REWARD, self.communityIntegrationBtn, 39)
  elseif self.communityIntegrationBtn then
    self.communityIntegrationBtn:SetActive(false)
  end
end

function MainViewMenuPage:_onClickCommunityIntegrationBtn()
  if not CommunityIntegrationProxy.Instance:CheckEntranceValid() then
    return
  end
  self:ToView(PanelConfig.CommunityIntegrationView)
end

function MainViewMenuPage:UpdateTimeLimitQuestReward()
  if not GameConfig.LimitTimeQuestReward then
    return
  end
  if not self.timeLimitsQuestBtn then
    self.timeLimitsQuestBtn = {}
  end
  for actid, config in pairs(GameConfig.LimitTimeQuestReward) do
    local actPersonalValid = LimitTimeQuestProxy.Instance:CheckActIsValid(actid)
    if actPersonalValid then
      if not self.timeLimitsQuestBtn[actid] then
        if not BranchMgr.IsJapan() then
          self.timeLimitsQuestBtn[actid] = self.container.activityPage:CreateDoujinshiButton(config.ActivityName, config.ActivityIcon, function(go)
            self:_onClickTimeLimitQuestReward(actid)
          end)
          self.doujinshiGrid:Reposition()
        else
          self.timeLimitsQuestBtn[actid] = self:CreatePocketLotteryButton(config.ActivityName, config.ActivityIcon)
          self:AddClickEvent(self.timeLimitsQuestBtn[actid], function(go)
            self:_onClickTimeLimitQuestReward(actid)
          end)
          self.addCreditGrid:Reposition()
        end
        self.timeLimitsQuestBtn[actid]:SetActive(true)
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MISSION_REWARD, self.timeLimitsQuestBtn[actid], 39, nil, nil, actid)
      end
    elseif self.timeLimitsQuestBtn[actid] then
      self.timeLimitsQuestBtn[actid]:SetActive(false)
    end
  end
  LimitTimeQuestProxy.Instance:RefreshManualRedTips()
end

function MainViewMenuPage:_onClickTimeLimitQuestReward(actid)
  if not actid then
    return
  end
  self:ToView(PanelConfig.QuestLimitTimeView, {actid = actid})
end

function MainViewMenuPage:InitQuestManual()
  local questManual = self:FindGO("QuestManual", self.topRFuncGrid2.gameObject)
  if questManual then
    local nameLabel = self:FindGO("Label", questManual):GetComponent(UILabel)
    nameLabel.text = ZhString.WorldMapMenuPopUp_Quest
    self:AddClickEvent(questManual, function()
      self:ToView(PanelConfig.QuestTracePanel)
    end)
    FunctionUnLockFunc.Me():RegisteEnterBtn(3051, questManual)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_HERO_STORY_QUEST, questManual, 42)
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PRESTIGE_SYSTEM_REWARD, questManual, 42)
    local sp = questManual:GetComponent(UISprite)
    Game.HotKeyTipManager:RegisterHotKeyTip(36, sp, NGUIUtil.AnchorSide.TopLeft, {7, -9})
  end
  self:AddOrRemoveGuideId(questManual, 208)
end

function MainViewMenuPage:InitBoliGold()
  if GameConfig.BoliGold then
    self:InitDoujinshiBtnFunc("boliGoldObj", "boliGoldCtrl", PanelConfig.TreasuryRechargeView, TreasuryRechargeProxy.Instance, TreasuryRechargeProxy.RedTipID)
  end
end

function MainViewMenuPage:UpdateBoliGold()
  if GameConfig.BoliGold then
    self:UpdateDoujinshiBtnFunc("boliGoldObj", "boliGoldCtrl", TreasuryRechargeProxy.Instance)
  end
end

function MainViewMenuPage:InitDoujinshiBtnFunc(btnName, btnCtrlName, toView, proxy, redtipId, shouldRemoveRedtipFunc)
  local isActRunning = proxy:IsActive()
  local config = proxy:GetConfig()
  local menuId = config and config.MenuId
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuId)
  local activityIcon = config and config.ActivityIcon
  local activityName = config and config.ActivityName
  local btnObj, btnCtrl = self.container.activityPage:CreateDoujinshiButton(activityName, activityIcon, function(go)
    if not proxy:IsActive() then
      return
    end
    self.DoujinshiNode.gameObject:SetActive(false)
    local openView = proxy.GetOpenView and proxy:GetOpenView()
    self:ToView(openView or toView)
    if not shouldRemoveRedtipFunc or shouldRemoveRedtipFunc() then
      RedTipProxy.Instance:RemoveWholeTip(redtipId)
    end
  end)
  self:RegisterRedTipCheck(redtipId, self.DoujinshiButton, 17)
  self:RegisterRedTipCheck(redtipId, btnObj, 39)
  FunctionUnLockFunc.Me():RegisteEnterBtn(menuId, btnObj)
  if isActRunning and canOpen then
    btnObj:SetActive(true)
  else
    btnObj:SetActive(false)
  end
  self[btnName] = btnObj
  self[btnCtrlName] = btnCtrl
end

function MainViewMenuPage:UpdateDoujinshiBtnFunc(btnName, btnCtrlName, proxy)
  local isActRunning = proxy:IsActive()
  local config = proxy:GetConfig()
  local activityIcon = config and config.ActivityIcon
  local activityName = config and config.ActivityName
  local menuId = config and config.MenuId
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuId)
  local btnObj = self[btnName]
  local btnCtrl = self[btnCtrlName]
  if isActRunning and canOpen then
    btnObj:SetActive(true)
    if not BranchMgr.IsJapan() then
      btnCtrl:SetData({name = activityName, icon = activityIcon})
    else
      self:SetSpriteAndLabel(btnObj, activityIcon, activityName)
    end
  else
    btnObj:SetActive(false)
  end
end

function MainViewMenuPage:InitDailyDepositBtn()
  if GameConfig.DailyDeposit then
    self:InitDoujinshiBtnFunc("dailyDepositObj", "dailyDepositCtrl", PanelConfig.DailyDepositView, DailyDepositProxy.Instance, DailyDepositProxy.RedTipID, function()
      return not DailyDepositProxy.Instance:HasUntakenReward()
    end)
  end
end

function MainViewMenuPage:UpdateDailyDepositBtn()
  if GameConfig.DailyDeposit then
    self:UpdateDoujinshiBtnFunc("dailyDepositObj", "dailyDepositCtrl", DailyDepositProxy.Instance)
  end
end

function MainViewMenuPage:RefreshWildMvpBtn()
  local proxy = WildMvpProxy.Instance
  local canShow = proxy:CanShow()
  if canShow then
    if not self.wildMvpBtnGO then
      self.wildMvpBtnGO = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
      self.wildMvpBtnGO.name = "WildMvpBtn"
      local config = proxy:GetConfig()
      self:SetSpriteAndLabel(self.wildMvpBtnGO, config.EntryIcon or "tab_icon_138", config.EntryName or "", true)
      self.wildMvpBtnGO:SetActive(true)
      self:AddClickEvent(self.wildMvpBtnGO, function()
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.WildMvpView
        })
      end)
      self:AddOrRemoveGuideId(self.wildMvpBtnGO, 522)
    end
    if self.wildMvpBtnGO then
      self.wildMvpBtnGO:SetActive(true)
    end
  elseif self.wildMvpBtnGO then
    self.wildMvpBtnGO:SetActive(false)
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:UpdateMoreBordClassIcon()
  local cells = self:GetMoreButtonCells()
  for i = 1, #cells do
    if cells[i].data.type == MainViewButtonType.PROFESSION then
      local curJob = MyselfProxy.Instance:GetMyProfession()
      local classConfig = Table_Class[curJob]
      if classConfig then
        IconManager:SetNewProfessionIcon(classConfig.icon, cells[i].sprite)
        cells[i].sprite:MakePixelPerfect()
        cells[i].sprite.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.6, 0.6, 0.6)
      end
    end
  end
end

function MainViewMenuPage:InitAfricanPoringBtn()
  if GameConfig.AfricanPoring then
    self:InitDoujinshiBtnFunc("africanPoringObj", "africanPoringCtrl", PanelConfig.AfricanPoringView, AfricanPoringProxy.Instance, AfricanPoringProxy.RedTipID, function()
      return AfricanPoringProxy.Instance:ShouldRemoveRedTip()
    end)
  end
end

function MainViewMenuPage:UpdateAfricanPoringBtn()
  if GameConfig.AfricanPoring then
    self:UpdateDoujinshiBtnFunc("africanPoringObj", "africanPoringCtrl", AfricanPoringProxy.Instance)
  end
end

function MainViewMenuPage:RefreshAnniversary2023Btn()
  local proxy = Anniversary2023Proxy.Instance
  local canShow = proxy:CanShow()
  if canShow then
    if not self.anniversary2023BtnGO then
      self.anniversary2023BtnGO = self:CopyGameObject(self.signInButton, self.topRFuncGrid2, true)
      self.anniversary2023BtnGO.name = "Anniversary2023Btn"
      local config = proxy:GetConfig()
      self:SetSpriteAndLabel(self.anniversary2023BtnGO, config.ActivityIcon or "", config.ActivityName or "", true)
      self.anniversary2023BtnGO:SetActive(true)
      self:AddClickEvent(self.anniversary2023BtnGO, function()
        proxy:OpenView()
      end)
      self:RegisterRedTipCheck(proxy.redTipId, self.anniversary2023BtnGO, 39)
    end
    if self.anniversary2023BtnGO then
      self.anniversary2023BtnGO:SetActive(true)
    end
  elseif self.anniversary2023BtnGO then
    self.anniversary2023BtnGO:SetActive(false)
  end
  self:RepositionTopRFuncGrid2()
end

function MainViewMenuPage:InitDownloadUIButton()
  local loginData = FunctionLogin.Me():getLoginData()
  local rewarded = loginData.resourceReward == nil and true or loginData.resourceReward
  helplog("MainViewMenuPage:InitDownloadUIButton() reward:", rewarded)
  if (not HotUpdateMgr.IsUpdateDone() or not rewarded) and not Application.isEditor and not Game.inAppStoreReview then
    self.downloadUICellGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("DownloadCell"))
    self.downloadUICellGO.transform:SetParent(self.topRFuncGrid2.transform, false)
    self.downloadUICellGO.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    DownloadCell.new(self.downloadUICellGO)
  end
end

function MainViewMenuPage:UpdateAntiAddiction()
  local isOpen = ActivityEventProxy.Instance:IsAntiAddictionOpen() or false
  self.antiAddictionSp:SetActive(isOpen)
end

local _matchFormat = "(%d+):(%d+):(%d+)"

function MainViewMenuPage:_CheckTripleTeamPwsMatchOpen()
  local matchid = GameConfig.Triple and GameConfig.Triple.SeasonMatchid
  local raidConfig = Table_MatchRaid[matchid]
  if raidConfig then
    local enterLv = raidConfig.EnterLevel
    local myLv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if enterLv > myLv then
      return false
    end
  end
  return PvpProxy.Instance:IsTripleTeamPwsMatchInOpenTime()
end

function MainViewMenuPage:InitTripleTeamPwsMatchBtn()
  self.tripleTeamPwsMatchBtn = self:FindGO("TripleTeamPwsMatchBtn")
  self:AddClickEvent(self.tripleTeamPwsMatchBtn, function()
    self:ToView(PanelConfig.MobaPVPView, {
      tab = PanelConfig.MobaPvpCompetiveView.tab
    })
  end)
  self:CreateTripleTeamPwsMatchCheckTimeTick()
end

function MainViewMenuPage:CreateTripleTeamPwsMatchCheckTimeTick()
  if not self.tripleTeamPwsMatchTick then
    self.tripleTeamPwsMatchTick = TimeTickManager.Me():CreateTick(0, 60000, function()
      local curActive = self.tripleTeamPwsMatchBtn.activeSelf
      if Game.MapManager:IsPVPMode_3Teams() then
        if curActive then
          self.tripleTeamPwsMatchBtn:SetActive(false)
          self.topRFuncGrid2:Reposition()
        end
        return
      end
      local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
      if etype == PvpProxy.Type.Triple and matchStatus and (matchStatus.ismatch or matchStatus.isprepare) then
        if curActive then
          self.tripleTeamPwsMatchBtn:SetActive(false)
          self.topRFuncGrid2:Reposition()
        end
        return
      end
      local isOpen = self:_CheckTripleTeamPwsMatchOpen()
      if self.tripleTeamPwsMatchBtn.activeSelf ~= isOpen then
        self.tripleTeamPwsMatchBtn:SetActive(isOpen)
        self.topRFuncGrid2:Reposition()
      end
    end, self, 333)
  end
end

function MainViewMenuPage:ClearTripleTeamPwsMatchCheckTimeTick()
  if self.tripleTeamPwsMatchTick then
    TimeTickManager.Me():ClearTick(self, 333)
    self.tripleTeamPwsMatchTick = nil
  end
end

function MainViewMenuPage:HandleUpdatePvpMatchInfo(note)
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if etype == PvpProxy.Type.Triple and matchStatus and (matchStatus.ismatch or matchStatus.isprepare) then
    local curCount = PvpProxy.Instance:GetTriplePwsMatchCurHeadCount()
    local needCount = PvpProxy.Instance:GetTriplePwsMatchNeedHeadCount()
    self.labTeamPwsMatchBtn.text = string.format(ZhString.Triple_Matching, curCount, needCount)
  end
end

function MainViewMenuPage:InitAbyssDragonBtn()
  if self.abyssDragonBtn == nil then
    self.abyssDragonBtn = self:FindGO("AbyssDragonBtn")
  end
  local isOn = AbyssFakeDragonProxy.Instance:GetOnOff()
  if isOn then
    local label = self:FindComponent("Label", UILabel, self.abyssDragonBtn)
    label.text = GameConfig.AbyssDragon.activityTitle
    self.abyssDragonBtn:SetActive(true)
    self:RepositionTopRFuncGrid2()
    self:AddClickEvent(self.abyssDragonBtn, function()
      self:ToView(PanelConfig.SpaceDragonIntroView)
    end)
  else
    self.abyssDragonBtn:SetActive(false)
    self:RepositionTopRFuncGrid2()
  end
end
