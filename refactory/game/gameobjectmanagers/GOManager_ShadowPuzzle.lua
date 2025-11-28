GOManager_ShadowPuzzle = class("GOManager_ShadowPuzzle")

function GOManager_ShadowPuzzle:ctor()
end

function GOManager_ShadowPuzzle:RegisterGameObject(obj)
  local system = obj.gameObject:GetComponent(ShadowPuzzleSystem)
  Debug_AssertFormat(nil ~= system, "RegisterShadowPuzzle({0}) can't find ShadowPuzzleSystem. Error RaidID {1}", obj, raidId)
  self.curPuzzleSystem = system
  self.curPuzzleSystem:HideLightEffect()
  return true
end

function GOManager_ShadowPuzzle:UnregisterGameObject(obj)
  self.curPuzzleSystem = nil
  return true
end

function GOManager_ShadowPuzzle:GetShadowPuzzle()
  return self.curPuzzleSystem
end
