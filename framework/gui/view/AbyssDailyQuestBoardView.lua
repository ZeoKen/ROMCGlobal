autoImport("AbyssQuestCell")
autoImport("AbyssQuestHelpCell")
AbyssDailyQuestBoardView = class("AbyssDailyQuestBoardView", ContainerView)
AbyssDailyQuestBoardView.ViewType = UIViewType.NormalLayer
local bgName = "img_task_Bg1"

function AbyssDailyQuestBoardView:Init()
  self:InitData()
  self:FindObjs()
  self:AddListenEvts()
  ServiceQuestProxy.Instance:CallQueryAbyssQuestListQuestCmd()
end

function AbyssDailyQuestBoardView:InitData()
  self.areaId = self.viewdata and self.viewdata.viewdata
end

function AbyssDailyQuestBoardView:FindObjs()
  self.bg = self:FindComponent("Bg", UITexture)
  local grid = self:FindComponent("Grid", UIGrid)
  self.questListCtrl = UIGridListCtrl.new(grid, AbyssQuestCell, "AbyssQuestCell")
  self.friendHelpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(self.friendHelpBtn, function()
    self:OnFriendHelpBtnClick()
  end)
  self.helpCountLabel = self:FindComponent("HelpNum", UILabel)
  grid = self:FindComponent("HelpGrid", UIGrid)
  self.helpListCtrl = UIGridListCtrl.new(grid, AbyssQuestHelpCell, "AbyssQuestHelpCell")
  self.areaFriendLabel = self:FindComponent("AreaFriend", UILabel)
end

function AbyssDailyQuestBoardView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3QueryPrestigeCmd, self.HandleQueryPrestige)
  self:AddListenEvt(ServiceEvent.QuestQueryAbyssQuestListQuestCmd, self.HandleQueryAbyssQuestList)
  self:AddListenEvt(ServiceEvent.QuestUpdateAbyssHelpCountQuestCmd, self.HandleUpdateAbyssHelpCount)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RefreshView)
end

function AbyssDailyQuestBoardView:HandleQueryPrestige()
  self:RefreshView()
end

function AbyssDailyQuestBoardView:HandleQueryAbyssQuestList()
  ServiceSceneUser3Proxy.Instance:CallQueryPrestigeCmd(self.areaId)
end

function AbyssDailyQuestBoardView:HandleUpdateAbyssHelpCount()
  self:RefreshFriendHelp()
end

function AbyssDailyQuestBoardView:OnEnter()
  local areaName = GameConfig.Quest and GameConfig.Quest.Abyss and GameConfig.Quest.Abyss.AreaName
  self.areaFriendLabel.text = string.format(ZhString.Abyss_QuestAreaFriend, areaName[self.areaId] or "")
  PictureManager.Instance:SetAbyssTexture(bgName, self.bg)
end

function AbyssDailyQuestBoardView:OnExit()
  PictureManager.Instance:UnloadAbyssTexture(bgName, self.bg)
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

function AbyssDailyQuestBoardView:RefreshView()
  local datas = {}
  if not self.questList then
    self.questList = AbyssQuestProxy.Instance:GetQuestList(self.areaId)
    table.sort(self.questList, sortFunc)
  end
  local count = GameConfig.Quest and GameConfig.Quest.Abyss and GameConfig.Quest.Abyss.TotalCount or 0
  local prestigeLv = AbyssQuestProxy.Instance:GetAreaPrestigeLevel(self.areaId)
  local prestigeInfo = VersionPrestigeProxy.Instance:GetPrestigeInfo(self.areaId)
  local myPrestigeLv = prestigeInfo and prestigeInfo.level or 0
  local unlockCountConf = GameConfig.Quest and GameConfig.Quest.Abyss and GameConfig.Quest.Abyss.PrestigeLvUnlockCount
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
      local areaName = GameConfig.Quest and GameConfig.Quest.Abyss and GameConfig.Quest.Abyss.AreaName
      datas[i] = {
        unlockLv = unlockLv or 0,
        areaName = areaName[self.areaId] or "",
        prestigeLv = prestigeLv,
        myPrestigeLv = myPrestigeLv
      }
    end
  end
  self.questListCtrl:ResetDatas(datas)
  self:RefreshFriendHelp()
end

local enableLabelColor = Color(0.6196078431372549, 0.33725490196078434, 0, 1)

function AbyssDailyQuestBoardView:RefreshFriendHelp()
  local curHelpNum = AbyssQuestProxy.Instance:GetCurHelpNum(self.areaId)
  local totalHelpNum = AbyssQuestProxy.Instance:GetTotalHelpNum(self.areaId)
  if 0 < totalHelpNum then
    self.helpCountLabel.text = string.format(ZhString.Abyss_QuestHelpCount, curHelpNum, totalHelpNum)
  else
    self.helpCountLabel.text = ZhString.Abyss_QuestHelp
  end
  local datas = {}
  local helpQuest = GameConfig.Quest and GameConfig.Quest.Abyss and GameConfig.Quest.Abyss.HelpQuest
  local maxHelpCount = helpQuest and helpQuest[self.areaId] and #helpQuest[self.areaId]
  for i = 1, maxHelpCount do
    local data = i <= curHelpNum and 2 or i <= totalHelpNum and 1 or 0
    redlog("helpcount", data)
    datas[#datas + 1] = data
  end
  self.helpListCtrl:ResetDatas(datas)
  self:SetButtonEnable(self.friendHelpBtn, totalHelpNum == 0 or curHelpNum < totalHelpNum, enableLabelColor)
end

function AbyssDailyQuestBoardView:OnFriendHelpBtnClick()
  local totalHelpNum = AbyssQuestProxy.Instance:GetTotalHelpNum(self.areaId)
  if totalHelpNum == 0 then
    MsgManager.ShowMsgByID(43606)
    return
  end
  local questData = AbyssQuestProxy.Instance:FindFirstCanAcceptQuest(self.areaId)
  if questData then
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_ABYSS, questData.id)
    return
  end
  questData = AbyssQuestProxy.Instance:FindFirstInProgressQuest(self.areaId)
  if questData then
    MsgManager.ConfirmMsgByID(626, function()
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_ABYSS, questData.id)
    end, nil, nil, questData.staticData.Name)
    return
  end
  MsgManager.ShowMsgByID(43605)
end
