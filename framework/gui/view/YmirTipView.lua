autoImport("YmirTipCell")
YmirTipView = class("YmirTipView", BaseView)
YmirTipView.ViewType = UIViewType.PopUpLayer
local bookIconName = "tab_icon_yimier"
local offset

function YmirTipView:Init()
  self.mainPanel = self:FindGO("MainPanel")
  self.closecomp = self.mainPanel:GetComponent(CloseWhenClickOtherPlace)
  if self.closecomp then
    function self.closecomp.callBack(go)
      self:CloseSelf()
    end
  end
  self.bookGO = self:FindGO("BookBg")
  self:AddClickEvent(self.bookGO, function()
    self:OnBookClicked()
  end)
  local bookIcon = self:FindComponent("BookIcon", UISprite, self.bookGO)
  IconManager:SetUIIcon(bookIconName, bookIcon)
  local itemPanel = self:FindGO("ItemPanel")
  self.itemCtrl = ListCtrl.new(self:FindComponent("Grid", UIGrid, itemPanel), YmirTipCell, "YmirTipCell")
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.emptyGO = self:FindGO("Empty")
  self.quickSaveBtn = self:FindGO("QuickSaveBtn")
  self.quickSaveBtn_st1 = self:FindGO("bg001")
  self.quickSaveBtn_st2 = self:FindGO("bg002")
  self.quickSaveStatus = false
  self:AddClickEvent(self.quickSaveBtn, function()
    self:SetQuickSaveMode(not self.quickSaveStatus)
  end)
  MultiProfessionSaveProxy.Instance:ClearProfessionRecordSimpleData()
  self:UpdateTip()
end

function YmirTipView:OnCellClicked(cell)
  if self.quickSaveStatus then
    self:OnCellQuickSave(cell)
    return
  end
  local myselfData = Game.Myself.data
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    return
  end
  if not cell.data then
    return
  end
  if Game.MapManager:IsRaidMode() and cell.data.charid ~= Game.Myself.data.id then
    MsgManager.ShowMsgByID(26300)
    return
  end
  local recordId = cell.data.id
  local unloadCardMoney = MultiProfessionSaveProxy.Instance:GetRecordEquipCardsUnloadMoney(recordId)
  MultiProfessionSaveProxy.Instance:LoadRecordByMapRule(recordId, true, unloadCardMoney)
end

function YmirTipView:UpdateTip()
  local datas = table.deepcopy(MultiProfessionSaveProxy.Instance:GetProfessionRecordSimpleData())
  local _slotIndexDatas = MultiProfessionSaveProxy.Instance.saveLocalIndexes
  local nowCanChangeProfession4NewPVPRule, nowCanChangeEquip4NewPVPRule = ProfessionProxy.CanChangeProfession4NewPVPRule()
  local myProf = MyselfProxy.Instance:GetMyProfession()
  for i = 1, #datas do
    local charid_forbidden = Game.MapManager:IsRaidMode() and datas[i].charid ~= Game.Myself.data.id
    datas[i].can_load = not charid_forbidden and (nowCanChangeProfession4NewPVPRule or datas[i].profession == myProf and nowCanChangeEquip4NewPVPRule ~= false)
  end
  table.sort(datas, function(l, r)
    if l.can_load ~= r.can_load then
      return l.can_load
    end
    return (_slotIndexDatas[l.id] or 99999) < (_slotIndexDatas[r.id] or 99999)
  end)
  local emptySlotId = MultiProfessionSaveProxy.Instance:GetFirstEmptySlotByIndexOrder()
  if self.quickSaveStatus and emptySlotId then
    table.insert(datas, {
      id = emptySlotId,
      recordname = string.format(ZhString.MultiProfession_SaveName, emptySlotId),
      can_load = nowCanChangeProfession4NewPVPRule and nowCanChangeEquip4NewPVPRule
    })
  end
  if datas then
    self.itemCtrl:ResetDatas(datas)
    local cells = self.itemCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:SetInQuickSaveMode(self.quickSaveStatus)
    end
  end
  if datas and 0 < #datas then
    self.emptyGO:SetActive(false)
  else
    self.emptyGO:SetActive(true)
  end
end

function YmirTipView:OnEnter()
  YmirTipView.super.OnEnter(self)
  self:UpdateTipPosition()
  ServiceSceneUser3Proxy.Instance:CallQueryProfessionRecordSimpleData()
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  EventManager.Me():AddEventListener(YmirEvent.OnSimpleRecordDataUpdated, self.UpdateTip, self)
  local checkName = self.viewdata.viewdata and self.viewdata.viewdata.cellCtl and self.viewdata.viewdata.cellCtl.trans and self.viewdata.viewdata.cellCtl.trans.name
  if checkName and type(checkName) == "string" and string.sub(checkName, 1, 1) == "Q" then
    self.quickSaveBtn:SetActive(false)
  end
end

function YmirTipView:OnExit()
  self.itemCtrl:RemoveAll()
  EventManager.Me():RemoveEventListener(YmirEvent.OnSimpleRecordDataUpdated, self.UpdateTip, self)
  YmirTipView.super.OnExit(self)
end

function YmirTipView:OnBookClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MultiProfessionNewView,
    viewdata = {tab = 2}
  })
  self:CloseSelf()
end

function YmirTipView:UpdateTipPosition()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if viewdata then
    local cellCtl = viewdata.cellCtl
    local stick = cellCtl and cellCtl.gameObject:GetComponentInChildren(UIWidget)
    if stick then
      local side = viewdata.side or NGUIUtil.AnchorSide.TopLeft
      offset = offset or LuaVector3.Zero()
      if viewdata.offset then
        LuaVector3.Better_SetPos(offset, viewdata.offset)
      else
        LuaVector3.Better_Set(offset, 0, 0, 0)
      end
      local newPos = NGUIUtil.GetAnchorPoint(self.mainPanel, stick, side, offset)
      self.mainPanel.transform.position = newPos
      local panel = self.gameObject:GetComponent(UIPanel)
      if panel then
        panel.gameObject:SetActive(false)
        panel.gameObject:SetActive(true)
        panel:ConstrainTargetToBounds(self.mainPanel.transform, true)
      end
    end
  end
end

local IsNull = Slua.IsNull

function YmirTipView:SetQuickSaveMode(status)
  self.quickSaveStatus = status
  if status then
    if not IsNull(self.quickSaveBtn_st1) then
      self.quickSaveBtn_st1:SetActive(false)
    end
    if not IsNull(self.quickSaveBtn_st2) then
      self.quickSaveBtn_st2:SetActive(true)
    end
  else
    if not IsNull(self.quickSaveBtn_st1) then
      self.quickSaveBtn_st1:SetActive(true)
    end
    if not IsNull(self.quickSaveBtn_st2) then
      self.quickSaveBtn_st2:SetActive(false)
    end
  end
  self:UpdateTip()
end

function YmirTipView:OnCellQuickSave(cell)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    self:SetQuickSaveMode(false)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    self:SetQuickSaveMode(false)
    return
  end
  if not ProfessionProxy.CanChangeProfession4NewPVPRule(25389) then
    return
  end
  local f = function()
    ServiceNUserProxy:CallSaveRecordUserCmd(cell.data.id, cell.data.recordname)
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:SetQuickSaveMode(false)
      MultiProfessionSaveProxy.Instance:ClearProfessionRecordSimpleData()
      ServiceSceneUser3Proxy.Instance:CallQueryProfessionRecordSimpleData()
    end, self)
  end
  if cell.data.profession then
    MsgManager.ConfirmMsgByID(25390, function()
      f()
    end, nil, nil, cell.data.recordname)
  else
    f()
  end
end
