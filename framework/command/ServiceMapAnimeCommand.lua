ServiceMapAnimeCommand = class("ServiceMapAnimeCommand", pm.SimpleCommand)

function ServiceMapAnimeCommand:execute(note)
  if note and note.name == ServiceEvent.NUserMapAnimeUserCmd then
    self:SetPendingMapAnime(note)
  end
end

function ServiceMapAnimeCommand:SetPendingMapAnime(note)
  Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:SetPendingAnimID(note.body)
end
