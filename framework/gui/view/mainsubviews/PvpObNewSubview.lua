autoImport("PvpObHeadCell")
autoImport("BranchMgr")
PvpObNewSubview = class("PvpObNewSubview", SubView)
local viewName = "PvpObNewSubview"
local viewPath = ResourcePathHelper.UIView(viewName)

function PvpObNewSubview:ctor(container, initParams, subViewData)
  PvpObNewSubview.super.ctor(self, container, initParams, subViewData)
  if initParams then
    self.proxy = initParams.proxy
    self.launchEvent = initParams.launchEvent
  end
end

function PvpObNewSubview:LoadPrefab()
end

function PvpObNewSubview:Init()
  self:LoadPrefab()
  self:FindObjs()
  self:UpdateView()
  self:SetExpand(true)
end

function PvpObNewSubview:FindObjs()
  self.playtween = self.obRootGO:GetComponent(UIPlayTween)
  local anchorCenterTopGO = self:FindGO("Anchor_CenterTop")
  self.twelvePlusGO = self:FindGO("TwelveIcon", anchorCenterTopGO)
  self.twelvePlusGO:SetActive(BranchMgr.IsVN() and true or false)
  local anchorLeftTopGO = self:FindGO("Anchor_LeftTop")
  self.timeLab = self:FindComponent("TimeLab", UILabel, anchorLeftTopGO)
  self.detailBtnGO = self:FindGO("DetailButton", anchorLeftTopGO)
  self:AddClickEvent(self.detailBtnGO, function()
    self:OnDetailClicked()
  end)
  local anchorLeftCenterGO = self:FindGO("Anchor_LeftCenter")
  self.leftCenterStick = anchorLeftCenterGO:GetComponent(UIWidget)
  self.leftHeadRootGO = self:FindGO("HeadRoot", anchorLeftCenterGO)
  self.leftTeamName = self:FindComponent("TeamName", UILabel, self.leftHeadRootGO)
  self.leftHeadGrid = self:FindComponent("gridPlayers", UIGrid, self.leftHeadRootGO)
  self.leftHeadListCtrl = UIGridListCtrl.new(self.leftHeadGrid, PvpObHeadCell, "PvpObHeadCell")
  self.leftHeadListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHeadCellClicked, self)
  local anchorRightCenterGO = self:FindGO("Anchor_RightCenter")
  self.rightCenterStick = anchorRightCenterGO:GetComponent("UIWidget")
  self.rightHeadRootGO = self:FindGO("HeadRoot", anchorRightCenterGO)
  self.rightTeamName = self:FindComponent("TeamName", UILabel, self.rightHeadRootGO)
  self.rightHeadGrid = self:FindComponent("gridPlayers", UIGrid, self.rightHeadRootGO)
  self.rightHeadListCtrl = UIGridListCtrl.new(self.rightHeadGrid, PvpObHeadCell, "PvpObHeadCell")
  self.rightHeadListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHeadCellClicked, self)
  local anchorLeftBottomGO = self:FindGO("Anchor_LeftBottom")
  self.settingBtnGO = self:FindGO("SettingBtn", anchorLeftBottomGO)
  self:AddClickEvent(self.settingBtnGO, function()
    self:OnSettingClicked()
  end)
  if GameConfig.ObModeConfig and GameConfig.ObModeConfig.HideSetting == 1 then
    self.settingBtnGO:SetActive(false)
  else
    self.settingBtnGO:SetActive(true)
  end
  local expandBtnGO = self:FindGO("ExpandBtn", anchorLeftBottomGO)
  self:AddClickEvent(expandBtnGO, function()
    self:OnExpandClicked()
  end)
  self.expandIcon = self:FindComponent("Icon", UIMultiSprite, expandBtnGO)
  self.stick = self:FindComponent("TipStick", UIWidget)
end

function PvpObNewSubview:OnEnter()
  self:InitListenEvents()
  PvpObNewSubview.super.OnEnter(self)
end

function PvpObNewSubview:OnExit()
  PvpObNewSubview.super.OnExit(self)
  if self.leftHeadListCtrl then
    self.leftHeadListCtrl:RemoveAll()
  end
  if self.rightHeadListCtrl then
    self.rightHeadListCtrl:RemoveAll()
  end
  self:StopTimeTick()
end

function PvpObNewSubview:InitListenEvents()
  self:AddDispatcherEvt(ServiceEvent.MatchCCmdObInitInfoFubenCmd, self.UpdatePlayerCells)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdObserverAttachFubenCmd, self.HandleAttachPlayer)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerHpSpUpdate, self.HandlePlayerHpSpUpdate)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerOffline, self.HandleObPlayerOffline)
  self:AddDispatcherEvt(MyselfEvent.ObservationSelectPlayer, self.HandleSelectPlayer)
end

function PvpObNewSubview:Show()
  if self.obRootGO then
    self.obRootGO:SetActive(true)
  end
  self:UpdateView()
end

function PvpObNewSubview:Hide()
  if self.obRootGO then
    self.obRootGO:SetActive(false)
  end
  self:StopTimeTick()
end

function PvpObNewSubview:UpdateView()
  self:UpdatePlayerCells()
end

function PvpObNewSubview:OnDetailClicked()
end

function PvpObNewSubview:OnHeadCellClicked(cell)
  local playerid = cell.data and cell.data.playerid
  if not playerid then
    return
  end
  if cell.data.offline then
    return
  end
  PvpObserveProxy.Instance:TryAttach(playerid)
end

function PvpObNewSubview:HandleAttachPlayer(data)
  local attchPlayerId = PvpObserveProxy.Instance:GetAttachPlayer()
  local cells = self.leftHeadListCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetAttach(attchPlayerId)
    cell:SetChoosen(attchPlayerId)
  end
  cells = self.rightHeadListCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetAttach(attchPlayerId)
    cell:SetChoosen(attchPlayerId)
  end
end

function PvpObNewSubview:HandleSelectPlayer(playerId)
  if not PvpObserveProxy.Instance:IsGhost() then
    return
  end
  local cells = self.leftHeadListCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetAttach(nil)
    cell:SetChoosen(playerId)
  end
  cells = self.rightHeadListCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetAttach(nil)
    cell:SetChoosen(playerId)
  end
end

function PvpObNewSubview:HandlePlayerHpSpUpdate(ids)
  if not ids then
    return
  end
  local proxy = PvpObserveProxy.Instance
  local leftPlayerCells = self.leftHeadListCtrl:GetCells()
  local rightPlayerCells = self.rightHeadListCtrl:GetCells()
  for i = 1, #ids do
    local uid = ids[i]
    if uid then
      for _, player in pairs(leftPlayerCells) do
        if player.playerid == uid then
          local data = proxy:GetPlayerDataById(ids[i])
          if data then
            player:UpdateHpSp(data.hp, data.mp)
          end
        end
      end
      for _, player in pairs(rightPlayerCells) do
        if player.playerid == uid then
          local data = proxy:GetPlayerDataById(ids[i])
          if data then
            player:UpdateHpSp(data.hp, data.mp)
          end
        end
      end
    end
  end
end

function PvpObNewSubview:HandleObPlayerOffline(id)
  if not id then
    return
  end
  local proxy = PvpObserveProxy.Instance
  local leftPlayerCells = self.leftHeadListCtrl:GetCells()
  for _, player in pairs(leftPlayerCells) do
    if player.playerid == id then
      local data = proxy:GetPlayerDataById(id)
      if data then
        player:UpdateOffline()
        return
      end
    end
  end
  local rightPlayerCells = self.rightHeadListCtrl:GetCells()
  for _, player in pairs(rightPlayerCells) do
    if player.playerid == id then
      local data = proxy:GetPlayerDataById(id)
      if data then
        player:UpdateOffline()
        return
      end
    end
  end
end

function PvpObNewSubview:UpdatePlayerCells()
  local obProxy = PvpObserveProxy.Instance
  self.leftHeadListCtrl:ResetDatas(obProxy:GetPlayerDataByCamp(1))
  self.rightHeadListCtrl:ResetDatas(obProxy:GetPlayerDataByCamp(2))
end

function PvpObNewSubview:OnSettingClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SetView
  })
end

function PvpObNewSubview:OnExpandClicked()
  self:SetExpand(not self.isExpanded)
end

function PvpObNewSubview:SetExpand(bExpand)
  if self.isExpanded == bExpand then
    return
  end
  self.isExpanded = bExpand
  if bExpand then
    self.expandIcon.CurrentState = 0
    self.playtween:Play(false)
    self.detailBtnGO:SetActive(true)
  else
    self.expandIcon.CurrentState = 1
    self.playtween:Play(true)
    self.detailBtnGO:SetActive(false)
  end
end

function PvpObNewSubview:StartTimeTick()
  if self.timeTick then
    return
  end
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateTimeLeft, self)
end

function PvpObNewSubview:StopTimeTick()
  if self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
  self.timeLab.text = "00:00"
end

function PvpObNewSubview:UpdateTimeLeft()
  local timeLeft = self.endTime and self.endTime - ServerTime.CurServerTime() / 1000 or 0
  if timeLeft <= 0 then
    self:StopTimeTick()
    return false
  end
  self.timeLab.text = string.format("%02d:%02d", math.floor(timeLeft / 60), math.floor(timeLeft % 60))
  return true
end
