local maxLv = 100
autoImport("GemPageAttributeCell")
GemPageSecretLandCell = class("GemPageSecretLandCell", GemPageAttributeCell)

function GemPageSecretLandCell:Init()
  GemPageSecretLandCell.super.Init(self)
  self.gemType = SceneItem_pb.EGEMTYPE_SECRETLAND
end

function GemPageSecretLandCell:SetData(data)
  GemPageSecretLandCell.super.SetData(self, data)
  if PvpProxy.Instance:IsFreeFire() and data and data.secretLandDatas then
    self.data.secretLandDatas.lv = maxLv
  end
  self:UpdateLevel()
end

function GemPageSecretLandCell:UpdateLevel()
  if not self.levelLabel then
    return
  end
  local data = self.data and self.data.secretLandDatas
  self.levelLabel.gameObject:SetActive(data ~= nil)
  if data then
    self.levelLabel.text = data.lv
  end
end

function GemPageSecretLandCell:UpdateFrame()
end

function GemPageSecretLandCell:UpdateAvailability()
  self:SetAvailable(true)
end

function GemPageSecretLandCell:CheckIsDataValid(data)
  return GemProxy.CheckContainsGemSecretLandData(data)
end

function GemPageSecretLandCell:TryEmbed(newData)
  GemProxy.CallEmbed(SceneItem_pb.EGEMTYPE_SECRETLAND, newData.id, self.id)
end

function GemPageSecretLandCell:TryRemoveSelf()
  if not self.data then
    return
  end
  GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_SECRETLAND, self.data.id)
end

function GemPageSecretLandCell:TryRemoveIncoming(data)
  if GemProxy.CheckContainsGemSecretLandData(data) then
    GemProxy.CallRemove(SceneItem_pb.EGEMTYPE_SECRETLAND, data.id)
  end
end

function GemPageSecretLandCell:GetEmbedSuccessEffectId()
  return EffectMap.UI.GemSkillEmbed
end

function GemPageSecretLandCell:GetSkillValidEffectId()
  return EffectMap.UI.GemSkillSkillValid
end

function GemPageSecretLandCell.AttributeGemTypePredicate(k, v, needType)
  return v.type == needType
end
