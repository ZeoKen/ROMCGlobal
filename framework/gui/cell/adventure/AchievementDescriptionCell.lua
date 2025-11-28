local baseCell = autoImport("BaseCell")
AchievementDescriptionCell = class("AchievementDescriptionCell", baseCell)
autoImport("AchievementQuestCell")
autoImport("AchievementPreQuestCell")
AchievementDescriptionCell.behaviorEnum = {
  levelup = "levelup",
  addfriend = "addfriend",
  mapmove = "mapmove",
  killmonster = "killmonster",
  killcat = "killcat",
  Commissioned = "Commissioned",
  Quest = "questfinish",
  SameQuest = "quest_some_finish",
  Achieve = "achievementfinish"
}
AchievementDescriptionCell.SubAchieve = {Achieve = 1, Quest = 2}
local tempArray = {}
local tempVector3 = LuaVector3.Zero()
AchievementDescriptionCell.RewardTextColor = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
AchievementDescriptionCell.RewardTitleColor = LuaColor.New(0.2784313725490196, 0.5725490196078431, 0.9294117647058824, 1)
AchievementDescriptionCell.SubAchieveClick = "AchievementDescriptionCell_SubAchieveClick"

function AchievementDescriptionCell:Init()
  self:initView()
  self:AddCellClickEvent()
end

function AchievementDescriptionCell:initView()
  self.name = self:FindComponent("AchievementName", UILabel)
  self.completeDate = self:FindComponent("completeDate", UILabel)
  self.AchievementCondition = self:FindComponent("AchievementCondition", UILabel)
  self.description = self:FindComponent("description", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
  self.bg = self:FindComponent("bg", UISprite)
  local rewardTitle = self:FindComponent("rewardTitle", UILabel)
  rewardTitle.text = ZhString.AdventureAchievePage_RewardTitle
  local rewardGrid = self:FindComponent("rewardGrid", UIGrid)
  self.rewardGrid = UIGridListCtrl.new(rewardGrid, AdvTipRewardCell, "AdvTipRewardCell")
  self.rewardGrid:AddEventListener(MouseEvent.MouseClick, self.RewardItemClick, self)
  local achievementQuestGrid = self:FindComponent("AchievementQuestGrid", UIGrid)
  self.achievementQuestGrid = UIGridListCtrl.new(achievementQuestGrid, AchievementQuestCell, "AchievementQuestCell")
  self.achievementQuestGrid:AddEventListener(MouseEvent.MouseClick, self.SubAchieveClick, self)
  self.completeIcon = self:FindGO("completeIcon")
  self.completeIcon:SetActive(false)
  IconManager:SetArtFontIcon("Rewardtask_txt_1", self.completeIcon:GetComponent(UISprite))
  self.AchievementIcon = self:FindComponent("AchievementIcon", UISprite)
  self.collapse = self:FindGO("collapse")
  self.shareBtn = self:FindGO("shareBtn")
  self:Hide(self.shareBtn)
  self.rewardCt = self:FindGO("rewardCt")
  self.questCt = self:FindGO("questCt")
  local tipCell = self:FindGO("AdvTipRewardCell")
  self.AdvTipRewardCell = AdvTipRewardCell.new(tipCell)
  self.addSymbol = self:FindGO("addSymbol")
  self:AddClickEvent(self.addSymbol, function()
    ServiceAchieveCmdProxy.Instance:CallRewardGetAchCmd(self.data.id)
    self:PlayUnlockEffect()
  end)
  self.content = self:FindGO("content")
  self.rewardLine = self:FindGO("RewardLine"):GetComponent(UISprite)
  self.rewardPreviewPart = self:FindGO("RewardPreviewPart")
  self.itemReward = self:FindGO("ItemReward")
  self.itemRewardIcon = self:FindGO("ItemIcon", self.itemReward):GetComponent(UISprite)
  self.BufferLabel = self:FindComponent("BufferLabel", UILabel)
  self:Hide(self.BufferLabel.gameObject)
  self.effectContainer = self:FindGO("EffectContainer")
  self.timeLimitGO = self:FindGO("TimeLimit")
  self.timeLimitBG = self.timeLimitGO:GetComponent(UISprite)
  self.timeLimitLabel = self:FindComponent("TimeLimitLabel", UILabel)
end

function AchievementDescriptionCell:SubAchieveClick(cellCtl)
  if cellCtl.data and cellCtl.data.type == AchievementDescriptionCell.SubAchieve.Achieve then
    self:PassEvent(AchievementDescriptionCell.SubAchieveClick, cellCtl.data)
  end
end

function AchievementDescriptionCell:RewardItemClick(cellCtl)
  if cellCtl.data then
    local data = cellCtl.data.value
    if data and type(data) == "table" then
      local newClickId = data[1]
      if self.clickId ~= newClickId then
        self.clickId = newClickId
        local callback = function()
          self.clickId = 0
        end
        local itemData = ItemData.new(nil, data[1])
        local stick = self.bg
        if itemData.staticData.Type == 10 then
          local t = Table_Appellation[itemData.staticData.id]
          if t and t.GroupID then
            local csv = Table_Appellation[itemData.staticData.id]
            local sdata = TitleData.new(t.GroupID, csv)
            sdata.hideFlag = true
            local data = {itemdata = sdata}
            if self.data and not self.data:canGetReward() and self.data:getCompleteString() then
              data.itemdata.unlocked = true
            end
            TipManager.Instance:ShowTitleTip(data, stick, nil, {200, 0})
          end
        else
          local sdata = {
            itemdata = itemData,
            funcConfig = {},
            hideGetPath = true,
            callback = callback
          }
          self:ShowItemTip(sdata, stick, nil, {200, 0})
        end
      else
        self:ShowItemTip()
        self.clickId = 0
      end
    else
      self:ShowItemTip()
      self.clickId = 0
    end
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end

function AchievementDescriptionCell:SetData(data)
  if not data then
    self:Hide()
    return
  end
  self:Show()
  self.data = data
  self.name.text = self.data.staticData.Name
  if self.name.width < 190 then
    self.name.overflowMethod = 2
  else
    self.name.overflowMethod = 0
    self.name.width = 190
    self.name.height = 40
  end
  self:SetRewardData()
  self:SetRefrestTime()
  local sus = IconManager:SetIconByType(self.data.staticData.Icon, self.icon, self.data.staticData.Atlas, "uiicon")
  if sus then
    self:Show(self.icon.gameObject)
  else
    self:Hide(self.icon.gameObject)
  end
  local textData = Table_AchievementText[self.data.staticData.AchievementTextID]
  local textStr = ""
  if textData then
    textStr = textData.Text
  end
  self.description.text = textStr
  self:SetTraceInfo()
  self:SetAchieveQuest()
  local dateStr = data:getCompleteString()
  if data:canGetReward() then
    self:Show(self.addSymbol)
    self:SetTextureGrey(self.icon)
    self:Hide(self.completeDate.gameObject)
  elseif dateStr then
    self:Hide(self.addSymbol)
    self:SetTextureWhite(self.icon)
    self:Show(self.completeDate.gameObject)
    self.completeDate.text = string.format(ZhString.AdventureAchievePage_CompleteDate, dateStr)
    local bd = NGUIMath.CalculateRelativeWidgetBounds(self.rewardCt.transform, true)
    local height = bd.size.y
    local x, y, z = LuaGameObject.GetLocalPosition(self.rewardCt.transform)
    y = y - height - 20
    local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.completeDate.transform)
    self.completeDate.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  else
    self:Hide(self.addSymbol)
    self:SetTextureGrey(self.icon)
    self:Hide(self.shareBtn)
    self:Hide(self.completeDate.gameObject)
  end
  self:UpdateSelected()
  if self.indexInList == 1 then
    self:AddOrRemoveGuideId(self.gameObject, 460)
  end
end

function AchievementDescriptionCell:SetAchieveQuest()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.description.transform, true)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.description.transform)
  y = y - height - 20
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.questCt.transform)
  self.questCt.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  local staticData = self.data.staticData
  local behavior = staticData.behavior
  local preach = behavior == self.behaviorEnum.Achieve and staticData.time or nil
  local quest = behavior == self.behaviorEnum.Quest and staticData.time or nil
  TableUtility.ArrayClear(tempArray)
  if quest and 0 < #quest then
    for i = 1, #quest do
      local exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(quest[i])
      exsitQuestData = exsitQuestData or QuestProxy.Instance:getQuestDataByIdAndType(quest[i], SceneQuest_pb.EQUESTLIST_SUBMIT)
      local result = self:GetQuestName(quest[i])
      local preQuestS, preAccept = self:GetPreQuest(quest[i])
      local questListType = exsitQuestData and exsitQuestData.questListType or preAccept
      local data = {
        type = AchievementDescriptionCell.SubAchieve.Quest,
        content = result,
        questListType = questListType,
        preQuestS = preQuestSstatusReplaceS
      }
      if staticData.TextReplace then
        data.contentReplaceS = staticData.TextReplace[1]
        data.statusReplaceS = staticData.TextReplace[2]
      end
      table.insert(tempArray, data)
    end
  end
  if preach and 0 < #preach then
    for i = 1, #preach do
      local tableData = Table_Achievement[preach[i]]
      local content = ""
      if tableData then
        content = tableData.Name
        local data = {
          type = AchievementDescriptionCell.SubAchieve.Achieve,
          content = content,
          id = preach[i]
        }
        table.insert(tempArray, data)
      end
    end
  end
  self.achievementQuestGrid:ResetDatas(tempArray)
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.questCt.transform, true)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.questCt.transform)
  y = y - height - 20
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.rewardCt.transform)
  self.rewardCt.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
end

function AchievementDescriptionCell:GetQuestName(questId)
  if self.data.questDatas then
    for i = 1, #self.data.questDatas do
      local single = self.data.questDatas[i]
      if single.id == questId then
        return single.name
      end
    end
  end
end

function AchievementDescriptionCell:GetValidPreQuest(questId, pre)
  if pre and 0 < #pre then
    local preAccept
    local id = QuestProxy.Instance:getQuestID(questId)
    for i = 1, #pre do
      local single = pre[#pre - i + 1]
      local preId = QuestProxy.Instance:getQuestID(single.id)
      if not preAccept and id == preId then
        local exsitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(single.id)
        if exsitQuestData then
          preAccept = SceneQuest_pb.EQUESTLIST_ACCEPT
        end
      end
    end
    return pre, preAccept
  end
end

function AchievementDescriptionCell:GetPreQuest(questId)
  if not self.data.questDatas then
    return
  end
  for i = 1, #self.data.questDatas do
    local single = self.data.questDatas[i]
    if single.id == questId then
      return self:GetValidPreQuest(questId, single.pre)
    end
  end
end

function AchievementDescriptionCell:GetAchieveQuestTrace(questData, step)
end

function AchievementDescriptionCell:SetTraceInfo()
  local behavior = self.data.staticData.behavior
  local traceText = ""
  local combinationStr = self.data.staticData.combination
  combinationStr = OverSea.LangManager.Instance():GetLangByKey(combinationStr)
  if string.find(combinationStr, "%%s") then
    traceText = string.format(combinationStr, self.data:getProcess())
  else
    traceText = combinationStr
  end
  self.AchievementCondition.text = traceText
end

function AchievementDescriptionCell:checkCanAddPrayCount(behavior)
  local tb = GameConfig.AchievementType_TimeReward or {}
  return TableUtility.TableFindKey(tb, behavior)
end

function AchievementDescriptionCell:SetRewardData()
  local staticData = self.data.staticData
  local behavior = staticData.behavior
  local RewardExp = staticData.RewardExp
  local RewardItems = staticData.RewardItems
  local RewardTimes = staticData.RewardTimes
  local advRDatas = {}
  self.noReward = true
  if RewardExp then
    local temp = {}
    temp.type = "AdventureValue"
    temp.value = RewardExp
    temp.showName = true
    temp.color = AchievementDescriptionCell.RewardTextColor
    table.insert(advRDatas, temp)
    self.noReward = false
  end
  if self:checkCanAddPrayCount(behavior) and RewardTimes and RewardTimes ~= "" then
    local temp = {}
    temp.type = "text"
    temp.preLabelTxt = RewardTimes
    temp.value = ""
    table.insert(advRDatas, temp)
    self.noReward = false
  end
  local titleData, normalData
  self.noReward = false
  local titleReward = false
  local attrRewardList = {}
  local rewardAttr = staticData.RewardAttr
  if rewardAttr ~= _EmptyTable then
    local achievementAttrStr = ""
    for k, v in pairs(rewardAttr) do
      if achievementAttrStr == "" then
        achievementAttrStr = achievementAttrStr .. k .. "+" .. v
      else
        achievementAttrStr = achievementAttrStr .. "\n" .. k .. "+" .. v
      end
    end
    local attrData = {}
    attrData.type = "PropValue"
    attrData.value = achievementAttrStr
    attrData.iconcolor = AchievementDescriptionCell.RewardTitleColor
    attrData.color = AchievementDescriptionCell.RewardTextColor
    table.insert(advRDatas, attrData)
    for k, v in pairs(rewardAttr) do
      if not attrRewardList[k] then
        attrRewardList[k] = v
      else
        attrRewardList[k] = attrRewardList[k] + v
      end
    end
  end
  if RewardItems and 0 < #RewardItems then
    for i = 1, #RewardItems do
      local single = RewardItems[i]
      local itemData = Table_Item[single[1]]
      if itemData then
        if itemData.Type == 10 then
          titleData = itemData
          local titleAttrReward = TitleProxy.Instance:GetPropsListByTitleId(single[1])
          if titleAttrReward then
            for k, v in pairs(titleAttrReward) do
              if not attrRewardList[k] then
                attrRewardList[k] = v
              else
                attrRewardList[k] = attrRewardList[k] + v
              end
            end
          end
        else
          normalData = itemData
        end
        local temp = {}
        local data = {
          single[1],
          single[2]
        }
        temp.value = data
        temp.type = "item"
        temp.showName = true
        temp.color = AchievementDescriptionCell.RewardTextColor
        temp.addbracket = true
        table.insert(advRDatas, temp)
      end
    end
  end
  self.rewardGrid:ResetDatas(advRDatas)
  local attrStr = ""
  for k, v in pairs(attrRewardList) do
    local prop = Game.Config_PropName[k]
    if attrStr == "" then
      attrStr = attrStr .. k .. "+" .. v
    else
      attrStr = attrStr .. "\n" .. k .. "+" .. v
    end
  end
  if attrStr ~= "" then
    self.rewardPreviewPart:SetActive(true)
    self:Show(self.BufferLabel.gameObject)
    self.BufferLabel.text = attrStr
    self:Hide(self.itemReward)
  elseif normalData then
    self.rewardPreviewPart:SetActive(true)
    self:Show(self.itemReward)
    self:Hide(self.BufferLabel.gameObject)
    IconManager:SetItemIcon(normalData.Icon, self.itemRewardIcon)
  else
    self.rewardPreviewPart:SetActive(false)
  end
  if titleData then
    self:Show(self.AchievementIcon.gameObject)
    self:Hide(self.itemReward)
    local atlas = RO.AtlasMap.GetAtlas("NewUI1")
    self.AchievementIcon.atlas = atlas
    self.AchievementIcon.spriteName = "Adventure_icon_badge"
  else
    self:Hide(self.AchievementIcon.gameObject)
  end
  local nameWidth = self.name.printedSize.x
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.name.gameObject.transform))
  tempVector3[1] = tempVector3[1] + nameWidth + 5
  self.AchievementIcon.gameObject.transform.localPosition = tempVector3
  if not self.noReward then
    self:Show(self.rewardCt)
  else
    self:Hide(self.rewardPreviewPart)
    self:Hide(self.rewardCt)
  end
end

function AchievementDescriptionCell:SetRefrestTime()
  local refreshTimeStr = self.data:getResetTime()
  if not refreshTimeStr then
    self.timeLimitGO:SetActive(false)
    return
  end
  self.timeLimitGO:SetActive(true)
  self.timeLimitLabel.text = refreshTimeStr
  local width = self.timeLimitLabel.printedSize.x
  self.timeLimitBG.width = width + 40
end

function AchievementDescriptionCell:UpdateSelected()
  local isSelected = self.data.isSelected
  if isSelected then
    self:Show(self.collapse)
  else
    self:Hide(self.collapse)
  end
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform, false)
  local height = bd.size.y
  self.bg.height = height + 15
  NGUITools.UpdateWidgetCollider(self.gameObject)
end

function AchievementDescriptionCell:PlayUnlockEffect()
  self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
end
