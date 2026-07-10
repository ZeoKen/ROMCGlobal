autoImport("SnowGemRewardCell")
SnowGemRewardPopup = class("SnowGemRewardPopup", BaseView)
SnowGemRewardPopup.ViewType = UIViewType.PopUpLayer

function SnowGemRewardPopup:Init()
  self:FindObjs()
  self:AddEvents()
end

function SnowGemRewardPopup:FindObjs()
  self.bg = self:FindGO("Mask")
  if self.bg then
    self:AddClickEvent(self.bg, function()
      self:CloseSelf()
    end)
  end
  self.mainPanel = self:FindGO("SnowGemRewardPopup")
  self.titleLabel = self:FindComponent("Label", UILabel, self.mainPanel)
  self.texture = self:FindComponent("Texture", UITexture, self.mainPanel)
  local scrollView = self:FindGO("ScrollView", self.mainPanel)
  if scrollView then
    self.scrollView = scrollView:GetComponent(UIScrollView)
    local table = self:FindGO("Table", scrollView)
    if table then
      self.uiTable = table:GetComponent(UITable)
      self.listCtrl = UIGridListCtrl.new(self.uiTable, SnowGemRewardCell, "SnowGemRewardCell")
      self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClick, self)
    end
  end
end

function SnowGemRewardPopup:AddEvents()
end

function SnowGemRewardPopup:OnCellClick(cellCtl)
  xdlog("OnCellClick", cellCtl.data.stoneId)
  if not cellCtl or not cellCtl.data then
    return
  end
  local stoneId = cellCtl.data.stoneId
  if not stoneId then
    return
  end
  local itemData = ItemData.new(stoneId, stoneId)
  if itemData then
    local tipData = {itemdata = itemData, hideGetPath = true}
    self:ShowItemTip(tipData, cellCtl.widget, NGUIUtil.AnchorSide.Right, {0, 0})
  end
end

function SnowGemRewardPopup:OnEnter()
  if TipManager.Instance then
    TipManager.Instance:CloseItemTip()
  end
  self:RefreshView()
  self:PlayUIEffect(EffectMap.UI.SnowGem_Reward, self.gameObject)
end

function SnowGemRewardPopup:OnExit()
end

function SnowGemRewardPopup:RefreshView()
  local viewData = self.viewdata and self.viewdata.viewdata
  if not viewData then
    return
  end
  local progressChanges = viewData.progressChanges or {}
  local overflowChanges = viewData.overflowChanges or {}
  local allData = {}
  for _, data in ipairs(progressChanges) do
    data.cellType = SnowGemRewardCell.CellType.Progress
    table.insert(allData, data)
  end
  for _, data in ipairs(overflowChanges) do
    data.cellType = SnowGemRewardCell.CellType.Overflow
    table.insert(allData, data)
  end
  if self.listCtrl then
    self.listCtrl:ResetDatas(allData)
  end
  if self.uiTable then
    self.uiTable:Reposition()
  end
  if self.scrollView and self.uiTable then
    local panel = self.scrollView.panel
    if panel then
      local bounds = NGUIMath.CalculateRelativeWidgetBounds(self.uiTable.transform)
      local contentWidth = bounds and bounds.size and bounds.size.x or 0
      local viewWidth = panel.baseClipRegion and panel.baseClipRegion.z or 0
      if contentWidth > viewWidth then
        self.scrollView.contentPivot = UIWidget.Pivot.TopLeft
      else
        self.scrollView.contentPivot = UIWidget.Pivot.Top
      end
    end
  end
  if self.scrollView then
    self.scrollView:ResetPosition()
  end
end
