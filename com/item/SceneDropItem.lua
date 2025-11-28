autoImport("SceneLItem")
autoImport("SceneDropNameCell")
SceneDropItem = reusableClass("SceneDropItem", SceneLItem)
SceneDropItem.PoolSize = 20
SceneDropItem.State = {
  Wait,
  Appear,
  OnGround,
  Disappear
}
SceneDropItem.ItemResID = {}
SceneDropItem.EffectResID = {}
local F_CurServerTime = ServerTime.CurServerTime
local ArrayIndexOf = TableUtil.ArrayIndexOf
local ConfigPrivateOwnTime = GameConfig.SceneDropItem.privateOwnTime
local tempVector3 = LuaVector3.Zero()
local MyselfID
local FlyModel = 10
local FIXED_FLYING_TIME = 2.0
local DEFAULT_HEIGHT_FACTOR = 2.0

function SceneDropItem:ctor()
  SceneDropItem.super.ctor(self)
  MyselfID = Game.Myself and Game.Myself.data.id
end

function SceneDropItem:ResetData(guid, staticData, equipStaticData, privateTime, disappeartime, pos, owners, config, sourceID, refinelv, stage, from_pos)
  self.id = guid
  self.failedGetCount = 0
  self:SetState(SceneDropItem.State.Wait)
  self.staticData = staticData
  self.equipStaticData = equipStaticData
  if #owners == 0 or 0 < ArrayIndexOf(owners, MyselfID) then
    self:SetCanPickUp(true)
  else
    self:SetCanPickUp(false)
  end
  self.privateTime = privateTime or F_CurServerTime() + ConfigPrivateOwnTime
  self.destroyTime = disappeartime or F_CurServerTime() + ConfigPrivateOwnTime
  self.pos = LuaVector3(pos.x, pos.y, pos.z)
  ProtolUtility.Better_S2C_Vector3(self.pos, self.pos)
  NavMeshUtility.Better_Sample(self.pos, self.pos, 1)
  self.config = config
  self.isskill = config == GameConfig.SceneDropItem.Skill
  self.sourceID = sourceID
  self.refinelv = refinelv
  self.stage = stage
  self:GetConfig()
  if self.stage and self.stage == 1 then
    local sourceNpc = NSceneNpcProxy.Instance:Find(sourceID)
    if sourceNpc then
      local posX, posY, posZ = sourceNpc.assetRole:GetEPPosition(RoleDefines_EP.Top)
      if posX then
        self.from_pos = LuaVector3(posX, posY, posZ)
      end
    end
    if not self.from_pos then
      self.from_pos = LuaVector3(from_pos.x, from_pos.y + 8000, from_pos.z)
      ProtolUtility.Better_S2C_Vector3(self.from_pos, self.from_pos)
    end
    self:StartProjectile()
  end
end

function SceneDropItem:CanShow()
  return self.iCanPickUp or F_CurServerTime() > self.privateTime
end

function SceneDropItem:CanBeDestroyed()
  return F_CurServerTime() > self.destroyTime
end

function SceneDropItem:SetCanPickUp(val)
  self.iCanPickUp = val
end

function SceneDropItem:SetState(state)
  self.state = state
end

function SceneDropItem:CallBack(t)
  if t ~= nil then
    if t[3] ~= nil then
      t[1](t[2], self, unpack(t[3]))
    else
      t[1](t[2], self)
    end
  end
end

function SceneDropItem:GetConfig()
  if self.config == nil then
    if self.equipStaticData ~= nil then
      self.config = GameConfig.SceneDropItem.EquipBox
    elseif self.stage and self.stage > 0 then
      self.config = GameConfig.SceneDropItem.DragonReward
    else
      self.config = GameConfig.SceneDropItem.ItemBox
    end
  end
end

function SceneDropItem:PlayAnim(state)
  if self.animPlayer ~= nil and self.animatorHelper then
    self.animatorHelper:Play(state, 1, false)
  end
end

function SceneDropItem:PlayAnimForce(state)
  if self.animPlayer ~= nil and self.animatorHelper then
    self.animatorHelper:PlayForce(state, 1)
  end
end

function SceneDropItem:FailGet()
  self.failedGetCount = self.failedGetCount + 1
  self:PlayAnimForce(GameConfig.SceneDropItem.Anims.WrongItem)
end

function SceneDropItem:SetNeedPickedUp(val)
  self.needPickedUp = val
end

function SceneDropItem:GetNeedPickedUp()
  return self.needPickedUp
end

local F_DelayPickUpTick = function(self, deltaTime)
  if self.pickUpCall then
    self.pickUpCall(self, unpack(self.pickUpCallParam))
  end
  self.pickUpCall = nil
  self.pickUpCallParam = nil
  self.pickLt = nil
end

function SceneDropItem:Pick(callBack, ...)
  if self.isPicked then
    return
  end
  self.isPicked = true
  if Slua.IsNull(self.model) then
    if callBack then
      callBack(self, ...)
    end
    return
  end
  self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemOpen)
  self.pickUpCall = callBack
  self.pickUpCallParam = {
    ...
  }
  if self.pickLt then
    TimeTickManager.Me():ClearTick(self, 22)
    self.pickLt = nil
  end
  self.pickLt = TimeTickManager.Me():CreateOnceDelayTick(1000, F_DelayPickUpTick, self, 22)
end

local effectPos = LuaVector3(0, 0, 0)

function SceneDropItem:GetEffectPoint(index)
  if self.pointSub ~= nil then
    effectPos:Set(LuaGameObject.GetPosition(self.pointSub:GetEffectPoint(index).transform))
    return effectPos
  else
    return self.pos
  end
end

local F_DelayShowQualityTick = function(self, deltaTime)
  self:ShowQuality()
  self:ShowName()
  if self.appearCall then
    self.appearCall(self.appearCallParam, self)
    self.appearCall = nil
  end
  self.sqlitylt = nil
end
local F_ModelCreated = function(self, obj)
  if not obj then
    return
  end
  if not self.isCreate then
    Game.AssetManager_SceneItem:DestroySceneDrop(self.config.Model, obj)
    return
  end
  self.model = obj
  if self.isskill then
    self:SetSkillIcon()
  end
  self.model.name = "Item_" .. self.id
  self.model.transform.localScale = LuaGeometry.GetTempVector3(self.config.Scale, self.config.Scale, self.config.Scale, tempVector3)
  self.model.transform.localPosition = self.pos
  self.animPlayer = self.model:GetComponent(SimpleAnimatorPlayer)
  self.animatorHelper = self.animPlayer and self.animPlayer.animatorHelper
  self.pointSub = self.model:GetComponent(PointSubject)
  if self.state == SceneDropItem.State.Appear then
    self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemBorn)
    self.sqlitylt = TimeTickManager.Me():CreateOnceDelayTick(600, F_DelayShowQualityTick, self, 11)
  else
    self:PlayAnimForce(GameConfig.SceneDropItem.Anims.ItemDrop)
    self:ShowQuality()
    self:ShowName()
    if self.appearCall then
      self.appearCall(self.appearCallParam, self)
      self.appearCall = nil
    end
  end
end

function SceneDropItem:CreateModel(callBack, callBackParam)
  if not self.isCreate and self.model == nil then
    self.isCreate = true
    self.appearCall = callBack
    self.appearCallParam = callBackParam
    if self.sqlitylt then
      TimeTickManager.Me():ClearTick(self, 11)
      self.sqlitylt = nil
    end
    Game.AssetManager_SceneItem:CreateSceneDrop(self.id, self.config.Model, nil, F_ModelCreated, self)
  end
end

local tempVector2 = LuaVector2.Zero()

function SceneDropItem:SetSkillIcon()
  if self.model == nil then
    return
  end
  if self.staticData == nil then
    return
  end
  local item_skill = GameConfig.PoliFire.item_skill
  local skillid = item_skill[self.staticData.id]
  local icon
  if skillid == nil then
    icon = self.staticData.Icon
  else
    icon = Table_Skill[skillid] and Table_Skill[skillid].Icon or ""
  end
  if icon == nil or icon == "" then
    return
  end
  local atlas, spriteData
  local skillAtlas = IconManager:GetAtlasByType(UIAtlasConfig.IconAtlas.Skill)
  for i = 1, #skillAtlas do
    spriteData = skillAtlas[i]:GetSprite(icon)
    if spriteData ~= nil then
      atlas = skillAtlas[i]
      break
    end
  end
  if atlas == nil or spriteData == nil then
    return
  end
  if self.refAtlas then
    self.refAtlas:RemoveRef()
  end
  self.refAtlas = atlas
  self.refAtlas:AddRef()
  local texture = atlas.texture
  local offsetX = spriteData.x / texture.width
  local offsetY = (texture.height - spriteData.y - spriteData.height) / texture.height
  local scaleX = spriteData.width / texture.width
  local scaleY = spriteData.height / texture.height
  local go = Game.GameObjectUtil:DeepFindChild(self.model.gameObject, "Skill")
  local renderer = go:GetComponent(Renderer)
  renderer.material = Game.Prefab_SceneGuildIcon.sharedMaterial
  renderer.material.mainTexture = texture
  if nil ~= offsetX and nil ~= offsetY then
    LuaVector2.Better_Set(tempVector2, offsetX, offsetY)
    renderer.material.mainTextureOffset = tempVector2
  end
  if nil ~= scaleX and nil ~= scaleY then
    LuaVector2.Better_Set(tempVector2, scaleX, scaleY)
    renderer.material.mainTextureScale = tempVector2
  end
end

function SceneDropItem:Appear(callBack, callBackParam)
  self:SetState(SceneDropItem.State.OnGround)
  self:CreateModel(callBack, callBackParam)
end

function SceneDropItem:PlayAppear(callBack, callBackParam)
  self:SetState(SceneDropItem.State.Appear)
  self:CreateModel(callBack, callBackParam)
end

function SceneDropItem:ShowSmoke()
  Asset_Effect.PlayOneShotAt(EffectMap.Maps.ItemSmoke, p)
end

function SceneDropItem:ShowQuality()
  if self.config.DropPerform == 1 then
    local effect
    if self.isskill then
      effect = "Common/Poring_Skill"
    else
      effect = GameConfig.SceneDropItem.Quality[self.staticData.Quality]
    end
    if effect then
      self.qualityEffect = Asset_Effect.PlayAt(effect, self.pos)
    end
  end
end

function SceneDropItem:ShowName()
  if self.config.ShowName then
    self.ui = SceneDropNameCell.CreateAsTable(self)
  end
end

function SceneDropItem:DestroyUI()
  if self.ui then
    self.ui:Destroy()
  end
  self.ui = nil
end

local F_ProjectileModelCreated = function(self, obj)
  if not obj then
    return
  end
  if not self.isProjectileCreate then
    Game.AssetManager_SceneItem:DestroySceneDrop(FlyModel, obj)
    return
  end
  self.projectileModel = obj
  self.projectileModel.name = "Item_Projectile_" .. self.id
  self.projectileModel.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1, tempVector3)
  self.projectileModel.transform.localPosition = self.from_pos
end

function SceneDropItem:StartProjectile()
  if not self.isProjectileCreate and self.projectileModel == nil then
    self.isProjectileCreate = true
    Game.AssetManager_SceneItem:CreateSceneDrop(self.id * 10, FlyModel, nil, F_ProjectileModelCreated, self)
  end
  if self.flyTimeTick then
    TimeTickManager.Me():ClearTick(self, 33)
    self.flyTimeTick = nil
  end
  self:InitProjectileParams()
  self.flyTimeTick = TimeTickManager.Me():CreateTick(0, 33, function(self)
    self:UpdateFlying()
  end, self, 33)
end

function SceneDropItem:InitProjectileParams()
  if not self.from_pos or not self.pos then
    return
  end
  self.flyStartTime = Time.time
  self:SetControlPoint()
  self.flyProgress = 0
end

function SceneDropItem:SetControlPoint()
  if not self.from_pos or not self.pos then
    return
  end
  local midX = (self.from_pos.x + self.pos.x) * 0.5
  local midZ = (self.from_pos.z + self.pos.z) * 0.5
  local dirX = self.pos.x - self.from_pos.x
  local dirZ = self.pos.z - self.from_pos.z
  local length = math.sqrt(dirX * dirX + dirZ * dirZ)
  local offsetX, offsetZ = 0, 0
  local offsetY = 0
  if 0.001 < length then
    dirX, dirZ = dirX / length, dirZ / length
    local perpX, perpZ = -dirZ, dirX
    local lateralOffset = math.min(length * 0.2, 3.0) * (math.random() * 2 - 1)
    offsetX = perpX * lateralOffset
    offsetZ = perpZ * lateralOffset
    offsetY = math.max(length * 0.3, 3.0) * DEFAULT_HEIGHT_FACTOR
  else
    offsetY = 3.0 * DEFAULT_HEIGHT_FACTOR
  end
  local highPoint = math.max(self.from_pos.y, self.pos.y) + offsetY
  if not self.bezierStartTangent then
    self.bezierStartTangent = LuaVector3.New(midX + offsetX, highPoint, midZ + offsetZ)
  else
    self.bezierStartTangent:Set(midX + offsetX, highPoint, midZ + offsetZ)
  end
  if not self.bezierStart then
    self.bezierStart = LuaVector3.New(self.from_pos.x, self.from_pos.y, self.from_pos.z)
  else
    self.bezierStart:Set(self.from_pos.x, self.from_pos.y, self.from_pos.z)
  end
  if not self.endPos then
    self.endPos = LuaVector3.New(self.pos.x, self.pos.y, self.pos.z)
  else
    self.endPos:Set(self.pos.x, self.pos.y, self.pos.z)
  end
end

local Better_Bezier = VectorUtility.Better_Bezier
local tempVector3 = LuaVector3.Zero()

function SceneDropItem:UpdateFlying()
  if not (self.projectileModel and self.bezierStart and self.bezierStartTangent) or not self.endPos then
    return false
  end
  local elapsedTime = Time.time - self.flyStartTime
  self.flyProgress = math.min(elapsedTime / FIXED_FLYING_TIME, 1.0)
  Better_Bezier(self.bezierStart, self.bezierStartTangent, self.endPos, tempVector3, self.flyProgress)
  if not Slua.IsNull(self.projectileModel) then
    self.projectileModel.transform.position = tempVector3
  end
  if self.flyProgress >= 1.0 then
    if self.flyTimeTick then
      TimeTickManager.Me():ClearTick(self, 33)
      self.flyTimeTick = nil
    end
    if self.projectileModel and not Slua.IsNull(self.projectileModel) then
      Game.AssetManager_SceneItem:DestroySceneDrop(FlyModel, self.projectileModel)
      self.projectileModel = nil
    end
    return false
  end
  return true
end

function SceneDropItem:ResetLocalPosition(pos)
  if self.projectileModel and not Slua.IsNull(self.projectileModel) then
    self.projectileModel.transform.position = pos
  end
end

function SceneDropItem:DoConstruct(asArray, data)
  self.isCreate = false
  self.isProjectileCreate = false
  self.isPicked = false
  self.needPickedUp = false
  self.flyProgress = 0
end

function SceneDropItem:DoDeconstruct(asArray)
  self:DestroyUI()
  self:ClearProjectileArgs()
  if self.pos then
    LuaVector3.Destroy(self.pos)
  end
  self.pos = nil
  Game.AssetManager_SceneItem:CancelCreateSceneDrop(self.id)
  if not Slua.IsNull(self.model) then
    Game.AssetManager_SceneItem:DestroySceneDrop(self.config.Model, self.model)
  end
  self.model = nil
  self.isCreate = false
  if self.refAtlas then
    self.refAtlas:RemoveRef()
    self.refAtlas = nil
  end
  if self.qualityEffect and self.qualityEffect:Alive() then
    self.qualityEffect:Destroy()
    self.qualityEffect = nil
  end
  self.animPlayer = nil
  self.animatorHelper = nil
  self.appearCall = nil
  self.appearCallParam = nil
  self.pickUpCall = nil
  self.pickUpCallParam = nil
  if self.sqlitylt then
    TimeTickManager.Me():ClearTick(self, 11)
    self.sqlitylt = nil
  end
  if self.pickLt then
    TimeTickManager.Me():ClearTick(self, 22)
    self.pickLt = nil
  end
  if self.flyTimeTick then
    TimeTickManager.Me():ClearTick(self, 33)
    self.flyTimeTick = nil
  end
end

function SceneDropItem:ClearProjectileArgs()
  Game.AssetManager_SceneItem:CancelCreateSceneDrop(self.id * 10)
  if self.projectileModel and not Slua.IsNull(self.projectileModel) then
    Game.AssetManager_SceneItem:DestroySceneDrop(FlyModel, self.projectileModel)
    self.projectileModel = nil
  end
  if self.from_pos then
    self.from_pos:Destroy()
    self.from_pos = nil
  end
  if self.bezierStart then
    self.bezierStart:Destroy()
    self.bezierStart = nil
  end
  if self.bezierStartTangent then
    self.bezierStartTangent:Destroy()
    self.bezierStartTangent = nil
  end
  if self.endPos then
    self.endPos:Destroy()
    self.endPos = nil
  end
  self.flyProgress = 0
  self.flyStartTime = nil
  self.isProjectileCreate = false
end
