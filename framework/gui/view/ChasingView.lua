ChasingView = class("ChasingView", ContainerView)
ChasingView.ViewType = UIViewType.ChasingViewLayer
local effectiveStartScale = 0.94
local effectiveEndScale = 0.7
local startScale = 1.5
local endScale = 0.1
local duration = 5000
local AlmostEqual_3 = VectorUtility.AlmostEqual_3
local SuccessEffect = EffectMap.UI.Eff_chase_success_QTE
local FailEffect = EffectMap.UI.Eff_chase_fail_QTE
local TipEffect = EffectMap.UI.Eff_chase_tips_QTE
local normalTip = "Game_btn_01"
local effectiveTip = "Game_btn_02"
local QTEConfig = GameConfig.ChasingScene.QTE
local SceneConfig = GameConfig.ChasingScene
local MaxBossHP = 10
local MaxPlayerHP = 10
local SuccessAudio = SceneConfig.failsoundEffect
local FailAudio = SceneConfig.successsoundEffect

function ChasingView:Init()
  self:FindObj()
  self:AddEvt()
  self:InitConfig()
  self.inited = true
end

function ChasingView:FindObj()
  self.qteAnchor = self:FindGO("QTEAnchor")
  self.qteAnchorWG = self.qteAnchor:GetComponent(UIWidget)
  self.outerRimGO = self:FindGO("outerRim", self.qteAnchor)
  self:PlayUIEffect(EffectMap.UI.Eff_chase_Rad_QTE, self.outerRimGO)
  self.outerRimTS = self.outerRimGO:GetComponent(TweenScale)
  self.outerRimSP = self.outerRimGO:GetComponent(UIWidget)
  self.innerRim = self:FindGO("innerRim", self.qteAnchor)
  self.outerRimTS.enabled = false
  self.outerRimTS:SetOnFinished(function()
    self.qteState = false
    self:Submit(false)
  end)
  self:AddClickEvent(self.innerRim, function()
    self:CheckQTE()
  end)
  self.qteState = false
  self:AddButtonEvent("CloseButton", function(go)
    MsgManager.ConfirmMsgByID(7, function()
      ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    end, nil, nil)
  end)
  self.bossHpSlider = self:FindGO("BossHpSlider"):GetComponent(UISlider)
  self.playerHpSlider = self:FindGO("PlayerHpSlider"):GetComponent(UISlider)
  self.qteAnchor:SetActive(false)
  self.effectContainer = self:FindGO("effectContainer")
  self.effectWG = self.effectContainer:GetComponent(UIWidget)
  self.tipEffectContainer = self:FindGO("tipEffectContainer")
  self.bossBg = self:FindGO("BossBg"):GetComponent(UISprite)
  self.heroBg = self:FindGO("HeroBg"):GetComponent(UISprite)
  self.tipSprite = self:FindGO("tipSprite"):GetComponent(UISprite)
end

function ChasingView:OnShow()
  self:UpdateAnchors()
  local bossGrid = self:FindComponent("BossHPGrid", UIGrid)
  bossGrid.cellWidth = (self.bossBg.width - 8) / 10
  bossGrid:Reposition()
  local playerGrid = self:FindComponent("PlayerHPGrid", UIGrid)
  playerGrid.cellWidth = (self.heroBg.width - 8) / 10
  playerGrid:Reposition()
end

function ChasingView:UpdateAnchors()
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    self.heroBg:ResetAndUpdateAnchors()
    self.bossBg:ResetAndUpdateAnchors()
    return
  end
  local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  local hasMobileScreenAdaption = SafeArea.on and l ~= nil and (l ~= 0 or r ~= 0)
  if hasMobileScreenAdaption then
    self.heroBg.leftAnchor.absolute = r
    self.bossBg.rightAnchor.absolute = -l
    local anchorDownOffset = (r - l) / 2
    self.heroBg.rightAnchor.absolute = 3 + anchorDownOffset
    self.bossBg.leftAnchor.absolute = -3 + anchorDownOffset
  end
  self.heroBg.anchorsCached = false
  self.bossBg.anchorsCached = false
  self.heroBg:Update()
  self.bossBg:Update()
  if hasMobileScreenAdaption then
    UIUtil.ResetAndUpdateAllAnchors(self.heroBg.gameObject)
    UIUtil.ResetAndUpdateAllAnchors(self.bossBg.gameObject)
  end
end

function ChasingView:AddEvt()
  EventManager.Me():AddEventListener(ChasingScene.StartQTE, self.HandleStartQTE, self)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.HandleBuff)
  Game.GUISystemManager:AddMonoUpdateFunction(self.MonoUpdate, self)
end

function ChasingView:MonoUpdate(time, deltaTime)
  if not (self.qteState and not self.hit and self.outerRimSP) or not self.inited then
    return
  end
  local localScale = self.outerRimSP.transform.localScale
  if effectiveStartScale >= localScale.x and effectiveEndScale <= localScale.x then
    self.tipSprite.spriteName = effectiveTip
    self.hit = true
  end
end

function ChasingView:InitConfig()
  local data = Table_Buffer[SceneConfig.PlayerHPBuff]
  MaxPlayerHP = data and data.BuffEffect.limit_layer or 1
  local data = Table_Buffer[SceneConfig.BossHPBuff]
  MaxBossHP = data and data.BuffEffect.limit_layer or 1
end

function ChasingView:OnEnter()
  self:OnShow()
end

local layer = 0
local myLayer, bossLayer

function ChasingView:HandleBuff()
  layer = Game.Myself:GetBuffLayer(SceneConfig.PlayerHPBuff)
  if layer ~= myLayer then
    myLayer = layer
    self.playerHpSlider.value = layer / MaxPlayerHP
  end
  layer = Game.Myself:GetBuffLayer(SceneConfig.BossHPBuff)
  if layer ~= bossLayer then
    bossLayer = layer
    self.bossHpSlider.value = layer / MaxBossHP
  end
end

function ChasingView:OnExit()
  EventManager.Me():RemoveEventListener(ChasingScene.StartQTE, self.HandleStartQTE, self)
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
end

function ChasingView:HandleStartQTE(qteconfig)
  if qteconfig then
    self.currentQuestdata = qteconfig.questData
    self.currentQTE = qteconfig.configid or 0
    self.currentQTEConfig = QTEConfig[self.currentQTE]
    if not self.currentQTEConfig then
      return
    end
    self:SpawnQTEEvent()
  end
end

function ChasingView:SpawnQTEEvent()
  self.hit = false
  self.qteAnchor:SetActive(true)
  self.tipSprite.spriteName = normalTip
  self.outerRimTS:ResetToBeginning()
  self.qteState = true
  startScale = self.currentQTEConfig.startScale
  self.outerRimTS.from = Vector3.one * startScale
  endScale = self.currentQTEConfig.endScale
  effectiveStartScale = self.currentQTEConfig.hitStartScale
  effectiveEndScale = self.currentQTEConfig.hitEndScale
  self.outerRimTS.to = Vector3.one * endScale
  self.outerRimTS.duration = self.currentQTEConfig.duration / 1000
  self.qteAnchorWG.leftAnchor.absolute = self.currentQTEConfig.pos[1] or 0
  self.qteAnchorWG.rightAnchor.absolute = self.currentQTEConfig.pos[2] or 0
  self.qteAnchorWG.bottomAnchor.absolute = self.currentQTEConfig.pos[3] or 0
  self.qteAnchorWG.topAnchor.absolute = self.currentQTEConfig.pos[4] or 0
  self.qteAnchorWG:ResetAndUpdateAnchors()
  self.effectWG.leftAnchor.absolute = self.currentQTEConfig.pos[1] or 0
  self.effectWG.rightAnchor.absolute = self.currentQTEConfig.pos[2] or 0
  self.effectWG.bottomAnchor.absolute = self.currentQTEConfig.pos[3] or 0
  self.effectWG.topAnchor.absolute = self.currentQTEConfig.pos[4] or 0
  self.effectWG:ResetAndUpdateAnchors()
  self.outerRimTS.enabled = true
  self.outerRimTS:PlayForward()
  if not self.loaded then
    self:PlayUIEffect(TipEffect, self.tipEffectContainer)
  else
    self.tipEffectContainer:SetActive(true)
  end
end

function ChasingView:CheckQTE()
  if not self.qteState then
    return
  end
  local localScale = self.outerRimSP.transform.localScale
  if effectiveStartScale >= localScale.x and effectiveEndScale <= localScale.x then
    self:Submit(true)
    return
  end
  self:Submit(false)
  return
end

function ChasingView:Submit(b)
  if self.currentQuestdata and self.currentQuestdata.staticData then
    if b then
      QuestProxy.Instance:notifyQuestState(self.currentQuestdata.scope, self.currentQuestdata.id, self.currentQuestdata.staticData.FinishJump)
      self:PlayUIEffect(SuccessEffect, self.effectContainer, true)
      if SuccessAudio then
        self:PlayUISound(SuccessAudio)
      end
    else
      QuestProxy.Instance:notifyQuestState(self.currentQuestdata.scope, self.currentQuestdata.id, self.currentQuestdata.staticData.FailJump)
      self:PlayUIEffect(FailEffect, self.effectContainer, true)
      if FailAudio then
        self:PlayUISound(FailAudio)
      end
    end
  end
  self.qteAnchor:SetActive(false)
end
