autoImport("BaseTip")
autoImport("PropTypeCell")
PropTypeTip = class("PropTypeTip", BaseTip)
local tempVector3 = LuaVector3.Zero()

function PropTypeTip:Init()
  PropTypeTip.super.Init(self)
  self.propDatas = {}
  self.customProps = {}
  self:initView()
end

function PropTypeTip:initView()
  self:initPropGrid()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("ConfirmBtn", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("ResetBtn", function()
    self:OnResetBtnClick()
  end)
  self.firstContent = self:FindGO("firstContent")
  self.secondContent = self:FindGO("secondContent")
  local ResetBtnLabel = self:FindComponent("ResetBtnLabel", UILabel)
  ResetBtnLabel.text = ZhString.SetViewSecurityPage_SecurityResetBtnText
  self.ConfirmBtnLabel = self:FindComponent("ConfirmBtnLabel", UILabel)
  self.ConfirmBtnLabel.text = ZhString.CommonZhString_Close
  local firstContentTitle = self:FindComponent("firstContentTitle", UILabel)
  firstContentTitle.text = ZhString.AdventureHomePage_PropTitle
  local secondContentTitle = self:FindComponent("secondContentTitle", UILabel)
  secondContentTitle.text = ZhString.AdventureHomePage_PropKeyworkTitle
  self.ConfirmBtnBg = self:FindComponent("ConfirmBtnbg", UISprite)
  self.emptyCt = self:FindGO("emptyCt")
  local emptyDes = self:FindComponent("emptyDes", UILabel)
  emptyDes.text = ZhString.AdventureHomePage_PropKeyEmptyTitle
  self:Show(self.emptyCt)
end

function PropTypeTip:initPropGrid()
  self.customContent = self:FindGO("customContent")
  self.customContentLabel = self:FindComponent("title", UILabel, self.customContent)
  local grid = self:FindComponent("customPropGrid", UIGrid)
  self.customPropGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.customPropGrid:AddEventListener(MouseEvent.MouseClick, self.CustomPropClick, self)
  local grid = self:FindComponent("PropTypeGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.propGrid:AddEventListener(MouseEvent.MouseClick, self.PropClick, self)
  grid = self:FindComponent("KeywordGrid", UIGrid)
  self.keyworkGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.keyworkGrid:AddEventListener(MouseEvent.MouseClick, self.KeyworkClick, self)
end

function PropTypeTip:ChooseEvent()
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

function PropTypeTip:PropClick(ctr)
  if ctr and ctr.data then
    if ctr.isSelected then
      ctr:SetIsSelect(false)
      self:SetKeyWords(nil)
    else
      ctr:SetIsSelect(true)
      local cells = self.propGrid:GetCells()
      for i = 1, #cells do
        if cells[i] ~= ctr then
          cells[i]:SetIsSelect(false)
        end
      end
      self:SetKeyWords(ctr.data)
    end
    self:ChooseEvent()
    return
  end
  self:Show(self.emptyCt)
end

local keyWordDatas = {}

function PropTypeTip:SetKeyWords(propData)
  TableUtility.ArrayClear(keyWordDatas)
  local datas = propData and AdventureDataProxy.Instance:getKeywords(propData.id, propData)
  if datas and datas.subTable then
    for k, v in pairs(datas.subTable) do
      for k1, v1 in pairs(v) do
        keyWordDatas[#keyWordDatas + 1] = v1
      end
    end
  end
  self.keyworkGrid:ResetDatas(keyWordDatas)
  local cells = self.keyworkGrid:GetCells()
  for i = 1, #cells do
    cells[i]:SetIsSelect(false)
  end
  self.emptyCt:SetActive(#keyWordDatas == 0)
  self.PropData = datas
end

function PropTypeTip:CustomPropClick(cell)
  if cell and cell.data then
    cell:SetIsSelect(not cell.isSelected)
  end
  self:ChooseEvent()
end

function PropTypeTip:KeyworkClick(ctr)
  if ctr and ctr.data then
    ctr:SetIsSelect(not ctr.isSelected)
    self:ChooseEvent()
  end
end

function PropTypeTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function PropTypeTip:SetData(data)
  TableUtility.ArrayClear(self.customProps)
  self.callback = data.callback
  self.callbackParam = data.param
  self.customContentLabel.text = data.customTitle or ""
  for id, name in pairs(data.customProps or {}) do
    self.customProps[#self.customProps + 1] = {id = id, name = name}
  end
  self.type = data.type
  self.tabID = data.tabID
  self:initData()
  self:SelectProps(data.curCustomProps, data.curPropData, data.curKeys)
end

function PropTypeTip:initData()
  if self.customProps and #self.customProps > 0 then
    self.customContent:SetActive(true)
    self.customPropGrid:ResetDatas(self.customProps)
  else
    self.customContent:SetActive(false)
    self.customPropGrid:ResetDatas({})
  end
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.customContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.customContent.transform)
  y = y - height - 30
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.firstContent.transform.localPosition = tempVector3
  TableUtility.ArrayClear(self.propDatas)
  local config = GameConfig.AdventurePropClassify
  local single
  for i = 1, #config do
    single = config[i]
    if (not single.TypeLimit or single.TypeLimit == self.type) and (not single.TabLimit or single.TabLimit == self.tabID) then
      self.propDatas[#self.propDatas + 1] = single
    end
  end
  self.propGrid:ResetDatas(self.propDatas)
  bd = NGUIMath.CalculateRelativeWidgetBounds(self.firstContent.transform)
  height = bd.size.y
  x, y, z = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  y = y - height - 30
  x1, y1, z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.secondContent.transform.localPosition = tempVector3
end

function PropTypeTip:SelectValues(propData, keys)
  if not propData then
    return
  end
  local cells = self.propGrid:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    if cells[i].data.id == propData.propId then
      cells[i]:SetIsSelect(true)
      self:SetKeyWords(cells[i].data)
      if keys then
        local keyCells = self.keyworkGrid:GetCells()
        if keyCells then
          for j = 1, #keys do
            for x = 1, #keyCells do
              if keyCells[x].data == keys[j] then
                keyCells[x]:SetIsSelect(true)
              end
            end
          end
        end
      end
      break
    end
  end
end

function PropTypeTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PropTypeTip:CloseSelf(data)
  if self.callback and data then
    local cells = self.keyworkGrid:GetCells()
    local tb = {}
    for i = 1, #cells do
      local single = cells[i]
      if single.isSelected then
        tb[#tb + 1] = single.data
      end
    end
    self.callback(self.callbackParam, data, tb)
  end
  self.PropData = nil
  TipsView.Me():HideCurrent()
end

function PropTypeTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function PropTypeTip:SelectProps(curCustomProps, props, keys)
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

function PropTypeTip:OnResetBtnClick()
  local cells = self.customPropGrid:GetCells()
  for i = 1, #cells do
    cells[i]:SetIsSelect(false)
  end
  cells = self.propGrid:GetCells()
  for i = 1, #cells do
    cells[i]:SetIsSelect(false)
  end
  self.keyworkGrid:ResetDatas({})
  self:Show(self.emptyCt)
  if self.callback then
    self.callback(self.callbackParam)
  end
  self.PropData = nil
end
