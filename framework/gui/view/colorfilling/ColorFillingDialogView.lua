autoImport("WrapCellHelper")
autoImport("TextEmojiCombineCell")
ColorFillingDialogView = class("ColorFillingDialogView", SubView)
local emojiNumPerRow = 9

function ColorFillingDialogView:Init()
  self:InitView()
end

function ColorFillingDialogView:InitView()
  self.textPanel = self:FindGO("dialogTextPanel")
  self.inputText = self:FindGO("inputText", self.textPanel)
  self.inputLabel = self.inputText:GetComponent(UIInput)
  self.inputInsertContent = self.inputText:GetComponent(UIInputInsertContent)
  local sendBtn = self:FindGO("sendBtn", self.textPanel)
  local emojiBtn = self:FindGO("emojiBtn", self.textPanel)
  self.popupWindow = self:FindGO("PopUpWindow", self.textPanel)
  local closeBtn = self:FindGO("CloseButton", self.popupWindow)
  local mask = self:FindGO("mask", self.textPanel)
  self:AddClickEvent(sendBtn, function()
    self:SetCurDialogText()
    self:HidePanel()
  end)
  self:AddClickEvent(emojiBtn, function()
    self:Show(self.popupWindow)
  end)
  self:AddClickEvent(closeBtn, function()
    self:Hide(self.popupWindow)
  end)
  self:AddClickEvent(mask, function()
    self:HidePanel()
  end)
  self.inputLabel.characterLimit = GameConfig.ColorFilling and GameConfig.ColorFilling.dialogCharacterLimit and GameConfig.ColorFilling.dialogCharacterLimit or 25
  local data = {}
  local container = self:FindGO("TextEmoji_Container", self.popupWindow)
  data.wrapObj = container
  data.pfbNum = 5
  data.cellName = "TextEmojiCombineCell"
  data.control = TextEmojiCombineCell
  data.dir = 1
  self.itemWrapHelper = WrapCellHelper.new(data)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:UpdateTextEmojiInfo()
end

function ColorFillingDialogView:ShowPanel()
  self:Show(self.textPanel)
end

function ColorFillingDialogView:HidePanel()
  self.inputLabel.value = ""
  self:Hide(self.textPanel)
end

function ColorFillingDialogView:SetCurDialogText()
  local input = self.inputLabel.value
  if not StringUtil.IsEmpty(input) then
    input = FunctionMaskWord.Me():ReplaceMaskWord(input, FunctionMaskWord.MaskWordType.Chat)
    self.container:SetCurDialogText(input)
  end
end

function ColorFillingDialogView:UpdateTextEmojiInfo()
  local datas = {}
  for index, data in ipairs(ChatRoomProxy.Instance.textEmojiData or {}) do
    local row = math.floor((index - 1) / emojiNumPerRow) + 1
    local col = math.floor((index - 1) % emojiNumPerRow) + 1
    datas[row] = datas[row] or {}
    datas[row][col] = data
  end
  self.itemWrapHelper:UpdateInfo(datas)
end

function ColorFillingDialogView:HandleClickItem(cell)
  self.inputInsertContent:InsertContent(cell.data.Emoji)
end
