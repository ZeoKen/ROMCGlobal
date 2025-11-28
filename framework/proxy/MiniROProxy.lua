MiniROProxy = class("MiniROProxy", pm.Proxy)
MiniROProxy.Instance = nil
MiniROProxy.NAME = "MiniROProxy"
MiniROProxy.CellType = {
  Special = 1,
  Normal = 2,
  Event = 3
}
MiniROProxy.QuestionGUID = -111
MiniROProxy.MiniRORedTipID = 10400
local _CreateTable = ReusableTable.CreateTable
local _ClearTable = TableUtility.TableClear

function MiniROProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MiniROProxy.NAME
  if MiniROProxy.Instance == nil then
    MiniROProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitData()
end

function MiniROProxy:InitData()
  self.activityData = nil
  self.curIndex = -1
  self.newIndex = -1
  self.curCompleteTurns = 0
  self.isNewTurn = false
  self.isMoving = false
  self.listOnceReward = _CreateTable()
  self.isDayFirst = false
  self.listDice = _CreateTable()
  self.freeDiceData = nil
  self.leftQuestionId = 0
  self.listDialogInfo = _CreateTable()
  self.listQuestion = _CreateTable()
  self.listStep = _CreateTable()
  self.showAnim = false
end

function MiniROProxy:IsDayFirst()
  return self.isDayFirst
end

function MiniROProxy:GetActDuringTime()
  if not self.activityData then
    return ""
  end
  if not ActivityCmd_pb.GACTIVITY_MINIRO then
    return
  end
  local actData = FunctionActivity.Me():GetActivityData(ActivityCmd_pb.GACTIVITY_MINIRO)
  if actData then
    local st, et = actData:GetDuringTime()
    local startTime = os.date("%m/%d %H:%M", st)
    local endTime = os.date("%m/%d %H:%M", et)
    return string.format(ZhString.MiniRO_ValidDate, startTime, endTime)
  end
  return ""
end

function MiniROProxy:RecvActMiniRoOpenPage(data)
  if self.curIndex ~= -1 and self.newIndex ~= data.curindex then
    self:SetIsMoving(true)
    redlog("MiniROProxy:RecvActMiniRoOpenPage =========0======== curIndex = " .. self.curIndex .. ", newIndex = " .. self.newIndex)
    table.insert(self.listQuestion, data.unanswerqid)
    table.insert(self.listStep, data.curindex)
    if data.dialoginfo and data.dialoginfo.dialogid ~= 0 then
      local dialogInfo = _CreateTable()
      dialogInfo.dialogStep = data.dialoginfo.step
      dialogInfo.dialogId = data.dialoginfo.dialogid
      table.insert(self.listDialogInfo, dialogInfo)
    end
  else
    redlog("MiniROProxy:RecvActMiniRoOpenPage =========00======== curIndex = " .. self.curIndex .. ", newIndex = " .. self.newIndex)
    self.curIndex = data.curindex
    self.isNewTurn = true
    self:ClearListStep()
  end
  self.newIndex = data.curindex
  if self.curCompleteTurns < data.circles then
    self.isNewTurn = true
  end
  self.curCompleteTurns = data.circles
  self.listOnceReward = data.onetimerewards
  self.isDayFirst = data.dayfirst
  self.listDice = data.dices
  self.freeDiceData = data.dicefree
  self.leftQuestionId = data.unanswerqid
  redlog("MiniROProxy:RecvActMiniRoOpenPage =========000======== " .. tostring(data.dialoginfo))
  if data.dialoginfo and data.dialoginfo.dialogid ~= 0 then
    redlog("MiniROProxy:RecvActMiniRoOpenPage =========1======== index = " .. tostring(data.curindex) .. ", circles = " .. tostring(data.circles) .. ", onetimerewards = " .. tostring(data.onetimerewards) .. ", dayfirst = " .. tostring(data.dayfirst) .. ", dices = " .. tostring(data.dices) .. ", dicefree = " .. tostring(data.dicefree) .. ", unanswerqid = " .. tostring(data.unanswerqid) .. ", store = " .. tostring(data.dicefree.store) .. ", storemax = " .. tostring(data.dicefree.storemax) .. ", nexttimestamp = " .. tostring(data.dicefree.nexttimestamp) .. ", dialogStep = " .. tostring(data.dialoginfo.step) .. ", dialogId = " .. tostring(data.dialoginfo.dialogid))
  else
    redlog("MiniROProxy:RecvActMiniRoOpenPage =========2======== index = " .. tostring(data.curindex) .. ", circles = " .. tostring(data.circles) .. ", onetimerewards = " .. tostring(data.onetimerewards) .. ", dayfirst = " .. tostring(data.dayfirst) .. ", dices = " .. tostring(data.dices) .. ", dicefree = " .. tostring(data.dicefree) .. ", unanswerqid = " .. tostring(data.unanswerqid) .. ", store = " .. tostring(data.dicefree.store) .. ", storemax = " .. tostring(data.dicefree.storemax) .. ", nexttimestamp = " .. tostring(data.dicefree.nexttimestamp))
  end
  TableUtil.Print(data)
end

function MiniROProxy:GetDiceCount(diceType)
  if not self.listDice or TableUtil.TableIsEmpty(self.listDice) then
    return 0
  end
  for k, v in pairs(self.listDice) do
    if v.type == diceType then
      return v.own
    end
  end
end

function MiniROProxy:SubDiceCount(diceType)
  if not self.listDice or TableUtil.TableIsEmpty(self.listDice) then
    return
  end
  for k, v in pairs(self.listDice) do
    if v.type == diceType then
      v.own = v.own - 1
      break
    end
  end
end

function MiniROProxy:SetActivityData(data)
  if not data then
    self.activityData = nil
    return
  end
  if self.activityData == nil then
    self.activityData = {}
  end
  self.activityData.id = data[1]
  self.activityData.statTime = data[2]
  self.activityData.endTime = data[3]
  self.activityData.featureData = GameConfig.Monopoly.feature[data[1]]
  local event = GameConfig.Monopoly.common.Event
  self.activityData.moveForwardID = event[1].param2[1]
  self.activityData.moveBackID = event[2].param2[1]
end

function MiniROProxy:GetActivityData()
  return self.activityData
end

function MiniROProxy:InitCurIndex()
  if self.newIndex ~= -1 then
    self.curIndex = self.newIndex
  end
end

function MiniROProxy:SetCurIndex(curIndex)
  self.curIndex = curIndex
end

function MiniROProxy:GetCurIndex()
  return self.curIndex
end

function MiniROProxy:SetIsMoving(isMoving)
  self.isMoving = isMoving
  UIManagerProxy.Instance:LockAndroidKey(isMoving)
end

function MiniROProxy:IsMoving()
  return self.isMoving
end

function MiniROProxy:GetNextDialogInfo()
  if #self.listStep ~= #self.listDialogInfo then
    return nil
  end
  return table.remove(self.listDialogInfo, 1)
end

function MiniROProxy:ClearListDialogInfo()
  _ClearTable(self.listDialogInfo)
end

function MiniROProxy:GetNextQuestion()
  return table.remove(self.listQuestion, 1)
end

function MiniROProxy:ClearListQuestion()
  _ClearTable(self.listQuestion)
end

function MiniROProxy:GetNextStepIndex()
  return table.remove(self.listStep, 1)
end

function MiniROProxy:ClearListStep()
  _ClearTable(self.listStep)
end

function MiniROProxy:GetLeftQuestionId()
  return self.leftQuestionId
end

function MiniROProxy:GetCurCompleteTurns()
  return self.curCompleteTurns
end

function MiniROProxy:IsNewTurn()
  return self.isNewTurn
end

function MiniROProxy:SetIsNewTurn(isNewTurn)
  self.isNewTurn = isNewTurn
end

function MiniROProxy:IsShowAnim()
  return self.showAnim
end

function MiniROProxy:SetIsShowAnim(IsShowAnim)
  self.showAnim = IsShowAnim
end

function MiniROProxy:SetFreeDiceData(data)
  self.freeDiceData = data.dicesync
end

function MiniROProxy:GetFreeDiceData()
  return self.freeDiceData
end

function MiniROProxy:CheckOnceReward(index)
  if not self.listOnceReward or TableUtil.TableIsEmpty(self.listOnceReward) then
    return false
  end
  for i, v in ipairs(self.listOnceReward) do
    if v == index then
      return true
    end
  end
  return false
end

function MiniROProxy:IsActivityDateValid()
  return nil ~= ActivityCmd_pb.GACTIVITY_MINIRO and FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_MINIRO)
end

function MiniROProxy:ClearData()
  self.curIndex = -1
  self.isNewTurn = false
  self.isMoving = false
  self.showAnim = false
  self.leftQuestionId = 0
  self:ClearListStep()
  self:ClearListDialogInfo()
  self:ClearListQuestion()
end
