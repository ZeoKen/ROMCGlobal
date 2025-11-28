BaseCell = autoImport("BaseCell")
ProfessionAttrCell = class("ProfessionAttrCell", BaseCell)

function ProfessionAttrCell:Init()
  self:FindObjs()
end

function ProfessionAttrCell:FindObjs()
  self.attrName = self:FindGO("AttrName"):GetComponent(UILabel)
  self.attrNum = self:FindGO("AttrNum"):GetComponent(UILabel)
  self.dotLine = self:FindGO("DotLine")
end

function ProfessionAttrCell:SetData(data, props)
  self.dotLine:SetActive(self.indexInList ~= 1)
  self.data = data
  local total, value, name, icon
  local addPointAttr = ""
  local lastTotal = 0
  if data ~= nil and data.name ~= nil and data.value ~= nil then
    value = data.value
    name = data.name
  end
  local propVO = data.prop and data.prop.propVO
  local per = props:GetPropByName(propVO.name .. "Per")
  per = per and per:GetValue() or nil
  local maxPer = props:GetPropByName("Max" .. propVO.name .. "Per")
  maxPer = maxPer and maxPer:GetValue() or nil
  local maxPropValue = props:GetPropByName("Max" .. propVO.name)
  maxPropValue = maxPropValue and maxPropValue:GetValue() or 0
  per = per or 0
  maxPer = maxPer or 0
  if propVO.name == "Sp" or propVO.name == "Hp" then
    addPointAttr = data.maxAddData or nil
  else
    addPointAttr = data.addData or nil
  end
  if CommonFun.checkIsNoNeedPercent(propVO.name) then
    total = data.prop:GetValue()
  else
    total = data.prop:GetValue() * (1 + per)
  end
  lastTotal = total
  if propVO.name == "Sp" or propVO.name == "Hp" then
    lastTotal = maxPropValue
  end
  if addPointAttr and addPointAttr ~= 0 then
    if propVO.IsClientPercent then
      if math.floor(addPointAttr * 1000) ~= 0 then
        local formatStr = "  [c][FF8A29FF]%s%%[-][/c]"
        if 0 < addPointAttr then
          formatStr = "  [c][FF8A29FF]+%s%%[-][/c]"
        end
        addPointAttr = string.format(formatStr, math.floor(addPointAttr * 1000) / 10)
      else
        addPointAttr = ""
      end
    elseif math.floor(addPointAttr) ~= 0 then
      local formatStr = "  [c][FF8A29ff]%s[-][/c]"
      if 0 < addPointAttr then
        formatStr = "  [c][FF8A29ff]+%s[-][/c]"
      end
      addPointAttr = string.format(formatStr, math.floor(addPointAttr))
    else
      addPointAttr = ""
    end
  else
    addPointAttr = ""
  end
  if propVO.IsClientPercent then
    local tmp = math.floor(total * 1000) / 10
    total = tmp .. "%"
  else
    total = math.floor(total)
  end
  if propVO.name == "Sp" or propVO.name == "Hp" then
    maxPropValue = math.floor(maxPropValue)
    value = total .. "/" .. maxPropValue .. addPointAttr
    name = propVO.name
  else
    value = total .. addPointAttr
    name = propVO.displayName
  end
  if self.checkBoxCt then
    if propVO.name == "SaveHp" or propVO.name == "SaveSp" then
      self:Show(self.checkBoxCt)
      self:PassEvent(InfomationPage.CheckHasSelected, self)
    else
      self:Hide(self.checkBoxCt)
    end
  end
  if propVO.name == "SlimHeight" then
    local _, scaleY = Game.Myself:GetScaleWithFixHW()
    value = math.floor(scaleY * 100) .. "%"
    if 1 < scaleY then
      value = ZhString.Charactor_SlimHeightDes_L .. value
    elseif scaleY == 1 then
      value = ZhString.Charactor_SlimDes_Nomal .. value
    else
      value = ZhString.Charactor_SlimHeightDes_S .. value
    end
  end
  if propVO.name == "SlimWeight" then
    local scaleX = Game.Myself:GetScaleWithFixHW()
    value = math.floor(scaleX * 100) .. "%"
    if 1 < scaleX then
      value = ZhString.Charactor_SlimWeightDes_L .. value
    elseif scaleX == 1 then
      value = ZhString.Charactor_SlimDes_Nomal .. value
    else
      value = ZhString.Charactor_SlimWeightDes_S .. value
    end
  end
  self.attrName.text = name
  self.attrNum.text = value
end
