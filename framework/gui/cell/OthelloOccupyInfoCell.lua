local BaseCell = autoImport("BaseCell")
OthelloOccupyInfoCell = class("OthelloOccupyInfoCell", BaseCell)
local UI_SliderOffset = 3
local robTotalValue
local _PvpProxy = PvpProxy.Instance

function OthelloOccupyInfoCell:Init()
  self.occupy_sps = {}
  for i = 1, 2 do
    self.occupy_sps[i] = self:FindComponent("Occupy_" .. i, UISprite)
  end
  self.sliderBg = self:FindComponent("SliderBg", UISprite)
  self.slider_length = self.sliderBg.width - UI_SliderOffset * 2
end

function OthelloOccupyInfoCell:SetData(id)
  if id == nil then
    self:HideSelf()
    return
  end
  self.id = id
  self:InitTotalValue()
  self:ShowSelf()
  self:Refresh()
end

function OthelloOccupyInfoCell:InitTotalValue()
  if not self.id then
    return
  end
  local othelloCfg = DungeonProxy.Instance:GetOthelloConfigRaid()
  if not othelloCfg then
    return
  end
  local checkpointConfig = othelloCfg.points
  robTotalValue = checkpointConfig[self.id] and checkpointConfig[self.id].progress
end

function OthelloOccupyInfoCell:Refresh()
  local id = self.id
  if not id then
    return
  end
  local othelloOccupyData = _PvpProxy:GetOthelloOccupyData(self.id)
  if not othelloOccupyData then
    redlog("othelloOccupyData Not Find!", id)
    self:HideSelf()
    return
  end
  local values = ReusableTable.CreateTable()
  if not robTotalValue then
    self:InitTotalValue()
  end
  values[OthelloOccupyData.OccupyType.RED] = othelloOccupyData.redprogress / robTotalValue
  values[OthelloOccupyData.OccupyType.BLUE] = othelloOccupyData.blueprogress / robTotalValue
  self:SetOccupySlider(values)
  ReusableTable.DestroyTable(values)
end

local tempV3 = LuaVector3.Zero()

function OthelloOccupyInfoCell:SetOccupySlider(values)
  local total_ocuvalue = 0
  local ocu_value
  for i = 1, 2 do
    ocu_value = values[i] or 0
    local sp = self.occupy_sps[i]
    tempV3[1] = self.slider_length * total_ocuvalue + UI_SliderOffset
    sp.transform.localPosition = tempV3
    local width = math.ceil(ocu_value * self.slider_length)
    if 2 < width then
      sp.gameObject:SetActive(true)
      sp.width = width
    else
      sp.gameObject:SetActive(false)
    end
    total_ocuvalue = total_ocuvalue + ocu_value
  end
end

function OthelloOccupyInfoCell:ShowSelf()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.active == true then
    return
  end
  self.active = true
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, self.Refresh, self)
end

function OthelloOccupyInfoCell:HideSelf()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.active == false then
    return
  end
  self.active = false
  self.gameObject:SetActive(false)
  if self.id ~= nil then
    self.id = nil
  end
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdOthelloPointOccupyPowerFubenCmd, self.Refresh, self)
end
