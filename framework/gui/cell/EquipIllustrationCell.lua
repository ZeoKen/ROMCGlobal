local BaseCell = autoImport("BaseCell")
EquipIllustrationCell = class("BossCell", BaseCell)

function EquipIllustrationCell:Init()
  self:FindObjs()
end

function EquipIllustrationCell:FindObjs()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.ScrollviewPanel = self:FindGO("Scrollview"):GetComponent(UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and self.ScrollviewPanel then
    self.ScrollviewPanel.depth = upPanel.depth + 1
  end
end

local splitor = "["
local equipname = ""

function EquipIllustrationCell:SetData(data)
  self.equipID = data
  if not data or not Table_EquipExtraction[data] then
    return
  end
  if data then
    local staticdata = Table_EquipExtraction[self.equipID]
    local itemdata = Table_Item[self.equipID]
    equipname = string.split(itemdata.NameZh, splitor)
    self.name.text = equipname and equipname[1] or equipname
    self.desc.text = staticdata.Dsc
    IconManager:SetItemIcon(itemdata.Icon, self.icon)
  end
end
