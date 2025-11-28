HomePhonographManager = class("HomePhonographManager")
local musicFadeDuration = 0.2
local phonographStaticType = 916

function HomePhonographManager:ctor()
  self.musicStaticDatas = Table_MusicBox
  self.phonographIds = {}
  EventManager.Me():AddEventListener(HomeEvent.AddFurniture, self.OnAddFurniture, self)
  EventManager.Me():AddEventListener(HomeEvent.RemoveFurniture, self.OnRemoveFurniture, self)
end

function HomePhonographManager:OnAddFurniture(note)
  self:TryAddPhonograph(note.data)
end

function HomePhonographManager:OnRemoveFurniture(note)
  self:TryRemovePhonograph(note.data and note.data[1])
end

function HomePhonographManager:Launch()
end

function HomePhonographManager:Shutdown()
  self:StopPhonographMusic()
  TableUtility.ArrayClear(self.phonographIds)
end

function HomePhonographManager:ExitEditMode()
  if self.nowPlayingMusicStartTime then
    self:PlayPhonographsAction(2001)
  end
end

function HomePhonographManager:Update(deltaTime)
  if #self.phonographIds > 0 then
    if not self.musicUpdateTime then
      self.musicUpdateTime = 0
    end
    self.musicUpdateTime = self.musicUpdateTime + deltaTime
    if self.musicUpdateTime > 1 then
      self:_PhonographUpdate()
      self.musicUpdateTime = 0
    end
  end
end

function HomePhonographManager:TryAddPhonograph(nFurniture)
  if not self:CheckIsPhonograph(nFurniture) then
    return
  end
  TableUtility.ArrayPushBack(self.phonographIds, nFurniture.id)
  if not self.phonographQueryTick then
    self.phonographQueryTick = TimeTickManager.Me():CreateTick(60000, 60000, self._PhonographQueryTickUpdate, self, 1)
  end
end

function HomePhonographManager:TryRemovePhonograph(nFurnitureId)
  if not nFurnitureId then
    return
  end
  local removed = TableUtility.ArrayRemove(self.phonographIds, nFurnitureId) > 0
  if removed and #self.phonographIds < 1 then
    self:StopPhonographMusic()
  end
end

function HomePhonographManager:StopPhonographMusic()
  FunctionBGMCmd.Me():StopJukeBox(musicFadeDuration, 0)
  self.musicUpdateTime = nil
  self.nowPlayingMusicStartTime = nil
  self:PlayPhonographsAction()
  TimeTickManager.Me():ClearTick(self, 1)
  self.phonographQueryTick = nil
end

function HomePhonographManager:_PhonographUpdate()
  if #self.phonographIds < 1 then
    return
  end
  local soundList = HomeProxy.Instance.curSoundList
  if not soundList or not next(soundList) then
    if self.nowPlayingMusicStartTime then
      self:StopPhonographMusic()
    end
    return
  end
  local soundData, soundData1, staticData, pastTime
  local nowTime = ServerTime.CurServerTime() / 1000
  for i = 1, #soundList do
    soundData = soundList[i]
    soundData1 = soundList[i + 1]
    staticData = self.musicStaticDatas[soundData.musicid]
    if staticData and nowTime >= soundData.starttime and (not soundData1 or nowTime < soundData1.starttime) and self.nowPlayingMusicStartTime ~= soundData.starttime then
      pastTime = math.max(0, math.floor(nowTime - soundData.starttime))
      if pastTime < staticData.MusicTim then
        self:_PlayMusic(soundData.musicid, soundData.starttime, pastTime)
      end
      break
    end
  end
  HomeProxy.Instance:RemoveOutOfDateSounds(nowTime)
end

function HomePhonographManager:_PlayMusic(musicId, startTime, pastTime)
  helplog("Play Furniture Music", musicId, startTime, pastTime)
  local path = self.musicStaticDatas[musicId] and self.musicStaticDatas[musicId].MusicAd
  if not path then
    LogUtility.ErrorFormat("Cannot play music with musicId = {0}", musicId)
    return
  end
  FunctionBGMCmd.Me():PlayJukeBox(path, pastTime, nil, nil, musicFadeDuration, musicFadeDuration, musicFadeDuration, 0)
  self.nowPlayingMusicStartTime = startTime
  self:PlayPhonographsAction(2001)
  HomeProxy.Instance:PassSoundListUpdateEvent()
end

function HomePhonographManager:_PhonographQueryTickUpdate(interval)
  local phonographs = self:GetPhonographs()
  if #phonographs <= 0 then
    return
  end
  if not phonographs[1].data then
    return
  end
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_RADIO_QUERY, phonographs[1].data.id)
end

function HomePhonographManager:PlayPhonographsAction(stateId)
  stateId = stateId or 1001
  local actionName = "state" .. tostring(stateId)
  local phonographs = self:GetPhonographs()
  for _, phonograph in pairs(phonographs) do
    phonograph:PlayAction(actionName)
  end
end

function HomePhonographManager:CheckIsPhonograph(nFurniture)
  if not nFurniture or not nFurniture.data then
    return false
  end
  return nFurniture.data:GetItemType() == phonographStaticType
end

function HomePhonographManager:GetPhonographs()
  return HomeManager.Me():GetFurnituresByStaticType(phonographStaticType)
end
