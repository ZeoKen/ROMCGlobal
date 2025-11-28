local baseCell = autoImport("BaseCell")
QuestTableCell = class("QuestTableCell", baseCell)
QuestTableCell.QuestBackgroundColor = {
  [6] = Color(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.3),
  [5] = Color(0 / 255.0, 0.2549019607843137, 0.6980392156862745, 0.3),
  [1] = Color(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.3),
  [2] = Color(0.21176470588235294, 0.5058823529411764, 0.6980392156862745, 0.2),
  [4] = Color(0.6431372549019608, 0.21176470588235294, 0.6980392156862745, 0.15),
  [3] = Color(0.21176470588235294, 0.6980392156862745, 0.24313725490196078, 0.15),
  [7] = Color(1, 0.8117647058823529, 0.050980392156862744, 0.4),
  [20] = Color(0.3607843137254902, 0.9215686274509803, 0.9019607843137255, 0.4),
  [999] = Color(1, 1, 1, 0.4)
}
local tempV3_Hide = LuaVector3.One()
local tempV3_Show = LuaVector3(-1, 1, 1)

function QuestTableCell:Init()
  QuestTableCell.super.Init(self)
  self:AddCellClickEvent()
  self.selectedBg = self:FindGO("selectedBg")
  self.questName = self:FindComponent("questName", UILabel)
  self.grid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardList = UIGridListCtrl.new(self.grid, QuestTableRewardCell, "QuestTableRewardCell")
  self.checkBox = self:FindComponent("checkBoxBg", UIToggle)
  self.TitleIcon = self:FindGO("TitleIcon")
  self.TitleIcon_UISprite = self.TitleIcon:GetComponent(UISprite)
  self.HideArrow = self:FindGO("HideArrow")
  self.HideArrow_UISprite = self.HideArrow:GetComponent(UISprite)
  self.HideArrow_Toggle = self.HideArrow:GetComponent(UIToggle)
  self.repairBtn = self:FindGO("RepairBtn")
  self.IsHide = true
  self:AddButtonEvent("checkBox", function()
    local traces = {}
    if self.groupid then
      for i = 1, #self.questList do
        local trace = {}
        trace.id = self.questList[i].id
        trace.trace = not self.questList[i].trace
        traces[#traces + 1] = trace
      end
      ServiceQuestProxy.Instance:CallQuestGroupTraceQuestCmd(traces)
    else
      local trace = {}
      trace.id = self.data.id
      trace.trace = not self.data.trace
      traces[#traces + 1] = trace
      ServiceQuestProxy.Instance:CallQuestGroupTraceQuestCmd(traces)
    end
    self.checkBox.value = not self.data.trace
    if not self.checkBox.value then
      GameFacade.Instance:sendNotification(QuestEvent.QuestTraceOff, self)
    end
  end)
  self:AddButtonEvent("HideArrow", function()
    self:switchHideArrow()
    self:InitEventListener()
  end)
  self:AddButtonEvent("RepairBtn", function()
    self:PassEvent("QuestTableCell_ClickRepair", self)
  end)
  self:setIsSelected(false)
end

function QuestTableCell:InitEventListener()
  local cells = self.rewardList:GetCells()
  if 0 < #cells then
    self:PassEvent("RefreshListShow", self)
  end
end

function QuestTableCell:InitArrowDir()
  local cells = self.rewardList:GetCells()
  if #cells ~= 0 then
    self.IsHide = false
    self.HideArrow.transform.localScale = tempV3_Show
  else
    self.IsHide = true
    self.HideArrow.transform.localScale = tempV3_Hide
  end
end

function QuestTableCell:switchHideArrow()
  if self.IsHide == true then
    self.HideArrow.transform.localScale = tempV3_Show
    self.grid.gameObject:SetActive(true)
    self.IsHide = false
  else
    self.HideArrow.transform.localScale = tempV3_Hide
    self.grid.gameObject:SetActive(false)
    self.IsHide = true
  end
end

function QuestTableCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self:Show(self.selectedBg)
    else
      self:Hide(self.selectedBg)
    end
  end
end

function QuestTableCell:SetData(data)
  if data.isCombined and data.groupid then
    self.questList = data.questList
    self.groupid = data.groupid
    self.data = data.questList[1]
  else
    self.questList = nil
    self.groupid = nil
    self.data = data
  end
  local level = self.data.staticData.Name.Level
  level = level and "Lv." .. level or ""
  self.questName.text = self.data.staticData.Name .. level
  self.checkBox.value = self.data.trace
  local rewards = QuestProxy.Instance:getValidReward(self.data)
  rewards = rewards or {}
  self.ColorFromServer = nil
  if self.data.staticData and self.data.staticData.ColorFromServer then
    self.ColorFromServer = self.data.staticData.ColorFromServer
  else
    helplog("该任务颜色号码缺失:", self.data.id)
  end
  self.IconFromServer = nil
  if self.data.staticData and self.data.staticData.IconFromServer then
    self.IconFromServer = self.data.staticData.IconFromServer
  else
    helplog("该任务图标号码缺失:", self.data.id)
  end
  self.specialIcon = nil
  if self.data.staticData and self.data.staticData.headIcon then
    self.specialIcon = self.data.staticData.headIcon
  end
  self:ShowQuestIcon(self.specialIcon)
  self.rewardList:ResetDatas(rewards)
  self:InitArrowDir()
  self:ShowRepairBtn()
end

function QuestTableCell:ShowQuestBackground(specialIcon)
  if self.ColorFromServer and self.ColorFromServer ~= 0 then
    local specialBG
    if specialIcon == 0 then
      specialIcon = self.ColorFromServer
    end
    if QuestSymbolConfig[specialIcon] then
      specialBG = QuestSymbolConfig[specialIcon].QuestTableCellBG
    end
    if specialIcon ~= 0 and specialBG ~= nil then
      local ui1Atlas = RO.AtlasMap.GetAtlas("NewUI5")
      if ui1Atlas then
        self.backgroundIcon.atlas = ui1Atlas
        local specialSprite = QuestSymbolConfig[specialIcon].QuestTableCellBG
        self.backgroundIcon.spriteName = specialSprite
        self.backgroundIcon.color = Color(1, 1, 1, 1)
      end
    else
      local ui1Atlas = RO.AtlasMap.GetAtlas("NewUI4")
      if ui1Atlas then
        self.backgroundIcon.atlas = ui1Atlas
        local commonSprite = "main_task_bg_00"
        self.backgroundIcon.spriteName = commonSprite
        if self.ColorFromServer ~= 0 and QuestTableCell.QuestBackgroundColor[self.ColorFromServer] then
          self.backgroundIcon.color = QuestTableCell.QuestBackgroundColor[self.ColorFromServer]
        else
          redlog("任务ID" .. self.data.id .. "未配置ColorFromServer")
          self.backgroundIcon.color = QuestTableCell.QuestBackgroundColor[999]
        end
      end
    end
  end
end

function QuestTableCell:ShowQuestIcon(specialIcon)
  if self.IconFromServer and self.IconFromServer ~= 0 then
    local tempIconNum
    if specialIcon and specialIcon ~= 0 and GameConfig.Quest.TraceIcon[specialIcon] ~= nil then
      tempIconNum = specialIcon
    else
      tempIconNum = self.IconFromServer
    end
    if GameConfig and GameConfig.Quest and GameConfig.Quest.TraceIcon and GameConfig.Quest.TraceIcon[tempIconNum] then
      local atlasStr = GameConfig.Quest.TraceIcon[tempIconNum][2]
      local spriteNameStr = GameConfig.Quest.TraceIcon[tempIconNum][1]
      local iconScale = GameConfig.Quest.TraceIcon[tempIconNum][3]
      local needMakePixelPerfect = GameConfig.Quest.TraceIcon[tempIconNum][4]
      if atlasStr and spriteNameStr then
        if IconManager:SetIconByType(spriteNameStr, self.TitleIcon_UISprite, atlasStr) then
          self:Show(self.TitleIcon)
          if needMakePixelPerfect then
            self.TitleIcon_UISprite:MakePixelPerfect()
          end
          if iconScale then
            self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
          elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
            self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
          end
          return
        end
        local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
        if ui1Atlas == nil then
          helplog("Gameconfig设置中atlas缺失" .. atlasStr)
          self:Hide(self.TitleIcon)
          return
        end
        self.TitleIcon_UISprite.atlas = ui1Atlas
        self.TitleIcon_UISprite.spriteName = spriteNameStr
        self:Show(self.TitleIcon)
        if needMakePixelPerfect then
          self.TitleIcon_UISprite:MakePixelPerfect()
        end
        if iconScale then
          self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
        elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
          self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
        end
        return
      else
        helplog("配置表GameConfig.Quest.TraceIcon出错:self.IconFromServer:" .. self.IconFromServer)
      end
    else
      helplog("配置表GameConfig.Quest.TraceIcon出错:self.IconFromServer:" .. self.IconFromServer)
    end
  end
  self:Hide(self.TitleIcon)
end

function QuestTableCell:ShowRepairBtn()
  if MyselfProxy.Instance.questRepairModeOn then
    self.repairBtn:SetActive(true)
  else
    self.repairBtn:SetActive(false)
  end
end
