autoImport("ChatRoomRecruitCell")
autoImport("Team_RoleCell_Jojo")
ChatRoomMyselfTeamRecruitCell = reusableClass("ChatRoomMyselfTeamRecruitCell", ChatRoomRecruitCell)
ChatRoomMyselfTeamRecruitCell.rid = ResourcePathHelper.UICell("ChatRoomMyselfTeamRecruitCell")
local groupGridY = -81.2
local teamGridY = -98.3

function ChatRoomMyselfTeamRecruitCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomMyselfTeamRecruitCell.rid, parent)
  end
end

function ChatRoomMyselfTeamRecruitCell:FindObjs()
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.68)
  self.headIcon:SetMinDepth(2)
  self.nameLabel = self:FindComponent("name", UILabel)
  self.adventureLabel = self:FindComponent("adventure", UILabel)
  self.currentChannel = self:FindComponent("currentChannel", UILabel)
  self.teamNameLabel = self:FindComponent("teamName", UILabel)
  self.lineLabel = self:FindComponent("line", UILabel)
  self.serverLabel = self:FindComponent("server", UILabel)
  local raid = self:FindGO("raidName")
  self.raidNameLabel = raid:GetComponent(UILabel)
  self.memberGrid = self:FindGO("members")
  local grid = self.memberGrid:GetComponent(UIGrid)
  self.memberList = UIGridListCtrl.new(grid, Team_RoleCell_Jojo, "Team_RoleCell_Jojo")
  self.gotoBtn = self:FindGO("gotoBtn")
  self.gotoBtnLabel = self:FindComponent("Label", UILabel, self.gotoBtn)
  self:AddClickEvent(self.gotoBtn, function()
    self:OnGotoBtnClick()
  end)
  self.disableGotoBtn = self:FindGO("disableGotoBtn")
  self.countdownLabel = self:FindComponent("countdownLabel", UILabel)
  self.top = self:FindGO("Top"):GetComponent(UIWidget)
end

function ChatRoomMyselfTeamRecruitCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    self:SetPublisherData(data)
    local tr = data:GetTeamRecruit()
    self.currentChannel.text = ZhString.ChatRoom_Recruit
    self.teamNameLabel.text = tr.name
    local leaderzone = ChangeZoneProxy.Instance:ZoneNumToString(tr.zoneid, nil, tr.realzoneid)
    self.lineLabel.text = leaderzone
    self.serverLabel.text = tr.serverid
    self.raidNameLabel.text = tr.raidname
    self:SetApplyData(data)
    local fullMemberNum = tr:GetFullMemberNum()
    local memberNum = tr:GetMemberNum()
    local datas = {}
    for i = 1, fullMemberNum do
      if i <= memberNum then
        datas[#datas + 1] = i
      else
        datas[#datas + 1] = "Empty"
      end
    end
    self.memberList:ResetDatas(datas)
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.memberGrid)
    if 6 < fullMemberNum then
      y = groupGridY
    else
      y = teamGridY
    end
    LuaGameObject.SetLocalPositionGO(self.memberGrid, x, y, z)
  end
end

function ChatRoomMyselfTeamRecruitCell:SetApplyData(data)
  TimeTickManager.Me():ClearTick(self, 1)
  self.gotoBtn:SetActive(false)
  self.disableGotoBtn:SetActive(true)
  self.countdownLabel.text = ""
end

function ChatRoomMyselfTeamRecruitCell:OnGotoBtnClick()
  if Game.MapManager:IsInSnowRealmHouseRaid() then
    MsgManager.ShowMsgByIDTable(43722)
    return
  end
  local snowOption = {
    mode = MatchCCmd_pb.ESNOWROOM_MODE_WEEKLYACT
  }
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.SnowRealm, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, snowOption)
end
