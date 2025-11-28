baseCell = autoImport("BaseCell")
ChooseRouteCell = class("ChooseRouteCell", baseCell)

function ChooseRouteCell:Init()
  self.bgTexture = self:FindComponent("BG", UITexture)
  self.chooseRouteBtn = self:FindGO("ChooseBtn")
  self.btnBgTexture = self.chooseRouteBtn:GetComponent(UITexture)
  self.routeLabel = self:FindComponent("Label", UILabel, self.chooseRouteBtn)
  self.routeIcon = self:FindComponent("RouteIcon", UITexture)
  self.tweenPosition = self.chooseRouteBtn:GetComponent(TweenPosition)
  self.bgtweenColor = self.chooseRouteBtn:GetComponent(TweenColor)
  self.iconTweenColor = self:FindGO("RouteIcon"):GetComponent(TweenColor)
  self.maskTweenColor = self:FindGO("Mask", self.chooseRouteBtn):GetComponent(TweenColor)
  self.labelTweenColor = self:FindGO("Label", self.chooseRouteBtn):GetComponent(TweenColor)
  PictureManager.Instance:SetUI("branch_Selection", self.bgTexture)
  PictureManager.Instance:SetUI("branch_BG", self.btnBgTexture)
  self:SetEvent(self.chooseRouteBtn, function()
    helplog("ClickCell")
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:ResetChooseState()
end

function ChooseRouteCell:ResetChooseState()
  self.tweenPosition:PlayReverse()
  self.bgtweenColor:PlayReverse()
  self.iconTweenColor:PlayReverse()
  self.maskTweenColor:PlayReverse()
  self.labelTweenColor:PlayReverse()
end

function ChooseRouteCell:SetData(data)
  self.data = data
  local menuType, name = data.menuType, data.name
  self.content = tostring(name)
  self.routeLabel.text = self.content
  self.iconPath = data.icon
  PictureManager.Instance:SetNPCLiHui(self.iconPath, self.routeIcon)
  self.routeIcon:MakePixelPerfect()
end

function ChooseRouteCell:setChoose(bool)
  if bool then
    self.tweenPosition:PlayForward()
    self.bgtweenColor:PlayForward()
    self.iconTweenColor:PlayForward()
    self.maskTweenColor:PlayForward()
    self.labelTweenColor:PlayForward()
  else
    self.tweenPosition:PlayReverse()
    self.bgtweenColor:PlayReverse()
    self.iconTweenColor:PlayReverse()
    self.maskTweenColor:PlayReverse()
    self.labelTweenColor:PlayReverse()
  end
end

function ChooseRouteCell:CancelSelectedOnShow()
  if tweenPosition then
    self.tweenPosition:PlayReverse()
    self.bgtweenColor:PlayReverse()
    self.iconTweenColor:PlayReverse()
    self.maskTweenColor:PlayReverse()
    self.labelTweenColor:PlayReverse()
  end
end

function ChooseRouteCell:OnCellDestroy()
  ChooseRouteCell.super.OnCellDestroy(self)
  PictureManager.Instance:UnLoadNPCLiHui(self.iconPath, self.routeIcon)
end
