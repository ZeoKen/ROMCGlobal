local baseCell = autoImport("BaseCell")
AierBlacksmithMonsterGridCell = class("AierBlacksmithMonsterGridCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function AierBlacksmithMonsterGridCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AierBlacksmithMonsterGridCell:FindObjs()
  self.bgTex = self:FindGO("bg", UITexture)
  self.nameLb = self:FindComponent("name", UILabel)
  self.finMark = self:FindGO("finMark")
end

function AierBlacksmithMonsterGridCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  end
  self:Show()
end
