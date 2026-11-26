SceneKickCountBar = class("SceneKickCountBar")
SceneKickCountBar.Kind = {Wall = "wall", Entity = "entity"}
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function SceneKickCountBar:Create(gameObject)
  local self = SceneKickCountBar.new()
  self.gameObject = gameObject
  self.frameLayout = func_deepFind(_gameUtilInstance, gameObject, "FrameLayout")
  self.wallProto = func_deepFind(_gameUtilInstance, gameObject, "WallProto")
  self.entityProto = func_deepFind(_gameUtilInstance, gameObject, "EntityProto")
  self.wallIcons = {}
  self.entityIcons = {}
  if self.wallProto then
    self.wallProto:SetActive(false)
  end
  if self.entityProto then
    self.entityProto:SetActive(false)
  end
  return self
end

function SceneKickCountBar:GetProto(kind)
  if kind == SceneKickCountBar.Kind.Wall then
    return self.wallProto
  end
  if kind == SceneKickCountBar.Kind.Entity then
    return self.entityProto
  end
  return nil
end

function SceneKickCountBar:GetIcons(kind)
  if kind == SceneKickCountBar.Kind.Wall then
    return self.wallIcons
  end
  return self.entityIcons
end

function SceneKickCountBar:SetType(kind)
  if self.kind == kind then
    return
  end
  self:ClearIcons()
  self.kind = kind
end

local function _FindFirstImage(go)
  if go == nil or LuaGameObject.ObjectIsNull(go) then
    return nil
  end
  if go:GetComponent(Image) ~= nil then
    return go
  end
  local t = go.transform
  if t == nil then
    return nil
  end
  for i = 0, t.childCount - 1 do
    local deeper = _FindFirstImage(t:GetChild(i).gameObject)
    if deeper ~= nil then
      return deeper
    end
  end
  return nil
end

function SceneKickCountBar:_FindTemplate(proto)
  return _FindFirstImage(proto)
end

function SceneKickCountBar:ClearIcons()
  local icons = self:GetIcons(self.kind)
  if icons == nil then
    return
  end
  for i = 1, #icons do
    local icon = icons[i]
    if icon and not LuaGameObject.ObjectIsNull(icon) then
      LuaGameObject.DestroyObject(icon)
    end
    icons[i] = nil
  end
end

function SceneKickCountBar:SetCount(cur, maxCount)
  if self.kind == nil then
    return
  end
  local proto = self:GetProto(self.kind)
  if proto == nil then
    return
  end
  local icons = self:GetIcons(self.kind)
  local count = tonumber(maxCount) or 0
  local parent = self.frameLayout and self.frameLayout.transform or proto.transform.parent
  if parent == nil then
    return
  end
  for i = #icons + 1, count do
    local template = self:_FindTemplate(proto)
    if template == nil or LuaGameObject.ObjectIsNull(template) then
      break
    end
    local icon = GameObject.Instantiate(template)
    icon.transform:SetParent(parent, false)
    icon:SetActive(true)
    icons[i] = icon
  end
  for i = count + 1, #icons do
    local icon = icons[i]
    if icon and not LuaGameObject.ObjectIsNull(icon) then
      LuaGameObject.DestroyObject(icon)
    end
    icons[i] = nil
  end
  local remain = tonumber(cur) or 0
  for i = 1, #icons do
    local icon = icons[i]
    if icon and not LuaGameObject.ObjectIsNull(icon) then
      icon:SetActive(i <= remain)
    end
  end
end

function SceneKickCountBar:Destroy()
  self:ClearIcons()
  self.wallIcons = nil
  self.entityIcons = nil
  self.wallProto = nil
  self.entityProto = nil
  self.gameObject = nil
  self.frameLayout = nil
  self.kind = nil
end
