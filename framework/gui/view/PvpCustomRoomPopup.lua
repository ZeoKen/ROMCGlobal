autoImport("TeamPwsCustomRoomInfoPopup")
autoImport("PvpCustomRoomMemberCombineCell")
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    local row = 1
    local idx = 1
    local num = #datas
    while idx <= num do
      newData[row] = newData[row] or {}
      local invalidRow = true
      for colum = 1, perRowNum do
        if datas[idx] == nil or datas[idx].id == nil then
          newData[row][colum] = nil
        else
          invalidRow = false
          newData[row][colum] = datas[idx]
        end
        idx = idx + 1
      end
      if invalidRow then
        table.remove(newData, row)
      else
        row = row + 1
      end
    end
  end
  return newData
end
local _textureName = "calendar_bg1_picture2"
local _PictureManager
PvpCustomRoomPopup = class("PvpCustomRoomPopup", TeamPwsCustomRoomInfoPopup)
PvpCustomRoomPopup.ViewType = UIViewType.PopUpLayer

function PvpCustomRoomPopup:Init()
  self:_Init()
  PvpCustomRoomPopup.super.Init(self)
end

function PvpCustomRoomPopup:_Init()
  _PictureManager = PictureManager.Instance
  self.homeEmptyObj = self:FindGO("HomeEmptyObj")
  self.awayEmptyObj = self:FindGO("AwayEmptyObj")
  self.team1InviteBtn = self:FindGO("Team1InviteBtn")
  self:AddClickEvent(self.team1InviteBtn, function()
    self:OnInviteTeam(1)
  end)
  self.team2InviteBtn = self:FindGO("Team2InviteBtn")
  self:AddClickEvent(self.team2InviteBtn, function()
    self:OnInviteTeam(2)
  end)
  self.team1MemberCnt = self:FindComponent("Team1MemberCnt", UILabel)
  self.team2MemberCnt = self:FindComponent("Team2MemberCnt", UILabel)
  self.teamTex1 = self:FindComponent("TeamTexture1", UITexture)
  self.teamTex2 = self:FindComponent("TeamTexture2", UITexture)
end

function PvpCustomRoomPopup:OnEnter()
  PvpCustomRoomPopup.super.OnEnter(self)
  _PictureManager:SetUI(_textureName, self.teamTex1)
  _PictureManager:SetUI(_textureName, self.teamTex2)
end

function PvpCustomRoomPopup:OnExit()
  PvpCustomRoomPopup.super.OnExit(self)
  _PictureManager:UnLoadUI(_textureName, self.teamTex1)
  _PictureManager:UnLoadUI(_textureName, self.teamTex2)
end

function PvpCustomRoomPopup:OnInviteTeam(team_index)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamInvitePopUp,
    viewdata = {
      isCustomRoomInvite = true,
      etype = PvpProxy.Type.TwelvePVPRelax,
      teamType = team_index
    }
  })
end

function PvpCustomRoomPopup:InitTeamCtl()
  local ListTeamHomeContainer = self:FindGO("ListTeamHome")
  local home_wrap = {}
  home_wrap.wrapObj = ListTeamHomeContainer
  home_wrap.pfbNum = 9
  home_wrap.cellName = "PvpCustomRoomMemberCombineCell"
  home_wrap.control = PvpCustomRoomMemberCombineCell
  home_wrap.disableDragIfFit = true
  self.listTeamHome = WrapCellHelper.new(home_wrap)
  self.listTeamHome:AddEventListener(UICellEvent.OnCellClicked, self.OnRoomCellClicked, self)
  self.listTeamHome:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnPlayerClicked, self)
  self.listTeamHome:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnKickPlayerClicked, self)
  local ListTeamAwayContainer = self:FindGO("ListTeamAway")
  local away_wrap = {}
  away_wrap.wrapObj = ListTeamAwayContainer
  away_wrap.pfbNum = 9
  away_wrap.cellName = "PvpCustomRoomMemberCombineCell"
  away_wrap.control = PvpCustomRoomMemberCombineCell
  away_wrap.disableDragIfFit = true
  self.listTeamAway = WrapCellHelper.new(away_wrap)
  self.listTeamAway:AddEventListener(UICellEvent.OnCellClicked, self.OnRoomCellClicked, self)
  self.listTeamAway:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnPlayerClicked, self)
  self.listTeamAway:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnKickPlayerClicked, self)
end

function PvpCustomRoomPopup:UpdateHomeAwayMembers()
  local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if not roomData then
    return
  end
  local home_members = roomData.homeMembers or {}
  local away_members = roomData.awayMembers or {}
  self.listTeamHome:ResetDatas(ReUniteCellData(home_members, 2))
  self.listTeamAway:ResetDatas(ReUniteCellData(away_members, 2))
  self.homeEmptyObj:SetActive(roomData.teamonenum == 0)
  self.awayEmptyObj:SetActive(roomData.teamtwonum == 0)
  self.team1MemberCnt.text = string.format(ZhString.PvpCustomRoom_MemberCount, roomData.teamonenum)
  self.team2MemberCnt.text = string.format(ZhString.PvpCustomRoom_MemberCount, roomData.teamtwonum)
end
