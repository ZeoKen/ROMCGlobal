autoImport("EquipChooseBord")
autoImport("EquipNewChooseCell")
EquipNewChooseBord = class("EquipNewChooseBord", EquipChooseBord)
EquipNewChooseBord.CellControl = EquipNewChooseCell
EquipNewChooseBord.PfbPath = "part/EquipNewChooseBord"
EquipNewChooseBord.CellPfbName = "EquipNewChooseCell"

function EquipNewChooseBord:InitBord()
  EquipNewChooseBord.super.InitBord(self)
  self.posTween = self.gameObject:GetComponent(TweenPosition)
  if self.posTween then
    self:SetTweenActive(false)
  end
  
  function self.tipData.callback()
    self.clickId = 0
    self:UpdateItemIconChoose()
  end
end

function EquipNewChooseBord:ResetDatas(datas, resetPos)
  EquipNewChooseBord.super.ResetDatas(self, datas, resetPos)
  self:_OnFilterPopChange(resetPos)
end

function EquipNewChooseBord:ResetFilter()
  if not self.filterPop then
    return
  end
  self.filterPop.value = self.textForAll
  self:_OnFilterPopChange()
end

function EquipNewChooseBord:Show(...)
  EquipNewChooseBord.super.Show(self, ...)
  self:TryPlayPosTween()
end

function EquipNewChooseBord:Hide()
  self:TryPlayPosTween(false, function()
    EquipNewChooseBord.super.Hide(self)
  end)
end

function EquipNewChooseBord:SetTweenActive(isActive)
  if not self.posTween then
    return
  end
  self.tweenActive = isActive and true or false
  if self.posTween.amountPerDelta > 0 then
    self.posTween:Sample(1, true)
  elseif self.posTween.amountPerDelta < 0 then
    self.posTween:Sample(0, true)
  end
  self.posTween.enabled = self.tweenActive
end

local _tweenPlay = function(tween, isForward)
  if isForward ~= false then
    tween:PlayForward()
  else
    tween:PlayReverse()
  end
end

function EquipNewChooseBord:TryPlayPosTween(isForward, onFinished)
  if not self.posTween or not self.tweenActive then
    if onFinished then
      onFinished()
    end
    return
  end
  _tweenPlay(self.posTween, isForward)
  self.posTween:ResetToBeginning()
  self.posTween:SetOnFinished(onFinished)
  _tweenPlay(self.posTween, isForward)
end

function EquipNewChooseBord:IsTweenPlaying()
  if not self.posTween then
    return false
  end
  local f = self.posTween.tweenFactor
  return 0.15 < f and f < 0.85
end

function EquipNewChooseBord:HandleClickItem(cellctl)
  if self:IsTweenPlaying() then
    return
  end
  EquipNewChooseBord.super.HandleClickItem(self, cellctl)
end

function EquipNewChooseBord:ClickItemIcon(cellctl)
  EquipNewChooseBord.super.ClickItemIcon(self, cellctl)
  self:UpdateItemIconChoose()
end

function EquipNewChooseBord:UpdateItemIconChoose()
  local cells = self.chooseCtl and self.chooseCtl:GetCells()
  if cells and 0 < #cells then
    for _, cell in pairs(cells) do
      cell:SetItemIconChooseId(self.clickId)
    end
  end
end

function EquipNewChooseBord:SetTypeLabelTextGetter(getter)
  local cells = self.chooseCtl and self.chooseCtl:GetCells()
  if cells and 0 < #cells then
    for _, cell in pairs(cells) do
      cell:SetTypeLabelTextGetter(getter)
    end
  end
end

function EquipNewChooseBord:ActiveFilterPop(b)
  if not self.filterPop then
    return
  end
  self.filterPop.gameObject:SetActive(b)
end

autoImport("EquipNewCountChooseCell")
EquipNewCountChooseBord = class("EquipNewCountChooseBord", EquipNewChooseBord)
EquipNewCountChooseBord.CellControl = EquipNewCountChooseCell

function EquipNewCountChooseBord:InitBord()
  EquipNewMultiChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
end

function EquipNewCountChooseBord:OnCountChooseChange(cellCtl)
  if self:IsTweenPlaying() then
    return
  end
  self:PassEvent(EquipChooseCellEvent.CountChooseChange, cellCtl)
end

function EquipNewCountChooseBord:SetChooseReference(reference, refreshData)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseReference(reference)
  end
  if refreshData then
    local datas = self.chooseCtl:GetDatas()
    if datas then
      for i = 1, #datas do
        for j = 1, #datas[i] do
          datas[i][j].chooseCount = 0
          for k, v in pairs(reference) do
            if v.id == datas[i][j].id then
              datas[i][j].chooseCount = v.num
            end
          end
        end
      end
    end
  end
end

function EquipNewCountChooseBord:SetUseItemNum(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetUseItemNum(b)
  end
end

autoImport("EquipExtractionCountChooseCell")
EquipExtractionCountChooseBord = class("EquipExtractionCountChooseBord", EquipNewChooseBord)
EquipExtractionCountChooseBord.CellControl = EquipExtractionCountChooseCell
EquipExtractionCountChooseBord.PfbPath = "part/Extraction/ExtractionEquipChooseBord"
EquipExtractionCountChooseBord.CellPfbName = "Extraction/ExtractionEquipChooseCell"

function EquipExtractionCountChooseBord:InitBord()
  EquipExtractionCountChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack(go)
    self:Hide()
  end
end

function EquipExtractionCountChooseBord:OnCountChooseChange(cellCtl)
  if self:IsTweenPlaying() then
    return
  end
  self:PassEvent(EquipChooseCellEvent.CountChooseChange, cellCtl)
end

function EquipExtractionCountChooseBord:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseReference(reference)
  end
end

function EquipExtractionCountChooseBord:SetUseItemNum(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetUseItemNum(b)
  end
end

EquipNewMultiChooseBord = class("EquipNewMultiChooseBord", EquipNewChooseBord)
EquipNewMultiChooseBord.CellControl = EquipNewMultiChooseCell

function EquipNewMultiChooseBord:InitBord()
  EquipNewMultiChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickCancel, self.ClickCancel, self)
end

function EquipNewMultiChooseBord:ClickCancel(cellCtl)
  if self:IsTweenPlaying() then
    return
  end
  self:PassEvent(EquipChooseCellEvent.ClickCancel, cellCtl and cellCtl.data)
end

function EquipNewMultiChooseBord:SetChoose(data)
end

function EquipNewMultiChooseBord:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(reference)
  end
end
