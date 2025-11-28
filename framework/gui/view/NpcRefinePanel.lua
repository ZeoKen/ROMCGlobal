autoImport("EquipRefineBordNew")
autoImport("EquipBatchRefineBord")
autoImport("EquipChooseBord1")
autoImport("CommonNewTabListCell")
autoImport("BagItemNewCell")
autoImport("MaterialItemNewCell")
autoImport("RefineCombineView")
NpcRefinePanel = class("NpcRefinePanel", ContainerView)
NpcRefinePanel.BrotherView = RefineCombineView
NpcRefinePanel.ViewType = UIViewType.NormalLayer
NpcRefinePanel.RefineBordPath = "part/EquipRefineBordNew"
NpcRefinePanel.BatchRefineBordPath = "part/EquipBatchRefineBord"
NpcRefinePanel.isCombineSize = false
local TabName = {
  RefineTab = ZhString.NpcRefinePanel_RefineTabName,
  OneClickTab = ZhString.NpcRefinePanel_OneClickTabName
}
local npcRefineAction = "functional_action"
local blackSmith
local tempVector3 = LuaVector3()
local CHOOSECOLOR = LuaColor(0.3607843137254902, 0.3843137254901961, 0.5647058823529412, 1)
local UNCHOOSECOLOR = LuaColor.White()

function NpcRefinePanel:Init()
  if not blackSmith then
    blackSmith = BlackSmithProxy.Instance
  end
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self.isFromBag = self.viewdata.viewdata and self.viewdata.viewdata.isFromBag
  self.selectTicket = self.viewdata.viewdata.selectTicket
  self:InitView()
  self:MapEvent()
end

function NpcRefinePanel:InitView()
  self.leftSideBar = self:FindGO("LeftSideBar")
  self.leftSideBar:SetActive(self.isCombine ~= true)
  self.bg = self:FindComponent("PanelBg", UISprite)
  self.colliderMask = self:FindGO("ColliderMask")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord1_CombineSize.new(self.chooseContainer)
  self.chooseBord:SetFilterPopData(self.isfashion and GameConfig.SewingRefineFilter or GameConfig.EquipChooseFilter)
  self.chooseBord:SetValidEvent(self.ChooseEquipValid, self, 43389)
  self.chooseBord:HideItemInValid()
  self.chooseBord:Hide()
  self.tabGrid = self:FindGO("TabGrid")
  self.refineBord = self:FindGO("RefineParent")
  self.refineTab = self:FindGO("RefineTab")
  self.refineTabCell = CommonNewTabListCell.new(self.refineTab)
  self.refineTabCell:SetIcon("tab_icon_86")
  self.refineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickRefineTab, self)
  self.batchRefineTab = self:FindGO("OneClickTab")
  self.batchRefineTabCell = CommonNewTabListCell.new(self.batchRefineTab)
  self.batchRefineTabCell:SetIcon("tab_icon_87")
  self.batchRefineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickBatchTab, self)
  self.combineTab = self:FindGO("CombineRefineTab")
  self.combineTabCell = CommonNewTabListCell.new(self.combineTab)
  self.combineTabCell:SetIcon("tab_icon_87")
  self.combineTabCell:AddEventListener(MouseEvent.MouseClick, self.OnClickBatchTab, self)
  local userRob = self:FindGO("Silver")
  local symbol = self:FindComponent("symbol", UISprite, userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.robLabel = self:FindComponent("Label", UILabel, userRob)
  self:AddButtonEvent("SilverAddBtn", function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
  userRob:SetActive(not self.isCombine)
  local go = self:LoadPreferb(self.RefineBordPath, self.refineBord, true)
  self.bord_Control = EquipRefineBordNew.new(go, self.isfashion, self.isFromBag, self.isCombineSize)
  self.bord_Control:AddEventListener(EquipRefineBordNew.Event.ClickTargetCell, self.ClickAddEquipButtonCall, self)
  self.bord_Control:AddEventListener(EquipRefineBordNew.Event.DoRefine, self.DoRefineCall, self)
  self.bord_Control:AddEventListener(EquipRefineBordNew.Event.DoRepair, self.DoRepairCall, self)
  self.bord_Control:AddEventListener(EquipRefineBordNew.Event.DoUseTicket, self.DoUseTicket, self)
  self.bord_Control:AddEventListener(EquipRefineBordNew.Event.TicketChange, self.TicketChangeCall, self)
  self.bord_Control:Show()
  local go = self:LoadPreferb(self.BatchRefineBordPath, self.refineBord, true)
  self.batchBord_Control = EquipBatchRefineBord.new(go, self.isfashion)
  self.batchBord_Control:Hide()
  local tabList, longPress = {
    self.refineTab,
    self.batchRefineTab
  }
  for _, v in ipairs(tabList) do
    longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.NpcRefinePanel, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.NpcRefinePanel, self.HandleLongPress, self)
  self:InitShopEnter()
  self.helpBtn = self:FindGO("HelpButton")
  self:TryOpenHelpViewById(31, nil, self.helpBtn)
end

function NpcRefinePanel:ChooseEquipValid(data)
  local ticket = self.bord_Control:GetSelectTicket()
  if ticket then
    return BlackSmithProxy.IsTicketCanUseFor(ticket, data)
  end
  return true
end

function NpcRefinePanel:InitShopEnter()
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

function NpcRefinePanel:OnClickRefineTab()
  self.bord_Control:Show()
  self.batchBord_Control:Hide()
  self:SetTargetItem(nil)
  self.chooseBord:Hide()
  self:ClickAddEquipButtonCall()
end

function NpcRefinePanel:OnClickBatchTab()
  self.bord_Control:Hide()
  self.batchBord_Control:Show()
  self.chooseBord:Hide()
  TipManager.CloseTip()
end

function NpcRefinePanel:RecvOneClickRefineResult(note)
  local b = note and note.body
  if b and b.result then
    self.batchBord_Control:Reset()
    MsgManager.ShowMsgByID(229)
  else
    MsgManager.FloatMsg(nil, ZhString.NpcRefinePanel_Failed)
  end
end

function NpcRefinePanel:ClickAddEquipButtonCall(control)
  self:ShowChooseEquipBord()
end

function NpcRefinePanel:ShowChooseEquipBord()
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
  self.bord_Control:ActiveTargetCellChooseSymbol(false)
end

function NpcRefinePanel:HideChooseEquipBord()
  if self.chooseBord then
    self.chooseBord:Hide()
  end
  self.bord_Control:ActiveTargetCellChooseSymbol(true)
end

function NpcRefinePanel:SetTargetItem(data)
  self.refineToLv = nil
  self.refineResult = nil
  self.bord_Control:SetTargetItem(data)
  if data then
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
end

function NpcRefinePanel:UpdateLeftTipBord(data)
end

function NpcRefinePanel:SetDelayTime(delayTime)
  self.delayTimeTick = ServerTime.CurServerTime() + delayTime
end

function NpcRefinePanel:GetDelayTime()
  if not self.delayTimeTick then
    return 0
  end
  return self.delayTimeTick - ServerTime.CurServerTime()
end

function NpcRefinePanel:TicketChangeCall(control)
  if not self.chooseBord:ActiveSelf() then
    return
  end
  local ticket = control:GetSelectTicket()
  if not ticket then
    if not control:GetNowItemData() then
      self:ShowChooseEquipBord()
    else
      self:HideChooseEquipBord()
    end
  end
end

function NpcRefinePanel:DoRefineCall(control)
  self.refineResult = nil
  self.refineToLv = control.refineTolv
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
  self:ActiveLock(true)
  self:SetDelayTime(GameConfig.EquipRefine.delay_time)
end

function NpcRefinePanel:DoRepairCall(control)
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
  self:ActiveLock(true)
  self:SetDelayTime(GameConfig.EquipRefine.delay_time)
end

function NpcRefinePanel:DoUseTicket(control)
  self.refineResult = SceneItem_pb.EREFINERESULT_SUCCESS
  local ticket = control:GetSelectTicket()
  local useEffect = ticket and Table_UseItem[ticket.staticData.id].UseEffect
  if useEffect then
    if useEffect.type == "refine" then
      self.refineToLv = useEffect.refine_level
    elseif useEffect.type == "refine_new_ticket" then
      self.refineToLv = useEffect.refine_lv
    end
  end
  local ncpinfo = self:GetCurNpc()
  if ncpinfo then
    ncpinfo:Client_PlayAction(npcRefineAction, nil, false)
  end
  self.chooseBord:Hide()
  self:SetDelayTime(GameConfig.EquipRefine.delay_time)
end

function NpcRefinePanel:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function NpcRefinePanel:ActiveLock(b)
  if self.safeActiveTick then
    TimeTickManager.Me():ClearTick(self, 121)
    self.safeActiveTick = nil
  end
  self.colliderMask:SetActive(b)
  if b then
    self.safeActiveTick = TimeTickManager.Me():CreateOnceDelayTick(2000, function()
      self.colliderMask:SetActive(false)
      self.safeActiveTick = nil
    end, self, 121)
  end
end

function NpcRefinePanel:RefineEnd()
  self:ActiveLock(false)
  if self.refineResult == SceneItem_pb.EREFINERESULT_SUCCESS then
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
  else
    AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinefail)
  end
  self.bord_Control:ShowTempResult(self.refineResult)
  self:UpdateLeftTipBord(nowData)
  if nowData and nowData.equipInfo.damage then
    MsgManager.ShowMsgByIDTable(230)
  end
end

function NpcRefinePanel:UpdateShare()
  local nowData = self.bord_Control:GetNowItemData()
  if not nowData then
    return
  end
  local maxLv = nowData.equipInfo.equipData.RefineMaxlv or 15
  if maxLv <= nowData.equipInfo.refinelv then
    FloatAwardView.ShowRefineShareViewNew(nowData:Clone())
    self.bord_Control:HideAllChooseBord()
  end
end

function NpcRefinePanel:RepairEnd()
  self:ActiveLock(false)
  local nowData = self.bord_Control:GetNowItemData()
  if not nowData then
    return
  end
  AudioUtil.Play2DRandomSound(AudioMap.Maps.Refinesuccess)
  MsgManager.ShowMsgByIDTable(221, {
    nowData.staticData.NameZh
  })
  self.bord_Control:PlaySuccessEffect()
  Game.Myself.assetRole:PlayEffectOneShotOn(EffectMap.Maps.ForgingSuccess, RoleDefines_EP.Top)
end

function NpcRefinePanel:MapEvent()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ItemEquipRefine, self.RecvRefineResult)
  self:AddListenEvt(ServiceEvent.ItemEquipRepair, self.RecvRepairResult)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.RecvUpdateRefineInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ItemBatchRefineItemCmd, self.RecvOneClickRefineResult)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.HandleChooseEquip)
end

function NpcRefinePanel:RecvRefineResult(note)
  if self.bord_Control then
    self.refineResult = note.body.eresult
    if self.waitTick then
      TimeTickManager.Me():ClearTick(self, 111)
      self.waitTick = nil
    end
    local delayTime = self:GetDelayTime()
    if 0 < delayTime then
      self.waitTick = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        self:RefineEnd()
      end, self, 111)
    else
      self:RefineEnd()
    end
  end
end

function NpcRefinePanel:RecvRepairResult()
  if self.bord_Control then
    if self.waitTick then
      TimeTickManager.Me():ClearTick(self, 111)
      self.waitTick = nil
    end
    local delayTime = self:GetDelayTime()
    if 0 < delayTime then
      self.waitTick = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        self:RepairEnd()
      end, self, 111)
    else
      self:RepairEnd()
    end
  end
end

function NpcRefinePanel:RecvUpdateRefineInfo(note)
  if self.bord_Control then
    local dirtyMap = note.body
    if self.refreshTick then
      TimeTickManager.Me():ClearTick(self, 131)
      self.refreshTick = nil
    end
    local delayTime = self:GetDelayTime()
    if 0 < delayTime then
      self.refreshTick = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        self:CheckUpdateRefineBord(dirtyMap)
      end, self, 131)
    else
      self:CheckUpdateRefineBord(dirtyMap)
    end
  end
end

function NpcRefinePanel:CheckUpdateRefineBord(dirtyMap)
  self:ActiveLock(false)
  if self.batchBord_Control:IsActived() then
    self.batchBord_Control:Refresh()
  else
    if not dirtyMap then
      return
    end
    local nowData = self.bord_Control:GetNowItemData()
    if nowData then
      if dirtyMap[nowData.id] then
        if nowData.equipInfo.refinelv == self.refineToLv then
          self:UpdateShare()
        end
        self.bord_Control:SetTargetItem(nowData)
      else
        self.bord_Control:RefreshDatas(dirtyMap)
        self.bord_Control:Refresh()
      end
    end
  end
end

function NpcRefinePanel:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end

local Default_FashionRefineEquiptypeMap = {
  [8] = 1,
  [9] = 1,
  [10] = 1,
  [11] = 1,
  [12] = 1,
  [13] = 1
}

function NpcRefinePanel:GetChooseBordDatas()
  xdlog("GetChooseBordDatas")
  local ticket = self.bord_Control:GetSelectTicket()
  return BlackSmithProxy.Instance:GetRefineEquips(self.refine_equiptype_map, true, function(a, b)
    local aValid = BlackSmithProxy.IsTicketCanUseFor(ticket, a) and 1 or 0
    local bValid = BlackSmithProxy.IsTicketCanUseFor(ticket, b) and 1 or 0
    if aValid ~= bValid then
      return aValid > bValid
    end
    return BlackSmithProxy.Equip_DefaultSortRule(a, b)
  end)
end

function NpcRefinePanel:InitValidRefineEquipType()
  self.refine_equiptype_map = {}
  if self.isfashion then
    TableUtility.TableShallowCopy(self.refine_equiptype_map, BlackSmithProxy.GetFashionRefineEquipTypeMap())
  else
    TableUtility.TableShallowCopy(self.refine_equiptype_map, BlackSmithProxy.GetAllRefineEquipTypeMap())
  end
end

function NpcRefinePanel:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, NpcRefinePanel.TabName[go.name], false, self:FindComponent("Sprite", UISprite, go))
end

function NpcRefinePanel:OnEnter()
  NpcRefinePanel.super.OnEnter(self)
  self:InitValidRefineEquipType()
  self.npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  self.npcguid = self.npcInfo and self.npcInfo.data and self.npcInfo.data.id
  self.bord_Control:SetNpcguid(self.npcguid)
  if self.npcInfo then
    local rootTrans = self.npcInfo.assetRole.completeTransform
    if self.isfashion then
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    else
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    end
  else
    self:CameraFocusToMe()
  end
  self:UpdateCoins()
  if self.viewdata.viewdata and self.viewdata.viewdata.isOneClick then
    self:OnClickBatchTab()
  else
    self.bord_Control:SetSelectTicket(self.selectTicket)
    local OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
    if OnClickChooseBordCell_data then
      self:SetTargetItem(OnClickChooseBordCell_data)
      self:HideChooseEquipBord()
    else
      self:SetTargetItem(nil)
      self:ShowChooseEquipBord()
    end
  end
end

function NpcRefinePanel:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function NpcRefinePanel:OnExit()
  NpcRefinePanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.bord_Control:OnExit()
  self:CameraReset()
end

function NpcRefinePanel:HandleChooseEquip()
  self.bord_Control:ClickTargetCell()
end
