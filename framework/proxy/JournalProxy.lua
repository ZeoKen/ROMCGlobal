JournalProxy = class("JournalProxy", pm.Proxy)
JournalProxy.Instance = nil
JournalProxy.NAME = "JournalProxy"

function JournalProxy:ctor(proxyName, data)
  self.proxyName = proxyName or JournalProxy.NAME
  if not JournalProxy.Instance then
    JournalProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self.journalMap = {}
end

function JournalProxy:UpdateJournalId(journalId)
  self.currentJournalId = journalId
end

function JournalProxy:UpdateJournalData(data)
  local journal = self.journalMap[data.global_activity_id]
  if not journal then
    journal = {}
    self.journalMap[data.global_activity_id] = journal
  end
  journal.isUnlocked = data.is_cover_unlock
  journal.rewardState = data.reward_state
  if data.last_pos then
    journal.lastPos = {}
    journal.lastPos.chapter_id = data.last_pos.chapter_id
    journal.lastPos.page_id = data.last_pos.page_id
  end
  if not journal.chapters then
    journal.chapters = {}
  end
  if Game.Config_ActivityJournal and Game.Config_ActivityJournal[data.global_activity_id] then
    local chapterCount = #Game.Config_ActivityJournal[data.global_activity_id]
    for chapterId, pageIndexes in ipairs(Game.Config_ActivityJournal[data.global_activity_id]) do
      local chapterData = journal.chapters[chapterId]
      if not chapterData then
        chapterData = {}
        journal.chapters[chapterId] = chapterData
        if Table_ActivityJournal[pageIndexes[1]] then
          chapterData.startTime = Table_ActivityJournal[pageIndexes[1]].StartTime
          chapterData.endTime = Table_ActivityJournal[pageIndexes[1]].EndTime
          chapterData.startTimeStr = Table_ActivityJournal[pageIndexes[1]].StartTimeStr
          chapterData.endTimeStr = Table_ActivityJournal[pageIndexes[1]].EndTimeStr
          chapterData.autoUnlockTimeStr = Table_ActivityJournal[pageIndexes[1]].AutoUnlockTimeStr
        end
      end
      chapterData.pages = {}
      local pageCount = #pageIndexes
      local chapter
      if data.chapters then
        chapter = TableUtil:GetValue(data.chapters, function(v)
          return v.chapter_id == chapterId
        end)
      end
      for _, index in ipairs(pageIndexes) do
        local pageId = Table_ActivityJournal[index] and Table_ActivityJournal[index].Page
        local page = {}
        page.id = pageId
        page.index = index
        page.isComplete = false
        page.isNew = false
        page.isLastPage = chapterId == chapterCount and pageId == pageCount
        page.progress = 0
        if chapter and pageId <= chapter.complete_page_progress then
          page.isComplete = true
        end
        chapterData.pages[pageId] = page
      end
      if chapter then
        for _, id in ipairs(chapter.unreaded_page_ids) do
          local page = chapterData.pages[id]
          if page then
            page.isNew = true
          end
        end
        for _, pageData in ipairs(chapter.page_quests) do
          local page = chapterData.pages[pageData.page_id]
          if page then
            page.progress = pageData.times
          end
        end
      end
    end
  end
end

function JournalProxy:UnlockJournal(data)
  local journal = self.journalMap[data.global_activity_id]
  if journal then
    journal.isUnlocked = true
  end
end

function JournalProxy:UpdateJournalRewardState(data)
  local journal = self.journalMap[data.global_activity_id]
  if journal then
    journal.rewardState = NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_RECEIVED
  end
end

function JournalProxy:GetJournalData(journalId)
  return self.journalMap[journalId]
end

function JournalProxy:IsJournalUnlock(journalId)
  if self.journalMap[journalId] then
    return self.journalMap[journalId].isUnlocked
  end
end

function JournalProxy:GetJournalRewardState(journalId)
  local journal = self.journalMap[journalId]
  local state = NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_NOT_AVAILABLE
  if journal then
    state = journal.rewardState
  end
  return state
end

function JournalProxy:GetPageByChapterIdAndPageId(journalId, chapterId, pageId)
  if self.journalMap[journalId] and self.journalMap[journalId].chapters then
    local chapter = self.journalMap[journalId].chapters[chapterId]
    if chapter then
      return TableUtil:GetValue(chapter.pages, function(v)
        return v.id == pageId
      end)
    end
  end
end

function JournalProxy:GetDefaultChapterAndPageId(journalId)
  local journal = self.journalMap[journalId]
  if not journal then
    return
  end
  local chapters = journal.chapters
  if journal.rewardState == NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_REWARD_STATE_AVAILABLE then
    local chapterCount = #chapters
    local lastChapter = chapters[chapterCount]
    return chapterCount, #lastChapter.pages
  end
  for chapterId, chapter in ipairs(chapters) do
    for _, page in ipairs(chapter.pages) do
      if page.isComplete and page.isNew then
        return chapterId, page.id
      end
    end
  end
  local lastPos = journal.lastPos
  if lastPos and lastPos.chapter_id > 0 and 0 < lastPos.page_id then
    return lastPos.chapter_id, lastPos.page_id
  end
  return 1, 1
end

function JournalProxy:GetPageCountByChapterId(journalId, chapterId)
  local journal = self.journalMap[journalId]
  local count = 0
  if journal then
    local chapter = journal.chapters[chapterId]
    if chapter then
      count = #chapter.pages
      for _, page in ipairs(chapter.pages) do
        if not page.isComplete then
          count = page.id
          break
        end
      end
    end
  end
  return count
end

function JournalProxy:GetChapterCount(journalId)
  local journal = self.journalMap[journalId]
  if journal then
    return #journal.chapters
  end
  return 0
end

function JournalProxy:GetChapterState(journalId, chapterId)
  local state = NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_DISABLE
  local journal = self.journalMap[journalId]
  if journal then
    local chapter = journal.chapters[chapterId]
    if chapter and chapter.startTime and chapter.endTime then
      local serverTime = ServerTime.CurServerTime() * 0.001
      if serverTime >= chapter.startTime and serverTime <= chapter.endTime then
        state = NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_OPEN
      elseif serverTime > chapter.endTime then
        state = NoviceNotebook_pb.NOVICE_NOTEBOOK_CHAPTER_TAG_STATE_CLOSE
      end
    end
  end
  return state
end

function JournalProxy:GetChapterTimeStr(journalId, chapterId)
  local startTimeStr = ""
  local endTimeStr = ""
  local journal = self.journalMap[journalId]
  if journal then
    local chapter = journal.chapters[chapterId]
    if chapter then
      startTimeStr = chapter.startTimeStr
      endTimeStr = chapter.endTimeStr
    end
  end
  return startTimeStr, endTimeStr
end

function JournalProxy:GetFirstNewPageByChapterId(journalId, chapterId)
  local journal = self.journalMap[journalId]
  if journal then
    local chapter = journal.chapters[chapterId]
    for _, page in ipairs(chapter.pages) do
      if page.isNew then
        return page.id
      end
    end
  end
end

function JournalProxy:GetAutoUnlockTimeStr(journalId, chapterId)
  local journal = self.journalMap[journalId]
  if journal then
    local chapter = journal.chapters[chapterId]
    return chapter.autoUnlockTimeStr
  end
end
