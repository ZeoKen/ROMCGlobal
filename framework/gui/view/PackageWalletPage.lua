autoImport("ItemNormalList")
autoImport("PackageWalletCombineItemCell")
PackageWalletPage = class("PackageWalletPage", SubView)
local FilterEnum = {
  All = 1,
  Account = 2,
  Role = 3
}
local PREFAB_PATH = "part/PackageWalletPage"
local FIXED_OFFSET = {-210, 0}
local fixedBgWidth = 10
local descSP = {
  ZhString.PackageWallet_OnlyRole,
  ZhString.PackageWallet_ShowAll,
  "com_btn_7",
  "com_btn_drop-down"
}
PackageWalletPage.WalletID = "wallet"

function PackageWalletPage:Init()
  self.gameObject = self:FindGO("PackageWalletRoot")
  self:AddEvts()
  self.pageInited = false
end

function PackageWalletPage:Show()
  if not self.pageInited then
    self:LoadSelf()
    self:InitView()
    self.pageInited = true
  end
  PackageWalletPage.packageContainer = self.container.__cname == "PackageView"
  self:_UpdateTab(1)
  self:ChooseFilter(FilterEnum.All)
  self.itemlist:UpdateList(false)
  self.gameObject:SetActive(true)
  self.entered = true
end

function PackageWalletPage:Hide()
  if self.pageInited then
    self.gameObject:SetActive(false)
  end
end

function PackageWalletPage:SeenRedTip()
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_WALLET)
  BagProxy.Instance:SetIsNewFlag(SceneItem_pb.EPACKTYPE_WALLET, false)
end

function PackageWalletPage:LoadSelf()
  local objPage = self:LoadPreferb(PREFAB_PATH, self.gameObject, true)
  objPage.transform.localPosition = LuaGeometry.GetTempVector3()
end

function PackageWalletPage:InitView()
  local listRoot = self:FindGO("ItemListRoot")
  self.itemlist = ItemNormalList.new(listRoot, PackageWalletCombineItemCell, true)
  self.itemlist.rowNum = 1
  self.itemlist.GetTabDatas = PackageWalletPage.GetTabDatas
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.OnClickItemTab, self)
  if self.container.__cname == "PackageView" then
    self.itemlist:AddEventListener(ItemEvent.ClickItem, self.OnClickPackageItem, self)
    self.itemlist:AddEventListener(ItemEvent.DoubleClickItem, self.OnDoubleClickItem, self)
    self.itemlist:UpdateTabList(ItemNormalList.TabType.Wallet)
  else
    self.itemlist:UpdateTabList(ItemNormalList.TabType.WalletSale)
  end
  self.itemCells = self.itemlist:GetItemCells()
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.emptyRoot)
  self.emptyLab.text = ZhString.PackageWallet_Empty
  self.emptyRoot:SetActive(false)
  self.newFilterBtn = self:FindComponent("NewFilterBtn", UISprite)
  self.allIcon = self:FindGO("All", self.newFilterBtn.gameObject)
  self.roleIcon = self:FindGO("Role", self.newFilterBtn.gameObject)
  self:AddClickEvent(self.newFilterBtn.gameObject, function()
    self:OnClickFilter()
  end)
  self.descLab = self:FindComponent("DescLab", UILabel, self.newFilterBtn.gameObject)
  self.descLabSp = self:FindComponent("Sp", UISprite, self.descLab.gameObject)
  self.descTweenAplha = self.descLab.gameObject:GetComponent(TweenAlpha)
end

function PackageWalletPage:ChooseFilter(filter)
  if PackageWalletPage.curFilter == filter then
    return
  end
  PackageWalletPage.curFilter = filter
  self.itemlist:UpdateList(false)
  self:RefreshFilterIcon()
  self:OnClickItemTab()
end

function PackageWalletPage:OnClickFilter()
  local desc
  if PackageWalletPage.curFilter == FilterEnum.All then
    self:ChooseFilter(FilterEnum.Role)
    desc = descSP[1]
  else
    self:ChooseFilter(FilterEnum.All)
    desc = descSP[2]
  end
  self.descLab.gameObject:SetActive(true)
  self.descLab.text = desc
  self.descLab.alpha = 1
  self.descLabSp.width = self.descLab.width + fixedBgWidth
  self.descTweenAplha.from = 1
  self.descTweenAplha.to = 0
  self.descTweenAplha.duration = 1.5
  self.descTweenAplha:ResetToBeginning()
  self.descTweenAplha:PlayForward()
end

function PackageWalletPage:RefreshFilterIcon()
  local isAll = PackageWalletPage.curFilter == FilterEnum.All
  self.allIcon:SetActive(isAll)
  self.roleIcon:SetActive(not isAll)
  local spname = isAll and descSP[3] or descSP[4]
  self.newFilterBtn.spriteName = spname
end

function PackageWalletPage.GetTabDatas(itemTabCfg, tabData)
  if PackageWalletPage.packageContainer then
    if itemTabCfg.fixed == 1 then
      BagProxy.Instance:InitMoneyItem()
      return BagProxy.Instance.moneyItems
    end
    return BagProxy.Instance:GetwalletBagData(itemTabCfg.index, PackageWalletPage.packageContainer, PackageWalletPage.curFilter)
  else
    return ShopSaleProxy.Instance:GetBagItemDatas(itemTabCfg)
  end
end

function PackageWalletPage:OnClickItemTab(cell)
  if not self.pageInited then
    return
  end
  local index = self.itemlist.nowTabData.index
  self.newFilterBtn.gameObject:SetActive(GameConfig.Wallet.ForbidFilter ~= 1 and PackageWalletPage.packageContainer and index ~= 1)
  local isEmpty = self.itemlist:IsEmpty()
  self.emptyRoot:SetActive(isEmpty)
  self:_clickTab(index)
end

local index2RedTip = {
  [2] = SceneTip_pb.EREDSYS_WALLET,
  [3] = SceneTip_pb.EREDSYS_WALLET_TYPE_PAGE
}

function PackageWalletPage:_clickTab(index)
  if not index then
    return
  end
  local red_tip = index2RedTip[index]
  if not red_tip then
    return
  end
  local redTipProxy = RedTipProxy.Instance
  if redTipProxy:InRedTip(red_tip) then
    redTipProxy:SeenNew(red_tip)
    self:SeenRedTip()
  end
end

function PackageWalletPage:AddEvts()
  self:AddListenEvt(ItemEvent.WalletUpdate, self.HandleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemQueryDebtItemCmd, self.HandleItemUpdate)
end

function PackageWalletPage:OnEnter()
  PackageWalletPage.super.OnEnter(self)
end

function PackageWalletPage:_UpdateTab(tab)
  local cells = self.itemlist.tabCtl:GetCells()
  if nil ~= cells then
    for k, v in pairs(cells) do
      v:SetTog(k == tab)
    end
  end
  self.itemlist:ChooseTab(tab)
end

function PackageWalletPage:OnExit()
  self.chooseId = nil
  self:ShowItemTip()
  self.entered = false
  self:_updateChoose()
  PackageWalletPage.super.OnExit(self)
end

function PackageWalletPage:HandleItemUpdate()
  if not self.pageInited then
    return
  end
  self.itemlist:UpdateList(true)
  self.emptyRoot:SetActive(self.itemlist:IsEmpty())
end

function PackageWalletPage:OnClickPackageItem(cellCtl)
  if not self.entered then
    return
  end
  local obj = cellCtl and cellCtl.gameObject
  local data = cellCtl and cellCtl.data
  if not data or not obj then
    return
  end
  local staticId = data.staticData and data.staticData.id
  if not staticId then
    return
  end
  local tipData
  if Game.Config_Wallet[staticId] and Game.Config_Wallet[staticId].Type == 1 then
    local id, bindid = staticId, GameConfig.BindItem[id]
    local bindid = GameConfig.BindItem[id]
    if bindid then
      tipData = {id, bindid}
    end
  end
  if self.chooseId ~= staticId then
    self.chooseId = staticId
    if tipData then
      TipManager.Instance:ShowBindWalletTip(tipData, cellCtl.bindTipStick)
    else
      self:ShowTip(data, {obj})
    end
  else
    self.chooseId = nil
    TipManager.Instance:CloseTip()
  end
  self:_updateChoose()
end

function PackageWalletPage:OnDoubleClickItem(cellCtl)
  local data = cellCtl.data
  if data and PackageWalletPage.WalletID ~= data.id then
    local curTime = ServerTime.CurServerTime() / 1000
    local func = FunctionItemFunc.Me():GetItemDefaultFunc(data, FunctionItemFunc_Source.MainBag, false)
    local isObsolete = data.deltime and data.deltime ~= 0 and 3 == data.staticData.ExistTimeType and curTime >= data.deltime
    if func and not isObsolete then
      func(data)
    end
    self:ShowTip()
    self.chooseId = nil
    self:_updateChoose()
  end
end

function PackageWalletPage:ShowTip(data, ignoreBounds)
  if not data or not self.pageInited then
    self:ShowItemTip()
    return
  end
  local callback = function()
    self.chooseId = nil
    self:_updateChoose()
  end
  local sdata = {
    itemdata = data,
    funcConfig = FunctionItemFunc.GetItemFuncIds(data.staticData.id, nil, false),
    ignoreBounds = ignoreBounds,
    callback = callback
  }
  self:ShowItemTip(sdata, self.tipStick, NGUIUtil.AnchorSide.Left, FIXED_OFFSET)
end

function PackageWalletPage:_updateChoose(id)
  if not self.pageInited then
    return
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end
