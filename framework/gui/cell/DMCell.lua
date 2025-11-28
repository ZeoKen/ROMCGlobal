local baseCell = autoImport("BaseCell")
DMCell = class("DMCell", baseCell)
autoImport("DMCellForSkill")
autoImport("DMCellForItem")
autoImport("DMMapIntroCell")
autoImport("DMTabCell")
DMCell.DMCellForSKill_cellRes = ResourcePathHelper.UICell("DMCellForSkill")
local tempVector3 = LuaVector3.Zero()
local TypeSetting1_Type = {
  showWeapon = 4011,
  showAbnorma = 4012,
  showEarnings = 4014,
  showResistance = 4015
}

function DMCell:Init()
  self:FindObjs()
end

function DMCell:FindObjs()
  self.NodeTypeForTypeSetting1 = self:FindGO("NodeTypeForTypeSetting1", self.gameObject)
  self.TypeSetting1_Title1 = self:FindGO("Title1", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Title2 = self:FindGO("Title2", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Desc2 = self:FindGO("Desc2", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Title3 = self:FindGO("Title3", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Desc3 = self:FindGO("Desc3", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Title3.gameObject:SetActive(false)
  self.TypeSetting1_Desc3.gameObject:SetActive(false)
  self.TypeSetting1_Title1_UILabel = self.TypeSetting1_Title1:GetComponent(UILabel)
  self.TypeSetting1_Title2_UILabel = self.TypeSetting1_Title2:GetComponent(UILabel)
  self.TypeSetting1_Desc2_UILabel = self.TypeSetting1_Desc2:GetComponent(UILabel)
  self.TypeSetting1_Title3_UILabel = self.TypeSetting1_Title3:GetComponent(UILabel)
  self.TypeSetting1_Desc3_UILabel = self.TypeSetting1_Desc3:GetComponent(UILabel)
  self.TypeSetting1_ScaleContainer = self:FindGO("ScaleContainer", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_Bg = self:FindGO("Bg", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_BossTexture = self:FindGO("BossTexture", self.TypeSetting1_ScaleContainer)
  self.TypeSetting1_BossTexture_UITexture = self.TypeSetting1_BossTexture:GetComponent(UITexture)
  self.TypeSetting1_MapCellContainer = self:FindGO("MapCell", self.NodeTypeForTypeSetting1)
  self.NodeTypeForTypeSetting2 = self:FindGO("NodeTypeForTypeSetting2", self.gameObject)
  self.TypeSetting2_BlueTitle1 = self:FindGO("BlueTitle1", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_BlueTitle1_UILabel = self.TypeSetting2_BlueTitle1:GetComponent(UILabel)
  self.TypeSetting2_ScaleContainer = self:FindGO("ScaleContainer", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_Bg = self:FindGO("Bg", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_BossTexture = self:FindGO("BossTexture", self.TypeSetting2_ScaleContainer)
  self.TypeSetting2_BossTexture_UITexture = self.TypeSetting2_BossTexture:GetComponent(UITexture)
  self.TypeSetting2_BossName = self:FindGO("BossName", self.TypeSetting2_ScaleContainer)
  self.TypeSetting2_BossName_UILabel = self.TypeSetting2_BossName:GetComponent(UILabel)
  self.TypeSetting2_JieDuanTitle1 = self:FindGO("JieDuanTitle1", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_JieDuanTitle2 = self:FindGO("JieDuanTitle2", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_JieDuanTitle1_UILabel = self.TypeSetting2_JieDuanTitle1:GetComponent(UILabel)
  self.TypeSetting2_JieDuanTitle2_UILabel = self.TypeSetting2_JieDuanTitle2:GetComponent(UILabel)
  self.TypeSetting2_Desc1 = self:FindGO("Desc1", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_Desc1_UILabel = self.TypeSetting2_Desc1:GetComponent(UILabel)
  self.TypeSetting2_UIGridPForItem = self:FindGO("UIGridPForItem", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_UIGridPForItem_UIGrid = self.TypeSetting2_UIGridPForItem:GetComponent(UIGrid)
  self.TypeSetting2_UIGridListCtrlForItem = UIGridListCtrl.new(self.TypeSetting2_UIGridPForItem_UIGrid, DMCellForItem, "DMCellForItem")
  self.TypeSetting2_UIGridListCtrlForItem:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  self.TypeSetting2_ServantP = self:FindGO("ServantP", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_UIGridPForServant = self:FindGO("UIGridPForServant", self.NodeTypeForTypeSetting2)
  self.TypeSetting2_UIGridPForServant_UIGrid = self.TypeSetting2_UIGridPForServant:GetComponent(UIGrid)
  self.TypeSetting2_UIGridListCtrlForServant = UIGridListCtrl.new(self.TypeSetting2_UIGridPForServant_UIGrid, DMCellForSkill, "DMCellForSkill")
  local obj = Game.AssetManager_UI:CreateAsset(DMCell.DMCellForSKill_cellRes, self.TypeSetting2_ServantP)
  obj.transform.localPosition = tempVector3
  self.TypeSetting2_ServantP_DMCellForSkill = DMCellForSkill.new(obj)
  self.TypeSetting2_SkillP = self:FindGO("SkillP", self.NodeTypeForTypeSetting2)
  obj = Game.AssetManager_UI:CreateAsset(DMCell.DMCellForSKill_cellRes, self.TypeSetting2_SkillP)
  obj.transform.localPosition = tempVector3
  self.TypeSetting2_SkillP_DMCellForSkill = DMCellForSkill.new(obj)
  self.NodeTypeForTypeSetting3 = self:FindGO("NodeTypeForTypeSetting3", self.gameObject)
  self.TypeSetting3_BlueTitle1 = self:FindGO("BlueTitle1", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_BlueTitle1_UILabel = self.TypeSetting3_BlueTitle1:GetComponent(UILabel)
  self.TypeSetting3_ScaleContainer = self:FindGO("ScaleContainer", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_Bg = self:FindGO("Bg", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_BossTexture = self:FindGO("BossTexture", self.TypeSetting3_ScaleContainer)
  self.TypeSetting3_BossTexture_UITexture = self.TypeSetting3_BossTexture:GetComponent(UITexture)
  self.TypeSetting3_BossName = self:FindGO("BossName", self.TypeSetting3_ScaleContainer)
  self.TypeSetting3_BossName_UILabel = self.TypeSetting3_BossName:GetComponent(UILabel)
  self.TypeSetting3_JieDuanTitle1 = self:FindGO("JieDuanTitle1", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_JieDuanTitle2 = self:FindGO("JieDuanTitle2", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_JieDuanTitle1_UILabel = self.TypeSetting3_JieDuanTitle1:GetComponent(UILabel)
  self.TypeSetting3_JieDuanTitle2_UILabel = self.TypeSetting3_JieDuanTitle2:GetComponent(UILabel)
  self.TypeSetting3_Desc1 = self:FindGO("Desc1", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_Desc1_UILabel = self.TypeSetting3_Desc1:GetComponent(UILabel)
  self.TypeSetting3_UIGridPForItem = self:FindGO("UIGridPForItem", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_UIGridPForItem_UIGrid = self.TypeSetting3_UIGridPForItem:GetComponent(UIGrid)
  self.TypeSetting3_UIGridListCtrlForItem = UIGridListCtrl.new(self.TypeSetting3_UIGridPForItem_UIGrid, DMCellForItem, "DMCellForItem")
  self.TypeSetting3_UIGridListCtrlForItem:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  self.TypeSetting3_ServantP = self:FindGO("ServantP", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_UIGridPForServant = self:FindGO("UIGridPForServant", self.NodeTypeForTypeSetting3)
  self.TypeSetting3_UIGridPForServant_UIGrid = self.TypeSetting3_UIGridPForServant:GetComponent(UIGrid)
  self.TypeSetting3_UIGridListCtrlForServant = UIGridListCtrl.new(self.TypeSetting3_UIGridPForServant_UIGrid, DMCellForSkill, "DMCellForSkill")
  obj = Game.AssetManager_UI:CreateAsset(DMCell.DMCellForSKill_cellRes, self.TypeSetting3_ServantP)
  obj.transform.localPosition = tempVector3
  self.TypeSetting3_ServantP_DMCellForSkill = DMCellForSkill.new(obj)
  self.TypeSetting3_SkillP = self:FindGO("SkillP", self.NodeTypeForTypeSetting3)
  obj = Game.AssetManager_UI:CreateAsset(DMCell.DMCellForSKill_cellRes, self.TypeSetting3_SkillP)
  obj.transform.localPosition = tempVector3
  self.TypeSetting3_SkillP_DMCellForSkill = DMCellForSkill.new(obj)
  self.TypeSetting1_attributeRoot = self:FindGO("AttributeRoot", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_weaponRoot = self:FindGO("weapenRoot", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_abnormaRoot = self:FindGO("abnormaRoot", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_abnormaRoot_titleRoot = self:FindGO("titleRoot", self.TypeSetting1_abnormaRoot)
  self.TypeSetting1_abnormaRoot_leftRoot = self:FindGO("left", self.TypeSetting1_abnormaRoot)
  self.TypeSetting1_earningsRoot = self:FindGO("earningsRoot", self.NodeTypeForTypeSetting1)
  self.TypeSetting1_weaponRoot_lable = self:FindComponents(UILabel, self.TypeSetting1_weaponRoot, false)
  self.TypeSetting1_abnormaRoot_lable = self:FindComponents(UILabel, self.TypeSetting1_abnormaRoot_titleRoot, false)
  self.TypeSetting1_earningsRoot_lable = self:FindComponents(UILabel, self.TypeSetting1_earningsRoot, false)
  self.attrTitle = self:FindGO("attrTitle", self.TypeSetting1_attributeRoot):GetComponent(UILabel)
  self.helpBtn = self:FindGO("helpBtn", self.TypeSetting1_attributeRoot)
  self:RegistShowGeneralHelpByHelpID(35273, self.helpBtn)
  self.TypeSetting1_attributeRoot_topGrid = self:FindGO("topGrid", self.TypeSetting1_attributeRoot):GetComponent(UIGrid)
  self.TypeSetting1_attributeRoot_topGridList = UIGridListCtrl.new(self.TypeSetting1_attributeRoot_topGrid, DMTabCell, "DMTabCell")
  self.TypeSetting1_attributeRoot_leftGrid = self:FindGO("leftGrid", self.TypeSetting1_attributeRoot):GetComponent(UIGrid)
  self.TypeSetting1_attributeRoot_leftGridList = UIGridListCtrl.new(self.TypeSetting1_attributeRoot_leftGrid, DMTabCell, "DMTabCell")
  self.debuffdesc = GameConfig and GameConfig.Debuffdesc and GameConfig.Debuffdesc or nil
  if self.debuffdesc ~= nil then
    local attribits = self.debuffdesc[1] and self.debuffdesc[1] or nil
    if attribits then
      local temp = {}
      for i = 1, #attribits do
        temp[i] = {}
        temp[i].desc = ""
        temp[i].tabName = attribits[i]
        temp[i].width = 40
        temp[i].height = 40
        temp[i].side = NGUIUtil.AnchorSide.Bottom
        temp[i].offset = {90, -58}
      end
      self.TypeSetting1_attributeRoot_topGridList:ResetDatas(temp)
      local temp1 = clone(temp)
      for k, v in ipairs(temp1) do
        v.width = 65
        v.side = NGUIUtil.AnchorSide.Right
        v.offset = {250, 0}
      end
      self.TypeSetting1_attributeRoot_leftGridList:ResetDatas(temp1)
    end
  end
  self.TypeSetting1_abnormaRoot_DMTabCells = {}
  for i = 1, 13 do
    local cell = self:FindGO("DMTabCell" .. i, self.TypeSetting1_abnormaRoot_leftRoot)
    if cell then
      local cellCtrl = DMTabCell.new(cell)
      table.insert(self.TypeSetting1_abnormaRoot_DMTabCells, cellCtrl)
    end
  end
end

function DMCell:InitAndSetResistance(data)
  if self.resistanceRoot then
    return
  end
  self.resistanceRoot = self:FindGO("resistanceRoot")
  self.helpBtn32581 = self:FindGO("helpBtn32581", self.resistanceRoot)
  self:RegistShowGeneralHelpByHelpID(32581, self.helpBtn32581)
  if not self.resistanceRoot then
    return
  end
  local gridGO = self:FindGO("Grid", self.resistanceRoot)
  local hGO, cellGO
  for i = 1, 12 do
    hGO = self:FindGO(i, gridGO)
    for j = 1, 10 do
      cellGO = self:FindGO(j, hGO)
      if cellGO.activeSelf then
        cellGO:GetComponent(UILongPress).pressEvent = function(go, state)
          if state then
            self:ShowResistanceTip(go)
          else
            TipManager.Instance:CloseTabNameTipWithFadeOut()
          end
        end
      end
    end
  end
  local attriGO = self:FindGO("attribute", self.resistanceRoot)
  for i = 1, 10 do
    cellGO = self:FindGO(i, attriGO)
    cellGO:GetComponent(UILongPress).pressEvent = function(go, state)
      if state then
        self:ShowResistanceAttriTip(go)
      else
        TipManager.Instance:CloseTabNameTipWithFadeOut()
      end
    end
  end
  local desc = data.Desc
  local label
  local titleGO = self:FindGO("title", self.resistanceRoot)
  local title0 = self:FindComponent("0", UILabel, titleGO)
  if title0 then
    title0.text = desc[1] or ""
  end
  for i = 1, 6 do
    label = self:FindComponent(i, UILabel, titleGO)
    if label then
      label.text = desc[i + 1] or ""
    end
  end
  local BuffStatusDecl = GameConfig.ElementStateEffect.BuffStatusDecl
  if BuffStatusDecl then
    local statusGO = self:FindGO("status", self.resistanceRoot)
    for i = 1, 12 do
      label = self:FindComponent(i, UILabel, statusGO)
      if label then
        label.text = BuffStatusDecl[i] or ""
      end
    end
  end
end

local descArray = {}

function DMCell:ShowResistanceTip(go)
  if Slua.IsNull(go) or not GameConfig.ElementStateEffect then
    return
  end
  local eleId, stId = go.name, go.transform.parent.name
  eleId = tonumber(eleId)
  stId = tonumber(stId)
  local BuffStatusDecl = GameConfig.ElementStateEffect.BuffStatusDecl
  local ElementDecl = GameConfig.ElementStateEffect.ElementDecl
  local oddRate = GameConfig.ElementStateEffect.OddsRate[eleId]
  if oddRate then
    local rate
    for i = 1, 4 do
      rate = oddRate[i] and oddRate[i][stId]
      if rate then
        rate = rate - 1
        if 1 <= rate * rate then
          table.insert(descArray, string.format(ZhString.DMCell_Resistance0Desc, ElementDecl[eleId], i, BuffStatusDecl[stId]))
        elseif 0 < rate then
          table.insert(descArray, string.format(ZhString.DMCell_ResistanceOddDesc, ElementDecl[eleId], i, BuffStatusDecl[stId], ZhString.DMCell_ResistanceUp, math.floor(rate * 100)))
        else
          table.insert(descArray, string.format(ZhString.DMCell_ResistanceOddDesc, ElementDecl[eleId], i, BuffStatusDecl[stId], ZhString.DMCell_ResistanceOddDown, math.floor(-rate * 100)))
        end
      end
    end
  end
  local timeRate = GameConfig.ElementStateEffect.TimeRate[eleId]
  if timeRate then
    local rate
    for i = 1, 4 do
      rate = timeRate[i] and timeRate[i][stId]
      if rate then
        rate = rate - 1
        if 1 <= rate * rate then
          table.insert(descArray, string.format(ZhString.DMCell_Resistance0Desc, ElementDecl[eleId], i, BuffStatusDecl[stId]))
        elseif 0 < rate then
          table.insert(descArray, string.format(ZhString.DMCell_ResistanceTimeDesc, ElementDecl[eleId], i, BuffStatusDecl[stId], ZhString.DMCell_ResistanceTimeUp, math.floor(rate * 100)))
        else
          table.insert(descArray, string.format(ZhString.DMCell_ResistanceTimeDesc, ElementDecl[eleId], i, BuffStatusDecl[stId], ZhString.DMCell_ResistanceTimeDown, math.floor(-rate * 100)))
        end
      end
    end
  end
  local des = ""
  for i = 1, #descArray do
    des = des .. descArray[i]
    if i ~= #descArray then
      des = des .. "\n"
    end
  end
  TableUtility.ArrayClear(descArray)
  TipManager.Instance:TryShowAllDirComodoBuildingSendNameTip(des, go:GetComponent(UIWidget), NGUIUtil.AnchorSide.Right, {115, 25}, "TabNameDetailTip")
end

function DMCell:ShowResistanceAttriTip(go)
  if Slua.IsNull(go) then
    return
  end
  local eleId = tonumber(go.name)
  local ElementDecl = GameConfig.ElementStateEffect.ElementDecl
  TipManager.Instance:TryShowAllDirComodoBuildingSendNameTip(string.format(ZhString.DMCell_Attribute, ElementDecl[eleId]), go:GetComponent(UIWidget), NGUIUtil.AnchorSide.Bottom, {92, -25})
end

function DMCell:ClickDropItem(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end

local monsterPos = LuaVector3()

function DMCell:UpdateBossAgent(monsterData, bosstype, p_UITexture)
  UIModelUtil.Instance:ResetTexture(self.bossTexture)
  if bosstype == 3 then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing_1", p_UITexture)
  else
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", p_UITexture)
  end
  UIModelUtil.Instance:SetMonsterModelTexture(p_UITexture, monsterData.id, nil, nil, function(obj)
    local model = obj
    local showPos = monsterData.LoadShowPose
    LuaVector3.Better_Set(monsterPos, showPos[1], showPos[2], showPos[3])
    model:SetPosition(monsterPos)
    model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
    local size = monsterData.LoadShowSize or 1
    model:SetScale(size)
    UIModelUtil.Instance:ChangeBGScale(15)
  end)
end

function DMCell:SetChoose(isChoose)
end

function DMCell:GetData()
  return self.data
end

DMCell.Node = {
  NodeTypeForTypeSetting1 = 1,
  NodeTypeForTypeSetting2 = 2,
  NodeTypeForTypeSetting3 = 3
}

function DMCell:OnlyShowThisNode(node)
  self.NodeTypeForTypeSetting1.gameObject:SetActive(node == DMCell.Node.NodeTypeForTypeSetting1)
  self.NodeTypeForTypeSetting2.gameObject:SetActive(node == DMCell.Node.NodeTypeForTypeSetting2)
  self.NodeTypeForTypeSetting3.gameObject:SetActive(node == DMCell.Node.NodeTypeForTypeSetting3)
end

function DMCell:ShowTypeSetting1Lable(data)
  if data.id == TypeSetting1_Type.showWeapon then
    for i = 1, #self.TypeSetting1_weaponRoot_lable do
      self.TypeSetting1_weaponRoot_lable[i].text = data.Desc[i]
    end
  elseif data.id == TypeSetting1_Type.showAbnorma then
    for i = 1, #self.TypeSetting1_abnormaRoot_lable do
      self.TypeSetting1_abnormaRoot_lable[i].text = data.Desc[i]
    end
    local startIndex = #self.TypeSetting1_abnormaRoot_lable + 1
    local endIndex = #data.Desc
    local temp = {}
    local index = 1
    for i = startIndex, endIndex do
      temp[index] = {}
      temp[index].desc = data.Desc[i]
      temp[index].tabName = self.debuffdesc and self.debuffdesc[2] and self.debuffdesc[2][index] or nil
      temp[index].side = NGUIUtil.AnchorSide.Right
      temp[index].offset = {140, 25}
      temp[index].prefabName = "TabNameDmTip"
      index = index + 1
    end
    for i = 1, #temp do
      local cell = self.TypeSetting1_abnormaRoot_DMTabCells[i]
      if cell then
        cell:SetData(temp[i])
      end
    end
  elseif data.id == TypeSetting1_Type.showEarnings then
    for i = 1, #self.TypeSetting1_earningsRoot_lable do
      self.TypeSetting1_earningsRoot_lable[i].text = data.Desc[i]
    end
  end
end

function DMCell:SetData(data)
  self.data = data
  if data.Typesetting == 1 then
    self:OnlyShowThisNode(DMCell.Node.NodeTypeForTypeSetting1)
    if data.Title then
      self.TypeSetting1_Title1_UILabel.text = data.Title
      self.TypeSetting1_Title1.gameObject:SetActive(true)
    else
      self.TypeSetting1_Title1.gameObject:SetActive(false)
    end
    if data.Image == "map_intro" then
      self.TypeSetting1_ScaleContainer.gameObject:SetActive(false)
      self.TypeSetting1_Bg.gameObject:SetActive(false)
      self:LoadMapIntroCell()
      self.TypeSetting1_MapCellContainer.gameObject:SetActive(true)
    elseif data.Image then
      PictureManager.Instance:SetBattleManualPanel(data.Image, self.TypeSetting1_BossTexture_UITexture)
      self.TypeSetting1_BossTexture_UITexture:MakePixelPerfect()
      self.TypeSetting1_ScaleContainer.gameObject:SetActive(true)
      self.TypeSetting1_Bg.gameObject:SetActive(true)
      self.TypeSetting1_MapCellContainer.gameObject:SetActive(false)
    else
      self.TypeSetting1_ScaleContainer.gameObject:SetActive(false)
      self.TypeSetting1_Bg.gameObject:SetActive(false)
      self.TypeSetting1_MapCellContainer.gameObject:SetActive(false)
    end
    if data.SubTitle then
      self.TypeSetting1_Title2_UILabel.text = data.SubTitle
      self.TypeSetting1_Title2.gameObject:SetActive(true)
    else
      self.TypeSetting1_Title2.gameObject:SetActive(false)
    end
    if data.Text then
      self.TypeSetting1_Desc2_UILabel.text = data.Text
      self.TypeSetting1_Desc2.gameObject:SetActive(true)
    else
      self.TypeSetting1_Desc2.gameObject:SetActive(false)
    end
    if data.id then
      if data.id == TypeSetting1_Type.showWeapon then
        self:ShowTypeSetting1Lable(data)
        self.TypeSetting1_weaponRoot.gameObject:SetActive(true)
        self.TypeSetting1_abnormaRoot.gameObject:SetActive(false)
        self.TypeSetting1_earningsRoot.gameObject:SetActive(false)
      elseif data.id == TypeSetting1_Type.showAbnorma then
        self:ShowTypeSetting1Lable(data)
        self.TypeSetting1_weaponRoot.gameObject:SetActive(false)
        self.TypeSetting1_abnormaRoot.gameObject:SetActive(true)
        self.TypeSetting1_earningsRoot.gameObject:SetActive(false)
      elseif data.id == TypeSetting1_Type.showEarnings then
        self:ShowTypeSetting1Lable(data)
        self.TypeSetting1_earningsRoot.gameObject:SetActive(true)
        self.TypeSetting1_weaponRoot.gameObject:SetActive(false)
        self.TypeSetting1_abnormaRoot.gameObject:SetActive(false)
      else
        self.TypeSetting1_weaponRoot.gameObject:SetActive(false)
        self.TypeSetting1_abnormaRoot.gameObject:SetActive(false)
        self.TypeSetting1_earningsRoot.gameObject:SetActive(false)
        if data.id == TypeSetting1_Type.showResistance then
          self.TypeSetting1_attributeRoot.gameObject:SetActive(false)
          self:InitAndSetResistance(data)
          if self.resistanceRoot then
            self.resistanceRoot:SetActive(true)
          end
        else
          self.TypeSetting1_attributeRoot.gameObject:SetActive(true)
          if self.resistanceRoot then
            self.resistanceRoot:SetActive(false)
          end
        end
      end
    end
  elseif data.Typesetting == 2 then
    self:OnlyShowThisNode(DMCell.Node.NodeTypeForTypeSetting2)
    if data.MonsterID then
      local monsterData = Table_Monster[data.MonsterID]
      self:UpdateBossAgent(monsterData, 3, self.TypeSetting2_BossTexture_UITexture)
      self.TypeSetting2_ScaleContainer.gameObject:SetActive(true)
      self.TypeSetting2_Bg.gameObject:SetActive(true)
      self.TypeSetting2_BossName_UILabel.text = monsterData.NameZh
    else
      self.TypeSetting2_ScaleContainer.gameObject:SetActive(false)
      self.TypeSetting2_Bg.gameObject:SetActive(false)
    end
    if data.SubTitle then
      self.TypeSetting2_BlueTitle1_UILabel.text = data.SubTitle
      self.TypeSetting2_BlueTitle1.gameObject:SetActive(true)
    else
      self.TypeSetting2_BlueTitle1.gameObject:SetActive(false)
    end
    if data.Stage then
      self.TypeSetting2_JieDuanTitle1_UILabel.text = data.Stage[1]
      self.TypeSetting2_JieDuanTitle1.gameObject:SetActive(true)
      self.TypeSetting2_JieDuanTitle2_UILabel.text = data.Stage[2]
      self.TypeSetting2_JieDuanTitle2.gameObject:SetActive(true)
    else
      self.TypeSetting2_JieDuanTitle1.gameObject:SetActive(false)
      self.TypeSetting2_JieDuanTitle2.gameObject:SetActive(false)
    end
    if data.StageIntroduce then
      self.TypeSetting2_Desc1_UILabel.text = data.StageIntroduce
      self.TypeSetting2_Desc1.gameObject:SetActive(true)
    else
      self.TypeSetting2_Desc1.gameObject:SetActive(false)
    end
    if data.SkillID then
      self.TypeSetting2_SkillP_DMCellForSkill:SetData(data.SkillID)
      self.TypeSetting2_SkillP.gameObject:SetActive(true)
    else
      self.TypeSetting2_SkillP.gameObject:SetActive(false)
    end
    if data.ServantID then
      self.TypeSetting2_ServantP_DMCellForSkill:SetDataForServant(data.ServantID)
      self.TypeSetting2_ServantP.gameObject:SetActive(true)
    else
      self.TypeSetting2_ServantP.gameObject:SetActive(false)
    end
    if data.ServantSkillID then
      self.TypeSetting2_UIGridListCtrlForServant:ResetDatas(data.ServantSkillID)
      self.TypeSetting2_UIGridPForServant.gameObject:SetActive(true)
    else
      self.TypeSetting2_UIGridPForServant.gameObject:SetActive(false)
    end
    if data.ItemID then
      self.TypeSetting2_UIGridListCtrlForItem:ResetDatas(data.ItemID)
      self.TypeSetting2_UIGridPForItem.gameObject:SetActive(true)
    else
      self.TypeSetting2_UIGridPForItem.gameObject:SetActive(false)
    end
  elseif data.Typesetting == 3 then
    self:OnlyShowThisNode(DMCell.Node.NodeTypeForTypeSetting3)
    if data.MonsterID then
      local monsterData = Table_Monster[data.MonsterID]
      self:UpdateBossAgent(monsterData, 3, self.TypeSetting3_BossTexture_UITexture)
      self.TypeSetting3_ScaleContainer.gameObject:SetActive(true)
      self.TypeSetting3_Bg.gameObject:SetActive(true)
      self.TypeSetting3_BossName_UILabel.text = monsterData.NameZh
    else
      self.TypeSetting3_ScaleContainer.gameObject:SetActive(false)
      self.TypeSetting3_Bg.gameObject:SetActive(false)
    end
    if data.SubTitle then
      self.TypeSetting3_BlueTitle1_UILabel.text = data.SubTitle
      self.TypeSetting3_BlueTitle1.gameObject:SetActive(true)
    else
      self.TypeSetting3_BlueTitle1.gameObject:SetActive(false)
    end
    if data.Stage then
      self.TypeSetting3_JieDuanTitle1_UILabel.text = data.Stage
      self.TypeSetting3_JieDuanTitle1.gameObject:SetActive(true)
    else
      self.TypeSetting3_JieDuanTitle1.gameObject:SetActive(false)
    end
    if data.StageCondition then
      self.TypeSetting3_JieDuanTitle2_UILabel.text = data.StageCondition
      self.TypeSetting3_JieDuanTitle2.gameObject:SetActive(true)
    else
      self.TypeSetting3_JieDuanTitle2.gameObject:SetActive(false)
    end
    if data.StageIntroduce then
      self.TypeSetting3_Desc1_UILabel.text = data.StageIntroduce
      self.TypeSetting3_Desc1.gameObject:SetActive(true)
    else
      self.TypeSetting3_Desc1.gameObject:SetActive(false)
    end
    if data.SkillID then
      self.TypeSetting3_SkillP_DMCellForSkill:SetData(data.SkillID)
      self.TypeSetting3_SkillP.gameObject:SetActive(true)
    else
      self.TypeSetting3_SkillP.gameObject:SetActive(false)
    end
    if data.ServantID then
      self.TypeSetting3_ServantP_DMCellForSkill:SetDataForServant(data.ServantID)
      self.TypeSetting3_ServantP.gameObject:SetActive(true)
    else
      self.TypeSetting3_ServantP.gameObject:SetActive(false)
    end
    if data.ServantSkillID then
    else
    end
    if data.ItemID then
      self.TypeSetting3_UIGridListCtrlForItem:ResetDatas(data.ItemID)
      self.TypeSetting3_UIGridPForItem.gameObject:SetActive(true)
    else
      self.TypeSetting3_UIGridPForItem.gameObject:SetActive(false)
    end
  end
end

function DMCell:LoadMapIntroCell()
  if not self.mapintrocell then
    local obj = self:LoadPreferb("cell/DMMapIntroCell", self.TypeSetting1_MapCellContainer.gameObject)
    obj.name = "DMMapIntroCell"
    obj:SetActive(true)
    self.mapintrocell = DMMapIntroCell.new(obj)
  else
  end
end
