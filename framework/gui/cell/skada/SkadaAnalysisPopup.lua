autoImport("HeadIconCell")
autoImport("SkadaAnalysisCell")
SkadaAnalysisPopup = class("SkadaAnalysisPopup", BaseView)
SkadaAnalysisPopup.ViewType = UIViewType.PopUpLayer
SkadaAnalysisPopup.SortType = {
  CastCount = 1,
  TotalDamage = 2,
  DPS = 3,
  Percent = 4
}

function SkadaAnalysisPopup:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
  self.shareViewData = {}
end

function SkadaAnalysisPopup:FindObjs()
  local l_objTitlesRoot = self:FindGO("TitleLabels")
  self.labCastCount = self:FindComponent("labCount", UILabel, l_objTitlesRoot)
  self.labTotalDamage = self:FindComponent("labTotalDamage", UILabel, l_objTitlesRoot)
  self.labDPS = self:FindComponent("labDPS", UILabel, l_objTitlesRoot)
  self.labPercent = self:FindComponent("labPercent", UILabel, l_objTitlesRoot)
  local l_objListRoot = self:FindGO("List")
  self.objNoneTip = self:FindGO("NoneTip", l_objListRoot)
  self.objBtnDeleteRank = self:FindGO("BtnDeleteRank", l_objListRoot)
  local l_objScrollSkills = self:FindGO("ScrollSkills")
  self.scrollSkills = l_objScrollSkills:GetComponent(UIScrollView)
  self.listSkills = UIGridListCtrl.new(self:FindComponent("skillsContainer", UIGrid, l_objScrollSkills), SkadaAnalysisCell, "SkadaAnalysisCell")
end

function SkadaAnalysisPopup:AddButtonEvt()
  self.btnHelp = self:FindGO("BtnHelp")
  self:RegistShowGeneralHelpByHelpID(PanelConfig.SkadaAnalysisPopup.id, self.btnHelp)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnShare"), function()
    self:ClickBtnShare()
  end)
  self:AddClickEvent(self.labCastCount.gameObject, function()
    self:SortByCastCount()
  end)
  self:AddClickEvent(self.labTotalDamage.gameObject, function()
    self:SortByTotalDamage()
  end)
  self:AddClickEvent(self.labDPS.gameObject, function()
    self:SortByDPS()
  end)
  self:AddClickEvent(self.labPercent.gameObject, function()
    self:SortByPercent()
  end)
end

function SkadaAnalysisPopup:AddViewEvt()
  self.listSkills:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
  self.listSkills:AddEventListener(SkadaAnalysisCell.ClickShare, self.ClickCellShare, self)
end

function SkadaAnalysisPopup:ClickBtnShare()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  if not furnitureData then
    LogUtility.Error("Cannot find furnitureData by id: " .. tostring(self.myFurnitureID))
    return
  end
  local attrConfig = GameConfig.MonsterAttr
  TableUtility.TableClear(self.shareViewData)
  self.shareViewData.shareType = 2
  self.shareViewData.analysisData = self.analysisData
  self.shareViewData.totalDamage = self.analysisData.totalDamage
  self.shareViewData.averageDamage = self.analysisData.averageDamage
  self.shareViewData.raceName = self.analysisData.woodRace and self:GetRaceName(self.analysisData.woodRace)
  self.shareViewData.natureName = self.analysisData.woodNature and self:GetNatureName(self.analysisData.woodNature)
  self.shareViewData.damageReduce = self.analysisData.woodDamageReduce and self:GetReduceName(self.analysisData.woodDamageReduce)
  self.shareViewData.shapeName = self.analysisData.woodShape and attrConfig.Body[CreatureData.ShapeIndex[self.analysisData.woodShape] or "M"]
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ShareAwardView,
    viewdata = self.shareViewData
  })
end

function SkadaAnalysisPopup:ClickCellShare(cellCtl)
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  if not furnitureData then
    LogUtility.Error("Cannot find furnitureData by id: " .. tostring(self.myFurnitureID))
    return
  end
  local cellData = cellCtl.data
  local attrConfig = GameConfig.MonsterAttr
  TableUtility.TableClear(self.shareViewData)
  self.shareViewData.shareType = 2
  self.shareViewData.analysisData = self.analysisData
  self.shareViewData.totalDamage = cellData.totalDamage
  self.shareViewData.averageDamage = cellData.averageDamage
  self.shareViewData.skillID = cellData.skillID
  self.shareViewData.raceName = self.analysisData.woodRace and self:GetRaceName(self.analysisData.woodRace)
  self.shareViewData.natureName = self.analysisData.woodNature and self:GetNatureName(self.analysisData.woodNature)
  self.shareViewData.damageReduce = self.analysisData.woodDamageReduce and self:GetReduceName(self.analysisData.woodDamageReduce)
  self.shareViewData.shapeName = self.analysisData.woodShape and attrConfig.Body[CreatureData.ShapeIndex[self.analysisData.woodShape] or "M"]
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ShareAwardView,
    viewdata = self.shareViewData
  })
end

function SkadaAnalysisPopup:ClickCellHead(cellCtl)
end

function SkadaAnalysisPopup:UpdateData()
  if not self.recordDatas then
    redlog("Cannot Find Skada Rounds Data!")
    return
  end
  self.objNoneTip:SetActive(#self.recordDatas < 1)
  self.listSkills:ResetDatas(self.recordDatas)
  self.scrollSkills:ResetPosition()
  self.labCastCount.text = ZhString.SkadaAnalysis_Count
  self.labTotalDamage.text = ZhString.SkadaAnalysis_SkillDamage
  self.labDPS.text = ZhString.SkadaAnalysis_AverageDamage
  self.labPercent.text = ZhString.SkadaAnalysis_DamagePercent
  local sortSign = self.sortPositive and ZhString.SkadaAnalysis_SortPositive or ZhString.SkadaAnalysis_SortNegative
  if self.sortType == SkadaAnalysisPopup.SortType.CastCount then
    self.labCastCount.text = ZhString.SkadaAnalysis_Count .. sortSign
  elseif self.sortType == SkadaAnalysisPopup.SortType.TotalDamage then
    self.labTotalDamage.text = ZhString.SkadaAnalysis_SkillDamage .. sortSign
  elseif self.sortType == SkadaAnalysisPopup.SortType.DPS then
    self.labDPS.text = ZhString.SkadaAnalysis_AverageDamage .. sortSign
  elseif self.sortType == SkadaAnalysisPopup.SortType.Percent then
    self.labPercent.text = ZhString.SkadaAnalysis_DamagePercent .. sortSign
  end
end

function SkadaAnalysisPopup:SortByCastCount()
  self.sortPositive = self.sortType ~= SkadaAnalysisPopup.SortType.CastCount or not self.sortPositive
  if self.sortPositive then
    table.sort(self.recordDatas, function(x, y)
      return x.atkCount > y.atkCount
    end)
  else
    table.sort(self.recordDatas, function(x, y)
      return x.atkCount < y.atkCount
    end)
  end
  self.sortType = SkadaAnalysisPopup.SortType.CastCount
  self:UpdateData()
end

function SkadaAnalysisPopup:SortByTotalDamage()
  self.sortPositive = self.sortType ~= SkadaAnalysisPopup.SortType.TotalDamage or not self.sortPositive
  if self.sortPositive then
    table.sort(self.recordDatas, function(x, y)
      return x.totalDamage > y.totalDamage
    end)
  else
    table.sort(self.recordDatas, function(x, y)
      return x.totalDamage < y.totalDamage
    end)
  end
  self.sortType = SkadaAnalysisPopup.SortType.TotalDamage
  self:UpdateData()
end

function SkadaAnalysisPopup:SortByDPS()
  self.sortPositive = self.sortType ~= SkadaAnalysisPopup.SortType.DPS or not self.sortPositive
  if self.sortPositive then
    table.sort(self.recordDatas, function(x, y)
      return x.averageDamage > y.averageDamage
    end)
  else
    table.sort(self.recordDatas, function(x, y)
      return x.averageDamage < y.averageDamage
    end)
  end
  self.sortType = SkadaAnalysisPopup.SortType.DPS
  self:UpdateData()
end

function SkadaAnalysisPopup:SortByPercent()
  self.sortPositive = self.sortType ~= SkadaAnalysisPopup.SortType.Percent or not self.sortPositive
  if self.sortPositive then
    table.sort(self.recordDatas, function(x, y)
      return x.percent > y.percent
    end)
  else
    table.sort(self.recordDatas, function(x, y)
      return x.percent < y.percent
    end)
  end
  self.sortType = SkadaAnalysisPopup.SortType.Percent
  self:UpdateData()
end

function SkadaAnalysisPopup:OnEnter()
  SkadaAnalysisPopup.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.analysisData = viewdata.skadaData
  self.myFurnitureID = viewdata.furnitureID
  self.recordDatas = self.analysisData and self.analysisData.rounds
  if not self.recordDatas then
    LogUtility.Error("没有数据！")
    self:CloseSelf()
    return
  end
  table.sort(self.recordDatas, function(a, b)
    return a.percent > b.percent
  end)
  self:UpdateData()
end

function SkadaAnalysisPopup:OnExit()
  SkadaAnalysisPopup.super.OnExit(self)
end

function SkadaAnalysisPopup:OnDestroy()
  self.listSkills:Destroy()
end

function SkadaAnalysisPopup:GetRaceName(raceid)
  local nameConfig = GameConfig.MonsterAttr
  for nameEn, id in pairs(CommonFun.Race) do
    if raceid == id then
      return nameConfig.Race[nameEn]
    end
  end
end

function SkadaAnalysisPopup:GetNatureName(natureid)
  local nameConfig = GameConfig.MonsterAttr
  for nameEn, id in pairs(CommonFun.Nature) do
    if natureid == id then
      return nameConfig.Nature[nameEn]
    end
  end
end

function SkadaAnalysisPopup:GetReduceName(configIndex)
  local powerConfig = GameConfig.Home and GameConfig.Home.npc_set_reduce
  if powerConfig then
    configIndex = math.clamp(configIndex, 1, #powerConfig)
    if configIndex == self.curPower then
      return
    end
    return powerConfig[configIndex].value .. "%"
  end
end
