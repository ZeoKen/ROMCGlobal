autoImport("ActivityExchangeView")
autoImport("ActivityExchangeInfoCell_Snow")
autoImport("ActivityExchangeGetWayCell_Snow")
ActivityExchangeView_Snow = class("ActivityExchangeView_Snow", ActivityExchangeView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityExchangeView_Snow")
local ToggleLabelEffectActiveCol = "C48600"
local ToggleLabelEffectInactiveCol = "537EBE"

function ActivityExchangeView_Snow:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityExchangeView_Snow"
  self.gameObject = obj
end

function ActivityExchangeView_Snow:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.bannerTex = self:FindComponent("BannerTex", UITexture)
  self.exchangePart = self:FindGO("ExchangePart")
  self.getMaterialPart = self:FindGO("MaterialPart")
  local grid = self:FindComponent("ExchangeGrid", UIGrid)
  self.exchangeItemListCtrl = UIGridListCtrl.new(grid, ActivityExchangeInfoCell_Snow, "ActivityExchangeInfoCell_Snow")
  grid = self:FindComponent("MatGrid", UIGrid)
  self.exchangeMatGetWayListCtrl = UIGridListCtrl.new(grid, ActivityExchangeGetWayCell_Snow, "ActivityExchangeGetWayCell_Snow")
  self.exchangeToggle = self:FindComponent("ExchangeTog", UIToggle)
  self.getWayToggle = self:FindComponent("GetWayTog", UIToggle)
  self.exchangeTogLabel = self:FindComponent("ExchangeTog", UILabel)
  self.getWayTogLabel = self:FindComponent("GetWayTog", UILabel)
  EventDelegate.Add(self.exchangeToggle.onChange, function()
    self.exchangePart:SetActive(self.exchangeToggle.value)
    self:OnToggleChange(self.exchangeTogLabel, self.exchangeToggle.value)
  end)
  EventDelegate.Add(self.getWayToggle.onChange, function()
    self.getMaterialPart:SetActive(self.getWayToggle.value)
    self:OnToggleChange(self.getWayTogLabel, self.getWayToggle.value)
  end)
  self.remainTimeLabel = self:FindComponent("RemainTime", UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
end

function ActivityExchangeView_Snow:OnToggleChange(label, active)
  local color = active and ToggleLabelEffectActiveCol or ToggleLabelEffectInactiveCol
  local _, c = ColorUtil.TryParseHexString(color)
  label.effectColor = c
end

function ActivityExchangeView_Snow:OnEnter(id)
  if not self.entered then
    self.titleLabel.text = self.act_name
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
  self:OnToggleChange(self.exchangeTogLabel, self.exchangeToggle.value)
  self:OnToggleChange(self.getWayTogLabel, self.getWayToggle.value)
  self:RefreshView()
end

function ActivityExchangeView_Snow:OnExit()
  if not StringUtil.IsEmpty(self.banner) then
    PictureManager.Instance:UnloadActivityTexture(self.banner, self.bannerTex)
  end
end
