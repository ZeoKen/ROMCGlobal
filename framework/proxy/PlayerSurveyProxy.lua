PlayerSurveyProxy = class("PlayerSurveyProxy", pm.Proxy)

function PlayerSurveyProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "PlayerSurveyProxy"
  if PlayerSurveyProxy.Instance == nil then
    PlayerSurveyProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PlayerSurveyProxy:Init()
  self.questionMap = {}
  self.curSurveyID = 0
end

function PlayerSurveyProxy:InitCurSurvey()
  if not Table_Questionnaire then
    return
  end
  local curFinishSurvey = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_QUESTIONNAIRE_BATCH) or 0
  for k, v in pairs(Table_Questionnaire) do
    local single = v
    if single and curFinishSurvey < single.id and self:CheckServer(single.ServerID) then
      local starttime, endtime
      if EnvChannel.IsTFBranch() then
        if single.BeginTimeTF then
          local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(single.BeginTimeTF)
          starttime = os.time({
            day = st_day,
            month = st_month,
            year = st_year,
            hour = st_hour,
            min = st_min,
            sec = st_sec
          })
        end
        if single.EndTimeTF then
          local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(single.EndTimeTF)
          endtime = os.time({
            day = st_day,
            month = st_month,
            year = st_year,
            hour = st_hour,
            min = st_min,
            sec = st_sec
          })
        end
        if not starttime or not endtime then
          redlog("问卷时间参数缺失", single.id)
          break
        end
      else
        if single.BeginTime then
          local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(single.BeginTime)
          starttime = os.time({
            day = st_day,
            month = st_month,
            year = st_year,
            hour = st_hour,
            min = st_min,
            sec = st_sec
          })
        end
        if single.EndTime then
          local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(single.EndTime)
          endtime = os.time({
            day = st_day,
            month = st_month,
            year = st_year,
            hour = st_hour,
            min = st_min,
            sec = st_sec
          })
        end
        if not starttime or not endtime then
          redlog("问卷时间参数缺失", single.id)
          break
        end
      end
      local serverTime = ServerTime.CurServerTime() / 1000
      if starttime < serverTime and endtime > serverTime then
        self.curSurveyID = single.id
        return self.curSurveyID
      end
    end
  end
  return nil
end

function PlayerSurveyProxy:CheckServer(ServerIDs)
  if ServerIDs and 0 < #ServerIDs then
    local curServer = FunctionLogin.Me():getCurServerData()
    local curServerID = curServer.linegroup or 1
    if 0 ~= TableUtility.ArrayFindIndex(ServerIDs, curServerID) then
      return true
    else
      return false
    end
  else
    return true
  end
end

function PlayerSurveyProxy:checkSurveyValid()
  local surveyConfig = Table_Questionnaire[self.curSurveyID]
  if not surveyConfig then
    redlog("缺少问卷配置", self.curSurveyID)
    return false
  end
  local starttime, endtime
  if EnvChannel.IsTFBranch() then
    if surveyConfig.BeginTimeTF then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(surveyConfig.BeginTimeTF)
      starttime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
    end
    if surveyConfig.EndTimeTF then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(surveyConfig.EndTimeTF)
      endtime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
    end
    if not starttime or not endtime then
      redlog("问卷时间参数缺失", surveyConfig.id)
      return false
    end
  else
    if surveyConfig.BeginTime then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(surveyConfig.BeginTime)
      starttime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
    end
    if surveyConfig.EndTime then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(surveyConfig.EndTime)
      endtime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
    end
    if not starttime or not endtime then
      redlog("问卷时间参数缺失", surveyConfig.id)
      return false
    end
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  if starttime < serverTime and endtime > serverTime then
    return true
  else
    return false
  end
end

function PlayerSurveyProxy:GetQuestionList()
  if not Table_QuestionnaireContent then
    redlog("缺少配置Table_QuestionnaireContent")
    return
  end
  local result = {}
  for k, v in pairs(Table_QuestionnaireContent) do
    local single = v
    if single.Batch == self.curSurveyID then
      table.insert(result, single)
    end
  end
  table.sort(result, function(l, r)
    return l.id < r.id
  end)
  return result
end
