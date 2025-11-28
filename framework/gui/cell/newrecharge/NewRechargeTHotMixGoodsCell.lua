autoImport("NewRechargeRecommendTShopGoodsCell")
autoImport("NewRechargeCombinePackCell")
NewRechargeTHotMixGoodsCell = class("NewRechargeTHotMixGoodsCell")

function NewRechargeTHotMixGoodsCell:ctor(obj)
  self.go_ = obj
  self.go_NewRechargeRecommendTShopGoodsCell = Game.GameObjectUtil:DeepFind(obj, "NewRechargeCommonGoodsCellType1")
  self.go_NewRechargeCombinePackCell = Game.GameObjectUtil:DeepFind(obj, "NewRechargeCombinePackCell")
  self.NewRechargeRecommendTShopGoodsCell = NewRechargeRecommendTShopGoodsCell.new(self.go_NewRechargeRecommendTShopGoodsCell)
  self.NewRechargeCombinePackCell = NewRechargeCombinePackCell.new(self.go_NewRechargeCombinePackCell)
  self:SetMixType(1)
end

function NewRechargeTHotMixGoodsCell:SetMixType(type)
  if type == 1 then
    setmetatable(self.class, {
      __index = self.NewRechargeCombinePackCell
    })
    if self.go_NewRechargeRecommendTShopGoodsCell and Slua.IsNull(self.go_NewRechargeRecommendTShopGoodsCell) == false then
      self.go_NewRechargeRecommendTShopGoodsCell:SetActive(false)
    end
    if self.go_NewRechargeCombinePackCell and Slua.IsNull(self.go_NewRechargeCombinePackCell) == false then
      self.go_NewRechargeCombinePackCell:SetActive(true)
    end
  else
    setmetatable(self.class, {
      __index = self.NewRechargeRecommendTShopGoodsCell
    })
    if self.go_NewRechargeRecommendTShopGoodsCell and Slua.IsNull(self.go_NewRechargeRecommendTShopGoodsCell) == false then
      self.go_NewRechargeRecommendTShopGoodsCell:SetActive(true)
    end
    if self.go_NewRechargeCombinePackCell and Slua.IsNull(self.go_NewRechargeCombinePackCell) == false then
      self.go_NewRechargeCombinePackCell:SetActive(false)
    end
  end
end

function NewRechargeTHotMixGoodsCell:SetData(data)
  self:SetMixType(data._mix_type)
  if data._mix_type == 1 then
    self.NewRechargeCombinePackCell:SetData(data)
  else
    self.NewRechargeRecommendTShopGoodsCell:SetData(data)
  end
end

function NewRechargeTHotMixGoodsCell:AddEventListener(eventType, handler, handlerOwner)
  self.NewRechargeCombinePackCell:AddEventListener(eventType, handler, handlerOwner)
  self.NewRechargeRecommendTShopGoodsCell:AddEventListener(eventType, handler, handlerOwner)
end

function NewRechargeTHotMixGoodsCell:OnCellDestroy()
  if self.NewRechargeCombinePackCell.OnCellDestroy then
    self.NewRechargeCombinePackCell:OnCellDestroy()
  end
  if self.NewRechargeRecommendTShopGoodsCell.OnCellDestroy then
    self.NewRechargeRecommendTShopGoodsCell:OnCellDestroy()
  end
  setmetatable(self.class, nil)
  self.gameObject = self.go_
end

function NewRechargeTHotMixGoodsCell:OnRemove()
  if self.NewRechargeCombinePackCell.OnRemove then
    self.NewRechargeCombinePackCell:OnRemove()
  end
  if self.NewRechargeRecommendTShopGoodsCell.OnRemove then
    self.NewRechargeRecommendTShopGoodsCell:OnRemove()
  end
end

function NewRechargeTHotMixGoodsCell:ClearEvent()
  if self.NewRechargeCombinePackCell.ClearEvent then
    self.NewRechargeCombinePackCell:ClearEvent()
  end
  if self.NewRechargeRecommendTShopGoodsCell.ClearEvent then
    self.NewRechargeRecommendTShopGoodsCell:ClearEvent()
  end
end
