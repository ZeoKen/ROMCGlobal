BanCardPopup = class("BanCardPopup", BaseView)
BanCardPopup.ViewType = UIViewType.CheckLayer
autoImport("BanCardChooseCell")

function BanCardPopup:Init()
  self:FindObjs()
  self:InitData()
  self:UpdateView()
end

function BanCardPopup:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  local closeBtnGO = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtnGO, function()
    self:CloseSelf()
  end)
  local container = self:FindGO("CardContainer")
  self.cardListCtl = WrapListCtrl.new(container, BanCardChooseCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 10, 100)
  self.cardListCtl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.cardListCtl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.filterBtn = self:FindGO("FilterBtn")
  self.filterBtnSp = self.filterBtn:GetComponent(UISprite)
  self:InitFilter()
end

function BanCardPopup:InitFilter()
  local filters = self:GetFilters()
  self.filterTipData = {
    callback = self.FilterPropCallback,
    param = self,
    curCustomProps = nil,
    curPropData = nil,
    curKeys = nil,
    customTitle = ZhString.CardMake_PartTitle,
    customProps = filters
  }
  self:AddClickEvent(self.filterBtn, function()
    TipManager.Instance:ShowNewPropTypeTip(self.filterTipData, self.filterBtnSp, NGUIUtil.AnchorSide.AnchorSide, {90, -50})
  end)
end

function BanCardPopup:GetFilters()
  return GameConfig.CardMake.MakeFilter
end

function BanCardPopup:FilterPropCallback(customProp, propData, keys)
  if self.filterTipData then
    self.filterTipData.curCustomProps = customProp
    self.filterTipData.curPropData = propData
    self.filterTipData.curKeys = keys
  end
  self:UpdateView()
end

function BanCardPopup:InitData()
  self.callback = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.callback
  self.callbackParam = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.callbackParam
  self.chosenList = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.chosenList or {}
end

function BanCardPopup:OnCellClicked(cell)
  local id = cell.data and cell.data.staticData and cell.data.staticData.id
  if cell.data and not cell.data.isBan and #self.chosenList >= 6 then
    MsgManager.FloatMsg("", ZhString.BanCard_ReachMax)
    return
  end
  if self.callback then
    xdlog("执行callback")
    self.callback(self.callbackParam, id)
  end
  cell.data.isBan = not cell.data.isBan
  cell:SetData(cell.data)
  self.title.text = string.format(ZhString.BanCard_TitleAndCount, #self.chosenList, 6)
end

function BanCardPopup:UpdateView()
  local cardList = {}
  for _id, _info in pairs(Table_Card) do
    if _info.SelectToForbid and Table_Item[_id] then
      local itemData = ItemData.new("Card", _id)
      local isBan = TableUtility.ArrayFindIndex(self.chosenList, _id) > 0
      itemData.isBan = isBan
      table.insert(cardList, itemData)
    end
  end
  local filterTypeList = {}
  filterTypeList = self:FilterByTypes(self.filterTipData.curCustomProps, cardList, filterTypeList)
  local cardShowList = AdventureDataProxy.Instance:getItemsByFilterData(nil, filterTypeList, self.filterTipData.curPropData, self.filterTipData.curKeys)
  self.cardListCtl:ResetDatas(cardShowList, true)
  self.title.text = string.format(ZhString.BanCard_TitleAndCount, #self.chosenList, 6)
end

function BanCardPopup:FilterByTypes(types, list, filterList)
  TableUtility.ArrayClear(filterList)
  if not types or #types == 0 then
    for i = 1, #list do
      local d = list[i]
      TableUtility.ArrayPushBack(filterList, d)
    end
  else
    for i = 1, #list do
      local data = list[i]
      if 0 < TableUtility.ArrayFindIndex(types, data.staticData.Type) then
        TableUtility.ArrayPushBack(filterList, data)
      end
    end
  end
  return filterList
end

function BanCardPopup:OnSelectLongPress(cell)
  local data = cell.data
  if data then
    local isBan = TableUtility.ArrayFindIndex(self.chosenList, data.staticData.id) > 0
    local tipData = {}
    tipData.itemdata = data
    tipData.customFuncConfig = {
      name = isBan and ZhString.PvpCustomRoom_UnBanCard or ZhString.PvpCustomRoom_BanCard,
      btnStyle = isBan and 2 or 1,
      callback = function()
        self:OnCellClicked(cell)
      end
    }
    self:ShowItemTip(tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
