WayPointerUtil = class("WayPointerUtil")
local screenWidth = Screen.width
local screenHeight = Screen.height
local uiWidth = 20.0
local uiHeight = 20.0
local waypointRadiusRatio = 0.6
local waypointRadius, screenRatio, minX, maxX, minY, maxY
local screenSpaceOffsetX = 0
local screenSpaceOffsetY = 0
local antiVibrationRadius = 200.0

function CalcWayPointerRadius()
  waypointRadius = screenWidth / 2.0 * waypointRadiusRatio
end

function CalcBorders()
  minX = uiWidth / 2.0
  maxX = screenWidth - minX
  minY = uiHeight / 2.0
  maxY = screenHeight - minY
  screenRatio = screenWidth / screenHeight
  CalcWayPointerRadius()
end

CalcBorders()

function WayPointerUtil.SetAntiVibrationRadius(radius)
  antiVibrationRadius = radius or 200.0
end

function WayPointerUtil.SetWayPointRadiusRatio(ratio)
  waypointRadiusRatio = ratio
  CalcWayPointerRadius()
end

function WayPointerUtil.SetScreenSize(width, height)
  screenWidth = width
  screenHeight = height
  CalcBorders()
end

function WayPointerUtil.SetUISize(width, height)
  uiWidth = width
  uiHeight = height
  CalcBorders()
end

function WayPointerUtil.SetScreenSpaceOffset(offsetX, offsetY)
  screenSpaceOffsetX = offsetX or 0
  screenSpaceOffsetY = offsetY or 0
end

local tempVec2, newUIPos

function WayPointerUtil.CalcWayPointerParams(camera, fromPositionWS, targetPositionWS, antiVibration)
  tempVec2 = tempVec2 or LuaVector2.Zero()
  newUIPos = newUIPos or LuaVector3.Zero()
  local fromPositionSS = camera:WorldToScreenPoint(fromPositionWS)
  local targetPositionSS = camera:WorldToScreenPoint(targetPositionWS)
  local fromPosSSX = fromPositionSS[1]
  local fromPosSSY = fromPositionSS[2]
  local fromPosSSZ = fromPositionSS[3]
  if antiVibration then
    fromPosSSX = screenWidth / 2.0
    fromPosSSY = screenHeight / 2.0
  end
  local targetPosSSX = targetPositionSS[1]
  local targetPosSSY = targetPositionSS[2]
  local targetPosSSZ = targetPositionSS[3]
  local angleZ = 0
  local isOffScreen = false
  newUIPos[1] = targetPosSSX
  newUIPos[2] = targetPosSSY
  if targetPosSSZ < 0 or targetPosSSX < minX or targetPosSSX > maxX or targetPosSSY < minY or targetPosSSY > maxY then
    isOffScreen = true
    local dx = targetPosSSX - fromPosSSX
    local dy = targetPosSSY - fromPosSSY
    angleZ = math.deg(math.atan2(dy, dx)) + 90.0
    if targetPosSSZ < 0 then
      angleZ = angleZ + (180.0 < angleZ and -180.0 or 180.0)
    end
    tempVec2[1] = dx
    tempVec2[2] = dy * screenRatio
    tempVec2 = LuaVector2.Normalized(tempVec2)
    tempVec2 = tempVec2 * waypointRadius
    tempVec2[2] = tempVec2[2] / screenRatio
    if targetPosSSZ < 0 then
      tempVec2 = -tempVec2
    end
    newUIPos[1] = fromPosSSX + tempVec2[1]
    newUIPos[2] = fromPosSSY + tempVec2[2]
  else
    newUIPos[1] = newUIPos[1] + screenSpaceOffsetX
    newUIPos[2] = newUIPos[2] + screenSpaceOffsetY
  end
  return newUIPos, angleZ, isOffScreen
end

function WayPointerUtil.CalcWayPointerParamsForNGUI(mainCamera, uiCamera, fromPositionWS, targetPositionWS, antiVibration)
  local newUIPos, angleZ, isOffScreen = WayPointerUtil.CalcWayPointerParams(mainCamera, fromPositionWS, targetPositionWS, antiVibration)
  local nguiPosWS = uiCamera:ScreenToWorldPoint(newUIPos)
  return nguiPosWS, angleZ, isOffScreen
end
