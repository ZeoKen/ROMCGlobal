autoImport("RecommendScoreView")
QuestionnaireScoreView = class("QuestionnaireScoreView", RecommendScoreView)

function QuestionnaireScoreView:InitData()
end

function QuestionnaireScoreView:OnEnter()
  QuestionnaireScoreView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.questionnaire = viewdata and viewdata.questionnaire
  self.contentLabel.text = OverSea.LangManager.Instance():GetLangByKey(GameConfig.QuestionnaireScore.Describe)
  if self.questionnaire and self.questionnaire.data then
    for i = 1, 3 do
      self.listGroupItems[i]:SetData(self.questionnaire.data.rewards[i])
    end
  end
  self.cancelLabel.text = ZhString.QuestionnaireScore_Cancel
  self.confirmLabel.text = ZhString.QuestionnaireScore_Confirm
  ActivityEventProxy.Instance:SetQuestionnaireVisitedToday()
end

function RecommendScoreView:AddEvent()
  self:AddClickEvent(self.leftBut, function(go)
    self:LeftButClick()
  end)
  self:AddClickEvent(self.rightBtn, function(go)
    self:RightButClick()
  end)
  self:AddClickEvent(self.closeBut, function(go)
    self:CloseButClick()
  end)
  EventManager.Me():AddEventListener(AppStateEvent.Pause, self.OpenUrlPause, self)
end

function QuestionnaireScoreView:LeftButClick()
  self:CloseSelf()
end

function QuestionnaireScoreView:RightButClick()
  self.butnClick = true
  local SDKEnable, sid = FunctionLogin.Me():getSdkEnable()
  if not SDKEnable then
    sid = FunctionLogin.Me().ServerZone
    local serverId = FunctionLogin.Me():GetLineGroup()
    if sid and serverId then
      sid = sid * 10000 + serverId
    else
      sid = 0
    end
  else
    if PlayerPrefs.HasKey(PlayerPrefsMYServer) then
      sid = PlayerPrefs.GetInt(PlayerPrefsMYServer)
    end
    if not sid or sid == 0 then
      local serverData = FunctionLogin.Me():getCurServerData()
      sid = serverData and serverData.sid and tonumber(serverData.sid) or 0
    end
  end
  local url = self.questionnaire.data.url
  local params1 = string.format("?sojumpparm=%s,%s,%s,%s", tostring(FunctionLogin.Me():getLoginData().accid), tostring(Game.Myself.data.id), tostring(sid), tostring(self.questionnaire.id))
  local params2 = string.format("&q1=%s", tostring(sid))
  local params3 = string.format("&q2=%s", tostring(FunctionLogin.Me():getLoginData().accid))
  local params4 = string.format("&q3=%s", tostring(Game.Myself.data.id))
  url = url .. params1 .. params2 .. params3 .. params4
  ApplicationInfo.OpenUrl(url)
  self:CloseSelf()
end

function QuestionnaireScoreView:OpenUrlPause(node)
  if node.data ~= false or self.butnClick == true then
  end
end
