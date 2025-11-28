autoImport("ItemTipGemCell")
autoImport("GemPage")
autoImport("GemSkillProfitCell")
autoImport("GemAttributeProfitCell")
GemEmbedPreviewPage = class("GemEmbedPreviewPage", SubView)
GemEmbedPreviewPage.TweenDuration = 0.5
local asideTranslationX = -170
local minPageLocalPosX, maxPageLocalPosX, minPageLocalPosY, maxPageLocalPosY = -370, 370, -360, 300
local tickManager
local _ShowBtnIcon = {
  [1] = "com_icon_hide",
  [2] = "com_icon_show"
}

function GemEmbedPreviewPage:Init()
  tickManager = TimeTickManager.Me()
  self:ReLoadPerferb("view/GemEmbedPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:InitRight()
  self:InitGemPage()
  self:InitHelpButton()
  self:_InitHeroProfession()
  self:_InitNewProfitBord()
end

function GemEmbedPreviewPage:_InitHeroProfession()
  local downLeftParent = self:FindGO("DownLeft")
  self.profitBtn = self:FindGO("ProfitBtn", downLeftParent)
  local profId = self.gemPageProfession
  if not profId or not ProfessionProxy.IsHero(profId) then
    self:Hide(self.profitBtn)
    return
  end
  local familyId = profId and Table_Class[profId] and Table_Class[profId].FeatureSkill
  if not familyId then
    return
  end
  local skillId = familyId * 1000 + self.heroFeatureLv
  self.heroSkillStaticData = Table_Skill[skillId]
  if not self.heroSkillStaticData then
    return
  end
  self.heroLvLab = self:FindComponent("HeroProLv", UILabel, self.profitBtn)
  self:Show(self.profitBtn)
  self:Show(self.heroLvLab)
  self.heroLvLab.text = ""
  self:AddClickEvent(self.profitBtn, function()
    self:OpenProfit()
  end)
end

function GemEmbedPreviewPage:UpdateHeroSkill()
  self.heroSkillInfoRoot = self:FindGO("HeroSkillInfoRoot", self.skillGemTable.gameObject)
  if self.heroSkillStaticData then
    self:Show(self.heroSkillInfoRoot)
    self.heroTitleLab = self:FindComponent("TitleLab", UILabel, self.heroSkillInfoRoot)
    self.heroTitleLab.text = ZhString.Gem_HeroProfessionTitle
    self.heroFeatureLvLab = self:FindComponent("LvLab", UILabel, self.heroTitleLab.gameObject)
    local midLv, maxLv = ProfessionProxy.Instance:GetMidHeroFeatureLv(), ProfessionProxy.Instance:GetMaxHeroFeatureLv()
    self.heroFeatureLvLab.text = tostring(self.heroFeatureLv) .. "/" .. maxLv
    self.heroSkillNameLab = self:FindComponent("SkillNameLab", UILabel, self.heroSkillInfoRoot)
    self.heroSkillNameLab.text = string.format(ZhString.Gem_HeroSkillName, self.heroSkillStaticData.NameZh)
    self.heroDescLab = self:FindComponent("SkillDescLab", UILabel, self.heroSkillInfoRoot)
    self.heroDescLab.text = SkillTip:GetHeroDesc(self.heroSkillStaticData, self.heroFeatureLv)
  else
    self:Hide(self.heroSkillInfoRoot)
  end
end

function GemEmbedPreviewPage:_InitNewProfitBord()
  self.profitBord = self:FindGO("NewProfitBord")
  self:Hide(self.profitBord)
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.profitBord)
  self.emptyLab.text = ZhString.Gem_Empty
  local closeBtn = self:FindGO("CloseBordBtn", self.profitBord)
  self:AddClickEvent(closeBtn, function()
    self.profitBord:SetActive(false)
  end)
  self.skillGemTable = self:FindComponent("SkillGemContainer", UITable, self.profitBord)
  self:UpdateHeroSkill()
  self.attrGemTable = self:FindComponent("AttrGemContainer", UITable, self.profitBord)
  self:Hide(self.attrGemTable)
  self.profitLeftListCtrl = ListCtrl.new(self.skillGemTable, GemSkillProfitCell, "GemSkillPlayerDetailCell")
  self.profitRightListCtrl = ListCtrl.new(self.attrGemTable, GemAttributeProfitCell, "GemAttributePlayerDetailCell")
  self.gemTogRoot = self:FindGO("GemTogRoot")
  self.skillGemTog = self:FindGO("SkillGemTog", self.gemTogRoot)
  self.skillGemTogLab1 = self:FindComponent("Label1", UILabel, self.skillGemTog)
  self.skillGemTogLab2 = self:FindComponent("Label2", UILabel, self.skillGemTog)
  self.skillGemTogLab1.text = ZhString.Gem_SkillGemCountLabel
  self.skillGemTogLab2.text = ZhString.Gem_SkillGemCountLabel
  self:AddClickEvent(self.skillGemTog, function()
    self:Show(self.skillGemTable)
    self:Hide(self.attrGemTable)
    self.profitLeftListCtrl:ResetPosition()
    local skillGemData = self.gemPage:GetPageSkillItemDatas() or {}
    self.emptyLab.gameObject:SetActive(#skillGemData == 0)
  end)
  self.attrGemTog = self:FindGO("AttrGemTog", self.gemTogRoot)
  self.attrGemTogLab1 = self:FindComponent("Label1", UILabel, self.attrGemTog)
  self.attrGemTogLab2 = self:FindComponent("Label2", UILabel, self.attrGemTog)
  self.attrGemTogLab1.text = ZhString.Gem_AttributeGemCountLabel
  self.attrGemTogLab2.text = ZhString.Gem_AttributeGemCountLabel
  self:AddClickEvent(self.attrGemTog, function()
    self:Hide(self.skillGemTable)
    self:Show(self.attrGemTable)
    self.profitRightListCtrl:ResetPosition()
    local attrGemData = GemProxy.GetDescNameValueDataFromAttributeItemDatas(self.gemPage:GetPageAttributeItemDatas()) or {}
    self.emptyLab.gameObject:SetActive(#attrGemData == 0)
  end)
end

function GemEmbedPreviewPage:OpenProfit()
  if not self.profitDataInited then
    self:TryUpdateProfitBord()
    self.profitDataInited = true
  end
  self.profitBord:SetActive(not self.profitBord.activeInHierarchy)
end

function GemEmbedPreviewPage:TryUpdateProfitBord()
  local skillGemData = self.gemPage:GetPageSkillItemDatas() or {}
  self.emptyLab.gameObject:SetActive(#skillGemData == 0)
  self.profitLeftListCtrl:ResetDatas(skillGemData, nil, true)
  local cells = self.profitLeftListCtrl:GetCells()
  for _, c in pairs(cells) do
    c:UpdateInvalidByGemPageData(self.gemPage.pageData)
  end
  local attrGemData = GemProxy.GetDescNameValueDataFromAttributeItemDatas(self.gemPage:GetPageAttributeItemDatas()) or {}
  self.profitRightListCtrl:ResetDatas(attrGemData)
  tickManager:CreateOnceDelayTick(33, function()
    if not self or not self.profitLeftListCtrl then
      return
    end
    self.profitLeftListCtrl:ResetPosition()
  end, self)
end

function GemEmbedPreviewPage:InitRight()
  self:InitGemTipCell()
end

function GemEmbedPreviewPage:InitGemTipCell()
  self.gemTipCellGO = self:FindGO("GemTipCell")
  self.gemTipCell = ItemTipGemCell.new(self.gemTipCellGO)
  local closeBtn = self:FindGO("CloseCellBtn", self.gemTipCellGO)
  self:AddClickEvent(closeBtn, function()
    self:CloseGemTipCell()
  end)
end

function GemEmbedPreviewPage:InitHelpButton()
  local go = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(1006, nil, go)
end

local _BgTexture = "rune_bg"

function GemEmbedPreviewPage:InitGemPage()
  self.mask = self:FindGO("Mask")
  self.bgTexture = self:FindComponent("ContainerTexture", UITexture)
  if self.bgTexture then
    PictureManager.Instance:SetUI(_BgTexture, self.bgTexture)
  end
  local container = self:FindGO("GemPageContainer")
  local gemPagePanel = container:GetComponent(UIPanel)
  if gemPagePanel then
    gemPagePanel.alpha = 0
    LeanTweenUtil.UIAlpha(gemPagePanel, 0, 1, 3, 0)
  end
  local viewData = self.container.viewdata.viewdata
  local previewGemItemData
  if viewData and viewData.saveId and viewData.saveType then
    previewGemItemData = SaveInfoProxy.Instance:GetGemData(viewData.saveId, viewData.saveType) or {}
    self.gemPageProfession = SaveInfoProxy.Instance:GetProfession(viewData.saveId, viewData.saveType)
    self.heroFeatureLv = SaveInfoProxy.Instance:GetHeroFeatureLv(viewData.saveId, viewData.saveType)
  end
  self.gemPage = GemPage.new(container, previewGemItemData)
  self.gemPage:AddEventListener(MouseEvent.MouseClick, self.OnClickPageCell, self)
  self.gemPageTrans = self.gemPage.gameObject.transform
  self.newPageLocalPos = LuaVector3.Zero()
end

function GemEmbedPreviewPage:OnEnter()
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  GemEmbedPreviewPage.super.OnEnter(self)
  local prefGemPageSkillCellCount = FunctionPlayerPrefs.Me():GetInt(GemProxy.PageSkillCellCountSaveKey, 0, false)
  local isPageNewVersion = self.gemPage.skillCellCount ~= prefGemPageSkillCellCount
  self.gemPage:Update(true, isPageNewVersion)
  self.mask:SetActive(false)
  if isPageNewVersion then
    self.mask:SetActive(true)
    self.pageNewVersionTween = TimeTickManager.Me():CreateOnceDelayTick(4200, function(owner, deltaTime)
      self.mask:SetActive(false)
      self.gemPage:DestroyAllEffectsOfUnembeddedCells()
      self.pageNewVersionTween = nil
    end, self)
    FunctionPlayerPrefs.Me():SetInt(GemProxy.PageSkillCellCountSaveKey, self.gemPage.skillCellCount, false)
  end
  self:OnActivate()
end

function GemEmbedPreviewPage:OnActivate()
  self:ShowGemTipWith()
  self.isPageAside = false
  self.gemPageTrans.localPosition = LuaVector3.Zero()
  self.gemPageTrans.localScale = LuaVector3.One()
  LuaVector3.Better_Set(self.newPageLocalPos, 0, 0, 0)
  self:_OnActivate()
end

function GemEmbedPreviewPage:_OnActivate()
  self.gemPage:SetShowNameTips(true)
  self.gemPage:SetCellsDragEnable(false)
end

function GemEmbedPreviewPage:OnExit()
  if self.gemTipCell then
    self.gemTipCell:OnDestroy()
  end
  GemProxy.Instance.choosePageCellID = nil
  GemEmbedPreviewPage.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.gemPage:OnExit()
  if self.pageNewVersionTween then
    self.pageNewVersionTween:Destroy()
  end
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI(_BgTexture, self.bgTexture)
  end
end

function GemEmbedPreviewPage:ClearChoosePageID()
  if self.choosePageCell then
    self.choosePageCell:SetChoose(false)
    self.choosePageCell = nil
  end
  GemProxy.Instance.choosePageCellID = nil
end

function GemEmbedPreviewPage:OnClickPageCell(cellCtl)
  if self.choosePageCell then
    if self.choosePageCell.id == cellCtl.id then
      return
    end
    self.choosePageCell:SetChoose(false)
    self.choosePageCell = nil
  end
  self.choosePageCell = cellCtl
  self.choosePageCell:SetChoose(true)
  GemProxy.Instance.choosePageCellID = self.choosePageCell.id
  self:_OnClickPageCell(cellCtl)
end

function GemEmbedPreviewPage:_OnClickPageCell(cellCtl)
  local data = cellCtl.data
  if not GemProxy.CheckContainsGemSkillData(data) then
    data = nil
  end
  if self.isPageAside then
    if data then
      self:ShowGemTipWith(data)
    else
      self:SetPageAside(false)
    end
    return
  end
  if data then
    self:ShowGemTipWith(data)
    self:SetPageAside(true)
  end
end

function GemEmbedPreviewPage:CloseGemTipCell()
  self:SetPageAside(false)
end

function GemEmbedPreviewPage:ResetGemTipCellPos()
  self:ChangeLocalPositionOfTrans(self.gemTipCellGO.transform, function(pos)
    pos.x = 30
  end)
end

function GemEmbedPreviewPage:ShowGemTipWith(tipData)
  self.gemTipCellGO:SetActive(tipData and true or false)
  if tipData then
    self.gemTipCell:SetData(tipData, true)
  else
    self:ResetGemTipCellPos()
  end
end

function GemEmbedPreviewPage:SetPageAside(isAside)
  isAside = isAside and true or false
  self.isPageAside = self.isPageAside or false
  if self.isPageAside == isAside then
    return
  else
    self.isPageAside = isAside
  end
  if not self.gemPage then
    LogUtility.Warning("Cannot find GemPage")
    return
  end
  self.newPageLocalPos[1] = asideTranslationX * (self.isPageAside and 1 or -1) + self.newPageLocalPos[1]
  self.newPageLocalPos[2] = self.gemPageTrans.localPosition.y
  self:ClampSet(self.newPageLocalPos)
  self:DoDefaultPositionTween(self.gemPage.gameObject, self.newPageLocalPos)
  if not self.isPageAside then
    self:ShowGemTipWith()
    self:ClearChoosePageID()
  end
end

function GemEmbedPreviewPage:DoDefaultPositionTween(go, pos)
  local t = TweenPosition.Begin(go, GemEmbedPreviewPage.TweenDuration, pos)
  t.method = 2
end

function GemEmbedPreviewPage:ChangeLocalPositionOfTrans(transform, func)
  local tempV3 = LuaGeometry.TempGetLocalPosition(transform)
  func(tempV3)
  transform.localPosition = tempV3
end

function GemEmbedPreviewPage:ChangeLocalEulerAnglesOfTrans(transform, func)
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalEulerAngles(transform))
  func(tempV3)
  transform.localEulerAngles = tempV3
end

function GemEmbedPreviewPage:ClampSet(v3)
  v3[1] = math.clamp(v3[1], minPageLocalPosX, maxPageLocalPosX)
  v3[2] = math.clamp(v3[2], minPageLocalPosY, maxPageLocalPosY)
  return v3
end
