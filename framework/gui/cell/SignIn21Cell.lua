local baseCell = autoImport("BaseCell")
SignIn21Cell = class("SignIn21Cell", baseCell)
local texPrefix = "DevelopFor21_"
local picManager
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
local _LayerColor = LuaColor.New(1.0, 0.8745098039215686, 0.1450980392156863, 1)
local _LayerLockColor = LuaColor.New(0.5215686274509804, 0.4196078431372549, 0.18823529411764706, 1)
local _LayerCopyColor = LuaColor.New(0.5647058823529412, 0.37254901960784315, 0.12941176470588237, 1)
local _LayerCopyLockColor = LuaColor.New(0.30980392156862746, 0.20392156862745098, 0.07058823529411765, 1)
local _LayerBgColor = LuaColor.New(0.7294117647058823, 0.4980392156862745, 0.2, 1)
local _LayerBgLockColor = LuaColor.New(0.4, 0.27450980392156865, 0.10980392156862745, 1)
SignIn21CellState = {
  Locked = 0,
  Unsigned = 1,
  Signed = 2
}

function SignIn21Cell:ctor(obj, day)
  if not picManager then
    picManager = PictureManager.Instance
  end
  self.day = day
  self.texName = texPrefix .. string.format("%02d", day)
  SignIn21Cell.super.ctor(self, obj)
end

function SignIn21Cell:Init()
  self.bg = self:FindComponent("Bg", UITexture)
  self.signed = self:FindGO("Signed")
  self.locked = self:FindGO("Locked")
  self.lockedBg = self:FindComponent("LockedBg", UITexture)
  self:InitIndexLab()
  self:AddGameObjectComp()
  self:SwitchToState(SignIn21CellState.Locked)
  picManager:SetSignIn(self.texName, self.bg)
  picManager:SetSignIn(self.texName, self.lockedBg)
  local lockCfg = GameConfig.NoviceTargetPointCFG.LockPosition
  lockCfg = lockCfg and lockCfg[self.day]
  self.locked.transform.localPosition = LuaGeometry.GetTempVector3(lockCfg and lockCfg[1], lockCfg and lockCfg[2])
end

function SignIn21Cell:InitIndexLab()
  self.layerLab = self:FindComponent("LayerLab", UILabel)
  self.layerBg = self:FindComponent("Sprite", UISprite, self.layerLab.gameObject)
  self.layerCopyLab = self:FindComponent("Label", UILabel, self.layerLab.gameObject)
  self.layerLab.text = tostring(self.day)
  self.layerCopyLab.text = tostring(self.day)
  local numPosConfig = GameConfig.Topic.layerPos.Num[self.day]
  _SetLocalPositionGO(self.layerLab.gameObject, numPosConfig[1], numPosConfig[2], 0)
end

function SignIn21Cell:SwitchToState(state)
  self.state = state
  local locked = state == SignIn21CellState.Locked
  self.signed:SetActive(state == SignIn21CellState.Signed)
  self.locked:SetActive(locked)
  self.lockedBg.gameObject:SetActive(locked)
  if locked then
    self.layerLab.color = _LayerLockColor
    self.layerCopyLab.color = _LayerCopyLockColor
    self.layerBg.color = _LayerBgLockColor
  else
    self.layerLab.color = _LayerColor
    self.layerCopyLab.color = _LayerCopyColor
    self.layerBg.color = _LayerBgColor
  end
end

function SignIn21Cell:OnDestroy()
  picManager:UnLoadSignIn(self.texName, self.bg)
  picManager:UnLoadSignIn(self.texName, self.lockedBg)
end
