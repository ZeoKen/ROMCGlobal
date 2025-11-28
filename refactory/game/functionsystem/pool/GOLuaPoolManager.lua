GOLuaPoolManager = class("GOLuaPoolManager")
local IsNull = Slua.IsNull
local SetParent = SetParent
local ROSetParent = LuaGameObject.SetParent
local FAST_MODE = GAME_FAST_MODE
local PoolConfigs = {
  [1] = {
    effect = {
      50,
      50,
      2,
      2
    },
    body = {
      20,
      2,
      2,
      2
    },
    hair = {
      20,
      2,
      2,
      2
    },
    weapon = {
      20,
      2,
      2,
      2
    },
    head = {
      20,
      2,
      2,
      2
    },
    face = {
      20,
      2,
      2,
      2
    },
    wing = {
      20,
      2,
      2,
      2
    },
    tail = {
      20,
      2,
      2,
      2
    },
    eye = {
      20,
      2,
      2,
      2
    },
    mount = {
      20,
      2,
      2,
      2
    },
    mountpart = {
      40,
      2,
      2,
      2
    },
    mouth = {
      20,
      2,
      2,
      2
    },
    sceneui = {
      10,
      200,
      2,
      2
    }
  },
  [2] = {
    effect = {
      30,
      30,
      2,
      2
    },
    body = {
      10,
      2,
      2,
      2
    },
    hair = {
      10,
      2,
      2,
      2
    },
    weapon = {
      10,
      2,
      2,
      2
    },
    head = {
      10,
      2,
      2,
      2
    },
    face = {
      10,
      2,
      2,
      2
    },
    wing = {
      10,
      2,
      2,
      2
    },
    tail = {
      10,
      2,
      2,
      2
    },
    eye = {
      10,
      2,
      2,
      2
    },
    mount = {
      10,
      2,
      2,
      2
    },
    mountpart = {
      20,
      2,
      2,
      2
    },
    mouth = {
      10,
      2,
      2,
      2
    },
    sceneui = {
      10,
      20,
      2,
      2
    }
  },
  [3] = {
    effect = {
      30,
      30,
      2,
      2
    },
    body = {
      10,
      1,
      2,
      2
    },
    hair = {
      10,
      1,
      2,
      2
    },
    weapon = {
      10,
      1,
      2,
      2
    },
    head = {
      10,
      1,
      2,
      2
    },
    face = {
      10,
      1,
      2,
      2
    },
    wing = {
      10,
      1,
      2,
      2
    },
    tail = {
      10,
      1,
      2,
      2
    },
    eye = {
      10,
      1,
      2,
      2
    },
    mount = {
      10,
      1,
      2,
      2
    },
    mountpart = {
      20,
      1,
      2,
      2
    },
    mouth = {
      10,
      1,
      2,
      2
    },
    sceneui = {
      10,
      20,
      2,
      2
    }
  }
}

function GOLuaPoolManager:ctor()
  self.gameObject = GameObject("LuaGameObjectPool")
  self.gameObject.transform:SetParent(LuaLuancher.Instance.monoGameObject.transform)
  GameObject.DontDestroyOnLoad(self.gameObject)
  local configIndex = 1
  local systemMem = ApplicationInfo.GetSystemMemorySize()
  if systemMem < 2800 then
    configIndex = 3
  elseif systemMem < 4800 then
    configIndex = 2
  end
  local poolConfig = PoolConfigs[configIndex]
  self.uiPool = GOLuaPool.new("UI", self.gameObject, 0, 60, false, {
    UIPanel
  })
  local config = poolConfig.sceneui
  self.sceneuiPool = GOLRUPool.new("SceneUI", self.gameObject, config[1], config[2], false, nil, config[3], config[4])
  self.sceneuiMovePool = MovePosPool.new(15)
  self.chatPool = GOLuaPool.new("Chat", self.gameObject, 0, 85)
  self.hurtNumPool = GOLuaPool.new("HurtNum", self.gameObject, 0, 50)
  config = poolConfig.effect
  self.effectPool = GOLRUPool.new("effectPool", self.gameObject, config[1], config[2], false, {
    UIPanel
  }, 30, 4, config[3], config[4])
  self.astrolabePool = GOLRUPool.new("Astrolabe", self.gameObject, 20, 100, false, {
    UIPanel
  }, 20, 15)
  self.sceneDropItemPool = GOLuaPool.new("SceneDropItems", self.gameObject, 0, 20)
  self.sceneSeatPool = GOLuaPool.new("SceneSeat", self.gameObject, 0, 20)
  self.role_CompletePool = GOLRUPool.new("role_CompletePool", self.gameObject, 10, 200, false, nil, 200, 60)
  config = poolConfig.body
  self.role_part_bodyPool = GOLRUPool.new("role_part_bodyPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.hair
  self.role_part_hairPool = GOLRUPool.new("role_part_hairPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.weapon
  self.role_part_weaponPool = GOLRUPool.new("role_part_weaponPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.head
  self.role_part_headPool = GOLRUPool.new("role_part_headPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.face
  self.role_part_facePool = GOLRUPool.new("role_part_facePool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.wing
  self.role_part_wingPool = GOLRUPool.new("role_part_wingPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.tail
  self.role_part_tailPool = GOLRUPool.new("role_part_tailPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.eye
  self.role_part_eyePool = GOLRUPool.new("role_part_eyePool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.mount
  self.role_part_mountPool = GOLRUPool.new("role_part_mountPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.mountpart
  self.role_part_mountPartPool = GOLRUPool.new("role_part_mountPartPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  config = poolConfig.mouth
  self.role_part_mouthPool = GOLRUPool.new("role_part_mouthPool", self.gameObject, config[1], config[2], false, nil, 30, 4, config[3], config[4])
  self.stage_partPool = GOLuaPool.new("stage_partPool", self.gameObject, 30, 3, false)
  self.emptyGOPool = GOLuaPool.new("EmptyGO", self.gameObject, 0, 100)
end

function GOLuaPoolManager:GetFromUIPool(key, parent)
  return self.uiPool:Remove(key, parent)
end

function GOLuaPoolManager:AddToUIPool(key, go)
  local isAdd = self.uiPool:Add(key, go)
  if not isAdd and not IsNull(go) then
    GameObject.Destroy(go)
  end
  return isAdd
end

function GOLuaPoolManager:ClearUIPool()
  self.uiPool:Clear()
end

function GOLuaPoolManager:Update(time, deltaTime)
  self.effectPool:Update(time, deltaTime)
  self.astrolabePool:Update(time, deltaTime)
  self.role_CompletePool:Update(time, deltaTime)
  self.role_part_bodyPool:Update(time, deltaTime)
  self.role_part_hairPool:Update(time, deltaTime)
  self.role_part_weaponPool:Update(time, deltaTime)
  self.role_part_headPool:Update(time, deltaTime)
  self.role_part_facePool:Update(time, deltaTime)
  self.role_part_wingPool:Update(time, deltaTime)
  self.role_part_tailPool:Update(time, deltaTime)
  self.role_part_eyePool:Update(time, deltaTime)
  self.role_part_mountPool:Update(time, deltaTime)
  self.role_part_mountPartPool:Update(time, deltaTime)
  self.role_part_mouthPool:Update(time, deltaTime)
end

function GOLuaPoolManager:GetFromSceneUIPool(key, parent)
  return self.sceneuiPool:Remove(key, parent)
end

function GOLuaPoolManager:AddToSceneUIPool(key, go)
  if not IsNull(go) then
    go.gameObject:SetActive(false)
    local isAdd = self.sceneuiPool:Add(key, go)
    if not isAdd then
      GameObject.Destroy(go)
    end
    return isAdd
  end
  return false
end

function GOLuaPoolManager:ClearSceneUIPool()
  self.sceneuiPool:Clear()
end

function GOLuaPoolManager:GetFromAstrolabePool(key, parent)
  return self.astrolabePool:Remove(key, parent)
end

function GOLuaPoolManager:AddToAstrolabePool(key, go)
  local isAdd = self.astrolabePool:Add(key, go)
  if not isAdd and not IsNull(go) then
    GameObject.Destroy(go)
  end
  return isAdd
end

function GOLuaPoolManager:ClearAstrolabePool()
  self.astrolabePool:Clear()
end

function GOLuaPoolManager:GetFromSceneUIMovePool(key, parent)
  return self.sceneuiMovePool:Get(key, parent)
end

function GOLuaPoolManager:AddToSceneUIMovePool(key, go)
  local putIn, res = self.sceneuiMovePool:Put(key, go)
  if not putIn and res ~= nil then
    for i = 1, #res do
      self:AddToSceneUIPool(key, res[i])
    end
    self.sceneuiMovePool:RemovePoolByKey(key)
    return true
  end
  return putIn
end

function GOLuaPoolManager:ClearSceneUIMovePool()
  self.sceneuiMovePool:Clear()
end

function GOLuaPoolManager:GetFromChatPool(go, parent)
  if SetParent(go, parent) then
    return go
  end
  return nil
end

function GOLuaPoolManager:AddToChatPool(go)
  if IsNull(go) == false then
    return self.chatPool:AddChild(go)
  end
  return false
end

function GOLuaPoolManager:GetFromHurtNumPool(go, parent)
  if SetParent(go, parent) then
    return go
  end
  return nil
end

function GOLuaPoolManager:AddToHurtNumPool(go)
  if IsNull(go) == false then
    return self.hurtNumPool:AddChild(go)
  end
  return false
end

function GOLuaPoolManager:GetFromEffectPool(key, parent)
  local effect = self.effectPool:Remove(key, parent)
  return effect
end

function GOLuaPoolManager:AddToEffectPool(key, go)
  local success = self.effectPool:Add(key, go, true)
  return success
end

function GOLuaPoolManager:ClearEffectPool()
  self.effectPool:Clear()
end

function GOLuaPoolManager:GetFromSceneDropPool(key, parent)
  local drop = self.sceneDropItemPool:Remove(key, parent)
  return drop
end

function GOLuaPoolManager:AddToSceneDropPool(key, go)
  local success = self.sceneDropItemPool:Add(key, go)
  return success
end

function GOLuaPoolManager:ClearSceneDropPool()
  self.sceneDropItemPool:Clear()
end

function GOLuaPoolManager:GetFromSceneSeatPool(key, parent)
  return self.sceneSeatPool:Remove(key, parent)
end

function GOLuaPoolManager:AddToSceneSeatPool(key, go)
  return self.sceneSeatPool:Add(key, go)
end

function GOLuaPoolManager:ClearSceneSeatPool()
  self.sceneSeatPool:Clear()
end

function GOLuaPoolManager:GetFromRoleCompletePool(parent)
  return self.role_CompletePool:Remove(1, parent)
end

function GOLuaPoolManager:AddToRoleCompletePool(go)
  return self.role_CompletePool:Add(1, go, true)
end

function GOLuaPoolManager:ClearRoleCompletePool()
  self.role_CompletePool:Clear()
end

function GOLuaPoolManager:GetFromRolePartBodyPool(key, parent)
  local part = self.role_part_bodyPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartBodyPool(key, go)
  go.componentsDisable = true
  return self.role_part_bodyPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartBodyPool()
  self.role_part_bodyPool:Clear()
end

function GOLuaPoolManager:RolePartBodyKeyFull()
  return self.role_part_bodyPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartBodyElementFull(key)
  return self.role_part_bodyPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartBodyElementCount(key)
  return self.role_part_bodyPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartHairPool(key, parent)
  local part = self.role_part_hairPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartHairPool(key, go)
  go.componentsDisable = true
  return self.role_part_hairPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartHairPool()
  self.role_part_hairPool:Clear()
end

function GOLuaPoolManager:RolePartHairKeyFull()
  return self.role_part_hairPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartHairElementFull(key)
  return self.role_part_hairPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartHairElementCount(key)
  return self.role_part_hairPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartWeaponPool(key, parent)
  local part = self.role_part_weaponPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartWeaponPool(key, go)
  go.componentsDisable = true
  return self.role_part_weaponPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartWeaponPool()
  self.role_part_weaponPool:Clear()
end

function GOLuaPoolManager:RolePartWeaponKeyFull()
  return self.role_part_weaponPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartWeaponElementFull(key)
  return self.role_part_weaponPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartWeaponElementCount(key)
  return self.role_part_weaponPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartHeadPool(key, parent)
  local part = self.role_part_headPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartHeadPool(key, go)
  go.componentsDisable = true
  return self.role_part_headPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartHeadPool()
  self.role_part_headPool:Clear()
end

function GOLuaPoolManager:RolePartHeadKeyFull()
  return self.role_part_headPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartHeadElementFull(key)
  return self.role_part_headPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartHeadElementCount(key)
  return self.role_part_headPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartFacePool(key, parent)
  local part = self.role_part_facePool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartFacePool(key, go)
  go.componentsDisable = true
  return self.role_part_facePool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartFacePool()
  self.role_part_facePool:Clear()
end

function GOLuaPoolManager:RolePartFaceKeyFull()
  return self.role_part_facePool:KeyIsFull()
end

function GOLuaPoolManager:RolePartFaceElementFull(key)
  return self.role_part_facePool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartFaceElementCount(key)
  return self.role_part_facePool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartWingPool(key, parent)
  local part = self.role_part_wingPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartWingPool(key, go)
  go.componentsDisable = true
  return self.role_part_wingPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartWingPool()
  self.role_part_wingPool:Clear()
end

function GOLuaPoolManager:RolePartWingKeyFull()
  return self.role_part_wingPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartWingElementFull(key)
  return self.role_part_wingPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartWingElementCount(key)
  return self.role_part_wingPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartTailPool(key, parent)
  local part = self.role_part_tailPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartTailPool(key, go)
  go.componentsDisable = true
  return self.role_part_tailPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartTailPool()
  self.role_part_tailPool:Clear()
end

function GOLuaPoolManager:RolePartTailKeyFull()
  return self.role_part_tailPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartTailElementFull(key)
  return self.role_part_tailPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartTailElementCount(key)
  return self.role_part_tailPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartEyePool(key, parent)
  local part = self.role_part_eyePool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartEyePool(key, go)
  go.componentsDisable = true
  return self.role_part_eyePool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartEyePool()
  self.role_part_eyePool:Clear()
end

function GOLuaPoolManager:RolePartEyeKeyFull()
  return self.role_part_eyePool:KeyIsFull()
end

function GOLuaPoolManager:RolePartEyeElementFull(key)
  return self.role_part_eyePool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartEyeElementCount(key)
  return self.role_part_eyePool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartMountPool(key, parent)
  local part = self.role_part_mountPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartMountPool(key, go)
  go.componentsDisable = true
  return self.role_part_mountPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartMountPool()
  self.role_part_mountPool:Clear()
end

function GOLuaPoolManager:RolePartMountKeyFull()
  return self.role_part_mountPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartMountElementFull(key)
  return self.role_part_mountPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartMountElementCount(key)
  return self.role_part_mountPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartMountPartPool(key, parent)
  local part = self.role_part_mountPartPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartMountPartPool(key, go)
  go.componentsDisable = true
  return self.role_part_mountPartPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartMountPartPool()
  self.role_part_mountPartPool:Clear()
end

function GOLuaPoolManager:RolePartMountPartKeyFull()
  return self.role_part_mountPartPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartMountPartElementFull(key)
  return self.role_part_mountPartPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartMountPartElementCount(key)
  return self.role_part_mountPartPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartMouthPool(key, parent)
  local part = self.role_part_mouthPool:Remove(key, parent)
  if part then
    part.componentsDisable = false
  end
  return part
end

function GOLuaPoolManager:AddToRolePartMouthPool(key, go)
  go.componentsDisable = true
  return self.role_part_mouthPool:Add(key, go, true)
end

function GOLuaPoolManager:ClearRolePartMouthPool()
  self.role_part_mouthPool:Clear()
end

function GOLuaPoolManager:RolePartMouthKeyFull()
  return self.role_part_mouthPool:KeyIsFull()
end

function GOLuaPoolManager:RolePartMouthElementFull(key)
  return self.role_part_mouthPool:ElementsFull(key)
end

function GOLuaPoolManager:RolePartMouthElementCount(key)
  return self.role_part_mouthPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:AddToStagePool(key, go)
  return self.stage_partPool:Add(key, go)
end

function GOLuaPoolManager:GetFromStagePool(key, parent)
  self.stage_partPool:Remove(key, parent)
end

function GOLuaPoolManager:ClearStagePool()
  self.stage_partPool:Clear()
end

function GOLuaPoolManager:AddToEmptyGOPool(key, go)
  local isAdd = self.emptyGOPool:Add(key, go)
  if not isAdd and not IsNull(go) then
    GameObject.Destroy(go)
  end
  return isAdd
end

function GOLuaPoolManager:GetFromEmptyGOPool(key, parent)
  local go = self.emptyGOPool:Remove(key, parent)
  if go == nil then
    go = GameObject()
  end
  return go
end

function GOLuaPoolManager:ClearEmptyGOPool()
  self.emptyGOPool:Clear()
end

function GOLuaPoolManager:ClearAllPools()
  self:ClearUIPool()
  self:ClearEffectPool()
  self:ClearSceneDropPool()
  self:ClearRolePartEyePool()
  self:ClearRolePartBodyPool()
  self:ClearRolePartHairPool()
  self:ClearRolePartWeaponPool()
  self:ClearRolePartHeadPool()
  self:ClearRolePartFacePool()
  self:ClearRolePartWingPool()
  self:ClearRolePartTailPool()
  self:ClearRolePartMountPool()
  self:ClearRolePartMountPartPool()
  self:ClearSceneUIPool()
  self:ClearAstrolabePool()
  self:ClearSceneUIMovePool()
  self:ClearStagePool()
  self:ClearSceneSeatPool()
  self:ClearEmptyGOPool()
end

function GOLuaPoolManager:Dispose()
  GameObject.Destroy(self.gameObject)
end

function GOLuaPoolManager:HandleLowMemory()
  for _ = 1, 8 do
    self.effectPool:GraduallyReleasePool()
  end
  self.role_part_bodyPool:Clear()
  self.role_part_hairPool:Clear()
  self.role_part_weaponPool:Clear()
  self.role_part_headPool:Clear()
  self.role_part_facePool:Clear()
  self.role_part_wingPool:Clear()
  self.role_part_tailPool:Clear()
  self.role_part_eyePool:Clear()
  self.role_part_mountPool:Clear()
  self.role_part_mountPartPool:Clear()
  self.role_part_mouthPool:Clear()
  self.sceneuiPool:Clear()
  self.uiPool:Clear()
end

function GOLuaPoolManager:SpeedUpPoolRelease()
  for _ = 1, 5 do
    self.effectPool:GraduallyReleasePool()
    self.role_part_bodyPool:GraduallyReleasePool()
    self.role_part_hairPool:GraduallyReleasePool()
    self.role_part_weaponPool:GraduallyReleasePool()
    self.role_part_headPool:GraduallyReleasePool()
    self.role_part_facePool:GraduallyReleasePool()
    self.role_part_wingPool:GraduallyReleasePool()
    self.role_part_tailPool:GraduallyReleasePool()
    self.role_part_eyePool:GraduallyReleasePool()
    self.role_part_mountPool:GraduallyReleasePool()
    self.role_part_mountPartPool:GraduallyReleasePool()
    self.role_part_mouthPool:GraduallyReleasePool()
    self.sceneuiPool:GraduallyReleasePool()
  end
end

local tmpV = LuaVector3(10000, 10000, 10000)
GOLRUPool = class("GOLRUPool")

function GOLRUPool:ctor(name, parent, keyMaxNum, maxNum, poolActive, initComps, scaleThreshold, releaseInterval, keyNumScaler, perKeyScaler)
  self.keyMaxNum = keyMaxNum
  self.pool = ROLruSetCache(keyMaxNum, maxNum, scaleThreshold)
  if keyNumScaler then
    self.pool.MaxCacheSizeFactor = keyNumScaler
  end
  if perKeyScaler then
    self.pool.MaxElementSizeFactor = perKeyScaler
  end
  self.keyMap = {}
  self.keyIndex = 1
  self.poolGO = GameObject(name)
  self.poolTrans = self.poolGO.transform
  if poolActive == true then
    self.poolTrans.localPosition = tmpV
  end
  SetParent(self.poolGO, parent)
  if poolActive == nil then
    poolActive = false
  end
  self.poolGO:SetActive(poolActive)
  self.poolActive = poolActive
  if initComps ~= nil then
    for i = 1, #initComps do
      self.poolGO:AddComponent(initComps[i])
    end
  end
  self.releaseInterval = releaseInterval
  self.lastReleaseTime = 0
end

function GOLRUPool:GetKeyIndex(name)
  local index = self.keyMap[name]
  if index == nil then
    self.keyIndex = self.keyIndex + 1
    index = self.keyIndex
    self.keyMap[name] = index
  end
  return index
end

function GOLRUPool:GraduallyReleasePool()
  self.pool:GraduallyReleasePool()
end

function GOLRUPool:Update(time, deltaTime)
  if time - self.lastReleaseTime > self.releaseInterval then
    self.pool:GraduallyReleasePool()
    self.lastReleaseTime = time
  end
end

function GOLRUPool:Add(name, go, checkEnabled)
  if not IsNull(go) then
    if checkEnabled and not go.enabled then
      LuaGameObject.RestoreBehaviours(go.gameObject)
    end
    local added = self.pool:Add(self:GetKeyIndex(name), go, true)
    if added then
      self:AddChild(go)
    end
    return added
  end
  return false
end

function GOLRUPool:AddChild(child)
  if self.poolActive then
    child.transform:SetParent(self.poolTrans, false)
  else
    ROSetParent(child, self.poolGO, false)
  end
end

function GOLRUPool:Remove(name, newParent)
  local element = self.pool:Extract(self:GetKeyIndex(name))
  if element ~= nil then
    ROSetParent(element, newParent, false)
    return element
  end
  return nil
end

function GOLRUPool:Clear()
  self.pool:ClearAll(true)
  TableUtility.TableClear(self.keyMap)
  self.keyIndex = 1
end

function GOLRUPool:GetElementCountByKey(key)
  return self.pool:ElementCount(self:GetKeyIndex(key))
end

function GOLRUPool:GetKeyLimit()
  return self.keyMaxNum
end

function GOLRUPool:ElementsFull(key)
  return self.pool:IsSetFull(self:GetKeyIndex(key))
end

GOLuaPool = class("GOLuaPool", LuaLRUKeyTable)

function GOLuaPool:ctor(name, parent, keyMaxNum, maxNum, poolActive, initComps)
  if poolActive == nil then
    poolActive = false
  end
  GOLuaPool.super.ctor(self, keyMaxNum, maxNum)
  self.poolGO = GameObject(name)
  if initComps ~= nil and 0 < #initComps then
    for i = 1, #initComps do
      self.poolGO:AddComponent(initComps[i])
    end
  end
  self.poolTrans = self.poolGO.transform
  self.poolGO:SetActive(poolActive)
  self.poolActive = poolActive
  if poolActive == true then
    self.poolGO.transform.localPosition = tmpV
  end
  SetParent(self.poolGO, parent)
  self.name = name
end

function GOLuaPool:Update(time, deltaTime)
  self:UpdateCull(time, deltaTime)
end

local superAdd = GOLuaPool.super.Add

function GOLuaPool:Add(name, go, checkEnabled)
  local spawnMap = self.spawnMap
  if spawnMap ~= nil then
    local spawnCount = spawnMap[name]
    if spawnCount ~= nil then
      spawnCount = spawnCount - 1
      spawnMap[name] = spawnCount
    end
  end
  if IsNull(go) == false then
    if checkEnabled and not go.enabled then
      LogUtility.DebugInfoFormat(go.gameObject, "<color=red>GOLuaPool:Add is not enabled: </color>{0},{1}", name, go.name)
      LuaGameObject.RestoreBehaviours(go.gameObject)
    end
    local added, removes = superAdd(self, name, go)
    if added then
      self:AddChild(go)
    end
    self:RemoveSome(removes)
    return added
  else
    LogUtility.InfoFormat("<color=red>GOLuaPool:Add is destroyed: </color>{0}", name)
  end
  return false
end

function GOLuaPool:AddChild(child)
  if self.poolActive then
    child.transform:SetParent(self.poolTrans, false)
  else
    SetParent(child, self.poolGO)
  end
end

local superTryGet = GOLuaPool.super.TryGetValue

function GOLuaPool:Remove(name, newParent)
  local spawnMap = self.spawnMap
  if spawnMap ~= nil then
    local spawnCount = spawnMap[name]
    if spawnCount == nil then
      spawnCount = 0
    end
    spawnCount = spawnCount + 1
    spawnMap[name] = spawnCount
  end
  local element = superTryGet(self, name)
  if element ~= nil and SetParent(element, newParent) then
    return element
  end
  return nil
end

function GOLuaPool:RemoveChild(child, newParent)
  if child ~= nil and IsNull(child) == false then
    child.transform:SetParent(IsNull(newParent) == false and newParent.transform or nil)
    return child
  end
  return nil
end

local DestroyGameObject = LuaGameObject.DestroyGameObject
local DestroyAndClearArray = ReusableTable.DestroyAndClearArray

function GOLuaPool:RemoveSome(removes)
  if removes then
    for i = 1, #removes do
      DestroyGameObject(removes[i])
    end
    DestroyAndClearArray(removes)
  end
end

local superClear = GOLuaPool.super.Clear

function GOLuaPool:Clear()
  local go
  local elements = self[4]
  for k, v in pairs(elements) do
    for i = 1, #v do
      go = v[i]
      if go ~= nil and IsNull(go) == false then
        GameObject.Destroy(go.gameObject)
      end
    end
    elements[k] = nil
    ReusableTable.DestroyAndClearArray(v)
  end
  superClear(self)
end

function GOLuaPool:ClearRetainCount(retainCount)
  local go
  local elements = self[4]
  for k, v in pairs(elements) do
    local count = #v
    count = retainCount < count and count - retainCount or 0
    for i = 1, count do
      go = v[i]
      if go ~= nil and IsNull(go) == false then
        GameObject.Destroy(go.gameObject)
      end
    end
  end
end

function GOLuaPool:RemoveChilds()
  local trans = self.poolGO.transform
  local childCount = trans.childCount
  for i = childCount - 1, 0, -1 do
    GameObject.Destroy(trans:GetChild(i).gameObject)
  end
end

function GOLuaPool:SetCull(cullAbove, cullDelay, cullMaxPerPass)
  self.cullAbove = cullAbove
  self.cullDelay = cullDelay or 5
  self.cullMaxPerPass = cullMaxPerPass or 1
  self.cullTime = 0
  self.spawnMap = {}
end

function GOLuaPool:UpdateCull(time, deltaTime)
  if time - self.cullTime <= self.cullDelay then
    return
  end
  self.cullTime = time
  local spawnCount = self:GetSpawnCount()
  TableUtility.TableClear(self.spawnMap)
  if 0 < spawnCount then
    return
  end
  self:DoCull()
end

function GOLuaPool:DoCull()
  local delta = self:GetKeyCount() - self.cullAbove
  if delta <= 0 then
    return
  end
  delta = math.min(delta, self.cullMaxPerPass)
  local removed, removes
  for i = delta, 1, -1 do
    removed, removes = self:RemoveByKey(self[3][i])
    self:RemoveSome(removes)
  end
end

function GOLuaPool:GetSpawnCount()
  local count = 0
  for k, v in pairs(self.spawnMap) do
    if 0 < v then
      count = count + 1
    else
      count = count - 1
    end
  end
  return count
end

MovePosPool = class("MovePosPool")
local pos = LuaVector3(999999, 999999, 999999)

function MovePosPool:ctor(count)
  self.count = count
  self.pool = {}
end

function MovePosPool:Put(key, go)
  if IsNull(go) == false then
    local pool = self.pool[key]
    if pool == nil then
      pool = {}
      self.pool[key] = pool
    end
    pool[#pool + 1] = go
    if self.count > 0 and #pool >= self.count then
      return false, pool
    end
    go.transform.localPosition = pos
    return true, nil
  end
  return false, nil
end

function MovePosPool:Get(key, parent)
  local pool = self.pool[key]
  if pool and 0 < #pool then
    local go
    for i = #pool, 1, -1 do
      go = pool[i]
      pool[i] = nil
      if IsNull(go) == false and SetParent(go, parent) then
        return go
      end
    end
  end
  return nil
end

function MovePosPool:RemovePoolByKey(key)
  local pool = self.pool[key]
  if pool then
    ReusableTable.DestroyAndClearArray(pool)
    self.pool[key] = nil
  end
end

function MovePosPool:Clear()
  local go, p
  for k, pool in pairs(self.pool) do
    if pool then
      for i = #pool, 1, -1 do
        go = pool[i]
        if IsNull(go) == false then
          GameObject.Destroy(go)
        end
      end
      ReusableTable.DestroyAndClearArray(pool)
      self.pool[k] = nil
    end
  end
end
