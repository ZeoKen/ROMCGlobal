autoImport("ShopDressingView")
ClothDressingView = class("ClothDressingView", ShopDressingView)
ClothDressingView.ViewType = UIViewType.NormalLayer
autoImport("ClothDressingPage")
local _shoptype, _shopID

function ClothDressingView:FindObjs()
  self.super.FindObjs(self)
  self.toggleLab = self:FindGO("toggleLab"):GetComponent(UILabel)
end

function ClothDressingView:InitUIView()
  self.super.InitUIView(self)
  self.ClothDressingPage = self:AddSubView("ClothDressingPage", ClothDressingPage)
  self.toggleLab.text = ZhString.ClothDressingView_title
end

function ClothDressingView:ClickReplaceBtn()
  local queryArgs = ShopDressingProxy.Instance:GetQueryArgs()
  local shopid = queryArgs[10]
  if not shopid then
    return
  end
  local moneyId, moneyNum, discount = queryArgs[11], queryArgs[12], queryArgs[13]
  _shoptype = ShopDressingProxy.Instance:GetShopType()
  _shopID = ShopDressingProxy.Instance:GetShopId()
  if ShopDressingProxy.Instance:IsSame(ShopDressingProxy.DressingType.ClothColor) then
    MsgManager.FloatMsgTableParam(nil, ZhString.ClothDressingView_same)
    return
  end
  local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(_shoptype, _shopID, shopid)
  if tempcsv:CheckCanRemove() then
    MsgManager.FloatMsgTableParam(nil, ZhString.HappyShop_overtime)
    return
  end
  if not ShopDressingProxy.Instance:CheckCanOpen(tempcsv.MenuID) then
    local lockmsg = tempcsv:GetQuestLockDes()
    if lockmsg then
      MsgManager.FloatMsgTableParam(nil, lockmsg)
    end
    return
  end
  local moneyNeed = moneyNum * discount * 0.01
  if moneyId == GameConfig.MoneyId.Zeny then
    if moneyNeed > MyselfProxy.Instance:GetROB() then
      MsgManager.ShowMsgByIDTable(1)
      return
    end
  elseif moneyNeed > BagProxy.Instance:GetItemNumByStaticID(moneyId) then
    local tName = Table_Item[moneyId] and Table_Item[moneyId].NameZh or ""
    MsgManager.ShowMsgByIDTable(25418, tName)
    return
  end
  ShopDressingProxy.Instance:CallReplaceDressing(shopid)
end

local strFormat = "%sx%s"

function ClothDressingView:RefreshROB(constID, costCount, menuid)
  self:Show(self.chargeNum)
  self:RefreshMoney()
  local itemStaticData = Table_Item[constID]
  local iconName = itemStaticData.NameZh or ""
  self.chargeNum.text = constID == GameConfig.MoneyId.Zeny and costCount or string.format(strFormat, iconName, costCount)
  local curCount = constID == GameConfig.MoneyId.Zeny and ShopDressingProxy.Instance:GetCurMoneyByID(constID) or BagProxy.Instance:GetItemNumByStaticID(constID)
  if costCount <= curCount then
    self.chargeNum.color = ColorUtil.ButtonLabelBlue
  else
    ColorUtil.RedLabel(self.chargeWidget)
  end
  local flag = costCount <= curCount and ShopDressingProxy.Instance:CheckCanOpen(menuid)
  self:SetReplaceBtnState(flag)
  if itemStaticData and itemStaticData.Icon then
    IconManager:SetItemIcon(itemStaticData.Icon, self.itemIcon)
  end
  self:Show(self.itemIcon)
end

function ClothDressingView:RecvUseDressing(note)
  self:RefreshModel()
  self:SetReplaceBtnState(false)
end

function ClothDressingView:OnEnter()
  self.super.OnEnter(self)
  local myTrans = Game.Myself.assetRole.completeTransform
  if myTrans then
    local viewPort = CameraConfig.ClothDressing_ViewPort
    local rotation = CameraConfig.ClothDressing_Rotation
    self:CameraFaceTo(myTrans, viewPort, rotation)
  end
end
