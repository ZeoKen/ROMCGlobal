local PlayerLevelUpCommand = class("PlayerLevelUpCommand", pm.SimpleCommand)

function PlayerLevelUpCommand:execute(note)
  local player = note.body
  if note.type == SceneUserEvent.JobLevelUp then
    player:PlayJobLevelUpEffect()
  elseif note.type == SceneUserEvent.BaseLevelUp then
    player:PlayBaseLevelUpEffect()
    player:PlayBaseLevelUpAudio()
    if player:GetCreatureType() == Creature_Type.Me then
      self:MyBaseLevelUp(player.data.userdata:Get(UDEnum.ROLELEVEL))
    end
  elseif note.type == SceneUserEvent.AppellationUp then
    player:PlayAdventureLevelUpEffect()
  end
end

function PlayerLevelUpCommand:MyBaseLevelUp(i_level)
  FunctionItemCompare.Me():TryCompare()
  local level = i_level or 0
  FunctionTyrantdb.Instance:SetLevel(level)
  if 120 <= level and level <= 140 and level % 5 == 0 then
    local evntName = "#BaseLevel_" .. level
    FunctionTyrantdb.Instance:trackEvent(evntName, nil)
  end
  if BranchMgr.IsChina() then
    return
  end
  if BranchMgr.IsJapan() and level % 10 == 0 then
    local evntName = "プレイヤーBaseレベル" .. level
    OverseaHostHelper:AFTrack(evntName)
  end
  if BranchMgr.IsTW() then
    local SDKEnable = EnvChannel.SDKEnable()
    if SDKEnable then
      local server = FunctionLogin.Me():getCurServerData()
      local serverID = server ~= nil and server.sid or 1
      OverSeas_TW.OverSeasManager.GetInstance():TrackAccount(serverID, level)
    end
    if level == 10 or level == 120 then
      local evntName = "Level_" .. level
      OverSeas_TW.OverSeasManager.GetInstance():TrackEvent(AppBundleConfig.GetAdjustByName(evntName))
    end
  end
  if (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) and level % 10 == 0 then
    local evntName = "base" .. level
    OverseaHostHelper:TXWYTrackEvent(evntName)
  end
end

return PlayerLevelUpCommand
