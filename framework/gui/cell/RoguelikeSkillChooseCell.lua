RoguelikeSkillChooseCell = class("RoguelikeSkillChooseCell", BaseCell)
local PurpleLv = 5
local OrangeLv = 10
local BgName = "Novicecopy_affix_iconbg"
local SpecialBgName = {
  [PurpleLv] = "Novicecopy_affix_iconbg02",
  [OrangeLv] = "Novicecopy_affix_iconbg03"
}
local BuildNormalColor = Color(0.17647058823529413, 0.5372549019607843, 0.8431372549019608, 1)
local BuildLvColor = {
  [PurpleLv] = Color(0.6, 0.43137254901960786, 0.9294117647058824, 1),
  [OrangeLv] = Color(0.9294117647058824, 0.5098039215686274, 0.4235294117647059, 1)
}

function RoguelikeSkillChooseCell:Init()
  self:FindObjs()
end

function RoguelikeSkillChooseCell:FindObjs()
  self.bgTex = self.gameObject:GetComponent(UITexture)
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.nameBg = self:FindComponent("NameBg", UIMultiSprite)
  self.skillIcon = self:FindComponent("Icon", UISprite)
  self:AddClickEvent(self.skillIcon.gameObject, function()
    self:OnSkillIconClick()
  end)
  self.skillName = self:FindComponent("Name", UILabel)
  self.skillDesc = self:FindComponent("Desc", UILabel)
  self.notLearnedTip = self:FindGO("NotLearnedTip")
  self.curLvLabel = self:FindComponent("CurLv", UILabel)
  self.nextLvLabel = self:FindComponent("NextLv", UILabel)
  self.lvArrow = self:FindComponent("LvArrow", UIMultiSprite)
  self.buildLabel = self:FindComponent("Build", UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.learnBtn = self:FindGO("LearnBtn")
  self:AddClickEvent(self.learnBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.selectGO = self:FindGO("Select")
  self.newGO = self:FindGO("New")
  self.recommendGO = self:FindGO("Recommend")
  self.effectContainer = self:FindGO("EffectContainer")
  self.parentTrans = self.trans.parent
end

function RoguelikeSkillChooseCell:SetData(data)
  self.data = data
  if data then
    local level = data:GetLevel()
    self:SetSpecialSkill(level)
    self.skillName.text = data:GetName()
    self.skillDesc.text = data:GetCurAttr()
    self.buildLabel.text = data:GetBuild()
    IconManager:SetSkillIcon(data:GetIcon(), self.skillIcon)
    self.recommendGO:SetActive(data:IsRecommend() or false)
    self.newGO:SetActive(data:IsNew() or false)
    self.upgradeBtn:SetActive(1 < level)
    self.learnBtn:SetActive(level <= 1)
    self.notLearnedTip:SetActive(level <= 1)
    self.curLvLabel.gameObject:SetActive(1 < level)
    self.nextLvLabel.gameObject:SetActive(1 < level)
    self.curLvLabel.text = string.format(ZhString.RoguelikeSkill_Level, level - 1)
    self.nextLvLabel.text = string.format(ZhString.RoguelikeSkill_Level, level)
    self:PlayUIEffect(EffectMap.UI.RoguelikeSkill_Reset, self.effectContainer, true)
  end
  self.isHighlight = false
end

function RoguelikeSkillChooseCell:SetSpecialSkill(level)
  self.bgName = BgName
  if SpecialBgName[level] then
    self.bgName = SpecialBgName[level]
  end
  PictureManager.Instance:SetUI(self.bgName, self.bgTex)
  self.bg.CurrentState = level == OrangeLv and 2 or level == PurpleLv and 1 or 0
  self.nameBg.CurrentState = level == OrangeLv and 2 or level == PurpleLv and 1 or 0
  self.lvArrow.CurrentState = level == OrangeLv and 2 or level == PurpleLv and 1 or 0
  local color = BuildNormalColor
  if BuildLvColor[level] then
    color = BuildLvColor[level]
  end
  self.buildLabel.color = color
end

function RoguelikeSkillChooseCell:OnCellDestroy()
  PictureManager.Instance:UnLoadUI(self.bgName, self.bgTex)
end

function RoguelikeSkillChooseCell:OnSkillIconClick()
  if self.data then
    TipsView.Me():ShowTip(RoguelikeSkillTip, self.data)
  end
end

function RoguelikeSkillChooseCell:SetSelect(isSelect)
  self.selectGO:SetActive(isSelect or false)
end

function RoguelikeSkillChooseCell:SetHighlight(parent)
  self.trans:SetParent(parent, true)
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
  self.isHighlight = true
end

function RoguelikeSkillChooseCell:ResetHighlight()
  if not self.isHighlight then
    return
  end
  self.trans:SetParent(self.parentTrans, true)
  self.trans:SetSiblingIndex(self.indexInList - 1)
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
  self.isHighlight = false
end

function RoguelikeSkillChooseCell:OnUpgradeBtnClick()
  self:PassEvent(MouseEvent.MouseClick, self)
end
