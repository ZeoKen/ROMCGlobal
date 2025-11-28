autoImport("BaseTip")
FloatTableTip = class("FloatTableTip", BaseTip)
local defaultHeight = 22

function FloatTableTip:Init()
  self:FindObjs()
end

function FloatTableTip:FindObjs()
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideTip(FloatTableTip)
  end
  
  self.bg = self:FindComponent("Bg", UISprite)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.table = self:FindGO("TableBg")
  self.columnTitle1 = self:FindComponent("columnTitle1", UILabel)
  self.columnTitle2 = self:FindComponent("columnTitle2", UILabel)
  local grid = self:FindComponent("Grid", UIGrid)
  self.tableCellListCtrl = UIGridListCtrl.new(grid, FloatTipTableCell, "FloatTipTableCell")
end

function FloatTableTip:SetData(data)
  self.descLabel.text = data.desc
  self.columnTitle1.text = data.columnTitle1
  self.columnTitle2.text = data.columnTitle2
  self.tableCellListCtrl:ResetDatas(data.tableRows)
  local offset = self.descLabel.height - defaultHeight
  self.bg.height = self.bg.height + offset
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.table)
  y = y - offset
  LuaGameObject.SetLocalPositionGO(self.table, x, y, z)
end

function FloatTableTip:OnExit()
  self.closeComp.callBack = nil
end

FloatTipTableCell = class("FloatTipTableCell", BaseCell)

function FloatTipTableCell:Init()
  self:FindObjs()
end

function FloatTipTableCell:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
end

function FloatTipTableCell:SetData(data)
  self.titleLabel.text = data.key
  self.valueLabel.text = data.value
end
