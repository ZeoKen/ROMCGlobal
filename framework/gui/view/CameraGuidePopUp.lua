CameraGuidePopUp = class("CameraGuidePopUp", BaseView)
CameraGuidePopUp.ViewType = UIViewType.PopUpLayer
local texName_Guide = "set_bg_pic"
local texName_Hand = "set_bg_hand"

function CameraGuidePopUp:Init()
  self:FindObj()
  self:AddViewEvts()
  self:InitView()
end

function CameraGuidePopUp:FindObj()
  local l_objContent = self:FindGO("Content")
  self.tsfContent = l_objContent.transform
  self.panelSelf = self.gameObject:GetComponent(UIPanel)
  self.texGuide = self:FindComponent("TexGuide", UITexture, l_objContent)
  self.texHand = self:FindComponent("TexHand", UITexture, l_objContent)
  local l_objLeftHand = self:FindGO("labLeftHand", l_objContent)
  self.labLeftHand = l_objLeftHand:GetComponent(UILabel)
  self.wgtLeftBG = self:FindComponent("bg", UIWidget, l_objLeftHand)
  local l_objRightHand = self:FindGO("labRightHand")
  self.labRightHand = l_objRightHand:GetComponent(UILabel)
  self.wgtRightBG = self:FindComponent("bg", UIWidget, l_objRightHand)
  self.labCloseTip = self:FindComponent("labCloseTip", UILabel, l_objContent)
end

function CameraGuidePopUp:AddViewEvts()
  self:AddClickEvent(self:FindGO("BgMask"), function()
    self:FadeOut()
  end)
end

function CameraGuidePopUp:InitView()
  self.labLeftHand.text = ZhString.CameraGuide_LeftHand
  self.wgtLeftBG:ResetAndUpdateAnchors()
  self.labRightHand.text = ZhString.CameraGuide_RightHand
  self.wgtRightBG:ResetAndUpdateAnchors()
  self.labCloseTip.text = ZhString.CameraGuide_CloseTip
  local rootSize = UIManagerProxy.Instance:GetUIRootSize()
  local perfectRatio = 1.7777777777777777
  local lowerRatio = 2.1653333333333333
  local curRatio = rootSize[1] / rootSize[2]
  local scale = 1 - 0.15 * math.clamp((curRatio - perfectRatio) / (lowerRatio - perfectRatio), 0, 1)
  self.tsfContent.localScale = LuaGeometry.GetTempVector3(scale, scale, 1)
end

function CameraGuidePopUp:FadeIn()
  self.panelSelf.alpha = 0
  TweenAlpha.Begin(self.gameObject, 0.5, 1)
end

function CameraGuidePopUp:FadeOut()
  if self.isClosing then
    return
  end
  self.isClosing = true
  TweenAlpha.Begin(self.gameObject, 0.5, 0):SetOnFinished(function()
    self.isClosing = false
    self:CloseSelf()
  end)
end

function CameraGuidePopUp:OnEnter()
  CameraGuidePopUp.super.OnEnter(self)
  self.isClosing = false
  PictureManager.Instance:SetUI(texName_Guide, self.texGuide)
  PictureManager.Instance:SetUI(texName_Hand, self.texHand)
  self:FadeIn()
end

function CameraGuidePopUp:OnExit()
  PictureManager.Instance:UnLoadUI(texName_Guide, self.texGuide)
  PictureManager.Instance:UnLoadUI(texName_Hand, self.texHand)
  CameraGuidePopUp.super.OnExit(self)
end
