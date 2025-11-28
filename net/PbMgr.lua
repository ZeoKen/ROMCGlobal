local protobuf = autoImport("protobuf_opt")
autoImport("protoslist")
autoImport("MissingEnum")
local exclude_pbs = {
  "SceneUser_pb",
  "ClientPrivateChatIO_pb",
  "RecordTrade_pb"
}
local PbMgr = {}

function PbMgr.InitPbs()
  for _, file in pairs(ProtoFileList) do
    local path = "PbBytes/" .. file
    protobuf.register(ResourceManager.Instance:SLoadBytes(path))
    autoImport(file)
  end
  for _, file in pairs(exclude_pbs) do
    autoImport(file)
  end
  autoImport("pbc_auto_construct")
end

function PbMgr.DecodeMsg(msgID, buff, out_table)
  local msgInfo = ProtoReqInfoList[msgID]
  if msgInfo == nil then
    return
  end
  protobuf.decodePB(msgInfo.ack, buff, out_table)
end

function PbMgr.DecodeMsgByName(typename, buff, out_table)
  protobuf.decodePB(typename, buff, out_table)
end

function PbMgr.CreateNewMsgByName(typename)
  return protobuf.debug_create_message2(typename)
end

function PbMgr.DecodeMsg2(msgID, address, offset, len, out_table)
  local msgInfo = ProtoReqInfoList[msgID]
  if msgInfo == nil then
    return
  end
  protobuf.decodePB2(msgInfo.ack, address, offset, len, out_table)
end

function PbMgr.EncodeMsg(msgID, msgTable)
  local msgInfo = ProtoReqInfoList[msgID]
  if msgInfo == nil then
    return
  end
  return protobuf.encode(msgInfo.req, msgTable)
end

function PbMgr.GetEnumValue(enumStr)
  return enumStr
end

function PbMgr.GetEnum(enumStr)
  return enumStr
end

SplitTable = {}

function PbMgr.DoTransfer(enumStr)
  local r = SplitTable[enumStr]
  if r then
    return r
  end
  local split_table = string.split(enumStr, "_")
  if #split_table <= 1 then
    return enumStr
  end
  local enumTable = split_table[1]
  local gTb = _G[enumTable]
  if gTb then
    if type(gTb) == "table" then
      local result = rawget(gTb, enumStr)
      if result then
        SplitTable[enumStr] = result
        return result
      else
        return enumStr
      end
    else
      return enumStr
    end
  else
    gTb = MissingEnum
    local result = gTb[enumStr]
    if result == "" or result == nil then
      return enumStr
    else
      SplitTable[enumStr] = result
      return result
    end
  end
  return enumStr
end

function PbMgr.TimeCost(func, name)
  local startTime = os.clock()
  if nil ~= func then
    func()
  end
  local cost = os.clock() - startTime
  Debug.Log(string.format("%s time cost : %.6f", tostring(name), cost))
end

return PbMgr
