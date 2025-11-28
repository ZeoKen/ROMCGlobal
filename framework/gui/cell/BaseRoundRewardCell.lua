local BaseCell = autoImport("BaseCell")
BaseRoundRewardCell = class("BaseRoundRewardCell", BaseCell)
local itemCellPos = {
  [1] = -97.9,
  [2] = -0.9,
  [3] = 96.5
}
local itemCellCount = 3
local tempCellVector3 = LuaVector3.Zero()

function BaseRoundRewardCell:Init()
  self:InitTableData()
  self:FindObjs()
  self:InitItemList()
  self:AddEvents()
end

function BaseRoundRewardCell:InitTableData()
  self.listItem = ReusableTable.CreateArray()
  self.tipData = ReusableTable.CreateTable()
  self:InitCellPath()
end

function BaseRoundRewardCell:InitCellPath()
  self.cellPath = "cell/ItemCell"
end

function BaseRoundRewardCell:OnCellDestroy()
  ReusableTable.DestroyAndClearArray(self.listItem)
  ReusableTable.DestroyAndClearTable(self.tipData)
end

function BaseRoundRewardCell:FindObjs()
  self.txtTitle = self:FindComponent("txtTitle", UILabel)
  self.objReceived = self:FindGO("objReceived")
  self.objSelect = self:FindGO("objSelect")
end

function BaseRoundRewardCell:InitItemList()
  local itemCell
  for i = 1, itemCellCount do
    local obj = self:LoadPreferb(self.cellPath, self.gameObject)
    tempCellVector3[1] = itemCellPos[i]
    obj.transform.localPosition = tempCellVector3
    itemCell = ItemCell.new(obj)
    itemCell:Hide()
    self.listItem[#self.listItem + 1] = itemCell
  end
end

function BaseRoundRewardCell:AddEvents()
  local itemCellData
  for i = 1, itemCellCount do
    self:AddButtonEvent("btn" .. i, function(go)
      itemCellData = self.listItem[i].data
      if itemCellData then
        self.tipData.itemdata = itemCellData
        self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
      end
    end)
  end
end

function BaseRoundRewardCell:SetData(data)
end
