autoImport("CoreView")
FoodPackagePart = class("FoodPackagePart", CoreView)
autoImport("BagItemCell")
autoImport("WrapListCtrl")
local TABCONFIG = {
  [1] = {Config = nil}
}
local FoodPackPage = GameConfig.FoodPackPage or _EmptyTable
for i = 1, #FoodPackPage do
  table.insert(TABCONFIG, {
    Config = FoodPackPage[i]
  })
end

function FoodPackagePart:ctor()
end

local FoodPackagePart_Path = "GUI/v1/part/FoodPackagePart"

function FoodPackagePart:CreateSelf(parent)
  if self.inited == true then
    return
  end
  self.inited = true
  self.gameObject = self:LoadPreferb_ByFullPath(FoodPackagePart_Path, parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
end

function FoodPackagePart:InitPart()
  self.waitting = self:FindComponent("Waitting", UILabel)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  self.panel = self.scrollView.gameObject:GetComponent(UIPanel)
  
  function self.scrollView.OnBackToStop()
    self.waitting.text = ZhString.ItemNormalList_Refreshing
  end
  
  function self.scrollView.OnStop()
    self.scrollView:Revert()
    ServiceItemProxy.Instance:CallPackageSort(SceneItem_pb.EPACKTYPE_FOOD)
  end
  
  function self.scrollView.OnPulling(offsetY, triggerY)
    self.waitting.text = offsetY < triggerY and ZhString.ItemNormalList_PullRefresh or ZhString.ItemNormalList_CanRefresh
  end
  
  function self.scrollView.OnRevertFinished()
    self.waitting.text = ZhString.ItemNormalList_PullRefresh
  end
  
  local container = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(container, BagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 4, 100)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.tabMap = {}
  for i = 1, #TABCONFIG do
    local obj = self:FindGO("ItemTab" .. i)
    local comps = UIUtil.GetAllComponentsInChildren(obj, UISprite)
    for i = 1, #comps do
      comps[i]:MakePixelPerfect()
    end
    local index = i
    self:AddClickEvent(obj, function(go)
      self.nowTab = index
      self:UpdateInfo(true)
    end)
    self.tabMap[i] = obj:GetComponent(UIToggle)
  end
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:Hide()
  end)
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.noneTip = self:FindGO("NoneTip")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
end

function FoodPackagePart:UpdateInfo(noResetPos)
  local foodBagData = BagProxy.Instance.foodBagData
  if foodBagData == nil then
    return
  end
  local index = self.nowTab or 1
  local config = TABCONFIG[index].Config
  local items = foodBagData:GetItems(config)
  if #items == 0 then
    self.noneTip:SetActive(true)
    self.scrollView.gameObject:SetActive(false)
    return
  else
    self.noneTip:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
  end
  self.itemCtrl:ResetDatas(foodBagData:GetItems(config), noResetPos)
end

function FoodPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function FoodPackagePart:ClickItemCell(cellCtl)
  local go = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowPackageItemTip(data, go)
  else
    self.chooseId = 0
    self:ShowPackageItemTip()
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function FoodPackagePart:ShowPackageItemTip(data, cellGO)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local offset = {}
  local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, cellGO.transform, Space.World)
  if 0 < x then
    offset[1] = -650
    offset[2] = 0
  else
    offset[1] = 190
    offset[2] = 0
  end
  local callback = function()
    self.chooseId = 0
    for _, cell in pairs(self.itemCells) do
      cell:SetChooseId(self.chooseId)
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback,
    funcConfig = FunctionItemFunc.GetItemFuncIds(data.staticData.id)
  }
  local itemtip = self:ShowItemTip(sdata, self.normalStick, NGUIUtil.AnchorSide.Right, offset)
  itemtip:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(itemtip.gameObject)
end

function FoodPackagePart:SetPos(x, y, z)
  if self.gameObject then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, z)
    self:UpdateLocalPosCache()
  end
end

function FoodPackagePart:UpdateLocalPosCache()
  self.localPos_x, self.localPos_y, self.localPos_z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
end

function FoodPackagePart:SetLocalOffset(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.localPos_x + x, self.localPos_y + y, self.localPos_z + z)
end

function FoodPackagePart:MapEvent()
end

function FoodPackagePart:Show()
  if not self.inited then
    return
  end
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ItemEvent.FoodUpdate, self.UpdateInfo, self)
  self:UpdateInfo()
  self.itemCtrl:ResetPosition()
end

function FoodPackagePart:Hide()
  if not self.inited then
    return
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_FOOD)
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.FoodUpdate, self.UpdateInfo, self)
end
