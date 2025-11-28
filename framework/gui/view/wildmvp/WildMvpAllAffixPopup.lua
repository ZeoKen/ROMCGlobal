autoImport("CollapseTreeCell")
autoImport("WildMvpAffixBriefCell")
WildMvpAllAffixPopup = class("WildMvpAllAffixPopup", BaseView)
WildMvpAllAffixPopup.ViewType = UIViewType.PopUpLayer

function WildMvpAllAffixPopup:Init()
  self:FindObjs()
  self:UpdateView()
end

function WildMvpAllAffixPopup:FindObjs()
  local closeBtnGO = self:FindGO("BtnClose")
  self:AddClickEvent(closeBtnGO, function()
    self:OnCloseClicked()
  end)
  local contentGO = self:FindGO("Content")
  local contentTable = self:FindComponent("Container", UITable, contentGO)
  self.scrollView = self:FindComponent("ContentScroll", UIScrollView, contentGO)
  self.contentCtrl = ListCtrl.new(contentTable, CollapseTreeCell, "WildMvp/WildMvpAffixGroupCell")
  self.contentCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.contentCtrl:AddEventListener(UICellEvent.OnCollapseFinished, self.OnCellCollapseFinished, self)
end

local tempVec3 = LuaVector3.New(0, 0.002, 0)

function WildMvpAllAffixPopup:OnCellCollapseFinished(cell)
  self.scrollView:MoveRelative(tempVec3)
  self.scrollView:RestrictWithinBounds(true)
end

function WildMvpAllAffixPopup:OnCellClicked(cell)
  if self.selectedCell ~= cell then
    if self.selectedCell then
      self.selectedCell:StopScroll(true)
    end
    self.selectedCell = cell
    if self.selectedCell then
      self.selectedCell:StartScroll(true)
    end
  end
end

function WildMvpAllAffixPopup:UpdateView()
  local datas = self.viewdata.viewdata.AffixData
  if datas then
    for _, v in ipairs(datas) do
      v.cellPrefab = "WildMvp/WildMvpAffixBriefCell"
      v.cellCtrl = WildMvpAffixBriefCell
      v.contentBgPadding = 46
    end
    self.contentCtrl:ResetDatas(datas)
  end
end

function WildMvpAllAffixPopup:OnCloseClicked()
  self:CloseSelf()
end
