autoImport("BossComposeCardCell")
autoImport("BossCardComposeMaterialCell")
BossCardComposeNewPage = class("BossCardComposeNewPage", SubView)
local maxCount = GameConfig.Card.exchangecard_boss
local maxComposeNum = 100
local skipType = SKIPTYPE.BossCardCompose
local Prefab_Path = ResourcePathHelper.UIView("BossCardComposeNewPage")
local BgName = "preview_bg_figure_03"

function BossCardComposeNewPage:Init(initParam)
  local chooseData = CardMakeData.new(2000)
  CardMakeProxy.Instance:SetChoose(chooseData)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.npcId = self.viewdata.viewdata and self.viewdata.viewdata.npcdata and self.viewdata.viewdata.npcdata.data.id
  self.tabIndex = initParam
  self.skipType = skipType
  self.composeNum = 1
  self:LoadPrefab()
  self:FindObjs()
  self:InitTitle()
  self:InitFilter()
  self:InitMaterial()
  self:UpdateRemainInfo()
  self:UpdateComposeNum()
  self:InitCardList()
end

function BossCardComposeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "BossCardComposeNewPage"
  self.gameObject = obj
end

function BossCardComposeNewPage:FindObjs()
  self.bgTex = self:FindComponent("TargetCardBg", UITexture)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.filterBtn = self:FindGO("filterBtn")
  self.filterBtnSp = self.filterBtn:GetComponent(UISprite)
  local container = self:FindGO("CardContainer")
  self.cardListCtl = WrapListCtrl.new(container, BossComposeCardCell, "BagCardCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.cardListCtl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, BossCardComposeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  self.remainLabel = self:FindComponent("remainNum", UILabel)
  self.confirmBtn = self:FindComponent("ConfirmButton", UIMultiSprite)
  self:AddClickEvent(self.confirmBtn.gameObject, function()
    self:Confirm()
  end)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmBtn.gameObject)
  self.addBtn = self:FindGO("addBtn")
  self:AddClickEvent(self.addBtn, function()
    self:OnAddBtnClick()
  end)
  self.reduceBtn = self:FindGO("reduceBtn")
  self:AddClickEvent(self.reduceBtn, function()
    self:OnReduceBtnClick()
  end)
  self.composeNumLabel = self:FindComponent("composeNum", UILabel)
  local helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(helpBtn, function()
    self:OnHelpBtnClick()
  end)
end

function BossCardComposeNewPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateRemainInfo)
end

function BossCardComposeNewPage:OnEnter()
  PictureManager.Instance:SetUI(BgName, self.bgTex)
end

function BossCardComposeNewPage:OnExit()
  PictureManager.Instance:UnLoadUI(BgName, self.bgTex)
end

function BossCardComposeNewPage:InitTitle()
  local npcFunc = Table_NpcFunction[self.tabIndex]
  if npcFunc then
    self.titleLabel.text = npcFunc.NameZh
  end
end

function BossCardComposeNewPage:InitFilter()
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

function BossCardComposeNewPage:GetFilters()
  return GameConfig.CardMake.MakeFilter
end

function BossCardComposeNewPage:InitCardList()
  self:UpdateCardList()
end

function BossCardComposeNewPage:InitMaterial()
  local beCostItem = GameConfig.Card.BossCardComposeMaterial
  if beCostItem then
    self.materialItems = {}
    for i = 1, #beCostItem do
      local costItem = beCostItem[i]
      local data = CardMakeMaterialData.new({
        id = costItem[1],
        num = costItem[2]
      }, i)
      TableUtility.ArrayPushBack(self.materialItems, data)
    end
  end
  self:UpdateMaterial()
end

function BossCardComposeNewPage:FilterPropCallback(customProp, propData, keys)
  if self.filterTipData then
    self.filterTipData.curCustomProps = customProp
    self.filterTipData.curPropData = propData
    self.filterTipData.curKeys = keys
  end
  self:UpdateCardList()
end

function BossCardComposeNewPage:OnSelectLongPress(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.widget, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function BossCardComposeNewPage:HandleMaterialTip(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function BossCardComposeNewPage:UpdateCardList()
  local items = CardMakeProxy.Instance:FilterBossComposeCardByTypes(self.filterTipData.curCustomProps)
  local data = AdventureDataProxy.Instance:getItemsByFilterData(nil, items, self.filterTipData.curPropData, self.filterTipData.curKeys)
  if data and 0 < #data then
    self.cardListCtl:ResetDatas(data)
  end
end

function BossCardComposeNewPage:UpdateMaterial()
  if self.materialItems then
    for i = 1, #self.materialItems do
      local data = self.materialItems[i]
      data.itemData.num = data.costNum * self.composeNum
    end
    self.materialCtl:ResetDatas(self.materialItems)
  end
  self:UpdateConfirmBtn()
end

function BossCardComposeNewPage:UpdateRemainInfo()
  local count = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_EXCHANGECARD_BOSS) or 0
  count = maxCount - count
  if count < 0 then
    count = 0
  end
  redlog("BossCardComposeNewPage:UpdateRemainInfo", count, maxCount)
  self.remainLabel.text = string.format(ZhString.CardMake_RandomRemainTip, count, maxCount)
end

function BossCardComposeNewPage:UpdateConfirmBtn()
  self:SetConfirm(not self:CanMake())
end

function BossCardComposeNewPage:HandleItemUpdate()
  self:UpdateMaterial()
end

function BossCardComposeNewPage:HandleRemoveNpc(note)
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

function BossCardComposeNewPage:CanMake()
  if self.materialItems then
    for i = 1, #self.materialItems do
      local material = self.materialItems[i]
      local myNum = 0
      if material.id == GameConfig.MoneyId.Zeny then
        myNum = MyselfProxy.Instance:GetROB()
      else
        myNum = CardMakeProxy.Instance:GetItemNumByStaticID(material.id)
      end
      if myNum < material.itemData.num then
        return false
      end
    end
  end
  return true
end

function BossCardComposeNewPage:Confirm()
  if self:CanMake() then
    self:CallExchangeCardItem()
  end
end

function BossCardComposeNewPage:CallExchangeCardItem()
  local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.BossCompose, self.npcId, nil, nil, nil, not skipValue, nil, self.composeNum)
end

function BossCardComposeNewPage:SetConfirm(isGray)
  if isGray then
    self.confirmBtn.CurrentState = 1
    self.confirmLabel.effectStyle = UILabel.Effect.None
  else
    self.confirmBtn.CurrentState = 0
    self.confirmLabel.effectStyle = UILabel.Effect.Outline
  end
end

function BossCardComposeNewPage:CloseSelf()
  self.container:CloseSelf()
end

function BossCardComposeNewPage:OnAddBtnClick()
  self.composeNum = self.composeNum + 1
  self:UpdateComposeNum()
  self:UpdateMaterial()
end

function BossCardComposeNewPage:OnReduceBtnClick()
  self.composeNum = self.composeNum - 1
  self:UpdateComposeNum()
  self:UpdateMaterial()
end

function BossCardComposeNewPage:UpdateComposeNum()
  local count = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_EXCHANGECARD_BOSS) or 0
  count = math.max(maxCount - count, 1)
  if self.materialItems then
    for i = 1, #self.materialItems do
      local material = self.materialItems[i]
      local ownNum = 0
      if material.id == GameConfig.MoneyId.Zeny then
        ownNum = MyselfProxy.Instance:GetROB()
      else
        ownNum = CardMakeProxy.Instance:GetItemNumByStaticID(material.id)
      end
      count = math.min(math.floor(ownNum / material.costNum), count)
    end
  end
  self.composeNum = math.min(count, self.composeNum)
  self.composeNum = math.clamp(self.composeNum, 1, maxComposeNum)
  self.composeNumLabel.text = self.composeNum
end

function BossCardComposeNewPage:OnHelpBtnClick()
  local helpData = Table_Help[32598]
  if helpData then
    TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
  end
end
