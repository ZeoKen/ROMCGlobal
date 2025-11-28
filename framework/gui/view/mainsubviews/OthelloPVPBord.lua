OthelloPVPBord = class("OthelloPVPBord", CoreView)
local PREFAB_PATH = "GUI/v1/part/OthelloPVPBord"
local TeamColor

function OthelloPVPBord:ctor(parent)
  if parent == nil then
    error("not find parent..root")
    return
  end
  self:CreateSelf(parent)
  TeamColor = PvpProxy.TeamPws.TeamColor
  local othelloConfig = DungeonProxy:GetOthelloConfigRaid()
  self.endscore = othelloConfig.endscore
end

function OthelloPVPBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/OthelloPVPBord", parent, true)
  self:InitView()
end

function OthelloPVPBord:InitView()
  self.leftTime_Raid = self:FindComponent("LeftTime_Raid", UILabel)
  self.score_Red = self:FindComponent("score1", UILabel)
  self.score_Blue = self:FindComponent("score2", UILabel)
  self.redProgress = self:FindGO("slider1"):GetComponent(UISlider)
  self.blueProgress = self:FindGO("slider2"):GetComponent(UISlider)
  local detailButton = self:FindGO("DetailButton")
  self:AddClickEvent(detailButton, function(go)
    self:ShowDetail()
  end)
  local stick = self:FindComponent("Stick", UIWidget)
end

function OthelloPVPBord:ShowDetail()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.OthelloReportPopUp
  })
end

function OthelloPVPBord:UpdateInfo()
  self:UpdateRaidInfo()
  self:UpdateScoreInfo()
end

function OthelloPVPBord:UpdateRaidInfo()
  local endtime = PvpProxy.Instance:GetOthelloEndtime()
  self:UpdateLeftTime_Raid(endtime)
end

function OthelloPVPBord:UpdateScoreInfo()
  local rd = PvpProxy.Instance:GetOhelloInfo(TeamColor.Red)
  local value = 0
  if rd ~= nil then
    self.score_Red.text = rd.score or 0
    value = rd.score or 0
  else
    self.score_Red.text = 0
    value = 0
  end
  self.redProgress.value = value / self.endscore
  local bd = PvpProxy.Instance:GetOhelloInfo(TeamColor.Blue)
  if bd ~= nil then
    self.score_Blue.text = bd.score or 0
    value = bd.score or 0
  else
    self.score_Blue.text = 0
    value = 0
  end
  self.blueProgress.value = value / self.endscore
end

local f_gnt
local getNowTime = function()
  if f_gnt == nil then
    f_gnt = ServerTime.CurServerTime
  end
  if f_gnt then
    return f_gnt() / 1000
  end
  return 0
end

function OthelloPVPBord:UpdateLeftTime_Raid(endtime)
  self.endtime_raid = endtime
  local nowtime = getNowTime()
  if endtime <= nowtime then
    self:RemoveTimeTick_Raid()
    return
  end
  if self.raid_tick ~= nil then
    return
  end
  self:AddTimeTick_Raid()
end

function OthelloPVPBord:RemoveTimeTick_Raid()
  if self.raid_tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.raid_tick = nil
  end
  self.leftTime_Raid.text = string.format("%02d:%02d", 0, 0)
end

function OthelloPVPBord:AddTimeTick_Raid()
  self.raid_tick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTimeTick_Raid, self, 1)
end

function OthelloPVPBord:_UpdateTimeTick_Raid()
  local lefttime = self.endtime_raid - getNowTime()
  if lefttime <= 0 then
    self:RemoveTimeTick_Raid()
    return
  end
  self.leftTime_Raid.text = string.format("%02d:%02d", math.floor(lefttime / 60), math.floor(lefttime % 60))
end

function OthelloPVPBord:Show()
  OthelloPVPBord.super.Show(self)
  self:UpdateInfo()
end

function OthelloPVPBord:Hide()
  OthelloPVPBord.super.Hide(self)
end
