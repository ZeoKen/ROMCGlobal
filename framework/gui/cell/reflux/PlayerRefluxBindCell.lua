PlayerRefluxBindCell = class("PlayerRefluxBindCell", ItemCell)

function PlayerRefluxBindCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  PlayerRefluxBindCell.super.Init(self)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PlayerRefluxBindCell:SetData(data)
  self.data = data
  if data then
    PlayerRefluxBindCell.super.SetData(self, data)
  end
end

function PlayerRefluxBindCell:UpdateNumLabel(scount, x, y, z)
  if not self.numLab_Inited then
    self.numLab_Inited = true
    self.numLabGO = self:FindGO("NumLabel", self.item)
    if self.numLabGO then
      self.numLabTrans = self.numLabGO.transform
      self.numLab = self.numLabGO:GetComponent(UILabel)
      self.numLabGO:SetActive(true)
    end
  end
  if not self.numLabGO then
    return
  end
  self.numLab.text = scount
  self.numLabTrans.localPosition = x and y and z and LuaGeometry.GetTempVector3(x, y, z) or self.DefaultNumLabelLocalPos
end
