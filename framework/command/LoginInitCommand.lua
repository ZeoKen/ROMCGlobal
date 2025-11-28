local LoginInitCommand = class("LoginInitCommand", pm.SimpleCommand)

function LoginInitCommand:execute(note)
  local data = note.body
  self:Init(data)
end

function LoginInitCommand:Init(data)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_WALLET)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_MAIN)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_EQUIP)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FASHIONEQUIP)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_STORE)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_PERSONAL_STORE)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_BARROW)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_QUEST or 10)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FOOD or 11)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_PET or 12)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FURNITURE or 13)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_TEMP_MAIN)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_MEMORY)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_SPECIAL_FASHION)
  GemProxy.QueryPackage()
  PersonalArtifactProxy.QueryPackage()
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_SHADOWEQUIP)
  redlog("---------------------LoginInitCommand 请求背包")
  GameFacade.Instance:sendNotification(ServiceEvent.ReloadDatas)
  ServiceNUserProxy.Instance:CallQueryShopGotItem()
  ServiceNUserProxy.Instance:CallQueryShortcut()
  if not data then
    FunctionGuide.Me():stopGuide()
  end
  FunctionPve.QueryPvePassInfo()
  ServiceSceneUser3Proxy.Instance:CallHeroShowUserCmd()
end

return LoginInitCommand
