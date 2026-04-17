autoImport("SnowCrownAreaAttrCell")
SnowCrownAreaAttrPage = class("SnowCrownAreaAttrPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("SnowCrownAreaAttrPage")

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
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32652, helpBtn)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
end

function SnowCrownAreaAttrPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, self.OnSnowDataUpdate)
end

function SnowCrownAreaAttrPage:OnSnowDataUpdate()
  local oldLevels = {}
  if self.attrCells then
    for i, cell in ipairs(self.attrCells) do
      if cell.data then
        oldLevels[i] = cell.data.level or 0
      else
        oldLevels[i] = 0
      end
    end
  end
  self:RefreshView()
  if self.attrCells then
    for i, cell in ipairs(self.attrCells) do
      local newLevel = cell.data and cell.data.level or 0
      local oldLevel = oldLevels[i] or 0
      if newLevel > oldLevel then
        self:PlayLevelUpEffect(cell)
      end
    end
  end
end

function SnowCrownAreaAttrPage:PlayLevelUpEffect(cell)
  if cell and cell.gameObject then
    self:PlayUIEffect(EffectMap.UI.SnowGem_AreaAttrLevelUp, cell.gameObject, true)
  end
end

function SnowCrownAreaAttrPage:OnEnter()
  self:RefreshView()
end

function SnowCrownAreaAttrPage:OnExit()
  self:OnHideAttrTip()
end

function SnowCrownAreaAttrPage:RefreshView()
  self:OnHideAttrTip()
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
  for i = 1, #self.attrCells do
    local cell = self.attrCells[i]
    cell:SetData(datas[i], i)
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
      MsgManager.ShowMsgByID(43689)
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
