local BaseCell = autoImport("BaseCell")
PetComposeChooseCell = class("PetComposeChooseCell", BaseCell)
local CONTRACT_COLOR_MAX = Color(0.3411764705882353, 0.7607843137254902, 0.22745098039215686, 1)
local CONTRACT_COLOR_LOW = Color(0.6901960784313725, 0.29411764705882354, 0.29411764705882354, 1)

function PetComposeChooseCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function PetComposeChooseCell:FindObjs()
  self.content = self:FindGO("Content")
  self.bg = self:FindGO("bg"):GetComponent(UISprite)
  self.headTipStick = self:FindGO("headTipStick"):GetComponent(UIWidget)
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.level = self:FindGO("petLv"):GetComponent(UILabel)
  self.name = self:FindGO("petName"):GetComponent(UILabel)
  self.limitLab = self:FindGO("limitLab"):GetComponent(UILabel)
  self.contractRoot = self:FindGO("ContractRoot")
  self.contractIcon = self:FindComponent("ContractIcon", UISprite, self.contractRoot)
  self.contractLv = self:FindComponent("ContractLv", UILabel, self.contractRoot)
end

function PetComposeChooseCell:AddEvts()
  self:AddButtonEvent("icon", function(obj)
    self:PassEvent(PetEvent.ClickPetAdventureIcon, self)
  end)
  self:AddCellClickEvent()
end

function PetComposeChooseCell:SetContract(data)
  local pcfg = Table_Pet[data.petid]
  if pcfg and pcfg.ContractSkill then
    self:Show(self.contractRoot)
    local maxLv = pcfg.ContractSkill[2] or 0
    local curLv = data:GetContractSkillLevel() or 0
    if 0 < maxLv and maxLv <= curLv then
      self.contractLv.text = ZhString.PetCompose_ContractLvMax
      self.contractLv.color = CONTRACT_COLOR_MAX
    else
      self.contractLv.text = string.format(ZhString.PetCompose_ContractLvProgress, curLv, maxLv)
      self.contractLv.color = CONTRACT_COLOR_LOW
    end
  else
    self:Hide(self.contractRoot)
  end
end

function PetComposeChooseCell:SetData(data)
  self.data = data
  if data then
    self.content:SetActive(true)
    self.name.text = data.name
    local face = data:GetHeadIcon()
    IconManager:SetFaceIcon(face, self.icon)
    self.level.text = string.format(ZhString.PetAdventure_Lv, data.lv)
    self.limitLab.text = string.format(ZhString.PetAdventure_Lv, data.friendlv)
    self:SetContract(data)
    if data.unlocked then
      self:Show(self.limitLab)
      ColorUtil.WhiteUIWidget(self.bg)
    else
      ColorUtil.ShaderLightGrayUIWidget(self.bg)
      self:Show(self.limitLab)
    end
  else
    self.content:SetActive(false)
  end
end
