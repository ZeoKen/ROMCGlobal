local BaseCell = autoImport("BaseCell")
BFBuildingWeatherCell = class("BFBuildingWeatherCell", BaseCell)
local tickMgr = TimeTickManager.Me()

function BFBuildingWeatherCell:Init()
  self:FindObjs()
  self:AddUIEvents()
end

function BFBuildingWeatherCell:FindObjs()
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.desc = self:FindComponent("desc", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
  self.btn = self:FindGO("UseButton")
  self.btnColl = self.btn:GetComponent(BoxCollider)
  self.btnSp = self.btn:GetComponent(UIMultiSprite)
  self.btnText = self:FindComponent("Label", UILabel, self.btn)
  self.choose = self:FindGO("Choose")
  self.lock = self:FindGO("Lock")
  self.cdtext = self:FindComponent("CD", UILabel)
  self.cdmask = self:FindComponent("Mask", UISprite)
end

function BFBuildingWeatherCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    if not self.inuse and not self.lock.activeSelf then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
  self:AddClickEvent(self.btn, function(go)
    self:PassEvent(BFBuildingEvent.UseWeather, self)
  end)
end

function BFBuildingWeatherCell:SetData(data)
  self.data = data
  local weatherid = data
  local weatherInfo = Table_Weather[weatherid]
  local atlas = RO.AtlasMap.GetAtlas("Weather")
  self.icon.atlas = atlas
  self.icon.spriteName = weatherInfo and weatherInfo.Icon or ""
  self.desc.text = weatherInfo and weatherInfo.NameZh or ""
  self:SetSelect(false)
  self:SelfUpdateCell()
end

function BFBuildingWeatherCell:SelfUpdateCell()
  local cbData = BFBuildingProxy.Instance:GetCurBuildingData()
  local inuse = cbData.wtime and cbData.wid and cbData.wid == self.data
  self.endTime = inuse and cbData.wtime
  self:SetStatus(inuse, cbData.status)
  if self.endTime then
    self:ClearTick()
    self.timeTick = tickMgr:CreateTick(0, 33, self.UpdateDuration, self, 1)
  end
end

function BFBuildingWeatherCell:SetSelect(istrue)
  istrue = istrue and not self.inuse
  self.bg.CurrentState = istrue and 1 or 0
  self.choose:SetActive(istrue)
  local weatherInfo = Table_Weather[self.data]
  if istrue then
    self.desc.text = weatherInfo and weatherInfo.Desc or ""
  else
    self.desc.text = weatherInfo and weatherInfo.NameZh or ""
  end
end

function BFBuildingWeatherCell:SetStatus(inuse, buildrun_stat)
  self.inuse = inuse
  if inuse then
    self.btnColl.enabled = false
    self.btnSp.CurrentState = 1
    self:SetTextureWhite(self.btn)
    self.btnText.color = LuaColor(0.24313725490196078, 0.34901960784313724, 0.6549019607843137)
    self.btnText.text = ZhString.BFBuilding_button_inuse
    self:SetSelect(false)
    self.lock:SetActive(false)
  else
    self.btnSp.CurrentState = 0
    if buildrun_stat == EBUILDSTATUS.EBUILDSTATUS_RUN then
      self.btnColl.enabled = true
      self:SetTextureWhite(self.btn)
      self.btnText.color = LuaColor(0.6980392156862745, 0.4196078431372549, 0.1411764705882353)
      self.btnText.text = ZhString.BFBuilding_button_use1
      self.lock:SetActive(false)
    elseif buildrun_stat == EBUILDSTATUS.EBUILDSTATUS_OPER then
      self.btnColl.enabled = false
      self:SetTextureGrey(self.btn)
      self.btnText.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
      self.btnText.text = ZhString.BFBuilding_button_use1
      self.lock:SetActive(false)
    else
      self.btnColl.enabled = false
      self:SetTextureGrey(self.btn)
      self.btnText.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
      self.btnText.text = ZhString.BFBuilding_button_use1
      self.lock:SetActive(true)
    end
  end
end

function BFBuildingWeatherCell:UpdateDuration()
  if self.endTime then
    local leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
    local t_min = math.ceil(leftTime) / 60
    local t_sec = math.ceil(leftTime) % 60
    self.cdtext.text = string.format("%02d:%02d", t_min, t_sec)
    self.cdmask.fillAmount = leftTime / (GameConfig.BuildingCooperate.WeatherDuration or 1)
    if leftTime <= 0 then
      self.endTime = nil
    end
    self.cdtext.gameObject:SetActive(true)
  else
    self:ClearTick()
    self.cdtext.gameObject:SetActive(false)
  end
end

function BFBuildingWeatherCell:ClearTick()
  if self.timeTick ~= nil then
    tickMgr:ClearTick(self)
    self.timeTick = nil
  end
end

function BFBuildingWeatherCell:OnCellDestroy()
  self:ClearTick()
end
