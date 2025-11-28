autoImport("PlayerSelectCell")
MainView3TeamsTeamBoardCell = class("MainView3TeamsTeamBoardCell", BaseCell)
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

function MainView3TeamsTeamBoardCell:Init()
  self:FindObjs()
  local parentPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  if parentPanel then
    self.playerPanel.depth = parentPanel.depth + 1
  end
end

function MainView3TeamsTeamBoardCell:FindObjs()
  self.campIcon = self:FindComponent("campIcon", UISprite)
  self.teamName = self:FindComponent("teamName", UILabel)
  self.playerPanel = self:FindComponent("ScrollPlayer", UIPanel)
  local teamGrid = self:FindComponent("gridPlayers", UIGrid)
  self.teamListCtrl = UIGridListCtrl.new(teamGrid, PlayerSelectCell, "PlayerSelectCell")
  self.teamListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerCell, self)
end

function MainView3TeamsTeamBoardCell:SetData(data)
  self.data = data
  self.camp = data.camp
  local conf = CampConf[data.camp]
  self.campIcon.spriteName = conf.sp
  local _, c = ColorUtil.TryParseHexString(conf.labelCol)
  self.teamName.color = c
  local campName = GameConfig.Triple.CampName[data.camp]
  if data.camp ~= PvpProxy.Instance.myselfCamp then
    self.teamName.text = string.format(ZhString.Triple_Camp_Enemy, campName)
  else
    self.teamName.text = campName
  end
  self:UpdateTeamMembers()
end

function MainView3TeamsTeamBoardCell:ClickPlayerCell(cell)
  Game.Myself:Client_LockTarget(cell.data)
end

function MainView3TeamsTeamBoardCell:UpdateTeamMembers()
  local datas = {}
  local users = self.data.users
  for i = 1, #users do
    local user = SceneCreatureProxy.FindCreature(users[i])
    if user then
      datas[#datas + 1] = user
    end
  end
  self.teamListCtrl:ResetDatas(datas)
end

function MainView3TeamsTeamBoardCell:GetCells(...)
  return self.teamListCtrl:GetCells()
end
