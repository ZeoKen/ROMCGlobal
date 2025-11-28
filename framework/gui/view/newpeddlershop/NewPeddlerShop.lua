autoImport("NewPeddlerShopItemCell")
autoImport("NewPeddlerShopBuyTips")
autoImport("NewPeddlerShopBuyGiftTips")
autoImport("NewPeddlerShopWrapListCtrl")
NewPeddlerShop = class("NewPeddlerShop", ContainerView)
NewPeddlerShop.ViewType = UIViewType.NormalLayer
local Tex_Bg = "mall_twistedegg_bg_bottom"
local Tex_Bg_1 = "Mysterious-Merchant_bg_00"
local Tex_Bg_2 = "Mysterious-Merchant_bg_pattern"
local Tex_Name_Bg = "Mysterious-Merchant_bg_title2"

function NewPeddlerShop:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:LoadTips()
end

function NewPeddlerShop:FindObjs()
  self.m_uiTexBg = self:FindGO("uiTexBg"):GetComponent(UITexture)
  self.m_uiTexBg1 = self:FindGO("uiTexBg1"):GetComponent(UITexture)
  self.m_uiTexBg2 = self:FindGO("uiTexBg2"):GetComponent(UITexture)
  self.m_uiTexBg3 = self:FindGO("uiTexBg3"):GetComponent(UITexture)
  self.m_uiTexNameBg = self:FindGO("uiTexNameBg"):GetComponent(UITexture)
  self.m_uiTxtName = self:FindGO("uiTexNameBg/uiTxtName"):GetComponent(UILabel)
  self.m_uiTxtLimitTime = self:FindGO("uiTexNameBg/uiTxtLimitTime"):GetComponent(UILabel)
  self.m_uiImgBtnQuestion = self:FindGO("uiImgBtnQuestion")
  self.m_uiImgBtnClose = self:FindGO("uiImgBtnClose")
  self.m_uiScrollView = self:FindGO("uiScrollView"):GetComponent(UIScrollView)
  local goGrid = self:FindGO("uiScrollView/Grid")
  self.m_gridListCtrl = NewPeddlerShopWrapListCtrl.new(goGrid, NewPeddlerShopItemCell, "NewPeddlerShopItemCell", WrapListCtrl_Dir.Horizontal)
  self.m_gridListCtrl:AddEventListener(MouseEvent.MouseClick, self.onClickItemHandler, self)
  self.m_widgetTipRelative = self:FindGO("TipRelative", self.gameObject):GetComponent(UIWidget)
  PictureManager.Instance:SetUI(Tex_Bg, self.m_uiTexBg)
  PictureManager.Instance:SetUI(Tex_Bg_1, self.m_uiTexBg1)
  PictureManager.Instance:SetUI(Tex_Bg_2, self.m_uiTexBg2)
  PictureManager.Instance:SetUI(Tex_Bg_2, self.m_uiTexBg3)
  PictureManager.Instance:SetUI(Tex_Name_Bg, self.m_uiTexNameBg)
end

function NewPeddlerShop:AddEvts()
  self:TryOpenHelpViewById(35247, nil, self.m_uiImgBtnQuestion)
  self:AddClickEvent(self.m_uiImgBtnClose.gameObject, function(go)
    self:CloseSelf()
  end)
end

function NewPeddlerShop:CloseSelf()
  PictureManager.Instance:UnLoadUI(Tex_Bg, self.m_uiTexBg)
  PictureManager.Instance:UnLoadUI(Tex_Bg_1, self.m_uiTexBg1)
  PictureManager.Instance:UnLoadUI(Tex_Bg_2, self.m_uiTexBg2)
  PictureManager.Instance:UnLoadUI(Tex_Bg_2, self.m_uiTexBg3)
  PictureManager.Instance:UnLoadUI(Tex_Name_Bg, self.m_uiTexNameBg)
  NewPeddlerShop.super.CloseSelf(self)
end

function NewPeddlerShop:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
end

function NewPeddlerShop:LoadTips()
  self.m_goItemTipsView = self:LoadPreferb("cell/NewHappyShopBuyItemCell", self.gameObject, false)
  self.m_goItemTipsView.transform.localPosition = LuaGeometry.GetTempVector3(0, 22)
  self.m_goGiftTipView = self:LoadPreferb("cell/NewRechargeGiftTipCell", self.gameObject, true)
  self:onShowItemTipsView(false)
  self:onShowGiftTipView(false)
end

function NewPeddlerShop:onShowItemTipsView(value)
  self.m_goItemTipsView:SetActive(value)
end

function NewPeddlerShop:onShowGiftTipView(value)
  self.m_goGiftTipView:SetActive(value)
end

function NewPeddlerShop:RecvBuyShopItem(data)
  if not data then
    NewRechargeProxy.Instance:readyTriggerEventId(0)
    return
  end
  self:CreateShowShopList(false)
  if NewRechargeProxy.Instance:isRecordEvent() then
    NewRechargeProxy.Instance:successTriggerEventId()
  end
end

function NewPeddlerShop:CreateShowShopList(repos)
  local listData = PeddlerShopProxy.Instance.shopList
  if listData == nil or #listData == 0 then
    return
  end
  self.m_gridListCtrl.cellNum = #listData
  self.m_gridListCtrl:ResetDatas(listData, repos)
  local cells = self.m_gridListCtrl:GetCells()
  local isCanDrag = 3 < #cells
  if isCanDrag and repos then
    local index = 1
    if not PeddlerShopProxy.Instance:isShowRedTip() then
      for i = 1, #cells do
        if cells[i]:isShowItem() then
          index = i
          break
        end
      end
      index = math.min(index, #cells - 2)
    end
    self.m_gridListCtrl:SetStartPositionByIndex(index)
  end
  self.m_uiScrollView.enabled = 3 < #cells
  for _, v in pairs(cells) do
    v:setClickItemFunc(self.onClickItem, self)
  end
end

function NewPeddlerShop:OnEnter()
  NewPeddlerShop.super.OnEnter(self)
  PeddlerShopProxy.Instance:InitShop()
  self:CreateShowShopList(true)
  LocalSaveProxy.Instance:SetPeddlerDailyDot()
  PeddlerShopProxy.Instance:UpdateWholeRedTip()
  self:UpdateDialogTimer()
end

function NewPeddlerShop:OnExit()
  if self.m_gridListCtrl ~= nil then
    self.m_gridListCtrl:Destroy()
  end
  NewPeddlerShop.super.OnExit(self)
end

function NewPeddlerShop:UpdateDialogTimer()
  local data = PeddlerShopProxy.Instance.shopList[1][1]
  local addDate = os.date("*t", data.AddDate)
  local removeDate = os.date("*t", data.RemoveDate)
  self.m_uiTxtLimitTime.text = string.format("%d.%d %d:%02d~%d.%d %d:%02d", addDate.month, addDate.day, addDate.hour, addDate.min, removeDate.month, removeDate.day, removeDate.hour, removeDate.min)
end

function NewPeddlerShop:onClickItemHandler(value)
end

function NewPeddlerShop:onClickItem(value)
  local tbItem = Table_Item[value.goodsID]
  if tbItem ~= nil and tbItem.ItemShow ~= nil and tbItem.ItemShow > 0 then
    self:onShowGiftTipView(true)
    if self.m_giftTips == nil then
      self.m_giftTips = NewPeddlerShopBuyGiftTips.new(self.m_goGiftTipView)
    end
    self.m_giftTips:SetData(value)
  else
    self:onShowItemTipsView(true)
    if self.m_itemTips == nil then
      self.m_itemTips = NewPeddlerShopBuyTips.new(self.m_goItemTipsView)
      self.m_itemTips:AddEventListener(ItemTipEvent.ClickItemUrl, self.onClickItemUrl, self)
      self.m_itemTipsCloseComp = self.m_itemTips.gameObject:GetComponent(CloseWhenClickOtherPlace)
    end
    self.m_itemTips:SetData(value)
  end
end

local itemClickUrlTipData = {}

function NewPeddlerShop:onClickItemUrl(id)
  if not next(itemClickUrlTipData) then
    itemClickUrlTipData.itemdata = ItemData.new()
  end
  local split = string.split(id, "+")
  id = tonumber(split[1])
  itemClickUrlTipData.itemdata:ResetData("itemClickUrl", id)
  if itemClickUrlTipData.itemdata:IsEquip() and split[2] then
    itemClickUrlTipData.itemdata.equipInfo:SetRefine(tonumber(split[2]))
  end
  
  function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
    itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
    if self.m_itemTips ~= nil then
      self.m_itemTips:onShowClickItemUrlTip(itemClickUrlTipData)
    end
  end
  
  if self.m_itemTips ~= nil then
    self.m_itemTips:onShowClickItemUrlTip(itemClickUrlTipData)
  end
end
