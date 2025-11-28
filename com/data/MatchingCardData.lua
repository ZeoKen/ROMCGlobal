autoImport("ItemData")
MatchingCardData = class("MatchingCardData")
local rate_base = 1000

function MatchingCardData:ctor()
  self.index = 0
  self.itemid = 0
  self.card_itemdata = nil
  self.display = MiniGameCardDisplay.ShowBack
end

function MatchingCardData:SetData(index, itemid)
  self.index = index
  self.itemid = itemid
  self.card_itemdata = ItemData.new("card", itemid)
  self.cardInfo = self.card_itemdata and self.card_itemdata.cardInfo
end

function MatchingCardData:GenerateDisplay(inforate, hidenameRate)
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 7)) + self.index)
  local r = math.random(1, rate_base)
  if hidenameRate >= r then
    self.display = MiniGameCardDisplay.HideName
    return
  end
  if inforate >= r then
    self.display = MiniGameCardDisplay.HideBack
    return
  end
  return
end
