local baseCell = autoImport("BaseCell")
PhotographSingleFilterText = class("PhotographSingleFilterText", baseCell)

function PhotographSingleFilterText:Init()
  self:initView()
end

function PhotographSingleFilterText:initView()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self:SetEvent(self.gameObject, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PhotographSingleFilterText:SetData(data)
  self.data = data
  if data.text then
    self.label.text = data.text
  else
    local config = Table_ScreenFilter[data.id]
    if config then
      self.label.text = config.Name
    end
  end
  if data.isSelect ~= nil then
    self:setIsSelect(data.isSelect)
  else
    self:setIsSelect(true)
  end
end

function PhotographSingleFilterText:setIsSelect(isSelect)
  self.toggle:Set(isSelect)
end

function PhotographSingleFilterText:getIsSelect()
  return self.toggle.value
end
