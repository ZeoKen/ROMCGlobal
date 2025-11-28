autoImport("SubView")
autoImport("SkillTip")
autoImport("PeakSkillPreviewTip")
autoImport("SkillCell")
autoImport("MasterSkillCell")
SkillContentPage = class("SkillContentPage", SkillBaseContentPage)
local tmpPos = LuaVector3.Zero()
local TimeOut = 10000
local MasterSkillBgName = "skill_master_bottom"

function SkillContentPage:Init()
  self.gameObject = self:FindGO("SkillContentPage", self:FindGO("SkillPages"))
  self.tipdata = {}
  self.cellHeight = 0
  self.cellWidth = 0
  self.hasProfessSkill = true
  self:FindObjs()
  self:InitCommonSkill()
  self:InitProfessSkill()
  self:InitMasterSkill()
  self:InitInheritSkills()
  self:AddViewListener()
  self:RegisterGuide()
end

function SkillContentPage:OnEnter()
  SkillContentPage.super.OnEnter(self)
  self.professDatas = nil
  self.proContentScroll:ResetPosition()
  self.proContentScroll.panel.clipOffset = LuaGeometry.GetTempVector2()
  self.proContentScroll.transform.localPosition = LuaGeometry.GetTempVector3()
  self.professesSkillCenterPos = {}
  self:SetEditMode(false)
  FunctionSkillSimulate.Me():CancelSimulate()
  self:SetCommonSkills()
  if self.hasProfessSkill then
    self:SetProfessSkills(true)
  end
  self:RefreshPoints()
  self:TrySimulate()
  local profess = SkillProxy.Instance:GetMyProfession()
  self:SetScrollToProfess(profess)
  self.proContentPanel:ResetAndUpdateAnchors()
  if ISNoviceServerType then
    PictureManager.Instance:SetMasterSkillTexture(MasterSkillBgName, self.masterSkillBg)
    self:UpdateMasterSkillEquipState()
  end
end

function SkillContentPage:AddViewListener()
  self:AddListenEvt(FunctionSkillSimulate.SimulateSkillPointChange, self.RefreshPointsAndUpdateCurrent)
  self:AddListenEvt(FunctionSkillSimulate.HasNoModifiedSkills, self.NoModifiedHandler)
  self:AddListenEvt(SkillEvent.SkillUpdate, self.RefreshSkills)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
  self:AddListenEvt(SkillRecommendEvent.SelectSolution, self.SimulatePreset)
  self:AddListenEvt(SkillRecommendEvent.ResetPreset, self.ResetPreset)
  self:AddListenEvt(GuideEvent.TargetGuideSuccess, self.ResetGuideView)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkill, self.RefreshSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkillEquip, self.UpdateMasterSkillEquipState)
  self:AddListenEvt(ServiceEvent.SkillUpdateInheritSkillCmd, self.RefreshSkills)
end

function SkillContentPage:ResetGuideView(note)
  local guideObj, guideID = note.body and note.body[1], note.body and note.body[2]
  if not guideObj or not guideID then
    return
  end
  redlog("ResetGuideView", guideObj, guideID)
  local cells = self.commonList:GetCells()
  local guideCell
  for i = 1, #cells do
    if cells[i]:IsMatchGuide(guideID, guideObj) then
      guideCell = cells[i]
      break
    end
  end
  if guideCell then
    self.comContentUSV:ResetPosition()
    local ox, _, _ = LuaGameObject.GetLocalPositionGO(self.comContentGO)
    local x, _, _ = LuaGameObject.InverseTransformPointByTransform(self.comContentGO.transform, guideCell.gameObject.transform, Space.World)
    self.comContentUSV:MoveRelative(LuaVector3(-(ox + x), 0, 0))
    self.comContentUSV:RestrictWithinBounds(true)
  end
end

function SkillContentPage:FindObjs()
  self.scrollAreaMines = self:FindGO("ScrollArea")
  self.contentMines = self:FindGO("Contents")
  self.bottomrightMines = self:FindGO("RightBtns")
  self.confirmBtn = self:FindGO("ConfirmBtn"):GetComponent(UIButton)
  self.confirmBtnSp = self:FindGO("ConfirmBtnSp")
  self.cancelBtn = self:FindGO("CancelBtn"):GetComponent(UIButton)
  self.commonScrollArea = self:FindGO("CommonArea")
  self.professScrollArea = self:FindGO("ProfessArea")
  self.proContentPanel = self:FindGO("ProfessContent"):GetComponent(UIPanel)
  self.proContentScroll = self:FindGO("ProfessContent"):GetComponent(ScrollViewWithProgress)
  self.comContentGO = self:FindGO("CommonContent")
  self.comContentPanel = self.comContentGO:GetComponent(UIPanel)
  self.comContentUSV = self.comContentGO:GetComponent(UIScrollView)
  self.commonGrid = self:FindGO("CommonGrid"):GetComponent(UIGrid)
  self.professGrid = self:FindGO("ProfessGrid")
  self.skillCellPlaceHolder = self:FindGO("SkillCellPlaceHolder")
  self.professBtnGrid = self:FindGO("ProfessionGrid"):GetComponent(UIGrid)
  self.professBgGrid = self:FindGO("ProfessBgGrid"):GetComponent(UITable)
  self.sperate = self:FindGO("Sperate")
  self.emptyTip = self:FindGO("EmptyTip")
  self.comContentPanel:ResetAndUpdateAnchors()
  self.proContentPanel:ResetAndUpdateAnchors()
  self.cellHeight = math.min(self.comContentPanel.height / 5, self.proContentPanel.height / 5) - 3
  self.cellWidth = 80
  self.professBtnGrid.cellHeight = self.cellHeight
  self.commonGrid.cellHeight = self.cellHeight
  self.commonSkillGO = self:FindGO("CommonSkills")
  self.commonSkillGO.transform.localPosition = Vector3(0, self.cellHeight + self.comContentPanel.baseClipRegion.y, 0)
  self:AddClickEvent(self.cancelBtn.gameObject, function()
    self:CancelSimulate()
  end)
  self:AddClickEvent(self.confirmBtn.gameObject, function()
    local skillIDs = FunctionSkillSimulate.Me():GetModifiedSkills()
    if #skillIDs == 0 then
      self:CancelSimulate()
      return
    end
    self.container:CheckNeedShowOverFlow(skillIDs)
    local skillType = SceneSkill_pb.ELEVELUPTYPE_MT
    for i = 1, #skillIDs do
      local skillId = skillIDs[i]
      if SimulateSkillProxy.Instance:IsMasterSkill(skillId) then
        skillType = SceneSkill_pb.ELEVELUPTYPE_MASTER
        break
      end
    end
    if skillType == SceneSkill_pb.ELEVELUPTYPE_MASTER then
      local totalCost = FunctionSkillSimulate.Me().masterSkillTotalCost
      local myZeny = MyselfProxy.Instance:GetROB()
      if totalCost > myZeny then
        MsgManager.ShowMsgByID(1)
        return
      end
    end
    ServiceSkillProxy.Instance:CallLevelupSkill(skillType, skillIDs)
    self.container:SetMaskColliderOn(true)
    self.waiting = true
    if not self.timeTick then
      self.timeTick = TimeTickManager.Me():CreateOnceDelayTick(TimeOut, function()
        if self.waiting then
          self:RefreshSkills()
        end
      end, self, 1)
    end
  end)
  
  function self.proContentScroll.onProgressStateChange(progress, state)
    self:ScrollStateChange(progress, state)
  end
  
  self.masterSkillsGO = self:FindGO("MasterSkills")
  self.masterSkillBg = self:FindComponent("MasterSkillBg", UITexture, self.masterSkillsGO)
  self.masterSkillSelectGOs = {}
  for i = 1, 3 do
    self.masterSkillSelectGOs[i] = self:FindGO("Select" .. i, self.masterSkillsGO)
  end
  self.masterSkillActiveBtns = {}
  for i = 1, 3 do
    self.masterSkillActiveBtns[i] = self:FindGO("Btn" .. i, self.masterSkillsGO)
    self:AddClickEvent(self.masterSkillActiveBtns[i], function()
      self:OnMasterSkillActiveBtnClick(i)
    end)
  end
  self.masterGrid = self:FindGO("MasterGrid")
  self.masterSkillCost = self:FindGO("MasterSkillCost")
  self.masterSkillCostIcon = self:FindComponent("Icon", UISprite, self.masterSkillCost)
  self.masterSkillCostLabel = self:FindComponent("Cost", UILabel, self.masterSkillCost)
  IconManager:SetItemIconById(100, self.masterSkillCostIcon)
  local helpBtn = self:FindGO("HelpBtn", self.masterSkillsGO)
  self:RegistShowGeneralHelpByHelpID(32628, helpBtn)
  self.masterSkillsGO:SetActive(false)
  self.inheritSkillGO = self:FindGO("InheritSkills")
  self.inheritGrid = self:FindComponent("InheritGrid", UIGrid, self.inheritSkillGO)
  self.inheritGrid.cellHeight = self.cellHeight
  self.inheritSperate = self:FindGO("InheritSperate")
  self.inheritSkillGO.transform.localPosition = Vector3(0, self.cellHeight + self.comContentPanel.baseClipRegion.y, 0)
  self.inheritSkillGotoBtn = self:FindGO("GotoBtn", self.inheritSkillGO)
  self:AddClickEvent(self.inheritSkillGotoBtn, function()
    self:OnInheritSkillGotoBtnClick()
  end)
end

function SkillContentPage:OnSwitch(val)
  self.container:ShowDefaultProfessionInfo(val)
  self.gameObject:SetActive(val == true)
  self.bottomrightMines:SetActive((val and self.isEditMode) == true)
end

function SkillContentPage:RegisterGuide()
  self:AddOrRemoveGuideId(self.confirmBtn.gameObject, 30)
end

function SkillContentPage:InitCommonSkill()
  self.commonList = ListCtrl.new(self.commonGrid, AdventureSkillCell, "SkillCell")
  self.commonList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
end

function SkillContentPage:InitProfessSkill()
  self.professList = ListCtrl.new(self.professGrid, SkillCell, "SkillCell")
  self.professList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.professList:AddEventListener(SkillCell.Click_PreviewPeak, self.ShowPeakTipHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end

function SkillContentPage:InitMasterSkill()
  self.masterSkillList = ListCtrl.new(self.masterGrid, MasterSkillCell, "MasterSkillCell")
  self.masterSkillList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.masterSkillList:AddEventListener(MasterSkillCell.SimulationUpgrade, self.MasterSkillSimulationUpgradeHandler, self)
  self.masterSkillList:AddEventListener(MasterSkillCell.SimulationDowngrade, self.MasterSkillSimulationDowngradeHandler, self)
end

function SkillContentPage:InitInheritSkills()
  self.inheritSkillList = ListCtrl.new(self.inheritGrid, AdventureSkillCell, "SkillCell")
  self.inheritSkillList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
end

function SkillContentPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end

function SkillContentPage:ShowPeakTipHandler(cell)
  self:_ShowTip(cell, PeakSkillPreviewTip, "PeakSkillPreviewTip")
end

function SkillContentPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    local data = cell.data
    if self.isEditMode then
      data = SimulateSkillProxy.Instance:GetSimulateSkillItemData(data.sortID)
    end
    self.tipdata.data = data
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      if viewPos.x <= 0.5 then
        tmpPos[1], tmpPos[2], tmpPos[3] = self.comContentPanel.width / 4, 0, 0
      else
        tmpPos[1], tmpPos[2], tmpPos[3] = -self.comContentPanel.width / 4, 0, 0
      end
      tip.gameObject.transform.localPosition = tmpPos
    end
  end
end

function SkillContentPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      
      if click then
        local cells = self.commonList:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
        cells = self.professList:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end

function SkillContentPage:CheckIsClickCell(cells, clickedObj)
  for i = 1, #cells do
    if cells[i]:IsClickMe(clickedObj) then
      return true
    end
  end
  return false
end

function SkillContentPage:ClickProfessBtn(cell)
end

function SkillContentPage:SetScrollToProfess(profess)
  local index
  local datas = self.professDatas
  if datas then
    local jobLv = MyselfProxy.Instance:JobLevel()
    for i = 1, #datas do
      if profess == datas[i].data.profession then
        index = i
        if jobLv - 160 < 60 then
          break
        end
      end
    end
  end
  if index then
    self:ScrollToProfess(index, false)
  end
end

function SkillContentPage:ScrollToProfess(index, spring)
  if GameConfig.SpecialGuide_Skill_QuestId ~= nil and #GameConfig.SpecialGuide_Skill_QuestId > 0 then
    local questData
    for _, v in ipairs(GameConfig.SpecialGuide_Skill_QuestId) do
      questData = FunctionGuide.Me():checkHasGuide(v)
      if questData then
        break
      end
    end
    if questData ~= nil then
      local guideId = questData.params.guideID
      if guideId ~= nil then
        local tb = Table_GuideID[guideId]
        if tb ~= nil and tb.SpecialID ~= nil then
          index = tb.SpecialID
        end
      end
    end
  end
  local sv = self.proContentScroll
  local data = self.professesSkillCenterPos[index]
  local offset = data.pos
  if not sv.canMoveHorizontally then
    offset.x = self.proContentPanel.cachedTransform.localPosition.x
  end
  if not sv.canMoveVertically then
    offset.y = self.proContentPanel.cachedTransform.localPosition.y
  end
  if spring then
    SpringPanel.Begin(self.proContentPanel.cachedGameObject, offset, 10)
  else
    self.proContentScroll:MoveRelative(offset)
  end
end

function SkillContentPage:SimulationUpgradeHandler(cell)
  if FunctionSkillSimulate.Me():Upgrade(cell) then
    self:SetEditMode(true)
    self:RefreshPoints()
    self:UpdateCurrentProfessSkillPoints()
  end
end

function SkillContentPage:SimulationDowngradeHandler(cell)
  FunctionSkillSimulate.Me():Downgrade(cell)
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
end

function SkillContentPage:MasterSkillSimulationUpgradeHandler(cell)
  redlog("SkillContentPage:MasterSkillSimulationUpgradeHandler")
  if FunctionSkillSimulate.Me():MasterSkillUpgrade(cell) then
    self:SetEditMode(true)
    self:RefreshPoints()
    self:UpdateCurrentProfessSkillPoints()
    self:UpdateMasterSkillCost()
  end
end

function SkillContentPage:MasterSkillSimulationDowngradeHandler(cell)
  FunctionSkillSimulate.Me():MasterSkillDowngrade(cell)
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
  self:UpdateMasterSkillCost()
end

function SkillContentPage:NoModifiedHandler(note)
  self:SetEditMode(false)
end

function SkillContentPage:RefreshSkills(note)
  self:CancelSimulate()
  if self.currentScrollProfessData then
    self.container:UpdateTopByProfess(self.currentScrollProfessData.data.profession, self.currentScrollProfessData.data.isMaster)
  end
  self:SetCommonSkills()
  self.container:SetMaskColliderOn(false)
  self.waiting = nil
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end

function SkillContentPage:RefreshProfess(note)
end

function SkillContentPage:ConfirmEditMode(toDo, owner)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:CancelSimulate()
      toDo(owner)
    end)
  else
    toDo(owner)
  end
end

function SkillContentPage:IsEditMode()
  return self.isEditMode
end

function SkillContentPage:TrySimulate()
  if self.container.multiSaveId ~= nil then
    local cells = self.professList:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if cell then
        cell:ShowUpgrade(false)
        cell:SetDragEnable(false)
      end
    end
    local commoncells = self.commonList:GetCells()
    for i = 1, #commoncells do
      local cell = commoncells[i]
      if cell then
        cell:SetDragEnable(false)
      end
    end
    local masterSkillCells = self.masterSkillList:GetCells()
    for i = 1, #masterSkillCells do
      local cell = masterSkillCells[i]
      cell:ShowUpgrade(false)
      cell:SetDragEnable(false)
    end
    return
  end
  if not FunctionSkillSimulate.Me().isIsSimulating then
    local cells = {}
    TableUtil.InsertArray(cells, self.professList:GetCells())
    local masterSkillCells = self.masterSkillList:GetCells()
    for i = 1, #masterSkillCells do
      if masterSkillCells[i].data then
        cells[#cells + 1] = masterSkillCells[i]
      end
    end
    FunctionSkillSimulate.Me():StartSimulate(cells, self.professDatas, self:GetProfessSkillPoint(), self:GetMasterSkillPoint())
  end
end

function SkillContentPage:CancelSimulate()
  self:SetEditMode(false)
  FunctionSkillSimulate.Me():CancelSimulate()
  if self.hasProfessSkill then
    self:SetProfessSkills()
  end
  self:TrySimulate()
  self:RefreshPoints()
  FunctionSkillSimulate.Me():ClosePreset()
end

function SkillContentPage:ShowCommon()
  self.ShowingCommon = true
  self:Show(self.commonScrollArea)
  self:Show(self.comContentPanel.gameObject)
  self:Hide(self.professScrollArea)
  self:Hide(self.proContentPanel.gameObject)
  self:Hide(self.professBtnGrid.gameObject)
  self:SetEditMode(false)
  self.commonGrid:Reposition()
  if self.inheritSkillGO.activeSelf then
    local x = LuaGameObject.GetLocalPositionGO(self.inheritSkillGO)
    self.comContentUSV:MoveRelative(LuaVector3(-x, 0, 0))
    self.comContentUSV:RestrictWithinBounds(true)
  end
end

function SkillContentPage:ShowProfess()
  self.ShowingCommon = false
  self:Hide(self.commonScrollArea)
  self:Hide(self.comContentPanel.gameObject)
  self:Show(self.professScrollArea)
  self:Show(self.proContentPanel.gameObject)
  self:SetEditMode(false)
end

function SkillContentPage:SetCommonSkills()
  local professSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
  if professSkill then
    local filteredSkill, skill = {}
    for i = 1, #professSkill.skills do
      skill = professSkill.skills[i]
      if (not skill.source or TableUtility.ArrayFindIndex(SkillProxy.ForbidShowSkillSources_CommonList, skill.source) == 0) and not skill:IsHideSkill() then
        TableUtility.ArrayPushBack(filteredSkill, skill)
      end
    end
    local num = 0
    for i = 1, #filteredSkill do
      if not filteredSkill[i].shadow then
        num = num + 1
      end
    end
    self:SetInheritSkills()
    local pos = self.inheritSkillGO.transform.localPosition
    if num <= self.commonGrid.maxPerLine then
      pos.x = 0
    else
      num = math.floor((num - 1) / self.commonGrid.maxPerLine)
      pos.x = -num * self.commonGrid.cellWidth / 2
    end
    pos.x = pos.x - 80
    if self.inheritSkillGO.activeSelf then
      self.inheritSkillGO.transform.localPosition = pos
      pos.x = pos.x + self.inheritSperate.transform.localPosition.x + 50
    end
    self.commonSkillGO.transform.localPosition = pos
    self.commonList:ResetDatas(filteredSkill, nil, true)
    self.commonGrid.repositionNow = true
  end
end

function SkillContentPage:SetProfessSkills(needLayout)
  local skills = {}
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
  if professTree ~= nil then
    local professes = {}
    local p = professTree.transferRoot
    local ps
    local typeBranch = Table_Class[myProfess].TypeBranch
    local mydepth = professTree:GetProfessDataByClassID(myProfess).depth
    while p ~= nil do
      ps = SkillProxy.Instance:FindProfessSkill(p.id, true)
      professes[#professes + 1] = ps
      TableUtil.InsertArray(skills, ps.skills)
      if mydepth == 1 or p.depth >= 4 then
        break
      end
      p = p:GetNextByBranch(typeBranch)
    end
    self:SetMasterSkills(professes)
    self:SetProfessBtns(professes)
    self.professList:ResetDatas(skills, true, false)
    if needLayout then
      self:LayOutProfessSkills(professTree)
    end
    self:LayoutEmptyMasterSkill()
  else
    self.professList:ResetDatas(skills, true, false)
    self:TryClearSperate()
    self:SetSkillCellPlaceHolder(0, 0)
  end
  self.emptyTip:SetActive(#skills == 0)
  self.container:ShowProfessSkillPoints(professTree ~= nil)
end

function SkillContentPage:LayOutProfessSkills(professTree)
  professTree:InitSkillPath(SkillProxy.Instance:GetMyProfession())
  local cells = self.professList:GetCells()
  local firstCell, cell, x, y
  local minCell = {x = 1000, y = 1000}
  local config
  local sortMap = {}
  local requiringCells = {}
  local professDatas = {}
  local professData
  local professCount = 0
  local multiRequiringCells, fitAll = {}, true
  local requiredSkill, requiredSort
  for i = 1, #cells do
    cell = cells[i]
    sortMap[cell.data.sortID] = cell
    local requiredSkills = cell.data.requiredSkills
    if cell.data.requiredSkillID then
      requiringCells[#requiringCells + 1] = cell
    end
    if requiredSkills then
      for i = 1, #requiredSkills do
        multiRequiringCells[requiredSkills[i]] = cell
      end
    end
    cell:RemoveLink()
    cell:ResetLink()
    x, y = cell:GetGridXY()
    minCell.x = math.min(minCell.x, x)
    if x == minCell.x then
      minCell.y = math.min(minCell.y, y)
      if y == minCell.y then
        firstCell = cell
      end
    end
    LuaVector3.Better_Set(tmpPos, self:GetX(x), -(y - 3) * self.cellHeight, 0)
    cell.gameObject.transform.localPosition = tmpPos
    professData = professDatas[cell.data.profession]
    if professData == nil then
      professCount = professCount + 1
      professData = {
        minX = 10000,
        maxX = 0,
        id = cell.data.profession
      }
      professDatas[cell.data.profession] = professData
    end
    professData.minX = math.min(professData.minX, x)
    professData.maxX = math.max(professData.maxX, x)
  end
  for i = 1, #requiringCells do
    cell = requiringCells[i]
    requiredSort = math.floor(cell.data.requiredSkillID / 1000)
    requiredSkill = sortMap[requiredSort]
    if requiredSkill then
      local x, y = requiredSkill:GetGridXY()
      local path = professTree.paths[y][x]
      requiredSkill:DrawLink(cell, path.combine)
      if self.container.multiSaveId ~= nil then
        requiredSkill:LinkUnlock(cell.data.sortID, requiredSkill.data.id >= cell.data.requiredSkillID and requiredSkill.data.learned)
      end
    end
  end
  for requiredID, cell in pairs(multiRequiringCells) do
    requiredSort = math.floor(requiredID / 1000)
    requiredSkill = sortMap[requiredSort]
    if requiredSkill then
      local x, y = requiredSkill:GetGridXY()
      local path = professTree.paths[y][x]
      requiredSkill:DrawLink(cell, path.multiSkill, true)
      if self.container.multiSaveId ~= nil then
        requiredSkill:MultiLinkUnlock(cell.data.sortID, fitAll)
      end
    end
  end
  self:LayOutMasterSkills(professDatas)
  if professDatas.master then
    professCount = professCount + 1
    professData = professDatas.master
  end
  self:SetProgressScroll(professDatas, professData.maxX)
  self:TrySperate(professDatas, 1 < professCount)
  self:SetMasterSkillsPos()
  self:SetSkillCellPlaceHolder(self:GetX(professData.maxX + 4), 0)
end

function SkillContentPage:GetX(x)
  return x * self.cellWidth - self.comContentPanel.width / 2
end

function SkillContentPage:TrySperate(professDatas, needCreate)
  self:TryClearSperate()
  self.sperates = {}
  if needCreate then
    local xs = {}
    for k, v in pairs(professDatas) do
      xs[#xs + 1] = v.maxX
    end
    table.sort(xs)
    table.remove(xs, #xs)
    local height = self.comContentPanel.height - 30
    local centerY = self.professGrid.transform.localPosition.y
    for i = 1, #xs do
      local s = GameObject.Instantiate(self.sperate)
      s.transform:SetParent(self.sperate.transform.parent)
      s:SetActive(true)
      s.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      s.transform.localPosition = LuaGeometry.GetTempVector3(self:GetX(xs[i] + 3.64), centerY, 0)
      local sp = self:FindGO("SUp", s):GetComponent(UISprite)
      sp.height = height / 2
      sp = self:FindGO("SDown", s):GetComponent(UISprite)
      sp.height = height / 2
      self.sperates[#self.sperates + 1] = s
    end
  end
end

function SkillContentPage:TryClearSperate()
  if self.sperates then
    for i = #self.sperates, 1, -1 do
      GameObject.Destroy(self.sperates[i])
      self.sperates[i] = nil
    end
  end
end

function SkillContentPage:SetProgressScroll(gridXYs, max)
  local datas = self.professDatas
  local progress = 0
  local professData
  self.professesSkillCenterCell = {}
  local stateMax
  for i = 1, #datas do
    if datas[i].data.isMaster then
      professData = gridXYs.master
    else
      professData = gridXYs[datas[i].data.profession]
    end
    if professData ~= nil then
      local centerX = math.ceil((professData.maxX + professData.minX) / 2)
      local x = -centerX * self.cellWidth + self.comContentPanel.width / 2
      if 0 < x then
        x = x - professData.minX * self.cellWidth
      else
        x = x - 120
      end
      self.professesSkillCenterPos[#self.professesSkillCenterPos + 1] = {
        pos = Vector3(x, 0, 0),
        minX = professData.minX,
        maxX = professData.maxX
      }
      stateMax = professData.maxX / max
      self.proContentScroll:AddStateRange(i, progress, stateMax, false)
      progress = stateMax
    end
  end
  local state = self.proContentScroll.state
  self.proContentScroll:CheckState()
  if state == self.proContentScroll.state then
    self:ScrollStateChange(0, state)
  end
end

function SkillContentPage:ScrollStateChange(progress, state)
  if self.professDatas == nil then
    return
  end
  local cellData = self.professDatas[state]
  if cellData ~= self.currentScrollProfessData then
    self.currentScrollProfessData = cellData
  end
  if self.currentScrollProfessData then
    self:RefreshPoints()
    self.container:UpdateTopByProfess(self.currentScrollProfessData.data.profession, self.currentScrollProfessData.data.isMaster)
    self.masterSkillCost:SetActive(self.currentScrollProfessData.data.isMaster and FunctionSkillSimulate.Me():HasModifiedMasterSkill() and not FunctionSkillSimulate.Me().isPresetting or false)
    self.container:UpdateRecommendBtn(not self.currentScrollProfessData.data.isMaster)
  end
  self:UpdateCurrentProfessSkillPoints()
end

function SkillContentPage:UpdateCurrentProfessSkillPoints()
  if self.currentScrollProfessData then
    self.container:UpdateProfessSkillPoints(self.currentScrollProfessData.points, self.currentScrollProfessData.data.totalPoints)
  end
end

function SkillContentPage:SetProfessBtns(professes)
  if self.professDatas == nil then
    self.professDatas = {}
    for i = 1, #professes do
      self.professDatas[#self.professDatas + 1] = {
        data = professes[i],
        points = professes[i].points
      }
    end
  end
end

function SkillContentPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.bottomrightMines)
    else
      self:Hide(self.bottomrightMines)
      self:ResetProfessPoints()
    end
    if self.currentScrollProfessData then
      self.masterSkillCost:SetActive(self.currentScrollProfessData.data.isMaster and FunctionSkillSimulate.Me():HasModifiedMasterSkill() and not FunctionSkillSimulate.Me().isPresetting or false)
    end
  end
end

function SkillContentPage:ResetProfessPoints()
  if self.professDatas then
    local data
    for i = 1, #self.professDatas do
      data = self.professDatas[i]
      data.points = data.data.points
    end
    self:UpdateCurrentProfessSkillPoints()
  end
end

function SkillContentPage:RefreshPointsAndUpdateCurrent()
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
end

function SkillContentPage:RefreshPoints()
  local points
  if self.isEditMode then
    if self.currentScrollProfessData and self.currentScrollProfessData.data.isMaster then
      points = FunctionSkillSimulate.Me().masterSkillTotalPoints
    else
      points = FunctionSkillSimulate.Me().totalPoints
    end
  else
    points = self:GetSkillPoint()
  end
  self.container:UpdateSkillSimulatePoints(points)
  FunctionGuide.Me():skillPointCheck(points)
end

function SkillContentPage:OnExit()
  self:SetEditMode(false)
  FunctionSkillSimulate.Me():CancelSimulate()
  if ISNoviceServerType then
    PictureManager.Instance:UnloadMasterSkillTexture(MasterSkillBgName, self.masterSkillBg)
  end
  SkillContentPage.super.OnExit(self)
end

function SkillContentPage:GetSkillPoint()
  if self.currentScrollProfessData and self.currentScrollProfessData.data.isMaster then
    return self:GetMasterSkillPoint()
  else
    return self:GetProfessSkillPoint()
  end
end

function SkillContentPage:GetProfessSkillPoint()
  local multiSaveId = self.container.multiSaveId
  local classid = multiSaveId and SaveInfoProxy.Instance:GetProfession(multiSaveId, self.container.multiSaveType) or SkillProxy.Instance:GetMyProfession()
  local typeBranch = multiSaveId and SaveInfoProxy.Instance:GetProfessionTypeBranch(multiSaveId, self.container.multiSaveType) or MyselfProxy.Instance:GetMyProfessionTypeBranch()
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(classid)
  local mydepth = professTree and professTree:GetProfessDataByClassID(classid).depth or 0
  if 5 <= mydepth then
    local professDatas = SkillProxy.Instance:GetProfessDatasByDepth(classid, mydepth - 1)
    local thirdTotalUsedPoints = 0
    for _, profess in pairs(professDatas) do
      thirdTotalUsedPoints = thirdTotalUsedPoints + profess.points
    end
    local config = GameConfig.ExtraSkill
    local thirdTotalPoints = config.point[typeBranch] or config.defaultPoint
    return thirdTotalPoints - thirdTotalUsedPoints
  else
    return multiSaveId and SaveInfoProxy.Instance:GetUnusedSkillPoint(multiSaveId, self.container.multiSaveType) or Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT)
  end
end

function SkillContentPage:GetMasterSkillPoint()
  local multiSaveId = self.container.multiSaveId
  local point = 0
  local masterJobLevel = MyselfProxy.Instance:GetMasterJobLevel()
  if self.professDatas then
    for i = 1, #self.professDatas do
      if self.professDatas[i].data.isMaster then
        local usedPoint = self.professDatas[i].points
        point = masterJobLevel - usedPoint
        break
      end
    end
  end
  return multiSaveId and SaveInfoProxy.Instance:GetUnusedSkillPoint(multiSaveId, self.container.multiSaveType) or point
end

function SkillContentPage:HandleMyDataChange(note)
  local data = note.body
  if data ~= nil then
    local skillType = ProtoCommon_pb.EUSERDATATYPE_SKILL_POINT
    for i = 1, #data do
      if data[i].type == skillType then
        self:RefreshPoints()
      elseif data[i].type == ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL then
        self:RefreshSkills()
        self:UpdateMasterSkillEquipState()
      end
    end
  end
end

function SkillContentPage:OnDestroy()
  self.professList:Destroy()
  self.commonList:Destroy()
  self.masterSkillList:Destroy()
  self.inheritSkillList:Destroy()
  SkillContentPage.super.OnDestroy(self)
end

function SkillContentPage:SetSkillCellPlaceHolder(x, y)
  LuaVector3.Better_Set(tmpPos, x, y, 0)
  self.skillCellPlaceHolder.transform.localPosition = tmpPos
end

function SkillContentPage:SimulatePreset(note)
  redlog("SimulatePreset", note.body)
  local skillp = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) or 0
  if skillp <= 0 then
    return
  end
  local solutionid = note.body
  local key = "Solution_" .. solutionid
  local preset = Game.SkillRecommend[key] or {}
  local totalPoints = self:GetProfessSkillPoint()
  FunctionSkillSimulate.Me():StartPreset(self.professList:GetCells(), preset, totalPoints)
  self:SetEditMode(true)
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
end

function SkillContentPage:ResetPreset()
  self:CancelSimulate()
end

function SkillContentPage:SetMasterSkills(professes)
  if not ISNoviceServerType then
    return
  end
  local skills = {}
  local depth = ProfessionProxy.GetJobDepth()
  redlog("SkillContentPage:SetMasterSkills", SkillProxy.Instance:GetMyProfession(), depth)
  if 3 < depth then
    local masterProfessSkill = SkillProxy.Instance:GetMasterSkillProfessData()
    if masterProfessSkill then
      masterProfessSkill:UpdateMasterSkillPoints()
      masterProfessSkill:UpdateSkillActive()
      professes[#professes + 1] = masterProfessSkill
      TableUtil.InsertArray(skills, masterProfessSkill.skills)
      local pro = SkillProxy.Instance:GetMyProfession()
      local config = Table_Class[pro]
      if config then
        local groupNum = masterProfessSkill:GetSkillGroupNum()
        for i = 1, 3 - groupNum do
          skills[#skills + 1] = SkillItemData.Empty
        end
      end
    end
  end
  self.masterSkillList:ResetDatas(skills, true, false)
  self.masterSkillsGO:SetActive(0 < #skills)
end

function SkillContentPage:LayOutMasterSkills(professDatas)
  local sortMap = {}
  local requiringCells = {}
  local cells = self.masterSkillList:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data then
      sortMap[cell.data.sortID] = cell
      if cell.data.requiredSkillID then
        requiringCells[#requiringCells + 1] = cell
      end
      cell:RemoveLink()
      cell:ResetLink()
      local x, y = cell:GetGridXY()
      tmpPos:Set(self:GetX(x + 0.5), -(y - 3) * self.cellHeight, 0)
      cell.gameObject.transform.localPosition = tmpPos
      local professData = professDatas.master
      if professData == nil then
        professData = {
          minX = 10000,
          maxX = 0,
          id = "master"
        }
        professDatas.master = professData
      end
      professData.minX = math.min(professData.minX, x)
      professData.maxX = math.max(professData.maxX, x)
    end
  end
  for i = 1, #requiringCells do
    local cell = requiringCells[i]
    requiredSort = math.floor(cell.data.requiredSkillID / 1000)
    requiredSkill = sortMap[requiredSort]
    if requiredSkill then
      requiredSkill:DrawLink(cell)
    end
  end
end

function SkillContentPage:LayoutEmptyMasterSkill()
  local cells = self.masterSkillList:GetCells()
  local emptyCellY
  for i = 1, #cells do
    local cell = cells[i]
    if not cell.data then
      local x, y = cells[1]:GetGridXY()
      if not emptyCellY then
        local lastCell = cells[cell.indexInList - 1]
        if lastCell then
          _, y = lastCell:GetGridXY()
        end
        emptyCellY = y
      end
      emptyCellY = emptyCellY + 1
      tmpPos:Set(self:GetX(x + 0.5), -(emptyCellY - 3) * self.cellHeight, 0)
      cell.gameObject.transform.localPosition = tmpPos
    end
  end
end

function SkillContentPage:SetMasterSkillsPos()
  local cells = self.masterSkillList:GetCells()
  if #cells == 0 then
    return
  end
  if self.sperates then
    local lastSperate = self.sperates[#self.sperates]
    local _, y, z = LuaGameObject.GetLocalPositionGO(self.masterSkillBg.gameObject)
    local x = lastSperate.transform.localPosition.x + 50
    LuaGameObject.SetLocalPositionGO(self.masterSkillBg.gameObject, x, y, z)
  end
end

function SkillContentPage:UpdateMasterSkillCost()
  local totalCost = FunctionSkillSimulate.Me().masterSkillTotalCost
  local costStr = StringUtil.NumThousandFormat(totalCost)
  local myZeny = MyselfProxy.Instance:GetROB()
  self.masterSkillCostLabel.text = totalCost > myZeny and string.format(ZhString.MasterSkill_ZenyCost, costStr) or costStr
end

function SkillContentPage:UpdateMasterSkillEquipState()
  local equipMasterSkillFamilyId = SkillProxy.Instance:GetEquipMasterSkillFamilyId()
  local selectIndex = 0
  local cells = self.masterSkillList:GetCells()
  redlog("SkillContentPage:UpdateMasterSkillEquipState", tostring(equipMasterSkillFamilyId))
  if equipMasterSkillFamilyId then
    local masterSkillProfessData = SkillProxy.Instance:GetMasterSkillProfessData()
    selectIndex = masterSkillProfessData and masterSkillProfessData:GetEquipMasterSkillGroupIndex(equipMasterSkillFamilyId) or 0
    local cell = TableUtility.ArrayFindByPredicate(cells, function(v, args)
      return v.data and v.data.sortID == args
    end, equipMasterSkillFamilyId)
    if cell then
      local selectGo = self.masterSkillSelectGOs[selectIndex]
      if selectGo then
        local _, y = cell:GetGridXY()
        local x = LuaGameObject.GetLocalPositionGO(selectGo)
        tmpPos:Set(x, -(y - 3) * self.cellHeight, 0)
        selectGo.transform.localPosition = tmpPos
      end
    end
  end
  for i = 1, #self.masterSkillSelectGOs do
    self.masterSkillSelectGOs[i]:SetActive(i == selectIndex)
  end
  for i = 1, #self.masterSkillActiveBtns do
    local go = self.masterSkillActiveBtns[i]
    local familyId = self:GetMasterSkillFamilyIdByIndex(i)
    go:SetActive(not self.container.multiSaveId and familyId and 0 < selectIndex and i ~= selectIndex or false)
    if familyId then
      local cell = TableUtility.ArrayFindByPredicate(cells, function(v, args)
        return v.data and v.data.sortID == args
      end, familyId)
      if cell then
        local x = LuaGameObject.GetLocalPositionGO(go)
        local _, y = cell:GetGridXY()
        tmpPos:Set(x, -(y - 3) * self.cellHeight, 0)
        go.transform.localPosition = tmpPos
      end
    end
  end
  self:ResetProfessPoints()
end

function SkillContentPage:GetMasterSkillFamilyIdByIndex(index)
  local masterSkillProfessData = SkillProxy.Instance:GetMasterSkillProfessData()
  local ids = masterSkillProfessData and masterSkillProfessData:GetSkillGroupFamilyIdsByGroupIndex(index)
  return ids and ids[1]
end

function SkillContentPage:OnMasterSkillActiveBtnClick(index)
  local familyId = self:GetMasterSkillFamilyIdByIndex(index)
  if familyId then
    local skillId = familyId * 1000 + 1
    local config = Table_Skill[skillId]
    local skillName = config and config.NameZh or ""
    MsgManager.DontAgainConfirmMsgByID(43597, function()
      redlog("CallSwitchMasterSkill", familyId)
      ServiceSkillProxy.Instance:CallSwitchMasterSkill(familyId)
    end, nil, nil, skillName)
  end
end

function SkillContentPage:SetInheritSkills()
  local loadInheritSkills = InheritSkillProxy.Instance:GetLoadSkills()
  local count = #loadInheritSkills
  local menuUnlock = FunctionUnLockFunc.Me():CheckCanOpen(19390) or false
  self.inheritSkillGO:SetActive(menuUnlock)
  self.inheritSkillList:ResetDatas(loadInheritSkills)
  self.inheritGrid.repositionNow = true
  self.inheritSperate:SetActive(menuUnlock)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.inheritSperate)
  count = math.max(count, 1)
  if 0 < count then
    x = self.inheritGrid.transform.localPosition.x + ((count - 1) // 3 + 1) * self.inheritGrid.cellWidth
  else
    x = 0
  end
  LuaGameObject.SetLocalPositionGO(self.inheritSperate, x, y, z)
end

function SkillContentPage:OnInheritSkillGotoBtnClick()
  if not FunctionUnLockFunc.Me():CheckCanOpen(19390) then
    MsgManager.ShowMsgByID(43661)
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.InheritSkillView
  })
end
