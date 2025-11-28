local BgTexture = {
  [Camp_Human] = "battlefield_bg_bottem_10",
  [Camp_Vampire] = "battlefield_bg_bottem_09",
  [Camp_Neutral] = "battlefield_bg_bottem_11"
}
local CampResult = {
  [Camp_Human] = ZhString.EndlessBattleEvent_HumanWin_Short,
  [Camp_Vampire] = ZhString.EndlessBattleEvent_VampireWin_Short
}
EndlessBattleResultView = class("EndlessBattleResultView", ContainerView)
EndlessBattleResultView.ViewType = UIViewType.PopUpLayer
autoImport("LuaQueue")

function EndlessBattleResultView:Init()
  self.neutralRoot = self:FindGO("NeutralRoot")
  self.victorRoot = self:FindGO("VictorRoot")
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.neutralLab = self:FindComponent("Neutral", UILabel, self.neutralRoot)
  self.eventName = self:FindComponent("EventName", UILabel, self.victorRoot)
  self.resultDesc = self:FindComponent("ResultDesc", UILabel, self.victorRoot)
  self.victorLab = self:FindComponent("Victor", UILabel, self.victorRoot)
  self.headIcon = self:FindComponent("HeadIcon", UISprite, self.victorRoot)
  self.effectContainer = self:FindGO("EffectContainer")
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.waittingEvent = LuaQueue.new()
  self:AddViewEvts()
  self:ResetView(self.viewdata.viewdata and self.viewdata.viewdata.data)
end

function EndlessBattleResultView:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(PVPEvent.EndlessBattleField_MultiEvent_End, self.OnMultiEventEnd)
end

function EndlessBattleResultView:OnMultiEventEnd(note)
  local event_data = note.body
  if not event_data then
    return
  end
  self.waittingEvent:Push(event_data)
end

function EndlessBattleResultView:UpdateView()
  local data = self.data
  if not data then
    return
  end
  local victor = data.winner
  local new_texture_name = BgTexture[victor]
  if new_texture_name and new_texture_name ~= self.victorTextureName then
    self:UnloadTexture()
    self.victorTextureName = new_texture_name
    self:LoadTexture()
  end
  local name = data.staticData.Name
  if victor == Camp_Neutral then
    self:Show(self.neutralRoot)
    self:Hide(self.victorRoot)
    self.neutralLab.text = string.format(ZhString.EndlessBattleResult_Neutral, name)
  else
    self:Hide(self.neutralRoot)
    self:Show(self.victorRoot)
    self.eventName.text = name
    self.victorLab.text = CampResult[victor]
    local statueName = EndlessBattleGameProxy.Instance:GetStatueName(victor)
    self.resultDesc.text = string.format(ZhString.EndlessBattleResult_Desc, statueName)
    local monster_icon = EndlessBattleGameProxy.Instance:GetStatueHeadIcon()
    IconManager:SetFaceIcon(monster_icon, self.headIcon)
    self.headIcon:MakePixelPerfect()
    self:PlayUIEffect(EffectMap.UI.EndlessBattle_Win, self.effectContainer)
  end
  LeanTweenUtil.UIAlpha(self.panel, 1, 0, 2, 1)
  self:ClearTick()
  self.tick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self:PreExit()
  end, self)
end

function EndlessBattleResultView:ResetView(data)
  self:ClearTick()
  self.panel.alpha = 1
  self.data = data
  self:UpdateView()
end

function EndlessBattleResultView:PreExit()
  local data = self.waittingEvent:Pop()
  if data then
    self:ResetView(data)
  else
    self:CloseSelf()
  end
end

function EndlessBattleResultView:OnExit()
  self:UnloadTexture()
  self:ClearTick()
end

function EndlessBattleResultView:LoadTexture()
  if self.victorTextureName then
    PictureManager.Instance:SetBattleFieldTexture(self.victorTextureName, self.bgTexture)
  end
end

function EndlessBattleResultView:UnloadTexture()
  if self.victorTextureName then
    PictureManager.Instance:UnloadBattleFieldTexture(self.victorTextureName, self.bgTexture)
    self.victorTextureName = nil
  end
end

function EndlessBattleResultView:ClearTick()
  if self.tick then
    self.tick:Destroy()
    self.tick = nil
  end
end
