CardUpgradeCell = class("CardUpgradeCell", ItemCell)
local NormalPosX = -142
local UpgradePosX = -107

function CardUpgradeCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  CardUpgradeCell.super.Init(self)
  self:FindObjs()
end

function CardUpgradeCell:FindObjs()
  local bg = self:FindComponent("Bg", UISprite)
  self.height = bg.height
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.choose = self:FindGO("ChooseSymbol")
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self:AddCellClickEvent()
  local longPress = self.itemContainer:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, isPress)
      if isPress then
        self:PassEvent(MouseEvent.LongPress, self)
      end
    end
  end
end

function CardUpgradeCell:SetData(data)
  if data then
    local itemData = data.itemData
    if itemData then
      CardUpgradeCell.super.SetData(self, itemData)
      self.itemName.text = itemData.staticData and itemData.staticData.NameZh or ""
      local x, y, z = LuaGameObject.GetLocalPositionGO(self.itemName.gameObject)
      local bufferIds = itemData.cardInfo.BuffEffect.buff
      if itemData.cardLv and itemData.cardLv > 0 then
        self.levelLabel.text = string.format("+%s", itemData.cardLv)
        LuaGameObject.SetLocalPositionGO(self.itemName.gameObject, UpgradePosX, y, z)
        if Game.CardUpgradeMap and Game.CardUpgradeMap[itemData.cardInfo.id] then
          local cfg = Game.CardUpgradeMap[itemData.cardInfo.id][itemData.cardLv]
          if cfg and cfg.BuffEffect then
            bufferIds = cfg.BuffEffect
          end
        end
      else
        self.levelLabel.text = ""
        LuaGameObject.SetLocalPositionGO(self.itemName.gameObject, NormalPosX, y, z)
      end
      self:SetCardGrey(0 >= itemData.num)
      if bufferIds then
        local descStr = ""
        for i = 1, #bufferIds do
          local str = ItemUtil.getBufferDescById(bufferIds[i])
          if not StringUtil.IsEmpty(str) then
            descStr = descStr .. str
            if i < #bufferIds then
              descStr = descStr .. "\n"
            end
          end
        end
        self.descLabel.text = descStr
        UIUtil.WrapLabel(self.descLabel)
      end
      if self.cardItem then
        self.cardItem:ShowCardLv(false)
      end
    end
  end
  self.data = data
end

function CardUpgradeCell:SetChoose(isChoose)
  self.choose:SetActive(isChoose)
end
