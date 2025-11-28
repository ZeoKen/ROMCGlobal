autoImport("Asset_Furniture")
NFurniture = class("NFurniture")
local BuildingRotations = {
  [1] = BuildingGrid.EBuildingRotation.E0,
  [2] = BuildingGrid.EBuildingRotation.E90,
  [3] = BuildingGrid.EBuildingRotation.E180,
  [4] = BuildingGrid.EBuildingRotation.E270
}

function NFurniture:ctor(id, staticID, parent, callBack)
  self.isAlive = true
  self.assetFurniture = Asset_Furniture.new(staticID, parent, function(furniture)
    self.assetFurniture = furniture
    if not furniture.gameObject then
      self:Destroy()
      return
    end
    self.gameObject = furniture.gameObject
    self.trans = furniture.trans
    self.gameCamera = NGUITools.FindCameraForLayer(self.gameObject.layer)
    self:Init(id, staticID)
    if callBack then
      callBack(self)
    end
  end)
end

local TAG = 0

function NFurniture:_SetTag()
  TAG = TAG + 1
  self.tag = TAG
end

function NFurniture:Init(id, staticID)
  self:_SetTag()
  self.vecMyPos = LuaVector3(0, 0, 0)
  self.rotationIndex = 1
  self.assetFurniture:SetBaseHeightLv(self.tag)
  self.assetFurniture:SetLocalEulerAngleY(self:GetRotationAngle())
  self.isTest = id == "ClientTest"
  self.id = self.isTest and id .. self.tag or id
  self.staticID = staticID
  self.extraInteract = nil
  local staticData = Table_HomeFurniture[self.staticID]
  self.assetFurniture:SetName(tostring(self.tag))
  self.isAutoRotate = type(staticData.FixedPlanes) == "table" and 0 < #staticData.FixedPlanes
  self.isHideWithWall = self.isAutoRotate and staticData.Altitude
  self.centerCellHeight = staticData.Altitude or 0 + (staticData.Height or 0) / 2
  self.assetFurniture:SetColliderName(tostring(self.id))
  local actionData = staticData.AccessAction and Table_ActionAnime[staticData.AccessAction]
  self.animName_Access = actionData and actionData.Name
  actionData = staticData.AccessEndAction and Table_ActionAnime[staticData.AccessEndAction]
  self.animName_AccessEnd = actionData and actionData.Name
  actionData = staticData.IdleAction and Table_ActionAnime[staticData.IdleAction]
  self.animName_Idle = actionData and actionData.Name
  actionData = staticData.NearbyAction and Table_ActionAnime[staticData.NearbyAction]
  self.animName_NearBy = actionData and actionData.Name
  self.nearByDistanceSquare = staticData.NearbyRange and staticData.NearbyRange * staticData.NearbyRange or 0
  self.needUpdate = self.animName_NearBy and self.animName_Idle and 0 < self.nearByDistanceSquare
  Game.InteractNpcManager:RegisterInteractFurniture(self.staticID, self.id)
  if HomeManager.Me():IsInEditMode() then
    self:OnEnterEditMode()
  elseif staticData and staticData.AccessType == HomeManager.AccessType.IsNPC then
    self.assetFurniture:SetActive(false)
  end
  local interactStaticData = Table_InteractFurniture[self.staticID]
  if interactStaticData then
    for cpid, actionid in pairs(interactStaticData.MountInfo) do
      self:GetCP(cpid)
    end
  end
  self.inited = true
end

function NFurniture:SetData(nFurnitureData)
  self.data = nFurnitureData
  if not self.data:IsServerInited() then
    return
  end
  if self.id ~= self.data.id and not self.isTest then
    Game.InteractNpcManager:UnregisterInteractFurniture(self.id)
    self.id = self.data.id
    self.assetFurniture:SetColliderName(tostring(self.id))
    Game.InteractNpcManager:RegisterInteractFurniture(self.staticID, self.id)
  end
  self.placeFloor = self.data.floor or self.placeFloor
  self.placeRow = self.data.row or self.placeRow
  self.placeCol = self.data.col or self.placeCol
  self.placeAngle = self.data.angle or self.placeAngle
  self:UpdateSeats(self.data.seats)
end

function NFurniture:GetRotationAngle()
  return BuildingRotations[self.rotationIndex] or self.assetFurniture:GetLocalEulerAngleY()
end

function NFurniture:SetRotationAngle(angle)
  if not angle then
    LogUtility.Error("Angle Is Nil!")
    return
  end
  if self:GetRotationAngle() == angle then
    return
  end
  for i = 1, #BuildingRotations do
    if math.abs(angle - BuildingRotations[i]) < 10 then
      self.rotationIndex = i
    end
  end
  self.assetFurniture:SetLocalEulerAngleY(angle)
end

function NFurniture:Rotate()
  self.rotationIndex = self.rotationIndex and self.rotationIndex < #BuildingRotations and self.rotationIndex + 1 or 1
  self.assetFurniture:SetLocalEulerAngleY(BuildingRotations[self.rotationIndex])
end

function NFurniture:SetCurCell(floorIndex, row, col)
  self.curFloor = floorIndex
  self.curRow = row
  self.curCol = col
end

function NFurniture:IsMoved()
  if not self.placeFloor then
    return false
  end
  return self.placeFloor ~= self.curFloor or self.placeRow ~= self.curRow or self.placeCol ~= self.curCol or self.placeAngle ~= self:GetRotationAngle()
end

function NFurniture:PlaceOnCurCell()
  self.placeFloor = self.curFloor
  self.placeRow = self.curRow
  self.placeCol = self.curCol
  self.placeAngle = self:GetRotationAngle()
end

function NFurniture:IsPlaced()
  return self.placeFloor ~= nil
end

function NFurniture:SetColliderLayer(layer)
  self.assetFurniture:SetColliderLayer(layer)
end

function NFurniture:SetSelect(isSelect)
  self.isSelect = isSelect
  self.assetFurniture:ShowSideShadow(not isSelect and HomeManager.Me():IsFurnitureNearWallSide(self.tag))
end

function NFurniture:IsAutoRotate()
  return self.isAutoRotate
end

function NFurniture:IsHideWithWall()
  return self.isHideWithWall
end

function NFurniture:GetInstanceID()
  return self.assetFurniture:GetInstanceID()
end

function NFurniture:GetPosition()
  if self.inited then
    LuaVector3.Better_Set(self.vecMyPos, self.assetFurniture:GetPositionXYZ())
  end
  return self.vecMyPos
end

function NFurniture:GetCP(cpid)
  return self.assetFurniture:GetCP(cpid)
end

function NFurniture:IsAccessible()
  return not self.forbidAccess and HomeProxy.Instance:CanUseFurnitureBySID(self.staticID)
end

function NFurniture:IsPhonograph()
  return self.data and self.data.staticID == 38021
end

function NFurniture:IsMagicBook()
  return self.data and self.data.staticID == 38027
end

function NFurniture:IsFireplace()
  return self.data and (self.data:GetItemType() == 902 or self.data:GetItemType() == 945)
end

function NFurniture:HaveFunction()
  local staticData = self.data and self.data.staticData
  if not staticData then
    redlog("数据还未初始化！无法判断家具是否有功能")
  end
  return staticData and #staticData.FurnitureFunction > 0
end

function NFurniture:OnClick()
  self.assetFurniture:PlayClickEffect()
end

function NFurniture:AccessStart()
  if self.animName_Access then
    self.nFurniture:PlayAction(self.animName_Access, nil, 1, 0.1)
  elseif self.isNearBy and self.animName_Idle then
    self:PlayAction(self.animName_Idle, nil, 1, 0.1)
  end
  self.isAcessing = true
end

function NFurniture:AccessOver(isSuccess, playAmimName)
  playAmimName = playAmimName or self.animName_AccessEnd
  if playAmimName then
    self.nFurniture:PlayAction(playAmimName, nil, 1, 0.1)
  end
  self.isAcessing = false
  if isSuccess then
    self:AccessSuccess()
  end
end

function NFurniture:AccessSuccess()
  local staticData = self.data and self.data.staticData
  if staticData and staticData.AccessDelay and staticData.AccessDelay > 0 then
    self.forbidAccess = true
    self:ClearLtAccess()
    self.ltAccessLimit = TimeTickManager.Me():CreateOnceDelayTick(staticData.AccessDelay * 1000, function(owner, deltaTime)
      self.ltAccessLimit = nil
      self.forbidAccess = false
    end, self)
  end
end

function NFurniture:ClearLtAccess()
  if self.ltAccessLimit then
    self.ltAccessLimit:Destroy()
    self.ltAccessLimit = nil
  end
end

function NFurniture:OnEnterEditMode()
  if self.animName_Idle then
    self:PlayAction(self.animName_Idle)
    self.isInEditMode = true
  end
  if self.rewardCell and self.rewardCell.gameObject then
    GameObject.Destroy(self.rewardCell.gameObject)
    self.rewardCell = nil
  end
  local staticData = self.data and self.data.staticData
  if staticData and staticData.AccessType == HomeManager.AccessType.IsNPC then
    self.assetFurniture:SetActive(true)
  end
end

function NFurniture:OnExitEditMode()
  self.isInEditMode = false
  local staticData = self.data and self.data.staticData
  if staticData and staticData.AccessType == HomeManager.AccessType.IsNPC then
    self.assetFurniture:SetActive(false)
  end
end

function NFurniture:UpdateSeats(seats)
  local _InteractNpcManager = Game.InteractNpcManager
  for k, v in pairs(seats) do
    if v == 0 then
      _InteractNpcManager:TryDelMountInter(self.id, k)
    end
  end
  for k, v in pairs(seats) do
    if v ~= 0 then
      if self.extraInteract ~= nil then
        local charId = self.extraInteract:GetCharid(k)
        if charId ~= nil then
          self.extraInteract:GetOff(charId)
          if BackwardCompatibilityUtil.CompatibilityMode_V36 then
            local creture = self.extraInteract:GetCreature(charId)
            if creture then
              creture.assetRole:SetForceColliderEnable(nil)
            end
          end
        end
      end
      _InteractNpcManager:AddMountInter(self.id, k, v)
    end
  end
end

local FramePhotoWidth = 822
local FramePhotoHeight = 462
local FramePhotoAspect = FramePhotoWidth / FramePhotoHeight
local tempVector3 = LuaVector3.Zero()

function NFurniture:UpdatePhoto(texture)
  local renderer = self.gameObject.transform:GetComponentsInChildren(Renderer)[2]
  if not renderer then
    return
  end
  self.data.photo.loaded = true
  if texture then
    renderer.material = Game.Prefab_ScenePhoto.sharedMaterial
    renderer.material.mainTexture = texture
  else
    renderer.material = Game.Prefab_ScenePhoto.sharedMaterial
    renderer.material.mainTexture = nil
    LuaVector3.Better_Set(tempVector3, 0, 0, 1)
    renderer.transform.localScale = tempVector3
    return
  end
  tempVector3:Set(LuaGameObject.GetLocalEulerAngles(renderer.transform))
  local frameAspect = FramePhotoAspect
  local scaleX = 1
  local scaleY = 1
  renderer.transform.localEulerAngles = tempVector3
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalScale(renderer.transform))
  local aspect = texture.width / texture.height
  if frameAspect > aspect then
    tempVector3[1] = scaleX
    tempVector3[2] = scaleY * (frameAspect / aspect)
    renderer.material:SetFloat("_CutX", 0)
    renderer.material:SetFloat("_CutY", (1 - aspect / frameAspect) * 0.5)
  else
    tempVector3[1] = scaleX * (aspect / frameAspect)
    tempVector3[2] = scaleY
    renderer.material:SetFloat("_CutX", (1 - frameAspect / aspect) * 0.5)
    renderer.material:SetFloat("_CutY", 0)
  end
  renderer.transform.localScale = tempVector3
end

function NFurniture:ShowReward()
  if not self.rewardCell then
    self.rewardCell = self.assetFurniture:CreateReward(self)
    self.data = HomeProxy.Instance:GetFurnitureData(self.id, self.staticID)
    if self.data then
      self.rewardCell:SetData(self.data)
    end
  end
  if not self.rewardCell.trans then
    return
  end
  local pos = self:GetPosition()
  self.rewardCell.trans.position = LuaGeometry.GetTempVector3(pos[1] - 0.5, pos[2] + 1.6, pos[3])
end

function NFurniture:ClearReward()
  if self.rewardCell == nil then
    return
  end
  self.assetFurniture:ClearReward()
  self.rewardCell = nil
end

function NFurniture:PlayAction(name, defaultName, speed, crossFadeNormalizedDuration, force)
  defaultName = defaultName or self.animName_Idle
  self.assetFurniture:PlayAction_Simple(name, defaultName, speed, crossFadeNormalizedDuration, force)
end

function NFurniture:PlayActionByID(actionid, force)
  if actionid == nil then
    return false
  end
  local actionInfo = Table_ActionAnime[actionid]
  if actionInfo == nil then
    return false
  end
  self:PlayAction(actionInfo.Name, nil, nil, nil, force)
  return true
end

function NFurniture:Update(time, deltaTime)
  if not self.gameObject then
    return
  end
  if self:IsFireplace() and HomeManager.Me():IsAtMyselfHome() and not self.isInEditMode then
    local houseData = HomeProxy.Instance:GetCurHouseData()
    if houseData then
      if houseData:GetCanReward() and self.data:GetItemType() == 902 then
        self:ShowReward()
      elseif self.data:GetItemType() == 945 and houseData:isHasDiningTableFood() then
        self:ShowReward()
      else
        self:ClearReward()
      end
    end
  end
  if not self.needUpdate or self.forbidAccess then
    return
  end
  local myPos, playerPos = self:GetPosition(), Game.Myself:GetPosition()
  local distance = LuaVector3.Distance_Square(myPos, playerPos)
  local isMoved = self.lastDistance and self.lastDistance ~= distance
  self.lastDistance = distance
  if self.isAcessing then
    if isMoved then
      self.isAcessing = false
    end
    return
  end
  local isCurNearBy = distance < self.nearByDistanceSquare
  if isCurNearBy then
    myPos:Sub(playerPos)
    isCurNearBy = LuaVector3.Angle(myPos, self.trans.forward) < 60
  end
  if self.isNearBy then
    if not isCurNearBy then
      self.isNearBy = false
      self:PlayAction(self.animName_Idle, nil, 1, 0.1)
    end
  elseif isCurNearBy then
    self.isNearBy = true
    self:PlayAction(self.animName_NearBy, nil, 1, 0.1)
  end
end

function NFurniture:Destroy(delayDestroy)
  self:ClearLtAccess()
  if self.extraInteract and self.extraInteract:Alive() then
    self.extraInteract:Destroy()
  end
  self.extraInteract = nil
  Game.InteractNpcManager:UnregisterInteractFurniture(self.id)
  self.assetFurniture:Destroy(delayDestroy)
  if self:IsPlaced() then
    GameFacade.Instance:sendNotification(HomeEvent.RemoveFurniture, {
      self.id,
      self.tag
    })
    EventManager.Me():DispatchEvent(HomeEvent.RemoveFurniture, {
      self.id,
      self.tag
    })
  end
  self.isAlive = false
  self.inited = false
end
