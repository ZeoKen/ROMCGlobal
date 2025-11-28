AierBlacksmithRewardListPopUp = class("AierBlacksmithRewardListPopUp", SubView)
autoImport("AierBlacksmithRewardLevelCell")

function AierBlacksmithRewardListPopUp:Init()
  xdlog("AierBlacksmithRewardListPopUp")
  self:ReLoadPerferb("view/AierBlacksmithRewardListPopUp")
  self.trans:SetParent(self.container.rewardPopupContainer.transform, false)
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end

function AierBlacksmithRewardListPopUp:FindObjs()
  self.scrollView = self:FindComponent("LevelScrollView", UIScrollView)
  self.levelTable = self:FindGO("LevelTable"):GetComponent(UITable)
  self.levelGridCtrl = UIGridListCtrl.new(self.levelTable, AierBlacksmithRewardLevelCell, "AierBlacksmithRewardLevelCell")
  self.panel = self.scrollView.panel
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
end

function AierBlacksmithRewardListPopUp:InitData()
  self:RefreshPage()
end

function AierBlacksmithRewardListPopUp:InitShow()
end

function AierBlacksmithRewardListPopUp:RefreshPage()
  local sss = {}
  local maxLevel = #Table_SmithLevel
  for i = 1, maxLevel do
    sss[#sss + 1] = Table_SmithLevel[i]
  end
  self.levelGridCtrl:ResetDatas(sss)
  self:AdjustScrollView()
end

function AierBlacksmithRewardListPopUp:AddEvts()
end

function AierBlacksmithRewardListPopUp:AddMapEvts()
end

function AierBlacksmithRewardListPopUp:UpdatePage()
end

function AierBlacksmithRewardListPopUp:ReUnitData(datas)
end

function AierBlacksmithRewardListPopUp:OnActivate()
  self:UpdatePage()
end

function AierBlacksmithRewardListPopUp:SetActive(bool)
  if bool then
    self:Show()
  else
    self:Hide()
  end
end

function AierBlacksmithRewardListPopUp:OnMouseClick(data)
end

function AierBlacksmithRewardListPopUp:AdjustScrollView()
  self.scrollView:ResetPosition()
  local cells = self.levelGridCtrl:GetCells()
  local targetCell
  for i = 1, #cells do
    local cell = cells[i]
    if not cell:CheckIsFinish() then
      if not targetCell then
        targetCell = cell
      elseif targetCell.sortOrder > cell.sortOrder then
        targetCell = cell
      end
    end
  end
  if not targetCell then
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.panel.cachedTransform, targetCell.gameObject.transform)
  local offset = self.panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollView:MoveRelative(offset)
end
