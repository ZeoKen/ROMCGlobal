QuestMini1Point = class("QuestMini1Point", BaseCell)
local markEffectId = "WorldMissionIight_quan"
local resultTEffectId = "WorldMissionIight_good"
local resultFEffectId = "WorldMissionIight_bad"

function QuestMini1Point:Init()
  self.ring = self:FindComponent("ring", UISprite)
  self.stepName = self:FindComponent("step", UILabel)
end

function QuestMini1Point:SetTimeOut(val)
  self.ring.fillAmount = val
  self.ring.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 360 * val)
end

function QuestMini1Point:SetText(text)
  self.stepName.text = text
end

function QuestMini1Point:SetEffectContainer(go)
  self.effectContainer = go
end

function QuestMini1Point:PlayMarkEffect(show)
  if show then
    if self.markEffect then
      self.markEffect:SetActive(true)
    else
      self:PlayUIEffect(markEffectId, self.gameObject, false, function(go, args, assetEffect)
        self.markEffect = assetEffect
        local childtrans = go.transform:GetChild(0)
        if childtrans then
          childtrans.transform.localPosition = LuaGeometry.Const_V3_zero
        end
      end)
    end
  elseif self.markEffect then
    self.markEffect:SetActive(false)
  end
end

function QuestMini1Point:PlayResultEffect(result)
  self:PlayUIEffect(result and resultTEffectId or resultFEffectId, self.effectContainer, true, function(go, args, assetEffect)
    self.resultEffect = assetEffect
    go.transform.localPosition = self.gameObject.transform.localPosition
  end)
  local se = result and "UI/LinkRune2" or "Common/AnswerWrong"
  self:PlayUISound(se)
end

function QuestMini1Point:DestroyEffects()
  if self.markEffect and self.markEffect:Alive() then
    self.markEffect:Destroy()
  end
  if self.resultEffect and self.resultEffect:Alive() then
    self.resultEffect:Destroy()
  end
  self.markEffect = nil
  self.resultEffect = nil
end
