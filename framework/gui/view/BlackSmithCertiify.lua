autoImport("LetterContainerView")
autoImport("HomeLetterPanel")
BlackSmithCertiify = class("HomeLetterPanel", HomeLetterPanel)
BlackSmithCertiify.ViewType = UIViewType.PopUpLayer
BlackSmithCertiify.PartName = "HomeLetter"
local letterContainerEffName = "Eff_ownership_open"
local homeIconName = "icon_tiejiangpu"

function BlackSmithCertiify:InitLetterPart()
  BlackSmithCertiify.super.InitLetterPart(self)
  self.HomeTypeLeft_UILabel.text = ZhString.BlackSmithCertiify_EstateType
  self.HomeTypeRight_UILabel.text = ZhString.BlackSmithCertiify_BusinessType
  self.homeIcon = self:FindGO("homeicon"):GetComponent(UISprite)
  IconManager:SetUIIcon(homeIconName, self.homeIcon)
  self.homeName = self:FindGO("HomeName"):GetComponent(UILabel)
  self.signature = self:FindGO("Signature"):GetComponent(UILabel)
  self.homeName.text = ZhString.BlackSmithCertiify_Belong
  self.signature.text = ZhString.BlackSmithCertiify_Guarantor
  self.staticName1 = self:FindGO("StaticName1"):GetComponent(UILabel)
  self.staticName2 = self:FindGO("StaticName2"):GetComponent(UILabel)
  self.staticName1.text = Table_Npc[1014].NameZh
  self.staticName2.text = Game.Myself.data:GetName()
  local housebelongLeft_UILabel = self:FindComponent("housebelong", UILabel, self.letterLabel)
  local housebelongRight_UILabel = self:FindComponent("housebelongRight", UILabel, self.letterLabel)
  housebelongLeft_UILabel.gameObject:SetActive(false)
  housebelongRight_UILabel.gameObject:SetActive(false)
  self.Name_UIInput.gameObject:SetActive(false)
  self.Sign_UIInput.gameObject:SetActive(false)
  self.staticName1.gameObject:SetActive(true)
  self.staticName2.gameObject:SetActive(true)
  local homeConfig = GameConfig.Home
  self.TopTitle_UILabel.text = homeConfig and homeConfig.HomeLetterTopTitleText
  self.Desc_UILabel.text = homeConfig and homeConfig.HomeLetterDesc
  self.homeIcon = self:FindGO("homeicon"):GetComponent(UISprite)
  self.letterStampTexture = self.letterStamp:GetComponent(UITexture)
  PictureManager.Instance:SetUI("icon_midejiaerte", self.letterStampTexture)
  self.letterStamp:SetActive(true)
end

function BlackSmithCertiify:OnClickConfirmBtn()
  self:CloseSelf()
end

function BlackSmithCertiify:OnEnter()
  BlackSmithCertiify.super.super.super.OnEnter(self)
  self:PlayUIEffect(letterContainerEffName, self.effectanchor, false, function(go, args, assetEffect)
    self.letterEffect = assetEffect
    local effectObjectAnchor = self:FindGO("anchor", self:FindGO("home_letter2", assetEffect.effectObj))
    local trans = self.letter.transform
    trans:SetParent(effectObjectAnchor.transform, false)
    trans.localScale = LuaGeometry.Const_V3_one
    trans.localPosition = LuaGeometry.Const_V3_zero
    trans.localRotation = LuaGeometry.Const_Qua_identity
    if not self.HideConfirmBtn then
      trans = self.confirmbtn.transform
      trans:SetParent(self:FindGO("btn", assetEffect.effectObj).transform, true)
      self.confirmbtn:SetActive(true)
    end
    local tips = self:FindComponent("Label", UILabel, assetEffect.effectObj)
    tips.text = ""
    self.letterEffect:SetPlaybackSpeed(0)
    self.letter:SetActive(true)
  end)
end

function BlackSmithCertiify:OnExit()
  BlackSmithCertiify.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("icon_midejiaerte", self.letterStampTexture)
end
