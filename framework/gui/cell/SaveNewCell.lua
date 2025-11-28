autoImport("BaseCell")
autoImport("UILabelScrollCtrl")
autoImport("DragDropCell")
SaveNewCell = class("SaveNewCell", BaseCell)
SaveNewCell.StatusChange = "SaveNewCell_StatusChange"
SaveNewCell.UpdateSlotIndex = "SaveNewCell_UpdateSlotIndex"

function SaveNewCell:Init()
  self:FindObjs()
  self:AddClickEvent(self.gameObject, function()
    if self.data == nil then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end, {hideClickSound = true})
  self:AddCellDoubleClickEvt()
  self:InitDragDrop()
end

function SaveNewCell:FindObjs()
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.name = self:FindComponent("name", UILabel)
  self.namePanel = self:FindComponent("namePanel", UIPanel)
  self.nameScroll = self.namePanel.gameObject:GetComponent(UIScrollView)
  local parentPanel = UIUtil.GetComponentInParents(self.namePanel.gameObject, UIPanel)
  if parentPanel then
    self.namePanel.depth = parentPanel.depth + 1
  end
  self.recordNameLabel = self:FindComponent("recordName", UILabel)
  self.nameScrollCtrl = UIAutoScrollCtrl.new(self.nameScroll, self.recordNameLabel)
  self.icon = self:FindComponent("icon", UIMultiSprite)
  self.editBtn = self:FindGO("editBtn")
  self:AddClickEvent(self.editBtn, function()
    self:OnEditBtnClick()
  end)
  self.deleteBtn = self:FindGO("deleteBtn")
  self:AddClickEvent(self.deleteBtn, function()
    self:OnDeleteBtnClick()
  end)
  self.replaceBtn = self:FindGO("replaceBtn")
  self:AddClickEvent(self.replaceBtn, function()
    self:OnReplaceBtnClick()
  end)
  self.btnGrid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.line = self:FindGO("line")
  self.selectCover = self:FindComponent("selectCover", UIPanel)
  if parentPanel then
    self.selectCover.depth = parentPanel.depth + 2
  end
end

function SaveNewCell:InitDragDrop()
  self.ddGo = self:FindGO("bg")
  if self.ddGo:GetComponent(UIDragItem) == nil then
    self.ddGo:AddComponent(UIDragItem)
  end
  self.dragDrop = DragDropCell.new(self.ddGo:GetComponent(UIDragItem), 0.3)
  self.dragDrop.dragDropComponent.type = 3
  
  function self.dragDrop.dragDropComponent.OnCursor(dragItem)
    if dragItem.data and dragItem.data.status == 1 and dragItem.data.recordTime ~= 0 then
      DragCursorPanel.Instance.ShowSaveNewCell(dragItem)
    end
  end
  
  function self.dragDrop.dragDropComponent.OnReplace(data)
    if data then
      redlog("OnReplace", data.id, self.id)
      if data.id and data.status == 1 and data.recordTime ~= 0 and data.id ~= self.id then
        MultiProfessionSaveProxy.Instance:DoSwapSlotIndex(data.id, self.id)
      end
    end
  end
  
  self:SetDragEnable(true)
end

function SaveNewCell:SetDragEnable(value)
  self.dragDrop:SetDragEnable(value)
end

function SaveNewCell:SetData(data)
  self.data = data
  self.id = data.id
  if data.status == 1 then
    if data.recordTime == 0 then
      self:SetSave()
    else
      self:SetInfo()
    end
    self.icon.alpha = 1
    self.name.alpha = 1
  else
    if data.type == SceneUser2_pb.ESLOT_MONTH_CARD then
      self:SetTip()
    elseif data.type == SceneUser2_pb.ESLOT_BUY then
      self:SetAdd()
    end
    self.icon.alpha = 0.5
    self.name.alpha = 0.5
  end
  if data.type == SceneUser2_pb.ESLOT_MONTH_CARD and data.status == 1 then
    self:CreateTick()
  else
    self:ClearTick()
  end
  if data.status == 1 and data.recordTime ~= 0 then
    self.dragDrop.dragDropComponent.data = self.data
  else
    self.dragDrop.dragDropComponent.data = nil
  end
end

function SaveNewCell:SetSave()
  self.icon.CurrentState = 0
  self.icon:MakePixelPerfect()
  LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.57, 0.57, 1)
  self.name.text = ZhString.MultiProfession_NoRecord
  self:SetClickState(true)
end

function SaveNewCell:SetInfo()
  local classId = MultiProfessionSaveProxy.Instance:GetProfession(self.id)
  local config = Table_Class[classId]
  if config then
    IconManager:SetProfessionIcon(config.icon, self.icon)
    self.icon:MakePixelPerfect()
  end
  LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.45, 0.45, 1)
  self.name.text = AppendSpace2Str(self.data.recordName)
  self:SetClickState(true)
end

function SaveNewCell:SetTip()
  self.icon.CurrentState = 1
  self.icon:MakePixelPerfect()
  LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.85, 0.85, 1)
  self.name.text = ZhString.MultiProfession_MonthCardNewTip
  self:SetClickState(false)
end

function SaveNewCell:SetAdd()
  self.icon.CurrentState = 2
  self.icon:MakePixelPerfect()
  LuaGameObject.SetLocalScaleGO(self.icon.gameObject, 0.7, 0.7, 1)
  self.name.text = ZhString.MultiProfession_BuySlot
  self:SetClickState(true)
end

function SaveNewCell:SetClickState(state)
  self.collider.enabled = state
end

function SaveNewCell:CreateTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._refreshTime, self)
end

function SaveNewCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function SaveNewCell:_refreshTime()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local leftTime = MultiProfessionSaveProxy.Instance:GetCardExpiration() - ServerTime.CurServerTime() / 1000
  leftTime = math.max(0, leftTime)
  if leftTime == 0 then
    self:ClearTick()
    MultiProfessionSaveProxy.Instance:UpdateStatus(self.id, 0)
    MultiProfessionSaveProxy.Instance:SortUserSave()
    self:PassEvent(SaveNewCell.StatusChange)
  end
end

function SaveNewCell:ShowChoose(selectId)
  if selectId == self.id then
    self:SetSelectState(true)
  else
    self:SetSelectState(false)
  end
end

function SaveNewCell:SetSelectState(state)
  if state then
    if self.data.status == 1 and self.data.recordTime > 0 then
      self.selectCover.gameObject:SetActive(true)
      self.editBtn:SetActive(true)
      self.replaceBtn:SetActive(true)
      self.deleteBtn:SetActive(true)
      self:SetChooseRecordName(true)
      self.name.text = ""
    else
      self.selectCover.gameObject:SetActive(true)
      self.editBtn:SetActive(false)
      self.replaceBtn:SetActive(true)
      self.deleteBtn:SetActive(false)
      self:SetChooseRecordName(false)
    end
    self.btnGrid:Reposition()
  else
    self.selectCover.gameObject:SetActive(false)
    self:SetChooseRecordName(false)
    if self.data.status == 1 and self.data.recordTime > 0 then
      self.name.text = AppendSpace2Str(self.data.recordName)
    end
  end
end

function SaveNewCell:SetChooseRecordName(choose)
  if choose then
    self.recordNameLabel.text = AppendSpace2Str(self.data.recordName)
    self.nameScrollCtrl:Start(true, true)
  else
    self.recordNameLabel.text = ""
    self.nameScrollCtrl:Stop()
  end
end

function SaveNewCell:OnEditBtnClick()
  if self.data.status == 1 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeSaveNamePopUp,
      viewdata = self
    })
  end
end

function SaveNewCell:OnDeleteBtnClick()
  if self.deleteCd then
    return
  end
  self.deleteCd = 500
  TimeTickManager.Me():CreateOnceDelayTick(self.deleteCd, function(owner, deltaTime)
    self.deleteCd = nil
  end, self)
  MsgManager.ConfirmMsgByID(25430, function()
    ServiceNUserProxy.Instance:CallDeleteRecordUserCmd(self.id)
  end)
end

function SaveNewCell:OnReplaceBtnClick()
  if self.call_lock then
    return
  end
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if not ProfessionProxy.CanChangeProfession4NewPVPRule(25389) then
    return
  end
  if self.data.status == 1 and self.data.recordTime > 0 then
    MsgManager.ConfirmMsgByID(25390, function()
      self:LockCall()
      ServiceNUserProxy:CallSaveRecordUserCmd(self.id, self.data.recordName)
    end, nil, nil, self.data.recordName)
  else
    local str = string.format(ZhString.MultiProfession_SaveName, self.id)
    ServiceNUserProxy:CallSaveRecordUserCmd(self.id, str)
  end
end

function SaveNewCell:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if not self.lock_lt then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function SaveNewCell:OnDestroy()
  self:ClearTick()
end
