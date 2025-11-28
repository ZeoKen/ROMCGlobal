PrestigeData = class("PrestigeData")

function PrestigeData:ctor(staticData)
  if staticData then
    self.campid = staticData.id
    self.staticData = staticData
    self.levelExpMap = {}
    self.level = 1
    self.exp = 0
    self.maxLevel = 0
    self.giftItems = {}
    self.display = {}
  end
end

function PrestigeData:UpdateData(serverdata)
  self.level = serverdata.level
  self.exp = serverdata.exp
  self:ParseDisplayData()
end

function PrestigeData:SetLevelExpStaticData(level, staticData)
  self.levelExpMap[level] = staticData
  if level > self.maxLevel then
    self.maxLevel = level
  end
end

function PrestigeData:IsGraduate()
  if self.maxLevel < 1 then
    LogUtility.Error(string.format("id:%s have no prestige level data!", tostring(self.campid)))
    return false
  end
  return self.level >= self.maxLevel
end

function PrestigeData:GetMaxExpToNextLevel()
  local expData = self.levelExpMap[self.level + 1]
  return expData and expData.NeedPre or 1
end

function PrestigeData:SetGiftItems(itemid, value)
  if self.giftItems then
    if not self.giftItems[itemid] then
      self.giftItems[itemid] = {}
    end
    self.giftItems[itemid] = value
  end
end

function PrestigeData:GetGiftItems()
  return self.giftItems
end

function PrestigeData:GetCurrentLevelExpData()
  if self.level then
    return self.levelExpMap[self.level]
  end
end

function PrestigeData:GetNextLevelExpData()
  if self.level then
    if self.maxLevel <= self.level then
      return self.levelExpMap[self.maxLevel]
    end
    return self.levelExpMap[self.level + 1]
  end
end

local menuid

function PrestigeData:CheckCampOpen()
  if self.staticData then
    menuid = self.staticData.MenuID
    if menuid and FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
      return true
    end
  end
  return false
end

function PrestigeData:ParseDisplayData()
  if self.levelExpMap then
    for kLevel, vStaticData in pairs(self.levelExpMap) do
      if vStaticData.NPCDisplay then
        if not self.display[kLevel] then
          self.display[kLevel] = {}
        end
        local display = vStaticData.NPCDisplay
        local dLen = #display
        for i = 1, dLen do
          local npcid = display[i].npcid
          if npcid then
            if not self.display[kLevel][npcid] then
              self.display[kLevel][npcid] = {}
            end
            local entry = {}
            entry.emoji = display[i].emoji
            entry.actionname = Table_ActionAnime[display[i].actionname] and Table_ActionAnime[display[i].actionname].Name
            entry.dialog = display[i].PreDialog
            self.display[kLevel][npcid] = entry
          end
        end
      end
    end
  end
end

function PrestigeData:GetCurrentDisplayByNPC(npcid)
  return self.level and self.display[self.level] and self.display[self.level][npcid]
end
