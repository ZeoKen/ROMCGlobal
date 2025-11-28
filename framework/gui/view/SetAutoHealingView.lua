autoImport("AutoHealingPotionCell")
SetAutoHealingView = class("SetAutoHealingView", ContainerView)
SetAutoHealingView.ViewType = UIViewType.PopUpLayer
local SettingEnum = {HP = 1, SP = 2}
local patternName = "team_bg_pattern_6"
local limitChangeStep = 10
local halfStep = limitChangeStep / 2
local hpPotions = {}
local spPotions = {}

function SetAutoHealingView:Init()
  self.minLimitValue = GameConfig.PotionStore and GameConfig.PotionStore.min_per
  self.minLimitValue = self.minLimitValue or 10
  self.maxLimitValue = GameConfig.PotionStore and GameConfig.PotionStore.max_per
  self.maxLimitValue = self.maxLimitValue or 100
  self:FindObjs()
end

function SetAutoHealingView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:SavePotionSetting()
    self:CloseSelf()
  end)
  self.settingCell = {}
  for _, type in pairs(SettingEnum) do
    self.settingCell[type] = SetAutoHealingCell.new(self, type)
  end
  self.useLimitSet = self:FindGO("UseLimitSet")
  self.pattern1 = self:FindComponent("pattern1", UITexture, self.useLimitSet)
  self.pattern2 = self:FindComponent("pattern2", UITexture, self.useLimitSet)
  self.plusBtn = self:FindGO("plusBtn", self.useLimitSet)
  self:AddClickEvent(self.plusBtn, function()
    self:OnPlusBtnClick()
  end)
  self.minusBtn = self:FindGO("minusBtn", self.useLimitSet)
  self:AddClickEvent(self.minusBtn, function()
    self:OnMinusBtnClick()
  end)
  self.progressBar = self:FindComponent("progressBar", UIProgressBar, self.useLimitSet)
  self.minValueLabel = self:FindComponent("Label1", UILabel, self.useLimitSet)
  self.midValueLabel = self:FindComponent("Label2", UILabel, self.useLimitSet)
  self.maxValueLabel = self:FindComponent("Label3", UILabel, self.useLimitSet)
  self.potionChoose = self:FindGO("potionChoose")
  local potionGrid = self:FindComponent("Grid", UIGrid)
  self.potionList = UIGridListCtrl.new(potionGrid, AutoHealingPotionCell, "AutoHealingPotionCell")
  self.potionList:AddEventListener(MouseEvent.MouseClick, self.OnPotionCellClick, self)
  self:AddOrRemoveGuideId("CloseButton", 467)
end

function SetAutoHealingView:OnEnter()
  local hpSetting = AutoHealingProxy.Instance:GetPotionSetting(SettingEnum.HP)
  local spSetting = AutoHealingProxy.Instance:GetPotionSetting(SettingEnum.SP)
  for _, type in pairs(SettingEnum) do
    local setting = AutoHealingProxy.Instance:GetPotionSetting(type)
    self.settingCell[type]:SetData(setting)
  end
  self.minValueLabel.text = self.minLimitValue .. "%"
  self.maxValueLabel.text = self.maxLimitValue .. "%"
  self.midValueLabel.text = math.floor((self.maxLimitValue + self.minLimitValue) / 2) .. "%"
  PictureManager.Instance:SetUI(patternName, self.pattern1)
  PictureManager.Instance:SetUI(patternName, self.pattern2)
  self:AddMonoUpdateFunction(self.OnUpdate)
end

function SetAutoHealingView:OnExit()
  SetAutoHealingView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(patternName, self.pattern1)
  PictureManager.Instance:UnLoadUI(patternName, self.pattern1)
end

function SetAutoHealingView:OnSetValueBtnClick(type)
  self.curSettingType = type
  self.potionChoose:SetActive(false)
  self.useLimitSet:SetActive(true)
  local curValue = AutoHealingProxy.Instance:GetPotionUseLimit(type)
  self:SetProgressBar(curValue)
end

function SetAutoHealingView:SetProgressBar(value)
  self.progressBar.value = (value - self.minLimitValue) / (self.maxLimitValue - self.minLimitValue)
  self.lastLimitValue = value
end

function SetAutoHealingView:OnSetCheckOnBtnClick(type, on)
  AutoHealingProxy.Instance:SetAutoHealingState(type, on)
  if self.curSettingType == type then
    self.useLimitSet:SetActive(false)
    self.potionChoose:SetActive(false)
  end
end

function SetAutoHealingView:OnPlusBtnClick()
  local curValue = AutoHealingProxy.Instance:GetPotionUseLimit(self.curSettingType)
  curValue = math.min(curValue + limitChangeStep, self.maxLimitValue)
  self:SetPotionUseLimit(curValue)
end

function SetAutoHealingView:OnMinusBtnClick()
  local curValue = AutoHealingProxy.Instance:GetPotionUseLimit(self.curSettingType)
  curValue = math.max(curValue - limitChangeStep, self.minLimitValue)
  self:SetPotionUseLimit(curValue)
end

function SetAutoHealingView:SetCellLimitValue(value)
  local cell = self.settingCell[self.curSettingType]
  if cell then
    cell:SetLimitValue(value)
  end
end

function SetAutoHealingView:SetPotionUseLimit(value)
  self:SetProgressBar(value)
  self:SetCellLimitValue(value)
  AutoHealingProxy.Instance:SetPotionUseLimit(self.curSettingType, value)
end

function SetAutoHealingView:OnPotionSelected(type)
  self.curSettingType = type
  self:RefreshPotionList()
  self.useLimitSet:SetActive(false)
  self.potionChoose:SetActive(true)
end

function SetAutoHealingView:OnPotionDelete(type, index)
  self:RefreshPotionList()
end

function SetAutoHealingView:OnPotionQuickSet(type)
  self:RefreshPotionList()
end

function SetAutoHealingView:OnPotionCellClick(cellCtrl)
  local type = cellCtrl.type
  local itemId = cellCtrl.id
  local num = BagProxy.Instance:GetItemNumByStaticID(itemId)
  if 0 < num and self.settingCell[type]:SetCurPotionData(itemId) then
    self:RefreshPotionList()
  end
end

function SetAutoHealingView:RefreshPotionList()
  local datas = AutoHealingProxy.Instance:GetPotionItems(self.curSettingType)
  if datas then
    self.potionList:ResetDatas(datas)
  end
end

function SetAutoHealingView:SetPotionSelectState(type)
  for _, v in pairs(SettingEnum) do
    if v ~= type then
      self.settingCell[v]:SetPotionSelectState()
    end
  end
end

function SetAutoHealingView:SavePotionSetting()
  local hpSetting = AutoHealingProxy.Instance:GetPotionSetting(SettingEnum.HP)
  local spSetting = AutoHealingProxy.Instance:GetPotionSetting(SettingEnum.SP)
  ServiceItemProxy.Instance:CallPotionStoreNtf(hpSetting, spSetting)
end

autoImport("BaseCell")
SetAutoHealingCell = class("SetAutoHealingCell", BaseCell)
local normalSprite = "com_bg_money3"
local graySprite = "com_bg_money3_gray"
local normalLabelCol = "383838"
local grayLabelCol = "A5A5A5"
local PotionStateEnum = {EMPTY = 0, OCCUPIED = 1}

function SetAutoHealingCell:ctor(container, type)
  self.container = container
  local parent
  if type == SettingEnum.HP then
    parent = self.container:FindGO("hpSetting")
  else
    parent = self.container:FindGO("spSetting")
  end
  self:FindObjs(parent)
  self.type = type
end

function SetAutoHealingCell:FindObjs(parent)
  self.checkBtn = self:FindGO("checkBg", parent)
  self:AddClickEvent(self.checkBtn, function()
    self:OnCheckBtnClick()
  end)
  self.check = self:FindGO("check", self.checkBtn)
  self.valueBtn = self:FindGO("valueBtn", parent)
  self:AddClickEvent(self.valueBtn, function()
    self.container:OnSetValueBtnClick(self.type)
  end)
  self.valueBtnCollider = self.valueBtn:GetComponent(BoxCollider)
  self.valueSp = self.valueBtn:GetComponent(UISprite)
  self.valueLabel = self:FindComponent("value", UILabel, parent)
  for i = 1, 3 do
    local potion = self:FindGO("potion" .. i, parent)
    self:AddClickEvent(potion, function()
      self:OnPotionClick(i)
    end)
    self["potionCollider" .. i] = potion:GetComponent(BoxCollider)
    self["potionSp" .. i] = potion:GetComponent(UISprite)
    self["potionIcon" .. i] = self:FindComponent("icon", UISprite, potion)
    self["potionNumLabel" .. i] = self:FindComponent("num", UILabel, potion)
    self["potionSelected" .. i] = self:FindGO("selected", potion)
    self["potionDelete" .. i] = self:FindGO("delete", potion)
    self["potionAdd" .. i] = self:FindGO("add", potion)
    self:AddClickEvent(self["potionDelete" .. i], function()
      self:OnPotionDeleteBtnClick(i)
    end)
  end
  self.quickSetBtn = self:FindGO("quickSetBtn", parent)
  self:AddClickEvent(self.quickSetBtn, function()
    self:OnQuickSetBtnClick()
  end)
  self.quickSetBtnGray = self:FindGO("quickSetBtnGray", parent)
end

function SetAutoHealingCell:SetData(data)
  if data then
    self.isCheckOn = data.auto_on or false
    self:SetAutoHealingState(self.isCheckOn)
    self:SetLimitValue(data.edge)
    for i = 1, #data.item do
      local itemId = data.item[i]
      self:SetPotionData(i, itemId)
    end
    if self.type == SettingEnum.HP then
      self:AddOrRemoveGuideId(self.checkBtn, 465)
      self:AddOrRemoveGuideId(self.quickSetBtn, 466)
    end
  end
end

function SetAutoHealingCell:SetLimitValue(value)
  self.value = value
  self.valueLabel.text = value
end

function SetAutoHealingCell:SetCurPotionData(itemId)
  local curItemId = AutoHealingProxy.Instance:GetPotionItemId(self.type, self.selectedIndex)
  if 0 < curItemId then
    self:OnPotionDeleteBtnClick(self.selectedIndex)
  end
  if curItemId ~= itemId then
    local itemIndex = AutoHealingProxy.Instance:GetPotionItemIndex(self.type, itemId)
    if 0 < itemIndex then
      self:SetPotionData(itemIndex, curItemId)
    end
    self:SetPotionData(self.selectedIndex, itemId)
    local nextIndex = self:FindNextIndex(self.selectedIndex)
    if nextIndex ~= self.selectedIndex then
      self:SetPotionSelectState(nextIndex)
    end
    return true
  end
  return false
end

function SetAutoHealingCell:SetPotionData(index, itemId)
  local icon = self["potionIcon" .. index]
  local sp = self["potionSp" .. index]
  local num = ""
  itemId = itemId or 0
  if 0 < itemId then
    icon.gameObject:SetActive(true)
    local config = Table_Item[itemId]
    IconManager:SetItemIcon(config.Icon, icon)
    num = BagProxy.Instance:GetItemNumByStaticID(itemId)
    sp.alpha = 0 < num and 1 or 0.4
    num = 1 < num and num or ""
    self["potionAdd" .. index]:SetActive(false)
  else
    icon.gameObject:SetActive(false)
    sp.alpha = 1
    self["potionDelete" .. index]:SetActive(false)
    self["potionAdd" .. index]:SetActive(true)
  end
  self["potionNumLabel" .. index].text = num
  AutoHealingProxy.Instance:SetPotionItemId(self.type, index, itemId)
end

function SetAutoHealingCell:OnCheckBtnClick()
  self.isCheckOn = not self.isCheckOn
  self:SetAutoHealingState(self.isCheckOn)
  self.container:OnSetCheckOnBtnClick(self.type, self.isCheckOn)
end

function SetAutoHealingCell:SetAutoHealingState(on)
  self.check:SetActive(on)
  self.valueBtnCollider.enabled = on
  self.valueSp.spriteName = on and normalSprite or graySprite
  local _, normalCol = ColorUtil.TryParseHexString(normalLabelCol)
  local _, grayCol = ColorUtil.TryParseHexString(grayLabelCol)
  self.valueLabel.color = on and normalCol or grayCol
  self.quickSetBtn:SetActive(on)
  self.quickSetBtnGray:SetActive(not on)
  for i = 1, 3 do
    self:SetPotionIconState(i, on)
  end
  self:SetPotionSelectState()
end

function SetAutoHealingCell:SetPotionIconState(index, on)
  self["potionSp" .. index].alpha = on and 1 or 0.4
  self["potionCollider" .. index].enabled = on
  if not on then
    self["potionDelete" .. index]:SetActive(false)
  end
end

function SetAutoHealingCell:OnPotionClick(index)
  self:SetPotionSelectState(index)
  self.container:OnPotionSelected(self.type)
end

function SetAutoHealingCell:SetPotionSelectState(selectedIndex)
  self.selectedIndex = selectedIndex
  if selectedIndex then
    self["potionSelected" .. selectedIndex]:SetActive(true)
    self.container:SetPotionSelectState(self.type)
  end
  local itemId = AutoHealingProxy.Instance:GetPotionItemId(self.type, selectedIndex)
  if 0 < itemId then
    self["potionDelete" .. selectedIndex]:SetActive(true)
  end
  for i = 1, 3 do
    if i ~= selectedIndex then
      self["potionSelected" .. i]:SetActive(false)
      self["potionDelete" .. i]:SetActive(false)
    else
      local itemId = AutoHealingProxy.Instance:GetPotionItemId(self.type, i)
      if 0 < itemId then
        self["potionDelete" .. i]:SetActive(true)
      else
        self["potionDelete" .. i]:SetActive(false)
      end
    end
  end
end

function SetAutoHealingCell:OnPotionDeleteBtnClick(index)
  self:SetPotionData(index)
  self["potionDelete" .. index]:SetActive(false)
  self.container:OnPotionDelete(self.type, index)
end

function SetAutoHealingCell:OnQuickSetBtnClick()
  local items = ReusableTable.CreateArray()
  AutoHealingProxy.Instance:GetQuickSetPotion(self.type, items)
  local potionNum = 3
  for i = 1, 3 do
    self:SetPotionData(i, items[i])
    if not items[i] or items[i] == 0 then
      potionNum = potionNum - 1
    end
  end
  self.container:OnPotionQuickSet(self.type)
  ReusableTable.DestroyAndClearArray(items)
  if potionNum == 0 then
    MsgManager.ShowMsgByID(43136)
  end
end

function SetAutoHealingCell:FindNextIndex(curIndex)
  local nextIndex = curIndex % 3 + 1
  if nextIndex == self.selectedIndex then
    return nextIndex
  end
  local itemId = AutoHealingProxy.Instance:GetPotionItemId(self.type, nextIndex)
  if itemId == 0 then
    return nextIndex
  else
    return self:FindNextIndex(nextIndex)
  end
end

function SetAutoHealingView:OnUpdate()
  if not self.lastLimitValue then
    return
  end
  local curValue = self.progressBar.value * (self.maxLimitValue - self.minLimitValue) + self.minLimitValue
  if curValue == self.lastLimitValue then
    return
  end
  local delta = curValue - self.lastLimitValue
  if delta > -halfStep and delta < halfStep then
    curValue = self.lastLimitValue
  elseif delta <= -halfStep then
    curValue = math.max(self.lastLimitValue - limitChangeStep, self.minLimitValue)
  else
    curValue = math.min(self.lastLimitValue + limitChangeStep, self.maxLimitValue)
  end
  self:SetPotionUseLimit(curValue)
end
