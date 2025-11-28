autoImport("SkillCell")
autoImport("SkillItemData")
FourthSkillCell = class("FourthSkillCell", SkillCell)
FourthSkillCell.ClickFourthBreak = "FourthSkillCell_ClickFourthBreak"

function FourthSkillCell:Init()
  FourthSkillCell.super.Init(self)
  self.objContent = self:FindGO("content")
  self.objBtnFourthBreak = self:FindGO("BtnFourthBreak")
  self:AddClickEvent(self.objBtnFourthBreak, function()
    self:PassEvent(FourthSkillCell.ClickFourthBreak, self)
  end)
end

function FourthSkillCell:InitCell()
  FourthSkillCell.super.InitCell(self)
  self.highlightFrame = self:FindGO("frame")
  self.highlightEffect = self:PlayUIEffect(EffectMap.UI.HeroFeatures, self.highlightFrame)
end

function FourthSkillCell:SetData(data)
  self.maxLevel = data.maxLevel
  self.simulateID = data.id
  FourthSkillCell.super.SetData(self, data)
  self:EnableGray(false)
  self:UpdateHighlight()
end

function FourthSkillCell:SetLevel(curLevel, color, breakEnable)
  self.curLevel = curLevel
  self.simulateLevel = curLevel
  self:SetLevelText()
  self:RefreshSimulateStatus()
end

function FourthSkillCell:GetCurLevel()
  return self.curLevel
end

function FourthSkillCell:GetSimulateLevel()
  return self.simulateLevel
end

function FourthSkillCell:SetLevelText()
  local color
  if self.simulateLevel < 1 then
    color = ColorUtil.GrayColor_16
  elseif self.simulateLevel > self.curLevel then
    color = "54B30A"
  else
    color = "000000"
  end
  self.skillLevel.text = string.format("[c][%s]%d[-][/c]/%d", color, self.simulateLevel, self.maxLevel)
end

function FourthSkillCell:GetRequireSkillID()
  return self.data.requiredSkillID
end

function FourthSkillCell:TrySimulateUpgrade()
  if self.simulateLevel < self.maxLevel then
    self.simulateLevel = self.simulateLevel + 1
    self:SetLevelText()
    if self.simulateLevel >= self.maxLevel then
      self:ShowUpgrade(false)
    end
    self:ShowDowngrade(true)
    self:RefreshSimulateStatus()
    self:RefreshCellColor()
    return true
  else
    return false
  end
end

function FourthSkillCell:TrySimulateDowngrade()
  if self.simulateLevel > self.curLevel then
    self.simulateLevel = self.simulateLevel - 1
    self:SetLevelText()
    if self.simulateLevel <= self.curLevel then
      self:ShowDowngrade(false)
    end
    self:ShowUpgrade(true)
    self:RefreshSimulateStatus()
    self:RefreshCellColor()
    return true
  else
    return false
  end
end

function FourthSkillCell:IsFitNextJobLevel(jobLevel)
  local needLv
  if not self.data.learned then
    needLv = self.data.staticData.Contidion.joblv
  elseif self.nextStaticData and self.nextStaticData.Contidion then
    needLv = self.nextStaticData.Contidion.joblv
  end
  if needLv then
    return jobLevel >= needLv, needLv
  end
  return true, 0
end

function FourthSkillCell:SetCellEnable(enableUpgrade, enableDowngrade)
  self:ShowUpgrade(enableUpgrade and self.simulateLevel < self.maxLevel)
  self:ShowDowngrade(enableDowngrade and self.simulateLevel > self.curLevel)
  self:RefreshCellColor()
end

function FourthSkillCell:RefreshCellColor()
  if self.simulateLevel > 0 then
    self:SetTextureWhite(self.skillIcon.gameObject)
  else
    self:SetTextureGrey(self.skillIcon.gameObject)
  end
end

function FourthSkillCell:IsChanged()
  return self.simulateLevel > self.curLevel
end

function FourthSkillCell:SetDisableOperate()
  self:ShowUpgrade(false)
  self:ShowDowngrade(false)
  self:EnableGray(self.simulateLevel < 1)
end

function FourthSkillCell:TryGetSimulateSkillID()
  if not self:IsChanged() then
    return nil
  end
  local id = self.data.id
  local skillData
  for i = math.max(self.curLevel, 1), self.simulateLevel - 1 do
    skillData = Table_Skill[id]
    if skillData and skillData.NextID then
      id = skillData.NextID
    end
  end
  return id
end

function FourthSkillCell:GetSimulateStaticData()
  return self.curStaticData
end

function FourthSkillCell:GetNextSkillStaticData()
  return self.nextStaticData
end

function FourthSkillCell:RefreshSimulateStatus()
  self.simulateID = self:TryGetSimulateSkillID() or self.data.id
  self.curStaticData = Table_Skill[self.simulateID]
  if self.simulateLevel < 1 then
    self.nextStaticData = self.curStaticData
  else
    local nextData = self.curStaticData and self.curStaticData.NextID and Table_Skill[self.curStaticData.NextID]
    self.nextStaticData = nextData and (nextData.ExtraMaxLevel or 0) <= self.data.extraMaxLevel and nextData or nil
  end
end

function FourthSkillCell:GetSimulateSkillItemData()
  if self:IsChanged() then
    if not self.simulateData then
      self.simulateData = SkillItemData.new(self.simulateID, 0, 0, self.data.profession, nil, nil, nil, self.data.extraMaxLevel)
    elseif self.simulateData.id ~= self.simulateID or self.simulateData.extraMaxLevel ~= self.data.extraMaxLevel then
      self.simulateData:Reset(self.simulateID, 0, 0, self.data.profession, nil, nil, nil, self.data.extraMaxLevel)
    end
    self.simulateData:SetLearned(0 < self.simulateLevel)
    return self.simulateData
  else
    return self.data
  end
end

function FourthSkillCell:SetLocalPosition(posX, posY)
  self.curPosX = posX
  self.curPosY = posY
  self.trans.localPosition = LuaGeometry.GetTempVector3(posX, posY, 0)
end

function FourthSkillCell:CreateLine(toCell)
  if self.curPosX and toCell.curPosX then
    local line = SkillLine.new(self.gameObject)
    line:DrawBetween(self.curPosX, self.curPosY, toCell.curPosX, toCell.curPosY)
    return line
  else
    LogUtility.Error("Please call FourthSkillCell:SetLocalPosition() before draw line")
    return FourthSkillCell.super.CreateLine(self, toCell)
  end
end

function FourthSkillCell:ShowBreakButton(isShow)
  local canShow = isShow == true and self.data:GetNextFourthBreakData() ~= nil
  if self.isBreakButtonActive == canShow then
    return
  end
  self.objBtnFourthBreak:SetActive(canShow)
  self.isBreakButtonActive = canShow
end

function FourthSkillCell:UpdateHighlight()
  local id = self.data.sortID * 1000 + 1
  local config = Table_SkillMould[id]
  local isShow = false
  if config then
    isShow = config.Feature == 1
  end
  self.highlightFrame:SetActive(isShow)
end

function FourthSkillCell:DestroyHightEffect()
  if self.highlightEffect then
    self.highlightEffect:Destroy()
    self.highlightEffect = nil
  end
end

function FourthSkillCell:OnCellDestroy()
  self:DestroyHightEffect()
end
