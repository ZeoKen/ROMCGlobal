ChatItemCell = class("ChatItemCell", ItemCell)

function ChatItemCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  ChatItemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function ChatItemCell:FindObjs()
  self.equip = self:FindGO("Equip")
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      if state then
        local data = {
          itemdata = self.data,
          
          funcConfig = {},
          noSelfClose = true,
          hideGetPath = true
        }
        TipManager.Instance:ShowItemFloatTip(data, self.icon, NGUIUtil.AnchorSide.Right, {250, 0})
      else
        self:ShowItemTip()
      end
    end
  end
end

function ChatItemCell:SetData(data)
  self.data = data
  if data then
    ChatItemCell.super.SetData(self, data)
    if data.equiped == 1 then
      self.equip:SetActive(true)
    else
      self.equip:SetActive(false)
    end
  end
end
