GVGBlessStatCell = class("GVGBlessStatCell", BaseCell)

function GVGBlessStatCell:Init()
  self:FindObjs()
end

function GVGBlessStatCell:FindObjs()
  self.colider = self.gameObject:GetComponent(BoxCollider)
  self.dataLabel = {}
  self.maxStar = {}
  self.data_cnt = #GvgStatData.SortableKeys
  for i = 1, self.data_cnt do
    self.dataLabel[i] = self:FindComponent("Data" .. i + 1, UILabel)
    self.maxStar[i] = self:FindGO("IsTop" .. i + 1, self.dataLabel.gameObject)
  end
end

function GVGBlessStatCell:SetData(data)
  self.data = data
  if data then
    for i = 1, self.data_cnt do
      self.dataLabel[i].text = data.GetValueByIndex and data:GetValueByIndex(i) or 0
      self.maxStar[i]:SetActive(data.IsStarByIndex and data:IsStarByIndex(i) or false)
    end
  end
end

function GVGBlessStatCell:SetColider(var)
  self.colider.enabled = var
end
