EndlessBattleFieldQuestCell = class("EndlessBattleFieldQuestCell", CoreView)
local PREFAB_NAME = "EndlessBattleFieldQuestCell"
local COMPLETE_EFFECT = ""

function EndlessBattleFieldQuestCell:ctor(parent)
  local go = self:LoadPrefab(parent)
  EndlessBattleFieldQuestCell.super.ctor(self, go)
  self:Init()
end

function EndlessBattleFieldQuestCell:LoadPrefab(parent)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(PREFAB_NAME))
  if not go then
    error("can not find pfb" .. PREFAB_NAME)
    return
  end
  go.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(go, 0, 0, 0)
  return go
end

function EndlessBattleFieldQuestCell:Init()
  self:InitData()
  self:FindObjs()
end

function EndlessBattleFieldQuestCell:InitData()
  self.questIds = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.QuestIds
end

function EndlessBattleFieldQuestCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.check = self:FindGO("Check")
  self.effectContainer = self:FindGO("EffectContainer")
end

function EndlessBattleFieldQuestCell:UpdateData()
  if self.questIds then
    local count = #self.questIds
    local completeNum = 0
    local curStr, curIcon
    for i = 1, count do
      local questId = self.questIds[i]
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
      if questData then
        if questData.complete then
          completeNum = completeNum + 1
        else
          local stepData = questData:getCurrentStepData()
          if stepData and stepData.staticData.Content == "group" then
            curStr = questData.traceInfo
            curIcon = stepData.staticData.ColorFromServer
          end
        end
      end
    end
    if count > completeNum then
      self:Show()
      local curIndex = math.min(completeNum + 1, count)
      curStr = curStr or ""
      self.nameLabel.text = string.format(ZhString.EndlessBattleEvent_QuestInfo, curStr, curIndex, count)
      if GameConfig.Quest and GameConfig.Quest.TraceIcon and GameConfig.Quest.TraceIcon[curIcon] then
        local iconName = GameConfig.Quest.TraceIcon[curIcon][1]
        self.icon.spriteName = iconName
      end
    else
      self:Hide()
    end
  end
end

function EndlessBattleFieldQuestCell:Show()
  self.gameObject:SetActive(true)
end

function EndlessBattleFieldQuestCell:Hide()
  self.gameObject:SetActive(false)
end

function EndlessBattleFieldQuestCell:PlayEffect()
  self:PlayUIEffect(COMPLETE_EFFECT, self.effectContainer, true, function(go, args, effect)
    args:UpdateData()
  end, self)
end

function EndlessBattleFieldQuestCell:OnQuestDataUpdate()
  self:PlayEffect()
end
