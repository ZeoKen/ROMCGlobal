autoImport("HappyShop")
autoImport("ItemTipGemExhibitCell")
GemShopView = class("GemShopView", HappyShop)

function GemShopView:AddViewEvts()
  GemShopView.super.AddViewEvts(self)
  self:AddListenEvt(ServiceEvent.ItemGemDataUpdateItemCmd, self.OnGemDataUpdate)
end

function GemShopView:InitUI()
  GemShopView.super.InitUI(self)
  if self.specialRoot then
    self.specialRoot:SetActive(false)
  end
  if self.skipBtn then
    self.skipBtn.gameObject:SetActive(false)
  end
  if self.toggleRoot then
    self.toggleRoot:SetActive(false)
  end
  if self.showtoggle then
    self.showtoggle:SetActive(false)
  end
  if self.servantExp then
    self.servantExp:SetActive(false)
  end
  if self.customToggleRoot then
    self.customToggleRoot:SetActive(false)
  end
  if self.searchToggle then
    self.searchToggle:SetActive(false)
  end
  self.panel = self.gameObject:GetComponent(UIPanel)
  self:TryInitFilterPopOfView("SkillProfessionFilterPop", function()
    self:UpdateShopInfo(true)
  end, GemSkillProfessionFilter, GemSkillProfessionFilterData)
  GemProxy.TryRemoveBannedProfessionsFromFilter(self.SkillProfessionFilterPop)
  self.SkillProfessionFilterPop.gameObject:SetActive(true)
  self.LeftStick.alpha = 1
end

function GemShopView:UpdateShopInfo(isReset)
  self.shopInfoDatas = self.shopInfoDatas or {}
  TableUtility.ArrayClear(self.shopInfoDatas)
  local shopItems, shopItem, item = HappyShopProxy.Instance:GetShopItems()
  local p = self.curSkillProfessionFilterPopData
  local isProfessionFilterExist = p and type(p) == "table" and next(p)
  for i = 1, #shopItems do
    shopItem = HappyShopProxy.Instance:GetShopItemDataByTypeId(shopItems[i])
    item = shopItem:GetItemData()
    if not isProfessionFilterExist or GemProxy.Instance:CheckIfSkillGemHasSameProfessions(item.staticData.id, p) then
      TableUtility.ArrayPushBack(self.shopInfoDatas, shopItems[i])
    end
  end
  self:NeedUpdateSold(self.shopInfoDatas)
  local wrap = self:GetWrapHelper()
  wrap:UpdateInfo(self.shopInfoDatas)
  HappyShopProxy.Instance:SetSelectId()
  if isReset == true then
    wrap:ResetPosition()
  end
end

function GemShopView:ShowHappyItemTip(data)
  if not data.goodsID then
    return
  end
  local item = data:GetItemData()
  local sData = item and Table_GemRate[item.staticData.id]
  if not sData then
    return
  end
  if self.gemExhibitTip then
    self.gemExhibitTip:SetActive(true)
  else
    self.gemExhibitTip = ItemTipGemExhibitCell.new(self.LeftStick.gameObject)
    local wrap = self:GetWrapHelper()
    local cells = wrap:GetCellCtls()
    for _, cell in pairs(cells) do
      self.gemExhibitTip:AddCloseCompTarget(cell)
    end
    self.gemExhibitTip.attriScrollView.panel.depth = self.panel.depth + 10
  end
  self.gemExhibitTip:SetData(sData)
end

function GemShopView:HandleClickItem(cellCtl)
  GemShopView.super.HandleClickItem(self, cellCtl)
  if self.gemExhibitTip then
    self.gemExhibitTip:SetActive(false)
  end
end

function GemShopView:OnGemDataUpdate(note)
  TipManager.CloseTip()
  GemProxy.Instance:ShowNewGemResults(note.body and note.body.items)
end

function GemShopView:OnExit()
  if self.gemExhibitTip then
    GameObject.Destroy(self.gemExhibitTip.gameObject)
    self.gemExhibitTip = nil
  end
  GemShopView.super.OnExit(self)
end
