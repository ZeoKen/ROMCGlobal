autoImport("TransferProfListCell")
autoImport("WrapInfiniteListCtrl")
TransferProfPreview = class("TransferProfPreview", BaseView)
TransferProfPreview.ViewType = UIViewType.NormalLayer
local questionnaireGroup, polygonLength = 1, 99
local texObjStaticNameMap = {
  PolygonBg = "College-transfer_bg_data",
  TachieBg = "College-transfer_bg_oblique"
}
local polygonFieldMap = {
  "mobility",
  "support",
  "damage",
  "survive",
  "difficulty"
}
local picIns, myselfIns, professIns

function TransferProfPreview:Init()
  if not picIns then
    picIns, myselfIns, professIns = PictureManager.Instance, MyselfProxy.Instance, ProfessionProxy.Instance
  end
  if not GameConfig.ClassShowUI then
    LogUtility.Error("Cannot find GameConfig.ClassShowUI")
    return
  end
  self:InitView()
  self:AddListenEvts()
end

function TransferProfPreview:InitView()
  self:InitSelfTween()
  self:InitStaticTexs()
  self:InitList()
  self:InitSubClassSelectCtrl()
  self:InitTachie()
  self:InitRight()
  self.viewEffContainer = self:FindGO("ViewEffContainer")
end

function TransferProfPreview:InitSelfTween()
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
  self.tweenPos = self.gameObject:GetComponent(TweenPosition)
  self.tweenPos.worldSpace = true
  self.tweenPosStart = Game.GameObjectUtil:DeepFind(UIManagerProxy.Instance.UIRoot, "TransferProfButton")
  self.tweenPosStart = self.tweenPosStart and self.tweenPosStart.transform.position
  self:AddButtonEvent("CloseBtn", function()
    self.tweenScale:SetOnFinished(function()
      self:CloseSelf()
    end)
    self.tweenScale:PlayReverse()
    if self.tweenPosStart then
      self.tweenPos:PlayReverse()
    end
  end)
end

function TransferProfPreview:InitStaticTexs()
  local bgSp = self:FindComponent("Bg", UISprite)
  PictureManager.ReFitFullScreen(bgSp, 2)
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  local pattern = self:FindComponent("Pattern", UISprite)
  pattern.width = bgSp.width
end

function TransferProfPreview:InitList()
  self.listCtrl = WrapInfiniteListCtrl.new(self:FindGO("ListContainer"), TransferProfListCell)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddStoppedMovingCall(self.OnListCtrlStoppedMoving, self)
  self.listCells = self.listCtrl:GetCells()
  self:SetListDatas()
  self.listSelectionIndexOnEnter, self.subClassSelectionIndexOnEnter = 1, 1
  if not self:IsSelfRootClass() then
    local data = professIns:GetTransferProfStaticDataByAnyProf(myselfIns:GetMyProfession())
    if data then
      self:SetListSelectionOnEnter(data.classid)
    end
  end
  local result = self:GetQuestionnaireResult()
  if result then
    self:UpdateRecommendedProf(result)
  else
    ServiceSceneInterlocutionProxy.Instance:CallQueryPaperResultInterCmd()
  end
end

function TransferProfPreview:SetListDatas()
  self.listDatas = self.listDatas or {}
  local data
  for i = 1, #Table_ClassShowUI do
    data = Table_ClassShowUI[i]
    if Table_Class[data.classid].Race == myselfIns:GetMyRace() and not StringUtil.IsEmpty(self:GetMyTachieNameFromStaticData(data)) then
      TableUtility.ArrayPushBack(self.listDatas, data.Firsticon)
    end
  end
  TableUtility.ArrayUnique(self.listDatas)
  for i = 1, #self.listDatas do
    self.listDatas[i] = {
      icon = self.listDatas[i]
    }
  end
end

function TransferProfPreview:SetListSelectionOnEnter(targetProf)
  local classShowUiData = professIns:GetTransferProfStaticData(targetProf)
  if not classShowUiData or not self.listDatas then
    return
  end
  local firstIcon, d = classShowUiData.Firsticon
  for i = 1, #self.listDatas do
    d = self.listDatas[i]
    if d.icon == firstIcon then
      self.listSelectionIndexOnEnter = i
      break
    end
  end
  local firstIconProfList = professIns:GetTransferProfListByIconName(firstIcon)
  if firstIconProfList then
    for i = 1, #firstIconProfList do
      if firstIconProfList[i] == targetProf then
        self.subClassSelectionIndexOnEnter = i
        break
      end
    end
  end
end

function TransferProfPreview:InitSubClassSelectCtrl()
  local subClassSelectCtrl = self:FindGO("SubClassSelectCtrl")
  self.subClassSelectTrans = subClassSelectCtrl.transform
  self.subClassSelectBtns, self.subClassSps, self.subClassBgSps, self.subClassChooses, self.subClassEffectContainers = {}, {}, {}, {}, {}
  for i = 1, 2 do
    self.subClassSelectBtns[i] = self:FindGO("SubClassSelectBtn" .. i)
    self.subClassSps[i] = self:FindComponent("SubClass" .. i, GradientUISprite)
    self.subClassBgSps[i] = self:FindComponent("SubClassBg" .. i, UISprite)
    self.subClassChooses[i] = self:FindGO("SubClassChoose" .. i)
    self.subClassEffectContainers[i] = self:FindGO("EffectContainer" .. i)
    self:AddClickEvent(self.subClassSelectBtns[i], function()
      self:OnClickSubClassSelectBtn(i)
    end)
  end
end

function TransferProfPreview:InitTachie()
  self.tachieCfg = GameConfig.ClassShowUI.tachieConfig
  for objName, _ in pairs(self.tachieCfg) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.tachieFrontTween = self:FindComponent("TachieFront", TweenScale)
  self.tachieBackTween = self:FindComponent("TachieBack", TweenAlpha)
end

function TransferProfPreview:InitRight()
  self.subClassSp = self:FindComponent("SubClassSprite", UISprite)
  self.profNameLabel = self:FindComponent("ClassName", UILabel)
  self.polygon = self:FindComponent("PowerPolygo", PolygonSprite)
  self.polygon:ReBuildPolygon()
  self.polygonDots = {}
  local dotParentTrans = self:FindGO("PolygonDots").transform
  for i = 1, dotParentTrans.childCount do
    TableUtility.ArrayPushBack(self.polygonDots, dotParentTrans:GetChild(i - 1))
  end
  self.skillBtnSps = {}
  local skillParent = self:FindGO("SkillPart")
  for i = 1, 6 do
    self.skillBtnSps[i] = self:FindComponent(tostring(i), UISprite, skillParent)
    self:AddClickEvent(self.skillBtnSps[i].gameObject, function()
      self:OnClickSkillBtn(i)
    end)
  end
  self:AddButtonEvent("GotoBtn", function()
    if not self.showingProfStaticData then
      LogUtility.Error("You're doing GOTO without static data of transfer prof!")
      return
    end
    FuncShortCutFunc.Me():CallByID(self.showingProfStaticData.gotomode)
    self:CloseSelf()
  end)
end

function TransferProfPreview:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SceneInterlocutionQueryPaperResultInterCmd, self.OnQueryPaperResult)
end

function TransferProfPreview:OnEnter()
  TransferProfPreview.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  self:UpdateSelectionOnEnter()
  self.tweenScale:PlayForward()
  if self.tweenPosStart then
    self.tweenPos.from = self.tweenPosStart
    self.tweenPos.to = LuaGeometry.Const_V3_zero
    self.tweenPos:PlayForward()
  end
  self:PlayUIEffect(EffectMap.UI.Interface_star, self.viewEffContainer)
  self.isInited = true
end

function TransferProfPreview:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  TransferProfPreview.super.OnExit(self)
end

function TransferProfPreview:OnClickListCell(cellCtl)
  local data = cellCtl and cellCtl.data
  local icon = data and data.icon
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(icon)
  end
  if self.isOnListCtrlStoppedMoving then
    self.isOnListCtrlStoppedMoving = nil
  else
    self.listCtrl:ScrollTowardsCell(cellCtl)
  end
  self:UpdateSubClassSelectCtrlByFirstIcon(icon)
  self:OnClickSubClassSelectBtn(1)
end

function TransferProfPreview:OnClickSubClassSelectBtn(index)
  if not index or index > #self.subClassList then
    return
  end
  self.subClassSelectIndex = index
  self.showingProfStaticData = professIns:GetTransferProfStaticData(self.subClassList[index])
  if not self.showingProfStaticData then
    LogUtility.ErrorFormat("Cannot get transfer prof static data with id = {0}", self.subClassList[index])
    return
  end
  IconManager:SetProfessionIcon(self.showingProfStaticData.Thirdicon, self.subClassSp)
  self.profNameLabel.text = ProfessionProxy.GetProfessionName(self.showingProfStaticData.classid, myselfIns:GetMySex())
  local factor, eagle
  for i, field in ipairs(polygonFieldMap) do
    factor = self.showingProfStaticData and self.showingProfStaticData[field] or 0
    eagle = math.rad(72.0 * (i - 1))
    self.polygon:SetLength(i - 1, factor * 20)
    self.polygonDots[i].transform.localPosition = LuaGeometry.GetTempVector3(math.sin(eagle) * polygonLength * factor / 5, math.cos(eagle) * polygonLength * factor / 5)
  end
  self:UpdateTachie()
  local skillId, isShow
  for i = 1, 6 do
    skillId = self.showingProfStaticData["skill" .. i]
    isShow = skillId ~= nil and 0 < skillId
    self.skillBtnSps[i].gameObject:SetActive(isShow)
    if isShow then
      IconManager:SetSkillIconByProfess(Table_Skill[skillId].Icon, self.skillBtnSps[i], myselfIns:GetMyProfessionType(), true)
    end
  end
  for i = 1, #self.subClassChooses do
    self.subClassChooses[i]:SetActive(i == index)
  end
end

function TransferProfPreview:OnClickSkillBtn(index)
  index = index or 1
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.VideoPreview,
    viewdata = {
      skillId = self.showingProfStaticData["skill" .. index]
    }
  })
end

function TransferProfPreview:OnListCtrlStoppedMoving(currentCellCtl)
  if not self.isOnListCtrlStoppedMovingCalled then
    self.isOnListCtrlStoppedMovingCalled = true
    return
  end
  self.isOnListCtrlStoppedMoving = true
  self:OnClickListCell(currentCellCtl)
end

function TransferProfPreview:OnQueryPaperResult()
  self:UpdateRecommendedProf(self:GetQuestionnaireResult())
end

function TransferProfPreview:UpdateSubClassSelectCtrlByFirstIcon(firstIcon)
  self.subClassList = self.subClassList or {}
  TableUtility.ArrayClear(self.subClassList)
  TableUtility.ArrayShallowCopy(self.subClassList, professIns:GetTransferProfListByIconName(firstIcon))
  for i = 1, #self.subClassSelectBtns do
    self.subClassSelectBtns[i]:SetActive(true)
  end
  if not self.subClassList or not next(self.subClassList) then
    LogUtility.Error("Cannot find any sub class to show!!!")
    return
  end
  local index, invalidIndices, sData = 1, ReusableTable.CreateArray()
  for i = 1, #self.subClassList do
    sData = professIns:GetTransferProfStaticData(self.subClassList[i])
    if StringUtil.IsEmpty(self:GetMyTachieNameFromStaticData(sData)) then
      TableUtility.ArrayPushBack(invalidIndices, i)
    else
      IconManager:SetProfessionIcon(sData.Thirdicon, self.subClassSps[index])
      local result, c = ColorUtil.TryParseHexString(GameConfig.ClassShowUI.subClassBgSpColorMap[sData.Firsticon])
      if result then
        self.subClassBgSps[index].color = c
      end
      local gradientColorCfg = GameConfig.ClassShowUI.subClassSpGradientColorMap[sData.Firsticon]
      if gradientColorCfg then
        result, c = ColorUtil.TryParseHexString(gradientColorCfg[1])
        if result then
          self.subClassSps[index].gradientTop = c
        end
        result, c = ColorUtil.TryParseHexString(gradientColorCfg[2])
        if result then
          self.subClassSps[index].gradientBottom = c
        end
      end
      index = index + 1
    end
  end
  for i = index, 2 do
    self.subClassSelectBtns[i]:SetActive(false)
  end
  for i = #invalidIndices, 1, -1 do
    table.remove(self.subClassList, invalidIndices[i])
  end
  ReusableTable.DestroyAndClearArray(invalidIndices)
  if self.recommendedClassId then
    if self.recommendedSubClassEffect then
      self.recommendedSubClassEffect:ResetLocalPositionXYZ(10000, 10000, 0)
    end
    for i = 1, #self.subClassList do
      if self.subClassList[i] == self.recommendedClassId then
        local container = self.subClassEffectContainers[i]
        if self.recommendedSubClassEffect then
          self.recommendedSubClassEffect:ResetParent(container.transform)
          self.recommendedSubClassEffect:ResetLocalPositionXYZ(0, 0, 0)
          break
        end
        self.recommendedSubClassEffect = self:PlayUIEffect(EffectMap.UI.TransferProf_RecommendedProf, container)
        self.recommendedSubClassEffect:ResetLocalPositionXYZ(0, 0, 0)
        break
      end
    end
  end
end

function TransferProfPreview:UpdateTachie()
  local newTachieName = self:GetMyTachieNameFromStaticData()
  if self.tachieName == newTachieName then
    return
  end
  if not StringUtil.IsEmpty(self.tachieName) then
    for objName, _ in pairs(self.tachieCfg) do
      picIns:UnLoadTransferProf(self.tachieName, self[objName])
    end
  end
  self.tachieName = newTachieName
  if StringUtil.IsEmpty(self.tachieName) then
    LogUtility.Error("Tachie name is nil or empty!!")
    return
  end
  local config, frontScale
  for objName, objConfig in pairs(self.tachieCfg) do
    picIns:SetTransferProf(self.tachieName, self[objName])
    config = objConfig[self.tachieName]
    if config and next(config) then
      self[objName].transform.localPosition = LuaGeometry.GetTempVector3(config[1], config[2])
      self[objName].transform.localScale = self:GetVector3OfScale(config[3])
      self[objName].flip = config[4] or 0
      if config[3] < 0.8 then
        frontScale = config[3]
      end
    end
  end
  self.tachieBackTween:Sample(0, false)
  self.tachieBackTween.enabled = false
  self.tachieFrontTween.from = self:GetVector3OfScale((frontScale or 1) + 0.05)
  self.tachieFrontTween.to = self:GetVector3OfScale(frontScale)
  self.tachieFrontTween:SetOnFinished(function()
    self.tachieBackTween:ResetToBeginning()
    self.tachieBackTween:PlayForward()
  end)
  self.tachieFrontTween:ResetToBeginning()
  self.tachieFrontTween:PlayForward()
end

function TransferProfPreview:UpdateRecommendedProf(questionnaireResult)
  self.recommendedClassShowUiId = self:GetRecommendedClassShowUiIdFromResult(questionnaireResult)
  if self.recommendedClassShowUiId then
    local classShowUiData, d = Table_ClassShowUI[self.recommendedClassShowUiId]
    self.recommendedClassId = classShowUiData.classid
    for i = 1, #self.listDatas do
      d = self.listDatas[i]
      d.recommended = d.icon == classShowUiData.Firsticon
      if d.recommended then
        if self:IsSelfRootClass() then
          self:SetListSelectionOnEnter(self.recommendedClassId)
        end
        if self.isInited then
          self:UpdateSelectionOnEnter()
        end
      end
    end
  end
end

function TransferProfPreview:UpdateSelectionOnEnter()
  self.listCtrl:ResetDatas(self.listDatas)
  self.listCtrl:SetStartPositionByIndex(self.listSelectionIndexOnEnter)
  local targetIcon, icon, hasCell = self.listDatas[self.listSelectionIndexOnEnter].icon
  for _, cell in pairs(self.listCells) do
    icon = cell.data and cell.data.icon
    if icon == targetIcon then
      self:OnClickListCell(cell)
      hasCell = true
      break
    end
  end
  if hasCell then
    self:OnClickSubClassSelectBtn(self.subClassSelectionIndexOnEnter)
  else
    LogUtility.WarningFormat("Cannot find cell with data.icon = {0} from the listCells. There must be sth wrong!", targetIcon)
  end
end

local sexFieldMap = {"pictureM", "pictureF"}

function TransferProfPreview:GetMyTachieNameFromStaticData(sData)
  sData = sData or self.showingProfStaticData
  local sexTachieField = sexFieldMap[myselfIns:GetMySex()]
  return sData[sexTachieField]
end

function TransferProfPreview:GetVector3OfScale(scale)
  return LuaGeometry.GetTempVector3(scale, scale, scale)
end

function TransferProfPreview:GetQuestionnaireResult()
  return QuestionnaireProxy.Instance:GetMyResultByGroup(questionnaireGroup)
end

local classShowUiIdsWithRepetitiveResult = {
  {8, 9}
}

function TransferProfPreview:GetRecommendedClassShowUiIdFromResult(questionnaireResult)
  local recommendedId
  for id, data in pairs(Table_ClassShowUI) do
    if data.result == questionnaireResult then
      recommendedId = id
      break
    end
  end
  if recommendedId then
    for _, cfg in pairs(classShowUiIdsWithRepetitiveResult) do
      for _, id in pairs(cfg) do
        if recommendedId == id then
          recommendedId = cfg[MyselfProxy.Instance:GetMySex() or 1]
          break
        end
      end
    end
  end
  return recommendedId
end

function TransferProfPreview:IsSelfRootClass()
  return ProfessionProxy.RootClass[myselfIns:GetMyProfession()] ~= nil
end
