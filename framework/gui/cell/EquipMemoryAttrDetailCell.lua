EquipMemoryAttrDetailCell = class("EquipMemoryAttrDetailCell", BaseCell)

function EquipMemoryAttrDetailCell:Init()
  self.arrow = self:FindGO("Arrow")
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.dataInfo = self:FindGO("DataInfo")
  self.wax = self:FindGO("Wax"):GetComponent(UIMultiSprite)
  self.starGrid = self:FindGO("StarGrid"):GetComponent(UIGrid)
  self.stars = {}
  for i = 1, 3 do
    self.stars[i] = self:FindGO("Star" .. i, self.starGrid.gameObject):GetComponent(UILabel)
  end
  self.detailInfo = self:FindGO("DetailInfo")
  self.detailBg = self:FindGO("Bg", self.detailInfo):GetComponent(UISprite)
  self.detailTable = self:FindGO("DetailTable", self.detailInfo):GetComponent(UITable)
  self.textDesc = self:FindGO("TextDesc"):GetComponent(UILabel)
  self.starLevelInfo = self:FindGO("StarLevelInfo", self.detailInfo)
  self.starLevelGrid = self:FindGO("LevelInfoGrid", self.starLevelInfo):GetComponent(UITable)
  self.starLevelDesc = {}
  for i = 1, 4 do
    local go = self:FindGO("Star" .. i, self.starLevelInfo)
    local _desc = self:FindGO("Desc", go):GetComponent(UILabel)
    self.starLevelDesc[i] = _desc
  end
  self.waxInfo = self:FindGO("WaxInfo", self.detailInfo)
  self.waxGrid = self:FindGO("WaxGrid", self.waxInfo):GetComponent(UITable)
  self.waxDesc = {}
  for i = 1, 3 do
    local go = self:FindGO("Wax" .. i, self.waxInfo)
    self.waxDesc[i] = go:GetComponent(UILabel)
  end
  self.folderState = false
  self:AddCellClickEvent()
end

local _Seperator = "[AttrValue]"

function EquipMemoryAttrDetailCell:SetData(data)
  self.data = data
  local attrId = data.attrid
  local levels = data.levels
  local waxLevel = data.wax_level or 0
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if levels and attrConfig then
    local _descStr = ""
    local _value = 0
    local _resultStr = ""
    local _bufferFrame
    local attrInfo = ItemUtil.GetMemoryEffectInfo(attrId)
    if attrInfo then
      local _valueList = {}
      self.name.text = attrInfo[1].BuffName
      local _formatStr = attrInfo[1].FormatStr
      for i = 1, #levels do
        local _single = attrInfo[levels[i]]
        local _attrValue = _single.AttrValue
        for j = 1, #_attrValue do
          if not _valueList[j] then
            _valueList[j] = _attrValue[j]
          else
            _valueList[j] = _valueList[j] + _attrValue[j]
          end
        end
      end
      for m in _formatStr:gmatch("[AttrValue]") do
        local _replaceValue = table.remove(_valueList, 1)
        if _replaceValue then
          _formatStr = _formatStr:gsub("%[.-]", _replaceValue, 1)
        end
      end
      _descStr = _descStr .. _formatStr
    end
    for i = 1, 3 do
      if levels[i] then
        self.stars[i].gameObject:SetActive(true)
        self.stars[i].text = levels[i]
      else
        self.stars[i].gameObject:SetActive(false)
      end
    end
    self.wax.CurrentState = waxLevel
    if waxLevel and 0 < waxLevel then
      _descStr = _descStr .. [[


]]
      waxLevel = 3 < waxLevel and 3 or waxLevel
      local waxInfo = ItemUtil.GetMemoryWaxDesc(attrId, waxLevel)
      if waxInfo then
        local waxDesc = waxInfo and waxInfo[waxLevel] or ""
        if waxDesc ~= "" then
          waxDesc = string.format(ZhString.EquipMemory_WaxProcess, waxLevel) .. "\n" .. waxDesc
        end
        if waxLevel < 3 then
          local staticId = attrConfig.level and attrConfig.level[3]
          local staticData = staticId and Table_ItemMemoryEffect[staticId]
          local maxEffect = staticData and staticData.WaxDesc
          if maxEffect and maxEffect ~= "" then
            waxDesc = waxDesc .. "\n" .. string.format(ZhString.EquipMemory_WaxProcessMaxEffect, maxEffect)
          end
        end
        if waxDesc ~= "" then
          _descStr = _descStr .. waxDesc
        end
      end
    end
    self.dataInfo:SetActive(true)
    self.textDesc.gameObject:SetActive(true)
    self.starLevelInfo:SetActive(false)
    self.waxInfo:SetActive(false)
    self.textDesc.text = _descStr
  else
    self.dataInfo:SetActive(false)
    self.textDesc.gameObject:SetActive(false)
    self.starLevelInfo:SetActive(true)
    self.waxInfo:SetActive(true)
    local _bufferName
    local staticConfig = Game.ItemMemoryEffect[attrId]
    local levels = staticConfig.level
    for _level, _staticId in pairs(levels) do
      local staticData = _staticId and Table_ItemMemoryEffect[_staticId]
      local buffids = staticData and staticData.BuffID
      local buffInfo = buffids[1] and Table_Buffer[buffids[1]]
      if buffInfo then
        _bufferName = _bufferName or buffInfo.BuffName
        if self.starLevelDesc[_level] then
          local _desc = string.split(OverSea.LangManager.Instance():GetLangByKey(buffInfo.Dsc), _Seperator)
          local _descStr = ""
          for i = 1, #_desc do
            _descStr = _descStr .. _desc[i]
          end
          self.starLevelDesc[_level].text = _descStr
        end
      end
      local _waxDesc = ""
      local waxBuffIds = staticData and staticData.WaxBuffID
      for i = 1, #waxBuffIds do
        local buffInfo = Table_Buffer[waxBuffIds[i]]
        if buffInfo then
          if buffInfo and buffInfo.BuffEffect and not buffInfo.BuffEffect.NoShow then
            _waxDesc = _waxDesc .. buffInfo.Dsc
            if i < #waxBuffIds then
              _waxDesc = _waxDesc .. "\n"
            end
          end
        else
          redlog("buffer error", waxBuffIds[i])
        end
      end
      if self.waxDesc[_level] then
        self.waxDesc[_level].text = _waxDesc
      end
    end
    self.name.text = _bufferName
  end
  if self.folderState then
    self.starLevelGrid:Reposition()
    self.waxGrid:Reposition()
    self.detailTable:Reposition()
    local size = NGUIMath.CalculateRelativeWidgetBounds(self.detailTable.transform)
    self.detailBg.height = size.size.y + 26
  end
end

function EquipMemoryAttrDetailCell:SwitchFolderState()
  self.folderState = not self.folderState
  self.detailInfo:SetActive(self.folderState)
  self.arrow.transform.localRotation = Quaternion.Euler(0, 0, self.folderState and -90 or 0)
  if self.folderState then
    self.starLevelGrid:Reposition()
    self.waxGrid:Reposition()
    self.detailTable:Reposition()
    local size = NGUIMath.CalculateRelativeWidgetBounds(self.detailTable.transform)
    self.detailBg.height = size.size.y + 26
  end
end
