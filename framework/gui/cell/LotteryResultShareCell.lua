LotteryResultShareCell = class("LotteryResultShareCell", ItemCell)
local Vector3Zero = LuaVector3.Zero()

function LotteryResultShareCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3Zero
  LotteryResultShareCell.super.Init(self)
end

function LotteryResultShareCell:SetData(data)
  self.data = data
  if data then
    LotteryResultShareCell.super.SetData(self, data)
  end
end
