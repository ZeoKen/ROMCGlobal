local _AttrGemCount = 3
GemEmbedDescCell = class("GemEmbedDescCell", BaseCell)

function GemEmbedDescCell:Init()
  self.descLab = self:FindComponent("Desc", UILabel)
  self.descLab.text = ZhString.Gem_EmbedDesc
  self.typeNumMap = {}
  for i = 1, _AttrGemCount do
    self.typeNumMap[i] = self:FindComponent("NeedNum" .. i, UILabel)
  end
end

function GemEmbedDescCell:SetPage(pageData)
  self.pageData = pageData
  self:SetData()
end

function GemEmbedDescCell:SetData()
  if not self.pageData then
    return
  end
  for i = 1, _AttrGemCount do
    self.typeNumMap[i].text = self.pageData:GetAttrGemCountByType(i) .. "/" .. self.pageData:GetEmbedAttrGemCountByType(i)
  end
end
