BeingInfoData = class("BeingInfoData")
BeingInfoData.KeyValue = {
  [SceneBeing_pb.EBEINGDATA_GUID] = "guid",
  [SceneBeing_pb.EBEINGDATA_LV] = "lv",
  [SceneBeing_pb.EBEINGDATA_EXP] = "exp",
  [SceneBeing_pb.EBEINGDATA_BATTLE] = "battle",
  [SceneBeing_pb.EBEINGDATA_LIVE] = "live",
  [SceneBeing_pb.EBEINGDATA_SUMMON or 6] = "summon",
  [SceneBeing_pb.EBEINGDATA_BODY or 7] = "body",
  [SceneBeing_pb.EBEINGDATA_EATEN or 9] = "eaten"
}

function BeingInfoData:ctor()
end

function BeingInfoData:Server_SetData(server_BeingInfo)
  self.beingid = server_BeingInfo.beingid
  if self.beingid then
    self.staticData = Table_Monster[self.beingid]
  end
  for k, v in pairs(self.KeyValue) do
    local s_value = server_BeingInfo[v]
    if s_value ~= nil then
      if v == "body" then
        self:setBodyId(s_value)
      elseif type(s_value) == "boolean" then
        if s_value == true then
          self[v] = 1
        else
          self[v] = 0
        end
      else
        self[v] = s_value
      end
    end
  end
  if server_BeingInfo.bodylist then
    self.bodylist = {}
    local list_value = server_BeingInfo.bodylist
    for i = 1, #list_value do
      local v = list_value[i]
      table.insert(self.bodylist, v)
    end
  else
    self.bodylist = {}
  end
  if self.body == nil or self.body == 0 then
    self:setBodyId(self.beingid)
  end
end

function BeingInfoData:Server_UpdateData(server_BeingMemberDatas)
  if server_BeingMemberDatas == nil then
    return
  end
  local oldSummon = self.summon
  local oldLive = self.live
  for i = 1, #server_BeingMemberDatas do
    local single = server_BeingMemberDatas[i]
    if single.etype == SceneBeing_pb.EBEINGDATA_BODYLIST then
      self.bodylist = {}
      local values = single.values
      for i = 1, #values do
        table.insert(self.bodylist, values[i])
      end
    elseif single.etype == SceneBeing_pb.EBEINGDATA_BODY then
      self:setBodyId(single.value)
    else
      local v = self.KeyValue[single.etype]
      if v ~= nil then
        self[v] = single.value
      end
    end
  end
  if self.body == nil or self.body == 0 then
    self:setBodyId(self.beingid)
  end
end

function BeingInfoData:IsAutoFighting()
  return self.battle == 1
end

function BeingInfoData:IsSummoned()
  return self.summon == 1
end

function BeingInfoData:IsAlive()
  return self.live == 1
end

function BeingInfoData:IsAliveAndNotBeEaten()
  return self.live == 1
end

function BeingInfoData:IsEaten()
  return self.eaten == 1
end

function BeingInfoData:SetUnlockBodys(server_unlockbodys)
end

function BeingInfoData:GetBeingBodys()
  if self.bodylist and #self.bodylist > 0 then
    local result = {
      self.beingid
    }
    for i = 1, #self.bodylist do
      table.insert(result, self.bodylist[i])
    end
    return result
  end
  return _EmptyTable
end

function BeingInfoData:setBodyId(bodyId)
  if bodyId == self.body then
    return
  end
  self.body = bodyId
  if nil == bodyId then
    return
  end
  local bodyData = Table_Monster[bodyId]
  if bodyData ~= nil then
    self.body_headIcon = bodyData.Icon
    self.name = bodyData.NameZh or "NOCONFIG"
  end
end

function BeingInfoData:GetHeadIcon()
  return self.body_headIcon
end
