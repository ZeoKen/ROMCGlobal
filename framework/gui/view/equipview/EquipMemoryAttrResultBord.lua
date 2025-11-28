EquipMemoryAttrResultBord = class("EquipMemoryAttrResultBord", CoreView)
autoImport("EquipMemoryAttrGroupCell")

function EquipMemoryAttrResultBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb("part/EquipMemoryAttrResultBord", parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  self:InitBord()
  self:InitStaticData()
end

function EquipMemoryAttrResultBord:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.grid = self:FindGO("ResultGrid"):GetComponent(UITable)
  self.attrGroupCtrl = UIGridListCtrl.new(self.grid, EquipMemoryAttrGroupCell, "EquipMemoryAttrGroupCell")
  self.attrGroupCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSwitchSingle, self)
  self.closeBtn = self:FindGO("CloseButton")
  if self.closeBtn then
    self:AddClickEvent(self.closeBtn, function()
      self:Hide()
    end)
  end
end

function EquipMemoryAttrResultBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function EquipMemoryAttrResultBord:InitStaticData()
  if not Table_ItemMemoryLibrary then
    return
  end
  self.groupMap = {}
  for k, v in pairs(Table_ItemMemoryLibrary) do
    local type = v.Type
    if type then
      if not self.groupMap[type] then
        self.groupMap[type] = {}
      end
      if TableUtility.ArrayFindIndex(self.groupMap[type], v.EffectID) == 0 then
        table.insert(self.groupMap[type], v.EffectID)
      end
    end
  end
end

function EquipMemoryAttrResultBord:UpdateValidAttrs(groups)
  if not self.groupMap then
    return
  end
  local result = {}
  for _type, _effectList in pairs(self.groupMap) do
    local name = GameConfig.EquipMemory and GameConfig.EquipMemory.AttrTypeIcon[_type].Name or "???"
    local _tempData = {
      validgroup = groups,
      color = _type,
      list = _effectList,
      name = string.format(ZhString.EquipMemory_AttrGroup, name)
    }
    table.insert(result, _tempData)
  end
  local sortValue = EquipMemoryProxy.SortValue
  table.sort(result, function(l, r)
    local l_sortOrder = sortValue[l.color] or 999
    local r_sortOrder = sortValue[r.color] or 999
    if l_sortOrder ~= r_sortOrder then
      return l_sortOrder < r_sortOrder
    end
  end)
  self.attrGroupCtrl:ResetDatas(result)
end

function EquipMemoryAttrResultBord:HandleSwitchSingle(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.grid:Reposition()
end
