local _RichLabFormat = ZhString.SignIn21View_RewardLabelFormat
TopicQuestCell = class("SignIn21TodayTargetCell", BaseCell)

function TopicQuestCell:Init()
  self:FindObj()
  self:AddUIEvt()
end

function TopicQuestCell:FindObj()
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.rewardRichLabel = SpriteLabel.new(self:FindGO("RewardRichLab"), nil, nil, nil, true)
  self.rewardBtn = self:FindGO("RewardBtn")
  self.gotFlag = self:FindGO("Got")
  self.unGet = self:FindGO("UnGet")
  local lab = self:FindComponent("Lab", UILabel, self.unGet)
  lab.text = ZhString.Topic_GO
  self.curProgressLab = self:FindComponent("CurLab", UILabel, self.unGet)
  self.totalProgressLab = self:FindComponent("TotalLab", UILabel, self.unGet)
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
end

function TopicQuestCell:AddUIEvt()
  self:AddClickEvent(self.rewardBtn, function()
    if not self.data then
      return
    end
    ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(self.data.id)
  end)
  self:SetEvent(self.unGet, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function TopicQuestCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.nameLab.text = data.titleDesc
  self:SetReward(data.staticData.Reward)
  self.progressSlider.value = data:GetProgressValue()
  self.gotFlag:SetActive(data:IsRewarded())
  self.rewardBtn:SetActive(data:IsFinished())
  if data:IsGoing() then
    self.unGet:SetActive(true)
    self.totalProgressLab.text = "/" .. tostring(data.targetNum)
    self.curProgressLab.text = tostring(data.progress)
    self.curProgressLab:ResetAndUpdateAnchors()
  else
    self.unGet:SetActive(false)
  end
end

function TopicQuestCell:SetReward(rewardTable)
  self.rewardRichLabel:Reset()
  local _GetRewardItemIdsByTeamId = ItemUtil.GetRewardItemIdsByTeamId
  local arr = ReusableTable.CreateArray()
  if type(rewardTable) == "table" then
    for _, id in pairs(rewardTable) do
      local rewardItemIds = _GetRewardItemIdsByTeamId(id)
      if rewardItemIds then
        for _, rewardItemInfo in pairs(rewardItemIds) do
          arr[#arr + 1] = rewardItemInfo
        end
      end
    end
  end
  local sb = LuaStringBuilder.CreateAsTable()
  for i = 1, #arr do
    sb:Append(string.format(_RichLabFormat, arr[i].id, arr[i].num))
  end
  ReusableTable.DestroyAndClearArray(arr)
  self.rewardRichLabel:SetText(sb:GetCount() > 0 and sb:ToString() or "")
  sb:Destroy()
end
