autoImport("UIAutoScrollCtrl")
ActivitySelfChooseTaskCell = class("ActivitySelfChooseTaskCell", BaseCell)

function ActivitySelfChooseTaskCell:Init()
  self:FindObjs()
end

function ActivitySelfChooseTaskCell:FindObjs()
  self.sp = self.gameObject:GetComponent(UIMultiSprite)
  self.descLabel = self:FindComponent("Desc", UILabel)
  local descPanel = self:FindComponent("DescPanel", UIPanel)
  local descScroll = descPanel.gameObject:GetComponent(UIScrollView)
  local parentPanel = UIUtil.GetComponentInParents(descPanel.gameObject, UIPanel)
  if parentPanel then
    descPanel.depth = parentPanel.depth + 1
  end
  self.descScrollCtrl = UIAutoScrollCtrl.new(descScroll, self.descLabel)
  self.progressLabel = self:FindComponent("Progress", UILabel)
  self.progressBar = self:FindComponent("ProgressBar", UIProgressBar)
  self.processing = self:FindGO("Processing")
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:OnGotoBtnClick()
  end)
  self.rewardNum = self:FindComponent("RewardNum", UILabel)
  self.checkMark = self:FindGO("CheckMark")
  self.drawBtn = self:FindGO("DrawBtn")
  self:AddClickEvent(self.drawBtn, function()
    self:OnDrawBtnClick()
  end)
  self.drawNum = self:FindComponent("DrawNum", UILabel)
end

function ActivitySelfChooseTaskCell:SetData(data)
  self.data = data
  if data.isLeftCountTask then
    self.descLabel.text = ZhString.SelfChoose_LeftCountTaskDesc
    self.progressLabel.gameObject:SetActive(false)
    self.progressBar.gameObject:SetActive(false)
  else
    local config = Table_FateSelectTarget[data.id]
    if config then
      local target = config.TargetNum
      self.descLabel.text = config.Description
      self:SetProgress(data.progress, target)
      local num = config.RewardCount
      self.rewardNum.text = string.format(ZhString.SelfChoose_DrawCount, num)
      local go = config.Goto
      self.gotoBtn:SetActive(go and go ~= _EmptyTable and 0 < #go or false)
    end
  end
  self.descScrollCtrl:Start(true, true)
  local drawStr = ZhString.SelfChoose_Draw
  if data.leftCount > 1 then
    drawStr = drawStr .. "x%s"
  end
  self.drawNum.text = string.format(drawStr, data.leftCount)
  local state = data.state
  self.processing:SetActive(state == EACTQUESTSTATE.EACT_QUEST_DOING)
  self.checkMark:SetActive(state == EACTQUESTSTATE.EACT_QUEST_REWARDED)
  self.drawBtn:SetActive(state == EACTQUESTSTATE.EACT_QUEST_FINISH)
  self.sp.CurrentState = state ~= EACTQUESTSTATE.EACT_QUEST_REWARDED and 0 or 1
  self.descLabel.alpha = state == EACTQUESTSTATE.EACT_QUEST_REWARDED and 0.5 or 1
  self.progressBar.alpha = state == EACTQUESTSTATE.EACT_QUEST_REWARDED and 0.5 or 1
end

function ActivitySelfChooseTaskCell:SetProgress(progress, target)
  self.progressLabel.text = string.format("%s/%s", progress, target)
  self.progressBar.value = progress / target
end

function ActivitySelfChooseTaskCell:OnGotoBtnClick()
  local config = Table_FateSelectTarget[self.data.id]
  if config then
    local go = config.Goto
    if go and go ~= _EmptyTable and 0 < #go then
      FuncShortCutFunc.Me():CallByID(go[1])
    end
  end
end

function ActivitySelfChooseTaskCell:OnDrawBtnClick()
  if self.data.isLeftCountTask then
    ServiceActivityCmdProxy.Instance:CallFateSelectDrawCmd(self.data.act_id, true)
  else
    ServiceActivityCmdProxy.Instance:CallFateSelectDrawCmd(self.data.act_id, false, self.data.id)
  end
end
