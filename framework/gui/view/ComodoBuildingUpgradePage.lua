autoImport("ComodoBuildingSubPage")
autoImport("ComodoBuildingUpgradeListCell")
ComodoBuildingUpgradePage = class("ComodoBuildingUpgradePage", ComodoBuildingSubPage)

function ComodoBuildingUpgradePage:InitPage()
  ComodoBuildingUpgradePage.super.InitPage(self)
  self.x2grid = self:FindComponent("UpgradeGridX2", UIGrid)
  self.x3grid = self:FindComponent("UpgradeGridX3", UIGrid)
  self.x2UpgradeCtl = ListCtrl.new(self.x2grid, ComodoBuildingUpgradeListCell, "ComodoBuildingUpgradeListCellX2")
  self.x2UpgradeCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMat, self)
  self.x3UpgradeCtl = ListCtrl.new(self.x3grid, ComodoBuildingUpgradeListCell, "ComodoBuildingUpgradeListCellX3")
  self.x3UpgradeCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMat, self)
end

function ComodoBuildingUpgradePage:OnActivate()
  ComodoBuildingUpgradePage.super.OnActivate(self)
  self:UpdateUpgradeCtl()
end

function ComodoBuildingUpgradePage:OnQuery()
  self:UpdateUpgradeCtl()
end

function ComodoBuildingUpgradePage:OnLevelUp()
  self:UpdateUpgradeCtl()
  MsgManager.FloatMsg(nil, ZhString.ComodoBuilding_UpgradeSuccessful)
end

function ComodoBuildingUpgradePage:OnItemUpdate()
  self:UpdateUpgradeCtl()
end

local tipOffset = {-250, 80}

function ComodoBuildingUpgradePage:OnClickMat(matCell)
  self:ShowItemTip(matCell.data, matCell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

local upgradeDataSortFunc = function(l, r)
  return l.funcType < r.funcType
end

function ComodoBuildingUpgradePage:UpdateUpgradeCtl()
  local datas = ReusableTable.CreateArray()
  local sData = self.proxyIns:GetStaticData(self.buildingId)
  if sData then
    local hideTypes = GameConfig.Manor.NoVisibleFuncType
    for key, data in pairs(sData) do
      if type(key) == "number" and TableUtility.ArrayFindIndex(hideTypes, key) == 0 then
        TableUtility.ArrayPushBack(datas, data)
      end
    end
    table.sort(datas, upgradeDataSortFunc)
    local flag = 3 <= #datas
    self.x2grid.gameObject:SetActive(not flag)
    self.x3grid.gameObject:SetActive(flag)
    local upgradeCtl = flag and self.x3UpgradeCtl or self.x2UpgradeCtl
    upgradeCtl:ResetDatas(datas)
    for _, c in pairs(upgradeCtl:GetCells()) do
      c:SetWidthOfAttrLabel(flag and 120 or 160)
    end
  else
    LogUtility.WarningFormat("Cannot get static data of building {0}!", self.buildingId)
  end
  ReusableTable.DestroyAndClearArray(datas)
end
