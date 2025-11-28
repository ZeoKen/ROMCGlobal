local BaseCell = autoImport("BaseCell")
NewRechargeHeroToggleCell = class("NewRechargeHeroToggleCell", BaseCell)
local COLOR_INACTIVE = LuaColor.New(0.2196078431372549, 0.3215686274509804, 0.3254901960784314, 1)
local COLOR_ACTIVE = LuaColor.New(1, 1, 1, 1)

function NewRechargeHeroToggleCell:Init()
  self.toggle1Bg = self:FindGO("toggle1_bg")
  self.toggle1Checkmark = self:FindGO("toggle1_checkmark")
  self.toggle2Bg = self:FindGO("toggle2_bg")
  self.toggle2Checkmark = self:FindGO("toggle2_checkmark")
  self.className = self:FindComponent("classname", UILabel)
  self.classIcon = self:FindComponent("classicon", UISprite)
  self.new = self:FindGO("new")
  self.line = self:FindGO("line")
  local click = self:FindGO("click")
  self:AddClickEvent(click, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:SetChoose(false)
end

function NewRechargeHeroToggleCell:SetData(data)
  self.data = data
  self.className.text = data.classname
  self:UpdateNew()
  IconManager:SetNewProfessionIcon(data.classicon, self.classIcon)
end

function NewRechargeHeroToggleCell:SetChoose(b)
  self.ischoose = b
  if self.ischoose then
    self.toggle1Bg:SetActive(false)
    self.toggle1Checkmark:SetActive(true)
    self.toggle2Checkmark:SetActive(true)
    self.classIcon.color = COLOR_ACTIVE
    LuaGameObject.SetLocalScaleGO(self.toggle2Bg, 1, 1, 1)
  else
    self.toggle1Bg:SetActive(true)
    self.toggle1Checkmark:SetActive(false)
    self.toggle2Checkmark:SetActive(false)
    self.classIcon.color = COLOR_INACTIVE
    LuaGameObject.SetLocalScaleGO(self.toggle2Bg, 0.85, 0.85, 1)
  end
end

function NewRechargeHeroToggleCell:UpdateNew()
  self.new:SetActive(self.data:IsNew())
end

function NewRechargeHeroToggleCell:ActiveLine(b)
  self.line:SetActive(b)
end
