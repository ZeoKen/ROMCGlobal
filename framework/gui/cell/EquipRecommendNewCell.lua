autoImport("EquipRecommendNewEquipCell")
autoImport("EquipRecommendNewCardCell")
EquipRecommendNewCell = class("EquipRecommendNewCell", BaseCell)

function EquipRecommendNewCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function EquipRecommendNewCell:FindObjs()
  self.nameLabel = self:FindComponent("name", UILabel)
  self.equipPanel = self:FindComponent("itemPanel", UIPanel)
  local equipGrid = self:FindComponent("itemGrid", UIGrid)
  self.equipListCtrl = UIGridListCtrl.new(equipGrid, EquipRecommendNewEquipCell, "EquipRecommendNewEquipCell")
  self.equipListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemClick, self)
  self.cardPanel = self:FindComponent("cardPanel", UIPanel)
  local cardGrid = self:FindComponent("cardGrid", UIGrid)
  self.cardListCtrl = UIGridListCtrl.new(cardGrid, EquipRecommendNewCardCell, "EquipRecommendNewCardCell")
  self.cardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemClick, self)
  self.icon = self:FindComponent("icon", UISprite)
  self:SetPanelDepth()
end

function EquipRecommendNewCell:SetData(data)
  self.data = data
  if data then
    local pos = data.pos
    local name = GameConfig.EquipPosName[pos]
    name = string.gsub(name, "(%d+)", "")
    self.nameLabel.text = name
    local index = pos == 5 and 6 or pos
    local iconName = "bag_equip_" .. index
    IconManager:SetUIIcon(iconName, self.icon)
    local itemDatas, cardDatas = {}, {}
    local equips = data:GetEquips()
    local cards = data:GetCards()
    for i = 1, 3 do
      local equip = equips[i] or BagItemEmptyType.Empty
      local card = cards[i] or BagItemEmptyType.Empty
      itemDatas[i] = equip
      cardDatas[i] = card
    end
    self.equipListCtrl:ResetDatas(itemDatas)
    self.cardListCtrl:ResetDatas(cardDatas)
  end
end

function EquipRecommendNewCell:OnItemClick(cell)
  local data = cell.data
  if data and data ~= BagItemEmptyType.Empty then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.widget, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function EquipRecommendNewCell:SetPanelDepth()
  local parentPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  if parentPanel then
    self.equipPanel.depth = parentPanel.depth + 1
    self.cardPanel.depth = parentPanel.depth + 1
  end
end
