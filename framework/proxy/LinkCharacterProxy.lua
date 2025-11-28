LinkCharacterProxy = class("LinkCharacterProxy", pm.Proxy)
LinkCharacterProxy.Instance = nil

function LinkCharacterProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "LinkCharacterProxy"
  if LinkCharacterProxy.Instance == nil then
    LinkCharacterProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function LinkCharacterProxy:Init()
  self:InitCfgs()
end

function LinkCharacterProxy:InitCfgs()
  self.staticCfgs = {}
  self.questIdMap = {}
  if not GameConfig.LinkCharacter then
    return
  end
  for _, cfg in pairs(GameConfig.LinkCharacter) do
    self.staticCfgs[cfg.CharacterID] = cfg
    self.questIdMap[cfg.QuestID] = true
  end
end

local initialCameraPos, initialCameraRot, initialOrthographicSize = {
  0,
  0.88,
  0
}, {
  0,
  0,
  0
}, 1

function LinkCharacterProxy:SetCurrentCharacter(charId)
  self.curCharCfg = charId and self.staticCfgs[charId]
  if self.curCharCfg then
    local pCfg, rCfg, osCfg = self.curCharCfg.CameraPosition or initialCameraPos, self.curCharCfg.CameraRotation or initialCameraRot, self.curCharCfg.OrthographicSize or initialOrthographicSize
    UIModelCameraTrans.LinkCharacter.position = Vector3(pCfg[1], pCfg[2], pCfg[3])
    UIModelCameraTrans.LinkCharacter.rotation = Quaternion.Euler(rCfg[1], rCfg[2], rCfg[3])
    UIModelCameraTrans.LinkCharacter.orthographicSize = osCfg
  end
end

function LinkCharacterProxy:GetCurrentCharacterConfig()
  self:CheckValidity()
  return self.curCharCfg
end

function LinkCharacterProxy:CheckValidity()
  if not self.curCharCfg then
    return
  end
  local myLv, mapId = MyselfProxy.Instance:RoleLevel(), SceneProxy.Instance:GetCurMapID()
  if self.curCharCfg.QuestLv and myLv < self.curCharCfg.QuestLv or self.curCharCfg.QuestMap and TableUtility.ArrayFindIndex(self.curCharCfg.QuestMap, mapId) > 0 then
    self.curCharCfg = nil
  end
end

function LinkCharacterProxy:CheckIsQuestIdOfLinkCharacter(questId)
  return self.questIdMap[questId] or false
end
