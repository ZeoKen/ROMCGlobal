autoImport("BaseTip")
autoImport("PropTypeCell")
PropTypeTip = class("PropTypeTip", BaseTip)
local tempVector3 = LuaVector3.Zero()

function PropTypeTip:Init()
  PropTypeTip.super.Init(self)
  self.propDatas = {}
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
  local grid = self:FindComponent("PropTypeGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.propGrid:AddEventListener(MouseEvent.MouseClick, self.PropClick, self)
  grid = self:FindComponent("KeywordGrid", UIGrid)
  self.keyworkGrid = UIGridListCtrl.new(grid, PropTypeCell, "PropTypeCell")
  self.keyworkGrid:AddEventListener(MouseEvent.MouseClick, self.KeyworkClick, self)
end

function PropTypeTip:ChooseEvent()
  local cells = self.keyworkGrid:GetCells()
  local tb = {}
  for i = 1, #cells do
    local single = cells[i]
    if single.isSelected then
      tb[#tb + 1] = single.data
    end
  end
  if self.callback then
    self.callback(self.callbackParam, self.PropData, tb)
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
  self.callback = data.callback
  self.callbackParam = data.param
  self.type = data.type
  self.tabID = data.tabID
  self:initData()
  self:SelectValues(data.curPropData, data.curKeys)
end

function PropTypeTip:initData()
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
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.firstContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  y = y - height - 30
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
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

function PropTypeTip:OnResetBtnClick()
  local cells = self.propGrid:GetCells()
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
