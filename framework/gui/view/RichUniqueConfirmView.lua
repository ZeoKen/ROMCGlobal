autoImport("SpriteLabel")
local UniqueConfirmView = autoImport("UniqueConfirmView")
RichUniqueConfirmView = class("RichUniqueConfirmView", UniqueConfirmView)
RichUniqueConfirmView.ViewType = UIViewType.ConfirmLayer

function RichUniqueConfirmView:FindObjs()
  RichUniqueConfirmView.super.FindObjs(self)
  self.contentLabel = Game.GameObjectUtil:DeepFindChild(self.gameObject, "ContentLabel"):GetComponent(UIRichLabel)
  self.contentSpriteLabel = SpriteLabel.CreateAsTable()
  self.contentSpriteLabel:Init(self.contentLabel, nil, 30, 30, true)
end

function RichUniqueConfirmView:FillContent(text)
  text = text or self.viewdata.content
  local patTai = OverSea.LangManager.Instance():GetLangByKey(ZhString.LangSwitchPanel_Thai)
  if text ~= nil then
    if string.match(text, patTai) then
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.thaiFont
    else
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.confirmLabel.bitmapFont
    end
    if self.viewdata.lockreason then
      self.contentSpriteLabel:SetText(text .. "\n" .. self.viewdata.lockreason, true)
    else
      self.contentSpriteLabel:SetText(text, true)
    end
    self:ResizeView()
  end
end
