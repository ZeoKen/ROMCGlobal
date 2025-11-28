autoImport("PlayerSelectCell")
MainView3TeamsOBTeamBoardCell = class("MainView3TeamsOBTeamBoardCell", MainView3TeamsTeamBoardCell)
local SpRed = "map_icon_qi01"
local SpYellow = "map_icon_qi02"
local SpBlue = "map_icon_qi03"
local SpGreen = "map_icon_qi04"
local LabelRed = "ff9090"
local LabelYellow = "ebe76f"
local LabelBlue = "acd9ff"
local LabelGreen = "92eb6f"
local CampConf = {
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = {labelCol = LabelRed, sp = SpRed},
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = {labelCol = LabelYellow, sp = SpYellow},
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = {labelCol = LabelBlue, sp = SpBlue},
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = {labelCol = LabelGreen, sp = SpGreen}
}

function MainView3TeamsOBTeamBoardCell:SetData(data)
  self.data = data
  self.camp = data.camp
  local conf = CampConf[data.camp]
  self.campIcon.spriteName = conf.sp
  local _, c = ColorUtil.TryParseHexString(conf.labelCol)
  self.teamName.color = c
  local campName = GameConfig.Triple.CampName[data.camp]
  self.teamName.text = campName
  self:UpdateTeamMembers()
end

function MainView3TeamsOBTeamBoardCell:ClickPlayerCell(cell)
  local player = cell.data
  local playerid = player and player.data.id
  if not player then
    return
  end
  PvpObserveProxy.Instance:TryAttach(playerid)
end
