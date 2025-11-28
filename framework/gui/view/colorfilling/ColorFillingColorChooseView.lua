ColorFillingColorChooseView = class("ColorFillingColorChooseView", SubView)
local colorWheelTexName = "Disney_Comics_color-ring"
local colorWheelBgName = "Disney_Comics_color-ring2"

function ColorFillingColorChooseView:Init()
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.touchSupported = Input.touchSupported
  local layer = LayerMask.NameToLayer("UI")
  self.camera = NGUITools.FindCameraForLayer(layer)
  self:InitView()
end

function ColorFillingColorChooseView:InitView()
  self.colorChoosePanel = self:FindGO("colorChoosePanel")
  self.pickColorSp = self:FindComponent("pickColor", UISprite, self.colorChoosePanel)
  self.colorWheelGo = self:FindGO("colorWheel", self.colorChoosePanel)
  self.colorWheel = self.colorWheelGo:GetComponent(UITexture)
  self.wheelBg = self:FindComponent("wheelBg", UITexture, self.colorWheelGo)
  self.cursor = self:FindGO("cursor", self.colorWheelGo)
  local guideBtn = self:FindGO("guideBtn", self.colorWheelGo)
  self:AddClickEvent(guideBtn, function()
    self:OnColorWheelClick()
  end)
  self:AddClickEvent(self.colorWheelGo, function()
    self:OnColorWheelClick()
  end)
  local confirmBtn = self:FindGO("confirmBtn", self.colorChoosePanel)
  local cancelBtn = self:FindGO("cancelBtn", self.colorChoosePanel)
  self:AddClickEvent(confirmBtn, function()
    self:OnColorChooseConfirm()
  end)
  self:AddClickEvent(cancelBtn, function()
    self:Hide(self.colorChoosePanel)
  end)
  self:Hide(self.cursor)
  local wheelPos = self.colorWheelGo.transform.localPosition
  local x = wheelPos.x - self.colorWheel.width * 0.5
  local y = wheelPos.y - self.colorWheel.height * 0.5
  self.wheelBottomLeft = LuaVector3(x, y, 0)
  self:AddOrRemoveGuideId(confirmBtn, 305)
  self:AddOrRemoveGuideId(guideBtn, 304)
end

function ColorFillingColorChooseView:OnEnter()
  PictureManager.Instance:SetColorFillingTexture(colorWheelTexName, self.colorWheel)
  PictureManager.Instance:SetColorFillingTexture(colorWheelBgName, self.wheelBg)
end

function ColorFillingColorChooseView:OnExit()
  PictureManager.Instance:UnloadColorFillingTexture(colorWheelTexName, self.colorWheel)
  PictureManager.Instance:UnloadColorFillingTexture(colorWheelBgName, self.wheelBg)
end

function ColorFillingColorChooseView:ShowPanel()
  self:Show(self.colorChoosePanel)
end

function ColorFillingColorChooseView:OnColorWheelClick()
  local texture = self.colorWheel.mainTexture
  if not texture then
    return
  end
  local color, worldPos = self:GetTexturePixelColor(texture)
  if color and color.a == 1 then
    self.pickColor = color
    self.pickColorSp.color = self.pickColor
    if worldPos then
      self:Show(self.cursor)
      self.cursor.transform.position = worldPos
    end
  end
end

function ColorFillingColorChooseView:OnColorChooseConfirm()
  if not self.pickColor then
    MsgManager.ShowMsgByID(41453)
    return
  end
  self.container:OnColorChooseConfirm(self.pickColor)
  self:Hide(self.colorChoosePanel)
end

function ColorFillingColorChooseView:GetTexturePixelColor(texture)
  local screenPos
  if self.isRunOnEditor or self.isRunOnWindows then
    screenPos = Input.mousePosition
  elseif self.touchSupported then
    local touch = Input.GetTouch(0)
    screenPos = touch.position
  end
  if screenPos then
    local worldPos = self.camera:ScreenToWorldPoint(screenPos)
    local localPos = self.colorWheelGo.transform:InverseTransformPoint(worldPos)
    local x = math.floor(localPos.x - self.wheelBottomLeft[1])
    local y = math.floor(localPos.y - self.wheelBottomLeft[2])
    local color = texture:GetPixel(x, y)
    return color, worldPos
  end
end
