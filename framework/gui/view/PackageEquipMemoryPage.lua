PackageEquipMemoryPage = class("PackageEquipMemoryPage", SubView)
PackageEquipMemoryPage.PfbPath = "view/PackageEquipMemoryPage"
autoImport("EquipMemoryAttrCell")
autoImport("EquipMemoryAttrDetailCell")

function PackageEquipMemoryPage:Init()
  self:AddEvts()
  self.initPage = false
end

function PackageEquipMemoryPage:AddEvts()
  self:AddListenEvt(ServiceEvent.ItemUpdateMemoryPosItemCmd, self.UpdateView)
end

function PackageEquipMemoryPage:InitPage()
  self.initPage = true
  self.holder = self:FindGO("EquipMemoryHolder")
  self.gameObject = self:LoadPreferb(PackageEquipMemoryPage.PfbPath, self.holder, true)
  local togGrid = self:FindGO("TogGrid"):GetComponent(UIGrid)
  self.tog1 = self:FindGO("Tog1"):GetComponent(UIToggle)
  self.tog2 = self:FindGO("Tog2"):GetComponent(UIToggle)
  self.tog1.value = true
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.effectGrid = self:FindGO("EffectGrid"):GetComponent(UITable)
  self.effectCtrl = UIGridListCtrl.new(self.effectGrid, EquipMemoryAttrCellType3, "EquipMemoryAttrCellType3")
  self.effectCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSwitchSingle, self)
  self.waxEffectCtrl = UIGridListCtrl.new(self.effectGrid, EquipMemoryAttrCellType5, "EquipMemoryAttrCellType5")
  self.closeButton = self:FindGO("CloseButton", self.holder)
  self:AddClickEvent(self.closeButton, function()
    self.container:SetLeftViewState(PackageView.LeftViewState.Default)
  end)
end

function PackageEquipMemoryPage:InitView()
end

function PackageEquipMemoryPage:UpdateView()
  xdlog("UpdateView")
  if self.initPage then
    self:UpdateActiveEffect()
  end
end

function PackageEquipMemoryPage:UpdateActiveEffect()
  local result = {}
  local result2 = {}
  local fullfire = PvpProxy.Instance:IsFreeFire()
  local memoryLevels = EquipMemoryProxy.Instance:GetTotalEquipMemoryLevels(fullfire) or {}
  for _attrid, _level in pairs(memoryLevels) do
    local _tempData = {id = _attrid, level = _level}
    xdlog("attrid", _attrid, _level)
    local attrConfig = Game.ItemMemoryEffect[_attrid]
    if attrConfig then
      local level = 3 < _level and 3 or _level
      local staticId = attrConfig.level and attrConfig.level[level]
      local staticData = staticId and Table_ItemMemoryEffect[staticId]
      local waxBuffId = staticData and staticData.WaxBuffID
      if waxBuffId and 0 < #waxBuffId then
        table.insert(result2, _tempData)
      else
        table.insert(result, _tempData)
      end
    end
  end
  table.sort(result, function(l, r)
    return l.id < r.id
  end)
  table.sort(result2, function(l, r)
    return l.id < r.id
  end)
  self.effectCtrl:RemoveAll()
  self.waxEffectCtrl:RemoveAll()
  self.effectCtrl:ResetDatas(result)
  self.waxEffectCtrl:ResetDatas(result2)
  self.scrollView:ResetPosition()
end

function PackageEquipMemoryPage:UpdateEffectPreview()
  if not Game.ItemMemoryEffect then
    return
  end
  local result = {}
  for _attrid, _info in pairs(Game.ItemMemoryEffect) do
    local _tempData = {attrid = _attrid}
    table.insert(result, _tempData)
  end
  self.detailCtrl:ResetDatas(result)
end

function PackageEquipMemoryPage:Switch(show)
  if show then
    if not self.initPage then
      self:InitPage()
    end
    self.holder:SetActive(true)
    self:UpdateView()
  elseif self.initPage then
    self.holder:SetActive(false)
  end
end

function PackageEquipMemoryPage:Open()
  if self.initPage == false then
    self:InitPage()
  end
end

function PackageEquipMemoryPage:Close()
end

function PackageEquipMemoryPage:HandleSwitchSingle(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.effectGrid:Reposition()
end
