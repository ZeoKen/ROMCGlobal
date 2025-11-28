UserData = reusableClass("UserData")
UserData.PoolSize = 100
if NetConfig.PBC then
  autoImport("ProtoCommon")
else
  autoImport("ProtoCommon_pb")
end
local TableClear = TableUtility.TableClear
if UserData.CacheEUSERkey == nil then
  UserData.CacheEUSERkey = {}
end

function UserData.GetKey(attribute)
  local key = UserData.CacheEUSERkey[attribute]
  if key == nil then
    key = ProtoCommon_pb["EUSERDATATYPE_" .. attribute]
    UserData.CacheEUSERkey[attribute] = key
  end
  return key
end

local GetKey = UserData.GetKey

function UserData:ctor()
  UserData.super.ctor(self)
  self.hasDirtyDatas = false
  self.datas = {}
  self.bytes = {}
  self.dirtyIDs = {}
  self.noEnterPackItems = {}
end

function UserData:Reset()
  self.hasDirtyDatas = false
  TableClear(self.dirtyIDs)
  TableClear(self.datas)
  TableClear(self.bytes)
end

function UserData:GetById(id)
  return self.datas[id]
end

function UserData:Get(attribute)
  return self.datas[GetKey(attribute)]
end

function UserData:GetBytes(attribute)
  return self.bytes[GetKey(attribute)]
end

function UserData:GetNoEnterPackItemNum(itemId)
  return self.noEnterPackItems[itemId]
end

function UserData:Set(attribute, value, bytes)
  local id = GetKey(attribute)
  self:SetByID(id, value, bytes)
end

function UserData:SetByID(id, value, bytes)
  if id == ProtoCommon_pb.EUSERDATATYPE_NO_ENTER_PACK_ITEM or id == ProtoCommon_pb.EUSERDATATYPE_ACC_NO_ENTER_PACK_ITEM then
    self.noEnterPackItems[tonumber(bytes)] = value
  end
  self.datas[id] = value
  self.bytes[id] = bytes
end

function UserData:Update(attribute, value, bytes)
  local id = GetKey(attribute)
  self:UpdateByID(id, value, bytes)
end

function UserData:DirtyUpdateByID(id, value, bytes)
  local old = self.datas[id]
  if old ~= value then
    self.datas[id] = value
    if self.dirtyIDs[id] == nil then
      self.dirtyIDs[id] = old or value
    end
    self.hasDirtyDatas = true
  end
end

function UserData:UpdateByID(id, value, bytes)
  if id == 53 then
    printRed("Update Follow :" .. tostring(value))
  end
  local old
  if id == ProtoCommon_pb.EUSERDATATYPE_NO_ENTER_PACK_ITEM or id == ProtoCommon_pb.EUSERDATATYPE_ACC_NO_ENTER_PACK_ITEM then
    local n_id = tonumber(bytes)
    old = self.noEnterPackItems[n_id]
    self.noEnterPackItems[n_id] = value
  else
    old = self.datas[id]
  end
  self.datas[id] = value
  self.bytes[id] = bytes
  return old
end

function UserData:DoConstruct(asArray, parts)
end

function UserData:DoDeconstruct(asArray)
  self:Reset()
end

UDEnum = {
  NAME = "NAME",
  ADDICT = "ADDICT",
  AGIPOINT = "AGIPOINT",
  BODY = "BODY",
  DEXPOINT = "DEXPOINT",
  HAIR = "HAIR",
  EYE = "EYE",
  MOUNT = "MOUNT",
  MOUTH = "MOUTH",
  INTPOINT = "INTPOINT",
  JOBEXP = "JOBEXP",
  JOBLEVEL = "JOBLEVEL",
  LUKPOINT = "LUKPOINT",
  MAPID = "MAPID",
  MAX = "MAX",
  MIN = "MIN",
  OFFLINETIME = "OFFLINETIME",
  ONLINETIME = "ONLINETIME",
  PACKAGE = "PACKAGE",
  PROFESSION = "PROFESSION",
  LEFTHAND = "LEFTHAND",
  RIGHTHAND = "RIGHTHAND",
  ROLEEXP = "ROLEEXP",
  ROLELEVEL = "ROLELEVEL",
  MONSTER_LEVEL = "MONSTER_LEVEL",
  SEX = "SEX",
  STRPOINT = "STRPOINT",
  TOTALPOINT = "TOTALPOINT",
  USERDATA = "USERDATA",
  VITPOINT = "VITPOINT",
  DIAMOND = "DIAMOND",
  SILVER = "SILVER",
  GOLD = "GOLD",
  GARDEN = "GARDEN",
  MORA = "MORA",
  LABORATORY = "LABORATORY",
  SKILL_POINT = "SKILL_POINT",
  NORMAL_SKILL = "NORMAL_SKILL",
  COLLECT_SKILL = "COLLECT_SKILL",
  TRANS_SKILL = "TRANS_SKILL",
  STATUS = "STATUS",
  DESTPROFESSION = "DESTPROFESSION",
  BODYSCALE = "BODYSCALE",
  EQUIPMASTER = "EQUIPMASTER",
  REFINEMASTER = "REFINEMASTER",
  HAIRCOLOR = "HAIRCOLOR",
  EYECOLOR = "EYECOLOR",
  CLOTHCOLOR = "CLOTHCOLOR",
  PORTRAIT = "PORTRAIT",
  FRAME = "FRAME",
  HEAD = "HEAD",
  FACE = "FACE",
  BACK = "BACK",
  TAIL = "TAIL",
  BATTLEPOINT = "BATTLEPOINT",
  RAIDID = "RAIDID",
  PET_PARTNER = "PET_PARTNER",
  ANGLE = "ANGLE",
  FOLLOWID = "FOLLOWID",
  SAVEMAP = "SAVEMAP",
  CREATETIME = "CREATETIME",
  MUSIC_CURID = "MUSIC_CURID",
  MUSIC_START = "MUSIC_START",
  MUSIC_LOOP = "MUSIC_LOOP",
  MUSIC_DEMAND = "MUSIC_DEMAND",
  GIFTPOINT = "GIFTPOINT",
  KILLERNAME = "KILLERNAME",
  DROPBASEEXP = "DROPBASEEXP",
  HANDID = "HANDID",
  TWINS_ACTIONID = "TWINS_ACTIONID",
  HASCHARGE = "HASCHARGE",
  QUERYTYPE = "QUERYTYPE",
  TREESTATUS = "TREESTATUS",
  ZONEID = "ZONEID",
  REAL_ZONEID = "REAL_ZONEID",
  FRIENDSHIP = "FRIENDSHIP",
  ALPHA = "ALPHA",
  QUOTA = "QUOTA",
  QUOTA_LOCK = "QUOTA_LOCK",
  PVP_COLOR = "PVP_COLOR",
  NORMALSKILL_OPTION = "NORMALSKILL_OPTION",
  CONTRIBUTE = "CONTRIBUTE",
  BIND_CONTRIBUTE = "BIND_CONTRIBUTE",
  PVPCOIN = "PVPCOIN",
  LOTTERY = "LOTTERY",
  BCAT_DIAMOND = "BCAT_DIAMOND",
  FREELOTTERY = "FREE_LOTTERY",
  TUTOR_PROFIC = "TUTOR_PROFIC",
  PEAK_EFFECT = "PEAK_EFFECT",
  COOKER_EXP = "COOKER_EXP",
  COOKER_LV = "COOKER_LV",
  TASTER_EXP = "TASTER_EXP",
  TASTER_LV = "TASTER_LV",
  SATIETY = "SATIETY",
  OPTION = "OPTION",
  GUILDHONOR = "GUILDHONOR",
  EQUIP_OFF = "EQUIP_OFF",
  EQUIP_BREAK = "EQUIP_BREAK",
  CUR_MAXJOB = "CUR_MAXJOB",
  PROFESSION_MAXJOB = "PROFESSION_MAXJOB",
  JOY = "JOY",
  MARITAL = "MARITAL",
  QUERYWEDDINGTYPE = "QUERYWEDDINGTYPE",
  DIVORCE_ROLLERCOASTER = "DIVORCE_ROLLERCOASTER",
  EQUIPED_WEAPON = "EQUIPED_WEAPON",
  SERVANTID = "SERVANTID",
  FAVORABILITY = "FAVORABILITY",
  BOOTH_SCORE = "BOOTH_SCORE",
  DRESSUP = "DRESSUP",
  SELLDISCOUNT = "SELLDISCOUNT",
  DEADCOIN = "DEADCOIN",
  DEADLV = "DEADLV",
  DEADEXP = "DEADEXP",
  TALENT_POINT = "TALENT_SKILLPOINT",
  TOTAL_MEDALCOUNT = "TOTAL_MEDALCOUNT",
  TEAMPVP_COIN = "TEAMPVP_COIN",
  EXPRAID_SCORE = "EXPRAID_SCORE",
  EXPRAID_SCORE_RAID = "EXPRAID_SCORE_RAID",
  COURAGE = "COURAGE",
  BEING_COUNT = "BEING_COUNT",
  HOME_ROOMID = "HOME_ROOMID",
  PORTRAIT_FRAME = "PORTRAIT_FRAME",
  BACKGROUND = "BACKGROUND",
  HEADWEAR_COINA = "HEADWEAR_COINA",
  HEADWEAR_COINB = "HEADWEAR_COINB",
  BATTLEPASS_LV = "BATTLEPASS_LV",
  BATTLEPASS_EXP = "BATTLEPASS_EXP",
  BATTLEPASS_COIN = "BATTLEPASS_COIN",
  BATTLEPASS_MAXEXP = "BATTLEPASS_MAXEXP",
  SAND = "SAND",
  ROLELEVEL_MAX = "ROLELEVEL_MAX",
  MONSTER_PORTRAIT = "MONSTER_PORTRAIT",
  NIGHTMARE = "NIGHTMARE",
  WEAPONPET_EXP = "WEAPONPET_EXP",
  HEAD_TEXT = "HEAD_TEXT",
  NPC_DIALOG = "NPC_DIALOG",
  LUCKY_DICE = "LUCKY_DICE",
  MYSELF_FASHION_HIDE = "MYSELF_FASHION_HIDE",
  TWELVEPVP_COIN = "TWELVEPVP_COIN",
  TWELVEPVP_CAMP = "TWELVEPVP_CAMP",
  GUILD_SCORE = "GUILD_SCORE",
  MULTIMOUNT_OPT = "MULTIMOUNT_OPT",
  RIDING_CHARID = "RIDING_CHARID",
  RIDING_POS = "RIDING_POS",
  GAGTIME = "GAGTIME",
  AFK_FUNCTIME = "AFK_FUNCTIME",
  NOVICE_TARGET_POINT = "NOVICE_TARGET_POINT",
  CHAIN_ACTIVE = "CHAIN_ACTIVE",
  ZENY_DEBT = "ZENY_DEBT",
  BOX_PUSHLIMIT = "BOX_PUSHLIMIT",
  BOX_FEATURE = "BOX_FEATURE",
  ISVEER = "ISVEER",
  SHOWNAME = "SHOWNAME",
  EQUIP_POWER = "EQUIP_POWER",
  XDIR = "XDIR",
  HIDEOTHER = "HIDEOTHER",
  PERCEPT_ABILITY = "PERCEPT_ABILITY",
  NOVICE_BP_EXP = "NOVICE_BP_EXP",
  RETURN_BP_EXP = "RETURN_BP_EXP",
  CHAT_FRAME = "CHAT_FRAME",
  SERVANT_CHALLENGE_EXP = "SERVANT_CHALLENGE_EXP",
  CHALLENGE_TOWER_LAYER = "CHALLENGE_TOWER_LAYER",
  RIDE_REFORM = "RIDE_REFORM",
  AUTOSELL = "AUTOSELL",
  SHIELD_HP = "SHIELD_HP",
  SHIELD_MAXHP = "SHIELD_MAXHP",
  RESISTANCE_VALUE = "RESISTANCE_VALUE",
  RESISTANCE_SPEED = "RESISTANCE_SPEED",
  ATTRIBUTE_VALUE = "ATTRIBUTE_VALUE",
  ATTRIBUTE_SPEED = "ATTRIBUTE_SPEED",
  MOUNT_FASHION = "MOUNT_FASHION",
  BALANCE_VALUE = "BALANCE_VALUE",
  BALANCE_STATE = "BALANCE_STATE",
  PRESTIGE_LEVEL = "PRESTIGE_LEVEL",
  NO_ENTER_PACK_ITEM = "NO_ENTER_PACK_ITEM",
  APPEARANCE_ANIMATION = "APPEARANCE_ANIMATION",
  RIDING_NPC = "RIDING_NPC",
  SHIELD = "SHIELD",
  UP_CHARID = "UP_CHARID",
  DOWN_CHARID = "DOWN_CHARID",
  RIDE_PIPPI_NOMOVE = "RIDE_PIPPI_NOMOVE",
  ACC_NO_ENTER_PACK_ITEM = "ACC_NO_ENTER_PACK_ITEM",
  PVP_CAMP = "PVP_CAMP",
  ANONYMOUS = "HIDE_NAME",
  EXCELLECT = "EXCELLECT",
  BLACK_MUCK = "BLACK_MUCK",
  RAID_LAYER = "RAID_LAYER",
  MOUNT_ROLE = "MOUNT_ROLE",
  RECALL_TIME = "RECALL_TIME",
  DAM_REDUCE_TYPE = "DAM_REDUCE_TYPE"
}
