GameConfig.AncientUpgradeFilter = GameConfig.EquipRefineFilter
autoImport("AncientUpgradeBord")
autoImport("EquipNewChooseBord")
autoImport("CommonNewTabListCell")
autoImport("BagItemNewCell")
autoImport("DecomposeItemCell")
AncientUpgradePanel = class("AncientUpgradePanel", ContainerView)
autoImport("AncientRandomCombineView")
AncientUpgradePanel.BrotherView = AncientRandomCombineView
AncientUpgradePanel.ViewType = UIViewType.NormalLayer
AncientUpgradePanel.RefineBordControl = AncientUpgradeBord
AncientUpgradePanel.PfbPath = "part/AncientUpgradeBord"
AncientUpgradePanel.TabName = {
  RandomTab = ZhString.AncientUpgrade_MainTabName
}
AncientUpgradePanel.m_helpId = 35266
local npcRefineAction = "functional_action"
local blackSmith
local tempVector3 = LuaVector3()
local CHOOSECOLOR = LuaColor(0.3607843137254902, 0.3843137254901961, 0.5647058823529412, 1)
local UNCHOOSECOLOR = LuaColor.White()

function AncientUpgradePanel:Init()
  if not blackSmith then
    blackSmith = BlackSmithProxy.Instance
  end
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.isfashion = false
  self:InitView()
  self:MapEvent()
end

function AncientUpgradePanel:InitView()
  self.leftSideBar = self:FindGO("LeftSideBar")
  self.leftSideBar:SetActive(self.isCombine ~= true)
  self.bg = self:FindComponent("PanelBg", UISprite)
  self.colliderMask = self:FindGO("ColliderMask")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(self.chooseContainer)
  self.chooseBord:SetFilterPopData(GameConfig.AncientUpgradeFilter)
  self.chooseBord:Hide()
  local cells = self.chooseBord.chooseCtl:GetCells()
  for _, c in pairs(cells) do
    c:SetShowStrengthLvOfItem(false)
  end
  self.tabGrid = self:FindGO("TabGrid")
  self.refineBord = self:FindGO("RandomParent")
  self.refineTab = self:FindGO("RandomTab")
  self.refineTabCell = CommonNewTabListCell.new(self.refineTab)
  self.refineTabCell:SetIcon("tab_icon_random")
  self.refineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickRefineTab, self)
  local userRob = self:FindGO("Silver")
  local symbol = self:FindComponent("symbol", UISprite, userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.robLabel = self:FindComponent("Label", UILabel, userRob)
  self:AddButtonEvent("SilverAddBtn", function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
  self:LoadPreferb(self.PfbPath, self.refineBord, true)
  self.bord_Control = self.RefineBordControl.new(self.refineBord, self.isfashion)
  self.bord_Control:AddEventListener(AncientUpgradeBord_Event.ClickTargetCell, self.ClickAddEquipButtonCall, self)
  self.bord_Control:AddEventListener(AncientUpgradeBord_Event.DoRefine, self.DoRefineCall, self)
  self.leftTipBord = self:FindGO("LeftTipBord")
  self.leftTipBord_tip = self:FindComponent("RefineTip", UILabel, self.leftTipBord)
  self.leftTipBord_ShareBtn = self:FindGO("ShareBtn", self.leftTipBord)
  self.leftTipBord_ShareBtn:SetActive(false)
  self:AddClickEvent(self.leftTipBord_ShareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    local nowData = self.bord_Control:GetNowItemData()
    FloatAwardView.ShowRefineShareViewNew(nowData)
    self.leftTipBord_ShareBtn:SetActive(false)
  end)
  local tabList, longPress = {
    self.refineTab
  }
  for _, v in ipairs(tabList) do
    longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.AncientUpgradePanel, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.AncientUpgradePanel, self.HandleLongPress, self)
  self:InitShopEnter()
end

function AncientUpgradePanel:InitShopEnter()
  self.shopEnterBtn = self:FindGO("LeftSideBar/ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    self:SetPushToStack(true)
    HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
      npcdata = self.npcInfo,
      viewPort = CameraConfig.SwingMachine_ViewPort,
      rotation = CameraConfig.SwingMachine_Rotation
    })
  end)
end

function AncientUpgradePanel:OnClickRefineTab()
  self.refineBord:SetActive(true)
  self.bord_Control:HideAllChooseBord()
  self:SetTargetItem(nil)
  self.chooseBord:Hide()
  self:ClickAddEquipButtonCall()
end

function AncientUpgradePanel:ClickAddEquipButtonCall(control)
  local datas = self:GetChooseBordDatas()
  self.chooseBord:ResetDatas(datas, true)
  self.chooseBord:Show(nil, function(self, data)
    self:SetTargetItem(data)
    self.chooseBord:Hide()
  end, self)
  local nowData = self.bord_Control:GetNowItemData()
  if nowData then
    self.chooseBord:SetChoose(nowData)
  end
  self.chooseBord:SetBordTitle(ZhString.NpcRefinePanel_ChooseEquip)
end

function AncientUpgradePanel:SetTargetItem(data)
  self.bord_Control:SetTargetItem(data)
  self:UpdateLeftTipBord(data)
end

function AncientUpgradePanel:UpdateLeftTipBord(data)
  if data and data.equipInfo then
    self.leftTipBord:SetActive(true)
    self.leftTipBord_tip.text = ZhString.AncientUpgrade_RefineTip
  else
    self.leftTipBord:SetActive(false)
  end
end

function AncientUpgradePanel:RemoveLeanTween()
  if self.lt then
    self.lt:Destroy()
  end
  self.lt = nil
end

local delay_time = 500

function AncientUpgradePanel:DoRefineCall(control)
  self:RemoveLeanTween()
  self:ActiveLock(true)
  self.wait_refresh = true
  local delayTime = delay_time or GameConfig.EquipRefine.delay_time
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
end

function AncientUpgradePanel:DoRepairCall(control)
  self:ActiveLock(true)
  self:RemoveLeanTween()
  self.wait_refresh = true
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    self.wait_refresh = false
    self:RepairEnd()
  end, self)
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
end

function AncientUpgradePanel:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function AncientUpgradePanel:ActiveLock(b)
  self.colliderMask:SetActive(b)
end

function AncientUpgradePanel:RefineEnd()
  self.leftTipBord_ShareBtn:SetActive(false)
  local needShare = false
  if self.result == true then
    needShare = true
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
  else
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinefail)
  end
  self.bord_Control:ShowTempResult(self.result)
  if AppBundleConfig.GetSocialShareInfo() == nil then
    needShare = false
  end
  needShare = false
  self.result = nil
  self:RemoveLeanTween()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(self)
    self:ActiveLock(false)
    self.bord_Control:Refresh()
    self:UpdateLeftTipBord(self.bord_Control:GetNowItemData())
    self.leftTipBord_ShareBtn:SetActive(false)
  end, self)
end

function AncientUpgradePanel:RepairEnd()
  local nowData = self.bord_Control:GetNowItemData()
  MsgManager.ShowMsgByIDTable(221, {
    nowData.staticData.NameZh
  })
  self.bord_Control:PlayEffect()
  local assetRole = Game.Myself.assetRole
  assetRole:PlayEffectOneShotOn(EffectMap.Maps.ForgingSuccess, RoleDefines_EP.Top)
  self:RemoveLeanTween()
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:ActiveLock(false)
    self.bord_Control:Refresh()
    self:UpdateLeftTipBord(self.bord_Control:GetNowItemData())
  end, self)
  AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
end

function AncientUpgradePanel:MapEvent()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ItemEquipPromote, self.RecvRefineResult)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RecvUpdateRefineInfo_Item)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.RecvUpdateRefineInfo_Equip)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
end

function AncientUpgradePanel:RecvUpdateRefineInfo_Item(note)
  if self.wait_refresh == true then
    return
  end
  if self.pending_item_update then
    local nowItem = self.bord_Control:GetNowItemData()
    if nowItem ~= nil then
      if nowItem.equiped ~= 0 then
        return
      end
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.EquipConvertResultView,
        viewdata = nowItem
      })
    end
    self.pending_item_update = nil
  end
  self.bord_Control:Refresh(true)
end

function AncientUpgradePanel:RecvUpdateRefineInfo_Equip(note)
  if self.wait_refresh == true then
    return
  end
  if self.pending_item_update then
    local nowItem = self.bord_Control:GetNowItemData()
    if nowItem ~= nil then
      if nowItem.equiped == 0 then
        return
      end
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.EquipConvertResultView,
        viewdata = nowItem
      })
    end
    self.pending_item_update = nil
  end
  self.bord_Control:Refresh(true)
end

function AncientUpgradePanel:RecvRefineResult(note)
  if self.bord_Control == nil then
    return
  end
  local nowItem = self.bord_Control:GetNowItemData()
  if nowItem == nil then
    return
  end
  self.result = true
  if self.wait_refresh then
    self.wait_refresh = false
    self:RefineEnd()
  end
  self.pending_item_update = true
end

function AncientUpgradePanel:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end

function AncientUpgradePanel:GetChooseBordDatas()
  return blackSmith:GetAncientUpgradeEquips(self.refine_equipxxx_map, self.isfashion)
end

function AncientUpgradePanel:InitValidRefineEquipType()
  self.refine_equipxxx_map = {}
  TableUtility.TableShallowCopy(self.refine_equipxxx_map, BlackSmithProxy.GetAncientUpgradeEquipPosMap())
end

function AncientUpgradePanel:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, AncientUpgradePanel.TabName[go.name], false, self:FindComponent("Sprite", UISprite, go))
end

function AncientUpgradePanel:OnEnter()
  AncientUpgradePanel.super.OnEnter(self)
  self:InitValidRefineEquipType()
  self.npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  self.npcguid = self.npcInfo and self.npcInfo.data.id
  self.bord_Control:SetNpcguid(self.npcguid)
  if self.viewdata.viewdata and self.viewdata.viewdata.CombineView then
    self.viewdata.viewdata.CombineView.refinePanel = self
  end
  if self.npcInfo then
    local rootTrans = self.npcInfo.assetRole.completeTransform
    if self.isfashion then
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    else
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
    end
  else
    self:CameraFocusToMe()
  end
  self:UpdateCoins()
  self:SetTargetItem(nil)
  self:ClickAddEquipButtonCall()
  local OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
  if OnClickChooseBordCell_data then
    self:SetTargetItem(OnClickChooseBordCell_data)
    if self.bord_Control:GetNowItemData() then
      self.chooseBord:Hide()
    end
  end
end

function AncientUpgradePanel:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function AncientUpgradePanel:OnExit()
  AncientUpgradePanel.super.OnExit(self)
  self.wait_refresh = false
  self:RemoveLeanTween()
  self.bord_Control:OnExit()
  self:CameraReset()
end
