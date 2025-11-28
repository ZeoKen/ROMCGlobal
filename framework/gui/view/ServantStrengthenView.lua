autoImport("WrapCellHelper")
autoImport("ServantStrengthenCell")
ServantStrengthenView = class("ServantStrengthenView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ServantStrengthenView")
local _strenghtenProxy = ServantStrengthenProxy.Instance

function ServantStrengthenView:Init()
  self:FindObjs()
  self:OpenUI()
end

function ServantStrengthenView:FindObjs()
  self:LoadSubView()
  self.itemRoot = self:FindGO("Wrap")
end

function ServantStrengthenView:LoadSubView()
  local container = self:FindGO("strengthenView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantStrengthenView"
end

function ServantStrengthenView:OnEnter()
  ServantStrengthenView.super.OnEnter(self)
end

function ServantStrengthenView:OnExit()
  ServantStrengthenView.super.OnExit(self)
end

function ServantStrengthenView:OpenUI()
  local viewData = _strenghtenProxy:GetData()
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.itemRoot,
      pfbNum = 6,
      cellName = "ServantStrengthenCell",
      control = ServantStrengthenCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  end
  if viewData and 0 < #viewData then
    self:Show(self.itemRoot)
    self.itemWrapHelper:UpdateInfo(viewData)
  else
    self:Hide(self.itemRoot)
  end
end
