local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("SceneItem_pb")
local SceneItem_pb = SceneItem_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
module("SceneQuest_pb")
QUESTPARAM = protobuf.EnumDescriptor()
QUESTPARAM_QUESTPARAM_QUESTLIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTUPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTACTION_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_RUNQUESTSTEP_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTSTEPUPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTTRACE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTDETAILLIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTDETAILUPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTRAIDCMD_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_CANACCEPTLISTCHANGED_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_VISIT_NPC_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERYOTHERDATA_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERYWANTEDINFO_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_INVITE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_AGREE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_INVITE_ACCEPT_QUEST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERY_WORLD_QUEST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTGROUP_TRACE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_HELP_QUICK_FINISH_BOARD_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERY_QUESTLIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_MAPSTEP_SYNC_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_MAPSTEP_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_MAPSTEP_FINISH_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_AREA_ACTION_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_PLOT_STATUS_NTF_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_BOTTLE_QUERY_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_BOTTLE_ACTION_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_BOTTLE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_EVIDENCE_QUERY_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERY_CHARACTER_INFO_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_EVIDENCE_HINT_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_ENLIGHT_SECRET_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_CLOSE_UI_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_NEW_EVIDENCE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_LEAVE_VISIT_NPC_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_COMPLETE_AVAILABLE_QUERY_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_WORLD_COUNT_LIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_TRACE_LIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_TRACE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_NEW_LIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_NEW_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTHERO_QUERY_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUESTHERO_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_STATUS_SET_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_STORY_INDEX_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_ONCE_REWARD_UPDATE_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_SYNC_TREASURE_BOX_NUM_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_QUERY_ABYSS_LIST_ENUM = protobuf.EnumValueDescriptor()
QUESTPARAM_QUESTPARAM_UPDATE_ABYSS_HELPCOUNT_ENUM = protobuf.EnumValueDescriptor()
EWANTEDTYPE = protobuf.EnumDescriptor()
EWANTEDTYPE_EWANTEDTYPE_TOTAL_ENUM = protobuf.EnumValueDescriptor()
EWANTEDTYPE_EWANTEDTYPE_ACTIVE_ENUM = protobuf.EnumValueDescriptor()
EWANTEDTYPE_EWANTEDTYPE_DAY_ENUM = protobuf.EnumValueDescriptor()
EWANTEDTYPE_EWANTEDTYPE_WEEK_ENUM = protobuf.EnumValueDescriptor()
EWANTEDTYPE_EWANTEDTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE = protobuf.EnumDescriptor()
EQUESTTYPE_EQUESTTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_MAIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_BRANCH_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_TALK_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_TRIGGER_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WANTED_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_7_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_STORY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_MAP_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SCENE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_HEAD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_RAIDTALK_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SATISFACTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ELITE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_CCRASTEHAM_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_STORY_CCRASTEHAM_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_GUILD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_CHILD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_RESET_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_CHOICE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_MAPRAND_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_MAIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_BRANCH_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_SATISFACTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_7_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_RESET_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAILY_BOX_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SIGN_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DAY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_NIGHT_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ARTIFACT_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WEDDING_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WEDDING_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_CAPRA_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_DEAD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_2_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_4_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_VERSION_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WANTED_DAY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WANTED_WEEK_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_BRANCHTALK_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_BRANCHSTEFANIE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SHARE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_7_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WORLD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WORLDBOSS_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WORLDTREASURE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SHARE_STATUS_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_GUIDING_TASK_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_5_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WEEK_1_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WEEK_3_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_WEEK_5_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_BOTTLE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WORLD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WORLDTREASURE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_WORLD_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ATMOSPHERE_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_SMITHY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ANCIENT_CITY_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ACC_WORLDBOSS_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_ABYSS_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTTYPE_EQUESTTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP = protobuf.EnumDescriptor()
EQUESTSTEP_EQUESTSTEP_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_VISIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_KILL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REWARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_COLLECT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SUMMON_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GUARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GMCMD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TESTFAIL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_USE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GATHER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_DELETE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RAID_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CAMERA_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_LEVEL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_WAIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MOVE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_DIALOG_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PREQUEST_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CLEARNPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MOUNTRIDE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SELFIE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKTEAM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REMOVEMONEY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CLASS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ORGCLASS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EVO_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKQUEST_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKITEM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REMOVEITEM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RANDOMJUMP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKLEVEL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKGEAR_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PURIFY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ACTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SKILL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INTERLOCUTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EMPTY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKEQUIP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKMONEY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GUIDE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GUIDE_CHECK_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GUIDE_HIGHLIGHT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKOPTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_HINT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKGROUP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SEAL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EQUIPLV_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_VIDEO_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ILLUSTRATION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NPCPLAY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ITEM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_DAILY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_MANUAL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MANUAL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PLAY_MUSIC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REWRADHELP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GUIDELOCKMONSTER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MONEY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ACTIVITY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_OPTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PHOTO_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ITEMUSE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_HAND_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MUSIC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RANDITEM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CARRIER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BATTLE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_COOKFOOD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PET_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SCENE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_COOK_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BUFF_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TUTOR_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_RUN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BEING_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_JOY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ADD_JOY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RAND_DIALOG_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CG_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKSERVANT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CLIENTPLOT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHAT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TRANSFER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REDIALOG_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHAT_SYSTEM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_UNLOCKCAT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GROUP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NPCWALK_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NPCSKILL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_HANDNPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_USESKILL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NPCHP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CAMERASHOW_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TIMEPHASING_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GAME_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_KILLORDER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PICTURE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GAMECOUNT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MAIL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHOOSE_BRANCH_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_WAITPOS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SHOT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_START_ACT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CUT_SCENE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKBORNMAP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PAPER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RANDOM_TIP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SHARE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TRANSIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SHAKESCREEN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ADDPICTURE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_DELPICTURE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_LIGHT_PUZZLE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PARTNER_MOVE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_WAITCLIENT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TAPPING_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_JOINT_REASON_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_AIEVENT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_FOLLOWNPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MIND_ENTER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SHOW_EVIDENCE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MIND_EXIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MIND_UNLOCK_PERFORM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_RANDOM_BUFF_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MULTICUTSCENE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_KILL_SPECIALNPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_WAITUI_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_LOAD_CLIENT_RAID_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CLIENT_RAID_PASS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SELFIE_SYS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_LOCK_BROKEN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PLAY_ACTION_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PLAY_EFFECT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_EVIDENCE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EDITOR_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MUSIC_GAME_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_CLEAR_END_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MENU_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EXCHANGE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_GRACE_REWARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_SMITHY_LEVEL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_POSTCARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_MENU_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NEW_CHAPTER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INTERACT_LOACL_AI_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_AI_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INTERACT_LOCAL_VISIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ADD_LOACL_INTERACT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_INTERACT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INTERACT_NPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INTERACT_MULTI_NPC_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_TAKE_SEAT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECKTRANSFER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_STAR_ARK_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_MULTI_QUEST_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CHECK_HOME_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_NPC_BUFF_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ACTIVATE_TRANSFER_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ITEM_COUNT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_ITEM_NUM_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EFFECT_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_EQUIP_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_AREA_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_WIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_STATUE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_CLIENT_DELAY_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_INHERITSKILL_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTEP_EQUESTSTEP_MAX_ENUM = protobuf.EnumValueDescriptor()
ECLIENTTRACE = protobuf.EnumDescriptor()
ECLIENTTRACE_ECLIENTTYPE_TRUE_ENUM = protobuf.EnumValueDescriptor()
ECLIENTTRACE_ECLIENTTYPE_FALSE_ENUM = protobuf.EnumValueDescriptor()
ECLIENTTRACE_ECLIENTTYPE_FAKEFALSE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTATUS = protobuf.EnumDescriptor()
EQUESTSTATUS_EQUESTSTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTATUS_EQUESTSTATUS_TRUE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTATUS_EQUESTSTATUS_FALSE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTATUS_EQUESTSTATUS_FAKEFALSE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTATUS_EQUESTSTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST = protobuf.EnumDescriptor()
EQUESTLIST_EQUESTLIST_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST_EQUESTLIST_ACCEPT_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST_EQUESTLIST_SUBMIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST_EQUESTLIST_COMPLETE_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST_EQUESTLIST_CANACCEPT_ENUM = protobuf.EnumValueDescriptor()
EQUESTLIST_EQUESTLIST_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION = protobuf.EnumDescriptor()
EQUESTACTION_EQUESTACTION_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_ACCEPT_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_SUBMIT_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_ABANDON_GROUP_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_ABANDON_QUEST_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_REPAIR_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_ABYSS_ENUM = protobuf.EnumValueDescriptor()
EQUESTACTION_EQUESTACTION_MAX_ENUM = protobuf.EnumValueDescriptor()
EOTHERDATA = protobuf.EnumDescriptor()
EOTHERDATA_EOTHERDATA_MIN_ENUM = protobuf.EnumValueDescriptor()
EOTHERDATA_EOTHERDATA_DAILY_ENUM = protobuf.EnumValueDescriptor()
EOTHERDATA_EOTHERDATA_CAT_ENUM = protobuf.EnumValueDescriptor()
EOTHERDATA_EOTHERDATA_WORLDTREASURE_ENUM = protobuf.EnumValueDescriptor()
EOTHERDATA_EOTHERDATA_MAX_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE = protobuf.EnumDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_MIN_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_GUESS_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_MISCHIEF_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_QUESTION_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_FOOD_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_YOYO_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_ATF_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_AUGURY_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_PHOTO_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_BEATPORI_ENUM = protobuf.EnumValueDescriptor()
EJOYACTIVITYTYPE_JOY_ACTIVITY_MAX_ENUM = protobuf.EnumValueDescriptor()
EBOTTLESTATUS = protobuf.EnumDescriptor()
EBOTTLESTATUS_EBOTTLESTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EBOTTLESTATUS_EBOTTLESTATUS_ACCEPT_ENUM = protobuf.EnumValueDescriptor()
EBOTTLESTATUS_EBOTTLESTATUS_FINISH_ENUM = protobuf.EnumValueDescriptor()
EBOTTLESTATUS_EBOTTLESTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EBOTTLEACTION = protobuf.EnumDescriptor()
EBOTTLEACTION_EBOTTLEACTION_MIN_ENUM = protobuf.EnumValueDescriptor()
EBOTTLEACTION_EBOTTLEACTION_ACCEPT_ENUM = protobuf.EnumValueDescriptor()
EBOTTLEACTION_EBOTTLEACTION_ABANDON_ENUM = protobuf.EnumValueDescriptor()
EBOTTLEACTION_EBOTTLEACTION_FINISH_ENUM = protobuf.EnumValueDescriptor()
EBOTTLEACTION_EBOTTLEACTION_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTCOMPLETESTATUS = protobuf.EnumDescriptor()
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_REWARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_NOREWARD_ENUM = protobuf.EnumValueDescriptor()
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_NOQUEST_ENUM = protobuf.EnumValueDescriptor()
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTHEROSTATUS = protobuf.EnumDescriptor()
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTHEROSTATUS_EQUESTHEROSTATUS_PROCESS_ENUM = protobuf.EnumValueDescriptor()
EQUESTHEROSTATUS_EQUESTHEROSTATUS_DONE_ENUM = protobuf.EnumValueDescriptor()
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTORYSTATUS = protobuf.EnumDescriptor()
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_LOCK_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_PROCESS_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_DONE_ENUM = protobuf.EnumValueDescriptor()
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
EACTMISSIONREWARDSTATUS = protobuf.EnumDescriptor()
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MIN_ENUM = protobuf.EnumValueDescriptor()
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_REWARD_ENUM = protobuf.EnumValueDescriptor()
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_DONE_ENUM = protobuf.EnumValueDescriptor()
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MAX_ENUM = protobuf.EnumValueDescriptor()
REWARD = protobuf.Descriptor()
QUESTPCONFIG = protobuf.Descriptor()
QUESTPCONFIG_QUESTID_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_GROUPID_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_REWARDGROUP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_SUBGROUP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_FINISHJUMP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_FAILJUMP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_MAP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_WHETHERTRACE_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_AUTO_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_FIRSTCLASS_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_CLASS_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_LEVEL_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_PRENOSHOW_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_RISKLEVEL_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_JOBLEVEL_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_COOKERLV_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_TASTERLV_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_STARTTIME_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_ENDTIME_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_ICON_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_COLOR_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_QUESTNAME_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_NAME_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_TYPE_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_CONTENT_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_TRACEINFO_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_PREFIXION_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_VERSION_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_PARAMS_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_EXTRAJUMP_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_STEPACTIONS_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_ALLREWARD_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_PREQUEST_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_MUSTPREQUEST_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_PREMENU_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_MUSTPREMENU_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_HEADICON_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_HIDE_FIELD = protobuf.FieldDescriptor()
QUESTPCONFIG_CREATETIME_FIELD = protobuf.FieldDescriptor()
QUESTSTEP = protobuf.Descriptor()
QUESTSTEP_PROCESS_FIELD = protobuf.FieldDescriptor()
QUESTSTEP_PARAMS_FIELD = protobuf.FieldDescriptor()
QUESTSTEP_NAMES_FIELD = protobuf.FieldDescriptor()
QUESTSTEP_CONFIG_FIELD = protobuf.FieldDescriptor()
CLIENTTRACE = protobuf.Descriptor()
CLIENTTRACE_QUESTID_FIELD = protobuf.FieldDescriptor()
CLIENTTRACE_TRACE_FIELD = protobuf.FieldDescriptor()
QUESTDATA = protobuf.Descriptor()
QUESTDATA_ID_FIELD = protobuf.FieldDescriptor()
QUESTDATA_STEP_FIELD = protobuf.FieldDescriptor()
QUESTDATA_TIME_FIELD = protobuf.FieldDescriptor()
QUESTDATA_COMPLETE_FIELD = protobuf.FieldDescriptor()
QUESTDATA_TRACE_FIELD = protobuf.FieldDescriptor()
QUESTDATA_DONE_FIELD = protobuf.FieldDescriptor()
QUESTDATA_PREDONE_FIELD = protobuf.FieldDescriptor()
QUESTDATA_CONVERT_FIELD = protobuf.FieldDescriptor()
QUESTDATA_ACCEPTTIME_FIELD = protobuf.FieldDescriptor()
QUESTDATA_STEPSTARTTIME_FIELD = protobuf.FieldDescriptor()
QUESTDATA_STEPSTARTMOVEDIS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_STEPS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_REWARDS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_VERSION_FIELD = protobuf.FieldDescriptor()
QUESTDATA_ACCEPTLV_FIELD = protobuf.FieldDescriptor()
QUESTDATA_FINISHCOUNT_FIELD = protobuf.FieldDescriptor()
QUESTDATA_TRACE_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_NEW_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_PARAMS_FIELD = protobuf.FieldDescriptor()
QUESTDATA_NAMES_FIELD = protobuf.FieldDescriptor()
QUESTPUZZLE = protobuf.Descriptor()
QUESTPUZZLE_VERSION_FIELD = protobuf.FieldDescriptor()
QUESTPUZZLE_OPEN_PUZZLES_FIELD = protobuf.FieldDescriptor()
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD = protobuf.FieldDescriptor()
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD = protobuf.FieldDescriptor()
QUESTLIST = protobuf.Descriptor()
QUESTLIST_CMD_FIELD = protobuf.FieldDescriptor()
QUESTLIST_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTLIST_TYPE_FIELD = protobuf.FieldDescriptor()
QUESTLIST_ID_FIELD = protobuf.FieldDescriptor()
QUESTLIST_LIST_FIELD = protobuf.FieldDescriptor()
QUESTLIST_CLEAR_FIELD = protobuf.FieldDescriptor()
QUESTLIST_OVER_FIELD = protobuf.FieldDescriptor()
QUESTUPDATEITEM = protobuf.Descriptor()
QUESTUPDATEITEM_UPDATE_FIELD = protobuf.FieldDescriptor()
QUESTUPDATEITEM_DEL_FIELD = protobuf.FieldDescriptor()
QUESTUPDATEITEM_TYPE_FIELD = protobuf.FieldDescriptor()
QUESTUPDATE = protobuf.Descriptor()
QUESTUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
QUESTUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTUPDATE_ITEMS_FIELD = protobuf.FieldDescriptor()
QUESTSTEPUPDATE = protobuf.Descriptor()
QUESTSTEPUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
QUESTSTEPUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTSTEPUPDATE_ID_FIELD = protobuf.FieldDescriptor()
QUESTSTEPUPDATE_STEP_FIELD = protobuf.FieldDescriptor()
QUESTSTEPUPDATE_DATA_FIELD = protobuf.FieldDescriptor()
QUESTACTION = protobuf.Descriptor()
QUESTACTION_CMD_FIELD = protobuf.FieldDescriptor()
QUESTACTION_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTACTION_ACTION_FIELD = protobuf.FieldDescriptor()
QUESTACTION_QUESTID_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP = protobuf.Descriptor()
RUNQUESTSTEP_CMD_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP_PARAM_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP_QUESTID_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP_STARID_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP_SUBGROUP_FIELD = protobuf.FieldDescriptor()
RUNQUESTSTEP_STEP_FIELD = protobuf.FieldDescriptor()
QUESTTRACE = protobuf.Descriptor()
QUESTTRACE_CMD_FIELD = protobuf.FieldDescriptor()
QUESTTRACE_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTTRACE_QUESTID_FIELD = protobuf.FieldDescriptor()
QUESTTRACE_TRACE_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL = protobuf.Descriptor()
QUESTDETAIL_ID_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL_TIME_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL_MAP_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL_COMPLETE_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL_TRACE_FIELD = protobuf.FieldDescriptor()
QUESTDETAIL_DETAILS_FIELD = protobuf.FieldDescriptor()
QUESTDETAILLIST = protobuf.Descriptor()
QUESTDETAILLIST_CMD_FIELD = protobuf.FieldDescriptor()
QUESTDETAILLIST_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTDETAILLIST_DETAILS_FIELD = protobuf.FieldDescriptor()
QUESTDETAILUPDATE = protobuf.Descriptor()
QUESTDETAILUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
QUESTDETAILUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTDETAILUPDATE_DETAIL_FIELD = protobuf.FieldDescriptor()
QUESTDETAILUPDATE_DEL_FIELD = protobuf.FieldDescriptor()
QUESTRAIDCMD = protobuf.Descriptor()
QUESTRAIDCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUESTRAIDCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTRAIDCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
QUESTCANACCEPTLISTCHANGE = protobuf.Descriptor()
QUESTCANACCEPTLISTCHANGE_CMD_FIELD = protobuf.FieldDescriptor()
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD = protobuf.FieldDescriptor()
VISITNPCUSERCMD = protobuf.Descriptor()
VISITNPCUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
VISITNPCUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
VISITNPCUSERCMD_NPCTEMPID_FIELD = protobuf.FieldDescriptor()
VISITNPCUSERCMD_SYNC_SCENE_FIELD = protobuf.FieldDescriptor()
WORLDTREASURE = protobuf.Descriptor()
WORLDTREASURE_QUESTID_FIELD = protobuf.FieldDescriptor()
WORLDTREASURE_NPCID_FIELD = protobuf.FieldDescriptor()
WORLDTREASURE_POS_FIELD = protobuf.FieldDescriptor()
OTHERDATA = protobuf.Descriptor()
OTHERDATA_DATA_FIELD = protobuf.FieldDescriptor()
OTHERDATA_PARAM1_FIELD = protobuf.FieldDescriptor()
OTHERDATA_PARAM2_FIELD = protobuf.FieldDescriptor()
OTHERDATA_PARAM3_FIELD = protobuf.FieldDescriptor()
OTHERDATA_PARAM4_FIELD = protobuf.FieldDescriptor()
OTHERDATA_TREASURES_FIELD = protobuf.FieldDescriptor()
QUERYOTHERDATA = protobuf.Descriptor()
QUERYOTHERDATA_CMD_FIELD = protobuf.FieldDescriptor()
QUERYOTHERDATA_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYOTHERDATA_TYPE_FIELD = protobuf.FieldDescriptor()
QUERYOTHERDATA_DATA_FIELD = protobuf.FieldDescriptor()
QUERYWANTEDINFOQUESTCMD = protobuf.Descriptor()
QUERYWANTEDINFOQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD = protobuf.Descriptor()
INVITEHELPACCEPTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_TIME_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD = protobuf.FieldDescriptor()
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD = protobuf.Descriptor()
INVITEACCEPTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_LEADERID_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_TIME_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_SIGN_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD = protobuf.FieldDescriptor()
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD = protobuf.Descriptor()
REPLYHELPACCELPQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_TIME_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_SIGN_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_AGREE_FIELD = protobuf.FieldDescriptor()
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD = protobuf.FieldDescriptor()
WORLDQUEST = protobuf.Descriptor()
WORLDQUEST_MAPID_FIELD = protobuf.FieldDescriptor()
WORLDQUEST_TYPE_MAIN_FIELD = protobuf.FieldDescriptor()
WORLDQUEST_TYPE_BRANCH_FIELD = protobuf.FieldDescriptor()
WORLDQUEST_TYPE_DAILY_FIELD = protobuf.FieldDescriptor()
QUERYWORLDQUESTCMD = protobuf.Descriptor()
QUERYWORLDQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYWORLDQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYWORLDQUESTCMD_QUESTS_FIELD = protobuf.FieldDescriptor()
TRACE = protobuf.Descriptor()
TRACE_ID_FIELD = protobuf.FieldDescriptor()
TRACE_TRACE_FIELD = protobuf.FieldDescriptor()
QUESTGROUPTRACEQUESTCMD = protobuf.Descriptor()
QUESTGROUPTRACEQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD = protobuf.FieldDescriptor()
HELPQUICKFINISHBOARDQUESTCMD = protobuf.Descriptor()
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD = protobuf.FieldDescriptor()
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD = protobuf.FieldDescriptor()
QUERYQUESTLISTQUESTCMD = protobuf.Descriptor()
QUERYQUESTLISTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYQUESTLISTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYQUESTLISTQUESTCMD_MAPID_FIELD = protobuf.FieldDescriptor()
QUERYQUESTLISTQUESTCMD_DATAS_FIELD = protobuf.FieldDescriptor()
MAPSTEPSYNCCMD = protobuf.Descriptor()
MAPSTEPSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
MAPSTEPSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MAPSTEPSYNCCMD_STEPID_FIELD = protobuf.FieldDescriptor()
MAPSTEPUPDATECMD = protobuf.Descriptor()
MAPSTEPUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
MAPSTEPUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
MAPSTEPUPDATECMD_DEL_STEPID_FIELD = protobuf.FieldDescriptor()
MAPSTEPUPDATECMD_ADD_STEPID_FIELD = protobuf.FieldDescriptor()
MAPSTEPFINISHCMD = protobuf.Descriptor()
MAPSTEPFINISHCMD_CMD_FIELD = protobuf.FieldDescriptor()
MAPSTEPFINISHCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MAPSTEPFINISHCMD_STEPID_FIELD = protobuf.FieldDescriptor()
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD = protobuf.FieldDescriptor()
PLOTSTATUSNTF = protobuf.Descriptor()
PLOTSTATUSNTF_CMD_FIELD = protobuf.FieldDescriptor()
PLOTSTATUSNTF_PARAM_FIELD = protobuf.FieldDescriptor()
PLOTSTATUSNTF_ISSTART_FIELD = protobuf.FieldDescriptor()
PLOTSTATUSNTF_ID_FIELD = protobuf.FieldDescriptor()
QUESTAREAACTION = protobuf.Descriptor()
QUESTAREAACTION_CMD_FIELD = protobuf.FieldDescriptor()
QUESTAREAACTION_PARAM_FIELD = protobuf.FieldDescriptor()
QUESTAREAACTION_CONFIGID_FIELD = protobuf.FieldDescriptor()
BOTTLEDATA = protobuf.Descriptor()
BOTTLEDATA_BOTTLEID_FIELD = protobuf.FieldDescriptor()
BOTTLEDATA_STATUS_FIELD = protobuf.FieldDescriptor()
QUERYBOTTLEINFOQUESTCMD = protobuf.Descriptor()
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD = protobuf.FieldDescriptor()
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD = protobuf.FieldDescriptor()
BOTTLEACTIONQUESTCMD = protobuf.Descriptor()
BOTTLEACTIONQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
BOTTLEACTIONQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOTTLEACTIONQUESTCMD_ACTION_FIELD = protobuf.FieldDescriptor()
BOTTLEACTIONQUESTCMD_ID_FIELD = protobuf.FieldDescriptor()
BOTTLEUPDATEQUESTCMD = protobuf.Descriptor()
BOTTLEUPDATEQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
BOTTLEUPDATEQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOTTLEUPDATEQUESTCMD_STATUS_FIELD = protobuf.FieldDescriptor()
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD = protobuf.FieldDescriptor()
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD = protobuf.FieldDescriptor()
EVIDENCEDATA = protobuf.Descriptor()
EVIDENCEDATA_ID_FIELD = protobuf.FieldDescriptor()
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD = protobuf.FieldDescriptor()
EVIDENCEQUERYCMD = protobuf.Descriptor()
EVIDENCEQUERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
EVIDENCEQUERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EVIDENCEQUERYCMD_EVIDENCES_FIELD = protobuf.FieldDescriptor()
EVIDENCEQUERYCMD_NEXT_HINT_FIELD = protobuf.FieldDescriptor()
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD = protobuf.FieldDescriptor()
UNLOCKEVIDENCEMESSAGECMD = protobuf.Descriptor()
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD = protobuf.FieldDescriptor()
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD = protobuf.FieldDescriptor()
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD = protobuf.FieldDescriptor()
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD = protobuf.FieldDescriptor()
RELATIONDATA = protobuf.Descriptor()
RELATIONDATA_ID_FIELD = protobuf.FieldDescriptor()
RELATIONDATA_STATE_FIELD = protobuf.FieldDescriptor()
CHARACTERSECRET = protobuf.Descriptor()
CHARACTERSECRET_SECRET_ID_FIELD = protobuf.FieldDescriptor()
CHARACTERSECRET_LIGHTED_FIELD = protobuf.FieldDescriptor()
CHARACTERINFO = protobuf.Descriptor()
CHARACTERINFO_CHARACTER_ID_FIELD = protobuf.FieldDescriptor()
CHARACTERINFO_UNLOCK_SECRETS_FIELD = protobuf.FieldDescriptor()
QUERYCHARACTERINFOCMD = protobuf.Descriptor()
QUERYCHARACTERINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYCHARACTERINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD = protobuf.FieldDescriptor()
QUERYCHARACTERINFOCMD_RELATIONS_FIELD = protobuf.FieldDescriptor()
EVIDENCEHINTCMD = protobuf.Descriptor()
EVIDENCEHINTCMD_CMD_FIELD = protobuf.FieldDescriptor()
EVIDENCEHINTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
EVIDENCEHINTCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
EVIDENCEHINTCMD_NEXT_HINT_FIELD = protobuf.FieldDescriptor()
EVIDENCEHINTCMD_HINT_CD_FIELD = protobuf.FieldDescriptor()
ENLIGHTSECRETCMD = protobuf.Descriptor()
ENLIGHTSECRETCMD_CMD_FIELD = protobuf.FieldDescriptor()
ENLIGHTSECRETCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD = protobuf.FieldDescriptor()
ENLIGHTSECRETCMD_SECRET_ID_FIELD = protobuf.FieldDescriptor()
ENLIGHTSECRETCMD_SUCCESS_FIELD = protobuf.FieldDescriptor()
CLOSEUICMD = protobuf.Descriptor()
CLOSEUICMD_CMD_FIELD = protobuf.FieldDescriptor()
CLOSEUICMD_PARAM_FIELD = protobuf.FieldDescriptor()
CLOSEUICMD_QUESTID_FIELD = protobuf.FieldDescriptor()
CLOSEUICMD_RAID_STARID_FIELD = protobuf.FieldDescriptor()
NEWEVIDENCEUPDATECMD = protobuf.Descriptor()
NEWEVIDENCEUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
NEWEVIDENCEUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD = protobuf.FieldDescriptor()
LEAVEVISITNPCQUESTCMD = protobuf.Descriptor()
LEAVEVISITNPCQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
LEAVEVISITNPCQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD = protobuf.FieldDescriptor()
COMPLETEAVAILABLEQUERYQUESTCMD = protobuf.Descriptor()
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD = protobuf.FieldDescriptor()
WORLDFINISHCOUNT = protobuf.Descriptor()
WORLDFINISHCOUNT_GROUPID_FIELD = protobuf.FieldDescriptor()
WORLDFINISHCOUNT_COUNT_FIELD = protobuf.FieldDescriptor()
WORLDCOUNTLISTQUESTCMD = protobuf.Descriptor()
WORLDCOUNTLISTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
WORLDCOUNTLISTQUESTCMD_LIST_FIELD = protobuf.FieldDescriptor()
QUESTSTATUS = protobuf.Descriptor()
QUESTSTATUS_QUESTID_FIELD = protobuf.FieldDescriptor()
QUESTSTATUS_STATUS_FIELD = protobuf.FieldDescriptor()
HEROPREQUESTCONFIG = protobuf.Descriptor()
HEROPREQUESTCONFIG_QUESTID_FIELD = protobuf.FieldDescriptor()
HEROPREQUESTCONFIG_CONFIG_FIELD = protobuf.FieldDescriptor()
QUESTHERO = protobuf.Descriptor()
QUESTHERO_ID_FIELD = protobuf.FieldDescriptor()
QUESTHERO_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTHERO_FIRST_FIELD = protobuf.FieldDescriptor()
QUERYQUESTHEROQUESTCMD = protobuf.Descriptor()
QUERYQUESTHEROQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYQUESTHEROQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
SETQUESTSTATUSQUESTCMD = protobuf.Descriptor()
SETQUESTSTATUSQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
SETQUESTSTATUSQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SETQUESTSTATUSQUESTCMD_TRACES_FIELD = protobuf.FieldDescriptor()
SETQUESTSTATUSQUESTCMD_NEWS_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTHEROQUESTCMD = protobuf.Descriptor()
UPDATEQUESTHEROQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
QUESTSTORYITEM = protobuf.Descriptor()
QUESTSTORYITEM_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTSTORYITEM_CONFIG_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX = protobuf.Descriptor()
QUESTSTORYINDEX_INDEX_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_QUEST_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_INDEX_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_CUR_QUEST_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_PRE_QUEST_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_CUR_ITEM_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_PRE_ITEM_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_SUB_ITEM_FIELD = protobuf.FieldDescriptor()
QUESTSTORYINDEX_REWARDS_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTSTORYINDEXQUESTCMD = protobuf.Descriptor()
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD = protobuf.FieldDescriptor()
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD = protobuf.FieldDescriptor()
UPDATEONCEREWARDQUESTCMD = protobuf.Descriptor()
UPDATEONCEREWARDQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD = protobuf.FieldDescriptor()
SYNCTREASUREBOXNUMCMD = protobuf.Descriptor()
SYNCTREASUREBOXNUMCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTREASUREBOXNUMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTREASUREBOXNUMCMD_MAPID_FIELD = protobuf.FieldDescriptor()
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD = protobuf.FieldDescriptor()
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD = protobuf.Descriptor()
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD = protobuf.FieldDescriptor()
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD = protobuf.FieldDescriptor()
UPDATEABYSSHELPCOUNTQUESTCMD = protobuf.Descriptor()
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD = protobuf.FieldDescriptor()
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD = protobuf.FieldDescriptor()
ACTMISSIONREWARD = protobuf.Descriptor()
ACTMISSIONREWARD_ACTID_FIELD = protobuf.FieldDescriptor()
ACTMISSIONREWARD_INDEX_FIELD = protobuf.FieldDescriptor()
ACTMISSIONREWARD_STATUS_FIELD = protobuf.FieldDescriptor()
QUESTPARAM_QUESTPARAM_QUESTLIST_ENUM.name = "QUESTPARAM_QUESTLIST"
QUESTPARAM_QUESTPARAM_QUESTLIST_ENUM.index = 0
QUESTPARAM_QUESTPARAM_QUESTLIST_ENUM.number = 1
QUESTPARAM_QUESTPARAM_QUESTUPDATE_ENUM.name = "QUESTPARAM_QUESTUPDATE"
QUESTPARAM_QUESTPARAM_QUESTUPDATE_ENUM.index = 1
QUESTPARAM_QUESTPARAM_QUESTUPDATE_ENUM.number = 2
QUESTPARAM_QUESTPARAM_QUESTACTION_ENUM.name = "QUESTPARAM_QUESTACTION"
QUESTPARAM_QUESTPARAM_QUESTACTION_ENUM.index = 2
QUESTPARAM_QUESTPARAM_QUESTACTION_ENUM.number = 3
QUESTPARAM_QUESTPARAM_RUNQUESTSTEP_ENUM.name = "QUESTPARAM_RUNQUESTSTEP"
QUESTPARAM_QUESTPARAM_RUNQUESTSTEP_ENUM.index = 3
QUESTPARAM_QUESTPARAM_RUNQUESTSTEP_ENUM.number = 4
QUESTPARAM_QUESTPARAM_QUESTSTEPUPDATE_ENUM.name = "QUESTPARAM_QUESTSTEPUPDATE"
QUESTPARAM_QUESTPARAM_QUESTSTEPUPDATE_ENUM.index = 4
QUESTPARAM_QUESTPARAM_QUESTSTEPUPDATE_ENUM.number = 5
QUESTPARAM_QUESTPARAM_QUESTTRACE_ENUM.name = "QUESTPARAM_QUESTTRACE"
QUESTPARAM_QUESTPARAM_QUESTTRACE_ENUM.index = 5
QUESTPARAM_QUESTPARAM_QUESTTRACE_ENUM.number = 6
QUESTPARAM_QUESTPARAM_QUESTDETAILLIST_ENUM.name = "QUESTPARAM_QUESTDETAILLIST"
QUESTPARAM_QUESTPARAM_QUESTDETAILLIST_ENUM.index = 6
QUESTPARAM_QUESTPARAM_QUESTDETAILLIST_ENUM.number = 7
QUESTPARAM_QUESTPARAM_QUESTDETAILUPDATE_ENUM.name = "QUESTPARAM_QUESTDETAILUPDATE"
QUESTPARAM_QUESTPARAM_QUESTDETAILUPDATE_ENUM.index = 7
QUESTPARAM_QUESTPARAM_QUESTDETAILUPDATE_ENUM.number = 8
QUESTPARAM_QUESTPARAM_QUESTRAIDCMD_ENUM.name = "QUESTPARAM_QUESTRAIDCMD"
QUESTPARAM_QUESTPARAM_QUESTRAIDCMD_ENUM.index = 8
QUESTPARAM_QUESTPARAM_QUESTRAIDCMD_ENUM.number = 9
QUESTPARAM_QUESTPARAM_CANACCEPTLISTCHANGED_ENUM.name = "QUESTPARAM_CANACCEPTLISTCHANGED"
QUESTPARAM_QUESTPARAM_CANACCEPTLISTCHANGED_ENUM.index = 9
QUESTPARAM_QUESTPARAM_CANACCEPTLISTCHANGED_ENUM.number = 10
QUESTPARAM_QUESTPARAM_VISIT_NPC_ENUM.name = "QUESTPARAM_VISIT_NPC"
QUESTPARAM_QUESTPARAM_VISIT_NPC_ENUM.index = 10
QUESTPARAM_QUESTPARAM_VISIT_NPC_ENUM.number = 11
QUESTPARAM_QUESTPARAM_QUERYOTHERDATA_ENUM.name = "QUESTPARAM_QUERYOTHERDATA"
QUESTPARAM_QUESTPARAM_QUERYOTHERDATA_ENUM.index = 11
QUESTPARAM_QUESTPARAM_QUERYOTHERDATA_ENUM.number = 12
QUESTPARAM_QUESTPARAM_QUERYWANTEDINFO_ENUM.name = "QUESTPARAM_QUERYWANTEDINFO"
QUESTPARAM_QUESTPARAM_QUERYWANTEDINFO_ENUM.index = 12
QUESTPARAM_QUESTPARAM_QUERYWANTEDINFO_ENUM.number = 13
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_INVITE_ENUM.name = "QUESTPARAM_HELP_ACCEPT_INVITE"
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_INVITE_ENUM.index = 13
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_INVITE_ENUM.number = 14
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_AGREE_ENUM.name = "QUESTPARAM_HELP_ACCEPT_AGREE"
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_AGREE_ENUM.index = 14
QUESTPARAM_QUESTPARAM_HELP_ACCEPT_AGREE_ENUM.number = 15
QUESTPARAM_QUESTPARAM_INVITE_ACCEPT_QUEST_ENUM.name = "QUESTPARAM_INVITE_ACCEPT_QUEST"
QUESTPARAM_QUESTPARAM_INVITE_ACCEPT_QUEST_ENUM.index = 15
QUESTPARAM_QUESTPARAM_INVITE_ACCEPT_QUEST_ENUM.number = 16
QUESTPARAM_QUESTPARAM_QUERY_WORLD_QUEST_ENUM.name = "QUESTPARAM_QUERY_WORLD_QUEST"
QUESTPARAM_QUESTPARAM_QUERY_WORLD_QUEST_ENUM.index = 16
QUESTPARAM_QUESTPARAM_QUERY_WORLD_QUEST_ENUM.number = 17
QUESTPARAM_QUESTPARAM_QUESTGROUP_TRACE_ENUM.name = "QUESTPARAM_QUESTGROUP_TRACE"
QUESTPARAM_QUESTPARAM_QUESTGROUP_TRACE_ENUM.index = 17
QUESTPARAM_QUESTPARAM_QUESTGROUP_TRACE_ENUM.number = 18
QUESTPARAM_QUESTPARAM_HELP_QUICK_FINISH_BOARD_ENUM.name = "QUESTPARAM_HELP_QUICK_FINISH_BOARD"
QUESTPARAM_QUESTPARAM_HELP_QUICK_FINISH_BOARD_ENUM.index = 18
QUESTPARAM_QUESTPARAM_HELP_QUICK_FINISH_BOARD_ENUM.number = 19
QUESTPARAM_QUESTPARAM_QUERY_QUESTLIST_ENUM.name = "QUESTPARAM_QUERY_QUESTLIST"
QUESTPARAM_QUESTPARAM_QUERY_QUESTLIST_ENUM.index = 19
QUESTPARAM_QUESTPARAM_QUERY_QUESTLIST_ENUM.number = 24
QUESTPARAM_QUESTPARAM_MAPSTEP_SYNC_ENUM.name = "QUESTPARAM_MAPSTEP_SYNC"
QUESTPARAM_QUESTPARAM_MAPSTEP_SYNC_ENUM.index = 20
QUESTPARAM_QUESTPARAM_MAPSTEP_SYNC_ENUM.number = 25
QUESTPARAM_QUESTPARAM_MAPSTEP_UPDATE_ENUM.name = "QUESTPARAM_MAPSTEP_UPDATE"
QUESTPARAM_QUESTPARAM_MAPSTEP_UPDATE_ENUM.index = 21
QUESTPARAM_QUESTPARAM_MAPSTEP_UPDATE_ENUM.number = 26
QUESTPARAM_QUESTPARAM_MAPSTEP_FINISH_ENUM.name = "QUESTPARAM_MAPSTEP_FINISH"
QUESTPARAM_QUESTPARAM_MAPSTEP_FINISH_ENUM.index = 22
QUESTPARAM_QUESTPARAM_MAPSTEP_FINISH_ENUM.number = 27
QUESTPARAM_QUESTPARAM_AREA_ACTION_ENUM.name = "QUESTPARAM_AREA_ACTION"
QUESTPARAM_QUESTPARAM_AREA_ACTION_ENUM.index = 23
QUESTPARAM_QUESTPARAM_AREA_ACTION_ENUM.number = 28
QUESTPARAM_QUESTPARAM_PLOT_STATUS_NTF_ENUM.name = "QUESTPARAM_PLOT_STATUS_NTF"
QUESTPARAM_QUESTPARAM_PLOT_STATUS_NTF_ENUM.index = 24
QUESTPARAM_QUESTPARAM_PLOT_STATUS_NTF_ENUM.number = 29
QUESTPARAM_QUESTPARAM_BOTTLE_QUERY_ENUM.name = "QUESTPARAM_BOTTLE_QUERY"
QUESTPARAM_QUESTPARAM_BOTTLE_QUERY_ENUM.index = 25
QUESTPARAM_QUESTPARAM_BOTTLE_QUERY_ENUM.number = 30
QUESTPARAM_QUESTPARAM_BOTTLE_ACTION_ENUM.name = "QUESTPARAM_BOTTLE_ACTION"
QUESTPARAM_QUESTPARAM_BOTTLE_ACTION_ENUM.index = 26
QUESTPARAM_QUESTPARAM_BOTTLE_ACTION_ENUM.number = 31
QUESTPARAM_QUESTPARAM_BOTTLE_UPDATE_ENUM.name = "QUESTPARAM_BOTTLE_UPDATE"
QUESTPARAM_QUESTPARAM_BOTTLE_UPDATE_ENUM.index = 27
QUESTPARAM_QUESTPARAM_BOTTLE_UPDATE_ENUM.number = 32
QUESTPARAM_QUESTPARAM_EVIDENCE_QUERY_ENUM.name = "QUESTPARAM_EVIDENCE_QUERY"
QUESTPARAM_QUESTPARAM_EVIDENCE_QUERY_ENUM.index = 28
QUESTPARAM_QUESTPARAM_EVIDENCE_QUERY_ENUM.number = 33
QUESTPARAM_QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE_ENUM.name = "QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE"
QUESTPARAM_QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE_ENUM.index = 29
QUESTPARAM_QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE_ENUM.number = 34
QUESTPARAM_QUESTPARAM_QUERY_CHARACTER_INFO_ENUM.name = "QUESTPARAM_QUERY_CHARACTER_INFO"
QUESTPARAM_QUESTPARAM_QUERY_CHARACTER_INFO_ENUM.index = 30
QUESTPARAM_QUESTPARAM_QUERY_CHARACTER_INFO_ENUM.number = 35
QUESTPARAM_QUESTPARAM_EVIDENCE_HINT_ENUM.name = "QUESTPARAM_EVIDENCE_HINT"
QUESTPARAM_QUESTPARAM_EVIDENCE_HINT_ENUM.index = 31
QUESTPARAM_QUESTPARAM_EVIDENCE_HINT_ENUM.number = 37
QUESTPARAM_QUESTPARAM_ENLIGHT_SECRET_ENUM.name = "QUESTPARAM_ENLIGHT_SECRET"
QUESTPARAM_QUESTPARAM_ENLIGHT_SECRET_ENUM.index = 32
QUESTPARAM_QUESTPARAM_ENLIGHT_SECRET_ENUM.number = 38
QUESTPARAM_QUESTPARAM_CLOSE_UI_ENUM.name = "QUESTPARAM_CLOSE_UI"
QUESTPARAM_QUESTPARAM_CLOSE_UI_ENUM.index = 33
QUESTPARAM_QUESTPARAM_CLOSE_UI_ENUM.number = 39
QUESTPARAM_QUESTPARAM_NEW_EVIDENCE_UPDATE_ENUM.name = "QUESTPARAM_NEW_EVIDENCE_UPDATE"
QUESTPARAM_QUESTPARAM_NEW_EVIDENCE_UPDATE_ENUM.index = 34
QUESTPARAM_QUESTPARAM_NEW_EVIDENCE_UPDATE_ENUM.number = 40
QUESTPARAM_QUESTPARAM_LEAVE_VISIT_NPC_ENUM.name = "QUESTPARAM_LEAVE_VISIT_NPC"
QUESTPARAM_QUESTPARAM_LEAVE_VISIT_NPC_ENUM.index = 35
QUESTPARAM_QUESTPARAM_LEAVE_VISIT_NPC_ENUM.number = 41
QUESTPARAM_QUESTPARAM_COMPLETE_AVAILABLE_QUERY_ENUM.name = "QUESTPARAM_COMPLETE_AVAILABLE_QUERY"
QUESTPARAM_QUESTPARAM_COMPLETE_AVAILABLE_QUERY_ENUM.index = 36
QUESTPARAM_QUESTPARAM_COMPLETE_AVAILABLE_QUERY_ENUM.number = 42
QUESTPARAM_QUESTPARAM_WORLD_COUNT_LIST_ENUM.name = "QUESTPARAM_WORLD_COUNT_LIST"
QUESTPARAM_QUESTPARAM_WORLD_COUNT_LIST_ENUM.index = 37
QUESTPARAM_QUESTPARAM_WORLD_COUNT_LIST_ENUM.number = 43
QUESTPARAM_QUESTPARAM_TRACE_LIST_ENUM.name = "QUESTPARAM_TRACE_LIST"
QUESTPARAM_QUESTPARAM_TRACE_LIST_ENUM.index = 38
QUESTPARAM_QUESTPARAM_TRACE_LIST_ENUM.number = 44
QUESTPARAM_QUESTPARAM_TRACE_UPDATE_ENUM.name = "QUESTPARAM_TRACE_UPDATE"
QUESTPARAM_QUESTPARAM_TRACE_UPDATE_ENUM.index = 39
QUESTPARAM_QUESTPARAM_TRACE_UPDATE_ENUM.number = 45
QUESTPARAM_QUESTPARAM_NEW_LIST_ENUM.name = "QUESTPARAM_NEW_LIST"
QUESTPARAM_QUESTPARAM_NEW_LIST_ENUM.index = 40
QUESTPARAM_QUESTPARAM_NEW_LIST_ENUM.number = 46
QUESTPARAM_QUESTPARAM_NEW_UPDATE_ENUM.name = "QUESTPARAM_NEW_UPDATE"
QUESTPARAM_QUESTPARAM_NEW_UPDATE_ENUM.index = 41
QUESTPARAM_QUESTPARAM_NEW_UPDATE_ENUM.number = 47
QUESTPARAM_QUESTPARAM_QUESTHERO_QUERY_ENUM.name = "QUESTPARAM_QUESTHERO_QUERY"
QUESTPARAM_QUESTPARAM_QUESTHERO_QUERY_ENUM.index = 42
QUESTPARAM_QUESTPARAM_QUESTHERO_QUERY_ENUM.number = 48
QUESTPARAM_QUESTPARAM_QUESTHERO_UPDATE_ENUM.name = "QUESTPARAM_QUESTHERO_UPDATE"
QUESTPARAM_QUESTPARAM_QUESTHERO_UPDATE_ENUM.index = 43
QUESTPARAM_QUESTPARAM_QUESTHERO_UPDATE_ENUM.number = 49
QUESTPARAM_QUESTPARAM_STATUS_SET_ENUM.name = "QUESTPARAM_STATUS_SET"
QUESTPARAM_QUESTPARAM_STATUS_SET_ENUM.index = 44
QUESTPARAM_QUESTPARAM_STATUS_SET_ENUM.number = 50
QUESTPARAM_QUESTPARAM_STORY_INDEX_UPDATE_ENUM.name = "QUESTPARAM_STORY_INDEX_UPDATE"
QUESTPARAM_QUESTPARAM_STORY_INDEX_UPDATE_ENUM.index = 45
QUESTPARAM_QUESTPARAM_STORY_INDEX_UPDATE_ENUM.number = 51
QUESTPARAM_QUESTPARAM_ONCE_REWARD_UPDATE_ENUM.name = "QUESTPARAM_ONCE_REWARD_UPDATE"
QUESTPARAM_QUESTPARAM_ONCE_REWARD_UPDATE_ENUM.index = 46
QUESTPARAM_QUESTPARAM_ONCE_REWARD_UPDATE_ENUM.number = 52
QUESTPARAM_QUESTPARAM_SYNC_TREASURE_BOX_NUM_ENUM.name = "QUESTPARAM_SYNC_TREASURE_BOX_NUM"
QUESTPARAM_QUESTPARAM_SYNC_TREASURE_BOX_NUM_ENUM.index = 47
QUESTPARAM_QUESTPARAM_SYNC_TREASURE_BOX_NUM_ENUM.number = 53
QUESTPARAM_QUESTPARAM_QUERY_ABYSS_LIST_ENUM.name = "QUESTPARAM_QUERY_ABYSS_LIST"
QUESTPARAM_QUESTPARAM_QUERY_ABYSS_LIST_ENUM.index = 48
QUESTPARAM_QUESTPARAM_QUERY_ABYSS_LIST_ENUM.number = 54
QUESTPARAM_QUESTPARAM_UPDATE_ABYSS_HELPCOUNT_ENUM.name = "QUESTPARAM_UPDATE_ABYSS_HELPCOUNT"
QUESTPARAM_QUESTPARAM_UPDATE_ABYSS_HELPCOUNT_ENUM.index = 49
QUESTPARAM_QUESTPARAM_UPDATE_ABYSS_HELPCOUNT_ENUM.number = 55
QUESTPARAM.name = "QuestParam"
QUESTPARAM.full_name = ".Cmd.QuestParam"
QUESTPARAM.values = {
  QUESTPARAM_QUESTPARAM_QUESTLIST_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTUPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTACTION_ENUM,
  QUESTPARAM_QUESTPARAM_RUNQUESTSTEP_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTSTEPUPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTTRACE_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTDETAILLIST_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTDETAILUPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTRAIDCMD_ENUM,
  QUESTPARAM_QUESTPARAM_CANACCEPTLISTCHANGED_ENUM,
  QUESTPARAM_QUESTPARAM_VISIT_NPC_ENUM,
  QUESTPARAM_QUESTPARAM_QUERYOTHERDATA_ENUM,
  QUESTPARAM_QUESTPARAM_QUERYWANTEDINFO_ENUM,
  QUESTPARAM_QUESTPARAM_HELP_ACCEPT_INVITE_ENUM,
  QUESTPARAM_QUESTPARAM_HELP_ACCEPT_AGREE_ENUM,
  QUESTPARAM_QUESTPARAM_INVITE_ACCEPT_QUEST_ENUM,
  QUESTPARAM_QUESTPARAM_QUERY_WORLD_QUEST_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTGROUP_TRACE_ENUM,
  QUESTPARAM_QUESTPARAM_HELP_QUICK_FINISH_BOARD_ENUM,
  QUESTPARAM_QUESTPARAM_QUERY_QUESTLIST_ENUM,
  QUESTPARAM_QUESTPARAM_MAPSTEP_SYNC_ENUM,
  QUESTPARAM_QUESTPARAM_MAPSTEP_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_MAPSTEP_FINISH_ENUM,
  QUESTPARAM_QUESTPARAM_AREA_ACTION_ENUM,
  QUESTPARAM_QUESTPARAM_PLOT_STATUS_NTF_ENUM,
  QUESTPARAM_QUESTPARAM_BOTTLE_QUERY_ENUM,
  QUESTPARAM_QUESTPARAM_BOTTLE_ACTION_ENUM,
  QUESTPARAM_QUESTPARAM_BOTTLE_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_EVIDENCE_QUERY_ENUM,
  QUESTPARAM_QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE_ENUM,
  QUESTPARAM_QUESTPARAM_QUERY_CHARACTER_INFO_ENUM,
  QUESTPARAM_QUESTPARAM_EVIDENCE_HINT_ENUM,
  QUESTPARAM_QUESTPARAM_ENLIGHT_SECRET_ENUM,
  QUESTPARAM_QUESTPARAM_CLOSE_UI_ENUM,
  QUESTPARAM_QUESTPARAM_NEW_EVIDENCE_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_LEAVE_VISIT_NPC_ENUM,
  QUESTPARAM_QUESTPARAM_COMPLETE_AVAILABLE_QUERY_ENUM,
  QUESTPARAM_QUESTPARAM_WORLD_COUNT_LIST_ENUM,
  QUESTPARAM_QUESTPARAM_TRACE_LIST_ENUM,
  QUESTPARAM_QUESTPARAM_TRACE_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_NEW_LIST_ENUM,
  QUESTPARAM_QUESTPARAM_NEW_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTHERO_QUERY_ENUM,
  QUESTPARAM_QUESTPARAM_QUESTHERO_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_STATUS_SET_ENUM,
  QUESTPARAM_QUESTPARAM_STORY_INDEX_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_ONCE_REWARD_UPDATE_ENUM,
  QUESTPARAM_QUESTPARAM_SYNC_TREASURE_BOX_NUM_ENUM,
  QUESTPARAM_QUESTPARAM_QUERY_ABYSS_LIST_ENUM,
  QUESTPARAM_QUESTPARAM_UPDATE_ABYSS_HELPCOUNT_ENUM
}
EWANTEDTYPE_EWANTEDTYPE_TOTAL_ENUM.name = "EWANTEDTYPE_TOTAL"
EWANTEDTYPE_EWANTEDTYPE_TOTAL_ENUM.index = 0
EWANTEDTYPE_EWANTEDTYPE_TOTAL_ENUM.number = 0
EWANTEDTYPE_EWANTEDTYPE_ACTIVE_ENUM.name = "EWANTEDTYPE_ACTIVE"
EWANTEDTYPE_EWANTEDTYPE_ACTIVE_ENUM.index = 1
EWANTEDTYPE_EWANTEDTYPE_ACTIVE_ENUM.number = 1
EWANTEDTYPE_EWANTEDTYPE_DAY_ENUM.name = "EWANTEDTYPE_DAY"
EWANTEDTYPE_EWANTEDTYPE_DAY_ENUM.index = 2
EWANTEDTYPE_EWANTEDTYPE_DAY_ENUM.number = 2
EWANTEDTYPE_EWANTEDTYPE_WEEK_ENUM.name = "EWANTEDTYPE_WEEK"
EWANTEDTYPE_EWANTEDTYPE_WEEK_ENUM.index = 3
EWANTEDTYPE_EWANTEDTYPE_WEEK_ENUM.number = 3
EWANTEDTYPE_EWANTEDTYPE_MAX_ENUM.name = "EWANTEDTYPE_MAX"
EWANTEDTYPE_EWANTEDTYPE_MAX_ENUM.index = 4
EWANTEDTYPE_EWANTEDTYPE_MAX_ENUM.number = 4
EWANTEDTYPE.name = "EWantedType"
EWANTEDTYPE.full_name = ".Cmd.EWantedType"
EWANTEDTYPE.values = {
  EWANTEDTYPE_EWANTEDTYPE_TOTAL_ENUM,
  EWANTEDTYPE_EWANTEDTYPE_ACTIVE_ENUM,
  EWANTEDTYPE_EWANTEDTYPE_DAY_ENUM,
  EWANTEDTYPE_EWANTEDTYPE_WEEK_ENUM,
  EWANTEDTYPE_EWANTEDTYPE_MAX_ENUM
}
EQUESTTYPE_EQUESTTYPE_MIN_ENUM.name = "EQUESTTYPE_MIN"
EQUESTTYPE_EQUESTTYPE_MIN_ENUM.index = 0
EQUESTTYPE_EQUESTTYPE_MIN_ENUM.number = 0
EQUESTTYPE_EQUESTTYPE_MAIN_ENUM.name = "EQUESTTYPE_MAIN"
EQUESTTYPE_EQUESTTYPE_MAIN_ENUM.index = 1
EQUESTTYPE_EQUESTTYPE_MAIN_ENUM.number = 1
EQUESTTYPE_EQUESTTYPE_BRANCH_ENUM.name = "EQUESTTYPE_BRANCH"
EQUESTTYPE_EQUESTTYPE_BRANCH_ENUM.index = 2
EQUESTTYPE_EQUESTTYPE_BRANCH_ENUM.number = 2
EQUESTTYPE_EQUESTTYPE_TALK_ENUM.name = "EQUESTTYPE_TALK"
EQUESTTYPE_EQUESTTYPE_TALK_ENUM.index = 3
EQUESTTYPE_EQUESTTYPE_TALK_ENUM.number = 3
EQUESTTYPE_EQUESTTYPE_TRIGGER_ENUM.name = "EQUESTTYPE_TRIGGER"
EQUESTTYPE_EQUESTTYPE_TRIGGER_ENUM.index = 4
EQUESTTYPE_EQUESTTYPE_TRIGGER_ENUM.number = 4
EQUESTTYPE_EQUESTTYPE_WANTED_ENUM.name = "EQUESTTYPE_WANTED"
EQUESTTYPE_EQUESTTYPE_WANTED_ENUM.index = 5
EQUESTTYPE_EQUESTTYPE_WANTED_ENUM.number = 5
EQUESTTYPE_EQUESTTYPE_DAILY_ENUM.name = "EQUESTTYPE_DAILY"
EQUESTTYPE_EQUESTTYPE_DAILY_ENUM.index = 6
EQUESTTYPE_EQUESTTYPE_DAILY_ENUM.number = 6
EQUESTTYPE_EQUESTTYPE_DAILY_1_ENUM.name = "EQUESTTYPE_DAILY_1"
EQUESTTYPE_EQUESTTYPE_DAILY_1_ENUM.index = 7
EQUESTTYPE_EQUESTTYPE_DAILY_1_ENUM.number = 7
EQUESTTYPE_EQUESTTYPE_DAILY_3_ENUM.name = "EQUESTTYPE_DAILY_3"
EQUESTTYPE_EQUESTTYPE_DAILY_3_ENUM.index = 8
EQUESTTYPE_EQUESTTYPE_DAILY_3_ENUM.number = 8
EQUESTTYPE_EQUESTTYPE_DAILY_7_ENUM.name = "EQUESTTYPE_DAILY_7"
EQUESTTYPE_EQUESTTYPE_DAILY_7_ENUM.index = 9
EQUESTTYPE_EQUESTTYPE_DAILY_7_ENUM.number = 9
EQUESTTYPE_EQUESTTYPE_STORY_ENUM.name = "EQUESTTYPE_STORY"
EQUESTTYPE_EQUESTTYPE_STORY_ENUM.index = 10
EQUESTTYPE_EQUESTTYPE_STORY_ENUM.number = 10
EQUESTTYPE_EQUESTTYPE_DAILY_MAP_ENUM.name = "EQUESTTYPE_DAILY_MAP"
EQUESTTYPE_EQUESTTYPE_DAILY_MAP_ENUM.index = 11
EQUESTTYPE_EQUESTTYPE_DAILY_MAP_ENUM.number = 11
EQUESTTYPE_EQUESTTYPE_SCENE_ENUM.name = "EQUESTTYPE_SCENE"
EQUESTTYPE_EQUESTTYPE_SCENE_ENUM.index = 12
EQUESTTYPE_EQUESTTYPE_SCENE_ENUM.number = 12
EQUESTTYPE_EQUESTTYPE_HEAD_ENUM.name = "EQUESTTYPE_HEAD"
EQUESTTYPE_EQUESTTYPE_HEAD_ENUM.index = 13
EQUESTTYPE_EQUESTTYPE_HEAD_ENUM.number = 13
EQUESTTYPE_EQUESTTYPE_RAIDTALK_ENUM.name = "EQUESTTYPE_RAIDTALK"
EQUESTTYPE_EQUESTTYPE_RAIDTALK_ENUM.index = 14
EQUESTTYPE_EQUESTTYPE_RAIDTALK_ENUM.number = 14
EQUESTTYPE_EQUESTTYPE_SATISFACTION_ENUM.name = "EQUESTTYPE_SATISFACTION"
EQUESTTYPE_EQUESTTYPE_SATISFACTION_ENUM.index = 15
EQUESTTYPE_EQUESTTYPE_SATISFACTION_ENUM.number = 15
EQUESTTYPE_EQUESTTYPE_ELITE_ENUM.name = "EQUESTTYPE_ELITE"
EQUESTTYPE_EQUESTTYPE_ELITE_ENUM.index = 16
EQUESTTYPE_EQUESTTYPE_ELITE_ENUM.number = 16
EQUESTTYPE_EQUESTTYPE_CCRASTEHAM_ENUM.name = "EQUESTTYPE_CCRASTEHAM"
EQUESTTYPE_EQUESTTYPE_CCRASTEHAM_ENUM.index = 17
EQUESTTYPE_EQUESTTYPE_CCRASTEHAM_ENUM.number = 17
EQUESTTYPE_EQUESTTYPE_STORY_CCRASTEHAM_ENUM.name = "EQUESTTYPE_STORY_CCRASTEHAM"
EQUESTTYPE_EQUESTTYPE_STORY_CCRASTEHAM_ENUM.index = 18
EQUESTTYPE_EQUESTTYPE_STORY_CCRASTEHAM_ENUM.number = 18
EQUESTTYPE_EQUESTTYPE_GUILD_ENUM.name = "EQUESTTYPE_GUILD"
EQUESTTYPE_EQUESTTYPE_GUILD_ENUM.index = 19
EQUESTTYPE_EQUESTTYPE_GUILD_ENUM.number = 19
EQUESTTYPE_EQUESTTYPE_CHILD_ENUM.name = "EQUESTTYPE_CHILD"
EQUESTTYPE_EQUESTTYPE_CHILD_ENUM.index = 20
EQUESTTYPE_EQUESTTYPE_CHILD_ENUM.number = 20
EQUESTTYPE_EQUESTTYPE_DAILY_RESET_ENUM.name = "EQUESTTYPE_DAILY_RESET"
EQUESTTYPE_EQUESTTYPE_DAILY_RESET_ENUM.index = 21
EQUESTTYPE_EQUESTTYPE_DAILY_RESET_ENUM.number = 21
EQUESTTYPE_EQUESTTYPE_ACC_ENUM.name = "EQUESTTYPE_ACC"
EQUESTTYPE_EQUESTTYPE_ACC_ENUM.index = 22
EQUESTTYPE_EQUESTTYPE_ACC_ENUM.number = 22
EQUESTTYPE_EQUESTTYPE_ACC_NORMAL_ENUM.name = "EQUESTTYPE_ACC_NORMAL"
EQUESTTYPE_EQUESTTYPE_ACC_NORMAL_ENUM.index = 23
EQUESTTYPE_EQUESTTYPE_ACC_NORMAL_ENUM.number = 23
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_ENUM.name = "EQUESTTYPE_ACC_DAILY"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_ENUM.index = 24
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_ENUM.number = 24
EQUESTTYPE_EQUESTTYPE_ACC_CHOICE_ENUM.name = "EQUESTTYPE_ACC_CHOICE"
EQUESTTYPE_EQUESTTYPE_ACC_CHOICE_ENUM.index = 25
EQUESTTYPE_EQUESTTYPE_ACC_CHOICE_ENUM.number = 25
EQUESTTYPE_EQUESTTYPE_DAILY_MAPRAND_ENUM.name = "EQUESTTYPE_DAILY_MAPRAND"
EQUESTTYPE_EQUESTTYPE_DAILY_MAPRAND_ENUM.index = 26
EQUESTTYPE_EQUESTTYPE_DAILY_MAPRAND_ENUM.number = 26
EQUESTTYPE_EQUESTTYPE_ACC_MAIN_ENUM.name = "EQUESTTYPE_ACC_MAIN"
EQUESTTYPE_EQUESTTYPE_ACC_MAIN_ENUM.index = 27
EQUESTTYPE_EQUESTTYPE_ACC_MAIN_ENUM.number = 27
EQUESTTYPE_EQUESTTYPE_ACC_BRANCH_ENUM.name = "EQUESTTYPE_ACC_BRANCH"
EQUESTTYPE_EQUESTTYPE_ACC_BRANCH_ENUM.index = 28
EQUESTTYPE_EQUESTTYPE_ACC_BRANCH_ENUM.number = 28
EQUESTTYPE_EQUESTTYPE_ACC_SATISFACTION_ENUM.name = "EQUESTTYPE_ACC_SATISFACTION"
EQUESTTYPE_EQUESTTYPE_ACC_SATISFACTION_ENUM.index = 29
EQUESTTYPE_EQUESTTYPE_ACC_SATISFACTION_ENUM.number = 29
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_1_ENUM.name = "EQUESTTYPE_ACC_DAILY_1"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_1_ENUM.index = 30
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_1_ENUM.number = 30
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_3_ENUM.name = "EQUESTTYPE_ACC_DAILY_3"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_3_ENUM.index = 31
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_3_ENUM.number = 31
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_7_ENUM.name = "EQUESTTYPE_ACC_DAILY_7"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_7_ENUM.index = 32
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_7_ENUM.number = 32
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_RESET_ENUM.name = "EQUESTTYPE_ACC_DAILY_RESET"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_RESET_ENUM.index = 33
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_RESET_ENUM.number = 33
EQUESTTYPE_EQUESTTYPE_DAILY_BOX_ENUM.name = "EQUESTTYPE_DAILY_BOX"
EQUESTTYPE_EQUESTTYPE_DAILY_BOX_ENUM.index = 34
EQUESTTYPE_EQUESTTYPE_DAILY_BOX_ENUM.number = 34
EQUESTTYPE_EQUESTTYPE_SIGN_ENUM.name = "EQUESTTYPE_SIGN"
EQUESTTYPE_EQUESTTYPE_SIGN_ENUM.index = 35
EQUESTTYPE_EQUESTTYPE_SIGN_ENUM.number = 35
EQUESTTYPE_EQUESTTYPE_DAY_ENUM.name = "EQUESTTYPE_DAY"
EQUESTTYPE_EQUESTTYPE_DAY_ENUM.index = 36
EQUESTTYPE_EQUESTTYPE_DAY_ENUM.number = 36
EQUESTTYPE_EQUESTTYPE_NIGHT_ENUM.name = "EQUESTTYPE_NIGHT"
EQUESTTYPE_EQUESTTYPE_NIGHT_ENUM.index = 37
EQUESTTYPE_EQUESTTYPE_NIGHT_ENUM.number = 37
EQUESTTYPE_EQUESTTYPE_ARTIFACT_ENUM.name = "EQUESTTYPE_ARTIFACT"
EQUESTTYPE_EQUESTTYPE_ARTIFACT_ENUM.index = 38
EQUESTTYPE_EQUESTTYPE_ARTIFACT_ENUM.number = 38
EQUESTTYPE_EQUESTTYPE_WEDDING_ENUM.name = "EQUESTTYPE_WEDDING"
EQUESTTYPE_EQUESTTYPE_WEDDING_ENUM.index = 39
EQUESTTYPE_EQUESTTYPE_WEDDING_ENUM.number = 39
EQUESTTYPE_EQUESTTYPE_WEDDING_DAILY_ENUM.name = "EQUESTTYPE_WEDDING_DAILY"
EQUESTTYPE_EQUESTTYPE_WEDDING_DAILY_ENUM.index = 40
EQUESTTYPE_EQUESTTYPE_WEDDING_DAILY_ENUM.number = 40
EQUESTTYPE_EQUESTTYPE_CAPRA_ENUM.name = "EQUESTTYPE_CAPRA"
EQUESTTYPE_EQUESTTYPE_CAPRA_ENUM.index = 41
EQUESTTYPE_EQUESTTYPE_CAPRA_ENUM.number = 41
EQUESTTYPE_EQUESTTYPE_DEAD_ENUM.name = "EQUESTTYPE_DEAD"
EQUESTTYPE_EQUESTTYPE_DEAD_ENUM.index = 42
EQUESTTYPE_EQUESTTYPE_DEAD_ENUM.number = 42
EQUESTTYPE_EQUESTTYPE_ACC_1_ENUM.name = "EQUESTTYPE_ACC_1"
EQUESTTYPE_EQUESTTYPE_ACC_1_ENUM.index = 43
EQUESTTYPE_EQUESTTYPE_ACC_1_ENUM.number = 43
EQUESTTYPE_EQUESTTYPE_ACC_2_ENUM.name = "EQUESTTYPE_ACC_2"
EQUESTTYPE_EQUESTTYPE_ACC_2_ENUM.index = 44
EQUESTTYPE_EQUESTTYPE_ACC_2_ENUM.number = 44
EQUESTTYPE_EQUESTTYPE_ACC_3_ENUM.name = "EQUESTTYPE_ACC_3"
EQUESTTYPE_EQUESTTYPE_ACC_3_ENUM.index = 45
EQUESTTYPE_EQUESTTYPE_ACC_3_ENUM.number = 45
EQUESTTYPE_EQUESTTYPE_ACC_4_ENUM.name = "EQUESTTYPE_ACC_4"
EQUESTTYPE_EQUESTTYPE_ACC_4_ENUM.index = 46
EQUESTTYPE_EQUESTTYPE_ACC_4_ENUM.number = 46
EQUESTTYPE_EQUESTTYPE_VERSION_ENUM.name = "EQUESTTYPE_VERSION"
EQUESTTYPE_EQUESTTYPE_VERSION_ENUM.index = 47
EQUESTTYPE_EQUESTTYPE_VERSION_ENUM.number = 47
EQUESTTYPE_EQUESTTYPE_WANTED_DAY_ENUM.name = "EQUESTTYPE_WANTED_DAY"
EQUESTTYPE_EQUESTTYPE_WANTED_DAY_ENUM.index = 48
EQUESTTYPE_EQUESTTYPE_WANTED_DAY_ENUM.number = 48
EQUESTTYPE_EQUESTTYPE_WANTED_WEEK_ENUM.name = "EQUESTTYPE_WANTED_WEEK"
EQUESTTYPE_EQUESTTYPE_WANTED_WEEK_ENUM.index = 49
EQUESTTYPE_EQUESTTYPE_WANTED_WEEK_ENUM.number = 49
EQUESTTYPE_EQUESTTYPE_BRANCHTALK_ENUM.name = "EQUESTTYPE_BRANCHTALK"
EQUESTTYPE_EQUESTTYPE_BRANCHTALK_ENUM.index = 50
EQUESTTYPE_EQUESTTYPE_BRANCHTALK_ENUM.number = 50
EQUESTTYPE_EQUESTTYPE_BRANCHSTEFANIE_ENUM.name = "EQUESTTYPE_BRANCHSTEFANIE"
EQUESTTYPE_EQUESTTYPE_BRANCHSTEFANIE_ENUM.index = 51
EQUESTTYPE_EQUESTTYPE_BRANCHSTEFANIE_ENUM.number = 51
EQUESTTYPE_EQUESTTYPE_SHARE_NORMAL_ENUM.name = "EQUESTTYPE_SHARE_NORMAL"
EQUESTTYPE_EQUESTTYPE_SHARE_NORMAL_ENUM.index = 52
EQUESTTYPE_EQUESTTYPE_SHARE_NORMAL_ENUM.number = 52
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_1_ENUM.name = "EQUESTTYPE_SHARE_DAILY_1"
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_1_ENUM.index = 53
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_1_ENUM.number = 53
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_3_ENUM.name = "EQUESTTYPE_SHARE_DAILY_3"
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_3_ENUM.index = 54
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_3_ENUM.number = 54
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_7_ENUM.name = "EQUESTTYPE_SHARE_DAILY_7"
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_7_ENUM.index = 55
EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_7_ENUM.number = 55
EQUESTTYPE_EQUESTTYPE_WORLD_ENUM.name = "EQUESTTYPE_WORLD"
EQUESTTYPE_EQUESTTYPE_WORLD_ENUM.index = 56
EQUESTTYPE_EQUESTTYPE_WORLD_ENUM.number = 56
EQUESTTYPE_EQUESTTYPE_WORLDBOSS_ENUM.name = "EQUESTTYPE_WORLDBOSS"
EQUESTTYPE_EQUESTTYPE_WORLDBOSS_ENUM.index = 57
EQUESTTYPE_EQUESTTYPE_WORLDBOSS_ENUM.number = 57
EQUESTTYPE_EQUESTTYPE_WORLDTREASURE_ENUM.name = "EQUESTTYPE_WORLDTREASURE"
EQUESTTYPE_EQUESTTYPE_WORLDTREASURE_ENUM.index = 58
EQUESTTYPE_EQUESTTYPE_WORLDTREASURE_ENUM.number = 58
EQUESTTYPE_EQUESTTYPE_SHARE_STATUS_ENUM.name = "EQUESTTYPE_SHARE_STATUS"
EQUESTTYPE_EQUESTTYPE_SHARE_STATUS_ENUM.index = 59
EQUESTTYPE_EQUESTTYPE_SHARE_STATUS_ENUM.number = 59
EQUESTTYPE_EQUESTTYPE_GUIDING_TASK_ENUM.name = "EQUESTTYPE_GUIDING_TASK"
EQUESTTYPE_EQUESTTYPE_GUIDING_TASK_ENUM.index = 60
EQUESTTYPE_EQUESTTYPE_GUIDING_TASK_ENUM.number = 60
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_1_ENUM.name = "EQUESTTYPE_ACC_WEEK_1"
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_1_ENUM.index = 61
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_1_ENUM.number = 61
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_3_ENUM.name = "EQUESTTYPE_ACC_WEEK_3"
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_3_ENUM.index = 62
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_3_ENUM.number = 62
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_5_ENUM.name = "EQUESTTYPE_ACC_WEEK_5"
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_5_ENUM.index = 63
EQUESTTYPE_EQUESTTYPE_ACC_WEEK_5_ENUM.number = 63
EQUESTTYPE_EQUESTTYPE_WEEK_1_ENUM.name = "EQUESTTYPE_WEEK_1"
EQUESTTYPE_EQUESTTYPE_WEEK_1_ENUM.index = 64
EQUESTTYPE_EQUESTTYPE_WEEK_1_ENUM.number = 64
EQUESTTYPE_EQUESTTYPE_WEEK_3_ENUM.name = "EQUESTTYPE_WEEK_3"
EQUESTTYPE_EQUESTTYPE_WEEK_3_ENUM.index = 65
EQUESTTYPE_EQUESTTYPE_WEEK_3_ENUM.number = 65
EQUESTTYPE_EQUESTTYPE_WEEK_5_ENUM.name = "EQUESTTYPE_WEEK_5"
EQUESTTYPE_EQUESTTYPE_WEEK_5_ENUM.index = 66
EQUESTTYPE_EQUESTTYPE_WEEK_5_ENUM.number = 66
EQUESTTYPE_EQUESTTYPE_BOTTLE_ENUM.name = "EQUESTTYPE_BOTTLE"
EQUESTTYPE_EQUESTTYPE_BOTTLE_ENUM.index = 67
EQUESTTYPE_EQUESTTYPE_BOTTLE_ENUM.number = 67
EQUESTTYPE_EQUESTTYPE_ACC_WORLD_ENUM.name = "EQUESTTYPE_ACC_WORLD"
EQUESTTYPE_EQUESTTYPE_ACC_WORLD_ENUM.index = 68
EQUESTTYPE_EQUESTTYPE_ACC_WORLD_ENUM.number = 68
EQUESTTYPE_EQUESTTYPE_ACC_WORLDTREASURE_ENUM.name = "EQUESTTYPE_ACC_WORLDTREASURE"
EQUESTTYPE_EQUESTTYPE_ACC_WORLDTREASURE_ENUM.index = 69
EQUESTTYPE_EQUESTTYPE_ACC_WORLDTREASURE_ENUM.number = 69
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_WORLD_ENUM.name = "EQUESTTYPE_ACC_DAILY_WORLD"
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_WORLD_ENUM.index = 70
EQUESTTYPE_EQUESTTYPE_ACC_DAILY_WORLD_ENUM.number = 70
EQUESTTYPE_EQUESTTYPE_ATMOSPHERE_ENUM.name = "EQUESTTYPE_ATMOSPHERE"
EQUESTTYPE_EQUESTTYPE_ATMOSPHERE_ENUM.index = 71
EQUESTTYPE_EQUESTTYPE_ATMOSPHERE_ENUM.number = 71
EQUESTTYPE_EQUESTTYPE_SMITHY_ENUM.name = "EQUESTTYPE_SMITHY"
EQUESTTYPE_EQUESTTYPE_SMITHY_ENUM.index = 72
EQUESTTYPE_EQUESTTYPE_SMITHY_ENUM.number = 72
EQUESTTYPE_EQUESTTYPE_ANCIENT_CITY_DAILY_ENUM.name = "EQUESTTYPE_ANCIENT_CITY_DAILY"
EQUESTTYPE_EQUESTTYPE_ANCIENT_CITY_DAILY_ENUM.index = 73
EQUESTTYPE_EQUESTTYPE_ANCIENT_CITY_DAILY_ENUM.number = 73
EQUESTTYPE_EQUESTTYPE_ACC_WORLDBOSS_ENUM.name = "EQUESTTYPE_ACC_WORLDBOSS"
EQUESTTYPE_EQUESTTYPE_ACC_WORLDBOSS_ENUM.index = 74
EQUESTTYPE_EQUESTTYPE_ACC_WORLDBOSS_ENUM.number = 74
EQUESTTYPE_EQUESTTYPE_ABYSS_DAILY_ENUM.name = "EQUESTTYPE_ABYSS_DAILY"
EQUESTTYPE_EQUESTTYPE_ABYSS_DAILY_ENUM.index = 75
EQUESTTYPE_EQUESTTYPE_ABYSS_DAILY_ENUM.number = 75
EQUESTTYPE_EQUESTTYPE_MAX_ENUM.name = "EQUESTTYPE_MAX"
EQUESTTYPE_EQUESTTYPE_MAX_ENUM.index = 76
EQUESTTYPE_EQUESTTYPE_MAX_ENUM.number = 76
EQUESTTYPE.name = "EQuestType"
EQUESTTYPE.full_name = ".Cmd.EQuestType"
EQUESTTYPE.values = {
  EQUESTTYPE_EQUESTTYPE_MIN_ENUM,
  EQUESTTYPE_EQUESTTYPE_MAIN_ENUM,
  EQUESTTYPE_EQUESTTYPE_BRANCH_ENUM,
  EQUESTTYPE_EQUESTTYPE_TALK_ENUM,
  EQUESTTYPE_EQUESTTYPE_TRIGGER_ENUM,
  EQUESTTYPE_EQUESTTYPE_WANTED_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_7_ENUM,
  EQUESTTYPE_EQUESTTYPE_STORY_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_MAP_ENUM,
  EQUESTTYPE_EQUESTTYPE_SCENE_ENUM,
  EQUESTTYPE_EQUESTTYPE_HEAD_ENUM,
  EQUESTTYPE_EQUESTTYPE_RAIDTALK_ENUM,
  EQUESTTYPE_EQUESTTYPE_SATISFACTION_ENUM,
  EQUESTTYPE_EQUESTTYPE_ELITE_ENUM,
  EQUESTTYPE_EQUESTTYPE_CCRASTEHAM_ENUM,
  EQUESTTYPE_EQUESTTYPE_STORY_CCRASTEHAM_ENUM,
  EQUESTTYPE_EQUESTTYPE_GUILD_ENUM,
  EQUESTTYPE_EQUESTTYPE_CHILD_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_RESET_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_NORMAL_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_CHOICE_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_MAPRAND_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_MAIN_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_BRANCH_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_SATISFACTION_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_7_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_RESET_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAILY_BOX_ENUM,
  EQUESTTYPE_EQUESTTYPE_SIGN_ENUM,
  EQUESTTYPE_EQUESTTYPE_DAY_ENUM,
  EQUESTTYPE_EQUESTTYPE_NIGHT_ENUM,
  EQUESTTYPE_EQUESTTYPE_ARTIFACT_ENUM,
  EQUESTTYPE_EQUESTTYPE_WEDDING_ENUM,
  EQUESTTYPE_EQUESTTYPE_WEDDING_DAILY_ENUM,
  EQUESTTYPE_EQUESTTYPE_CAPRA_ENUM,
  EQUESTTYPE_EQUESTTYPE_DEAD_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_2_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_4_ENUM,
  EQUESTTYPE_EQUESTTYPE_VERSION_ENUM,
  EQUESTTYPE_EQUESTTYPE_WANTED_DAY_ENUM,
  EQUESTTYPE_EQUESTTYPE_WANTED_WEEK_ENUM,
  EQUESTTYPE_EQUESTTYPE_BRANCHTALK_ENUM,
  EQUESTTYPE_EQUESTTYPE_BRANCHSTEFANIE_ENUM,
  EQUESTTYPE_EQUESTTYPE_SHARE_NORMAL_ENUM,
  EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_SHARE_DAILY_7_ENUM,
  EQUESTTYPE_EQUESTTYPE_WORLD_ENUM,
  EQUESTTYPE_EQUESTTYPE_WORLDBOSS_ENUM,
  EQUESTTYPE_EQUESTTYPE_WORLDTREASURE_ENUM,
  EQUESTTYPE_EQUESTTYPE_SHARE_STATUS_ENUM,
  EQUESTTYPE_EQUESTTYPE_GUIDING_TASK_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WEEK_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WEEK_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WEEK_5_ENUM,
  EQUESTTYPE_EQUESTTYPE_WEEK_1_ENUM,
  EQUESTTYPE_EQUESTTYPE_WEEK_3_ENUM,
  EQUESTTYPE_EQUESTTYPE_WEEK_5_ENUM,
  EQUESTTYPE_EQUESTTYPE_BOTTLE_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WORLD_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WORLDTREASURE_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_DAILY_WORLD_ENUM,
  EQUESTTYPE_EQUESTTYPE_ATMOSPHERE_ENUM,
  EQUESTTYPE_EQUESTTYPE_SMITHY_ENUM,
  EQUESTTYPE_EQUESTTYPE_ANCIENT_CITY_DAILY_ENUM,
  EQUESTTYPE_EQUESTTYPE_ACC_WORLDBOSS_ENUM,
  EQUESTTYPE_EQUESTTYPE_ABYSS_DAILY_ENUM,
  EQUESTTYPE_EQUESTTYPE_MAX_ENUM
}
EQUESTSTEP_EQUESTSTEP_MIN_ENUM.name = "EQUESTSTEP_MIN"
EQUESTSTEP_EQUESTSTEP_MIN_ENUM.index = 0
EQUESTSTEP_EQUESTSTEP_MIN_ENUM.number = 0
EQUESTSTEP_EQUESTSTEP_VISIT_ENUM.name = "EQUESTSTEP_VISIT"
EQUESTSTEP_EQUESTSTEP_VISIT_ENUM.index = 1
EQUESTSTEP_EQUESTSTEP_VISIT_ENUM.number = 1
EQUESTSTEP_EQUESTSTEP_KILL_ENUM.name = "EQUESTSTEP_KILL"
EQUESTSTEP_EQUESTSTEP_KILL_ENUM.index = 2
EQUESTSTEP_EQUESTSTEP_KILL_ENUM.number = 2
EQUESTSTEP_EQUESTSTEP_REWARD_ENUM.name = "EQUESTSTEP_REWARD"
EQUESTSTEP_EQUESTSTEP_REWARD_ENUM.index = 3
EQUESTSTEP_EQUESTSTEP_REWARD_ENUM.number = 3
EQUESTSTEP_EQUESTSTEP_COLLECT_ENUM.name = "EQUESTSTEP_COLLECT"
EQUESTSTEP_EQUESTSTEP_COLLECT_ENUM.index = 4
EQUESTSTEP_EQUESTSTEP_COLLECT_ENUM.number = 4
EQUESTSTEP_EQUESTSTEP_SUMMON_ENUM.name = "EQUESTSTEP_SUMMON"
EQUESTSTEP_EQUESTSTEP_SUMMON_ENUM.index = 5
EQUESTSTEP_EQUESTSTEP_SUMMON_ENUM.number = 5
EQUESTSTEP_EQUESTSTEP_GUARD_ENUM.name = "EQUESTSTEP_GUARD"
EQUESTSTEP_EQUESTSTEP_GUARD_ENUM.index = 6
EQUESTSTEP_EQUESTSTEP_GUARD_ENUM.number = 6
EQUESTSTEP_EQUESTSTEP_GMCMD_ENUM.name = "EQUESTSTEP_GMCMD"
EQUESTSTEP_EQUESTSTEP_GMCMD_ENUM.index = 7
EQUESTSTEP_EQUESTSTEP_GMCMD_ENUM.number = 7
EQUESTSTEP_EQUESTSTEP_TESTFAIL_ENUM.name = "EQUESTSTEP_TESTFAIL"
EQUESTSTEP_EQUESTSTEP_TESTFAIL_ENUM.index = 8
EQUESTSTEP_EQUESTSTEP_TESTFAIL_ENUM.number = 8
EQUESTSTEP_EQUESTSTEP_USE_ENUM.name = "EQUESTSTEP_USE"
EQUESTSTEP_EQUESTSTEP_USE_ENUM.index = 9
EQUESTSTEP_EQUESTSTEP_USE_ENUM.number = 9
EQUESTSTEP_EQUESTSTEP_GATHER_ENUM.name = "EQUESTSTEP_GATHER"
EQUESTSTEP_EQUESTSTEP_GATHER_ENUM.index = 10
EQUESTSTEP_EQUESTSTEP_GATHER_ENUM.number = 10
EQUESTSTEP_EQUESTSTEP_DELETE_ENUM.name = "EQUESTSTEP_DELETE"
EQUESTSTEP_EQUESTSTEP_DELETE_ENUM.index = 11
EQUESTSTEP_EQUESTSTEP_DELETE_ENUM.number = 11
EQUESTSTEP_EQUESTSTEP_RAID_ENUM.name = "EQUESTSTEP_RAID"
EQUESTSTEP_EQUESTSTEP_RAID_ENUM.index = 12
EQUESTSTEP_EQUESTSTEP_RAID_ENUM.number = 12
EQUESTSTEP_EQUESTSTEP_CAMERA_ENUM.name = "EQUESTSTEP_CAMERA"
EQUESTSTEP_EQUESTSTEP_CAMERA_ENUM.index = 13
EQUESTSTEP_EQUESTSTEP_CAMERA_ENUM.number = 13
EQUESTSTEP_EQUESTSTEP_LEVEL_ENUM.name = "EQUESTSTEP_LEVEL"
EQUESTSTEP_EQUESTSTEP_LEVEL_ENUM.index = 14
EQUESTSTEP_EQUESTSTEP_LEVEL_ENUM.number = 14
EQUESTSTEP_EQUESTSTEP_WAIT_ENUM.name = "EQUESTSTEP_WAIT"
EQUESTSTEP_EQUESTSTEP_WAIT_ENUM.index = 15
EQUESTSTEP_EQUESTSTEP_WAIT_ENUM.number = 15
EQUESTSTEP_EQUESTSTEP_MOVE_ENUM.name = "EQUESTSTEP_MOVE"
EQUESTSTEP_EQUESTSTEP_MOVE_ENUM.index = 16
EQUESTSTEP_EQUESTSTEP_MOVE_ENUM.number = 16
EQUESTSTEP_EQUESTSTEP_DIALOG_ENUM.name = "EQUESTSTEP_DIALOG"
EQUESTSTEP_EQUESTSTEP_DIALOG_ENUM.index = 17
EQUESTSTEP_EQUESTSTEP_DIALOG_ENUM.number = 17
EQUESTSTEP_EQUESTSTEP_PREQUEST_ENUM.name = "EQUESTSTEP_PREQUEST"
EQUESTSTEP_EQUESTSTEP_PREQUEST_ENUM.index = 18
EQUESTSTEP_EQUESTSTEP_PREQUEST_ENUM.number = 18
EQUESTSTEP_EQUESTSTEP_CLEARNPC_ENUM.name = "EQUESTSTEP_CLEARNPC"
EQUESTSTEP_EQUESTSTEP_CLEARNPC_ENUM.index = 19
EQUESTSTEP_EQUESTSTEP_CLEARNPC_ENUM.number = 19
EQUESTSTEP_EQUESTSTEP_MOUNTRIDE_ENUM.name = "EQUESTSTEP_MOUNTRIDE"
EQUESTSTEP_EQUESTSTEP_MOUNTRIDE_ENUM.index = 20
EQUESTSTEP_EQUESTSTEP_MOUNTRIDE_ENUM.number = 20
EQUESTSTEP_EQUESTSTEP_SELFIE_ENUM.name = "EQUESTSTEP_SELFIE"
EQUESTSTEP_EQUESTSTEP_SELFIE_ENUM.index = 21
EQUESTSTEP_EQUESTSTEP_SELFIE_ENUM.number = 21
EQUESTSTEP_EQUESTSTEP_CHECKTEAM_ENUM.name = "EQUESTSTEP_CHECKTEAM"
EQUESTSTEP_EQUESTSTEP_CHECKTEAM_ENUM.index = 22
EQUESTSTEP_EQUESTSTEP_CHECKTEAM_ENUM.number = 22
EQUESTSTEP_EQUESTSTEP_REMOVEMONEY_ENUM.name = "EQUESTSTEP_REMOVEMONEY"
EQUESTSTEP_EQUESTSTEP_REMOVEMONEY_ENUM.index = 23
EQUESTSTEP_EQUESTSTEP_REMOVEMONEY_ENUM.number = 23
EQUESTSTEP_EQUESTSTEP_CLASS_ENUM.name = "EQUESTSTEP_CLASS"
EQUESTSTEP_EQUESTSTEP_CLASS_ENUM.index = 24
EQUESTSTEP_EQUESTSTEP_CLASS_ENUM.number = 24
EQUESTSTEP_EQUESTSTEP_ORGCLASS_ENUM.name = "EQUESTSTEP_ORGCLASS"
EQUESTSTEP_EQUESTSTEP_ORGCLASS_ENUM.index = 25
EQUESTSTEP_EQUESTSTEP_ORGCLASS_ENUM.number = 25
EQUESTSTEP_EQUESTSTEP_EVO_ENUM.name = "EQUESTSTEP_EVO"
EQUESTSTEP_EQUESTSTEP_EVO_ENUM.index = 26
EQUESTSTEP_EQUESTSTEP_EVO_ENUM.number = 26
EQUESTSTEP_EQUESTSTEP_CHECKQUEST_ENUM.name = "EQUESTSTEP_CHECKQUEST"
EQUESTSTEP_EQUESTSTEP_CHECKQUEST_ENUM.index = 27
EQUESTSTEP_EQUESTSTEP_CHECKQUEST_ENUM.number = 27
EQUESTSTEP_EQUESTSTEP_CHECKITEM_ENUM.name = "EQUESTSTEP_CHECKITEM"
EQUESTSTEP_EQUESTSTEP_CHECKITEM_ENUM.index = 28
EQUESTSTEP_EQUESTSTEP_CHECKITEM_ENUM.number = 28
EQUESTSTEP_EQUESTSTEP_REMOVEITEM_ENUM.name = "EQUESTSTEP_REMOVEITEM"
EQUESTSTEP_EQUESTSTEP_REMOVEITEM_ENUM.index = 29
EQUESTSTEP_EQUESTSTEP_REMOVEITEM_ENUM.number = 29
EQUESTSTEP_EQUESTSTEP_RANDOMJUMP_ENUM.name = "EQUESTSTEP_RANDOMJUMP"
EQUESTSTEP_EQUESTSTEP_RANDOMJUMP_ENUM.index = 30
EQUESTSTEP_EQUESTSTEP_RANDOMJUMP_ENUM.number = 30
EQUESTSTEP_EQUESTSTEP_CHECKLEVEL_ENUM.name = "EQUESTSTEP_CHECKLEVEL"
EQUESTSTEP_EQUESTSTEP_CHECKLEVEL_ENUM.index = 31
EQUESTSTEP_EQUESTSTEP_CHECKLEVEL_ENUM.number = 31
EQUESTSTEP_EQUESTSTEP_CHECKGEAR_ENUM.name = "EQUESTSTEP_CHECKGEAR"
EQUESTSTEP_EQUESTSTEP_CHECKGEAR_ENUM.index = 32
EQUESTSTEP_EQUESTSTEP_CHECKGEAR_ENUM.number = 32
EQUESTSTEP_EQUESTSTEP_PURIFY_ENUM.name = "EQUESTSTEP_PURIFY"
EQUESTSTEP_EQUESTSTEP_PURIFY_ENUM.index = 33
EQUESTSTEP_EQUESTSTEP_PURIFY_ENUM.number = 33
EQUESTSTEP_EQUESTSTEP_ACTION_ENUM.name = "EQUESTSTEP_ACTION"
EQUESTSTEP_EQUESTSTEP_ACTION_ENUM.index = 34
EQUESTSTEP_EQUESTSTEP_ACTION_ENUM.number = 34
EQUESTSTEP_EQUESTSTEP_SKILL_ENUM.name = "EQUESTSTEP_SKILL"
EQUESTSTEP_EQUESTSTEP_SKILL_ENUM.index = 35
EQUESTSTEP_EQUESTSTEP_SKILL_ENUM.number = 35
EQUESTSTEP_EQUESTSTEP_INTERLOCUTION_ENUM.name = "EQUESTSTEP_INTERLOCUTION"
EQUESTSTEP_EQUESTSTEP_INTERLOCUTION_ENUM.index = 36
EQUESTSTEP_EQUESTSTEP_INTERLOCUTION_ENUM.number = 36
EQUESTSTEP_EQUESTSTEP_EMPTY_ENUM.name = "EQUESTSTEP_EMPTY"
EQUESTSTEP_EQUESTSTEP_EMPTY_ENUM.index = 37
EQUESTSTEP_EQUESTSTEP_EMPTY_ENUM.number = 37
EQUESTSTEP_EQUESTSTEP_CHECKEQUIP_ENUM.name = "EQUESTSTEP_CHECKEQUIP"
EQUESTSTEP_EQUESTSTEP_CHECKEQUIP_ENUM.index = 38
EQUESTSTEP_EQUESTSTEP_CHECKEQUIP_ENUM.number = 38
EQUESTSTEP_EQUESTSTEP_CHECKMONEY_ENUM.name = "EQUESTSTEP_CHECKMONEY"
EQUESTSTEP_EQUESTSTEP_CHECKMONEY_ENUM.index = 39
EQUESTSTEP_EQUESTSTEP_CHECKMONEY_ENUM.number = 39
EQUESTSTEP_EQUESTSTEP_GUIDE_ENUM.name = "EQUESTSTEP_GUIDE"
EQUESTSTEP_EQUESTSTEP_GUIDE_ENUM.index = 40
EQUESTSTEP_EQUESTSTEP_GUIDE_ENUM.number = 40
EQUESTSTEP_EQUESTSTEP_GUIDE_CHECK_ENUM.name = "EQUESTSTEP_GUIDE_CHECK"
EQUESTSTEP_EQUESTSTEP_GUIDE_CHECK_ENUM.index = 41
EQUESTSTEP_EQUESTSTEP_GUIDE_CHECK_ENUM.number = 41
EQUESTSTEP_EQUESTSTEP_GUIDE_HIGHLIGHT_ENUM.name = "EQUESTSTEP_GUIDE_HIGHLIGHT"
EQUESTSTEP_EQUESTSTEP_GUIDE_HIGHLIGHT_ENUM.index = 42
EQUESTSTEP_EQUESTSTEP_GUIDE_HIGHLIGHT_ENUM.number = 42
EQUESTSTEP_EQUESTSTEP_CHECKOPTION_ENUM.name = "EQUESTSTEP_CHECKOPTION"
EQUESTSTEP_EQUESTSTEP_CHECKOPTION_ENUM.index = 43
EQUESTSTEP_EQUESTSTEP_CHECKOPTION_ENUM.number = 43
EQUESTSTEP_EQUESTSTEP_HINT_ENUM.name = "EQUESTSTEP_HINT"
EQUESTSTEP_EQUESTSTEP_HINT_ENUM.index = 44
EQUESTSTEP_EQUESTSTEP_HINT_ENUM.number = 44
EQUESTSTEP_EQUESTSTEP_CHECKGROUP_ENUM.name = "EQUESTSTEP_CHECKGROUP"
EQUESTSTEP_EQUESTSTEP_CHECKGROUP_ENUM.index = 45
EQUESTSTEP_EQUESTSTEP_CHECKGROUP_ENUM.number = 45
EQUESTSTEP_EQUESTSTEP_SEAL_ENUM.name = "EQUESTSTEP_SEAL"
EQUESTSTEP_EQUESTSTEP_SEAL_ENUM.index = 46
EQUESTSTEP_EQUESTSTEP_SEAL_ENUM.number = 46
EQUESTSTEP_EQUESTSTEP_EQUIPLV_ENUM.name = "EQUESTSTEP_EQUIPLV"
EQUESTSTEP_EQUESTSTEP_EQUIPLV_ENUM.index = 47
EQUESTSTEP_EQUESTSTEP_EQUIPLV_ENUM.number = 47
EQUESTSTEP_EQUESTSTEP_VIDEO_ENUM.name = "EQUESTSTEP_VIDEO"
EQUESTSTEP_EQUESTSTEP_VIDEO_ENUM.index = 48
EQUESTSTEP_EQUESTSTEP_VIDEO_ENUM.number = 48
EQUESTSTEP_EQUESTSTEP_ILLUSTRATION_ENUM.name = "EQUESTSTEP_ILLUSTRATION"
EQUESTSTEP_EQUESTSTEP_ILLUSTRATION_ENUM.index = 49
EQUESTSTEP_EQUESTSTEP_ILLUSTRATION_ENUM.number = 49
EQUESTSTEP_EQUESTSTEP_NPCPLAY_ENUM.name = "EQUESTSTEP_NPCPLAY"
EQUESTSTEP_EQUESTSTEP_NPCPLAY_ENUM.index = 50
EQUESTSTEP_EQUESTSTEP_NPCPLAY_ENUM.number = 50
EQUESTSTEP_EQUESTSTEP_ITEM_ENUM.name = "EQUESTSTEP_ITEM"
EQUESTSTEP_EQUESTSTEP_ITEM_ENUM.index = 51
EQUESTSTEP_EQUESTSTEP_ITEM_ENUM.number = 51
EQUESTSTEP_EQUESTSTEP_DAILY_ENUM.name = "EQUESTSTEP_DAILY"
EQUESTSTEP_EQUESTSTEP_DAILY_ENUM.index = 52
EQUESTSTEP_EQUESTSTEP_DAILY_ENUM.number = 52
EQUESTSTEP_EQUESTSTEP_CHECK_MANUAL_ENUM.name = "EQUESTSTEP_CHECK_MANUAL"
EQUESTSTEP_EQUESTSTEP_CHECK_MANUAL_ENUM.index = 53
EQUESTSTEP_EQUESTSTEP_CHECK_MANUAL_ENUM.number = 53
EQUESTSTEP_EQUESTSTEP_MANUAL_ENUM.name = "EQUESTSTEP_MANUAL"
EQUESTSTEP_EQUESTSTEP_MANUAL_ENUM.index = 54
EQUESTSTEP_EQUESTSTEP_MANUAL_ENUM.number = 54
EQUESTSTEP_EQUESTSTEP_PLAY_MUSIC_ENUM.name = "EQUESTSTEP_PLAY_MUSIC"
EQUESTSTEP_EQUESTSTEP_PLAY_MUSIC_ENUM.index = 55
EQUESTSTEP_EQUESTSTEP_PLAY_MUSIC_ENUM.number = 55
EQUESTSTEP_EQUESTSTEP_REWRADHELP_ENUM.name = "EQUESTSTEP_REWRADHELP"
EQUESTSTEP_EQUESTSTEP_REWRADHELP_ENUM.index = 56
EQUESTSTEP_EQUESTSTEP_REWRADHELP_ENUM.number = 56
EQUESTSTEP_EQUESTSTEP_GUIDELOCKMONSTER_ENUM.name = "EQUESTSTEP_GUIDELOCKMONSTER"
EQUESTSTEP_EQUESTSTEP_GUIDELOCKMONSTER_ENUM.index = 57
EQUESTSTEP_EQUESTSTEP_GUIDELOCKMONSTER_ENUM.number = 57
EQUESTSTEP_EQUESTSTEP_MONEY_ENUM.name = "EQUESTSTEP_MONEY"
EQUESTSTEP_EQUESTSTEP_MONEY_ENUM.index = 58
EQUESTSTEP_EQUESTSTEP_MONEY_ENUM.number = 58
EQUESTSTEP_EQUESTSTEP_ACTIVITY_ENUM.name = "EQUESTSTEP_ACTIVITY"
EQUESTSTEP_EQUESTSTEP_ACTIVITY_ENUM.index = 59
EQUESTSTEP_EQUESTSTEP_ACTIVITY_ENUM.number = 59
EQUESTSTEP_EQUESTSTEP_OPTION_ENUM.name = "EQUESTSTEP_OPTION"
EQUESTSTEP_EQUESTSTEP_OPTION_ENUM.index = 60
EQUESTSTEP_EQUESTSTEP_OPTION_ENUM.number = 60
EQUESTSTEP_EQUESTSTEP_PHOTO_ENUM.name = "EQUESTSTEP_PHOTO"
EQUESTSTEP_EQUESTSTEP_PHOTO_ENUM.index = 61
EQUESTSTEP_EQUESTSTEP_PHOTO_ENUM.number = 61
EQUESTSTEP_EQUESTSTEP_ITEMUSE_ENUM.name = "EQUESTSTEP_ITEMUSE"
EQUESTSTEP_EQUESTSTEP_ITEMUSE_ENUM.index = 62
EQUESTSTEP_EQUESTSTEP_ITEMUSE_ENUM.number = 62
EQUESTSTEP_EQUESTSTEP_HAND_ENUM.name = "EQUESTSTEP_HAND"
EQUESTSTEP_EQUESTSTEP_HAND_ENUM.index = 63
EQUESTSTEP_EQUESTSTEP_HAND_ENUM.number = 63
EQUESTSTEP_EQUESTSTEP_MUSIC_ENUM.name = "EQUESTSTEP_MUSIC"
EQUESTSTEP_EQUESTSTEP_MUSIC_ENUM.index = 64
EQUESTSTEP_EQUESTSTEP_MUSIC_ENUM.number = 64
EQUESTSTEP_EQUESTSTEP_RANDITEM_ENUM.name = "EQUESTSTEP_RANDITEM"
EQUESTSTEP_EQUESTSTEP_RANDITEM_ENUM.index = 65
EQUESTSTEP_EQUESTSTEP_RANDITEM_ENUM.number = 65
EQUESTSTEP_EQUESTSTEP_CARRIER_ENUM.name = "EQUESTSTEP_CARRIER"
EQUESTSTEP_EQUESTSTEP_CARRIER_ENUM.index = 66
EQUESTSTEP_EQUESTSTEP_CARRIER_ENUM.number = 66
EQUESTSTEP_EQUESTSTEP_BATTLE_ENUM.name = "EQUESTSTEP_BATTLE"
EQUESTSTEP_EQUESTSTEP_BATTLE_ENUM.index = 67
EQUESTSTEP_EQUESTSTEP_BATTLE_ENUM.number = 67
EQUESTSTEP_EQUESTSTEP_COOKFOOD_ENUM.name = "EQUESTSTEP_COOKFOOD"
EQUESTSTEP_EQUESTSTEP_COOKFOOD_ENUM.index = 68
EQUESTSTEP_EQUESTSTEP_COOKFOOD_ENUM.number = 68
EQUESTSTEP_EQUESTSTEP_PET_ENUM.name = "EQUESTSTEP_PET"
EQUESTSTEP_EQUESTSTEP_PET_ENUM.index = 69
EQUESTSTEP_EQUESTSTEP_PET_ENUM.number = 69
EQUESTSTEP_EQUESTSTEP_SCENE_ENUM.name = "EQUESTSTEP_SCENE"
EQUESTSTEP_EQUESTSTEP_SCENE_ENUM.index = 70
EQUESTSTEP_EQUESTSTEP_SCENE_ENUM.number = 70
EQUESTSTEP_EQUESTSTEP_COOK_ENUM.name = "EQUESTSTEP_COOK"
EQUESTSTEP_EQUESTSTEP_COOK_ENUM.index = 71
EQUESTSTEP_EQUESTSTEP_COOK_ENUM.number = 71
EQUESTSTEP_EQUESTSTEP_BUFF_ENUM.name = "EQUESTSTEP_BUFF"
EQUESTSTEP_EQUESTSTEP_BUFF_ENUM.index = 72
EQUESTSTEP_EQUESTSTEP_BUFF_ENUM.number = 72
EQUESTSTEP_EQUESTSTEP_TUTOR_ENUM.name = "EQUESTSTEP_TUTOR"
EQUESTSTEP_EQUESTSTEP_TUTOR_ENUM.index = 73
EQUESTSTEP_EQUESTSTEP_TUTOR_ENUM.number = 73
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_ENUM.name = "EQUESTSTEP_CHRISTMAS"
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_ENUM.index = 74
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_ENUM.number = 74
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_RUN_ENUM.name = "EQUESTSTEP_CHRISTMAS_RUN"
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_RUN_ENUM.index = 75
EQUESTSTEP_EQUESTSTEP_CHRISTMAS_RUN_ENUM.number = 75
EQUESTSTEP_EQUESTSTEP_BEING_ENUM.name = "EQUESTSTEP_BEING"
EQUESTSTEP_EQUESTSTEP_BEING_ENUM.index = 76
EQUESTSTEP_EQUESTSTEP_BEING_ENUM.number = 76
EQUESTSTEP_EQUESTSTEP_CHECK_JOY_ENUM.name = "EQUESTSTEP_CHECK_JOY"
EQUESTSTEP_EQUESTSTEP_CHECK_JOY_ENUM.index = 77
EQUESTSTEP_EQUESTSTEP_CHECK_JOY_ENUM.number = 77
EQUESTSTEP_EQUESTSTEP_ADD_JOY_ENUM.name = "EQUESTSTEP_ADD_JOY"
EQUESTSTEP_EQUESTSTEP_ADD_JOY_ENUM.index = 78
EQUESTSTEP_EQUESTSTEP_ADD_JOY_ENUM.number = 78
EQUESTSTEP_EQUESTSTEP_RAND_DIALOG_ENUM.name = "EQUESTSTEP_RAND_DIALOG"
EQUESTSTEP_EQUESTSTEP_RAND_DIALOG_ENUM.index = 79
EQUESTSTEP_EQUESTSTEP_RAND_DIALOG_ENUM.number = 79
EQUESTSTEP_EQUESTSTEP_CG_ENUM.name = "EQUESTSTEP_CG"
EQUESTSTEP_EQUESTSTEP_CG_ENUM.index = 80
EQUESTSTEP_EQUESTSTEP_CG_ENUM.number = 80
EQUESTSTEP_EQUESTSTEP_CHECKSERVANT_ENUM.name = "EQUESTSTEP_CHECKSERVANT"
EQUESTSTEP_EQUESTSTEP_CHECKSERVANT_ENUM.index = 81
EQUESTSTEP_EQUESTSTEP_CHECKSERVANT_ENUM.number = 81
EQUESTSTEP_EQUESTSTEP_CLIENTPLOT_ENUM.name = "EQUESTSTEP_CLIENTPLOT"
EQUESTSTEP_EQUESTSTEP_CLIENTPLOT_ENUM.index = 82
EQUESTSTEP_EQUESTSTEP_CLIENTPLOT_ENUM.number = 84
EQUESTSTEP_EQUESTSTEP_CHAT_ENUM.name = "EQUESTSTEP_CHAT"
EQUESTSTEP_EQUESTSTEP_CHAT_ENUM.index = 83
EQUESTSTEP_EQUESTSTEP_CHAT_ENUM.number = 85
EQUESTSTEP_EQUESTSTEP_TRANSFER_ENUM.name = "EQUESTSTEP_TRANSFER"
EQUESTSTEP_EQUESTSTEP_TRANSFER_ENUM.index = 84
EQUESTSTEP_EQUESTSTEP_TRANSFER_ENUM.number = 86
EQUESTSTEP_EQUESTSTEP_REDIALOG_ENUM.name = "EQUESTSTEP_REDIALOG"
EQUESTSTEP_EQUESTSTEP_REDIALOG_ENUM.index = 85
EQUESTSTEP_EQUESTSTEP_REDIALOG_ENUM.number = 87
EQUESTSTEP_EQUESTSTEP_CHAT_SYSTEM_ENUM.name = "EQUESTSTEP_CHAT_SYSTEM"
EQUESTSTEP_EQUESTSTEP_CHAT_SYSTEM_ENUM.index = 86
EQUESTSTEP_EQUESTSTEP_CHAT_SYSTEM_ENUM.number = 88
EQUESTSTEP_EQUESTSTEP_CHECK_UNLOCKCAT_ENUM.name = "EQUESTSTEP_CHECK_UNLOCKCAT"
EQUESTSTEP_EQUESTSTEP_CHECK_UNLOCKCAT_ENUM.index = 87
EQUESTSTEP_EQUESTSTEP_CHECK_UNLOCKCAT_ENUM.number = 89
EQUESTSTEP_EQUESTSTEP_GROUP_ENUM.name = "EQUESTSTEP_GROUP"
EQUESTSTEP_EQUESTSTEP_GROUP_ENUM.index = 88
EQUESTSTEP_EQUESTSTEP_GROUP_ENUM.number = 90
EQUESTSTEP_EQUESTSTEP_NPCWALK_ENUM.name = "EQUESTSTEP_NPCWALK"
EQUESTSTEP_EQUESTSTEP_NPCWALK_ENUM.index = 89
EQUESTSTEP_EQUESTSTEP_NPCWALK_ENUM.number = 91
EQUESTSTEP_EQUESTSTEP_NPCSKILL_ENUM.name = "EQUESTSTEP_NPCSKILL"
EQUESTSTEP_EQUESTSTEP_NPCSKILL_ENUM.index = 90
EQUESTSTEP_EQUESTSTEP_NPCSKILL_ENUM.number = 92
EQUESTSTEP_EQUESTSTEP_CHECK_HANDNPC_ENUM.name = "EQUESTSTEP_CHECK_HANDNPC"
EQUESTSTEP_EQUESTSTEP_CHECK_HANDNPC_ENUM.index = 91
EQUESTSTEP_EQUESTSTEP_CHECK_HANDNPC_ENUM.number = 94
EQUESTSTEP_EQUESTSTEP_USESKILL_ENUM.name = "EQUESTSTEP_USESKILL"
EQUESTSTEP_EQUESTSTEP_USESKILL_ENUM.index = 92
EQUESTSTEP_EQUESTSTEP_USESKILL_ENUM.number = 95
EQUESTSTEP_EQUESTSTEP_NPCHP_ENUM.name = "EQUESTSTEP_NPCHP"
EQUESTSTEP_EQUESTSTEP_NPCHP_ENUM.index = 93
EQUESTSTEP_EQUESTSTEP_NPCHP_ENUM.number = 96
EQUESTSTEP_EQUESTSTEP_CAMERASHOW_ENUM.name = "EQUESTSTEP_CAMERASHOW"
EQUESTSTEP_EQUESTSTEP_CAMERASHOW_ENUM.index = 94
EQUESTSTEP_EQUESTSTEP_CAMERASHOW_ENUM.number = 98
EQUESTSTEP_EQUESTSTEP_TIMEPHASING_ENUM.name = "EQUESTSTEP_TIMEPHASING"
EQUESTSTEP_EQUESTSTEP_TIMEPHASING_ENUM.index = 95
EQUESTSTEP_EQUESTSTEP_TIMEPHASING_ENUM.number = 99
EQUESTSTEP_EQUESTSTEP_GAME_ENUM.name = "EQUESTSTEP_GAME"
EQUESTSTEP_EQUESTSTEP_GAME_ENUM.index = 96
EQUESTSTEP_EQUESTSTEP_GAME_ENUM.number = 100
EQUESTSTEP_EQUESTSTEP_KILLORDER_ENUM.name = "EQUESTSTEP_KILLORDER"
EQUESTSTEP_EQUESTSTEP_KILLORDER_ENUM.index = 97
EQUESTSTEP_EQUESTSTEP_KILLORDER_ENUM.number = 101
EQUESTSTEP_EQUESTSTEP_PICTURE_ENUM.name = "EQUESTSTEP_PICTURE"
EQUESTSTEP_EQUESTSTEP_PICTURE_ENUM.index = 98
EQUESTSTEP_EQUESTSTEP_PICTURE_ENUM.number = 102
EQUESTSTEP_EQUESTSTEP_GAMECOUNT_ENUM.name = "EQUESTSTEP_GAMECOUNT"
EQUESTSTEP_EQUESTSTEP_GAMECOUNT_ENUM.index = 99
EQUESTSTEP_EQUESTSTEP_GAMECOUNT_ENUM.number = 103
EQUESTSTEP_EQUESTSTEP_MAIL_ENUM.name = "EQUESTSTEP_MAIL"
EQUESTSTEP_EQUESTSTEP_MAIL_ENUM.index = 100
EQUESTSTEP_EQUESTSTEP_MAIL_ENUM.number = 104
EQUESTSTEP_EQUESTSTEP_CHOOSE_BRANCH_ENUM.name = "EQUESTSTEP_CHOOSE_BRANCH"
EQUESTSTEP_EQUESTSTEP_CHOOSE_BRANCH_ENUM.index = 101
EQUESTSTEP_EQUESTSTEP_CHOOSE_BRANCH_ENUM.number = 105
EQUESTSTEP_EQUESTSTEP_WAITPOS_ENUM.name = "EQUESTSTEP_WAITPOS"
EQUESTSTEP_EQUESTSTEP_WAITPOS_ENUM.index = 102
EQUESTSTEP_EQUESTSTEP_WAITPOS_ENUM.number = 106
EQUESTSTEP_EQUESTSTEP_SHOT_ENUM.name = "EQUESTSTEP_SHOT"
EQUESTSTEP_EQUESTSTEP_SHOT_ENUM.index = 103
EQUESTSTEP_EQUESTSTEP_SHOT_ENUM.number = 107
EQUESTSTEP_EQUESTSTEP_START_ACT_ENUM.name = "EQUESTSTEP_START_ACT"
EQUESTSTEP_EQUESTSTEP_START_ACT_ENUM.index = 104
EQUESTSTEP_EQUESTSTEP_START_ACT_ENUM.number = 108
EQUESTSTEP_EQUESTSTEP_CUT_SCENE_ENUM.name = "EQUESTSTEP_CUT_SCENE"
EQUESTSTEP_EQUESTSTEP_CUT_SCENE_ENUM.index = 105
EQUESTSTEP_EQUESTSTEP_CUT_SCENE_ENUM.number = 109
EQUESTSTEP_EQUESTSTEP_CHECKBORNMAP_ENUM.name = "EQUESTSTEP_CHECKBORNMAP"
EQUESTSTEP_EQUESTSTEP_CHECKBORNMAP_ENUM.index = 106
EQUESTSTEP_EQUESTSTEP_CHECKBORNMAP_ENUM.number = 110
EQUESTSTEP_EQUESTSTEP_PAPER_ENUM.name = "EQUESTSTEP_PAPER"
EQUESTSTEP_EQUESTSTEP_PAPER_ENUM.index = 107
EQUESTSTEP_EQUESTSTEP_PAPER_ENUM.number = 111
EQUESTSTEP_EQUESTSTEP_RANDOM_TIP_ENUM.name = "EQUESTSTEP_RANDOM_TIP"
EQUESTSTEP_EQUESTSTEP_RANDOM_TIP_ENUM.index = 108
EQUESTSTEP_EQUESTSTEP_RANDOM_TIP_ENUM.number = 112
EQUESTSTEP_EQUESTSTEP_SHARE_ENUM.name = "EQUESTSTEP_SHARE"
EQUESTSTEP_EQUESTSTEP_SHARE_ENUM.index = 109
EQUESTSTEP_EQUESTSTEP_SHARE_ENUM.number = 113
EQUESTSTEP_EQUESTSTEP_TRANSIT_ENUM.name = "EQUESTSTEP_TRANSIT"
EQUESTSTEP_EQUESTSTEP_TRANSIT_ENUM.index = 110
EQUESTSTEP_EQUESTSTEP_TRANSIT_ENUM.number = 114
EQUESTSTEP_EQUESTSTEP_SHAKESCREEN_ENUM.name = "EQUESTSTEP_SHAKESCREEN"
EQUESTSTEP_EQUESTSTEP_SHAKESCREEN_ENUM.index = 111
EQUESTSTEP_EQUESTSTEP_SHAKESCREEN_ENUM.number = 115
EQUESTSTEP_EQUESTSTEP_ADDPICTURE_ENUM.name = "EQUESTSTEP_ADDPICTURE"
EQUESTSTEP_EQUESTSTEP_ADDPICTURE_ENUM.index = 112
EQUESTSTEP_EQUESTSTEP_ADDPICTURE_ENUM.number = 116
EQUESTSTEP_EQUESTSTEP_DELPICTURE_ENUM.name = "EQUESTSTEP_DELPICTURE"
EQUESTSTEP_EQUESTSTEP_DELPICTURE_ENUM.index = 113
EQUESTSTEP_EQUESTSTEP_DELPICTURE_ENUM.number = 117
EQUESTSTEP_EQUESTSTEP_CHECK_LIGHT_PUZZLE_ENUM.name = "EQUESTSTEP_CHECK_LIGHT_PUZZLE"
EQUESTSTEP_EQUESTSTEP_CHECK_LIGHT_PUZZLE_ENUM.index = 114
EQUESTSTEP_EQUESTSTEP_CHECK_LIGHT_PUZZLE_ENUM.number = 118
EQUESTSTEP_EQUESTSTEP_PARTNER_MOVE_ENUM.name = "EQUESTSTEP_PARTNER_MOVE"
EQUESTSTEP_EQUESTSTEP_PARTNER_MOVE_ENUM.index = 115
EQUESTSTEP_EQUESTSTEP_PARTNER_MOVE_ENUM.number = 119
EQUESTSTEP_EQUESTSTEP_WAITCLIENT_ENUM.name = "EQUESTSTEP_WAITCLIENT"
EQUESTSTEP_EQUESTSTEP_WAITCLIENT_ENUM.index = 116
EQUESTSTEP_EQUESTSTEP_WAITCLIENT_ENUM.number = 120
EQUESTSTEP_EQUESTSTEP_TAPPING_ENUM.name = "EQUESTSTEP_TAPPING"
EQUESTSTEP_EQUESTSTEP_TAPPING_ENUM.index = 117
EQUESTSTEP_EQUESTSTEP_TAPPING_ENUM.number = 121
EQUESTSTEP_EQUESTSTEP_JOINT_REASON_ENUM.name = "EQUESTSTEP_JOINT_REASON"
EQUESTSTEP_EQUESTSTEP_JOINT_REASON_ENUM.index = 118
EQUESTSTEP_EQUESTSTEP_JOINT_REASON_ENUM.number = 123
EQUESTSTEP_EQUESTSTEP_AIEVENT_ENUM.name = "EQUESTSTEP_AIEVENT"
EQUESTSTEP_EQUESTSTEP_AIEVENT_ENUM.index = 119
EQUESTSTEP_EQUESTSTEP_AIEVENT_ENUM.number = 124
EQUESTSTEP_EQUESTSTEP_FOLLOWNPC_ENUM.name = "EQUESTSTEP_FOLLOWNPC"
EQUESTSTEP_EQUESTSTEP_FOLLOWNPC_ENUM.index = 120
EQUESTSTEP_EQUESTSTEP_FOLLOWNPC_ENUM.number = 125
EQUESTSTEP_EQUESTSTEP_MIND_ENTER_ENUM.name = "EQUESTSTEP_MIND_ENTER"
EQUESTSTEP_EQUESTSTEP_MIND_ENTER_ENUM.index = 121
EQUESTSTEP_EQUESTSTEP_MIND_ENTER_ENUM.number = 126
EQUESTSTEP_EQUESTSTEP_SHOW_EVIDENCE_ENUM.name = "EQUESTSTEP_SHOW_EVIDENCE"
EQUESTSTEP_EQUESTSTEP_SHOW_EVIDENCE_ENUM.index = 122
EQUESTSTEP_EQUESTSTEP_SHOW_EVIDENCE_ENUM.number = 127
EQUESTSTEP_EQUESTSTEP_MIND_EXIT_ENUM.name = "EQUESTSTEP_MIND_EXIT"
EQUESTSTEP_EQUESTSTEP_MIND_EXIT_ENUM.index = 123
EQUESTSTEP_EQUESTSTEP_MIND_EXIT_ENUM.number = 128
EQUESTSTEP_EQUESTSTEP_MIND_UNLOCK_PERFORM_ENUM.name = "EQUESTSTEP_MIND_UNLOCK_PERFORM"
EQUESTSTEP_EQUESTSTEP_MIND_UNLOCK_PERFORM_ENUM.index = 124
EQUESTSTEP_EQUESTSTEP_MIND_UNLOCK_PERFORM_ENUM.number = 129
EQUESTSTEP_EQUESTSTEP_RANDOM_BUFF_ENUM.name = "EQUESTSTEP_RANDOM_BUFF"
EQUESTSTEP_EQUESTSTEP_RANDOM_BUFF_ENUM.index = 125
EQUESTSTEP_EQUESTSTEP_RANDOM_BUFF_ENUM.number = 130
EQUESTSTEP_EQUESTSTEP_MULTICUTSCENE_ENUM.name = "EQUESTSTEP_MULTICUTSCENE"
EQUESTSTEP_EQUESTSTEP_MULTICUTSCENE_ENUM.index = 126
EQUESTSTEP_EQUESTSTEP_MULTICUTSCENE_ENUM.number = 131
EQUESTSTEP_EQUESTSTEP_KILL_SPECIALNPC_ENUM.name = "EQUESTSTEP_KILL_SPECIALNPC"
EQUESTSTEP_EQUESTSTEP_KILL_SPECIALNPC_ENUM.index = 127
EQUESTSTEP_EQUESTSTEP_KILL_SPECIALNPC_ENUM.number = 132
EQUESTSTEP_EQUESTSTEP_WAITUI_ENUM.name = "EQUESTSTEP_WAITUI"
EQUESTSTEP_EQUESTSTEP_WAITUI_ENUM.index = 128
EQUESTSTEP_EQUESTSTEP_WAITUI_ENUM.number = 133
EQUESTSTEP_EQUESTSTEP_LOAD_CLIENT_RAID_ENUM.name = "EQUESTSTEP_LOAD_CLIENT_RAID"
EQUESTSTEP_EQUESTSTEP_LOAD_CLIENT_RAID_ENUM.index = 129
EQUESTSTEP_EQUESTSTEP_LOAD_CLIENT_RAID_ENUM.number = 134
EQUESTSTEP_EQUESTSTEP_CLIENT_RAID_PASS_ENUM.name = "EQUESTSTEP_CLIENT_RAID_PASS"
EQUESTSTEP_EQUESTSTEP_CLIENT_RAID_PASS_ENUM.index = 130
EQUESTSTEP_EQUESTSTEP_CLIENT_RAID_PASS_ENUM.number = 135
EQUESTSTEP_EQUESTSTEP_SELFIE_SYS_ENUM.name = "EQUESTSTEP_SELFIE_SYS"
EQUESTSTEP_EQUESTSTEP_SELFIE_SYS_ENUM.index = 131
EQUESTSTEP_EQUESTSTEP_SELFIE_SYS_ENUM.number = 136
EQUESTSTEP_EQUESTSTEP_LOCK_BROKEN_ENUM.name = "EQUESTSTEP_LOCK_BROKEN"
EQUESTSTEP_EQUESTSTEP_LOCK_BROKEN_ENUM.index = 132
EQUESTSTEP_EQUESTSTEP_LOCK_BROKEN_ENUM.number = 137
EQUESTSTEP_EQUESTSTEP_PLAY_ACTION_ENUM.name = "EQUESTSTEP_PLAY_ACTION"
EQUESTSTEP_EQUESTSTEP_PLAY_ACTION_ENUM.index = 133
EQUESTSTEP_EQUESTSTEP_PLAY_ACTION_ENUM.number = 138
EQUESTSTEP_EQUESTSTEP_PLAY_EFFECT_ENUM.name = "EQUESTSTEP_PLAY_EFFECT"
EQUESTSTEP_EQUESTSTEP_PLAY_EFFECT_ENUM.index = 134
EQUESTSTEP_EQUESTSTEP_PLAY_EFFECT_ENUM.number = 139
EQUESTSTEP_EQUESTSTEP_CHECK_EVIDENCE_ENUM.name = "EQUESTSTEP_CHECK_EVIDENCE"
EQUESTSTEP_EQUESTSTEP_CHECK_EVIDENCE_ENUM.index = 135
EQUESTSTEP_EQUESTSTEP_CHECK_EVIDENCE_ENUM.number = 140
EQUESTSTEP_EQUESTSTEP_EDITOR_ENUM.name = "EQUESTSTEP_EDITOR"
EQUESTSTEP_EQUESTSTEP_EDITOR_ENUM.index = 136
EQUESTSTEP_EQUESTSTEP_EDITOR_ENUM.number = 141
EQUESTSTEP_EQUESTSTEP_MUSIC_GAME_ENUM.name = "EQUESTSTEP_MUSIC_GAME"
EQUESTSTEP_EQUESTSTEP_MUSIC_GAME_ENUM.index = 137
EQUESTSTEP_EQUESTSTEP_MUSIC_GAME_ENUM.number = 142
EQUESTSTEP_EQUESTSTEP_CHECK_CLEAR_END_ENUM.name = "EQUESTSTEP_CHECK_CLEAR_END"
EQUESTSTEP_EQUESTSTEP_CHECK_CLEAR_END_ENUM.index = 138
EQUESTSTEP_EQUESTSTEP_CHECK_CLEAR_END_ENUM.number = 143
EQUESTSTEP_EQUESTSTEP_MENU_ENUM.name = "EQUESTSTEP_MENU"
EQUESTSTEP_EQUESTSTEP_MENU_ENUM.index = 139
EQUESTSTEP_EQUESTSTEP_MENU_ENUM.number = 144
EQUESTSTEP_EQUESTSTEP_EXCHANGE_ENUM.name = "EQUESTSTEP_EXCHANGE"
EQUESTSTEP_EQUESTSTEP_EXCHANGE_ENUM.index = 140
EQUESTSTEP_EQUESTSTEP_EXCHANGE_ENUM.number = 145
EQUESTSTEP_EQUESTSTEP_GRACE_REWARD_ENUM.name = "EQUESTSTEP_GRACE_REWARD"
EQUESTSTEP_EQUESTSTEP_GRACE_REWARD_ENUM.index = 141
EQUESTSTEP_EQUESTSTEP_GRACE_REWARD_ENUM.number = 146
EQUESTSTEP_EQUESTSTEP_SMITHY_LEVEL_ENUM.name = "EQUESTSTEP_SMITHY_LEVEL"
EQUESTSTEP_EQUESTSTEP_SMITHY_LEVEL_ENUM.index = 142
EQUESTSTEP_EQUESTSTEP_SMITHY_LEVEL_ENUM.number = 147
EQUESTSTEP_EQUESTSTEP_POSTCARD_ENUM.name = "EQUESTSTEP_POSTCARD"
EQUESTSTEP_EQUESTSTEP_POSTCARD_ENUM.index = 143
EQUESTSTEP_EQUESTSTEP_POSTCARD_ENUM.number = 148
EQUESTSTEP_EQUESTSTEP_CHECK_MENU_ENUM.name = "EQUESTSTEP_CHECK_MENU"
EQUESTSTEP_EQUESTSTEP_CHECK_MENU_ENUM.index = 144
EQUESTSTEP_EQUESTSTEP_CHECK_MENU_ENUM.number = 149
EQUESTSTEP_EQUESTSTEP_NEW_CHAPTER_ENUM.name = "EQUESTSTEP_NEW_CHAPTER"
EQUESTSTEP_EQUESTSTEP_NEW_CHAPTER_ENUM.index = 145
EQUESTSTEP_EQUESTSTEP_NEW_CHAPTER_ENUM.number = 150
EQUESTSTEP_EQUESTSTEP_INTERACT_LOACL_AI_ENUM.name = "EQUESTSTEP_INTERACT_LOACL_AI"
EQUESTSTEP_EQUESTSTEP_INTERACT_LOACL_AI_ENUM.index = 146
EQUESTSTEP_EQUESTSTEP_INTERACT_LOACL_AI_ENUM.number = 151
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_AI_ENUM.name = "EQUESTSTEP_REMOVE_LOACL_AI"
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_AI_ENUM.index = 147
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_AI_ENUM.number = 152
EQUESTSTEP_EQUESTSTEP_INTERACT_LOCAL_VISIT_ENUM.name = "EQUESTSTEP_INTERACT_LOCAL_VISIT"
EQUESTSTEP_EQUESTSTEP_INTERACT_LOCAL_VISIT_ENUM.index = 148
EQUESTSTEP_EQUESTSTEP_INTERACT_LOCAL_VISIT_ENUM.number = 153
EQUESTSTEP_EQUESTSTEP_ADD_LOACL_INTERACT_ENUM.name = "EQUESTSTEP_ADD_LOACL_INTERACT"
EQUESTSTEP_EQUESTSTEP_ADD_LOACL_INTERACT_ENUM.index = 149
EQUESTSTEP_EQUESTSTEP_ADD_LOACL_INTERACT_ENUM.number = 154
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_INTERACT_ENUM.name = "EQUESTSTEP_REMOVE_LOACL_INTERACT"
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_INTERACT_ENUM.index = 150
EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_INTERACT_ENUM.number = 155
EQUESTSTEP_EQUESTSTEP_INTERACT_NPC_ENUM.name = "EQUESTSTEP_INTERACT_NPC"
EQUESTSTEP_EQUESTSTEP_INTERACT_NPC_ENUM.index = 151
EQUESTSTEP_EQUESTSTEP_INTERACT_NPC_ENUM.number = 156
EQUESTSTEP_EQUESTSTEP_INTERACT_MULTI_NPC_ENUM.name = "EQUESTSTEP_INTERACT_MULTI_NPC"
EQUESTSTEP_EQUESTSTEP_INTERACT_MULTI_NPC_ENUM.index = 152
EQUESTSTEP_EQUESTSTEP_INTERACT_MULTI_NPC_ENUM.number = 157
EQUESTSTEP_EQUESTSTEP_TAKE_SEAT_ENUM.name = "EQUESTSTEP_TAKE_SEAT"
EQUESTSTEP_EQUESTSTEP_TAKE_SEAT_ENUM.index = 153
EQUESTSTEP_EQUESTSTEP_TAKE_SEAT_ENUM.number = 158
EQUESTSTEP_EQUESTSTEP_CHECKTRANSFER_ENUM.name = "EQUESTSTEP_CHECKTRANSFER"
EQUESTSTEP_EQUESTSTEP_CHECKTRANSFER_ENUM.index = 154
EQUESTSTEP_EQUESTSTEP_CHECKTRANSFER_ENUM.number = 159
EQUESTSTEP_EQUESTSTEP_STAR_ARK_ENUM.name = "EQUESTSTEP_STAR_ARK"
EQUESTSTEP_EQUESTSTEP_STAR_ARK_ENUM.index = 155
EQUESTSTEP_EQUESTSTEP_STAR_ARK_ENUM.number = 160
EQUESTSTEP_EQUESTSTEP_CHECK_MULTI_QUEST_ENUM.name = "EQUESTSTEP_CHECK_MULTI_QUEST"
EQUESTSTEP_EQUESTSTEP_CHECK_MULTI_QUEST_ENUM.index = 156
EQUESTSTEP_EQUESTSTEP_CHECK_MULTI_QUEST_ENUM.number = 161
EQUESTSTEP_EQUESTSTEP_CHECK_HOME_ENUM.name = "EQUESTSTEP_CHECK_HOME"
EQUESTSTEP_EQUESTSTEP_CHECK_HOME_ENUM.index = 157
EQUESTSTEP_EQUESTSTEP_CHECK_HOME_ENUM.number = 162
EQUESTSTEP_EQUESTSTEP_NPC_BUFF_ENUM.name = "EQUESTSTEP_NPC_BUFF"
EQUESTSTEP_EQUESTSTEP_NPC_BUFF_ENUM.index = 158
EQUESTSTEP_EQUESTSTEP_NPC_BUFF_ENUM.number = 163
EQUESTSTEP_EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL_ENUM.name = "EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL"
EQUESTSTEP_EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL_ENUM.index = 159
EQUESTSTEP_EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL_ENUM.number = 164
EQUESTSTEP_EQUESTSTEP_ACTIVATE_TRANSFER_ENUM.name = "EQUESTSTEP_ACTIVATE_TRANSFER"
EQUESTSTEP_EQUESTSTEP_ACTIVATE_TRANSFER_ENUM.index = 160
EQUESTSTEP_EQUESTSTEP_ACTIVATE_TRANSFER_ENUM.number = 165
EQUESTSTEP_EQUESTSTEP_ITEM_COUNT_ENUM.name = "EQUESTSTEP_ITEM_COUNT"
EQUESTSTEP_EQUESTSTEP_ITEM_COUNT_ENUM.index = 161
EQUESTSTEP_EQUESTSTEP_ITEM_COUNT_ENUM.number = 166
EQUESTSTEP_EQUESTSTEP_ITEM_NUM_ENUM.name = "EQUESTSTEP_ITEM_NUM"
EQUESTSTEP_EQUESTSTEP_ITEM_NUM_ENUM.index = 162
EQUESTSTEP_EQUESTSTEP_ITEM_NUM_ENUM.number = 167
EQUESTSTEP_EQUESTSTEP_EFFECT_ENUM.name = "EQUESTSTEP_EFFECT"
EQUESTSTEP_EQUESTSTEP_EFFECT_ENUM.index = 163
EQUESTSTEP_EQUESTSTEP_EFFECT_ENUM.number = 168
EQUESTSTEP_EQUESTSTEP_EQUIP_ENUM.name = "EQUESTSTEP_EQUIP"
EQUESTSTEP_EQUESTSTEP_EQUIP_ENUM.index = 164
EQUESTSTEP_EQUESTSTEP_EQUIP_ENUM.number = 170
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_ENUM.name = "EQUESTSTEP_BATTLE_FIELD"
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_ENUM.index = 165
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_ENUM.number = 171
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_AREA_ENUM.name = "EQUESTSTEP_BATTLE_FIELD_AREA"
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_AREA_ENUM.index = 166
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_AREA_ENUM.number = 172
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_WIN_ENUM.name = "EQUESTSTEP_BATTLE_FIELD_WIN"
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_WIN_ENUM.index = 167
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_WIN_ENUM.number = 173
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_STATUE_ENUM.name = "EQUESTSTEP_BATTLE_FIELD_STATUE"
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_STATUE_ENUM.index = 168
EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_STATUE_ENUM.number = 174
EQUESTSTEP_EQUESTSTEP_CLIENT_DELAY_ENUM.name = "EQUESTSTEP_CLIENT_DELAY"
EQUESTSTEP_EQUESTSTEP_CLIENT_DELAY_ENUM.index = 169
EQUESTSTEP_EQUESTSTEP_CLIENT_DELAY_ENUM.number = 175
EQUESTSTEP_EQUESTSTEP_INHERITSKILL_ENUM.name = "EQUESTSTEP_INHERITSKILL"
EQUESTSTEP_EQUESTSTEP_INHERITSKILL_ENUM.index = 170
EQUESTSTEP_EQUESTSTEP_INHERITSKILL_ENUM.number = 176
EQUESTSTEP_EQUESTSTEP_MAX_ENUM.name = "EQUESTSTEP_MAX"
EQUESTSTEP_EQUESTSTEP_MAX_ENUM.index = 171
EQUESTSTEP_EQUESTSTEP_MAX_ENUM.number = 177
EQUESTSTEP.name = "EQuestStep"
EQUESTSTEP.full_name = ".Cmd.EQuestStep"
EQUESTSTEP.values = {
  EQUESTSTEP_EQUESTSTEP_MIN_ENUM,
  EQUESTSTEP_EQUESTSTEP_VISIT_ENUM,
  EQUESTSTEP_EQUESTSTEP_KILL_ENUM,
  EQUESTSTEP_EQUESTSTEP_REWARD_ENUM,
  EQUESTSTEP_EQUESTSTEP_COLLECT_ENUM,
  EQUESTSTEP_EQUESTSTEP_SUMMON_ENUM,
  EQUESTSTEP_EQUESTSTEP_GUARD_ENUM,
  EQUESTSTEP_EQUESTSTEP_GMCMD_ENUM,
  EQUESTSTEP_EQUESTSTEP_TESTFAIL_ENUM,
  EQUESTSTEP_EQUESTSTEP_USE_ENUM,
  EQUESTSTEP_EQUESTSTEP_GATHER_ENUM,
  EQUESTSTEP_EQUESTSTEP_DELETE_ENUM,
  EQUESTSTEP_EQUESTSTEP_RAID_ENUM,
  EQUESTSTEP_EQUESTSTEP_CAMERA_ENUM,
  EQUESTSTEP_EQUESTSTEP_LEVEL_ENUM,
  EQUESTSTEP_EQUESTSTEP_WAIT_ENUM,
  EQUESTSTEP_EQUESTSTEP_MOVE_ENUM,
  EQUESTSTEP_EQUESTSTEP_DIALOG_ENUM,
  EQUESTSTEP_EQUESTSTEP_PREQUEST_ENUM,
  EQUESTSTEP_EQUESTSTEP_CLEARNPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_MOUNTRIDE_ENUM,
  EQUESTSTEP_EQUESTSTEP_SELFIE_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKTEAM_ENUM,
  EQUESTSTEP_EQUESTSTEP_REMOVEMONEY_ENUM,
  EQUESTSTEP_EQUESTSTEP_CLASS_ENUM,
  EQUESTSTEP_EQUESTSTEP_ORGCLASS_ENUM,
  EQUESTSTEP_EQUESTSTEP_EVO_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKQUEST_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKITEM_ENUM,
  EQUESTSTEP_EQUESTSTEP_REMOVEITEM_ENUM,
  EQUESTSTEP_EQUESTSTEP_RANDOMJUMP_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKLEVEL_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKGEAR_ENUM,
  EQUESTSTEP_EQUESTSTEP_PURIFY_ENUM,
  EQUESTSTEP_EQUESTSTEP_ACTION_ENUM,
  EQUESTSTEP_EQUESTSTEP_SKILL_ENUM,
  EQUESTSTEP_EQUESTSTEP_INTERLOCUTION_ENUM,
  EQUESTSTEP_EQUESTSTEP_EMPTY_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKEQUIP_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKMONEY_ENUM,
  EQUESTSTEP_EQUESTSTEP_GUIDE_ENUM,
  EQUESTSTEP_EQUESTSTEP_GUIDE_CHECK_ENUM,
  EQUESTSTEP_EQUESTSTEP_GUIDE_HIGHLIGHT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKOPTION_ENUM,
  EQUESTSTEP_EQUESTSTEP_HINT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKGROUP_ENUM,
  EQUESTSTEP_EQUESTSTEP_SEAL_ENUM,
  EQUESTSTEP_EQUESTSTEP_EQUIPLV_ENUM,
  EQUESTSTEP_EQUESTSTEP_VIDEO_ENUM,
  EQUESTSTEP_EQUESTSTEP_ILLUSTRATION_ENUM,
  EQUESTSTEP_EQUESTSTEP_NPCPLAY_ENUM,
  EQUESTSTEP_EQUESTSTEP_ITEM_ENUM,
  EQUESTSTEP_EQUESTSTEP_DAILY_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_MANUAL_ENUM,
  EQUESTSTEP_EQUESTSTEP_MANUAL_ENUM,
  EQUESTSTEP_EQUESTSTEP_PLAY_MUSIC_ENUM,
  EQUESTSTEP_EQUESTSTEP_REWRADHELP_ENUM,
  EQUESTSTEP_EQUESTSTEP_GUIDELOCKMONSTER_ENUM,
  EQUESTSTEP_EQUESTSTEP_MONEY_ENUM,
  EQUESTSTEP_EQUESTSTEP_ACTIVITY_ENUM,
  EQUESTSTEP_EQUESTSTEP_OPTION_ENUM,
  EQUESTSTEP_EQUESTSTEP_PHOTO_ENUM,
  EQUESTSTEP_EQUESTSTEP_ITEMUSE_ENUM,
  EQUESTSTEP_EQUESTSTEP_HAND_ENUM,
  EQUESTSTEP_EQUESTSTEP_MUSIC_ENUM,
  EQUESTSTEP_EQUESTSTEP_RANDITEM_ENUM,
  EQUESTSTEP_EQUESTSTEP_CARRIER_ENUM,
  EQUESTSTEP_EQUESTSTEP_BATTLE_ENUM,
  EQUESTSTEP_EQUESTSTEP_COOKFOOD_ENUM,
  EQUESTSTEP_EQUESTSTEP_PET_ENUM,
  EQUESTSTEP_EQUESTSTEP_SCENE_ENUM,
  EQUESTSTEP_EQUESTSTEP_COOK_ENUM,
  EQUESTSTEP_EQUESTSTEP_BUFF_ENUM,
  EQUESTSTEP_EQUESTSTEP_TUTOR_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHRISTMAS_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHRISTMAS_RUN_ENUM,
  EQUESTSTEP_EQUESTSTEP_BEING_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_JOY_ENUM,
  EQUESTSTEP_EQUESTSTEP_ADD_JOY_ENUM,
  EQUESTSTEP_EQUESTSTEP_RAND_DIALOG_ENUM,
  EQUESTSTEP_EQUESTSTEP_CG_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKSERVANT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CLIENTPLOT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHAT_ENUM,
  EQUESTSTEP_EQUESTSTEP_TRANSFER_ENUM,
  EQUESTSTEP_EQUESTSTEP_REDIALOG_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHAT_SYSTEM_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_UNLOCKCAT_ENUM,
  EQUESTSTEP_EQUESTSTEP_GROUP_ENUM,
  EQUESTSTEP_EQUESTSTEP_NPCWALK_ENUM,
  EQUESTSTEP_EQUESTSTEP_NPCSKILL_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_HANDNPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_USESKILL_ENUM,
  EQUESTSTEP_EQUESTSTEP_NPCHP_ENUM,
  EQUESTSTEP_EQUESTSTEP_CAMERASHOW_ENUM,
  EQUESTSTEP_EQUESTSTEP_TIMEPHASING_ENUM,
  EQUESTSTEP_EQUESTSTEP_GAME_ENUM,
  EQUESTSTEP_EQUESTSTEP_KILLORDER_ENUM,
  EQUESTSTEP_EQUESTSTEP_PICTURE_ENUM,
  EQUESTSTEP_EQUESTSTEP_GAMECOUNT_ENUM,
  EQUESTSTEP_EQUESTSTEP_MAIL_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHOOSE_BRANCH_ENUM,
  EQUESTSTEP_EQUESTSTEP_WAITPOS_ENUM,
  EQUESTSTEP_EQUESTSTEP_SHOT_ENUM,
  EQUESTSTEP_EQUESTSTEP_START_ACT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CUT_SCENE_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKBORNMAP_ENUM,
  EQUESTSTEP_EQUESTSTEP_PAPER_ENUM,
  EQUESTSTEP_EQUESTSTEP_RANDOM_TIP_ENUM,
  EQUESTSTEP_EQUESTSTEP_SHARE_ENUM,
  EQUESTSTEP_EQUESTSTEP_TRANSIT_ENUM,
  EQUESTSTEP_EQUESTSTEP_SHAKESCREEN_ENUM,
  EQUESTSTEP_EQUESTSTEP_ADDPICTURE_ENUM,
  EQUESTSTEP_EQUESTSTEP_DELPICTURE_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_LIGHT_PUZZLE_ENUM,
  EQUESTSTEP_EQUESTSTEP_PARTNER_MOVE_ENUM,
  EQUESTSTEP_EQUESTSTEP_WAITCLIENT_ENUM,
  EQUESTSTEP_EQUESTSTEP_TAPPING_ENUM,
  EQUESTSTEP_EQUESTSTEP_JOINT_REASON_ENUM,
  EQUESTSTEP_EQUESTSTEP_AIEVENT_ENUM,
  EQUESTSTEP_EQUESTSTEP_FOLLOWNPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_MIND_ENTER_ENUM,
  EQUESTSTEP_EQUESTSTEP_SHOW_EVIDENCE_ENUM,
  EQUESTSTEP_EQUESTSTEP_MIND_EXIT_ENUM,
  EQUESTSTEP_EQUESTSTEP_MIND_UNLOCK_PERFORM_ENUM,
  EQUESTSTEP_EQUESTSTEP_RANDOM_BUFF_ENUM,
  EQUESTSTEP_EQUESTSTEP_MULTICUTSCENE_ENUM,
  EQUESTSTEP_EQUESTSTEP_KILL_SPECIALNPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_WAITUI_ENUM,
  EQUESTSTEP_EQUESTSTEP_LOAD_CLIENT_RAID_ENUM,
  EQUESTSTEP_EQUESTSTEP_CLIENT_RAID_PASS_ENUM,
  EQUESTSTEP_EQUESTSTEP_SELFIE_SYS_ENUM,
  EQUESTSTEP_EQUESTSTEP_LOCK_BROKEN_ENUM,
  EQUESTSTEP_EQUESTSTEP_PLAY_ACTION_ENUM,
  EQUESTSTEP_EQUESTSTEP_PLAY_EFFECT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_EVIDENCE_ENUM,
  EQUESTSTEP_EQUESTSTEP_EDITOR_ENUM,
  EQUESTSTEP_EQUESTSTEP_MUSIC_GAME_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_CLEAR_END_ENUM,
  EQUESTSTEP_EQUESTSTEP_MENU_ENUM,
  EQUESTSTEP_EQUESTSTEP_EXCHANGE_ENUM,
  EQUESTSTEP_EQUESTSTEP_GRACE_REWARD_ENUM,
  EQUESTSTEP_EQUESTSTEP_SMITHY_LEVEL_ENUM,
  EQUESTSTEP_EQUESTSTEP_POSTCARD_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_MENU_ENUM,
  EQUESTSTEP_EQUESTSTEP_NEW_CHAPTER_ENUM,
  EQUESTSTEP_EQUESTSTEP_INTERACT_LOACL_AI_ENUM,
  EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_AI_ENUM,
  EQUESTSTEP_EQUESTSTEP_INTERACT_LOCAL_VISIT_ENUM,
  EQUESTSTEP_EQUESTSTEP_ADD_LOACL_INTERACT_ENUM,
  EQUESTSTEP_EQUESTSTEP_REMOVE_LOACL_INTERACT_ENUM,
  EQUESTSTEP_EQUESTSTEP_INTERACT_NPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_INTERACT_MULTI_NPC_ENUM,
  EQUESTSTEP_EQUESTSTEP_TAKE_SEAT_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECKTRANSFER_ENUM,
  EQUESTSTEP_EQUESTSTEP_STAR_ARK_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_MULTI_QUEST_ENUM,
  EQUESTSTEP_EQUESTSTEP_CHECK_HOME_ENUM,
  EQUESTSTEP_EQUESTSTEP_NPC_BUFF_ENUM,
  EQUESTSTEP_EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL_ENUM,
  EQUESTSTEP_EQUESTSTEP_ACTIVATE_TRANSFER_ENUM,
  EQUESTSTEP_EQUESTSTEP_ITEM_COUNT_ENUM,
  EQUESTSTEP_EQUESTSTEP_ITEM_NUM_ENUM,
  EQUESTSTEP_EQUESTSTEP_EFFECT_ENUM,
  EQUESTSTEP_EQUESTSTEP_EQUIP_ENUM,
  EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_ENUM,
  EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_AREA_ENUM,
  EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_WIN_ENUM,
  EQUESTSTEP_EQUESTSTEP_BATTLE_FIELD_STATUE_ENUM,
  EQUESTSTEP_EQUESTSTEP_CLIENT_DELAY_ENUM,
  EQUESTSTEP_EQUESTSTEP_INHERITSKILL_ENUM,
  EQUESTSTEP_EQUESTSTEP_MAX_ENUM
}
ECLIENTTRACE_ECLIENTTYPE_TRUE_ENUM.name = "ECLIENTTYPE_TRUE"
ECLIENTTRACE_ECLIENTTYPE_TRUE_ENUM.index = 0
ECLIENTTRACE_ECLIENTTYPE_TRUE_ENUM.number = 1
ECLIENTTRACE_ECLIENTTYPE_FALSE_ENUM.name = "ECLIENTTYPE_FALSE"
ECLIENTTRACE_ECLIENTTYPE_FALSE_ENUM.index = 1
ECLIENTTRACE_ECLIENTTYPE_FALSE_ENUM.number = 2
ECLIENTTRACE_ECLIENTTYPE_FAKEFALSE_ENUM.name = "ECLIENTTYPE_FAKEFALSE"
ECLIENTTRACE_ECLIENTTYPE_FAKEFALSE_ENUM.index = 2
ECLIENTTRACE_ECLIENTTYPE_FAKEFALSE_ENUM.number = 3
ECLIENTTRACE.name = "EClientTrace"
ECLIENTTRACE.full_name = ".Cmd.EClientTrace"
ECLIENTTRACE.values = {
  ECLIENTTRACE_ECLIENTTYPE_TRUE_ENUM,
  ECLIENTTRACE_ECLIENTTYPE_FALSE_ENUM,
  ECLIENTTRACE_ECLIENTTYPE_FAKEFALSE_ENUM
}
EQUESTSTATUS_EQUESTSTATUS_MIN_ENUM.name = "EQUESTSTATUS_MIN"
EQUESTSTATUS_EQUESTSTATUS_MIN_ENUM.index = 0
EQUESTSTATUS_EQUESTSTATUS_MIN_ENUM.number = 0
EQUESTSTATUS_EQUESTSTATUS_TRUE_ENUM.name = "EQUESTSTATUS_TRUE"
EQUESTSTATUS_EQUESTSTATUS_TRUE_ENUM.index = 1
EQUESTSTATUS_EQUESTSTATUS_TRUE_ENUM.number = 1
EQUESTSTATUS_EQUESTSTATUS_FALSE_ENUM.name = "EQUESTSTATUS_FALSE"
EQUESTSTATUS_EQUESTSTATUS_FALSE_ENUM.index = 2
EQUESTSTATUS_EQUESTSTATUS_FALSE_ENUM.number = 2
EQUESTSTATUS_EQUESTSTATUS_FAKEFALSE_ENUM.name = "EQUESTSTATUS_FAKEFALSE"
EQUESTSTATUS_EQUESTSTATUS_FAKEFALSE_ENUM.index = 3
EQUESTSTATUS_EQUESTSTATUS_FAKEFALSE_ENUM.number = 3
EQUESTSTATUS_EQUESTSTATUS_MAX_ENUM.name = "EQUESTSTATUS_MAX"
EQUESTSTATUS_EQUESTSTATUS_MAX_ENUM.index = 4
EQUESTSTATUS_EQUESTSTATUS_MAX_ENUM.number = 4
EQUESTSTATUS.name = "EQuestStatus"
EQUESTSTATUS.full_name = ".Cmd.EQuestStatus"
EQUESTSTATUS.values = {
  EQUESTSTATUS_EQUESTSTATUS_MIN_ENUM,
  EQUESTSTATUS_EQUESTSTATUS_TRUE_ENUM,
  EQUESTSTATUS_EQUESTSTATUS_FALSE_ENUM,
  EQUESTSTATUS_EQUESTSTATUS_FAKEFALSE_ENUM,
  EQUESTSTATUS_EQUESTSTATUS_MAX_ENUM
}
EQUESTLIST_EQUESTLIST_MIN_ENUM.name = "EQUESTLIST_MIN"
EQUESTLIST_EQUESTLIST_MIN_ENUM.index = 0
EQUESTLIST_EQUESTLIST_MIN_ENUM.number = 0
EQUESTLIST_EQUESTLIST_ACCEPT_ENUM.name = "EQUESTLIST_ACCEPT"
EQUESTLIST_EQUESTLIST_ACCEPT_ENUM.index = 1
EQUESTLIST_EQUESTLIST_ACCEPT_ENUM.number = 1
EQUESTLIST_EQUESTLIST_SUBMIT_ENUM.name = "EQUESTLIST_SUBMIT"
EQUESTLIST_EQUESTLIST_SUBMIT_ENUM.index = 2
EQUESTLIST_EQUESTLIST_SUBMIT_ENUM.number = 2
EQUESTLIST_EQUESTLIST_COMPLETE_ENUM.name = "EQUESTLIST_COMPLETE"
EQUESTLIST_EQUESTLIST_COMPLETE_ENUM.index = 3
EQUESTLIST_EQUESTLIST_COMPLETE_ENUM.number = 3
EQUESTLIST_EQUESTLIST_CANACCEPT_ENUM.name = "EQUESTLIST_CANACCEPT"
EQUESTLIST_EQUESTLIST_CANACCEPT_ENUM.index = 4
EQUESTLIST_EQUESTLIST_CANACCEPT_ENUM.number = 4
EQUESTLIST_EQUESTLIST_MAX_ENUM.name = "EQUESTLIST_MAX"
EQUESTLIST_EQUESTLIST_MAX_ENUM.index = 5
EQUESTLIST_EQUESTLIST_MAX_ENUM.number = 5
EQUESTLIST.name = "EQuestList"
EQUESTLIST.full_name = ".Cmd.EQuestList"
EQUESTLIST.values = {
  EQUESTLIST_EQUESTLIST_MIN_ENUM,
  EQUESTLIST_EQUESTLIST_ACCEPT_ENUM,
  EQUESTLIST_EQUESTLIST_SUBMIT_ENUM,
  EQUESTLIST_EQUESTLIST_COMPLETE_ENUM,
  EQUESTLIST_EQUESTLIST_CANACCEPT_ENUM,
  EQUESTLIST_EQUESTLIST_MAX_ENUM
}
EQUESTACTION_EQUESTACTION_MIN_ENUM.name = "EQUESTACTION_MIN"
EQUESTACTION_EQUESTACTION_MIN_ENUM.index = 0
EQUESTACTION_EQUESTACTION_MIN_ENUM.number = 0
EQUESTACTION_EQUESTACTION_ACCEPT_ENUM.name = "EQUESTACTION_ACCEPT"
EQUESTACTION_EQUESTACTION_ACCEPT_ENUM.index = 1
EQUESTACTION_EQUESTACTION_ACCEPT_ENUM.number = 1
EQUESTACTION_EQUESTACTION_SUBMIT_ENUM.name = "EQUESTACTION_SUBMIT"
EQUESTACTION_EQUESTACTION_SUBMIT_ENUM.index = 2
EQUESTACTION_EQUESTACTION_SUBMIT_ENUM.number = 2
EQUESTACTION_EQUESTACTION_ABANDON_GROUP_ENUM.name = "EQUESTACTION_ABANDON_GROUP"
EQUESTACTION_EQUESTACTION_ABANDON_GROUP_ENUM.index = 3
EQUESTACTION_EQUESTACTION_ABANDON_GROUP_ENUM.number = 3
EQUESTACTION_EQUESTACTION_ABANDON_QUEST_ENUM.name = "EQUESTACTION_ABANDON_QUEST"
EQUESTACTION_EQUESTACTION_ABANDON_QUEST_ENUM.index = 4
EQUESTACTION_EQUESTACTION_ABANDON_QUEST_ENUM.number = 4
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_ENUM.name = "EQUESTACTION_QUICK_SUBMIT_BOARD"
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_ENUM.index = 5
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_ENUM.number = 5
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM_ENUM.name = "EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM"
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM_ENUM.index = 6
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM_ENUM.number = 6
EQUESTACTION_EQUESTACTION_REPAIR_ENUM.name = "EQUESTACTION_REPAIR"
EQUESTACTION_EQUESTACTION_REPAIR_ENUM.index = 7
EQUESTACTION_EQUESTACTION_REPAIR_ENUM.number = 7
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_ABYSS_ENUM.name = "EQUESTACTION_QUICK_SUBMIT_ABYSS"
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_ABYSS_ENUM.index = 8
EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_ABYSS_ENUM.number = 8
EQUESTACTION_EQUESTACTION_MAX_ENUM.name = "EQUESTACTION_MAX"
EQUESTACTION_EQUESTACTION_MAX_ENUM.index = 9
EQUESTACTION_EQUESTACTION_MAX_ENUM.number = 9
EQUESTACTION.name = "EQuestAction"
EQUESTACTION.full_name = ".Cmd.EQuestAction"
EQUESTACTION.values = {
  EQUESTACTION_EQUESTACTION_MIN_ENUM,
  EQUESTACTION_EQUESTACTION_ACCEPT_ENUM,
  EQUESTACTION_EQUESTACTION_SUBMIT_ENUM,
  EQUESTACTION_EQUESTACTION_ABANDON_GROUP_ENUM,
  EQUESTACTION_EQUESTACTION_ABANDON_QUEST_ENUM,
  EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_ENUM,
  EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM_ENUM,
  EQUESTACTION_EQUESTACTION_REPAIR_ENUM,
  EQUESTACTION_EQUESTACTION_QUICK_SUBMIT_ABYSS_ENUM,
  EQUESTACTION_EQUESTACTION_MAX_ENUM
}
EOTHERDATA_EOTHERDATA_MIN_ENUM.name = "EOTHERDATA_MIN"
EOTHERDATA_EOTHERDATA_MIN_ENUM.index = 0
EOTHERDATA_EOTHERDATA_MIN_ENUM.number = 0
EOTHERDATA_EOTHERDATA_DAILY_ENUM.name = "EOTHERDATA_DAILY"
EOTHERDATA_EOTHERDATA_DAILY_ENUM.index = 1
EOTHERDATA_EOTHERDATA_DAILY_ENUM.number = 1
EOTHERDATA_EOTHERDATA_CAT_ENUM.name = "EOTHERDATA_CAT"
EOTHERDATA_EOTHERDATA_CAT_ENUM.index = 2
EOTHERDATA_EOTHERDATA_CAT_ENUM.number = 2
EOTHERDATA_EOTHERDATA_WORLDTREASURE_ENUM.name = "EOTHERDATA_WORLDTREASURE"
EOTHERDATA_EOTHERDATA_WORLDTREASURE_ENUM.index = 3
EOTHERDATA_EOTHERDATA_WORLDTREASURE_ENUM.number = 3
EOTHERDATA_EOTHERDATA_MAX_ENUM.name = "EOTHERDATA_MAX"
EOTHERDATA_EOTHERDATA_MAX_ENUM.index = 4
EOTHERDATA_EOTHERDATA_MAX_ENUM.number = 4
EOTHERDATA.name = "EOtherData"
EOTHERDATA.full_name = ".Cmd.EOtherData"
EOTHERDATA.values = {
  EOTHERDATA_EOTHERDATA_MIN_ENUM,
  EOTHERDATA_EOTHERDATA_DAILY_ENUM,
  EOTHERDATA_EOTHERDATA_CAT_ENUM,
  EOTHERDATA_EOTHERDATA_WORLDTREASURE_ENUM,
  EOTHERDATA_EOTHERDATA_MAX_ENUM
}
EJOYACTIVITYTYPE_JOY_ACTIVITY_MIN_ENUM.name = "JOY_ACTIVITY_MIN"
EJOYACTIVITYTYPE_JOY_ACTIVITY_MIN_ENUM.index = 0
EJOYACTIVITYTYPE_JOY_ACTIVITY_MIN_ENUM.number = 0
EJOYACTIVITYTYPE_JOY_ACTIVITY_GUESS_ENUM.name = "JOY_ACTIVITY_GUESS"
EJOYACTIVITYTYPE_JOY_ACTIVITY_GUESS_ENUM.index = 1
EJOYACTIVITYTYPE_JOY_ACTIVITY_GUESS_ENUM.number = 1
EJOYACTIVITYTYPE_JOY_ACTIVITY_MISCHIEF_ENUM.name = "JOY_ACTIVITY_MISCHIEF"
EJOYACTIVITYTYPE_JOY_ACTIVITY_MISCHIEF_ENUM.index = 2
EJOYACTIVITYTYPE_JOY_ACTIVITY_MISCHIEF_ENUM.number = 2
EJOYACTIVITYTYPE_JOY_ACTIVITY_QUESTION_ENUM.name = "JOY_ACTIVITY_QUESTION"
EJOYACTIVITYTYPE_JOY_ACTIVITY_QUESTION_ENUM.index = 3
EJOYACTIVITYTYPE_JOY_ACTIVITY_QUESTION_ENUM.number = 3
EJOYACTIVITYTYPE_JOY_ACTIVITY_FOOD_ENUM.name = "JOY_ACTIVITY_FOOD"
EJOYACTIVITYTYPE_JOY_ACTIVITY_FOOD_ENUM.index = 4
EJOYACTIVITYTYPE_JOY_ACTIVITY_FOOD_ENUM.number = 4
EJOYACTIVITYTYPE_JOY_ACTIVITY_YOYO_ENUM.name = "JOY_ACTIVITY_YOYO"
EJOYACTIVITYTYPE_JOY_ACTIVITY_YOYO_ENUM.index = 5
EJOYACTIVITYTYPE_JOY_ACTIVITY_YOYO_ENUM.number = 5
EJOYACTIVITYTYPE_JOY_ACTIVITY_ATF_ENUM.name = "JOY_ACTIVITY_ATF"
EJOYACTIVITYTYPE_JOY_ACTIVITY_ATF_ENUM.index = 6
EJOYACTIVITYTYPE_JOY_ACTIVITY_ATF_ENUM.number = 6
EJOYACTIVITYTYPE_JOY_ACTIVITY_AUGURY_ENUM.name = "JOY_ACTIVITY_AUGURY"
EJOYACTIVITYTYPE_JOY_ACTIVITY_AUGURY_ENUM.index = 7
EJOYACTIVITYTYPE_JOY_ACTIVITY_AUGURY_ENUM.number = 7
EJOYACTIVITYTYPE_JOY_ACTIVITY_PHOTO_ENUM.name = "JOY_ACTIVITY_PHOTO"
EJOYACTIVITYTYPE_JOY_ACTIVITY_PHOTO_ENUM.index = 8
EJOYACTIVITYTYPE_JOY_ACTIVITY_PHOTO_ENUM.number = 8
EJOYACTIVITYTYPE_JOY_ACTIVITY_BEATPORI_ENUM.name = "JOY_ACTIVITY_BEATPORI"
EJOYACTIVITYTYPE_JOY_ACTIVITY_BEATPORI_ENUM.index = 9
EJOYACTIVITYTYPE_JOY_ACTIVITY_BEATPORI_ENUM.number = 9
EJOYACTIVITYTYPE_JOY_ACTIVITY_MAX_ENUM.name = "JOY_ACTIVITY_MAX"
EJOYACTIVITYTYPE_JOY_ACTIVITY_MAX_ENUM.index = 10
EJOYACTIVITYTYPE_JOY_ACTIVITY_MAX_ENUM.number = 10
EJOYACTIVITYTYPE.name = "EJoyActivityType"
EJOYACTIVITYTYPE.full_name = ".Cmd.EJoyActivityType"
EJOYACTIVITYTYPE.values = {
  EJOYACTIVITYTYPE_JOY_ACTIVITY_MIN_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_GUESS_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_MISCHIEF_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_QUESTION_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_FOOD_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_YOYO_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_ATF_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_AUGURY_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_PHOTO_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_BEATPORI_ENUM,
  EJOYACTIVITYTYPE_JOY_ACTIVITY_MAX_ENUM
}
EBOTTLESTATUS_EBOTTLESTATUS_MIN_ENUM.name = "EBOTTLESTATUS_MIN"
EBOTTLESTATUS_EBOTTLESTATUS_MIN_ENUM.index = 0
EBOTTLESTATUS_EBOTTLESTATUS_MIN_ENUM.number = 0
EBOTTLESTATUS_EBOTTLESTATUS_ACCEPT_ENUM.name = "EBOTTLESTATUS_ACCEPT"
EBOTTLESTATUS_EBOTTLESTATUS_ACCEPT_ENUM.index = 1
EBOTTLESTATUS_EBOTTLESTATUS_ACCEPT_ENUM.number = 1
EBOTTLESTATUS_EBOTTLESTATUS_FINISH_ENUM.name = "EBOTTLESTATUS_FINISH"
EBOTTLESTATUS_EBOTTLESTATUS_FINISH_ENUM.index = 2
EBOTTLESTATUS_EBOTTLESTATUS_FINISH_ENUM.number = 2
EBOTTLESTATUS_EBOTTLESTATUS_MAX_ENUM.name = "EBOTTLESTATUS_MAX"
EBOTTLESTATUS_EBOTTLESTATUS_MAX_ENUM.index = 3
EBOTTLESTATUS_EBOTTLESTATUS_MAX_ENUM.number = 3
EBOTTLESTATUS.name = "EBottleStatus"
EBOTTLESTATUS.full_name = ".Cmd.EBottleStatus"
EBOTTLESTATUS.values = {
  EBOTTLESTATUS_EBOTTLESTATUS_MIN_ENUM,
  EBOTTLESTATUS_EBOTTLESTATUS_ACCEPT_ENUM,
  EBOTTLESTATUS_EBOTTLESTATUS_FINISH_ENUM,
  EBOTTLESTATUS_EBOTTLESTATUS_MAX_ENUM
}
EBOTTLEACTION_EBOTTLEACTION_MIN_ENUM.name = "EBOTTLEACTION_MIN"
EBOTTLEACTION_EBOTTLEACTION_MIN_ENUM.index = 0
EBOTTLEACTION_EBOTTLEACTION_MIN_ENUM.number = 0
EBOTTLEACTION_EBOTTLEACTION_ACCEPT_ENUM.name = "EBOTTLEACTION_ACCEPT"
EBOTTLEACTION_EBOTTLEACTION_ACCEPT_ENUM.index = 1
EBOTTLEACTION_EBOTTLEACTION_ACCEPT_ENUM.number = 1
EBOTTLEACTION_EBOTTLEACTION_ABANDON_ENUM.name = "EBOTTLEACTION_ABANDON"
EBOTTLEACTION_EBOTTLEACTION_ABANDON_ENUM.index = 2
EBOTTLEACTION_EBOTTLEACTION_ABANDON_ENUM.number = 2
EBOTTLEACTION_EBOTTLEACTION_FINISH_ENUM.name = "EBOTTLEACTION_FINISH"
EBOTTLEACTION_EBOTTLEACTION_FINISH_ENUM.index = 3
EBOTTLEACTION_EBOTTLEACTION_FINISH_ENUM.number = 3
EBOTTLEACTION_EBOTTLEACTION_MAX_ENUM.name = "EBOTTLEACTION_MAX"
EBOTTLEACTION_EBOTTLEACTION_MAX_ENUM.index = 4
EBOTTLEACTION_EBOTTLEACTION_MAX_ENUM.number = 4
EBOTTLEACTION.name = "EBottleAction"
EBOTTLEACTION.full_name = ".Cmd.EBottleAction"
EBOTTLEACTION.values = {
  EBOTTLEACTION_EBOTTLEACTION_MIN_ENUM,
  EBOTTLEACTION_EBOTTLEACTION_ACCEPT_ENUM,
  EBOTTLEACTION_EBOTTLEACTION_ABANDON_ENUM,
  EBOTTLEACTION_EBOTTLEACTION_FINISH_ENUM,
  EBOTTLEACTION_EBOTTLEACTION_MAX_ENUM
}
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MIN_ENUM.name = "EQUESTCOMPLETESTATUS_MIN"
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MIN_ENUM.index = 0
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MIN_ENUM.number = 0
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_REWARD_ENUM.name = "EQUESTCOMPLETESTATUS_QUEST_REWARD"
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_REWARD_ENUM.index = 1
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_REWARD_ENUM.number = 1
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_NOREWARD_ENUM.name = "EQUESTCOMPLETESTATUS_QUEST_NOREWARD"
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_NOREWARD_ENUM.index = 2
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_NOREWARD_ENUM.number = 2
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_NOQUEST_ENUM.name = "EQUESTCOMPLETESTATUS_NOQUEST"
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_NOQUEST_ENUM.index = 3
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_NOQUEST_ENUM.number = 3
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MAX_ENUM.name = "EQUESTCOMPLETESTATUS_MAX"
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MAX_ENUM.index = 4
EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MAX_ENUM.number = 4
EQUESTCOMPLETESTATUS.name = "EQuestCompleteStatus"
EQUESTCOMPLETESTATUS.full_name = ".Cmd.EQuestCompleteStatus"
EQUESTCOMPLETESTATUS.values = {
  EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MIN_ENUM,
  EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_REWARD_ENUM,
  EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_QUEST_NOREWARD_ENUM,
  EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_NOQUEST_ENUM,
  EQUESTCOMPLETESTATUS_EQUESTCOMPLETESTATUS_MAX_ENUM
}
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MIN_ENUM.name = "EQUESTHEROSTATUS_MIN"
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MIN_ENUM.index = 0
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MIN_ENUM.number = 0
EQUESTHEROSTATUS_EQUESTHEROSTATUS_PROCESS_ENUM.name = "EQUESTHEROSTATUS_PROCESS"
EQUESTHEROSTATUS_EQUESTHEROSTATUS_PROCESS_ENUM.index = 1
EQUESTHEROSTATUS_EQUESTHEROSTATUS_PROCESS_ENUM.number = 1
EQUESTHEROSTATUS_EQUESTHEROSTATUS_DONE_ENUM.name = "EQUESTHEROSTATUS_DONE"
EQUESTHEROSTATUS_EQUESTHEROSTATUS_DONE_ENUM.index = 2
EQUESTHEROSTATUS_EQUESTHEROSTATUS_DONE_ENUM.number = 2
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MAX_ENUM.name = "EQUESTHEROSTATUS_MAX"
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MAX_ENUM.index = 3
EQUESTHEROSTATUS_EQUESTHEROSTATUS_MAX_ENUM.number = 3
EQUESTHEROSTATUS.name = "EQuestHeroStatus"
EQUESTHEROSTATUS.full_name = ".Cmd.EQuestHeroStatus"
EQUESTHEROSTATUS.values = {
  EQUESTHEROSTATUS_EQUESTHEROSTATUS_MIN_ENUM,
  EQUESTHEROSTATUS_EQUESTHEROSTATUS_PROCESS_ENUM,
  EQUESTHEROSTATUS_EQUESTHEROSTATUS_DONE_ENUM,
  EQUESTHEROSTATUS_EQUESTHEROSTATUS_MAX_ENUM
}
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MIN_ENUM.name = "EQUESTSTORYSTATUS_MIN"
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MIN_ENUM.index = 0
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MIN_ENUM.number = 0
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_LOCK_ENUM.name = "EQUESTSTORYSTATUS_LOCK"
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_LOCK_ENUM.index = 1
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_LOCK_ENUM.number = 1
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_PROCESS_ENUM.name = "EQUESTSTORYSTATUS_PROCESS"
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_PROCESS_ENUM.index = 2
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_PROCESS_ENUM.number = 2
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_DONE_ENUM.name = "EQUESTSTORYSTATUS_DONE"
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_DONE_ENUM.index = 3
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_DONE_ENUM.number = 3
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MAX_ENUM.name = "EQUESTSTORYSTATUS_MAX"
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MAX_ENUM.index = 4
EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MAX_ENUM.number = 4
EQUESTSTORYSTATUS.name = "EQuestStoryStatus"
EQUESTSTORYSTATUS.full_name = ".Cmd.EQuestStoryStatus"
EQUESTSTORYSTATUS.values = {
  EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MIN_ENUM,
  EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_LOCK_ENUM,
  EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_PROCESS_ENUM,
  EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_DONE_ENUM,
  EQUESTSTORYSTATUS_EQUESTSTORYSTATUS_MAX_ENUM
}
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MIN_ENUM.name = "EACT_REWARD_STATUS_MIN"
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MIN_ENUM.index = 0
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MIN_ENUM.number = 0
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_REWARD_ENUM.name = "EACT_REWARD_STATUS_REWARD"
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_REWARD_ENUM.index = 1
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_REWARD_ENUM.number = 1
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_DONE_ENUM.name = "EACT_REWARD_STATUS_DONE"
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_DONE_ENUM.index = 2
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_DONE_ENUM.number = 2
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MAX_ENUM.name = "EACT_REWARD_STATUS_MAX"
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MAX_ENUM.index = 3
EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MAX_ENUM.number = 3
EACTMISSIONREWARDSTATUS.name = "EActMissionRewardStatus"
EACTMISSIONREWARDSTATUS.full_name = ".Cmd.EActMissionRewardStatus"
EACTMISSIONREWARDSTATUS.values = {
  EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MIN_ENUM,
  EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_REWARD_ENUM,
  EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_DONE_ENUM,
  EACTMISSIONREWARDSTATUS_EACT_REWARD_STATUS_MAX_ENUM
}
REWARD.name = "Reward"
REWARD.full_name = ".Cmd.Reward"
REWARD.nested_types = {}
REWARD.enum_types = {}
REWARD.fields = {}
REWARD.is_extendable = false
REWARD.extensions = {}
QUESTPCONFIG_QUESTID_FIELD.name = "QuestID"
QUESTPCONFIG_QUESTID_FIELD.full_name = ".Cmd.QuestPConfig.QuestID"
QUESTPCONFIG_QUESTID_FIELD.number = 38
QUESTPCONFIG_QUESTID_FIELD.index = 0
QUESTPCONFIG_QUESTID_FIELD.label = 1
QUESTPCONFIG_QUESTID_FIELD.has_default_value = false
QUESTPCONFIG_QUESTID_FIELD.default_value = 0
QUESTPCONFIG_QUESTID_FIELD.type = 13
QUESTPCONFIG_QUESTID_FIELD.cpp_type = 3
QUESTPCONFIG_GROUPID_FIELD.name = "GroupID"
QUESTPCONFIG_GROUPID_FIELD.full_name = ".Cmd.QuestPConfig.GroupID"
QUESTPCONFIG_GROUPID_FIELD.number = 39
QUESTPCONFIG_GROUPID_FIELD.index = 1
QUESTPCONFIG_GROUPID_FIELD.label = 1
QUESTPCONFIG_GROUPID_FIELD.has_default_value = false
QUESTPCONFIG_GROUPID_FIELD.default_value = 0
QUESTPCONFIG_GROUPID_FIELD.type = 13
QUESTPCONFIG_GROUPID_FIELD.cpp_type = 3
QUESTPCONFIG_REWARDGROUP_FIELD.name = "RewardGroup"
QUESTPCONFIG_REWARDGROUP_FIELD.full_name = ".Cmd.QuestPConfig.RewardGroup"
QUESTPCONFIG_REWARDGROUP_FIELD.number = 1
QUESTPCONFIG_REWARDGROUP_FIELD.index = 2
QUESTPCONFIG_REWARDGROUP_FIELD.label = 1
QUESTPCONFIG_REWARDGROUP_FIELD.has_default_value = true
QUESTPCONFIG_REWARDGROUP_FIELD.default_value = 0
QUESTPCONFIG_REWARDGROUP_FIELD.type = 13
QUESTPCONFIG_REWARDGROUP_FIELD.cpp_type = 3
QUESTPCONFIG_SUBGROUP_FIELD.name = "SubGroup"
QUESTPCONFIG_SUBGROUP_FIELD.full_name = ".Cmd.QuestPConfig.SubGroup"
QUESTPCONFIG_SUBGROUP_FIELD.number = 2
QUESTPCONFIG_SUBGROUP_FIELD.index = 3
QUESTPCONFIG_SUBGROUP_FIELD.label = 1
QUESTPCONFIG_SUBGROUP_FIELD.has_default_value = true
QUESTPCONFIG_SUBGROUP_FIELD.default_value = 0
QUESTPCONFIG_SUBGROUP_FIELD.type = 13
QUESTPCONFIG_SUBGROUP_FIELD.cpp_type = 3
QUESTPCONFIG_FINISHJUMP_FIELD.name = "FinishJump"
QUESTPCONFIG_FINISHJUMP_FIELD.full_name = ".Cmd.QuestPConfig.FinishJump"
QUESTPCONFIG_FINISHJUMP_FIELD.number = 3
QUESTPCONFIG_FINISHJUMP_FIELD.index = 4
QUESTPCONFIG_FINISHJUMP_FIELD.label = 1
QUESTPCONFIG_FINISHJUMP_FIELD.has_default_value = true
QUESTPCONFIG_FINISHJUMP_FIELD.default_value = 0
QUESTPCONFIG_FINISHJUMP_FIELD.type = 13
QUESTPCONFIG_FINISHJUMP_FIELD.cpp_type = 3
QUESTPCONFIG_FAILJUMP_FIELD.name = "FailJump"
QUESTPCONFIG_FAILJUMP_FIELD.full_name = ".Cmd.QuestPConfig.FailJump"
QUESTPCONFIG_FAILJUMP_FIELD.number = 4
QUESTPCONFIG_FAILJUMP_FIELD.index = 5
QUESTPCONFIG_FAILJUMP_FIELD.label = 1
QUESTPCONFIG_FAILJUMP_FIELD.has_default_value = true
QUESTPCONFIG_FAILJUMP_FIELD.default_value = 0
QUESTPCONFIG_FAILJUMP_FIELD.type = 13
QUESTPCONFIG_FAILJUMP_FIELD.cpp_type = 3
QUESTPCONFIG_MAP_FIELD.name = "Map"
QUESTPCONFIG_MAP_FIELD.full_name = ".Cmd.QuestPConfig.Map"
QUESTPCONFIG_MAP_FIELD.number = 5
QUESTPCONFIG_MAP_FIELD.index = 6
QUESTPCONFIG_MAP_FIELD.label = 1
QUESTPCONFIG_MAP_FIELD.has_default_value = true
QUESTPCONFIG_MAP_FIELD.default_value = 0
QUESTPCONFIG_MAP_FIELD.type = 13
QUESTPCONFIG_MAP_FIELD.cpp_type = 3
QUESTPCONFIG_WHETHERTRACE_FIELD.name = "WhetherTrace"
QUESTPCONFIG_WHETHERTRACE_FIELD.full_name = ".Cmd.QuestPConfig.WhetherTrace"
QUESTPCONFIG_WHETHERTRACE_FIELD.number = 6
QUESTPCONFIG_WHETHERTRACE_FIELD.index = 7
QUESTPCONFIG_WHETHERTRACE_FIELD.label = 1
QUESTPCONFIG_WHETHERTRACE_FIELD.has_default_value = true
QUESTPCONFIG_WHETHERTRACE_FIELD.default_value = 0
QUESTPCONFIG_WHETHERTRACE_FIELD.type = 13
QUESTPCONFIG_WHETHERTRACE_FIELD.cpp_type = 3
QUESTPCONFIG_AUTO_FIELD.name = "Auto"
QUESTPCONFIG_AUTO_FIELD.full_name = ".Cmd.QuestPConfig.Auto"
QUESTPCONFIG_AUTO_FIELD.number = 7
QUESTPCONFIG_AUTO_FIELD.index = 8
QUESTPCONFIG_AUTO_FIELD.label = 1
QUESTPCONFIG_AUTO_FIELD.has_default_value = true
QUESTPCONFIG_AUTO_FIELD.default_value = 0
QUESTPCONFIG_AUTO_FIELD.type = 13
QUESTPCONFIG_AUTO_FIELD.cpp_type = 3
QUESTPCONFIG_FIRSTCLASS_FIELD.name = "FirstClass"
QUESTPCONFIG_FIRSTCLASS_FIELD.full_name = ".Cmd.QuestPConfig.FirstClass"
QUESTPCONFIG_FIRSTCLASS_FIELD.number = 8
QUESTPCONFIG_FIRSTCLASS_FIELD.index = 9
QUESTPCONFIG_FIRSTCLASS_FIELD.label = 1
QUESTPCONFIG_FIRSTCLASS_FIELD.has_default_value = true
QUESTPCONFIG_FIRSTCLASS_FIELD.default_value = 0
QUESTPCONFIG_FIRSTCLASS_FIELD.type = 13
QUESTPCONFIG_FIRSTCLASS_FIELD.cpp_type = 3
QUESTPCONFIG_CLASS_FIELD.name = "Class"
QUESTPCONFIG_CLASS_FIELD.full_name = ".Cmd.QuestPConfig.Class"
QUESTPCONFIG_CLASS_FIELD.number = 9
QUESTPCONFIG_CLASS_FIELD.index = 10
QUESTPCONFIG_CLASS_FIELD.label = 1
QUESTPCONFIG_CLASS_FIELD.has_default_value = true
QUESTPCONFIG_CLASS_FIELD.default_value = 0
QUESTPCONFIG_CLASS_FIELD.type = 13
QUESTPCONFIG_CLASS_FIELD.cpp_type = 3
QUESTPCONFIG_LEVEL_FIELD.name = "Level"
QUESTPCONFIG_LEVEL_FIELD.full_name = ".Cmd.QuestPConfig.Level"
QUESTPCONFIG_LEVEL_FIELD.number = 10
QUESTPCONFIG_LEVEL_FIELD.index = 11
QUESTPCONFIG_LEVEL_FIELD.label = 1
QUESTPCONFIG_LEVEL_FIELD.has_default_value = true
QUESTPCONFIG_LEVEL_FIELD.default_value = 0
QUESTPCONFIG_LEVEL_FIELD.type = 13
QUESTPCONFIG_LEVEL_FIELD.cpp_type = 3
QUESTPCONFIG_PRENOSHOW_FIELD.name = "PreNoShow"
QUESTPCONFIG_PRENOSHOW_FIELD.full_name = ".Cmd.QuestPConfig.PreNoShow"
QUESTPCONFIG_PRENOSHOW_FIELD.number = 21
QUESTPCONFIG_PRENOSHOW_FIELD.index = 12
QUESTPCONFIG_PRENOSHOW_FIELD.label = 1
QUESTPCONFIG_PRENOSHOW_FIELD.has_default_value = true
QUESTPCONFIG_PRENOSHOW_FIELD.default_value = 0
QUESTPCONFIG_PRENOSHOW_FIELD.type = 13
QUESTPCONFIG_PRENOSHOW_FIELD.cpp_type = 3
QUESTPCONFIG_RISKLEVEL_FIELD.name = "Risklevel"
QUESTPCONFIG_RISKLEVEL_FIELD.full_name = ".Cmd.QuestPConfig.Risklevel"
QUESTPCONFIG_RISKLEVEL_FIELD.number = 22
QUESTPCONFIG_RISKLEVEL_FIELD.index = 13
QUESTPCONFIG_RISKLEVEL_FIELD.label = 1
QUESTPCONFIG_RISKLEVEL_FIELD.has_default_value = true
QUESTPCONFIG_RISKLEVEL_FIELD.default_value = 0
QUESTPCONFIG_RISKLEVEL_FIELD.type = 13
QUESTPCONFIG_RISKLEVEL_FIELD.cpp_type = 3
QUESTPCONFIG_JOBLEVEL_FIELD.name = "Joblevel"
QUESTPCONFIG_JOBLEVEL_FIELD.full_name = ".Cmd.QuestPConfig.Joblevel"
QUESTPCONFIG_JOBLEVEL_FIELD.number = 23
QUESTPCONFIG_JOBLEVEL_FIELD.index = 14
QUESTPCONFIG_JOBLEVEL_FIELD.label = 1
QUESTPCONFIG_JOBLEVEL_FIELD.has_default_value = true
QUESTPCONFIG_JOBLEVEL_FIELD.default_value = 0
QUESTPCONFIG_JOBLEVEL_FIELD.type = 13
QUESTPCONFIG_JOBLEVEL_FIELD.cpp_type = 3
QUESTPCONFIG_COOKERLV_FIELD.name = "CookerLv"
QUESTPCONFIG_COOKERLV_FIELD.full_name = ".Cmd.QuestPConfig.CookerLv"
QUESTPCONFIG_COOKERLV_FIELD.number = 24
QUESTPCONFIG_COOKERLV_FIELD.index = 15
QUESTPCONFIG_COOKERLV_FIELD.label = 1
QUESTPCONFIG_COOKERLV_FIELD.has_default_value = true
QUESTPCONFIG_COOKERLV_FIELD.default_value = 0
QUESTPCONFIG_COOKERLV_FIELD.type = 13
QUESTPCONFIG_COOKERLV_FIELD.cpp_type = 3
QUESTPCONFIG_TASTERLV_FIELD.name = "TasterLv"
QUESTPCONFIG_TASTERLV_FIELD.full_name = ".Cmd.QuestPConfig.TasterLv"
QUESTPCONFIG_TASTERLV_FIELD.number = 25
QUESTPCONFIG_TASTERLV_FIELD.index = 16
QUESTPCONFIG_TASTERLV_FIELD.label = 1
QUESTPCONFIG_TASTERLV_FIELD.has_default_value = true
QUESTPCONFIG_TASTERLV_FIELD.default_value = 0
QUESTPCONFIG_TASTERLV_FIELD.type = 13
QUESTPCONFIG_TASTERLV_FIELD.cpp_type = 3
QUESTPCONFIG_STARTTIME_FIELD.name = "StartTime"
QUESTPCONFIG_STARTTIME_FIELD.full_name = ".Cmd.QuestPConfig.StartTime"
QUESTPCONFIG_STARTTIME_FIELD.number = 35
QUESTPCONFIG_STARTTIME_FIELD.index = 17
QUESTPCONFIG_STARTTIME_FIELD.label = 1
QUESTPCONFIG_STARTTIME_FIELD.has_default_value = false
QUESTPCONFIG_STARTTIME_FIELD.default_value = 0
QUESTPCONFIG_STARTTIME_FIELD.type = 13
QUESTPCONFIG_STARTTIME_FIELD.cpp_type = 3
QUESTPCONFIG_ENDTIME_FIELD.name = "EndTime"
QUESTPCONFIG_ENDTIME_FIELD.full_name = ".Cmd.QuestPConfig.EndTime"
QUESTPCONFIG_ENDTIME_FIELD.number = 26
QUESTPCONFIG_ENDTIME_FIELD.index = 18
QUESTPCONFIG_ENDTIME_FIELD.label = 1
QUESTPCONFIG_ENDTIME_FIELD.has_default_value = true
QUESTPCONFIG_ENDTIME_FIELD.default_value = 0
QUESTPCONFIG_ENDTIME_FIELD.type = 13
QUESTPCONFIG_ENDTIME_FIELD.cpp_type = 3
QUESTPCONFIG_ICON_FIELD.name = "Icon"
QUESTPCONFIG_ICON_FIELD.full_name = ".Cmd.QuestPConfig.Icon"
QUESTPCONFIG_ICON_FIELD.number = 27
QUESTPCONFIG_ICON_FIELD.index = 19
QUESTPCONFIG_ICON_FIELD.label = 1
QUESTPCONFIG_ICON_FIELD.has_default_value = true
QUESTPCONFIG_ICON_FIELD.default_value = 0
QUESTPCONFIG_ICON_FIELD.type = 13
QUESTPCONFIG_ICON_FIELD.cpp_type = 3
QUESTPCONFIG_COLOR_FIELD.name = "Color"
QUESTPCONFIG_COLOR_FIELD.full_name = ".Cmd.QuestPConfig.Color"
QUESTPCONFIG_COLOR_FIELD.number = 28
QUESTPCONFIG_COLOR_FIELD.index = 20
QUESTPCONFIG_COLOR_FIELD.label = 1
QUESTPCONFIG_COLOR_FIELD.has_default_value = true
QUESTPCONFIG_COLOR_FIELD.default_value = 0
QUESTPCONFIG_COLOR_FIELD.type = 13
QUESTPCONFIG_COLOR_FIELD.cpp_type = 3
QUESTPCONFIG_QUESTNAME_FIELD.name = "QuestName"
QUESTPCONFIG_QUESTNAME_FIELD.full_name = ".Cmd.QuestPConfig.QuestName"
QUESTPCONFIG_QUESTNAME_FIELD.number = 11
QUESTPCONFIG_QUESTNAME_FIELD.index = 21
QUESTPCONFIG_QUESTNAME_FIELD.label = 1
QUESTPCONFIG_QUESTNAME_FIELD.has_default_value = false
QUESTPCONFIG_QUESTNAME_FIELD.default_value = ""
QUESTPCONFIG_QUESTNAME_FIELD.type = 9
QUESTPCONFIG_QUESTNAME_FIELD.cpp_type = 9
QUESTPCONFIG_NAME_FIELD.name = "Name"
QUESTPCONFIG_NAME_FIELD.full_name = ".Cmd.QuestPConfig.Name"
QUESTPCONFIG_NAME_FIELD.number = 12
QUESTPCONFIG_NAME_FIELD.index = 22
QUESTPCONFIG_NAME_FIELD.label = 1
QUESTPCONFIG_NAME_FIELD.has_default_value = false
QUESTPCONFIG_NAME_FIELD.default_value = ""
QUESTPCONFIG_NAME_FIELD.type = 9
QUESTPCONFIG_NAME_FIELD.cpp_type = 9
QUESTPCONFIG_TYPE_FIELD.name = "Type"
QUESTPCONFIG_TYPE_FIELD.full_name = ".Cmd.QuestPConfig.Type"
QUESTPCONFIG_TYPE_FIELD.number = 13
QUESTPCONFIG_TYPE_FIELD.index = 23
QUESTPCONFIG_TYPE_FIELD.label = 1
QUESTPCONFIG_TYPE_FIELD.has_default_value = false
QUESTPCONFIG_TYPE_FIELD.default_value = ""
QUESTPCONFIG_TYPE_FIELD.type = 9
QUESTPCONFIG_TYPE_FIELD.cpp_type = 9
QUESTPCONFIG_CONTENT_FIELD.name = "Content"
QUESTPCONFIG_CONTENT_FIELD.full_name = ".Cmd.QuestPConfig.Content"
QUESTPCONFIG_CONTENT_FIELD.number = 14
QUESTPCONFIG_CONTENT_FIELD.index = 24
QUESTPCONFIG_CONTENT_FIELD.label = 1
QUESTPCONFIG_CONTENT_FIELD.has_default_value = false
QUESTPCONFIG_CONTENT_FIELD.default_value = ""
QUESTPCONFIG_CONTENT_FIELD.type = 9
QUESTPCONFIG_CONTENT_FIELD.cpp_type = 9
QUESTPCONFIG_TRACEINFO_FIELD.name = "TraceInfo"
QUESTPCONFIG_TRACEINFO_FIELD.full_name = ".Cmd.QuestPConfig.TraceInfo"
QUESTPCONFIG_TRACEINFO_FIELD.number = 15
QUESTPCONFIG_TRACEINFO_FIELD.index = 25
QUESTPCONFIG_TRACEINFO_FIELD.label = 1
QUESTPCONFIG_TRACEINFO_FIELD.has_default_value = false
QUESTPCONFIG_TRACEINFO_FIELD.default_value = ""
QUESTPCONFIG_TRACEINFO_FIELD.type = 9
QUESTPCONFIG_TRACEINFO_FIELD.cpp_type = 9
QUESTPCONFIG_PREFIXION_FIELD.name = "Prefixion"
QUESTPCONFIG_PREFIXION_FIELD.full_name = ".Cmd.QuestPConfig.Prefixion"
QUESTPCONFIG_PREFIXION_FIELD.number = 20
QUESTPCONFIG_PREFIXION_FIELD.index = 26
QUESTPCONFIG_PREFIXION_FIELD.label = 1
QUESTPCONFIG_PREFIXION_FIELD.has_default_value = false
QUESTPCONFIG_PREFIXION_FIELD.default_value = ""
QUESTPCONFIG_PREFIXION_FIELD.type = 9
QUESTPCONFIG_PREFIXION_FIELD.cpp_type = 9
QUESTPCONFIG_VERSION_FIELD.name = "version"
QUESTPCONFIG_VERSION_FIELD.full_name = ".Cmd.QuestPConfig.version"
QUESTPCONFIG_VERSION_FIELD.number = 32
QUESTPCONFIG_VERSION_FIELD.index = 27
QUESTPCONFIG_VERSION_FIELD.label = 1
QUESTPCONFIG_VERSION_FIELD.has_default_value = false
QUESTPCONFIG_VERSION_FIELD.default_value = ""
QUESTPCONFIG_VERSION_FIELD.type = 9
QUESTPCONFIG_VERSION_FIELD.cpp_type = 9
QUESTPCONFIG_PARAMS_FIELD.name = "params"
QUESTPCONFIG_PARAMS_FIELD.full_name = ".Cmd.QuestPConfig.params"
QUESTPCONFIG_PARAMS_FIELD.number = 16
QUESTPCONFIG_PARAMS_FIELD.index = 28
QUESTPCONFIG_PARAMS_FIELD.label = 1
QUESTPCONFIG_PARAMS_FIELD.has_default_value = false
QUESTPCONFIG_PARAMS_FIELD.default_value = nil
QUESTPCONFIG_PARAMS_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
QUESTPCONFIG_PARAMS_FIELD.type = 11
QUESTPCONFIG_PARAMS_FIELD.cpp_type = 10
QUESTPCONFIG_EXTRAJUMP_FIELD.name = "ExtraJump"
QUESTPCONFIG_EXTRAJUMP_FIELD.full_name = ".Cmd.QuestPConfig.ExtraJump"
QUESTPCONFIG_EXTRAJUMP_FIELD.number = 36
QUESTPCONFIG_EXTRAJUMP_FIELD.index = 29
QUESTPCONFIG_EXTRAJUMP_FIELD.label = 1
QUESTPCONFIG_EXTRAJUMP_FIELD.has_default_value = false
QUESTPCONFIG_EXTRAJUMP_FIELD.default_value = nil
QUESTPCONFIG_EXTRAJUMP_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
QUESTPCONFIG_EXTRAJUMP_FIELD.type = 11
QUESTPCONFIG_EXTRAJUMP_FIELD.cpp_type = 10
QUESTPCONFIG_STEPACTIONS_FIELD.name = "stepactions"
QUESTPCONFIG_STEPACTIONS_FIELD.full_name = ".Cmd.QuestPConfig.stepactions"
QUESTPCONFIG_STEPACTIONS_FIELD.number = 37
QUESTPCONFIG_STEPACTIONS_FIELD.index = 30
QUESTPCONFIG_STEPACTIONS_FIELD.label = 3
QUESTPCONFIG_STEPACTIONS_FIELD.has_default_value = false
QUESTPCONFIG_STEPACTIONS_FIELD.default_value = {}
QUESTPCONFIG_STEPACTIONS_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
QUESTPCONFIG_STEPACTIONS_FIELD.type = 11
QUESTPCONFIG_STEPACTIONS_FIELD.cpp_type = 10
QUESTPCONFIG_ALLREWARD_FIELD.name = "allreward"
QUESTPCONFIG_ALLREWARD_FIELD.full_name = ".Cmd.QuestPConfig.allreward"
QUESTPCONFIG_ALLREWARD_FIELD.number = 17
QUESTPCONFIG_ALLREWARD_FIELD.index = 31
QUESTPCONFIG_ALLREWARD_FIELD.label = 3
QUESTPCONFIG_ALLREWARD_FIELD.has_default_value = false
QUESTPCONFIG_ALLREWARD_FIELD.default_value = {}
QUESTPCONFIG_ALLREWARD_FIELD.message_type = ProtoCommon_pb.QUESTREWARD
QUESTPCONFIG_ALLREWARD_FIELD.type = 11
QUESTPCONFIG_ALLREWARD_FIELD.cpp_type = 10
QUESTPCONFIG_PREQUEST_FIELD.name = "PreQuest"
QUESTPCONFIG_PREQUEST_FIELD.full_name = ".Cmd.QuestPConfig.PreQuest"
QUESTPCONFIG_PREQUEST_FIELD.number = 18
QUESTPCONFIG_PREQUEST_FIELD.index = 32
QUESTPCONFIG_PREQUEST_FIELD.label = 3
QUESTPCONFIG_PREQUEST_FIELD.has_default_value = false
QUESTPCONFIG_PREQUEST_FIELD.default_value = {}
QUESTPCONFIG_PREQUEST_FIELD.type = 13
QUESTPCONFIG_PREQUEST_FIELD.cpp_type = 3
QUESTPCONFIG_MUSTPREQUEST_FIELD.name = "MustPreQuest"
QUESTPCONFIG_MUSTPREQUEST_FIELD.full_name = ".Cmd.QuestPConfig.MustPreQuest"
QUESTPCONFIG_MUSTPREQUEST_FIELD.number = 19
QUESTPCONFIG_MUSTPREQUEST_FIELD.index = 33
QUESTPCONFIG_MUSTPREQUEST_FIELD.label = 3
QUESTPCONFIG_MUSTPREQUEST_FIELD.has_default_value = false
QUESTPCONFIG_MUSTPREQUEST_FIELD.default_value = {}
QUESTPCONFIG_MUSTPREQUEST_FIELD.type = 13
QUESTPCONFIG_MUSTPREQUEST_FIELD.cpp_type = 3
QUESTPCONFIG_PREMENU_FIELD.name = "PreMenu"
QUESTPCONFIG_PREMENU_FIELD.full_name = ".Cmd.QuestPConfig.PreMenu"
QUESTPCONFIG_PREMENU_FIELD.number = 33
QUESTPCONFIG_PREMENU_FIELD.index = 34
QUESTPCONFIG_PREMENU_FIELD.label = 3
QUESTPCONFIG_PREMENU_FIELD.has_default_value = false
QUESTPCONFIG_PREMENU_FIELD.default_value = {}
QUESTPCONFIG_PREMENU_FIELD.type = 13
QUESTPCONFIG_PREMENU_FIELD.cpp_type = 3
QUESTPCONFIG_MUSTPREMENU_FIELD.name = "MustPreMenu"
QUESTPCONFIG_MUSTPREMENU_FIELD.full_name = ".Cmd.QuestPConfig.MustPreMenu"
QUESTPCONFIG_MUSTPREMENU_FIELD.number = 34
QUESTPCONFIG_MUSTPREMENU_FIELD.index = 35
QUESTPCONFIG_MUSTPREMENU_FIELD.label = 3
QUESTPCONFIG_MUSTPREMENU_FIELD.has_default_value = false
QUESTPCONFIG_MUSTPREMENU_FIELD.default_value = {}
QUESTPCONFIG_MUSTPREMENU_FIELD.type = 13
QUESTPCONFIG_MUSTPREMENU_FIELD.cpp_type = 3
QUESTPCONFIG_HEADICON_FIELD.name = "Headicon"
QUESTPCONFIG_HEADICON_FIELD.full_name = ".Cmd.QuestPConfig.Headicon"
QUESTPCONFIG_HEADICON_FIELD.number = 29
QUESTPCONFIG_HEADICON_FIELD.index = 36
QUESTPCONFIG_HEADICON_FIELD.label = 1
QUESTPCONFIG_HEADICON_FIELD.has_default_value = true
QUESTPCONFIG_HEADICON_FIELD.default_value = 0
QUESTPCONFIG_HEADICON_FIELD.type = 13
QUESTPCONFIG_HEADICON_FIELD.cpp_type = 3
QUESTPCONFIG_HIDE_FIELD.name = "Hide"
QUESTPCONFIG_HIDE_FIELD.full_name = ".Cmd.QuestPConfig.Hide"
QUESTPCONFIG_HIDE_FIELD.number = 30
QUESTPCONFIG_HIDE_FIELD.index = 37
QUESTPCONFIG_HIDE_FIELD.label = 1
QUESTPCONFIG_HIDE_FIELD.has_default_value = false
QUESTPCONFIG_HIDE_FIELD.default_value = 0
QUESTPCONFIG_HIDE_FIELD.type = 13
QUESTPCONFIG_HIDE_FIELD.cpp_type = 3
QUESTPCONFIG_CREATETIME_FIELD.name = "CreateTime"
QUESTPCONFIG_CREATETIME_FIELD.full_name = ".Cmd.QuestPConfig.CreateTime"
QUESTPCONFIG_CREATETIME_FIELD.number = 31
QUESTPCONFIG_CREATETIME_FIELD.index = 38
QUESTPCONFIG_CREATETIME_FIELD.label = 1
QUESTPCONFIG_CREATETIME_FIELD.has_default_value = false
QUESTPCONFIG_CREATETIME_FIELD.default_value = 0
QUESTPCONFIG_CREATETIME_FIELD.type = 13
QUESTPCONFIG_CREATETIME_FIELD.cpp_type = 3
QUESTPCONFIG.name = "QuestPConfig"
QUESTPCONFIG.full_name = ".Cmd.QuestPConfig"
QUESTPCONFIG.nested_types = {}
QUESTPCONFIG.enum_types = {}
QUESTPCONFIG.fields = {
  QUESTPCONFIG_QUESTID_FIELD,
  QUESTPCONFIG_GROUPID_FIELD,
  QUESTPCONFIG_REWARDGROUP_FIELD,
  QUESTPCONFIG_SUBGROUP_FIELD,
  QUESTPCONFIG_FINISHJUMP_FIELD,
  QUESTPCONFIG_FAILJUMP_FIELD,
  QUESTPCONFIG_MAP_FIELD,
  QUESTPCONFIG_WHETHERTRACE_FIELD,
  QUESTPCONFIG_AUTO_FIELD,
  QUESTPCONFIG_FIRSTCLASS_FIELD,
  QUESTPCONFIG_CLASS_FIELD,
  QUESTPCONFIG_LEVEL_FIELD,
  QUESTPCONFIG_PRENOSHOW_FIELD,
  QUESTPCONFIG_RISKLEVEL_FIELD,
  QUESTPCONFIG_JOBLEVEL_FIELD,
  QUESTPCONFIG_COOKERLV_FIELD,
  QUESTPCONFIG_TASTERLV_FIELD,
  QUESTPCONFIG_STARTTIME_FIELD,
  QUESTPCONFIG_ENDTIME_FIELD,
  QUESTPCONFIG_ICON_FIELD,
  QUESTPCONFIG_COLOR_FIELD,
  QUESTPCONFIG_QUESTNAME_FIELD,
  QUESTPCONFIG_NAME_FIELD,
  QUESTPCONFIG_TYPE_FIELD,
  QUESTPCONFIG_CONTENT_FIELD,
  QUESTPCONFIG_TRACEINFO_FIELD,
  QUESTPCONFIG_PREFIXION_FIELD,
  QUESTPCONFIG_VERSION_FIELD,
  QUESTPCONFIG_PARAMS_FIELD,
  QUESTPCONFIG_EXTRAJUMP_FIELD,
  QUESTPCONFIG_STEPACTIONS_FIELD,
  QUESTPCONFIG_ALLREWARD_FIELD,
  QUESTPCONFIG_PREQUEST_FIELD,
  QUESTPCONFIG_MUSTPREQUEST_FIELD,
  QUESTPCONFIG_PREMENU_FIELD,
  QUESTPCONFIG_MUSTPREMENU_FIELD,
  QUESTPCONFIG_HEADICON_FIELD,
  QUESTPCONFIG_HIDE_FIELD,
  QUESTPCONFIG_CREATETIME_FIELD
}
QUESTPCONFIG.is_extendable = false
QUESTPCONFIG.extensions = {}
QUESTSTEP_PROCESS_FIELD.name = "process"
QUESTSTEP_PROCESS_FIELD.full_name = ".Cmd.QuestStep.process"
QUESTSTEP_PROCESS_FIELD.number = 1
QUESTSTEP_PROCESS_FIELD.index = 0
QUESTSTEP_PROCESS_FIELD.label = 1
QUESTSTEP_PROCESS_FIELD.has_default_value = true
QUESTSTEP_PROCESS_FIELD.default_value = 0
QUESTSTEP_PROCESS_FIELD.type = 13
QUESTSTEP_PROCESS_FIELD.cpp_type = 3
QUESTSTEP_PARAMS_FIELD.name = "params"
QUESTSTEP_PARAMS_FIELD.full_name = ".Cmd.QuestStep.params"
QUESTSTEP_PARAMS_FIELD.number = 2
QUESTSTEP_PARAMS_FIELD.index = 1
QUESTSTEP_PARAMS_FIELD.label = 3
QUESTSTEP_PARAMS_FIELD.has_default_value = false
QUESTSTEP_PARAMS_FIELD.default_value = {}
QUESTSTEP_PARAMS_FIELD.type = 4
QUESTSTEP_PARAMS_FIELD.cpp_type = 4
QUESTSTEP_NAMES_FIELD.name = "names"
QUESTSTEP_NAMES_FIELD.full_name = ".Cmd.QuestStep.names"
QUESTSTEP_NAMES_FIELD.number = 3
QUESTSTEP_NAMES_FIELD.index = 2
QUESTSTEP_NAMES_FIELD.label = 3
QUESTSTEP_NAMES_FIELD.has_default_value = false
QUESTSTEP_NAMES_FIELD.default_value = {}
QUESTSTEP_NAMES_FIELD.type = 9
QUESTSTEP_NAMES_FIELD.cpp_type = 9
QUESTSTEP_CONFIG_FIELD.name = "config"
QUESTSTEP_CONFIG_FIELD.full_name = ".Cmd.QuestStep.config"
QUESTSTEP_CONFIG_FIELD.number = 4
QUESTSTEP_CONFIG_FIELD.index = 3
QUESTSTEP_CONFIG_FIELD.label = 1
QUESTSTEP_CONFIG_FIELD.has_default_value = false
QUESTSTEP_CONFIG_FIELD.default_value = nil
QUESTSTEP_CONFIG_FIELD.message_type = QUESTPCONFIG
QUESTSTEP_CONFIG_FIELD.type = 11
QUESTSTEP_CONFIG_FIELD.cpp_type = 10
QUESTSTEP.name = "QuestStep"
QUESTSTEP.full_name = ".Cmd.QuestStep"
QUESTSTEP.nested_types = {}
QUESTSTEP.enum_types = {}
QUESTSTEP.fields = {
  QUESTSTEP_PROCESS_FIELD,
  QUESTSTEP_PARAMS_FIELD,
  QUESTSTEP_NAMES_FIELD,
  QUESTSTEP_CONFIG_FIELD
}
QUESTSTEP.is_extendable = false
QUESTSTEP.extensions = {}
CLIENTTRACE_QUESTID_FIELD.name = "questid"
CLIENTTRACE_QUESTID_FIELD.full_name = ".Cmd.ClientTrace.questid"
CLIENTTRACE_QUESTID_FIELD.number = 1
CLIENTTRACE_QUESTID_FIELD.index = 0
CLIENTTRACE_QUESTID_FIELD.label = 1
CLIENTTRACE_QUESTID_FIELD.has_default_value = false
CLIENTTRACE_QUESTID_FIELD.default_value = 0
CLIENTTRACE_QUESTID_FIELD.type = 13
CLIENTTRACE_QUESTID_FIELD.cpp_type = 3
CLIENTTRACE_TRACE_FIELD.name = "trace"
CLIENTTRACE_TRACE_FIELD.full_name = ".Cmd.ClientTrace.trace"
CLIENTTRACE_TRACE_FIELD.number = 2
CLIENTTRACE_TRACE_FIELD.index = 1
CLIENTTRACE_TRACE_FIELD.label = 1
CLIENTTRACE_TRACE_FIELD.has_default_value = false
CLIENTTRACE_TRACE_FIELD.default_value = nil
CLIENTTRACE_TRACE_FIELD.enum_type = ECLIENTTRACE
CLIENTTRACE_TRACE_FIELD.type = 14
CLIENTTRACE_TRACE_FIELD.cpp_type = 8
CLIENTTRACE.name = "ClientTrace"
CLIENTTRACE.full_name = ".Cmd.ClientTrace"
CLIENTTRACE.nested_types = {}
CLIENTTRACE.enum_types = {}
CLIENTTRACE.fields = {
  CLIENTTRACE_QUESTID_FIELD,
  CLIENTTRACE_TRACE_FIELD
}
CLIENTTRACE.is_extendable = false
CLIENTTRACE.extensions = {}
QUESTDATA_ID_FIELD.name = "id"
QUESTDATA_ID_FIELD.full_name = ".Cmd.QuestData.id"
QUESTDATA_ID_FIELD.number = 1
QUESTDATA_ID_FIELD.index = 0
QUESTDATA_ID_FIELD.label = 1
QUESTDATA_ID_FIELD.has_default_value = true
QUESTDATA_ID_FIELD.default_value = 0
QUESTDATA_ID_FIELD.type = 13
QUESTDATA_ID_FIELD.cpp_type = 3
QUESTDATA_STEP_FIELD.name = "step"
QUESTDATA_STEP_FIELD.full_name = ".Cmd.QuestData.step"
QUESTDATA_STEP_FIELD.number = 2
QUESTDATA_STEP_FIELD.index = 1
QUESTDATA_STEP_FIELD.label = 1
QUESTDATA_STEP_FIELD.has_default_value = true
QUESTDATA_STEP_FIELD.default_value = 0
QUESTDATA_STEP_FIELD.type = 13
QUESTDATA_STEP_FIELD.cpp_type = 3
QUESTDATA_TIME_FIELD.name = "time"
QUESTDATA_TIME_FIELD.full_name = ".Cmd.QuestData.time"
QUESTDATA_TIME_FIELD.number = 3
QUESTDATA_TIME_FIELD.index = 2
QUESTDATA_TIME_FIELD.label = 1
QUESTDATA_TIME_FIELD.has_default_value = true
QUESTDATA_TIME_FIELD.default_value = 0
QUESTDATA_TIME_FIELD.type = 13
QUESTDATA_TIME_FIELD.cpp_type = 3
QUESTDATA_COMPLETE_FIELD.name = "complete"
QUESTDATA_COMPLETE_FIELD.full_name = ".Cmd.QuestData.complete"
QUESTDATA_COMPLETE_FIELD.number = 4
QUESTDATA_COMPLETE_FIELD.index = 3
QUESTDATA_COMPLETE_FIELD.label = 1
QUESTDATA_COMPLETE_FIELD.has_default_value = true
QUESTDATA_COMPLETE_FIELD.default_value = false
QUESTDATA_COMPLETE_FIELD.type = 8
QUESTDATA_COMPLETE_FIELD.cpp_type = 7
QUESTDATA_TRACE_FIELD.name = "trace"
QUESTDATA_TRACE_FIELD.full_name = ".Cmd.QuestData.trace"
QUESTDATA_TRACE_FIELD.number = 12
QUESTDATA_TRACE_FIELD.index = 4
QUESTDATA_TRACE_FIELD.label = 1
QUESTDATA_TRACE_FIELD.has_default_value = true
QUESTDATA_TRACE_FIELD.default_value = true
QUESTDATA_TRACE_FIELD.type = 8
QUESTDATA_TRACE_FIELD.cpp_type = 7
QUESTDATA_DONE_FIELD.name = "done"
QUESTDATA_DONE_FIELD.full_name = ".Cmd.QuestData.done"
QUESTDATA_DONE_FIELD.number = 13
QUESTDATA_DONE_FIELD.index = 5
QUESTDATA_DONE_FIELD.label = 1
QUESTDATA_DONE_FIELD.has_default_value = false
QUESTDATA_DONE_FIELD.default_value = false
QUESTDATA_DONE_FIELD.type = 8
QUESTDATA_DONE_FIELD.cpp_type = 7
QUESTDATA_PREDONE_FIELD.name = "predone"
QUESTDATA_PREDONE_FIELD.full_name = ".Cmd.QuestData.predone"
QUESTDATA_PREDONE_FIELD.number = 14
QUESTDATA_PREDONE_FIELD.index = 6
QUESTDATA_PREDONE_FIELD.label = 1
QUESTDATA_PREDONE_FIELD.has_default_value = false
QUESTDATA_PREDONE_FIELD.default_value = false
QUESTDATA_PREDONE_FIELD.type = 8
QUESTDATA_PREDONE_FIELD.cpp_type = 7
QUESTDATA_CONVERT_FIELD.name = "convert"
QUESTDATA_CONVERT_FIELD.full_name = ".Cmd.QuestData.convert"
QUESTDATA_CONVERT_FIELD.number = 16
QUESTDATA_CONVERT_FIELD.index = 7
QUESTDATA_CONVERT_FIELD.label = 1
QUESTDATA_CONVERT_FIELD.has_default_value = false
QUESTDATA_CONVERT_FIELD.default_value = false
QUESTDATA_CONVERT_FIELD.type = 8
QUESTDATA_CONVERT_FIELD.cpp_type = 7
QUESTDATA_ACCEPTTIME_FIELD.name = "accepttime"
QUESTDATA_ACCEPTTIME_FIELD.full_name = ".Cmd.QuestData.accepttime"
QUESTDATA_ACCEPTTIME_FIELD.number = 15
QUESTDATA_ACCEPTTIME_FIELD.index = 8
QUESTDATA_ACCEPTTIME_FIELD.label = 1
QUESTDATA_ACCEPTTIME_FIELD.has_default_value = true
QUESTDATA_ACCEPTTIME_FIELD.default_value = 0
QUESTDATA_ACCEPTTIME_FIELD.type = 13
QUESTDATA_ACCEPTTIME_FIELD.cpp_type = 3
QUESTDATA_STEPSTARTTIME_FIELD.name = "stepstarttime"
QUESTDATA_STEPSTARTTIME_FIELD.full_name = ".Cmd.QuestData.stepstarttime"
QUESTDATA_STEPSTARTTIME_FIELD.number = 17
QUESTDATA_STEPSTARTTIME_FIELD.index = 9
QUESTDATA_STEPSTARTTIME_FIELD.label = 1
QUESTDATA_STEPSTARTTIME_FIELD.has_default_value = false
QUESTDATA_STEPSTARTTIME_FIELD.default_value = 0
QUESTDATA_STEPSTARTTIME_FIELD.type = 13
QUESTDATA_STEPSTARTTIME_FIELD.cpp_type = 3
QUESTDATA_STEPSTARTMOVEDIS_FIELD.name = "stepstartmovedis"
QUESTDATA_STEPSTARTMOVEDIS_FIELD.full_name = ".Cmd.QuestData.stepstartmovedis"
QUESTDATA_STEPSTARTMOVEDIS_FIELD.number = 18
QUESTDATA_STEPSTARTMOVEDIS_FIELD.index = 10
QUESTDATA_STEPSTARTMOVEDIS_FIELD.label = 1
QUESTDATA_STEPSTARTMOVEDIS_FIELD.has_default_value = false
QUESTDATA_STEPSTARTMOVEDIS_FIELD.default_value = 0
QUESTDATA_STEPSTARTMOVEDIS_FIELD.type = 13
QUESTDATA_STEPSTARTMOVEDIS_FIELD.cpp_type = 3
QUESTDATA_STEPS_FIELD.name = "steps"
QUESTDATA_STEPS_FIELD.full_name = ".Cmd.QuestData.steps"
QUESTDATA_STEPS_FIELD.number = 5
QUESTDATA_STEPS_FIELD.index = 11
QUESTDATA_STEPS_FIELD.label = 3
QUESTDATA_STEPS_FIELD.has_default_value = false
QUESTDATA_STEPS_FIELD.default_value = {}
QUESTDATA_STEPS_FIELD.message_type = QUESTSTEP
QUESTDATA_STEPS_FIELD.type = 11
QUESTDATA_STEPS_FIELD.cpp_type = 10
QUESTDATA_REWARDS_FIELD.name = "rewards"
QUESTDATA_REWARDS_FIELD.full_name = ".Cmd.QuestData.rewards"
QUESTDATA_REWARDS_FIELD.number = 6
QUESTDATA_REWARDS_FIELD.index = 12
QUESTDATA_REWARDS_FIELD.label = 3
QUESTDATA_REWARDS_FIELD.has_default_value = false
QUESTDATA_REWARDS_FIELD.default_value = {}
QUESTDATA_REWARDS_FIELD.message_type = SceneItem_pb.ITEMINFO
QUESTDATA_REWARDS_FIELD.type = 11
QUESTDATA_REWARDS_FIELD.cpp_type = 10
QUESTDATA_VERSION_FIELD.name = "version"
QUESTDATA_VERSION_FIELD.full_name = ".Cmd.QuestData.version"
QUESTDATA_VERSION_FIELD.number = 7
QUESTDATA_VERSION_FIELD.index = 13
QUESTDATA_VERSION_FIELD.label = 1
QUESTDATA_VERSION_FIELD.has_default_value = true
QUESTDATA_VERSION_FIELD.default_value = 0
QUESTDATA_VERSION_FIELD.type = 13
QUESTDATA_VERSION_FIELD.cpp_type = 3
QUESTDATA_ACCEPTLV_FIELD.name = "acceptlv"
QUESTDATA_ACCEPTLV_FIELD.full_name = ".Cmd.QuestData.acceptlv"
QUESTDATA_ACCEPTLV_FIELD.number = 8
QUESTDATA_ACCEPTLV_FIELD.index = 14
QUESTDATA_ACCEPTLV_FIELD.label = 1
QUESTDATA_ACCEPTLV_FIELD.has_default_value = true
QUESTDATA_ACCEPTLV_FIELD.default_value = 0
QUESTDATA_ACCEPTLV_FIELD.type = 13
QUESTDATA_ACCEPTLV_FIELD.cpp_type = 3
QUESTDATA_FINISHCOUNT_FIELD.name = "finishcount"
QUESTDATA_FINISHCOUNT_FIELD.full_name = ".Cmd.QuestData.finishcount"
QUESTDATA_FINISHCOUNT_FIELD.number = 9
QUESTDATA_FINISHCOUNT_FIELD.index = 15
QUESTDATA_FINISHCOUNT_FIELD.label = 1
QUESTDATA_FINISHCOUNT_FIELD.has_default_value = true
QUESTDATA_FINISHCOUNT_FIELD.default_value = 0
QUESTDATA_FINISHCOUNT_FIELD.type = 13
QUESTDATA_FINISHCOUNT_FIELD.cpp_type = 3
QUESTDATA_TRACE_STATUS_FIELD.name = "trace_status"
QUESTDATA_TRACE_STATUS_FIELD.full_name = ".Cmd.QuestData.trace_status"
QUESTDATA_TRACE_STATUS_FIELD.number = 19
QUESTDATA_TRACE_STATUS_FIELD.index = 16
QUESTDATA_TRACE_STATUS_FIELD.label = 1
QUESTDATA_TRACE_STATUS_FIELD.has_default_value = false
QUESTDATA_TRACE_STATUS_FIELD.default_value = nil
QUESTDATA_TRACE_STATUS_FIELD.enum_type = EQUESTSTATUS
QUESTDATA_TRACE_STATUS_FIELD.type = 14
QUESTDATA_TRACE_STATUS_FIELD.cpp_type = 8
QUESTDATA_NEW_STATUS_FIELD.name = "new_status"
QUESTDATA_NEW_STATUS_FIELD.full_name = ".Cmd.QuestData.new_status"
QUESTDATA_NEW_STATUS_FIELD.number = 20
QUESTDATA_NEW_STATUS_FIELD.index = 17
QUESTDATA_NEW_STATUS_FIELD.label = 1
QUESTDATA_NEW_STATUS_FIELD.has_default_value = false
QUESTDATA_NEW_STATUS_FIELD.default_value = nil
QUESTDATA_NEW_STATUS_FIELD.enum_type = EQUESTSTATUS
QUESTDATA_NEW_STATUS_FIELD.type = 14
QUESTDATA_NEW_STATUS_FIELD.cpp_type = 8
QUESTDATA_PARAMS_FIELD.name = "params"
QUESTDATA_PARAMS_FIELD.full_name = ".Cmd.QuestData.params"
QUESTDATA_PARAMS_FIELD.number = 10
QUESTDATA_PARAMS_FIELD.index = 18
QUESTDATA_PARAMS_FIELD.label = 3
QUESTDATA_PARAMS_FIELD.has_default_value = false
QUESTDATA_PARAMS_FIELD.default_value = {}
QUESTDATA_PARAMS_FIELD.type = 4
QUESTDATA_PARAMS_FIELD.cpp_type = 4
QUESTDATA_NAMES_FIELD.name = "names"
QUESTDATA_NAMES_FIELD.full_name = ".Cmd.QuestData.names"
QUESTDATA_NAMES_FIELD.number = 11
QUESTDATA_NAMES_FIELD.index = 19
QUESTDATA_NAMES_FIELD.label = 3
QUESTDATA_NAMES_FIELD.has_default_value = false
QUESTDATA_NAMES_FIELD.default_value = {}
QUESTDATA_NAMES_FIELD.type = 9
QUESTDATA_NAMES_FIELD.cpp_type = 9
QUESTDATA.name = "QuestData"
QUESTDATA.full_name = ".Cmd.QuestData"
QUESTDATA.nested_types = {}
QUESTDATA.enum_types = {}
QUESTDATA.fields = {
  QUESTDATA_ID_FIELD,
  QUESTDATA_STEP_FIELD,
  QUESTDATA_TIME_FIELD,
  QUESTDATA_COMPLETE_FIELD,
  QUESTDATA_TRACE_FIELD,
  QUESTDATA_DONE_FIELD,
  QUESTDATA_PREDONE_FIELD,
  QUESTDATA_CONVERT_FIELD,
  QUESTDATA_ACCEPTTIME_FIELD,
  QUESTDATA_STEPSTARTTIME_FIELD,
  QUESTDATA_STEPSTARTMOVEDIS_FIELD,
  QUESTDATA_STEPS_FIELD,
  QUESTDATA_REWARDS_FIELD,
  QUESTDATA_VERSION_FIELD,
  QUESTDATA_ACCEPTLV_FIELD,
  QUESTDATA_FINISHCOUNT_FIELD,
  QUESTDATA_TRACE_STATUS_FIELD,
  QUESTDATA_NEW_STATUS_FIELD,
  QUESTDATA_PARAMS_FIELD,
  QUESTDATA_NAMES_FIELD
}
QUESTDATA.is_extendable = false
QUESTDATA.extensions = {}
QUESTPUZZLE_VERSION_FIELD.name = "version"
QUESTPUZZLE_VERSION_FIELD.full_name = ".Cmd.QuestPuzzle.version"
QUESTPUZZLE_VERSION_FIELD.number = 1
QUESTPUZZLE_VERSION_FIELD.index = 0
QUESTPUZZLE_VERSION_FIELD.label = 1
QUESTPUZZLE_VERSION_FIELD.has_default_value = false
QUESTPUZZLE_VERSION_FIELD.default_value = ""
QUESTPUZZLE_VERSION_FIELD.type = 9
QUESTPUZZLE_VERSION_FIELD.cpp_type = 9
QUESTPUZZLE_OPEN_PUZZLES_FIELD.name = "open_puzzles"
QUESTPUZZLE_OPEN_PUZZLES_FIELD.full_name = ".Cmd.QuestPuzzle.open_puzzles"
QUESTPUZZLE_OPEN_PUZZLES_FIELD.number = 2
QUESTPUZZLE_OPEN_PUZZLES_FIELD.index = 1
QUESTPUZZLE_OPEN_PUZZLES_FIELD.label = 3
QUESTPUZZLE_OPEN_PUZZLES_FIELD.has_default_value = false
QUESTPUZZLE_OPEN_PUZZLES_FIELD.default_value = {}
QUESTPUZZLE_OPEN_PUZZLES_FIELD.type = 13
QUESTPUZZLE_OPEN_PUZZLES_FIELD.cpp_type = 3
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.name = "unlock_puzzles"
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.full_name = ".Cmd.QuestPuzzle.unlock_puzzles"
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.number = 3
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.index = 2
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.label = 3
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.has_default_value = false
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.default_value = {}
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.type = 13
QUESTPUZZLE_UNLOCK_PUZZLES_FIELD.cpp_type = 3
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.name = "canopen_puzzles"
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.full_name = ".Cmd.QuestPuzzle.canopen_puzzles"
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.number = 4
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.index = 3
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.label = 3
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.has_default_value = false
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.default_value = {}
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.type = 13
QUESTPUZZLE_CANOPEN_PUZZLES_FIELD.cpp_type = 3
QUESTPUZZLE.name = "QuestPuzzle"
QUESTPUZZLE.full_name = ".Cmd.QuestPuzzle"
QUESTPUZZLE.nested_types = {}
QUESTPUZZLE.enum_types = {}
QUESTPUZZLE.fields = {
  QUESTPUZZLE_VERSION_FIELD,
  QUESTPUZZLE_OPEN_PUZZLES_FIELD,
  QUESTPUZZLE_UNLOCK_PUZZLES_FIELD,
  QUESTPUZZLE_CANOPEN_PUZZLES_FIELD
}
QUESTPUZZLE.is_extendable = false
QUESTPUZZLE.extensions = {}
QUESTLIST_CMD_FIELD.name = "cmd"
QUESTLIST_CMD_FIELD.full_name = ".Cmd.QuestList.cmd"
QUESTLIST_CMD_FIELD.number = 1
QUESTLIST_CMD_FIELD.index = 0
QUESTLIST_CMD_FIELD.label = 1
QUESTLIST_CMD_FIELD.has_default_value = true
QUESTLIST_CMD_FIELD.default_value = 8
QUESTLIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTLIST_CMD_FIELD.type = 14
QUESTLIST_CMD_FIELD.cpp_type = 8
QUESTLIST_PARAM_FIELD.name = "param"
QUESTLIST_PARAM_FIELD.full_name = ".Cmd.QuestList.param"
QUESTLIST_PARAM_FIELD.number = 2
QUESTLIST_PARAM_FIELD.index = 1
QUESTLIST_PARAM_FIELD.label = 1
QUESTLIST_PARAM_FIELD.has_default_value = true
QUESTLIST_PARAM_FIELD.default_value = 1
QUESTLIST_PARAM_FIELD.enum_type = QUESTPARAM
QUESTLIST_PARAM_FIELD.type = 14
QUESTLIST_PARAM_FIELD.cpp_type = 8
QUESTLIST_TYPE_FIELD.name = "type"
QUESTLIST_TYPE_FIELD.full_name = ".Cmd.QuestList.type"
QUESTLIST_TYPE_FIELD.number = 3
QUESTLIST_TYPE_FIELD.index = 2
QUESTLIST_TYPE_FIELD.label = 1
QUESTLIST_TYPE_FIELD.has_default_value = true
QUESTLIST_TYPE_FIELD.default_value = 1
QUESTLIST_TYPE_FIELD.enum_type = EQUESTLIST
QUESTLIST_TYPE_FIELD.type = 14
QUESTLIST_TYPE_FIELD.cpp_type = 8
QUESTLIST_ID_FIELD.name = "id"
QUESTLIST_ID_FIELD.full_name = ".Cmd.QuestList.id"
QUESTLIST_ID_FIELD.number = 4
QUESTLIST_ID_FIELD.index = 3
QUESTLIST_ID_FIELD.label = 1
QUESTLIST_ID_FIELD.has_default_value = true
QUESTLIST_ID_FIELD.default_value = 0
QUESTLIST_ID_FIELD.type = 13
QUESTLIST_ID_FIELD.cpp_type = 3
QUESTLIST_LIST_FIELD.name = "list"
QUESTLIST_LIST_FIELD.full_name = ".Cmd.QuestList.list"
QUESTLIST_LIST_FIELD.number = 5
QUESTLIST_LIST_FIELD.index = 4
QUESTLIST_LIST_FIELD.label = 3
QUESTLIST_LIST_FIELD.has_default_value = false
QUESTLIST_LIST_FIELD.default_value = {}
QUESTLIST_LIST_FIELD.message_type = QUESTDATA
QUESTLIST_LIST_FIELD.type = 11
QUESTLIST_LIST_FIELD.cpp_type = 10
QUESTLIST_CLEAR_FIELD.name = "clear"
QUESTLIST_CLEAR_FIELD.full_name = ".Cmd.QuestList.clear"
QUESTLIST_CLEAR_FIELD.number = 6
QUESTLIST_CLEAR_FIELD.index = 5
QUESTLIST_CLEAR_FIELD.label = 1
QUESTLIST_CLEAR_FIELD.has_default_value = true
QUESTLIST_CLEAR_FIELD.default_value = false
QUESTLIST_CLEAR_FIELD.type = 8
QUESTLIST_CLEAR_FIELD.cpp_type = 7
QUESTLIST_OVER_FIELD.name = "over"
QUESTLIST_OVER_FIELD.full_name = ".Cmd.QuestList.over"
QUESTLIST_OVER_FIELD.number = 7
QUESTLIST_OVER_FIELD.index = 6
QUESTLIST_OVER_FIELD.label = 1
QUESTLIST_OVER_FIELD.has_default_value = false
QUESTLIST_OVER_FIELD.default_value = false
QUESTLIST_OVER_FIELD.type = 8
QUESTLIST_OVER_FIELD.cpp_type = 7
QUESTLIST.name = "QuestList"
QUESTLIST.full_name = ".Cmd.QuestList"
QUESTLIST.nested_types = {}
QUESTLIST.enum_types = {}
QUESTLIST.fields = {
  QUESTLIST_CMD_FIELD,
  QUESTLIST_PARAM_FIELD,
  QUESTLIST_TYPE_FIELD,
  QUESTLIST_ID_FIELD,
  QUESTLIST_LIST_FIELD,
  QUESTLIST_CLEAR_FIELD,
  QUESTLIST_OVER_FIELD
}
QUESTLIST.is_extendable = false
QUESTLIST.extensions = {}
QUESTUPDATEITEM_UPDATE_FIELD.name = "update"
QUESTUPDATEITEM_UPDATE_FIELD.full_name = ".Cmd.QuestUpdateItem.update"
QUESTUPDATEITEM_UPDATE_FIELD.number = 1
QUESTUPDATEITEM_UPDATE_FIELD.index = 0
QUESTUPDATEITEM_UPDATE_FIELD.label = 3
QUESTUPDATEITEM_UPDATE_FIELD.has_default_value = false
QUESTUPDATEITEM_UPDATE_FIELD.default_value = {}
QUESTUPDATEITEM_UPDATE_FIELD.message_type = QUESTDATA
QUESTUPDATEITEM_UPDATE_FIELD.type = 11
QUESTUPDATEITEM_UPDATE_FIELD.cpp_type = 10
QUESTUPDATEITEM_DEL_FIELD.name = "del"
QUESTUPDATEITEM_DEL_FIELD.full_name = ".Cmd.QuestUpdateItem.del"
QUESTUPDATEITEM_DEL_FIELD.number = 2
QUESTUPDATEITEM_DEL_FIELD.index = 1
QUESTUPDATEITEM_DEL_FIELD.label = 3
QUESTUPDATEITEM_DEL_FIELD.has_default_value = false
QUESTUPDATEITEM_DEL_FIELD.default_value = {}
QUESTUPDATEITEM_DEL_FIELD.type = 13
QUESTUPDATEITEM_DEL_FIELD.cpp_type = 3
QUESTUPDATEITEM_TYPE_FIELD.name = "type"
QUESTUPDATEITEM_TYPE_FIELD.full_name = ".Cmd.QuestUpdateItem.type"
QUESTUPDATEITEM_TYPE_FIELD.number = 3
QUESTUPDATEITEM_TYPE_FIELD.index = 2
QUESTUPDATEITEM_TYPE_FIELD.label = 1
QUESTUPDATEITEM_TYPE_FIELD.has_default_value = true
QUESTUPDATEITEM_TYPE_FIELD.default_value = 1
QUESTUPDATEITEM_TYPE_FIELD.enum_type = EQUESTLIST
QUESTUPDATEITEM_TYPE_FIELD.type = 14
QUESTUPDATEITEM_TYPE_FIELD.cpp_type = 8
QUESTUPDATEITEM.name = "QuestUpdateItem"
QUESTUPDATEITEM.full_name = ".Cmd.QuestUpdateItem"
QUESTUPDATEITEM.nested_types = {}
QUESTUPDATEITEM.enum_types = {}
QUESTUPDATEITEM.fields = {
  QUESTUPDATEITEM_UPDATE_FIELD,
  QUESTUPDATEITEM_DEL_FIELD,
  QUESTUPDATEITEM_TYPE_FIELD
}
QUESTUPDATEITEM.is_extendable = false
QUESTUPDATEITEM.extensions = {}
QUESTUPDATE_CMD_FIELD.name = "cmd"
QUESTUPDATE_CMD_FIELD.full_name = ".Cmd.QuestUpdate.cmd"
QUESTUPDATE_CMD_FIELD.number = 1
QUESTUPDATE_CMD_FIELD.index = 0
QUESTUPDATE_CMD_FIELD.label = 1
QUESTUPDATE_CMD_FIELD.has_default_value = true
QUESTUPDATE_CMD_FIELD.default_value = 8
QUESTUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTUPDATE_CMD_FIELD.type = 14
QUESTUPDATE_CMD_FIELD.cpp_type = 8
QUESTUPDATE_PARAM_FIELD.name = "param"
QUESTUPDATE_PARAM_FIELD.full_name = ".Cmd.QuestUpdate.param"
QUESTUPDATE_PARAM_FIELD.number = 2
QUESTUPDATE_PARAM_FIELD.index = 1
QUESTUPDATE_PARAM_FIELD.label = 1
QUESTUPDATE_PARAM_FIELD.has_default_value = true
QUESTUPDATE_PARAM_FIELD.default_value = 2
QUESTUPDATE_PARAM_FIELD.enum_type = QUESTPARAM
QUESTUPDATE_PARAM_FIELD.type = 14
QUESTUPDATE_PARAM_FIELD.cpp_type = 8
QUESTUPDATE_ITEMS_FIELD.name = "items"
QUESTUPDATE_ITEMS_FIELD.full_name = ".Cmd.QuestUpdate.items"
QUESTUPDATE_ITEMS_FIELD.number = 3
QUESTUPDATE_ITEMS_FIELD.index = 2
QUESTUPDATE_ITEMS_FIELD.label = 3
QUESTUPDATE_ITEMS_FIELD.has_default_value = false
QUESTUPDATE_ITEMS_FIELD.default_value = {}
QUESTUPDATE_ITEMS_FIELD.message_type = QUESTUPDATEITEM
QUESTUPDATE_ITEMS_FIELD.type = 11
QUESTUPDATE_ITEMS_FIELD.cpp_type = 10
QUESTUPDATE.name = "QuestUpdate"
QUESTUPDATE.full_name = ".Cmd.QuestUpdate"
QUESTUPDATE.nested_types = {}
QUESTUPDATE.enum_types = {}
QUESTUPDATE.fields = {
  QUESTUPDATE_CMD_FIELD,
  QUESTUPDATE_PARAM_FIELD,
  QUESTUPDATE_ITEMS_FIELD
}
QUESTUPDATE.is_extendable = false
QUESTUPDATE.extensions = {}
QUESTSTEPUPDATE_CMD_FIELD.name = "cmd"
QUESTSTEPUPDATE_CMD_FIELD.full_name = ".Cmd.QuestStepUpdate.cmd"
QUESTSTEPUPDATE_CMD_FIELD.number = 1
QUESTSTEPUPDATE_CMD_FIELD.index = 0
QUESTSTEPUPDATE_CMD_FIELD.label = 1
QUESTSTEPUPDATE_CMD_FIELD.has_default_value = true
QUESTSTEPUPDATE_CMD_FIELD.default_value = 8
QUESTSTEPUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTSTEPUPDATE_CMD_FIELD.type = 14
QUESTSTEPUPDATE_CMD_FIELD.cpp_type = 8
QUESTSTEPUPDATE_PARAM_FIELD.name = "param"
QUESTSTEPUPDATE_PARAM_FIELD.full_name = ".Cmd.QuestStepUpdate.param"
QUESTSTEPUPDATE_PARAM_FIELD.number = 2
QUESTSTEPUPDATE_PARAM_FIELD.index = 1
QUESTSTEPUPDATE_PARAM_FIELD.label = 1
QUESTSTEPUPDATE_PARAM_FIELD.has_default_value = true
QUESTSTEPUPDATE_PARAM_FIELD.default_value = 5
QUESTSTEPUPDATE_PARAM_FIELD.enum_type = QUESTPARAM
QUESTSTEPUPDATE_PARAM_FIELD.type = 14
QUESTSTEPUPDATE_PARAM_FIELD.cpp_type = 8
QUESTSTEPUPDATE_ID_FIELD.name = "id"
QUESTSTEPUPDATE_ID_FIELD.full_name = ".Cmd.QuestStepUpdate.id"
QUESTSTEPUPDATE_ID_FIELD.number = 3
QUESTSTEPUPDATE_ID_FIELD.index = 2
QUESTSTEPUPDATE_ID_FIELD.label = 1
QUESTSTEPUPDATE_ID_FIELD.has_default_value = true
QUESTSTEPUPDATE_ID_FIELD.default_value = 0
QUESTSTEPUPDATE_ID_FIELD.type = 13
QUESTSTEPUPDATE_ID_FIELD.cpp_type = 3
QUESTSTEPUPDATE_STEP_FIELD.name = "step"
QUESTSTEPUPDATE_STEP_FIELD.full_name = ".Cmd.QuestStepUpdate.step"
QUESTSTEPUPDATE_STEP_FIELD.number = 4
QUESTSTEPUPDATE_STEP_FIELD.index = 3
QUESTSTEPUPDATE_STEP_FIELD.label = 1
QUESTSTEPUPDATE_STEP_FIELD.has_default_value = true
QUESTSTEPUPDATE_STEP_FIELD.default_value = 0
QUESTSTEPUPDATE_STEP_FIELD.type = 13
QUESTSTEPUPDATE_STEP_FIELD.cpp_type = 3
QUESTSTEPUPDATE_DATA_FIELD.name = "data"
QUESTSTEPUPDATE_DATA_FIELD.full_name = ".Cmd.QuestStepUpdate.data"
QUESTSTEPUPDATE_DATA_FIELD.number = 5
QUESTSTEPUPDATE_DATA_FIELD.index = 4
QUESTSTEPUPDATE_DATA_FIELD.label = 1
QUESTSTEPUPDATE_DATA_FIELD.has_default_value = false
QUESTSTEPUPDATE_DATA_FIELD.default_value = nil
QUESTSTEPUPDATE_DATA_FIELD.message_type = QUESTSTEP
QUESTSTEPUPDATE_DATA_FIELD.type = 11
QUESTSTEPUPDATE_DATA_FIELD.cpp_type = 10
QUESTSTEPUPDATE.name = "QuestStepUpdate"
QUESTSTEPUPDATE.full_name = ".Cmd.QuestStepUpdate"
QUESTSTEPUPDATE.nested_types = {}
QUESTSTEPUPDATE.enum_types = {}
QUESTSTEPUPDATE.fields = {
  QUESTSTEPUPDATE_CMD_FIELD,
  QUESTSTEPUPDATE_PARAM_FIELD,
  QUESTSTEPUPDATE_ID_FIELD,
  QUESTSTEPUPDATE_STEP_FIELD,
  QUESTSTEPUPDATE_DATA_FIELD
}
QUESTSTEPUPDATE.is_extendable = false
QUESTSTEPUPDATE.extensions = {}
QUESTACTION_CMD_FIELD.name = "cmd"
QUESTACTION_CMD_FIELD.full_name = ".Cmd.QuestAction.cmd"
QUESTACTION_CMD_FIELD.number = 1
QUESTACTION_CMD_FIELD.index = 0
QUESTACTION_CMD_FIELD.label = 1
QUESTACTION_CMD_FIELD.has_default_value = true
QUESTACTION_CMD_FIELD.default_value = 8
QUESTACTION_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTACTION_CMD_FIELD.type = 14
QUESTACTION_CMD_FIELD.cpp_type = 8
QUESTACTION_PARAM_FIELD.name = "param"
QUESTACTION_PARAM_FIELD.full_name = ".Cmd.QuestAction.param"
QUESTACTION_PARAM_FIELD.number = 2
QUESTACTION_PARAM_FIELD.index = 1
QUESTACTION_PARAM_FIELD.label = 1
QUESTACTION_PARAM_FIELD.has_default_value = true
QUESTACTION_PARAM_FIELD.default_value = 3
QUESTACTION_PARAM_FIELD.enum_type = QUESTPARAM
QUESTACTION_PARAM_FIELD.type = 14
QUESTACTION_PARAM_FIELD.cpp_type = 8
QUESTACTION_ACTION_FIELD.name = "action"
QUESTACTION_ACTION_FIELD.full_name = ".Cmd.QuestAction.action"
QUESTACTION_ACTION_FIELD.number = 3
QUESTACTION_ACTION_FIELD.index = 2
QUESTACTION_ACTION_FIELD.label = 1
QUESTACTION_ACTION_FIELD.has_default_value = true
QUESTACTION_ACTION_FIELD.default_value = 0
QUESTACTION_ACTION_FIELD.enum_type = EQUESTACTION
QUESTACTION_ACTION_FIELD.type = 14
QUESTACTION_ACTION_FIELD.cpp_type = 8
QUESTACTION_QUESTID_FIELD.name = "questid"
QUESTACTION_QUESTID_FIELD.full_name = ".Cmd.QuestAction.questid"
QUESTACTION_QUESTID_FIELD.number = 4
QUESTACTION_QUESTID_FIELD.index = 3
QUESTACTION_QUESTID_FIELD.label = 1
QUESTACTION_QUESTID_FIELD.has_default_value = true
QUESTACTION_QUESTID_FIELD.default_value = 0
QUESTACTION_QUESTID_FIELD.type = 13
QUESTACTION_QUESTID_FIELD.cpp_type = 3
QUESTACTION.name = "QuestAction"
QUESTACTION.full_name = ".Cmd.QuestAction"
QUESTACTION.nested_types = {}
QUESTACTION.enum_types = {}
QUESTACTION.fields = {
  QUESTACTION_CMD_FIELD,
  QUESTACTION_PARAM_FIELD,
  QUESTACTION_ACTION_FIELD,
  QUESTACTION_QUESTID_FIELD
}
QUESTACTION.is_extendable = false
QUESTACTION.extensions = {}
RUNQUESTSTEP_CMD_FIELD.name = "cmd"
RUNQUESTSTEP_CMD_FIELD.full_name = ".Cmd.RunQuestStep.cmd"
RUNQUESTSTEP_CMD_FIELD.number = 1
RUNQUESTSTEP_CMD_FIELD.index = 0
RUNQUESTSTEP_CMD_FIELD.label = 1
RUNQUESTSTEP_CMD_FIELD.has_default_value = true
RUNQUESTSTEP_CMD_FIELD.default_value = 8
RUNQUESTSTEP_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RUNQUESTSTEP_CMD_FIELD.type = 14
RUNQUESTSTEP_CMD_FIELD.cpp_type = 8
RUNQUESTSTEP_PARAM_FIELD.name = "param"
RUNQUESTSTEP_PARAM_FIELD.full_name = ".Cmd.RunQuestStep.param"
RUNQUESTSTEP_PARAM_FIELD.number = 2
RUNQUESTSTEP_PARAM_FIELD.index = 1
RUNQUESTSTEP_PARAM_FIELD.label = 1
RUNQUESTSTEP_PARAM_FIELD.has_default_value = true
RUNQUESTSTEP_PARAM_FIELD.default_value = 4
RUNQUESTSTEP_PARAM_FIELD.enum_type = QUESTPARAM
RUNQUESTSTEP_PARAM_FIELD.type = 14
RUNQUESTSTEP_PARAM_FIELD.cpp_type = 8
RUNQUESTSTEP_QUESTID_FIELD.name = "questid"
RUNQUESTSTEP_QUESTID_FIELD.full_name = ".Cmd.RunQuestStep.questid"
RUNQUESTSTEP_QUESTID_FIELD.number = 3
RUNQUESTSTEP_QUESTID_FIELD.index = 2
RUNQUESTSTEP_QUESTID_FIELD.label = 1
RUNQUESTSTEP_QUESTID_FIELD.has_default_value = true
RUNQUESTSTEP_QUESTID_FIELD.default_value = 0
RUNQUESTSTEP_QUESTID_FIELD.type = 13
RUNQUESTSTEP_QUESTID_FIELD.cpp_type = 3
RUNQUESTSTEP_STARID_FIELD.name = "starid"
RUNQUESTSTEP_STARID_FIELD.full_name = ".Cmd.RunQuestStep.starid"
RUNQUESTSTEP_STARID_FIELD.number = 4
RUNQUESTSTEP_STARID_FIELD.index = 3
RUNQUESTSTEP_STARID_FIELD.label = 1
RUNQUESTSTEP_STARID_FIELD.has_default_value = true
RUNQUESTSTEP_STARID_FIELD.default_value = 0
RUNQUESTSTEP_STARID_FIELD.type = 13
RUNQUESTSTEP_STARID_FIELD.cpp_type = 3
RUNQUESTSTEP_SUBGROUP_FIELD.name = "subgroup"
RUNQUESTSTEP_SUBGROUP_FIELD.full_name = ".Cmd.RunQuestStep.subgroup"
RUNQUESTSTEP_SUBGROUP_FIELD.number = 5
RUNQUESTSTEP_SUBGROUP_FIELD.index = 4
RUNQUESTSTEP_SUBGROUP_FIELD.label = 1
RUNQUESTSTEP_SUBGROUP_FIELD.has_default_value = true
RUNQUESTSTEP_SUBGROUP_FIELD.default_value = 0
RUNQUESTSTEP_SUBGROUP_FIELD.type = 13
RUNQUESTSTEP_SUBGROUP_FIELD.cpp_type = 3
RUNQUESTSTEP_STEP_FIELD.name = "step"
RUNQUESTSTEP_STEP_FIELD.full_name = ".Cmd.RunQuestStep.step"
RUNQUESTSTEP_STEP_FIELD.number = 6
RUNQUESTSTEP_STEP_FIELD.index = 5
RUNQUESTSTEP_STEP_FIELD.label = 1
RUNQUESTSTEP_STEP_FIELD.has_default_value = true
RUNQUESTSTEP_STEP_FIELD.default_value = 0
RUNQUESTSTEP_STEP_FIELD.type = 13
RUNQUESTSTEP_STEP_FIELD.cpp_type = 3
RUNQUESTSTEP.name = "RunQuestStep"
RUNQUESTSTEP.full_name = ".Cmd.RunQuestStep"
RUNQUESTSTEP.nested_types = {}
RUNQUESTSTEP.enum_types = {}
RUNQUESTSTEP.fields = {
  RUNQUESTSTEP_CMD_FIELD,
  RUNQUESTSTEP_PARAM_FIELD,
  RUNQUESTSTEP_QUESTID_FIELD,
  RUNQUESTSTEP_STARID_FIELD,
  RUNQUESTSTEP_SUBGROUP_FIELD,
  RUNQUESTSTEP_STEP_FIELD
}
RUNQUESTSTEP.is_extendable = false
RUNQUESTSTEP.extensions = {}
QUESTTRACE_CMD_FIELD.name = "cmd"
QUESTTRACE_CMD_FIELD.full_name = ".Cmd.QuestTrace.cmd"
QUESTTRACE_CMD_FIELD.number = 1
QUESTTRACE_CMD_FIELD.index = 0
QUESTTRACE_CMD_FIELD.label = 1
QUESTTRACE_CMD_FIELD.has_default_value = true
QUESTTRACE_CMD_FIELD.default_value = 8
QUESTTRACE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTTRACE_CMD_FIELD.type = 14
QUESTTRACE_CMD_FIELD.cpp_type = 8
QUESTTRACE_PARAM_FIELD.name = "param"
QUESTTRACE_PARAM_FIELD.full_name = ".Cmd.QuestTrace.param"
QUESTTRACE_PARAM_FIELD.number = 2
QUESTTRACE_PARAM_FIELD.index = 1
QUESTTRACE_PARAM_FIELD.label = 1
QUESTTRACE_PARAM_FIELD.has_default_value = true
QUESTTRACE_PARAM_FIELD.default_value = 6
QUESTTRACE_PARAM_FIELD.enum_type = QUESTPARAM
QUESTTRACE_PARAM_FIELD.type = 14
QUESTTRACE_PARAM_FIELD.cpp_type = 8
QUESTTRACE_QUESTID_FIELD.name = "questid"
QUESTTRACE_QUESTID_FIELD.full_name = ".Cmd.QuestTrace.questid"
QUESTTRACE_QUESTID_FIELD.number = 3
QUESTTRACE_QUESTID_FIELD.index = 2
QUESTTRACE_QUESTID_FIELD.label = 1
QUESTTRACE_QUESTID_FIELD.has_default_value = true
QUESTTRACE_QUESTID_FIELD.default_value = 0
QUESTTRACE_QUESTID_FIELD.type = 13
QUESTTRACE_QUESTID_FIELD.cpp_type = 3
QUESTTRACE_TRACE_FIELD.name = "trace"
QUESTTRACE_TRACE_FIELD.full_name = ".Cmd.QuestTrace.trace"
QUESTTRACE_TRACE_FIELD.number = 4
QUESTTRACE_TRACE_FIELD.index = 3
QUESTTRACE_TRACE_FIELD.label = 1
QUESTTRACE_TRACE_FIELD.has_default_value = true
QUESTTRACE_TRACE_FIELD.default_value = false
QUESTTRACE_TRACE_FIELD.type = 8
QUESTTRACE_TRACE_FIELD.cpp_type = 7
QUESTTRACE.name = "QuestTrace"
QUESTTRACE.full_name = ".Cmd.QuestTrace"
QUESTTRACE.nested_types = {}
QUESTTRACE.enum_types = {}
QUESTTRACE.fields = {
  QUESTTRACE_CMD_FIELD,
  QUESTTRACE_PARAM_FIELD,
  QUESTTRACE_QUESTID_FIELD,
  QUESTTRACE_TRACE_FIELD
}
QUESTTRACE.is_extendable = false
QUESTTRACE.extensions = {}
QUESTDETAIL_ID_FIELD.name = "id"
QUESTDETAIL_ID_FIELD.full_name = ".Cmd.QuestDetail.id"
QUESTDETAIL_ID_FIELD.number = 1
QUESTDETAIL_ID_FIELD.index = 0
QUESTDETAIL_ID_FIELD.label = 1
QUESTDETAIL_ID_FIELD.has_default_value = true
QUESTDETAIL_ID_FIELD.default_value = 0
QUESTDETAIL_ID_FIELD.type = 13
QUESTDETAIL_ID_FIELD.cpp_type = 3
QUESTDETAIL_TIME_FIELD.name = "time"
QUESTDETAIL_TIME_FIELD.full_name = ".Cmd.QuestDetail.time"
QUESTDETAIL_TIME_FIELD.number = 2
QUESTDETAIL_TIME_FIELD.index = 1
QUESTDETAIL_TIME_FIELD.label = 1
QUESTDETAIL_TIME_FIELD.has_default_value = true
QUESTDETAIL_TIME_FIELD.default_value = 0
QUESTDETAIL_TIME_FIELD.type = 13
QUESTDETAIL_TIME_FIELD.cpp_type = 3
QUESTDETAIL_MAP_FIELD.name = "map"
QUESTDETAIL_MAP_FIELD.full_name = ".Cmd.QuestDetail.map"
QUESTDETAIL_MAP_FIELD.number = 3
QUESTDETAIL_MAP_FIELD.index = 2
QUESTDETAIL_MAP_FIELD.label = 1
QUESTDETAIL_MAP_FIELD.has_default_value = true
QUESTDETAIL_MAP_FIELD.default_value = 0
QUESTDETAIL_MAP_FIELD.type = 13
QUESTDETAIL_MAP_FIELD.cpp_type = 3
QUESTDETAIL_COMPLETE_FIELD.name = "complete"
QUESTDETAIL_COMPLETE_FIELD.full_name = ".Cmd.QuestDetail.complete"
QUESTDETAIL_COMPLETE_FIELD.number = 4
QUESTDETAIL_COMPLETE_FIELD.index = 3
QUESTDETAIL_COMPLETE_FIELD.label = 1
QUESTDETAIL_COMPLETE_FIELD.has_default_value = true
QUESTDETAIL_COMPLETE_FIELD.default_value = false
QUESTDETAIL_COMPLETE_FIELD.type = 8
QUESTDETAIL_COMPLETE_FIELD.cpp_type = 7
QUESTDETAIL_TRACE_FIELD.name = "trace"
QUESTDETAIL_TRACE_FIELD.full_name = ".Cmd.QuestDetail.trace"
QUESTDETAIL_TRACE_FIELD.number = 5
QUESTDETAIL_TRACE_FIELD.index = 4
QUESTDETAIL_TRACE_FIELD.label = 1
QUESTDETAIL_TRACE_FIELD.has_default_value = true
QUESTDETAIL_TRACE_FIELD.default_value = true
QUESTDETAIL_TRACE_FIELD.type = 8
QUESTDETAIL_TRACE_FIELD.cpp_type = 7
QUESTDETAIL_DETAILS_FIELD.name = "details"
QUESTDETAIL_DETAILS_FIELD.full_name = ".Cmd.QuestDetail.details"
QUESTDETAIL_DETAILS_FIELD.number = 6
QUESTDETAIL_DETAILS_FIELD.index = 5
QUESTDETAIL_DETAILS_FIELD.label = 3
QUESTDETAIL_DETAILS_FIELD.has_default_value = false
QUESTDETAIL_DETAILS_FIELD.default_value = {}
QUESTDETAIL_DETAILS_FIELD.type = 13
QUESTDETAIL_DETAILS_FIELD.cpp_type = 3
QUESTDETAIL.name = "QuestDetail"
QUESTDETAIL.full_name = ".Cmd.QuestDetail"
QUESTDETAIL.nested_types = {}
QUESTDETAIL.enum_types = {}
QUESTDETAIL.fields = {
  QUESTDETAIL_ID_FIELD,
  QUESTDETAIL_TIME_FIELD,
  QUESTDETAIL_MAP_FIELD,
  QUESTDETAIL_COMPLETE_FIELD,
  QUESTDETAIL_TRACE_FIELD,
  QUESTDETAIL_DETAILS_FIELD
}
QUESTDETAIL.is_extendable = false
QUESTDETAIL.extensions = {}
QUESTDETAILLIST_CMD_FIELD.name = "cmd"
QUESTDETAILLIST_CMD_FIELD.full_name = ".Cmd.QuestDetailList.cmd"
QUESTDETAILLIST_CMD_FIELD.number = 1
QUESTDETAILLIST_CMD_FIELD.index = 0
QUESTDETAILLIST_CMD_FIELD.label = 1
QUESTDETAILLIST_CMD_FIELD.has_default_value = true
QUESTDETAILLIST_CMD_FIELD.default_value = 8
QUESTDETAILLIST_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTDETAILLIST_CMD_FIELD.type = 14
QUESTDETAILLIST_CMD_FIELD.cpp_type = 8
QUESTDETAILLIST_PARAM_FIELD.name = "param"
QUESTDETAILLIST_PARAM_FIELD.full_name = ".Cmd.QuestDetailList.param"
QUESTDETAILLIST_PARAM_FIELD.number = 2
QUESTDETAILLIST_PARAM_FIELD.index = 1
QUESTDETAILLIST_PARAM_FIELD.label = 1
QUESTDETAILLIST_PARAM_FIELD.has_default_value = true
QUESTDETAILLIST_PARAM_FIELD.default_value = 7
QUESTDETAILLIST_PARAM_FIELD.enum_type = QUESTPARAM
QUESTDETAILLIST_PARAM_FIELD.type = 14
QUESTDETAILLIST_PARAM_FIELD.cpp_type = 8
QUESTDETAILLIST_DETAILS_FIELD.name = "details"
QUESTDETAILLIST_DETAILS_FIELD.full_name = ".Cmd.QuestDetailList.details"
QUESTDETAILLIST_DETAILS_FIELD.number = 3
QUESTDETAILLIST_DETAILS_FIELD.index = 2
QUESTDETAILLIST_DETAILS_FIELD.label = 3
QUESTDETAILLIST_DETAILS_FIELD.has_default_value = false
QUESTDETAILLIST_DETAILS_FIELD.default_value = {}
QUESTDETAILLIST_DETAILS_FIELD.message_type = QUESTDETAIL
QUESTDETAILLIST_DETAILS_FIELD.type = 11
QUESTDETAILLIST_DETAILS_FIELD.cpp_type = 10
QUESTDETAILLIST.name = "QuestDetailList"
QUESTDETAILLIST.full_name = ".Cmd.QuestDetailList"
QUESTDETAILLIST.nested_types = {}
QUESTDETAILLIST.enum_types = {}
QUESTDETAILLIST.fields = {
  QUESTDETAILLIST_CMD_FIELD,
  QUESTDETAILLIST_PARAM_FIELD,
  QUESTDETAILLIST_DETAILS_FIELD
}
QUESTDETAILLIST.is_extendable = false
QUESTDETAILLIST.extensions = {}
QUESTDETAILUPDATE_CMD_FIELD.name = "cmd"
QUESTDETAILUPDATE_CMD_FIELD.full_name = ".Cmd.QuestDetailUpdate.cmd"
QUESTDETAILUPDATE_CMD_FIELD.number = 1
QUESTDETAILUPDATE_CMD_FIELD.index = 0
QUESTDETAILUPDATE_CMD_FIELD.label = 1
QUESTDETAILUPDATE_CMD_FIELD.has_default_value = true
QUESTDETAILUPDATE_CMD_FIELD.default_value = 8
QUESTDETAILUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTDETAILUPDATE_CMD_FIELD.type = 14
QUESTDETAILUPDATE_CMD_FIELD.cpp_type = 8
QUESTDETAILUPDATE_PARAM_FIELD.name = "param"
QUESTDETAILUPDATE_PARAM_FIELD.full_name = ".Cmd.QuestDetailUpdate.param"
QUESTDETAILUPDATE_PARAM_FIELD.number = 2
QUESTDETAILUPDATE_PARAM_FIELD.index = 1
QUESTDETAILUPDATE_PARAM_FIELD.label = 1
QUESTDETAILUPDATE_PARAM_FIELD.has_default_value = true
QUESTDETAILUPDATE_PARAM_FIELD.default_value = 8
QUESTDETAILUPDATE_PARAM_FIELD.enum_type = QUESTPARAM
QUESTDETAILUPDATE_PARAM_FIELD.type = 14
QUESTDETAILUPDATE_PARAM_FIELD.cpp_type = 8
QUESTDETAILUPDATE_DETAIL_FIELD.name = "detail"
QUESTDETAILUPDATE_DETAIL_FIELD.full_name = ".Cmd.QuestDetailUpdate.detail"
QUESTDETAILUPDATE_DETAIL_FIELD.number = 3
QUESTDETAILUPDATE_DETAIL_FIELD.index = 2
QUESTDETAILUPDATE_DETAIL_FIELD.label = 3
QUESTDETAILUPDATE_DETAIL_FIELD.has_default_value = false
QUESTDETAILUPDATE_DETAIL_FIELD.default_value = {}
QUESTDETAILUPDATE_DETAIL_FIELD.message_type = QUESTDETAIL
QUESTDETAILUPDATE_DETAIL_FIELD.type = 11
QUESTDETAILUPDATE_DETAIL_FIELD.cpp_type = 10
QUESTDETAILUPDATE_DEL_FIELD.name = "del"
QUESTDETAILUPDATE_DEL_FIELD.full_name = ".Cmd.QuestDetailUpdate.del"
QUESTDETAILUPDATE_DEL_FIELD.number = 4
QUESTDETAILUPDATE_DEL_FIELD.index = 3
QUESTDETAILUPDATE_DEL_FIELD.label = 3
QUESTDETAILUPDATE_DEL_FIELD.has_default_value = false
QUESTDETAILUPDATE_DEL_FIELD.default_value = {}
QUESTDETAILUPDATE_DEL_FIELD.message_type = QUESTDETAIL
QUESTDETAILUPDATE_DEL_FIELD.type = 11
QUESTDETAILUPDATE_DEL_FIELD.cpp_type = 10
QUESTDETAILUPDATE.name = "QuestDetailUpdate"
QUESTDETAILUPDATE.full_name = ".Cmd.QuestDetailUpdate"
QUESTDETAILUPDATE.nested_types = {}
QUESTDETAILUPDATE.enum_types = {}
QUESTDETAILUPDATE.fields = {
  QUESTDETAILUPDATE_CMD_FIELD,
  QUESTDETAILUPDATE_PARAM_FIELD,
  QUESTDETAILUPDATE_DETAIL_FIELD,
  QUESTDETAILUPDATE_DEL_FIELD
}
QUESTDETAILUPDATE.is_extendable = false
QUESTDETAILUPDATE.extensions = {}
QUESTRAIDCMD_CMD_FIELD.name = "cmd"
QUESTRAIDCMD_CMD_FIELD.full_name = ".Cmd.QuestRaidCmd.cmd"
QUESTRAIDCMD_CMD_FIELD.number = 1
QUESTRAIDCMD_CMD_FIELD.index = 0
QUESTRAIDCMD_CMD_FIELD.label = 1
QUESTRAIDCMD_CMD_FIELD.has_default_value = true
QUESTRAIDCMD_CMD_FIELD.default_value = 8
QUESTRAIDCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTRAIDCMD_CMD_FIELD.type = 14
QUESTRAIDCMD_CMD_FIELD.cpp_type = 8
QUESTRAIDCMD_PARAM_FIELD.name = "param"
QUESTRAIDCMD_PARAM_FIELD.full_name = ".Cmd.QuestRaidCmd.param"
QUESTRAIDCMD_PARAM_FIELD.number = 2
QUESTRAIDCMD_PARAM_FIELD.index = 1
QUESTRAIDCMD_PARAM_FIELD.label = 1
QUESTRAIDCMD_PARAM_FIELD.has_default_value = true
QUESTRAIDCMD_PARAM_FIELD.default_value = 9
QUESTRAIDCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUESTRAIDCMD_PARAM_FIELD.type = 14
QUESTRAIDCMD_PARAM_FIELD.cpp_type = 8
QUESTRAIDCMD_QUESTID_FIELD.name = "questid"
QUESTRAIDCMD_QUESTID_FIELD.full_name = ".Cmd.QuestRaidCmd.questid"
QUESTRAIDCMD_QUESTID_FIELD.number = 3
QUESTRAIDCMD_QUESTID_FIELD.index = 2
QUESTRAIDCMD_QUESTID_FIELD.label = 1
QUESTRAIDCMD_QUESTID_FIELD.has_default_value = false
QUESTRAIDCMD_QUESTID_FIELD.default_value = 0
QUESTRAIDCMD_QUESTID_FIELD.type = 13
QUESTRAIDCMD_QUESTID_FIELD.cpp_type = 3
QUESTRAIDCMD.name = "QuestRaidCmd"
QUESTRAIDCMD.full_name = ".Cmd.QuestRaidCmd"
QUESTRAIDCMD.nested_types = {}
QUESTRAIDCMD.enum_types = {}
QUESTRAIDCMD.fields = {
  QUESTRAIDCMD_CMD_FIELD,
  QUESTRAIDCMD_PARAM_FIELD,
  QUESTRAIDCMD_QUESTID_FIELD
}
QUESTRAIDCMD.is_extendable = false
QUESTRAIDCMD.extensions = {}
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.name = "cmd"
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.full_name = ".Cmd.QuestCanAcceptListChange.cmd"
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.number = 1
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.index = 0
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.label = 1
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.has_default_value = true
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.default_value = 8
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.type = 14
QUESTCANACCEPTLISTCHANGE_CMD_FIELD.cpp_type = 8
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.name = "param"
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.full_name = ".Cmd.QuestCanAcceptListChange.param"
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.number = 2
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.index = 1
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.label = 1
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.has_default_value = true
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.default_value = 10
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.enum_type = QUESTPARAM
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.type = 14
QUESTCANACCEPTLISTCHANGE_PARAM_FIELD.cpp_type = 8
QUESTCANACCEPTLISTCHANGE.name = "QuestCanAcceptListChange"
QUESTCANACCEPTLISTCHANGE.full_name = ".Cmd.QuestCanAcceptListChange"
QUESTCANACCEPTLISTCHANGE.nested_types = {}
QUESTCANACCEPTLISTCHANGE.enum_types = {}
QUESTCANACCEPTLISTCHANGE.fields = {
  QUESTCANACCEPTLISTCHANGE_CMD_FIELD,
  QUESTCANACCEPTLISTCHANGE_PARAM_FIELD
}
QUESTCANACCEPTLISTCHANGE.is_extendable = false
QUESTCANACCEPTLISTCHANGE.extensions = {}
VISITNPCUSERCMD_CMD_FIELD.name = "cmd"
VISITNPCUSERCMD_CMD_FIELD.full_name = ".Cmd.VisitNpcUserCmd.cmd"
VISITNPCUSERCMD_CMD_FIELD.number = 1
VISITNPCUSERCMD_CMD_FIELD.index = 0
VISITNPCUSERCMD_CMD_FIELD.label = 1
VISITNPCUSERCMD_CMD_FIELD.has_default_value = true
VISITNPCUSERCMD_CMD_FIELD.default_value = 8
VISITNPCUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
VISITNPCUSERCMD_CMD_FIELD.type = 14
VISITNPCUSERCMD_CMD_FIELD.cpp_type = 8
VISITNPCUSERCMD_PARAM_FIELD.name = "param"
VISITNPCUSERCMD_PARAM_FIELD.full_name = ".Cmd.VisitNpcUserCmd.param"
VISITNPCUSERCMD_PARAM_FIELD.number = 2
VISITNPCUSERCMD_PARAM_FIELD.index = 1
VISITNPCUSERCMD_PARAM_FIELD.label = 1
VISITNPCUSERCMD_PARAM_FIELD.has_default_value = true
VISITNPCUSERCMD_PARAM_FIELD.default_value = 11
VISITNPCUSERCMD_PARAM_FIELD.enum_type = QUESTPARAM
VISITNPCUSERCMD_PARAM_FIELD.type = 14
VISITNPCUSERCMD_PARAM_FIELD.cpp_type = 8
VISITNPCUSERCMD_NPCTEMPID_FIELD.name = "npctempid"
VISITNPCUSERCMD_NPCTEMPID_FIELD.full_name = ".Cmd.VisitNpcUserCmd.npctempid"
VISITNPCUSERCMD_NPCTEMPID_FIELD.number = 3
VISITNPCUSERCMD_NPCTEMPID_FIELD.index = 2
VISITNPCUSERCMD_NPCTEMPID_FIELD.label = 1
VISITNPCUSERCMD_NPCTEMPID_FIELD.has_default_value = true
VISITNPCUSERCMD_NPCTEMPID_FIELD.default_value = 0
VISITNPCUSERCMD_NPCTEMPID_FIELD.type = 4
VISITNPCUSERCMD_NPCTEMPID_FIELD.cpp_type = 4
VISITNPCUSERCMD_SYNC_SCENE_FIELD.name = "sync_scene"
VISITNPCUSERCMD_SYNC_SCENE_FIELD.full_name = ".Cmd.VisitNpcUserCmd.sync_scene"
VISITNPCUSERCMD_SYNC_SCENE_FIELD.number = 4
VISITNPCUSERCMD_SYNC_SCENE_FIELD.index = 3
VISITNPCUSERCMD_SYNC_SCENE_FIELD.label = 1
VISITNPCUSERCMD_SYNC_SCENE_FIELD.has_default_value = true
VISITNPCUSERCMD_SYNC_SCENE_FIELD.default_value = false
VISITNPCUSERCMD_SYNC_SCENE_FIELD.type = 8
VISITNPCUSERCMD_SYNC_SCENE_FIELD.cpp_type = 7
VISITNPCUSERCMD.name = "VisitNpcUserCmd"
VISITNPCUSERCMD.full_name = ".Cmd.VisitNpcUserCmd"
VISITNPCUSERCMD.nested_types = {}
VISITNPCUSERCMD.enum_types = {}
VISITNPCUSERCMD.fields = {
  VISITNPCUSERCMD_CMD_FIELD,
  VISITNPCUSERCMD_PARAM_FIELD,
  VISITNPCUSERCMD_NPCTEMPID_FIELD,
  VISITNPCUSERCMD_SYNC_SCENE_FIELD
}
VISITNPCUSERCMD.is_extendable = false
VISITNPCUSERCMD.extensions = {}
WORLDTREASURE_QUESTID_FIELD.name = "questid"
WORLDTREASURE_QUESTID_FIELD.full_name = ".Cmd.WorldTreasure.questid"
WORLDTREASURE_QUESTID_FIELD.number = 1
WORLDTREASURE_QUESTID_FIELD.index = 0
WORLDTREASURE_QUESTID_FIELD.label = 1
WORLDTREASURE_QUESTID_FIELD.has_default_value = true
WORLDTREASURE_QUESTID_FIELD.default_value = 0
WORLDTREASURE_QUESTID_FIELD.type = 13
WORLDTREASURE_QUESTID_FIELD.cpp_type = 3
WORLDTREASURE_NPCID_FIELD.name = "npcid"
WORLDTREASURE_NPCID_FIELD.full_name = ".Cmd.WorldTreasure.npcid"
WORLDTREASURE_NPCID_FIELD.number = 2
WORLDTREASURE_NPCID_FIELD.index = 1
WORLDTREASURE_NPCID_FIELD.label = 1
WORLDTREASURE_NPCID_FIELD.has_default_value = true
WORLDTREASURE_NPCID_FIELD.default_value = 0
WORLDTREASURE_NPCID_FIELD.type = 13
WORLDTREASURE_NPCID_FIELD.cpp_type = 3
WORLDTREASURE_POS_FIELD.name = "pos"
WORLDTREASURE_POS_FIELD.full_name = ".Cmd.WorldTreasure.pos"
WORLDTREASURE_POS_FIELD.number = 3
WORLDTREASURE_POS_FIELD.index = 2
WORLDTREASURE_POS_FIELD.label = 1
WORLDTREASURE_POS_FIELD.has_default_value = false
WORLDTREASURE_POS_FIELD.default_value = nil
WORLDTREASURE_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
WORLDTREASURE_POS_FIELD.type = 11
WORLDTREASURE_POS_FIELD.cpp_type = 10
WORLDTREASURE.name = "WorldTreasure"
WORLDTREASURE.full_name = ".Cmd.WorldTreasure"
WORLDTREASURE.nested_types = {}
WORLDTREASURE.enum_types = {}
WORLDTREASURE.fields = {
  WORLDTREASURE_QUESTID_FIELD,
  WORLDTREASURE_NPCID_FIELD,
  WORLDTREASURE_POS_FIELD
}
WORLDTREASURE.is_extendable = false
WORLDTREASURE.extensions = {}
OTHERDATA_DATA_FIELD.name = "data"
OTHERDATA_DATA_FIELD.full_name = ".Cmd.OtherData.data"
OTHERDATA_DATA_FIELD.number = 1
OTHERDATA_DATA_FIELD.index = 0
OTHERDATA_DATA_FIELD.label = 1
OTHERDATA_DATA_FIELD.has_default_value = true
OTHERDATA_DATA_FIELD.default_value = 0
OTHERDATA_DATA_FIELD.enum_type = EOTHERDATA
OTHERDATA_DATA_FIELD.type = 14
OTHERDATA_DATA_FIELD.cpp_type = 8
OTHERDATA_PARAM1_FIELD.name = "param1"
OTHERDATA_PARAM1_FIELD.full_name = ".Cmd.OtherData.param1"
OTHERDATA_PARAM1_FIELD.number = 2
OTHERDATA_PARAM1_FIELD.index = 1
OTHERDATA_PARAM1_FIELD.label = 1
OTHERDATA_PARAM1_FIELD.has_default_value = true
OTHERDATA_PARAM1_FIELD.default_value = 0
OTHERDATA_PARAM1_FIELD.type = 13
OTHERDATA_PARAM1_FIELD.cpp_type = 3
OTHERDATA_PARAM2_FIELD.name = "param2"
OTHERDATA_PARAM2_FIELD.full_name = ".Cmd.OtherData.param2"
OTHERDATA_PARAM2_FIELD.number = 3
OTHERDATA_PARAM2_FIELD.index = 2
OTHERDATA_PARAM2_FIELD.label = 1
OTHERDATA_PARAM2_FIELD.has_default_value = true
OTHERDATA_PARAM2_FIELD.default_value = 0
OTHERDATA_PARAM2_FIELD.type = 13
OTHERDATA_PARAM2_FIELD.cpp_type = 3
OTHERDATA_PARAM3_FIELD.name = "param3"
OTHERDATA_PARAM3_FIELD.full_name = ".Cmd.OtherData.param3"
OTHERDATA_PARAM3_FIELD.number = 4
OTHERDATA_PARAM3_FIELD.index = 3
OTHERDATA_PARAM3_FIELD.label = 1
OTHERDATA_PARAM3_FIELD.has_default_value = true
OTHERDATA_PARAM3_FIELD.default_value = 0
OTHERDATA_PARAM3_FIELD.type = 13
OTHERDATA_PARAM3_FIELD.cpp_type = 3
OTHERDATA_PARAM4_FIELD.name = "param4"
OTHERDATA_PARAM4_FIELD.full_name = ".Cmd.OtherData.param4"
OTHERDATA_PARAM4_FIELD.number = 5
OTHERDATA_PARAM4_FIELD.index = 4
OTHERDATA_PARAM4_FIELD.label = 1
OTHERDATA_PARAM4_FIELD.has_default_value = true
OTHERDATA_PARAM4_FIELD.default_value = 0
OTHERDATA_PARAM4_FIELD.type = 13
OTHERDATA_PARAM4_FIELD.cpp_type = 3
OTHERDATA_TREASURES_FIELD.name = "treasures"
OTHERDATA_TREASURES_FIELD.full_name = ".Cmd.OtherData.treasures"
OTHERDATA_TREASURES_FIELD.number = 6
OTHERDATA_TREASURES_FIELD.index = 5
OTHERDATA_TREASURES_FIELD.label = 3
OTHERDATA_TREASURES_FIELD.has_default_value = false
OTHERDATA_TREASURES_FIELD.default_value = {}
OTHERDATA_TREASURES_FIELD.message_type = WORLDTREASURE
OTHERDATA_TREASURES_FIELD.type = 11
OTHERDATA_TREASURES_FIELD.cpp_type = 10
OTHERDATA.name = "OtherData"
OTHERDATA.full_name = ".Cmd.OtherData"
OTHERDATA.nested_types = {}
OTHERDATA.enum_types = {}
OTHERDATA.fields = {
  OTHERDATA_DATA_FIELD,
  OTHERDATA_PARAM1_FIELD,
  OTHERDATA_PARAM2_FIELD,
  OTHERDATA_PARAM3_FIELD,
  OTHERDATA_PARAM4_FIELD,
  OTHERDATA_TREASURES_FIELD
}
OTHERDATA.is_extendable = false
OTHERDATA.extensions = {}
QUERYOTHERDATA_CMD_FIELD.name = "cmd"
QUERYOTHERDATA_CMD_FIELD.full_name = ".Cmd.QueryOtherData.cmd"
QUERYOTHERDATA_CMD_FIELD.number = 1
QUERYOTHERDATA_CMD_FIELD.index = 0
QUERYOTHERDATA_CMD_FIELD.label = 1
QUERYOTHERDATA_CMD_FIELD.has_default_value = true
QUERYOTHERDATA_CMD_FIELD.default_value = 8
QUERYOTHERDATA_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYOTHERDATA_CMD_FIELD.type = 14
QUERYOTHERDATA_CMD_FIELD.cpp_type = 8
QUERYOTHERDATA_PARAM_FIELD.name = "param"
QUERYOTHERDATA_PARAM_FIELD.full_name = ".Cmd.QueryOtherData.param"
QUERYOTHERDATA_PARAM_FIELD.number = 2
QUERYOTHERDATA_PARAM_FIELD.index = 1
QUERYOTHERDATA_PARAM_FIELD.label = 1
QUERYOTHERDATA_PARAM_FIELD.has_default_value = true
QUERYOTHERDATA_PARAM_FIELD.default_value = 12
QUERYOTHERDATA_PARAM_FIELD.enum_type = QUESTPARAM
QUERYOTHERDATA_PARAM_FIELD.type = 14
QUERYOTHERDATA_PARAM_FIELD.cpp_type = 8
QUERYOTHERDATA_TYPE_FIELD.name = "type"
QUERYOTHERDATA_TYPE_FIELD.full_name = ".Cmd.QueryOtherData.type"
QUERYOTHERDATA_TYPE_FIELD.number = 3
QUERYOTHERDATA_TYPE_FIELD.index = 2
QUERYOTHERDATA_TYPE_FIELD.label = 1
QUERYOTHERDATA_TYPE_FIELD.has_default_value = true
QUERYOTHERDATA_TYPE_FIELD.default_value = 0
QUERYOTHERDATA_TYPE_FIELD.enum_type = EOTHERDATA
QUERYOTHERDATA_TYPE_FIELD.type = 14
QUERYOTHERDATA_TYPE_FIELD.cpp_type = 8
QUERYOTHERDATA_DATA_FIELD.name = "data"
QUERYOTHERDATA_DATA_FIELD.full_name = ".Cmd.QueryOtherData.data"
QUERYOTHERDATA_DATA_FIELD.number = 4
QUERYOTHERDATA_DATA_FIELD.index = 3
QUERYOTHERDATA_DATA_FIELD.label = 1
QUERYOTHERDATA_DATA_FIELD.has_default_value = false
QUERYOTHERDATA_DATA_FIELD.default_value = nil
QUERYOTHERDATA_DATA_FIELD.message_type = OTHERDATA
QUERYOTHERDATA_DATA_FIELD.type = 11
QUERYOTHERDATA_DATA_FIELD.cpp_type = 10
QUERYOTHERDATA.name = "QueryOtherData"
QUERYOTHERDATA.full_name = ".Cmd.QueryOtherData"
QUERYOTHERDATA.nested_types = {}
QUERYOTHERDATA.enum_types = {}
QUERYOTHERDATA.fields = {
  QUERYOTHERDATA_CMD_FIELD,
  QUERYOTHERDATA_PARAM_FIELD,
  QUERYOTHERDATA_TYPE_FIELD,
  QUERYOTHERDATA_DATA_FIELD
}
QUERYOTHERDATA.is_extendable = false
QUERYOTHERDATA.extensions = {}
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.name = "cmd"
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryWantedInfoQuestCmd.cmd"
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.number = 1
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.index = 0
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.label = 1
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.has_default_value = true
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.default_value = 8
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.type = 14
QUERYWANTEDINFOQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.name = "param"
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryWantedInfoQuestCmd.param"
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.number = 2
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.index = 1
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.label = 1
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.default_value = 13
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.type = 14
QUERYWANTEDINFOQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.name = "maxcount"
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.full_name = ".Cmd.QueryWantedInfoQuestCmd.maxcount"
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.number = 3
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.index = 2
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.label = 1
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.has_default_value = true
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.default_value = 0
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.type = 13
QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD.cpp_type = 3
QUERYWANTEDINFOQUESTCMD.name = "QueryWantedInfoQuestCmd"
QUERYWANTEDINFOQUESTCMD.full_name = ".Cmd.QueryWantedInfoQuestCmd"
QUERYWANTEDINFOQUESTCMD.nested_types = {}
QUERYWANTEDINFOQUESTCMD.enum_types = {}
QUERYWANTEDINFOQUESTCMD.fields = {
  QUERYWANTEDINFOQUESTCMD_CMD_FIELD,
  QUERYWANTEDINFOQUESTCMD_PARAM_FIELD,
  QUERYWANTEDINFOQUESTCMD_MAXCOUNT_FIELD
}
QUERYWANTEDINFOQUESTCMD.is_extendable = false
QUERYWANTEDINFOQUESTCMD.extensions = {}
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.name = "cmd"
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.cmd"
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.number = 1
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.index = 0
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.default_value = 8
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.type = 14
INVITEHELPACCEPTQUESTCMD_CMD_FIELD.cpp_type = 8
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.name = "param"
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.param"
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.number = 2
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.index = 1
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.default_value = 14
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.type = 14
INVITEHELPACCEPTQUESTCMD_PARAM_FIELD.cpp_type = 8
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.name = "leaderid"
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.leaderid"
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.number = 3
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.index = 2
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.default_value = 0
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.type = 4
INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD.cpp_type = 4
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.name = "questid"
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.questid"
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.number = 4
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.index = 3
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.default_value = 0
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.type = 13
INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD.cpp_type = 3
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.name = "time"
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.time"
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.number = 5
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.index = 4
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.default_value = 0
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.type = 13
INVITEHELPACCEPTQUESTCMD_TIME_FIELD.cpp_type = 3
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.name = "sign"
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.sign"
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.number = 6
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.index = 5
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.has_default_value = false
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.default_value = ""
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.type = 12
INVITEHELPACCEPTQUESTCMD_SIGN_FIELD.cpp_type = 9
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.name = "leadername"
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.leadername"
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.number = 7
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.index = 6
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.has_default_value = false
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.default_value = ""
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.type = 9
INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD.cpp_type = 9
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.name = "issubmit"
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.full_name = ".Cmd.InviteHelpAcceptQuestCmd.issubmit"
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.number = 8
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.index = 7
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.label = 1
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.has_default_value = true
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.default_value = false
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.type = 8
INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD.cpp_type = 7
INVITEHELPACCEPTQUESTCMD.name = "InviteHelpAcceptQuestCmd"
INVITEHELPACCEPTQUESTCMD.full_name = ".Cmd.InviteHelpAcceptQuestCmd"
INVITEHELPACCEPTQUESTCMD.nested_types = {}
INVITEHELPACCEPTQUESTCMD.enum_types = {}
INVITEHELPACCEPTQUESTCMD.fields = {
  INVITEHELPACCEPTQUESTCMD_CMD_FIELD,
  INVITEHELPACCEPTQUESTCMD_PARAM_FIELD,
  INVITEHELPACCEPTQUESTCMD_LEADERID_FIELD,
  INVITEHELPACCEPTQUESTCMD_QUESTID_FIELD,
  INVITEHELPACCEPTQUESTCMD_TIME_FIELD,
  INVITEHELPACCEPTQUESTCMD_SIGN_FIELD,
  INVITEHELPACCEPTQUESTCMD_LEADERNAME_FIELD,
  INVITEHELPACCEPTQUESTCMD_ISSUBMIT_FIELD
}
INVITEHELPACCEPTQUESTCMD.is_extendable = false
INVITEHELPACCEPTQUESTCMD.extensions = {}
INVITEACCEPTQUESTCMD_CMD_FIELD.name = "cmd"
INVITEACCEPTQUESTCMD_CMD_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.cmd"
INVITEACCEPTQUESTCMD_CMD_FIELD.number = 1
INVITEACCEPTQUESTCMD_CMD_FIELD.index = 0
INVITEACCEPTQUESTCMD_CMD_FIELD.label = 1
INVITEACCEPTQUESTCMD_CMD_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_CMD_FIELD.default_value = 8
INVITEACCEPTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEACCEPTQUESTCMD_CMD_FIELD.type = 14
INVITEACCEPTQUESTCMD_CMD_FIELD.cpp_type = 8
INVITEACCEPTQUESTCMD_PARAM_FIELD.name = "param"
INVITEACCEPTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.param"
INVITEACCEPTQUESTCMD_PARAM_FIELD.number = 2
INVITEACCEPTQUESTCMD_PARAM_FIELD.index = 1
INVITEACCEPTQUESTCMD_PARAM_FIELD.label = 1
INVITEACCEPTQUESTCMD_PARAM_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_PARAM_FIELD.default_value = 16
INVITEACCEPTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
INVITEACCEPTQUESTCMD_PARAM_FIELD.type = 14
INVITEACCEPTQUESTCMD_PARAM_FIELD.cpp_type = 8
INVITEACCEPTQUESTCMD_LEADERID_FIELD.name = "leaderid"
INVITEACCEPTQUESTCMD_LEADERID_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.leaderid"
INVITEACCEPTQUESTCMD_LEADERID_FIELD.number = 3
INVITEACCEPTQUESTCMD_LEADERID_FIELD.index = 2
INVITEACCEPTQUESTCMD_LEADERID_FIELD.label = 1
INVITEACCEPTQUESTCMD_LEADERID_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_LEADERID_FIELD.default_value = 0
INVITEACCEPTQUESTCMD_LEADERID_FIELD.type = 4
INVITEACCEPTQUESTCMD_LEADERID_FIELD.cpp_type = 4
INVITEACCEPTQUESTCMD_QUESTID_FIELD.name = "questid"
INVITEACCEPTQUESTCMD_QUESTID_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.questid"
INVITEACCEPTQUESTCMD_QUESTID_FIELD.number = 4
INVITEACCEPTQUESTCMD_QUESTID_FIELD.index = 3
INVITEACCEPTQUESTCMD_QUESTID_FIELD.label = 1
INVITEACCEPTQUESTCMD_QUESTID_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_QUESTID_FIELD.default_value = 0
INVITEACCEPTQUESTCMD_QUESTID_FIELD.type = 13
INVITEACCEPTQUESTCMD_QUESTID_FIELD.cpp_type = 3
INVITEACCEPTQUESTCMD_TIME_FIELD.name = "time"
INVITEACCEPTQUESTCMD_TIME_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.time"
INVITEACCEPTQUESTCMD_TIME_FIELD.number = 5
INVITEACCEPTQUESTCMD_TIME_FIELD.index = 4
INVITEACCEPTQUESTCMD_TIME_FIELD.label = 1
INVITEACCEPTQUESTCMD_TIME_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_TIME_FIELD.default_value = 0
INVITEACCEPTQUESTCMD_TIME_FIELD.type = 13
INVITEACCEPTQUESTCMD_TIME_FIELD.cpp_type = 3
INVITEACCEPTQUESTCMD_SIGN_FIELD.name = "sign"
INVITEACCEPTQUESTCMD_SIGN_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.sign"
INVITEACCEPTQUESTCMD_SIGN_FIELD.number = 6
INVITEACCEPTQUESTCMD_SIGN_FIELD.index = 5
INVITEACCEPTQUESTCMD_SIGN_FIELD.label = 1
INVITEACCEPTQUESTCMD_SIGN_FIELD.has_default_value = false
INVITEACCEPTQUESTCMD_SIGN_FIELD.default_value = ""
INVITEACCEPTQUESTCMD_SIGN_FIELD.type = 12
INVITEACCEPTQUESTCMD_SIGN_FIELD.cpp_type = 9
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.name = "leadername"
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.leadername"
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.number = 7
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.index = 6
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.label = 1
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.has_default_value = false
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.default_value = ""
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.type = 9
INVITEACCEPTQUESTCMD_LEADERNAME_FIELD.cpp_type = 9
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.name = "issubmit"
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.issubmit"
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.number = 8
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.index = 7
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.label = 1
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.default_value = false
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.type = 8
INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD.cpp_type = 7
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.name = "isquickfinish"
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.full_name = ".Cmd.InviteAcceptQuestCmd.isquickfinish"
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.number = 9
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.index = 8
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.label = 1
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.has_default_value = true
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.default_value = false
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.type = 8
INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD.cpp_type = 7
INVITEACCEPTQUESTCMD.name = "InviteAcceptQuestCmd"
INVITEACCEPTQUESTCMD.full_name = ".Cmd.InviteAcceptQuestCmd"
INVITEACCEPTQUESTCMD.nested_types = {}
INVITEACCEPTQUESTCMD.enum_types = {}
INVITEACCEPTQUESTCMD.fields = {
  INVITEACCEPTQUESTCMD_CMD_FIELD,
  INVITEACCEPTQUESTCMD_PARAM_FIELD,
  INVITEACCEPTQUESTCMD_LEADERID_FIELD,
  INVITEACCEPTQUESTCMD_QUESTID_FIELD,
  INVITEACCEPTQUESTCMD_TIME_FIELD,
  INVITEACCEPTQUESTCMD_SIGN_FIELD,
  INVITEACCEPTQUESTCMD_LEADERNAME_FIELD,
  INVITEACCEPTQUESTCMD_ISSUBMIT_FIELD,
  INVITEACCEPTQUESTCMD_ISQUICKFINISH_FIELD
}
INVITEACCEPTQUESTCMD.is_extendable = false
INVITEACCEPTQUESTCMD.extensions = {}
REPLYHELPACCELPQUESTCMD_CMD_FIELD.name = "cmd"
REPLYHELPACCELPQUESTCMD_CMD_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.cmd"
REPLYHELPACCELPQUESTCMD_CMD_FIELD.number = 1
REPLYHELPACCELPQUESTCMD_CMD_FIELD.index = 0
REPLYHELPACCELPQUESTCMD_CMD_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_CMD_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_CMD_FIELD.default_value = 8
REPLYHELPACCELPQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REPLYHELPACCELPQUESTCMD_CMD_FIELD.type = 14
REPLYHELPACCELPQUESTCMD_CMD_FIELD.cpp_type = 8
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.name = "param"
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.param"
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.number = 2
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.index = 1
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.default_value = 15
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.type = 14
REPLYHELPACCELPQUESTCMD_PARAM_FIELD.cpp_type = 8
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.name = "leaderid"
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.leaderid"
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.number = 3
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.index = 2
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.default_value = 0
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.type = 4
REPLYHELPACCELPQUESTCMD_LEADERID_FIELD.cpp_type = 4
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.name = "questid"
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.questid"
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.number = 4
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.index = 3
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.default_value = 0
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.type = 13
REPLYHELPACCELPQUESTCMD_QUESTID_FIELD.cpp_type = 3
REPLYHELPACCELPQUESTCMD_TIME_FIELD.name = "time"
REPLYHELPACCELPQUESTCMD_TIME_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.time"
REPLYHELPACCELPQUESTCMD_TIME_FIELD.number = 5
REPLYHELPACCELPQUESTCMD_TIME_FIELD.index = 4
REPLYHELPACCELPQUESTCMD_TIME_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_TIME_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_TIME_FIELD.default_value = 0
REPLYHELPACCELPQUESTCMD_TIME_FIELD.type = 13
REPLYHELPACCELPQUESTCMD_TIME_FIELD.cpp_type = 3
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.name = "sign"
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.sign"
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.number = 6
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.index = 5
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.has_default_value = false
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.default_value = ""
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.type = 12
REPLYHELPACCELPQUESTCMD_SIGN_FIELD.cpp_type = 9
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.name = "agree"
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.agree"
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.number = 7
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.index = 6
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.default_value = false
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.type = 8
REPLYHELPACCELPQUESTCMD_AGREE_FIELD.cpp_type = 7
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.name = "issubmit"
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd.issubmit"
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.number = 8
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.index = 7
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.label = 1
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.has_default_value = true
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.default_value = false
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.type = 8
REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD.cpp_type = 7
REPLYHELPACCELPQUESTCMD.name = "ReplyHelpAccelpQuestCmd"
REPLYHELPACCELPQUESTCMD.full_name = ".Cmd.ReplyHelpAccelpQuestCmd"
REPLYHELPACCELPQUESTCMD.nested_types = {}
REPLYHELPACCELPQUESTCMD.enum_types = {}
REPLYHELPACCELPQUESTCMD.fields = {
  REPLYHELPACCELPQUESTCMD_CMD_FIELD,
  REPLYHELPACCELPQUESTCMD_PARAM_FIELD,
  REPLYHELPACCELPQUESTCMD_LEADERID_FIELD,
  REPLYHELPACCELPQUESTCMD_QUESTID_FIELD,
  REPLYHELPACCELPQUESTCMD_TIME_FIELD,
  REPLYHELPACCELPQUESTCMD_SIGN_FIELD,
  REPLYHELPACCELPQUESTCMD_AGREE_FIELD,
  REPLYHELPACCELPQUESTCMD_ISSUBMIT_FIELD
}
REPLYHELPACCELPQUESTCMD.is_extendable = false
REPLYHELPACCELPQUESTCMD.extensions = {}
WORLDQUEST_MAPID_FIELD.name = "mapid"
WORLDQUEST_MAPID_FIELD.full_name = ".Cmd.WorldQuest.mapid"
WORLDQUEST_MAPID_FIELD.number = 1
WORLDQUEST_MAPID_FIELD.index = 0
WORLDQUEST_MAPID_FIELD.label = 1
WORLDQUEST_MAPID_FIELD.has_default_value = true
WORLDQUEST_MAPID_FIELD.default_value = 0
WORLDQUEST_MAPID_FIELD.type = 13
WORLDQUEST_MAPID_FIELD.cpp_type = 3
WORLDQUEST_TYPE_MAIN_FIELD.name = "type_main"
WORLDQUEST_TYPE_MAIN_FIELD.full_name = ".Cmd.WorldQuest.type_main"
WORLDQUEST_TYPE_MAIN_FIELD.number = 2
WORLDQUEST_TYPE_MAIN_FIELD.index = 1
WORLDQUEST_TYPE_MAIN_FIELD.label = 1
WORLDQUEST_TYPE_MAIN_FIELD.has_default_value = true
WORLDQUEST_TYPE_MAIN_FIELD.default_value = false
WORLDQUEST_TYPE_MAIN_FIELD.type = 8
WORLDQUEST_TYPE_MAIN_FIELD.cpp_type = 7
WORLDQUEST_TYPE_BRANCH_FIELD.name = "type_branch"
WORLDQUEST_TYPE_BRANCH_FIELD.full_name = ".Cmd.WorldQuest.type_branch"
WORLDQUEST_TYPE_BRANCH_FIELD.number = 3
WORLDQUEST_TYPE_BRANCH_FIELD.index = 2
WORLDQUEST_TYPE_BRANCH_FIELD.label = 1
WORLDQUEST_TYPE_BRANCH_FIELD.has_default_value = true
WORLDQUEST_TYPE_BRANCH_FIELD.default_value = false
WORLDQUEST_TYPE_BRANCH_FIELD.type = 8
WORLDQUEST_TYPE_BRANCH_FIELD.cpp_type = 7
WORLDQUEST_TYPE_DAILY_FIELD.name = "type_daily"
WORLDQUEST_TYPE_DAILY_FIELD.full_name = ".Cmd.WorldQuest.type_daily"
WORLDQUEST_TYPE_DAILY_FIELD.number = 4
WORLDQUEST_TYPE_DAILY_FIELD.index = 3
WORLDQUEST_TYPE_DAILY_FIELD.label = 1
WORLDQUEST_TYPE_DAILY_FIELD.has_default_value = true
WORLDQUEST_TYPE_DAILY_FIELD.default_value = false
WORLDQUEST_TYPE_DAILY_FIELD.type = 8
WORLDQUEST_TYPE_DAILY_FIELD.cpp_type = 7
WORLDQUEST.name = "WorldQuest"
WORLDQUEST.full_name = ".Cmd.WorldQuest"
WORLDQUEST.nested_types = {}
WORLDQUEST.enum_types = {}
WORLDQUEST.fields = {
  WORLDQUEST_MAPID_FIELD,
  WORLDQUEST_TYPE_MAIN_FIELD,
  WORLDQUEST_TYPE_BRANCH_FIELD,
  WORLDQUEST_TYPE_DAILY_FIELD
}
WORLDQUEST.is_extendable = false
WORLDQUEST.extensions = {}
QUERYWORLDQUESTCMD_CMD_FIELD.name = "cmd"
QUERYWORLDQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryWorldQuestCmd.cmd"
QUERYWORLDQUESTCMD_CMD_FIELD.number = 1
QUERYWORLDQUESTCMD_CMD_FIELD.index = 0
QUERYWORLDQUESTCMD_CMD_FIELD.label = 1
QUERYWORLDQUESTCMD_CMD_FIELD.has_default_value = true
QUERYWORLDQUESTCMD_CMD_FIELD.default_value = 8
QUERYWORLDQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYWORLDQUESTCMD_CMD_FIELD.type = 14
QUERYWORLDQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYWORLDQUESTCMD_PARAM_FIELD.name = "param"
QUERYWORLDQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryWorldQuestCmd.param"
QUERYWORLDQUESTCMD_PARAM_FIELD.number = 2
QUERYWORLDQUESTCMD_PARAM_FIELD.index = 1
QUERYWORLDQUESTCMD_PARAM_FIELD.label = 1
QUERYWORLDQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYWORLDQUESTCMD_PARAM_FIELD.default_value = 17
QUERYWORLDQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYWORLDQUESTCMD_PARAM_FIELD.type = 14
QUERYWORLDQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYWORLDQUESTCMD_QUESTS_FIELD.name = "quests"
QUERYWORLDQUESTCMD_QUESTS_FIELD.full_name = ".Cmd.QueryWorldQuestCmd.quests"
QUERYWORLDQUESTCMD_QUESTS_FIELD.number = 3
QUERYWORLDQUESTCMD_QUESTS_FIELD.index = 2
QUERYWORLDQUESTCMD_QUESTS_FIELD.label = 3
QUERYWORLDQUESTCMD_QUESTS_FIELD.has_default_value = false
QUERYWORLDQUESTCMD_QUESTS_FIELD.default_value = {}
QUERYWORLDQUESTCMD_QUESTS_FIELD.message_type = WORLDQUEST
QUERYWORLDQUESTCMD_QUESTS_FIELD.type = 11
QUERYWORLDQUESTCMD_QUESTS_FIELD.cpp_type = 10
QUERYWORLDQUESTCMD.name = "QueryWorldQuestCmd"
QUERYWORLDQUESTCMD.full_name = ".Cmd.QueryWorldQuestCmd"
QUERYWORLDQUESTCMD.nested_types = {}
QUERYWORLDQUESTCMD.enum_types = {}
QUERYWORLDQUESTCMD.fields = {
  QUERYWORLDQUESTCMD_CMD_FIELD,
  QUERYWORLDQUESTCMD_PARAM_FIELD,
  QUERYWORLDQUESTCMD_QUESTS_FIELD
}
QUERYWORLDQUESTCMD.is_extendable = false
QUERYWORLDQUESTCMD.extensions = {}
TRACE_ID_FIELD.name = "id"
TRACE_ID_FIELD.full_name = ".Cmd.Trace.id"
TRACE_ID_FIELD.number = 3
TRACE_ID_FIELD.index = 0
TRACE_ID_FIELD.label = 1
TRACE_ID_FIELD.has_default_value = true
TRACE_ID_FIELD.default_value = 0
TRACE_ID_FIELD.type = 13
TRACE_ID_FIELD.cpp_type = 3
TRACE_TRACE_FIELD.name = "trace"
TRACE_TRACE_FIELD.full_name = ".Cmd.Trace.trace"
TRACE_TRACE_FIELD.number = 4
TRACE_TRACE_FIELD.index = 1
TRACE_TRACE_FIELD.label = 1
TRACE_TRACE_FIELD.has_default_value = true
TRACE_TRACE_FIELD.default_value = false
TRACE_TRACE_FIELD.type = 8
TRACE_TRACE_FIELD.cpp_type = 7
TRACE.name = "Trace"
TRACE.full_name = ".Cmd.Trace"
TRACE.nested_types = {}
TRACE.enum_types = {}
TRACE.fields = {
  TRACE_ID_FIELD,
  TRACE_TRACE_FIELD
}
TRACE.is_extendable = false
TRACE.extensions = {}
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.name = "cmd"
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.full_name = ".Cmd.QuestGroupTraceQuestCmd.cmd"
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.number = 1
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.index = 0
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.label = 1
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.has_default_value = true
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.default_value = 8
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.type = 14
QUESTGROUPTRACEQUESTCMD_CMD_FIELD.cpp_type = 8
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.name = "param"
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QuestGroupTraceQuestCmd.param"
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.number = 2
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.index = 1
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.label = 1
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.has_default_value = true
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.default_value = 18
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.type = 14
QUESTGROUPTRACEQUESTCMD_PARAM_FIELD.cpp_type = 8
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.name = "traces"
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.full_name = ".Cmd.QuestGroupTraceQuestCmd.traces"
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.number = 3
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.index = 2
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.label = 3
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.has_default_value = false
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.default_value = {}
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.message_type = TRACE
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.type = 11
QUESTGROUPTRACEQUESTCMD_TRACES_FIELD.cpp_type = 10
QUESTGROUPTRACEQUESTCMD.name = "QuestGroupTraceQuestCmd"
QUESTGROUPTRACEQUESTCMD.full_name = ".Cmd.QuestGroupTraceQuestCmd"
QUESTGROUPTRACEQUESTCMD.nested_types = {}
QUESTGROUPTRACEQUESTCMD.enum_types = {}
QUESTGROUPTRACEQUESTCMD.fields = {
  QUESTGROUPTRACEQUESTCMD_CMD_FIELD,
  QUESTGROUPTRACEQUESTCMD_PARAM_FIELD,
  QUESTGROUPTRACEQUESTCMD_TRACES_FIELD
}
QUESTGROUPTRACEQUESTCMD.is_extendable = false
QUESTGROUPTRACEQUESTCMD.extensions = {}
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.name = "cmd"
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.full_name = ".Cmd.HelpQuickFinishBoardQuestCmd.cmd"
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.number = 1
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.index = 0
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.label = 1
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.has_default_value = true
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.default_value = 8
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.type = 14
HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD.cpp_type = 8
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.name = "param"
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.full_name = ".Cmd.HelpQuickFinishBoardQuestCmd.param"
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.number = 2
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.index = 1
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.label = 1
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.has_default_value = true
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.default_value = 19
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.type = 14
HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD.cpp_type = 8
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.name = "questid"
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.full_name = ".Cmd.HelpQuickFinishBoardQuestCmd.questid"
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.number = 3
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.index = 2
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.label = 1
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.has_default_value = true
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.default_value = 0
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.type = 13
HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD.cpp_type = 3
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.name = "leadername"
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.full_name = ".Cmd.HelpQuickFinishBoardQuestCmd.leadername"
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.number = 4
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.index = 3
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.label = 1
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.has_default_value = false
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.default_value = ""
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.type = 9
HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD.cpp_type = 9
HELPQUICKFINISHBOARDQUESTCMD.name = "HelpQuickFinishBoardQuestCmd"
HELPQUICKFINISHBOARDQUESTCMD.full_name = ".Cmd.HelpQuickFinishBoardQuestCmd"
HELPQUICKFINISHBOARDQUESTCMD.nested_types = {}
HELPQUICKFINISHBOARDQUESTCMD.enum_types = {}
HELPQUICKFINISHBOARDQUESTCMD.fields = {
  HELPQUICKFINISHBOARDQUESTCMD_CMD_FIELD,
  HELPQUICKFINISHBOARDQUESTCMD_PARAM_FIELD,
  HELPQUICKFINISHBOARDQUESTCMD_QUESTID_FIELD,
  HELPQUICKFINISHBOARDQUESTCMD_LEADERNAME_FIELD
}
HELPQUICKFINISHBOARDQUESTCMD.is_extendable = false
HELPQUICKFINISHBOARDQUESTCMD.extensions = {}
QUERYQUESTLISTQUESTCMD_CMD_FIELD.name = "cmd"
QUERYQUESTLISTQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryQuestListQuestCmd.cmd"
QUERYQUESTLISTQUESTCMD_CMD_FIELD.number = 1
QUERYQUESTLISTQUESTCMD_CMD_FIELD.index = 0
QUERYQUESTLISTQUESTCMD_CMD_FIELD.label = 1
QUERYQUESTLISTQUESTCMD_CMD_FIELD.has_default_value = true
QUERYQUESTLISTQUESTCMD_CMD_FIELD.default_value = 8
QUERYQUESTLISTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYQUESTLISTQUESTCMD_CMD_FIELD.type = 14
QUERYQUESTLISTQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.name = "param"
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryQuestListQuestCmd.param"
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.number = 2
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.index = 1
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.label = 1
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.default_value = 24
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.type = 14
QUERYQUESTLISTQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.name = "mapid"
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.full_name = ".Cmd.QueryQuestListQuestCmd.mapid"
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.number = 3
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.index = 2
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.label = 1
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.has_default_value = true
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.default_value = 0
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.type = 13
QUERYQUESTLISTQUESTCMD_MAPID_FIELD.cpp_type = 3
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.name = "datas"
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.full_name = ".Cmd.QueryQuestListQuestCmd.datas"
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.number = 4
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.index = 3
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.label = 3
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.has_default_value = false
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.default_value = {}
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.message_type = QUESTDATA
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.type = 11
QUERYQUESTLISTQUESTCMD_DATAS_FIELD.cpp_type = 10
QUERYQUESTLISTQUESTCMD.name = "QueryQuestListQuestCmd"
QUERYQUESTLISTQUESTCMD.full_name = ".Cmd.QueryQuestListQuestCmd"
QUERYQUESTLISTQUESTCMD.nested_types = {}
QUERYQUESTLISTQUESTCMD.enum_types = {}
QUERYQUESTLISTQUESTCMD.fields = {
  QUERYQUESTLISTQUESTCMD_CMD_FIELD,
  QUERYQUESTLISTQUESTCMD_PARAM_FIELD,
  QUERYQUESTLISTQUESTCMD_MAPID_FIELD,
  QUERYQUESTLISTQUESTCMD_DATAS_FIELD
}
QUERYQUESTLISTQUESTCMD.is_extendable = false
QUERYQUESTLISTQUESTCMD.extensions = {}
MAPSTEPSYNCCMD_CMD_FIELD.name = "cmd"
MAPSTEPSYNCCMD_CMD_FIELD.full_name = ".Cmd.MapStepSyncCmd.cmd"
MAPSTEPSYNCCMD_CMD_FIELD.number = 1
MAPSTEPSYNCCMD_CMD_FIELD.index = 0
MAPSTEPSYNCCMD_CMD_FIELD.label = 1
MAPSTEPSYNCCMD_CMD_FIELD.has_default_value = true
MAPSTEPSYNCCMD_CMD_FIELD.default_value = 8
MAPSTEPSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MAPSTEPSYNCCMD_CMD_FIELD.type = 14
MAPSTEPSYNCCMD_CMD_FIELD.cpp_type = 8
MAPSTEPSYNCCMD_PARAM_FIELD.name = "param"
MAPSTEPSYNCCMD_PARAM_FIELD.full_name = ".Cmd.MapStepSyncCmd.param"
MAPSTEPSYNCCMD_PARAM_FIELD.number = 2
MAPSTEPSYNCCMD_PARAM_FIELD.index = 1
MAPSTEPSYNCCMD_PARAM_FIELD.label = 1
MAPSTEPSYNCCMD_PARAM_FIELD.has_default_value = true
MAPSTEPSYNCCMD_PARAM_FIELD.default_value = 25
MAPSTEPSYNCCMD_PARAM_FIELD.enum_type = QUESTPARAM
MAPSTEPSYNCCMD_PARAM_FIELD.type = 14
MAPSTEPSYNCCMD_PARAM_FIELD.cpp_type = 8
MAPSTEPSYNCCMD_STEPID_FIELD.name = "stepid"
MAPSTEPSYNCCMD_STEPID_FIELD.full_name = ".Cmd.MapStepSyncCmd.stepid"
MAPSTEPSYNCCMD_STEPID_FIELD.number = 3
MAPSTEPSYNCCMD_STEPID_FIELD.index = 2
MAPSTEPSYNCCMD_STEPID_FIELD.label = 3
MAPSTEPSYNCCMD_STEPID_FIELD.has_default_value = false
MAPSTEPSYNCCMD_STEPID_FIELD.default_value = {}
MAPSTEPSYNCCMD_STEPID_FIELD.type = 13
MAPSTEPSYNCCMD_STEPID_FIELD.cpp_type = 3
MAPSTEPSYNCCMD.name = "MapStepSyncCmd"
MAPSTEPSYNCCMD.full_name = ".Cmd.MapStepSyncCmd"
MAPSTEPSYNCCMD.nested_types = {}
MAPSTEPSYNCCMD.enum_types = {}
MAPSTEPSYNCCMD.fields = {
  MAPSTEPSYNCCMD_CMD_FIELD,
  MAPSTEPSYNCCMD_PARAM_FIELD,
  MAPSTEPSYNCCMD_STEPID_FIELD
}
MAPSTEPSYNCCMD.is_extendable = false
MAPSTEPSYNCCMD.extensions = {}
MAPSTEPUPDATECMD_CMD_FIELD.name = "cmd"
MAPSTEPUPDATECMD_CMD_FIELD.full_name = ".Cmd.MapStepUpdateCmd.cmd"
MAPSTEPUPDATECMD_CMD_FIELD.number = 1
MAPSTEPUPDATECMD_CMD_FIELD.index = 0
MAPSTEPUPDATECMD_CMD_FIELD.label = 1
MAPSTEPUPDATECMD_CMD_FIELD.has_default_value = true
MAPSTEPUPDATECMD_CMD_FIELD.default_value = 8
MAPSTEPUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MAPSTEPUPDATECMD_CMD_FIELD.type = 14
MAPSTEPUPDATECMD_CMD_FIELD.cpp_type = 8
MAPSTEPUPDATECMD_PARAM_FIELD.name = "param"
MAPSTEPUPDATECMD_PARAM_FIELD.full_name = ".Cmd.MapStepUpdateCmd.param"
MAPSTEPUPDATECMD_PARAM_FIELD.number = 2
MAPSTEPUPDATECMD_PARAM_FIELD.index = 1
MAPSTEPUPDATECMD_PARAM_FIELD.label = 1
MAPSTEPUPDATECMD_PARAM_FIELD.has_default_value = true
MAPSTEPUPDATECMD_PARAM_FIELD.default_value = 26
MAPSTEPUPDATECMD_PARAM_FIELD.enum_type = QUESTPARAM
MAPSTEPUPDATECMD_PARAM_FIELD.type = 14
MAPSTEPUPDATECMD_PARAM_FIELD.cpp_type = 8
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.name = "del_stepid"
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.full_name = ".Cmd.MapStepUpdateCmd.del_stepid"
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.number = 3
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.index = 2
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.label = 3
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.has_default_value = false
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.default_value = {}
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.type = 13
MAPSTEPUPDATECMD_DEL_STEPID_FIELD.cpp_type = 3
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.name = "add_stepid"
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.full_name = ".Cmd.MapStepUpdateCmd.add_stepid"
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.number = 4
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.index = 3
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.label = 3
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.has_default_value = false
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.default_value = {}
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.type = 13
MAPSTEPUPDATECMD_ADD_STEPID_FIELD.cpp_type = 3
MAPSTEPUPDATECMD.name = "MapStepUpdateCmd"
MAPSTEPUPDATECMD.full_name = ".Cmd.MapStepUpdateCmd"
MAPSTEPUPDATECMD.nested_types = {}
MAPSTEPUPDATECMD.enum_types = {}
MAPSTEPUPDATECMD.fields = {
  MAPSTEPUPDATECMD_CMD_FIELD,
  MAPSTEPUPDATECMD_PARAM_FIELD,
  MAPSTEPUPDATECMD_DEL_STEPID_FIELD,
  MAPSTEPUPDATECMD_ADD_STEPID_FIELD
}
MAPSTEPUPDATECMD.is_extendable = false
MAPSTEPUPDATECMD.extensions = {}
MAPSTEPFINISHCMD_CMD_FIELD.name = "cmd"
MAPSTEPFINISHCMD_CMD_FIELD.full_name = ".Cmd.MapStepFinishCmd.cmd"
MAPSTEPFINISHCMD_CMD_FIELD.number = 1
MAPSTEPFINISHCMD_CMD_FIELD.index = 0
MAPSTEPFINISHCMD_CMD_FIELD.label = 1
MAPSTEPFINISHCMD_CMD_FIELD.has_default_value = true
MAPSTEPFINISHCMD_CMD_FIELD.default_value = 8
MAPSTEPFINISHCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MAPSTEPFINISHCMD_CMD_FIELD.type = 14
MAPSTEPFINISHCMD_CMD_FIELD.cpp_type = 8
MAPSTEPFINISHCMD_PARAM_FIELD.name = "param"
MAPSTEPFINISHCMD_PARAM_FIELD.full_name = ".Cmd.MapStepFinishCmd.param"
MAPSTEPFINISHCMD_PARAM_FIELD.number = 2
MAPSTEPFINISHCMD_PARAM_FIELD.index = 1
MAPSTEPFINISHCMD_PARAM_FIELD.label = 1
MAPSTEPFINISHCMD_PARAM_FIELD.has_default_value = true
MAPSTEPFINISHCMD_PARAM_FIELD.default_value = 27
MAPSTEPFINISHCMD_PARAM_FIELD.enum_type = QUESTPARAM
MAPSTEPFINISHCMD_PARAM_FIELD.type = 14
MAPSTEPFINISHCMD_PARAM_FIELD.cpp_type = 8
MAPSTEPFINISHCMD_STEPID_FIELD.name = "stepid"
MAPSTEPFINISHCMD_STEPID_FIELD.full_name = ".Cmd.MapStepFinishCmd.stepid"
MAPSTEPFINISHCMD_STEPID_FIELD.number = 3
MAPSTEPFINISHCMD_STEPID_FIELD.index = 2
MAPSTEPFINISHCMD_STEPID_FIELD.label = 1
MAPSTEPFINISHCMD_STEPID_FIELD.has_default_value = false
MAPSTEPFINISHCMD_STEPID_FIELD.default_value = 0
MAPSTEPFINISHCMD_STEPID_FIELD.type = 13
MAPSTEPFINISHCMD_STEPID_FIELD.cpp_type = 3
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.name = "option_jump"
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.full_name = ".Cmd.MapStepFinishCmd.option_jump"
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.number = 4
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.index = 3
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.label = 1
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.has_default_value = false
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.default_value = 0
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.type = 13
MAPSTEPFINISHCMD_OPTION_JUMP_FIELD.cpp_type = 3
MAPSTEPFINISHCMD.name = "MapStepFinishCmd"
MAPSTEPFINISHCMD.full_name = ".Cmd.MapStepFinishCmd"
MAPSTEPFINISHCMD.nested_types = {}
MAPSTEPFINISHCMD.enum_types = {}
MAPSTEPFINISHCMD.fields = {
  MAPSTEPFINISHCMD_CMD_FIELD,
  MAPSTEPFINISHCMD_PARAM_FIELD,
  MAPSTEPFINISHCMD_STEPID_FIELD,
  MAPSTEPFINISHCMD_OPTION_JUMP_FIELD
}
MAPSTEPFINISHCMD.is_extendable = false
MAPSTEPFINISHCMD.extensions = {}
PLOTSTATUSNTF_CMD_FIELD.name = "cmd"
PLOTSTATUSNTF_CMD_FIELD.full_name = ".Cmd.PlotStatusNtf.cmd"
PLOTSTATUSNTF_CMD_FIELD.number = 1
PLOTSTATUSNTF_CMD_FIELD.index = 0
PLOTSTATUSNTF_CMD_FIELD.label = 1
PLOTSTATUSNTF_CMD_FIELD.has_default_value = true
PLOTSTATUSNTF_CMD_FIELD.default_value = 8
PLOTSTATUSNTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PLOTSTATUSNTF_CMD_FIELD.type = 14
PLOTSTATUSNTF_CMD_FIELD.cpp_type = 8
PLOTSTATUSNTF_PARAM_FIELD.name = "param"
PLOTSTATUSNTF_PARAM_FIELD.full_name = ".Cmd.PlotStatusNtf.param"
PLOTSTATUSNTF_PARAM_FIELD.number = 2
PLOTSTATUSNTF_PARAM_FIELD.index = 1
PLOTSTATUSNTF_PARAM_FIELD.label = 1
PLOTSTATUSNTF_PARAM_FIELD.has_default_value = true
PLOTSTATUSNTF_PARAM_FIELD.default_value = 29
PLOTSTATUSNTF_PARAM_FIELD.enum_type = QUESTPARAM
PLOTSTATUSNTF_PARAM_FIELD.type = 14
PLOTSTATUSNTF_PARAM_FIELD.cpp_type = 8
PLOTSTATUSNTF_ISSTART_FIELD.name = "isstart"
PLOTSTATUSNTF_ISSTART_FIELD.full_name = ".Cmd.PlotStatusNtf.isstart"
PLOTSTATUSNTF_ISSTART_FIELD.number = 3
PLOTSTATUSNTF_ISSTART_FIELD.index = 2
PLOTSTATUSNTF_ISSTART_FIELD.label = 1
PLOTSTATUSNTF_ISSTART_FIELD.has_default_value = false
PLOTSTATUSNTF_ISSTART_FIELD.default_value = false
PLOTSTATUSNTF_ISSTART_FIELD.type = 8
PLOTSTATUSNTF_ISSTART_FIELD.cpp_type = 7
PLOTSTATUSNTF_ID_FIELD.name = "id"
PLOTSTATUSNTF_ID_FIELD.full_name = ".Cmd.PlotStatusNtf.id"
PLOTSTATUSNTF_ID_FIELD.number = 4
PLOTSTATUSNTF_ID_FIELD.index = 3
PLOTSTATUSNTF_ID_FIELD.label = 1
PLOTSTATUSNTF_ID_FIELD.has_default_value = false
PLOTSTATUSNTF_ID_FIELD.default_value = 0
PLOTSTATUSNTF_ID_FIELD.type = 13
PLOTSTATUSNTF_ID_FIELD.cpp_type = 3
PLOTSTATUSNTF.name = "PlotStatusNtf"
PLOTSTATUSNTF.full_name = ".Cmd.PlotStatusNtf"
PLOTSTATUSNTF.nested_types = {}
PLOTSTATUSNTF.enum_types = {}
PLOTSTATUSNTF.fields = {
  PLOTSTATUSNTF_CMD_FIELD,
  PLOTSTATUSNTF_PARAM_FIELD,
  PLOTSTATUSNTF_ISSTART_FIELD,
  PLOTSTATUSNTF_ID_FIELD
}
PLOTSTATUSNTF.is_extendable = false
PLOTSTATUSNTF.extensions = {}
QUESTAREAACTION_CMD_FIELD.name = "cmd"
QUESTAREAACTION_CMD_FIELD.full_name = ".Cmd.QuestAreaAction.cmd"
QUESTAREAACTION_CMD_FIELD.number = 1
QUESTAREAACTION_CMD_FIELD.index = 0
QUESTAREAACTION_CMD_FIELD.label = 1
QUESTAREAACTION_CMD_FIELD.has_default_value = true
QUESTAREAACTION_CMD_FIELD.default_value = 8
QUESTAREAACTION_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUESTAREAACTION_CMD_FIELD.type = 14
QUESTAREAACTION_CMD_FIELD.cpp_type = 8
QUESTAREAACTION_PARAM_FIELD.name = "param"
QUESTAREAACTION_PARAM_FIELD.full_name = ".Cmd.QuestAreaAction.param"
QUESTAREAACTION_PARAM_FIELD.number = 2
QUESTAREAACTION_PARAM_FIELD.index = 1
QUESTAREAACTION_PARAM_FIELD.label = 1
QUESTAREAACTION_PARAM_FIELD.has_default_value = true
QUESTAREAACTION_PARAM_FIELD.default_value = 28
QUESTAREAACTION_PARAM_FIELD.enum_type = QUESTPARAM
QUESTAREAACTION_PARAM_FIELD.type = 14
QUESTAREAACTION_PARAM_FIELD.cpp_type = 8
QUESTAREAACTION_CONFIGID_FIELD.name = "configid"
QUESTAREAACTION_CONFIGID_FIELD.full_name = ".Cmd.QuestAreaAction.configid"
QUESTAREAACTION_CONFIGID_FIELD.number = 3
QUESTAREAACTION_CONFIGID_FIELD.index = 2
QUESTAREAACTION_CONFIGID_FIELD.label = 1
QUESTAREAACTION_CONFIGID_FIELD.has_default_value = false
QUESTAREAACTION_CONFIGID_FIELD.default_value = 0
QUESTAREAACTION_CONFIGID_FIELD.type = 13
QUESTAREAACTION_CONFIGID_FIELD.cpp_type = 3
QUESTAREAACTION.name = "QuestAreaAction"
QUESTAREAACTION.full_name = ".Cmd.QuestAreaAction"
QUESTAREAACTION.nested_types = {}
QUESTAREAACTION.enum_types = {}
QUESTAREAACTION.fields = {
  QUESTAREAACTION_CMD_FIELD,
  QUESTAREAACTION_PARAM_FIELD,
  QUESTAREAACTION_CONFIGID_FIELD
}
QUESTAREAACTION.is_extendable = false
QUESTAREAACTION.extensions = {}
BOTTLEDATA_BOTTLEID_FIELD.name = "bottleid"
BOTTLEDATA_BOTTLEID_FIELD.full_name = ".Cmd.BottleData.bottleid"
BOTTLEDATA_BOTTLEID_FIELD.number = 1
BOTTLEDATA_BOTTLEID_FIELD.index = 0
BOTTLEDATA_BOTTLEID_FIELD.label = 1
BOTTLEDATA_BOTTLEID_FIELD.has_default_value = false
BOTTLEDATA_BOTTLEID_FIELD.default_value = 0
BOTTLEDATA_BOTTLEID_FIELD.type = 13
BOTTLEDATA_BOTTLEID_FIELD.cpp_type = 3
BOTTLEDATA_STATUS_FIELD.name = "status"
BOTTLEDATA_STATUS_FIELD.full_name = ".Cmd.BottleData.status"
BOTTLEDATA_STATUS_FIELD.number = 2
BOTTLEDATA_STATUS_FIELD.index = 1
BOTTLEDATA_STATUS_FIELD.label = 1
BOTTLEDATA_STATUS_FIELD.has_default_value = false
BOTTLEDATA_STATUS_FIELD.default_value = nil
BOTTLEDATA_STATUS_FIELD.enum_type = EBOTTLESTATUS
BOTTLEDATA_STATUS_FIELD.type = 14
BOTTLEDATA_STATUS_FIELD.cpp_type = 8
BOTTLEDATA.name = "BottleData"
BOTTLEDATA.full_name = ".Cmd.BottleData"
BOTTLEDATA.nested_types = {}
BOTTLEDATA.enum_types = {}
BOTTLEDATA.fields = {
  BOTTLEDATA_BOTTLEID_FIELD,
  BOTTLEDATA_STATUS_FIELD
}
BOTTLEDATA.is_extendable = false
BOTTLEDATA.extensions = {}
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.name = "cmd"
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryBottleInfoQuestCmd.cmd"
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.number = 1
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.index = 0
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.label = 1
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.has_default_value = true
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.default_value = 8
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.type = 14
QUERYBOTTLEINFOQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.name = "param"
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryBottleInfoQuestCmd.param"
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.number = 2
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.index = 1
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.label = 1
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.default_value = 30
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.type = 14
QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.name = "accepts"
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.full_name = ".Cmd.QueryBottleInfoQuestCmd.accepts"
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.number = 3
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.index = 2
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.label = 3
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.has_default_value = false
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.default_value = {}
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.message_type = BOTTLEDATA
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.type = 11
QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD.cpp_type = 10
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.name = "finishs"
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.full_name = ".Cmd.QueryBottleInfoQuestCmd.finishs"
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.number = 4
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.index = 3
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.label = 3
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.has_default_value = false
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.default_value = {}
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.message_type = BOTTLEDATA
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.type = 11
QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD.cpp_type = 10
QUERYBOTTLEINFOQUESTCMD.name = "QueryBottleInfoQuestCmd"
QUERYBOTTLEINFOQUESTCMD.full_name = ".Cmd.QueryBottleInfoQuestCmd"
QUERYBOTTLEINFOQUESTCMD.nested_types = {}
QUERYBOTTLEINFOQUESTCMD.enum_types = {}
QUERYBOTTLEINFOQUESTCMD.fields = {
  QUERYBOTTLEINFOQUESTCMD_CMD_FIELD,
  QUERYBOTTLEINFOQUESTCMD_PARAM_FIELD,
  QUERYBOTTLEINFOQUESTCMD_ACCEPTS_FIELD,
  QUERYBOTTLEINFOQUESTCMD_FINISHS_FIELD
}
QUERYBOTTLEINFOQUESTCMD.is_extendable = false
QUERYBOTTLEINFOQUESTCMD.extensions = {}
BOTTLEACTIONQUESTCMD_CMD_FIELD.name = "cmd"
BOTTLEACTIONQUESTCMD_CMD_FIELD.full_name = ".Cmd.BottleActionQuestCmd.cmd"
BOTTLEACTIONQUESTCMD_CMD_FIELD.number = 1
BOTTLEACTIONQUESTCMD_CMD_FIELD.index = 0
BOTTLEACTIONQUESTCMD_CMD_FIELD.label = 1
BOTTLEACTIONQUESTCMD_CMD_FIELD.has_default_value = true
BOTTLEACTIONQUESTCMD_CMD_FIELD.default_value = 8
BOTTLEACTIONQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BOTTLEACTIONQUESTCMD_CMD_FIELD.type = 14
BOTTLEACTIONQUESTCMD_CMD_FIELD.cpp_type = 8
BOTTLEACTIONQUESTCMD_PARAM_FIELD.name = "param"
BOTTLEACTIONQUESTCMD_PARAM_FIELD.full_name = ".Cmd.BottleActionQuestCmd.param"
BOTTLEACTIONQUESTCMD_PARAM_FIELD.number = 2
BOTTLEACTIONQUESTCMD_PARAM_FIELD.index = 1
BOTTLEACTIONQUESTCMD_PARAM_FIELD.label = 1
BOTTLEACTIONQUESTCMD_PARAM_FIELD.has_default_value = true
BOTTLEACTIONQUESTCMD_PARAM_FIELD.default_value = 31
BOTTLEACTIONQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
BOTTLEACTIONQUESTCMD_PARAM_FIELD.type = 14
BOTTLEACTIONQUESTCMD_PARAM_FIELD.cpp_type = 8
BOTTLEACTIONQUESTCMD_ACTION_FIELD.name = "action"
BOTTLEACTIONQUESTCMD_ACTION_FIELD.full_name = ".Cmd.BottleActionQuestCmd.action"
BOTTLEACTIONQUESTCMD_ACTION_FIELD.number = 3
BOTTLEACTIONQUESTCMD_ACTION_FIELD.index = 2
BOTTLEACTIONQUESTCMD_ACTION_FIELD.label = 1
BOTTLEACTIONQUESTCMD_ACTION_FIELD.has_default_value = false
BOTTLEACTIONQUESTCMD_ACTION_FIELD.default_value = nil
BOTTLEACTIONQUESTCMD_ACTION_FIELD.enum_type = EBOTTLEACTION
BOTTLEACTIONQUESTCMD_ACTION_FIELD.type = 14
BOTTLEACTIONQUESTCMD_ACTION_FIELD.cpp_type = 8
BOTTLEACTIONQUESTCMD_ID_FIELD.name = "id"
BOTTLEACTIONQUESTCMD_ID_FIELD.full_name = ".Cmd.BottleActionQuestCmd.id"
BOTTLEACTIONQUESTCMD_ID_FIELD.number = 4
BOTTLEACTIONQUESTCMD_ID_FIELD.index = 3
BOTTLEACTIONQUESTCMD_ID_FIELD.label = 1
BOTTLEACTIONQUESTCMD_ID_FIELD.has_default_value = false
BOTTLEACTIONQUESTCMD_ID_FIELD.default_value = 0
BOTTLEACTIONQUESTCMD_ID_FIELD.type = 13
BOTTLEACTIONQUESTCMD_ID_FIELD.cpp_type = 3
BOTTLEACTIONQUESTCMD.name = "BottleActionQuestCmd"
BOTTLEACTIONQUESTCMD.full_name = ".Cmd.BottleActionQuestCmd"
BOTTLEACTIONQUESTCMD.nested_types = {}
BOTTLEACTIONQUESTCMD.enum_types = {}
BOTTLEACTIONQUESTCMD.fields = {
  BOTTLEACTIONQUESTCMD_CMD_FIELD,
  BOTTLEACTIONQUESTCMD_PARAM_FIELD,
  BOTTLEACTIONQUESTCMD_ACTION_FIELD,
  BOTTLEACTIONQUESTCMD_ID_FIELD
}
BOTTLEACTIONQUESTCMD.is_extendable = false
BOTTLEACTIONQUESTCMD.extensions = {}
BOTTLEUPDATEQUESTCMD_CMD_FIELD.name = "cmd"
BOTTLEUPDATEQUESTCMD_CMD_FIELD.full_name = ".Cmd.BottleUpdateQuestCmd.cmd"
BOTTLEUPDATEQUESTCMD_CMD_FIELD.number = 1
BOTTLEUPDATEQUESTCMD_CMD_FIELD.index = 0
BOTTLEUPDATEQUESTCMD_CMD_FIELD.label = 1
BOTTLEUPDATEQUESTCMD_CMD_FIELD.has_default_value = true
BOTTLEUPDATEQUESTCMD_CMD_FIELD.default_value = 8
BOTTLEUPDATEQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BOTTLEUPDATEQUESTCMD_CMD_FIELD.type = 14
BOTTLEUPDATEQUESTCMD_CMD_FIELD.cpp_type = 8
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.name = "param"
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.full_name = ".Cmd.BottleUpdateQuestCmd.param"
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.number = 2
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.index = 1
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.label = 1
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.has_default_value = true
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.default_value = 32
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.type = 14
BOTTLEUPDATEQUESTCMD_PARAM_FIELD.cpp_type = 8
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.name = "status"
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.full_name = ".Cmd.BottleUpdateQuestCmd.status"
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.number = 3
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.index = 2
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.label = 1
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.has_default_value = false
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.default_value = nil
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.enum_type = EBOTTLESTATUS
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.type = 14
BOTTLEUPDATEQUESTCMD_STATUS_FIELD.cpp_type = 8
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.name = "updates"
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.full_name = ".Cmd.BottleUpdateQuestCmd.updates"
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.number = 4
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.index = 3
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.label = 3
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.has_default_value = false
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.default_value = {}
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.message_type = BOTTLEDATA
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.type = 11
BOTTLEUPDATEQUESTCMD_UPDATES_FIELD.cpp_type = 10
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.name = "delids"
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.full_name = ".Cmd.BottleUpdateQuestCmd.delids"
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.number = 5
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.index = 4
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.label = 3
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.has_default_value = false
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.default_value = {}
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.type = 13
BOTTLEUPDATEQUESTCMD_DELIDS_FIELD.cpp_type = 3
BOTTLEUPDATEQUESTCMD.name = "BottleUpdateQuestCmd"
BOTTLEUPDATEQUESTCMD.full_name = ".Cmd.BottleUpdateQuestCmd"
BOTTLEUPDATEQUESTCMD.nested_types = {}
BOTTLEUPDATEQUESTCMD.enum_types = {}
BOTTLEUPDATEQUESTCMD.fields = {
  BOTTLEUPDATEQUESTCMD_CMD_FIELD,
  BOTTLEUPDATEQUESTCMD_PARAM_FIELD,
  BOTTLEUPDATEQUESTCMD_STATUS_FIELD,
  BOTTLEUPDATEQUESTCMD_UPDATES_FIELD,
  BOTTLEUPDATEQUESTCMD_DELIDS_FIELD
}
BOTTLEUPDATEQUESTCMD.is_extendable = false
BOTTLEUPDATEQUESTCMD.extensions = {}
EVIDENCEDATA_ID_FIELD.name = "id"
EVIDENCEDATA_ID_FIELD.full_name = ".Cmd.EvidenceData.id"
EVIDENCEDATA_ID_FIELD.number = 1
EVIDENCEDATA_ID_FIELD.index = 0
EVIDENCEDATA_ID_FIELD.label = 1
EVIDENCEDATA_ID_FIELD.has_default_value = false
EVIDENCEDATA_ID_FIELD.default_value = 0
EVIDENCEDATA_ID_FIELD.type = 13
EVIDENCEDATA_ID_FIELD.cpp_type = 3
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.name = "unlock_message"
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.full_name = ".Cmd.EvidenceData.unlock_message"
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.number = 2
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.index = 1
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.label = 3
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.has_default_value = false
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.default_value = {}
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.type = 13
EVIDENCEDATA_UNLOCK_MESSAGE_FIELD.cpp_type = 3
EVIDENCEDATA.name = "EvidenceData"
EVIDENCEDATA.full_name = ".Cmd.EvidenceData"
EVIDENCEDATA.nested_types = {}
EVIDENCEDATA.enum_types = {}
EVIDENCEDATA.fields = {
  EVIDENCEDATA_ID_FIELD,
  EVIDENCEDATA_UNLOCK_MESSAGE_FIELD
}
EVIDENCEDATA.is_extendable = false
EVIDENCEDATA.extensions = {}
EVIDENCEQUERYCMD_CMD_FIELD.name = "cmd"
EVIDENCEQUERYCMD_CMD_FIELD.full_name = ".Cmd.EvidenceQueryCmd.cmd"
EVIDENCEQUERYCMD_CMD_FIELD.number = 1
EVIDENCEQUERYCMD_CMD_FIELD.index = 0
EVIDENCEQUERYCMD_CMD_FIELD.label = 1
EVIDENCEQUERYCMD_CMD_FIELD.has_default_value = true
EVIDENCEQUERYCMD_CMD_FIELD.default_value = 8
EVIDENCEQUERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EVIDENCEQUERYCMD_CMD_FIELD.type = 14
EVIDENCEQUERYCMD_CMD_FIELD.cpp_type = 8
EVIDENCEQUERYCMD_PARAM_FIELD.name = "param"
EVIDENCEQUERYCMD_PARAM_FIELD.full_name = ".Cmd.EvidenceQueryCmd.param"
EVIDENCEQUERYCMD_PARAM_FIELD.number = 2
EVIDENCEQUERYCMD_PARAM_FIELD.index = 1
EVIDENCEQUERYCMD_PARAM_FIELD.label = 1
EVIDENCEQUERYCMD_PARAM_FIELD.has_default_value = true
EVIDENCEQUERYCMD_PARAM_FIELD.default_value = 33
EVIDENCEQUERYCMD_PARAM_FIELD.enum_type = QUESTPARAM
EVIDENCEQUERYCMD_PARAM_FIELD.type = 14
EVIDENCEQUERYCMD_PARAM_FIELD.cpp_type = 8
EVIDENCEQUERYCMD_EVIDENCES_FIELD.name = "evidences"
EVIDENCEQUERYCMD_EVIDENCES_FIELD.full_name = ".Cmd.EvidenceQueryCmd.evidences"
EVIDENCEQUERYCMD_EVIDENCES_FIELD.number = 3
EVIDENCEQUERYCMD_EVIDENCES_FIELD.index = 2
EVIDENCEQUERYCMD_EVIDENCES_FIELD.label = 3
EVIDENCEQUERYCMD_EVIDENCES_FIELD.has_default_value = false
EVIDENCEQUERYCMD_EVIDENCES_FIELD.default_value = {}
EVIDENCEQUERYCMD_EVIDENCES_FIELD.message_type = EVIDENCEDATA
EVIDENCEQUERYCMD_EVIDENCES_FIELD.type = 11
EVIDENCEQUERYCMD_EVIDENCES_FIELD.cpp_type = 10
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.name = "next_hint"
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.full_name = ".Cmd.EvidenceQueryCmd.next_hint"
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.number = 4
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.index = 3
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.label = 1
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.has_default_value = false
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.default_value = 0
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.type = 13
EVIDENCEQUERYCMD_NEXT_HINT_FIELD.cpp_type = 3
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.name = "last_hint_cd"
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.full_name = ".Cmd.EvidenceQueryCmd.last_hint_cd"
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.number = 5
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.index = 4
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.label = 1
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.has_default_value = false
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.default_value = 0
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.type = 13
EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD.cpp_type = 3
EVIDENCEQUERYCMD.name = "EvidenceQueryCmd"
EVIDENCEQUERYCMD.full_name = ".Cmd.EvidenceQueryCmd"
EVIDENCEQUERYCMD.nested_types = {}
EVIDENCEQUERYCMD.enum_types = {}
EVIDENCEQUERYCMD.fields = {
  EVIDENCEQUERYCMD_CMD_FIELD,
  EVIDENCEQUERYCMD_PARAM_FIELD,
  EVIDENCEQUERYCMD_EVIDENCES_FIELD,
  EVIDENCEQUERYCMD_NEXT_HINT_FIELD,
  EVIDENCEQUERYCMD_LAST_HINT_CD_FIELD
}
EVIDENCEQUERYCMD.is_extendable = false
EVIDENCEQUERYCMD.extensions = {}
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.name = "cmd"
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.full_name = ".Cmd.UnlockEvidenceMessageCmd.cmd"
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.number = 1
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.index = 0
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.label = 1
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.has_default_value = true
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.default_value = 8
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.type = 14
UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD.cpp_type = 8
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.name = "param"
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.full_name = ".Cmd.UnlockEvidenceMessageCmd.param"
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.number = 2
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.index = 1
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.label = 1
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.has_default_value = true
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.default_value = 34
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.enum_type = QUESTPARAM
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.type = 14
UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD.cpp_type = 8
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.name = "evidence_id"
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.full_name = ".Cmd.UnlockEvidenceMessageCmd.evidence_id"
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.number = 3
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.index = 2
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.label = 1
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.has_default_value = false
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.default_value = 0
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.type = 13
UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD.cpp_type = 3
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.name = "message_id"
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.full_name = ".Cmd.UnlockEvidenceMessageCmd.message_id"
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.number = 4
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.index = 3
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.label = 1
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.has_default_value = false
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.default_value = 0
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.type = 13
UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD.cpp_type = 3
UNLOCKEVIDENCEMESSAGECMD.name = "UnlockEvidenceMessageCmd"
UNLOCKEVIDENCEMESSAGECMD.full_name = ".Cmd.UnlockEvidenceMessageCmd"
UNLOCKEVIDENCEMESSAGECMD.nested_types = {}
UNLOCKEVIDENCEMESSAGECMD.enum_types = {}
UNLOCKEVIDENCEMESSAGECMD.fields = {
  UNLOCKEVIDENCEMESSAGECMD_CMD_FIELD,
  UNLOCKEVIDENCEMESSAGECMD_PARAM_FIELD,
  UNLOCKEVIDENCEMESSAGECMD_EVIDENCE_ID_FIELD,
  UNLOCKEVIDENCEMESSAGECMD_MESSAGE_ID_FIELD
}
UNLOCKEVIDENCEMESSAGECMD.is_extendable = false
UNLOCKEVIDENCEMESSAGECMD.extensions = {}
RELATIONDATA_ID_FIELD.name = "id"
RELATIONDATA_ID_FIELD.full_name = ".Cmd.RelationData.id"
RELATIONDATA_ID_FIELD.number = 1
RELATIONDATA_ID_FIELD.index = 0
RELATIONDATA_ID_FIELD.label = 1
RELATIONDATA_ID_FIELD.has_default_value = false
RELATIONDATA_ID_FIELD.default_value = 0
RELATIONDATA_ID_FIELD.type = 13
RELATIONDATA_ID_FIELD.cpp_type = 3
RELATIONDATA_STATE_FIELD.name = "state"
RELATIONDATA_STATE_FIELD.full_name = ".Cmd.RelationData.state"
RELATIONDATA_STATE_FIELD.number = 2
RELATIONDATA_STATE_FIELD.index = 1
RELATIONDATA_STATE_FIELD.label = 1
RELATIONDATA_STATE_FIELD.has_default_value = false
RELATIONDATA_STATE_FIELD.default_value = 0
RELATIONDATA_STATE_FIELD.type = 13
RELATIONDATA_STATE_FIELD.cpp_type = 3
RELATIONDATA.name = "RelationData"
RELATIONDATA.full_name = ".Cmd.RelationData"
RELATIONDATA.nested_types = {}
RELATIONDATA.enum_types = {}
RELATIONDATA.fields = {
  RELATIONDATA_ID_FIELD,
  RELATIONDATA_STATE_FIELD
}
RELATIONDATA.is_extendable = false
RELATIONDATA.extensions = {}
CHARACTERSECRET_SECRET_ID_FIELD.name = "secret_id"
CHARACTERSECRET_SECRET_ID_FIELD.full_name = ".Cmd.CharacterSecret.secret_id"
CHARACTERSECRET_SECRET_ID_FIELD.number = 1
CHARACTERSECRET_SECRET_ID_FIELD.index = 0
CHARACTERSECRET_SECRET_ID_FIELD.label = 1
CHARACTERSECRET_SECRET_ID_FIELD.has_default_value = false
CHARACTERSECRET_SECRET_ID_FIELD.default_value = 0
CHARACTERSECRET_SECRET_ID_FIELD.type = 13
CHARACTERSECRET_SECRET_ID_FIELD.cpp_type = 3
CHARACTERSECRET_LIGHTED_FIELD.name = "lighted"
CHARACTERSECRET_LIGHTED_FIELD.full_name = ".Cmd.CharacterSecret.lighted"
CHARACTERSECRET_LIGHTED_FIELD.number = 2
CHARACTERSECRET_LIGHTED_FIELD.index = 1
CHARACTERSECRET_LIGHTED_FIELD.label = 1
CHARACTERSECRET_LIGHTED_FIELD.has_default_value = false
CHARACTERSECRET_LIGHTED_FIELD.default_value = false
CHARACTERSECRET_LIGHTED_FIELD.type = 8
CHARACTERSECRET_LIGHTED_FIELD.cpp_type = 7
CHARACTERSECRET.name = "CharacterSecret"
CHARACTERSECRET.full_name = ".Cmd.CharacterSecret"
CHARACTERSECRET.nested_types = {}
CHARACTERSECRET.enum_types = {}
CHARACTERSECRET.fields = {
  CHARACTERSECRET_SECRET_ID_FIELD,
  CHARACTERSECRET_LIGHTED_FIELD
}
CHARACTERSECRET.is_extendable = false
CHARACTERSECRET.extensions = {}
CHARACTERINFO_CHARACTER_ID_FIELD.name = "character_id"
CHARACTERINFO_CHARACTER_ID_FIELD.full_name = ".Cmd.CharacterInfo.character_id"
CHARACTERINFO_CHARACTER_ID_FIELD.number = 1
CHARACTERINFO_CHARACTER_ID_FIELD.index = 0
CHARACTERINFO_CHARACTER_ID_FIELD.label = 1
CHARACTERINFO_CHARACTER_ID_FIELD.has_default_value = false
CHARACTERINFO_CHARACTER_ID_FIELD.default_value = 0
CHARACTERINFO_CHARACTER_ID_FIELD.type = 13
CHARACTERINFO_CHARACTER_ID_FIELD.cpp_type = 3
CHARACTERINFO_UNLOCK_SECRETS_FIELD.name = "unlock_secrets"
CHARACTERINFO_UNLOCK_SECRETS_FIELD.full_name = ".Cmd.CharacterInfo.unlock_secrets"
CHARACTERINFO_UNLOCK_SECRETS_FIELD.number = 2
CHARACTERINFO_UNLOCK_SECRETS_FIELD.index = 1
CHARACTERINFO_UNLOCK_SECRETS_FIELD.label = 3
CHARACTERINFO_UNLOCK_SECRETS_FIELD.has_default_value = false
CHARACTERINFO_UNLOCK_SECRETS_FIELD.default_value = {}
CHARACTERINFO_UNLOCK_SECRETS_FIELD.message_type = CHARACTERSECRET
CHARACTERINFO_UNLOCK_SECRETS_FIELD.type = 11
CHARACTERINFO_UNLOCK_SECRETS_FIELD.cpp_type = 10
CHARACTERINFO.name = "CharacterInfo"
CHARACTERINFO.full_name = ".Cmd.CharacterInfo"
CHARACTERINFO.nested_types = {}
CHARACTERINFO.enum_types = {}
CHARACTERINFO.fields = {
  CHARACTERINFO_CHARACTER_ID_FIELD,
  CHARACTERINFO_UNLOCK_SECRETS_FIELD
}
CHARACTERINFO.is_extendable = false
CHARACTERINFO.extensions = {}
QUERYCHARACTERINFOCMD_CMD_FIELD.name = "cmd"
QUERYCHARACTERINFOCMD_CMD_FIELD.full_name = ".Cmd.QueryCharacterInfoCmd.cmd"
QUERYCHARACTERINFOCMD_CMD_FIELD.number = 1
QUERYCHARACTERINFOCMD_CMD_FIELD.index = 0
QUERYCHARACTERINFOCMD_CMD_FIELD.label = 1
QUERYCHARACTERINFOCMD_CMD_FIELD.has_default_value = true
QUERYCHARACTERINFOCMD_CMD_FIELD.default_value = 8
QUERYCHARACTERINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYCHARACTERINFOCMD_CMD_FIELD.type = 14
QUERYCHARACTERINFOCMD_CMD_FIELD.cpp_type = 8
QUERYCHARACTERINFOCMD_PARAM_FIELD.name = "param"
QUERYCHARACTERINFOCMD_PARAM_FIELD.full_name = ".Cmd.QueryCharacterInfoCmd.param"
QUERYCHARACTERINFOCMD_PARAM_FIELD.number = 2
QUERYCHARACTERINFOCMD_PARAM_FIELD.index = 1
QUERYCHARACTERINFOCMD_PARAM_FIELD.label = 1
QUERYCHARACTERINFOCMD_PARAM_FIELD.has_default_value = true
QUERYCHARACTERINFOCMD_PARAM_FIELD.default_value = 35
QUERYCHARACTERINFOCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYCHARACTERINFOCMD_PARAM_FIELD.type = 14
QUERYCHARACTERINFOCMD_PARAM_FIELD.cpp_type = 8
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.name = "characters"
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.full_name = ".Cmd.QueryCharacterInfoCmd.characters"
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.number = 3
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.index = 2
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.label = 3
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.has_default_value = false
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.default_value = {}
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.message_type = CHARACTERINFO
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.type = 11
QUERYCHARACTERINFOCMD_CHARACTERS_FIELD.cpp_type = 10
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.name = "relations"
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.full_name = ".Cmd.QueryCharacterInfoCmd.relations"
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.number = 4
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.index = 3
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.label = 3
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.has_default_value = false
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.default_value = {}
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.message_type = RELATIONDATA
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.type = 11
QUERYCHARACTERINFOCMD_RELATIONS_FIELD.cpp_type = 10
QUERYCHARACTERINFOCMD.name = "QueryCharacterInfoCmd"
QUERYCHARACTERINFOCMD.full_name = ".Cmd.QueryCharacterInfoCmd"
QUERYCHARACTERINFOCMD.nested_types = {}
QUERYCHARACTERINFOCMD.enum_types = {}
QUERYCHARACTERINFOCMD.fields = {
  QUERYCHARACTERINFOCMD_CMD_FIELD,
  QUERYCHARACTERINFOCMD_PARAM_FIELD,
  QUERYCHARACTERINFOCMD_CHARACTERS_FIELD,
  QUERYCHARACTERINFOCMD_RELATIONS_FIELD
}
QUERYCHARACTERINFOCMD.is_extendable = false
QUERYCHARACTERINFOCMD.extensions = {}
EVIDENCEHINTCMD_CMD_FIELD.name = "cmd"
EVIDENCEHINTCMD_CMD_FIELD.full_name = ".Cmd.EvidenceHintCmd.cmd"
EVIDENCEHINTCMD_CMD_FIELD.number = 1
EVIDENCEHINTCMD_CMD_FIELD.index = 0
EVIDENCEHINTCMD_CMD_FIELD.label = 1
EVIDENCEHINTCMD_CMD_FIELD.has_default_value = true
EVIDENCEHINTCMD_CMD_FIELD.default_value = 8
EVIDENCEHINTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EVIDENCEHINTCMD_CMD_FIELD.type = 14
EVIDENCEHINTCMD_CMD_FIELD.cpp_type = 8
EVIDENCEHINTCMD_PARAM_FIELD.name = "param"
EVIDENCEHINTCMD_PARAM_FIELD.full_name = ".Cmd.EvidenceHintCmd.param"
EVIDENCEHINTCMD_PARAM_FIELD.number = 2
EVIDENCEHINTCMD_PARAM_FIELD.index = 1
EVIDENCEHINTCMD_PARAM_FIELD.label = 1
EVIDENCEHINTCMD_PARAM_FIELD.has_default_value = true
EVIDENCEHINTCMD_PARAM_FIELD.default_value = 37
EVIDENCEHINTCMD_PARAM_FIELD.enum_type = QUESTPARAM
EVIDENCEHINTCMD_PARAM_FIELD.type = 14
EVIDENCEHINTCMD_PARAM_FIELD.cpp_type = 8
EVIDENCEHINTCMD_SUCCESS_FIELD.name = "success"
EVIDENCEHINTCMD_SUCCESS_FIELD.full_name = ".Cmd.EvidenceHintCmd.success"
EVIDENCEHINTCMD_SUCCESS_FIELD.number = 3
EVIDENCEHINTCMD_SUCCESS_FIELD.index = 2
EVIDENCEHINTCMD_SUCCESS_FIELD.label = 1
EVIDENCEHINTCMD_SUCCESS_FIELD.has_default_value = false
EVIDENCEHINTCMD_SUCCESS_FIELD.default_value = false
EVIDENCEHINTCMD_SUCCESS_FIELD.type = 8
EVIDENCEHINTCMD_SUCCESS_FIELD.cpp_type = 7
EVIDENCEHINTCMD_NEXT_HINT_FIELD.name = "next_hint"
EVIDENCEHINTCMD_NEXT_HINT_FIELD.full_name = ".Cmd.EvidenceHintCmd.next_hint"
EVIDENCEHINTCMD_NEXT_HINT_FIELD.number = 4
EVIDENCEHINTCMD_NEXT_HINT_FIELD.index = 3
EVIDENCEHINTCMD_NEXT_HINT_FIELD.label = 1
EVIDENCEHINTCMD_NEXT_HINT_FIELD.has_default_value = false
EVIDENCEHINTCMD_NEXT_HINT_FIELD.default_value = 0
EVIDENCEHINTCMD_NEXT_HINT_FIELD.type = 13
EVIDENCEHINTCMD_NEXT_HINT_FIELD.cpp_type = 3
EVIDENCEHINTCMD_HINT_CD_FIELD.name = "hint_cd"
EVIDENCEHINTCMD_HINT_CD_FIELD.full_name = ".Cmd.EvidenceHintCmd.hint_cd"
EVIDENCEHINTCMD_HINT_CD_FIELD.number = 5
EVIDENCEHINTCMD_HINT_CD_FIELD.index = 4
EVIDENCEHINTCMD_HINT_CD_FIELD.label = 1
EVIDENCEHINTCMD_HINT_CD_FIELD.has_default_value = false
EVIDENCEHINTCMD_HINT_CD_FIELD.default_value = 0
EVIDENCEHINTCMD_HINT_CD_FIELD.type = 13
EVIDENCEHINTCMD_HINT_CD_FIELD.cpp_type = 3
EVIDENCEHINTCMD.name = "EvidenceHintCmd"
EVIDENCEHINTCMD.full_name = ".Cmd.EvidenceHintCmd"
EVIDENCEHINTCMD.nested_types = {}
EVIDENCEHINTCMD.enum_types = {}
EVIDENCEHINTCMD.fields = {
  EVIDENCEHINTCMD_CMD_FIELD,
  EVIDENCEHINTCMD_PARAM_FIELD,
  EVIDENCEHINTCMD_SUCCESS_FIELD,
  EVIDENCEHINTCMD_NEXT_HINT_FIELD,
  EVIDENCEHINTCMD_HINT_CD_FIELD
}
EVIDENCEHINTCMD.is_extendable = false
EVIDENCEHINTCMD.extensions = {}
ENLIGHTSECRETCMD_CMD_FIELD.name = "cmd"
ENLIGHTSECRETCMD_CMD_FIELD.full_name = ".Cmd.EnlightSecretCmd.cmd"
ENLIGHTSECRETCMD_CMD_FIELD.number = 1
ENLIGHTSECRETCMD_CMD_FIELD.index = 0
ENLIGHTSECRETCMD_CMD_FIELD.label = 1
ENLIGHTSECRETCMD_CMD_FIELD.has_default_value = true
ENLIGHTSECRETCMD_CMD_FIELD.default_value = 8
ENLIGHTSECRETCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENLIGHTSECRETCMD_CMD_FIELD.type = 14
ENLIGHTSECRETCMD_CMD_FIELD.cpp_type = 8
ENLIGHTSECRETCMD_PARAM_FIELD.name = "param"
ENLIGHTSECRETCMD_PARAM_FIELD.full_name = ".Cmd.EnlightSecretCmd.param"
ENLIGHTSECRETCMD_PARAM_FIELD.number = 2
ENLIGHTSECRETCMD_PARAM_FIELD.index = 1
ENLIGHTSECRETCMD_PARAM_FIELD.label = 1
ENLIGHTSECRETCMD_PARAM_FIELD.has_default_value = true
ENLIGHTSECRETCMD_PARAM_FIELD.default_value = 38
ENLIGHTSECRETCMD_PARAM_FIELD.enum_type = QUESTPARAM
ENLIGHTSECRETCMD_PARAM_FIELD.type = 14
ENLIGHTSECRETCMD_PARAM_FIELD.cpp_type = 8
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.name = "character_id"
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.full_name = ".Cmd.EnlightSecretCmd.character_id"
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.number = 3
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.index = 2
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.label = 1
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.has_default_value = false
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.default_value = 0
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.type = 13
ENLIGHTSECRETCMD_CHARACTER_ID_FIELD.cpp_type = 3
ENLIGHTSECRETCMD_SECRET_ID_FIELD.name = "secret_id"
ENLIGHTSECRETCMD_SECRET_ID_FIELD.full_name = ".Cmd.EnlightSecretCmd.secret_id"
ENLIGHTSECRETCMD_SECRET_ID_FIELD.number = 4
ENLIGHTSECRETCMD_SECRET_ID_FIELD.index = 3
ENLIGHTSECRETCMD_SECRET_ID_FIELD.label = 1
ENLIGHTSECRETCMD_SECRET_ID_FIELD.has_default_value = false
ENLIGHTSECRETCMD_SECRET_ID_FIELD.default_value = 0
ENLIGHTSECRETCMD_SECRET_ID_FIELD.type = 13
ENLIGHTSECRETCMD_SECRET_ID_FIELD.cpp_type = 3
ENLIGHTSECRETCMD_SUCCESS_FIELD.name = "success"
ENLIGHTSECRETCMD_SUCCESS_FIELD.full_name = ".Cmd.EnlightSecretCmd.success"
ENLIGHTSECRETCMD_SUCCESS_FIELD.number = 5
ENLIGHTSECRETCMD_SUCCESS_FIELD.index = 4
ENLIGHTSECRETCMD_SUCCESS_FIELD.label = 1
ENLIGHTSECRETCMD_SUCCESS_FIELD.has_default_value = false
ENLIGHTSECRETCMD_SUCCESS_FIELD.default_value = false
ENLIGHTSECRETCMD_SUCCESS_FIELD.type = 8
ENLIGHTSECRETCMD_SUCCESS_FIELD.cpp_type = 7
ENLIGHTSECRETCMD.name = "EnlightSecretCmd"
ENLIGHTSECRETCMD.full_name = ".Cmd.EnlightSecretCmd"
ENLIGHTSECRETCMD.nested_types = {}
ENLIGHTSECRETCMD.enum_types = {}
ENLIGHTSECRETCMD.fields = {
  ENLIGHTSECRETCMD_CMD_FIELD,
  ENLIGHTSECRETCMD_PARAM_FIELD,
  ENLIGHTSECRETCMD_CHARACTER_ID_FIELD,
  ENLIGHTSECRETCMD_SECRET_ID_FIELD,
  ENLIGHTSECRETCMD_SUCCESS_FIELD
}
ENLIGHTSECRETCMD.is_extendable = false
ENLIGHTSECRETCMD.extensions = {}
CLOSEUICMD_CMD_FIELD.name = "cmd"
CLOSEUICMD_CMD_FIELD.full_name = ".Cmd.CloseUICmd.cmd"
CLOSEUICMD_CMD_FIELD.number = 1
CLOSEUICMD_CMD_FIELD.index = 0
CLOSEUICMD_CMD_FIELD.label = 1
CLOSEUICMD_CMD_FIELD.has_default_value = true
CLOSEUICMD_CMD_FIELD.default_value = 8
CLOSEUICMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CLOSEUICMD_CMD_FIELD.type = 14
CLOSEUICMD_CMD_FIELD.cpp_type = 8
CLOSEUICMD_PARAM_FIELD.name = "param"
CLOSEUICMD_PARAM_FIELD.full_name = ".Cmd.CloseUICmd.param"
CLOSEUICMD_PARAM_FIELD.number = 2
CLOSEUICMD_PARAM_FIELD.index = 1
CLOSEUICMD_PARAM_FIELD.label = 1
CLOSEUICMD_PARAM_FIELD.has_default_value = true
CLOSEUICMD_PARAM_FIELD.default_value = 39
CLOSEUICMD_PARAM_FIELD.enum_type = QUESTPARAM
CLOSEUICMD_PARAM_FIELD.type = 14
CLOSEUICMD_PARAM_FIELD.cpp_type = 8
CLOSEUICMD_QUESTID_FIELD.name = "questid"
CLOSEUICMD_QUESTID_FIELD.full_name = ".Cmd.CloseUICmd.questid"
CLOSEUICMD_QUESTID_FIELD.number = 3
CLOSEUICMD_QUESTID_FIELD.index = 2
CLOSEUICMD_QUESTID_FIELD.label = 1
CLOSEUICMD_QUESTID_FIELD.has_default_value = false
CLOSEUICMD_QUESTID_FIELD.default_value = 0
CLOSEUICMD_QUESTID_FIELD.type = 13
CLOSEUICMD_QUESTID_FIELD.cpp_type = 3
CLOSEUICMD_RAID_STARID_FIELD.name = "raid_starid"
CLOSEUICMD_RAID_STARID_FIELD.full_name = ".Cmd.CloseUICmd.raid_starid"
CLOSEUICMD_RAID_STARID_FIELD.number = 4
CLOSEUICMD_RAID_STARID_FIELD.index = 3
CLOSEUICMD_RAID_STARID_FIELD.label = 1
CLOSEUICMD_RAID_STARID_FIELD.has_default_value = false
CLOSEUICMD_RAID_STARID_FIELD.default_value = 0
CLOSEUICMD_RAID_STARID_FIELD.type = 13
CLOSEUICMD_RAID_STARID_FIELD.cpp_type = 3
CLOSEUICMD.name = "CloseUICmd"
CLOSEUICMD.full_name = ".Cmd.CloseUICmd"
CLOSEUICMD.nested_types = {}
CLOSEUICMD.enum_types = {}
CLOSEUICMD.fields = {
  CLOSEUICMD_CMD_FIELD,
  CLOSEUICMD_PARAM_FIELD,
  CLOSEUICMD_QUESTID_FIELD,
  CLOSEUICMD_RAID_STARID_FIELD
}
CLOSEUICMD.is_extendable = false
CLOSEUICMD.extensions = {}
NEWEVIDENCEUPDATECMD_CMD_FIELD.name = "cmd"
NEWEVIDENCEUPDATECMD_CMD_FIELD.full_name = ".Cmd.NewEvidenceUpdateCmd.cmd"
NEWEVIDENCEUPDATECMD_CMD_FIELD.number = 1
NEWEVIDENCEUPDATECMD_CMD_FIELD.index = 0
NEWEVIDENCEUPDATECMD_CMD_FIELD.label = 1
NEWEVIDENCEUPDATECMD_CMD_FIELD.has_default_value = true
NEWEVIDENCEUPDATECMD_CMD_FIELD.default_value = 8
NEWEVIDENCEUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
NEWEVIDENCEUPDATECMD_CMD_FIELD.type = 14
NEWEVIDENCEUPDATECMD_CMD_FIELD.cpp_type = 8
NEWEVIDENCEUPDATECMD_PARAM_FIELD.name = "param"
NEWEVIDENCEUPDATECMD_PARAM_FIELD.full_name = ".Cmd.NewEvidenceUpdateCmd.param"
NEWEVIDENCEUPDATECMD_PARAM_FIELD.number = 2
NEWEVIDENCEUPDATECMD_PARAM_FIELD.index = 1
NEWEVIDENCEUPDATECMD_PARAM_FIELD.label = 1
NEWEVIDENCEUPDATECMD_PARAM_FIELD.has_default_value = true
NEWEVIDENCEUPDATECMD_PARAM_FIELD.default_value = 40
NEWEVIDENCEUPDATECMD_PARAM_FIELD.enum_type = QUESTPARAM
NEWEVIDENCEUPDATECMD_PARAM_FIELD.type = 14
NEWEVIDENCEUPDATECMD_PARAM_FIELD.cpp_type = 8
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.name = "evidence_ids"
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.full_name = ".Cmd.NewEvidenceUpdateCmd.evidence_ids"
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.number = 3
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.index = 2
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.label = 3
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.has_default_value = false
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.default_value = {}
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.type = 13
NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD.cpp_type = 3
NEWEVIDENCEUPDATECMD.name = "NewEvidenceUpdateCmd"
NEWEVIDENCEUPDATECMD.full_name = ".Cmd.NewEvidenceUpdateCmd"
NEWEVIDENCEUPDATECMD.nested_types = {}
NEWEVIDENCEUPDATECMD.enum_types = {}
NEWEVIDENCEUPDATECMD.fields = {
  NEWEVIDENCEUPDATECMD_CMD_FIELD,
  NEWEVIDENCEUPDATECMD_PARAM_FIELD,
  NEWEVIDENCEUPDATECMD_EVIDENCE_IDS_FIELD
}
NEWEVIDENCEUPDATECMD.is_extendable = false
NEWEVIDENCEUPDATECMD.extensions = {}
LEAVEVISITNPCQUESTCMD_CMD_FIELD.name = "cmd"
LEAVEVISITNPCQUESTCMD_CMD_FIELD.full_name = ".Cmd.LeaveVisitNpcQuestCmd.cmd"
LEAVEVISITNPCQUESTCMD_CMD_FIELD.number = 1
LEAVEVISITNPCQUESTCMD_CMD_FIELD.index = 0
LEAVEVISITNPCQUESTCMD_CMD_FIELD.label = 1
LEAVEVISITNPCQUESTCMD_CMD_FIELD.has_default_value = true
LEAVEVISITNPCQUESTCMD_CMD_FIELD.default_value = 8
LEAVEVISITNPCQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LEAVEVISITNPCQUESTCMD_CMD_FIELD.type = 14
LEAVEVISITNPCQUESTCMD_CMD_FIELD.cpp_type = 8
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.name = "param"
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.full_name = ".Cmd.LeaveVisitNpcQuestCmd.param"
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.number = 2
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.index = 1
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.label = 1
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.has_default_value = true
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.default_value = 41
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.type = 14
LEAVEVISITNPCQUESTCMD_PARAM_FIELD.cpp_type = 8
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.name = "sync_scene"
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.full_name = ".Cmd.LeaveVisitNpcQuestCmd.sync_scene"
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.number = 3
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.index = 2
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.label = 1
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.has_default_value = true
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.default_value = false
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.type = 8
LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD.cpp_type = 7
LEAVEVISITNPCQUESTCMD.name = "LeaveVisitNpcQuestCmd"
LEAVEVISITNPCQUESTCMD.full_name = ".Cmd.LeaveVisitNpcQuestCmd"
LEAVEVISITNPCQUESTCMD.nested_types = {}
LEAVEVISITNPCQUESTCMD.enum_types = {}
LEAVEVISITNPCQUESTCMD.fields = {
  LEAVEVISITNPCQUESTCMD_CMD_FIELD,
  LEAVEVISITNPCQUESTCMD_PARAM_FIELD,
  LEAVEVISITNPCQUESTCMD_SYNC_SCENE_FIELD
}
LEAVEVISITNPCQUESTCMD.is_extendable = false
LEAVEVISITNPCQUESTCMD.extensions = {}
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.name = "cmd"
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.full_name = ".Cmd.CompleteAvailableQueryQuestCmd.cmd"
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.number = 1
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.index = 0
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.label = 1
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.has_default_value = true
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.default_value = 8
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.type = 14
COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD.cpp_type = 8
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.name = "param"
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.full_name = ".Cmd.CompleteAvailableQueryQuestCmd.param"
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.number = 2
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.index = 1
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.label = 1
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.has_default_value = true
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.default_value = 42
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.type = 14
COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD.cpp_type = 8
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.name = "itemid"
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.full_name = ".Cmd.CompleteAvailableQueryQuestCmd.itemid"
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.number = 3
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.index = 2
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.label = 1
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.has_default_value = false
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.default_value = 0
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.type = 13
COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD.cpp_type = 3
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.name = "status"
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.full_name = ".Cmd.CompleteAvailableQueryQuestCmd.status"
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.number = 4
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.index = 3
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.label = 1
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.has_default_value = false
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.default_value = nil
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.enum_type = EQUESTCOMPLETESTATUS
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.type = 14
COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD.cpp_type = 8
COMPLETEAVAILABLEQUERYQUESTCMD.name = "CompleteAvailableQueryQuestCmd"
COMPLETEAVAILABLEQUERYQUESTCMD.full_name = ".Cmd.CompleteAvailableQueryQuestCmd"
COMPLETEAVAILABLEQUERYQUESTCMD.nested_types = {}
COMPLETEAVAILABLEQUERYQUESTCMD.enum_types = {}
COMPLETEAVAILABLEQUERYQUESTCMD.fields = {
  COMPLETEAVAILABLEQUERYQUESTCMD_CMD_FIELD,
  COMPLETEAVAILABLEQUERYQUESTCMD_PARAM_FIELD,
  COMPLETEAVAILABLEQUERYQUESTCMD_ITEMID_FIELD,
  COMPLETEAVAILABLEQUERYQUESTCMD_STATUS_FIELD
}
COMPLETEAVAILABLEQUERYQUESTCMD.is_extendable = false
COMPLETEAVAILABLEQUERYQUESTCMD.extensions = {}
WORLDFINISHCOUNT_GROUPID_FIELD.name = "groupid"
WORLDFINISHCOUNT_GROUPID_FIELD.full_name = ".Cmd.WorldFinishCount.groupid"
WORLDFINISHCOUNT_GROUPID_FIELD.number = 1
WORLDFINISHCOUNT_GROUPID_FIELD.index = 0
WORLDFINISHCOUNT_GROUPID_FIELD.label = 1
WORLDFINISHCOUNT_GROUPID_FIELD.has_default_value = false
WORLDFINISHCOUNT_GROUPID_FIELD.default_value = 0
WORLDFINISHCOUNT_GROUPID_FIELD.type = 13
WORLDFINISHCOUNT_GROUPID_FIELD.cpp_type = 3
WORLDFINISHCOUNT_COUNT_FIELD.name = "count"
WORLDFINISHCOUNT_COUNT_FIELD.full_name = ".Cmd.WorldFinishCount.count"
WORLDFINISHCOUNT_COUNT_FIELD.number = 2
WORLDFINISHCOUNT_COUNT_FIELD.index = 1
WORLDFINISHCOUNT_COUNT_FIELD.label = 1
WORLDFINISHCOUNT_COUNT_FIELD.has_default_value = false
WORLDFINISHCOUNT_COUNT_FIELD.default_value = 0
WORLDFINISHCOUNT_COUNT_FIELD.type = 13
WORLDFINISHCOUNT_COUNT_FIELD.cpp_type = 3
WORLDFINISHCOUNT.name = "WorldFinishCount"
WORLDFINISHCOUNT.full_name = ".Cmd.WorldFinishCount"
WORLDFINISHCOUNT.nested_types = {}
WORLDFINISHCOUNT.enum_types = {}
WORLDFINISHCOUNT.fields = {
  WORLDFINISHCOUNT_GROUPID_FIELD,
  WORLDFINISHCOUNT_COUNT_FIELD
}
WORLDFINISHCOUNT.is_extendable = false
WORLDFINISHCOUNT.extensions = {}
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.name = "cmd"
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.full_name = ".Cmd.WorldCountListQuestCmd.cmd"
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.number = 1
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.index = 0
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.label = 1
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.has_default_value = true
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.default_value = 8
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.type = 14
WORLDCOUNTLISTQUESTCMD_CMD_FIELD.cpp_type = 8
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.name = "param"
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.WorldCountListQuestCmd.param"
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.number = 2
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.index = 1
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.label = 1
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.has_default_value = true
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.default_value = 43
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.type = 14
WORLDCOUNTLISTQUESTCMD_PARAM_FIELD.cpp_type = 8
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.name = "list"
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.full_name = ".Cmd.WorldCountListQuestCmd.list"
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.number = 3
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.index = 2
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.label = 3
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.has_default_value = false
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.default_value = {}
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.message_type = WORLDFINISHCOUNT
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.type = 11
WORLDCOUNTLISTQUESTCMD_LIST_FIELD.cpp_type = 10
WORLDCOUNTLISTQUESTCMD.name = "WorldCountListQuestCmd"
WORLDCOUNTLISTQUESTCMD.full_name = ".Cmd.WorldCountListQuestCmd"
WORLDCOUNTLISTQUESTCMD.nested_types = {}
WORLDCOUNTLISTQUESTCMD.enum_types = {}
WORLDCOUNTLISTQUESTCMD.fields = {
  WORLDCOUNTLISTQUESTCMD_CMD_FIELD,
  WORLDCOUNTLISTQUESTCMD_PARAM_FIELD,
  WORLDCOUNTLISTQUESTCMD_LIST_FIELD
}
WORLDCOUNTLISTQUESTCMD.is_extendable = false
WORLDCOUNTLISTQUESTCMD.extensions = {}
QUESTSTATUS_QUESTID_FIELD.name = "questid"
QUESTSTATUS_QUESTID_FIELD.full_name = ".Cmd.QuestStatus.questid"
QUESTSTATUS_QUESTID_FIELD.number = 1
QUESTSTATUS_QUESTID_FIELD.index = 0
QUESTSTATUS_QUESTID_FIELD.label = 1
QUESTSTATUS_QUESTID_FIELD.has_default_value = false
QUESTSTATUS_QUESTID_FIELD.default_value = 0
QUESTSTATUS_QUESTID_FIELD.type = 13
QUESTSTATUS_QUESTID_FIELD.cpp_type = 3
QUESTSTATUS_STATUS_FIELD.name = "status"
QUESTSTATUS_STATUS_FIELD.full_name = ".Cmd.QuestStatus.status"
QUESTSTATUS_STATUS_FIELD.number = 2
QUESTSTATUS_STATUS_FIELD.index = 1
QUESTSTATUS_STATUS_FIELD.label = 1
QUESTSTATUS_STATUS_FIELD.has_default_value = false
QUESTSTATUS_STATUS_FIELD.default_value = nil
QUESTSTATUS_STATUS_FIELD.enum_type = EQUESTSTATUS
QUESTSTATUS_STATUS_FIELD.type = 14
QUESTSTATUS_STATUS_FIELD.cpp_type = 8
QUESTSTATUS.name = "QuestStatus"
QUESTSTATUS.full_name = ".Cmd.QuestStatus"
QUESTSTATUS.nested_types = {}
QUESTSTATUS.enum_types = {}
QUESTSTATUS.fields = {
  QUESTSTATUS_QUESTID_FIELD,
  QUESTSTATUS_STATUS_FIELD
}
QUESTSTATUS.is_extendable = false
QUESTSTATUS.extensions = {}
HEROPREQUESTCONFIG_QUESTID_FIELD.name = "questid"
HEROPREQUESTCONFIG_QUESTID_FIELD.full_name = ".Cmd.HeroPreQuestConfig.questid"
HEROPREQUESTCONFIG_QUESTID_FIELD.number = 1
HEROPREQUESTCONFIG_QUESTID_FIELD.index = 0
HEROPREQUESTCONFIG_QUESTID_FIELD.label = 1
HEROPREQUESTCONFIG_QUESTID_FIELD.has_default_value = false
HEROPREQUESTCONFIG_QUESTID_FIELD.default_value = 0
HEROPREQUESTCONFIG_QUESTID_FIELD.type = 13
HEROPREQUESTCONFIG_QUESTID_FIELD.cpp_type = 3
HEROPREQUESTCONFIG_CONFIG_FIELD.name = "config"
HEROPREQUESTCONFIG_CONFIG_FIELD.full_name = ".Cmd.HeroPreQuestConfig.config"
HEROPREQUESTCONFIG_CONFIG_FIELD.number = 2
HEROPREQUESTCONFIG_CONFIG_FIELD.index = 1
HEROPREQUESTCONFIG_CONFIG_FIELD.label = 1
HEROPREQUESTCONFIG_CONFIG_FIELD.has_default_value = false
HEROPREQUESTCONFIG_CONFIG_FIELD.default_value = nil
HEROPREQUESTCONFIG_CONFIG_FIELD.message_type = QUESTPCONFIG
HEROPREQUESTCONFIG_CONFIG_FIELD.type = 11
HEROPREQUESTCONFIG_CONFIG_FIELD.cpp_type = 10
HEROPREQUESTCONFIG.name = "HeroPreQuestConfig"
HEROPREQUESTCONFIG.full_name = ".Cmd.HeroPreQuestConfig"
HEROPREQUESTCONFIG.nested_types = {}
HEROPREQUESTCONFIG.enum_types = {}
HEROPREQUESTCONFIG.fields = {
  HEROPREQUESTCONFIG_QUESTID_FIELD,
  HEROPREQUESTCONFIG_CONFIG_FIELD
}
HEROPREQUESTCONFIG.is_extendable = false
HEROPREQUESTCONFIG.extensions = {}
QUESTHERO_ID_FIELD.name = "id"
QUESTHERO_ID_FIELD.full_name = ".Cmd.QuestHero.id"
QUESTHERO_ID_FIELD.number = 1
QUESTHERO_ID_FIELD.index = 0
QUESTHERO_ID_FIELD.label = 1
QUESTHERO_ID_FIELD.has_default_value = false
QUESTHERO_ID_FIELD.default_value = 0
QUESTHERO_ID_FIELD.type = 13
QUESTHERO_ID_FIELD.cpp_type = 3
QUESTHERO_STATUS_FIELD.name = "status"
QUESTHERO_STATUS_FIELD.full_name = ".Cmd.QuestHero.status"
QUESTHERO_STATUS_FIELD.number = 2
QUESTHERO_STATUS_FIELD.index = 1
QUESTHERO_STATUS_FIELD.label = 1
QUESTHERO_STATUS_FIELD.has_default_value = false
QUESTHERO_STATUS_FIELD.default_value = nil
QUESTHERO_STATUS_FIELD.enum_type = EQUESTHEROSTATUS
QUESTHERO_STATUS_FIELD.type = 14
QUESTHERO_STATUS_FIELD.cpp_type = 8
QUESTHERO_FIRST_FIELD.name = "first"
QUESTHERO_FIRST_FIELD.full_name = ".Cmd.QuestHero.first"
QUESTHERO_FIRST_FIELD.number = 3
QUESTHERO_FIRST_FIELD.index = 2
QUESTHERO_FIRST_FIELD.label = 3
QUESTHERO_FIRST_FIELD.has_default_value = false
QUESTHERO_FIRST_FIELD.default_value = {}
QUESTHERO_FIRST_FIELD.message_type = HEROPREQUESTCONFIG
QUESTHERO_FIRST_FIELD.type = 11
QUESTHERO_FIRST_FIELD.cpp_type = 10
QUESTHERO.name = "QuestHero"
QUESTHERO.full_name = ".Cmd.QuestHero"
QUESTHERO.nested_types = {}
QUESTHERO.enum_types = {}
QUESTHERO.fields = {
  QUESTHERO_ID_FIELD,
  QUESTHERO_STATUS_FIELD,
  QUESTHERO_FIRST_FIELD
}
QUESTHERO.is_extendable = false
QUESTHERO.extensions = {}
QUERYQUESTHEROQUESTCMD_CMD_FIELD.name = "cmd"
QUERYQUESTHEROQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryQuestHeroQuestCmd.cmd"
QUERYQUESTHEROQUESTCMD_CMD_FIELD.number = 1
QUERYQUESTHEROQUESTCMD_CMD_FIELD.index = 0
QUERYQUESTHEROQUESTCMD_CMD_FIELD.label = 1
QUERYQUESTHEROQUESTCMD_CMD_FIELD.has_default_value = true
QUERYQUESTHEROQUESTCMD_CMD_FIELD.default_value = 8
QUERYQUESTHEROQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYQUESTHEROQUESTCMD_CMD_FIELD.type = 14
QUERYQUESTHEROQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.name = "param"
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryQuestHeroQuestCmd.param"
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.number = 2
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.index = 1
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.label = 1
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.default_value = 48
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.type = 14
QUERYQUESTHEROQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.name = "items"
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.full_name = ".Cmd.QueryQuestHeroQuestCmd.items"
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.number = 3
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.index = 2
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.label = 3
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.has_default_value = false
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.default_value = {}
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.message_type = QUESTHERO
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.type = 11
QUERYQUESTHEROQUESTCMD_ITEMS_FIELD.cpp_type = 10
QUERYQUESTHEROQUESTCMD.name = "QueryQuestHeroQuestCmd"
QUERYQUESTHEROQUESTCMD.full_name = ".Cmd.QueryQuestHeroQuestCmd"
QUERYQUESTHEROQUESTCMD.nested_types = {}
QUERYQUESTHEROQUESTCMD.enum_types = {}
QUERYQUESTHEROQUESTCMD.fields = {
  QUERYQUESTHEROQUESTCMD_CMD_FIELD,
  QUERYQUESTHEROQUESTCMD_PARAM_FIELD,
  QUERYQUESTHEROQUESTCMD_ITEMS_FIELD
}
QUERYQUESTHEROQUESTCMD.is_extendable = false
QUERYQUESTHEROQUESTCMD.extensions = {}
SETQUESTSTATUSQUESTCMD_CMD_FIELD.name = "cmd"
SETQUESTSTATUSQUESTCMD_CMD_FIELD.full_name = ".Cmd.SetQuestStatusQuestCmd.cmd"
SETQUESTSTATUSQUESTCMD_CMD_FIELD.number = 1
SETQUESTSTATUSQUESTCMD_CMD_FIELD.index = 0
SETQUESTSTATUSQUESTCMD_CMD_FIELD.label = 1
SETQUESTSTATUSQUESTCMD_CMD_FIELD.has_default_value = true
SETQUESTSTATUSQUESTCMD_CMD_FIELD.default_value = 8
SETQUESTSTATUSQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SETQUESTSTATUSQUESTCMD_CMD_FIELD.type = 14
SETQUESTSTATUSQUESTCMD_CMD_FIELD.cpp_type = 8
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.name = "param"
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.full_name = ".Cmd.SetQuestStatusQuestCmd.param"
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.number = 2
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.index = 1
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.label = 1
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.has_default_value = true
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.default_value = 50
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.type = 14
SETQUESTSTATUSQUESTCMD_PARAM_FIELD.cpp_type = 8
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.name = "traces"
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.full_name = ".Cmd.SetQuestStatusQuestCmd.traces"
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.number = 3
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.index = 2
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.label = 3
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.has_default_value = false
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.default_value = {}
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.message_type = QUESTSTATUS
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.type = 11
SETQUESTSTATUSQUESTCMD_TRACES_FIELD.cpp_type = 10
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.name = "news"
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.full_name = ".Cmd.SetQuestStatusQuestCmd.news"
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.number = 4
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.index = 3
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.label = 3
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.has_default_value = false
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.default_value = {}
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.message_type = QUESTSTATUS
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.type = 11
SETQUESTSTATUSQUESTCMD_NEWS_FIELD.cpp_type = 10
SETQUESTSTATUSQUESTCMD.name = "SetQuestStatusQuestCmd"
SETQUESTSTATUSQUESTCMD.full_name = ".Cmd.SetQuestStatusQuestCmd"
SETQUESTSTATUSQUESTCMD.nested_types = {}
SETQUESTSTATUSQUESTCMD.enum_types = {}
SETQUESTSTATUSQUESTCMD.fields = {
  SETQUESTSTATUSQUESTCMD_CMD_FIELD,
  SETQUESTSTATUSQUESTCMD_PARAM_FIELD,
  SETQUESTSTATUSQUESTCMD_TRACES_FIELD,
  SETQUESTSTATUSQUESTCMD_NEWS_FIELD
}
SETQUESTSTATUSQUESTCMD.is_extendable = false
SETQUESTSTATUSQUESTCMD.extensions = {}
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.name = "cmd"
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.full_name = ".Cmd.UpdateQuestHeroQuestCmd.cmd"
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.number = 1
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.index = 0
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.label = 1
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.has_default_value = true
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.default_value = 8
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.type = 14
UPDATEQUESTHEROQUESTCMD_CMD_FIELD.cpp_type = 8
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.name = "param"
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.full_name = ".Cmd.UpdateQuestHeroQuestCmd.param"
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.number = 2
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.index = 1
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.label = 1
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.has_default_value = true
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.default_value = 49
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.type = 14
UPDATEQUESTHEROQUESTCMD_PARAM_FIELD.cpp_type = 8
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.name = "items"
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.full_name = ".Cmd.UpdateQuestHeroQuestCmd.items"
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.number = 3
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.index = 2
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.label = 3
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.has_default_value = false
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.default_value = {}
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.message_type = QUESTHERO
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.type = 11
UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD.cpp_type = 10
UPDATEQUESTHEROQUESTCMD.name = "UpdateQuestHeroQuestCmd"
UPDATEQUESTHEROQUESTCMD.full_name = ".Cmd.UpdateQuestHeroQuestCmd"
UPDATEQUESTHEROQUESTCMD.nested_types = {}
UPDATEQUESTHEROQUESTCMD.enum_types = {}
UPDATEQUESTHEROQUESTCMD.fields = {
  UPDATEQUESTHEROQUESTCMD_CMD_FIELD,
  UPDATEQUESTHEROQUESTCMD_PARAM_FIELD,
  UPDATEQUESTHEROQUESTCMD_ITEMS_FIELD
}
UPDATEQUESTHEROQUESTCMD.is_extendable = false
UPDATEQUESTHEROQUESTCMD.extensions = {}
QUESTSTORYITEM_STATUS_FIELD.name = "status"
QUESTSTORYITEM_STATUS_FIELD.full_name = ".Cmd.QuestStoryItem.status"
QUESTSTORYITEM_STATUS_FIELD.number = 1
QUESTSTORYITEM_STATUS_FIELD.index = 0
QUESTSTORYITEM_STATUS_FIELD.label = 1
QUESTSTORYITEM_STATUS_FIELD.has_default_value = false
QUESTSTORYITEM_STATUS_FIELD.default_value = nil
QUESTSTORYITEM_STATUS_FIELD.enum_type = EQUESTLIST
QUESTSTORYITEM_STATUS_FIELD.type = 14
QUESTSTORYITEM_STATUS_FIELD.cpp_type = 8
QUESTSTORYITEM_CONFIG_FIELD.name = "config"
QUESTSTORYITEM_CONFIG_FIELD.full_name = ".Cmd.QuestStoryItem.config"
QUESTSTORYITEM_CONFIG_FIELD.number = 2
QUESTSTORYITEM_CONFIG_FIELD.index = 1
QUESTSTORYITEM_CONFIG_FIELD.label = 1
QUESTSTORYITEM_CONFIG_FIELD.has_default_value = false
QUESTSTORYITEM_CONFIG_FIELD.default_value = nil
QUESTSTORYITEM_CONFIG_FIELD.message_type = QUESTPCONFIG
QUESTSTORYITEM_CONFIG_FIELD.type = 11
QUESTSTORYITEM_CONFIG_FIELD.cpp_type = 10
QUESTSTORYITEM.name = "QuestStoryItem"
QUESTSTORYITEM.full_name = ".Cmd.QuestStoryItem"
QUESTSTORYITEM.nested_types = {}
QUESTSTORYITEM.enum_types = {}
QUESTSTORYITEM.fields = {
  QUESTSTORYITEM_STATUS_FIELD,
  QUESTSTORYITEM_CONFIG_FIELD
}
QUESTSTORYITEM.is_extendable = false
QUESTSTORYITEM.extensions = {}
QUESTSTORYINDEX_INDEX_FIELD.name = "index"
QUESTSTORYINDEX_INDEX_FIELD.full_name = ".Cmd.QuestStoryIndex.index"
QUESTSTORYINDEX_INDEX_FIELD.number = 1
QUESTSTORYINDEX_INDEX_FIELD.index = 0
QUESTSTORYINDEX_INDEX_FIELD.label = 1
QUESTSTORYINDEX_INDEX_FIELD.has_default_value = false
QUESTSTORYINDEX_INDEX_FIELD.default_value = 0
QUESTSTORYINDEX_INDEX_FIELD.type = 13
QUESTSTORYINDEX_INDEX_FIELD.cpp_type = 3
QUESTSTORYINDEX_QUEST_STATUS_FIELD.name = "quest_status"
QUESTSTORYINDEX_QUEST_STATUS_FIELD.full_name = ".Cmd.QuestStoryIndex.quest_status"
QUESTSTORYINDEX_QUEST_STATUS_FIELD.number = 2
QUESTSTORYINDEX_QUEST_STATUS_FIELD.index = 1
QUESTSTORYINDEX_QUEST_STATUS_FIELD.label = 1
QUESTSTORYINDEX_QUEST_STATUS_FIELD.has_default_value = false
QUESTSTORYINDEX_QUEST_STATUS_FIELD.default_value = nil
QUESTSTORYINDEX_QUEST_STATUS_FIELD.enum_type = EQUESTLIST
QUESTSTORYINDEX_QUEST_STATUS_FIELD.type = 14
QUESTSTORYINDEX_QUEST_STATUS_FIELD.cpp_type = 8
QUESTSTORYINDEX_INDEX_STATUS_FIELD.name = "index_status"
QUESTSTORYINDEX_INDEX_STATUS_FIELD.full_name = ".Cmd.QuestStoryIndex.index_status"
QUESTSTORYINDEX_INDEX_STATUS_FIELD.number = 3
QUESTSTORYINDEX_INDEX_STATUS_FIELD.index = 2
QUESTSTORYINDEX_INDEX_STATUS_FIELD.label = 1
QUESTSTORYINDEX_INDEX_STATUS_FIELD.has_default_value = false
QUESTSTORYINDEX_INDEX_STATUS_FIELD.default_value = nil
QUESTSTORYINDEX_INDEX_STATUS_FIELD.enum_type = EQUESTSTORYSTATUS
QUESTSTORYINDEX_INDEX_STATUS_FIELD.type = 14
QUESTSTORYINDEX_INDEX_STATUS_FIELD.cpp_type = 8
QUESTSTORYINDEX_CUR_QUEST_FIELD.name = "cur_quest"
QUESTSTORYINDEX_CUR_QUEST_FIELD.full_name = ".Cmd.QuestStoryIndex.cur_quest"
QUESTSTORYINDEX_CUR_QUEST_FIELD.number = 4
QUESTSTORYINDEX_CUR_QUEST_FIELD.index = 3
QUESTSTORYINDEX_CUR_QUEST_FIELD.label = 3
QUESTSTORYINDEX_CUR_QUEST_FIELD.has_default_value = false
QUESTSTORYINDEX_CUR_QUEST_FIELD.default_value = {}
QUESTSTORYINDEX_CUR_QUEST_FIELD.message_type = QUESTPCONFIG
QUESTSTORYINDEX_CUR_QUEST_FIELD.type = 11
QUESTSTORYINDEX_CUR_QUEST_FIELD.cpp_type = 10
QUESTSTORYINDEX_PRE_QUEST_FIELD.name = "pre_quest"
QUESTSTORYINDEX_PRE_QUEST_FIELD.full_name = ".Cmd.QuestStoryIndex.pre_quest"
QUESTSTORYINDEX_PRE_QUEST_FIELD.number = 5
QUESTSTORYINDEX_PRE_QUEST_FIELD.index = 4
QUESTSTORYINDEX_PRE_QUEST_FIELD.label = 3
QUESTSTORYINDEX_PRE_QUEST_FIELD.has_default_value = false
QUESTSTORYINDEX_PRE_QUEST_FIELD.default_value = {}
QUESTSTORYINDEX_PRE_QUEST_FIELD.message_type = QUESTPCONFIG
QUESTSTORYINDEX_PRE_QUEST_FIELD.type = 11
QUESTSTORYINDEX_PRE_QUEST_FIELD.cpp_type = 10
QUESTSTORYINDEX_CUR_ITEM_FIELD.name = "cur_item"
QUESTSTORYINDEX_CUR_ITEM_FIELD.full_name = ".Cmd.QuestStoryIndex.cur_item"
QUESTSTORYINDEX_CUR_ITEM_FIELD.number = 7
QUESTSTORYINDEX_CUR_ITEM_FIELD.index = 5
QUESTSTORYINDEX_CUR_ITEM_FIELD.label = 3
QUESTSTORYINDEX_CUR_ITEM_FIELD.has_default_value = false
QUESTSTORYINDEX_CUR_ITEM_FIELD.default_value = {}
QUESTSTORYINDEX_CUR_ITEM_FIELD.message_type = QUESTSTORYITEM
QUESTSTORYINDEX_CUR_ITEM_FIELD.type = 11
QUESTSTORYINDEX_CUR_ITEM_FIELD.cpp_type = 10
QUESTSTORYINDEX_PRE_ITEM_FIELD.name = "pre_item"
QUESTSTORYINDEX_PRE_ITEM_FIELD.full_name = ".Cmd.QuestStoryIndex.pre_item"
QUESTSTORYINDEX_PRE_ITEM_FIELD.number = 8
QUESTSTORYINDEX_PRE_ITEM_FIELD.index = 6
QUESTSTORYINDEX_PRE_ITEM_FIELD.label = 3
QUESTSTORYINDEX_PRE_ITEM_FIELD.has_default_value = false
QUESTSTORYINDEX_PRE_ITEM_FIELD.default_value = {}
QUESTSTORYINDEX_PRE_ITEM_FIELD.message_type = QUESTSTORYITEM
QUESTSTORYINDEX_PRE_ITEM_FIELD.type = 11
QUESTSTORYINDEX_PRE_ITEM_FIELD.cpp_type = 10
QUESTSTORYINDEX_SUB_ITEM_FIELD.name = "sub_item"
QUESTSTORYINDEX_SUB_ITEM_FIELD.full_name = ".Cmd.QuestStoryIndex.sub_item"
QUESTSTORYINDEX_SUB_ITEM_FIELD.number = 9
QUESTSTORYINDEX_SUB_ITEM_FIELD.index = 7
QUESTSTORYINDEX_SUB_ITEM_FIELD.label = 3
QUESTSTORYINDEX_SUB_ITEM_FIELD.has_default_value = false
QUESTSTORYINDEX_SUB_ITEM_FIELD.default_value = {}
QUESTSTORYINDEX_SUB_ITEM_FIELD.message_type = QUESTSTORYITEM
QUESTSTORYINDEX_SUB_ITEM_FIELD.type = 11
QUESTSTORYINDEX_SUB_ITEM_FIELD.cpp_type = 10
QUESTSTORYINDEX_REWARDS_FIELD.name = "rewards"
QUESTSTORYINDEX_REWARDS_FIELD.full_name = ".Cmd.QuestStoryIndex.rewards"
QUESTSTORYINDEX_REWARDS_FIELD.number = 6
QUESTSTORYINDEX_REWARDS_FIELD.index = 8
QUESTSTORYINDEX_REWARDS_FIELD.label = 3
QUESTSTORYINDEX_REWARDS_FIELD.has_default_value = false
QUESTSTORYINDEX_REWARDS_FIELD.default_value = {}
QUESTSTORYINDEX_REWARDS_FIELD.message_type = ProtoCommon_pb.QUESTREWARD
QUESTSTORYINDEX_REWARDS_FIELD.type = 11
QUESTSTORYINDEX_REWARDS_FIELD.cpp_type = 10
QUESTSTORYINDEX.name = "QuestStoryIndex"
QUESTSTORYINDEX.full_name = ".Cmd.QuestStoryIndex"
QUESTSTORYINDEX.nested_types = {}
QUESTSTORYINDEX.enum_types = {}
QUESTSTORYINDEX.fields = {
  QUESTSTORYINDEX_INDEX_FIELD,
  QUESTSTORYINDEX_QUEST_STATUS_FIELD,
  QUESTSTORYINDEX_INDEX_STATUS_FIELD,
  QUESTSTORYINDEX_CUR_QUEST_FIELD,
  QUESTSTORYINDEX_PRE_QUEST_FIELD,
  QUESTSTORYINDEX_CUR_ITEM_FIELD,
  QUESTSTORYINDEX_PRE_ITEM_FIELD,
  QUESTSTORYINDEX_SUB_ITEM_FIELD,
  QUESTSTORYINDEX_REWARDS_FIELD
}
QUESTSTORYINDEX.is_extendable = false
QUESTSTORYINDEX.extensions = {}
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.name = "cmd"
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.full_name = ".Cmd.UpdateQuestStoryIndexQuestCmd.cmd"
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.number = 1
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.index = 0
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.label = 1
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.has_default_value = true
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.default_value = 8
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.type = 14
UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD.cpp_type = 8
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.name = "param"
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.full_name = ".Cmd.UpdateQuestStoryIndexQuestCmd.param"
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.number = 2
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.index = 1
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.label = 1
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.has_default_value = true
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.default_value = 51
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.type = 14
UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD.cpp_type = 8
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.name = "version"
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.full_name = ".Cmd.UpdateQuestStoryIndexQuestCmd.version"
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.number = 3
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.index = 2
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.label = 1
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.has_default_value = false
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.default_value = ""
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.type = 9
UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD.cpp_type = 9
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.name = "indexs"
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.full_name = ".Cmd.UpdateQuestStoryIndexQuestCmd.indexs"
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.number = 4
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.index = 3
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.label = 3
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.has_default_value = false
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.default_value = {}
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.message_type = QUESTSTORYINDEX
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.type = 11
UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD.cpp_type = 10
UPDATEQUESTSTORYINDEXQUESTCMD.name = "UpdateQuestStoryIndexQuestCmd"
UPDATEQUESTSTORYINDEXQUESTCMD.full_name = ".Cmd.UpdateQuestStoryIndexQuestCmd"
UPDATEQUESTSTORYINDEXQUESTCMD.nested_types = {}
UPDATEQUESTSTORYINDEXQUESTCMD.enum_types = {}
UPDATEQUESTSTORYINDEXQUESTCMD.fields = {
  UPDATEQUESTSTORYINDEXQUESTCMD_CMD_FIELD,
  UPDATEQUESTSTORYINDEXQUESTCMD_PARAM_FIELD,
  UPDATEQUESTSTORYINDEXQUESTCMD_VERSION_FIELD,
  UPDATEQUESTSTORYINDEXQUESTCMD_INDEXS_FIELD
}
UPDATEQUESTSTORYINDEXQUESTCMD.is_extendable = false
UPDATEQUESTSTORYINDEXQUESTCMD.extensions = {}
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.name = "cmd"
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.full_name = ".Cmd.UpdateOnceRewardQuestCmd.cmd"
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.number = 1
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.index = 0
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.label = 1
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.has_default_value = true
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.default_value = 8
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.type = 14
UPDATEONCEREWARDQUESTCMD_CMD_FIELD.cpp_type = 8
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.name = "param"
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.full_name = ".Cmd.UpdateOnceRewardQuestCmd.param"
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.number = 2
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.index = 1
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.label = 1
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.has_default_value = true
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.default_value = 52
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.type = 14
UPDATEONCEREWARDQUESTCMD_PARAM_FIELD.cpp_type = 8
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.name = "item"
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.full_name = ".Cmd.UpdateOnceRewardQuestCmd.item"
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.number = 3
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.index = 2
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.label = 3
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.has_default_value = false
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.default_value = {}
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.message_type = ProtoCommon_pb.QUESTREWARD
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.type = 11
UPDATEONCEREWARDQUESTCMD_ITEM_FIELD.cpp_type = 10
UPDATEONCEREWARDQUESTCMD.name = "UpdateOnceRewardQuestCmd"
UPDATEONCEREWARDQUESTCMD.full_name = ".Cmd.UpdateOnceRewardQuestCmd"
UPDATEONCEREWARDQUESTCMD.nested_types = {}
UPDATEONCEREWARDQUESTCMD.enum_types = {}
UPDATEONCEREWARDQUESTCMD.fields = {
  UPDATEONCEREWARDQUESTCMD_CMD_FIELD,
  UPDATEONCEREWARDQUESTCMD_PARAM_FIELD,
  UPDATEONCEREWARDQUESTCMD_ITEM_FIELD
}
UPDATEONCEREWARDQUESTCMD.is_extendable = false
UPDATEONCEREWARDQUESTCMD.extensions = {}
SYNCTREASUREBOXNUMCMD_CMD_FIELD.name = "cmd"
SYNCTREASUREBOXNUMCMD_CMD_FIELD.full_name = ".Cmd.SyncTreasureBoxNumCmd.cmd"
SYNCTREASUREBOXNUMCMD_CMD_FIELD.number = 1
SYNCTREASUREBOXNUMCMD_CMD_FIELD.index = 0
SYNCTREASUREBOXNUMCMD_CMD_FIELD.label = 1
SYNCTREASUREBOXNUMCMD_CMD_FIELD.has_default_value = true
SYNCTREASUREBOXNUMCMD_CMD_FIELD.default_value = 8
SYNCTREASUREBOXNUMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTREASUREBOXNUMCMD_CMD_FIELD.type = 14
SYNCTREASUREBOXNUMCMD_CMD_FIELD.cpp_type = 8
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.name = "param"
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.full_name = ".Cmd.SyncTreasureBoxNumCmd.param"
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.number = 2
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.index = 1
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.label = 1
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.has_default_value = true
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.default_value = 53
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.enum_type = QUESTPARAM
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.type = 14
SYNCTREASUREBOXNUMCMD_PARAM_FIELD.cpp_type = 8
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.name = "mapid"
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.full_name = ".Cmd.SyncTreasureBoxNumCmd.mapid"
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.number = 3
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.index = 2
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.label = 1
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.has_default_value = false
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.default_value = 0
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.type = 13
SYNCTREASUREBOXNUMCMD_MAPID_FIELD.cpp_type = 3
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.name = "gotten_num"
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.full_name = ".Cmd.SyncTreasureBoxNumCmd.gotten_num"
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.number = 4
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.index = 3
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.label = 1
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.has_default_value = false
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.default_value = 0
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.type = 13
SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD.cpp_type = 3
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.name = "total_num"
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.full_name = ".Cmd.SyncTreasureBoxNumCmd.total_num"
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.number = 5
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.index = 4
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.label = 1
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.has_default_value = false
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.default_value = 0
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.type = 13
SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD.cpp_type = 3
SYNCTREASUREBOXNUMCMD.name = "SyncTreasureBoxNumCmd"
SYNCTREASUREBOXNUMCMD.full_name = ".Cmd.SyncTreasureBoxNumCmd"
SYNCTREASUREBOXNUMCMD.nested_types = {}
SYNCTREASUREBOXNUMCMD.enum_types = {}
SYNCTREASUREBOXNUMCMD.fields = {
  SYNCTREASUREBOXNUMCMD_CMD_FIELD,
  SYNCTREASUREBOXNUMCMD_PARAM_FIELD,
  SYNCTREASUREBOXNUMCMD_MAPID_FIELD,
  SYNCTREASUREBOXNUMCMD_GOTTEN_NUM_FIELD,
  SYNCTREASUREBOXNUMCMD_TOTAL_NUM_FIELD
}
SYNCTREASUREBOXNUMCMD.is_extendable = false
SYNCTREASUREBOXNUMCMD.extensions = {}
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.name = "cmd"
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.cmd"
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.number = 1
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.index = 0
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.has_default_value = true
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.default_value = 8
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.type = 14
QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD.cpp_type = 8
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.name = "param"
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.param"
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.number = 2
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.index = 1
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.has_default_value = true
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.default_value = 54
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.type = 14
QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD.cpp_type = 8
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.name = "cur_area"
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.cur_area"
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.number = 3
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.index = 2
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.has_default_value = false
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.default_value = 0
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.type = 13
QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD.cpp_type = 3
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.name = "cur_prestige_lv"
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.cur_prestige_lv"
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.number = 4
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.index = 3
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.has_default_value = false
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.default_value = 0
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.type = 13
QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD.cpp_type = 3
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.name = "cur_help_count"
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.cur_help_count"
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.number = 5
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.index = 4
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.has_default_value = false
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.default_value = 0
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.type = 13
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD.cpp_type = 3
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.name = "cur_help_totalcount"
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.cur_help_totalcount"
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.number = 6
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.index = 5
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.has_default_value = false
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.default_value = 0
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.type = 13
QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD.cpp_type = 3
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.name = "list"
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd.list"
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.number = 7
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.index = 6
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.label = 1
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.has_default_value = false
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.default_value = nil
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.message_type = QUESTLIST
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.type = 11
QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD.cpp_type = 10
QUERYABYSSQUESTLISTQUESTCMD.name = "QueryAbyssQuestListQuestCmd"
QUERYABYSSQUESTLISTQUESTCMD.full_name = ".Cmd.QueryAbyssQuestListQuestCmd"
QUERYABYSSQUESTLISTQUESTCMD.nested_types = {}
QUERYABYSSQUESTLISTQUESTCMD.enum_types = {}
QUERYABYSSQUESTLISTQUESTCMD.fields = {
  QUERYABYSSQUESTLISTQUESTCMD_CMD_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_PARAM_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_CUR_AREA_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_CUR_PRESTIGE_LV_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_COUNT_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_CUR_HELP_TOTALCOUNT_FIELD,
  QUERYABYSSQUESTLISTQUESTCMD_LIST_FIELD
}
QUERYABYSSQUESTLISTQUESTCMD.is_extendable = false
QUERYABYSSQUESTLISTQUESTCMD.extensions = {}
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.name = "cmd"
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.full_name = ".Cmd.UpdateAbyssHelpCountQuestCmd.cmd"
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.number = 1
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.index = 0
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.label = 1
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.has_default_value = true
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.default_value = 8
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.type = 14
UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD.cpp_type = 8
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.name = "param"
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.full_name = ".Cmd.UpdateAbyssHelpCountQuestCmd.param"
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.number = 2
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.index = 1
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.label = 1
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.has_default_value = true
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.default_value = 55
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.enum_type = QUESTPARAM
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.type = 14
UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD.cpp_type = 8
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.name = "area"
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.full_name = ".Cmd.UpdateAbyssHelpCountQuestCmd.area"
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.number = 3
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.index = 2
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.label = 1
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.has_default_value = false
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.default_value = 0
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.type = 13
UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD.cpp_type = 3
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.name = "count"
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.full_name = ".Cmd.UpdateAbyssHelpCountQuestCmd.count"
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.number = 4
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.index = 3
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.label = 1
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.has_default_value = false
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.default_value = 0
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.type = 13
UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD.cpp_type = 3
UPDATEABYSSHELPCOUNTQUESTCMD.name = "UpdateAbyssHelpCountQuestCmd"
UPDATEABYSSHELPCOUNTQUESTCMD.full_name = ".Cmd.UpdateAbyssHelpCountQuestCmd"
UPDATEABYSSHELPCOUNTQUESTCMD.nested_types = {}
UPDATEABYSSHELPCOUNTQUESTCMD.enum_types = {}
UPDATEABYSSHELPCOUNTQUESTCMD.fields = {
  UPDATEABYSSHELPCOUNTQUESTCMD_CMD_FIELD,
  UPDATEABYSSHELPCOUNTQUESTCMD_PARAM_FIELD,
  UPDATEABYSSHELPCOUNTQUESTCMD_AREA_FIELD,
  UPDATEABYSSHELPCOUNTQUESTCMD_COUNT_FIELD
}
UPDATEABYSSHELPCOUNTQUESTCMD.is_extendable = false
UPDATEABYSSHELPCOUNTQUESTCMD.extensions = {}
ACTMISSIONREWARD_ACTID_FIELD.name = "actid"
ACTMISSIONREWARD_ACTID_FIELD.full_name = ".Cmd.ActMissionReward.actid"
ACTMISSIONREWARD_ACTID_FIELD.number = 1
ACTMISSIONREWARD_ACTID_FIELD.index = 0
ACTMISSIONREWARD_ACTID_FIELD.label = 1
ACTMISSIONREWARD_ACTID_FIELD.has_default_value = false
ACTMISSIONREWARD_ACTID_FIELD.default_value = 0
ACTMISSIONREWARD_ACTID_FIELD.type = 13
ACTMISSIONREWARD_ACTID_FIELD.cpp_type = 3
ACTMISSIONREWARD_INDEX_FIELD.name = "index"
ACTMISSIONREWARD_INDEX_FIELD.full_name = ".Cmd.ActMissionReward.index"
ACTMISSIONREWARD_INDEX_FIELD.number = 2
ACTMISSIONREWARD_INDEX_FIELD.index = 1
ACTMISSIONREWARD_INDEX_FIELD.label = 1
ACTMISSIONREWARD_INDEX_FIELD.has_default_value = false
ACTMISSIONREWARD_INDEX_FIELD.default_value = 0
ACTMISSIONREWARD_INDEX_FIELD.type = 13
ACTMISSIONREWARD_INDEX_FIELD.cpp_type = 3
ACTMISSIONREWARD_STATUS_FIELD.name = "status"
ACTMISSIONREWARD_STATUS_FIELD.full_name = ".Cmd.ActMissionReward.status"
ACTMISSIONREWARD_STATUS_FIELD.number = 3
ACTMISSIONREWARD_STATUS_FIELD.index = 2
ACTMISSIONREWARD_STATUS_FIELD.label = 1
ACTMISSIONREWARD_STATUS_FIELD.has_default_value = false
ACTMISSIONREWARD_STATUS_FIELD.default_value = nil
ACTMISSIONREWARD_STATUS_FIELD.enum_type = EACTMISSIONREWARDSTATUS
ACTMISSIONREWARD_STATUS_FIELD.type = 14
ACTMISSIONREWARD_STATUS_FIELD.cpp_type = 8
ACTMISSIONREWARD.name = "ActMissionReward"
ACTMISSIONREWARD.full_name = ".Cmd.ActMissionReward"
ACTMISSIONREWARD.nested_types = {}
ACTMISSIONREWARD.enum_types = {}
ACTMISSIONREWARD.fields = {
  ACTMISSIONREWARD_ACTID_FIELD,
  ACTMISSIONREWARD_INDEX_FIELD,
  ACTMISSIONREWARD_STATUS_FIELD
}
ACTMISSIONREWARD.is_extendable = false
ACTMISSIONREWARD.extensions = {}
ActMissionReward = protobuf.Message(ACTMISSIONREWARD)
BottleActionQuestCmd = protobuf.Message(BOTTLEACTIONQUESTCMD)
BottleData = protobuf.Message(BOTTLEDATA)
BottleUpdateQuestCmd = protobuf.Message(BOTTLEUPDATEQUESTCMD)
CharacterInfo = protobuf.Message(CHARACTERINFO)
CharacterSecret = protobuf.Message(CHARACTERSECRET)
ClientTrace = protobuf.Message(CLIENTTRACE)
CloseUICmd = protobuf.Message(CLOSEUICMD)
CompleteAvailableQueryQuestCmd = protobuf.Message(COMPLETEAVAILABLEQUERYQUESTCMD)
EACT_REWARD_STATUS_DONE = 2
EACT_REWARD_STATUS_MAX = 3
EACT_REWARD_STATUS_MIN = 0
EACT_REWARD_STATUS_REWARD = 1
EBOTTLEACTION_ABANDON = 2
EBOTTLEACTION_ACCEPT = 1
EBOTTLEACTION_FINISH = 3
EBOTTLEACTION_MAX = 4
EBOTTLEACTION_MIN = 0
EBOTTLESTATUS_ACCEPT = 1
EBOTTLESTATUS_FINISH = 2
EBOTTLESTATUS_MAX = 3
EBOTTLESTATUS_MIN = 0
ECLIENTTYPE_FAKEFALSE = 3
ECLIENTTYPE_FALSE = 2
ECLIENTTYPE_TRUE = 1
EOTHERDATA_CAT = 2
EOTHERDATA_DAILY = 1
EOTHERDATA_MAX = 4
EOTHERDATA_MIN = 0
EOTHERDATA_WORLDTREASURE = 3
EQUESTACTION_ABANDON_GROUP = 3
EQUESTACTION_ABANDON_QUEST = 4
EQUESTACTION_ACCEPT = 1
EQUESTACTION_MAX = 9
EQUESTACTION_MIN = 0
EQUESTACTION_QUICK_SUBMIT_ABYSS = 8
EQUESTACTION_QUICK_SUBMIT_BOARD = 5
EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM = 6
EQUESTACTION_REPAIR = 7
EQUESTACTION_SUBMIT = 2
EQUESTCOMPLETESTATUS_MAX = 4
EQUESTCOMPLETESTATUS_MIN = 0
EQUESTCOMPLETESTATUS_NOQUEST = 3
EQUESTCOMPLETESTATUS_QUEST_NOREWARD = 2
EQUESTCOMPLETESTATUS_QUEST_REWARD = 1
EQUESTHEROSTATUS_DONE = 2
EQUESTHEROSTATUS_MAX = 3
EQUESTHEROSTATUS_MIN = 0
EQUESTHEROSTATUS_PROCESS = 1
EQUESTLIST_ACCEPT = 1
EQUESTLIST_CANACCEPT = 4
EQUESTLIST_COMPLETE = 3
EQUESTLIST_MAX = 5
EQUESTLIST_MIN = 0
EQUESTLIST_SUBMIT = 2
EQUESTSTATUS_FAKEFALSE = 3
EQUESTSTATUS_FALSE = 2
EQUESTSTATUS_MAX = 4
EQUESTSTATUS_MIN = 0
EQUESTSTATUS_TRUE = 1
EQUESTSTEP_ACTION = 34
EQUESTSTEP_ACTIVATE_TRANSFER = 165
EQUESTSTEP_ACTIVITY = 59
EQUESTSTEP_ADDPICTURE = 116
EQUESTSTEP_ADD_JOY = 78
EQUESTSTEP_ADD_LOACL_INTERACT = 154
EQUESTSTEP_AIEVENT = 124
EQUESTSTEP_BATTLE = 67
EQUESTSTEP_BATTLE_FIELD = 171
EQUESTSTEP_BATTLE_FIELD_AREA = 172
EQUESTSTEP_BATTLE_FIELD_STATUE = 174
EQUESTSTEP_BATTLE_FIELD_WIN = 173
EQUESTSTEP_BEING = 76
EQUESTSTEP_BUFF = 72
EQUESTSTEP_CAMERA = 13
EQUESTSTEP_CAMERASHOW = 98
EQUESTSTEP_CARRIER = 66
EQUESTSTEP_CG = 80
EQUESTSTEP_CHAT = 85
EQUESTSTEP_CHAT_SYSTEM = 88
EQUESTSTEP_CHECKBORNMAP = 110
EQUESTSTEP_CHECKEQUIP = 38
EQUESTSTEP_CHECKGEAR = 32
EQUESTSTEP_CHECKGROUP = 45
EQUESTSTEP_CHECKITEM = 28
EQUESTSTEP_CHECKLEVEL = 31
EQUESTSTEP_CHECKMONEY = 39
EQUESTSTEP_CHECKOPTION = 43
EQUESTSTEP_CHECKQUEST = 27
EQUESTSTEP_CHECKSERVANT = 81
EQUESTSTEP_CHECKTEAM = 22
EQUESTSTEP_CHECKTRANSFER = 159
EQUESTSTEP_CHECK_CLEAR_END = 143
EQUESTSTEP_CHECK_EVIDENCE = 140
EQUESTSTEP_CHECK_HANDNPC = 94
EQUESTSTEP_CHECK_HOME = 162
EQUESTSTEP_CHECK_JOY = 77
EQUESTSTEP_CHECK_LIGHT_PUZZLE = 118
EQUESTSTEP_CHECK_MANUAL = 53
EQUESTSTEP_CHECK_MENU = 149
EQUESTSTEP_CHECK_MULTI_QUEST = 161
EQUESTSTEP_CHECK_UNLOCKCAT = 89
EQUESTSTEP_CHOOSE_BRANCH = 105
EQUESTSTEP_CHRISTMAS = 74
EQUESTSTEP_CHRISTMAS_RUN = 75
EQUESTSTEP_CLASS = 24
EQUESTSTEP_CLEARNPC = 19
EQUESTSTEP_CLIENTPLOT = 84
EQUESTSTEP_CLIENT_DELAY = 175
EQUESTSTEP_CLIENT_RAID_PASS = 135
EQUESTSTEP_COLLECT = 4
EQUESTSTEP_COOK = 71
EQUESTSTEP_COOKFOOD = 68
EQUESTSTEP_CUT_SCENE = 109
EQUESTSTEP_DAILY = 52
EQUESTSTEP_DELETE = 11
EQUESTSTEP_DELPICTURE = 117
EQUESTSTEP_DIALOG = 17
EQUESTSTEP_EDITOR = 141
EQUESTSTEP_EFFECT = 168
EQUESTSTEP_EMPTY = 37
EQUESTSTEP_EQUIP = 170
EQUESTSTEP_EQUIPLV = 47
EQUESTSTEP_EVO = 26
EQUESTSTEP_EXCHANGE = 145
EQUESTSTEP_FOLLOWNPC = 125
EQUESTSTEP_GAME = 100
EQUESTSTEP_GAMECOUNT = 103
EQUESTSTEP_GATHER = 10
EQUESTSTEP_GMCMD = 7
EQUESTSTEP_GRACE_REWARD = 146
EQUESTSTEP_GROUP = 90
EQUESTSTEP_GUARD = 6
EQUESTSTEP_GUIDE = 40
EQUESTSTEP_GUIDELOCKMONSTER = 57
EQUESTSTEP_GUIDE_CHECK = 41
EQUESTSTEP_GUIDE_HIGHLIGHT = 42
EQUESTSTEP_HAND = 63
EQUESTSTEP_HINT = 44
EQUESTSTEP_ILLUSTRATION = 49
EQUESTSTEP_INHERITSKILL = 176
EQUESTSTEP_INTERACT_LOACL_AI = 151
EQUESTSTEP_INTERACT_LOCAL_VISIT = 153
EQUESTSTEP_INTERACT_MULTI_NPC = 157
EQUESTSTEP_INTERACT_NPC = 156
EQUESTSTEP_INTERLOCUTION = 36
EQUESTSTEP_ITEM = 51
EQUESTSTEP_ITEMUSE = 62
EQUESTSTEP_ITEM_COUNT = 166
EQUESTSTEP_ITEM_NUM = 167
EQUESTSTEP_JOINT_REASON = 123
EQUESTSTEP_KILL = 2
EQUESTSTEP_KILLORDER = 101
EQUESTSTEP_KILL_SPECIALNPC = 132
EQUESTSTEP_LEVEL = 14
EQUESTSTEP_LOAD_CLIENT_RAID = 134
EQUESTSTEP_LOCK_BROKEN = 137
EQUESTSTEP_MAIL = 104
EQUESTSTEP_MANUAL = 54
EQUESTSTEP_MAX = 177
EQUESTSTEP_MENU = 144
EQUESTSTEP_MIN = 0
EQUESTSTEP_MIND_ENTER = 126
EQUESTSTEP_MIND_EXIT = 128
EQUESTSTEP_MIND_UNLOCK_PERFORM = 129
EQUESTSTEP_MONEY = 58
EQUESTSTEP_MOUNTRIDE = 20
EQUESTSTEP_MOVE = 16
EQUESTSTEP_MULTICUTSCENE = 131
EQUESTSTEP_MUSIC = 64
EQUESTSTEP_MUSIC_GAME = 142
EQUESTSTEP_NEW_CHAPTER = 150
EQUESTSTEP_NPCHP = 96
EQUESTSTEP_NPCPLAY = 50
EQUESTSTEP_NPCSKILL = 92
EQUESTSTEP_NPCWALK = 91
EQUESTSTEP_NPC_BUFF = 163
EQUESTSTEP_OPTION = 60
EQUESTSTEP_ORGCLASS = 25
EQUESTSTEP_PAPER = 111
EQUESTSTEP_PARTNER_MOVE = 119
EQUESTSTEP_PET = 69
EQUESTSTEP_PHOTO = 61
EQUESTSTEP_PICTURE = 102
EQUESTSTEP_PLAY_ACTION = 138
EQUESTSTEP_PLAY_EFFECT = 139
EQUESTSTEP_PLAY_MUSIC = 55
EQUESTSTEP_POSTCARD = 148
EQUESTSTEP_PREQUEST = 18
EQUESTSTEP_PRESTIGE_SYSTEM_LEVEL = 164
EQUESTSTEP_PURIFY = 33
EQUESTSTEP_RAID = 12
EQUESTSTEP_RANDITEM = 65
EQUESTSTEP_RANDOMJUMP = 30
EQUESTSTEP_RANDOM_BUFF = 130
EQUESTSTEP_RANDOM_TIP = 112
EQUESTSTEP_RAND_DIALOG = 79
EQUESTSTEP_REDIALOG = 87
EQUESTSTEP_REMOVEITEM = 29
EQUESTSTEP_REMOVEMONEY = 23
EQUESTSTEP_REMOVE_LOACL_AI = 152
EQUESTSTEP_REMOVE_LOACL_INTERACT = 155
EQUESTSTEP_REWARD = 3
EQUESTSTEP_REWRADHELP = 56
EQUESTSTEP_SCENE = 70
EQUESTSTEP_SEAL = 46
EQUESTSTEP_SELFIE = 21
EQUESTSTEP_SELFIE_SYS = 136
EQUESTSTEP_SHAKESCREEN = 115
EQUESTSTEP_SHARE = 113
EQUESTSTEP_SHOT = 107
EQUESTSTEP_SHOW_EVIDENCE = 127
EQUESTSTEP_SKILL = 35
EQUESTSTEP_SMITHY_LEVEL = 147
EQUESTSTEP_START_ACT = 108
EQUESTSTEP_STAR_ARK = 160
EQUESTSTEP_SUMMON = 5
EQUESTSTEP_TAKE_SEAT = 158
EQUESTSTEP_TAPPING = 121
EQUESTSTEP_TESTFAIL = 8
EQUESTSTEP_TIMEPHASING = 99
EQUESTSTEP_TRANSFER = 86
EQUESTSTEP_TRANSIT = 114
EQUESTSTEP_TUTOR = 73
EQUESTSTEP_USE = 9
EQUESTSTEP_USESKILL = 95
EQUESTSTEP_VIDEO = 48
EQUESTSTEP_VISIT = 1
EQUESTSTEP_WAIT = 15
EQUESTSTEP_WAITCLIENT = 120
EQUESTSTEP_WAITPOS = 106
EQUESTSTEP_WAITUI = 133
EQUESTSTORYSTATUS_DONE = 3
EQUESTSTORYSTATUS_LOCK = 1
EQUESTSTORYSTATUS_MAX = 4
EQUESTSTORYSTATUS_MIN = 0
EQUESTSTORYSTATUS_PROCESS = 2
EQUESTTYPE_ABYSS_DAILY = 75
EQUESTTYPE_ACC = 22
EQUESTTYPE_ACC_1 = 43
EQUESTTYPE_ACC_2 = 44
EQUESTTYPE_ACC_3 = 45
EQUESTTYPE_ACC_4 = 46
EQUESTTYPE_ACC_BRANCH = 28
EQUESTTYPE_ACC_CHOICE = 25
EQUESTTYPE_ACC_DAILY = 24
EQUESTTYPE_ACC_DAILY_1 = 30
EQUESTTYPE_ACC_DAILY_3 = 31
EQUESTTYPE_ACC_DAILY_7 = 32
EQUESTTYPE_ACC_DAILY_RESET = 33
EQUESTTYPE_ACC_DAILY_WORLD = 70
EQUESTTYPE_ACC_MAIN = 27
EQUESTTYPE_ACC_NORMAL = 23
EQUESTTYPE_ACC_SATISFACTION = 29
EQUESTTYPE_ACC_WEEK_1 = 61
EQUESTTYPE_ACC_WEEK_3 = 62
EQUESTTYPE_ACC_WEEK_5 = 63
EQUESTTYPE_ACC_WORLD = 68
EQUESTTYPE_ACC_WORLDBOSS = 74
EQUESTTYPE_ACC_WORLDTREASURE = 69
EQUESTTYPE_ANCIENT_CITY_DAILY = 73
EQUESTTYPE_ARTIFACT = 38
EQUESTTYPE_ATMOSPHERE = 71
EQUESTTYPE_BOTTLE = 67
EQUESTTYPE_BRANCH = 2
EQUESTTYPE_BRANCHSTEFANIE = 51
EQUESTTYPE_BRANCHTALK = 50
EQUESTTYPE_CAPRA = 41
EQUESTTYPE_CCRASTEHAM = 17
EQUESTTYPE_CHILD = 20
EQUESTTYPE_DAILY = 6
EQUESTTYPE_DAILY_1 = 7
EQUESTTYPE_DAILY_3 = 8
EQUESTTYPE_DAILY_7 = 9
EQUESTTYPE_DAILY_BOX = 34
EQUESTTYPE_DAILY_MAP = 11
EQUESTTYPE_DAILY_MAPRAND = 26
EQUESTTYPE_DAILY_RESET = 21
EQUESTTYPE_DAY = 36
EQUESTTYPE_DEAD = 42
EQUESTTYPE_ELITE = 16
EQUESTTYPE_GUIDING_TASK = 60
EQUESTTYPE_GUILD = 19
EQUESTTYPE_HEAD = 13
EQUESTTYPE_MAIN = 1
EQUESTTYPE_MAX = 76
EQUESTTYPE_MIN = 0
EQUESTTYPE_NIGHT = 37
EQUESTTYPE_RAIDTALK = 14
EQUESTTYPE_SATISFACTION = 15
EQUESTTYPE_SCENE = 12
EQUESTTYPE_SHARE_DAILY_1 = 53
EQUESTTYPE_SHARE_DAILY_3 = 54
EQUESTTYPE_SHARE_DAILY_7 = 55
EQUESTTYPE_SHARE_NORMAL = 52
EQUESTTYPE_SHARE_STATUS = 59
EQUESTTYPE_SIGN = 35
EQUESTTYPE_SMITHY = 72
EQUESTTYPE_STORY = 10
EQUESTTYPE_STORY_CCRASTEHAM = 18
EQUESTTYPE_TALK = 3
EQUESTTYPE_TRIGGER = 4
EQUESTTYPE_VERSION = 47
EQUESTTYPE_WANTED = 5
EQUESTTYPE_WANTED_DAY = 48
EQUESTTYPE_WANTED_WEEK = 49
EQUESTTYPE_WEDDING = 39
EQUESTTYPE_WEDDING_DAILY = 40
EQUESTTYPE_WEEK_1 = 64
EQUESTTYPE_WEEK_3 = 65
EQUESTTYPE_WEEK_5 = 66
EQUESTTYPE_WORLD = 56
EQUESTTYPE_WORLDBOSS = 57
EQUESTTYPE_WORLDTREASURE = 58
EWANTEDTYPE_ACTIVE = 1
EWANTEDTYPE_DAY = 2
EWANTEDTYPE_MAX = 4
EWANTEDTYPE_TOTAL = 0
EWANTEDTYPE_WEEK = 3
EnlightSecretCmd = protobuf.Message(ENLIGHTSECRETCMD)
EvidenceData = protobuf.Message(EVIDENCEDATA)
EvidenceHintCmd = protobuf.Message(EVIDENCEHINTCMD)
EvidenceQueryCmd = protobuf.Message(EVIDENCEQUERYCMD)
HelpQuickFinishBoardQuestCmd = protobuf.Message(HELPQUICKFINISHBOARDQUESTCMD)
HeroPreQuestConfig = protobuf.Message(HEROPREQUESTCONFIG)
InviteAcceptQuestCmd = protobuf.Message(INVITEACCEPTQUESTCMD)
InviteHelpAcceptQuestCmd = protobuf.Message(INVITEHELPACCEPTQUESTCMD)
JOY_ACTIVITY_ATF = 6
JOY_ACTIVITY_AUGURY = 7
JOY_ACTIVITY_BEATPORI = 9
JOY_ACTIVITY_FOOD = 4
JOY_ACTIVITY_GUESS = 1
JOY_ACTIVITY_MAX = 10
JOY_ACTIVITY_MIN = 0
JOY_ACTIVITY_MISCHIEF = 2
JOY_ACTIVITY_PHOTO = 8
JOY_ACTIVITY_QUESTION = 3
JOY_ACTIVITY_YOYO = 5
LeaveVisitNpcQuestCmd = protobuf.Message(LEAVEVISITNPCQUESTCMD)
MapStepFinishCmd = protobuf.Message(MAPSTEPFINISHCMD)
MapStepSyncCmd = protobuf.Message(MAPSTEPSYNCCMD)
MapStepUpdateCmd = protobuf.Message(MAPSTEPUPDATECMD)
NewEvidenceUpdateCmd = protobuf.Message(NEWEVIDENCEUPDATECMD)
OtherData = protobuf.Message(OTHERDATA)
PlotStatusNtf = protobuf.Message(PLOTSTATUSNTF)
QUESTPARAM_AREA_ACTION = 28
QUESTPARAM_BOTTLE_ACTION = 31
QUESTPARAM_BOTTLE_QUERY = 30
QUESTPARAM_BOTTLE_UPDATE = 32
QUESTPARAM_CANACCEPTLISTCHANGED = 10
QUESTPARAM_CLOSE_UI = 39
QUESTPARAM_COMPLETE_AVAILABLE_QUERY = 42
QUESTPARAM_ENLIGHT_SECRET = 38
QUESTPARAM_EVIDENCE_HINT = 37
QUESTPARAM_EVIDENCE_QUERY = 33
QUESTPARAM_HELP_ACCEPT_AGREE = 15
QUESTPARAM_HELP_ACCEPT_INVITE = 14
QUESTPARAM_HELP_QUICK_FINISH_BOARD = 19
QUESTPARAM_INVITE_ACCEPT_QUEST = 16
QUESTPARAM_LEAVE_VISIT_NPC = 41
QUESTPARAM_MAPSTEP_FINISH = 27
QUESTPARAM_MAPSTEP_SYNC = 25
QUESTPARAM_MAPSTEP_UPDATE = 26
QUESTPARAM_NEW_EVIDENCE_UPDATE = 40
QUESTPARAM_NEW_LIST = 46
QUESTPARAM_NEW_UPDATE = 47
QUESTPARAM_ONCE_REWARD_UPDATE = 52
QUESTPARAM_PLOT_STATUS_NTF = 29
QUESTPARAM_QUERYOTHERDATA = 12
QUESTPARAM_QUERYWANTEDINFO = 13
QUESTPARAM_QUERY_ABYSS_LIST = 54
QUESTPARAM_QUERY_CHARACTER_INFO = 35
QUESTPARAM_QUERY_QUESTLIST = 24
QUESTPARAM_QUERY_WORLD_QUEST = 17
QUESTPARAM_QUESTACTION = 3
QUESTPARAM_QUESTDETAILLIST = 7
QUESTPARAM_QUESTDETAILUPDATE = 8
QUESTPARAM_QUESTGROUP_TRACE = 18
QUESTPARAM_QUESTHERO_QUERY = 48
QUESTPARAM_QUESTHERO_UPDATE = 49
QUESTPARAM_QUESTLIST = 1
QUESTPARAM_QUESTRAIDCMD = 9
QUESTPARAM_QUESTSTEPUPDATE = 5
QUESTPARAM_QUESTTRACE = 6
QUESTPARAM_QUESTUPDATE = 2
QUESTPARAM_RUNQUESTSTEP = 4
QUESTPARAM_STATUS_SET = 50
QUESTPARAM_STORY_INDEX_UPDATE = 51
QUESTPARAM_SYNC_TREASURE_BOX_NUM = 53
QUESTPARAM_TRACE_LIST = 44
QUESTPARAM_TRACE_UPDATE = 45
QUESTPARAM_UNLOCK_EVIDENCE_MESSAGE = 34
QUESTPARAM_UPDATE_ABYSS_HELPCOUNT = 55
QUESTPARAM_VISIT_NPC = 11
QUESTPARAM_WORLD_COUNT_LIST = 43
QueryAbyssQuestListQuestCmd = protobuf.Message(QUERYABYSSQUESTLISTQUESTCMD)
QueryBottleInfoQuestCmd = protobuf.Message(QUERYBOTTLEINFOQUESTCMD)
QueryCharacterInfoCmd = protobuf.Message(QUERYCHARACTERINFOCMD)
QueryOtherData = protobuf.Message(QUERYOTHERDATA)
QueryQuestHeroQuestCmd = protobuf.Message(QUERYQUESTHEROQUESTCMD)
QueryQuestListQuestCmd = protobuf.Message(QUERYQUESTLISTQUESTCMD)
QueryWantedInfoQuestCmd = protobuf.Message(QUERYWANTEDINFOQUESTCMD)
QueryWorldQuestCmd = protobuf.Message(QUERYWORLDQUESTCMD)
QuestAction = protobuf.Message(QUESTACTION)
QuestAreaAction = protobuf.Message(QUESTAREAACTION)
QuestCanAcceptListChange = protobuf.Message(QUESTCANACCEPTLISTCHANGE)
QuestData = protobuf.Message(QUESTDATA)
QuestDetail = protobuf.Message(QUESTDETAIL)
QuestDetailList = protobuf.Message(QUESTDETAILLIST)
QuestDetailUpdate = protobuf.Message(QUESTDETAILUPDATE)
QuestGroupTraceQuestCmd = protobuf.Message(QUESTGROUPTRACEQUESTCMD)
QuestHero = protobuf.Message(QUESTHERO)
QuestList = protobuf.Message(QUESTLIST)
QuestPConfig = protobuf.Message(QUESTPCONFIG)
QuestPuzzle = protobuf.Message(QUESTPUZZLE)
QuestRaidCmd = protobuf.Message(QUESTRAIDCMD)
QuestStatus = protobuf.Message(QUESTSTATUS)
QuestStep = protobuf.Message(QUESTSTEP)
QuestStepUpdate = protobuf.Message(QUESTSTEPUPDATE)
QuestStoryIndex = protobuf.Message(QUESTSTORYINDEX)
QuestStoryItem = protobuf.Message(QUESTSTORYITEM)
QuestTrace = protobuf.Message(QUESTTRACE)
QuestUpdate = protobuf.Message(QUESTUPDATE)
QuestUpdateItem = protobuf.Message(QUESTUPDATEITEM)
RelationData = protobuf.Message(RELATIONDATA)
ReplyHelpAccelpQuestCmd = protobuf.Message(REPLYHELPACCELPQUESTCMD)
Reward = protobuf.Message(REWARD)
RunQuestStep = protobuf.Message(RUNQUESTSTEP)
SetQuestStatusQuestCmd = protobuf.Message(SETQUESTSTATUSQUESTCMD)
SyncTreasureBoxNumCmd = protobuf.Message(SYNCTREASUREBOXNUMCMD)
Trace = protobuf.Message(TRACE)
UnlockEvidenceMessageCmd = protobuf.Message(UNLOCKEVIDENCEMESSAGECMD)
UpdateAbyssHelpCountQuestCmd = protobuf.Message(UPDATEABYSSHELPCOUNTQUESTCMD)
UpdateOnceRewardQuestCmd = protobuf.Message(UPDATEONCEREWARDQUESTCMD)
UpdateQuestHeroQuestCmd = protobuf.Message(UPDATEQUESTHEROQUESTCMD)
UpdateQuestStoryIndexQuestCmd = protobuf.Message(UPDATEQUESTSTORYINDEXQUESTCMD)
VisitNpcUserCmd = protobuf.Message(VISITNPCUSERCMD)
WorldCountListQuestCmd = protobuf.Message(WORLDCOUNTLISTQUESTCMD)
WorldFinishCount = protobuf.Message(WORLDFINISHCOUNT)
WorldQuest = protobuf.Message(WORLDQUEST)
WorldTreasure = protobuf.Message(WORLDTREASURE)
