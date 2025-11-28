autoImport("SkillTip")
autoImport("PeakSkillPreviewTip")
autoImport("PvpTalentCell")
autoImport("SkillItemData")
autoImport("BalanceModeSkillCell")
PvpTalentContentPage = class("PvpTalentContentPage", SkillBaseContentPage)
local tmpPos = LuaVector3.Zero()

function PvpTalentContentPage:Init()
  self.gameObject = self:FindGO("PvpTalentContentPage", self:FindGO("SkillPages"))
  local useless, pwsConfig = next(GameConfig.PvpTeamRaid)
  self.pwsConfig = pwsConfig
  self.tipdata = {}
  self.usablePoints = 0
  self.maxPoints = 0
  self:FindObjs()
  self:InitTalentsList()
  self:AddViewListener()
  self:AddButtonEvts()
end

function PvpTalentContentPage:FindObjs()
  self.objLeftTopInfo = self:FindGO("Left", self:FindGO("Up"))
  self.objPwsTop = self:FindGO("pwsTop", self.objLeftTopInfo)
  self.objBalanceModeTop = self:FindGO("balanceModeTop", self.objLeftTopInfo)
  self.objContents = self:FindGO("Contents")
  self.objPwsContent = self:FindGO("PwsContent", self.objContents)
  self.objBalanceModeContent = self:FindGO("BalanceModeContent", self.objContents)
  self.labUsablePoints = self:FindComponent("labPvpTalentPoints", UILabel, self.objPwsTop)
  self.objRightButtons = self:FindGO("RightBtns")
  self.objBtnConfirm = self:FindGO("PvpTalentConfirmBtn", self.objRightButtons)
  self.objBtnCancel = self:FindGO("PvpTalentCancelBtn", self.objRightButtons)
  self.objScrollArea = self:FindGO("PvpTalentArea", self:FindGO("ScrollArea"))
  self.objBtnReset = self:FindGO("PvpTalentResetBtn", self.objPwsTop)
  self.contentPanel = self:FindComponent("PvpTalentContent", UIPanel, self.objPwsContent)
  self.contentScroll = self.contentPanel.gameObject:GetComponent(ScrollViewWithProgress)
  self.balanceScollView = self:FindComponent("ScrollParent", UIScrollView, self.objBalanceModeContent)
  self.balanceTable = self:FindComponent("Table", UITable, self.objBalanceModeContent)
  self:InitBalanceModeUI()
  self:InitEquipMemoryUI()
  self:InitToggles()
end

function PvpTalentContentPage:InitBalanceModeUI()
  self.balanceModeType = {}
  self.balanceModeType[1] = self:FindGO("AttackType", self.objBalanceModeContent)
  self.balanceModeType[2] = self:FindGO("DefType", self.objBalanceModeContent)
  self.balanceModeType[3] = self:FindGO("ArtifactType", self.objBalanceModeContent)
  if ISNoviceServerType then
    self.balanceModeType[1]:SetActive(false)
    self.balanceModeType[2]:SetActive(false)
    self.balanceModeType[3]:SetActive(false)
  else
    self:InitModeTypeUI(self.balanceModeType, 3, "balance")
  end
  self:InitModeTypeUI(self.balanceModeType, 3, "balance")
end

function PvpTalentContentPage:InitEquipMemoryUI()
  self.memoryType = {}
  self.memoryType[1] = self:FindGO("Memory_Set1", self.objBalanceModeContent)
  self.memoryType[2] = self:FindGO("Memory_Set2", self.objBalanceModeContent)
  self.memoryType[3] = self:FindGO("Memory_Set3", self.objBalanceModeContent)
  self.memoryType[4] = self:FindGO("Memory_Set4", self.objBalanceModeContent)
  self.memoryUpgradeType = {}
  self.memoryUpgradeType[1] = self:FindGO("MemoryUprade_Set1", self.objBalanceModeContent)
  self.memoryUpgradeType[2] = self:FindGO("MemoryUprade_Set2", self.objBalanceModeContent)
  self.memoryUpgradeType[3] = self:FindGO("MemoryUprade_Set3", self.objBalanceModeContent)
  self.memoryUpgradeType[4] = self:FindGO("MemoryUprade_Set4", self.objBalanceModeContent)
  if ISNoviceServerType then
    self.memoryType[3]:SetActive(false)
    self.memoryUpgradeType[3]:SetActive(false)
    local bg4 = self:FindGO("Bg", self.memoryType[4]):GetComponent(UISprite)
    bg4.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.00392156862745098)
    local labLayer = self:FindGO("labLayer", self.memoryType[4]):GetComponent(UILabel)
    labLayer.text = ZhString.EquipMemory_SetName_SP
    local upgradeBg4 = self:FindGO("Bg", self.memoryUpgradeType[4]):GetComponent(UISprite)
    upgradeBg4.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.00392156862745098)
    local upgradeLabLayer = self:FindGO("labLayer", self.memoryUpgradeType[4]):GetComponent(UILabel)
    upgradeLabLayer.text = ZhString.EquipMemory_SetName_SP_Upgrade
  end
  self:InitModeTypeUI(self.memoryType, 4, "memory")
  self:InitModeTypeUI(self.memoryUpgradeType, 4, "memoryUpgrade")
end

function PvpTalentContentPage:InitModeTypeUI(typeTable, count, prefix)
  local scrollViewKey = prefix .. "ScrollView"
  local curSkillCellKey = prefix .. "CurSkillCell"
  local curSkillCellBgKey = prefix .. "CurSkillCell_Bg"
  local curSkillCellIconKey = prefix .. "CurSkillCell_Icon"
  local curSkillCellEmptyKey = prefix .. "CurSkillCell_Empty"
  local curSkillCellHighlightKey = prefix .. "CurSkillCell_HightLight"
  local skillCtrlKey = prefix .. "SkillCtrl"
  local dragDropKey = prefix .. "DragDrop"
  if not self[scrollViewKey] then
    self[scrollViewKey] = {}
  end
  if not self[curSkillCellKey] then
    self[curSkillCellKey] = {}
  end
  if not self[curSkillCellBgKey] then
    self[curSkillCellBgKey] = {}
  end
  if not self[curSkillCellIconKey] then
    self[curSkillCellIconKey] = {}
  end
  if not self[curSkillCellEmptyKey] then
    self[curSkillCellEmptyKey] = {}
  end
  if not self[curSkillCellHighlightKey] then
    self[curSkillCellHighlightKey] = {}
  end
  if not self[skillCtrlKey] then
    self[skillCtrlKey] = {}
  end
  if not self[dragDropKey] then
    self[dragDropKey] = {}
  end
  if prefix == "balance" then
    self.balanceModeScrollView = self[scrollViewKey]
    self.curSkillCell = self[curSkillCellKey]
    self.curSkillCell_Bg = self[curSkillCellBgKey]
    self.curSkillCell_Icon = self[curSkillCellIconKey]
    self.curSkillCell_Empty = self[curSkillCellEmptyKey]
    self.curSkillCell_HightLight = self[curSkillCellHighlightKey]
    self.skillCtrl = self[skillCtrlKey]
    self.dragDrop = self[dragDropKey]
  elseif prefix == "memory" then
    self.memoryScrollView = self[scrollViewKey]
    self.memoryCurSkillCell = self[curSkillCellKey]
    self.memoryCurSkillCell_Bg = self[curSkillCellBgKey]
    self.memoryCurSkillCell_Icon = self[curSkillCellIconKey]
    self.memoryCurSkillCell_Empty = self[curSkillCellEmptyKey]
    self.memoryCurSkillCell_HightLight = self[curSkillCellHighlightKey]
    self.memorySkillCtrl = self[skillCtrlKey]
    self.memoryDragDrop = self[dragDropKey]
  elseif prefix == "memoryUpgrade" then
    self.memoryUpgradeScrollView = self[scrollViewKey]
    self.memoryUpgradeCurSkillCell = self[curSkillCellKey]
    self.memoryUpgradeCurSkillCell_Bg = self[curSkillCellBgKey]
    self.memoryUpgradeCurSkillCell_Icon = self[curSkillCellIconKey]
    self.memoryUpgradeCurSkillCell_Empty = self[curSkillCellEmptyKey]
    self.memoryUpgradeCurSkillCell_HightLight = self[curSkillCellHighlightKey]
    self.memoryUpgradeSkillCtrl = self[skillCtrlKey]
    self.memoryUpgradeDragDrop = self[dragDropKey]
  end
  for i = 1, count do
    self[scrollViewKey][i] = self:FindGO("TalentScrollView", typeTable[i]):GetComponent(UIScrollView)
    self[curSkillCellKey][i] = self:FindGO("CurSkill", typeTable[i])
    self[curSkillCellBgKey][i] = self[curSkillCellKey][i]:GetComponent(UISprite)
    self[curSkillCellIconKey][i] = self:FindGO("CurSkillIcon", self[curSkillCellKey][i]):GetComponent(UISprite)
    self[curSkillCellEmptyKey][i] = self:FindGO("EmptyTip", self[curSkillCellKey][i])
    self[curSkillCellHighlightKey][i] = self:FindGO("HighLight", self[curSkillCellKey][i])
    self[curSkillCellHighlightKey][i]:SetActive(false)
    local gridTalents = self:FindComponent("gridTalents", UIGrid, typeTable[i])
    self[skillCtrlKey][i] = UIGridListCtrl.new(gridTalents, BalanceModeSkillCell, "BalanceModeSkillCell")
    if prefix == "balance" then
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.MouseClick, self.ShowBalanceModeSkillTipHandler, self)
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.DoubleClick, self.HandleBalanceModelSkillDoubleClick, self)
    elseif prefix == "memory" then
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.MouseClick, self.ShowMemorySkillTipHandler, self)
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.DoubleClick, self.HandleMemorySkillDoubleClick, self)
    elseif prefix == "memoryUpgrade" then
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.MouseClick, self.ShowMemoryUpgradeSkillTipHandler, self)
      self[skillCtrlKey][i]:AddEventListener(MouseEvent.DoubleClick, self.HandleMemoryUpgradeSkillDoubleClick, self)
    end
    self[dragDropKey][i] = DragDropCell.new(self[curSkillCellKey][i]:GetComponent(UIDragItem), 0.01)
    self[dragDropKey][i].dragDropComponent.OnCursor = DragCursorPanel.Instance.ShowItemCell_NoQuality
    if prefix == "balance" then
      self:SetupBalanceModeCallbacks(self[dragDropKey][i], i)
    elseif prefix == "memory" then
      self:SetupMemoryCallbacks(self[dragDropKey][i], i)
    elseif prefix == "memoryUpgrade" then
      self:SetupMemoryUpgradeCallbacks(self[dragDropKey][i], i)
    end
    self[dragDropKey][i].dragDropComponent.GetObserved = function()
      return self
    end
    self[dragDropKey][i].dragDropComponent.OnStart = function()
    end
    self:AddClickEvent(self[curSkillCellKey][i], function()
      if prefix == "balance" then
        self:HandleBalanceSkillCellClick(i)
      elseif prefix == "memory" then
        self:HandleMemorySkillCellClick(i)
      elseif prefix == "memoryUpgrade" then
        self:HandleMemoryUpgradeSkillCellClick(i)
      end
    end)
    self:AddDoubleClickEvent(self[curSkillCellKey][i], function()
      if prefix == "balance" then
        self:HandleBalanceSkillCellDoubleClick(i)
      elseif prefix == "memory" then
        self:HandleMemorySkillCellDoubleClick(i)
      elseif prefix == "memoryUpgrade" then
        self:HandleMemoryUpgradeSkillCellDoubleClick(i)
      end
    end)
  end
end

function PvpTalentContentPage:SetQualityBg(qualityBgSprite, quality)
  if not qualityBgSprite then
    return
  end
  if quality == 1 then
    local spName = "com_icon_bottom3"
    qualityBgSprite.atlas = RO.AtlasMap.GetAtlas("NewCom")
    qualityBgSprite.spriteName = spName
  else
    qualityBgSprite.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    if quality == 2 then
      qualityBgSprite.spriteName = "refine_bg_green"
    elseif quality == 3 then
      qualityBgSprite.spriteName = "refine_bg_blue"
    elseif quality == 4 then
      qualityBgSprite.spriteName = "refine_bg_purple"
    elseif quality == 5 then
      qualityBgSprite.spriteName = "refine_bg_orange"
    elseif quality == 6 then
      qualityBgSprite.spriteName = "refine_bg_red"
    end
  end
  qualityBgSprite.color = LuaColor.White()
end

function PvpTalentContentPage:SetupBalanceModeCallbacks(dragDrop, index)
  function dragDrop.dragDropComponent.OnReplace(obj)
    if obj then
      if obj.isArtifact then
        SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, obj.id)
      elseif obj.type == 1 then
        SkillProxy.Instance:CallBalanceModeChooseMess(obj.id, nil, nil)
      elseif obj.type == 2 then
        SkillProxy.Instance:CallBalanceModeChooseMess(nil, obj.id, nil)
      end
    end
  end
  
  function dragDrop.dragDropComponent.OnDropEmpty(obj)
    if obj then
      redlog(obj, index)
    end
    if index == 1 then
      SkillProxy.Instance:CallBalanceModeChooseMess(0)
    elseif index == 2 then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, 0, nil)
    elseif index == 3 then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, 0)
    end
  end
end

local EnumToTempPos = {
  [1] = 5,
  [2] = 2,
  [3] = 8,
  [4] = 1
}

function PvpTalentContentPage:SetupMemoryCallbacks(dragDrop, index)
  function dragDrop.dragDropComponent.OnReplace(obj)
    if obj and obj.data then
      xdlog("OnReplace", index)
      
      if obj.data and obj.data.groupType and obj.data.groupType ~= index then
        return
      end
      xdlog("装备记忆OnReplace", index, EnumToTempPos[index], obj.data.effectId)
      local effect = {
        index = 2,
        effect_id = obj.data.effectId
      }
      ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    end
  end
  
  function dragDrop.dragDropComponent.OnDropEmpty(obj)
    if obj then
      redlog("装备记忆OnDropEmpty", index, EnumToTempPos[index])
      local effect = {index = 2, effect_id = 0}
      ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    end
    xdlog("装备记忆OnDropEmpty", index)
  end
end

function PvpTalentContentPage:SetupMemoryUpgradeCallbacks(dragDrop, index)
  function dragDrop.dragDropComponent.OnReplace(obj)
    if obj and obj.data then
      xdlog("升级记忆OnReplace", index)
      
      if obj.data and obj.data.groupType and obj.data.groupType ~= index then
        return
      end
      xdlog("升级记忆OnReplace", index, EnumToTempPos[index], obj.data.effectId)
      local effect = {
        index = 3,
        effect_id = obj.data.effectId
      }
      ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    end
  end
  
  function dragDrop.dragDropComponent.OnDropEmpty(obj)
    if obj then
      redlog("升级记忆OnDropEmpty", index, EnumToTempPos[index])
      local effect = {index = 3, effect_id = 0}
      ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    end
    xdlog("升级记忆OnDropEmpty", index)
  end
end

function PvpTalentContentPage:HandleBalanceSkillCellClick(index)
  local curEquipSkill = SkillProxy.Instance:GetBalanceModeChooseMess()
  if curEquipSkill and curEquipSkill[index] and curEquipSkill[index] ~= 0 then
    self:ShowCurEquipedBalanceModeSkill(self.curSkillCell_Icon[index], {
      isArtifact = index == 3 and true or false,
      id = curEquipSkill[index],
      type = index
    })
  end
end

function PvpTalentContentPage:HandleBalanceSkillCellDoubleClick(index)
  local curEquipSkill = SkillProxy.Instance:GetBalanceModeChooseMess()
  if curEquipSkill and curEquipSkill[index] and curEquipSkill[index] ~= 0 then
    if index == 1 then
      SkillProxy.Instance:CallBalanceModeChooseMess(0)
    elseif index == 2 then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, 0, nil)
    elseif index == 3 then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, 0)
    end
  end
end

function PvpTalentContentPage:HandleMemorySkillCellClick(index)
  local equipedEffectId = EquipMemoryProxy.Instance:GetBalanceMemory(index)
  if equipedEffectId and equipedEffectId ~= 0 then
    local effectConfig = Game.ItemMemoryEffect and Game.ItemMemoryEffect[equipedEffectId]
    if effectConfig and effectConfig.level then
      local memoryId = effectConfig.level[3]
      if memoryId then
        local memoryConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
        if memoryConfig then
          local data = {
            id = memoryConfig.id,
            effectId = memoryConfig.EffectID,
            groupType = index,
            isMemory = true,
            isChoose = true,
            previewDesc = memoryConfig.PreviewDesc,
            waxDesc = memoryConfig.WaxDesc,
            level = memoryConfig.Level or 1
          }
          self:ShowCurEquipedBalanceModeSkill(self.memoryCurSkillCell_Icon[index], data)
        end
      end
    end
  end
end

function PvpTalentContentPage:HandleMemorySkillCellDoubleClick(index)
  local equipedEffectId = EquipMemoryProxy.Instance:GetBalanceMemory(index)
  if equipedEffectId and equipedEffectId ~= 0 then
    local EnumToTempPos = {
      [1] = 5,
      [2] = 2,
      [3] = 8,
      [4] = 1
    }
    local effect = {index = 2, effect_id = 0}
    ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    xdlog("装备记忆双击移除", index, EnumToTempPos[index])
  else
    xdlog("装备记忆双击", index, "当前槽位无数据")
  end
end

function PvpTalentContentPage:HandleMemoryUpgradeSkillCellClick(index)
  local equipedEffectId = EquipMemoryProxy.Instance:GetUpgradeMemory(index)
  if equipedEffectId and equipedEffectId ~= 0 then
    local effectConfig = Game.ItemMemoryEffect and Game.ItemMemoryEffect[equipedEffectId]
    if effectConfig and effectConfig.level then
      local memoryId = effectConfig.level[1]
      if memoryId then
        local memoryConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
        if memoryConfig then
          local data = {
            id = memoryConfig.id,
            effectId = memoryConfig.EffectID,
            groupType = index,
            isMemory = true,
            isUpgradeMemory = true,
            isChoose = true,
            previewDesc = memoryConfig.PreviewDesc,
            waxDesc = memoryConfig.WaxDesc,
            level = memoryConfig.Level or 1
          }
          self:ShowCurEquipedBalanceModeSkill(self.memoryUpgradeCurSkillCell_Icon[index], data)
        end
      end
    end
  end
end

function PvpTalentContentPage:HandleMemoryUpgradeSkillCellDoubleClick(index)
  local equipedEffectId = EquipMemoryProxy.Instance:GetUpgradeMemory(index)
  if equipedEffectId and equipedEffectId ~= 0 then
    local EnumToTempPos = {
      [1] = 5,
      [2] = 2,
      [3] = 8,
      [4] = 1
    }
    local effect = {index = 3, effect_id = 0}
    ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[index], effect)
    xdlog("升级记忆双击移除", index, EnumToTempPos[index])
  else
    xdlog("升级记忆双击", index, "当前槽位无数据")
  end
end

function PvpTalentContentPage:InitToggles()
  self.toggles = self:FindGO("Toggles")
  self.pwsSkillTog = self:FindGO("PwsSkillTog", self.toggles)
  self.pwsSkillTog_Label = self:FindGO("NameLabel", self.pwsSkillTog):GetComponent(UILabel)
  self.pwsSkillTog_Checkmark = self:FindGO("Sprite", self.pwsSkillTog)
  self.balanceModeTog = self:FindGO("BalanceModeTog", self.toggles)
  self.balanceModeTog_Label = self:FindGO("NameLabel", self.balanceModeTog):GetComponent(UILabel)
  self.balanceModeTog_Checkmark = self:FindGO("Sprite", self.balanceModeTog)
end

function PvpTalentContentPage:InitTalentsList()
  self.listTalents = ListCtrl.new(self:FindGO("pvpTalentGrid", self.objContents), PvpTalentCell, "PvpTalentCell")
  self.listTalents:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.Click_PreviewPeak, self.ShowPeakTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end

function PvpTalentContentPage:AddViewListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.RefreshSkills)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(ServiceEvent.MessCCmdBalanceModeChooseMessCCmd, self.HandleBalanceSkillUpdate)
  self:AddListenEvt(ServiceEvent.ItemBalanceModeMemoryUpdateItemCmd, self.HandleBalanceMemoryUpdate)
  self:AddListenEvt(DragDropEvent.StartDrag, self.HandleBalanceSkillDragStart)
  self:AddListenEvt(DragDropEvent.EndDrag, self.HandleBalanceSkillDragEnd)
end

function PvpTalentContentPage:AddButtonEvts()
  self:AddClickEvent(self.objBtnCancel, function()
    self:ResetTalents()
    self:SetEditMode(false)
  end)
  self:AddClickEvent(self.objBtnConfirm, function()
    if Game.MapManager:IsTeamPwsFire() then
      MsgManager.ShowMsgByID(25932)
      return
    end
    local skillIDs = ReusableTable.CreateArray()
    local cells = self.listTalents:GetCells()
    local skills, id
    for i = 1, #cells do
      skills = cells[i].listTalents:GetCells()
      for j = 1, #skills do
        id = skills[j]:TryGetSimulateSkillID()
        if id then
          skillIDs[#skillIDs + 1] = id
        end
      end
    end
    self.container:CheckNeedShowOverFlow(skillIDs)
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_TALENT, skillIDs)
    ReusableTable.DestroyAndClearArray(skillIDs)
  end)
  self:AddClickEvent(self.objBtnReset, function()
    if self.usablePoints >= self.maxPoints then
      return
    end
    if Game.MapManager:IsTeamPwsFire() then
      MsgManager.ShowMsgByID(25932)
      return
    end
    MsgManager.ConfirmMsgByID(25933, function()
      ServiceSkillProxy.Instance:CallResetTalentSkillCmd()
    end, nil)
  end)
  self:AddClickEvent(self.pwsSkillTog, function()
    self.objPwsContent:SetActive(true)
    self.objPwsTop:SetActive(true)
    self.objBalanceModeContent:SetActive(false)
    self.objBalanceModeTop:SetActive(false)
    self.container:SwitchBG(1)
    self.container:ActiveBottom(true)
    self.pwsSkillTog_Label.alpha = 1
    self.pwsSkillTog_Checkmark:SetActive(true)
    self.balanceModeTog_Label.alpha = 0.4
    self.balanceModeTog_Checkmark:SetActive(false)
  end)
  self:AddClickEvent(self.balanceModeTog, function()
    self.objPwsContent:SetActive(false)
    self.objPwsTop:SetActive(false)
    self.objBalanceModeContent:SetActive(true)
    self.objBalanceModeTop:SetActive(true)
    self.container:SwitchBG(2)
    self.container:ActiveBottom(false)
    self.pwsSkillTog_Label.alpha = 0.4
    self.pwsSkillTog_Checkmark:SetActive(false)
    self.balanceModeTog_Label.alpha = 1
    self.balanceModeTog_Checkmark:SetActive(true)
    self.balanceTable:Reposition()
    self.balanceScollView:ResetPosition()
    self:RefreshSkills()
  end)
end

function PvpTalentContentPage:InitShow()
  local subTab = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.subtab or 1
  self.objPwsContent:SetActive(subTab == 1)
  self.objPwsTop:SetActive(subTab == 1)
  self.objBalanceModeContent:SetActive(subTab ~= 1)
  self.objBalanceModeTop:SetActive(subTab ~= 1)
  self.container:SwitchBG(subTab)
  self.pwsSkillTog_Label.alpha = subTab == 1 and 1 or 0.4
  self.pwsSkillTog_Checkmark:SetActive(subTab == 1)
  self.balanceModeTog_Label.alpha = subTab ~= 1 and 1 or 0.4
  self.balanceModeTog_Checkmark:SetActive(subTab ~= 1)
  self.container:SwitchBG(subTab)
  self.container:ActiveBottom(subTab == 1)
  for i = 1, 3 do
    self.balanceModeScrollView[i]:ResetPosition()
  end
  for i = 1, 4 do
    self.memoryScrollView[i]:ResetPosition()
    self.memoryUpgradeScrollView[i]:ResetPosition()
  end
end

function PvpTalentContentPage:OnEnter()
  PvpTalentContentPage.super.OnEnter(self)
  self.talentDatas = nil
  self.contentScroll:ResetPosition()
  self.contentScroll.panel.clipOffset = LuaGeometry.GetTempVector3()
  self.contentScroll.transform.localPosition = LuaGeometry.GetTempVector3()
  self:RefreshSkills()
  self:InitShow()
end

function PvpTalentContentPage:OnExit()
  self:ClearTalentDatas()
  PvpTalentContentPage.super.OnExit(self)
end

function PvpTalentContentPage:RefreshSkills()
  self:SetEditMode(false)
  self:SetTalentSkills()
  self:SetBalanceModeSkill(true)
  self:SetMemorySkill(true)
  self:SetMemoryUpgradeSkill(true)
  self:UpdateCurrentTalentSkillPoints()
end

function PvpTalentContentPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end

function PvpTalentContentPage:ShowPeakTipHandler(cell)
  self:_ShowTip(cell, PeakSkillPreviewTip, "PeakSkillPreviewTip")
end

function PvpTalentContentPage:ShowBalanceModeSkillTipHandler(cell)
  self:ShowCurEquipedBalanceModeSkill(cell.skillIcon, cell.data)
end

function PvpTalentContentPage:ShowCurEquipedBalanceModeSkill(obj, data)
  local camera = NGUITools.FindCameraForLayer(obj.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(obj.gameObject.transform.position)
    self.tipdata.data = data
    local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, obj.gameObject.transform, Space.World)
    TipsView.Me():ShowStickTip(BalanceModeSkillTip, self.tipdata, NGUIUtil.AnchorSide.Left, obj, 0 < x and {-200, -150} or {300, -150}, "SkillTip")
  end
end

function PvpTalentContentPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    self.tipdata.data = cell:GetSimulateSkillItemData()
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      if viewPos.x <= 0.5 then
        tmpPos[1], tmpPos[2], tmpPos[3] = self.contentPanel.width / 4, 0, 0
      else
        tmpPos[1], tmpPos[2], tmpPos[3] = -self.contentPanel.width / 4, 0, 0
      end
      tip.gameObject.transform.localPosition = tmpPos
    end
  end
end

function PvpTalentContentPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      
      if click then
        local cells = self.listTalents:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end

function PvpTalentContentPage:CheckIsClickCell(cells, clickedObj)
  local skills
  for i = 1, #cells do
    skills = cells[i].listTalents:GetCells()
    for j = 1, #skills do
      if skills[j]:IsClickMe(clickedObj) then
        return true
      end
    end
  end
  return false
end

function PvpTalentContentPage:SimulationUpgradeHandler(cell)
  if Game.MapManager:IsTeamPwsFire() then
    MsgManager.ShowMsgByID(25932)
    return
  end
  if self.usablePoints < 1 then
    MsgManager.ShowMsgByID(604)
    return
  end
  local curLayer = cell.layer
  local cells = self.listTalents:GetCells()
  local curLayerLevel = cells[curLayer]:GetLayerSimulateLevel()
  if curLayerLevel >= self.pwsConfig.LayerNeedPoint then
    MsgManager.ShowMsgByID(25936)
    return
  end
  if cell:TrySimulateUpgrade() then
    if cells[curLayer]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint then
      cells[curLayer]:SetLayerUpdateEnable(false)
      if curLayer < #cells then
        cells[curLayer + 1]:SetLayerEnable(true)
      end
    end
    self:SetEditMode(true)
    self.usablePoints = self.usablePoints - 1
    self:UpdateCurrentTalentSkillPoints()
    if self.usablePoints < 1 then
      for i = 1, #cells do
        cells[i]:SetLayerUpdateEnable(false)
      end
    end
  end
end

function PvpTalentContentPage:SimulationDowngradeHandler(cell)
  if Game.MapManager:IsTeamPwsFire() then
    MsgManager.ShowMsgByID(25932)
    return
  end
  local cells = self.listTalents:GetCells()
  local curLayer, maxLayer = cell.layer, #cells
  local curLayerLevel = cells[curLayer]:GetLayerSimulateLevel()
  if curLayer < maxLayer and curLayerLevel <= self.pwsConfig.LayerNeedPoint and cells[curLayer + 1]:GetLayerSimulateLevel() > 0 then
    MsgManager.ShowMsgByID(25934)
    return
  end
  if cell:TrySimulateDowngrade() then
    local haveChange = false
    local cells = self.listTalents:GetCells()
    local skills
    for i = 1, #cells do
      skills = cells[i].listTalents:GetCells()
      for j = 1, #skills do
        if skills[j]:IsChanged() then
          haveChange = true
          break
        end
      end
      if haveChange then
        break
      end
    end
    if cells[curLayer]:GetLayerSimulateLevel() < self.pwsConfig.LayerNeedPoint then
      cells[curLayer]:SetLayerUpdateEnable(true)
      if curLayer < maxLayer then
        cells[curLayer + 1]:SetLayerEnable(false)
      end
    end
    self.usablePoints = self.usablePoints + 1
    self:UpdateCurrentTalentSkillPoints()
    for i = 1, #cells do
      cells[i]:SetLayerUpdateEnable(true)
    end
    if not haveChange then
      self:SetEditMode(false)
    end
  end
end

function PvpTalentContentPage:SetTalentSkills()
  if not Table_TalentSkill then
    return
  end
  self:ClearTalentDatas()
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local learnedSkills = SkillProxy.Instance:GetPvpTalentSkillsData()
  self.maxPoints = Game.Myself.data.userdata:Get(UDEnum.TALENT_POINT) or 0
  self.usablePoints = self.maxPoints - (learnedSkills and learnedSkills.usedPoints or 0)
  self.talentDatas = ReusableTable.CreateTable()
  local isMyTalent = false
  local pvpTalentData
  for sortID, talent in pairs(Table_TalentSkill) do
    isMyTalent = talent.RequireProfession == nil
    if talent.RequireProfession then
      for i = 1, #talent.RequireProfession do
        if talent.RequireProfession[i] == myProfess then
          isMyTalent = true
          break
        end
      end
    end
    if isMyTalent then
      local layerTalentsData = self.talentDatas[talent.Layer]
      if not layerTalentsData then
        layerTalentsData = ReusableTable.CreateTable()
        layerTalentsData.layer = talent.Layer
        layerTalentsData.skills = ReusableTable.CreateArray()
        self.talentDatas[talent.Layer] = layerTalentsData
      end
      pvpTalentData = ReusableTable.CreateTable()
      pvpTalentData.layer = talent.Layer
      pvpTalentData.maxLevel = talent.MaxLevel
      if learnedSkills and learnedSkills.skills[sortID] then
        pvpTalentData.skill = learnedSkills.skills[sortID]
        pvpTalentData.level = pvpTalentData.skill.level
      else
        pvpTalentData.skill = SkillItemData.new(sortID * 1000 + 1, i, 0, myProfess, 0)
        pvpTalentData.skill:SetLearned(false)
        pvpTalentData.skill:SetActive(true)
        pvpTalentData.level = 0
      end
      layerTalentsData.skills[#layerTalentsData.skills + 1] = pvpTalentData
    end
  end
  for layer, talents in pairs(self.talentDatas) do
    table.sort(talents.skills, function(x, y)
      if not x then
        return true
      end
      if not y then
        return false
      end
      return x.skill.sortID < y.skill.sortID
    end)
  end
  self.listTalents:ResetDatas(self.talentDatas, true, false)
  local cells = self.listTalents:GetCells()
  if 1 < #cells then
    if 0 < self.usablePoints then
      cells[1]:SetLayerEnable(true)
      cells[1]:SetLayerUpdateEnable(true)
      for i = 2, #cells do
        cells[i]:SetLayerEnable(cells[i - 1]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint)
        cells[i]:SetLayerUpdateEnable(true)
      end
    else
      for i = 1, #cells do
        cells[i]:SetLayerDisableOperate()
      end
    end
  end
end

function PvpTalentContentPage:SetBalanceModeSkill(resetPos)
  local balanceSkillInfo = SkillProxy.Instance:GetBalanceModeChooseMess()
  local skillList = {}
  local atkEquip = GameConfig.BalanceMode and GameConfig.BalanceMode.EquipExtractionAtk or {}
  skillList[1] = {}
  for i = 1, #atkEquip do
    local tempSkill = {
      id = atkEquip[i],
      type = 1,
      isChoose = balanceSkillInfo[1] and balanceSkillInfo[1] == atkEquip[i] or false
    }
    table.insert(skillList[1], tempSkill)
  end
  local defEquip = GameConfig.BalanceMode and GameConfig.BalanceMode.EquipExtractionDef or {}
  skillList[2] = {}
  for i = 1, #defEquip do
    local tempSkill = {
      id = defEquip[i],
      type = 2,
      isChoose = balanceSkillInfo[2] and balanceSkillInfo[2] == defEquip[i] or false
    }
    table.insert(skillList[2], tempSkill)
  end
  local artifactEquip = GameConfig.BalanceMode and GameConfig.BalanceMode.PersonalArtifactCompose or {}
  skillList[3] = {}
  for i = 1, #artifactEquip do
    local tempSkill = {
      id = artifactEquip[i],
      isArtifact = 1,
      isChoose = balanceSkillInfo[3] and balanceSkillInfo[3] == artifactEquip[i] or false
    }
    table.insert(skillList[3], tempSkill)
  end
  for i = 1, 3 do
    if balanceSkillInfo[i] and balanceSkillInfo[i] ~= 0 then
      self.dragDrop[i].dragDropComponent.data = {
        type = i,
        id = balanceSkillInfo[i],
        itemdata = ItemData.new("DragItem", balanceSkillInfo[i])
      }
      self.dragDrop[i]:SetDragEnable(true)
      local itemInfo = Table_Item[balanceSkillInfo[i]]
      IconManager:SetItemIcon(itemInfo.Icon, self.curSkillCell_Icon[i])
      self.curSkillCell_Icon[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
      self.curSkillCell_Bg[i].color = LuaColor.White()
      self.curSkillCell_Empty[i]:SetActive(false)
    else
      self.dragDrop[i]:SetDragEnable(false)
      self.curSkillCell_Icon[i].spriteName = ""
      self.curSkillCell_Bg[i].color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      self.curSkillCell_Empty[i]:SetActive(true)
    end
    self.skillCtrl[i]:ResetDatas(skillList[i])
  end
  if resetPos then
    for i = 1, 3 do
      self.balanceModeScrollView[i]:ResetPosition()
    end
  end
end

function PvpTalentContentPage:SetMemorySkill(resetPos)
  local memorySkillList = {}
  for i = 1, 4 do
    memorySkillList[i] = {}
    local equipedEffectId = EquipMemoryProxy.Instance:GetBalanceMemory(i)
    local memoryIds = EquipMemoryProxy.GetSpecialEffectIdsByEnum(i)
    if memoryIds and 0 < #memoryIds then
      for j = 1, #memoryIds do
        local memoryId = memoryIds[j]
        local effectConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
        if effectConfig and effectConfig.Level and effectConfig.Level == 3 then
          local tempSkill = {
            id = memoryId,
            effectId = effectConfig.EffectID,
            previewDesc = effectConfig.PreviewDesc,
            waxDesc = effectConfig.WaxDesc,
            level = effectConfig.Level or 1,
            groupType = i,
            isChoose = equipedEffectId and equipedEffectId == effectConfig.EffectID or false,
            isMemory = true
          }
          table.insert(memorySkillList[i], tempSkill)
        end
      end
    else
      redlog("该种类不存在or没有投放")
    end
  end
  for i = 1, 4 do
    self.memorySkillCtrl[i]:ResetDatas(memorySkillList[i])
    local equipedEffectId = EquipMemoryProxy.Instance:GetBalanceMemory(i)
    if equipedEffectId and equipedEffectId ~= 0 then
      local memoryConfig
      local memoryIds = EquipMemoryProxy.GetSpecialEffectIdsByEnum(i)
      if memoryIds and 0 < #memoryIds then
        for j = 1, #memoryIds do
          local memoryId = memoryIds[j]
          local effectConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
          if effectConfig and effectConfig.EffectID == equipedEffectId then
            memoryConfig = effectConfig
            break
          end
        end
      end
      if memoryConfig then
        local itemID = EquipMemoryProxy.PosEnumItemID[i]
        local itemData = ItemData.new("DragItem", itemID)
        itemData.hideMemoryCorner = true
        if self.memoryDragDrop[i] then
          self.memoryDragDrop[i].dragDropComponent.data = {
            groupType = i,
            id = memoryConfig.id,
            effectId = memoryConfig.EffectID,
            itemdata = itemData,
            isMemory = true
          }
          self.memoryDragDrop[i]:SetDragEnable(true)
        end
        if self.memoryCurSkillCell_Icon[i] then
          local staticData = Table_Item[itemID]
          if staticData then
            IconManager:SetItemIcon(staticData and staticData.Icon, self.memoryCurSkillCell_Icon[i])
            self.memoryCurSkillCell_Icon[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
          end
        end
        if self.memoryCurSkillCell_Bg[i] then
          local staticData = Table_Item[itemID]
          if staticData then
            self:SetQualityBg(self.memoryCurSkillCell_Bg[i], staticData.Quality)
          end
        end
        if self.memoryCurSkillCell_Empty[i] then
          self.memoryCurSkillCell_Empty[i]:SetActive(false)
        end
      else
        if self.memoryDragDrop[i] then
          self.memoryDragDrop[i]:SetDragEnable(false)
        end
        if self.memoryCurSkillCell_Icon[i] then
          self.memoryCurSkillCell_Icon[i].spriteName = ""
        end
        if self.memoryCurSkillCell_Bg[i] then
          self.memoryCurSkillCell_Bg[i].color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
        end
        if self.memoryCurSkillCell_Empty[i] then
          self.memoryCurSkillCell_Empty[i]:SetActive(true)
        end
      end
    else
      if self.memoryDragDrop[i] then
        self.memoryDragDrop[i]:SetDragEnable(false)
      end
      if self.memoryCurSkillCell_Icon[i] then
        self.memoryCurSkillCell_Icon[i].spriteName = ""
      end
      if self.memoryCurSkillCell_Bg[i] then
        self.memoryCurSkillCell_Bg[i].color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      end
      if self.memoryCurSkillCell_Empty[i] then
        self.memoryCurSkillCell_Empty[i]:SetActive(true)
      end
    end
  end
  if resetPos then
    for i = 1, 4 do
      self.memoryScrollView[i]:ResetPosition()
    end
  end
end

function PvpTalentContentPage:SetMemoryUpgradeSkill(resetPos)
  local memoryUpgradeSkillList = {}
  for i = 1, 4 do
    memoryUpgradeSkillList[i] = {}
    local equipedEffectId = EquipMemoryProxy.Instance:GetUpgradeMemory(i)
    local memoryIds = EquipMemoryProxy.GetUpgradeSpecialEffectIdsByEnum(i)
    if memoryIds and 0 < #memoryIds then
      for j = 1, #memoryIds do
        local memoryId = memoryIds[j]
        local effectConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
        if effectConfig and effectConfig.Level and effectConfig.Level == 1 then
          local tempSkill = {
            id = memoryId,
            effectId = effectConfig.EffectID,
            previewDesc = effectConfig.PreviewDesc,
            waxDesc = effectConfig.WaxDesc,
            level = effectConfig.Level or 1,
            groupType = i,
            isChoose = equipedEffectId and equipedEffectId == effectConfig.EffectID or false,
            isMemory = true,
            isUpgradeMemory = true
          }
          table.insert(memoryUpgradeSkillList[i], tempSkill)
        end
      end
    else
      redlog("该升级记忆种类不存在or没有投放")
    end
  end
  for i = 1, 4 do
    self.memoryUpgradeSkillCtrl[i]:ResetDatas(memoryUpgradeSkillList[i])
    local equipedEffectId = EquipMemoryProxy.Instance:GetUpgradeMemory(i)
    if equipedEffectId and equipedEffectId ~= 0 then
      local memoryConfig
      local memoryIds = EquipMemoryProxy.GetUpgradeSpecialEffectIdsByEnum(i)
      if memoryIds and 0 < #memoryIds then
        for j = 1, #memoryIds do
          local memoryId = memoryIds[j]
          local effectConfig = Table_ItemMemoryEffect and Table_ItemMemoryEffect[memoryId]
          if effectConfig and effectConfig.EffectID == equipedEffectId then
            memoryConfig = effectConfig
            break
          end
        end
      end
      if memoryConfig then
        local itemID = EquipMemoryProxy.PosEnumUpgradeItemID[i]
        local itemData = ItemData.new("DragItem", itemID)
        itemData.hideMemoryCorner = true
        if self.memoryUpgradeDragDrop[i] then
          self.memoryUpgradeDragDrop[i].dragDropComponent.data = {
            groupType = i,
            id = memoryConfig.id,
            effectId = memoryConfig.EffectID,
            itemdata = itemData,
            isMemory = true,
            isUpgradeMemory = true
          }
          self.memoryUpgradeDragDrop[i]:SetDragEnable(true)
        end
        if self.memoryUpgradeCurSkillCell_Icon[i] then
          local staticData = Table_Item[itemID]
          if staticData then
            IconManager:SetItemIcon(staticData and staticData.Icon, self.memoryUpgradeCurSkillCell_Icon[i])
            self.memoryUpgradeCurSkillCell_Icon[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
          end
        end
        if self.memoryUpgradeCurSkillCell_Bg[i] then
          local staticData = Table_Item[itemID]
          if staticData then
            self:SetQualityBg(self.memoryUpgradeCurSkillCell_Bg[i], staticData.Quality)
          end
        end
        if self.memoryUpgradeCurSkillCell_Empty[i] then
          self.memoryUpgradeCurSkillCell_Empty[i]:SetActive(false)
        end
      else
        if self.memoryUpgradeDragDrop[i] then
          self.memoryUpgradeDragDrop[i]:SetDragEnable(false)
        end
        if self.memoryUpgradeCurSkillCell_Icon[i] then
          self.memoryUpgradeCurSkillCell_Icon[i].spriteName = ""
        end
        if self.memoryUpgradeCurSkillCell_Bg[i] then
          self.memoryUpgradeCurSkillCell_Bg[i].color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
        end
        if self.memoryUpgradeCurSkillCell_Empty[i] then
          self.memoryUpgradeCurSkillCell_Empty[i]:SetActive(true)
        end
      end
    else
      if self.memoryUpgradeDragDrop[i] then
        self.memoryUpgradeDragDrop[i]:SetDragEnable(false)
      end
      if self.memoryUpgradeCurSkillCell_Icon[i] then
        self.memoryUpgradeCurSkillCell_Icon[i].spriteName = ""
      end
      if self.memoryUpgradeCurSkillCell_Bg[i] then
        self.memoryUpgradeCurSkillCell_Bg[i].color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      end
      if self.memoryUpgradeCurSkillCell_Empty[i] then
        self.memoryUpgradeCurSkillCell_Empty[i]:SetActive(true)
      end
    end
  end
  if resetPos then
    for i = 1, 4 do
      self.memoryUpgradeScrollView[i]:ResetPosition()
    end
  end
end

function PvpTalentContentPage:ClearTalentDatas()
  if not self.talentDatas then
    return
  end
  for k, talent in pairs(self.talentDatas) do
    for i = 1, #talent.skills do
      ReusableTable.DestroyAndClearTable(talent.skills[i])
    end
    ReusableTable.DestroyAndClearArray(talent.skills)
    ReusableTable.DestroyAndClearTable(talent)
  end
  ReusableTable.DestroyAndClearTable(self.talentDatas)
  self.talentDatas = nil
end

function PvpTalentContentPage:UpdateCurrentTalentSkillPoints()
  self.labUsablePoints.text = string.format(ZhString.SkillView_Talent_UsablePoints, self.usablePoints, self.maxPoints)
end

function PvpTalentContentPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.objRightButtons)
    else
      self:Hide(self.objRightButtons)
    end
  end
end

function PvpTalentContentPage:ResetTalents()
  local talentData = SkillProxy.Instance:GetPvpTalentSkillsData()
  self.usablePoints = self.maxPoints - (talentData and talentData.usedPoints or 0)
  self:UpdateCurrentTalentSkillPoints()
  local updateEnable = self.usablePoints > 0
  local cells = self.listTalents:GetCells()
  if 0 < #cells then
    cells[1]:ResetLayer()
    cells[1]:SetLayerUpdateEnable(updateEnable)
    cells[1]:SetLayerEnable(true)
  end
  for i = 2, #cells do
    cells[i]:ResetLayer()
    cells[i]:SetLayerUpdateEnable(updateEnable)
    cells[i]:SetLayerEnable(cells[i - 1]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint)
  end
end

function PvpTalentContentPage:ConfirmEditMode(toDo, owner, param)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:ResetTalents()
      self:SetEditMode(false)
      toDo(owner, param)
    end)
  else
    toDo(owner, param)
  end
end

function PvpTalentContentPage:IsEditMode()
  return self.isEditMode
end

function PvpTalentContentPage:OnSwitch(val)
  self.gameObject:SetActive(val == true)
  self:InitShow()
end

function PvpTalentContentPage:HandleMyDataChange(note)
  local data = note.body
  if not data then
    return
  end
  local skillType = ProtoCommon_pb.EUSERDATATYPE_TALENT_SKILLPOINT
  for i = 1, #data do
    if data[i].type == skillType then
      self.maxPoints = Game.Myself.data.userdata:Get(UDEnum.TALENT_POINT) or 0
      self:UpdateCurrentTalentSkillPoints()
      break
    end
  end
end

function PvpTalentContentPage:OnDestroy()
  self.listTalents:Destroy()
  PvpTalentContentPage.super.OnDestroy(self)
end

function PvpTalentContentPage:HandleBalanceModelSkillDoubleClick(cell)
  local data = cell.data
  local id = cell.id
  xdlog("双击装备", id)
  local type = cell.type
  local isArtifact = cell.isArtifact
  if isArtifact then
    SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, id)
  elseif type == 1 then
    SkillProxy.Instance:CallBalanceModeChooseMess(id, nil, nil)
  elseif type == 2 then
    SkillProxy.Instance:CallBalanceModeChooseMess(nil, id, nil)
  end
end

function PvpTalentContentPage:HandleBalanceSkillUpdate()
  xdlog("服务器来数据了")
  self:SetBalanceModeSkill()
end

function PvpTalentContentPage:HandleBalanceMemoryUpdate()
  xdlog("火力全开记忆更新")
  self:SetMemorySkill()
  self:SetMemoryUpgradeSkill()
end

function PvpTalentContentPage:HandleBalanceSkillDragStart(note)
  local cellCtrl = note.body
  local data = cellCtrl and cellCtrl.data
  local type = cellCtrl.type
  if cellCtrl.isArtifact then
    type = 3
  end
  for i = 1, 3 do
    self.curSkillCell_HightLight[i]:SetActive(i == type)
  end
  for i = 1, 4 do
    local shouldHighlightMemory = false
    local shouldHighlightUpgrade = false
    if data and data.groupType and data.groupType == i then
      if data.isUpgradeMemory then
        shouldHighlightUpgrade = true
      elseif data.isMemory then
        shouldHighlightMemory = true
      end
    end
    self.memoryCurSkillCell_HightLight[i]:SetActive(shouldHighlightMemory)
    self.memoryUpgradeCurSkillCell_HightLight[i]:SetActive(shouldHighlightUpgrade)
  end
end

function PvpTalentContentPage:HandleBalanceSkillDragEnd(note)
  local cellCtrl = note.body
  for i = 1, 3 do
    self.curSkillCell_HightLight[i]:SetActive(false)
  end
  for i = 1, 4 do
    self.memoryCurSkillCell_HightLight[i]:SetActive(false)
    self.memoryUpgradeCurSkillCell_HightLight[i]:SetActive(false)
  end
end

function PvpTalentContentPage:ShowMemorySkillTipHandler(cell)
  xdlog("显示装备记忆技能提示", cell.data)
  self:ShowCurEquipedBalanceModeSkill(cell.skillIcon, cell.data)
end

function PvpTalentContentPage:HandleMemorySkillDoubleClick(cell)
  local data = cell.data
  local id = cell.id
  xdlog("装备记忆双击", id)
end

function PvpTalentContentPage:ShowMemoryUpgradeSkillTipHandler(cell)
  xdlog("显示升级记忆技能提示", cell.data)
  self:ShowCurEquipedBalanceModeSkill(cell.skillIcon, cell.data)
end

function PvpTalentContentPage:HandleMemoryUpgradeSkillDoubleClick(cell)
  local data = cell.data
  local id = cell.id
  xdlog("升级记忆双击", id)
end
