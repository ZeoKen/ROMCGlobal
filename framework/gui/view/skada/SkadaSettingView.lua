autoImport("SkadaRaceCell")
autoImport("SkadaSettingToggleCell")
autoImport("SkadaBossPveTypeCell")
autoImport("SkadaBossHeadCell")
autoImport("SkadaPveDifficultyCell")
SkadaSettingView = class("SkadaSettingView", BaseView)
SkadaSettingView.ViewType = UIViewType.NormalLayer
local OperSourceID = {
  Race = 1,
  Shape = 2,
  Nature = 3,
  HpReduce = 4,
  BossType = 5,
  NatureLv = 6
}
local SettingType = {
  Custom = EWOODTYPE.EWOODTYPE_NORMAL,
  Boss = EWOODTYPE.EWOODTYPE_SPEC_MONSTER
}
local BossType = {
  Normal = 0,
  MVP = 1,
  Mini = 2
}
local _, c = ColorUtil.TryParseHexString("B36B24")
local SelectedLabelCol = c
_, c = ColorUtil.TryParseHexString("4059A8")
local NormalLabelCol = c
local SaveBtnOffsetX = 94

function SkadaSettingView:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function SkadaSettingView:FindObjs()
  self.customBtn = self:FindGO("CustomBtn")
  self:AddClickEvent(self.customBtn, function()
    self:SelectSettingType(SettingType.Custom)
  end)
  self.customBtnSp = self.customBtn:GetComponent(UIMultiSprite)
  self.customBtnLabel = self:FindComponent("Label", UILabel, self.customBtn)
  self.bossBtn = self:FindGO("BossBtn")
  self:AddClickEvent(self.bossBtn, function()
    self:SelectSettingType(SettingType.Boss)
  end)
  self.bossBtnSp = self.bossBtn:GetComponent(UIMultiSprite)
  self.bossBtnLabel = self:FindComponent("Label", UILabel, self.bossBtn)
  self.settingList = self:FindGO("SettingList")
  local l_objSettings = self:FindGO("containerSettings")
  self.tableSettings = l_objSettings:GetComponent(UITable)
  self.listRace = UIGridListCtrl.new(self:FindComponent("gridRace", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.listShape = UIGridListCtrl.new(self:FindComponent("gridShape", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.listNature = UIGridListCtrl.new(self:FindComponent("gridNature", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.listType = UIGridListCtrl.new(self:FindComponent("gridType", UIGrid, l_objSettings), SkadaSettingToggleCell, "SkadaSettingToggleCell")
  self.objNatureLvAdjust = self:FindGO("NatureLvAdjust", l_objSettings)
  self.labNatureLv = self:FindComponent("labNatureLv", UILabel, self.objNatureLvAdjust)
  self.objPowerAdjust = self:FindGO("PowerAdjust", l_objSettings)
  self.labPower = self:FindComponent("labPower", UILabel, self.objPowerAdjust)
  self.objEmptyList = self:FindGO("NoneTip", l_objSettings)
  self.bossSettingRoot = self:FindGO("BossRoot")
  local raidGrid = self:FindComponent("RaidGrid", UIGrid)
  self.raidList = UIGridListCtrl.new(raidGrid, SkadaBossPveTypeCell, "PveTypeCell")
  self.raidList:AddEventListener(MouseEvent.MouseClick, self.OnRaidClick, self)
  local difficultyGrid = self:FindComponent("DifficultyGrid", UIGrid)
  self.raidDifficultyList = UIGridListCtrl.new(difficultyGrid, SkadaPveDifficultyCell, "PveDifficultyCell")
  self.raidDifficultyList:AddEventListener(MouseEvent.MouseClick, self.OnRaidDifficultyClick, self)
  local monsterGrid = self:FindComponent("MonsterGrid", UIGrid)
  self.monsterList = UIGridListCtrl.new(monsterGrid, SkadaBossHeadCell, "SkadaBossHeadCell")
  self.monsterList:AddEventListener(MouseEvent.MouseClick, self.OnMonsterClick, self)
end

function SkadaSettingView:AddButtonEvt()
  local help_go = self:FindGO("BtnHelp")
  self:RegistShowGeneralHelpByHelpID(PanelConfig.SkadaSettingView.id, help_go)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self.btnSave = self:FindGO("BtnSave")
  self:AddClickEvent(self.btnSave, function()
    self:ClickBtnSave()
  end)
  local btnNatureLvDown = self:FindGO("btnNatureLvDown", self.objNatureLvAdjust)
  self.btnNatureLvDownSp = btnNatureLvDown:GetComponent(UISprite)
  self:AddClickEvent(btnNatureLvDown, function()
    self:SetNatureLv(self.curNatureLv - 1)
  end)
  local btnNatureLvUp = self:FindGO("btnNatureLvUp", self.objNatureLvAdjust)
  self.btnNatureLvUpSp = btnNatureLvUp:GetComponent(UISprite)
  self:AddClickEvent(btnNatureLvUp, function()
    self:SetNatureLv(self.curNatureLv + 1)
  end)
  local btnPowerDown = self:FindGO("btnPowerDown", self.objPowerAdjust)
  self.btnPowerDownSp = btnPowerDown:GetComponent(UISprite)
  self:AddClickEvent(btnPowerDown, function()
    self:SetPower(self.curPower - 1)
  end)
  local btnPowerUp = self:FindGO("btnPowerUp", self.objPowerAdjust)
  self.btnPowerUpSp = btnPowerUp:GetComponent(UISprite)
  self:AddClickEvent(btnPowerUp, function()
    self:SetPower(self.curPower + 1)
  end)
end

function SkadaSettingView:AddViewEvt()
  self.listRace:AddEventListener(MouseEvent.MouseClick, self.ClickRace, self)
  self.listShape:AddEventListener(MouseEvent.MouseClick, self.ClickShape, self)
  self.listNature:AddEventListener(MouseEvent.MouseClick, self.ClickNature, self)
  self.listType:AddEventListener(MouseEvent.MouseClick, self.ClickType, self)
end

function SkadaSettingView:InitSettings()
  self:DeleteSettings()
  local nameConfig = GameConfig.MonsterAttr
  local singleTable
  self.raceDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Race) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Race[nameEn]
    self.raceDatas[#self.raceDatas + 1] = singleTable
  end
  table.sort(self.raceDatas, function(a, b)
    return a.id < b.id
  end)
  self.listRace:ResetDatas(self.raceDatas)
  self.natureDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Nature) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Nature[nameEn]
    self.natureDatas[#self.natureDatas + 1] = singleTable
  end
  table.sort(self.natureDatas, function(a, b)
    return a.id < b.id
  end)
  self.listNature:ResetDatas(self.natureDatas)
  self.shapeDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(CommonFun.Shape) do
    singleTable = ReusableTable.CreateTable()
    for index, shapeID in pairs(CreatureData.ShapeIndex) do
      if shapeID == id then
        singleTable.id = index
        break
      end
    end
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.Body[nameEn]
    self.shapeDatas[#self.shapeDatas + 1] = singleTable
  end
  table.sort(self.shapeDatas, function(a, b)
    return a.id < b.id
  end)
  self.listShape:ResetDatas(self.shapeDatas)
  self.typeDatas = ReusableTable.CreateArray()
  for nameEn, id in pairs(BossType) do
    singleTable = ReusableTable.CreateTable()
    singleTable.id = id
    singleTable.NameEn = nameEn
    singleTable.NameZh = nameConfig.BossType[nameEn]
    self.typeDatas[#self.typeDatas + 1] = singleTable
  end
  table.sort(self.typeDatas, function(a, b)
    return a.id < b.id
  end)
  self.listType:ResetDatas(self.typeDatas)
end

function SkadaSettingView:DeleteSettings()
  if self.raceDatas then
    for i = 1, #self.raceDatas do
      ReusableTable.DestroyAndClearTable(self.raceDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.raceDatas)
    self.raceDatas = nil
  end
  if self.natureDatas then
    for i = 1, #self.natureDatas do
      ReusableTable.DestroyAndClearTable(self.natureDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.natureDatas)
    self.natureDatas = nil
  end
  if self.shapeDatas then
    for i = 1, #self.shapeDatas do
      ReusableTable.DestroyAndClearTable(self.shapeDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.shapeDatas)
    self.shapeDatas = nil
  end
  if self.typeDatas then
    for i = 1, #self.typeDatas do
      ReusableTable.DestroyAndClearTable(self.typeDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.typeDatas)
    self.typeDatas = nil
  end
end

function SkadaSettingView:LoadCurSettings()
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  local curSettingID = furnitureData and furnitureData.woodRace
  local cells = self.listRace:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickRace(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodNature
  cells = self.listNature:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickNature(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodShape
  cells = self.listShape:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickShape(cells[i])
        break
      end
    end
  end
  curSettingID = furnitureData and furnitureData.woodBossType or 0
  cells = self.listType:GetCells()
  if curSettingID then
    for i = 1, #cells do
      if cells[i].id == curSettingID then
        self:ClickType(cells[i])
        break
      end
    end
  end
  self:SetNatureLv(furnitureData and furnitureData.woodNatureLv or 1)
  self:SetPower(furnitureData and furnitureData.woodDamageReduce or 1)
  self.curSettingType = furnitureData and furnitureData.woodType or SettingType.Custom
  self.curMonsterId = furnitureData and furnitureData.woodMonsterId or 0
end

function SkadaSettingView:ClickRace(cellCtl)
  if self.curRaceCell then
    self.curRaceCell:SetIsSelect(false)
  end
  self.curRaceCell = cellCtl
  self.curRaceCell:SetIsSelect(true)
end

function SkadaSettingView:ClickShape(cellCtl)
  if self.curShapeCell then
    self.curShapeCell:SetIsSelect(false)
  end
  self.curShapeCell = cellCtl
  self.curShapeCell:SetIsSelect(true)
end

function SkadaSettingView:ClickNature(cellCtl)
  if self.curNatureCell then
    self.curNatureCell:SetIsSelect(false)
  end
  self.curNatureCell = cellCtl
  self.curNatureCell:SetIsSelect(true)
end

function SkadaSettingView:ClickType(cellCtl)
  if self.curTypeCell then
    self.curTypeCell:SetIsSelect(false)
  end
  self.curTypeCell = cellCtl
  self.curTypeCell:SetIsSelect(true)
end

function SkadaSettingView:SetPower(configIndex)
  local powerConfig = GameConfig.Home and GameConfig.Home.npc_set_reduce
  if not powerConfig then
    LogUtility.Error("没有找到配置GameConfig.Home.npc_set_reduce！")
    return
  end
  configIndex = math.clamp(configIndex, 1, #powerConfig)
  if configIndex == 1 then
    self.btnPowerDownSp.alpha = 0.5
  else
    self.btnPowerDownSp.alpha = 1
  end
  if configIndex == #powerConfig then
    self.btnPowerUpSp.alpha = 0.5
  else
    self.btnPowerUpSp.alpha = 1
  end
  if configIndex == self.curPower then
    return
  end
  self.curPower = configIndex
  self.labPower.text = powerConfig[configIndex].value .. "%"
end

function SkadaSettingView:SetNatureLv(configIndex)
  local natureLvConfig = GameConfig.Home and GameConfig.Home.NpcSetNatureLv
  if not natureLvConfig then
    LogUtility.Error("没有找到配置GameConfig.Home.NpcSetNatureLv！")
    return
  end
  configIndex = math.clamp(configIndex, natureLvConfig.MinLv, natureLvConfig.MaxLv)
  if configIndex == natureLvConfig.MinLv then
    self.btnNatureLvDownSp.alpha = 0.5
  else
    self.btnNatureLvDownSp.alpha = 1
  end
  if configIndex == natureLvConfig.MaxLv then
    self.btnNatureLvUpSp.alpha = 0.5
  else
    self.btnNatureLvUpSp.alpha = 1
  end
  if configIndex == self.curNatureLv then
    return
  end
  self.curNatureLv = configIndex
  self.labNatureLv.text = StringUtil.IntToRoman(self.curNatureLv)
end

function SkadaSettingView:ClickBtnSave()
  local furnitureData = HomeProxy.Instance:FindFurnitureData(self.myFurnitureID)
  local settingData = {}
  local isDirty = false
  local newSetting = self.curSettingType
  local oldSetting = furnitureData and furnitureData.woodType
  settingData.type = self.curSettingType
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curRaceCell and self.curRaceCell.id
  oldSetting = furnitureData and furnitureData.woodRace
  settingData.race = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curNatureCell and self.curNatureCell.id
  oldSetting = furnitureData and furnitureData.woodNature
  settingData.nature = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curShapeCell and self.curShapeCell.id
  oldSetting = furnitureData and furnitureData.woodShape
  settingData.shape = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curPower
  oldSetting = furnitureData and furnitureData.woodDamageReduce
  settingData.damage_reduce = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curNatureLv
  oldSetting = furnitureData and furnitureData.woodNatureLv
  settingData.nature_lv = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  newSetting = self.curTypeCell and self.curTypeCell.id
  oldSetting = furnitureData and furnitureData.woodBossType
  settingData.boss_type = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  if self.curSettingType == SettingType.Custom then
    self.curMonsterId = 0
  end
  newSetting = self.curMonsterId
  oldSetting = furnitureData and furnitureData.woodMonsterId
  settingData.monster_id = newSetting
  if newSetting and newSetting ~= oldSetting then
    isDirty = true
  end
  if isDirty then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodSet, self.myFurnitureID, nil, nil, nil, nil, settingData)
    local creature = self.myNpcID and NSceneNpcProxy.Instance:Find(self.myNpcID)
    if creature then
      local zoneType = NpcData.ZoneType.ZONE_FIELD
      if self.curSettingType == SettingType.Boss then
        local staticData = Table_Monster[self.curMonsterId]
        zoneType = NpcData.GetZoneTypeByStaticData(staticData)
      end
      creature.data.zoneType = zoneType
    end
  end
  MsgManager.ShowMsgByID(34009)
  self:CloseSelf()
end

function SkadaSettingView:SelectSettingType(type)
  self.curSettingType = type
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.btnSave)
  if type == SettingType.Custom then
    self.customBtnSp.CurrentState = 1
    self.bossBtnSp.CurrentState = 0
    self.customBtnLabel.color = SelectedLabelCol
    self.bossBtnLabel.color = NormalLabelCol
    self.settingList:SetActive(true)
    self.bossSettingRoot:SetActive(false)
    x = 0
  elseif type == SettingType.Boss then
    self.customBtnSp.CurrentState = 0
    self.bossBtnSp.CurrentState = 1
    self.bossBtnLabel.color = SelectedLabelCol
    self.customBtnLabel.color = NormalLabelCol
    self.settingList:SetActive(false)
    self.bossSettingRoot:SetActive(true)
    x = SaveBtnOffsetX
  end
  LuaGameObject.SetLocalPositionGO(self.btnSave, x, y, z)
end

function SkadaSettingView:InitBossSetting()
  local raidDatas = {}
  if GameConfig.Home.Skada.monsterRaids then
    for i = 1, #GameConfig.Home.Skada.monsterRaids do
      local groupid = GameConfig.Home.Skada.monsterRaids[i]
      local raidData = PveEntranceProxy.Instance:GetRaidData(groupid)
      raidDatas[#raidDatas + 1] = raidData[1]
    end
  end
  self.raidList:ResetDatas(raidDatas)
  local i, j, k
  if self.curMonsterId > 0 then
    i, j, k = self:FindCurBossIndex(raidDatas)
  end
  i = i or 1
  local cells = self.raidList:GetCells()
  if 0 < #cells then
    self:OnRaidClick(cells[i], j, k)
  end
end

function SkadaSettingView:FindCurBossIndex(raidDatas)
  for i = 1, #raidDatas do
    local groupid = raidDatas[i].staticEntranceData.groupid
    local diffs = PveEntranceProxy.Instance:GetDifficultyData(groupid)
    for j = 1, #diffs do
      local data = diffs[j]
      if data ~= PveEntranceProxy.EmptyDiff then
        local monsters = data:getMonsters()
        local k = TableUtility.ArrayFindIndex(monsters, self.curMonsterId)
        if 0 < k then
          return i, j, k
        end
      end
    end
  end
end

function SkadaSettingView:OnRaidClick(cell, diffIndex, monsterIndex)
  diffIndex = diffIndex or 1
  local cells = self.raidList:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(cell.data.staticEntranceData.id)
  end
  local datas = {}
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(cell.groupid)
  for i = 1, #diffs do
    if diffs[i] ~= PveEntranceProxy.EmptyDiff then
      datas[#datas + 1] = diffs[i]
    end
  end
  self.raidDifficultyList:ResetDatas(datas)
  cells = self.raidDifficultyList:GetCells()
  if 0 < #cells then
    self:OnRaidDifficultyClick(cells[diffIndex], monsterIndex)
  end
end

function SkadaSettingView:OnRaidDifficultyClick(cell, monsterIndex)
  if not cell.data.staticEntranceData then
    return
  end
  monsterIndex = monsterIndex or 1
  local cells = self.raidDifficultyList:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoosen(cell.data.staticEntranceData.staticDifficulty)
  end
  local monsters = cell.data:getMonsters()
  self.monsterList:ResetDatas(monsters)
  cells = self.monsterList:GetCells()
  self:OnMonsterClick(cells[monsterIndex])
end

function SkadaSettingView:OnMonsterClick(cell)
  self.curMonsterId = cell.monsterId
  self:SelectMonsterCell()
end

function SkadaSettingView:SelectMonsterCell()
  local cells = self.monsterList:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetSelect(self.curMonsterId == cell.monsterId)
  end
end

function SkadaSettingView:OnEnter()
  SkadaSettingView.super.OnEnter(self)
  self.myNpcID = self.viewdata and self.viewdata.viewdata
  local nCreature = self.myNpcID and NSceneNpcProxy.Instance:Find(self.myNpcID)
  self.myFurnitureID = nCreature and nCreature.data:GetRelativeFurnitureID()
  if not self.myFurnitureID then
    LogUtility.Error(string.format("没有找到npcid: %s的对应家具ID！", tostring(self.myNpcID)))
    self:CloseSelf()
    return
  end
  self:InitSettings()
  self:LoadCurSettings()
  self:SelectSettingType(self.curSettingType)
  self:InitBossSetting()
end

function SkadaSettingView:OnExit()
  self:DeleteSettings()
  SkadaSettingView.super.OnExit(self)
end

function SkadaSettingView:OnDestroy()
  self.listRace:Destroy()
  self.listNature:Destroy()
  self.listShape:Destroy()
  self.listType:Destroy()
  SkadaSettingView.super.OnDestroy(self)
end
