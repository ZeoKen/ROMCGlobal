autoImport("BagCombineFashionItemCell")
autoImport("Asset_Role_UI")
autoImport("UIEmojiCell")
autoImport("FashionSetCell")
PackageFashionPage = class("PackageFashionPage", SubView)
local Config_MountTransform = {
  position_x = 0.1,
  position_y = -0.2,
  position_z = 2,
  eulerAngles_x = 0,
  eulerAngles_y = 150,
  eulerAngles_z = 0,
  Scale = 1
}
local Config_BarrowTransform = {
  position_x = 0.1,
  position_y = -0.2,
  position_z = 2,
  eulerAngles_x = 0,
  eulerAngles_y = 150,
  eulerAngles_z = 0,
  Scale = 1
}
local TabIndex = {
  FashionTab = 1,
  SkillEffectTab = 2,
  RewardEffectTab = 3
}
local invisibleComponent = 10000
local Fashion2AdvFashionTab, AdvFashion2FashionHideType, myselfIns, curEquippedWeaponItemType
local _ItemPB = SceneItem_pb
local m_actionID_ride = "fashionPage_actionName_ride"
local m_actionID_withMount = "fashionPage_actionName_withMount"
local m_actionID_withBarrow = "fashionPage_actionName_withBarrow"
local m_actionID_withWeapon = 8
local tempVector3 = LuaVector3.Zero()

function PackageFashionPage:Init()
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self:AddViewEvts()
  if not myselfIns then
    myselfIns = MyselfProxy.Instance
  end
end

function PackageFashionPage:InitFashionTab()
  local class = myselfIns:GetMyProfession()
  if self.mclass == class then
    return
  end
  self.mclass = class
  Fashion2AdvFashionTab = {
    [1] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1045
    },
    [2] = {
      SceneManual_pb.EMANUALTYPE_EQUIP,
      1025
    },
    [3] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1040
    },
    [4] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1041
    },
    [5] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1043
    },
    [6] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1042
    },
    [7] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1044
    },
    [8] = {
      SceneManual_pb.EMANUALTYPE_MOUNT,
      5
    },
    [9] = {
      SceneManual_pb.EMANUALTYPE_FASHION,
      1055
    }
  }
  if ProfessionProxy.ProfEquipShield(class) then
    local Fashion2AdvShieldTab = {
      SceneManual_pb.EMANUALTYPE_EQUIP,
      1026
    }
    table.insert(Fashion2AdvFashionTab, 3, Fashion2AdvShieldTab)
  end
  if ProfessionProxy.GetTypeBranchBaseIdFromProf(class) == ProfessionProxy.xiudoumodaoshiJob then
    table.remove(Fashion2AdvFashionTab, 2)
  end
  if not AdvFashion2FashionHideType then
    AdvFashion2FashionHideType = {
      [1045] = SceneUser2_pb.EFASHIONHIDETYPE_BODY,
      [1025] = SceneUser2_pb.EFASHIONHIDETYPE_WEAPON,
      [1040] = SceneUser2_pb.EFASHIONHIDETYPE_HEAD,
      [1041] = SceneUser2_pb.EFASHIONHIDETYPE_FACE,
      [1043] = SceneUser2_pb.EFASHIONHIDETYPE_MOUTH,
      [1042] = SceneUser2_pb.EFASHIONHIDETYPE_BACK,
      [1044] = SceneUser2_pb.EFASHIONHIDETYPE_TAIL,
      [1026] = SceneUser2_pb.EFASHIONHIDETYPE_SHIELD
    }
  end
  if ProfessionProxy.ShieldPosCanEquipWeapon(class, Game.Myself) then
    local Fashion2AdvShieldTab = {
      SceneManual_pb.EMANUALTYPE_EQUIP,
      1026,
      replaceBag = 1025,
      forcePos = _ItemPB.EEQUIPPOS_SHIELD
    }
    table.insert(Fashion2AdvFashionTab, 3, Fashion2AdvShieldTab)
  end
end

function PackageFashionPage:InitFashionPage()
  self:InitFashionTab()
  if not self.inited then
    self:FindObjs()
    self:AddEvts()
    self.inited = true
  end
  self:InitFashionTabNameTip()
  self.itemlist:UpdateTabList(ItemNormalList.TabType.FashionPage, Fashion2AdvFashionTab, true)
  self:UpdateTabRedTips()
  self:ResetFashionSet()
end

function PackageFashionPage:UpdateTabRedTips()
  local tabCells = self.itemlist.tabCtl:GetCells()
  local hasSpecialFashion = false
  for i = 1, #tabCells do
    local index = tabCells[i].data and tabCells[i].data.index
    if index then
      local cfg = Fashion2AdvFashionTab[index]
      local subids = {}
      local _validTypes = {}
      for _itemType, _info in pairs(Table_ItemType) do
        if _info.AdventureLogGroup and _info.AdventureLogGroup == cfg[2] then
          table.insert(_validTypes, _itemType)
        end
      end
      if 0 < #_validTypes then
        local spFashionItems = BagProxy.Instance:GetBagItemsByTypes(_validTypes, BagProxy.BagType.SpecialFashion)
        for j = 1, #spFashionItems do
          table.insert(subids, spFashionItems[j].staticData.id)
          hasSpecialFashion = true
        end
      end
      if subids and 0 < #subids then
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ASTRAL_NEW_FASHION, tabCells[i].sp1)
      else
        self:UnRegisterSingleRedTipCheck(SceneTip_pb.EREDSYS_ASTRAL_NEW_FASHION, tabCells[i].sp1)
      end
    end
  end
  if not hasSpecialFashion then
    xdlog("无限时外观装备  强制移除红点")
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_ASTRAL_NEW_FASHION)
  end
end

function PackageFashionPage:FindObjs()
  self.objEmojiPanel = self:FindGO("EmojiPanel")
  self.emojiCtl = UIGridListCtrl.new(self:FindComponent("EmojiGrid", UIGrid, self.objEmojiPanel), UIEmojiCell, "UIEmojiCell")
  self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEmojiCell, self)
  self:ReLoadPerferb("view/PackageFashionPage", true)
  self.objBtnEmoji = self:FindGO("EmojiButton")
  self.objSelectColorMsg = self:FindGO("SelectFashionColorMsg")
  self.listGroupFashion = UIGridListCtrl.new(self:FindComponent("gridFashions", UIGrid), BagFashionItemCell, "BagFashionItemCell")
  self.scrollFashions = self:FindComponent("ScrollFashions", UIScrollView, self.objSelectColorMsg)
  self.itemlist = ItemNormalList.new(self:FindGO("FashionItemNormalList"), BagCombineFashionItemCell, nil, ROUIScrollView, false)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickItemTab, self)
  self.itemlist.GetTabDatas = PackageFashionPage.GetTabDatas
  self.itemCells = self.itemlist:GetItemCells()
  self.texBG = self:FindComponent("texBG", UITexture)
  self.objRotateRoleArrows = self:FindGO("RotateRoleArrows")
  self.objRotateRole = self:FindGO("RotateRoleCollider")
  self.normalStick = self.container.normalStick
  self.noneTip = self:FindGO("NoneTip")
  self.noneTipLabel = self.noneTip:GetComponent(UILabel)
  self.fashionBg = self:FindGO("FashionBg")
  local panel = self.container.gameObject:GetComponent(UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  self.mountFashionBtn = self:FindGO("MountFashionBtn")
  self.fashionSetPart = self:FindGO("FashionSetPart")
  self.fashionSetBtn = self:FindGO("FashionSetBtn", self.fashionSetPart)
  self.fashionSet_Arrow = self:FindGO("Arrow", self.fashionSetBtn)
  self.fashionSet_Icon = self:FindGO("SetIcon", self.fashionSetBtn):GetComponent(UISprite)
  self.fashionSetTog = self.fashionSetBtn:GetComponent(UIToggle)
  local fashionSetList = self:FindGO("FashionSetList", self.fashionSetPart)
  self.fashionSetTween = {}
  self.fashionSetTween[1] = fashionSetList:GetComponent(TweenAlpha)
  self.fashionSetTween[2] = fashionSetList:GetComponent(TweenPosition)
  self.fashionSetGrid = self:FindGO("SetGrid", self.fashionSetPart):GetComponent(UIGrid)
  self.fashionSetCtrl = UIGridListCtrl.new(self.fashionSetGrid, FashionSetCell, "FashionSetCell")
  self.fashionSetCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickFashionSet, self)
  self.fashionSetTipLabel = self:FindGO("TipLabel", self.fashionSetPart):GetComponent(UILabel)
  self.fashionSetTipLabel.text = ZhString.PackageView_FashionPageSaveAndLoadTip
  local x, y, z = LuaGameObject.GetLocalPosition(self.fashionSetTipLabel.transform)
  local printedX = self.fashionSetTipLabel.printedSize.x
  LuaVector3.Better_Set(tempVector3, (500 - printedX) / 2 + 30, y, z)
  self.fashionSetTipLabel.gameObject.transform.localPosition = tempVector3
  self:InitFashionPart()
end

function PackageFashionPage:InitSceneModel()
  if self.objSceneModelRoot then
    return
  end
  self.objSceneModelRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIModel("PackageFashionScene"))
  GameObject.DontDestroyOnLoad(self.objSceneModelRoot)
  self.objSceneModelRoot.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.objModelParent = self:FindGO("RolePos", self.objSceneModelRoot)
  self.tsfCameraPos = self:FindGO("CameraPos", self.objSceneModelRoot).transform
  UIManagerProxy.Instance:RefitSceneModel(self.tsfCameraPos, self:FindGO("Reloading_BG", self.objSceneModelRoot).transform)
end

function PackageFashionPage:ClickItemTab(cellCtl)
  local isNoneTipShow = self.itemlist:IsEmpty()
  self.noneTip:SetActive(isNoneTipShow)
  local cellCfg = cellCtl.data and cellCtl.data.tabConfig
  local myPro = myselfIns:GetMyProfession()
  if isNoneTipShow then
    self.noneTipLabel.text = not (not cellCfg or cellCfg[2] ~= 1055 or PackageEquip_ShowCar_Class[myPro]) and ZhString.PackageView_FashionPageNoneTipForNonBarrowProfessions or ZhString.PackageView_FashionPageNoneTip
  end
  self:TrySetFashionHide()
  self:SetMountFashionBtnState(self.isFashionTab, cellCfg[1] == SceneManual_pb.EMANUALTYPE_MOUNT)
end

function PackageFashionPage:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnEquipUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnMyDataChange)
  self:AddListenEvt(MyselfEvent.ChangeDress, self.RefreshMyselfModel)
end

function PackageFashionPage:AddEvts()
  self:AddClickEvent(self.objBtnEmoji, function(go)
    self:ShowEmojiPanel(true)
  end)
  self:RegistShowGeneralHelpByHelpID(1000, self:FindGO("FashionHelpButton"))
  self:AddClickEvent(self:FindGO("E_CloseButton", self.objEmojiPanel), function(go)
    self:ShowEmojiPanel(false)
  end)
  self:AddClickEvent(self:FindGO("BtnCloseFashionMsg", self.objSelectColorMsg), function(go)
    self.objSelectColorMsg:SetActive(false)
  end)
  self:AddClickEvent(self.mountFashionBtn, function()
    self:OnMountFashionBtnClick()
  end)
  self:AddClickEvent(self.fashionSetBtn, function()
    local value = self.fashionSetTog.value
    self.fashionSet_Arrow:SetActive(value)
    self.fashionSet_Icon.gameObject:SetActive(not value)
    self:DoFashionSetTween(value)
  end)
  self.listGroupFashion:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.itemlist:AddCellEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  
  function self.itemlist.scrollView.onDragStarted()
    self:ShowItemTip()
  end
  
  self:AddDragEvent(self.objRotateRole, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self:AddPressEvent(self.objRotateRole, function(go, isPress)
    self:PressRoleEvt(go, isPress)
  end)
end

function PackageFashionPage:SwitchFashionTab(tabIndex)
  self.itemlist.gameObject:SetActive(tabIndex == TabIndex.FashionTab)
  self.fashionBg:SetActive(tabIndex == TabIndex.FashionTab)
  self.objBtnEmoji:SetActive(tabIndex == TabIndex.FashionTab)
  if tabIndex == TabIndex.FashionTab then
    local isEmpty = self.itemlist:IsEmpty()
    self.noneTip:SetActive(isEmpty)
  else
    self.noneTip:SetActive(false)
  end
  self.container.DynamicSkillEffView:Switch(tabIndex == TabIndex.SkillEffectTab)
  self.container.rewardEffectView:Switch(tabIndex == TabIndex.RewardEffectTab)
  self:SetCurrentTabIconColor(self.tabStick[tabIndex].gameObject)
  self.fashionTog:Set(tabIndex == TabIndex.FashionTab)
  self.skillTog:Set(tabIndex == TabIndex.SkillEffectTab)
  self.rewardTog:Set(tabIndex == TabIndex.RewardEffectTab)
  self:SetMountFashionBtnState(tabIndex == TabIndex.FashionTab, self.isMountTab)
end

function PackageFashionPage:InitFashionTabNameTip()
  local fashionRightTab = self:FindGO("FashionTab")
  local skillEffectTab = self:FindGO("SkillEffectTab")
  local RewardEffectTab = self:FindGO("RewardEffectTab")
  self.fashionTog = self:FindComponent("Tog", UIToggle, fashionRightTab)
  self.skillTog = self:FindComponent("Tog", UIToggle, skillEffectTab)
  self.rewardTog = self:FindComponent("Tog", UIToggle, RewardEffectTab)
  local tabTab = {
    fashionRightTab,
    skillEffectTab,
    RewardEffectTab
  }
  self.fashionRightTabBgSp = fashionRightTab:GetComponent(UISprite)
  self.skillEffectTabBgSp = skillEffectTab:GetComponent(UISprite)
  self.rewardEffectTabBgSp = RewardEffectTab:GetComponent(UISprite)
  self.tabStick = {
    self.fashionRightTabBgSp,
    self.skillEffectTabBgSp,
    self.rewardEffectTabBgSp
  }
  self:SetCurrentTabIconColor(self.tabStick[1].gameObject)
  self:SwitchFashionTab(TabIndex.FashionTab)
  self:AddClickEvent(fashionRightTab, function(go)
    self:SwitchFashionTab(TabIndex.FashionTab)
  end)
  self:AddClickEvent(skillEffectTab, function(go)
    self:SwitchFashionTab(TabIndex.SkillEffectTab)
  end)
  self:AddClickEvent(RewardEffectTab, function(go)
    self:SwitchFashionTab(TabIndex.RewardEffectTab)
  end)
  self.tabIconSpList = {}
  local icon
  for i, v in ipairs(tabTab) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.PackageFashionPage, {state, i})
    end
    
    icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    TabNameTip.SwitchShowTabIconOrLabel(icon, Game.GameObjectUtil:DeepFindChild(v, "Label"))
  end
  self:AddEventListener(TipLongPressEvent.PackageFashionPage, self.HandleLongPress, self)
end

function PackageFashionPage:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

local unEquipedDatas = {}
local tabDatas = {}

function PackageFashionPage.GetTabDatas(itemTabConfig, tabData)
  TableUtility.ArrayClear(unEquipedDatas)
  TableUtility.ArrayClear(tabDatas)
  local _AdventureDataProxy = AdventureDataProxy.Instance
  local cfg = Fashion2AdvFashionTab[tabData.index]
  local advBagMap = _AdventureDataProxy.bagMap
  local bagData = advBagMap[cfg[1]]
  if bagData then
    local bagTabData = bagData:GetTab(cfg.replaceBag or cfg[2])
    local items = bagTabData and bagTabData:GetItems()
    if items then
      for i = 1, #items do
        local savedItems = items[i].savedItemDatas
        if savedItems and 0 < #savedItems then
          local found = false
          local useableNum = 0
          local singleItem
          for j = 1, #savedItems do
            singleItem = savedItems[j]
            if not found and PackageFashionPage.IsFashionItemEquiped(singleItem) then
              items[i].forcePos = cfg.forcePos
              table.insert(tabDatas, items[i])
              found = true
            end
            if PackageFashionPage.IsItemUseable(singleItem) then
              useableNum = useableNum + 1
            end
          end
          if not found and 0 < useableNum then
            table.insert(unEquipedDatas, items[i])
          end
        end
      end
    end
  end
  local _validTypes = {}
  for _itemType, _info in pairs(Table_ItemType) do
    if _info.AdventureLogGroup and _info.AdventureLogGroup == cfg[2] then
      table.insert(_validTypes, _itemType)
    end
  end
  if 0 < #_validTypes then
    local spFashionItems = BagProxy.Instance:GetBagItemsByTypes(_validTypes, BagProxy.BagType.SpecialFashion)
    for i = 1, #spFashionItems do
      table.insert(tabDatas, spFashionItems[i])
    end
  end
  for i = 1, #unEquipedDatas do
    unEquipedDatas[i].forcePos = cfg.forcePos
    table.insert(tabDatas, unEquipedDatas[i])
  end
  if AdvFashion2FashionHideType[cfg[2]] then
    TableUtility.ArrayPushFront(tabDatas, BagItemEmptyType.Empty)
  end
  return tabDatas
end

function PackageFashionPage.IsItemUseable(itemData)
  if not itemData or itemData.IsJobLimit and itemData:IsJobLimit() then
    return false
  end
  if itemData.IsUseItem and itemData:IsUseItem() then
    return ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(itemType, itemData.staticData.id) and not itemData:IsLimitUse()
  elseif itemData.equipInfo then
    if itemData.equipInfo:IsWeapon() then
      local myPro = myselfIns:GetMyProfession()
      local weaponFashionForSpecialProf = GameConfig.WeaponIllusion[GameConfig.ClassIllusion[myPro] or 0]
      if weaponFashionForSpecialProf then
        local weapons = curEquippedWeaponItemType and weaponFashionForSpecialProf[curEquippedWeaponItemType]
        if weapons and 0 < TableUtility.ArrayFindIndex(weapons, itemData.staticData.id) then
          return true
        end
      end
      if curEquippedWeaponItemType ~= nil then
        return itemData.staticData.Type == curEquippedWeaponItemType
      end
    end
    return itemData:IsPetEgg() or itemData:CanEquip()
  end
  return true
end

function PackageFashionPage.IsFashionItemEquiped(itemData, advFashion)
  if not itemData or itemData == BagItemEmptyType.Empty or itemData == BagItemEmptyType.Grey then
    return false
  end
  if itemData.equipInfo then
    if advFashion and advFashion == 1026 then
      local comp = BagProxy.Instance.fashionEquipBag:GetEquipBySite(1)
      if comp and comp.staticData.id == itemData.staticData.id then
        return true
      end
      return false
    end
    local site = itemData.equipInfo:GetEquipSite()
    for i = 1, #site do
      local comp = BagProxy.Instance.fashionEquipBag:GetEquipBySite(site[i])
      if comp and comp.staticData.id == itemData.staticData.id then
        return true
      end
    end
  end
  return false
end

function PackageFashionPage:OnEquipUpdate()
  if not self.inited then
    return
  end
  self:UpdateList()
  self:RefreshItemStatus()
  self:UpdateTabRedTips()
  if self:GetAdvFashionOfCurrentTab(true) == 1055 then
    self:RefreshMyselfBarrow()
  end
  local userdata = Game.Myself.data.userdata
end

function PackageFashionPage:RefreshItemStatus()
  if not self.inited then
    return
  end
  local weapon = BagProxy.Instance.roleEquip:GetWeapon()
  curEquippedWeaponItemType = weapon and weapon.staticData.Type or nil
  self.itemlist:UpdateTabList(ItemNormalList.TabType.FashionPage, Fashion2AdvFashionTab, false)
  for _, cell in pairs(self.itemCells) do
    cell:RefreshStatus()
    cell:CheckRedTip()
  end
  local groupItemCells = self.listGroupFashion:GetCells()
  for _, cell in pairs(groupItemCells) do
    cell:RefreshStatus()
  end
end

function PackageFashionPage:ClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data or data == BagItemEmptyType.Grey then
    return
  end
  if data == BagItemEmptyType.Empty then
    self:TryCallSwitchFashionHideByCurrentAdvFashion()
    local advFashion = self:GetAdvFashionOfCurrentTab()
    if advFashion == 1025 or advFashion == 1026 then
      self:DoPlayEmojiAct(m_actionID_withWeapon)
    end
    return
  end
  if self.forbidClick then
    return
  end
  if Game.Myself.data:IsInMagicMachine() then
    MsgManager.ShowMsgByIDTable(39002)
    return
  end
  local actId
  if data:IsMount() or data:IsMountPet() then
    if self.mountId == nil then
      MsgManager.ShowMsgByIDTable(27203)
      return
    end
    actId = m_actionID_ride
  elseif data.equipInfo and data.equipInfo:IsWeapon() then
    actId = m_actionID_withWeapon
  elseif data.equipInfo and data.equipInfo:IsBarrow() then
    local myPro = myselfIns:GetMyProfession()
    if PackageEquip_ShowCar_Class[myPro] and not BagProxy.Instance.roleEquip:GetBarrow() then
      MsgManager.ShowMsgByIDTable(27206)
      return
    end
    actId = m_actionID_withBarrow
  end
  local fashionItemData = cellCtl.fashionItemData
  if fashionItemData and fashionItemData.isAdventureItemData and #fashionItemData.savedItemDatas > 0 then
    if not self.groupfashionItemsData then
      self.groupfashionItemsData = {}
    end
    TableUtility.ArrayClear(self.groupfashionItemsData)
    local savedItems = fashionItemData.savedItemDatas
    local singleItem
    for i = 1, #savedItems do
      singleItem = savedItems[i]
      if PackageFashionPage.IsItemUseable(singleItem) or PackageFashionPage.IsFashionItemEquiped(singleItem) then
        self.groupfashionItemsData[#self.groupfashionItemsData + 1] = singleItem
      end
    end
    if #self.groupfashionItemsData > 1 then
      self.listGroupFashion:ResetDatas(self.groupfashionItemsData)
      self.objSelectColorMsg:SetActive(true)
      self.scrollFashions:ResetPosition()
      return
    end
    data = self.groupfashionItemsData[1]
  end
  local class = myselfIns:GetMyProfession()
  local pos
  if ProfessionProxy.ShieldPosCanEquipWeapon(class, Game.Myself) then
    local tabData = self.itemlist.nowTabData
    local forcePos = tabData and tabData.tabConfig.forcePos
    pos = forcePos and 1
  end
  if cellCtl.isEquiped and not cellCtl.isFashionHide then
    FunctionItemFunc.OffEquip_Fashion(data, pos)
  elseif data and data.CanEquip and data:CanEquip() then
    FunctionItemFunc.DepositFashionEvt(data, pos)
    self:TryCallSetFashionHideByCurrentAdvFashion(false)
    if actId then
      self:DoPlayEmojiAct(actId)
    end
  end
  self.forbidClick = true
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self.forbidClick = false
  end, self, 2)
end

function PackageFashionPage:DoubleClickItem(cellCtl)
  local data = cellCtl.data
  if data == "Empty" or data == "Grey" then
    data = nil
  end
  if data then
    local funcId = 38
    if type(funcId) == "number" then
      local func = FunctionItemFunc.Me():GetFuncById(funcId)
      if type(func) == "function" then
        func(data)
      end
    end
    self:ShowPackageItemTip()
  end
end

function PackageFashionPage:ShowPackageItemTip(data, ignoreBounds)
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    showUpTip = true,
    funcConfig = self.container:GetDataFuncs(data),
    ignoreBounds = ignoreBounds
  }
  local comps, offset = {}, {-210, 0}
  if data.equipInfo or data:IsMount() then
    local site = data.equipInfo:GetEquipSite()
    for i = 1, #site do
      local comp = BagProxy.Instance.roleEquip:GetEquipBySite(site[i])
      if comp then
        table.insert(comps, comp)
      end
    end
  end
  sdata.compdata1 = comps[1]
  sdata.compdata2 = comps[2]
  if comps[1] then
    offset = {0, 0}
  end
  local tip = self:ShowItemTip(sdata, self.normalStick, nil, offset)
  if tip and tip.ActiveFavorite then
    tip:ActiveFavorite()
  end
end

function PackageFashionPage:UpdateList(notRearrange)
  self.notRearrange = true
  self.itemlist:UpdateList(true)
  self:TrySetFashionHide()
end

function PackageFashionPage:HandleItemUpdate()
  self:InitFashionTab()
  if not self.inited then
    return
  end
  self:UpdateList()
end

function PackageFashionPage:RefreshMyselfModel(isSwitching)
  if not self.inited then
    return
  end
  if isSwitching ~= true and self.isCurrentShow ~= true then
    return
  end
  self:RefreshMyselfRole()
  self:RefreshMyselfMount()
  self:RefreshMyselfBarrow()
  self:SetMountFashionBtnState(self.isFashionTab, self.isMountTab)
end

function PackageFashionPage:ActiveRoleMount(b)
  if self.showRoleMount == b then
    return
  end
  self.showRoleMount = b
  self.role:_ActionHideMount(self.showRoleMount == false)
  self.role:SetMountDisplay(self.showRoleMount == true)
  if b then
    self.role:SetScale(0.8)
  else
    self.role:SetScale(1)
  end
end

function PackageFashionPage:RefreshMyselfRole()
  local userdata = Game.Myself.data.userdata
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  if self.role == nil then
    parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
    self.role = Asset_Role_UI.Create(parts)
    self.role:SetParent(self.objModelParent.transform, false)
    self.role:SetLayer(Game.ELayer.Outline)
    self.role:SetPosition(LuaGeometry.Const_V3_zero)
    self.role:SetEulerAngleY(180)
    self.role:SetScale(1)
    self.role:RegisterWeakObserver(self)
    self.role:SetLogicIgnoreScale(true)
    self.role:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
  end
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
  self.haveBody = parts[partIndex.Body] ~= 0
  parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
  self.haveHair = parts[partIndex.Hair] ~= 0
  parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
  parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
  parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
  parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
  parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
  parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
  parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
  self.haveEye = parts[partIndex.Eye] ~= 0
  parts[partIndex.Mount] = userdata:Get(UDEnum.MOUNT) or 0
  parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
  parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
  parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  self.role:SetSuffixReplaceMap(Asset_RoleUtility.GetSuffixReplaceMap(MyselfProxy.Instance:GetMyProfession(), parts[partIndex.Body], parts[partIndexEx.Gender]))
  Game.Myself.data:SpecialProcessPart_Sheath(parts)
  Game.Myself.data:SetMountFashionParts(parts, userdata)
  self.role:Redress(parts, true)
  self:RefreshBuffState(parts)
  Asset_Role.DestroyPartArray(parts)
  self.role:SetMountDisplay(self.showRoleMount == true)
  self.role:SetEpNodesDisplay(true)
  self:CheckUpdateEmojiData()
end

function PackageFashionPage:RefreshBuffState(parts)
  if not self.buffEffects then
    self.buffEffects = {}
  end
  if not self.containBuffPart then
    self.containBuffPart = {}
  end
  for _partType, _index in pairs(Asset_Role.PartIndex) do
    local _id = parts and parts[_index] or 0
    if _id and self.containBuffPart[_index] and self.containBuffPart[_index] ~= _id then
      xdlog("移除特效")
      self.containBuffPart[_index] = nil
      local effList = self.buffEffects[_index] or {}
      for i = #effList, 1, -1 do
        effList[i]:Destroy()
        effList[i] = nil
      end
    end
    if 0 < _id and (not self.containBuffPart[_index] or self.containBuffPart[_index] ~= _id) then
      local equipData = Table_Equip[_id]
      local fashionBuff = equipData and equipData.FashionBuff
      if fashionBuff and 0 < #fashionBuff then
        self.containBuffPart[_index] = _id
        for i = 1, #fashionBuff do
          local buffData = Table_Buffer[fashionBuff[i]]
          local buffStateID = buffData and buffData.BuffStateID
          if buffStateID then
            local buffStateData = Table_BuffState[buffStateID]
            local path = buffStateData.Effect
            local eff = self.role:PlayEffectOn(path, buffStateData.EP)
            if not self.buffEffects[_index] then
              self.buffEffects[_index] = {}
            end
            xdlog("添加特效", _index, path)
            table.insert(self.buffEffects[_index], eff)
          end
        end
      end
    end
  end
end

function PackageFashionPage:ActiveAssetMount(b)
  if self.showAssetMount == b then
    return
  end
  self.showAssetMount = b
  if self.asset_Mount == nil then
    return
  end
  local tempV3 = LuaGeometry.GetTempVector3()
  tempV3:Set(b and -0.25 or 0, 0, 0)
  self.role:SetPosition(tempV3)
  if b then
    tempV3:Set(Config_MountTransform.position_x, Config_MountTransform.position_y, Config_MountTransform.position_z)
  else
    tempV3:Set(invisibleComponent, invisibleComponent, invisibleComponent)
  end
  self.asset_Mount:ResetLocalPosition(tempV3)
end

function PackageFashionPage:RefreshMyselfMount()
  local mountId
  local mountItem = BagProxy.Instance.roleEquip:GetMount()
  if mountItem ~= nil then
    mountId = mountItem.staticData.id
    if GameConfig.Mount2Body[mountId] then
      mountId = nil
    else
      local fashionMount = BagProxy.Instance.fashionEquipBag:GetMount()
      if fashionMount then
        mountId = fashionMount.staticData.id
      end
    end
  end
  if self.mountId == mountId then
    return
  end
  self.mountId = mountId
  if self.asset_Mount then
    self.asset_Mount:Destroy()
    self.asset_Mount = nil
  end
  if mountId == nil then
    return
  end
  self.asset_Mount = Asset_RolePart.Create(Asset_Role.PartIndex.Mount, mountId, function(rolePart, arg, assetRolePart)
    self.asset_Mount = assetRolePart
    self.asset_Mount:ResetParent(self.objModelParent.transform)
    self.asset_Mount:SetLayer(Game.ELayer.Outline)
    local tempV3 = LuaGeometry.GetTempVector3()
    if self.showAssetMount then
      tempV3:Set(Config_MountTransform.position_x, Config_MountTransform.position_y, Config_MountTransform.position_z)
    else
      tempV3:Set(invisibleComponent, invisibleComponent, invisibleComponent)
    end
    self.asset_Mount:ResetLocalPosition(tempV3)
    tempV3:Set(Config_MountTransform.eulerAngles_x, Config_MountTransform.eulerAngles_y, Config_MountTransform.eulerAngles_z)
    self.asset_Mount:ResetLocalEulerAngles(tempV3)
    self.asset_Mount:ResetLocalScaleXYZ(Config_MountTransform.Scale, Config_MountTransform.Scale, Config_MountTransform.Scale)
  end, nil, Asset_RolePart.SkinQuality.Bone4)
  self.asset_Mount:RegisterWeakObserver(self)
end

function PackageFashionPage:ActiveAssetBarrow(b)
  if self.showAssetBarrow == b then
    return
  end
  self.showAssetBarrow = b
  if self.asset_Barrow == nil then
    return
  end
  local tempV3 = LuaGeometry.GetTempVector3()
  tempV3:Set(b and -0.25 or 0, 0, 0)
  self.role:SetPosition(tempV3)
  if b then
    tempV3:Set(Config_BarrowTransform.position_x, Config_BarrowTransform.position_y, Config_BarrowTransform.position_z)
  else
    tempV3:Set(invisibleComponent, invisibleComponent, invisibleComponent)
  end
  self.asset_Barrow:SetPosition(tempV3)
end

function PackageFashionPage:RefreshMyselfBarrow()
  local barrowId
  local barrowItem = BagProxy.Instance.roleEquip:GetBarrow()
  if barrowItem and barrowItem.staticData then
    barrowId = barrowItem.staticData.id
    barrowItem = BagProxy.Instance.fashionEquipBag:GetBarrow()
    if barrowItem and barrowItem.staticData then
      barrowId = barrowItem.staticData.id
    end
  end
  if self.barrowId == barrowId then
    return
  end
  self.barrowId = barrowId
  if self.asset_Barrow then
    self.asset_Barrow:Destroy()
    self.asset_Barrow = nil
  end
  if barrowId == nil then
    return
  end
  self.asset_Barrow = Asset_RoleUtility.CreateNpcRole(GameConfig.Pet.merchant_barrow[self.barrowId])
  self.asset_Barrow:SetParent(self.objModelParent.transform)
  self.asset_Barrow:SetLayer(Game.ELayer.Outline)
  local tempV3 = LuaGeometry.GetTempVector3()
  if self.showAssetBarrow then
    tempV3:Set(Config_BarrowTransform.position_x, Config_BarrowTransform.position_y, Config_BarrowTransform.position_z)
  else
    tempV3:Set(invisibleComponent, invisibleComponent, invisibleComponent)
  end
  self.asset_Barrow:SetPosition(tempV3)
  tempV3:Set(Config_BarrowTransform.eulerAngles_x, Config_BarrowTransform.eulerAngles_y, Config_BarrowTransform.eulerAngles_z)
  self.asset_Barrow:SetEulerAngles(tempV3)
  self.asset_Barrow:SetScale(Config_BarrowTransform.Scale)
  self.asset_Barrow:RegisterWeakObserver(self)
end

function PackageFashionPage:ObserverEvent(role, param)
  if role ~= self.role then
    return
  end
  if type(param) ~= "table" then
    return
  end
  local evt, partObj, part = param[1], param[2], param[3]
  if part == Asset_Role.PartIndex.Body then
    if self.role then
      if self.showRoleMount and self.role:HasActionRaw("ride_wait") then
        self.role:SetScale(0.8)
      else
        self.role:SetScale(1)
      end
    end
    self:PlayRoleAction(self.lastActionName or "wait", 33)
  elseif (part == Asset_Role.PartIndex.RightWeapon or part == Asset_Role.PartIndex.LeftWeapon) and self.role:IsPlayingAction("attack_wait") then
    self:PlayRoleAction("attack_wait", 33)
  end
  if evt == Asset_Role_UI_Event.PartCreated then
    UIUtil.NormalizedSortingOrder(partObj)
  elseif evt == Asset_Role_UI_Event.PartCreated then
    UIUtil.RevertSortingOrder(partObj.gameObject)
  end
end

function PackageFashionPage:ObserverDestroyed(obj)
  if obj == self.role then
    self.role:UnregisterWeakObserver(self)
    self.role = nil
  elseif obj == self.asset_Mount then
    self.asset_Mount:UnregisterWeakObserver(self)
    self.asset_Mount = nil
  end
end

function PackageFashionPage:DestroyRoleModel()
  if self.role and self.role:Alive() then
    self.role:SetEpNodesDisplay(false)
    self.role:Destroy()
  end
  self.role = nil
  if self.asset_Mount and self.asset_Mount:Alive() then
    self.asset_Mount:Destroy()
  end
  self.asset_Mount = nil
  if self.asset_Barrow and self.asset_Barrow:Alive() then
    self.asset_Barrow:Destroy()
  end
  self.asset_Barrow = nil
  self.lastActionName = nil
  self.lastActId = nil
  self.showAssetMount = nil
  self.showRoleMount = nil
  self.mountId = nil
end

function PackageFashionPage:PressRoleEvt(go, isPress)
  if self.role then
    self.objRotateRoleArrows:SetActive(isPress)
  end
end

function PackageFashionPage:RotateRoleEvt(go, delta)
  if self.role then
    self.role:RotateDelta(-delta.x * 360 / 400)
  end
end

function PackageFashionPage:CheckUpdateEmojiData()
  if self.checkEmojiTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 121)
    self.checkEmojiTick = nil
  end
  if self.emojiPanelShow ~= true then
    return
  end
  if not self.role:_IsLoading() then
    self:UpdateEmojiData()
    return
  end
  self.checkEmojiTick = TimeTickManager.Me():CreateTick(0, 33, function()
    if self.role:_IsLoading() then
      return
    end
    self:UpdateEmojiData()
    TimeTickManager.Me():ClearTick(self, 121)
    self.checkEmojiTick = nil
  end, self, 121)
end

function PackageFashionPage:ShowEmojiPanel(isShow)
  if self.emojiPanelShow == isShow then
    return
  end
  self.emojiPanelShow = isShow
  self.objEmojiPanel:SetActive(isShow)
  self:CheckUpdateEmojiData()
end

function PackageFashionPage:UpdateEmojiData()
  if not self.emojiPanelShow then
    return
  end
  if not self.role then
    return
  end
  self:ClearEmojiData()
  self.emojiData = ChatRoomProxy.Instance:GetActionExpressions()
  self.emojiCtl:ResetDatas(self.emojiData)
end

function PackageFashionPage:ClearEmojiData()
end

function PackageFashionPage:ClickEmojiCell(cellctl)
  if cellctl.type ~= UIEmojiType.Action or cellctl.forbidState == 1 then
    return
  end
  self:DoPlayEmojiAct(cellctl.id)
end

function PackageFashionPage:DoPlayEmojiAct(actId)
  if self.role:_IsLoading() then
    return
  end
  if self.lastActId == actId then
    return
  end
  if self.lastActId == m_actionID_ride then
    self:ActiveRoleMount(false)
  elseif self.lastActId == m_actionID_withMount then
    self:ActiveAssetMount(false)
  elseif self.lastActId == m_actionID_withBarrow then
    self:ActiveAssetBarrow(false)
  end
  self.lastActId = actId
  if actId == m_actionID_ride then
    if self.mountId == nil or Game.Myself.data:IsInMagicMachine() then
      MsgManager.ShowMsgByIDTable(27203)
      self.lastActId = nil
      return
    end
    self:ActiveRoleMount(true)
    self:PlayRoleAction("wait")
  elseif actId == m_actionID_withMount then
    if self.mountId == nil or Game.Myself.data:IsInMagicMachine() then
      MsgManager.ShowMsgByIDTable(27203)
      self.lastActId = nil
      return
    end
    self:ActiveAssetMount(true)
    self:PlayRoleAction("wait")
  elseif actId == m_actionID_withBarrow then
    if self.barrowId == nil or not BagProxy.Instance.roleEquip:GetBarrow() then
      MsgManager.ShowMsgByIDTable(27206)
      return
    end
    self:ActiveAssetBarrow(true)
    self:PlayRoleAction("wait")
  else
    local sdata = UIEmojiCell.TryReplaceMyProfessionAction(actId)
    local once = TableUtility.ArrayFindIndex(GameConfig.OnlyOnceAction.action_id, actId) > 0 and true or false
    self:PlayRoleAction(sdata.Name, nil, not once)
  end
end

function PackageFashionPage:PlayRoleAction(name, delay, loop)
  if delay == nil then
    self:_PlayRoleAction(name, loop)
  else
    TimeTickManager.Me():ClearTick(self, 111)
    TimeTickManager.Me():CreateTick(delay, 0, function()
      self:_PlayRoleAction(name, loop)
      TimeTickManager.Me():ClearTick(self, 111)
    end, self, 111)
  end
end

function PackageFashionPage:_PlayRoleAction(name, loop)
  if name == nil then
    return
  end
  if self.role == nil then
    return
  end
  self.lastActionName = name
  local actParam = Asset_Role.GetPlayActionParams(name)
  if loop ~= nil then
    actParam[5] = loop
  else
    actParam[5] = true
  end
  actParam[6] = true
  self.role:PlayAction(actParam)
end

function PackageFashionPage:GetAdvFashionOfCurrentTab(ignoreFashionHide)
  local tabData = self.itemlist.nowTabData
  local advFashion = tabData and (tabData.replaceBag or tabData.tabConfig[2])
  if not advFashion then
    LogUtility.Error("Cannot get tabConfig of nowTabData!")
    return
  end
  if ignoreFashionHide then
    return advFashion
  end
  return AdvFashion2FashionHideType[advFashion] and advFashion
end

function PackageFashionPage:OnMyDataChange()
  if not self.inited then
    return
  end
  self:TrySetFashionHide()
end

local getFashionHide = function(fashionHideType)
  if not fashionHideType then
    return
  end
  local fashionHide = myselfIns:GetMyselfFashionHide()
  return fashionHide >> fashionHideType & 1 > 0
end

function PackageFashionPage:TryCallSetFashionHideByCurrentAdvFashion(isHide)
  local advFashion = self:GetAdvFashionOfCurrentTab()
  if not advFashion then
    return
  end
  isHide = isHide and true or false
  local fashionHideType = AdvFashion2FashionHideType[advFashion]
  if getFashionHide(fashionHideType) == isHide then
    return
  end
  local fashionHide = myselfIns:GetMyselfFashionHide()
  fashionHide = fashionHide + (isHide and 1 or -1) * (1 << fashionHideType)
  ServiceNUserProxy.Instance:CallSetMyselfOptionCmd(fashionHide)
end

function PackageFashionPage:TryCallSwitchFashionHideByCurrentAdvFashion()
  local advFashion = self:GetAdvFashionOfCurrentTab()
  if not advFashion then
    return
  end
  local isNowHide = getFashionHide(AdvFashion2FashionHideType[advFashion])
  if isNowHide == nil then
    return
  end
  self:TryCallSetFashionHideByCurrentAdvFashion(not isNowHide)
end

function PackageFashionPage:TrySetFashionHide()
  local advFashion = self:GetAdvFashionOfCurrentTab()
  if not advFashion then
    return
  end
  for _, cell in pairs(self.itemCells) do
    cell:TrySetFashionHide(advFashion, getFashionHide(AdvFashion2FashionHideType[advFashion]))
    cell:RefreshStatus()
  end
end

function PackageFashionPage:Switch(isShow)
  self.initRetryCount = 0
  self.errorOccured = nil
  if self.isCurrentShow ~= isShow then
    if isShow then
      Game.EnviromentManager:SetSpecialBloomEffect(EnviromentManager.UIRoleBloom)
    else
      Game.EnviromentManager:UnSetSpecialBloomEffect()
    end
  end
  if isShow then
    self:InitSceneModel()
    self:InitFashionPage()
    self:RefreshItemStatus()
    self:RefreshMyselfModel(true)
    self:SwitchCameraToModel()
  elseif not self.inited then
    return
  else
    self:ResetCameraToDefault()
    self:DestroyRoleModel()
    self:ShowPackageItemTip()
  end
  self.objRotateRoleArrows:SetActive(false)
  self.objSelectColorMsg:SetActive(false)
  self:ShowEmojiPanel(false)
  local initTab = 1
  if self.container.viewdata and self.container.viewdata.viewdata and self.container.viewdata.viewdata.item then
    local item = self.container.viewdata.viewdata.item
    local itemType = item and item.staticData and item.staticData.Type
    local adventureLogGroup = Table_ItemType[itemType].AdventureLogGroup
    for index, info in pairs(Fashion2AdvFashionTab) do
      if info[2] == adventureLogGroup then
        initTab = index
        xdlog("初始页签", initTab)
        break
      end
    end
    xdlog("初始页签", item.staticData.id, initTab)
  end
  self.itemlist:ChooseTab(initTab, true)
  self.itemlist.tabCtl:ScrollToIndex(initTab)
  self.gameObject:SetActive(isShow)
  self.isCurrentShow = isShow
end

function PackageFashionPage:ResetCameraToDefault()
  if not self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.cameraWorld and not LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.tsfCameraWorld.position = self.vecCameraPosRecord
    self.tsfCameraWorld.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self.container:UpdateCameraViewPort(0)
      self.cameraController:ForceApplyCurrentInfo()
      self.cameraController:UpdatePosition()
      self.container:UpdateCameraViewPort()
    end
  end
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function PackageFashionPage:OnShow()
  if self.isCurrentShow then
    self:SwitchCameraToModel()
  end
end

function PackageFashionPage:OnHide()
  self:ResetCameraToDefault()
end

function PackageFashionPage:SwitchCameraToModel()
  if self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    return
  end
  if not self.cameraWorld or LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      if not self.errorOccured then
        self.objBtnEmoji:SetActive(false)
        self.objRotateRole:SetActive(false)
        self.errorOccured = true
      end
      self.initRetryCount = self.initRetryCount + 1
      if self.initRetryCount > 9 then
        LogUtility.Error("无法找到CameraController，重试10次失败，将无法使用表情功能！")
        return
      end
      self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
        self.ltInitCamera = nil
        self:SwitchCameraToModel()
      end, self, 3)
      return
    end
  end
  if self.errorOccured then
    self.objBtnEmoji:SetActive(true)
    self.objRotateRole:SetActive(true)
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  else
    LogUtility.Error("没有在主摄像机上找到CameraController！")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, LuaGameObject.GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, LuaGameObject.GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.tsfCameraPos))
  self.tsfCameraWorld.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.tsfCameraPos))
  self.cameraWorld.fieldOfView = 20
  self.isCameraOnModel = true
end

function PackageFashionPage:ResetCameraToDefault()
  if not self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    self.ltInitCamera:Destroy()
    self.ltInitCamera = nil
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.cameraWorld and not LuaGameObject.ObjectIsNull(self.cameraWorld) then
    self.tsfCameraWorld.position = self.vecCameraPosRecord
    self.tsfCameraWorld.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self.container:UpdateCameraViewPort(0)
      self.container:UpdateCameraViewPort()
    end
  end
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function PackageFashionPage:OnEnter()
  PackageFashionPage.super.OnEnter(self)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  CameraFilterProxy.Instance:Pause()
end

function PackageFashionPage:OnExit()
  if self.inited then
    self:ResetCameraToDefault()
    self:DestroyRoleModel()
    self:ClearEmojiData()
    self.emojiPanelShow = nil
  end
  self.buffEffects = nil
  self.containBuffPart = nil
  if self.objSceneModelRoot then
    LuaGameObject.DestroyObject(self.objSceneModelRoot)
    self.objSceneModelRoot = nil
    self.objModelParent = nil
    self.tsfCameraPos = nil
  end
  EventManager.Me():RemoveEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
  Game.EnviromentManager:UnSetSpecialBloomEffect()
  CameraFilterProxy.Instance:Resume()
  PackageFashionPage.super.OnExit(self)
end

PackageFashionPage.TabName = {
  [1] = ZhString.PackageView_FashionPageTabName,
  [2] = ZhString.PackageView_FashionPageSkillEffTabName,
  [3] = ZhString.PackageView_FashionPageRewardEffTabName
}

function PackageFashionPage:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, PackageFashionPage.TabName[index], false, self.tabStick[index])
end

function PackageFashionPage:OnMountFashionBtnClick()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MountDressingView,
    viewdata = {
      mountId = Game.Myself.data:GetMount()
    }
  })
end

function PackageFashionPage:SetMountFashionBtnState(isFashionTab, isMountTab, mountId)
  self.isFashionTab = isFashionTab or false
  self.isMountTab = isMountTab or false
  mountId = mountId or Game.Myself.data:GetMount()
  local config = Table_Mount[mountId]
  local isMountDressing = config and config.IsMountDressing == 1 or false
  self.mountFashionBtn:SetActive(self.isFashionTab and self.isMountTab and isMountDressing)
end

function PackageFashionPage:DoFashionSetTween(bool)
  if bool then
    for i = 1, #self.fashionSetTween do
      self.fashionSetTween[i]:PlayForward()
    end
  else
    for i = 1, #self.fashionSetTween do
      self.fashionSetTween[i]:PlayReverse()
    end
  end
end

local fashionSetIconName = "bg_icon_clothes_"

function PackageFashionPage:InitFashionPart()
  self.fashionSetCtrl:SetEmptyDatas(5)
end

function PackageFashionPage:ResetFashionSet()
  local curChooseSet = ProfessionProxy.Instance:GetCurFashionSetIndex()
  self.fashionSet_Icon.spriteName = fashionSetIconName .. curChooseSet
  self.fashionSetTog.value = false
  self.fashionSet_Arrow:SetActive(false)
  self.fashionSet_Icon.gameObject:SetActive(true)
  for i = 1, #self.fashionSetTween do
    self.fashionSetTween[i]:ResetToBeginning()
  end
  local cells = self.fashionSetCtrl:GetCells()
  for i = 1, 5 do
    cells[i]:SetIndex(i)
    cells[i]:SetChoose(i == curChooseSet)
  end
end

function PackageFashionPage:handleClickFashionSet(cellCtrl)
  xdlog("点击套装")
  local curIndex = cellCtrl.index or 1
  local curChooseSet = ProfessionProxy.Instance:GetCurFashionSetIndex()
  if curIndex == curChooseSet then
    redlog("点击重复  取消")
    return
  end
  local cells = self.fashionSetCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(i == curIndex)
  end
  self.fashionSet_Icon.spriteName = fashionSetIconName .. curIndex
  self:SetFashionSet(curIndex)
end

function PackageFashionPage:SetFashionSet(index)
  ProfessionProxy.Instance:SetCurFashionSetIndex(index)
  ServiceItemProxy.Instance:CallSwitchFashionEquipRecordItemCmd(index)
end
