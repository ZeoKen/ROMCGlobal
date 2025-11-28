local baseCell = autoImport("BaseCell")
BaseAttributeCell = class("BaseAttributeCell", baseCell)
BaseAttributeCell_Event = {
  GoPray = "BaseAttributeCell_GoPray"
}
local ValuePos1 = LuaVector3(469, 0, 0)
local ValuePos2 = LuaVector3(425, 0, 0)

function BaseAttributeCell:Init()
  self:initView()
  self:addViewEventListener()
end

function BaseAttributeCell:addViewEventListener()
  self:AddCellClickEvent()
end

function BaseAttributeCell:SetData(data)
  self.data = data
  local total, value, name, icon
  local addPointAttr = ""
  local lastTotal = 0
  if data ~= nil and data.name ~= nil and data.value ~= nil then
    value = data.value
    name = data.name
  end
  local propVO = data.prop and data.prop.propVO
  if self.data.type == BaseAttributeView.cellType.normal then
    local props = Game.Myself.data.props
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
  elseif self.data.type == BaseAttributeView.cellType.jobBase then
    value = self.data.value
    name = self.data.name
    if self.checkBoxCt then
      self:Hide(self.checkBoxCt)
    end
  elseif self.data.type == BaseAttributeView.cellType.saveHpSp then
    value = self.data.value
    name = ""
    if self.checkBoxCt then
      self:Hide(self.checkBoxCt)
    end
  elseif self.data.type == BaseAttributeView.cellType.fixed then
    total = data.prop:GetValue()
    if propVO.IsClientPercent then
      local tmp = math.floor(total * 1000) / 10
      if tmp == 0 then
        total = "0%"
      else
        total = tmp .. "%"
      end
    else
      total = math.floor(total)
    end
    total = "+" .. total
    if propVO.name == "Sp" or propVO.name == "Hp" then
      maxPropValue = math.floor(maxPropValue)
      value = total .. "/" .. maxPropValue .. addPointAttr
      name = propVO.name
    else
      value = total .. addPointAttr
      name = propVO.displayName
    end
    if self.checkBoxCt then
      self:Hide(self.checkBoxCt)
    end
  elseif self.data.type == BaseAttributeView.cellType.guild then
    icon = self.data.icon
  end
  self.value.text = value
  self.name.text = name
  if self.checkboxAnchor then
    self.checkboxAnchor:UpdateAnchors()
  end
  self:HideLine()
  self:HideDesc()
  if self.iconDescGO then
    if icon and icon ~= "" then
      self.iconDescGO:SetActive(true)
      self.valueTrans.localPosition = ValuePos2
      IconManager:SetUIIcon(icon, self.iconDesc)
      self.iconDesc:MakePixelPerfect()
      local width = self.iconDesc.width
      local height = self.iconDesc.height
      self.iconDesc.width = width * 0.8
      self.iconDesc.height = height * 0.8
    else
      self.iconDescGO:SetActive(false)
      self.valueTrans.localPosition = ValuePos1
    end
  end
end

function BaseAttributeCell:initView()
  self.name = self:FindChild("name"):GetComponent(UILabel)
  self.attributeDesc = self:FindComponent("attributeDesc", UILabel)
  local valueGO = self:FindGO("value")
  self.valueTrans = valueGO:GetComponent(Transform)
  self.value = valueGO:GetComponent(UILabel)
  self.line = self:FindGO("line")
  self.checkBox = self:FindComponent("selectedBg", UIToggle)
  self.checkBoxCt = self:FindGO("checkBox")
  self:AddButtonEvent("checkBox", function()
    self:PassEvent(InfomationPage.HasSelectedChange, self)
  end)
  self.checkboxAnchor = self:FindComponent("checkBox", UIWidget)
  self.iconDescGO = self:FindGO("IconDesc")
  if self.iconDescGO then
    self.iconDesc = self.iconDescGO:GetComponent(UISprite)
    self:AddClickEvent(self.iconDescGO, function()
      if self.data.type == BaseAttributeView.cellType.guild then
        self:PassEvent(BaseAttributeCell_Event.GoPray, self)
      end
    end)
  end
end

function BaseAttributeCell:setIsSelected(bRet)
  self.checkBox.value = bRet and true or false
end

function BaseAttributeCell:greyValueText()
  self.value.text = string.format("[c][454545FF]%s[-][/c]", self.data.value)
end

function BaseAttributeCell:whiteValueText()
  self.value.text = self.data.value
end

function BaseAttributeCell:IsSelected()
  return self.checkBox.value
end

function BaseAttributeCell:ChangeValueDepth(depth)
  self.value.depth = depth
end

function BaseAttributeCell:ChangeNameDepth(depth)
  self.name.depth = depth
end

function BaseAttributeCell:ChangeValueFontSize(size)
  self.value.fontSize = size
end

function BaseAttributeCell:ChangeNameFontSize(size)
  self.name.fontSize = size
end

function BaseAttributeCell:ChangeValueColor(color)
  self.value.color = color
end

function BaseAttributeCell:ChangeNameColor(color)
  self.name.color = color
end

function BaseAttributeCell:ChangeValueLocalPos(pos)
  self.value.gameObject.transform.localPosition = pos
end

function BaseAttributeCell:ChangeNameLocalPos(pos)
  self.value.gameObject.transform.localPosition = pos
end

function BaseAttributeCell:ChangeValueWidgetSize(width, height)
  if width then
    self.value.width = width
  end
  if height then
    self.value.height = height
  end
end

function BaseAttributeCell:ChangeNameWidgetSize(width, height)
  if width then
    self.name.width = width
  end
  if height then
    self.name.height = height
  end
end

function BaseAttributeCell:HideLine()
  self.line.gameObject:SetActive(false)
end

function BaseAttributeCell:HideDesc()
  self.attributeDesc.gameObject:SetActive(false)
  local tempVector3 = LuaGeometry.GetTempVector3()
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.name.transform))
  tempVector3:Set(tempVector3.x, 0, tempVector3.z)
  self.name.transform.localPosition = tempVector3
end
