local baseCell = autoImport("BaseCell")
QuickUsePopupFuncCell = class("QuickUsePopupFuncCell", baseCell)

function QuickUsePopupFuncCell:Init()
  self.commonStyle = self:FindGO("CommonStyle")
  self.icon = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self.iconLabel = self:FindGO("IconLabel"):GetComponent(UILabel)
  self.closeBtn = self:FindGO("CloseBtn"):GetComponent(UIButton)
  self.functionTip = self:FindGO("FunctionTip")
  self:SetEvent(self.closeBtn.gameObject, function(obj)
    self:TryClose()
  end)
  self.btnLabel = self:FindGO("QuickUseBtnLabel"):GetComponent(UILabel)
  self.quickUseBtn = self:FindGO("QuickUseBtn")
  self.useCollider = self.quickUseBtn:GetComponent(Collider)
  self:SetEvent(self.quickUseBtn, function(obj)
    self:BtnClick()
  end)
  self.doubleQuickUse = self:FindGO("DoubleQuickUse")
  local button1 = self:FindGO("Button1", self.doubleQuickUse)
  self.button1_label = self:FindComponent("Label", UILabel, button1)
  self:SetEvent(button1, function(go)
    self:DoButton1Event()
  end)
  local button2 = self:FindGO("Button2", self.doubleQuickUse)
  self.button2_label = self:FindComponent("Label", UILabel, button2)
  self:SetEvent(button2, function(go)
    self:DoButton2Event()
  end)
  self.interactiveStyle = self:FindGO("InteractiveStyle")
  self.interactiveIconGO = self:FindGO("InteractiveIconGO", self.interactiveStyle)
  self.interactiveIcon = self:FindGO("InteractiveIcon", self.interactiveIconGO):GetComponent(UISprite)
  self.interactiveLabel = self:FindGO("InteractiveLabel", self.interactiveStyle):GetComponent(UILabel)
  self.interactiveTween = self.interactiveIconGO:GetComponent(TweenScale)
  self.interactiveProcess = self:FindGO("InteractiveProcess", self.interactiveStyle):GetComponent(UISprite)
  self.interactiveProcess.fillAmount = 0
  self:SetEvent(self.interactiveIconGO, function(go)
    local questData = self.data.questData
    local params = questData and questData.params
    local pressTime = params and params.presstime
    if not pressTime then
      self:BtnClick()
    end
  end)
  local press = function(obj, isPress)
    local questData = self.data.questData
    local params = questData and questData.params
    local pressTime = params and params.presstime
    if not pressTime then
      return
    end
    if isPress then
      local questData = self.data.questData
      QuestUseFuncManager.Me():PlayUseEffect(questData.id)
      self.endPressStamp = ServerTime.CurServerTime() / 1000 + pressTime
      TimeTickManager.Me():CreateTick(0, 33, self.updateLongPressProcess, self, 1)
      self.interactiveTween.enabled = false
      self.interactiveIcon.color = LuaGeometry.GetTempVector4(0.7098039215686275, 0.7098039215686275, 0.7098039215686275, 1)
      self.interactiveIconGO.transform.localScale = LuaGeometry.GetTempVector3(0.9, 0.9, 0.9)
    else
      QuestUseFuncManager.Me():StopPlayUseEffect()
      self.interactiveProcess.fillAmount = 0
      self.interactiveTween.enabled = true
      self.interactiveIcon.color = LuaColor.White()
      TimeTickManager.Me():ClearTick(self, 1)
    end
  end
  self:AddPressEvent(self.interactiveIconGO, press)
  self:InitTypes()
end

function QuickUsePopupFuncCell:InitTypes()
  self.typeShow = {}
  self.typeClick = {}
  self.typeRefreshNum = {}
  self.typeShow[QuickUseProxy.Type.Quest] = self.QuestShow
  self.typeShow[QuickUseProxy.Type.Equip] = self.EquipShow
  self.typeShow[QuickUseProxy.Type.Fashion] = self.FashionShow
  self.typeShow[QuickUseProxy.Type.Trigger] = self.TriggerShow
  self.typeShow[QuickUseProxy.Type.Common] = self.CommonShow
  self.typeShow[QuickUseProxy.Type.Item] = self.ItemShow
  self.typeShow[QuickUseProxy.Type.CatchPet] = self.CatchPetShow
  self.typeShow[QuickUseProxy.Type.TwelvePVPTrigger] = self.TwelvePVPShopShow
  self.typeShow[QuickUseProxy.Type.Skill] = self.SkillShow
  self.typeShow[QuickUseProxy.Type.StealthGame_Item] = self.ItemShow
  self.typeClick[QuickUseProxy.Type.Quest] = self.QuestClick
  self.typeClick[QuickUseProxy.Type.Equip] = self.EquipClick
  self.typeClick[QuickUseProxy.Type.Fashion] = self.FashionClick
  self.typeClick[QuickUseProxy.Type.Trigger] = self.TriggerClick
  self.typeClick[QuickUseProxy.Type.Common] = self.CommonClick
  self.typeClick[QuickUseProxy.Type.Skill] = self.CommonClick
  self.typeClick[QuickUseProxy.Type.Item] = self.ItemClick
  self.typeClick[QuickUseProxy.Type.TwelvePVPTrigger] = self.TwelvePVPShopOpen
  self.typeClick[QuickUseProxy.Type.StealthGame_Item] = self.onUseStealthGameItem
  self.typeRefreshNum[QuickUseProxy.Type.CatchPet] = self.CatchPetNumRefrehs
  self.doubleQuickUse_typeClick1 = {}
  self.doubleQuickUse_typeClick2 = {}
  self.doubleQuickUse_typeClick1[QuickUseProxy.Type.CatchPet] = self.CathPetClick1
  self.doubleQuickUse_typeClick2[QuickUseProxy.Type.CatchPet] = self.CathPetClick2
  self.enableCheck = {}
  self.enableCheck[QuickUseProxy.Type.Skill] = self.SkillEnableCheck
end

function QuickUsePopupFuncCell:SetData(data)
  self.data = data and data.data or nil
  if data == nil then
    UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
      UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback()
    end)
    self:Hide()
  else
    self.type = data.type
    self:Show()
    self:Refresh()
    UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
      if self.type == QuickUseProxy.Type.Common or self.type == QuickUseProxy.Type.Equip or self.type == QuickUseProxy.Type.Item then
        self:Hide()
      end
      UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback()()
    end)
  end
end

function QuickUsePopupFuncCell:SetStealthGameData(value, type)
  if value == nil then
    self:Hide()
  else
    self.data = value
    self.type = type
    self:Show()
    self:Refresh()
    self:TrySetIcon()
  end
end

function QuickUsePopupFuncCell:Refresh()
  self.closeBtn.gameObject:SetActive(self.type ~= QuickUseProxy.Type.Quest)
  self.doubleQuickUse:SetActive(self.type == QuickUseProxy.Type.CatchPet)
  self.quickUseBtn:SetActive(self.type ~= QuickUseProxy.Type.CatchPet)
  self.interactiveStyle:SetActive(self.type == QuickUseProxy.Type.Quest)
  self.numLabel.gameObject:SetActive(false)
  if self.mainColorPalette then
    self.mainColorPalette:SetActive(false)
  end
  self.typeShow[self.type](self)
end

function QuickUsePopupFuncCell:UpdateEquipInfo(item, btnLabel)
  self.interactiveStyle:SetActive(false)
  self.commonStyle:SetActive(true)
  self.btnLabel.text = btnLabel or ZhString.QuickUsePopupFuncCell_EquipBtn
  self.iconLabel.text = item.staticData.NameZh
  IconManager:SetItemIcon(item.staticData.Icon, self.icon)
  self.icon:MakePixelPerfect()
  if self.functionTip then
    self.functionTip:SetActive(item.staticData.Type == 65)
  end
  ItemCell.SetMainColorPalette(self, item, self._MainColorPaletteCellPartLoader)
end

function QuickUsePopupFuncCell:_MainColorPaletteCellPartLoader()
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCellParts/ItemCell_MainColorPalette"), self.icon.gameObject)
  local ws = UIUtil.GetAllComponentsInChildren(go, UIWidget)
  if ws then
    local iconDepth = self.icon.depth
    for i = 1, #ws do
      ws[i].depth = ws[i].depth + iconDepth
    end
  end
  return go
end

function QuickUsePopupFuncCell:ItemShow()
  self:UpdateEquipInfo(self.data, ZhString.QuickUsePopupFuncCell_UseBtn)
  if self.data and type(self.data) == "table" then
    if self.data.closeUi and self.type == QuickUseProxy.Type.StealthGame_Item then
      self:TryClose()
      return
    end
    FunctionItemCompare.Me():SetHint(self.data)
  end
end

function QuickUsePopupFuncCell:EquipShow()
  self:UpdateEquipInfo(self.data)
  FunctionItemCompare.Me():SetHint(self.data)
end

function QuickUsePopupFuncCell:FashionShow()
  local item = BagProxy.Instance:GetItemByStaticID(self.data)
  if item then
    self:UpdateEquipInfo(item)
    FunctionItemCompare.Me():SetHint(item)
  end
end

function QuickUsePopupFuncCell:QuestShow()
  self.btnLabel.text = self.data.btn or ZhString.QuickUsePopupFuncCell_CameraBtn
  self.iconLabel.text = self.data.content or ""
  self:TrySetIcon()
end

function QuickUsePopupFuncCell:TriggerShow()
  self:Hide(self.closeBtn.gameObject)
  self.interactiveStyle:SetActive(false)
  self.commonStyle:SetActive(true)
  if self.data.data.skill then
    local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(self.data.data.skill)
    local staticData = skill.staticData
    if staticData then
      IconManager:SetSkillIcon(staticData.Icon, self.icon)
      if staticData.SkillType == GameConfig.SkillType.Purify.type then
        self.btnLabel.text = MsgParserProxy.Instance:TryParse(Table_Sysmsg[701].button, self.data.params[1])
        self.iconLabel.text = MsgParserProxy.Instance:TryParse(Table_Sysmsg[701].Text, skill and skill.leftTimes or 0, skill and skill.maxTimes or 0)
      else
      end
    end
  end
  self.icon.width = 76
  self.icon.height = 76
end

function QuickUsePopupFuncCell:CommonShow()
  if self.data.canClose then
    self:Show(self.closeBtn.gameObject)
  else
    self:Hide(self.closeBtn.gameObject)
  end
  self:TrySetIcon()
  self.iconLabel.text = self.data.iconStr ~= nil and self.data.iconStr or ""
  self.btnLabel.text = self.data.btnStr ~= nil and self.data.btnStr or ""
end

function QuickUsePopupFuncCell:SkillShow()
  local skillid = self.data.skillid
  if not skillid then
    self:Hide()
    return
  end
  self.interactiveStyle:SetActive(false)
  self.commonStyle:SetActive(true)
  self.closeBtn.gameObject:SetActive(false)
  local skillData = Table_Skill[skillid]
  self.iconLabel.text = skillData.NameZh
  self.btnLabel.text = ZhString.QuickUsePopupFuncCell_UseBtn
  IconManager:SetSkillIcon(skillData.Icon, self.icon)
  self.icon.width = 76
  self.icon.height = 76
  self:Show()
end

function QuickUsePopupFuncCell:CatchPetShow()
  self:Hide(self.closeBtn.gameObject)
  local data = self.data
  local cpatureData = data[2]
  if cpatureData == nil then
    return
  end
  self.interactiveStyle:SetActive(false)
  self.commonStyle:SetActive(true)
  self.numLabel.gameObject:SetActive(true)
  self.numLabel.text = BagProxy.Instance:GetItemNumByStaticID(cpatureData.GiftItemID) or 0
  local itemSData = Table_Item[cpatureData.GiftItemID]
  IconManager:SetItemIcon(itemSData.Icon, self.icon)
  self.icon:MakePixelPerfect()
  self.iconLabel.text = itemSData.NameZh
  self.doubleQuickUse:SetActive(true)
  self.quickUseBtn:SetActive(false)
  self.button1_label.text = ZhString.QuickUsePopupFuncCell_Catch
  self.button2_label.text = ZhString.QuickUsePopupFuncCell_Give
end

function QuickUsePopupFuncCell:TrySetIcon()
  if self.data.iconType == "interactiveIcon" then
    self.interactiveStyle:SetActive(true)
    self.commonStyle:SetActive(false)
    IconManager:SetUIIcon(self.data.iconID, self.interactiveIcon)
    local offsetConfig = GameConfig.Quest.InteractiveIconOffset
    local curConfig = offsetConfig and offsetConfig[self.data.iconID]
    if curConfig and curConfig.offset then
      self.interactiveIcon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(curConfig.offset[1], curConfig.offset[2], 0)
    else
      self.interactiveIcon.gameObject.transform.localPosition = LuaVector3.Zero()
    end
    if curConfig and curConfig.scale then
      self.interactiveIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(curConfig.scale, curConfig.scale, curConfig.scale)
    else
      self.interactiveIcon.gameObject.transform.localScale = LuaVector3.One()
    end
    local offsetX, offsetY = offsetConfig and offsetConfig
    self.interactiveLabel.text = self.data.content or ""
    local questData = self.data.questData
    local params = questData and questData.params
    local pressTime = params and params.presstime
    if pressTime then
      self.interactiveTween:ResetToBeginning()
      self.interactiveTween:PlayForward()
    else
      self.interactiveTween:ResetToBeginning()
      self.interactiveTween.enabled = false
    end
    return
  end
  self.interactiveStyle:SetActive(false)
  self.commonStyle:SetActive(true)
  if self.data.iconType == "itemIcon" then
    IconManager:SetItemIcon(self.data.iconID, self.icon)
    self.icon:MakePixelPerfect()
  elseif self.data.iconType == "npcIcon" then
    IconManager:SetNpcMonsterIconByID(self.data.iconID, self.icon)
    self.icon.width = 76
    self.icon.height = 76
  elseif self.data.iconType == "skillIcon" then
    IconManager:SetSkillIcon(self.data.iconID, self.icon)
    self.icon.width = 76
    self.icon.height = 76
  elseif self.data.iconType == "uiIcon" then
    IconManager:SetUIIcon(self.data.iconID, self.icon)
    self.icon.width = 76
    self.icon.height = 76
  end
end

function QuickUsePopupFuncCell:BtnClick()
  self.typeClick[self.type](self)
  if self.type ~= QuickUseProxy.Type.Item then
    self:TryClose()
  end
end

function QuickUsePopupFuncCell:DoButton1Event()
  local func = self.doubleQuickUse_typeClick1[self.type]
  local needClose = false
  if func then
    needClose = func(self)
  end
  if needClose then
    self:TryClose()
  end
end

function QuickUsePopupFuncCell:DoButton2Event()
  local func = self.doubleQuickUse_typeClick2[self.type]
  local needClose = false
  if func then
    needClose = func(self)
  end
  if needClose then
    self:TryClose()
  end
end

function QuickUsePopupFuncCell:QuestClick()
  if self.data.questData.questDataStepType == QuestDataStepType.QuestDataStepType_USE then
    local questData = self.data.questData
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
  elseif self.data.questData.questDataStepType == QuestDataStepType.QuestDataStepType_SELFIE then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PhotographPanel,
      force = true,
      viewdata = {
        questData = self.data.questData
      }
    })
  elseif self.data.questData.questDataStepType == "shot" then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GunShootPanel,
      force = true,
      viewdata = {
        questData = self.data.questData
      }
    })
  elseif self.data.questData.questDataStepType == "shot_advanced" then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GunShootBirdPanel,
      force = true,
      viewdata = {
        questData = self.data.questData,
        birdShoot = true
      }
    })
  elseif self.data.questData.questDataStepType == QuestDataStepType.QuestDataStepType_PICKING_SORT then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PickingReorderPanel,
      force = true,
      viewdata = {
        questData = self.data.questData
      }
    })
  end
end

function QuickUsePopupFuncCell:ItemClick()
  local data = self.data
  if data then
    local itemTarget = data.staticData.ItemTarget
    if itemTarget and itemTarget.type then
      local realTarget = Game.Myself:GetLockTarget()
      if not realTarget then
        MsgManager.ShowMsgByIDTable(710)
        return
      end
      local creatureType = realTarget:GetCreatureType()
      if Creature_Type.Player == creatureType and not data:CanUseForTarget(ItemTarget_Type.Player) then
        MsgManager.ShowMsgByIDTable(711)
        return
      elseif Creature_Type.Npc == creatureType then
        if realTarget.data:IsNpc() and not data:CanUseForTarget(ItemTarget_Type.Npc, realTarget.data:GetStaticID()) then
          MsgManager.ShowMsgByIDTable(711)
          return
        elseif realTarget.data:IsMonster() and not data:CanUseForTarget(ItemTarget_Type.Monster) then
          MsgManager.ShowMsgByIDTable(711)
          return
        end
      end
    end
  end
  FunctionItemFunc.ItemUseEvt(self.data)
  self:TryClose()
end

function QuickUsePopupFuncCell:onUseStealthGameItem()
  if self.data ~= nil then
    SgAIManager.Me():onTryUsePlayThePianoItem(self.data.uid)
  end
  self:TryClose()
end

function QuickUsePopupFuncCell:EquipClick()
  FunctionItemFunc.CallEquipEvt(self.data, self.data.site)
end

function QuickUsePopupFuncCell:FashionClick()
  local item = BagProxy.Instance:GetItemByStaticID(self.data)
  if item then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON, nil, item.id)
  else
    error("快捷装备，无法在背包中找到时装。静态id为" .. self.data)
  end
end

function QuickUsePopupFuncCell:TriggerClick()
  if self.data.type == SceneMap_pb.EACTTYPE_PURIFY and self.data.data.skill then
    local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(self.data.data.skill)
    if skill then
      if skill.leftTimes and skill.leftTimes >= self.data.serverData.actvalue then
        GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, {
          skill = skill.id,
          target = self.data.master
        })
        FunctionPurify.Me():TryPurifyMonster(self.data.master)
      else
        MsgManager.ShowMsgByIDTable(702)
      end
    end
  end
end

function QuickUsePopupFuncCell:CommonClick()
  if self.data.ClickCall then
    self.data.ClickCall(self.data.ClickCallParam)
  end
  self:TryClose()
end

function QuickUsePopupFuncCell:CathPetClick1()
  FunctionPet.Me():DoCatch(self.data[1])
  return false
end

function QuickUsePopupFuncCell:CathPetClick2()
  ServiceScenePetProxy.Instance:CallCatchPetGiftPetCmd(self.data[1])
  return false
end

function QuickUsePopupFuncCell:CanUseSkillById(skillid)
  if not skillid then
    return false
  end
  local sData = Table_Skill[skillid]
  if not sData then
    return false
  end
  if not SkillProxy.Instance:SkillCanBeUsedByID(skillid, true) then
    return false
  end
  if sData.PreCondition and sData.PreCondition.ProType == 11 and Game.Myself.data:HasBuffID(157361) then
    return false
  end
  return true
end

function QuickUsePopupFuncCell:SkillEnableCheck()
  local newEnable = self:CanUseSkillById(self.data and self.data.skillid)
  if self.skillEnable == newEnable then
    return
  end
  self.skillEnable = newEnable
  if newEnable then
    self:SetTextureWhite(self.quickUseBtn, ColorUtil.ButtonLabelBlue)
    self:SetTextureWhite(self.icon)
    self.useCollider.enabled = true
  else
    self:SetTextureGrey(self.quickUseBtn)
    self:SetTextureGrey(self.icon)
    self.useCollider.enabled = false
  end
end

function QuickUsePopupFuncCell:CatchPetNumRefrehs()
  local cpatureData = self.data[2]
  if cpatureData == nil then
    return
  end
  self.numLabel.gameObject:SetActive(true)
  self.numLabel.text = BagProxy.Instance:GetItemNumByStaticID(cpatureData.GiftItemID) or 0
end

function QuickUsePopupFuncCell:TryClose()
  if self.data and type(self.data) == "table" and self.data.noClose then
    return
  end
  if self.type == QuickUseProxy.Type.Skill and not self:CanUseSkillById(self.data and self.data.skillid) then
    return
  end
  if self.type == QuickUseProxy.Type.Equip then
    QuickUseProxy.Instance:RemoveBetterEquip(self.data)
  elseif self.type == QuickUseProxy.Type.Fashion then
    QuickUseProxy.Instance:RemoveNeverEquipedFashion(self.data, true)
  elseif self.type == QuickUseProxy.Type.Item then
    QuickUseProxy.Instance:RemoveItemUse(self.data)
  elseif self.type == QuickUseProxy.Type.CatchPet then
    QuickUseProxy.Instance:RemoveCatchPetData(self.data)
  elseif self.type == QuickUseProxy.Type.TwelvePVPTrigger then
    QuickUseProxy.Instance:RemoveTwelveTriggerData(self.data)
  else
    QuickUseProxy.Instance:RemoveCommon(self.data)
  end
  self:DispatchEvent(UIEvent.CloseUI)
end

function QuickUsePopupFuncCell:RefreshNum()
  if not self.gameObject.activeSelf then
    return
  end
  local func = self.typeRefreshNum[self.type]
  if func then
    func(self)
  end
end

function QuickUsePopupFuncCell:TwelvePVPShopShow()
  if self.data.canClose then
    self:Show(self.closeBtn.gameObject)
  else
    self:Hide(self.closeBtn.gameObject)
  end
  local ui1Atlas = RO.AtlasMap.GetAtlas("NewUI5")
  if ui1Atlas then
    self.icon.atlas = ui1Atlas
    self.icon.spriteName = self.data.iconID
    self.icon.width = 76
    self.icon.height = 76
  end
  self.iconLabel.text = self.data.iconStr ~= nil and self.data.iconStr or ""
  self.btnLabel.text = self.data.btnStr ~= nil and self.data.btnStr or ""
end

function QuickUsePopupFuncCell:TwelvePVPShopOpen()
  if Game.MapManager:IsPvPMode_TeamTwelve() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TwelvePVPShopView
    })
  end
  self:TryClose()
end

function QuickUsePopupFuncCell:updateLongPressProcess()
  if not self.endPressStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
  local leftTime = self.endPressStamp - ServerTime.CurServerTime() / 1000
  self.interactiveProcess.fillAmount = 1 - leftTime
  if leftTime <= 0 then
    self:BtnClick()
    QuestUseFuncManager.Me():StopPlayUseEffect()
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
end

function QuickUsePopupFuncCell:Show(target)
  if not Slua.IsNull(target) then
    QuickUsePopupFuncCell.super.Show(self, target)
    return
  end
  if not self.gameObject then
    return
  end
  if self.cacheActive == true then
    return
  end
  if not self.data then
    return
  end
  self.cacheActive = true
  self.gameObject:SetActive(true)
  self.skillEnable = nil
  local checkFunc = self.enableCheck[self.type]
  if checkFunc then
    self.enableCheckTick = TimeTickManager.Me():CreateTick(0, 16, checkFunc, self, 123)
  end
end

function QuickUsePopupFuncCell:Hide(target)
  if not Slua.IsNull(target) then
    QuickUsePopupFuncCell.super.Hide(self, target)
    return
  end
  if not self.gameObject then
    return
  end
  if self.cacheActive == false then
    return
  end
  self.cacheActive = false
  self.gameObject:SetActive(false)
  if self.enableCheckTick then
    self.enableCheckTick = nil
    TimeTickManager.Me():ClearTick(self, 123)
  end
end
