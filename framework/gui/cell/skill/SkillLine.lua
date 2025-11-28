local baseCell = autoImport("BaseCell")
SkillLine = class("SkillLine", baseCell)
local linePath = ResourcePathHelper.UICell("SkillLine")
local vector3 = LuaVector3(0, 0, 0)

function SkillLine:ctor(parent)
  local go = Game.AssetManager_UI:CreateAsset(linePath, parent)
  SkillLine.super.ctor(self, go)
end

function SkillLine:Init()
  self.sprite = self.gameObject:GetComponent(UISprite)
end

function SkillLine:SetRotation(angle)
  LuaVector3.Better_Set(vector3, 0, 0, angle)
  self.trans.localEulerAngles = vector3
end

function SkillLine:DrawHorizontal(pos, width)
  self.trans.localPosition = pos
  self.sprite.width = width
end

function SkillLine:DrawVertical(up, pos, height)
  self:SetRotation(up and 90 or -90)
  self.trans.localPosition = pos
  self.sprite.width = height
end

function SkillLine:DrawBetween(fromPosX, fromPosY, toPosX, toPosY)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  local tmp = LuaGeometry.GetTempVector3(toPosX, toPosY, 0)
  LuaVector3.Better_Set(vector3, fromPosX, fromPosY, 0)
  self.sprite.width = VectorUtility.DistanceXY(tmp, vector3)
  local tanValue = math.atan2(tmp[2] - vector3[2], tmp[1] - vector3[1])
  self:SetRotation(math.deg(tanValue))
end

function SkillLine:DrawTurnUp(pos, width, height)
  self:CreateChild(width, height, -90)
  self:SetRotation(90)
  self:DrawHorizontal(pos, height)
end

function SkillLine:DrawTurnDown(pos, width, height)
  self:CreateChild(width, height, 90)
  self:SetRotation(-90)
  self:DrawHorizontal(pos, height)
end

function SkillLine:CreateChild(width, height, angle)
  local go = Game.AssetManager_UI:CreateAsset(linePath, self.gameObject)
  local trans = go.transform
  LuaVector3.Better_Set(vector3, height, 0, 0)
  trans.localPosition = vector3
  LuaVector3.Better_Set(vector3, 0, 0, angle)
  trans.localEulerAngles = vector3
  local sprite = go:GetComponent(UISprite)
  sprite.width = width
  local child = self.child
  if child == nil then
    child = {}
    self.child = child
  end
  child[#child + 1] = sprite
end

function SkillLine:Unlock(sortID, val)
  if self.linkState ~= val then
    self.linkState = val
    self:SetColor(self.sprite, val)
    local child = self.child
    if child ~= nil then
      for i = 1, #child do
        self:SetColor(child[i], val)
      end
    end
  end
end

function SkillLine:SetColor(sprite, val)
  if val then
    sprite.color = SkillCell.EnableLineColor
  else
    sprite.color = SkillCell.DisableLineColor
  end
end

function SkillLine:Destroy()
  if self.gameObject ~= nil then
    GameObject.Destroy(self.gameObject)
  end
end
