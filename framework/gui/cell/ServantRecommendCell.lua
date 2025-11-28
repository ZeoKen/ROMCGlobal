local BaseCell = autoImport("BaseCell")
ServantRecommendCell = class("ServantRecommendCell", BaseCell)
local tmpPos = LuaVector3.Zero()
local OFFSET = 200
local greenBtn, yellowBtn, greenEffect, yellowEffect = "new-com_btn_a", "new-com_btn_c", LuaColor.New(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1), LuaColor.New(0.7686274509803922, 0.5254901960784314, 0 / 255, 1)
local graySP, grayLabEffect = "new-com_btn_a_gray", LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
local btnStatus = {
  GO = {
    greenBtn,
    ZhString.Servant_Recommend_MoveTo,
    greenEffect,
    true
  },
  RECEIVE = {
    yellowBtn,
    ZhString.Servant_Recommend_Receive,
    yellowEffect,
    false
  },
  RECEIVE_GROUP_SINGLE = {
    yellowBtn,
    ZhString.Servant_Recommend_Receive,
    yellowEffect,
    true
  },
  RECEIVE_GROUP = {
    yellowBtn,
    ZhString.Servant_Recommend_Receive_Group,
    yellowEffect,
    true
  },
  RECEIVED = {
    greenBtn,
    ZhString.Servant_Recommend_Received,
    yellowEffect,
    false
  },
  DailyKill = {
    greenBtn,
    ZhString.Servant_Recommend_MoveTo,
    greenEffect,
    true
  },
  KJMC = {
    textname = {
      [1] = ZhString.Servant_Recommend_Go,
      [2] = ZhString.AnnounceQuestPanel_AcceptQuest,
      [3] = ZhString.Servant_Recommend_Go,
      [4] = ZhString.AnnounceQuestPanel_CommitQuest
    }
  }
}
local tempVector3 = LuaVector3.Zero()
local EQUIP_SHORTCUT_ID = 522
local KJMC_ID = 521
local KJMC_QUEST_ID = 305000001
local KJMC_GUIDE_QUEST_ID = 99090033
local SEAL_REPAIR = {2, 1002}
local ANNOUNCE_QUEST = {1, 1001}
local XGL = 18
local defaultX = 422
local IsNull = Slua.IsNull
local typeCfgColor = {
  [1] = "[ffa0bf]",
  [2] = "[6ca7ff]",
  [3] = "[ffd44f]",
  [4] = "[bde379]",
  [5] = "[dbb8ef]"
}
local _TipFunc = {77}
autoImport("PveDropItemCell")

function ServantRecommendCell:_defaultX()
  return defaultX
end

function ServantRecommendCell:Init()
  ServantRecommendCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
end

function ServantRecommendCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.quickFinishBtn = self:FindGO("QuickFinishBtn")
  local btnText = self:FindComponent("BtnText", UILabel, self.quickFinishBtn)
  btnText.text = ZhString.Servant_Recommend_QuickFinish
  self.name = self:FindComponent("Name", UILabel)
  self.nameCorner = self:FindComponent("NameCorner", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self.equipShortCutPos = self:FindGO("EquipShortCutPos")
  self.equipShortCutGrid = self:FindGO("EquipShortCutGrid")
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnColider = self.btn:GetComponent(BoxCollider)
  self.dailyKillTaskRewardBtn = self:FindGO("DailyKillTaskRewardBtn")
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.finishedFlag = self:FindComponent("FinishedImg", UISprite)
  IconManager:SetArtFontIcon("com_bg_reached", self.finishedFlag)
  self.everPassLab = self:FindGO("EverPass")
  self.difficulty = self:FindGO("Difficulty")
  self.newRewardIcon = self:FindComponent("Reward", UISprite)
  self.newRewardNum = self:FindComponent("RewardNum", UILabel)
  self.favRewardIcon = self:FindComponent("FavReward", UISprite)
  self.favRewardNum = self:FindComponent("FavRewardNum", UILabel)
  self.BpExp = self:FindGO("BPEXP")
  self.BpExpNum = self:FindComponent("BPEXPNum", UILabel)
  self.pagePfb = self:FindGO("PagePfb")
  self.pageWidget = self:FindComponent("PageWidget", UIWidget)
  self.PageText1 = self:FindComponent("PageText1", UILabel)
  self.PageBg1 = self:FindComponent("PageBg", UISprite, self.PageText1.gameObject)
  self.PageText2 = self:FindComponent("PageText2", UILabel)
  self.PageBg2 = self:FindComponent("PageBg", UISprite, self.PageText2.gameObject)
  self.PageText3 = self:FindComponent("PageText3", UILabel)
  self.PageBg3 = self:FindComponent("PageBg", UISprite, self.PageText3.gameObject)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
  self.tipData = {}
  self.projectPart = self:FindGO("ProjectPart")
  self.rewardLabel_project = SpriteLabel.new(self:FindGO("pReward", self.projectPart), nil, nil, nil, true)
  self.refreshEffectContainer_project = self:FindGO("refreshEffectContainer", self.projectPart)
  self.clickBlocker_project = self:FindGO("clickBlocker", self.projectPart)
  self.g_cmt = self.bg:AddComponent(GuideTagCollection)
  self.g_collider = self.bg:AddComponent(BoxCollider)
  self.g_collider.enabled = false
end

function ServantRecommendCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    self:OnClickBtn()
  end)
  if self.dailyKillTaskRewardBtn then
    self:AddClickEvent(self.dailyKillTaskRewardBtn, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ServantRoundRewardView
      })
    end)
  end
  self:AddClickEvent(self.quickFinishBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SealTaskPopUp,
      viewdata = {costID = 5503}
    })
  end)
  for i = 0, 5 do
    local trans = self.equipShortCutGrid.transform:GetChild(i)
    self:AddClickEvent(trans.gameObject, function(g)
      if self.gotoMode and #self.gotoMode >= 6 then
        FuncShortCutFunc.Me():CallByID(self.gotoMode[i + 1])
      else
        redlog("请检查执事装备打洞的配置GotoMode")
      end
    end)
  end
end

local _endlessPrivateRaidID = GameConfig.endlessPrivate and GameConfig.endlessPrivate.mapraidid or 115
local _danrentaID = 139

function ServantRecommendCell:OnClickBtn()
  if not self.data.ISPROJECT then
    local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_QUEST_ID)
    if self.data.id == KJMC_ID then
      local status = self:GetSpecialState()
      if status == 1 then
        if #self.gotoMode == 2 then
          local temp = Game.Myself.data:IsDoram() and self.gotoMode[1] or self.gotoMode[2]
          FuncShortCutFunc.Me():CallByID(temp)
          GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
        else
          redlog("执事抗击魔潮引导任务GotoMode字段长度应该为2，分别为猫和人")
        end
      elseif status == 2 then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      elseif status == 3 then
        FunctionQuest.Me():executeManualQuest(questData)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      elseif status == 4 then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
      return
    end
    if self.data.id == EQUIP_SHORTCUT_ID then
      self.equipShortCutPos:SetActive(not self.equipShortCutPos.activeSelf)
      return
    end
  end
  if ServantRecommendProxy.STATUS.GO == self.status then
    if self.data.ISPROJECT then
      if self.data.GuideId ~= nil and self.data.GuideId > 0 then
        local guideid = self.data.GuideId
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
        ServiceUserEventProxy.Instance:CallGuideQuestEvent(guideid)
      elseif self.gotoMode and next(self.gotoMode) then
        local gotoMode = table.deepcopy(self.gotoMode)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
        FuncShortCutFunc.Me():CallByID(gotoMode)
      elseif not StringUtil.IsEmpty(self.data.Message) then
        MsgManager.FloatMsg("", self.data.Message)
      elseif self.data.Mapid then
        if self.data.Mapid == _endlessPrivateRaidID then
          local limitLv = GameConfig.endlessPrivate.limitlv or 100
          local curLv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
          if limitLv > curLv then
            MsgManager.ShowMsgByID(2950)
            return
          end
          if TeamProxy.Instance:IHaveTeam() then
            MsgManager.ShowMsgByID(41401)
            return
          end
          ServiceFuBenCmdProxy.Instance:CallReqEnterTowerPrivate(_endlessPrivateRaidID)
        elseif self.data.Mapid == _danrentaID then
          if TeamProxy.Instance:IHaveTeam() then
            MsgManager.ShowMsgByID(41401)
            return
          end
          ServiceFuBenCmdProxy.Instance:CallReqEnterTowerPrivate(_danrentaID)
        else
          ServiceGMProxy.Instance:Call("gocity mapid=" .. self.data.Mapid)
        end
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
      end
      return
    end
    if self.data:IsDailyKillType() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.RecommendDailyMonsterView
      })
      return
    end
    if self.data and self.data:IsActive() and not self.data.real_open then
      MsgManager.ShowMsgByID(25423)
      return
    end
    local finishType = self.data.staticData and self.data.staticData.Finish
    if finishType == "repair_seal" then
      if GameConfig.Servant.SealGeneration then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.SealTaskPopUpV2,
          viewdata = {costID = 5503}
        })
        return
      end
    elseif finishType == "petwork" then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PetView,
        viewdata = {tab = 3}
      })
      return
    elseif finishType == "wanted_quest_day" then
      NewLookBoardProxy.Instance:SetOpenNewPanel(false)
      FunctionVisitNpc.openWantedQuestPanel(101, nil, false)
    elseif finishType == "guild_pray" or finishType == "guild_pray_daily" or finishType == "guild_donate" or finishType == "guild_fuben" then
      if Game.MapManager:IsInGuildMap() then
        FuncShortCutFunc.Me():CallByID(self.gotoMode)
      elseif Game.Myself:IsDead() then
        MsgManager.ShowMsgByIDTable(2500)
      elseif not GuildProxy.Instance:IHaveGuild() then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.GuildInfoView
        })
        return
      else
        xdlog("申请进入公会")
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
        local gotoModeList = {}
        TableUtility.ArrayShallowCopy(gotoModeList, self.gotoMode)
        FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function(gotoModeList)
          FuncShortCutFunc.Me():CallByID(gotoModeList)
        end, gotoModeList)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      end
    else
      FuncShortCutFunc.Me():CallByID(self.gotoMode)
    end
  elseif ServantRecommendProxy.STATUS.RECEIVE == self.status then
    if self.data.ISPROJECT then
      self:Project_RECEIVE()
    else
      ServiceNUserProxy.Instance:CallReceiveServantUserCmd(false, self.id)
    end
  elseif self.data.staticData.CardExtraReward and not self.data.card_extra_rewarded and NewRechargeProxy.Ins:AmIMonthlyVIP() then
    ServiceNUserProxy.Instance:CallReceiveServantUserCmd(false, self.id)
  end
end

local reward_icon, reward_num
local CONST_GIFT_ID, CONST_GIFT_NUM, FAVOR_ICON = 700108, 1, "food_icon_10"
local tempColor = LuaColor.white
local num_Format = "X%s"

function ServantRecommendCell:SetData(data)
  self.data = data
  if data and data.ISPROJECT then
    self:SetData_project(self.data)
    return
  else
    self.projectPart:SetActive(false)
    self.pageWidget.gameObject:SetActive(false)
  end
  local servantID = MyselfProxy.Instance:GetMyServantID()
  if data then
    local isDailyKillType = data:IsDailyKillType()
    self.dailyKillTaskRewardBtn:SetActive(isDailyKillType == true)
    self.bg:SetActive(true)
    local cfg = data.staticData
    if nil == cfg then
      helplog("女仆今日推荐前后端表不一致")
      return
    end
    self.id = data.id
    self.status = data.status
    self.gotoMode = cfg.GotoMode
    local _name
    if isDailyKillType then
      _name = string.format(ZhString.RoundReward_RoundCount, cfg.Name, BattleTimeDataProxy.Instance:GetCurRewardRound(), BattleTimeDataProxy.Instance:GetMaxRewardRound())
    else
      _name = string.format("【%s】", cfg.Name)
    end
    self.name.text = _name
    self.title.text = data.finish_time and string.format(cfg.Title, data.finish_time) or cfg.Title
    local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
    local totalcount, curCount = 0, 0
    local isEverPass = data.status == ServantRecommendProxy.STATUS.EVERPASS
    if dailyData then
      totalcount = dailyData.param1
      curCount = dailyData.param2
    end
    if StringUtil.IsEmpty(cfg.Progress) or isEverPass then
      self.progress.gameObject:SetActive(false)
    else
      self.progress.gameObject:SetActive(true)
      if self.id ~= KJMC_ID then
        if isDailyKillType then
          local killCountEachRound = BattleTimeDataProxy.KillCountEachRound()
          local num = BattleTimeDataProxy.Instance:Timelen() % killCountEachRound
          self.progress.text = string.format(ZhString.RoundReward_RoundCount_, num, killCountEachRound)
          self.progressSlider.value = num / killCountEachRound
        else
          self.progress.text = string.format(cfg.Progress, data.finish_time)
          self.progressSlider.value = data.finish_time / tonumber(string.sub(cfg.Progress, 4))
        end
      else
        self.progress.text = string.format(cfg.Progress, curCount, totalcount)
        self.progressSlider.value = curCount / totalcount
        self.progress.gameObject:SetActive(totalcount ~= 0)
      end
    end
    self.difficulty:SetActive(cfg.Difficulty == 1)
    local exitIcon = IconManager:SetUIIcon(cfg.Icon, self.icon)
    if not exitIcon then
      exitIcon = IconManager:SetItemIcon(cfg.Icon, self.icon)
      if not exitIcon then
        exitIcon = IconManager:SetFaceIcon(cfg.Icon, self.icon)
        if not exitIcon then
          helplog("ServantRecommendCell SetData SetIcon 未在v1、v2、item、Face图集中找到对应icon. 错误ID: ", data and data.id)
        end
      end
    end
    self.rewardGridCtrl:RemoveAll()
    local rewards = isDailyKillType and self.data:GetGroupRewards() or self.data:GetRewards()
    self.rewardGridCtrl:ResetDatas(rewards, nil, true)
    self.icon:MakePixelPerfect()
    ColorUtil.WhiteUIWidget(self.btn)
    if self.id ~= KJMC_ID then
      self.everPassLab:SetActive(false)
      self.finishedFlag.gameObject:SetActive(false)
      LuaVector3.Better_Set(tmpPos, self:_defaultX(), 39.7, 0)
      self.progress.gameObject.transform.localPosition = tmpPos
      if ServantRecommendProxy.STATUS.FINISHED == data.status then
        if cfg.CardExtraReward and not data.card_extra_rewarded then
          self:_setBtnStatue(true, btnStatus.RECEIVE, NewRechargeProxy.Ins:AmIMonthlyVIP() == false)
        else
          self:_setBtnStatue(false)
        end
      elseif ServantRecommendProxy.STATUS.RECEIVE == data.status then
        local config
        if isDailyKillType then
          config = ServantRecommendProxy.Instance:HasGroupRewardToReceive() and btnStatus.RECEIVE_GROUP or btnStatus.RECEIVE_GROUP_SINGLE
        else
          config = btnStatus.RECEIVE
        end
        self:_setBtnStatue(true, config)
      elseif ServantRecommendProxy.STATUS.GO == data.status then
        if self.data and isDailyKillType then
          self:_setBtnStatue(true, btnStatus.DailyKill)
        elseif self.gotoMode == _EmptyTable then
          self.btn.gameObject:SetActive(false)
          LuaVector3.Better_Set(tmpPos, self:_defaultX(), 15, 0)
          self.progress.gameObject.transform.localPosition = tmpPos
          self.finishedFlag.gameObject:SetActive(false)
        else
          self:_setBtnStatue(true, btnStatus.GO)
        end
      elseif isEverPass then
        self:_setBtnStatue(false)
        self.finishedFlag.gameObject:SetActive(false)
        self.everPassLab:SetActive(true)
      end
    else
      local status = self:GetSpecialState()
      self.btn.spriteName = status == 4 and greenBtn or yellowBtn
      self.btnLab.text = btnStatus.KJMC.textname[status]
      self.btnLab.effectColor = status == 4 and greenEffect or yellowEffect
      local complete = curCount == totalcount and curCount ~= 0
      self.btn.gameObject:SetActive(not complete)
      self.everPassLab:SetActive(complete)
      self.progress.gameObject:SetActive(not complete)
    end
    self:SetPage(cfg)
    self.equipShortCutPos:SetActive(false)
    if cfg.Recycle == 6 or cfg.Recycle == 9 or data.double then
      self.nameCorner.color = LuaGeometry.GetTempVector4(1, 0.8980392156862745, 0.4980392156862745, 1)
      self.name.color = LuaGeometry.GetTempVector4(1, 0.47058823529411764, 0, 1)
    else
      self.nameCorner.color = LuaGeometry.GetTempVector4(0.7803921568627451, 0.9686274509803922, 1, 1)
      self.name.color = LuaGeometry.GetTempVector4(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
    end
    local cells = self.rewardGridCtrl:GetCells()
    for i = 1, #cells do
      local isVip = cells[i].data.isVipReward
      if cfg.Recycle == 6 or cfg.Recycle == 9 then
        cells[i]:SetDoubleSymbol(not isVip, true)
      elseif data.double then
        cells[i]:SetDoubleSymbol(not isVip)
      else
        cells[i]:SetDoubleSymbol(false)
      end
      cells[i]:SetVIPSymbol(cells[i].data)
    end
  else
    self.bg:SetActive(false)
  end
  if self.data and self.data.staticData.Finish == "wanted_quest_day" then
    self:AddOrRemoveGuideId(520)
  else
    self:AddOrRemoveGuideId()
  end
end

function ServantRecommendCell:AddOrRemoveGuideId(id)
  if id and id ~= -1 then
    self.g_collider.enabled = true
    self.g_cmt.id = id
    FunctionGuide.Me():setGuideUIActive(id, true)
  else
    FunctionGuide.Me():setGuideUIActive(self.g_cmt.id, false)
    self.g_cmt.id = -1
    self.g_collider.enabled = false
  end
end

function ServantRecommendCell:_getProjectProxy()
  return SignIn21Proxy.Instance
end

function ServantRecommendCell:SetData_project(data)
  if not data then
    return
  end
  local sign21Ins = self:_getProjectProxy()
  local state = sign21Ins:GetTargetState(data.id)
  self.projectPart:SetActive(true)
  self.bg:SetActive(true)
  self.rewardLabel_project:Reset()
  local dataIcon = data.Icon or ""
  local exitIcon = IconManager:SetUIIcon(dataIcon, self.icon)
  if not exitIcon then
    exitIcon = IconManager:SetItemIcon(dataIcon, self.icon)
    if not exitIcon then
      exitIcon = IconManager:SetFaceIcon(dataIcon, self.icon)
      if not exitIcon then
        helplog("ServantRecommendCell SetData SetIcon 未在v1、v2、item、Face图集中找到对应icon. 错误ID: ", data and data.id)
      end
    end
  end
  self.icon:MakePixelPerfect()
  local scale = data.IconScale or 1
  self.icon.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.name.text = data.Title
  if data.SubTitle then
    self.title.text = string.format(data.SubTitle, tostring(sign21Ins:GetTargetProgress(data.id)) or 0)
  elseif data.Description then
    self.title.text = data.Description
  else
    self.title.text = ""
  end
  self.rewardLabel_project:SetText("")
  local rewardList = self:UpdateReward_project(data.Reward)
  self.rewardGridCtrl:RemoveAll()
  self.rewardGridCtrl:ResetDatas(rewardList, nil, true)
  if state == SceneUser2_pb.ENOVICE_TARGET_LOCKED then
    self.icon.color = ColorUtil.NGUIShaderGray
  else
    self.icon.color = ColorUtil.NGUIWhite
  end
  self.difficulty:SetActive(data.Chanllenge ~= nil)
  self.id = data.id
  if state == SceneUser2_pb.ENOVICE_TARGET_REWARDED then
    self.status = ServantRecommendProxy.STATUS.FINISHED
  elseif state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
    self.status = ServantRecommendProxy.STATUS.RECEIVE
  elseif state == SceneUser2_pb.ENOVICE_TARGET_GO then
    self.status = ServantRecommendProxy.STATUS.GO
  else
    self.status = ServantRecommendProxy.STATUS.GO
  end
  self.gotoMode = data.Goto
  self.progress.gameObject:SetActive(true)
  local a = sign21Ins:GetTargetProgress(data.id) or 0
  local b = data.TargetNum or 1
  self.progress.text = a .. "/" .. b
  self.progressSlider.value = a / b
  ColorUtil.WhiteUIWidget(self.btn)
  self.everPassLab:SetActive(false)
  self.finishedFlag.gameObject:SetActive(false)
  LuaVector3.Better_Set(tmpPos, self:_defaultX(), 39.7, 0)
  self.progress.gameObject.transform.localPosition = tmpPos
  if ServantRecommendProxy.STATUS.FINISHED == self.status then
    self:_setBtnStatue(false)
  elseif ServantRecommendProxy.STATUS.RECEIVE == self.status then
    self:_setBtnStatue(true, btnStatus.RECEIVE)
  elseif ServantRecommendProxy.STATUS.GO == self.status then
    self:_setBtnStatue(true, btnStatus.GO)
  end
  self.pageWidget.gameObject:SetActive(true)
  self:SetPage(self.data)
  self.equipShortCutPos:SetActive(false)
  if Recycle == 6 or Recycle == 9 or data.double then
    self.nameCorner.color = LuaGeometry.GetTempVector4(1, 0.8980392156862745, 0.4980392156862745, 1)
    self.name.color = LuaGeometry.GetTempVector4(1, 0.47058823529411764, 0, 1)
  else
    self.nameCorner.color = LuaGeometry.GetTempVector4(0.7803921568627451, 0.9686274509803922, 1, 1)
    self.name.color = LuaGeometry.GetTempVector4(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  end
end

function ServantRecommendCell:UpdateReward_project(rewardTable)
  local array = ReusableTable.CreateArray()
  if type(rewardTable) == "table" then
    for _, id in pairs(rewardTable) do
      local list = ItemUtil.GetRewardItemIdsByTeamId(id)
      if list then
        for i = 1, #list do
          local single = list[i]
          local hasAdd = false
          for j = 1, #array do
            local temp = array[j]
            if temp.id == single.id then
              temp.num = temp.num + single.num
              hasAdd = true
              break
            end
          end
          if not hasAdd then
            local itemData = ItemData.new("Reward", single.id)
            if itemData then
              itemData:SetItemNum(single.num)
              table.insert(array, itemData)
            end
          end
        end
      end
    end
  end
  return array
end

local pageCFG = GameConfig.Servant.ServantRecommendPageType
local CONST_INTERVAL = 10
local CONST_BGWIDTH = 20

function ServantRecommendCell:SetPage(cfg)
  if cfg and cfg.PageType[1] then
    self.PageText1.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[1]].color)
    if result then
      self.PageBg1.color = value
    end
    self.PageText1.text = pageCFG[cfg.PageType[1]].name
    self.PageBg1.width = CONST_BGWIDTH + self.PageText1.width
    self.pageWidget:ResetAndUpdateAnchors()
  else
    self.PageText1.gameObject:SetActive(false)
  end
  if cfg and cfg.PageType[2] then
    self.PageText2.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[2]].color)
    if result then
      self.PageBg2.color = value
    end
    self.PageText2.text = pageCFG[cfg.PageType[2]].name
    self.PageBg2.width = CONST_BGWIDTH + self.PageText2.width
    local x = CONST_INTERVAL + self.PageBg1.width
    tempVector3[1] = x
    self.PageText2.gameObject.transform.localPosition = tempVector3
  else
    self.PageText2.gameObject:SetActive(false)
  end
  if cfg and cfg.PageType[3] then
    self.PageText3.gameObject:SetActive(true)
    local result, value = ColorUtil.TryParseHexString(pageCFG[cfg.PageType[3]].color)
    if result then
      self.PageBg3.color = value
    end
    self.PageText3.text = pageCFG[cfg.PageType[3]].name
    self.PageBg3.width = CONST_BGWIDTH + self.PageText3.width
    local x = CONST_INTERVAL * 2 + self.PageBg2.width + self.PageBg1.width
    tempVector3[1] = x
    self.PageText3.gameObject.transform.localPosition = tempVector3
  else
    self.PageText3.gameObject:SetActive(false)
  end
end

function ServantRecommendCell:GetSpecialState()
  local preQuestData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_GUIDE_QUEST_ID)
  if preQuestData then
    return 1
  else
  end
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(KJMC_QUEST_ID)
  if questData then
    if questData.params.canSubmit then
      return 4
    elseif questData.params.canAccept then
      return 2
    else
      if questData and questData.questDataStepType == QuestDataStepType.QuestDataStepType_DAILY then
        return 3
      else
      end
    end
  else
  end
end

function ServantRecommendCell:_setBtnStatue(showBtn, statusCfg, gray)
  if showBtn then
    self.btnLab.text = statusCfg[2]
    self.btn.spriteName = gray and graySP or statusCfg[1]
    self.btnLab.effectColor = gray and grayLabEffect or statusCfg[3]
    self.progress.gameObject:SetActive(statusCfg[4])
  else
    self.progress.gameObject:SetActive(false)
  end
  local sealValid = self.id == 3 and SealProxy.Instance:CheckQuickFinishValid()
  self.quickFinishBtn:SetActive(sealValid and ServantRecommendProxy.STATUS.GO == self.data.status)
  self.btn.gameObject:SetActive(showBtn)
  self.btnColider.enabled = not gray
  self.everPassLab.gameObject:SetActive(not showBtn)
  if sealValid then
    LuaVector3.Better_Set(tmpPos, self:_defaultX(), -32, 0)
  else
    LuaVector3.Better_Set(tmpPos, self:_defaultX(), self.progress.gameObject.activeSelf and -20 or 0, 0)
  end
  self.btn.gameObject.transform.localPosition = tmpPos
end

function ServantRecommendCell:handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local item_data = cellCtrl.data
    self.tipData.itemdata = item_data
    self.tipData.funcConfig = FunctionItemFunc.CheckBeVIP(item_data) == ItemFuncState.Active and _TipFunc or _EmptyTable
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-230, 0})
  end
end

function ServantRecommendCell:_PlayReceiveEffect()
  self:PlayUIEffect(EffectMap.UI.ufx_deacon_refresh_prf, self.refreshEffectContainer_project, true, function(go, args, assetEffect)
    go.transform:SetParent(self.gameObject.transform.parent.parent)
  end)
end

function ServantRecommendCell:Project_RECEIVE()
  self:_PlayReceiveEffect()
  if self.clickBlocker_project and not IsNull(self.clickBlocker_project) then
    self.clickBlocker_project:SetActive(true)
  end
  self:PassEvent(ServantRecommendView.ShowHideClickBlock, true)
  self.delayRECEIVE = TimeTickManager.Me():CreateOnceDelayTick(GameConfig.NewTopic.GetRewardEffectDuration or 300, function(owner, deltaTime)
    ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(self.id)
    if self.clickBlocker_project and not IsNull(self.clickBlocker_project) then
      self.clickBlocker_project:SetActive(false)
    end
    self:PassEvent(ServantRecommendView.ShowHideClickBlock, false)
  end, self)
end
