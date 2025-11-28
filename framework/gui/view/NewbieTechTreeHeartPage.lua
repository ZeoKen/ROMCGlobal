NewbieTechTreeHeartPage = class("NewbieTechTreeHeartPage", SubView)
NewbieTechTreeHeartPage.BranchList = {
  41,
  42,
  43,
  44,
  45
}
local texObjStaticNameMap = {
  PageBg = "tree_bg_bottom_02",
  Bottom3 = "tree_bg_bottom_03",
  Bottom4 = "tree_bg_bottom_04",
  Bottom6 = "tree_bg_bottom_06"
}
local diretAdd = false

function NewbieTechTreeHeartPage:Init()
  if not picIns then
    picIns = PictureManager.Instance
  end
  self:ReLoadPerferb("view/NewbieTechTreeHeartPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, -30, 0)
  self:FindObjs()
  self:InitPage()
  self:AddEvents()
  self:RegisterGuide()
end

function NewbieTechTreeHeartPage:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.costCtrl1 = self:FindGO("CostCtrl1")
  self.cost1Sp = self.costCtrl1:GetComponent(UISprite)
  self.cost1Label = self:FindGO("CostLabel", self.costCtrl1):GetComponent(UILabel)
  self.cost1AddBtn = self:FindGO("CostAddBtn", self.costCtrl1)
  self.cost1GetPathContainer = self:FindGO("GetPathContainer", self.costCtrl1)
  self:AddClickEvent(self.cost1Sp.gameObject, function()
    self.tipData.itemdata = ItemData.new("cost", self.costItem)
    self:ShowItemTip(self.tipData, self.cost1Sp, NGUIUtil.AnchorSide.Down, costTipOffset)
  end)
  self:AddClickEvent(self.cost1AddBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TechTreeGuidePopUp
    })
  end)
  self.interactivePartGO = self:FindGO("InteractivePart")
  self.interactivePart = {}
  self.leafList = {}
  for i = 1, 5 do
    local pack = {}
    local go = self:FindGO("Part" .. i)
    pack.chooseSymbol = self:FindGO("ChooseSymbol" .. i, go)
    pack.chooseSymbol:SetActive(false)
    pack.clickArea = self:FindGO("ClickArea", go)
    local targetBranch = NewbieTechTreeHeartPage.BranchList[i]
    self:AddClickEvent(pack.clickArea, function()
      self.container:ShowBranchTip(targetBranch)
      self.curChooseBranchIndex = i
      self:ShowRuins(i)
      self:ShowProcess(i)
      self:UpdateActionBtn(i)
    end)
    pack.processLabel = self:FindGO("ProcessLabel", go):GetComponent(UILabel)
    pack.processLabel.gameObject:SetActive(false)
    local ruinsGO = self:FindGO("Ruins", go)
    local leafs = TechTreeProxy.Instance:GetLeafsByBranch(targetBranch)
    local ruins = {}
    for j = 1, 5 do
      local ruin = self:FindGO(j, ruinsGO)
      ruin.name = leafs and leafs[j] or 0
      ruins[tonumber(ruin.name)] = ruin
      self.leafList[tonumber(ruin.name)] = ruin
    end
    pack.ruinsParent = ruinsGO
    pack.ruins = ruins
    ruinsGO:SetActive(false)
    local piecesGO = self:FindGO("Pieces", go)
    local pieces = {}
    for j = 1, 5 do
      local piece = self:FindGO(j, piecesGO)
      piece.name = "piece" .. j
      table.insert(pieces, piece)
      piece:SetActive(false)
    end
    pack.pieces = pieces
    self.interactivePart[i] = pack
  end
  self.actionPart = self:FindGO("ActionPart")
  self.leafEffectLabelGO = self:FindGO("LeafEffectLabel")
  self.leafEffectLabel = self.leafEffectLabelGO:GetComponent(UILabel)
  self.leafEffectLabel_TweenAlpha = self.leafEffectLabelGO:GetComponent(TweenAlpha)
  self.leafEffectLabel_TweenAlpha:ResetToBeginning()
  self.progress = self:FindComponent("Progress", UILabel)
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
  self.actionBtn = self:FindGO("ActionBtn")
  self.actionBtn_Icon = self.actionBtn:GetComponent(UIMultiSprite)
  self.actionBtn_Label = self:FindGO("Label", self.actionBtn):GetComponent(UILabel)
  self.actionBtn_BoxCollider = self.actionBtn:GetComponent(BoxCollider)
  local actionTipLabelGO = self:FindGO("ActionTipLabel")
  self.actionTipLabel = actionTipLabelGO:GetComponent(UILabel)
  self.actionTipClickUrl = actionTipLabelGO:GetComponent(UILabelClickUrl)
  self:AddOrRemoveGuideId(actionTipLabelGO, 488)
  
  function self.actionTipClickUrl.callback(url)
    local cmt = actionTipLabelGO:GetComponent(GuideTagCollection)
    if cmt and cmt.id ~= -1 then
      FunctionGuide.Me():triggerWithTag(cmt.id)
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TechTreeGuidePopUp
    })
  end
  
  local longPress = self.actionBtn:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    if state then
      self.curInjectCount = diretAdd and self.maxProcess - self.curProcess or 1
      self.maxWaitCount = 10
      self.speedLimit = 7
      self.waitCount = self.maxWaitCount
      self.container:HideAllTips()
      TimeTickManager.Me():CreateTick(0, 10, self.addInjectCount, self, 1)
    else
      TimeTickManager.Me():ClearTick(self, 1)
      self:tryCallAddProcess()
      local cmt = obj:GetComponent(GuideTagCollection)
      if cmt and cmt.id ~= -1 then
        FunctionGuide.Me():triggerWithTag(cmt.id)
      end
    end
  end
  
  self.bgEffectHandler = self:FindGO("BgEffectHandler")
  self.branchEffectHandler = self:FindGO("BranchEffectHandler")
  self.clickCollider = self:FindGO("ClickCollider"):GetComponent(BoxCollider)
  self.clickCollider.enabled = false
end

function NewbieTechTreeHeartPage:InitPage()
  self.curInjectCount = 0
  self.treeId = self.container.treeId or 4
  self.curChooseBranchIndex = 1
  self.costItem = GameConfig.NoviceTechTree.CostItem or 6927
  IconManager:SetItemIcon(Table_Item[self.costItem].Icon, self.cost1Sp)
  self:UpdateCostCtrls()
  self:UpdateInjectInfo()
  self:UpdateActionBtn()
  self:PlayUIEffect(EffectMap.UI.NewbieTechTree_BgEffect, self.bgEffectHandler, false, function(obj, args, assetEffect)
    self.bgEffect = assetEffect
    self.bgEffect:ResetAction("ufx_kejishu_yimier_" .. "state1001", 0, true)
  end)
end

function NewbieTechTreeHeartPage:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeInjectCmd, self.UpdateInjectInfo)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeInjectInfoCmd, self.UpdateInjectInfo)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, self.UpdateRuins)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function NewbieTechTreeHeartPage:OnItemUpdate()
  self:UpdateCostCtrls()
  self:UpdateActionBtn()
end

function NewbieTechTreeHeartPage:UpdateCostCtrls()
  self.cost1Label.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(self.costItem)) or 0
end

function NewbieTechTreeHeartPage:addInjectCount()
  local bagNum = HappyShopProxy.Instance:GetItemNum(self.costItem)
  if bagNum == 0 or bagNum < self.curInjectCount then
    return
  end
  if not self.curLeafNode then
    return
  end
  if self.maxWaitCount > 1 then
    self.waitCount = self.waitCount - 1
    if self.waitCount == 0 then
      self.maxWaitCount = self.maxWaitCount - 1
      self.waitCount = self.maxWaitCount
      self.curInjectCount = self.curInjectCount + 1
    end
  else
    if -self.maxWaitCount <= self.speedLimit then
      self.maxWaitCount = self.maxWaitCount - 1
    end
    local addCount = self.maxWaitCount * -1
    self.curInjectCount = self.curInjectCount + addCount
  end
  if self.curInjectCount + self.curProcess > self.maxProcess then
    self.curInjectCount = self.maxProcess - self.curProcess
  end
  if bagNum < self.curInjectCount then
    self.curInjectCount = bagNum
  end
  self.progress.text = self.curInjectCount + self.curProcess .. "/" .. self.maxProcess
  self.progressSlider.value = (self.curInjectCount + self.curProcess) / self.maxProcess
  if self.curInjectCount + self.curProcess >= self.maxProcess then
    TimeTickManager.Me():ClearTick(self, 1)
    self:tryCallAddProcess()
    return
  end
  if bagNum <= self.curInjectCount then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
end

function NewbieTechTreeHeartPage:tryCallAddProcess()
  xdlog("递交消息申请", self.curInjectCount)
  if self.curInjectCount + self.curProcess > self.maxProcess then
    return
  end
  local bagNum = HappyShopProxy.Instance:GetItemNum(self.costItem)
  if bagNum < self.curInjectCount then
    return
  end
  self.progress.text = self.curInjectCount + self.curProcess .. "/" .. self.maxProcess
  self.progressSlider.value = (self.curInjectCount + self.curProcess) / self.maxProcess
  xdlog("提交注入", self.curLeafNode, self.curInjectCount)
  if self.curInjectCount < 0 then
    self.curInjectCount = 0
  end
  self.clickCollider.enabled = true
  ServiceTechTreeCmdProxy.Instance:CallTechTreeInjectCmd(self.treeId, self.curLeafNode, self.curInjectCount)
end

function NewbieTechTreeHeartPage:UpdateInjectInfo()
  local injectInfo = TechTreeProxy.Instance.newbieTechTreeInjectInfo and TechTreeProxy.Instance.newbieTechTreeInjectInfo[self.treeId]
  if not injectInfo or not injectInfo.leafnode then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
  self.clickCollider.enabled = false
  local waitEffect = false
  if self.curLeafNode and injectInfo.leafnode ~= self.curLeafNode then
    local desc = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "Tips")
    if desc and desc ~= "" then
      self.leafEffectLabel.text = desc or ""
      self.leafEffectLabel_TweenAlpha:ResetToBeginning()
      self.leafEffectLabel_TweenAlpha:PlayForward()
    end
    waitEffect = true
    if self.leafList[self.curLeafNode].activeSelf then
      local go = self.leafList[self.curLeafNode]
      local sprite = go:GetComponent(UISprite)
      LeanTween.alphaNGUI(sprite, 1, 0, 1)
      self:PlayUIEffect(EffectMap.UI.NewbieTechTree_RuinBroken, go, true)
      local index = self:GetBranchIndexByLeafNode(self.curLeafNode)
      if index then
        self:PlayUIEffect(EffectMap.UI["NewbieTechTree_Branch" .. index], self.branchEffectHandler, true, function()
          TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
            self:PlayUIEffect(EffectMap.UI.NewbieTechTree_ProcessUpdate, self.bgEffectHandler, true)
          end, self, 4)
        end)
      end
    end
  end
  self.curLeafNode = injectInfo.leafnode
  self.curProcess = injectInfo.injectNum
  local unlockItems = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "UnlockItems")
  if unlockItems then
    self.maxProcess = unlockItems and unlockItems[1].num
    self.progress.text = self.curProcess .. "/" .. self.maxProcess
    self.progressSlider.value = self.curProcess / self.maxProcess
  end
  local treeid = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "TreeID")
  if not treeid or treeid[1] ~= self.treeId then
    self.actionPart:SetActive(false)
  else
    self.actionPart:SetActive(true)
  end
  local unlockMenu = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "unlockMenu")
  if unlockMenu and not FunctionUnLockFunc.Me():CheckCanOpen(unlockMenu) then
    local menuConfig = Table_Menu[unlockMenu]
    self.actionTipLabel.text = menuConfig and menuConfig.text
    self.actionBtn_Icon.CurrentState = 1
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    self.actionBtn_Label.color = LuaGeometry.GetTempVector4(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
    self.actionBtn_BoxCollider.enabled = false
    self.actionTipLabel.color = LuaGeometry.GetTempVector4(1, 0.36470588235294116, 0.08235294117647059, 1)
    self.actionTipLabel.effectColor = LuaGeometry.GetTempVector4(0.3215686274509804, 0.2, 0.1411764705882353, 1)
    self.progress.gameObject:SetActive(false)
  end
  local delay = waitEffect and 1500 or 0
  TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
    local index = self:GetBranchIndexByLeafNode(self.curLeafNode)
    if index then
      self.curChooseBranchIndex = index
      self:ShowRuins(index)
      self:ShowProcess(index)
      self:UpdateActionBtn(index)
    end
    self:UpdateRuins()
  end, self, 3)
end

function NewbieTechTreeHeartPage:OnRecvProcess(note)
  xdlog("注入反馈")
end

function NewbieTechTreeHeartPage:UpdateActionBtn(index)
  local curBranchIndex = index or self.curChooseBranchIndex
  local targetBranchIndex = self:GetBranchIndexByLeafNode(self.curLeafNode) or 1
  local bagNum = HappyShopProxy.Instance:GetItemNum(self.costItem)
  local unlockMenu = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "unlockMenu")
  self.progress.gameObject:SetActive(false)
  if curBranchIndex < targetBranchIndex then
    self.actionBtn_Icon.CurrentState = 1
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    self.actionBtn_Label.color = LuaGeometry.GetTempVector4(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
    self.actionBtn_BoxCollider.enabled = false
    self.actionBtn_Label.text = ZhString.NewbieTechTree_ProcessFinish
  elseif curBranchIndex > targetBranchIndex then
    self.actionBtn_Icon.CurrentState = 1
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    self.actionBtn_Label.color = LuaGeometry.GetTempVector4(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
    self.actionBtn_BoxCollider.enabled = false
    self.actionBtn_Label.text = ZhString.NewbieTechTree_Unenabled
  elseif bagNum == 0 then
    self.actionBtn_Icon.CurrentState = 1
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    self.actionBtn_Label.color = LuaGeometry.GetTempVector4(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
    self.actionBtn_BoxCollider.enabled = false
    self.actionBtn_Label.text = ZhString.NewbieTechTree_Inject
    self.progress.gameObject:SetActive(true)
  elseif unlockMenu and not FunctionUnLockFunc.Me():CheckCanOpen(unlockMenu) then
    self.actionBtn_Icon.CurrentState = 1
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    self.actionBtn_Label.color = LuaGeometry.GetTempVector4(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
    self.actionBtn_BoxCollider.enabled = false
    self.actionBtn_Label.text = ZhString.NewbieTechTree_Unenabled
  else
    self.actionBtn_Icon.CurrentState = 0
    self.actionBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1)
    self.actionBtn_Label.color = LuaColor.White()
    self.actionBtn_BoxCollider.enabled = true
    self.actionBtn_Label.text = ZhString.NewbieTechTree_Inject
    self.progress.gameObject:SetActive(true)
  end
  if unlockMenu and not FunctionUnLockFunc.Me():CheckCanOpen(unlockMenu) then
    local menuConfig = Table_Menu[unlockMenu]
    self.actionTipLabel.text = menuConfig and menuConfig.text
    self.actionTipLabel.color = LuaGeometry.GetTempVector4(1, 0.36470588235294116, 0.08235294117647059, 1)
    self.actionTipLabel.effectColor = LuaGeometry.GetTempVector4(0.3215686274509804, 0.2, 0.1411764705882353, 1)
  elseif bagNum == 0 then
    self.actionTipLabel.text = ZhString.NewbieTechTree_NotEnoughEnergy
    self.actionTipLabel.color = LuaGeometry.GetTempVector4(1, 0.36470588235294116, 0.08235294117647059, 1)
    self.actionTipLabel.effectColor = LuaGeometry.GetTempVector4(0.3215686274509804, 0.2, 0.1411764705882353, 1)
  else
    self.actionTipLabel.text = ZhString.NewbieTechTree_InjectEnergyTip
    self.actionTipLabel.color = LuaColor.White()
    self.actionTipLabel.effectColor = LuaGeometry.GetTempVector4(0.35294117647058826, 0.3764705882352941, 0.4980392156862745, 1)
  end
end

function NewbieTechTreeHeartPage:ShowRuins(index)
  if not self.interactivePart[index] then
    return
  end
  for i = 1, 5 do
    if i == index then
      self.interactivePart[i].chooseSymbol:SetActive(true)
      self.interactivePart[i].ruinsParent:SetActive(true)
      local widget = self.interactivePart[i].ruinsParent:GetComponent(UIWidget)
      if widget.alpha ~= 1 then
        LeanTween.alphaNGUI(widget, 0, 1, 1)
      end
      self.interactivePart[i].processLabel.gameObject:SetActive(true)
    else
      self.interactivePart[i].chooseSymbol:SetActive(false)
      local widget = self.interactivePart[i].ruinsParent:GetComponent(UIWidget)
      LeanTween.alphaNGUI(widget, widget.alpha, 0, 0.1)
      self.interactivePart[i].ruinsParent:SetActive(false)
      self.interactivePart[i].processLabel.gameObject:SetActive(false)
    end
  end
end

function NewbieTechTreeHeartPage:RefreshPieces()
  for i = 1, 5 do
    local pack = self.interactivePart[i]
    local pieces = pack.pieces
    local targetBranch = NewbieTechTreeHeartPage.BranchList[i]
    local leafs = TechTreeProxy.Instance:GetLeafsByBranch(targetBranch)
    for j = 1, #leafs do
      local leaf = leafs[j]
      local isUnlock = TechTreeProxy.Instance:IsLeafUnlocked(leaf, self.treeId)
      if not pieces[j] then
        redlog("超出碎片数量上线", leaf)
        break
      end
      pieces[j]:SetActive(isUnlock)
    end
  end
end

function NewbieTechTreeHeartPage:ShowProcess(index)
end

function NewbieTechTreeHeartPage:UpdateRuins()
  xdlog("刷新ruins")
  for i = 1, 5 do
    local ruins = self.interactivePart[i].ruins
    local pieces = self.interactivePart[i].pieces
    local unlockPieces = 0
    for k, v in pairs(ruins) do
      if k < self.curLeafNode then
        unlockPieces = unlockPieces + 1
        v:SetActive(false)
      end
    end
    for j = 1, unlockPieces do
      pieces[j]:SetActive(true)
    end
    self.interactivePart[i].processLabel.text = unlockPieces * 20 .. "%"
    if 5 <= unlockPieces then
      self.interactivePart[i].processLabel.color = LuaGeometry.GetTempVector4(1, 0.49411764705882355, 0, 1)
    end
  end
  if self.bgEffect then
    local treeid = TechTreeProxy.Instance:GetStaticValueOfLeaf(self.curLeafNode, 1, "TreeID")
    if not treeid or treeid[1] ~= self.treeId then
      local str = string.format("state%s001", 7)
      xdlog("当前特效", str)
      self.bgEffect:ResetAction("ufx_kejishu_yimier_" .. str, 0, true)
      self.Bottom3.gameObject:SetActive(true)
    else
      local index = self:GetBranchIndexByLeafNode(self.curLeafNode)
      local str = string.format("state%s001", index + 1)
      xdlog("当前特效", str)
      self.bgEffect:ResetAction("ufx_kejishu_yimier_" .. str, 0, true)
      self.Bottom3.gameObject:SetActive(false)
    end
  end
end

function NewbieTechTreeHeartPage:ShowGetPathOfCost(itemID, parent)
  if self.bdt then
    self.bdt:OnExit()
  elseif itemID then
    self.bdt = GainWayTip.new(parent)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(itemID)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function NewbieTechTreeHeartPage:GetPathCloseCall()
  self.bdt = nil
end

function NewbieTechTreeHeartPage:OnEnter()
  NewbieTechTreeHeartPage.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  xdlog("申请注入信息", self.treeId)
  ServiceTechTreeCmdProxy.Instance:CallTechTreeInjectInfoCmd(self.treeId)
end

function NewbieTechTreeHeartPage:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  TimeTickManager.Me():ClearTick(self)
  NewbieTechTreeHeartPage.super.OnExit(self)
end

function NewbieTechTreeHeartPage:RegisterGuide()
  self:AddOrRemoveGuideId(self.actionBtn, 480)
end

function NewbieTechTreeHeartPage:GetBranchIndex(branch)
  if not branch then
    return
  end
  for i = 1, 5 do
    if NewbieTechTreeHeartPage.BranchList[i] == branch then
      return i
    end
  end
  return nil
end

function NewbieTechTreeHeartPage:GetBranchIndexByLeafNode(leaf)
  local targetBranch = TechTreeProxy.Instance:GetStaticValueOfLeaf(leaf, 1, "Branch")
  return self:GetBranchIndex(targetBranch)
end
