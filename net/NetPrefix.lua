using("RO.Net")
autoImport("ProtobufPool")
require("Script.Net.NetConfig")
require("Script.Net.NetProtocol")
autoImport("protobuf")
if not NetConfig.PBC then
  require("Script.Net.Protos.Proto_Include")
  SceneUser_pb.UserAttr.PoolNum = 600
  SceneUser_pb.UserData.PoolNum = 600
  SceneUser2_pb.BufferData.PoolNum = 250
else
  PbMgr = autoImport("PbMgr")
  PbMgr.InitPbs()
end
