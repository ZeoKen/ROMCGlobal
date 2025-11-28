autoImport("PveSkillPage")
autoImport("PveSummonPage")
autoImport("PveIntroductionPage")
local _CatalogText = {
  [1] = ZhString.Pve_MonsterPopup_Catalog1,
  [2] = ZhString.Pve_MonsterPopup_Catalog2,
  [3] = ZhString.Pve_MonsterPopup_Catalog3
}
local _ModelTexture = "Novicecopy_bg_01"
local _BgTexture = "calendar_bg1_picture2"
local _PicMrg
local _RaceConfig = GameConfig.MonsterAttr.Race
local _ShapeConfig = GameConfig.MonsterAttr.Body
local monsterPos = LuaVector3.Zero()
local _TogColor = {
  ChoosenColor = Color(0.25098039215686274, 0.34901960784313724, 0.6588235294117647, 1),
  UnChoosenColor = Color(0.2901960784313726, 0.5647058823529412, 0.803921568627451, 1)
}
local _defaultLoadPos = {
  0,
  0,
  0
}
PveMonsterPopUp = class("PveMonsterPopUp", ContainerView)
PveMonsterPopUp.ViewType = UIViewType.PopUpLayer

function PveMonsterPopUp:Init()
  _PicMrg = PictureManager.Instance
  self:FindObjs()
  self:InitUI()
  self:InitTabChange()
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    self:CloseSelf()
  end
end

function PveMonsterPopUp:InitTabChange()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end

function PveMonsterPopUp:FindObjs()
  local bgRoot = self:FindGO("BgRoot")
  self.bgTexture = self:FindComponent("BgTexture", UITexture, bgRoot)
  local leftRoot = self:FindGO("LeftRoot")
  self.shapeRaceLab = self:FindComponent("ShapeRaceLab", UILabel, leftRoot)
  self.modelBgTexture = self:FindComponent("BgTexture", UITexture, leftRoot)
  self.monsterNameLab = self:FindComponent("NameLab", UILabel, leftRoot)
  self.modelTexture = self:FindComponent("ModelTexture", UITexture, leftRoot)
  local objRotateRole = self:FindGO("RotateRoleCollider", leftRoot)
  self.objRotateRoleArrows = self:FindGO("RotateRoleArrows", leftRoot)
  self:AddDragEvent(objRotateRole, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self:AddPressEvent(objRotateRole, function(go, isPress)
    self:PressRoleEvt(go, isPress)
  end)
  local rightRoot = self:FindGO("RightRoot")
  self.rightRootGrid = rightRoot:GetComponent(UIGrid)
  self.togs = {}
  self.togs[1] = self:FindGO("Skill", rightRoot)
  self.togs[2] = self:FindGO("Summon", rightRoot)
  self.togs[3] = self:FindGO("Introdution", rightRoot)
  self.togSprites = {}
  self.togSprites[1] = self.togs[1]:GetComponent(UISprite)
  self.togSprites[2] = self.togs[2]:GetComponent(UISprite)
  self.togSprites[3] = self.togs[3]:GetComponent(UISprite)
  local centerRoot = self:FindGO("CenterRoot")
  local closeTipLab = self:FindComponent("CloseTip", UILabel, centerRoot)
  closeTipLab.text = ZhString.Pve_CloseTip
  self.togTargets = {}
  self.togTargets[1] = self:FindGO("SkillPageRoot", centerRoot)
  self.togTargets[2] = self:FindGO("SummonPageRoot", centerRoot)
  self.togTargets[3] = self:FindGO("IntrodutionPageRoot", centerRoot)
  self.catalogDescLab = self:FindComponent("CatalogDesc", UILabel, centerRoot)
  self.dragScrollView = self:FindComponent("DragScrollView", UIDragScrollView)
  self.subScrollViews = {}
  self.subScrollViews[1] = self:FindComponent("ScrollView", UIScrollView, self.togTargets[1])
  self.subScrollViews[2] = self:FindComponent("ScrollView", UIScrollView, self.togTargets[2])
  self.subScrollViews[3] = self:FindComponent("ScrollView", UIScrollView, self.togTargets[3])
  self.nextBtn = self:FindGO("NextBtn")
  self.preBtn = self:FindGO("PreBtn")
  self:AddClickEvent(self.nextBtn, function()
    self:ToNextMonster()
  end)
  self:AddClickEvent(self.preBtn, function()
    self:ToPreMonster()
  end)
end

function PveMonsterPopUp:ToNextMonster()
  if self.monstersData and #self.monstersData <= 1 then
    return
  end
  if self.monsterIndex >= #self.monstersData then
    self.monsterIndex = 1
  else
    self.monsterIndex = self.monsterIndex + 1
  end
  self:ChangeMonster()
end

function PveMonsterPopUp:ToPreMonster()
  if self.monstersData and #self.monstersData <= 1 then
    return
  end
  if 1 >= self.monsterIndex then
    self.monsterIndex = #self.monstersData
  else
    self.monsterIndex = self.monsterIndex - 1
  end
  self:ChangeMonster()
end

function PveMonsterPopUp:ChangeMonster()
  self.monsterID = self.monstersData[self.monsterIndex]
  redlog("self.monsterIDz;", self.monsterID)
  self.previewData = Table_PveMonsterPreview[self.monsterID]
  if not self.previewData then
    redlog("未找到 Table_PveMonsterPreview id ： ", self.monsterID)
    return
  end
  self.togs[2]:SetActive(nil ~= next(self.previewData.Summon))
  self.rightRootGrid:Reposition()
  self:SetViewInfo()
  self.curKey = nil
  self:TabChangeHandler(1)
end

function PveMonsterPopUp:InitUI()
  self:AddTabChangeEvent(self.togs[1], self.togTargets[1], PanelConfig.PveSkillPage)
  self:AddTabChangeEvent(self.togs[2], self.togTargets[2], PanelConfig.PveSummonPage)
  self:AddTabChangeEvent(self.togs[3], self.togTargets[3], PanelConfig.PveIntroductionPage)
  self.viewdata.view.tab = 1
end

function PveMonsterPopUp:OnEnter()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.monstersData = viewdata.monstersData
    local multiMonster = #self.monstersData > 1
    self.nextBtn:SetActive(multiMonster)
    self.preBtn:SetActive(multiMonster)
    self.monsterIndex = viewdata.monsterIndex
    self.monsterID = self.monstersData[self.monsterIndex]
    self.previewData = Table_PveMonsterPreview[self.monsterID]
    if not self.previewData then
      redlog("未找到 Table_PveMonsterPreview id ： ", self.monsterID)
      return
    end
  end
  PveMonsterPopUp.super.OnEnter(self)
  _PicMrg:SetUI(_BgTexture, self.bgTexture)
  _PicMrg:SetUI(_ModelTexture, self.modelBgTexture)
  self.togs[2]:SetActive(nil ~= next(self.previewData.Summon))
  self.rightRootGrid:Reposition()
  self:SetViewInfo()
end

function PveMonsterPopUp:SetViewInfo()
  self.monsterStaticData = Table_Monster[self.monsterID]
  if nil == self.monsterStaticData then
    redlog("策划未配置monsterID： ", self.monsterID)
  end
  local shape = _ShapeConfig[self.monsterStaticData.Shape]
  local race = _RaceConfig[self.monsterStaticData.Race]
  self.shapeRaceLab.text = string.format(ZhString.Pve_Shape_Race, shape, race)
  self.monsterNameLab.text = self.monsterStaticData.NameZh
  self:SetModelTexture()
end

function PveMonsterPopUp:SetModelTexture()
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  UIModelUtil.Instance:SetMonsterModelTexture(self.modelTexture, self.monsterID, nil, nil, function(obj)
    if obj then
      self.monsterAssetRole = obj
      local showPos = self.previewData.LoadShowPose or _defaultLoadPos
      LuaVector3.Better_Set(monsterPos, showPos[1], showPos[2], showPos[3])
      self.monsterAssetRole:SetPosition(monsterPos)
      self.monsterAssetRole:SetEulerAngleY(self.previewData.LoadShowRotate or 0)
      local size = self.previewData.LoadShowSize or 1
      self.monsterAssetRole:SetScale(size)
      UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
    end
  end)
end

function PveMonsterPopUp:ClearMonster()
  if self.monsterAssetRole and self.monsterAssetRole:Alive() then
    self.monsterAssetRole:Destroy()
    self.monsterAssetRole = nil
  end
end

function PveMonsterPopUp:PressRoleEvt(go, isPress)
  if self.monsterAssetRole then
    self.objRotateRoleArrows:SetActive(isPress)
  end
end

function PveMonsterPopUp:RotateRoleEvt(go, delta)
  if self.monsterAssetRole then
    self.monsterAssetRole:RotateDelta(-delta.x * 360 / 400)
  end
end

function PveMonsterPopUp:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  self.curKey = key
  PveMonsterPopUp.super.TabChangeHandler(self, key)
  if PanelConfig.PveSkillPage.tab == key then
    if not self.skillPage then
      self.skillPage = self:AddSubView("PveSkillPage", PveSkillPage)
    else
      self.skillPage:Reset()
    end
  elseif PanelConfig.PveSummonPage.tab == key then
    if not self.summonPage then
      self.summonPage = self:AddSubView("PveSummonPage", PveSummonPage)
    else
      self.summonPage:Reset()
      self.summonPage:ResetSkillPosition()
    end
  elseif PanelConfig.PveIntroductionPage.tab == key then
    if not self.introdutionPage then
      self.introdutionPage = self:AddSubView("PveIntroductionPage", PveIntroductionPage)
    else
      self.introdutionPage:Reset()
    end
  end
  self.catalogDescLab.text = _CatalogText[key]
  if key == PanelConfig.PveSummonPage.tab then
    self:Hide(self.dragScrollView)
  else
    self:Show(self.dragScrollView)
    self.dragScrollView.scrollView = self.subScrollViews[key]
  end
  self.subScrollViews[key]:ResetPosition()
  for i = 1, #self.togSprites do
    self.togSprites[i].color = key == i and _TogColor.ChoosenColor or _TogColor.UnChoosenColor
  end
end

function PveMonsterPopUp:OnExit()
  _PicMrg:UnLoadUI(_BgTexture, self.bgTexture)
  _PicMrg:UnLoadUI(_ModelTexture, self.modelBgTexture)
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  self:ClearMonster()
  PveMonsterPopUp.super.OnExit(self)
end
