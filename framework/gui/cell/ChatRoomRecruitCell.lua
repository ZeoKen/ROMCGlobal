autoImport("BaseCell")
autoImport("Team_RoleCell")
ChatRoomRecruitCell = reusableClass("ChatRoomRecruitCell", BaseCell)
ChatRoomRecruitCell.PoolSize = 60
local disableJoinBtnCD = 15
local localData = {}
local groupGridY = -81.2
local teamGridY = -98.3

function ChatRoomRecruitCell:Construct(asArray, args)
  self._alive = true
  self.parent = args
  if self.gameObject == nil then
    self:CreateSelf(self.parent)
    self:FindObjs()
    self:AddEvts()
    self:InitShow()
  else
    self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject, self.parent)
  end
end

function ChatRoomRecruitCell:Deconstruct()
  self._alive = false
  self.data = nil
  TimeTickManager.Me():ClearTick(self)
  Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatRoomRecruitCell:Alive()
  return self._alive
end

function ChatRoomRecruitCell:Finalize()
  GameObject.Destroy(self.gameObject)
end

function ChatRoomRecruitCell:CreateSelf(parent)
end

function ChatRoomRecruitCell:FindObjs()
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
  self.levelLabel = self:FindComponent("level", UILabel, raid)
  self.memberGrid = self:FindGO("members")
  local grid = self.memberGrid:GetComponent(UIGrid)
  self.memberList = UIGridListCtrl.new(grid, Team_RoleCell, "Team_RoleCell")
  self.joinBtn = self:FindGO("joinBtn")
  self.joinBtnLabel = self:FindComponent("Label", UILabel, self.joinBtn)
  self:AddClickEvent(self.joinBtn, function()
    self:OnJoinBtnClick()
  end)
  self.disableJoinBtn = self:FindGO("disableJoinBtn")
  self.countdownLabel = self:FindComponent("countdownLabel", UILabel)
  self.top = self:FindGO("Top"):GetComponent(UIWidget)
end

function ChatRoomRecruitCell:AddEvts()
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(ChatRoomEvent.SelectHead, self)
  end)
end

function ChatRoomRecruitCell:InitShow()
end

function ChatRoomRecruitCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    self:SetPublisherData(data)
    self.currentChannel.text = ZhString.ChatRoom_Recruit
    self.teamNameLabel.text = data.name
    local leader = data:GetLeader()
    local leaderzone = ChangeZoneProxy.Instance:ZoneNumToString(leader.zoneid, nil, leader.realzoneid)
    self.lineLabel.text = leaderzone
    self.serverLabel.text = leader:GetServerId()
    if data.type and Table_TeamGoals[data.type] then
      self.raidNameLabel.text = Table_TeamGoals[data.type].NameZh
    end
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local islvOutRange = mylv < data.minlv
    if islvOutRange then
      self.levelLabel.text = string.format("[c][ff0000]Lv.%s+[-][/c]", tostring(data.minlv))
    else
      self.levelLabel.text = string.format("Lv.%s+", tostring(data.minlv))
    end
    self.joinBtnLabel.text = TeamProxy.Instance:CheckIHaveLeaderAuthority() and ZhString.TeamCell_GroupApply or ZhString.TeamCell_Apply
    self:SetApplyData(data)
    local members = data:GetFullMembers()
    self.memberList:ResetDatas(data:GetRoles())
    local cells = self.memberList:GetCells()
    if cells then
      for i = 1, #cells do
        cells[i]:SetScale(0.38, 0.45)
      end
    end
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.memberGrid)
    if 6 < #members then
      y = groupGridY
    else
      y = teamGridY
    end
    LuaGameObject.SetLocalPositionGO(self.memberGrid, x, y, z)
    if self.waitToReqJoin then
      self:OnRecruitTeamInfoUpdate()
      self.waitToReqJoin = nil
    end
  end
end

function ChatRoomRecruitCell:SetPublisherData(data)
  self.nameLabel.text = data:GetName()
  local appellation = Table_Appellation[data:GetAppellation()]
  if appellation then
    self.adventureLabel.text = appellation.Level
  else
    self.adventureLabel.text = ""
  end
  local portrait = data:GetPortrait()
  local headData = Table_HeadImage[portrait]
  if portrait and portrait ~= 0 and headData and headData.Picture then
    self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
    self.headIcon:SetPortraitFrame(data:GetPortraitFrame())
  else
    TableUtility.TableClear(localData)
    localData.hairID = data:GetHair()
    localData.haircolor = data:GetHaircolor()
    localData.bodyID = data:GetBody()
    localData.headID = data:GetHead()
    localData.faceID = data:GetFace()
    localData.mouthID = data:GetMouth()
    localData.eyeID = data:GetEye()
    localData.gender = data:GetGender()
    localData.blink = data:GetBlink()
    localData.portraitframe = data:GetPortraitFrame()
    self.headIcon:SetData(localData)
  end
end

function ChatRoomRecruitCell:SetApplyData(data)
  local applyInfo = TeamProxy.Instance:GetUserApply(data.id)
  if applyInfo and applyInfo.createtime then
    local duringTime = GameConfig.Team.applyovertime - (ServerTime.CurServerTime() / 1000 - applyInfo.createtime)
    TimeTickManager.Me():CreateTick(0, 1000, function()
      if 0 <= duringTime then
        self.joinBtn:SetActive(false)
        self.disableJoinBtn:SetActive(false)
        self.countdownLabel.text = string.format(ZhString.TeamCell_Applying, ClientTimeUtil.GetFormatSecTimeStr(duringTime))
        duringTime = duringTime - 1
      else
        TimeTickManager.Me():ClearTick(self, 1)
        TeamProxy.Instance:RemoveApply(self.data.id)
        self.joinBtn:SetActive(true)
        self.countdownLabel.text = ""
      end
    end, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    local joinBtnState = TeamProxy.Instance:IsRecruitTeamCanApply(data.id)
    self.joinBtn:SetActive(joinBtnState)
    self.disableJoinBtn:SetActive(not joinBtnState)
    self.countdownLabel.text = ""
  end
end

function ChatRoomRecruitCell:OnJoinBtnClick()
  if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(334)
    self:DisableJoinBtn()
    return
  end
  self.waitToReqJoin = true
  self:PassEvent(TeamEvent.UpdateRecruitTeamInfo, self.data.id)
end

function ChatRoomRecruitCell:OnRecruitTeamInfoUpdate()
  if self.data:IsTeamFull() and self.data:IsGroupTeamFull() then
    MsgManager.ShowMsgByID(302)
    self:DisableJoinBtn()
    return
  end
  local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local islvOutRange = mylv < self.data.minlv or mylv > self.data.maxlv
  if islvOutRange then
    MsgManager.ShowMsgByID(305)
    self:DisableJoinBtn()
    return
  end
  FunctionTeam.DoApply(self.data)
end

function ChatRoomRecruitCell:DisableJoinBtn()
  self.joinBtn:SetActive(false)
  self.disableJoinBtn:SetActive(true)
  TimeTickManager.Me():CreateOnceDelayTick(disableJoinBtnCD * 1000, function()
    self.joinBtn:SetActive(true)
    self.disableJoinBtn:SetActive(false)
  end, self)
end
