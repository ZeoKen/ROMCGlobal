local ReloadDatasCommand = class("ReloadDatasCommand", pm.SimpleCommand)

function ReloadDatasCommand:execute(note)
  local data = note.body
  self:Init()
end

function ReloadDatasCommand:Init()
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_FASHION)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_CARD)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_EQUIP)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_ITEM)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MOUNT)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MONSTER)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_PET)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_NPC)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MAP)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_SCENERY)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_COLLECTION)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_TOY)
  ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_FURNITURE)
end

return ReloadDatasCommand
