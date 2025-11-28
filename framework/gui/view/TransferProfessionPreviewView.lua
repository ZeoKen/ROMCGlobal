TransferProfessionPreviewView = class("TransferProfessionPreviewView", ContainerView)
TransferProfessionPreviewView.ViewType = UIViewType.NormalLayer
autoImport("ClassPreviewCombineCell")
autoImport("ClassPreviewCell")
autoImport("TransferProfessionTabCell")
autoImport("TransferProfessionConditionCell")
local tempArray = {}
local transferQuestID = 11000001
local pos = LuaVector3.Zero()
local nameTextureMap = {
  LeftBgTexture = "newcareer_zuo_bg03"
}

function TransferProfessionPreviewView:Init()
  self:FindObjs()
  self:AddListenerEvts()
  self:InitDatas()
end

function TransferProfessionPreviewView:FindObjs()
  self.tabPart = self:FindGO("TabPart")
  self.tabScrollView = self:FindGO("TabScrollView"):GetComponent(UIScrollView)
  self.tabGrid = self:FindGO("TabGrid", self.tabPart):GetComponent(UIGrid)
  self.tabGridCtrl = UIGridListCtrl.new(self.tabGrid, TransferProfessionTabCell, "TransferProfessionTabCell")
  self.tabGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTabCell, self)
  self.leftPart = self:FindGO("LeftPart")
  self.jobTreeScrollView = self:FindGO("JobTreeScrollView", self.leftPart):GetComponent(UIScrollView)
  self.jobTreePanel = self:FindGO("JobTreeScrollView", self.leftPart):GetComponent(UIPanel)
  local cellNode = self:FindGO("CellNode", self.leftPart)
  local cellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ClassPreviewCombineCell"), cellNode)
  self.classPreviewCbCell = ClassPreviewCombineCell.new(cellObj)
  self.classPreviewCbCell:AddEventListener(MouseEvent.MouseClick, self.handleClickPreviewCell, self)
  self.classPreviewCbCell.gameObject.transform.localPosition = LuaVector3.Zero()
  self.advanceClassTip = self:FindGO("AdvanceClassTip", self.leftPart):GetComponent(UILabel)
  self.rightPart = self:FindGO("RightPart")
  self.infoScrollView = self:FindGO("InfoScrollView", self.rightPart):GetComponent(UIScrollView)
  self.infoTable = self:FindGO("InfoTable", self.rightPart):GetComponent(UITable)
  self.profIntroTitle = self:FindGO("ProfIntroTitle", self.rightPart):GetComponent(UILabel)
  self.profIntroLabel = self:FindGO("ProfIntroLabel", self.rightPart):GetComponent(UILabel)
  self.skillInfoTitle = self:FindGO("SkillInfoTitle", self.rightPart):GetComponent(UILabel)
  self.skillGrid = self:FindGO("SkillGrid", self.rightPart):GetComponent(UIGrid)
  self.skillScrollView = self:FindGO("SkillScrollView", self.rightPart):GetComponent(UIScrollView)
  self.skillGridList = UIGridListCtrl.new(self.skillGrid, ProfessionSkillCell, "ProfessionSkillCell")
  self.skillGridList:AddEventListener(MouseEvent.MouseClick, self.handleClickskill, self)
  self.advanceInfoTip = self:FindGO("AdvanceInfoTip", self.rightPart):GetComponent(UILabel)
  self.advanceGrid = self:FindGO("AdvanceInfoGrid", self.rightPart):GetComponent(UITable)
  self.advConditionCtrl = UIGridListCtrl.new(self.advanceGrid, TransferProfessionConditionCell, "TransferProfessionConditionCell")
  self.playBtn = self:FindGO("PlayBtn")
  self.playBtn_Label = self:FindGO("Label", self.playBtn):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmButton")
  self.confirmBtn_Label = self:FindGO("Label", self.confirmBtn):GetComponent(UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectContainer_TweenPos = self.effectContainer:GetComponent(TweenPosition)
  self.effectContainer:SetActive(false)
  self.tweenPart1 = self:FindGO("TweenPart1"):GetComponent(UISprite)
  self.tweenLine1 = self:FindGO("TweenLine1"):GetComponent(TweenHeight)
  self.tweenLine2_1 = self:FindGO("TweenLine2_1"):GetComponent(TweenWidth)
  self.tweenLine2_2 = self:FindGO("TweenLine2_2"):GetComponent(TweenWidth)
  self.tweenPart1.gameObject:SetActive(false)
  self.tweenLine1.gameObject:SetActive(false)
  self.tweenLine2_1.gameObject:SetActive(false)
  self.tweenLine2_2.gameObject:SetActive(false)
  for name, _ in pairs(nameTextureMap) do
    self[name] = self:FindComponent(name, UITexture)
  end
  self:AddClickEvent(self.confirmBtn, function()
    self:TryGoTo()
  end)
  self:AddClickEvent(self.playBtn, function()
    self:TryPlay()
  end)
  self:AddButtonEvent("CloseButton", function()
    self:TransferQuestNotify(false)
    self:CloseSelf()
  end)
end

function TransferProfessionPreviewView:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
end

function TransferProfessionPreviewView:InitDatas()
  if not self.dataInited then
    ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
    return
  end
  self:InitShow()
end

function TransferProfessionPreviewView:InitShow()
  tempArray = ProfessionProxy.Instance:GetClassPreviewFirstRowTable()
  self.tabGridCtrl:ResetDatas(tempArray)
  self.tabScrollView:ResetPosition()
  local cells = self.tabGridCtrl:GetCells()
  local curProfID = self.initProfID or MyselfProxy.Instance:GetMyProfession()
  local baseID = ProfessionProxy.GetTypeBranchBaseIdFromProf(curProfID)
  local curTypeBranch = Table_Class[baseID] and Table_Class[baseID].TypeBranch or 0
  local targetCell
  for i = 1, #cells do
    if cells[i].staticData.TypeBranch == curTypeBranch then
      targetCell = cells[i]
      self:handleClickTabCell(cells[i])
      break
    end
  end
  if not targetCell then
    self:handleClickTabCell(cells[1])
  else
    local panel = self.tabScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.tabScrollView:MoveRelative(offset)
  end
end

function TransferProfessionPreviewView:handleClickTabCell(cellCtrl)
  local classid = cellCtrl.data
  local statidData = cellCtrl.staticData
  local cells = self.tabGridCtrl:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single == cellCtrl then
      single:setIsSelected(true)
    else
      single:setIsSelected(false)
    end
  end
  if self.curChooseTabCell == cellCtrl then
    return
  end
  self.curChooseTabCell = cellCtrl
  local baseID = ProfessionProxy.GetTypeBranchBaseIdFromProf(classid)
  self:RefreshProfessionTree(baseID)
  self.jobTreeScrollView:ResetPosition()
  local curProfID = self.initProfID or MyselfProxy.Instance:GetMyProfession()
  local myselfProf = MyselfProxy.Instance:GetMyProfession()
  cells = self.classPreviewCbCell:GetCells()
  if cells then
    if not TableUtil.TableIsEmpty(self.transferQuestList) then
      for prof, questid in pairs(self.transferQuestList) do
        if cells[prof] then
          cells[prof]:SetUnlockStatus(true)
        end
      end
    end
    if cells[curProfID] then
      self.curClass = curProfID
      self:handleClickPreviewCell(cells[curProfID])
      self:TweenToPreviewCell(cells[curProfID])
      if not self.initProfID then
        local targetCell = cells[curProfID]
        local previewCell = cells[curProfID - 1]
        if not self.transferEffPlayed then
          self:HandlePlayTransferEffect(previewCell, targetCell)
          self.transferEffPlayed = true
        end
      end
      return
    else
      local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      local typeBranch = statidData.TypeBranch
      if S_ProfessionDatas[typeBranch] then
        local profession = S_ProfessionDatas[typeBranch].profession
        if cells[profession] then
          self.curClass = profession
          self:handleClickPreviewCell(cells[profession])
          self:TweenToPreviewCell(cells[profession])
          return
        end
      else
        xdlog("默认勾选第一个")
        local tempList = {}
        for k, v in pairs(cells) do
          table.insert(tempList, v)
        end
        table.sort(tempList, function(l, r)
          local l_id = l.data or 0
          local r_id = r.data or 0
          if l_id ~= r_id then
            return l_id < r_id
          end
        end)
        if 0 < #tempList then
          self.curClass = tempList[1].data
          tempList[1]:SetUnlockStatus(true)
          self:handleClickPreviewCell(tempList[1])
          self:TweenToPreviewCell(tempList[1])
          return
        end
      end
    end
  end
  self.curClass = classid
  self:RefreshProfessionInfo(classid)
end

function TransferProfessionPreviewView:HandlePlayTransferEffect(previewCell, targetCell)
  if not targetCell then
    return
  end
  local line = targetCell.line or 1
  local depth = ProfessionProxy.GetJobDepth(targetCell.data)
  if depth == 2 then
    self.tweenPart1.gameObject:SetActive(true)
    self.tweenPart1.fillAmount = 1
    self.tween1EndTime = ServerTime.CurServerTime() / 1000 + 0.8
    TimeTickManager.Me():CreateTick(500, 20, function(owner, deltaTime)
      local leftTime = self.tween1EndTime - ServerTime.CurServerTime() / 1000
      local per = leftTime / 0.3
      self.tweenPart1.fillAmount = per
      if leftTime < 0 then
        TimeTickManager.Me():ClearTick(self, 2)
      end
    end, self, 2)
    TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
      self.tweenLine1.gameObject:SetActive(true)
      self.tweenLine1.delay = 0
      self.tweenLine1:ResetToBeginning()
      self.tweenLine1:PlayForward()
    end, self, 3)
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      if line == 1 then
        self.tweenLine2_1.gameObject:SetActive(true)
        self.tweenLine2_1:ResetToBeginning()
        self.tweenLine2_1.delay = 0
        self.tweenLine2_1:PlayForward()
      else
        self.tweenLine2_2.gameObject:SetActive(true)
        self.tweenLine2_2:ResetToBeginning()
        self.tweenLine2_2.delay = 0
        self.tweenLine2_2:PlayForward()
      end
    end, self, 4)
  elseif previewCell then
    self.tweenPart1.gameObject:SetActive(true)
    self.tweenPart1.gameObject.transform:SetParent(previewCell.gameObject.transform)
    self.tweenPart1.gameObject.transform.localPosition = LuaVector3.Zero()
    self.tweenPart1.fillAmount = 1
    self.tween1EndTime = ServerTime.CurServerTime() / 1000 + 0.8
    TimeTickManager.Me():CreateTick(500, 20, function(owner, deltaTime)
      local leftTime = self.tween1EndTime - ServerTime.CurServerTime() / 1000
      local per = leftTime / 0.3
      self.tweenPart1.fillAmount = per
      if leftTime < 0 then
        TimeTickManager.Me():ClearTick(self, 2)
      end
    end, self, 2)
  end
  TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
    targetCell:PlayTransferEffect()
  end, self, 1)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:PlayUISound(AudioMap.UI.TransferPreviewEffect)
  end, self, 5)
end

function TransferProfessionPreviewView:ResetTweens()
  self.tweenLine1:ResetToBeginning()
  self.tweenLine2_1:ResetToBeginning()
  self.tweenLine2_2:ResetToBeginning()
end

function TransferProfessionPreviewView:TweenToPreviewCell(targetCell)
  local panel = self.jobTreeScrollView.panel
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.jobTreeScrollView:MoveRelative(offset)
end

function TransferProfessionPreviewView:handleClickskill(target)
  local skillId = target.data
  local skillItem = SkillItemData.new(skillId, nil, nil, self.curClass)
  local tipData = {}
  tipData.data = skillItem
  TipManager.Instance:ShowSkillStickTip(skillItem, target.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function TransferProfessionPreviewView:handleClickPreviewCell(cellCtrl)
  local classid = cellCtrl.data
  xdlog("点击的职业ID", classid)
  if self.curChoosePreviewCell ~= cellCtrl then
    if self.curChoosePreviewCell then
      self.curChoosePreviewCell:SetChoose(false)
    end
    self.curChoosePreviewCell = cellCtrl
    self.curChoosePreviewCell:SetChoose(true)
  else
    self.curChoosePreviewCell = cellCtrl
    self.curChoosePreviewCell:SetChoose(true)
  end
  if classid then
    self:RefreshProfessionInfo(classid)
  end
end

function TransferProfessionPreviewView:RefreshProfessionTree(baseid)
  self.curChoosePreviewCell = nil
  self.classPreviewCbCell:SetData(baseid)
end

function TransferProfessionPreviewView:RefreshProfessionInfo(classid)
  local classData = Table_Class[classid]
  if not classData then
    return
  end
  local classState = ProfessionProxy.Instance:GetClassState(classid)
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local typeBranch = classData.TypeBranch
  local jobDepth = ProfessionProxy.GetJobDepth(classid)
  xdlog(classid, typeBranch, jobDepth, classState)
  local resultStr = ""
  local className = ProfessionProxy.GetProfessionName(classid, MyselfProxy.Instance:GetMySex())
  local classStr = string.format(ZhString.ProfessionPreview_ClassName, className)
  if classStr ~= "" then
    resultStr = resultStr .. classStr
  end
  local desc = string.format(ZhString.ProfessionPreview_ClassExplain, OverSea.LangManager.Instance():GetLangByKey(classData.Explain)) or ""
  if desc ~= "" then
    resultStr = resultStr .. "\n"
    resultStr = resultStr .. desc
  end
  local priorAttrList = {}
  local intialAttr = classData.InitialAttr
  if intialAttr and 0 < #intialAttr then
    local attrList = {}
    for i = 1, #intialAttr do
      table.insert(attrList, intialAttr[i])
    end
    table.sort(attrList, function(l, r)
      l_value = l.value
      r_value = r.value
      if l_value ~= r_value then
        return l_value > r_value
      end
    end)
    for i = 1, #attrList do
      if #priorAttrList < 3 then
        table.insert(priorAttrList, attrList[i])
      elseif #priorAttrList == 3 then
        if priorAttrList[3].value == attrList[i].value then
          table.insert(priorAttrList, attrList[i])
        end
      else
        break
      end
    end
  end
  local attrNameStr = ""
  if priorAttrList and 0 < #priorAttrList then
    local propNameConfig = Game.Config_PropName
    for i = 1, #priorAttrList do
      if priorAttrList[i].name and propNameConfig[priorAttrList[i].name] then
        if attrNameStr ~= "" then
          attrNameStr = attrNameStr .. ZhString.ItemTip_ChAnd
        end
        if BranchMgr.IsChina() then
          attrNameStr = attrNameStr .. propNameConfig[priorAttrList[i].name].PropName .. priorAttrList[i].name
        else
          attrNameStr = attrNameStr .. propNameConfig[priorAttrList[i].name].PropName
        end
      end
    end
  end
  if attrNameStr ~= "" then
    resultStr = resultStr .. "\n"
    resultStr = resultStr .. string.format(ZhString.ProfessionPreview_MainAttribute, attrNameStr)
  end
  local recommendList = {}
  for k, v in pairs(Table_Equip_recommend) do
    if v.branch == typeBranch and v.level == jobDepth - 1 then
      table.insert(recommendList, v)
    end
  end
  local recommendTypeList = {}
  local recommendStr = ""
  if recommendList and 0 < #recommendList then
    for i = 1, #recommendList do
      local equips = recommendList[i].equip
      for j = 1, #equips do
        local equipData = Table_Equip[equips[j]]
        if equipData and equipData.EquipType == EquipTypeEnum.Weapon then
          local itemData = Table_Item[equips[j]]
          local itemType = itemData and itemData.Type
          if not recommendTypeList[itemType] then
            recommendTypeList[itemType] = 1
          end
          if TableUtility.ArrayFindIndex(recommendTypeList, itemType) == 0 then
            table.insert(recommendTypeList, itemType)
          end
        end
      end
    end
  end
  for i = 1, #recommendTypeList do
    local typeData = Table_ItemType[recommendTypeList[i]]
    if typeData then
      if recommendStr ~= "" then
        recommendStr = recommendStr .. ZhString.ItemTip_ChAnd
      end
      if typeData.ShowName then
        recommendStr = recommendStr .. typeData.ShowName
      elseif typeData.Name then
        recommendStr = recommendStr .. typeData.Name
      end
    end
  end
  if recommendStr ~= "" then
    resultStr = resultStr .. "\n"
    resultStr = resultStr .. string.format(ZhString.ProfessionPreview_CommonlyUseWeapon, recommendStr)
  end
  local advClassNameStr = ""
  local advanceClass = classData.AdvanceClass
  if advanceClass and 0 < #advanceClass then
    local advClass = {}
    for i = 1, #advanceClass do
      if Table_Class[advanceClass[i]] then
        TableUtility.ArrayPushBack(advClass, advanceClass[i])
      end
    end
    if #advClass == 3 then
      local baseID = ProfessionProxy.GetTypeBranchBaseIdFromProf(classid)
      if 0 < TableUtility.ArrayFindIndex(ProfessionProxy.MultiSexJob1st, baseID) then
        advClass = self:GetRightUpgradeTableForMultiSexJob(baseID)
      end
    end
    for i = 1, #advClass do
      local advClassData = Table_Class[advClass[i]]
      if advClassNameStr ~= "" then
        advClassNameStr = advClassNameStr .. "/"
      end
      advClassNameStr = advClassNameStr .. ProfessionProxy.GetProfessionName(advClass[i], MyselfProxy.Instance:GetMySex())
    end
  end
  if advClassNameStr ~= "" then
    resultStr = resultStr .. "\n"
    resultStr = resultStr .. string.format(ZhString.ProfessionPreview_AdvanceClass, advClassNameStr)
  end
  self.profIntroLabel.text = resultStr
  local skillShowList = {}
  local skills = classData.Skill
  if skills then
    for i = 1, #skills do
      local data = {}
      data[1] = classid
      data[2] = skills[i]
      skillShowList[#skillShowList + 1] = data
    end
  end
  table.sort(skillShowList, function(l, r)
    local l_skillData = Table_Skill[l[2]]
    local r_skillData = Table_Skill[r[2]]
    local l_isPassive = l_skillData and l_skillData.SkillType and l_skillData.SkillType == "Passive" and 1 or 0
    local r_isPassive = r_skillData and r_skillData.SkillType and r_skillData.SkillType == "Passive" and 1 or 0
    if l_isPassive ~= r_isPassive then
      return l_isPassive < r_isPassive
    end
  end)
  self.skillGridList:ResetDatas(skillShowList)
  self.skillGrid:Reposition()
  self.skillScrollView:ResetPosition()
  local condList = {}
  local baseLv_Cond = ProfessionProxy.Instance:GetThisIdJiuZhiBaseLevel(classid)
  local jobLv_Cond = ProfessionProxy.Instance:GetThisIdJiuZhiTiaoJianLevel(classid)
  if baseLv_Cond then
    local cur_Lv = MyselfProxy.Instance:RoleLevel()
    local tempData = {
      Desc = string.format(ZhString.ProfessionPreview_PreviewClassBaseLv, baseLv_Cond),
      status = baseLv_Cond <= cur_Lv and true or false
    }
    table.insert(condList, tempData)
  end
  if jobLv_Cond then
    local previousID = ProfessionProxy.Instance:GetThisIdPreviousId(classid)
    local previousClassName = ProfessionProxy.GetProfessionName(previousID, MyselfProxy.Instance:GetMySex())
    if previousClassName then
      local tempData = {
        Desc = string.format(ZhString.ProfessionPreview_PreviewClassJobLv, previousClassName, jobLv_Cond),
        status = false
      }
      if classState == 1 or classState == 2 or classState == 3 or classState == 4 then
        tempData.status = true
      else
        local previewTypeBranch = ProfessionProxy.GetTypeBranchFromProf(previousID)
        if S_ProfessionDatas[previewTypeBranch] then
          local curJobLv = S_ProfessionDatas[previewTypeBranch].joblv
          if curJobLv then
            local previousJobLv = ProfessionProxy.Instance:GetThisJobLevelForClient(previousID, curJobLv)
            if previousJobLv and jobLv_Cond <= previousJobLv then
              tempData.status = true
            end
          end
        elseif previousID == MyselfProxy.Instance:GetMyProfession() then
          local curJobLv = MyselfProxy.Instance:JobLevel()
          if curJobLv then
            local previousJobLv = ProfessionProxy.Instance:GetThisJobLevelForClient(previousID, curJobLv)
            if previousJobLv and jobLv_Cond <= previousJobLv then
              tempData.status = true
            end
          end
        end
      end
      table.insert(condList, tempData)
    end
  end
  local advQuest = classData.AdvanceQuest
  if advQuest then
    local stepConfig = Table_ServantQuestfinishStep[advQuest]
    if stepConfig then
      local tempData = {
        Desc = string.format(ZhString.ProfessionPreview_ConditionQuestName, stepConfig.subtitle),
        status = false
      }
      if classState == 1 or classState == 2 or classState == 3 then
        tempData.status = true
      else
        tempData.status = false
      end
      table.insert(condList, tempData)
    else
      redlog("任务链配置缺失Table_ServantQuestfinishStep", advQuest)
    end
  end
  self.advConditionCtrl:ResetDatas(condList)
  self.infoTable:Reposition()
  xdlog("inited", self.notifyType, self.initProfID)
  if self.notifyType == 1 then
    self.advanceClassTip.gameObject:SetActive(true)
    local targetBaseID = ProfessionProxy.GetTypeBranchBaseIdFromProf(classid)
    self.advanceClassTip.text = string.format(ZhString.ProfessionPreview_AdvanceClass2, ProfessionProxy.GetProfessionName(MyselfProxy.Instance:GetMyProfession(), MyselfProxy.Instance:GetMySex()), ProfessionProxy.GetProfessionName(targetBaseID, MyselfProxy.Instance:GetMySex()))
    self:ResizeProfessionTreeScrollView(1)
    self.confirmBtn:SetActive(true)
  elseif self.notifyType == 2 then
    local branchValid = false
    for k, v in pairs(self.transferQuestList) do
      local _typrBranch = ProfessionProxy.GetTypeBranchFromProf(k)
      if _typrBranch == typeBranch and classid >= k then
        self.advanceClassTip.gameObject:SetActive(true)
        local previousID = ProfessionProxy.Instance:GetThisIdPreviousId(self.initProfID)
        local advClassID = Table_Class[self.initProfID].AdvanceClass and Table_Class[self.initProfID].AdvanceClass[1]
        self.advanceClassTip.text = string.format(ZhString.ProfessionPreview_AdvanceClass2, ProfessionProxy.GetProfessionName(previousID, MyselfProxy.Instance:GetMySex()), ProfessionProxy.GetProfessionName(k, MyselfProxy.Instance:GetMySex()))
        self:ResizeProfessionTreeScrollView(1)
        self.confirmBtn:SetActive(true)
        branchValid = true
        break
      end
    end
    if not branchValid then
      self.advanceClassTip.gameObject:SetActive(false)
      self:ResizeProfessionTreeScrollView(2)
      self.confirmBtn:SetActive(false)
    end
  else
    self.advanceClassTip.gameObject:SetActive(false)
    self:ResizeProfessionTreeScrollView(2)
    self.confirmBtn:SetActive(false)
  end
  self:UpdateFuncs(classid)
end

function TransferProfessionPreviewView:CheckCanNotifyQuest(classid)
  local questid = self.transferQuestList[classid]
  if questid then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questid)
    if questData and questData.type ~= QuestDataType.QuestDataType_TALK then
      return true
    end
  end
  return false
end

function TransferProfessionPreviewView:GetRightUpgradeTableForMultiSexJob(prof1st)
  local rightTable = {}
  for k, v in pairs(Table_Class[prof1st].AdvanceClass) do
    if Table_Class[v] and Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
    else
      table.insert(rightTable, v)
    end
  end
  return rightTable
end

function TransferProfessionPreviewView:UpdateFuncs(classid)
  if not self.questId then
    self.playBtn:SetActive(false)
    return
  else
    local transferClassConfig = Table_TransferClass[classid]
    if transferClassConfig and transferClassConfig.PlayForbid then
      self.playBtn:SetActive(false)
    else
      self.playBtn:SetActive(true)
    end
  end
end

local profSVParam = {
  [1] = {offsetY = 0, height = 508},
  [2] = {offsetY = -17, height = 535.4}
}

function TransferProfessionPreviewView:ResizeProfessionTreeScrollView(type)
  local param = profSVParam[type]
  if not param then
    return
  end
  local clip = self.jobTreePanel.baseClipRegion
  local pos = self.jobTreePanel.gameObject.transform.localPosition
  local targetOffsetY = param.offsetY - pos.y
  self.jobTreePanel.clipOffset = LuaGeometry.GetTempVector2(self.jobTreePanel.clipOffset.x, targetOffsetY)
  self.jobTreePanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
end

function TransferProfessionPreviewView:TryGoTo()
  if not self.curChoosePreviewCell then
    return
  end
  local classid
  if self.notifyType == 1 then
    classid = self.curChoosePreviewCell.data
    classid = classid and ProfessionProxy.GetTypeBranchBaseIdFromProf(classid)
  else
    classid = self.curChoosePreviewCell.data
    local typeBranch = classid and ProfessionProxy.GetTypeBranchFromProf(classid)
    for k, v in pairs(self.transferQuestList) do
      local _typrBranch = ProfessionProxy.GetTypeBranchFromProf(k)
      if typeBranch == _typrBranch then
        classid = k
        break
      end
    end
  end
  local staticData = Table_TransferClass[classid]
  if not staticData then
    return
  end
  local className = ProfessionProxy.GetProfessionName(classid, MyselfProxy.Instance:GetMySex())
  MsgManager.ConfirmMsgByID(296, function()
    local excuteQuest = self:TransferQuestNotify(true, classid)
    if excuteQuest then
      self:CloseSelf()
      return
    end
    local gomode = staticData and staticData.Gotomode
    if not gomode then
      return
    end
    FuncShortCutFunc.Me():CallByID(gomode)
    self:CloseSelf()
  end, nil, nil, className)
end

function TransferProfessionPreviewView:TryPlay()
  if not self.curChoosePreviewCell then
    return
  end
  local tryPro = self.curChoosePreviewCell.data
  if not tryPro then
    return
  end
  if Game.MapManager:IsPVEMode_DemoRaid() then
    ServiceMessCCmdProxy.Instance:CallChooseNewProfessionMessCCmd(nil, tryPro)
    self:TryRunQuestJump(1)
  else
    ProfessionProxy.Instance:SaveChooseClassID(tryPro)
    ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_NEWPRO)
  end
  self:TransferQuestNotify(false)
  self:CloseSelf()
end

function TransferProfessionPreviewView:TransferQuestNotify(bool, classid)
  xdlog("执行任务的跳转", bool)
  if self.notifyType == 1 then
    return self:BaseTransferNotify(bool)
  elseif self.notifyType == 2 then
    return self:AdvanceClassTransferNotify(bool, classid)
  end
end

function TransferProfessionPreviewView:AdvanceClassTransferNotify(bool, classid)
  local questid = self.transferQuestList[classid]
  local questData = questid and QuestProxy.Instance:getQuestDataByIdAndType(questid)
  if questData then
    local dialogs = questData.params and questData.params.dialog
    if dialogs and 0 < #dialogs then
      for i = 1, #dialogs do
        local dialogData = DialogUtil.GetDialogData(dialogs[i])
        local optionStr = dialogData and dialogData.Option
        if optionStr and optionStr ~= "" then
          local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(optionStr))
          if optionConfig and 1 <= #optionConfig then
            local keyStep = false
            for j = 1, #optionConfig do
              if optionConfig and optionConfig[j].id and optionConfig[j].id ~= 0 then
                keyStep = true
              end
            end
            if keyStep then
              local jumpID
              if bool then
                jumpID = optionConfig[1] and optionConfig[1].id
                if jumpID then
                  ServiceQuestProxy.Instance:CallRunQuestStep(questData.id, nil, jumpID, questData.step)
                  return true
                else
                  return false
                end
              else
                jumpID = optionConfig[2] and optionConfig[2].id
                if jumpID then
                  ServiceQuestProxy.Instance:CallRunQuestStep(questData.id, nil, jumpID, questData.step)
                end
                return false
              end
            end
          end
        else
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
          xdlog("没选项  但是有profession  竟有这种配置")
        end
      end
    else
      return false
    end
  else
    return false
  end
end

function TransferProfessionPreviewView:BaseTransferNotify(bool)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(transferQuestID)
  if questData then
    local jumpTarget = self.curChoosePreviewCell and self.curChoosePreviewCell.data
    if not jumpTarget then
      redlog("Table_TransferClass职业错误")
    end
    local targetClass = ProfessionProxy.GetTypeBranchBaseIdFromProf(jumpTarget)
    if bool then
      ServiceQuestProxy.Instance:CallRunQuestStep(questData.id, targetClass, questData.staticData.FinishJump, questData.step)
      return true
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return false
    end
  end
  return false
end

function TransferProfessionPreviewView:TryRunQuestJump(jumpId)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
  if questData then
    local jumpList = questData.params.jump
    if jumpList and 0 < #jumpList and jumpList[jumpId] then
      xdlog("有对应配置 并执行跳转", jumpList[jumpId])
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, jumpList[jumpId])
    end
  end
end

function TransferProfessionPreviewView:OnEnter()
  TransferProfessionPreviewView.super.OnEnter(self)
  self.questData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.questData
  self.questId = self.questData and self.questData.id
  if not self.questData then
    self.questId = self.viewdata.questId
    self.questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
  end
  self.transferQuestList = {}
  local questType = self.questData and self.questData.questDataStepType
  if questType and questType == QuestDataStepType.QuestDataStepType_EXCHANGE then
    self.notifyType = 1
  else
    local npc = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npc
    local questList = npc and QuestProxy.Instance:getDialogQuestListByNpcId(npc.data.staticData.id, npc.data.uniqueid) or {}
    if questList and 0 < #questList and self.questData and self.questData.type ~= QuestDataType.QuestDataType_TALK then
      for i = 1, #questList do
        local single = questList[i]
        local profession = single and single.params and single.params.profession
        if profession and single.type ~= QuestDataType.QuestDataType_TALK then
          self.transferQuestList[profession] = single.id
          self.notifyType = 2
        end
      end
    end
  end
  self.initProfID = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.classid
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:SetUI(texName, self[compName])
  end
end

function TransferProfessionPreviewView:OnExit()
  TransferProfessionPreviewView.super.OnExit(self)
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:UnLoadUI(texName, self[compName])
  end
  TimeTickManager.Me():ClearTick(self)
  local mapid = Game.MapManager:GetMapID()
  if mapid ~= nil then
    local config = Table_Map[mapid]
    if config ~= nil then
      FunctionChangeScene.Me():ReplaceCurrentBgm(config.NameEn)
    end
  end
  if self.container then
    self.container:CloseSelf()
  end
end

function TransferProfessionPreviewView:RecvProfessionQueryUserCmd(data)
  self.dataInited = true
  self:InitDatas()
end
