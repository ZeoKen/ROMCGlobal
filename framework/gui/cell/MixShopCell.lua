MixShopCell = class("MixShopCell", LotteryCell)

function MixShopCell:FindObjs()
  MixShopCell.super.FindObjs(self)
  local moneyRoot = self:FindGO("MoneyRoot")
  self.moneyIcon = self:FindComponent("MoneyIcon", UISprite, moneyRoot)
  self.money = self:FindComponent("Money", UILabel, moneyRoot)
  self.moneyBg = self:FindComponent("bg", UISprite, moneyRoot)
  self.dressLab = self:FindComponent("DressLab", UILabel)
  self.choosen = self:FindGO("Choosen")
  self.endline = self:FindGO("EndLine")
  self.bgSp = self:FindComponent("Bg", UISprite)
end

function MixShopCell:SetData(data, reset)
  self.gameObject:SetActive(nil ~= data)
  if data then
    MixShopCell.super.SetData(self, data)
    self:UpdateMyselfInfo(data:GetItemData())
    local costIcon = Table_Item[data.ItemID].Icon
    IconManager:SetItemIcon(costIcon, self.moneyIcon)
    self.money.text = data.ItemCount
  end
  self.data = data
  self:UpdateDressLab()
  self:UpdateChoose()
  self:ResetMainColorPalette()
  if not reset then
    self.endline:SetActive(nil ~= data and data.newSeries == true)
  end
  if self.data then
    local isInvalid = self.data:CheckPurchaseInvalid()
    local colorhexStr = isInvalid and "F9E1C5" or "7A562C"
    local _, c = ColorUtil.TryParseHexString(colorhexStr)
    self.nameLab.color = c
    self.bgSp.spriteName = isInvalid and "mall_twistedegg_bg_22" or "mall_twistedegg_bg_02"
    self.moneyBg.alpha = isInvalid and 0.8 or 1
  end
end

function MixShopCell:SetChoose(id)
  self.chooseid = id
  self.choose_groupId = Table_Equip[id].GroupID
  self:UpdateChoose()
end

function MixShopCell:UpdateChoose()
  local sameGroup = nil ~= self.data and nil ~= self.data.group_id and self.data.group_id == self.choose_groupId
  if self.data and (self.data.goodsID == self.chooseid or sameGroup) then
    self:Show(self.choosen)
  else
    self:Hide(self.choosen)
  end
end

function MixShopCell:ResetMainColorPalette()
  if not self.mainColorPaletteSp then
    return
  end
  self.mainColorPaletteSp.color = ColorUtil.NGUIWhite
  self.mainColorPaletteSp.spriteName = "com_icon_Palette02"
end

function MixShopCell:UpdateGotFlag()
  if not self.gotFlag then
    return
  end
  self.gotFlag:SetActive(self.data and self.data.CheckGoodsGroupGot and self.data:CheckGoodsGroupGot())
end
