local baseCell = autoImport("BaseCell")
MessageBoardCombineCell = class("MessageBoardCombineCell", baseCell)
autoImport("MessageBoardCell")

function MessageBoardCombineCell:Init()
  self:FindObjs()
end

function MessageBoardCombineCell:FindObjs()
end
