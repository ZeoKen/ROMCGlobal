autoImport("MidSummerDesireCell")
MidSummerRelationshipCell = class("MidSummerRelationshipCell", MidSummerDesireCell)

function MidSummerRelationshipCell:FindObjs()
  MidSummerRelationshipCell.super.FindObjs(self)
  self.relation = {}
  for i = 1, 3 do
    self.relation[i] = self:FindGO("Relation" .. i)
  end
end

function MidSummerRelationshipCell:SetData(data)
  MidSummerRelationshipCell.super.SetData(self, data)
  if not self.data then
    return
  end
  local levelCfg = self.ins:GetRelationConfig(self.ins.showingActId)
  for lv, d in pairs(levelCfg) do
    if self.relation[lv] then
      self.relation[lv]:SetActive(d[1] == data.id)
    end
  end
end

function MidSummerRelationshipCell:GetRewardDatas()
  local rewardData = MidSummerRelationshipCell.super.GetRewardDatas(self)
  TableUtility.ArrayPushBack(rewardData, "HeightRaise")
  return rewardData
end
