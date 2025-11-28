AECommunityData = class("AECommunityData")

function AECommunityData:ctor(data)
  self:SetData(data)
end

function AECommunityData:SetData(data)
  if data ~= nil then
    self.order = order
    local infos = data.infos
    if infos and 0 < #infos then
      local langInfo = {}
      for i = 1, #infos do
        local info = infos[i]
        langInfo[info.language] = {
          name = info.name,
          desc = info.desc,
          url = info.url,
          photourl = info.photourl
        }
      end
      self.langInfo = langInfo
    end
    local rewards = data.rewards
    if rewards and 0 < #rewards then
      local rewardList = {}
      for i = 1, #rewards do
        local tempData = {
          id = rewards[i].id,
          num = rewards[i].count
        }
        table.insert(rewardList, tempData)
      end
      self.rewards = rewardList
    end
  end
end

function AECommunityData:SetTime(event)
  self.beginTime = event.begintime
  self.endTime = event.endtime
  self.id = event.id
end
