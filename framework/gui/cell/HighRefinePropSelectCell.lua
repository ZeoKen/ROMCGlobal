local BaseCell = autoImport("BaseCell")
HighRefinePropSelectCell = class("HighRefinePropSelectCell", BaseCell)
local normalColor = Color(0.20392156862745098, 0.20392156862745098, 0.20392156862745098)
local blueColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
local bsProxy

function HighRefinePropSelectCell:Init()
  if not bsProxy then
    bsProxy = BlackSmithProxy.Instance
  end
  self.isIniting = true
  self.lv = self:FindComponent("Lv", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
  self.toggle1 = self:FindComponent("Toggle1", UIToggle)
  self.toggle2 = self:FindComponent("Toggle2", UIToggle)
  self.toggle1Label = self:FindComponent("Label", UILabel, self.toggle1.gameObject)
  self.toggle2Label = self:FindComponent("Label", UILabel, self.toggle2.gameObject)
  self:AddEvents()
  self.isIniting = false
end

local onToggleChange = function(control, toggle, bitVal)
  if not control.isEnabled or control.isSettingData or control.isIniting then
    return
  end
  local value = bsProxy:GetHighRefineAttr(control.posType, control.levelType)
  if not value then
    if not control.initialAttrValue then
      return
    end
    value = control.initialAttrValue
  end
  local exValue = value
  if toggle.value then
    if 0 < bitVal then
      value = BitUtil.setbit(value, control.level - 1)
    else
      value = BitUtil.unsetbit(value, control.level - 1)
    end
    if exValue ~= value then
      ServiceNUserProxy.Instance:CallHighRefineAttrUserCmd(control.posType, control.levelType, math.floor(value))
    end
  end
end

function HighRefinePropSelectCell:AddEvents()
  EventDelegate.Add(self.toggle1.onChange, function()
    onToggleChange(self, self.toggle1, BlackSmithProxy.HRefinePropValueMap.Refine)
  end)
  EventDelegate.Add(self.toggle2.onChange, function()
    onToggleChange(self, self.toggle2, BlackSmithProxy.HRefinePropValueMap.MRefine)
  end)
end

function HighRefinePropSelectCell:SetData(data)
  self.isSettingData = true
  self:SetEnabled(data)
  if not data then
    return
  end
  self.posType = data.PosType
  self.levelType = math.floor(data.Level / 1000)
  self.level = data.Level % 1000
  self.lv.text = string.format("Lv.%s", self.level)
  local myHRefineLevel = bsProxy:GetPlayerHRefineLevel(self.posType, self.levelType)
  local effectMap = bsProxy:get_SingleHRefineEffects_Map(data, MyselfProxy.Instance:GetMyProfession())
  if myHRefineLevel < self.level or not effectMap then
    self:SetEnabled(false)
    self.isSettingData = false
    return
  end
  self.value = nil
  for _, v in pairs(effectMap) do
    if type(v) == "number" then
      self.value = v
    end
  end
  self.value = self.value or 0
  self.valueLabel.text = string.format("+%s", self.value)
  local attr = bsProxy:GetHighRefineAttr(self.posType, self.levelType, self.level)
  local myClass = MyselfProxy.Instance:GetMyProfession()
  if not attr then
    local jobs
    for i = 1, #data.Effect do
      jobs = data.Effect[i].Job
      if 0 < TableUtility.ArrayFindIndex(jobs, myClass) then
        if data.Effect[i].Refine then
          attr = BlackSmithProxy.HRefinePropValueMap.Refine
          self.initialAttrValue = 1023
        elseif data.Effect[i].MRefine then
          attr = BlackSmithProxy.HRefinePropValueMap.MRefine
          self.initialAttrValue = 0
        end
      end
    end
  end
  self.toggle1.value = attr == BlackSmithProxy.HRefinePropValueMap.Refine
  self.toggle2.value = attr == BlackSmithProxy.HRefinePropValueMap.MRefine
  self.isSettingData = false
end

function HighRefinePropSelectCell:SetEnabled(isEnabled)
  self.isEnabled = isEnabled and true or false
  local color = isEnabled and normalColor or ColorUtil.NGUIGray
  self.lv.color = color
  self.desc.color = color
  self.valueLabel.color = isEnabled and blueColor or ColorUtil.NGUIGray
  self.toggle1Label.color = color
  self.toggle2Label.color = color
  self:SetToggleGroup(isEnabled and self.group or 0)
  if not isEnabled then
    self.valueLabel.text = "+0"
    self.toggle1.value = false
    self.toggle2.value = false
  end
  self.toggle1.enabled = self.isEnabled
  self.toggle2.enabled = self.isEnabled
end

function HighRefinePropSelectCell:SetToggleGroup(g)
  g = g or 88
  self.group = g
  self.toggle1.group = g
  self.toggle2.group = g
end

function HighRefinePropSelectCell:GetSelection()
  local default = -1
  if self.toggle1.value then
    return BlackSmithProxy.HRefinePropValueMap.Refine
  elseif self.toggle2.value then
    return BlackSmithProxy.HRefinePropValueMap.MRefine
  else
    return default
  end
end
