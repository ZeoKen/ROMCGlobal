autoImport("InheritSkillCostPointCell")
autoImport("InheritSkillDragCell")
autoImport("InheritJobSkillCombineCell")
autoImport("InheritSkillMaterialCell")
autoImport("InheritSkillCostPointAttrCell")
InheritSkillView = class("InheritSkillView", ContainerView)
InheritSkillView.ViewType = UIViewType.NormalLayer
local BgName = "skill_inherit_bg_00"
local SkillBgName = "skill_inherit_bg_04"
local EnabledLabelEffectColor = Color(0.6196078431372549, 0.33725490196078434, 0, 1)

function InheritSkillView:Init()
  self.multiSaveId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.saveId
  self.multiSaveType = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.saveType
  self:FindObjs()
  self:AddListenEvts()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.lackMats = {}
end

function InheritSkillView:FindObjs()
  self.bg = self:FindComponent("Bg", UITexture)
  self.skillBg = self:FindComponent("SkillBg", UITexture)
  self.costPointLabel = self:FindComponent("CostPoint", UILabel)
  local grid = self:FindComponent("CostPointGrid", UIGrid)
  self.costPointListCtrl = UIGridListCtrl.new(grid, InheritSkillCostPointCell, "InheritSkillCostPointCell")
  grid = self:FindComponent("EquipSkillGrid", UIGrid)
  self.equipSkillListCtrl = UIGridListCtrl.new(grid, InheritSkillDragCell, "InheritSkillDragCell")
  self.equipSkillListCtrl:AddEventListener(DragDropEvent.SwapObj, self.SwapSkill, self)
  self.equipSkillListCtrl:AddEventListener(DragDropEvent.DropEmpty, self.TakeOffSkill, self)
  self.equipSkillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnEquipSkillClick, self)
  self.addCostBtn = self:FindGO("AddCostBtn")
  self:AddClickEvent(self.addCostBtn, function()
    self:OnAddCostBtnClick()
  end)
  local gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(gotoBtn, function()
    self:OnGotoBtnClick()
  end)
  gotoBtn:SetActive(not self.multiSaveId)
  self.skillScrollView = self:FindComponent("SkillPanel", UIScrollView)
  grid = self:FindGO("SkillGrid")
  self.skillListCtrl = ListCtrl.new(grid, InheritJobSkillCombineCell, "InheritJobSkillCombineCell")
  self.skillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnInheritSkillSelect, self)
  self.skillListCtrl:AddEventListener(InheritSkillEvent.ExpendSkill, self.OnExpendSkill, self)
  local selectSkillCell = self:FindGO("SelectInheritSkillCell")
  self.selectInheritSkillCell = InheritSkillDragCell.new(selectSkillCell)
  self.selectSkillName = self:FindComponent("SelectSkillName", UILabel)
  self.upgradePart = self:FindGO("UpgradeDescPart")
  self.oldDesc = self:FindComponent("OldDesc", UILabel)
  self.oldLv = self:FindComponent("OldLv", UILabel)
  self.newDesc = self:FindComponent("NewDesc", UILabel)
  self.newLv = self:FindComponent("NewLv", UILabel)
  self.noEffectTip = self:FindGO("NoEffectTip")
  self.maxLvPart = self:FindGO("MaxLvPart")
  self.maxLv = self:FindComponent("MaxLv", UILabel)
  self.maxLvDesc = self:FindComponent("MaxLvDesc", UILabel)
  self.materialPart = self:FindGO("MaterialPart")
  self.materialTipLabel = self:FindComponent("MaterialTip", UILabel)
  grid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialListCtrl = UIGridListCtrl.new(grid, InheritSkillMaterialCell, "InheritSkillMaterialCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMaterialItemClick, self)
  self.inheritBtn = self:FindGO("InheritBtn")
  self:AddClickEvent(self.inheritBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.equipUpgradeBtns = self:FindGO("EquipUpgradeBtns")
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.upgradeLabel = self:FindComponent("Label", UILabel, self.upgradeBtn)
  self.equipBtn = self:FindGO("EquipBtn")
  self:AddClickEvent(self.equipBtn, function()
    self:OnEquipBtnClick()
  end)
  self.unequipBtn = self:FindGO("UnequipBtn")
  self:AddClickEvent(self.unequipBtn, function()
    self:OnUnequipBtnClick()
  end)
  self.upgradeTipLabel = self:FindComponent("UpgradeTip", UILabel)
  self.upgradeTip = self:FindGO("UpgradeTipBg")
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32634, helpBtn)
  self.effectContainer = self:FindGO("effectContainer")
  local attrGrid = self:FindComponent("AttrGrid", UIGrid)
  self.costPointAttrListCtrl = UIGridListCtrl.new(attrGrid, InheritSkillCostPointAttrCell, "InheritSkillCostPointAttrCell")
  self.costPointMax = self:FindGO("CostPointMax")
  self.tipLabel = self:FindComponent("TipLabel", UILabel)
  self.tipLabel.text = ZhString.InheritSkill_Tip
  self.materialProgressBar = self:FindComponent("MaterialBar", UIProgressBar)
  self.progressLabel = self:FindComponent("Progress", UILabel)
  self.barSp = self:FindComponent("Foreground", UIMultiSprite)
  self.oldDescScrollView = self:FindComponent("OldDescScrollView", UIScrollView)
  self.newDescScrollView = self:FindComponent("NewDescScrollView", UIScrollView)
  local previewLongPress = self:FindComponent("PreviewBtn", UILongPress)
  if previewLongPress then
    function previewLongPress.pressEvent(obj, isPress)
      if isPress then
        self:ShowMaxLevelPreview()
      else
        TipManager.Instance:CloseTip()
      end
    end
  end
  self.previewBtnSp = self:FindComponent("PreviewBtn", UISprite)
  self.attrExpandBtnSp = self:FindComponent("AttrExpandBtn", UISprite)
  self:AddClickEvent(self.attrExpandBtnSp.gameObject, function()
    self:OnAttrExpandBtnClick()
  end)
  self.attrExpandPanel = self:FindGO("AttrPanel")
  local expandAttrGrid = self:FindComponent("ExpandAttrGrid", UIGrid)
  self.expandAttrListCtrl = UIGridListCtrl.new(expandAttrGrid, InheritSkillCostPointAttrCell, "InheritSkillCostPointAttrCell")
end

function InheritSkillView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SkillUpdateInheritSkillCmd, self.HandleInheritSkillUpdate)
  self:AddListenEvt(ServiceEvent.SkillExtendInheritSkillCmd, self.HandleExtendCostPoint)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function InheritSkillView:OnEnter()
  PictureManager.Instance:SetInheritSkillTexture(BgName, self.bg)
  PictureManager.Instance:SetInheritSkillTexture(SkillBgName, self.skillBg)
  self:RefreshView()
end

function InheritSkillView:OnExit()
  PictureManager.Instance:UnloadInheritSkillTexture(BgName, self.bg)
  PictureManager.Instance:UnloadInheritSkillTexture(SkillBgName, self.skillBg)
end

function InheritSkillView:HandleInheritSkillUpdate()
  self:RefreshView()
  if self.isLvUp then
    self:PlayUIEffect(EffectMap.UI.EquipUpgrade_Success, self.effectContainer, true)
    self.isLvUp = nil
  end
end

function InheritSkillView:HandleExtendCostPoint()
  self:RefreshCostPoint()
end

function InheritSkillView:RefreshView()
  self:RefreshSkills()
  self:RefreshCostPoint()
  local selectCell
  local cells = self.skillListCtrl:GetCells()
  if not self.selectSkillItemData then
    selectCell = cells[1]:GetSkillCells()[1]
  else
    for i = 1, #cells do
      local skillCells = cells[i]:GetSkillCells()
      for j = 1, #skillCells do
        if skillCells[j].data == self.selectSkillItemData then
          selectCell = skillCells[j]
          break
        end
      end
    end
  end
  self:OnInheritSkillSelect(selectCell)
end

function InheritSkillView:SwapSkill(obj)
  local source = obj.data.source
  local target = obj.data.target
  redlog("InheritSkillView:SwapSkill", source and source.data.id, target and target.data.id)
  if not (source and source.data) or source.data == InheritSkillDragCell.Empty or source.data.isLoad then
    return
  end
  if source.data:IsProfessionForbid() then
    MsgManager.ShowMsgByID(43612)
    return
  end
  local costPoint = source.data:GetCostPoint()
  if not InheritSkillProxy.Instance:IsCostPointsEnough(source.data) then
    MsgManager.ShowMsgByID(43613)
    local cells = self.costPointListCtrl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if not cell.data.isLock and (not cell.data.isLeftLoad or not cell.data.isRightLoad) then
        cell:PlayEffect(EffectMap.UI.SkillInherit_CostPointRed)
      end
    end
    return
  end
  if target then
    if target.data == InheritSkillDragCell.Empty then
      redlog("CallLoadInheritSkillCmd", source.data.id)
      ServiceSkillProxy.Instance:CallLoadInheritSkillCmd(source.data.id, nil, 0)
    else
      ServiceSkillProxy.Instance:CallLoadInheritSkillCmd(source.data.id, target.data.id, 0)
    end
  end
end

function InheritSkillView:TakeOffSkill(obj)
  local source = obj.data
  if not (source and source.data) or source.data == InheritSkillDragCell.Empty then
    return
  end
  redlog("InheritSkillView:TakeOffSkill", source.data.id)
  source.dragDrop:SetDragEnable(false)
  ServiceSkillProxy.Instance:CallLoadInheritSkillCmd(source.data.id, nil, 1)
end

function InheritSkillView:OnEquipSkillClick(cell)
  if cell.data and cell.data ~= InheritSkillDragCell.Empty then
    self:ScrollToSkill(cell.data.sortID)
  end
end

function InheritSkillView:RefreshCostPoint()
  local datas = {}
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  local extendPointCost = GameConfig.SkillInherit and GameConfig.SkillInherit.PointExtendCost
  local max = initPoint
  if extendPointCost then
    max = max + #extendPointCost
  end
  local extendedCostPoints = self.multiSaveId and SaveInfoProxy.Instance:GetExtendedCostPoints(self.multiSaveId, self.multiSaveType) or InheritSkillProxy.Instance:GetExtendedCostPoints()
  redlog("InheritSkillView:RefreshCostPoint", extendedCostPoints)
  local costPoints = extendedCostPoints + initPoint
  local loadSkills = self.multiSaveId and SaveInfoProxy.Instance:GetInheritSkillLoadSkills(self.multiSaveId, self.multiSaveType) or InheritSkillProxy.Instance:GetLoadSkills()
  local loadCostPoint = 0
  for i = 1, #loadSkills do
    local loadSkill = loadSkills[i]
    loadCostPoint = loadCostPoint + loadSkill:GetCostPoint()
  end
  for i = 1, NumberUtility.RoundToInt(max / 2) do
    local data = {}
    data.isLock = i > math.ceil(costPoints / 2)
    data.isLeftUnlock = costPoints >= 2 * i - 1
    data.isRightUnlock = costPoints >= 2 * i
    data.isLeftLoad = loadCostPoint >= 2 * i - 1
    data.isRightLoad = loadCostPoint >= 2 * i
    datas[#datas + 1] = data
  end
  self.costPointListCtrl:ResetDatas(datas)
  self.costPointLabel.text = string.format("(%d/%d)", loadCostPoint, costPoints)
  local attrs = self.multiSaveId and SaveInfoProxy.Instance:GetTotalCostPointAttrs(self.multiSaveId, self.multiSaveType, extendedCostPoints) or InheritSkillProxy.Instance:GetTotalCostPointAttrs(extendedCostPoints)
  local count = math.min(#attrs, 4)
  local attrDatas = {}
  for i = 1, count do
    attrDatas[#attrDatas + 1] = attrs[i]
  end
  self.costPointAttrListCtrl:ResetDatas(attrDatas)
  self.expandAttrListCtrl:ResetDatas(attrs)
  self.costPointMax:SetActive(max <= costPoints)
  self.addCostBtn:SetActive(not self.multiSaveId and max > costPoints)
end

local sortFunc = function(l, r)
  if l.profession > 0 and r.profession > 0 then
    return l.profession < r.profession
  end
  return l.profession > 0
end

function InheritSkillView:RefreshSkills()
  local professDatas = self.multiSaveId and SaveInfoProxy.Instance:GetInheritSkillProfessDatas(self.multiSaveId, self.multiSaveType) or InheritSkillProxy.Instance:GetSkillProfessDatas()
  table.sort(professDatas, sortFunc)
  self.skillListCtrl:ResetDatas(professDatas, nil, false)
  if self.multiSaveId then
    local cells = self.skillListCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:UpdateDragable(false)
    end
  end
  self:LayoutSkills()
  self:RefreshLoadSkills()
end

local CellSpace = 10

function InheritSkillView:LayoutSkills()
  local cells = self.skillListCtrl:GetCells()
  local posY = 0
  for i = 1, #cells do
    local cell = cells[i]
    LuaGameObject.SetLocalPositionGO(cell.gameObject, 0, posY, 0)
    posY = posY - cell.height - CellSpace
  end
end

function InheritSkillView:RefreshLoadSkills()
  local datas = {}
  local skills = self.multiSaveId and SaveInfoProxy.Instance:GetInheritSkillLoadSkills(self.multiSaveId, self.multiSaveType) or InheritSkillProxy.Instance:GetLoadSkills()
  local count = #skills < 1 and 1 or #skills + 1
  for i = 1, count do
    local data = skills[i] or InheritSkillDragCell.Empty
    datas[#datas + 1] = data
  end
  self.equipSkillListCtrl:ResetDatas(datas)
  local cells = self.equipSkillListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelect(false)
    if self.multiSaveId then
      cells[i]:UpdateDragable(false)
    end
  end
end

function InheritSkillView:OnInheritSkillSelect(cell)
  if not cell then
    return
  end
  cell:SetSelect(true)
  local cells = self.skillListCtrl:GetCells()
  for i = 1, #cells do
    local skillCells = cells[i]:GetSkillCells()
    for j = 1, #skillCells do
      if skillCells[j].data ~= cell.data then
        skillCells[j]:SetSelect(false)
      end
    end
  end
  self:RefreshSelectSkillInfo(cell.data)
  local cells = self.equipSkillListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data ~= cell.data then
      cells[i]:SetSelect(false)
    else
      cells[i]:SetSelect(true)
    end
  end
end

function InheritSkillView:OnExpendSkill(cell)
  self:LayoutSkills()
end

function InheritSkillView:RefreshSelectSkillInfo(data)
  self.selectSkillItemData = data
  self.selectInheritSkillCell:SetData(data)
  self.selectInheritSkillCell:UpdateDragable(false)
  self.selectSkillName.text = OverSea.LangManager.Instance():GetLangByKey(data.staticData.NameZh)
  local isMaxLv = data:IsMaxLevel()
  self.upgradePart:SetActive(not isMaxLv)
  self.maxLvPart:SetActive(isMaxLv)
  self.materialPart:SetActive(not isMaxLv and data.isUnlock or false)
  self.upgradeTip:SetActive(not data.isUnlock)
  self.noEffectTip:SetActive(not data.isInherited)
  self.upgradeLabel.text = ZhString.InheritSkill_Upgrade
  self.inheritBtn:SetActive(not self.multiSaveId and data.isUnlock and not data.isInherited)
  self.equipUpgradeBtns:SetActive(not self.multiSaveId and data.isInherited)
  self:SetButtonEnable(self.upgradeBtn, not isMaxLv, EnabledLabelEffectColor)
  self.equipBtn:SetActive(not data.isLoad)
  self.unequipBtn:SetActive(data.isLoad)
  self.previewBtnSp.gameObject:SetActive(not isMaxLv)
  if isMaxLv then
    self.upgradeLabel.text = ZhString.InheritSkill_MaxLevel
    self.maxLv.text = string.format(ZhString.InheritSkill_MaxLv, data.maxLevel)
    self.maxLvDesc.text = SkillProxy.GetDesc(data.id)
  elseif not data.isUnlock then
    if data.inheritStaticData and data.inheritStaticData.Condition then
      local condition = data.inheritStaticData.Condition
      local conditionFamilyId = condition // 1000
      local conditionLevel = condition % 1000
      local _, conditionSkill = InheritSkillProxy.Instance:FindSkillByFamilyId(conditionFamilyId)
      local conditionSkillName = conditionSkill and conditionSkill.staticData.NameZh or ""
      self.upgradeTipLabel.text = string.format(ZhString.InheritSkill_UnlockTip, conditionSkillName, conditionLevel)
    end
    self:UpdateCurLevelSkillInfo(data)
    self:UpdateNextLevelSkillInfo(data)
  else
    self:UpdateCurLevelSkillInfo(data)
    self:UpdateNextLevelSkillInfo(data)
    self:UpdateMaterialInfo(data)
  end
  self.oldDescScrollView.currentMomentum = LuaGeometry.Const_V3_zero
  self.oldDescScrollView:ResetPosition()
  self.newDescScrollView.currentMomentum = LuaGeometry.Const_V3_zero
  self.newDescScrollView:ResetPosition()
end

function InheritSkillView:UpdateCurLevelSkillInfo(data)
  if data then
    self.oldLv.text = data.level > 0 and string.format("Lv.%d", data.level) or ""
    self.oldDesc.text = data.level > 0 and SkillProxy.GetDesc(data.id) or ""
  end
end

function InheritSkillView:UpdateNextLevelSkillInfo(data)
  if data then
    local nextId = data.level > 0 and data:GetNextID() or data.id + 1
    local config = Table_Skill[nextId]
    if config then
      self.newLv.text = string.format("Lv.%d", config.Level)
      self.newDesc.text = SkillProxy.GetDesc(nextId)
    end
  end
end

local NormalColor = Color(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
local LackColor = Color(0.9333333333333333, 0.3568627450980392, 0.3568627450980392, 1)

function InheritSkillView:UpdateMaterialInfo(data)
  if not data then
    return
  end
  local materials, matNum, totalNum, isLack = data:GetUpgradeMaterialState()
  if materials and matNum then
    local datas = {}
    local str = ""
    local count = #materials
    local checkPackage = GameConfig.PackageMaterialCheck.skill_inherit
    for i = 1, count do
      local itemId = materials[i]
      local itemData = ItemData.new("", itemId)
      local num = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
      itemData.num = num
      str = str .. itemData:GetName()
      if i < count then
        str = str .. "/"
      end
      datas[#datas + 1] = itemData
    end
    self.materialListCtrl:ResetDatas(datas)
    TableUtility.ArrayClear(self.lackMats)
    self.materialTipLabel.text = string.format(ZhString.InheritSkill_MaterialTip, str, matNum)
    local cells = self.materialListCtrl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      cell:SetNumLabelState(isLack)
      if isLack and ItemData.CheckItemCanTrade(cell.data.staticData.id) then
        self.lackMats[#self.lackMats + 1] = {
          id = cell.data.staticData.id,
          count = matNum - totalNum
        }
      end
    end
    self.materialProgressBar.value = math.clamp(totalNum / matNum, 0, 1)
    self.progressLabel.text = string.format("%d/%d", totalNum, matNum)
    self.progressLabel.color = isLack and LackColor or NormalColor
    self.barSp.CurrentState = isLack and 0 or 1
  end
end

function InheritSkillView:OnAddCostBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.InheritSkillExtendCostPointPopUp
  })
end

function InheritSkillView:OnGotoBtnClick()
  MsgManager.ConfirmMsgByID(43611, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorAdventureSkill
    })
  end)
end

function InheritSkillView:OnMaterialItemClick(cell)
  self.tipData.itemdata = cell.data
  self:ShowItemTip(self.tipData, cell.bg, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function InheritSkillView:OnUpgradeBtnClick()
  if self.selectSkillItemData then
    if #self.lackMats > 0 then
      QuickBuyProxy.Instance:TryOpenView(self.lackMats)
      return
    end
    local skillIds = {
      self.selectSkillItemData.id
    }
    self.isLvUp = true
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_INHERIT, skillIds)
  end
end

function InheritSkillView:HandleItemUpdate()
  self:RefreshView()
end

function InheritSkillView:ScrollToSkill(familyId)
  local pro = InheritSkillProxy.GetSkillProfess(familyId)
  local index = 0
  if pro then
    local cells = self.skillListCtrl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if cell.data.profession == pro then
        index = i
        break
      end
    end
    if 0 < index then
      self.skillScrollView:InvalidateBounds()
      local panel = self.skillScrollView.panel
      panel = panel or self.skillScrollView.gameObject:GetComponent(UIPanel)
      if panel and cells[index] and cells[index].gameObject then
        local clip = panel.baseClipRegion
        local clipOffset = panel.clipOffset
        local topY = clip.y + clipOffset.y + clip.w * 0.5
        local _, pivotY = LuaGameObject.InverseTransformPointByTransform(panel.cachedTransform, cells[index].gameObject.transform, Space.World)
        self.skillScrollView:MoveRelative(LuaGeometry.GetTempVector3(0, topY - pivotY, 0))
        self.skillScrollView:RestrictWithinBounds(true)
      end
    end
    local skillCells = cells[index]:GetSkillCells()
    local selectCell = TableUtility.ArrayFindByPredicate(skillCells, function(v, args)
      return v.data.sortID == args
    end, familyId)
    if selectCell then
      self:OnInheritSkillSelect(selectCell)
    end
  end
end

function InheritSkillView:OnEquipBtnClick()
  if self.selectSkillItemData then
    if self.selectSkillItemData:IsProfessionForbid() then
      MsgManager.ShowMsgByID(43612)
      return
    end
    local costPoint = self.selectSkillItemData:GetCostPoint()
    if not InheritSkillProxy.Instance:IsCostPointsEnough(self.selectSkillItemData) then
      MsgManager.ShowMsgByID(43613)
      local cells = self.costPointListCtrl:GetCells()
      for i = 1, #cells do
        local cell = cells[i]
        if not cell.data.isLock and (not cell.data.isLeftLoad or not cell.data.isRightLoad) then
          cell:PlayEffect(EffectMap.UI.SkillInherit_CostPointRed)
        end
      end
      return
    end
    ServiceSkillProxy.Instance:CallLoadInheritSkillCmd(self.selectSkillItemData.id, nil, 0)
  end
end

function InheritSkillView:OnUnequipBtnClick()
  if self.selectSkillItemData and self.selectSkillItemData.isLoad then
    ServiceSkillProxy.Instance:CallLoadInheritSkillCmd(self.selectSkillItemData.id, nil, 1)
  end
end

function InheritSkillView:ShowMaxLevelPreview()
  if not self.selectSkillItemData then
    return
  end
  local maxLevel = GameConfig.SkillInherit and GameConfig.SkillInherit.MaxLv
  local previewId = self.selectSkillItemData.sortID * 1000 + maxLevel
  local desc = SkillProxy.GetDesc(previewId)
  TipManager.Instance:ShowInheritSkillMaxLevelPreviewTip({maxLevel = maxLevel, desc = desc}, self.previewBtnSp, NGUIUtil.AnchorSide.TopLeft, {-150, -254})
end

function InheritSkillView:OnAttrExpandBtnClick()
  local curActive = self.attrExpandPanel.activeSelf
  self.attrExpandPanel:SetActive(not curActive)
  self.attrExpandBtnSp.flip = curActive and 0 or 2
end
