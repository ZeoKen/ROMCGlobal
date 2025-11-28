LotteryResultCell = class("LotteryResultCell", ItemCell)
local Vector3Zero = LuaVector3.Zero()

function LotteryResultCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3Zero
  LotteryResultCell.super.Init(self)
end

function LotteryResultCell:SetData(data)
  self.data = data
  if data then
    LotteryResultCell.super.SetData(self, data)
  end
end
