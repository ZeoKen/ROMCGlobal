autoImport("QuestTraceBaseTogCell")
MainQuestTraceCell = class("MainQuestTraceCell", QuestTraceBaseTogCell)
local _PrestigePartColor = {
  [1] = LuaColor.White(),
  [2] = LuaColor.New(1, 0.9450980392156862, 0.9450980392156862, 1),
  [3] = LuaColor.New(0.9450980392156862, 1.0, 0.9607843137254902, 1),
  [4] = LuaColor.New(1, 0.8745098039215686, 0.7764705882352941, 1),
  [5] = LuaColor.New(0.8509803921568627, 0.8509803921568627, 0.8509803921568627, 1),
  [6] = LuaColor.New(1, 0.8352941176470589, 0.9568627450980393, 1)
}
local _PrestigeOutlineColor = {
  [1] = LuaColor.New(0.8, 0.2549019607843137, 0.24705882352941178, 1),
  [2] = LuaColor.New(0.7568627450980392, 0.17647058823529413, 0.4470588235294118, 1),
  [3] = LuaColor.New(0.3411764705882353, 0.6509803921568628, 0.5725490196078431, 1),
  [4] = LuaColor.New(0.8431372549019608, 0.5490196078431373, 0.3215686274509804, 1),
  [5] = LuaColor.New(0.41568627450980394, 0.41568627450980394, 0.41568627450980394, 1),
  [6] = LuaColor.New(0.7647058823529411, 0.27058823529411763, 0.6431372549019608, 1)
}

function MainQuestTraceCell:Init()
  MainQuestTraceCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function MainQuestTraceCell:FindObjs()
  MainQuestTraceCell.super.FindObjs(self)
  self.lv = self:FindGO("Lv"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.newLevel = self:FindGO("NewLevel")
  self.newLevel:SetActive(false)
  self.prestigePart = self:FindGO("PrestigeLevelPart")
  self.prestigeIcon_BG = self.prestigePart:GetComponent(UISprite)
  self.prestigeLevel = self:FindGO("PrestigeLevel", self.prestigePart):GetComponent(UILabel)
  self.prestigeBg = self:FindGO("PrestigeBg", self.prestigePart):GetComponent(UIMultiSprite)
  self.prestigeShineBg = self:FindGO("ShineBg", self.prestigePart):GetComponent(UIMultiSprite)
  self.prestigeNoLevel = self:FindGO("PrestigeNoLevel", self.prestigePart):GetComponent(UIMultiSprite)
  self.prestigePart:SetActive(false)
end

function MainQuestTraceCell:ResetData()
  self:SetData(self.cellData)
end

function MainQuestTraceCell:SetData(data)
  self.cellData = data
  if data.isKnight then
    self.prestigePart:SetActive(true)
    self.lv.text = ""
    self.prestigeVersion = data.prestigeVersion
    self.prestigeIcon_BG.color = _PrestigePartColor[self.prestigeVersion]
    self.prestigeLevel.effectColor = _PrestigeOutlineColor[self.prestigeVersion]
    local titleConfig = GameConfig.Prestige and GameConfig.Prestige.PrestigeTitle
    local prestigeInfo = VersionPrestigeProxy.Instance:GetPrestigeInfo(self.prestigeVersion)
    local staticPrestigeInfo = VersionPrestigeProxy.Instance:GetStaticPrestigeInfo(self.prestigeVersion)
    local notify = prestigeInfo and prestigeInfo.levelUpNotify or false
    self.newLevel:SetActive(notify)
    local maxLevel = staticPrestigeInfo and staticPrestigeInfo.MaxLevel
    local curLv = prestigeInfo and prestigeInfo.level or 0
    local titleStr = titleConfig and titleConfig[self.prestigeVersion] and titleConfig[self.prestigeVersion].level_name or "???"
    if curLv == 0 then
      self.title.text = titleStr
    else
      self.title.text = titleStr .. " Lv." .. curLv
    end
    self.title.color = LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
    self:ResetPrestigeLevel(curLv)
    RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_PRESTIGE_SYSTEM_REWARD, self.gameObject, 39, {-20, -10}, nil, self.prestigeVersion)
    return
  end
  self.prestigePart:SetActive(false)
  self.title.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-83.82, 0, 0)
  local curWorldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
  local isCurWorldGroupAllFinish = Game.MapManager:GetWorldQuestProcessAllFinish(curWorldQuestGroup)
  self.version = data.version
  self.index = data.index
  self.isUnlock = data.isUnlock or false
  self.raceValid = data.raceValid
  self.indexID = QuestManualProxy.Instance:GetStoryConfigByIndex(self.version, self.index)
  if not self.indexID then
    redlog("没有搜寻到对应ID", self.version, self.index)
  end
  self.questData = data.questData or nil
  self.data = data.questData or nil
  local isFakeData = true
  if self.questData then
    local questid = self.questData.id
    local realQuestData = QuestProxy.Instance:getQuestDataByIdAndType(questid)
    if realQuestData then
      isFakeData = false
      self.questData = realQuestData
      self.data = realQuestData
    end
  end
  local config = Table_MainQuestStory[self.indexID]
  local minLevel = config and config.LvRange and config.LvRange[1] or 1
  local questLvLimit = self.questData and self.questData.staticData.Level or 1
  if self.questData and self.questData.questDataStepType == QuestDataStepType.QuestDataStepType_LEVEL then
    local _level = self.questData.params.base or 1
    questLvLimit = math.max(questLvLimit, _level)
  end
  local param_Lv = self.questData and self.questData.params.level
  self.lv.text = "Lv." .. math.max(minLevel, questLvLimit)
  self.toggleGO:SetActive(false)
  self.lockSymbol:SetActive(false)
  self.finishSymbol:SetActive(false)
  self.questType = data.questType
  if self.questData then
    self.title.text = self.questData.traceTitle or "???"
    self.lv.color = LuaGeometry.GetTempVector4(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
    self.title.color = LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
    self.toggleGO:SetActive(not isFakeData)
    if self.questType ~= 1 then
      self.lockSymbol:SetActive(true)
      self.title.color = LuaGeometry.GetTempVector4(0.49411764705882355, 0.49411764705882355, 0.49411764705882355, 1)
    end
  else
    if config then
      self.title.text = config and config.QuestName
    else
      self.title.text = "配置错误 index: " .. self.index
    end
    self.finishSymbol:SetActive(self.isUnlock)
    self.lockSymbol:SetActive(not self.isUnlock)
    self.lv.color = self.isUnlock and LuaGeometry.GetTempVector4(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1) or LuaGeometry.GetTempVector4(0.5215686274509804, 0.5176470588235295, 0.5176470588235295, 1)
    self.title.color = self.isUnlock and LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1) or LuaGeometry.GetTempVector4(0.49411764705882355, 0.49411764705882355, 0.49411764705882355, 1)
  end
  self:SetQuestIcon()
  self:SetChooseStatus(false)
  TimeTickManager.Me():ClearTick(self, 1)
  self.tweenPos:ResetToBeginning()
  self.tweenPos.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha.enabled = false
  if not self.isUnlock then
    local questId = self.data and self.data.id
    if not questId then
      return
    end
    local status = QuestProxy.Instance:CheckQuestIsTrace(self.data.id)
    local isTrace = false
    if curWorldQuestGroup and not isCurWorldGroupAllFinish then
      if status and status == 3 then
        local version = Table_WorldQuest[self.data.id] and Table_WorldQuest[self.data.id].Version
        if version == curWorldQuestGroup then
          isTrace = true
        end
      elseif status and status == 1 then
        isTrace = true
      end
    elseif status and status == 1 then
      isTrace = true
    else
      isTrace = false
    end
    self.toggle.value = isTrace
  end
end

function MainQuestTraceCell:SetNewSymbol(bool)
  self.newSymbol:SetActive(bool)
end

function MainQuestTraceCell:SetChooseStatus(bool)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(bool)
  else
    redlog("no chooseSymbol")
  end
end

function MainQuestTraceCell:PlayTween()
  if self.indexInList > 6 then
    self.tweenPos.enabled = false
    self.tweenAlpha.enabled = false
    self.tweenPos:PlayForward()
    self.tweenAlpha:PlayForward()
    return
  end
  self.tweenPos.delay = 0.1 * self.indexInList
  self.tweenPos.enabled = false
  self.tweenPos:ResetToBeginning()
  self.tweenPos:PlayForward()
  self.tweenAlpha.delay = 0.1 * self.indexInList
  self.tweenAlpha.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha:PlayForward()
end

function MainQuestTraceCell:PlayReverse()
  self.tweenPos:ResetToBeginning()
  self.tweenAlpha:ResetToBeginning()
end

function MainQuestTraceCell:OnCellDestroy()
  MainQuestTraceCell.super.OnCellDestroy(self)
  TimeTickManager.Me():ClearTick(self)
end

function MainQuestTraceCell:ResetPrestigeLevel(level)
  if not self.cellData.isKnight then
    return
  end
  if level == 0 then
    self.prestigeBg.gameObject:SetActive(false)
    self.prestigeNoLevel.gameObject:SetActive(true)
    self.prestigeNoLevel.CurrentState = self.prestigeVersion - 1
    self.prestigeLevel.text = ""
    self.prestigeShineBg.gameObject:SetActive(false)
  else
    self.prestigeBg.gameObject:SetActive(true)
    self.prestigeNoLevel.gameObject:SetActive(false)
    self.prestigeBg.CurrentState = self.prestigeVersion - 1
    self.prestigeLevel.text = level
    self.prestigeShineBg.gameObject:SetActive(true)
    self.prestigeShineBg.CurrentState = self.prestigeVersion - 1
  end
end
