QuestMini1StillPoint = class("QuestMini1StillPoint", BaseCell)

function QuestMini1StillPoint.Create(parent)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("QuestMini1StillPoint"), parent)
  return QuestMini1StillPoint.new(go)
end

local EffectOffsetDir = -1
local EffectOriginOffset = 0.8
QuestMini1StillPoint.ClickBackground = "ClickBackground"

function QuestMini1StillPoint:Init()
  self.ring = self:FindComponent("ring", UISprite)
  self.stepName = self:FindComponent("step", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self:AddClickEvent(self.effectContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local bord = self:FindGO("Bord")
  self:AddClickEvent(bord, function()
    self:PassEvent(QuestMini1StillPoint.ClickBackground, self)
  end)
  self.effect = self:PlayUIEffect(EffectMap.UI.QuestMini1StillPoint_EffectID, self.effectContainer, false, function(asset)
    if not asset then
      return
    end
    local mr = self:FindComponent("xdzck_fx_pattern_006_mt", MeshRenderer)
    if mr then
      self.optMat = mr.materials[1]
      if self.offsetVal then
        self.optMat:SetTextureOffset("_MainTex", LuaGeometry.GetTempVector2(self.offsetVal, 0))
      else
        self.optMat:SetTextureOffset("_MainTex", LuaGeometry.GetTempVector2(EffectOriginOffset, 0))
      end
    end
  end)
end

function QuestMini1StillPoint:SetProgress(nowCount, fullCount)
  self.offsetVal = EffectOriginOffset + EffectOffsetDir * (nowCount / fullCount) * 10
  if self.optMat then
    self.optMat:SetTextureOffset("_MainTex", LuaGeometry.GetTempVector2(self.offsetVal, 0))
  end
  if nowCount and 0 < nowCount then
    self:PlayUIEffect(EffectMap.UI.QuestMini1StillPoint_EffectOnce, self.effectContainer, true)
  end
end

function QuestMini1StillPoint:Destroy()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.markEffect then
    self.markEffect:Destroy()
    self.markEffect = nil
  end
end

function QuestMini1StillPoint:SetPos(x, y, z)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, y, z)
end

function QuestMini1StillPoint:SetTimeOut(val)
  self.ring.fillAmount = val
  self.ring.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 360 * val)
end

function QuestMini1StillPoint:PlayMarkEffect(show)
end

function QuestMini1StillPoint:PlayResultEffect(result)
  self:PlayUIEffect(result and EffectMap.UI.QuestMini1StillPoint_ResultTEffectID or EffectMap.UI.QuestMini1StillPoint_ResultFEffectID, self.effectContainer, true)
  AudioUtility.PlayOneShot2D_Path(result and "UI/LinkRune2" or "Common/AnswerWrong")
  if self.markEffect then
    self.markEffect:SetActive(false)
  end
  if self.effect then
    self.effect:SetActive(false)
  end
  self.ring.gameObject:SetActive(false)
end
