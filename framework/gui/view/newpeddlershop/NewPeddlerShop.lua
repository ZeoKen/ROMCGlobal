autoImport("NewPeddlerShopItemCell")
autoImport("NewPeddlerShopBuyTips")
autoImport("NewPeddlerShopBuyGiftTips")
autoImport("NewPeddlerShopWrapListCtrl")
autoImport("PeddlerExtraBonusCell")
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
  self.resetBtn = self:FindGO("ResetBtn")
  self.resetBtn_BoxCollider = self.resetBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.resetBtn, function()
    self:OnResetClicked()
  end)
  self.resetTimeLabel = self:FindComponent("ResetTimeLabel", UILabel)
  self.extraRewardTip = self:FindGO("ExtraRewardTip")
  self.extraBounsGrid = self:FindGO("SliderGrid"):GetComponent(UIGrid)
  self.extraBonusCtrl = UIGridListCtrl.new(self.extraBounsGrid, PeddlerExtraBonusCell, "PeddlerExtraBonusCell")
  self.extraBonusCtrl:AddEventListener(MouseEvent.MouseClick, self.onClickExtraBonus, self)
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
  self:AddListenEvt(ServiceEvent.SessionShopExtraBonusQueryShopCmd, self.OnExtraBonusDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopExtraBonusResetShopCmd, self.OnExtraBonusReset)
  self:AddListenEvt(ServiceEvent.SessionShopExtraBonusRewardShopCmd, self.OnExtraBonusReward)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnPeddlerShopConfigUpdate)
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
  self:UpdateExtraBonusUI()
  self:UpdateResetButton()
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
  PeddlerShopProxy.Instance:QueryShopConfig()
  PeddlerShopProxy.Instance:InitShop()
  self:CreateShowShopList(true)
  LocalSaveProxy.Instance:SetPeddlerDailyDot()
  PeddlerShopProxy.Instance:UpdateWholeRedTip()
  PeddlerShopProxy.Instance:QueryExtraBonusData()
  self:UpdateExtraBonusUI()
  self:UpdateResetButton()
  self:UpdateDialogTimer()
  self:UpdateResetTime()
end

function NewPeddlerShop:OnExit()
  if self.m_gridListCtrl ~= nil then
    self.m_gridListCtrl:Destroy()
  end
  NewPeddlerShop.super.OnExit(self)
end

function NewPeddlerShop:UpdateDialogTimer()
  local extraBonusBatch = PeddlerShopProxy.Instance:CheckExtraBonusActivity()
  if 0 < extraBonusBatch then
    local config = Table_ShopExtraBonus[extraBonusBatch]
    if config then
      self.m_uiTxtName.text = config.Title or ""
      local isTFBranch = EnvChannel.IsTFBranch()
      local addDateStr, removeDateStr
      if isTFBranch then
        addDateStr = config.TFAddDate
        removeDateStr = config.TFRemoveDate
      else
        addDateStr = config.AddDate
        removeDateStr = config.RemoveDate
      end
      if addDateStr and removeDateStr then
        self.m_uiTxtLimitTime.text = string.format("%s ~ %s", addDateStr, removeDateStr)
      else
        self.m_uiTxtLimitTime.text = ""
      end
    end
  else
    local data = PeddlerShopProxy.Instance.shopList[1] and PeddlerShopProxy.Instance.shopList[1][1]
    if data then
      local addDate = os.date("*t", data.AddDate)
      local removeDate = os.date("*t", data.RemoveDate)
      self.m_uiTxtLimitTime.text = string.format("%d.%d %d:%02d~%d.%d %d:%02d", addDate.month, addDate.day, addDate.hour, addDate.min, removeDate.month, removeDate.day, removeDate.hour, removeDate.min)
    end
  end
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

function NewPeddlerShop:OnResetClicked()
  xdlog("NewPeddlerShop:OnResetClicked")
  if not PeddlerShopProxy.Instance:CanResetExtraBonus() then
    xdlog("NewPeddlerShop:OnResetClicked", "不满足重置条件")
    return
  end
  PeddlerShopProxy.Instance:RequestResetExtraBonus()
end

function NewPeddlerShop:OnExtraBonusDataUpdate(data)
  xdlog("NewPeddlerShop:OnExtraBonusDataUpdate")
  self:UpdateExtraBonusUI()
  self:UpdateResetButton()
  self:UpdateDialogTimer()
end

function NewPeddlerShop:OnExtraBonusReset(data)
  xdlog("NewPeddlerShop:OnExtraBonusReset")
  self:UpdateExtraBonusUI()
  self:UpdateResetButton()
end

function NewPeddlerShop:OnExtraBonusReward(data)
  xdlog("NewPeddlerShop:OnExtraBonusReward")
  self:UpdateExtraBonusUI()
  self:UpdateResetButton()
end

function NewPeddlerShop:OnPeddlerShopConfigUpdate(note)
  local data = note.body
  if data and (data.type == 20060 or data.type == 20325) then
    self:CreateShowShopList(false)
  end
end

function NewPeddlerShop:UpdateExtraBonusUI()
  if not self.extraBonusCtrl then
    return
  end
  local displayData = PeddlerShopProxy.Instance:GetExtraBonusDisplayData()
  self.extraBonusCtrl:ResetDatas(displayData, true, true)
  if self.extraRewardTip then
    local dataLength = #displayData
    local xPosition = 228.7 * dataLength / 2 * -1
    self.extraRewardTip.transform.localPosition = LuaGeometry.GetTempVector3(xPosition, -274, 0)
    self.extraRewardTip:SetActive(0 < dataLength)
  end
end

function NewPeddlerShop:UpdateResetButton()
  if not self.resetBtn then
    return
  end
  local extraBonusBatch = PeddlerShopProxy.Instance:CheckExtraBonusActivity()
  if extraBonusBatch == 0 then
    self.resetBtn:SetActive(false)
    self.resetTimeLabel.text = ""
    return
  end
  local canReset = PeddlerShopProxy.Instance:CanResetExtraBonus()
  self.resetBtn_BoxCollider.enabled = canReset
  if canReset then
    self:SetTextureWhite(self.resetBtn, Color(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1))
  else
    self:SetTextureGrey(self.resetBtn)
  end
  self:UpdateResetTime()
end

function NewPeddlerShop:UpdateResetTime()
  if not self.resetTimeLabel then
    return
  end
  local extraBonusData = PeddlerShopProxy.Instance:GetExtraBonusData()
  local extraBonusConfig = PeddlerShopProxy.Instance:GetExtraBonusConfig()
  local extraBonusBatch = PeddlerShopProxy.Instance:CheckExtraBonusActivity()
  if not (extraBonusData and extraBonusConfig) or extraBonusBatch == 0 then
    self.resetTimeLabel.text = ""
    return
  end
  local currentResetTimes = extraBonusData.resetTimes or 0
  local maxResetTimes = extraBonusConfig.ResetTimesLimit or 0
  local resetText = string.format(ZhString.PeddlerShop_ResetTimes, maxResetTimes - currentResetTimes)
  self.resetTimeLabel.text = resetText
end

function NewPeddlerShop:onClickExtraBonus(cellCtrl)
  xdlog("NewPeddlerShop:onClickExtraBonus")
  if not cellCtrl or not cellCtrl.data then
    return
  end
  local data = cellCtrl.data
  if data.status == "complete" then
    xdlog("NewPeddlerShop:onClickExtraBonus", "领取奖励", data.targetAmount)
    PeddlerShopProxy.Instance:RequestReceiveExtraBonus(data.targetAmount)
  else
    xdlog("NewPeddlerShop:onClickExtraBonus", "显示物品提示", data.rewardId)
    if data.rewardId and data.rewardId > 0 then
      local funcData = {}
      funcData.itemdata = ItemData.new("ItemData", data.rewardId)
      funcData.itemdata:SetItemNum(data.rewardCount)
      self:ShowItemTip(funcData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end
