autoImport("Team_RoleCell")
local BaseCell = autoImport("BaseCell")
TeamCell = class("TeamCell", BaseCell)
local _ZoneIcon = "main_icon_worldline_jm"
local _ServerIcon = "main_icon_The-server2"
local _texName = {
  "team_bg_pattern_6",
  "team_bg_pattern_12"
}
local _bgHeight = {100, 118}
local _intervalX = 70

function TeamCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.goal = self:FindComponent("Goal", UILabel)
  self.level = self:FindComponent("Level", UILabel)
  self.teamZone = self:FindGO("TeamZoneRoot")
  self.teamName = self:FindComponent("TeamName", UILabel, self.teamZone)
  self.applyBtn = self:FindGO("ApplyButton")
  self.applyLabel = self:FindComponent("Label", UILabel, self.applyBtn)
  self.applyLabel.text = ZhString.TeamCell_Apply
  self.cancelApplyBtn = self:FindGO("CancelApplyBtn")
  local cancelApplyLab = self:FindComponent("Label", UILabel, self.cancelApplyBtn)
  cancelApplyLab.text = ZhString.TeamCell_CancelApply
  self.countDownLab = self:FindComponent("CountDownLab", UILabel)
  self.zoneid = self:FindComponent("Zone", UILabel, self.teamZone)
  self.zoneIconSp = self:FindComponent("Sprite", UISprite, self.zoneid.gameObject)
  self:AddClickEvent(self.applyBtn, function(go)
    self:OnClickApplyBtn()
  end)
  self:AddClickEvent(self.cancelApplyBtn, function(go)
    self:OnClickCancelApply()
  end)
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:InitExtra()
  self.infoBtn = self:FindGO("InfoBtn")
  self:AddClickEvent(self.infoBtn, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInfoPopup,
      viewdata = {
        teamdata = self.data
      }
    })
  end)
  self.tex6 = self:FindComponent("Texture6", UITexture)
  self.tex12 = self:FindComponent("Texture12", UITexture)
  self.difficulty = self:FindGO("Difficulty"):GetComponent(UILabel)
end

function TeamCell:InitExtra()
  self.roleGrid = self:FindComponent("RoleGrid", UIGrid)
  self.roleCtrl = UIGridListCtrl.new(self.roleGrid, Team_RoleCell, "Team_RoleCell")
end

function TeamCell:CountDown(createTime)
  if not createTime then
    self:SetApplyButton(false)
    self:ClearTick()
    self:Hide(self.countDownLab)
    return
  end
  self.createTime = createTime
  self:ClearTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.funcCountDown, self)
end

function TeamCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
end

function TeamCell:OnCellDestroy()
  self:ClearTick()
end

function TeamCell:funcCountDown()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local duringTime = GameConfig.Team.applyovertime - (ServerTime.CurServerTime() / 1000 - self.createTime)
  if 0 < duringTime then
    self:Show(self.countDownLab)
    self.countDownLab.text = string.format(ZhString.TeamCell_Applying, ClientTimeUtil.GetFormatSecTimeStr(duringTime))
    self:SetApplyButton(true)
  else
    self:Hide(self.countDownLab)
    self:ClearTick()
    TeamProxy.Instance:RemoveApply(self.data.id)
    self:SetApplyButton(false)
  end
end

function TeamCell:SetApplyButton(applying)
  local valid = self:CheckApplyValid()
  self.applying = applying
  self.applyBtn:SetActive(valid and not applying)
  self.cancelApplyBtn:SetActive(valid and applying)
  if not applying then
    self.applyLabel.text = TeamProxy.Instance:CheckIHaveLeaderAuthority() and ZhString.TeamCell_GroupApply or ZhString.TeamCell_Apply
  end
end

function TeamCell:OnClickCancelApply()
  MsgManager.ConfirmMsgByID(370, function()
    local applydata = TeamProxy.Instance:GetUserApply(self.data.id)
    if applydata then
      if applydata.isgroup then
        ServiceSessionTeamProxy.Instance:CallTeamGroupApplyTeamCmd(self.data.id, nil, true)
      else
        ServiceSessionTeamProxy.Instance:CallCancelApplyTeamCmd(self.data.id)
        if self.data:IsGroupTeam() then
          ServiceSessionTeamProxy.Instance:CallCancelApplyTeamCmd(self.data.uniteteamid)
        end
      end
    end
  end)
end

function TeamCell:OnClickApplyBtn()
  FunctionTeam.DoApply(self.data)
end

function TeamCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    local goalConfig = {}
    if data.type and Table_TeamGoals[data.type] then
      goalConfig = Table_TeamGoals[data.type]
      if goalConfig and goalConfig.type then
        self.goal.text = Table_TeamGoals[goalConfig.type].NameZh
      end
    end
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local islvOutRange = mylv < data.minlv or mylv > data.maxlv
    if islvOutRange then
      self.level.text = string.format("[c][ff0000]Lv.%s +", tostring(data.minlv))
    else
      self.level.text = string.format("Lv.%s +", tostring(data.minlv))
    end
    self.teamName.text = data.name
    local leader = data:GetLeader()
    if leader then
      if nil == leader.IsSameServer or leader:IsSameServer() then
        local leaderzone = ChangeZoneProxy.Instance:ZoneNumToString(leader.zoneid, nil, leader.realzoneid)
        self.zoneid.gameObject:SetActive(leaderzone ~= "" and not leader:IsSameline())
        self.zoneid.text = leaderzone
        self.zoneIconSp.spriteName = _ZoneIcon
      else
        local serverId = leader:GetServerId()
        self.zoneid.text = tostring(serverId)
        self.zoneIconSp.spriteName = _ServerIcon
      end
      self.zoneIconSp:MakePixelPerfect()
    end
    local initX = LuaGameObject.GetLocalPositionGO(self.teamName.gameObject)
    local zoneX = initX + self.teamName.width + _intervalX
    self.zoneid.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(zoneX, 22, 0)
    if data:IsGroupTeam() then
      PictureManager.Instance:SetUI(_texName[2], self.tex12)
      self.teamZone.transform.localPosition = LuaGeometry.GetTempVector3(0, 10, 0)
    else
      PictureManager.Instance:SetUI(_texName[1], self.tex6)
      self.teamZone.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    end
    local diffConfig = goalConfig.Difficulty
    if 0 < #diffConfig then
      local _DifficultyConfig = GameConfig.Pve.Difficulty
      if _DifficultyConfig[diffConfig[1]] and _DifficultyConfig[diffConfig[1]][diffConfig[2]] then
        self.difficulty.text = _DifficultyConfig[diffConfig[1]][diffConfig[2]]
      else
        self.difficulty.text = ""
        redlog("TeamGoals表Difficulty字段与GameConfig.Pve.Difficulty不匹配。TeamGoal id : ", goalConfig.id, diffConfig[1], diffConfig[2])
      end
    else
      self.difficulty.text = ""
    end
    self.roleCtrl:ResetDatas(data:GetRoles())
    local cells = self.roleCtrl:GetCells()
    if cells then
      for i = 1, #cells do
        cells[i]:SetScale(0.5, 0.5)
      end
    end
  else
    self.gameObject:SetActive(false)
  end
end

function TeamCell:CheckApplyValid()
  if not TeamProxy.IsGroupTeamGoal(self.data.type) then
    return not TeamProxy.Instance:IHaveTeam()
  end
  local haveTeam = TeamProxy.Instance:IHaveTeam()
  if haveTeam and self.data.id == Game.Myself.data:GetTeamID() then
    return false
  end
  if haveTeam and self.data:IsGroupTeam() then
    return false
  end
  if not haveTeam or TeamProxy.Instance:IsSubTeamLeader() then
    return true
  else
    return false
  end
end
