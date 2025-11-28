autoImport("HotKeyTip")
HotKeyTipManager = class("HotKeyTipManager")
HotKeyTipManager.Instance = nil
HotKeyTipManager.TipLevel = {
  ALL = 0,
  SIMPLE = 1,
  CLOSE = 2
}
local SAVE_KEY = "WindowsHotKeyTipLevel"

function HotKeyTipManager:ctor()
  HotKeyTipManager.Instance = self
  self:Init()
end

function HotKeyTipManager:Init()
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  self:LoadTipLevel()
  self.hotKeyTips = {}
end

function HotKeyTipManager:LoadTipLevel()
  self.tipLevel = FunctionPlayerPrefs.Me():GetInt(SAVE_KEY, HotKeyTipManager.TipLevel.ALL, false)
end

function HotKeyTipManager:SaveTipLevel()
  FunctionPlayerPrefs.Me():SetInt(SAVE_KEY, self.tipLevel, false)
end

function HotKeyTipManager:SetTipLevel(level)
  self.tipLevel = level
  for id, tips in pairs(self.hotKeyTips) do
    local state = self:GetHotKeyTipState(id)
    for ui, tip in pairs(tips) do
      if LuaGameObject.ObjectIsNull(ui) then
        self:RemoveHotKeyTip(id, ui)
      else
        tip:SetState(state)
      end
    end
  end
end

function HotKeyTipManager:GetTipLevel()
  return self.tipLevel
end

function HotKeyTipManager:RegisterHotKeyTip(id, ui, side, offset, scale, depth)
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  local tips = self.hotKeyTips[id]
  if not tips then
    tips = {}
    self.hotKeyTips[id] = tips
  end
  if not tips[ui] then
    local tip = HotKeyTip.new("HotKeyTip", ui, side, offset, scale, depth)
    tips[ui] = tip
  end
  self:SetHotKeyTip(id)
end

function HotKeyTipManager:RemoveHotKeyTip(id, ui)
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  local tips = self.hotKeyTips[id]
  if tips then
    local tip = tips[ui]
    if tip then
      tip:DestroySelf()
    end
    tips[ui] = nil
  end
end

function HotKeyTipManager:ResetHotKeyTips()
  for id, _ in pairs(self.hotKeyTips) do
    self:SetHotKeyTip(id)
  end
end

function HotKeyTipManager:SetHotKeyTip(id)
  local tips = self.hotKeyTips[id]
  if tips then
    local hotKey = Game.HotKeyManager:GetHotKeyCustom(id)
    local state = self:GetHotKeyTipState(id)
    for ui, tip in pairs(tips) do
      if LuaGameObject.ObjectIsNull(ui) then
        self:RemoveHotKeyTip(id, ui)
      else
        tip:SetData(hotKey, state)
      end
    end
  end
end

function HotKeyTipManager:GetHotKeyTipState(id)
  local state = false
  local config = Table_WindowsHotKey[id]
  if config then
    local isSimple = config.Param and config.Param.simple == 1 or false
    state = self.tipLevel == HotKeyTipManager.TipLevel.ALL or self.tipLevel == HotKeyTipManager.TipLevel.SIMPLE and isSimple
  end
  return state
end
