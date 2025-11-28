ServiceEffectCommand = class("ServiceEffectCommand", pm.SimpleCommand)

function ServiceEffectCommand:execute(note)
  local proxy = NSceneEffectProxy.Instance
  local data = note.body
  local effectType = data.effecttype
  local opt = data.opt
  if effectType == SceneUser2_pb.EEFFECTTYPE_NORMAL then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      if data.charid > 0 then
        proxy:Add(data)
      else
      end
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      proxy:Remove(data)
    end
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_SKILL then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      if data.charid > 0 then
        proxy:AddSkillEffect(data)
      else
      end
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      proxy:Remove(data)
    end
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_SCENEEFFECT then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      if 0 < data.id then
        proxy:Server_AddSceneEffect(data)
      else
      end
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      proxy:Remove(data)
    end
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_ACCEPTQUEST then
    FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.accept)
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_FINISHQUEST then
    FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.complete)
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_MVPSHOW then
    FloatingPanel.Instance:FloatingMidEffect(EffectMap.UI.warning, function(effect)
      effect.transform.localPosition = LuaGeometry.GetTempVector3(0, 100, 0)
    end)
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_UIPATH then
    FloatingPanel.Instance:FloatingMidEffectByFullPath(data.effect, function(effect)
      effect.transform.localPosition = LuaGeometry.GetTempVector3()
    end)
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_CAMERAFILTER then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      if PpLua == nil then
        autoImport("PpLua")
      end
      PpLua:Init(Camera.main)
      PpLua:SetEffect(data.effect)
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      PpLua:Destroy()
    end
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_FILTER then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      local cfData = Table_CameraFilters[data.filterid]
      if cfData then
        CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cfData.FilterName, cfData.SpecialEffectsName, true, nil, data.msec)
      end
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      CameraFilterProxy.Instance:CFQuit(true)
    end
  elseif effectType == SceneUser2_pb.EEFFECTTYPE_FULLSCREENUIEFFECT then
    if opt == SceneUser2_pb.EEFFECTOPT_PLAY then
      if not Game.Myself.data.attrEffect3:BlindnessState() then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.FullScreenEffectView,
          viewdata = data
        })
      end
    elseif opt == SceneUser2_pb.EEFFECTOPT_DELETE then
      GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
    end
  end
end
