local mt1 = {__autoNewTable = true}

function mt1.__index(t, k)
  local nt = {}
  setmetatable(nt, mt1)
  rawset(t, k, nt)
  return t[k]
end

local mt = {}

function mt.__index(t, k)
  rawset(t, k, function()
    local nt = {}
    setmetatable(nt, mt1)
    return nt
  end)
  return t[k]
end

if AchieveCmd_pb then
  setmetatable(AchieveCmd_pb, mt)
end
if ActivityCmd_pb then
  setmetatable(ActivityCmd_pb, mt)
end
if ActivityEvent_pb then
  setmetatable(ActivityEvent_pb, mt)
end
if AstrolabeCmd_pb then
  setmetatable(AstrolabeCmd_pb, mt)
end
if AuctionCCmd_pb then
  setmetatable(AuctionCCmd_pb, mt)
end
if Authorize_pb then
  setmetatable(Authorize_pb, mt)
end
if BattlePass_pb then
  setmetatable(BattlePass_pb, mt)
end
if BossCmd_pb then
  setmetatable(BossCmd_pb, mt)
end
if CarrierCmd_pb then
  setmetatable(CarrierCmd_pb, mt)
end
if ChatCmd_pb then
  setmetatable(ChatCmd_pb, mt)
end
if ClientPrivateChatIO_pb then
  setmetatable(ClientPrivateChatIO_pb, mt)
end
if descriptor_pb then
  setmetatable(descriptor_pb, mt)
end
if Dojo_pb then
  setmetatable(Dojo_pb, mt)
end
if ErrorUserCmd_pb then
  setmetatable(ErrorUserCmd_pb, mt)
end
if FuBenCmd_pb then
  setmetatable(FuBenCmd_pb, mt)
end
if GuildCmd_pb then
  setmetatable(GuildCmd_pb, mt)
end
if HomeCmd_pb then
  setmetatable(HomeCmd_pb, mt)
end
if InfiniteTower_pb then
  setmetatable(InfiniteTower_pb, mt)
end
if InteractCmd_pb then
  setmetatable(InteractCmd_pb, mt)
end
if LoginUserCmd_pb then
  setmetatable(LoginUserCmd_pb, mt)
end
if MatchCCmd_pb then
  setmetatable(MatchCCmd_pb, mt)
end
if OverseasTaiwanCmd_pb then
  setmetatable(OverseasTaiwanCmd_pb, mt)
end
if PhotoCmd_pb then
  setmetatable(PhotoCmd_pb, mt)
end
if ProtoCommon_pb then
  setmetatable(ProtoCommon_pb, mt)
end
if PuzzleCmd_pb then
  setmetatable(PuzzleCmd_pb, mt)
end
if PveCard_pb then
  setmetatable(PveCard_pb, mt)
end
if RecordTrade_pb then
  setmetatable(RecordTrade_pb, mt)
end
if RoguelikeCmd_pb then
  setmetatable(RoguelikeCmd_pb, mt)
end
if SceneAugury_pb then
  setmetatable(SceneAugury_pb, mt)
end
if SceneBeing_pb then
  setmetatable(SceneBeing_pb, mt)
end
if SceneChatRoom_pb then
  setmetatable(SceneChatRoom_pb, mt)
end
if SceneFood_pb then
  setmetatable(SceneFood_pb, mt)
end
if SceneInterlocution_pb then
  setmetatable(SceneInterlocution_pb, mt)
end
if SceneItem_pb then
  setmetatable(SceneItem_pb, mt)
end
if SceneManual_pb then
  setmetatable(SceneManual_pb, mt)
end
if SceneMap_pb then
  setmetatable(SceneMap_pb, mt)
end
if ScenePet_pb then
  setmetatable(ScenePet_pb, mt)
end
if SceneQuest_pb then
  setmetatable(SceneQuest_pb, mt)
end
if SceneSeal_pb then
  setmetatable(SceneSeal_pb, mt)
end
if SceneSkill_pb then
  setmetatable(SceneSkill_pb, mt)
end
if SceneTip_pb then
  setmetatable(SceneTip_pb, mt)
end
if SceneUser_pb then
  setmetatable(SceneUser_pb, mt)
end
if SceneUser2_pb then
  setmetatable(SceneUser2_pb, mt)
end
if SessionMail_pb then
  setmetatable(SessionMail_pb, mt)
end
if SessionShop_pb then
  setmetatable(SessionShop_pb, mt)
end
if SessionSociality_pb then
  setmetatable(SessionSociality_pb, mt)
end
if SessionTeam_pb then
  setmetatable(SessionTeam_pb, mt)
end
if SessionWeather_pb then
  setmetatable(SessionWeather_pb, mt)
end
if TeamGroupRaid_pb then
  setmetatable(TeamGroupRaid_pb, mt)
end
if TeamRaidCmd_pb then
  setmetatable(TeamRaidCmd_pb, mt)
end
if Tutor_pb then
  setmetatable(Tutor_pb, mt)
end
if UserEvent_pb then
  setmetatable(UserEvent_pb, mt)
end
if Var_pb then
  setmetatable(Var_pb, mt)
end
if WeddingCCmd_pb then
  setmetatable(WeddingCCmd_pb, mt)
end
if xCmd_pb then
  setmetatable(xCmd_pb, mt)
end
