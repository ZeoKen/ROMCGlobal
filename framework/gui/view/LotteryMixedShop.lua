local _LotteryFunc
local _Path = "GUI/v1/part/LotteryMixedShop"
local _PackageCheck = GameConfig.PackageMaterialCheck.default
local _ReverseGenderMap = {
  [1] = 2,
  [2] = 1
}
local _GenderIcon = {
  [1] = "mall_twistedegg_btn_boy",
  [2] = "mall_twistedegg_btn_girl"
}
local _Epsilon = 90
autoImport("MixShopFilterPopup")
autoImport("MixShopCell")
autoImport("LotterySuitCell")
autoImport("MixShopTip")
LotteryMixedShop = class("LotteryMixedShop", SubView)

function LotteryMixedShop:CreateSelf()
  local container = self:FindGO("MixShopRoot")
  local obj = self:LoadPreferb_ByFullPath(_Path, container, true)
  obj.name = "LotteryMixedShop"
  self.gameObject = obj
end

function LotteryMixedShop:Init(lotteryMix)
  self.top_goods = nil
  self.lotteryMix = lotteryMix
  _LotteryFunc = FunctionLottery.Me()
  self:CreateSelf()
  self:FindObjs()
  self:AddViewEvts()
  self:AddEvts()
  self.originalGender = MyselfProxy.Instance:GetMySex()
end

function LotteryMixedShop:SetSeries()
  if not self.top_goods then
    return
  end
  local goods_id = self.top_goods.goodsID
  local _config = goods_id and Table_HeadwearRepair[goods_id]
  if not _config then
    self.shopTimeLab.text = ""
    self.seriesName.text = ""
  end
  self.shopTimeLab.text = self.top_goods:GetShopTimeDisplay()
  self.seriesName.text = _config.SeriesName
  local year = self.top_goods:CheckPurchaseInvalid() and LotteryProxy.Invalid_Year or self.top_goods.shop_year
  if self.topYear ~= year then
    self.topYear = year
    self.filterPopup:SetYear(year)
  end
end

function LotteryMixedShop:OnMoment()
  local cells = self.shopHelper:GetCellCtls()
  if cells and 0 < #cells then
    local offset_y = self.shopHelper.panel.clipOffset.y
    for i = 1, #cells do
      if math.abs(cells[i].trans.localPosition.y - offset_y) < _Epsilon and self.top_goods ~= cells[i].data then
        self.top_goods = cells[i].data
        self:SetSeries()
        break
      end
    end
  end
end

function LotteryMixedShop:GetRowIndexByYear()
  local index, goodsID, data
  if self.manualChooseYear then
    for i = #self.shopHelper.datas, 1, -1 do
      data = self.shopHelper.datas[i]
      if self.manualChooseYear == LotteryProxy.Invalid_Year then
        if data:CheckPurchaseInvalid() then
          return i, data.goodsID
        end
      elseif not data:CheckPurchaseInvalid() and data.shop_year == self.manualChooseYear then
        return i, data.goodsID
      end
    end
  else
    for i = 1, #self.shopHelper.datas do
      data = self.shopHelper.datas[i]
      if self.chooseYear == LotteryProxy.Invalid_Year then
        if data:CheckPurchaseInvalid() then
          return i, data.goodsID
        end
      elseif not data:CheckPurchaseInvalid() and data.shop_year == self.chooseYear then
        return i, data.goodsID
      end
    end
  end
end

function LotteryMixedShop:GetInitializedRowIndex()
  if not self.shopHelper then
    return
  end
  local data
  for i = 1, #self.shopHelper.datas do
    data = self.shopHelper.datas[i]
    if not data:CheckPurchaseInvalid() then
      return i, data.goodsID
    end
  end
end

function LotteryMixedShop:OnClickShopItemCell(cell)
  if self.goods_id == cell.data.goodsID or not _LotteryFunc:CheckEquipInPreview(cell.data.goodsID) then
    self.container:ClickCell(cell)
  end
  self:UpdateDressLab()
  self:OnChooseShopItemCell(cell)
end

function LotteryMixedShop:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotteryMixedShop:FindObjs()
  self.emptyRoot = self:FindGO("Empty_MixShop")
  self.emptyLab = self:FindComponent("Label", UILabel, self.emptyRoot)
  self.emptyLab.text = ZhString.Lottery_MixShop_Empty
  self.shopTimeLab = self:FindComponent("ShopTimeLab", UILabel)
  self.seriesName = self:FindComponent("SeriesNameLab", UILabel)
  self.buyBtn = self:FindComponent("BuyBtn", UISprite)
  self.buyLab = self:FindComponent("Lab", UILabel, self.buyBtn.gameObject)
  self.buyLab.text = ZhString.Lottery_MixShop_Buy
  self.shopContainer = self:FindGO("ShopContainer")
  local wrapConfig = {
    wrapObj = self.shopContainer,
    pfbNum = 7,
    cellName = "MixShopCell",
    control = MixShopCell,
    eventWhenUpdate = self.OnMoment,
    eventWhenUpdateParam = self
  }
  self.shopHelper = WrapCellHelper.new(wrapConfig)
  self.shopHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.shopHelper:AddEventListener(LotteryCell.ClickEvent, self.OnClickShopItemCell, self)
  self.shopPanel = self:FindComponent("ShopScrollView", UIPanel)
  self.suitRoot = self:FindGO("SuitRoot")
  self.suit_grid = self:FindComponent("SuitGrid", UIGrid, self.suitRoot)
  self.suitCtl = UIGridListCtrl.new(self.suit_grid, LotterySuitCell, "LotterySuitCell")
  self.suitCtl:AddEventListener(MouseEvent.MouseClick, self.OnChooseSuitItemCell, self)
  self.suitBg = self:FindComponent("SuitBg", UISprite, self.suitRoot)
  self.genderBtn = self:FindComponent("GenderBtn", UISprite, self.suitRoot)
  self.maleSp = self:FindComponent("Male", UISprite, self.genderBtn.gameObject)
  self.femaleSp = self:FindComponent("Female", UISprite, self.genderBtn.gameObject)
  self.mappingMaleSp = self:FindComponent("MappingMale", UISprite, self.genderBtn.gameObject)
  self.mappingFemaleSp = self:FindComponent("MappingFemale", UISprite, self.genderBtn.gameObject)
  self.invalidLab = self:FindComponent("InvalidLab", UILabel)
  self.invalidLab.text = ZhString.Lottery_MixShop_InvalidGender
  self:Hide(self.invalidLab)
  local filterRoot = self:FindGO("FilterRoot")
  self.filterPopup = self:AddSubView("MixShopFilterPopup", MixShopFilterPopup, filterRoot)
  self.filterPopup:Hide()
  self.filterBtn = self:FindGO("FilterBtn")
  self:AddClickEvent(self.filterBtn, function()
    if self.filterPopup.gameObject.activeSelf then
      self.filterPopup:Hide()
    else
      self.filterPopup:Show()
      self.filterPopup:OnShow()
    end
  end)
  self.shop_ToLotteryBtn = self:FindGO("ToLotteryBtn")
  self:AddClickEvent(self.shop_ToLotteryBtn, function()
    self.lotteryMix:ToLottery()
  end)
end

function LotteryMixedShop:SetGenderForbidden(var)
  if not self.suitCtl then
    return
  end
  local cells = self.suitCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetForbidden(var)
  end
end

local const_V3_zero = LuaGeometry.Const_V3_zero
local const_V3_one = LuaGeometry.Const_V3_one

function LotteryMixedShop:ResetDatas(data, layout)
  local isEmpty = LotteryProxy.Instance.allGot and self.filterPopup.noGotTogValue
  isEmpty = isEmpty or #data == 0
  if isEmpty then
    self:Hide(self.shopContainer)
    self:Hide(self.shopTimeLab)
    self:Hide(self.seriesName)
    self.buyBtn.transform.localScale = const_V3_zero
    self.suitRoot.transform.localScale = const_V3_zero
    self.invalidLab.gameObject.transform.localScale = const_V3_zero
  else
    self:Show(self.shopContainer)
    self:Show(self.shopTimeLab)
    self:Show(self.seriesName)
    self.buyBtn.transform.localScale = const_V3_one
    self.suitRoot.transform.localScale = const_V3_one
    self.invalidLab.gameObject.transform.localScale = const_V3_one
    self.shopHelper:ResetDatas(data, layout)
  end
  if layout then
    if isEmpty then
      self:Show(self.emptyRoot)
    else
      self:Hide(self.emptyRoot)
      local row, goodsID
      if self.chooseYear then
        row, goodsID = self:GetRowIndexByYear()
      else
        row, goodsID = self:GetInitializedRowIndex()
      end
      if not row then
        return
      end
      self.shopHelper:SetStartPositionByIndex(row)
      if self.firstGoodsID == goodsID then
        return
      end
      self.firstGoodsID = goodsID
      self:SelectFirst(goodsID)
    end
  else
    self:HandleMixShopPurchase()
  end
end

function LotteryMixedShop:_resetSuits()
  self:Hide(self.suitRoot)
  self.goods_gender = nil
  self.suitCtl:RemoveAll()
  self.suitCtl:Layout()
end

function LotteryMixedShop:TryResetSuits()
  if not self.group_id then
    self:_resetSuits()
    return
  end
  self.goods_gender = MyselfProxy.Instance:GetMySex()
  local data = LotteryProxy.Instance:GetGoodsByGender(self.group_id, self.goods_gender)
  if not data or nil == next(data) then
    self.goods_gender = _ReverseGenderMap[self.goods_gender]
    data = LotteryProxy.Instance:GetGoodsByGender(self.group_id, self.goods_gender)
    if not data or nil == next(data) or #data == 1 then
      self:_resetSuits()
      return
    end
  end
  self.suitBg.height = self.needShowGender and 511 or 411
  self:Show(self.suitRoot)
  self.suitCtl:RemoveAll()
  self.suitCtl:ResetDatas(data)
  if self.needShowGender then
    self:Show(self.genderBtn)
    self:UpdateGenderBtn()
  else
    self:Hide(self.genderBtn)
    self:SetGenderForbidden(false)
  end
end

function LotteryMixedShop:AddEvts()
  self:AddClickEvent(self.buyBtn.gameObject, function()
    self:DoBuy()
  end)
  self:AddClickEvent(self.genderBtn.gameObject, function()
    self:OnClickGenderBtn()
  end)
end

function LotteryMixedShop:UpdateGenderBtn()
  if not self.goods_gender then
    self.gender_invalid = false
    self:SetGenderForbidden(self.gender_invalid)
    return
  end
  local isMale = self.goods_gender == ProtoCommon_pb.EGENDER_MALE
  self.genderBtn.spriteName = _GenderIcon[self.goods_gender]
  if isMale then
    self:Show(self.maleSp)
    self:Show(self.mappingFemaleSp)
    self:Hide(self.femaleSp)
    self:Hide(self.mappingMaleSp)
  else
    self:Hide(self.maleSp)
    self:Hide(self.mappingFemaleSp)
    self:Show(self.femaleSp)
    self:Show(self.mappingMaleSp)
  end
  self.gender_invalid = not isMale and self.originalGender == ProtoCommon_pb.EGENDER_MALE
  self:SetGenderForbidden(self.gender_invalid)
end

function LotteryMixedShop:UpdateInvalidLab()
  if not self.data then
    return
  end
  if self.data:CheckPurchaseInvalid() then
    self:Show(self.invalidLab)
    local date = self.data.in_shop_date
    self.invalidLab.text = string.format(ZhString.Lottery_MixShop_InvalidTime, date.month, date.day)
    return
  end
  if self.gender_invalid then
    self:Show(self.invalidLab)
    self.invalidLab.text = ZhString.Lottery_MixShop_InvalidGender
  else
    self:Hide(self.invalidLab)
  end
end

function LotteryMixedShop:OnClickGenderBtn()
  local _gender = _ReverseGenderMap[self.goods_gender]
  local data = LotteryProxy.Instance:GetGoodsByGender(self.group_id, _gender)
  if not data or nil == next(data) then
    return
  end
  self.goods_gender = _gender
  self.suitCtl:ResetDatas(data)
  self:UpdateGenderBtn()
  self:UpdateInvalidLab()
  self:ChooseSuitItem()
end

function LotteryMixedShop:DoBuy()
  if not self.data then
    return
  end
  if self.data:CheckPurchaseInvalid() then
    local str = self.data:GetPurchaseShopTimeStr()
    str = string.format(ZhString.Lottery_SellTimeInvalid, str)
    MsgManager.FloatMsgTableParam(nil, str)
    return
  end
  if self.lack then
    MsgManager.ShowMsgByID(10154)
    return
  end
  TipManager.Instance:ShowMixShopTip(self.data)
end

function LotteryMixedShop:AddViewEvts()
  self:AddDispatcherEvt(LotteryEvent.MixShopSiteChanged, self.HandleSiteChanged, self)
  self:AddDispatcherEvt(LotteryEvent.MixShopYearChanged, self.HandleYearChanged, self)
  self:AddDispatcherEvt(LotteryEvent.MixShopTogChanged, self.HandleTogChanged, self)
  self:AddDispatcherEvt(LotteryEvent.MixShopYearManualChanged, self.HandleManualYearChanged, self)
end

function LotteryMixedShop:HandleSiteChanged(note)
  self.chooseSite = note.data
  self.manualChooseYear = nil
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopFilterChanged)
end

function LotteryMixedShop:ResetFilter()
  self.chooseYear = nil
  self.manualChooseYear = nil
  self.chooseSite = nil
  self.filterPopup:ResetFilter()
  self.filterPopup:Hide()
end

function LotteryMixedShop:HandleTogChanged(note)
  self.manualChooseYear = nil
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopFilterChanged)
end

function LotteryMixedShop:HandleYearChanged(note)
  self.chooseYear = note.data
  self.manualChooseYear = nil
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopFilterChanged)
end

function LotteryMixedShop:HandleManualYearChanged(note)
  local data = note.data
  self.chooseYear = data[1]
  self.manualChooseYear = data[2]
  self.chooseSite = data[3]
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopFilterChanged)
end

function LotteryMixedShop:HandleMixShopPurchase()
  self:RefreshBtn()
  self.chooseShopItemCell:UpdateGotFlag()
  self:UpdateSuitGot()
  LotteryProxy.Instance:ResetMixShopData()
  self.shopTimeLab.text = self.top_goods:GetShopTimeDisplay()
  self.filterPopup:OnShow()
end

function LotteryMixedShop:RefreshBtn()
  if not self.data then
    return
  end
  if not self.goods_price then
    self:Hide(self.buyBtn)
    return
  end
  self:Show(self.buyBtn)
  local cost_id = _LotteryFunc:GetMixLotteryShopCostID()
  local own_count = BagProxy.Instance:GetItemNumByStaticID(cost_id, _PackageCheck)
  self.lack = own_count < self.goods_price
  if self.lack or self.data:CheckPurchaseInvalid() then
    self.buyBtn.spriteName = "new-com_btn_a_gray"
    self.buyLab.effectColor = LuaGeometry.GetTempVector4(0.25098039215686274, 0.26666666666666666, 0.2980392156862745, 1)
  else
    self.buyBtn.spriteName = "new-com_btn_c"
    self.buyLab.effectColor = LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1)
  end
end

function LotteryMixedShop:SelectFirst(goodsID)
  local cells = self.shopHelper:GetCellCtls()
  local index = 1
  if goodsID then
    for i = 1, #cells do
      if cells[i].data.goodsID == goodsID then
        index = i
        break
      end
    end
  end
  local first = cells[index]
  if first then
    self:OnChooseShopItemCell(first)
    self.container:ClickCell(first)
    local mapping_head = LotteryProxy.Instance:GetHeadByFashion(first.data)
    if mapping_head then
      local celldata
      for i = 1, #cells do
        celldata = cells[i].data
        if celldata and celldata.goodsID == mapping_head then
          self.container:ClickCell(cells[i])
          break
        end
      end
    end
    self:UpdateDressLab()
    self.top_goods = first.data
    self:SetSeries()
  end
end

function LotteryMixedShop:SetChooseID(id)
  local cells = self.shopHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:SetChoose(id)
  end
end

function LotteryMixedShop:UpdateDressLab()
  local cells = self.shopHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:UpdateDressLab()
  end
end

function LotteryMixedShop:OnChooseShopItemCell(cellCtl)
  self.chooseShopItemCell = cellCtl
  self:UpdateView(self.chooseShopItemCell.data)
end

function LotteryMixedShop:UpdateView(data, group_choose)
  local id = data and data.goodsID
  if not id then
    return
  end
  self:SetChooseID(id)
  self.group_id = data.group_id
  self.goods_id = id
  self.goods_price = _LotteryFunc:GetPrice(id)
  self.data = data
  self.needShowGender = self.data.headwearType == LotteryHeadwearType.Fashion and not _LotteryFunc:IsIgnoreGender(self.group_id)
  _LotteryFunc:SetCurMixShopGoods(data)
  self:RefreshBtn()
  if not group_choose then
    self:TryResetSuits()
  end
  self:ChooseSuitItem()
  self:UpdateInvalidLab()
end

function LotteryMixedShop:OnChooseSuitItemCell(cellCtl)
  local data = cellCtl.data
  if not data then
    return
  end
  if not self.gender_invalid then
    self.container:ClickDressID(cellCtl.data.itemid)
  end
  self:UpdateView(data, true)
  if self.chooseShopItemCell and self.chooseShopItemCell.data.group_id == self.group_id then
    self.chooseShopItemCell:SetData(data, true)
  end
end

function LotteryMixedShop:ChooseSuitItem()
  if not self.goods_gender then
    return
  end
  local cells = self.suitCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.goods_id)
  end
end

function LotteryMixedShop:UpdateSuitGot()
  local cells = self.suitCtl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:UpdateGotFlag()
    end
  end
end

function LotteryMixedShop:OnExit()
  _LotteryFunc:ResetMixShopPurchase()
  if self.shopTip then
    self.shopTip:OnExit()
    self.shopTip = nil
  end
  if self.shopHelper then
    self.shopHelper:Destroy()
  end
  if self.suitCtl then
    self.suitCtl:RemoveAll()
  end
  LotteryMixedShop.super.OnExit(self)
end
