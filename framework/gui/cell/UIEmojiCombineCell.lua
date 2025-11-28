autoImport("BaseCombineCell")
autoImport("UIEmojiCell")
UIEmojiCombineCell = class("UIEmojiCombineCell", BaseCombineCell)

function UIEmojiCombineCell:Init()
  self:InitCells(2, "UIEmojiCell", UIEmojiCell)
end
