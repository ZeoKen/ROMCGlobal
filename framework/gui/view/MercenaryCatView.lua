autoImport("ItemNormalList")
autoImport("HireCatSkillCombineItemCell")
autoImport("MercenaryCatHeadCell")
autoImport("PetDressingCombineItemCell")
autoImport("BaseAttributeReCell")
MercenaryCatView = class("MercenaryCatView", ContainerView)
MercenaryCatView.ViewType = UIViewType.NormalLayer
local tempVector3 = LuaVector3.Zero()
local tempRot = LuaQuaternion()
local m_texBGName = "Reloading_BG"
local EMPTY_EQUIPID = {
  "bag_equip_8",
  "bag_equip_10",
  "bag_equip_11"
}
local CONFIG_PROPS = GameConfig.Mercenary and GameConfig.Mercenary.MercenaryProps
local SIX_BASE_PROPS = {
  "Str",
  "Int",
  "Vit",
  "Agi",
  "Dex",
  "Luk"
}
local zenyIconName = "item_100"
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function MercenaryCatView:Init()
  self.skillTipData = {}
  self:FindObjs()
  self:AddUIEvts()
  self:InitView()
  self:MapEvent()
end

function MercenaryCatView:FindObjs()
  self.leftBord = self:FindGO("LeftBord")
  self.attrViewHolder = self:FindGO("attrViewHolder")
  self:RegisterChildPopObj(self.attrViewHolder)
  self.fixedLeftTitle = self:FindComponent("FixedTitleLab", UILabel, self.attrViewHolder)
  self.fixedLeftTitle.text = ZhString.MercenaryCatView_Title
  self.fixedDescTitle = self:FindComponent("FixedDescTitle", UILabel, self.attrViewHolder)
  self.fixedDescTitle.text = ZhString.MercenaryCatView_MercanaryDesc
  self.fixedAttriLab = self:FindComponent("FixedAttriLab", UILabel, self.attrViewHolder)
  self.fixedAttriLab.text = ZhString.MercenaryCatView_FixedAttr
  self.descLab = self:FindComponent("DescLab", UILabel, self.attrViewHolder)
  self.closeLeftBtn = self:FindGO("CloseLeftBtn", self.attrViewHolder)
  self.openAttriBtn = self:FindGO("OpenAttriBtn", self.leftBord)
  self.info = self:FindGO("Info")
  local portrait = self:FindGO("PlayerHeadCell")
  self.faceCell = PlayerFaceCell.new(portrait)
  self.headLock = self:FindGO("HeadLock")
  self.name = self:FindComponent("Name", UILabel, self.info)
  self.timeleft = self:FindComponent("TimeLeftLab", UILabel, self.info)
  self.fixedCatLevel = self:FindComponent("FixedCatLevelLabel", UILabel, self.info)
  self.fixedCatLevel.text = ZhString.MercenaryCatView_MercanaryLv
  self.lvSlider = self:FindComponent("LvSlider", UISlider, self.info)
  self.catlevel = self:FindComponent("CatLevelLab", UILabel, self.lvSlider.gameObject)
  self.btnTipLab = self:FindComponent("BtnTipLab", UILabel, self.info)
  self.fixedEquipedSkillLab = self:FindComponent("FixedEquipSkillLab", UILabel, self.info)
  self.fixedEquipedSkillLab.text = ZhString.MercenaryCatView_EquipedSkill
  self.button = self:FindGO("Button", self.info)
  self.buttonText = self:FindComponent("BtnText", UILabel, self.button)
  self.tsfSkillTipRoot = self:FindGO("SkillTipRoot", self.info).transform
  self.lockSkillPos = self:FindGO("LockSkillPos")
  self.lockDescLab = self:FindComponent("LockDescLab", UILabel)
  self.skillIcon = self:FindComponent("SkillIcon", UISprite, self.lockSkillPos)
  self.skillLock = self:FindGO("SkillLock", self.lockSkillPos)
  self.nameLvLab = self:FindComponent("NameLvLab", UILabel, self.lockSkillPos)
  self.skillDescLab = self:FindComponent("SkillDescLab", UILabel, self.lockSkillPos)
  self.fullLvPos = self:FindGO("FullLvPos")
  self.fullLvDesc = self:FindComponent("FullLvDesc", UILabel, self.fullLvPos)
  self.fullLvDesc.text = ZhString.MercenaryCatView_FullLvDesc
  local catRoot = self:FindGO("CatRoot")
  self.catHeadToggleBtn = self:FindGO("CatHeadToggleBtn", catRoot)
  self.catHead = self:FindComponent("CatHead", UISprite, catRoot)
  self.catHeadGrid = self:FindComponent("CatHeadGrid", UIGrid, catRoot)
  self.rehirePos = self:FindGO("ReHirePos")
  self:RegisterChildPopObj(self.rehirePos)
  self.cancelRehireBtn = self:FindGO("CancelRehire", self.rehirePos)
  self.closeRehireBtn = self:FindGO("CloseRehire", self.rehirePos)
  self.confirmRehireBtn = self:FindGO("ConfirmRehire", self.rehirePos)
  self.hireTipLab = self:FindComponent("HireTipLab", UILabel, self.rehirePos)
  self.hireTipLab.text = ZhString.HireCatPopUp_Tip
  local hire_1 = self:FindGO("HireDayTog_1", self.rehirePos)
  self.hireDay_1_TipLabel = self:FindComponent("TipLabel", UILabel, hire_1)
  self.hireDay_1_Label = self:FindComponent("Label", UILabel, hire_1)
  self.hireDay_1_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 1)
  self.hireDay_1_Tog = self:FindComponent("Tog_1", UIToggle, hire_1)
  local hireDay_1_ZenySp = self:FindComponent("Sprite", UISprite, hire_1)
  IconManager:SetItemIcon(Table_Item[100].Icon, hireDay_1_ZenySp)
  local hire_7 = self:FindGO("HireDayTog_7", self.rehirePos)
  self.hireDay_7_TipLabel = self:FindComponent("TipLabel", UILabel, hire_7)
  local hireDay_7_ZenySp = self:FindComponent("Sprite", UISprite, hire_7)
  IconManager:SetItemIcon(Table_Item[100].Icon, hireDay_7_ZenySp)
  self.hireDay_7_Label = self:FindComponent("Label", UILabel, hire_7)
  self.hireDay_7_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 7)
  self.hireDay_7_Tog = self:FindComponent("Tog_7", UIToggle, hire_7)
  self.modelRoot = self:FindGO("ModelRoot")
  self.objRotateRoleArrows = self:FindGO("RotateRoleArrows", self.modelRoot)
  self.modelTex = self:FindComponent("ModelTexture", UITexture, self.modelRoot)
  self.previewTip = self:FindComponent("PreviewTip", UILabel, self.modelRoot)
  self.previewTip.text = ZhString.MercenaryCatView_Preview
  self.itemlist = ItemNormalList.new(self:FindGO("ItemNormalList"), PetDressingCombineItemCell)
  self.itemlist:AddEventListener(ItemEvent.ClickItem, self.ClickEquipItem, self)
  self.itemlist:AddEventListener(ItemEvent.ClickItemTab, self.ClickEquipItemType, self)
  self.itemlist.rowNum = 4
  self.itemlist.GetTabDatas = MercenaryCatView.GetTabDatas
  local itemNormalListGo = self:FindGO("ItemNormalList")
  self:RegisterChildPopObj(itemNormalListGo)
  self.closeNormalList = self:FindGO("CloseNormalList", itemNormalListGo)
  self.equipTip = self:FindComponent("EquipTip", UILabel, itemNormalListGo)
  self.equipTip.text = ZhString.MercenaryCatView_EquipTip
end

local tabDatas = {}

function MercenaryCatView.GetTabDatas(tabConfig, tabData)
  TableUtility.ArrayClear(tabDatas)
  local index = tabData.index
  local site = GameConfig.Mercenary.EquipTab[index].type
  local equips = MercenaryCatProxy.Instance:GetEquips(site)
  local data = {id = 0, unlocked = true}
  tabDatas[#tabDatas + 1] = data
  for i = 1, #equips do
    local data = {
      id = equips[i],
      unlocked = MercenaryCatProxy.Instance:IsEquipUnLock(equips[i])
    }
    tabDatas[#tabDatas + 1] = data
  end
  return tabDatas
end

function MercenaryCatView:GetEquips(site)
  return MercenaryCatProxy.Instance:GetEquips(site)
end

local tabCfg = {
  8,
  10,
  11
}

function MercenaryCatView:ClickEquipItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data then
    if data.unlocked then
      if data.id == 0 then
        if nil ~= self.chooseCat[self.site] then
          self:UpdateChoose()
          ServiceScenePetProxy.Instance:CallCatEquipPetCmd(self.chooseCat.id, ScenePet_pb.ECATEQUIPOPER_OFF, self.site, self.chooseCat[self.site])
        else
          MsgManager.ShowMsgByID(26116)
        end
      else
        local fakeid
        if self.site == tabCfg[1] then
          fakeid = self.fakeHead
          self.fakeHead = 0
        elseif self.site == tabCfg[2] then
          fakeid = self.fakeMouth
          self.fakeMouth = 0
        elseif self.site == tabCfg[3] then
          fakeid = self.fakeBack
          self.fakeBack = 0
        end
        if fakeid ~= 0 and fakeid == data.id then
          self:UpdateChoose(data.id)
          self:UpdateAssetRole()
          return
        end
        local oper
        if self.chooseCat:IsCurEquip(data.id) and fakeid == 0 then
          oper = ScenePet_pb.ECATEQUIPOPER_OFF
          self:UpdateChoose()
        else
          oper = ScenePet_pb.ECATEQUIPOPER_ON
          self:UpdateChoose(data.id)
        end
        ServiceScenePetProxy.Instance:CallCatEquipPetCmd(self.chooseCat.id, oper, self.site, data.id)
      end
      return
    end
    if self.site == tabCfg[1] then
      self.fakeHead = data.id == self.fakeHead and 0 or data.id
      self:UpdateChoose(self.fakeHead)
    elseif self.site == tabCfg[2] then
      self.fakeMouth = data.id == self.fakeMouth and 0 or data.id
      self:UpdateChoose(self.fakeMouth)
    elseif self.site == tabCfg[3] then
      self.fakeBack = data.id == self.fakeBack and 0 or data.id
      self:UpdateChoose(self.fakeBack)
    end
    self:UpdateAssetRole()
  end
end

function MercenaryCatView:ClickEquipItemType(cell)
  if cell and cell.data and self.site ~= GameConfig.Mercenary.EquipTab[cell.data.index].type then
    self.site = GameConfig.Mercenary.EquipTab[cell.data.index].type
    local fakeid = 0
    if self.site == tabCfg[1] then
      fakeid = self.fakeHead == 0 and self.chooseCat[8] or 0
    elseif self.site == tabCfg[2] then
      fakeid = self.fakeMouth == 0 and self.chooseCat[10] or 0
    elseif self.site == tabCfg[3] then
      fakeid = self.fakeBack == 0 and self.chooseCat[11] or 0
    end
    self:UpdateChoose(fakeid)
  end
end

function MercenaryCatView:PressRoleEvt(go, isPress)
  if self.role and not self.attrViewHolder.activeSelf then
    self.objRotateRoleArrows:SetActive(isPress)
  end
end

function MercenaryCatView:RotateRoleEvt(go, delta)
  if self.role and not self.attrViewHolder.activeSelf then
    self.role:RotateDelta(-delta.x * 360 / 400)
  end
end

function MercenaryCatView:AddUIEvts()
  self:AddClickEvent(self.openAttriBtn, function(go)
    if not self.attrViewHolder.activeSelf then
      self:FixedCloseAllChildView()
    end
    self.attrViewHolder:SetActive(not self.attrViewHolder.activeSelf)
  end)
  self:AddClickEvent(self.closeLeftBtn, function(go)
    self.attrViewHolder:SetActive(false)
  end)
  self:AddClickEvent(self.catHeadToggleBtn, function(go)
    self:SetTagArrowSpread(self.catHeadToggleBtn.transform.localRotation.eulerAngles ~= LuaGeometry.GetTempVector3(0, 0, 0))
  end)
  self:AddClickEvent(self.closeRehireBtn, function(go)
    self.rehirePos:SetActive(false)
  end)
  self:AddClickEvent(self.cancelRehireBtn, function(go)
    self.rehirePos:SetActive(false)
  end)
  self:AddClickEvent(self.confirmRehireBtn, function(go)
    local hireDay = self.hireDay_1_Tog.value and ScenePet_pb.EEMPLOYTYPE_DAY or ScenePet_pb.EEMPLOYTYPE_WEEK
    ServiceScenePetProxy.Instance:CallHireCatPetCmd(self.chooseCat.id, hireDay)
  end)
  self:AddClickEvent(self.button, function(go)
    if not self.chooseCat then
      return
    end
    local menuOpen = FunctionUnLockFunc.Me():CheckCanOpen(self.chooseCat.staticData.MenuID)
    if menuOpen then
      ServiceQuestProxy.Instance:CallQueryCatPrice(self.chooseCat.id, 1)
      ServiceQuestProxy.Instance:CallQueryCatPrice(self.chooseCat.id, 2)
    else
      FuncShortCutFunc.Me():CallByID(self.chooseCat.staticData.ShortcutPower)
      self:CloseSelf()
    end
  end)
  local objRotateRole = self:FindGO("RotateRoleCollider")
  self:AddDragEvent(objRotateRole, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self:AddPressEvent(objRotateRole, function(go, isPress)
    self:PressRoleEvt(go, isPress)
  end)
  self.equipItem1 = self:FindComponent("EquipItem1", UISprite)
  self.equipItem2 = self:FindComponent("EquipItem2", UISprite)
  self.equipItem3 = self:FindComponent("EquipItem3", UISprite)
  for tab = 1, 3 do
    self:AddClickEvent(self:FindGO("EquipItem" .. tab), function(go)
      self:FixedCloseAllChildView()
      self.itemlist.gameObject:SetActive(true)
      self.site = GameConfig.Mercenary.EquipTab[tab].type
      self.itemlist:ChooseTab(tab)
    end)
  end
  self:AddClickEvent(self.closeNormalList, function()
    self.itemlist.gameObject:SetActive(false)
  end)
end

function MercenaryCatView:InitView()
  self.modelCameraConfig = UIModelCameraTrans.Mercenary
  self.attrViewHolder:SetActive(false)
  local container = self:FindGO("skill_itemContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 4,
    cellName = "HireCatSkillCombineItemCell",
    control = HireCatSkillCombineItemCell,
    dir = 1
  }
  self.skillWrapHelper = WrapCellHelper.new(wrapConfig)
  self.skillWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickSkillCell, self)
  self.catCtl = UIGridListCtrl.new(self.catHeadGrid, MercenaryCatHeadCell, "MercenaryCatHeadCell")
  self.catCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMercenaryCatHead, self)
  local attriGrid = self:FindComponent("AttriGrid", UIGrid)
  self.attriCtl = UIGridListCtrl.new(attriGrid, PetInfoLabelCell, "PetInfoLabelCell")
  self:SetTagArrowSpread(false)
  self.initCatID = self.viewdata.viewdata.CatID or 1
  self:RefreshUI(MercenaryCatProxy.Instance:GetMercenaryCat()[self.initCatID])
  self.itemlist:UpdateTabList(ItemNormalList.TabType.Mercenary)
  self.itemlist.gameObject:SetActive(false)
end

function MercenaryCatView:SetTagArrowSpread(spread)
  local catHeadData = MercenaryCatProxy.Instance:GetMercenaryCat()
  if #catHeadData == 0 then
    return
  end
  if spread then
    self.catHead.width = #catHeadData * self.catHeadGrid.cellHeight + 35
    local x = -self.catHead.width + 20
    LuaVector3.Better_Set(tempVector3, x, 3, 0)
    self.catHeadToggleBtn.transform.localPosition = tempVector3
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, 0))
    self.catHeadToggleBtn.transform.localRotation = tempRot
    self.catCtl:ResetDatas(catHeadData)
  else
    self.catHead.width = 100
    self.catCtl:ResetDatas({
      catHeadData[1]
    })
    LuaVector3.Better_Set(tempVector3, -80, 3, 0)
    self.catHeadToggleBtn.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, 0, 180)
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
    self.catHeadToggleBtn.transform.localRotation = tempRot
  end
end

function MercenaryCatView:RefreshUI(data)
  if not data then
    return
  end
  self.chooseCat = data
  MercenaryCatProxy.Instance:SetCurChooseCat(data)
  self.name.text = data.name
  local menuOpen = FunctionUnLockFunc.Me():CheckCanOpen(data.staticData.MenuID)
  if not menuOpen then
    MsgManager.ShowMsgByID(40600)
  end
  self.rehirePos:SetActive(false)
  local headImageData = HeadImageData.new()
  headImageData:TransByMonsterData(data.monsterStaticData)
  self.faceCell:SetData(headImageData)
  self.headLock:SetActive(not menuOpen)
  self.skillLock:SetActive(not menuOpen)
  local mercenaryLv = MercenaryCatProxy.Instance:GetMercenaryLv()
  self.catlevel.text = string.format(ZhString.MercenaryCatView_MercenaryLv, mercenaryLv)
  if mercenaryLv >= #Table_MercenaryCatLevel then
    self.lockDescLab.text = ZhString.MercenaryCatView_LockDescLabLimited
    self.fullLvPos:SetActive(true)
    self.lockSkillPos:SetActive(false)
  else
    self.lockDescLab.text = string.format(ZhString.MercenaryCatView_LockDescLab, mercenaryLv + 1)
    self.fullLvPos:SetActive(false)
    self.lockSkillPos:SetActive(true)
    self:UpdateNextSkill()
  end
  self:UpdateExp()
  self.descLab.text = data.staticData.Introduction
  self.btnTipLab.text = menuOpen and ZhString.MercenaryCatView_UnlockBtnTip or ZhString.MercenaryCatView_LockBtnTip
  self.buttonText.text = menuOpen and ZhString.MercenaryCatView_Btn_ReHire or ZhString.MercenaryCatView_Btn_Go
  self:UpdateLeftTime()
  local skillids = self.chooseCat.staticData.SkillID
  if not skillids or "table" ~= type(skillids) or #skillids == 0 then
    redlog("未配置佣兵猫技能,佣兵猫ID: ", self.chooseCat.id)
    return
  end
  local catSkillData = self.chooseCat:GetViewSkillTab(true)
  catSkillData = ReUniteCellData(catSkillData, 4)
  self.skillWrapHelper:ResetDatas(catSkillData)
  self:UpdateProps()
  self.fakeHead, self.fakeMouth, self.fakeBack = 0, 0, 0
  self:UpdateAssetRole()
  self:RefreshEquip()
end

function MercenaryCatView:UpdateNextSkill()
  local staticData = MercenaryCatProxy.Instance:GetNextLvSkills()
  if not staticData then
    return
  end
  local nextSkill = staticData[self.chooseCat.id][1]
  local nextSkillStaticData = Table_Skill[nextSkill]
  IconManager:SetSkillIcon(nextSkillStaticData.Icon, self.skillIcon)
  self.nameLvLab.text = nextSkillStaticData.NameZh
  local descCsv = nextSkillStaticData.Desc
  local skilldesc = ""
  if descCsv then
    for i = 1, #descCsv do
      local config = descCsv[i]
      if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
        if config.params then
          skilldesc = string.format(Table_SkillDesc[config.id].Desc, unpack(config.params))
        else
          skilldesc = Table_SkillDesc[config.id].Desc
        end
      end
    end
  end
  self.skillDescLab.text = skilldesc
end

function MercenaryCatView:RefreshEquip()
  if self.chooseCat[8] then
    IconManager:SetItemIcon(Table_Item[self.chooseCat[8]].Icon, self.equipItem1)
  else
    IconManager:SetUIIcon(EMPTY_EQUIPID[1], self.equipItem1)
  end
  if self.chooseCat[10] then
    IconManager:SetItemIcon(Table_Item[self.chooseCat[10]].Icon, self.equipItem2)
  else
    IconManager:SetUIIcon(EMPTY_EQUIPID[2], self.equipItem2)
  end
  if self.chooseCat[11] then
    IconManager:SetItemIcon(Table_Item[self.chooseCat[11]].Icon, self.equipItem3)
  else
    IconManager:SetUIIcon(EMPTY_EQUIPID[3], self.equipItem3)
  end
end

function MercenaryCatView:UpdateChoose(id)
  local cells = self.itemlist.wraplist:GetCells()
  for i = 1, #cells do
    local single = cells[i]:GetCells()
    for j = 1, #single do
      single[j]:SetChoose(id)
    end
  end
end

local tempV3, quaternion = LuaVector3(1.85, -1.57, 3.03), LuaQuaternion.Euler(0.5, -33, 0)

function MercenaryCatView:UpdateAssetRole()
  if nil == self.parts then
    self.parts = Asset_Role.CreatePartArray()
  end
  local partIndex = Asset_Role.PartIndex
  self.parts[partIndex.Body] = self.chooseCat.body
  self.parts[partIndex.Head] = self.fakeHead == 0 and self.chooseCat[8] or self.fakeHead
  self.parts[partIndex.Mouth] = self.fakeMouth == 0 and self.chooseCat[10] or self.fakeMouth
  self.parts[partIndex.Wing] = self.fakeBack == 0 and self.chooseCat[11] or self.fakeBack
  self.modelTex:ResetAndUpdateAnchors()
  UIModelUtil.Instance:ResetTexture(self.modelTex)
  UIModelUtil.Instance:ChangeBGMeshRenderer(m_texBGName, self.modelTex)
  UIModelUtil.Instance:SetRoleModelTexture(self.modelTex, self.parts, self.modelCameraConfig, nil, nil, nil, nil, function(obj)
    self.role = obj
    if self.role then
      self.role:SetPosition(tempV3)
      self.role:SetRotation(quaternion)
    end
    self.previewTip.gameObject:SetActive(self.fakeMouth ~= 0 or self.fakeHead ~= 0 or self.fakeBack ~= 0)
  end)
end

function MercenaryCatView:OnClickSkillCell(cellctl)
  if self.itemlist.gameObject.activeSelf then
    return
  end
  self:ShowSkillTip(cellctl:GetSkillItemData(), SkillTip, "SkillTip")
end

function MercenaryCatView:ShowSkillTip(skillItemData, tipCtrl, tipView)
  if not skillItemData then
    return
  end
  self.skillTipData.data = skillItemData
  TipsView.Me():ShowTip(tipCtrl, self.skillTipData, tipView)
  local tip = TipsView.Me().currentTip
  if tip then
    tip:SetCheckClick(self:TipClickCheck())
    tip:SetPos(LuaGeometry.TempGetPosition(self.tsfSkillTipRoot))
  end
end

function MercenaryCatView:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      
      if click then
        if self.skillIcon == click then
          return true
        end
        local cells = self.skillWrapHelper:GetCellCtls()
        for c = 1, #cells do
          for i = 1, #cells[c] do
            if cells[c][i]:IsSelf(click) then
              return true
            end
          end
        end
      end
      return false
    end
  end
  return self.tipCheck
end

function MercenaryCatView:OnClickMercenaryCatHead(cellctl)
  if cellctl.data then
    if self.chooseCat and self.chooseCat.id == cellctl.data.id then
      return
    end
    self:RefreshUI(cellctl.data)
    self.itemlist.gameObject:SetActive(false)
  end
end

function MercenaryCatView:MapEvent()
  self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.UpdateHirePrice)
  self:AddListenEvt(ServiceEvent.ScenePetCatEquipInfoPetCmd, self.HandleCatNtf)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateLeftTime)
  self:AddListenEvt(MyselfEvent.WeaponPetExpChange, self.UpdateExp)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(MyselfEvent.LevelUp, self.UpdateProps)
end

function MercenaryCatView:HandleSyncNpc(note)
  local data = note.body
  if data and self.catnpcData and data.guid == self.catnpcData.id then
    self:UpdateProps()
  end
end

function MercenaryCatView:UpdateExp()
  self.lvSlider.value = MercenaryCatProxy.Instance:GetExpSliderValue()
end

function MercenaryCatView:UpdateHirePrice(note)
  local data = note.body
  if data.type ~= SceneQuest_pb.EOTHERDATA_CAT then
    return
  end
  self:FixedCloseAllChildView()
  self.rehirePos:SetActive(true)
  self.hireDay_1_Tog.value = true
  self.hireDay_7_Tog.value = false
  local ddata = data.data
  local dayType = ddata.param2
  local price = ddata.param3
  if dayType == ScenePet_pb.EEMPLOYTYPE_DAY then
    self.hireDay_1_price = price
    self.hireDay_1_Label.text = price
  elseif dayType == ScenePet_pb.EEMPLOYTYPE_WEEK then
    self.hireDay_7_price = price
    self.hireDay_7_Label.text = price
  end
end

function MercenaryCatView:UpdateLeftTime()
  local menuOpen = FunctionUnLockFunc.Me():CheckCanOpen(self.chooseCat.staticData.MenuID)
  if not menuOpen then
    self:RemoveLeftTimeCheck()
    self.timeleft.text = ZhString.MercenaryCatView_Lock
    self.catnpcData = nil
    self.mercenaryProps = {
      unpack(CONFIG_PROPS.clientProps)
    }
    return
  end
  local cat = TeamProxy.Instance:GetMercenaryCatByID(Game.Myself.data.id * 1000 + self.chooseCat.id)
  if cat then
    self.catnpcData = SceneCreatureProxy.FindCreature(cat.id) and SceneCreatureProxy.FindCreature(cat.id).data
    if self.catnpcData then
      self.mercenaryProps = {
        unpack(CONFIG_PROPS.serverProps)
      }
    else
      self.mercenaryProps = {
        unpack(CONFIG_PROPS.clientProps)
      }
    end
    self.expiretime = cat.expiretime or 0
    local leftTime = self.expiretime - ServerTime.CurServerTime() / 1000
    self:RemoveLeftTimeCheck()
    if 0 < leftTime then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._Tick, self)
    else
      self.timeleft.text = ZhString.TeamMemberCell_Expire
    end
  else
    self:RemoveLeftTimeCheck()
    self.timeleft.text = ZhString.MercenaryCatView_NoHire
    self.catnpcData = nil
    self.mercenaryProps = {
      unpack(CONFIG_PROPS.clientProps)
    }
  end
end

function MercenaryCatView:_Tick(deltatime)
  local leftTime, label = self.expiretime - ServerTime.CurServerTime() / 1000
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if 0 < day then
    label = string.format(ZhString.HireCatTip_HireLeftTimeTip, day + 1)
    label = label .. ZhString.HireCatTip_Day
  else
    label = string.format("%02d:%02d:%02d", hour, min, sec)
    label = string.format(ZhString.HireCatTip_HireLeftTimeTip, label)
  end
  self.timeleft.text = label
  if leftTime <= 0 then
    self:RemoveLeftTimeCheck()
  end
end

function MercenaryCatView:RemoveLeftTimeCheck()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
  end
  self.timeTick = nil
end

local CommonFun_Attr = {
  "Atk",
  "MAtk",
  "Def",
  "MDef",
  "MaxHp",
  "MaxHpPer",
  "Hit",
  "Flee",
  "Cri",
  "CriRes",
  "DamIncrease",
  "MDamIncrease",
  "HealEncPer"
}

function MercenaryCatView:UpdateProps()
  local propMap = Game.Config_PropName
  local result = {}
  local clientfakeAttrs
  local bClientCalc = nil == self.catnpcData
  if bClientCalc then
    for i = 1, #CommonFun_Attr do
      CommonFun_Attr[propMap[CommonFun_Attr[i]].id] = 0
    end
    clientfakeAttrs = CommonFun.calcWeaponPetNpcAttrValue(CommonFun_Attr, self.chooseCat.classtype, MyselfProxy.Instance:RoleLevel(), Game.Myself.data)
    for i = 1, #SIX_BASE_PROPS do
      local data = {}
      data[1] = PetInfoLabelCell.Type.Attri
      data[2] = propMap[SIX_BASE_PROPS[i]].PropName
      data[3] = self.chooseCat.monsterStaticData[SIX_BASE_PROPS[i]]
      data[4] = 200
      data[5] = 22
      result[#result + 1] = data
    end
  end
  for i = 1, #self.mercenaryProps do
    local data = {}
    local VarName = self.mercenaryProps[i]
    local value = self.catnpcData and self.catnpcData:GetProperty(VarName) or clientfakeAttrs[propMap[VarName].id]
    data[1] = PetInfoLabelCell.Type.Attri
    if self.catnpcData then
      data[2] = VarName == "MaxHp" and "Hp" or propMap[VarName].PropName
      data[3] = VarName == "MaxHp" and self.catnpcData:GetProperty("Hp") .. "/" .. value or value
    else
      data[2] = propMap[VarName].PropName
      data[3] = math.floor(value)
    end
    data[4] = 200
    data[5] = 22
    result[#result + 1] = data
  end
  self.attriCtl:ResetDatas(result)
end

function MercenaryCatView:HandleCatNtf(note)
  if nil == self.chooseCat then
    return
  end
  self:RefreshUI(self.chooseCat)
end

function MercenaryCatView:FixedCloseAllChildView()
  if BranchMgr.IsChina() then
    return
  end
  if self.attrViewHolder then
    self.attrViewHolder:SetActive(false)
  end
  if self.itemlist then
    self.itemlist.gameObject:SetActive(false)
  end
  if self.rehirePos then
    self.rehirePos:SetActive(false)
  end
end

function MercenaryCatView:OnEnter()
  MercenaryCatView.super.OnEnter(self)
  if nil == self.role then
    self:UpdateAssetRole()
  end
  self.site = nil
end

function MercenaryCatView:OnExit()
  local tip = TipsView.Me().currentTip
  if tip and tip.SetCheckClick then
    tip:SetCheckClick(nil)
  end
  self:RemoveLeftTimeCheck()
  self.site = nil
  UIModelUtil.Instance:ResetTexture(self.modelTex)
  MercenaryCatView.super.OnExit(self)
end
