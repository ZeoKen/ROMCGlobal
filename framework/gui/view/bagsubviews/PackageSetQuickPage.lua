PackageSetQuickPage = class("PackageSetQuickPage", SubMediatorView)
autoImport("SetQuickItemCell")
local MAX_SHORTCUT = GameConfig.NewRole.maxshortcut
local ROWCOUNT = 5

function PackageSetQuickPage:Init()
  self:AddViewEvts()
  self:InitUI()
end

function PackageSetQuickPage:InitUI()
  self.switchBtn = self:FindGO("SwitchBtn")
  self.pageLab = self:FindComponent("PageLab", UILabel, self.switchBtn)
  self:AddClickEvent(self.switchBtn, function(go)
    self:onSwitch()
  end)
  self.quickUseGrid = self:FindComponent("QuickUseGrid", UIGrid)
  self.switchIndex = 1
  self.pageLab.text = self.switchIndex
  self.quickUseItem = {}
  for i = 1, ROWCOUNT do
    local obj = self:LoadPreferb("cell/SetQuickItemCell", self.quickUseGrid.gameObject)
    obj.name = "SetQuickItemCell" .. i
    self.quickUseItem[i] = SetQuickItemCell.new(obj)
    self.quickUseItem[i]:SetQuickPos(i)
    self.quickUseItem[i]:AddEventListener(SetQuickItemCell.SwapObj, self.SetQuickUseItem, self)
  end
  self.quickUseGrid:Reposition()
end

function PackageSetQuickPage:OnEnter()
  PackageSetQuickPage.super.OnEnter(self)
  self:UpdateQuickUse()
end

function PackageSetQuickPage:SetQuickUseItem(param)
  self.SetQuickUseFunc(param)
end

function PackageSetQuickPage:onSwitch(index)
  self.switchIndex = self.switchIndex + 1
  if self.switchIndex > MAX_SHORTCUT / 5 then
    self.switchIndex = 1
  end
  self.pageLab.text = self.switchIndex
  local begin = 1 + (self.switchIndex - 1) * ROWCOUNT
  for i = begin, self.switchIndex * ROWCOUNT do
    local index = math.floor(i % 5)
    index = index == 0 and 4 or index - 1
    local obj = self.quickUseGrid.gameObject.transform:GetChild(index).gameObject
    obj.name = "SetQuickItemCell" .. i
    self.quickUseItem[index + 1]:SetQuickPos(i)
  end
  self:UpdateQuickUse()
  self.quickUseGrid:Reposition()
end

function PackageSetQuickPage.SetQuickUseFunc(param)
  local surcData = param.surce.itemdata
  local surcPos = param.surce.pos
  local targetPos = param.target.pos
  local keys = {}
  local key = {
    guid = surcData.id,
    preguid = surcData:GetPileString(),
    type = surcData.staticData.id,
    pos = targetPos - 1
  }
  table.insert(keys, key)
  if surcPos then
    local targetData = param.target.data
    local targetId, typeId, targetPreguid
    if targetData then
      targetId = targetData.id
      typeId = targetData.staticData.id
      targetPreguid = targetData:GetPileString()
    end
    local key2 = {
      guid = targetId,
      type = typeId,
      preguid = targetPreguid,
      pos = surcPos - 1
    }
    table.insert(keys, key2)
  end
  for i = 1, #keys do
    ServiceNUserProxy.Instance:CallPutShortcut(keys[i])
  end
end

function PackageSetQuickPage:UpdateQuickUse()
  local quickUseItems = ShortCutProxy.Instance:GetShorCutItem(true)
  for i = 1, #self.quickUseItem do
    local cell = self.quickUseItem[i]
    local dataIndex = i + (self.switchIndex - 1) * ROWCOUNT
    cell:SetData(quickUseItems[dataIndex])
  end
end

function PackageSetQuickPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateQuickUse)
  self:AddListenEvt(ServiceEvent.NUserPutShortcut, self.UpdateQuickUse)
  self:AddListenEvt(MyselfEvent.ResetHpShortCut, self.UpdateQuickUse)
end

function PackageSetQuickPage:OnDestroy()
  for _, cell in pairs(self.quickUseItem) do
    cell:OnCellDestroy()
    TableUtility.TableClear(cell)
  end
  PackageSetQuickPage.super.OnDestroy(self)
end
