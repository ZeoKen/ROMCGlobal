local baseCell = autoImport("BaseCell")
MercenaryCatHeadCell = class("MercenaryCatHeadCell", baseCell)

function MercenaryCatHeadCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.lockFlag = self:FindGO("LockFlag")
  self:SetEvent(self.icon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MercenaryCatHeadCell:SetData(data)
  self.data = data
  self.lockFlag:SetActive(not FunctionUnLockFunc.Me():CheckCanOpen(data.staticData.MenuID))
  IconManager:SetFaceIcon(data.icon, self.icon)
end

local scale = LuaVector3.One()

function MercenaryCatHeadCell:SetScale(size)
  if not Slua.IsNull(self.gameObject) and self.gameObject then
    LuaVector3.Better_Set(scale, 1, 1, 1)
    LuaVector3.Mul(scale, size)
    self.gameObject.transform.localScale = scale
  end
end
