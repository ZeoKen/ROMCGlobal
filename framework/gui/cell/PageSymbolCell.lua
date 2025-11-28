PageSymbolCell = class("PageSymbolCell", BaseCell)

function PageSymbolCell:Init()
  PageSymbolCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function PageSymbolCell:FindObjs()
  self.togSelect = self.gameObject:GetComponent(UIToggle)
end

function PageSymbolCell:AddEvts()
end

function PageSymbolCell:SetData(data)
  self.index = data
end

function PageSymbolCell:Select(isSelect)
  self.togSelect.value = isSelect == nil and true or isSelect
end
