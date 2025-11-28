autoImport("UINode")
autoImport("LStack")
autoImport("EventDispatcher")
local _ArrayClear = TableUtility.ArrayClear
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
UILayer = class("UILayer", EventDispatcher)
UILayer.AddChildEvent = "UILayer_AddChildEvent"
UILayer.EmptyChildEvent = "UILayer_EmptyChildEvent"
UILayer.ShowPos = Vector3.zero
UILayer.HidePos = Vector3(-10000, -10000, 0)

function UILayer:ctor(data, root)
  self.data = data
  if ApplicationInfo.IsRunOnWindowns() then
    self.showHideMode = self.data.showHideMode ~= nil and self.data.showHideMode or LayerShowHideMode.ActiveAndDeactive
  else
    self.showHideMode = self.data.showHideMode ~= nil and self.data.showHideMode or LayerShowHideMode.MoveOutAndMoveIn
  end
  self.depthGap = 15
  self.nodes = {}
  self.tempArray = {}
  self.hideMasters = {}
  self.panelNum = 0
  self.name = data.name
  self.depth = data.depth
  self.gameObject = GameObject()
  self.cachedNode = {}
  self.stack = LStack.new()
  self.uiRoot = root
  Game.GameObjectUtil:ChangeLayersRecursively(self.gameObject, "UI")
  self.gameObject.transform:SetParent(self.uiRoot.transform, false)
  self:TryCreateColliderMask()
  self:Rename()
  self:InitShowHideModeCall()
end

function UILayer:StartDepth()
  return self.data.depth * self.depthGap
end

function UILayer:UINodeStartDepth()
  return self:StartDepth() + 1
end

function UILayer:TryCreateColliderMask()
  if self.data and self.data.coliderColor and not self.colliderMask then
    self.colliderMask = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("ColliderView")):GetComponent(UIPanel)
    self.colliderMaskContainer = GameObject("MaskContainer")
    self.colliderMaskContainer.transform:SetParent(self.gameObject.transform, false)
    self.colliderMask.transform:SetParent(self.colliderMaskContainer.transform, false)
    self.colliderMask.depth = self:StartDepth()
    local sprite = self.colliderMask.gameObject:GetComponentInChildren(UISprite)
    sprite.color = self.data.coliderColor
    self:HideMask()
  end
end

function UILayer:Rename()
  self.gameObject.name = orginStringFormat("L%s_%s(%s)(%s)(%s)", self.depth, self.name, #self.nodes, self:GetPanelNum(), self.stack:GetCount())
end

function UILayer:AddHideMasterLayer(layer)
  if TableUtil.ArrayIndexOf(self.hideMasters, layer) == 0 then
    self.hideMasters[#self.hideMasters + 1] = layer
    self:Hide()
  end
end

function UILayer:RemoveHideMasterLayer(layer)
  if TableUtil.Remove(self.hideMasters, layer) > 0 and #self.hideMasters == 0 then
    self:Show()
  end
end

function UILayer:Show()
  if self.showHideMode == LayerShowHideMode.ActiveAndDeactive then
    if self.gameObject then
      self.gameObject:SetActive(true)
    end
  else
    if self.gameObject then
      self.gameObject.transform.localPosition = UILayer.ShowPos
    end
    if self.colliderMaskContainer and not self.colliderMaskContainer.activeSelf then
      self.colliderMaskContainer:SetActive(true)
      Game.HotKeyManager:SetEnableMoveAxisDirty()
    end
  end
  for i = 1, #self.nodes do
    self.nodes[i]:OnShow()
  end
end

function UILayer:Hide()
  if self.showHideMode == LayerShowHideMode.ActiveAndDeactive then
    if self.gameObject then
      self.gameObject:SetActive(false)
    end
  else
    if self.gameObject then
      self.gameObject.transform.localPosition = UILayer.HidePos
    end
    if self.colliderMaskContainer and self.colliderMaskContainer.activeSelf then
      self.colliderMaskContainer:SetActive(false)
      Game.HotKeyManager:SetEnableMoveAxisDirty()
    end
  end
  for i = 1, #self.nodes do
    self.nodes[i]:OnHide()
  end
end

function UILayer:IsOnShow()
  return self.gameObject and not Slua.IsNull(self.gameObject) and self.gameObject.activeSelf
end

function UILayer:ShowMask()
  if self.colliderMask and not self.colliderMask.gameObject.activeSelf then
    self.colliderMask.gameObject:SetActive(true)
    Game.HotKeyManager:SetEnableMoveAxisDirty()
  end
end

function UILayer:HideMask()
  if self.colliderMask and self.colliderMask.gameObject.activeSelf then
    self.colliderMask.gameObject:SetActive(false)
    Game.HotKeyManager:SetEnableMoveAxisDirty()
  end
end

function UILayer:IsMaskOn()
  return self.colliderMask and self.colliderMask.gameObject.activeSelf
end

function UILayer:GetPanelNum()
  local num = 0
  for i = 1, #self.nodes do
    num = num + self.nodes[i]:GetPanelNum()
  end
  return num
end

function UILayer:FindNodeFunc(cond, param)
  for i = 1, #self.nodes do
    if cond == self.nodes[i][param] then
      return self.nodes[i]
    end
  end
  return nil
end

function UILayer:FindNode(ctrl)
  return self:FindNodeFunc(ctrl, "viewCtrl")
end

function UILayer:FindNodeByName(ctrl)
  return self:FindNodeFunc(ctrl, "viewname")
end

function UILayer:FindNodeByClassName(className)
  return self:FindNodeFunc(className, "class")
end

function UILayer:HasOtherNodeByClassName(className)
  for i = 1, #self.nodes do
    if self.nodes[i].class ~= className and self.nodes[i]:IsShow() then
      return true
    end
  end
  return false
end

function UILayer:HasAnyNode(className)
  for i = 1, #self.nodes do
    if self.nodes[i]:IsShow() then
      return true
    end
  end
  return false
end

function UILayer:CreateChild(data, prefab, class, needRollBack)
  local node = self:FindNodeByName(data.viewname or prefab)
  local custom_reEntnerNotDestory = data and data.viewdata and type(data.viewdata) == "table" and data.viewdata.reEntnerNotDestory
  if node and not self.data.reEntnerNotDestory and not custom_reEntnerNotDestory then
    self:DestoryChild(node, true)
    node = nil
  end
  if node and custom_reEntnerNotDestory then
    node:ResetViewData(data)
    if node.viewCtrl and node.viewCtrl.ReloadView then
      node.viewCtrl:ReloadView()
    end
  end
  if not node then
    local viewClass = UINode.GetImport(class or data.viewname)
    node = self.cachedNode[viewClass.__cname]
    if not node then
      node = UINode.new(data, prefab, class, self, needRollBack)
      node:Create()
    else
      node:ResetViewData(data)
      self.cachedNode[viewClass.__cname] = nil
    end
    self:AddChild(node)
  end
  return node
end

function UILayer:IndexOfSameUINode(node, compareNode)
  return node.viewClass == compareNode.viewClass
end

function UILayer:TryPushNodeToStack(newNode, node)
  if not newNode:NeedRollBack() and not node:NeedPushToStack() then
    return false
  end
  local findSameDepth = self.stack:GetDepthByFunc(node, self.IndexOfSameUINode, self)
  if 0 < findSameDepth then
    self.stack:RemoveNum(findSameDepth)
  end
  if node:GetShowHideMode() == PanelShowHideMode.CreateAndDestroy then
    node = node:Clone()
  end
  self.stack:Push(node)
  return true
end

function UILayer:TryRollBackPrevious()
  local previous = self.stack:Pop()
  if previous then
    previous:Create()
    return self:AddChild(previous, false)
  end
  return false
end

function UILayer:AddChild(node, pushStack)
  if pushStack == nil then
    pushStack = true
  end
  if node and not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    if node.layer ~= self then
      if node.layer then
        node.layer:RemoveChild(node)
      end
      node:SetLayer(self)
    end
    if not node.data.view and node.data.viewname then
      node.data.view = PanelConfig[node.data.viewname]
    end
    local keepMask = not node.data.view or not node.data.view.hideCollider
    _ArrayShallowCopy(self.tempArray, self.nodes)
    for i = #self.tempArray, 1, -1 do
      if self:CanNodeDestroy(node, self.tempArray[i]) then
        if pushStack then
          self:TryPushNodeToStack(node, self.tempArray[i])
        end
        self:DestoryChild(self.tempArray[i], nil, keepMask)
      end
    end
    _ArrayClear(self.tempArray)
    self.nodes[#self.nodes + 1] = node
    if #self.nodes == 1 then
      self:DispatchEvent(UILayer.AddChildEvent)
    end
    self:ModeShow(node)
    node:OnEnter()
    node:SetDepth(self:UINodeStartDepth())
    self:Rename()
    if node.data.view and node.data.view.hideCollider then
      self:HideMask()
    else
      self:ShowMask()
    end
    return true
  else
    printRed(string.format("%s Layer想添加一个不存在的uinode", self.name))
  end
  return false
end

function UILayer:RemoveChild(node, create, keepMask)
  if node and TableUtil.Remove(self.nodes, node) > 0 then
    node:SetLayer(nil)
    node:OnHide()
    node:OnExit()
    self:Rename()
    if not create and #self.nodes == 0 then
      self:DispatchEvent(UILayer.EmptyChildEvent)
      if not keepMask then
        self:HideMask()
      end
    end
    return true
  end
  return false
end

function UILayer:RemoveChildByCtrl(ctrl)
  local node = self:FindNode(ctrl)
  return self:RemoveChild(node)
end

function UILayer:DestoryChildByCtrl(ctrl)
  local node = self:FindNode(ctrl)
  return self:DestoryChild(node)
end

function UILayer:DestoryChild(node, create, keepMask)
  if node and node.layer == self then
    self:RemoveChild(node, create, keepMask)
    self:ModeHide(node)
  end
end

function UILayer:DestoryAllChildren(keepMask)
  _ArrayShallowCopy(self.tempArray, self.nodes)
  for i = 1, #self.tempArray do
    self:DestoryChild(self.tempArray[i], nil, keepMask)
  end
  _ArrayClear(self.tempArray)
  if not keepMask then
    self:HideMask()
  end
  if self.stack then
    self.stack:Clear()
  end
end

function UILayer:CanNodeDestroy(newNode, node)
  if newNode ~= node and newNode:CanCoExist(node) then
    return false
  end
  return true
end

function UILayer:InitShowHideModeCall()
  self.ShowCallByMode = {}
  self.ShowCallByMode[PanelShowHideMode.CreateAndDestroy] = self.ModeCreateShow
  self.ShowCallByMode[PanelShowHideMode.ActiveAndDeactive] = self.ModeActiveShow
  self.ShowCallByMode[PanelShowHideMode.MoveOutAndMoveIn] = self.ModeMoveInShow
  self.HideCallByMode = {}
  self.HideCallByMode[PanelShowHideMode.CreateAndDestroy] = self.ModeDestroyHide
  self.HideCallByMode[PanelShowHideMode.ActiveAndDeactive] = self.ModeDeActiveHide
  self.HideCallByMode[PanelShowHideMode.MoveOutAndMoveIn] = self.ModeMoveOutHide
end

function UILayer:ModeShow(node)
  if node then
    local func = self.ShowCallByMode[node:GetShowHideMode()]
    if func == nil then
      func = self.ModeCreateShow
    end
    if func then
      func(self, node)
    end
  end
end

function UILayer:ModeHide(node)
  if node then
    local func = self.HideCallByMode[node:GetShowHideMode()]
    if func == nil then
      func = self.ModeDestroyHide
    end
    if func then
      func(self, node)
    end
  end
end

function UILayer:ModeCreateShow(node)
  if not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    node.gameObject.transform:SetParent(self.gameObject.transform, false)
  end
end

function UILayer:ModeActiveShow(node)
  if not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    if node.gameObject.transform.parent ~= self.gameObject.transform then
      node.gameObject.transform:SetParent(self.gameObject.transform, false)
    end
    if node:MediatorReActive() then
      node:RegisterMediator()
    end
    node:Show()
  end
end

function UILayer:ModeMoveInShow(node)
  if not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    if node.gameObject.transform.parent ~= self.gameObject.transform then
      node.gameObject.transform:SetParent(self.gameObject.transform, false)
    end
    if node:MediatorReActive() then
      node:RegisterMediator()
    end
    node.gameObject.transform.localPosition = UILayer.ShowPos
    node:ActivePanelUpdate(true)
  end
end

function UILayer:ModeDestroyHide(node)
  node:Dispose()
end

function UILayer:ModeDeActiveHide(node)
  if not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    self.cachedNode[node.viewClass.__cname] = node
    node:Hide()
    if node:MediatorReActive() then
      node:UnRegisterMediator()
    end
  end
end

function UILayer:ModeMoveOutHide(node)
  if not Game.GameObjectUtil:ObjectIsNULL(node.gameObject) then
    self.cachedNode[node.viewClass.__cname] = node
    node.gameObject.transform.localPosition = UILayer.HidePos
    node:ActivePanelUpdate(false)
    if node:MediatorReActive() then
      node:UnRegisterMediator()
    end
  end
end

function UILayer:DisposeCachedNodeByShowHideMode(showHideMode)
  for name, node in pairs(self.cachedNode) do
    if node:GetShowHideMode() == showHideMode then
      node:Dispose()
      self.cachedNode[name] = nil
    end
  end
end

function UILayer:Dispose()
  for i = 1, #self.nodes do
    self.nodes[i]:Dispose()
  end
  GameObject.Destroy(self.gameObject)
  TableUtility.TableClear(self)
end

function UILayer:GetEscNodeCount()
  local retCount = 0
  for i = 1, #self.nodes do
    local node = self.nodes[i]
    if node.data and node.data.view and node.data.view.forbidesc then
    else
      retCount = retCount + 1
    end
  end
  return retCount
end

function UILayer:TryPopNode()
  local nodeCount = #self.nodes
  if nodeCount == 0 then
    return false
  end
  local retNode
  for i = nodeCount, 1, -1 do
    node = self.nodes[i]
    if node.data and node.data.view and node.data.view.forbidesc then
    else
      retNode = node
    end
  end
  if not retNode then
    return false
  end
  if retNode:CustomExit() then
  else
    self:DestoryChild(retNode)
    self:TryRollBackPrevious()
  end
  return true
end
