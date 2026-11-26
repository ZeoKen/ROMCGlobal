autoImport("BaseTip")
autoImport("SnowCrownCostItemCell")
SnowCrownAttrTip = class("SnowCrownAttrTip", BaseTip)
local NextGap = 34
local TextFormatNormal = "%s/%s"
local TextFormatRed = "[c][FF3B35]%s[-][/c]/%s"
local DefaultBottomBgY, LongBottomBgY = -107, -253
local UnlockLabelFallback = "解锁"
local FormatCostNum = function(num, needNum, isLack)
  local format = isLack and TextFormatRed or TextFormatNormal
  return string.format(format, num, needNum)
end

function SnowCrownAttrTip:Init()
  self:FindObjs()
  self.lackMats = {}
end

function SnowCrownAttrTip:FindObjs()
  self.callbackWhenClickOtherPlace = self:FindComponent("Bg", CallBackWhenClickOtherPlace)
  
  function self.callbackWhenClickOtherPlace.call()
    self:CloseTip()
  end
  
  self.iconBg = self:FindGO("IconBg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.level = self:FindComponent("Level", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.next = self:FindGO("Next")
  self.nextDesc = self:FindComponent("NextDesc", UILabel)
  self.descTrans = self.desc.gameObject.transform
  self.nextTrans = self.next.transform
  if self.descTrans and self.nextTrans then
    local dx, dy, dz = LuaGameObject.GetLocalPosition(self.descTrans)
    local nx, ny, nz = LuaGameObject.GetLocalPosition(self.nextTrans)
    self.descPos = {
      x = dx,
      y = dy,
      z = dz
    }
    self.nextPos = {
      x = nx,
      y = ny,
      z = nz
    }
  end
  local grid = self:FindComponent("Grid", UIGrid)
  self.costListCtrl = UIGridListCtrl.new(grid, SnowCrownCostItemCell, "ItemCell")
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.upgradeLabel = self:FindComponent("UpgradeLabel", UILabel)
  self.maxLv = self:FindGO("MaxLv")
  self.costPart = self:FindGO("CostPart")
  self.bottomBg = self:FindGO("BottomBg")
  local checkBtnGO = self:FindGO("CheckBtn")
  if checkBtnGO then
    self.checkBtn = checkBtnGO:GetComponent(UIToggle)
    self:AddClickEvent(checkBtnGO, function()
      self:RefreshCost()
    end)
  end
end

function SnowCrownAttrTip:ClearLegacyIconItemCell()
  if self.iconCellCleared or not self.iconBg then
    return
  end
  self.iconCellCleared = true
  local iconBgTrans = self.iconBg.transform
  for i = iconBgTrans.childCount - 1, 0, -1 do
    local childGO = iconBgTrans:GetChild(i).gameObject
    if childGO.name == "SnowCrownIconItemCell" or childGO.name == "ItemCell" then
      GameObject.DestroyImmediate(childGO)
    end
  end
end

function SnowCrownAttrTip:SetData(data)
  self.data = data
  if data and data.staticData then
    self:SetIcon(data.staticData.Icon)
    self.name.text = data.staticData.Name
    local maxLevel = Game.SnowCrownGroupMaxLevel[data.id // 100]
    local isMax = maxLevel ~= nil and maxLevel <= data.level or false
    self.level.text = isMax and ZhString.SnowCrown_MaxLevel or "Lv." .. data.level
    self:SetDesc(data, isMax)
    self.nextStatic = self:GetNextStatic(data.id)
    self.isMax = isMax
    self.isGlobal = data.tab == 2
    if self.checkBtn then
      if not self.keepCheckState then
        self.checkBtn.value = false
      end
      self.checkBtn.gameObject:SetActive(not isMax and self.nextStatic ~= nil and not self.isGlobal)
    end
    self.maxLv:SetActive(isMax)
    self.costPart:SetActive(not isMax)
    self.upgradeBtn:SetActive(not isMax)
    self:RefreshCost()
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.bottomBg)
    y = isMax and LongBottomBgY or DefaultBottomBgY
    LuaGameObject.SetLocalPositionGO(self.bottomBg, x, y, z)
  end
end

function SnowCrownAttrTip:SetIcon(iconName)
  if not self.icon then
    return
  end
  self:ClearLegacyIconItemCell()
  self.icon.gameObject:SetActive(true)
  if iconName then
    self.icon.spriteName = iconName
    self.icon:MakePixelPerfect()
  end
end

function SnowCrownAttrTip:RefreshData(data)
  self.keepCheckState = true
  self:SetData(data)
  self.keepCheckState = nil
end

function SnowCrownAttrTip:RefreshCost()
  if not self.costListCtrl then
    return
  end
  local datas = {}
  self.lack = false
  TableUtility.ArrayClear(self.lackMats)
  if self.isMax then
    self.costListCtrl:ResetDatas(datas)
    return
  end
  if self.nextStatic and self.nextStatic.ItemCost then
    local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
    local costs = {}
    for i = 1, #self.nextStatic.ItemCost do
      local cost = self.nextStatic.ItemCost[i]
      costs[#costs + 1] = {
        id = cost[1],
        num = cost[2]
      }
    end
    if self.checkBtn and self.checkBtn.value and 0 < #costs and not self.isGlobal then
      local use, has = false, false
      costs, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(costs, checkPackage)
      if not use then
        if not has then
          MsgManager.ShowMsgByID(28117)
        else
          MsgManager.ShowMsgByID(28118)
        end
        self.checkBtn.value = false
        self:RefreshCost()
        return
      end
    end
    for i = 1, #costs do
      local cost = costs[i]
      local itemData = ItemData.new(cost.id, cost.id)
      local bagNum = BagProxy.Instance:GetItemNumByStaticID(cost.id, checkPackage)
      local needNum = cost.num
      local displayNum, displayNeedNum = bagNum, needNum
      if cost.deduction then
        displayNum = bagNum + cost.ori_num - cost.num
        displayNeedNum = cost.ori_num
        itemData.deduction = cost.deduction
      end
      local isLack = bagNum < needNum
      if isLack then
        table.insert(self.lackMats, {
          id = cost.id,
          count = needNum - bagNum
        })
      end
      itemData.num = FormatCostNum(displayNum, displayNeedNum, isLack)
      datas[#datas + 1] = itemData
    end
    self.lack = #self.lackMats > 0
  end
  self.costListCtrl:ResetDatas(datas)
  if self.lack then
    self.upgradeLabel.text = ZhString.EquipUpgradePopUp_QuickBuy
  elseif self.isGlobal and self.data and 0 >= (self.data.level or 0) then
    self.upgradeLabel.text = ZhString.SnowCrown_GlobalUnlock or UnlockLabelFallback
  else
    self.upgradeLabel.text = ZhString.EquipUpgradePopUp_Upgrade
  end
end

function SnowCrownAttrTip:OnUpgradeBtnClick()
  if self.data then
    if self.lack then
      QuickBuyProxy.Instance:TryOpenView(self.lackMats)
      self:CloseTip()
      return
    end
    local nextStatic = self:GetNextStatic(self.data.id)
    if not nextStatic then
      return
    end
    if self.isGlobal then
      SnowCrownProxy.Instance:RequestGlobalActive(nextStatic.id)
    else
      ServiceSnowCmdProxy.Instance:CallSnowCrownActiveSnowCmd(nextStatic.id, self.checkBtn and self.checkBtn.value or false)
    end
  end
end

function SnowCrownAttrTip:SetDesc(data, isMax)
  if data and data.staticData then
    self.desc.text = data.level > 0 and data.staticData.Desc or ""
    self.next:SetActive(not isMax)
    local nextStatic
    if not isMax then
      nextStatic = self:GetNextStatic(data.id)
    end
    self.nextDesc.text = nextStatic and nextStatic.Desc or ""
    if self.descTrans and self.nextTrans then
      local posY = (self.descPos and self.descPos.y or 0) - self.desc.height - NextGap
      local posX = self.nextPos and self.nextPos.x or 0
      local posZ = self.nextPos and self.nextPos.z or 0
      self.nextTrans.localPosition = LuaGeometry.GetTempVector3(posX, posY, posZ)
    end
  end
end

function SnowCrownAttrTip:GetNextStatic(id)
  local nextStatic = Table_SnowCrown[id + 1]
  if nextStatic and (not nextStatic.PreID or nextStatic.PreID == id) then
    return nextStatic
  end
  return nil
end

function SnowCrownAttrTip:OnEnter()
  SnowCrownAttrTip.super.OnEnter(self)
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.HandleItemUpdate, self)
end

function SnowCrownAttrTip:HandleItemUpdate()
  if not self.data then
    return
  end
  self:RefreshCost()
end

function SnowCrownAttrTip:CloseTip()
  self:PassEvent(UIEvent.CloseUI)
end

function SnowCrownAttrTip:OnExit()
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.HandleItemUpdate, self)
  if self.callbackWhenClickOtherPlace then
    self.callbackWhenClickOtherPlace.call = nil
    self.callbackWhenClickOtherPlace = nil
  end
  self.costListCtrl:RemoveAll()
  self.costListCtrl = nil
  return SnowCrownAttrTip.super.OnExit(self)
end
