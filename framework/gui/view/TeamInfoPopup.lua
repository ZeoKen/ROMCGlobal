autoImport("TeamInfoPortrait")
TeamInfoPopup = class("TeamInfoPopup", ContainerView)
TeamInfoPopup.ViewType = UIViewType.PopUpLayer

function TeamInfoPopup:Init()
  self:FindOBJ()
end

function TeamInfoPopup:FindOBJ()
  self.baseInfoPage = self:FindGO("BaseInfoPage")
  self.teamNameLab = self:FindComponent("TeamNameLab", UILabel)
  self.leaderNameTip = self:FindComponent("LeaderNameTip", UILabel)
  self.leaderNameTip.text = ZhString.TeamInfoPopup_LeaderName
  self.leaderNameLab = self:FindComponent("Lab", UILabel, self.leaderNameTip.gameObject)
  self.descTip = self:FindComponent("TeamDescTip", UILabel)
  self.descTip.text = ZhString.TeamInfoPopup_Desc
  self.descLab = self:FindComponent("Lab", UILabel, self.descTip.gameObject)
  self.typeTip = self:FindComponent("CurTeamTypeTip", UILabel)
  self.typeTip.text = ZhString.TeamInfoPopup_Type
  self.typeLab = self:FindComponent("Lab", UILabel, self.typeTip.gameObject)
  self.lvTip = self:FindComponent("TeamLvTip", UILabel)
  self.lvTip.text = ZhString.TeamInfoPopup_Lv
  self.lvLab = self:FindComponent("Lab", UILabel, self.lvTip.gameObject)
  self.memberBg = self:FindComponent("MemberBg", UISprite)
  self.memberGrid = self:FindComponent("Grid", UIGrid)
  self.memberListCtl = UIGridListCtrl.new(self.memberGrid, TeamInfoPortrait, "TeamInfoPortrait")
  self.memberListCtl:AddEventListener(MouseEvent.MouseClick, function(owner, cell)
    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end, self)
  self.baseInfoRoot = self:FindGO("BaseInfoPage")
  self.memberRoot = self:FindGO("MemberBg")
  self.memberBg = self.memberRoot:GetComponent(UISprite)
  self.bottomFrame = self:FindGO("BottomFrame")
end

TeamInfoPopup.emptyMD = "EMPTY"

function TeamInfoPopup:Show()
  local data = self.tmData
  local isGroup = data:IsGroupTeam()
  self.bottomFrame:SetActive(isGroup)
  if isGroup then
    self.baseInfoRoot.transform.localPosition = LuaGeometry.GetTempVector3(0, 19, 0)
    self.memberRoot.transform.localPosition = LuaGeometry.GetTempVector3(2, -62, 0)
    self.memberBg.height = 250
  else
    self.baseInfoRoot.transform.localPosition = LuaGeometry.GetTempVector3(0, -23, 0)
    self.memberRoot.transform.localPosition = LuaGeometry.GetTempVector3(2, -106, 0)
    self.memberBg.height = 163
  end
  self.teamNameLab.text = data.name
  local leader = data:GetLeader()
  self.leaderNameLab.text = leader and leader.name or ""
  self.descLab.text = data.desc
  self.typeLab.text = data.type and Table_TeamGoals[data.type] and Table_TeamGoals[data.type].NameZh or ""
  self.lvLab.text = tostring(data.minlv) .. "~" .. tostring(data.maxlv)
  local mdata = data:GetMembersList()
  local teamNum = GameConfig.Team.maxmember
  local maxNum = isGroup and teamNum * 2 or teamNum
  maxNum = maxNum - #mdata
  for i = 1, maxNum do
    table.insert(mdata, TeamInfoPopup.emptyMD)
  end
  self.memberListCtl:ResetDatas(mdata)
end

function TeamInfoPopup:OnEnter()
  TeamInfoPopup.super.OnEnter(self)
  self.tmData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.teamdata
  if self.tmData then
    self:Show()
  end
end
