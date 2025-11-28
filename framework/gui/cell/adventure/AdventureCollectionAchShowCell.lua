local baseCell = autoImport("BaseCell")
AdventureCollectionAchShowCell = class("AdventureCollectionAchShowCell", baseCell)
local ConfigValidCountTypeMap = {
  [SceneManual_pb.EMANUALTYPE_FASHION] = true,
  [SceneManual_pb.EMANUALTYPE_COLLECTION] = true,
  [SceneManual_pb.EMANUALTYPE_PET] = true,
  [SceneManual_pb.EMANUALTYPE_MOUNT] = true
}

function AdventureCollectionAchShowCell:Init()
  self.name = self:FindComponent("name", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
end

function AdventureCollectionAchShowCell:SetData(data)
  local type, count, totalCount = data.type, data.GetUnlockNum and data:GetUnlockNum(), data.totalCount
  local typeName
  if type == SceneManual_pb.EMANUALTYPE_FASHION or type == SceneManual_pb.EMANUALTYPE_COLLECTION or type == SceneManual_pb.EMANUALTYPE_TOY or type == SceneManual_pb.EMANUALTYPE_FOOD then
    for k, v in pairs(AdventureDataProxy.BriefType) do
      if v == type then
        typeName = k
        break
      end
    end
    if typeName then
      local proxy = AdventureDataProxy.Instance
      local brief = proxy["GetBriefSummary_" .. typeName](proxy)
      count, totalCount = brief.t[1], brief.t[2]
    end
  elseif type == SceneManual_pb.EMANUALTYPE_PET then
    local brief = AdventureDataProxy.Instance:GetBriefSummary_Pet()
    count, totalCount = brief.pet[1], brief.pet[2]
  elseif type == SceneManual_pb.EMANUALTYPE_MOUNT then
    local brief = AdventureDataProxy.Instance:GetBriefSummary_Pet()
    count, totalCount = brief.mount[1], brief.mount[2]
  elseif type == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    count, totalCount = AdventureAchieveProxy.Instance:getTotalAchieveProgress()
  elseif ConfigValidCountTypeMap[type] then
    totalCount = data:GetValidItemNum()
  end
  local config = GameConfig.Share.AdventureProgress[type]
  self.name.text = string.format("%s/%s", count, totalCount)
  IconManager:SetUIIcon(config and config[2] or "", self.icon)
end
