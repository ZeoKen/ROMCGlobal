autoImport("SkadaRankingCell")
autoImport("SkadaAnalysisPopup")
autoImport("PopupGridList")
SkadaRankingPopup = class("SkadaRankingPopup", SkadaAnalysisPopup)
SkadaRankingPopup.ViewType = UIViewType.NormalLayer
SkadaRankingPopup.RT_BG = "pwsFightResultBgRt"
SkadaRankingPopup.ModelBg = "pwsFightResultBg"
local EWoodRank = {EWOODRANK_QUERY_TOTAL = 999}

function SkadaRankingPopup:FindObjs()
  self.rankListGo = self:FindGO("RankList")
  self.rankNoTip = self:FindGO("rankNoTip")
  self.cellGrid = self:FindGO("RankGrid")
  local cellWrapCfg = {
    wrapObj = self.cellGrid,
    pfbNum = 5,
    cellName = "SkadaRankingCell",
    control = SkadaRankingCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.cellWrapHelper = WrapCellHelper.new(cellWrapCfg)
  self.cellWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickRankCell, self)
  self.cellWrapHelper:AddEventListener(SkadaRankingEvent.ShowDetail, self.HandleShowDetail, self)
  local go = self:LoadCellPfb("SkadaRankingCell", self:FindGO("SelfHolder"))
  self.selfRankCell = SkadaRankingCell.new(go)
  self:AddClickEvent(self.selfRankCell.btn, function()
    self:HandleShowDetail(self.selfRankCell)
  end)
  self.modelShowGo = self:FindGO("ModelInfos")
  self.modelTexture = self:FindComponent("ModelRoot", UITexture)
  self.modelRTBg = self:FindComponent("ModelTexBg", UITexture)
  PictureManager.Instance:SetPVP(SkadaRankingPopup.ModelBg, self.modelRTBg)
  self.showName = self:FindComponent("labMvpName", UILabel)
  self.detailPopupPanel = self:FindGO("detailPopupPanel")
  self.detailRaceValue = self:FindComponent("value", UILabel, self:FindGO("Race", self.detailPopupPanel))
  self.detailSizeValue = self:FindComponent("value", UILabel, self:FindGO("Size", self.detailPopupPanel))
  self.detailAttrValue = self:FindComponent("value", UILabel, self:FindGO("Attr", self.detailPopupPanel))
  self.detailHPValue = self:FindComponent("value", UILabel, self:FindGO("HP", self.detailPopupPanel))
  self:AddClickEvent(self:FindGO("PanelClose"), function()
    self.detailPopupPanel:SetActive(false)
  end)
  SkadaRankingPopup.super.FindObjs(self)
  self.listSkills = UIGridListCtrl.new(self:FindComponent("skillsContainer", UIGrid, l_objScrollSkills), SkadaAnalysisCell, "SkadaAnalysis2Cell")
end

function SkadaRankingPopup:AddViewEvt()
  self:AddListenEvt(ServiceEvent.HomeCmdQueryWoodRankHomeCmd, self.UpdateView)
end

function SkadaRankingPopup:OnEnter()
  SkadaRankingPopup.super.super.OnEnter(self)
  if not self.profPoplist then
    self.profPoplist = PopupGridList.new(self:FindGO("profPoplist"), function(self, data)
      if self.entered then
        self:QueryInfo(data and data.id, nil)
      end
    end, self, self:FindComponent("FrontPanel", UIPanel).depth)
    local profId = ProfessionProxy.GetAllBranchProfessionId()
    local profTable = {}
    for i = 1, #profId do
      local prof = Table_Class[profId[i]]
      local item = {}
      item.id = prof and prof.TypeBranch or EWoodRank.EWOODRANK_QUERY_TOTAL
      item.Name = ProfessionProxy.GetProfessionName(prof.id)
      if StringUtil.IsEmpty(item.Name) then
        item.Name = ZhString.Gem_FilterAllProfession
      end
      table.insert(profTable, item)
    end
    local item = {
      id = EWoodRank.EWOODRANK_QUERY_TOTAL,
      Name = ZhString.Gem_FilterAllProfession
    }
    TableUtility.ArrayPushFront(profTable, item)
    self.profPoplist:SetData(profTable)
  end
  if not self.skadaPoplist then
    self.skadaPoplist = PopupGridList.new(self:FindGO("skadaPoplist"), function(self, data)
      if self.entered then
        self:QueryInfo(nil, data and data.id)
      end
    end, self, self:FindComponent("FrontPanel", UIPanel).depth)
    local powerConfig = GameConfig.Home and GameConfig.Home.npc_set_reduce
    local skadaTable = {}
    for i = 1, #powerConfig do
      local item = {}
      item.id = i
      item.Name = powerConfig[i].value .. "%"
      table.insert(skadaTable, item)
    end
    local item = {
      id = EWoodRank.EWOODRANK_QUERY_TOTAL,
      Name = ZhString.Card_All
    }
    TableUtility.ArrayPushFront(skadaTable, item)
    self.skadaPoplist:SetData(skadaTable)
  end
  self:QueryInfo(EWoodRank.EWOODRANK_QUERY_TOTAL, EWoodRank.EWOODRANK_QUERY_TOTAL)
  self.entered = true
  self.cellWrapHelper:UpdateInfo({}, true, true)
end

function SkadaRankingPopup:QueryInfo(prof, skada)
  if (not prof or self.selectProf == prof) and (not skada or self.selectSkada == skada) then
    return
  end
  self.selectProf = prof and prof or self.selectProf or EWoodRank.EWOODRANK_QUERY_TOTAL
  self.selectSkada = skada and skada or self.selectSkada or EWoodRank.EWOODRANK_QUERY_TOTAL
  ServiceHomeCmdProxy.Instance:CallQueryWoodRankHomeCmd(self.selectProf, self.selectSkada)
end

function SkadaRankingPopup:UpdateView()
  if SkadaRankingProxy.Instance.rankPending then
    return
  end
  local rankdata = SkadaRankingProxy.Instance:GetRankingData()
  if rankdata and 0 < #rankdata then
    self.rankListGo:SetActive(true)
    self.rankNoTip:SetActive(false)
    self.cellWrapHelper:UpdateInfo(rankdata, true, true)
    self:ShowModel(rankdata[1])
  else
    self.rankListGo:SetActive(false)
    self.rankNoTip:SetActive(true)
    self:ShowModel()
  end
  self.selfRankCell:SetData(SkadaRankingProxy.Instance:GetSelfRankingData(), true)
end

function SkadaRankingPopup:OnExit()
  SkadaRankingPopup.super.OnExit(self)
  self.skadaPoplist = nil
  self.profPoplist = nil
  if self.role then
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    self.modelTexture = nil
    self.role = nil
  end
end

function SkadaRankingPopup:HandleClickRankCell(cell)
  self:ShowModel(cell.data)
end

function SkadaRankingPopup:HandleShowDetail(cell)
  self.analysisData = cell.data
  self.recordDatas = self.analysisData and self.analysisData.rounds
  self:ShowDetailPopup()
end

function SkadaRankingPopup:ShowModel(rankdata)
  if not rankdata then
    self.modelShowGo:SetActive(false)
    return
  end
  self.modelShowGo:SetActive(true)
  self.showName.text = rankdata.name
  if rankdata then
    local parts = Asset_Role.CreatePartArray()
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    parts[partIndex.Body] = rankdata.body or 0
    parts[partIndex.Hair] = rankdata.hair or 0
    parts[partIndex.LeftWeapon] = rankdata.lefthand or 0
    parts[partIndex.RightWeapon] = rankdata.righthand or 0
    parts[partIndex.Head] = rankdata.headID or 0
    parts[partIndex.Wing] = rankdata.back or 0
    parts[partIndex.Face] = rankdata.faceID or 0
    parts[partIndex.Tail] = rankdata.tail or 0
    parts[partIndex.Eye] = rankdata.eye or 0
    parts[partIndex.Mount] = rankdata.mount or 0
    parts[partIndex.Mouth] = rankdata.mouthID or 0
    parts[partIndexEx.Gender] = rankdata.gender or 0
    parts[partIndexEx.HairColorIndex] = rankdata.haircolor or 0
    parts[partIndexEx.EyeColorIndex] = rankdata.eyecolor or 0
    parts[partIndexEx.BodyColorIndex] = rankdata.clothcolor or 0
    if self.role then
      self.role:Redress(parts)
      self:ShowModelCallBack()
    else
      self.role = UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.Role, nil, nil, nil, nil, function(obj)
        self.role = obj
        UIModelUtil.Instance:ChangeBGMeshRenderer(SkadaRankingPopup.RT_BG, self.modelTexture)
      end)
      self:ShowModelCallBack()
    end
    Asset_Role.DestroyPartArray(parts)
  end
end

function SkadaRankingPopup:ShowModelCallBack()
  self.role:SetName(self.showName.text)
  self.role:SetPosition(LuaGeometry.Const_V3_zero)
  self.role:SetEulerAngleY(-20)
  self.role:SetScale(1)
  self.role:RegisterWeakObserver(self)
end

function SkadaRankingPopup:ObserverDestroyed(obj)
  if obj == self.role then
    self.role = nil
  end
end

function SkadaRankingPopup:ShowDetailPopup()
  self.detailPopupPanel:SetActive(true)
  table.sort(self.recordDatas, function(a, b)
    return a.percent > b.percent
  end)
  self:UpdateData()
  local attrConfig = GameConfig.MonsterAttr
  self.detailRaceValue.text = self.analysisData.woodRace and self:GetRaceName(self.analysisData.woodRace)
  self.detailSizeValue.text = self.analysisData.woodShape and attrConfig.Body[CreatureData.ShapeIndex[self.analysisData.woodShape] or "M"]
  self.detailAttrValue.text = self.analysisData.woodNature and self:GetNatureName(self.analysisData.woodNature)
  self.detailHPValue.text = self.analysisData.woodDamageReduce and self:GetReduceName(self.analysisData.woodDamageReduce)
end

function SkadaRankingPopup:ClickBtnHelp()
  local helpData = Table_Help[PanelConfig.SkadaAnalysisPopup.id]
  local desc = helpData and helpData.Desc
  if desc then
    TipsView.Me():ShowGeneralHelp(desc)
  end
end

function SkadaRankingPopup:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function SkadaRankingPopup:ClickBtnHelp()
  local helpData = Table_Help[8000006]
  local desc = helpData and helpData.Desc
  if desc then
    TipsView.Me():ShowGeneralHelp(desc)
  end
end
