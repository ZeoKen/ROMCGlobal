QuestMini1Line = class("QuestMini1Line", BaseCell)
local tailEffectId = "WorldMissionIight_quan02"

function QuestMini1Line:Init()
  self.progresss = self:FindComponent("Line", UISlider)
  self.bline = self:FindComponent("BG", UISprite)
  self.fline = self:FindComponent("FG", UISprite)
  self.mark = self:FindComponent("Mark", UISprite)
end

local tempPos = LuaVector3()
local tempVec3_1 = LuaVector3()
local tempVec3_2 = LuaVector3()

function QuestMini1Line:SetLine(pos1, pos2, id)
  self.id = id
  self.pos1 = LuaVector3.Better_Clone(pos1)
  self.pos2 = LuaVector3.Better_Clone(pos2)
  self.lerpPos = LuaVector3.Zero()
  LuaVector3.Better_Set(tempVec3_1, (pos1[1] + pos2[1]) / 2, (pos1[2] + pos2[2]) / 2, (pos1[3] + pos2[3]) / 2)
  self.progresss.gameObject.transform.localPosition = tempVec3_1
  tempVec3_2[3] = math.deg(math.atan2(pos1[2] - pos2[2], pos1[1] - pos2[1]))
  self.progresss.gameObject.transform.localEulerAngles = tempVec3_2
  LuaVector3.Better_Sub(pos1, pos2, tempVec3_1)
  local width = LuaVector3.Magnitude(tempVec3_1)
  self.bline.width = width
  self.fline.width = width - 12
  tempPos[1] = -self.fline.width / 2
  self.fline.transform.localPosition = tempPos
  self:SetProgress(0)
end

function QuestMini1Line:SetProgress(value)
  self.progresss.value = value
  LuaVector3.Better_SetPosXYZ(self.lerpPos, self.pos1[1] + (self.pos2[1] - self.pos1[1]) * value, self.pos1[2] + (self.pos2[2] - self.pos1[2]) * value, self.pos1[3] + (self.pos2[3] - self.pos1[3]) * value)
  self.mark.gameObject.transform.localPosition = self.lerpPos
  self.mark.gameObject:SetActive(0 < value and value < 1)
  if 0 < value and value < 1 then
    self:GetTailEffect(function()
      self.effect:ResetLocalPositionXYZ(self.lerpPos[1], self.lerpPos[2] - 30, self.lerpPos[3])
    end)
  elseif self.effect then
    self.effect:Stop()
  end
end

function QuestMini1Line:GetTailEffect(callBack)
  if not self.tryCreated then
    self.tryCreated = true
    self:PlayUIEffect(tailEffectId, self.gameObject, false, function(go, args, assetEffect)
      if go == nil then
        return
      end
      self.effect = assetEffect
      go.gameObject:AddComponent(ChangeRqByTex).depth = 1
      if callBack then
        callBack(assetEffect)
      end
    end)
  end
  if self.effect and callBack then
    callBack(self.effect)
  end
end

function QuestMini1Line:DestroyEffects()
  if self.effect and self.effect:Alive() then
    self.effect:Destroy()
  end
  self.effect = nil
end
