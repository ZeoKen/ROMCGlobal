local baseCell = autoImport("BaseCell")
AncientRandomAttrCell = class("AncientRandomAttrCell", baseCell)

function AncientRandomAttrCell:Init()
  self:initView()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AncientRandomAttrCell:initView()
  self.tabName = self:FindComponent("TabName", UILabel)
  self.tabTime = self:FindComponent("TabTime", UILabel)
  self.checkmark = self:FindGO("Checkmark")
  self.oriAttr = self:FindComponent("OriAttr", UILabel)
  self.newAttr = self:FindComponent("NewAttr", UILabel)
  self.maxMark = self:FindGO("MaxMark")
  self.arrow = self:FindGO("Arrow")
  self._normal = self:FindGO("_normal")
  self._selected = self:FindGO("_selected")
end

function AncientRandomAttrCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    self._normal:SetActive(not self.isSelected)
    self._selected:SetActive(self.isSelected)
  end
end

function AncientRandomAttrCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  else
    self:Show()
  end
  self.valueMaxed = false
  local sData = Table_EquipEffect[data.id]
  if not sData then
    return
  end
  local tAttrType, attrType = type(sData.AttrType)
  if tAttrType == "string" then
    attrType = sData.AttrType
  elseif tAttrType == "table" then
    attrType = tostring(sData.AttrType[1])
  end
  local attrConfig = Game.Config_PropName[attrType]
  if not attrConfig then
    LogUtility.WarningFormat("Cannot find prop data by name = {0} with id = {1}", attrType or "", randomEffectId)
    return
  end
  local oriText = ItemTipBaseCell.FormatRandomEffectStr(data.id, data.value, true)
  self.oriAttr.text = oriText
  local isMinusPattern = not string.find(oriText, "＋") and not string.find(oriText, "+")
  local nowData = data.nowData
  local __AttrGroup = sData.GroupID
  local __NewEquipRefine = nowData.equipInfo.equipData.NewEquipRefine
  local __Pos = nowData.equipInfo.site
  __Pos = __Pos and 0 < #__Pos and __Pos[1] or 0
  local __Spirit = nowData.equipInfo.equipData.Spirit or 0
  local __Level = ItemTipBaseCell.GetGenByRandomEffectValue(data.id, data.value)
  local available_formula = {}
  for _, v in pairs(Table_RefreshAttrCompose) do
    if v.AttrGroup == __AttrGroup and v.Spirit == __Spirit and 0 < TableUtility.ArrayFindIndex(v.NewEquipRefine, __NewEquipRefine) and 0 < TableUtility.ArrayFindIndex(v.Pos, __Pos) and __Level < v.MaxLevel then
      table.insert(available_formula, v)
    end
  end
  table.sort(available_formula, function(l, r)
    return l.MaxLevel < r.MaxLevel
  end)
  if #available_formula == 0 then
    self.valueMaxed = true
    self.formula = nil
  else
    self.valueMaxed = false
    self.formula = available_formula[1]
  end
  self.newAttr.text = ""
  if self.valueMaxed then
    self.arrow:SetActive(false)
    self.maxMark:SetActive(true)
  else
    self.arrow:SetActive(true)
    self.maxMark:SetActive(__Level + 1 == self.formula.MaxLevel)
    local nextValue = ItemTipBaseCell.GetNextGenRandomEffectValue(data.id, data.value)
    local signPrefix = isMinusPattern and "-" or "+"
    if data.value < 0 then
      signPrefix = ""
    end
    if nextValue ~= nil then
      self.newAttr.text = signPrefix .. (attrConfig.IsPercent == 1 and nextValue * 100 .. "%" or nextValue)
    end
  end
  if self.isSelected == nil then
    self.isSelected = false
  end
  self._normal:SetActive(not self.isSelected)
  self._selected:SetActive(self.isSelected)
end
