local static_robot_key = {"KickMember"}
local static_cat_key = {
  "ShowDetail",
  "KickMember",
  "InviteCatJoinHand",
  "CancelCatJoinHand",
  "FireHireman",
  "ReHireCat",
  "ChangeCat"
}
local static_common_func_key = {
  "SendMessage",
  "ShowDetail",
  "AddFriend",
  "DeleteFriend",
  "InviteMember",
  "InviteEnterGuild",
  "ApplyEnterGuild",
  "Tipoff",
  "AddBlacklist",
  "ShowGUID",
  "Double_Action",
  "GuildMercenaryInvite",
  "GuildMercenaryApply",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local static_last_version_common_func_key = {
  "FollowMember",
  "CancelFollowMember",
  "InviteJoinHand",
  "CancelJoinHand",
  "SetLeader",
  "SetGroupLeader",
  "KickMember",
  "DistributeArtifact",
  "VoteOut"
}
local _result_key = {}
local _ArrayClear = TableUtility.ArrayClear
local _InsertArray = TableUtil.InsertArray
PlayerTipFactory = class("PlayerTipFactory")
PlayerTipFactory.BokiFunckeys = {
  "Boki_Detail",
  "Boki_Follow",
  "Boki_CancelFollow",
  "Boki_ResetPos"
}
PlayerTipFactory.ServantFunckeys = {
  "ServantShop",
  "ServantHandIn",
  "ServantReset"
}
PlayerTipFactory.SkadaFunckeys = {
  "Skada_Settings",
  "Skada_Analysis"
}
PlayerTipFactory.PetFunckeys = {
  "Pet_CallBack",
  "Pet_ShowDetail",
  "Pet_AutoFight"
}
PlayerTipFactory.AllPetFunckeys = {
  "Pet_GiveGift",
  "Pet_Touch",
  "Pet_Hug",
  "Pet_CancelHug",
  "Pet_CallBack",
  "Pet_ShowDetail",
  "Pet_AutoFight"
}

function PlayerTipFactory.Me()
  if nil == PlayerTipFactory.me then
    PlayerTipFactory.me = PlayerTipFactory.new()
  end
  return PlayerTipFactory.me
end

function PlayerTipFactory:ctor()
  self.factoryMap = {}
  self.factoryMap[TeamMemberType.Human] = self.GetPlayerFunckey
  self.factoryMap[TeamMemberType.Robot] = self.GetRobotFunckey
  self.factoryMap[TeamMemberType.HireCat] = self.GetHireCatFunckey
  self.playerFuncKey = {}
  _InsertArray(self.playerFuncKey, static_common_func_key)
  _InsertArray(self.playerFuncKey, static_last_version_common_func_key)
end

function PlayerTipFactory:GetHireCatFunckey(ptdata)
  _ArrayClear(_result_key)
  for i = 1, #static_cat_key do
    local state, otherName, isCancel = FunctionPlayerTip.Me():CheckTipFuncStateByKey(static_cat_key[i], ptdata)
    if state ~= PlayerTipFuncState.InActive then
      _result_key[#_result_key + 1] = static_cat_key[i]
    end
  end
  return _result_key
end

function PlayerTipFactory:GetPlayerFunckey(ptdata, common)
  _ArrayClear(_result_key)
  local array = common == true and static_common_func_key or self.playerFuncKey
  for i = 1, #array do
    local state, otherName, isCancel = FunctionPlayerTip.Me():CheckTipFuncStateByKey(array[i], ptdata)
    if state ~= PlayerTipFuncState.InActive then
      _result_key[#_result_key + 1] = array[i]
    end
  end
  return _result_key
end

function PlayerTipFactory:GetTeamMemberFunckey(md)
  if not md then
    return
  end
  local type = md.memberType
  local call = type and self.factoryMap[type]
  if call then
    local ptdata = PlayerTipData.new()
    ptdata:SetByTeamMemberData(md)
    return call(self, ptdata)
  end
  return nil
end

function PlayerTipFactory:GetRobotFunckey()
  return static_robot_key
end

function PlayerTipFactory.CommonFunckey()
  return static_common_func_key
end
