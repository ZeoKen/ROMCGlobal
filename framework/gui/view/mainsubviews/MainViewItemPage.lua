MainViewItemPage = class("MainViewItemPage", SubView)
autoImport("QuickItemCell")
autoImport("QuestPackagePart")
autoImport("FoodPackagePart")
autoImport("PetPackagePart")
autoImport("GemPackagePart")
autoImport("FurniturePackagePart")
autoImport("PersonalArtifactPackagePart")
autoImport("ExtractionPackagePart")
autoImport("RaidItemCell")
MainViewItemPage.ButterflyWingId = 50001
MainViewItemPage.PetItemId = 5682
MainViewItemPage.SignIn21ItemId = 6732
local MAX_SHORTCUT = GameConfig.NewRole.maxshortcut
local ROWCOUNT = 5
local tempRot = LuaQuaternion()
local EmptyTable = _EmptyTable

function MainViewItemPage:Init()
  self:AddViewInterests()
  self:InitUI()
end

function MainViewItemPage:InitUI()
  self.root = self:FindGO("ShortCutGrid")
  self.grid = self:FindComponent("ItemGrid", UIGridEx)
  self.expandGrid = self:FindComponent("ExpandGrid", UIGridEx)
  self.expandGrid.animateSmoothly = false
  self.expandBtn = self:FindGO("ExpandBtn")
  self.expandArrow = self:FindGO("ExpandArrow")
  self.canShowExpandBtn = true
  self:AddClickEvent(self.expandBtn, function(go)
    self:OnExpandBtn()
  end)
  
  function self.grid.onReposition()
    self.grid.gameObject:SetActive(false)
    self.grid.gameObject:SetActive(true)
  end
  
  self.packageBordMap = {}
  self.quickItemCells = {}
  for i = 1, ROWCOUNT do
    local obj = self:LoadPreferb("cell/QuickItemCell", self.grid.gameObject)
    obj.name = "QuickItemCell" .. i
    self.quickItemCells[i] = QuickItemCell.new(obj)
    self.quickItemCells[i]:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
    local parent = self.quickItemCells[i]:GetBgSprite()
    Game.HotKeyTipManager:RegisterHotKeyTip(22 + i, parent, NGUIUtil.AnchorSide.TopLeft, {6, -7}, {1.2, 1.2})
  end
  if 1 < MAX_SHORTCUT / ROWCOUNT then
    for i = 6, 10 do
      local obj = self:LoadPreferb("cell/QuickItemCell", self.expandGrid.gameObject)
      obj.name = "QuickItemCell" .. i
      self.quickItemCells[i] = QuickItemCell.new(obj)
      self.quickItemCells[i]:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
      local parent = self.quickItemCells[i]:GetBgSprite()
      Game.HotKeyTipManager:RegisterHotKeyTip(22 + i, parent, NGUIUtil.AnchorSide.TopLeft, {6, -7}, {1.2, 1.2})
    end
  end
  self:Tutorial()
  local deltaTime, lastTime = 0
  TimeTickManager.Me():CreateTick(0, 33, function(self)
    if lastTime then
      deltaTime = deltaTime + (RealTime.time - lastTime)
      if 2 < deltaTime then
        self.grid.animateSmoothly = true
        self:UpdateQuickItems()
        self.expandGrid.gameObject:SetActive(false)
        self.initQuickItems = true
        TimeTickManager.Me():ClearTick(self, 2)
      end
    end
    lastTime = RealTime.time
  end, self, 2)
  self.phaseItemSkillEffect = self:FindGO("PhaseItemSkillEffect")
  self.tsfInteractMountBtnRoot = self:FindGO("InteractMountBtns").transform
  self:InitHeartLockItemGrid()
end

function MainViewItemPage:InitHeartLockItemGrid()
  self.heartLockItemBord = self:FindGO("HeartLockItemBord")
  self.heartLockItemGrid = self:FindGO("HeartLockItemGrid", self.heartLockItemBord):GetComponent(UIGridEx)
  self.heartLockItemCtrl = UIGridListCtrl.new(self.heartLockItemGrid, RaidItemCell, "RaidItemCell")
  self.heartLockItemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickHeartLockItem, self)
  self.heartLockItemGridEx = self:FindGO("HeartLockItemGridEx", self.heartLockItemBord):GetComponent(UIGridEx)
  self.heartLockItemCtrlEx = UIGridListCtrl.new(self.heartLockItemGridEx, RaidItemCell, "RaidItemCell")
  self.heartLockItemCtrlEx:AddEventListener(MouseEvent.MouseClick, self.ClickHeartLockItem, self)
end

function MainViewItemPage:UpdateHeartLockItems()
  local itemdatas = SgAIManager.Me():GetPlayerItemdatas()
  if itemdatas then
    if #itemdatas <= 7 then
      self.heartLockItemCtrl:ResetDatas(itemdatas)
      self.heartLockItemCtrl:Layout()
      self.heartLockItemCtrlEx:ResetDatas(EmptyTable)
      self.heartLockItemCtrlEx:Layout()
    else
      local itemlist = {}
      for i = 1, 7 do
        table.insert(itemlist, itemdatas[i])
      end
      self.heartLockItemCtrl:ResetDatas(itemlist)
      self.heartLockItemCtrl:Layout()
      TableUtility.ArrayClear(itemlist)
      for i = 8, #itemdatas do
        table.insert(itemlist, itemdatas[i])
      end
      self.heartLockItemCtrlEx:ResetDatas(itemlist)
      self.heartLockItemCtrlEx:Layout()
    end
  end
end

function MainViewItemPage:ClearHeartLockItems()
  if self.heartLockItemCtrl then
    self.heartLockItemCtrl:RemoveAll()
  end
end

local tipData = {}
tipData.funcConfig = {}

function MainViewItemPage:ClickHeartLockItem(cell)
  if cell.data then
    tipData.itemdata = cell.data
    tipData.funcConfig = FunctionItemFunc.GetItemFuncIds(cell.data.staticData.id, nil, false)
    self:ShowItemTip(tipData, cell.itemnum, NGUIUtil.AnchorSide.Up)
  end
end

function MainViewItemPage:OnEnter()
  MainViewItemPage.super.OnEnter(self)
  self:HandleHpSpChange()
end

function MainViewItemPage:OnExpandBtn()
  local on = self.expandGrid.gameObject.activeSelf
  self.expandGrid.gameObject:SetActive(not on)
  self.expandGrid:Reposition()
  local tempVector3 = LuaGeometry.GetTempVector3()
  if on then
    tempVector3:Set(-85, 27, 0)
  else
    tempVector3:Set(-85, 104, 0)
  end
  self.expandBtn.transform.localPosition = tempVector3
  if on then
    tempVector3:Set(0, 0, 0)
  else
    tempVector3:Set(0, 0, 180)
  end
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
  self.expandBtn.transform.localRotation = tempRot
  self.tsfInteractMountBtnRoot.localPosition = LuaGeometry.GetTempVector3(0, on and 241 or 338, 0)
end

function MainViewItemPage:GetPackageBord(bordKey)
  if self.packageBordMap[bordKey] then
    return self.packageBordMap[bordKey]
  end
  local frontPanel = self:FindGO("ThefrontPanel")
  local bord = _G[bordKey .. "PackagePart"].new()
  bord:CreateSelf(frontPanel.gameObject)
  if bordKey ~= "Pet" then
    bord:Hide()
  end
  self.packageBordMap[bordKey] = bord
  return bord
end

function MainViewItemPage:ShowPackageBord(bordKey, cellCtl)
  local ctrl = self:GetPackageBord(bordKey)
  ctrl:UpdateInfo()
  ctrl:Show()
  local x, y, z = LuaGameObject.GetPosition(cellCtl.gameObject.transform)
  ctrl:SetPos(x, y, z)
  ctrl:SetLocalOffset(-257.1, 214, 0)
  local thefrontPanel = self:FindComponent("ThefrontPanel", UIPanel)
  if thefrontPanel and ctrl.gameObject then
    thefrontPanel:ConstrainTargetToBounds(ctrl.gameObject.transform, true)
  end
end

function MainViewItemPage:ClickItem(cellCtl)
  local data = cellCtl.data
  local existTimeType = data.staticData and data.staticData.ExistTimeType
  if existTimeType == 3 and data.deltime ~= nil and data.deltime ~= 0 and data.deltime <= ServerTime.CurServerTime() / 1000 then
    MsgManager.FloatMsg(nil, ZhString.ItemTip_InvalidTip)
    return
  end
  if data and 0 < data.num and 0 >= data.cdTime then
    if data.staticData.id == 5045 then
      self:ShowPackageBord("Quest", cellCtl)
      return
    end
    if data.staticData.id == 5640 then
      self:ShowPackageBord("Pet", cellCtl)
      return
    end
    if data.staticData.id == 5047 then
      self:ShowPackageBord("Food", cellCtl)
      return
    end
    if data.staticData.id == 5660 then
      self:ShowPackageBord("Furniture", cellCtl)
      return
    end
    if data.staticData.id == 5671 then
      self:ShowPackageBord("Gem", cellCtl)
      return
    end
    if data.staticData.id == 7203 then
      self:ShowPackageBord("PersonalArtifact", cellCtl)
      return
    end
    if data.staticData.id == 5681 then
      ServiceNUserProxy.Instance:CallExtractionQueryUserCmd()
      self:ShowPackageBord("Extraction", cellCtl)
      return
    end
    local source
    if BagProxy.Instance.roleEquip:GetItemByGuid(data.id) ~= nil then
      source = FunctionItemFunc_Source.RoleEquipBag
    end
    local func
    if data:IsFashion() then
      func = ItemUtil.getFashionDefaultEquipFunc(data)
    else
      func = FunctionItemFunc.Me():GetItemDefaultFunc(data, source)
    end
    if func then
      local lastCellCtl = data.cellCtl
      data.cellCtl = cellCtl
      func(data)
      data.cellCtl = lastCellCtl
    end
  end
end

function MainViewItemPage:KeyBoardUseItemHandler(index)
  if 0 < index and index <= #self.quickItemCells then
    local cell = self.quickItemCells[index]
    if cell then
      self:ClickItem(cell)
    end
  end
end

function MainViewItemPage:UpdateQuickItems()
  local quickItemDatas = ShortCutProxy.Instance:GetShorCutItem(true)
  local bwingGuideCell
  self.hpCells, self.spCells = {}, {}
  local _SetQuickItemData = function(i)
    local data = quickItemDatas[i]
    if data and data.staticData and data.num > 0 then
      if not bwingGuideCell and data.staticData.id == MainViewItemPage.ButterflyWingId then
        bwingGuideCell = self.quickItemCells[i]
      end
      if data.staticData.id == MainViewItemPage.PetItemId then
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.quickItemCells[i].icon.gameObject, 42)
      end
    end
    self.quickItemCells[i]:SetData(quickItemDatas[i])
  end
  for i = 1, ROWCOUNT do
    _SetQuickItemData(i)
  end
  if 1 < MAX_SHORTCUT / ROWCOUNT then
    for i = 6, 10 do
      _SetQuickItemData(i)
    end
  end
  self.grid.enabled = true
  
  function self.grid.onReposition()
    if self.setButterFlyGuild then
      self.setButterFlyGuild = false
      if bwingGuideCell then
        local obj = bwingGuideCell.gameObject
        local stick = obj:GetComponentInChildren(UISprite)
        if stick then
          TipManager.Instance:ShowBubbleTipById(BubbleID.ButterflyWingGuildId, stick, NGUIUtil.AnchorSide.Top)
        end
      end
    end
  end
  
  self.expandGrid:Reposition()
  if self.canShowExpandBtn then
    self.expandBtn:SetActive(ShortCutProxy.Instance:MulRowShortCutItems())
  end
end

function MainViewItemPage:UpdateQuickItemsByMainBag()
  ShortCutProxy.Instance:HandleServerShortCut()
  self:UpdateQuickItems()
end

function MainViewItemPage:UpdateQuickItemsByEquipBag()
  ShortCutProxy.Instance:HandleServerShortCut(true)
  self:UpdateQuickItems()
end

function MainViewItemPage:AddViewInterests()
  self:AddListenEvt(GuideEvent.ShowBubble, self.HandleButterflyWingGuild)
  self:AddListenEvt(MyselfEvent.ResetHpShortCut, self.UpdateQuickItems)
  self:AddListenEvt(ItemEvent.QuickUseItemCheckEquipUpdate, self.UpdateQuickItems)
  self:AddListenEvt(ItemEvent.QuickUseItemCheckUpdate, self.UpdateQuickItemsByMainBag)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateQuickItemsByEquipBag)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateQuickItems)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdateQuickItems)
  self:AddListenEvt(DesertWolfEvent.OnRuleUpdated, self.UpdateQuickItems)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateQuickItems)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleHpSpChange)
  self:AddDispatcherEvt("CJKeyBoardUseItemEvent", self.KeyBoardUseItemHandler)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HideItemGrid)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.ShowItemGrid)
  self:AddListenEvt(PVEEvent.Altman_Launch, self.HideItemGrid)
  self:AddListenEvt(PVEEvent.Altman_Shutdown, self.ShowItemGrid)
  self:AddListenEvt(HotKeyEvent.UseShortCutItem, self.HandleShortCutItem)
  self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseItemSkillEffect)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleBattleTime)
  self:AddListenEvt(PVPEvent.PVP_TransferFightLaunch, self.HideItemGrid)
  self:AddListenEvt(PVPEvent.PVP_TransferFightShutDown, self.ShowItemGrid)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(MainViewEvent.ActiveShortCutBord, self.HandleActiveShortCutBord)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Launch, self.HandleHeartLockRaidLaunch)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Shutdown, self.HandleHeartLockRaidShutdown)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Update, self.UpdateHeartLockItems)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Add, self.UpdateHeartLockItems)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Del, self.UpdateHeartLockItems)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.OnDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.OnDemoRaidShutdown)
  self:AddListenEvt(MyselfEvent.UpdateRefineBuff, self.UpdateRefineLv)
end

function MainViewItemPage:HandleButterflyWingGuild(note)
  local guildid = note.body
  if guildid == BubbleID.ButterflyWingGuildId then
    local deltaTime, lastTime = 0
    TimeTickManager.Me():CreateTick(0, 33, function(self)
      if lastTime then
        deltaTime = deltaTime + (RealTime.time - lastTime)
        if 1 < deltaTime then
          TimeTickManager.Me():ClearTick(self, 1)
        end
      end
      lastTime = RealTime.time
      local bfItem = BagProxy.Instance:GetItemByStaticID(MainViewItemPage.ButterflyWingId)
      if bfItem then
        self.setButterFlyGuild = true
        local key = {
          guid = bfItem.id,
          type = bfItem.staticData.id,
          pos = 2
        }
        ServiceNUserProxy.Instance:CallPutShortcut(key)
        TimeTickManager.Me():ClearTick(self, 1)
      end
    end, self, 1)
  end
end

function MainViewItemPage:HandleHpSpChange(note)
  if not self.initQuickItems then
    return
  end
  for i, cell in pairs(self.quickItemCells) do
    cell:UpdateHpSpTipEffect()
  end
end

function MainViewItemPage:HideItemGrid(note)
  self.grid.gameObject:SetActive(false)
  self.expandGrid.gameObject:SetActive(false)
  self.expandBtn:SetActive(false)
  self.canShowExpandBtn = false
  self.tsfInteractMountBtnRoot.localPosition = LuaGeometry.GetTempVector3(0, 241, 0)
end

function MainViewItemPage:ShowItemGrid(note)
  self.grid.gameObject:SetActive(true)
  self.expandGrid.gameObject:SetActive(true)
  self.expandBtn:SetActive(ShortCutProxy.Instance:MulRowShortCutItems())
  self:OnExpandBtn()
  self.canShowExpandBtn = true
  self.tsfInteractMountBtnRoot.localPosition = LuaGeometry.GetTempVector3(0, 338, 0)
end

function MainViewItemPage:HandleShortCutItem(note)
  local param = note.body
  if param.index then
    local cell = self.quickItemCells[param.index]
    if cell and cell.data then
      self:ClickItem(cell)
    end
  end
end

function MainViewItemPage:HandlePhaseItemSkillEffect()
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID <= 0 then
    self:HidePhaseItemSkillEffect()
  else
    local skillCostItemId = self:GetSkillCostItemId(skillID)
    if skillCostItemId then
      self:ShowPhaseItemSkillEffect(skillCostItemId)
    end
  end
end

function MainViewItemPage:ShowPhaseItemSkillEffect(itemId)
  local cell = self:GetQuickItemCell(itemId)
  if not cell then
    return
  end
  if not self.phaseEffectCtrl then
    self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay, self.phaseItemSkillEffect.transform, false, function(obj, args, assetEffect)
      self.phaseEffectCtrl = assetEffect
      local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseItemSkillEffect.transform, cell.gameObject.transform, Space.World)
      self.phaseEffectCtrl:ResetLocalPositionXYZ(x, y, z)
    end)
  end
end

function MainViewItemPage:HidePhaseItemSkillEffect()
  if self.phaseEffectCtrl then
    self.phaseEffectCtrl:Destroy()
    self.phaseEffectCtrl = nil
  end
end

function MainViewItemPage:GetSkillCostItemId(skillId)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillId)
  if not skillInfo then
    return nil
  end
  local skillCost = SkillProxy.Instance:GetOriginSpecialCost(skillInfo.staticData)
  if not skillCost or not next(skillCost) then
    return nil
  end
  local itemCost
  for i = 1, #skillCost do
    itemCost = skillCost[i]
    if itemCost.itemID then
      return itemCost.itemID
    end
  end
  return nil
end

function MainViewItemPage:GetQuickItemCell(itemId)
  if itemId then
    for _, cell in pairs(self.quickItemCells) do
      if cell.data and cell.data.staticData.id == itemId then
        return cell
      end
    end
  end
  return nil
end

function MainViewItemPage:OnHide()
  if self.petPackageBord then
    self.petPackageBord:Hide()
  end
end

function MainViewItemPage:OnShow()
  self:UpdateRefineLv()
end

local MaxBattletime = GameConfig.Tutor.tutor_vip_max_battletime

function MainViewItemPage:HandleBattleTime(note)
  if note and note.body and BagProxy.Instance.callBattletime then
    local data = note.body
    local itemdata = BagProxy.Instance:GetBattleTimeItem()
    if data.tutortime and itemdata then
      if itemdata:GetUseEffectTime() + data.tutortime > MaxBattletime and data.tutortime < MaxBattletime then
        MsgManager.ConfirmMsgByID(39012, function()
          FunctionItemFunc.DoUseItem(itemdata, nil, 1)
        end, nil, nil)
        BagProxy.Instance.callBattletime = false
      else
        FunctionItemFunc.DoUseItem(itemdata, nil, 1)
        BagProxy.Instance.callBattletime = false
      end
    end
  end
end

local guideIds = {
  141,
  142,
  143,
  144,
  145
}

function MainViewItemPage:Tutorial()
  if self.guideInited then
    return
  end
  local cells = self.quickItemCells
  if cells then
    local idCount = #guideIds
    for i, cell in ipairs(cells) do
      if i > idCount then
        break
      end
      self:AddOrRemoveGuideId(cell.gameObject)
      self:AddOrRemoveGuideId(cell.gameObject, guideIds[i])
    end
  end
  self.guideInited = true
end

function MainViewItemPage:HandleHideUIUserCmd(note)
  local data = note.body
  local on = data.open
  if on and on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 9) > 0 then
      self.root:SetActive(false)
    end
  else
    self.root:SetActive(true)
  end
end

function MainViewItemPage:HandleActiveShortCutBord(note)
  if note.body ~= true then
    for _, bord in pairs(self.packageBordMap) do
      bord:Hide()
    end
  end
end

function MainViewItemPage:HandleHeartLockRaidLaunch()
  self.root:SetActive(false)
end

function MainViewItemPage:HandleHeartLockRaidShutdown()
  self.root:SetActive(true)
  self:ClearHeartLockItems()
end

function MainViewItemPage:OnDemoRaidLaunch()
  self:HideItemGrid()
end

function MainViewItemPage:OnDemoRaidShutdown()
  self:ShowItemGrid()
end

function MainViewItemPage:UpdateRefineLv()
  if not self.initQuickItems then
    return
  end
  for i, cell in pairs(self.quickItemCells) do
    cell:UpdateRefineLv()
  end
end
