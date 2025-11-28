autoImport("TechTreeBuildingCell")
TechTreeBuildingPage = class("TechTreeBuildingPage", SubView)
local picIns
local texObjStaticNameMap = {
  Detail = "tree_bg_jianbian",
  DetailTitleBg = "Games_bg_time",
  TexBulding = "tree_bg_bulding",
  TexDiban = "tree_bg_diban"
}

function TechTreeBuildingPage:Init()
  if not picIns then
    picIns = PictureManager.Instance
  end
  self:ReLoadPerferb("view/TechTreeBuildingPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:FindObjs()
  self:InitPage()
  self:AddEvents()
end

function TechTreeBuildingPage:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.cellTable = self:FindComponent("CellTable", UITable)
  self.detailTitleIcon = self:FindComponent("DetailTitleIcon", UISprite)
  self.detailTitle = self:FindComponent("DetailTitle", UILabel)
  self.descScrollView = self:FindComponent("DescScrollView", UIScrollView)
  self.desc = self:FindComponent("Desc", UILabel)
  self.texDetail = self:FindComponent("TexDetail", UITexture)
  self.locked = self:FindGO("Locked")
  self.lockedLabel = self:FindComponent("LockedLabel", UILabel)
  self.texParent = self:FindGO("TexParent")
  self.gotoBtn = self:FindGO("GotoBtn")
end

function TechTreeBuildingPage:InitPage()
  IconManager:SetUIIcon("ThanatosT", self.detailTitleIcon)
  self.cellCtrl = ListCtrl.new(self.cellTable, TechTreeBuildingCell, "TechTreeBuildingCell")
  self.cellCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.cellCells = self.cellCtrl:GetCells()
  self.descLabel = SpriteLabel.new(self.desc, nil, 18, 20, true)
end

function TechTreeBuildingPage:AddEvents()
  self:AddListenEvt(UIMenuEvent.UnlockMenu, self.OnUnlockMenu)
  self:AddClickEvent(self.gotoBtn, function()
    if self.gotoMode then
      FuncShortCutFunc.Me():CallByID(self.gotoMode)
    end
  end)
end

local buildingListDataSortFunc = function(l, r)
  return l.Order < r.Order
end

function TechTreeBuildingPage:UpdateCells()
  local arr = ReusableTable.CreateArray()
  if Table_BuildingList then
    for _, d in pairs(Table_BuildingList) do
      TableUtility.ArrayPushBack(arr, d)
    end
  end
  table.sort(arr, buildingListDataSortFunc)
  self.cellCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray()
end

function TechTreeBuildingPage:UpdateDetail(data)
  local isUnlock = data ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID)
  self.detailTitle.text = isUnlock and data.Name or "????????"
  self.descScrollView.gameObject:SetActive(isUnlock)
  self.texParent:SetActive(isUnlock)
  self.gotoBtn:SetActive(isUnlock)
  self.locked:SetActive(not isUnlock)
  if isUnlock then
    TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(self.descLabel, data.Describe)
    self.descScrollView:ResetPosition()
    if self.texDetailName ~= data.Icon then
      self:TryUnloadTexDetail()
      self.texDetailName = data.Icon
      if self.texDetailName then
        picIns:SetUI(self.texDetailName, self.texDetail)
      end
    end
    self.gotoMode = data.GotoMode and data.GotoMode[1]
  else
    self.lockedLabel.text = data.UnlockText
  end
  for _, c in pairs(self.cellCells) do
    c:SetChooseId(data and data.id)
  end
end

function TechTreeBuildingPage:OnEnter()
  TechTreeBuildingPage.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function TechTreeBuildingPage:OnActivate()
  self:UpdateCells()
  self:OnClickCell(self.cellCells[1])
end

function TechTreeBuildingPage:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  self:TryUnloadTexDetail()
  self.cellCtrl:Destroy()
  TechTreeBuildingPage.super.OnExit(self)
end

function TechTreeBuildingPage:OnUnlockMenu()
  self:UpdateCells()
end

function TechTreeBuildingPage:OnClickCell(cell)
  if not cell or not cell.data then
    return
  end
  self:UpdateDetail(cell.data)
end

function TechTreeBuildingPage:TryUnloadTexDetail()
  if self.texDetailName then
    picIns:UnLoadUI(self.texDetailName, self.texDetail)
  end
end
