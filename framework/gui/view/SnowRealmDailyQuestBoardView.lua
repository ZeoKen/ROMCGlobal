autoImport("AbyssDailyQuestBoardView")
autoImport("SnowRealmQuestCell")
SnowRealmDailyQuestBoardView = class("SnowRealmDailyQuestBoardView", AbyssDailyQuestBoardView)
SnowRealmDailyQuestBoardView.ViewType = UIViewType.NormalLayer

function SnowRealmDailyQuestBoardView:QueryQuestList()
  ServiceQuestProxy.Instance:CallQuerySnowRealmQuestListCmd()
end

function SnowRealmDailyQuestBoardView:InitQuestListCtrl(grid)
  self.questListCtrl = UIGridListCtrl.new(grid, SnowRealmQuestCell, "AbyssQuestCell")
end

function SnowRealmDailyQuestBoardView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.QuestQuerySnowRealmQuestListCmd, self.HandleQuerySnowRealmQuestList)
  self:AddListenEvt(ServiceEvent.QuestUpdateSnowRealmDailyQuestHelpCountCmd, self.HandleUpdateSnowRealmDailyQuestHelpCount)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RefreshView)
end

function SnowRealmDailyQuestBoardView:HandleQuerySnowRealmQuestList()
  self:RefreshView()
end

function SnowRealmDailyQuestBoardView:HandleUpdateSnowRealmDailyQuestHelpCount()
  redlog("HandleUpdateSnowRealmDailyQuestHelpCount")
  self:RefreshFriendHelp()
end

local sortFunc = function(l, r)
  local resultl, typel = QuestProxy.Instance:checkQuestHasAccept(l.id)
  local resultr, typer = QuestProxy.Instance:checkQuestHasAccept(r.id)
  local getPriority = function(result, type, questId)
    if not result then
      return 1
    end
    if type == SceneQuest_pb.EQUESTLIST_COMPLETE then
      return 3
    end
    if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId, SceneQuest_pb.EQUESTLIST_ACCEPT)
      local accessFc = questData.staticData and questData.staticData.Params and questData.staticData.Params.ifAccessFc
      if accessFc == 1 then
        return 2
      end
      return 0
    end
    return -1
  end
  local priorityL = getPriority(resultl, typel, l.id)
  local priorityR = getPriority(resultr, typer, r.id)
  if priorityL ~= priorityR then
    return priorityL > priorityR
  end
  return l.id < r.id
end

function SnowRealmDailyQuestBoardView:RefreshView()
  local datas = {}
  if not self.questList then
    self.questList = self:GetQuestList()
    table.sort(self.questList, sortFunc)
  end
  local count = self:GetTotalQuestCount()
  local crownLevel = self:GetSnowCrownLevel()
  local myCrownLevel = self:GetMyCrownLevel()
  local unlockCountConf = self:GetUnlockCountConf()
  for i = 1, count do
    local questData = self.questList[i]
    if questData then
      datas[i] = questData
    else
      local unlockLv
      for lv, num in pairs(unlockCountConf) do
        if i <= num then
          unlockLv = unlockLv or lv
          unlockLv = math.min(unlockLv, lv)
        end
      end
      datas[i] = {
        unlockLv = unlockLv or 0,
        areaName = self:GetAreaName(),
        crownLv = crownLevel,
        myCrownLv = myCrownLevel
      }
    end
  end
  self.questListCtrl:ResetDatas(datas)
  self:RefreshFriendHelp()
end

function SnowRealmDailyQuestBoardView:GetAreaName()
  local config = GameConfig.Quest and GameConfig.Quest.SnowRealm and GameConfig.Quest.SnowRealm[self.areaId]
  return config and config.AreaName or ""
end

function SnowRealmDailyQuestBoardView:GetQuestList()
  local questList = SnowRealmQuestProxy.Instance:GetQuestList(self.areaId)
  return questList
end

function SnowRealmDailyQuestBoardView:GetTotalQuestCount()
  local config = GameConfig.Quest and GameConfig.Quest.SnowRealm and GameConfig.Quest.SnowRealm[self.areaId]
  local count = config and config.MaxQuestCount or 0
  return count
end

function SnowRealmDailyQuestBoardView:GetUnlockCountConf()
  local config = GameConfig.Quest and GameConfig.Quest.SnowRealm and GameConfig.Quest.SnowRealm[self.areaId]
  local unlockCountConf = config and config.ArtifactLvToUnlockCount or {}
  return unlockCountConf
end

function SnowRealmDailyQuestBoardView:GetSnowCrownLevel()
  local snowCrownLevel = SnowRealmQuestProxy.Instance:GetSnowCrownLevel(self.areaId)
  return snowCrownLevel
end

function SnowRealmDailyQuestBoardView:GetMyCrownLevel()
  return SnowCrownProxy.Instance:GetCurrentLevel()
end

function SnowRealmDailyQuestBoardView:GetCurHelpNum()
  local curHelpNum = SnowRealmQuestProxy.Instance:GetCurHelpNum(self.areaId)
  return curHelpNum
end

function SnowRealmDailyQuestBoardView:GetTotalHelpNum()
  local totalHelpNum = SnowRealmQuestProxy.Instance:GetTotalHelpNum(self.areaId)
  return totalHelpNum
end

function SnowRealmDailyQuestBoardView:GetMaxHelpCount()
  local config = GameConfig.Quest and GameConfig.Quest.SnowRealm and GameConfig.Quest.SnowRealm[self.areaId]
  local maxHelpCount = config and config.MaxHelpCount or 0
  return maxHelpCount
end

function SnowRealmDailyQuestBoardView:OnFriendHelpBtnClick()
  local totalHelpNum = self:GetTotalHelpNum()
  if totalHelpNum == 0 then
    local config = GameConfig.Quest and GameConfig.Quest.SnowRealm and GameConfig.Quest.SnowRealm[self.areaId]
    local msgId = config and config.FriendHelpMsgId or 43668
    MsgManager.ShowMsgByID(msgId)
    return
  end
  local questData = SnowRealmQuestProxy.Instance:FindFirstCanAcceptQuest(self.areaId)
  if questData then
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_SNOWREALM, questData.id)
    return
  end
  questData = SnowRealmQuestProxy.Instance:FindFirstInProgressQuest(self.areaId)
  if questData then
    MsgManager.ConfirmMsgByID(626, function()
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_SNOWREALM, questData.id)
    end, nil, nil, questData.staticData.Name)
    return
  end
  MsgManager.ShowMsgByID(43605)
end
