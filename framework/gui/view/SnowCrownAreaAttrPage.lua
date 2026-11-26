autoImport("SnowCrownAreaAttrCell")
SnowCrownAreaAttrPage = class("SnowCrownAreaAttrPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("SnowCrownAreaAttrPage")
local InnerTabNamePrefix = "SnowCrownAreaAttrPage_TabName_"
local InnerTabCheckName = "Checkmark"
local InnerTabCount = 2
local InnerTabArea = 1
local InnerTabGlobal = 2
local CircleCount = 3
local CircleNamePrefix = "SnowCrownAreaAttrPage_CircleName_"
local CircleRowLockName = "Lock"
local CircleRowDotLineName = "DotLine"
local LockedLabelColor = Color(0.6470588235294118, 0.6470588235294118, 0.6470588235294118, 1)
local StageLockedMsgIDs = {
  [1] = 43672,
  [2] = 43673,
  [3] = 43674
}
local LockedMsgID = 43689
SnowCrownAreaAttrPage.GlobalAttrsName = nil
SnowCrownAreaAttrPage.GlobalRingLayout = nil
SnowCrownAreaAttrPage.LineChordPadding = 1.04
SnowCrownAreaAttrPage.RingLayout = {
  CenterX = -5.1,
  CenterY = -31.0,
  Radius = 257.2
}

function SnowCrownAreaAttrPage:LayoutRingNodes(nodes, opt)
  local count = nodes and #nodes or 0
  if count < 3 then
    xdlog("SnowCrownAreaAttrPage:LayoutRingNodes skipped | count=", count)
    return
  end
  local cfg = SnowCrownAreaAttrPage.RingLayout
  opt = opt or {}
  local cx = opt.CenterX or cfg.CenterX
  local cy = opt.CenterY or cfg.CenterY
  local radius = opt.Radius or cfg.Radius
  local startAngle = opt.StartAngle or 90 + 180 / count
  local lineName = opt.LineName or "Line"
  local step = 360 / count
  local chord = 2 * radius * math.sin(math.pi / count)
  local lineWidth = opt.LineWidth or chord * SnowCrownAreaAttrPage.LineChordPadding
  for i = 1, count do
    local go = nodes[i]
    if go then
      local angle = math.rad(startAngle + (i - 1) * step)
      LuaGameObject.SetLocalPositionGO(go, cx + radius * math.cos(angle), cy + radius * math.sin(angle), 0)
      local line = self:FindGO(lineName, go)
      if line then
        line.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, startAngle + (i - 1) * step + step * 0.5 - 90)
        if opt.SyncLineWidth ~= false then
          local lineSprite = line:GetComponent(UISprite)
          if lineSprite then
            lineSprite.width = lineWidth
          end
        end
      end
    end
  end
end

function SnowCrownAreaAttrPage:LayoutCellsWithData(cells, datas, ringOpt)
  local nodes = {}
  if not cells then
    return nodes
  end
  datas = datas or {}
  for i = 1, #cells do
    local cell = cells[i]
    local data = datas[i]
    if data then
      cell.gameObject:SetActive(true)
      cell:SetData(data, i)
      nodes[#nodes + 1] = cell.gameObject
    else
      cell:SetData(nil, i)
      cell.gameObject:SetActive(false)
    end
  end
  self:LayoutRingNodes(nodes, ringOpt)
  return nodes
end

function SnowCrownAreaAttrPage:Init()
  self:LoadPrefab()
  self:FindObjs()
  self:AddListenEvts()
end

function SnowCrownAreaAttrPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "SnowCrownAreaAttrPage"
  self.gameObject = obj
end

function SnowCrownAreaAttrPage:FindObjs()
  self.attrCells = {}
  for i = 1, 9 do
    local go = self:FindGO("Attr" .. i)
    if go then
      local cell = SnowCrownAreaAttrCell.new(go)
      cell:AddEventListener(MouseEvent.MouseClick, self.OnAttrCellClick, self)
      table.insert(self.attrCells, cell)
      if i == 1 then
        self:AddOrRemoveGuideId(go, 559)
      end
    end
  end
  self.helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32652, self.helpBtn)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self:InitInnerTabs()
  self:InitTabsRoot()
end

function SnowCrownAreaAttrPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, self.OnSnowDataUpdate)
end

function SnowCrownAreaAttrPage:SetVisible(go, visible)
  if go then
    go:SetActive(visible and true or false)
  end
end

function SnowCrownAreaAttrPage:InitInnerTabs()
  self.innerTabs = self:FindGO("InnerTabs")
  self.innerTabMap = {}
  if not self.innerTabs then
    LogUtility.Error("SnowCrownAreaAttrPage: Cannot find InnerTabs!")
    return
  end
  for i = 1, InnerTabCount do
    local tabGO = self:FindGO("Tab" .. i, self.innerTabs)
    if tabGO then
      self:SetTabLabelText(tabGO, InnerTabCheckName, ZhString[InnerTabNamePrefix .. "Tab" .. i])
      self:AddClickEvent(tabGO, function()
        self:SwitchInnerTab(i)
      end)
      self.innerTabMap[i] = tabGO
    else
      LogUtility.Error("SnowCrownAreaAttrPage: Cannot find InnerTabs/Tab" .. i)
    end
  end
  self:SetVisible(self:FindGO("BackBtn"), false)
  self:SetVisible(self:FindGO("AllFieldBtn"), false)
end

function SnowCrownAreaAttrPage:SetTabLabelText(tabGO, checkName, text)
  if not tabGO or not text then
    return
  end
  local trans = tabGO.transform
  for i = 0, trans.childCount - 1 do
    local child = trans:GetChild(i)
    local label = child:GetComponent(UILabel)
    if not label and child.name == checkName then
      label = Game.GameObjectUtil:DeepFindComponent(child.gameObject, UILabel, "Label")
    end
    if label then
      label.text = text
    end
  end
end

function SnowCrownAreaAttrPage:SetTabSelected(tabGO, checkName, selected)
  if not tabGO then
    return
  end
  local toggle = tabGO:GetComponent(UIToggle)
  if toggle then
    toggle.value = selected
  end
  local check = self:FindGO(checkName, tabGO)
  if check then
    check:SetActive(selected)
  end
end

function SnowCrownAreaAttrPage:SwitchInnerTab(index, forceRefresh)
  if not index then
    return
  end
  if self.currentInnerTab == index and not forceRefresh then
    return
  end
  self.currentInnerTab = index
  self.isGlobalMode = index == InnerTabGlobal
  SnowCrownProxy.Instance:SetInnerTab(index)
  self:OnHideAttrTip()
  for i, tabGO in pairs(self.innerTabMap) do
    self:SetTabSelected(tabGO, InnerTabCheckName, i == index)
  end
  if self.isGlobalMode then
    self:SetGlobalCellsVisible(true)
    self:EnterGlobalMode()
  else
    self:SetTabsExpanded(false)
    self:SetVisible(self.tabsRoot, false)
    self:SetGlobalCellsVisible(false)
    self:RefreshView()
  end
end

function SnowCrownAreaAttrPage:EnterGlobalMode()
  self:SetVisible(self.tabsRoot, true)
  local firstUnlocked
  local unlockedCount = 0
  for i = 1, CircleCount do
    if SnowCrownProxy.Instance:IsGlobalCircleUnlocked(i) then
      unlockedCount = unlockedCount + 1
      firstUnlocked = firstUnlocked or i
    end
  end
  if unlockedCount == 0 then
    self.currentCircle = self.currentCircle or 1
    SnowCrownProxy.Instance:SetGlobalCircle(self.currentCircle)
    self:RefreshCurLabel()
    self:RefreshTabsGridRows()
    self:RefreshGlobalView()
    return
  end
  local circle = firstUnlocked
  local remembered = SnowCrownProxy.Instance:GetGlobalCircle()
  if remembered and remembered <= CircleCount and SnowCrownProxy.Instance:IsGlobalCircleUnlocked(remembered) then
    circle = remembered
  end
  if not SnowCrownProxy.Instance:IsGlobalFirstEnterHandled() then
    SnowCrownProxy.Instance:MarkGlobalFirstEnterHandled()
    if SnowCrownProxy.Instance:IsGlobalCircleMaxed(circle) then
      local nextCircle = circle + 1
      if nextCircle <= CircleCount and SnowCrownProxy.Instance:IsGlobalCircleUnlocked(nextCircle) then
        circle = nextCircle
      end
    end
  end
  self:SwitchCircle(circle, true)
end

function SnowCrownAreaAttrPage:GetActiveCells()
  if self.isGlobalMode then
    return self.globalCells or {}
  end
  return self.attrCells or {}
end

function SnowCrownAreaAttrPage:InitTabsRoot()
  self.tabsRoot = self:FindGO("TabsRoot")
  self.circleRows = {}
  if not self.tabsRoot then
    LogUtility.Error("SnowCrownAreaAttrPage: Cannot find TabsRoot!")
    return
  end
  self.curLabel = self:FindComponent("CurLabel", UILabel, self.tabsRoot)
  self.tabsBG = self:FindGO("TabBG", self.tabsRoot)
  self.arrow = self:FindGO("Arrow", self.tabsRoot)
  self.tabsGrid = self:FindGO("TabsGrid", self.tabsRoot)
  if not self.tabsGrid then
    LogUtility.Error("SnowCrownAreaAttrPage: Cannot find TabsRoot/TabsGrid!")
    return
  end
  self.tabsGridComp = self.tabsGrid:GetComponent(UIGrid)
  if self.tabsGridComp then
    self.tabsGridComp.hideInactive = true
  end
  local trans = self.tabsGrid.transform
  for k = 0, trans.childCount - 1 do
    local rowGO = trans:GetChild(k).gameObject
    local index = tonumber(string.match(rowGO.name, "^Tab(%d+)$"))
    if index then
      do
        local label = self:FindComponent("Label", UILabel, rowGO)
        local text = ZhString[CircleNamePrefix .. "Tab" .. index]
        if label and text then
          label.text = text
        end
        local labelColor
        if label then
          local c = label.color
          if c then
            labelColor = Color(c.r, c.g, c.b, c.a)
          end
        end
        self:AddClickEvent(rowGO, function()
          self:SwitchCircle(index)
        end)
        self.circleRows[#self.circleRows + 1] = {
          index = index,
          gameObject = rowGO,
          label = label,
          labelColor = labelColor,
          lock = self:FindGO(CircleRowLockName, rowGO),
          dotLine = self:FindGO(CircleRowDotLineName, rowGO)
        }
      end
    end
  end
  self:AddClickEvent(self.tabsRoot, function()
    self:SetTabsExpanded(not self.tabsExpanded)
  end)
  self:SetTabsExpanded(false)
end

function SnowCrownAreaAttrPage:SetTabsExpanded(expanded)
  self.tabsExpanded = expanded and true or false
  self:SetVisible(self.tabsBG, self.tabsExpanded)
  self:SetVisible(self.tabsGrid, self.tabsExpanded)
  if self.arrow then
    self.arrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, self.tabsExpanded and 90 or -90)
  end
  if self.tabsExpanded then
    self:RefreshTabsGridRows()
  end
end

function SnowCrownAreaAttrPage:RefreshTabsGridRows()
  local current = self.currentCircle or 1
  local lastVisible
  for i = 1, #self.circleRows do
    local row = self.circleRows[i]
    local unlocked = SnowCrownProxy.Instance:IsGlobalCircleUnlocked(row.index)
    local visible = row.index ~= current
    row.gameObject:SetActive(visible)
    if row.lock then
      row.lock:SetActive(not unlocked)
    end
    if row.label then
      if unlocked then
        if row.labelColor then
          row.label.color = row.labelColor
        end
      else
        row.label.color = LockedLabelColor
      end
    end
    if row.dotLine then
      row.dotLine:SetActive(visible)
    end
    if visible then
      lastVisible = row
    end
  end
  if lastVisible and lastVisible.dotLine then
    lastVisible.dotLine:SetActive(false)
  end
  if self.tabsGridComp then
    self.tabsGridComp:Reposition()
  end
end

function SnowCrownAreaAttrPage:RefreshCurLabel()
  if not self.curLabel then
    return
  end
  local text = ZhString[CircleNamePrefix .. "Tab" .. (self.currentCircle or 1)]
  if text then
    self.curLabel.text = text
  end
end

function SnowCrownAreaAttrPage:SwitchCircle(circle, forceRefresh)
  if not circle then
    return
  end
  if self.currentCircle == circle and not forceRefresh then
    self:SetTabsExpanded(false)
    return
  end
  if not SnowCrownProxy.Instance:IsGlobalCircleUnlocked(circle) then
    MsgManager.ShowMsgByID(StageLockedMsgIDs[circle] or LockedMsgID)
    self:RefreshTabsGridRows()
    return
  end
  self.currentCircle = circle
  SnowCrownProxy.Instance:SetGlobalCircle(circle)
  self:OnHideAttrTip()
  self:RefreshCurLabel()
  self:SetTabsExpanded(false)
  self:RefreshTabsGridRows()
  self:RefreshGlobalView()
  self:PlayGemsSwitchEffect()
end

function SnowCrownAreaAttrPage:PlayGemsSwitchEffect()
  local cells = self:GetActiveCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    if cell and cell.gameObject and cell.gameObject.activeSelf then
      self:PlayUIEffect(EffectMap.UI.GemSkillEmbed, cell.gameObject, true)
    end
  end
end

function SnowCrownAreaAttrPage:GetGlobalCells()
  if self.globalCells then
    return self.globalCells
  end
  local cells = {}
  local root = self.gameObject
  local container
  if SnowCrownAreaAttrPage.GlobalAttrsName and SnowCrownAreaAttrPage.GlobalAttrsName ~= "" then
    container = self:FindGO(SnowCrownAreaAttrPage.GlobalAttrsName, root)
  end
  if container then
    local i = 1
    while true do
      local go = self:FindGO("Attr" .. i, container)
      if not go then
        break
      end
      local cell = SnowCrownAreaAttrCell.new(go)
      cell:AddEventListener(MouseEvent.MouseClick, self.OnAttrCellClick, self)
      cells[#cells + 1] = cell
      i = i + 1
    end
    self.globalDedicated = true
  else
    cells = self.attrCells
    self.globalDedicated = false
  end
  self.globalCells = cells
  return cells
end

function SnowCrownAreaAttrPage:SetGlobalCellsVisible(visible)
  if not self.globalDedicated then
    return
  end
  local attrs = self:FindGO("Attrs", self.gameObject)
  if attrs then
    attrs:SetActive(not visible)
  end
  local root = self:FindGO(SnowCrownAreaAttrPage.GlobalAttrsName, self.gameObject)
  if root then
    root:SetActive(visible)
  end
end

function SnowCrownAreaAttrPage:RefreshGlobalView()
  local circle = self.currentCircle or 1
  local cells = self:GetGlobalCells()
  if not cells or #cells == 0 then
    return
  end
  self:RefreshTabsGridRows()
  local slots = SnowCrownProxy.Instance:GetGlobalSlotList(circle)
  local datas = {}
  for i = 1, #slots do
    datas[#datas + 1] = SnowCrownProxy.Instance:GetGlobalSlotData(circle, slots[i].slot)
  end
  self:LayoutCellsWithData(cells, datas, SnowCrownAreaAttrPage.GlobalRingLayout)
  self:RefreshOpenAttrTip()
end

function SnowCrownAreaAttrPage:OnSnowDataUpdate()
  local cells = self:GetActiveCells()
  local oldLevels = {}
  for i, cell in ipairs(cells) do
    if cell.data then
      oldLevels[i] = cell.data.level or 0
    else
      oldLevels[i] = 0
    end
  end
  if self.isGlobalMode then
    self:RefreshGlobalView()
  else
    self:RefreshView()
  end
  for i, cell in ipairs(cells) do
    local newLevel = cell.data and cell.data.level or 0
    local oldLevel = oldLevels[i] or 0
    if newLevel > oldLevel then
      self:PlayLevelUpEffect(cell)
    end
  end
end

function SnowCrownAreaAttrPage:PlayLevelUpEffect(cell)
  if cell and cell.gameObject then
    self:PlayUIEffect(EffectMap.UI.SnowGem_AreaAttrLevelUp, cell.gameObject, true)
  end
end

function SnowCrownAreaAttrPage:OnEnter()
  local index = SnowCrownProxy.Instance:GetInnerTab()
  if index ~= InnerTabArea and index ~= InnerTabGlobal then
    index = InnerTabArea
  end
  self:SwitchInnerTab(index, true)
end

function SnowCrownAreaAttrPage:OnExit()
  self:OnHideAttrTip()
end

function SnowCrownAreaAttrPage:RefreshView()
  local datas = {}
  local batch = SnowCrownProxy.Instance:GetCurrentBatch()
  for _, groupIds in pairs(Game.SnowCrown) do
    for i = 1, #groupIds do
      local groupId = groupIds[i]
      local id = SnowCrownProxy.Instance:GetCrownIdByGroupId(groupId)
      local data = {}
      data.id = id
      local staticData = Table_SnowCrown[id]
      if not staticData then
        staticData = Table_SnowCrown[groupId * 100 + 1]
        data.level = 0
      else
        data.level = staticData.Level
      end
      data.staticData = staticData
      data.isLock = batch < staticData.Batch
      datas[#datas + 1] = data
    end
  end
  table.sort(datas, function(a, b)
    local groupA = a.id // 100
    local groupB = b.id // 100
    return groupA < groupB
  end)
  self:LayoutCellsWithData(self.attrCells, datas, SnowCrownAreaAttrPage.RingLayout)
  self:RefreshOpenAttrTip()
end

function SnowCrownAreaAttrPage:RefreshOpenAttrTip()
  if self.currentTip and self.selectCell and self.selectCell.data then
    self.currentTip:RefreshData(self.selectCell.data)
  end
end

function SnowCrownAreaAttrPage:OnAttrCellClick(cell)
  if cell.data then
    if not cell.data.isLock then
      self:OnHideAttrTip()
      local side = NGUIUtil.AnchorSide.TopRight
      local offset = {170, 0}
      if cell.index > 5 then
        side = NGUIUtil.AnchorSide.TopLeft
        offset = {-170, 0}
      end
      self.currentTip = TipManager.Instance:ShowSnowCrownAttrTip(cell.data, self.tipStick, side, offset)
      self.currentTip:AddEventListener(UIEvent.CloseUI, self.OnHideAttrTip, self)
    else
      local stage = cell.data.staticData and cell.data.staticData.Batch or 1
      MsgManager.ShowMsgByID(StageLockedMsgIDs[stage] or LockedMsgID)
    end
  end
  self:SelectAttrCell(cell)
end

function SnowCrownAreaAttrPage:OnHideAttrTip()
  if self.currentTip then
    TipsView.Me():HideCurrent()
    self.currentTip = nil
  end
  self:SelectAttrCell()
end

function SnowCrownAreaAttrPage:SelectAttrCell(cell)
  if self.selectCell ~= cell then
    if self.selectCell then
      self.selectCell:SetSelect(false)
    end
    self.selectCell = cell
    if self.selectCell then
      self.selectCell:SetSelect(true)
    end
  end
end
