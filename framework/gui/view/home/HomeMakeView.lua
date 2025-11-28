autoImport("BaseView")
autoImport("HomeMakeCell")
HomeMakeView = class("HomeMakeView", BaseView)
HomeMakeView.ViewType = UIViewType.NormalLayer
HomeMakeView.PosConfig = {
  LeftGrid = Vector3(-372, 0, 0),
  MidGrid = Vector3.zero
}
local HomeMake_BagCheckTypes, bagProxy

function HomeMakeView:Init()
  self:InitView()
  self:MapEvent()
  HomeMake_BagCheckTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
  bagProxy = BagProxy.Instance
end

function HomeMakeView:InitView()
  self.mainBord = self:FindGO("MainBord")
  self.blackBg = self:FindComponent("BlackBg", UISprite)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.grid = self:FindComponent("HomeMakeGrid", UIGrid)
  self.homeMakeCtl = UIGridListCtrl.new(self.grid, HomeMakeCell, "HomeMakeCell")
  self.homeMakeCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCombine, self)
  self.homeMakeCtl:AddEventListener(HomeMakeCell.ClickMaterial, self.ClickMaterial, self)
  self.homeMakeCtl:AddEventListener(HomeMakeCell.ClickToItem, self.ClickMaterial, self)
end

function HomeMakeView:ShowHomeMakeItemTip(data, obj)
  if data == self.chooseData then
    self.chooseData = nil
    TipManager.Instance:CloseItemTip()
  else
    self.chooseData = data
    local callback = function()
      self.chooseData = nil
    end
    local tipData = {
      itemdata = data,
      funcConfig = {},
      callback = callback,
      ignoreBounds = {obj}
    }
    local stick = UIUtil.GetAllComponentInChildren(obj, UIWidget)
    self:ShowItemTip(tipData, stick, NGUIUtil.AnchorSide.Left, {300, 0})
  end
end

function HomeMakeView:UpdateDatas(datas)
  datas = datas or {}
  table.sort(datas, HomeMakeView.SortHomeData)
  self.homeMakeCtl:ResetDatas(datas)
end

function HomeMakeView.SortHomeData(a, b)
  local aComposeId, bComposeId = a.staticData.ComposeID, b.staticData.ComposeID
  if aComposeId and bComposeId and aComposeId ~= bComposeId then
    local aCData, bCData = Table_Compose[aComposeId], Table_Compose[bComposeId]
    if aCData and bCData then
      local aCanCompose, bCanCompose = true, true
      for i = 1, #aCData.BeCostItem do
        local material = aCData.BeCostItem[i]
        local num = bagProxy:GetItemNumByStaticID(material.id, HomeMake_BagCheckTypes)
        if num < material.num then
          aCanCompose = false
          break
        end
      end
      for i = 1, #bCData.BeCostItem do
        local material = bCData.BeCostItem[i]
        local num = bagProxy:GetItemNumByStaticID(material.id, HomeMake_BagCheckTypes)
        if num < material.num then
          bCanCompose = false
          break
        end
      end
      if aCanCompose ~= bCanCompose then
        return aCanCompose
      end
      local aProduce, bProduce = aCData.Product.id, bCData.Product.id
      if aProduce and bProduce and aProduce ~= bProduce then
        local aPItem, bPItem = Table_Item[aProduce], Table_Item[bProduce]
        if aPItem and bPItem and aPItem.AdventureValue and aPItem.AdventureValue > 0 and bPItem.AdventureValue and bPItem.AdventureValue > 0 and aPItem.AdventureValue ~= bPItem.AdventureValue then
          return aPItem.AdventureValue < bPItem.AdventureValue
        end
      end
    end
  end
  if a.staticData.Quality ~= b.staticData.Quality then
    return a.staticData.Quality > b.staticData.Quality
  end
  return a.staticData.id > b.staticData.id
end

function HomeMakeView:PlayPicMakeAnim()
  self:ActiveView(false)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(4000, function(owner, deltaTime)
    self:HomeMakeDone()
  end, self)
end

function HomeMakeView:HomeMakeDone()
  FunctionVisitNpc.Me():AccessTarget(self.npcinfo)
  self:CloseSelf()
end

function HomeMakeView:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleUpdateMaterial)
end

function HomeMakeView:HandleUpdateMaterial(note)
  local cells = self.homeMakeCtl:GetCells()
  for i = 1, #cells do
    cells[i]:Refresh()
  end
end

function HomeMakeView:OnEnter()
  HomeMakeView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    if type(viewdata) == "number" then
      if self.datas == nil then
        self.datas = {}
      end
      self.datas.composeId = viewdata
    else
      self.datas = viewdata.datas
      self.npcinfo = viewdata.npcdata
    end
  end
  self:UpdateDatas(self.datas)
end

function HomeMakeView:OnShow()
  self.scrollView:ResetPosition()
end

function HomeMakeView:OnExit()
  HomeMakeView.super.OnExit(self)
  local cells = self.homeMakeCtl:GetCells()
  for i = 1, #cells do
    cells[i]:OnRemove()
  end
end
