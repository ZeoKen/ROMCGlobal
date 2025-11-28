PlayerTeamInfoCommand = class("PlayerTeamInfoCommand", pm.SimpleCommand)

function PlayerTeamInfoCommand:execute(note)
  FunctionTeamInvite.Me():HandleQueryUserTeamInfo(note.body)
end
