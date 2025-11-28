TeamPwsData = class("TeamPwsData")

function TeamPwsData.ParseRankData(table, serverData)
  table.name = serverData.name
  if serverData.portrait then
    local portrait = serverData.portrait
    table.portrait = portrait.portrait
    table.body = portrait.body
    table.hair = portrait.hair
    table.haircolor = portrait.haircolor
    table.gender = portrait.gender
    table.head = portrait.head
    table.face = portrait.face
    table.mouth = portrait.mouth
    table.eye = portrait.eye
    table.portrait_frame = portrait.portrait_frame
  end
  table.profession = serverData.profession
  table.rank = serverData.rank
  table.score = serverData.score
  table.erank = serverData.erank
  table.level = serverData.level
  table.guildname = serverData.guildname
  table.charid = serverData.charid
  return table
end

function TeamPwsData.ParsePrepareData(table, serverData, readyEnum)
  table.charID = serverData
  table.isReady = readyEnum or false
  return table
end

function TeamPwsData.ParseReportData(table, serverData, teamID, color)
  table.teamID = teamID
  table.teamColor = color
  table.charID = serverData.charid
  table.name = serverData.name or ""
  table.profession = serverData.profession or 1
  table.kill = serverData.killnum or 0
  table.death = serverData.dienum or 0
  table.heal = serverData.heal or 0
  table.killScore = serverData.killscore or 0
  table.ballScore = math.ceil((serverData.ballscore or 0) / 1000) + (serverData.buffscore or 0)
  table.seasonScore = serverData.seasonscore or 0
  table.hideName = serverData.hidename
  return table
end

function TeamPwsData.ParseOthelloReportData(table, serverData, teamID, color)
  table.teamID = teamID
  table.teamColor = color
  table.charID = serverData.charid
  table.name = serverData.name or ""
  table.profession = serverData.profession or 1
  table.kill = serverData.killnum or 0
  table.death = serverData.dienum or 0
  table.heal = serverData.heal or 0
  table.killScore = serverData.killscore or 0
  table.occupyscore = serverData.occupyscore or 0
  table.seasonScore = serverData.seasonscore or 0
  table.hideName = serverData.hidename
  return table
end
