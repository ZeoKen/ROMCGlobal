local baseCell = autoImport("BaseCell")
NewServerSignInMapCell = class("NewServerSignInMapCell", baseCell)
NewServerSignInMapCellState = {
  Unsigned = 0,
  Signed = 1,
  Barrier = 2,
  SmallGift = 3,
  LargeGift = 4
}

function NewServerSignInMapCell:ctor(obj, day)
  self.day = day
  NewServerSignInMapCell.super.ctor(self, obj)
end

function NewServerSignInMapCell:Init()
  self:FindObjs()
  IconManager:SetUIIcon("sign_icon_signin", self:FindComponent("Bg", UISprite))
  IconManager:SetUIIcon("sign_icon_claw", self.signedGO:GetComponent(UISprite))
  IconManager:SetUIIcon("sign_icon_hindrance", self.barrierGO:GetComponent(UISprite))
  IconManager:SetUIIcon("sign_icon_S-box", self.smallGiftGO:GetComponent(UISprite))
  IconManager:SetUIIcon("sign_icon_L-box", self.largeGiftGO:GetComponent(UISprite))
  self:SwitchToState(NewServerSignInMapCellState.Unsigned)
end

function NewServerSignInMapCell:FindObjs()
  self.signedGO = self:FindGO("Signed")
  self.barrierGO = self:FindGO("Flag")
  self.smallGiftGO = self:FindGO("SmallGift")
  self.largeGiftGO = self:FindGO("LargeGift")
  self.stateGOs = {
    self.signedGO,
    self.barrierGO,
    self.smallGiftGO,
    self.largeGiftGO
  }
end

function NewServerSignInMapCell:SwitchToState(state)
  for _, obj in pairs(self.stateGOs) do
    obj:SetActive(false)
  end
  local go = self.stateGOs[state]
  if go then
    go:SetActive(true)
  end
  self.state = state
end
