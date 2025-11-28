autoImport("MainViewThanatosFirstPage")
autoImport("MainViewThanatosSecondPage")
autoImport("MainViewThanatosThirdPage")
autoImport("MainViewThanatosFourthPage")
MainViewThanatosPage = class("MainViewThanatosPage", SubMediatorView)
local RaidConfig = {
  [35] = 1,
  [36] = 2,
  [38] = 3,
  [40] = 4
}
MainViewThanatosPage.HideUI = {
  HideTeaminfo = 1,
  HideBuffinfo = 2,
  HideBossinfo = 3,
  HideEnergyinfo = 4,
  HideCystalInfo = 5,
  HidePanelControl = 6,
  HideCountCrystal = 7
}
local originPos = LuaVector3(115, -28, 0)

function MainViewThanatosPage:Show(tarObj)
  local anchorLeft = Game.GameObjectUtil:DeepFindChild(self.mainviewParent.gameObject, "Anchor_Left")
  self.teamObj.transform.parent = anchorLeft.transform
  self.teamObj.transform.localPosition = originPos
  local index = self:GetStatePageIndex()
  if index ~= nil and self.currentPageIndex ~= index then
    if self.currentPageIndex ~= nil then
      local lastPage = self.statePage[index]
      if lastPage ~= nil then
        lastPage:Hide(target)
      end
    end
    local page = self.statePage[index]
    if page ~= nil then
      page:Show(tarObj)
      self:ResetView()
      self.currentPageIndex = index
      self.isIn = true
    end
  end
  self.listUniteMembers:ResetPosition()
  MainViewThanatosPage.super.Show(self)
end

function MainViewThanatosPage:Hide(target)
  self.teamObj.transform.parent = self.gameObject.transform
  local index = self:GetStatePageIndex()
  if index ~= nil then
    local page = self.statePage[index]
    if page ~= nil then
      self.topFunc1:SetActive(true)
      self.topFunc2:SetActive(true)
      page:Hide(target)
      self.isIn = false
      self.currentPageIndex = nil
    end
  end
  MainViewThanatosPage.super.Hide(self)
end

function MainViewThanatosPage:Init()
  self:ReLoadPerferb("view/MainViewThanatosPage")
  self.statePage = {}
  self.statePage[1] = self:AddSubView("MainViewThanatosFirstPage", MainViewThanatosFirstPage)
  self.statePage[2] = self:AddSubView("MainViewThanatosSecondPage", MainViewThanatosSecondPage)
  self.statePage[3] = self:AddSubView("MainViewThanatosThirdPage", MainViewThanatosThirdPage)
  self.statePage[4] = self:AddSubView("MainViewThanatosFourthPage", MainViewThanatosFourthPage)
  self:FindObjs()
  self:AddViewEvents()
end

function MainViewThanatosPage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateRevive)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateGroupUniteTeamMembers)
end

function MainViewThanatosPage:FindObjs()
  if not self.teamObj then
    self.mainviewParent = self.gameObject.transform.parent
    self.anchorLeft = Game.GameObjectUtil:DeepFindChild(self.mainviewParent.gameObject, "Anchor_Left")
    self.teamObj = self:FindGO("TeamInfo")
    self.teamObj.transform.localPosition = originPos
    local reviveLabel = self:FindGO("revive", self.teamObj):GetComponent(UILabel)
    reviveLabel.text = ZhString.Thanatos_Revive
    self.reviveCount = self:FindGO("reviveCount", self.teamObj):GetComponent(UILabel)
    self.memberBg = self:FindGO("bg", self.teamObj)
    self.memberBg:SetActive(false)
    self.teamObj.transform.parent = self.anchorLeft.transform
    self.teamObj:SetActive(false)
  end
  self.controlPanel = self:FindGO("ControlPanel")
  self.controlPanel:SetActive(false)
  local TeamBtn = self:FindGO("TeamBtn")
  self.teamsp = self:FindGO("icon", TeamBtn):GetComponent(UISprite)
  self.toggleteam = false
  self:AddClickEvent(TeamBtn, function()
    if self.toggleteam then
      self.teamsp.color = ColorUtil.NGUIWhite
    else
      self.teamsp.color = ColorUtil.NGUIDeepGray
    end
    self.teamObj:SetActive(self.toggleteam)
    if self.toggleteam then
      self.listUniteMembers:Layout()
    end
    self.toggleteam = not self.toggleteam
  end)
  self.listUniteMembers = UIGridListCtrl.new(self:FindComponent("gridMembers", UIGrid, self.teamObj), MemberSelectCell, "PlayerSelectCell")
  self.listUniteMembers:AddEventListener(MouseEvent.MouseClick, self.ClickUniteMemberCell, self)
  self.topFunc1 = Game.GameObjectUtil:DeepFindChild(self.mainviewParent.gameObject, "TopRightFunc")
  self.topFunc2 = Game.GameObjectUtil:DeepFindChild(self.mainviewParent.gameObject, "TopRightFunc2")
  local TopFuncBtn = self:FindGO("TopFuncBtn")
  self.TopFuncsp = self:FindGO("icon", TopFuncBtn):GetComponent(UISprite)
  self.toggletopfunc = false
  self.topFunc1:SetActive(true)
  self.topFunc2:SetActive(true)
  self:AddClickEvent(TopFuncBtn, function()
    if self.toggletopfunc then
      self.TopFuncsp.color = ColorUtil.NGUIWhite
    else
      self.TopFuncsp.color = ColorUtil.NGUIDeepGray
    end
    self.topFunc1:SetActive(self.toggletopfunc)
    self.topFunc2:SetActive(self.toggletopfunc)
    self.toggletopfunc = not self.toggletopfunc
  end)
  self.raidObj = self:FindGO("RaidInfo")
  self.buffObj = self:FindGO("BuffInfo")
  local RaidBtn = self:FindGO("RaidBtn")
  self.Raidsp = self:FindGO("icon", RaidBtn):GetComponent(UISprite)
  self.arrow = self:FindGO("arrow"):GetComponent(UISprite)
  self.toggleraid = false
  if self.raidObj then
    self.raidObj:SetActive(true)
  end
  self:AddClickEvent(RaidBtn, function()
    if self.toggleraid then
      self.Raidsp.color = ColorUtil.NGUIWhite
    else
      self.Raidsp.color = ColorUtil.NGUIDeepGray
    end
    if self.raidObj then
      self.raidObj:SetActive(self.toggleraid)
    end
    if self.buffObj then
      self.buffObj:SetActive(self.toggleraid)
    end
    self.toggleraid = not self.toggleraid
  end)
  local toggle = self:FindGO("Toggle")
  self.controlNode = self:FindGO("ControlNode")
  self.controlToggle = false
  self.controlNode:SetActive(false)
  self:AddClickEvent(toggle, function()
    self.controlToggle = not self.controlToggle
    self.controlNode:SetActive(self.controlToggle)
    self.arrow.flip = self.controlToggle and 1 or 0
  end)
  self.uibtn = self:FindGO("UIBtn")
  self:AddClickEvent(self.uibtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RaidStatisticsView
    })
  end)
end

function MainViewThanatosPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewThanatosPage:ResetView()
  self.teamObj:SetActive(true)
  self.controlPanel:SetActive(true)
  self.raidObj:SetActive(true)
  self.topFunc1:SetActive(true)
  self.topFunc2:SetActive(true)
  self.toggleteam = false
  self.toggletopfunc = false
  self.toggleraid = false
  self.Raidsp.color = ColorUtil.NGUIWhite
  self.teamsp.color = ColorUtil.NGUIWhite
  self.TopFuncsp.color = ColorUtil.NGUIWhite
  self:UpdateTeamInfoBg()
end

function MainViewThanatosPage:GetStatePageIndex()
  return RaidConfig[Game.DungeonManager:GetRaidType()]
end

local revive = 0
local maxRevive = 0

function MainViewThanatosPage:UpdateRevive(note)
  local data = note and note.body
  if data then
    revive = data.count
    maxRevive = data.maxcount
    GroupRaidProxy.Instance:SaveCanRevive(0 < maxRevive - revive)
    self.reviveCount.text = string.format("%d/%d", maxRevive - revive, maxRevive)
  else
    self.reviveCount.text = "0/0"
  end
end

function MainViewThanatosPage:UpdateGroupUniteTeamMembers()
  if not self.isIn then
    return
  end
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  self.listUniteMembers:ResetDatas(uniteTeam and uniteTeam:GetMembersList())
  self.listUniteMembers:ResetPosition()
  self:UpdateTeamInfoBg()
end

function MainViewThanatosPage:UpdateTeamInfoBg()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  local data = uniteTeam and uniteTeam:GetMembersList()
  self.memberBg:SetActive(nil ~= data and nil ~= next(data))
end

function MainViewThanatosPage:ClickUniteMemberCell(cell)
  local creature = NSceneUserProxy.Instance:Find(cell.id)
  if creature then
    Game.Myself:Client_LockTarget(creature)
  end
end
