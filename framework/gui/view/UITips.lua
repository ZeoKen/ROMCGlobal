local UITips = class("Charactor", BaseView)

function UITips:Init()
  self.contentLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "contentLabel"):GetComponent(UILabel)
end

function UITips:SetString(value)
  if self.contentLabel ~= nil then
    self.contentLabel.text = tostring(value)
  end
end

return UITips
