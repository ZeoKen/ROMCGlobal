autoImport("PvpObHeadCell")
PvpObSubview = class("PvpObSubview", SubView)
local viewName = "PvpObSubview"
local viewPath = ResourcePathHelper.UIView(viewName)

function PvpObSubview:ctor(container, initParams, subViewData)
  PvpObSubview.super.ctor(self, container, initParams, subViewData)
  if initParams then
    self.proxy = initParams.proxy
    self.launchEvent = initParams.launchEvent
  end
end

function PvpObSubview:Init()
  self:ReLoadPerferb("view/PvpObSubview", true)
  self.obRootGO = self:FindGO("PvpObSubview")
  self.infoPanelContainerGO = self:FindGO("InfoContainer", self.obRootGO)
  self:InitHeadPanel()
  self:UpdateView()
end

function PvpObSubview:InitHeadPanel()
  self.leftHeadRootGO = self:FindGO("HeadRootLeft", self.obRootGO)
  self.leftHeadGrid = self:FindComponent("gridPlayers", UIGrid, self.leftHeadRootGO)
  self.leftHeadListCtrl = UIGridListCtrl.new(self.leftHeadGrid, PvpObHeadCell, "PvpObHeadCell")
  self.leftHeadListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHeadCellClicked, self)
  self.rightHeadRootGO = self:FindGO("HeadRootRight", self.obRootGO)
  self.rightHeadGrid = self:FindComponent("gridPlayers", UIGrid, self.rightHeadRootGO)
  self.rightHeadListCtrl = UIGridListCtrl.new(self.rightHeadGrid, PvpObHeadCell, "PvpObHeadCell")
  self.rightHeadListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHeadCellClicked, self)
  local settingBtnGO = self:FindGO("SettingBtn", self.obRootGO)
  self:AddClickEvent(settingBtnGO, function()
    self:OnSettingClicked()
  end)
end

function PvpObSubview:OnEnter()
  self:InitListenEvents()
  PvpObSubview.super.OnEnter(self)
end

function PvpObSubview:OnExit()
  PvpObSubview.super.OnExit(self)
  if self.leftHeadListCtrl then
    self.leftHeadListCtrl:RemoveAll()
  end
  if self.rightHeadListCtrl then
    self.rightHeadListCtrl:RemoveAll()
  end
end

function PvpObSubview:InitListenEvents()
  self:AddDispatcherEvt(ServiceEvent.MatchCCmdObInitInfoFubenCmd, self.UpdatePlayerCells)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdObserverAttachFubenCmd, self.HandleAttachPlayer)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerHpSpUpdate, self.HandlePlayerHpSpUpdate)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerOffline, self.HandleObPlayerOffline)
  self:AddDispatcherEvt(MyselfEvent.ObservationSelectPlayer, self.HandleSelectPlayer)
end

function PvpObSubview:Show()
  self.obRootGO:SetActive(true)
  self:UpdateView()
end

function PvpObSubview:Hide()
  self.obRootGO:SetActive(false)
end

function PvpObSubview:UpdateView()
  self:UpdatePlayerCells()
end

function PvpObSubview:OnHeadCellClicked(cell)
  local playerid = cell.data and cell.data.playerid
  if not playerid then
    return
  end
  if cell.data.offline then
    return
  end
  PvpObserveProxy.Instance:TryAttach(playerid)
end

function PvpObSubview:HandleAttachPlayer(data)
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

function PvpObSubview:HandleSelectPlayer(playerId)
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

function PvpObSubview:HandlePlayerHpSpUpdate(ids)
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

function PvpObSubview:HandleObPlayerOffline(id)
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

function PvpObSubview:UpdatePlayerCells()
  local obProxy = PvpObserveProxy.Instance
  self.leftHeadListCtrl:ResetDatas(obProxy:GetPlayerDataByCamp(1))
  self.rightHeadListCtrl:ResetDatas(obProxy:GetPlayerDataByCamp(2))
end

function PvpObSubview:OnSettingClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SetView
  })
end
