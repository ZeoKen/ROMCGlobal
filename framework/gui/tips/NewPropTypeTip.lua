autoImport("SinglePropTypeCell")
NewPropTypeTip = class("NewPropTypeTip", PropTypeTip)
local tempVector3 = LuaVector3.Zero()

function NewPropTypeTip:Init()
  NewPropTypeTip.super.Init(self)
  self.customProps = {}
end

function NewPropTypeTip:initView()
  self.customContent = self:FindGO("customContent")
  self.customContentLabel = self:FindComponent("title", UILabel, self.customContent)
  local grid = self:FindComponent("customPropGrid", UIGrid)
  self.customPropGrid = UIGridListCtrl.new(grid, SinglePropTypeCell, "SinglePropTypeCell")
  self.customPropGrid:AddEventListener(MouseEvent.MouseClick, self.CustomPropClick, self)
  NewPropTypeTip.super.initView(self)
end

function NewPropTypeTip:initPropGrid()
  local grid = self:FindComponent("PropTypeGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(grid, SinglePropTypeCell, "SinglePropTypeCell")
  self.propGrid:AddEventListener(MouseEvent.MouseClick, self.PropClick, self)
  grid = self:FindComponent("KeywordGrid", UIGrid)
  self.keyworkGrid = UIGridListCtrl.new(grid, SinglePropTypeCell, "SinglePropTypeCell")
  self.keyworkGrid:AddEventListener(MouseEvent.MouseClick, self.KeyworkClick, self)
end

function NewPropTypeTip:SetData(data)
  TableUtility.ArrayClear(self.customProps)
  self.callback = data.callback
  self.callbackParam = data.param
  self.customContentLabel.text = data.customTitle or ""
  for id, name in pairs(data.customProps) do
    self.customProps[#self.customProps + 1] = {id = id, name = name}
  end
  self:initData()
  self:SelectProps(data.curCustomProps, data.curPropData, data.curKeys)
end

function NewPropTypeTip:initData()
  self.customPropGrid:ResetDatas(self.customProps)
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.customContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.customContent.transform)
  y = y - height - 30
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.firstContent.transform.localPosition = tempVector3
  NewPropTypeTip.super.initData(self)
end

function NewPropTypeTip:CustomPropClick(cell)
  if cell and cell.data then
    cell:SetIsSelect(not cell.isSelected)
  end
  self:ChooseEvent()
end

function NewPropTypeTip:ChooseEvent()
  local cells = self.customPropGrid:GetCells()
  local customs = {}
  for i = 1, #cells do
    local cell = cells[i]
    if cell.isSelected then
      customs[#customs + 1] = cell.id
    end
  end
  cells = self.keyworkGrid:GetCells()
  local tb = {}
  for i = 1, #cells do
    local single = cells[i]
    if single.isSelected then
      tb[#tb + 1] = single.data
    end
  end
  if self.callback then
    self.callback(self.callbackParam, customs, self.PropData, tb)
  end
end

function NewPropTypeTip:SelectProps(curCustomProps, props, keys)
  if curCustomProps then
    local cells = self.customPropGrid:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if TableUtility.ArrayFindIndex(curCustomProps, cell.id) > 0 then
        cell:SetIsSelect(true)
      end
    end
  end
  self:SelectValues(props, keys)
end

function NewPropTypeTip:OnResetBtnClick()
  local cells = self.customPropGrid:GetCells()
  for i = 1, #cells do
    cells[i]:SetIsSelect(false)
  end
  NewPropTypeTip.super.OnResetBtnClick(self)
end
