autoImport("BokiMapAttrCombineCell")
autoImport("SkillTip")
autoImport("FourthSkillCell")
autoImport("AutoShortCutSkillDragCell")
BokiSkillPage = class("BokiSkillPage", SubView)
local SUB_VIEW_PATH = ResourcePathHelper.UIView("BokiSkillPage")
local MAX_GRID_X, MAX_GRID_Y
local TEXTURE = {
  "fb_bg_skill01",
  "fb_bg_skill02"
}

function BokiSkillPage:Init()
  MAX_GRID_X = GameConfig.SkillFourth and GameConfig.SkillFourth.MaxGridX or 12
  MAX_GRID_Y = GameConfig.SkillFourth and GameConfig.SkillFourth.MaxGridY or 6
  self.gameObject = self:LoadPreferb_ByFullPath(SUB_VIEW_PATH, self.container.skillObj, true)
  self.skillDatas = {}
  self.skillCellMap = {}
  self.tipdata = {}
  self.usedMatItemMap = {}
  self:FindObjs()
  self:InitListCtl()
  self:AddButtonEvts()
end

function BokiSkillPage:FindObjs()
  self.objRoot = self:FindGO("ContentRoot")
  self.objRightButtons = self:FindGO("RightBtns", self.objRoot)
  self.objBtnConfirm = self:FindGO("SkillConfirmBtn", self.objRightButtons)
  self.objBtnCancel = self:FindGO("SkillCancelBtn", self.objRightButtons)
  self.objBtnSize = self:FindGO("SizeBtn")
  self.sprBtnSizeIcon = self:FindComponent("Icon", UIMultiSprite, self.objBtnSize)
  self.objContents = self:FindGO("Contents", self.objRoot)
  self.objSkillContainer = self:FindGO("SkillContainer", self.objContents)
  self.contentPanel = self:FindComponent("SkillContent", UIPanel, self.objContents)
  self.contentScroll = self.contentPanel.gameObject:GetComponent(ScrollViewWithProgress)
  self.emptyTip = self:FindGO("EmptyTip", self.objContents)
  self.buttomLeft = self:FindGO("BottomLeft")
  self.autoShortCutGrid = self:FindComponent("AutoShortCutGrid", UIGrid, self.buttomLeft)
  self.mapAttrOpenBtn = self:FindGO("MapAttrBtn")
  self.mapAttrCloseBtn = self:FindGO("MapAttrCloseBtn")
  self.mapAttrPage = self:FindGO("MapAttrPage")
  self.tab = self:FindComponent("MapAttrContainer", UITable)
  self.mapAttrWraper = UIGridListCtrl.new(self.tab, BokiMapAttrCombineCell, "BokiMapAttrCombineCell")
  self.mapAttrWraper:AddEventListener(BokiMapAttrCombineCell.ClickTag, self.HandleClickTag, self)
  self.tex1 = self:FindComponent("Tex1", UITexture)
  self.tex2 = self:FindComponent("Tex2", UITexture)
  self:PlayUIEffect(EffectMap.UI.Eff_SkillView_Fragment, self:FindGO("effRoot_Fragment"))
  PictureManager.Instance:SetUI(TEXTURE[1], self.tex1)
  PictureManager.Instance:SetUI(TEXTURE[2], self.tex2)
end

function BokiSkillPage:HandleClickTag()
  self.tab:Reposition()
end

function BokiSkillPage:InitListCtl()
  self.skillCtl = ListCtrl.new(self.objSkillContainer, FourthSkillCell, "FourthSkillCell")
  self.skillCtl:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.skillCtl:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.skillCtl:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
  self.shortCutList = UIGridListCtrl.new(self.autoShortCutGrid, AutoShortCutSkillDragCell, "ShortCutSkillDragCell")
  self.shortCutList:AddEventListener(DragDropEvent.SwapObj, self.SwapSkill, self)
  self.shortCutList:AddEventListener(DragDropEvent.DropEmpty, self.TakeOffSkill, self)
end

function BokiSkillPage:UpdateMapAttrInfo(data)
  if data then
    self.mapAttrWraper:ResetDatas(data)
  end
end

function BokiSkillPage:SwapSkill(obj)
  local source = obj.data.source
  local target = obj.data.target
  if self:IsEditMode() then
    MsgManager.ShowMsgByIDTable(608)
    return
  end
  if nil ~= source and source.data.staticData and source.data.staticData.AutoCondition_Groove == 1 or nil ~= target and target.data.staticData and target.data.staticData.AutoCondition_Groove == 1 then
    MsgManager.ShowMsgByIDTable(1950)
    return
  end
  local setData = {
    pos = target.data.pos,
    id = source.data.id
  }
  redlog("BokiSkillPage SwapSkill pos | id | ", setData.pos, setData.id)
  ServiceScenePetProxy.Instance:CallBoKiSkillInUseSetPetCmd(setData)
end

function BokiSkillPage:TakeOffSkill(obj)
  local data = obj.data
  if nil ~= data then
    local setData = {
      pos = data.data.pos,
      id = 0
    }
    redlog("BokiSkillPage TakeOffSkill pos | id | ", setData.pos, setData.id)
    ServiceScenePetProxy.Instance:CallBoKiSkillInUseSetPetCmd(setData)
  end
end

function BokiSkillPage:AddButtonEvts()
  self:AddClickEvent(self.objBtnCancel, function()
    self:ClearSimulate()
  end)
  self:AddClickEvent(self.objBtnConfirm, function()
    self:OnObjBtnConfirm()
  end)
  self:AddClickEvent(self.objBtnSize, function()
    self:ChangeShowScale(not self.isShowSmall)
  end)
  self:AddClickEvent(self.mapAttrOpenBtn, function()
    if not self.mapAttrPage.activeSelf then
      self.mapAttrPage:SetActive(true)
      local mapAttr = BokiProxy.Instance:GetMapAttrSkills()
      self:UpdateMapAttrInfo(mapAttr)
    end
  end)
  self:AddClickEvent(self.mapAttrCloseBtn, function()
    self.mapAttrPage:SetActive(false)
  end)
end

function BokiSkillPage:OnObjBtnConfirm()
  local skillIDs = ReusableTable.CreateArray()
  local cells = self.skillCtl:GetCells()
  local id
  for i = 1, #cells do
    id = cells[i]:TryGetSimulateSkillID()
    if id then
      local bokiSkill = {
        family_id = math.floor(id / 1000),
        level = id % 100
      }
      skillIDs[#skillIDs + 1] = bokiSkill
    end
  end
  ServiceScenePetProxy.Instance:CallBoKiSkillLevelUpPetCmd(skillIDs)
  ReusableTable.DestroyAndClearArray(skillIDs)
end

function BokiSkillPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end

function BokiSkillPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    self.tipdata.data = cell:GetSimulateSkillItemData()
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      tip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.contentPanel.width / 4 * (viewPos.x <= 0.5 and 1 or -1), 0, 0)
      local itemCostCells = tip:GetItemCostCells()
      if itemCostCells then
        for i = 1, #itemCostCells do
          itemCostCells[i]:ResetUsableItemNum(self:GetUsableItemNumByID(itemCostCells[i].id, itemCostCells[i].currentItemNum))
        end
      end
    end
  end
end

function BokiSkillPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      
      if not click then
        return false
      end
      local cells = self.skillCtl:GetCells()
      for i = 1, #cells do
        if cells[i]:IsClickMe(click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end

function BokiSkillPage:SimulationUpgradeHandler(cell)
  local nextSkillStaticData = cell:GetNextSkillStaticData()
  local costItem = nextSkillStaticData and nextSkillStaticData.ItemCost
  if costItem then
    for index, costData in pairs(costItem) do
      if self:GetUsableItemNumByID(costData.id) < costData.count then
        return
      end
    end
  end
  if not cell:TrySimulateUpgrade() then
    return
  end
  self:SetEditMode(true)
  if costItem then
    for index, costData in pairs(costItem) do
      self.usedMatItemMap[costData.id] = (self.usedMatItemMap[costData.id] or 0) + costData.count
    end
  end
  self:RefreshSkillsStatus()
end

function BokiSkillPage:SimulationDowngradeHandler(cell)
  local curSortID = cell.data.sortID
  local staticData = cell:GetSimulateStaticData()
  if not staticData then
    LogUtility.Error("Cannot Find Skill StaticData!")
    return
  end
  local skillCells = self.skillCtl:GetCells()
  local singleSkillCell
  for i = 1, #skillCells do
    singleSkillCell = skillCells[i]
    if singleSkillCell.data.requiredSkillID == staticData.id and singleSkillCell:GetSimulateLevel() > 0 then
      MsgManager.ShowMsgByID(607, singleSkillCell.data.staticData.NameZh)
      return
    end
  end
  if not cell:TrySimulateDowngrade() then
    return
  end
  local haveChange = false
  for i = 1, #skillCells do
    if skillCells[i]:IsChanged() then
      haveChange = true
      break
    end
  end
  local costItem = staticData.ItemCost
  if costItem then
    for index, costData in pairs(costItem) do
      self.usedMatItemMap[costData.id] = math.max((self.usedMatItemMap[costData.id] or 0) - costData.count, 0)
    end
  end
  if not haveChange then
    self:SetEditMode(false)
  end
  self:RefreshSkillsStatus()
end

function BokiSkillPage:SetSkills(needLayout)
  TableUtility.TableClear(self.usedMatItemMap)
  TableUtility.ArrayClear(self.skillDatas)
  local skills = BokiProxy.Instance:GetSkills()
  TableUtil.InsertArray(self.skillDatas, skills)
  self.skillCtl:ResetDatas(self.skillDatas, true, false)
  if needLayout then
    self:LayOutSkills()
  end
  self.emptyTip:SetActive(#self.skillDatas == 0)
  self:RefreshSkillsStatus()
  self:RefreshInUseSkills()
end

function BokiSkillPage:LayOutSkills()
  TableUtility.TableClear(self.skillCellMap)
  self.contentPanel:ResetAndUpdateAnchors()
  local cellWidth = self.contentPanel.width / MAX_GRID_X
  local cellHeight = self.contentPanel.height / MAX_GRID_Y
  local cells = self.skillCtl:GetCells()
  local cell, x, y
  local requiringCells = ReusableTable.CreateArray()
  for i = 1, #cells do
    cell = cells[i]
    self.skillCellMap[cell.data.sortID] = cell
    if cell.data.requiredSkillID then
      requiringCells[#requiringCells + 1] = cell
    end
    cell:RemoveLink()
    cell:ResetLink()
    x, y = cell:GetGridXY()
    cell:SetLocalPosition(cellWidth * x, -y * cellHeight)
  end
  local requiredSkill
  for i = 1, #requiringCells do
    cell = requiringCells[i]
    requiredSkill = self.skillCellMap[math.floor(cell.data.requiredSkillID / 1000)]
    if requiredSkill then
      requiredSkill:DrawLink(cell)
    end
  end
  ReusableTable.DestroyAndClearArray(requiringCells)
  self.contentScroll:ResetPosition()
end

function BokiSkillPage:RefreshSkillsStatus()
  local cells = self.skillCtl:GetCells()
  local singleSkillCell, singleSkillData, requiredSkillCell, hasMatItem, fitRequiredSkill
  for i = 1, #cells do
    singleSkillCell = cells[i]
    singleSkillData = singleSkillCell.data
    requiredSkillCell = nil
    hasMatItem, fitRequiredSkill = true, true
    if singleSkillData.requiredSkillID then
      requiredSkillCell = self.skillCellMap[math.floor(singleSkillData.requiredSkillID / 1000)]
      fitRequiredSkill = requiredSkillCell and requiredSkillCell.simulateID >= singleSkillData.requiredSkillID and requiredSkillCell.simulateLevel > 0
    end
    local nextSkillStaticData = singleSkillCell:GetNextSkillStaticData()
    local costItem = nextSkillStaticData and nextSkillStaticData.ItemCost
    if costItem then
      for index, costData in pairs(costItem) do
        if self:GetUsableItemNumByID(costData.id) < costData.count then
          hasMatItem = false
          break
        end
      end
    end
    singleSkillCell:SetCellEnable(fitRequiredSkill and hasMatItem, true)
    singleSkillCell:ShowBreakButton(false)
    if requiredSkillCell then
      requiredSkillCell:LinkUnlock(singleSkillData.sortID, fitRequiredSkill)
    end
  end
end

function BokiSkillPage:GetUsableItemNumByID(id, baseNum)
  if not id then
    return 0
  end
  return math.max((baseNum or HappyShopProxy.Instance:GetItemNum(id)) - (self.usedMatItemMap[id] or 0), 0)
end

function BokiSkillPage:ChangeShowScale(isSmall, immediate)
  if self.isShowSmall == isSmall then
    return
  end
  self.isShowSmall = isSmall
  self.sprBtnSizeIcon.CurrentState = self.isShowSmall and 0 or 1
  local scale = self.isShowSmall and 0.5 or 1
  local tarVecScale = LuaGeometry.GetTempVector3(scale, scale, 1)
  if immediate then
    self.objSkillContainer.transform.localScale = tarVecScale
    self.contentScroll:ResetPosition()
  else
    TweenScale.Begin(self.objSkillContainer, 0.2, tarVecScale)
    TimeTickManager.Me():CreateOnceDelayTick(210, function(owner, deltaTime)
      self.contentScroll:ResetPosition()
    end, self)
  end
end

function BokiSkillPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.objBtnConfirm)
      self:Show(self.objBtnCancel)
    else
      self:Hide(self.objBtnConfirm)
      self:Hide(self.objBtnCancel)
    end
  end
end

function BokiSkillPage:HandleSkillUpdate()
  self:ClearSimulate(false)
  self:RefreshInUseSkills()
end

function BokiSkillPage:HandleUpdateBoKiSkillInUse()
  self:RefreshInUseSkills()
end

function BokiSkillPage:RefreshInUseSkills()
  local inUseskills = BokiProxy.Instance:GetAutoSkills()
  self.shortCutList:ResetDatas(inUseskills)
end

function BokiSkillPage:ClearSimulate(needLayout)
  TableUtility.TableClear(self.usedMatItemMap)
  self:SetEditMode(false)
  self:SetSkills(needLayout)
end

function BokiSkillPage:ConfirmEditMode(toDo, owner, param)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:ClearSimulate()
      toDo(owner, param)
    end)
  else
    toDo(owner, param)
  end
end

function BokiSkillPage:IsEditMode()
  return self.isEditMode
end

function BokiSkillPage:Switch()
  if not self.inited then
    self:ClearSimulate(true)
    self.contentScroll:ResetPosition()
    self.inited = true
  end
  self.mapAttrPage:SetActive(false)
  self:ChangeShowScale(true, true)
  self:RefreshInUseSkills()
  local menuid = GameConfig.BoKiConfig.menuid
  local unlock = nil ~= menuid and FunctionUnLockFunc.Me():CheckCanOpen(menuid)
  self.buttomLeft:SetActive(not unlock)
  local pos = unlock and LuaGeometry.GetTempVector3(-30, -280, 0) or LuaGeometry.GetTempVector3(-12, -57, 0)
  self.objBtnSize.transform.localPosition = pos
end

function BokiSkillPage:OnExit()
  BokiSkillPage.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  local tip = TipsView.Me().currentTip
  if tip and tip.SetCheckClick then
    tip:SetCheckClick(nil)
  end
  SkillTip.SetForbidFunc()
  PictureManager.Instance:UnLoadUI(TEXTURE[1], self.tex1)
  PictureManager.Instance:UnLoadUI(TEXTURE[2], self.tex2)
end

function BokiSkillPage:OnDestroy()
  self.skillCtl:Destroy()
  self.shortCutList:Destroy()
  BokiSkillPage.super.OnDestroy(self)
end
