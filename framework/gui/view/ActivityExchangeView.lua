autoImport("ActivityExchangeInfoCell")
autoImport("ActivityExchangeGetWayCell")
ActivityExchangeView = class("ActivityExchangeView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityExchangeView")
local ToggleActiveCol = "391b03"
local ToggleInactiveCol = "fdf2d1"
local ToggleLabelEffectActiveCol = "f3e29b"
local ToggleLabelEffectInactiveCol = "8f7545"

function ActivityExchangeView:Init()
  self:InitData()
  self:LoadPrefab()
  self:FindObjs()
  self:AddListenEvts()
end

function ActivityExchangeView:InitData()
  self.act_id = self.subViewData and self.subViewData.ActivityId or 0
  self.exchangeItems = {}
  self.exchangeMatGetWays = {}
  local config = Table_ActPersonalTimer[self.act_id]
  if config then
    self.act_name = config.Name
    local exchange_items = config.Misc and config.Misc.exchange_item
    for i = 1, #exchange_items do
      local data = {}
      data.index = i
      data.exchangeItem = exchange_items[i]
      data.act_id = self.act_id
      self.exchangeItems[i] = data
      local cost = exchange_items[i].cost
      for j = 1, #cost do
        local itemId = cost[j][1]
        local getWayItemData = GainWayItemData.new(itemId)
        local cellDatas = getWayItemData.datas
        for k = 1, #cellDatas do
          self.exchangeMatGetWays[#self.exchangeMatGetWays + 1] = cellDatas[k]
        end
      end
    end
    local isTFBranch = EnvChannel.IsTFBranch()
    local phaseTime = StringUtil.FormatTime2TimeStamp2
    if isTFBranch then
      self.startTime = config.TfStartTime and phaseTime(config.TfStartTime)
      self.endTime = config.TfEndTime and phaseTime(config.TfEndTime)
    else
      self.startTime = config.StartTime and phaseTime(config.StartTime)
      self.endTime = config.EndTime and phaseTime(config.EndTime)
    end
  end
end

function ActivityExchangeView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityExchangeView"
  self.gameObject = obj
end

function ActivityExchangeView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bgDecorationTex = self:FindComponent("DecorateTex", UITexture)
  self.bannerTex = self:FindComponent("BannerTex", UITexture)
  self.exchangePart = self:FindGO("ExchangePart")
  self.getMaterialPart = self:FindGO("MaterialPart")
  local grid = self:FindComponent("ExchangeGrid", UIGrid)
  self.exchangeItemListCtrl = UIGridListCtrl.new(grid, ActivityExchangeInfoCell, "ActivityExchangeInfoCell")
  grid = self:FindComponent("MatGrid", UIGrid)
  self.exchangeMatGetWayListCtrl = UIGridListCtrl.new(grid, ActivityExchangeGetWayCell, "ActivityExchangeGetWayCell")
  self.exchangeToggle = self:FindComponent("ExchangeTog", UIToggle)
  self.getWayToggle = self:FindComponent("GetWayTog", UIToggle)
  local onToggleChange = function(label, sprite, active)
    local color = active and ToggleActiveCol or ToggleInactiveCol
    local effectCol = active and ToggleLabelEffectActiveCol or ToggleLabelEffectInactiveCol
    local _, c = ColorUtil.TryParseHexString(color)
    label.color = c
    local _, c = ColorUtil.TryParseHexString(effectCol)
    label.effectColor = c
    sprite:SetActive(not active)
  end
  EventDelegate.Add(self.exchangeToggle.onChange, function()
    self.exchangePart:SetActive(self.exchangeToggle.value)
    onToggleChange(self.exchangeTogLabel, self.exchangeInactiveImg, self.exchangeToggle.value)
  end)
  EventDelegate.Add(self.getWayToggle.onChange, function()
    self.getMaterialPart:SetActive(self.getWayToggle.value)
    onToggleChange(self.getWayTogLabel, self.getWayInactiveImg, self.getWayToggle.value)
  end)
  self.exchangeTogLabel = self:FindComponent("ExchangeTog", UILabel)
  self.getWayTogLabel = self:FindComponent("GetWayTog", UILabel)
  self.exchangeInactiveImg = self:FindGO("img2", self.exchangeToggle.gameObject)
  self.getWayInactiveImg = self:FindGO("img2", self.getWayToggle.gameObject)
  self.remainTimeLabel = self:FindComponent("RemainTime", UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
end

function ActivityExchangeView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdActExchangeInfoCmd, self.RefreshView)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RefreshView)
  self:AddListenEvt(ServiceEvent.ActivityCmdActExchangeItemCmd, self.RefreshView)
end

local BgName = "risingstar_bg_bottom_04"

function ActivityExchangeView:OnEnter(id)
  if not self.entered then
    self.titleLabel.text = self.act_name
    PictureManager.Instance:SetActivityTexture(BgName, self.bgDecorationTex)
    local config = Table_ActivityIntegration[id]
    local helpId = config and config.HelpID
    self:RegistShowGeneralHelpByHelpID(helpId, self.helpBtn)
    self.banner = config and config.Params and config.Params.Texture
    if not StringUtil.IsEmpty(self.banner) then
      PictureManager.Instance:SetActivityTexture(self.banner, self.bannerTex)
    end
    local bottomTex = config and config.Params and config.Params.IntegrationBottom
    if not StringUtil.IsEmpty(bottomTex) then
      self.container:SetBottomBg(bottomTex)
    end
    self.entered = true
  end
  self.exchangeToggle.value = true
  self:RefreshView()
end

function ActivityExchangeView:OnExit()
  PictureManager.Instance:UnloadActivityTexture(BgName, self.bgDecorationTex)
  if not StringUtil.IsEmpty(self.banner) then
    PictureManager.Instance:UnloadActivityTexture(self.banner, self.bannerTex)
  end
end

function ActivityExchangeView:OnHide()
  self.container:ResetBottomBg()
end

local exchangeItemSortFunc = function(l, r)
  local lexchangedCount = ActivityExchangeProxy.Instance:GetExchangedCount(l.act_id, l.index)
  local rexchangedCount = ActivityExchangeProxy.Instance:GetExchangedCount(r.act_id, r.index)
  local ltotalCount = l.exchangeItem.exchange_count
  local rtotalCount = r.exchangeItem.exchange_count
  local lunlimit = not ltotalCount or ltotalCount == 0
  local runlimit = not rtotalCount or rtotalCount == 0
  local lexchangeout = lexchangedCount >= ltotalCount
  local rexchangeout = rexchangedCount >= rtotalCount
  if lunlimit and runlimit then
    return l.index < r.index
  end
  if not lunlimit and not runlimit then
    if lexchangeout == rexchangeout then
      return l.index < r.index
    end
    return rexchangeout
  end
  if not lunlimit and not lexchangeout then
    return l.index < r.index
  end
  if not runlimit and not rexchangeout then
    return l.index < r.index
  end
  return lunlimit
end

function ActivityExchangeView:RefreshView()
  table.sort(self.exchangeItems, exchangeItemSortFunc)
  self.exchangeItemListCtrl:ResetDatas(self.exchangeItems)
  self.exchangeMatGetWayListCtrl:ResetDatas(self.exchangeMatGetWays)
  if self.startTime and self.endTime then
    local curTime = math.floor(ServerTime.CurServerTime() / 1000)
    if curTime > self.startTime and curTime < self.endTime then
      local remainTime = self.endTime - curTime
      local day = math.floor(remainTime / 86400)
      if day == 0 then
        local hour = math.floor(remainTime / 3600)
        if hour == 0 then
          local min = math.floor(remainTime / 60)
          self.remainTimeLabel.text = string.format(ZhString.RemainTimeMin, min)
        else
          self.remainTimeLabel.text = string.format(ZhString.RemainTimeHour, hour)
        end
      else
        self.remainTimeLabel.text = string.format(ZhString.RemainTimeDay, day)
      end
    else
      self.remainTimeLabel.text = ZhString.NoviceShop_End
    end
  end
end
