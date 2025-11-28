autoImport("ChatItemCombineCell")
autoImport("RedPacketItemCell")
RedPacketCombineCell = class("RedPacketCombineCell", ChatItemCombineCell)

function RedPacketCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = RedPacketItemCell.new(go)
  end
end
