local BaseCell = autoImport("BaseCell")
EquipMemoryEditCell = class("EquipMemoryEditCell", BaseCell)

function EquipMemoryEditCell:Init()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.activePart = self:FindGO("ActivePart")
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  local itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.itemCell = ItemCell.new(obj)
  self.emptyPart = self:FindGO("Empty")
  self.changeBtn = self:FindGO("ChangeBtn")
  self.holeBtn = self:FindGO("HoleBtn")
  self.insertBtn = self:FindGO("InsertBtn")
  self.empthLabel = self:FindGO("EmptyLabel"):GetComponent(UILabel)
  self.emptyIcon = self:FindGO("EmptyIcon"):GetComponent(UIMultiSprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.attrGrid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.attrs = {}
  for i = 1, 3 do
    local go = self:FindGO("Attr" .. i)
    local name = self:FindGO("EffectName", go):GetComponent(UILabel)
    local level = self:FindGO("EffectLevel", go):GetComponent(UILabel)
    local waxSymbol = self:FindGO("Wax", go)
    self.attrs[i] = {
      go = go,
      name = name,
      level = level,
      waxSymbol = waxSymbol
    }
  end
  self:SetEvent(self.changeBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self:SetEvent(self.holeBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self:SetEvent(self.insertBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self:AddCellClickEvent()
end

function EquipMemoryEditCell:SetData(data)
  self.data = data
  if not data then
    self.activePart:SetActive(false)
    self.emptyPart:SetActive(true)
    self.emptyIcon.CurrentState = 0
    self.empthLabel.text = ZhString.EquipMemory_EmptySlot
    self.holeBtn:SetActive(false)
    self.insertBtn:SetActive(true)
    self.name.text = ZhString.EquipMemory_NotEquiped
  else
    local memoryData = data.equipMemoryData
    if not memoryData then
      redlog("没有记忆数据")
      return
    end
    self.activePart:SetActive(true)
    self.emptyPart:SetActive(false)
    local attrs = memoryData.memoryAttrs
    local maxAttrCount = memoryData.maxAttrCount
    for i = 1, maxAttrCount do
      if attrs[i] then
        self.attrs[i].go:SetActive(true)
        local attrId = attrs[i].id
        local level = 1
        local attrConfig = Game.ItemMemoryEffect[attrId]
        if attrConfig then
          local buffDesc
          local staticId = attrConfig.level and attrConfig.level[level]
          local staticData = staticId and Table_ItemMemoryEffect[staticId]
          self.attrs[i].name.text = staticData and staticData.WaxDesc
        end
      else
        self.attrs[i].go:SetActive(true)
        self.attrs[i].name.text = ZhString.NewbieTechTree_Unenabled
      end
    end
    self.attrGrid:Reposition()
    local _itemData = ItemData.new(data.id, data.equipMemoryData.staticId)
    _itemData:Copy(data)
    _itemData.embeded = true
    self.itemCell:SetData(_itemData)
    local level = memoryData.level
    self.name.text = _itemData:GetName()
  end
end
