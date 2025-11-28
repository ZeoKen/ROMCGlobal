local BaseCell = autoImport("BaseCell")
NoviceTarget2023HelpPopupCell = class("NoviceTarget2023HelpPopupCell", BaseCell)
autoImport("NoviceTarget2023HelpItemCell")
local bgTexName = "mall_bg_bottom_10"

function NoviceTarget2023HelpPopupCell:PageToggleChange(toggle, label, toggleColor, normalColor, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        handler(self, param)
      end
    else
      label.color = normalColor
    end
  end)
end

function NoviceTarget2023HelpPopupCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

NoviceTarget2023HelpPopupCell._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
NoviceTarget2023HelpPopupCell._ColorTitleGray = ColorUtil.TitleGray

function NoviceTarget2023HelpPopupCell:FindObjs()
  self.thetext = self:FindGO("thetext")
  self.theitem = self:FindGO("theitem")
  self.thetext_scrollView = self:FindComponent("ScrollView", UIScrollView, self.thetext)
  self.thetext_ttexttext = self:FindComponent("ttextext", UILabel, self.thetext)
  self.theitem_scrollView = self:FindComponent("ScrollView", UIScrollView, self.theitem)
  self.theitem_scrollCtl = UIGridListCtrl.new(self:FindComponent("Grid", UIGrid, self.theitem_scrollView.gameObject), NoviceTarget2023HelpItemCell, "NoviceTarget2023HelpItemCell")
  self.theitem_scrollCtl:AddEventListener(MouseEvent.MouseClick, self.theitem_handleClickReward, self)
  local dailyObj = self:FindGO("DailyToggle")
  self.dailyToggle = dailyObj:GetComponent(UIToggle)
  self.dailyLab = dailyObj:GetComponent(UILabel)
  local weekObj = self:FindGO("WeeklyToggle")
  self.weeklyToggle = weekObj:GetComponent(UIToggle)
  self.weeklyLab = weekObj:GetComponent(UILabel)
  self:AddButtonEvent("CloseButton", function()
    self:Cancel()
  end)
  self:PageToggleChange(self.dailyToggle, self.dailyLab, NoviceTarget2023HelpPopupCell._ColorEffectBlue, NoviceTarget2023HelpPopupCell._ColorTitleGray, self.ShowUI, 1)
  self:PageToggleChange(self.weeklyToggle, self.weeklyLab, NoviceTarget2023HelpPopupCell._ColorEffectBlue, NoviceTarget2023HelpPopupCell._ColorTitleGray, self.ShowUI, 2)
end

function NoviceTarget2023HelpPopupCell:theitem_handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local item_data = cellCtrl.data
    self.tipData.itemdata = item_data
    self.tipData.funcConfig = FunctionItemFunc.CheckBeVIP(item_data) == ItemFuncState.Active and _TipFunc or _EmptyTable
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-230, 0})
  end
end

function NoviceTarget2023HelpPopupCell:Show()
  self.gameObject:SetActive(true)
end

function NoviceTarget2023HelpPopupCell:Hide()
  self.gameObject:SetActive(false)
end

function NoviceTarget2023HelpPopupCell:ShowUI(type)
  if type == 1 then
    self:ShowUI_thetext()
  else
    self:ShowUI_theitem()
  end
end

function NoviceTarget2023HelpPopupCell:ShowUI_thetext()
  self.theitem:SetActive(false)
  self.thetext:SetActive(true)
  self.dailyToggle.value = true
  self.weeklyToggle.value = false
  self:FillTextByHelpId(50002, self.thetext_ttexttext)
  self.thetext_scrollView:ResetPosition()
end

function NoviceTarget2023HelpPopupCell:ShowUI_theitem()
  self.theitem:SetActive(true)
  self.thetext:SetActive(false)
  self.dailyToggle.value = false
  self.weeklyToggle.value = true
  self.theitem_scrollCtl:ResetDatas(NoviceTarget2023Proxy.Instance:GetAllRewardDataStatus())
  self.theitem_scrollView:ResetPosition()
end

function NoviceTarget2023HelpPopupCell:OnEnable()
  NoviceTarget2023HelpPopupCell.super.OnEnable(self)
  self:ShowUI(1)
end

function NoviceTarget2023HelpPopupCell:OnDisable()
  NoviceTarget2023HelpPopupCell.super.OnDisable(self)
end

function NoviceTarget2023HelpPopupCell:AddEvts()
  NoviceTarget2023HelpPopupCell.super.AddEvts(self)
end

function NoviceTarget2023HelpPopupCell:SetData(data)
  self.data = data
end

function NoviceTarget2023HelpPopupCell:setLocalPosition(x)
end

function NoviceTarget2023HelpPopupCell:Cancel()
  self:Hide()
  self:onCloseFashionPreview()
  TipsView.Me():HideCurrent()
end

function NoviceTarget2023HelpPopupCell:onShowFashionPreview(value)
  TipsView.Me():HideCurrent()
  if null == self.m_fashionPreviewTip then
    local data = value.data
    if data ~= nil and data.staticData ~= nil then
      self.m_fashionPreviewTip = FashionPreviewTip.new(self.gpContainer)
      self.m_fashionPreviewTip:SetAnchorPos(true)
      if data:IsPic() then
        local cid = data.staticData.ComposeID
        local composeData = cid and Table_Compose[cid]
        if composeData then
          self.m_fashionPreviewTip:SetData(composeData.Product.id)
        end
      else
        local equipPreview = GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id]
        local equipInfo = data.equipInfo
        local fashionGroupEquip = equipInfo and equipInfo:GetMyGroupFashionEquip()
        if equipPreview then
          local field = MyselfProxy.Instance:GetMySex() == 2 and "female" or "male"
          self.m_fashionPreviewTip:SetData(equipPreview[field])
        elseif fashionGroupEquip then
          self.m_fashionPreviewTip:SetData(fashionGroupEquip.id)
        else
          self.m_fashionPreviewTip:SetData(data.staticData.id)
        end
      end
      self.m_fashionPreviewTip:AddEventListener(ItemEvent.GoTraceItem, function()
        self:CloseSelf()
      end, self)
      self.m_fashionPreviewTip:AddIgnoreBounds(self.gameObject)
      self.m_fashionPreviewTip:AddEventListener(FashionPreviewEvent.Close, self.onFashionPreViewCloseCall, self)
    end
    self:PassEvent(ItemTipEvent.ShowFashionPreview, self.m_fashionPreviewTip)
    self:setLocalPosition(self.showTipSelfOffsetX or -200)
  else
    self:onCloseFashionPreview()
  end
end

function NoviceTarget2023HelpPopupCell:onFashionPreViewCloseCall()
  self.m_fashionPreviewTip = nil
  self:PassEvent(FashionPreviewEvent.Close)
  self:setLocalPosition(0)
end

function NoviceTarget2023HelpPopupCell:onCloseFashionPreview()
  if self.m_fashionPreviewTip then
    self.m_fashionPreviewTip:OnExit()
    self.m_fashionPreviewTip = nil
  end
  self:setLocalPosition(0)
end

function NoviceTarget2023HelpPopupCell:onShowGoodsItemTip(cell)
  self:ShowGoodsItemTip(cell.data.staticData.id, cell.gameObject)
end

function NoviceTarget2023HelpPopupCell:ShowGoodsItemTip(itemId, go)
  self:onCloseFashionPreview()
  local itemData = ItemData.new(nil, itemId)
  if itemData ~= nil then
    self:setLocalPosition(self.showTipSelfOffsetX or -200)
    if self.m_tipWidget == nil then
      self.m_tipWidget = self.gpContainer:GetComponent(UIWidget)
    end
    local tipData, tipOffset = {}, {195, 0}
    tipData.itemdata = itemData
    tipData.ignoreBounds = {go}
    tipData.showCloseBtn = true
    if self.cfg_noSelfClose ~= nil then
      tipData.noSelfClose = self.cfg_noSelfClose
    else
      tipData.noSelfClose = true
    end
    
    function tipData.callback()
      self:setLocalPosition(0)
    end
    
    function tipData.clickItemUrlCallback(tb, id)
      self:onShowUrlInfo(tb, id)
    end
    
    local currentTip = TipManager.Instance:ShowItemFloatTip(tipData, self.m_goodsItemTipAnchor, NGUIUtil.AnchorSide.Right, self.showTipOffset or tipOffset, false)
    self:AddIgnoreBounds(currentTip:GetCell(1).gameObject)
  end
end

function NoviceTarget2023HelpPopupCell:onShowUrlInfo(tb, id)
  if self.m_gwt ~= nil then
    self.m_gwt:OnExit()
    self.m_gwt = nil
  end
  if tb ~= nil then
    tb:DefaultClickItemUrl(id, UIWidget.Pivot.Right)
  end
end
