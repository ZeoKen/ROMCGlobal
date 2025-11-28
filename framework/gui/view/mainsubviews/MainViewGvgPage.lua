local calSize = NGUIMath.CalculateRelativeWidgetBounds
local getLocalPos = LuaGameObject.GetLocalPosition
local valueFormat = "%s/%s"
local _MinSecFormat = "%02d:%02d"
autoImport("GvgProxy")
autoImport("GvgQuestScoreTip")
MainViewGvgPage = class("MainViewGvgPage", SubMediatorView)

function MainViewGvgPage:Init()
  self.isGuildDate = Game.MapManager:IsGVG_DateBattle()
  local prefab = self:GetPrefabName()
  self:ReLoadPerferb(prefab)
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:InitShow()
  self:resetData()
  self.isInit = true
end

function MainViewGvgPage:GetPrefabName()
  return self.isGuildDate and "view/MainViewGuildDateGvgPage" or "view/MainViewGvgPage"
end

function MainViewGvgPage:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewGvgPage:resetData()
  self.isDefSide = false
  if self.tickMg then
    self:ClearUpdateTick()
  end
end

function MainViewGvgPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewGvgPage:ClearUpdateTick()
  if self.updateTick then
    self.updateTick:Destroy()
    self.updateTick = nil
  end
  self:RemovePerfectDefenseTick()
end

function MainViewGvgPage:initData()
  self.specialSusTime = GameConfig.specialSusTime
  self.specialSusTime = self.specialSusTime and self.specialSusTime or 300
  self.tickMg = TimeTickManager.Me()
  self.gvgIns = GvgProxy.Instance
end

function MainViewGvgPage:Show(tarObj)
  MainViewGvgPage.super.Show(self, tarObj)
  if not tarObj then
    self.isInit = true
    self:SetData()
  end
  self.curServerT = ServerTime.CurServerTime() / 1000
end

function MainViewGvgPage:Hide(tarObj)
  MainViewGvgPage.super.Hide(self, tarObj)
  if not tarObj then
    self.isInit = false
    self:resetData()
  end
  TipsView.Me():HideTip(GvgQuestScoreTip)
  MsgManager.CloseConfirmMsgByID(27182)
end

function MainViewGvgPage:SetData()
  self:UpdateNewDef()
  self:updateHonorValue()
  self:resizeContent()
  self:ClearUpdateTick()
  self:UpdateSmallMetalCtn()
  self.updateTick = self.tickMg:CreateTick(0, 1000, self.updateCountTime, self, 101)
  self:UpdatePerfectDefense()
end

function MainViewGvgPage:UpdatePerfectDefense()
  if self.gvgIns:IsNeutral() then
    self.perfectDefenseCDLab.text = ZhString.MainViewGvgPage_PerfectDefense_Neutral
    self:RemovePerfectDefenseTick()
    return
  end
  if self.gvgIns:IsPerfectDefense() then
    self:HandleDefensePerfectSuccess()
    return
  end
  self.perfectTimeInfo = self.gvgIns:GetPerfectTimeInfo()
  if not self.perfectTimeInfo then
    self:RemovePerfectDefenseTick()
    return
  end
  if self:TrySetPausePerfectTime() then
    return
  end
  if not self.perfectDefenseTick then
    self.perfectDefenseTick = self.tickMg:CreateTick(0, 1000, self._updatePerfectDefenseCD, self, 102)
  end
end

function MainViewGvgPage:TrySetPausePerfectTime()
  if not self.perfectTimeInfo then
    return false
  end
  if not self.perfectTimeInfo.pause then
    return false
  end
  self:PausePerfectDefenseTick()
  local leftTime = self.perfectTimeInfo.time
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.perfectDefenseCDLab.text = orginStringFormat(ZhString.MainViewGvgPage_PerfectDefense, min, sec)
  return true
end

function MainViewGvgPage:_updatePerfectDefenseCD()
  if not self.perfectTimeInfo then
    return
  end
  if self:TrySetPausePerfectTime() then
    return
  end
  local leftTime = self.perfectTimeInfo.time - ServerTime.CurServerTime() / 1000
  if leftTime <= 0 then
    self.bPerfect = true
    self:HandleDefensePerfectSuccess()
    return
  end
  self.bPerfect = false
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.perfectDefenseCDLab.text = orginStringFormat(ZhString.MainViewGvgPage_PerfectDefense, min, sec)
end

function MainViewGvgPage:PausePerfectDefenseTick()
  if not self.perfectDefenseTick then
    return
  end
  GvgProxy.Instance:Debug("[NewGVG] PausePerfectDefenseTick")
  self.perfectDefenseTick:StopTick()
end

function MainViewGvgPage:ResumePerfectDefenseTick()
  if not self.perfectDefenseTick then
    return
  end
  GvgProxy.Instance:Debug("[NewGVG] ResumePerfectDefenseTick")
  self.perfectDefenseTick:ContinueTick()
end

function MainViewGvgPage:RemovePerfectDefenseTick()
  if self.perfectDefenseTick then
    TimeTickManager.Me():ClearTick(self, 102)
    self.perfectDefenseTick = nil
  end
end

function MainViewGvgPage:initView()
  self.gvgInfoBord = self:FindGO("GvgInfoBord")
  self.progress = self:FindGO("progress")
  self.progressSlider = self.progress:GetComponent(UISlider)
  self.progressBg = self:FindComponent("bg", UISprite, self.progress)
  self.progressForebg = self:FindComponent("forebg", UISprite, self.progress)
  self.thumbBg = self:FindGO("bg", self.thumbCt):GetComponent(UISprite)
  self.name = self:FindComponent("Title", UILabel)
  self.countDownLabel = self:FindComponent("DescriptionText", UILabel)
  self.stateLab = self:FindComponent("StateLab", UILabel)
  self.scoreLabel = self:FindComponent("score", UILabel)
  self.l_sprProgressIcon = self:FindComponent("progressIcon", UISprite)
  IconManager:SetItemIcon("item_5500", self.l_sprProgressIcon)
  self.progressLabel = self:FindComponent("progressLabel", UILabel)
  self.perfectDefenseCDLab = self:FindComponent("perfectDefenseLab", UILabel)
  self.bg = self:FindComponent("contentBg", UISprite)
  self.content = self:FindGO("content")
  self.effectObj = self:FindGO("EffectHolder")
  local resPath = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBox)
  local effect = Game.AssetManager_UI:CreateAsset(resPath, self.effectObj)
  effect.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  local hlightTexture = self:FindGO("pic_skill_uv_add", effect)
  if hlightTexture then
    hlightTexture = hlightTexture:GetComponent(UIWidget)
    hlightTexture.depth = 3000
    hlightTexture.width = 57
    hlightTexture.height = 101
  end
  self:Hide(self.effectObj)
  self.bgSizeX = self.bg.width
  local objLua = self.gvgInfoBord:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
      self:resizeContent()
    end, self)
  end
  
  self.taskCellFoldSymbolSp = self:FindComponent("taskCellFoldSymbol", UISprite)
  self.taskBordFold = self:FindGO("taskBordFoldSymbol")
  if self.taskBordFold then
    self:AddClickEvent(self.taskBordFold, function()
      self:OnClickTaskBordFold()
    end)
  end
  self.GvgHonorTraceInfo = self:FindGO("GvgHonorTraceInfo")
  if self.isGuildDate and self.GvgHonorTraceInfo then
    self:Hide(self.GvgHonorTraceInfo)
  end
  self:InitTraceHonor()
end

function MainViewGvgPage:OnClickTaskBordFold()
  if self.isGuildDate then
    return
  end
  if self.effectObj then
    self:Hide(self.effectObj)
  end
  self:stopDelayRemoveEffect()
  TipManager.Instance:ShowGvgQuestScoreTip(self.taskCellFoldSymbolSp, NGUIUtil.AnchorSide.Left, {-450, 0})
end

function MainViewGvgPage:InitTraceHonor()
  if self.isGuildDate then
    return
  end
  self.honorValue = self:FindComponent("honorValue", UILabel)
  self.honorFixed = self:FindComponent("honorFixed", UILabel, self.honorValue.gameObject)
  self.honorFixed.text = ZhString.MainViewGvgPage_HonorValue
  local l_sprHonorIcon = self:FindComponent("honorIcon", UISprite, self.honorValue.gameObject)
  IconManager:SetItemIcon("item_156", l_sprHonorIcon)
  self.coinValue = self:FindComponent("coinValue", UILabel)
  self.coinFixed = self:FindComponent("coinFixed", UILabel, self.coinValue.gameObject)
  self.coinFixed.text = ZhString.MainViewGvgPage_CoinValue
  local l_sprCoinIcon = self:FindComponent("coinIcon", UISprite, self.coinValue.gameObject)
  IconManager:SetItemIcon("item_5897", l_sprCoinIcon)
  self.smallMetalRoot = self:FindGO("SmallMetalRoot")
  self.smallMetalProgress = self:FindComponent("SmallMetalProgress", UISlider, self.smallMetalRoot)
  self.smallMetalLab = self:FindComponent("Label", UILabel, self.smallMetalRoot)
end

function MainViewGvgPage:updateHonorValue()
  if self.isGuildDate then
    return
  end
  local cur = self.gvgIns:GetHonor()
  local max = GameConfig.GVGConfig.reward.max_honor or 3200
  local data = ActivityEventProxy.Instance:GetRewardByType(AERewardType.NewGVGPersonal)
  local reward_multiple = data and data:GetMultiple() or nil
  if reward_multiple and 0 < reward_multiple then
    max = max * reward_multiple
  end
  self.honorValue.text = string.format(valueFormat, cur, max)
  cur = self.gvgIns:GetCoin()
  max = GameConfig.GVGConfig.reward.max_coin or 320
  if reward_multiple and 0 < reward_multiple then
    max = max * reward_multiple
  end
  self.coinValue.text = string.format(valueFormat, cur, max)
  if TipsView.Me().currentTipType == GvgQuestScoreTip then
    TipManager.Instance:ShowGvgQuestScoreTip(self.taskCellFoldSymbolSp, NGUIUtil.AnchorSide.Left, {-450, 0})
  end
end

function MainViewGvgPage:updatehpper()
  local hp_per
  if self.gvgIns:IsMvpAlive() then
    hp_per = self.gvgIns:GetMvpHpPer()
  else
    hp_per = self.gvgIns.metal_hpper
  end
  hp_per = hp_per or 0
  self.progressSlider.value = hp_per / 100
  self.progressLabel.text = math.floor(hp_per) .. "%"
  if 70 <= hp_per then
    self.progressForebg.spriteName = "com_bg_hp"
  elseif 25 <= hp_per then
    self.progressForebg.spriteName = "com_bg_hp_3s"
  else
    self.progressForebg.spriteName = "com_bg_hp_2s"
  end
end

function MainViewGvgPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, self.updatehpper)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgMvpInfoUpdateCmd, self.updatehpper)
  self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, self.UpdateNewDef)
  self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, self.SetData)
  self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireRestartFubenCmd, self.SetData)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgDataSyncCmd, self.updateHonorValue)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgDataUpdateCmd, self.updateHonorValue)
  self:AddListenEvt(GVGEvent.ShowNewAchievemnetEffect, self.HandleAchieveEffect)
  self:AddListenEvt(GVGEvent.GVG_SmallMetalCntUpdate, self.UpdateSmallMetalCtn)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgPerfectStateUpdateFubenCmd, self.UpdatePerfectDefense)
  self:AddListenEvt(GVGEvent.GVG_PerfectDefenseSuccess, self.HandleDefensePerfectSuccess)
  self:AddListenEvt(GVGEvent.GVG_PerfectDefensePause, self.TrySetPausePerfectTime)
  self:AddListenEvt(GVGEvent.GVG_PerfectDefenseResume, self.ResumePerfectDefenseTick)
end

function MainViewGvgPage:HandleDefensePerfectSuccess()
  self:RemovePerfectDefenseTick()
  self.perfectDefenseCDLab.text = ZhString.MainViewGvgPage_PerfectDefense_Success
  self:SetState()
end

function MainViewGvgPage:resizeContent()
  if not self.isInit then
    return
  end
  if not self.container.gameObject.activeInHierarchy then
    return
  end
  local bd = calSize(self.content.transform, false)
  local height = bd.size.y
  self.bg.height = height + 10
  if self.isGuildDate then
    return
  end
  local x, y, z = getLocalPos(self.GvgHonorTraceInfo.transform)
  local x1, y1, z1 = getLocalPos(self.bg.transform)
  self.GvgHonorTraceInfo.transform.localPosition = LuaGeometry.GetTempVector3(x, y1 - height - 20, z)
end

function MainViewGvgPage:SetState()
  local str
  if self.gvgIns:IsMvpAlive() then
    str = (self.gvgIns:CheckPerfectDefense() or self.bPerfect or self.gvgIns:IsPerfectDefense()) and ZhString.MainViewGvgPage_FinishState_Attack_MVP_PerfectDefend or ZhString.MainViewGvgPage_FinishState_Attack_MVP
    IconManager:SetMapIcon("GVG_icon_map_mvp", self.l_sprProgressIcon)
  else
    IconManager:SetItemIcon("item_5500", self.l_sprProgressIcon)
    if self.gvgIns:IsFireState() then
      if self.isDefSide then
        str = ZhString.MainViewGvgPage_NormalState_Def
      else
        str = ZhString.MainViewGvgPage_NormalState_Attack
      end
    elseif self.gvgIns:IsPerfectDefense() and self.isDefSide then
      str = ZhString.MainViewGvgPage_FinishState_DefSusCountLabel
    end
  end
  self.stateLab.text = str or ""
end

function MainViewGvgPage:updateCountTime(totalTime, type)
  if not self.isInit then
    return
  end
  local result = self.gvgIns.result
  local endfire_time = self.gvgIns.endfire_time
  result = result and result or FuBenCmd_pb.EGUILDFIRERESULT_DEFSPEC
  endfire_time = endfire_time and endfire_time or self.curServerT + 3000
  self:SetState()
  local titleLeftTime = endfire_time - ServerTime.CurServerTime() / 1000
  if titleLeftTime < 0 then
    titleLeftTime = 0
    self.tickMg:ClearTick(self, 101)
  end
  titleLeftTime = math.floor(titleLeftTime)
  local m = math.floor(titleLeftTime / 60)
  local s = titleLeftTime - m * 60
  self.name.text = orginStringFormat(ZhString.MainViewGvgPage_TitleDes, m, s)
  if self.gvgIns:IsNeutral() then
    self.countDownLabel.text = ZhString.MainViewGvgPage_GvgPageNoDefine
  else
    self.countDownLabel.text = string.format(ZhString.MainViewGvgPage_GvgPageTitleDes, self.gvgIns:GetDefGuildName())
  end
  self:updatehpper()
  self:resizeContent()
end

function MainViewGvgPage:UpdateNewDef()
  self.isDefSide = self.gvgIns:IsDefSide()
  self:updatehpper()
end

function MainViewGvgPage:stopDelayRemoveEffect()
  if self.BlockRemoveEffectTwId then
    self.BlockRemoveEffectTwId:Destroy()
    self.BlockRemoveEffectTwId = nil
  end
end

function MainViewGvgPage:delayRemoveEffect()
  self:stopDelayRemoveEffect()
  self.BlockRemoveEffectTwId = TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    if not self.isInit then
      return
    end
    self.BlockRemoveEffectTwId = nil
    if self.effectObj then
      self:Hide(self.effectObj)
    end
  end, self)
end

function MainViewGvgPage:HandleAchieveEffect()
  if self.effectObj and TipsView.Me().currentTipType ~= GvgQuestScoreTip then
    self:Show(self.effectObj)
    self:delayRemoveEffect()
  end
end

local _suffix = "%"
local _maxSmallMetal

function MainViewGvgPage:UpdateSmallMetalCtn()
  if not self.isInit then
    return
  end
  if not self.smallMetalRoot then
    return
  end
  if not _maxSmallMetal then
    _maxSmallMetal = GameConfig.GVGConfig.occupy_smallmetal_maxcount
    if not _maxSmallMetal then
      redlog("未配置公会最多抢夺小水晶的数量  GameConfig.GVGConfig.occupy_smallmetal_maxcount ")
    end
    _maxSmallMetal = 5
  end
  local myguildSmallMetalCnt = GvgProxy.Instance:GetMyGuildSmallMetalCnt()
  self.smallMetalProgress.value = myguildSmallMetalCnt / _maxSmallMetal
  self.smallMetalLab.text = tostring(myguildSmallMetalCnt) .. "/" .. tostring(_maxSmallMetal)
end
