HeroProfessionProxy = class("HeroProfessionProxy")
autoImport("ProfessionNewHeroTaskData")
autoImport("ProfessionNewHeroStoryData")
autoImport("ProfessionNewHeroIntroData")
autoImport("ProfessionNewHeroExtraStoryData")
autoImport("ProfessionNewHeroExtraTaskData")
HeroProfessionProxy = class("HeroProfessionProxy", pm.Proxy)
HeroProfessionProxy.Instance = nil
HeroProfessionProxy.NAME = "HeroProfessionProxy"

function HeroProfessionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HeroProfessionProxy.NAME
  if HeroProfessionProxy.Instance == nil then
    HeroProfessionProxy.Instance = self
  end
  self.heroQuests = {}
  self.heroStories = {}
  self.heroExtraStoryQuests = {}
  self.heroTaskExtra = {}
  self.heroIntros = {}
end

function HeroProfessionProxy:RemoveUnusedDatas(fromArray, accordingToArray, key, startIndex)
  if not fromArray or not accordingToArray then
    return
  end
  for i = #fromArray, startIndex or 1, -1 do
    local fromData = fromArray[i]
    local keep = false
    if fromData then
      local fromId = fromData[key]
      if keepIds and table.ContainsValue(keepIds, fromId) then
        keep = true
      else
        for _, v in ipairs(accordingToArray) do
          if v[key] == fromId then
            keep = true
            break
          end
        end
      end
    end
    if not keep then
      table.remove(fromArray, i)
    end
  end
end

function HeroProfessionProxy:QueryHeroQuests(profession)
  xdlog("CallHeroGrowthQuestInfo", profession)
  ServiceSceneUser3Proxy.Instance:CallHeroGrowthQuestInfo(profession)
end

function HeroProfessionProxy:GetHeroQuestsByProfession(profession)
  return self.heroQuests and self.heroQuests[profession] or {}
end

function HeroProfessionProxy:UpdateHeroQuests(profession, serverDatas, fullData)
  if self.heroQuests then
    self:RemoveUnusedDatas(self.heroQuests[profession], serverDatas, "id")
  end
  for i, v in ipairs(serverDatas) do
    self:AddOrUpdateHeroQuest(profession, v)
  end
  self:AddOrUpdateHeroExtraTask(profession, fullData)
end

function HeroProfessionProxy:GetHeroQuestById(id)
  if self.heroQuests then
    for _, quests in pairs(self.heroQuests) do
      for _, v in ipairs(quests) do
        if v.id == id then
          return v
        end
      end
    end
  end
end

function HeroProfessionProxy:GetHeroQuestByProfessionAndId(profession, id)
  local quests = self.heroQuests and self.heroQuests[profession]
  if quests then
    for _, v in ipairs(quests) do
      if v.id == id then
        return v
      end
    end
  end
end

function HeroProfessionProxy:AddOrUpdateHeroQuest(profession, serverData)
  if not self.heroQuests then
    self.heroQuests = {}
  end
  local quests = self.heroQuests[profession]
  if not quests then
    quests = {}
    self.heroQuests[profession] = quests
  end
  local newQuest = self:GetHeroQuestByProfessionAndId(profession, serverData.id)
  if newQuest then
    newQuest:SetServerData(serverData)
  else
    newQuest = ProfessionNewHeroTaskData.new(serverData)
    table.insert(quests, newQuest)
  end
end

function HeroProfessionProxy:QueryHeroStories(profession)
  ServiceSceneUser3Proxy.Instance:CallHeroStoryQuestInfo(profession)
end

function HeroProfessionProxy:GetHeroExtraStoryQuest(profession)
  return self.heroExtraStoryQuests and self.heroExtraStoryQuests[profession]
end

function HeroProfessionProxy:AddOrUpdateHeroExtraQuest(profession, serverData)
  if not self.heroExtraStoryQuests then
    self.heroExtraStoryQuests = {}
  end
  local extraStoryQuest = self:GetHeroExtraStoryQuest(profession)
  if extraStoryQuest then
    extraStoryQuest:SetServerData(self:GetHeroStories(profession), serverData)
  else
    extraStoryQuest = ProfessionNewHeroExtraStoryData.new(self:GetHeroStories(profession), serverData)
    self.heroExtraStoryQuests[profession] = extraStoryQuest
  end
end

function HeroProfessionProxy:GetHeroExtraTask(profession)
  return self.heroTaskExtra and self.heroTaskExtra[profession]
end

function HeroProfessionProxy:AddOrUpdateHeroExtraTask(profession, serverData)
  if not self.heroTaskExtra then
    self.heroTaskExtra = {}
  end
  local extraTask = self:GetHeroExtraTask(profession)
  if extraTask then
    extraTask:SetServerData(self:GetHeroQuestsByProfession(profession), serverData)
  else
    extraTask = ProfessionNewHeroExtraTaskData.new(self:GetHeroQuestsByProfession(profession), serverData)
    self.heroTaskExtra[profession] = extraTask
  end
end

function HeroProfessionProxy:GetHeroIntro(profession)
  if not self.heroIntros then
    self.heroIntros = {}
  end
  local intro = self.heroIntros[profession]
  if not intro then
    intro = ProfessionNewHeroIntroData.new(profession)
    self.heroIntros[profession] = intro
  end
  return intro
end

function HeroProfessionProxy:GetHeroStories(profession)
  return self.heroStories and self.heroStories[profession] or {}
end

function HeroProfessionProxy:GetHeroStoryByProfessionAndID(classid, id)
  local stories = self.heroStories and self.heroStories[classid]
  if stories then
    for _, v in ipairs(stories) do
      if v.id == id then
        return v
      end
    end
  end
end

function HeroProfessionProxy:GetHeroStoryByID(id)
  for profID, stories in pairs(self.heroStories) do
    for _, v in pairs(stories) do
      if v.id == id then
        return v
      end
    end
  end
end

function HeroProfessionProxy:UpdateHeroStory(profession, serverDatas, fullData)
  if self.heroStories then
    self:RemoveUnusedDatas(self.heroStories[profession], serverDatas, "id")
  end
  for i, v in ipairs(serverDatas) do
    self:AddOrUpdateHeroStory(profession, v)
  end
  self:AddOrUpdateHeroExtraQuest(profession, fullData)
end

function HeroProfessionProxy:UpdateHeroStories(data)
  local profdatas = data.profession_data
  if profdatas and 0 < #profdatas then
    for i = 1, #profdatas do
      local profdata = profdatas[i]
      self:UpdateHeroStory(profdata.profession, profdata.story_quests, profdata)
    end
  end
end

function HeroProfessionProxy:AddOrUpdateHeroStory(profession, serverData)
  if not self.heroStories then
    self.heroStories = {}
  end
  local stories = self.heroStories[profession]
  if not stories then
    stories = {}
    self.heroStories[profession] = stories
  end
  local newStory = self:GetHeroStoryByProfessionAndId(profession, serverData.id)
  if newStory then
    newStory:SetServerData(serverData)
  else
    newStory = ProfessionNewHeroStoryData.new(serverData)
    table.insert(stories, newStory)
  end
end

function HeroProfessionProxy:GetHeroStoryByProfessionAndId(profession, id)
  local stories = self.heroStories and self.heroStories[profession]
  if stories then
    for _, v in ipairs(stories) do
      if v.id == id then
        return v
      end
    end
  end
end

function HeroProfessionProxy:GetHeroStoryById(id)
  if self.heroStories then
    for _, stories in pairs(self.heroStories) do
      for _, v in ipairs(stories) do
        if v.id == id then
          return v
        end
      end
    end
  end
end

function HeroProfessionProxy:UnlockStory(id)
  ServiceSceneUser3Proxy.Instance:CallHeroStoryQuestAccept(id)
end

function HeroProfessionProxy:HandleUnlockStoryResp(resp)
  if resp.success then
    local story = self:GetHeroStoryById(resp.id)
    if story then
      story:UnlockByServer()
    end
  end
end

function HeroProfessionProxy:TakeHeroQuestReward(id, profession, complete_num, typ)
  ServiceSceneUser3Proxy.Instance:CallHeroQuestReward(id, profession, complete_num, typ)
end

function HeroProfessionProxy:HandleHeroQuestRewardResp(resp)
  if resp.success then
    if resp.type == SceneUser3_pb.HEROQUESTREWARDTYPE_STORY then
      local storyData = self:GetHeroStoryById(resp.id)
      if storyData then
        storyData:OnRewarded()
      end
    elseif resp.type == SceneUser3_pb.HEROQUESTREWARDTYPE_STORY_EXTRA then
      local extraStoryQuest = self:GetHeroExtraStoryQuest(resp.profession)
      if extraStoryQuest then
        extraStoryQuest:OnRewarded()
      end
    elseif resp.type == SceneUser3_pb.HEROQUESTREWARDTYPE_GROWTH then
      local questData = self:GetHeroQuestById(resp.id)
      if questData then
        questData:OnRewarded()
      end
    elseif resp.type == SceneUser3_pb.HEROQUESTREWARDTYPE_GROWTH_EXTRA then
      xdlog("成长任务额外奖励 领取反馈")
      local extraTask = self:GetHeroExtraTask(resp.profession)
      if extraTask then
        extraTask:OnRewarded()
      end
    end
  end
end

function HeroProfessionProxy:isCommonBranchTaskValid(typeBranch)
  if not self.validBranches then
    self.validBranches = {}
    for k, v in pairs(Table_HeroGrowthQuest) do
      local branch = v.Branch
      if branch and not self.validBranches[branch] then
        self.validBranches[branch] = 1
      end
    end
  end
  if self.validBranches[typeBranch] then
    return true
  end
  return false
end
