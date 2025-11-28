autoImport("SpriteText")
SceneFloatMessage = reusableClass("SceneFloatMessage")
SceneFloatMessage.PoolSize = 20
SceneFloatMessageType = {
  Text = "SceneFloatMessageType_Text",
  Exp = "SceneFloatMessageType_Exp",
  Item = "SceneFloatMessageType_Item",
  TwelvePVPGold = "SceneFloatMessageType_TwelvePVPGold"
}
SceneFloatMessage.LabelColor = {
  Text = {
    LuaColor.New(0.7372549019607844, 0.7372549019607844, 0.7372549019607844),
    LuaColor.New(0.11764705882352941, 0.11764705882352941, 0.11764705882352941)
  },
  Exp = {
    LuaColor.New(0.8627450980392157, 0.6352941176470588, 0.4823529411764706),
    LuaColor.New(0.23921568627450981, 0.15294117647058825, 0.09803921568627451)
  },
  Item = {
    {
      LuaColor.New(0.7372549019607844, 0.7372549019607844, 0.7372549019607844),
      LuaColor.New(0.07058823529411765, 0.10588235294117647, 0.11372549019607843)
    },
    {
      LuaColor.New(0.396078431372549, 0.9921568627450981, 0.8627450980392157),
      LuaColor.New(0.10588235294117647, 0.20784313725490197, 0.08627450980392157)
    },
    {
      LuaColor.New(0.3254901960784314, 0.7725490196078432, 1.0),
      LuaColor.New(0.10588235294117647, 0.09803921568627451, 0.21176470588235294)
    },
    {
      LuaColor.New(0.788235294117647, 0.32941176470588235, 1.0),
      LuaColor.New(0.01568627450980392, 0.08235294117647059, 0.21176470588235294)
    },
    {
      LuaColor.New(1.0, 0.7254901960784313, 0.19215686274509805),
      LuaColor.New(0.2549019607843137, 0.15294117647058825, 0.023529411764705882)
    }
  },
  TwelvePVPGold = {
    LuaColor.New(0.9529411764705882, 0.9254901960784314, 0.5803921568627451),
    LuaColor.New(1.0, 0.7686274509803922, 0)
  }
}
SceneFloatMessage.ResID = ResourcePathHelper.UIPrefab_Cell("SceneFloatMessage")
local _FindComponent = UIUtil.FindComponent
local tempRot = LuaQuaternion()
local tempV3 = LuaVector3()

function SceneFloatMessage:CreatePerfab(parent)
  if self.gameObject == nil then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneFloatMessage.ResID, parent)
    self.transform = self.gameObject.transform
  end
  if self.gameObject and self.transform then
    self.gameObject:GetComponent(Animator):Play("SceneFloatMessage", -1, 0)
    self.transform.localPosition = LuaGeometry.Const_V3_zero
    local randomZ = math.random(-10, 10)
    tempV3[3] = randomZ
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
    self.transform.localRotation = tempRot
  end
end

local color1 = LuaColor.White()
local color2 = LuaColor.White()

function SceneFloatMessage:RefreshInfo()
  if Slua.IsNull(self.spriteText) then
    return
  end
  if self.effectGradientColors == nil then
    self.effectGradientColors = {}
    self.effectGradientColors[1] = GradientColorKey(color1, 0)
    self.effectGradientColors[2] = GradientColorKey(color2, 1)
  end
  local dtype = self.data_dtype
  if dtype and dtype == SceneFloatMessageType.Exp then
    self.effectGradientColors[1].color = SceneFloatMessage.LabelColor.Exp[1]
    self.shadow.effectColor = SceneFloatMessage.LabelColor.Exp[2]
  elseif dtype and dtype == SceneFloatMessageType.TwelvePVPGold then
    self.effectGradientColors[1].color = SceneFloatMessage.LabelColor.TwelvePVPGold[1]
    self.effectGradientColors[2].color = SceneFloatMessage.LabelColor.TwelvePVPGold[2]
    self.shadow.effectColor = SceneFloatMessage.LabelColor.TwelvePVPGold[2]
  else
    self.effectGradientColors[1].color = SceneFloatMessage.LabelColor.Text[1]
    self.shadow.effectColor = SceneFloatMessage.LabelColor.Text[2]
  end
  self.uguiGradient.EffectGradient.colorKeys = self.effectGradientColors
  local msg = self.data_msg
  local param = self.data_param
  local typeParam = type(param)
  local msgText = msg
  if typeParam == "table" then
    msgText = MsgParserProxy.Instance:TryParse(msgText, unpack(param))
  elseif typeParam ~= "nil" then
    msgText = string.format(msgText, tostring(param))
  end
  self.spriteText:SetValue(msgText)
end

function SceneFloatMessage:SetActive(visible)
  if not self.canvasGroup then
    return
  end
  self.canvasGroup.alpha = visible and 1 or 0
end

function SceneFloatMessage:IsHide()
  return self.canvasGroup.alpha == 0
end

function SceneFloatMessage:RemoveLeanTween()
  if self.lt then
    self.lt:Destroy()
  end
  self.lt = nil
end

function SceneFloatMessage:DoConstruct(asArray, param)
  self:SetData(param)
end

function SceneFloatMessage:SetData(param)
  self.data_dtype = param[2]
  self.data_msg = param[3]
  self.data_param = param[4]
  self:CreatePerfab(param[1])
  self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)
  if not Slua.IsNull(self.gameObject) then
    local msgText = _FindComponent("Label", EmojiText, self.gameObject)
    self.spriteText = SpriteText.new(msgText)
    self.uguiGradient = _FindComponent("Label", UGUIGradient, self.gameObject)
    self.shadow = _FindComponent("Label", Shadow, self.gameObject)
  end
  self:SetActive(true)
  self:RefreshInfo()
  self:RemoveLeanTween()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:SetActive(false)
  end, self)
end

function SceneFloatMessage:DoDeconstruct(asArray)
  if not Slua.IsNull(self.gameObject) then
    if self.spriteText then
      self.spriteText:Destroy()
      self.spriteText = nil
    end
    self.uguiGradient = nil
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneFloatMessage.ResID, self.gameObject)
  end
  self.canvasGroup = nil
  self.gameObject = nil
  self.transform = nil
  self:RemoveLeanTween()
  self.data_dtype = nil
  self.data_msg = nil
  self.data_param = nil
end
