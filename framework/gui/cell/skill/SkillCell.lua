autoImport("SkillBaseCell")
autoImport("DragDropCell")
autoImport("SkillLine")
autoImport("SkillLineCombine")
SkillCell = class("SkillCell", SkillBaseCell)
SkillCell.Click_PreviewPeak = "SkillCell_Click_PreviewPeak"
SkillCell.SimulationUpgrade = "SkillCell_SimulationUpgrade"
SkillCell.SimulationDowngrade = "SkillCell_SimulationDowngrade"
SkillCell.EnableLineColor = Color(0.49411764705882355, 0.8, 0.10588235294117647, 1)
SkillCell.DisableLineColor = Color(0.45098039215686275, 0.45098039215686275, 0.45098039215686275, 1)
local vector3 = LuaVector3(0, 0, 0)
local GetLocalPosition = LuaGameObject.GetLocalPosition
local skillGuideID = {
  [4601001] = 206,
  [4609001] = 521,
  [4620001] = 207
}
local GetDistanceXY = function(transA, transB)
  local transAX, transAY = GetLocalPosition(transA)
  local transBX, transBY = GetLocalPosition(transB)
  return transAX - transBX, transAY - transBY
end
local GetHorizontalPos = function(sprite)
  local width = sprite.width
  LuaVector3.Better_Set(vector3, GetLocalPosition(sprite.transform))
  vector3[1] = vector3[1] + width
  return vector3
end
local GetHorizontalWidth = function(isPassive, disX, sprite)
  local fix = isPassive and 10 or 0
  return disX - sprite.width - 66 + fix
end
local GetVerticalPos = function(up, sprite, height)
  LuaVector3.Better_Set(vector3, GetLocalPosition(sprite.transform))
  LuaVector3.Better_Set(vector3, 45, vector3[2] + (up and height / 2 or -(height / 2)), 0)
  return vector3
end

function SkillCell:Init()
  self.nameEnableAlpha = 1
  SkillCell.super.Init(self)
  self:InitCell()
end

function SkillCell:InitCell()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
  self.skillLevel = self:FindGO("SkillLevel"):GetComponent(UILabel)
  self.skillCount = self:FindGO("Count"):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("LevelUpBtn")
  self.upgradeBtnSp = self:FindGO("LevelUpBtn"):GetComponent(UIMultiSprite)
  self.upgradeBtnSp.isChangeSnap = false
  self.previewBtn = self:FindGO("PreviewBtn")
  self.levelDelBtn = self:FindGO("LevelDelete"):GetComponent(UIButton)
  self.nameBg = self:FindGO("NameBg"):GetComponent(UIMultiSprite)
  self.skillIcon = self:FindGO("SkillIcon"):GetComponent(UISprite)
  self.share = self:FindGO("Share")
  self.func = self:FindGO("Func")
  self.clickCell = self:FindGO("SkillBg")
  self.dragDrop = DragDropCell.new(self.clickCell:GetComponent(UIDragItem), 0.01)
  self.dragDrop.dragDropComponent.data = self
  self:SetEvent(self.clickCell, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddSimulateButtonEvent()
  
  function self.dragDrop.dragDropComponent.OnStart(data)
    if GameConfig.SkillType[self.data.staticData.SkillType].isPassive then
      self.dragDrop.dragDropComponent:StopDrag()
      MsgManager.ShowMsgByIDTable(601)
    end
  end
  
  self:SetEvent(self.previewBtn, function()
    self:PassEvent(SkillCell.Click_PreviewPeak, self)
  end)
  self:Hide(self.levelDelBtn.gameObject)
  self:Hide(self.previewBtn)
end

function SkillCell:AddSimulateButtonEvent()
  self:SetEvent(self.upgradeBtn.gameObject, function()
    self:PassEvent(SkillCell.SimulationUpgrade, self)
  end)
  self:SetEvent(self.levelDelBtn.gameObject, function()
    self:PassEvent(SkillCell.SimulationDowngrade, self)
  end)
end

function SkillCell:IsClickMe(click)
  return click == self.clickCell
end

function SkillCell:SetData(data)
  self.data = data
  if self.data and self.data.shadow then
    self:Hide()
    return
  else
    self:Show()
  end
  if 12001 == self.data.id and self.clickCell ~= nil then
    self:AddOrRemoveGuideId(self.clickCell, 478)
  end
  if GameConfig.SkillView_SkillCell_GuideId ~= nil then
    for k, v in pairs(GameConfig.SkillView_SkillCell_GuideId) do
      if v == self.data.id and self.clickCell ~= nil then
        self:AddOrRemoveGuideId(self.clickCell, k)
      end
    end
  end
  if GameConfig.SkillView_SkillCell_GuideId_Add ~= nil then
    local upgradeId = GameConfig.SkillView_SkillCell_GuideId_Add[self.data.id]
    if upgradeId then
      self:AddOrRemoveGuideId(self.upgradeBtn.gameObject, upgradeId)
    end
  end
  local skillData = data.staticData
  self:UpdateName(skillData)
  self:UpdateLevel(skillData)
  self:UpdateIcon(skillData)
  self:UpdateSkillNameBg(skillData, self.data:HasRuneSpecials() and 2 or 0)
  self:UpdateUpgradeBtn(skillData)
  self:UpdateShare()
  self:UpdateFunc()
  self:UpdateDragable()
  self:ShowDowngrade(false)
  self:RegisterGuide()
end

function SkillCell:UpdateName(skillData)
  skillData = skillData or self.data.staticData
  if self.skillName ~= skillData.NameZh then
    local name = OverSea.LangManager.Instance():GetLangByKey(skillData.NameZh)
    local len = StringUtil.getTextLen(name)
    if 5 < len then
      name = StringUtil.SubString(name, 1, 4) .. "..."
    end
    self.skillName.text = name
    UIUtil.WrapLabel(self.skillName)
  end
end

function SkillCell:UpdateLevel(skillData)
  self.skillCount.gameObject:SetActive(self.data.maxTimes > 0)
  self.skillLevel.gameObject:SetActive(self.data.maxTimes <= 0)
  if self.data.maxTimes > 0 then
    self.skillCount.text = self.data.leftTimes .. "/" .. self.data.maxTimes
  else
    local breakEnable = SkillProxy.Instance:GetSkillCanBreak() or SimulateSkillProxy.Instance:GetSkillCanBreak()
    if self.data.learned then
      self:SetLevel(self.data.level, nil, breakEnable)
    else
      self:SetLevel(0, nil, breakEnable)
    end
    self:Show(self.skillLevel.gameObject)
  end
end

local sb = LuaStringBuilder.new()

function SkillCell:SetLevel(level, color, breakEnable)
  sb:Clear()
  local extraLevel = self.data:GetExtraLevel()
  local max = self.data.maxLevel
  if breakEnable and self.data.breakMaxLevel > 0 and MyselfProxy.Instance:HasJobBreak() then
    max = self.data.breakMaxLevel
  elseif 0 < self.data.breakNewMaxLevel and MyselfProxy.Instance:HasJobNewBreak() then
    max = self.data.breakNewMaxLevel
  end
  if level == 0 then
    if extraLevel ~= 0 then
      sb:Append(level)
      sb:Append("+")
      sb:Append(extraLevel)
      level = sb:ToString()
    end
    self.skillLevel.text = string.format(ZhString.SkillCell_Level, ColorUtil.GrayColor_16, level, max)
  else
    if extraLevel ~= 0 then
      sb:Append(level)
      sb:Append("[c][000000]")
      sb:Append("+")
      sb:Append(extraLevel)
      sb:Append("[-][/c]")
      level = sb:ToString()
    end
    if color then
      self.skillLevel.text = string.format(ZhString.SkillCell_Level, color, level, max)
    else
      self.skillLevel.text = level .. "/" .. max
    end
  end
end

function SkillCell:UpdateIcon(skillData)
  if skillData ~= nil then
    IconManager:SetSkillIconByProfess(skillData.Icon, self.skillIcon, MyselfProxy.Instance:GetMyProfessionType(), true)
    self:EnableGray(not self.data.learned)
  else
    self.icon.spriteName = nil
  end
end

function SkillCell:UpdateSkillNameBg(skillData, startIndex)
  if startIndex == nil then
    startIndex = 0
  end
  if GameConfig.SkillType[skillData.SkillType] and not GameConfig.SkillType[skillData.SkillType].isPassive then
    self.nameBg.CurrentState = startIndex
    LuaVector3.Better_Set(vector3, 75, 0, 0)
    self.nameBg.transform.localPosition = vector3
    self.nameBg.width = 178
  else
    self.nameBg.CurrentState = startIndex + 1
    LuaVector3.Better_Set(vector3, 67, 0, 0)
    self.nameBg.transform.localPosition = vector3
    self.nameBg.width = 186
  end
end

function SkillCell:EnableGray(value)
  if value then
    self.nameBg.alpha = 0.5
    self.skillName.alpha = 0.5
    ColorUtil.ShaderGrayUIWidget(self.skillIcon)
    self.skillIcon.alpha = 0.5
  else
    self.nameBg.alpha = 1
    self:SetNameAlpha(self.nameEnableAlpha)
    ColorUtil.WhiteUIWidget(self.skillIcon)
    self.skillIcon.alpha = 1
  end
end

function SkillCell:UpdateUpgradeBtn(skillData)
  if self.data:GetNextID(SkillProxy.Instance:GetSkillCanBreak()) ~= nil and self.data.active and skillData.Cost > 0 then
    self:ShowUpgrade(true)
  else
    self:ShowUpgrade(false)
  end
end

function SkillCell:UpdateDragable()
  if self.data == nil then
    self:SetDragEnable(false)
  else
    self:SetDragEnable(self.data.learned)
  end
end

function SkillCell:SetDragEnable(val)
  if self.data ~= nil and val then
    local typeConfig = GameConfig.SkillType[self.data.staticData.SkillType]
    local configEnableDrag = true
    if typeConfig and typeConfig.nodrag and typeConfig.nodrag == 1 then
      configEnableDrag = false
    end
    self.dragDrop:SetDragEnable(val and configEnableDrag)
  else
    self.dragDrop:SetDragEnable(false)
  end
end

function SkillCell:SetUpgradeEnable(val, breakEnable)
  if val then
    if breakEnable and MyselfProxy.Instance:HasJobBreak() and self.data ~= nil and self.data.breakMaxLevel > 0 then
      self.upgradeBtnSp.CurrentState = 2
    else
      self.upgradeBtnSp.CurrentState = 0
    end
  else
    self.upgradeBtnSp.CurrentState = 1
  end
end

function SkillCell:SetNameBgEnable(val)
  if val then
    self.nameEnableAlpha = 1
  else
    self.nameEnableAlpha = 0.6
  end
  self:SetNameAlpha(self.nameEnableAlpha)
end

function SkillCell:SetNameAlpha(alpha)
  self.skillName.alpha = alpha
end

function SkillCell:ShowPreview(value)
  if value then
    self:Show(self.previewBtn)
    self:Hide(self.upgradeBtn.gameObject)
  else
    self:Hide(self.previewBtn)
  end
end

function SkillCell:ShowUpgrade(value)
  if value then
    self:Show(self.upgradeBtn.gameObject)
    self:Hide(self.previewBtn)
  else
    self:Hide(self.upgradeBtn.gameObject)
  end
end

function SkillCell:ShowDowngrade(value)
  if value then
    self:Show(self.levelDelBtn.gameObject)
  else
    self:Hide(self.levelDelBtn.gameObject)
  end
end

function SkillCell:GetGridXY()
  local id = self.data.sortID * 1000 + 1
  local config = Table_SkillMould[id]
  if config ~= nil then
    local pos = config.Pos
    if 0 < #pos then
      return pos[1], pos[2]
    end
    pos = config.ProfessionPos
    if pos ~= nil then
      local professionPos = pos[self.data.profession]
      if professionPos ~= nil then
        return professionPos[1], professionPos[2]
      end
    end
  end
  return 0, 0
end

function SkillCell:RemoveLink()
  local lineMap = self.lineMap
  if lineMap == nil then
    return
  end
  for k, v in pairs(lineMap) do
    v:Destroy()
    lineMap[k] = nil
  end
  self.lineMap = nil
  self.combineLine = nil
  if self.multiLineMap then
    for sort1, lines in pairs(self.multiLineMap) do
      for sort2, line in pairs(lines) do
        line:Destroy()
        self.multiLineMap[sort1][sort2] = nil
      end
    end
    self.multiLineMap = nil
  end
end

function SkillCell:ResetLink()
  self.requiredCell = nil
  if self.requiredCells then
    TableUtility.ArrayClear(self.requiredCells)
  end
end

function SkillCell:DrawLink(cell, combine, isMulti)
  local lineMap = self.lineMap
  if lineMap == nil then
    lineMap = {}
    self.lineMap = lineMap
  end
  self:AddLine(cell, combine, isMulti)
  if not isMulti then
    cell.requiredCell = self
  else
    if not cell.requiredCells then
      cell.requiredCells = {}
    end
    cell.requiredCells[#cell.requiredCells + 1] = self
  end
end

function SkillCell:AddLine(toCell, combine, isMulti)
  local sortID = toCell.data.sortID
  local line = self.lineMap[sortID]
  if combine ~= nil and combine[sortID] ~= nil then
    line = self:CreateLineCombine(toCell)
  else
    if line ~= nil then
      line:Destroy()
    end
    line = self:CreateLine(toCell)
  end
  if not isMulti then
    self.lineMap[sortID] = line
  else
    local mlineMap = self.multiLineMap
    if mlineMap == nil then
      mlineMap = {}
      self.multiLineMap = mlineMap
    end
    local lines = self.multiLineMap[sortID]
    if not lines then
      lines = {}
      self.multiLineMap[sortID] = lines
    end
    lines[self.data.sortID] = line
  end
end

function SkillCell:CreateLine(toCell)
  local line = SkillLine.new(self.gameObject)
  local nameBg = self.nameBg
  local fromX, fromY = self:GetGridXY()
  local toX, toY = toCell:GetGridXY()
  local disX, disY = GetDistanceXY(toCell.trans, self.trans)
  if fromX == toX then
    local height = self.skillIcon.height
    local up = fromY > toY
    local pos = GetVerticalPos(up, nameBg, height)
    line:DrawVertical(up, pos, math.abs(disY) - height)
  elseif fromY == toY then
    local pos = GetHorizontalPos(nameBg)
    local width = GetHorizontalWidth(GameConfig.SkillType[self.data.staticData.SkillType].isPassive, disX, nameBg)
    line:DrawHorizontal(pos, width)
  end
  return line
end

function SkillCell:CreateLineCombine(toCell)
  local nameBg = self.nameBg
  local disX, disY = GetDistanceXY(toCell.trans, self.trans)
  local width = GetHorizontalWidth(GameConfig.SkillType[self.data.staticData.SkillType].isPassive, disX, nameBg)
  width = width / 2
  local line = self.combineLine
  if line == nil then
    line = SkillLineCombine.new(self.gameObject)
    self.combineLine = line
    local pos = GetHorizontalPos(nameBg)
    line:DrawHorizontal(pos, width)
  end
  line:AddLine(toCell.data.sortID, width, disY)
  return line
end

function SkillCell:LinkUnlock(sortID, val)
  local lineMap = self.lineMap
  if lineMap == nil then
    return
  end
  local line = lineMap[sortID]
  if line == nil then
    return
  end
  line:Unlock(sortID, val)
end

function SkillCell:MultiLinkUnlock(sortID, val)
  local mlineMap = self.multiLineMap
  if mlineMap == nil then
    return
  end
  local lines = mlineMap[sortID]
  if lines == nil then
    return
  end
  local line = lines[self.data.sortID]
  if line then
    line:Unlock(sortID, val)
  end
end

function SkillCell:UpdateShare()
  self.share:SetActive(self.data:GetIsShare())
end

function SkillCell:RegisterGuide()
  local skillID = self.data.staticData.id
  self.guideId = skillGuideID[skillID]
  if self.guideId then
    self:AddOrRemoveGuideId(self.clickCell, self.guideId)
  end
end

function SkillCell:IsMatchGuide(guideId, obj)
  return self.guideId == guideId and self.skillIcon ~= nil and self.skillIcon.gameObject == obj.gameObject
end

function SkillCell:UpdateFunc()
  local isFunc = false
  for k, v in pairs(SkillItemData.FuncType) do
    if self.data:CheckFuncOpen(v) then
      isFunc = true
      break
    end
  end
  self.func:SetActive(isFunc)
end

function SkillCell:OnCellDestroy()
  TableUtility.TableClear(self.dragDrop)
end

AdventureSkillCell = class("AdventureSkillCell", SkillCell)

function AdventureSkillCell:InitCell()
  AdventureSkillCell.super.InitCell(self)
  self:TryFindObjs()
end

function AdventureSkillCell:SetData(data)
  AdventureSkillCell.super.SetData(self, data)
  self:UpdateExpireTime()
  self:UpdateUsedCount()
end

function AdventureSkillCell:RefreshCountdown(deltaTime)
  return self:SetExpireTime()
end

function AdventureSkillCell:UpdateLevel(skillData)
  self.super.UpdateLevel(self, skillData)
  if self.data.maxTimes <= 0 and skillData.NextID == nil and skillData.Level <= 1 then
    self:Hide(self.skillLevel.gameObject)
  end
end

function AdventureSkillCell:SetLevel(level, color)
  if level == 0 then
    self.skillLevel.text = string.format("[c][%s]0/%s[-][/c]", ColorUtil.GrayColor_16, self.data.maxLevel)
  else
    self.skillLevel.text = "Lv." .. level
  end
end
