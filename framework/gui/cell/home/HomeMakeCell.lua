autoImport("BaseCell")
autoImport("MaterialHomeCell")
HomeMakeCell = class("HomeMakeCell", BaseCell)
HomeMakeCell.ClickToItem = "HomeMakeCell_ClickToItem"
HomeMakeCell.ClickMaterial = "HomeMakeCell_ClickMaterial"
HomeMakeCell.GoToMake = "HomeMakeCell_GoToMake"
HomeMakeCell.TraceMaterial = "HomeMakeCell_TraceMaterial"
HomeMakeCell.RTBGName = "home_compose_BG2"
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, PRODUCE_MATERIAL_SEARCH_BAGTYPES
local pacakgeCheck = GameConfig.PackageMaterialCheck
DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1, 9}
PRODUCE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.produce or DEFAULT_MATERIAL_SEARCH_BAGTYPES

function HomeMakeCell:Init()
  self.composeCount = 1
  self.combine_lacMats = {}
  self.cache_sortingOrder = {}
  self:InitView()
end

function HomeMakeCell:InitView()
  self.roblab = self:FindComponent("ROGold", UILabel)
  local zenyIcon = self:FindComponent("Symbol", UISprite)
  IconManager:SetItemIconById(100, zenyIcon)
  self.makeTip = self:FindComponent("MakeTip", UILabel)
  self.composeCountLabel = self:FindComponent("CountLabel", UILabel)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, MaterialHomeCell, "MaterialHomeCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMaterial, self)
  self.texFurniture = self:FindComponent("texFurniture", UITexture)
  local effectContainer = self:FindGO("EffectContainer")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/14itemShine"), effectContainer)
  self.trackButton = self:FindGO("TrackButton")
  if self.trackButton then
    self.trackButton:SetActive(false)
  end
  self.goMakeButton = self:FindGO("GoMakeButton")
  self:AddClickEvent(self.goMakeButton, function(go)
    self:PassEvent(HomeMakeCell.GoToMake, self)
  end)
  self.quickBuyButton = self:FindGO("QuickBuyButton")
  self:AddClickEvent(self.quickBuyButton, function(go)
    if #self.combine_lacMats > 0 then
      HomeMakeCell.useDeduction = self.checkBtn.value
      if QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
        return
      end
    end
  end)
  self.makeBtn = self:FindGO("MakeButton")
  self:AddClickEvent(self.makeBtn, function(go)
    if #self.combine_lacMats > 0 then
      HomeMakeCell.useDeduction = self.checkBtn.value
      if QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
        return
      end
    end
    if self.canCompose then
      self:PassEvent(MouseEvent.MouseClick, self)
    else
      MsgManager.ShowMsgByIDTable(8)
    end
  end)
  self.minusBtn = self:FindComponent("MinusBtn", UIButton)
  self.plusBtn = self:FindComponent("PlusBtn", UIButton)
  self:AddClickEvent(self.minusBtn.gameObject, function(go)
    self:ReduceCount()
  end)
  self:AddClickEvent(self.plusBtn.gameObject, function(go)
    self:AddCount()
  end)
  self.checkBtn = self:FindComponent("CheckBtn", UIToggle)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:UpdateCostMaterial()
    self:UpdateButtons()
  end)
  self.checkBtn.value = HomeMakeCell.useDeduction or false
  HomeMakeCell.useDeduction = nil
end

function HomeMakeCell:AddCount()
  self.composeCount = self.composeCount + 1
  self.data.composeCount = self.composeCount
  if self.data.viewdata and self.data.viewdata.chooseCount then
    self.data.viewdata.chooseCount = self.composeCount
  end
  self:UpdateCostMaterial()
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateComposeLabel()
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end

function HomeMakeCell:ReduceCount()
  self.composeCount = self.composeCount - 1
  self.data.composeCount = self.composeCount
  if self.data.viewdata and self.data.viewdata.chooseCount then
    self.data.viewdata.chooseCount = self.composeCount
  end
  self:UpdateCostMaterial()
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateComposeLabel()
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end

function HomeMakeCell:UpdateCountBtns()
  if self.composeCount <= 1 then
    self.minusBtn.isEnabled = false
  elseif self.composeCount > 1 then
    self.minusBtn.isEnabled = true
  end
  if self.composeCount < 20 then
    self.plusBtn.isEnabled = true
  else
    self.plusBtn.isEnabled = false
  end
end

function HomeMakeCell:Refresh()
  self:SetData(self.data)
end

function HomeMakeCell:SetData(data)
  local composeID
  if type(data.viewdata) == "number" then
    local itemData = Table_Item[data.viewdata]
    composeID = itemData and itemData.ComposeID
    self.data = {}
    self.data.composeId = composeID
  elseif data.viewdata and data.viewdata.staticData then
    self.data = data
    composeID = self.data.viewdata.staticData.ComposeID
    self.data.composeId = composeID
  end
  if not self.data.composeId then
    return
  else
    composeID = self.data.composeId
  end
  if self.data then
    self.composeCount = self.data.viewdata and self.data.viewdata.chooseCount or math.min(math.max(1, self:GetItemNum(composeID)), 20)
  else
    self.composeCount = math.min(math.max(1, self:GetItemNum(composeID)), 20)
  end
  if not Table_Compose[composeID] then
    return
  end
  self.composeID = composeID
  local cdata = Table_Compose[composeID]
  self.toItem = ItemData.new(0, cdata.Product.id)
  local toSdata = self.toItem.staticData
  self:UpdateFashionModel(self.toItem)
  self.canCompose = true
  self:UpdateCostMaterial()
  self.paperCount = self:GetItemNum(self.composeID)
  self:UpdateComposeLabel()
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateCountBtns()
  self:UpdateROBLabel()
  self:UpdateButtons()
end

function HomeMakeCell:UpdateMaterialsData()
  local cdata = Table_Compose[self.composeID]
  if cdata then
    self.materialsData = {}
    local failIndexMap = {}
    if cdata.FailStayItem then
      for i = 1, #cdata.FailStayItem do
        local index = cdata.FailStayItem[i]
        if index then
          failIndexMap[index] = 1
        end
      end
    end
    for i = 1, #cdata.BeCostItem do
      local v = cdata.BeCostItem[i]
      if v and not failIndexMap[i] then
        local tempData = ItemData.new("Material", v.id)
        tempData.num = self:GetItemNum(v.id)
        tempData.neednum = v.num * self.composeCount
        if tempData.staticData.Type ~= 50 then
          table.insert(self.materialsData, tempData)
        end
      end
    end
  end
  for k, v in pairs(self.materialsData) do
    v.composeCount = self.composeCount
  end
  self.data.composeCount = self.composeCount
end

function HomeMakeCell:UpdateLacMaterials()
  local cdata = Table_Compose[self.composeID]
  if cdata then
    TableUtility.ArrayClear(self.combine_lacMats)
    local failIndexMap = {}
    if cdata.FailStayItem then
      for i = 1, #cdata.FailStayItem do
        local index = cdata.FailStayItem[i]
        if index then
          failIndexMap[index] = 1
        end
      end
    end
    for i = 1, #self.materialsData do
      local v = self.materialsData[i]
      if not failIndexMap[i] then
        local neednum = v.neednum
        if neednum > v.num then
          local lackItem = {
            id = v.staticData.id,
            count = neednum - v.num
          }
          table.insert(self.combine_lacMats, lackItem)
        end
      end
    end
  end
end

function HomeMakeCell:UpdateROBLabel()
  local cdata = Table_Compose[self.composeID]
  if cdata and self.composeCount then
    local rob = cdata.ROB * self.composeCount
    if 0 < rob then
      self.roblab.gameObject:SetActive(true)
      if rob > MyselfProxy.Instance:GetROB() then
        self.lackMoney = true
        self.roblab.text = CustomStrColor.BanRed .. tostring(rob) .. "[-]"
      else
        self.lackMoney = false
        self.roblab.text = tostring(rob)
      end
    else
      self.roblab.gameObject:SetActive(false)
    end
  end
end

function HomeMakeCell:UpdateComposeLabel()
  self.composeCountLabel.text = self.composeCount or 1
end

function HomeMakeCell:GetItemNum(itemid)
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
  local searchNum = 0
  if items then
    for i = 1, #items do
      searchNum = searchNum + items[i].num
    end
  end
  return searchNum
end

function HomeMakeCell:UpdateFashionModel(fashionData)
  local staticData = self.data.staticData
  if self.modelTimer then
    TimeTickManager.Me():ClearTick(self)
  end
  local composeID
  if staticData then
    composeID = staticData.ComposeID
  else
    composeID = self.composeID
  end
  local composeInfo = Table_Compose[composeID]
  if not composeInfo then
    return
  end
  local furnitureId = composeInfo.Product.id
  if Table_HomeFurniture[furnitureId] then
    UIModelUtil.Instance:SetFurnitureModelTexture(self.texFurniture, furnitureId, UIModelCameraTrans.FurnitureMake, function(obj)
      self:UpdateFashionModelCallBack(obj, false)
    end)
  elseif Table_HomeFurnitureMaterial[furnitureId] then
    UIModelUtil.Instance:SetHomeMaterialModelTexture(self.texFurniture, furnitureId, UIModelCameraTrans.FurnitureMake, function(obj)
      self:UpdateFashionModelCallBack(obj, true)
    end)
  else
    redlog("nothing can show :" .. furnitureId)
  end
end

function HomeMakeCell:UpdateFashionModelCallBack(obj, isHomeMat)
  self.furnitureModel = obj
  UIModelUtil.Instance:ChangeBGMeshRenderer(HomeMakeCell.RTBGName, self.texFurniture)
  if self.furnitureModel then
    self.modelTimer = TimeTickManager.Me():CreateTick(0, 17, function()
      if LuaGameObject.ObjectIsNull(self.furnitureModel.gameObject) then
        return
      end
      if not isHomeMat then
        self.furnitureModel:RotateDelta(-1)
      else
        LuaGameObject.LocalRotateDeltaByAxisY(self.furnitureModel.transform, -1)
      end
    end, self)
  end
end

function HomeMakeCell:ActiveGoMakeButton(b)
  self.gotoMake_active = b
  self:UpdateButtons()
end

function HomeMakeCell:UpdateButtons()
  local canMake = #self.combine_lacMats <= 0
  self.data.lackMoney = self.lackMoney
  self.quickBuyButton:SetActive(not canMake)
  self.makeTip.gameObject:SetActive(not canMake)
  self.roblab.gameObject:SetActive(canMake)
  if canMake then
    self.makeBtn:SetActive(self.gotoMake_active ~= true)
    self.goMakeButton:SetActive(self.gotoMake_active == true)
  else
    self.makeBtn:SetActive(false)
    self.goMakeButton:SetActive(false)
  end
  if self.composeCount == 0 then
    self.goMakeButton:SetActive(false)
  end
end

function HomeMakeCell:ClickMaterial(cellctl)
  self:PassEvent(HomeMakeCell.ClickMaterial, cellctl)
end

function HomeMakeCell:RemoveModel()
  if self.furnitureModel then
    UIModelUtil.Instance:ResetTexture(self.furnitureModel)
  end
  if self.modelTimer then
    TimeTickManager.Me():ClearTick(self)
    self.modelTimer = nil
  end
end

function HomeMakeCell:OnRemove()
  self:RemoveModel()
end

function HomeMakeCell:UpdateCostMaterial()
  self:UpdateMaterialsData()
  if self.checkBtn.value then
    local mats = {}
    for i = 1, #self.materialsData do
      local matData = self.materialsData[i]
      local mat = {
        id = matData.staticData.id,
        num = matData.neednum
      }
      mats[i] = mat
    end
    local result, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(mats, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    else
      for i = 1, #result do
        local data = result[i]
        local matData = TableUtility.ArrayFindByPredicate(self.materialsData, function(v, args)
          return v.staticData.id == args
        end, data.id)
        if matData then
          matData.num = data.exchangenum or BagProxy.Instance:GetItemNumByStaticID(data.id, PRODUCE_MATERIAL_SEARCH_BAGTYPES) or 0
          matData.deduction = data.deduction
        else
          matData = ItemData.new("Deduction", data.id)
          matData.num = BagProxy.Instance:GetItemNumByStaticID(data.id, PRODUCE_MATERIAL_SEARCH_BAGTYPES) or 0
          matData.neednum = data.num
          table.insert(self.materialsData, matData)
        end
      end
    end
  end
  self.materialCtl:ResetDatas(self.materialsData)
  self:UpdateLacMaterials()
end
