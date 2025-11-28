autoImport("GemExhibitCell")
autoImport("WrapListCtrl")
autoImport("ItemTipGemExhibitCell")
GemAppraisePage = class("GemAppraisePage", SubView)
local lackMagnifier

function GemAppraisePage:InitSkillQualityFilter()
  local obsoleteSkillClassFilterPopObj = self:FindGO("SkillClassFilterPop")
  if obsoleteSkillClassFilterPopObj then
    self:Hide(obsoleteSkillClassFilterPopObj)
  end
  self.curSkillClassFilterPopData = 0
  local qualityTabRoot = self:FindGO("SkillQualityTabRoot")
  self:Show(qualityTabRoot)
  for togName, tableData in pairs(GemProxy.QualityTogs) do
    self[togName] = self:FindGO(togName, qualityTabRoot)
    self[togName .. "lab1"] = self:FindComponent("Label1", UILabel, self[togName])
    self[togName .. "lab1"].text = tableData.value
    self[togName .. "lab2"] = self:FindComponent("Label2", UILabel, self[togName])
    self[togName .. "lab2"].text = tableData.value
    self:AddClickEvent(self[togName], function()
      local key = GemProxy.QualityTogs[togName].key
      if self.curSkillClassFilterPopData == key then
        return
      end
      self.curSkillClassFilterPopData = key
      self:UpdateExhibitList()
    end)
  end
end

function GemAppraisePage:InitProfessionFilter()
  local obsoleteSkillProfessionFilterPop = self:FindGO("SkillProfessionFilterPop")
  if obsoleteSkillProfessionFilterPop then
    self:Hide(obsoleteSkillProfessionFilterPop)
  end
  self.professionTipStick = self:FindComponent("AppraiseProfessionTipStick", UIWidget)
  self.curProfessionFilterLab = self:FindComponent("CurProfessionFilterLab", UILabel)
  self.curProfessionFilterLab.text = GemProxy.Instance:GetCurProfressionName()
  self:AddClickEvent(self.curProfessionFilterLab.gameObject, function()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.professionTipStick)
  end)
end

function GemAppraisePage:Init()
  self:ReLoadPerferb("view/GemAppraisePage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  if not lackMagnifier then
    lackMagnifier = {
      {
        id = GameConfig.Gem.CheckUpItemId
      }
    }
  end
  self.selectTipData = {
    customFuncConfig = {
      name = ZhString.Gem_AppraiseSelectBtnName,
      needCountChoose = true,
      callback = function(data, count)
        data = data:Clone()
        data:SetItemNum(count)
        self.targetCell:SetData(data)
        self:UpdateAppraiseBtnLabels()
        self.leadLabel:SetActive(false)
        self.selectBord:SetActive(false)
      end
    },
    callback = function(self)
      self:RemoveSelectTip()
    end,
    callbackParam = self
  }
  self:AddEvents()
  self:InitRight()
  self:InitLeft()
  self:InitSelectBord()
  self:InitExhibitTip()
  self:InitHelpButton()
end

function GemAppraisePage:AddEvents()
  self:AddDispatcherEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddDispatcherEvt(GemEvent.ProfessionChanged, self.OnProfessionChanged)
  self:AddDispatcherEvt(ItemEvent.GemDataUpdate, self.OnGemDataUpdate)
end

function GemAppraisePage:OnProfessionChanged()
  self.curProfessionFilterLab.text = GemProxy.Instance:GetCurProfressionName()
  self:UpdateExhibitList()
end

local skipTipOffset = {-90, -75}

function GemAppraisePage:InitRight()
  self.effectContainer = self:FindGO("EffectContainer")
  local skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemAppraise, skipBtnSp, NGUIUtil.AnchorSide.Left, skipTipOffset)
  end)
  local targetCellGO = self:FindGO("TargetCell")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GemCell"), targetCellGO)
  self.targetCell = GemCell.new(targetCellGO)
  self.targetCell:SetData()
  self.targetCell:ShowNum()
  self.targetCell:SetShowBagSlot(true)
  self.targetCell:SetShowNewTag(false)
  self.targetCell:SetShowNameLabel(false)
  self.targetCell:SetShowFavoriteTip(false)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.OnClickTargetCell, self)
  self.leadLabel = self:FindGO("LeadLabel")
  local appraise1Btn = self:FindGO("Appraise1Btn")
  self:AddClickEvent(appraise1Btn, function()
    self:TrySendAppraiseMessage(1)
  end)
  local appraise10Btn = self:FindGO("Appraise10Btn")
  self:AddClickEvent(appraise10Btn, function()
    self:TrySendAppraiseMessage(tonumber(self.appraise10Label.text))
  end)
  local appraise1Icon = self:FindComponent("Icon", UISprite, appraise1Btn)
  IconManager:SetUIIcon("UI_380001", appraise1Icon)
  local appraise10Icon = self:FindComponent("Icon", UISprite, appraise10Btn)
  IconManager:SetUIIcon("UI_380001", appraise10Icon)
  self.appraise1Label = self:FindComponent("Num", UILabel, appraise1Btn)
  local appraise1DescLabel = self:FindComponent("Label", UILabel, appraise1Btn)
  appraise1DescLabel.text = ZhString.GemAppraise_Once
  self.appraise1Label.text = "1"
  self.appraise10Label = self:FindComponent("Num", UILabel, appraise10Btn)
  self.appraise10Label.text = "10"
  self.appraise10DescLabel = self:FindComponent("Label", UILabel, appraise10Btn)
  self.appraise10DescLabel.text = string.format(ZhString.GemAppraise_Multi, 10)
  self.isAppraiseBtnEnabled = true
end

function GemAppraisePage:InitLeft()
  local leftGO = self:FindGO("Left")
  local container = self:FindGO("ItemContainer", leftGO)
  self.emptyGemLab = self:FindComponent("EmptyGem", UILabel, leftGO)
  self.emptyGemLab.text = ZhString.GemAppraise_Empty
  self.exhibitListCtrl = WrapListCtrl.new(container, GemExhibitCell, "GemExhibitCell", nil, nil, nil, true)
  self.exhibitListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExhibitCell, self)
  self:InitProfessionFilter()
  self:InitSkillQualityFilter()
end

function GemAppraisePage:InitSelectBord()
  self.selectBord = self:FindGO("SelectBord")
  self.selectBordBg = self:FindComponent("SelectBordBg", UISprite)
  self.selectBordContainer = self:FindGO("ItemContainer", self.selectBord)
  self.selectBordListCtrl = WrapListCtrl.new(self.selectBordContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 3, 102, true)
  self.selectBordListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSelectBordCell, self)
  self.selectBordCells = self.selectBordListCtrl:GetCells()
  for _, cell in pairs(self.selectBordCells) do
    cell:SetShowNameLabel(false)
    cell:SetShowFavoriteTip(false)
  end
  self:AddButtonEvent("BordCloseBtn", function()
    self.selectBord:SetActive(false)
  end)
  self.selectBordCloseComp = self.selectBord:GetComponent(CloseWhenClickOtherPlace)
  
  function self.selectBordCloseComp.callBack()
    if self.selectBord then
      self.selectBord:SetActive(false)
    end
    if self.selectTip then
      self:RemoveSelectTip()
    end
  end
end

function GemAppraisePage:InitExhibitTip()
  self.exhibitTip = ItemTipGemExhibitCell.new(self:FindGO("ExhibitTipContainer"))
  local cells = self.exhibitListCtrl:GetCells()
  for _, cell in pairs(cells) do
    self.exhibitTip:AddCloseCompTarget(cell)
  end
  self.exhibitTip:SetActive(false)
end

function GemAppraisePage:InitHelpButton()
  local go = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(1008, nil, go)
end

function GemAppraisePage:OnEnter()
  GemAppraisePage.super.OnEnter(self)
  self:OnActivate()
  self:UpdateExhibitList()
end

function GemAppraisePage:OnActivate()
  self.selectBord:SetActive(false)
  self.targetCell:SetData(nil)
  self.leadLabel:SetActive(true)
  self:UpdateAppraiseBtnLabels()
  if not self.backEffect then
    self:PlayUIEffect(EffectMap.UI.GemViewGuide, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("jianding_1", 0, true)
    end)
  else
    self.backEffect:ResetAction("jianding_1", 0, true)
  end
end

function GemAppraisePage:OnDeactivate()
  self.exhibitTip:SetActive(false)
end

function GemAppraisePage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  GemAppraisePage.super.OnExit(self)
end

function GemAppraisePage:OnItemUpdate()
  local data = self.targetCell.data
  self.targetCell:SetData(data and BagProxy.Instance:GetItemByGuid(data.id))
  self:UpdateSelectBordList()
  self:UpdateAppraiseBtnLabels()
  self:RemoveSelectTip()
end

function GemAppraisePage:OnGemDataUpdate(items)
  if self.gameObject.activeInHierarchy then
    GemProxy.Instance:ShowNewGemResults(items)
  end
end

function GemAppraisePage:OnClickTargetCell()
  if not self.selectBord.activeSelf then
    self.selectBord:SetActive(true)
    self.leadLabel:SetActive(false)
    self:UpdateSelectBordList()
  end
end

local selectTipOffset = {-180, 0}

function GemAppraisePage:OnClickSelectBordCell(cellCtl)
  if cellCtl:CheckDataIsNilOrEmpty() then
    return
  end
  local data = cellCtl and cellCtl.data
  self.selectTipData.itemdata = data
  self.selectTipData.customFuncConfig.callbackParam = data
  self.selectTip = self:ShowItemTip(self.selectTipData, self.selectBordBg, NGUIUtil.AnchorSide.Left, selectTipOffset)
  self.selectTip:AddIgnoreBounds(self.selectBordContainer)
  self.selectBordCloseComp:AddTarget(self.selectTip.gameObject.transform)
  self:TryUpdateSelectTip(data)
  self:UpdateSelectBordChoose(data.id)
end

function GemAppraisePage:OnClickExhibitCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  self.exhibitTip:SetActive(true)
  self.exhibitTip:SetData(data)
end

function GemAppraisePage:UpdateSelectBordList()
  if not self.selectBord.activeSelf then
    return
  end
  self.selectBordListCtrl:ResetDatas(GemProxy.GetFoldedUnappraisedGemItemData(), true)
  self:UpdateSelectBordChoose(self.targetCell.data and self.targetCell.data.id)
end

function GemAppraisePage:UpdateSelectBordChoose(id)
  for _, cell in pairs(self.selectBordCells) do
    cell:SetChoose(id)
  end
end

function GemAppraisePage:UpdateAppraiseBtnLabels()
  local data = self.targetCell.data
  local appraise10LabelRealCount = data and math.min(99, data.num) or 10
  self.appraise10Label.text = appraise10LabelRealCount
  self.appraise10DescLabel.text = string.format(ZhString.GemAppraise_Multi, appraise10LabelRealCount)
  local magnifierCount = GemProxy.GetMagnifierCount()
  self.appraise1Label.color = data and magnifierCount < 1 and ColorUtil.NGUILabelRed or ColorUtil.NGUIWhite
  self.appraise10Label.color = data and appraise10LabelRealCount > magnifierCount and ColorUtil.NGUILabelRed or ColorUtil.NGUIWhite
end

local exhibitComp = function(l, r)
  if l.Quality ~= r.Quality then
    return l.Quality > r.Quality
  end
  return l.id < r.id
end

function GemAppraisePage:UpdateExhibitList()
  local staticDataArr = ReusableTable.CreateArray()
  local q = self.curSkillClassFilterPopData
  local p = GemProxy.Instance:GetCurNewProfessionFilterData()
  local isAllQuality = q == 0
  local isProfessionFilterExist = type(p) == "table" and next(p)
  for _, data in pairs(Table_GemRate) do
    if GemProxy.Instance:CheckGemRateValid(data.id) and (isAllQuality or data.Quality == q) and (not isProfessionFilterExist or GemProxy.Instance:CheckIfSkillGemHasSameProfessions(data.id, p)) then
      TableUtility.ArrayPushBack(staticDataArr, data)
    end
  end
  table.sort(staticDataArr, exhibitComp)
  local funcStateId, param = GemProxy.BannedQualityFuncStateId
  if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
    param = Table_FuncState[funcStateId] and Table_FuncState[funcStateId].Param
    if param then
      for i = #staticDataArr, 1, -1 do
        if 0 < TableUtility.ArrayFindIndex(param, staticDataArr[i].Quality) then
          table.remove(staticDataArr, i)
        end
      end
    end
  end
  self.exhibitListCtrl:ResetDatas(staticDataArr, true)
  if 0 < #staticDataArr then
    self:Hide(self.emptyGemLab)
  else
    self:Show(self.emptyGemLab)
  end
  ReusableTable.DestroyAndClearArray(staticDataArr)
end

function GemAppraisePage:RemoveSelectTip()
  TipManager.CloseTip()
  if self.selectBordCloseComp then
    self.selectBordCloseComp:ClearTarget()
  end
  self.selectTip = nil
end

function GemAppraisePage:TryUpdateSelectTip(data)
  if not self.selectTip then
    return
  end
  local rem = data and BagProxy.Instance:GetItemNumByStaticID(data.staticData.id) or 0
  if rem <= 0 then
    self:RemoveSelectTip()
    return
  end
  local cell = self.selectTip.cells[1]
  cell:UpdateCountChooseBord(rem)
  cell:SetChooseCount(rem)
end

function GemAppraisePage:TrySendAppraiseMessage(count)
  if not self.isAppraiseBtnEnabled then
    return
  end
  local data = self.targetCell.data
  if not data then
    MsgManager.FloatMsg(nil, ZhString.Gem_AppraiseNoTargetCellTip)
    return
  end
  if count > data.num then
    MsgManager.ShowMsgByID(3554, string.format(ZhString.Gem_LackOfUnappraisedGem, data:GetName()))
    if data.num < 1 then
      self.targetCell:SetData(nil)
    end
    return
  end
  local magnifierCount = GemProxy.GetMagnifierCount()
  if count > magnifierCount then
    lackMagnifier[1].count = count - magnifierCount
    QuickBuyProxy.Instance:TryOpenView(lackMagnifier)
    return
  end
  if count > BagProxy.Instance.skillGemBagData:GetSpaceItemNum() then
    MsgManager.ShowMsgByID(36005)
    return
  end
  local delayedTime, tickManager = 600, TimeTickManager.Me()
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemAppraise) then
    GemProxy.CallAppraisal(data.staticData.id, count)
  else
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    self:PlayUISound(AudioMap.UI.Gem)
    self:PlayUIEffect(EffectMap.UI.GemViewGuide, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction("jianding_2", 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction("jianding_2", 0, true)
    end
    delayedTime = 3600
    tickManager:CreateOnceDelayTick(delayedTime, function(owner, deltaTime)
      GemProxy.CallAppraisal(data.staticData.id, count)
    end, self, 1)
  end
  self.isAppraiseBtnEnabled = false
  tickManager:CreateOnceDelayTick(delayedTime, function(owner, deltaTime)
    self.isAppraiseBtnEnabled = true
  end, self, 2)
end

function GemAppraisePage:AddButtonEvent(name, event)
  GemAppraisePage.super.super.AddButtonEvent(self, name, event)
end
