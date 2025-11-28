autoImport("ComodoBuildingSubPage")
autoImport("ComodoBuildingSmithingListCell")
ComodoBuildingSmithingPage = class("ComodoBuildingSmithingPage", ComodoBuildingSubPage)
local productMap

function ComodoBuildingSmithingPage:InitPage()
  ComodoBuildingSmithingPage.super.InitPage(self)
  self.x2grid = self:FindComponent("SmithingGridX2", UIGrid)
  self.x2SmithingCtl = ListCtrl.new(self.x2grid, ComodoBuildingSmithingListCell, "ComodoBuildingSmithingListCellX2")
  self.x2SmithingCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.x2SmithingCtl:AddEventListener(HappyShopEvent.SelectIconSprite, self.OnClickMatCell, self)
  if not productMap then
    productMap = {}
    for _, list in pairs(GameConfig.Manor.ManorForgeProduce) do
      for _, id in pairs(list) do
        productMap[id] = true
      end
    end
  end
end

function ComodoBuildingSmithingPage:AddEvents()
  ComodoBuildingSmithingPage.super.AddEvents(self)
  self:AddListenEvt(ServiceEvent.SceneManorBuildForgeManorCmd, self.OnSmithing)
end

function ComodoBuildingSmithingPage:OnEnter()
  ComodoBuildingSmithingPage.super.OnEnter(self)
  self:UpdateSmithingCtl()
end

function ComodoBuildingSmithingPage:OnQuery()
  self:UpdateSmithingCtl()
end

function ComodoBuildingSmithingPage:OnLevelUp()
  self:UpdateSmithingCtl()
end

function ComodoBuildingSmithingPage:OnItemUpdate()
  self:UpdateSmithingCtl()
  if self.snapshot then
    local nowSnapshot, item = ReusableTable.CreateTable()
    self:MakeSnapshot(nowSnapshot)
    for id, num in pairs(nowSnapshot) do
      if self.snapshot[id] ~= num then
        item = BagProxy.Instance:GetItemByGuid(id)
        break
      end
    end
    ReusableTable.DestroyAndClearTable(nowSnapshot)
    self:TryShowSmithingProduct(item)
  end
end

function ComodoBuildingSmithingPage:OnSmithing()
  self:UpdateSmithingCtl()
end

function ComodoBuildingSmithingPage:OnClickListCell(cell)
  self.snapshot = self.snapshot or {}
  self:MakeSnapshot(self.snapshot)
  self.targetStick = cell.getBg
end

local tipOffset = {-250, 80}

function ComodoBuildingSmithingPage:OnClickMatCell(matCell)
  self.tipData.noSelfClose = nil
  self:ShowItemTip(matCell.data, matCell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

function ComodoBuildingSmithingPage:UpdateSmithingCtl()
  self.x2SmithingCtl:ResetDatas(ComodoBuildingProxy.Instance.smithingPartIdList)
end

function ComodoBuildingSmithingPage:TryShowSmithingProduct(item)
  if not self.targetStick then
    LogUtility.Warning("Cannot find target stick. The item tip will not be shown.")
    return
  end
  if not self.tipData.customFuncConfig then
    self.tipData.customFuncConfig = {
      name = ZhString.ComodoBuilding_SmithingPutIn,
      callback = function()
      end
    }
  end
  self.tipData.noSelfClose = true
  self:ShowItemTip(item, self.targetStick, NGUIUtil.AnchorSide.Left, tipOffset)
  self.targetStick = nil
end

function ComodoBuildingSmithingPage:MakeSnapshot(tab)
  TableUtility.TableClear(tab)
  for id, _ in pairs(productMap) do
    self:MakeSnapshotByStaticId(tab, id)
  end
end

function ComodoBuildingSmithingPage:MakeSnapshotByStaticId(tab, sId)
  if not sId then
    return
  end
  local check, items, id, num = GameConfig.PackageMaterialCheck.Exist
  for i = 1, #check do
    items = BagProxy.Instance:GetItemsByStaticID(sId, check[i])
    if items then
      for j = 1, #items do
        id, num = items[j].id, items[j].num
        tab[id] = (tab[id] or 0) + num
      end
    end
  end
end
