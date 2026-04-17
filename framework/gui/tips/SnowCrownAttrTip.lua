autoImport("BaseTip")
autoImport("SnowCrownCostItemCell")
SnowCrownAttrTip = class("SnowCrownAttrTip", BaseTip)
local NextGap = 34
local TextColorRed = "[c][FF3B35]"
local DefaultBottomBgY, LongBottomBgY = -107, -253

function SnowCrownAttrTip:Init()
  self:FindObjs()
  self.lackMats = {}
end

function SnowCrownAttrTip:FindObjs()
  self.callbackWhenClickOtherPlace = self:FindComponent("Bg", CallBackWhenClickOtherPlace)
  
  function self.callbackWhenClickOtherPlace.call()
    self:CloseTip()
  end
  
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
end

function SnowCrownAttrTip:SetData(data)
  self.data = data
  if data and data.staticData then
    self.icon.spriteName = data.staticData.Icon
    self.name.text = data.staticData.Name
    local maxLevel = Game.SnowCrownGroupMaxLevel[data.id // 100]
    local isMax = maxLevel ~= nil and maxLevel <= data.level or false
    self.level.text = isMax and ZhString.SnowCrown_MaxLevel or "Lv." .. data.level
    self:SetDesc(data, isMax)
    local datas = {}
    local nextStatic = self:GetNextStatic(data.id)
    self.lack = false
    TableUtility.ArrayClear(self.lackMats)
    if nextStatic and nextStatic.ItemCost then
      local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
      for i = 1, #nextStatic.ItemCost do
        local cost = nextStatic.ItemCost[i]
        local itemData = ItemData.new(cost[1], cost[1])
        local bagNum = BagProxy.Instance:GetItemNumByStaticID(cost[1], checkPackage)
        local colorStr = bagNum >= cost[2] and "" or TextColorRed
        if bagNum < cost[2] then
          table.insert(self.lackMats, {
            id = cost[1],
            count = cost[2]
          })
        end
        itemData.num = colorStr .. bagNum .. "[-][/c]/" .. cost[2]
        datas[#datas + 1] = itemData
      end
      self.lack = #self.lackMats > 0
    end
    self.costListCtrl:ResetDatas(datas)
    self.upgradeBtn:SetActive(not isMax)
    self.upgradeLabel.text = self.lack and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipUpgradePopUp_Upgrade
    self.maxLv:SetActive(isMax)
    self.costPart:SetActive(not isMax)
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.bottomBg)
    y = isMax and LongBottomBgY or DefaultBottomBgY
    LuaGameObject.SetLocalPositionGO(self.bottomBg, x, y, z)
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
    ServiceSnowCmdProxy.Instance:CallSnowCrownActiveSnowCmd(nextStatic.id)
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

function SnowCrownAttrTip:CloseTip()
  self:PassEvent(UIEvent.CloseUI)
end

function SnowCrownAttrTip:OnExit()
  if self.callbackWhenClickOtherPlace then
    self.callbackWhenClickOtherPlace.call = nil
    self.callbackWhenClickOtherPlace = nil
  end
  self.costListCtrl:RemoveAll()
  self.costListCtrl = nil
  return SnowCrownAttrTip.super.OnExit(self)
end
