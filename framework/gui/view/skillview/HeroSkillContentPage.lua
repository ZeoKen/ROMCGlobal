HeroSkillContentPage = class("HeroSkillContentPage", FourthSkillContentPage)

function HeroSkillContentPage:FindObjs()
  self.objBackGround = self:FindGO("HeroSkillBG")
  self.objBaseBG = self:FindGO("HeroSkillBaseBG", self.objBackGround)
  self.objMahoujin = self:FindGO("Mahoujin", self.objBackGround)
  self.mahoujinWidget = self.objMahoujin:GetComponent(UIWidget)
  self.texProfession = self:FindComponent("texProfession", UITexture, self.objMahoujin)
  self.sprHalo = self:FindComponent("Halo", UISprite, self.objMahoujin)
  self.gameObject = self:FindGO("HeroSkillContentPage", self:FindGO("SkillPages"))
  self.objRoot = self:FindGO("ContentRoot")
  self.objLeftTopInfo = self:FindGO("Left", self:FindGO("Up", self.objRoot))
  self.labProfessName = self:FindComponent("ProfessName", UILabel, self.objLeftTopInfo)
  self.sprProfessIcon = self:FindComponent("ProfessIcon", UISprite, self.objLeftTopInfo)
  self.sprProfessColor = self:FindComponent("ProfessionColor", UISprite, self.objLeftTopInfo)
  self.skillPoints = self:FindComponent("skillPoints", UILabel, self.objLeftTopInfo)
  self.jobLevel = self:FindComponent("jobLevel", UILabel, self.objLeftTopInfo)
  self.objRightButtons = self:FindGO("RightBtns", self.objRoot)
  self.objBtnConfirm = self:FindGO("FourthSkillConfirmBtn", self.objRightButtons)
  self.objBtnCancel = self:FindGO("FourthSkillCancelBtn", self.objRightButtons)
  self.objLeftButtons = self:FindGO("FourthSkill", self:FindGO("LeftBtns", self.objRoot))
  self.objSkillResetBtn = self:FindGO("FourthSkillResetBtn", self.objLeftButtons)
  self.objBtnSize = self:FindGO("FourthSkillSizeBtn", self.objLeftButtons)
  self.sprBtnSizeIcon = self:FindComponent("Icon", UIMultiSprite, self.objBtnSize)
  self.objScrollArea = self:FindGO("FourthSkillArea", self:FindGO("ScrollArea", self.objRoot))
  self.objContents = self:FindGO("Contents", self.objRoot)
  self.objSkillContainer = self:FindGO("FourthSkillContainer", self.objContents)
  self.contentPanel = self:FindComponent("FourthSkillContent", UIPanel, self.objContents)
  self.contentScroll = self.contentPanel.gameObject:GetComponent(ScrollViewWithProgress)
  self.emptyTip = self:FindGO("FourthSkillEmptyTip", self.objContents)
end

function HeroSkillContentPage:InitProfessSkill()
  self.professList = ListCtrl.new(self.objSkillContainer, FourthSkillCell, "FourthSkillCell")
  self.professList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end

function HeroSkillContentPage:OnEnter()
  FourthSkillContentPage.super.OnEnter(self)
  self.inited = false
  self:ChangeShowScale(true, true)
  self.effectFrag = self:PlayUIEffect(EffectMap.UI.Eff_SkillView_Fragment, self:FindGO("effRoot_Fragment", self.objMahoujin))
  self.effectFrag:RegisterWeakObserver(self)
  self.effectFrag:SetActive(false)
  self.isLockFunctions = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.allowedSkillTip
  if self.isLockFunctions then
    self.objSkillResetBtn:SetActive(false)
  else
    self.objSkillResetBtn:SetActive(true)
  end
end

function HeroSkillContentPage:OnExit()
  if self.curProTexName then
    PictureManager.Instance:UnLoadProfession(self.curProTexName, self.texProfession)
    self.curProTexName = nil
  end
  if self.effectFrag and self.effectFrag:Alive() then
    self.effectFrag:Destroy()
  end
  FourthSkillContentPage.super.OnExit(self)
end

function HeroSkillContentPage:AddViewListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.HandleSkillUpdate)
end

function HeroSkillContentPage:AddButtonEvts()
  self:AddClickEvent(self.objBtnCancel, function()
    self:ClearSimulate()
  end)
  self:AddClickEvent(self.objBtnConfirm, function()
    local skillIDs = ReusableTable.CreateArray()
    local cells = self.professList:GetCells()
    local id
    for i = 1, #cells do
      id = cells[i]:TryGetSimulateSkillID()
      if id then
        skillIDs[#skillIDs + 1] = id
      end
    end
    self.forbidMyDataChange = true
    self.container:CheckNeedShowOverFlow(skillIDs)
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_MT, skillIDs)
    ReusableTable.DestroyAndClearArray(skillIDs)
  end)
  self:AddClickEvent(self.objSkillResetBtn, function()
    self.container:DoResetSkill()
  end)
  self:AddClickEvent(self.objBtnSize, function()
    self:ChangeShowScale(not self.isShowSmall)
  end)
end

function HeroSkillContentPage:SetProfessSkills(needLayout)
  TableUtility.TableClear(self.skillDatas)
  local skillPoint = self:GetSkillPoint()
  self.simulateSkillPoint = skillPoint
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local staticData = Table_Class[myProfess]
  if staticData and ProfessionProxy.IsHero(myProfess) then
    IconManager:SetNewProfessionIcon(staticData.icon, self.sprProfessIcon)
    self.labProfessName.text = ProfessionProxy.GetProfessionName(myProfess, MyselfProxy.Instance:GetMySex())
    local config = GameConfig.SkillFourth and GameConfig.SkillFourth.ProfessTexID
    self.curProTexName = "profession_" .. (config and config[myProfess] or myProfess)
    PictureManager.Instance:SetProfession(self.curProTexName, self.texProfession)
    config = GameConfig.SkillFourth and GameConfig.SkillFourth.ProfessColor
    local configColor = config[myProfess]
    self.sprHalo.color = LuaGeometry.GetTempColorByHtml(configColor or "#C0EC29")
    self.sprProfessColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil("CareerIconBg" .. staticData.Type)
    local myJobLevel = self:GetJobLevel()
    self.jobLevel.text = "Lv." .. myJobLevel
    self:SetSkillPoint(self.simulateSkillPoint)
    local ps = SkillProxy.Instance:FindProfessSkill(myProfess, true)
    TableUtil.InsertArray(self.skillDatas, ps.skills)
    local commonSkills = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
    if commonSkills then
      for i = 1, #commonSkills.skills do
        local skill = commonSkills.skills[i]
        local skillFamilyId = math.floor(skill.id / 1000)
        if skillFamilyId == staticData.FeatureSkill then
          self.skillDatas[#self.skillDatas + 1] = skill
        end
      end
    end
    self.professList:ResetDatas(self.skillDatas, true, false)
    if needLayout then
      self:LayOutProfessSkills()
    end
  else
    self.professList:ResetDatas(self.skillDatas, true, false)
  end
  self.emptyTip:SetActive(#self.skillDatas == 0)
  self:RefreshSkillsStatus()
  local cells = self.professList:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:ShowBreakButton(false)
  end
end

function HeroSkillContentPage:SetSkillPoint(skillPoint)
  self.skillPoints.text = string.format(ZhString.SkillView_HeroSkillPointText, skillPoint)
end

function HeroSkillContentPage:GetJobLevel()
  local multiSaveId = self.container.multiSaveId
  local jobLevel
  if multiSaveId then
    jobLevel = SaveInfoProxy.Instance:GetJobLevel(multiSaveId, self.container.multiSaveType)
  else
    jobLevel = MyselfProxy.Instance:JobLevel()
  end
  return jobLevel
end

function HeroSkillContentPage:GetSkillPoint()
  local multiSaveId = self.container.multiSaveId
  if multiSaveId ~= nil then
    local point = SaveInfoProxy.Instance:GetUnusedSkillPoint(multiSaveId, self.container.multiSaveType)
    if point ~= nil then
      return point
    end
  end
  return Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT)
end

function HeroSkillContentPage:OnSwitch(val)
  if val and not self.inited then
    self:ClearSimulate(true)
  end
  self.objRoot:SetActive(val == true)
  self.objBaseBG:SetActive(val == true)
  if self.effectFrag then
    self.effectFrag:SetActive(val == true)
  end
  if val then
    self.mahoujinWidget.alpha = 1
    if not self.inited then
      self.contentScroll:ResetPosition()
      self.inited = true
    end
  else
    self.mahoujinWidget.alpha = 0
  end
end

function HeroSkillContentPage:SimulationUpgradeHandler(cell)
  local nextSkillStaticData = cell:GetNextSkillStaticData()
  local jobLevel = self:GetJobLevel()
  if not cell:IsFitNextJobLevel(jobLevel) then
    return
  end
  if not cell:TrySimulateUpgrade() then
    return
  end
  self:SetEditMode(true)
  self.simulateSkillPoint = math.max(self.simulateSkillPoint - 1, 0)
  self:RefreshSkillsStatus()
end

function HeroSkillContentPage:SimulationDowngradeHandler(cell)
  local curSortID = cell.data.sortID
  local staticData = cell:GetSimulateStaticData()
  if not staticData then
    LogUtility.Error("Cannot Find Skill StaticData!")
    return
  end
  local skillCells = self.professList:GetCells()
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
  if not haveChange then
    self:SetEditMode(false)
  end
  self.simulateSkillPoint = math.min(self.simulateSkillPoint + 1, self:GetSkillPoint())
  self:RefreshSkillsStatus()
end

function HeroSkillContentPage:RefreshSkillsStatus()
  local myJobLevel = self:GetJobLevel()
  local cells = self.professList:GetCells()
  local singleSkillCell, singleSkillData, requiredSkillCell, fitJob, fitRequiredSkill, hasSkillPoint
  for i = 1, #cells do
    singleSkillCell = cells[i]
    singleSkillData = singleSkillCell.data
    fitJob = singleSkillCell:IsFitNextJobLevel(myJobLevel)
    requiredSkillCell = nil
    fitRequiredSkill = true
    hasSkillPoint = true
    if singleSkillData.requiredSkillID then
      requiredSkillCell = self.skillCellMap[math.floor(singleSkillData.requiredSkillID / 1000)]
      fitRequiredSkill = requiredSkillCell and requiredSkillCell.simulateID and requiredSkillCell.simulateID >= singleSkillData.requiredSkillID and requiredSkillCell:GetSimulateLevel() > 0
    end
    local nextSkillStaticData = singleSkillCell:GetNextSkillStaticData()
    local cost = nextSkillStaticData and nextSkillStaticData.Cost
    if cost then
      hasSkillPoint = cost <= self.simulateSkillPoint
    end
    local isFeatureSkill = singleSkillData:IsHeroFeatureSkill()
    singleSkillCell:SetCellEnable(not isFeatureSkill and fitJob and fitRequiredSkill and hasSkillPoint and not self.container.multiSaveId, not self.container.multiSaveId)
    if requiredSkillCell then
      requiredSkillCell:LinkUnlock(singleSkillCell.data.sortID, fitRequiredSkill)
    end
    if self.container.multiSaveId then
      singleSkillCell:SetDragEnable(false)
    end
  end
  self:SetSkillPoint(self.simulateSkillPoint)
end

function HeroSkillContentPage:HandleSkillUpdate(note)
  self:ClearSimulate(false)
end
