local BaseCell = autoImport("BaseCell")
WarbandWinsCell = class("WarbandWinsCell", BaseCell)

function WarbandWinsCell:Init()
  self:FindObj()
end

function WarbandWinsCell:FindObj()
  self.grid = self.gameObject:GetComponent(UIGrid)
  self.stars = {}
  self.stars[1] = self:FindGO("star1")
  self.stars[1]:SetActive(false)
  self.stars[2] = self:FindGO("star2")
  self.stars[2]:SetActive(false)
end

function WarbandWinsCell:SetData(data)
  self.data = data
  if data and 0 < data then
    self.stars[1]:SetActive(false)
    self.stars[2]:SetActive(false)
    for i = 1, data do
      if self.stars[i] then
        self.stars[i]:SetActive(true)
      end
    end
    self.grid:Reposition()
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function WarbandWinsCell:OnDestroy()
end
