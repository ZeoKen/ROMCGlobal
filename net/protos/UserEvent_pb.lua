local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
autoImport("SceneUser_pb")
local SceneUser_pb = SceneUser_pb
autoImport("ActivityEvent_pb")
local ActivityEvent_pb = ActivityEvent_pb
autoImport("SceneItem_pb")
local SceneItem_pb = SceneItem_pb
autoImport("SessionShop_pb")
local SessionShop_pb = SessionShop_pb
autoImport("GuildCmd_pb")
local GuildCmd_pb = GuildCmd_pb
autoImport("FuBenCmd_pb")
local FuBenCmd_pb = FuBenCmd_pb
module("UserEvent_pb")
EVENTPARAM = protobuf.EnumDescriptor()
EVENTPARAM_USER_EVENT_FIRST_ACTION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ATTACK_NPC_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_NEW_TITLE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ALL_TITLE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_UPDATE_RANDOM_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_BUFF_DAMAGE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHARGE_NTF_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHARGE_QUERY_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_DEPOSIT_CARD_INFO_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_DEL_TRANSFORM_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_INVITECAT_FAIL_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_NPC_FUNCTION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SYSTEM_STRING_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_HAND_CAT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHANGE_TITLE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_CHARGE_CNT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_NTF_MONTHCARD_END_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_LOVELETTER_USE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_ACTIVITY_CNT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_UPDATE_ACTIVITY_CNT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GET_RECALL_SHARE_REWARD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_NTF_VERSION_CARD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_WAIT_RELIVE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_RESETTIME_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_INOUT_ACT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MAIL_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_LEVELUP_DEAD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_AUTOBATTLE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ACTIVITY_MAP_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ACTIVITY_POINT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_THEME_DETAILS_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_FAVORITE_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_UPDATE_FAVORITE_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ACTION_FAVORITE_FRIEND_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SOUND_STORY_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHARGE_ACC_CNT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_BIFROST_CONTRIBUTE_ITEM_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CAMERA_ACTION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_ROBOT_OFFBATTLE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHARGE_SDK_REQUEST_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CHARGE_SDK_REPLY_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CLIENT_AI_SYNC_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CLIENT_AI_UPDATE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GIFTCODE_EXCHANGE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_HIDE_OTHER_APPEARANCE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_NTF_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_BUY_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_ACTIVE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MULTI_CUTSCENE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_POLICY_UPDATE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_POLICY_AGREE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SHOW_SCENE_OBJECT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_DOUBLE_ACTION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_BEGIN_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_STOP_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_TOMAP_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_ENDMAP_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_BUILD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_MONITOR_STOP_RET_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_CONFIG_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_NPCWALK_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SET_PROFILE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SYNC_FATE_RELATION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_FATE_RELATION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GVG_OPT_STATUE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_TIMELIMIT_ICON_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GUIDE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SHOW_CARD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_RMB_GIFT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_PROFILE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_GVGSANDTABLE_INFO_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_DELAY_RELIVE_METHOD_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_UI_ACTION_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_SPEEDUP_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_PLAY_CUTSCENE_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_SERVER_OPENTME_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_REQ_PERIODIC_MONSTER_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_PLAY_HOLDPET_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_DAMAGE_RESULT_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_HEARTBEAT_REQ_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_HEARTBEAT_ACH_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_QUERY_USER_REPORT_LIST_ENUM = protobuf.EnumValueDescriptor()
EVENTPARAM_USER_EVENT_USER_REPORT_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE = protobuf.EnumDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_MIN_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_SKILL_OVERFLOW_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_EXCHANGECARD_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_COMPOSECARD_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_COOKFOOD_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_FOOD_MAIL_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_MAGIC_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_RECALL_SHARE_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_DECOMPOSECARD_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_KFC_SHARE_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_RIDE_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_MIX_LOTTERY_ENUM = protobuf.EnumValueDescriptor()
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_NEW_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE = protobuf.EnumDescriptor()
ETITLETYPE_ETITLE_TYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_MANNUAL_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ORDER_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_FOODCOOKER_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_FOODTASTER_ENUM = protobuf.EnumValueDescriptor()
ETITLETYPE_ETITLE_TYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EDEPOSITSTATE = protobuf.EnumDescriptor()
EDEPOSITSTATE_EDEPOSITSTAT_NONE_ENUM = protobuf.EnumValueDescriptor()
EDEPOSITSTATE_EDEPOSITSTAT_VALID_ENUM = protobuf.EnumValueDescriptor()
EDEPOSITSTATE_EDEPOSITSTAT_INVALID_ENUM = protobuf.EnumValueDescriptor()
ESYSTEMSTRINGTYPE = protobuf.EnumDescriptor()
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MIN_ENUM = protobuf.EnumValueDescriptor()
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MEMO_ENUM = protobuf.EnumValueDescriptor()
EEVENTMAILTYPE = protobuf.EnumDescriptor()
EEVENTMAILTYPE_EEVENTMAILTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EEVENTMAILTYPE_EEVENTMAILTYPE_DELCAHR_ENUM = protobuf.EnumValueDescriptor()
EGIFTSTATE = protobuf.EnumDescriptor()
EGIFTSTATE_EGIFTSTATE_INIT_ENUM = protobuf.EnumValueDescriptor()
EGIFTSTATE_EGIFTSTATE_ACTIVE_ENUM = protobuf.EnumValueDescriptor()
EGIFTSTATE_EGIFTSTATE_REWARD_ENUM = protobuf.EnumValueDescriptor()
EGIFTSTATE_EGIFTSTATE_EXPIRE_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION = protobuf.EnumDescriptor()
ECONFIGACTION_ECONFIGACTION_MIN_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION_ECONFIGACTION_QUERY_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION_ECONFIGACTION_ADD_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION_ECONFIGACTION_MODIFY_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION_ECONFIGACTION_DELETE_ENUM = protobuf.EnumValueDescriptor()
ECONFIGACTION_ECONFIGACTION_MAX_ENUM = protobuf.EnumValueDescriptor()
EDELAYRELIVEMETHOD = protobuf.EnumDescriptor()
EDELAYRELIVEMETHOD_EDELAYRELIVE_MIN_ENUM = protobuf.EnumValueDescriptor()
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_POINT_ENUM = protobuf.EnumValueDescriptor()
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_SAFE_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE = protobuf.EnumDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_DIFF_JOB_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_SERVER_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_ITEM_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_NOT_TIRE_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_COMMON_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_RAID_ENUM = protobuf.EnumValueDescriptor()
ESPEEDUPTYPE_ESPEEDUP_TYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
FIRSTACTIONUSEREVENT = protobuf.Descriptor()
FIRSTACTIONUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
FIRSTACTIONUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD = protobuf.FieldDescriptor()
DAMAGENPCUSEREVENT = protobuf.Descriptor()
DAMAGENPCUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
DAMAGENPCUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
DAMAGENPCUSEREVENT_NPCGUID_FIELD = protobuf.FieldDescriptor()
DAMAGENPCUSEREVENT_USERID_FIELD = protobuf.FieldDescriptor()
TITLEDATA = protobuf.Descriptor()
TITLEDATA_TITLE_TYPE_FIELD = protobuf.FieldDescriptor()
TITLEDATA_ID_FIELD = protobuf.FieldDescriptor()
TITLEDATA_CREATETIME_FIELD = protobuf.FieldDescriptor()
NEWTITLE = protobuf.Descriptor()
NEWTITLE_CMD_FIELD = protobuf.FieldDescriptor()
NEWTITLE_PARAM_FIELD = protobuf.FieldDescriptor()
NEWTITLE_TITLE_DATA_FIELD = protobuf.FieldDescriptor()
NEWTITLE_CHARID_FIELD = protobuf.FieldDescriptor()
ALLTITLE = protobuf.Descriptor()
ALLTITLE_CMD_FIELD = protobuf.FieldDescriptor()
ALLTITLE_PARAM_FIELD = protobuf.FieldDescriptor()
ALLTITLE_TITLE_DATAS_FIELD = protobuf.FieldDescriptor()
UPDATERANDOMUSEREVENT = protobuf.Descriptor()
UPDATERANDOMUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
UPDATERANDOMUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD = protobuf.FieldDescriptor()
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD = protobuf.FieldDescriptor()
UPDATERANDOMUSEREVENT_RANDOMS_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT = protobuf.Descriptor()
BUFFDAMAGEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT_ETYPE_FIELD = protobuf.FieldDescriptor()
BUFFDAMAGEUSEREVENT_FROMID_FIELD = protobuf.FieldDescriptor()
CHARGENTFUSEREVENT = protobuf.Descriptor()
CHARGENTFUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CHARGENTFUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CHARGENTFUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
CHARGENTFUSEREVENT_DATAID_FIELD = protobuf.FieldDescriptor()
DEPOSITTYPEDATA = protobuf.Descriptor()
DEPOSITTYPEDATA_TYPE_FIELD = protobuf.FieldDescriptor()
DEPOSITTYPEDATA_EXPIRETIME_FIELD = protobuf.FieldDescriptor()
DEPOSITTYPEDATA_STARTTIME_FIELD = protobuf.FieldDescriptor()
DEPOSITTYPEDATA_STATE_FIELD = protobuf.FieldDescriptor()
DEPOSITTYPEDATA_INVALID_FIELD = protobuf.FieldDescriptor()
DEPOSITCARDDATA = protobuf.Descriptor()
DEPOSITCARDDATA_ITEMID_FIELD = protobuf.FieldDescriptor()
DEPOSITCARDDATA_ISUSED_FIELD = protobuf.FieldDescriptor()
CHARGEQUERYCMD = protobuf.Descriptor()
CHARGEQUERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHARGEQUERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
CHARGEQUERYCMD_DATA_ID_FIELD = protobuf.FieldDescriptor()
CHARGEQUERYCMD_RET_FIELD = protobuf.FieldDescriptor()
CHARGEQUERYCMD_CHARGED_COUNT_FIELD = protobuf.FieldDescriptor()
DEPOSITCARDINFO = protobuf.Descriptor()
DEPOSITCARDINFO_CMD_FIELD = protobuf.FieldDescriptor()
DEPOSITCARDINFO_PARAM_FIELD = protobuf.FieldDescriptor()
DEPOSITCARDINFO_CARD_DATAS_FIELD = protobuf.FieldDescriptor()
DELTRANSFORMUSEREVENT = protobuf.Descriptor()
DELTRANSFORMUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
DELTRANSFORMUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
INVITECATFAILUSEREVENT = protobuf.Descriptor()
INVITECATFAILUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
INVITECATFAILUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
TRIGNPCFUNCUSEREVENT = protobuf.Descriptor()
TRIGNPCFUNCUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
TRIGNPCFUNCUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD = protobuf.FieldDescriptor()
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD = protobuf.FieldDescriptor()
SYSTEMSTRINGUSEREVENT = protobuf.Descriptor()
SYSTEMSTRINGUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SYSTEMSTRINGUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD = protobuf.FieldDescriptor()
HANDCATUSEREVENT = protobuf.Descriptor()
HANDCATUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
HANDCATUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
HANDCATUSEREVENT_CATGUID_FIELD = protobuf.FieldDescriptor()
HANDCATUSEREVENT_BREAKUP_FIELD = protobuf.FieldDescriptor()
CHANGETITLE = protobuf.Descriptor()
CHANGETITLE_CMD_FIELD = protobuf.FieldDescriptor()
CHANGETITLE_PARAM_FIELD = protobuf.FieldDescriptor()
CHANGETITLE_TITLE_DATA_FIELD = protobuf.FieldDescriptor()
CHANGETITLE_CHARID_FIELD = protobuf.FieldDescriptor()
CHARGECNTINFO = protobuf.Descriptor()
CHARGECNTINFO_DATAID_FIELD = protobuf.FieldDescriptor()
CHARGECNTINFO_COUNT_FIELD = protobuf.FieldDescriptor()
CHARGECNTINFO_LIMIT_FIELD = protobuf.FieldDescriptor()
CHARGECNTINFO_DAILYCOUNT_FIELD = protobuf.FieldDescriptor()
QUERYCHARGECNT = protobuf.Descriptor()
QUERYCHARGECNT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYCHARGECNT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYCHARGECNT_INFO_FIELD = protobuf.FieldDescriptor()
NTFMONTHCARDEND = protobuf.Descriptor()
NTFMONTHCARDEND_CMD_FIELD = protobuf.FieldDescriptor()
NTFMONTHCARDEND_PARAM_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE = protobuf.Descriptor()
LOVELETTERUSE_CMD_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE_PARAM_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE_ITEMGUID_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE_TARGETS_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE_CONTENT_FIELD = protobuf.FieldDescriptor()
LOVELETTERUSE_TYPE_FIELD = protobuf.FieldDescriptor()
ACTIVITYCNTITEM = protobuf.Descriptor()
ACTIVITYCNTITEM_ACTIVITYID_FIELD = protobuf.FieldDescriptor()
ACTIVITYCNTITEM_COUNT_FIELD = protobuf.FieldDescriptor()
QUERYACTIVITYCNT = protobuf.Descriptor()
QUERYACTIVITYCNT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYACTIVITYCNT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYACTIVITYCNT_INFO_FIELD = protobuf.FieldDescriptor()
UPDATEACTIVITYCNT = protobuf.Descriptor()
UPDATEACTIVITYCNT_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEACTIVITYCNT_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEACTIVITYCNT_INFO_FIELD = protobuf.FieldDescriptor()
VERSIONCARDINFO = protobuf.Descriptor()
VERSIONCARDINFO_VERSION_FIELD = protobuf.FieldDescriptor()
VERSIONCARDINFO_ID1_FIELD = protobuf.FieldDescriptor()
VERSIONCARDINFO_ID2_FIELD = protobuf.FieldDescriptor()
NTFVERSIONCARDINFO = protobuf.Descriptor()
NTFVERSIONCARDINFO_CMD_FIELD = protobuf.FieldDescriptor()
NTFVERSIONCARDINFO_PARAM_FIELD = protobuf.FieldDescriptor()
NTFVERSIONCARDINFO_INFO_FIELD = protobuf.FieldDescriptor()
DIETIMECOUNTEVENTCMD = protobuf.Descriptor()
DIETIMECOUNTEVENTCMD_CMD_FIELD = protobuf.FieldDescriptor()
DIETIMECOUNTEVENTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
DIETIMECOUNTEVENTCMD_TIME_FIELD = protobuf.FieldDescriptor()
DIETIMECOUNTEVENTCMD_NAME_FIELD = protobuf.FieldDescriptor()
GETFIRSTSHAREREWARDUSEREVENT = protobuf.Descriptor()
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYRESETTIMEEVENTCMD = protobuf.Descriptor()
QUERYRESETTIMEEVENTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYRESETTIMEEVENTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD = protobuf.FieldDescriptor()
INOUTACTEVENTCMD = protobuf.Descriptor()
INOUTACTEVENTCMD_CMD_FIELD = protobuf.FieldDescriptor()
INOUTACTEVENTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INOUTACTEVENTCMD_ACTID_FIELD = protobuf.FieldDescriptor()
INOUTACTEVENTCMD_INOUT_FIELD = protobuf.FieldDescriptor()
USEREVENTMAILCMD = protobuf.Descriptor()
USEREVENTMAILCMD_CMD_FIELD = protobuf.FieldDescriptor()
USEREVENTMAILCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USEREVENTMAILCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
USEREVENTMAILCMD_PARAM32_FIELD = protobuf.FieldDescriptor()
USEREVENTMAILCMD_PARAM64_FIELD = protobuf.FieldDescriptor()
LEVELUPDEADUSEREVENT = protobuf.Descriptor()
LEVELUPDEADUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
LEVELUPDEADUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SWITCHAUTOBATTLEUSEREVENT = protobuf.Descriptor()
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD = protobuf.FieldDescriptor()
GOACTIVITYMAPUSEREVENT = protobuf.Descriptor()
GOACTIVITYMAPUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
GOACTIVITYMAPUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GOACTIVITYMAPUSEREVENT_ACTID_FIELD = protobuf.FieldDescriptor()
GOACTIVITYMAPUSEREVENT_MAPID_FIELD = protobuf.FieldDescriptor()
ACTIVITYPOINTUSEREVENT = protobuf.Descriptor()
ACTIVITYPOINTUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
ACTIVITYPOINTUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYFAVORITEFRIENDUSEREVENT = protobuf.Descriptor()
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
UPDATEFAVORITEFRIENDUSEREVENT = protobuf.Descriptor()
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD = protobuf.FieldDescriptor()
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD = protobuf.FieldDescriptor()
ACTIONFAVORITEFRIENDUSEREVENT = protobuf.Descriptor()
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD = protobuf.FieldDescriptor()
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT = protobuf.Descriptor()
SOUNDSTORYUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_ID_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_TIMES_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_REPLACE_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD = protobuf.FieldDescriptor()
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD = protobuf.FieldDescriptor()
THEMEDETAILSUSEREVENT = protobuf.Descriptor()
THEMEDETAILSUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
THEMEDETAILSUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
THEMEDETAILSUSEREVENT_TYPE_FIELD = protobuf.FieldDescriptor()
CAMERAACTIONUSEREVENT = protobuf.Descriptor()
CAMERAACTIONUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CAMERAACTIONUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CAMERAACTIONUSEREVENT_PARAMS_FIELD = protobuf.FieldDescriptor()
BIFROSTCONTRIBUTEITEMUSEREVENT = protobuf.Descriptor()
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD = protobuf.FieldDescriptor()
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD = protobuf.FieldDescriptor()
ROBOTOFFBATTLEUSEREVENT = protobuf.Descriptor()
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD = protobuf.FieldDescriptor()
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD = protobuf.FieldDescriptor()
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD = protobuf.FieldDescriptor()
QUERYACCCHARGECNTREWARD = protobuf.Descriptor()
QUERYACCCHARGECNTREWARD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYACCCHARGECNTREWARD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYACCCHARGECNTREWARD_INFOS_FIELD = protobuf.FieldDescriptor()
CHARGESDKREQUESTUSEREVENT = protobuf.Descriptor()
CHARGESDKREQUESTUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD = protobuf.FieldDescriptor()
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD = protobuf.FieldDescriptor()
CHARGESDKREPLYUSEREVENT = protobuf.Descriptor()
CHARGESDKREPLYUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CHARGESDKREPLYUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CHARGESDKREPLYUSEREVENT_DATAID_FIELD = protobuf.FieldDescriptor()
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD = protobuf.FieldDescriptor()
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD = protobuf.FieldDescriptor()
CLIENTAIDATA = protobuf.Descriptor()
CLIENTAIDATA_EVENTID_FIELD = protobuf.FieldDescriptor()
CLIENTAIDATA_PARAM32_FIELD = protobuf.FieldDescriptor()
CLIENTAIDATA_PARAM64_FIELD = protobuf.FieldDescriptor()
CLIENTAIDATA_GUID_FIELD = protobuf.FieldDescriptor()
CLIENTAISYNCUSEREVENT = protobuf.Descriptor()
CLIENTAISYNCUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CLIENTAISYNCUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CLIENTAISYNCUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
CLIENTAISYNCUSEREVENT_AIDATA_FIELD = protobuf.FieldDescriptor()
CLIENTAIUPDATEUSEREVENT = protobuf.Descriptor()
CLIENTAIUPDATEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD = protobuf.FieldDescriptor()
CLIENTAIUPDATEUSEREVENT_DEL_FIELD = protobuf.FieldDescriptor()
GIFTCODEEXCHANGEEVENT = protobuf.Descriptor()
GIFTCODEEXCHANGEEVENT_CMD_FIELD = protobuf.FieldDescriptor()
GIFTCODEEXCHANGEEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GIFTCODEEXCHANGEEVENT_CODE_FIELD = protobuf.FieldDescriptor()
SETHIDEOTHERCMD = protobuf.Descriptor()
SETHIDEOTHERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SETHIDEOTHERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SETHIDEOTHERCMD_HIDEID_FIELD = protobuf.FieldDescriptor()
GIFTINFO = protobuf.Descriptor()
GIFTINFO_ID_FIELD = protobuf.FieldDescriptor()
GIFTINFO_TIME_FIELD = protobuf.FieldDescriptor()
GIFTINFO_STATE_FIELD = protobuf.FieldDescriptor()
GIFTEVENT = protobuf.Descriptor()
GIFTEVENT_EVENT_FIELD = protobuf.FieldDescriptor()
GIFTEVENT_COUNT_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITNTFUSEREVENT = protobuf.Descriptor()
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITBUYUSEREVENT = protobuf.Descriptor()
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITACTIVEUSEREVENT = protobuf.Descriptor()
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENE = protobuf.Descriptor()
MULTICUTSCENE_ID_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENE_MAPID_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENE_QUESTID_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENE_PARAM_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENEUPDATEUSEREVENT = protobuf.Descriptor()
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD = protobuf.FieldDescriptor()
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD = protobuf.FieldDescriptor()
POLICYUPDATEUSEREVENT = protobuf.Descriptor()
POLICYUPDATEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
POLICYUPDATEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
POLICYUPDATEUSEREVENT_TAG_FIELD = protobuf.FieldDescriptor()
POLICYAGREEUSEREVENT = protobuf.Descriptor()
POLICYAGREEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
POLICYAGREEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT = protobuf.Descriptor()
SHOWSCENEOBJECT_CMD_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT_MAPID_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT_HIDE_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT_NPCID_FIELD = protobuf.FieldDescriptor()
SHOWSCENEOBJECT_OBJECTID_FIELD = protobuf.FieldDescriptor()
DOUBLEACIONEVENT = protobuf.Descriptor()
DOUBLEACIONEVENT_CMD_FIELD = protobuf.FieldDescriptor()
DOUBLEACIONEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
DOUBLEACIONEVENT_USERID_FIELD = protobuf.FieldDescriptor()
DOUBLEACIONEVENT_ACTIONID_FIELD = protobuf.FieldDescriptor()
BEGINMONITORUSEREVENT = protobuf.Descriptor()
BEGINMONITORUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
BEGINMONITORUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
BEGINMONITORUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
STOPMONITORUSEREVENT = protobuf.Descriptor()
STOPMONITORUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
STOPMONITORUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
STOPMONITORRETUSEREVENT = protobuf.Descriptor()
STOPMONITORRETUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
STOPMONITORRETUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
MONITORGOTOMAPUSEREVENT = protobuf.Descriptor()
MONITORGOTOMAPUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
MONITORGOTOMAPUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT = protobuf.Descriptor()
MONITORMAPENDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD = protobuf.FieldDescriptor()
MONITORMAPENDUSEREVENT_MAPID_FIELD = protobuf.FieldDescriptor()
MONITORBUILDUSEREVENT = protobuf.Descriptor()
MONITORBUILDUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
MONITORBUILDUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD = protobuf.FieldDescriptor()
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD = protobuf.FieldDescriptor()
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD = protobuf.FieldDescriptor()
GUIDEQUESTEVENT = protobuf.Descriptor()
GUIDEQUESTEVENT_CMD_FIELD = protobuf.FieldDescriptor()
GUIDEQUESTEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GUIDEQUESTEVENT_TARGETID_FIELD = protobuf.FieldDescriptor()
SHOWCARDEVENT = protobuf.Descriptor()
SHOWCARDEVENT_CMD_FIELD = protobuf.FieldDescriptor()
SHOWCARDEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWCARDEVENT_CARDID_FIELD = protobuf.FieldDescriptor()
GVGOPTSTATUEEVENT = protobuf.Descriptor()
GVGOPTSTATUEEVENT_CMD_FIELD = protobuf.FieldDescriptor()
GVGOPTSTATUEEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GVGOPTSTATUEEVENT_EXTERIOR_FIELD = protobuf.FieldDescriptor()
GVGOPTSTATUEEVENT_POSE_FIELD = protobuf.FieldDescriptor()
TIMELIMITICONEVENT = protobuf.Descriptor()
TIMELIMITICONEVENT_CMD_FIELD = protobuf.FieldDescriptor()
TIMELIMITICONEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD = protobuf.FieldDescriptor()
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD = protobuf.FieldDescriptor()
SHOWGIFTINFO = protobuf.Descriptor()
SHOWGIFTINFO_PRODUCT_FIELD = protobuf.FieldDescriptor()
SHOWGIFTINFO_INFO_FIELD = protobuf.FieldDescriptor()
SHOWRMBGIFTEVENT = protobuf.Descriptor()
SHOWRMBGIFTEVENT_CMD_FIELD = protobuf.FieldDescriptor()
SHOWRMBGIFTEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SHOWRMBGIFTEVENT_SHOW_FIELD = protobuf.FieldDescriptor()
CONFIGINFO = protobuf.Descriptor()
CONFIGINFO_SUCCESS_FIELD = protobuf.FieldDescriptor()
CONFIGINFO_INFO_FIELD = protobuf.FieldDescriptor()
CONFIGINFO_ERROR_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT = protobuf.Descriptor()
CONFIGACTIONUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_ACTION_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_SESSIONID_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_NAME_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_INFOS_FIELD = protobuf.FieldDescriptor()
CONFIGACTIONUSEREVENT_OVER_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT = protobuf.Descriptor()
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT_ID_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD = protobuf.FieldDescriptor()
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD = protobuf.FieldDescriptor()
SETPROFILEUSEREVENT = protobuf.Descriptor()
SETPROFILEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SETPROFILEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SETPROFILEUSEREVENT_PROFILE_FIELD = protobuf.FieldDescriptor()
QUERYFATERELATIONEVENT = protobuf.Descriptor()
QUERYFATERELATIONEVENT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYFATERELATIONEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYFATERELATIONEVENT_ID_FIELD = protobuf.FieldDescriptor()
SYNCFATERELATIONEVENT = protobuf.Descriptor()
SYNCFATERELATIONEVENT_CMD_FIELD = protobuf.FieldDescriptor()
SYNCFATERELATIONEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCFATERELATIONEVENT_FATEVAL_FIELD = protobuf.FieldDescriptor()
SYNCFATERELATIONEVENT_FATEID_FIELD = protobuf.FieldDescriptor()
QUERYPROFILEUSEREVENT = protobuf.Descriptor()
QUERYPROFILEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYPROFILEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYPROFILEUSEREVENT_CHARID_FIELD = protobuf.FieldDescriptor()
QUERYPROFILEUSEREVENT_PROFILE_FIELD = protobuf.FieldDescriptor()
SANDTABLEGUILD = protobuf.Descriptor()
SANDTABLEGUILD_GUILDID_FIELD = protobuf.FieldDescriptor()
SANDTABLEGUILD_NAME_FIELD = protobuf.FieldDescriptor()
SANDTABLEGUILD_IMAGE_FIELD = protobuf.FieldDescriptor()
POINTINFO = protobuf.Descriptor()
POINTINFO_GUILD_FIELD = protobuf.FieldDescriptor()
POINTINFO_ID_FIELD = protobuf.FieldDescriptor()
POINTINFO_HAS_OCCUPIED_FIELD = protobuf.FieldDescriptor()
POINTINFO_SCORE_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO = protobuf.Descriptor()
SANDTABLEINFO_CITY_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_METALHP_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_DEFENSENUM_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_ATTACKNUM_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_GUILD_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_STATE_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_DEFGUILD_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_POINT_INFO_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_RAIDSTATE_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_MVP_STATE_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD = protobuf.FieldDescriptor()
SANDTABLEINFO_MVP_HP_PER_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT = protobuf.Descriptor()
GVGSANDTABLEEVENT_CMD_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_PARAM_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_GVG_GROUP_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_STARTTIME_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_ENDTIME_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_INFO_FIELD = protobuf.FieldDescriptor()
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD = protobuf.FieldDescriptor()
SETRELIVEMETHODUSEREVENT = protobuf.Descriptor()
SETRELIVEMETHODUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SETRELIVEMETHODUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD = protobuf.FieldDescriptor()
UIACTIONUSEREVENT = protobuf.Descriptor()
UIACTIONUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
UIACTIONUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
UIACTIONUSEREVENT_PARAMS_FIELD = protobuf.FieldDescriptor()
PLAYCUTSCENEUSEREVENT = protobuf.Descriptor()
PLAYCUTSCENEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
PLAYCUTSCENEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD = protobuf.FieldDescriptor()
REQPERIODICMONSTERUSEREVENT = protobuf.Descriptor()
REQPERIODICMONSTERUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD = protobuf.FieldDescriptor()
PLAYHOLDPETUSEREVENT = protobuf.Descriptor()
PLAYHOLDPETUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
PLAYHOLDPETUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
PLAYHOLDPETUSEREVENT_PARAMS_FIELD = protobuf.FieldDescriptor()
USERSPEEDUPDATA = protobuf.Descriptor()
USERSPEEDUPDATA_ETYPE_FIELD = protobuf.FieldDescriptor()
USERSPEEDUPDATA_ADDPER_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT = protobuf.Descriptor()
QUERYSPEEDUPUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD = protobuf.FieldDescriptor()
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD = protobuf.FieldDescriptor()
SERVEROPENTIMEUSEREVENT = protobuf.Descriptor()
SERVEROPENTIMEUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SERVEROPENTIMEUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD = protobuf.FieldDescriptor()
DAMAGESTATDISTRI = protobuf.Descriptor()
DAMAGESTATDISTRI_DAM_VALUE_FIELD = protobuf.FieldDescriptor()
DAMAGESTATDISTRI_COUNT_FIELD = protobuf.FieldDescriptor()
SKILLDAMAGESTATUSEREVENT = protobuf.Descriptor()
SKILLDAMAGESTATUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD = protobuf.FieldDescriptor()
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD = protobuf.FieldDescriptor()
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD = protobuf.FieldDescriptor()
HEARTBEATREQUSEREVENT = protobuf.Descriptor()
HEARTBEATREQUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
HEARTBEATREQUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD = protobuf.FieldDescriptor()
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD = protobuf.FieldDescriptor()
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD = protobuf.FieldDescriptor()
HEARTBEATACKUSEREVENT = protobuf.Descriptor()
HEARTBEATACKUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
HEARTBEATACKUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD = protobuf.FieldDescriptor()
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD = protobuf.FieldDescriptor()
REPORTREASON = protobuf.Descriptor()
REPORTREASON_REASON_ID_FIELD = protobuf.FieldDescriptor()
REPORTREASON_REPORT_COUNT_FIELD = protobuf.FieldDescriptor()
REPORTREASON_DATA_FIELD = protobuf.FieldDescriptor()
USERREPORT = protobuf.Descriptor()
USERREPORT_CHARID_FIELD = protobuf.FieldDescriptor()
USERREPORT_LAST_REPORT_TIME_FIELD = protobuf.FieldDescriptor()
USERREPORT_REASONS_FIELD = protobuf.FieldDescriptor()
QUERYUSERREPORTLISTUSEREVENT = protobuf.Descriptor()
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD = protobuf.FieldDescriptor()
USERREPORTUSEREVENT = protobuf.Descriptor()
USERREPORTUSEREVENT_CMD_FIELD = protobuf.FieldDescriptor()
USERREPORTUSEREVENT_PARAM_FIELD = protobuf.FieldDescriptor()
USERREPORTUSEREVENT_REPORT_FIELD = protobuf.FieldDescriptor()
USERREPORTUSEREVENT_MSGID_FIELD = protobuf.FieldDescriptor()
EVENTPARAM_USER_EVENT_FIRST_ACTION_ENUM.name = "USER_EVENT_FIRST_ACTION"
EVENTPARAM_USER_EVENT_FIRST_ACTION_ENUM.index = 0
EVENTPARAM_USER_EVENT_FIRST_ACTION_ENUM.number = 1
EVENTPARAM_USER_EVENT_ATTACK_NPC_ENUM.name = "USER_EVENT_ATTACK_NPC"
EVENTPARAM_USER_EVENT_ATTACK_NPC_ENUM.index = 1
EVENTPARAM_USER_EVENT_ATTACK_NPC_ENUM.number = 2
EVENTPARAM_USER_EVENT_NEW_TITLE_ENUM.name = "USER_EVENT_NEW_TITLE"
EVENTPARAM_USER_EVENT_NEW_TITLE_ENUM.index = 2
EVENTPARAM_USER_EVENT_NEW_TITLE_ENUM.number = 3
EVENTPARAM_USER_EVENT_ALL_TITLE_ENUM.name = "USER_EVENT_ALL_TITLE"
EVENTPARAM_USER_EVENT_ALL_TITLE_ENUM.index = 3
EVENTPARAM_USER_EVENT_ALL_TITLE_ENUM.number = 4
EVENTPARAM_USER_EVENT_UPDATE_RANDOM_ENUM.name = "USER_EVENT_UPDATE_RANDOM"
EVENTPARAM_USER_EVENT_UPDATE_RANDOM_ENUM.index = 4
EVENTPARAM_USER_EVENT_UPDATE_RANDOM_ENUM.number = 5
EVENTPARAM_USER_EVENT_BUFF_DAMAGE_ENUM.name = "USER_EVENT_BUFF_DAMAGE"
EVENTPARAM_USER_EVENT_BUFF_DAMAGE_ENUM.index = 5
EVENTPARAM_USER_EVENT_BUFF_DAMAGE_ENUM.number = 6
EVENTPARAM_USER_EVENT_CHARGE_NTF_ENUM.name = "USER_EVENT_CHARGE_NTF"
EVENTPARAM_USER_EVENT_CHARGE_NTF_ENUM.index = 6
EVENTPARAM_USER_EVENT_CHARGE_NTF_ENUM.number = 7
EVENTPARAM_USER_EVENT_CHARGE_QUERY_ENUM.name = "USER_EVENT_CHARGE_QUERY"
EVENTPARAM_USER_EVENT_CHARGE_QUERY_ENUM.index = 7
EVENTPARAM_USER_EVENT_CHARGE_QUERY_ENUM.number = 8
EVENTPARAM_USER_EVENT_DEPOSIT_CARD_INFO_ENUM.name = "USER_EVENT_DEPOSIT_CARD_INFO"
EVENTPARAM_USER_EVENT_DEPOSIT_CARD_INFO_ENUM.index = 8
EVENTPARAM_USER_EVENT_DEPOSIT_CARD_INFO_ENUM.number = 9
EVENTPARAM_USER_EVENT_DEL_TRANSFORM_ENUM.name = "USER_EVENT_DEL_TRANSFORM"
EVENTPARAM_USER_EVENT_DEL_TRANSFORM_ENUM.index = 9
EVENTPARAM_USER_EVENT_DEL_TRANSFORM_ENUM.number = 10
EVENTPARAM_USER_EVENT_INVITECAT_FAIL_ENUM.name = "USER_EVENT_INVITECAT_FAIL"
EVENTPARAM_USER_EVENT_INVITECAT_FAIL_ENUM.index = 10
EVENTPARAM_USER_EVENT_INVITECAT_FAIL_ENUM.number = 11
EVENTPARAM_USER_EVENT_NPC_FUNCTION_ENUM.name = "USER_EVENT_NPC_FUNCTION"
EVENTPARAM_USER_EVENT_NPC_FUNCTION_ENUM.index = 11
EVENTPARAM_USER_EVENT_NPC_FUNCTION_ENUM.number = 12
EVENTPARAM_USER_EVENT_SYSTEM_STRING_ENUM.name = "USER_EVENT_SYSTEM_STRING"
EVENTPARAM_USER_EVENT_SYSTEM_STRING_ENUM.index = 12
EVENTPARAM_USER_EVENT_SYSTEM_STRING_ENUM.number = 13
EVENTPARAM_USER_EVENT_HAND_CAT_ENUM.name = "USER_EVENT_HAND_CAT"
EVENTPARAM_USER_EVENT_HAND_CAT_ENUM.index = 13
EVENTPARAM_USER_EVENT_HAND_CAT_ENUM.number = 14
EVENTPARAM_USER_EVENT_CHANGE_TITLE_ENUM.name = "USER_EVENT_CHANGE_TITLE"
EVENTPARAM_USER_EVENT_CHANGE_TITLE_ENUM.index = 14
EVENTPARAM_USER_EVENT_CHANGE_TITLE_ENUM.number = 15
EVENTPARAM_USER_EVENT_QUERY_CHARGE_CNT_ENUM.name = "USER_EVENT_QUERY_CHARGE_CNT"
EVENTPARAM_USER_EVENT_QUERY_CHARGE_CNT_ENUM.index = 15
EVENTPARAM_USER_EVENT_QUERY_CHARGE_CNT_ENUM.number = 16
EVENTPARAM_USER_EVENT_NTF_MONTHCARD_END_ENUM.name = "USER_EVENT_NTF_MONTHCARD_END"
EVENTPARAM_USER_EVENT_NTF_MONTHCARD_END_ENUM.index = 16
EVENTPARAM_USER_EVENT_NTF_MONTHCARD_END_ENUM.number = 17
EVENTPARAM_USER_EVENT_LOVELETTER_USE_ENUM.name = "USER_EVENT_LOVELETTER_USE"
EVENTPARAM_USER_EVENT_LOVELETTER_USE_ENUM.index = 17
EVENTPARAM_USER_EVENT_LOVELETTER_USE_ENUM.number = 18
EVENTPARAM_USER_EVENT_QUERY_ACTIVITY_CNT_ENUM.name = "USER_EVENT_QUERY_ACTIVITY_CNT"
EVENTPARAM_USER_EVENT_QUERY_ACTIVITY_CNT_ENUM.index = 18
EVENTPARAM_USER_EVENT_QUERY_ACTIVITY_CNT_ENUM.number = 19
EVENTPARAM_USER_EVENT_UPDATE_ACTIVITY_CNT_ENUM.name = "USER_EVENT_UPDATE_ACTIVITY_CNT"
EVENTPARAM_USER_EVENT_UPDATE_ACTIVITY_CNT_ENUM.index = 19
EVENTPARAM_USER_EVENT_UPDATE_ACTIVITY_CNT_ENUM.number = 20
EVENTPARAM_USER_EVENT_GET_RECALL_SHARE_REWARD_ENUM.name = "USER_EVENT_GET_RECALL_SHARE_REWARD"
EVENTPARAM_USER_EVENT_GET_RECALL_SHARE_REWARD_ENUM.index = 20
EVENTPARAM_USER_EVENT_GET_RECALL_SHARE_REWARD_ENUM.number = 22
EVENTPARAM_USER_EVENT_NTF_VERSION_CARD_ENUM.name = "USER_EVENT_NTF_VERSION_CARD"
EVENTPARAM_USER_EVENT_NTF_VERSION_CARD_ENUM.index = 21
EVENTPARAM_USER_EVENT_NTF_VERSION_CARD_ENUM.number = 23
EVENTPARAM_USER_EVENT_WAIT_RELIVE_ENUM.name = "USER_EVENT_WAIT_RELIVE"
EVENTPARAM_USER_EVENT_WAIT_RELIVE_ENUM.index = 22
EVENTPARAM_USER_EVENT_WAIT_RELIVE_ENUM.number = 24
EVENTPARAM_USER_EVENT_QUERY_RESETTIME_ENUM.name = "USER_EVENT_QUERY_RESETTIME"
EVENTPARAM_USER_EVENT_QUERY_RESETTIME_ENUM.index = 23
EVENTPARAM_USER_EVENT_QUERY_RESETTIME_ENUM.number = 25
EVENTPARAM_USER_EVENT_INOUT_ACT_ENUM.name = "USER_EVENT_INOUT_ACT"
EVENTPARAM_USER_EVENT_INOUT_ACT_ENUM.index = 24
EVENTPARAM_USER_EVENT_INOUT_ACT_ENUM.number = 26
EVENTPARAM_USER_EVENT_MAIL_ENUM.name = "USER_EVENT_MAIL"
EVENTPARAM_USER_EVENT_MAIL_ENUM.index = 25
EVENTPARAM_USER_EVENT_MAIL_ENUM.number = 27
EVENTPARAM_USER_EVENT_LEVELUP_DEAD_ENUM.name = "USER_EVENT_LEVELUP_DEAD"
EVENTPARAM_USER_EVENT_LEVELUP_DEAD_ENUM.index = 26
EVENTPARAM_USER_EVENT_LEVELUP_DEAD_ENUM.number = 28
EVENTPARAM_USER_EVENT_AUTOBATTLE_ENUM.name = "USER_EVENT_AUTOBATTLE"
EVENTPARAM_USER_EVENT_AUTOBATTLE_ENUM.index = 27
EVENTPARAM_USER_EVENT_AUTOBATTLE_ENUM.number = 29
EVENTPARAM_USER_EVENT_ACTIVITY_MAP_ENUM.name = "USER_EVENT_ACTIVITY_MAP"
EVENTPARAM_USER_EVENT_ACTIVITY_MAP_ENUM.index = 28
EVENTPARAM_USER_EVENT_ACTIVITY_MAP_ENUM.number = 30
EVENTPARAM_USER_EVENT_ACTIVITY_POINT_ENUM.name = "USER_EVENT_ACTIVITY_POINT"
EVENTPARAM_USER_EVENT_ACTIVITY_POINT_ENUM.index = 29
EVENTPARAM_USER_EVENT_ACTIVITY_POINT_ENUM.number = 31
EVENTPARAM_USER_EVENT_THEME_DETAILS_ENUM.name = "USER_EVENT_THEME_DETAILS"
EVENTPARAM_USER_EVENT_THEME_DETAILS_ENUM.index = 30
EVENTPARAM_USER_EVENT_THEME_DETAILS_ENUM.number = 32
EVENTPARAM_USER_EVENT_QUERY_FAVORITE_FRIEND_ENUM.name = "USER_EVENT_QUERY_FAVORITE_FRIEND"
EVENTPARAM_USER_EVENT_QUERY_FAVORITE_FRIEND_ENUM.index = 31
EVENTPARAM_USER_EVENT_QUERY_FAVORITE_FRIEND_ENUM.number = 33
EVENTPARAM_USER_EVENT_UPDATE_FAVORITE_FRIEND_ENUM.name = "USER_EVENT_UPDATE_FAVORITE_FRIEND"
EVENTPARAM_USER_EVENT_UPDATE_FAVORITE_FRIEND_ENUM.index = 32
EVENTPARAM_USER_EVENT_UPDATE_FAVORITE_FRIEND_ENUM.number = 34
EVENTPARAM_USER_EVENT_ACTION_FAVORITE_FRIEND_ENUM.name = "USER_EVENT_ACTION_FAVORITE_FRIEND"
EVENTPARAM_USER_EVENT_ACTION_FAVORITE_FRIEND_ENUM.index = 33
EVENTPARAM_USER_EVENT_ACTION_FAVORITE_FRIEND_ENUM.number = 35
EVENTPARAM_USER_EVENT_SOUND_STORY_ENUM.name = "USER_EVENT_SOUND_STORY"
EVENTPARAM_USER_EVENT_SOUND_STORY_ENUM.index = 34
EVENTPARAM_USER_EVENT_SOUND_STORY_ENUM.number = 36
EVENTPARAM_USER_EVENT_CHARGE_ACC_CNT_ENUM.name = "USER_EVENT_CHARGE_ACC_CNT"
EVENTPARAM_USER_EVENT_CHARGE_ACC_CNT_ENUM.index = 35
EVENTPARAM_USER_EVENT_CHARGE_ACC_CNT_ENUM.number = 37
EVENTPARAM_USER_EVENT_BIFROST_CONTRIBUTE_ITEM_ENUM.name = "USER_EVENT_BIFROST_CONTRIBUTE_ITEM"
EVENTPARAM_USER_EVENT_BIFROST_CONTRIBUTE_ITEM_ENUM.index = 36
EVENTPARAM_USER_EVENT_BIFROST_CONTRIBUTE_ITEM_ENUM.number = 39
EVENTPARAM_USER_EVENT_CAMERA_ACTION_ENUM.name = "USER_EVENT_CAMERA_ACTION"
EVENTPARAM_USER_EVENT_CAMERA_ACTION_ENUM.index = 37
EVENTPARAM_USER_EVENT_CAMERA_ACTION_ENUM.number = 40
EVENTPARAM_USER_EVENT_ROBOT_OFFBATTLE_ENUM.name = "USER_EVENT_ROBOT_OFFBATTLE"
EVENTPARAM_USER_EVENT_ROBOT_OFFBATTLE_ENUM.index = 38
EVENTPARAM_USER_EVENT_ROBOT_OFFBATTLE_ENUM.number = 41
EVENTPARAM_USER_EVENT_CHARGE_SDK_REQUEST_ENUM.name = "USER_EVENT_CHARGE_SDK_REQUEST"
EVENTPARAM_USER_EVENT_CHARGE_SDK_REQUEST_ENUM.index = 39
EVENTPARAM_USER_EVENT_CHARGE_SDK_REQUEST_ENUM.number = 42
EVENTPARAM_USER_EVENT_CHARGE_SDK_REPLY_ENUM.name = "USER_EVENT_CHARGE_SDK_REPLY"
EVENTPARAM_USER_EVENT_CHARGE_SDK_REPLY_ENUM.index = 40
EVENTPARAM_USER_EVENT_CHARGE_SDK_REPLY_ENUM.number = 43
EVENTPARAM_USER_EVENT_CLIENT_AI_SYNC_ENUM.name = "USER_EVENT_CLIENT_AI_SYNC"
EVENTPARAM_USER_EVENT_CLIENT_AI_SYNC_ENUM.index = 41
EVENTPARAM_USER_EVENT_CLIENT_AI_SYNC_ENUM.number = 44
EVENTPARAM_USER_EVENT_CLIENT_AI_UPDATE_ENUM.name = "USER_EVENT_CLIENT_AI_UPDATE"
EVENTPARAM_USER_EVENT_CLIENT_AI_UPDATE_ENUM.index = 42
EVENTPARAM_USER_EVENT_CLIENT_AI_UPDATE_ENUM.number = 45
EVENTPARAM_USER_EVENT_GIFTCODE_EXCHANGE_ENUM.name = "USER_EVENT_GIFTCODE_EXCHANGE"
EVENTPARAM_USER_EVENT_GIFTCODE_EXCHANGE_ENUM.index = 43
EVENTPARAM_USER_EVENT_GIFTCODE_EXCHANGE_ENUM.number = 46
EVENTPARAM_USER_EVENT_HIDE_OTHER_APPEARANCE_ENUM.name = "USER_EVENT_HIDE_OTHER_APPEARANCE"
EVENTPARAM_USER_EVENT_HIDE_OTHER_APPEARANCE_ENUM.index = 44
EVENTPARAM_USER_EVENT_HIDE_OTHER_APPEARANCE_ENUM.number = 47
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_NTF_ENUM.name = "USER_EVENT_GIFT_TIMELIMIT_NTF"
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_NTF_ENUM.index = 45
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_NTF_ENUM.number = 48
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_BUY_ENUM.name = "USER_EVENT_GIFT_TIMELIMIT_BUY"
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_BUY_ENUM.index = 46
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_BUY_ENUM.number = 49
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_ACTIVE_ENUM.name = "USER_EVENT_GIFT_TIMELIMIT_ACTIVE"
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_ACTIVE_ENUM.index = 47
EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_ACTIVE_ENUM.number = 50
EVENTPARAM_USER_EVENT_MULTI_CUTSCENE_UPDATE_ENUM.name = "USER_EVENT_MULTI_CUTSCENE_UPDATE"
EVENTPARAM_USER_EVENT_MULTI_CUTSCENE_UPDATE_ENUM.index = 48
EVENTPARAM_USER_EVENT_MULTI_CUTSCENE_UPDATE_ENUM.number = 55
EVENTPARAM_USER_EVENT_POLICY_UPDATE_ENUM.name = "USER_EVENT_POLICY_UPDATE"
EVENTPARAM_USER_EVENT_POLICY_UPDATE_ENUM.index = 49
EVENTPARAM_USER_EVENT_POLICY_UPDATE_ENUM.number = 56
EVENTPARAM_USER_EVENT_POLICY_AGREE_ENUM.name = "USER_EVENT_POLICY_AGREE"
EVENTPARAM_USER_EVENT_POLICY_AGREE_ENUM.index = 50
EVENTPARAM_USER_EVENT_POLICY_AGREE_ENUM.number = 57
EVENTPARAM_USER_EVENT_SHOW_SCENE_OBJECT_ENUM.name = "USER_EVENT_SHOW_SCENE_OBJECT"
EVENTPARAM_USER_EVENT_SHOW_SCENE_OBJECT_ENUM.index = 51
EVENTPARAM_USER_EVENT_SHOW_SCENE_OBJECT_ENUM.number = 58
EVENTPARAM_USER_EVENT_DOUBLE_ACTION_ENUM.name = "USER_EVENT_DOUBLE_ACTION"
EVENTPARAM_USER_EVENT_DOUBLE_ACTION_ENUM.index = 52
EVENTPARAM_USER_EVENT_DOUBLE_ACTION_ENUM.number = 59
EVENTPARAM_USER_EVENT_MONITOR_BEGIN_ENUM.name = "USER_EVENT_MONITOR_BEGIN"
EVENTPARAM_USER_EVENT_MONITOR_BEGIN_ENUM.index = 53
EVENTPARAM_USER_EVENT_MONITOR_BEGIN_ENUM.number = 60
EVENTPARAM_USER_EVENT_MONITOR_STOP_ENUM.name = "USER_EVENT_MONITOR_STOP"
EVENTPARAM_USER_EVENT_MONITOR_STOP_ENUM.index = 54
EVENTPARAM_USER_EVENT_MONITOR_STOP_ENUM.number = 61
EVENTPARAM_USER_EVENT_MONITOR_TOMAP_ENUM.name = "USER_EVENT_MONITOR_TOMAP"
EVENTPARAM_USER_EVENT_MONITOR_TOMAP_ENUM.index = 55
EVENTPARAM_USER_EVENT_MONITOR_TOMAP_ENUM.number = 62
EVENTPARAM_USER_EVENT_MONITOR_ENDMAP_ENUM.name = "USER_EVENT_MONITOR_ENDMAP"
EVENTPARAM_USER_EVENT_MONITOR_ENDMAP_ENUM.index = 56
EVENTPARAM_USER_EVENT_MONITOR_ENDMAP_ENUM.number = 63
EVENTPARAM_USER_EVENT_MONITOR_BUILD_ENUM.name = "USER_EVENT_MONITOR_BUILD"
EVENTPARAM_USER_EVENT_MONITOR_BUILD_ENUM.index = 57
EVENTPARAM_USER_EVENT_MONITOR_BUILD_ENUM.number = 64
EVENTPARAM_USER_EVENT_MONITOR_STOP_RET_ENUM.name = "USER_EVENT_MONITOR_STOP_RET"
EVENTPARAM_USER_EVENT_MONITOR_STOP_RET_ENUM.index = 58
EVENTPARAM_USER_EVENT_MONITOR_STOP_RET_ENUM.number = 65
EVENTPARAM_USER_EVENT_CONFIG_ENUM.name = "USER_EVENT_CONFIG"
EVENTPARAM_USER_EVENT_CONFIG_ENUM.index = 59
EVENTPARAM_USER_EVENT_CONFIG_ENUM.number = 66
EVENTPARAM_USER_EVENT_NPCWALK_ENUM.name = "USER_EVENT_NPCWALK"
EVENTPARAM_USER_EVENT_NPCWALK_ENUM.index = 60
EVENTPARAM_USER_EVENT_NPCWALK_ENUM.number = 67
EVENTPARAM_USER_EVENT_SET_PROFILE_ENUM.name = "USER_EVENT_SET_PROFILE"
EVENTPARAM_USER_EVENT_SET_PROFILE_ENUM.index = 61
EVENTPARAM_USER_EVENT_SET_PROFILE_ENUM.number = 68
EVENTPARAM_USER_EVENT_SYNC_FATE_RELATION_ENUM.name = "USER_EVENT_SYNC_FATE_RELATION"
EVENTPARAM_USER_EVENT_SYNC_FATE_RELATION_ENUM.index = 62
EVENTPARAM_USER_EVENT_SYNC_FATE_RELATION_ENUM.number = 69
EVENTPARAM_USER_EVENT_QUERY_FATE_RELATION_ENUM.name = "USER_EVENT_QUERY_FATE_RELATION"
EVENTPARAM_USER_EVENT_QUERY_FATE_RELATION_ENUM.index = 63
EVENTPARAM_USER_EVENT_QUERY_FATE_RELATION_ENUM.number = 70
EVENTPARAM_USER_EVENT_GVG_OPT_STATUE_ENUM.name = "USER_EVENT_GVG_OPT_STATUE"
EVENTPARAM_USER_EVENT_GVG_OPT_STATUE_ENUM.index = 64
EVENTPARAM_USER_EVENT_GVG_OPT_STATUE_ENUM.number = 71
EVENTPARAM_USER_EVENT_TIMELIMIT_ICON_ENUM.name = "USER_EVENT_TIMELIMIT_ICON"
EVENTPARAM_USER_EVENT_TIMELIMIT_ICON_ENUM.index = 65
EVENTPARAM_USER_EVENT_TIMELIMIT_ICON_ENUM.number = 72
EVENTPARAM_USER_EVENT_GUIDE_ENUM.name = "USER_EVENT_GUIDE"
EVENTPARAM_USER_EVENT_GUIDE_ENUM.index = 66
EVENTPARAM_USER_EVENT_GUIDE_ENUM.number = 73
EVENTPARAM_USER_EVENT_SHOW_CARD_ENUM.name = "USER_EVENT_SHOW_CARD"
EVENTPARAM_USER_EVENT_SHOW_CARD_ENUM.index = 67
EVENTPARAM_USER_EVENT_SHOW_CARD_ENUM.number = 75
EVENTPARAM_USER_EVENT_RMB_GIFT_ENUM.name = "USER_EVENT_RMB_GIFT"
EVENTPARAM_USER_EVENT_RMB_GIFT_ENUM.index = 68
EVENTPARAM_USER_EVENT_RMB_GIFT_ENUM.number = 76
EVENTPARAM_USER_EVENT_QUERY_PROFILE_ENUM.name = "USER_EVENT_QUERY_PROFILE"
EVENTPARAM_USER_EVENT_QUERY_PROFILE_ENUM.index = 69
EVENTPARAM_USER_EVENT_QUERY_PROFILE_ENUM.number = 77
EVENTPARAM_USER_EVENT_GVGSANDTABLE_INFO_ENUM.name = "USER_EVENT_GVGSANDTABLE_INFO"
EVENTPARAM_USER_EVENT_GVGSANDTABLE_INFO_ENUM.index = 70
EVENTPARAM_USER_EVENT_GVGSANDTABLE_INFO_ENUM.number = 78
EVENTPARAM_USER_EVENT_DELAY_RELIVE_METHOD_ENUM.name = "USER_EVENT_DELAY_RELIVE_METHOD"
EVENTPARAM_USER_EVENT_DELAY_RELIVE_METHOD_ENUM.index = 71
EVENTPARAM_USER_EVENT_DELAY_RELIVE_METHOD_ENUM.number = 79
EVENTPARAM_USER_EVENT_UI_ACTION_ENUM.name = "USER_EVENT_UI_ACTION"
EVENTPARAM_USER_EVENT_UI_ACTION_ENUM.index = 72
EVENTPARAM_USER_EVENT_UI_ACTION_ENUM.number = 80
EVENTPARAM_USER_EVENT_QUERY_SPEEDUP_ENUM.name = "USER_EVENT_QUERY_SPEEDUP"
EVENTPARAM_USER_EVENT_QUERY_SPEEDUP_ENUM.index = 73
EVENTPARAM_USER_EVENT_QUERY_SPEEDUP_ENUM.number = 81
EVENTPARAM_USER_EVENT_PLAY_CUTSCENE_ENUM.name = "USER_EVENT_PLAY_CUTSCENE"
EVENTPARAM_USER_EVENT_PLAY_CUTSCENE_ENUM.index = 74
EVENTPARAM_USER_EVENT_PLAY_CUTSCENE_ENUM.number = 82
EVENTPARAM_USER_EVENT_SERVER_OPENTME_ENUM.name = "USER_EVENT_SERVER_OPENTME"
EVENTPARAM_USER_EVENT_SERVER_OPENTME_ENUM.index = 75
EVENTPARAM_USER_EVENT_SERVER_OPENTME_ENUM.number = 83
EVENTPARAM_USER_EVENT_REQ_PERIODIC_MONSTER_ENUM.name = "USER_EVENT_REQ_PERIODIC_MONSTER"
EVENTPARAM_USER_EVENT_REQ_PERIODIC_MONSTER_ENUM.index = 76
EVENTPARAM_USER_EVENT_REQ_PERIODIC_MONSTER_ENUM.number = 84
EVENTPARAM_USER_EVENT_PLAY_HOLDPET_ENUM.name = "USER_EVENT_PLAY_HOLDPET"
EVENTPARAM_USER_EVENT_PLAY_HOLDPET_ENUM.index = 77
EVENTPARAM_USER_EVENT_PLAY_HOLDPET_ENUM.number = 85
EVENTPARAM_USER_EVENT_DAMAGE_RESULT_ENUM.name = "USER_EVENT_DAMAGE_RESULT"
EVENTPARAM_USER_EVENT_DAMAGE_RESULT_ENUM.index = 78
EVENTPARAM_USER_EVENT_DAMAGE_RESULT_ENUM.number = 86
EVENTPARAM_USER_EVENT_HEARTBEAT_REQ_ENUM.name = "USER_EVENT_HEARTBEAT_REQ"
EVENTPARAM_USER_EVENT_HEARTBEAT_REQ_ENUM.index = 79
EVENTPARAM_USER_EVENT_HEARTBEAT_REQ_ENUM.number = 87
EVENTPARAM_USER_EVENT_HEARTBEAT_ACH_ENUM.name = "USER_EVENT_HEARTBEAT_ACH"
EVENTPARAM_USER_EVENT_HEARTBEAT_ACH_ENUM.index = 80
EVENTPARAM_USER_EVENT_HEARTBEAT_ACH_ENUM.number = 88
EVENTPARAM_USER_EVENT_QUERY_USER_REPORT_LIST_ENUM.name = "USER_EVENT_QUERY_USER_REPORT_LIST"
EVENTPARAM_USER_EVENT_QUERY_USER_REPORT_LIST_ENUM.index = 81
EVENTPARAM_USER_EVENT_QUERY_USER_REPORT_LIST_ENUM.number = 89
EVENTPARAM_USER_EVENT_USER_REPORT_ENUM.name = "USER_EVENT_USER_REPORT"
EVENTPARAM_USER_EVENT_USER_REPORT_ENUM.index = 82
EVENTPARAM_USER_EVENT_USER_REPORT_ENUM.number = 90
EVENTPARAM.name = "EventParam"
EVENTPARAM.full_name = ".Cmd.EventParam"
EVENTPARAM.values = {
  EVENTPARAM_USER_EVENT_FIRST_ACTION_ENUM,
  EVENTPARAM_USER_EVENT_ATTACK_NPC_ENUM,
  EVENTPARAM_USER_EVENT_NEW_TITLE_ENUM,
  EVENTPARAM_USER_EVENT_ALL_TITLE_ENUM,
  EVENTPARAM_USER_EVENT_UPDATE_RANDOM_ENUM,
  EVENTPARAM_USER_EVENT_BUFF_DAMAGE_ENUM,
  EVENTPARAM_USER_EVENT_CHARGE_NTF_ENUM,
  EVENTPARAM_USER_EVENT_CHARGE_QUERY_ENUM,
  EVENTPARAM_USER_EVENT_DEPOSIT_CARD_INFO_ENUM,
  EVENTPARAM_USER_EVENT_DEL_TRANSFORM_ENUM,
  EVENTPARAM_USER_EVENT_INVITECAT_FAIL_ENUM,
  EVENTPARAM_USER_EVENT_NPC_FUNCTION_ENUM,
  EVENTPARAM_USER_EVENT_SYSTEM_STRING_ENUM,
  EVENTPARAM_USER_EVENT_HAND_CAT_ENUM,
  EVENTPARAM_USER_EVENT_CHANGE_TITLE_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_CHARGE_CNT_ENUM,
  EVENTPARAM_USER_EVENT_NTF_MONTHCARD_END_ENUM,
  EVENTPARAM_USER_EVENT_LOVELETTER_USE_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_ACTIVITY_CNT_ENUM,
  EVENTPARAM_USER_EVENT_UPDATE_ACTIVITY_CNT_ENUM,
  EVENTPARAM_USER_EVENT_GET_RECALL_SHARE_REWARD_ENUM,
  EVENTPARAM_USER_EVENT_NTF_VERSION_CARD_ENUM,
  EVENTPARAM_USER_EVENT_WAIT_RELIVE_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_RESETTIME_ENUM,
  EVENTPARAM_USER_EVENT_INOUT_ACT_ENUM,
  EVENTPARAM_USER_EVENT_MAIL_ENUM,
  EVENTPARAM_USER_EVENT_LEVELUP_DEAD_ENUM,
  EVENTPARAM_USER_EVENT_AUTOBATTLE_ENUM,
  EVENTPARAM_USER_EVENT_ACTIVITY_MAP_ENUM,
  EVENTPARAM_USER_EVENT_ACTIVITY_POINT_ENUM,
  EVENTPARAM_USER_EVENT_THEME_DETAILS_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_FAVORITE_FRIEND_ENUM,
  EVENTPARAM_USER_EVENT_UPDATE_FAVORITE_FRIEND_ENUM,
  EVENTPARAM_USER_EVENT_ACTION_FAVORITE_FRIEND_ENUM,
  EVENTPARAM_USER_EVENT_SOUND_STORY_ENUM,
  EVENTPARAM_USER_EVENT_CHARGE_ACC_CNT_ENUM,
  EVENTPARAM_USER_EVENT_BIFROST_CONTRIBUTE_ITEM_ENUM,
  EVENTPARAM_USER_EVENT_CAMERA_ACTION_ENUM,
  EVENTPARAM_USER_EVENT_ROBOT_OFFBATTLE_ENUM,
  EVENTPARAM_USER_EVENT_CHARGE_SDK_REQUEST_ENUM,
  EVENTPARAM_USER_EVENT_CHARGE_SDK_REPLY_ENUM,
  EVENTPARAM_USER_EVENT_CLIENT_AI_SYNC_ENUM,
  EVENTPARAM_USER_EVENT_CLIENT_AI_UPDATE_ENUM,
  EVENTPARAM_USER_EVENT_GIFTCODE_EXCHANGE_ENUM,
  EVENTPARAM_USER_EVENT_HIDE_OTHER_APPEARANCE_ENUM,
  EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_NTF_ENUM,
  EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_BUY_ENUM,
  EVENTPARAM_USER_EVENT_GIFT_TIMELIMIT_ACTIVE_ENUM,
  EVENTPARAM_USER_EVENT_MULTI_CUTSCENE_UPDATE_ENUM,
  EVENTPARAM_USER_EVENT_POLICY_UPDATE_ENUM,
  EVENTPARAM_USER_EVENT_POLICY_AGREE_ENUM,
  EVENTPARAM_USER_EVENT_SHOW_SCENE_OBJECT_ENUM,
  EVENTPARAM_USER_EVENT_DOUBLE_ACTION_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_BEGIN_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_STOP_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_TOMAP_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_ENDMAP_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_BUILD_ENUM,
  EVENTPARAM_USER_EVENT_MONITOR_STOP_RET_ENUM,
  EVENTPARAM_USER_EVENT_CONFIG_ENUM,
  EVENTPARAM_USER_EVENT_NPCWALK_ENUM,
  EVENTPARAM_USER_EVENT_SET_PROFILE_ENUM,
  EVENTPARAM_USER_EVENT_SYNC_FATE_RELATION_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_FATE_RELATION_ENUM,
  EVENTPARAM_USER_EVENT_GVG_OPT_STATUE_ENUM,
  EVENTPARAM_USER_EVENT_TIMELIMIT_ICON_ENUM,
  EVENTPARAM_USER_EVENT_GUIDE_ENUM,
  EVENTPARAM_USER_EVENT_SHOW_CARD_ENUM,
  EVENTPARAM_USER_EVENT_RMB_GIFT_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_PROFILE_ENUM,
  EVENTPARAM_USER_EVENT_GVGSANDTABLE_INFO_ENUM,
  EVENTPARAM_USER_EVENT_DELAY_RELIVE_METHOD_ENUM,
  EVENTPARAM_USER_EVENT_UI_ACTION_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_SPEEDUP_ENUM,
  EVENTPARAM_USER_EVENT_PLAY_CUTSCENE_ENUM,
  EVENTPARAM_USER_EVENT_SERVER_OPENTME_ENUM,
  EVENTPARAM_USER_EVENT_REQ_PERIODIC_MONSTER_ENUM,
  EVENTPARAM_USER_EVENT_PLAY_HOLDPET_ENUM,
  EVENTPARAM_USER_EVENT_DAMAGE_RESULT_ENUM,
  EVENTPARAM_USER_EVENT_HEARTBEAT_REQ_ENUM,
  EVENTPARAM_USER_EVENT_HEARTBEAT_ACH_ENUM,
  EVENTPARAM_USER_EVENT_QUERY_USER_REPORT_LIST_ENUM,
  EVENTPARAM_USER_EVENT_USER_REPORT_ENUM
}
EFIRSTACTIONTYPE_EFIRSTACTION_MIN_ENUM.name = "EFIRSTACTION_MIN"
EFIRSTACTIONTYPE_EFIRSTACTION_MIN_ENUM.index = 0
EFIRSTACTIONTYPE_EFIRSTACTION_MIN_ENUM.number = 0
EFIRSTACTIONTYPE_EFIRSTACTION_SKILL_OVERFLOW_ENUM.name = "EFIRSTACTION_SKILL_OVERFLOW"
EFIRSTACTIONTYPE_EFIRSTACTION_SKILL_OVERFLOW_ENUM.index = 1
EFIRSTACTIONTYPE_EFIRSTACTION_SKILL_OVERFLOW_ENUM.number = 1
EFIRSTACTIONTYPE_EFIRSTACTION_EXCHANGECARD_ENUM.name = "EFIRSTACTION_EXCHANGECARD"
EFIRSTACTIONTYPE_EFIRSTACTION_EXCHANGECARD_ENUM.index = 2
EFIRSTACTIONTYPE_EFIRSTACTION_EXCHANGECARD_ENUM.number = 2
EFIRSTACTIONTYPE_EFIRSTACTION_COMPOSECARD_ENUM.name = "EFIRSTACTION_COMPOSECARD"
EFIRSTACTIONTYPE_EFIRSTACTION_COMPOSECARD_ENUM.index = 3
EFIRSTACTIONTYPE_EFIRSTACTION_COMPOSECARD_ENUM.number = 3
EFIRSTACTIONTYPE_EFIRSTACTION_COOKFOOD_ENUM.name = "EFIRSTACTION_COOKFOOD"
EFIRSTACTIONTYPE_EFIRSTACTION_COOKFOOD_ENUM.index = 4
EFIRSTACTIONTYPE_EFIRSTACTION_COOKFOOD_ENUM.number = 4
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_ENUM.name = "EFIRSTACTION_LOTTERY"
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_ENUM.index = 5
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_ENUM.number = 5
EFIRSTACTIONTYPE_EFIRSTACTION_FOOD_MAIL_ENUM.name = "EFIRSTACTION_FOOD_MAIL"
EFIRSTACTIONTYPE_EFIRSTACTION_FOOD_MAIL_ENUM.index = 6
EFIRSTACTIONTYPE_EFIRSTACTION_FOOD_MAIL_ENUM.number = 6
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_EQUIP_ENUM.name = "EFIRSTACTION_LOTTERY_EQUIP"
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_EQUIP_ENUM.index = 7
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_EQUIP_ENUM.number = 7
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_ENUM.name = "EFIRSTACTION_LOTTERY_CARD"
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_ENUM.index = 8
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_ENUM.number = 8
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_MAGIC_ENUM.name = "EFIRSTACTION_LOTTERY_MAGIC"
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_MAGIC_ENUM.index = 9
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_MAGIC_ENUM.number = 9
EFIRSTACTIONTYPE_EFIRSTACTION_RECALL_SHARE_ENUM.name = "EFIRSTACTION_RECALL_SHARE"
EFIRSTACTIONTYPE_EFIRSTACTION_RECALL_SHARE_ENUM.index = 10
EFIRSTACTIONTYPE_EFIRSTACTION_RECALL_SHARE_ENUM.number = 10
EFIRSTACTIONTYPE_EFIRSTACTION_DECOMPOSECARD_ENUM.name = "EFIRSTACTION_DECOMPOSECARD"
EFIRSTACTIONTYPE_EFIRSTACTION_DECOMPOSECARD_ENUM.index = 11
EFIRSTACTIONTYPE_EFIRSTACTION_DECOMPOSECARD_ENUM.number = 11
EFIRSTACTIONTYPE_EFIRSTACTION_KFC_SHARE_ENUM.name = "EFIRSTACTION_KFC_SHARE"
EFIRSTACTIONTYPE_EFIRSTACTION_KFC_SHARE_ENUM.index = 12
EFIRSTACTIONTYPE_EFIRSTACTION_KFC_SHARE_ENUM.number = 12
EFIRSTACTIONTYPE_EFIRSTACTION_RIDE_LOTTERY_ENUM.name = "EFIRSTACTION_RIDE_LOTTERY"
EFIRSTACTIONTYPE_EFIRSTACTION_RIDE_LOTTERY_ENUM.index = 13
EFIRSTACTIONTYPE_EFIRSTACTION_RIDE_LOTTERY_ENUM.number = 13
EFIRSTACTIONTYPE_EFIRSTACTION_MIX_LOTTERY_ENUM.name = "EFIRSTACTION_MIX_LOTTERY"
EFIRSTACTIONTYPE_EFIRSTACTION_MIX_LOTTERY_ENUM.index = 14
EFIRSTACTIONTYPE_EFIRSTACTION_MIX_LOTTERY_ENUM.number = 14
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_NEW_ENUM.name = "EFIRSTACTION_LOTTERY_CARD_NEW"
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_NEW_ENUM.index = 15
EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_NEW_ENUM.number = 15
EFIRSTACTIONTYPE.name = "EFirstActionType"
EFIRSTACTIONTYPE.full_name = ".Cmd.EFirstActionType"
EFIRSTACTIONTYPE.values = {
  EFIRSTACTIONTYPE_EFIRSTACTION_MIN_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_SKILL_OVERFLOW_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_EXCHANGECARD_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_COMPOSECARD_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_COOKFOOD_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_FOOD_MAIL_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_EQUIP_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_MAGIC_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_RECALL_SHARE_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_DECOMPOSECARD_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_KFC_SHARE_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_RIDE_LOTTERY_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_MIX_LOTTERY_ENUM,
  EFIRSTACTIONTYPE_EFIRSTACTION_LOTTERY_CARD_NEW_ENUM
}
ETITLETYPE_ETITLE_TYPE_MIN_ENUM.name = "ETITLE_TYPE_MIN"
ETITLETYPE_ETITLE_TYPE_MIN_ENUM.index = 0
ETITLETYPE_ETITLE_TYPE_MIN_ENUM.number = 0
ETITLETYPE_ETITLE_TYPE_MANNUAL_ENUM.name = "ETITLE_TYPE_MANNUAL"
ETITLETYPE_ETITLE_TYPE_MANNUAL_ENUM.index = 1
ETITLETYPE_ETITLE_TYPE_MANNUAL_ENUM.number = 1
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ENUM.name = "ETITLE_TYPE_ACHIEVEMENT"
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ENUM.index = 2
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ENUM.number = 2
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ORDER_ENUM.name = "ETITLE_TYPE_ACHIEVEMENT_ORDER"
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ORDER_ENUM.index = 3
ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ORDER_ENUM.number = 3
ETITLETYPE_ETITLE_TYPE_FOODCOOKER_ENUM.name = "ETITLE_TYPE_FOODCOOKER"
ETITLETYPE_ETITLE_TYPE_FOODCOOKER_ENUM.index = 4
ETITLETYPE_ETITLE_TYPE_FOODCOOKER_ENUM.number = 7
ETITLETYPE_ETITLE_TYPE_FOODTASTER_ENUM.name = "ETITLE_TYPE_FOODTASTER"
ETITLETYPE_ETITLE_TYPE_FOODTASTER_ENUM.index = 5
ETITLETYPE_ETITLE_TYPE_FOODTASTER_ENUM.number = 8
ETITLETYPE_ETITLE_TYPE_MAX_ENUM.name = "ETITLE_TYPE_MAX"
ETITLETYPE_ETITLE_TYPE_MAX_ENUM.index = 6
ETITLETYPE_ETITLE_TYPE_MAX_ENUM.number = 9
ETITLETYPE.name = "ETitleType"
ETITLETYPE.full_name = ".Cmd.ETitleType"
ETITLETYPE.values = {
  ETITLETYPE_ETITLE_TYPE_MIN_ENUM,
  ETITLETYPE_ETITLE_TYPE_MANNUAL_ENUM,
  ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ENUM,
  ETITLETYPE_ETITLE_TYPE_ACHIEVEMENT_ORDER_ENUM,
  ETITLETYPE_ETITLE_TYPE_FOODCOOKER_ENUM,
  ETITLETYPE_ETITLE_TYPE_FOODTASTER_ENUM,
  ETITLETYPE_ETITLE_TYPE_MAX_ENUM
}
EDEPOSITSTATE_EDEPOSITSTAT_NONE_ENUM.name = "EDEPOSITSTAT_NONE"
EDEPOSITSTATE_EDEPOSITSTAT_NONE_ENUM.index = 0
EDEPOSITSTATE_EDEPOSITSTAT_NONE_ENUM.number = 0
EDEPOSITSTATE_EDEPOSITSTAT_VALID_ENUM.name = "EDEPOSITSTAT_VALID"
EDEPOSITSTATE_EDEPOSITSTAT_VALID_ENUM.index = 1
EDEPOSITSTATE_EDEPOSITSTAT_VALID_ENUM.number = 1
EDEPOSITSTATE_EDEPOSITSTAT_INVALID_ENUM.name = "EDEPOSITSTAT_INVALID"
EDEPOSITSTATE_EDEPOSITSTAT_INVALID_ENUM.index = 2
EDEPOSITSTATE_EDEPOSITSTAT_INVALID_ENUM.number = 2
EDEPOSITSTATE.name = "EDepositState"
EDEPOSITSTATE.full_name = ".Cmd.EDepositState"
EDEPOSITSTATE.values = {
  EDEPOSITSTATE_EDEPOSITSTAT_NONE_ENUM,
  EDEPOSITSTATE_EDEPOSITSTAT_VALID_ENUM,
  EDEPOSITSTATE_EDEPOSITSTAT_INVALID_ENUM
}
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MIN_ENUM.name = "ESYSTEMSTRING_MIN"
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MIN_ENUM.index = 0
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MIN_ENUM.number = 0
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MEMO_ENUM.name = "ESYSTEMSTRING_MEMO"
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MEMO_ENUM.index = 1
ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MEMO_ENUM.number = 1
ESYSTEMSTRINGTYPE.name = "ESystemStringType"
ESYSTEMSTRINGTYPE.full_name = ".Cmd.ESystemStringType"
ESYSTEMSTRINGTYPE.values = {
  ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MIN_ENUM,
  ESYSTEMSTRINGTYPE_ESYSTEMSTRING_MEMO_ENUM
}
EEVENTMAILTYPE_EEVENTMAILTYPE_MIN_ENUM.name = "EEVENTMAILTYPE_MIN"
EEVENTMAILTYPE_EEVENTMAILTYPE_MIN_ENUM.index = 0
EEVENTMAILTYPE_EEVENTMAILTYPE_MIN_ENUM.number = 0
EEVENTMAILTYPE_EEVENTMAILTYPE_DELCAHR_ENUM.name = "EEVENTMAILTYPE_DELCAHR"
EEVENTMAILTYPE_EEVENTMAILTYPE_DELCAHR_ENUM.index = 1
EEVENTMAILTYPE_EEVENTMAILTYPE_DELCAHR_ENUM.number = 1
EEVENTMAILTYPE.name = "EEventMailType"
EEVENTMAILTYPE.full_name = ".Cmd.EEventMailType"
EEVENTMAILTYPE.values = {
  EEVENTMAILTYPE_EEVENTMAILTYPE_MIN_ENUM,
  EEVENTMAILTYPE_EEVENTMAILTYPE_DELCAHR_ENUM
}
EGIFTSTATE_EGIFTSTATE_INIT_ENUM.name = "EGIFTSTATE_INIT"
EGIFTSTATE_EGIFTSTATE_INIT_ENUM.index = 0
EGIFTSTATE_EGIFTSTATE_INIT_ENUM.number = 0
EGIFTSTATE_EGIFTSTATE_ACTIVE_ENUM.name = "EGIFTSTATE_ACTIVE"
EGIFTSTATE_EGIFTSTATE_ACTIVE_ENUM.index = 1
EGIFTSTATE_EGIFTSTATE_ACTIVE_ENUM.number = 1
EGIFTSTATE_EGIFTSTATE_REWARD_ENUM.name = "EGIFTSTATE_REWARD"
EGIFTSTATE_EGIFTSTATE_REWARD_ENUM.index = 2
EGIFTSTATE_EGIFTSTATE_REWARD_ENUM.number = 2
EGIFTSTATE_EGIFTSTATE_EXPIRE_ENUM.name = "EGIFTSTATE_EXPIRE"
EGIFTSTATE_EGIFTSTATE_EXPIRE_ENUM.index = 3
EGIFTSTATE_EGIFTSTATE_EXPIRE_ENUM.number = 3
EGIFTSTATE.name = "EGiftState"
EGIFTSTATE.full_name = ".Cmd.EGiftState"
EGIFTSTATE.values = {
  EGIFTSTATE_EGIFTSTATE_INIT_ENUM,
  EGIFTSTATE_EGIFTSTATE_ACTIVE_ENUM,
  EGIFTSTATE_EGIFTSTATE_REWARD_ENUM,
  EGIFTSTATE_EGIFTSTATE_EXPIRE_ENUM
}
ECONFIGACTION_ECONFIGACTION_MIN_ENUM.name = "ECONFIGACTION_MIN"
ECONFIGACTION_ECONFIGACTION_MIN_ENUM.index = 0
ECONFIGACTION_ECONFIGACTION_MIN_ENUM.number = 0
ECONFIGACTION_ECONFIGACTION_QUERY_ENUM.name = "ECONFIGACTION_QUERY"
ECONFIGACTION_ECONFIGACTION_QUERY_ENUM.index = 1
ECONFIGACTION_ECONFIGACTION_QUERY_ENUM.number = 1
ECONFIGACTION_ECONFIGACTION_ADD_ENUM.name = "ECONFIGACTION_ADD"
ECONFIGACTION_ECONFIGACTION_ADD_ENUM.index = 2
ECONFIGACTION_ECONFIGACTION_ADD_ENUM.number = 2
ECONFIGACTION_ECONFIGACTION_MODIFY_ENUM.name = "ECONFIGACTION_MODIFY"
ECONFIGACTION_ECONFIGACTION_MODIFY_ENUM.index = 3
ECONFIGACTION_ECONFIGACTION_MODIFY_ENUM.number = 3
ECONFIGACTION_ECONFIGACTION_DELETE_ENUM.name = "ECONFIGACTION_DELETE"
ECONFIGACTION_ECONFIGACTION_DELETE_ENUM.index = 4
ECONFIGACTION_ECONFIGACTION_DELETE_ENUM.number = 4
ECONFIGACTION_ECONFIGACTION_MAX_ENUM.name = "ECONFIGACTION_MAX"
ECONFIGACTION_ECONFIGACTION_MAX_ENUM.index = 5
ECONFIGACTION_ECONFIGACTION_MAX_ENUM.number = 5
ECONFIGACTION.name = "EConfigAction"
ECONFIGACTION.full_name = ".Cmd.EConfigAction"
ECONFIGACTION.values = {
  ECONFIGACTION_ECONFIGACTION_MIN_ENUM,
  ECONFIGACTION_ECONFIGACTION_QUERY_ENUM,
  ECONFIGACTION_ECONFIGACTION_ADD_ENUM,
  ECONFIGACTION_ECONFIGACTION_MODIFY_ENUM,
  ECONFIGACTION_ECONFIGACTION_DELETE_ENUM,
  ECONFIGACTION_ECONFIGACTION_MAX_ENUM
}
EDELAYRELIVEMETHOD_EDELAYRELIVE_MIN_ENUM.name = "EDELAYRELIVE_MIN"
EDELAYRELIVEMETHOD_EDELAYRELIVE_MIN_ENUM.index = 0
EDELAYRELIVEMETHOD_EDELAYRELIVE_MIN_ENUM.number = 0
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_POINT_ENUM.name = "EDELAYRELIVE_GVG_POINT"
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_POINT_ENUM.index = 1
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_POINT_ENUM.number = 1
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_SAFE_ENUM.name = "EDELAYRELIVE_GVG_SAFE"
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_SAFE_ENUM.index = 2
EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_SAFE_ENUM.number = 2
EDELAYRELIVEMETHOD.name = "EDelayReliveMethod"
EDELAYRELIVEMETHOD.full_name = ".Cmd.EDelayReliveMethod"
EDELAYRELIVEMETHOD.values = {
  EDELAYRELIVEMETHOD_EDELAYRELIVE_MIN_ENUM,
  EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_POINT_ENUM,
  EDELAYRELIVEMETHOD_EDELAYRELIVE_GVG_SAFE_ENUM
}
ESPEEDUPTYPE_ESPEEDUP_TYPE_MIN_ENUM.name = "ESPEEDUP_TYPE_MIN"
ESPEEDUPTYPE_ESPEEDUP_TYPE_MIN_ENUM.index = 0
ESPEEDUPTYPE_ESPEEDUP_TYPE_MIN_ENUM.number = 0
ESPEEDUPTYPE_ESPEEDUP_TYPE_DIFF_JOB_ENUM.name = "ESPEEDUP_TYPE_DIFF_JOB"
ESPEEDUPTYPE_ESPEEDUP_TYPE_DIFF_JOB_ENUM.index = 1
ESPEEDUPTYPE_ESPEEDUP_TYPE_DIFF_JOB_ENUM.number = 1
ESPEEDUPTYPE_ESPEEDUP_TYPE_SERVER_ENUM.name = "ESPEEDUP_TYPE_SERVER"
ESPEEDUPTYPE_ESPEEDUP_TYPE_SERVER_ENUM.index = 2
ESPEEDUPTYPE_ESPEEDUP_TYPE_SERVER_ENUM.number = 2
ESPEEDUPTYPE_ESPEEDUP_TYPE_ITEM_ENUM.name = "ESPEEDUP_TYPE_ITEM"
ESPEEDUPTYPE_ESPEEDUP_TYPE_ITEM_ENUM.index = 3
ESPEEDUPTYPE_ESPEEDUP_TYPE_ITEM_ENUM.number = 3
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_NOT_TIRE_ENUM.name = "ESPEEDUP_TYPE_CARD_NOT_TIRE"
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_NOT_TIRE_ENUM.index = 4
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_NOT_TIRE_ENUM.number = 4
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_COMMON_ENUM.name = "ESPEEDUP_TYPE_CARD_COMMON"
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_COMMON_ENUM.index = 5
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_COMMON_ENUM.number = 5
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_RAID_ENUM.name = "ESPEEDUP_TYPE_CARD_RAID"
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_RAID_ENUM.index = 6
ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_RAID_ENUM.number = 6
ESPEEDUPTYPE_ESPEEDUP_TYPE_MAX_ENUM.name = "ESPEEDUP_TYPE_MAX"
ESPEEDUPTYPE_ESPEEDUP_TYPE_MAX_ENUM.index = 7
ESPEEDUPTYPE_ESPEEDUP_TYPE_MAX_ENUM.number = 7
ESPEEDUPTYPE.name = "ESpeedUpType"
ESPEEDUPTYPE.full_name = ".Cmd.ESpeedUpType"
ESPEEDUPTYPE.values = {
  ESPEEDUPTYPE_ESPEEDUP_TYPE_MIN_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_DIFF_JOB_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_SERVER_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_ITEM_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_NOT_TIRE_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_COMMON_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_CARD_RAID_ENUM,
  ESPEEDUPTYPE_ESPEEDUP_TYPE_MAX_ENUM
}
FIRSTACTIONUSEREVENT_CMD_FIELD.name = "cmd"
FIRSTACTIONUSEREVENT_CMD_FIELD.full_name = ".Cmd.FirstActionUserEvent.cmd"
FIRSTACTIONUSEREVENT_CMD_FIELD.number = 1
FIRSTACTIONUSEREVENT_CMD_FIELD.index = 0
FIRSTACTIONUSEREVENT_CMD_FIELD.label = 1
FIRSTACTIONUSEREVENT_CMD_FIELD.has_default_value = true
FIRSTACTIONUSEREVENT_CMD_FIELD.default_value = 25
FIRSTACTIONUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FIRSTACTIONUSEREVENT_CMD_FIELD.type = 14
FIRSTACTIONUSEREVENT_CMD_FIELD.cpp_type = 8
FIRSTACTIONUSEREVENT_PARAM_FIELD.name = "param"
FIRSTACTIONUSEREVENT_PARAM_FIELD.full_name = ".Cmd.FirstActionUserEvent.param"
FIRSTACTIONUSEREVENT_PARAM_FIELD.number = 2
FIRSTACTIONUSEREVENT_PARAM_FIELD.index = 1
FIRSTACTIONUSEREVENT_PARAM_FIELD.label = 1
FIRSTACTIONUSEREVENT_PARAM_FIELD.has_default_value = true
FIRSTACTIONUSEREVENT_PARAM_FIELD.default_value = 1
FIRSTACTIONUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
FIRSTACTIONUSEREVENT_PARAM_FIELD.type = 14
FIRSTACTIONUSEREVENT_PARAM_FIELD.cpp_type = 8
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.name = "firstaction"
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.full_name = ".Cmd.FirstActionUserEvent.firstaction"
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.number = 3
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.index = 2
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.label = 1
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.has_default_value = true
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.default_value = 0
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.type = 13
FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD.cpp_type = 3
FIRSTACTIONUSEREVENT.name = "FirstActionUserEvent"
FIRSTACTIONUSEREVENT.full_name = ".Cmd.FirstActionUserEvent"
FIRSTACTIONUSEREVENT.nested_types = {}
FIRSTACTIONUSEREVENT.enum_types = {}
FIRSTACTIONUSEREVENT.fields = {
  FIRSTACTIONUSEREVENT_CMD_FIELD,
  FIRSTACTIONUSEREVENT_PARAM_FIELD,
  FIRSTACTIONUSEREVENT_FIRSTACTION_FIELD
}
FIRSTACTIONUSEREVENT.is_extendable = false
FIRSTACTIONUSEREVENT.extensions = {}
DAMAGENPCUSEREVENT_CMD_FIELD.name = "cmd"
DAMAGENPCUSEREVENT_CMD_FIELD.full_name = ".Cmd.DamageNpcUserEvent.cmd"
DAMAGENPCUSEREVENT_CMD_FIELD.number = 1
DAMAGENPCUSEREVENT_CMD_FIELD.index = 0
DAMAGENPCUSEREVENT_CMD_FIELD.label = 1
DAMAGENPCUSEREVENT_CMD_FIELD.has_default_value = true
DAMAGENPCUSEREVENT_CMD_FIELD.default_value = 25
DAMAGENPCUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DAMAGENPCUSEREVENT_CMD_FIELD.type = 14
DAMAGENPCUSEREVENT_CMD_FIELD.cpp_type = 8
DAMAGENPCUSEREVENT_PARAM_FIELD.name = "param"
DAMAGENPCUSEREVENT_PARAM_FIELD.full_name = ".Cmd.DamageNpcUserEvent.param"
DAMAGENPCUSEREVENT_PARAM_FIELD.number = 2
DAMAGENPCUSEREVENT_PARAM_FIELD.index = 1
DAMAGENPCUSEREVENT_PARAM_FIELD.label = 1
DAMAGENPCUSEREVENT_PARAM_FIELD.has_default_value = true
DAMAGENPCUSEREVENT_PARAM_FIELD.default_value = 2
DAMAGENPCUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
DAMAGENPCUSEREVENT_PARAM_FIELD.type = 14
DAMAGENPCUSEREVENT_PARAM_FIELD.cpp_type = 8
DAMAGENPCUSEREVENT_NPCGUID_FIELD.name = "npcguid"
DAMAGENPCUSEREVENT_NPCGUID_FIELD.full_name = ".Cmd.DamageNpcUserEvent.npcguid"
DAMAGENPCUSEREVENT_NPCGUID_FIELD.number = 3
DAMAGENPCUSEREVENT_NPCGUID_FIELD.index = 2
DAMAGENPCUSEREVENT_NPCGUID_FIELD.label = 1
DAMAGENPCUSEREVENT_NPCGUID_FIELD.has_default_value = true
DAMAGENPCUSEREVENT_NPCGUID_FIELD.default_value = 0
DAMAGENPCUSEREVENT_NPCGUID_FIELD.type = 4
DAMAGENPCUSEREVENT_NPCGUID_FIELD.cpp_type = 4
DAMAGENPCUSEREVENT_USERID_FIELD.name = "userid"
DAMAGENPCUSEREVENT_USERID_FIELD.full_name = ".Cmd.DamageNpcUserEvent.userid"
DAMAGENPCUSEREVENT_USERID_FIELD.number = 4
DAMAGENPCUSEREVENT_USERID_FIELD.index = 3
DAMAGENPCUSEREVENT_USERID_FIELD.label = 1
DAMAGENPCUSEREVENT_USERID_FIELD.has_default_value = true
DAMAGENPCUSEREVENT_USERID_FIELD.default_value = 0
DAMAGENPCUSEREVENT_USERID_FIELD.type = 4
DAMAGENPCUSEREVENT_USERID_FIELD.cpp_type = 4
DAMAGENPCUSEREVENT.name = "DamageNpcUserEvent"
DAMAGENPCUSEREVENT.full_name = ".Cmd.DamageNpcUserEvent"
DAMAGENPCUSEREVENT.nested_types = {}
DAMAGENPCUSEREVENT.enum_types = {}
DAMAGENPCUSEREVENT.fields = {
  DAMAGENPCUSEREVENT_CMD_FIELD,
  DAMAGENPCUSEREVENT_PARAM_FIELD,
  DAMAGENPCUSEREVENT_NPCGUID_FIELD,
  DAMAGENPCUSEREVENT_USERID_FIELD
}
DAMAGENPCUSEREVENT.is_extendable = false
DAMAGENPCUSEREVENT.extensions = {}
TITLEDATA_TITLE_TYPE_FIELD.name = "title_type"
TITLEDATA_TITLE_TYPE_FIELD.full_name = ".Cmd.TitleData.title_type"
TITLEDATA_TITLE_TYPE_FIELD.number = 1
TITLEDATA_TITLE_TYPE_FIELD.index = 0
TITLEDATA_TITLE_TYPE_FIELD.label = 1
TITLEDATA_TITLE_TYPE_FIELD.has_default_value = false
TITLEDATA_TITLE_TYPE_FIELD.default_value = nil
TITLEDATA_TITLE_TYPE_FIELD.enum_type = ETITLETYPE
TITLEDATA_TITLE_TYPE_FIELD.type = 14
TITLEDATA_TITLE_TYPE_FIELD.cpp_type = 8
TITLEDATA_ID_FIELD.name = "id"
TITLEDATA_ID_FIELD.full_name = ".Cmd.TitleData.id"
TITLEDATA_ID_FIELD.number = 2
TITLEDATA_ID_FIELD.index = 1
TITLEDATA_ID_FIELD.label = 1
TITLEDATA_ID_FIELD.has_default_value = true
TITLEDATA_ID_FIELD.default_value = 0
TITLEDATA_ID_FIELD.type = 13
TITLEDATA_ID_FIELD.cpp_type = 3
TITLEDATA_CREATETIME_FIELD.name = "createtime"
TITLEDATA_CREATETIME_FIELD.full_name = ".Cmd.TitleData.createtime"
TITLEDATA_CREATETIME_FIELD.number = 3
TITLEDATA_CREATETIME_FIELD.index = 2
TITLEDATA_CREATETIME_FIELD.label = 1
TITLEDATA_CREATETIME_FIELD.has_default_value = true
TITLEDATA_CREATETIME_FIELD.default_value = 0
TITLEDATA_CREATETIME_FIELD.type = 13
TITLEDATA_CREATETIME_FIELD.cpp_type = 3
TITLEDATA.name = "TitleData"
TITLEDATA.full_name = ".Cmd.TitleData"
TITLEDATA.nested_types = {}
TITLEDATA.enum_types = {}
TITLEDATA.fields = {
  TITLEDATA_TITLE_TYPE_FIELD,
  TITLEDATA_ID_FIELD,
  TITLEDATA_CREATETIME_FIELD
}
TITLEDATA.is_extendable = false
TITLEDATA.extensions = {}
NEWTITLE_CMD_FIELD.name = "cmd"
NEWTITLE_CMD_FIELD.full_name = ".Cmd.NewTitle.cmd"
NEWTITLE_CMD_FIELD.number = 1
NEWTITLE_CMD_FIELD.index = 0
NEWTITLE_CMD_FIELD.label = 1
NEWTITLE_CMD_FIELD.has_default_value = true
NEWTITLE_CMD_FIELD.default_value = 25
NEWTITLE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWTITLE_CMD_FIELD.type = 14
NEWTITLE_CMD_FIELD.cpp_type = 8
NEWTITLE_PARAM_FIELD.name = "param"
NEWTITLE_PARAM_FIELD.full_name = ".Cmd.NewTitle.param"
NEWTITLE_PARAM_FIELD.number = 2
NEWTITLE_PARAM_FIELD.index = 1
NEWTITLE_PARAM_FIELD.label = 1
NEWTITLE_PARAM_FIELD.has_default_value = true
NEWTITLE_PARAM_FIELD.default_value = 3
NEWTITLE_PARAM_FIELD.enum_type = EVENTPARAM
NEWTITLE_PARAM_FIELD.type = 14
NEWTITLE_PARAM_FIELD.cpp_type = 8
NEWTITLE_TITLE_DATA_FIELD.name = "title_data"
NEWTITLE_TITLE_DATA_FIELD.full_name = ".Cmd.NewTitle.title_data"
NEWTITLE_TITLE_DATA_FIELD.number = 3
NEWTITLE_TITLE_DATA_FIELD.index = 2
NEWTITLE_TITLE_DATA_FIELD.label = 1
NEWTITLE_TITLE_DATA_FIELD.has_default_value = false
NEWTITLE_TITLE_DATA_FIELD.default_value = nil
NEWTITLE_TITLE_DATA_FIELD.message_type = TITLEDATA
NEWTITLE_TITLE_DATA_FIELD.type = 11
NEWTITLE_TITLE_DATA_FIELD.cpp_type = 10
NEWTITLE_CHARID_FIELD.name = "charid"
NEWTITLE_CHARID_FIELD.full_name = ".Cmd.NewTitle.charid"
NEWTITLE_CHARID_FIELD.number = 4
NEWTITLE_CHARID_FIELD.index = 3
NEWTITLE_CHARID_FIELD.label = 1
NEWTITLE_CHARID_FIELD.has_default_value = false
NEWTITLE_CHARID_FIELD.default_value = 0
NEWTITLE_CHARID_FIELD.type = 4
NEWTITLE_CHARID_FIELD.cpp_type = 4
NEWTITLE.name = "NewTitle"
NEWTITLE.full_name = ".Cmd.NewTitle"
NEWTITLE.nested_types = {}
NEWTITLE.enum_types = {}
NEWTITLE.fields = {
  NEWTITLE_CMD_FIELD,
  NEWTITLE_PARAM_FIELD,
  NEWTITLE_TITLE_DATA_FIELD,
  NEWTITLE_CHARID_FIELD
}
NEWTITLE.is_extendable = false
NEWTITLE.extensions = {}
ALLTITLE_CMD_FIELD.name = "cmd"
ALLTITLE_CMD_FIELD.full_name = ".Cmd.AllTitle.cmd"
ALLTITLE_CMD_FIELD.number = 1
ALLTITLE_CMD_FIELD.index = 0
ALLTITLE_CMD_FIELD.label = 1
ALLTITLE_CMD_FIELD.has_default_value = true
ALLTITLE_CMD_FIELD.default_value = 25
ALLTITLE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ALLTITLE_CMD_FIELD.type = 14
ALLTITLE_CMD_FIELD.cpp_type = 8
ALLTITLE_PARAM_FIELD.name = "param"
ALLTITLE_PARAM_FIELD.full_name = ".Cmd.AllTitle.param"
ALLTITLE_PARAM_FIELD.number = 2
ALLTITLE_PARAM_FIELD.index = 1
ALLTITLE_PARAM_FIELD.label = 1
ALLTITLE_PARAM_FIELD.has_default_value = true
ALLTITLE_PARAM_FIELD.default_value = 4
ALLTITLE_PARAM_FIELD.enum_type = EVENTPARAM
ALLTITLE_PARAM_FIELD.type = 14
ALLTITLE_PARAM_FIELD.cpp_type = 8
ALLTITLE_TITLE_DATAS_FIELD.name = "title_datas"
ALLTITLE_TITLE_DATAS_FIELD.full_name = ".Cmd.AllTitle.title_datas"
ALLTITLE_TITLE_DATAS_FIELD.number = 3
ALLTITLE_TITLE_DATAS_FIELD.index = 2
ALLTITLE_TITLE_DATAS_FIELD.label = 3
ALLTITLE_TITLE_DATAS_FIELD.has_default_value = false
ALLTITLE_TITLE_DATAS_FIELD.default_value = {}
ALLTITLE_TITLE_DATAS_FIELD.message_type = TITLEDATA
ALLTITLE_TITLE_DATAS_FIELD.type = 11
ALLTITLE_TITLE_DATAS_FIELD.cpp_type = 10
ALLTITLE.name = "AllTitle"
ALLTITLE.full_name = ".Cmd.AllTitle"
ALLTITLE.nested_types = {}
ALLTITLE.enum_types = {}
ALLTITLE.fields = {
  ALLTITLE_CMD_FIELD,
  ALLTITLE_PARAM_FIELD,
  ALLTITLE_TITLE_DATAS_FIELD
}
ALLTITLE.is_extendable = false
ALLTITLE.extensions = {}
UPDATERANDOMUSEREVENT_CMD_FIELD.name = "cmd"
UPDATERANDOMUSEREVENT_CMD_FIELD.full_name = ".Cmd.UpdateRandomUserEvent.cmd"
UPDATERANDOMUSEREVENT_CMD_FIELD.number = 1
UPDATERANDOMUSEREVENT_CMD_FIELD.index = 0
UPDATERANDOMUSEREVENT_CMD_FIELD.label = 1
UPDATERANDOMUSEREVENT_CMD_FIELD.has_default_value = true
UPDATERANDOMUSEREVENT_CMD_FIELD.default_value = 25
UPDATERANDOMUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATERANDOMUSEREVENT_CMD_FIELD.type = 14
UPDATERANDOMUSEREVENT_CMD_FIELD.cpp_type = 8
UPDATERANDOMUSEREVENT_PARAM_FIELD.name = "param"
UPDATERANDOMUSEREVENT_PARAM_FIELD.full_name = ".Cmd.UpdateRandomUserEvent.param"
UPDATERANDOMUSEREVENT_PARAM_FIELD.number = 2
UPDATERANDOMUSEREVENT_PARAM_FIELD.index = 1
UPDATERANDOMUSEREVENT_PARAM_FIELD.label = 1
UPDATERANDOMUSEREVENT_PARAM_FIELD.has_default_value = true
UPDATERANDOMUSEREVENT_PARAM_FIELD.default_value = 5
UPDATERANDOMUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
UPDATERANDOMUSEREVENT_PARAM_FIELD.type = 14
UPDATERANDOMUSEREVENT_PARAM_FIELD.cpp_type = 8
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.name = "beginindex"
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.full_name = ".Cmd.UpdateRandomUserEvent.beginindex"
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.number = 3
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.index = 2
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.label = 1
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.has_default_value = true
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.default_value = 0
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.type = 13
UPDATERANDOMUSEREVENT_BEGININDEX_FIELD.cpp_type = 3
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.name = "endindex"
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.full_name = ".Cmd.UpdateRandomUserEvent.endindex"
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.number = 4
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.index = 3
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.label = 1
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.has_default_value = true
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.default_value = 0
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.type = 13
UPDATERANDOMUSEREVENT_ENDINDEX_FIELD.cpp_type = 3
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.name = "randoms"
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.full_name = ".Cmd.UpdateRandomUserEvent.randoms"
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.number = 5
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.index = 4
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.label = 3
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.has_default_value = false
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.default_value = {}
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.type = 4
UPDATERANDOMUSEREVENT_RANDOMS_FIELD.cpp_type = 4
UPDATERANDOMUSEREVENT.name = "UpdateRandomUserEvent"
UPDATERANDOMUSEREVENT.full_name = ".Cmd.UpdateRandomUserEvent"
UPDATERANDOMUSEREVENT.nested_types = {}
UPDATERANDOMUSEREVENT.enum_types = {}
UPDATERANDOMUSEREVENT.fields = {
  UPDATERANDOMUSEREVENT_CMD_FIELD,
  UPDATERANDOMUSEREVENT_PARAM_FIELD,
  UPDATERANDOMUSEREVENT_BEGININDEX_FIELD,
  UPDATERANDOMUSEREVENT_ENDINDEX_FIELD,
  UPDATERANDOMUSEREVENT_RANDOMS_FIELD
}
UPDATERANDOMUSEREVENT.is_extendable = false
UPDATERANDOMUSEREVENT.extensions = {}
BUFFDAMAGEUSEREVENT_CMD_FIELD.name = "cmd"
BUFFDAMAGEUSEREVENT_CMD_FIELD.full_name = ".Cmd.BuffDamageUserEvent.cmd"
BUFFDAMAGEUSEREVENT_CMD_FIELD.number = 1
BUFFDAMAGEUSEREVENT_CMD_FIELD.index = 0
BUFFDAMAGEUSEREVENT_CMD_FIELD.label = 1
BUFFDAMAGEUSEREVENT_CMD_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_CMD_FIELD.default_value = 25
BUFFDAMAGEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BUFFDAMAGEUSEREVENT_CMD_FIELD.type = 14
BUFFDAMAGEUSEREVENT_CMD_FIELD.cpp_type = 8
BUFFDAMAGEUSEREVENT_PARAM_FIELD.name = "param"
BUFFDAMAGEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.BuffDamageUserEvent.param"
BUFFDAMAGEUSEREVENT_PARAM_FIELD.number = 2
BUFFDAMAGEUSEREVENT_PARAM_FIELD.index = 1
BUFFDAMAGEUSEREVENT_PARAM_FIELD.label = 1
BUFFDAMAGEUSEREVENT_PARAM_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_PARAM_FIELD.default_value = 6
BUFFDAMAGEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
BUFFDAMAGEUSEREVENT_PARAM_FIELD.type = 14
BUFFDAMAGEUSEREVENT_PARAM_FIELD.cpp_type = 8
BUFFDAMAGEUSEREVENT_CHARID_FIELD.name = "charid"
BUFFDAMAGEUSEREVENT_CHARID_FIELD.full_name = ".Cmd.BuffDamageUserEvent.charid"
BUFFDAMAGEUSEREVENT_CHARID_FIELD.number = 3
BUFFDAMAGEUSEREVENT_CHARID_FIELD.index = 2
BUFFDAMAGEUSEREVENT_CHARID_FIELD.label = 1
BUFFDAMAGEUSEREVENT_CHARID_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_CHARID_FIELD.default_value = 0
BUFFDAMAGEUSEREVENT_CHARID_FIELD.type = 4
BUFFDAMAGEUSEREVENT_CHARID_FIELD.cpp_type = 4
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.name = "damage"
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.full_name = ".Cmd.BuffDamageUserEvent.damage"
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.number = 4
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.index = 3
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.label = 1
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.default_value = 0
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.type = 5
BUFFDAMAGEUSEREVENT_DAMAGE_FIELD.cpp_type = 1
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.name = "etype"
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.full_name = ".Cmd.BuffDamageUserEvent.etype"
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.number = 5
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.index = 4
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.label = 1
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.default_value = 1
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.enum_type = SCENEUSER_PB_DAMAGETYPE
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.type = 14
BUFFDAMAGEUSEREVENT_ETYPE_FIELD.cpp_type = 8
BUFFDAMAGEUSEREVENT_FROMID_FIELD.name = "fromid"
BUFFDAMAGEUSEREVENT_FROMID_FIELD.full_name = ".Cmd.BuffDamageUserEvent.fromid"
BUFFDAMAGEUSEREVENT_FROMID_FIELD.number = 6
BUFFDAMAGEUSEREVENT_FROMID_FIELD.index = 5
BUFFDAMAGEUSEREVENT_FROMID_FIELD.label = 1
BUFFDAMAGEUSEREVENT_FROMID_FIELD.has_default_value = true
BUFFDAMAGEUSEREVENT_FROMID_FIELD.default_value = 0
BUFFDAMAGEUSEREVENT_FROMID_FIELD.type = 4
BUFFDAMAGEUSEREVENT_FROMID_FIELD.cpp_type = 4
BUFFDAMAGEUSEREVENT.name = "BuffDamageUserEvent"
BUFFDAMAGEUSEREVENT.full_name = ".Cmd.BuffDamageUserEvent"
BUFFDAMAGEUSEREVENT.nested_types = {}
BUFFDAMAGEUSEREVENT.enum_types = {}
BUFFDAMAGEUSEREVENT.fields = {
  BUFFDAMAGEUSEREVENT_CMD_FIELD,
  BUFFDAMAGEUSEREVENT_PARAM_FIELD,
  BUFFDAMAGEUSEREVENT_CHARID_FIELD,
  BUFFDAMAGEUSEREVENT_DAMAGE_FIELD,
  BUFFDAMAGEUSEREVENT_ETYPE_FIELD,
  BUFFDAMAGEUSEREVENT_FROMID_FIELD
}
BUFFDAMAGEUSEREVENT.is_extendable = false
BUFFDAMAGEUSEREVENT.extensions = {}
CHARGENTFUSEREVENT_CMD_FIELD.name = "cmd"
CHARGENTFUSEREVENT_CMD_FIELD.full_name = ".Cmd.ChargeNtfUserEvent.cmd"
CHARGENTFUSEREVENT_CMD_FIELD.number = 1
CHARGENTFUSEREVENT_CMD_FIELD.index = 0
CHARGENTFUSEREVENT_CMD_FIELD.label = 1
CHARGENTFUSEREVENT_CMD_FIELD.has_default_value = true
CHARGENTFUSEREVENT_CMD_FIELD.default_value = 25
CHARGENTFUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHARGENTFUSEREVENT_CMD_FIELD.type = 14
CHARGENTFUSEREVENT_CMD_FIELD.cpp_type = 8
CHARGENTFUSEREVENT_PARAM_FIELD.name = "param"
CHARGENTFUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ChargeNtfUserEvent.param"
CHARGENTFUSEREVENT_PARAM_FIELD.number = 2
CHARGENTFUSEREVENT_PARAM_FIELD.index = 1
CHARGENTFUSEREVENT_PARAM_FIELD.label = 1
CHARGENTFUSEREVENT_PARAM_FIELD.has_default_value = true
CHARGENTFUSEREVENT_PARAM_FIELD.default_value = 7
CHARGENTFUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CHARGENTFUSEREVENT_PARAM_FIELD.type = 14
CHARGENTFUSEREVENT_PARAM_FIELD.cpp_type = 8
CHARGENTFUSEREVENT_CHARID_FIELD.name = "charid"
CHARGENTFUSEREVENT_CHARID_FIELD.full_name = ".Cmd.ChargeNtfUserEvent.charid"
CHARGENTFUSEREVENT_CHARID_FIELD.number = 3
CHARGENTFUSEREVENT_CHARID_FIELD.index = 2
CHARGENTFUSEREVENT_CHARID_FIELD.label = 1
CHARGENTFUSEREVENT_CHARID_FIELD.has_default_value = true
CHARGENTFUSEREVENT_CHARID_FIELD.default_value = 0
CHARGENTFUSEREVENT_CHARID_FIELD.type = 4
CHARGENTFUSEREVENT_CHARID_FIELD.cpp_type = 4
CHARGENTFUSEREVENT_DATAID_FIELD.name = "dataid"
CHARGENTFUSEREVENT_DATAID_FIELD.full_name = ".Cmd.ChargeNtfUserEvent.dataid"
CHARGENTFUSEREVENT_DATAID_FIELD.number = 4
CHARGENTFUSEREVENT_DATAID_FIELD.index = 3
CHARGENTFUSEREVENT_DATAID_FIELD.label = 1
CHARGENTFUSEREVENT_DATAID_FIELD.has_default_value = true
CHARGENTFUSEREVENT_DATAID_FIELD.default_value = 0
CHARGENTFUSEREVENT_DATAID_FIELD.type = 13
CHARGENTFUSEREVENT_DATAID_FIELD.cpp_type = 3
CHARGENTFUSEREVENT.name = "ChargeNtfUserEvent"
CHARGENTFUSEREVENT.full_name = ".Cmd.ChargeNtfUserEvent"
CHARGENTFUSEREVENT.nested_types = {}
CHARGENTFUSEREVENT.enum_types = {}
CHARGENTFUSEREVENT.fields = {
  CHARGENTFUSEREVENT_CMD_FIELD,
  CHARGENTFUSEREVENT_PARAM_FIELD,
  CHARGENTFUSEREVENT_CHARID_FIELD,
  CHARGENTFUSEREVENT_DATAID_FIELD
}
CHARGENTFUSEREVENT.is_extendable = false
CHARGENTFUSEREVENT.extensions = {}
DEPOSITTYPEDATA_TYPE_FIELD.name = "type"
DEPOSITTYPEDATA_TYPE_FIELD.full_name = ".Cmd.DepositTypeData.type"
DEPOSITTYPEDATA_TYPE_FIELD.number = 1
DEPOSITTYPEDATA_TYPE_FIELD.index = 0
DEPOSITTYPEDATA_TYPE_FIELD.label = 1
DEPOSITTYPEDATA_TYPE_FIELD.has_default_value = false
DEPOSITTYPEDATA_TYPE_FIELD.default_value = nil
DEPOSITTYPEDATA_TYPE_FIELD.enum_type = PROTOCOMMON_PB_EDEPOSITCARDTYPE
DEPOSITTYPEDATA_TYPE_FIELD.type = 14
DEPOSITTYPEDATA_TYPE_FIELD.cpp_type = 8
DEPOSITTYPEDATA_EXPIRETIME_FIELD.name = "expiretime"
DEPOSITTYPEDATA_EXPIRETIME_FIELD.full_name = ".Cmd.DepositTypeData.expiretime"
DEPOSITTYPEDATA_EXPIRETIME_FIELD.number = 2
DEPOSITTYPEDATA_EXPIRETIME_FIELD.index = 1
DEPOSITTYPEDATA_EXPIRETIME_FIELD.label = 1
DEPOSITTYPEDATA_EXPIRETIME_FIELD.has_default_value = false
DEPOSITTYPEDATA_EXPIRETIME_FIELD.default_value = 0
DEPOSITTYPEDATA_EXPIRETIME_FIELD.type = 13
DEPOSITTYPEDATA_EXPIRETIME_FIELD.cpp_type = 3
DEPOSITTYPEDATA_STARTTIME_FIELD.name = "starttime"
DEPOSITTYPEDATA_STARTTIME_FIELD.full_name = ".Cmd.DepositTypeData.starttime"
DEPOSITTYPEDATA_STARTTIME_FIELD.number = 3
DEPOSITTYPEDATA_STARTTIME_FIELD.index = 2
DEPOSITTYPEDATA_STARTTIME_FIELD.label = 1
DEPOSITTYPEDATA_STARTTIME_FIELD.has_default_value = false
DEPOSITTYPEDATA_STARTTIME_FIELD.default_value = 0
DEPOSITTYPEDATA_STARTTIME_FIELD.type = 13
DEPOSITTYPEDATA_STARTTIME_FIELD.cpp_type = 3
DEPOSITTYPEDATA_STATE_FIELD.name = "state"
DEPOSITTYPEDATA_STATE_FIELD.full_name = ".Cmd.DepositTypeData.state"
DEPOSITTYPEDATA_STATE_FIELD.number = 4
DEPOSITTYPEDATA_STATE_FIELD.index = 3
DEPOSITTYPEDATA_STATE_FIELD.label = 1
DEPOSITTYPEDATA_STATE_FIELD.has_default_value = false
DEPOSITTYPEDATA_STATE_FIELD.default_value = nil
DEPOSITTYPEDATA_STATE_FIELD.enum_type = EDEPOSITSTATE
DEPOSITTYPEDATA_STATE_FIELD.type = 14
DEPOSITTYPEDATA_STATE_FIELD.cpp_type = 8
DEPOSITTYPEDATA_INVALID_FIELD.name = "invalid"
DEPOSITTYPEDATA_INVALID_FIELD.full_name = ".Cmd.DepositTypeData.invalid"
DEPOSITTYPEDATA_INVALID_FIELD.number = 5
DEPOSITTYPEDATA_INVALID_FIELD.index = 4
DEPOSITTYPEDATA_INVALID_FIELD.label = 1
DEPOSITTYPEDATA_INVALID_FIELD.has_default_value = true
DEPOSITTYPEDATA_INVALID_FIELD.default_value = false
DEPOSITTYPEDATA_INVALID_FIELD.type = 8
DEPOSITTYPEDATA_INVALID_FIELD.cpp_type = 7
DEPOSITTYPEDATA.name = "DepositTypeData"
DEPOSITTYPEDATA.full_name = ".Cmd.DepositTypeData"
DEPOSITTYPEDATA.nested_types = {}
DEPOSITTYPEDATA.enum_types = {}
DEPOSITTYPEDATA.fields = {
  DEPOSITTYPEDATA_TYPE_FIELD,
  DEPOSITTYPEDATA_EXPIRETIME_FIELD,
  DEPOSITTYPEDATA_STARTTIME_FIELD,
  DEPOSITTYPEDATA_STATE_FIELD,
  DEPOSITTYPEDATA_INVALID_FIELD
}
DEPOSITTYPEDATA.is_extendable = false
DEPOSITTYPEDATA.extensions = {}
DEPOSITCARDDATA_ITEMID_FIELD.name = "itemid"
DEPOSITCARDDATA_ITEMID_FIELD.full_name = ".Cmd.DepositCardData.itemid"
DEPOSITCARDDATA_ITEMID_FIELD.number = 1
DEPOSITCARDDATA_ITEMID_FIELD.index = 0
DEPOSITCARDDATA_ITEMID_FIELD.label = 1
DEPOSITCARDDATA_ITEMID_FIELD.has_default_value = false
DEPOSITCARDDATA_ITEMID_FIELD.default_value = 0
DEPOSITCARDDATA_ITEMID_FIELD.type = 13
DEPOSITCARDDATA_ITEMID_FIELD.cpp_type = 3
DEPOSITCARDDATA_ISUSED_FIELD.name = "isused"
DEPOSITCARDDATA_ISUSED_FIELD.full_name = ".Cmd.DepositCardData.isused"
DEPOSITCARDDATA_ISUSED_FIELD.number = 2
DEPOSITCARDDATA_ISUSED_FIELD.index = 1
DEPOSITCARDDATA_ISUSED_FIELD.label = 1
DEPOSITCARDDATA_ISUSED_FIELD.has_default_value = true
DEPOSITCARDDATA_ISUSED_FIELD.default_value = false
DEPOSITCARDDATA_ISUSED_FIELD.type = 8
DEPOSITCARDDATA_ISUSED_FIELD.cpp_type = 7
DEPOSITCARDDATA.name = "DepositCardData"
DEPOSITCARDDATA.full_name = ".Cmd.DepositCardData"
DEPOSITCARDDATA.nested_types = {}
DEPOSITCARDDATA.enum_types = {}
DEPOSITCARDDATA.fields = {
  DEPOSITCARDDATA_ITEMID_FIELD,
  DEPOSITCARDDATA_ISUSED_FIELD
}
DEPOSITCARDDATA.is_extendable = false
DEPOSITCARDDATA.extensions = {}
CHARGEQUERYCMD_CMD_FIELD.name = "cmd"
CHARGEQUERYCMD_CMD_FIELD.full_name = ".Cmd.ChargeQueryCmd.cmd"
CHARGEQUERYCMD_CMD_FIELD.number = 1
CHARGEQUERYCMD_CMD_FIELD.index = 0
CHARGEQUERYCMD_CMD_FIELD.label = 1
CHARGEQUERYCMD_CMD_FIELD.has_default_value = true
CHARGEQUERYCMD_CMD_FIELD.default_value = 25
CHARGEQUERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHARGEQUERYCMD_CMD_FIELD.type = 14
CHARGEQUERYCMD_CMD_FIELD.cpp_type = 8
CHARGEQUERYCMD_PARAM_FIELD.name = "param"
CHARGEQUERYCMD_PARAM_FIELD.full_name = ".Cmd.ChargeQueryCmd.param"
CHARGEQUERYCMD_PARAM_FIELD.number = 2
CHARGEQUERYCMD_PARAM_FIELD.index = 1
CHARGEQUERYCMD_PARAM_FIELD.label = 1
CHARGEQUERYCMD_PARAM_FIELD.has_default_value = true
CHARGEQUERYCMD_PARAM_FIELD.default_value = 8
CHARGEQUERYCMD_PARAM_FIELD.enum_type = EVENTPARAM
CHARGEQUERYCMD_PARAM_FIELD.type = 14
CHARGEQUERYCMD_PARAM_FIELD.cpp_type = 8
CHARGEQUERYCMD_DATA_ID_FIELD.name = "data_id"
CHARGEQUERYCMD_DATA_ID_FIELD.full_name = ".Cmd.ChargeQueryCmd.data_id"
CHARGEQUERYCMD_DATA_ID_FIELD.number = 3
CHARGEQUERYCMD_DATA_ID_FIELD.index = 2
CHARGEQUERYCMD_DATA_ID_FIELD.label = 1
CHARGEQUERYCMD_DATA_ID_FIELD.has_default_value = false
CHARGEQUERYCMD_DATA_ID_FIELD.default_value = 0
CHARGEQUERYCMD_DATA_ID_FIELD.type = 13
CHARGEQUERYCMD_DATA_ID_FIELD.cpp_type = 3
CHARGEQUERYCMD_RET_FIELD.name = "ret"
CHARGEQUERYCMD_RET_FIELD.full_name = ".Cmd.ChargeQueryCmd.ret"
CHARGEQUERYCMD_RET_FIELD.number = 4
CHARGEQUERYCMD_RET_FIELD.index = 3
CHARGEQUERYCMD_RET_FIELD.label = 1
CHARGEQUERYCMD_RET_FIELD.has_default_value = false
CHARGEQUERYCMD_RET_FIELD.default_value = false
CHARGEQUERYCMD_RET_FIELD.type = 8
CHARGEQUERYCMD_RET_FIELD.cpp_type = 7
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.name = "charged_count"
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.full_name = ".Cmd.ChargeQueryCmd.charged_count"
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.number = 5
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.index = 4
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.label = 1
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.has_default_value = false
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.default_value = 0
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.type = 13
CHARGEQUERYCMD_CHARGED_COUNT_FIELD.cpp_type = 3
CHARGEQUERYCMD.name = "ChargeQueryCmd"
CHARGEQUERYCMD.full_name = ".Cmd.ChargeQueryCmd"
CHARGEQUERYCMD.nested_types = {}
CHARGEQUERYCMD.enum_types = {}
CHARGEQUERYCMD.fields = {
  CHARGEQUERYCMD_CMD_FIELD,
  CHARGEQUERYCMD_PARAM_FIELD,
  CHARGEQUERYCMD_DATA_ID_FIELD,
  CHARGEQUERYCMD_RET_FIELD,
  CHARGEQUERYCMD_CHARGED_COUNT_FIELD
}
CHARGEQUERYCMD.is_extendable = false
CHARGEQUERYCMD.extensions = {}
DEPOSITCARDINFO_CMD_FIELD.name = "cmd"
DEPOSITCARDINFO_CMD_FIELD.full_name = ".Cmd.DepositCardInfo.cmd"
DEPOSITCARDINFO_CMD_FIELD.number = 1
DEPOSITCARDINFO_CMD_FIELD.index = 0
DEPOSITCARDINFO_CMD_FIELD.label = 1
DEPOSITCARDINFO_CMD_FIELD.has_default_value = true
DEPOSITCARDINFO_CMD_FIELD.default_value = 25
DEPOSITCARDINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DEPOSITCARDINFO_CMD_FIELD.type = 14
DEPOSITCARDINFO_CMD_FIELD.cpp_type = 8
DEPOSITCARDINFO_PARAM_FIELD.name = "param"
DEPOSITCARDINFO_PARAM_FIELD.full_name = ".Cmd.DepositCardInfo.param"
DEPOSITCARDINFO_PARAM_FIELD.number = 2
DEPOSITCARDINFO_PARAM_FIELD.index = 1
DEPOSITCARDINFO_PARAM_FIELD.label = 1
DEPOSITCARDINFO_PARAM_FIELD.has_default_value = true
DEPOSITCARDINFO_PARAM_FIELD.default_value = 9
DEPOSITCARDINFO_PARAM_FIELD.enum_type = EVENTPARAM
DEPOSITCARDINFO_PARAM_FIELD.type = 14
DEPOSITCARDINFO_PARAM_FIELD.cpp_type = 8
DEPOSITCARDINFO_CARD_DATAS_FIELD.name = "card_datas"
DEPOSITCARDINFO_CARD_DATAS_FIELD.full_name = ".Cmd.DepositCardInfo.card_datas"
DEPOSITCARDINFO_CARD_DATAS_FIELD.number = 3
DEPOSITCARDINFO_CARD_DATAS_FIELD.index = 2
DEPOSITCARDINFO_CARD_DATAS_FIELD.label = 3
DEPOSITCARDINFO_CARD_DATAS_FIELD.has_default_value = false
DEPOSITCARDINFO_CARD_DATAS_FIELD.default_value = {}
DEPOSITCARDINFO_CARD_DATAS_FIELD.message_type = DEPOSITTYPEDATA
DEPOSITCARDINFO_CARD_DATAS_FIELD.type = 11
DEPOSITCARDINFO_CARD_DATAS_FIELD.cpp_type = 10
DEPOSITCARDINFO.name = "DepositCardInfo"
DEPOSITCARDINFO.full_name = ".Cmd.DepositCardInfo"
DEPOSITCARDINFO.nested_types = {}
DEPOSITCARDINFO.enum_types = {}
DEPOSITCARDINFO.fields = {
  DEPOSITCARDINFO_CMD_FIELD,
  DEPOSITCARDINFO_PARAM_FIELD,
  DEPOSITCARDINFO_CARD_DATAS_FIELD
}
DEPOSITCARDINFO.is_extendable = false
DEPOSITCARDINFO.extensions = {}
DELTRANSFORMUSEREVENT_CMD_FIELD.name = "cmd"
DELTRANSFORMUSEREVENT_CMD_FIELD.full_name = ".Cmd.DelTransformUserEvent.cmd"
DELTRANSFORMUSEREVENT_CMD_FIELD.number = 1
DELTRANSFORMUSEREVENT_CMD_FIELD.index = 0
DELTRANSFORMUSEREVENT_CMD_FIELD.label = 1
DELTRANSFORMUSEREVENT_CMD_FIELD.has_default_value = true
DELTRANSFORMUSEREVENT_CMD_FIELD.default_value = 25
DELTRANSFORMUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DELTRANSFORMUSEREVENT_CMD_FIELD.type = 14
DELTRANSFORMUSEREVENT_CMD_FIELD.cpp_type = 8
DELTRANSFORMUSEREVENT_PARAM_FIELD.name = "param"
DELTRANSFORMUSEREVENT_PARAM_FIELD.full_name = ".Cmd.DelTransformUserEvent.param"
DELTRANSFORMUSEREVENT_PARAM_FIELD.number = 2
DELTRANSFORMUSEREVENT_PARAM_FIELD.index = 1
DELTRANSFORMUSEREVENT_PARAM_FIELD.label = 1
DELTRANSFORMUSEREVENT_PARAM_FIELD.has_default_value = true
DELTRANSFORMUSEREVENT_PARAM_FIELD.default_value = 10
DELTRANSFORMUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
DELTRANSFORMUSEREVENT_PARAM_FIELD.type = 14
DELTRANSFORMUSEREVENT_PARAM_FIELD.cpp_type = 8
DELTRANSFORMUSEREVENT.name = "DelTransformUserEvent"
DELTRANSFORMUSEREVENT.full_name = ".Cmd.DelTransformUserEvent"
DELTRANSFORMUSEREVENT.nested_types = {}
DELTRANSFORMUSEREVENT.enum_types = {}
DELTRANSFORMUSEREVENT.fields = {
  DELTRANSFORMUSEREVENT_CMD_FIELD,
  DELTRANSFORMUSEREVENT_PARAM_FIELD
}
DELTRANSFORMUSEREVENT.is_extendable = false
DELTRANSFORMUSEREVENT.extensions = {}
INVITECATFAILUSEREVENT_CMD_FIELD.name = "cmd"
INVITECATFAILUSEREVENT_CMD_FIELD.full_name = ".Cmd.InviteCatFailUserEvent.cmd"
INVITECATFAILUSEREVENT_CMD_FIELD.number = 1
INVITECATFAILUSEREVENT_CMD_FIELD.index = 0
INVITECATFAILUSEREVENT_CMD_FIELD.label = 1
INVITECATFAILUSEREVENT_CMD_FIELD.has_default_value = true
INVITECATFAILUSEREVENT_CMD_FIELD.default_value = 25
INVITECATFAILUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITECATFAILUSEREVENT_CMD_FIELD.type = 14
INVITECATFAILUSEREVENT_CMD_FIELD.cpp_type = 8
INVITECATFAILUSEREVENT_PARAM_FIELD.name = "param"
INVITECATFAILUSEREVENT_PARAM_FIELD.full_name = ".Cmd.InviteCatFailUserEvent.param"
INVITECATFAILUSEREVENT_PARAM_FIELD.number = 2
INVITECATFAILUSEREVENT_PARAM_FIELD.index = 1
INVITECATFAILUSEREVENT_PARAM_FIELD.label = 1
INVITECATFAILUSEREVENT_PARAM_FIELD.has_default_value = true
INVITECATFAILUSEREVENT_PARAM_FIELD.default_value = 11
INVITECATFAILUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
INVITECATFAILUSEREVENT_PARAM_FIELD.type = 14
INVITECATFAILUSEREVENT_PARAM_FIELD.cpp_type = 8
INVITECATFAILUSEREVENT.name = "InviteCatFailUserEvent"
INVITECATFAILUSEREVENT.full_name = ".Cmd.InviteCatFailUserEvent"
INVITECATFAILUSEREVENT.nested_types = {}
INVITECATFAILUSEREVENT.enum_types = {}
INVITECATFAILUSEREVENT.fields = {
  INVITECATFAILUSEREVENT_CMD_FIELD,
  INVITECATFAILUSEREVENT_PARAM_FIELD
}
INVITECATFAILUSEREVENT.is_extendable = false
INVITECATFAILUSEREVENT.extensions = {}
TRIGNPCFUNCUSEREVENT_CMD_FIELD.name = "cmd"
TRIGNPCFUNCUSEREVENT_CMD_FIELD.full_name = ".Cmd.TrigNpcFuncUserEvent.cmd"
TRIGNPCFUNCUSEREVENT_CMD_FIELD.number = 1
TRIGNPCFUNCUSEREVENT_CMD_FIELD.index = 0
TRIGNPCFUNCUSEREVENT_CMD_FIELD.label = 1
TRIGNPCFUNCUSEREVENT_CMD_FIELD.has_default_value = true
TRIGNPCFUNCUSEREVENT_CMD_FIELD.default_value = 25
TRIGNPCFUNCUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRIGNPCFUNCUSEREVENT_CMD_FIELD.type = 14
TRIGNPCFUNCUSEREVENT_CMD_FIELD.cpp_type = 8
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.name = "param"
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.full_name = ".Cmd.TrigNpcFuncUserEvent.param"
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.number = 2
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.index = 1
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.label = 1
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.has_default_value = true
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.default_value = 12
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.type = 14
TRIGNPCFUNCUSEREVENT_PARAM_FIELD.cpp_type = 8
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.name = "npcguid"
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.full_name = ".Cmd.TrigNpcFuncUserEvent.npcguid"
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.number = 3
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.index = 2
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.label = 2
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.has_default_value = false
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.default_value = 0
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.type = 4
TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD.cpp_type = 4
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.name = "funcid"
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.full_name = ".Cmd.TrigNpcFuncUserEvent.funcid"
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.number = 4
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.index = 3
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.label = 2
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.has_default_value = false
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.default_value = 0
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.type = 13
TRIGNPCFUNCUSEREVENT_FUNCID_FIELD.cpp_type = 3
TRIGNPCFUNCUSEREVENT.name = "TrigNpcFuncUserEvent"
TRIGNPCFUNCUSEREVENT.full_name = ".Cmd.TrigNpcFuncUserEvent"
TRIGNPCFUNCUSEREVENT.nested_types = {}
TRIGNPCFUNCUSEREVENT.enum_types = {}
TRIGNPCFUNCUSEREVENT.fields = {
  TRIGNPCFUNCUSEREVENT_CMD_FIELD,
  TRIGNPCFUNCUSEREVENT_PARAM_FIELD,
  TRIGNPCFUNCUSEREVENT_NPCGUID_FIELD,
  TRIGNPCFUNCUSEREVENT_FUNCID_FIELD
}
TRIGNPCFUNCUSEREVENT.is_extendable = false
TRIGNPCFUNCUSEREVENT.extensions = {}
SYSTEMSTRINGUSEREVENT_CMD_FIELD.name = "cmd"
SYSTEMSTRINGUSEREVENT_CMD_FIELD.full_name = ".Cmd.SystemStringUserEvent.cmd"
SYSTEMSTRINGUSEREVENT_CMD_FIELD.number = 1
SYSTEMSTRINGUSEREVENT_CMD_FIELD.index = 0
SYSTEMSTRINGUSEREVENT_CMD_FIELD.label = 1
SYSTEMSTRINGUSEREVENT_CMD_FIELD.has_default_value = true
SYSTEMSTRINGUSEREVENT_CMD_FIELD.default_value = 25
SYSTEMSTRINGUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYSTEMSTRINGUSEREVENT_CMD_FIELD.type = 14
SYSTEMSTRINGUSEREVENT_CMD_FIELD.cpp_type = 8
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.name = "param"
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SystemStringUserEvent.param"
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.number = 2
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.index = 1
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.label = 1
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.has_default_value = true
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.default_value = 13
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.type = 14
SYSTEMSTRINGUSEREVENT_PARAM_FIELD.cpp_type = 8
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.name = "etype"
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.full_name = ".Cmd.SystemStringUserEvent.etype"
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.number = 3
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.index = 2
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.label = 1
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.has_default_value = true
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.default_value = 0
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.enum_type = ESYSTEMSTRINGTYPE
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.type = 14
SYSTEMSTRINGUSEREVENT_ETYPE_FIELD.cpp_type = 8
SYSTEMSTRINGUSEREVENT.name = "SystemStringUserEvent"
SYSTEMSTRINGUSEREVENT.full_name = ".Cmd.SystemStringUserEvent"
SYSTEMSTRINGUSEREVENT.nested_types = {}
SYSTEMSTRINGUSEREVENT.enum_types = {}
SYSTEMSTRINGUSEREVENT.fields = {
  SYSTEMSTRINGUSEREVENT_CMD_FIELD,
  SYSTEMSTRINGUSEREVENT_PARAM_FIELD,
  SYSTEMSTRINGUSEREVENT_ETYPE_FIELD
}
SYSTEMSTRINGUSEREVENT.is_extendable = false
SYSTEMSTRINGUSEREVENT.extensions = {}
HANDCATUSEREVENT_CMD_FIELD.name = "cmd"
HANDCATUSEREVENT_CMD_FIELD.full_name = ".Cmd.HandCatUserEvent.cmd"
HANDCATUSEREVENT_CMD_FIELD.number = 1
HANDCATUSEREVENT_CMD_FIELD.index = 0
HANDCATUSEREVENT_CMD_FIELD.label = 1
HANDCATUSEREVENT_CMD_FIELD.has_default_value = true
HANDCATUSEREVENT_CMD_FIELD.default_value = 25
HANDCATUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HANDCATUSEREVENT_CMD_FIELD.type = 14
HANDCATUSEREVENT_CMD_FIELD.cpp_type = 8
HANDCATUSEREVENT_PARAM_FIELD.name = "param"
HANDCATUSEREVENT_PARAM_FIELD.full_name = ".Cmd.HandCatUserEvent.param"
HANDCATUSEREVENT_PARAM_FIELD.number = 2
HANDCATUSEREVENT_PARAM_FIELD.index = 1
HANDCATUSEREVENT_PARAM_FIELD.label = 1
HANDCATUSEREVENT_PARAM_FIELD.has_default_value = true
HANDCATUSEREVENT_PARAM_FIELD.default_value = 14
HANDCATUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
HANDCATUSEREVENT_PARAM_FIELD.type = 14
HANDCATUSEREVENT_PARAM_FIELD.cpp_type = 8
HANDCATUSEREVENT_CATGUID_FIELD.name = "catguid"
HANDCATUSEREVENT_CATGUID_FIELD.full_name = ".Cmd.HandCatUserEvent.catguid"
HANDCATUSEREVENT_CATGUID_FIELD.number = 3
HANDCATUSEREVENT_CATGUID_FIELD.index = 2
HANDCATUSEREVENT_CATGUID_FIELD.label = 2
HANDCATUSEREVENT_CATGUID_FIELD.has_default_value = false
HANDCATUSEREVENT_CATGUID_FIELD.default_value = 0
HANDCATUSEREVENT_CATGUID_FIELD.type = 4
HANDCATUSEREVENT_CATGUID_FIELD.cpp_type = 4
HANDCATUSEREVENT_BREAKUP_FIELD.name = "breakup"
HANDCATUSEREVENT_BREAKUP_FIELD.full_name = ".Cmd.HandCatUserEvent.breakup"
HANDCATUSEREVENT_BREAKUP_FIELD.number = 4
HANDCATUSEREVENT_BREAKUP_FIELD.index = 3
HANDCATUSEREVENT_BREAKUP_FIELD.label = 1
HANDCATUSEREVENT_BREAKUP_FIELD.has_default_value = true
HANDCATUSEREVENT_BREAKUP_FIELD.default_value = false
HANDCATUSEREVENT_BREAKUP_FIELD.type = 8
HANDCATUSEREVENT_BREAKUP_FIELD.cpp_type = 7
HANDCATUSEREVENT.name = "HandCatUserEvent"
HANDCATUSEREVENT.full_name = ".Cmd.HandCatUserEvent"
HANDCATUSEREVENT.nested_types = {}
HANDCATUSEREVENT.enum_types = {}
HANDCATUSEREVENT.fields = {
  HANDCATUSEREVENT_CMD_FIELD,
  HANDCATUSEREVENT_PARAM_FIELD,
  HANDCATUSEREVENT_CATGUID_FIELD,
  HANDCATUSEREVENT_BREAKUP_FIELD
}
HANDCATUSEREVENT.is_extendable = false
HANDCATUSEREVENT.extensions = {}
CHANGETITLE_CMD_FIELD.name = "cmd"
CHANGETITLE_CMD_FIELD.full_name = ".Cmd.ChangeTitle.cmd"
CHANGETITLE_CMD_FIELD.number = 1
CHANGETITLE_CMD_FIELD.index = 0
CHANGETITLE_CMD_FIELD.label = 1
CHANGETITLE_CMD_FIELD.has_default_value = true
CHANGETITLE_CMD_FIELD.default_value = 25
CHANGETITLE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHANGETITLE_CMD_FIELD.type = 14
CHANGETITLE_CMD_FIELD.cpp_type = 8
CHANGETITLE_PARAM_FIELD.name = "param"
CHANGETITLE_PARAM_FIELD.full_name = ".Cmd.ChangeTitle.param"
CHANGETITLE_PARAM_FIELD.number = 2
CHANGETITLE_PARAM_FIELD.index = 1
CHANGETITLE_PARAM_FIELD.label = 1
CHANGETITLE_PARAM_FIELD.has_default_value = true
CHANGETITLE_PARAM_FIELD.default_value = 15
CHANGETITLE_PARAM_FIELD.enum_type = EVENTPARAM
CHANGETITLE_PARAM_FIELD.type = 14
CHANGETITLE_PARAM_FIELD.cpp_type = 8
CHANGETITLE_TITLE_DATA_FIELD.name = "title_data"
CHANGETITLE_TITLE_DATA_FIELD.full_name = ".Cmd.ChangeTitle.title_data"
CHANGETITLE_TITLE_DATA_FIELD.number = 3
CHANGETITLE_TITLE_DATA_FIELD.index = 2
CHANGETITLE_TITLE_DATA_FIELD.label = 1
CHANGETITLE_TITLE_DATA_FIELD.has_default_value = false
CHANGETITLE_TITLE_DATA_FIELD.default_value = nil
CHANGETITLE_TITLE_DATA_FIELD.message_type = TITLEDATA
CHANGETITLE_TITLE_DATA_FIELD.type = 11
CHANGETITLE_TITLE_DATA_FIELD.cpp_type = 10
CHANGETITLE_CHARID_FIELD.name = "charid"
CHANGETITLE_CHARID_FIELD.full_name = ".Cmd.ChangeTitle.charid"
CHANGETITLE_CHARID_FIELD.number = 4
CHANGETITLE_CHARID_FIELD.index = 3
CHANGETITLE_CHARID_FIELD.label = 1
CHANGETITLE_CHARID_FIELD.has_default_value = false
CHANGETITLE_CHARID_FIELD.default_value = 0
CHANGETITLE_CHARID_FIELD.type = 4
CHANGETITLE_CHARID_FIELD.cpp_type = 4
CHANGETITLE.name = "ChangeTitle"
CHANGETITLE.full_name = ".Cmd.ChangeTitle"
CHANGETITLE.nested_types = {}
CHANGETITLE.enum_types = {}
CHANGETITLE.fields = {
  CHANGETITLE_CMD_FIELD,
  CHANGETITLE_PARAM_FIELD,
  CHANGETITLE_TITLE_DATA_FIELD,
  CHANGETITLE_CHARID_FIELD
}
CHANGETITLE.is_extendable = false
CHANGETITLE.extensions = {}
CHARGECNTINFO_DATAID_FIELD.name = "dataid"
CHARGECNTINFO_DATAID_FIELD.full_name = ".Cmd.ChargeCntInfo.dataid"
CHARGECNTINFO_DATAID_FIELD.number = 1
CHARGECNTINFO_DATAID_FIELD.index = 0
CHARGECNTINFO_DATAID_FIELD.label = 1
CHARGECNTINFO_DATAID_FIELD.has_default_value = false
CHARGECNTINFO_DATAID_FIELD.default_value = 0
CHARGECNTINFO_DATAID_FIELD.type = 13
CHARGECNTINFO_DATAID_FIELD.cpp_type = 3
CHARGECNTINFO_COUNT_FIELD.name = "count"
CHARGECNTINFO_COUNT_FIELD.full_name = ".Cmd.ChargeCntInfo.count"
CHARGECNTINFO_COUNT_FIELD.number = 2
CHARGECNTINFO_COUNT_FIELD.index = 1
CHARGECNTINFO_COUNT_FIELD.label = 1
CHARGECNTINFO_COUNT_FIELD.has_default_value = false
CHARGECNTINFO_COUNT_FIELD.default_value = 0
CHARGECNTINFO_COUNT_FIELD.type = 13
CHARGECNTINFO_COUNT_FIELD.cpp_type = 3
CHARGECNTINFO_LIMIT_FIELD.name = "limit"
CHARGECNTINFO_LIMIT_FIELD.full_name = ".Cmd.ChargeCntInfo.limit"
CHARGECNTINFO_LIMIT_FIELD.number = 3
CHARGECNTINFO_LIMIT_FIELD.index = 2
CHARGECNTINFO_LIMIT_FIELD.label = 1
CHARGECNTINFO_LIMIT_FIELD.has_default_value = true
CHARGECNTINFO_LIMIT_FIELD.default_value = 0
CHARGECNTINFO_LIMIT_FIELD.type = 13
CHARGECNTINFO_LIMIT_FIELD.cpp_type = 3
CHARGECNTINFO_DAILYCOUNT_FIELD.name = "dailycount"
CHARGECNTINFO_DAILYCOUNT_FIELD.full_name = ".Cmd.ChargeCntInfo.dailycount"
CHARGECNTINFO_DAILYCOUNT_FIELD.number = 4
CHARGECNTINFO_DAILYCOUNT_FIELD.index = 3
CHARGECNTINFO_DAILYCOUNT_FIELD.label = 1
CHARGECNTINFO_DAILYCOUNT_FIELD.has_default_value = false
CHARGECNTINFO_DAILYCOUNT_FIELD.default_value = 0
CHARGECNTINFO_DAILYCOUNT_FIELD.type = 13
CHARGECNTINFO_DAILYCOUNT_FIELD.cpp_type = 3
CHARGECNTINFO.name = "ChargeCntInfo"
CHARGECNTINFO.full_name = ".Cmd.ChargeCntInfo"
CHARGECNTINFO.nested_types = {}
CHARGECNTINFO.enum_types = {}
CHARGECNTINFO.fields = {
  CHARGECNTINFO_DATAID_FIELD,
  CHARGECNTINFO_COUNT_FIELD,
  CHARGECNTINFO_LIMIT_FIELD,
  CHARGECNTINFO_DAILYCOUNT_FIELD
}
CHARGECNTINFO.is_extendable = false
CHARGECNTINFO.extensions = {}
QUERYCHARGECNT_CMD_FIELD.name = "cmd"
QUERYCHARGECNT_CMD_FIELD.full_name = ".Cmd.QueryChargeCnt.cmd"
QUERYCHARGECNT_CMD_FIELD.number = 1
QUERYCHARGECNT_CMD_FIELD.index = 0
QUERYCHARGECNT_CMD_FIELD.label = 1
QUERYCHARGECNT_CMD_FIELD.has_default_value = true
QUERYCHARGECNT_CMD_FIELD.default_value = 25
QUERYCHARGECNT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYCHARGECNT_CMD_FIELD.type = 14
QUERYCHARGECNT_CMD_FIELD.cpp_type = 8
QUERYCHARGECNT_PARAM_FIELD.name = "param"
QUERYCHARGECNT_PARAM_FIELD.full_name = ".Cmd.QueryChargeCnt.param"
QUERYCHARGECNT_PARAM_FIELD.number = 2
QUERYCHARGECNT_PARAM_FIELD.index = 1
QUERYCHARGECNT_PARAM_FIELD.label = 1
QUERYCHARGECNT_PARAM_FIELD.has_default_value = true
QUERYCHARGECNT_PARAM_FIELD.default_value = 16
QUERYCHARGECNT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYCHARGECNT_PARAM_FIELD.type = 14
QUERYCHARGECNT_PARAM_FIELD.cpp_type = 8
QUERYCHARGECNT_INFO_FIELD.name = "info"
QUERYCHARGECNT_INFO_FIELD.full_name = ".Cmd.QueryChargeCnt.info"
QUERYCHARGECNT_INFO_FIELD.number = 3
QUERYCHARGECNT_INFO_FIELD.index = 2
QUERYCHARGECNT_INFO_FIELD.label = 3
QUERYCHARGECNT_INFO_FIELD.has_default_value = false
QUERYCHARGECNT_INFO_FIELD.default_value = {}
QUERYCHARGECNT_INFO_FIELD.message_type = CHARGECNTINFO
QUERYCHARGECNT_INFO_FIELD.type = 11
QUERYCHARGECNT_INFO_FIELD.cpp_type = 10
QUERYCHARGECNT.name = "QueryChargeCnt"
QUERYCHARGECNT.full_name = ".Cmd.QueryChargeCnt"
QUERYCHARGECNT.nested_types = {}
QUERYCHARGECNT.enum_types = {}
QUERYCHARGECNT.fields = {
  QUERYCHARGECNT_CMD_FIELD,
  QUERYCHARGECNT_PARAM_FIELD,
  QUERYCHARGECNT_INFO_FIELD
}
QUERYCHARGECNT.is_extendable = false
QUERYCHARGECNT.extensions = {}
NTFMONTHCARDEND_CMD_FIELD.name = "cmd"
NTFMONTHCARDEND_CMD_FIELD.full_name = ".Cmd.NTFMonthCardEnd.cmd"
NTFMONTHCARDEND_CMD_FIELD.number = 1
NTFMONTHCARDEND_CMD_FIELD.index = 0
NTFMONTHCARDEND_CMD_FIELD.label = 1
NTFMONTHCARDEND_CMD_FIELD.has_default_value = true
NTFMONTHCARDEND_CMD_FIELD.default_value = 25
NTFMONTHCARDEND_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NTFMONTHCARDEND_CMD_FIELD.type = 14
NTFMONTHCARDEND_CMD_FIELD.cpp_type = 8
NTFMONTHCARDEND_PARAM_FIELD.name = "param"
NTFMONTHCARDEND_PARAM_FIELD.full_name = ".Cmd.NTFMonthCardEnd.param"
NTFMONTHCARDEND_PARAM_FIELD.number = 2
NTFMONTHCARDEND_PARAM_FIELD.index = 1
NTFMONTHCARDEND_PARAM_FIELD.label = 1
NTFMONTHCARDEND_PARAM_FIELD.has_default_value = true
NTFMONTHCARDEND_PARAM_FIELD.default_value = 17
NTFMONTHCARDEND_PARAM_FIELD.enum_type = EVENTPARAM
NTFMONTHCARDEND_PARAM_FIELD.type = 14
NTFMONTHCARDEND_PARAM_FIELD.cpp_type = 8
NTFMONTHCARDEND.name = "NTFMonthCardEnd"
NTFMONTHCARDEND.full_name = ".Cmd.NTFMonthCardEnd"
NTFMONTHCARDEND.nested_types = {}
NTFMONTHCARDEND.enum_types = {}
NTFMONTHCARDEND.fields = {
  NTFMONTHCARDEND_CMD_FIELD,
  NTFMONTHCARDEND_PARAM_FIELD
}
NTFMONTHCARDEND.is_extendable = false
NTFMONTHCARDEND.extensions = {}
LOVELETTERUSE_CMD_FIELD.name = "cmd"
LOVELETTERUSE_CMD_FIELD.full_name = ".Cmd.LoveLetterUse.cmd"
LOVELETTERUSE_CMD_FIELD.number = 1
LOVELETTERUSE_CMD_FIELD.index = 0
LOVELETTERUSE_CMD_FIELD.label = 1
LOVELETTERUSE_CMD_FIELD.has_default_value = true
LOVELETTERUSE_CMD_FIELD.default_value = 25
LOVELETTERUSE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LOVELETTERUSE_CMD_FIELD.type = 14
LOVELETTERUSE_CMD_FIELD.cpp_type = 8
LOVELETTERUSE_PARAM_FIELD.name = "param"
LOVELETTERUSE_PARAM_FIELD.full_name = ".Cmd.LoveLetterUse.param"
LOVELETTERUSE_PARAM_FIELD.number = 2
LOVELETTERUSE_PARAM_FIELD.index = 1
LOVELETTERUSE_PARAM_FIELD.label = 1
LOVELETTERUSE_PARAM_FIELD.has_default_value = true
LOVELETTERUSE_PARAM_FIELD.default_value = 18
LOVELETTERUSE_PARAM_FIELD.enum_type = EVENTPARAM
LOVELETTERUSE_PARAM_FIELD.type = 14
LOVELETTERUSE_PARAM_FIELD.cpp_type = 8
LOVELETTERUSE_ITEMGUID_FIELD.name = "itemguid"
LOVELETTERUSE_ITEMGUID_FIELD.full_name = ".Cmd.LoveLetterUse.itemguid"
LOVELETTERUSE_ITEMGUID_FIELD.number = 3
LOVELETTERUSE_ITEMGUID_FIELD.index = 2
LOVELETTERUSE_ITEMGUID_FIELD.label = 1
LOVELETTERUSE_ITEMGUID_FIELD.has_default_value = false
LOVELETTERUSE_ITEMGUID_FIELD.default_value = ""
LOVELETTERUSE_ITEMGUID_FIELD.type = 9
LOVELETTERUSE_ITEMGUID_FIELD.cpp_type = 9
LOVELETTERUSE_TARGETS_FIELD.name = "targets"
LOVELETTERUSE_TARGETS_FIELD.full_name = ".Cmd.LoveLetterUse.targets"
LOVELETTERUSE_TARGETS_FIELD.number = 4
LOVELETTERUSE_TARGETS_FIELD.index = 3
LOVELETTERUSE_TARGETS_FIELD.label = 1
LOVELETTERUSE_TARGETS_FIELD.has_default_value = false
LOVELETTERUSE_TARGETS_FIELD.default_value = 0
LOVELETTERUSE_TARGETS_FIELD.type = 4
LOVELETTERUSE_TARGETS_FIELD.cpp_type = 4
LOVELETTERUSE_CONTENT_FIELD.name = "content"
LOVELETTERUSE_CONTENT_FIELD.full_name = ".Cmd.LoveLetterUse.content"
LOVELETTERUSE_CONTENT_FIELD.number = 5
LOVELETTERUSE_CONTENT_FIELD.index = 4
LOVELETTERUSE_CONTENT_FIELD.label = 1
LOVELETTERUSE_CONTENT_FIELD.has_default_value = false
LOVELETTERUSE_CONTENT_FIELD.default_value = ""
LOVELETTERUSE_CONTENT_FIELD.type = 9
LOVELETTERUSE_CONTENT_FIELD.cpp_type = 9
LOVELETTERUSE_TYPE_FIELD.name = "type"
LOVELETTERUSE_TYPE_FIELD.full_name = ".Cmd.LoveLetterUse.type"
LOVELETTERUSE_TYPE_FIELD.number = 6
LOVELETTERUSE_TYPE_FIELD.index = 5
LOVELETTERUSE_TYPE_FIELD.label = 1
LOVELETTERUSE_TYPE_FIELD.has_default_value = true
LOVELETTERUSE_TYPE_FIELD.default_value = 3
LOVELETTERUSE_TYPE_FIELD.enum_type = SCENEITEM_PB_ELETTERTYPE
LOVELETTERUSE_TYPE_FIELD.type = 14
LOVELETTERUSE_TYPE_FIELD.cpp_type = 8
LOVELETTERUSE.name = "LoveLetterUse"
LOVELETTERUSE.full_name = ".Cmd.LoveLetterUse"
LOVELETTERUSE.nested_types = {}
LOVELETTERUSE.enum_types = {}
LOVELETTERUSE.fields = {
  LOVELETTERUSE_CMD_FIELD,
  LOVELETTERUSE_PARAM_FIELD,
  LOVELETTERUSE_ITEMGUID_FIELD,
  LOVELETTERUSE_TARGETS_FIELD,
  LOVELETTERUSE_CONTENT_FIELD,
  LOVELETTERUSE_TYPE_FIELD
}
LOVELETTERUSE.is_extendable = false
LOVELETTERUSE.extensions = {}
ACTIVITYCNTITEM_ACTIVITYID_FIELD.name = "activityid"
ACTIVITYCNTITEM_ACTIVITYID_FIELD.full_name = ".Cmd.ActivityCntItem.activityid"
ACTIVITYCNTITEM_ACTIVITYID_FIELD.number = 1
ACTIVITYCNTITEM_ACTIVITYID_FIELD.index = 0
ACTIVITYCNTITEM_ACTIVITYID_FIELD.label = 1
ACTIVITYCNTITEM_ACTIVITYID_FIELD.has_default_value = false
ACTIVITYCNTITEM_ACTIVITYID_FIELD.default_value = 0
ACTIVITYCNTITEM_ACTIVITYID_FIELD.type = 13
ACTIVITYCNTITEM_ACTIVITYID_FIELD.cpp_type = 3
ACTIVITYCNTITEM_COUNT_FIELD.name = "count"
ACTIVITYCNTITEM_COUNT_FIELD.full_name = ".Cmd.ActivityCntItem.count"
ACTIVITYCNTITEM_COUNT_FIELD.number = 2
ACTIVITYCNTITEM_COUNT_FIELD.index = 1
ACTIVITYCNTITEM_COUNT_FIELD.label = 1
ACTIVITYCNTITEM_COUNT_FIELD.has_default_value = false
ACTIVITYCNTITEM_COUNT_FIELD.default_value = 0
ACTIVITYCNTITEM_COUNT_FIELD.type = 13
ACTIVITYCNTITEM_COUNT_FIELD.cpp_type = 3
ACTIVITYCNTITEM.name = "ActivityCntItem"
ACTIVITYCNTITEM.full_name = ".Cmd.ActivityCntItem"
ACTIVITYCNTITEM.nested_types = {}
ACTIVITYCNTITEM.enum_types = {}
ACTIVITYCNTITEM.fields = {
  ACTIVITYCNTITEM_ACTIVITYID_FIELD,
  ACTIVITYCNTITEM_COUNT_FIELD
}
ACTIVITYCNTITEM.is_extendable = false
ACTIVITYCNTITEM.extensions = {}
QUERYACTIVITYCNT_CMD_FIELD.name = "cmd"
QUERYACTIVITYCNT_CMD_FIELD.full_name = ".Cmd.QueryActivityCnt.cmd"
QUERYACTIVITYCNT_CMD_FIELD.number = 1
QUERYACTIVITYCNT_CMD_FIELD.index = 0
QUERYACTIVITYCNT_CMD_FIELD.label = 1
QUERYACTIVITYCNT_CMD_FIELD.has_default_value = true
QUERYACTIVITYCNT_CMD_FIELD.default_value = 25
QUERYACTIVITYCNT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYACTIVITYCNT_CMD_FIELD.type = 14
QUERYACTIVITYCNT_CMD_FIELD.cpp_type = 8
QUERYACTIVITYCNT_PARAM_FIELD.name = "param"
QUERYACTIVITYCNT_PARAM_FIELD.full_name = ".Cmd.QueryActivityCnt.param"
QUERYACTIVITYCNT_PARAM_FIELD.number = 2
QUERYACTIVITYCNT_PARAM_FIELD.index = 1
QUERYACTIVITYCNT_PARAM_FIELD.label = 1
QUERYACTIVITYCNT_PARAM_FIELD.has_default_value = true
QUERYACTIVITYCNT_PARAM_FIELD.default_value = 19
QUERYACTIVITYCNT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYACTIVITYCNT_PARAM_FIELD.type = 14
QUERYACTIVITYCNT_PARAM_FIELD.cpp_type = 8
QUERYACTIVITYCNT_INFO_FIELD.name = "info"
QUERYACTIVITYCNT_INFO_FIELD.full_name = ".Cmd.QueryActivityCnt.info"
QUERYACTIVITYCNT_INFO_FIELD.number = 3
QUERYACTIVITYCNT_INFO_FIELD.index = 2
QUERYACTIVITYCNT_INFO_FIELD.label = 3
QUERYACTIVITYCNT_INFO_FIELD.has_default_value = false
QUERYACTIVITYCNT_INFO_FIELD.default_value = {}
QUERYACTIVITYCNT_INFO_FIELD.message_type = ACTIVITYCNTITEM
QUERYACTIVITYCNT_INFO_FIELD.type = 11
QUERYACTIVITYCNT_INFO_FIELD.cpp_type = 10
QUERYACTIVITYCNT.name = "QueryActivityCnt"
QUERYACTIVITYCNT.full_name = ".Cmd.QueryActivityCnt"
QUERYACTIVITYCNT.nested_types = {}
QUERYACTIVITYCNT.enum_types = {}
QUERYACTIVITYCNT.fields = {
  QUERYACTIVITYCNT_CMD_FIELD,
  QUERYACTIVITYCNT_PARAM_FIELD,
  QUERYACTIVITYCNT_INFO_FIELD
}
QUERYACTIVITYCNT.is_extendable = false
QUERYACTIVITYCNT.extensions = {}
UPDATEACTIVITYCNT_CMD_FIELD.name = "cmd"
UPDATEACTIVITYCNT_CMD_FIELD.full_name = ".Cmd.UpdateActivityCnt.cmd"
UPDATEACTIVITYCNT_CMD_FIELD.number = 1
UPDATEACTIVITYCNT_CMD_FIELD.index = 0
UPDATEACTIVITYCNT_CMD_FIELD.label = 1
UPDATEACTIVITYCNT_CMD_FIELD.has_default_value = true
UPDATEACTIVITYCNT_CMD_FIELD.default_value = 25
UPDATEACTIVITYCNT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEACTIVITYCNT_CMD_FIELD.type = 14
UPDATEACTIVITYCNT_CMD_FIELD.cpp_type = 8
UPDATEACTIVITYCNT_PARAM_FIELD.name = "param"
UPDATEACTIVITYCNT_PARAM_FIELD.full_name = ".Cmd.UpdateActivityCnt.param"
UPDATEACTIVITYCNT_PARAM_FIELD.number = 2
UPDATEACTIVITYCNT_PARAM_FIELD.index = 1
UPDATEACTIVITYCNT_PARAM_FIELD.label = 1
UPDATEACTIVITYCNT_PARAM_FIELD.has_default_value = true
UPDATEACTIVITYCNT_PARAM_FIELD.default_value = 20
UPDATEACTIVITYCNT_PARAM_FIELD.enum_type = EVENTPARAM
UPDATEACTIVITYCNT_PARAM_FIELD.type = 14
UPDATEACTIVITYCNT_PARAM_FIELD.cpp_type = 8
UPDATEACTIVITYCNT_INFO_FIELD.name = "info"
UPDATEACTIVITYCNT_INFO_FIELD.full_name = ".Cmd.UpdateActivityCnt.info"
UPDATEACTIVITYCNT_INFO_FIELD.number = 3
UPDATEACTIVITYCNT_INFO_FIELD.index = 2
UPDATEACTIVITYCNT_INFO_FIELD.label = 1
UPDATEACTIVITYCNT_INFO_FIELD.has_default_value = false
UPDATEACTIVITYCNT_INFO_FIELD.default_value = nil
UPDATEACTIVITYCNT_INFO_FIELD.message_type = ACTIVITYCNTITEM
UPDATEACTIVITYCNT_INFO_FIELD.type = 11
UPDATEACTIVITYCNT_INFO_FIELD.cpp_type = 10
UPDATEACTIVITYCNT.name = "UpdateActivityCnt"
UPDATEACTIVITYCNT.full_name = ".Cmd.UpdateActivityCnt"
UPDATEACTIVITYCNT.nested_types = {}
UPDATEACTIVITYCNT.enum_types = {}
UPDATEACTIVITYCNT.fields = {
  UPDATEACTIVITYCNT_CMD_FIELD,
  UPDATEACTIVITYCNT_PARAM_FIELD,
  UPDATEACTIVITYCNT_INFO_FIELD
}
UPDATEACTIVITYCNT.is_extendable = false
UPDATEACTIVITYCNT.extensions = {}
VERSIONCARDINFO_VERSION_FIELD.name = "version"
VERSIONCARDINFO_VERSION_FIELD.full_name = ".Cmd.VersionCardInfo.version"
VERSIONCARDINFO_VERSION_FIELD.number = 1
VERSIONCARDINFO_VERSION_FIELD.index = 0
VERSIONCARDINFO_VERSION_FIELD.label = 1
VERSIONCARDINFO_VERSION_FIELD.has_default_value = false
VERSIONCARDINFO_VERSION_FIELD.default_value = 0
VERSIONCARDINFO_VERSION_FIELD.type = 13
VERSIONCARDINFO_VERSION_FIELD.cpp_type = 3
VERSIONCARDINFO_ID1_FIELD.name = "id1"
VERSIONCARDINFO_ID1_FIELD.full_name = ".Cmd.VersionCardInfo.id1"
VERSIONCARDINFO_ID1_FIELD.number = 2
VERSIONCARDINFO_ID1_FIELD.index = 1
VERSIONCARDINFO_ID1_FIELD.label = 1
VERSIONCARDINFO_ID1_FIELD.has_default_value = false
VERSIONCARDINFO_ID1_FIELD.default_value = 0
VERSIONCARDINFO_ID1_FIELD.type = 13
VERSIONCARDINFO_ID1_FIELD.cpp_type = 3
VERSIONCARDINFO_ID2_FIELD.name = "id2"
VERSIONCARDINFO_ID2_FIELD.full_name = ".Cmd.VersionCardInfo.id2"
VERSIONCARDINFO_ID2_FIELD.number = 3
VERSIONCARDINFO_ID2_FIELD.index = 2
VERSIONCARDINFO_ID2_FIELD.label = 1
VERSIONCARDINFO_ID2_FIELD.has_default_value = false
VERSIONCARDINFO_ID2_FIELD.default_value = 0
VERSIONCARDINFO_ID2_FIELD.type = 13
VERSIONCARDINFO_ID2_FIELD.cpp_type = 3
VERSIONCARDINFO.name = "VersionCardInfo"
VERSIONCARDINFO.full_name = ".Cmd.VersionCardInfo"
VERSIONCARDINFO.nested_types = {}
VERSIONCARDINFO.enum_types = {}
VERSIONCARDINFO.fields = {
  VERSIONCARDINFO_VERSION_FIELD,
  VERSIONCARDINFO_ID1_FIELD,
  VERSIONCARDINFO_ID2_FIELD
}
VERSIONCARDINFO.is_extendable = false
VERSIONCARDINFO.extensions = {}
NTFVERSIONCARDINFO_CMD_FIELD.name = "cmd"
NTFVERSIONCARDINFO_CMD_FIELD.full_name = ".Cmd.NtfVersionCardInfo.cmd"
NTFVERSIONCARDINFO_CMD_FIELD.number = 1
NTFVERSIONCARDINFO_CMD_FIELD.index = 0
NTFVERSIONCARDINFO_CMD_FIELD.label = 1
NTFVERSIONCARDINFO_CMD_FIELD.has_default_value = true
NTFVERSIONCARDINFO_CMD_FIELD.default_value = 25
NTFVERSIONCARDINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NTFVERSIONCARDINFO_CMD_FIELD.type = 14
NTFVERSIONCARDINFO_CMD_FIELD.cpp_type = 8
NTFVERSIONCARDINFO_PARAM_FIELD.name = "param"
NTFVERSIONCARDINFO_PARAM_FIELD.full_name = ".Cmd.NtfVersionCardInfo.param"
NTFVERSIONCARDINFO_PARAM_FIELD.number = 2
NTFVERSIONCARDINFO_PARAM_FIELD.index = 1
NTFVERSIONCARDINFO_PARAM_FIELD.label = 1
NTFVERSIONCARDINFO_PARAM_FIELD.has_default_value = true
NTFVERSIONCARDINFO_PARAM_FIELD.default_value = 23
NTFVERSIONCARDINFO_PARAM_FIELD.enum_type = EVENTPARAM
NTFVERSIONCARDINFO_PARAM_FIELD.type = 14
NTFVERSIONCARDINFO_PARAM_FIELD.cpp_type = 8
NTFVERSIONCARDINFO_INFO_FIELD.name = "info"
NTFVERSIONCARDINFO_INFO_FIELD.full_name = ".Cmd.NtfVersionCardInfo.info"
NTFVERSIONCARDINFO_INFO_FIELD.number = 3
NTFVERSIONCARDINFO_INFO_FIELD.index = 2
NTFVERSIONCARDINFO_INFO_FIELD.label = 3
NTFVERSIONCARDINFO_INFO_FIELD.has_default_value = false
NTFVERSIONCARDINFO_INFO_FIELD.default_value = {}
NTFVERSIONCARDINFO_INFO_FIELD.message_type = VERSIONCARDINFO
NTFVERSIONCARDINFO_INFO_FIELD.type = 11
NTFVERSIONCARDINFO_INFO_FIELD.cpp_type = 10
NTFVERSIONCARDINFO.name = "NtfVersionCardInfo"
NTFVERSIONCARDINFO.full_name = ".Cmd.NtfVersionCardInfo"
NTFVERSIONCARDINFO.nested_types = {}
NTFVERSIONCARDINFO.enum_types = {}
NTFVERSIONCARDINFO.fields = {
  NTFVERSIONCARDINFO_CMD_FIELD,
  NTFVERSIONCARDINFO_PARAM_FIELD,
  NTFVERSIONCARDINFO_INFO_FIELD
}
NTFVERSIONCARDINFO.is_extendable = false
NTFVERSIONCARDINFO.extensions = {}
DIETIMECOUNTEVENTCMD_CMD_FIELD.name = "cmd"
DIETIMECOUNTEVENTCMD_CMD_FIELD.full_name = ".Cmd.DieTimeCountEventCmd.cmd"
DIETIMECOUNTEVENTCMD_CMD_FIELD.number = 1
DIETIMECOUNTEVENTCMD_CMD_FIELD.index = 0
DIETIMECOUNTEVENTCMD_CMD_FIELD.label = 1
DIETIMECOUNTEVENTCMD_CMD_FIELD.has_default_value = true
DIETIMECOUNTEVENTCMD_CMD_FIELD.default_value = 25
DIETIMECOUNTEVENTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DIETIMECOUNTEVENTCMD_CMD_FIELD.type = 14
DIETIMECOUNTEVENTCMD_CMD_FIELD.cpp_type = 8
DIETIMECOUNTEVENTCMD_PARAM_FIELD.name = "param"
DIETIMECOUNTEVENTCMD_PARAM_FIELD.full_name = ".Cmd.DieTimeCountEventCmd.param"
DIETIMECOUNTEVENTCMD_PARAM_FIELD.number = 2
DIETIMECOUNTEVENTCMD_PARAM_FIELD.index = 1
DIETIMECOUNTEVENTCMD_PARAM_FIELD.label = 1
DIETIMECOUNTEVENTCMD_PARAM_FIELD.has_default_value = true
DIETIMECOUNTEVENTCMD_PARAM_FIELD.default_value = 24
DIETIMECOUNTEVENTCMD_PARAM_FIELD.enum_type = EVENTPARAM
DIETIMECOUNTEVENTCMD_PARAM_FIELD.type = 14
DIETIMECOUNTEVENTCMD_PARAM_FIELD.cpp_type = 8
DIETIMECOUNTEVENTCMD_TIME_FIELD.name = "time"
DIETIMECOUNTEVENTCMD_TIME_FIELD.full_name = ".Cmd.DieTimeCountEventCmd.time"
DIETIMECOUNTEVENTCMD_TIME_FIELD.number = 3
DIETIMECOUNTEVENTCMD_TIME_FIELD.index = 2
DIETIMECOUNTEVENTCMD_TIME_FIELD.label = 1
DIETIMECOUNTEVENTCMD_TIME_FIELD.has_default_value = true
DIETIMECOUNTEVENTCMD_TIME_FIELD.default_value = 0
DIETIMECOUNTEVENTCMD_TIME_FIELD.type = 13
DIETIMECOUNTEVENTCMD_TIME_FIELD.cpp_type = 3
DIETIMECOUNTEVENTCMD_NAME_FIELD.name = "name"
DIETIMECOUNTEVENTCMD_NAME_FIELD.full_name = ".Cmd.DieTimeCountEventCmd.name"
DIETIMECOUNTEVENTCMD_NAME_FIELD.number = 4
DIETIMECOUNTEVENTCMD_NAME_FIELD.index = 3
DIETIMECOUNTEVENTCMD_NAME_FIELD.label = 1
DIETIMECOUNTEVENTCMD_NAME_FIELD.has_default_value = false
DIETIMECOUNTEVENTCMD_NAME_FIELD.default_value = ""
DIETIMECOUNTEVENTCMD_NAME_FIELD.type = 9
DIETIMECOUNTEVENTCMD_NAME_FIELD.cpp_type = 9
DIETIMECOUNTEVENTCMD.name = "DieTimeCountEventCmd"
DIETIMECOUNTEVENTCMD.full_name = ".Cmd.DieTimeCountEventCmd"
DIETIMECOUNTEVENTCMD.nested_types = {}
DIETIMECOUNTEVENTCMD.enum_types = {}
DIETIMECOUNTEVENTCMD.fields = {
  DIETIMECOUNTEVENTCMD_CMD_FIELD,
  DIETIMECOUNTEVENTCMD_PARAM_FIELD,
  DIETIMECOUNTEVENTCMD_TIME_FIELD,
  DIETIMECOUNTEVENTCMD_NAME_FIELD
}
DIETIMECOUNTEVENTCMD.is_extendable = false
DIETIMECOUNTEVENTCMD.extensions = {}
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.name = "cmd"
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.full_name = ".Cmd.GetFirstShareRewardUserEvent.cmd"
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.number = 1
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.index = 0
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.label = 1
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.has_default_value = true
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.default_value = 25
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.type = 14
GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD.cpp_type = 8
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.name = "param"
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.GetFirstShareRewardUserEvent.param"
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.number = 2
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.index = 1
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.label = 1
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.has_default_value = true
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.default_value = 22
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.type = 14
GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD.cpp_type = 8
GETFIRSTSHAREREWARDUSEREVENT.name = "GetFirstShareRewardUserEvent"
GETFIRSTSHAREREWARDUSEREVENT.full_name = ".Cmd.GetFirstShareRewardUserEvent"
GETFIRSTSHAREREWARDUSEREVENT.nested_types = {}
GETFIRSTSHAREREWARDUSEREVENT.enum_types = {}
GETFIRSTSHAREREWARDUSEREVENT.fields = {
  GETFIRSTSHAREREWARDUSEREVENT_CMD_FIELD,
  GETFIRSTSHAREREWARDUSEREVENT_PARAM_FIELD
}
GETFIRSTSHAREREWARDUSEREVENT.is_extendable = false
GETFIRSTSHAREREWARDUSEREVENT.extensions = {}
QUERYRESETTIMEEVENTCMD_CMD_FIELD.name = "cmd"
QUERYRESETTIMEEVENTCMD_CMD_FIELD.full_name = ".Cmd.QueryResetTimeEventCmd.cmd"
QUERYRESETTIMEEVENTCMD_CMD_FIELD.number = 1
QUERYRESETTIMEEVENTCMD_CMD_FIELD.index = 0
QUERYRESETTIMEEVENTCMD_CMD_FIELD.label = 1
QUERYRESETTIMEEVENTCMD_CMD_FIELD.has_default_value = true
QUERYRESETTIMEEVENTCMD_CMD_FIELD.default_value = 25
QUERYRESETTIMEEVENTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYRESETTIMEEVENTCMD_CMD_FIELD.type = 14
QUERYRESETTIMEEVENTCMD_CMD_FIELD.cpp_type = 8
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.name = "param"
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.full_name = ".Cmd.QueryResetTimeEventCmd.param"
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.number = 2
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.index = 1
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.label = 1
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.has_default_value = true
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.default_value = 25
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.enum_type = EVENTPARAM
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.type = 14
QUERYRESETTIMEEVENTCMD_PARAM_FIELD.cpp_type = 8
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.name = "etype"
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.full_name = ".Cmd.QueryResetTimeEventCmd.etype"
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.number = 3
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.index = 2
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.label = 2
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.has_default_value = false
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.default_value = nil
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.enum_type = ACTIVITYEVENT_PB_EAEREWARDMODE
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.type = 14
QUERYRESETTIMEEVENTCMD_ETYPE_FIELD.cpp_type = 8
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.name = "resettime"
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.full_name = ".Cmd.QueryResetTimeEventCmd.resettime"
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.number = 4
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.index = 3
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.label = 1
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.has_default_value = true
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.default_value = 0
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.type = 13
QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD.cpp_type = 3
QUERYRESETTIMEEVENTCMD.name = "QueryResetTimeEventCmd"
QUERYRESETTIMEEVENTCMD.full_name = ".Cmd.QueryResetTimeEventCmd"
QUERYRESETTIMEEVENTCMD.nested_types = {}
QUERYRESETTIMEEVENTCMD.enum_types = {}
QUERYRESETTIMEEVENTCMD.fields = {
  QUERYRESETTIMEEVENTCMD_CMD_FIELD,
  QUERYRESETTIMEEVENTCMD_PARAM_FIELD,
  QUERYRESETTIMEEVENTCMD_ETYPE_FIELD,
  QUERYRESETTIMEEVENTCMD_RESETTIME_FIELD
}
QUERYRESETTIMEEVENTCMD.is_extendable = false
QUERYRESETTIMEEVENTCMD.extensions = {}
INOUTACTEVENTCMD_CMD_FIELD.name = "cmd"
INOUTACTEVENTCMD_CMD_FIELD.full_name = ".Cmd.InOutActEventCmd.cmd"
INOUTACTEVENTCMD_CMD_FIELD.number = 1
INOUTACTEVENTCMD_CMD_FIELD.index = 0
INOUTACTEVENTCMD_CMD_FIELD.label = 1
INOUTACTEVENTCMD_CMD_FIELD.has_default_value = true
INOUTACTEVENTCMD_CMD_FIELD.default_value = 25
INOUTACTEVENTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INOUTACTEVENTCMD_CMD_FIELD.type = 14
INOUTACTEVENTCMD_CMD_FIELD.cpp_type = 8
INOUTACTEVENTCMD_PARAM_FIELD.name = "param"
INOUTACTEVENTCMD_PARAM_FIELD.full_name = ".Cmd.InOutActEventCmd.param"
INOUTACTEVENTCMD_PARAM_FIELD.number = 2
INOUTACTEVENTCMD_PARAM_FIELD.index = 1
INOUTACTEVENTCMD_PARAM_FIELD.label = 1
INOUTACTEVENTCMD_PARAM_FIELD.has_default_value = true
INOUTACTEVENTCMD_PARAM_FIELD.default_value = 26
INOUTACTEVENTCMD_PARAM_FIELD.enum_type = EVENTPARAM
INOUTACTEVENTCMD_PARAM_FIELD.type = 14
INOUTACTEVENTCMD_PARAM_FIELD.cpp_type = 8
INOUTACTEVENTCMD_ACTID_FIELD.name = "actid"
INOUTACTEVENTCMD_ACTID_FIELD.full_name = ".Cmd.InOutActEventCmd.actid"
INOUTACTEVENTCMD_ACTID_FIELD.number = 3
INOUTACTEVENTCMD_ACTID_FIELD.index = 2
INOUTACTEVENTCMD_ACTID_FIELD.label = 2
INOUTACTEVENTCMD_ACTID_FIELD.has_default_value = false
INOUTACTEVENTCMD_ACTID_FIELD.default_value = 0
INOUTACTEVENTCMD_ACTID_FIELD.type = 4
INOUTACTEVENTCMD_ACTID_FIELD.cpp_type = 4
INOUTACTEVENTCMD_INOUT_FIELD.name = "inout"
INOUTACTEVENTCMD_INOUT_FIELD.full_name = ".Cmd.InOutActEventCmd.inout"
INOUTACTEVENTCMD_INOUT_FIELD.number = 4
INOUTACTEVENTCMD_INOUT_FIELD.index = 3
INOUTACTEVENTCMD_INOUT_FIELD.label = 1
INOUTACTEVENTCMD_INOUT_FIELD.has_default_value = true
INOUTACTEVENTCMD_INOUT_FIELD.default_value = false
INOUTACTEVENTCMD_INOUT_FIELD.type = 8
INOUTACTEVENTCMD_INOUT_FIELD.cpp_type = 7
INOUTACTEVENTCMD.name = "InOutActEventCmd"
INOUTACTEVENTCMD.full_name = ".Cmd.InOutActEventCmd"
INOUTACTEVENTCMD.nested_types = {}
INOUTACTEVENTCMD.enum_types = {}
INOUTACTEVENTCMD.fields = {
  INOUTACTEVENTCMD_CMD_FIELD,
  INOUTACTEVENTCMD_PARAM_FIELD,
  INOUTACTEVENTCMD_ACTID_FIELD,
  INOUTACTEVENTCMD_INOUT_FIELD
}
INOUTACTEVENTCMD.is_extendable = false
INOUTACTEVENTCMD.extensions = {}
USEREVENTMAILCMD_CMD_FIELD.name = "cmd"
USEREVENTMAILCMD_CMD_FIELD.full_name = ".Cmd.UserEventMailCmd.cmd"
USEREVENTMAILCMD_CMD_FIELD.number = 1
USEREVENTMAILCMD_CMD_FIELD.index = 0
USEREVENTMAILCMD_CMD_FIELD.label = 1
USEREVENTMAILCMD_CMD_FIELD.has_default_value = true
USEREVENTMAILCMD_CMD_FIELD.default_value = 25
USEREVENTMAILCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USEREVENTMAILCMD_CMD_FIELD.type = 14
USEREVENTMAILCMD_CMD_FIELD.cpp_type = 8
USEREVENTMAILCMD_PARAM_FIELD.name = "param"
USEREVENTMAILCMD_PARAM_FIELD.full_name = ".Cmd.UserEventMailCmd.param"
USEREVENTMAILCMD_PARAM_FIELD.number = 2
USEREVENTMAILCMD_PARAM_FIELD.index = 1
USEREVENTMAILCMD_PARAM_FIELD.label = 1
USEREVENTMAILCMD_PARAM_FIELD.has_default_value = true
USEREVENTMAILCMD_PARAM_FIELD.default_value = 27
USEREVENTMAILCMD_PARAM_FIELD.enum_type = EVENTPARAM
USEREVENTMAILCMD_PARAM_FIELD.type = 14
USEREVENTMAILCMD_PARAM_FIELD.cpp_type = 8
USEREVENTMAILCMD_ETYPE_FIELD.name = "eType"
USEREVENTMAILCMD_ETYPE_FIELD.full_name = ".Cmd.UserEventMailCmd.eType"
USEREVENTMAILCMD_ETYPE_FIELD.number = 3
USEREVENTMAILCMD_ETYPE_FIELD.index = 2
USEREVENTMAILCMD_ETYPE_FIELD.label = 1
USEREVENTMAILCMD_ETYPE_FIELD.has_default_value = true
USEREVENTMAILCMD_ETYPE_FIELD.default_value = 0
USEREVENTMAILCMD_ETYPE_FIELD.enum_type = EEVENTMAILTYPE
USEREVENTMAILCMD_ETYPE_FIELD.type = 14
USEREVENTMAILCMD_ETYPE_FIELD.cpp_type = 8
USEREVENTMAILCMD_PARAM32_FIELD.name = "param32"
USEREVENTMAILCMD_PARAM32_FIELD.full_name = ".Cmd.UserEventMailCmd.param32"
USEREVENTMAILCMD_PARAM32_FIELD.number = 4
USEREVENTMAILCMD_PARAM32_FIELD.index = 3
USEREVENTMAILCMD_PARAM32_FIELD.label = 3
USEREVENTMAILCMD_PARAM32_FIELD.has_default_value = false
USEREVENTMAILCMD_PARAM32_FIELD.default_value = {}
USEREVENTMAILCMD_PARAM32_FIELD.type = 13
USEREVENTMAILCMD_PARAM32_FIELD.cpp_type = 3
USEREVENTMAILCMD_PARAM64_FIELD.name = "param64"
USEREVENTMAILCMD_PARAM64_FIELD.full_name = ".Cmd.UserEventMailCmd.param64"
USEREVENTMAILCMD_PARAM64_FIELD.number = 5
USEREVENTMAILCMD_PARAM64_FIELD.index = 4
USEREVENTMAILCMD_PARAM64_FIELD.label = 3
USEREVENTMAILCMD_PARAM64_FIELD.has_default_value = false
USEREVENTMAILCMD_PARAM64_FIELD.default_value = {}
USEREVENTMAILCMD_PARAM64_FIELD.type = 4
USEREVENTMAILCMD_PARAM64_FIELD.cpp_type = 4
USEREVENTMAILCMD.name = "UserEventMailCmd"
USEREVENTMAILCMD.full_name = ".Cmd.UserEventMailCmd"
USEREVENTMAILCMD.nested_types = {}
USEREVENTMAILCMD.enum_types = {}
USEREVENTMAILCMD.fields = {
  USEREVENTMAILCMD_CMD_FIELD,
  USEREVENTMAILCMD_PARAM_FIELD,
  USEREVENTMAILCMD_ETYPE_FIELD,
  USEREVENTMAILCMD_PARAM32_FIELD,
  USEREVENTMAILCMD_PARAM64_FIELD
}
USEREVENTMAILCMD.is_extendable = false
USEREVENTMAILCMD.extensions = {}
LEVELUPDEADUSEREVENT_CMD_FIELD.name = "cmd"
LEVELUPDEADUSEREVENT_CMD_FIELD.full_name = ".Cmd.LevelupDeadUserEvent.cmd"
LEVELUPDEADUSEREVENT_CMD_FIELD.number = 1
LEVELUPDEADUSEREVENT_CMD_FIELD.index = 0
LEVELUPDEADUSEREVENT_CMD_FIELD.label = 1
LEVELUPDEADUSEREVENT_CMD_FIELD.has_default_value = true
LEVELUPDEADUSEREVENT_CMD_FIELD.default_value = 25
LEVELUPDEADUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LEVELUPDEADUSEREVENT_CMD_FIELD.type = 14
LEVELUPDEADUSEREVENT_CMD_FIELD.cpp_type = 8
LEVELUPDEADUSEREVENT_PARAM_FIELD.name = "param"
LEVELUPDEADUSEREVENT_PARAM_FIELD.full_name = ".Cmd.LevelupDeadUserEvent.param"
LEVELUPDEADUSEREVENT_PARAM_FIELD.number = 2
LEVELUPDEADUSEREVENT_PARAM_FIELD.index = 1
LEVELUPDEADUSEREVENT_PARAM_FIELD.label = 1
LEVELUPDEADUSEREVENT_PARAM_FIELD.has_default_value = true
LEVELUPDEADUSEREVENT_PARAM_FIELD.default_value = 28
LEVELUPDEADUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
LEVELUPDEADUSEREVENT_PARAM_FIELD.type = 14
LEVELUPDEADUSEREVENT_PARAM_FIELD.cpp_type = 8
LEVELUPDEADUSEREVENT.name = "LevelupDeadUserEvent"
LEVELUPDEADUSEREVENT.full_name = ".Cmd.LevelupDeadUserEvent"
LEVELUPDEADUSEREVENT.nested_types = {}
LEVELUPDEADUSEREVENT.enum_types = {}
LEVELUPDEADUSEREVENT.fields = {
  LEVELUPDEADUSEREVENT_CMD_FIELD,
  LEVELUPDEADUSEREVENT_PARAM_FIELD
}
LEVELUPDEADUSEREVENT.is_extendable = false
LEVELUPDEADUSEREVENT.extensions = {}
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.name = "cmd"
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.full_name = ".Cmd.SwitchAutoBattleUserEvent.cmd"
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.number = 1
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.index = 0
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.label = 1
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.has_default_value = true
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.default_value = 25
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.type = 14
SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD.cpp_type = 8
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.name = "param"
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SwitchAutoBattleUserEvent.param"
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.number = 2
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.index = 1
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.label = 1
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.has_default_value = true
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.default_value = 29
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.type = 14
SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD.cpp_type = 8
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.name = "open"
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.full_name = ".Cmd.SwitchAutoBattleUserEvent.open"
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.number = 3
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.index = 2
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.label = 1
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.has_default_value = true
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.default_value = false
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.type = 8
SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD.cpp_type = 7
SWITCHAUTOBATTLEUSEREVENT.name = "SwitchAutoBattleUserEvent"
SWITCHAUTOBATTLEUSEREVENT.full_name = ".Cmd.SwitchAutoBattleUserEvent"
SWITCHAUTOBATTLEUSEREVENT.nested_types = {}
SWITCHAUTOBATTLEUSEREVENT.enum_types = {}
SWITCHAUTOBATTLEUSEREVENT.fields = {
  SWITCHAUTOBATTLEUSEREVENT_CMD_FIELD,
  SWITCHAUTOBATTLEUSEREVENT_PARAM_FIELD,
  SWITCHAUTOBATTLEUSEREVENT_OPEN_FIELD
}
SWITCHAUTOBATTLEUSEREVENT.is_extendable = false
SWITCHAUTOBATTLEUSEREVENT.extensions = {}
GOACTIVITYMAPUSEREVENT_CMD_FIELD.name = "cmd"
GOACTIVITYMAPUSEREVENT_CMD_FIELD.full_name = ".Cmd.GoActivityMapUserEvent.cmd"
GOACTIVITYMAPUSEREVENT_CMD_FIELD.number = 1
GOACTIVITYMAPUSEREVENT_CMD_FIELD.index = 0
GOACTIVITYMAPUSEREVENT_CMD_FIELD.label = 1
GOACTIVITYMAPUSEREVENT_CMD_FIELD.has_default_value = true
GOACTIVITYMAPUSEREVENT_CMD_FIELD.default_value = 25
GOACTIVITYMAPUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GOACTIVITYMAPUSEREVENT_CMD_FIELD.type = 14
GOACTIVITYMAPUSEREVENT_CMD_FIELD.cpp_type = 8
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.name = "param"
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.full_name = ".Cmd.GoActivityMapUserEvent.param"
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.number = 2
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.index = 1
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.label = 1
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.has_default_value = true
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.default_value = 30
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.type = 14
GOACTIVITYMAPUSEREVENT_PARAM_FIELD.cpp_type = 8
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.name = "actid"
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.full_name = ".Cmd.GoActivityMapUserEvent.actid"
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.number = 3
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.index = 2
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.label = 1
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.has_default_value = true
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.default_value = 0
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.type = 13
GOACTIVITYMAPUSEREVENT_ACTID_FIELD.cpp_type = 3
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.name = "mapid"
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.full_name = ".Cmd.GoActivityMapUserEvent.mapid"
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.number = 4
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.index = 3
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.label = 1
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.has_default_value = true
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.default_value = 0
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.type = 13
GOACTIVITYMAPUSEREVENT_MAPID_FIELD.cpp_type = 3
GOACTIVITYMAPUSEREVENT.name = "GoActivityMapUserEvent"
GOACTIVITYMAPUSEREVENT.full_name = ".Cmd.GoActivityMapUserEvent"
GOACTIVITYMAPUSEREVENT.nested_types = {}
GOACTIVITYMAPUSEREVENT.enum_types = {}
GOACTIVITYMAPUSEREVENT.fields = {
  GOACTIVITYMAPUSEREVENT_CMD_FIELD,
  GOACTIVITYMAPUSEREVENT_PARAM_FIELD,
  GOACTIVITYMAPUSEREVENT_ACTID_FIELD,
  GOACTIVITYMAPUSEREVENT_MAPID_FIELD
}
GOACTIVITYMAPUSEREVENT.is_extendable = false
GOACTIVITYMAPUSEREVENT.extensions = {}
ACTIVITYPOINTUSEREVENT_CMD_FIELD.name = "cmd"
ACTIVITYPOINTUSEREVENT_CMD_FIELD.full_name = ".Cmd.ActivityPointUserEvent.cmd"
ACTIVITYPOINTUSEREVENT_CMD_FIELD.number = 1
ACTIVITYPOINTUSEREVENT_CMD_FIELD.index = 0
ACTIVITYPOINTUSEREVENT_CMD_FIELD.label = 1
ACTIVITYPOINTUSEREVENT_CMD_FIELD.has_default_value = true
ACTIVITYPOINTUSEREVENT_CMD_FIELD.default_value = 25
ACTIVITYPOINTUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ACTIVITYPOINTUSEREVENT_CMD_FIELD.type = 14
ACTIVITYPOINTUSEREVENT_CMD_FIELD.cpp_type = 8
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.name = "param"
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ActivityPointUserEvent.param"
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.number = 2
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.index = 1
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.label = 1
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.has_default_value = true
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.default_value = 31
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.type = 14
ACTIVITYPOINTUSEREVENT_PARAM_FIELD.cpp_type = 8
ACTIVITYPOINTUSEREVENT.name = "ActivityPointUserEvent"
ACTIVITYPOINTUSEREVENT.full_name = ".Cmd.ActivityPointUserEvent"
ACTIVITYPOINTUSEREVENT.nested_types = {}
ACTIVITYPOINTUSEREVENT.enum_types = {}
ACTIVITYPOINTUSEREVENT.fields = {
  ACTIVITYPOINTUSEREVENT_CMD_FIELD,
  ACTIVITYPOINTUSEREVENT_PARAM_FIELD
}
ACTIVITYPOINTUSEREVENT.is_extendable = false
ACTIVITYPOINTUSEREVENT.extensions = {}
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.name = "cmd"
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.full_name = ".Cmd.QueryFavoriteFriendUserEvent.cmd"
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.number = 1
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.index = 0
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.label = 1
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.has_default_value = true
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.default_value = 25
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.type = 14
QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD.cpp_type = 8
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.name = "param"
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.QueryFavoriteFriendUserEvent.param"
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.number = 2
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.index = 1
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.label = 1
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.has_default_value = true
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.default_value = 33
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.type = 14
QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD.cpp_type = 8
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.name = "charid"
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.full_name = ".Cmd.QueryFavoriteFriendUserEvent.charid"
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.number = 3
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.index = 2
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.label = 3
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.has_default_value = false
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.default_value = {}
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.type = 4
QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD.cpp_type = 4
QUERYFAVORITEFRIENDUSEREVENT.name = "QueryFavoriteFriendUserEvent"
QUERYFAVORITEFRIENDUSEREVENT.full_name = ".Cmd.QueryFavoriteFriendUserEvent"
QUERYFAVORITEFRIENDUSEREVENT.nested_types = {}
QUERYFAVORITEFRIENDUSEREVENT.enum_types = {}
QUERYFAVORITEFRIENDUSEREVENT.fields = {
  QUERYFAVORITEFRIENDUSEREVENT_CMD_FIELD,
  QUERYFAVORITEFRIENDUSEREVENT_PARAM_FIELD,
  QUERYFAVORITEFRIENDUSEREVENT_CHARID_FIELD
}
QUERYFAVORITEFRIENDUSEREVENT.is_extendable = false
QUERYFAVORITEFRIENDUSEREVENT.extensions = {}
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.name = "cmd"
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.full_name = ".Cmd.UpdateFavoriteFriendUserEvent.cmd"
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.number = 1
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.index = 0
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.label = 1
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.has_default_value = true
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.default_value = 25
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.type = 14
UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD.cpp_type = 8
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.name = "param"
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.UpdateFavoriteFriendUserEvent.param"
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.number = 2
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.index = 1
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.label = 1
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.has_default_value = true
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.default_value = 34
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.type = 14
UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD.cpp_type = 8
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.name = "updateids"
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.full_name = ".Cmd.UpdateFavoriteFriendUserEvent.updateids"
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.number = 3
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.index = 2
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.label = 3
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.has_default_value = false
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.default_value = {}
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.type = 4
UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD.cpp_type = 4
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.name = "delids"
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.full_name = ".Cmd.UpdateFavoriteFriendUserEvent.delids"
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.number = 4
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.index = 3
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.label = 3
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.has_default_value = false
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.default_value = {}
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.type = 4
UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.cpp_type = 4
UPDATEFAVORITEFRIENDUSEREVENT.name = "UpdateFavoriteFriendUserEvent"
UPDATEFAVORITEFRIENDUSEREVENT.full_name = ".Cmd.UpdateFavoriteFriendUserEvent"
UPDATEFAVORITEFRIENDUSEREVENT.nested_types = {}
UPDATEFAVORITEFRIENDUSEREVENT.enum_types = {}
UPDATEFAVORITEFRIENDUSEREVENT.fields = {
  UPDATEFAVORITEFRIENDUSEREVENT_CMD_FIELD,
  UPDATEFAVORITEFRIENDUSEREVENT_PARAM_FIELD,
  UPDATEFAVORITEFRIENDUSEREVENT_UPDATEIDS_FIELD,
  UPDATEFAVORITEFRIENDUSEREVENT_DELIDS_FIELD
}
UPDATEFAVORITEFRIENDUSEREVENT.is_extendable = false
UPDATEFAVORITEFRIENDUSEREVENT.extensions = {}
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.name = "cmd"
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.full_name = ".Cmd.ActionFavoriteFriendUserEvent.cmd"
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.number = 1
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.index = 0
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.label = 1
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.has_default_value = true
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.default_value = 25
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.type = 14
ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD.cpp_type = 8
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.name = "param"
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ActionFavoriteFriendUserEvent.param"
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.number = 2
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.index = 1
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.label = 1
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.has_default_value = true
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.default_value = 35
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.type = 14
ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD.cpp_type = 8
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.name = "addids"
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.full_name = ".Cmd.ActionFavoriteFriendUserEvent.addids"
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.number = 3
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.index = 2
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.label = 3
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.has_default_value = false
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.default_value = {}
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.type = 4
ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD.cpp_type = 4
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.name = "delids"
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.full_name = ".Cmd.ActionFavoriteFriendUserEvent.delids"
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.number = 4
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.index = 3
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.label = 3
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.has_default_value = false
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.default_value = {}
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.type = 4
ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD.cpp_type = 4
ACTIONFAVORITEFRIENDUSEREVENT.name = "ActionFavoriteFriendUserEvent"
ACTIONFAVORITEFRIENDUSEREVENT.full_name = ".Cmd.ActionFavoriteFriendUserEvent"
ACTIONFAVORITEFRIENDUSEREVENT.nested_types = {}
ACTIONFAVORITEFRIENDUSEREVENT.enum_types = {}
ACTIONFAVORITEFRIENDUSEREVENT.fields = {
  ACTIONFAVORITEFRIENDUSEREVENT_CMD_FIELD,
  ACTIONFAVORITEFRIENDUSEREVENT_PARAM_FIELD,
  ACTIONFAVORITEFRIENDUSEREVENT_ADDIDS_FIELD,
  ACTIONFAVORITEFRIENDUSEREVENT_DELIDS_FIELD
}
ACTIONFAVORITEFRIENDUSEREVENT.is_extendable = false
ACTIONFAVORITEFRIENDUSEREVENT.extensions = {}
SOUNDSTORYUSEREVENT_CMD_FIELD.name = "cmd"
SOUNDSTORYUSEREVENT_CMD_FIELD.full_name = ".Cmd.SoundStoryUserEvent.cmd"
SOUNDSTORYUSEREVENT_CMD_FIELD.number = 1
SOUNDSTORYUSEREVENT_CMD_FIELD.index = 0
SOUNDSTORYUSEREVENT_CMD_FIELD.label = 1
SOUNDSTORYUSEREVENT_CMD_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_CMD_FIELD.default_value = 25
SOUNDSTORYUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SOUNDSTORYUSEREVENT_CMD_FIELD.type = 14
SOUNDSTORYUSEREVENT_CMD_FIELD.cpp_type = 8
SOUNDSTORYUSEREVENT_PARAM_FIELD.name = "param"
SOUNDSTORYUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SoundStoryUserEvent.param"
SOUNDSTORYUSEREVENT_PARAM_FIELD.number = 2
SOUNDSTORYUSEREVENT_PARAM_FIELD.index = 1
SOUNDSTORYUSEREVENT_PARAM_FIELD.label = 1
SOUNDSTORYUSEREVENT_PARAM_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_PARAM_FIELD.default_value = 36
SOUNDSTORYUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SOUNDSTORYUSEREVENT_PARAM_FIELD.type = 14
SOUNDSTORYUSEREVENT_PARAM_FIELD.cpp_type = 8
SOUNDSTORYUSEREVENT_ID_FIELD.name = "id"
SOUNDSTORYUSEREVENT_ID_FIELD.full_name = ".Cmd.SoundStoryUserEvent.id"
SOUNDSTORYUSEREVENT_ID_FIELD.number = 3
SOUNDSTORYUSEREVENT_ID_FIELD.index = 2
SOUNDSTORYUSEREVENT_ID_FIELD.label = 1
SOUNDSTORYUSEREVENT_ID_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_ID_FIELD.default_value = 0
SOUNDSTORYUSEREVENT_ID_FIELD.type = 13
SOUNDSTORYUSEREVENT_ID_FIELD.cpp_type = 3
SOUNDSTORYUSEREVENT_TIMES_FIELD.name = "times"
SOUNDSTORYUSEREVENT_TIMES_FIELD.full_name = ".Cmd.SoundStoryUserEvent.times"
SOUNDSTORYUSEREVENT_TIMES_FIELD.number = 4
SOUNDSTORYUSEREVENT_TIMES_FIELD.index = 3
SOUNDSTORYUSEREVENT_TIMES_FIELD.label = 1
SOUNDSTORYUSEREVENT_TIMES_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_TIMES_FIELD.default_value = 0
SOUNDSTORYUSEREVENT_TIMES_FIELD.type = 13
SOUNDSTORYUSEREVENT_TIMES_FIELD.cpp_type = 3
SOUNDSTORYUSEREVENT_REPLACE_FIELD.name = "replace"
SOUNDSTORYUSEREVENT_REPLACE_FIELD.full_name = ".Cmd.SoundStoryUserEvent.replace"
SOUNDSTORYUSEREVENT_REPLACE_FIELD.number = 5
SOUNDSTORYUSEREVENT_REPLACE_FIELD.index = 4
SOUNDSTORYUSEREVENT_REPLACE_FIELD.label = 1
SOUNDSTORYUSEREVENT_REPLACE_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_REPLACE_FIELD.default_value = 0
SOUNDSTORYUSEREVENT_REPLACE_FIELD.type = 13
SOUNDSTORYUSEREVENT_REPLACE_FIELD.cpp_type = 3
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.name = "forcestop"
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.full_name = ".Cmd.SoundStoryUserEvent.forcestop"
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.number = 6
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.index = 5
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.label = 1
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.default_value = false
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.type = 8
SOUNDSTORYUSEREVENT_FORCESTOP_FIELD.cpp_type = 7
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.name = "bgmkeep"
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.full_name = ".Cmd.SoundStoryUserEvent.bgmkeep"
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.number = 7
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.index = 6
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.label = 1
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.has_default_value = true
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.default_value = false
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.type = 8
SOUNDSTORYUSEREVENT_BGMKEEP_FIELD.cpp_type = 7
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.name = "replacecontext"
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.full_name = ".Cmd.SoundStoryUserEvent.replacecontext"
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.number = 8
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.index = 7
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.label = 1
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.has_default_value = false
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.default_value = ""
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.type = 9
SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD.cpp_type = 9
SOUNDSTORYUSEREVENT.name = "SoundStoryUserEvent"
SOUNDSTORYUSEREVENT.full_name = ".Cmd.SoundStoryUserEvent"
SOUNDSTORYUSEREVENT.nested_types = {}
SOUNDSTORYUSEREVENT.enum_types = {}
SOUNDSTORYUSEREVENT.fields = {
  SOUNDSTORYUSEREVENT_CMD_FIELD,
  SOUNDSTORYUSEREVENT_PARAM_FIELD,
  SOUNDSTORYUSEREVENT_ID_FIELD,
  SOUNDSTORYUSEREVENT_TIMES_FIELD,
  SOUNDSTORYUSEREVENT_REPLACE_FIELD,
  SOUNDSTORYUSEREVENT_FORCESTOP_FIELD,
  SOUNDSTORYUSEREVENT_BGMKEEP_FIELD,
  SOUNDSTORYUSEREVENT_REPLACECONTEXT_FIELD
}
SOUNDSTORYUSEREVENT.is_extendable = false
SOUNDSTORYUSEREVENT.extensions = {}
THEMEDETAILSUSEREVENT_CMD_FIELD.name = "cmd"
THEMEDETAILSUSEREVENT_CMD_FIELD.full_name = ".Cmd.ThemeDetailsUserEvent.cmd"
THEMEDETAILSUSEREVENT_CMD_FIELD.number = 1
THEMEDETAILSUSEREVENT_CMD_FIELD.index = 0
THEMEDETAILSUSEREVENT_CMD_FIELD.label = 1
THEMEDETAILSUSEREVENT_CMD_FIELD.has_default_value = true
THEMEDETAILSUSEREVENT_CMD_FIELD.default_value = 25
THEMEDETAILSUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
THEMEDETAILSUSEREVENT_CMD_FIELD.type = 14
THEMEDETAILSUSEREVENT_CMD_FIELD.cpp_type = 8
THEMEDETAILSUSEREVENT_PARAM_FIELD.name = "param"
THEMEDETAILSUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ThemeDetailsUserEvent.param"
THEMEDETAILSUSEREVENT_PARAM_FIELD.number = 2
THEMEDETAILSUSEREVENT_PARAM_FIELD.index = 1
THEMEDETAILSUSEREVENT_PARAM_FIELD.label = 1
THEMEDETAILSUSEREVENT_PARAM_FIELD.has_default_value = true
THEMEDETAILSUSEREVENT_PARAM_FIELD.default_value = 32
THEMEDETAILSUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
THEMEDETAILSUSEREVENT_PARAM_FIELD.type = 14
THEMEDETAILSUSEREVENT_PARAM_FIELD.cpp_type = 8
THEMEDETAILSUSEREVENT_TYPE_FIELD.name = "type"
THEMEDETAILSUSEREVENT_TYPE_FIELD.full_name = ".Cmd.ThemeDetailsUserEvent.type"
THEMEDETAILSUSEREVENT_TYPE_FIELD.number = 3
THEMEDETAILSUSEREVENT_TYPE_FIELD.index = 2
THEMEDETAILSUSEREVENT_TYPE_FIELD.label = 1
THEMEDETAILSUSEREVENT_TYPE_FIELD.has_default_value = true
THEMEDETAILSUSEREVENT_TYPE_FIELD.default_value = 0
THEMEDETAILSUSEREVENT_TYPE_FIELD.type = 13
THEMEDETAILSUSEREVENT_TYPE_FIELD.cpp_type = 3
THEMEDETAILSUSEREVENT.name = "ThemeDetailsUserEvent"
THEMEDETAILSUSEREVENT.full_name = ".Cmd.ThemeDetailsUserEvent"
THEMEDETAILSUSEREVENT.nested_types = {}
THEMEDETAILSUSEREVENT.enum_types = {}
THEMEDETAILSUSEREVENT.fields = {
  THEMEDETAILSUSEREVENT_CMD_FIELD,
  THEMEDETAILSUSEREVENT_PARAM_FIELD,
  THEMEDETAILSUSEREVENT_TYPE_FIELD
}
THEMEDETAILSUSEREVENT.is_extendable = false
THEMEDETAILSUSEREVENT.extensions = {}
CAMERAACTIONUSEREVENT_CMD_FIELD.name = "cmd"
CAMERAACTIONUSEREVENT_CMD_FIELD.full_name = ".Cmd.CameraActionUserEvent.cmd"
CAMERAACTIONUSEREVENT_CMD_FIELD.number = 1
CAMERAACTIONUSEREVENT_CMD_FIELD.index = 0
CAMERAACTIONUSEREVENT_CMD_FIELD.label = 1
CAMERAACTIONUSEREVENT_CMD_FIELD.has_default_value = true
CAMERAACTIONUSEREVENT_CMD_FIELD.default_value = 25
CAMERAACTIONUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CAMERAACTIONUSEREVENT_CMD_FIELD.type = 14
CAMERAACTIONUSEREVENT_CMD_FIELD.cpp_type = 8
CAMERAACTIONUSEREVENT_PARAM_FIELD.name = "param"
CAMERAACTIONUSEREVENT_PARAM_FIELD.full_name = ".Cmd.CameraActionUserEvent.param"
CAMERAACTIONUSEREVENT_PARAM_FIELD.number = 2
CAMERAACTIONUSEREVENT_PARAM_FIELD.index = 1
CAMERAACTIONUSEREVENT_PARAM_FIELD.label = 1
CAMERAACTIONUSEREVENT_PARAM_FIELD.has_default_value = true
CAMERAACTIONUSEREVENT_PARAM_FIELD.default_value = 40
CAMERAACTIONUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CAMERAACTIONUSEREVENT_PARAM_FIELD.type = 14
CAMERAACTIONUSEREVENT_PARAM_FIELD.cpp_type = 8
CAMERAACTIONUSEREVENT_PARAMS_FIELD.name = "params"
CAMERAACTIONUSEREVENT_PARAMS_FIELD.full_name = ".Cmd.CameraActionUserEvent.params"
CAMERAACTIONUSEREVENT_PARAMS_FIELD.number = 3
CAMERAACTIONUSEREVENT_PARAMS_FIELD.index = 2
CAMERAACTIONUSEREVENT_PARAMS_FIELD.label = 1
CAMERAACTIONUSEREVENT_PARAMS_FIELD.has_default_value = false
CAMERAACTIONUSEREVENT_PARAMS_FIELD.default_value = ""
CAMERAACTIONUSEREVENT_PARAMS_FIELD.type = 9
CAMERAACTIONUSEREVENT_PARAMS_FIELD.cpp_type = 9
CAMERAACTIONUSEREVENT.name = "CameraActionUserEvent"
CAMERAACTIONUSEREVENT.full_name = ".Cmd.CameraActionUserEvent"
CAMERAACTIONUSEREVENT.nested_types = {}
CAMERAACTIONUSEREVENT.enum_types = {}
CAMERAACTIONUSEREVENT.fields = {
  CAMERAACTIONUSEREVENT_CMD_FIELD,
  CAMERAACTIONUSEREVENT_PARAM_FIELD,
  CAMERAACTIONUSEREVENT_PARAMS_FIELD
}
CAMERAACTIONUSEREVENT.is_extendable = false
CAMERAACTIONUSEREVENT.extensions = {}
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.name = "cmd"
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.full_name = ".Cmd.BifrostContributeItemUserEvent.cmd"
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.number = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.index = 0
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.label = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.has_default_value = true
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.default_value = 25
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.type = 14
BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD.cpp_type = 8
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.name = "param"
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.full_name = ".Cmd.BifrostContributeItemUserEvent.param"
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.number = 2
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.index = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.label = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.has_default_value = true
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.default_value = 39
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.type = 14
BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD.cpp_type = 8
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.name = "id"
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.full_name = ".Cmd.BifrostContributeItemUserEvent.id"
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.number = 3
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.index = 2
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.label = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.has_default_value = true
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.default_value = 0
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.type = 13
BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD.cpp_type = 3
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.name = "times"
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.full_name = ".Cmd.BifrostContributeItemUserEvent.times"
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.number = 4
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.index = 3
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.label = 1
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.has_default_value = true
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.default_value = 0
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.type = 13
BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD.cpp_type = 3
BIFROSTCONTRIBUTEITEMUSEREVENT.name = "BifrostContributeItemUserEvent"
BIFROSTCONTRIBUTEITEMUSEREVENT.full_name = ".Cmd.BifrostContributeItemUserEvent"
BIFROSTCONTRIBUTEITEMUSEREVENT.nested_types = {}
BIFROSTCONTRIBUTEITEMUSEREVENT.enum_types = {}
BIFROSTCONTRIBUTEITEMUSEREVENT.fields = {
  BIFROSTCONTRIBUTEITEMUSEREVENT_CMD_FIELD,
  BIFROSTCONTRIBUTEITEMUSEREVENT_PARAM_FIELD,
  BIFROSTCONTRIBUTEITEMUSEREVENT_ID_FIELD,
  BIFROSTCONTRIBUTEITEMUSEREVENT_TIMES_FIELD
}
BIFROSTCONTRIBUTEITEMUSEREVENT.is_extendable = false
BIFROSTCONTRIBUTEITEMUSEREVENT.extensions = {}
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.name = "cmd"
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.full_name = ".Cmd.RobotOffBattleUserEvent.cmd"
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.number = 1
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.index = 0
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.label = 1
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.has_default_value = true
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.default_value = 25
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.type = 14
ROBOTOFFBATTLEUSEREVENT_CMD_FIELD.cpp_type = 8
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.name = "param"
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.RobotOffBattleUserEvent.param"
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.number = 2
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.index = 1
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.label = 1
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.has_default_value = true
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.default_value = 41
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.type = 14
ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD.cpp_type = 8
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.name = "inplace"
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.full_name = ".Cmd.RobotOffBattleUserEvent.inplace"
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.number = 3
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.index = 2
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.label = 1
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.has_default_value = false
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.default_value = false
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.type = 8
ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD.cpp_type = 7
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.name = "protect_team"
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.full_name = ".Cmd.RobotOffBattleUserEvent.protect_team"
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.number = 4
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.index = 3
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.label = 1
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.has_default_value = false
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.default_value = false
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.type = 8
ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD.cpp_type = 7
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.name = "monsterids"
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.full_name = ".Cmd.RobotOffBattleUserEvent.monsterids"
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.number = 5
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.index = 4
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.label = 3
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.has_default_value = false
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.default_value = {}
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.type = 13
ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD.cpp_type = 3
ROBOTOFFBATTLEUSEREVENT.name = "RobotOffBattleUserEvent"
ROBOTOFFBATTLEUSEREVENT.full_name = ".Cmd.RobotOffBattleUserEvent"
ROBOTOFFBATTLEUSEREVENT.nested_types = {}
ROBOTOFFBATTLEUSEREVENT.enum_types = {}
ROBOTOFFBATTLEUSEREVENT.fields = {
  ROBOTOFFBATTLEUSEREVENT_CMD_FIELD,
  ROBOTOFFBATTLEUSEREVENT_PARAM_FIELD,
  ROBOTOFFBATTLEUSEREVENT_INPLACE_FIELD,
  ROBOTOFFBATTLEUSEREVENT_PROTECT_TEAM_FIELD,
  ROBOTOFFBATTLEUSEREVENT_MONSTERIDS_FIELD
}
ROBOTOFFBATTLEUSEREVENT.is_extendable = false
ROBOTOFFBATTLEUSEREVENT.extensions = {}
QUERYACCCHARGECNTREWARD_CMD_FIELD.name = "cmd"
QUERYACCCHARGECNTREWARD_CMD_FIELD.full_name = ".Cmd.QueryAccChargeCntReward.cmd"
QUERYACCCHARGECNTREWARD_CMD_FIELD.number = 1
QUERYACCCHARGECNTREWARD_CMD_FIELD.index = 0
QUERYACCCHARGECNTREWARD_CMD_FIELD.label = 1
QUERYACCCHARGECNTREWARD_CMD_FIELD.has_default_value = true
QUERYACCCHARGECNTREWARD_CMD_FIELD.default_value = 25
QUERYACCCHARGECNTREWARD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYACCCHARGECNTREWARD_CMD_FIELD.type = 14
QUERYACCCHARGECNTREWARD_CMD_FIELD.cpp_type = 8
QUERYACCCHARGECNTREWARD_PARAM_FIELD.name = "param"
QUERYACCCHARGECNTREWARD_PARAM_FIELD.full_name = ".Cmd.QueryAccChargeCntReward.param"
QUERYACCCHARGECNTREWARD_PARAM_FIELD.number = 2
QUERYACCCHARGECNTREWARD_PARAM_FIELD.index = 1
QUERYACCCHARGECNTREWARD_PARAM_FIELD.label = 1
QUERYACCCHARGECNTREWARD_PARAM_FIELD.has_default_value = true
QUERYACCCHARGECNTREWARD_PARAM_FIELD.default_value = 37
QUERYACCCHARGECNTREWARD_PARAM_FIELD.enum_type = EVENTPARAM
QUERYACCCHARGECNTREWARD_PARAM_FIELD.type = 14
QUERYACCCHARGECNTREWARD_PARAM_FIELD.cpp_type = 8
QUERYACCCHARGECNTREWARD_INFOS_FIELD.name = "infos"
QUERYACCCHARGECNTREWARD_INFOS_FIELD.full_name = ".Cmd.QueryAccChargeCntReward.infos"
QUERYACCCHARGECNTREWARD_INFOS_FIELD.number = 3
QUERYACCCHARGECNTREWARD_INFOS_FIELD.index = 2
QUERYACCCHARGECNTREWARD_INFOS_FIELD.label = 3
QUERYACCCHARGECNTREWARD_INFOS_FIELD.has_default_value = false
QUERYACCCHARGECNTREWARD_INFOS_FIELD.default_value = {}
QUERYACCCHARGECNTREWARD_INFOS_FIELD.message_type = CHARGECNTINFO
QUERYACCCHARGECNTREWARD_INFOS_FIELD.type = 11
QUERYACCCHARGECNTREWARD_INFOS_FIELD.cpp_type = 10
QUERYACCCHARGECNTREWARD.name = "QueryAccChargeCntReward"
QUERYACCCHARGECNTREWARD.full_name = ".Cmd.QueryAccChargeCntReward"
QUERYACCCHARGECNTREWARD.nested_types = {}
QUERYACCCHARGECNTREWARD.enum_types = {}
QUERYACCCHARGECNTREWARD.fields = {
  QUERYACCCHARGECNTREWARD_CMD_FIELD,
  QUERYACCCHARGECNTREWARD_PARAM_FIELD,
  QUERYACCCHARGECNTREWARD_INFOS_FIELD
}
QUERYACCCHARGECNTREWARD.is_extendable = false
QUERYACCCHARGECNTREWARD.extensions = {}
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.name = "cmd"
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.full_name = ".Cmd.ChargeSdkRequestUserEvent.cmd"
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.number = 1
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.index = 0
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.label = 1
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.has_default_value = true
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.default_value = 25
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.type = 14
CHARGESDKREQUESTUSEREVENT_CMD_FIELD.cpp_type = 8
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.name = "param"
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ChargeSdkRequestUserEvent.param"
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.number = 2
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.index = 1
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.label = 1
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.has_default_value = true
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.default_value = 42
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.type = 14
CHARGESDKREQUESTUSEREVENT_PARAM_FIELD.cpp_type = 8
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.name = "dataid"
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.full_name = ".Cmd.ChargeSdkRequestUserEvent.dataid"
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.number = 3
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.index = 2
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.label = 1
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.has_default_value = false
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.default_value = 0
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.type = 13
CHARGESDKREQUESTUSEREVENT_DATAID_FIELD.cpp_type = 3
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.name = "client_timestamp"
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.full_name = ".Cmd.ChargeSdkRequestUserEvent.client_timestamp"
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.number = 4
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.index = 3
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.label = 1
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.has_default_value = false
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.default_value = 0
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.type = 13
CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD.cpp_type = 3
CHARGESDKREQUESTUSEREVENT.name = "ChargeSdkRequestUserEvent"
CHARGESDKREQUESTUSEREVENT.full_name = ".Cmd.ChargeSdkRequestUserEvent"
CHARGESDKREQUESTUSEREVENT.nested_types = {}
CHARGESDKREQUESTUSEREVENT.enum_types = {}
CHARGESDKREQUESTUSEREVENT.fields = {
  CHARGESDKREQUESTUSEREVENT_CMD_FIELD,
  CHARGESDKREQUESTUSEREVENT_PARAM_FIELD,
  CHARGESDKREQUESTUSEREVENT_DATAID_FIELD,
  CHARGESDKREQUESTUSEREVENT_CLIENT_TIMESTAMP_FIELD
}
CHARGESDKREQUESTUSEREVENT.is_extendable = false
CHARGESDKREQUESTUSEREVENT.extensions = {}
CHARGESDKREPLYUSEREVENT_CMD_FIELD.name = "cmd"
CHARGESDKREPLYUSEREVENT_CMD_FIELD.full_name = ".Cmd.ChargeSdkReplyUserEvent.cmd"
CHARGESDKREPLYUSEREVENT_CMD_FIELD.number = 1
CHARGESDKREPLYUSEREVENT_CMD_FIELD.index = 0
CHARGESDKREPLYUSEREVENT_CMD_FIELD.label = 1
CHARGESDKREPLYUSEREVENT_CMD_FIELD.has_default_value = true
CHARGESDKREPLYUSEREVENT_CMD_FIELD.default_value = 25
CHARGESDKREPLYUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHARGESDKREPLYUSEREVENT_CMD_FIELD.type = 14
CHARGESDKREPLYUSEREVENT_CMD_FIELD.cpp_type = 8
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.name = "param"
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ChargeSdkReplyUserEvent.param"
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.number = 2
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.index = 1
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.label = 1
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.has_default_value = true
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.default_value = 43
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.type = 14
CHARGESDKREPLYUSEREVENT_PARAM_FIELD.cpp_type = 8
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.name = "dataid"
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.full_name = ".Cmd.ChargeSdkReplyUserEvent.dataid"
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.number = 3
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.index = 2
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.label = 1
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.has_default_value = false
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.default_value = 0
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.type = 13
CHARGESDKREPLYUSEREVENT_DATAID_FIELD.cpp_type = 3
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.name = "client_timestamp"
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.full_name = ".Cmd.ChargeSdkReplyUserEvent.client_timestamp"
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.number = 4
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.index = 3
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.label = 1
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.has_default_value = false
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.default_value = 0
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.type = 13
CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD.cpp_type = 3
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.name = "success"
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.full_name = ".Cmd.ChargeSdkReplyUserEvent.success"
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.number = 5
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.index = 4
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.label = 1
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.has_default_value = false
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.default_value = false
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.type = 8
CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD.cpp_type = 7
CHARGESDKREPLYUSEREVENT.name = "ChargeSdkReplyUserEvent"
CHARGESDKREPLYUSEREVENT.full_name = ".Cmd.ChargeSdkReplyUserEvent"
CHARGESDKREPLYUSEREVENT.nested_types = {}
CHARGESDKREPLYUSEREVENT.enum_types = {}
CHARGESDKREPLYUSEREVENT.fields = {
  CHARGESDKREPLYUSEREVENT_CMD_FIELD,
  CHARGESDKREPLYUSEREVENT_PARAM_FIELD,
  CHARGESDKREPLYUSEREVENT_DATAID_FIELD,
  CHARGESDKREPLYUSEREVENT_CLIENT_TIMESTAMP_FIELD,
  CHARGESDKREPLYUSEREVENT_SUCCESS_FIELD
}
CHARGESDKREPLYUSEREVENT.is_extendable = false
CHARGESDKREPLYUSEREVENT.extensions = {}
CLIENTAIDATA_EVENTID_FIELD.name = "eventid"
CLIENTAIDATA_EVENTID_FIELD.full_name = ".Cmd.ClientAIData.eventid"
CLIENTAIDATA_EVENTID_FIELD.number = 1
CLIENTAIDATA_EVENTID_FIELD.index = 0
CLIENTAIDATA_EVENTID_FIELD.label = 1
CLIENTAIDATA_EVENTID_FIELD.has_default_value = false
CLIENTAIDATA_EVENTID_FIELD.default_value = 0
CLIENTAIDATA_EVENTID_FIELD.type = 13
CLIENTAIDATA_EVENTID_FIELD.cpp_type = 3
CLIENTAIDATA_PARAM32_FIELD.name = "param32"
CLIENTAIDATA_PARAM32_FIELD.full_name = ".Cmd.ClientAIData.param32"
CLIENTAIDATA_PARAM32_FIELD.number = 2
CLIENTAIDATA_PARAM32_FIELD.index = 1
CLIENTAIDATA_PARAM32_FIELD.label = 3
CLIENTAIDATA_PARAM32_FIELD.has_default_value = false
CLIENTAIDATA_PARAM32_FIELD.default_value = {}
CLIENTAIDATA_PARAM32_FIELD.type = 13
CLIENTAIDATA_PARAM32_FIELD.cpp_type = 3
CLIENTAIDATA_PARAM64_FIELD.name = "param64"
CLIENTAIDATA_PARAM64_FIELD.full_name = ".Cmd.ClientAIData.param64"
CLIENTAIDATA_PARAM64_FIELD.number = 3
CLIENTAIDATA_PARAM64_FIELD.index = 2
CLIENTAIDATA_PARAM64_FIELD.label = 3
CLIENTAIDATA_PARAM64_FIELD.has_default_value = false
CLIENTAIDATA_PARAM64_FIELD.default_value = {}
CLIENTAIDATA_PARAM64_FIELD.type = 4
CLIENTAIDATA_PARAM64_FIELD.cpp_type = 4
CLIENTAIDATA_GUID_FIELD.name = "guid"
CLIENTAIDATA_GUID_FIELD.full_name = ".Cmd.ClientAIData.guid"
CLIENTAIDATA_GUID_FIELD.number = 4
CLIENTAIDATA_GUID_FIELD.index = 3
CLIENTAIDATA_GUID_FIELD.label = 1
CLIENTAIDATA_GUID_FIELD.has_default_value = false
CLIENTAIDATA_GUID_FIELD.default_value = 0
CLIENTAIDATA_GUID_FIELD.type = 13
CLIENTAIDATA_GUID_FIELD.cpp_type = 3
CLIENTAIDATA.name = "ClientAIData"
CLIENTAIDATA.full_name = ".Cmd.ClientAIData"
CLIENTAIDATA.nested_types = {}
CLIENTAIDATA.enum_types = {}
CLIENTAIDATA.fields = {
  CLIENTAIDATA_EVENTID_FIELD,
  CLIENTAIDATA_PARAM32_FIELD,
  CLIENTAIDATA_PARAM64_FIELD,
  CLIENTAIDATA_GUID_FIELD
}
CLIENTAIDATA.is_extendable = false
CLIENTAIDATA.extensions = {}
CLIENTAISYNCUSEREVENT_CMD_FIELD.name = "cmd"
CLIENTAISYNCUSEREVENT_CMD_FIELD.full_name = ".Cmd.ClientAISyncUserEvent.cmd"
CLIENTAISYNCUSEREVENT_CMD_FIELD.number = 1
CLIENTAISYNCUSEREVENT_CMD_FIELD.index = 0
CLIENTAISYNCUSEREVENT_CMD_FIELD.label = 1
CLIENTAISYNCUSEREVENT_CMD_FIELD.has_default_value = true
CLIENTAISYNCUSEREVENT_CMD_FIELD.default_value = 25
CLIENTAISYNCUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLIENTAISYNCUSEREVENT_CMD_FIELD.type = 14
CLIENTAISYNCUSEREVENT_CMD_FIELD.cpp_type = 8
CLIENTAISYNCUSEREVENT_PARAM_FIELD.name = "param"
CLIENTAISYNCUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ClientAISyncUserEvent.param"
CLIENTAISYNCUSEREVENT_PARAM_FIELD.number = 2
CLIENTAISYNCUSEREVENT_PARAM_FIELD.index = 1
CLIENTAISYNCUSEREVENT_PARAM_FIELD.label = 1
CLIENTAISYNCUSEREVENT_PARAM_FIELD.has_default_value = true
CLIENTAISYNCUSEREVENT_PARAM_FIELD.default_value = 44
CLIENTAISYNCUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CLIENTAISYNCUSEREVENT_PARAM_FIELD.type = 14
CLIENTAISYNCUSEREVENT_PARAM_FIELD.cpp_type = 8
CLIENTAISYNCUSEREVENT_CHARID_FIELD.name = "charid"
CLIENTAISYNCUSEREVENT_CHARID_FIELD.full_name = ".Cmd.ClientAISyncUserEvent.charid"
CLIENTAISYNCUSEREVENT_CHARID_FIELD.number = 3
CLIENTAISYNCUSEREVENT_CHARID_FIELD.index = 2
CLIENTAISYNCUSEREVENT_CHARID_FIELD.label = 1
CLIENTAISYNCUSEREVENT_CHARID_FIELD.has_default_value = false
CLIENTAISYNCUSEREVENT_CHARID_FIELD.default_value = 0
CLIENTAISYNCUSEREVENT_CHARID_FIELD.type = 4
CLIENTAISYNCUSEREVENT_CHARID_FIELD.cpp_type = 4
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.name = "aidata"
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.full_name = ".Cmd.ClientAISyncUserEvent.aidata"
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.number = 4
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.index = 3
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.label = 3
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.has_default_value = false
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.default_value = {}
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.message_type = CLIENTAIDATA
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.type = 11
CLIENTAISYNCUSEREVENT_AIDATA_FIELD.cpp_type = 10
CLIENTAISYNCUSEREVENT.name = "ClientAISyncUserEvent"
CLIENTAISYNCUSEREVENT.full_name = ".Cmd.ClientAISyncUserEvent"
CLIENTAISYNCUSEREVENT.nested_types = {}
CLIENTAISYNCUSEREVENT.enum_types = {}
CLIENTAISYNCUSEREVENT.fields = {
  CLIENTAISYNCUSEREVENT_CMD_FIELD,
  CLIENTAISYNCUSEREVENT_PARAM_FIELD,
  CLIENTAISYNCUSEREVENT_CHARID_FIELD,
  CLIENTAISYNCUSEREVENT_AIDATA_FIELD
}
CLIENTAISYNCUSEREVENT.is_extendable = false
CLIENTAISYNCUSEREVENT.extensions = {}
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.name = "cmd"
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.full_name = ".Cmd.ClientAIUpdateUserEvent.cmd"
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.number = 1
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.index = 0
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.label = 1
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.has_default_value = true
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.default_value = 25
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.type = 14
CLIENTAIUPDATEUSEREVENT_CMD_FIELD.cpp_type = 8
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.name = "param"
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ClientAIUpdateUserEvent.param"
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.number = 2
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.index = 1
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.label = 1
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.has_default_value = true
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.default_value = 45
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.type = 14
CLIENTAIUPDATEUSEREVENT_PARAM_FIELD.cpp_type = 8
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.name = "charid"
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.full_name = ".Cmd.ClientAIUpdateUserEvent.charid"
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.number = 3
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.index = 2
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.label = 1
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.has_default_value = false
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.default_value = 0
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.type = 4
CLIENTAIUPDATEUSEREVENT_CHARID_FIELD.cpp_type = 4
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.name = "aidata"
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.full_name = ".Cmd.ClientAIUpdateUserEvent.aidata"
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.number = 4
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.index = 3
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.label = 1
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.has_default_value = false
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.default_value = nil
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.message_type = CLIENTAIDATA
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.type = 11
CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD.cpp_type = 10
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.name = "del"
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.full_name = ".Cmd.ClientAIUpdateUserEvent.del"
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.number = 5
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.index = 4
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.label = 1
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.has_default_value = false
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.default_value = false
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.type = 8
CLIENTAIUPDATEUSEREVENT_DEL_FIELD.cpp_type = 7
CLIENTAIUPDATEUSEREVENT.name = "ClientAIUpdateUserEvent"
CLIENTAIUPDATEUSEREVENT.full_name = ".Cmd.ClientAIUpdateUserEvent"
CLIENTAIUPDATEUSEREVENT.nested_types = {}
CLIENTAIUPDATEUSEREVENT.enum_types = {}
CLIENTAIUPDATEUSEREVENT.fields = {
  CLIENTAIUPDATEUSEREVENT_CMD_FIELD,
  CLIENTAIUPDATEUSEREVENT_PARAM_FIELD,
  CLIENTAIUPDATEUSEREVENT_CHARID_FIELD,
  CLIENTAIUPDATEUSEREVENT_AIDATA_FIELD,
  CLIENTAIUPDATEUSEREVENT_DEL_FIELD
}
CLIENTAIUPDATEUSEREVENT.is_extendable = false
CLIENTAIUPDATEUSEREVENT.extensions = {}
GIFTCODEEXCHANGEEVENT_CMD_FIELD.name = "cmd"
GIFTCODEEXCHANGEEVENT_CMD_FIELD.full_name = ".Cmd.GiftCodeExchangeEvent.cmd"
GIFTCODEEXCHANGEEVENT_CMD_FIELD.number = 1
GIFTCODEEXCHANGEEVENT_CMD_FIELD.index = 0
GIFTCODEEXCHANGEEVENT_CMD_FIELD.label = 1
GIFTCODEEXCHANGEEVENT_CMD_FIELD.has_default_value = true
GIFTCODEEXCHANGEEVENT_CMD_FIELD.default_value = 25
GIFTCODEEXCHANGEEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GIFTCODEEXCHANGEEVENT_CMD_FIELD.type = 14
GIFTCODEEXCHANGEEVENT_CMD_FIELD.cpp_type = 8
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.name = "param"
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.full_name = ".Cmd.GiftCodeExchangeEvent.param"
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.number = 2
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.index = 1
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.label = 1
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.has_default_value = true
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.default_value = 46
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.enum_type = EVENTPARAM
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.type = 14
GIFTCODEEXCHANGEEVENT_PARAM_FIELD.cpp_type = 8
GIFTCODEEXCHANGEEVENT_CODE_FIELD.name = "code"
GIFTCODEEXCHANGEEVENT_CODE_FIELD.full_name = ".Cmd.GiftCodeExchangeEvent.code"
GIFTCODEEXCHANGEEVENT_CODE_FIELD.number = 3
GIFTCODEEXCHANGEEVENT_CODE_FIELD.index = 2
GIFTCODEEXCHANGEEVENT_CODE_FIELD.label = 1
GIFTCODEEXCHANGEEVENT_CODE_FIELD.has_default_value = false
GIFTCODEEXCHANGEEVENT_CODE_FIELD.default_value = ""
GIFTCODEEXCHANGEEVENT_CODE_FIELD.type = 9
GIFTCODEEXCHANGEEVENT_CODE_FIELD.cpp_type = 9
GIFTCODEEXCHANGEEVENT.name = "GiftCodeExchangeEvent"
GIFTCODEEXCHANGEEVENT.full_name = ".Cmd.GiftCodeExchangeEvent"
GIFTCODEEXCHANGEEVENT.nested_types = {}
GIFTCODEEXCHANGEEVENT.enum_types = {}
GIFTCODEEXCHANGEEVENT.fields = {
  GIFTCODEEXCHANGEEVENT_CMD_FIELD,
  GIFTCODEEXCHANGEEVENT_PARAM_FIELD,
  GIFTCODEEXCHANGEEVENT_CODE_FIELD
}
GIFTCODEEXCHANGEEVENT.is_extendable = false
GIFTCODEEXCHANGEEVENT.extensions = {}
SETHIDEOTHERCMD_CMD_FIELD.name = "cmd"
SETHIDEOTHERCMD_CMD_FIELD.full_name = ".Cmd.SetHideOtherCmd.cmd"
SETHIDEOTHERCMD_CMD_FIELD.number = 1
SETHIDEOTHERCMD_CMD_FIELD.index = 0
SETHIDEOTHERCMD_CMD_FIELD.label = 1
SETHIDEOTHERCMD_CMD_FIELD.has_default_value = true
SETHIDEOTHERCMD_CMD_FIELD.default_value = 25
SETHIDEOTHERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETHIDEOTHERCMD_CMD_FIELD.type = 14
SETHIDEOTHERCMD_CMD_FIELD.cpp_type = 8
SETHIDEOTHERCMD_PARAM_FIELD.name = "param"
SETHIDEOTHERCMD_PARAM_FIELD.full_name = ".Cmd.SetHideOtherCmd.param"
SETHIDEOTHERCMD_PARAM_FIELD.number = 2
SETHIDEOTHERCMD_PARAM_FIELD.index = 1
SETHIDEOTHERCMD_PARAM_FIELD.label = 1
SETHIDEOTHERCMD_PARAM_FIELD.has_default_value = true
SETHIDEOTHERCMD_PARAM_FIELD.default_value = 47
SETHIDEOTHERCMD_PARAM_FIELD.enum_type = EVENTPARAM
SETHIDEOTHERCMD_PARAM_FIELD.type = 14
SETHIDEOTHERCMD_PARAM_FIELD.cpp_type = 8
SETHIDEOTHERCMD_HIDEID_FIELD.name = "hideid"
SETHIDEOTHERCMD_HIDEID_FIELD.full_name = ".Cmd.SetHideOtherCmd.hideid"
SETHIDEOTHERCMD_HIDEID_FIELD.number = 3
SETHIDEOTHERCMD_HIDEID_FIELD.index = 2
SETHIDEOTHERCMD_HIDEID_FIELD.label = 1
SETHIDEOTHERCMD_HIDEID_FIELD.has_default_value = true
SETHIDEOTHERCMD_HIDEID_FIELD.default_value = 0
SETHIDEOTHERCMD_HIDEID_FIELD.type = 13
SETHIDEOTHERCMD_HIDEID_FIELD.cpp_type = 3
SETHIDEOTHERCMD.name = "SetHideOtherCmd"
SETHIDEOTHERCMD.full_name = ".Cmd.SetHideOtherCmd"
SETHIDEOTHERCMD.nested_types = {}
SETHIDEOTHERCMD.enum_types = {}
SETHIDEOTHERCMD.fields = {
  SETHIDEOTHERCMD_CMD_FIELD,
  SETHIDEOTHERCMD_PARAM_FIELD,
  SETHIDEOTHERCMD_HIDEID_FIELD
}
SETHIDEOTHERCMD.is_extendable = false
SETHIDEOTHERCMD.extensions = {}
GIFTINFO_ID_FIELD.name = "id"
GIFTINFO_ID_FIELD.full_name = ".Cmd.GiftInfo.id"
GIFTINFO_ID_FIELD.number = 1
GIFTINFO_ID_FIELD.index = 0
GIFTINFO_ID_FIELD.label = 1
GIFTINFO_ID_FIELD.has_default_value = false
GIFTINFO_ID_FIELD.default_value = 0
GIFTINFO_ID_FIELD.type = 13
GIFTINFO_ID_FIELD.cpp_type = 3
GIFTINFO_TIME_FIELD.name = "time"
GIFTINFO_TIME_FIELD.full_name = ".Cmd.GiftInfo.time"
GIFTINFO_TIME_FIELD.number = 2
GIFTINFO_TIME_FIELD.index = 1
GIFTINFO_TIME_FIELD.label = 1
GIFTINFO_TIME_FIELD.has_default_value = false
GIFTINFO_TIME_FIELD.default_value = 0
GIFTINFO_TIME_FIELD.type = 13
GIFTINFO_TIME_FIELD.cpp_type = 3
GIFTINFO_STATE_FIELD.name = "state"
GIFTINFO_STATE_FIELD.full_name = ".Cmd.GiftInfo.state"
GIFTINFO_STATE_FIELD.number = 3
GIFTINFO_STATE_FIELD.index = 2
GIFTINFO_STATE_FIELD.label = 1
GIFTINFO_STATE_FIELD.has_default_value = false
GIFTINFO_STATE_FIELD.default_value = nil
GIFTINFO_STATE_FIELD.enum_type = EGIFTSTATE
GIFTINFO_STATE_FIELD.type = 14
GIFTINFO_STATE_FIELD.cpp_type = 8
GIFTINFO.name = "GiftInfo"
GIFTINFO.full_name = ".Cmd.GiftInfo"
GIFTINFO.nested_types = {}
GIFTINFO.enum_types = {}
GIFTINFO.fields = {
  GIFTINFO_ID_FIELD,
  GIFTINFO_TIME_FIELD,
  GIFTINFO_STATE_FIELD
}
GIFTINFO.is_extendable = false
GIFTINFO.extensions = {}
GIFTEVENT_EVENT_FIELD.name = "event"
GIFTEVENT_EVENT_FIELD.full_name = ".Cmd.GiftEvent.event"
GIFTEVENT_EVENT_FIELD.number = 1
GIFTEVENT_EVENT_FIELD.index = 0
GIFTEVENT_EVENT_FIELD.label = 1
GIFTEVENT_EVENT_FIELD.has_default_value = false
GIFTEVENT_EVENT_FIELD.default_value = 0
GIFTEVENT_EVENT_FIELD.type = 13
GIFTEVENT_EVENT_FIELD.cpp_type = 3
GIFTEVENT_COUNT_FIELD.name = "count"
GIFTEVENT_COUNT_FIELD.full_name = ".Cmd.GiftEvent.count"
GIFTEVENT_COUNT_FIELD.number = 2
GIFTEVENT_COUNT_FIELD.index = 1
GIFTEVENT_COUNT_FIELD.label = 1
GIFTEVENT_COUNT_FIELD.has_default_value = false
GIFTEVENT_COUNT_FIELD.default_value = 0
GIFTEVENT_COUNT_FIELD.type = 13
GIFTEVENT_COUNT_FIELD.cpp_type = 3
GIFTEVENT.name = "GiftEvent"
GIFTEVENT.full_name = ".Cmd.GiftEvent"
GIFTEVENT.nested_types = {}
GIFTEVENT.enum_types = {}
GIFTEVENT.fields = {
  GIFTEVENT_EVENT_FIELD,
  GIFTEVENT_COUNT_FIELD
}
GIFTEVENT.is_extendable = false
GIFTEVENT.extensions = {}
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.name = "cmd"
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.full_name = ".Cmd.GiftTimeLimitNtfUserEvent.cmd"
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.number = 1
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.index = 0
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.label = 1
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.has_default_value = true
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.default_value = 25
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.type = 14
GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD.cpp_type = 8
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.name = "param"
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.full_name = ".Cmd.GiftTimeLimitNtfUserEvent.param"
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.number = 2
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.index = 1
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.label = 1
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.has_default_value = true
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.default_value = 48
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.type = 14
GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD.cpp_type = 8
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.name = "infos"
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.full_name = ".Cmd.GiftTimeLimitNtfUserEvent.infos"
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.number = 3
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.index = 2
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.label = 3
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.has_default_value = false
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.default_value = {}
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.message_type = GIFTINFO
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.type = 11
GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD.cpp_type = 10
GIFTTIMELIMITNTFUSEREVENT.name = "GiftTimeLimitNtfUserEvent"
GIFTTIMELIMITNTFUSEREVENT.full_name = ".Cmd.GiftTimeLimitNtfUserEvent"
GIFTTIMELIMITNTFUSEREVENT.nested_types = {}
GIFTTIMELIMITNTFUSEREVENT.enum_types = {}
GIFTTIMELIMITNTFUSEREVENT.fields = {
  GIFTTIMELIMITNTFUSEREVENT_CMD_FIELD,
  GIFTTIMELIMITNTFUSEREVENT_PARAM_FIELD,
  GIFTTIMELIMITNTFUSEREVENT_INFOS_FIELD
}
GIFTTIMELIMITNTFUSEREVENT.is_extendable = false
GIFTTIMELIMITNTFUSEREVENT.extensions = {}
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.name = "cmd"
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.full_name = ".Cmd.GiftTimeLimitBuyUserEvent.cmd"
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.number = 1
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.index = 0
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.label = 1
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.has_default_value = true
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.default_value = 25
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.type = 14
GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD.cpp_type = 8
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.name = "param"
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.full_name = ".Cmd.GiftTimeLimitBuyUserEvent.param"
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.number = 2
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.index = 1
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.label = 1
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.has_default_value = true
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.default_value = 49
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.type = 14
GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD.cpp_type = 8
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.name = "id"
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.full_name = ".Cmd.GiftTimeLimitBuyUserEvent.id"
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.number = 3
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.index = 2
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.label = 1
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.has_default_value = false
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.default_value = 0
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.type = 13
GIFTTIMELIMITBUYUSEREVENT_ID_FIELD.cpp_type = 3
GIFTTIMELIMITBUYUSEREVENT.name = "GiftTimeLimitBuyUserEvent"
GIFTTIMELIMITBUYUSEREVENT.full_name = ".Cmd.GiftTimeLimitBuyUserEvent"
GIFTTIMELIMITBUYUSEREVENT.nested_types = {}
GIFTTIMELIMITBUYUSEREVENT.enum_types = {}
GIFTTIMELIMITBUYUSEREVENT.fields = {
  GIFTTIMELIMITBUYUSEREVENT_CMD_FIELD,
  GIFTTIMELIMITBUYUSEREVENT_PARAM_FIELD,
  GIFTTIMELIMITBUYUSEREVENT_ID_FIELD
}
GIFTTIMELIMITBUYUSEREVENT.is_extendable = false
GIFTTIMELIMITBUYUSEREVENT.extensions = {}
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.name = "cmd"
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.full_name = ".Cmd.GiftTimeLimitActiveUserEvent.cmd"
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.number = 1
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.index = 0
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.label = 1
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.has_default_value = true
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.default_value = 25
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.type = 14
GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD.cpp_type = 8
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.name = "param"
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.GiftTimeLimitActiveUserEvent.param"
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.number = 2
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.index = 1
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.label = 1
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.has_default_value = true
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.default_value = 50
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.type = 14
GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD.cpp_type = 8
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.name = "id"
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.full_name = ".Cmd.GiftTimeLimitActiveUserEvent.id"
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.number = 3
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.index = 2
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.label = 1
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.has_default_value = false
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.default_value = 0
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.type = 13
GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD.cpp_type = 3
GIFTTIMELIMITACTIVEUSEREVENT.name = "GiftTimeLimitActiveUserEvent"
GIFTTIMELIMITACTIVEUSEREVENT.full_name = ".Cmd.GiftTimeLimitActiveUserEvent"
GIFTTIMELIMITACTIVEUSEREVENT.nested_types = {}
GIFTTIMELIMITACTIVEUSEREVENT.enum_types = {}
GIFTTIMELIMITACTIVEUSEREVENT.fields = {
  GIFTTIMELIMITACTIVEUSEREVENT_CMD_FIELD,
  GIFTTIMELIMITACTIVEUSEREVENT_PARAM_FIELD,
  GIFTTIMELIMITACTIVEUSEREVENT_ID_FIELD
}
GIFTTIMELIMITACTIVEUSEREVENT.is_extendable = false
GIFTTIMELIMITACTIVEUSEREVENT.extensions = {}
MULTICUTSCENE_ID_FIELD.name = "id"
MULTICUTSCENE_ID_FIELD.full_name = ".Cmd.MultiCutScene.id"
MULTICUTSCENE_ID_FIELD.number = 1
MULTICUTSCENE_ID_FIELD.index = 0
MULTICUTSCENE_ID_FIELD.label = 1
MULTICUTSCENE_ID_FIELD.has_default_value = false
MULTICUTSCENE_ID_FIELD.default_value = 0
MULTICUTSCENE_ID_FIELD.type = 13
MULTICUTSCENE_ID_FIELD.cpp_type = 3
MULTICUTSCENE_MAPID_FIELD.name = "mapid"
MULTICUTSCENE_MAPID_FIELD.full_name = ".Cmd.MultiCutScene.mapid"
MULTICUTSCENE_MAPID_FIELD.number = 2
MULTICUTSCENE_MAPID_FIELD.index = 1
MULTICUTSCENE_MAPID_FIELD.label = 1
MULTICUTSCENE_MAPID_FIELD.has_default_value = false
MULTICUTSCENE_MAPID_FIELD.default_value = 0
MULTICUTSCENE_MAPID_FIELD.type = 13
MULTICUTSCENE_MAPID_FIELD.cpp_type = 3
MULTICUTSCENE_QUESTID_FIELD.name = "questid"
MULTICUTSCENE_QUESTID_FIELD.full_name = ".Cmd.MultiCutScene.questid"
MULTICUTSCENE_QUESTID_FIELD.number = 3
MULTICUTSCENE_QUESTID_FIELD.index = 2
MULTICUTSCENE_QUESTID_FIELD.label = 1
MULTICUTSCENE_QUESTID_FIELD.has_default_value = false
MULTICUTSCENE_QUESTID_FIELD.default_value = 0
MULTICUTSCENE_QUESTID_FIELD.type = 13
MULTICUTSCENE_QUESTID_FIELD.cpp_type = 3
MULTICUTSCENE_PARAM_FIELD.name = "param"
MULTICUTSCENE_PARAM_FIELD.full_name = ".Cmd.MultiCutScene.param"
MULTICUTSCENE_PARAM_FIELD.number = 4
MULTICUTSCENE_PARAM_FIELD.index = 3
MULTICUTSCENE_PARAM_FIELD.label = 1
MULTICUTSCENE_PARAM_FIELD.has_default_value = false
MULTICUTSCENE_PARAM_FIELD.default_value = nil
MULTICUTSCENE_PARAM_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
MULTICUTSCENE_PARAM_FIELD.type = 11
MULTICUTSCENE_PARAM_FIELD.cpp_type = 10
MULTICUTSCENE.name = "MultiCutScene"
MULTICUTSCENE.full_name = ".Cmd.MultiCutScene"
MULTICUTSCENE.nested_types = {}
MULTICUTSCENE.enum_types = {}
MULTICUTSCENE.fields = {
  MULTICUTSCENE_ID_FIELD,
  MULTICUTSCENE_MAPID_FIELD,
  MULTICUTSCENE_QUESTID_FIELD,
  MULTICUTSCENE_PARAM_FIELD
}
MULTICUTSCENE.is_extendable = false
MULTICUTSCENE.extensions = {}
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.name = "cmd"
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.full_name = ".Cmd.MultiCutSceneUpdateUserEvent.cmd"
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.number = 1
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.index = 0
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.label = 1
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.has_default_value = true
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.default_value = 25
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.type = 14
MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD.cpp_type = 8
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.name = "param"
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.MultiCutSceneUpdateUserEvent.param"
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.number = 2
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.index = 1
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.label = 1
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.has_default_value = true
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.default_value = 55
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.type = 14
MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD.cpp_type = 8
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.name = "updates"
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.full_name = ".Cmd.MultiCutSceneUpdateUserEvent.updates"
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.number = 3
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.index = 2
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.label = 3
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.has_default_value = false
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.default_value = {}
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.message_type = MULTICUTSCENE
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.type = 11
MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD.cpp_type = 10
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.name = "dels"
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.full_name = ".Cmd.MultiCutSceneUpdateUserEvent.dels"
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.number = 4
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.index = 3
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.label = 3
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.has_default_value = false
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.default_value = {}
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.type = 13
MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD.cpp_type = 3
MULTICUTSCENEUPDATEUSEREVENT.name = "MultiCutSceneUpdateUserEvent"
MULTICUTSCENEUPDATEUSEREVENT.full_name = ".Cmd.MultiCutSceneUpdateUserEvent"
MULTICUTSCENEUPDATEUSEREVENT.nested_types = {}
MULTICUTSCENEUPDATEUSEREVENT.enum_types = {}
MULTICUTSCENEUPDATEUSEREVENT.fields = {
  MULTICUTSCENEUPDATEUSEREVENT_CMD_FIELD,
  MULTICUTSCENEUPDATEUSEREVENT_PARAM_FIELD,
  MULTICUTSCENEUPDATEUSEREVENT_UPDATES_FIELD,
  MULTICUTSCENEUPDATEUSEREVENT_DELS_FIELD
}
MULTICUTSCENEUPDATEUSEREVENT.is_extendable = false
MULTICUTSCENEUPDATEUSEREVENT.extensions = {}
POLICYUPDATEUSEREVENT_CMD_FIELD.name = "cmd"
POLICYUPDATEUSEREVENT_CMD_FIELD.full_name = ".Cmd.PolicyUpdateUserEvent.cmd"
POLICYUPDATEUSEREVENT_CMD_FIELD.number = 1
POLICYUPDATEUSEREVENT_CMD_FIELD.index = 0
POLICYUPDATEUSEREVENT_CMD_FIELD.label = 1
POLICYUPDATEUSEREVENT_CMD_FIELD.has_default_value = true
POLICYUPDATEUSEREVENT_CMD_FIELD.default_value = 25
POLICYUPDATEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
POLICYUPDATEUSEREVENT_CMD_FIELD.type = 14
POLICYUPDATEUSEREVENT_CMD_FIELD.cpp_type = 8
POLICYUPDATEUSEREVENT_PARAM_FIELD.name = "param"
POLICYUPDATEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.PolicyUpdateUserEvent.param"
POLICYUPDATEUSEREVENT_PARAM_FIELD.number = 2
POLICYUPDATEUSEREVENT_PARAM_FIELD.index = 1
POLICYUPDATEUSEREVENT_PARAM_FIELD.label = 1
POLICYUPDATEUSEREVENT_PARAM_FIELD.has_default_value = true
POLICYUPDATEUSEREVENT_PARAM_FIELD.default_value = 56
POLICYUPDATEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
POLICYUPDATEUSEREVENT_PARAM_FIELD.type = 14
POLICYUPDATEUSEREVENT_PARAM_FIELD.cpp_type = 8
POLICYUPDATEUSEREVENT_TAG_FIELD.name = "tag"
POLICYUPDATEUSEREVENT_TAG_FIELD.full_name = ".Cmd.PolicyUpdateUserEvent.tag"
POLICYUPDATEUSEREVENT_TAG_FIELD.number = 3
POLICYUPDATEUSEREVENT_TAG_FIELD.index = 2
POLICYUPDATEUSEREVENT_TAG_FIELD.label = 1
POLICYUPDATEUSEREVENT_TAG_FIELD.has_default_value = false
POLICYUPDATEUSEREVENT_TAG_FIELD.default_value = 0
POLICYUPDATEUSEREVENT_TAG_FIELD.type = 13
POLICYUPDATEUSEREVENT_TAG_FIELD.cpp_type = 3
POLICYUPDATEUSEREVENT.name = "PolicyUpdateUserEvent"
POLICYUPDATEUSEREVENT.full_name = ".Cmd.PolicyUpdateUserEvent"
POLICYUPDATEUSEREVENT.nested_types = {}
POLICYUPDATEUSEREVENT.enum_types = {}
POLICYUPDATEUSEREVENT.fields = {
  POLICYUPDATEUSEREVENT_CMD_FIELD,
  POLICYUPDATEUSEREVENT_PARAM_FIELD,
  POLICYUPDATEUSEREVENT_TAG_FIELD
}
POLICYUPDATEUSEREVENT.is_extendable = false
POLICYUPDATEUSEREVENT.extensions = {}
POLICYAGREEUSEREVENT_CMD_FIELD.name = "cmd"
POLICYAGREEUSEREVENT_CMD_FIELD.full_name = ".Cmd.PolicyAgreeUserEvent.cmd"
POLICYAGREEUSEREVENT_CMD_FIELD.number = 1
POLICYAGREEUSEREVENT_CMD_FIELD.index = 0
POLICYAGREEUSEREVENT_CMD_FIELD.label = 1
POLICYAGREEUSEREVENT_CMD_FIELD.has_default_value = true
POLICYAGREEUSEREVENT_CMD_FIELD.default_value = 25
POLICYAGREEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
POLICYAGREEUSEREVENT_CMD_FIELD.type = 14
POLICYAGREEUSEREVENT_CMD_FIELD.cpp_type = 8
POLICYAGREEUSEREVENT_PARAM_FIELD.name = "param"
POLICYAGREEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.PolicyAgreeUserEvent.param"
POLICYAGREEUSEREVENT_PARAM_FIELD.number = 2
POLICYAGREEUSEREVENT_PARAM_FIELD.index = 1
POLICYAGREEUSEREVENT_PARAM_FIELD.label = 1
POLICYAGREEUSEREVENT_PARAM_FIELD.has_default_value = true
POLICYAGREEUSEREVENT_PARAM_FIELD.default_value = 57
POLICYAGREEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
POLICYAGREEUSEREVENT_PARAM_FIELD.type = 14
POLICYAGREEUSEREVENT_PARAM_FIELD.cpp_type = 8
POLICYAGREEUSEREVENT.name = "PolicyAgreeUserEvent"
POLICYAGREEUSEREVENT.full_name = ".Cmd.PolicyAgreeUserEvent"
POLICYAGREEUSEREVENT.nested_types = {}
POLICYAGREEUSEREVENT.enum_types = {}
POLICYAGREEUSEREVENT.fields = {
  POLICYAGREEUSEREVENT_CMD_FIELD,
  POLICYAGREEUSEREVENT_PARAM_FIELD
}
POLICYAGREEUSEREVENT.is_extendable = false
POLICYAGREEUSEREVENT.extensions = {}
SHOWSCENEOBJECT_CMD_FIELD.name = "cmd"
SHOWSCENEOBJECT_CMD_FIELD.full_name = ".Cmd.ShowSceneObject.cmd"
SHOWSCENEOBJECT_CMD_FIELD.number = 1
SHOWSCENEOBJECT_CMD_FIELD.index = 0
SHOWSCENEOBJECT_CMD_FIELD.label = 1
SHOWSCENEOBJECT_CMD_FIELD.has_default_value = true
SHOWSCENEOBJECT_CMD_FIELD.default_value = 25
SHOWSCENEOBJECT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHOWSCENEOBJECT_CMD_FIELD.type = 14
SHOWSCENEOBJECT_CMD_FIELD.cpp_type = 8
SHOWSCENEOBJECT_PARAM_FIELD.name = "param"
SHOWSCENEOBJECT_PARAM_FIELD.full_name = ".Cmd.ShowSceneObject.param"
SHOWSCENEOBJECT_PARAM_FIELD.number = 2
SHOWSCENEOBJECT_PARAM_FIELD.index = 1
SHOWSCENEOBJECT_PARAM_FIELD.label = 1
SHOWSCENEOBJECT_PARAM_FIELD.has_default_value = true
SHOWSCENEOBJECT_PARAM_FIELD.default_value = 58
SHOWSCENEOBJECT_PARAM_FIELD.enum_type = EVENTPARAM
SHOWSCENEOBJECT_PARAM_FIELD.type = 14
SHOWSCENEOBJECT_PARAM_FIELD.cpp_type = 8
SHOWSCENEOBJECT_MAPID_FIELD.name = "mapid"
SHOWSCENEOBJECT_MAPID_FIELD.full_name = ".Cmd.ShowSceneObject.mapid"
SHOWSCENEOBJECT_MAPID_FIELD.number = 3
SHOWSCENEOBJECT_MAPID_FIELD.index = 2
SHOWSCENEOBJECT_MAPID_FIELD.label = 1
SHOWSCENEOBJECT_MAPID_FIELD.has_default_value = true
SHOWSCENEOBJECT_MAPID_FIELD.default_value = 0
SHOWSCENEOBJECT_MAPID_FIELD.type = 13
SHOWSCENEOBJECT_MAPID_FIELD.cpp_type = 3
SHOWSCENEOBJECT_HIDE_FIELD.name = "hide"
SHOWSCENEOBJECT_HIDE_FIELD.full_name = ".Cmd.ShowSceneObject.hide"
SHOWSCENEOBJECT_HIDE_FIELD.number = 4
SHOWSCENEOBJECT_HIDE_FIELD.index = 3
SHOWSCENEOBJECT_HIDE_FIELD.label = 1
SHOWSCENEOBJECT_HIDE_FIELD.has_default_value = true
SHOWSCENEOBJECT_HIDE_FIELD.default_value = false
SHOWSCENEOBJECT_HIDE_FIELD.type = 8
SHOWSCENEOBJECT_HIDE_FIELD.cpp_type = 7
SHOWSCENEOBJECT_NPCID_FIELD.name = "npcid"
SHOWSCENEOBJECT_NPCID_FIELD.full_name = ".Cmd.ShowSceneObject.npcid"
SHOWSCENEOBJECT_NPCID_FIELD.number = 5
SHOWSCENEOBJECT_NPCID_FIELD.index = 4
SHOWSCENEOBJECT_NPCID_FIELD.label = 3
SHOWSCENEOBJECT_NPCID_FIELD.has_default_value = false
SHOWSCENEOBJECT_NPCID_FIELD.default_value = {}
SHOWSCENEOBJECT_NPCID_FIELD.type = 13
SHOWSCENEOBJECT_NPCID_FIELD.cpp_type = 3
SHOWSCENEOBJECT_OBJECTID_FIELD.name = "objectid"
SHOWSCENEOBJECT_OBJECTID_FIELD.full_name = ".Cmd.ShowSceneObject.objectid"
SHOWSCENEOBJECT_OBJECTID_FIELD.number = 6
SHOWSCENEOBJECT_OBJECTID_FIELD.index = 5
SHOWSCENEOBJECT_OBJECTID_FIELD.label = 3
SHOWSCENEOBJECT_OBJECTID_FIELD.has_default_value = false
SHOWSCENEOBJECT_OBJECTID_FIELD.default_value = {}
SHOWSCENEOBJECT_OBJECTID_FIELD.type = 13
SHOWSCENEOBJECT_OBJECTID_FIELD.cpp_type = 3
SHOWSCENEOBJECT.name = "ShowSceneObject"
SHOWSCENEOBJECT.full_name = ".Cmd.ShowSceneObject"
SHOWSCENEOBJECT.nested_types = {}
SHOWSCENEOBJECT.enum_types = {}
SHOWSCENEOBJECT.fields = {
  SHOWSCENEOBJECT_CMD_FIELD,
  SHOWSCENEOBJECT_PARAM_FIELD,
  SHOWSCENEOBJECT_MAPID_FIELD,
  SHOWSCENEOBJECT_HIDE_FIELD,
  SHOWSCENEOBJECT_NPCID_FIELD,
  SHOWSCENEOBJECT_OBJECTID_FIELD
}
SHOWSCENEOBJECT.is_extendable = false
SHOWSCENEOBJECT.extensions = {}
DOUBLEACIONEVENT_CMD_FIELD.name = "cmd"
DOUBLEACIONEVENT_CMD_FIELD.full_name = ".Cmd.DoubleAcionEvent.cmd"
DOUBLEACIONEVENT_CMD_FIELD.number = 1
DOUBLEACIONEVENT_CMD_FIELD.index = 0
DOUBLEACIONEVENT_CMD_FIELD.label = 1
DOUBLEACIONEVENT_CMD_FIELD.has_default_value = true
DOUBLEACIONEVENT_CMD_FIELD.default_value = 25
DOUBLEACIONEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
DOUBLEACIONEVENT_CMD_FIELD.type = 14
DOUBLEACIONEVENT_CMD_FIELD.cpp_type = 8
DOUBLEACIONEVENT_PARAM_FIELD.name = "param"
DOUBLEACIONEVENT_PARAM_FIELD.full_name = ".Cmd.DoubleAcionEvent.param"
DOUBLEACIONEVENT_PARAM_FIELD.number = 2
DOUBLEACIONEVENT_PARAM_FIELD.index = 1
DOUBLEACIONEVENT_PARAM_FIELD.label = 1
DOUBLEACIONEVENT_PARAM_FIELD.has_default_value = true
DOUBLEACIONEVENT_PARAM_FIELD.default_value = 59
DOUBLEACIONEVENT_PARAM_FIELD.enum_type = EVENTPARAM
DOUBLEACIONEVENT_PARAM_FIELD.type = 14
DOUBLEACIONEVENT_PARAM_FIELD.cpp_type = 8
DOUBLEACIONEVENT_USERID_FIELD.name = "userid"
DOUBLEACIONEVENT_USERID_FIELD.full_name = ".Cmd.DoubleAcionEvent.userid"
DOUBLEACIONEVENT_USERID_FIELD.number = 3
DOUBLEACIONEVENT_USERID_FIELD.index = 2
DOUBLEACIONEVENT_USERID_FIELD.label = 1
DOUBLEACIONEVENT_USERID_FIELD.has_default_value = true
DOUBLEACIONEVENT_USERID_FIELD.default_value = 0
DOUBLEACIONEVENT_USERID_FIELD.type = 4
DOUBLEACIONEVENT_USERID_FIELD.cpp_type = 4
DOUBLEACIONEVENT_ACTIONID_FIELD.name = "actionid"
DOUBLEACIONEVENT_ACTIONID_FIELD.full_name = ".Cmd.DoubleAcionEvent.actionid"
DOUBLEACIONEVENT_ACTIONID_FIELD.number = 4
DOUBLEACIONEVENT_ACTIONID_FIELD.index = 3
DOUBLEACIONEVENT_ACTIONID_FIELD.label = 1
DOUBLEACIONEVENT_ACTIONID_FIELD.has_default_value = true
DOUBLEACIONEVENT_ACTIONID_FIELD.default_value = 0
DOUBLEACIONEVENT_ACTIONID_FIELD.type = 13
DOUBLEACIONEVENT_ACTIONID_FIELD.cpp_type = 3
DOUBLEACIONEVENT.name = "DoubleAcionEvent"
DOUBLEACIONEVENT.full_name = ".Cmd.DoubleAcionEvent"
DOUBLEACIONEVENT.nested_types = {}
DOUBLEACIONEVENT.enum_types = {}
DOUBLEACIONEVENT.fields = {
  DOUBLEACIONEVENT_CMD_FIELD,
  DOUBLEACIONEVENT_PARAM_FIELD,
  DOUBLEACIONEVENT_USERID_FIELD,
  DOUBLEACIONEVENT_ACTIONID_FIELD
}
DOUBLEACIONEVENT.is_extendable = false
DOUBLEACIONEVENT.extensions = {}
BEGINMONITORUSEREVENT_CMD_FIELD.name = "cmd"
BEGINMONITORUSEREVENT_CMD_FIELD.full_name = ".Cmd.BeginMonitorUserEvent.cmd"
BEGINMONITORUSEREVENT_CMD_FIELD.number = 1
BEGINMONITORUSEREVENT_CMD_FIELD.index = 0
BEGINMONITORUSEREVENT_CMD_FIELD.label = 1
BEGINMONITORUSEREVENT_CMD_FIELD.has_default_value = true
BEGINMONITORUSEREVENT_CMD_FIELD.default_value = 25
BEGINMONITORUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BEGINMONITORUSEREVENT_CMD_FIELD.type = 14
BEGINMONITORUSEREVENT_CMD_FIELD.cpp_type = 8
BEGINMONITORUSEREVENT_PARAM_FIELD.name = "param"
BEGINMONITORUSEREVENT_PARAM_FIELD.full_name = ".Cmd.BeginMonitorUserEvent.param"
BEGINMONITORUSEREVENT_PARAM_FIELD.number = 2
BEGINMONITORUSEREVENT_PARAM_FIELD.index = 1
BEGINMONITORUSEREVENT_PARAM_FIELD.label = 1
BEGINMONITORUSEREVENT_PARAM_FIELD.has_default_value = true
BEGINMONITORUSEREVENT_PARAM_FIELD.default_value = 60
BEGINMONITORUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
BEGINMONITORUSEREVENT_PARAM_FIELD.type = 14
BEGINMONITORUSEREVENT_PARAM_FIELD.cpp_type = 8
BEGINMONITORUSEREVENT_CHARID_FIELD.name = "charid"
BEGINMONITORUSEREVENT_CHARID_FIELD.full_name = ".Cmd.BeginMonitorUserEvent.charid"
BEGINMONITORUSEREVENT_CHARID_FIELD.number = 3
BEGINMONITORUSEREVENT_CHARID_FIELD.index = 2
BEGINMONITORUSEREVENT_CHARID_FIELD.label = 1
BEGINMONITORUSEREVENT_CHARID_FIELD.has_default_value = false
BEGINMONITORUSEREVENT_CHARID_FIELD.default_value = 0
BEGINMONITORUSEREVENT_CHARID_FIELD.type = 4
BEGINMONITORUSEREVENT_CHARID_FIELD.cpp_type = 4
BEGINMONITORUSEREVENT.name = "BeginMonitorUserEvent"
BEGINMONITORUSEREVENT.full_name = ".Cmd.BeginMonitorUserEvent"
BEGINMONITORUSEREVENT.nested_types = {}
BEGINMONITORUSEREVENT.enum_types = {}
BEGINMONITORUSEREVENT.fields = {
  BEGINMONITORUSEREVENT_CMD_FIELD,
  BEGINMONITORUSEREVENT_PARAM_FIELD,
  BEGINMONITORUSEREVENT_CHARID_FIELD
}
BEGINMONITORUSEREVENT.is_extendable = false
BEGINMONITORUSEREVENT.extensions = {}
STOPMONITORUSEREVENT_CMD_FIELD.name = "cmd"
STOPMONITORUSEREVENT_CMD_FIELD.full_name = ".Cmd.StopMonitorUserEvent.cmd"
STOPMONITORUSEREVENT_CMD_FIELD.number = 1
STOPMONITORUSEREVENT_CMD_FIELD.index = 0
STOPMONITORUSEREVENT_CMD_FIELD.label = 1
STOPMONITORUSEREVENT_CMD_FIELD.has_default_value = true
STOPMONITORUSEREVENT_CMD_FIELD.default_value = 25
STOPMONITORUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STOPMONITORUSEREVENT_CMD_FIELD.type = 14
STOPMONITORUSEREVENT_CMD_FIELD.cpp_type = 8
STOPMONITORUSEREVENT_PARAM_FIELD.name = "param"
STOPMONITORUSEREVENT_PARAM_FIELD.full_name = ".Cmd.StopMonitorUserEvent.param"
STOPMONITORUSEREVENT_PARAM_FIELD.number = 2
STOPMONITORUSEREVENT_PARAM_FIELD.index = 1
STOPMONITORUSEREVENT_PARAM_FIELD.label = 1
STOPMONITORUSEREVENT_PARAM_FIELD.has_default_value = true
STOPMONITORUSEREVENT_PARAM_FIELD.default_value = 61
STOPMONITORUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
STOPMONITORUSEREVENT_PARAM_FIELD.type = 14
STOPMONITORUSEREVENT_PARAM_FIELD.cpp_type = 8
STOPMONITORUSEREVENT.name = "StopMonitorUserEvent"
STOPMONITORUSEREVENT.full_name = ".Cmd.StopMonitorUserEvent"
STOPMONITORUSEREVENT.nested_types = {}
STOPMONITORUSEREVENT.enum_types = {}
STOPMONITORUSEREVENT.fields = {
  STOPMONITORUSEREVENT_CMD_FIELD,
  STOPMONITORUSEREVENT_PARAM_FIELD
}
STOPMONITORUSEREVENT.is_extendable = false
STOPMONITORUSEREVENT.extensions = {}
STOPMONITORRETUSEREVENT_CMD_FIELD.name = "cmd"
STOPMONITORRETUSEREVENT_CMD_FIELD.full_name = ".Cmd.StopMonitorRetUserEvent.cmd"
STOPMONITORRETUSEREVENT_CMD_FIELD.number = 1
STOPMONITORRETUSEREVENT_CMD_FIELD.index = 0
STOPMONITORRETUSEREVENT_CMD_FIELD.label = 1
STOPMONITORRETUSEREVENT_CMD_FIELD.has_default_value = true
STOPMONITORRETUSEREVENT_CMD_FIELD.default_value = 25
STOPMONITORRETUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STOPMONITORRETUSEREVENT_CMD_FIELD.type = 14
STOPMONITORRETUSEREVENT_CMD_FIELD.cpp_type = 8
STOPMONITORRETUSEREVENT_PARAM_FIELD.name = "param"
STOPMONITORRETUSEREVENT_PARAM_FIELD.full_name = ".Cmd.StopMonitorRetUserEvent.param"
STOPMONITORRETUSEREVENT_PARAM_FIELD.number = 2
STOPMONITORRETUSEREVENT_PARAM_FIELD.index = 1
STOPMONITORRETUSEREVENT_PARAM_FIELD.label = 1
STOPMONITORRETUSEREVENT_PARAM_FIELD.has_default_value = true
STOPMONITORRETUSEREVENT_PARAM_FIELD.default_value = 65
STOPMONITORRETUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
STOPMONITORRETUSEREVENT_PARAM_FIELD.type = 14
STOPMONITORRETUSEREVENT_PARAM_FIELD.cpp_type = 8
STOPMONITORRETUSEREVENT.name = "StopMonitorRetUserEvent"
STOPMONITORRETUSEREVENT.full_name = ".Cmd.StopMonitorRetUserEvent"
STOPMONITORRETUSEREVENT.nested_types = {}
STOPMONITORRETUSEREVENT.enum_types = {}
STOPMONITORRETUSEREVENT.fields = {
  STOPMONITORRETUSEREVENT_CMD_FIELD,
  STOPMONITORRETUSEREVENT_PARAM_FIELD
}
STOPMONITORRETUSEREVENT.is_extendable = false
STOPMONITORRETUSEREVENT.extensions = {}
MONITORGOTOMAPUSEREVENT_CMD_FIELD.name = "cmd"
MONITORGOTOMAPUSEREVENT_CMD_FIELD.full_name = ".Cmd.MonitorGoToMapUserEvent.cmd"
MONITORGOTOMAPUSEREVENT_CMD_FIELD.number = 1
MONITORGOTOMAPUSEREVENT_CMD_FIELD.index = 0
MONITORGOTOMAPUSEREVENT_CMD_FIELD.label = 1
MONITORGOTOMAPUSEREVENT_CMD_FIELD.has_default_value = true
MONITORGOTOMAPUSEREVENT_CMD_FIELD.default_value = 25
MONITORGOTOMAPUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MONITORGOTOMAPUSEREVENT_CMD_FIELD.type = 14
MONITORGOTOMAPUSEREVENT_CMD_FIELD.cpp_type = 8
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.name = "param"
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.full_name = ".Cmd.MonitorGoToMapUserEvent.param"
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.number = 2
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.index = 1
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.label = 1
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.has_default_value = true
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.default_value = 62
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.type = 14
MONITORGOTOMAPUSEREVENT_PARAM_FIELD.cpp_type = 8
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.name = "monitor_charid"
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.full_name = ".Cmd.MonitorGoToMapUserEvent.monitor_charid"
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.number = 3
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.index = 2
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.label = 1
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.has_default_value = false
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.default_value = 0
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.type = 4
MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD.cpp_type = 4
MONITORGOTOMAPUSEREVENT.name = "MonitorGoToMapUserEvent"
MONITORGOTOMAPUSEREVENT.full_name = ".Cmd.MonitorGoToMapUserEvent"
MONITORGOTOMAPUSEREVENT.nested_types = {}
MONITORGOTOMAPUSEREVENT.enum_types = {}
MONITORGOTOMAPUSEREVENT.fields = {
  MONITORGOTOMAPUSEREVENT_CMD_FIELD,
  MONITORGOTOMAPUSEREVENT_PARAM_FIELD,
  MONITORGOTOMAPUSEREVENT_MONITOR_CHARID_FIELD
}
MONITORGOTOMAPUSEREVENT.is_extendable = false
MONITORGOTOMAPUSEREVENT.extensions = {}
MONITORMAPENDUSEREVENT_CMD_FIELD.name = "cmd"
MONITORMAPENDUSEREVENT_CMD_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.cmd"
MONITORMAPENDUSEREVENT_CMD_FIELD.number = 1
MONITORMAPENDUSEREVENT_CMD_FIELD.index = 0
MONITORMAPENDUSEREVENT_CMD_FIELD.label = 1
MONITORMAPENDUSEREVENT_CMD_FIELD.has_default_value = true
MONITORMAPENDUSEREVENT_CMD_FIELD.default_value = 25
MONITORMAPENDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MONITORMAPENDUSEREVENT_CMD_FIELD.type = 14
MONITORMAPENDUSEREVENT_CMD_FIELD.cpp_type = 8
MONITORMAPENDUSEREVENT_PARAM_FIELD.name = "param"
MONITORMAPENDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.param"
MONITORMAPENDUSEREVENT_PARAM_FIELD.number = 2
MONITORMAPENDUSEREVENT_PARAM_FIELD.index = 1
MONITORMAPENDUSEREVENT_PARAM_FIELD.label = 1
MONITORMAPENDUSEREVENT_PARAM_FIELD.has_default_value = true
MONITORMAPENDUSEREVENT_PARAM_FIELD.default_value = 63
MONITORMAPENDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
MONITORMAPENDUSEREVENT_PARAM_FIELD.type = 14
MONITORMAPENDUSEREVENT_PARAM_FIELD.cpp_type = 8
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.name = "monitor_accid"
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.monitor_accid"
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.number = 3
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.index = 2
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.label = 1
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.has_default_value = false
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.default_value = 0
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.type = 4
MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD.cpp_type = 4
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.name = "monitor_charid"
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.monitor_charid"
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.number = 4
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.index = 3
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.label = 1
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.has_default_value = false
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.default_value = 0
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.type = 4
MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD.cpp_type = 4
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.name = "monitor_proxyid"
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.monitor_proxyid"
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.number = 5
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.index = 4
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.label = 1
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.has_default_value = false
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.default_value = ""
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.type = 9
MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD.cpp_type = 9
MONITORMAPENDUSEREVENT_MAPID_FIELD.name = "mapid"
MONITORMAPENDUSEREVENT_MAPID_FIELD.full_name = ".Cmd.MonitorMapEndUserEvent.mapid"
MONITORMAPENDUSEREVENT_MAPID_FIELD.number = 6
MONITORMAPENDUSEREVENT_MAPID_FIELD.index = 5
MONITORMAPENDUSEREVENT_MAPID_FIELD.label = 1
MONITORMAPENDUSEREVENT_MAPID_FIELD.has_default_value = false
MONITORMAPENDUSEREVENT_MAPID_FIELD.default_value = 0
MONITORMAPENDUSEREVENT_MAPID_FIELD.type = 13
MONITORMAPENDUSEREVENT_MAPID_FIELD.cpp_type = 3
MONITORMAPENDUSEREVENT.name = "MonitorMapEndUserEvent"
MONITORMAPENDUSEREVENT.full_name = ".Cmd.MonitorMapEndUserEvent"
MONITORMAPENDUSEREVENT.nested_types = {}
MONITORMAPENDUSEREVENT.enum_types = {}
MONITORMAPENDUSEREVENT.fields = {
  MONITORMAPENDUSEREVENT_CMD_FIELD,
  MONITORMAPENDUSEREVENT_PARAM_FIELD,
  MONITORMAPENDUSEREVENT_MONITOR_ACCID_FIELD,
  MONITORMAPENDUSEREVENT_MONITOR_CHARID_FIELD,
  MONITORMAPENDUSEREVENT_MONITOR_PROXYID_FIELD,
  MONITORMAPENDUSEREVENT_MAPID_FIELD
}
MONITORMAPENDUSEREVENT.is_extendable = false
MONITORMAPENDUSEREVENT.extensions = {}
MONITORBUILDUSEREVENT_CMD_FIELD.name = "cmd"
MONITORBUILDUSEREVENT_CMD_FIELD.full_name = ".Cmd.MonitorBuildUserEvent.cmd"
MONITORBUILDUSEREVENT_CMD_FIELD.number = 1
MONITORBUILDUSEREVENT_CMD_FIELD.index = 0
MONITORBUILDUSEREVENT_CMD_FIELD.label = 1
MONITORBUILDUSEREVENT_CMD_FIELD.has_default_value = true
MONITORBUILDUSEREVENT_CMD_FIELD.default_value = 25
MONITORBUILDUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MONITORBUILDUSEREVENT_CMD_FIELD.type = 14
MONITORBUILDUSEREVENT_CMD_FIELD.cpp_type = 8
MONITORBUILDUSEREVENT_PARAM_FIELD.name = "param"
MONITORBUILDUSEREVENT_PARAM_FIELD.full_name = ".Cmd.MonitorBuildUserEvent.param"
MONITORBUILDUSEREVENT_PARAM_FIELD.number = 2
MONITORBUILDUSEREVENT_PARAM_FIELD.index = 1
MONITORBUILDUSEREVENT_PARAM_FIELD.label = 1
MONITORBUILDUSEREVENT_PARAM_FIELD.has_default_value = true
MONITORBUILDUSEREVENT_PARAM_FIELD.default_value = 64
MONITORBUILDUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
MONITORBUILDUSEREVENT_PARAM_FIELD.type = 14
MONITORBUILDUSEREVENT_PARAM_FIELD.cpp_type = 8
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.name = "be_monitor_charid"
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.full_name = ".Cmd.MonitorBuildUserEvent.be_monitor_charid"
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.number = 3
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.index = 2
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.label = 1
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.has_default_value = false
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.default_value = 0
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.type = 4
MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD.cpp_type = 4
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.name = "be_monitor_accid"
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.full_name = ".Cmd.MonitorBuildUserEvent.be_monitor_accid"
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.number = 4
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.index = 3
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.label = 1
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.has_default_value = false
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.default_value = 0
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.type = 4
MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD.cpp_type = 4
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.name = "be_monitor_proxyid"
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.full_name = ".Cmd.MonitorBuildUserEvent.be_monitor_proxyid"
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.number = 5
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.index = 4
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.label = 1
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.has_default_value = false
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.default_value = ""
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.type = 9
MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD.cpp_type = 9
MONITORBUILDUSEREVENT.name = "MonitorBuildUserEvent"
MONITORBUILDUSEREVENT.full_name = ".Cmd.MonitorBuildUserEvent"
MONITORBUILDUSEREVENT.nested_types = {}
MONITORBUILDUSEREVENT.enum_types = {}
MONITORBUILDUSEREVENT.fields = {
  MONITORBUILDUSEREVENT_CMD_FIELD,
  MONITORBUILDUSEREVENT_PARAM_FIELD,
  MONITORBUILDUSEREVENT_BE_MONITOR_CHARID_FIELD,
  MONITORBUILDUSEREVENT_BE_MONITOR_ACCID_FIELD,
  MONITORBUILDUSEREVENT_BE_MONITOR_PROXYID_FIELD
}
MONITORBUILDUSEREVENT.is_extendable = false
MONITORBUILDUSEREVENT.extensions = {}
GUIDEQUESTEVENT_CMD_FIELD.name = "cmd"
GUIDEQUESTEVENT_CMD_FIELD.full_name = ".Cmd.GuideQuestEvent.cmd"
GUIDEQUESTEVENT_CMD_FIELD.number = 1
GUIDEQUESTEVENT_CMD_FIELD.index = 0
GUIDEQUESTEVENT_CMD_FIELD.label = 1
GUIDEQUESTEVENT_CMD_FIELD.has_default_value = true
GUIDEQUESTEVENT_CMD_FIELD.default_value = 25
GUIDEQUESTEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUIDEQUESTEVENT_CMD_FIELD.type = 14
GUIDEQUESTEVENT_CMD_FIELD.cpp_type = 8
GUIDEQUESTEVENT_PARAM_FIELD.name = "param"
GUIDEQUESTEVENT_PARAM_FIELD.full_name = ".Cmd.GuideQuestEvent.param"
GUIDEQUESTEVENT_PARAM_FIELD.number = 2
GUIDEQUESTEVENT_PARAM_FIELD.index = 1
GUIDEQUESTEVENT_PARAM_FIELD.label = 1
GUIDEQUESTEVENT_PARAM_FIELD.has_default_value = true
GUIDEQUESTEVENT_PARAM_FIELD.default_value = 73
GUIDEQUESTEVENT_PARAM_FIELD.enum_type = EVENTPARAM
GUIDEQUESTEVENT_PARAM_FIELD.type = 14
GUIDEQUESTEVENT_PARAM_FIELD.cpp_type = 8
GUIDEQUESTEVENT_TARGETID_FIELD.name = "targetid"
GUIDEQUESTEVENT_TARGETID_FIELD.full_name = ".Cmd.GuideQuestEvent.targetid"
GUIDEQUESTEVENT_TARGETID_FIELD.number = 3
GUIDEQUESTEVENT_TARGETID_FIELD.index = 2
GUIDEQUESTEVENT_TARGETID_FIELD.label = 1
GUIDEQUESTEVENT_TARGETID_FIELD.has_default_value = false
GUIDEQUESTEVENT_TARGETID_FIELD.default_value = 0
GUIDEQUESTEVENT_TARGETID_FIELD.type = 13
GUIDEQUESTEVENT_TARGETID_FIELD.cpp_type = 3
GUIDEQUESTEVENT.name = "GuideQuestEvent"
GUIDEQUESTEVENT.full_name = ".Cmd.GuideQuestEvent"
GUIDEQUESTEVENT.nested_types = {}
GUIDEQUESTEVENT.enum_types = {}
GUIDEQUESTEVENT.fields = {
  GUIDEQUESTEVENT_CMD_FIELD,
  GUIDEQUESTEVENT_PARAM_FIELD,
  GUIDEQUESTEVENT_TARGETID_FIELD
}
GUIDEQUESTEVENT.is_extendable = false
GUIDEQUESTEVENT.extensions = {}
SHOWCARDEVENT_CMD_FIELD.name = "cmd"
SHOWCARDEVENT_CMD_FIELD.full_name = ".Cmd.ShowCardEvent.cmd"
SHOWCARDEVENT_CMD_FIELD.number = 1
SHOWCARDEVENT_CMD_FIELD.index = 0
SHOWCARDEVENT_CMD_FIELD.label = 1
SHOWCARDEVENT_CMD_FIELD.has_default_value = true
SHOWCARDEVENT_CMD_FIELD.default_value = 25
SHOWCARDEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHOWCARDEVENT_CMD_FIELD.type = 14
SHOWCARDEVENT_CMD_FIELD.cpp_type = 8
SHOWCARDEVENT_PARAM_FIELD.name = "param"
SHOWCARDEVENT_PARAM_FIELD.full_name = ".Cmd.ShowCardEvent.param"
SHOWCARDEVENT_PARAM_FIELD.number = 2
SHOWCARDEVENT_PARAM_FIELD.index = 1
SHOWCARDEVENT_PARAM_FIELD.label = 1
SHOWCARDEVENT_PARAM_FIELD.has_default_value = true
SHOWCARDEVENT_PARAM_FIELD.default_value = 75
SHOWCARDEVENT_PARAM_FIELD.enum_type = EVENTPARAM
SHOWCARDEVENT_PARAM_FIELD.type = 14
SHOWCARDEVENT_PARAM_FIELD.cpp_type = 8
SHOWCARDEVENT_CARDID_FIELD.name = "cardid"
SHOWCARDEVENT_CARDID_FIELD.full_name = ".Cmd.ShowCardEvent.cardid"
SHOWCARDEVENT_CARDID_FIELD.number = 3
SHOWCARDEVENT_CARDID_FIELD.index = 2
SHOWCARDEVENT_CARDID_FIELD.label = 1
SHOWCARDEVENT_CARDID_FIELD.has_default_value = false
SHOWCARDEVENT_CARDID_FIELD.default_value = 0
SHOWCARDEVENT_CARDID_FIELD.type = 13
SHOWCARDEVENT_CARDID_FIELD.cpp_type = 3
SHOWCARDEVENT.name = "ShowCardEvent"
SHOWCARDEVENT.full_name = ".Cmd.ShowCardEvent"
SHOWCARDEVENT.nested_types = {}
SHOWCARDEVENT.enum_types = {}
SHOWCARDEVENT.fields = {
  SHOWCARDEVENT_CMD_FIELD,
  SHOWCARDEVENT_PARAM_FIELD,
  SHOWCARDEVENT_CARDID_FIELD
}
SHOWCARDEVENT.is_extendable = false
SHOWCARDEVENT.extensions = {}
GVGOPTSTATUEEVENT_CMD_FIELD.name = "cmd"
GVGOPTSTATUEEVENT_CMD_FIELD.full_name = ".Cmd.GvgOptStatueEvent.cmd"
GVGOPTSTATUEEVENT_CMD_FIELD.number = 1
GVGOPTSTATUEEVENT_CMD_FIELD.index = 0
GVGOPTSTATUEEVENT_CMD_FIELD.label = 1
GVGOPTSTATUEEVENT_CMD_FIELD.has_default_value = true
GVGOPTSTATUEEVENT_CMD_FIELD.default_value = 25
GVGOPTSTATUEEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGOPTSTATUEEVENT_CMD_FIELD.type = 14
GVGOPTSTATUEEVENT_CMD_FIELD.cpp_type = 8
GVGOPTSTATUEEVENT_PARAM_FIELD.name = "param"
GVGOPTSTATUEEVENT_PARAM_FIELD.full_name = ".Cmd.GvgOptStatueEvent.param"
GVGOPTSTATUEEVENT_PARAM_FIELD.number = 2
GVGOPTSTATUEEVENT_PARAM_FIELD.index = 1
GVGOPTSTATUEEVENT_PARAM_FIELD.label = 1
GVGOPTSTATUEEVENT_PARAM_FIELD.has_default_value = true
GVGOPTSTATUEEVENT_PARAM_FIELD.default_value = 71
GVGOPTSTATUEEVENT_PARAM_FIELD.enum_type = EVENTPARAM
GVGOPTSTATUEEVENT_PARAM_FIELD.type = 14
GVGOPTSTATUEEVENT_PARAM_FIELD.cpp_type = 8
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.name = "exterior"
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.full_name = ".Cmd.GvgOptStatueEvent.exterior"
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.number = 3
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.index = 2
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.label = 1
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.has_default_value = false
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.default_value = false
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.type = 8
GVGOPTSTATUEEVENT_EXTERIOR_FIELD.cpp_type = 7
GVGOPTSTATUEEVENT_POSE_FIELD.name = "pose"
GVGOPTSTATUEEVENT_POSE_FIELD.full_name = ".Cmd.GvgOptStatueEvent.pose"
GVGOPTSTATUEEVENT_POSE_FIELD.number = 4
GVGOPTSTATUEEVENT_POSE_FIELD.index = 3
GVGOPTSTATUEEVENT_POSE_FIELD.label = 1
GVGOPTSTATUEEVENT_POSE_FIELD.has_default_value = false
GVGOPTSTATUEEVENT_POSE_FIELD.default_value = 0
GVGOPTSTATUEEVENT_POSE_FIELD.type = 13
GVGOPTSTATUEEVENT_POSE_FIELD.cpp_type = 3
GVGOPTSTATUEEVENT.name = "GvgOptStatueEvent"
GVGOPTSTATUEEVENT.full_name = ".Cmd.GvgOptStatueEvent"
GVGOPTSTATUEEVENT.nested_types = {}
GVGOPTSTATUEEVENT.enum_types = {}
GVGOPTSTATUEEVENT.fields = {
  GVGOPTSTATUEEVENT_CMD_FIELD,
  GVGOPTSTATUEEVENT_PARAM_FIELD,
  GVGOPTSTATUEEVENT_EXTERIOR_FIELD,
  GVGOPTSTATUEEVENT_POSE_FIELD
}
GVGOPTSTATUEEVENT.is_extendable = false
GVGOPTSTATUEEVENT.extensions = {}
TIMELIMITICONEVENT_CMD_FIELD.name = "cmd"
TIMELIMITICONEVENT_CMD_FIELD.full_name = ".Cmd.TimeLimitIconEvent.cmd"
TIMELIMITICONEVENT_CMD_FIELD.number = 1
TIMELIMITICONEVENT_CMD_FIELD.index = 0
TIMELIMITICONEVENT_CMD_FIELD.label = 1
TIMELIMITICONEVENT_CMD_FIELD.has_default_value = true
TIMELIMITICONEVENT_CMD_FIELD.default_value = 25
TIMELIMITICONEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TIMELIMITICONEVENT_CMD_FIELD.type = 14
TIMELIMITICONEVENT_CMD_FIELD.cpp_type = 8
TIMELIMITICONEVENT_PARAM_FIELD.name = "param"
TIMELIMITICONEVENT_PARAM_FIELD.full_name = ".Cmd.TimeLimitIconEvent.param"
TIMELIMITICONEVENT_PARAM_FIELD.number = 2
TIMELIMITICONEVENT_PARAM_FIELD.index = 1
TIMELIMITICONEVENT_PARAM_FIELD.label = 1
TIMELIMITICONEVENT_PARAM_FIELD.has_default_value = true
TIMELIMITICONEVENT_PARAM_FIELD.default_value = 72
TIMELIMITICONEVENT_PARAM_FIELD.enum_type = EVENTPARAM
TIMELIMITICONEVENT_PARAM_FIELD.type = 14
TIMELIMITICONEVENT_PARAM_FIELD.cpp_type = 8
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.name = "show_items"
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.full_name = ".Cmd.TimeLimitIconEvent.show_items"
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.number = 3
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.index = 2
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.label = 3
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.has_default_value = false
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.default_value = {}
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.type = 13
TIMELIMITICONEVENT_SHOW_ITEMS_FIELD.cpp_type = 3
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.name = "show_deposits"
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.full_name = ".Cmd.TimeLimitIconEvent.show_deposits"
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.number = 4
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.index = 3
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.label = 3
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.has_default_value = false
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.default_value = {}
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.type = 13
TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD.cpp_type = 3
TIMELIMITICONEVENT.name = "TimeLimitIconEvent"
TIMELIMITICONEVENT.full_name = ".Cmd.TimeLimitIconEvent"
TIMELIMITICONEVENT.nested_types = {}
TIMELIMITICONEVENT.enum_types = {}
TIMELIMITICONEVENT.fields = {
  TIMELIMITICONEVENT_CMD_FIELD,
  TIMELIMITICONEVENT_PARAM_FIELD,
  TIMELIMITICONEVENT_SHOW_ITEMS_FIELD,
  TIMELIMITICONEVENT_SHOW_DEPOSITS_FIELD
}
TIMELIMITICONEVENT.is_extendable = false
TIMELIMITICONEVENT.extensions = {}
SHOWGIFTINFO_PRODUCT_FIELD.name = "product"
SHOWGIFTINFO_PRODUCT_FIELD.full_name = ".Cmd.ShowGiftInfo.product"
SHOWGIFTINFO_PRODUCT_FIELD.number = 1
SHOWGIFTINFO_PRODUCT_FIELD.index = 0
SHOWGIFTINFO_PRODUCT_FIELD.label = 1
SHOWGIFTINFO_PRODUCT_FIELD.has_default_value = false
SHOWGIFTINFO_PRODUCT_FIELD.default_value = 0
SHOWGIFTINFO_PRODUCT_FIELD.type = 13
SHOWGIFTINFO_PRODUCT_FIELD.cpp_type = 3
SHOWGIFTINFO_INFO_FIELD.name = "info"
SHOWGIFTINFO_INFO_FIELD.full_name = ".Cmd.ShowGiftInfo.info"
SHOWGIFTINFO_INFO_FIELD.number = 2
SHOWGIFTINFO_INFO_FIELD.index = 1
SHOWGIFTINFO_INFO_FIELD.label = 3
SHOWGIFTINFO_INFO_FIELD.has_default_value = false
SHOWGIFTINFO_INFO_FIELD.default_value = {}
SHOWGIFTINFO_INFO_FIELD.message_type = SessionShop_pb.ITEMSHOWINFO
SHOWGIFTINFO_INFO_FIELD.type = 11
SHOWGIFTINFO_INFO_FIELD.cpp_type = 10
SHOWGIFTINFO.name = "ShowGiftInfo"
SHOWGIFTINFO.full_name = ".Cmd.ShowGiftInfo"
SHOWGIFTINFO.nested_types = {}
SHOWGIFTINFO.enum_types = {}
SHOWGIFTINFO.fields = {
  SHOWGIFTINFO_PRODUCT_FIELD,
  SHOWGIFTINFO_INFO_FIELD
}
SHOWGIFTINFO.is_extendable = false
SHOWGIFTINFO.extensions = {}
SHOWRMBGIFTEVENT_CMD_FIELD.name = "cmd"
SHOWRMBGIFTEVENT_CMD_FIELD.full_name = ".Cmd.ShowRMBGiftEvent.cmd"
SHOWRMBGIFTEVENT_CMD_FIELD.number = 1
SHOWRMBGIFTEVENT_CMD_FIELD.index = 0
SHOWRMBGIFTEVENT_CMD_FIELD.label = 1
SHOWRMBGIFTEVENT_CMD_FIELD.has_default_value = true
SHOWRMBGIFTEVENT_CMD_FIELD.default_value = 25
SHOWRMBGIFTEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SHOWRMBGIFTEVENT_CMD_FIELD.type = 14
SHOWRMBGIFTEVENT_CMD_FIELD.cpp_type = 8
SHOWRMBGIFTEVENT_PARAM_FIELD.name = "param"
SHOWRMBGIFTEVENT_PARAM_FIELD.full_name = ".Cmd.ShowRMBGiftEvent.param"
SHOWRMBGIFTEVENT_PARAM_FIELD.number = 2
SHOWRMBGIFTEVENT_PARAM_FIELD.index = 1
SHOWRMBGIFTEVENT_PARAM_FIELD.label = 1
SHOWRMBGIFTEVENT_PARAM_FIELD.has_default_value = true
SHOWRMBGIFTEVENT_PARAM_FIELD.default_value = 76
SHOWRMBGIFTEVENT_PARAM_FIELD.enum_type = EVENTPARAM
SHOWRMBGIFTEVENT_PARAM_FIELD.type = 14
SHOWRMBGIFTEVENT_PARAM_FIELD.cpp_type = 8
SHOWRMBGIFTEVENT_SHOW_FIELD.name = "show"
SHOWRMBGIFTEVENT_SHOW_FIELD.full_name = ".Cmd.ShowRMBGiftEvent.show"
SHOWRMBGIFTEVENT_SHOW_FIELD.number = 3
SHOWRMBGIFTEVENT_SHOW_FIELD.index = 2
SHOWRMBGIFTEVENT_SHOW_FIELD.label = 3
SHOWRMBGIFTEVENT_SHOW_FIELD.has_default_value = false
SHOWRMBGIFTEVENT_SHOW_FIELD.default_value = {}
SHOWRMBGIFTEVENT_SHOW_FIELD.message_type = SHOWGIFTINFO
SHOWRMBGIFTEVENT_SHOW_FIELD.type = 11
SHOWRMBGIFTEVENT_SHOW_FIELD.cpp_type = 10
SHOWRMBGIFTEVENT.name = "ShowRMBGiftEvent"
SHOWRMBGIFTEVENT.full_name = ".Cmd.ShowRMBGiftEvent"
SHOWRMBGIFTEVENT.nested_types = {}
SHOWRMBGIFTEVENT.enum_types = {}
SHOWRMBGIFTEVENT.fields = {
  SHOWRMBGIFTEVENT_CMD_FIELD,
  SHOWRMBGIFTEVENT_PARAM_FIELD,
  SHOWRMBGIFTEVENT_SHOW_FIELD
}
SHOWRMBGIFTEVENT.is_extendable = false
SHOWRMBGIFTEVENT.extensions = {}
CONFIGINFO_SUCCESS_FIELD.name = "success"
CONFIGINFO_SUCCESS_FIELD.full_name = ".Cmd.ConfigInfo.success"
CONFIGINFO_SUCCESS_FIELD.number = 1
CONFIGINFO_SUCCESS_FIELD.index = 0
CONFIGINFO_SUCCESS_FIELD.label = 1
CONFIGINFO_SUCCESS_FIELD.has_default_value = false
CONFIGINFO_SUCCESS_FIELD.default_value = false
CONFIGINFO_SUCCESS_FIELD.type = 8
CONFIGINFO_SUCCESS_FIELD.cpp_type = 7
CONFIGINFO_INFO_FIELD.name = "info"
CONFIGINFO_INFO_FIELD.full_name = ".Cmd.ConfigInfo.info"
CONFIGINFO_INFO_FIELD.number = 2
CONFIGINFO_INFO_FIELD.index = 1
CONFIGINFO_INFO_FIELD.label = 1
CONFIGINFO_INFO_FIELD.has_default_value = false
CONFIGINFO_INFO_FIELD.default_value = ""
CONFIGINFO_INFO_FIELD.type = 9
CONFIGINFO_INFO_FIELD.cpp_type = 9
CONFIGINFO_ERROR_FIELD.name = "error"
CONFIGINFO_ERROR_FIELD.full_name = ".Cmd.ConfigInfo.error"
CONFIGINFO_ERROR_FIELD.number = 3
CONFIGINFO_ERROR_FIELD.index = 2
CONFIGINFO_ERROR_FIELD.label = 1
CONFIGINFO_ERROR_FIELD.has_default_value = false
CONFIGINFO_ERROR_FIELD.default_value = ""
CONFIGINFO_ERROR_FIELD.type = 9
CONFIGINFO_ERROR_FIELD.cpp_type = 9
CONFIGINFO.name = "ConfigInfo"
CONFIGINFO.full_name = ".Cmd.ConfigInfo"
CONFIGINFO.nested_types = {}
CONFIGINFO.enum_types = {}
CONFIGINFO.fields = {
  CONFIGINFO_SUCCESS_FIELD,
  CONFIGINFO_INFO_FIELD,
  CONFIGINFO_ERROR_FIELD
}
CONFIGINFO.is_extendable = false
CONFIGINFO.extensions = {}
CONFIGACTIONUSEREVENT_CMD_FIELD.name = "cmd"
CONFIGACTIONUSEREVENT_CMD_FIELD.full_name = ".Cmd.ConfigActionUserEvent.cmd"
CONFIGACTIONUSEREVENT_CMD_FIELD.number = 1
CONFIGACTIONUSEREVENT_CMD_FIELD.index = 0
CONFIGACTIONUSEREVENT_CMD_FIELD.label = 1
CONFIGACTIONUSEREVENT_CMD_FIELD.has_default_value = true
CONFIGACTIONUSEREVENT_CMD_FIELD.default_value = 25
CONFIGACTIONUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CONFIGACTIONUSEREVENT_CMD_FIELD.type = 14
CONFIGACTIONUSEREVENT_CMD_FIELD.cpp_type = 8
CONFIGACTIONUSEREVENT_PARAM_FIELD.name = "param"
CONFIGACTIONUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ConfigActionUserEvent.param"
CONFIGACTIONUSEREVENT_PARAM_FIELD.number = 2
CONFIGACTIONUSEREVENT_PARAM_FIELD.index = 1
CONFIGACTIONUSEREVENT_PARAM_FIELD.label = 1
CONFIGACTIONUSEREVENT_PARAM_FIELD.has_default_value = true
CONFIGACTIONUSEREVENT_PARAM_FIELD.default_value = 66
CONFIGACTIONUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
CONFIGACTIONUSEREVENT_PARAM_FIELD.type = 14
CONFIGACTIONUSEREVENT_PARAM_FIELD.cpp_type = 8
CONFIGACTIONUSEREVENT_ACTION_FIELD.name = "action"
CONFIGACTIONUSEREVENT_ACTION_FIELD.full_name = ".Cmd.ConfigActionUserEvent.action"
CONFIGACTIONUSEREVENT_ACTION_FIELD.number = 3
CONFIGACTIONUSEREVENT_ACTION_FIELD.index = 2
CONFIGACTIONUSEREVENT_ACTION_FIELD.label = 1
CONFIGACTIONUSEREVENT_ACTION_FIELD.has_default_value = false
CONFIGACTIONUSEREVENT_ACTION_FIELD.default_value = nil
CONFIGACTIONUSEREVENT_ACTION_FIELD.enum_type = ECONFIGACTION
CONFIGACTIONUSEREVENT_ACTION_FIELD.type = 14
CONFIGACTIONUSEREVENT_ACTION_FIELD.cpp_type = 8
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.name = "sessionid"
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.full_name = ".Cmd.ConfigActionUserEvent.sessionid"
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.number = 4
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.index = 3
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.label = 1
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.has_default_value = false
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.default_value = 0
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.type = 13
CONFIGACTIONUSEREVENT_SESSIONID_FIELD.cpp_type = 3
CONFIGACTIONUSEREVENT_NAME_FIELD.name = "name"
CONFIGACTIONUSEREVENT_NAME_FIELD.full_name = ".Cmd.ConfigActionUserEvent.name"
CONFIGACTIONUSEREVENT_NAME_FIELD.number = 5
CONFIGACTIONUSEREVENT_NAME_FIELD.index = 4
CONFIGACTIONUSEREVENT_NAME_FIELD.label = 1
CONFIGACTIONUSEREVENT_NAME_FIELD.has_default_value = false
CONFIGACTIONUSEREVENT_NAME_FIELD.default_value = ""
CONFIGACTIONUSEREVENT_NAME_FIELD.type = 9
CONFIGACTIONUSEREVENT_NAME_FIELD.cpp_type = 9
CONFIGACTIONUSEREVENT_INFOS_FIELD.name = "infos"
CONFIGACTIONUSEREVENT_INFOS_FIELD.full_name = ".Cmd.ConfigActionUserEvent.infos"
CONFIGACTIONUSEREVENT_INFOS_FIELD.number = 6
CONFIGACTIONUSEREVENT_INFOS_FIELD.index = 5
CONFIGACTIONUSEREVENT_INFOS_FIELD.label = 3
CONFIGACTIONUSEREVENT_INFOS_FIELD.has_default_value = false
CONFIGACTIONUSEREVENT_INFOS_FIELD.default_value = {}
CONFIGACTIONUSEREVENT_INFOS_FIELD.message_type = CONFIGINFO
CONFIGACTIONUSEREVENT_INFOS_FIELD.type = 11
CONFIGACTIONUSEREVENT_INFOS_FIELD.cpp_type = 10
CONFIGACTIONUSEREVENT_OVER_FIELD.name = "over"
CONFIGACTIONUSEREVENT_OVER_FIELD.full_name = ".Cmd.ConfigActionUserEvent.over"
CONFIGACTIONUSEREVENT_OVER_FIELD.number = 7
CONFIGACTIONUSEREVENT_OVER_FIELD.index = 6
CONFIGACTIONUSEREVENT_OVER_FIELD.label = 1
CONFIGACTIONUSEREVENT_OVER_FIELD.has_default_value = false
CONFIGACTIONUSEREVENT_OVER_FIELD.default_value = false
CONFIGACTIONUSEREVENT_OVER_FIELD.type = 8
CONFIGACTIONUSEREVENT_OVER_FIELD.cpp_type = 7
CONFIGACTIONUSEREVENT.name = "ConfigActionUserEvent"
CONFIGACTIONUSEREVENT.full_name = ".Cmd.ConfigActionUserEvent"
CONFIGACTIONUSEREVENT.nested_types = {}
CONFIGACTIONUSEREVENT.enum_types = {}
CONFIGACTIONUSEREVENT.fields = {
  CONFIGACTIONUSEREVENT_CMD_FIELD,
  CONFIGACTIONUSEREVENT_PARAM_FIELD,
  CONFIGACTIONUSEREVENT_ACTION_FIELD,
  CONFIGACTIONUSEREVENT_SESSIONID_FIELD,
  CONFIGACTIONUSEREVENT_NAME_FIELD,
  CONFIGACTIONUSEREVENT_INFOS_FIELD,
  CONFIGACTIONUSEREVENT_OVER_FIELD
}
CONFIGACTIONUSEREVENT.is_extendable = false
CONFIGACTIONUSEREVENT.extensions = {}
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.name = "cmd"
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.cmd"
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.number = 1
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.index = 0
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.has_default_value = true
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.default_value = 25
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.type = 14
NPCWALKSTEPNTFUSEREVENT_CMD_FIELD.cpp_type = 8
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.name = "param"
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.param"
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.number = 2
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.index = 1
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.has_default_value = true
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.default_value = 67
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.type = 14
NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD.cpp_type = 8
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.name = "guid"
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.guid"
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.number = 3
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.index = 2
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.has_default_value = false
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.default_value = 0
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.type = 4
NPCWALKSTEPNTFUSEREVENT_GUID_FIELD.cpp_type = 4
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.name = "id"
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.id"
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.number = 4
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.index = 3
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.has_default_value = false
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.default_value = 0
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.type = 13
NPCWALKSTEPNTFUSEREVENT_ID_FIELD.cpp_type = 3
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.name = "walkid"
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.walkid"
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.number = 5
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.index = 4
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.has_default_value = false
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.default_value = 0
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.type = 13
NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD.cpp_type = 3
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.name = "type"
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.full_name = ".Cmd.NpcWalkStepNtfUserEvent.type"
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.number = 6
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.index = 5
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.label = 1
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.has_default_value = false
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.default_value = ""
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.type = 9
NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD.cpp_type = 9
NPCWALKSTEPNTFUSEREVENT.name = "NpcWalkStepNtfUserEvent"
NPCWALKSTEPNTFUSEREVENT.full_name = ".Cmd.NpcWalkStepNtfUserEvent"
NPCWALKSTEPNTFUSEREVENT.nested_types = {}
NPCWALKSTEPNTFUSEREVENT.enum_types = {}
NPCWALKSTEPNTFUSEREVENT.fields = {
  NPCWALKSTEPNTFUSEREVENT_CMD_FIELD,
  NPCWALKSTEPNTFUSEREVENT_PARAM_FIELD,
  NPCWALKSTEPNTFUSEREVENT_GUID_FIELD,
  NPCWALKSTEPNTFUSEREVENT_ID_FIELD,
  NPCWALKSTEPNTFUSEREVENT_WALKID_FIELD,
  NPCWALKSTEPNTFUSEREVENT_TYPE_FIELD
}
NPCWALKSTEPNTFUSEREVENT.is_extendable = false
NPCWALKSTEPNTFUSEREVENT.extensions = {}
SETPROFILEUSEREVENT_CMD_FIELD.name = "cmd"
SETPROFILEUSEREVENT_CMD_FIELD.full_name = ".Cmd.SetProfileUserEvent.cmd"
SETPROFILEUSEREVENT_CMD_FIELD.number = 1
SETPROFILEUSEREVENT_CMD_FIELD.index = 0
SETPROFILEUSEREVENT_CMD_FIELD.label = 1
SETPROFILEUSEREVENT_CMD_FIELD.has_default_value = true
SETPROFILEUSEREVENT_CMD_FIELD.default_value = 25
SETPROFILEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETPROFILEUSEREVENT_CMD_FIELD.type = 14
SETPROFILEUSEREVENT_CMD_FIELD.cpp_type = 8
SETPROFILEUSEREVENT_PARAM_FIELD.name = "param"
SETPROFILEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SetProfileUserEvent.param"
SETPROFILEUSEREVENT_PARAM_FIELD.number = 2
SETPROFILEUSEREVENT_PARAM_FIELD.index = 1
SETPROFILEUSEREVENT_PARAM_FIELD.label = 1
SETPROFILEUSEREVENT_PARAM_FIELD.has_default_value = true
SETPROFILEUSEREVENT_PARAM_FIELD.default_value = 68
SETPROFILEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SETPROFILEUSEREVENT_PARAM_FIELD.type = 14
SETPROFILEUSEREVENT_PARAM_FIELD.cpp_type = 8
SETPROFILEUSEREVENT_PROFILE_FIELD.name = "profile"
SETPROFILEUSEREVENT_PROFILE_FIELD.full_name = ".Cmd.SetProfileUserEvent.profile"
SETPROFILEUSEREVENT_PROFILE_FIELD.number = 3
SETPROFILEUSEREVENT_PROFILE_FIELD.index = 2
SETPROFILEUSEREVENT_PROFILE_FIELD.label = 1
SETPROFILEUSEREVENT_PROFILE_FIELD.has_default_value = false
SETPROFILEUSEREVENT_PROFILE_FIELD.default_value = nil
SETPROFILEUSEREVENT_PROFILE_FIELD.message_type = ProtoCommon_pb.USERPROFILEDATA
SETPROFILEUSEREVENT_PROFILE_FIELD.type = 11
SETPROFILEUSEREVENT_PROFILE_FIELD.cpp_type = 10
SETPROFILEUSEREVENT.name = "SetProfileUserEvent"
SETPROFILEUSEREVENT.full_name = ".Cmd.SetProfileUserEvent"
SETPROFILEUSEREVENT.nested_types = {}
SETPROFILEUSEREVENT.enum_types = {}
SETPROFILEUSEREVENT.fields = {
  SETPROFILEUSEREVENT_CMD_FIELD,
  SETPROFILEUSEREVENT_PARAM_FIELD,
  SETPROFILEUSEREVENT_PROFILE_FIELD
}
SETPROFILEUSEREVENT.is_extendable = false
SETPROFILEUSEREVENT.extensions = {}
QUERYFATERELATIONEVENT_CMD_FIELD.name = "cmd"
QUERYFATERELATIONEVENT_CMD_FIELD.full_name = ".Cmd.QueryFateRelationEvent.cmd"
QUERYFATERELATIONEVENT_CMD_FIELD.number = 1
QUERYFATERELATIONEVENT_CMD_FIELD.index = 0
QUERYFATERELATIONEVENT_CMD_FIELD.label = 1
QUERYFATERELATIONEVENT_CMD_FIELD.has_default_value = true
QUERYFATERELATIONEVENT_CMD_FIELD.default_value = 25
QUERYFATERELATIONEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYFATERELATIONEVENT_CMD_FIELD.type = 14
QUERYFATERELATIONEVENT_CMD_FIELD.cpp_type = 8
QUERYFATERELATIONEVENT_PARAM_FIELD.name = "param"
QUERYFATERELATIONEVENT_PARAM_FIELD.full_name = ".Cmd.QueryFateRelationEvent.param"
QUERYFATERELATIONEVENT_PARAM_FIELD.number = 2
QUERYFATERELATIONEVENT_PARAM_FIELD.index = 1
QUERYFATERELATIONEVENT_PARAM_FIELD.label = 1
QUERYFATERELATIONEVENT_PARAM_FIELD.has_default_value = true
QUERYFATERELATIONEVENT_PARAM_FIELD.default_value = 70
QUERYFATERELATIONEVENT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYFATERELATIONEVENT_PARAM_FIELD.type = 14
QUERYFATERELATIONEVENT_PARAM_FIELD.cpp_type = 8
QUERYFATERELATIONEVENT_ID_FIELD.name = "id"
QUERYFATERELATIONEVENT_ID_FIELD.full_name = ".Cmd.QueryFateRelationEvent.id"
QUERYFATERELATIONEVENT_ID_FIELD.number = 3
QUERYFATERELATIONEVENT_ID_FIELD.index = 2
QUERYFATERELATIONEVENT_ID_FIELD.label = 1
QUERYFATERELATIONEVENT_ID_FIELD.has_default_value = false
QUERYFATERELATIONEVENT_ID_FIELD.default_value = 0
QUERYFATERELATIONEVENT_ID_FIELD.type = 4
QUERYFATERELATIONEVENT_ID_FIELD.cpp_type = 4
QUERYFATERELATIONEVENT.name = "QueryFateRelationEvent"
QUERYFATERELATIONEVENT.full_name = ".Cmd.QueryFateRelationEvent"
QUERYFATERELATIONEVENT.nested_types = {}
QUERYFATERELATIONEVENT.enum_types = {}
QUERYFATERELATIONEVENT.fields = {
  QUERYFATERELATIONEVENT_CMD_FIELD,
  QUERYFATERELATIONEVENT_PARAM_FIELD,
  QUERYFATERELATIONEVENT_ID_FIELD
}
QUERYFATERELATIONEVENT.is_extendable = false
QUERYFATERELATIONEVENT.extensions = {}
SYNCFATERELATIONEVENT_CMD_FIELD.name = "cmd"
SYNCFATERELATIONEVENT_CMD_FIELD.full_name = ".Cmd.SyncFateRelationEvent.cmd"
SYNCFATERELATIONEVENT_CMD_FIELD.number = 1
SYNCFATERELATIONEVENT_CMD_FIELD.index = 0
SYNCFATERELATIONEVENT_CMD_FIELD.label = 1
SYNCFATERELATIONEVENT_CMD_FIELD.has_default_value = true
SYNCFATERELATIONEVENT_CMD_FIELD.default_value = 25
SYNCFATERELATIONEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCFATERELATIONEVENT_CMD_FIELD.type = 14
SYNCFATERELATIONEVENT_CMD_FIELD.cpp_type = 8
SYNCFATERELATIONEVENT_PARAM_FIELD.name = "param"
SYNCFATERELATIONEVENT_PARAM_FIELD.full_name = ".Cmd.SyncFateRelationEvent.param"
SYNCFATERELATIONEVENT_PARAM_FIELD.number = 2
SYNCFATERELATIONEVENT_PARAM_FIELD.index = 1
SYNCFATERELATIONEVENT_PARAM_FIELD.label = 1
SYNCFATERELATIONEVENT_PARAM_FIELD.has_default_value = true
SYNCFATERELATIONEVENT_PARAM_FIELD.default_value = 69
SYNCFATERELATIONEVENT_PARAM_FIELD.enum_type = EVENTPARAM
SYNCFATERELATIONEVENT_PARAM_FIELD.type = 14
SYNCFATERELATIONEVENT_PARAM_FIELD.cpp_type = 8
SYNCFATERELATIONEVENT_FATEVAL_FIELD.name = "fateval"
SYNCFATERELATIONEVENT_FATEVAL_FIELD.full_name = ".Cmd.SyncFateRelationEvent.fateval"
SYNCFATERELATIONEVENT_FATEVAL_FIELD.number = 3
SYNCFATERELATIONEVENT_FATEVAL_FIELD.index = 2
SYNCFATERELATIONEVENT_FATEVAL_FIELD.label = 1
SYNCFATERELATIONEVENT_FATEVAL_FIELD.has_default_value = false
SYNCFATERELATIONEVENT_FATEVAL_FIELD.default_value = 0
SYNCFATERELATIONEVENT_FATEVAL_FIELD.type = 13
SYNCFATERELATIONEVENT_FATEVAL_FIELD.cpp_type = 3
SYNCFATERELATIONEVENT_FATEID_FIELD.name = "fateid"
SYNCFATERELATIONEVENT_FATEID_FIELD.full_name = ".Cmd.SyncFateRelationEvent.fateid"
SYNCFATERELATIONEVENT_FATEID_FIELD.number = 4
SYNCFATERELATIONEVENT_FATEID_FIELD.index = 3
SYNCFATERELATIONEVENT_FATEID_FIELD.label = 1
SYNCFATERELATIONEVENT_FATEID_FIELD.has_default_value = false
SYNCFATERELATIONEVENT_FATEID_FIELD.default_value = 0
SYNCFATERELATIONEVENT_FATEID_FIELD.type = 13
SYNCFATERELATIONEVENT_FATEID_FIELD.cpp_type = 3
SYNCFATERELATIONEVENT.name = "SyncFateRelationEvent"
SYNCFATERELATIONEVENT.full_name = ".Cmd.SyncFateRelationEvent"
SYNCFATERELATIONEVENT.nested_types = {}
SYNCFATERELATIONEVENT.enum_types = {}
SYNCFATERELATIONEVENT.fields = {
  SYNCFATERELATIONEVENT_CMD_FIELD,
  SYNCFATERELATIONEVENT_PARAM_FIELD,
  SYNCFATERELATIONEVENT_FATEVAL_FIELD,
  SYNCFATERELATIONEVENT_FATEID_FIELD
}
SYNCFATERELATIONEVENT.is_extendable = false
SYNCFATERELATIONEVENT.extensions = {}
QUERYPROFILEUSEREVENT_CMD_FIELD.name = "cmd"
QUERYPROFILEUSEREVENT_CMD_FIELD.full_name = ".Cmd.QueryProfileUserEvent.cmd"
QUERYPROFILEUSEREVENT_CMD_FIELD.number = 1
QUERYPROFILEUSEREVENT_CMD_FIELD.index = 0
QUERYPROFILEUSEREVENT_CMD_FIELD.label = 1
QUERYPROFILEUSEREVENT_CMD_FIELD.has_default_value = true
QUERYPROFILEUSEREVENT_CMD_FIELD.default_value = 25
QUERYPROFILEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYPROFILEUSEREVENT_CMD_FIELD.type = 14
QUERYPROFILEUSEREVENT_CMD_FIELD.cpp_type = 8
QUERYPROFILEUSEREVENT_PARAM_FIELD.name = "param"
QUERYPROFILEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.QueryProfileUserEvent.param"
QUERYPROFILEUSEREVENT_PARAM_FIELD.number = 2
QUERYPROFILEUSEREVENT_PARAM_FIELD.index = 1
QUERYPROFILEUSEREVENT_PARAM_FIELD.label = 1
QUERYPROFILEUSEREVENT_PARAM_FIELD.has_default_value = true
QUERYPROFILEUSEREVENT_PARAM_FIELD.default_value = 77
QUERYPROFILEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYPROFILEUSEREVENT_PARAM_FIELD.type = 14
QUERYPROFILEUSEREVENT_PARAM_FIELD.cpp_type = 8
QUERYPROFILEUSEREVENT_CHARID_FIELD.name = "charid"
QUERYPROFILEUSEREVENT_CHARID_FIELD.full_name = ".Cmd.QueryProfileUserEvent.charid"
QUERYPROFILEUSEREVENT_CHARID_FIELD.number = 3
QUERYPROFILEUSEREVENT_CHARID_FIELD.index = 2
QUERYPROFILEUSEREVENT_CHARID_FIELD.label = 1
QUERYPROFILEUSEREVENT_CHARID_FIELD.has_default_value = false
QUERYPROFILEUSEREVENT_CHARID_FIELD.default_value = 0
QUERYPROFILEUSEREVENT_CHARID_FIELD.type = 4
QUERYPROFILEUSEREVENT_CHARID_FIELD.cpp_type = 4
QUERYPROFILEUSEREVENT_PROFILE_FIELD.name = "profile"
QUERYPROFILEUSEREVENT_PROFILE_FIELD.full_name = ".Cmd.QueryProfileUserEvent.profile"
QUERYPROFILEUSEREVENT_PROFILE_FIELD.number = 4
QUERYPROFILEUSEREVENT_PROFILE_FIELD.index = 3
QUERYPROFILEUSEREVENT_PROFILE_FIELD.label = 1
QUERYPROFILEUSEREVENT_PROFILE_FIELD.has_default_value = false
QUERYPROFILEUSEREVENT_PROFILE_FIELD.default_value = nil
QUERYPROFILEUSEREVENT_PROFILE_FIELD.message_type = ProtoCommon_pb.USERPROFILEDATA
QUERYPROFILEUSEREVENT_PROFILE_FIELD.type = 11
QUERYPROFILEUSEREVENT_PROFILE_FIELD.cpp_type = 10
QUERYPROFILEUSEREVENT.name = "QueryProfileUserEvent"
QUERYPROFILEUSEREVENT.full_name = ".Cmd.QueryProfileUserEvent"
QUERYPROFILEUSEREVENT.nested_types = {}
QUERYPROFILEUSEREVENT.enum_types = {}
QUERYPROFILEUSEREVENT.fields = {
  QUERYPROFILEUSEREVENT_CMD_FIELD,
  QUERYPROFILEUSEREVENT_PARAM_FIELD,
  QUERYPROFILEUSEREVENT_CHARID_FIELD,
  QUERYPROFILEUSEREVENT_PROFILE_FIELD
}
QUERYPROFILEUSEREVENT.is_extendable = false
QUERYPROFILEUSEREVENT.extensions = {}
SANDTABLEGUILD_GUILDID_FIELD.name = "guildid"
SANDTABLEGUILD_GUILDID_FIELD.full_name = ".Cmd.SandTableGuild.guildid"
SANDTABLEGUILD_GUILDID_FIELD.number = 1
SANDTABLEGUILD_GUILDID_FIELD.index = 0
SANDTABLEGUILD_GUILDID_FIELD.label = 1
SANDTABLEGUILD_GUILDID_FIELD.has_default_value = false
SANDTABLEGUILD_GUILDID_FIELD.default_value = 0
SANDTABLEGUILD_GUILDID_FIELD.type = 4
SANDTABLEGUILD_GUILDID_FIELD.cpp_type = 4
SANDTABLEGUILD_NAME_FIELD.name = "name"
SANDTABLEGUILD_NAME_FIELD.full_name = ".Cmd.SandTableGuild.name"
SANDTABLEGUILD_NAME_FIELD.number = 2
SANDTABLEGUILD_NAME_FIELD.index = 1
SANDTABLEGUILD_NAME_FIELD.label = 1
SANDTABLEGUILD_NAME_FIELD.has_default_value = false
SANDTABLEGUILD_NAME_FIELD.default_value = ""
SANDTABLEGUILD_NAME_FIELD.type = 9
SANDTABLEGUILD_NAME_FIELD.cpp_type = 9
SANDTABLEGUILD_IMAGE_FIELD.name = "image"
SANDTABLEGUILD_IMAGE_FIELD.full_name = ".Cmd.SandTableGuild.image"
SANDTABLEGUILD_IMAGE_FIELD.number = 3
SANDTABLEGUILD_IMAGE_FIELD.index = 2
SANDTABLEGUILD_IMAGE_FIELD.label = 1
SANDTABLEGUILD_IMAGE_FIELD.has_default_value = false
SANDTABLEGUILD_IMAGE_FIELD.default_value = ""
SANDTABLEGUILD_IMAGE_FIELD.type = 9
SANDTABLEGUILD_IMAGE_FIELD.cpp_type = 9
SANDTABLEGUILD.name = "SandTableGuild"
SANDTABLEGUILD.full_name = ".Cmd.SandTableGuild"
SANDTABLEGUILD.nested_types = {}
SANDTABLEGUILD.enum_types = {}
SANDTABLEGUILD.fields = {
  SANDTABLEGUILD_GUILDID_FIELD,
  SANDTABLEGUILD_NAME_FIELD,
  SANDTABLEGUILD_IMAGE_FIELD
}
SANDTABLEGUILD.is_extendable = false
SANDTABLEGUILD.extensions = {}
POINTINFO_GUILD_FIELD.name = "guild"
POINTINFO_GUILD_FIELD.full_name = ".Cmd.PointInfo.guild"
POINTINFO_GUILD_FIELD.number = 1
POINTINFO_GUILD_FIELD.index = 0
POINTINFO_GUILD_FIELD.label = 1
POINTINFO_GUILD_FIELD.has_default_value = false
POINTINFO_GUILD_FIELD.default_value = nil
POINTINFO_GUILD_FIELD.message_type = SANDTABLEGUILD
POINTINFO_GUILD_FIELD.type = 11
POINTINFO_GUILD_FIELD.cpp_type = 10
POINTINFO_ID_FIELD.name = "id"
POINTINFO_ID_FIELD.full_name = ".Cmd.PointInfo.id"
POINTINFO_ID_FIELD.number = 2
POINTINFO_ID_FIELD.index = 1
POINTINFO_ID_FIELD.label = 1
POINTINFO_ID_FIELD.has_default_value = false
POINTINFO_ID_FIELD.default_value = 0
POINTINFO_ID_FIELD.type = 13
POINTINFO_ID_FIELD.cpp_type = 3
POINTINFO_HAS_OCCUPIED_FIELD.name = "has_occupied"
POINTINFO_HAS_OCCUPIED_FIELD.full_name = ".Cmd.PointInfo.has_occupied"
POINTINFO_HAS_OCCUPIED_FIELD.number = 3
POINTINFO_HAS_OCCUPIED_FIELD.index = 2
POINTINFO_HAS_OCCUPIED_FIELD.label = 1
POINTINFO_HAS_OCCUPIED_FIELD.has_default_value = false
POINTINFO_HAS_OCCUPIED_FIELD.default_value = false
POINTINFO_HAS_OCCUPIED_FIELD.type = 8
POINTINFO_HAS_OCCUPIED_FIELD.cpp_type = 7
POINTINFO_SCORE_FIELD.name = "score"
POINTINFO_SCORE_FIELD.full_name = ".Cmd.PointInfo.score"
POINTINFO_SCORE_FIELD.number = 4
POINTINFO_SCORE_FIELD.index = 3
POINTINFO_SCORE_FIELD.label = 1
POINTINFO_SCORE_FIELD.has_default_value = false
POINTINFO_SCORE_FIELD.default_value = false
POINTINFO_SCORE_FIELD.type = 8
POINTINFO_SCORE_FIELD.cpp_type = 7
POINTINFO.name = "PointInfo"
POINTINFO.full_name = ".Cmd.PointInfo"
POINTINFO.nested_types = {}
POINTINFO.enum_types = {}
POINTINFO.fields = {
  POINTINFO_GUILD_FIELD,
  POINTINFO_ID_FIELD,
  POINTINFO_HAS_OCCUPIED_FIELD,
  POINTINFO_SCORE_FIELD
}
POINTINFO.is_extendable = false
POINTINFO.extensions = {}
SANDTABLEINFO_CITY_FIELD.name = "city"
SANDTABLEINFO_CITY_FIELD.full_name = ".Cmd.SandTableInfo.city"
SANDTABLEINFO_CITY_FIELD.number = 1
SANDTABLEINFO_CITY_FIELD.index = 0
SANDTABLEINFO_CITY_FIELD.label = 1
SANDTABLEINFO_CITY_FIELD.has_default_value = false
SANDTABLEINFO_CITY_FIELD.default_value = 0
SANDTABLEINFO_CITY_FIELD.type = 13
SANDTABLEINFO_CITY_FIELD.cpp_type = 3
SANDTABLEINFO_METALHP_FIELD.name = "metalhp"
SANDTABLEINFO_METALHP_FIELD.full_name = ".Cmd.SandTableInfo.metalhp"
SANDTABLEINFO_METALHP_FIELD.number = 2
SANDTABLEINFO_METALHP_FIELD.index = 1
SANDTABLEINFO_METALHP_FIELD.label = 1
SANDTABLEINFO_METALHP_FIELD.has_default_value = false
SANDTABLEINFO_METALHP_FIELD.default_value = 0
SANDTABLEINFO_METALHP_FIELD.type = 13
SANDTABLEINFO_METALHP_FIELD.cpp_type = 3
SANDTABLEINFO_DEFENSENUM_FIELD.name = "defensenum"
SANDTABLEINFO_DEFENSENUM_FIELD.full_name = ".Cmd.SandTableInfo.defensenum"
SANDTABLEINFO_DEFENSENUM_FIELD.number = 3
SANDTABLEINFO_DEFENSENUM_FIELD.index = 2
SANDTABLEINFO_DEFENSENUM_FIELD.label = 1
SANDTABLEINFO_DEFENSENUM_FIELD.has_default_value = false
SANDTABLEINFO_DEFENSENUM_FIELD.default_value = 0
SANDTABLEINFO_DEFENSENUM_FIELD.type = 13
SANDTABLEINFO_DEFENSENUM_FIELD.cpp_type = 3
SANDTABLEINFO_ATTACKNUM_FIELD.name = "attacknum"
SANDTABLEINFO_ATTACKNUM_FIELD.full_name = ".Cmd.SandTableInfo.attacknum"
SANDTABLEINFO_ATTACKNUM_FIELD.number = 4
SANDTABLEINFO_ATTACKNUM_FIELD.index = 3
SANDTABLEINFO_ATTACKNUM_FIELD.label = 1
SANDTABLEINFO_ATTACKNUM_FIELD.has_default_value = false
SANDTABLEINFO_ATTACKNUM_FIELD.default_value = 0
SANDTABLEINFO_ATTACKNUM_FIELD.type = 13
SANDTABLEINFO_ATTACKNUM_FIELD.cpp_type = 3
SANDTABLEINFO_GUILD_FIELD.name = "guild"
SANDTABLEINFO_GUILD_FIELD.full_name = ".Cmd.SandTableInfo.guild"
SANDTABLEINFO_GUILD_FIELD.number = 5
SANDTABLEINFO_GUILD_FIELD.index = 4
SANDTABLEINFO_GUILD_FIELD.label = 3
SANDTABLEINFO_GUILD_FIELD.has_default_value = false
SANDTABLEINFO_GUILD_FIELD.default_value = {}
SANDTABLEINFO_GUILD_FIELD.message_type = SANDTABLEGUILD
SANDTABLEINFO_GUILD_FIELD.type = 11
SANDTABLEINFO_GUILD_FIELD.cpp_type = 10
SANDTABLEINFO_STATE_FIELD.name = "state"
SANDTABLEINFO_STATE_FIELD.full_name = ".Cmd.SandTableInfo.state"
SANDTABLEINFO_STATE_FIELD.number = 6
SANDTABLEINFO_STATE_FIELD.index = 5
SANDTABLEINFO_STATE_FIELD.label = 1
SANDTABLEINFO_STATE_FIELD.has_default_value = false
SANDTABLEINFO_STATE_FIELD.default_value = nil
SANDTABLEINFO_STATE_FIELD.enum_type = GUILDCMD_PB_EGCITYSTATE
SANDTABLEINFO_STATE_FIELD.type = 14
SANDTABLEINFO_STATE_FIELD.cpp_type = 8
SANDTABLEINFO_DEFGUILD_FIELD.name = "defguild"
SANDTABLEINFO_DEFGUILD_FIELD.full_name = ".Cmd.SandTableInfo.defguild"
SANDTABLEINFO_DEFGUILD_FIELD.number = 7
SANDTABLEINFO_DEFGUILD_FIELD.index = 6
SANDTABLEINFO_DEFGUILD_FIELD.label = 1
SANDTABLEINFO_DEFGUILD_FIELD.has_default_value = false
SANDTABLEINFO_DEFGUILD_FIELD.default_value = nil
SANDTABLEINFO_DEFGUILD_FIELD.message_type = SANDTABLEGUILD
SANDTABLEINFO_DEFGUILD_FIELD.type = 11
SANDTABLEINFO_DEFGUILD_FIELD.cpp_type = 10
SANDTABLEINFO_POINT_INFO_FIELD.name = "point_info"
SANDTABLEINFO_POINT_INFO_FIELD.full_name = ".Cmd.SandTableInfo.point_info"
SANDTABLEINFO_POINT_INFO_FIELD.number = 8
SANDTABLEINFO_POINT_INFO_FIELD.index = 7
SANDTABLEINFO_POINT_INFO_FIELD.label = 3
SANDTABLEINFO_POINT_INFO_FIELD.has_default_value = false
SANDTABLEINFO_POINT_INFO_FIELD.default_value = {}
SANDTABLEINFO_POINT_INFO_FIELD.message_type = POINTINFO
SANDTABLEINFO_POINT_INFO_FIELD.type = 11
SANDTABLEINFO_POINT_INFO_FIELD.cpp_type = 10
SANDTABLEINFO_RAIDSTATE_FIELD.name = "raidstate"
SANDTABLEINFO_RAIDSTATE_FIELD.full_name = ".Cmd.SandTableInfo.raidstate"
SANDTABLEINFO_RAIDSTATE_FIELD.number = 9
SANDTABLEINFO_RAIDSTATE_FIELD.index = 8
SANDTABLEINFO_RAIDSTATE_FIELD.label = 1
SANDTABLEINFO_RAIDSTATE_FIELD.has_default_value = false
SANDTABLEINFO_RAIDSTATE_FIELD.default_value = nil
SANDTABLEINFO_RAIDSTATE_FIELD.enum_type = FUBENCMD_PB_EGVGRAIDSTATE
SANDTABLEINFO_RAIDSTATE_FIELD.type = 14
SANDTABLEINFO_RAIDSTATE_FIELD.cpp_type = 8
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.name = "perfect_time_info"
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.full_name = ".Cmd.SandTableInfo.perfect_time_info"
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.number = 10
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.index = 9
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.label = 1
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.has_default_value = false
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.default_value = nil
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.message_type = ProtoCommon_pb.GVGPERFECTTIMEINFO
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.type = 11
SANDTABLEINFO_PERFECT_TIME_INFO_FIELD.cpp_type = 10
SANDTABLEINFO_MVP_STATE_FIELD.name = "mvp_state"
SANDTABLEINFO_MVP_STATE_FIELD.full_name = ".Cmd.SandTableInfo.mvp_state"
SANDTABLEINFO_MVP_STATE_FIELD.number = 11
SANDTABLEINFO_MVP_STATE_FIELD.index = 10
SANDTABLEINFO_MVP_STATE_FIELD.label = 1
SANDTABLEINFO_MVP_STATE_FIELD.has_default_value = false
SANDTABLEINFO_MVP_STATE_FIELD.default_value = nil
SANDTABLEINFO_MVP_STATE_FIELD.enum_type = GUILDCMD_PB_EMVPSTATE
SANDTABLEINFO_MVP_STATE_FIELD.type = 14
SANDTABLEINFO_MVP_STATE_FIELD.cpp_type = 8
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.name = "mvp_summon_time"
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.full_name = ".Cmd.SandTableInfo.mvp_summon_time"
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.number = 12
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.index = 11
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.label = 1
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.has_default_value = false
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.default_value = 0
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.type = 13
SANDTABLEINFO_MVP_SUMMON_TIME_FIELD.cpp_type = 3
SANDTABLEINFO_MVP_HP_PER_FIELD.name = "mvp_hp_per"
SANDTABLEINFO_MVP_HP_PER_FIELD.full_name = ".Cmd.SandTableInfo.mvp_hp_per"
SANDTABLEINFO_MVP_HP_PER_FIELD.number = 13
SANDTABLEINFO_MVP_HP_PER_FIELD.index = 12
SANDTABLEINFO_MVP_HP_PER_FIELD.label = 1
SANDTABLEINFO_MVP_HP_PER_FIELD.has_default_value = false
SANDTABLEINFO_MVP_HP_PER_FIELD.default_value = 0
SANDTABLEINFO_MVP_HP_PER_FIELD.type = 13
SANDTABLEINFO_MVP_HP_PER_FIELD.cpp_type = 3
SANDTABLEINFO.name = "SandTableInfo"
SANDTABLEINFO.full_name = ".Cmd.SandTableInfo"
SANDTABLEINFO.nested_types = {}
SANDTABLEINFO.enum_types = {}
SANDTABLEINFO.fields = {
  SANDTABLEINFO_CITY_FIELD,
  SANDTABLEINFO_METALHP_FIELD,
  SANDTABLEINFO_DEFENSENUM_FIELD,
  SANDTABLEINFO_ATTACKNUM_FIELD,
  SANDTABLEINFO_GUILD_FIELD,
  SANDTABLEINFO_STATE_FIELD,
  SANDTABLEINFO_DEFGUILD_FIELD,
  SANDTABLEINFO_POINT_INFO_FIELD,
  SANDTABLEINFO_RAIDSTATE_FIELD,
  SANDTABLEINFO_PERFECT_TIME_INFO_FIELD,
  SANDTABLEINFO_MVP_STATE_FIELD,
  SANDTABLEINFO_MVP_SUMMON_TIME_FIELD,
  SANDTABLEINFO_MVP_HP_PER_FIELD
}
SANDTABLEINFO.is_extendable = false
SANDTABLEINFO.extensions = {}
GVGSANDTABLEEVENT_CMD_FIELD.name = "cmd"
GVGSANDTABLEEVENT_CMD_FIELD.full_name = ".Cmd.GvgSandTableEvent.cmd"
GVGSANDTABLEEVENT_CMD_FIELD.number = 1
GVGSANDTABLEEVENT_CMD_FIELD.index = 0
GVGSANDTABLEEVENT_CMD_FIELD.label = 1
GVGSANDTABLEEVENT_CMD_FIELD.has_default_value = true
GVGSANDTABLEEVENT_CMD_FIELD.default_value = 25
GVGSANDTABLEEVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGSANDTABLEEVENT_CMD_FIELD.type = 14
GVGSANDTABLEEVENT_CMD_FIELD.cpp_type = 8
GVGSANDTABLEEVENT_PARAM_FIELD.name = "param"
GVGSANDTABLEEVENT_PARAM_FIELD.full_name = ".Cmd.GvgSandTableEvent.param"
GVGSANDTABLEEVENT_PARAM_FIELD.number = 2
GVGSANDTABLEEVENT_PARAM_FIELD.index = 1
GVGSANDTABLEEVENT_PARAM_FIELD.label = 1
GVGSANDTABLEEVENT_PARAM_FIELD.has_default_value = true
GVGSANDTABLEEVENT_PARAM_FIELD.default_value = 78
GVGSANDTABLEEVENT_PARAM_FIELD.enum_type = EVENTPARAM
GVGSANDTABLEEVENT_PARAM_FIELD.type = 14
GVGSANDTABLEEVENT_PARAM_FIELD.cpp_type = 8
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.name = "gvg_group"
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.full_name = ".Cmd.GvgSandTableEvent.gvg_group"
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.number = 3
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.index = 2
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.label = 1
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.has_default_value = false
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.default_value = 0
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.type = 13
GVGSANDTABLEEVENT_GVG_GROUP_FIELD.cpp_type = 3
GVGSANDTABLEEVENT_STARTTIME_FIELD.name = "starttime"
GVGSANDTABLEEVENT_STARTTIME_FIELD.full_name = ".Cmd.GvgSandTableEvent.starttime"
GVGSANDTABLEEVENT_STARTTIME_FIELD.number = 4
GVGSANDTABLEEVENT_STARTTIME_FIELD.index = 3
GVGSANDTABLEEVENT_STARTTIME_FIELD.label = 1
GVGSANDTABLEEVENT_STARTTIME_FIELD.has_default_value = false
GVGSANDTABLEEVENT_STARTTIME_FIELD.default_value = 0
GVGSANDTABLEEVENT_STARTTIME_FIELD.type = 13
GVGSANDTABLEEVENT_STARTTIME_FIELD.cpp_type = 3
GVGSANDTABLEEVENT_ENDTIME_FIELD.name = "endtime"
GVGSANDTABLEEVENT_ENDTIME_FIELD.full_name = ".Cmd.GvgSandTableEvent.endtime"
GVGSANDTABLEEVENT_ENDTIME_FIELD.number = 5
GVGSANDTABLEEVENT_ENDTIME_FIELD.index = 4
GVGSANDTABLEEVENT_ENDTIME_FIELD.label = 1
GVGSANDTABLEEVENT_ENDTIME_FIELD.has_default_value = false
GVGSANDTABLEEVENT_ENDTIME_FIELD.default_value = 0
GVGSANDTABLEEVENT_ENDTIME_FIELD.type = 13
GVGSANDTABLEEVENT_ENDTIME_FIELD.cpp_type = 3
GVGSANDTABLEEVENT_INFO_FIELD.name = "info"
GVGSANDTABLEEVENT_INFO_FIELD.full_name = ".Cmd.GvgSandTableEvent.info"
GVGSANDTABLEEVENT_INFO_FIELD.number = 6
GVGSANDTABLEEVENT_INFO_FIELD.index = 5
GVGSANDTABLEEVENT_INFO_FIELD.label = 3
GVGSANDTABLEEVENT_INFO_FIELD.has_default_value = false
GVGSANDTABLEEVENT_INFO_FIELD.default_value = {}
GVGSANDTABLEEVENT_INFO_FIELD.message_type = SANDTABLEINFO
GVGSANDTABLEEVENT_INFO_FIELD.type = 11
GVGSANDTABLEEVENT_INFO_FIELD.cpp_type = 10
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.name = "nomore_smallmetal"
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.full_name = ".Cmd.GvgSandTableEvent.nomore_smallmetal"
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.number = 7
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.index = 6
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.label = 1
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.has_default_value = false
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.default_value = false
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.type = 8
GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD.cpp_type = 7
GVGSANDTABLEEVENT.name = "GvgSandTableEvent"
GVGSANDTABLEEVENT.full_name = ".Cmd.GvgSandTableEvent"
GVGSANDTABLEEVENT.nested_types = {}
GVGSANDTABLEEVENT.enum_types = {}
GVGSANDTABLEEVENT.fields = {
  GVGSANDTABLEEVENT_CMD_FIELD,
  GVGSANDTABLEEVENT_PARAM_FIELD,
  GVGSANDTABLEEVENT_GVG_GROUP_FIELD,
  GVGSANDTABLEEVENT_STARTTIME_FIELD,
  GVGSANDTABLEEVENT_ENDTIME_FIELD,
  GVGSANDTABLEEVENT_INFO_FIELD,
  GVGSANDTABLEEVENT_NOMORE_SMALLMETAL_FIELD
}
GVGSANDTABLEEVENT.is_extendable = false
GVGSANDTABLEEVENT.extensions = {}
SETRELIVEMETHODUSEREVENT_CMD_FIELD.name = "cmd"
SETRELIVEMETHODUSEREVENT_CMD_FIELD.full_name = ".Cmd.SetReliveMethodUserEvent.cmd"
SETRELIVEMETHODUSEREVENT_CMD_FIELD.number = 1
SETRELIVEMETHODUSEREVENT_CMD_FIELD.index = 0
SETRELIVEMETHODUSEREVENT_CMD_FIELD.label = 1
SETRELIVEMETHODUSEREVENT_CMD_FIELD.has_default_value = true
SETRELIVEMETHODUSEREVENT_CMD_FIELD.default_value = 25
SETRELIVEMETHODUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETRELIVEMETHODUSEREVENT_CMD_FIELD.type = 14
SETRELIVEMETHODUSEREVENT_CMD_FIELD.cpp_type = 8
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.name = "param"
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SetReliveMethodUserEvent.param"
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.number = 2
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.index = 1
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.label = 1
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.has_default_value = true
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.default_value = 79
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.type = 14
SETRELIVEMETHODUSEREVENT_PARAM_FIELD.cpp_type = 8
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.name = "relive_method"
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.full_name = ".Cmd.SetReliveMethodUserEvent.relive_method"
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.number = 3
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.index = 2
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.label = 1
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.has_default_value = false
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.default_value = nil
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.enum_type = EDELAYRELIVEMETHOD
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.type = 14
SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD.cpp_type = 8
SETRELIVEMETHODUSEREVENT.name = "SetReliveMethodUserEvent"
SETRELIVEMETHODUSEREVENT.full_name = ".Cmd.SetReliveMethodUserEvent"
SETRELIVEMETHODUSEREVENT.nested_types = {}
SETRELIVEMETHODUSEREVENT.enum_types = {}
SETRELIVEMETHODUSEREVENT.fields = {
  SETRELIVEMETHODUSEREVENT_CMD_FIELD,
  SETRELIVEMETHODUSEREVENT_PARAM_FIELD,
  SETRELIVEMETHODUSEREVENT_RELIVE_METHOD_FIELD
}
SETRELIVEMETHODUSEREVENT.is_extendable = false
SETRELIVEMETHODUSEREVENT.extensions = {}
UIACTIONUSEREVENT_CMD_FIELD.name = "cmd"
UIACTIONUSEREVENT_CMD_FIELD.full_name = ".Cmd.UIActionUserEvent.cmd"
UIACTIONUSEREVENT_CMD_FIELD.number = 1
UIACTIONUSEREVENT_CMD_FIELD.index = 0
UIACTIONUSEREVENT_CMD_FIELD.label = 1
UIACTIONUSEREVENT_CMD_FIELD.has_default_value = true
UIACTIONUSEREVENT_CMD_FIELD.default_value = 25
UIACTIONUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UIACTIONUSEREVENT_CMD_FIELD.type = 14
UIACTIONUSEREVENT_CMD_FIELD.cpp_type = 8
UIACTIONUSEREVENT_PARAM_FIELD.name = "param"
UIACTIONUSEREVENT_PARAM_FIELD.full_name = ".Cmd.UIActionUserEvent.param"
UIACTIONUSEREVENT_PARAM_FIELD.number = 2
UIACTIONUSEREVENT_PARAM_FIELD.index = 1
UIACTIONUSEREVENT_PARAM_FIELD.label = 1
UIACTIONUSEREVENT_PARAM_FIELD.has_default_value = true
UIACTIONUSEREVENT_PARAM_FIELD.default_value = 80
UIACTIONUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
UIACTIONUSEREVENT_PARAM_FIELD.type = 14
UIACTIONUSEREVENT_PARAM_FIELD.cpp_type = 8
UIACTIONUSEREVENT_PARAMS_FIELD.name = "params"
UIACTIONUSEREVENT_PARAMS_FIELD.full_name = ".Cmd.UIActionUserEvent.params"
UIACTIONUSEREVENT_PARAMS_FIELD.number = 3
UIACTIONUSEREVENT_PARAMS_FIELD.index = 2
UIACTIONUSEREVENT_PARAMS_FIELD.label = 1
UIACTIONUSEREVENT_PARAMS_FIELD.has_default_value = false
UIACTIONUSEREVENT_PARAMS_FIELD.default_value = ""
UIACTIONUSEREVENT_PARAMS_FIELD.type = 9
UIACTIONUSEREVENT_PARAMS_FIELD.cpp_type = 9
UIACTIONUSEREVENT.name = "UIActionUserEvent"
UIACTIONUSEREVENT.full_name = ".Cmd.UIActionUserEvent"
UIACTIONUSEREVENT.nested_types = {}
UIACTIONUSEREVENT.enum_types = {}
UIACTIONUSEREVENT.fields = {
  UIACTIONUSEREVENT_CMD_FIELD,
  UIACTIONUSEREVENT_PARAM_FIELD,
  UIACTIONUSEREVENT_PARAMS_FIELD
}
UIACTIONUSEREVENT.is_extendable = false
UIACTIONUSEREVENT.extensions = {}
PLAYCUTSCENEUSEREVENT_CMD_FIELD.name = "cmd"
PLAYCUTSCENEUSEREVENT_CMD_FIELD.full_name = ".Cmd.PlayCutSceneUserEvent.cmd"
PLAYCUTSCENEUSEREVENT_CMD_FIELD.number = 1
PLAYCUTSCENEUSEREVENT_CMD_FIELD.index = 0
PLAYCUTSCENEUSEREVENT_CMD_FIELD.label = 1
PLAYCUTSCENEUSEREVENT_CMD_FIELD.has_default_value = true
PLAYCUTSCENEUSEREVENT_CMD_FIELD.default_value = 25
PLAYCUTSCENEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PLAYCUTSCENEUSEREVENT_CMD_FIELD.type = 14
PLAYCUTSCENEUSEREVENT_CMD_FIELD.cpp_type = 8
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.name = "param"
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.PlayCutSceneUserEvent.param"
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.number = 2
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.index = 1
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.label = 1
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.has_default_value = true
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.default_value = 82
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.type = 14
PLAYCUTSCENEUSEREVENT_PARAM_FIELD.cpp_type = 8
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.name = "params"
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.full_name = ".Cmd.PlayCutSceneUserEvent.params"
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.number = 3
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.index = 2
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.label = 1
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.has_default_value = false
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.default_value = ""
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.type = 9
PLAYCUTSCENEUSEREVENT_PARAMS_FIELD.cpp_type = 9
PLAYCUTSCENEUSEREVENT.name = "PlayCutSceneUserEvent"
PLAYCUTSCENEUSEREVENT.full_name = ".Cmd.PlayCutSceneUserEvent"
PLAYCUTSCENEUSEREVENT.nested_types = {}
PLAYCUTSCENEUSEREVENT.enum_types = {}
PLAYCUTSCENEUSEREVENT.fields = {
  PLAYCUTSCENEUSEREVENT_CMD_FIELD,
  PLAYCUTSCENEUSEREVENT_PARAM_FIELD,
  PLAYCUTSCENEUSEREVENT_PARAMS_FIELD
}
PLAYCUTSCENEUSEREVENT.is_extendable = false
PLAYCUTSCENEUSEREVENT.extensions = {}
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.name = "cmd"
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.full_name = ".Cmd.ReqPeriodicMonsterUserEvent.cmd"
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.number = 1
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.index = 0
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.label = 1
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.has_default_value = true
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.default_value = 25
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.type = 14
REQPERIODICMONSTERUSEREVENT_CMD_FIELD.cpp_type = 8
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.name = "param"
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ReqPeriodicMonsterUserEvent.param"
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.number = 2
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.index = 1
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.label = 1
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.has_default_value = true
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.default_value = 84
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.type = 14
REQPERIODICMONSTERUSEREVENT_PARAM_FIELD.cpp_type = 8
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.name = "killed_monsters"
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.full_name = ".Cmd.ReqPeriodicMonsterUserEvent.killed_monsters"
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.number = 3
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.index = 2
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.label = 3
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.has_default_value = false
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.default_value = {}
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.type = 13
REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD.cpp_type = 3
REQPERIODICMONSTERUSEREVENT.name = "ReqPeriodicMonsterUserEvent"
REQPERIODICMONSTERUSEREVENT.full_name = ".Cmd.ReqPeriodicMonsterUserEvent"
REQPERIODICMONSTERUSEREVENT.nested_types = {}
REQPERIODICMONSTERUSEREVENT.enum_types = {}
REQPERIODICMONSTERUSEREVENT.fields = {
  REQPERIODICMONSTERUSEREVENT_CMD_FIELD,
  REQPERIODICMONSTERUSEREVENT_PARAM_FIELD,
  REQPERIODICMONSTERUSEREVENT_KILLED_MONSTERS_FIELD
}
REQPERIODICMONSTERUSEREVENT.is_extendable = false
REQPERIODICMONSTERUSEREVENT.extensions = {}
PLAYHOLDPETUSEREVENT_CMD_FIELD.name = "cmd"
PLAYHOLDPETUSEREVENT_CMD_FIELD.full_name = ".Cmd.PlayHoldPetUserEvent.cmd"
PLAYHOLDPETUSEREVENT_CMD_FIELD.number = 1
PLAYHOLDPETUSEREVENT_CMD_FIELD.index = 0
PLAYHOLDPETUSEREVENT_CMD_FIELD.label = 1
PLAYHOLDPETUSEREVENT_CMD_FIELD.has_default_value = true
PLAYHOLDPETUSEREVENT_CMD_FIELD.default_value = 25
PLAYHOLDPETUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PLAYHOLDPETUSEREVENT_CMD_FIELD.type = 14
PLAYHOLDPETUSEREVENT_CMD_FIELD.cpp_type = 8
PLAYHOLDPETUSEREVENT_PARAM_FIELD.name = "param"
PLAYHOLDPETUSEREVENT_PARAM_FIELD.full_name = ".Cmd.PlayHoldPetUserEvent.param"
PLAYHOLDPETUSEREVENT_PARAM_FIELD.number = 2
PLAYHOLDPETUSEREVENT_PARAM_FIELD.index = 1
PLAYHOLDPETUSEREVENT_PARAM_FIELD.label = 1
PLAYHOLDPETUSEREVENT_PARAM_FIELD.has_default_value = true
PLAYHOLDPETUSEREVENT_PARAM_FIELD.default_value = 85
PLAYHOLDPETUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
PLAYHOLDPETUSEREVENT_PARAM_FIELD.type = 14
PLAYHOLDPETUSEREVENT_PARAM_FIELD.cpp_type = 8
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.name = "params"
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.full_name = ".Cmd.PlayHoldPetUserEvent.params"
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.number = 3
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.index = 2
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.label = 1
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.has_default_value = false
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.default_value = ""
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.type = 9
PLAYHOLDPETUSEREVENT_PARAMS_FIELD.cpp_type = 9
PLAYHOLDPETUSEREVENT.name = "PlayHoldPetUserEvent"
PLAYHOLDPETUSEREVENT.full_name = ".Cmd.PlayHoldPetUserEvent"
PLAYHOLDPETUSEREVENT.nested_types = {}
PLAYHOLDPETUSEREVENT.enum_types = {}
PLAYHOLDPETUSEREVENT.fields = {
  PLAYHOLDPETUSEREVENT_CMD_FIELD,
  PLAYHOLDPETUSEREVENT_PARAM_FIELD,
  PLAYHOLDPETUSEREVENT_PARAMS_FIELD
}
PLAYHOLDPETUSEREVENT.is_extendable = false
PLAYHOLDPETUSEREVENT.extensions = {}
USERSPEEDUPDATA_ETYPE_FIELD.name = "etype"
USERSPEEDUPDATA_ETYPE_FIELD.full_name = ".Cmd.UserSpeedUpData.etype"
USERSPEEDUPDATA_ETYPE_FIELD.number = 1
USERSPEEDUPDATA_ETYPE_FIELD.index = 0
USERSPEEDUPDATA_ETYPE_FIELD.label = 1
USERSPEEDUPDATA_ETYPE_FIELD.has_default_value = false
USERSPEEDUPDATA_ETYPE_FIELD.default_value = nil
USERSPEEDUPDATA_ETYPE_FIELD.enum_type = ESPEEDUPTYPE
USERSPEEDUPDATA_ETYPE_FIELD.type = 14
USERSPEEDUPDATA_ETYPE_FIELD.cpp_type = 8
USERSPEEDUPDATA_ADDPER_FIELD.name = "addper"
USERSPEEDUPDATA_ADDPER_FIELD.full_name = ".Cmd.UserSpeedUpData.addper"
USERSPEEDUPDATA_ADDPER_FIELD.number = 2
USERSPEEDUPDATA_ADDPER_FIELD.index = 1
USERSPEEDUPDATA_ADDPER_FIELD.label = 1
USERSPEEDUPDATA_ADDPER_FIELD.has_default_value = false
USERSPEEDUPDATA_ADDPER_FIELD.default_value = 0
USERSPEEDUPDATA_ADDPER_FIELD.type = 13
USERSPEEDUPDATA_ADDPER_FIELD.cpp_type = 3
USERSPEEDUPDATA.name = "UserSpeedUpData"
USERSPEEDUPDATA.full_name = ".Cmd.UserSpeedUpData"
USERSPEEDUPDATA.nested_types = {}
USERSPEEDUPDATA.enum_types = {}
USERSPEEDUPDATA.fields = {
  USERSPEEDUPDATA_ETYPE_FIELD,
  USERSPEEDUPDATA_ADDPER_FIELD
}
USERSPEEDUPDATA.is_extendable = false
USERSPEEDUPDATA.extensions = {}
QUERYSPEEDUPUSEREVENT_CMD_FIELD.name = "cmd"
QUERYSPEEDUPUSEREVENT_CMD_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.cmd"
QUERYSPEEDUPUSEREVENT_CMD_FIELD.number = 1
QUERYSPEEDUPUSEREVENT_CMD_FIELD.index = 0
QUERYSPEEDUPUSEREVENT_CMD_FIELD.label = 1
QUERYSPEEDUPUSEREVENT_CMD_FIELD.has_default_value = true
QUERYSPEEDUPUSEREVENT_CMD_FIELD.default_value = 25
QUERYSPEEDUPUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYSPEEDUPUSEREVENT_CMD_FIELD.type = 14
QUERYSPEEDUPUSEREVENT_CMD_FIELD.cpp_type = 8
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.name = "param"
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.param"
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.number = 2
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.index = 1
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.label = 1
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.has_default_value = true
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.default_value = 81
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.type = 14
QUERYSPEEDUPUSEREVENT_PARAM_FIELD.cpp_type = 8
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.name = "month_card_effect"
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.month_card_effect"
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.number = 3
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.index = 2
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.label = 1
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.default_value = false
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.type = 8
QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD.cpp_type = 7
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.name = "exp_item_branchs"
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.exp_item_branchs"
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.number = 4
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.index = 3
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.label = 3
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.default_value = {}
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.type = 13
QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD.cpp_type = 3
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.name = "in_max_profession"
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.in_max_profession"
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.number = 5
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.index = 4
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.label = 1
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.default_value = false
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.type = 8
QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD.cpp_type = 7
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.name = "server_open_day"
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.server_open_day"
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.number = 6
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.index = 5
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.label = 1
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.default_value = 0
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.type = 13
QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD.cpp_type = 3
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.name = "base_speedup"
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.base_speedup"
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.number = 7
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.index = 6
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.label = 3
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.default_value = {}
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.message_type = USERSPEEDUPDATA
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.type = 11
QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD.cpp_type = 10
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.name = "job_speedup"
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.job_speedup"
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.number = 8
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.index = 7
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.label = 3
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.default_value = {}
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.message_type = USERSPEEDUPDATA
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.type = 11
QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD.cpp_type = 10
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.name = "gem_speedup"
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.full_name = ".Cmd.QuerySpeedUpUserEvent.gem_speedup"
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.number = 9
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.index = 8
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.label = 3
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.has_default_value = false
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.default_value = {}
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.message_type = USERSPEEDUPDATA
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.type = 11
QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD.cpp_type = 10
QUERYSPEEDUPUSEREVENT.name = "QuerySpeedUpUserEvent"
QUERYSPEEDUPUSEREVENT.full_name = ".Cmd.QuerySpeedUpUserEvent"
QUERYSPEEDUPUSEREVENT.nested_types = {}
QUERYSPEEDUPUSEREVENT.enum_types = {}
QUERYSPEEDUPUSEREVENT.fields = {
  QUERYSPEEDUPUSEREVENT_CMD_FIELD,
  QUERYSPEEDUPUSEREVENT_PARAM_FIELD,
  QUERYSPEEDUPUSEREVENT_MONTH_CARD_EFFECT_FIELD,
  QUERYSPEEDUPUSEREVENT_EXP_ITEM_BRANCHS_FIELD,
  QUERYSPEEDUPUSEREVENT_IN_MAX_PROFESSION_FIELD,
  QUERYSPEEDUPUSEREVENT_SERVER_OPEN_DAY_FIELD,
  QUERYSPEEDUPUSEREVENT_BASE_SPEEDUP_FIELD,
  QUERYSPEEDUPUSEREVENT_JOB_SPEEDUP_FIELD,
  QUERYSPEEDUPUSEREVENT_GEM_SPEEDUP_FIELD
}
QUERYSPEEDUPUSEREVENT.is_extendable = false
QUERYSPEEDUPUSEREVENT.extensions = {}
SERVEROPENTIMEUSEREVENT_CMD_FIELD.name = "cmd"
SERVEROPENTIMEUSEREVENT_CMD_FIELD.full_name = ".Cmd.ServerOpenTimeUserEvent.cmd"
SERVEROPENTIMEUSEREVENT_CMD_FIELD.number = 1
SERVEROPENTIMEUSEREVENT_CMD_FIELD.index = 0
SERVEROPENTIMEUSEREVENT_CMD_FIELD.label = 1
SERVEROPENTIMEUSEREVENT_CMD_FIELD.has_default_value = true
SERVEROPENTIMEUSEREVENT_CMD_FIELD.default_value = 25
SERVEROPENTIMEUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SERVEROPENTIMEUSEREVENT_CMD_FIELD.type = 14
SERVEROPENTIMEUSEREVENT_CMD_FIELD.cpp_type = 8
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.name = "param"
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.full_name = ".Cmd.ServerOpenTimeUserEvent.param"
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.number = 2
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.index = 1
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.label = 1
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.has_default_value = true
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.default_value = 83
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.type = 14
SERVEROPENTIMEUSEREVENT_PARAM_FIELD.cpp_type = 8
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.name = "opentime"
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.full_name = ".Cmd.ServerOpenTimeUserEvent.opentime"
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.number = 3
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.index = 2
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.label = 1
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.has_default_value = false
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.default_value = 0
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.type = 13
SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD.cpp_type = 3
SERVEROPENTIMEUSEREVENT.name = "ServerOpenTimeUserEvent"
SERVEROPENTIMEUSEREVENT.full_name = ".Cmd.ServerOpenTimeUserEvent"
SERVEROPENTIMEUSEREVENT.nested_types = {}
SERVEROPENTIMEUSEREVENT.enum_types = {}
SERVEROPENTIMEUSEREVENT.fields = {
  SERVEROPENTIMEUSEREVENT_CMD_FIELD,
  SERVEROPENTIMEUSEREVENT_PARAM_FIELD,
  SERVEROPENTIMEUSEREVENT_OPENTIME_FIELD
}
SERVEROPENTIMEUSEREVENT.is_extendable = false
SERVEROPENTIMEUSEREVENT.extensions = {}
DAMAGESTATDISTRI_DAM_VALUE_FIELD.name = "dam_value"
DAMAGESTATDISTRI_DAM_VALUE_FIELD.full_name = ".Cmd.DamageStatDistri.dam_value"
DAMAGESTATDISTRI_DAM_VALUE_FIELD.number = 1
DAMAGESTATDISTRI_DAM_VALUE_FIELD.index = 0
DAMAGESTATDISTRI_DAM_VALUE_FIELD.label = 1
DAMAGESTATDISTRI_DAM_VALUE_FIELD.has_default_value = false
DAMAGESTATDISTRI_DAM_VALUE_FIELD.default_value = 0
DAMAGESTATDISTRI_DAM_VALUE_FIELD.type = 5
DAMAGESTATDISTRI_DAM_VALUE_FIELD.cpp_type = 1
DAMAGESTATDISTRI_COUNT_FIELD.name = "count"
DAMAGESTATDISTRI_COUNT_FIELD.full_name = ".Cmd.DamageStatDistri.count"
DAMAGESTATDISTRI_COUNT_FIELD.number = 2
DAMAGESTATDISTRI_COUNT_FIELD.index = 1
DAMAGESTATDISTRI_COUNT_FIELD.label = 1
DAMAGESTATDISTRI_COUNT_FIELD.has_default_value = false
DAMAGESTATDISTRI_COUNT_FIELD.default_value = 0
DAMAGESTATDISTRI_COUNT_FIELD.type = 13
DAMAGESTATDISTRI_COUNT_FIELD.cpp_type = 3
DAMAGESTATDISTRI.name = "DamageStatDistri"
DAMAGESTATDISTRI.full_name = ".Cmd.DamageStatDistri"
DAMAGESTATDISTRI.nested_types = {}
DAMAGESTATDISTRI.enum_types = {}
DAMAGESTATDISTRI.fields = {
  DAMAGESTATDISTRI_DAM_VALUE_FIELD,
  DAMAGESTATDISTRI_COUNT_FIELD
}
DAMAGESTATDISTRI.is_extendable = false
DAMAGESTATDISTRI.extensions = {}
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.name = "cmd"
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.full_name = ".Cmd.SkillDamageStatUserEvent.cmd"
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.number = 1
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.index = 0
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.label = 1
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.has_default_value = true
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.default_value = 25
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.type = 14
SKILLDAMAGESTATUSEREVENT_CMD_FIELD.cpp_type = 8
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.name = "param"
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.full_name = ".Cmd.SkillDamageStatUserEvent.param"
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.number = 2
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.index = 1
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.label = 1
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.has_default_value = true
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.default_value = 86
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.type = 14
SKILLDAMAGESTATUSEREVENT_PARAM_FIELD.cpp_type = 8
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.name = "skillid"
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.full_name = ".Cmd.SkillDamageStatUserEvent.skillid"
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.number = 3
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.index = 2
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.label = 1
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.has_default_value = false
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.default_value = 0
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.type = 13
SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD.cpp_type = 3
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.name = "ave_dam"
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.full_name = ".Cmd.SkillDamageStatUserEvent.ave_dam"
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.number = 4
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.index = 3
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.label = 1
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.has_default_value = false
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.default_value = 0
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.type = 5
SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD.cpp_type = 1
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.name = "dam_distri"
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.full_name = ".Cmd.SkillDamageStatUserEvent.dam_distri"
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.number = 5
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.index = 4
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.label = 3
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.has_default_value = false
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.default_value = {}
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.message_type = DAMAGESTATDISTRI
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.type = 11
SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD.cpp_type = 10
SKILLDAMAGESTATUSEREVENT.name = "SkillDamageStatUserEvent"
SKILLDAMAGESTATUSEREVENT.full_name = ".Cmd.SkillDamageStatUserEvent"
SKILLDAMAGESTATUSEREVENT.nested_types = {}
SKILLDAMAGESTATUSEREVENT.enum_types = {}
SKILLDAMAGESTATUSEREVENT.fields = {
  SKILLDAMAGESTATUSEREVENT_CMD_FIELD,
  SKILLDAMAGESTATUSEREVENT_PARAM_FIELD,
  SKILLDAMAGESTATUSEREVENT_SKILLID_FIELD,
  SKILLDAMAGESTATUSEREVENT_AVE_DAM_FIELD,
  SKILLDAMAGESTATUSEREVENT_DAM_DISTRI_FIELD
}
SKILLDAMAGESTATUSEREVENT.is_extendable = false
SKILLDAMAGESTATUSEREVENT.extensions = {}
HEARTBEATREQUSEREVENT_CMD_FIELD.name = "cmd"
HEARTBEATREQUSEREVENT_CMD_FIELD.full_name = ".Cmd.HeartBeatReqUserEvent.cmd"
HEARTBEATREQUSEREVENT_CMD_FIELD.number = 1
HEARTBEATREQUSEREVENT_CMD_FIELD.index = 0
HEARTBEATREQUSEREVENT_CMD_FIELD.label = 1
HEARTBEATREQUSEREVENT_CMD_FIELD.has_default_value = true
HEARTBEATREQUSEREVENT_CMD_FIELD.default_value = 25
HEARTBEATREQUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HEARTBEATREQUSEREVENT_CMD_FIELD.type = 14
HEARTBEATREQUSEREVENT_CMD_FIELD.cpp_type = 8
HEARTBEATREQUSEREVENT_PARAM_FIELD.name = "param"
HEARTBEATREQUSEREVENT_PARAM_FIELD.full_name = ".Cmd.HeartBeatReqUserEvent.param"
HEARTBEATREQUSEREVENT_PARAM_FIELD.number = 2
HEARTBEATREQUSEREVENT_PARAM_FIELD.index = 1
HEARTBEATREQUSEREVENT_PARAM_FIELD.label = 1
HEARTBEATREQUSEREVENT_PARAM_FIELD.has_default_value = true
HEARTBEATREQUSEREVENT_PARAM_FIELD.default_value = 87
HEARTBEATREQUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
HEARTBEATREQUSEREVENT_PARAM_FIELD.type = 14
HEARTBEATREQUSEREVENT_PARAM_FIELD.cpp_type = 8
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.name = "codec_group"
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.full_name = ".Cmd.HeartBeatReqUserEvent.codec_group"
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.number = 3
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.index = 2
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.label = 1
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.has_default_value = false
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.default_value = 0
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.type = 13
HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD.cpp_type = 3
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.name = "codec_seed"
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.full_name = ".Cmd.HeartBeatReqUserEvent.codec_seed"
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.number = 4
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.index = 3
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.label = 1
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.has_default_value = false
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.default_value = 0
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.type = 4
HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD.cpp_type = 4
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.name = "themis_data"
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.full_name = ".Cmd.HeartBeatReqUserEvent.themis_data"
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.number = 5
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.index = 4
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.label = 1
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.has_default_value = false
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.default_value = ""
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.type = 9
HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD.cpp_type = 9
HEARTBEATREQUSEREVENT.name = "HeartBeatReqUserEvent"
HEARTBEATREQUSEREVENT.full_name = ".Cmd.HeartBeatReqUserEvent"
HEARTBEATREQUSEREVENT.nested_types = {}
HEARTBEATREQUSEREVENT.enum_types = {}
HEARTBEATREQUSEREVENT.fields = {
  HEARTBEATREQUSEREVENT_CMD_FIELD,
  HEARTBEATREQUSEREVENT_PARAM_FIELD,
  HEARTBEATREQUSEREVENT_CODEC_GROUP_FIELD,
  HEARTBEATREQUSEREVENT_CODEC_SEED_FIELD,
  HEARTBEATREQUSEREVENT_THEMIS_DATA_FIELD
}
HEARTBEATREQUSEREVENT.is_extendable = false
HEARTBEATREQUSEREVENT.extensions = {}
HEARTBEATACKUSEREVENT_CMD_FIELD.name = "cmd"
HEARTBEATACKUSEREVENT_CMD_FIELD.full_name = ".Cmd.HeartBeatAckUserEvent.cmd"
HEARTBEATACKUSEREVENT_CMD_FIELD.number = 1
HEARTBEATACKUSEREVENT_CMD_FIELD.index = 0
HEARTBEATACKUSEREVENT_CMD_FIELD.label = 1
HEARTBEATACKUSEREVENT_CMD_FIELD.has_default_value = true
HEARTBEATACKUSEREVENT_CMD_FIELD.default_value = 25
HEARTBEATACKUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HEARTBEATACKUSEREVENT_CMD_FIELD.type = 14
HEARTBEATACKUSEREVENT_CMD_FIELD.cpp_type = 8
HEARTBEATACKUSEREVENT_PARAM_FIELD.name = "param"
HEARTBEATACKUSEREVENT_PARAM_FIELD.full_name = ".Cmd.HeartBeatAckUserEvent.param"
HEARTBEATACKUSEREVENT_PARAM_FIELD.number = 2
HEARTBEATACKUSEREVENT_PARAM_FIELD.index = 1
HEARTBEATACKUSEREVENT_PARAM_FIELD.label = 1
HEARTBEATACKUSEREVENT_PARAM_FIELD.has_default_value = true
HEARTBEATACKUSEREVENT_PARAM_FIELD.default_value = 88
HEARTBEATACKUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
HEARTBEATACKUSEREVENT_PARAM_FIELD.type = 14
HEARTBEATACKUSEREVENT_PARAM_FIELD.cpp_type = 8
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.name = "codec_group"
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.full_name = ".Cmd.HeartBeatAckUserEvent.codec_group"
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.number = 3
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.index = 2
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.label = 1
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.has_default_value = false
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.default_value = 0
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.type = 13
HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD.cpp_type = 3
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.name = "codec_seed"
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.full_name = ".Cmd.HeartBeatAckUserEvent.codec_seed"
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.number = 4
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.index = 3
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.label = 1
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.has_default_value = false
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.default_value = 0
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.type = 4
HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD.cpp_type = 4
HEARTBEATACKUSEREVENT.name = "HeartBeatAckUserEvent"
HEARTBEATACKUSEREVENT.full_name = ".Cmd.HeartBeatAckUserEvent"
HEARTBEATACKUSEREVENT.nested_types = {}
HEARTBEATACKUSEREVENT.enum_types = {}
HEARTBEATACKUSEREVENT.fields = {
  HEARTBEATACKUSEREVENT_CMD_FIELD,
  HEARTBEATACKUSEREVENT_PARAM_FIELD,
  HEARTBEATACKUSEREVENT_CODEC_GROUP_FIELD,
  HEARTBEATACKUSEREVENT_CODEC_SEED_FIELD
}
HEARTBEATACKUSEREVENT.is_extendable = false
HEARTBEATACKUSEREVENT.extensions = {}
REPORTREASON_REASON_ID_FIELD.name = "reason_id"
REPORTREASON_REASON_ID_FIELD.full_name = ".Cmd.ReportReason.reason_id"
REPORTREASON_REASON_ID_FIELD.number = 1
REPORTREASON_REASON_ID_FIELD.index = 0
REPORTREASON_REASON_ID_FIELD.label = 1
REPORTREASON_REASON_ID_FIELD.has_default_value = false
REPORTREASON_REASON_ID_FIELD.default_value = 0
REPORTREASON_REASON_ID_FIELD.type = 13
REPORTREASON_REASON_ID_FIELD.cpp_type = 3
REPORTREASON_REPORT_COUNT_FIELD.name = "report_count"
REPORTREASON_REPORT_COUNT_FIELD.full_name = ".Cmd.ReportReason.report_count"
REPORTREASON_REPORT_COUNT_FIELD.number = 2
REPORTREASON_REPORT_COUNT_FIELD.index = 1
REPORTREASON_REPORT_COUNT_FIELD.label = 1
REPORTREASON_REPORT_COUNT_FIELD.has_default_value = false
REPORTREASON_REPORT_COUNT_FIELD.default_value = 0
REPORTREASON_REPORT_COUNT_FIELD.type = 13
REPORTREASON_REPORT_COUNT_FIELD.cpp_type = 3
REPORTREASON_DATA_FIELD.name = "data"
REPORTREASON_DATA_FIELD.full_name = ".Cmd.ReportReason.data"
REPORTREASON_DATA_FIELD.number = 3
REPORTREASON_DATA_FIELD.index = 2
REPORTREASON_DATA_FIELD.label = 1
REPORTREASON_DATA_FIELD.has_default_value = false
REPORTREASON_DATA_FIELD.default_value = ""
REPORTREASON_DATA_FIELD.type = 9
REPORTREASON_DATA_FIELD.cpp_type = 9
REPORTREASON.name = "ReportReason"
REPORTREASON.full_name = ".Cmd.ReportReason"
REPORTREASON.nested_types = {}
REPORTREASON.enum_types = {}
REPORTREASON.fields = {
  REPORTREASON_REASON_ID_FIELD,
  REPORTREASON_REPORT_COUNT_FIELD,
  REPORTREASON_DATA_FIELD
}
REPORTREASON.is_extendable = false
REPORTREASON.extensions = {}
USERREPORT_CHARID_FIELD.name = "charid"
USERREPORT_CHARID_FIELD.full_name = ".Cmd.UserReport.charid"
USERREPORT_CHARID_FIELD.number = 1
USERREPORT_CHARID_FIELD.index = 0
USERREPORT_CHARID_FIELD.label = 1
USERREPORT_CHARID_FIELD.has_default_value = false
USERREPORT_CHARID_FIELD.default_value = 0
USERREPORT_CHARID_FIELD.type = 4
USERREPORT_CHARID_FIELD.cpp_type = 4
USERREPORT_LAST_REPORT_TIME_FIELD.name = "last_report_time"
USERREPORT_LAST_REPORT_TIME_FIELD.full_name = ".Cmd.UserReport.last_report_time"
USERREPORT_LAST_REPORT_TIME_FIELD.number = 2
USERREPORT_LAST_REPORT_TIME_FIELD.index = 1
USERREPORT_LAST_REPORT_TIME_FIELD.label = 1
USERREPORT_LAST_REPORT_TIME_FIELD.has_default_value = false
USERREPORT_LAST_REPORT_TIME_FIELD.default_value = 0
USERREPORT_LAST_REPORT_TIME_FIELD.type = 13
USERREPORT_LAST_REPORT_TIME_FIELD.cpp_type = 3
USERREPORT_REASONS_FIELD.name = "reasons"
USERREPORT_REASONS_FIELD.full_name = ".Cmd.UserReport.reasons"
USERREPORT_REASONS_FIELD.number = 3
USERREPORT_REASONS_FIELD.index = 2
USERREPORT_REASONS_FIELD.label = 3
USERREPORT_REASONS_FIELD.has_default_value = false
USERREPORT_REASONS_FIELD.default_value = {}
USERREPORT_REASONS_FIELD.message_type = REPORTREASON
USERREPORT_REASONS_FIELD.type = 11
USERREPORT_REASONS_FIELD.cpp_type = 10
USERREPORT.name = "UserReport"
USERREPORT.full_name = ".Cmd.UserReport"
USERREPORT.nested_types = {}
USERREPORT.enum_types = {}
USERREPORT.fields = {
  USERREPORT_CHARID_FIELD,
  USERREPORT_LAST_REPORT_TIME_FIELD,
  USERREPORT_REASONS_FIELD
}
USERREPORT.is_extendable = false
USERREPORT.extensions = {}
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.name = "cmd"
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.full_name = ".Cmd.QueryUserReportListUserEvent.cmd"
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.number = 1
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.index = 0
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.label = 1
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.has_default_value = true
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.default_value = 25
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.type = 14
QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD.cpp_type = 8
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.name = "param"
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.full_name = ".Cmd.QueryUserReportListUserEvent.param"
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.number = 2
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.index = 1
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.label = 1
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.has_default_value = true
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.default_value = 89
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.type = 14
QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD.cpp_type = 8
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.name = "reports"
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.full_name = ".Cmd.QueryUserReportListUserEvent.reports"
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.number = 3
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.index = 2
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.label = 3
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.has_default_value = false
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.default_value = {}
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.message_type = USERREPORT
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.type = 11
QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD.cpp_type = 10
QUERYUSERREPORTLISTUSEREVENT.name = "QueryUserReportListUserEvent"
QUERYUSERREPORTLISTUSEREVENT.full_name = ".Cmd.QueryUserReportListUserEvent"
QUERYUSERREPORTLISTUSEREVENT.nested_types = {}
QUERYUSERREPORTLISTUSEREVENT.enum_types = {}
QUERYUSERREPORTLISTUSEREVENT.fields = {
  QUERYUSERREPORTLISTUSEREVENT_CMD_FIELD,
  QUERYUSERREPORTLISTUSEREVENT_PARAM_FIELD,
  QUERYUSERREPORTLISTUSEREVENT_REPORTS_FIELD
}
QUERYUSERREPORTLISTUSEREVENT.is_extendable = false
QUERYUSERREPORTLISTUSEREVENT.extensions = {}
USERREPORTUSEREVENT_CMD_FIELD.name = "cmd"
USERREPORTUSEREVENT_CMD_FIELD.full_name = ".Cmd.UserReportUserEvent.cmd"
USERREPORTUSEREVENT_CMD_FIELD.number = 1
USERREPORTUSEREVENT_CMD_FIELD.index = 0
USERREPORTUSEREVENT_CMD_FIELD.label = 1
USERREPORTUSEREVENT_CMD_FIELD.has_default_value = true
USERREPORTUSEREVENT_CMD_FIELD.default_value = 25
USERREPORTUSEREVENT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERREPORTUSEREVENT_CMD_FIELD.type = 14
USERREPORTUSEREVENT_CMD_FIELD.cpp_type = 8
USERREPORTUSEREVENT_PARAM_FIELD.name = "param"
USERREPORTUSEREVENT_PARAM_FIELD.full_name = ".Cmd.UserReportUserEvent.param"
USERREPORTUSEREVENT_PARAM_FIELD.number = 2
USERREPORTUSEREVENT_PARAM_FIELD.index = 1
USERREPORTUSEREVENT_PARAM_FIELD.label = 1
USERREPORTUSEREVENT_PARAM_FIELD.has_default_value = true
USERREPORTUSEREVENT_PARAM_FIELD.default_value = 90
USERREPORTUSEREVENT_PARAM_FIELD.enum_type = EVENTPARAM
USERREPORTUSEREVENT_PARAM_FIELD.type = 14
USERREPORTUSEREVENT_PARAM_FIELD.cpp_type = 8
USERREPORTUSEREVENT_REPORT_FIELD.name = "report"
USERREPORTUSEREVENT_REPORT_FIELD.full_name = ".Cmd.UserReportUserEvent.report"
USERREPORTUSEREVENT_REPORT_FIELD.number = 3
USERREPORTUSEREVENT_REPORT_FIELD.index = 2
USERREPORTUSEREVENT_REPORT_FIELD.label = 1
USERREPORTUSEREVENT_REPORT_FIELD.has_default_value = false
USERREPORTUSEREVENT_REPORT_FIELD.default_value = nil
USERREPORTUSEREVENT_REPORT_FIELD.message_type = USERREPORT
USERREPORTUSEREVENT_REPORT_FIELD.type = 11
USERREPORTUSEREVENT_REPORT_FIELD.cpp_type = 10
USERREPORTUSEREVENT_MSGID_FIELD.name = "msgid"
USERREPORTUSEREVENT_MSGID_FIELD.full_name = ".Cmd.UserReportUserEvent.msgid"
USERREPORTUSEREVENT_MSGID_FIELD.number = 4
USERREPORTUSEREVENT_MSGID_FIELD.index = 3
USERREPORTUSEREVENT_MSGID_FIELD.label = 1
USERREPORTUSEREVENT_MSGID_FIELD.has_default_value = false
USERREPORTUSEREVENT_MSGID_FIELD.default_value = 0
USERREPORTUSEREVENT_MSGID_FIELD.type = 13
USERREPORTUSEREVENT_MSGID_FIELD.cpp_type = 3
USERREPORTUSEREVENT.name = "UserReportUserEvent"
USERREPORTUSEREVENT.full_name = ".Cmd.UserReportUserEvent"
USERREPORTUSEREVENT.nested_types = {}
USERREPORTUSEREVENT.enum_types = {}
USERREPORTUSEREVENT.fields = {
  USERREPORTUSEREVENT_CMD_FIELD,
  USERREPORTUSEREVENT_PARAM_FIELD,
  USERREPORTUSEREVENT_REPORT_FIELD,
  USERREPORTUSEREVENT_MSGID_FIELD
}
USERREPORTUSEREVENT.is_extendable = false
USERREPORTUSEREVENT.extensions = {}
ActionFavoriteFriendUserEvent = protobuf.Message(ACTIONFAVORITEFRIENDUSEREVENT)
ActivityCntItem = protobuf.Message(ACTIVITYCNTITEM)
ActivityPointUserEvent = protobuf.Message(ACTIVITYPOINTUSEREVENT)
AllTitle = protobuf.Message(ALLTITLE)
BeginMonitorUserEvent = protobuf.Message(BEGINMONITORUSEREVENT)
BifrostContributeItemUserEvent = protobuf.Message(BIFROSTCONTRIBUTEITEMUSEREVENT)
BuffDamageUserEvent = protobuf.Message(BUFFDAMAGEUSEREVENT)
CameraActionUserEvent = protobuf.Message(CAMERAACTIONUSEREVENT)
ChangeTitle = protobuf.Message(CHANGETITLE)
ChargeCntInfo = protobuf.Message(CHARGECNTINFO)
ChargeNtfUserEvent = protobuf.Message(CHARGENTFUSEREVENT)
ChargeQueryCmd = protobuf.Message(CHARGEQUERYCMD)
ChargeSdkReplyUserEvent = protobuf.Message(CHARGESDKREPLYUSEREVENT)
ChargeSdkRequestUserEvent = protobuf.Message(CHARGESDKREQUESTUSEREVENT)
ClientAIData = protobuf.Message(CLIENTAIDATA)
ClientAISyncUserEvent = protobuf.Message(CLIENTAISYNCUSEREVENT)
ClientAIUpdateUserEvent = protobuf.Message(CLIENTAIUPDATEUSEREVENT)
ConfigActionUserEvent = protobuf.Message(CONFIGACTIONUSEREVENT)
ConfigInfo = protobuf.Message(CONFIGINFO)
DamageNpcUserEvent = protobuf.Message(DAMAGENPCUSEREVENT)
DamageStatDistri = protobuf.Message(DAMAGESTATDISTRI)
DelTransformUserEvent = protobuf.Message(DELTRANSFORMUSEREVENT)
DepositCardData = protobuf.Message(DEPOSITCARDDATA)
DepositCardInfo = protobuf.Message(DEPOSITCARDINFO)
DepositTypeData = protobuf.Message(DEPOSITTYPEDATA)
DieTimeCountEventCmd = protobuf.Message(DIETIMECOUNTEVENTCMD)
DoubleAcionEvent = protobuf.Message(DOUBLEACIONEVENT)
ECONFIGACTION_ADD = 2
ECONFIGACTION_DELETE = 4
ECONFIGACTION_MAX = 5
ECONFIGACTION_MIN = 0
ECONFIGACTION_MODIFY = 3
ECONFIGACTION_QUERY = 1
EDELAYRELIVE_GVG_POINT = 1
EDELAYRELIVE_GVG_SAFE = 2
EDELAYRELIVE_MIN = 0
EDEPOSITSTAT_INVALID = 2
EDEPOSITSTAT_NONE = 0
EDEPOSITSTAT_VALID = 1
EEVENTMAILTYPE_DELCAHR = 1
EEVENTMAILTYPE_MIN = 0
EFIRSTACTION_COMPOSECARD = 3
EFIRSTACTION_COOKFOOD = 4
EFIRSTACTION_DECOMPOSECARD = 11
EFIRSTACTION_EXCHANGECARD = 2
EFIRSTACTION_FOOD_MAIL = 6
EFIRSTACTION_KFC_SHARE = 12
EFIRSTACTION_LOTTERY = 5
EFIRSTACTION_LOTTERY_CARD = 8
EFIRSTACTION_LOTTERY_CARD_NEW = 15
EFIRSTACTION_LOTTERY_EQUIP = 7
EFIRSTACTION_LOTTERY_MAGIC = 9
EFIRSTACTION_MIN = 0
EFIRSTACTION_MIX_LOTTERY = 14
EFIRSTACTION_RECALL_SHARE = 10
EFIRSTACTION_RIDE_LOTTERY = 13
EFIRSTACTION_SKILL_OVERFLOW = 1
EGIFTSTATE_ACTIVE = 1
EGIFTSTATE_EXPIRE = 3
EGIFTSTATE_INIT = 0
EGIFTSTATE_REWARD = 2
ESPEEDUP_TYPE_CARD_COMMON = 5
ESPEEDUP_TYPE_CARD_NOT_TIRE = 4
ESPEEDUP_TYPE_CARD_RAID = 6
ESPEEDUP_TYPE_DIFF_JOB = 1
ESPEEDUP_TYPE_ITEM = 3
ESPEEDUP_TYPE_MAX = 7
ESPEEDUP_TYPE_MIN = 0
ESPEEDUP_TYPE_SERVER = 2
ESYSTEMSTRING_MEMO = 1
ESYSTEMSTRING_MIN = 0
ETITLE_TYPE_ACHIEVEMENT = 2
ETITLE_TYPE_ACHIEVEMENT_ORDER = 3
ETITLE_TYPE_FOODCOOKER = 7
ETITLE_TYPE_FOODTASTER = 8
ETITLE_TYPE_MANNUAL = 1
ETITLE_TYPE_MAX = 9
ETITLE_TYPE_MIN = 0
FirstActionUserEvent = protobuf.Message(FIRSTACTIONUSEREVENT)
GetFirstShareRewardUserEvent = protobuf.Message(GETFIRSTSHAREREWARDUSEREVENT)
GiftCodeExchangeEvent = protobuf.Message(GIFTCODEEXCHANGEEVENT)
GiftEvent = protobuf.Message(GIFTEVENT)
GiftInfo = protobuf.Message(GIFTINFO)
GiftTimeLimitActiveUserEvent = protobuf.Message(GIFTTIMELIMITACTIVEUSEREVENT)
GiftTimeLimitBuyUserEvent = protobuf.Message(GIFTTIMELIMITBUYUSEREVENT)
GiftTimeLimitNtfUserEvent = protobuf.Message(GIFTTIMELIMITNTFUSEREVENT)
GoActivityMapUserEvent = protobuf.Message(GOACTIVITYMAPUSEREVENT)
GuideQuestEvent = protobuf.Message(GUIDEQUESTEVENT)
GvgOptStatueEvent = protobuf.Message(GVGOPTSTATUEEVENT)
GvgSandTableEvent = protobuf.Message(GVGSANDTABLEEVENT)
HandCatUserEvent = protobuf.Message(HANDCATUSEREVENT)
HeartBeatAckUserEvent = protobuf.Message(HEARTBEATACKUSEREVENT)
HeartBeatReqUserEvent = protobuf.Message(HEARTBEATREQUSEREVENT)
InOutActEventCmd = protobuf.Message(INOUTACTEVENTCMD)
InviteCatFailUserEvent = protobuf.Message(INVITECATFAILUSEREVENT)
LevelupDeadUserEvent = protobuf.Message(LEVELUPDEADUSEREVENT)
LoveLetterUse = protobuf.Message(LOVELETTERUSE)
MonitorBuildUserEvent = protobuf.Message(MONITORBUILDUSEREVENT)
MonitorGoToMapUserEvent = protobuf.Message(MONITORGOTOMAPUSEREVENT)
MonitorMapEndUserEvent = protobuf.Message(MONITORMAPENDUSEREVENT)
MultiCutScene = protobuf.Message(MULTICUTSCENE)
MultiCutSceneUpdateUserEvent = protobuf.Message(MULTICUTSCENEUPDATEUSEREVENT)
NTFMonthCardEnd = protobuf.Message(NTFMONTHCARDEND)
NewTitle = protobuf.Message(NEWTITLE)
NpcWalkStepNtfUserEvent = protobuf.Message(NPCWALKSTEPNTFUSEREVENT)
NtfVersionCardInfo = protobuf.Message(NTFVERSIONCARDINFO)
PlayCutSceneUserEvent = protobuf.Message(PLAYCUTSCENEUSEREVENT)
PlayHoldPetUserEvent = protobuf.Message(PLAYHOLDPETUSEREVENT)
PointInfo = protobuf.Message(POINTINFO)
PolicyAgreeUserEvent = protobuf.Message(POLICYAGREEUSEREVENT)
PolicyUpdateUserEvent = protobuf.Message(POLICYUPDATEUSEREVENT)
QueryAccChargeCntReward = protobuf.Message(QUERYACCCHARGECNTREWARD)
QueryActivityCnt = protobuf.Message(QUERYACTIVITYCNT)
QueryChargeCnt = protobuf.Message(QUERYCHARGECNT)
QueryFateRelationEvent = protobuf.Message(QUERYFATERELATIONEVENT)
QueryFavoriteFriendUserEvent = protobuf.Message(QUERYFAVORITEFRIENDUSEREVENT)
QueryProfileUserEvent = protobuf.Message(QUERYPROFILEUSEREVENT)
QueryResetTimeEventCmd = protobuf.Message(QUERYRESETTIMEEVENTCMD)
QuerySpeedUpUserEvent = protobuf.Message(QUERYSPEEDUPUSEREVENT)
QueryUserReportListUserEvent = protobuf.Message(QUERYUSERREPORTLISTUSEREVENT)
ReportReason = protobuf.Message(REPORTREASON)
ReqPeriodicMonsterUserEvent = protobuf.Message(REQPERIODICMONSTERUSEREVENT)
RobotOffBattleUserEvent = protobuf.Message(ROBOTOFFBATTLEUSEREVENT)
SandTableGuild = protobuf.Message(SANDTABLEGUILD)
SandTableInfo = protobuf.Message(SANDTABLEINFO)
ServerOpenTimeUserEvent = protobuf.Message(SERVEROPENTIMEUSEREVENT)
SetHideOtherCmd = protobuf.Message(SETHIDEOTHERCMD)
SetProfileUserEvent = protobuf.Message(SETPROFILEUSEREVENT)
SetReliveMethodUserEvent = protobuf.Message(SETRELIVEMETHODUSEREVENT)
ShowCardEvent = protobuf.Message(SHOWCARDEVENT)
ShowGiftInfo = protobuf.Message(SHOWGIFTINFO)
ShowRMBGiftEvent = protobuf.Message(SHOWRMBGIFTEVENT)
ShowSceneObject = protobuf.Message(SHOWSCENEOBJECT)
SkillDamageStatUserEvent = protobuf.Message(SKILLDAMAGESTATUSEREVENT)
SoundStoryUserEvent = protobuf.Message(SOUNDSTORYUSEREVENT)
StopMonitorRetUserEvent = protobuf.Message(STOPMONITORRETUSEREVENT)
StopMonitorUserEvent = protobuf.Message(STOPMONITORUSEREVENT)
SwitchAutoBattleUserEvent = protobuf.Message(SWITCHAUTOBATTLEUSEREVENT)
SyncFateRelationEvent = protobuf.Message(SYNCFATERELATIONEVENT)
SystemStringUserEvent = protobuf.Message(SYSTEMSTRINGUSEREVENT)
ThemeDetailsUserEvent = protobuf.Message(THEMEDETAILSUSEREVENT)
TimeLimitIconEvent = protobuf.Message(TIMELIMITICONEVENT)
TitleData = protobuf.Message(TITLEDATA)
TrigNpcFuncUserEvent = protobuf.Message(TRIGNPCFUNCUSEREVENT)
UIActionUserEvent = protobuf.Message(UIACTIONUSEREVENT)
USER_EVENT_ACTION_FAVORITE_FRIEND = 35
USER_EVENT_ACTIVITY_MAP = 30
USER_EVENT_ACTIVITY_POINT = 31
USER_EVENT_ALL_TITLE = 4
USER_EVENT_ATTACK_NPC = 2
USER_EVENT_AUTOBATTLE = 29
USER_EVENT_BIFROST_CONTRIBUTE_ITEM = 39
USER_EVENT_BUFF_DAMAGE = 6
USER_EVENT_CAMERA_ACTION = 40
USER_EVENT_CHANGE_TITLE = 15
USER_EVENT_CHARGE_ACC_CNT = 37
USER_EVENT_CHARGE_NTF = 7
USER_EVENT_CHARGE_QUERY = 8
USER_EVENT_CHARGE_SDK_REPLY = 43
USER_EVENT_CHARGE_SDK_REQUEST = 42
USER_EVENT_CLIENT_AI_SYNC = 44
USER_EVENT_CLIENT_AI_UPDATE = 45
USER_EVENT_CONFIG = 66
USER_EVENT_DAMAGE_RESULT = 86
USER_EVENT_DELAY_RELIVE_METHOD = 79
USER_EVENT_DEL_TRANSFORM = 10
USER_EVENT_DEPOSIT_CARD_INFO = 9
USER_EVENT_DOUBLE_ACTION = 59
USER_EVENT_FIRST_ACTION = 1
USER_EVENT_GET_RECALL_SHARE_REWARD = 22
USER_EVENT_GIFTCODE_EXCHANGE = 46
USER_EVENT_GIFT_TIMELIMIT_ACTIVE = 50
USER_EVENT_GIFT_TIMELIMIT_BUY = 49
USER_EVENT_GIFT_TIMELIMIT_NTF = 48
USER_EVENT_GUIDE = 73
USER_EVENT_GVGSANDTABLE_INFO = 78
USER_EVENT_GVG_OPT_STATUE = 71
USER_EVENT_HAND_CAT = 14
USER_EVENT_HEARTBEAT_ACH = 88
USER_EVENT_HEARTBEAT_REQ = 87
USER_EVENT_HIDE_OTHER_APPEARANCE = 47
USER_EVENT_INOUT_ACT = 26
USER_EVENT_INVITECAT_FAIL = 11
USER_EVENT_LEVELUP_DEAD = 28
USER_EVENT_LOVELETTER_USE = 18
USER_EVENT_MAIL = 27
USER_EVENT_MONITOR_BEGIN = 60
USER_EVENT_MONITOR_BUILD = 64
USER_EVENT_MONITOR_ENDMAP = 63
USER_EVENT_MONITOR_STOP = 61
USER_EVENT_MONITOR_STOP_RET = 65
USER_EVENT_MONITOR_TOMAP = 62
USER_EVENT_MULTI_CUTSCENE_UPDATE = 55
USER_EVENT_NEW_TITLE = 3
USER_EVENT_NPCWALK = 67
USER_EVENT_NPC_FUNCTION = 12
USER_EVENT_NTF_MONTHCARD_END = 17
USER_EVENT_NTF_VERSION_CARD = 23
USER_EVENT_PLAY_CUTSCENE = 82
USER_EVENT_PLAY_HOLDPET = 85
USER_EVENT_POLICY_AGREE = 57
USER_EVENT_POLICY_UPDATE = 56
USER_EVENT_QUERY_ACTIVITY_CNT = 19
USER_EVENT_QUERY_CHARGE_CNT = 16
USER_EVENT_QUERY_FATE_RELATION = 70
USER_EVENT_QUERY_FAVORITE_FRIEND = 33
USER_EVENT_QUERY_PROFILE = 77
USER_EVENT_QUERY_RESETTIME = 25
USER_EVENT_QUERY_SPEEDUP = 81
USER_EVENT_QUERY_USER_REPORT_LIST = 89
USER_EVENT_REQ_PERIODIC_MONSTER = 84
USER_EVENT_RMB_GIFT = 76
USER_EVENT_ROBOT_OFFBATTLE = 41
USER_EVENT_SERVER_OPENTME = 83
USER_EVENT_SET_PROFILE = 68
USER_EVENT_SHOW_CARD = 75
USER_EVENT_SHOW_SCENE_OBJECT = 58
USER_EVENT_SOUND_STORY = 36
USER_EVENT_SYNC_FATE_RELATION = 69
USER_EVENT_SYSTEM_STRING = 13
USER_EVENT_THEME_DETAILS = 32
USER_EVENT_TIMELIMIT_ICON = 72
USER_EVENT_UI_ACTION = 80
USER_EVENT_UPDATE_ACTIVITY_CNT = 20
USER_EVENT_UPDATE_FAVORITE_FRIEND = 34
USER_EVENT_UPDATE_RANDOM = 5
USER_EVENT_USER_REPORT = 90
USER_EVENT_WAIT_RELIVE = 24
UpdateActivityCnt = protobuf.Message(UPDATEACTIVITYCNT)
UpdateFavoriteFriendUserEvent = protobuf.Message(UPDATEFAVORITEFRIENDUSEREVENT)
UpdateRandomUserEvent = protobuf.Message(UPDATERANDOMUSEREVENT)
UserEventMailCmd = protobuf.Message(USEREVENTMAILCMD)
UserReport = protobuf.Message(USERREPORT)
UserReportUserEvent = protobuf.Message(USERREPORTUSEREVENT)
UserSpeedUpData = protobuf.Message(USERSPEEDUPDATA)
VersionCardInfo = protobuf.Message(VERSIONCARDINFO)
