local _LockNum_1 = "x1"
local _LockNum_2 = "x2"
local _LayerColor = LuaColor.New(1.0, 0.8745098039215686, 0.1450980392156863, 1)
local _LayerLockColor = LuaColor.New(0.5215686274509804, 0.4196078431372549, 0.18823529411764706, 1)
local _LayerCopyColor = LuaColor.New(0.5647058823529412, 0.37254901960784315, 0.12941176470588237, 1)
local _LayerCopyLockColor = LuaColor.New(0.30980392156862746, 0.20392156862745098, 0.07058823529411765, 1)
local _LayerBgColor = LuaColor.New(0.7294117647058823, 0.4980392156862745, 0.2, 1)
local _LayerBgLockColor = LuaColor.New(0.4, 0.27450980392156865, 0.10980392156862745, 1)
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
TopicLayerCell = class("TopicLayerCell", BaseCell)

function TopicLayerCell:Init()
  self.tipData = {}
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.effectRoot = self:FindGO("EffectRoot")
  self.layerLab = self:FindComponent("LayerLab", UILabel)
  self.layerBg = self:FindComponent("Sprite", UISprite, self.layerLab.gameObject)
  self.layerCopyLab = self:FindComponent("Label", UILabel, self.layerLab.gameObject)
  self.layerFinishedObj = self:FindGO("LayerFinished")
  self.lockedObj = self:FindGO("Locked")
  self.lockLab = self:FindComponent("Label", UILabel, self.lockedObj)
  self:SetEvent(self.bgTexture.gameObject, function()
    GameFacade.Instance:sendNotification(TopicEvent.ClickLayer, self.tipData)
  end)
end

function TopicLayerCell:SetData(data, index)
  if not data then
    return
  end
  local staticData = data.staticData
  self.texName = staticData.Texture
  PictureManager.Instance:SetSignIn(self.texName, self.bgTexture)
  local layer = staticData.id
  local num = tonumber(string.sub(staticData.Texture, -2))
  local numPosConfig = GameConfig.Topic.layerPos.Num[num]
  self.layerLab.text = tostring(layer)
  self.layerCopyLab.text = tostring(layer)
  _SetLocalPositionGO(self.layerLab.gameObject, numPosConfig[1], numPosConfig[2], 0)
  local price = GameConfig.Topic.unlockTowerLayerStar
  local unlockStar = price * layer
  local own = MyselfProxy.Instance:GetServantStarCount()
  local locked = unlockStar > own
  local colorFunc = locked and ColorUtil.GrayUIWidget or ColorUtil.WhiteUIWidget
  colorFunc(self.bgTexture)
  local challengeTowerLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_CHALLENGE_ENDLESS) or 0
  local layerFinished = layer <= challengeTowerLayer
  self.layerFinishedObj:SetActive(layerFinished)
  self.lockedObj:SetActive(locked)
  if locked then
    self.layerLab.color = _LayerLockColor
    self.layerCopyLab.color = _LayerCopyLockColor
    self.layerBg.color = _LayerBgLockColor
    self.lockLab.text = 2 <= unlockStar - own and _LockNum_2 or _LockNum_1
  else
    self.layerLab.color = _LayerColor
    self.layerBg.color = _LayerBgColor
    self.layerCopyLab.color = _LayerCopyColor
  end
  self.tipData.staticData = staticData
  self.tipData.layerFinished = layerFinished
  self.tipData.locked = locked
  self.tipData.index = index
  if layerFinished then
    self.tipData.isNext = false
  else
    self.tipData.isNext = challengeTowerLayer + 1 == layer
  end
end

function TopicLayerCell:PlayUIEff()
  self:PlayUIEffect(EffectMap.UI.Topic_layerUnlock, self.effectRoot)
end

function TopicLayerCell:OnDestroy()
  PictureManager.Instance:UnLoadSignIn(self.texName, self.bgTexture)
end
