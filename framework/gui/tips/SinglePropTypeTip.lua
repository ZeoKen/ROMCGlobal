autoImport("BaseTip")
autoImport("SinglePropTypeCell")
SinglePropTypeTip = class("SinglePropTypeTip", BaseTip)
local tempVector3 = LuaVector3.Zero()

function SinglePropTypeTip:Init()
  SinglePropTypeTip.super.Init(self)
  self.propDatas = {}
  self:initView()
end

function SinglePropTypeTip:initView()
  local grid = self:FindComponent("PropTypeGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(grid, SinglePropTypeCell, "SinglePropTypeCell")
  self.propGrid:AddEventListener(MouseEvent.MouseClick, self.PropClick, self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("ConfirmBtn", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("ResetBtn", function()
    local cells = self.propGrid:GetCells()
    for i = 1, #cells do
      cells[i]:SetIsSelect(true)
    end
    if self.callback then
      self.callback(self.callbackParam)
    end
  end)
  self.firstContent = self:FindGO("firstContent")
  self.ConfirmBtnBg = self:FindComponent("ConfirmBtnbg", UISprite)
end

function SinglePropTypeTip:ChooseEvent()
  local cells = self.propGrid:GetCells()
  local tb = {}
  for i = 1, #cells do
    local single = cells[i]
    if single.isSelected then
      tb[#tb + 1] = single.id
    end
  end
  if self.callback then
    self.callback(self.callbackParam, tb)
  end
end

function SinglePropTypeTip:PropClick(ctr)
  if ctr and ctr.data then
    ctr:SetIsSelect(not ctr.isSelected)
  end
end

function SinglePropTypeTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function SinglePropTypeTip:SetData(data)
  self.callback = data.callback
  self.callbackParam = data.param
  self.data = data.data
  self:initData()
  self:SelectValues(data.curProps)
end

function SinglePropTypeTip:initData()
  TableUtility.ArrayClear(self.propDatas)
  local config = self.data
  local single
  for k, v in pairs(config) do
    single = {id = k, name = v}
    self.propDatas[#self.propDatas + 1] = single
  end
  self.propGrid:ResetDatas(self.propDatas)
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.firstContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  y = y - height - 30
end

function SinglePropTypeTip:SelectValues(props)
  if not props then
    return
  end
  local cells = self.propGrid:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    if TableUtility.ArrayFindIndex(props, cells[i].id) > 0 then
      cells[i]:SetIsSelect(true)
    end
  end
end

function SinglePropTypeTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function SinglePropTypeTip:CloseSelf()
  self:ChooseEvent()
  TipsView.Me():HideCurrent()
end

function SinglePropTypeTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
