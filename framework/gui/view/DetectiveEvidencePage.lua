DetectiveEvidencePage = class("DetectiveEvidencePage", SubView)
DetectiveEvidencePage.ViewType = UIViewType.NormalLayer
autoImport("EvidenceGridCell")
autoImport("EvidenceTipCell")
autoImport("EvidenceToolCell")
local decorateTextureNameMap = {
  PicBg = "Sevenroyalfamilies_bg_bottom3",
  Decorate10 = "Sevenroyalfamilies_bg_decoration10",
  Decorate11 = "Sevenroyalfamilies_bg_decoration11"
}
local decorateCommonMap = {
  DecorateBG = "calendar_bg1_picture2",
  DecorateBG2 = "calendar_bg1_picture2"
}
local tipsSkillID = 4603
local tipsHighLightSkillID = 4605
local viewPath = ResourcePathHelper.UIView("DetectiveEvidencePage")
local picIns = PictureManager.Instance
local posVec = LuaVector3.Zero()
local rotVec = LuaVector3.Zero()
local scaleVec = LuaVector3.Zero()
local rotationQuatY = LuaQuaternion.Identity()
local rotationQuatZ = LuaQuaternion.Identity()
local vec_right = LuaVector3.New(1, 0, 0)
local vec_up = LuaVector3.Up()
local enableCorrectTip = false

function DetectiveEvidencePage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function DetectiveEvidencePage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.evidencePageObj, true)
  obj.name = "DetectiveEvidencePage"
end

function DetectiveEvidencePage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("DetectiveEvidencePage")
  self.cameraUI = NGUIUtil:GetCameraByLayername("UI")
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  for objName, _ in pairs(decorateCommonMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.evidenceListPart = self:FindGO("EvidenceListPart")
  self.evidenceListPartContainer = self:FindGO("Container", self.evidenceListPart)
  self.evidenceListNone = self:FindGO("None", self.evidenceListPart)
  self.evidenceScrollView = self:FindGO("EvidenceScrollView"):GetComponent(UIScrollView)
  self.evidenceGrid = self:FindGO("EvidenceGrid"):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceGrid, EvidenceGridCell, "ManorPartnerHeadCell")
  self.evidenceGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseEvidence, self)
  self.previewPart = self:FindGO("PreviewPart")
  self.previewPartContainer = self:FindGO("Container", self.previewPart)
  self.previewPartContainer_TweenAlpha = self.previewPartContainer:GetComponent(TweenAlpha)
  self.previewPartNone = self:FindGO("None", self.previewPart)
  self.evidenceTexture = self:FindGO("EvidenceTexture", self.previewPart):GetComponent(UITexture)
  self.previewName = self:FindGO("Name", self.previewPart):GetComponent(UILabel)
  self.previewNameGO = self.previewName.gameObject
  self.descScrollView = self:FindGO("DescScrollView", self.previewPart):GetComponent(UIScrollView)
  self.descTable = self:FindGO("DescTable", self.previewPart):GetComponent(UITable)
  self.evidenceDesc = self:FindGO("Desc", self.previewPart):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol", self.previewPart)
  self.tipsGrid = self:FindGO("TipsGrid", self.previewPart):GetComponent(UITable)
  self.tipsGridCtrl = UIGridListCtrl.new(self.tipsGrid, EvidenceTipCell, "EvidenceTipCell")
  self.startCheckBtn = self:FindGO("StartCheckBtn", self.previewPart)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.detailPart = self:FindGO("DetailPart")
  self.closeDetailBtn = self:FindGO("CloseDetailBtn")
  self.infoScrollView = self:FindGO("InfoScrollView", self.detailPart):GetComponent(UIScrollView)
  self.infoGrid = self:FindGO("InfoGrid", self.detailPart):GetComponent(UITable)
  self.infoGridCtrl = UIGridListCtrl.new(self.infoGrid, EvidenceTipCell, "EvidenceTipCell")
  self.itemPart = self:FindGO("ItemPart", self.detailPart)
  self.itemGrid = self:FindGO("ItemGrid", self.itemPart):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(self.itemGrid, EvidenceToolCell, "ManorPartnerHeadCell")
  self.itemGridCtrl:AddEventListener(MouseEvent.MousePress, self.HandlePressItem, self)
  self.itemGridCtrl:AddEventListener(DragDropEvent.OnDrag, self.HandleDragItem, self)
  self.evidenceName = self:FindGO("EvidenceName", self.detailPart):GetComponent(UILabel)
  self.modelContainer = self:FindGO("ModelContainer")
  self.modelTexture = self:FindGO("ModelTexture"):GetComponent(UITexture)
  self.upBtn = self:FindGO("Up")
  self.downBtn = self:FindGO("Down")
  self.rightBtn = self:FindGO("Right")
  self.leftBtn = self:FindGO("Left")
  self.tipsBtn = self:FindGO("TipsBtn", self.detailPart)
  self.tipLabel = self:FindGO("TipLabel", self.detailPart):GetComponent(UILabel)
  self.cdMask = self:FindGO("CDMask", self.tipsBtn):GetComponent(UISprite)
  self.tipLabelGO = self.tipLabel.gameObject
  self.tipLabel_TweenAlpha = self.tipLabelGO:GetComponent(TweenAlpha)
  self.tipLabelGO:SetActive(false)
  self.correctTip = self:FindGO("CorrectTip")
  self.correctTip:SetActive(false)
  self.guideRoot = self:FindGO("GuideRoot", self.detailPart)
  self.cancelBtn = self:FindGO("CancelBtn")
  local luaMono = self.gameObject:GetComponent(GameObjectForLua)
  if luaMono == nil then
    luaMono = self.gameObject:AddComponent(GameObjectForLua)
  end
  
  function luaMono.onDisable()
    self:OnDisable()
  end
end

function DetectiveEvidencePage:AddEvts()
  self:AddClickEvent(self.startCheckBtn, function()
    self.evidenceListPart:SetActive(false)
    self.previewPart:SetActive(false)
    self.detailPart:SetActive(true)
    self:RefreshDetailPart(self.curEvidenceID)
    self:RefreshTipsBtn()
  end)
  self:AddClickEvent(self.closeDetailBtn, function()
    self.evidenceListPart:SetActive(true)
    self.previewPart:SetActive(true)
    self.detailPart:SetActive(false)
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    LeanTween.cancel(self.modelTexture.gameObject)
    self.UIModel = nil
    self:RefreshPreviewPart(self.curEvidenceID)
    if self.readyRefresh then
      self.readyRefresh = false
      self:RefreshExistEvidence()
    end
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self.guideRoot:SetActive(false)
  end)
  self:AddClickEvent(self.tipsBtn, function()
    local checkColdDown = true
    if self.nextHint and self.nextHint ~= 0 and self.nextHint > ServerTime.CurServerTime() / 1000 then
      checkColdDown = false
    end
    if not checkColdDown then
      MsgManager.ShowMsgByID(42117)
      return
    end
    if not self.messageTipsList or #self.messageTipsList == 0 then
      MsgManager.ShowMsgByID(42118)
      return
    end
    xdlog("申请进入CD")
    ServiceQuestProxy.Instance:CallEvidenceHintCmd()
  end)
  self.lastDeltaX = 0
  self.lastDeltaY = 0
  self.lastRotateTime = Time.time
  self:AddDragEvent(self.modelTexture.gameObject, function(obj, delta)
    self:TryRotate(delta.x, delta.y)
  end)
  self:AddPressEvent(self.modelTexture.gameObject, function(g, b)
    if b == false and Time.time - self.lastRotateTime < 0.15 and (math.abs(self.lastDeltaX) > 10 or 10 < math.abs(self.lastDeltaY)) then
      LeanTween.value(self.modelTexture.gameObject, function(v)
        local rsx = 0.5
        local rsy = 0.5
        local smoothX = self.lastDeltaX * 0.5 * v
        local smoothY = self.lastDeltaY * 0.5 * v
        rotationQuatY = Quaternion.AngleAxis(-smoothX * self.rotateSpeed * rsx, vec_up)
        rotationQuatZ = Quaternion.AngleAxis(-smoothY * self.rotateSpeed * rsy, vec_right)
        self.UIModel.completeTransform.localRotation = rotationQuatZ * self.UIModel.completeTransform.localRotation
        self.UIModel.completeTransform.localRotation = rotationQuatY * self.UIModel.completeTransform.localRotation
      end, 1, 0, 0.5)
    end
  end)
  self:AddPressEvent(self.upBtn, function(g, b)
    self:TryArrowRotateUP(b)
  end)
  self:AddPressEvent(self.downBtn, function(g, b)
    self:TryArrowRotateDown(b)
  end)
  self:AddClickEvent(self.modelTexture.gameObject, function()
    xdlog("clickModeltexture")
    if not self.targetMessageID then
      redlog("不满足旋转角度")
      return
    end
    if self.operateNeed ~= 0 then
      redlog("需要使用工具", self.operateNeed)
      return
    end
    ServiceQuestProxy.Instance:CallUnlockEvidenceMessageCmd(self.curChooseEvidence.id, self.targetMessageID)
    self.targetMessageID = nil
    self.operateNeed = 0
  end)
  local helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:RegistShowGeneralHelpByHelpID(35091, helpBtn)
end

function DetectiveEvidencePage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.QuestEvidenceQueryCmd, self.InitShow)
  self:AddListenEvt(ServiceEvent.QuestUnlockEvidenceMessageCmd, self.RefreshEvidenceMessage)
  self:AddListenEvt(ServiceEvent.QuestNewEvidenceUpdateCmd, self.RefreshExistEvidence)
  self:AddListenEvt(ServiceEvent.QuestEvidenceHintCmd, self.RefreshCDHint)
end

function DetectiveEvidencePage:InitDatas()
  self.isDragCell = false
  self.isDragged = false
  self.operateNeed = 0
  self.evidenceUnlockCondition = {}
  self.messageTipsList = {}
  self.effectKeepList = {}
  self.effects = {}
  self.curTipIndex = 1
  self.rotateSpeed = GameConfig.SevenRoyalFamilies and GameConfig.SevenRoyalFamilies.RotateSpeed or 0.5
end

function DetectiveEvidencePage:InitShow()
  if not Table_Evidence then
    redlog("无table_evidence")
    return
  end
  if not SevenRoyalFamiliesProxy.Instance:IsDataInited() then
    return
  end
  self:RefreshExistEvidence()
  self:RefreshTools()
  self:RefreshCDHint()
  self:RefreshTipsBtn()
end

function DetectiveEvidencePage:RefreshCDHint()
  self.nextHint = SevenRoyalFamiliesProxy.Instance.nextHint
  self.lastHintCD = SevenRoyalFamiliesProxy.Instance.lastHintCD
  xdlog("重置转CD", self.nextHint, self.lastHintCD)
  if self.nextHint ~= 0 and self.nextHint > ServerTime.CurServerTime() / 1000 then
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTipCD, self, 1)
  else
    self.cdMask.fillAmount = 0
  end
  local tipData = self.messageTipsList[self.curTipIndex]
  local targetMessageID = tipData and tipData.messageID
  local tipID = tipData and tipData.tipID
  xdlog(self.curTipIndex, targetMessageID, tipID)
  if tipID then
    local config = Table_EvidenceMessage[tipID]
    self.tipLabel.gameObject:SetActive(true)
    self.tipLabel.text = config and config.Description
    self.tipLabel_TweenAlpha:ResetToBeginning()
    self.tipLabel_TweenAlpha:PlayForward()
    local skillInfo = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(tipsHighLightSkillID)
    if skillInfo and 0 < skillInfo.lv and tipData.effectID and self.effects[tipData.effectID] then
      table.insert(self.effectKeepList, tipData.effectID)
      for j = 1, #self.effects[tipData.effectID] do
        self:Show(self.effects[tipData.effectID][j])
      end
    end
    self.curTipIndex = self.curTipIndex + 1
    if self.curTipIndex > #self.messageTipsList then
      self.curTipIndex = 1
    end
  end
end

function DetectiveEvidencePage:RefreshTipCD()
  local leftTime = self.nextHint - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    self.cdMask.fillAmount = 0
    TimeTickManager.Me():ClearTick(self, 1)
  end
  local fillAmount = leftTime / self.lastHintCD
  self.cdMask.fillAmount = fillAmount
end

function DetectiveEvidencePage:RefreshTipsBtn()
  local skillInfo = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(tipsSkillID)
  if not skillInfo then
    xdlog("没技能")
    self.tipsBtn:SetActive(false)
    return
  end
  xdlog(skillInfo.lv)
  self.tipsBtn:SetActive(skillInfo.lv > 0)
end

function DetectiveEvidencePage:RefreshExistEvidence()
  local result = {}
  local totalCount = 0
  self.existEvidenceData = SevenRoyalFamiliesProxy.Instance.evidenceData
  for k, v in pairs(Table_Evidence) do
    if self.existEvidenceData and self.existEvidenceData[k] and not v.ToolItem then
      local data = {staticData = v}
      local maxMessageNum = v.Messages and #v.Messages or 0
      local curUnlockMessageNum = self.existEvidenceData[k].unlockMessage and #self.existEvidenceData[k].unlockMessage or 0
      data.finish = maxMessageNum <= curUnlockMessageNum
      data.isnew = self.existEvidenceData[k].isNew
      totalCount = totalCount + 1
      table.insert(result, data)
    end
  end
  table.sort(result, function(l, r)
    if l.finish == r.finish then
      return l.staticData.id < r.staticData.id
    else
      return l.finish == false
    end
  end)
  self.totalCount = totalCount
  self.evidenceGridCtrl:ResetDatas(result)
  self.evidenceListPartContainer:SetActive(totalCount ~= 0)
  self.evidenceListNone:SetActive(totalCount == 0)
  self.previewPartContainer:SetActive(totalCount ~= 0)
  self.previewPartNone:SetActive(totalCount == 0)
  if not self.curEvidenceID or not self.existEvidenceData[self.curEvidenceID] then
    self.curEvidenceID = result and result[1] and result[1].staticData.id
  end
  if self.curEvidenceID then
    if self.detailPart.activeSelf then
      self:RefreshDetailPart(self.curEvidenceID)
    end
    self:RefreshPreviewPart(self.curEvidenceID)
  end
  if not self.curChooseEvidence then
    local cells = self.evidenceGridCtrl:GetCells()
    if cells and cells[1] then
      self.curChooseEvidence = cells[1]
      cells[1]:SetChoose(true)
    end
  else
    local cells = self.evidenceGridCtrl:GetCells()
    local curChooseID = self.curChooseEvidence.id or 0
    for i = 1, #cells do
      if cells[i].id == curChooseID then
        cells[i]:SetChoose(false)
      end
      if cells[i].id == self.curEvidenceID then
        cells[i]:SetChoose(true)
        self.curChooseEvidence = cells[i]
      end
    end
  end
  self.evidenceScrollView:ResetPosition()
end

function DetectiveEvidencePage:RefreshEvidenceMessage(note)
  if self.detailPart.activeSelf then
    self.existEvidenceData = SevenRoyalFamiliesProxy.Instance.evidenceData
    self:RefreshDetailPart(self.curEvidenceID)
    local data = note.body
    self:EnlightNewMessage(data)
    self.readyRefresh = true
  end
end

function DetectiveEvidencePage:RefreshTools()
  xdlog("工具")
  local unlockedToolList = SevenRoyalFamiliesProxy.Instance.evidenceToolList
  local staticToolList = SevenRoyalFamiliesProxy.Instance.staticEvidenceTool
  local result = {}
  for k, v in pairs(staticToolList) do
    if self.existEvidenceData[k] and (not (unlockedToolList and unlockedToolList[k]) or v <= unlockedToolList[k]) then
      xdlog("加入可用道具列表", k)
      table.insert(result, k)
    end
  end
  self.itemGridCtrl:ResetDatas(result)
end

function DetectiveEvidencePage:HandleChooseEvidence(cellCtrl)
  if self.curChooseEvidence then
    self.curChooseEvidence:SetChoose(false)
  end
  self.curChooseEvidence = cellCtrl
  self.curChooseEvidence:SetChoose(true)
  self.curChooseEvidence:SetNew(false)
  xdlog("HandleChooseEvidence", cellCtrl.id)
  self.curEvidenceID = cellCtrl.id
  SevenRoyalFamiliesProxy.Instance:SetEvidenceNew(self.curEvidenceID, false)
  self.previewPartContainer:SetActive(true)
  self.previewPartNone:SetActive(false)
  self.previewPartContainer_TweenAlpha:ResetToBeginning()
  self.previewPartContainer_TweenAlpha:PlayForward()
  self:RefreshPreviewPart(self.curEvidenceID)
end

function DetectiveEvidencePage:HandlePressItem(cell)
  xdlog("press")
  self.isStartDrag = true
  if not cell.isPress then
    self:OnPressUp()
  end
end

function DetectiveEvidencePage:OnPressUp()
  if self.isDragged then
    self.curOperateCell.gameObject:SetActive(false)
    local pos = self.curOperateCell.gameObject.transform.localPosition
    if pos.x > 100 and pos.x < 400 and pos.y > -170 and 100 > pos.y then
      xdlog("try use")
      self:EvidenceToolOperate()
    else
      helplog("释放")
    end
  end
end

function DetectiveEvidencePage:HandleDragItem(cell)
  if self.isStartDrag then
    self.isStartDrag = false
    self:CreateDragCell(cell)
  end
  if self.isDragCell then
    self.isDragged = true
    self:DragTool(cell.delta)
  end
end

function DetectiveEvidencePage:CreateDragCell(cell)
  self.isDragCell = true
  local cellPos = self.cameraUI:ScreenToWorldPoint(Input.mousePosition)
  self.curOperateCell.trans.position = cellPos
  self.curOperateCell.gameObject:SetActive(true)
  self.curOperateCell:SetData(cell.id)
end

function DetectiveEvidencePage:DragTool(delta)
  local inputPos = LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
  local vecPos = self.cameraUI:ScreenToWorldPoint(inputPos)
  self.curOperateCell.trans.position = vecPos
  local pos = self.curOperateCell.gameObject.transform.localPosition
  if pos.x > 100 and pos.x < 400 and pos.y > -170 and 100 > pos.y then
    if self.curOperateCell.id == self.operateNeed then
      self.curOperateCell:CreateEffect(true)
    end
  else
    self.curOperateCell:CreateEffect(false)
  end
end

function DetectiveEvidencePage:RefreshPreviewPart(id)
  if not id then
    return
  end
  local evidenceData = Table_Evidence[id]
  if not evidenceData then
    return
  end
  self.previewName.text = evidenceData.Name
  self.previewNameGO:SetActive(false)
  self.previewNameGO:SetActive(true)
  local itemConfig = Table_Item[id]
  self.evidenceDesc.text = itemConfig and itemConfig.Desc or "???"
  local evidenceMessage = evidenceData and evidenceData.Messages
  local totalEvidenceMessage = evidenceMessage and #evidenceMessage or 0
  local showEvidenceCount = 0
  for i = 1, #evidenceMessage do
    if not evidenceMessage[i].noshow then
      showEvidenceCount = showEvidenceCount + 1
    end
  end
  self.tipsGridCtrl:SetEmptyDatas(showEvidenceCount)
  local unlockMessages = self.existEvidenceData and self.existEvidenceData[id] and self.existEvidenceData[id].unlockMessage or {}
  local actionName = ""
  local showList = {}
  if unlockMessages and 0 < #unlockMessages then
    for i = 1, #evidenceMessage do
      local single = evidenceMessage[i]
      if 0 < TableUtility.ArrayFindIndex(unlockMessages, single.id) then
        if not single.noshow then
          table.insert(showList, single.id)
        end
        if single.action then
          actionName = single.action
        end
      end
    end
    local cells = self.tipsGridCtrl:GetCells()
    for i = 1, #cells do
      local single = cells[i]
      if showList[i] then
        single:SetData(showList[i])
      end
    end
  end
  self.tipsGrid:Reposition()
  self.descTable:Reposition()
  self.descScrollView:ResetPosition()
  local complete = true
  if totalEvidenceMessage ~= 0 and (not unlockMessages or totalEvidenceMessage > #unlockMessages) then
    complete = false
  end
  self.startCheckBtn:SetActive(true)
  self.finishSymbol:SetActive(false)
  local body = evidenceData.Body
  local scale = evidenceData.Scale or 1
  UIModelUtil.Instance:ResetTexture(self.evidenceTexture)
  if body then
    if nil == self.parts then
      self.parts = Asset_Role.CreatePartArray()
    end
    local partIndex = Asset_Role.PartIndex
    self.parts[partIndex.Body] = body
    UIModelUtil.Instance:SetCellTransparent(self.evidenceTexture)
    local previewModel = UIModelUtil.Instance:SetRoleModelTexture(self.evidenceTexture, self.parts, UIModelCameraTrans.Evidence, scale, nil, nil, nil, function(obj)
      if obj then
        local lodGroup = obj.completeTransform:GetComponentInChildren(LODGroup)
        if lodGroup then
          lodGroup.enabled = false
        end
      end
      for i = 1, 2 do
        local effectParent
        if i == 1 then
          effectParent = self:FindGO("effect", obj.complete.rendererNode.gameObject)
          if not effectParent then
            effectParent = self:FindGO("effect_1", obj.complete.rendererNode.gameObject)
          end
        else
          effectParent = self:FindGO("effect_" .. i, obj.complete.rendererNode.gameObject)
        end
        if effectParent then
          local anglePS = effectParent:GetComponentsInChildren(ParticleSystem, true)
          if anglePS then
            for j = 1, #anglePS do
              self:Hide(anglePS[j])
            end
          end
        end
      end
    end)
    local loadShowPos = evidenceData.Position
    if loadShowPos and #loadShowPos == 3 then
      previewModel:SetPosition(LuaGeometry.GetTempVector3(loadShowPos[1] or 0, loadShowPos[2] or 0, loadShowPos[3] or 0))
    end
    local loadShowRot = evidenceData.Rotation
    if loadShowRot and #loadShowRot == 3 then
      LuaVector3.Better_Set(rotVec, loadShowRot[1] or 0, loadShowRot[2] or 0, loadShowRot[3] or 0)
      previewModel:SetEulerAngles(rotVec)
    end
    if actionName and actionName ~= "" then
      previewModel:PlayAction_Simple(actionName)
    end
  end
end

local guideMessage = {
  [17] = 1
}

function DetectiveEvidencePage:RefreshDetailPart(id)
  if not id then
    return
  end
  if self.guideRoot.activeSelf then
    self.guideRoot:SetActive(false)
  end
  local evidenceData = Table_Evidence[id]
  local evidenceMessage = evidenceData and evidenceData.Messages
  local totalEvidenceMessage = evidenceMessage and #evidenceMessage or 0
  local showEvidenceCount = 0
  for i = 1, #evidenceMessage do
    if not evidenceMessage[i].noshow then
      showEvidenceCount = showEvidenceCount + 1
    end
  end
  self.infoGridCtrl:SetEmptyDatas(showEvidenceCount)
  local unlockMessages = self.existEvidenceData and self.existEvidenceData[id] and self.existEvidenceData[id].unlockMessage or {}
  local unlockMessageCount = unlockMessages and #unlockMessages or 0
  local actionName = ""
  local showList = {}
  if unlockMessages and 0 < #unlockMessages then
    for i = 1, #evidenceMessage do
      local single = evidenceMessage[i]
      if 0 < TableUtility.ArrayFindIndex(unlockMessages, single.id) then
        if not single.noshow then
          xdlog("显示列表", single.id)
          table.insert(showList, single.id)
        end
        if single.action then
          actionName = single.action
          xdlog("设置动画", actionName)
        end
      end
    end
    local cells = self.infoGridCtrl:GetCells()
    for i = 1, #cells do
      local single = cells[i]
      if showList[i] then
        single:SetData(showList[i])
      end
    end
  end
  self.infoGrid:Reposition()
  self.infoScrollView:ResetPosition()
  TableUtility.TableClear(self.evidenceUnlockCondition)
  if 0 < totalEvidenceMessage - unlockMessageCount then
    for i = 1, totalEvidenceMessage do
      local single = evidenceMessage[i]
      if TableUtility.ArrayFindIndex(unlockMessages, single.id) == 0 then
        if not single.pre or 0 < TableUtility.ArrayFindIndex(unlockMessages, single.pre) then
          local data = {}
          data.id = single.id
          data.rot = single.rot
          data.offset = single.offset
          data.toolid = single.toolid
          data.effect = single.effect
          table.insert(self.evidenceUnlockCondition, data)
          xdlog("尚未解锁", data.id)
          if guideMessage[single.id] and self.existEvidenceData[single.toolid] then
            self.guideRoot:SetActive(true)
          end
        else
          redlog("前置条件限制", single.id)
        end
      end
    end
  end
  TableUtility.TableClear(self.messageTipsList)
  TableUtility.TableClear(self.effectKeepList)
  for i = 1, #self.evidenceUnlockCondition do
    local id = self.evidenceUnlockCondition[i].id
    local config = Table_EvidenceMessage[id]
    local tips = config and config.Tips
    if tips and 0 < #tips then
      for j = 1, #tips do
        local tipData = {
          messageID = id,
          tipID = tips[j],
          effectID = self.evidenceUnlockCondition[i].effect
        }
        table.insert(self.messageTipsList, tipData)
      end
    end
  end
  self.evidenceName.text = evidenceData.Name
  if not self.UIModel then
    TableUtility.TableClear(self.effects)
    local body = evidenceData.Body
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    if body then
      if nil == self.parts then
        self.parts = Asset_Role.CreatePartArray()
      end
      local partIndex = Asset_Role.PartIndex
      self.parts[partIndex.Body] = body
      local scale = evidenceData.Scale or 1
      UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
      yacc = 0
      zacc = 0
      local detailModel = UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, self.parts, UIModelCameraTrans.Evidence, scale, nil, nil, nil, function(obj)
        self.UIModel = obj
        local lodGroup = obj.completeTransform:GetComponentInChildren(LODGroup)
        if lodGroup then
          lodGroup.enabled = false
        end
        for i = 1, 2 do
          local effectParent
          if i == 1 then
            effectParent = self:FindGO("effect", obj.complete.rendererNode.gameObject)
            if not effectParent then
              effectParent = self:FindGO("effect_1", obj.complete.rendererNode.gameObject)
            end
          else
            effectParent = self:FindGO("effect_" .. i, obj.complete.rendererNode.gameObject)
          end
          if effectParent then
            local anglePS = effectParent:GetComponentsInChildren(ParticleSystem, true)
            if anglePS then
              self.effects[i] = anglePS
              for j = 1, #anglePS do
                self:Hide(anglePS[j])
              end
            end
          end
        end
      end)
      local loadShowPos = evidenceData.Position
      if loadShowPos and #loadShowPos == 3 then
        detailModel:SetPosition(LuaGeometry.GetTempVector3(loadShowPos[1] or 0, loadShowPos[2] or 0, loadShowPos[3] or 0))
      end
      local loadShowRot = evidenceData.Rotation
      if loadShowRot and #loadShowRot == 3 then
        LuaVector3.Better_Set(rotVec, loadShowRot[1] or 0, loadShowRot[2] or 0, loadShowRot[3] or 0)
        detailModel:SetEulerAngles(rotVec)
      end
      if actionName and actionName ~= "" then
        xdlog("playaction", actionName)
        detailModel:PlayAction_Simple(actionName)
      end
      LuaQuaternion.Better_GetEulerAngles(detailModel.completeTransform.localRotation, rotVec)
      self:TransferEulerAngle(rotVec)
      xdlog("当前位置", rotVec[1], rotVec[2], rotVec[3])
      self:CheckRotationCorrect(rotVec)
    end
  else
    LuaQuaternion.Better_GetEulerAngles(self.UIModel.completeTransform.localRotation, rotVec)
    self:TransferEulerAngle(rotVec)
    xdlog("当前位置", rotVec[1], rotVec[2], rotVec[3])
    self:CheckRotationCorrect(rotVec)
  end
  uiFocusPosVec = nil
  self.curTipIndex = 1
  self.tipLabel_TweenAlpha.enabled = false
  self.tipLabel_TweenAlpha:ResetToBeginning()
  if actionName and actionName ~= "" then
    xdlog("playaction", actionName)
    if self.UIModel then
      self.UIModel:PlayAction_Simple(actionName)
    end
  end
end

function DetectiveEvidencePage:TryRotate(x, y)
  if self.UIModel then
    local rsx = 0.5
    local rsy = 0.5
    self.lastDeltaX = x
    self.lastDeltaY = y
    self.lastRotateTime = Time.time
    rotationQuatY = Quaternion.AngleAxis(-x * self.rotateSpeed * rsx, vec_up)
    rotationQuatZ = Quaternion.AngleAxis(-y * self.rotateSpeed * rsy, vec_right)
    self.UIModel.completeTransform.localRotation = rotationQuatZ * self.UIModel.completeTransform.localRotation
    self.UIModel.completeTransform.localRotation = rotationQuatY * self.UIModel.completeTransform.localRotation
    LuaQuaternion.Better_GetEulerAngles(self.UIModel.completeTransform.localRotation, rotVec)
    self:TransferEulerAngle(rotVec)
    self:CheckRotationCorrect(rotVec)
  end
end

function DetectiveEvidencePage:TryRotateByAxis(deltaX, deltaY)
  if self.UIModel then
    self.UIModel.completeTransform:Rotate(-deltaX * self.rotateSpeed, 0, 0)
    LuaQuaternion.Better_GetEulerAngles(self.UIModel.completeTransform.localRotation, rotVec)
    self:CheckRotationCorrect(rotVec)
  end
end

function DetectiveEvidencePage:TransferEulerAngle(vector3)
  for i = 1, 3 do
    if 180 < vector3[i] then
      vector3[i] = vector3[i] - 360
    end
  end
end

function DetectiveEvidencePage:TryArrowRotateUP(isPressed)
  if isPressed then
    TimeTickManager.Me():CreateTick(0, 20, function(owner, deltaTime)
      self:TryRotateByAxis(4)
    end, self, 55)
  else
    TimeTickManager.Me():ClearTick(self, 55)
  end
end

function DetectiveEvidencePage:TryArrowRotateDown(isPressed)
  if isPressed then
    TimeTickManager.Me():CreateTick(0, 20, function(owner, deltaTime)
      self:TryRotateByAxis(-4)
    end, self, 56)
  else
    TimeTickManager.Me():ClearTick(self, 56)
  end
end

function DetectiveEvidencePage:CheckRotationCorrect(curRot)
  if not curRot then
    return
  end
  LuaVector3.Better_Set(posVec, 50, 50, 50)
  for i = 1, #self.evidenceUnlockCondition do
    local single = self.evidenceUnlockCondition[i]
    if single.rot then
      local targetRot = single.rot
      local offset = single.offset or posVec
      if curRot[1] > targetRot[1] - offset[1] and curRot[1] < targetRot[1] + offset[1] and curRot[2] > targetRot[2] - offset[2] and curRot[2] < targetRot[2] + offset[2] and curRot[3] > targetRot[3] - offset[3] and curRot[3] < targetRot[3] + offset[3] then
        self.targetMessageID = single.id
        if single.toolid then
          xdlog("需要工具", single.toolid)
          self.operateNeed = single.toolid
        end
        if enableCorrectTip then
          self.correctTip:SetActive(true)
        end
        if single.effect and self.effects[single.effect] then
          for j = 1, #self.effects[single.effect] do
            self:Show(self.effects[single.effect][j])
          end
        end
        return
      end
    end
  end
  if enableCorrectTip then
    self.correctTip:SetActive(false)
  end
  for i = 1, 2 do
    if self.effects[i] and #self.effects[i] > 0 and TableUtility.ArrayFindIndex(self.effectKeepList, i) == 0 then
      for j = 1, #self.effects[i] do
        self:Hide(self.effects[i][j])
      end
    end
  end
  self.targetMessageID = nil
  self.operateNeed = 0
end

function DetectiveEvidencePage:EvidenceToolOperate()
  if not self.targetMessageID or self.operateNeed == 0 then
    redlog("该证物无需使用操作道具")
    return
  end
  if self.curOperateCell.id == self.operateNeed then
    xdlog("UnlockEvidenceMessageCmd申请解锁证物信息", self.curChooseEvidence.id, self.targetMessageID)
    ServiceQuestProxy.Instance:CallUnlockEvidenceMessageCmd(self.curChooseEvidence.id, self.targetMessageID)
  end
end

function DetectiveEvidencePage:EnlightNewMessage(data)
  local evidenceId = data.evidence_id
  if not self.curChooseEvidence or self.curChooseEvidence.id ~= evidenceId then
    return
  end
  local messageId = data.message_id
  local cells = self.infoGridCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].id == messageId then
      cells[i]:Enlight()
    end
  end
end

function DetectiveEvidencePage:RefreshModel()
  if self.curEvidenceID then
    if self.detailPart.activeSelf then
      self:RefreshDetailPart(self.curEvidenceID)
    end
    self:RefreshPreviewPart(self.curEvidenceID)
  end
end

function DetectiveEvidencePage:OnEnter()
  DetectiveEvidencePage.super.OnEnter(self)
  local dragObj = self.container.dragModelCell
  self.curOperateCell = DragModelCell.new(dragObj)
  dragObj:SetActive(false)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function DetectiveEvidencePage:OnExit()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  DetectiveEvidencePage.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end

function DetectiveEvidencePage:OnDisable()
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  self.UIModel = nil
end

local BaseCell = autoImport("BaseCell")
DragModelCell = class("DragModelCell", BaseCell)
local rotVec = LuaVector3.Zero()

function DragModelCell:Init()
  DragModelCell.super.Init(self)
  self:FindObjs()
end

function DragModelCell:FindObjs()
  self.toolTexture = self:FindGO("ToolTexture"):GetComponent(UITexture)
  self.effectContainer = self:FindGO("CorrectEffectContainer")
end

function DragModelCell:SetData(data)
  self.data = data
  self.id = self.data
  local config = Table_Evidence[self.id]
  local body = config and config.Body
  local scale = config and config.Scale or 1
  UIModelUtil.Instance:ResetTexture(self.toolTexture)
  if body then
    if nil == self.parts then
      self.parts = Asset_Role.CreatePartArray()
    end
    local partIndex = Asset_Role.PartIndex
    self.parts[partIndex.Body] = body
    UIModelUtil.Instance:SetCellTransparent(self.toolTexture)
    self.dragModel = UIModelUtil.Instance:SetRoleModelTexture(self.toolTexture, self.parts, UIModelCameraTrans.Evidence, scale, nil, nil, nil, function(obj)
      if obj then
        local lodGroup = obj.completeTransform:GetComponentInChildren(LODGroup)
        if lodGroup then
          lodGroup.enabled = false
        end
      end
    end)
    local loadShowPos = config.Position
    if loadShowPos and #loadShowPos == 3 then
      self.dragModel:SetPosition(LuaGeometry.GetTempVector3(loadShowPos[1] or 0, loadShowPos[2] or 0, loadShowPos[3] or 0))
    end
    local loadShowRot = config.Rotation
    if loadShowRot and #loadShowRot == 3 then
      LuaVector3.Better_Set(rotVec, loadShowRot[1] or 0, loadShowRot[2] or 0, loadShowRot[3] or 0)
      self.dragModel:SetEulerAngles(rotVec)
    end
    self.dragModel:AddOutlineProcess()
  end
end

function DragModelCell:CreateEffect(bool)
  if bool then
    if not self.effect then
      xdlog("创建特效")
      self.effect = self:PlayUIEffect(EffectMap.UI.SevenRoyalFamilies_EvidenceBook_CorrectEffect, self.effectContainer, false)
    end
    if not self.effectContainer.activeSelf then
      self.effectContainer:SetActive(true)
    end
  elseif self.effectContainer.activeSelf then
    self.effectContainer:SetActive(false)
  end
end

function DragModelCell:OnDestroy()
  UIModelUtil.Instance:ResetTexture(self.toolTexture)
  DragModelCell.super.OnDestroy(self)
end
