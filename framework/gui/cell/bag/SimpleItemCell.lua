local BaseCell = autoImport("BaseCell")
SimpleItemCell = class("SimpleItemCell", BaseCell)
autoImport("UIUtil")

function SimpleItemCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SimpleItemCell:FindObjs()
  self.icon = self:FindChild("Icon_Sprite"):GetComponent(UISprite)
end

function SimpleItemCell:SetData(data)
  self.data = data
  if data and not IconManager:SetItemIcon(data.staticData.Icon, self.icon) then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
end

function SimpleItemCell:SetMinDepth(minDepth)
  local ws = UIUtil.GetAllComponentsInChildren(self.gameObject, UIWidget, true)
  if ws then
    for i = 1, #ws do
      ws[i].depth = ws[i].depth + minDepth
    end
  end
end
