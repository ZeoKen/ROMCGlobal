local BaseCell = autoImport("BaseCell")
BFBuildingReviveCell = class("BFBuildingReviveCell", BaseCell)
local tickMgr = TimeTickManager.Me()

function BFBuildingReviveCell:Init()
  self:FindObjs()
  self:AddUIEvents()
end

function BFBuildingReviveCell:FindObjs()
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
  self.cdtext.text = ""
  self.cdmask = self:FindComponent("Mask", UISprite)
end

function BFBuildingReviveCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.btn, function(go)
    self:PassEvent(BFBuildingEvent.UseRevive, self)
  end)
end

function BFBuildingReviveCell:SetData(data)
  self.data = data
  local monster = Table_Monster[data.npcid]
  IconManager:SetFaceIcon(monster and monster.Icon, self.icon)
  self.desc.text = monster and monster.NameZh or ""
  self:SetSelect(false)
  self:SelfUpdateCell()
end

function BFBuildingReviveCell:SelfUpdateCell()
  local cbData = BFBuildingProxy.Instance:GetCurBuildingData()
  local b_status = cbData.status
  local canRevive = GameConfig.BuildingCooperate.TimerMaxCount - cbData.r_times > 0
  self:SetStatus(canRevive, b_status)
end

function BFBuildingReviveCell:SetSelect(istrue)
  istrue = istrue and not self.inuse
  self.bg.CurrentState = istrue and 1 or 0
  self.choose:SetActive(istrue)
end

function BFBuildingReviveCell:SetStatus(canRevive, buildrun_stat)
  self.lock:SetActive(false)
  self.cdtext.gameObject:SetActive(false)
  self:ClearTick()
  if self.data.status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE then
    self.btnText.text = ZhString.BFBuilding_button_revive2
    self.desc.text = ZhString.BFBuilding_revive_status_alive
  elseif self.data.status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD then
    self.btnText.text = ZhString.BFBuilding_button_revive1
    self.desc.text = ""
    self.endTime = self.data.lefttime + ServerTime.CurServerTime() / 1000
    if self.endTime and self.endTime > 0 then
      self:ClearTick()
      self.timeTick = tickMgr:CreateTick(0, 33, self.UpdateDuration, self, 1)
    end
  else
    self.btnText.text = ZhString.BFBuilding_button_revive1
    self.desc.text = ZhString.BFBuilding_revive_status_unknown
  end
  if buildrun_stat ~= EBUILDSTATUS.EBUILDSTATUS_RUN then
    self.btnColl.enabled = false
    self.btnSp.CurrentState = 1
    self:SetTextureGrey(self.btn)
    self.btnText.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
  elseif self.data.status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE then
    self.btnColl.enabled = true
    self.btnSp.CurrentState = 0
    self:SetTextureWhite(self.btn)
    self.btnText.color = LuaColor(0.6980392156862745, 0.4196078431372549, 0.1411764705882353)
  elseif self.data.status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD and canRevive then
    self.btnColl.enabled = true
    self.btnSp.CurrentState = 1
    self:SetTextureWhite(self.btn)
    self.btnText.color = LuaColor(0.24313725490196078, 0.34901960784313724, 0.6549019607843137)
  else
    self.btnColl.enabled = false
    self.btnSp.CurrentState = 1
    self:SetTextureGrey(self.btn)
    self.btnText.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
  end
end

local IsNull = Slua.IsNull

function BFBuildingReviveCell:UpdateDuration()
  if self.endTime then
    local leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
    local t_min = math.ceil(leftTime) / 60
    local t_sec = math.ceil(leftTime) % 60
    if not IsNull(self.desc) then
      self.desc.text = string.format("%02d:%02d", t_min, t_sec)
    end
    if not IsNull(self.cdmask) then
      self.cdmask.fillAmount = leftTime / (GameConfig.BuildingCooperate.WeatherDuration or 1)
    end
    if leftTime <= 0 then
      self.endTime = nil
    end
    if not IsNull(self.cdtext) then
      self.cdtext.gameObject:SetActive(true)
    end
  else
    self:ClearTick()
    if not IsNull(self.cdtext) then
      self.cdtext.gameObject:SetActive(false)
    end
    self:PassEvent(BFBuildingEvent.ReviveQuery, self)
  end
end

function BFBuildingReviveCell:ClearTick()
  if self.timeTick ~= nil then
    tickMgr:ClearTick(self)
    self.timeTick = nil
  end
end

function BFBuildingReviveCell:OnCellDestroy()
  self:ClearTick()
end
