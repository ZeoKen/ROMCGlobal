autoImport("CrownTotalAttrCell")
SnowCrownCollectAttrPopup = class("SnowCrownCollectAttrPopup", BaseView)
SnowCrownCollectAttrPopup.ViewType = UIViewType.PopUpLayer

function SnowCrownCollectAttrPopup:Init()
  self:InitView()
  self:InitData()
  self:RefreshShow()
end

function SnowCrownCollectAttrPopup:InitView()
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.closeBordBtn = self:FindGO("CloseBordBtn")
  if self.closeBordBtn then
    self:AddClickEvent(self.closeBordBtn, function()
      self:CloseSelf()
    end)
  end
  self.profitScrollView = self:FindComponent("ProfitScrollView", UIScrollView)
  self.profitGrid = self:FindComponent("ProfitGrid", UITable)
  if self.profitGrid then
    self.profitAttrListCtrl = UIGridListCtrl.new(self.profitGrid, CrownTotalAttrCell, "CrownTotalAttrCellType2")
  end
  self.noneTip = self:FindGO("NoneTip")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  if self.closecomp then
    function self.closecomp.callBack()
      self:CloseSelf()
    end
  end
end

function SnowCrownCollectAttrPopup:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.attrList = viewdata and viewdata.attrList or {}
  local title = viewdata and viewdata.title
  if title and self.titleLabel then
    self.titleLabel.text = title
  end
end

function SnowCrownCollectAttrPopup:RefreshShow()
  if not self.profitAttrListCtrl then
    return
  end
  local attrDataList = {}
  for _, attrInfo in ipairs(self.attrList) do
    local propConfig = Game.Config_PropName and Game.Config_PropName[attrInfo.name]
    table.insert(attrDataList, {
      varName = attrInfo.name,
      value = attrInfo.value,
      propConfig = propConfig
    })
  end
  self.profitAttrListCtrl:ResetDatas(attrDataList)
  self.noneTip:SetActive(#attrDataList == 0)
  if self.profitScrollView then
    self.profitScrollView:ResetPosition()
  end
end
