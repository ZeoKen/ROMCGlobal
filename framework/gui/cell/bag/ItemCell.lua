autoImport("BaseCDCell")
autoImport("ItemCardCell")
autoImport("PortraitFrameCell")
ItemCell = class("ItemCell", BaseCDCell)
ItemCell.CellPartPathFolderName = "ItemCellParts"
ItemCell.DefaultNumLabelLocalPos = LuaVector3.New(35, -37, 0)
ItemCell.CardSlotElementWidth = 10
ItemCell.Config = {
  PicId = 50,
  PetPicId = 51,
  HomePicId = 55,
  MountFashionPicId = 57,
  ChipId = 110,
  ARTIFACT = 550
}

function ItemCell:GetCellPartPrefix(key)
  return "ItemCell_"
end

function ItemCell:_LoadCellPart(key, parent)
  local partPrefix = self:GetCellPartPrefix(key)
  if StringUtil.IsEmpty(partPrefix) then
    return
  end
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell(string.format("%s/%s", self.CellPartPathFolderName, partPrefix)) .. key, parent)
  if go then
    go.name = key
    return go
  end
end

function ItemCell:AdjustDepth(rootGO)
  if not self.minDepth or not rootGO then
    return
  end
  local widgets = UIUtil.GetAllComponentsInChildren(rootGO, UIWidget, true)
  if widgets then
    for _, ws in ipairs(widgets) do
      ws.depth = ws.depth + self.minDepth
    end
  end
end

function ItemCell:LoadCellPart(key, parent)
  if self.cellPartMap[key] then
    return self.cellPartMap[key]
  end
  local go = self:_LoadCellPart(key, parent)
  if go and self.minDepth then
    local ws = UIUtil.GetAllComponentInChildren(go, UIWidget)
    if ws then
      for i = 1, #ws do
        ws[i].depth = ws[i].depth + self.minDepth
      end
    end
  end
  self.cellPartMap[key] = go
  return go
end

function ItemCell:ClearAllCellParts()
  for _, go in pairs(self.cellPartMap) do
    GameObject.DestroyImmediate(go)
  end
  TableUtility.TableClear(self.cellPartMap)
end

function ItemCell:Init()
  if not BagType_SymbolMap then
    BagType_SymbolMap = {
      [BagProxy.BagType.PersonalStorage] = "com_icon_Corner_warehouse",
      [BagProxy.BagType.Barrow] = "com_icon_Corner_wheelbarrow",
      [BagProxy.BagType.Temp] = "com_icon_Corner_temporarybag"
    }
  end
  ItemCell.super.Init(self)
  self:InitItemCell()
end

function ItemCell:SetDefaultBgSprite(atlas, spriteName)
  self.DefaultBg_atlas = atlas
  self.DefaultBg_spriteName = spriteName
end

function ItemCell:InitItemCell()
  self.item = self:FindGO("Item")
  self.empty = self:FindGO("Empty")
  self.empty_hideIcon = self:FindGO("HideIconSymbol", self.empty)
  self.normalItem = self:FindGO("NormalItem", self.item)
  self.iconGO = self:FindGO("Icon_Sprite", self.normalItem)
  self.iconTrans = self.iconGO and self.iconGO.transform
  self.icon = self.iconGO and self.iconGO:GetComponent(UISprite)
  self.newTag = self:FindGO("NewTag", self.normalItem)
  self.invalid = self:FindGO("Invalid", self.normalItem)
  self.nameLab = self:FindComponent("ItemName", UILabel)
  self.coldDown = self:FindComponent("ColdDown", UISprite, self.item)
  self.numHide = false
  self.cellPartMap = {}
  local valid2 = self:FindGO("Invalid (1)")
  if self.invalid and valid2 then
    local validspr = self.invalid:GetComponent(UISprite)
    local validspr2 = valid2:GetComponent(UISprite)
    IconManager:SetUIIcon("icon_24", validspr)
    IconManager:SetUIIcon("icon_24", validspr2)
  end
end

function ItemCell:InitCardSlot()
  self.cardSlotGO = self:FindGO("CardSlot", self.equipGO)
  local slotCpy, cardGO = self:FindGO("CardEquip1", self.cardSlotGO)
  self.cardSlotSymbols = {}
  for i = 1, 5 do
    if i == 1 then
      cardGO = slotCpy
    else
      cardGO = self:FindGO("CardEquip" .. i, self.cardSlotGO)
      if not cardGO then
        cardGO = self:CopyGameObject(slotCpy, self.cardSlotGO)
        cardGO.name = "CardEquip" .. i
      end
    end
    local cardSp = cardGO:GetComponent(UISprite)
    self.cardSlotSymbols[-i] = cardGO
    self.cardSlotSymbols[i] = cardSp
  end
end

function ItemCell:RemoveUnuseObj(key)
  if not self:ObjIsNil(self[key]) then
    GameObject.DestroyImmediate(self[key])
    self[key] = nil
  end
end

function ItemCell:SetData(data)
  self.data = data
  local cellGO = self.item or self.gameObject
  if data == nil or data.staticData == nil then
    if self.empty then
      self.empty:SetActive(true)
      if self.empty_hideIcon then
        self.empty_hideIcon:SetActive(false)
      end
    end
    if cellGO then
      cellGO:SetActive(false)
    end
    return
  end
  if cellGO then
    cellGO:SetActive(true)
  end
  if self.empty then
    self.empty:SetActive(false)
  end
  self:UpdateNumLabel(data.num or 0)
  self:ActiveNewTag(data:IsNew())
  self:SetCardInfo(data)
  if self.nameLab then
    self.nameLab.text = self.data:GetName()
  end
  if data.staticData and data.IsAnonymousItem and data:IsAnonymousItem() then
    local isAnonymous = Game.Myself.data:IsAnonymous()
    self:SetActiveSymbol(isAnonymous)
  elseif self.isCard then
    self:SetActiveSymbol(false)
  else
    self:SetActiveSymbol(data.isactive == true)
  end
  if self.isCard then
    return
  end
  self:SetIcon(data)
  local itemType = self.data and self.data.staticData and self.data.staticData.Type
  self:SetPic(itemType, self.data and self.data.staticData)
  self:SetQuestIcon(itemType)
  self:SetFunctionTip(itemType)
  local showLimitTime = self:SetLimitTimeCorner(data)
  if not showLimitTime then
    self:SetShopCorner(itemType)
  end
  self:SetPetFlag(itemType)
  self:SetUseItemInvalid(data)
  self:SetFoodStars(data)
  self:SetPersonalArtifact(data)
  self:SetConditionForbid(data)
  self:SetMainColorPalette(data)
  self:SetEquipInfo(data)
  self:UpdateQuenchBg(data)
  self:SetMemoryInfo(data)
  self:SetMercenaryCatEquipUnlock(itemType, data)
end

function ItemCell:SetIcon(data)
  local itemType = data and data.staticData and data.staticData.Type
  if not self.iconGO then
    return
  end
  local setSuc, setFaceSuc = false, false
  if itemType == 1200 then
    setFaceSuc = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
    if not setFaceSuc then
      setFaceSuc = IconManager:SetFaceIcon("boli", self.icon)
    end
  elseif itemType == 41 then
    local useItem = Table_UseItem[data.staticData.id]
    local isPortrait = useItem and useItem.UseEffect and useItem.UseEffect.type == "add_portrait" or false
    if isPortrait then
      setFaceSuc = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
      if not setFaceSuc then
        setFaceSuc = IconManager:SetFaceIcon("boli", self.icon)
      end
    else
      setSuc = IconManager:SetItemIcon(data.staticData.Icon, self.icon)
      if not setSuc then
        setSuc = IconManager:SetItemIcon("item_45001", self.icon)
      end
    end
  else
    if data.petEggInfo and data.petEggInfo:PetMountCanEquip() then
      setSuc = IconManager:SetPetMountIcon(data, self.icon)
    elseif data.site then
      local siteName = (data.site == 5 or data.site == 6) and "bag_equip_6" or "bag_equip_" .. data.site
      setSuc = IconManager:SetUIIcon(siteName, self.icon)
    else
      setSuc = IconManager:SetItemIcon(data.staticData.Icon, self.icon)
    end
    setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.icon)
  end
  if setSuc then
    self.iconGO:SetActive(true)
    self.icon:MakePixelPerfect()
  elseif setFaceSuc then
    self.iconGO:SetActive(true)
    self.icon.width = 80
    self.icon.height = 80
  else
    self.iconGO:SetActive(false)
  end
end

function ItemCell:ActiveNewTag(b)
  if self.newTag == nil then
    return
  end
  self.newTag:SetActive(b)
end

function ItemCell:SetActiveSymbol(active)
  active = active and true or false
  if self.activeSymbol == nil then
    if not active then
      return
    end
    self.activeSymbol = self:LoadCellPart("ActiveSymbol", self.item)
  end
  self.activeSymbol:SetActive(active)
end

local Config_QuestItemIcon = GameConfig.QuestItemIcon

function ItemCell:SetQuestIcon(itemType)
  if Config_QuestItemIcon == nil or itemType == nil then
    return
  end
  local iconName = Config_QuestItemIcon[itemType]
  if iconName == nil then
    if self.questFlagIconGO then
      self.questFlagIconGO:SetActive(false)
    end
    return
  end
  if self.questFlagIconGO == nil then
    self.questFlagIconGO = self:LoadCellPart("QuestFlagIcon", self.normalItem)
    self.questFlagIcon = self:FindGO("QuestFlagIcon", self.questFlagIconGO):GetComponent(UISprite)
  end
  self.questFlagIconGO:SetActive(true)
  IconManager:SetUIIcon(iconName, self.questFlagIcon)
end

function ItemCell:SetPic(itemType, staticData)
  ItemCell.SetBgIcon(self:GetBgSprite(), itemType, function()
    if self.bg_inited and self.bg then
      local quality = 1
      if staticData then
        quality = GameConfig.Item.special_quality and GameConfig.Item.special_quality[staticData.id] or quality
        local equipInfo = Table_Equip[staticData.id]
        if equipInfo then
          quality = staticData.Quality or 1
        elseif Table_ItemMemory and Table_ItemMemory[staticData.id] then
          quality = staticData.Quality or 1
        end
      end
      self:SetItemQualityBG(quality)
    end
  end)
end

function ItemCell.SetBgIcon(bgSp, itemType, setDefaultBgAction)
  if not bgSp then
    return
  end
  if itemType == ItemCell.Config.HomePicId then
    IconManager:SetUIIcon("icon_62", bgSp)
  elseif itemType == ItemCell.Config.PicId or itemType == ItemCell.Config.PetPicId then
    IconManager:SetUIIcon("icon_34", bgSp)
  elseif itemType == ItemCell.Config.MountFashionPicId then
    IconManager:SetUIIcon("icon_103", bgSp)
  elseif setDefaultBgAction then
    setDefaultBgAction(bgSp)
  end
end

function ItemCell:SetItemQualityBG(quality)
  if not self.bg and not self:GetBgSprite() then
    return
  end
  if quality == 1 then
    local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
    if self.bg.spriteName ~= spName then
      self.bg.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom")
      self.bg.spriteName = spName
    end
  else
    self.bg.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    self.bg_inited = true
    if quality == 2 then
      self.bg.spriteName = "refine_bg_green"
    elseif quality == 3 then
      self.bg.spriteName = "refine_bg_blue"
    elseif quality == 4 then
      self.bg.spriteName = "refine_bg_purple"
    elseif quality == 5 then
      self.bg.spriteName = "refine_bg_orange"
    elseif quality == 6 then
      self.bg.spriteName = "refine_bg_red"
    end
  end
end

function ItemCell:GetBgSprite()
  if not self.bg_inited then
    self.bg_inited = true
    self.bg = self:FindComponent("Background", UISprite, self.normalItem)
  end
  return self.bg
end

local _AdventureDataProxy

function ItemCell:SetCardInfo(data)
  local dType = data.staticData.Type
  if _AdventureDataProxy == nil then
    _AdventureDataProxy = AdventureDataProxy.Instance
  end
  self.isCard = _AdventureDataProxy:isCard(dType)
  if self.normalItem then
    self.normalItem:SetActive(not self.isCard)
  end
  if not self.isCard then
    if self.cardItem then
      self.cardItem:SetData(nil)
    end
    return
  end
  if not self.cardItem then
    local cardobj = self:LoadPreferb("cell/ItemCardCell", self.item or self.gameObject)
    if self.minDepthAffectCard then
      self:AdjustDepth(cardobj)
    end
    self.cardItem = ItemCardCell.new(cardobj)
  end
  self.cardItem:SetData(data)
end

function ItemCell:SetFunctionTip(itemType)
  if itemType ~= 65 then
    if self.functionTip then
      self.functionTip:SetActive(false)
    end
    return
  end
  if self.functionTip == nil then
    self.functionTip = self:LoadCellPart("FunctionTip", self.normalItem)
  end
  self.functionTip:SetActive(true)
end

function ItemCell:SetShowCellPart(key, isShow, parent)
  if not self.cellPartMap[key] then
    local go = self:FindGO(key)
    if go then
      self.cellPartMap[key] = go
    else
      if not isShow then
        return
      end
      self:LoadCellPart(key, parent or self.normalItem)
    end
  end
  if self.cellPartMap[key] then
    self.cellPartMap[key]:SetActive(isShow)
  end
end

function ItemCell:SetShopCorner(itemType)
  self:SetShowCellPart("ShopCorner", itemType == 61 and (not Game.Config_Wallet or not self.data.staticData or not Game.Config_Wallet[self.data.staticData.id]))
end

function ItemCell:SetPetFlag(itemType)
  self:SetShowCellPart("PetFlag", itemType == 51 or itemType == 52 or itemType == 58)
end

function ItemCell:SetPersonalArtifact(data)
  local valid = data and data.CheckPersonalArtifactValid and data:CheckPersonalArtifactValid()
  self:SetShowCellPart("PersonalArtifact", valid)
  self:InitPersonalArtifact()
  if not valid then
    return
  end
  if not self.attrStateGo or not self.activeStateGo then
    return
  end
  local state = data:GetPersonalArtifactState()
  local fragmentCount = data:GetFragmentCount()
  local isInactive = state == PersonalArtifactProxy.EArtifactState.InActivated
  if isInactive then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
  elseif state == PersonalArtifactProxy.EArtifactState.Fragments then
    self:Hide(self.activeStateGo)
    self:Show(self.attrStateGo)
    self:UpdateFragmentLine(fragmentCount)
  elseif state == PersonalArtifactProxy.EArtifactState.Activation then
    self:Hide(self.attrStateGo)
    self:Hide(self.activeStateGo)
  elseif state == PersonalArtifactProxy.EArtifactState.Entery then
    self:Show(self.activeStateGo)
    self:Hide(self.attrStateGo)
  end
end

local maxMatCount = 5

function ItemCell:InitPersonalArtifact()
  self.fragmentLines = {}
  self.attrStateGo = self:FindGO("AttrState", self.normalItem)
  self.activeStateGo = self:FindGO("ActiveState", self.normalItem)
  for i = 1, maxMatCount do
    self.fragmentLines[i] = self:FindComponent("Line" .. tostring(i), UISprite, self.attrStateGo)
  end
end

local _FramentColor = {
  Active = LuaColor.New(0.5019607843137255, 0.8352941176470589, 0.3176470588235294, 1),
  DeActive = LuaColor.New(0.7803921568627451, 0.7803921568627451, 0.7803921568627451, 1)
}

function ItemCell:UpdateFragmentLine(fragmentCount)
  for k, v in pairs(self.fragmentLines) do
    v.color = k <= fragmentCount and _FramentColor.Active or _FramentColor.DeActive
  end
end

function ItemCell:SetLimitTimeCorner(data)
  local existTimeType = data and data.staticData and data.staticData.ExistTimeType
  local isShow = data.CheckIsLimitedTime and data:CheckIsLimitedTime() or existTimeType == 1 or existTimeType == 2 or existTimeType == 3
  self:SetShowCellPart("LimitTimeCorner", isShow)
  return isShow
end

function ItemCell:SetFoodStars(data)
  local foodSData = data and data:GetFoodSData()
  if foodSData == nil then
    if self.foodStars then
      self.foodStars[0]:SetActive(false)
    end
    return
  end
  if not self.foodStars_Init then
    self.foodStars_Init = true
    self.foodStars = {}
    self.foodStars[0] = self:LoadCellPart("FoodStars", self.normalItem)
    for i = 1, 5 do
      self.foodStars[-i] = self:FindGO(tostring(i), self.foodStars[0])
      self.foodStars[i] = self.foodStars[-1 * i]:GetComponent(UISprite)
    end
  end
  local cookHard = foodSData.CookHard
  if cookHard == nil or cookHard <= 0 then
    self.foodStars[0]:SetActive(false)
    return
  end
  self.foodStars[0]:SetActive(true)
  local num = math.floor(cookHard / 2)
  for i = 1, 5 do
    if i <= num then
      self.foodStars[-i]:SetActive(true)
      self.foodStars[i].spriteName = "food_icon_08"
    elseif i == num + 1 and cookHard % 2 == 1 then
      self.foodStars[-i]:SetActive(true)
      self.foodStars[i].spriteName = "food_icon_09"
    else
      self.foodStars[-i]:SetActive(false)
    end
  end
end

function ItemCell:SetConditionForbid(data)
  if not Table_ItemRef then
    return
  end
  local itemId = data.staticData.id
  if not itemId then
    return
  end
  local itemRefConfig = Table_ItemRef[itemId]
  if itemRefConfig then
    local forbid = false
    if itemRefConfig.Menu_ID and not FunctionUnLockFunc.Me():CheckCanOpen(itemRefConfig.Menu_ID) then
      forbid = true
    end
    if itemRefConfig.Time_ID and not FunctionUnLockFunc.checkFuncTimeValid(itemRefConfig.Time_ID) then
      forbid = true
    end
    if self.conditionForbidSymbol == nil then
      self.conditionForbidSymbol = self:LoadCellPart("ConditionForbid", self.normalItem)
    end
    if self.conditionForbidSymbol then
      self.conditionForbidSymbol:SetActive(forbid)
    end
  elseif self.conditionForbidSymbol then
    self.conditionForbidSymbol:SetActive(false)
  end
end

function ItemCell:SetDoubleSymbol(bool, isDevide)
  if bool then
    if not self.doubleSymbol then
      self.doubleSymbol = self:LoadCellPart("DoubleSymbol", self.normalItem)
    end
    if self.doubleSymbol then
      self.doubleSymbol:SetActive(true)
      if isDevide then
        local value = self.numLab.text
        if value and value ~= "" then
          value = math.floor(value / 2)
          self.numLab.text = value
        end
      end
    end
  elseif self.doubleSymbol then
    self.doubleSymbol:SetActive(false)
  end
end

function ItemCell:SetVIPSymbol(data)
  if data and data.isVipReward then
    if not self.vipSymbol then
      self.vipSymbol = self:LoadCellPart("VIPSymbol", self.normalItem)
    end
    if self.vipSymbol then
      self:Show(self.vipSymbol)
      self.vpBg = self:FindComponent("Sprite", UISprite, self.vipSymbol)
      self.vipLab = self:FindComponent("Label", UILabel, self.vpBg.gameObject)
      self.vipLab.text = ZhString.Lottery_MonthlyVIP
      self.vipLock = self:FindGO("Lock", self.vipSymbol)
      local isVip = NewRechargeProxy.Ins:AmIMonthlyVIP()
      self.vipLock:SetActive(not isVip)
    end
  elseif self.vipSymbol then
    self:Hide(self.vipSymbol)
  end
end

function ItemCell:SetMainColorPalette(data, mainColorPaletteCellPartLoader)
  mainColorPaletteCellPartLoader = mainColorPaletteCellPartLoader or self._DefaultMainColorPaletteCellPartLoader
  local mainColor, active = data and data.staticData and data.staticData.MainColor, true
  if StringUtil.IsEmpty(mainColor) then
    active = false
  end
  if active then
    if not self.mainColorPalette then
      self.mainColorPalette = mainColorPaletteCellPartLoader(self)
      self.mainColorPaletteSp = self.mainColorPalette and self:FindComponent("Sprite", UISprite, self.mainColorPalette)
    end
    if self.mainColorPalette then
      self.mainColorPalette:SetActive(true)
      if mainColor == "X" then
        self.mainColorPaletteSp.color = ColorUtil.NGUIWhite
        self.mainColorPaletteSp.spriteName = "com_icon_Palette02"
      else
        local succ, color = ColorUtil.TryParseHexString(mainColor)
        if succ then
          self.mainColorPaletteSp.color = color
          self.mainColorPaletteSp.spriteName = "com_icon_Palette01"
        else
          self.mainColorPalette:SetActive(false)
        end
      end
    end
  elseif self.mainColorPalette then
    self.mainColorPalette:SetActive(false)
  end
end

function ItemCell:_DefaultMainColorPaletteCellPartLoader()
  return self:LoadCellPart("MainColorPalette", self.normalItem)
end

function ItemCell:SetEquipInfo(data)
  local equipInfo = data.equipInfo
  if equipInfo == nil then
    if self.equip_Inited then
      self:UpdateEquipInfo(data)
    end
    return
  end
  self:InitEquipPart()
  self:UpdateEquipInfo(data)
end

function ItemCell:InitEquipPart()
  if self.equip_Inited then
    return
  end
  self.equip_Inited = true
  self.equipGO = self:LoadCellPart("Equip", self.normalItem)
  if not self.equipGO then
    return
  end
  local attrGO = self:FindGO("AttrGrid", self.equipGO)
  if attrGO then
    self.attrGrid = attrGO:GetComponent(UIGrid)
  end
  self.leftTopAttriGrid = self:FindComponent("LtGrid", UIGrid)
  local strenglvGO = self:FindGO("StrengLv", self.equipGO)
  self.strenglv = strenglvGO:GetComponent(UILabel)
  self.quenchPerLab = self:FindComponent("QuenchPer", UILabel, self.equipGO)
  local refinelvGO = self:FindGO("RefineLv", self.equipGO)
  self.refinelv = refinelvGO:GetComponent(UILabel)
  local equiplvGO = self:FindGO("EquipLv", self.equipGO)
  self.equiplv = equiplvGO:GetComponent(UILabel)
  self.damageSymbol = self:FindGO("Break", self.equipGO)
  self.refineValSymbol = self:FindGO("RefineVal", self.equipGO)
  self.bebreaked = self:FindComponent("BeBreaked", UISprite, self.equipGO)
  self.bebreakedbg = self:FindGO("BeBreakedBG", self.equipGO)
  self.bebreakedbg:SetActive(false)
  local bebreakedtext = self:FindGO("BeBreakedText", self.equipGO)
  self.bebreakedlabel = bebreakedtext:GetComponent(UILabel)
  self.bebreakedlabel.text = ZhString.ItemIcon_Repair
  self:InitCardSlot()
end

function ItemCell:UpdateEquipInfo(data, replaceEquipInfo)
  if self.equipGO == nil then
    return
  end
  local equipInfo = replaceEquipInfo or data.equipInfo
  if equipInfo == nil then
    self.equipGO:SetActive(false)
    return
  end
  self.equipGO:SetActive(true)
  local st = equipInfo.site
  st = st and st[1]
  if st then
    if 7 < st and st < 13 then
      st = 6
    end
    st = st == 5 and 6 or st
    st = st == 1 and 7 or st
    self.bebreaked.spriteName = "bag_equip_break" .. tostring(st)
  else
    self.bebreaked.spriteName = ""
  end
  self.damageSymbol:SetActive(equipInfo.damage == true)
  if self.refineValSymbol then
    self.refineValSymbol:SetActive(equipInfo.extra_refine_value > 0)
  end
  if self.leftTopAttriGrid then
    self.leftTopAttriGrid:Reposition()
  end
  self:UpdateStrengthLevel(equipInfo.strengthlv)
  self:UpdateQuenchPer(PvpProxy.Instance:IsFreeFire() and equipInfo:MaxQunenchPer() or equipInfo.quench_per)
  self:UpdateRefineLevel(equipInfo.refinelv)
  self:UpdateEquipLevel(equipInfo.equiplv, equipInfo.artifact_lv)
  self:UpdateCardSlot(data, equipInfo ~= nil)
end

function ItemCell:UpdateStrengthLevel(strengthlv, withBuff)
  local isShow = strengthlv ~= nil and 0 < strengthlv and not self.forbidShowStrengthLv
  local quenchIsShow = self.data and self.data.CanShowQuenchLv and self.data:CanShowQuenchLv()
  self.strenglv.gameObject:SetActive(isShow and not quenchIsShow)
  if isShow then
    self.strenglv.text = string.format(withBuff and "[c][FF000A]%d[-][/c]" or "%d", strengthlv)
  end
end

function ItemCell:UpdateQuenchPer(quench)
  if not self.quenchPerLab then
    return
  end
  local canShowQuench = quench and 0 < quench and self.data and self.data.CanShowQuenchLv and self.data:CanShowQuenchLv()
  if canShowQuench then
    self:Show(self.quenchPerLab)
    self.quenchPerLab.text = tostring(quench) .. "%"
  else
    self:Hide(self.quenchPerLab)
  end
end

function ItemCell:UpdateQuenchBg(data)
  local hasQuench = data and data.HasQuench and data:HasQuench()
  if self.quenchBg == nil then
    if not hasQuench then
      return
    end
    self.quenchBg = self:LoadCellPart("QuenchSymbol", self.normalItem)
    local activeSymbol = self:FindGO("ActiveSymbol", self.quenchBg):GetComponent(UISprite)
    if activeSymbol then
      activeSymbol.depth = self.icon.depth - 1
      if self.bg and self.bg.depth == activeSymbol.depth then
        self.bg.depth = self.bg.depth - 1
      end
    end
  end
  self.quenchBg:SetActive(hasQuench)
end

function ItemCell:UpdateRefineLevel(refinelv, withBuff)
  if not self.refinelv then
    return
  end
  local isShow = refinelv ~= nil and 0 < refinelv and not self.forbidShowRefineLv
  self.refinelv.gameObject:SetActive(isShow)
  if isShow then
    self.refinelv.text = string.format(withBuff and "[c][CB5AFF]+%d[-][/c]" or "+%d", refinelv)
  end
  self:AttriGridReposition()
end

function ItemCell:UpdateEquipLevel(equiplv, artifactlv)
  if not self.forbidShowEquipLv then
    if 0 < equiplv then
      self.equiplv.gameObject:SetActive(true)
      self.equiplv.text = StringUtil.IntToRoman(equiplv)
    elseif artifactlv and 0 < artifactlv then
      self.equiplv.gameObject:SetActive(true)
      self.equiplv.text = StringUtil.IntToRoman(artifactlv)
    else
      self.equiplv.gameObject:SetActive(false)
    end
  else
    self.equiplv.gameObject:SetActive(false)
  end
  self:AttriGridReposition()
end

function ItemCell:AttriGridReposition()
  if self.attrGrid then
    self.attrGrid:Reposition()
  end
end

function ItemCell:UpdateCardSlot(data, isEquip)
  local slotNum = data.cardSlotNum or 0
  local replaceCount = data.replaceCount or 0
  if data.isAdv then
    data.replaceCount = 0
  end
  if isEquip and (0 < slotNum or 0 < replaceCount) then
    self.cardSlotGO:SetActive(true)
    local cardDatas, symbols, count = data.equipedCardInfo or {}, self.cardSlotSymbols, 0
    for i = 1, #symbols do
      if i <= slotNum then
        symbols[-i]:SetActive(true)
        local quality = cardDatas[i] and cardDatas[i]:GetCardQuality()
        symbols[i].spriteName = quality and string.format("card_icon_%02d", quality) or "card_icon_0"
        count = count + 1
      elseif i <= slotNum + replaceCount then
        symbols[-i]:SetActive(true)
        symbols[i].spriteName = "card_icon_lock"
        count = count + 1
      else
        symbols[-i]:SetActive(false)
      end
    end
    for i = 1, count do
      symbols[i].transform.localPosition = LuaGeometry.GetTempVector3(-1 * self.CardSlotElementWidth * (count - i))
    end
  else
    self.cardSlotGO:SetActive(false)
  end
end

function ItemCell:SetMercenaryCatEquipUnlock(itemtype, data)
  local equipID = data and data.staticData and data.staticData.id
  local showSymbol = false
  if itemtype == 58 then
    local targetFashionID
    local config = Table_UseItem[equipID]
    if config then
      local useEffect = config.UseEffect
      targetFashionID = useEffect and useEffect.fashion
    end
    local mercenaryCats = MercenaryCatProxy.Instance.mercenaryCat
    if mercenaryCats then
      for k, v in pairs(mercenaryCats) do
        local unlockEquips = v.unlockEquips
        if unlockEquips and 0 < #unlockEquips then
          for i = 1, #unlockEquips do
            if targetFashionID == unlockEquips[i] then
              showSymbol = true
            end
          end
        end
      end
    end
  else
    if self.unlockSymbol then
      self.unlockSymbol:SetActive(false)
    end
    return
  end
  if not showSymbol then
    if self.unlockSymbol then
      self.unlockSymbol:SetActive(false)
    end
    return
  end
  if self.unlockSymbol == nil then
    self.unlockSymbol = self:LoadCellPart("UnlockSymbol", self.item)
  end
  self.unlockSymbol:SetActive(true)
end

function ItemCell:SetUseItemInvalid(data)
  if self.invalid == nil then
    return
  end
  if data.IsExtraction and data:IsExtraction() then
    self:SetInvalid(false)
  elseif data.IsUseItem and data:IsUseItem() then
    local staticData = data.staticData
    local couldUse = ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(staticData.Type, staticData.id)
    if couldUse == true then
      self:SetInvalid(data:IsLimitUse())
    else
      self:SetInvalid(true)
    end
  else
    self:SetInvalid(false)
  end
end

function ItemCell:SetInvalid(b)
  if self.invalid == nil then
    return
  end
  self.invalid:SetActive(b or false)
end

function ItemCell:SetIconGrey(b)
  local data = self.data
  if data and data.staticData then
    local isCard = AdventureDataProxy.Instance:isCard(data.staticData.Type)
    if isCard then
      self:SetCardGrey(b)
    elseif self.icon then
      self.icon.color = b and ColorUtil.NGUIShaderGray or ColorUtil.NGUIWhite
    end
  end
end

local darkColor = LuaColor.New(0.39215686274509803, 0.39215686274509803, 0.39215686274509803)

function ItemCell:SetIconDark(b)
  if self.icon then
    self.icon.color = b and darkColor or LuaGeometry.GetTempColor()
  end
end

function ItemCell:SetIconlocked(b)
  if self.icon then
    self.icon.color = b and LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569) or LuaGeometry.GetTempColor()
  end
end

function ItemCell:ShowMask()
  if self.spMask then
    self.spMask.enabled = true
  end
end

function ItemCell:HideMask()
  if self.spMask then
    self.spMask.enabled = false
  end
end

function ItemCell:HideBgSp()
  local bg = self:GetBgSprite()
  if bg then
    self:Hide(bg)
  end
end

function ItemCell:SetMinDepth(minDepth, includeCardItem)
  self.minDepth = minDepth
  self.minDepthAffectCard = includeCardItem
end

function ItemCell:SetCardGrey(b)
  if self.cardItem then
    self.cardItem:SetCardGrey(b)
  end
end

function ItemCell:ShowNum()
  self.numHide = false
end

function ItemCell:HideNum()
  self.numHide = true
end

function ItemCell:HideIcon()
  if self.item then
    self.item:SetActive(false)
  end
  if self.empty then
    self.empty:SetActive(true)
  end
  if self.empty_hideIcon then
    self.empty_hideIcon:SetActive(true)
  end
end

local BagType_SymbolMap

function ItemCell:UpdateBagType()
  if not self.init_bagtype then
    self.init_bagtype = true
    self.bagTypes = self:FindGO("BagTypes")
    self.bagTypes_Sp = self.bagTypes and self.bagTypes:GetComponent(UISprite)
  end
  if self.bagTypes == nil then
    return
  end
  local data = self.data
  if data and data.bagtype then
    if BagType_SymbolMap[data.bagtype] then
      self.bagTypes:SetActive(true)
      self.bagTypes_Sp.spriteName = BagType_SymbolMap[data.bagtype]
    else
      self.bagTypes:SetActive(false)
    end
  else
    self.bagTypes:SetActive(false)
  end
end

local equipUpgrade_RefreshBagType

function ItemCell:UpdateEquipUpgradeTip()
  if self.upgradeTip == nil then
    self.upgradeTip = self:FindGO("UpgradeTip")
  end
  if self.upgradeTip == nil then
    return
  end
  self.upgradeTip:SetActive(false)
  local bagtype, equipInfo
  if type(self.data) == "table" then
    bagtype = self.data.bagtype
    equipInfo = self.data.equipInfo
  end
  if equipUpgrade_RefreshBagType == nil then
    equipUpgrade_RefreshBagType = BagProxy.EquipUpgrade_RefreshBagType
  end
  if bagtype == nil or equipUpgrade_RefreshBagType[bagtype] == nil then
    return
  end
  if equipInfo == nil then
    return
  end
  if not equipInfo:CheckCanUpgradeSuccess(true) then
    return
  end
  self.upgradeTip:SetActive(true)
end

function ItemCell:UpdateNumLabel(scount, x, y, z)
  local needHide = false
  if type(scount) == "number" and scount <= 1 then
    needHide = true
  end
  if self.numHide or needHide then
    if self.numLab_Inited and self.numLab then
      self.numLab.text = ""
    end
    return
  end
  if not self.numLab_Inited then
    self.numLab_Inited = true
    self.numLabGO = self:FindGO("NumLabel", self.item)
    if self.numLabGO then
      self.numLabTrans = self.numLabGO.transform
      self.numLab = self.numLabGO:GetComponent(UILabel)
      self.numLabGO:SetActive(true)
    end
  end
  if not self.numLabGO then
    return
  end
  self.numLab.text = scount
  self.numLabTrans.localPosition = x and y and z and LuaGeometry.GetTempVector3(x, y, z) or self.DefaultNumLabelLocalPos
end

function ItemCell:UpdateMyselfInfo(data)
  if self.invalid == nil then
    return
  end
  data = data or self.data
  if data == nil then
    self.invalid:SetActive(false)
    return
  end
  if data.IsExtraction and data:IsExtraction() then
    self.invalid:SetActive(false)
    return
  end
  if data and data.IsJobLimit and data:IsJobLimit() then
    self.invalid:SetActive(true)
    return
  end
  if data.IsUseItem and data:IsUseItem() then
    return
  end
  if data.equipInfo then
    local isValid, lv, mapManager, bagTypeCfg = true, data.staticData.Level or 0, Game.MapManager, BagProxy.BagType
    if self.showEquipInvalidByLevel and lv > MyselfProxy.Instance:RoleLevel() then
      isValid = false
    elseif bagTypeCfg.RoleEquip == data.bagType or bagTypeCfg.RoleFashionEquip == data.bagType then
      isValid = data:CanIOffEquip()
    elseif data.staticData.Type == 101 then
      isValid = true
    elseif data.equipInfo:IsArtifact() and mapManager:IsPveMode_PveCard() then
      isValid = false
    else
      isValid = data:CanEquip() and TableUtility.ArrayFindIndex(data.equipInfo.equipData.MapForbid, mapManager:GetMapID()) == 0
    end
    if DesertWolfProxy.Instance:IsEquipForbidden(data.equipInfo) then
      isValid = false
    end
    self:SetActive(self.invalid, not isValid)
  else
    self:SetActive(self.invalid, false)
  end
end

function ItemCell:ResetBG()
  local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
  local bg = self:GetBgSprite()
  if not bg then
    return
  end
  if bg.spriteName ~= spName then
    bg.atlas = self.DefaultBg_atlyas or RO.AtlasMap.GetAtlas("NewCom")
    bg.spriteName = spName
  end
end

function ItemCell:SetGetSymbol(active)
  active = active and true or false
  if self.getSymbol == nil then
    if not active then
      return
    end
    self.getSymbol = self:LoadCellPart("GetSymbol", self.item)
  end
  self.getSymbol:SetActive(active)
end

function ItemCell:SetMemoryInfo(data)
  if data.IsMemory and data:IsMemory() and not data.hideMemoryCorner then
    if not self.memoryGO then
      self.memoryGO = self:LoadCellPart("Memory", self.normalItem)
      if self.memoryGO then
        self.memoryLvLabel = self:FindGO("MemoryLevel", self.memoryGO):GetComponent(UILabel)
        self.memoryExcess = self:FindGO("MemoryExcess", self.memoryGO):GetComponent(UILabel)
      end
    else
      self.memoryGO:SetActive(true)
    end
    if self.memoryGO then
      local level = data.equipMemoryData and data.equipMemoryData.level or 1
      self.memoryLvLabel.text = string.format("Lv.%s", level)
      local excessStage = data.equipMemoryData and data.equipMemoryData.excess_lv or 0
      self.memoryExcess.text = StringUtil.IntToRoman(excessStage)
    end
  elseif self.memoryGO then
    self.memoryGO:SetActive(false)
  end
end
