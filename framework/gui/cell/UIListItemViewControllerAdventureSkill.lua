UIListItemViewControllerAdventureSkill = class("UIListItemViewControllerAdventureSkill", BaseCell)

function UIListItemViewControllerAdventureSkill:Init()
  self:GetGameObjects()
  self:RegisterItemClickEvent()
end

function UIListItemViewControllerAdventureSkill:GetGameObjects()
  if self.getGameObjectsComplete then
    return
  end
  self.goName = self:FindGO("Name")
  self.labName = self.goName:GetComponent(UILabel)
  self.goSkillPointValue = self:FindGO("LabSkillPoint")
  if self.goSkillPointValue then
    self.goSkillPointValue:SetActive(false)
  end
  self.goCurrency = self:FindGO("Currency")
  self.goCurrencyValue = self:FindGO("LabNeedCurrency", self.goCurrency)
  self.currencyIcon = self:FindComponent("IconCurrency", UISprite, self.goCurrency)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.currencyIcon)
  self.labCurrencyValue = self.goCurrencyValue:GetComponent(UILabel)
  self.goIcon = self:FindGO("Icon")
  self.spIcon = self.goIcon:GetComponent(UISprite)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.goRequireAdventureLevel = self:FindGO("RequireAdventureLevel")
  self.goSharedSkill = self:FindGO("SharedSkill")
  self.labRequireAdventureLevel = self.goRequireAdventureLevel:GetComponent(UILabel)
  self.getGameObjectsComplete = true
  self.lockState = self:FindGO("LockState")
end

function UIListItemViewControllerAdventureSkill:IsClickMe(click)
  return click == self.gameObject
end

function UIListItemViewControllerAdventureSkill:SetData(adventure_skill_shop_item_data)
  self.skillShopItemData = adventure_skill_shop_item_data
  self:InitializeModelSet()
  self:LoadView()
  self:UpdateLockInfo()
end

function UIListItemViewControllerAdventureSkill:InitializeModelSet()
  local skillID = self.skillShopItemData.SkillID
  self.skillConf = Table_Skill[skillID]
  if self.skillConf == nil then
    LogUtility.Error(string.format("Can't find configure(%s) in Skill.xlsx", tostring(skillID)))
  else
    self.needSkillPointCost = self.skillConf.Cost
  end
  self.adventureLevelID = UIModelAdventureSkill.Instance():GetAdventureLevel()
  if self.adventureLevelID == nil or self.adventureLevelID <= 0 then
    LogUtility.Error(string.format("Field self.adventureLevelID is illegal"))
  end
  self.needCurrency = self.skillShopItemData.ItemCount
end

function UIListItemViewControllerAdventureSkill:LoadView()
  self.labName.text = self.skillConf.NameZh
  self.needSkillPointCost = self.needSkillPointCost or "-1"
  local strNeedCurrency = FunctionNewRecharge.FormatMilComma(self.needCurrency)
  if strNeedCurrency ~= nil then
    self.labCurrencyValue.text = strNeedCurrency
  end
  if self.skillConf ~= nil then
    IconManager:SetSkillIcon(self.skillConf.Icon, self.spIcon)
  end
  local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
  if requireAdventureLevel ~= nil and 0 < requireAdventureLevel then
    self.labRequireAdventureLevel.text = string.format(ZhString.AdventureSkill_NeedReachAdventureLevel, Table_Appellation[requireAdventureLevel].Name)
  end
  if self:IsReachEnoughAdventureLevelForLearn() then
    self.goRequireAdventureLevel:SetActive(false)
    self.goCurrency:SetActive(true)
    self.widget.alpha = 1
  else
    self.goRequireAdventureLevel:SetActive(true)
    self.goCurrency:SetActive(false)
    self.widget.alpha = 0.4
  end
  self.goSharedSkill:GetComponent(UILabel).text = ZhString.SkillTip_Shared
  self.goSharedSkill:SetActive(self.skillConf.Share == 1)
end

function UIListItemViewControllerAdventureSkill:AddCellClickEvent()
end

function UIListItemViewControllerAdventureSkill:RegisterItemClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:OnItemViewClick()
  end)
end

function UIListItemViewControllerAdventureSkill:OnItemViewClick()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function UIListItemViewControllerAdventureSkill:IsReachEnoughAdventureLevelForLearn()
  local requireAdventureLevel = UIModelAdventureSkill.Instance():GetSkillRequireAppellation(self.skillShopItemData.id)
  requireAdventureLevel = requireAdventureLevel or 0
  self.adventureLevelID = self.adventureLevelID or 0
  return requireAdventureLevel <= self.adventureLevelID
end

function UIListItemViewControllerAdventureSkill:UpdateLockInfo()
  local menuId = self.skillShopItemData and self.skillShopItemData.MenuID
  if menuId == nil then
    return
  end
  if FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    self.lockState:SetActive(false)
    return
  end
  local goodsID = self.skillShopItemData.goodsID
  local unlockData = goodsID and Table_MenuUnclock[goodsID]
  if unlockData == nil then
    self.lockState:SetActive(false)
    return
  end
  self.labCurrencyValue.text = unlockData.MenuDes
end
