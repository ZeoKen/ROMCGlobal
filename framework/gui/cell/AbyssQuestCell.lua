AbyssQuestCell = class("AbyssQuestCell", BaseCell)

function AbyssQuestCell:Init()
  self:FindObjs()
end

function AbyssQuestCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.unlockTip = self:FindComponent("UnlockTip", UILabel)
  self.lock = self:FindGO("Lock")
  self.completeGO = self:FindGO("Complete")
  self.acceptBtn = self:FindGO("AcceptBtn")
  self:AddClickEvent(self.acceptBtn, function()
    redlog("accept", self.data and self.data.id)
    if self.data and self.data.id then
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.data.id)
    end
  end)
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(self.cancelBtn, function()
    if self.data and self.data.id then
      MsgManager.ConfirmMsgByID(43604, function()
        redlog("cancel", self.data.id)
        ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ABANDON_GROUP, self.data.id)
      end)
    end
  end)
  self.submitBtn = self:FindGO("SubmitBtn")
  self:AddClickEvent(self.submitBtn, function()
    if self.data and self.data.id then
      local _, type = QuestProxy.Instance:checkQuestHasAccept(self.data.id)
      if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
        local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
        if questData.staticData and questData.staticData.Params and questData.staticData.Params.ifAccessFc then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id)
        end
      end
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, self.data.id)
    end
  end)
  self.rewardIcon = self:FindComponent("RewardIcon", UISprite)
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
end

function AbyssQuestCell:SetData(data)
  self.data = data
  if data and data.id then
    local result, type = QuestProxy.Instance:checkQuestHasAccept(data.id)
    if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData.staticData and questData.staticData.Params and questData.staticData.Params.ifAccessFc then
        self.cancelBtn:SetActive(false)
        self.submitBtn:SetActive(true)
      else
        self.cancelBtn:SetActive(true)
        self.submitBtn:SetActive(false)
      end
    else
      self.cancelBtn:SetActive(false)
      self.submitBtn:SetActive(type == SceneQuest_pb.EQUESTLIST_COMPLETE)
    end
    self.completeGO:SetActive(result and type == SceneQuest_pb.EQUESTLIST_SUBMIT or false)
    self.acceptBtn:SetActive(not result)
    self.lock:SetActive(false)
    self.unlockTip.gameObject:SetActive(false)
    local config = data.staticData
    self.nameLabel.text = config and config.Name or ""
    local abyssConf = Table_AbyssQuest[data.id]
    if abyssConf then
      local rewardId = abyssConf.Reward
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
      if items then
        local itemId = items[1] and items[1].id
        local num = items[1] and items[1].num
        IconManager:SetItemIconById(itemId, self.rewardIcon)
        local itemConf = Table_Item[itemId]
        self.rewardLabel.text = string.format(ZhString.Abyss_QuestRewardStr, itemConf and itemConf.NameZh or "", num)
      end
    end
  elseif data then
    self.cancelBtn:SetActive(false)
    self.submitBtn:SetActive(false)
    self.completeGO:SetActive(false)
    self.acceptBtn:SetActive(false)
    self.unlockTip.gameObject:SetActive(true)
    if data.prestigeLv < data.myPrestigeLv and data.unlockLv <= data.myPrestigeLv then
      self.unlockTip.text = ZhString.Abyss_QuestUnlocked
      self.lock:SetActive(false)
    else
      self.unlockTip.text = string.format(ZhString.Abyss_QuestUnlockTip, data.areaName, data.unlockLv)
      self.lock:SetActive(true)
    end
  end
end
