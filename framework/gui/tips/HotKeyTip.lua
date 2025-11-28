HotKeyTip = class("HotKeyTip", BaseTip)
local BASE_DEPTH = 100

function HotKeyTip:ctor(prefab, parent, side, offset, scale, depth)
  self.parent = parent
  self.side = side
  self.offset = offset
  self.scale = scale
  self.depth = depth
  HotKeyTip.super.ctor(self, prefab, parent)
  self:InitTip()
end

function HotKeyTip:InitTip()
  self.hotKeyLabel = self:FindComponent("Label", UILabel)
  self.bg1 = self:FindComponent("Bg1", UISprite)
  self.bg2 = self:FindComponent("Bg2", UISprite)
  local pos = NGUIUtil.GetAnchorPoint(nil, self.parent, self.side, self.offset)
  self:SetPos(pos)
  self:SetScale(self.scale)
  if self.parent then
    local widgets = self.parent.gameObject:GetComponentsInChildren(UIWidget)
    if widgets then
      local depth = self.depth or 0
      for i = 1, #widgets do
        depth = math.max(depth, widgets[i].depth)
      end
      self.bg1.depth = depth + BASE_DEPTH + 1
      self.bg2.depth = depth + BASE_DEPTH + 1
      self.hotKeyLabel.depth = depth + BASE_DEPTH + 2
    end
  end
end

function HotKeyTip:SetData(hotKey, state)
  self.hotKey = hotKey ~= "None" and hotKey or ""
  local displayConf = Game.WindowsHotKeyDisplay[hotKey]
  local display = not (not displayConf or StringUtil.IsEmpty(displayConf.Display)) and displayConf.Display or hotKey
  self.hotKeyLabel.text = display
  local isLong = 2 < #display
  self.bg1.gameObject:SetActive(not isLong)
  self.bg2.gameObject:SetActive(isLong)
  self:SetState(state)
end

function HotKeyTip:SetState(state)
  if not StringUtil.IsEmpty(self.hotKey) and state then
    self:Show()
  else
    self:Hide()
  end
end

function HotKeyTip:SetScale(scale)
  if scale then
    scale[3] = scale[3] or 1
    LuaGameObject.SetLocalScaleGO(self.gameObject, scale[1], scale[2], scale[3])
  end
end

function HotKeyTip:Show()
  self.gameObject:SetActive(true)
end

function HotKeyTip:Hide()
  self.gameObject:SetActive(false)
end
