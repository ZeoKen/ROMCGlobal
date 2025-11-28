TweenUtility = class("TweenUtility")
local m_tmpVector3 = LuaVector3(0, 0, 0)

function TweenUtility.BeginIceMove(gameObject, tarPosition, startSpeed, endSpeed, precision)
  local distance = LuaVector3.Distance(LuaGeometry.TempGetPosition(gameObject.transform, m_tmpVector3), tarPosition)
  local totalTime = distance / ((startSpeed + endSpeed) / 2)
  local tweener = TweenPosition.Begin(gameObject, totalTime, tarPosition)
  local animationCurve = tweener.animationCurve
  local deltaSpeed = startSpeed - endSpeed
  precision = precision or 0.2
  for i = precision, totalTime - precision, precision do
    animationCurve:AddKey(i / totalTime, math.min((startSpeed + (startSpeed - i / totalTime * deltaSpeed)) / 2 * i / distance, 1))
  end
  return tweener
end
