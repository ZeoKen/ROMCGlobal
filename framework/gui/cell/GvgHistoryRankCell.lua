local _tempVector3 = LuaVector3.Zero()
local _tempRot = LuaQuaternion()
local _maxChampionCnt = 3
local _BaseCell = autoImport("BaseCell")
autoImport("NewGvgRankCell")
GvgHistoryRankCell = class("GvgHistoryRankCell", _BaseCell)
GvgHistoryRankCell.ClickArrow = "GvgHistoryRankCell_ClickArrow"

function GvgHistoryRankCell:Init()
  self:FindObj()
  self.shrink = false
  self:AddUIEvts()
end

function GvgHistoryRankCell:FindObj()
  self.table = self.gameObject:GetComponent(UITable)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.rankCtl = UIGridListCtrl.new(self.grid, NewGvgRankCell, "NewGvgRankCell")
  self.seasonLab = self:FindComponent("SeasonLab", UILabel)
  self.seasonLab2 = self:FindComponent("SeasonLab2", UILabel, self.seasonLab.gameObject)
  self.arrowBtn = self:FindGO("ArrowBtn")
end

function GvgHistoryRankCell:AddUIEvts()
  self:AddClickEvent(self.arrowBtn, function()
    self:RevertArrow()
  end)
end

function GvgHistoryRankCell:RevertArrow()
  self.shrink = not self.shrink
  _tempVector3[3] = self.shrink and -90 or 90
  LuaQuaternion.Better_SetEulerAngles(_tempRot, _tempVector3)
  self.arrowBtn.transform.localRotation = _tempRot
  if not (self.data and self.data.rankData) or 0 == #self.data.rankData then
    return
  end
  self:ResetRankCtlDatas()
  self.table:Reposition()
  self:PassEvent(GvgHistoryRankCell.ClickArrow)
end

function GvgHistoryRankCell:ResetRankCtlDatas()
  local championCnt = self.data.championCnt
  if self.shrink then
    if championCnt > _maxChampionCnt then
      self.rankCtl:ResetDatas(_EmptyTable)
    else
      local shrinkData = {}
      for i = 1, championCnt do
        shrinkData[#shrinkData + 1] = self.data.rankData[i]
      end
      self.rankCtl:ResetDatas(shrinkData)
    end
  else
    self.rankCtl:ResetDatas(self.data.rankData)
  end
end

function GvgHistoryRankCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:ResetRankCtlDatas()
  self.seasonLab.text = string.format(ZhString.NewGVG_SeasonIndex, data.season)
  self.seasonLab2.text = string.format(ZhString.NewGVG_Season, data.season)
end
