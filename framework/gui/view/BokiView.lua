autoImport("QuickItemCell")
autoImport("BokiEquipItem")
autoImport("PetInfoLabelCell")
BokiView = class("BokiView", SubView)
local attrColor = Color(0.8274509803921568, 0.9529411764705882, 0.984313725490196, 1)
local outlineColor = Color(0.2196078431372549, 0.2627450980392157, 0.38823529411764707, 0.7372549019607844)
local SUB_VIEW_PATH = ResourcePathHelper.UIView("BokiView")
local BGTEXTURE = {"fb_bg", "fb_bg_wave"}
local _bokiProxy, _lvHelpId, _bodyCfg

function BokiView:Init()
  _lvHelpId = GameConfig.BoKiConfig and GameConfig.BoKiConfig.BoKiLevelHelpID or 1
  _bodyCfg = GameConfig.BoKiConfig and GameConfig.BoKiConfig.BoKiBody and GameConfig.BoKiConfig.BoKiBody.normal
  _bokiProxy = BokiProxy.Instance
  self.gameObject = self:LoadPreferb_ByFullPath(SUB_VIEW_PATH, self.container.bokiObj, true)
  self:FindObjs()
  self:AddUIEvts()
  self:InitView()
end

function BokiView:FindObjs()
  local bg = self:FindGO("Bg")
  self.bgTex = self:FindComponent("BgTex", UITexture, bg)
  self.waveTex = self:FindComponent("WaveTex", UITexture, bg)
  self.infoRoot = self:FindGO("InfoRoot")
  self.infoRoot:SetActive(true)
  self.nameLab = self:FindComponent("Name", UILabel, self.infoRoot)
  self.phaseFixed = self:FindComponent("Phase", UILabel, self.infoRoot)
  self.phaseFixed.text = ZhString.Boki_Phase
  self.phaseLab = self:FindComponent("PhaseLab", UILabel, self.phaseFixed.gameObject)
  self.lvFixed = self:FindComponent("Level", UILabel, self.infoRoot)
  self.lvFixed.text = string.format(ZhString.Boki_Lv)
  self.expSlider = self:FindComponent("ExpSlider", UISlider, self.lvFixed.gameObject)
  self.lvLab = self:FindComponent("LevelLab", UILabel, self.lvFixed.gameObject)
  self.lvHelpBtn = self:FindGO("LevelHelpBtn", self.lvFixed.gameObject)
  self:InitEquipItems()
  self.equipRoot = self:FindGO("EquipInfoRoot")
  self.equipRoot:SetActive(false)
  local leftEquipGrid = self:FindComponent("LeftEquipGrid", UIGrid)
  local rigthEquipGrid = self:FindComponent("RigthEquipGrid", UIGrid)
  self.leftEquipCtl = UIGridListCtrl.new(leftEquipGrid, BokiEquipItem, "BokiEquipItem")
  self.leftEquipCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickEquipItem, self)
  self.rigthEquipCtl = UIGridListCtrl.new(rigthEquipGrid, BokiEquipItem, "BokiEquipItem")
  self.rigthEquipCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickEquipItem, self)
  self.returnViewBtn = self:FindGO("ReturnBtn", self.equipRoot)
  local modelRoot = self:FindGO("ModelRoot")
  self.modelTex = self:FindComponent("ModelTexture", UITexture, modelRoot)
  self.equipAttrRoot = self:FindGO("AttrRoot", self.equipRoot)
  self.equipGetWayRoot = self:FindGO("GetWayRoot", self.equipRoot)
  self.equipLvupRoot = self:FindGO("LvUpRoot", self.equipRoot)
  self.goUpgradeBtn = self:FindGO("GoUpgradeBtn", self.equipAttrRoot)
  self.getBtn = self:FindGO("GetBtn", self.equipAttrRoot)
  self.maxLv = self:FindGO("MaxLv", self.equipAttrRoot)
  self.upgradeBtn = self:FindComponent("UpgradeBtn", UISprite, self.equipLvupRoot)
  self.upgradeBtnLab = self:FindComponent("Label", UILabel, self.upgradeBtn.gameObject)
  self.upgradeShadowBtn = self:FindComponent("BtnShadow", UISprite, self.upgradeBtn.gameObject)
  self.costRoot = self:FindGO("CostRoot", self.upgradeBtn.gameObject)
  self.UpgradeCostIcon = self:FindComponent("CostIcon", UISprite, self.costRoot)
  self.UpgradeCostNum = self:FindComponent("CostNum", UILabel, self.costRoot)
  self.lackMaterial = self:FindGO("LackMaterial", self.upgradeBtn.gameObject)
  local costGrid = self:FindComponent("CostGrid", UIGrid)
  self.costCtl = UIGridListCtrl.new(costGrid, QuickItemCell, "QuickItemCell")
  self.costCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickCostCell, self)
  self.newSpecAttrLab = self:FindComponent("NewSpecAttr", UILabel, self.equipLvupRoot)
  local sixAttrRoot = self:FindGO("SixAttrRoot")
  self.changeRqByTex = self:FindComponent("occupy", ChangeRqByTex, sixAttrRoot)
  self.abilityPolygon = self:FindChild("PowerPolygo", sixAttrRoot):GetComponent(PolygonSprite)
  self.abilityPolygon:ReBuildPolygon()
  self.abilityPolygonDots = {}
  local fixAttrDots = self:FindGO("fixAttrDots", sixAttrRoot)
  table.insert(self.abilityPolygonDots, self:FindGO("Str", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Int", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Dex", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Luk", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Agi", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Vit", fixAttrDots).transform:GetChild(0))
  self.effectContainer = self:FindGO("EffectContainer")
  self.specAttrLab = self:FindComponent("SpecAttrLab", UILabel)
  self.attriGrid = self:FindGO("attriGrid"):GetComponent(UIGrid)
  self.attrList = UIGridListCtrl.new(self.attriGrid, PetInfoLabelCell, "PetInfoLabelCell")
  self.lvupAttriGrid = self:FindGO("LvupAttriGrid"):GetComponent(UIGrid)
  self.lvupAttriList = UIGridListCtrl.new(self.lvupAttriGrid, PetInfoLabelCell, "PetInfoLabelCell")
  self.creaturePropTable = self:FindComponent("CreaturePropTable", UITable)
  self.creaturePropCtl = UIGridListCtrl.new(self.creaturePropTable, PetInfoLabelCell, "PetInfoLabelCell")
  self.addWayLab = self:FindComponent("AddWayLab", UILabel, self.equipGetWayRoot)
  self.addWayGO = self:FindGO("AddWayGo", self.equipGetWayRoot)
end

function BokiView:UpdateCreatureProps()
  BokiProxy.Instance:ResetBokiProps()
  local data = _bokiProxy:GetSceneBokiProps()
  local result = {}
  local myBoki = _bokiProxy:GetSceneBoki()
  local maxHp = myBoki and myBoki.data:GetProperty("MaxHp") or 0
  for i = 1, #data do
    local temp = ReusableTable.CreateArray()
    temp[1] = PetInfoLabelCell.Type.Attri
    temp[2] = data[i].displayName
    temp[3] = data[i].isPercent and data[i].value * 100 .. "%" or data[i].value
    temp[4] = 280
    temp[5] = 18
    temp[6] = attrColor
    temp[7] = attrColor
    temp[8] = UILabel.Effect.Shadow
    temp[9] = UILabel.Effect.Shadow
    temp[10] = outlineColor
    if data[i].displayName == "Hp" then
      temp[3] = temp[3] .. "/" .. maxHp
      temp[12] = data[i].value / maxHp
    end
    result[#result + 1] = temp
  end
  self.creaturePropCtl:ResetDatas(result)
  self.creaturePropCtl:ResetPosition()
end

function BokiView:UpdateTotalAttr()
  if nil == self.curEquip then
    return
  end
  local totalAttrMap = self.curEquip.totalAttrMap
  local result = {}
  for PropName, value in pairs(totalAttrMap) do
    local temp = ReusableTable.CreateArray()
    temp[1] = PetInfoLabelCell.Type.Attri
    temp[2] = PropName
    temp[3] = value.isPercent and value.value * 100 .. "%" or value.value
    temp[4] = 360
    temp[5] = 22
    temp[6] = attrColor
    temp[7] = attrColor
    temp[8] = UILabel.Effect.Shadow
    temp[9] = UILabel.Effect.Shadow
    temp[10] = outlineColor
    result[#result + 1] = temp
  end
  self.attrList:ResetDatas(result)
  self.attrList:ResetPosition()
end

function BokiView:UpdateNextLvupAttr()
  if nil == self.curEquip then
    return
  end
  local nextAttrMap = self.curEquip.nextAttrMap
  if not nextAttrMap then
    return
  end
  local result = {}
  for PropName, tab in pairs(nextAttrMap) do
    local temp = ReusableTable.CreateArray()
    temp[1] = PetInfoLabelCell.Type.Diff
    temp[2] = PropName
    temp[3] = tab.isPercent and tab.original * 100 .. "%" or tab.original
    temp[4] = tab.isPercent and tab.new * 100 .. "%" or tab.new
    result[#result + 1] = temp
  end
  self.lvupAttriList:ResetDatas(result)
  self.lvupAttriList:ResetPosition()
end

function BokiView:AddUIEvts()
  self:RegistShowGeneralHelpByHelpID(_lvHelpId, self.lvHelpBtn)
  self:AddClickEvent(self.returnViewBtn, function(go)
    self.container.tabRoot:SetActive(true)
    self.infoRoot:SetActive(true)
    self.equipRoot:SetActive(false)
    self:InitSixBaseProps()
    self:InitEquipInfoRoot()
  end)
  self:AddClickEvent(self.getBtn, function(go)
    self:OnClickGetBtn()
  end)
  self:AddClickEvent(self.goUpgradeBtn, function(go)
    self:OnClickGoUpgrade()
  end)
  self:AddClickEvent(self.upgradeBtn.gameObject, function(go)
    self:OnClickUpgrade()
  end)
  self:AddClickEvent(self.addWayGO, function(go)
    FuncShortCutFunc.Me():CallByID(self.addWayGoIDs)
    if self.container then
      self.container:CloseSelf()
    end
  end)
end

function BokiView:InitEquipInfoRoot()
  self.equipAttrRoot:SetActive(true)
  self.equipLvupRoot:SetActive(false)
  self.equipGetWayRoot:SetActive(false)
end

function BokiView:InitSixBaseProps()
  local attris = _bokiProxy.sixBaseProps
  if nil ~= attris and 0 < #attris then
    for i = 1, #attris do
      local value = attris[i] / 210 * 100
      self.abilityPolygon:SetLength(i - 1, value)
      self.abilityPolygonDots[i].localPosition = LuaGeometry.GetTempVector3(value, 0, 0)
    end
  end
end

local tempVector3, quaternion = LuaVector3.Zero()

function BokiView:InitModel()
  if nil == _bodyCfg then
    redlog("GameConfig.BoKiConfig.BoKiBody 未配置")
    return
  end
  local bodyId = _bokiProxy.stage and _bodyCfg[_bokiProxy.stage]
  if nil == bodyId then
    return
  end
  local size = _bokiProxy.stage == 3 and 0.5 or 1
  self.modelCameraConfig = UIModelCameraTrans.Boki
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  parts[partIndex.Body] = bodyId
  self.modelTex:ResetAndUpdateAnchors()
  UIModelUtil.Instance:ChangeBGMeshRenderer(BGTEXTURE[1], self.modelTex)
  self:PlayUIEffect(EffectMap.UI.Eff_Blossom_wave, self.effectContainer, false)
  self.role = UIModelUtil.Instance:SetRoleModelTexture(self.modelTex, parts, self.modelCameraConfig, nil, nil, nil, nil, function(obj)
    self.role = obj
    UIUtil.ChangeLayer(obj:GetRoleComplete().gameObject, Game.ELayer.UIModel)
    obj.complete.ShadowCastEnable = false
  end)
  LuaVector3.Better_Set(tempVector3, 1.01, -1.06, 3.63)
  quaternion = LuaQuaternion.Euler(0, -20, 0)
  self.role:SetPosition(tempVector3)
  self.role:SetRotation(quaternion)
  self.role:SetScale(size)
  Asset_Role.DestroyPartArray(parts)
end

function BokiView:UpdateSceneBokiAttr()
  self.bokiData = SceneCreatureProxy.FindCreature(cat.id) and SceneCreatureProxy.FindCreature(cat.id).data
end

function BokiView:InitEquipItems()
  self.equipItemTab = {}
  local equipItemRoot = self:FindGO("EquipRoot")
  local cellRoot
  for i = 1, 6 do
    cellRoot = self:FindGO("ItemPos" .. i, equipItemRoot)
    local obj = self:LoadPreferb("cell/BokiEquipItem", cellRoot)
    obj.name = "BokiEquipItem" .. i
    self.equipItemTab[i] = BokiEquipItem.new(obj)
    self.equipItemTab[i]:AddEventListener(MouseEvent.MouseClick, self.OnClickEquipTabItem, self)
  end
end

function BokiView:UpdateEquip()
  local data = _bokiProxy:GetEquipList()
  local leftData, rightData = {}, {}
  for i = 1, 6 do
    self.equipItemTab[i]:SetData(data[i])
    if i < 4 then
      leftData[#leftData + 1] = data[i]
    else
      rightData[#rightData + 1] = data[i]
    end
  end
  self.leftEquipCtl:ResetDatas(leftData)
  self.rigthEquipCtl:ResetDatas(rightData)
end

function BokiView:OnClickEquipTabItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data then
    self.container.tabRoot:SetActive(false)
    self.infoRoot:SetActive(false)
    self.equipRoot:SetActive(true)
    self.changeRqByTex.RenderQ = 0
    self.curClickBokiEquipPos = data.pos
    self:SwitchToEquipRoot(self.curClickBokiEquipPos)
  end
end

function BokiView:SwitchToEquipRoot(fromPos)
  local cells
  cells = self.leftEquipCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data.pos == fromPos then
      self:OnClickEquipItem(cells[i])
      return
    end
  end
  cells = self.rigthEquipCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data.pos == fromPos then
      self:OnClickEquipItem(cells[i])
      return
    end
  end
end

function BokiView:OnClickEquipItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if data and self.curEquip ~= data then
    self.curEquip = data
    self.curClickBokiEquipPos = data.pos
    self:InitEquipInfoRoot()
    self:UpdateRightBtn()
    self:UpdateSpecAttr()
    self:UpdateTotalAttr()
    self:UpdateChooseEquip()
    self:UpdateCost()
    self:UpdateNextLvupAttr()
  end
end

function BokiView:UpdateChooseEquip()
  local cells = self.leftEquipCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(self.curClickBokiEquipPos)
  end
  local cells = self.rigthEquipCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(self.curClickBokiEquipPos)
  end
end

function BokiView:UpdateSpecAttr()
  local pos = self.curClickBokiEquipPos
  local data = _bokiProxy:GetSpecBuffByPos(pos)
  if nil ~= data and 0 < #data then
    local desc = ""
    for i = 1, #data do
      if i == #data then
        desc = desc .. data[i].desc
      else
        desc = desc .. data[i].desc .. "\n"
      end
    end
    self.specAttrLab.text = desc
  else
    self.specAttrLab.text = ""
  end
end

function BokiView:OnClickCostCell(cellCtl)
  if not self.ShowTip then
    local callback = function()
      self.ShowTip = false
    end
    local sdata = {
      itemdata = cellCtl.data,
      ignoreBounds = cellCtl.gameObject,
      callback = callback
    }
    self:ShowItemTip(sdata, self.bg, NGUIUtil.AnchorSide.Left, {-180, 0})
  else
    self:ShowItemTip()
  end
  self.ShowTip = not self.ShowTip
end

local btn_name_cfg = {
  updateBtnSp = {
    "new-com_btn_03",
    "new-com_btn_02"
  },
  BtnShadowSP = {
    "fb_bg_daoying_02",
    "fb_bg_daoying_01"
  },
  Outline = {
    ColorUtil.NGUIGray,
    Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  }
}

function BokiView:UpdateCost()
  if nil == self.curEquip then
    return
  end
  local costcfg = self.curEquip and self.curEquip.staticData and self.curEquip.staticData.MoneyCost
  if nil ~= costcfg and nil ~= costcfg.item then
    self.costRoot:SetActive(true)
    local icon = Table_Item[costcfg.item] and Table_Item[costcfg.item].Icon or ""
    IconManager:SetItemIcon(icon, self.UpgradeCostIcon)
    self.UpgradeCostNum.text = costcfg.count or 0
    LuaVector3.Better_Set(tempVector3, -55, 2, 0)
  else
    self.costRoot:SetActive(false)
    LuaVector3.Better_Set(tempVector3, 0, 2, 0)
  end
  local costData = self.curEquip:GetCostData()
  self.isCurEquipLackMat = false
  local _bagProxy = BagProxy.Instance
  for i = 1, #costData do
    if costData[i].num > _bagProxy:GetItemNumByStaticID(costData[i].staticData.id, _bokiProxy.checkPackage) then
      self.isCurEquipLackMat = true
      break
    end
  end
  self.lackMaterial:SetActive(self.isCurEquipLackMat)
  self.upgradeBtn.spriteName = self.isCurEquipLackMat and btn_name_cfg.updateBtnSp[1] or btn_name_cfg.updateBtnSp[2]
  self.upgradeShadowBtn.spriteName = self.isCurEquipLackMat and btn_name_cfg.BtnShadowSP[1] or btn_name_cfg.BtnShadowSP[2]
  self.upgradeBtnLab.effectColor = self.isCurEquipLackMat and btn_name_cfg.Outline[1] or btn_name_cfg.Outline[2]
  self.upgradeBtnLab.gameObject.transform.localPosition = tempVector3
  self.costCtl:ResetDatas(costData)
end

function BokiView:OnClickGoUpgrade()
  if nil == self.curEquip then
    return
  end
  self.equipLvupRoot:SetActive(true)
  self.equipAttrRoot:SetActive(false)
  self.equipGetWayRoot:SetActive(false)
  self:RefreshUpgrade()
end

function BokiView:UpdateNewSpecAttrLab()
  if nil == self.curEquip then
    return
  end
  local specDesc = self.curEquip.newSpecDesc
  if specDesc then
    self.newSpecAttrLab.gameObject:SetActive(true)
    self.newSpecAttrLab.text = specDesc
  else
    self.newSpecAttrLab.gameObject:SetActive(false)
  end
end

function BokiView:RefreshUpgrade()
  if nil == self.curEquip then
    return
  end
  self.curEquip = _bokiProxy.equipMap[self.curEquip.pos]
  self:UpdateNewSpecAttrLab()
  self:UpdateCost()
  self:UpdateNextLvupAttr()
  self:UpdateTotalAttr()
  self:UpdateRightBtn()
  self:UpdateChooseEquip()
end

function BokiView:OnClickGetBtn()
  self.equipLvupRoot:SetActive(false)
  self.equipAttrRoot:SetActive(false)
  self.equipGetWayRoot:SetActive(true)
  self:UpdateAddWay()
end

function BokiView:UpdateAddWay()
  if nil == self.curEquip then
    return
  end
  local addWayCfg = Table_AddWay[self.curEquip.staticData.AddWay or 801]
  self.addWayLab.text = addWayCfg.Desc
  self.addWayGoIDs = addWayCfg.GotoMode
end

function BokiView:OnClickUpgrade()
  if nil == self.curEquip then
    return
  end
  if self.isCurEquipLackMat then
    return
  end
  BokiProxy.Instance:DoEquipLvup(self.curEquip.pos)
end

function BokiView:UpdateRightBtn()
  if nil == self.curEquip then
    return
  end
  if not self.curEquip.unlock then
    self.maxLv:SetActive(false)
    self.getBtn:SetActive(true)
    self.goUpgradeBtn:SetActive(false)
    self.equipAttrRoot:SetActive(true)
    self.equipGetWayRoot:SetActive(false)
    self.equipLvupRoot:SetActive(false)
  elseif self.curEquip.isMaxLv then
    self.maxLv:SetActive(true)
    self.getBtn:SetActive(false)
    self.goUpgradeBtn:SetActive(false)
    self.equipAttrRoot:SetActive(true)
    self.equipGetWayRoot:SetActive(false)
    self.equipLvupRoot:SetActive(false)
  else
    self.maxLv:SetActive(false)
    self.getBtn:SetActive(false)
    self.goUpgradeBtn:SetActive(true)
  end
end

function BokiView:InitView()
  self:InitModel()
  self:InitUpdateBoki()
  self:InitSixBaseProps()
  PictureManager.Instance:SetUI(BGTEXTURE[1], self.bgTex)
  PictureManager.Instance:SetUI(BGTEXTURE[2], self.waveTex)
  self:UpdateCreatureProps()
end

function BokiView:OnExit()
  BokiView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(BGTEXTURE[1], self.bgTex)
  PictureManager.Instance:UnLoadUI(BGTEXTURE[2], self.waveTex)
  UIModelUtil.Instance:ResetTexture(self.modelTex)
end

function BokiView:InitUpdateBoki()
  self:UpdateBokiInfo()
  self:UpdateEquip()
end

function BokiView:UpdateBokiInfo()
  self.nameLab.text = _bokiProxy.bokiMonsterStaticData.NameZh
  local stage = _bokiProxy.stage or 1
  local level = _bokiProxy.level or 1
  if BokiProxy.EPhase.EInfancy == stage then
    self.phaseLab.text = ZhString.Boki_Phase_Infancey
  elseif BokiProxy.EPhase.EGirl == stage then
    self.phaseLab.text = ZhString.Boki_Phase_Girl
  elseif BokiProxy.EPhase.ETeenager == stage then
    self.phaseLab.text = ZhString.Boki_Phase_Teenager
  elseif BokiProxy.EPhase.EAdult == stage then
    self.phaseLab.text = ZhString.Boki_Phase_Adult
  end
  self.lvLab.text = "Lv." .. level
  self.expSlider.value = _bokiProxy.nextLevelConfig and _bokiProxy.exp / _bokiProxy.nextLevelConfig.NextExp or 1
end

function BokiView:HandleBokiAttrSync(note)
  local data = note.body
  if data and data.guid == BokiProxy.Instance:GetBokiGuid() then
    self:UpdateCreatureProps()
  end
end

function BokiView:HandleUpdateBoKiData(note)
  self:UpdateBokiInfo()
  self:UpdateCreatureProps()
end

function BokiView:HandleUpdateBoKiEquip(note)
  self:UpdateEquip()
  self:RefreshUpgrade()
  self:UpdateCreatureProps()
end
