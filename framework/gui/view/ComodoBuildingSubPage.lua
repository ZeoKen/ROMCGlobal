ComodoBuildingSubPage = class("ComodoBuildingSubPage", SubView)
local buildingHelpIdMap = {
  [817419] = 35061,
  [817420] = 35062,
  [817421] = 35063,
  [817422] = 35064,
  [817424] = 35065,
  [817425] = 35066,
  [817426] = 35079
}
local leftBgName = "Disney_yhqd_bg_02"
local buildingUpgradeMatMaxNum = 4

function ComodoBuildingSubPage:Init()
  self.proxyIns = ComodoBuildingProxy.Instance
  self.buildingId = self.container.buildingId
  self:ReLoadPerferb("view/" .. self.__cname)
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self:AddEvents()
  self:InitPage()
  self:InitHelpButton()
end

function ComodoBuildingSubPage:AddEvents()
  self:AddListenEvt(ItemEvent.ItemUpdate, self._OnItemUpdate)
  self:AddListenEvt(ServiceEvent.SceneManorBuildQueryManorCmd, self._OnQuery)
  self:AddListenEvt(ServiceEvent.SceneManorBuildDataNtfManorCmd, self._OnQuery)
  self:AddListenEvt(ServiceEvent.SceneManorBuildLevelUpManorCmd, self._OnLevelUp)
  self:AddListenEvt(ServiceEvent.SceneManorBuildCollectManorCmd, self._OnCollect)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function ComodoBuildingSubPage:InitPage()
  self.leftBgTex = self:FindComponent("LeftBg", UITexture)
  self.buildingSp = self:FindComponent("BuildingSp", UISprite)
  self.buildingName = self:FindComponent("BuildingName", UILabel)
  self.buildingEffContainer = self:FindGO("BuildingEffContainer")
  if self.buildingSp then
    IconManager:SetUIIcon(GameConfig.Manor.BuildIconShow[self.buildingId], self.buildingSp)
    self.buildingSp:MakePixelPerfect()
  end
  if self.buildingName then
    self.buildingName.text = ComodoBuildingProxy.GetBuildingName(self.buildingId)
  end
  self.producePop = self:FindGO("ProducePop")
  self.produceIcon = self:FindComponent("ProduceIcon", UISprite)
  if self.producePop then
    self:AddClickEvent(self.producePop, function()
      ComodoBuildingProxy.Collect()
    end)
  end
  self:InitBuildingResources()
end

function ComodoBuildingSubPage:InitBuildingResources()
  self.resBasicCfg = GameConfig.Manor.ManorResource[self.buildingId]
  if not self.resBasicCfg then
    self.producePop, self.produceIcon = nil, nil
  end
  self.buildingUpgradeMatParent = self:FindGO("BuildingUpgradeMaterial")
  if self.buildingUpgradeMatParent then
    self.buildingUpgradeMatTable = self.buildingUpgradeMatParent:GetComponent(UITable)
    local x = LuaGameObject.GetLocalPosition(self.buildingUpgradeMatParent.transform)
    self.buildingUpgradeMatParent.transform.localPosition = LuaGeometry.GetTempVector3(x, self.resBasicCfg and -132 or -162)
    self.buildingUpgradeMatTable.padding = LuaGeometry.GetTempVector2(30, self.resBasicCfg and 6 or 16)
    self.buildingUpgradeMatElements, self.buildingUpgradeMatIcons, self.buildingUpgradeMatNumLabels = {}, {}, {}
    local element
    for i = 1, buildingUpgradeMatMaxNum do
      element = self:FindGO("Material" .. i, self.buildingUpgradeMatParent)
      if element then
        self.buildingUpgradeMatElements[i] = element
        self.buildingUpgradeMatIcons[i] = self:FindComponent("Icon", UISprite, element)
        self.buildingUpgradeMatNumLabels[i] = self:FindComponent("Num", UILabel, element)
        self:AddClickEvent(element, function()
          self:OnClickUpgradeMat(i)
        end)
      end
    end
  end
  self.produceSliderParent = self:FindGO("ProduceSliders")
  if self.produceSliderParent then
    self.produceSliderParent:SetActive(self.resBasicCfg ~= nil)
    if self.resBasicCfg then
      self.produceSliderGOs, self.produceSliderRightLabels, self.produceSliders = {}, {}, {}
      local element
      for i = 1, buildingUpgradeMatMaxNum do
        element = self:FindGO("Slider" .. i, self.produceSliderParent)
        if element then
          self.produceSliderGOs[i] = element
          self.produceSliderRightLabels[i] = self:FindComponent("RightLabel", UILabel, element)
          self.produceSliders[i] = self:FindComponent("Slider", UISlider, element)
        end
      end
    end
  end
end

function ComodoBuildingSubPage:InitHelpButton()
  local buttonobj = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(self:GetHelpId(), nil, buttonobj)
end

function ComodoBuildingSubPage:GetHelpId()
  return buildingHelpIdMap[self.buildingId]
end

function ComodoBuildingSubPage:OnEnter()
  ComodoBuildingSubPage.super.OnEnter(self)
  if self.leftBgTex then
    PictureManager.Instance:SetUI(leftBgName, self.leftBgTex)
  end
  if self.buildingUpgradeMatTable then
    self.buildingUpgradeMatTable:Reposition()
  end
  if self.resBasicCfg then
    self.maxProduceVelocity = self.proxyIns.buildingMaxResProduceVelocityMap[self.buildingId]
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateProduce, self, 9999)
  end
  self.tipData = {
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.buildingUpgradeMatParent
    }
  }
end

function ComodoBuildingSubPage:OnActivate()
  self:UpdateMaterial()
  self:UpdateProduce()
end

function ComodoBuildingSubPage:OnExit()
  if self.leftBgTex then
    PictureManager.Instance:UnLoadUI(leftBgName, self.leftBgTex)
  end
  TimeTickManager.Me():ClearTick(self)
  ComodoBuildingSubPage.super.OnExit(self)
end

local matTipOffset = {350, 0}

function ComodoBuildingSubPage:OnClickUpgradeMat(index)
  local icon = self.buildingUpgradeMatIcons[index]
  if not icon then
    return
  end
  self.upgradeMatTipItemData = self.upgradeMatTipItemData or ItemData.new()
  self.upgradeMatTipItemData:ResetData("Material", self:GetUpgradeMaterialConfig()[index])
  self:ShowItemTip(self.upgradeMatTipItemData, icon, NGUIUtil.AnchorSide.Right, matTipOffset)
end

function ComodoBuildingSubPage:_OnItemUpdate()
  self:UpdateMaterial()
  if self.OnItemUpdate then
    self:OnItemUpdate()
  end
end

function ComodoBuildingSubPage:_OnQuery()
  self:UpdateProduce()
  if self.OnQuery then
    self:OnQuery()
  end
end

function ComodoBuildingSubPage:_OnLevelUp()
  self:UpdateProduce()
  if self.buildingEffContainer then
    self:PlayUIEffect(EffectMap.UI.iz_dis_up_ui, self.buildingEffContainer, true)
  end
  if self.OnLevelUp then
    self:OnLevelUp()
  end
end

function ComodoBuildingSubPage:_OnCollect()
  self:UpdateProduce()
  if self.OnCollect then
    self:OnCollect()
  end
end

function ComodoBuildingSubPage:UpdateMaterial()
  if not self.buildingUpgradeMatParent then
    return
  end
  local cfg, itemId = self:GetUpgradeMaterialConfig()
  for i = 1, buildingUpgradeMatMaxNum do
    itemId = cfg and cfg[i]
    self.buildingUpgradeMatElements[i]:SetActive(itemId ~= nil)
    if itemId then
      IconManager:SetItemIcon(Table_Item[itemId].Icon, self.buildingUpgradeMatIcons[i])
      self.buildingUpgradeMatNumLabels[i].text = HappyShopProxy.Instance:GetItemNum(itemId)
    end
  end
end

function ComodoBuildingSubPage:UpdateProduce()
  if not self.resBasicCfg or not self.produceSliderParent then
    return
  end
  local velocity = self.proxyIns:GetCurrentProduceVelocity(self.buildingId)
  self.produceSliderRightLabels[1].text = string.format("%.2f/min", velocity)
  self.produceSliders[1].value = self.maxProduceVelocity and math.clamp(velocity / self.maxProduceVelocity, 0, 1) or 1
  local curProduce, capacity = self.proxyIns:GetCurrentProduce(self.buildingId)
  self.produceSliders[2].value = capacity and 0 < capacity and curProduce / capacity or 0
  self.produceSliderRightLabels[2].text = string.format("%d/%s", curProduce, capacity)
  local isShowPop = 0 < curProduce
  self.producePop:SetActive(isShowPop)
  if isShowPop then
    IconManager:SetUIIcon(self.proxyIns:GetDisplayIconNameOfReservedProduce(self.buildingId), self.produceIcon)
  end
end

function ComodoBuildingSubPage:GetUpgradeMaterialConfig()
  return GameConfig.Manor.BuildingLvUpMat
end

function ComodoBuildingSubPage:AddButtonEvent(name, event)
  ComodoBuildingSubPage.super.super.AddButtonEvent(self, name, event)
end

function ComodoBuildingSubPage:ShowItemTip(itemData, stick, side, offset)
  self.tipData.itemdata = itemData
  ComodoBuildingSubPage.super.ShowItemTip(self, self.tipData, stick, side, offset)
end
