autoImport("PushBaseCell")
autoImport("SpriteLabel")
FloatMessage = class("FloatMessage", PushBaseCell)
FloatMessage.resID = ResourcePathHelper.UICell("FloatMessage")

function FloatMessage:ctor(parent, cellType)
  self.speed = 300
  self.previous = nil
  self.follow = nil
  self.floating = false
  self.targetY = 0
  self.resID = FloatMessage.resID
  self.cellType = cellType
  self.iconSize = 30
  self.defineWidth = nil
  if cellType == 1 then
    self.resID = ResourcePathHelper.UICell("FloatMessage_S1")
    self.iconSize = 28
    self.defineWidth = 9999
  elseif cellType == 2 then
    self.resID = ResourcePathHelper.UICell("FloatMessage_S2")
    self.iconSize = 28
    self.defineWidth = 9999
  elseif cellType == 3 then
    self.resID = ResourcePathHelper.UICell("FloatMessage_S3")
    self.iconSize = 28
  elseif cellType == 4 then
    self.resID = ResourcePathHelper.UICell("FloatMessage_S4")
  end
  self.gameObject = self:CreateObj(parent)
  self:Init()
end

function FloatMessage:Init()
  self.msg = self:FindGO("MessageContent"):GetComponent(UILabel)
  self.spriteLabel = SpriteLabel.CreateAsTable()
  self.spriteLabel:Init(self.msg, self.defineWidth, self.iconSize, self.iconSize, true)
  self.bg = Game.GameObjectUtil:DeepFindChild(self.gameObject, "Bg"):GetComponent(UISprite)
end

function FloatMessage:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(self.resID, parent)
end

function FloatMessage:Destroy()
  self.data = nil
  if self.spriteLabel then
    self.spriteLabel:Destroy()
    self.spriteLabel = nil
  end
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
end

function FloatMessage:SetY(y)
  local pos = self.gameObject.transform.localPosition
  pos.y = y
  self.gameObject.transform.localPosition = pos
end

function FloatMessage:GetY()
  local x, y, z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
  return y
end

function FloatMessage:GetH()
  if self.cellType == 1 then
    return self.bg.height + 32
  elseif self.cellType == 2 then
    return self.bg.height + 30
  elseif self.cellType == 3 then
    return self.bg.height + 32
  else
    return self.bg.height
  end
end

function FloatMessage:_SetText(text)
  text = Game.simpleReplace(text)
  if self.spriteLabel then
    self.spriteLabel:SetText(text, false)
  else
    self.msg.text = text
  end
end

function FloatMessage:_AddSprites()
  if self.spriteLabel then
    self.spriteLabel:AddSprites()
  end
  self:ResetBgWidthHeight()
end

function FloatMessage:SetMsg(text)
  if self.cellType == 3 then
    self:_SetText(text)
    UIUtil.FitLabelHeight(self.msg, 480)
  else
    self:_SetText(text)
  end
  self:_AddSprites()
  if self.cellType == 3 then
    self.msg.overflowMethod = 3
    self.msg.width = 480
    UIUtil.CenterLabelLine(self.msg)
  end
end

function FloatMessage:SetMsgCenterAlign(text)
  self:_SetText(text)
  UIUtil.CenterLabelLine(self.msg)
  self:_AddSprites()
end

function FloatMessage:ResetBgWidthHeight()
  if self.cellType == 1 then
    self.bg.width = math.max(self.msg.width + 55, 195)
  elseif self.cellType == 2 then
    self.bg.width = math.max(self.msg.width + 28, 130)
  elseif self.cellType == 3 then
    self.bg.width = math.max(self.msg.width + 28, 215)
    self.bg.height = self.msg.height + 28
  else
    self.bg.width = self.msg.width + 78
    self.bg.height = self.msg.height + 57
  end
end

function FloatMessage:Parsed()
  return self.data == nil or self.data.parsed == true
end

function FloatMessage:NextToPush()
  self.data.parsed = true
  if self.data.params ~= nil and type(self.data.params) == "table" then
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, unpack(self.data.params))
  else
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, self.data.params)
  end
  self:SetMsg(self.data.text)
end
