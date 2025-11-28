autoImport("BagItemCell")
RoguelikeItemCell = class("RoguelikeItemCell", BagItemCell)
local magicBottleItemId, magicBottleMaxNum

function RoguelikeItemCell:Init()
  if not magicBottleItemId then
    magicBottleItemId = GameConfig.Roguelike.MagicBottleItemID
    magicBottleMaxNum = GameConfig.Roguelike.MagicBottleItemNum
  end
  RoguelikeItemCell.super.Init(self)
  local longPress = self.gameObject:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
  
  self:InitEquipPart()
end

function RoguelikeItemCell:_UpdateData(data)
  RoguelikeItemCell.super._UpdateData(self, data)
  local itemId = data and data.staticData.id
  self:SetInvalid(Game.Myself:IsDead() or itemId and not ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(data.staticData.Type, itemId))
  self.equipGO:SetActive(true)
  local maxLevel, level = DungeonProxy.GetRoguelikeItemMaxLevel(itemId)
  if 1 < maxLevel then
    level = data.num or 0
    self.equiplv.gameObject:SetActive(0 < level)
    self:UpdateNumLabel(0)
  else
    self.equiplv.gameObject:SetActive(false)
  end
  self.equiplv.text = StringUtil.IntToRoman(level)
  self.attrGrid:Reposition()
  if itemId and itemId == magicBottleItemId then
    self:UpdateNumLabel(string.format("%s/%s", data.num or 0, magicBottleMaxNum))
  end
end

function RoguelikeItemCell:GetCD()
  local data = self.data
  if data then
    local cd = CDProxy.Instance:GetItemInCD(data.staticData.id)
    return cd and cd:GetCd() or 0
  end
  return 0
end

function RoguelikeItemCell:GetMaxCD()
  local data = self.data
  if data then
    return DungeonProxy.GetRoguelikeItemCdTime(data.staticData.id)
  end
  return 0
end
