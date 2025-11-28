local BaseCell = autoImport("BaseCell")
SetViewSystemPushToggleCell = class("SetViewSystemPushToggleCell", BaseCell)

function SetViewSystemPushToggleCell:Init()
  self.tog = self.gameObject:GetComponentInChildren(UIToggle)
  self.label = self.gameObject:GetComponentInChildren(UILabel)
  self.toggleTween = self.gameObject:GetComponentInChildren(UIPlayTween)
end

function SetViewSystemPushToggleCell:SetData(data)
  self.data = data
  self.label.text = data.name
  self:SetValid()
  self.gameObject:SetActive(self.valid)
end

function SetViewSystemPushToggleCell:SetValid()
  local key = self.data.key
  self.valid = true
  if key == "Auction" then
    self.valid = FunctionUnLockFunc.checkFuncStateValid(121)
  elseif key == "Guild" then
    self.valid = FunctionUnLockFunc.checkFuncStateValid(4)
  elseif key == "Polly" then
    self.valid = FunctionUnLockFunc.checkFuncStateValid(17)
  elseif key == "Bigcat" then
    self.valid = FunctionUnLockFunc.checkFuncStateValid(3)
  end
end
