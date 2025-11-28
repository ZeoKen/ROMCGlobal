local baseCell = autoImport("BaseCell")
QuestTraceSymbolCell = reusableClass("QuestTraceSymbolCell", baseCell)

function QuestTraceSymbolCell:Init()
  self:FindObjs()
end

function QuestTraceSymbolCell:FindObjs()
  self.root = self:FindGO("QuestTraceContainer").transform
  self.distanceLabel = self:FindGO("Distance"):GetComponent(UILabel)
  self.distanceLabelTrans = self.distanceLabel.transform
end

function QuestTraceSymbolCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  local myPos = Game.Myself:GetPosition()
  local targetPos = data.pos
  if myPos == nil or targetPos == nil then
    self.gameObject:SetActive(false)
    return
  end
  local distance = VectorUtility.DistanceXZ(myPos, targetPos)
  local rangeLimit = data.range
  if distance <= rangeLimit then
    self.gameObject:SetActive(false)
    return
  end
  local mainCamera = Game.GameObjectManagers[Game.GameObjectType.Camera]:GetCamera(GOManager_Camera.CameraID.MainCamera)
  if mainCamera == nil then
    return
  end
  local uiCamera = UIManagerProxy.Instance.uiCamera
  if uiCamera == nil then
    return
  end
  self.gameObject:SetActive(true)
  local fromPos = LuaGeometry.GetTempVector3(myPos[1], myPos[2] + 1.3, myPos[3])
  local pos, angleZ, isOffScreen = WayPointerUtil.CalcWayPointerParamsForNGUI(mainCamera, uiCamera, fromPos, targetPos, true)
  self.gameObject.transform.position = pos
  if self.rootAngleZ == nil or 1 < self.rootAngleZ - angleZ or 1 < angleZ - self.rootAngleZ then
    self.rootAngleZ = angleZ
    self.root.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, angleZ)
    self.distanceLabelTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
  end
  if self.distanceNum == nil or 1 < self.distanceNum - distance or 1 < distance - self.distanceNum then
    self.distanceNum = distance
    self.distanceLabel.text = string.format("%dm", distance)
  end
end
