DisneyTeamView = class("DisneyTeamView", ContainerView)
DisneyTeamView.ViewType = UIViewType.NormalLayer
autoImport("DisneyTeamMemberCell")
autoImport("DisneyRoleHeadCell")
local _TeamProxy, _DisneyStageProxy, _MyGUID
local DoLeave = function()
  MsgManager.ConfirmMsgByID(42053, function()
    if _TeamProxy:IHaveTeam() then
      ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id)
    end
  end, nil, nil, _TeamProxy.myTeam.name)
end
local _prepareBtnSpName = {
  "new-com_btn_a",
  "new-com_btn_a_gray"
}
local _prepareBtnLabOutlineColor = {
  Color(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1),
  Color(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
}
local _prepareGrayLabColor = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
local _whiteLabColor = ColorUtil.NGUIWhite

function DisneyTeamView:DoChangePrepare()
  if _DisneyStageProxy:IsInMusic() then
    self:TryToMusicView()
    return
  end
  if not _DisneyStageProxy:IsInPrepare() then
    return
  end
  if _DisneyStageProxy:AllPrepared() then
    if self:TryToMusicView() then
      return
    end
    if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      local r = math.random(#Table_DisneySong)
      helplog("DisneyStage -------> CallDisneyMusicChooseMusicCmd： ", r)
      ServiceDisneyActivityProxy.Instance:CallDisneyMusicChooseMusicCmd(r)
    else
      ServiceDisneyActivityProxy.Instance:CallDisneyMusicPrepareCmd(false)
    end
  else
    local isPrepared = _DisneyStageProxy:IsPrepared(_MyGUID)
    helplog("DisneyStage -------> CallDisneyMusicPrepareCmd ", not isPrepared)
    ServiceDisneyActivityProxy.Instance:CallDisneyMusicPrepareCmd(not isPrepared)
  end
end

function DisneyTeamView:Init()
  _TeamProxy = TeamProxy.Instance
  _DisneyStageProxy = DisneyStageProxy.Instance
  _MyGUID = Game.Myself.data.id
  self:InitView()
  self:AddEvent()
end

function DisneyTeamView:InitView()
  local titleLab = self:FindComponent("Title", UILabel)
  titleLab.text = ZhString.DisneyTeam_Title
  local exitBtn = self:FindGO("ExitBtn")
  self:AddClickEvent(exitBtn, function(go)
    DoLeave()
  end)
  local exitLab = self:FindComponent("Lab", UILabel, exitBtn)
  exitLab.text = ZhString.DisneyTeam_Exit
  self.prepareButton = self:FindComponent("PrepareButton", UISprite)
  self.prepareButtonColider = self.prepareButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.prepareButton.gameObject, function(go)
    self:DoChangePrepare()
  end)
  self.prepareLab = self:FindComponent("Lab", UILabel, self.prepareButton.gameObject)
  self.selectRoleTipLab = self:FindComponent("SelectRoleTipLab", UILabel)
  self.selectRoleTipLab.text = ZhString.DisneyTeam_SelectRole
  self.memberGrid = self:FindComponent("MemberGrid", UIGrid)
  self.memberlist = UIGridListCtrl.new(self.memberGrid, DisneyTeamMemberCell, "DisneyTeamMemberCell")
  self.heroGrid = self:FindComponent("HeroGrid", UIGrid)
  self.herolist = UIGridListCtrl.new(self.heroGrid, DisneyRoleHeadCell, "DisneyRoleHeadCell")
  self.herolist:AddEventListener(MouseEvent.MouseClick, self.OnClickRole, self)
end

function DisneyTeamView:OnClickRole(cell)
  local data = cell.data
  if data then
    if _DisneyStageProxy:GetMyDisneyHeroId() == data.id then
      return
    end
    if data.isSelected then
      MsgManager.ShowMsgByID(42054)
      return
    end
    helplog("DisneyStage -------> CallDisneyMusicChooseHeroCmd : ", data.id)
    ServiceDisneyActivityProxy.Instance:CallDisneyMusicChooseHeroCmd(data.id)
  end
end

function DisneyTeamView:UpdateTeam()
  if not _TeamProxy:IHaveTeam() then
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local leaderAuthority = TeamProxy.Instance:CheckIHaveLeaderAuthority()
  self:UpdateMembers()
end

local memberDatas = {}

function DisneyTeamView:UpdateMembers()
  local myTeam = _TeamProxy.myTeam
  local memberList = myTeam:GetPlayerMemberList(true, true)
  TableUtility.ArrayClear(memberDatas)
  for i = 1, #memberList do
    table.insert(memberDatas, memberList[i])
  end
  if #memberDatas < GameConfig.Team.maxmember then
    for i = 1, GameConfig.Team.maxmember - #memberDatas do
      table.insert(memberDatas, MyselfTeamData.EMPTY_STATE)
    end
  end
  self.memberlist:ResetDatas(memberDatas)
end

function DisneyTeamView:AddEvent()
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMembers)
  self:AddListenEvt(ServiceEvent.DisneyActivityDisneyMusicUpdateCmd, self.HandleMusicDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(DisneyEvent.DisneyMusicStatusChanged, self.TryToMusicView)
end

function DisneyTeamView:TryToMusicView()
  if _DisneyStageProxy:IsInMusic() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DisneyMusicView
    })
    return true
  end
  return false
end

function DisneyTeamView:HandleMusicDataUpdate()
  self:UpdateMembers()
  self:UpdateHeroHeads()
  self:UpdatePrepareBtn()
end

function DisneyTeamView:UpdateHeroHeads()
  local heroData = _DisneyStageProxy:GetHeroData()
  self.herolist:ResetDatas(heroData)
end

function DisneyTeamView:UpdatePrepareBtn()
  local prepared = _DisneyStageProxy:IsPrepared(_MyGUID)
  if prepared then
    if TeamProxy.Instance:CheckIHaveLeaderAuthority() and _DisneyStageProxy:AllPrepared() then
      self.prepareLab.text = ZhString.DisneyTeam_ChooseMusic
    else
      self.prepareLab.text = ZhString.DisneyTeam_CancelPrepare
    end
  else
    self.prepareLab.text = ZhString.DisneyTeam_Prepare
  end
  local inPrepareOrInMusic = _DisneyStageProxy:IsInPrepare() or _DisneyStageProxy:IsInMusic()
  if inPrepareOrInMusic then
    self.prepareButton.spriteName = _prepareBtnSpName[1]
    self.prepareLab.color = _whiteLabColor
    self.prepareLab.effectColor = _prepareBtnLabOutlineColor[1]
    self.prepareButtonColider.enabled = true
  else
    self.prepareButton.spriteName = _prepareBtnSpName[2]
    self.prepareLab.color = _prepareGrayLabColor
    self.prepareLab.effectColor = _prepareBtnLabOutlineColor[2]
    self.prepareButtonColider.enabled = false
  end
  local isSelected = _DisneyStageProxy:HasSelected(_MyGUID)
  self.selectRoleTipLab.gameObject:SetActive(not isSelected)
end

function DisneyTeamView:OnEnter()
  DisneyTeamView.super.OnEnter(self)
  _DisneyStageProxy:QueryDisneyMusicOpen()
  UIModelUtil.Instance:ResetAllTextures()
  self:UpdateHeroHeads()
end

function DisneyTeamView:OnExit()
  DisneyTeamView.super.OnExit(self)
  FunctionPlayerTip.Me():CloseTip()
end
