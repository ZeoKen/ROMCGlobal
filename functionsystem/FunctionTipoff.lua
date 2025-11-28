autoImport("PlayerTipoff")
local ArrayPushBack = TableUtility.ArrayPushBack
FunctionTipoff = class("FunctionTipoff", EventDispatcher)

function FunctionTipoff.Me()
  if nil == FunctionTipoff.me then
    FunctionTipoff.me = FunctionTipoff.new()
  end
  return FunctionTipoff.me
end

function FunctionTipoff:ctor()
  self:Init()
end

function FunctionTipoff.IsForbidden()
  if BranchMgr.IsKorea() then
    return true
  end
  if FunctionUnLockFunc.CheckForbiddenByFuncState("report_forbidden") then
    return true
  end
  return false
end

function FunctionTipoff:Init()
  self.reason = {}
  self.recordMap = {}
end

function FunctionTipoff:SetCurPlayer(id)
  self.curPlayer = id
end

function FunctionTipoff:GetReason()
  if nil == next(self.reason) then
    for k, v in pairs(Table_TipoffReason) do
      ArrayPushBack(self.reason, v)
    end
    table.sort(self.reason, function(a, b)
      return a.id < b.id
    end)
  end
  return self.reason
end

function FunctionTipoff:Record(user_report)
  if not user_report then
    return
  end
  local char_id = user_report.charid
  if not char_id then
    return
  end
  local data = self.recordMap[char_id]
  if nil == data then
    data = PlayerTipoff.new(char_id)
    self.recordMap[char_id] = data
  end
  data:SetData(user_report)
end

function FunctionTipoff:HandleRecvList(user_reports)
  if FunctionTipoff.IsForbidden() then
    return
  end
  TableUtility.TableClear(self.recordMap)
  if not user_reports then
    return
  end
  for i = 1, #user_reports do
    self:Record(user_reports[i])
  end
end

function FunctionTipoff:HandleReportUser(msgid, user_report)
  if FunctionTipoff.IsForbidden() then
    return
  end
  if type(msgid) ~= "number" then
    return
  end
  if msgid == 0 then
    self:Record(user_report)
  else
    MsgManager.ShowMsgByID(msgid)
  end
end

function FunctionTipoff:DoTipoff(id, record_reason, name, str)
  if FunctionTipoff.IsForbidden() then
    return
  end
  if self:CheckRecorded(id) then
    MsgManager.ShowMsgByID(466)
    return
  end
  local tipoffCall = function()
    local temp = ReusableTable.CreateTable()
    temp.charid = id
    temp.reasons = {}
    for k, _ in pairs(record_reason) do
      local reason = {}
      reason.reason_id = k
      reason.data = str
      temp.reasons[#temp.reasons + 1] = reason
    end
    ServiceUserEventProxy.Instance:CallUserReportUserEvent(temp)
    ReusableTable.DestroyAndClearTable(temp)
  end
  MsgManager.ConfirmMsgByID(468, function()
    tipoffCall()
  end, nil, nil, name)
end

function FunctionTipoff:CheckRecorded(id)
  local data = self.recordMap[id]
  if not data then
    return false
  end
  return data:IsRecord()
end

function FunctionTipoff:GetPlayerReasons()
  local check_id = self.curPlayer
  if not check_id then
    return
  end
  local data = self.recordMap[check_id]
  if data then
    return data.reasonMap
  end
  return false
end
