HighRefinePanel = class("HighRefinePanel", ContainerView)
autoImport("HRefineTypeCell")
autoImport("MaterialItemCell")
autoImport("HighRefinePropSelectCell")
autoImport("HighRefineAdditionPreviewCell")
local bsProxy, propNameConfig
local defaultToggleGroup, tempTable, asidePosX = 88, {}, -10000

function HighRefinePanel:Init()
  if not bsProxy then
    bsProxy = BlackSmithProxy.Instance
  end
  if not propNameConfig then
    propNameConfig = Game.Config_PropName
  end
  self:InitView()
  self:MapEvent()
end

function HighRefinePanel:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMaterials)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateEquip)
  self:AddListenEvt(ServiceEvent.ItemNtfHighRefineDataCmd, self.HandleHighRefineUpdate)
  self:AddListenEvt(ServiceEvent.ItemUpdateHighRefineDataCmd, self.HandleHighRefineLvUp)
  self:AddListenEvt(ServiceEvent.NUserHighRefineAttrUserCmd, self.UpdateLeftBord)
end

function HighRefinePanel:HandleHighRefineUpdate(note)
  self:ChooseRefineCall(nil, self.curLevelType)
end

local msgOffset = {0, 10}

function HighRefinePanel:HandleHighRefineLvUp()
  self:PlayUIEffect(EffectMap.UI.UltimateLvUp, self.effectContainer, true)
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.effectContainer.transform))
  MsgManager.ShowEightTypeMsgByIDTable(2652, {
    string.format("[%s] Lv+1", self.equipName.text)
  }, tempV3, msgOffset)
  local nextEffectData = bsProxy:GetHighRefineData(self.equipPos, self.curLevelType, bsProxy:GetPlayerHRefineLevel(self.equipPos, self.curLevelType))
  local nextEffectMap = bsProxy:get_SingleHRefineEffects_Map(nextEffectData, self.myclass)
  local addValue
  for ek, ev in pairs(nextEffectMap) do
    if ek ~= "Job" then
      addValue = ev
      break
    end
  end
  if addValue then
    MsgManager.ShowEightTypeMsgByIDTable(2653, {addValue}, tempV3, msgOffset)
  end
  self:ChooseRefineCall(nil, self.curLevelType)
end

function HighRefinePanel:InitView()
  self.bord = self.gameObject
  self.refineGrid = self:FindComponent("RefineGrid", UIGrid, self.bord)
  self.hRefineCtl = UIGridListCtrl.new(self.refineGrid, HRefineTypeCell, "HRefineTypeCell")
  self.hRefineCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTypeCell, self)
  self.centerScrollView = self:FindComponent("CenterScrollView", UIScrollView, self.bord)
  self.centerControl = EnlargeCenterCell_Control.new(self.centerScrollView, self.refineGrid, 0.8, self.refineGrid.cellWidth, 1)
  self.centerControl:SetCenterCall(self.ChooseRefineCall, self)
  local preGO = self:FindGO("PreButton", self.bord)
  self.centerControl:SetPreSymbol(preGO, true)
  local nextGO = self:FindGO("NextButton", self.bord)
  self.centerControl:SetNextSymbol(nextGO, true)
  self.equipName = self:FindComponent("EquipName", UILabel, self.bord)
  self.unFullBord = self:FindGO("UnFull", self.bord)
  self.nowRefineLv = self:FindComponent("NowHRefineLv", UILabel, self.bord)
  self.nowEffect_Name = self:FindComponent("NowEffect", UILabel, self.bord)
  self.nowEffect_Value = self:FindComponent("Label", UILabel, self.nowEffect_Name.gameObject)
  self.nextRefineLv = self:FindComponent("NextRefineLv", UILabel, self.unFullBord)
  self.nextEffect_Name = self:FindComponent("NextEffect", UILabel, self.unFullBord)
  self.nextEffect_Value = self:FindComponent("Label", UILabel, self.nextEffect_Name.gameObject)
  self.matGrid = self:FindComponent("MatGrid", UIGrid, self.unFullBord)
  self.hRefineMatCtl = UIGridListCtrl.new(self.matGrid, MaterialItemCell, "MaterialItemCell")
  self.hRefineMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMat, self)
  self.maxTip = self:FindGO("MaxTip", self.bord)
  self.doButton = self:FindGO("DoButton", self.bord)
  self.doButton_Collider = self.doButton:GetComponent(BoxCollider)
  self.doButton_Sprite = self.doButton:GetComponent(UISprite)
  self.doButton_Label = self:FindComponent("Label", UILabel, self.doButton)
  self:AddClickEvent(self.doButton, function(go)
    self:DoHRefine()
  end)
  self.addEffectTip = self:FindComponent("RefineModelTip", UILabel, self.bord)
  self.posGrid = self:FindComponent("PosGrid", UIGrid, self.bord)
  self.hrefineEquipCtl = UIGridListCtrl.new(self.posGrid, HRefinePosTogCell, "HRefinePosTogCell")
  self.hrefineEquipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickHRefineEquipCell, self)
  self.effectContainer = self:FindGO("EffectContainer", self.bord)
  self.tipStick = self:FindComponent("TipStick", UIWidget, self.bord)
  self.leftBord = self:FindGO("LeftBord")
  local helpBtn = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(1100, nil, helpBtn)
  self.targetLabel = self:FindComponent("Label", UILabel, self:FindGO("Target"))
  self.additionLabel = self:FindComponent("Label", UILabel, self:FindGO("Addition"))
  self.allToggle1 = self:FindComponent("AllToggle1", UIToggle)
  self.allToggle2 = self:FindComponent("AllToggle2", UIToggle)
  self:AddToggleEvents()
  self.totalPhysicLabel = self:FindComponent("Label", UILabel, self:FindGO("TotalPhysic"))
  self.totalMagicLabel = self:FindComponent("Label", UILabel, self:FindGO("TotalMagic"))
  self.propCtl = WrapListCtrl.new(self:FindGO("PropContainer"), HighRefinePropSelectCell, "HighRefinePropSelectCell", nil, nil, nil, true)
  self:AddButtonEvent("AdditionPreviewBtn", function()
    self.leftBord.transform.localPosition = LuaGeometry.GetTempVector3(asidePosX)
    self.additionPreview:SetActive(true)
    self.additionPreview.transform.localPosition = LuaGeometry.GetTempVector3()
  end)
  self.additionPreview = self:FindGO("AdditionPreview")
  self:AddButtonEvent("APBackBtn", function()
    self.leftBord:SetActive(true)
    self.leftBord.transform.localPosition = LuaGeometry.GetTempVector3()
    self.additionPreview.transform.localPosition = LuaGeometry.GetTempVector3(asidePosX)
  end)
  local curWeaponCellGO = self:LoadPreferb("cell/HighRefineAdditionPreviewCell", self:FindGO("CWContainer"))
  self.curWeaponCell = HighRefineAdditionPreviewCell.new(curWeaponCellGO)
  local grid = self:FindComponent("Grid", UIGrid, self.additionPreview)
  self.curAccessoriesCtl = UIGridListCtrl.new(grid, HighRefineAdditionPreviewCell, "HighRefineAdditionPreviewCell")
  self.effectParent = self:FindGO("EffectBg")
  self:PlayUIEffect(EffectMap.UI.UltimateHighRefine, self.effectParent)
end

function HighRefinePanel:AddToggleEvents()
  EventDelegate.Add(self.allToggle1.onChange, function()
    if self.isUpdatingAllToggles then
      return
    end
    if not self.allToggle1.value then
      return
    end
    ServiceNUserProxy.Instance:CallHighRefineAttrUserCmd(self.equipPos, self.curLevelType, 1023)
  end)
  EventDelegate.Add(self.allToggle2.onChange, function()
    if self.isUpdatingAllToggles then
      return
    end
    if not self.allToggle2.value then
      return
    end
    ServiceNUserProxy.Instance:CallHighRefineAttrUserCmd(self.equipPos, self.curLevelType, 0)
  end)
end

function HighRefinePanel:UpdateHRefineEquipPosInfo(initChoose)
  local posDatas = {}
  local showPoses = BlackSmithProxy.Instance:GetHighRefinePoses() or {5}
  for i = 1, #showPoses do
    table.insert(posDatas, showPoses[i])
  end
  self.hrefineEquipCtl:ResetDatas(posDatas)
  if initChoose then
    self.hrefineEquipCells = self.hrefineEquipCtl:GetCells()
    self:ClickHRefineEquipCell(self.hrefineEquipCells[1])
  end
end

function HighRefinePanel:ClickTypeCell(cell)
  if not cell.levelType then
    return
  end
  self.centerControl:CenterOn(cell.levelType, nil, true)
end

function HighRefinePanel:ClickHRefineEquipCell(cell)
  self:SetChoosePos(cell.data)
end

function HighRefinePanel:ClickMat(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, self.tipStick, nil, {-190, 0})
end

function HighRefinePanel:SetChoosePos(pos)
  local cells = self.hrefineEquipCells
  for i = 1, #cells do
    cells[i]:SetTog(pos)
  end
  self.equipPos = pos
  self:UpdateChooseHRefineEquipInfo(pos)
  local _, showlvType = BlackSmithProxy.Instance:GetShowHRefineDatas(pos)
  if showlvType ~= 0 then
    self.centerControl:CenterOn(showlvType, true, true)
  end
end

function HighRefinePanel:DoHRefine()
  if self.nextHRefineData then
    if self.materialEnough ~= true then
      MsgManager.ShowMsgByIDTable(8)
      return
    end
    ServiceItemProxy.Instance:CallHighRefineCmd(self.nextHRefineData.id)
  end
end

function HighRefinePanel:UpdateChooseHRefineEquipInfo(equipPos)
  local datas = {}
  local maxType = bsProxy:GetMaxHRefineTypeOrLevel(self.equipPos)
  for i = 1, maxType do
    local showData = {}
    showData[1] = equipPos
    showData[2] = i
    table.insert(datas, showData)
  end
  self.hRefineCtl:ResetDatas(datas)
end

function HighRefinePanel:ChooseRefineCall(centerGO, centerIndex)
  self:UpdateChooseHRefineTypeInfo(centerIndex)
end

function HighRefinePanel:UpdateChooseHRefineTypeInfo(levelType)
  self.curLevelType = levelType
  local curlv = bsProxy:GetPlayerHRefineLevel(self.equipPos, levelType)
  local hRefineData = bsProxy:GetHighRefineData(self.equipPos, levelType, curlv)
  self.curHRefineData = hRefineData
  self.equipName.text = RoleEquipBagData.GetSiteNameZh(self.equipPos) .. ZhString["PackageHighRefine_Title_" .. levelType]
  self.maxHRefineLevel = bsProxy:GetMaxHRefineTypeOrLevel(self.equipPos, levelType)
  local nextEN_Str, nextEV_Str = "", ""
  if curlv == self.maxHRefineLevel then
    self.unFullBord:SetActive(false)
    self.maxTip:SetActive(true)
    self.nextHRefineData = nil
  else
    self.nextHRefineData = bsProxy:GetHighRefineData(self.equipPos, levelType, curlv + 1)
    self.maxTip:SetActive(false)
    self.unFullBord:SetActive(true)
    self.nextRefineLv.text = curlv + 1 .. "/" .. self.maxHRefineLevel
    local effectmap = bsProxy:Get_TotalHRefineEffect_Map(self.equipPos, levelType, curlv + 1, self.myclass)
    local proKey, proValue = next(effectmap)
    if proKey then
      nextEN_Str = self:GetPropertyName(proKey)
      local config = propNameConfig[proKey]
      if config == nil then
        helplog("Not Find Config", proKey)
      end
      if config.IsPercent == 1 then
        nextEV_Str = proValue * 100 .. "%"
      else
        nextEV_Str = proValue
      end
      if 0 < proValue then
        nextEV_Str = "+" .. nextEV_Str
      end
    else
      nextEN_Str = "No Effect"
      nextEV_Str = "+NULL"
    end
    self.nextEffect_Name.text = nextEN_Str .. ZhString.PackageHighRefine_colon
    self.nextEffect_Value.text = nextEV_Str
    self.addEffectTip.text = string.format(ZhString.PackageHighRefine_AddEffectTip2, self.nextHRefineData.RefineLv, RoleEquipBagData.GetSiteNameZh(self.equipPos), nextEN_Str)
    self:UpdateMaterials()
    self:ActiveDoButton(self.nextHRefineData ~= nil)
  end
  self.nowRefineLv.text = curlv .. "/" .. self.maxHRefineLevel
  local nowEN_Str, nowEV_Str = "", ""
  local fakeGet = curlv == 0
  if fakeGet then
    curlv = 1
  end
  local effectmap = bsProxy:Get_TotalHRefineEffect_Map(self.equipPos, levelType, curlv, self.myclass)
  local proKey, proValue = next(effectmap)
  if proKey then
    if fakeGet then
      proValue = 0
    end
    nowEN_Str = self:GetPropertyName(proKey)
    local config = propNameConfig[proKey]
    if config.IsPercent == 1 then
      nowEV_Str = proValue * 100 .. "%"
    else
      nowEV_Str = proValue
    end
    if 0 <= proValue then
      nowEV_Str = "+" .. nowEV_Str
    end
  else
    nowEN_Str = nextEN_Str
    nowEV_Str = "+0"
  end
  self.nowEffect_Name.text = nowEN_Str .. ZhString.PackageHighRefine_colon
  self.nowEffect_Value.text = nowEV_Str
  self:UpdateLeftBord()
end

function HighRefinePanel:UpdateMaterials()
  if self.nextHRefineData == nil then
    return
  end
  self.materialEnough = true
  local cost = self.nextHRefineData.Cost
  local matDatas = {}
  local bagProxy = BagProxy.Instance
  for i = 1, #cost do
    local matData = ItemData.new("Mat", cost[i][1])
    matData.num = bagProxy:GetItemNumByStaticID(cost[i][1])
    matData.neednum = cost[i][2]
    table.insert(matDatas, matData)
    if matData.neednum > matData.num then
      self.materialEnough = false
    end
  end
  self.hRefineMatCtl:ResetDatas(matDatas)
  local cells = self.hRefineMatCtl:GetCells()
  for i = 1, #cells do
    cells[i]:ActiveClickTip(false)
  end
end

function HighRefinePanel:UpdateLeftBord()
  self.targetLabel.text = self.equipName.text
  local curlv = bsProxy:GetPlayerHRefineLevel(self.equipPos, self.curLevelType)
  local curEffectMap = bsProxy:Get_TotalHRefineEffect_Map(self.equipPos, self.curLevelType, curlv, self.myclass)
  local key, curProValue = next(curEffectMap)
  local maxEffectMap = bsProxy:Get_TotalHRefineEffect_Map(self.equipPos, self.curLevelType, self.maxHRefineLevel, self.myclass)
  local proKey, maxProValue = next(maxEffectMap)
  self.additionLabel.text = string.format("%s/%s", curProValue or 0, maxProValue or 0)
  self.propCtl:ResetDatas(bsProxy:GetHighRefineData(self.equipPos, self.curLevelType))
  local refineSum, mRefineSum, selection, val = 0, 0
  local cells = self.propCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetToggleGroup(defaultToggleGroup - i)
    if cells[i].isEnabled then
      selection = cells[i]:GetSelection()
      val = cells[i].value
      if selection == BlackSmithProxy.HRefinePropValueMap.Refine then
        refineSum = refineSum + val
      elseif selection == BlackSmithProxy.HRefinePropValueMap.MRefine then
        mRefineSum = mRefineSum + val
      end
    end
  end
  self.totalPhysicLabel.text = string.format("+%s", refineSum)
  self.totalMagicLabel.text = string.format("+%s", mRefineSum)
  self:UpdateAllToggles()
  self:UpdateEquip()
end

function HighRefinePanel:UpdateAllToggles()
  self.allToggle1.group = 0
  self.allToggle2.group = 0
  local isAllRefine, isAllMRefine, enabledCellCount, selection = true, true, 0
  local cells = self.propCtl:GetCells()
  for i = 1, #cells do
    if cells[i].isEnabled then
      enabledCellCount = enabledCellCount + 1
      selection = cells[i]:GetSelection()
      isAllRefine = isAllRefine and selection == BlackSmithProxy.HRefinePropValueMap.Refine
      isAllMRefine = isAllMRefine and selection == BlackSmithProxy.HRefinePropValueMap.MRefine
    end
  end
  self.isUpdatingAllToggles = true
  self.allToggle1.value = 0 < enabledCellCount and isAllRefine
  self.allToggle2.value = 0 < enabledCellCount and isAllMRefine
  self.allToggle1.group = defaultToggleGroup
  self.allToggle2.group = defaultToggleGroup
  TimeTickManager.Me():CreateOnceDelayTick(400, function(owner, deltaTime)
    self.isUpdatingAllToggles = nil
  end, self)
end

function HighRefinePanel:UpdateEquip()
  local roleEquip = BagProxy.Instance.roleEquip
  self.curWeaponCell:SetData(roleEquip:GetWeapon())
  TableUtility.TableClear(tempTable)
  local accessoriesSite = GameConfig.EquipType[6].site
  for _, site in pairs(accessoriesSite) do
    table.insert(tempTable, roleEquip:GetEquipBySite(site))
  end
  self.curAccessoriesCtl:ResetDatas(tempTable)
end

function HighRefinePanel:ActiveDoButton(b)
  if b then
    self.doButton_Sprite.color = ColorUtil.NGUIWhite
    self.doButton_Collider.enabled = true
    self.doButton_Label.effectColor = ColorUtil.ButtonLabelOrange
  else
    self.doButton_Sprite.color = ColorUtil.NGUIShaderGray
    self.doButton_Collider.enabled = false
    self.doButton_Label.effectColor = ColorUtil.NGUIGray
  end
end

function HighRefinePanel:OnEnter()
  HighRefinePanel.super.OnEnter(self)
  self.myclass = MyselfProxy.Instance:GetMyProfession()
  self:UpdateHRefineEquipPosInfo(true)
  self:UpdateEquip()
  local npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcInfo then
    local rootTrans = npcInfo.assetRole.completeTransform
    self:CameraFocusOnNpc(rootTrans)
  else
    self:CameraRotateToMe()
  end
end

function HighRefinePanel:OnExit()
  HighRefinePanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CameraReset()
end

function HighRefinePanel:GetPropertyName(proKey)
  if BlackSmithProxy.HRefinePropValueMap[proKey] then
    return ZhString.PackageHighRefine_RefineMRefineEffect
  else
    return GameConfig.EquipEffect[proKey] or "Cannot Find " .. proKey
  end
end
