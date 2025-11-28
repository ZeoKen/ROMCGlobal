EvidenceShowPanel = class("EvidenceShowPanel", ContainerView)
EvidenceShowPanel.ViewType = UIViewType.DialogLayer
autoImport("DialogCell")
autoImport("EvidenceGridCell")

function EvidenceShowPanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function EvidenceShowPanel:FindObjs()
  self.listRoot = self:FindGO("ListRoot")
  self.evidenceScrollView = self:FindGO("EvidenceScrollView"):GetComponent(UIScrollView)
  self.evidenceGrid = self:FindGO("EvidenceGrid", self.listRoot):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceGrid, EvidenceGridCell, "ManorPartnerHeadCell")
  self.evidenceGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseEvidence, self)
  self.evidenceGridCtrl:AddEventListener(SevenRoyalFamilies.JointInferenceLongPressEvidence, self.HandleShowEvidenceDetail, self)
  local bottom = self:FindGO("Anchor_bottom")
  local activeH = Game.GameObjectUtil:GetUIActiveHeight(self.gameObject)
  bottom.transform.localPosition = LuaGeometry.GetTempVector3(0, -activeH / 2, 0)
  local obj = self:LoadPreferb("cell/DialogCell", self:FindGO("Anchor_bottom"))
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.dialogCtl = DialogCell.new(obj)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtn_BoxCollider = self.confirmBtn:GetComponent(BoxCollider)
  self.closeBtn = self:FindGO("CloseButton")
  self.stick = self:FindGO("Stick"):GetComponent(UIWidget)
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.subTitleLabel = self:FindGO("SubTitleLabel"):GetComponent(UILabel)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.descLabel.text = ""
  self.noneTip = self:FindGO("NoneTip"):GetComponent(UILabel)
  self.noneTip.text = ZhString.EvidenceShowPanel_ChooseEmpty
end

function EvidenceShowPanel:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    if self.questData then
      if not self.curChooseEvidence then
        return
      end
      self.confirmCommit = true
      if self.curChooseEvidence.id == self.targetEvidence then
        QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
      else
        QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
      end
    end
    self:CloseSelf()
  end)
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function EvidenceShowPanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  EventManager.Me():AddEventListener(MyselfEvent.PlaceTo, self.CloseSelf, self)
end

function EvidenceShowPanel:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.questData = viewdata and viewdata.questData
  if self.questData then
    self.evidenceList = self.questData.params.evidenceList
    self.targetEvidence = self.questData.params.Answer
    self.dialogList = self.questData.params.dialog or {451134}
    self.npcid = self.questData.params.npc
    self.zoomIn = self.questData.params.zoomIn
    self.zoomOut = self.questData.params.zoomOut
    self.scope = self.questData.scope
  else
    self.evidenceList = {
      53959,
      53960,
      53963,
      53979
    }
    self.targetEvidence = 53960
  end
end

function EvidenceShowPanel:InitShow()
  local showList = {}
  for i = 1, #self.evidenceList do
    local id = self.evidenceList[i]
    local staticData = Table_Evidence[id]
    if staticData then
      local data = {staticData = staticData}
      table.insert(showList, data)
    end
  end
  self.evidenceGridCtrl:ResetDatas(showList)
  if self.dialogList then
    local dialogData = self.dialogList[1] and DialogUtil.GetDialogData(self.dialogList[1])
    self.dialogCtl:SetData(dialogData)
  end
  if not FunctionMindLocker.Me().isEntered and self.npcid then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(self.npcid)
    local npc = npcs and npcs[1]
    if not npc then
      return
    end
    if self.zoomIn then
      self:CameraFaceTo(npc.assetRole.completeTransform, CameraConfig.ShowEvidence_ViewPort, CameraConfig.ShowEvidence_Rotation, 1)
    end
  end
  if self.questData.params.title_msg then
    local data = DialogUtil.GetDialogData(self.questData.params.title_msg)
    if data then
      self.titleLabel.text = MsgParserProxy.Instance:TryParse(data.Text)
    end
  end
  if self.questData.params.subtitle_msg then
    local data = DialogUtil.GetDialogData(self.questData.params.subtitle_msg)
    if data then
      self.subTitleLabel.text = MsgParserProxy.Instance:TryParse(data.Text)
    end
  end
  self:SetTextureGrey(self.confirmBtn)
  self.confirmBtn_BoxCollider.enabled = false
end

function EvidenceShowPanel:HandleChooseEvidence(cellCtrl)
  if self.curChooseEvidence then
    self.curChooseEvidence:SetChoose(false)
  end
  self.curChooseEvidence = cellCtrl
  self.curChooseEvidence:SetChoose(true)
  self:SetTextureWhite(self.confirmBtn, LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1))
  self.confirmBtn_BoxCollider.enabled = true
  self.noneTip.gameObject:SetActive(false)
  self:PlayNpcReflect()
  self:SwitchEvidenceDesc()
end

function EvidenceShowPanel:PlayNpcReflect()
  if not self.npcid then
    return
  end
  local actionConfig = GameConfig.SevenRoyalFamilies.ShowEvidenceNpcAction
  if not actionConfig then
    return
  end
  if actionConfig[self.npcid] then
    local actionID, expressionID, loop
    if self.curChooseEvidence.id == self.targetEvidence then
      actionID = actionConfig[self.npcid].correct
      expressionID = actionConfig[self.npcid].correctexpression
      loop = actionConfig[self.npcid].correctloop
    else
      actionID = actionConfig[self.npcid].wrong
      expressionID = actionConfig[self.npcid].wrongexpression
      loop = actionConfig[self.npcid].wrongloop
    end
    loop = loop and true or false
    if FunctionMindLocker.Me().isEntered then
      FunctionMindLocker.Me():PlayRoleAction(actionID, expressionID, 1, loop)
    else
      local npcs = NSceneNpcProxy.Instance:FindNpcs(self.npcid)
      local npc = npcs and npcs[1]
      if not npc then
        return
      end
      local actionData = Table_ActionAnime[actionID]
      if actionData then
        npc:Server_PlayActionCmd(actionData.Name, nil, loop)
      else
        npc.assetRole:PlayAction_Idle()
      end
      if expressionID ~= nil then
        npc.assetRole:SetExpression(expressionID, true)
      end
    end
  end
end

function EvidenceShowPanel:SwitchEvidenceDesc()
  local id = self.curChooseEvidence and self.curChooseEvidence.id
  xdlog("id", id)
  if not id then
    redlog("未选择证物")
    self.noneTip.gameObject:SetActive(true)
    return
  end
  local config = Table_Evidence[id]
  if not config then
    redlog("无证物配置  请检查", id)
    return
  end
  local itemData = Table_Item[id]
  if not itemData then
    redlog("未配置证物对应道具", id)
    return
  end
  self.descLabel.text = itemData.Desc or "..."
end

function EvidenceShowPanel:HandleShowEvidenceDetail(cellCtrl)
  TipManager.Instance:ShowEvidenceDetailTip(cellCtrl.id, self.stick, nil, {80, 70})
end

function EvidenceShowPanel:HandleForceMove()
  if self.questData then
    redlog("强制退出心锁界面  并执行掉线跳转")
    if self.scope == QuestDataScopeType.QuestDataScopeType_CITY then
      ServiceQuestProxy.Instance:CallCloseUICmd(self.questData.id)
    else
      ServiceQuestProxy.Instance:CallCloseUICmd(nil, self.questData.id)
    end
    FunctionMindLocker.Me():ExitAll()
  end
  self:CloseSelf()
end

function EvidenceShowPanel:CloseSelf()
  EvidenceShowPanel.super.CloseSelf(self)
end

function EvidenceShowPanel:OnEnter()
  EvidenceShowPanel.super.OnEnter(self)
  ServiceQuestProxy.Instance:CallEvidenceQueryCmd()
end

function EvidenceShowPanel:OnExit()
  if self.questData and not self.confirmCommit then
    redlog("强制退出心锁界面  并执行掉线跳转")
    if self.scope == QuestDataScopeType.QuestDataScopeType_CITY then
      ServiceQuestProxy.Instance:CallCloseUICmd(self.questData.id)
    else
      ServiceQuestProxy.Instance:CallCloseUICmd(nil, self.questData.id)
    end
    FunctionMindLocker.Me():ExitAll()
  end
  if self.zoomOut then
    self:CameraReset(0.5)
  end
  EventManager.Me():RemoveEventListener(MyselfEvent.PlaceTo, self.CloseSelf)
  self.dialogCtl:OnExit()
  self.dialogCtl = nil
  EvidenceShowPanel.super.OnExit(self)
end
