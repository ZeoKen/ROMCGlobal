local BaseCell = autoImport("BaseCell")
MatchingCardCell = class("MatchingCardCell", CardNCell)
autoImport("TipLabelCell")
local CardState = {
  None = 1,
  ShowCard = 2,
  Done = 3
}

function MatchingCardCell:Init()
  self.iconContainer = self:FindGO("IconContainer")
  self.infoContainer = self:FindGO("Info")
  self.icon = self:FindComponent("Icon", UISprite, self.iconContainer)
  self.iconPic = self:FindComponent("IconTex", UITexture)
  self.cardName = self:FindComponent("CardName", UILabel)
  self.displayContainer = self:FindGO("displayContainer")
  self.Back = self:FindGO("Back")
  self.contentLabel = self:FindGO("contentLabel"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.cardAnimator = self.gameObject:GetComponent(Animator)
  self.alphaTW = self.gameObject:GetComponent(TweenAlpha)
  self.alphaTW:ResetToBeginning()
  self:AddCellClickEvent()
  self.cheatTip = self:FindGO("cheatTip"):GetComponent(UILabel)
  self.cheatTip.text = ""
end

function MatchingCardCell:SetData(data)
  self.data = data
  if data and data.cardInfo then
    self.gameObject:SetActive(true)
    self.cardInfo = data.cardInfo
    if not PictureManager.Instance:SetCard(self.cardInfo.Picture, self.iconPic) then
      printRed(string.format("cant find card pic", self.cardInfo.Picture))
      PictureManager.Instance:SetCard("card_10001", self.iconPic)
    end
    self.cardName.text = self.cardInfo.Name
    local contextlabel = ""
    local bufferIds = self.cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        local bufferStrs = string.split(str, "\n")
        contextlabel = contextlabel .. str
      end
    end
    self.contentLabel.text = contextlabel
    UIUtil.WrapLabel(self.contentLabel)
    self.cardName.gameObject:SetActive(data.display ~= MiniGameCardDisplay.HideName)
    self.infoContainer:SetActive(data.display >= MiniGameCardDisplay.HideBack)
    self.iconContainer:SetActive(data.display < MiniGameCardDisplay.HideBack)
    self.Back:SetActive(true)
    self.displayContainer:SetActive(false)
    self.isMatched = false
    self.cardState = false
  else
    redlog("data cardInfo nil")
  end
end

function MatchingCardCell:SetChooseState()
  self.cardState = not self.cardState
  self.Back:SetActive(not self.cardState)
  self.displayContainer:SetActive(self.cardState)
  if self.cardState then
    self:PlayAnimation("Choice")
  end
end

function MatchingCardCell:SetMatched(b)
  self.isMatched = b
  if b then
    self:PlayUIEffect(EffectMap.UI.Eff_PairingSuccess_LittleGame, self.effectContainer, true)
    self.faceLT = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self:PlayAnimation("Face")
    end, self)
  end
end

function MatchingCardCell:IsMatched()
  return self.isMatched
end

function MatchingCardCell:GetCardId()
  if self.cardInfo then
    return self.cardInfo.id
  end
  return nil
end

function MatchingCardCell:GetIndex()
  if self.data then
    return self.data.index
  end
  return nil
end

function MatchingCardCell:GetChooseState()
  return self.cardState
end

function MatchingCardCell:PlayFlipEffect()
  self:PlayAnimation("Return_fail")
  self.backLT = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:PlayAnimation("Back")
  end, self)
  self:PlayUIEffect(EffectMap.UI.Eff_PairingFailure_LittleGame, self.effectContainer, true)
end

function MatchingCardCell:PlayAnimation(aniName)
  if self.cardAnimator then
    self.cardAnimator:Play(aniName, -1, 0)
  end
end

function MatchingCardCell:PlayShow()
  self.alphaTW:PlayReverse()
end

function MatchingCardCell:PlayHide()
  self.alphaTW:PlayForward()
end

function MatchingCardCell:OnDestroy()
  if self.backLT then
    self.backLT:Destroy()
    self.backLT = nil
  end
  if self.faceLT then
    self.faceLT:Destroy()
    self.faceLT = nil
  end
end
