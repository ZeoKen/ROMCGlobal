autoImport("BagItemCell")
QuickBuffItemCell = class("QuickBuffItemCell", BagItemCell)

function QuickBuffItemCell:Init()
  QuickBuffItemCell.super.Init(self)
  local longPress = self.gameObject:GetComponent(UILongPress)
  longPress = longPress or self.gameObject:AddComponent(UILongPress)
  longPress.pressTime = 0.3
  
  function longPress.pressEvent(obj, isPressing)
    if isPressing then
      self:PassEvent(MouseEvent.LongPress, self)
    end
  end
end
