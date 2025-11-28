SkillLineCombine = class("SkillLineCombine", SkillLine)
local linePath = ResourcePathHelper.UICell("SkillLine")
local vector3 = LuaVector3(0, 0, 0)

function SkillLineCombine:Init()
  self.map = {}
  SkillLineCombine.super.Init(self)
end

function SkillLineCombine:AddLine(sortID, width, height)
  local line = self.map[sortID]
  if line ~= nil then
    line:Destroy()
  end
  if height == 0 then
    line = self:CreateLine(width)
  elseif 0 < height then
    line = self:CreateTurnUp(width, height)
  elseif height < 0 then
    line = self:CreateTurnDown(width, math.abs(height))
  end
  self.map[sortID] = line
end

function SkillLineCombine:CreateLine(width)
  local line = SkillLine.new(self.gameObject)
  vector3[1] = width
  line:DrawHorizontal(vector3, width)
  return line
end

function SkillLineCombine:CreateTurnUp(width, height)
  local line = SkillLine.new(self.gameObject)
  vector3[1] = width
  line:DrawTurnUp(vector3, width, height)
  return line
end

function SkillLineCombine:CreateTurnDown(width, height)
  local line = SkillLine.new(self.gameObject)
  vector3[1] = width
  line:DrawTurnDown(vector3, width, height)
  return line
end

function SkillLineCombine:Unlock(sortID, val)
  local map = self.map
  local line = map[sortID]
  if line ~= nil then
    line:Unlock(sortID, val)
  end
  local state = false
  for k, v in pairs(map) do
    if v.linkState then
      state = true
      break
    end
  end
  SkillLineCombine.super.Unlock(self, sortID, state)
end

function SkillLineCombine:Destroy()
  local map = self.map
  for k, v in pairs(map) do
    v:Destroy()
    map[k] = nil
  end
  SkillLineCombine.super.Destroy(self)
end
