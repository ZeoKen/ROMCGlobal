autoImport("ComodoBuildingMusicBoxListCell")
ComodoBuildingMusicBoxView = class("ComodoBuildingMusicBoxView", BaseView)
ComodoBuildingMusicBoxView.ViewType = UIViewType.NormalLayer
ComodoBuildingMusicBoxView.ViewMaskAdaption = {left = 1, right = 1}
local shopIns

function ComodoBuildingMusicBoxView:Init()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
  end
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function ComodoBuildingMusicBoxView:FindObjs()
  self.costSp = self:FindComponent("CostCtrl", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.skipBtnSp = self:FindComponent("SkipSprite", UISprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel)
  self.actionIcon = self:FindComponent("ActionIcon", UISprite)
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.lotteryContainer = self:FindGO("LotteryContainer")
end

function ComodoBuildingMusicBoxView:InitView()
  IconManager:SetUIIcon("tab_icon_98", self.skipBtnSp)
  self.costItemId, self.costNum = GameConfig.Manor.LotteryCostItemID, GameConfig.Manor.LotteryCostItemCount
  IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costSp)
  IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.actionIcon)
  self.actionLabel.text = self.costNum
  self.itemCtrl = WrapListCtrl.new(self.lotteryContainer, ComodoBuildingMusicBoxListCell, "ComodoBuildingMusicBoxListCell", nil, nil, nil, nil, 2)
  self.itemCtrl:AddEventListener(HappyShopEvent.SelectIconSprite, self.OnClickIcon, self)
  self.tipData.ignoreBounds = {
    self.lotteryContainer
  }
end

local skipAnimTipOffset = {120, 50}

function ComodoBuildingMusicBoxView:AddEvents()
  local buttonobj = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(35067, nil, buttonobj)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.ComodoMusicBox, self.skipBtnSp, NGUIUtil.AnchorSide.Top, skipAnimTipOffset)
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self:CheckCost() then
      MsgManager.ShowMsgByIDTable(25418, Table_Item[self.costItemId].NameZh)
      return
    end
    if self.clickDisabled then
      return
    end
    self:TryPlayAnimThenCall(self.DoLottery)
  end)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function ComodoBuildingMusicBoxView:OnEnter()
  ComodoBuildingMusicBoxView.super.OnEnter(self)
  local npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcInfo then
    self.npcRole = npcInfo.assetRole
    self:CameraFocusOnNpc(self.npcRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  self:UpdateList()
  self:OnItemUpdate()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.TeamLayer)
end

function ComodoBuildingMusicBoxView:OnExit()
  self:CameraReset()
  TimeTickManager.Me():ClearTick(self)
  ComodoBuildingMusicBoxView.super.OnExit(self)
end

function ComodoBuildingMusicBoxView:OnItemUpdate()
  self:UpdateCostCtrl()
  self:UpdatePrice()
end

local tipOffset = {-210, 0}

function ComodoBuildingMusicBoxView:OnClickIcon(cellCtrl)
  if cellCtrl and cellCtrl.itemData then
    self.tipData.itemdata = cellCtrl.itemData
    self:ShowItemTip(self.tipData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
  end
end

function ComodoBuildingMusicBoxView:UpdateCostCtrl()
  self.costLabel.text = tostring(shopIns:GetItemNum(self.costItemId)) or 0
end

local actionLabelEnoughColor, actionLabelNotEnoughColor = LuaColor.New(0.3176470588235294, 0.3764705882352941, 0.5058823529411764), LuaColor.New(1, 0.3764705882352941, 0.12941176470588237)

function ComodoBuildingMusicBoxView:UpdatePrice()
  self.actionLabel.color = self:CheckCost() and LuaGeometry.GetTempColor() or actionLabelNotEnoughColor
  self.actionLabel.effectColor = self:CheckCost() and actionLabelEnoughColor or LuaGeometry.GetTempColor()
end

function ComodoBuildingMusicBoxView:UpdateList()
  self.itemCtrl:ResetDatas(Table_ManorLottery)
end

function ComodoBuildingMusicBoxView:TryPlayAnimThenCall(func)
  self.clickDisabled = true
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.ComodoMusicBox) then
    func(self)
  else
    local anime = Table_SceneBossAnime[208]
    if anime then
      Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:PlayAnimation(anime.ObjID, anime.Name)
    end
    TimeTickManager.Me():CreateOnceDelayTick(2000, func, self)
  end
end

function ComodoBuildingMusicBoxView:DoLottery()
  ComodoBuildingProxy.Lottery()
  self.clickDisabled = nil
end

function ComodoBuildingMusicBoxView:CheckCost()
  return shopIns:GetItemNum(self.costItemId) >= self.costNum
end
