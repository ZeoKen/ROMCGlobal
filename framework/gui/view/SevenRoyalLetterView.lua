autoImport("LetterContainerView")
SevenRoyalLetterView = class("SevenRoyalLetterView", LetterContainerView)
SevenRoyalLetterView.ViewType = UIViewType.PopUpLayer
SevenRoyalLetterView.PartName = "SevenRoyalLetter"
SevenRoyalLetterView.HideConfirmBtn = true
local texObjStaticNameMap = {
  BG1 = "qws_Invitation-card_bg_01",
  BG2 = "qws_Invitation-card_bg_01"
}

function SevenRoyalLetterView:InitLetterPart()
  SevenRoyalLetterView.super.InitLetterPart(self)
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.letterStamp = self:FindGO("Stamp", self.letter)
  if not self.cfg then
    LogUtility.Warning("Cannot find config of letter")
    return
  end
  local content = self:FindGO("Content")
  local icon = self:FindComponent("Icon", UISprite, content)
  IconManager:SetUIIcon(self.cfg.Icon, icon)
  local honorific = self:FindComponent("Honorific", UILabel, content)
  honorific.text = self.cfg.Honorific or ""
  local name = self:FindComponent("Name", UILabel, content)
  name.text = Game.Myself.data:GetName()
  local main = self:FindComponent("Main", UILabel, content)
  main.text = self:AdaptText(self.cfg.main_text)
  local signoff = self:FindComponent("SignOff", UILabel, content)
  signoff.text = self:AdaptText(self.cfg.sign_off)
end

function SevenRoyalLetterView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local params = viewdata and viewdata.params
  self.LetterConfigIndex = params and params.letterid or 1
  SevenRoyalLetterView.super.InitData(self)
end

function SevenRoyalLetterView:OnEnter()
  SevenRoyalLetterView.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    PictureManager.Instance:SetUI(texName, self[objName])
  end
end

function SevenRoyalLetterView:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    PictureManager.Instance:UnLoadUI(texName, self[objName])
  end
  SevenRoyalLetterView.super.OnExit(self)
end

function SevenRoyalLetterView:OnClickBlackBg()
  if self.letterBgCollider.enabled then
    return
  end
  self:CloseSelf()
end

function SevenRoyalLetterView:OnClickLetterBg()
  if not self.letterEffectPlayed then
    if self.letterEffect then
      self.letterEffect:SetPlaybackSpeed(1)
      TimeTickManager.Me():CreateOnceDelayTick(self.DrawOutDuration, function(self)
        self.letterBgCollider.enabled = false
      end, self)
    end
    self.letterEffectPlayed = true
  end
end

function SevenRoyalLetterView:AdaptText(text)
  if not text then
    return ""
  end
  if BranchMgr.IsChina() then
    text = string.gsub(text, "    ", "[00000000]缩进[-]")
  end
  return text
end
