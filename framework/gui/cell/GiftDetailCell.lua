GiftDetailCell = class("GiftDetailCell", BaseCell)

function GiftDetailCell:Init()
  self:FindObjs()
end

function GiftDetailCell:FindObjs()
  local itemContainer = self:FindGO("ItemContainer")
  local cell = self:LoadPreferb("cell/ItemCell", itemContainer)
  cell.transform.localPosition = LuaGeometry.Const_V3_zero
  self.itemCell = ItemCell.new(cell)
  self.rateImg = self:FindGO("uiImgRate")
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.previewBtn = self:FindGO("PreviewButton")
  self:AddClickEvent(self.previewBtn, function()
    self:OnClickPreview()
  end)
end

function GiftDetailCell:SetData(data)
  self.data = data
  if data then
    local itemData = ItemData.new(data.itemid, data.itemid)
    itemData.num = data.num
    self.itemData = itemData
    self.itemCell:SetData(itemData)
    self.nameLabel.text = itemData:GetName()
    self.rateImg:SetActive(data.probability or false)
    local x, _, z = LuaGameObject.GetLocalPositionGO(self.nameLabel.gameObject)
    if data.safety then
      self.descLabel.text = string.format(ZhString.NewRecharge_Buy_Rate, data.showcount, data.guaranteed)
      LuaGameObject.SetLocalPositionGO(self.nameLabel.gameObject, x, 44, z)
    else
      self.descLabel.text = ""
      LuaGameObject.SetLocalPositionGO(self.nameLabel.gameObject, x, 14, z)
    end
    local isActive = false
    if itemData:IsPic() then
      local composeId = itemData.staticData.ComposeID
      local productId = composeId and Table_Compose[composeId] and Table_Compose[composeId].Product.id
      local product = productId and ItemData.new("Product", productId)
      isActive = product and product:CanEquip() and true or false
    elseif itemData:IsHomePic() then
      isActive = itemData:IsHomeMaterialPic()
    elseif itemData:EyeCanEquip() then
      isActive = true
    elseif itemData:HairCanEquip() then
      isActive = true
    elseif itemData:IsMountPet() then
      isActive = true
    elseif itemData:IsFurniture() then
      isActive = true
    elseif itemData:IsFashion() or itemData.equipInfo and (itemData.equipInfo:IsWeapon() or itemData.equipInfo:IsMount()) then
      if itemData:CanEquip(itemData.equipInfo:IsMount()) and not itemData:IsTrolley() then
        isActive = not Game.Myself.data:IsInMagicMachine() and not Game.Myself.data:IsEatBeing()
      else
        isActive = false
      end
    elseif itemData.equipInfo and itemData.equipInfo:GetEquipType() == EquipTypeEnum.Shield then
      local cfgShowShield = GameConfig.Profession.show_shield_typeBranches
      isActive = cfgShowShield ~= nil and TableUtility.ArrayFindIndex(cfgShowShield, MyselfProxy.Instance:GetMyProfessionTypeBranch()) > 0
    elseif GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[itemData.staticData.id] then
      isActive = true
    else
      isActive = false
    end
    self.previewBtn:SetActive(isActive)
  end
end

function GiftDetailCell:OnClickPreview()
  if self.itemData then
    if self.itemData.equipInfo and self.itemData.equipInfo:IsMyDisplayForbid() then
      MsgManager.ShowMsgByID(40310)
      return
    end
    self:PassEvent(GiftDetailTip.ShowPreview, self)
  end
end

function GiftDetailCell:OnCellDestroy()
  if self.itemCell then
    self.itemCell:ClearAllCellParts()
    self.itemCell = nil
  end
end
