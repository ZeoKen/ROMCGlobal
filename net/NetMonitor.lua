NetMonitor = class("NetMonitor")
local s_c
local getCurTime = function()
  if s_c == nil then
    s_c = ServerTime.CurServerTime
  end
  return s_c()
end
local getKey = function(id1, id2)
  return string.format("%d_%d", id1, id2)
end

function NetMonitor.Me()
  if nil == NetMonitor.me then
    NetMonitor.me = NetMonitor.new()
  end
  return NetMonitor.me
end

function NetMonitor:ctor()
  self.idCall = {}
  self.lastSendtime = {}
  self.intervalMap = {}
end

function NetMonitor:InitCallBack()
  NetManager.SetSocketSendCallBack(function(protocolID)
    self:HandleSendDone(protocolID)
  end)
end

function NetMonitor:HandleSendDone(protocolID)
  local key_id = getKey(protocolID.id1, protocolID.id2)
  self:LogSendInterval(key_id)
  local call = self.idCall[key_id]
  if call == nil then
    return
  end
  call()
end

function NetMonitor:SetLogInterval(id1, id2, interval)
  local key = getKey(id1, id2)
  self.intervalMap[key] = interval
end

function NetMonitor:LogSendInterval(key_id)
  local lastSendtime = self.lastSendtime[key_id]
  local curTime = getCurTime()
  self.lastSendtime[key_id] = curTime
  if lastSendtime == nil then
    return
  end
  local deltaTime = curTime - lastSendtime
  local interval = self.intervalMap[key_id]
  if interval ~= nil then
    if deltaTime < interval then
      redlog(string.format("发送消息(%s) 距离上次间隔时间(%sms)", key_id, deltaTime))
    end
  else
    redlog(string.format("发送消息(%s) 距离上次间隔时间(%sms)", key_id, deltaTime))
  end
end

function NetMonitor:AddSendCallBack(id1, id2, call)
  local key_id = getKey(id1, id2)
  self.idCall[key_id] = call
  NetManager.AddSendCallBackProtocolID(id1, id2)
end

function NetMonitor:ListenSkillUseSendCallBack()
  self:AddSendCallBack(5, 27)
  self:SetLogInterval(5, 27, 200)
end
