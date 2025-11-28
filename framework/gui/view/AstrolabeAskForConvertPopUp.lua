AstrolabeAskForConvertPopUp = class("AstrolabeAskForConvertPopUp", BaseView)
AstrolabeAskForConvertPopUp.ViewType = UIViewType.PopUpLayer

function AstrolabeAskForConvertPopUp:Init()
  self:AddButtonEvent("ConfirmBtn", function()
    if self.confirmFunc then
      self.confirmFunc()
    end
    self:CloseSelf()
  end)
  local grid = self:FindComponent("ConvertGrid", UIGrid)
  self.ctl = UIGridListCtrl.new(grid, AstrolabeMaterilaCell, "AstrolabeMaterilaCell")
end

function AstrolabeAskForConvertPopUp:OnEnter()
  AstrolabeAskForConvertPopUp.super.OnEnter(self)
  local viewData = self.viewdata.viewdata
  if not viewData or not viewData.convert then
    self:CloseSelf()
    return
  end
  self.confirmFunc = viewData.confirmFunc
  self:UpdateConvert(viewData.convert)
end

local data = {}
local addReusableDataElement = function(id, num)
  num = num or 0
  local t = ReusableTable.CreateArray()
  TableUtility.ArrayPushBack(t, id)
  TableUtility.ArrayPushBack(t, num)
  TableUtility.ArrayPushBack(data, t)
end
local clearData = function()
  for _, t in pairs(data) do
    ReusableTable.DestroyAndClearArray(t)
  end
  TableUtility.TableClear(data)
end

function AstrolabeAskForConvertPopUp:UpdateConvert(convertData)
  local contribute, goldMedal = convertData[AstrolabeProxy.ContributeItemId], convertData[AstrolabeProxy.GoldMedalItemId]
  if contribute and 0 < contribute then
    addReusableDataElement(AstrolabeProxy.ContributeItemId, contribute)
    addReusableDataElement(AstrolabeProxy.BindedContributeItemId, contribute)
  end
  if goldMedal and 0 < goldMedal then
    addReusableDataElement(AstrolabeProxy.GoldMedalItemId, goldMedal)
    addReusableDataElement(AstrolabeProxy.BindedGoldMedalItemId, goldMedal)
  end
  self.ctl:ResetDatas(data)
  clearData()
  local cells = self.ctl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetLabelColor(ColorUtil.NGUIDeepGray)
    cell:SetIconSize(48)
  end
end
