autoImport("CardMakeNewCell")
CardMakeNewPage = class("CardMakeNewPage", SubView)
CardMakeNewPage.CardNCellResPath = ResourcePathHelper.UICell("CardNNewCell")
local tempVector3 = LuaVector3.Zero()
local skipType = SKIPTYPE.CardMake
local filterItem = GameConfig.System.autobuy_noInspect
local Prefab_Path = ResourcePathHelper.UIView("CardMakeNewPage")
local BgName = "preview_bg_figure_03"
CardMakeNewPage.SortFilter = {
  [1] = ZhString.CardMake_NotOwned,
  [2] = ZhString.CardMake_Makeable
}

function CardMakeNewPage:OnExit()
  PictureManager.Instance:UnLoadUI(BgName, self.bgTex)
  self.targetCardCell:OnCellDestroy()
  if self.sortFilter then
    self.sortFilter:Destroy()
  end
  CardMakeNewPage.super.OnExit(self)
end

function CardMakeNewPage:Init(initParam)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  self.tabIndex = initParam
  self.skipType = skipType
  self:LoadPrefab()
  self:FindObjs()
  self:InitTitle()
  self:InitFilter()
  self:InitSortFilter()
  self:UpdateCard()
  self:SelectFirst()
end

function CardMakeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "CardMakeNewPage"
  self.gameObject = obj
end

function CardMakeNewPage:FindObjs()
  self.bgTex = self:FindComponent("TargetCardBg", UITexture)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.targetName = self:FindComponent("TargetName", UILabel)
  self.confirmButton = self:FindComponent("ConfirmButton", UIMultiSprite)
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
  end)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmButton.gameObject)
  self.cost = self:FindComponent("cost", UILabel)
  self.costIcon = self:FindGO("CoinIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.costIcon)
  self.filterBtn = self:FindGO("filterBtn")
  self.filterBtnSp = self.filterBtn:GetComponent(UISprite)
  local container = self:FindGO("CardContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 8,
    cellName = "CardMakeNewCell",
    control = CardMakeNewCell,
    dir = 1
  }
  self.wrapHelper = WrapCellHelper.new(wrapConfig)
  self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickCell, self)
  self.wrapHelper:AddEventListener(CardMakeEvent.Select, self.HandleSelect, self)
  local materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, CardMakeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  local targetCard = self:FindGO("TargetCard")
  local obj = self:FindGO("CardNNewCell")
  self.targetCardCell = CardNCell.new(obj)
  self.targetCardCell:Hide(self.targetCardCell.useButton.gameObject)
end

function CardMakeNewPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function CardMakeNewPage:OnEnter()
  PictureManager.Instance:SetUI(BgName, self.bgTex)
end

function CardMakeNewPage:InitTitle()
  local npcFunc = Table_NpcFunction[self.tabIndex]
  if npcFunc then
    self.titleLabel.text = npcFunc.NameZh
  end
end

function CardMakeNewPage:InitFilter()
  local filters = self:GetFilters()
  self.filterTipData = {
    callback = self.FilterPropCallback,
    param = self,
    curCustomProps = nil,
    curPropData = nil,
    curKeys = nil,
    customTitle = ZhString.CardMake_PartTitle,
    customProps = filters
  }
  self:AddClickEvent(self.filterBtn, function()
    TipManager.Instance:ShowNewPropTypeTip(self.filterTipData, self.filterBtnSp, NGUIUtil.AnchorSide.AnchorSide, {90, -50})
  end)
end

function CardMakeNewPage:InitSortFilter()
  local go = self:FindGO("SortPop")
  local panel = self:FindComponent("ScrollView", UIPanel)
  self.sortFilter = PopupGridList.new(go, function(self, data)
    self:OnSortChoose(self, data)
  end, self, panel.depth + 2)
  local list = CardMakeNewPage.SortFilter
  local datas = {}
  for i = 1, #list do
    local data = {}
    data.index = i
    data.text = list[i]
    datas[i] = data
  end
  self.sortFilter:SetData(datas)
end

function CardMakeNewPage:Show()
  self.gameObject:SetActive(true)
  self:UpdateCard()
  self:SelectFirst()
end

function CardMakeNewPage:GetFilters()
  return GameConfig.CardMake.MakeFilter
end

function CardMakeNewPage:FilterPropCallback(customProp, propData, keys)
  if self.filterTipData then
    self.filterTipData.curCustomProps = customProp
    self.filterTipData.curPropData = propData
    self.filterTipData.curKeys = keys
  end
  self:UpdateCard()
  self:SelectFirst()
end

function CardMakeNewPage:OnSortChoose(self, data)
  if not data then
    return
  end
  local isOwned = data.index == 1
  local isMakeable = data.index == 2
  redlog("OnSortChoose", data.text, tostring(isOwned), tostring(isMakeable))
  CardMakeProxy.Instance:SetMakeSortParam(isOwned, isMakeable)
  self:UpdateCard()
  self:SelectFirst()
end

function CardMakeNewPage:UpdateCard()
  local items = CardMakeProxy.Instance:FilterCardByTypes(self.filterTipData.curCustomProps)
  local data = CardMakeProxy.Instance:getItemsByFilterData(items, self.filterTipData.curPropData, self.filterTipData.curKeys)
  if data then
    self.wrapHelper:UpdateInfo(data, true)
  end
end

function CardMakeNewPage:UpdateMaterial(data)
  if data then
    self.materialCtl:ResetDatas(data.materialItems)
  end
end

function CardMakeNewPage:SelectFirst()
  local cells = self.wrapHelper:GetCellCtls()
  local first = cells[1]
  if first then
    self:HandleClickCell(first)
  end
end

function CardMakeNewPage:HandleClickCell(cell)
  local data = cell.data
  if data then
    if self.curChooseId == data.id then
      return
    end
    self:ClearChooseCard()
    self:ClearChooseData()
    cell:SetChoose(true)
    CardMakeProxy.Instance:SetChoose(data)
    self.curChooseId = data.id
    self.targetName.text = data.itemData.staticData.NameZh
    local path = ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. data.itemData.cardInfo.Picture)
    local chooseState = Game.AssetLoadEventDispatcher:IsFileExist(path) == 0
    if self.targetCardCell.use ~= nil then
      chooseState = self.targetCardCell.use
    end
    self.targetCardCell:SetData(data.itemData, chooseState)
    self:UpdateMaterial(data)
    local composeData = Table_Compose[data.id]
    self.cost.text = StringUtil.NumThousandFormat(composeData.ROB)
    self:UpdateConfirmBtn()
  end
end

function CardMakeNewPage:HandleSelect(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function CardMakeNewPage:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function CardMakeNewPage:HandleItemUpdate()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    self:UpdateMaterial(chooseData)
    self:UpdateConfirmBtn()
  end
end

function CardMakeNewPage:HandleRemoveNpc(note)
  local data = note.body
  if data and 0 < #data then
    for i = 1, #data do
      if self.npcId == data[i] then
        self:CloseSelf()
        break
      end
    end
  end
end

function CardMakeNewPage:UpdateConfirmBtn()
  self.canMake = CardMakeProxy.Instance:CanMake()
  self:SetConfirm(not self.canMake)
end

function CardMakeNewPage:Confirm()
  if self.canMake then
    local chooseData = CardMakeProxy.Instance:GetChoose()
    local data = Table_Compose[chooseData.id]
    if MyselfProxy.Instance:GetROB() < data.ROB then
      MsgManager.ShowMsgByID(1)
      return
    end
    local materialItems = chooseData:GetMaterials() or {}
    local mItem
    local neededItems = {}
    for i = 1, #materialItems do
      mItem = materialItems[i]
      if mItem.id ~= filterItem and not chooseData:CheckMaterialSlotCanMake(i) then
        local neededItem = {
          id = mItem.id,
          count = chooseData:GetNeedMaterialNumBySlotId(i)
        }
        table.insert(neededItems, neededItem)
      end
    end
    if #neededItems ~= 0 then
      QuickBuyProxy.Instance:TryOpenView(neededItems)
      return
    end
    for i = 1, #materialItems do
      mItem = materialItems[i]
      if not chooseData:CheckMaterialSlotCanMake(i) then
        MsgManager.ShowMsgByIDTable(3004)
        return
      end
    end
    local noTrade = false
    for i = 1, #materialItems do
      local material = materialItems[i]
      if material.itemData:IsCard() then
        local count = material.itemData.num
        local result = CardMakeProxy.Instance:GetItemsByStaticIDAndPredicate(material.id, function(item, args)
          return item:CanTrade()
        end)
        local num = 0
        for i = 1, #result do
          num = num + result[i].num
        end
        if count > num then
          noTrade = true
          break
        end
      end
    end
    local confirmAgain = function()
      if CardMakeProxy.Instance:IsCostGreatCard(chooseData.id) then
        MsgManager.ConfirmMsgByID(1150, function()
          self:CallExchangeCardItem()
        end)
      else
        self:CallExchangeCardItem()
      end
    end
    if noTrade then
      MsgManager.ConfirmMsgByID(43494, function()
        confirmAgain()
      end)
    else
      confirmAgain()
    end
  end
end

function CardMakeNewPage:CallExchangeCardItem()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Compose, self.npcId, nil, nil, {
    chooseData.itemData.staticData.id
  }, skipValue)
end

function CardMakeNewPage:SetConfirm(isGray)
  if isGray then
    self.confirmButton.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
  else
    self.confirmButton.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
  end
end

function CardMakeNewPage:ClearChooseCard()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    local cell
    local cells = self.wrapHelper:GetCellCtls()
    for i = 1, #cells do
      cell = cells[i]
      if cell.data and cell.data.id == chooseData.id then
        cell:SetChoose(false)
        break
      end
    end
  end
end

function CardMakeNewPage:ClearChooseData()
  local chooseData = CardMakeProxy.Instance:GetChoose()
  if chooseData then
    local data = CardMakeProxy.Instance:GetCard()
    if data then
      for i = 1, #data do
        if data[i].id == chooseData.id then
          data[i]:SetChoose(false)
          break
        end
      end
    end
  end
end

function CardMakeNewPage:CloseSelf()
  self.container:CloseSelf()
end
