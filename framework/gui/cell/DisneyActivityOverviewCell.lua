DisneyActivityOverviewCell = class("DisneyActivityOverviewCell", BaseCell)
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _chooseCfg = {
  picCfg = {
    "disneyactivity_bg_tab_unchecked",
    "disneyactivity_bg_tab_chose"
  },
  colorCfg = {
    effect = {
      UILabel.Effect.None,
      UILabel.Effect.Outline
    },
    outlineColor = {"FFFFFF", "d3a506"},
    color = {"6D7499", "FFFFFF"}
  }
}
local _mickeyIcon
local _maxLength = 146
local _pivot = {
  UIWidget.Pivot.Left,
  UIWidget.Pivot.Center
}

function DisneyActivityOverviewCell:Init()
  DisneyActivityOverviewCell.super.Init(self)
  self:InitCell()
  _mickeyIcon = DisneyStageProxy.Instance:GetDisneyGuideStatusSp()
end

function DisneyActivityOverviewCell:InitCell()
  local bg = self:FindGO("bg")
  self:SetEvent(bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local nameDragSV = self:FindGO("NameDragSV")
  self:SetEvent(nameDragSV, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.timeLab = self:FindComponent("Time", UILabel)
  self.chooseFlag = self:FindComponent("ChooseFlag", UISprite)
  self.mickeyIcon = self:FindComponent("MikeyIcon", UISprite)
  self.hasRewardSp = self:FindGO("HasMickeyReward")
  self.timeStatusLab = self:FindComponent("TimeStatusLab", UILabel)
  self.nameSV = self:FindComponent("NameSV", UIScrollView)
end

function DisneyActivityOverviewCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  self.data = data
  self:SetTimeInfo()
  self:UpdateChoose()
  self:UpdateMickeyState()
end

local tempV3 = LuaVector3()
local singleLine, multiLine = 18, 36

function DisneyActivityOverviewCell:SetTimeInfo()
  local data = self.data
  self.nameLab.text = data:IsOpenLater() and ZhString.DisneyOverview_Time_OpenLaterName or data.staticData.Name
  self.nameSV.contentPivot = self.nameLab.width > _maxLength and _pivot[1] or _pivot[2]
  self.nameSV:ResetPosition()
  self:Hide(self.timeStatusLab)
  self.timeLab.height = multiLine
  tempV3[2] = -40
  if data:IsOpenLater() then
    self.timeLab.text = ZhString.DisneyOverview_Time_OpenLater
  elseif data:IsOpenSooner() then
    local m = os.date("%m", data.startTime)
    local d = os.date("%d", data.startTime)
    local H = os.date("%H", data.startTime)
    local M = os.date("%M", data.startTime)
    self.timeLab.text = string.format(ZhString.DisneyOverview_Time_OpenSooner, m, d, H, M)
  elseif data:IsGuideActivityRunning() then
    local sm = os.date("%m", data.startTime)
    local sd = os.date("%d", data.startTime)
    local em = os.date("%m", data.endTime)
    local ed = os.date("%d", data.endTime)
    self.timeLab.height = singleLine
    self.timeLab.text = string.format(ZhString.DisneyOverview_Time_Running, sm, sd, em, ed)
    self:Show(self.timeStatusLab)
    self.timeStatusLab.text = data:GetTimeDesc()
    tempV3[2] = -26
  elseif data:IsClosed() then
    self.timeLab.text = ZhString.DisneyOverview_Time_Closed
  end
  self.timeLab.gameObject.transform.localPosition = tempV3
end

function DisneyActivityOverviewCell:UpdateMickeyState()
  if self.data and self.data:HasMickey() then
    self:Show(self.mickeyIcon)
    self.mickeyIcon.spriteName = self.data:IsMickeyActive() and _mickeyIcon.Active or _mickeyIcon.InActive
    self.hasRewardSp:SetActive(self.data:CheckCanGetReward())
  else
    self:Hide(self.mickeyIcon)
    self.hasRewardSp:SetActive(false)
  end
end

function DisneyActivityOverviewCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function DisneyActivityOverviewCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseFlag.spriteName = _chooseCfg.picCfg[2]
    self.nameLab.effectStyle = _chooseCfg.colorCfg.effect[2]
    self.nameLab.effectColor = _ParseColor(_chooseCfg.colorCfg.outlineColor[2])
    self.nameLab.color = _ParseColor(_chooseCfg.colorCfg.color[2])
  else
    self.chooseFlag.spriteName = _chooseCfg.picCfg[1]
    self.nameLab.effectStyle = _chooseCfg.colorCfg.effect[1]
    self.nameLab.effectColor = _ParseColor(_chooseCfg.colorCfg.outlineColor[1])
    self.nameLab.color = _ParseColor(_chooseCfg.colorCfg.color[1])
  end
end
