local protobuf = protobuf
autoImport("xCmd_pb")
local xCmd_pb = xCmd_pb
autoImport("ProtoCommon_pb")
local ProtoCommon_pb = ProtoCommon_pb
autoImport("ChatCmd_pb")
local ChatCmd_pb = ChatCmd_pb
autoImport("SceneItem_pb")
local SceneItem_pb = SceneItem_pb
autoImport("GuildCmd_pb")
local GuildCmd_pb = GuildCmd_pb
module("FuBenCmd_pb")
FUBENPARAM = protobuf.EnumDescriptor()
FUBENPARAM_TRACK_FUBEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FAIL_FUBEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_LEAVE_FUBEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUCCESS_FUBEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_WORLD_STAGE_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUB_STAGE_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_START_STAGE_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GET_REWARD_STAGE_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STAGE_STEP_STAR_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_JOIN_FUBEN_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MONSTER_COUNT_USER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FUBEN_STEP_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FUBEN_GOAL_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FUBEN_CLEAR_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_RAID_USER_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_RAID_GATE_OPT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_STOP_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_DANGER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_METALHP_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_CALM_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_RESTART_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_STATUS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_DATA_SYNC_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_DATA_UPDATE_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_NAME_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MVPBATTLE_SYNC_MVPINFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MVPBATTLE_BOSS_DIE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FUBEN_USERNUM_COUNT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_INFO_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_TOWERINFO_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_METALINFO_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_QUERY_TOWERINFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_REWARD_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_QUERY_USER_DATA_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MVPBATTLE_END_REPORT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SUPERGVG_METAL_DIE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_INVITE_SUMMON_DEADBOSS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_REPLY_SUMMON_DEADBOSS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_QUERY_RAID_TEAMPWS_USERINFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_END_REPORT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_SYNC_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_SELECT_MAGIC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_UPDATE_MAGIC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_UPDATE_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EXIT_RAID_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_BEGIN_FIRE_FUBENCMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMEXP_RAID_REPORT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMEXP_BUY_ITEM_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMEXP_SYNC_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_RELIVE_COUNT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_RAID_CHIP_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_RAID_QUERY_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMEXP_QUERY_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_RAID_STATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_KUMAMOTO_OPER_CMD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_FOURTH_QUERY_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_FOURTH_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAM_GROUP_FOURTH_GOOUTER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RAID_STAGE_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_THANKSGIVING_MONSTER_NUM_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OTHELLO_POINT_OCCUPY_POWER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OTHELLO_SYNC_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_QUERY_RAID_OTHELLO_USERINFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OTHELLO_END_REPORT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ROGUELIKE_SYNC_UNLOCKSCENES_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TRANSFERFIGHT_CHOOSE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TRANSFERFIGHT_RANK_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TRANSFERFIGHT_END_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_DATA_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_ITEM_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_ITEM_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_SHOP_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_QUEST_QUERY_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_GROUP_INFO_QUERY_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_RESULT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_BUILDING_HP_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_QUERY_UI_OPER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TWELVEPVP_USE_ITEM_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_INVITE_ROLL_RAID_REWARD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_REPLY_ROLL_RAID_REARD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMMEMBER_ROLL_PROCESS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_PRE_REPLY_ROLL_RAID_REARD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RELIVE_CD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_POS_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_REQ_ENTER_TOWERPRIVATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TOWERPRIVATE_LAYINFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TOWERPRIVATE_LAYER_COUNTDOWN_NTF_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FUBEN_RESULT_NTF_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ENDTIME_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RESULT_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_COMODO_PHASE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_COMODO_STAT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_TEAMPWS_STATE_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OBSERVER_FLASH_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OBSERVER_ATTACH_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OBSERVER_SELECT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OB_HPSP_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OB_PLAYER_OFFLINE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MULTI_BOSS_PHASE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_MULTI_BOSS_STAT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OB_CAMERA_MOVE_PREPARE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OB_CAMERA_MOVE_END_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RAID_KILL_NUM_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_PVE_PASS_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_POINT_STATE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_CONSTRUCT_BUILDING_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_LEVELUP_BUILDING_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_CANCEL_BUILDING_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_STATE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_USE_BUILDING_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_MORALE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_PVE_RAID_ACHIEVE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_QUICK_FINISH_CRACK_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_PICKUP_PVE_RAID_ACHIEVE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ADD_PVECARD_TIMES_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_PVECARD_OPENSTATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_QUICK_FINISH_PVERAID_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_PVECARD_DIFFTIMES_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_PERFECT_STATE_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_BOSS_SCENE_BOSS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RESET_RAID_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ELEMENT_RAID_STAT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_EMOTION_FACTORS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_VISIT_NPC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_UNLOCK_ROOMIDS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_MONSTER_COUNT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SKIL_ANIMATION_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_STAR_ARK_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_STAR_ARK_STATISTICS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OPEN_NTF_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_ROADBLOCK_CHANGE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_FIRE_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_COMBO_KILL_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_PLAYER_MODEL_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_PROFESSION_TIME_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_CAMP_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_ENTER_COUNT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_PASS_USER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_CHOOSE_CUR_PROFESSION_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_TRIPLE_FIGHTING_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_FULL_FIRE_STATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EBF_EVENT_DATA_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EBF_MISC_DATA_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_OCCUPY_POINT_DATA_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_QUERY_PVP_STAT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EBF_KICK_TIME_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EBF_CONTINUE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_EBF_EVENT_AREA_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ASTRAL_INFO_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_MVP_INFO_UPDATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_ASTRAL_PRAY_BRANCH_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_START_FIGHT_STATE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_GVG_FIGHT_POINT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_GVG_LEADER_POS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_SYNC_SCORE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_SYNC_SKILL_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_SYNC_AVAILABLE_UPGRADE_NUMBER_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_GET_SKILL_UPGRADE_OPTIONS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_RET_SKILL_UPGRADE_OPTIONS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_EXEC_SKILL_UPGRADE_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_SPACETIME_ILLUSION_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_SPACETIME_ILLUSION_EXP_LEVEL_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_REFRESH_SKILL_UPGRADE_OPTIONS_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_STI_DROP_SKILL_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FAIRY_TALE_RAID_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_RAID_START_FIGHT_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_GVG_DATE_BATTLE_INFO_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FAIRY_TALE_RAID_REWARD_SYNC_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_FAIRY_TALE_RAID_GET_REWARD_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_SYNC_MEMORY_EQUIP_REWARD_INFO_ENUM = protobuf.EnumValueDescriptor()
FUBENPARAM_CHOOSE_MEMORY_EQUIP_REWARD_INFO_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE = protobuf.EnumDescriptor()
ERAIDTYPE_ERAIDTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_FERRISWHEEL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_EXCHANGE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TOWER_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_LABORATORY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_EXCHANGEGALLERY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SEAL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_RAIDTEMP2_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_DOJO_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GUILD_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_RAIDTEMP4_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ITEMIMAGE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GUILDRAID_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GUILDFIRE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PVP_LLH_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PVP_SMZL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PVP_HLJS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_DATELAND_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PVP_POLLY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_WEDDING_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_DIVORCE_ROLLER_COASTER_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PVECARD_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MVPBATTLE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SUPERGVG_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ALTMAN_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TEAMPWS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TEAMEXP_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_THANATOS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_THANATOS_MID_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_HOUSE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_THANATOS_SCENE3_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_KUMAMOTO_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_THANATOS_FOURTH_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GARDEN_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_THANKSGIVING_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_HEADWEAR_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_OTHELLO_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SPRING_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ROGUELIKE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MONSTER_ANSWER_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MONSTER_PHOTO_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TRANSFERFIGHT_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TWELVE_PVP_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_DEADBOSS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_EINHERJAR_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_QTE_CHASING_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SLAYERS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ENDLESSTOWER_PRIVATE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_JANUARY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MAY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_COMODO_TEAM_RAID_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MANOR_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_DISNEY_MUSIC_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_HEART_LOCK_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_HEADWEARACTIVITY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_CRACK_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GVG_LOBBY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_PROFESSION_TRIAL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_BOSS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_EQUIP_UP_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ELEMENT_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_STAR_ARK_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_TRIPLE_PVP_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_COMMON_MATERIALS_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MEMORY_PALACE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ENDLESS_BATTLE_FIELD_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_HERO_JOURNEY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ASTRAL_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MEMORY_RAID_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_SPACETIME_ILLUSION_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_FAIRY_TALE_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_ABYSS_DRAGON_ENUM = protobuf.EnumValueDescriptor()
ERAIDTYPE_ERAIDTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EENDLESSPRIVATEMONSTERTYPE = protobuf.EnumDescriptor()
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_ADVANCE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE = protobuf.EnumDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_COMODO_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MULTIBOSS_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_HEADWEAR_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CARD_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ENDLESS_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_DEADBOSS_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_THANATOS_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ROGUELIKE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_ONE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TWO_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_THREE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FOUR_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FIVE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SIX_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SEVEN_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_EIGHT_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_NINE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TEN_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_GUILD_RAID_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_ONE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_TWO_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ELEMENT_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TORTOISE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_EQUIP_UP_RAID_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_THREE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FOUR_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FIVE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SIX_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SEVEN_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_STAR_ARK_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_EIGHT_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_COMMON_MATERIALS_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_PALACE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_NINE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_LIFE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_PASSION_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_SPACETIME_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_DEATH_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_THIRD_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_OTHERWORLD_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_SPACETIME_ILLUSION_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_FAIRY_TALE_ENUM = protobuf.EnumValueDescriptor()
EPVEGROUPTYPE_EPVEGROUPTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATESTATE = protobuf.EnumDescriptor()
EGUILDGATESTATE_EGUILDGATESTATE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATESTATE_EGUILDGATESTATE_LOCK_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATESTATE_EGUILDGATESTATE_CLOSE_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATESTATE_EGUILDGATESTATE_OPEN_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATEOPT = protobuf.EnumDescriptor()
EGUILDGATEOPT_EGUILDGATEOPT_UNLOCK_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATEOPT_EGUILDGATEOPT_ENTER_ENUM = protobuf.EnumValueDescriptor()
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENTER_ENUM = protobuf.EnumValueDescriptor()
EGVGPOINTSTATE = protobuf.EnumDescriptor()
EGVGPOINTSTATE_EGVGPOINT_STATE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGVGPOINTSTATE_EGVGPOINT_STATE_OCCUPIED_ENUM = protobuf.EnumValueDescriptor()
EGUILDFIRERESULT = protobuf.EnumDescriptor()
EGUILDFIRERESULT_EGUILDFIRERESULT_DEF_ENUM = protobuf.EnumValueDescriptor()
EGUILDFIRERESULT_EGUILDFIRERESULT_DEFSPEC_ENUM = protobuf.EnumValueDescriptor()
EGUILDFIRERESULT_EGUILDFIRERESULT_ATTACK_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE = protobuf.EnumDescriptor()
EGVGDATATYPE_EGVGDATA_MIN_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_PARTINTIME_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_KILLMON_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_RELIVE_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_EXPEL_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_DAMMETAL_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_KILLMETAL_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_KILLUSER_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_HONOR_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_OCCUPY_POINT_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_COIN_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_DEF_POINT_TIME_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_PARTIN_KILLMETAL_ENUM = protobuf.EnumValueDescriptor()
EGVGDATATYPE_EGVGDATA_DAM_MVP_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERSTATE = protobuf.EnumDescriptor()
EGVGTOWERSTATE_EGVGTOWERSTATE_INITFREE_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERSTATE_EGVGTOWERSTATE_OCCUPY_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERSTATE_EGVGTOWERSTATE_FREE_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERTYPE = protobuf.EnumDescriptor()
EGVGTOWERTYPE_EGVGTOWERTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERTYPE_EGVGTOWERTYPE_CORE_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERTYPE_EGVGTOWERTYPE_WEST_ENUM = protobuf.EnumValueDescriptor()
EGVGTOWERTYPE_EGVGTOWERTYPE_EAST_ENUM = protobuf.EnumValueDescriptor()
EDEADBOSSDIFFICULTY = protobuf.EnumDescriptor()
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_MIN_ENUM = protobuf.EnumValueDescriptor()
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_HARD_ENUM = protobuf.EnumValueDescriptor()
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_SUPER_ENUM = protobuf.EnumValueDescriptor()
ETEAMPWSCOLOR = protobuf.EnumDescriptor()
ETEAMPWSCOLOR_ETEAMPWS_MIN_ENUM = protobuf.EnumValueDescriptor()
ETEAMPWSCOLOR_ETEAMPWS_RED_ENUM = protobuf.EnumValueDescriptor()
ETEAMPWSCOLOR_ETEAMPWS_BLUE_ENUM = protobuf.EnumValueDescriptor()
EMAGICBALLTYPE = protobuf.EnumDescriptor()
EMAGICBALLTYPE_EMAGICBALL_MIN_ENUM = protobuf.EnumValueDescriptor()
EMAGICBALLTYPE_EMAGICBALL_WIND_ENUM = protobuf.EnumValueDescriptor()
EMAGICBALLTYPE_EMAGICBALL_EARTH_ENUM = protobuf.EnumValueDescriptor()
EMAGICBALLTYPE_EMAGICBALL_WATER_ENUM = protobuf.EnumValueDescriptor()
EMAGICBALLTYPE_EMAGICBALL_FIRE_ENUM = protobuf.EnumValueDescriptor()
EGROUPRAIDSCENESTATE = protobuf.EnumDescriptor()
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_FIRE_ENUM = protobuf.EnumValueDescriptor()
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_OVER_ENUM = protobuf.EnumValueDescriptor()
EKUMAMOTOOPER = protobuf.EnumDescriptor()
EKUMAMOTOOPER_EKUMAMOTOOPER_CREATE_ENUM = protobuf.EnumValueDescriptor()
EKUMAMOTOOPER_EKUMAMOTOOPER_REWARD_ENUM = protobuf.EnumValueDescriptor()
EKUMAMOTOOPER_EKUMAMOTOOPER_SCORE_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE = protobuf.EnumDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MIN_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_PVERAID_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GROUPRAID_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_WORLDBOSS_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_DEADBOSS_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GUILD_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_COMODO_TEAM_RAID_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_EQUIP_UP_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MVP_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MINI_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_PALACE_ENUM = protobuf.EnumValueDescriptor()
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_ENUM = protobuf.EnumValueDescriptor()
EGROUPCAMP = protobuf.EnumDescriptor()
EGROUPCAMP_EGROUPCAMP_MIN_ENUM = protobuf.EnumValueDescriptor()
EGROUPCAMP_EGROUPCAMP_RED_ENUM = protobuf.EnumValueDescriptor()
EGROUPCAMP_EGROUPCAMP_BLUE_ENUM = protobuf.EnumValueDescriptor()
EGROUPCAMP_EGROUPCAMP_OBSERVER_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE = protobuf.EnumDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MIN_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_EXP_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_GOLD_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAR_POINT_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PUSH_PLAYER_NUM_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_END_TIME_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_SHOP_CD_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAMP_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_BARRACK_HP_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_HP_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PVP_TYPE_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_LEVEL_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_KILL_NUM_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MAX_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPUI = protobuf.EnumDescriptor()
ETWELVEPVPUI_ETWELVEPVP_UI_MIN_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPUI_ETWELVEPVP_UI_CRYSTAL_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPUI_ETWELVEPVP_UI_SHOP_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_MIN_ENUM = protobuf.EnumValueDescriptor()
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_ITEM_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDBOSS = protobuf.EnumDescriptor()
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MIN_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_DRAGON_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_CHESS_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_HERO_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MAX_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDPHASE = protobuf.EnumDescriptor()
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_MIN_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_DRAGON_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_CHESS_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_HERO_ENUM = protobuf.EnumValueDescriptor()
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_SAVE_NPC_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE = protobuf.EnumDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_MIN_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_WEEKLY_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_FIRST_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_PROBABLY_ENUM = protobuf.EnumValueDescriptor()
EREWARDSHOWTYPE_EREWARD_SHOW_HEAD_WEAR_ENUM = protobuf.EnumValueDescriptor()
EGVGRAIDSTATE = protobuf.EnumDescriptor()
EGVGRAIDSTATE_EGVGRAIDSTATE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGVGRAIDSTATE_EGVGRAIDSTATE_PEACE_ENUM = protobuf.EnumValueDescriptor()
EGVGRAIDSTATE_EGVGRAIDSTATE_FIRE_ENUM = protobuf.EnumValueDescriptor()
EGVGRAIDSTATE_EGVGRAIDSTATE_CALM_ENUM = protobuf.EnumValueDescriptor()
EGVGRAIDSTATE_EGVGRAIDSTATE_PERFECT_ENUM = protobuf.EnumValueDescriptor()
EGVGCITYTYPE = protobuf.EnumDescriptor()
EGVGCITYTYPE_EGVGCITYTYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EGVGCITYTYPE_EGVGCITYTYPE_SMALL_ENUM = protobuf.EnumValueDescriptor()
EGVGCITYTYPE_EGVGCITYTYPE_MIDDLE_ENUM = protobuf.EnumValueDescriptor()
EGVGCITYTYPE_EGVGCITYTYPE_LARGE_ENUM = protobuf.EnumValueDescriptor()
EGVGCITYTYPE_EGVGCITYTYPE_MAX_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP = protobuf.EnumDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_MIN_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_RED_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_YELLOW_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_BLUE_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_GREEN_ENUM = protobuf.EnumValueDescriptor()
ETRIPLECAMP_ETRIPLE_CAMP_MAX_ENUM = protobuf.EnumValueDescriptor()
EEBFFIELDSTATE = protobuf.EnumDescriptor()
EEBFFIELDSTATE_EEBF_FIELD_WAITING_ENUM = protobuf.EnumValueDescriptor()
EEBFFIELDSTATE_EEBF_FIELD_EVENT_ENUM = protobuf.EnumValueDescriptor()
EEBFFIELDSTATE_EEBF_FIELD_FINAL_ENUM = protobuf.EnumValueDescriptor()
EFIGHTBARSTATE = protobuf.EnumDescriptor()
EFIGHTBARSTATE_EFIGHT_BAR_STATE_MIN_ENUM = protobuf.EnumValueDescriptor()
EFIGHTBARSTATE_EFIGHT_BAR_STATE_BEGIN_ENUM = protobuf.EnumValueDescriptor()
EFIGHTBARSTATE_EFIGHT_BAR_STATE_PAUSE_ENUM = protobuf.EnumValueDescriptor()
EFIGHTBARSTATE_EFIGHT_BAR_STATE_DEL_ENUM = protobuf.EnumValueDescriptor()
EFAIRYTALEWAVETYPE = protobuf.EnumDescriptor()
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MIN_ENUM = protobuf.EnumValueDescriptor()
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_NORMAL_ENUM = protobuf.EnumValueDescriptor()
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MINI_ENUM = protobuf.EnumValueDescriptor()
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MVP_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE = protobuf.EnumDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MIN_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_UP_LEVEL_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_TO_BREAK_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_LEVEL_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_BREAK_ENUM = protobuf.EnumValueDescriptor()
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_EMPTY_ENUM = protobuf.EnumValueDescriptor()
TRACKDATA = protobuf.Descriptor()
TRACKDATA_STAR_FIELD = protobuf.FieldDescriptor()
TRACKDATA_ID_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG = protobuf.Descriptor()
RAIDPCONFIG_RAIDID_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_STARID_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_AUTO_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_WHETHERTRACE_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_FINISHJUMP_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_FAILJUMP_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_SUBSTEP_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_DESCINFO_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_CONTENT_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_TRACEINFO_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_PARAMS_FIELD = protobuf.FieldDescriptor()
RAIDPCONFIG_EXTRAJUMP_FIELD = protobuf.FieldDescriptor()
TRACKFUBENUSERCMD = protobuf.Descriptor()
TRACKFUBENUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
TRACKFUBENUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TRACKFUBENUSERCMD_DATA_FIELD = protobuf.FieldDescriptor()
TRACKFUBENUSERCMD_DMAPID_FIELD = protobuf.FieldDescriptor()
TRACKFUBENUSERCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
FAILFUBENUSERCMD = protobuf.Descriptor()
FAILFUBENUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
FAILFUBENUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LEAVEFUBENUSERCMD = protobuf.Descriptor()
LEAVEFUBENUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
LEAVEFUBENUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
LEAVEFUBENUSERCMD_MAPID_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD = protobuf.Descriptor()
SUCCESSFUBENUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_PARAM1_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_PARAM2_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_PARAM3_FIELD = protobuf.FieldDescriptor()
SUCCESSFUBENUSERCMD_PARAM4_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEITEM = protobuf.Descriptor()
WORLDSTAGEITEM_ID_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEITEM_STAR_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEITEM_GETLIST_FIELD = protobuf.FieldDescriptor()
STAGESTEPITEM = protobuf.Descriptor()
STAGESTEPITEM_STAGEID_FIELD = protobuf.FieldDescriptor()
STAGESTEPITEM_STEPID_FIELD = protobuf.FieldDescriptor()
STAGESTEPITEM_TYPE_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEUSERCMD = protobuf.Descriptor()
WORLDSTAGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEUSERCMD_LIST_FIELD = protobuf.FieldDescriptor()
WORLDSTAGEUSERCMD_CURINFO_FIELD = protobuf.FieldDescriptor()
STAGENORMALSTEPITEM = protobuf.Descriptor()
STAGENORMALSTEPITEM_STEPID_FIELD = protobuf.FieldDescriptor()
STAGENORMALSTEPITEM_STAR_FIELD = protobuf.FieldDescriptor()
STAGEHARDSTEPITEM = protobuf.Descriptor()
STAGEHARDSTEPITEM_STEPID_FIELD = protobuf.FieldDescriptor()
STAGEHARDSTEPITEM_FINISH_FIELD = protobuf.FieldDescriptor()
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD = protobuf.FieldDescriptor()
STAGESTEPUSERCMD = protobuf.Descriptor()
STAGESTEPUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
STAGESTEPUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STAGESTEPUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
STAGESTEPUSERCMD_NORMALIST_FIELD = protobuf.FieldDescriptor()
STAGESTEPUSERCMD_HARDLIST_FIELD = protobuf.FieldDescriptor()
STARTSTAGEUSERCMD = protobuf.Descriptor()
STARTSTAGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
STARTSTAGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STARTSTAGEUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
STARTSTAGEUSERCMD_STEPID_FIELD = protobuf.FieldDescriptor()
STARTSTAGEUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
GETREWARDSTAGEUSERCMD = protobuf.Descriptor()
GETREWARDSTAGEUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GETREWARDSTAGEUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GETREWARDSTAGEUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
GETREWARDSTAGEUSERCMD_STARID_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD = protobuf.Descriptor()
STAGESTEPSTARUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD_STAGEID_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD_STEPID_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD_STAR_FIELD = protobuf.FieldDescriptor()
STAGESTEPSTARUSERCMD_TYPE_FIELD = protobuf.FieldDescriptor()
MONSTERCOUNTUSERCMD = protobuf.Descriptor()
MONSTERCOUNTUSERCMD_CMD_FIELD = protobuf.FieldDescriptor()
MONSTERCOUNTUSERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MONSTERCOUNTUSERCMD_NUM_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD = protobuf.Descriptor()
FUBENSTEPSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_ID_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_DEL_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_GROUPID_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_CONFIG_FIELD = protobuf.FieldDescriptor()
FUBENSTEPSYNCCMD_UNIQUEID_FIELD = protobuf.FieldDescriptor()
FUBENPROGRESSSYNCCMD = protobuf.Descriptor()
FUBENPROGRESSSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
FUBENPROGRESSSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FUBENPROGRESSSYNCCMD_ID_FIELD = protobuf.FieldDescriptor()
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD = protobuf.FieldDescriptor()
FUBENPROGRESSSYNCCMD_STARID_FIELD = protobuf.FieldDescriptor()
FUBENCLEARINFOCMD = protobuf.Descriptor()
FUBENCLEARINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
FUBENCLEARINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA = protobuf.Descriptor()
GUILDGATEDATA_GATENPCID_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_KILLEDBOSSNUM_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_GROUPINDEX_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_CLOSETIME_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_LEVEL_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_ISSPECIAL_FIELD = protobuf.FieldDescriptor()
GUILDGATEDATA_STATE_FIELD = protobuf.FieldDescriptor()
USERGUILDRAIDFUBENCMD = protobuf.Descriptor()
USERGUILDRAIDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
USERGUILDRAIDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD = protobuf.FieldDescriptor()
GUILDGATEOPTCMD = protobuf.Descriptor()
GUILDGATEOPTCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDGATEOPTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDGATEOPTCMD_GATENPCID_FIELD = protobuf.FieldDescriptor()
GUILDGATEOPTCMD_OPT_FIELD = protobuf.FieldDescriptor()
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO = protobuf.Descriptor()
GVGPOINTINFO_POINTID_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_STATE_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_GUILDID_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_PER_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_GUILDNAME_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_GUILDPORTRAIT_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_SCORE_FIELD = protobuf.FieldDescriptor()
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD = protobuf.Descriptor()
GUILDFIREINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_POINTS_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_PERFECT_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD = protobuf.FieldDescriptor()
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTOPFUBENCMD = protobuf.Descriptor()
GUILDFIRESTOPFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTOPFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTOPFUBENCMD_RESULT_FIELD = protobuf.FieldDescriptor()
GUILDFIREDANGERFUBENCMD = protobuf.Descriptor()
GUILDFIREDANGERFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIREDANGERFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIREDANGERFUBENCMD_DANGER_FIELD = protobuf.FieldDescriptor()
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD = protobuf.FieldDescriptor()
GUILDFIREMETALHPFUBENCMD = protobuf.Descriptor()
GUILDFIREMETALHPFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD = protobuf.FieldDescriptor()
GUILDFIREMETALHPFUBENCMD_GOD_FIELD = protobuf.FieldDescriptor()
GUILDFIRECALMFUBENCMD = protobuf.Descriptor()
GUILDFIRECALMFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIRECALMFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIRECALMFUBENCMD_CALM_FIELD = protobuf.FieldDescriptor()
GUILDFIRENEWDEFFUBENCMD = protobuf.Descriptor()
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD = protobuf.FieldDescriptor()
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD = protobuf.FieldDescriptor()
GUILDFIRERESTARTFUBENCMD = protobuf.Descriptor()
GUILDFIRERESTARTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD = protobuf.Descriptor()
GUILDFIRESTATUSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD = protobuf.FieldDescriptor()
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD = protobuf.FieldDescriptor()
GVGDATA = protobuf.Descriptor()
GVGDATA_TYPE_FIELD = protobuf.FieldDescriptor()
GVGDATA_VALUE_FIELD = protobuf.FieldDescriptor()
GVGDATASYNCCMD = protobuf.Descriptor()
GVGDATASYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGDATASYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGDATASYNCCMD_DATAS_FIELD = protobuf.FieldDescriptor()
GVGDATASYNCCMD_CITYTYPE_FIELD = protobuf.FieldDescriptor()
GVGDATAUPDATECMD = protobuf.Descriptor()
GVGDATAUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGDATAUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGDATAUPDATECMD_DATA_FIELD = protobuf.FieldDescriptor()
GVGDEFNAMECHANGEFUBENCMD = protobuf.Descriptor()
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD = protobuf.FieldDescriptor()
SYNCMVPINFOFUBENCMD = protobuf.Descriptor()
SYNCMVPINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCMVPINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCMVPINFOFUBENCMD_USERNUM_FIELD = protobuf.FieldDescriptor()
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD = protobuf.FieldDescriptor()
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD = protobuf.FieldDescriptor()
BOSSDIEFUBENCMD = protobuf.Descriptor()
BOSSDIEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
BOSSDIEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BOSSDIEFUBENCMD_NPCID_FIELD = protobuf.FieldDescriptor()
UPDATEUSERNUMFUBENCMD = protobuf.Descriptor()
UPDATEUSERNUMFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEUSERNUMFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD = protobuf.FieldDescriptor()
GVGTOWERVALUE = protobuf.Descriptor()
GVGTOWERVALUE_GUILDID_FIELD = protobuf.FieldDescriptor()
GVGTOWERVALUE_VALUE_FIELD = protobuf.FieldDescriptor()
GVGTOWERDATA = protobuf.Descriptor()
GVGTOWERDATA_ETYPE_FIELD = protobuf.FieldDescriptor()
GVGTOWERDATA_ESTATE_FIELD = protobuf.FieldDescriptor()
GVGTOWERDATA_OWNER_GUILD_FIELD = protobuf.FieldDescriptor()
GVGTOWERDATA_INFO_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALINFO = protobuf.Descriptor()
GVGCRYSTALINFO_RANK_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALINFO_GUILDID_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALINFO_CRYSTALNUM_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALINFO_CHIPNUM_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO = protobuf.Descriptor()
GVGGUILDINFO_INDEX_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO_GUILDID_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO_GUILDNAME_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO_ICON_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO_METAL_LIVE_FIELD = protobuf.FieldDescriptor()
GVGGUILDINFO_CRYSTAL_FIELD = protobuf.FieldDescriptor()
SUPERGVGSYNCFUBENCMD = protobuf.Descriptor()
SUPERGVGSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SUPERGVGSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD = protobuf.FieldDescriptor()
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD = protobuf.FieldDescriptor()
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD = protobuf.FieldDescriptor()
GVGTOWERUPDATEFUBENCMD = protobuf.Descriptor()
GVGTOWERUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD = protobuf.FieldDescriptor()
GVGMETALDIEFUBENCMD = protobuf.Descriptor()
GVGMETALDIEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGMETALDIEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGMETALDIEFUBENCMD_INDEX_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALUPDATEFUBENCMD = protobuf.Descriptor()
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD = protobuf.FieldDescriptor()
QUERYGVGTOWERINFOFUBENCMD = protobuf.Descriptor()
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD = protobuf.FieldDescriptor()
REWARDITEMDATA = protobuf.Descriptor()
REWARDITEMDATA_ITEMID_FIELD = protobuf.FieldDescriptor()
REWARDITEMDATA_COUNT_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDDATA = protobuf.Descriptor()
SUPERGVGREWARDDATA_GUILDID_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDDATA_RANK_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDDATA_ITEMS_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDINFOFUBENCMD = protobuf.Descriptor()
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD = protobuf.FieldDescriptor()
SUPERGVGQUERYUSERDATAFUBENCMD = protobuf.Descriptor()
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD = protobuf.FieldDescriptor()
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA = protobuf.Descriptor()
MVPBATTLETEAMDATA_TEAMID_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA_TEAMNAME_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA_KILLMVPS_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA_KILLMINIS_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD = protobuf.FieldDescriptor()
MVPBATTLETEAMDATA_DEADBOSS_FIELD = protobuf.FieldDescriptor()
MVPBATTLEREPORTFUBENCMD = protobuf.Descriptor()
MVPBATTLEREPORTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD = protobuf.FieldDescriptor()
INVITESUMMONBOSSFUBENCMD = protobuf.Descriptor()
INVITESUMMONBOSSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD = protobuf.FieldDescriptor()
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD = protobuf.FieldDescriptor()
REPLYSUMMONBOSSFUBENCMD = protobuf.Descriptor()
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD = protobuf.FieldDescriptor()
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD = protobuf.FieldDescriptor()
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO = protobuf.Descriptor()
TEAMPWSRAIDUSERINFO_CHARID_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_NAME_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_HEAL_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_DIENUM_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDTEAMINFO = protobuf.Descriptor()
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDTEAMINFO_COLOR_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD = protobuf.FieldDescriptor()
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD = protobuf.FieldDescriptor()
QUERYTEAMPWSUSERINFOFUBENCMD = protobuf.Descriptor()
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
TEAMPWSREPORTFUBENCMD = protobuf.Descriptor()
TEAMPWSREPORTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMPWSREPORTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD = protobuf.FieldDescriptor()
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA = protobuf.Descriptor()
TEAMPWSINFOSYNCDATA_TEAMID_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_COLOR_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_SCORE_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_MAGICID_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_BALLS_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCFUBENCMD = protobuf.Descriptor()
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD = protobuf.FieldDescriptor()
UPDATETEAMPWSINFOFUBENCMD = protobuf.Descriptor()
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
SELECTTEAMPWSMAGICFUBENCMD = protobuf.Descriptor()
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD = protobuf.FieldDescriptor()
EXITMAPFUBENCMD = protobuf.Descriptor()
EXITMAPFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
EXITMAPFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BEGINFIREFUBENCMD = protobuf.Descriptor()
BEGINFIREFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
BEGINFIREFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD = protobuf.Descriptor()
TEAMEXPREPORTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD = protobuf.FieldDescriptor()
BUYEXPRAIDITEMFUBENCMD = protobuf.Descriptor()
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD = protobuf.FieldDescriptor()
TEAMEXPSYNCFUBENCMD = protobuf.Descriptor()
TEAMEXPSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMEXPSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
TEAMRELIVECOUNTFUBENCMD = protobuf.Descriptor()
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD = protobuf.FieldDescriptor()
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD = protobuf.FieldDescriptor()
TEAMGROUPRAIDUPDATECHIPNUM = protobuf.Descriptor()
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD = protobuf.FieldDescriptor()
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA = protobuf.Descriptor()
GROUPRAIDSHOWDATA_CHARID_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_PROFESSION_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_NAME_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_DAMAGE_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_HEAL_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_DIENUM_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSHOWDATA_HATETIME_FIELD = protobuf.FieldDescriptor()
GROUPRAIDTEAMSHOWDATA = protobuf.Descriptor()
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD = protobuf.FieldDescriptor()
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD = protobuf.FieldDescriptor()
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD = protobuf.FieldDescriptor()
QUERYTEAMGROUPRAIDUSERINFO = protobuf.Descriptor()
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD = protobuf.FieldDescriptor()
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD = protobuf.FieldDescriptor()
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSTATESYNCFUBENCMD = protobuf.Descriptor()
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD = protobuf.FieldDescriptor()
TEAMEXPQUERYINFOFUBENCMD = protobuf.Descriptor()
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD = protobuf.FieldDescriptor()
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD = protobuf.FieldDescriptor()
GROUPRAIDFOURTHSHOWDATA = protobuf.Descriptor()
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD = protobuf.FieldDescriptor()
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD = protobuf.FieldDescriptor()
UPDATEGROUPRAIDFOURTHSHOWDATA = protobuf.Descriptor()
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD = protobuf.FieldDescriptor()
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD = protobuf.FieldDescriptor()
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD = protobuf.FieldDescriptor()
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD = protobuf.FieldDescriptor()
QUERYGROUPRAIDFOURTHSHOWDATA = protobuf.Descriptor()
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD = protobuf.FieldDescriptor()
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD = protobuf.FieldDescriptor()
GROUPRAIDFOURTHGOOUTERCMD = protobuf.Descriptor()
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD = protobuf.FieldDescriptor()
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD = protobuf.FieldDescriptor()
RAIDSTAGESYNCFUBENCMD = protobuf.Descriptor()
RAIDSTAGESYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD = protobuf.FieldDescriptor()
THANKSGIVINGMONSTERFUBENCMD = protobuf.Descriptor()
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD = protobuf.FieldDescriptor()
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD = protobuf.FieldDescriptor()
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD = protobuf.FieldDescriptor()
KUMAMOTOOPERFUBENCMD = protobuf.Descriptor()
KUMAMOTOOPERFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
KUMAMOTOOPERFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KUMAMOTOOPERFUBENCMD_TYPE_FIELD = protobuf.FieldDescriptor()
KUMAMOTOOPERFUBENCMD_VALUE_FIELD = protobuf.FieldDescriptor()
OTHELLOOCCUPYITEM = protobuf.Descriptor()
OTHELLOOCCUPYITEM_POINTID_FIELD = protobuf.FieldDescriptor()
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD = protobuf.FieldDescriptor()
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD = protobuf.FieldDescriptor()
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD = protobuf.FieldDescriptor()
OTHELLOPOINTOCCUPYPOWERFUBENCMD = protobuf.Descriptor()
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCDATA = protobuf.Descriptor()
OTHELLOINFOSYNCDATA_TEAMID_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCDATA_COLOR_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCDATA_SCORE_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCFUBENCMD = protobuf.Descriptor()
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO = protobuf.Descriptor()
OTHELLORAIDUSERINFO_CHARID_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_NAME_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_PROFESSION_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_KILLNUM_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_DIENUM_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_HEAL_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_KILLSCORE_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDUSERINFO_HIDENAME_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDTEAMINFO = protobuf.Descriptor()
OTHELLORAIDTEAMINFO_TEAMID_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDTEAMINFO_COLOR_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDTEAMINFO_AVESCORE_FIELD = protobuf.FieldDescriptor()
OTHELLORAIDTEAMINFO_USERINFOS_FIELD = protobuf.FieldDescriptor()
QUERYOTHELLOUSERINFOFUBENCMD = protobuf.Descriptor()
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
OTHELLOREPORTFUBENCMD = protobuf.Descriptor()
OTHELLOREPORTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OTHELLOREPORTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD = protobuf.FieldDescriptor()
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD = protobuf.FieldDescriptor()
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD = protobuf.FieldDescriptor()
ROGUELIKEUNLOCKSCENESYNC = protobuf.Descriptor()
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD = protobuf.FieldDescriptor()
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD = protobuf.FieldDescriptor()
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTCHOOSEFUBENCMD = protobuf.Descriptor()
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD = protobuf.FieldDescriptor()
RANKSCORE = protobuf.Descriptor()
RANKSCORE_RANK_FIELD = protobuf.FieldDescriptor()
RANKSCORE_SCORE_FIELD = protobuf.FieldDescriptor()
RANKSCORE_NAME_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTRANKFUBENCMD = protobuf.Descriptor()
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTENDFUBENCMD = protobuf.Descriptor()
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD = protobuf.FieldDescriptor()
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD = protobuf.Descriptor()
INVITEROLLREWARDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD = protobuf.FieldDescriptor()
INVITEROLLREWARDFUBENCMD_COUNT_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD = protobuf.Descriptor()
REPLYROLLREWARDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD_AGREE_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD = protobuf.FieldDescriptor()
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD = protobuf.FieldDescriptor()
TEAMROLLSTATUSFUBENCMD = protobuf.Descriptor()
TEAMROLLSTATUSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD = protobuf.FieldDescriptor()
TEAMROLLSTATUSFUBENCMD_DELID_FIELD = protobuf.FieldDescriptor()
PREREPLYROLLREWARDFUBENCMD = protobuf.Descriptor()
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD = protobuf.FieldDescriptor()
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD = protobuf.FieldDescriptor()
TWELVEPVPDATA = protobuf.Descriptor()
TWELVEPVPDATA_TYPE_FIELD = protobuf.FieldDescriptor()
TWELVEPVPDATA_VALUE_FIELD = protobuf.FieldDescriptor()
TWELVEPVPSYNCCMD = protobuf.Descriptor()
TWELVEPVPSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPSYNCCMD_DATAS_FIELD = protobuf.FieldDescriptor()
TWELVEPVPSYNCCMD_CAMP_FIELD = protobuf.FieldDescriptor()
TWELVEPVPSYNCCMD_CHARID_FIELD = protobuf.FieldDescriptor()
TWEITEMINFO = protobuf.Descriptor()
TWEITEMINFO_ITEMID_FIELD = protobuf.FieldDescriptor()
TWEITEMINFO_COUNT_FIELD = protobuf.FieldDescriptor()
RAIDITEMSYNCCMD = protobuf.Descriptor()
RAIDITEMSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDITEMSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RAIDITEMSYNCCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
RAIDITEMSYNCCMD_CHARID_FIELD = protobuf.FieldDescriptor()
RAIDITEMUPDATECMD = protobuf.Descriptor()
RAIDITEMUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDITEMUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
RAIDITEMUPDATECMD_ITEMID_FIELD = protobuf.FieldDescriptor()
RAIDITEMUPDATECMD_COUNT_FIELD = protobuf.FieldDescriptor()
RAIDITEMUPDATECMD_CHARID_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSEITEMCMD = protobuf.Descriptor()
TWELVEPVPUSEITEMCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSEITEMCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSEITEMCMD_ITEMID_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSEITEMCMD_COUNT_FIELD = protobuf.FieldDescriptor()
RAIDSHOPUPDATECMD = protobuf.Descriptor()
RAIDSHOPUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDSHOPUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD = protobuf.FieldDescriptor()
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTDATA = protobuf.Descriptor()
TWELVEPVPQUESTDATA_QUESTID_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTDATA_PROGRESS_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTDATA_FINISHED_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTQUERYCMD = protobuf.Descriptor()
TWELVEPVPQUESTQUERYCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO = protobuf.Descriptor()
TWELVEPVPUSERINFO_CHARID_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_NAME_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_KILLNUM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_DIENUM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_HEAL_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_GOLD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_PUSH_TIME_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_KILL_MVP_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_PROFESSION_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUSERINFO_HIDENAME_FIELD = protobuf.FieldDescriptor()
TWELVEPVPGROUPINFO = protobuf.Descriptor()
TWELVEPVPGROUPINFO_COLOR_FIELD = protobuf.FieldDescriptor()
TWELVEPVPGROUPINFO_USERINFOS_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUERYGROUPINFOCMD = protobuf.Descriptor()
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD = protobuf.FieldDescriptor()
CAMPRESULTDATA = protobuf.Descriptor()
CAMPRESULTDATA_CAMP_FIELD = protobuf.FieldDescriptor()
CAMPRESULTDATA_KILL_NUM_FIELD = protobuf.FieldDescriptor()
CAMPRESULTDATA_EXP_FIELD = protobuf.FieldDescriptor()
CAMPRESULTDATA_KILL_MVP_FIELD = protobuf.FieldDescriptor()
TWELVEPVPRESULTCMD = protobuf.Descriptor()
TWELVEPVPRESULTCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPRESULTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPRESULTCMD_WINTEAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD = protobuf.FieldDescriptor()
BUILDINGHP = protobuf.Descriptor()
BUILDINGHP_BUILDING_ID_FIELD = protobuf.FieldDescriptor()
BUILDINGHP_HP_PER_FIELD = protobuf.FieldDescriptor()
TWELVEPVPBUILDINGHPUPDATECMD = protobuf.Descriptor()
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUIOPERCMD = protobuf.Descriptor()
TWELVEPVPUIOPERCMD_CMD_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUIOPERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUIOPERCMD_UI_FIELD = protobuf.FieldDescriptor()
TWELVEPVPUIOPERCMD_OPEN_FIELD = protobuf.FieldDescriptor()
RELIVECDFUBENCMD = protobuf.Descriptor()
RELIVECDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
RELIVECDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD = protobuf.FieldDescriptor()
POSDATA = protobuf.Descriptor()
POSDATA_ID_FIELD = protobuf.FieldDescriptor()
POSDATA_POS_FIELD = protobuf.FieldDescriptor()
POSDATA_NPCID_FIELD = protobuf.FieldDescriptor()
POSDATA_CAMP_FIELD = protobuf.FieldDescriptor()
POSSYNCFUBENCMD = protobuf.Descriptor()
POSSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
POSSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
POSSYNCFUBENCMD_DATAS_FIELD = protobuf.FieldDescriptor()
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD = protobuf.FieldDescriptor()
REQENTERTOWERPRIVATE = protobuf.Descriptor()
REQENTERTOWERPRIVATE_CMD_FIELD = protobuf.FieldDescriptor()
REQENTERTOWERPRIVATE_PARAM_FIELD = protobuf.FieldDescriptor()
REQENTERTOWERPRIVATE_RAIDID_FIELD = protobuf.FieldDescriptor()
LAYERMONSTERTOWERPRIVATE = protobuf.Descriptor()
LAYERMONSTERTOWERPRIVATE_ID_FIELD = protobuf.FieldDescriptor()
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD = protobuf.FieldDescriptor()
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD = protobuf.FieldDescriptor()
LAYERMONSTERTOWERPRIVATE_ICON_FIELD = protobuf.FieldDescriptor()
LAYERREWARDTOWERPRIVATE = protobuf.Descriptor()
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD = protobuf.FieldDescriptor()
LAYERREWARDTOWERPRIVATE_COUNT_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO = protobuf.Descriptor()
TOWERPRIVATELAYERINFO_CMD_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO_PARAM_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO_RAIDID_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO_LAYER_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO_MONSTERS_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERINFO_REWARDS_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERCOUNTDOWNNTF = protobuf.Descriptor()
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD = protobuf.FieldDescriptor()
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD = protobuf.FieldDescriptor()
FUBENRESULTNTF = protobuf.Descriptor()
FUBENRESULTNTF_CMD_FIELD = protobuf.FieldDescriptor()
FUBENRESULTNTF_PARAM_FIELD = protobuf.FieldDescriptor()
FUBENRESULTNTF_RAIDTYPE_FIELD = protobuf.FieldDescriptor()
FUBENRESULTNTF_ISWIN_FIELD = protobuf.FieldDescriptor()
ENDTIMESYNCFUBENCMD = protobuf.Descriptor()
ENDTIMESYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
ENDTIMESYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
RESULTSYNCFUBENCMD = protobuf.Descriptor()
RESULTSYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
RESULTSYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RESULTSYNCFUBENCMD_SCORE_FIELD = protobuf.FieldDescriptor()
COMODOPHASEFUBENCMD = protobuf.Descriptor()
COMODOPHASEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
COMODOPHASEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
COMODOPHASEFUBENCMD_PHASE_FIELD = protobuf.FieldDescriptor()
COMODOTEAMRAIDSTATDATA = protobuf.Descriptor()
COMODOTEAMRAIDSTATDATA_BOSS_FIELD = protobuf.FieldDescriptor()
COMODOTEAMRAIDSTATDATA_DATAS_FIELD = protobuf.FieldDescriptor()
QUERYCOMODOTEAMRAIDSTAT = protobuf.Descriptor()
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD = protobuf.FieldDescriptor()
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD = protobuf.FieldDescriptor()
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD = protobuf.FieldDescriptor()
TEAMPWSSTATESYNCFUBENCMD = protobuf.Descriptor()
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD = protobuf.FieldDescriptor()
OBSERVERFLASHFUBENCMD = protobuf.Descriptor()
OBSERVERFLASHFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBSERVERFLASHFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBSERVERFLASHFUBENCMD_X_FIELD = protobuf.FieldDescriptor()
OBSERVERFLASHFUBENCMD_Y_FIELD = protobuf.FieldDescriptor()
OBSERVERFLASHFUBENCMD_Z_FIELD = protobuf.FieldDescriptor()
OBSERVERATTACHFUBENCMD = protobuf.Descriptor()
OBSERVERATTACHFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBSERVERATTACHFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD = protobuf.FieldDescriptor()
OBSERVERSELECTFUBENCMD = protobuf.Descriptor()
OBSERVERSELECTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBSERVERSELECTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD = protobuf.FieldDescriptor()
PLAYERHPSPUPDATE = protobuf.Descriptor()
PLAYERHPSPUPDATE_CHARID_FIELD = protobuf.FieldDescriptor()
PLAYERHPSPUPDATE_HPPER_FIELD = protobuf.FieldDescriptor()
PLAYERHPSPUPDATE_SPPER_FIELD = protobuf.FieldDescriptor()
OBHPSPUPDATEFUBENCMD = protobuf.Descriptor()
OBHPSPUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBHPSPUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD = protobuf.FieldDescriptor()
OBPLAYEROFFLINEFUBENCMD = protobuf.Descriptor()
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD = protobuf.FieldDescriptor()
MULTIBOSSPHASEFUBENCMD = protobuf.Descriptor()
MULTIBOSSPHASEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD = protobuf.FieldDescriptor()
MULTIBOSSRAIDSTATDATA = protobuf.Descriptor()
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD = protobuf.FieldDescriptor()
MULTIBOSSRAIDSTATDATA_DATAS_FIELD = protobuf.FieldDescriptor()
ACHIEVEREWARD = protobuf.Descriptor()
ACHIEVEREWARD_ACHIEVEID_FIELD = protobuf.FieldDescriptor()
ACHIEVEREWARD_PICK_FIELD = protobuf.FieldDescriptor()
PVERAIDACHIEVE = protobuf.Descriptor()
PVERAIDACHIEVE_GROUPID_FIELD = protobuf.FieldDescriptor()
PVERAIDACHIEVE_ACHIEVEIDS_FIELD = protobuf.FieldDescriptor()
QUERYMULTIBOSSRAIDSTAT = protobuf.Descriptor()
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD = protobuf.FieldDescriptor()
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD = protobuf.FieldDescriptor()
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD = protobuf.FieldDescriptor()
BOSSSCENEINFO = protobuf.Descriptor()
BOSSSCENEINFO_BOSSID_FIELD = protobuf.FieldDescriptor()
BOSSSCENEINFO_RANDREWARDID_FIELD = protobuf.FieldDescriptor()
BOSSSCENEINFO_RANDNOREWARDID_FIELD = protobuf.FieldDescriptor()
BOSSSCENEINFO_SHOWREWARDS_FIELD = protobuf.FieldDescriptor()
PVEPASSSHOWREWARD = protobuf.Descriptor()
PVEPASSSHOWREWARD_SHOWTYPE_FIELD = protobuf.FieldDescriptor()
PVEPASSSHOWREWARD_ITEM_FIELD = protobuf.FieldDescriptor()
PVEPASSSHOWREWARD_REWARDIDS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO = protobuf.Descriptor()
PVEPASSINFO_ID_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_FIRSTPASS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_PASSTIME_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_OPEN_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_QUICK_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_PICKUP_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_NORLENFIRST_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_PASS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_BOSSINFO_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_SHOWBOSSIDS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_SHOWREWARDS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_RESET_TIME_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_KILL_BOSS_NUM_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_MVP_REST_TIME_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_MINI_REST_TIME_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_GRADE_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_FREE_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_STARS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_ACC_PASS_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_NO_SHOW_LABEL_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_ACT_END_TIME_FIELD = protobuf.FieldDescriptor()
PVEPASSINFO_AFFIXIDS_FIELD = protobuf.FieldDescriptor()
OBMOVECAMERAPREPARECMD = protobuf.Descriptor()
OBMOVECAMERAPREPARECMD_CMD_FIELD = protobuf.FieldDescriptor()
OBMOVECAMERAPREPARECMD_PARAM_FIELD = protobuf.FieldDescriptor()
OBCAMERAMOVEENDCMD = protobuf.Descriptor()
OBCAMERAMOVEENDCMD_CMD_FIELD = protobuf.FieldDescriptor()
OBCAMERAMOVEENDCMD_PARAM_FIELD = protobuf.FieldDescriptor()
KILLNUM = protobuf.Descriptor()
KILLNUM_CAMP_FIELD = protobuf.FieldDescriptor()
KILLNUM_KILL_NUM_FIELD = protobuf.FieldDescriptor()
RAIDKILLNUMSYNCCMD = protobuf.Descriptor()
RAIDKILLNUMSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDKILLNUMSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD = protobuf.FieldDescriptor()
LASTBOSSSCENEINFO = protobuf.Descriptor()
LASTBOSSSCENEINFO_ID_FIELD = protobuf.FieldDescriptor()
LASTBOSSSCENEINFO_BOSSID_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD = protobuf.Descriptor()
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD = protobuf.FieldDescriptor()
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD = protobuf.FieldDescriptor()
SYNCPVERAIDACHIEVEFUBENCMD = protobuf.Descriptor()
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD = protobuf.FieldDescriptor()
QUICKFINISHCRACKRAIDFUBENCMD = protobuf.Descriptor()
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD = protobuf.FieldDescriptor()
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD = protobuf.FieldDescriptor()
PICKUPPVERAIDACHIEVEFUBENCMD = protobuf.Descriptor()
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD = protobuf.FieldDescriptor()
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD = protobuf.FieldDescriptor()
GVGPOINTUPDATEFUBENCMD = protobuf.Descriptor()
GVGPOINTUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGPOINTUPDATEFUBENCMD_INFO_FIELD = protobuf.FieldDescriptor()
GVGRAIDSTATEUPDATEFUBENCMD = protobuf.Descriptor()
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD = protobuf.FieldDescriptor()
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD = protobuf.FieldDescriptor()
ADDPVECARDTIMESFUBENCMD = protobuf.Descriptor()
ADDPVECARDTIMESFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD = protobuf.FieldDescriptor()
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD = protobuf.FieldDescriptor()
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD = protobuf.FieldDescriptor()
PVECARDPASSINFO = protobuf.Descriptor()
PVECARDPASSINFO_ID_FIELD = protobuf.FieldDescriptor()
PVECARDPASSINFO_OPEN_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDOPENSTATEFUBENCMD = protobuf.Descriptor()
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD = protobuf.Descriptor()
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD = protobuf.FieldDescriptor()
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD = protobuf.FieldDescriptor()
PVECARDREWARDTIMESITEM = protobuf.Descriptor()
PVECARDREWARDTIMESITEM_DIFF_FIELD = protobuf.FieldDescriptor()
PVECARDREWARDTIMESITEM_TIMES_FIELD = protobuf.FieldDescriptor()
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDREWARDTIMESFUBENCMD = protobuf.Descriptor()
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD = protobuf.FieldDescriptor()
GVGPERFECTSTATEUPDATEFUBENCMD = protobuf.Descriptor()
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD = protobuf.FieldDescriptor()
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD = protobuf.FieldDescriptor()
BOSSSTATEINFO = protobuf.Descriptor()
BOSSSTATEINFO_BOSSID_FIELD = protobuf.FieldDescriptor()
BOSSSTATEINFO_ISALIVE_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT = protobuf.Descriptor()
QUERYELEMENTRAIDSTAT_CMD_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT_CURRENT_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT_TOTAL_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT_HISTORY_FIELD = protobuf.FieldDescriptor()
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD = protobuf.FieldDescriptor()
EMOTIONFACTORS = protobuf.Descriptor()
EMOTIONFACTORS_ID_FIELD = protobuf.FieldDescriptor()
EMOTIONFACTORS_COUNT_FIELD = protobuf.FieldDescriptor()
SYNCEMOTIONFACTORSFUBENCMD = protobuf.Descriptor()
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD = protobuf.FieldDescriptor()
SYNCBOSSSCENEINFO = protobuf.Descriptor()
SYNCBOSSSCENEINFO_CMD_FIELD = protobuf.FieldDescriptor()
SYNCBOSSSCENEINFO_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCBOSSSCENEINFO_INFOS_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKROOMIDSFUBENCMD = protobuf.Descriptor()
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD = protobuf.FieldDescriptor()
SYNCVISITNPCINFO = protobuf.Descriptor()
SYNCVISITNPCINFO_CMD_FIELD = protobuf.FieldDescriptor()
SYNCVISITNPCINFO_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCVISITNPCINFO_NPCTEMPID_FIELD = protobuf.FieldDescriptor()
SYNCVISITNPCINFO_CHARID_FIELD = protobuf.FieldDescriptor()
SYNCVISITNPCINFO_VISIT_FIELD = protobuf.FieldDescriptor()
SYNCMONSTERCOUNTFUBENCMD = protobuf.Descriptor()
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD = protobuf.FieldDescriptor()
SKIPANIMATIONFUBENCMD = protobuf.Descriptor()
SKIPANIMATIONFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SKIPANIMATIONFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RESETRAIDFUBENCMD = protobuf.Descriptor()
RESETRAIDFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
RESETRAIDFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD = protobuf.Descriptor()
SYNCSTARARKINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO = protobuf.Descriptor()
FIGHTUSERINFO_DAMAGE_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_HEAL_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_SUFFER_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_DAMGENAME_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_HEALNAME_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_SUFFERNAME_FIELD = protobuf.FieldDescriptor()
FIGHTUSERINFO_MVPUSERINFO_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD = protobuf.Descriptor()
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD = protobuf.FieldDescriptor()
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD = protobuf.FieldDescriptor()
OPENNTFFUBENCMD = protobuf.Descriptor()
OPENNTFFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
OPENNTFFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
OPENNTFFUBENCMD_RAIDTYPE_FIELD = protobuf.FieldDescriptor()
ROADBLOCKSCHANGEFUBENCMD = protobuf.Descriptor()
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD = protobuf.FieldDescriptor()
PASSINFO = protobuf.Descriptor()
PASSINFO_EQUIPS_FIELD = protobuf.FieldDescriptor()
PASSINFO_USERINFOS_FIELD = protobuf.FieldDescriptor()
PASSINFO_SHADOW_EQUIPS_FIELD = protobuf.FieldDescriptor()
PASSEQUIP = protobuf.Descriptor()
PASSEQUIP_POS_FIELD = protobuf.FieldDescriptor()
PASSEQUIP_CARD_FIELD = protobuf.FieldDescriptor()
PASSEQUIP_EQUIP_FIELD = protobuf.FieldDescriptor()
PASSEQUIPITEM = protobuf.Descriptor()
PASSEQUIPITEM_ITEMID_FIELD = protobuf.FieldDescriptor()
PASSEQUIPITEM_FREQUENCY_FIELD = protobuf.FieldDescriptor()
SYNCPASSUSERINFO = protobuf.Descriptor()
SYNCPASSUSERINFO_CMD_FIELD = protobuf.FieldDescriptor()
SYNCPASSUSERINFO_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCPASSUSERINFO_BRANCH_FIELD = protobuf.FieldDescriptor()
SYNCPASSUSERINFO_DATA_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA = protobuf.Descriptor()
TRIPLEUSERDATA_CHARID_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_USERNAME_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_PROFESSION_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_PORTRAIT_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_KILLNUM_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_DIENUM_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_HELPNUM_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_DAMAGE_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_BEDAMAGE_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_HEAL_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_HIDENAME_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_SCORE_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERDATA_ADDSCORE_FIELD = protobuf.FieldDescriptor()
TRIPLECAMPDATA = protobuf.Descriptor()
TRIPLECAMPDATA_ECAMP_FIELD = protobuf.FieldDescriptor()
TRIPLECAMPDATA_SCORE_FIELD = protobuf.FieldDescriptor()
TRIPLECAMPDATA_USERS_FIELD = protobuf.FieldDescriptor()
TRIPLECOMBODATA = protobuf.Descriptor()
TRIPLECOMBODATA_CHARID_FIELD = protobuf.FieldDescriptor()
TRIPLECOMBODATA_COMBO_FIELD = protobuf.FieldDescriptor()
TRIPLECOMBODATA_LIFEKILLNUM_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERINFO = protobuf.Descriptor()
TRIPLEUSERINFO_USER_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERINFO_INDEX_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERINFO_OFFLINE_FIELD = protobuf.FieldDescriptor()
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD = protobuf.FieldDescriptor()
TRIPLEMODELDATA = protobuf.Descriptor()
TRIPLEMODELDATA_ECAMP_FIELD = protobuf.FieldDescriptor()
TRIPLEMODELDATA_USERINFOS_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD = protobuf.Descriptor()
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECOMBOKILLFUBENCMD = protobuf.Descriptor()
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPLAYERMODELFUBENCMD = protobuf.Descriptor()
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD = protobuf.Descriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECAMPINFOFUBENCMD = protobuf.Descriptor()
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEENTERCOUNTFUBENCMD = protobuf.Descriptor()
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD = protobuf.FieldDescriptor()
CHOOSECURPROFESSIONFUBENCMD = protobuf.Descriptor()
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIGHTINGINFOFUBENCMD = protobuf.Descriptor()
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD = protobuf.FieldDescriptor()
SYNCFULLFIRESTATEFUBENCMD = protobuf.Descriptor()
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA = protobuf.Descriptor()
EBFEVENTDATA_ID_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_START_TIME_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_IS_END_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_WINNER_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATAUPDATECMD = protobuf.Descriptor()
EBFEVENTDATAUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATAUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATAUPDATECMD_DATAS_FIELD = protobuf.FieldDescriptor()
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE = protobuf.Descriptor()
EBFMISCDATAUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_STATE_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD = protobuf.FieldDescriptor()
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATA = protobuf.Descriptor()
OCCUPYPOINTDATA_POINT_ID_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATA_OCCUPIED_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATAUPDATE = protobuf.Descriptor()
OCCUPYPOINTDATAUPDATE_CMD_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATAUPDATE_PARAM_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD = protobuf.FieldDescriptor()
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA = protobuf.Descriptor()
PVPSTATDATA_CHARID_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_USERNAME_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_PROFESSION_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_HEAL_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_KILL_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_DEATH_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_ASSIST_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_DAMAGE_USER_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_DAMAGE_NPC_FIELD = protobuf.FieldDescriptor()
PVPSTATDATA_CAMP_FIELD = protobuf.FieldDescriptor()
QUERYPVPSTATCMD = protobuf.Descriptor()
QUERYPVPSTATCMD_CMD_FIELD = protobuf.FieldDescriptor()
QUERYPVPSTATCMD_PARAM_FIELD = protobuf.FieldDescriptor()
QUERYPVPSTATCMD_STATS_FIELD = protobuf.FieldDescriptor()
EBFKICKTIMECMD = protobuf.Descriptor()
EBFKICKTIMECMD_CMD_FIELD = protobuf.FieldDescriptor()
EBFKICKTIMECMD_PARAM_FIELD = protobuf.FieldDescriptor()
EBFKICKTIMECMD_KICK_TIME_FIELD = protobuf.FieldDescriptor()
EBFCONTINUECMD = protobuf.Descriptor()
EBFCONTINUECMD_CMD_FIELD = protobuf.FieldDescriptor()
EBFCONTINUECMD_PARAM_FIELD = protobuf.FieldDescriptor()
EBFEVENTAREAUPDATECMD = protobuf.Descriptor()
EBFEVENTAREAUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
EBFEVENTAREAUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD = protobuf.FieldDescriptor()
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD = protobuf.Descriptor()
ASTRALINFOSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_ROUND_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_PRAY_ID_FIELD = protobuf.FieldDescriptor()
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD = protobuf.FieldDescriptor()
GVGMVPINFOUPDATECMD = protobuf.Descriptor()
GVGMVPINFOUPDATECMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGMVPINFOUPDATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGMVPINFOUPDATECMD_HP_PER_FIELD = protobuf.FieldDescriptor()
GVGMVPINFOUPDATECMD_STATE_FIELD = protobuf.FieldDescriptor()
ASTRALPRAYGROUP = protobuf.Descriptor()
ASTRALPRAYGROUP_GROUP_FIELD = protobuf.FieldDescriptor()
ASTRALPRAYGROUP_BRANCHES_FIELD = protobuf.FieldDescriptor()
ASTRALPRAYBRANCHSYNCCMD = protobuf.Descriptor()
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD = protobuf.FieldDescriptor()
SYNCSTARTFIGHTSTATECMD = protobuf.Descriptor()
SYNCSTARTFIGHTSTATECMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD = protobuf.FieldDescriptor()
SYNCGVGFIGHTPOINTCMD = protobuf.Descriptor()
SYNCGVGFIGHTPOINTCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD = protobuf.FieldDescriptor()
GUILDLEADERPOS = protobuf.Descriptor()
GUILDLEADERPOS_GUILD_ID_FIELD = protobuf.FieldDescriptor()
GUILDLEADERPOS_LEADER_POS_FIELD = protobuf.FieldDescriptor()
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD = protobuf.FieldDescriptor()
SYNCGVGLEADERPOSCMD = protobuf.Descriptor()
SYNCGVGLEADERPOSCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCGVGLEADERPOSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD = protobuf.FieldDescriptor()
STISYNCSCORECMD = protobuf.Descriptor()
STISYNCSCORECMD_CMD_FIELD = protobuf.FieldDescriptor()
STISYNCSCORECMD_PARAM_FIELD = protobuf.FieldDescriptor()
STISYNCSCORECMD_SCORE_FIELD = protobuf.FieldDescriptor()
STISKILLINFO = protobuf.Descriptor()
STISKILLINFO_SKILL_ID_FIELD = protobuf.FieldDescriptor()
STISKILLINFO_SKILL_LEVEL_FIELD = protobuf.FieldDescriptor()
STISKILLINFO_IS_RECOMMEND_FIELD = protobuf.FieldDescriptor()
STISKILLINFO_IS_NEW_SKILL_FIELD = protobuf.FieldDescriptor()
STISYNCSKILLCMD = protobuf.Descriptor()
STISYNCSKILLCMD_CMD_FIELD = protobuf.FieldDescriptor()
STISYNCSKILLCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD = protobuf.FieldDescriptor()
STISYNCAVAILABLEUPGRADENUMBERCMD = protobuf.Descriptor()
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD = protobuf.FieldDescriptor()
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD = protobuf.FieldDescriptor()
STIGETUPGRADEOPTIONSCMD = protobuf.Descriptor()
STIGETUPGRADEOPTIONSCMD_CMD_FIELD = protobuf.FieldDescriptor()
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STIRETUPGRADEOPTIONSCMD = protobuf.Descriptor()
STIRETUPGRADEOPTIONSCMD_CMD_FIELD = protobuf.FieldDescriptor()
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD = protobuf.FieldDescriptor()
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD = protobuf.FieldDescriptor()
STIEXECSKILLUPGRADECMD = protobuf.Descriptor()
STIEXECSKILLUPGRADECMD_CMD_FIELD = protobuf.FieldDescriptor()
STIEXECSKILLUPGRADECMD_PARAM_FIELD = protobuf.FieldDescriptor()
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD = protobuf.Descriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD = protobuf.Descriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD = protobuf.FieldDescriptor()
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD = protobuf.FieldDescriptor()
STIREFRESHUPGRADEOPTIONSCMD = protobuf.Descriptor()
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD = protobuf.FieldDescriptor()
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD = protobuf.FieldDescriptor()
STIDROPSKILLCMD = protobuf.Descriptor()
STIDROPSKILLCMD_CMD_FIELD = protobuf.FieldDescriptor()
STIDROPSKILLCMD_PARAM_FIELD = protobuf.FieldDescriptor()
STIDROPSKILLCMD_SKILL_ID_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD = protobuf.Descriptor()
FAIRYTALERAIDSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD = protobuf.FieldDescriptor()
RAIDSTARTFIGHTCMD = protobuf.Descriptor()
RAIDSTARTFIGHTCMD_CMD_FIELD = protobuf.FieldDescriptor()
RAIDSTARTFIGHTCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDREWARDSYNCCMD = protobuf.Descriptor()
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDGETREWARDCMD = protobuf.Descriptor()
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD = protobuf.FieldDescriptor()
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO = protobuf.Descriptor()
MEMORYEQUIPREWARDINFO_INDEX_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_POS_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_STATE_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_QUALITY_FIELD = protobuf.FieldDescriptor()
MEMORYEQUIPREWARDINFO_ITEMS_FIELD = protobuf.FieldDescriptor()
SYNCMEMORYEQUIPREWARDINFO = protobuf.Descriptor()
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD = protobuf.FieldDescriptor()
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD = protobuf.FieldDescriptor()
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD = protobuf.FieldDescriptor()
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD = protobuf.FieldDescriptor()
CHOOSEMEMORYEQUIPREWARDINFO = protobuf.Descriptor()
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD = protobuf.FieldDescriptor()
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD = protobuf.FieldDescriptor()
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEDEATHINFO = protobuf.Descriptor()
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEBLOODINFO = protobuf.Descriptor()
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEINFOSYNCCMD = protobuf.Descriptor()
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD = protobuf.FieldDescriptor()
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD = protobuf.FieldDescriptor()
FUBENPARAM_TRACK_FUBEN_USER_CMD_ENUM.name = "TRACK_FUBEN_USER_CMD"
FUBENPARAM_TRACK_FUBEN_USER_CMD_ENUM.index = 0
FUBENPARAM_TRACK_FUBEN_USER_CMD_ENUM.number = 1
FUBENPARAM_FAIL_FUBEN_USER_CMD_ENUM.name = "FAIL_FUBEN_USER_CMD"
FUBENPARAM_FAIL_FUBEN_USER_CMD_ENUM.index = 1
FUBENPARAM_FAIL_FUBEN_USER_CMD_ENUM.number = 2
FUBENPARAM_LEAVE_FUBEN_USER_CMD_ENUM.name = "LEAVE_FUBEN_USER_CMD"
FUBENPARAM_LEAVE_FUBEN_USER_CMD_ENUM.index = 2
FUBENPARAM_LEAVE_FUBEN_USER_CMD_ENUM.number = 3
FUBENPARAM_SUCCESS_FUBEN_USER_CMD_ENUM.name = "SUCCESS_FUBEN_USER_CMD"
FUBENPARAM_SUCCESS_FUBEN_USER_CMD_ENUM.index = 3
FUBENPARAM_SUCCESS_FUBEN_USER_CMD_ENUM.number = 4
FUBENPARAM_WORLD_STAGE_USER_CMD_ENUM.name = "WORLD_STAGE_USER_CMD"
FUBENPARAM_WORLD_STAGE_USER_CMD_ENUM.index = 4
FUBENPARAM_WORLD_STAGE_USER_CMD_ENUM.number = 5
FUBENPARAM_SUB_STAGE_USER_CMD_ENUM.name = "SUB_STAGE_USER_CMD"
FUBENPARAM_SUB_STAGE_USER_CMD_ENUM.index = 5
FUBENPARAM_SUB_STAGE_USER_CMD_ENUM.number = 6
FUBENPARAM_START_STAGE_USER_CMD_ENUM.name = "START_STAGE_USER_CMD"
FUBENPARAM_START_STAGE_USER_CMD_ENUM.index = 6
FUBENPARAM_START_STAGE_USER_CMD_ENUM.number = 7
FUBENPARAM_GET_REWARD_STAGE_USER_CMD_ENUM.name = "GET_REWARD_STAGE_USER_CMD"
FUBENPARAM_GET_REWARD_STAGE_USER_CMD_ENUM.index = 7
FUBENPARAM_GET_REWARD_STAGE_USER_CMD_ENUM.number = 8
FUBENPARAM_STAGE_STEP_STAR_USER_CMD_ENUM.name = "STAGE_STEP_STAR_USER_CMD"
FUBENPARAM_STAGE_STEP_STAR_USER_CMD_ENUM.index = 8
FUBENPARAM_STAGE_STEP_STAR_USER_CMD_ENUM.number = 9
FUBENPARAM_JOIN_FUBEN_USER_CMD_ENUM.name = "JOIN_FUBEN_USER_CMD"
FUBENPARAM_JOIN_FUBEN_USER_CMD_ENUM.index = 9
FUBENPARAM_JOIN_FUBEN_USER_CMD_ENUM.number = 10
FUBENPARAM_MONSTER_COUNT_USER_CMD_ENUM.name = "MONSTER_COUNT_USER_CMD"
FUBENPARAM_MONSTER_COUNT_USER_CMD_ENUM.index = 10
FUBENPARAM_MONSTER_COUNT_USER_CMD_ENUM.number = 11
FUBENPARAM_FUBEN_STEP_SYNC_ENUM.name = "FUBEN_STEP_SYNC"
FUBENPARAM_FUBEN_STEP_SYNC_ENUM.index = 11
FUBENPARAM_FUBEN_STEP_SYNC_ENUM.number = 12
FUBENPARAM_FUBEN_GOAL_SYNC_ENUM.name = "FUBEN_GOAL_SYNC"
FUBENPARAM_FUBEN_GOAL_SYNC_ENUM.index = 12
FUBENPARAM_FUBEN_GOAL_SYNC_ENUM.number = 13
FUBENPARAM_FUBEN_CLEAR_SYNC_ENUM.name = "FUBEN_CLEAR_SYNC"
FUBENPARAM_FUBEN_CLEAR_SYNC_ENUM.index = 13
FUBENPARAM_FUBEN_CLEAR_SYNC_ENUM.number = 15
FUBENPARAM_GUILD_RAID_USER_INFO_ENUM.name = "GUILD_RAID_USER_INFO"
FUBENPARAM_GUILD_RAID_USER_INFO_ENUM.index = 14
FUBENPARAM_GUILD_RAID_USER_INFO_ENUM.number = 16
FUBENPARAM_GUILD_RAID_GATE_OPT_ENUM.name = "GUILD_RAID_GATE_OPT"
FUBENPARAM_GUILD_RAID_GATE_OPT_ENUM.index = 15
FUBENPARAM_GUILD_RAID_GATE_OPT_ENUM.number = 17
FUBENPARAM_GUILD_FIRE_INFO_ENUM.name = "GUILD_FIRE_INFO"
FUBENPARAM_GUILD_FIRE_INFO_ENUM.index = 16
FUBENPARAM_GUILD_FIRE_INFO_ENUM.number = 18
FUBENPARAM_GUILD_FIRE_STOP_ENUM.name = "GUILD_FIRE_STOP"
FUBENPARAM_GUILD_FIRE_STOP_ENUM.index = 17
FUBENPARAM_GUILD_FIRE_STOP_ENUM.number = 19
FUBENPARAM_GUILD_FIRE_DANGER_ENUM.name = "GUILD_FIRE_DANGER"
FUBENPARAM_GUILD_FIRE_DANGER_ENUM.index = 18
FUBENPARAM_GUILD_FIRE_DANGER_ENUM.number = 20
FUBENPARAM_GUILD_FIRE_METALHP_ENUM.name = "GUILD_FIRE_METALHP"
FUBENPARAM_GUILD_FIRE_METALHP_ENUM.index = 19
FUBENPARAM_GUILD_FIRE_METALHP_ENUM.number = 21
FUBENPARAM_GUILD_FIRE_CALM_ENUM.name = "GUILD_FIRE_CALM"
FUBENPARAM_GUILD_FIRE_CALM_ENUM.index = 20
FUBENPARAM_GUILD_FIRE_CALM_ENUM.number = 22
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_ENUM.name = "GUILD_FIRE_CHANGE_GUILD"
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_ENUM.index = 21
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_ENUM.number = 23
FUBENPARAM_GUILD_FIRE_RESTART_ENUM.name = "GUILD_FIRE_RESTART"
FUBENPARAM_GUILD_FIRE_RESTART_ENUM.index = 22
FUBENPARAM_GUILD_FIRE_RESTART_ENUM.number = 24
FUBENPARAM_GUILD_FIRE_STATUS_ENUM.name = "GUILD_FIRE_STATUS"
FUBENPARAM_GUILD_FIRE_STATUS_ENUM.index = 23
FUBENPARAM_GUILD_FIRE_STATUS_ENUM.number = 25
FUBENPARAM_GVG_DATA_SYNC_CMD_ENUM.name = "GVG_DATA_SYNC_CMD"
FUBENPARAM_GVG_DATA_SYNC_CMD_ENUM.index = 24
FUBENPARAM_GVG_DATA_SYNC_CMD_ENUM.number = 26
FUBENPARAM_GVG_DATA_UPDATE_CMD_ENUM.name = "GVG_DATA_UPDATE_CMD"
FUBENPARAM_GVG_DATA_UPDATE_CMD_ENUM.index = 25
FUBENPARAM_GVG_DATA_UPDATE_CMD_ENUM.number = 27
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_NAME_ENUM.name = "GUILD_FIRE_CHANGE_GUILD_NAME"
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_NAME_ENUM.index = 26
FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_NAME_ENUM.number = 28
FUBENPARAM_MVPBATTLE_SYNC_MVPINFO_ENUM.name = "MVPBATTLE_SYNC_MVPINFO"
FUBENPARAM_MVPBATTLE_SYNC_MVPINFO_ENUM.index = 27
FUBENPARAM_MVPBATTLE_SYNC_MVPINFO_ENUM.number = 29
FUBENPARAM_MVPBATTLE_BOSS_DIE_ENUM.name = "MVPBATTLE_BOSS_DIE"
FUBENPARAM_MVPBATTLE_BOSS_DIE_ENUM.index = 28
FUBENPARAM_MVPBATTLE_BOSS_DIE_ENUM.number = 30
FUBENPARAM_FUBEN_USERNUM_COUNT_ENUM.name = "FUBEN_USERNUM_COUNT"
FUBENPARAM_FUBEN_USERNUM_COUNT_ENUM.index = 29
FUBENPARAM_FUBEN_USERNUM_COUNT_ENUM.number = 31
FUBENPARAM_SUPERGVG_INFO_SYNC_ENUM.name = "SUPERGVG_INFO_SYNC"
FUBENPARAM_SUPERGVG_INFO_SYNC_ENUM.index = 30
FUBENPARAM_SUPERGVG_INFO_SYNC_ENUM.number = 32
FUBENPARAM_SUPERGVG_TOWERINFO_UPDATE_ENUM.name = "SUPERGVG_TOWERINFO_UPDATE"
FUBENPARAM_SUPERGVG_TOWERINFO_UPDATE_ENUM.index = 31
FUBENPARAM_SUPERGVG_TOWERINFO_UPDATE_ENUM.number = 33
FUBENPARAM_SUPERGVG_METALINFO_UPDATE_ENUM.name = "SUPERGVG_METALINFO_UPDATE"
FUBENPARAM_SUPERGVG_METALINFO_UPDATE_ENUM.index = 32
FUBENPARAM_SUPERGVG_METALINFO_UPDATE_ENUM.number = 34
FUBENPARAM_SUPERGVG_QUERY_TOWERINFO_ENUM.name = "SUPERGVG_QUERY_TOWERINFO"
FUBENPARAM_SUPERGVG_QUERY_TOWERINFO_ENUM.index = 33
FUBENPARAM_SUPERGVG_QUERY_TOWERINFO_ENUM.number = 35
FUBENPARAM_SUPERGVG_REWARD_INFO_ENUM.name = "SUPERGVG_REWARD_INFO"
FUBENPARAM_SUPERGVG_REWARD_INFO_ENUM.index = 34
FUBENPARAM_SUPERGVG_REWARD_INFO_ENUM.number = 36
FUBENPARAM_SUPERGVG_QUERY_USER_DATA_ENUM.name = "SUPERGVG_QUERY_USER_DATA"
FUBENPARAM_SUPERGVG_QUERY_USER_DATA_ENUM.index = 35
FUBENPARAM_SUPERGVG_QUERY_USER_DATA_ENUM.number = 37
FUBENPARAM_MVPBATTLE_END_REPORT_ENUM.name = "MVPBATTLE_END_REPORT"
FUBENPARAM_MVPBATTLE_END_REPORT_ENUM.index = 36
FUBENPARAM_MVPBATTLE_END_REPORT_ENUM.number = 38
FUBENPARAM_SUPERGVG_METAL_DIE_ENUM.name = "SUPERGVG_METAL_DIE"
FUBENPARAM_SUPERGVG_METAL_DIE_ENUM.index = 37
FUBENPARAM_SUPERGVG_METAL_DIE_ENUM.number = 39
FUBENPARAM_INVITE_SUMMON_DEADBOSS_ENUM.name = "INVITE_SUMMON_DEADBOSS"
FUBENPARAM_INVITE_SUMMON_DEADBOSS_ENUM.index = 38
FUBENPARAM_INVITE_SUMMON_DEADBOSS_ENUM.number = 40
FUBENPARAM_REPLY_SUMMON_DEADBOSS_ENUM.name = "REPLY_SUMMON_DEADBOSS"
FUBENPARAM_REPLY_SUMMON_DEADBOSS_ENUM.index = 39
FUBENPARAM_REPLY_SUMMON_DEADBOSS_ENUM.number = 41
FUBENPARAM_QUERY_RAID_TEAMPWS_USERINFO_ENUM.name = "QUERY_RAID_TEAMPWS_USERINFO"
FUBENPARAM_QUERY_RAID_TEAMPWS_USERINFO_ENUM.index = 40
FUBENPARAM_QUERY_RAID_TEAMPWS_USERINFO_ENUM.number = 42
FUBENPARAM_TEAMPWS_END_REPORT_ENUM.name = "TEAMPWS_END_REPORT"
FUBENPARAM_TEAMPWS_END_REPORT_ENUM.index = 41
FUBENPARAM_TEAMPWS_END_REPORT_ENUM.number = 43
FUBENPARAM_TEAMPWS_SYNC_INFO_ENUM.name = "TEAMPWS_SYNC_INFO"
FUBENPARAM_TEAMPWS_SYNC_INFO_ENUM.index = 42
FUBENPARAM_TEAMPWS_SYNC_INFO_ENUM.number = 44
FUBENPARAM_TEAMPWS_SELECT_MAGIC_ENUM.name = "TEAMPWS_SELECT_MAGIC"
FUBENPARAM_TEAMPWS_SELECT_MAGIC_ENUM.index = 43
FUBENPARAM_TEAMPWS_SELECT_MAGIC_ENUM.number = 45
FUBENPARAM_TEAMPWS_UPDATE_MAGIC_ENUM.name = "TEAMPWS_UPDATE_MAGIC"
FUBENPARAM_TEAMPWS_UPDATE_MAGIC_ENUM.index = 44
FUBENPARAM_TEAMPWS_UPDATE_MAGIC_ENUM.number = 46
FUBENPARAM_TEAMPWS_UPDATE_INFO_ENUM.name = "TEAMPWS_UPDATE_INFO"
FUBENPARAM_TEAMPWS_UPDATE_INFO_ENUM.index = 45
FUBENPARAM_TEAMPWS_UPDATE_INFO_ENUM.number = 47
FUBENPARAM_EXIT_RAID_CMD_ENUM.name = "EXIT_RAID_CMD"
FUBENPARAM_EXIT_RAID_CMD_ENUM.index = 46
FUBENPARAM_EXIT_RAID_CMD_ENUM.number = 48
FUBENPARAM_BEGIN_FIRE_FUBENCMD_ENUM.name = "BEGIN_FIRE_FUBENCMD"
FUBENPARAM_BEGIN_FIRE_FUBENCMD_ENUM.index = 47
FUBENPARAM_BEGIN_FIRE_FUBENCMD_ENUM.number = 49
FUBENPARAM_TEAMEXP_RAID_REPORT_ENUM.name = "TEAMEXP_RAID_REPORT"
FUBENPARAM_TEAMEXP_RAID_REPORT_ENUM.index = 48
FUBENPARAM_TEAMEXP_RAID_REPORT_ENUM.number = 50
FUBENPARAM_TEAMEXP_BUY_ITEM_ENUM.name = "TEAMEXP_BUY_ITEM"
FUBENPARAM_TEAMEXP_BUY_ITEM_ENUM.index = 49
FUBENPARAM_TEAMEXP_BUY_ITEM_ENUM.number = 51
FUBENPARAM_TEAMEXP_SYNC_CMD_ENUM.name = "TEAMEXP_SYNC_CMD"
FUBENPARAM_TEAMEXP_SYNC_CMD_ENUM.index = 50
FUBENPARAM_TEAMEXP_SYNC_CMD_ENUM.number = 52
FUBENPARAM_TEAM_RELIVE_COUNT_ENUM.name = "TEAM_RELIVE_COUNT"
FUBENPARAM_TEAM_RELIVE_COUNT_ENUM.index = 51
FUBENPARAM_TEAM_RELIVE_COUNT_ENUM.number = 53
FUBENPARAM_TEAM_GROUP_RAID_CHIP_ENUM.name = "TEAM_GROUP_RAID_CHIP"
FUBENPARAM_TEAM_GROUP_RAID_CHIP_ENUM.index = 52
FUBENPARAM_TEAM_GROUP_RAID_CHIP_ENUM.number = 54
FUBENPARAM_TEAM_GROUP_RAID_QUERY_INFO_ENUM.name = "TEAM_GROUP_RAID_QUERY_INFO"
FUBENPARAM_TEAM_GROUP_RAID_QUERY_INFO_ENUM.index = 53
FUBENPARAM_TEAM_GROUP_RAID_QUERY_INFO_ENUM.number = 55
FUBENPARAM_TEAMEXP_QUERY_INFO_ENUM.name = "TEAMEXP_QUERY_INFO"
FUBENPARAM_TEAMEXP_QUERY_INFO_ENUM.index = 54
FUBENPARAM_TEAMEXP_QUERY_INFO_ENUM.number = 56
FUBENPARAM_TEAM_GROUP_RAID_STATE_ENUM.name = "TEAM_GROUP_RAID_STATE"
FUBENPARAM_TEAM_GROUP_RAID_STATE_ENUM.index = 55
FUBENPARAM_TEAM_GROUP_RAID_STATE_ENUM.number = 57
FUBENPARAM_KUMAMOTO_OPER_CMD_ENUM.name = "KUMAMOTO_OPER_CMD"
FUBENPARAM_KUMAMOTO_OPER_CMD_ENUM.index = 56
FUBENPARAM_KUMAMOTO_OPER_CMD_ENUM.number = 58
FUBENPARAM_TEAM_GROUP_FOURTH_QUERY_ENUM.name = "TEAM_GROUP_FOURTH_QUERY"
FUBENPARAM_TEAM_GROUP_FOURTH_QUERY_ENUM.index = 57
FUBENPARAM_TEAM_GROUP_FOURTH_QUERY_ENUM.number = 59
FUBENPARAM_TEAM_GROUP_FOURTH_UPDATE_ENUM.name = "TEAM_GROUP_FOURTH_UPDATE"
FUBENPARAM_TEAM_GROUP_FOURTH_UPDATE_ENUM.index = 58
FUBENPARAM_TEAM_GROUP_FOURTH_UPDATE_ENUM.number = 60
FUBENPARAM_TEAM_GROUP_FOURTH_GOOUTER_ENUM.name = "TEAM_GROUP_FOURTH_GOOUTER"
FUBENPARAM_TEAM_GROUP_FOURTH_GOOUTER_ENUM.index = 59
FUBENPARAM_TEAM_GROUP_FOURTH_GOOUTER_ENUM.number = 61
FUBENPARAM_RAID_STAGE_SYNC_ENUM.name = "RAID_STAGE_SYNC"
FUBENPARAM_RAID_STAGE_SYNC_ENUM.index = 60
FUBENPARAM_RAID_STAGE_SYNC_ENUM.number = 62
FUBENPARAM_THANKSGIVING_MONSTER_NUM_ENUM.name = "THANKSGIVING_MONSTER_NUM"
FUBENPARAM_THANKSGIVING_MONSTER_NUM_ENUM.index = 61
FUBENPARAM_THANKSGIVING_MONSTER_NUM_ENUM.number = 63
FUBENPARAM_OTHELLO_POINT_OCCUPY_POWER_ENUM.name = "OTHELLO_POINT_OCCUPY_POWER"
FUBENPARAM_OTHELLO_POINT_OCCUPY_POWER_ENUM.index = 62
FUBENPARAM_OTHELLO_POINT_OCCUPY_POWER_ENUM.number = 64
FUBENPARAM_OTHELLO_SYNC_INFO_ENUM.name = "OTHELLO_SYNC_INFO"
FUBENPARAM_OTHELLO_SYNC_INFO_ENUM.index = 63
FUBENPARAM_OTHELLO_SYNC_INFO_ENUM.number = 65
FUBENPARAM_QUERY_RAID_OTHELLO_USERINFO_ENUM.name = "QUERY_RAID_OTHELLO_USERINFO"
FUBENPARAM_QUERY_RAID_OTHELLO_USERINFO_ENUM.index = 64
FUBENPARAM_QUERY_RAID_OTHELLO_USERINFO_ENUM.number = 66
FUBENPARAM_OTHELLO_END_REPORT_ENUM.name = "OTHELLO_END_REPORT"
FUBENPARAM_OTHELLO_END_REPORT_ENUM.index = 65
FUBENPARAM_OTHELLO_END_REPORT_ENUM.number = 67
FUBENPARAM_ROGUELIKE_SYNC_UNLOCKSCENES_ENUM.name = "ROGUELIKE_SYNC_UNLOCKSCENES"
FUBENPARAM_ROGUELIKE_SYNC_UNLOCKSCENES_ENUM.index = 66
FUBENPARAM_ROGUELIKE_SYNC_UNLOCKSCENES_ENUM.number = 68
FUBENPARAM_TRANSFERFIGHT_CHOOSE_ENUM.name = "TRANSFERFIGHT_CHOOSE"
FUBENPARAM_TRANSFERFIGHT_CHOOSE_ENUM.index = 67
FUBENPARAM_TRANSFERFIGHT_CHOOSE_ENUM.number = 69
FUBENPARAM_TRANSFERFIGHT_RANK_ENUM.name = "TRANSFERFIGHT_RANK"
FUBENPARAM_TRANSFERFIGHT_RANK_ENUM.index = 68
FUBENPARAM_TRANSFERFIGHT_RANK_ENUM.number = 70
FUBENPARAM_TRANSFERFIGHT_END_ENUM.name = "TRANSFERFIGHT_END"
FUBENPARAM_TRANSFERFIGHT_END_ENUM.index = 69
FUBENPARAM_TRANSFERFIGHT_END_ENUM.number = 71
FUBENPARAM_TWELVEPVP_DATA_SYNC_ENUM.name = "TWELVEPVP_DATA_SYNC"
FUBENPARAM_TWELVEPVP_DATA_SYNC_ENUM.index = 70
FUBENPARAM_TWELVEPVP_DATA_SYNC_ENUM.number = 72
FUBENPARAM_TWELVEPVP_ITEM_SYNC_ENUM.name = "TWELVEPVP_ITEM_SYNC"
FUBENPARAM_TWELVEPVP_ITEM_SYNC_ENUM.index = 71
FUBENPARAM_TWELVEPVP_ITEM_SYNC_ENUM.number = 73
FUBENPARAM_TWELVEPVP_ITEM_UPDATE_ENUM.name = "TWELVEPVP_ITEM_UPDATE"
FUBENPARAM_TWELVEPVP_ITEM_UPDATE_ENUM.index = 72
FUBENPARAM_TWELVEPVP_ITEM_UPDATE_ENUM.number = 74
FUBENPARAM_TWELVEPVP_SHOP_UPDATE_ENUM.name = "TWELVEPVP_SHOP_UPDATE"
FUBENPARAM_TWELVEPVP_SHOP_UPDATE_ENUM.index = 73
FUBENPARAM_TWELVEPVP_SHOP_UPDATE_ENUM.number = 75
FUBENPARAM_TWELVEPVP_QUEST_QUERY_ENUM.name = "TWELVEPVP_QUEST_QUERY"
FUBENPARAM_TWELVEPVP_QUEST_QUERY_ENUM.index = 74
FUBENPARAM_TWELVEPVP_QUEST_QUERY_ENUM.number = 76
FUBENPARAM_TWELVEPVP_GROUP_INFO_QUERY_ENUM.name = "TWELVEPVP_GROUP_INFO_QUERY"
FUBENPARAM_TWELVEPVP_GROUP_INFO_QUERY_ENUM.index = 75
FUBENPARAM_TWELVEPVP_GROUP_INFO_QUERY_ENUM.number = 77
FUBENPARAM_TWELVEPVP_RESULT_ENUM.name = "TWELVEPVP_RESULT"
FUBENPARAM_TWELVEPVP_RESULT_ENUM.index = 76
FUBENPARAM_TWELVEPVP_RESULT_ENUM.number = 78
FUBENPARAM_TWELVEPVP_BUILDING_HP_UPDATE_ENUM.name = "TWELVEPVP_BUILDING_HP_UPDATE"
FUBENPARAM_TWELVEPVP_BUILDING_HP_UPDATE_ENUM.index = 77
FUBENPARAM_TWELVEPVP_BUILDING_HP_UPDATE_ENUM.number = 79
FUBENPARAM_TWELVEPVP_QUERY_UI_OPER_ENUM.name = "TWELVEPVP_QUERY_UI_OPER"
FUBENPARAM_TWELVEPVP_QUERY_UI_OPER_ENUM.index = 78
FUBENPARAM_TWELVEPVP_QUERY_UI_OPER_ENUM.number = 80
FUBENPARAM_TWELVEPVP_USE_ITEM_ENUM.name = "TWELVEPVP_USE_ITEM"
FUBENPARAM_TWELVEPVP_USE_ITEM_ENUM.index = 79
FUBENPARAM_TWELVEPVP_USE_ITEM_ENUM.number = 81
FUBENPARAM_INVITE_ROLL_RAID_REWARD_ENUM.name = "INVITE_ROLL_RAID_REWARD"
FUBENPARAM_INVITE_ROLL_RAID_REWARD_ENUM.index = 80
FUBENPARAM_INVITE_ROLL_RAID_REWARD_ENUM.number = 82
FUBENPARAM_REPLY_ROLL_RAID_REARD_ENUM.name = "REPLY_ROLL_RAID_REARD"
FUBENPARAM_REPLY_ROLL_RAID_REARD_ENUM.index = 81
FUBENPARAM_REPLY_ROLL_RAID_REARD_ENUM.number = 83
FUBENPARAM_TEAMMEMBER_ROLL_PROCESS_ENUM.name = "TEAMMEMBER_ROLL_PROCESS"
FUBENPARAM_TEAMMEMBER_ROLL_PROCESS_ENUM.index = 82
FUBENPARAM_TEAMMEMBER_ROLL_PROCESS_ENUM.number = 84
FUBENPARAM_PRE_REPLY_ROLL_RAID_REARD_ENUM.name = "PRE_REPLY_ROLL_RAID_REARD"
FUBENPARAM_PRE_REPLY_ROLL_RAID_REARD_ENUM.index = 83
FUBENPARAM_PRE_REPLY_ROLL_RAID_REARD_ENUM.number = 85
FUBENPARAM_RELIVE_CD_ENUM.name = "RELIVE_CD"
FUBENPARAM_RELIVE_CD_ENUM.index = 84
FUBENPARAM_RELIVE_CD_ENUM.number = 86
FUBENPARAM_POS_SYNC_ENUM.name = "POS_SYNC"
FUBENPARAM_POS_SYNC_ENUM.index = 85
FUBENPARAM_POS_SYNC_ENUM.number = 87
FUBENPARAM_REQ_ENTER_TOWERPRIVATE_ENUM.name = "REQ_ENTER_TOWERPRIVATE"
FUBENPARAM_REQ_ENTER_TOWERPRIVATE_ENUM.index = 86
FUBENPARAM_REQ_ENTER_TOWERPRIVATE_ENUM.number = 88
FUBENPARAM_TOWERPRIVATE_LAYINFO_ENUM.name = "TOWERPRIVATE_LAYINFO"
FUBENPARAM_TOWERPRIVATE_LAYINFO_ENUM.index = 87
FUBENPARAM_TOWERPRIVATE_LAYINFO_ENUM.number = 89
FUBENPARAM_TOWERPRIVATE_LAYER_COUNTDOWN_NTF_ENUM.name = "TOWERPRIVATE_LAYER_COUNTDOWN_NTF"
FUBENPARAM_TOWERPRIVATE_LAYER_COUNTDOWN_NTF_ENUM.index = 88
FUBENPARAM_TOWERPRIVATE_LAYER_COUNTDOWN_NTF_ENUM.number = 90
FUBENPARAM_FUBEN_RESULT_NTF_ENUM.name = "FUBEN_RESULT_NTF"
FUBENPARAM_FUBEN_RESULT_NTF_ENUM.index = 89
FUBENPARAM_FUBEN_RESULT_NTF_ENUM.number = 91
FUBENPARAM_ENDTIME_SYNC_ENUM.name = "ENDTIME_SYNC"
FUBENPARAM_ENDTIME_SYNC_ENUM.index = 90
FUBENPARAM_ENDTIME_SYNC_ENUM.number = 92
FUBENPARAM_RESULT_SYNC_ENUM.name = "RESULT_SYNC"
FUBENPARAM_RESULT_SYNC_ENUM.index = 91
FUBENPARAM_RESULT_SYNC_ENUM.number = 93
FUBENPARAM_COMODO_PHASE_ENUM.name = "COMODO_PHASE"
FUBENPARAM_COMODO_PHASE_ENUM.index = 92
FUBENPARAM_COMODO_PHASE_ENUM.number = 97
FUBENPARAM_COMODO_STAT_ENUM.name = "COMODO_STAT"
FUBENPARAM_COMODO_STAT_ENUM.index = 93
FUBENPARAM_COMODO_STAT_ENUM.number = 98
FUBENPARAM_TEAMPWS_STATE_SYNC_ENUM.name = "TEAMPWS_STATE_SYNC"
FUBENPARAM_TEAMPWS_STATE_SYNC_ENUM.index = 94
FUBENPARAM_TEAMPWS_STATE_SYNC_ENUM.number = 99
FUBENPARAM_OBSERVER_FLASH_ENUM.name = "OBSERVER_FLASH"
FUBENPARAM_OBSERVER_FLASH_ENUM.index = 95
FUBENPARAM_OBSERVER_FLASH_ENUM.number = 100
FUBENPARAM_OBSERVER_ATTACH_ENUM.name = "OBSERVER_ATTACH"
FUBENPARAM_OBSERVER_ATTACH_ENUM.index = 96
FUBENPARAM_OBSERVER_ATTACH_ENUM.number = 101
FUBENPARAM_OBSERVER_SELECT_ENUM.name = "OBSERVER_SELECT"
FUBENPARAM_OBSERVER_SELECT_ENUM.index = 97
FUBENPARAM_OBSERVER_SELECT_ENUM.number = 102
FUBENPARAM_OB_HPSP_UPDATE_ENUM.name = "OB_HPSP_UPDATE"
FUBENPARAM_OB_HPSP_UPDATE_ENUM.index = 98
FUBENPARAM_OB_HPSP_UPDATE_ENUM.number = 104
FUBENPARAM_OB_PLAYER_OFFLINE_ENUM.name = "OB_PLAYER_OFFLINE"
FUBENPARAM_OB_PLAYER_OFFLINE_ENUM.index = 99
FUBENPARAM_OB_PLAYER_OFFLINE_ENUM.number = 105
FUBENPARAM_MULTI_BOSS_PHASE_ENUM.name = "MULTI_BOSS_PHASE"
FUBENPARAM_MULTI_BOSS_PHASE_ENUM.index = 100
FUBENPARAM_MULTI_BOSS_PHASE_ENUM.number = 106
FUBENPARAM_MULTI_BOSS_STAT_ENUM.name = "MULTI_BOSS_STAT"
FUBENPARAM_MULTI_BOSS_STAT_ENUM.index = 101
FUBENPARAM_MULTI_BOSS_STAT_ENUM.number = 107
FUBENPARAM_OB_CAMERA_MOVE_PREPARE_ENUM.name = "OB_CAMERA_MOVE_PREPARE"
FUBENPARAM_OB_CAMERA_MOVE_PREPARE_ENUM.index = 102
FUBENPARAM_OB_CAMERA_MOVE_PREPARE_ENUM.number = 108
FUBENPARAM_OB_CAMERA_MOVE_END_ENUM.name = "OB_CAMERA_MOVE_END"
FUBENPARAM_OB_CAMERA_MOVE_END_ENUM.index = 103
FUBENPARAM_OB_CAMERA_MOVE_END_ENUM.number = 109
FUBENPARAM_RAID_KILL_NUM_SYNC_ENUM.name = "RAID_KILL_NUM_SYNC"
FUBENPARAM_RAID_KILL_NUM_SYNC_ENUM.index = 104
FUBENPARAM_RAID_KILL_NUM_SYNC_ENUM.number = 110
FUBENPARAM_PVE_PASS_INFO_ENUM.name = "PVE_PASS_INFO"
FUBENPARAM_PVE_PASS_INFO_ENUM.index = 105
FUBENPARAM_PVE_PASS_INFO_ENUM.number = 118
FUBENPARAM_GVG_POINT_STATE_UPDATE_ENUM.name = "GVG_POINT_STATE_UPDATE"
FUBENPARAM_GVG_POINT_STATE_UPDATE_ENUM.index = 106
FUBENPARAM_GVG_POINT_STATE_UPDATE_ENUM.number = 119
FUBENPARAM_GVG_CONSTRUCT_BUILDING_ENUM.name = "GVG_CONSTRUCT_BUILDING"
FUBENPARAM_GVG_CONSTRUCT_BUILDING_ENUM.index = 107
FUBENPARAM_GVG_CONSTRUCT_BUILDING_ENUM.number = 120
FUBENPARAM_GVG_LEVELUP_BUILDING_ENUM.name = "GVG_LEVELUP_BUILDING"
FUBENPARAM_GVG_LEVELUP_BUILDING_ENUM.index = 108
FUBENPARAM_GVG_LEVELUP_BUILDING_ENUM.number = 121
FUBENPARAM_GVG_CANCEL_BUILDING_ENUM.name = "GVG_CANCEL_BUILDING"
FUBENPARAM_GVG_CANCEL_BUILDING_ENUM.index = 109
FUBENPARAM_GVG_CANCEL_BUILDING_ENUM.number = 122
FUBENPARAM_GVG_STATE_UPDATE_ENUM.name = "GVG_STATE_UPDATE"
FUBENPARAM_GVG_STATE_UPDATE_ENUM.index = 110
FUBENPARAM_GVG_STATE_UPDATE_ENUM.number = 123
FUBENPARAM_GVG_USE_BUILDING_ENUM.name = "GVG_USE_BUILDING"
FUBENPARAM_GVG_USE_BUILDING_ENUM.index = 111
FUBENPARAM_GVG_USE_BUILDING_ENUM.number = 124
FUBENPARAM_GVG_MORALE_UPDATE_ENUM.name = "GVG_MORALE_UPDATE"
FUBENPARAM_GVG_MORALE_UPDATE_ENUM.index = 112
FUBENPARAM_GVG_MORALE_UPDATE_ENUM.number = 125
FUBENPARAM_PVE_RAID_ACHIEVE_ENUM.name = "PVE_RAID_ACHIEVE"
FUBENPARAM_PVE_RAID_ACHIEVE_ENUM.index = 113
FUBENPARAM_PVE_RAID_ACHIEVE_ENUM.number = 126
FUBENPARAM_QUICK_FINISH_CRACK_ENUM.name = "QUICK_FINISH_CRACK"
FUBENPARAM_QUICK_FINISH_CRACK_ENUM.index = 114
FUBENPARAM_QUICK_FINISH_CRACK_ENUM.number = 127
FUBENPARAM_PICKUP_PVE_RAID_ACHIEVE_ENUM.name = "PICKUP_PVE_RAID_ACHIEVE"
FUBENPARAM_PICKUP_PVE_RAID_ACHIEVE_ENUM.index = 115
FUBENPARAM_PICKUP_PVE_RAID_ACHIEVE_ENUM.number = 128
FUBENPARAM_ADD_PVECARD_TIMES_ENUM.name = "ADD_PVECARD_TIMES"
FUBENPARAM_ADD_PVECARD_TIMES_ENUM.index = 116
FUBENPARAM_ADD_PVECARD_TIMES_ENUM.number = 129
FUBENPARAM_SYNC_PVECARD_OPENSTATE_ENUM.name = "SYNC_PVECARD_OPENSTATE"
FUBENPARAM_SYNC_PVECARD_OPENSTATE_ENUM.index = 117
FUBENPARAM_SYNC_PVECARD_OPENSTATE_ENUM.number = 130
FUBENPARAM_QUICK_FINISH_PVERAID_ENUM.name = "QUICK_FINISH_PVERAID"
FUBENPARAM_QUICK_FINISH_PVERAID_ENUM.index = 118
FUBENPARAM_QUICK_FINISH_PVERAID_ENUM.number = 131
FUBENPARAM_SYNC_PVECARD_DIFFTIMES_ENUM.name = "SYNC_PVECARD_DIFFTIMES"
FUBENPARAM_SYNC_PVECARD_DIFFTIMES_ENUM.index = 119
FUBENPARAM_SYNC_PVECARD_DIFFTIMES_ENUM.number = 132
FUBENPARAM_GVG_PERFECT_STATE_UPDATE_ENUM.name = "GVG_PERFECT_STATE_UPDATE"
FUBENPARAM_GVG_PERFECT_STATE_UPDATE_ENUM.index = 120
FUBENPARAM_GVG_PERFECT_STATE_UPDATE_ENUM.number = 133
FUBENPARAM_SYNC_BOSS_SCENE_BOSS_ENUM.name = "SYNC_BOSS_SCENE_BOSS"
FUBENPARAM_SYNC_BOSS_SCENE_BOSS_ENUM.index = 121
FUBENPARAM_SYNC_BOSS_SCENE_BOSS_ENUM.number = 134
FUBENPARAM_RESET_RAID_ENUM.name = "RESET_RAID"
FUBENPARAM_RESET_RAID_ENUM.index = 122
FUBENPARAM_RESET_RAID_ENUM.number = 135
FUBENPARAM_ELEMENT_RAID_STAT_ENUM.name = "ELEMENT_RAID_STAT"
FUBENPARAM_ELEMENT_RAID_STAT_ENUM.index = 123
FUBENPARAM_ELEMENT_RAID_STAT_ENUM.number = 136
FUBENPARAM_SYNC_EMOTION_FACTORS_ENUM.name = "SYNC_EMOTION_FACTORS"
FUBENPARAM_SYNC_EMOTION_FACTORS_ENUM.index = 124
FUBENPARAM_SYNC_EMOTION_FACTORS_ENUM.number = 137
FUBENPARAM_SYNC_VISIT_NPC_ENUM.name = "SYNC_VISIT_NPC"
FUBENPARAM_SYNC_VISIT_NPC_ENUM.index = 125
FUBENPARAM_SYNC_VISIT_NPC_ENUM.number = 138
FUBENPARAM_SYNC_UNLOCK_ROOMIDS_ENUM.name = "SYNC_UNLOCK_ROOMIDS"
FUBENPARAM_SYNC_UNLOCK_ROOMIDS_ENUM.index = 126
FUBENPARAM_SYNC_UNLOCK_ROOMIDS_ENUM.number = 139
FUBENPARAM_SYNC_MONSTER_COUNT_ENUM.name = "SYNC_MONSTER_COUNT"
FUBENPARAM_SYNC_MONSTER_COUNT_ENUM.index = 127
FUBENPARAM_SYNC_MONSTER_COUNT_ENUM.number = 140
FUBENPARAM_SKIL_ANIMATION_ENUM.name = "SKIL_ANIMATION"
FUBENPARAM_SKIL_ANIMATION_ENUM.index = 128
FUBENPARAM_SKIL_ANIMATION_ENUM.number = 141
FUBENPARAM_SYNC_STAR_ARK_INFO_ENUM.name = "SYNC_STAR_ARK_INFO"
FUBENPARAM_SYNC_STAR_ARK_INFO_ENUM.index = 129
FUBENPARAM_SYNC_STAR_ARK_INFO_ENUM.number = 142
FUBENPARAM_SYNC_STAR_ARK_STATISTICS_ENUM.name = "SYNC_STAR_ARK_STATISTICS"
FUBENPARAM_SYNC_STAR_ARK_STATISTICS_ENUM.index = 130
FUBENPARAM_SYNC_STAR_ARK_STATISTICS_ENUM.number = 143
FUBENPARAM_OPEN_NTF_ENUM.name = "OPEN_NTF"
FUBENPARAM_OPEN_NTF_ENUM.index = 131
FUBENPARAM_OPEN_NTF_ENUM.number = 144
FUBENPARAM_GVG_ROADBLOCK_CHANGE_ENUM.name = "GVG_ROADBLOCK_CHANGE"
FUBENPARAM_GVG_ROADBLOCK_CHANGE_ENUM.index = 132
FUBENPARAM_GVG_ROADBLOCK_CHANGE_ENUM.number = 145
FUBENPARAM_SYNC_TRIPLE_FIRE_INFO_ENUM.name = "SYNC_TRIPLE_FIRE_INFO"
FUBENPARAM_SYNC_TRIPLE_FIRE_INFO_ENUM.index = 133
FUBENPARAM_SYNC_TRIPLE_FIRE_INFO_ENUM.number = 146
FUBENPARAM_SYNC_TRIPLE_COMBO_KILL_ENUM.name = "SYNC_TRIPLE_COMBO_KILL"
FUBENPARAM_SYNC_TRIPLE_COMBO_KILL_ENUM.index = 134
FUBENPARAM_SYNC_TRIPLE_COMBO_KILL_ENUM.number = 147
FUBENPARAM_SYNC_TRIPLE_PLAYER_MODEL_ENUM.name = "SYNC_TRIPLE_PLAYER_MODEL"
FUBENPARAM_SYNC_TRIPLE_PLAYER_MODEL_ENUM.index = 135
FUBENPARAM_SYNC_TRIPLE_PLAYER_MODEL_ENUM.number = 148
FUBENPARAM_SYNC_TRIPLE_PROFESSION_TIME_ENUM.name = "SYNC_TRIPLE_PROFESSION_TIME"
FUBENPARAM_SYNC_TRIPLE_PROFESSION_TIME_ENUM.index = 136
FUBENPARAM_SYNC_TRIPLE_PROFESSION_TIME_ENUM.number = 149
FUBENPARAM_SYNC_TRIPLE_CAMP_INFO_ENUM.name = "SYNC_TRIPLE_CAMP_INFO"
FUBENPARAM_SYNC_TRIPLE_CAMP_INFO_ENUM.index = 137
FUBENPARAM_SYNC_TRIPLE_CAMP_INFO_ENUM.number = 150
FUBENPARAM_SYNC_TRIPLE_ENTER_COUNT_ENUM.name = "SYNC_TRIPLE_ENTER_COUNT"
FUBENPARAM_SYNC_TRIPLE_ENTER_COUNT_ENUM.index = 138
FUBENPARAM_SYNC_TRIPLE_ENTER_COUNT_ENUM.number = 151
FUBENPARAM_SYNC_PASS_USER_ENUM.name = "SYNC_PASS_USER"
FUBENPARAM_SYNC_PASS_USER_ENUM.index = 139
FUBENPARAM_SYNC_PASS_USER_ENUM.number = 152
FUBENPARAM_CHOOSE_CUR_PROFESSION_ENUM.name = "CHOOSE_CUR_PROFESSION"
FUBENPARAM_CHOOSE_CUR_PROFESSION_ENUM.index = 140
FUBENPARAM_CHOOSE_CUR_PROFESSION_ENUM.number = 153
FUBENPARAM_SYNC_TRIPLE_FIGHTING_INFO_ENUM.name = "SYNC_TRIPLE_FIGHTING_INFO"
FUBENPARAM_SYNC_TRIPLE_FIGHTING_INFO_ENUM.index = 141
FUBENPARAM_SYNC_TRIPLE_FIGHTING_INFO_ENUM.number = 154
FUBENPARAM_SYNC_FULL_FIRE_STATE_ENUM.name = "SYNC_FULL_FIRE_STATE"
FUBENPARAM_SYNC_FULL_FIRE_STATE_ENUM.index = 142
FUBENPARAM_SYNC_FULL_FIRE_STATE_ENUM.number = 155
FUBENPARAM_EBF_EVENT_DATA_UPDATE_ENUM.name = "EBF_EVENT_DATA_UPDATE"
FUBENPARAM_EBF_EVENT_DATA_UPDATE_ENUM.index = 143
FUBENPARAM_EBF_EVENT_DATA_UPDATE_ENUM.number = 156
FUBENPARAM_EBF_MISC_DATA_UPDATE_ENUM.name = "EBF_MISC_DATA_UPDATE"
FUBENPARAM_EBF_MISC_DATA_UPDATE_ENUM.index = 144
FUBENPARAM_EBF_MISC_DATA_UPDATE_ENUM.number = 157
FUBENPARAM_OCCUPY_POINT_DATA_UPDATE_ENUM.name = "OCCUPY_POINT_DATA_UPDATE"
FUBENPARAM_OCCUPY_POINT_DATA_UPDATE_ENUM.index = 145
FUBENPARAM_OCCUPY_POINT_DATA_UPDATE_ENUM.number = 158
FUBENPARAM_QUERY_PVP_STAT_ENUM.name = "QUERY_PVP_STAT"
FUBENPARAM_QUERY_PVP_STAT_ENUM.index = 146
FUBENPARAM_QUERY_PVP_STAT_ENUM.number = 159
FUBENPARAM_EBF_KICK_TIME_ENUM.name = "EBF_KICK_TIME"
FUBENPARAM_EBF_KICK_TIME_ENUM.index = 147
FUBENPARAM_EBF_KICK_TIME_ENUM.number = 160
FUBENPARAM_EBF_CONTINUE_ENUM.name = "EBF_CONTINUE"
FUBENPARAM_EBF_CONTINUE_ENUM.index = 148
FUBENPARAM_EBF_CONTINUE_ENUM.number = 161
FUBENPARAM_EBF_EVENT_AREA_UPDATE_ENUM.name = "EBF_EVENT_AREA_UPDATE"
FUBENPARAM_EBF_EVENT_AREA_UPDATE_ENUM.index = 149
FUBENPARAM_EBF_EVENT_AREA_UPDATE_ENUM.number = 162
FUBENPARAM_ASTRAL_INFO_SYNC_ENUM.name = "ASTRAL_INFO_SYNC"
FUBENPARAM_ASTRAL_INFO_SYNC_ENUM.index = 150
FUBENPARAM_ASTRAL_INFO_SYNC_ENUM.number = 163
FUBENPARAM_GVG_MVP_INFO_UPDATE_ENUM.name = "GVG_MVP_INFO_UPDATE"
FUBENPARAM_GVG_MVP_INFO_UPDATE_ENUM.index = 151
FUBENPARAM_GVG_MVP_INFO_UPDATE_ENUM.number = 164
FUBENPARAM_ASTRAL_PRAY_BRANCH_SYNC_ENUM.name = "ASTRAL_PRAY_BRANCH_SYNC"
FUBENPARAM_ASTRAL_PRAY_BRANCH_SYNC_ENUM.index = 152
FUBENPARAM_ASTRAL_PRAY_BRANCH_SYNC_ENUM.number = 165
FUBENPARAM_SYNC_START_FIGHT_STATE_ENUM.name = "SYNC_START_FIGHT_STATE"
FUBENPARAM_SYNC_START_FIGHT_STATE_ENUM.index = 153
FUBENPARAM_SYNC_START_FIGHT_STATE_ENUM.number = 166
FUBENPARAM_SYNC_GVG_FIGHT_POINT_ENUM.name = "SYNC_GVG_FIGHT_POINT"
FUBENPARAM_SYNC_GVG_FIGHT_POINT_ENUM.index = 154
FUBENPARAM_SYNC_GVG_FIGHT_POINT_ENUM.number = 167
FUBENPARAM_SYNC_GVG_LEADER_POS_ENUM.name = "SYNC_GVG_LEADER_POS"
FUBENPARAM_SYNC_GVG_LEADER_POS_ENUM.index = 155
FUBENPARAM_SYNC_GVG_LEADER_POS_ENUM.number = 168
FUBENPARAM_STI_SYNC_SCORE_ENUM.name = "STI_SYNC_SCORE"
FUBENPARAM_STI_SYNC_SCORE_ENUM.index = 156
FUBENPARAM_STI_SYNC_SCORE_ENUM.number = 169
FUBENPARAM_STI_SYNC_SKILL_ENUM.name = "STI_SYNC_SKILL"
FUBENPARAM_STI_SYNC_SKILL_ENUM.index = 157
FUBENPARAM_STI_SYNC_SKILL_ENUM.number = 170
FUBENPARAM_STI_SYNC_AVAILABLE_UPGRADE_NUMBER_ENUM.name = "STI_SYNC_AVAILABLE_UPGRADE_NUMBER"
FUBENPARAM_STI_SYNC_AVAILABLE_UPGRADE_NUMBER_ENUM.index = 158
FUBENPARAM_STI_SYNC_AVAILABLE_UPGRADE_NUMBER_ENUM.number = 171
FUBENPARAM_STI_GET_SKILL_UPGRADE_OPTIONS_ENUM.name = "STI_GET_SKILL_UPGRADE_OPTIONS"
FUBENPARAM_STI_GET_SKILL_UPGRADE_OPTIONS_ENUM.index = 159
FUBENPARAM_STI_GET_SKILL_UPGRADE_OPTIONS_ENUM.number = 172
FUBENPARAM_STI_RET_SKILL_UPGRADE_OPTIONS_ENUM.name = "STI_RET_SKILL_UPGRADE_OPTIONS"
FUBENPARAM_STI_RET_SKILL_UPGRADE_OPTIONS_ENUM.index = 160
FUBENPARAM_STI_RET_SKILL_UPGRADE_OPTIONS_ENUM.number = 173
FUBENPARAM_STI_EXEC_SKILL_UPGRADE_ENUM.name = "STI_EXEC_SKILL_UPGRADE"
FUBENPARAM_STI_EXEC_SKILL_UPGRADE_ENUM.index = 161
FUBENPARAM_STI_EXEC_SKILL_UPGRADE_ENUM.number = 174
FUBENPARAM_SYNC_SPACETIME_ILLUSION_INFO_ENUM.name = "SYNC_SPACETIME_ILLUSION_INFO"
FUBENPARAM_SYNC_SPACETIME_ILLUSION_INFO_ENUM.index = 162
FUBENPARAM_SYNC_SPACETIME_ILLUSION_INFO_ENUM.number = 175
FUBENPARAM_SYNC_SPACETIME_ILLUSION_EXP_LEVEL_ENUM.name = "SYNC_SPACETIME_ILLUSION_EXP_LEVEL"
FUBENPARAM_SYNC_SPACETIME_ILLUSION_EXP_LEVEL_ENUM.index = 163
FUBENPARAM_SYNC_SPACETIME_ILLUSION_EXP_LEVEL_ENUM.number = 176
FUBENPARAM_STI_REFRESH_SKILL_UPGRADE_OPTIONS_ENUM.name = "STI_REFRESH_SKILL_UPGRADE_OPTIONS"
FUBENPARAM_STI_REFRESH_SKILL_UPGRADE_OPTIONS_ENUM.index = 164
FUBENPARAM_STI_REFRESH_SKILL_UPGRADE_OPTIONS_ENUM.number = 177
FUBENPARAM_STI_DROP_SKILL_ENUM.name = "STI_DROP_SKILL"
FUBENPARAM_STI_DROP_SKILL_ENUM.index = 165
FUBENPARAM_STI_DROP_SKILL_ENUM.number = 178
FUBENPARAM_FAIRY_TALE_RAID_SYNC_ENUM.name = "FAIRY_TALE_RAID_SYNC"
FUBENPARAM_FAIRY_TALE_RAID_SYNC_ENUM.index = 166
FUBENPARAM_FAIRY_TALE_RAID_SYNC_ENUM.number = 179
FUBENPARAM_RAID_START_FIGHT_ENUM.name = "RAID_START_FIGHT"
FUBENPARAM_RAID_START_FIGHT_ENUM.index = 167
FUBENPARAM_RAID_START_FIGHT_ENUM.number = 180
FUBENPARAM_GVG_DATE_BATTLE_INFO_SYNC_ENUM.name = "GVG_DATE_BATTLE_INFO_SYNC"
FUBENPARAM_GVG_DATE_BATTLE_INFO_SYNC_ENUM.index = 168
FUBENPARAM_GVG_DATE_BATTLE_INFO_SYNC_ENUM.number = 181
FUBENPARAM_FAIRY_TALE_RAID_REWARD_SYNC_ENUM.name = "FAIRY_TALE_RAID_REWARD_SYNC"
FUBENPARAM_FAIRY_TALE_RAID_REWARD_SYNC_ENUM.index = 169
FUBENPARAM_FAIRY_TALE_RAID_REWARD_SYNC_ENUM.number = 182
FUBENPARAM_FAIRY_TALE_RAID_GET_REWARD_ENUM.name = "FAIRY_TALE_RAID_GET_REWARD"
FUBENPARAM_FAIRY_TALE_RAID_GET_REWARD_ENUM.index = 170
FUBENPARAM_FAIRY_TALE_RAID_GET_REWARD_ENUM.number = 183
FUBENPARAM_SYNC_MEMORY_EQUIP_REWARD_INFO_ENUM.name = "SYNC_MEMORY_EQUIP_REWARD_INFO"
FUBENPARAM_SYNC_MEMORY_EQUIP_REWARD_INFO_ENUM.index = 171
FUBENPARAM_SYNC_MEMORY_EQUIP_REWARD_INFO_ENUM.number = 184
FUBENPARAM_CHOOSE_MEMORY_EQUIP_REWARD_INFO_ENUM.name = "CHOOSE_MEMORY_EQUIP_REWARD_INFO"
FUBENPARAM_CHOOSE_MEMORY_EQUIP_REWARD_INFO_ENUM.index = 172
FUBENPARAM_CHOOSE_MEMORY_EQUIP_REWARD_INFO_ENUM.number = 185
FUBENPARAM.name = "FuBenParam"
FUBENPARAM.full_name = ".Cmd.FuBenParam"
FUBENPARAM.values = {
  FUBENPARAM_TRACK_FUBEN_USER_CMD_ENUM,
  FUBENPARAM_FAIL_FUBEN_USER_CMD_ENUM,
  FUBENPARAM_LEAVE_FUBEN_USER_CMD_ENUM,
  FUBENPARAM_SUCCESS_FUBEN_USER_CMD_ENUM,
  FUBENPARAM_WORLD_STAGE_USER_CMD_ENUM,
  FUBENPARAM_SUB_STAGE_USER_CMD_ENUM,
  FUBENPARAM_START_STAGE_USER_CMD_ENUM,
  FUBENPARAM_GET_REWARD_STAGE_USER_CMD_ENUM,
  FUBENPARAM_STAGE_STEP_STAR_USER_CMD_ENUM,
  FUBENPARAM_JOIN_FUBEN_USER_CMD_ENUM,
  FUBENPARAM_MONSTER_COUNT_USER_CMD_ENUM,
  FUBENPARAM_FUBEN_STEP_SYNC_ENUM,
  FUBENPARAM_FUBEN_GOAL_SYNC_ENUM,
  FUBENPARAM_FUBEN_CLEAR_SYNC_ENUM,
  FUBENPARAM_GUILD_RAID_USER_INFO_ENUM,
  FUBENPARAM_GUILD_RAID_GATE_OPT_ENUM,
  FUBENPARAM_GUILD_FIRE_INFO_ENUM,
  FUBENPARAM_GUILD_FIRE_STOP_ENUM,
  FUBENPARAM_GUILD_FIRE_DANGER_ENUM,
  FUBENPARAM_GUILD_FIRE_METALHP_ENUM,
  FUBENPARAM_GUILD_FIRE_CALM_ENUM,
  FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_ENUM,
  FUBENPARAM_GUILD_FIRE_RESTART_ENUM,
  FUBENPARAM_GUILD_FIRE_STATUS_ENUM,
  FUBENPARAM_GVG_DATA_SYNC_CMD_ENUM,
  FUBENPARAM_GVG_DATA_UPDATE_CMD_ENUM,
  FUBENPARAM_GUILD_FIRE_CHANGE_GUILD_NAME_ENUM,
  FUBENPARAM_MVPBATTLE_SYNC_MVPINFO_ENUM,
  FUBENPARAM_MVPBATTLE_BOSS_DIE_ENUM,
  FUBENPARAM_FUBEN_USERNUM_COUNT_ENUM,
  FUBENPARAM_SUPERGVG_INFO_SYNC_ENUM,
  FUBENPARAM_SUPERGVG_TOWERINFO_UPDATE_ENUM,
  FUBENPARAM_SUPERGVG_METALINFO_UPDATE_ENUM,
  FUBENPARAM_SUPERGVG_QUERY_TOWERINFO_ENUM,
  FUBENPARAM_SUPERGVG_REWARD_INFO_ENUM,
  FUBENPARAM_SUPERGVG_QUERY_USER_DATA_ENUM,
  FUBENPARAM_MVPBATTLE_END_REPORT_ENUM,
  FUBENPARAM_SUPERGVG_METAL_DIE_ENUM,
  FUBENPARAM_INVITE_SUMMON_DEADBOSS_ENUM,
  FUBENPARAM_REPLY_SUMMON_DEADBOSS_ENUM,
  FUBENPARAM_QUERY_RAID_TEAMPWS_USERINFO_ENUM,
  FUBENPARAM_TEAMPWS_END_REPORT_ENUM,
  FUBENPARAM_TEAMPWS_SYNC_INFO_ENUM,
  FUBENPARAM_TEAMPWS_SELECT_MAGIC_ENUM,
  FUBENPARAM_TEAMPWS_UPDATE_MAGIC_ENUM,
  FUBENPARAM_TEAMPWS_UPDATE_INFO_ENUM,
  FUBENPARAM_EXIT_RAID_CMD_ENUM,
  FUBENPARAM_BEGIN_FIRE_FUBENCMD_ENUM,
  FUBENPARAM_TEAMEXP_RAID_REPORT_ENUM,
  FUBENPARAM_TEAMEXP_BUY_ITEM_ENUM,
  FUBENPARAM_TEAMEXP_SYNC_CMD_ENUM,
  FUBENPARAM_TEAM_RELIVE_COUNT_ENUM,
  FUBENPARAM_TEAM_GROUP_RAID_CHIP_ENUM,
  FUBENPARAM_TEAM_GROUP_RAID_QUERY_INFO_ENUM,
  FUBENPARAM_TEAMEXP_QUERY_INFO_ENUM,
  FUBENPARAM_TEAM_GROUP_RAID_STATE_ENUM,
  FUBENPARAM_KUMAMOTO_OPER_CMD_ENUM,
  FUBENPARAM_TEAM_GROUP_FOURTH_QUERY_ENUM,
  FUBENPARAM_TEAM_GROUP_FOURTH_UPDATE_ENUM,
  FUBENPARAM_TEAM_GROUP_FOURTH_GOOUTER_ENUM,
  FUBENPARAM_RAID_STAGE_SYNC_ENUM,
  FUBENPARAM_THANKSGIVING_MONSTER_NUM_ENUM,
  FUBENPARAM_OTHELLO_POINT_OCCUPY_POWER_ENUM,
  FUBENPARAM_OTHELLO_SYNC_INFO_ENUM,
  FUBENPARAM_QUERY_RAID_OTHELLO_USERINFO_ENUM,
  FUBENPARAM_OTHELLO_END_REPORT_ENUM,
  FUBENPARAM_ROGUELIKE_SYNC_UNLOCKSCENES_ENUM,
  FUBENPARAM_TRANSFERFIGHT_CHOOSE_ENUM,
  FUBENPARAM_TRANSFERFIGHT_RANK_ENUM,
  FUBENPARAM_TRANSFERFIGHT_END_ENUM,
  FUBENPARAM_TWELVEPVP_DATA_SYNC_ENUM,
  FUBENPARAM_TWELVEPVP_ITEM_SYNC_ENUM,
  FUBENPARAM_TWELVEPVP_ITEM_UPDATE_ENUM,
  FUBENPARAM_TWELVEPVP_SHOP_UPDATE_ENUM,
  FUBENPARAM_TWELVEPVP_QUEST_QUERY_ENUM,
  FUBENPARAM_TWELVEPVP_GROUP_INFO_QUERY_ENUM,
  FUBENPARAM_TWELVEPVP_RESULT_ENUM,
  FUBENPARAM_TWELVEPVP_BUILDING_HP_UPDATE_ENUM,
  FUBENPARAM_TWELVEPVP_QUERY_UI_OPER_ENUM,
  FUBENPARAM_TWELVEPVP_USE_ITEM_ENUM,
  FUBENPARAM_INVITE_ROLL_RAID_REWARD_ENUM,
  FUBENPARAM_REPLY_ROLL_RAID_REARD_ENUM,
  FUBENPARAM_TEAMMEMBER_ROLL_PROCESS_ENUM,
  FUBENPARAM_PRE_REPLY_ROLL_RAID_REARD_ENUM,
  FUBENPARAM_RELIVE_CD_ENUM,
  FUBENPARAM_POS_SYNC_ENUM,
  FUBENPARAM_REQ_ENTER_TOWERPRIVATE_ENUM,
  FUBENPARAM_TOWERPRIVATE_LAYINFO_ENUM,
  FUBENPARAM_TOWERPRIVATE_LAYER_COUNTDOWN_NTF_ENUM,
  FUBENPARAM_FUBEN_RESULT_NTF_ENUM,
  FUBENPARAM_ENDTIME_SYNC_ENUM,
  FUBENPARAM_RESULT_SYNC_ENUM,
  FUBENPARAM_COMODO_PHASE_ENUM,
  FUBENPARAM_COMODO_STAT_ENUM,
  FUBENPARAM_TEAMPWS_STATE_SYNC_ENUM,
  FUBENPARAM_OBSERVER_FLASH_ENUM,
  FUBENPARAM_OBSERVER_ATTACH_ENUM,
  FUBENPARAM_OBSERVER_SELECT_ENUM,
  FUBENPARAM_OB_HPSP_UPDATE_ENUM,
  FUBENPARAM_OB_PLAYER_OFFLINE_ENUM,
  FUBENPARAM_MULTI_BOSS_PHASE_ENUM,
  FUBENPARAM_MULTI_BOSS_STAT_ENUM,
  FUBENPARAM_OB_CAMERA_MOVE_PREPARE_ENUM,
  FUBENPARAM_OB_CAMERA_MOVE_END_ENUM,
  FUBENPARAM_RAID_KILL_NUM_SYNC_ENUM,
  FUBENPARAM_PVE_PASS_INFO_ENUM,
  FUBENPARAM_GVG_POINT_STATE_UPDATE_ENUM,
  FUBENPARAM_GVG_CONSTRUCT_BUILDING_ENUM,
  FUBENPARAM_GVG_LEVELUP_BUILDING_ENUM,
  FUBENPARAM_GVG_CANCEL_BUILDING_ENUM,
  FUBENPARAM_GVG_STATE_UPDATE_ENUM,
  FUBENPARAM_GVG_USE_BUILDING_ENUM,
  FUBENPARAM_GVG_MORALE_UPDATE_ENUM,
  FUBENPARAM_PVE_RAID_ACHIEVE_ENUM,
  FUBENPARAM_QUICK_FINISH_CRACK_ENUM,
  FUBENPARAM_PICKUP_PVE_RAID_ACHIEVE_ENUM,
  FUBENPARAM_ADD_PVECARD_TIMES_ENUM,
  FUBENPARAM_SYNC_PVECARD_OPENSTATE_ENUM,
  FUBENPARAM_QUICK_FINISH_PVERAID_ENUM,
  FUBENPARAM_SYNC_PVECARD_DIFFTIMES_ENUM,
  FUBENPARAM_GVG_PERFECT_STATE_UPDATE_ENUM,
  FUBENPARAM_SYNC_BOSS_SCENE_BOSS_ENUM,
  FUBENPARAM_RESET_RAID_ENUM,
  FUBENPARAM_ELEMENT_RAID_STAT_ENUM,
  FUBENPARAM_SYNC_EMOTION_FACTORS_ENUM,
  FUBENPARAM_SYNC_VISIT_NPC_ENUM,
  FUBENPARAM_SYNC_UNLOCK_ROOMIDS_ENUM,
  FUBENPARAM_SYNC_MONSTER_COUNT_ENUM,
  FUBENPARAM_SKIL_ANIMATION_ENUM,
  FUBENPARAM_SYNC_STAR_ARK_INFO_ENUM,
  FUBENPARAM_SYNC_STAR_ARK_STATISTICS_ENUM,
  FUBENPARAM_OPEN_NTF_ENUM,
  FUBENPARAM_GVG_ROADBLOCK_CHANGE_ENUM,
  FUBENPARAM_SYNC_TRIPLE_FIRE_INFO_ENUM,
  FUBENPARAM_SYNC_TRIPLE_COMBO_KILL_ENUM,
  FUBENPARAM_SYNC_TRIPLE_PLAYER_MODEL_ENUM,
  FUBENPARAM_SYNC_TRIPLE_PROFESSION_TIME_ENUM,
  FUBENPARAM_SYNC_TRIPLE_CAMP_INFO_ENUM,
  FUBENPARAM_SYNC_TRIPLE_ENTER_COUNT_ENUM,
  FUBENPARAM_SYNC_PASS_USER_ENUM,
  FUBENPARAM_CHOOSE_CUR_PROFESSION_ENUM,
  FUBENPARAM_SYNC_TRIPLE_FIGHTING_INFO_ENUM,
  FUBENPARAM_SYNC_FULL_FIRE_STATE_ENUM,
  FUBENPARAM_EBF_EVENT_DATA_UPDATE_ENUM,
  FUBENPARAM_EBF_MISC_DATA_UPDATE_ENUM,
  FUBENPARAM_OCCUPY_POINT_DATA_UPDATE_ENUM,
  FUBENPARAM_QUERY_PVP_STAT_ENUM,
  FUBENPARAM_EBF_KICK_TIME_ENUM,
  FUBENPARAM_EBF_CONTINUE_ENUM,
  FUBENPARAM_EBF_EVENT_AREA_UPDATE_ENUM,
  FUBENPARAM_ASTRAL_INFO_SYNC_ENUM,
  FUBENPARAM_GVG_MVP_INFO_UPDATE_ENUM,
  FUBENPARAM_ASTRAL_PRAY_BRANCH_SYNC_ENUM,
  FUBENPARAM_SYNC_START_FIGHT_STATE_ENUM,
  FUBENPARAM_SYNC_GVG_FIGHT_POINT_ENUM,
  FUBENPARAM_SYNC_GVG_LEADER_POS_ENUM,
  FUBENPARAM_STI_SYNC_SCORE_ENUM,
  FUBENPARAM_STI_SYNC_SKILL_ENUM,
  FUBENPARAM_STI_SYNC_AVAILABLE_UPGRADE_NUMBER_ENUM,
  FUBENPARAM_STI_GET_SKILL_UPGRADE_OPTIONS_ENUM,
  FUBENPARAM_STI_RET_SKILL_UPGRADE_OPTIONS_ENUM,
  FUBENPARAM_STI_EXEC_SKILL_UPGRADE_ENUM,
  FUBENPARAM_SYNC_SPACETIME_ILLUSION_INFO_ENUM,
  FUBENPARAM_SYNC_SPACETIME_ILLUSION_EXP_LEVEL_ENUM,
  FUBENPARAM_STI_REFRESH_SKILL_UPGRADE_OPTIONS_ENUM,
  FUBENPARAM_STI_DROP_SKILL_ENUM,
  FUBENPARAM_FAIRY_TALE_RAID_SYNC_ENUM,
  FUBENPARAM_RAID_START_FIGHT_ENUM,
  FUBENPARAM_GVG_DATE_BATTLE_INFO_SYNC_ENUM,
  FUBENPARAM_FAIRY_TALE_RAID_REWARD_SYNC_ENUM,
  FUBENPARAM_FAIRY_TALE_RAID_GET_REWARD_ENUM,
  FUBENPARAM_SYNC_MEMORY_EQUIP_REWARD_INFO_ENUM,
  FUBENPARAM_CHOOSE_MEMORY_EQUIP_REWARD_INFO_ENUM
}
ERAIDTYPE_ERAIDTYPE_MIN_ENUM.name = "ERAIDTYPE_MIN"
ERAIDTYPE_ERAIDTYPE_MIN_ENUM.index = 0
ERAIDTYPE_ERAIDTYPE_MIN_ENUM.number = 0
ERAIDTYPE_ERAIDTYPE_FERRISWHEEL_ENUM.name = "ERAIDTYPE_FERRISWHEEL"
ERAIDTYPE_ERAIDTYPE_FERRISWHEEL_ENUM.index = 1
ERAIDTYPE_ERAIDTYPE_FERRISWHEEL_ENUM.number = 1
ERAIDTYPE_ERAIDTYPE_NORMAL_ENUM.name = "ERAIDTYPE_NORMAL"
ERAIDTYPE_ERAIDTYPE_NORMAL_ENUM.index = 2
ERAIDTYPE_ERAIDTYPE_NORMAL_ENUM.number = 2
ERAIDTYPE_ERAIDTYPE_EXCHANGE_ENUM.name = "ERAIDTYPE_EXCHANGE"
ERAIDTYPE_ERAIDTYPE_EXCHANGE_ENUM.index = 3
ERAIDTYPE_ERAIDTYPE_EXCHANGE_ENUM.number = 3
ERAIDTYPE_ERAIDTYPE_TOWER_ENUM.name = "ERAIDTYPE_TOWER"
ERAIDTYPE_ERAIDTYPE_TOWER_ENUM.index = 4
ERAIDTYPE_ERAIDTYPE_TOWER_ENUM.number = 4
ERAIDTYPE_ERAIDTYPE_LABORATORY_ENUM.name = "ERAIDTYPE_LABORATORY"
ERAIDTYPE_ERAIDTYPE_LABORATORY_ENUM.index = 5
ERAIDTYPE_ERAIDTYPE_LABORATORY_ENUM.number = 5
ERAIDTYPE_ERAIDTYPE_EXCHANGEGALLERY_ENUM.name = "ERAIDTYPE_EXCHANGEGALLERY"
ERAIDTYPE_ERAIDTYPE_EXCHANGEGALLERY_ENUM.index = 6
ERAIDTYPE_ERAIDTYPE_EXCHANGEGALLERY_ENUM.number = 6
ERAIDTYPE_ERAIDTYPE_SEAL_ENUM.name = "ERAIDTYPE_SEAL"
ERAIDTYPE_ERAIDTYPE_SEAL_ENUM.index = 7
ERAIDTYPE_ERAIDTYPE_SEAL_ENUM.number = 7
ERAIDTYPE_ERAIDTYPE_RAIDTEMP2_ENUM.name = "ERAIDTYPE_RAIDTEMP2"
ERAIDTYPE_ERAIDTYPE_RAIDTEMP2_ENUM.index = 8
ERAIDTYPE_ERAIDTYPE_RAIDTEMP2_ENUM.number = 8
ERAIDTYPE_ERAIDTYPE_DOJO_ENUM.name = "ERAIDTYPE_DOJO"
ERAIDTYPE_ERAIDTYPE_DOJO_ENUM.index = 9
ERAIDTYPE_ERAIDTYPE_DOJO_ENUM.number = 9
ERAIDTYPE_ERAIDTYPE_GUILD_ENUM.name = "ERAIDTYPE_GUILD"
ERAIDTYPE_ERAIDTYPE_GUILD_ENUM.index = 10
ERAIDTYPE_ERAIDTYPE_GUILD_ENUM.number = 10
ERAIDTYPE_ERAIDTYPE_RAIDTEMP4_ENUM.name = "ERAIDTYPE_RAIDTEMP4"
ERAIDTYPE_ERAIDTYPE_RAIDTEMP4_ENUM.index = 11
ERAIDTYPE_ERAIDTYPE_RAIDTEMP4_ENUM.number = 11
ERAIDTYPE_ERAIDTYPE_ITEMIMAGE_ENUM.name = "ERAIDTYPE_ITEMIMAGE"
ERAIDTYPE_ERAIDTYPE_ITEMIMAGE_ENUM.index = 12
ERAIDTYPE_ERAIDTYPE_ITEMIMAGE_ENUM.number = 12
ERAIDTYPE_ERAIDTYPE_GUILDRAID_ENUM.name = "ERAIDTYPE_GUILDRAID"
ERAIDTYPE_ERAIDTYPE_GUILDRAID_ENUM.index = 13
ERAIDTYPE_ERAIDTYPE_GUILDRAID_ENUM.number = 13
ERAIDTYPE_ERAIDTYPE_GUILDFIRE_ENUM.name = "ERAIDTYPE_GUILDFIRE"
ERAIDTYPE_ERAIDTYPE_GUILDFIRE_ENUM.index = 14
ERAIDTYPE_ERAIDTYPE_GUILDFIRE_ENUM.number = 14
ERAIDTYPE_ERAIDTYPE_PVP_LLH_ENUM.name = "ERAIDTYPE_PVP_LLH"
ERAIDTYPE_ERAIDTYPE_PVP_LLH_ENUM.index = 15
ERAIDTYPE_ERAIDTYPE_PVP_LLH_ENUM.number = 21
ERAIDTYPE_ERAIDTYPE_PVP_SMZL_ENUM.name = "ERAIDTYPE_PVP_SMZL"
ERAIDTYPE_ERAIDTYPE_PVP_SMZL_ENUM.index = 16
ERAIDTYPE_ERAIDTYPE_PVP_SMZL_ENUM.number = 22
ERAIDTYPE_ERAIDTYPE_PVP_HLJS_ENUM.name = "ERAIDTYPE_PVP_HLJS"
ERAIDTYPE_ERAIDTYPE_PVP_HLJS_ENUM.index = 17
ERAIDTYPE_ERAIDTYPE_PVP_HLJS_ENUM.number = 23
ERAIDTYPE_ERAIDTYPE_DATELAND_ENUM.name = "ERAIDTYPE_DATELAND"
ERAIDTYPE_ERAIDTYPE_DATELAND_ENUM.index = 18
ERAIDTYPE_ERAIDTYPE_DATELAND_ENUM.number = 24
ERAIDTYPE_ERAIDTYPE_PVP_POLLY_ENUM.name = "ERAIDTYPE_PVP_POLLY"
ERAIDTYPE_ERAIDTYPE_PVP_POLLY_ENUM.index = 19
ERAIDTYPE_ERAIDTYPE_PVP_POLLY_ENUM.number = 25
ERAIDTYPE_ERAIDTYPE_WEDDING_ENUM.name = "ERAIDTYPE_WEDDING"
ERAIDTYPE_ERAIDTYPE_WEDDING_ENUM.index = 20
ERAIDTYPE_ERAIDTYPE_WEDDING_ENUM.number = 26
ERAIDTYPE_ERAIDTYPE_DIVORCE_ROLLER_COASTER_ENUM.name = "ERAIDTYPE_DIVORCE_ROLLER_COASTER"
ERAIDTYPE_ERAIDTYPE_DIVORCE_ROLLER_COASTER_ENUM.index = 21
ERAIDTYPE_ERAIDTYPE_DIVORCE_ROLLER_COASTER_ENUM.number = 27
ERAIDTYPE_ERAIDTYPE_PVECARD_ENUM.name = "ERAIDTYPE_PVECARD"
ERAIDTYPE_ERAIDTYPE_PVECARD_ENUM.index = 22
ERAIDTYPE_ERAIDTYPE_PVECARD_ENUM.number = 28
ERAIDTYPE_ERAIDTYPE_MVPBATTLE_ENUM.name = "ERAIDTYPE_MVPBATTLE"
ERAIDTYPE_ERAIDTYPE_MVPBATTLE_ENUM.index = 23
ERAIDTYPE_ERAIDTYPE_MVPBATTLE_ENUM.number = 29
ERAIDTYPE_ERAIDTYPE_SUPERGVG_ENUM.name = "ERAIDTYPE_SUPERGVG"
ERAIDTYPE_ERAIDTYPE_SUPERGVG_ENUM.index = 24
ERAIDTYPE_ERAIDTYPE_SUPERGVG_ENUM.number = 30
ERAIDTYPE_ERAIDTYPE_ALTMAN_ENUM.name = "ERAIDTYPE_ALTMAN"
ERAIDTYPE_ERAIDTYPE_ALTMAN_ENUM.index = 25
ERAIDTYPE_ERAIDTYPE_ALTMAN_ENUM.number = 31
ERAIDTYPE_ERAIDTYPE_TEAMPWS_ENUM.name = "ERAIDTYPE_TEAMPWS"
ERAIDTYPE_ERAIDTYPE_TEAMPWS_ENUM.index = 26
ERAIDTYPE_ERAIDTYPE_TEAMPWS_ENUM.number = 32
ERAIDTYPE_ERAIDTYPE_TEAMEXP_ENUM.name = "ERAIDTYPE_TEAMEXP"
ERAIDTYPE_ERAIDTYPE_TEAMEXP_ENUM.index = 27
ERAIDTYPE_ERAIDTYPE_TEAMEXP_ENUM.number = 34
ERAIDTYPE_ERAIDTYPE_THANATOS_ENUM.name = "ERAIDTYPE_THANATOS"
ERAIDTYPE_ERAIDTYPE_THANATOS_ENUM.index = 28
ERAIDTYPE_ERAIDTYPE_THANATOS_ENUM.number = 35
ERAIDTYPE_ERAIDTYPE_THANATOS_MID_ENUM.name = "ERAIDTYPE_THANATOS_MID"
ERAIDTYPE_ERAIDTYPE_THANATOS_MID_ENUM.index = 29
ERAIDTYPE_ERAIDTYPE_THANATOS_MID_ENUM.number = 36
ERAIDTYPE_ERAIDTYPE_HOUSE_ENUM.name = "ERAIDTYPE_HOUSE"
ERAIDTYPE_ERAIDTYPE_HOUSE_ENUM.index = 30
ERAIDTYPE_ERAIDTYPE_HOUSE_ENUM.number = 37
ERAIDTYPE_ERAIDTYPE_THANATOS_SCENE3_ENUM.name = "ERAIDTYPE_THANATOS_SCENE3"
ERAIDTYPE_ERAIDTYPE_THANATOS_SCENE3_ENUM.index = 31
ERAIDTYPE_ERAIDTYPE_THANATOS_SCENE3_ENUM.number = 38
ERAIDTYPE_ERAIDTYPE_KUMAMOTO_ENUM.name = "ERAIDTYPE_KUMAMOTO"
ERAIDTYPE_ERAIDTYPE_KUMAMOTO_ENUM.index = 32
ERAIDTYPE_ERAIDTYPE_KUMAMOTO_ENUM.number = 39
ERAIDTYPE_ERAIDTYPE_THANATOS_FOURTH_ENUM.name = "ERAIDTYPE_THANATOS_FOURTH"
ERAIDTYPE_ERAIDTYPE_THANATOS_FOURTH_ENUM.index = 33
ERAIDTYPE_ERAIDTYPE_THANATOS_FOURTH_ENUM.number = 40
ERAIDTYPE_ERAIDTYPE_GARDEN_ENUM.name = "ERAIDTYPE_GARDEN"
ERAIDTYPE_ERAIDTYPE_GARDEN_ENUM.index = 34
ERAIDTYPE_ERAIDTYPE_GARDEN_ENUM.number = 41
ERAIDTYPE_ERAIDTYPE_THANKSGIVING_ENUM.name = "ERAIDTYPE_THANKSGIVING"
ERAIDTYPE_ERAIDTYPE_THANKSGIVING_ENUM.index = 35
ERAIDTYPE_ERAIDTYPE_THANKSGIVING_ENUM.number = 42
ERAIDTYPE_ERAIDTYPE_HEADWEAR_ENUM.name = "ERAIDTYPE_HEADWEAR"
ERAIDTYPE_ERAIDTYPE_HEADWEAR_ENUM.index = 36
ERAIDTYPE_ERAIDTYPE_HEADWEAR_ENUM.number = 43
ERAIDTYPE_ERAIDTYPE_OTHELLO_ENUM.name = "ERAIDTYPE_OTHELLO"
ERAIDTYPE_ERAIDTYPE_OTHELLO_ENUM.index = 37
ERAIDTYPE_ERAIDTYPE_OTHELLO_ENUM.number = 44
ERAIDTYPE_ERAIDTYPE_SPRING_ENUM.name = "ERAIDTYPE_SPRING"
ERAIDTYPE_ERAIDTYPE_SPRING_ENUM.index = 38
ERAIDTYPE_ERAIDTYPE_SPRING_ENUM.number = 45
ERAIDTYPE_ERAIDTYPE_ROGUELIKE_ENUM.name = "ERAIDTYPE_ROGUELIKE"
ERAIDTYPE_ERAIDTYPE_ROGUELIKE_ENUM.index = 39
ERAIDTYPE_ERAIDTYPE_ROGUELIKE_ENUM.number = 46
ERAIDTYPE_ERAIDTYPE_MONSTER_ANSWER_ENUM.name = "ERAIDTYPE_MONSTER_ANSWER"
ERAIDTYPE_ERAIDTYPE_MONSTER_ANSWER_ENUM.index = 40
ERAIDTYPE_ERAIDTYPE_MONSTER_ANSWER_ENUM.number = 47
ERAIDTYPE_ERAIDTYPE_MONSTER_PHOTO_ENUM.name = "ERAIDTYPE_MONSTER_PHOTO"
ERAIDTYPE_ERAIDTYPE_MONSTER_PHOTO_ENUM.index = 41
ERAIDTYPE_ERAIDTYPE_MONSTER_PHOTO_ENUM.number = 48
ERAIDTYPE_ERAIDTYPE_TRANSFERFIGHT_ENUM.name = "ERAIDTYPE_TRANSFERFIGHT"
ERAIDTYPE_ERAIDTYPE_TRANSFERFIGHT_ENUM.index = 42
ERAIDTYPE_ERAIDTYPE_TRANSFERFIGHT_ENUM.number = 49
ERAIDTYPE_ERAIDTYPE_TWELVE_PVP_ENUM.name = "ERAIDTYPE_TWELVE_PVP"
ERAIDTYPE_ERAIDTYPE_TWELVE_PVP_ENUM.index = 43
ERAIDTYPE_ERAIDTYPE_TWELVE_PVP_ENUM.number = 50
ERAIDTYPE_ERAIDTYPE_DEADBOSS_ENUM.name = "ERAIDTYPE_DEADBOSS"
ERAIDTYPE_ERAIDTYPE_DEADBOSS_ENUM.index = 44
ERAIDTYPE_ERAIDTYPE_DEADBOSS_ENUM.number = 51
ERAIDTYPE_ERAIDTYPE_EINHERJAR_ENUM.name = "ERAIDTYPE_EINHERJAR"
ERAIDTYPE_ERAIDTYPE_EINHERJAR_ENUM.index = 45
ERAIDTYPE_ERAIDTYPE_EINHERJAR_ENUM.number = 52
ERAIDTYPE_ERAIDTYPE_QTE_CHASING_ENUM.name = "ERAIDTYPE_QTE_CHASING"
ERAIDTYPE_ERAIDTYPE_QTE_CHASING_ENUM.index = 46
ERAIDTYPE_ERAIDTYPE_QTE_CHASING_ENUM.number = 53
ERAIDTYPE_ERAIDTYPE_SLAYERS_ENUM.name = "ERAIDTYPE_SLAYERS"
ERAIDTYPE_ERAIDTYPE_SLAYERS_ENUM.index = 47
ERAIDTYPE_ERAIDTYPE_SLAYERS_ENUM.number = 54
ERAIDTYPE_ERAIDTYPE_ENDLESSTOWER_PRIVATE_ENUM.name = "ERAIDTYPE_ENDLESSTOWER_PRIVATE"
ERAIDTYPE_ERAIDTYPE_ENDLESSTOWER_PRIVATE_ENUM.index = 48
ERAIDTYPE_ERAIDTYPE_ENDLESSTOWER_PRIVATE_ENUM.number = 55
ERAIDTYPE_ERAIDTYPE_JANUARY_ENUM.name = "ERAIDTYPE_JANUARY"
ERAIDTYPE_ERAIDTYPE_JANUARY_ENUM.index = 49
ERAIDTYPE_ERAIDTYPE_JANUARY_ENUM.number = 56
ERAIDTYPE_ERAIDTYPE_MAY_ENUM.name = "ERAIDTYPE_MAY"
ERAIDTYPE_ERAIDTYPE_MAY_ENUM.index = 50
ERAIDTYPE_ERAIDTYPE_MAY_ENUM.number = 57
ERAIDTYPE_ERAIDTYPE_COMODO_TEAM_RAID_ENUM.name = "ERAIDTYPE_COMODO_TEAM_RAID"
ERAIDTYPE_ERAIDTYPE_COMODO_TEAM_RAID_ENUM.index = 51
ERAIDTYPE_ERAIDTYPE_COMODO_TEAM_RAID_ENUM.number = 59
ERAIDTYPE_ERAIDTYPE_MANOR_ENUM.name = "ERAIDTYPE_MANOR"
ERAIDTYPE_ERAIDTYPE_MANOR_ENUM.index = 52
ERAIDTYPE_ERAIDTYPE_MANOR_ENUM.number = 60
ERAIDTYPE_ERAIDTYPE_DISNEY_MUSIC_ENUM.name = "ERAIDTYPE_DISNEY_MUSIC"
ERAIDTYPE_ERAIDTYPE_DISNEY_MUSIC_ENUM.index = 53
ERAIDTYPE_ERAIDTYPE_DISNEY_MUSIC_ENUM.number = 61
ERAIDTYPE_ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID_ENUM.name = "ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID"
ERAIDTYPE_ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID_ENUM.index = 54
ERAIDTYPE_ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID_ENUM.number = 62
ERAIDTYPE_ERAIDTYPE_HEART_LOCK_ENUM.name = "ERAIDTYPE_HEART_LOCK"
ERAIDTYPE_ERAIDTYPE_HEART_LOCK_ENUM.index = 55
ERAIDTYPE_ERAIDTYPE_HEART_LOCK_ENUM.number = 63
ERAIDTYPE_ERAIDTYPE_HEADWEARACTIVITY_ENUM.name = "ERAIDTYPE_HEADWEARACTIVITY"
ERAIDTYPE_ERAIDTYPE_HEADWEARACTIVITY_ENUM.index = 56
ERAIDTYPE_ERAIDTYPE_HEADWEARACTIVITY_ENUM.number = 64
ERAIDTYPE_ERAIDTYPE_CRACK_ENUM.name = "ERAIDTYPE_CRACK"
ERAIDTYPE_ERAIDTYPE_CRACK_ENUM.index = 57
ERAIDTYPE_ERAIDTYPE_CRACK_ENUM.number = 65
ERAIDTYPE_ERAIDTYPE_GVG_LOBBY_ENUM.name = "ERAIDTYPE_GVG_LOBBY"
ERAIDTYPE_ERAIDTYPE_GVG_LOBBY_ENUM.index = 58
ERAIDTYPE_ERAIDTYPE_GVG_LOBBY_ENUM.number = 66
ERAIDTYPE_ERAIDTYPE_PROFESSION_TRIAL_ENUM.name = "ERAIDTYPE_PROFESSION_TRIAL"
ERAIDTYPE_ERAIDTYPE_PROFESSION_TRIAL_ENUM.index = 59
ERAIDTYPE_ERAIDTYPE_PROFESSION_TRIAL_ENUM.number = 67
ERAIDTYPE_ERAIDTYPE_BOSS_ENUM.name = "ERAIDTYPE_BOSS"
ERAIDTYPE_ERAIDTYPE_BOSS_ENUM.index = 60
ERAIDTYPE_ERAIDTYPE_BOSS_ENUM.number = 68
ERAIDTYPE_ERAIDTYPE_EQUIP_UP_ENUM.name = "ERAIDTYPE_EQUIP_UP"
ERAIDTYPE_ERAIDTYPE_EQUIP_UP_ENUM.index = 61
ERAIDTYPE_ERAIDTYPE_EQUIP_UP_ENUM.number = 69
ERAIDTYPE_ERAIDTYPE_ELEMENT_ENUM.name = "ERAIDTYPE_ELEMENT"
ERAIDTYPE_ERAIDTYPE_ELEMENT_ENUM.index = 62
ERAIDTYPE_ERAIDTYPE_ELEMENT_ENUM.number = 70
ERAIDTYPE_ERAIDTYPE_STAR_ARK_ENUM.name = "ERAIDTYPE_STAR_ARK"
ERAIDTYPE_ERAIDTYPE_STAR_ARK_ENUM.index = 63
ERAIDTYPE_ERAIDTYPE_STAR_ARK_ENUM.number = 71
ERAIDTYPE_ERAIDTYPE_TRIPLE_PVP_ENUM.name = "ERAIDTYPE_TRIPLE_PVP"
ERAIDTYPE_ERAIDTYPE_TRIPLE_PVP_ENUM.index = 64
ERAIDTYPE_ERAIDTYPE_TRIPLE_PVP_ENUM.number = 72
ERAIDTYPE_ERAIDTYPE_COMMON_MATERIALS_ENUM.name = "ERAIDTYPE_COMMON_MATERIALS"
ERAIDTYPE_ERAIDTYPE_COMMON_MATERIALS_ENUM.index = 65
ERAIDTYPE_ERAIDTYPE_COMMON_MATERIALS_ENUM.number = 73
ERAIDTYPE_ERAIDTYPE_MEMORY_PALACE_ENUM.name = "ERAIDTYPE_MEMORY_PALACE"
ERAIDTYPE_ERAIDTYPE_MEMORY_PALACE_ENUM.index = 66
ERAIDTYPE_ERAIDTYPE_MEMORY_PALACE_ENUM.number = 74
ERAIDTYPE_ERAIDTYPE_ENDLESS_BATTLE_FIELD_ENUM.name = "ERAIDTYPE_ENDLESS_BATTLE_FIELD"
ERAIDTYPE_ERAIDTYPE_ENDLESS_BATTLE_FIELD_ENUM.index = 67
ERAIDTYPE_ERAIDTYPE_ENDLESS_BATTLE_FIELD_ENUM.number = 75
ERAIDTYPE_ERAIDTYPE_HERO_JOURNEY_ENUM.name = "ERAIDTYPE_HERO_JOURNEY"
ERAIDTYPE_ERAIDTYPE_HERO_JOURNEY_ENUM.index = 68
ERAIDTYPE_ERAIDTYPE_HERO_JOURNEY_ENUM.number = 76
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_ENUM.name = "ERAIDTYPE_GUILD_DATE_BATTLE"
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_ENUM.index = 69
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_ENUM.number = 77
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY_ENUM.name = "ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY"
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY_ENUM.index = 70
ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY_ENUM.number = 78
ERAIDTYPE_ERAIDTYPE_ASTRAL_ENUM.name = "ERAIDTYPE_ASTRAL"
ERAIDTYPE_ERAIDTYPE_ASTRAL_ENUM.index = 71
ERAIDTYPE_ERAIDTYPE_ASTRAL_ENUM.number = 79
ERAIDTYPE_ERAIDTYPE_MEMORY_RAID_ENUM.name = "ERAIDTYPE_MEMORY_RAID"
ERAIDTYPE_ERAIDTYPE_MEMORY_RAID_ENUM.index = 72
ERAIDTYPE_ERAIDTYPE_MEMORY_RAID_ENUM.number = 80
ERAIDTYPE_ERAIDTYPE_SPACETIME_ILLUSION_ENUM.name = "ERAIDTYPE_SPACETIME_ILLUSION"
ERAIDTYPE_ERAIDTYPE_SPACETIME_ILLUSION_ENUM.index = 73
ERAIDTYPE_ERAIDTYPE_SPACETIME_ILLUSION_ENUM.number = 81
ERAIDTYPE_ERAIDTYPE_FAIRY_TALE_ENUM.name = "ERAIDTYPE_FAIRY_TALE"
ERAIDTYPE_ERAIDTYPE_FAIRY_TALE_ENUM.index = 74
ERAIDTYPE_ERAIDTYPE_FAIRY_TALE_ENUM.number = 82
ERAIDTYPE_ERAIDTYPE_ABYSS_DRAGON_ENUM.name = "ERAIDTYPE_ABYSS_DRAGON"
ERAIDTYPE_ERAIDTYPE_ABYSS_DRAGON_ENUM.index = 75
ERAIDTYPE_ERAIDTYPE_ABYSS_DRAGON_ENUM.number = 83
ERAIDTYPE_ERAIDTYPE_MAX_ENUM.name = "ERAIDTYPE_MAX"
ERAIDTYPE_ERAIDTYPE_MAX_ENUM.index = 76
ERAIDTYPE_ERAIDTYPE_MAX_ENUM.number = 84
ERAIDTYPE.name = "ERaidType"
ERAIDTYPE.full_name = ".Cmd.ERaidType"
ERAIDTYPE.values = {
  ERAIDTYPE_ERAIDTYPE_MIN_ENUM,
  ERAIDTYPE_ERAIDTYPE_FERRISWHEEL_ENUM,
  ERAIDTYPE_ERAIDTYPE_NORMAL_ENUM,
  ERAIDTYPE_ERAIDTYPE_EXCHANGE_ENUM,
  ERAIDTYPE_ERAIDTYPE_TOWER_ENUM,
  ERAIDTYPE_ERAIDTYPE_LABORATORY_ENUM,
  ERAIDTYPE_ERAIDTYPE_EXCHANGEGALLERY_ENUM,
  ERAIDTYPE_ERAIDTYPE_SEAL_ENUM,
  ERAIDTYPE_ERAIDTYPE_RAIDTEMP2_ENUM,
  ERAIDTYPE_ERAIDTYPE_DOJO_ENUM,
  ERAIDTYPE_ERAIDTYPE_GUILD_ENUM,
  ERAIDTYPE_ERAIDTYPE_RAIDTEMP4_ENUM,
  ERAIDTYPE_ERAIDTYPE_ITEMIMAGE_ENUM,
  ERAIDTYPE_ERAIDTYPE_GUILDRAID_ENUM,
  ERAIDTYPE_ERAIDTYPE_GUILDFIRE_ENUM,
  ERAIDTYPE_ERAIDTYPE_PVP_LLH_ENUM,
  ERAIDTYPE_ERAIDTYPE_PVP_SMZL_ENUM,
  ERAIDTYPE_ERAIDTYPE_PVP_HLJS_ENUM,
  ERAIDTYPE_ERAIDTYPE_DATELAND_ENUM,
  ERAIDTYPE_ERAIDTYPE_PVP_POLLY_ENUM,
  ERAIDTYPE_ERAIDTYPE_WEDDING_ENUM,
  ERAIDTYPE_ERAIDTYPE_DIVORCE_ROLLER_COASTER_ENUM,
  ERAIDTYPE_ERAIDTYPE_PVECARD_ENUM,
  ERAIDTYPE_ERAIDTYPE_MVPBATTLE_ENUM,
  ERAIDTYPE_ERAIDTYPE_SUPERGVG_ENUM,
  ERAIDTYPE_ERAIDTYPE_ALTMAN_ENUM,
  ERAIDTYPE_ERAIDTYPE_TEAMPWS_ENUM,
  ERAIDTYPE_ERAIDTYPE_TEAMEXP_ENUM,
  ERAIDTYPE_ERAIDTYPE_THANATOS_ENUM,
  ERAIDTYPE_ERAIDTYPE_THANATOS_MID_ENUM,
  ERAIDTYPE_ERAIDTYPE_HOUSE_ENUM,
  ERAIDTYPE_ERAIDTYPE_THANATOS_SCENE3_ENUM,
  ERAIDTYPE_ERAIDTYPE_KUMAMOTO_ENUM,
  ERAIDTYPE_ERAIDTYPE_THANATOS_FOURTH_ENUM,
  ERAIDTYPE_ERAIDTYPE_GARDEN_ENUM,
  ERAIDTYPE_ERAIDTYPE_THANKSGIVING_ENUM,
  ERAIDTYPE_ERAIDTYPE_HEADWEAR_ENUM,
  ERAIDTYPE_ERAIDTYPE_OTHELLO_ENUM,
  ERAIDTYPE_ERAIDTYPE_SPRING_ENUM,
  ERAIDTYPE_ERAIDTYPE_ROGUELIKE_ENUM,
  ERAIDTYPE_ERAIDTYPE_MONSTER_ANSWER_ENUM,
  ERAIDTYPE_ERAIDTYPE_MONSTER_PHOTO_ENUM,
  ERAIDTYPE_ERAIDTYPE_TRANSFERFIGHT_ENUM,
  ERAIDTYPE_ERAIDTYPE_TWELVE_PVP_ENUM,
  ERAIDTYPE_ERAIDTYPE_DEADBOSS_ENUM,
  ERAIDTYPE_ERAIDTYPE_EINHERJAR_ENUM,
  ERAIDTYPE_ERAIDTYPE_QTE_CHASING_ENUM,
  ERAIDTYPE_ERAIDTYPE_SLAYERS_ENUM,
  ERAIDTYPE_ERAIDTYPE_ENDLESSTOWER_PRIVATE_ENUM,
  ERAIDTYPE_ERAIDTYPE_JANUARY_ENUM,
  ERAIDTYPE_ERAIDTYPE_MAY_ENUM,
  ERAIDTYPE_ERAIDTYPE_COMODO_TEAM_RAID_ENUM,
  ERAIDTYPE_ERAIDTYPE_MANOR_ENUM,
  ERAIDTYPE_ERAIDTYPE_DISNEY_MUSIC_ENUM,
  ERAIDTYPE_ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID_ENUM,
  ERAIDTYPE_ERAIDTYPE_HEART_LOCK_ENUM,
  ERAIDTYPE_ERAIDTYPE_HEADWEARACTIVITY_ENUM,
  ERAIDTYPE_ERAIDTYPE_CRACK_ENUM,
  ERAIDTYPE_ERAIDTYPE_GVG_LOBBY_ENUM,
  ERAIDTYPE_ERAIDTYPE_PROFESSION_TRIAL_ENUM,
  ERAIDTYPE_ERAIDTYPE_BOSS_ENUM,
  ERAIDTYPE_ERAIDTYPE_EQUIP_UP_ENUM,
  ERAIDTYPE_ERAIDTYPE_ELEMENT_ENUM,
  ERAIDTYPE_ERAIDTYPE_STAR_ARK_ENUM,
  ERAIDTYPE_ERAIDTYPE_TRIPLE_PVP_ENUM,
  ERAIDTYPE_ERAIDTYPE_COMMON_MATERIALS_ENUM,
  ERAIDTYPE_ERAIDTYPE_MEMORY_PALACE_ENUM,
  ERAIDTYPE_ERAIDTYPE_ENDLESS_BATTLE_FIELD_ENUM,
  ERAIDTYPE_ERAIDTYPE_HERO_JOURNEY_ENUM,
  ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_ENUM,
  ERAIDTYPE_ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY_ENUM,
  ERAIDTYPE_ERAIDTYPE_ASTRAL_ENUM,
  ERAIDTYPE_ERAIDTYPE_MEMORY_RAID_ENUM,
  ERAIDTYPE_ERAIDTYPE_SPACETIME_ILLUSION_ENUM,
  ERAIDTYPE_ERAIDTYPE_FAIRY_TALE_ENUM,
  ERAIDTYPE_ERAIDTYPE_ABYSS_DRAGON_ENUM,
  ERAIDTYPE_ERAIDTYPE_MAX_ENUM
}
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_NORMAL_ENUM.name = "EEENDLESSPRIVATE_MONSTER_NORMAL"
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_NORMAL_ENUM.index = 0
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_NORMAL_ENUM.number = 0
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_ADVANCE_ENUM.name = "EEENDLESSPRIVATE_MONSTER_ADVANCE"
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_ADVANCE_ENUM.index = 1
EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_ADVANCE_ENUM.number = 1
EENDLESSPRIVATEMONSTERTYPE.name = "EEndlessPrivateMonsterType"
EENDLESSPRIVATEMONSTERTYPE.full_name = ".Cmd.EEndlessPrivateMonsterType"
EENDLESSPRIVATEMONSTERTYPE.values = {
  EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_NORMAL_ENUM,
  EENDLESSPRIVATEMONSTERTYPE_EEENDLESSPRIVATE_MONSTER_ADVANCE_ENUM
}
EPVEGROUPTYPE_EPVEGROUPTYPE_MIN_ENUM.name = "EPVEGROUPTYPE_MIN"
EPVEGROUPTYPE_EPVEGROUPTYPE_MIN_ENUM.index = 0
EPVEGROUPTYPE_EPVEGROUPTYPE_MIN_ENUM.number = 0
EPVEGROUPTYPE_EPVEGROUPTYPE_COMODO_ENUM.name = "EPVEGROUPTYPE_COMODO"
EPVEGROUPTYPE_EPVEGROUPTYPE_COMODO_ENUM.index = 1
EPVEGROUPTYPE_EPVEGROUPTYPE_COMODO_ENUM.number = 1
EPVEGROUPTYPE_EPVEGROUPTYPE_MULTIBOSS_ENUM.name = "EPVEGROUPTYPE_MULTIBOSS"
EPVEGROUPTYPE_EPVEGROUPTYPE_MULTIBOSS_ENUM.index = 2
EPVEGROUPTYPE_EPVEGROUPTYPE_MULTIBOSS_ENUM.number = 2
EPVEGROUPTYPE_EPVEGROUPTYPE_HEADWEAR_ENUM.name = "EPVEGROUPTYPE_HEADWEAR"
EPVEGROUPTYPE_EPVEGROUPTYPE_HEADWEAR_ENUM.index = 3
EPVEGROUPTYPE_EPVEGROUPTYPE_HEADWEAR_ENUM.number = 3
EPVEGROUPTYPE_EPVEGROUPTYPE_CARD_ENUM.name = "EPVEGROUPTYPE_CARD"
EPVEGROUPTYPE_EPVEGROUPTYPE_CARD_ENUM.index = 4
EPVEGROUPTYPE_EPVEGROUPTYPE_CARD_ENUM.number = 4
EPVEGROUPTYPE_EPVEGROUPTYPE_ENDLESS_ENUM.name = "EPVEGROUPTYPE_ENDLESS"
EPVEGROUPTYPE_EPVEGROUPTYPE_ENDLESS_ENUM.index = 5
EPVEGROUPTYPE_EPVEGROUPTYPE_ENDLESS_ENUM.number = 5
EPVEGROUPTYPE_EPVEGROUPTYPE_DEADBOSS_ENUM.name = "EPVEGROUPTYPE_DEADBOSS"
EPVEGROUPTYPE_EPVEGROUPTYPE_DEADBOSS_ENUM.index = 6
EPVEGROUPTYPE_EPVEGROUPTYPE_DEADBOSS_ENUM.number = 6
EPVEGROUPTYPE_EPVEGROUPTYPE_THANATOS_ENUM.name = "EPVEGROUPTYPE_THANATOS"
EPVEGROUPTYPE_EPVEGROUPTYPE_THANATOS_ENUM.index = 7
EPVEGROUPTYPE_EPVEGROUPTYPE_THANATOS_ENUM.number = 7
EPVEGROUPTYPE_EPVEGROUPTYPE_ROGUELIKE_ENUM.name = "EPVEGROUPTYPE_ROGUELIKE"
EPVEGROUPTYPE_EPVEGROUPTYPE_ROGUELIKE_ENUM.index = 8
EPVEGROUPTYPE_EPVEGROUPTYPE_ROGUELIKE_ENUM.number = 8
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_ONE_ENUM.name = "EPVEGROUPTYPE_CRACK_ONE"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_ONE_ENUM.index = 9
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_ONE_ENUM.number = 9
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TWO_ENUM.name = "EPVEGROUPTYPE_CRACK_TWO"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TWO_ENUM.index = 10
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TWO_ENUM.number = 10
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_THREE_ENUM.name = "EPVEGROUPTYPE_CRACK_THREE"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_THREE_ENUM.index = 11
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_THREE_ENUM.number = 11
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FOUR_ENUM.name = "EPVEGROUPTYPE_CRACK_FOUR"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FOUR_ENUM.index = 12
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FOUR_ENUM.number = 12
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FIVE_ENUM.name = "EPVEGROUPTYPE_CRACK_FIVE"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FIVE_ENUM.index = 13
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FIVE_ENUM.number = 13
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SIX_ENUM.name = "EPVEGROUPTYPE_CRACK_SIX"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SIX_ENUM.index = 14
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SIX_ENUM.number = 14
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SEVEN_ENUM.name = "EPVEGROUPTYPE_CRACK_SEVEN"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SEVEN_ENUM.index = 15
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SEVEN_ENUM.number = 15
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_EIGHT_ENUM.name = "EPVEGROUPTYPE_CRACK_EIGHT"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_EIGHT_ENUM.index = 16
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_EIGHT_ENUM.number = 16
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_NINE_ENUM.name = "EPVEGROUPTYPE_CRACK_NINE"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_NINE_ENUM.index = 17
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_NINE_ENUM.number = 17
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TEN_ENUM.name = "EPVEGROUPTYPE_CRACK_TEN"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TEN_ENUM.index = 18
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TEN_ENUM.number = 18
EPVEGROUPTYPE_EPVEGROUPTYPE_GUILD_RAID_ENUM.name = "EPVEGROUPTYPE_GUILD_RAID"
EPVEGROUPTYPE_EPVEGROUPTYPE_GUILD_RAID_ENUM.index = 19
EPVEGROUPTYPE_EPVEGROUPTYPE_GUILD_RAID_ENUM.number = 19
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_ONE_ENUM.name = "EPVEGROUPTYPE_BOSS_ONE"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_ONE_ENUM.index = 20
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_ONE_ENUM.number = 20
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_TWO_ENUM.name = "EPVEGROUPTYPE_BOSS_TWO"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_TWO_ENUM.index = 21
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_TWO_ENUM.number = 21
EPVEGROUPTYPE_EPVEGROUPTYPE_ELEMENT_ENUM.name = "EPVEGROUPTYPE_ELEMENT"
EPVEGROUPTYPE_EPVEGROUPTYPE_ELEMENT_ENUM.index = 22
EPVEGROUPTYPE_EPVEGROUPTYPE_ELEMENT_ENUM.number = 22
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TORTOISE_ENUM.name = "EPVEGROUPTYPE_CRACK_TORTOISE"
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TORTOISE_ENUM.index = 23
EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TORTOISE_ENUM.number = 23
EPVEGROUPTYPE_EPVEGROUPTYPE_EQUIP_UP_RAID_ENUM.name = "EPVEGROUPTYPE_EQUIP_UP_RAID"
EPVEGROUPTYPE_EPVEGROUPTYPE_EQUIP_UP_RAID_ENUM.index = 24
EPVEGROUPTYPE_EPVEGROUPTYPE_EQUIP_UP_RAID_ENUM.number = 24
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_THREE_ENUM.name = "EPVEGROUPTYPE_BOSS_THREE"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_THREE_ENUM.index = 25
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_THREE_ENUM.number = 25
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FOUR_ENUM.name = "EPVEGROUPTYPE_BOSS_FOUR"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FOUR_ENUM.index = 26
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FOUR_ENUM.number = 26
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FIVE_ENUM.name = "EPVEGROUPTYPE_BOSS_FIVE"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FIVE_ENUM.index = 27
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FIVE_ENUM.number = 27
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SIX_ENUM.name = "EPVEGROUPTYPE_BOSS_SIX"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SIX_ENUM.index = 28
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SIX_ENUM.number = 28
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SEVEN_ENUM.name = "EPVEGROUPTYPE_BOSS_SEVEN"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SEVEN_ENUM.index = 29
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SEVEN_ENUM.number = 29
EPVEGROUPTYPE_EPVEGROUPTYPE_STAR_ARK_ENUM.name = "EPVEGROUPTYPE_STAR_ARK"
EPVEGROUPTYPE_EPVEGROUPTYPE_STAR_ARK_ENUM.index = 30
EPVEGROUPTYPE_EPVEGROUPTYPE_STAR_ARK_ENUM.number = 30
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_EIGHT_ENUM.name = "EPVEGROUPTYPE_BOSS_EIGHT"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_EIGHT_ENUM.index = 31
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_EIGHT_ENUM.number = 31
EPVEGROUPTYPE_EPVEGROUPTYPE_COMMON_MATERIALS_ENUM.name = "EPVEGROUPTYPE_COMMON_MATERIALS"
EPVEGROUPTYPE_EPVEGROUPTYPE_COMMON_MATERIALS_ENUM.index = 32
EPVEGROUPTYPE_EPVEGROUPTYPE_COMMON_MATERIALS_ENUM.number = 32
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_PALACE_ENUM.name = "EPVEGROUPTYPE_MEMORY_PALACE"
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_PALACE_ENUM.index = 33
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_PALACE_ENUM.number = 33
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_ENUM.name = "EPVEGROUPTYPE_HERO_JOURNEY"
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_ENUM.index = 34
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_ENUM.number = 34
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_NINE_ENUM.name = "EPVEGROUPTYPE_BOSS_NINE"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_NINE_ENUM.index = 35
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_NINE_ENUM.number = 35
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_LIFE_ENUM.name = "EPVEGROUPTYPE_ASTRAL_LIFE"
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_LIFE_ENUM.index = 36
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_LIFE_ENUM.number = 36
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_PASSION_ENUM.name = "EPVEGROUPTYPE_ASTRAL_PASSION"
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_PASSION_ENUM.index = 37
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_PASSION_ENUM.number = 37
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_SPACETIME_ENUM.name = "EPVEGROUPTYPE_ASTRAL_SPACETIME"
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_SPACETIME_ENUM.index = 38
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_SPACETIME_ENUM.number = 38
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_DEATH_ENUM.name = "EPVEGROUPTYPE_ASTRAL_DEATH"
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_DEATH_ENUM.index = 39
EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_DEATH_ENUM.number = 39
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_ENUM.name = "EPVEGROUPTYPE_MEMORY"
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_ENUM.index = 40
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_ENUM.number = 40
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_THIRD_ENUM.name = "EPVEGROUPTYPE_MEMORY_THIRD"
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_THIRD_ENUM.index = 41
EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_THIRD_ENUM.number = 41
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT_ENUM.name = "EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT"
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT_ENUM.index = 42
EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT_ENUM.number = 42
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_OTHERWORLD_ENUM.name = "EPVEGROUPTYPE_BOSS_OTHERWORLD"
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_OTHERWORLD_ENUM.index = 43
EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_OTHERWORLD_ENUM.number = 43
EPVEGROUPTYPE_EPVEGROUPTYPE_SPACETIME_ILLUSION_ENUM.name = "EPVEGROUPTYPE_SPACETIME_ILLUSION"
EPVEGROUPTYPE_EPVEGROUPTYPE_SPACETIME_ILLUSION_ENUM.index = 44
EPVEGROUPTYPE_EPVEGROUPTYPE_SPACETIME_ILLUSION_ENUM.number = 44
EPVEGROUPTYPE_EPVEGROUPTYPE_FAIRY_TALE_ENUM.name = "EPVEGROUPTYPE_FAIRY_TALE"
EPVEGROUPTYPE_EPVEGROUPTYPE_FAIRY_TALE_ENUM.index = 45
EPVEGROUPTYPE_EPVEGROUPTYPE_FAIRY_TALE_ENUM.number = 45
EPVEGROUPTYPE_EPVEGROUPTYPE_MAX_ENUM.name = "EPVEGROUPTYPE_MAX"
EPVEGROUPTYPE_EPVEGROUPTYPE_MAX_ENUM.index = 46
EPVEGROUPTYPE_EPVEGROUPTYPE_MAX_ENUM.number = 46
EPVEGROUPTYPE.name = "EPveGroupType"
EPVEGROUPTYPE.full_name = ".Cmd.EPveGroupType"
EPVEGROUPTYPE.values = {
  EPVEGROUPTYPE_EPVEGROUPTYPE_MIN_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_COMODO_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_MULTIBOSS_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_HEADWEAR_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CARD_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ENDLESS_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_DEADBOSS_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_THANATOS_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ROGUELIKE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_ONE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TWO_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_THREE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FOUR_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_FIVE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SIX_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_SEVEN_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_EIGHT_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_NINE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TEN_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_GUILD_RAID_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_ONE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_TWO_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ELEMENT_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_CRACK_TORTOISE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_EQUIP_UP_RAID_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_THREE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FOUR_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_FIVE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SIX_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_SEVEN_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_STAR_ARK_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_EIGHT_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_COMMON_MATERIALS_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_PALACE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_NINE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_LIFE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_PASSION_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_SPACETIME_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_ASTRAL_DEATH_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_MEMORY_THIRD_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_BOSS_OTHERWORLD_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_SPACETIME_ILLUSION_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_FAIRY_TALE_ENUM,
  EPVEGROUPTYPE_EPVEGROUPTYPE_MAX_ENUM
}
EGUILDGATESTATE_EGUILDGATESTATE_MIN_ENUM.name = "EGUILDGATESTATE_MIN"
EGUILDGATESTATE_EGUILDGATESTATE_MIN_ENUM.index = 0
EGUILDGATESTATE_EGUILDGATESTATE_MIN_ENUM.number = 0
EGUILDGATESTATE_EGUILDGATESTATE_LOCK_ENUM.name = "EGUILDGATESTATE_LOCK"
EGUILDGATESTATE_EGUILDGATESTATE_LOCK_ENUM.index = 1
EGUILDGATESTATE_EGUILDGATESTATE_LOCK_ENUM.number = 1
EGUILDGATESTATE_EGUILDGATESTATE_CLOSE_ENUM.name = "EGUILDGATESTATE_CLOSE"
EGUILDGATESTATE_EGUILDGATESTATE_CLOSE_ENUM.index = 2
EGUILDGATESTATE_EGUILDGATESTATE_CLOSE_ENUM.number = 2
EGUILDGATESTATE_EGUILDGATESTATE_OPEN_ENUM.name = "EGUILDGATESTATE_OPEN"
EGUILDGATESTATE_EGUILDGATESTATE_OPEN_ENUM.index = 3
EGUILDGATESTATE_EGUILDGATESTATE_OPEN_ENUM.number = 3
EGUILDGATESTATE.name = "EGuildGateState"
EGUILDGATESTATE.full_name = ".Cmd.EGuildGateState"
EGUILDGATESTATE.values = {
  EGUILDGATESTATE_EGUILDGATESTATE_MIN_ENUM,
  EGUILDGATESTATE_EGUILDGATESTATE_LOCK_ENUM,
  EGUILDGATESTATE_EGUILDGATESTATE_CLOSE_ENUM,
  EGUILDGATESTATE_EGUILDGATESTATE_OPEN_ENUM
}
EGUILDGATEOPT_EGUILDGATEOPT_UNLOCK_ENUM.name = "EGUILDGATEOPT_UNLOCK"
EGUILDGATEOPT_EGUILDGATEOPT_UNLOCK_ENUM.index = 0
EGUILDGATEOPT_EGUILDGATEOPT_UNLOCK_ENUM.number = 1
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENUM.name = "EGUILDGATEOPT_OPEN"
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENUM.index = 1
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENUM.number = 2
EGUILDGATEOPT_EGUILDGATEOPT_ENTER_ENUM.name = "EGUILDGATEOPT_ENTER"
EGUILDGATEOPT_EGUILDGATEOPT_ENTER_ENUM.index = 2
EGUILDGATEOPT_EGUILDGATEOPT_ENTER_ENUM.number = 3
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENTER_ENUM.name = "EGUILDGATEOPT_OPEN_ENTER"
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENTER_ENUM.index = 3
EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENTER_ENUM.number = 4
EGUILDGATEOPT.name = "EGuildGateOpt"
EGUILDGATEOPT.full_name = ".Cmd.EGuildGateOpt"
EGUILDGATEOPT.values = {
  EGUILDGATEOPT_EGUILDGATEOPT_UNLOCK_ENUM,
  EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENUM,
  EGUILDGATEOPT_EGUILDGATEOPT_ENTER_ENUM,
  EGUILDGATEOPT_EGUILDGATEOPT_OPEN_ENTER_ENUM
}
EGVGPOINTSTATE_EGVGPOINT_STATE_MIN_ENUM.name = "EGVGPOINT_STATE_MIN"
EGVGPOINTSTATE_EGVGPOINT_STATE_MIN_ENUM.index = 0
EGVGPOINTSTATE_EGVGPOINT_STATE_MIN_ENUM.number = 0
EGVGPOINTSTATE_EGVGPOINT_STATE_OCCUPIED_ENUM.name = "EGVGPOINT_STATE_OCCUPIED"
EGVGPOINTSTATE_EGVGPOINT_STATE_OCCUPIED_ENUM.index = 1
EGVGPOINTSTATE_EGVGPOINT_STATE_OCCUPIED_ENUM.number = 1
EGVGPOINTSTATE.name = "EGvgPointState"
EGVGPOINTSTATE.full_name = ".Cmd.EGvgPointState"
EGVGPOINTSTATE.values = {
  EGVGPOINTSTATE_EGVGPOINT_STATE_MIN_ENUM,
  EGVGPOINTSTATE_EGVGPOINT_STATE_OCCUPIED_ENUM
}
EGUILDFIRERESULT_EGUILDFIRERESULT_DEF_ENUM.name = "EGUILDFIRERESULT_DEF"
EGUILDFIRERESULT_EGUILDFIRERESULT_DEF_ENUM.index = 0
EGUILDFIRERESULT_EGUILDFIRERESULT_DEF_ENUM.number = 1
EGUILDFIRERESULT_EGUILDFIRERESULT_DEFSPEC_ENUM.name = "EGUILDFIRERESULT_DEFSPEC"
EGUILDFIRERESULT_EGUILDFIRERESULT_DEFSPEC_ENUM.index = 1
EGUILDFIRERESULT_EGUILDFIRERESULT_DEFSPEC_ENUM.number = 2
EGUILDFIRERESULT_EGUILDFIRERESULT_ATTACK_ENUM.name = "EGUILDFIRERESULT_ATTACK"
EGUILDFIRERESULT_EGUILDFIRERESULT_ATTACK_ENUM.index = 2
EGUILDFIRERESULT_EGUILDFIRERESULT_ATTACK_ENUM.number = 3
EGUILDFIRERESULT.name = "EGuildFireResult"
EGUILDFIRERESULT.full_name = ".Cmd.EGuildFireResult"
EGUILDFIRERESULT.values = {
  EGUILDFIRERESULT_EGUILDFIRERESULT_DEF_ENUM,
  EGUILDFIRERESULT_EGUILDFIRERESULT_DEFSPEC_ENUM,
  EGUILDFIRERESULT_EGUILDFIRERESULT_ATTACK_ENUM
}
EGVGDATATYPE_EGVGDATA_MIN_ENUM.name = "EGVGDATA_MIN"
EGVGDATATYPE_EGVGDATA_MIN_ENUM.index = 0
EGVGDATATYPE_EGVGDATA_MIN_ENUM.number = 0
EGVGDATATYPE_EGVGDATA_PARTINTIME_ENUM.name = "EGVGDATA_PARTINTIME"
EGVGDATATYPE_EGVGDATA_PARTINTIME_ENUM.index = 1
EGVGDATATYPE_EGVGDATA_PARTINTIME_ENUM.number = 1
EGVGDATATYPE_EGVGDATA_KILLMON_ENUM.name = "EGVGDATA_KILLMON"
EGVGDATATYPE_EGVGDATA_KILLMON_ENUM.index = 2
EGVGDATATYPE_EGVGDATA_KILLMON_ENUM.number = 2
EGVGDATATYPE_EGVGDATA_RELIVE_ENUM.name = "EGVGDATA_RELIVE"
EGVGDATATYPE_EGVGDATA_RELIVE_ENUM.index = 3
EGVGDATATYPE_EGVGDATA_RELIVE_ENUM.number = 3
EGVGDATATYPE_EGVGDATA_EXPEL_ENUM.name = "EGVGDATA_EXPEL"
EGVGDATATYPE_EGVGDATA_EXPEL_ENUM.index = 4
EGVGDATATYPE_EGVGDATA_EXPEL_ENUM.number = 4
EGVGDATATYPE_EGVGDATA_DAMMETAL_ENUM.name = "EGVGDATA_DAMMETAL"
EGVGDATATYPE_EGVGDATA_DAMMETAL_ENUM.index = 5
EGVGDATATYPE_EGVGDATA_DAMMETAL_ENUM.number = 5
EGVGDATATYPE_EGVGDATA_KILLMETAL_ENUM.name = "EGVGDATA_KILLMETAL"
EGVGDATATYPE_EGVGDATA_KILLMETAL_ENUM.index = 6
EGVGDATATYPE_EGVGDATA_KILLMETAL_ENUM.number = 6
EGVGDATATYPE_EGVGDATA_KILLUSER_ENUM.name = "EGVGDATA_KILLUSER"
EGVGDATATYPE_EGVGDATA_KILLUSER_ENUM.index = 7
EGVGDATATYPE_EGVGDATA_KILLUSER_ENUM.number = 7
EGVGDATATYPE_EGVGDATA_HONOR_ENUM.name = "EGVGDATA_HONOR"
EGVGDATATYPE_EGVGDATA_HONOR_ENUM.index = 8
EGVGDATATYPE_EGVGDATA_HONOR_ENUM.number = 8
EGVGDATATYPE_EGVGDATA_OCCUPY_POINT_ENUM.name = "EGVGDATA_OCCUPY_POINT"
EGVGDATATYPE_EGVGDATA_OCCUPY_POINT_ENUM.index = 9
EGVGDATATYPE_EGVGDATA_OCCUPY_POINT_ENUM.number = 9
EGVGDATATYPE_EGVGDATA_COIN_ENUM.name = "EGVGDATA_COIN"
EGVGDATATYPE_EGVGDATA_COIN_ENUM.index = 10
EGVGDATATYPE_EGVGDATA_COIN_ENUM.number = 10
EGVGDATATYPE_EGVGDATA_DEF_POINT_TIME_ENUM.name = "EGVGDATA_DEF_POINT_TIME"
EGVGDATATYPE_EGVGDATA_DEF_POINT_TIME_ENUM.index = 11
EGVGDATATYPE_EGVGDATA_DEF_POINT_TIME_ENUM.number = 11
EGVGDATATYPE_EGVGDATA_PARTIN_KILLMETAL_ENUM.name = "EGVGDATA_PARTIN_KILLMETAL"
EGVGDATATYPE_EGVGDATA_PARTIN_KILLMETAL_ENUM.index = 12
EGVGDATATYPE_EGVGDATA_PARTIN_KILLMETAL_ENUM.number = 12
EGVGDATATYPE_EGVGDATA_DAM_MVP_ENUM.name = "EGVGDATA_DAM_MVP"
EGVGDATATYPE_EGVGDATA_DAM_MVP_ENUM.index = 13
EGVGDATATYPE_EGVGDATA_DAM_MVP_ENUM.number = 13
EGVGDATATYPE.name = "EGvgDataType"
EGVGDATATYPE.full_name = ".Cmd.EGvgDataType"
EGVGDATATYPE.values = {
  EGVGDATATYPE_EGVGDATA_MIN_ENUM,
  EGVGDATATYPE_EGVGDATA_PARTINTIME_ENUM,
  EGVGDATATYPE_EGVGDATA_KILLMON_ENUM,
  EGVGDATATYPE_EGVGDATA_RELIVE_ENUM,
  EGVGDATATYPE_EGVGDATA_EXPEL_ENUM,
  EGVGDATATYPE_EGVGDATA_DAMMETAL_ENUM,
  EGVGDATATYPE_EGVGDATA_KILLMETAL_ENUM,
  EGVGDATATYPE_EGVGDATA_KILLUSER_ENUM,
  EGVGDATATYPE_EGVGDATA_HONOR_ENUM,
  EGVGDATATYPE_EGVGDATA_OCCUPY_POINT_ENUM,
  EGVGDATATYPE_EGVGDATA_COIN_ENUM,
  EGVGDATATYPE_EGVGDATA_DEF_POINT_TIME_ENUM,
  EGVGDATATYPE_EGVGDATA_PARTIN_KILLMETAL_ENUM,
  EGVGDATATYPE_EGVGDATA_DAM_MVP_ENUM
}
EGVGTOWERSTATE_EGVGTOWERSTATE_INITFREE_ENUM.name = "EGVGTOWERSTATE_INITFREE"
EGVGTOWERSTATE_EGVGTOWERSTATE_INITFREE_ENUM.index = 0
EGVGTOWERSTATE_EGVGTOWERSTATE_INITFREE_ENUM.number = 1
EGVGTOWERSTATE_EGVGTOWERSTATE_OCCUPY_ENUM.name = "EGVGTOWERSTATE_OCCUPY"
EGVGTOWERSTATE_EGVGTOWERSTATE_OCCUPY_ENUM.index = 1
EGVGTOWERSTATE_EGVGTOWERSTATE_OCCUPY_ENUM.number = 2
EGVGTOWERSTATE_EGVGTOWERSTATE_FREE_ENUM.name = "EGVGTOWERSTATE_FREE"
EGVGTOWERSTATE_EGVGTOWERSTATE_FREE_ENUM.index = 2
EGVGTOWERSTATE_EGVGTOWERSTATE_FREE_ENUM.number = 3
EGVGTOWERSTATE.name = "EGvgTowerState"
EGVGTOWERSTATE.full_name = ".Cmd.EGvgTowerState"
EGVGTOWERSTATE.values = {
  EGVGTOWERSTATE_EGVGTOWERSTATE_INITFREE_ENUM,
  EGVGTOWERSTATE_EGVGTOWERSTATE_OCCUPY_ENUM,
  EGVGTOWERSTATE_EGVGTOWERSTATE_FREE_ENUM
}
EGVGTOWERTYPE_EGVGTOWERTYPE_MIN_ENUM.name = "EGVGTOWERTYPE_MIN"
EGVGTOWERTYPE_EGVGTOWERTYPE_MIN_ENUM.index = 0
EGVGTOWERTYPE_EGVGTOWERTYPE_MIN_ENUM.number = 0
EGVGTOWERTYPE_EGVGTOWERTYPE_CORE_ENUM.name = "EGVGTOWERTYPE_CORE"
EGVGTOWERTYPE_EGVGTOWERTYPE_CORE_ENUM.index = 1
EGVGTOWERTYPE_EGVGTOWERTYPE_CORE_ENUM.number = 1
EGVGTOWERTYPE_EGVGTOWERTYPE_WEST_ENUM.name = "EGVGTOWERTYPE_WEST"
EGVGTOWERTYPE_EGVGTOWERTYPE_WEST_ENUM.index = 2
EGVGTOWERTYPE_EGVGTOWERTYPE_WEST_ENUM.number = 2
EGVGTOWERTYPE_EGVGTOWERTYPE_EAST_ENUM.name = "EGVGTOWERTYPE_EAST"
EGVGTOWERTYPE_EGVGTOWERTYPE_EAST_ENUM.index = 3
EGVGTOWERTYPE_EGVGTOWERTYPE_EAST_ENUM.number = 3
EGVGTOWERTYPE.name = "EGvgTowerType"
EGVGTOWERTYPE.full_name = ".Cmd.EGvgTowerType"
EGVGTOWERTYPE.values = {
  EGVGTOWERTYPE_EGVGTOWERTYPE_MIN_ENUM,
  EGVGTOWERTYPE_EGVGTOWERTYPE_CORE_ENUM,
  EGVGTOWERTYPE_EGVGTOWERTYPE_WEST_ENUM,
  EGVGTOWERTYPE_EGVGTOWERTYPE_EAST_ENUM
}
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_MIN_ENUM.name = "EDEADBOSSDIFF_MIN"
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_MIN_ENUM.index = 0
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_MIN_ENUM.number = 0
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_NORMAL_ENUM.name = "EDEADBOSSDIFF_NORMAL"
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_NORMAL_ENUM.index = 1
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_NORMAL_ENUM.number = 2
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_HARD_ENUM.name = "EDEADBOSSDIFF_HARD"
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_HARD_ENUM.index = 2
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_HARD_ENUM.number = 3
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_SUPER_ENUM.name = "EDEADBOSSDIFF_SUPER"
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_SUPER_ENUM.index = 3
EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_SUPER_ENUM.number = 4
EDEADBOSSDIFFICULTY.name = "EDeadBossDifficulty"
EDEADBOSSDIFFICULTY.full_name = ".Cmd.EDeadBossDifficulty"
EDEADBOSSDIFFICULTY.values = {
  EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_MIN_ENUM,
  EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_NORMAL_ENUM,
  EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_HARD_ENUM,
  EDEADBOSSDIFFICULTY_EDEADBOSSDIFF_SUPER_ENUM
}
ETEAMPWSCOLOR_ETEAMPWS_MIN_ENUM.name = "ETEAMPWS_MIN"
ETEAMPWSCOLOR_ETEAMPWS_MIN_ENUM.index = 0
ETEAMPWSCOLOR_ETEAMPWS_MIN_ENUM.number = 0
ETEAMPWSCOLOR_ETEAMPWS_RED_ENUM.name = "ETEAMPWS_RED"
ETEAMPWSCOLOR_ETEAMPWS_RED_ENUM.index = 1
ETEAMPWSCOLOR_ETEAMPWS_RED_ENUM.number = 1
ETEAMPWSCOLOR_ETEAMPWS_BLUE_ENUM.name = "ETEAMPWS_BLUE"
ETEAMPWSCOLOR_ETEAMPWS_BLUE_ENUM.index = 2
ETEAMPWSCOLOR_ETEAMPWS_BLUE_ENUM.number = 2
ETEAMPWSCOLOR.name = "ETeamPwsColor"
ETEAMPWSCOLOR.full_name = ".Cmd.ETeamPwsColor"
ETEAMPWSCOLOR.values = {
  ETEAMPWSCOLOR_ETEAMPWS_MIN_ENUM,
  ETEAMPWSCOLOR_ETEAMPWS_RED_ENUM,
  ETEAMPWSCOLOR_ETEAMPWS_BLUE_ENUM
}
EMAGICBALLTYPE_EMAGICBALL_MIN_ENUM.name = "EMAGICBALL_MIN"
EMAGICBALLTYPE_EMAGICBALL_MIN_ENUM.index = 0
EMAGICBALLTYPE_EMAGICBALL_MIN_ENUM.number = 0
EMAGICBALLTYPE_EMAGICBALL_WIND_ENUM.name = "EMAGICBALL_WIND"
EMAGICBALLTYPE_EMAGICBALL_WIND_ENUM.index = 1
EMAGICBALLTYPE_EMAGICBALL_WIND_ENUM.number = 1
EMAGICBALLTYPE_EMAGICBALL_EARTH_ENUM.name = "EMAGICBALL_EARTH"
EMAGICBALLTYPE_EMAGICBALL_EARTH_ENUM.index = 2
EMAGICBALLTYPE_EMAGICBALL_EARTH_ENUM.number = 2
EMAGICBALLTYPE_EMAGICBALL_WATER_ENUM.name = "EMAGICBALL_WATER"
EMAGICBALLTYPE_EMAGICBALL_WATER_ENUM.index = 3
EMAGICBALLTYPE_EMAGICBALL_WATER_ENUM.number = 3
EMAGICBALLTYPE_EMAGICBALL_FIRE_ENUM.name = "EMAGICBALL_FIRE"
EMAGICBALLTYPE_EMAGICBALL_FIRE_ENUM.index = 4
EMAGICBALLTYPE_EMAGICBALL_FIRE_ENUM.number = 4
EMAGICBALLTYPE.name = "EMagicBallType"
EMAGICBALLTYPE.full_name = ".Cmd.EMagicBallType"
EMAGICBALLTYPE.values = {
  EMAGICBALLTYPE_EMAGICBALL_MIN_ENUM,
  EMAGICBALLTYPE_EMAGICBALL_WIND_ENUM,
  EMAGICBALLTYPE_EMAGICBALL_EARTH_ENUM,
  EMAGICBALLTYPE_EMAGICBALL_WATER_ENUM,
  EMAGICBALLTYPE_EMAGICBALL_FIRE_ENUM
}
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_MIN_ENUM.name = "EGROUPRAIDSCENE_MIN"
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_MIN_ENUM.index = 0
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_MIN_ENUM.number = 0
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_FIRE_ENUM.name = "EGROUPRAIDSCENE_FIRE"
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_FIRE_ENUM.index = 1
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_FIRE_ENUM.number = 1
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_OVER_ENUM.name = "EGROUPRAIDSCENE_OVER"
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_OVER_ENUM.index = 2
EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_OVER_ENUM.number = 2
EGROUPRAIDSCENESTATE.name = "EGroupRaidSceneState"
EGROUPRAIDSCENESTATE.full_name = ".Cmd.EGroupRaidSceneState"
EGROUPRAIDSCENESTATE.values = {
  EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_MIN_ENUM,
  EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_FIRE_ENUM,
  EGROUPRAIDSCENESTATE_EGROUPRAIDSCENE_OVER_ENUM
}
EKUMAMOTOOPER_EKUMAMOTOOPER_CREATE_ENUM.name = "EKUMAMOTOOPER_CREATE"
EKUMAMOTOOPER_EKUMAMOTOOPER_CREATE_ENUM.index = 0
EKUMAMOTOOPER_EKUMAMOTOOPER_CREATE_ENUM.number = 1
EKUMAMOTOOPER_EKUMAMOTOOPER_REWARD_ENUM.name = "EKUMAMOTOOPER_REWARD"
EKUMAMOTOOPER_EKUMAMOTOOPER_REWARD_ENUM.index = 1
EKUMAMOTOOPER_EKUMAMOTOOPER_REWARD_ENUM.number = 2
EKUMAMOTOOPER_EKUMAMOTOOPER_SCORE_ENUM.name = "EKUMAMOTOOPER_SCORE"
EKUMAMOTOOPER_EKUMAMOTOOPER_SCORE_ENUM.index = 2
EKUMAMOTOOPER_EKUMAMOTOOPER_SCORE_ENUM.number = 3
EKUMAMOTOOPER.name = "EKumamotoOper"
EKUMAMOTOOPER.full_name = ".Cmd.EKumamotoOper"
EKUMAMOTOOPER.values = {
  EKUMAMOTOOPER_EKUMAMOTOOPER_CREATE_ENUM,
  EKUMAMOTOOPER_EKUMAMOTOOPER_REWARD_ENUM,
  EKUMAMOTOOPER_EKUMAMOTOOPER_SCORE_ENUM
}
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MIN_ENUM.name = "EROLLRAIDREWARD_MIN"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MIN_ENUM.index = 0
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MIN_ENUM.number = 0
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_PVERAID_ENUM.name = "EROLLRAIDREWARD_PVERAID"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_PVERAID_ENUM.index = 1
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_PVERAID_ENUM.number = 1
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GROUPRAID_ENUM.name = "EROLLRAIDREWARD_GROUPRAID"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GROUPRAID_ENUM.index = 2
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GROUPRAID_ENUM.number = 2
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_WORLDBOSS_ENUM.name = "EROLLRAIDREWARD_WORLDBOSS"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_WORLDBOSS_ENUM.index = 3
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_WORLDBOSS_ENUM.number = 3
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_DEADBOSS_ENUM.name = "EROLLRAIDREWARD_DEADBOSS"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_DEADBOSS_ENUM.index = 4
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_DEADBOSS_ENUM.number = 4
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GUILD_ENUM.name = "EROLLRAIDREWARD_GUILD"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GUILD_ENUM.index = 5
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GUILD_ENUM.number = 5
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_COMODO_TEAM_RAID_ENUM.name = "EROLLRAIDREWARD_COMODO_TEAM_RAID"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_COMODO_TEAM_RAID_ENUM.index = 6
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_COMODO_TEAM_RAID_ENUM.number = 6
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID_ENUM.name = "EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID_ENUM.index = 7
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID_ENUM.number = 7
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_EQUIP_UP_ENUM.name = "EROLLRAIDREWARD_EQUIP_UP"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_EQUIP_UP_ENUM.index = 8
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_EQUIP_UP_ENUM.number = 8
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MVP_ENUM.name = "EROLLRAIDREWARD_BOSS_SCENE_MVP"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MVP_ENUM.index = 9
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MVP_ENUM.number = 9
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MINI_ENUM.name = "EROLLRAIDREWARD_BOSS_SCENE_MINI"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MINI_ENUM.index = 10
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MINI_ENUM.number = 10
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_PALACE_ENUM.name = "EROLLRAIDREWARD_MEMORY_PALACE"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_PALACE_ENUM.index = 11
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_PALACE_ENUM.number = 11
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_ENUM.name = "EROLLRAIDREWARD_MEMORY"
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_ENUM.index = 12
EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_ENUM.number = 12
EROLLRAIDREWARDTYPE.name = "ERollRaidRewardType"
EROLLRAIDREWARDTYPE.full_name = ".Cmd.ERollRaidRewardType"
EROLLRAIDREWARDTYPE.values = {
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MIN_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_PVERAID_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GROUPRAID_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_WORLDBOSS_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_DEADBOSS_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_GUILD_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_COMODO_TEAM_RAID_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_EQUIP_UP_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MVP_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_BOSS_SCENE_MINI_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_PALACE_ENUM,
  EROLLRAIDREWARDTYPE_EROLLRAIDREWARD_MEMORY_ENUM
}
EGROUPCAMP_EGROUPCAMP_MIN_ENUM.name = "EGROUPCAMP_MIN"
EGROUPCAMP_EGROUPCAMP_MIN_ENUM.index = 0
EGROUPCAMP_EGROUPCAMP_MIN_ENUM.number = 0
EGROUPCAMP_EGROUPCAMP_RED_ENUM.name = "EGROUPCAMP_RED"
EGROUPCAMP_EGROUPCAMP_RED_ENUM.index = 1
EGROUPCAMP_EGROUPCAMP_RED_ENUM.number = 1
EGROUPCAMP_EGROUPCAMP_BLUE_ENUM.name = "EGROUPCAMP_BLUE"
EGROUPCAMP_EGROUPCAMP_BLUE_ENUM.index = 2
EGROUPCAMP_EGROUPCAMP_BLUE_ENUM.number = 2
EGROUPCAMP_EGROUPCAMP_OBSERVER_ENUM.name = "EGROUPCAMP_OBSERVER"
EGROUPCAMP_EGROUPCAMP_OBSERVER_ENUM.index = 3
EGROUPCAMP_EGROUPCAMP_OBSERVER_ENUM.number = 3
EGROUPCAMP.name = "EGroupCamp"
EGROUPCAMP.full_name = ".Cmd.EGroupCamp"
EGROUPCAMP.values = {
  EGROUPCAMP_EGROUPCAMP_MIN_ENUM,
  EGROUPCAMP_EGROUPCAMP_RED_ENUM,
  EGROUPCAMP_EGROUPCAMP_BLUE_ENUM,
  EGROUPCAMP_EGROUPCAMP_OBSERVER_ENUM
}
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MIN_ENUM.name = "ETWELVEPVP_DATA_MIN"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MIN_ENUM.index = 0
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MIN_ENUM.number = 0
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_EXP_ENUM.name = "ETWELVEPVP_DATA_CRYSTAL_EXP"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_EXP_ENUM.index = 1
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_EXP_ENUM.number = 3
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_GOLD_ENUM.name = "ETWELVEPVP_DATA_GOLD"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_GOLD_ENUM.index = 2
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_GOLD_ENUM.number = 4
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAR_POINT_ENUM.name = "ETWELVEPVP_DATA_CAR_POINT"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAR_POINT_ENUM.index = 3
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAR_POINT_ENUM.number = 5
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PUSH_PLAYER_NUM_ENUM.name = "ETWELVEPVP_DATA_PUSH_PLAYER_NUM"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PUSH_PLAYER_NUM_ENUM.index = 4
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PUSH_PLAYER_NUM_ENUM.number = 6
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_END_TIME_ENUM.name = "ETWELVEPVP_DATA_END_TIME"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_END_TIME_ENUM.index = 5
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_END_TIME_ENUM.number = 7
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_SHOP_CD_ENUM.name = "ETWELVEPVP_DATA_SHOP_CD"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_SHOP_CD_ENUM.index = 6
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_SHOP_CD_ENUM.number = 8
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAMP_ENUM.name = "ETWELVEPVP_DATA_CAMP"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAMP_ENUM.index = 7
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAMP_ENUM.number = 9
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_BARRACK_HP_ENUM.name = "ETWELVEPVP_DATA_BARRACK_HP"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_BARRACK_HP_ENUM.index = 8
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_BARRACK_HP_ENUM.number = 10
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_HP_ENUM.name = "ETWELVEPVP_DATA_CRYSTAL_HP"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_HP_ENUM.index = 9
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_HP_ENUM.number = 11
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PVP_TYPE_ENUM.name = "ETWELVEPVP_DATA_PVP_TYPE"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PVP_TYPE_ENUM.index = 10
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PVP_TYPE_ENUM.number = 12
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_LEVEL_ENUM.name = "ETWELVEPVP_DATA_CRYSTAL_LEVEL"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_LEVEL_ENUM.index = 11
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_LEVEL_ENUM.number = 13
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_KILL_NUM_ENUM.name = "ETWELVEPVP_DATA_KILL_NUM"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_KILL_NUM_ENUM.index = 12
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_KILL_NUM_ENUM.number = 14
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MAX_ENUM.name = "ETWELVEPVP_DATA_MAX"
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MAX_ENUM.index = 13
ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MAX_ENUM.number = 15
ETWELVEPVPDATATYPE.name = "ETwelvePvpDataType"
ETWELVEPVPDATATYPE.full_name = ".Cmd.ETwelvePvpDataType"
ETWELVEPVPDATATYPE.values = {
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MIN_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_EXP_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_GOLD_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAR_POINT_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PUSH_PLAYER_NUM_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_END_TIME_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_SHOP_CD_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CAMP_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_BARRACK_HP_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_HP_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_PVP_TYPE_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_CRYSTAL_LEVEL_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_KILL_NUM_ENUM,
  ETWELVEPVPDATATYPE_ETWELVEPVP_DATA_MAX_ENUM
}
ETWELVEPVPUI_ETWELVEPVP_UI_MIN_ENUM.name = "ETWELVEPVP_UI_MIN"
ETWELVEPVPUI_ETWELVEPVP_UI_MIN_ENUM.index = 0
ETWELVEPVPUI_ETWELVEPVP_UI_MIN_ENUM.number = 0
ETWELVEPVPUI_ETWELVEPVP_UI_CRYSTAL_ENUM.name = "ETWELVEPVP_UI_CRYSTAL"
ETWELVEPVPUI_ETWELVEPVP_UI_CRYSTAL_ENUM.index = 1
ETWELVEPVPUI_ETWELVEPVP_UI_CRYSTAL_ENUM.number = 1
ETWELVEPVPUI_ETWELVEPVP_UI_SHOP_ENUM.name = "ETWELVEPVP_UI_SHOP"
ETWELVEPVPUI_ETWELVEPVP_UI_SHOP_ENUM.index = 2
ETWELVEPVPUI_ETWELVEPVP_UI_SHOP_ENUM.number = 2
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_MIN_ENUM.name = "ETWELVEPVP_OBSERVER_UI_MIN"
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_MIN_ENUM.index = 3
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_MIN_ENUM.number = 1000
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_ITEM_ENUM.name = "ETWELVEPVP_OBSERVER_UI_ITEM"
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_ITEM_ENUM.index = 4
ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_ITEM_ENUM.number = 1001
ETWELVEPVPUI.name = "ETwelvePvpUI"
ETWELVEPVPUI.full_name = ".Cmd.ETwelvePvpUI"
ETWELVEPVPUI.values = {
  ETWELVEPVPUI_ETWELVEPVP_UI_MIN_ENUM,
  ETWELVEPVPUI_ETWELVEPVP_UI_CRYSTAL_ENUM,
  ETWELVEPVPUI_ETWELVEPVP_UI_SHOP_ENUM,
  ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_MIN_ENUM,
  ETWELVEPVPUI_ETWELVEPVP_OBSERVER_UI_ITEM_ENUM
}
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MIN_ENUM.name = "ECOMODO_BOSS_MIN"
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MIN_ENUM.index = 0
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MIN_ENUM.number = 0
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_DRAGON_ENUM.name = "ECOMODO_BOSS_DRAGON"
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_DRAGON_ENUM.index = 1
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_DRAGON_ENUM.number = 1
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_CHESS_ENUM.name = "ECOMODO_BOSS_CHESS"
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_CHESS_ENUM.index = 2
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_CHESS_ENUM.number = 2
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_HERO_ENUM.name = "ECOMODO_BOSS_HERO"
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_HERO_ENUM.index = 3
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_HERO_ENUM.number = 3
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MAX_ENUM.name = "ECOMODO_BOSS_MAX"
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MAX_ENUM.index = 4
ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MAX_ENUM.number = 4
ECOMODOTEAMRAIDBOSS.name = "EComodoTeamRaidBoss"
ECOMODOTEAMRAIDBOSS.full_name = ".Cmd.EComodoTeamRaidBoss"
ECOMODOTEAMRAIDBOSS.values = {
  ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MIN_ENUM,
  ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_DRAGON_ENUM,
  ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_CHESS_ENUM,
  ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_HERO_ENUM,
  ECOMODOTEAMRAIDBOSS_ECOMODO_BOSS_MAX_ENUM
}
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_MIN_ENUM.name = "ECOMODO_PHASE_MIN"
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_MIN_ENUM.index = 0
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_MIN_ENUM.number = 0
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_DRAGON_ENUM.name = "ECOMODO_PHASE_DRAGON"
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_DRAGON_ENUM.index = 1
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_DRAGON_ENUM.number = 1
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_CHESS_ENUM.name = "ECOMODO_PHASE_CHESS"
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_CHESS_ENUM.index = 2
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_CHESS_ENUM.number = 2
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_HERO_ENUM.name = "ECOMODO_PHASE_HERO"
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_HERO_ENUM.index = 3
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_HERO_ENUM.number = 3
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_SAVE_NPC_ENUM.name = "ECOMODO_PHASE_SAVE_NPC"
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_SAVE_NPC_ENUM.index = 4
ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_SAVE_NPC_ENUM.number = 4
ECOMODOTEAMRAIDPHASE.name = "EComodoTeamRaidPhase"
ECOMODOTEAMRAIDPHASE.full_name = ".Cmd.EComodoTeamRaidPhase"
ECOMODOTEAMRAIDPHASE.values = {
  ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_MIN_ENUM,
  ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_DRAGON_ENUM,
  ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_CHESS_ENUM,
  ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_HERO_ENUM,
  ECOMODOTEAMRAIDPHASE_ECOMODO_PHASE_SAVE_NPC_ENUM
}
EREWARDSHOWTYPE_EREWARD_SHOW_MIN_ENUM.name = "EREWARD_SHOW_MIN"
EREWARDSHOWTYPE_EREWARD_SHOW_MIN_ENUM.index = 0
EREWARDSHOWTYPE_EREWARD_SHOW_MIN_ENUM.number = 0
EREWARDSHOWTYPE_EREWARD_SHOW_NORMAL_ENUM.name = "EREWARD_SHOW_NORMAL"
EREWARDSHOWTYPE_EREWARD_SHOW_NORMAL_ENUM.index = 1
EREWARDSHOWTYPE_EREWARD_SHOW_NORMAL_ENUM.number = 1
EREWARDSHOWTYPE_EREWARD_SHOW_WEEKLY_ENUM.name = "EREWARD_SHOW_WEEKLY"
EREWARDSHOWTYPE_EREWARD_SHOW_WEEKLY_ENUM.index = 2
EREWARDSHOWTYPE_EREWARD_SHOW_WEEKLY_ENUM.number = 2
EREWARDSHOWTYPE_EREWARD_SHOW_FIRST_ENUM.name = "EREWARD_SHOW_FIRST"
EREWARDSHOWTYPE_EREWARD_SHOW_FIRST_ENUM.index = 3
EREWARDSHOWTYPE_EREWARD_SHOW_FIRST_ENUM.number = 3
EREWARDSHOWTYPE_EREWARD_SHOW_PROBABLY_ENUM.name = "EREWARD_SHOW_PROBABLY"
EREWARDSHOWTYPE_EREWARD_SHOW_PROBABLY_ENUM.index = 4
EREWARDSHOWTYPE_EREWARD_SHOW_PROBABLY_ENUM.number = 4
EREWARDSHOWTYPE_EREWARD_SHOW_HEAD_WEAR_ENUM.name = "EREWARD_SHOW_HEAD_WEAR"
EREWARDSHOWTYPE_EREWARD_SHOW_HEAD_WEAR_ENUM.index = 5
EREWARDSHOWTYPE_EREWARD_SHOW_HEAD_WEAR_ENUM.number = 5
EREWARDSHOWTYPE.name = "ERewardShowType"
EREWARDSHOWTYPE.full_name = ".Cmd.ERewardShowType"
EREWARDSHOWTYPE.values = {
  EREWARDSHOWTYPE_EREWARD_SHOW_MIN_ENUM,
  EREWARDSHOWTYPE_EREWARD_SHOW_NORMAL_ENUM,
  EREWARDSHOWTYPE_EREWARD_SHOW_WEEKLY_ENUM,
  EREWARDSHOWTYPE_EREWARD_SHOW_FIRST_ENUM,
  EREWARDSHOWTYPE_EREWARD_SHOW_PROBABLY_ENUM,
  EREWARDSHOWTYPE_EREWARD_SHOW_HEAD_WEAR_ENUM
}
EGVGRAIDSTATE_EGVGRAIDSTATE_MIN_ENUM.name = "EGVGRAIDSTATE_MIN"
EGVGRAIDSTATE_EGVGRAIDSTATE_MIN_ENUM.index = 0
EGVGRAIDSTATE_EGVGRAIDSTATE_MIN_ENUM.number = 0
EGVGRAIDSTATE_EGVGRAIDSTATE_PEACE_ENUM.name = "EGVGRAIDSTATE_PEACE"
EGVGRAIDSTATE_EGVGRAIDSTATE_PEACE_ENUM.index = 1
EGVGRAIDSTATE_EGVGRAIDSTATE_PEACE_ENUM.number = 1
EGVGRAIDSTATE_EGVGRAIDSTATE_FIRE_ENUM.name = "EGVGRAIDSTATE_FIRE"
EGVGRAIDSTATE_EGVGRAIDSTATE_FIRE_ENUM.index = 2
EGVGRAIDSTATE_EGVGRAIDSTATE_FIRE_ENUM.number = 2
EGVGRAIDSTATE_EGVGRAIDSTATE_CALM_ENUM.name = "EGVGRAIDSTATE_CALM"
EGVGRAIDSTATE_EGVGRAIDSTATE_CALM_ENUM.index = 3
EGVGRAIDSTATE_EGVGRAIDSTATE_CALM_ENUM.number = 3
EGVGRAIDSTATE_EGVGRAIDSTATE_PERFECT_ENUM.name = "EGVGRAIDSTATE_PERFECT"
EGVGRAIDSTATE_EGVGRAIDSTATE_PERFECT_ENUM.index = 4
EGVGRAIDSTATE_EGVGRAIDSTATE_PERFECT_ENUM.number = 4
EGVGRAIDSTATE.name = "EGvgRaidState"
EGVGRAIDSTATE.full_name = ".Cmd.EGvgRaidState"
EGVGRAIDSTATE.values = {
  EGVGRAIDSTATE_EGVGRAIDSTATE_MIN_ENUM,
  EGVGRAIDSTATE_EGVGRAIDSTATE_PEACE_ENUM,
  EGVGRAIDSTATE_EGVGRAIDSTATE_FIRE_ENUM,
  EGVGRAIDSTATE_EGVGRAIDSTATE_CALM_ENUM,
  EGVGRAIDSTATE_EGVGRAIDSTATE_PERFECT_ENUM
}
EGVGCITYTYPE_EGVGCITYTYPE_MIN_ENUM.name = "EGVGCITYTYPE_MIN"
EGVGCITYTYPE_EGVGCITYTYPE_MIN_ENUM.index = 0
EGVGCITYTYPE_EGVGCITYTYPE_MIN_ENUM.number = 0
EGVGCITYTYPE_EGVGCITYTYPE_SMALL_ENUM.name = "EGVGCITYTYPE_SMALL"
EGVGCITYTYPE_EGVGCITYTYPE_SMALL_ENUM.index = 1
EGVGCITYTYPE_EGVGCITYTYPE_SMALL_ENUM.number = 1
EGVGCITYTYPE_EGVGCITYTYPE_MIDDLE_ENUM.name = "EGVGCITYTYPE_MIDDLE"
EGVGCITYTYPE_EGVGCITYTYPE_MIDDLE_ENUM.index = 2
EGVGCITYTYPE_EGVGCITYTYPE_MIDDLE_ENUM.number = 2
EGVGCITYTYPE_EGVGCITYTYPE_LARGE_ENUM.name = "EGVGCITYTYPE_LARGE"
EGVGCITYTYPE_EGVGCITYTYPE_LARGE_ENUM.index = 3
EGVGCITYTYPE_EGVGCITYTYPE_LARGE_ENUM.number = 3
EGVGCITYTYPE_EGVGCITYTYPE_MAX_ENUM.name = "EGVGCITYTYPE_MAX"
EGVGCITYTYPE_EGVGCITYTYPE_MAX_ENUM.index = 4
EGVGCITYTYPE_EGVGCITYTYPE_MAX_ENUM.number = 4
EGVGCITYTYPE.name = "EGvgCityType"
EGVGCITYTYPE.full_name = ".Cmd.EGvgCityType"
EGVGCITYTYPE.values = {
  EGVGCITYTYPE_EGVGCITYTYPE_MIN_ENUM,
  EGVGCITYTYPE_EGVGCITYTYPE_SMALL_ENUM,
  EGVGCITYTYPE_EGVGCITYTYPE_MIDDLE_ENUM,
  EGVGCITYTYPE_EGVGCITYTYPE_LARGE_ENUM,
  EGVGCITYTYPE_EGVGCITYTYPE_MAX_ENUM
}
ETRIPLECAMP_ETRIPLE_CAMP_MIN_ENUM.name = "ETRIPLE_CAMP_MIN"
ETRIPLECAMP_ETRIPLE_CAMP_MIN_ENUM.index = 0
ETRIPLECAMP_ETRIPLE_CAMP_MIN_ENUM.number = 0
ETRIPLECAMP_ETRIPLE_CAMP_RED_ENUM.name = "ETRIPLE_CAMP_RED"
ETRIPLECAMP_ETRIPLE_CAMP_RED_ENUM.index = 1
ETRIPLECAMP_ETRIPLE_CAMP_RED_ENUM.number = 1
ETRIPLECAMP_ETRIPLE_CAMP_YELLOW_ENUM.name = "ETRIPLE_CAMP_YELLOW"
ETRIPLECAMP_ETRIPLE_CAMP_YELLOW_ENUM.index = 2
ETRIPLECAMP_ETRIPLE_CAMP_YELLOW_ENUM.number = 2
ETRIPLECAMP_ETRIPLE_CAMP_BLUE_ENUM.name = "ETRIPLE_CAMP_BLUE"
ETRIPLECAMP_ETRIPLE_CAMP_BLUE_ENUM.index = 3
ETRIPLECAMP_ETRIPLE_CAMP_BLUE_ENUM.number = 3
ETRIPLECAMP_ETRIPLE_CAMP_GREEN_ENUM.name = "ETRIPLE_CAMP_GREEN"
ETRIPLECAMP_ETRIPLE_CAMP_GREEN_ENUM.index = 4
ETRIPLECAMP_ETRIPLE_CAMP_GREEN_ENUM.number = 4
ETRIPLECAMP_ETRIPLE_CAMP_MAX_ENUM.name = "ETRIPLE_CAMP_MAX"
ETRIPLECAMP_ETRIPLE_CAMP_MAX_ENUM.index = 5
ETRIPLECAMP_ETRIPLE_CAMP_MAX_ENUM.number = 5
ETRIPLECAMP.name = "ETripleCamp"
ETRIPLECAMP.full_name = ".Cmd.ETripleCamp"
ETRIPLECAMP.values = {
  ETRIPLECAMP_ETRIPLE_CAMP_MIN_ENUM,
  ETRIPLECAMP_ETRIPLE_CAMP_RED_ENUM,
  ETRIPLECAMP_ETRIPLE_CAMP_YELLOW_ENUM,
  ETRIPLECAMP_ETRIPLE_CAMP_BLUE_ENUM,
  ETRIPLECAMP_ETRIPLE_CAMP_GREEN_ENUM,
  ETRIPLECAMP_ETRIPLE_CAMP_MAX_ENUM
}
EEBFFIELDSTATE_EEBF_FIELD_WAITING_ENUM.name = "EEBF_FIELD_WAITING"
EEBFFIELDSTATE_EEBF_FIELD_WAITING_ENUM.index = 0
EEBFFIELDSTATE_EEBF_FIELD_WAITING_ENUM.number = 0
EEBFFIELDSTATE_EEBF_FIELD_EVENT_ENUM.name = "EEBF_FIELD_EVENT"
EEBFFIELDSTATE_EEBF_FIELD_EVENT_ENUM.index = 1
EEBFFIELDSTATE_EEBF_FIELD_EVENT_ENUM.number = 1
EEBFFIELDSTATE_EEBF_FIELD_FINAL_ENUM.name = "EEBF_FIELD_FINAL"
EEBFFIELDSTATE_EEBF_FIELD_FINAL_ENUM.index = 2
EEBFFIELDSTATE_EEBF_FIELD_FINAL_ENUM.number = 2
EEBFFIELDSTATE.name = "EEBFFieldState"
EEBFFIELDSTATE.full_name = ".Cmd.EEBFFieldState"
EEBFFIELDSTATE.values = {
  EEBFFIELDSTATE_EEBF_FIELD_WAITING_ENUM,
  EEBFFIELDSTATE_EEBF_FIELD_EVENT_ENUM,
  EEBFFIELDSTATE_EEBF_FIELD_FINAL_ENUM
}
EFIGHTBARSTATE_EFIGHT_BAR_STATE_MIN_ENUM.name = "EFIGHT_BAR_STATE_MIN"
EFIGHTBARSTATE_EFIGHT_BAR_STATE_MIN_ENUM.index = 0
EFIGHTBARSTATE_EFIGHT_BAR_STATE_MIN_ENUM.number = 0
EFIGHTBARSTATE_EFIGHT_BAR_STATE_BEGIN_ENUM.name = "EFIGHT_BAR_STATE_BEGIN"
EFIGHTBARSTATE_EFIGHT_BAR_STATE_BEGIN_ENUM.index = 1
EFIGHTBARSTATE_EFIGHT_BAR_STATE_BEGIN_ENUM.number = 1
EFIGHTBARSTATE_EFIGHT_BAR_STATE_PAUSE_ENUM.name = "EFIGHT_BAR_STATE_PAUSE"
EFIGHTBARSTATE_EFIGHT_BAR_STATE_PAUSE_ENUM.index = 2
EFIGHTBARSTATE_EFIGHT_BAR_STATE_PAUSE_ENUM.number = 2
EFIGHTBARSTATE_EFIGHT_BAR_STATE_DEL_ENUM.name = "EFIGHT_BAR_STATE_DEL"
EFIGHTBARSTATE_EFIGHT_BAR_STATE_DEL_ENUM.index = 3
EFIGHTBARSTATE_EFIGHT_BAR_STATE_DEL_ENUM.number = 3
EFIGHTBARSTATE.name = "EFightBarState"
EFIGHTBARSTATE.full_name = ".Cmd.EFightBarState"
EFIGHTBARSTATE.values = {
  EFIGHTBARSTATE_EFIGHT_BAR_STATE_MIN_ENUM,
  EFIGHTBARSTATE_EFIGHT_BAR_STATE_BEGIN_ENUM,
  EFIGHTBARSTATE_EFIGHT_BAR_STATE_PAUSE_ENUM,
  EFIGHTBARSTATE_EFIGHT_BAR_STATE_DEL_ENUM
}
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MIN_ENUM.name = "EFAIRYTALEWAVETYPE_MIN"
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MIN_ENUM.index = 0
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MIN_ENUM.number = 0
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_NORMAL_ENUM.name = "EFAIRYTALEWAVETYPE_NORMAL"
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_NORMAL_ENUM.index = 1
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_NORMAL_ENUM.number = 1
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MINI_ENUM.name = "EFAIRYTALEWAVETYPE_MINI"
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MINI_ENUM.index = 2
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MINI_ENUM.number = 2
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MVP_ENUM.name = "EFAIRYTALEWAVETYPE_MVP"
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MVP_ENUM.index = 3
EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MVP_ENUM.number = 3
EFAIRYTALEWAVETYPE.name = "EFairyTaleWaveType"
EFAIRYTALEWAVETYPE.full_name = ".Cmd.EFairyTaleWaveType"
EFAIRYTALEWAVETYPE.values = {
  EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MIN_ENUM,
  EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_NORMAL_ENUM,
  EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MINI_ENUM,
  EFAIRYTALEWAVETYPE_EFAIRYTALEWAVETYPE_MVP_ENUM
}
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MIN_ENUM.name = "EMEMORY_EQUIP_REWARD_MIN"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MIN_ENUM.index = 0
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MIN_ENUM.number = 0
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_UP_LEVEL_ENUM.name = "EMEMORY_EQUIP_REWARD_UP_LEVEL"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_UP_LEVEL_ENUM.index = 1
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_UP_LEVEL_ENUM.number = 1
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_TO_BREAK_ENUM.name = "EMEMORY_EQUIP_REWARD_TO_BREAK"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_TO_BREAK_ENUM.index = 2
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_TO_BREAK_ENUM.number = 2
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_LEVEL_ENUM.name = "EMEMORY_EQUIP_REWARD_MAX_LEVEL"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_LEVEL_ENUM.index = 3
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_LEVEL_ENUM.number = 3
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_BREAK_ENUM.name = "EMEMORY_EQUIP_REWARD_MAX_BREAK"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_BREAK_ENUM.index = 4
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_BREAK_ENUM.number = 4
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_EMPTY_ENUM.name = "EMEMORY_EQUIP_REWARD_EMPTY"
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_EMPTY_ENUM.index = 5
EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_EMPTY_ENUM.number = 5
EMEMORYEQUIPREWARDSTATE.name = "EMemoryEquipRewardState"
EMEMORYEQUIPREWARDSTATE.full_name = ".Cmd.EMemoryEquipRewardState"
EMEMORYEQUIPREWARDSTATE.values = {
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MIN_ENUM,
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_UP_LEVEL_ENUM,
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_TO_BREAK_ENUM,
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_LEVEL_ENUM,
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_MAX_BREAK_ENUM,
  EMEMORYEQUIPREWARDSTATE_EMEMORY_EQUIP_REWARD_EMPTY_ENUM
}
TRACKDATA_STAR_FIELD.name = "star"
TRACKDATA_STAR_FIELD.full_name = ".Cmd.TrackData.star"
TRACKDATA_STAR_FIELD.number = 1
TRACKDATA_STAR_FIELD.index = 0
TRACKDATA_STAR_FIELD.label = 1
TRACKDATA_STAR_FIELD.has_default_value = false
TRACKDATA_STAR_FIELD.default_value = 0
TRACKDATA_STAR_FIELD.type = 13
TRACKDATA_STAR_FIELD.cpp_type = 3
TRACKDATA_ID_FIELD.name = "id"
TRACKDATA_ID_FIELD.full_name = ".Cmd.TrackData.id"
TRACKDATA_ID_FIELD.number = 2
TRACKDATA_ID_FIELD.index = 1
TRACKDATA_ID_FIELD.label = 1
TRACKDATA_ID_FIELD.has_default_value = false
TRACKDATA_ID_FIELD.default_value = 0
TRACKDATA_ID_FIELD.type = 13
TRACKDATA_ID_FIELD.cpp_type = 3
TRACKDATA.name = "TrackData"
TRACKDATA.full_name = ".Cmd.TrackData"
TRACKDATA.nested_types = {}
TRACKDATA.enum_types = {}
TRACKDATA.fields = {
  TRACKDATA_STAR_FIELD,
  TRACKDATA_ID_FIELD
}
TRACKDATA.is_extendable = false
TRACKDATA.extensions = {}
RAIDPCONFIG_RAIDID_FIELD.name = "RaidID"
RAIDPCONFIG_RAIDID_FIELD.full_name = ".Cmd.RaidPConfig.RaidID"
RAIDPCONFIG_RAIDID_FIELD.number = 1
RAIDPCONFIG_RAIDID_FIELD.index = 0
RAIDPCONFIG_RAIDID_FIELD.label = 1
RAIDPCONFIG_RAIDID_FIELD.has_default_value = true
RAIDPCONFIG_RAIDID_FIELD.default_value = 0
RAIDPCONFIG_RAIDID_FIELD.type = 13
RAIDPCONFIG_RAIDID_FIELD.cpp_type = 3
RAIDPCONFIG_STARID_FIELD.name = "starID"
RAIDPCONFIG_STARID_FIELD.full_name = ".Cmd.RaidPConfig.starID"
RAIDPCONFIG_STARID_FIELD.number = 2
RAIDPCONFIG_STARID_FIELD.index = 1
RAIDPCONFIG_STARID_FIELD.label = 1
RAIDPCONFIG_STARID_FIELD.has_default_value = true
RAIDPCONFIG_STARID_FIELD.default_value = 0
RAIDPCONFIG_STARID_FIELD.type = 13
RAIDPCONFIG_STARID_FIELD.cpp_type = 3
RAIDPCONFIG_AUTO_FIELD.name = "Auto"
RAIDPCONFIG_AUTO_FIELD.full_name = ".Cmd.RaidPConfig.Auto"
RAIDPCONFIG_AUTO_FIELD.number = 3
RAIDPCONFIG_AUTO_FIELD.index = 2
RAIDPCONFIG_AUTO_FIELD.label = 1
RAIDPCONFIG_AUTO_FIELD.has_default_value = true
RAIDPCONFIG_AUTO_FIELD.default_value = 0
RAIDPCONFIG_AUTO_FIELD.type = 13
RAIDPCONFIG_AUTO_FIELD.cpp_type = 3
RAIDPCONFIG_WHETHERTRACE_FIELD.name = "WhetherTrace"
RAIDPCONFIG_WHETHERTRACE_FIELD.full_name = ".Cmd.RaidPConfig.WhetherTrace"
RAIDPCONFIG_WHETHERTRACE_FIELD.number = 4
RAIDPCONFIG_WHETHERTRACE_FIELD.index = 3
RAIDPCONFIG_WHETHERTRACE_FIELD.label = 1
RAIDPCONFIG_WHETHERTRACE_FIELD.has_default_value = true
RAIDPCONFIG_WHETHERTRACE_FIELD.default_value = 0
RAIDPCONFIG_WHETHERTRACE_FIELD.type = 13
RAIDPCONFIG_WHETHERTRACE_FIELD.cpp_type = 3
RAIDPCONFIG_FINISHJUMP_FIELD.name = "FinishJump"
RAIDPCONFIG_FINISHJUMP_FIELD.full_name = ".Cmd.RaidPConfig.FinishJump"
RAIDPCONFIG_FINISHJUMP_FIELD.number = 9
RAIDPCONFIG_FINISHJUMP_FIELD.index = 4
RAIDPCONFIG_FINISHJUMP_FIELD.label = 1
RAIDPCONFIG_FINISHJUMP_FIELD.has_default_value = true
RAIDPCONFIG_FINISHJUMP_FIELD.default_value = 0
RAIDPCONFIG_FINISHJUMP_FIELD.type = 13
RAIDPCONFIG_FINISHJUMP_FIELD.cpp_type = 3
RAIDPCONFIG_FAILJUMP_FIELD.name = "FailJump"
RAIDPCONFIG_FAILJUMP_FIELD.full_name = ".Cmd.RaidPConfig.FailJump"
RAIDPCONFIG_FAILJUMP_FIELD.number = 10
RAIDPCONFIG_FAILJUMP_FIELD.index = 5
RAIDPCONFIG_FAILJUMP_FIELD.label = 1
RAIDPCONFIG_FAILJUMP_FIELD.has_default_value = true
RAIDPCONFIG_FAILJUMP_FIELD.default_value = 0
RAIDPCONFIG_FAILJUMP_FIELD.type = 13
RAIDPCONFIG_FAILJUMP_FIELD.cpp_type = 3
RAIDPCONFIG_SUBSTEP_FIELD.name = "SubStep"
RAIDPCONFIG_SUBSTEP_FIELD.full_name = ".Cmd.RaidPConfig.SubStep"
RAIDPCONFIG_SUBSTEP_FIELD.number = 11
RAIDPCONFIG_SUBSTEP_FIELD.index = 6
RAIDPCONFIG_SUBSTEP_FIELD.label = 1
RAIDPCONFIG_SUBSTEP_FIELD.has_default_value = false
RAIDPCONFIG_SUBSTEP_FIELD.default_value = 0
RAIDPCONFIG_SUBSTEP_FIELD.type = 13
RAIDPCONFIG_SUBSTEP_FIELD.cpp_type = 3
RAIDPCONFIG_DESCINFO_FIELD.name = "DescInfo"
RAIDPCONFIG_DESCINFO_FIELD.full_name = ".Cmd.RaidPConfig.DescInfo"
RAIDPCONFIG_DESCINFO_FIELD.number = 5
RAIDPCONFIG_DESCINFO_FIELD.index = 7
RAIDPCONFIG_DESCINFO_FIELD.label = 1
RAIDPCONFIG_DESCINFO_FIELD.has_default_value = false
RAIDPCONFIG_DESCINFO_FIELD.default_value = ""
RAIDPCONFIG_DESCINFO_FIELD.type = 9
RAIDPCONFIG_DESCINFO_FIELD.cpp_type = 9
RAIDPCONFIG_CONTENT_FIELD.name = "Content"
RAIDPCONFIG_CONTENT_FIELD.full_name = ".Cmd.RaidPConfig.Content"
RAIDPCONFIG_CONTENT_FIELD.number = 6
RAIDPCONFIG_CONTENT_FIELD.index = 8
RAIDPCONFIG_CONTENT_FIELD.label = 1
RAIDPCONFIG_CONTENT_FIELD.has_default_value = false
RAIDPCONFIG_CONTENT_FIELD.default_value = ""
RAIDPCONFIG_CONTENT_FIELD.type = 9
RAIDPCONFIG_CONTENT_FIELD.cpp_type = 9
RAIDPCONFIG_TRACEINFO_FIELD.name = "TraceInfo"
RAIDPCONFIG_TRACEINFO_FIELD.full_name = ".Cmd.RaidPConfig.TraceInfo"
RAIDPCONFIG_TRACEINFO_FIELD.number = 7
RAIDPCONFIG_TRACEINFO_FIELD.index = 9
RAIDPCONFIG_TRACEINFO_FIELD.label = 1
RAIDPCONFIG_TRACEINFO_FIELD.has_default_value = false
RAIDPCONFIG_TRACEINFO_FIELD.default_value = ""
RAIDPCONFIG_TRACEINFO_FIELD.type = 9
RAIDPCONFIG_TRACEINFO_FIELD.cpp_type = 9
RAIDPCONFIG_PARAMS_FIELD.name = "params"
RAIDPCONFIG_PARAMS_FIELD.full_name = ".Cmd.RaidPConfig.params"
RAIDPCONFIG_PARAMS_FIELD.number = 8
RAIDPCONFIG_PARAMS_FIELD.index = 10
RAIDPCONFIG_PARAMS_FIELD.label = 1
RAIDPCONFIG_PARAMS_FIELD.has_default_value = false
RAIDPCONFIG_PARAMS_FIELD.default_value = nil
RAIDPCONFIG_PARAMS_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
RAIDPCONFIG_PARAMS_FIELD.type = 11
RAIDPCONFIG_PARAMS_FIELD.cpp_type = 10
RAIDPCONFIG_EXTRAJUMP_FIELD.name = "ExtraJump"
RAIDPCONFIG_EXTRAJUMP_FIELD.full_name = ".Cmd.RaidPConfig.ExtraJump"
RAIDPCONFIG_EXTRAJUMP_FIELD.number = 12
RAIDPCONFIG_EXTRAJUMP_FIELD.index = 11
RAIDPCONFIG_EXTRAJUMP_FIELD.label = 1
RAIDPCONFIG_EXTRAJUMP_FIELD.has_default_value = false
RAIDPCONFIG_EXTRAJUMP_FIELD.default_value = nil
RAIDPCONFIG_EXTRAJUMP_FIELD.message_type = ProtoCommon_pb.CONFIGPARAM
RAIDPCONFIG_EXTRAJUMP_FIELD.type = 11
RAIDPCONFIG_EXTRAJUMP_FIELD.cpp_type = 10
RAIDPCONFIG.name = "RaidPConfig"
RAIDPCONFIG.full_name = ".Cmd.RaidPConfig"
RAIDPCONFIG.nested_types = {}
RAIDPCONFIG.enum_types = {}
RAIDPCONFIG.fields = {
  RAIDPCONFIG_RAIDID_FIELD,
  RAIDPCONFIG_STARID_FIELD,
  RAIDPCONFIG_AUTO_FIELD,
  RAIDPCONFIG_WHETHERTRACE_FIELD,
  RAIDPCONFIG_FINISHJUMP_FIELD,
  RAIDPCONFIG_FAILJUMP_FIELD,
  RAIDPCONFIG_SUBSTEP_FIELD,
  RAIDPCONFIG_DESCINFO_FIELD,
  RAIDPCONFIG_CONTENT_FIELD,
  RAIDPCONFIG_TRACEINFO_FIELD,
  RAIDPCONFIG_PARAMS_FIELD,
  RAIDPCONFIG_EXTRAJUMP_FIELD
}
RAIDPCONFIG.is_extendable = false
RAIDPCONFIG.extensions = {}
TRACKFUBENUSERCMD_CMD_FIELD.name = "cmd"
TRACKFUBENUSERCMD_CMD_FIELD.full_name = ".Cmd.TrackFuBenUserCmd.cmd"
TRACKFUBENUSERCMD_CMD_FIELD.number = 1
TRACKFUBENUSERCMD_CMD_FIELD.index = 0
TRACKFUBENUSERCMD_CMD_FIELD.label = 1
TRACKFUBENUSERCMD_CMD_FIELD.has_default_value = true
TRACKFUBENUSERCMD_CMD_FIELD.default_value = 11
TRACKFUBENUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRACKFUBENUSERCMD_CMD_FIELD.type = 14
TRACKFUBENUSERCMD_CMD_FIELD.cpp_type = 8
TRACKFUBENUSERCMD_PARAM_FIELD.name = "param"
TRACKFUBENUSERCMD_PARAM_FIELD.full_name = ".Cmd.TrackFuBenUserCmd.param"
TRACKFUBENUSERCMD_PARAM_FIELD.number = 2
TRACKFUBENUSERCMD_PARAM_FIELD.index = 1
TRACKFUBENUSERCMD_PARAM_FIELD.label = 1
TRACKFUBENUSERCMD_PARAM_FIELD.has_default_value = true
TRACKFUBENUSERCMD_PARAM_FIELD.default_value = 1
TRACKFUBENUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
TRACKFUBENUSERCMD_PARAM_FIELD.type = 14
TRACKFUBENUSERCMD_PARAM_FIELD.cpp_type = 8
TRACKFUBENUSERCMD_DATA_FIELD.name = "data"
TRACKFUBENUSERCMD_DATA_FIELD.full_name = ".Cmd.TrackFuBenUserCmd.data"
TRACKFUBENUSERCMD_DATA_FIELD.number = 3
TRACKFUBENUSERCMD_DATA_FIELD.index = 2
TRACKFUBENUSERCMD_DATA_FIELD.label = 3
TRACKFUBENUSERCMD_DATA_FIELD.has_default_value = false
TRACKFUBENUSERCMD_DATA_FIELD.default_value = {}
TRACKFUBENUSERCMD_DATA_FIELD.message_type = TRACKDATA
TRACKFUBENUSERCMD_DATA_FIELD.type = 11
TRACKFUBENUSERCMD_DATA_FIELD.cpp_type = 10
TRACKFUBENUSERCMD_DMAPID_FIELD.name = "dmapid"
TRACKFUBENUSERCMD_DMAPID_FIELD.full_name = ".Cmd.TrackFuBenUserCmd.dmapid"
TRACKFUBENUSERCMD_DMAPID_FIELD.number = 4
TRACKFUBENUSERCMD_DMAPID_FIELD.index = 3
TRACKFUBENUSERCMD_DMAPID_FIELD.label = 1
TRACKFUBENUSERCMD_DMAPID_FIELD.has_default_value = false
TRACKFUBENUSERCMD_DMAPID_FIELD.default_value = 0
TRACKFUBENUSERCMD_DMAPID_FIELD.type = 13
TRACKFUBENUSERCMD_DMAPID_FIELD.cpp_type = 3
TRACKFUBENUSERCMD_ENDTIME_FIELD.name = "endtime"
TRACKFUBENUSERCMD_ENDTIME_FIELD.full_name = ".Cmd.TrackFuBenUserCmd.endtime"
TRACKFUBENUSERCMD_ENDTIME_FIELD.number = 5
TRACKFUBENUSERCMD_ENDTIME_FIELD.index = 4
TRACKFUBENUSERCMD_ENDTIME_FIELD.label = 1
TRACKFUBENUSERCMD_ENDTIME_FIELD.has_default_value = false
TRACKFUBENUSERCMD_ENDTIME_FIELD.default_value = 0
TRACKFUBENUSERCMD_ENDTIME_FIELD.type = 13
TRACKFUBENUSERCMD_ENDTIME_FIELD.cpp_type = 3
TRACKFUBENUSERCMD.name = "TrackFuBenUserCmd"
TRACKFUBENUSERCMD.full_name = ".Cmd.TrackFuBenUserCmd"
TRACKFUBENUSERCMD.nested_types = {}
TRACKFUBENUSERCMD.enum_types = {}
TRACKFUBENUSERCMD.fields = {
  TRACKFUBENUSERCMD_CMD_FIELD,
  TRACKFUBENUSERCMD_PARAM_FIELD,
  TRACKFUBENUSERCMD_DATA_FIELD,
  TRACKFUBENUSERCMD_DMAPID_FIELD,
  TRACKFUBENUSERCMD_ENDTIME_FIELD
}
TRACKFUBENUSERCMD.is_extendable = false
TRACKFUBENUSERCMD.extensions = {}
FAILFUBENUSERCMD_CMD_FIELD.name = "cmd"
FAILFUBENUSERCMD_CMD_FIELD.full_name = ".Cmd.FailFuBenUserCmd.cmd"
FAILFUBENUSERCMD_CMD_FIELD.number = 1
FAILFUBENUSERCMD_CMD_FIELD.index = 0
FAILFUBENUSERCMD_CMD_FIELD.label = 1
FAILFUBENUSERCMD_CMD_FIELD.has_default_value = true
FAILFUBENUSERCMD_CMD_FIELD.default_value = 11
FAILFUBENUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FAILFUBENUSERCMD_CMD_FIELD.type = 14
FAILFUBENUSERCMD_CMD_FIELD.cpp_type = 8
FAILFUBENUSERCMD_PARAM_FIELD.name = "param"
FAILFUBENUSERCMD_PARAM_FIELD.full_name = ".Cmd.FailFuBenUserCmd.param"
FAILFUBENUSERCMD_PARAM_FIELD.number = 2
FAILFUBENUSERCMD_PARAM_FIELD.index = 1
FAILFUBENUSERCMD_PARAM_FIELD.label = 1
FAILFUBENUSERCMD_PARAM_FIELD.has_default_value = true
FAILFUBENUSERCMD_PARAM_FIELD.default_value = 2
FAILFUBENUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
FAILFUBENUSERCMD_PARAM_FIELD.type = 14
FAILFUBENUSERCMD_PARAM_FIELD.cpp_type = 8
FAILFUBENUSERCMD.name = "FailFuBenUserCmd"
FAILFUBENUSERCMD.full_name = ".Cmd.FailFuBenUserCmd"
FAILFUBENUSERCMD.nested_types = {}
FAILFUBENUSERCMD.enum_types = {}
FAILFUBENUSERCMD.fields = {
  FAILFUBENUSERCMD_CMD_FIELD,
  FAILFUBENUSERCMD_PARAM_FIELD
}
FAILFUBENUSERCMD.is_extendable = false
FAILFUBENUSERCMD.extensions = {}
LEAVEFUBENUSERCMD_CMD_FIELD.name = "cmd"
LEAVEFUBENUSERCMD_CMD_FIELD.full_name = ".Cmd.LeaveFuBenUserCmd.cmd"
LEAVEFUBENUSERCMD_CMD_FIELD.number = 1
LEAVEFUBENUSERCMD_CMD_FIELD.index = 0
LEAVEFUBENUSERCMD_CMD_FIELD.label = 1
LEAVEFUBENUSERCMD_CMD_FIELD.has_default_value = true
LEAVEFUBENUSERCMD_CMD_FIELD.default_value = 11
LEAVEFUBENUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
LEAVEFUBENUSERCMD_CMD_FIELD.type = 14
LEAVEFUBENUSERCMD_CMD_FIELD.cpp_type = 8
LEAVEFUBENUSERCMD_PARAM_FIELD.name = "param"
LEAVEFUBENUSERCMD_PARAM_FIELD.full_name = ".Cmd.LeaveFuBenUserCmd.param"
LEAVEFUBENUSERCMD_PARAM_FIELD.number = 2
LEAVEFUBENUSERCMD_PARAM_FIELD.index = 1
LEAVEFUBENUSERCMD_PARAM_FIELD.label = 1
LEAVEFUBENUSERCMD_PARAM_FIELD.has_default_value = true
LEAVEFUBENUSERCMD_PARAM_FIELD.default_value = 3
LEAVEFUBENUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
LEAVEFUBENUSERCMD_PARAM_FIELD.type = 14
LEAVEFUBENUSERCMD_PARAM_FIELD.cpp_type = 8
LEAVEFUBENUSERCMD_MAPID_FIELD.name = "mapid"
LEAVEFUBENUSERCMD_MAPID_FIELD.full_name = ".Cmd.LeaveFuBenUserCmd.mapid"
LEAVEFUBENUSERCMD_MAPID_FIELD.number = 3
LEAVEFUBENUSERCMD_MAPID_FIELD.index = 2
LEAVEFUBENUSERCMD_MAPID_FIELD.label = 1
LEAVEFUBENUSERCMD_MAPID_FIELD.has_default_value = false
LEAVEFUBENUSERCMD_MAPID_FIELD.default_value = 0
LEAVEFUBENUSERCMD_MAPID_FIELD.type = 13
LEAVEFUBENUSERCMD_MAPID_FIELD.cpp_type = 3
LEAVEFUBENUSERCMD.name = "LeaveFuBenUserCmd"
LEAVEFUBENUSERCMD.full_name = ".Cmd.LeaveFuBenUserCmd"
LEAVEFUBENUSERCMD.nested_types = {}
LEAVEFUBENUSERCMD.enum_types = {}
LEAVEFUBENUSERCMD.fields = {
  LEAVEFUBENUSERCMD_CMD_FIELD,
  LEAVEFUBENUSERCMD_PARAM_FIELD,
  LEAVEFUBENUSERCMD_MAPID_FIELD
}
LEAVEFUBENUSERCMD.is_extendable = false
LEAVEFUBENUSERCMD.extensions = {}
SUCCESSFUBENUSERCMD_CMD_FIELD.name = "cmd"
SUCCESSFUBENUSERCMD_CMD_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.cmd"
SUCCESSFUBENUSERCMD_CMD_FIELD.number = 1
SUCCESSFUBENUSERCMD_CMD_FIELD.index = 0
SUCCESSFUBENUSERCMD_CMD_FIELD.label = 1
SUCCESSFUBENUSERCMD_CMD_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_CMD_FIELD.default_value = 11
SUCCESSFUBENUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SUCCESSFUBENUSERCMD_CMD_FIELD.type = 14
SUCCESSFUBENUSERCMD_CMD_FIELD.cpp_type = 8
SUCCESSFUBENUSERCMD_PARAM_FIELD.name = "param"
SUCCESSFUBENUSERCMD_PARAM_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.param"
SUCCESSFUBENUSERCMD_PARAM_FIELD.number = 2
SUCCESSFUBENUSERCMD_PARAM_FIELD.index = 1
SUCCESSFUBENUSERCMD_PARAM_FIELD.label = 1
SUCCESSFUBENUSERCMD_PARAM_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_PARAM_FIELD.default_value = 4
SUCCESSFUBENUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
SUCCESSFUBENUSERCMD_PARAM_FIELD.type = 14
SUCCESSFUBENUSERCMD_PARAM_FIELD.cpp_type = 8
SUCCESSFUBENUSERCMD_TYPE_FIELD.name = "type"
SUCCESSFUBENUSERCMD_TYPE_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.type"
SUCCESSFUBENUSERCMD_TYPE_FIELD.number = 3
SUCCESSFUBENUSERCMD_TYPE_FIELD.index = 2
SUCCESSFUBENUSERCMD_TYPE_FIELD.label = 1
SUCCESSFUBENUSERCMD_TYPE_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_TYPE_FIELD.default_value = 0
SUCCESSFUBENUSERCMD_TYPE_FIELD.enum_type = ERAIDTYPE
SUCCESSFUBENUSERCMD_TYPE_FIELD.type = 14
SUCCESSFUBENUSERCMD_TYPE_FIELD.cpp_type = 8
SUCCESSFUBENUSERCMD_PARAM1_FIELD.name = "param1"
SUCCESSFUBENUSERCMD_PARAM1_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.param1"
SUCCESSFUBENUSERCMD_PARAM1_FIELD.number = 4
SUCCESSFUBENUSERCMD_PARAM1_FIELD.index = 3
SUCCESSFUBENUSERCMD_PARAM1_FIELD.label = 1
SUCCESSFUBENUSERCMD_PARAM1_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_PARAM1_FIELD.default_value = 0
SUCCESSFUBENUSERCMD_PARAM1_FIELD.type = 13
SUCCESSFUBENUSERCMD_PARAM1_FIELD.cpp_type = 3
SUCCESSFUBENUSERCMD_PARAM2_FIELD.name = "param2"
SUCCESSFUBENUSERCMD_PARAM2_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.param2"
SUCCESSFUBENUSERCMD_PARAM2_FIELD.number = 5
SUCCESSFUBENUSERCMD_PARAM2_FIELD.index = 4
SUCCESSFUBENUSERCMD_PARAM2_FIELD.label = 1
SUCCESSFUBENUSERCMD_PARAM2_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_PARAM2_FIELD.default_value = 0
SUCCESSFUBENUSERCMD_PARAM2_FIELD.type = 13
SUCCESSFUBENUSERCMD_PARAM2_FIELD.cpp_type = 3
SUCCESSFUBENUSERCMD_PARAM3_FIELD.name = "param3"
SUCCESSFUBENUSERCMD_PARAM3_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.param3"
SUCCESSFUBENUSERCMD_PARAM3_FIELD.number = 6
SUCCESSFUBENUSERCMD_PARAM3_FIELD.index = 5
SUCCESSFUBENUSERCMD_PARAM3_FIELD.label = 1
SUCCESSFUBENUSERCMD_PARAM3_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_PARAM3_FIELD.default_value = 0
SUCCESSFUBENUSERCMD_PARAM3_FIELD.type = 13
SUCCESSFUBENUSERCMD_PARAM3_FIELD.cpp_type = 3
SUCCESSFUBENUSERCMD_PARAM4_FIELD.name = "param4"
SUCCESSFUBENUSERCMD_PARAM4_FIELD.full_name = ".Cmd.SuccessFuBenUserCmd.param4"
SUCCESSFUBENUSERCMD_PARAM4_FIELD.number = 7
SUCCESSFUBENUSERCMD_PARAM4_FIELD.index = 6
SUCCESSFUBENUSERCMD_PARAM4_FIELD.label = 1
SUCCESSFUBENUSERCMD_PARAM4_FIELD.has_default_value = true
SUCCESSFUBENUSERCMD_PARAM4_FIELD.default_value = 0
SUCCESSFUBENUSERCMD_PARAM4_FIELD.type = 13
SUCCESSFUBENUSERCMD_PARAM4_FIELD.cpp_type = 3
SUCCESSFUBENUSERCMD.name = "SuccessFuBenUserCmd"
SUCCESSFUBENUSERCMD.full_name = ".Cmd.SuccessFuBenUserCmd"
SUCCESSFUBENUSERCMD.nested_types = {}
SUCCESSFUBENUSERCMD.enum_types = {}
SUCCESSFUBENUSERCMD.fields = {
  SUCCESSFUBENUSERCMD_CMD_FIELD,
  SUCCESSFUBENUSERCMD_PARAM_FIELD,
  SUCCESSFUBENUSERCMD_TYPE_FIELD,
  SUCCESSFUBENUSERCMD_PARAM1_FIELD,
  SUCCESSFUBENUSERCMD_PARAM2_FIELD,
  SUCCESSFUBENUSERCMD_PARAM3_FIELD,
  SUCCESSFUBENUSERCMD_PARAM4_FIELD
}
SUCCESSFUBENUSERCMD.is_extendable = false
SUCCESSFUBENUSERCMD.extensions = {}
WORLDSTAGEITEM_ID_FIELD.name = "id"
WORLDSTAGEITEM_ID_FIELD.full_name = ".Cmd.WorldStageItem.id"
WORLDSTAGEITEM_ID_FIELD.number = 1
WORLDSTAGEITEM_ID_FIELD.index = 0
WORLDSTAGEITEM_ID_FIELD.label = 1
WORLDSTAGEITEM_ID_FIELD.has_default_value = false
WORLDSTAGEITEM_ID_FIELD.default_value = 0
WORLDSTAGEITEM_ID_FIELD.type = 13
WORLDSTAGEITEM_ID_FIELD.cpp_type = 3
WORLDSTAGEITEM_STAR_FIELD.name = "star"
WORLDSTAGEITEM_STAR_FIELD.full_name = ".Cmd.WorldStageItem.star"
WORLDSTAGEITEM_STAR_FIELD.number = 2
WORLDSTAGEITEM_STAR_FIELD.index = 1
WORLDSTAGEITEM_STAR_FIELD.label = 1
WORLDSTAGEITEM_STAR_FIELD.has_default_value = false
WORLDSTAGEITEM_STAR_FIELD.default_value = 0
WORLDSTAGEITEM_STAR_FIELD.type = 13
WORLDSTAGEITEM_STAR_FIELD.cpp_type = 3
WORLDSTAGEITEM_GETLIST_FIELD.name = "getList"
WORLDSTAGEITEM_GETLIST_FIELD.full_name = ".Cmd.WorldStageItem.getList"
WORLDSTAGEITEM_GETLIST_FIELD.number = 3
WORLDSTAGEITEM_GETLIST_FIELD.index = 2
WORLDSTAGEITEM_GETLIST_FIELD.label = 3
WORLDSTAGEITEM_GETLIST_FIELD.has_default_value = false
WORLDSTAGEITEM_GETLIST_FIELD.default_value = {}
WORLDSTAGEITEM_GETLIST_FIELD.type = 13
WORLDSTAGEITEM_GETLIST_FIELD.cpp_type = 3
WORLDSTAGEITEM.name = "WorldStageItem"
WORLDSTAGEITEM.full_name = ".Cmd.WorldStageItem"
WORLDSTAGEITEM.nested_types = {}
WORLDSTAGEITEM.enum_types = {}
WORLDSTAGEITEM.fields = {
  WORLDSTAGEITEM_ID_FIELD,
  WORLDSTAGEITEM_STAR_FIELD,
  WORLDSTAGEITEM_GETLIST_FIELD
}
WORLDSTAGEITEM.is_extendable = false
WORLDSTAGEITEM.extensions = {}
STAGESTEPITEM_STAGEID_FIELD.name = "stageid"
STAGESTEPITEM_STAGEID_FIELD.full_name = ".Cmd.StageStepItem.stageid"
STAGESTEPITEM_STAGEID_FIELD.number = 1
STAGESTEPITEM_STAGEID_FIELD.index = 0
STAGESTEPITEM_STAGEID_FIELD.label = 1
STAGESTEPITEM_STAGEID_FIELD.has_default_value = false
STAGESTEPITEM_STAGEID_FIELD.default_value = 0
STAGESTEPITEM_STAGEID_FIELD.type = 13
STAGESTEPITEM_STAGEID_FIELD.cpp_type = 3
STAGESTEPITEM_STEPID_FIELD.name = "stepid"
STAGESTEPITEM_STEPID_FIELD.full_name = ".Cmd.StageStepItem.stepid"
STAGESTEPITEM_STEPID_FIELD.number = 2
STAGESTEPITEM_STEPID_FIELD.index = 1
STAGESTEPITEM_STEPID_FIELD.label = 1
STAGESTEPITEM_STEPID_FIELD.has_default_value = false
STAGESTEPITEM_STEPID_FIELD.default_value = 0
STAGESTEPITEM_STEPID_FIELD.type = 13
STAGESTEPITEM_STEPID_FIELD.cpp_type = 3
STAGESTEPITEM_TYPE_FIELD.name = "type"
STAGESTEPITEM_TYPE_FIELD.full_name = ".Cmd.StageStepItem.type"
STAGESTEPITEM_TYPE_FIELD.number = 3
STAGESTEPITEM_TYPE_FIELD.index = 2
STAGESTEPITEM_TYPE_FIELD.label = 1
STAGESTEPITEM_TYPE_FIELD.has_default_value = false
STAGESTEPITEM_TYPE_FIELD.default_value = 0
STAGESTEPITEM_TYPE_FIELD.type = 13
STAGESTEPITEM_TYPE_FIELD.cpp_type = 3
STAGESTEPITEM.name = "StageStepItem"
STAGESTEPITEM.full_name = ".Cmd.StageStepItem"
STAGESTEPITEM.nested_types = {}
STAGESTEPITEM.enum_types = {}
STAGESTEPITEM.fields = {
  STAGESTEPITEM_STAGEID_FIELD,
  STAGESTEPITEM_STEPID_FIELD,
  STAGESTEPITEM_TYPE_FIELD
}
STAGESTEPITEM.is_extendable = false
STAGESTEPITEM.extensions = {}
WORLDSTAGEUSERCMD_CMD_FIELD.name = "cmd"
WORLDSTAGEUSERCMD_CMD_FIELD.full_name = ".Cmd.WorldStageUserCmd.cmd"
WORLDSTAGEUSERCMD_CMD_FIELD.number = 1
WORLDSTAGEUSERCMD_CMD_FIELD.index = 0
WORLDSTAGEUSERCMD_CMD_FIELD.label = 1
WORLDSTAGEUSERCMD_CMD_FIELD.has_default_value = true
WORLDSTAGEUSERCMD_CMD_FIELD.default_value = 11
WORLDSTAGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
WORLDSTAGEUSERCMD_CMD_FIELD.type = 14
WORLDSTAGEUSERCMD_CMD_FIELD.cpp_type = 8
WORLDSTAGEUSERCMD_PARAM_FIELD.name = "param"
WORLDSTAGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.WorldStageUserCmd.param"
WORLDSTAGEUSERCMD_PARAM_FIELD.number = 2
WORLDSTAGEUSERCMD_PARAM_FIELD.index = 1
WORLDSTAGEUSERCMD_PARAM_FIELD.label = 1
WORLDSTAGEUSERCMD_PARAM_FIELD.has_default_value = true
WORLDSTAGEUSERCMD_PARAM_FIELD.default_value = 5
WORLDSTAGEUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
WORLDSTAGEUSERCMD_PARAM_FIELD.type = 14
WORLDSTAGEUSERCMD_PARAM_FIELD.cpp_type = 8
WORLDSTAGEUSERCMD_LIST_FIELD.name = "list"
WORLDSTAGEUSERCMD_LIST_FIELD.full_name = ".Cmd.WorldStageUserCmd.list"
WORLDSTAGEUSERCMD_LIST_FIELD.number = 3
WORLDSTAGEUSERCMD_LIST_FIELD.index = 2
WORLDSTAGEUSERCMD_LIST_FIELD.label = 3
WORLDSTAGEUSERCMD_LIST_FIELD.has_default_value = false
WORLDSTAGEUSERCMD_LIST_FIELD.default_value = {}
WORLDSTAGEUSERCMD_LIST_FIELD.message_type = WORLDSTAGEITEM
WORLDSTAGEUSERCMD_LIST_FIELD.type = 11
WORLDSTAGEUSERCMD_LIST_FIELD.cpp_type = 10
WORLDSTAGEUSERCMD_CURINFO_FIELD.name = "curinfo"
WORLDSTAGEUSERCMD_CURINFO_FIELD.full_name = ".Cmd.WorldStageUserCmd.curinfo"
WORLDSTAGEUSERCMD_CURINFO_FIELD.number = 4
WORLDSTAGEUSERCMD_CURINFO_FIELD.index = 3
WORLDSTAGEUSERCMD_CURINFO_FIELD.label = 3
WORLDSTAGEUSERCMD_CURINFO_FIELD.has_default_value = false
WORLDSTAGEUSERCMD_CURINFO_FIELD.default_value = {}
WORLDSTAGEUSERCMD_CURINFO_FIELD.message_type = STAGESTEPITEM
WORLDSTAGEUSERCMD_CURINFO_FIELD.type = 11
WORLDSTAGEUSERCMD_CURINFO_FIELD.cpp_type = 10
WORLDSTAGEUSERCMD.name = "WorldStageUserCmd"
WORLDSTAGEUSERCMD.full_name = ".Cmd.WorldStageUserCmd"
WORLDSTAGEUSERCMD.nested_types = {}
WORLDSTAGEUSERCMD.enum_types = {}
WORLDSTAGEUSERCMD.fields = {
  WORLDSTAGEUSERCMD_CMD_FIELD,
  WORLDSTAGEUSERCMD_PARAM_FIELD,
  WORLDSTAGEUSERCMD_LIST_FIELD,
  WORLDSTAGEUSERCMD_CURINFO_FIELD
}
WORLDSTAGEUSERCMD.is_extendable = false
WORLDSTAGEUSERCMD.extensions = {}
STAGENORMALSTEPITEM_STEPID_FIELD.name = "stepid"
STAGENORMALSTEPITEM_STEPID_FIELD.full_name = ".Cmd.StageNormalStepItem.stepid"
STAGENORMALSTEPITEM_STEPID_FIELD.number = 1
STAGENORMALSTEPITEM_STEPID_FIELD.index = 0
STAGENORMALSTEPITEM_STEPID_FIELD.label = 1
STAGENORMALSTEPITEM_STEPID_FIELD.has_default_value = false
STAGENORMALSTEPITEM_STEPID_FIELD.default_value = 0
STAGENORMALSTEPITEM_STEPID_FIELD.type = 13
STAGENORMALSTEPITEM_STEPID_FIELD.cpp_type = 3
STAGENORMALSTEPITEM_STAR_FIELD.name = "star"
STAGENORMALSTEPITEM_STAR_FIELD.full_name = ".Cmd.StageNormalStepItem.star"
STAGENORMALSTEPITEM_STAR_FIELD.number = 2
STAGENORMALSTEPITEM_STAR_FIELD.index = 1
STAGENORMALSTEPITEM_STAR_FIELD.label = 1
STAGENORMALSTEPITEM_STAR_FIELD.has_default_value = false
STAGENORMALSTEPITEM_STAR_FIELD.default_value = 0
STAGENORMALSTEPITEM_STAR_FIELD.type = 13
STAGENORMALSTEPITEM_STAR_FIELD.cpp_type = 3
STAGENORMALSTEPITEM.name = "StageNormalStepItem"
STAGENORMALSTEPITEM.full_name = ".Cmd.StageNormalStepItem"
STAGENORMALSTEPITEM.nested_types = {}
STAGENORMALSTEPITEM.enum_types = {}
STAGENORMALSTEPITEM.fields = {
  STAGENORMALSTEPITEM_STEPID_FIELD,
  STAGENORMALSTEPITEM_STAR_FIELD
}
STAGENORMALSTEPITEM.is_extendable = false
STAGENORMALSTEPITEM.extensions = {}
STAGEHARDSTEPITEM_STEPID_FIELD.name = "stepid"
STAGEHARDSTEPITEM_STEPID_FIELD.full_name = ".Cmd.StageHardStepItem.stepid"
STAGEHARDSTEPITEM_STEPID_FIELD.number = 1
STAGEHARDSTEPITEM_STEPID_FIELD.index = 0
STAGEHARDSTEPITEM_STEPID_FIELD.label = 1
STAGEHARDSTEPITEM_STEPID_FIELD.has_default_value = false
STAGEHARDSTEPITEM_STEPID_FIELD.default_value = 0
STAGEHARDSTEPITEM_STEPID_FIELD.type = 13
STAGEHARDSTEPITEM_STEPID_FIELD.cpp_type = 3
STAGEHARDSTEPITEM_FINISH_FIELD.name = "finish"
STAGEHARDSTEPITEM_FINISH_FIELD.full_name = ".Cmd.StageHardStepItem.finish"
STAGEHARDSTEPITEM_FINISH_FIELD.number = 2
STAGEHARDSTEPITEM_FINISH_FIELD.index = 1
STAGEHARDSTEPITEM_FINISH_FIELD.label = 1
STAGEHARDSTEPITEM_FINISH_FIELD.has_default_value = false
STAGEHARDSTEPITEM_FINISH_FIELD.default_value = 0
STAGEHARDSTEPITEM_FINISH_FIELD.type = 13
STAGEHARDSTEPITEM_FINISH_FIELD.cpp_type = 3
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.name = "challengeTime"
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.full_name = ".Cmd.StageHardStepItem.challengeTime"
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.number = 3
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.index = 2
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.label = 1
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.has_default_value = false
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.default_value = 0
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.type = 13
STAGEHARDSTEPITEM_CHALLENGETIME_FIELD.cpp_type = 3
STAGEHARDSTEPITEM.name = "StageHardStepItem"
STAGEHARDSTEPITEM.full_name = ".Cmd.StageHardStepItem"
STAGEHARDSTEPITEM.nested_types = {}
STAGEHARDSTEPITEM.enum_types = {}
STAGEHARDSTEPITEM.fields = {
  STAGEHARDSTEPITEM_STEPID_FIELD,
  STAGEHARDSTEPITEM_FINISH_FIELD,
  STAGEHARDSTEPITEM_CHALLENGETIME_FIELD
}
STAGEHARDSTEPITEM.is_extendable = false
STAGEHARDSTEPITEM.extensions = {}
STAGESTEPUSERCMD_CMD_FIELD.name = "cmd"
STAGESTEPUSERCMD_CMD_FIELD.full_name = ".Cmd.StageStepUserCmd.cmd"
STAGESTEPUSERCMD_CMD_FIELD.number = 1
STAGESTEPUSERCMD_CMD_FIELD.index = 0
STAGESTEPUSERCMD_CMD_FIELD.label = 1
STAGESTEPUSERCMD_CMD_FIELD.has_default_value = true
STAGESTEPUSERCMD_CMD_FIELD.default_value = 11
STAGESTEPUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STAGESTEPUSERCMD_CMD_FIELD.type = 14
STAGESTEPUSERCMD_CMD_FIELD.cpp_type = 8
STAGESTEPUSERCMD_PARAM_FIELD.name = "param"
STAGESTEPUSERCMD_PARAM_FIELD.full_name = ".Cmd.StageStepUserCmd.param"
STAGESTEPUSERCMD_PARAM_FIELD.number = 2
STAGESTEPUSERCMD_PARAM_FIELD.index = 1
STAGESTEPUSERCMD_PARAM_FIELD.label = 1
STAGESTEPUSERCMD_PARAM_FIELD.has_default_value = true
STAGESTEPUSERCMD_PARAM_FIELD.default_value = 6
STAGESTEPUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
STAGESTEPUSERCMD_PARAM_FIELD.type = 14
STAGESTEPUSERCMD_PARAM_FIELD.cpp_type = 8
STAGESTEPUSERCMD_STAGEID_FIELD.name = "stageid"
STAGESTEPUSERCMD_STAGEID_FIELD.full_name = ".Cmd.StageStepUserCmd.stageid"
STAGESTEPUSERCMD_STAGEID_FIELD.number = 3
STAGESTEPUSERCMD_STAGEID_FIELD.index = 2
STAGESTEPUSERCMD_STAGEID_FIELD.label = 1
STAGESTEPUSERCMD_STAGEID_FIELD.has_default_value = false
STAGESTEPUSERCMD_STAGEID_FIELD.default_value = 0
STAGESTEPUSERCMD_STAGEID_FIELD.type = 13
STAGESTEPUSERCMD_STAGEID_FIELD.cpp_type = 3
STAGESTEPUSERCMD_NORMALIST_FIELD.name = "normalist"
STAGESTEPUSERCMD_NORMALIST_FIELD.full_name = ".Cmd.StageStepUserCmd.normalist"
STAGESTEPUSERCMD_NORMALIST_FIELD.number = 4
STAGESTEPUSERCMD_NORMALIST_FIELD.index = 3
STAGESTEPUSERCMD_NORMALIST_FIELD.label = 3
STAGESTEPUSERCMD_NORMALIST_FIELD.has_default_value = false
STAGESTEPUSERCMD_NORMALIST_FIELD.default_value = {}
STAGESTEPUSERCMD_NORMALIST_FIELD.message_type = STAGENORMALSTEPITEM
STAGESTEPUSERCMD_NORMALIST_FIELD.type = 11
STAGESTEPUSERCMD_NORMALIST_FIELD.cpp_type = 10
STAGESTEPUSERCMD_HARDLIST_FIELD.name = "hardlist"
STAGESTEPUSERCMD_HARDLIST_FIELD.full_name = ".Cmd.StageStepUserCmd.hardlist"
STAGESTEPUSERCMD_HARDLIST_FIELD.number = 5
STAGESTEPUSERCMD_HARDLIST_FIELD.index = 4
STAGESTEPUSERCMD_HARDLIST_FIELD.label = 3
STAGESTEPUSERCMD_HARDLIST_FIELD.has_default_value = false
STAGESTEPUSERCMD_HARDLIST_FIELD.default_value = {}
STAGESTEPUSERCMD_HARDLIST_FIELD.message_type = STAGEHARDSTEPITEM
STAGESTEPUSERCMD_HARDLIST_FIELD.type = 11
STAGESTEPUSERCMD_HARDLIST_FIELD.cpp_type = 10
STAGESTEPUSERCMD.name = "StageStepUserCmd"
STAGESTEPUSERCMD.full_name = ".Cmd.StageStepUserCmd"
STAGESTEPUSERCMD.nested_types = {}
STAGESTEPUSERCMD.enum_types = {}
STAGESTEPUSERCMD.fields = {
  STAGESTEPUSERCMD_CMD_FIELD,
  STAGESTEPUSERCMD_PARAM_FIELD,
  STAGESTEPUSERCMD_STAGEID_FIELD,
  STAGESTEPUSERCMD_NORMALIST_FIELD,
  STAGESTEPUSERCMD_HARDLIST_FIELD
}
STAGESTEPUSERCMD.is_extendable = false
STAGESTEPUSERCMD.extensions = {}
STARTSTAGEUSERCMD_CMD_FIELD.name = "cmd"
STARTSTAGEUSERCMD_CMD_FIELD.full_name = ".Cmd.StartStageUserCmd.cmd"
STARTSTAGEUSERCMD_CMD_FIELD.number = 1
STARTSTAGEUSERCMD_CMD_FIELD.index = 0
STARTSTAGEUSERCMD_CMD_FIELD.label = 1
STARTSTAGEUSERCMD_CMD_FIELD.has_default_value = true
STARTSTAGEUSERCMD_CMD_FIELD.default_value = 11
STARTSTAGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STARTSTAGEUSERCMD_CMD_FIELD.type = 14
STARTSTAGEUSERCMD_CMD_FIELD.cpp_type = 8
STARTSTAGEUSERCMD_PARAM_FIELD.name = "param"
STARTSTAGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.StartStageUserCmd.param"
STARTSTAGEUSERCMD_PARAM_FIELD.number = 2
STARTSTAGEUSERCMD_PARAM_FIELD.index = 1
STARTSTAGEUSERCMD_PARAM_FIELD.label = 1
STARTSTAGEUSERCMD_PARAM_FIELD.has_default_value = true
STARTSTAGEUSERCMD_PARAM_FIELD.default_value = 7
STARTSTAGEUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
STARTSTAGEUSERCMD_PARAM_FIELD.type = 14
STARTSTAGEUSERCMD_PARAM_FIELD.cpp_type = 8
STARTSTAGEUSERCMD_STAGEID_FIELD.name = "stageid"
STARTSTAGEUSERCMD_STAGEID_FIELD.full_name = ".Cmd.StartStageUserCmd.stageid"
STARTSTAGEUSERCMD_STAGEID_FIELD.number = 3
STARTSTAGEUSERCMD_STAGEID_FIELD.index = 2
STARTSTAGEUSERCMD_STAGEID_FIELD.label = 1
STARTSTAGEUSERCMD_STAGEID_FIELD.has_default_value = false
STARTSTAGEUSERCMD_STAGEID_FIELD.default_value = 0
STARTSTAGEUSERCMD_STAGEID_FIELD.type = 13
STARTSTAGEUSERCMD_STAGEID_FIELD.cpp_type = 3
STARTSTAGEUSERCMD_STEPID_FIELD.name = "stepid"
STARTSTAGEUSERCMD_STEPID_FIELD.full_name = ".Cmd.StartStageUserCmd.stepid"
STARTSTAGEUSERCMD_STEPID_FIELD.number = 4
STARTSTAGEUSERCMD_STEPID_FIELD.index = 3
STARTSTAGEUSERCMD_STEPID_FIELD.label = 1
STARTSTAGEUSERCMD_STEPID_FIELD.has_default_value = false
STARTSTAGEUSERCMD_STEPID_FIELD.default_value = 0
STARTSTAGEUSERCMD_STEPID_FIELD.type = 13
STARTSTAGEUSERCMD_STEPID_FIELD.cpp_type = 3
STARTSTAGEUSERCMD_TYPE_FIELD.name = "type"
STARTSTAGEUSERCMD_TYPE_FIELD.full_name = ".Cmd.StartStageUserCmd.type"
STARTSTAGEUSERCMD_TYPE_FIELD.number = 5
STARTSTAGEUSERCMD_TYPE_FIELD.index = 4
STARTSTAGEUSERCMD_TYPE_FIELD.label = 1
STARTSTAGEUSERCMD_TYPE_FIELD.has_default_value = false
STARTSTAGEUSERCMD_TYPE_FIELD.default_value = 0
STARTSTAGEUSERCMD_TYPE_FIELD.type = 13
STARTSTAGEUSERCMD_TYPE_FIELD.cpp_type = 3
STARTSTAGEUSERCMD.name = "StartStageUserCmd"
STARTSTAGEUSERCMD.full_name = ".Cmd.StartStageUserCmd"
STARTSTAGEUSERCMD.nested_types = {}
STARTSTAGEUSERCMD.enum_types = {}
STARTSTAGEUSERCMD.fields = {
  STARTSTAGEUSERCMD_CMD_FIELD,
  STARTSTAGEUSERCMD_PARAM_FIELD,
  STARTSTAGEUSERCMD_STAGEID_FIELD,
  STARTSTAGEUSERCMD_STEPID_FIELD,
  STARTSTAGEUSERCMD_TYPE_FIELD
}
STARTSTAGEUSERCMD.is_extendable = false
STARTSTAGEUSERCMD.extensions = {}
GETREWARDSTAGEUSERCMD_CMD_FIELD.name = "cmd"
GETREWARDSTAGEUSERCMD_CMD_FIELD.full_name = ".Cmd.GetRewardStageUserCmd.cmd"
GETREWARDSTAGEUSERCMD_CMD_FIELD.number = 1
GETREWARDSTAGEUSERCMD_CMD_FIELD.index = 0
GETREWARDSTAGEUSERCMD_CMD_FIELD.label = 1
GETREWARDSTAGEUSERCMD_CMD_FIELD.has_default_value = true
GETREWARDSTAGEUSERCMD_CMD_FIELD.default_value = 11
GETREWARDSTAGEUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GETREWARDSTAGEUSERCMD_CMD_FIELD.type = 14
GETREWARDSTAGEUSERCMD_CMD_FIELD.cpp_type = 8
GETREWARDSTAGEUSERCMD_PARAM_FIELD.name = "param"
GETREWARDSTAGEUSERCMD_PARAM_FIELD.full_name = ".Cmd.GetRewardStageUserCmd.param"
GETREWARDSTAGEUSERCMD_PARAM_FIELD.number = 2
GETREWARDSTAGEUSERCMD_PARAM_FIELD.index = 1
GETREWARDSTAGEUSERCMD_PARAM_FIELD.label = 1
GETREWARDSTAGEUSERCMD_PARAM_FIELD.has_default_value = true
GETREWARDSTAGEUSERCMD_PARAM_FIELD.default_value = 8
GETREWARDSTAGEUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
GETREWARDSTAGEUSERCMD_PARAM_FIELD.type = 14
GETREWARDSTAGEUSERCMD_PARAM_FIELD.cpp_type = 8
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.name = "stageid"
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.full_name = ".Cmd.GetRewardStageUserCmd.stageid"
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.number = 3
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.index = 2
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.label = 1
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.has_default_value = false
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.default_value = 0
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.type = 13
GETREWARDSTAGEUSERCMD_STAGEID_FIELD.cpp_type = 3
GETREWARDSTAGEUSERCMD_STARID_FIELD.name = "starid"
GETREWARDSTAGEUSERCMD_STARID_FIELD.full_name = ".Cmd.GetRewardStageUserCmd.starid"
GETREWARDSTAGEUSERCMD_STARID_FIELD.number = 4
GETREWARDSTAGEUSERCMD_STARID_FIELD.index = 3
GETREWARDSTAGEUSERCMD_STARID_FIELD.label = 1
GETREWARDSTAGEUSERCMD_STARID_FIELD.has_default_value = false
GETREWARDSTAGEUSERCMD_STARID_FIELD.default_value = 0
GETREWARDSTAGEUSERCMD_STARID_FIELD.type = 13
GETREWARDSTAGEUSERCMD_STARID_FIELD.cpp_type = 3
GETREWARDSTAGEUSERCMD.name = "GetRewardStageUserCmd"
GETREWARDSTAGEUSERCMD.full_name = ".Cmd.GetRewardStageUserCmd"
GETREWARDSTAGEUSERCMD.nested_types = {}
GETREWARDSTAGEUSERCMD.enum_types = {}
GETREWARDSTAGEUSERCMD.fields = {
  GETREWARDSTAGEUSERCMD_CMD_FIELD,
  GETREWARDSTAGEUSERCMD_PARAM_FIELD,
  GETREWARDSTAGEUSERCMD_STAGEID_FIELD,
  GETREWARDSTAGEUSERCMD_STARID_FIELD
}
GETREWARDSTAGEUSERCMD.is_extendable = false
GETREWARDSTAGEUSERCMD.extensions = {}
STAGESTEPSTARUSERCMD_CMD_FIELD.name = "cmd"
STAGESTEPSTARUSERCMD_CMD_FIELD.full_name = ".Cmd.StageStepStarUserCmd.cmd"
STAGESTEPSTARUSERCMD_CMD_FIELD.number = 1
STAGESTEPSTARUSERCMD_CMD_FIELD.index = 0
STAGESTEPSTARUSERCMD_CMD_FIELD.label = 1
STAGESTEPSTARUSERCMD_CMD_FIELD.has_default_value = true
STAGESTEPSTARUSERCMD_CMD_FIELD.default_value = 11
STAGESTEPSTARUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STAGESTEPSTARUSERCMD_CMD_FIELD.type = 14
STAGESTEPSTARUSERCMD_CMD_FIELD.cpp_type = 8
STAGESTEPSTARUSERCMD_PARAM_FIELD.name = "param"
STAGESTEPSTARUSERCMD_PARAM_FIELD.full_name = ".Cmd.StageStepStarUserCmd.param"
STAGESTEPSTARUSERCMD_PARAM_FIELD.number = 2
STAGESTEPSTARUSERCMD_PARAM_FIELD.index = 1
STAGESTEPSTARUSERCMD_PARAM_FIELD.label = 1
STAGESTEPSTARUSERCMD_PARAM_FIELD.has_default_value = true
STAGESTEPSTARUSERCMD_PARAM_FIELD.default_value = 9
STAGESTEPSTARUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
STAGESTEPSTARUSERCMD_PARAM_FIELD.type = 14
STAGESTEPSTARUSERCMD_PARAM_FIELD.cpp_type = 8
STAGESTEPSTARUSERCMD_STAGEID_FIELD.name = "stageid"
STAGESTEPSTARUSERCMD_STAGEID_FIELD.full_name = ".Cmd.StageStepStarUserCmd.stageid"
STAGESTEPSTARUSERCMD_STAGEID_FIELD.number = 3
STAGESTEPSTARUSERCMD_STAGEID_FIELD.index = 2
STAGESTEPSTARUSERCMD_STAGEID_FIELD.label = 1
STAGESTEPSTARUSERCMD_STAGEID_FIELD.has_default_value = false
STAGESTEPSTARUSERCMD_STAGEID_FIELD.default_value = 0
STAGESTEPSTARUSERCMD_STAGEID_FIELD.type = 13
STAGESTEPSTARUSERCMD_STAGEID_FIELD.cpp_type = 3
STAGESTEPSTARUSERCMD_STEPID_FIELD.name = "stepid"
STAGESTEPSTARUSERCMD_STEPID_FIELD.full_name = ".Cmd.StageStepStarUserCmd.stepid"
STAGESTEPSTARUSERCMD_STEPID_FIELD.number = 4
STAGESTEPSTARUSERCMD_STEPID_FIELD.index = 3
STAGESTEPSTARUSERCMD_STEPID_FIELD.label = 1
STAGESTEPSTARUSERCMD_STEPID_FIELD.has_default_value = false
STAGESTEPSTARUSERCMD_STEPID_FIELD.default_value = 0
STAGESTEPSTARUSERCMD_STEPID_FIELD.type = 13
STAGESTEPSTARUSERCMD_STEPID_FIELD.cpp_type = 3
STAGESTEPSTARUSERCMD_STAR_FIELD.name = "star"
STAGESTEPSTARUSERCMD_STAR_FIELD.full_name = ".Cmd.StageStepStarUserCmd.star"
STAGESTEPSTARUSERCMD_STAR_FIELD.number = 5
STAGESTEPSTARUSERCMD_STAR_FIELD.index = 4
STAGESTEPSTARUSERCMD_STAR_FIELD.label = 1
STAGESTEPSTARUSERCMD_STAR_FIELD.has_default_value = false
STAGESTEPSTARUSERCMD_STAR_FIELD.default_value = 0
STAGESTEPSTARUSERCMD_STAR_FIELD.type = 13
STAGESTEPSTARUSERCMD_STAR_FIELD.cpp_type = 3
STAGESTEPSTARUSERCMD_TYPE_FIELD.name = "type"
STAGESTEPSTARUSERCMD_TYPE_FIELD.full_name = ".Cmd.StageStepStarUserCmd.type"
STAGESTEPSTARUSERCMD_TYPE_FIELD.number = 6
STAGESTEPSTARUSERCMD_TYPE_FIELD.index = 5
STAGESTEPSTARUSERCMD_TYPE_FIELD.label = 1
STAGESTEPSTARUSERCMD_TYPE_FIELD.has_default_value = false
STAGESTEPSTARUSERCMD_TYPE_FIELD.default_value = 0
STAGESTEPSTARUSERCMD_TYPE_FIELD.type = 13
STAGESTEPSTARUSERCMD_TYPE_FIELD.cpp_type = 3
STAGESTEPSTARUSERCMD.name = "StageStepStarUserCmd"
STAGESTEPSTARUSERCMD.full_name = ".Cmd.StageStepStarUserCmd"
STAGESTEPSTARUSERCMD.nested_types = {}
STAGESTEPSTARUSERCMD.enum_types = {}
STAGESTEPSTARUSERCMD.fields = {
  STAGESTEPSTARUSERCMD_CMD_FIELD,
  STAGESTEPSTARUSERCMD_PARAM_FIELD,
  STAGESTEPSTARUSERCMD_STAGEID_FIELD,
  STAGESTEPSTARUSERCMD_STEPID_FIELD,
  STAGESTEPSTARUSERCMD_STAR_FIELD,
  STAGESTEPSTARUSERCMD_TYPE_FIELD
}
STAGESTEPSTARUSERCMD.is_extendable = false
STAGESTEPSTARUSERCMD.extensions = {}
MONSTERCOUNTUSERCMD_CMD_FIELD.name = "cmd"
MONSTERCOUNTUSERCMD_CMD_FIELD.full_name = ".Cmd.MonsterCountUserCmd.cmd"
MONSTERCOUNTUSERCMD_CMD_FIELD.number = 1
MONSTERCOUNTUSERCMD_CMD_FIELD.index = 0
MONSTERCOUNTUSERCMD_CMD_FIELD.label = 1
MONSTERCOUNTUSERCMD_CMD_FIELD.has_default_value = true
MONSTERCOUNTUSERCMD_CMD_FIELD.default_value = 11
MONSTERCOUNTUSERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MONSTERCOUNTUSERCMD_CMD_FIELD.type = 14
MONSTERCOUNTUSERCMD_CMD_FIELD.cpp_type = 8
MONSTERCOUNTUSERCMD_PARAM_FIELD.name = "param"
MONSTERCOUNTUSERCMD_PARAM_FIELD.full_name = ".Cmd.MonsterCountUserCmd.param"
MONSTERCOUNTUSERCMD_PARAM_FIELD.number = 2
MONSTERCOUNTUSERCMD_PARAM_FIELD.index = 1
MONSTERCOUNTUSERCMD_PARAM_FIELD.label = 1
MONSTERCOUNTUSERCMD_PARAM_FIELD.has_default_value = true
MONSTERCOUNTUSERCMD_PARAM_FIELD.default_value = 11
MONSTERCOUNTUSERCMD_PARAM_FIELD.enum_type = FUBENPARAM
MONSTERCOUNTUSERCMD_PARAM_FIELD.type = 14
MONSTERCOUNTUSERCMD_PARAM_FIELD.cpp_type = 8
MONSTERCOUNTUSERCMD_NUM_FIELD.name = "num"
MONSTERCOUNTUSERCMD_NUM_FIELD.full_name = ".Cmd.MonsterCountUserCmd.num"
MONSTERCOUNTUSERCMD_NUM_FIELD.number = 3
MONSTERCOUNTUSERCMD_NUM_FIELD.index = 2
MONSTERCOUNTUSERCMD_NUM_FIELD.label = 1
MONSTERCOUNTUSERCMD_NUM_FIELD.has_default_value = false
MONSTERCOUNTUSERCMD_NUM_FIELD.default_value = 0
MONSTERCOUNTUSERCMD_NUM_FIELD.type = 13
MONSTERCOUNTUSERCMD_NUM_FIELD.cpp_type = 3
MONSTERCOUNTUSERCMD.name = "MonsterCountUserCmd"
MONSTERCOUNTUSERCMD.full_name = ".Cmd.MonsterCountUserCmd"
MONSTERCOUNTUSERCMD.nested_types = {}
MONSTERCOUNTUSERCMD.enum_types = {}
MONSTERCOUNTUSERCMD.fields = {
  MONSTERCOUNTUSERCMD_CMD_FIELD,
  MONSTERCOUNTUSERCMD_PARAM_FIELD,
  MONSTERCOUNTUSERCMD_NUM_FIELD
}
MONSTERCOUNTUSERCMD.is_extendable = false
MONSTERCOUNTUSERCMD.extensions = {}
FUBENSTEPSYNCCMD_CMD_FIELD.name = "cmd"
FUBENSTEPSYNCCMD_CMD_FIELD.full_name = ".Cmd.FubenStepSyncCmd.cmd"
FUBENSTEPSYNCCMD_CMD_FIELD.number = 1
FUBENSTEPSYNCCMD_CMD_FIELD.index = 0
FUBENSTEPSYNCCMD_CMD_FIELD.label = 1
FUBENSTEPSYNCCMD_CMD_FIELD.has_default_value = true
FUBENSTEPSYNCCMD_CMD_FIELD.default_value = 11
FUBENSTEPSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FUBENSTEPSYNCCMD_CMD_FIELD.type = 14
FUBENSTEPSYNCCMD_CMD_FIELD.cpp_type = 8
FUBENSTEPSYNCCMD_PARAM_FIELD.name = "param"
FUBENSTEPSYNCCMD_PARAM_FIELD.full_name = ".Cmd.FubenStepSyncCmd.param"
FUBENSTEPSYNCCMD_PARAM_FIELD.number = 2
FUBENSTEPSYNCCMD_PARAM_FIELD.index = 1
FUBENSTEPSYNCCMD_PARAM_FIELD.label = 1
FUBENSTEPSYNCCMD_PARAM_FIELD.has_default_value = true
FUBENSTEPSYNCCMD_PARAM_FIELD.default_value = 12
FUBENSTEPSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
FUBENSTEPSYNCCMD_PARAM_FIELD.type = 14
FUBENSTEPSYNCCMD_PARAM_FIELD.cpp_type = 8
FUBENSTEPSYNCCMD_ID_FIELD.name = "id"
FUBENSTEPSYNCCMD_ID_FIELD.full_name = ".Cmd.FubenStepSyncCmd.id"
FUBENSTEPSYNCCMD_ID_FIELD.number = 3
FUBENSTEPSYNCCMD_ID_FIELD.index = 2
FUBENSTEPSYNCCMD_ID_FIELD.label = 1
FUBENSTEPSYNCCMD_ID_FIELD.has_default_value = false
FUBENSTEPSYNCCMD_ID_FIELD.default_value = 0
FUBENSTEPSYNCCMD_ID_FIELD.type = 13
FUBENSTEPSYNCCMD_ID_FIELD.cpp_type = 3
FUBENSTEPSYNCCMD_DEL_FIELD.name = "del"
FUBENSTEPSYNCCMD_DEL_FIELD.full_name = ".Cmd.FubenStepSyncCmd.del"
FUBENSTEPSYNCCMD_DEL_FIELD.number = 4
FUBENSTEPSYNCCMD_DEL_FIELD.index = 3
FUBENSTEPSYNCCMD_DEL_FIELD.label = 1
FUBENSTEPSYNCCMD_DEL_FIELD.has_default_value = false
FUBENSTEPSYNCCMD_DEL_FIELD.default_value = false
FUBENSTEPSYNCCMD_DEL_FIELD.type = 8
FUBENSTEPSYNCCMD_DEL_FIELD.cpp_type = 7
FUBENSTEPSYNCCMD_GROUPID_FIELD.name = "groupid"
FUBENSTEPSYNCCMD_GROUPID_FIELD.full_name = ".Cmd.FubenStepSyncCmd.groupid"
FUBENSTEPSYNCCMD_GROUPID_FIELD.number = 6
FUBENSTEPSYNCCMD_GROUPID_FIELD.index = 4
FUBENSTEPSYNCCMD_GROUPID_FIELD.label = 1
FUBENSTEPSYNCCMD_GROUPID_FIELD.has_default_value = false
FUBENSTEPSYNCCMD_GROUPID_FIELD.default_value = 0
FUBENSTEPSYNCCMD_GROUPID_FIELD.type = 13
FUBENSTEPSYNCCMD_GROUPID_FIELD.cpp_type = 3
FUBENSTEPSYNCCMD_CONFIG_FIELD.name = "config"
FUBENSTEPSYNCCMD_CONFIG_FIELD.full_name = ".Cmd.FubenStepSyncCmd.config"
FUBENSTEPSYNCCMD_CONFIG_FIELD.number = 5
FUBENSTEPSYNCCMD_CONFIG_FIELD.index = 5
FUBENSTEPSYNCCMD_CONFIG_FIELD.label = 1
FUBENSTEPSYNCCMD_CONFIG_FIELD.has_default_value = false
FUBENSTEPSYNCCMD_CONFIG_FIELD.default_value = nil
FUBENSTEPSYNCCMD_CONFIG_FIELD.message_type = RAIDPCONFIG
FUBENSTEPSYNCCMD_CONFIG_FIELD.type = 11
FUBENSTEPSYNCCMD_CONFIG_FIELD.cpp_type = 10
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.name = "uniqueid"
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.full_name = ".Cmd.FubenStepSyncCmd.uniqueid"
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.number = 7
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.index = 6
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.label = 1
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.has_default_value = false
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.default_value = 0
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.type = 13
FUBENSTEPSYNCCMD_UNIQUEID_FIELD.cpp_type = 3
FUBENSTEPSYNCCMD.name = "FubenStepSyncCmd"
FUBENSTEPSYNCCMD.full_name = ".Cmd.FubenStepSyncCmd"
FUBENSTEPSYNCCMD.nested_types = {}
FUBENSTEPSYNCCMD.enum_types = {}
FUBENSTEPSYNCCMD.fields = {
  FUBENSTEPSYNCCMD_CMD_FIELD,
  FUBENSTEPSYNCCMD_PARAM_FIELD,
  FUBENSTEPSYNCCMD_ID_FIELD,
  FUBENSTEPSYNCCMD_DEL_FIELD,
  FUBENSTEPSYNCCMD_GROUPID_FIELD,
  FUBENSTEPSYNCCMD_CONFIG_FIELD,
  FUBENSTEPSYNCCMD_UNIQUEID_FIELD
}
FUBENSTEPSYNCCMD.is_extendable = false
FUBENSTEPSYNCCMD.extensions = {}
FUBENPROGRESSSYNCCMD_CMD_FIELD.name = "cmd"
FUBENPROGRESSSYNCCMD_CMD_FIELD.full_name = ".Cmd.FuBenProgressSyncCmd.cmd"
FUBENPROGRESSSYNCCMD_CMD_FIELD.number = 1
FUBENPROGRESSSYNCCMD_CMD_FIELD.index = 0
FUBENPROGRESSSYNCCMD_CMD_FIELD.label = 1
FUBENPROGRESSSYNCCMD_CMD_FIELD.has_default_value = true
FUBENPROGRESSSYNCCMD_CMD_FIELD.default_value = 11
FUBENPROGRESSSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FUBENPROGRESSSYNCCMD_CMD_FIELD.type = 14
FUBENPROGRESSSYNCCMD_CMD_FIELD.cpp_type = 8
FUBENPROGRESSSYNCCMD_PARAM_FIELD.name = "param"
FUBENPROGRESSSYNCCMD_PARAM_FIELD.full_name = ".Cmd.FuBenProgressSyncCmd.param"
FUBENPROGRESSSYNCCMD_PARAM_FIELD.number = 2
FUBENPROGRESSSYNCCMD_PARAM_FIELD.index = 1
FUBENPROGRESSSYNCCMD_PARAM_FIELD.label = 1
FUBENPROGRESSSYNCCMD_PARAM_FIELD.has_default_value = true
FUBENPROGRESSSYNCCMD_PARAM_FIELD.default_value = 13
FUBENPROGRESSSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
FUBENPROGRESSSYNCCMD_PARAM_FIELD.type = 14
FUBENPROGRESSSYNCCMD_PARAM_FIELD.cpp_type = 8
FUBENPROGRESSSYNCCMD_ID_FIELD.name = "id"
FUBENPROGRESSSYNCCMD_ID_FIELD.full_name = ".Cmd.FuBenProgressSyncCmd.id"
FUBENPROGRESSSYNCCMD_ID_FIELD.number = 3
FUBENPROGRESSSYNCCMD_ID_FIELD.index = 2
FUBENPROGRESSSYNCCMD_ID_FIELD.label = 1
FUBENPROGRESSSYNCCMD_ID_FIELD.has_default_value = true
FUBENPROGRESSSYNCCMD_ID_FIELD.default_value = 0
FUBENPROGRESSSYNCCMD_ID_FIELD.type = 13
FUBENPROGRESSSYNCCMD_ID_FIELD.cpp_type = 3
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.name = "progress"
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.full_name = ".Cmd.FuBenProgressSyncCmd.progress"
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.number = 4
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.index = 3
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.label = 1
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.has_default_value = true
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.default_value = 0
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.type = 13
FUBENPROGRESSSYNCCMD_PROGRESS_FIELD.cpp_type = 3
FUBENPROGRESSSYNCCMD_STARID_FIELD.name = "starid"
FUBENPROGRESSSYNCCMD_STARID_FIELD.full_name = ".Cmd.FuBenProgressSyncCmd.starid"
FUBENPROGRESSSYNCCMD_STARID_FIELD.number = 5
FUBENPROGRESSSYNCCMD_STARID_FIELD.index = 4
FUBENPROGRESSSYNCCMD_STARID_FIELD.label = 1
FUBENPROGRESSSYNCCMD_STARID_FIELD.has_default_value = true
FUBENPROGRESSSYNCCMD_STARID_FIELD.default_value = 0
FUBENPROGRESSSYNCCMD_STARID_FIELD.type = 13
FUBENPROGRESSSYNCCMD_STARID_FIELD.cpp_type = 3
FUBENPROGRESSSYNCCMD.name = "FuBenProgressSyncCmd"
FUBENPROGRESSSYNCCMD.full_name = ".Cmd.FuBenProgressSyncCmd"
FUBENPROGRESSSYNCCMD.nested_types = {}
FUBENPROGRESSSYNCCMD.enum_types = {}
FUBENPROGRESSSYNCCMD.fields = {
  FUBENPROGRESSSYNCCMD_CMD_FIELD,
  FUBENPROGRESSSYNCCMD_PARAM_FIELD,
  FUBENPROGRESSSYNCCMD_ID_FIELD,
  FUBENPROGRESSSYNCCMD_PROGRESS_FIELD,
  FUBENPROGRESSSYNCCMD_STARID_FIELD
}
FUBENPROGRESSSYNCCMD.is_extendable = false
FUBENPROGRESSSYNCCMD.extensions = {}
FUBENCLEARINFOCMD_CMD_FIELD.name = "cmd"
FUBENCLEARINFOCMD_CMD_FIELD.full_name = ".Cmd.FuBenClearInfoCmd.cmd"
FUBENCLEARINFOCMD_CMD_FIELD.number = 1
FUBENCLEARINFOCMD_CMD_FIELD.index = 0
FUBENCLEARINFOCMD_CMD_FIELD.label = 1
FUBENCLEARINFOCMD_CMD_FIELD.has_default_value = true
FUBENCLEARINFOCMD_CMD_FIELD.default_value = 11
FUBENCLEARINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FUBENCLEARINFOCMD_CMD_FIELD.type = 14
FUBENCLEARINFOCMD_CMD_FIELD.cpp_type = 8
FUBENCLEARINFOCMD_PARAM_FIELD.name = "param"
FUBENCLEARINFOCMD_PARAM_FIELD.full_name = ".Cmd.FuBenClearInfoCmd.param"
FUBENCLEARINFOCMD_PARAM_FIELD.number = 2
FUBENCLEARINFOCMD_PARAM_FIELD.index = 1
FUBENCLEARINFOCMD_PARAM_FIELD.label = 1
FUBENCLEARINFOCMD_PARAM_FIELD.has_default_value = true
FUBENCLEARINFOCMD_PARAM_FIELD.default_value = 15
FUBENCLEARINFOCMD_PARAM_FIELD.enum_type = FUBENPARAM
FUBENCLEARINFOCMD_PARAM_FIELD.type = 14
FUBENCLEARINFOCMD_PARAM_FIELD.cpp_type = 8
FUBENCLEARINFOCMD.name = "FuBenClearInfoCmd"
FUBENCLEARINFOCMD.full_name = ".Cmd.FuBenClearInfoCmd"
FUBENCLEARINFOCMD.nested_types = {}
FUBENCLEARINFOCMD.enum_types = {}
FUBENCLEARINFOCMD.fields = {
  FUBENCLEARINFOCMD_CMD_FIELD,
  FUBENCLEARINFOCMD_PARAM_FIELD
}
FUBENCLEARINFOCMD.is_extendable = false
FUBENCLEARINFOCMD.extensions = {}
GUILDGATEDATA_GATENPCID_FIELD.name = "gatenpcid"
GUILDGATEDATA_GATENPCID_FIELD.full_name = ".Cmd.GuildGateData.gatenpcid"
GUILDGATEDATA_GATENPCID_FIELD.number = 1
GUILDGATEDATA_GATENPCID_FIELD.index = 0
GUILDGATEDATA_GATENPCID_FIELD.label = 2
GUILDGATEDATA_GATENPCID_FIELD.has_default_value = false
GUILDGATEDATA_GATENPCID_FIELD.default_value = 0
GUILDGATEDATA_GATENPCID_FIELD.type = 4
GUILDGATEDATA_GATENPCID_FIELD.cpp_type = 4
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.name = "killedbossnum"
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.full_name = ".Cmd.GuildGateData.killedbossnum"
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.number = 2
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.index = 1
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.label = 1
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.has_default_value = true
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.default_value = 0
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.type = 13
GUILDGATEDATA_KILLEDBOSSNUM_FIELD.cpp_type = 3
GUILDGATEDATA_GROUPINDEX_FIELD.name = "groupindex"
GUILDGATEDATA_GROUPINDEX_FIELD.full_name = ".Cmd.GuildGateData.groupindex"
GUILDGATEDATA_GROUPINDEX_FIELD.number = 3
GUILDGATEDATA_GROUPINDEX_FIELD.index = 2
GUILDGATEDATA_GROUPINDEX_FIELD.label = 1
GUILDGATEDATA_GROUPINDEX_FIELD.has_default_value = true
GUILDGATEDATA_GROUPINDEX_FIELD.default_value = 0
GUILDGATEDATA_GROUPINDEX_FIELD.type = 13
GUILDGATEDATA_GROUPINDEX_FIELD.cpp_type = 3
GUILDGATEDATA_CLOSETIME_FIELD.name = "closetime"
GUILDGATEDATA_CLOSETIME_FIELD.full_name = ".Cmd.GuildGateData.closetime"
GUILDGATEDATA_CLOSETIME_FIELD.number = 4
GUILDGATEDATA_CLOSETIME_FIELD.index = 3
GUILDGATEDATA_CLOSETIME_FIELD.label = 1
GUILDGATEDATA_CLOSETIME_FIELD.has_default_value = true
GUILDGATEDATA_CLOSETIME_FIELD.default_value = 0
GUILDGATEDATA_CLOSETIME_FIELD.type = 13
GUILDGATEDATA_CLOSETIME_FIELD.cpp_type = 3
GUILDGATEDATA_LEVEL_FIELD.name = "level"
GUILDGATEDATA_LEVEL_FIELD.full_name = ".Cmd.GuildGateData.level"
GUILDGATEDATA_LEVEL_FIELD.number = 5
GUILDGATEDATA_LEVEL_FIELD.index = 4
GUILDGATEDATA_LEVEL_FIELD.label = 1
GUILDGATEDATA_LEVEL_FIELD.has_default_value = true
GUILDGATEDATA_LEVEL_FIELD.default_value = 0
GUILDGATEDATA_LEVEL_FIELD.type = 13
GUILDGATEDATA_LEVEL_FIELD.cpp_type = 3
GUILDGATEDATA_ISSPECIAL_FIELD.name = "isspecial"
GUILDGATEDATA_ISSPECIAL_FIELD.full_name = ".Cmd.GuildGateData.isspecial"
GUILDGATEDATA_ISSPECIAL_FIELD.number = 6
GUILDGATEDATA_ISSPECIAL_FIELD.index = 5
GUILDGATEDATA_ISSPECIAL_FIELD.label = 1
GUILDGATEDATA_ISSPECIAL_FIELD.has_default_value = true
GUILDGATEDATA_ISSPECIAL_FIELD.default_value = false
GUILDGATEDATA_ISSPECIAL_FIELD.type = 8
GUILDGATEDATA_ISSPECIAL_FIELD.cpp_type = 7
GUILDGATEDATA_STATE_FIELD.name = "state"
GUILDGATEDATA_STATE_FIELD.full_name = ".Cmd.GuildGateData.state"
GUILDGATEDATA_STATE_FIELD.number = 7
GUILDGATEDATA_STATE_FIELD.index = 6
GUILDGATEDATA_STATE_FIELD.label = 1
GUILDGATEDATA_STATE_FIELD.has_default_value = true
GUILDGATEDATA_STATE_FIELD.default_value = 1
GUILDGATEDATA_STATE_FIELD.enum_type = EGUILDGATESTATE
GUILDGATEDATA_STATE_FIELD.type = 14
GUILDGATEDATA_STATE_FIELD.cpp_type = 8
GUILDGATEDATA.name = "GuildGateData"
GUILDGATEDATA.full_name = ".Cmd.GuildGateData"
GUILDGATEDATA.nested_types = {}
GUILDGATEDATA.enum_types = {}
GUILDGATEDATA.fields = {
  GUILDGATEDATA_GATENPCID_FIELD,
  GUILDGATEDATA_KILLEDBOSSNUM_FIELD,
  GUILDGATEDATA_GROUPINDEX_FIELD,
  GUILDGATEDATA_CLOSETIME_FIELD,
  GUILDGATEDATA_LEVEL_FIELD,
  GUILDGATEDATA_ISSPECIAL_FIELD,
  GUILDGATEDATA_STATE_FIELD
}
GUILDGATEDATA.is_extendable = false
GUILDGATEDATA.extensions = {}
USERGUILDRAIDFUBENCMD_CMD_FIELD.name = "cmd"
USERGUILDRAIDFUBENCMD_CMD_FIELD.full_name = ".Cmd.UserGuildRaidFubenCmd.cmd"
USERGUILDRAIDFUBENCMD_CMD_FIELD.number = 1
USERGUILDRAIDFUBENCMD_CMD_FIELD.index = 0
USERGUILDRAIDFUBENCMD_CMD_FIELD.label = 1
USERGUILDRAIDFUBENCMD_CMD_FIELD.has_default_value = true
USERGUILDRAIDFUBENCMD_CMD_FIELD.default_value = 11
USERGUILDRAIDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
USERGUILDRAIDFUBENCMD_CMD_FIELD.type = 14
USERGUILDRAIDFUBENCMD_CMD_FIELD.cpp_type = 8
USERGUILDRAIDFUBENCMD_PARAM_FIELD.name = "param"
USERGUILDRAIDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.UserGuildRaidFubenCmd.param"
USERGUILDRAIDFUBENCMD_PARAM_FIELD.number = 2
USERGUILDRAIDFUBENCMD_PARAM_FIELD.index = 1
USERGUILDRAIDFUBENCMD_PARAM_FIELD.label = 1
USERGUILDRAIDFUBENCMD_PARAM_FIELD.has_default_value = true
USERGUILDRAIDFUBENCMD_PARAM_FIELD.default_value = 16
USERGUILDRAIDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
USERGUILDRAIDFUBENCMD_PARAM_FIELD.type = 14
USERGUILDRAIDFUBENCMD_PARAM_FIELD.cpp_type = 8
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.name = "gatedata"
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.full_name = ".Cmd.UserGuildRaidFubenCmd.gatedata"
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.number = 3
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.index = 2
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.label = 3
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.has_default_value = false
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.default_value = {}
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.message_type = GUILDGATEDATA
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.type = 11
USERGUILDRAIDFUBENCMD_GATEDATA_FIELD.cpp_type = 10
USERGUILDRAIDFUBENCMD.name = "UserGuildRaidFubenCmd"
USERGUILDRAIDFUBENCMD.full_name = ".Cmd.UserGuildRaidFubenCmd"
USERGUILDRAIDFUBENCMD.nested_types = {}
USERGUILDRAIDFUBENCMD.enum_types = {}
USERGUILDRAIDFUBENCMD.fields = {
  USERGUILDRAIDFUBENCMD_CMD_FIELD,
  USERGUILDRAIDFUBENCMD_PARAM_FIELD,
  USERGUILDRAIDFUBENCMD_GATEDATA_FIELD
}
USERGUILDRAIDFUBENCMD.is_extendable = false
USERGUILDRAIDFUBENCMD.extensions = {}
GUILDGATEOPTCMD_CMD_FIELD.name = "cmd"
GUILDGATEOPTCMD_CMD_FIELD.full_name = ".Cmd.GuildGateOptCmd.cmd"
GUILDGATEOPTCMD_CMD_FIELD.number = 1
GUILDGATEOPTCMD_CMD_FIELD.index = 0
GUILDGATEOPTCMD_CMD_FIELD.label = 1
GUILDGATEOPTCMD_CMD_FIELD.has_default_value = true
GUILDGATEOPTCMD_CMD_FIELD.default_value = 11
GUILDGATEOPTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDGATEOPTCMD_CMD_FIELD.type = 14
GUILDGATEOPTCMD_CMD_FIELD.cpp_type = 8
GUILDGATEOPTCMD_PARAM_FIELD.name = "param"
GUILDGATEOPTCMD_PARAM_FIELD.full_name = ".Cmd.GuildGateOptCmd.param"
GUILDGATEOPTCMD_PARAM_FIELD.number = 2
GUILDGATEOPTCMD_PARAM_FIELD.index = 1
GUILDGATEOPTCMD_PARAM_FIELD.label = 1
GUILDGATEOPTCMD_PARAM_FIELD.has_default_value = true
GUILDGATEOPTCMD_PARAM_FIELD.default_value = 17
GUILDGATEOPTCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDGATEOPTCMD_PARAM_FIELD.type = 14
GUILDGATEOPTCMD_PARAM_FIELD.cpp_type = 8
GUILDGATEOPTCMD_GATENPCID_FIELD.name = "gatenpcid"
GUILDGATEOPTCMD_GATENPCID_FIELD.full_name = ".Cmd.GuildGateOptCmd.gatenpcid"
GUILDGATEOPTCMD_GATENPCID_FIELD.number = 3
GUILDGATEOPTCMD_GATENPCID_FIELD.index = 2
GUILDGATEOPTCMD_GATENPCID_FIELD.label = 1
GUILDGATEOPTCMD_GATENPCID_FIELD.has_default_value = false
GUILDGATEOPTCMD_GATENPCID_FIELD.default_value = 0
GUILDGATEOPTCMD_GATENPCID_FIELD.type = 4
GUILDGATEOPTCMD_GATENPCID_FIELD.cpp_type = 4
GUILDGATEOPTCMD_OPT_FIELD.name = "opt"
GUILDGATEOPTCMD_OPT_FIELD.full_name = ".Cmd.GuildGateOptCmd.opt"
GUILDGATEOPTCMD_OPT_FIELD.number = 4
GUILDGATEOPTCMD_OPT_FIELD.index = 3
GUILDGATEOPTCMD_OPT_FIELD.label = 1
GUILDGATEOPTCMD_OPT_FIELD.has_default_value = false
GUILDGATEOPTCMD_OPT_FIELD.default_value = nil
GUILDGATEOPTCMD_OPT_FIELD.enum_type = EGUILDGATEOPT
GUILDGATEOPTCMD_OPT_FIELD.type = 14
GUILDGATEOPTCMD_OPT_FIELD.cpp_type = 8
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.name = "uplocklevel"
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.full_name = ".Cmd.GuildGateOptCmd.uplocklevel"
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.number = 5
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.index = 4
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.label = 1
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.has_default_value = true
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.default_value = 0
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.type = 13
GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD.cpp_type = 3
GUILDGATEOPTCMD.name = "GuildGateOptCmd"
GUILDGATEOPTCMD.full_name = ".Cmd.GuildGateOptCmd"
GUILDGATEOPTCMD.nested_types = {}
GUILDGATEOPTCMD.enum_types = {}
GUILDGATEOPTCMD.fields = {
  GUILDGATEOPTCMD_CMD_FIELD,
  GUILDGATEOPTCMD_PARAM_FIELD,
  GUILDGATEOPTCMD_GATENPCID_FIELD,
  GUILDGATEOPTCMD_OPT_FIELD,
  GUILDGATEOPTCMD_UPLOCKLEVEL_FIELD
}
GUILDGATEOPTCMD.is_extendable = false
GUILDGATEOPTCMD.extensions = {}
GVGPOINTINFO_POINTID_FIELD.name = "pointid"
GVGPOINTINFO_POINTID_FIELD.full_name = ".Cmd.GvgPointInfo.pointid"
GVGPOINTINFO_POINTID_FIELD.number = 1
GVGPOINTINFO_POINTID_FIELD.index = 0
GVGPOINTINFO_POINTID_FIELD.label = 1
GVGPOINTINFO_POINTID_FIELD.has_default_value = false
GVGPOINTINFO_POINTID_FIELD.default_value = 0
GVGPOINTINFO_POINTID_FIELD.type = 13
GVGPOINTINFO_POINTID_FIELD.cpp_type = 3
GVGPOINTINFO_STATE_FIELD.name = "state"
GVGPOINTINFO_STATE_FIELD.full_name = ".Cmd.GvgPointInfo.state"
GVGPOINTINFO_STATE_FIELD.number = 2
GVGPOINTINFO_STATE_FIELD.index = 1
GVGPOINTINFO_STATE_FIELD.label = 1
GVGPOINTINFO_STATE_FIELD.has_default_value = false
GVGPOINTINFO_STATE_FIELD.default_value = nil
GVGPOINTINFO_STATE_FIELD.enum_type = EGVGPOINTSTATE
GVGPOINTINFO_STATE_FIELD.type = 14
GVGPOINTINFO_STATE_FIELD.cpp_type = 8
GVGPOINTINFO_GUILDID_FIELD.name = "guildid"
GVGPOINTINFO_GUILDID_FIELD.full_name = ".Cmd.GvgPointInfo.guildid"
GVGPOINTINFO_GUILDID_FIELD.number = 3
GVGPOINTINFO_GUILDID_FIELD.index = 2
GVGPOINTINFO_GUILDID_FIELD.label = 1
GVGPOINTINFO_GUILDID_FIELD.has_default_value = false
GVGPOINTINFO_GUILDID_FIELD.default_value = 0
GVGPOINTINFO_GUILDID_FIELD.type = 4
GVGPOINTINFO_GUILDID_FIELD.cpp_type = 4
GVGPOINTINFO_PER_FIELD.name = "per"
GVGPOINTINFO_PER_FIELD.full_name = ".Cmd.GvgPointInfo.per"
GVGPOINTINFO_PER_FIELD.number = 4
GVGPOINTINFO_PER_FIELD.index = 3
GVGPOINTINFO_PER_FIELD.label = 1
GVGPOINTINFO_PER_FIELD.has_default_value = false
GVGPOINTINFO_PER_FIELD.default_value = 0
GVGPOINTINFO_PER_FIELD.type = 13
GVGPOINTINFO_PER_FIELD.cpp_type = 3
GVGPOINTINFO_GUILDNAME_FIELD.name = "guildname"
GVGPOINTINFO_GUILDNAME_FIELD.full_name = ".Cmd.GvgPointInfo.guildname"
GVGPOINTINFO_GUILDNAME_FIELD.number = 7
GVGPOINTINFO_GUILDNAME_FIELD.index = 4
GVGPOINTINFO_GUILDNAME_FIELD.label = 1
GVGPOINTINFO_GUILDNAME_FIELD.has_default_value = false
GVGPOINTINFO_GUILDNAME_FIELD.default_value = ""
GVGPOINTINFO_GUILDNAME_FIELD.type = 9
GVGPOINTINFO_GUILDNAME_FIELD.cpp_type = 9
GVGPOINTINFO_GUILDPORTRAIT_FIELD.name = "guildportrait"
GVGPOINTINFO_GUILDPORTRAIT_FIELD.full_name = ".Cmd.GvgPointInfo.guildportrait"
GVGPOINTINFO_GUILDPORTRAIT_FIELD.number = 8
GVGPOINTINFO_GUILDPORTRAIT_FIELD.index = 5
GVGPOINTINFO_GUILDPORTRAIT_FIELD.label = 1
GVGPOINTINFO_GUILDPORTRAIT_FIELD.has_default_value = false
GVGPOINTINFO_GUILDPORTRAIT_FIELD.default_value = ""
GVGPOINTINFO_GUILDPORTRAIT_FIELD.type = 9
GVGPOINTINFO_GUILDPORTRAIT_FIELD.cpp_type = 9
GVGPOINTINFO_SCORE_FIELD.name = "score"
GVGPOINTINFO_SCORE_FIELD.full_name = ".Cmd.GvgPointInfo.score"
GVGPOINTINFO_SCORE_FIELD.number = 9
GVGPOINTINFO_SCORE_FIELD.index = 6
GVGPOINTINFO_SCORE_FIELD.label = 1
GVGPOINTINFO_SCORE_FIELD.has_default_value = false
GVGPOINTINFO_SCORE_FIELD.default_value = false
GVGPOINTINFO_SCORE_FIELD.type = 8
GVGPOINTINFO_SCORE_FIELD.cpp_type = 7
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.name = "occupied_guilds"
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.full_name = ".Cmd.GvgPointInfo.occupied_guilds"
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.number = 5
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.index = 7
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.label = 3
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.has_default_value = false
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.default_value = {}
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.type = 4
GVGPOINTINFO_OCCUPIED_GUILDS_FIELD.cpp_type = 4
GVGPOINTINFO.name = "GvgPointInfo"
GVGPOINTINFO.full_name = ".Cmd.GvgPointInfo"
GVGPOINTINFO.nested_types = {}
GVGPOINTINFO.enum_types = {}
GVGPOINTINFO.fields = {
  GVGPOINTINFO_POINTID_FIELD,
  GVGPOINTINFO_STATE_FIELD,
  GVGPOINTINFO_GUILDID_FIELD,
  GVGPOINTINFO_PER_FIELD,
  GVGPOINTINFO_GUILDNAME_FIELD,
  GVGPOINTINFO_GUILDPORTRAIT_FIELD,
  GVGPOINTINFO_SCORE_FIELD,
  GVGPOINTINFO_OCCUPIED_GUILDS_FIELD
}
GVGPOINTINFO.is_extendable = false
GVGPOINTINFO.extensions = {}
GUILDFIREINFOFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIREINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.cmd"
GUILDFIREINFOFUBENCMD_CMD_FIELD.number = 1
GUILDFIREINFOFUBENCMD_CMD_FIELD.index = 0
GUILDFIREINFOFUBENCMD_CMD_FIELD.label = 1
GUILDFIREINFOFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIREINFOFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIREINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIREINFOFUBENCMD_CMD_FIELD.type = 14
GUILDFIREINFOFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIREINFOFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIREINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.param"
GUILDFIREINFOFUBENCMD_PARAM_FIELD.number = 2
GUILDFIREINFOFUBENCMD_PARAM_FIELD.index = 1
GUILDFIREINFOFUBENCMD_PARAM_FIELD.label = 1
GUILDFIREINFOFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIREINFOFUBENCMD_PARAM_FIELD.default_value = 18
GUILDFIREINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIREINFOFUBENCMD_PARAM_FIELD.type = 14
GUILDFIREINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.name = "raidstate"
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.raidstate"
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.number = 3
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.index = 2
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.label = 1
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.default_value = nil
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.enum_type = EGVGRAIDSTATE
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.type = 14
GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD.cpp_type = 8
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.name = "def_guildid"
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.def_guildid"
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.number = 4
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.index = 3
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.label = 1
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.type = 4
GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD.cpp_type = 4
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.name = "endfire_time"
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.endfire_time"
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.number = 5
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.index = 4
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.label = 1
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.type = 13
GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.name = "metal_hpper"
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.metal_hpper"
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.number = 6
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.index = 5
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.label = 1
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.type = 13
GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.name = "calm_time"
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.calm_time"
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.number = 7
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.index = 6
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.label = 1
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.type = 13
GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.name = "def_guildname"
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.def_guildname"
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.number = 8
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.index = 7
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.label = 1
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.default_value = ""
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.type = 9
GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD.cpp_type = 9
GUILDFIREINFOFUBENCMD_POINTS_FIELD.name = "points"
GUILDFIREINFOFUBENCMD_POINTS_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.points"
GUILDFIREINFOFUBENCMD_POINTS_FIELD.number = 13
GUILDFIREINFOFUBENCMD_POINTS_FIELD.index = 8
GUILDFIREINFOFUBENCMD_POINTS_FIELD.label = 3
GUILDFIREINFOFUBENCMD_POINTS_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_POINTS_FIELD.default_value = {}
GUILDFIREINFOFUBENCMD_POINTS_FIELD.message_type = GVGPOINTINFO
GUILDFIREINFOFUBENCMD_POINTS_FIELD.type = 11
GUILDFIREINFOFUBENCMD_POINTS_FIELD.cpp_type = 10
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.name = "my_smallmetal_cnt"
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.my_smallmetal_cnt"
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.number = 14
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.index = 9
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.label = 1
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.type = 13
GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.name = "perfect_time"
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.perfect_time"
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.number = 15
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.index = 10
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.label = 1
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.default_value = nil
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.message_type = ProtoCommon_pb.GVGPERFECTTIMEINFO
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.type = 11
GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD.cpp_type = 10
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.name = "metal_god"
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.metal_god"
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.number = 16
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.index = 11
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.label = 1
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.default_value = false
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.type = 8
GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD.cpp_type = 7
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.name = "perfect"
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.perfect"
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.number = 17
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.index = 12
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.label = 1
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.default_value = false
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.type = 8
GUILDFIREINFOFUBENCMD_PERFECT_FIELD.cpp_type = 7
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.name = "roadblock"
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.roadblock"
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.number = 18
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.index = 13
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.label = 1
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.type = 13
GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.name = "gvg_group"
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.gvg_group"
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.number = 19
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.index = 14
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.label = 1
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.type = 13
GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.name = "mvp_hp_per"
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.mvp_hp_per"
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.number = 20
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.index = 15
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.label = 1
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.default_value = 0
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.type = 13
GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD.cpp_type = 3
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.name = "mvp_state"
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.full_name = ".Cmd.GuildFireInfoFubenCmd.mvp_state"
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.number = 21
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.index = 16
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.label = 1
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.has_default_value = false
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.default_value = nil
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.enum_type = GUILDCMD_PB_EMVPSTATE
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.type = 14
GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD.cpp_type = 8
GUILDFIREINFOFUBENCMD.name = "GuildFireInfoFubenCmd"
GUILDFIREINFOFUBENCMD.full_name = ".Cmd.GuildFireInfoFubenCmd"
GUILDFIREINFOFUBENCMD.nested_types = {}
GUILDFIREINFOFUBENCMD.enum_types = {}
GUILDFIREINFOFUBENCMD.fields = {
  GUILDFIREINFOFUBENCMD_CMD_FIELD,
  GUILDFIREINFOFUBENCMD_PARAM_FIELD,
  GUILDFIREINFOFUBENCMD_RAIDSTATE_FIELD,
  GUILDFIREINFOFUBENCMD_DEF_GUILDID_FIELD,
  GUILDFIREINFOFUBENCMD_ENDFIRE_TIME_FIELD,
  GUILDFIREINFOFUBENCMD_METAL_HPPER_FIELD,
  GUILDFIREINFOFUBENCMD_CALM_TIME_FIELD,
  GUILDFIREINFOFUBENCMD_DEF_GUILDNAME_FIELD,
  GUILDFIREINFOFUBENCMD_POINTS_FIELD,
  GUILDFIREINFOFUBENCMD_MY_SMALLMETAL_CNT_FIELD,
  GUILDFIREINFOFUBENCMD_PERFECT_TIME_FIELD,
  GUILDFIREINFOFUBENCMD_METAL_GOD_FIELD,
  GUILDFIREINFOFUBENCMD_PERFECT_FIELD,
  GUILDFIREINFOFUBENCMD_ROADBLOCK_FIELD,
  GUILDFIREINFOFUBENCMD_GVG_GROUP_FIELD,
  GUILDFIREINFOFUBENCMD_MVP_HP_PER_FIELD,
  GUILDFIREINFOFUBENCMD_MVP_STATE_FIELD
}
GUILDFIREINFOFUBENCMD.is_extendable = false
GUILDFIREINFOFUBENCMD.extensions = {}
GUILDFIRESTOPFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIRESTOPFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireStopFubenCmd.cmd"
GUILDFIRESTOPFUBENCMD_CMD_FIELD.number = 1
GUILDFIRESTOPFUBENCMD_CMD_FIELD.index = 0
GUILDFIRESTOPFUBENCMD_CMD_FIELD.label = 1
GUILDFIRESTOPFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIRESTOPFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIRESTOPFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIRESTOPFUBENCMD_CMD_FIELD.type = 14
GUILDFIRESTOPFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireStopFubenCmd.param"
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.number = 2
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.index = 1
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.label = 1
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.default_value = 19
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.type = 14
GUILDFIRESTOPFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.name = "result"
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.full_name = ".Cmd.GuildFireStopFubenCmd.result"
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.number = 3
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.index = 2
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.label = 2
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.has_default_value = false
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.default_value = nil
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.enum_type = EGUILDFIRERESULT
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.type = 14
GUILDFIRESTOPFUBENCMD_RESULT_FIELD.cpp_type = 8
GUILDFIRESTOPFUBENCMD.name = "GuildFireStopFubenCmd"
GUILDFIRESTOPFUBENCMD.full_name = ".Cmd.GuildFireStopFubenCmd"
GUILDFIRESTOPFUBENCMD.nested_types = {}
GUILDFIRESTOPFUBENCMD.enum_types = {}
GUILDFIRESTOPFUBENCMD.fields = {
  GUILDFIRESTOPFUBENCMD_CMD_FIELD,
  GUILDFIRESTOPFUBENCMD_PARAM_FIELD,
  GUILDFIRESTOPFUBENCMD_RESULT_FIELD
}
GUILDFIRESTOPFUBENCMD.is_extendable = false
GUILDFIRESTOPFUBENCMD.extensions = {}
GUILDFIREDANGERFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIREDANGERFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireDangerFubenCmd.cmd"
GUILDFIREDANGERFUBENCMD_CMD_FIELD.number = 1
GUILDFIREDANGERFUBENCMD_CMD_FIELD.index = 0
GUILDFIREDANGERFUBENCMD_CMD_FIELD.label = 1
GUILDFIREDANGERFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIREDANGERFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIREDANGERFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIREDANGERFUBENCMD_CMD_FIELD.type = 14
GUILDFIREDANGERFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireDangerFubenCmd.param"
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.number = 2
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.index = 1
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.label = 1
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.default_value = 20
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.type = 14
GUILDFIREDANGERFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.name = "danger"
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.full_name = ".Cmd.GuildFireDangerFubenCmd.danger"
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.number = 3
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.index = 2
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.label = 1
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.has_default_value = true
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.default_value = false
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.type = 8
GUILDFIREDANGERFUBENCMD_DANGER_FIELD.cpp_type = 7
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.name = "danger_time"
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.full_name = ".Cmd.GuildFireDangerFubenCmd.danger_time"
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.number = 4
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.index = 3
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.label = 1
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.has_default_value = true
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.default_value = 0
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.type = 13
GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD.cpp_type = 3
GUILDFIREDANGERFUBENCMD.name = "GuildFireDangerFubenCmd"
GUILDFIREDANGERFUBENCMD.full_name = ".Cmd.GuildFireDangerFubenCmd"
GUILDFIREDANGERFUBENCMD.nested_types = {}
GUILDFIREDANGERFUBENCMD.enum_types = {}
GUILDFIREDANGERFUBENCMD.fields = {
  GUILDFIREDANGERFUBENCMD_CMD_FIELD,
  GUILDFIREDANGERFUBENCMD_PARAM_FIELD,
  GUILDFIREDANGERFUBENCMD_DANGER_FIELD,
  GUILDFIREDANGERFUBENCMD_DANGER_TIME_FIELD
}
GUILDFIREDANGERFUBENCMD.is_extendable = false
GUILDFIREDANGERFUBENCMD.extensions = {}
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireMetalHpFubenCmd.cmd"
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.number = 1
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.index = 0
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.label = 1
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.type = 14
GUILDFIREMETALHPFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireMetalHpFubenCmd.param"
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.number = 2
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.index = 1
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.label = 1
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.default_value = 21
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.type = 14
GUILDFIREMETALHPFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.name = "hpper"
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.full_name = ".Cmd.GuildFireMetalHpFubenCmd.hpper"
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.number = 3
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.index = 2
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.label = 1
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.has_default_value = true
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.default_value = 0
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.type = 13
GUILDFIREMETALHPFUBENCMD_HPPER_FIELD.cpp_type = 3
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.name = "god"
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.full_name = ".Cmd.GuildFireMetalHpFubenCmd.god"
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.number = 4
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.index = 3
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.label = 1
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.has_default_value = false
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.default_value = false
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.type = 8
GUILDFIREMETALHPFUBENCMD_GOD_FIELD.cpp_type = 7
GUILDFIREMETALHPFUBENCMD.name = "GuildFireMetalHpFubenCmd"
GUILDFIREMETALHPFUBENCMD.full_name = ".Cmd.GuildFireMetalHpFubenCmd"
GUILDFIREMETALHPFUBENCMD.nested_types = {}
GUILDFIREMETALHPFUBENCMD.enum_types = {}
GUILDFIREMETALHPFUBENCMD.fields = {
  GUILDFIREMETALHPFUBENCMD_CMD_FIELD,
  GUILDFIREMETALHPFUBENCMD_PARAM_FIELD,
  GUILDFIREMETALHPFUBENCMD_HPPER_FIELD,
  GUILDFIREMETALHPFUBENCMD_GOD_FIELD
}
GUILDFIREMETALHPFUBENCMD.is_extendable = false
GUILDFIREMETALHPFUBENCMD.extensions = {}
GUILDFIRECALMFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIRECALMFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireCalmFubenCmd.cmd"
GUILDFIRECALMFUBENCMD_CMD_FIELD.number = 1
GUILDFIRECALMFUBENCMD_CMD_FIELD.index = 0
GUILDFIRECALMFUBENCMD_CMD_FIELD.label = 1
GUILDFIRECALMFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIRECALMFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIRECALMFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIRECALMFUBENCMD_CMD_FIELD.type = 14
GUILDFIRECALMFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIRECALMFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIRECALMFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireCalmFubenCmd.param"
GUILDFIRECALMFUBENCMD_PARAM_FIELD.number = 2
GUILDFIRECALMFUBENCMD_PARAM_FIELD.index = 1
GUILDFIRECALMFUBENCMD_PARAM_FIELD.label = 1
GUILDFIRECALMFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIRECALMFUBENCMD_PARAM_FIELD.default_value = 22
GUILDFIRECALMFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIRECALMFUBENCMD_PARAM_FIELD.type = 14
GUILDFIRECALMFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIRECALMFUBENCMD_CALM_FIELD.name = "calm"
GUILDFIRECALMFUBENCMD_CALM_FIELD.full_name = ".Cmd.GuildFireCalmFubenCmd.calm"
GUILDFIRECALMFUBENCMD_CALM_FIELD.number = 3
GUILDFIRECALMFUBENCMD_CALM_FIELD.index = 2
GUILDFIRECALMFUBENCMD_CALM_FIELD.label = 1
GUILDFIRECALMFUBENCMD_CALM_FIELD.has_default_value = true
GUILDFIRECALMFUBENCMD_CALM_FIELD.default_value = false
GUILDFIRECALMFUBENCMD_CALM_FIELD.type = 8
GUILDFIRECALMFUBENCMD_CALM_FIELD.cpp_type = 7
GUILDFIRECALMFUBENCMD.name = "GuildFireCalmFubenCmd"
GUILDFIRECALMFUBENCMD.full_name = ".Cmd.GuildFireCalmFubenCmd"
GUILDFIRECALMFUBENCMD.nested_types = {}
GUILDFIRECALMFUBENCMD.enum_types = {}
GUILDFIRECALMFUBENCMD.fields = {
  GUILDFIRECALMFUBENCMD_CMD_FIELD,
  GUILDFIRECALMFUBENCMD_PARAM_FIELD,
  GUILDFIRECALMFUBENCMD_CALM_FIELD
}
GUILDFIRECALMFUBENCMD.is_extendable = false
GUILDFIRECALMFUBENCMD.extensions = {}
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireNewDefFubenCmd.cmd"
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.number = 1
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.index = 0
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.label = 1
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.type = 14
GUILDFIRENEWDEFFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireNewDefFubenCmd.param"
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.number = 2
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.index = 1
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.label = 1
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.default_value = 23
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.type = 14
GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.name = "guildid"
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.full_name = ".Cmd.GuildFireNewDefFubenCmd.guildid"
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.number = 3
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.index = 2
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.label = 1
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.has_default_value = true
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.default_value = 0
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.type = 4
GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD.cpp_type = 4
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.name = "guildname"
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.full_name = ".Cmd.GuildFireNewDefFubenCmd.guildname"
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.number = 4
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.index = 3
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.label = 1
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.has_default_value = false
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.default_value = ""
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.type = 9
GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD.cpp_type = 9
GUILDFIRENEWDEFFUBENCMD.name = "GuildFireNewDefFubenCmd"
GUILDFIRENEWDEFFUBENCMD.full_name = ".Cmd.GuildFireNewDefFubenCmd"
GUILDFIRENEWDEFFUBENCMD.nested_types = {}
GUILDFIRENEWDEFFUBENCMD.enum_types = {}
GUILDFIRENEWDEFFUBENCMD.fields = {
  GUILDFIRENEWDEFFUBENCMD_CMD_FIELD,
  GUILDFIRENEWDEFFUBENCMD_PARAM_FIELD,
  GUILDFIRENEWDEFFUBENCMD_GUILDID_FIELD,
  GUILDFIRENEWDEFFUBENCMD_GUILDNAME_FIELD
}
GUILDFIRENEWDEFFUBENCMD.is_extendable = false
GUILDFIRENEWDEFFUBENCMD.extensions = {}
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireRestartFubenCmd.cmd"
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.number = 1
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.index = 0
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.label = 1
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.type = 14
GUILDFIRERESTARTFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireRestartFubenCmd.param"
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.number = 2
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.index = 1
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.label = 1
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.default_value = 24
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.type = 14
GUILDFIRERESTARTFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIRERESTARTFUBENCMD.name = "GuildFireRestartFubenCmd"
GUILDFIRERESTARTFUBENCMD.full_name = ".Cmd.GuildFireRestartFubenCmd"
GUILDFIRERESTARTFUBENCMD.nested_types = {}
GUILDFIRERESTARTFUBENCMD.enum_types = {}
GUILDFIRERESTARTFUBENCMD.fields = {
  GUILDFIRERESTARTFUBENCMD_CMD_FIELD,
  GUILDFIRERESTARTFUBENCMD_PARAM_FIELD
}
GUILDFIRERESTARTFUBENCMD.is_extendable = false
GUILDFIRERESTARTFUBENCMD.extensions = {}
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.name = "cmd"
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.cmd"
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.number = 1
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.index = 0
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.label = 1
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.has_default_value = true
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.default_value = 11
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.type = 14
GUILDFIRESTATUSFUBENCMD_CMD_FIELD.cpp_type = 8
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.name = "param"
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.param"
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.number = 2
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.index = 1
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.label = 1
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.has_default_value = true
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.default_value = 25
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.type = 14
GUILDFIRESTATUSFUBENCMD_PARAM_FIELD.cpp_type = 8
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.name = "open"
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.open"
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.number = 3
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.index = 2
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.label = 1
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.has_default_value = true
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.default_value = false
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.type = 8
GUILDFIRESTATUSFUBENCMD_OPEN_FIELD.cpp_type = 7
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.name = "starttime"
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.starttime"
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.number = 4
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.index = 3
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.label = 1
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.has_default_value = true
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.default_value = 0
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.type = 13
GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD.cpp_type = 3
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.name = "cityid"
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.cityid"
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.number = 5
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.index = 4
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.label = 2
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.has_default_value = false
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.default_value = 0
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.type = 13
GUILDFIRESTATUSFUBENCMD_CITYID_FIELD.cpp_type = 3
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.name = "cityopen"
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.full_name = ".Cmd.GuildFireStatusFubenCmd.cityopen"
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.number = 6
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.index = 5
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.label = 1
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.has_default_value = true
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.default_value = false
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.type = 8
GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD.cpp_type = 7
GUILDFIRESTATUSFUBENCMD.name = "GuildFireStatusFubenCmd"
GUILDFIRESTATUSFUBENCMD.full_name = ".Cmd.GuildFireStatusFubenCmd"
GUILDFIRESTATUSFUBENCMD.nested_types = {}
GUILDFIRESTATUSFUBENCMD.enum_types = {}
GUILDFIRESTATUSFUBENCMD.fields = {
  GUILDFIRESTATUSFUBENCMD_CMD_FIELD,
  GUILDFIRESTATUSFUBENCMD_PARAM_FIELD,
  GUILDFIRESTATUSFUBENCMD_OPEN_FIELD,
  GUILDFIRESTATUSFUBENCMD_STARTTIME_FIELD,
  GUILDFIRESTATUSFUBENCMD_CITYID_FIELD,
  GUILDFIRESTATUSFUBENCMD_CITYOPEN_FIELD
}
GUILDFIRESTATUSFUBENCMD.is_extendable = false
GUILDFIRESTATUSFUBENCMD.extensions = {}
GVGDATA_TYPE_FIELD.name = "type"
GVGDATA_TYPE_FIELD.full_name = ".Cmd.GvgData.type"
GVGDATA_TYPE_FIELD.number = 1
GVGDATA_TYPE_FIELD.index = 0
GVGDATA_TYPE_FIELD.label = 1
GVGDATA_TYPE_FIELD.has_default_value = true
GVGDATA_TYPE_FIELD.default_value = 0
GVGDATA_TYPE_FIELD.enum_type = EGVGDATATYPE
GVGDATA_TYPE_FIELD.type = 14
GVGDATA_TYPE_FIELD.cpp_type = 8
GVGDATA_VALUE_FIELD.name = "value"
GVGDATA_VALUE_FIELD.full_name = ".Cmd.GvgData.value"
GVGDATA_VALUE_FIELD.number = 2
GVGDATA_VALUE_FIELD.index = 1
GVGDATA_VALUE_FIELD.label = 1
GVGDATA_VALUE_FIELD.has_default_value = true
GVGDATA_VALUE_FIELD.default_value = 0
GVGDATA_VALUE_FIELD.type = 13
GVGDATA_VALUE_FIELD.cpp_type = 3
GVGDATA.name = "GvgData"
GVGDATA.full_name = ".Cmd.GvgData"
GVGDATA.nested_types = {}
GVGDATA.enum_types = {}
GVGDATA.fields = {
  GVGDATA_TYPE_FIELD,
  GVGDATA_VALUE_FIELD
}
GVGDATA.is_extendable = false
GVGDATA.extensions = {}
GVGDATASYNCCMD_CMD_FIELD.name = "cmd"
GVGDATASYNCCMD_CMD_FIELD.full_name = ".Cmd.GvgDataSyncCmd.cmd"
GVGDATASYNCCMD_CMD_FIELD.number = 1
GVGDATASYNCCMD_CMD_FIELD.index = 0
GVGDATASYNCCMD_CMD_FIELD.label = 1
GVGDATASYNCCMD_CMD_FIELD.has_default_value = true
GVGDATASYNCCMD_CMD_FIELD.default_value = 11
GVGDATASYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGDATASYNCCMD_CMD_FIELD.type = 14
GVGDATASYNCCMD_CMD_FIELD.cpp_type = 8
GVGDATASYNCCMD_PARAM_FIELD.name = "param"
GVGDATASYNCCMD_PARAM_FIELD.full_name = ".Cmd.GvgDataSyncCmd.param"
GVGDATASYNCCMD_PARAM_FIELD.number = 2
GVGDATASYNCCMD_PARAM_FIELD.index = 1
GVGDATASYNCCMD_PARAM_FIELD.label = 1
GVGDATASYNCCMD_PARAM_FIELD.has_default_value = true
GVGDATASYNCCMD_PARAM_FIELD.default_value = 26
GVGDATASYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGDATASYNCCMD_PARAM_FIELD.type = 14
GVGDATASYNCCMD_PARAM_FIELD.cpp_type = 8
GVGDATASYNCCMD_DATAS_FIELD.name = "datas"
GVGDATASYNCCMD_DATAS_FIELD.full_name = ".Cmd.GvgDataSyncCmd.datas"
GVGDATASYNCCMD_DATAS_FIELD.number = 3
GVGDATASYNCCMD_DATAS_FIELD.index = 2
GVGDATASYNCCMD_DATAS_FIELD.label = 3
GVGDATASYNCCMD_DATAS_FIELD.has_default_value = false
GVGDATASYNCCMD_DATAS_FIELD.default_value = {}
GVGDATASYNCCMD_DATAS_FIELD.message_type = GVGDATA
GVGDATASYNCCMD_DATAS_FIELD.type = 11
GVGDATASYNCCMD_DATAS_FIELD.cpp_type = 10
GVGDATASYNCCMD_CITYTYPE_FIELD.name = "citytype"
GVGDATASYNCCMD_CITYTYPE_FIELD.full_name = ".Cmd.GvgDataSyncCmd.citytype"
GVGDATASYNCCMD_CITYTYPE_FIELD.number = 4
GVGDATASYNCCMD_CITYTYPE_FIELD.index = 3
GVGDATASYNCCMD_CITYTYPE_FIELD.label = 1
GVGDATASYNCCMD_CITYTYPE_FIELD.has_default_value = false
GVGDATASYNCCMD_CITYTYPE_FIELD.default_value = nil
GVGDATASYNCCMD_CITYTYPE_FIELD.enum_type = EGVGCITYTYPE
GVGDATASYNCCMD_CITYTYPE_FIELD.type = 14
GVGDATASYNCCMD_CITYTYPE_FIELD.cpp_type = 8
GVGDATASYNCCMD.name = "GvgDataSyncCmd"
GVGDATASYNCCMD.full_name = ".Cmd.GvgDataSyncCmd"
GVGDATASYNCCMD.nested_types = {}
GVGDATASYNCCMD.enum_types = {}
GVGDATASYNCCMD.fields = {
  GVGDATASYNCCMD_CMD_FIELD,
  GVGDATASYNCCMD_PARAM_FIELD,
  GVGDATASYNCCMD_DATAS_FIELD,
  GVGDATASYNCCMD_CITYTYPE_FIELD
}
GVGDATASYNCCMD.is_extendable = false
GVGDATASYNCCMD.extensions = {}
GVGDATAUPDATECMD_CMD_FIELD.name = "cmd"
GVGDATAUPDATECMD_CMD_FIELD.full_name = ".Cmd.GvgDataUpdateCmd.cmd"
GVGDATAUPDATECMD_CMD_FIELD.number = 1
GVGDATAUPDATECMD_CMD_FIELD.index = 0
GVGDATAUPDATECMD_CMD_FIELD.label = 1
GVGDATAUPDATECMD_CMD_FIELD.has_default_value = true
GVGDATAUPDATECMD_CMD_FIELD.default_value = 11
GVGDATAUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGDATAUPDATECMD_CMD_FIELD.type = 14
GVGDATAUPDATECMD_CMD_FIELD.cpp_type = 8
GVGDATAUPDATECMD_PARAM_FIELD.name = "param"
GVGDATAUPDATECMD_PARAM_FIELD.full_name = ".Cmd.GvgDataUpdateCmd.param"
GVGDATAUPDATECMD_PARAM_FIELD.number = 2
GVGDATAUPDATECMD_PARAM_FIELD.index = 1
GVGDATAUPDATECMD_PARAM_FIELD.label = 1
GVGDATAUPDATECMD_PARAM_FIELD.has_default_value = true
GVGDATAUPDATECMD_PARAM_FIELD.default_value = 27
GVGDATAUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGDATAUPDATECMD_PARAM_FIELD.type = 14
GVGDATAUPDATECMD_PARAM_FIELD.cpp_type = 8
GVGDATAUPDATECMD_DATA_FIELD.name = "data"
GVGDATAUPDATECMD_DATA_FIELD.full_name = ".Cmd.GvgDataUpdateCmd.data"
GVGDATAUPDATECMD_DATA_FIELD.number = 3
GVGDATAUPDATECMD_DATA_FIELD.index = 2
GVGDATAUPDATECMD_DATA_FIELD.label = 1
GVGDATAUPDATECMD_DATA_FIELD.has_default_value = false
GVGDATAUPDATECMD_DATA_FIELD.default_value = nil
GVGDATAUPDATECMD_DATA_FIELD.message_type = GVGDATA
GVGDATAUPDATECMD_DATA_FIELD.type = 11
GVGDATAUPDATECMD_DATA_FIELD.cpp_type = 10
GVGDATAUPDATECMD.name = "GvgDataUpdateCmd"
GVGDATAUPDATECMD.full_name = ".Cmd.GvgDataUpdateCmd"
GVGDATAUPDATECMD.nested_types = {}
GVGDATAUPDATECMD.enum_types = {}
GVGDATAUPDATECMD.fields = {
  GVGDATAUPDATECMD_CMD_FIELD,
  GVGDATAUPDATECMD_PARAM_FIELD,
  GVGDATAUPDATECMD_DATA_FIELD
}
GVGDATAUPDATECMD.is_extendable = false
GVGDATAUPDATECMD.extensions = {}
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.name = "cmd"
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgDefNameChangeFubenCmd.cmd"
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.number = 1
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.index = 0
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.label = 1
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.has_default_value = true
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.default_value = 11
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.type = 14
GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.name = "param"
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgDefNameChangeFubenCmd.param"
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.number = 2
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.index = 1
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.label = 1
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.default_value = 28
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.type = 14
GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.name = "newname"
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.full_name = ".Cmd.GvgDefNameChangeFubenCmd.newname"
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.number = 3
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.index = 2
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.label = 2
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.has_default_value = false
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.default_value = ""
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.type = 9
GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD.cpp_type = 9
GVGDEFNAMECHANGEFUBENCMD.name = "GvgDefNameChangeFubenCmd"
GVGDEFNAMECHANGEFUBENCMD.full_name = ".Cmd.GvgDefNameChangeFubenCmd"
GVGDEFNAMECHANGEFUBENCMD.nested_types = {}
GVGDEFNAMECHANGEFUBENCMD.enum_types = {}
GVGDEFNAMECHANGEFUBENCMD.fields = {
  GVGDEFNAMECHANGEFUBENCMD_CMD_FIELD,
  GVGDEFNAMECHANGEFUBENCMD_PARAM_FIELD,
  GVGDEFNAMECHANGEFUBENCMD_NEWNAME_FIELD
}
GVGDEFNAMECHANGEFUBENCMD.is_extendable = false
GVGDEFNAMECHANGEFUBENCMD.extensions = {}
SYNCMVPINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCMVPINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncMvpInfoFubenCmd.cmd"
SYNCMVPINFOFUBENCMD_CMD_FIELD.number = 1
SYNCMVPINFOFUBENCMD_CMD_FIELD.index = 0
SYNCMVPINFOFUBENCMD_CMD_FIELD.label = 1
SYNCMVPINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCMVPINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCMVPINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCMVPINFOFUBENCMD_CMD_FIELD.type = 14
SYNCMVPINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCMVPINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCMVPINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncMvpInfoFubenCmd.param"
SYNCMVPINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCMVPINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCMVPINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCMVPINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCMVPINFOFUBENCMD_PARAM_FIELD.default_value = 29
SYNCMVPINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCMVPINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCMVPINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.name = "usernum"
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.full_name = ".Cmd.SyncMvpInfoFubenCmd.usernum"
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.number = 3
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.index = 2
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.label = 1
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.has_default_value = true
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.default_value = 0
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.type = 13
SYNCMVPINFOFUBENCMD_USERNUM_FIELD.cpp_type = 3
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.name = "liveboss"
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.full_name = ".Cmd.SyncMvpInfoFubenCmd.liveboss"
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.number = 4
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.index = 3
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.label = 3
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.has_default_value = false
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.default_value = {}
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.type = 13
SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD.cpp_type = 3
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.name = "dieboss"
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.full_name = ".Cmd.SyncMvpInfoFubenCmd.dieboss"
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.number = 5
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.index = 4
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.label = 3
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.has_default_value = false
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.default_value = {}
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.type = 13
SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD.cpp_type = 3
SYNCMVPINFOFUBENCMD.name = "SyncMvpInfoFubenCmd"
SYNCMVPINFOFUBENCMD.full_name = ".Cmd.SyncMvpInfoFubenCmd"
SYNCMVPINFOFUBENCMD.nested_types = {}
SYNCMVPINFOFUBENCMD.enum_types = {}
SYNCMVPINFOFUBENCMD.fields = {
  SYNCMVPINFOFUBENCMD_CMD_FIELD,
  SYNCMVPINFOFUBENCMD_PARAM_FIELD,
  SYNCMVPINFOFUBENCMD_USERNUM_FIELD,
  SYNCMVPINFOFUBENCMD_LIVEBOSS_FIELD,
  SYNCMVPINFOFUBENCMD_DIEBOSS_FIELD
}
SYNCMVPINFOFUBENCMD.is_extendable = false
SYNCMVPINFOFUBENCMD.extensions = {}
BOSSDIEFUBENCMD_CMD_FIELD.name = "cmd"
BOSSDIEFUBENCMD_CMD_FIELD.full_name = ".Cmd.BossDieFubenCmd.cmd"
BOSSDIEFUBENCMD_CMD_FIELD.number = 1
BOSSDIEFUBENCMD_CMD_FIELD.index = 0
BOSSDIEFUBENCMD_CMD_FIELD.label = 1
BOSSDIEFUBENCMD_CMD_FIELD.has_default_value = true
BOSSDIEFUBENCMD_CMD_FIELD.default_value = 11
BOSSDIEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BOSSDIEFUBENCMD_CMD_FIELD.type = 14
BOSSDIEFUBENCMD_CMD_FIELD.cpp_type = 8
BOSSDIEFUBENCMD_PARAM_FIELD.name = "param"
BOSSDIEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.BossDieFubenCmd.param"
BOSSDIEFUBENCMD_PARAM_FIELD.number = 2
BOSSDIEFUBENCMD_PARAM_FIELD.index = 1
BOSSDIEFUBENCMD_PARAM_FIELD.label = 1
BOSSDIEFUBENCMD_PARAM_FIELD.has_default_value = true
BOSSDIEFUBENCMD_PARAM_FIELD.default_value = 30
BOSSDIEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
BOSSDIEFUBENCMD_PARAM_FIELD.type = 14
BOSSDIEFUBENCMD_PARAM_FIELD.cpp_type = 8
BOSSDIEFUBENCMD_NPCID_FIELD.name = "npcid"
BOSSDIEFUBENCMD_NPCID_FIELD.full_name = ".Cmd.BossDieFubenCmd.npcid"
BOSSDIEFUBENCMD_NPCID_FIELD.number = 3
BOSSDIEFUBENCMD_NPCID_FIELD.index = 2
BOSSDIEFUBENCMD_NPCID_FIELD.label = 2
BOSSDIEFUBENCMD_NPCID_FIELD.has_default_value = false
BOSSDIEFUBENCMD_NPCID_FIELD.default_value = 0
BOSSDIEFUBENCMD_NPCID_FIELD.type = 13
BOSSDIEFUBENCMD_NPCID_FIELD.cpp_type = 3
BOSSDIEFUBENCMD.name = "BossDieFubenCmd"
BOSSDIEFUBENCMD.full_name = ".Cmd.BossDieFubenCmd"
BOSSDIEFUBENCMD.nested_types = {}
BOSSDIEFUBENCMD.enum_types = {}
BOSSDIEFUBENCMD.fields = {
  BOSSDIEFUBENCMD_CMD_FIELD,
  BOSSDIEFUBENCMD_PARAM_FIELD,
  BOSSDIEFUBENCMD_NPCID_FIELD
}
BOSSDIEFUBENCMD.is_extendable = false
BOSSDIEFUBENCMD.extensions = {}
UPDATEUSERNUMFUBENCMD_CMD_FIELD.name = "cmd"
UPDATEUSERNUMFUBENCMD_CMD_FIELD.full_name = ".Cmd.UpdateUserNumFubenCmd.cmd"
UPDATEUSERNUMFUBENCMD_CMD_FIELD.number = 1
UPDATEUSERNUMFUBENCMD_CMD_FIELD.index = 0
UPDATEUSERNUMFUBENCMD_CMD_FIELD.label = 1
UPDATEUSERNUMFUBENCMD_CMD_FIELD.has_default_value = true
UPDATEUSERNUMFUBENCMD_CMD_FIELD.default_value = 11
UPDATEUSERNUMFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEUSERNUMFUBENCMD_CMD_FIELD.type = 14
UPDATEUSERNUMFUBENCMD_CMD_FIELD.cpp_type = 8
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.name = "param"
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.full_name = ".Cmd.UpdateUserNumFubenCmd.param"
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.number = 2
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.index = 1
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.label = 1
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.has_default_value = true
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.default_value = 31
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.type = 14
UPDATEUSERNUMFUBENCMD_PARAM_FIELD.cpp_type = 8
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.name = "usernum"
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.full_name = ".Cmd.UpdateUserNumFubenCmd.usernum"
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.number = 3
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.index = 2
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.label = 1
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.has_default_value = true
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.default_value = 0
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.type = 13
UPDATEUSERNUMFUBENCMD_USERNUM_FIELD.cpp_type = 3
UPDATEUSERNUMFUBENCMD.name = "UpdateUserNumFubenCmd"
UPDATEUSERNUMFUBENCMD.full_name = ".Cmd.UpdateUserNumFubenCmd"
UPDATEUSERNUMFUBENCMD.nested_types = {}
UPDATEUSERNUMFUBENCMD.enum_types = {}
UPDATEUSERNUMFUBENCMD.fields = {
  UPDATEUSERNUMFUBENCMD_CMD_FIELD,
  UPDATEUSERNUMFUBENCMD_PARAM_FIELD,
  UPDATEUSERNUMFUBENCMD_USERNUM_FIELD
}
UPDATEUSERNUMFUBENCMD.is_extendable = false
UPDATEUSERNUMFUBENCMD.extensions = {}
GVGTOWERVALUE_GUILDID_FIELD.name = "guildid"
GVGTOWERVALUE_GUILDID_FIELD.full_name = ".Cmd.GvgTowerValue.guildid"
GVGTOWERVALUE_GUILDID_FIELD.number = 1
GVGTOWERVALUE_GUILDID_FIELD.index = 0
GVGTOWERVALUE_GUILDID_FIELD.label = 1
GVGTOWERVALUE_GUILDID_FIELD.has_default_value = false
GVGTOWERVALUE_GUILDID_FIELD.default_value = 0
GVGTOWERVALUE_GUILDID_FIELD.type = 4
GVGTOWERVALUE_GUILDID_FIELD.cpp_type = 4
GVGTOWERVALUE_VALUE_FIELD.name = "value"
GVGTOWERVALUE_VALUE_FIELD.full_name = ".Cmd.GvgTowerValue.value"
GVGTOWERVALUE_VALUE_FIELD.number = 2
GVGTOWERVALUE_VALUE_FIELD.index = 1
GVGTOWERVALUE_VALUE_FIELD.label = 1
GVGTOWERVALUE_VALUE_FIELD.has_default_value = false
GVGTOWERVALUE_VALUE_FIELD.default_value = 0
GVGTOWERVALUE_VALUE_FIELD.type = 13
GVGTOWERVALUE_VALUE_FIELD.cpp_type = 3
GVGTOWERVALUE.name = "GvgTowerValue"
GVGTOWERVALUE.full_name = ".Cmd.GvgTowerValue"
GVGTOWERVALUE.nested_types = {}
GVGTOWERVALUE.enum_types = {}
GVGTOWERVALUE.fields = {
  GVGTOWERVALUE_GUILDID_FIELD,
  GVGTOWERVALUE_VALUE_FIELD
}
GVGTOWERVALUE.is_extendable = false
GVGTOWERVALUE.extensions = {}
GVGTOWERDATA_ETYPE_FIELD.name = "etype"
GVGTOWERDATA_ETYPE_FIELD.full_name = ".Cmd.GvgTowerData.etype"
GVGTOWERDATA_ETYPE_FIELD.number = 1
GVGTOWERDATA_ETYPE_FIELD.index = 0
GVGTOWERDATA_ETYPE_FIELD.label = 1
GVGTOWERDATA_ETYPE_FIELD.has_default_value = false
GVGTOWERDATA_ETYPE_FIELD.default_value = nil
GVGTOWERDATA_ETYPE_FIELD.enum_type = EGVGTOWERTYPE
GVGTOWERDATA_ETYPE_FIELD.type = 14
GVGTOWERDATA_ETYPE_FIELD.cpp_type = 8
GVGTOWERDATA_ESTATE_FIELD.name = "estate"
GVGTOWERDATA_ESTATE_FIELD.full_name = ".Cmd.GvgTowerData.estate"
GVGTOWERDATA_ESTATE_FIELD.number = 2
GVGTOWERDATA_ESTATE_FIELD.index = 1
GVGTOWERDATA_ESTATE_FIELD.label = 1
GVGTOWERDATA_ESTATE_FIELD.has_default_value = false
GVGTOWERDATA_ESTATE_FIELD.default_value = nil
GVGTOWERDATA_ESTATE_FIELD.enum_type = EGVGTOWERSTATE
GVGTOWERDATA_ESTATE_FIELD.type = 14
GVGTOWERDATA_ESTATE_FIELD.cpp_type = 8
GVGTOWERDATA_OWNER_GUILD_FIELD.name = "owner_guild"
GVGTOWERDATA_OWNER_GUILD_FIELD.full_name = ".Cmd.GvgTowerData.owner_guild"
GVGTOWERDATA_OWNER_GUILD_FIELD.number = 3
GVGTOWERDATA_OWNER_GUILD_FIELD.index = 2
GVGTOWERDATA_OWNER_GUILD_FIELD.label = 1
GVGTOWERDATA_OWNER_GUILD_FIELD.has_default_value = false
GVGTOWERDATA_OWNER_GUILD_FIELD.default_value = 0
GVGTOWERDATA_OWNER_GUILD_FIELD.type = 4
GVGTOWERDATA_OWNER_GUILD_FIELD.cpp_type = 4
GVGTOWERDATA_INFO_FIELD.name = "info"
GVGTOWERDATA_INFO_FIELD.full_name = ".Cmd.GvgTowerData.info"
GVGTOWERDATA_INFO_FIELD.number = 4
GVGTOWERDATA_INFO_FIELD.index = 3
GVGTOWERDATA_INFO_FIELD.label = 3
GVGTOWERDATA_INFO_FIELD.has_default_value = false
GVGTOWERDATA_INFO_FIELD.default_value = {}
GVGTOWERDATA_INFO_FIELD.message_type = GVGTOWERVALUE
GVGTOWERDATA_INFO_FIELD.type = 11
GVGTOWERDATA_INFO_FIELD.cpp_type = 10
GVGTOWERDATA.name = "GvgTowerData"
GVGTOWERDATA.full_name = ".Cmd.GvgTowerData"
GVGTOWERDATA.nested_types = {}
GVGTOWERDATA.enum_types = {}
GVGTOWERDATA.fields = {
  GVGTOWERDATA_ETYPE_FIELD,
  GVGTOWERDATA_ESTATE_FIELD,
  GVGTOWERDATA_OWNER_GUILD_FIELD,
  GVGTOWERDATA_INFO_FIELD
}
GVGTOWERDATA.is_extendable = false
GVGTOWERDATA.extensions = {}
GVGCRYSTALINFO_RANK_FIELD.name = "rank"
GVGCRYSTALINFO_RANK_FIELD.full_name = ".Cmd.GvgCrystalInfo.rank"
GVGCRYSTALINFO_RANK_FIELD.number = 1
GVGCRYSTALINFO_RANK_FIELD.index = 0
GVGCRYSTALINFO_RANK_FIELD.label = 1
GVGCRYSTALINFO_RANK_FIELD.has_default_value = false
GVGCRYSTALINFO_RANK_FIELD.default_value = 0
GVGCRYSTALINFO_RANK_FIELD.type = 13
GVGCRYSTALINFO_RANK_FIELD.cpp_type = 3
GVGCRYSTALINFO_GUILDID_FIELD.name = "guildid"
GVGCRYSTALINFO_GUILDID_FIELD.full_name = ".Cmd.GvgCrystalInfo.guildid"
GVGCRYSTALINFO_GUILDID_FIELD.number = 2
GVGCRYSTALINFO_GUILDID_FIELD.index = 1
GVGCRYSTALINFO_GUILDID_FIELD.label = 1
GVGCRYSTALINFO_GUILDID_FIELD.has_default_value = false
GVGCRYSTALINFO_GUILDID_FIELD.default_value = 0
GVGCRYSTALINFO_GUILDID_FIELD.type = 4
GVGCRYSTALINFO_GUILDID_FIELD.cpp_type = 4
GVGCRYSTALINFO_CRYSTALNUM_FIELD.name = "crystalnum"
GVGCRYSTALINFO_CRYSTALNUM_FIELD.full_name = ".Cmd.GvgCrystalInfo.crystalnum"
GVGCRYSTALINFO_CRYSTALNUM_FIELD.number = 3
GVGCRYSTALINFO_CRYSTALNUM_FIELD.index = 2
GVGCRYSTALINFO_CRYSTALNUM_FIELD.label = 1
GVGCRYSTALINFO_CRYSTALNUM_FIELD.has_default_value = true
GVGCRYSTALINFO_CRYSTALNUM_FIELD.default_value = 0
GVGCRYSTALINFO_CRYSTALNUM_FIELD.type = 13
GVGCRYSTALINFO_CRYSTALNUM_FIELD.cpp_type = 3
GVGCRYSTALINFO_CHIPNUM_FIELD.name = "chipnum"
GVGCRYSTALINFO_CHIPNUM_FIELD.full_name = ".Cmd.GvgCrystalInfo.chipnum"
GVGCRYSTALINFO_CHIPNUM_FIELD.number = 4
GVGCRYSTALINFO_CHIPNUM_FIELD.index = 3
GVGCRYSTALINFO_CHIPNUM_FIELD.label = 1
GVGCRYSTALINFO_CHIPNUM_FIELD.has_default_value = true
GVGCRYSTALINFO_CHIPNUM_FIELD.default_value = 0
GVGCRYSTALINFO_CHIPNUM_FIELD.type = 13
GVGCRYSTALINFO_CHIPNUM_FIELD.cpp_type = 3
GVGCRYSTALINFO.name = "GvgCrystalInfo"
GVGCRYSTALINFO.full_name = ".Cmd.GvgCrystalInfo"
GVGCRYSTALINFO.nested_types = {}
GVGCRYSTALINFO.enum_types = {}
GVGCRYSTALINFO.fields = {
  GVGCRYSTALINFO_RANK_FIELD,
  GVGCRYSTALINFO_GUILDID_FIELD,
  GVGCRYSTALINFO_CRYSTALNUM_FIELD,
  GVGCRYSTALINFO_CHIPNUM_FIELD
}
GVGCRYSTALINFO.is_extendable = false
GVGCRYSTALINFO.extensions = {}
GVGGUILDINFO_INDEX_FIELD.name = "index"
GVGGUILDINFO_INDEX_FIELD.full_name = ".Cmd.GvgGuildInfo.index"
GVGGUILDINFO_INDEX_FIELD.number = 1
GVGGUILDINFO_INDEX_FIELD.index = 0
GVGGUILDINFO_INDEX_FIELD.label = 1
GVGGUILDINFO_INDEX_FIELD.has_default_value = false
GVGGUILDINFO_INDEX_FIELD.default_value = 0
GVGGUILDINFO_INDEX_FIELD.type = 13
GVGGUILDINFO_INDEX_FIELD.cpp_type = 3
GVGGUILDINFO_GUILDID_FIELD.name = "guildid"
GVGGUILDINFO_GUILDID_FIELD.full_name = ".Cmd.GvgGuildInfo.guildid"
GVGGUILDINFO_GUILDID_FIELD.number = 2
GVGGUILDINFO_GUILDID_FIELD.index = 1
GVGGUILDINFO_GUILDID_FIELD.label = 1
GVGGUILDINFO_GUILDID_FIELD.has_default_value = false
GVGGUILDINFO_GUILDID_FIELD.default_value = 0
GVGGUILDINFO_GUILDID_FIELD.type = 4
GVGGUILDINFO_GUILDID_FIELD.cpp_type = 4
GVGGUILDINFO_GUILDNAME_FIELD.name = "guildname"
GVGGUILDINFO_GUILDNAME_FIELD.full_name = ".Cmd.GvgGuildInfo.guildname"
GVGGUILDINFO_GUILDNAME_FIELD.number = 3
GVGGUILDINFO_GUILDNAME_FIELD.index = 2
GVGGUILDINFO_GUILDNAME_FIELD.label = 1
GVGGUILDINFO_GUILDNAME_FIELD.has_default_value = false
GVGGUILDINFO_GUILDNAME_FIELD.default_value = ""
GVGGUILDINFO_GUILDNAME_FIELD.type = 9
GVGGUILDINFO_GUILDNAME_FIELD.cpp_type = 9
GVGGUILDINFO_ICON_FIELD.name = "icon"
GVGGUILDINFO_ICON_FIELD.full_name = ".Cmd.GvgGuildInfo.icon"
GVGGUILDINFO_ICON_FIELD.number = 4
GVGGUILDINFO_ICON_FIELD.index = 3
GVGGUILDINFO_ICON_FIELD.label = 1
GVGGUILDINFO_ICON_FIELD.has_default_value = false
GVGGUILDINFO_ICON_FIELD.default_value = ""
GVGGUILDINFO_ICON_FIELD.type = 9
GVGGUILDINFO_ICON_FIELD.cpp_type = 9
GVGGUILDINFO_METAL_LIVE_FIELD.name = "metal_live"
GVGGUILDINFO_METAL_LIVE_FIELD.full_name = ".Cmd.GvgGuildInfo.metal_live"
GVGGUILDINFO_METAL_LIVE_FIELD.number = 5
GVGGUILDINFO_METAL_LIVE_FIELD.index = 4
GVGGUILDINFO_METAL_LIVE_FIELD.label = 1
GVGGUILDINFO_METAL_LIVE_FIELD.has_default_value = true
GVGGUILDINFO_METAL_LIVE_FIELD.default_value = false
GVGGUILDINFO_METAL_LIVE_FIELD.type = 8
GVGGUILDINFO_METAL_LIVE_FIELD.cpp_type = 7
GVGGUILDINFO_CRYSTAL_FIELD.name = "crystal"
GVGGUILDINFO_CRYSTAL_FIELD.full_name = ".Cmd.GvgGuildInfo.crystal"
GVGGUILDINFO_CRYSTAL_FIELD.number = 6
GVGGUILDINFO_CRYSTAL_FIELD.index = 5
GVGGUILDINFO_CRYSTAL_FIELD.label = 1
GVGGUILDINFO_CRYSTAL_FIELD.has_default_value = false
GVGGUILDINFO_CRYSTAL_FIELD.default_value = nil
GVGGUILDINFO_CRYSTAL_FIELD.message_type = GVGCRYSTALINFO
GVGGUILDINFO_CRYSTAL_FIELD.type = 11
GVGGUILDINFO_CRYSTAL_FIELD.cpp_type = 10
GVGGUILDINFO.name = "GvgGuildInfo"
GVGGUILDINFO.full_name = ".Cmd.GvgGuildInfo"
GVGGUILDINFO.nested_types = {}
GVGGUILDINFO.enum_types = {}
GVGGUILDINFO.fields = {
  GVGGUILDINFO_INDEX_FIELD,
  GVGGUILDINFO_GUILDID_FIELD,
  GVGGUILDINFO_GUILDNAME_FIELD,
  GVGGUILDINFO_ICON_FIELD,
  GVGGUILDINFO_METAL_LIVE_FIELD,
  GVGGUILDINFO_CRYSTAL_FIELD
}
GVGGUILDINFO.is_extendable = false
GVGGUILDINFO.extensions = {}
SUPERGVGSYNCFUBENCMD_CMD_FIELD.name = "cmd"
SUPERGVGSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.SuperGvgSyncFubenCmd.cmd"
SUPERGVGSYNCFUBENCMD_CMD_FIELD.number = 1
SUPERGVGSYNCFUBENCMD_CMD_FIELD.index = 0
SUPERGVGSYNCFUBENCMD_CMD_FIELD.label = 1
SUPERGVGSYNCFUBENCMD_CMD_FIELD.has_default_value = true
SUPERGVGSYNCFUBENCMD_CMD_FIELD.default_value = 11
SUPERGVGSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SUPERGVGSYNCFUBENCMD_CMD_FIELD.type = 14
SUPERGVGSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.name = "param"
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SuperGvgSyncFubenCmd.param"
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.number = 2
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.index = 1
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.label = 1
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.default_value = 32
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.type = 14
SUPERGVGSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.name = "towers"
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.full_name = ".Cmd.SuperGvgSyncFubenCmd.towers"
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.number = 3
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.index = 2
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.label = 3
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.has_default_value = false
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.default_value = {}
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.message_type = GVGTOWERDATA
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.type = 11
SUPERGVGSYNCFUBENCMD_TOWERS_FIELD.cpp_type = 10
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.name = "guildinfo"
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.full_name = ".Cmd.SuperGvgSyncFubenCmd.guildinfo"
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.number = 4
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.index = 3
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.label = 3
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.has_default_value = false
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.default_value = {}
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.message_type = GVGGUILDINFO
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.type = 11
SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD.cpp_type = 10
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.name = "firebegintime"
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.full_name = ".Cmd.SuperGvgSyncFubenCmd.firebegintime"
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.number = 5
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.index = 4
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.label = 1
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.has_default_value = true
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.default_value = 0
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.type = 13
SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD.cpp_type = 3
SUPERGVGSYNCFUBENCMD.name = "SuperGvgSyncFubenCmd"
SUPERGVGSYNCFUBENCMD.full_name = ".Cmd.SuperGvgSyncFubenCmd"
SUPERGVGSYNCFUBENCMD.nested_types = {}
SUPERGVGSYNCFUBENCMD.enum_types = {}
SUPERGVGSYNCFUBENCMD.fields = {
  SUPERGVGSYNCFUBENCMD_CMD_FIELD,
  SUPERGVGSYNCFUBENCMD_PARAM_FIELD,
  SUPERGVGSYNCFUBENCMD_TOWERS_FIELD,
  SUPERGVGSYNCFUBENCMD_GUILDINFO_FIELD,
  SUPERGVGSYNCFUBENCMD_FIREBEGINTIME_FIELD
}
SUPERGVGSYNCFUBENCMD.is_extendable = false
SUPERGVGSYNCFUBENCMD.extensions = {}
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgTowerUpdateFubenCmd.cmd"
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.number = 1
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.index = 0
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.label = 1
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.default_value = 11
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.type = 14
GVGTOWERUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.name = "param"
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgTowerUpdateFubenCmd.param"
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.number = 2
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.index = 1
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.label = 1
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.default_value = 33
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.type = 14
GVGTOWERUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.name = "towers"
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.full_name = ".Cmd.GvgTowerUpdateFubenCmd.towers"
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.number = 3
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.index = 2
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.label = 3
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.has_default_value = false
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.default_value = {}
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.message_type = GVGTOWERDATA
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.type = 11
GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD.cpp_type = 10
GVGTOWERUPDATEFUBENCMD.name = "GvgTowerUpdateFubenCmd"
GVGTOWERUPDATEFUBENCMD.full_name = ".Cmd.GvgTowerUpdateFubenCmd"
GVGTOWERUPDATEFUBENCMD.nested_types = {}
GVGTOWERUPDATEFUBENCMD.enum_types = {}
GVGTOWERUPDATEFUBENCMD.fields = {
  GVGTOWERUPDATEFUBENCMD_CMD_FIELD,
  GVGTOWERUPDATEFUBENCMD_PARAM_FIELD,
  GVGTOWERUPDATEFUBENCMD_TOWERS_FIELD
}
GVGTOWERUPDATEFUBENCMD.is_extendable = false
GVGTOWERUPDATEFUBENCMD.extensions = {}
GVGMETALDIEFUBENCMD_CMD_FIELD.name = "cmd"
GVGMETALDIEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgMetalDieFubenCmd.cmd"
GVGMETALDIEFUBENCMD_CMD_FIELD.number = 1
GVGMETALDIEFUBENCMD_CMD_FIELD.index = 0
GVGMETALDIEFUBENCMD_CMD_FIELD.label = 1
GVGMETALDIEFUBENCMD_CMD_FIELD.has_default_value = true
GVGMETALDIEFUBENCMD_CMD_FIELD.default_value = 11
GVGMETALDIEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGMETALDIEFUBENCMD_CMD_FIELD.type = 14
GVGMETALDIEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGMETALDIEFUBENCMD_PARAM_FIELD.name = "param"
GVGMETALDIEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgMetalDieFubenCmd.param"
GVGMETALDIEFUBENCMD_PARAM_FIELD.number = 2
GVGMETALDIEFUBENCMD_PARAM_FIELD.index = 1
GVGMETALDIEFUBENCMD_PARAM_FIELD.label = 1
GVGMETALDIEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGMETALDIEFUBENCMD_PARAM_FIELD.default_value = 39
GVGMETALDIEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGMETALDIEFUBENCMD_PARAM_FIELD.type = 14
GVGMETALDIEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGMETALDIEFUBENCMD_INDEX_FIELD.name = "index"
GVGMETALDIEFUBENCMD_INDEX_FIELD.full_name = ".Cmd.GvgMetalDieFubenCmd.index"
GVGMETALDIEFUBENCMD_INDEX_FIELD.number = 3
GVGMETALDIEFUBENCMD_INDEX_FIELD.index = 2
GVGMETALDIEFUBENCMD_INDEX_FIELD.label = 1
GVGMETALDIEFUBENCMD_INDEX_FIELD.has_default_value = true
GVGMETALDIEFUBENCMD_INDEX_FIELD.default_value = 0
GVGMETALDIEFUBENCMD_INDEX_FIELD.type = 13
GVGMETALDIEFUBENCMD_INDEX_FIELD.cpp_type = 3
GVGMETALDIEFUBENCMD.name = "GvgMetalDieFubenCmd"
GVGMETALDIEFUBENCMD.full_name = ".Cmd.GvgMetalDieFubenCmd"
GVGMETALDIEFUBENCMD.nested_types = {}
GVGMETALDIEFUBENCMD.enum_types = {}
GVGMETALDIEFUBENCMD.fields = {
  GVGMETALDIEFUBENCMD_CMD_FIELD,
  GVGMETALDIEFUBENCMD_PARAM_FIELD,
  GVGMETALDIEFUBENCMD_INDEX_FIELD
}
GVGMETALDIEFUBENCMD.is_extendable = false
GVGMETALDIEFUBENCMD.extensions = {}
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgCrystalUpdateFubenCmd.cmd"
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.number = 1
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.index = 0
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.label = 1
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.default_value = 11
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.type = 14
GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.name = "param"
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgCrystalUpdateFubenCmd.param"
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.number = 2
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.index = 1
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.label = 1
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.default_value = 34
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.type = 14
GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.name = "crystals"
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.full_name = ".Cmd.GvgCrystalUpdateFubenCmd.crystals"
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.number = 3
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.index = 2
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.label = 3
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.has_default_value = false
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.default_value = {}
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.message_type = GVGCRYSTALINFO
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.type = 11
GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD.cpp_type = 10
GVGCRYSTALUPDATEFUBENCMD.name = "GvgCrystalUpdateFubenCmd"
GVGCRYSTALUPDATEFUBENCMD.full_name = ".Cmd.GvgCrystalUpdateFubenCmd"
GVGCRYSTALUPDATEFUBENCMD.nested_types = {}
GVGCRYSTALUPDATEFUBENCMD.enum_types = {}
GVGCRYSTALUPDATEFUBENCMD.fields = {
  GVGCRYSTALUPDATEFUBENCMD_CMD_FIELD,
  GVGCRYSTALUPDATEFUBENCMD_PARAM_FIELD,
  GVGCRYSTALUPDATEFUBENCMD_CRYSTALS_FIELD
}
GVGCRYSTALUPDATEFUBENCMD.is_extendable = false
GVGCRYSTALUPDATEFUBENCMD.extensions = {}
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.name = "cmd"
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.QueryGvgTowerInfoFubenCmd.cmd"
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.number = 1
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.index = 0
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.label = 1
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.has_default_value = true
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.default_value = 11
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.type = 14
QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD.cpp_type = 8
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.name = "param"
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.QueryGvgTowerInfoFubenCmd.param"
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.number = 2
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.index = 1
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.label = 1
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.has_default_value = true
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.default_value = 35
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.type = 14
QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.name = "etype"
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.full_name = ".Cmd.QueryGvgTowerInfoFubenCmd.etype"
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.number = 3
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.index = 2
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.label = 2
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.has_default_value = false
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.default_value = nil
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.enum_type = EGVGTOWERTYPE
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.type = 14
QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD.cpp_type = 8
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.name = "open"
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.full_name = ".Cmd.QueryGvgTowerInfoFubenCmd.open"
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.number = 4
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.index = 3
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.label = 1
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.has_default_value = true
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.default_value = false
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.type = 8
QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD.cpp_type = 7
QUERYGVGTOWERINFOFUBENCMD.name = "QueryGvgTowerInfoFubenCmd"
QUERYGVGTOWERINFOFUBENCMD.full_name = ".Cmd.QueryGvgTowerInfoFubenCmd"
QUERYGVGTOWERINFOFUBENCMD.nested_types = {}
QUERYGVGTOWERINFOFUBENCMD.enum_types = {}
QUERYGVGTOWERINFOFUBENCMD.fields = {
  QUERYGVGTOWERINFOFUBENCMD_CMD_FIELD,
  QUERYGVGTOWERINFOFUBENCMD_PARAM_FIELD,
  QUERYGVGTOWERINFOFUBENCMD_ETYPE_FIELD,
  QUERYGVGTOWERINFOFUBENCMD_OPEN_FIELD
}
QUERYGVGTOWERINFOFUBENCMD.is_extendable = false
QUERYGVGTOWERINFOFUBENCMD.extensions = {}
REWARDITEMDATA_ITEMID_FIELD.name = "itemid"
REWARDITEMDATA_ITEMID_FIELD.full_name = ".Cmd.RewardItemData.itemid"
REWARDITEMDATA_ITEMID_FIELD.number = 1
REWARDITEMDATA_ITEMID_FIELD.index = 0
REWARDITEMDATA_ITEMID_FIELD.label = 1
REWARDITEMDATA_ITEMID_FIELD.has_default_value = false
REWARDITEMDATA_ITEMID_FIELD.default_value = 0
REWARDITEMDATA_ITEMID_FIELD.type = 13
REWARDITEMDATA_ITEMID_FIELD.cpp_type = 3
REWARDITEMDATA_COUNT_FIELD.name = "count"
REWARDITEMDATA_COUNT_FIELD.full_name = ".Cmd.RewardItemData.count"
REWARDITEMDATA_COUNT_FIELD.number = 2
REWARDITEMDATA_COUNT_FIELD.index = 1
REWARDITEMDATA_COUNT_FIELD.label = 1
REWARDITEMDATA_COUNT_FIELD.has_default_value = false
REWARDITEMDATA_COUNT_FIELD.default_value = 0
REWARDITEMDATA_COUNT_FIELD.type = 13
REWARDITEMDATA_COUNT_FIELD.cpp_type = 3
REWARDITEMDATA.name = "RewardItemData"
REWARDITEMDATA.full_name = ".Cmd.RewardItemData"
REWARDITEMDATA.nested_types = {}
REWARDITEMDATA.enum_types = {}
REWARDITEMDATA.fields = {
  REWARDITEMDATA_ITEMID_FIELD,
  REWARDITEMDATA_COUNT_FIELD
}
REWARDITEMDATA.is_extendable = false
REWARDITEMDATA.extensions = {}
SUPERGVGREWARDDATA_GUILDID_FIELD.name = "guildid"
SUPERGVGREWARDDATA_GUILDID_FIELD.full_name = ".Cmd.SuperGvgRewardData.guildid"
SUPERGVGREWARDDATA_GUILDID_FIELD.number = 1
SUPERGVGREWARDDATA_GUILDID_FIELD.index = 0
SUPERGVGREWARDDATA_GUILDID_FIELD.label = 1
SUPERGVGREWARDDATA_GUILDID_FIELD.has_default_value = false
SUPERGVGREWARDDATA_GUILDID_FIELD.default_value = 0
SUPERGVGREWARDDATA_GUILDID_FIELD.type = 4
SUPERGVGREWARDDATA_GUILDID_FIELD.cpp_type = 4
SUPERGVGREWARDDATA_RANK_FIELD.name = "rank"
SUPERGVGREWARDDATA_RANK_FIELD.full_name = ".Cmd.SuperGvgRewardData.rank"
SUPERGVGREWARDDATA_RANK_FIELD.number = 2
SUPERGVGREWARDDATA_RANK_FIELD.index = 1
SUPERGVGREWARDDATA_RANK_FIELD.label = 1
SUPERGVGREWARDDATA_RANK_FIELD.has_default_value = false
SUPERGVGREWARDDATA_RANK_FIELD.default_value = 0
SUPERGVGREWARDDATA_RANK_FIELD.type = 13
SUPERGVGREWARDDATA_RANK_FIELD.cpp_type = 3
SUPERGVGREWARDDATA_ITEMS_FIELD.name = "items"
SUPERGVGREWARDDATA_ITEMS_FIELD.full_name = ".Cmd.SuperGvgRewardData.items"
SUPERGVGREWARDDATA_ITEMS_FIELD.number = 3
SUPERGVGREWARDDATA_ITEMS_FIELD.index = 2
SUPERGVGREWARDDATA_ITEMS_FIELD.label = 3
SUPERGVGREWARDDATA_ITEMS_FIELD.has_default_value = false
SUPERGVGREWARDDATA_ITEMS_FIELD.default_value = {}
SUPERGVGREWARDDATA_ITEMS_FIELD.message_type = REWARDITEMDATA
SUPERGVGREWARDDATA_ITEMS_FIELD.type = 11
SUPERGVGREWARDDATA_ITEMS_FIELD.cpp_type = 10
SUPERGVGREWARDDATA.name = "SuperGvgRewardData"
SUPERGVGREWARDDATA.full_name = ".Cmd.SuperGvgRewardData"
SUPERGVGREWARDDATA.nested_types = {}
SUPERGVGREWARDDATA.enum_types = {}
SUPERGVGREWARDDATA.fields = {
  SUPERGVGREWARDDATA_GUILDID_FIELD,
  SUPERGVGREWARDDATA_RANK_FIELD,
  SUPERGVGREWARDDATA_ITEMS_FIELD
}
SUPERGVGREWARDDATA.is_extendable = false
SUPERGVGREWARDDATA.extensions = {}
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.name = "cmd"
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SuperGvgRewardInfoFubenCmd.cmd"
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.number = 1
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.index = 0
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.label = 1
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.has_default_value = true
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.default_value = 11
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.type = 14
SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.name = "param"
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SuperGvgRewardInfoFubenCmd.param"
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.number = 2
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.index = 1
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.label = 1
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.default_value = 36
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.type = 14
SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.name = "rewardinfo"
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.full_name = ".Cmd.SuperGvgRewardInfoFubenCmd.rewardinfo"
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.number = 3
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.index = 2
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.label = 3
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.has_default_value = false
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.default_value = {}
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.message_type = SUPERGVGREWARDDATA
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.type = 11
SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD.cpp_type = 10
SUPERGVGREWARDINFOFUBENCMD.name = "SuperGvgRewardInfoFubenCmd"
SUPERGVGREWARDINFOFUBENCMD.full_name = ".Cmd.SuperGvgRewardInfoFubenCmd"
SUPERGVGREWARDINFOFUBENCMD.nested_types = {}
SUPERGVGREWARDINFOFUBENCMD.enum_types = {}
SUPERGVGREWARDINFOFUBENCMD.fields = {
  SUPERGVGREWARDINFOFUBENCMD_CMD_FIELD,
  SUPERGVGREWARDINFOFUBENCMD_PARAM_FIELD,
  SUPERGVGREWARDINFOFUBENCMD_REWARDINFO_FIELD
}
SUPERGVGREWARDINFOFUBENCMD.is_extendable = false
SUPERGVGREWARDINFOFUBENCMD.extensions = {}
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.name = "cmd"
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.full_name = ".Cmd.SuperGvgQueryUserDataFubenCmd.cmd"
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.number = 1
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.index = 0
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.label = 1
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.has_default_value = true
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.default_value = 11
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.type = 14
SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD.cpp_type = 8
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.name = "param"
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SuperGvgQueryUserDataFubenCmd.param"
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.number = 2
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.index = 1
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.label = 1
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.has_default_value = true
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.default_value = 37
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.type = 14
SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD.cpp_type = 8
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.name = "guilduserdata"
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.full_name = ".Cmd.SuperGvgQueryUserDataFubenCmd.guilduserdata"
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.number = 3
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.index = 2
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.label = 3
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.has_default_value = false
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.default_value = {}
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.message_type = ProtoCommon_pb.SUPERGVGGUILDUSERDATA
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.type = 11
SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD.cpp_type = 10
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.name = "is_end"
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.full_name = ".Cmd.SuperGvgQueryUserDataFubenCmd.is_end"
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.number = 4
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.index = 3
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.label = 1
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.has_default_value = true
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.default_value = false
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.type = 8
SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD.cpp_type = 7
SUPERGVGQUERYUSERDATAFUBENCMD.name = "SuperGvgQueryUserDataFubenCmd"
SUPERGVGQUERYUSERDATAFUBENCMD.full_name = ".Cmd.SuperGvgQueryUserDataFubenCmd"
SUPERGVGQUERYUSERDATAFUBENCMD.nested_types = {}
SUPERGVGQUERYUSERDATAFUBENCMD.enum_types = {}
SUPERGVGQUERYUSERDATAFUBENCMD.fields = {
  SUPERGVGQUERYUSERDATAFUBENCMD_CMD_FIELD,
  SUPERGVGQUERYUSERDATAFUBENCMD_PARAM_FIELD,
  SUPERGVGQUERYUSERDATAFUBENCMD_GUILDUSERDATA_FIELD,
  SUPERGVGQUERYUSERDATAFUBENCMD_IS_END_FIELD
}
SUPERGVGQUERYUSERDATAFUBENCMD.is_extendable = false
SUPERGVGQUERYUSERDATAFUBENCMD.extensions = {}
MVPBATTLETEAMDATA_TEAMID_FIELD.name = "teamid"
MVPBATTLETEAMDATA_TEAMID_FIELD.full_name = ".Cmd.MvpBattleTeamData.teamid"
MVPBATTLETEAMDATA_TEAMID_FIELD.number = 1
MVPBATTLETEAMDATA_TEAMID_FIELD.index = 0
MVPBATTLETEAMDATA_TEAMID_FIELD.label = 2
MVPBATTLETEAMDATA_TEAMID_FIELD.has_default_value = false
MVPBATTLETEAMDATA_TEAMID_FIELD.default_value = 0
MVPBATTLETEAMDATA_TEAMID_FIELD.type = 4
MVPBATTLETEAMDATA_TEAMID_FIELD.cpp_type = 4
MVPBATTLETEAMDATA_TEAMNAME_FIELD.name = "teamname"
MVPBATTLETEAMDATA_TEAMNAME_FIELD.full_name = ".Cmd.MvpBattleTeamData.teamname"
MVPBATTLETEAMDATA_TEAMNAME_FIELD.number = 2
MVPBATTLETEAMDATA_TEAMNAME_FIELD.index = 1
MVPBATTLETEAMDATA_TEAMNAME_FIELD.label = 1
MVPBATTLETEAMDATA_TEAMNAME_FIELD.has_default_value = false
MVPBATTLETEAMDATA_TEAMNAME_FIELD.default_value = ""
MVPBATTLETEAMDATA_TEAMNAME_FIELD.type = 9
MVPBATTLETEAMDATA_TEAMNAME_FIELD.cpp_type = 9
MVPBATTLETEAMDATA_KILLMVPS_FIELD.name = "killmvps"
MVPBATTLETEAMDATA_KILLMVPS_FIELD.full_name = ".Cmd.MvpBattleTeamData.killmvps"
MVPBATTLETEAMDATA_KILLMVPS_FIELD.number = 3
MVPBATTLETEAMDATA_KILLMVPS_FIELD.index = 2
MVPBATTLETEAMDATA_KILLMVPS_FIELD.label = 3
MVPBATTLETEAMDATA_KILLMVPS_FIELD.has_default_value = false
MVPBATTLETEAMDATA_KILLMVPS_FIELD.default_value = {}
MVPBATTLETEAMDATA_KILLMVPS_FIELD.type = 13
MVPBATTLETEAMDATA_KILLMVPS_FIELD.cpp_type = 3
MVPBATTLETEAMDATA_KILLMINIS_FIELD.name = "killminis"
MVPBATTLETEAMDATA_KILLMINIS_FIELD.full_name = ".Cmd.MvpBattleTeamData.killminis"
MVPBATTLETEAMDATA_KILLMINIS_FIELD.number = 4
MVPBATTLETEAMDATA_KILLMINIS_FIELD.index = 3
MVPBATTLETEAMDATA_KILLMINIS_FIELD.label = 3
MVPBATTLETEAMDATA_KILLMINIS_FIELD.has_default_value = false
MVPBATTLETEAMDATA_KILLMINIS_FIELD.default_value = {}
MVPBATTLETEAMDATA_KILLMINIS_FIELD.type = 13
MVPBATTLETEAMDATA_KILLMINIS_FIELD.cpp_type = 3
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.name = "killusernum"
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.full_name = ".Cmd.MvpBattleTeamData.killusernum"
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.number = 5
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.index = 4
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.label = 1
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.has_default_value = true
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.default_value = 0
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.type = 13
MVPBATTLETEAMDATA_KILLUSERNUM_FIELD.cpp_type = 3
MVPBATTLETEAMDATA_DEADBOSS_FIELD.name = "deadboss"
MVPBATTLETEAMDATA_DEADBOSS_FIELD.full_name = ".Cmd.MvpBattleTeamData.deadboss"
MVPBATTLETEAMDATA_DEADBOSS_FIELD.number = 6
MVPBATTLETEAMDATA_DEADBOSS_FIELD.index = 5
MVPBATTLETEAMDATA_DEADBOSS_FIELD.label = 3
MVPBATTLETEAMDATA_DEADBOSS_FIELD.has_default_value = false
MVPBATTLETEAMDATA_DEADBOSS_FIELD.default_value = {}
MVPBATTLETEAMDATA_DEADBOSS_FIELD.type = 13
MVPBATTLETEAMDATA_DEADBOSS_FIELD.cpp_type = 3
MVPBATTLETEAMDATA.name = "MvpBattleTeamData"
MVPBATTLETEAMDATA.full_name = ".Cmd.MvpBattleTeamData"
MVPBATTLETEAMDATA.nested_types = {}
MVPBATTLETEAMDATA.enum_types = {}
MVPBATTLETEAMDATA.fields = {
  MVPBATTLETEAMDATA_TEAMID_FIELD,
  MVPBATTLETEAMDATA_TEAMNAME_FIELD,
  MVPBATTLETEAMDATA_KILLMVPS_FIELD,
  MVPBATTLETEAMDATA_KILLMINIS_FIELD,
  MVPBATTLETEAMDATA_KILLUSERNUM_FIELD,
  MVPBATTLETEAMDATA_DEADBOSS_FIELD
}
MVPBATTLETEAMDATA.is_extendable = false
MVPBATTLETEAMDATA.extensions = {}
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.name = "cmd"
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.full_name = ".Cmd.MvpBattleReportFubenCmd.cmd"
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.number = 1
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.index = 0
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.label = 1
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.has_default_value = true
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.default_value = 11
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.type = 14
MVPBATTLEREPORTFUBENCMD_CMD_FIELD.cpp_type = 8
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.name = "param"
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.MvpBattleReportFubenCmd.param"
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.number = 2
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.index = 1
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.label = 1
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.has_default_value = true
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.default_value = 38
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.type = 14
MVPBATTLEREPORTFUBENCMD_PARAM_FIELD.cpp_type = 8
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.name = "datas"
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.full_name = ".Cmd.MvpBattleReportFubenCmd.datas"
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.number = 3
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.index = 2
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.label = 3
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.has_default_value = false
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.default_value = {}
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.message_type = MVPBATTLETEAMDATA
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.type = 11
MVPBATTLEREPORTFUBENCMD_DATAS_FIELD.cpp_type = 10
MVPBATTLEREPORTFUBENCMD.name = "MvpBattleReportFubenCmd"
MVPBATTLEREPORTFUBENCMD.full_name = ".Cmd.MvpBattleReportFubenCmd"
MVPBATTLEREPORTFUBENCMD.nested_types = {}
MVPBATTLEREPORTFUBENCMD.enum_types = {}
MVPBATTLEREPORTFUBENCMD.fields = {
  MVPBATTLEREPORTFUBENCMD_CMD_FIELD,
  MVPBATTLEREPORTFUBENCMD_PARAM_FIELD,
  MVPBATTLEREPORTFUBENCMD_DATAS_FIELD
}
MVPBATTLEREPORTFUBENCMD.is_extendable = false
MVPBATTLEREPORTFUBENCMD.extensions = {}
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.name = "cmd"
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.full_name = ".Cmd.InviteSummonBossFubenCmd.cmd"
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.number = 1
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.index = 0
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.label = 1
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.has_default_value = true
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.default_value = 11
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.type = 14
INVITESUMMONBOSSFUBENCMD_CMD_FIELD.cpp_type = 8
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.name = "param"
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.InviteSummonBossFubenCmd.param"
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.number = 2
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.index = 1
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.label = 1
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.has_default_value = true
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.default_value = 40
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.type = 14
INVITESUMMONBOSSFUBENCMD_PARAM_FIELD.cpp_type = 8
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.name = "difficulty"
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.full_name = ".Cmd.InviteSummonBossFubenCmd.difficulty"
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.number = 3
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.index = 2
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.label = 1
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.has_default_value = false
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.default_value = nil
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.enum_type = EDEADBOSSDIFFICULTY
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.type = 14
INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD.cpp_type = 8
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.name = "deadboss_raid_index"
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.full_name = ".Cmd.InviteSummonBossFubenCmd.deadboss_raid_index"
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.number = 4
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.index = 3
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.label = 1
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.has_default_value = false
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.default_value = 0
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.type = 13
INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD.cpp_type = 3
INVITESUMMONBOSSFUBENCMD.name = "InviteSummonBossFubenCmd"
INVITESUMMONBOSSFUBENCMD.full_name = ".Cmd.InviteSummonBossFubenCmd"
INVITESUMMONBOSSFUBENCMD.nested_types = {}
INVITESUMMONBOSSFUBENCMD.enum_types = {}
INVITESUMMONBOSSFUBENCMD.fields = {
  INVITESUMMONBOSSFUBENCMD_CMD_FIELD,
  INVITESUMMONBOSSFUBENCMD_PARAM_FIELD,
  INVITESUMMONBOSSFUBENCMD_DIFFICULTY_FIELD,
  INVITESUMMONBOSSFUBENCMD_DEADBOSS_RAID_INDEX_FIELD
}
INVITESUMMONBOSSFUBENCMD.is_extendable = false
INVITESUMMONBOSSFUBENCMD.extensions = {}
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.name = "cmd"
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.full_name = ".Cmd.ReplySummonBossFubenCmd.cmd"
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.number = 1
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.index = 0
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.label = 1
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.has_default_value = true
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.default_value = 11
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.type = 14
REPLYSUMMONBOSSFUBENCMD_CMD_FIELD.cpp_type = 8
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.name = "param"
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ReplySummonBossFubenCmd.param"
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.number = 2
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.index = 1
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.label = 1
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.has_default_value = true
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.default_value = 41
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.type = 14
REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD.cpp_type = 8
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.name = "isfull"
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.full_name = ".Cmd.ReplySummonBossFubenCmd.isfull"
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.number = 3
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.index = 2
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.label = 1
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.has_default_value = true
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.default_value = false
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.type = 8
REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD.cpp_type = 7
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.name = "agree"
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.full_name = ".Cmd.ReplySummonBossFubenCmd.agree"
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.number = 4
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.index = 3
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.label = 1
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.has_default_value = true
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.default_value = false
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.type = 8
REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD.cpp_type = 7
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.name = "charid"
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.full_name = ".Cmd.ReplySummonBossFubenCmd.charid"
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.number = 5
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.index = 4
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.label = 1
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.has_default_value = false
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.default_value = 0
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.type = 4
REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD.cpp_type = 4
REPLYSUMMONBOSSFUBENCMD.name = "ReplySummonBossFubenCmd"
REPLYSUMMONBOSSFUBENCMD.full_name = ".Cmd.ReplySummonBossFubenCmd"
REPLYSUMMONBOSSFUBENCMD.nested_types = {}
REPLYSUMMONBOSSFUBENCMD.enum_types = {}
REPLYSUMMONBOSSFUBENCMD.fields = {
  REPLYSUMMONBOSSFUBENCMD_CMD_FIELD,
  REPLYSUMMONBOSSFUBENCMD_PARAM_FIELD,
  REPLYSUMMONBOSSFUBENCMD_ISFULL_FIELD,
  REPLYSUMMONBOSSFUBENCMD_AGREE_FIELD,
  REPLYSUMMONBOSSFUBENCMD_CHARID_FIELD
}
REPLYSUMMONBOSSFUBENCMD.is_extendable = false
REPLYSUMMONBOSSFUBENCMD.extensions = {}
TEAMPWSRAIDUSERINFO_CHARID_FIELD.name = "charid"
TEAMPWSRAIDUSERINFO_CHARID_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.charid"
TEAMPWSRAIDUSERINFO_CHARID_FIELD.number = 1
TEAMPWSRAIDUSERINFO_CHARID_FIELD.index = 0
TEAMPWSRAIDUSERINFO_CHARID_FIELD.label = 1
TEAMPWSRAIDUSERINFO_CHARID_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_CHARID_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_CHARID_FIELD.type = 4
TEAMPWSRAIDUSERINFO_CHARID_FIELD.cpp_type = 4
TEAMPWSRAIDUSERINFO_NAME_FIELD.name = "name"
TEAMPWSRAIDUSERINFO_NAME_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.name"
TEAMPWSRAIDUSERINFO_NAME_FIELD.number = 2
TEAMPWSRAIDUSERINFO_NAME_FIELD.index = 1
TEAMPWSRAIDUSERINFO_NAME_FIELD.label = 1
TEAMPWSRAIDUSERINFO_NAME_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_NAME_FIELD.default_value = ""
TEAMPWSRAIDUSERINFO_NAME_FIELD.type = 9
TEAMPWSRAIDUSERINFO_NAME_FIELD.cpp_type = 9
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.name = "killnum"
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.killnum"
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.number = 3
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.index = 2
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.label = 1
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.type = 13
TEAMPWSRAIDUSERINFO_KILLNUM_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_HEAL_FIELD.name = "heal"
TEAMPWSRAIDUSERINFO_HEAL_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.heal"
TEAMPWSRAIDUSERINFO_HEAL_FIELD.number = 4
TEAMPWSRAIDUSERINFO_HEAL_FIELD.index = 3
TEAMPWSRAIDUSERINFO_HEAL_FIELD.label = 1
TEAMPWSRAIDUSERINFO_HEAL_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_HEAL_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_HEAL_FIELD.type = 13
TEAMPWSRAIDUSERINFO_HEAL_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.name = "killscore"
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.killscore"
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.number = 5
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.index = 4
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.label = 1
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.type = 13
TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.name = "ballscore"
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.ballscore"
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.number = 6
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.index = 5
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.label = 1
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.type = 13
TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.name = "buffscore"
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.buffscore"
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.number = 7
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.index = 6
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.label = 1
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.type = 13
TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.name = "dienum"
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.dienum"
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.number = 8
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.index = 7
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.label = 1
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.type = 13
TEAMPWSRAIDUSERINFO_DIENUM_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.name = "profession"
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.profession"
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.number = 9
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.index = 8
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.label = 1
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.default_value = nil
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.type = 14
TEAMPWSRAIDUSERINFO_PROFESSION_FIELD.cpp_type = 8
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.name = "seasonscore"
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.seasonscore"
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.number = 10
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.index = 9
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.label = 1
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.default_value = 0
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.type = 13
TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD.cpp_type = 3
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.name = "hidename"
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.full_name = ".Cmd.TeamPwsRaidUserInfo.hidename"
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.number = 11
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.index = 10
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.label = 1
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.has_default_value = false
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.default_value = false
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.type = 8
TEAMPWSRAIDUSERINFO_HIDENAME_FIELD.cpp_type = 7
TEAMPWSRAIDUSERINFO.name = "TeamPwsRaidUserInfo"
TEAMPWSRAIDUSERINFO.full_name = ".Cmd.TeamPwsRaidUserInfo"
TEAMPWSRAIDUSERINFO.nested_types = {}
TEAMPWSRAIDUSERINFO.enum_types = {}
TEAMPWSRAIDUSERINFO.fields = {
  TEAMPWSRAIDUSERINFO_CHARID_FIELD,
  TEAMPWSRAIDUSERINFO_NAME_FIELD,
  TEAMPWSRAIDUSERINFO_KILLNUM_FIELD,
  TEAMPWSRAIDUSERINFO_HEAL_FIELD,
  TEAMPWSRAIDUSERINFO_KILLSCORE_FIELD,
  TEAMPWSRAIDUSERINFO_BALLSCORE_FIELD,
  TEAMPWSRAIDUSERINFO_BUFFSCORE_FIELD,
  TEAMPWSRAIDUSERINFO_DIENUM_FIELD,
  TEAMPWSRAIDUSERINFO_PROFESSION_FIELD,
  TEAMPWSRAIDUSERINFO_SEASONSCORE_FIELD,
  TEAMPWSRAIDUSERINFO_HIDENAME_FIELD
}
TEAMPWSRAIDUSERINFO.is_extendable = false
TEAMPWSRAIDUSERINFO.extensions = {}
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.name = "teamid"
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.full_name = ".Cmd.TeamPwsRaidTeamInfo.teamid"
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.number = 1
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.index = 0
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.label = 1
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.has_default_value = false
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.default_value = 0
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.type = 4
TEAMPWSRAIDTEAMINFO_TEAMID_FIELD.cpp_type = 4
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.name = "color"
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.full_name = ".Cmd.TeamPwsRaidTeamInfo.color"
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.number = 2
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.index = 1
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.label = 1
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.has_default_value = false
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.default_value = nil
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.enum_type = ETEAMPWSCOLOR
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.type = 14
TEAMPWSRAIDTEAMINFO_COLOR_FIELD.cpp_type = 8
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.name = "userinfos"
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.full_name = ".Cmd.TeamPwsRaidTeamInfo.userinfos"
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.number = 3
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.index = 2
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.label = 3
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.has_default_value = false
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.default_value = {}
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.message_type = TEAMPWSRAIDUSERINFO
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.type = 11
TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD.cpp_type = 10
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.name = "avescore"
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.full_name = ".Cmd.TeamPwsRaidTeamInfo.avescore"
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.number = 4
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.index = 3
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.label = 1
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.has_default_value = false
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.default_value = 0
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.type = 13
TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD.cpp_type = 3
TEAMPWSRAIDTEAMINFO.name = "TeamPwsRaidTeamInfo"
TEAMPWSRAIDTEAMINFO.full_name = ".Cmd.TeamPwsRaidTeamInfo"
TEAMPWSRAIDTEAMINFO.nested_types = {}
TEAMPWSRAIDTEAMINFO.enum_types = {}
TEAMPWSRAIDTEAMINFO.fields = {
  TEAMPWSRAIDTEAMINFO_TEAMID_FIELD,
  TEAMPWSRAIDTEAMINFO_COLOR_FIELD,
  TEAMPWSRAIDTEAMINFO_USERINFOS_FIELD,
  TEAMPWSRAIDTEAMINFO_AVESCORE_FIELD
}
TEAMPWSRAIDTEAMINFO.is_extendable = false
TEAMPWSRAIDTEAMINFO.extensions = {}
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.name = "cmd"
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.QueryTeamPwsUserInfoFubenCmd.cmd"
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.number = 1
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.index = 0
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.label = 1
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.has_default_value = true
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.default_value = 11
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.type = 14
QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD.cpp_type = 8
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.name = "param"
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.QueryTeamPwsUserInfoFubenCmd.param"
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.number = 2
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.index = 1
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.label = 1
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.has_default_value = true
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.default_value = 42
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.type = 14
QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.QueryTeamPwsUserInfoFubenCmd.teaminfo"
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.number = 3
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.index = 2
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.label = 3
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.has_default_value = false
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.default_value = {}
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.message_type = TEAMPWSRAIDTEAMINFO
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.type = 11
QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
QUERYTEAMPWSUSERINFOFUBENCMD.name = "QueryTeamPwsUserInfoFubenCmd"
QUERYTEAMPWSUSERINFOFUBENCMD.full_name = ".Cmd.QueryTeamPwsUserInfoFubenCmd"
QUERYTEAMPWSUSERINFOFUBENCMD.nested_types = {}
QUERYTEAMPWSUSERINFOFUBENCMD.enum_types = {}
QUERYTEAMPWSUSERINFOFUBENCMD.fields = {
  QUERYTEAMPWSUSERINFOFUBENCMD_CMD_FIELD,
  QUERYTEAMPWSUSERINFOFUBENCMD_PARAM_FIELD,
  QUERYTEAMPWSUSERINFOFUBENCMD_TEAMINFO_FIELD
}
QUERYTEAMPWSUSERINFOFUBENCMD.is_extendable = false
QUERYTEAMPWSUSERINFOFUBENCMD.extensions = {}
TEAMPWSREPORTFUBENCMD_CMD_FIELD.name = "cmd"
TEAMPWSREPORTFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamPwsReportFubenCmd.cmd"
TEAMPWSREPORTFUBENCMD_CMD_FIELD.number = 1
TEAMPWSREPORTFUBENCMD_CMD_FIELD.index = 0
TEAMPWSREPORTFUBENCMD_CMD_FIELD.label = 1
TEAMPWSREPORTFUBENCMD_CMD_FIELD.has_default_value = true
TEAMPWSREPORTFUBENCMD_CMD_FIELD.default_value = 11
TEAMPWSREPORTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMPWSREPORTFUBENCMD_CMD_FIELD.type = 14
TEAMPWSREPORTFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.name = "param"
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamPwsReportFubenCmd.param"
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.number = 2
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.index = 1
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.label = 1
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.default_value = 43
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.type = 14
TEAMPWSREPORTFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.TeamPwsReportFubenCmd.teaminfo"
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.number = 3
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.index = 2
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.label = 3
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.has_default_value = false
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.default_value = {}
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.message_type = TEAMPWSRAIDTEAMINFO
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.type = 11
TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.name = "mvpuserinfo"
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.full_name = ".Cmd.TeamPwsReportFubenCmd.mvpuserinfo"
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.number = 4
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.index = 3
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.label = 1
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.has_default_value = false
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.default_value = nil
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.type = 11
TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD.cpp_type = 10
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.name = "winteam"
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.full_name = ".Cmd.TeamPwsReportFubenCmd.winteam"
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.number = 5
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.index = 4
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.label = 2
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.has_default_value = false
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.default_value = nil
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.enum_type = ETEAMPWSCOLOR
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.type = 14
TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD.cpp_type = 8
TEAMPWSREPORTFUBENCMD.name = "TeamPwsReportFubenCmd"
TEAMPWSREPORTFUBENCMD.full_name = ".Cmd.TeamPwsReportFubenCmd"
TEAMPWSREPORTFUBENCMD.nested_types = {}
TEAMPWSREPORTFUBENCMD.enum_types = {}
TEAMPWSREPORTFUBENCMD.fields = {
  TEAMPWSREPORTFUBENCMD_CMD_FIELD,
  TEAMPWSREPORTFUBENCMD_PARAM_FIELD,
  TEAMPWSREPORTFUBENCMD_TEAMINFO_FIELD,
  TEAMPWSREPORTFUBENCMD_MVPUSERINFO_FIELD,
  TEAMPWSREPORTFUBENCMD_WINTEAM_FIELD
}
TEAMPWSREPORTFUBENCMD.is_extendable = false
TEAMPWSREPORTFUBENCMD.extensions = {}
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.name = "teamid"
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.teamid"
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.number = 1
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.index = 0
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.label = 1
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.has_default_value = false
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.default_value = 0
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.type = 4
TEAMPWSINFOSYNCDATA_TEAMID_FIELD.cpp_type = 4
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.name = "teamname"
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.teamname"
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.number = 2
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.index = 1
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.label = 1
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.has_default_value = false
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.default_value = ""
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.type = 9
TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD.cpp_type = 9
TEAMPWSINFOSYNCDATA_COLOR_FIELD.name = "color"
TEAMPWSINFOSYNCDATA_COLOR_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.color"
TEAMPWSINFOSYNCDATA_COLOR_FIELD.number = 3
TEAMPWSINFOSYNCDATA_COLOR_FIELD.index = 2
TEAMPWSINFOSYNCDATA_COLOR_FIELD.label = 1
TEAMPWSINFOSYNCDATA_COLOR_FIELD.has_default_value = false
TEAMPWSINFOSYNCDATA_COLOR_FIELD.default_value = nil
TEAMPWSINFOSYNCDATA_COLOR_FIELD.enum_type = ETEAMPWSCOLOR
TEAMPWSINFOSYNCDATA_COLOR_FIELD.type = 14
TEAMPWSINFOSYNCDATA_COLOR_FIELD.cpp_type = 8
TEAMPWSINFOSYNCDATA_SCORE_FIELD.name = "score"
TEAMPWSINFOSYNCDATA_SCORE_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.score"
TEAMPWSINFOSYNCDATA_SCORE_FIELD.number = 4
TEAMPWSINFOSYNCDATA_SCORE_FIELD.index = 3
TEAMPWSINFOSYNCDATA_SCORE_FIELD.label = 1
TEAMPWSINFOSYNCDATA_SCORE_FIELD.has_default_value = true
TEAMPWSINFOSYNCDATA_SCORE_FIELD.default_value = 0
TEAMPWSINFOSYNCDATA_SCORE_FIELD.type = 13
TEAMPWSINFOSYNCDATA_SCORE_FIELD.cpp_type = 3
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.name = "effectcd"
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.effectcd"
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.number = 5
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.index = 4
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.label = 1
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.has_default_value = true
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.default_value = 0
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.type = 13
TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD.cpp_type = 3
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.name = "magicid"
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.magicid"
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.number = 6
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.index = 5
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.label = 1
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.has_default_value = true
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.default_value = 0
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.type = 13
TEAMPWSINFOSYNCDATA_MAGICID_FIELD.cpp_type = 3
TEAMPWSINFOSYNCDATA_BALLS_FIELD.name = "balls"
TEAMPWSINFOSYNCDATA_BALLS_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.balls"
TEAMPWSINFOSYNCDATA_BALLS_FIELD.number = 7
TEAMPWSINFOSYNCDATA_BALLS_FIELD.index = 6
TEAMPWSINFOSYNCDATA_BALLS_FIELD.label = 3
TEAMPWSINFOSYNCDATA_BALLS_FIELD.has_default_value = false
TEAMPWSINFOSYNCDATA_BALLS_FIELD.default_value = {}
TEAMPWSINFOSYNCDATA_BALLS_FIELD.enum_type = EMAGICBALLTYPE
TEAMPWSINFOSYNCDATA_BALLS_FIELD.type = 14
TEAMPWSINFOSYNCDATA_BALLS_FIELD.cpp_type = 8
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.name = "warband_name"
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.full_name = ".Cmd.TeamPwsInfoSyncData.warband_name"
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.number = 8
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.index = 7
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.label = 1
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.has_default_value = false
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.default_value = ""
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.type = 9
TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD.cpp_type = 9
TEAMPWSINFOSYNCDATA.name = "TeamPwsInfoSyncData"
TEAMPWSINFOSYNCDATA.full_name = ".Cmd.TeamPwsInfoSyncData"
TEAMPWSINFOSYNCDATA.nested_types = {}
TEAMPWSINFOSYNCDATA.enum_types = {}
TEAMPWSINFOSYNCDATA.fields = {
  TEAMPWSINFOSYNCDATA_TEAMID_FIELD,
  TEAMPWSINFOSYNCDATA_TEAMNAME_FIELD,
  TEAMPWSINFOSYNCDATA_COLOR_FIELD,
  TEAMPWSINFOSYNCDATA_SCORE_FIELD,
  TEAMPWSINFOSYNCDATA_EFFECTCD_FIELD,
  TEAMPWSINFOSYNCDATA_MAGICID_FIELD,
  TEAMPWSINFOSYNCDATA_BALLS_FIELD,
  TEAMPWSINFOSYNCDATA_WARBAND_NAME_FIELD
}
TEAMPWSINFOSYNCDATA.is_extendable = false
TEAMPWSINFOSYNCDATA.extensions = {}
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.name = "cmd"
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd.cmd"
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.number = 1
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.index = 0
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.label = 1
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.has_default_value = true
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.default_value = 11
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.type = 14
TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.name = "param"
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd.param"
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.number = 2
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.index = 1
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.label = 1
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.default_value = 44
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.type = 14
TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd.teaminfo"
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.number = 3
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.index = 2
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.label = 3
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.has_default_value = false
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.default_value = {}
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.message_type = TEAMPWSINFOSYNCDATA
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.type = 11
TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.name = "endtime"
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd.endtime"
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.number = 4
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.index = 3
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.label = 1
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.has_default_value = false
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.default_value = 0
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.type = 13
TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD.cpp_type = 3
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.name = "fullfire"
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd.fullfire"
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.number = 5
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.index = 4
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.label = 1
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.has_default_value = false
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.default_value = false
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.type = 8
TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD.cpp_type = 7
TEAMPWSINFOSYNCFUBENCMD.name = "TeamPwsInfoSyncFubenCmd"
TEAMPWSINFOSYNCFUBENCMD.full_name = ".Cmd.TeamPwsInfoSyncFubenCmd"
TEAMPWSINFOSYNCFUBENCMD.nested_types = {}
TEAMPWSINFOSYNCFUBENCMD.enum_types = {}
TEAMPWSINFOSYNCFUBENCMD.fields = {
  TEAMPWSINFOSYNCFUBENCMD_CMD_FIELD,
  TEAMPWSINFOSYNCFUBENCMD_PARAM_FIELD,
  TEAMPWSINFOSYNCFUBENCMD_TEAMINFO_FIELD,
  TEAMPWSINFOSYNCFUBENCMD_ENDTIME_FIELD,
  TEAMPWSINFOSYNCFUBENCMD_FULLFIRE_FIELD
}
TEAMPWSINFOSYNCFUBENCMD.is_extendable = false
TEAMPWSINFOSYNCFUBENCMD.extensions = {}
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.name = "cmd"
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.UpdateTeamPwsInfoFubenCmd.cmd"
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.number = 1
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.index = 0
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.label = 1
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.has_default_value = true
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.default_value = 11
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.type = 14
UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD.cpp_type = 8
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.name = "param"
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.UpdateTeamPwsInfoFubenCmd.param"
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.number = 2
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.index = 1
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.label = 1
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.has_default_value = true
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.default_value = 47
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.type = 14
UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.UpdateTeamPwsInfoFubenCmd.teaminfo"
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.number = 3
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.index = 2
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.label = 3
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.has_default_value = false
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.default_value = {}
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.message_type = TEAMPWSINFOSYNCDATA
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.type = 11
UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
UPDATETEAMPWSINFOFUBENCMD.name = "UpdateTeamPwsInfoFubenCmd"
UPDATETEAMPWSINFOFUBENCMD.full_name = ".Cmd.UpdateTeamPwsInfoFubenCmd"
UPDATETEAMPWSINFOFUBENCMD.nested_types = {}
UPDATETEAMPWSINFOFUBENCMD.enum_types = {}
UPDATETEAMPWSINFOFUBENCMD.fields = {
  UPDATETEAMPWSINFOFUBENCMD_CMD_FIELD,
  UPDATETEAMPWSINFOFUBENCMD_PARAM_FIELD,
  UPDATETEAMPWSINFOFUBENCMD_TEAMINFO_FIELD
}
UPDATETEAMPWSINFOFUBENCMD.is_extendable = false
UPDATETEAMPWSINFOFUBENCMD.extensions = {}
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.name = "cmd"
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.full_name = ".Cmd.SelectTeamPwsMagicFubenCmd.cmd"
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.number = 1
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.index = 0
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.label = 1
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.has_default_value = true
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.default_value = 11
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.type = 14
SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD.cpp_type = 8
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.name = "param"
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SelectTeamPwsMagicFubenCmd.param"
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.number = 2
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.index = 1
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.label = 1
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.has_default_value = true
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.default_value = 45
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.type = 14
SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD.cpp_type = 8
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.name = "magicid"
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.full_name = ".Cmd.SelectTeamPwsMagicFubenCmd.magicid"
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.number = 3
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.index = 2
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.label = 2
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.has_default_value = false
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.default_value = 0
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.type = 13
SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD.cpp_type = 3
SELECTTEAMPWSMAGICFUBENCMD.name = "SelectTeamPwsMagicFubenCmd"
SELECTTEAMPWSMAGICFUBENCMD.full_name = ".Cmd.SelectTeamPwsMagicFubenCmd"
SELECTTEAMPWSMAGICFUBENCMD.nested_types = {}
SELECTTEAMPWSMAGICFUBENCMD.enum_types = {}
SELECTTEAMPWSMAGICFUBENCMD.fields = {
  SELECTTEAMPWSMAGICFUBENCMD_CMD_FIELD,
  SELECTTEAMPWSMAGICFUBENCMD_PARAM_FIELD,
  SELECTTEAMPWSMAGICFUBENCMD_MAGICID_FIELD
}
SELECTTEAMPWSMAGICFUBENCMD.is_extendable = false
SELECTTEAMPWSMAGICFUBENCMD.extensions = {}
EXITMAPFUBENCMD_CMD_FIELD.name = "cmd"
EXITMAPFUBENCMD_CMD_FIELD.full_name = ".Cmd.ExitMapFubenCmd.cmd"
EXITMAPFUBENCMD_CMD_FIELD.number = 1
EXITMAPFUBENCMD_CMD_FIELD.index = 0
EXITMAPFUBENCMD_CMD_FIELD.label = 1
EXITMAPFUBENCMD_CMD_FIELD.has_default_value = true
EXITMAPFUBENCMD_CMD_FIELD.default_value = 11
EXITMAPFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EXITMAPFUBENCMD_CMD_FIELD.type = 14
EXITMAPFUBENCMD_CMD_FIELD.cpp_type = 8
EXITMAPFUBENCMD_PARAM_FIELD.name = "param"
EXITMAPFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ExitMapFubenCmd.param"
EXITMAPFUBENCMD_PARAM_FIELD.number = 2
EXITMAPFUBENCMD_PARAM_FIELD.index = 1
EXITMAPFUBENCMD_PARAM_FIELD.label = 1
EXITMAPFUBENCMD_PARAM_FIELD.has_default_value = true
EXITMAPFUBENCMD_PARAM_FIELD.default_value = 48
EXITMAPFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
EXITMAPFUBENCMD_PARAM_FIELD.type = 14
EXITMAPFUBENCMD_PARAM_FIELD.cpp_type = 8
EXITMAPFUBENCMD.name = "ExitMapFubenCmd"
EXITMAPFUBENCMD.full_name = ".Cmd.ExitMapFubenCmd"
EXITMAPFUBENCMD.nested_types = {}
EXITMAPFUBENCMD.enum_types = {}
EXITMAPFUBENCMD.fields = {
  EXITMAPFUBENCMD_CMD_FIELD,
  EXITMAPFUBENCMD_PARAM_FIELD
}
EXITMAPFUBENCMD.is_extendable = false
EXITMAPFUBENCMD.extensions = {}
BEGINFIREFUBENCMD_CMD_FIELD.name = "cmd"
BEGINFIREFUBENCMD_CMD_FIELD.full_name = ".Cmd.BeginFireFubenCmd.cmd"
BEGINFIREFUBENCMD_CMD_FIELD.number = 1
BEGINFIREFUBENCMD_CMD_FIELD.index = 0
BEGINFIREFUBENCMD_CMD_FIELD.label = 1
BEGINFIREFUBENCMD_CMD_FIELD.has_default_value = true
BEGINFIREFUBENCMD_CMD_FIELD.default_value = 11
BEGINFIREFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BEGINFIREFUBENCMD_CMD_FIELD.type = 14
BEGINFIREFUBENCMD_CMD_FIELD.cpp_type = 8
BEGINFIREFUBENCMD_PARAM_FIELD.name = "param"
BEGINFIREFUBENCMD_PARAM_FIELD.full_name = ".Cmd.BeginFireFubenCmd.param"
BEGINFIREFUBENCMD_PARAM_FIELD.number = 2
BEGINFIREFUBENCMD_PARAM_FIELD.index = 1
BEGINFIREFUBENCMD_PARAM_FIELD.label = 1
BEGINFIREFUBENCMD_PARAM_FIELD.has_default_value = true
BEGINFIREFUBENCMD_PARAM_FIELD.default_value = 49
BEGINFIREFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
BEGINFIREFUBENCMD_PARAM_FIELD.type = 14
BEGINFIREFUBENCMD_PARAM_FIELD.cpp_type = 8
BEGINFIREFUBENCMD.name = "BeginFireFubenCmd"
BEGINFIREFUBENCMD.full_name = ".Cmd.BeginFireFubenCmd"
BEGINFIREFUBENCMD.nested_types = {}
BEGINFIREFUBENCMD.enum_types = {}
BEGINFIREFUBENCMD.fields = {
  BEGINFIREFUBENCMD_CMD_FIELD,
  BEGINFIREFUBENCMD_PARAM_FIELD
}
BEGINFIREFUBENCMD.is_extendable = false
BEGINFIREFUBENCMD.extensions = {}
TEAMEXPREPORTFUBENCMD_CMD_FIELD.name = "cmd"
TEAMEXPREPORTFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.cmd"
TEAMEXPREPORTFUBENCMD_CMD_FIELD.number = 1
TEAMEXPREPORTFUBENCMD_CMD_FIELD.index = 0
TEAMEXPREPORTFUBENCMD_CMD_FIELD.label = 1
TEAMEXPREPORTFUBENCMD_CMD_FIELD.has_default_value = true
TEAMEXPREPORTFUBENCMD_CMD_FIELD.default_value = 11
TEAMEXPREPORTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMEXPREPORTFUBENCMD_CMD_FIELD.type = 14
TEAMEXPREPORTFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.name = "param"
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.param"
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.number = 2
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.index = 1
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.label = 1
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.default_value = 50
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.type = 14
TEAMEXPREPORTFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.name = "baseexp"
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.baseexp"
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.number = 3
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.index = 2
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.label = 1
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.has_default_value = false
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.default_value = 0
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.type = 13
TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD.cpp_type = 3
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.name = "jobexp"
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.jobexp"
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.number = 4
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.index = 3
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.label = 1
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.has_default_value = false
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.default_value = 0
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.type = 13
TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD.cpp_type = 3
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.name = "items"
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.items"
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.number = 5
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.index = 4
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.label = 3
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.has_default_value = false
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.default_value = {}
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.message_type = SceneItem_pb.ITEMINFO
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.type = 11
TEAMEXPREPORTFUBENCMD_ITEMS_FIELD.cpp_type = 10
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.name = "closetime"
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.full_name = ".Cmd.TeamExpReportFubenCmd.closetime"
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.number = 6
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.index = 5
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.label = 1
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.has_default_value = false
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.default_value = 0
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.type = 13
TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD.cpp_type = 3
TEAMEXPREPORTFUBENCMD.name = "TeamExpReportFubenCmd"
TEAMEXPREPORTFUBENCMD.full_name = ".Cmd.TeamExpReportFubenCmd"
TEAMEXPREPORTFUBENCMD.nested_types = {}
TEAMEXPREPORTFUBENCMD.enum_types = {}
TEAMEXPREPORTFUBENCMD.fields = {
  TEAMEXPREPORTFUBENCMD_CMD_FIELD,
  TEAMEXPREPORTFUBENCMD_PARAM_FIELD,
  TEAMEXPREPORTFUBENCMD_BASEEXP_FIELD,
  TEAMEXPREPORTFUBENCMD_JOBEXP_FIELD,
  TEAMEXPREPORTFUBENCMD_ITEMS_FIELD,
  TEAMEXPREPORTFUBENCMD_CLOSETIME_FIELD
}
TEAMEXPREPORTFUBENCMD.is_extendable = false
TEAMEXPREPORTFUBENCMD.extensions = {}
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.name = "cmd"
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.full_name = ".Cmd.BuyExpRaidItemFubenCmd.cmd"
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.number = 1
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.index = 0
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.label = 1
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.has_default_value = true
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.default_value = 11
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.type = 14
BUYEXPRAIDITEMFUBENCMD_CMD_FIELD.cpp_type = 8
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.name = "param"
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.full_name = ".Cmd.BuyExpRaidItemFubenCmd.param"
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.number = 2
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.index = 1
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.label = 1
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.has_default_value = true
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.default_value = 51
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.type = 14
BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD.cpp_type = 8
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.name = "itemid"
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.full_name = ".Cmd.BuyExpRaidItemFubenCmd.itemid"
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.number = 3
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.index = 2
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.label = 1
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.has_default_value = false
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.default_value = 0
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.type = 13
BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD.cpp_type = 3
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.name = "num"
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.full_name = ".Cmd.BuyExpRaidItemFubenCmd.num"
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.number = 4
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.index = 3
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.label = 1
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.has_default_value = false
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.default_value = 0
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.type = 13
BUYEXPRAIDITEMFUBENCMD_NUM_FIELD.cpp_type = 3
BUYEXPRAIDITEMFUBENCMD.name = "BuyExpRaidItemFubenCmd"
BUYEXPRAIDITEMFUBENCMD.full_name = ".Cmd.BuyExpRaidItemFubenCmd"
BUYEXPRAIDITEMFUBENCMD.nested_types = {}
BUYEXPRAIDITEMFUBENCMD.enum_types = {}
BUYEXPRAIDITEMFUBENCMD.fields = {
  BUYEXPRAIDITEMFUBENCMD_CMD_FIELD,
  BUYEXPRAIDITEMFUBENCMD_PARAM_FIELD,
  BUYEXPRAIDITEMFUBENCMD_ITEMID_FIELD,
  BUYEXPRAIDITEMFUBENCMD_NUM_FIELD
}
BUYEXPRAIDITEMFUBENCMD.is_extendable = false
BUYEXPRAIDITEMFUBENCMD.extensions = {}
TEAMEXPSYNCFUBENCMD_CMD_FIELD.name = "cmd"
TEAMEXPSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamExpSyncFubenCmd.cmd"
TEAMEXPSYNCFUBENCMD_CMD_FIELD.number = 1
TEAMEXPSYNCFUBENCMD_CMD_FIELD.index = 0
TEAMEXPSYNCFUBENCMD_CMD_FIELD.label = 1
TEAMEXPSYNCFUBENCMD_CMD_FIELD.has_default_value = true
TEAMEXPSYNCFUBENCMD_CMD_FIELD.default_value = 11
TEAMEXPSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMEXPSYNCFUBENCMD_CMD_FIELD.type = 14
TEAMEXPSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.name = "param"
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamExpSyncFubenCmd.param"
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.number = 2
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.index = 1
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.label = 1
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.default_value = 52
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.type = 14
TEAMEXPSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.name = "endtime"
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.TeamExpSyncFubenCmd.endtime"
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.number = 3
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.index = 2
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.label = 1
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.has_default_value = true
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.default_value = 0
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.type = 13
TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD.cpp_type = 3
TEAMEXPSYNCFUBENCMD.name = "TeamExpSyncFubenCmd"
TEAMEXPSYNCFUBENCMD.full_name = ".Cmd.TeamExpSyncFubenCmd"
TEAMEXPSYNCFUBENCMD.nested_types = {}
TEAMEXPSYNCFUBENCMD.enum_types = {}
TEAMEXPSYNCFUBENCMD.fields = {
  TEAMEXPSYNCFUBENCMD_CMD_FIELD,
  TEAMEXPSYNCFUBENCMD_PARAM_FIELD,
  TEAMEXPSYNCFUBENCMD_ENDTIME_FIELD
}
TEAMEXPSYNCFUBENCMD.is_extendable = false
TEAMEXPSYNCFUBENCMD.extensions = {}
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.name = "cmd"
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamReliveCountFubenCmd.cmd"
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.number = 1
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.index = 0
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.label = 1
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.has_default_value = true
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.default_value = 11
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.type = 14
TEAMRELIVECOUNTFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.name = "param"
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamReliveCountFubenCmd.param"
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.number = 2
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.index = 1
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.label = 1
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.default_value = 53
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.type = 14
TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.name = "count"
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.full_name = ".Cmd.TeamReliveCountFubenCmd.count"
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.number = 3
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.index = 2
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.label = 1
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.has_default_value = true
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.default_value = 0
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.type = 13
TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD.cpp_type = 3
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.name = "maxcount"
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.full_name = ".Cmd.TeamReliveCountFubenCmd.maxcount"
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.number = 4
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.index = 3
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.label = 1
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.has_default_value = false
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.default_value = 0
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.type = 13
TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD.cpp_type = 3
TEAMRELIVECOUNTFUBENCMD.name = "TeamReliveCountFubenCmd"
TEAMRELIVECOUNTFUBENCMD.full_name = ".Cmd.TeamReliveCountFubenCmd"
TEAMRELIVECOUNTFUBENCMD.nested_types = {}
TEAMRELIVECOUNTFUBENCMD.enum_types = {}
TEAMRELIVECOUNTFUBENCMD.fields = {
  TEAMRELIVECOUNTFUBENCMD_CMD_FIELD,
  TEAMRELIVECOUNTFUBENCMD_PARAM_FIELD,
  TEAMRELIVECOUNTFUBENCMD_COUNT_FIELD,
  TEAMRELIVECOUNTFUBENCMD_MAXCOUNT_FIELD
}
TEAMRELIVECOUNTFUBENCMD.is_extendable = false
TEAMRELIVECOUNTFUBENCMD.extensions = {}
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.name = "cmd"
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.full_name = ".Cmd.TeamGroupRaidUpdateChipNum.cmd"
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.number = 1
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.index = 0
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.label = 1
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.has_default_value = true
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.default_value = 11
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.type = 14
TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD.cpp_type = 8
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.name = "param"
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.full_name = ".Cmd.TeamGroupRaidUpdateChipNum.param"
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.number = 2
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.index = 1
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.label = 1
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.has_default_value = true
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.default_value = 54
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.enum_type = FUBENPARAM
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.type = 14
TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD.cpp_type = 8
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.name = "chipnum"
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.full_name = ".Cmd.TeamGroupRaidUpdateChipNum.chipnum"
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.number = 3
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.index = 2
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.label = 1
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.has_default_value = true
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.default_value = 0
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.type = 13
TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD.cpp_type = 3
TEAMGROUPRAIDUPDATECHIPNUM.name = "TeamGroupRaidUpdateChipNum"
TEAMGROUPRAIDUPDATECHIPNUM.full_name = ".Cmd.TeamGroupRaidUpdateChipNum"
TEAMGROUPRAIDUPDATECHIPNUM.nested_types = {}
TEAMGROUPRAIDUPDATECHIPNUM.enum_types = {}
TEAMGROUPRAIDUPDATECHIPNUM.fields = {
  TEAMGROUPRAIDUPDATECHIPNUM_CMD_FIELD,
  TEAMGROUPRAIDUPDATECHIPNUM_PARAM_FIELD,
  TEAMGROUPRAIDUPDATECHIPNUM_CHIPNUM_FIELD
}
TEAMGROUPRAIDUPDATECHIPNUM.is_extendable = false
TEAMGROUPRAIDUPDATECHIPNUM.extensions = {}
GROUPRAIDSHOWDATA_CHARID_FIELD.name = "charid"
GROUPRAIDSHOWDATA_CHARID_FIELD.full_name = ".Cmd.GroupRaidShowData.charid"
GROUPRAIDSHOWDATA_CHARID_FIELD.number = 1
GROUPRAIDSHOWDATA_CHARID_FIELD.index = 0
GROUPRAIDSHOWDATA_CHARID_FIELD.label = 1
GROUPRAIDSHOWDATA_CHARID_FIELD.has_default_value = false
GROUPRAIDSHOWDATA_CHARID_FIELD.default_value = 0
GROUPRAIDSHOWDATA_CHARID_FIELD.type = 4
GROUPRAIDSHOWDATA_CHARID_FIELD.cpp_type = 4
GROUPRAIDSHOWDATA_PROFESSION_FIELD.name = "profession"
GROUPRAIDSHOWDATA_PROFESSION_FIELD.full_name = ".Cmd.GroupRaidShowData.profession"
GROUPRAIDSHOWDATA_PROFESSION_FIELD.number = 2
GROUPRAIDSHOWDATA_PROFESSION_FIELD.index = 1
GROUPRAIDSHOWDATA_PROFESSION_FIELD.label = 1
GROUPRAIDSHOWDATA_PROFESSION_FIELD.has_default_value = false
GROUPRAIDSHOWDATA_PROFESSION_FIELD.default_value = 0
GROUPRAIDSHOWDATA_PROFESSION_FIELD.type = 13
GROUPRAIDSHOWDATA_PROFESSION_FIELD.cpp_type = 3
GROUPRAIDSHOWDATA_NAME_FIELD.name = "name"
GROUPRAIDSHOWDATA_NAME_FIELD.full_name = ".Cmd.GroupRaidShowData.name"
GROUPRAIDSHOWDATA_NAME_FIELD.number = 3
GROUPRAIDSHOWDATA_NAME_FIELD.index = 2
GROUPRAIDSHOWDATA_NAME_FIELD.label = 1
GROUPRAIDSHOWDATA_NAME_FIELD.has_default_value = false
GROUPRAIDSHOWDATA_NAME_FIELD.default_value = ""
GROUPRAIDSHOWDATA_NAME_FIELD.type = 9
GROUPRAIDSHOWDATA_NAME_FIELD.cpp_type = 9
GROUPRAIDSHOWDATA_DAMAGE_FIELD.name = "damage"
GROUPRAIDSHOWDATA_DAMAGE_FIELD.full_name = ".Cmd.GroupRaidShowData.damage"
GROUPRAIDSHOWDATA_DAMAGE_FIELD.number = 4
GROUPRAIDSHOWDATA_DAMAGE_FIELD.index = 3
GROUPRAIDSHOWDATA_DAMAGE_FIELD.label = 1
GROUPRAIDSHOWDATA_DAMAGE_FIELD.has_default_value = true
GROUPRAIDSHOWDATA_DAMAGE_FIELD.default_value = 0
GROUPRAIDSHOWDATA_DAMAGE_FIELD.type = 4
GROUPRAIDSHOWDATA_DAMAGE_FIELD.cpp_type = 4
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.name = "bedamage"
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.full_name = ".Cmd.GroupRaidShowData.bedamage"
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.number = 5
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.index = 4
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.label = 1
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.has_default_value = true
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.default_value = 0
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.type = 4
GROUPRAIDSHOWDATA_BEDAMAGE_FIELD.cpp_type = 4
GROUPRAIDSHOWDATA_HEAL_FIELD.name = "heal"
GROUPRAIDSHOWDATA_HEAL_FIELD.full_name = ".Cmd.GroupRaidShowData.heal"
GROUPRAIDSHOWDATA_HEAL_FIELD.number = 6
GROUPRAIDSHOWDATA_HEAL_FIELD.index = 5
GROUPRAIDSHOWDATA_HEAL_FIELD.label = 1
GROUPRAIDSHOWDATA_HEAL_FIELD.has_default_value = true
GROUPRAIDSHOWDATA_HEAL_FIELD.default_value = 0
GROUPRAIDSHOWDATA_HEAL_FIELD.type = 4
GROUPRAIDSHOWDATA_HEAL_FIELD.cpp_type = 4
GROUPRAIDSHOWDATA_DIENUM_FIELD.name = "dienum"
GROUPRAIDSHOWDATA_DIENUM_FIELD.full_name = ".Cmd.GroupRaidShowData.dienum"
GROUPRAIDSHOWDATA_DIENUM_FIELD.number = 7
GROUPRAIDSHOWDATA_DIENUM_FIELD.index = 6
GROUPRAIDSHOWDATA_DIENUM_FIELD.label = 1
GROUPRAIDSHOWDATA_DIENUM_FIELD.has_default_value = true
GROUPRAIDSHOWDATA_DIENUM_FIELD.default_value = 0
GROUPRAIDSHOWDATA_DIENUM_FIELD.type = 13
GROUPRAIDSHOWDATA_DIENUM_FIELD.cpp_type = 3
GROUPRAIDSHOWDATA_HATETIME_FIELD.name = "hatetime"
GROUPRAIDSHOWDATA_HATETIME_FIELD.full_name = ".Cmd.GroupRaidShowData.hatetime"
GROUPRAIDSHOWDATA_HATETIME_FIELD.number = 8
GROUPRAIDSHOWDATA_HATETIME_FIELD.index = 7
GROUPRAIDSHOWDATA_HATETIME_FIELD.label = 1
GROUPRAIDSHOWDATA_HATETIME_FIELD.has_default_value = false
GROUPRAIDSHOWDATA_HATETIME_FIELD.default_value = 0
GROUPRAIDSHOWDATA_HATETIME_FIELD.type = 13
GROUPRAIDSHOWDATA_HATETIME_FIELD.cpp_type = 3
GROUPRAIDSHOWDATA.name = "GroupRaidShowData"
GROUPRAIDSHOWDATA.full_name = ".Cmd.GroupRaidShowData"
GROUPRAIDSHOWDATA.nested_types = {}
GROUPRAIDSHOWDATA.enum_types = {}
GROUPRAIDSHOWDATA.fields = {
  GROUPRAIDSHOWDATA_CHARID_FIELD,
  GROUPRAIDSHOWDATA_PROFESSION_FIELD,
  GROUPRAIDSHOWDATA_NAME_FIELD,
  GROUPRAIDSHOWDATA_DAMAGE_FIELD,
  GROUPRAIDSHOWDATA_BEDAMAGE_FIELD,
  GROUPRAIDSHOWDATA_HEAL_FIELD,
  GROUPRAIDSHOWDATA_DIENUM_FIELD,
  GROUPRAIDSHOWDATA_HATETIME_FIELD
}
GROUPRAIDSHOWDATA.is_extendable = false
GROUPRAIDSHOWDATA.extensions = {}
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.name = "raidid"
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.full_name = ".Cmd.GroupRaidTeamShowData.raidid"
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.number = 1
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.index = 0
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.label = 1
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.has_default_value = true
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.default_value = 0
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.type = 13
GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD.cpp_type = 3
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.name = "datas"
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.full_name = ".Cmd.GroupRaidTeamShowData.datas"
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.number = 2
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.index = 1
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.label = 3
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.has_default_value = false
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.default_value = {}
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.message_type = GROUPRAIDSHOWDATA
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.type = 11
GROUPRAIDTEAMSHOWDATA_DATAS_FIELD.cpp_type = 10
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.name = "boss_index"
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.full_name = ".Cmd.GroupRaidTeamShowData.boss_index"
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.number = 3
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.index = 2
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.label = 1
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.has_default_value = false
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.default_value = 0
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.type = 13
GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD.cpp_type = 3
GROUPRAIDTEAMSHOWDATA.name = "GroupRaidTeamShowData"
GROUPRAIDTEAMSHOWDATA.full_name = ".Cmd.GroupRaidTeamShowData"
GROUPRAIDTEAMSHOWDATA.nested_types = {}
GROUPRAIDTEAMSHOWDATA.enum_types = {}
GROUPRAIDTEAMSHOWDATA.fields = {
  GROUPRAIDTEAMSHOWDATA_RAIDID_FIELD,
  GROUPRAIDTEAMSHOWDATA_DATAS_FIELD,
  GROUPRAIDTEAMSHOWDATA_BOSS_INDEX_FIELD
}
GROUPRAIDTEAMSHOWDATA.is_extendable = false
GROUPRAIDTEAMSHOWDATA.extensions = {}
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.name = "cmd"
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.full_name = ".Cmd.QueryTeamGroupRaidUserInfo.cmd"
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.number = 1
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.index = 0
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.label = 1
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.has_default_value = true
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.default_value = 11
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.type = 14
QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD.cpp_type = 8
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.name = "param"
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.full_name = ".Cmd.QueryTeamGroupRaidUserInfo.param"
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.number = 2
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.index = 1
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.label = 1
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.has_default_value = true
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.default_value = 55
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.enum_type = FUBENPARAM
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.type = 14
QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD.cpp_type = 8
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.name = "current"
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.full_name = ".Cmd.QueryTeamGroupRaidUserInfo.current"
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.number = 3
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.index = 2
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.label = 1
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.has_default_value = false
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.default_value = nil
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.type = 11
QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD.cpp_type = 10
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.name = "history"
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.full_name = ".Cmd.QueryTeamGroupRaidUserInfo.history"
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.number = 4
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.index = 3
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.label = 3
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.has_default_value = false
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.default_value = {}
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.type = 11
QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD.cpp_type = 10
QUERYTEAMGROUPRAIDUSERINFO.name = "QueryTeamGroupRaidUserInfo"
QUERYTEAMGROUPRAIDUSERINFO.full_name = ".Cmd.QueryTeamGroupRaidUserInfo"
QUERYTEAMGROUPRAIDUSERINFO.nested_types = {}
QUERYTEAMGROUPRAIDUSERINFO.enum_types = {}
QUERYTEAMGROUPRAIDUSERINFO.fields = {
  QUERYTEAMGROUPRAIDUSERINFO_CMD_FIELD,
  QUERYTEAMGROUPRAIDUSERINFO_PARAM_FIELD,
  QUERYTEAMGROUPRAIDUSERINFO_CURRENT_FIELD,
  QUERYTEAMGROUPRAIDUSERINFO_HISTORY_FIELD
}
QUERYTEAMGROUPRAIDUSERINFO.is_extendable = false
QUERYTEAMGROUPRAIDUSERINFO.extensions = {}
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.name = "cmd"
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.GroupRaidStateSyncFuBenCmd.cmd"
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.number = 1
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.index = 0
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.label = 1
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.has_default_value = true
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.default_value = 11
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.type = 14
GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD.cpp_type = 8
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.name = "param"
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GroupRaidStateSyncFuBenCmd.param"
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.number = 2
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.index = 1
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.label = 1
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.has_default_value = true
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.default_value = 57
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.type = 14
GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.name = "state"
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.full_name = ".Cmd.GroupRaidStateSyncFuBenCmd.state"
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.number = 3
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.index = 2
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.label = 1
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.has_default_value = true
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.default_value = 0
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.enum_type = EGROUPRAIDSCENESTATE
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.type = 14
GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD.cpp_type = 8
GROUPRAIDSTATESYNCFUBENCMD.name = "GroupRaidStateSyncFuBenCmd"
GROUPRAIDSTATESYNCFUBENCMD.full_name = ".Cmd.GroupRaidStateSyncFuBenCmd"
GROUPRAIDSTATESYNCFUBENCMD.nested_types = {}
GROUPRAIDSTATESYNCFUBENCMD.enum_types = {}
GROUPRAIDSTATESYNCFUBENCMD.fields = {
  GROUPRAIDSTATESYNCFUBENCMD_CMD_FIELD,
  GROUPRAIDSTATESYNCFUBENCMD_PARAM_FIELD,
  GROUPRAIDSTATESYNCFUBENCMD_STATE_FIELD
}
GROUPRAIDSTATESYNCFUBENCMD.is_extendable = false
GROUPRAIDSTATESYNCFUBENCMD.extensions = {}
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.name = "cmd"
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamExpQueryInfoFubenCmd.cmd"
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.number = 1
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.index = 0
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.label = 1
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.has_default_value = true
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.default_value = 11
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.type = 14
TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.name = "param"
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamExpQueryInfoFubenCmd.param"
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.number = 2
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.index = 1
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.label = 1
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.default_value = 56
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.type = 14
TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.name = "rewardtimes"
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.full_name = ".Cmd.TeamExpQueryInfoFubenCmd.rewardtimes"
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.number = 3
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.index = 2
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.label = 1
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.has_default_value = true
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.default_value = 0
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.type = 13
TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD.cpp_type = 3
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.name = "totaltimes"
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.full_name = ".Cmd.TeamExpQueryInfoFubenCmd.totaltimes"
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.number = 4
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.index = 3
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.label = 1
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.has_default_value = true
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.default_value = 0
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.type = 13
TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD.cpp_type = 3
TEAMEXPQUERYINFOFUBENCMD.name = "TeamExpQueryInfoFubenCmd"
TEAMEXPQUERYINFOFUBENCMD.full_name = ".Cmd.TeamExpQueryInfoFubenCmd"
TEAMEXPQUERYINFOFUBENCMD.nested_types = {}
TEAMEXPQUERYINFOFUBENCMD.enum_types = {}
TEAMEXPQUERYINFOFUBENCMD.fields = {
  TEAMEXPQUERYINFOFUBENCMD_CMD_FIELD,
  TEAMEXPQUERYINFOFUBENCMD_PARAM_FIELD,
  TEAMEXPQUERYINFOFUBENCMD_REWARDTIMES_FIELD,
  TEAMEXPQUERYINFOFUBENCMD_TOTALTIMES_FIELD
}
TEAMEXPQUERYINFOFUBENCMD.is_extendable = false
TEAMEXPQUERYINFOFUBENCMD.extensions = {}
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.name = "charid"
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.full_name = ".Cmd.GroupRaidFourthShowData.charid"
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.number = 1
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.index = 0
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.label = 1
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.has_default_value = false
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.default_value = 0
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.type = 4
GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD.cpp_type = 4
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.name = "layer"
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.full_name = ".Cmd.GroupRaidFourthShowData.layer"
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.number = 2
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.index = 1
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.label = 1
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.has_default_value = false
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.default_value = 0
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.type = 13
GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD.cpp_type = 3
GROUPRAIDFOURTHSHOWDATA.name = "GroupRaidFourthShowData"
GROUPRAIDFOURTHSHOWDATA.full_name = ".Cmd.GroupRaidFourthShowData"
GROUPRAIDFOURTHSHOWDATA.nested_types = {}
GROUPRAIDFOURTHSHOWDATA.enum_types = {}
GROUPRAIDFOURTHSHOWDATA.fields = {
  GROUPRAIDFOURTHSHOWDATA_CHARID_FIELD,
  GROUPRAIDFOURTHSHOWDATA_LAYER_FIELD
}
GROUPRAIDFOURTHSHOWDATA.is_extendable = false
GROUPRAIDFOURTHSHOWDATA.extensions = {}
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.name = "cmd"
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.full_name = ".Cmd.UpdateGroupRaidFourthShowData.cmd"
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.number = 1
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.index = 0
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.label = 1
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.has_default_value = true
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.default_value = 11
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.enum_type = XCMD_PB_COMMAND
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.type = 14
UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.cpp_type = 8
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.name = "param"
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.full_name = ".Cmd.UpdateGroupRaidFourthShowData.param"
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.number = 2
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.index = 1
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.label = 1
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.has_default_value = true
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.default_value = 60
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.enum_type = FUBENPARAM
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.type = 14
UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.cpp_type = 8
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.name = "inner"
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.full_name = ".Cmd.UpdateGroupRaidFourthShowData.inner"
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.number = 3
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.index = 2
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.label = 3
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.has_default_value = false
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.default_value = {}
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.message_type = GROUPRAIDFOURTHSHOWDATA
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.type = 11
UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD.cpp_type = 10
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.name = "outer"
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.full_name = ".Cmd.UpdateGroupRaidFourthShowData.outer"
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.number = 4
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.index = 3
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.label = 3
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.has_default_value = false
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.default_value = {}
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.message_type = GROUPRAIDFOURTHSHOWDATA
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.type = 11
UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD.cpp_type = 10
UPDATEGROUPRAIDFOURTHSHOWDATA.name = "UpdateGroupRaidFourthShowData"
UPDATEGROUPRAIDFOURTHSHOWDATA.full_name = ".Cmd.UpdateGroupRaidFourthShowData"
UPDATEGROUPRAIDFOURTHSHOWDATA.nested_types = {}
UPDATEGROUPRAIDFOURTHSHOWDATA.enum_types = {}
UPDATEGROUPRAIDFOURTHSHOWDATA.fields = {
  UPDATEGROUPRAIDFOURTHSHOWDATA_CMD_FIELD,
  UPDATEGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD,
  UPDATEGROUPRAIDFOURTHSHOWDATA_INNER_FIELD,
  UPDATEGROUPRAIDFOURTHSHOWDATA_OUTER_FIELD
}
UPDATEGROUPRAIDFOURTHSHOWDATA.is_extendable = false
UPDATEGROUPRAIDFOURTHSHOWDATA.extensions = {}
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.name = "cmd"
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.full_name = ".Cmd.QueryGroupRaidFourthShowData.cmd"
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.number = 1
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.index = 0
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.label = 1
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.has_default_value = true
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.default_value = 11
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.type = 14
QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD.cpp_type = 8
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.name = "param"
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.full_name = ".Cmd.QueryGroupRaidFourthShowData.param"
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.number = 2
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.index = 1
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.label = 1
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.has_default_value = true
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.default_value = 59
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.enum_type = FUBENPARAM
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.type = 14
QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD.cpp_type = 8
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.name = "open"
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.full_name = ".Cmd.QueryGroupRaidFourthShowData.open"
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.number = 3
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.index = 2
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.label = 1
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.has_default_value = true
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.default_value = false
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.type = 8
QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD.cpp_type = 7
QUERYGROUPRAIDFOURTHSHOWDATA.name = "QueryGroupRaidFourthShowData"
QUERYGROUPRAIDFOURTHSHOWDATA.full_name = ".Cmd.QueryGroupRaidFourthShowData"
QUERYGROUPRAIDFOURTHSHOWDATA.nested_types = {}
QUERYGROUPRAIDFOURTHSHOWDATA.enum_types = {}
QUERYGROUPRAIDFOURTHSHOWDATA.fields = {
  QUERYGROUPRAIDFOURTHSHOWDATA_CMD_FIELD,
  QUERYGROUPRAIDFOURTHSHOWDATA_PARAM_FIELD,
  QUERYGROUPRAIDFOURTHSHOWDATA_OPEN_FIELD
}
QUERYGROUPRAIDFOURTHSHOWDATA.is_extendable = false
QUERYGROUPRAIDFOURTHSHOWDATA.extensions = {}
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.name = "cmd"
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.full_name = ".Cmd.GroupRaidFourthGoOuterCmd.cmd"
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.number = 1
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.index = 0
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.label = 1
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.has_default_value = true
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.default_value = 11
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.type = 14
GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD.cpp_type = 8
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.name = "param"
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.full_name = ".Cmd.GroupRaidFourthGoOuterCmd.param"
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.number = 2
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.index = 1
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.label = 1
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.has_default_value = true
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.default_value = 61
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.enum_type = FUBENPARAM
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.type = 14
GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD.cpp_type = 8
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.name = "npcguid"
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.full_name = ".Cmd.GroupRaidFourthGoOuterCmd.npcguid"
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.number = 3
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.index = 2
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.label = 2
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.has_default_value = false
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.default_value = 0
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.type = 4
GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD.cpp_type = 4
GROUPRAIDFOURTHGOOUTERCMD.name = "GroupRaidFourthGoOuterCmd"
GROUPRAIDFOURTHGOOUTERCMD.full_name = ".Cmd.GroupRaidFourthGoOuterCmd"
GROUPRAIDFOURTHGOOUTERCMD.nested_types = {}
GROUPRAIDFOURTHGOOUTERCMD.enum_types = {}
GROUPRAIDFOURTHGOOUTERCMD.fields = {
  GROUPRAIDFOURTHGOOUTERCMD_CMD_FIELD,
  GROUPRAIDFOURTHGOOUTERCMD_PARAM_FIELD,
  GROUPRAIDFOURTHGOOUTERCMD_NPCGUID_FIELD
}
GROUPRAIDFOURTHGOOUTERCMD.is_extendable = false
GROUPRAIDFOURTHGOOUTERCMD.extensions = {}
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.name = "cmd"
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.RaidStageSyncFubenCmd.cmd"
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.number = 1
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.index = 0
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.label = 1
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.has_default_value = true
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.default_value = 11
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.type = 14
RAIDSTAGESYNCFUBENCMD_CMD_FIELD.cpp_type = 8
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.name = "param"
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.RaidStageSyncFubenCmd.param"
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.number = 2
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.index = 1
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.label = 1
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.has_default_value = true
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.default_value = 62
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.type = 14
RAIDSTAGESYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.name = "stage"
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.full_name = ".Cmd.RaidStageSyncFubenCmd.stage"
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.number = 3
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.index = 2
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.label = 1
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.has_default_value = true
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.default_value = 0
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.type = 13
RAIDSTAGESYNCFUBENCMD_STAGE_FIELD.cpp_type = 3
RAIDSTAGESYNCFUBENCMD.name = "RaidStageSyncFubenCmd"
RAIDSTAGESYNCFUBENCMD.full_name = ".Cmd.RaidStageSyncFubenCmd"
RAIDSTAGESYNCFUBENCMD.nested_types = {}
RAIDSTAGESYNCFUBENCMD.enum_types = {}
RAIDSTAGESYNCFUBENCMD.fields = {
  RAIDSTAGESYNCFUBENCMD_CMD_FIELD,
  RAIDSTAGESYNCFUBENCMD_PARAM_FIELD,
  RAIDSTAGESYNCFUBENCMD_STAGE_FIELD
}
RAIDSTAGESYNCFUBENCMD.is_extendable = false
RAIDSTAGESYNCFUBENCMD.extensions = {}
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.name = "cmd"
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd.cmd"
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.number = 1
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.index = 0
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.label = 1
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.has_default_value = true
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.default_value = 11
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.type = 14
THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD.cpp_type = 8
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.name = "param"
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd.param"
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.number = 2
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.index = 1
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.label = 1
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.has_default_value = true
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.default_value = 63
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.type = 14
THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD.cpp_type = 8
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.name = "elitenum"
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd.elitenum"
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.number = 3
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.index = 2
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.label = 1
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.has_default_value = true
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.default_value = 0
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.type = 5
THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD.cpp_type = 1
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.name = "mininum"
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd.mininum"
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.number = 4
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.index = 3
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.label = 1
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.has_default_value = true
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.default_value = -1
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.type = 5
THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD.cpp_type = 1
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.name = "mvpnum"
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd.mvpnum"
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.number = 5
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.index = 4
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.label = 1
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.has_default_value = true
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.default_value = -1
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.type = 5
THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD.cpp_type = 1
THANKSGIVINGMONSTERFUBENCMD.name = "ThanksGivingMonsterFuBenCmd"
THANKSGIVINGMONSTERFUBENCMD.full_name = ".Cmd.ThanksGivingMonsterFuBenCmd"
THANKSGIVINGMONSTERFUBENCMD.nested_types = {}
THANKSGIVINGMONSTERFUBENCMD.enum_types = {}
THANKSGIVINGMONSTERFUBENCMD.fields = {
  THANKSGIVINGMONSTERFUBENCMD_CMD_FIELD,
  THANKSGIVINGMONSTERFUBENCMD_PARAM_FIELD,
  THANKSGIVINGMONSTERFUBENCMD_ELITENUM_FIELD,
  THANKSGIVINGMONSTERFUBENCMD_MININUM_FIELD,
  THANKSGIVINGMONSTERFUBENCMD_MVPNUM_FIELD
}
THANKSGIVINGMONSTERFUBENCMD.is_extendable = false
THANKSGIVINGMONSTERFUBENCMD.extensions = {}
KUMAMOTOOPERFUBENCMD_CMD_FIELD.name = "cmd"
KUMAMOTOOPERFUBENCMD_CMD_FIELD.full_name = ".Cmd.KumamotoOperFubenCmd.cmd"
KUMAMOTOOPERFUBENCMD_CMD_FIELD.number = 1
KUMAMOTOOPERFUBENCMD_CMD_FIELD.index = 0
KUMAMOTOOPERFUBENCMD_CMD_FIELD.label = 1
KUMAMOTOOPERFUBENCMD_CMD_FIELD.has_default_value = true
KUMAMOTOOPERFUBENCMD_CMD_FIELD.default_value = 11
KUMAMOTOOPERFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
KUMAMOTOOPERFUBENCMD_CMD_FIELD.type = 14
KUMAMOTOOPERFUBENCMD_CMD_FIELD.cpp_type = 8
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.name = "param"
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.full_name = ".Cmd.KumamotoOperFubenCmd.param"
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.number = 2
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.index = 1
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.label = 1
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.has_default_value = true
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.default_value = 58
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.type = 14
KUMAMOTOOPERFUBENCMD_PARAM_FIELD.cpp_type = 8
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.name = "type"
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.full_name = ".Cmd.KumamotoOperFubenCmd.type"
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.number = 3
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.index = 2
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.label = 1
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.has_default_value = true
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.default_value = EKUMAMOTOOPER_CREATE
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.enum_type = EKUMAMOTOOPER
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.type = 14
KUMAMOTOOPERFUBENCMD_TYPE_FIELD.cpp_type = 8
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.name = "value"
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.full_name = ".Cmd.KumamotoOperFubenCmd.value"
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.number = 4
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.index = 3
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.label = 1
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.has_default_value = true
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.default_value = 0
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.type = 13
KUMAMOTOOPERFUBENCMD_VALUE_FIELD.cpp_type = 3
KUMAMOTOOPERFUBENCMD.name = "KumamotoOperFubenCmd"
KUMAMOTOOPERFUBENCMD.full_name = ".Cmd.KumamotoOperFubenCmd"
KUMAMOTOOPERFUBENCMD.nested_types = {}
KUMAMOTOOPERFUBENCMD.enum_types = {}
KUMAMOTOOPERFUBENCMD.fields = {
  KUMAMOTOOPERFUBENCMD_CMD_FIELD,
  KUMAMOTOOPERFUBENCMD_PARAM_FIELD,
  KUMAMOTOOPERFUBENCMD_TYPE_FIELD,
  KUMAMOTOOPERFUBENCMD_VALUE_FIELD
}
KUMAMOTOOPERFUBENCMD.is_extendable = false
KUMAMOTOOPERFUBENCMD.extensions = {}
OTHELLOOCCUPYITEM_POINTID_FIELD.name = "pointid"
OTHELLOOCCUPYITEM_POINTID_FIELD.full_name = ".Cmd.OthelloOccupyItem.pointid"
OTHELLOOCCUPYITEM_POINTID_FIELD.number = 1
OTHELLOOCCUPYITEM_POINTID_FIELD.index = 0
OTHELLOOCCUPYITEM_POINTID_FIELD.label = 1
OTHELLOOCCUPYITEM_POINTID_FIELD.has_default_value = true
OTHELLOOCCUPYITEM_POINTID_FIELD.default_value = 0
OTHELLOOCCUPYITEM_POINTID_FIELD.type = 13
OTHELLOOCCUPYITEM_POINTID_FIELD.cpp_type = 3
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.name = "occupycolor"
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.full_name = ".Cmd.OthelloOccupyItem.occupycolor"
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.number = 2
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.index = 1
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.label = 1
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.has_default_value = true
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.default_value = 0
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.type = 13
OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD.cpp_type = 3
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.name = "redprogress"
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.full_name = ".Cmd.OthelloOccupyItem.redprogress"
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.number = 3
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.index = 2
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.label = 1
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.has_default_value = true
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.default_value = 0
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.type = 13
OTHELLOOCCUPYITEM_REDPROGRESS_FIELD.cpp_type = 3
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.name = "blueprogress"
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.full_name = ".Cmd.OthelloOccupyItem.blueprogress"
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.number = 4
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.index = 3
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.label = 1
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.has_default_value = true
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.default_value = 0
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.type = 13
OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD.cpp_type = 3
OTHELLOOCCUPYITEM.name = "OthelloOccupyItem"
OTHELLOOCCUPYITEM.full_name = ".Cmd.OthelloOccupyItem"
OTHELLOOCCUPYITEM.nested_types = {}
OTHELLOOCCUPYITEM.enum_types = {}
OTHELLOOCCUPYITEM.fields = {
  OTHELLOOCCUPYITEM_POINTID_FIELD,
  OTHELLOOCCUPYITEM_OCCUPYCOLOR_FIELD,
  OTHELLOOCCUPYITEM_REDPROGRESS_FIELD,
  OTHELLOOCCUPYITEM_BLUEPROGRESS_FIELD
}
OTHELLOOCCUPYITEM.is_extendable = false
OTHELLOOCCUPYITEM.extensions = {}
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.name = "cmd"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.full_name = ".Cmd.OthelloPointOccupyPowerFubenCmd.cmd"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.number = 1
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.index = 0
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.label = 1
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.has_default_value = true
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.default_value = 11
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.type = 14
OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD.cpp_type = 8
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.name = "param"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.full_name = ".Cmd.OthelloPointOccupyPowerFubenCmd.param"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.number = 2
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.index = 1
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.label = 1
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.has_default_value = true
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.default_value = 64
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.type = 14
OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD.cpp_type = 8
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.name = "occupy"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.full_name = ".Cmd.OthelloPointOccupyPowerFubenCmd.occupy"
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.number = 3
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.index = 2
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.label = 3
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.has_default_value = false
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.default_value = {}
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.message_type = OTHELLOOCCUPYITEM
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.type = 11
OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD.cpp_type = 10
OTHELLOPOINTOCCUPYPOWERFUBENCMD.name = "OthelloPointOccupyPowerFubenCmd"
OTHELLOPOINTOCCUPYPOWERFUBENCMD.full_name = ".Cmd.OthelloPointOccupyPowerFubenCmd"
OTHELLOPOINTOCCUPYPOWERFUBENCMD.nested_types = {}
OTHELLOPOINTOCCUPYPOWERFUBENCMD.enum_types = {}
OTHELLOPOINTOCCUPYPOWERFUBENCMD.fields = {
  OTHELLOPOINTOCCUPYPOWERFUBENCMD_CMD_FIELD,
  OTHELLOPOINTOCCUPYPOWERFUBENCMD_PARAM_FIELD,
  OTHELLOPOINTOCCUPYPOWERFUBENCMD_OCCUPY_FIELD
}
OTHELLOPOINTOCCUPYPOWERFUBENCMD.is_extendable = false
OTHELLOPOINTOCCUPYPOWERFUBENCMD.extensions = {}
OTHELLOINFOSYNCDATA_TEAMID_FIELD.name = "teamid"
OTHELLOINFOSYNCDATA_TEAMID_FIELD.full_name = ".Cmd.OthelloInfoSyncData.teamid"
OTHELLOINFOSYNCDATA_TEAMID_FIELD.number = 1
OTHELLOINFOSYNCDATA_TEAMID_FIELD.index = 0
OTHELLOINFOSYNCDATA_TEAMID_FIELD.label = 1
OTHELLOINFOSYNCDATA_TEAMID_FIELD.has_default_value = false
OTHELLOINFOSYNCDATA_TEAMID_FIELD.default_value = 0
OTHELLOINFOSYNCDATA_TEAMID_FIELD.type = 4
OTHELLOINFOSYNCDATA_TEAMID_FIELD.cpp_type = 4
OTHELLOINFOSYNCDATA_COLOR_FIELD.name = "color"
OTHELLOINFOSYNCDATA_COLOR_FIELD.full_name = ".Cmd.OthelloInfoSyncData.color"
OTHELLOINFOSYNCDATA_COLOR_FIELD.number = 2
OTHELLOINFOSYNCDATA_COLOR_FIELD.index = 1
OTHELLOINFOSYNCDATA_COLOR_FIELD.label = 1
OTHELLOINFOSYNCDATA_COLOR_FIELD.has_default_value = false
OTHELLOINFOSYNCDATA_COLOR_FIELD.default_value = 0
OTHELLOINFOSYNCDATA_COLOR_FIELD.type = 13
OTHELLOINFOSYNCDATA_COLOR_FIELD.cpp_type = 3
OTHELLOINFOSYNCDATA_SCORE_FIELD.name = "score"
OTHELLOINFOSYNCDATA_SCORE_FIELD.full_name = ".Cmd.OthelloInfoSyncData.score"
OTHELLOINFOSYNCDATA_SCORE_FIELD.number = 3
OTHELLOINFOSYNCDATA_SCORE_FIELD.index = 2
OTHELLOINFOSYNCDATA_SCORE_FIELD.label = 1
OTHELLOINFOSYNCDATA_SCORE_FIELD.has_default_value = true
OTHELLOINFOSYNCDATA_SCORE_FIELD.default_value = 0
OTHELLOINFOSYNCDATA_SCORE_FIELD.type = 13
OTHELLOINFOSYNCDATA_SCORE_FIELD.cpp_type = 3
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.name = "teamname"
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.full_name = ".Cmd.OthelloInfoSyncData.teamname"
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.number = 4
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.index = 3
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.label = 1
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.has_default_value = false
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.default_value = ""
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.type = 9
OTHELLOINFOSYNCDATA_TEAMNAME_FIELD.cpp_type = 9
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.name = "warband_name"
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.full_name = ".Cmd.OthelloInfoSyncData.warband_name"
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.number = 5
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.index = 4
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.label = 1
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.has_default_value = false
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.default_value = ""
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.type = 9
OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD.cpp_type = 9
OTHELLOINFOSYNCDATA.name = "OthelloInfoSyncData"
OTHELLOINFOSYNCDATA.full_name = ".Cmd.OthelloInfoSyncData"
OTHELLOINFOSYNCDATA.nested_types = {}
OTHELLOINFOSYNCDATA.enum_types = {}
OTHELLOINFOSYNCDATA.fields = {
  OTHELLOINFOSYNCDATA_TEAMID_FIELD,
  OTHELLOINFOSYNCDATA_COLOR_FIELD,
  OTHELLOINFOSYNCDATA_SCORE_FIELD,
  OTHELLOINFOSYNCDATA_TEAMNAME_FIELD,
  OTHELLOINFOSYNCDATA_WARBAND_NAME_FIELD
}
OTHELLOINFOSYNCDATA.is_extendable = false
OTHELLOINFOSYNCDATA.extensions = {}
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.name = "cmd"
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.OthelloInfoSyncFubenCmd.cmd"
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.number = 1
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.index = 0
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.label = 1
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.has_default_value = true
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.default_value = 11
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.type = 14
OTHELLOINFOSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.name = "param"
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.OthelloInfoSyncFubenCmd.param"
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.number = 2
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.index = 1
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.label = 1
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.default_value = 65
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.type = 14
OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.OthelloInfoSyncFubenCmd.teaminfo"
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.number = 3
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.index = 2
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.label = 3
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.has_default_value = false
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.default_value = {}
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.message_type = OTHELLOINFOSYNCDATA
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.type = 11
OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.name = "endtime"
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.OthelloInfoSyncFubenCmd.endtime"
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.number = 4
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.index = 3
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.label = 1
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.has_default_value = false
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.default_value = 0
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.type = 13
OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD.cpp_type = 3
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.name = "fullfire"
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.full_name = ".Cmd.OthelloInfoSyncFubenCmd.fullfire"
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.number = 5
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.index = 4
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.label = 1
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.has_default_value = false
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.default_value = false
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.type = 8
OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD.cpp_type = 7
OTHELLOINFOSYNCFUBENCMD.name = "OthelloInfoSyncFubenCmd"
OTHELLOINFOSYNCFUBENCMD.full_name = ".Cmd.OthelloInfoSyncFubenCmd"
OTHELLOINFOSYNCFUBENCMD.nested_types = {}
OTHELLOINFOSYNCFUBENCMD.enum_types = {}
OTHELLOINFOSYNCFUBENCMD.fields = {
  OTHELLOINFOSYNCFUBENCMD_CMD_FIELD,
  OTHELLOINFOSYNCFUBENCMD_PARAM_FIELD,
  OTHELLOINFOSYNCFUBENCMD_TEAMINFO_FIELD,
  OTHELLOINFOSYNCFUBENCMD_ENDTIME_FIELD,
  OTHELLOINFOSYNCFUBENCMD_FULLFIRE_FIELD
}
OTHELLOINFOSYNCFUBENCMD.is_extendable = false
OTHELLOINFOSYNCFUBENCMD.extensions = {}
OTHELLORAIDUSERINFO_CHARID_FIELD.name = "charid"
OTHELLORAIDUSERINFO_CHARID_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.charid"
OTHELLORAIDUSERINFO_CHARID_FIELD.number = 1
OTHELLORAIDUSERINFO_CHARID_FIELD.index = 0
OTHELLORAIDUSERINFO_CHARID_FIELD.label = 1
OTHELLORAIDUSERINFO_CHARID_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_CHARID_FIELD.default_value = 0
OTHELLORAIDUSERINFO_CHARID_FIELD.type = 4
OTHELLORAIDUSERINFO_CHARID_FIELD.cpp_type = 4
OTHELLORAIDUSERINFO_NAME_FIELD.name = "name"
OTHELLORAIDUSERINFO_NAME_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.name"
OTHELLORAIDUSERINFO_NAME_FIELD.number = 2
OTHELLORAIDUSERINFO_NAME_FIELD.index = 1
OTHELLORAIDUSERINFO_NAME_FIELD.label = 1
OTHELLORAIDUSERINFO_NAME_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_NAME_FIELD.default_value = ""
OTHELLORAIDUSERINFO_NAME_FIELD.type = 9
OTHELLORAIDUSERINFO_NAME_FIELD.cpp_type = 9
OTHELLORAIDUSERINFO_PROFESSION_FIELD.name = "profession"
OTHELLORAIDUSERINFO_PROFESSION_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.profession"
OTHELLORAIDUSERINFO_PROFESSION_FIELD.number = 3
OTHELLORAIDUSERINFO_PROFESSION_FIELD.index = 2
OTHELLORAIDUSERINFO_PROFESSION_FIELD.label = 1
OTHELLORAIDUSERINFO_PROFESSION_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_PROFESSION_FIELD.default_value = nil
OTHELLORAIDUSERINFO_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
OTHELLORAIDUSERINFO_PROFESSION_FIELD.type = 14
OTHELLORAIDUSERINFO_PROFESSION_FIELD.cpp_type = 8
OTHELLORAIDUSERINFO_KILLNUM_FIELD.name = "killnum"
OTHELLORAIDUSERINFO_KILLNUM_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.killnum"
OTHELLORAIDUSERINFO_KILLNUM_FIELD.number = 4
OTHELLORAIDUSERINFO_KILLNUM_FIELD.index = 3
OTHELLORAIDUSERINFO_KILLNUM_FIELD.label = 1
OTHELLORAIDUSERINFO_KILLNUM_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_KILLNUM_FIELD.default_value = 0
OTHELLORAIDUSERINFO_KILLNUM_FIELD.type = 13
OTHELLORAIDUSERINFO_KILLNUM_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_DIENUM_FIELD.name = "dienum"
OTHELLORAIDUSERINFO_DIENUM_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.dienum"
OTHELLORAIDUSERINFO_DIENUM_FIELD.number = 5
OTHELLORAIDUSERINFO_DIENUM_FIELD.index = 4
OTHELLORAIDUSERINFO_DIENUM_FIELD.label = 1
OTHELLORAIDUSERINFO_DIENUM_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_DIENUM_FIELD.default_value = 0
OTHELLORAIDUSERINFO_DIENUM_FIELD.type = 13
OTHELLORAIDUSERINFO_DIENUM_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_HEAL_FIELD.name = "heal"
OTHELLORAIDUSERINFO_HEAL_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.heal"
OTHELLORAIDUSERINFO_HEAL_FIELD.number = 6
OTHELLORAIDUSERINFO_HEAL_FIELD.index = 5
OTHELLORAIDUSERINFO_HEAL_FIELD.label = 1
OTHELLORAIDUSERINFO_HEAL_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_HEAL_FIELD.default_value = 0
OTHELLORAIDUSERINFO_HEAL_FIELD.type = 13
OTHELLORAIDUSERINFO_HEAL_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.name = "killscore"
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.killscore"
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.number = 7
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.index = 6
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.label = 1
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.default_value = 0
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.type = 13
OTHELLORAIDUSERINFO_KILLSCORE_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.name = "occupyscore"
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.occupyscore"
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.number = 8
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.index = 7
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.label = 1
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.default_value = 0
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.type = 13
OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.name = "seasonscore"
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.seasonscore"
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.number = 9
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.index = 8
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.label = 1
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.default_value = 0
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.type = 13
OTHELLORAIDUSERINFO_SEASONSCORE_FIELD.cpp_type = 3
OTHELLORAIDUSERINFO_HIDENAME_FIELD.name = "hidename"
OTHELLORAIDUSERINFO_HIDENAME_FIELD.full_name = ".Cmd.OthelloRaidUserInfo.hidename"
OTHELLORAIDUSERINFO_HIDENAME_FIELD.number = 10
OTHELLORAIDUSERINFO_HIDENAME_FIELD.index = 9
OTHELLORAIDUSERINFO_HIDENAME_FIELD.label = 1
OTHELLORAIDUSERINFO_HIDENAME_FIELD.has_default_value = false
OTHELLORAIDUSERINFO_HIDENAME_FIELD.default_value = false
OTHELLORAIDUSERINFO_HIDENAME_FIELD.type = 8
OTHELLORAIDUSERINFO_HIDENAME_FIELD.cpp_type = 7
OTHELLORAIDUSERINFO.name = "OthelloRaidUserInfo"
OTHELLORAIDUSERINFO.full_name = ".Cmd.OthelloRaidUserInfo"
OTHELLORAIDUSERINFO.nested_types = {}
OTHELLORAIDUSERINFO.enum_types = {}
OTHELLORAIDUSERINFO.fields = {
  OTHELLORAIDUSERINFO_CHARID_FIELD,
  OTHELLORAIDUSERINFO_NAME_FIELD,
  OTHELLORAIDUSERINFO_PROFESSION_FIELD,
  OTHELLORAIDUSERINFO_KILLNUM_FIELD,
  OTHELLORAIDUSERINFO_DIENUM_FIELD,
  OTHELLORAIDUSERINFO_HEAL_FIELD,
  OTHELLORAIDUSERINFO_KILLSCORE_FIELD,
  OTHELLORAIDUSERINFO_OCCUPYSCORE_FIELD,
  OTHELLORAIDUSERINFO_SEASONSCORE_FIELD,
  OTHELLORAIDUSERINFO_HIDENAME_FIELD
}
OTHELLORAIDUSERINFO.is_extendable = false
OTHELLORAIDUSERINFO.extensions = {}
OTHELLORAIDTEAMINFO_TEAMID_FIELD.name = "teamid"
OTHELLORAIDTEAMINFO_TEAMID_FIELD.full_name = ".Cmd.OthelloRaidTeamInfo.teamid"
OTHELLORAIDTEAMINFO_TEAMID_FIELD.number = 1
OTHELLORAIDTEAMINFO_TEAMID_FIELD.index = 0
OTHELLORAIDTEAMINFO_TEAMID_FIELD.label = 1
OTHELLORAIDTEAMINFO_TEAMID_FIELD.has_default_value = false
OTHELLORAIDTEAMINFO_TEAMID_FIELD.default_value = 0
OTHELLORAIDTEAMINFO_TEAMID_FIELD.type = 4
OTHELLORAIDTEAMINFO_TEAMID_FIELD.cpp_type = 4
OTHELLORAIDTEAMINFO_COLOR_FIELD.name = "color"
OTHELLORAIDTEAMINFO_COLOR_FIELD.full_name = ".Cmd.OthelloRaidTeamInfo.color"
OTHELLORAIDTEAMINFO_COLOR_FIELD.number = 2
OTHELLORAIDTEAMINFO_COLOR_FIELD.index = 1
OTHELLORAIDTEAMINFO_COLOR_FIELD.label = 1
OTHELLORAIDTEAMINFO_COLOR_FIELD.has_default_value = false
OTHELLORAIDTEAMINFO_COLOR_FIELD.default_value = 0
OTHELLORAIDTEAMINFO_COLOR_FIELD.type = 13
OTHELLORAIDTEAMINFO_COLOR_FIELD.cpp_type = 3
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.name = "avescore"
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.full_name = ".Cmd.OthelloRaidTeamInfo.avescore"
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.number = 3
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.index = 2
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.label = 1
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.has_default_value = false
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.default_value = 0
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.type = 13
OTHELLORAIDTEAMINFO_AVESCORE_FIELD.cpp_type = 3
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.name = "userinfos"
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.full_name = ".Cmd.OthelloRaidTeamInfo.userinfos"
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.number = 4
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.index = 3
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.label = 3
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.has_default_value = false
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.default_value = {}
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.message_type = OTHELLORAIDUSERINFO
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.type = 11
OTHELLORAIDTEAMINFO_USERINFOS_FIELD.cpp_type = 10
OTHELLORAIDTEAMINFO.name = "OthelloRaidTeamInfo"
OTHELLORAIDTEAMINFO.full_name = ".Cmd.OthelloRaidTeamInfo"
OTHELLORAIDTEAMINFO.nested_types = {}
OTHELLORAIDTEAMINFO.enum_types = {}
OTHELLORAIDTEAMINFO.fields = {
  OTHELLORAIDTEAMINFO_TEAMID_FIELD,
  OTHELLORAIDTEAMINFO_COLOR_FIELD,
  OTHELLORAIDTEAMINFO_AVESCORE_FIELD,
  OTHELLORAIDTEAMINFO_USERINFOS_FIELD
}
OTHELLORAIDTEAMINFO.is_extendable = false
OTHELLORAIDTEAMINFO.extensions = {}
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.name = "cmd"
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.QueryOthelloUserInfoFubenCmd.cmd"
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.number = 1
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.index = 0
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.label = 1
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.has_default_value = true
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.default_value = 11
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.type = 14
QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD.cpp_type = 8
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.name = "param"
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.QueryOthelloUserInfoFubenCmd.param"
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.number = 2
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.index = 1
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.label = 1
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.has_default_value = true
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.default_value = 66
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.type = 14
QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.QueryOthelloUserInfoFubenCmd.teaminfo"
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.number = 3
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.index = 2
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.label = 3
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.has_default_value = false
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.default_value = {}
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.message_type = OTHELLORAIDTEAMINFO
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.type = 11
QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
QUERYOTHELLOUSERINFOFUBENCMD.name = "QueryOthelloUserInfoFubenCmd"
QUERYOTHELLOUSERINFOFUBENCMD.full_name = ".Cmd.QueryOthelloUserInfoFubenCmd"
QUERYOTHELLOUSERINFOFUBENCMD.nested_types = {}
QUERYOTHELLOUSERINFOFUBENCMD.enum_types = {}
QUERYOTHELLOUSERINFOFUBENCMD.fields = {
  QUERYOTHELLOUSERINFOFUBENCMD_CMD_FIELD,
  QUERYOTHELLOUSERINFOFUBENCMD_PARAM_FIELD,
  QUERYOTHELLOUSERINFOFUBENCMD_TEAMINFO_FIELD
}
QUERYOTHELLOUSERINFOFUBENCMD.is_extendable = false
QUERYOTHELLOUSERINFOFUBENCMD.extensions = {}
OTHELLOREPORTFUBENCMD_CMD_FIELD.name = "cmd"
OTHELLOREPORTFUBENCMD_CMD_FIELD.full_name = ".Cmd.OthelloReportFubenCmd.cmd"
OTHELLOREPORTFUBENCMD_CMD_FIELD.number = 1
OTHELLOREPORTFUBENCMD_CMD_FIELD.index = 0
OTHELLOREPORTFUBENCMD_CMD_FIELD.label = 1
OTHELLOREPORTFUBENCMD_CMD_FIELD.has_default_value = true
OTHELLOREPORTFUBENCMD_CMD_FIELD.default_value = 11
OTHELLOREPORTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OTHELLOREPORTFUBENCMD_CMD_FIELD.type = 14
OTHELLOREPORTFUBENCMD_CMD_FIELD.cpp_type = 8
OTHELLOREPORTFUBENCMD_PARAM_FIELD.name = "param"
OTHELLOREPORTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.OthelloReportFubenCmd.param"
OTHELLOREPORTFUBENCMD_PARAM_FIELD.number = 2
OTHELLOREPORTFUBENCMD_PARAM_FIELD.index = 1
OTHELLOREPORTFUBENCMD_PARAM_FIELD.label = 1
OTHELLOREPORTFUBENCMD_PARAM_FIELD.has_default_value = true
OTHELLOREPORTFUBENCMD_PARAM_FIELD.default_value = 67
OTHELLOREPORTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OTHELLOREPORTFUBENCMD_PARAM_FIELD.type = 14
OTHELLOREPORTFUBENCMD_PARAM_FIELD.cpp_type = 8
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.name = "winteam"
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.full_name = ".Cmd.OthelloReportFubenCmd.winteam"
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.number = 3
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.index = 2
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.label = 2
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.has_default_value = true
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.default_value = 0
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.type = 13
OTHELLOREPORTFUBENCMD_WINTEAM_FIELD.cpp_type = 3
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.name = "teaminfo"
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.full_name = ".Cmd.OthelloReportFubenCmd.teaminfo"
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.number = 4
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.index = 3
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.label = 3
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.has_default_value = false
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.default_value = {}
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.message_type = OTHELLORAIDTEAMINFO
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.type = 11
OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD.cpp_type = 10
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.name = "mvpuserinfo"
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.full_name = ".Cmd.OthelloReportFubenCmd.mvpuserinfo"
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.number = 5
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.index = 4
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.label = 1
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.has_default_value = false
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.default_value = nil
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.type = 11
OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD.cpp_type = 10
OTHELLOREPORTFUBENCMD.name = "OthelloReportFubenCmd"
OTHELLOREPORTFUBENCMD.full_name = ".Cmd.OthelloReportFubenCmd"
OTHELLOREPORTFUBENCMD.nested_types = {}
OTHELLOREPORTFUBENCMD.enum_types = {}
OTHELLOREPORTFUBENCMD.fields = {
  OTHELLOREPORTFUBENCMD_CMD_FIELD,
  OTHELLOREPORTFUBENCMD_PARAM_FIELD,
  OTHELLOREPORTFUBENCMD_WINTEAM_FIELD,
  OTHELLOREPORTFUBENCMD_TEAMINFO_FIELD,
  OTHELLOREPORTFUBENCMD_MVPUSERINFO_FIELD
}
OTHELLOREPORTFUBENCMD.is_extendable = false
OTHELLOREPORTFUBENCMD.extensions = {}
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.name = "cmd"
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.full_name = ".Cmd.RoguelikeUnlockSceneSync.cmd"
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.number = 1
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.index = 0
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.label = 1
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.has_default_value = true
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.default_value = 11
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.type = 14
ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD.cpp_type = 8
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.name = "param"
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.full_name = ".Cmd.RoguelikeUnlockSceneSync.param"
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.number = 2
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.index = 1
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.label = 1
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.has_default_value = true
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.default_value = 68
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.enum_type = FUBENPARAM
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.type = 14
ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD.cpp_type = 8
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.name = "unlockids"
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.full_name = ".Cmd.RoguelikeUnlockSceneSync.unlockids"
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.number = 3
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.index = 2
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.label = 3
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.has_default_value = false
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.default_value = {}
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.type = 13
ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD.cpp_type = 3
ROGUELIKEUNLOCKSCENESYNC.name = "RoguelikeUnlockSceneSync"
ROGUELIKEUNLOCKSCENESYNC.full_name = ".Cmd.RoguelikeUnlockSceneSync"
ROGUELIKEUNLOCKSCENESYNC.nested_types = {}
ROGUELIKEUNLOCKSCENESYNC.enum_types = {}
ROGUELIKEUNLOCKSCENESYNC.fields = {
  ROGUELIKEUNLOCKSCENESYNC_CMD_FIELD,
  ROGUELIKEUNLOCKSCENESYNC_PARAM_FIELD,
  ROGUELIKEUNLOCKSCENESYNC_UNLOCKIDS_FIELD
}
ROGUELIKEUNLOCKSCENESYNC.is_extendable = false
ROGUELIKEUNLOCKSCENESYNC.extensions = {}
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.name = "cmd"
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.full_name = ".Cmd.TransferFightChooseFubenCmd.cmd"
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.number = 1
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.index = 0
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.label = 1
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.has_default_value = true
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.default_value = 11
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.type = 14
TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD.cpp_type = 8
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.name = "param"
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TransferFightChooseFubenCmd.param"
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.number = 2
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.index = 1
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.label = 1
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.has_default_value = true
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.default_value = 69
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.type = 14
TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD.cpp_type = 8
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.name = "coldtime"
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.full_name = ".Cmd.TransferFightChooseFubenCmd.coldtime"
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.number = 3
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.index = 2
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.label = 1
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.has_default_value = false
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.default_value = 0
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.type = 13
TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD.cpp_type = 3
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.name = "index"
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.full_name = ".Cmd.TransferFightChooseFubenCmd.index"
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.number = 4
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.index = 3
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.label = 1
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.has_default_value = false
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.default_value = 0
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.type = 13
TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD.cpp_type = 3
TRANSFERFIGHTCHOOSEFUBENCMD.name = "TransferFightChooseFubenCmd"
TRANSFERFIGHTCHOOSEFUBENCMD.full_name = ".Cmd.TransferFightChooseFubenCmd"
TRANSFERFIGHTCHOOSEFUBENCMD.nested_types = {}
TRANSFERFIGHTCHOOSEFUBENCMD.enum_types = {}
TRANSFERFIGHTCHOOSEFUBENCMD.fields = {
  TRANSFERFIGHTCHOOSEFUBENCMD_CMD_FIELD,
  TRANSFERFIGHTCHOOSEFUBENCMD_PARAM_FIELD,
  TRANSFERFIGHTCHOOSEFUBENCMD_COLDTIME_FIELD,
  TRANSFERFIGHTCHOOSEFUBENCMD_INDEX_FIELD
}
TRANSFERFIGHTCHOOSEFUBENCMD.is_extendable = false
TRANSFERFIGHTCHOOSEFUBENCMD.extensions = {}
RANKSCORE_RANK_FIELD.name = "rank"
RANKSCORE_RANK_FIELD.full_name = ".Cmd.RankScore.rank"
RANKSCORE_RANK_FIELD.number = 1
RANKSCORE_RANK_FIELD.index = 0
RANKSCORE_RANK_FIELD.label = 1
RANKSCORE_RANK_FIELD.has_default_value = false
RANKSCORE_RANK_FIELD.default_value = 0
RANKSCORE_RANK_FIELD.type = 13
RANKSCORE_RANK_FIELD.cpp_type = 3
RANKSCORE_SCORE_FIELD.name = "score"
RANKSCORE_SCORE_FIELD.full_name = ".Cmd.RankScore.score"
RANKSCORE_SCORE_FIELD.number = 2
RANKSCORE_SCORE_FIELD.index = 1
RANKSCORE_SCORE_FIELD.label = 1
RANKSCORE_SCORE_FIELD.has_default_value = false
RANKSCORE_SCORE_FIELD.default_value = 0
RANKSCORE_SCORE_FIELD.type = 13
RANKSCORE_SCORE_FIELD.cpp_type = 3
RANKSCORE_NAME_FIELD.name = "name"
RANKSCORE_NAME_FIELD.full_name = ".Cmd.RankScore.name"
RANKSCORE_NAME_FIELD.number = 3
RANKSCORE_NAME_FIELD.index = 2
RANKSCORE_NAME_FIELD.label = 1
RANKSCORE_NAME_FIELD.has_default_value = false
RANKSCORE_NAME_FIELD.default_value = ""
RANKSCORE_NAME_FIELD.type = 9
RANKSCORE_NAME_FIELD.cpp_type = 9
RANKSCORE.name = "RankScore"
RANKSCORE.full_name = ".Cmd.RankScore"
RANKSCORE.nested_types = {}
RANKSCORE.enum_types = {}
RANKSCORE.fields = {
  RANKSCORE_RANK_FIELD,
  RANKSCORE_SCORE_FIELD,
  RANKSCORE_NAME_FIELD
}
RANKSCORE.is_extendable = false
RANKSCORE.extensions = {}
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.name = "cmd"
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.full_name = ".Cmd.TransferFightRankFubenCmd.cmd"
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.number = 1
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.index = 0
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.label = 1
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.has_default_value = true
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.default_value = 11
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.type = 14
TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD.cpp_type = 8
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.name = "param"
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TransferFightRankFubenCmd.param"
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.number = 2
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.index = 1
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.label = 1
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.has_default_value = true
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.default_value = 70
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.type = 14
TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD.cpp_type = 8
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.name = "coldtime"
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.full_name = ".Cmd.TransferFightRankFubenCmd.coldtime"
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.number = 3
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.index = 2
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.label = 1
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.has_default_value = false
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.default_value = 0
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.type = 13
TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD.cpp_type = 3
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.name = "myscore"
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.full_name = ".Cmd.TransferFightRankFubenCmd.myscore"
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.number = 4
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.index = 3
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.label = 1
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.has_default_value = false
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.default_value = 0
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.type = 13
TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD.cpp_type = 3
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.name = "rank"
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.full_name = ".Cmd.TransferFightRankFubenCmd.rank"
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.number = 5
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.index = 4
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.label = 3
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.has_default_value = false
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.default_value = {}
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.message_type = RANKSCORE
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.type = 11
TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD.cpp_type = 10
TRANSFERFIGHTRANKFUBENCMD.name = "TransferFightRankFubenCmd"
TRANSFERFIGHTRANKFUBENCMD.full_name = ".Cmd.TransferFightRankFubenCmd"
TRANSFERFIGHTRANKFUBENCMD.nested_types = {}
TRANSFERFIGHTRANKFUBENCMD.enum_types = {}
TRANSFERFIGHTRANKFUBENCMD.fields = {
  TRANSFERFIGHTRANKFUBENCMD_CMD_FIELD,
  TRANSFERFIGHTRANKFUBENCMD_PARAM_FIELD,
  TRANSFERFIGHTRANKFUBENCMD_COLDTIME_FIELD,
  TRANSFERFIGHTRANKFUBENCMD_MYSCORE_FIELD,
  TRANSFERFIGHTRANKFUBENCMD_RANK_FIELD
}
TRANSFERFIGHTRANKFUBENCMD.is_extendable = false
TRANSFERFIGHTRANKFUBENCMD.extensions = {}
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.name = "cmd"
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.full_name = ".Cmd.TransferFightEndFubenCmd.cmd"
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.number = 1
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.index = 0
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.label = 1
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.has_default_value = true
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.default_value = 11
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.type = 14
TRANSFERFIGHTENDFUBENCMD_CMD_FIELD.cpp_type = 8
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.name = "param"
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TransferFightEndFubenCmd.param"
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.number = 2
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.index = 1
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.label = 1
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.has_default_value = true
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.default_value = 71
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.type = 14
TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD.cpp_type = 8
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.name = "rank"
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.full_name = ".Cmd.TransferFightEndFubenCmd.rank"
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.number = 3
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.index = 2
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.label = 3
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.has_default_value = false
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.default_value = {}
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.message_type = RANKSCORE
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.type = 11
TRANSFERFIGHTENDFUBENCMD_RANK_FIELD.cpp_type = 10
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.name = "myrank"
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.full_name = ".Cmd.TransferFightEndFubenCmd.myrank"
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.number = 4
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.index = 3
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.label = 1
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.has_default_value = false
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.default_value = nil
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.message_type = RANKSCORE
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.type = 11
TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD.cpp_type = 10
TRANSFERFIGHTENDFUBENCMD.name = "TransferFightEndFubenCmd"
TRANSFERFIGHTENDFUBENCMD.full_name = ".Cmd.TransferFightEndFubenCmd"
TRANSFERFIGHTENDFUBENCMD.nested_types = {}
TRANSFERFIGHTENDFUBENCMD.enum_types = {}
TRANSFERFIGHTENDFUBENCMD.fields = {
  TRANSFERFIGHTENDFUBENCMD_CMD_FIELD,
  TRANSFERFIGHTENDFUBENCMD_PARAM_FIELD,
  TRANSFERFIGHTENDFUBENCMD_RANK_FIELD,
  TRANSFERFIGHTENDFUBENCMD_MYRANK_FIELD
}
TRANSFERFIGHTENDFUBENCMD.is_extendable = false
TRANSFERFIGHTENDFUBENCMD.extensions = {}
INVITEROLLREWARDFUBENCMD_CMD_FIELD.name = "cmd"
INVITEROLLREWARDFUBENCMD_CMD_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.cmd"
INVITEROLLREWARDFUBENCMD_CMD_FIELD.number = 1
INVITEROLLREWARDFUBENCMD_CMD_FIELD.index = 0
INVITEROLLREWARDFUBENCMD_CMD_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_CMD_FIELD.has_default_value = true
INVITEROLLREWARDFUBENCMD_CMD_FIELD.default_value = 11
INVITEROLLREWARDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
INVITEROLLREWARDFUBENCMD_CMD_FIELD.type = 14
INVITEROLLREWARDFUBENCMD_CMD_FIELD.cpp_type = 8
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.name = "param"
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.param"
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.number = 2
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.index = 1
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.has_default_value = true
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.default_value = 82
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.type = 14
INVITEROLLREWARDFUBENCMD_PARAM_FIELD.cpp_type = 8
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.name = "etype"
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.etype"
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.number = 3
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.index = 2
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.has_default_value = true
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.default_value = 0
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.enum_type = EROLLRAIDREWARDTYPE
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.type = 14
INVITEROLLREWARDFUBENCMD_ETYPE_FIELD.cpp_type = 8
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.name = "param1"
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.param1"
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.number = 4
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.index = 3
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.has_default_value = false
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.default_value = 0
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.type = 13
INVITEROLLREWARDFUBENCMD_PARAM1_FIELD.cpp_type = 3
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.name = "costcoin"
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.costcoin"
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.number = 5
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.index = 4
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.has_default_value = false
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.default_value = 0
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.type = 13
INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD.cpp_type = 3
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.name = "count"
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.full_name = ".Cmd.InviteRollRewardFubenCmd.count"
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.number = 6
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.index = 5
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.label = 1
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.has_default_value = false
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.default_value = 0
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.type = 13
INVITEROLLREWARDFUBENCMD_COUNT_FIELD.cpp_type = 3
INVITEROLLREWARDFUBENCMD.name = "InviteRollRewardFubenCmd"
INVITEROLLREWARDFUBENCMD.full_name = ".Cmd.InviteRollRewardFubenCmd"
INVITEROLLREWARDFUBENCMD.nested_types = {}
INVITEROLLREWARDFUBENCMD.enum_types = {}
INVITEROLLREWARDFUBENCMD.fields = {
  INVITEROLLREWARDFUBENCMD_CMD_FIELD,
  INVITEROLLREWARDFUBENCMD_PARAM_FIELD,
  INVITEROLLREWARDFUBENCMD_ETYPE_FIELD,
  INVITEROLLREWARDFUBENCMD_PARAM1_FIELD,
  INVITEROLLREWARDFUBENCMD_COSTCOIN_FIELD,
  INVITEROLLREWARDFUBENCMD_COUNT_FIELD
}
INVITEROLLREWARDFUBENCMD.is_extendable = false
INVITEROLLREWARDFUBENCMD.extensions = {}
REPLYROLLREWARDFUBENCMD_CMD_FIELD.name = "cmd"
REPLYROLLREWARDFUBENCMD_CMD_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.cmd"
REPLYROLLREWARDFUBENCMD_CMD_FIELD.number = 1
REPLYROLLREWARDFUBENCMD_CMD_FIELD.index = 0
REPLYROLLREWARDFUBENCMD_CMD_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_CMD_FIELD.has_default_value = true
REPLYROLLREWARDFUBENCMD_CMD_FIELD.default_value = 11
REPLYROLLREWARDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REPLYROLLREWARDFUBENCMD_CMD_FIELD.type = 14
REPLYROLLREWARDFUBENCMD_CMD_FIELD.cpp_type = 8
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.name = "param"
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.param"
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.number = 2
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.index = 1
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.has_default_value = true
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.default_value = 83
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.type = 14
REPLYROLLREWARDFUBENCMD_PARAM_FIELD.cpp_type = 8
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.name = "agree"
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.agree"
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.number = 3
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.index = 2
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.has_default_value = false
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.default_value = false
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.type = 8
REPLYROLLREWARDFUBENCMD_AGREE_FIELD.cpp_type = 7
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.name = "etype"
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.etype"
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.number = 4
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.index = 3
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.has_default_value = false
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.default_value = nil
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.enum_type = EROLLRAIDREWARDTYPE
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.type = 14
REPLYROLLREWARDFUBENCMD_ETYPE_FIELD.cpp_type = 8
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.name = "param1"
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.param1"
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.number = 5
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.index = 4
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.has_default_value = false
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.default_value = 0
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.type = 13
REPLYROLLREWARDFUBENCMD_PARAM1_FIELD.cpp_type = 3
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.name = "gold_buy_price"
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.full_name = ".Cmd.ReplyRollRewardFubenCmd.gold_buy_price"
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.number = 6
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.index = 5
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.label = 1
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.has_default_value = false
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.default_value = 0
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.type = 13
REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD.cpp_type = 3
REPLYROLLREWARDFUBENCMD.name = "ReplyRollRewardFubenCmd"
REPLYROLLREWARDFUBENCMD.full_name = ".Cmd.ReplyRollRewardFubenCmd"
REPLYROLLREWARDFUBENCMD.nested_types = {}
REPLYROLLREWARDFUBENCMD.enum_types = {}
REPLYROLLREWARDFUBENCMD.fields = {
  REPLYROLLREWARDFUBENCMD_CMD_FIELD,
  REPLYROLLREWARDFUBENCMD_PARAM_FIELD,
  REPLYROLLREWARDFUBENCMD_AGREE_FIELD,
  REPLYROLLREWARDFUBENCMD_ETYPE_FIELD,
  REPLYROLLREWARDFUBENCMD_PARAM1_FIELD,
  REPLYROLLREWARDFUBENCMD_GOLD_BUY_PRICE_FIELD
}
REPLYROLLREWARDFUBENCMD.is_extendable = false
REPLYROLLREWARDFUBENCMD.extensions = {}
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.name = "cmd"
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamRollStatusFuBenCmd.cmd"
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.number = 1
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.index = 0
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.label = 1
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.has_default_value = true
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.default_value = 11
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.type = 14
TEAMROLLSTATUSFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.name = "param"
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamRollStatusFuBenCmd.param"
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.number = 2
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.index = 1
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.label = 1
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.default_value = 84
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.type = 14
TEAMROLLSTATUSFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.name = "addids"
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.full_name = ".Cmd.TeamRollStatusFuBenCmd.addids"
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.number = 3
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.index = 2
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.label = 3
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.has_default_value = false
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.default_value = {}
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.type = 13
TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD.cpp_type = 3
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.name = "delid"
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.full_name = ".Cmd.TeamRollStatusFuBenCmd.delid"
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.number = 4
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.index = 3
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.label = 1
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.has_default_value = false
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.default_value = 0
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.type = 13
TEAMROLLSTATUSFUBENCMD_DELID_FIELD.cpp_type = 3
TEAMROLLSTATUSFUBENCMD.name = "TeamRollStatusFuBenCmd"
TEAMROLLSTATUSFUBENCMD.full_name = ".Cmd.TeamRollStatusFuBenCmd"
TEAMROLLSTATUSFUBENCMD.nested_types = {}
TEAMROLLSTATUSFUBENCMD.enum_types = {}
TEAMROLLSTATUSFUBENCMD.fields = {
  TEAMROLLSTATUSFUBENCMD_CMD_FIELD,
  TEAMROLLSTATUSFUBENCMD_PARAM_FIELD,
  TEAMROLLSTATUSFUBENCMD_ADDIDS_FIELD,
  TEAMROLLSTATUSFUBENCMD_DELID_FIELD
}
TEAMROLLSTATUSFUBENCMD.is_extendable = false
TEAMROLLSTATUSFUBENCMD.extensions = {}
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.name = "cmd"
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.full_name = ".Cmd.PreReplyRollRewardFubenCmd.cmd"
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.number = 1
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.index = 0
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.label = 1
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.has_default_value = true
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.default_value = 11
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.type = 14
PREREPLYROLLREWARDFUBENCMD_CMD_FIELD.cpp_type = 8
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.name = "param"
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.PreReplyRollRewardFubenCmd.param"
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.number = 2
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.index = 1
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.label = 1
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.has_default_value = true
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.default_value = 85
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.type = 14
PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD.cpp_type = 8
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.name = "charid"
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.full_name = ".Cmd.PreReplyRollRewardFubenCmd.charid"
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.number = 3
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.index = 2
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.label = 1
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.has_default_value = false
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.default_value = 0
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.type = 4
PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD.cpp_type = 4
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.name = "etype"
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.full_name = ".Cmd.PreReplyRollRewardFubenCmd.etype"
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.number = 4
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.index = 3
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.label = 1
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.has_default_value = false
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.default_value = nil
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.enum_type = EROLLRAIDREWARDTYPE
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.type = 14
PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD.cpp_type = 8
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.name = "param1"
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.full_name = ".Cmd.PreReplyRollRewardFubenCmd.param1"
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.number = 5
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.index = 4
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.label = 1
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.has_default_value = false
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.default_value = 0
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.type = 13
PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD.cpp_type = 3
PREREPLYROLLREWARDFUBENCMD.name = "PreReplyRollRewardFubenCmd"
PREREPLYROLLREWARDFUBENCMD.full_name = ".Cmd.PreReplyRollRewardFubenCmd"
PREREPLYROLLREWARDFUBENCMD.nested_types = {}
PREREPLYROLLREWARDFUBENCMD.enum_types = {}
PREREPLYROLLREWARDFUBENCMD.fields = {
  PREREPLYROLLREWARDFUBENCMD_CMD_FIELD,
  PREREPLYROLLREWARDFUBENCMD_PARAM_FIELD,
  PREREPLYROLLREWARDFUBENCMD_CHARID_FIELD,
  PREREPLYROLLREWARDFUBENCMD_ETYPE_FIELD,
  PREREPLYROLLREWARDFUBENCMD_PARAM1_FIELD
}
PREREPLYROLLREWARDFUBENCMD.is_extendable = false
PREREPLYROLLREWARDFUBENCMD.extensions = {}
TWELVEPVPDATA_TYPE_FIELD.name = "type"
TWELVEPVPDATA_TYPE_FIELD.full_name = ".Cmd.TwelvePvpData.type"
TWELVEPVPDATA_TYPE_FIELD.number = 1
TWELVEPVPDATA_TYPE_FIELD.index = 0
TWELVEPVPDATA_TYPE_FIELD.label = 1
TWELVEPVPDATA_TYPE_FIELD.has_default_value = false
TWELVEPVPDATA_TYPE_FIELD.default_value = nil
TWELVEPVPDATA_TYPE_FIELD.enum_type = ETWELVEPVPDATATYPE
TWELVEPVPDATA_TYPE_FIELD.type = 14
TWELVEPVPDATA_TYPE_FIELD.cpp_type = 8
TWELVEPVPDATA_VALUE_FIELD.name = "value"
TWELVEPVPDATA_VALUE_FIELD.full_name = ".Cmd.TwelvePvpData.value"
TWELVEPVPDATA_VALUE_FIELD.number = 2
TWELVEPVPDATA_VALUE_FIELD.index = 1
TWELVEPVPDATA_VALUE_FIELD.label = 1
TWELVEPVPDATA_VALUE_FIELD.has_default_value = false
TWELVEPVPDATA_VALUE_FIELD.default_value = 0
TWELVEPVPDATA_VALUE_FIELD.type = 5
TWELVEPVPDATA_VALUE_FIELD.cpp_type = 1
TWELVEPVPDATA.name = "TwelvePvpData"
TWELVEPVPDATA.full_name = ".Cmd.TwelvePvpData"
TWELVEPVPDATA.nested_types = {}
TWELVEPVPDATA.enum_types = {}
TWELVEPVPDATA.fields = {
  TWELVEPVPDATA_TYPE_FIELD,
  TWELVEPVPDATA_VALUE_FIELD
}
TWELVEPVPDATA.is_extendable = false
TWELVEPVPDATA.extensions = {}
TWELVEPVPSYNCCMD_CMD_FIELD.name = "cmd"
TWELVEPVPSYNCCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpSyncCmd.cmd"
TWELVEPVPSYNCCMD_CMD_FIELD.number = 1
TWELVEPVPSYNCCMD_CMD_FIELD.index = 0
TWELVEPVPSYNCCMD_CMD_FIELD.label = 1
TWELVEPVPSYNCCMD_CMD_FIELD.has_default_value = true
TWELVEPVPSYNCCMD_CMD_FIELD.default_value = 11
TWELVEPVPSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPSYNCCMD_CMD_FIELD.type = 14
TWELVEPVPSYNCCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPSYNCCMD_PARAM_FIELD.name = "param"
TWELVEPVPSYNCCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpSyncCmd.param"
TWELVEPVPSYNCCMD_PARAM_FIELD.number = 2
TWELVEPVPSYNCCMD_PARAM_FIELD.index = 1
TWELVEPVPSYNCCMD_PARAM_FIELD.label = 1
TWELVEPVPSYNCCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPSYNCCMD_PARAM_FIELD.default_value = 72
TWELVEPVPSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPSYNCCMD_PARAM_FIELD.type = 14
TWELVEPVPSYNCCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPSYNCCMD_DATAS_FIELD.name = "datas"
TWELVEPVPSYNCCMD_DATAS_FIELD.full_name = ".Cmd.TwelvePvpSyncCmd.datas"
TWELVEPVPSYNCCMD_DATAS_FIELD.number = 3
TWELVEPVPSYNCCMD_DATAS_FIELD.index = 2
TWELVEPVPSYNCCMD_DATAS_FIELD.label = 3
TWELVEPVPSYNCCMD_DATAS_FIELD.has_default_value = false
TWELVEPVPSYNCCMD_DATAS_FIELD.default_value = {}
TWELVEPVPSYNCCMD_DATAS_FIELD.message_type = TWELVEPVPDATA
TWELVEPVPSYNCCMD_DATAS_FIELD.type = 11
TWELVEPVPSYNCCMD_DATAS_FIELD.cpp_type = 10
TWELVEPVPSYNCCMD_CAMP_FIELD.name = "camp"
TWELVEPVPSYNCCMD_CAMP_FIELD.full_name = ".Cmd.TwelvePvpSyncCmd.camp"
TWELVEPVPSYNCCMD_CAMP_FIELD.number = 4
TWELVEPVPSYNCCMD_CAMP_FIELD.index = 3
TWELVEPVPSYNCCMD_CAMP_FIELD.label = 1
TWELVEPVPSYNCCMD_CAMP_FIELD.has_default_value = false
TWELVEPVPSYNCCMD_CAMP_FIELD.default_value = nil
TWELVEPVPSYNCCMD_CAMP_FIELD.enum_type = EGROUPCAMP
TWELVEPVPSYNCCMD_CAMP_FIELD.type = 14
TWELVEPVPSYNCCMD_CAMP_FIELD.cpp_type = 8
TWELVEPVPSYNCCMD_CHARID_FIELD.name = "charid"
TWELVEPVPSYNCCMD_CHARID_FIELD.full_name = ".Cmd.TwelvePvpSyncCmd.charid"
TWELVEPVPSYNCCMD_CHARID_FIELD.number = 5
TWELVEPVPSYNCCMD_CHARID_FIELD.index = 4
TWELVEPVPSYNCCMD_CHARID_FIELD.label = 1
TWELVEPVPSYNCCMD_CHARID_FIELD.has_default_value = false
TWELVEPVPSYNCCMD_CHARID_FIELD.default_value = 0
TWELVEPVPSYNCCMD_CHARID_FIELD.type = 4
TWELVEPVPSYNCCMD_CHARID_FIELD.cpp_type = 4
TWELVEPVPSYNCCMD.name = "TwelvePvpSyncCmd"
TWELVEPVPSYNCCMD.full_name = ".Cmd.TwelvePvpSyncCmd"
TWELVEPVPSYNCCMD.nested_types = {}
TWELVEPVPSYNCCMD.enum_types = {}
TWELVEPVPSYNCCMD.fields = {
  TWELVEPVPSYNCCMD_CMD_FIELD,
  TWELVEPVPSYNCCMD_PARAM_FIELD,
  TWELVEPVPSYNCCMD_DATAS_FIELD,
  TWELVEPVPSYNCCMD_CAMP_FIELD,
  TWELVEPVPSYNCCMD_CHARID_FIELD
}
TWELVEPVPSYNCCMD.is_extendable = false
TWELVEPVPSYNCCMD.extensions = {}
TWEITEMINFO_ITEMID_FIELD.name = "itemid"
TWEITEMINFO_ITEMID_FIELD.full_name = ".Cmd.TweItemInfo.itemid"
TWEITEMINFO_ITEMID_FIELD.number = 1
TWEITEMINFO_ITEMID_FIELD.index = 0
TWEITEMINFO_ITEMID_FIELD.label = 1
TWEITEMINFO_ITEMID_FIELD.has_default_value = false
TWEITEMINFO_ITEMID_FIELD.default_value = 0
TWEITEMINFO_ITEMID_FIELD.type = 13
TWEITEMINFO_ITEMID_FIELD.cpp_type = 3
TWEITEMINFO_COUNT_FIELD.name = "count"
TWEITEMINFO_COUNT_FIELD.full_name = ".Cmd.TweItemInfo.count"
TWEITEMINFO_COUNT_FIELD.number = 2
TWEITEMINFO_COUNT_FIELD.index = 1
TWEITEMINFO_COUNT_FIELD.label = 1
TWEITEMINFO_COUNT_FIELD.has_default_value = false
TWEITEMINFO_COUNT_FIELD.default_value = 0
TWEITEMINFO_COUNT_FIELD.type = 13
TWEITEMINFO_COUNT_FIELD.cpp_type = 3
TWEITEMINFO.name = "TweItemInfo"
TWEITEMINFO.full_name = ".Cmd.TweItemInfo"
TWEITEMINFO.nested_types = {}
TWEITEMINFO.enum_types = {}
TWEITEMINFO.fields = {
  TWEITEMINFO_ITEMID_FIELD,
  TWEITEMINFO_COUNT_FIELD
}
TWEITEMINFO.is_extendable = false
TWEITEMINFO.extensions = {}
RAIDITEMSYNCCMD_CMD_FIELD.name = "cmd"
RAIDITEMSYNCCMD_CMD_FIELD.full_name = ".Cmd.RaidItemSyncCmd.cmd"
RAIDITEMSYNCCMD_CMD_FIELD.number = 1
RAIDITEMSYNCCMD_CMD_FIELD.index = 0
RAIDITEMSYNCCMD_CMD_FIELD.label = 1
RAIDITEMSYNCCMD_CMD_FIELD.has_default_value = true
RAIDITEMSYNCCMD_CMD_FIELD.default_value = 11
RAIDITEMSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDITEMSYNCCMD_CMD_FIELD.type = 14
RAIDITEMSYNCCMD_CMD_FIELD.cpp_type = 8
RAIDITEMSYNCCMD_PARAM_FIELD.name = "param"
RAIDITEMSYNCCMD_PARAM_FIELD.full_name = ".Cmd.RaidItemSyncCmd.param"
RAIDITEMSYNCCMD_PARAM_FIELD.number = 2
RAIDITEMSYNCCMD_PARAM_FIELD.index = 1
RAIDITEMSYNCCMD_PARAM_FIELD.label = 1
RAIDITEMSYNCCMD_PARAM_FIELD.has_default_value = true
RAIDITEMSYNCCMD_PARAM_FIELD.default_value = 73
RAIDITEMSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDITEMSYNCCMD_PARAM_FIELD.type = 14
RAIDITEMSYNCCMD_PARAM_FIELD.cpp_type = 8
RAIDITEMSYNCCMD_ITEMS_FIELD.name = "items"
RAIDITEMSYNCCMD_ITEMS_FIELD.full_name = ".Cmd.RaidItemSyncCmd.items"
RAIDITEMSYNCCMD_ITEMS_FIELD.number = 3
RAIDITEMSYNCCMD_ITEMS_FIELD.index = 2
RAIDITEMSYNCCMD_ITEMS_FIELD.label = 3
RAIDITEMSYNCCMD_ITEMS_FIELD.has_default_value = false
RAIDITEMSYNCCMD_ITEMS_FIELD.default_value = {}
RAIDITEMSYNCCMD_ITEMS_FIELD.message_type = TWEITEMINFO
RAIDITEMSYNCCMD_ITEMS_FIELD.type = 11
RAIDITEMSYNCCMD_ITEMS_FIELD.cpp_type = 10
RAIDITEMSYNCCMD_CHARID_FIELD.name = "charid"
RAIDITEMSYNCCMD_CHARID_FIELD.full_name = ".Cmd.RaidItemSyncCmd.charid"
RAIDITEMSYNCCMD_CHARID_FIELD.number = 5
RAIDITEMSYNCCMD_CHARID_FIELD.index = 3
RAIDITEMSYNCCMD_CHARID_FIELD.label = 1
RAIDITEMSYNCCMD_CHARID_FIELD.has_default_value = false
RAIDITEMSYNCCMD_CHARID_FIELD.default_value = 0
RAIDITEMSYNCCMD_CHARID_FIELD.type = 4
RAIDITEMSYNCCMD_CHARID_FIELD.cpp_type = 4
RAIDITEMSYNCCMD.name = "RaidItemSyncCmd"
RAIDITEMSYNCCMD.full_name = ".Cmd.RaidItemSyncCmd"
RAIDITEMSYNCCMD.nested_types = {}
RAIDITEMSYNCCMD.enum_types = {}
RAIDITEMSYNCCMD.fields = {
  RAIDITEMSYNCCMD_CMD_FIELD,
  RAIDITEMSYNCCMD_PARAM_FIELD,
  RAIDITEMSYNCCMD_ITEMS_FIELD,
  RAIDITEMSYNCCMD_CHARID_FIELD
}
RAIDITEMSYNCCMD.is_extendable = false
RAIDITEMSYNCCMD.extensions = {}
RAIDITEMUPDATECMD_CMD_FIELD.name = "cmd"
RAIDITEMUPDATECMD_CMD_FIELD.full_name = ".Cmd.RaidItemUpdateCmd.cmd"
RAIDITEMUPDATECMD_CMD_FIELD.number = 1
RAIDITEMUPDATECMD_CMD_FIELD.index = 0
RAIDITEMUPDATECMD_CMD_FIELD.label = 1
RAIDITEMUPDATECMD_CMD_FIELD.has_default_value = true
RAIDITEMUPDATECMD_CMD_FIELD.default_value = 11
RAIDITEMUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDITEMUPDATECMD_CMD_FIELD.type = 14
RAIDITEMUPDATECMD_CMD_FIELD.cpp_type = 8
RAIDITEMUPDATECMD_PARAM_FIELD.name = "param"
RAIDITEMUPDATECMD_PARAM_FIELD.full_name = ".Cmd.RaidItemUpdateCmd.param"
RAIDITEMUPDATECMD_PARAM_FIELD.number = 2
RAIDITEMUPDATECMD_PARAM_FIELD.index = 1
RAIDITEMUPDATECMD_PARAM_FIELD.label = 1
RAIDITEMUPDATECMD_PARAM_FIELD.has_default_value = true
RAIDITEMUPDATECMD_PARAM_FIELD.default_value = 74
RAIDITEMUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDITEMUPDATECMD_PARAM_FIELD.type = 14
RAIDITEMUPDATECMD_PARAM_FIELD.cpp_type = 8
RAIDITEMUPDATECMD_ITEMID_FIELD.name = "itemid"
RAIDITEMUPDATECMD_ITEMID_FIELD.full_name = ".Cmd.RaidItemUpdateCmd.itemid"
RAIDITEMUPDATECMD_ITEMID_FIELD.number = 3
RAIDITEMUPDATECMD_ITEMID_FIELD.index = 2
RAIDITEMUPDATECMD_ITEMID_FIELD.label = 1
RAIDITEMUPDATECMD_ITEMID_FIELD.has_default_value = false
RAIDITEMUPDATECMD_ITEMID_FIELD.default_value = 0
RAIDITEMUPDATECMD_ITEMID_FIELD.type = 13
RAIDITEMUPDATECMD_ITEMID_FIELD.cpp_type = 3
RAIDITEMUPDATECMD_COUNT_FIELD.name = "count"
RAIDITEMUPDATECMD_COUNT_FIELD.full_name = ".Cmd.RaidItemUpdateCmd.count"
RAIDITEMUPDATECMD_COUNT_FIELD.number = 4
RAIDITEMUPDATECMD_COUNT_FIELD.index = 3
RAIDITEMUPDATECMD_COUNT_FIELD.label = 1
RAIDITEMUPDATECMD_COUNT_FIELD.has_default_value = false
RAIDITEMUPDATECMD_COUNT_FIELD.default_value = 0
RAIDITEMUPDATECMD_COUNT_FIELD.type = 13
RAIDITEMUPDATECMD_COUNT_FIELD.cpp_type = 3
RAIDITEMUPDATECMD_CHARID_FIELD.name = "charid"
RAIDITEMUPDATECMD_CHARID_FIELD.full_name = ".Cmd.RaidItemUpdateCmd.charid"
RAIDITEMUPDATECMD_CHARID_FIELD.number = 5
RAIDITEMUPDATECMD_CHARID_FIELD.index = 4
RAIDITEMUPDATECMD_CHARID_FIELD.label = 1
RAIDITEMUPDATECMD_CHARID_FIELD.has_default_value = false
RAIDITEMUPDATECMD_CHARID_FIELD.default_value = 0
RAIDITEMUPDATECMD_CHARID_FIELD.type = 4
RAIDITEMUPDATECMD_CHARID_FIELD.cpp_type = 4
RAIDITEMUPDATECMD.name = "RaidItemUpdateCmd"
RAIDITEMUPDATECMD.full_name = ".Cmd.RaidItemUpdateCmd"
RAIDITEMUPDATECMD.nested_types = {}
RAIDITEMUPDATECMD.enum_types = {}
RAIDITEMUPDATECMD.fields = {
  RAIDITEMUPDATECMD_CMD_FIELD,
  RAIDITEMUPDATECMD_PARAM_FIELD,
  RAIDITEMUPDATECMD_ITEMID_FIELD,
  RAIDITEMUPDATECMD_COUNT_FIELD,
  RAIDITEMUPDATECMD_CHARID_FIELD
}
RAIDITEMUPDATECMD.is_extendable = false
RAIDITEMUPDATECMD.extensions = {}
TWELVEPVPUSEITEMCMD_CMD_FIELD.name = "cmd"
TWELVEPVPUSEITEMCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpUseItemCmd.cmd"
TWELVEPVPUSEITEMCMD_CMD_FIELD.number = 1
TWELVEPVPUSEITEMCMD_CMD_FIELD.index = 0
TWELVEPVPUSEITEMCMD_CMD_FIELD.label = 1
TWELVEPVPUSEITEMCMD_CMD_FIELD.has_default_value = true
TWELVEPVPUSEITEMCMD_CMD_FIELD.default_value = 11
TWELVEPVPUSEITEMCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPUSEITEMCMD_CMD_FIELD.type = 14
TWELVEPVPUSEITEMCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPUSEITEMCMD_PARAM_FIELD.name = "param"
TWELVEPVPUSEITEMCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpUseItemCmd.param"
TWELVEPVPUSEITEMCMD_PARAM_FIELD.number = 2
TWELVEPVPUSEITEMCMD_PARAM_FIELD.index = 1
TWELVEPVPUSEITEMCMD_PARAM_FIELD.label = 1
TWELVEPVPUSEITEMCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPUSEITEMCMD_PARAM_FIELD.default_value = 81
TWELVEPVPUSEITEMCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPUSEITEMCMD_PARAM_FIELD.type = 14
TWELVEPVPUSEITEMCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.name = "itemid"
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.full_name = ".Cmd.TwelvePvpUseItemCmd.itemid"
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.number = 3
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.index = 2
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.label = 1
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.has_default_value = true
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.default_value = 0
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.type = 13
TWELVEPVPUSEITEMCMD_ITEMID_FIELD.cpp_type = 3
TWELVEPVPUSEITEMCMD_COUNT_FIELD.name = "count"
TWELVEPVPUSEITEMCMD_COUNT_FIELD.full_name = ".Cmd.TwelvePvpUseItemCmd.count"
TWELVEPVPUSEITEMCMD_COUNT_FIELD.number = 4
TWELVEPVPUSEITEMCMD_COUNT_FIELD.index = 3
TWELVEPVPUSEITEMCMD_COUNT_FIELD.label = 1
TWELVEPVPUSEITEMCMD_COUNT_FIELD.has_default_value = true
TWELVEPVPUSEITEMCMD_COUNT_FIELD.default_value = 0
TWELVEPVPUSEITEMCMD_COUNT_FIELD.type = 13
TWELVEPVPUSEITEMCMD_COUNT_FIELD.cpp_type = 3
TWELVEPVPUSEITEMCMD.name = "TwelvePvpUseItemCmd"
TWELVEPVPUSEITEMCMD.full_name = ".Cmd.TwelvePvpUseItemCmd"
TWELVEPVPUSEITEMCMD.nested_types = {}
TWELVEPVPUSEITEMCMD.enum_types = {}
TWELVEPVPUSEITEMCMD.fields = {
  TWELVEPVPUSEITEMCMD_CMD_FIELD,
  TWELVEPVPUSEITEMCMD_PARAM_FIELD,
  TWELVEPVPUSEITEMCMD_ITEMID_FIELD,
  TWELVEPVPUSEITEMCMD_COUNT_FIELD
}
TWELVEPVPUSEITEMCMD.is_extendable = false
TWELVEPVPUSEITEMCMD.extensions = {}
RAIDSHOPUPDATECMD_CMD_FIELD.name = "cmd"
RAIDSHOPUPDATECMD_CMD_FIELD.full_name = ".Cmd.RaidShopUpdateCmd.cmd"
RAIDSHOPUPDATECMD_CMD_FIELD.number = 1
RAIDSHOPUPDATECMD_CMD_FIELD.index = 0
RAIDSHOPUPDATECMD_CMD_FIELD.label = 1
RAIDSHOPUPDATECMD_CMD_FIELD.has_default_value = true
RAIDSHOPUPDATECMD_CMD_FIELD.default_value = 11
RAIDSHOPUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDSHOPUPDATECMD_CMD_FIELD.type = 14
RAIDSHOPUPDATECMD_CMD_FIELD.cpp_type = 8
RAIDSHOPUPDATECMD_PARAM_FIELD.name = "param"
RAIDSHOPUPDATECMD_PARAM_FIELD.full_name = ".Cmd.RaidShopUpdateCmd.param"
RAIDSHOPUPDATECMD_PARAM_FIELD.number = 2
RAIDSHOPUPDATECMD_PARAM_FIELD.index = 1
RAIDSHOPUPDATECMD_PARAM_FIELD.label = 1
RAIDSHOPUPDATECMD_PARAM_FIELD.has_default_value = true
RAIDSHOPUPDATECMD_PARAM_FIELD.default_value = 75
RAIDSHOPUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDSHOPUPDATECMD_PARAM_FIELD.type = 14
RAIDSHOPUPDATECMD_PARAM_FIELD.cpp_type = 8
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.name = "shopitem_id"
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.full_name = ".Cmd.RaidShopUpdateCmd.shopitem_id"
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.number = 3
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.index = 2
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.label = 1
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.has_default_value = false
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.default_value = 0
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.type = 13
RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD.cpp_type = 3
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.name = "next_available_time"
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.full_name = ".Cmd.RaidShopUpdateCmd.next_available_time"
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.number = 4
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.index = 3
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.label = 1
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.has_default_value = false
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.default_value = 0
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.type = 13
RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD.cpp_type = 3
RAIDSHOPUPDATECMD.name = "RaidShopUpdateCmd"
RAIDSHOPUPDATECMD.full_name = ".Cmd.RaidShopUpdateCmd"
RAIDSHOPUPDATECMD.nested_types = {}
RAIDSHOPUPDATECMD.enum_types = {}
RAIDSHOPUPDATECMD.fields = {
  RAIDSHOPUPDATECMD_CMD_FIELD,
  RAIDSHOPUPDATECMD_PARAM_FIELD,
  RAIDSHOPUPDATECMD_SHOPITEM_ID_FIELD,
  RAIDSHOPUPDATECMD_NEXT_AVAILABLE_TIME_FIELD
}
RAIDSHOPUPDATECMD.is_extendable = false
RAIDSHOPUPDATECMD.extensions = {}
TWELVEPVPQUESTDATA_QUESTID_FIELD.name = "questid"
TWELVEPVPQUESTDATA_QUESTID_FIELD.full_name = ".Cmd.TwelvePvpQuestData.questid"
TWELVEPVPQUESTDATA_QUESTID_FIELD.number = 1
TWELVEPVPQUESTDATA_QUESTID_FIELD.index = 0
TWELVEPVPQUESTDATA_QUESTID_FIELD.label = 1
TWELVEPVPQUESTDATA_QUESTID_FIELD.has_default_value = false
TWELVEPVPQUESTDATA_QUESTID_FIELD.default_value = 0
TWELVEPVPQUESTDATA_QUESTID_FIELD.type = 13
TWELVEPVPQUESTDATA_QUESTID_FIELD.cpp_type = 3
TWELVEPVPQUESTDATA_PROGRESS_FIELD.name = "progress"
TWELVEPVPQUESTDATA_PROGRESS_FIELD.full_name = ".Cmd.TwelvePvpQuestData.progress"
TWELVEPVPQUESTDATA_PROGRESS_FIELD.number = 2
TWELVEPVPQUESTDATA_PROGRESS_FIELD.index = 1
TWELVEPVPQUESTDATA_PROGRESS_FIELD.label = 1
TWELVEPVPQUESTDATA_PROGRESS_FIELD.has_default_value = false
TWELVEPVPQUESTDATA_PROGRESS_FIELD.default_value = 0
TWELVEPVPQUESTDATA_PROGRESS_FIELD.type = 13
TWELVEPVPQUESTDATA_PROGRESS_FIELD.cpp_type = 3
TWELVEPVPQUESTDATA_FINISHED_FIELD.name = "finished"
TWELVEPVPQUESTDATA_FINISHED_FIELD.full_name = ".Cmd.TwelvePvpQuestData.finished"
TWELVEPVPQUESTDATA_FINISHED_FIELD.number = 3
TWELVEPVPQUESTDATA_FINISHED_FIELD.index = 2
TWELVEPVPQUESTDATA_FINISHED_FIELD.label = 1
TWELVEPVPQUESTDATA_FINISHED_FIELD.has_default_value = false
TWELVEPVPQUESTDATA_FINISHED_FIELD.default_value = false
TWELVEPVPQUESTDATA_FINISHED_FIELD.type = 8
TWELVEPVPQUESTDATA_FINISHED_FIELD.cpp_type = 7
TWELVEPVPQUESTDATA.name = "TwelvePvpQuestData"
TWELVEPVPQUESTDATA.full_name = ".Cmd.TwelvePvpQuestData"
TWELVEPVPQUESTDATA.nested_types = {}
TWELVEPVPQUESTDATA.enum_types = {}
TWELVEPVPQUESTDATA.fields = {
  TWELVEPVPQUESTDATA_QUESTID_FIELD,
  TWELVEPVPQUESTDATA_PROGRESS_FIELD,
  TWELVEPVPQUESTDATA_FINISHED_FIELD
}
TWELVEPVPQUESTDATA.is_extendable = false
TWELVEPVPQUESTDATA.extensions = {}
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.name = "cmd"
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpQuestQueryCmd.cmd"
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.number = 1
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.index = 0
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.label = 1
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.has_default_value = true
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.default_value = 11
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.type = 14
TWELVEPVPQUESTQUERYCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.name = "param"
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpQuestQueryCmd.param"
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.number = 2
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.index = 1
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.label = 1
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.default_value = 76
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.type = 14
TWELVEPVPQUESTQUERYCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.name = "datas"
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.full_name = ".Cmd.TwelvePvpQuestQueryCmd.datas"
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.number = 3
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.index = 2
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.label = 3
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.has_default_value = false
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.default_value = {}
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.message_type = TWELVEPVPQUESTDATA
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.type = 11
TWELVEPVPQUESTQUERYCMD_DATAS_FIELD.cpp_type = 10
TWELVEPVPQUESTQUERYCMD.name = "TwelvePvpQuestQueryCmd"
TWELVEPVPQUESTQUERYCMD.full_name = ".Cmd.TwelvePvpQuestQueryCmd"
TWELVEPVPQUESTQUERYCMD.nested_types = {}
TWELVEPVPQUESTQUERYCMD.enum_types = {}
TWELVEPVPQUESTQUERYCMD.fields = {
  TWELVEPVPQUESTQUERYCMD_CMD_FIELD,
  TWELVEPVPQUESTQUERYCMD_PARAM_FIELD,
  TWELVEPVPQUESTQUERYCMD_DATAS_FIELD
}
TWELVEPVPQUESTQUERYCMD.is_extendable = false
TWELVEPVPQUESTQUERYCMD.extensions = {}
TWELVEPVPUSERINFO_CHARID_FIELD.name = "charid"
TWELVEPVPUSERINFO_CHARID_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.charid"
TWELVEPVPUSERINFO_CHARID_FIELD.number = 1
TWELVEPVPUSERINFO_CHARID_FIELD.index = 0
TWELVEPVPUSERINFO_CHARID_FIELD.label = 1
TWELVEPVPUSERINFO_CHARID_FIELD.has_default_value = false
TWELVEPVPUSERINFO_CHARID_FIELD.default_value = 0
TWELVEPVPUSERINFO_CHARID_FIELD.type = 4
TWELVEPVPUSERINFO_CHARID_FIELD.cpp_type = 4
TWELVEPVPUSERINFO_NAME_FIELD.name = "name"
TWELVEPVPUSERINFO_NAME_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.name"
TWELVEPVPUSERINFO_NAME_FIELD.number = 2
TWELVEPVPUSERINFO_NAME_FIELD.index = 1
TWELVEPVPUSERINFO_NAME_FIELD.label = 1
TWELVEPVPUSERINFO_NAME_FIELD.has_default_value = false
TWELVEPVPUSERINFO_NAME_FIELD.default_value = ""
TWELVEPVPUSERINFO_NAME_FIELD.type = 9
TWELVEPVPUSERINFO_NAME_FIELD.cpp_type = 9
TWELVEPVPUSERINFO_KILLNUM_FIELD.name = "killnum"
TWELVEPVPUSERINFO_KILLNUM_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.killnum"
TWELVEPVPUSERINFO_KILLNUM_FIELD.number = 3
TWELVEPVPUSERINFO_KILLNUM_FIELD.index = 2
TWELVEPVPUSERINFO_KILLNUM_FIELD.label = 1
TWELVEPVPUSERINFO_KILLNUM_FIELD.has_default_value = false
TWELVEPVPUSERINFO_KILLNUM_FIELD.default_value = 0
TWELVEPVPUSERINFO_KILLNUM_FIELD.type = 13
TWELVEPVPUSERINFO_KILLNUM_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_DIENUM_FIELD.name = "dienum"
TWELVEPVPUSERINFO_DIENUM_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.dienum"
TWELVEPVPUSERINFO_DIENUM_FIELD.number = 4
TWELVEPVPUSERINFO_DIENUM_FIELD.index = 3
TWELVEPVPUSERINFO_DIENUM_FIELD.label = 1
TWELVEPVPUSERINFO_DIENUM_FIELD.has_default_value = false
TWELVEPVPUSERINFO_DIENUM_FIELD.default_value = 0
TWELVEPVPUSERINFO_DIENUM_FIELD.type = 13
TWELVEPVPUSERINFO_DIENUM_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_HEAL_FIELD.name = "heal"
TWELVEPVPUSERINFO_HEAL_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.heal"
TWELVEPVPUSERINFO_HEAL_FIELD.number = 5
TWELVEPVPUSERINFO_HEAL_FIELD.index = 4
TWELVEPVPUSERINFO_HEAL_FIELD.label = 1
TWELVEPVPUSERINFO_HEAL_FIELD.has_default_value = false
TWELVEPVPUSERINFO_HEAL_FIELD.default_value = 0
TWELVEPVPUSERINFO_HEAL_FIELD.type = 13
TWELVEPVPUSERINFO_HEAL_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_GOLD_FIELD.name = "gold"
TWELVEPVPUSERINFO_GOLD_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.gold"
TWELVEPVPUSERINFO_GOLD_FIELD.number = 6
TWELVEPVPUSERINFO_GOLD_FIELD.index = 5
TWELVEPVPUSERINFO_GOLD_FIELD.label = 1
TWELVEPVPUSERINFO_GOLD_FIELD.has_default_value = false
TWELVEPVPUSERINFO_GOLD_FIELD.default_value = 0
TWELVEPVPUSERINFO_GOLD_FIELD.type = 13
TWELVEPVPUSERINFO_GOLD_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.name = "crystal_exp"
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.crystal_exp"
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.number = 7
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.index = 6
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.label = 1
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.has_default_value = false
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.default_value = 0
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.type = 13
TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.name = "push_time"
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.push_time"
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.number = 8
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.index = 7
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.label = 1
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.has_default_value = false
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.default_value = 0
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.type = 13
TWELVEPVPUSERINFO_PUSH_TIME_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_KILL_MVP_FIELD.name = "kill_mvp"
TWELVEPVPUSERINFO_KILL_MVP_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.kill_mvp"
TWELVEPVPUSERINFO_KILL_MVP_FIELD.number = 9
TWELVEPVPUSERINFO_KILL_MVP_FIELD.index = 8
TWELVEPVPUSERINFO_KILL_MVP_FIELD.label = 1
TWELVEPVPUSERINFO_KILL_MVP_FIELD.has_default_value = false
TWELVEPVPUSERINFO_KILL_MVP_FIELD.default_value = 0
TWELVEPVPUSERINFO_KILL_MVP_FIELD.type = 13
TWELVEPVPUSERINFO_KILL_MVP_FIELD.cpp_type = 3
TWELVEPVPUSERINFO_PROFESSION_FIELD.name = "profession"
TWELVEPVPUSERINFO_PROFESSION_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.profession"
TWELVEPVPUSERINFO_PROFESSION_FIELD.number = 10
TWELVEPVPUSERINFO_PROFESSION_FIELD.index = 9
TWELVEPVPUSERINFO_PROFESSION_FIELD.label = 1
TWELVEPVPUSERINFO_PROFESSION_FIELD.has_default_value = false
TWELVEPVPUSERINFO_PROFESSION_FIELD.default_value = nil
TWELVEPVPUSERINFO_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
TWELVEPVPUSERINFO_PROFESSION_FIELD.type = 14
TWELVEPVPUSERINFO_PROFESSION_FIELD.cpp_type = 8
TWELVEPVPUSERINFO_HIDENAME_FIELD.name = "hidename"
TWELVEPVPUSERINFO_HIDENAME_FIELD.full_name = ".Cmd.TwelvePvpUserInfo.hidename"
TWELVEPVPUSERINFO_HIDENAME_FIELD.number = 11
TWELVEPVPUSERINFO_HIDENAME_FIELD.index = 10
TWELVEPVPUSERINFO_HIDENAME_FIELD.label = 1
TWELVEPVPUSERINFO_HIDENAME_FIELD.has_default_value = false
TWELVEPVPUSERINFO_HIDENAME_FIELD.default_value = false
TWELVEPVPUSERINFO_HIDENAME_FIELD.type = 8
TWELVEPVPUSERINFO_HIDENAME_FIELD.cpp_type = 7
TWELVEPVPUSERINFO.name = "TwelvePvpUserInfo"
TWELVEPVPUSERINFO.full_name = ".Cmd.TwelvePvpUserInfo"
TWELVEPVPUSERINFO.nested_types = {}
TWELVEPVPUSERINFO.enum_types = {}
TWELVEPVPUSERINFO.fields = {
  TWELVEPVPUSERINFO_CHARID_FIELD,
  TWELVEPVPUSERINFO_NAME_FIELD,
  TWELVEPVPUSERINFO_KILLNUM_FIELD,
  TWELVEPVPUSERINFO_DIENUM_FIELD,
  TWELVEPVPUSERINFO_HEAL_FIELD,
  TWELVEPVPUSERINFO_GOLD_FIELD,
  TWELVEPVPUSERINFO_CRYSTAL_EXP_FIELD,
  TWELVEPVPUSERINFO_PUSH_TIME_FIELD,
  TWELVEPVPUSERINFO_KILL_MVP_FIELD,
  TWELVEPVPUSERINFO_PROFESSION_FIELD,
  TWELVEPVPUSERINFO_HIDENAME_FIELD
}
TWELVEPVPUSERINFO.is_extendable = false
TWELVEPVPUSERINFO.extensions = {}
TWELVEPVPGROUPINFO_COLOR_FIELD.name = "color"
TWELVEPVPGROUPINFO_COLOR_FIELD.full_name = ".Cmd.TwelvePvpGroupInfo.color"
TWELVEPVPGROUPINFO_COLOR_FIELD.number = 1
TWELVEPVPGROUPINFO_COLOR_FIELD.index = 0
TWELVEPVPGROUPINFO_COLOR_FIELD.label = 1
TWELVEPVPGROUPINFO_COLOR_FIELD.has_default_value = false
TWELVEPVPGROUPINFO_COLOR_FIELD.default_value = nil
TWELVEPVPGROUPINFO_COLOR_FIELD.enum_type = EGROUPCAMP
TWELVEPVPGROUPINFO_COLOR_FIELD.type = 14
TWELVEPVPGROUPINFO_COLOR_FIELD.cpp_type = 8
TWELVEPVPGROUPINFO_USERINFOS_FIELD.name = "userinfos"
TWELVEPVPGROUPINFO_USERINFOS_FIELD.full_name = ".Cmd.TwelvePvpGroupInfo.userinfos"
TWELVEPVPGROUPINFO_USERINFOS_FIELD.number = 2
TWELVEPVPGROUPINFO_USERINFOS_FIELD.index = 1
TWELVEPVPGROUPINFO_USERINFOS_FIELD.label = 3
TWELVEPVPGROUPINFO_USERINFOS_FIELD.has_default_value = false
TWELVEPVPGROUPINFO_USERINFOS_FIELD.default_value = {}
TWELVEPVPGROUPINFO_USERINFOS_FIELD.message_type = TWELVEPVPUSERINFO
TWELVEPVPGROUPINFO_USERINFOS_FIELD.type = 11
TWELVEPVPGROUPINFO_USERINFOS_FIELD.cpp_type = 10
TWELVEPVPGROUPINFO.name = "TwelvePvpGroupInfo"
TWELVEPVPGROUPINFO.full_name = ".Cmd.TwelvePvpGroupInfo"
TWELVEPVPGROUPINFO.nested_types = {}
TWELVEPVPGROUPINFO.enum_types = {}
TWELVEPVPGROUPINFO.fields = {
  TWELVEPVPGROUPINFO_COLOR_FIELD,
  TWELVEPVPGROUPINFO_USERINFOS_FIELD
}
TWELVEPVPGROUPINFO.is_extendable = false
TWELVEPVPGROUPINFO.extensions = {}
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.name = "cmd"
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpQueryGroupInfoCmd.cmd"
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.number = 1
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.index = 0
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.label = 1
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.has_default_value = true
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.default_value = 11
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.type = 14
TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.name = "param"
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpQueryGroupInfoCmd.param"
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.number = 2
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.index = 1
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.label = 1
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.default_value = 77
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.type = 14
TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.name = "groupinfo"
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.full_name = ".Cmd.TwelvePvpQueryGroupInfoCmd.groupinfo"
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.number = 3
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.index = 2
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.label = 3
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.has_default_value = false
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.default_value = {}
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.message_type = TWELVEPVPGROUPINFO
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.type = 11
TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD.cpp_type = 10
TWELVEPVPQUERYGROUPINFOCMD.name = "TwelvePvpQueryGroupInfoCmd"
TWELVEPVPQUERYGROUPINFOCMD.full_name = ".Cmd.TwelvePvpQueryGroupInfoCmd"
TWELVEPVPQUERYGROUPINFOCMD.nested_types = {}
TWELVEPVPQUERYGROUPINFOCMD.enum_types = {}
TWELVEPVPQUERYGROUPINFOCMD.fields = {
  TWELVEPVPQUERYGROUPINFOCMD_CMD_FIELD,
  TWELVEPVPQUERYGROUPINFOCMD_PARAM_FIELD,
  TWELVEPVPQUERYGROUPINFOCMD_GROUPINFO_FIELD
}
TWELVEPVPQUERYGROUPINFOCMD.is_extendable = false
TWELVEPVPQUERYGROUPINFOCMD.extensions = {}
CAMPRESULTDATA_CAMP_FIELD.name = "camp"
CAMPRESULTDATA_CAMP_FIELD.full_name = ".Cmd.CampResultData.camp"
CAMPRESULTDATA_CAMP_FIELD.number = 1
CAMPRESULTDATA_CAMP_FIELD.index = 0
CAMPRESULTDATA_CAMP_FIELD.label = 1
CAMPRESULTDATA_CAMP_FIELD.has_default_value = false
CAMPRESULTDATA_CAMP_FIELD.default_value = nil
CAMPRESULTDATA_CAMP_FIELD.enum_type = EGROUPCAMP
CAMPRESULTDATA_CAMP_FIELD.type = 14
CAMPRESULTDATA_CAMP_FIELD.cpp_type = 8
CAMPRESULTDATA_KILL_NUM_FIELD.name = "kill_num"
CAMPRESULTDATA_KILL_NUM_FIELD.full_name = ".Cmd.CampResultData.kill_num"
CAMPRESULTDATA_KILL_NUM_FIELD.number = 2
CAMPRESULTDATA_KILL_NUM_FIELD.index = 1
CAMPRESULTDATA_KILL_NUM_FIELD.label = 1
CAMPRESULTDATA_KILL_NUM_FIELD.has_default_value = false
CAMPRESULTDATA_KILL_NUM_FIELD.default_value = 0
CAMPRESULTDATA_KILL_NUM_FIELD.type = 13
CAMPRESULTDATA_KILL_NUM_FIELD.cpp_type = 3
CAMPRESULTDATA_EXP_FIELD.name = "exp"
CAMPRESULTDATA_EXP_FIELD.full_name = ".Cmd.CampResultData.exp"
CAMPRESULTDATA_EXP_FIELD.number = 3
CAMPRESULTDATA_EXP_FIELD.index = 2
CAMPRESULTDATA_EXP_FIELD.label = 1
CAMPRESULTDATA_EXP_FIELD.has_default_value = false
CAMPRESULTDATA_EXP_FIELD.default_value = 0
CAMPRESULTDATA_EXP_FIELD.type = 13
CAMPRESULTDATA_EXP_FIELD.cpp_type = 3
CAMPRESULTDATA_KILL_MVP_FIELD.name = "kill_mvp"
CAMPRESULTDATA_KILL_MVP_FIELD.full_name = ".Cmd.CampResultData.kill_mvp"
CAMPRESULTDATA_KILL_MVP_FIELD.number = 4
CAMPRESULTDATA_KILL_MVP_FIELD.index = 3
CAMPRESULTDATA_KILL_MVP_FIELD.label = 1
CAMPRESULTDATA_KILL_MVP_FIELD.has_default_value = false
CAMPRESULTDATA_KILL_MVP_FIELD.default_value = 0
CAMPRESULTDATA_KILL_MVP_FIELD.type = 13
CAMPRESULTDATA_KILL_MVP_FIELD.cpp_type = 3
CAMPRESULTDATA.name = "CampResultData"
CAMPRESULTDATA.full_name = ".Cmd.CampResultData"
CAMPRESULTDATA.nested_types = {}
CAMPRESULTDATA.enum_types = {}
CAMPRESULTDATA.fields = {
  CAMPRESULTDATA_CAMP_FIELD,
  CAMPRESULTDATA_KILL_NUM_FIELD,
  CAMPRESULTDATA_EXP_FIELD,
  CAMPRESULTDATA_KILL_MVP_FIELD
}
CAMPRESULTDATA.is_extendable = false
CAMPRESULTDATA.extensions = {}
TWELVEPVPRESULTCMD_CMD_FIELD.name = "cmd"
TWELVEPVPRESULTCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpResultCmd.cmd"
TWELVEPVPRESULTCMD_CMD_FIELD.number = 1
TWELVEPVPRESULTCMD_CMD_FIELD.index = 0
TWELVEPVPRESULTCMD_CMD_FIELD.label = 1
TWELVEPVPRESULTCMD_CMD_FIELD.has_default_value = true
TWELVEPVPRESULTCMD_CMD_FIELD.default_value = 11
TWELVEPVPRESULTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPRESULTCMD_CMD_FIELD.type = 14
TWELVEPVPRESULTCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPRESULTCMD_PARAM_FIELD.name = "param"
TWELVEPVPRESULTCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpResultCmd.param"
TWELVEPVPRESULTCMD_PARAM_FIELD.number = 2
TWELVEPVPRESULTCMD_PARAM_FIELD.index = 1
TWELVEPVPRESULTCMD_PARAM_FIELD.label = 1
TWELVEPVPRESULTCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPRESULTCMD_PARAM_FIELD.default_value = 78
TWELVEPVPRESULTCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPRESULTCMD_PARAM_FIELD.type = 14
TWELVEPVPRESULTCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.name = "groupinfo_cmd"
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.full_name = ".Cmd.TwelvePvpResultCmd.groupinfo_cmd"
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.number = 3
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.index = 2
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.label = 1
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.has_default_value = false
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.default_value = nil
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.message_type = TWELVEPVPQUERYGROUPINFOCMD
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.type = 11
TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD.cpp_type = 10
TWELVEPVPRESULTCMD_WINTEAM_FIELD.name = "winteam"
TWELVEPVPRESULTCMD_WINTEAM_FIELD.full_name = ".Cmd.TwelvePvpResultCmd.winteam"
TWELVEPVPRESULTCMD_WINTEAM_FIELD.number = 4
TWELVEPVPRESULTCMD_WINTEAM_FIELD.index = 3
TWELVEPVPRESULTCMD_WINTEAM_FIELD.label = 1
TWELVEPVPRESULTCMD_WINTEAM_FIELD.has_default_value = false
TWELVEPVPRESULTCMD_WINTEAM_FIELD.default_value = nil
TWELVEPVPRESULTCMD_WINTEAM_FIELD.enum_type = EGROUPCAMP
TWELVEPVPRESULTCMD_WINTEAM_FIELD.type = 14
TWELVEPVPRESULTCMD_WINTEAM_FIELD.cpp_type = 8
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.name = "camp_result_data"
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.full_name = ".Cmd.TwelvePvpResultCmd.camp_result_data"
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.number = 5
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.index = 4
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.label = 3
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.has_default_value = false
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.default_value = {}
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.message_type = CAMPRESULTDATA
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.type = 11
TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD.cpp_type = 10
TWELVEPVPRESULTCMD.name = "TwelvePvpResultCmd"
TWELVEPVPRESULTCMD.full_name = ".Cmd.TwelvePvpResultCmd"
TWELVEPVPRESULTCMD.nested_types = {}
TWELVEPVPRESULTCMD.enum_types = {}
TWELVEPVPRESULTCMD.fields = {
  TWELVEPVPRESULTCMD_CMD_FIELD,
  TWELVEPVPRESULTCMD_PARAM_FIELD,
  TWELVEPVPRESULTCMD_GROUPINFO_CMD_FIELD,
  TWELVEPVPRESULTCMD_WINTEAM_FIELD,
  TWELVEPVPRESULTCMD_CAMP_RESULT_DATA_FIELD
}
TWELVEPVPRESULTCMD.is_extendable = false
TWELVEPVPRESULTCMD.extensions = {}
BUILDINGHP_BUILDING_ID_FIELD.name = "building_id"
BUILDINGHP_BUILDING_ID_FIELD.full_name = ".Cmd.BuildingHp.building_id"
BUILDINGHP_BUILDING_ID_FIELD.number = 1
BUILDINGHP_BUILDING_ID_FIELD.index = 0
BUILDINGHP_BUILDING_ID_FIELD.label = 1
BUILDINGHP_BUILDING_ID_FIELD.has_default_value = false
BUILDINGHP_BUILDING_ID_FIELD.default_value = 0
BUILDINGHP_BUILDING_ID_FIELD.type = 13
BUILDINGHP_BUILDING_ID_FIELD.cpp_type = 3
BUILDINGHP_HP_PER_FIELD.name = "hp_per"
BUILDINGHP_HP_PER_FIELD.full_name = ".Cmd.BuildingHp.hp_per"
BUILDINGHP_HP_PER_FIELD.number = 2
BUILDINGHP_HP_PER_FIELD.index = 1
BUILDINGHP_HP_PER_FIELD.label = 1
BUILDINGHP_HP_PER_FIELD.has_default_value = false
BUILDINGHP_HP_PER_FIELD.default_value = 0
BUILDINGHP_HP_PER_FIELD.type = 13
BUILDINGHP_HP_PER_FIELD.cpp_type = 3
BUILDINGHP.name = "BuildingHp"
BUILDINGHP.full_name = ".Cmd.BuildingHp"
BUILDINGHP.nested_types = {}
BUILDINGHP.enum_types = {}
BUILDINGHP.fields = {
  BUILDINGHP_BUILDING_ID_FIELD,
  BUILDINGHP_HP_PER_FIELD
}
BUILDINGHP.is_extendable = false
BUILDINGHP.extensions = {}
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.name = "cmd"
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpBuildingHpUpdateCmd.cmd"
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.number = 1
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.index = 0
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.label = 1
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.has_default_value = true
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.default_value = 11
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.type = 14
TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD.cpp_type = 8
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.name = "param"
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpBuildingHpUpdateCmd.param"
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.number = 2
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.index = 1
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.label = 1
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.has_default_value = true
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.default_value = 79
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.type = 14
TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.name = "data"
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.full_name = ".Cmd.TwelvePvpBuildingHpUpdateCmd.data"
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.number = 3
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.index = 2
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.label = 3
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.has_default_value = false
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.default_value = {}
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.message_type = BUILDINGHP
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.type = 11
TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD.cpp_type = 10
TWELVEPVPBUILDINGHPUPDATECMD.name = "TwelvePvpBuildingHpUpdateCmd"
TWELVEPVPBUILDINGHPUPDATECMD.full_name = ".Cmd.TwelvePvpBuildingHpUpdateCmd"
TWELVEPVPBUILDINGHPUPDATECMD.nested_types = {}
TWELVEPVPBUILDINGHPUPDATECMD.enum_types = {}
TWELVEPVPBUILDINGHPUPDATECMD.fields = {
  TWELVEPVPBUILDINGHPUPDATECMD_CMD_FIELD,
  TWELVEPVPBUILDINGHPUPDATECMD_PARAM_FIELD,
  TWELVEPVPBUILDINGHPUPDATECMD_DATA_FIELD
}
TWELVEPVPBUILDINGHPUPDATECMD.is_extendable = false
TWELVEPVPBUILDINGHPUPDATECMD.extensions = {}
TWELVEPVPUIOPERCMD_CMD_FIELD.name = "cmd"
TWELVEPVPUIOPERCMD_CMD_FIELD.full_name = ".Cmd.TwelvePvpUIOperCmd.cmd"
TWELVEPVPUIOPERCMD_CMD_FIELD.number = 1
TWELVEPVPUIOPERCMD_CMD_FIELD.index = 0
TWELVEPVPUIOPERCMD_CMD_FIELD.label = 1
TWELVEPVPUIOPERCMD_CMD_FIELD.has_default_value = true
TWELVEPVPUIOPERCMD_CMD_FIELD.default_value = 11
TWELVEPVPUIOPERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TWELVEPVPUIOPERCMD_CMD_FIELD.type = 14
TWELVEPVPUIOPERCMD_CMD_FIELD.cpp_type = 8
TWELVEPVPUIOPERCMD_PARAM_FIELD.name = "param"
TWELVEPVPUIOPERCMD_PARAM_FIELD.full_name = ".Cmd.TwelvePvpUIOperCmd.param"
TWELVEPVPUIOPERCMD_PARAM_FIELD.number = 2
TWELVEPVPUIOPERCMD_PARAM_FIELD.index = 1
TWELVEPVPUIOPERCMD_PARAM_FIELD.label = 1
TWELVEPVPUIOPERCMD_PARAM_FIELD.has_default_value = true
TWELVEPVPUIOPERCMD_PARAM_FIELD.default_value = 80
TWELVEPVPUIOPERCMD_PARAM_FIELD.enum_type = FUBENPARAM
TWELVEPVPUIOPERCMD_PARAM_FIELD.type = 14
TWELVEPVPUIOPERCMD_PARAM_FIELD.cpp_type = 8
TWELVEPVPUIOPERCMD_UI_FIELD.name = "ui"
TWELVEPVPUIOPERCMD_UI_FIELD.full_name = ".Cmd.TwelvePvpUIOperCmd.ui"
TWELVEPVPUIOPERCMD_UI_FIELD.number = 3
TWELVEPVPUIOPERCMD_UI_FIELD.index = 2
TWELVEPVPUIOPERCMD_UI_FIELD.label = 1
TWELVEPVPUIOPERCMD_UI_FIELD.has_default_value = false
TWELVEPVPUIOPERCMD_UI_FIELD.default_value = nil
TWELVEPVPUIOPERCMD_UI_FIELD.enum_type = ETWELVEPVPUI
TWELVEPVPUIOPERCMD_UI_FIELD.type = 14
TWELVEPVPUIOPERCMD_UI_FIELD.cpp_type = 8
TWELVEPVPUIOPERCMD_OPEN_FIELD.name = "open"
TWELVEPVPUIOPERCMD_OPEN_FIELD.full_name = ".Cmd.TwelvePvpUIOperCmd.open"
TWELVEPVPUIOPERCMD_OPEN_FIELD.number = 4
TWELVEPVPUIOPERCMD_OPEN_FIELD.index = 3
TWELVEPVPUIOPERCMD_OPEN_FIELD.label = 1
TWELVEPVPUIOPERCMD_OPEN_FIELD.has_default_value = false
TWELVEPVPUIOPERCMD_OPEN_FIELD.default_value = false
TWELVEPVPUIOPERCMD_OPEN_FIELD.type = 8
TWELVEPVPUIOPERCMD_OPEN_FIELD.cpp_type = 7
TWELVEPVPUIOPERCMD.name = "TwelvePvpUIOperCmd"
TWELVEPVPUIOPERCMD.full_name = ".Cmd.TwelvePvpUIOperCmd"
TWELVEPVPUIOPERCMD.nested_types = {}
TWELVEPVPUIOPERCMD.enum_types = {}
TWELVEPVPUIOPERCMD.fields = {
  TWELVEPVPUIOPERCMD_CMD_FIELD,
  TWELVEPVPUIOPERCMD_PARAM_FIELD,
  TWELVEPVPUIOPERCMD_UI_FIELD,
  TWELVEPVPUIOPERCMD_OPEN_FIELD
}
TWELVEPVPUIOPERCMD.is_extendable = false
TWELVEPVPUIOPERCMD.extensions = {}
RELIVECDFUBENCMD_CMD_FIELD.name = "cmd"
RELIVECDFUBENCMD_CMD_FIELD.full_name = ".Cmd.ReliveCdFubenCmd.cmd"
RELIVECDFUBENCMD_CMD_FIELD.number = 1
RELIVECDFUBENCMD_CMD_FIELD.index = 0
RELIVECDFUBENCMD_CMD_FIELD.label = 1
RELIVECDFUBENCMD_CMD_FIELD.has_default_value = true
RELIVECDFUBENCMD_CMD_FIELD.default_value = 11
RELIVECDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RELIVECDFUBENCMD_CMD_FIELD.type = 14
RELIVECDFUBENCMD_CMD_FIELD.cpp_type = 8
RELIVECDFUBENCMD_PARAM_FIELD.name = "param"
RELIVECDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ReliveCdFubenCmd.param"
RELIVECDFUBENCMD_PARAM_FIELD.number = 2
RELIVECDFUBENCMD_PARAM_FIELD.index = 1
RELIVECDFUBENCMD_PARAM_FIELD.label = 1
RELIVECDFUBENCMD_PARAM_FIELD.has_default_value = true
RELIVECDFUBENCMD_PARAM_FIELD.default_value = 86
RELIVECDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
RELIVECDFUBENCMD_PARAM_FIELD.type = 14
RELIVECDFUBENCMD_PARAM_FIELD.cpp_type = 8
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.name = "next_relive_time"
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.full_name = ".Cmd.ReliveCdFubenCmd.next_relive_time"
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.number = 3
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.index = 2
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.label = 1
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.has_default_value = false
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.default_value = 0
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.type = 13
RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD.cpp_type = 3
RELIVECDFUBENCMD.name = "ReliveCdFubenCmd"
RELIVECDFUBENCMD.full_name = ".Cmd.ReliveCdFubenCmd"
RELIVECDFUBENCMD.nested_types = {}
RELIVECDFUBENCMD.enum_types = {}
RELIVECDFUBENCMD.fields = {
  RELIVECDFUBENCMD_CMD_FIELD,
  RELIVECDFUBENCMD_PARAM_FIELD,
  RELIVECDFUBENCMD_NEXT_RELIVE_TIME_FIELD
}
RELIVECDFUBENCMD.is_extendable = false
RELIVECDFUBENCMD.extensions = {}
POSDATA_ID_FIELD.name = "id"
POSDATA_ID_FIELD.full_name = ".Cmd.PosData.id"
POSDATA_ID_FIELD.number = 3
POSDATA_ID_FIELD.index = 0
POSDATA_ID_FIELD.label = 1
POSDATA_ID_FIELD.has_default_value = false
POSDATA_ID_FIELD.default_value = 0
POSDATA_ID_FIELD.type = 4
POSDATA_ID_FIELD.cpp_type = 4
POSDATA_POS_FIELD.name = "pos"
POSDATA_POS_FIELD.full_name = ".Cmd.PosData.pos"
POSDATA_POS_FIELD.number = 4
POSDATA_POS_FIELD.index = 1
POSDATA_POS_FIELD.label = 1
POSDATA_POS_FIELD.has_default_value = false
POSDATA_POS_FIELD.default_value = nil
POSDATA_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
POSDATA_POS_FIELD.type = 11
POSDATA_POS_FIELD.cpp_type = 10
POSDATA_NPCID_FIELD.name = "npcid"
POSDATA_NPCID_FIELD.full_name = ".Cmd.PosData.npcid"
POSDATA_NPCID_FIELD.number = 5
POSDATA_NPCID_FIELD.index = 2
POSDATA_NPCID_FIELD.label = 1
POSDATA_NPCID_FIELD.has_default_value = false
POSDATA_NPCID_FIELD.default_value = 0
POSDATA_NPCID_FIELD.type = 13
POSDATA_NPCID_FIELD.cpp_type = 3
POSDATA_CAMP_FIELD.name = "camp"
POSDATA_CAMP_FIELD.full_name = ".Cmd.PosData.camp"
POSDATA_CAMP_FIELD.number = 6
POSDATA_CAMP_FIELD.index = 3
POSDATA_CAMP_FIELD.label = 1
POSDATA_CAMP_FIELD.has_default_value = false
POSDATA_CAMP_FIELD.default_value = 0
POSDATA_CAMP_FIELD.type = 13
POSDATA_CAMP_FIELD.cpp_type = 3
POSDATA.name = "PosData"
POSDATA.full_name = ".Cmd.PosData"
POSDATA.nested_types = {}
POSDATA.enum_types = {}
POSDATA.fields = {
  POSDATA_ID_FIELD,
  POSDATA_POS_FIELD,
  POSDATA_NPCID_FIELD,
  POSDATA_CAMP_FIELD
}
POSDATA.is_extendable = false
POSDATA.extensions = {}
POSSYNCFUBENCMD_CMD_FIELD.name = "cmd"
POSSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.PosSyncFubenCmd.cmd"
POSSYNCFUBENCMD_CMD_FIELD.number = 1
POSSYNCFUBENCMD_CMD_FIELD.index = 0
POSSYNCFUBENCMD_CMD_FIELD.label = 1
POSSYNCFUBENCMD_CMD_FIELD.has_default_value = true
POSSYNCFUBENCMD_CMD_FIELD.default_value = 11
POSSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
POSSYNCFUBENCMD_CMD_FIELD.type = 14
POSSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
POSSYNCFUBENCMD_PARAM_FIELD.name = "param"
POSSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.PosSyncFubenCmd.param"
POSSYNCFUBENCMD_PARAM_FIELD.number = 2
POSSYNCFUBENCMD_PARAM_FIELD.index = 1
POSSYNCFUBENCMD_PARAM_FIELD.label = 1
POSSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
POSSYNCFUBENCMD_PARAM_FIELD.default_value = 87
POSSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
POSSYNCFUBENCMD_PARAM_FIELD.type = 14
POSSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
POSSYNCFUBENCMD_DATAS_FIELD.name = "datas"
POSSYNCFUBENCMD_DATAS_FIELD.full_name = ".Cmd.PosSyncFubenCmd.datas"
POSSYNCFUBENCMD_DATAS_FIELD.number = 3
POSSYNCFUBENCMD_DATAS_FIELD.index = 2
POSSYNCFUBENCMD_DATAS_FIELD.label = 3
POSSYNCFUBENCMD_DATAS_FIELD.has_default_value = false
POSSYNCFUBENCMD_DATAS_FIELD.default_value = {}
POSSYNCFUBENCMD_DATAS_FIELD.message_type = POSDATA
POSSYNCFUBENCMD_DATAS_FIELD.type = 11
POSSYNCFUBENCMD_DATAS_FIELD.cpp_type = 10
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.name = "out_scope_ids"
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.full_name = ".Cmd.PosSyncFubenCmd.out_scope_ids"
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.number = 4
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.index = 3
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.label = 3
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.has_default_value = false
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.default_value = {}
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.type = 4
POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD.cpp_type = 4
POSSYNCFUBENCMD.name = "PosSyncFubenCmd"
POSSYNCFUBENCMD.full_name = ".Cmd.PosSyncFubenCmd"
POSSYNCFUBENCMD.nested_types = {}
POSSYNCFUBENCMD.enum_types = {}
POSSYNCFUBENCMD.fields = {
  POSSYNCFUBENCMD_CMD_FIELD,
  POSSYNCFUBENCMD_PARAM_FIELD,
  POSSYNCFUBENCMD_DATAS_FIELD,
  POSSYNCFUBENCMD_OUT_SCOPE_IDS_FIELD
}
POSSYNCFUBENCMD.is_extendable = false
POSSYNCFUBENCMD.extensions = {}
REQENTERTOWERPRIVATE_CMD_FIELD.name = "cmd"
REQENTERTOWERPRIVATE_CMD_FIELD.full_name = ".Cmd.ReqEnterTowerPrivate.cmd"
REQENTERTOWERPRIVATE_CMD_FIELD.number = 1
REQENTERTOWERPRIVATE_CMD_FIELD.index = 0
REQENTERTOWERPRIVATE_CMD_FIELD.label = 1
REQENTERTOWERPRIVATE_CMD_FIELD.has_default_value = true
REQENTERTOWERPRIVATE_CMD_FIELD.default_value = 11
REQENTERTOWERPRIVATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
REQENTERTOWERPRIVATE_CMD_FIELD.type = 14
REQENTERTOWERPRIVATE_CMD_FIELD.cpp_type = 8
REQENTERTOWERPRIVATE_PARAM_FIELD.name = "param"
REQENTERTOWERPRIVATE_PARAM_FIELD.full_name = ".Cmd.ReqEnterTowerPrivate.param"
REQENTERTOWERPRIVATE_PARAM_FIELD.number = 2
REQENTERTOWERPRIVATE_PARAM_FIELD.index = 1
REQENTERTOWERPRIVATE_PARAM_FIELD.label = 1
REQENTERTOWERPRIVATE_PARAM_FIELD.has_default_value = true
REQENTERTOWERPRIVATE_PARAM_FIELD.default_value = 88
REQENTERTOWERPRIVATE_PARAM_FIELD.enum_type = FUBENPARAM
REQENTERTOWERPRIVATE_PARAM_FIELD.type = 14
REQENTERTOWERPRIVATE_PARAM_FIELD.cpp_type = 8
REQENTERTOWERPRIVATE_RAIDID_FIELD.name = "raidid"
REQENTERTOWERPRIVATE_RAIDID_FIELD.full_name = ".Cmd.ReqEnterTowerPrivate.raidid"
REQENTERTOWERPRIVATE_RAIDID_FIELD.number = 3
REQENTERTOWERPRIVATE_RAIDID_FIELD.index = 2
REQENTERTOWERPRIVATE_RAIDID_FIELD.label = 1
REQENTERTOWERPRIVATE_RAIDID_FIELD.has_default_value = false
REQENTERTOWERPRIVATE_RAIDID_FIELD.default_value = 0
REQENTERTOWERPRIVATE_RAIDID_FIELD.type = 13
REQENTERTOWERPRIVATE_RAIDID_FIELD.cpp_type = 3
REQENTERTOWERPRIVATE.name = "ReqEnterTowerPrivate"
REQENTERTOWERPRIVATE.full_name = ".Cmd.ReqEnterTowerPrivate"
REQENTERTOWERPRIVATE.nested_types = {}
REQENTERTOWERPRIVATE.enum_types = {}
REQENTERTOWERPRIVATE.fields = {
  REQENTERTOWERPRIVATE_CMD_FIELD,
  REQENTERTOWERPRIVATE_PARAM_FIELD,
  REQENTERTOWERPRIVATE_RAIDID_FIELD
}
REQENTERTOWERPRIVATE.is_extendable = false
REQENTERTOWERPRIVATE.extensions = {}
LAYERMONSTERTOWERPRIVATE_ID_FIELD.name = "id"
LAYERMONSTERTOWERPRIVATE_ID_FIELD.full_name = ".Cmd.LayerMonsterTowerPrivate.id"
LAYERMONSTERTOWERPRIVATE_ID_FIELD.number = 1
LAYERMONSTERTOWERPRIVATE_ID_FIELD.index = 0
LAYERMONSTERTOWERPRIVATE_ID_FIELD.label = 1
LAYERMONSTERTOWERPRIVATE_ID_FIELD.has_default_value = false
LAYERMONSTERTOWERPRIVATE_ID_FIELD.default_value = 0
LAYERMONSTERTOWERPRIVATE_ID_FIELD.type = 13
LAYERMONSTERTOWERPRIVATE_ID_FIELD.cpp_type = 3
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.name = "type"
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.full_name = ".Cmd.LayerMonsterTowerPrivate.type"
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.number = 2
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.index = 1
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.label = 1
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.has_default_value = false
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.default_value = nil
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.enum_type = EENDLESSPRIVATEMONSTERTYPE
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.type = 14
LAYERMONSTERTOWERPRIVATE_TYPE_FIELD.cpp_type = 8
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.name = "count"
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.full_name = ".Cmd.LayerMonsterTowerPrivate.count"
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.number = 3
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.index = 2
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.label = 1
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.has_default_value = false
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.default_value = 0
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.type = 13
LAYERMONSTERTOWERPRIVATE_COUNT_FIELD.cpp_type = 3
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.name = "icon"
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.full_name = ".Cmd.LayerMonsterTowerPrivate.icon"
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.number = 4
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.index = 3
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.label = 1
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.has_default_value = false
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.default_value = 0
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.type = 13
LAYERMONSTERTOWERPRIVATE_ICON_FIELD.cpp_type = 3
LAYERMONSTERTOWERPRIVATE.name = "LayerMonsterTowerPrivate"
LAYERMONSTERTOWERPRIVATE.full_name = ".Cmd.LayerMonsterTowerPrivate"
LAYERMONSTERTOWERPRIVATE.nested_types = {}
LAYERMONSTERTOWERPRIVATE.enum_types = {}
LAYERMONSTERTOWERPRIVATE.fields = {
  LAYERMONSTERTOWERPRIVATE_ID_FIELD,
  LAYERMONSTERTOWERPRIVATE_TYPE_FIELD,
  LAYERMONSTERTOWERPRIVATE_COUNT_FIELD,
  LAYERMONSTERTOWERPRIVATE_ICON_FIELD
}
LAYERMONSTERTOWERPRIVATE.is_extendable = false
LAYERMONSTERTOWERPRIVATE.extensions = {}
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.name = "itemid"
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.full_name = ".Cmd.LayerRewardTowerPrivate.itemid"
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.number = 1
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.index = 0
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.label = 1
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.has_default_value = false
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.default_value = 0
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.type = 13
LAYERREWARDTOWERPRIVATE_ITEMID_FIELD.cpp_type = 3
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.name = "count"
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.full_name = ".Cmd.LayerRewardTowerPrivate.count"
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.number = 2
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.index = 1
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.label = 1
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.has_default_value = false
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.default_value = 0
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.type = 13
LAYERREWARDTOWERPRIVATE_COUNT_FIELD.cpp_type = 3
LAYERREWARDTOWERPRIVATE.name = "LayerRewardTowerPrivate"
LAYERREWARDTOWERPRIVATE.full_name = ".Cmd.LayerRewardTowerPrivate"
LAYERREWARDTOWERPRIVATE.nested_types = {}
LAYERREWARDTOWERPRIVATE.enum_types = {}
LAYERREWARDTOWERPRIVATE.fields = {
  LAYERREWARDTOWERPRIVATE_ITEMID_FIELD,
  LAYERREWARDTOWERPRIVATE_COUNT_FIELD
}
LAYERREWARDTOWERPRIVATE.is_extendable = false
LAYERREWARDTOWERPRIVATE.extensions = {}
TOWERPRIVATELAYERINFO_CMD_FIELD.name = "cmd"
TOWERPRIVATELAYERINFO_CMD_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.cmd"
TOWERPRIVATELAYERINFO_CMD_FIELD.number = 1
TOWERPRIVATELAYERINFO_CMD_FIELD.index = 0
TOWERPRIVATELAYERINFO_CMD_FIELD.label = 1
TOWERPRIVATELAYERINFO_CMD_FIELD.has_default_value = true
TOWERPRIVATELAYERINFO_CMD_FIELD.default_value = 11
TOWERPRIVATELAYERINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TOWERPRIVATELAYERINFO_CMD_FIELD.type = 14
TOWERPRIVATELAYERINFO_CMD_FIELD.cpp_type = 8
TOWERPRIVATELAYERINFO_PARAM_FIELD.name = "param"
TOWERPRIVATELAYERINFO_PARAM_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.param"
TOWERPRIVATELAYERINFO_PARAM_FIELD.number = 2
TOWERPRIVATELAYERINFO_PARAM_FIELD.index = 1
TOWERPRIVATELAYERINFO_PARAM_FIELD.label = 1
TOWERPRIVATELAYERINFO_PARAM_FIELD.has_default_value = true
TOWERPRIVATELAYERINFO_PARAM_FIELD.default_value = 89
TOWERPRIVATELAYERINFO_PARAM_FIELD.enum_type = FUBENPARAM
TOWERPRIVATELAYERINFO_PARAM_FIELD.type = 14
TOWERPRIVATELAYERINFO_PARAM_FIELD.cpp_type = 8
TOWERPRIVATELAYERINFO_RAIDID_FIELD.name = "raidid"
TOWERPRIVATELAYERINFO_RAIDID_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.raidid"
TOWERPRIVATELAYERINFO_RAIDID_FIELD.number = 3
TOWERPRIVATELAYERINFO_RAIDID_FIELD.index = 2
TOWERPRIVATELAYERINFO_RAIDID_FIELD.label = 1
TOWERPRIVATELAYERINFO_RAIDID_FIELD.has_default_value = false
TOWERPRIVATELAYERINFO_RAIDID_FIELD.default_value = 0
TOWERPRIVATELAYERINFO_RAIDID_FIELD.type = 13
TOWERPRIVATELAYERINFO_RAIDID_FIELD.cpp_type = 3
TOWERPRIVATELAYERINFO_LAYER_FIELD.name = "layer"
TOWERPRIVATELAYERINFO_LAYER_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.layer"
TOWERPRIVATELAYERINFO_LAYER_FIELD.number = 4
TOWERPRIVATELAYERINFO_LAYER_FIELD.index = 3
TOWERPRIVATELAYERINFO_LAYER_FIELD.label = 1
TOWERPRIVATELAYERINFO_LAYER_FIELD.has_default_value = false
TOWERPRIVATELAYERINFO_LAYER_FIELD.default_value = 0
TOWERPRIVATELAYERINFO_LAYER_FIELD.type = 13
TOWERPRIVATELAYERINFO_LAYER_FIELD.cpp_type = 3
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.name = "monsters"
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.monsters"
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.number = 5
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.index = 4
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.label = 3
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.has_default_value = false
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.default_value = {}
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.message_type = LAYERMONSTERTOWERPRIVATE
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.type = 11
TOWERPRIVATELAYERINFO_MONSTERS_FIELD.cpp_type = 10
TOWERPRIVATELAYERINFO_REWARDS_FIELD.name = "rewards"
TOWERPRIVATELAYERINFO_REWARDS_FIELD.full_name = ".Cmd.TowerPrivateLayerInfo.rewards"
TOWERPRIVATELAYERINFO_REWARDS_FIELD.number = 6
TOWERPRIVATELAYERINFO_REWARDS_FIELD.index = 5
TOWERPRIVATELAYERINFO_REWARDS_FIELD.label = 3
TOWERPRIVATELAYERINFO_REWARDS_FIELD.has_default_value = false
TOWERPRIVATELAYERINFO_REWARDS_FIELD.default_value = {}
TOWERPRIVATELAYERINFO_REWARDS_FIELD.message_type = LAYERREWARDTOWERPRIVATE
TOWERPRIVATELAYERINFO_REWARDS_FIELD.type = 11
TOWERPRIVATELAYERINFO_REWARDS_FIELD.cpp_type = 10
TOWERPRIVATELAYERINFO.name = "TowerPrivateLayerInfo"
TOWERPRIVATELAYERINFO.full_name = ".Cmd.TowerPrivateLayerInfo"
TOWERPRIVATELAYERINFO.nested_types = {}
TOWERPRIVATELAYERINFO.enum_types = {}
TOWERPRIVATELAYERINFO.fields = {
  TOWERPRIVATELAYERINFO_CMD_FIELD,
  TOWERPRIVATELAYERINFO_PARAM_FIELD,
  TOWERPRIVATELAYERINFO_RAIDID_FIELD,
  TOWERPRIVATELAYERINFO_LAYER_FIELD,
  TOWERPRIVATELAYERINFO_MONSTERS_FIELD,
  TOWERPRIVATELAYERINFO_REWARDS_FIELD
}
TOWERPRIVATELAYERINFO.is_extendable = false
TOWERPRIVATELAYERINFO.extensions = {}
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.name = "cmd"
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.full_name = ".Cmd.TowerPrivateLayerCountdownNtf.cmd"
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.number = 1
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.index = 0
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.label = 1
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.has_default_value = true
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.default_value = 11
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.type = 14
TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD.cpp_type = 8
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.name = "param"
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.full_name = ".Cmd.TowerPrivateLayerCountdownNtf.param"
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.number = 2
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.index = 1
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.label = 1
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.has_default_value = true
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.default_value = 90
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.enum_type = FUBENPARAM
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.type = 14
TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD.cpp_type = 8
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.name = "overat"
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.full_name = ".Cmd.TowerPrivateLayerCountdownNtf.overat"
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.number = 3
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.index = 2
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.label = 1
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.has_default_value = false
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.default_value = 0
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.type = 13
TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD.cpp_type = 3
TOWERPRIVATELAYERCOUNTDOWNNTF.name = "TowerPrivateLayerCountdownNtf"
TOWERPRIVATELAYERCOUNTDOWNNTF.full_name = ".Cmd.TowerPrivateLayerCountdownNtf"
TOWERPRIVATELAYERCOUNTDOWNNTF.nested_types = {}
TOWERPRIVATELAYERCOUNTDOWNNTF.enum_types = {}
TOWERPRIVATELAYERCOUNTDOWNNTF.fields = {
  TOWERPRIVATELAYERCOUNTDOWNNTF_CMD_FIELD,
  TOWERPRIVATELAYERCOUNTDOWNNTF_PARAM_FIELD,
  TOWERPRIVATELAYERCOUNTDOWNNTF_OVERAT_FIELD
}
TOWERPRIVATELAYERCOUNTDOWNNTF.is_extendable = false
TOWERPRIVATELAYERCOUNTDOWNNTF.extensions = {}
FUBENRESULTNTF_CMD_FIELD.name = "cmd"
FUBENRESULTNTF_CMD_FIELD.full_name = ".Cmd.FubenResultNtf.cmd"
FUBENRESULTNTF_CMD_FIELD.number = 1
FUBENRESULTNTF_CMD_FIELD.index = 0
FUBENRESULTNTF_CMD_FIELD.label = 1
FUBENRESULTNTF_CMD_FIELD.has_default_value = true
FUBENRESULTNTF_CMD_FIELD.default_value = 11
FUBENRESULTNTF_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FUBENRESULTNTF_CMD_FIELD.type = 14
FUBENRESULTNTF_CMD_FIELD.cpp_type = 8
FUBENRESULTNTF_PARAM_FIELD.name = "param"
FUBENRESULTNTF_PARAM_FIELD.full_name = ".Cmd.FubenResultNtf.param"
FUBENRESULTNTF_PARAM_FIELD.number = 2
FUBENRESULTNTF_PARAM_FIELD.index = 1
FUBENRESULTNTF_PARAM_FIELD.label = 1
FUBENRESULTNTF_PARAM_FIELD.has_default_value = true
FUBENRESULTNTF_PARAM_FIELD.default_value = 91
FUBENRESULTNTF_PARAM_FIELD.enum_type = FUBENPARAM
FUBENRESULTNTF_PARAM_FIELD.type = 14
FUBENRESULTNTF_PARAM_FIELD.cpp_type = 8
FUBENRESULTNTF_RAIDTYPE_FIELD.name = "raidtype"
FUBENRESULTNTF_RAIDTYPE_FIELD.full_name = ".Cmd.FubenResultNtf.raidtype"
FUBENRESULTNTF_RAIDTYPE_FIELD.number = 3
FUBENRESULTNTF_RAIDTYPE_FIELD.index = 2
FUBENRESULTNTF_RAIDTYPE_FIELD.label = 1
FUBENRESULTNTF_RAIDTYPE_FIELD.has_default_value = true
FUBENRESULTNTF_RAIDTYPE_FIELD.default_value = 0
FUBENRESULTNTF_RAIDTYPE_FIELD.enum_type = ERAIDTYPE
FUBENRESULTNTF_RAIDTYPE_FIELD.type = 14
FUBENRESULTNTF_RAIDTYPE_FIELD.cpp_type = 8
FUBENRESULTNTF_ISWIN_FIELD.name = "iswin"
FUBENRESULTNTF_ISWIN_FIELD.full_name = ".Cmd.FubenResultNtf.iswin"
FUBENRESULTNTF_ISWIN_FIELD.number = 4
FUBENRESULTNTF_ISWIN_FIELD.index = 3
FUBENRESULTNTF_ISWIN_FIELD.label = 1
FUBENRESULTNTF_ISWIN_FIELD.has_default_value = false
FUBENRESULTNTF_ISWIN_FIELD.default_value = false
FUBENRESULTNTF_ISWIN_FIELD.type = 8
FUBENRESULTNTF_ISWIN_FIELD.cpp_type = 7
FUBENRESULTNTF.name = "FubenResultNtf"
FUBENRESULTNTF.full_name = ".Cmd.FubenResultNtf"
FUBENRESULTNTF.nested_types = {}
FUBENRESULTNTF.enum_types = {}
FUBENRESULTNTF.fields = {
  FUBENRESULTNTF_CMD_FIELD,
  FUBENRESULTNTF_PARAM_FIELD,
  FUBENRESULTNTF_RAIDTYPE_FIELD,
  FUBENRESULTNTF_ISWIN_FIELD
}
FUBENRESULTNTF.is_extendable = false
FUBENRESULTNTF.extensions = {}
ENDTIMESYNCFUBENCMD_CMD_FIELD.name = "cmd"
ENDTIMESYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.EndTimeSyncFubenCmd.cmd"
ENDTIMESYNCFUBENCMD_CMD_FIELD.number = 1
ENDTIMESYNCFUBENCMD_CMD_FIELD.index = 0
ENDTIMESYNCFUBENCMD_CMD_FIELD.label = 1
ENDTIMESYNCFUBENCMD_CMD_FIELD.has_default_value = true
ENDTIMESYNCFUBENCMD_CMD_FIELD.default_value = 11
ENDTIMESYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ENDTIMESYNCFUBENCMD_CMD_FIELD.type = 14
ENDTIMESYNCFUBENCMD_CMD_FIELD.cpp_type = 8
ENDTIMESYNCFUBENCMD_PARAM_FIELD.name = "param"
ENDTIMESYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.EndTimeSyncFubenCmd.param"
ENDTIMESYNCFUBENCMD_PARAM_FIELD.number = 2
ENDTIMESYNCFUBENCMD_PARAM_FIELD.index = 1
ENDTIMESYNCFUBENCMD_PARAM_FIELD.label = 1
ENDTIMESYNCFUBENCMD_PARAM_FIELD.has_default_value = true
ENDTIMESYNCFUBENCMD_PARAM_FIELD.default_value = 92
ENDTIMESYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
ENDTIMESYNCFUBENCMD_PARAM_FIELD.type = 14
ENDTIMESYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.name = "endtime"
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.EndTimeSyncFubenCmd.endtime"
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.number = 3
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.index = 2
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.label = 1
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.has_default_value = true
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.default_value = 0
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.type = 13
ENDTIMESYNCFUBENCMD_ENDTIME_FIELD.cpp_type = 3
ENDTIMESYNCFUBENCMD.name = "EndTimeSyncFubenCmd"
ENDTIMESYNCFUBENCMD.full_name = ".Cmd.EndTimeSyncFubenCmd"
ENDTIMESYNCFUBENCMD.nested_types = {}
ENDTIMESYNCFUBENCMD.enum_types = {}
ENDTIMESYNCFUBENCMD.fields = {
  ENDTIMESYNCFUBENCMD_CMD_FIELD,
  ENDTIMESYNCFUBENCMD_PARAM_FIELD,
  ENDTIMESYNCFUBENCMD_ENDTIME_FIELD
}
ENDTIMESYNCFUBENCMD.is_extendable = false
ENDTIMESYNCFUBENCMD.extensions = {}
RESULTSYNCFUBENCMD_CMD_FIELD.name = "cmd"
RESULTSYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.ResultSyncFubenCmd.cmd"
RESULTSYNCFUBENCMD_CMD_FIELD.number = 1
RESULTSYNCFUBENCMD_CMD_FIELD.index = 0
RESULTSYNCFUBENCMD_CMD_FIELD.label = 1
RESULTSYNCFUBENCMD_CMD_FIELD.has_default_value = true
RESULTSYNCFUBENCMD_CMD_FIELD.default_value = 11
RESULTSYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RESULTSYNCFUBENCMD_CMD_FIELD.type = 14
RESULTSYNCFUBENCMD_CMD_FIELD.cpp_type = 8
RESULTSYNCFUBENCMD_PARAM_FIELD.name = "param"
RESULTSYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ResultSyncFubenCmd.param"
RESULTSYNCFUBENCMD_PARAM_FIELD.number = 2
RESULTSYNCFUBENCMD_PARAM_FIELD.index = 1
RESULTSYNCFUBENCMD_PARAM_FIELD.label = 1
RESULTSYNCFUBENCMD_PARAM_FIELD.has_default_value = true
RESULTSYNCFUBENCMD_PARAM_FIELD.default_value = 93
RESULTSYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
RESULTSYNCFUBENCMD_PARAM_FIELD.type = 14
RESULTSYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
RESULTSYNCFUBENCMD_SCORE_FIELD.name = "score"
RESULTSYNCFUBENCMD_SCORE_FIELD.full_name = ".Cmd.ResultSyncFubenCmd.score"
RESULTSYNCFUBENCMD_SCORE_FIELD.number = 3
RESULTSYNCFUBENCMD_SCORE_FIELD.index = 2
RESULTSYNCFUBENCMD_SCORE_FIELD.label = 1
RESULTSYNCFUBENCMD_SCORE_FIELD.has_default_value = true
RESULTSYNCFUBENCMD_SCORE_FIELD.default_value = 0
RESULTSYNCFUBENCMD_SCORE_FIELD.type = 13
RESULTSYNCFUBENCMD_SCORE_FIELD.cpp_type = 3
RESULTSYNCFUBENCMD.name = "ResultSyncFubenCmd"
RESULTSYNCFUBENCMD.full_name = ".Cmd.ResultSyncFubenCmd"
RESULTSYNCFUBENCMD.nested_types = {}
RESULTSYNCFUBENCMD.enum_types = {}
RESULTSYNCFUBENCMD.fields = {
  RESULTSYNCFUBENCMD_CMD_FIELD,
  RESULTSYNCFUBENCMD_PARAM_FIELD,
  RESULTSYNCFUBENCMD_SCORE_FIELD
}
RESULTSYNCFUBENCMD.is_extendable = false
RESULTSYNCFUBENCMD.extensions = {}
COMODOPHASEFUBENCMD_CMD_FIELD.name = "cmd"
COMODOPHASEFUBENCMD_CMD_FIELD.full_name = ".Cmd.ComodoPhaseFubenCmd.cmd"
COMODOPHASEFUBENCMD_CMD_FIELD.number = 1
COMODOPHASEFUBENCMD_CMD_FIELD.index = 0
COMODOPHASEFUBENCMD_CMD_FIELD.label = 1
COMODOPHASEFUBENCMD_CMD_FIELD.has_default_value = true
COMODOPHASEFUBENCMD_CMD_FIELD.default_value = 11
COMODOPHASEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
COMODOPHASEFUBENCMD_CMD_FIELD.type = 14
COMODOPHASEFUBENCMD_CMD_FIELD.cpp_type = 8
COMODOPHASEFUBENCMD_PARAM_FIELD.name = "param"
COMODOPHASEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ComodoPhaseFubenCmd.param"
COMODOPHASEFUBENCMD_PARAM_FIELD.number = 2
COMODOPHASEFUBENCMD_PARAM_FIELD.index = 1
COMODOPHASEFUBENCMD_PARAM_FIELD.label = 1
COMODOPHASEFUBENCMD_PARAM_FIELD.has_default_value = true
COMODOPHASEFUBENCMD_PARAM_FIELD.default_value = 97
COMODOPHASEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
COMODOPHASEFUBENCMD_PARAM_FIELD.type = 14
COMODOPHASEFUBENCMD_PARAM_FIELD.cpp_type = 8
COMODOPHASEFUBENCMD_PHASE_FIELD.name = "phase"
COMODOPHASEFUBENCMD_PHASE_FIELD.full_name = ".Cmd.ComodoPhaseFubenCmd.phase"
COMODOPHASEFUBENCMD_PHASE_FIELD.number = 3
COMODOPHASEFUBENCMD_PHASE_FIELD.index = 2
COMODOPHASEFUBENCMD_PHASE_FIELD.label = 1
COMODOPHASEFUBENCMD_PHASE_FIELD.has_default_value = false
COMODOPHASEFUBENCMD_PHASE_FIELD.default_value = nil
COMODOPHASEFUBENCMD_PHASE_FIELD.enum_type = ECOMODOTEAMRAIDPHASE
COMODOPHASEFUBENCMD_PHASE_FIELD.type = 14
COMODOPHASEFUBENCMD_PHASE_FIELD.cpp_type = 8
COMODOPHASEFUBENCMD.name = "ComodoPhaseFubenCmd"
COMODOPHASEFUBENCMD.full_name = ".Cmd.ComodoPhaseFubenCmd"
COMODOPHASEFUBENCMD.nested_types = {}
COMODOPHASEFUBENCMD.enum_types = {}
COMODOPHASEFUBENCMD.fields = {
  COMODOPHASEFUBENCMD_CMD_FIELD,
  COMODOPHASEFUBENCMD_PARAM_FIELD,
  COMODOPHASEFUBENCMD_PHASE_FIELD
}
COMODOPHASEFUBENCMD.is_extendable = false
COMODOPHASEFUBENCMD.extensions = {}
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.name = "boss"
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.full_name = ".Cmd.ComodoTeamRaidStatData.boss"
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.number = 1
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.index = 0
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.label = 1
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.has_default_value = false
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.default_value = nil
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.enum_type = ECOMODOTEAMRAIDBOSS
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.type = 14
COMODOTEAMRAIDSTATDATA_BOSS_FIELD.cpp_type = 8
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.name = "datas"
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.full_name = ".Cmd.ComodoTeamRaidStatData.datas"
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.number = 2
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.index = 1
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.label = 3
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.has_default_value = false
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.default_value = {}
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.message_type = GROUPRAIDSHOWDATA
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.type = 11
COMODOTEAMRAIDSTATDATA_DATAS_FIELD.cpp_type = 10
COMODOTEAMRAIDSTATDATA.name = "ComodoTeamRaidStatData"
COMODOTEAMRAIDSTATDATA.full_name = ".Cmd.ComodoTeamRaidStatData"
COMODOTEAMRAIDSTATDATA.nested_types = {}
COMODOTEAMRAIDSTATDATA.enum_types = {}
COMODOTEAMRAIDSTATDATA.fields = {
  COMODOTEAMRAIDSTATDATA_BOSS_FIELD,
  COMODOTEAMRAIDSTATDATA_DATAS_FIELD
}
COMODOTEAMRAIDSTATDATA.is_extendable = false
COMODOTEAMRAIDSTATDATA.extensions = {}
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.name = "cmd"
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.full_name = ".Cmd.QueryComodoTeamRaidStat.cmd"
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.number = 1
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.index = 0
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.label = 1
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.has_default_value = true
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.default_value = 11
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.type = 14
QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD.cpp_type = 8
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.name = "param"
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.full_name = ".Cmd.QueryComodoTeamRaidStat.param"
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.number = 2
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.index = 1
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.label = 1
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.has_default_value = true
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.default_value = 98
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.enum_type = FUBENPARAM
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.type = 14
QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD.cpp_type = 8
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.name = "current"
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.full_name = ".Cmd.QueryComodoTeamRaidStat.current"
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.number = 3
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.index = 2
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.label = 1
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.has_default_value = false
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.default_value = nil
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.type = 11
QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD.cpp_type = 10
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.name = "total"
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.full_name = ".Cmd.QueryComodoTeamRaidStat.total"
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.number = 4
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.index = 3
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.label = 1
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.has_default_value = false
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.default_value = nil
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.type = 11
QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD.cpp_type = 10
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.name = "history"
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.full_name = ".Cmd.QueryComodoTeamRaidStat.history"
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.number = 5
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.index = 4
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.label = 3
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.has_default_value = false
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.default_value = {}
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.type = 11
QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD.cpp_type = 10
QUERYCOMODOTEAMRAIDSTAT.name = "QueryComodoTeamRaidStat"
QUERYCOMODOTEAMRAIDSTAT.full_name = ".Cmd.QueryComodoTeamRaidStat"
QUERYCOMODOTEAMRAIDSTAT.nested_types = {}
QUERYCOMODOTEAMRAIDSTAT.enum_types = {}
QUERYCOMODOTEAMRAIDSTAT.fields = {
  QUERYCOMODOTEAMRAIDSTAT_CMD_FIELD,
  QUERYCOMODOTEAMRAIDSTAT_PARAM_FIELD,
  QUERYCOMODOTEAMRAIDSTAT_CURRENT_FIELD,
  QUERYCOMODOTEAMRAIDSTAT_TOTAL_FIELD,
  QUERYCOMODOTEAMRAIDSTAT_HISTORY_FIELD
}
QUERYCOMODOTEAMRAIDSTAT.is_extendable = false
QUERYCOMODOTEAMRAIDSTAT.extensions = {}
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.name = "cmd"
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.full_name = ".Cmd.TeamPwsStateSyncFubenCmd.cmd"
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.number = 1
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.index = 0
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.label = 1
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.has_default_value = true
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.default_value = 11
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.type = 14
TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD.cpp_type = 8
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.name = "param"
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.full_name = ".Cmd.TeamPwsStateSyncFubenCmd.param"
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.number = 2
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.index = 1
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.label = 1
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.has_default_value = true
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.default_value = 99
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.type = 14
TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD.cpp_type = 8
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.name = "fire"
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.full_name = ".Cmd.TeamPwsStateSyncFubenCmd.fire"
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.number = 3
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.index = 2
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.label = 1
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.has_default_value = false
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.default_value = false
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.type = 8
TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD.cpp_type = 7
TEAMPWSSTATESYNCFUBENCMD.name = "TeamPwsStateSyncFubenCmd"
TEAMPWSSTATESYNCFUBENCMD.full_name = ".Cmd.TeamPwsStateSyncFubenCmd"
TEAMPWSSTATESYNCFUBENCMD.nested_types = {}
TEAMPWSSTATESYNCFUBENCMD.enum_types = {}
TEAMPWSSTATESYNCFUBENCMD.fields = {
  TEAMPWSSTATESYNCFUBENCMD_CMD_FIELD,
  TEAMPWSSTATESYNCFUBENCMD_PARAM_FIELD,
  TEAMPWSSTATESYNCFUBENCMD_FIRE_FIELD
}
TEAMPWSSTATESYNCFUBENCMD.is_extendable = false
TEAMPWSSTATESYNCFUBENCMD.extensions = {}
OBSERVERFLASHFUBENCMD_CMD_FIELD.name = "cmd"
OBSERVERFLASHFUBENCMD_CMD_FIELD.full_name = ".Cmd.ObserverFlashFubenCmd.cmd"
OBSERVERFLASHFUBENCMD_CMD_FIELD.number = 1
OBSERVERFLASHFUBENCMD_CMD_FIELD.index = 0
OBSERVERFLASHFUBENCMD_CMD_FIELD.label = 1
OBSERVERFLASHFUBENCMD_CMD_FIELD.has_default_value = true
OBSERVERFLASHFUBENCMD_CMD_FIELD.default_value = 11
OBSERVERFLASHFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBSERVERFLASHFUBENCMD_CMD_FIELD.type = 14
OBSERVERFLASHFUBENCMD_CMD_FIELD.cpp_type = 8
OBSERVERFLASHFUBENCMD_PARAM_FIELD.name = "param"
OBSERVERFLASHFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ObserverFlashFubenCmd.param"
OBSERVERFLASHFUBENCMD_PARAM_FIELD.number = 2
OBSERVERFLASHFUBENCMD_PARAM_FIELD.index = 1
OBSERVERFLASHFUBENCMD_PARAM_FIELD.label = 1
OBSERVERFLASHFUBENCMD_PARAM_FIELD.has_default_value = true
OBSERVERFLASHFUBENCMD_PARAM_FIELD.default_value = 100
OBSERVERFLASHFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBSERVERFLASHFUBENCMD_PARAM_FIELD.type = 14
OBSERVERFLASHFUBENCMD_PARAM_FIELD.cpp_type = 8
OBSERVERFLASHFUBENCMD_X_FIELD.name = "x"
OBSERVERFLASHFUBENCMD_X_FIELD.full_name = ".Cmd.ObserverFlashFubenCmd.x"
OBSERVERFLASHFUBENCMD_X_FIELD.number = 3
OBSERVERFLASHFUBENCMD_X_FIELD.index = 2
OBSERVERFLASHFUBENCMD_X_FIELD.label = 1
OBSERVERFLASHFUBENCMD_X_FIELD.has_default_value = false
OBSERVERFLASHFUBENCMD_X_FIELD.default_value = 0.0
OBSERVERFLASHFUBENCMD_X_FIELD.type = 2
OBSERVERFLASHFUBENCMD_X_FIELD.cpp_type = 6
OBSERVERFLASHFUBENCMD_Y_FIELD.name = "y"
OBSERVERFLASHFUBENCMD_Y_FIELD.full_name = ".Cmd.ObserverFlashFubenCmd.y"
OBSERVERFLASHFUBENCMD_Y_FIELD.number = 4
OBSERVERFLASHFUBENCMD_Y_FIELD.index = 3
OBSERVERFLASHFUBENCMD_Y_FIELD.label = 1
OBSERVERFLASHFUBENCMD_Y_FIELD.has_default_value = false
OBSERVERFLASHFUBENCMD_Y_FIELD.default_value = 0.0
OBSERVERFLASHFUBENCMD_Y_FIELD.type = 2
OBSERVERFLASHFUBENCMD_Y_FIELD.cpp_type = 6
OBSERVERFLASHFUBENCMD_Z_FIELD.name = "z"
OBSERVERFLASHFUBENCMD_Z_FIELD.full_name = ".Cmd.ObserverFlashFubenCmd.z"
OBSERVERFLASHFUBENCMD_Z_FIELD.number = 5
OBSERVERFLASHFUBENCMD_Z_FIELD.index = 4
OBSERVERFLASHFUBENCMD_Z_FIELD.label = 1
OBSERVERFLASHFUBENCMD_Z_FIELD.has_default_value = false
OBSERVERFLASHFUBENCMD_Z_FIELD.default_value = 0.0
OBSERVERFLASHFUBENCMD_Z_FIELD.type = 2
OBSERVERFLASHFUBENCMD_Z_FIELD.cpp_type = 6
OBSERVERFLASHFUBENCMD.name = "ObserverFlashFubenCmd"
OBSERVERFLASHFUBENCMD.full_name = ".Cmd.ObserverFlashFubenCmd"
OBSERVERFLASHFUBENCMD.nested_types = {}
OBSERVERFLASHFUBENCMD.enum_types = {}
OBSERVERFLASHFUBENCMD.fields = {
  OBSERVERFLASHFUBENCMD_CMD_FIELD,
  OBSERVERFLASHFUBENCMD_PARAM_FIELD,
  OBSERVERFLASHFUBENCMD_X_FIELD,
  OBSERVERFLASHFUBENCMD_Y_FIELD,
  OBSERVERFLASHFUBENCMD_Z_FIELD
}
OBSERVERFLASHFUBENCMD.is_extendable = false
OBSERVERFLASHFUBENCMD.extensions = {}
OBSERVERATTACHFUBENCMD_CMD_FIELD.name = "cmd"
OBSERVERATTACHFUBENCMD_CMD_FIELD.full_name = ".Cmd.ObserverAttachFubenCmd.cmd"
OBSERVERATTACHFUBENCMD_CMD_FIELD.number = 1
OBSERVERATTACHFUBENCMD_CMD_FIELD.index = 0
OBSERVERATTACHFUBENCMD_CMD_FIELD.label = 1
OBSERVERATTACHFUBENCMD_CMD_FIELD.has_default_value = true
OBSERVERATTACHFUBENCMD_CMD_FIELD.default_value = 11
OBSERVERATTACHFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBSERVERATTACHFUBENCMD_CMD_FIELD.type = 14
OBSERVERATTACHFUBENCMD_CMD_FIELD.cpp_type = 8
OBSERVERATTACHFUBENCMD_PARAM_FIELD.name = "param"
OBSERVERATTACHFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ObserverAttachFubenCmd.param"
OBSERVERATTACHFUBENCMD_PARAM_FIELD.number = 2
OBSERVERATTACHFUBENCMD_PARAM_FIELD.index = 1
OBSERVERATTACHFUBENCMD_PARAM_FIELD.label = 1
OBSERVERATTACHFUBENCMD_PARAM_FIELD.has_default_value = true
OBSERVERATTACHFUBENCMD_PARAM_FIELD.default_value = 101
OBSERVERATTACHFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBSERVERATTACHFUBENCMD_PARAM_FIELD.type = 14
OBSERVERATTACHFUBENCMD_PARAM_FIELD.cpp_type = 8
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.name = "attach_player"
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.full_name = ".Cmd.ObserverAttachFubenCmd.attach_player"
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.number = 3
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.index = 2
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.label = 1
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.has_default_value = false
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.default_value = 0
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.type = 4
OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD.cpp_type = 4
OBSERVERATTACHFUBENCMD.name = "ObserverAttachFubenCmd"
OBSERVERATTACHFUBENCMD.full_name = ".Cmd.ObserverAttachFubenCmd"
OBSERVERATTACHFUBENCMD.nested_types = {}
OBSERVERATTACHFUBENCMD.enum_types = {}
OBSERVERATTACHFUBENCMD.fields = {
  OBSERVERATTACHFUBENCMD_CMD_FIELD,
  OBSERVERATTACHFUBENCMD_PARAM_FIELD,
  OBSERVERATTACHFUBENCMD_ATTACH_PLAYER_FIELD
}
OBSERVERATTACHFUBENCMD.is_extendable = false
OBSERVERATTACHFUBENCMD.extensions = {}
OBSERVERSELECTFUBENCMD_CMD_FIELD.name = "cmd"
OBSERVERSELECTFUBENCMD_CMD_FIELD.full_name = ".Cmd.ObserverSelectFubenCmd.cmd"
OBSERVERSELECTFUBENCMD_CMD_FIELD.number = 1
OBSERVERSELECTFUBENCMD_CMD_FIELD.index = 0
OBSERVERSELECTFUBENCMD_CMD_FIELD.label = 1
OBSERVERSELECTFUBENCMD_CMD_FIELD.has_default_value = true
OBSERVERSELECTFUBENCMD_CMD_FIELD.default_value = 11
OBSERVERSELECTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBSERVERSELECTFUBENCMD_CMD_FIELD.type = 14
OBSERVERSELECTFUBENCMD_CMD_FIELD.cpp_type = 8
OBSERVERSELECTFUBENCMD_PARAM_FIELD.name = "param"
OBSERVERSELECTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ObserverSelectFubenCmd.param"
OBSERVERSELECTFUBENCMD_PARAM_FIELD.number = 2
OBSERVERSELECTFUBENCMD_PARAM_FIELD.index = 1
OBSERVERSELECTFUBENCMD_PARAM_FIELD.label = 1
OBSERVERSELECTFUBENCMD_PARAM_FIELD.has_default_value = true
OBSERVERSELECTFUBENCMD_PARAM_FIELD.default_value = 102
OBSERVERSELECTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBSERVERSELECTFUBENCMD_PARAM_FIELD.type = 14
OBSERVERSELECTFUBENCMD_PARAM_FIELD.cpp_type = 8
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.name = "select_player"
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.full_name = ".Cmd.ObserverSelectFubenCmd.select_player"
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.number = 3
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.index = 2
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.label = 1
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.has_default_value = false
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.default_value = 0
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.type = 4
OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD.cpp_type = 4
OBSERVERSELECTFUBENCMD.name = "ObserverSelectFubenCmd"
OBSERVERSELECTFUBENCMD.full_name = ".Cmd.ObserverSelectFubenCmd"
OBSERVERSELECTFUBENCMD.nested_types = {}
OBSERVERSELECTFUBENCMD.enum_types = {}
OBSERVERSELECTFUBENCMD.fields = {
  OBSERVERSELECTFUBENCMD_CMD_FIELD,
  OBSERVERSELECTFUBENCMD_PARAM_FIELD,
  OBSERVERSELECTFUBENCMD_SELECT_PLAYER_FIELD
}
OBSERVERSELECTFUBENCMD.is_extendable = false
OBSERVERSELECTFUBENCMD.extensions = {}
PLAYERHPSPUPDATE_CHARID_FIELD.name = "charid"
PLAYERHPSPUPDATE_CHARID_FIELD.full_name = ".Cmd.PlayerHpSpUpdate.charid"
PLAYERHPSPUPDATE_CHARID_FIELD.number = 1
PLAYERHPSPUPDATE_CHARID_FIELD.index = 0
PLAYERHPSPUPDATE_CHARID_FIELD.label = 1
PLAYERHPSPUPDATE_CHARID_FIELD.has_default_value = false
PLAYERHPSPUPDATE_CHARID_FIELD.default_value = 0
PLAYERHPSPUPDATE_CHARID_FIELD.type = 4
PLAYERHPSPUPDATE_CHARID_FIELD.cpp_type = 4
PLAYERHPSPUPDATE_HPPER_FIELD.name = "hpper"
PLAYERHPSPUPDATE_HPPER_FIELD.full_name = ".Cmd.PlayerHpSpUpdate.hpper"
PLAYERHPSPUPDATE_HPPER_FIELD.number = 2
PLAYERHPSPUPDATE_HPPER_FIELD.index = 1
PLAYERHPSPUPDATE_HPPER_FIELD.label = 1
PLAYERHPSPUPDATE_HPPER_FIELD.has_default_value = false
PLAYERHPSPUPDATE_HPPER_FIELD.default_value = 0
PLAYERHPSPUPDATE_HPPER_FIELD.type = 13
PLAYERHPSPUPDATE_HPPER_FIELD.cpp_type = 3
PLAYERHPSPUPDATE_SPPER_FIELD.name = "spper"
PLAYERHPSPUPDATE_SPPER_FIELD.full_name = ".Cmd.PlayerHpSpUpdate.spper"
PLAYERHPSPUPDATE_SPPER_FIELD.number = 3
PLAYERHPSPUPDATE_SPPER_FIELD.index = 2
PLAYERHPSPUPDATE_SPPER_FIELD.label = 1
PLAYERHPSPUPDATE_SPPER_FIELD.has_default_value = false
PLAYERHPSPUPDATE_SPPER_FIELD.default_value = 0
PLAYERHPSPUPDATE_SPPER_FIELD.type = 13
PLAYERHPSPUPDATE_SPPER_FIELD.cpp_type = 3
PLAYERHPSPUPDATE.name = "PlayerHpSpUpdate"
PLAYERHPSPUPDATE.full_name = ".Cmd.PlayerHpSpUpdate"
PLAYERHPSPUPDATE.nested_types = {}
PLAYERHPSPUPDATE.enum_types = {}
PLAYERHPSPUPDATE.fields = {
  PLAYERHPSPUPDATE_CHARID_FIELD,
  PLAYERHPSPUPDATE_HPPER_FIELD,
  PLAYERHPSPUPDATE_SPPER_FIELD
}
PLAYERHPSPUPDATE.is_extendable = false
PLAYERHPSPUPDATE.extensions = {}
OBHPSPUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
OBHPSPUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.ObHpspUpdateFubenCmd.cmd"
OBHPSPUPDATEFUBENCMD_CMD_FIELD.number = 1
OBHPSPUPDATEFUBENCMD_CMD_FIELD.index = 0
OBHPSPUPDATEFUBENCMD_CMD_FIELD.label = 1
OBHPSPUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
OBHPSPUPDATEFUBENCMD_CMD_FIELD.default_value = 11
OBHPSPUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBHPSPUPDATEFUBENCMD_CMD_FIELD.type = 14
OBHPSPUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.name = "param"
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ObHpspUpdateFubenCmd.param"
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.number = 2
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.index = 1
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.label = 1
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.default_value = 104
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.type = 14
OBHPSPUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.name = "updates"
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.full_name = ".Cmd.ObHpspUpdateFubenCmd.updates"
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.number = 3
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.index = 2
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.label = 3
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.has_default_value = false
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.default_value = {}
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.message_type = PLAYERHPSPUPDATE
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.type = 11
OBHPSPUPDATEFUBENCMD_UPDATES_FIELD.cpp_type = 10
OBHPSPUPDATEFUBENCMD.name = "ObHpspUpdateFubenCmd"
OBHPSPUPDATEFUBENCMD.full_name = ".Cmd.ObHpspUpdateFubenCmd"
OBHPSPUPDATEFUBENCMD.nested_types = {}
OBHPSPUPDATEFUBENCMD.enum_types = {}
OBHPSPUPDATEFUBENCMD.fields = {
  OBHPSPUPDATEFUBENCMD_CMD_FIELD,
  OBHPSPUPDATEFUBENCMD_PARAM_FIELD,
  OBHPSPUPDATEFUBENCMD_UPDATES_FIELD
}
OBHPSPUPDATEFUBENCMD.is_extendable = false
OBHPSPUPDATEFUBENCMD.extensions = {}
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.name = "cmd"
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.full_name = ".Cmd.ObPlayerOfflineFubenCmd.cmd"
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.number = 1
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.index = 0
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.label = 1
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.has_default_value = true
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.default_value = 11
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.type = 14
OBPLAYEROFFLINEFUBENCMD_CMD_FIELD.cpp_type = 8
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.name = "param"
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ObPlayerOfflineFubenCmd.param"
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.number = 2
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.index = 1
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.label = 1
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.has_default_value = true
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.default_value = 105
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.type = 14
OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD.cpp_type = 8
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.name = "offline_char"
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.full_name = ".Cmd.ObPlayerOfflineFubenCmd.offline_char"
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.number = 3
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.index = 2
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.label = 1
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.has_default_value = false
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.default_value = 0
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.type = 4
OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD.cpp_type = 4
OBPLAYEROFFLINEFUBENCMD.name = "ObPlayerOfflineFubenCmd"
OBPLAYEROFFLINEFUBENCMD.full_name = ".Cmd.ObPlayerOfflineFubenCmd"
OBPLAYEROFFLINEFUBENCMD.nested_types = {}
OBPLAYEROFFLINEFUBENCMD.enum_types = {}
OBPLAYEROFFLINEFUBENCMD.fields = {
  OBPLAYEROFFLINEFUBENCMD_CMD_FIELD,
  OBPLAYEROFFLINEFUBENCMD_PARAM_FIELD,
  OBPLAYEROFFLINEFUBENCMD_OFFLINE_CHAR_FIELD
}
OBPLAYEROFFLINEFUBENCMD.is_extendable = false
OBPLAYEROFFLINEFUBENCMD.extensions = {}
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.name = "cmd"
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.full_name = ".Cmd.MultiBossPhaseFubenCmd.cmd"
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.number = 1
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.index = 0
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.label = 1
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.has_default_value = true
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.default_value = 11
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.type = 14
MULTIBOSSPHASEFUBENCMD_CMD_FIELD.cpp_type = 8
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.name = "param"
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.MultiBossPhaseFubenCmd.param"
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.number = 2
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.index = 1
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.label = 1
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.has_default_value = true
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.default_value = 106
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.type = 14
MULTIBOSSPHASEFUBENCMD_PARAM_FIELD.cpp_type = 8
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.name = "boss_index"
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.full_name = ".Cmd.MultiBossPhaseFubenCmd.boss_index"
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.number = 3
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.index = 2
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.label = 1
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.has_default_value = false
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.default_value = 0
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.type = 13
MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD.cpp_type = 3
MULTIBOSSPHASEFUBENCMD.name = "MultiBossPhaseFubenCmd"
MULTIBOSSPHASEFUBENCMD.full_name = ".Cmd.MultiBossPhaseFubenCmd"
MULTIBOSSPHASEFUBENCMD.nested_types = {}
MULTIBOSSPHASEFUBENCMD.enum_types = {}
MULTIBOSSPHASEFUBENCMD.fields = {
  MULTIBOSSPHASEFUBENCMD_CMD_FIELD,
  MULTIBOSSPHASEFUBENCMD_PARAM_FIELD,
  MULTIBOSSPHASEFUBENCMD_BOSS_INDEX_FIELD
}
MULTIBOSSPHASEFUBENCMD.is_extendable = false
MULTIBOSSPHASEFUBENCMD.extensions = {}
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.name = "boss_index"
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.full_name = ".Cmd.MultiBossRaidStatData.boss_index"
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.number = 1
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.index = 0
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.label = 1
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.has_default_value = false
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.default_value = 0
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.type = 13
MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD.cpp_type = 3
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.name = "datas"
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.full_name = ".Cmd.MultiBossRaidStatData.datas"
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.number = 2
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.index = 1
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.label = 3
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.has_default_value = false
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.default_value = {}
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.message_type = GROUPRAIDSHOWDATA
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.type = 11
MULTIBOSSRAIDSTATDATA_DATAS_FIELD.cpp_type = 10
MULTIBOSSRAIDSTATDATA.name = "MultiBossRaidStatData"
MULTIBOSSRAIDSTATDATA.full_name = ".Cmd.MultiBossRaidStatData"
MULTIBOSSRAIDSTATDATA.nested_types = {}
MULTIBOSSRAIDSTATDATA.enum_types = {}
MULTIBOSSRAIDSTATDATA.fields = {
  MULTIBOSSRAIDSTATDATA_BOSS_INDEX_FIELD,
  MULTIBOSSRAIDSTATDATA_DATAS_FIELD
}
MULTIBOSSRAIDSTATDATA.is_extendable = false
MULTIBOSSRAIDSTATDATA.extensions = {}
ACHIEVEREWARD_ACHIEVEID_FIELD.name = "achieveid"
ACHIEVEREWARD_ACHIEVEID_FIELD.full_name = ".Cmd.AchieveReward.achieveid"
ACHIEVEREWARD_ACHIEVEID_FIELD.number = 1
ACHIEVEREWARD_ACHIEVEID_FIELD.index = 0
ACHIEVEREWARD_ACHIEVEID_FIELD.label = 1
ACHIEVEREWARD_ACHIEVEID_FIELD.has_default_value = false
ACHIEVEREWARD_ACHIEVEID_FIELD.default_value = 0
ACHIEVEREWARD_ACHIEVEID_FIELD.type = 13
ACHIEVEREWARD_ACHIEVEID_FIELD.cpp_type = 3
ACHIEVEREWARD_PICK_FIELD.name = "pick"
ACHIEVEREWARD_PICK_FIELD.full_name = ".Cmd.AchieveReward.pick"
ACHIEVEREWARD_PICK_FIELD.number = 2
ACHIEVEREWARD_PICK_FIELD.index = 1
ACHIEVEREWARD_PICK_FIELD.label = 1
ACHIEVEREWARD_PICK_FIELD.has_default_value = false
ACHIEVEREWARD_PICK_FIELD.default_value = false
ACHIEVEREWARD_PICK_FIELD.type = 8
ACHIEVEREWARD_PICK_FIELD.cpp_type = 7
ACHIEVEREWARD.name = "AchieveReward"
ACHIEVEREWARD.full_name = ".Cmd.AchieveReward"
ACHIEVEREWARD.nested_types = {}
ACHIEVEREWARD.enum_types = {}
ACHIEVEREWARD.fields = {
  ACHIEVEREWARD_ACHIEVEID_FIELD,
  ACHIEVEREWARD_PICK_FIELD
}
ACHIEVEREWARD.is_extendable = false
ACHIEVEREWARD.extensions = {}
PVERAIDACHIEVE_GROUPID_FIELD.name = "groupid"
PVERAIDACHIEVE_GROUPID_FIELD.full_name = ".Cmd.PveRaidAchieve.groupid"
PVERAIDACHIEVE_GROUPID_FIELD.number = 1
PVERAIDACHIEVE_GROUPID_FIELD.index = 0
PVERAIDACHIEVE_GROUPID_FIELD.label = 1
PVERAIDACHIEVE_GROUPID_FIELD.has_default_value = false
PVERAIDACHIEVE_GROUPID_FIELD.default_value = 0
PVERAIDACHIEVE_GROUPID_FIELD.type = 13
PVERAIDACHIEVE_GROUPID_FIELD.cpp_type = 3
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.name = "achieveids"
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.full_name = ".Cmd.PveRaidAchieve.achieveids"
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.number = 2
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.index = 1
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.label = 3
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.has_default_value = false
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.default_value = {}
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.message_type = ACHIEVEREWARD
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.type = 11
PVERAIDACHIEVE_ACHIEVEIDS_FIELD.cpp_type = 10
PVERAIDACHIEVE.name = "PveRaidAchieve"
PVERAIDACHIEVE.full_name = ".Cmd.PveRaidAchieve"
PVERAIDACHIEVE.nested_types = {}
PVERAIDACHIEVE.enum_types = {}
PVERAIDACHIEVE.fields = {
  PVERAIDACHIEVE_GROUPID_FIELD,
  PVERAIDACHIEVE_ACHIEVEIDS_FIELD
}
PVERAIDACHIEVE.is_extendable = false
PVERAIDACHIEVE.extensions = {}
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.name = "cmd"
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.full_name = ".Cmd.QueryMultiBossRaidStat.cmd"
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.number = 1
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.index = 0
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.label = 1
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.has_default_value = true
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.default_value = 11
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.type = 14
QUERYMULTIBOSSRAIDSTAT_CMD_FIELD.cpp_type = 8
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.name = "param"
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.full_name = ".Cmd.QueryMultiBossRaidStat.param"
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.number = 2
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.index = 1
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.label = 1
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.has_default_value = true
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.default_value = 107
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.enum_type = FUBENPARAM
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.type = 14
QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD.cpp_type = 8
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.name = "current"
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.full_name = ".Cmd.QueryMultiBossRaidStat.current"
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.number = 4
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.index = 2
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.label = 1
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.has_default_value = false
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.default_value = nil
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.type = 11
QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD.cpp_type = 10
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.name = "total"
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.full_name = ".Cmd.QueryMultiBossRaidStat.total"
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.number = 5
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.index = 3
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.label = 1
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.has_default_value = false
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.default_value = nil
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.type = 11
QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD.cpp_type = 10
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.name = "history"
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.full_name = ".Cmd.QueryMultiBossRaidStat.history"
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.number = 6
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.index = 4
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.label = 3
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.has_default_value = false
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.default_value = {}
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.type = 11
QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD.cpp_type = 10
QUERYMULTIBOSSRAIDSTAT.name = "QueryMultiBossRaidStat"
QUERYMULTIBOSSRAIDSTAT.full_name = ".Cmd.QueryMultiBossRaidStat"
QUERYMULTIBOSSRAIDSTAT.nested_types = {}
QUERYMULTIBOSSRAIDSTAT.enum_types = {}
QUERYMULTIBOSSRAIDSTAT.fields = {
  QUERYMULTIBOSSRAIDSTAT_CMD_FIELD,
  QUERYMULTIBOSSRAIDSTAT_PARAM_FIELD,
  QUERYMULTIBOSSRAIDSTAT_CURRENT_FIELD,
  QUERYMULTIBOSSRAIDSTAT_TOTAL_FIELD,
  QUERYMULTIBOSSRAIDSTAT_HISTORY_FIELD
}
QUERYMULTIBOSSRAIDSTAT.is_extendable = false
QUERYMULTIBOSSRAIDSTAT.extensions = {}
BOSSSCENEINFO_BOSSID_FIELD.name = "bossid"
BOSSSCENEINFO_BOSSID_FIELD.full_name = ".Cmd.BossSceneInfo.bossid"
BOSSSCENEINFO_BOSSID_FIELD.number = 1
BOSSSCENEINFO_BOSSID_FIELD.index = 0
BOSSSCENEINFO_BOSSID_FIELD.label = 1
BOSSSCENEINFO_BOSSID_FIELD.has_default_value = false
BOSSSCENEINFO_BOSSID_FIELD.default_value = 0
BOSSSCENEINFO_BOSSID_FIELD.type = 13
BOSSSCENEINFO_BOSSID_FIELD.cpp_type = 3
BOSSSCENEINFO_RANDREWARDID_FIELD.name = "randrewardid"
BOSSSCENEINFO_RANDREWARDID_FIELD.full_name = ".Cmd.BossSceneInfo.randrewardid"
BOSSSCENEINFO_RANDREWARDID_FIELD.number = 2
BOSSSCENEINFO_RANDREWARDID_FIELD.index = 1
BOSSSCENEINFO_RANDREWARDID_FIELD.label = 3
BOSSSCENEINFO_RANDREWARDID_FIELD.has_default_value = false
BOSSSCENEINFO_RANDREWARDID_FIELD.default_value = {}
BOSSSCENEINFO_RANDREWARDID_FIELD.type = 13
BOSSSCENEINFO_RANDREWARDID_FIELD.cpp_type = 3
BOSSSCENEINFO_RANDNOREWARDID_FIELD.name = "randnorewardid"
BOSSSCENEINFO_RANDNOREWARDID_FIELD.full_name = ".Cmd.BossSceneInfo.randnorewardid"
BOSSSCENEINFO_RANDNOREWARDID_FIELD.number = 3
BOSSSCENEINFO_RANDNOREWARDID_FIELD.index = 2
BOSSSCENEINFO_RANDNOREWARDID_FIELD.label = 3
BOSSSCENEINFO_RANDNOREWARDID_FIELD.has_default_value = false
BOSSSCENEINFO_RANDNOREWARDID_FIELD.default_value = {}
BOSSSCENEINFO_RANDNOREWARDID_FIELD.type = 13
BOSSSCENEINFO_RANDNOREWARDID_FIELD.cpp_type = 3
BOSSSCENEINFO_SHOWREWARDS_FIELD.name = "showrewards"
BOSSSCENEINFO_SHOWREWARDS_FIELD.full_name = ".Cmd.BossSceneInfo.showrewards"
BOSSSCENEINFO_SHOWREWARDS_FIELD.number = 4
BOSSSCENEINFO_SHOWREWARDS_FIELD.index = 3
BOSSSCENEINFO_SHOWREWARDS_FIELD.label = 3
BOSSSCENEINFO_SHOWREWARDS_FIELD.has_default_value = false
BOSSSCENEINFO_SHOWREWARDS_FIELD.default_value = {}
BOSSSCENEINFO_SHOWREWARDS_FIELD.message_type = _PVEPASSSHOWREWARD
BOSSSCENEINFO_SHOWREWARDS_FIELD.type = 11
BOSSSCENEINFO_SHOWREWARDS_FIELD.cpp_type = 10
BOSSSCENEINFO.name = "BossSceneInfo"
BOSSSCENEINFO.full_name = ".Cmd.BossSceneInfo"
BOSSSCENEINFO.nested_types = {}
BOSSSCENEINFO.enum_types = {}
BOSSSCENEINFO.fields = {
  BOSSSCENEINFO_BOSSID_FIELD,
  BOSSSCENEINFO_RANDREWARDID_FIELD,
  BOSSSCENEINFO_RANDNOREWARDID_FIELD,
  BOSSSCENEINFO_SHOWREWARDS_FIELD
}
BOSSSCENEINFO.is_extendable = false
BOSSSCENEINFO.extensions = {}
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.name = "showtype"
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.full_name = ".Cmd.PvePassShowReward.showtype"
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.number = 1
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.index = 0
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.label = 1
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.has_default_value = true
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.default_value = 1
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.enum_type = EREWARDSHOWTYPE
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.type = 14
PVEPASSSHOWREWARD_SHOWTYPE_FIELD.cpp_type = 8
PVEPASSSHOWREWARD_ITEM_FIELD.name = "item"
PVEPASSSHOWREWARD_ITEM_FIELD.full_name = ".Cmd.PvePassShowReward.item"
PVEPASSSHOWREWARD_ITEM_FIELD.number = 2
PVEPASSSHOWREWARD_ITEM_FIELD.index = 1
PVEPASSSHOWREWARD_ITEM_FIELD.label = 1
PVEPASSSHOWREWARD_ITEM_FIELD.has_default_value = false
PVEPASSSHOWREWARD_ITEM_FIELD.default_value = nil
PVEPASSSHOWREWARD_ITEM_FIELD.message_type = SceneItem_pb.ITEMINFO
PVEPASSSHOWREWARD_ITEM_FIELD.type = 11
PVEPASSSHOWREWARD_ITEM_FIELD.cpp_type = 10
PVEPASSSHOWREWARD_REWARDIDS_FIELD.name = "rewardids"
PVEPASSSHOWREWARD_REWARDIDS_FIELD.full_name = ".Cmd.PvePassShowReward.rewardids"
PVEPASSSHOWREWARD_REWARDIDS_FIELD.number = 3
PVEPASSSHOWREWARD_REWARDIDS_FIELD.index = 2
PVEPASSSHOWREWARD_REWARDIDS_FIELD.label = 1
PVEPASSSHOWREWARD_REWARDIDS_FIELD.has_default_value = false
PVEPASSSHOWREWARD_REWARDIDS_FIELD.default_value = 0
PVEPASSSHOWREWARD_REWARDIDS_FIELD.type = 13
PVEPASSSHOWREWARD_REWARDIDS_FIELD.cpp_type = 3
PVEPASSSHOWREWARD.name = "PvePassShowReward"
PVEPASSSHOWREWARD.full_name = ".Cmd.PvePassShowReward"
PVEPASSSHOWREWARD.nested_types = {}
PVEPASSSHOWREWARD.enum_types = {}
PVEPASSSHOWREWARD.fields = {
  PVEPASSSHOWREWARD_SHOWTYPE_FIELD,
  PVEPASSSHOWREWARD_ITEM_FIELD,
  PVEPASSSHOWREWARD_REWARDIDS_FIELD
}
PVEPASSSHOWREWARD.is_extendable = false
PVEPASSSHOWREWARD.extensions = {}
PVEPASSINFO_ID_FIELD.name = "id"
PVEPASSINFO_ID_FIELD.full_name = ".Cmd.PvePassInfo.id"
PVEPASSINFO_ID_FIELD.number = 1
PVEPASSINFO_ID_FIELD.index = 0
PVEPASSINFO_ID_FIELD.label = 1
PVEPASSINFO_ID_FIELD.has_default_value = false
PVEPASSINFO_ID_FIELD.default_value = 0
PVEPASSINFO_ID_FIELD.type = 13
PVEPASSINFO_ID_FIELD.cpp_type = 3
PVEPASSINFO_FIRSTPASS_FIELD.name = "firstpass"
PVEPASSINFO_FIRSTPASS_FIELD.full_name = ".Cmd.PvePassInfo.firstpass"
PVEPASSINFO_FIRSTPASS_FIELD.number = 2
PVEPASSINFO_FIRSTPASS_FIELD.index = 1
PVEPASSINFO_FIRSTPASS_FIELD.label = 1
PVEPASSINFO_FIRSTPASS_FIELD.has_default_value = false
PVEPASSINFO_FIRSTPASS_FIELD.default_value = false
PVEPASSINFO_FIRSTPASS_FIELD.type = 8
PVEPASSINFO_FIRSTPASS_FIELD.cpp_type = 7
PVEPASSINFO_PASSTIME_FIELD.name = "passtime"
PVEPASSINFO_PASSTIME_FIELD.full_name = ".Cmd.PvePassInfo.passtime"
PVEPASSINFO_PASSTIME_FIELD.number = 3
PVEPASSINFO_PASSTIME_FIELD.index = 2
PVEPASSINFO_PASSTIME_FIELD.label = 1
PVEPASSINFO_PASSTIME_FIELD.has_default_value = false
PVEPASSINFO_PASSTIME_FIELD.default_value = 0
PVEPASSINFO_PASSTIME_FIELD.type = 5
PVEPASSINFO_PASSTIME_FIELD.cpp_type = 1
PVEPASSINFO_OPEN_FIELD.name = "open"
PVEPASSINFO_OPEN_FIELD.full_name = ".Cmd.PvePassInfo.open"
PVEPASSINFO_OPEN_FIELD.number = 4
PVEPASSINFO_OPEN_FIELD.index = 3
PVEPASSINFO_OPEN_FIELD.label = 1
PVEPASSINFO_OPEN_FIELD.has_default_value = true
PVEPASSINFO_OPEN_FIELD.default_value = false
PVEPASSINFO_OPEN_FIELD.type = 8
PVEPASSINFO_OPEN_FIELD.cpp_type = 7
PVEPASSINFO_QUICK_FIELD.name = "quick"
PVEPASSINFO_QUICK_FIELD.full_name = ".Cmd.PvePassInfo.quick"
PVEPASSINFO_QUICK_FIELD.number = 5
PVEPASSINFO_QUICK_FIELD.index = 4
PVEPASSINFO_QUICK_FIELD.label = 1
PVEPASSINFO_QUICK_FIELD.has_default_value = false
PVEPASSINFO_QUICK_FIELD.default_value = false
PVEPASSINFO_QUICK_FIELD.type = 8
PVEPASSINFO_QUICK_FIELD.cpp_type = 7
PVEPASSINFO_PICKUP_FIELD.name = "pickup"
PVEPASSINFO_PICKUP_FIELD.full_name = ".Cmd.PvePassInfo.pickup"
PVEPASSINFO_PICKUP_FIELD.number = 6
PVEPASSINFO_PICKUP_FIELD.index = 5
PVEPASSINFO_PICKUP_FIELD.label = 1
PVEPASSINFO_PICKUP_FIELD.has_default_value = false
PVEPASSINFO_PICKUP_FIELD.default_value = false
PVEPASSINFO_PICKUP_FIELD.type = 8
PVEPASSINFO_PICKUP_FIELD.cpp_type = 7
PVEPASSINFO_NORLENFIRST_FIELD.name = "norlenfirst"
PVEPASSINFO_NORLENFIRST_FIELD.full_name = ".Cmd.PvePassInfo.norlenfirst"
PVEPASSINFO_NORLENFIRST_FIELD.number = 7
PVEPASSINFO_NORLENFIRST_FIELD.index = 6
PVEPASSINFO_NORLENFIRST_FIELD.label = 1
PVEPASSINFO_NORLENFIRST_FIELD.has_default_value = false
PVEPASSINFO_NORLENFIRST_FIELD.default_value = false
PVEPASSINFO_NORLENFIRST_FIELD.type = 8
PVEPASSINFO_NORLENFIRST_FIELD.cpp_type = 7
PVEPASSINFO_PASS_FIELD.name = "pass"
PVEPASSINFO_PASS_FIELD.full_name = ".Cmd.PvePassInfo.pass"
PVEPASSINFO_PASS_FIELD.number = 8
PVEPASSINFO_PASS_FIELD.index = 7
PVEPASSINFO_PASS_FIELD.label = 1
PVEPASSINFO_PASS_FIELD.has_default_value = false
PVEPASSINFO_PASS_FIELD.default_value = false
PVEPASSINFO_PASS_FIELD.type = 8
PVEPASSINFO_PASS_FIELD.cpp_type = 7
PVEPASSINFO_BOSSINFO_FIELD.name = "bossinfo"
PVEPASSINFO_BOSSINFO_FIELD.full_name = ".Cmd.PvePassInfo.bossinfo"
PVEPASSINFO_BOSSINFO_FIELD.number = 9
PVEPASSINFO_BOSSINFO_FIELD.index = 8
PVEPASSINFO_BOSSINFO_FIELD.label = 3
PVEPASSINFO_BOSSINFO_FIELD.has_default_value = false
PVEPASSINFO_BOSSINFO_FIELD.default_value = {}
PVEPASSINFO_BOSSINFO_FIELD.message_type = BOSSSCENEINFO
PVEPASSINFO_BOSSINFO_FIELD.type = 11
PVEPASSINFO_BOSSINFO_FIELD.cpp_type = 10
PVEPASSINFO_SHOWBOSSIDS_FIELD.name = "showbossids"
PVEPASSINFO_SHOWBOSSIDS_FIELD.full_name = ".Cmd.PvePassInfo.showbossids"
PVEPASSINFO_SHOWBOSSIDS_FIELD.number = 10
PVEPASSINFO_SHOWBOSSIDS_FIELD.index = 9
PVEPASSINFO_SHOWBOSSIDS_FIELD.label = 3
PVEPASSINFO_SHOWBOSSIDS_FIELD.has_default_value = false
PVEPASSINFO_SHOWBOSSIDS_FIELD.default_value = {}
PVEPASSINFO_SHOWBOSSIDS_FIELD.type = 13
PVEPASSINFO_SHOWBOSSIDS_FIELD.cpp_type = 3
PVEPASSINFO_SHOWREWARDS_FIELD.name = "showrewards"
PVEPASSINFO_SHOWREWARDS_FIELD.full_name = ".Cmd.PvePassInfo.showrewards"
PVEPASSINFO_SHOWREWARDS_FIELD.number = 11
PVEPASSINFO_SHOWREWARDS_FIELD.index = 10
PVEPASSINFO_SHOWREWARDS_FIELD.label = 3
PVEPASSINFO_SHOWREWARDS_FIELD.has_default_value = false
PVEPASSINFO_SHOWREWARDS_FIELD.default_value = {}
PVEPASSINFO_SHOWREWARDS_FIELD.message_type = PVEPASSSHOWREWARD
PVEPASSINFO_SHOWREWARDS_FIELD.type = 11
PVEPASSINFO_SHOWREWARDS_FIELD.cpp_type = 10
PVEPASSINFO_RESET_TIME_FIELD.name = "reset_time"
PVEPASSINFO_RESET_TIME_FIELD.full_name = ".Cmd.PvePassInfo.reset_time"
PVEPASSINFO_RESET_TIME_FIELD.number = 12
PVEPASSINFO_RESET_TIME_FIELD.index = 11
PVEPASSINFO_RESET_TIME_FIELD.label = 1
PVEPASSINFO_RESET_TIME_FIELD.has_default_value = false
PVEPASSINFO_RESET_TIME_FIELD.default_value = 0
PVEPASSINFO_RESET_TIME_FIELD.type = 13
PVEPASSINFO_RESET_TIME_FIELD.cpp_type = 3
PVEPASSINFO_KILL_BOSS_NUM_FIELD.name = "kill_boss_num"
PVEPASSINFO_KILL_BOSS_NUM_FIELD.full_name = ".Cmd.PvePassInfo.kill_boss_num"
PVEPASSINFO_KILL_BOSS_NUM_FIELD.number = 13
PVEPASSINFO_KILL_BOSS_NUM_FIELD.index = 12
PVEPASSINFO_KILL_BOSS_NUM_FIELD.label = 1
PVEPASSINFO_KILL_BOSS_NUM_FIELD.has_default_value = false
PVEPASSINFO_KILL_BOSS_NUM_FIELD.default_value = 0
PVEPASSINFO_KILL_BOSS_NUM_FIELD.type = 13
PVEPASSINFO_KILL_BOSS_NUM_FIELD.cpp_type = 3
PVEPASSINFO_MVP_REST_TIME_FIELD.name = "mvp_rest_time"
PVEPASSINFO_MVP_REST_TIME_FIELD.full_name = ".Cmd.PvePassInfo.mvp_rest_time"
PVEPASSINFO_MVP_REST_TIME_FIELD.number = 14
PVEPASSINFO_MVP_REST_TIME_FIELD.index = 13
PVEPASSINFO_MVP_REST_TIME_FIELD.label = 1
PVEPASSINFO_MVP_REST_TIME_FIELD.has_default_value = false
PVEPASSINFO_MVP_REST_TIME_FIELD.default_value = 0
PVEPASSINFO_MVP_REST_TIME_FIELD.type = 5
PVEPASSINFO_MVP_REST_TIME_FIELD.cpp_type = 1
PVEPASSINFO_MINI_REST_TIME_FIELD.name = "mini_rest_time"
PVEPASSINFO_MINI_REST_TIME_FIELD.full_name = ".Cmd.PvePassInfo.mini_rest_time"
PVEPASSINFO_MINI_REST_TIME_FIELD.number = 15
PVEPASSINFO_MINI_REST_TIME_FIELD.index = 14
PVEPASSINFO_MINI_REST_TIME_FIELD.label = 1
PVEPASSINFO_MINI_REST_TIME_FIELD.has_default_value = false
PVEPASSINFO_MINI_REST_TIME_FIELD.default_value = 0
PVEPASSINFO_MINI_REST_TIME_FIELD.type = 5
PVEPASSINFO_MINI_REST_TIME_FIELD.cpp_type = 1
PVEPASSINFO_GRADE_FIELD.name = "grade"
PVEPASSINFO_GRADE_FIELD.full_name = ".Cmd.PvePassInfo.grade"
PVEPASSINFO_GRADE_FIELD.number = 16
PVEPASSINFO_GRADE_FIELD.index = 15
PVEPASSINFO_GRADE_FIELD.label = 1
PVEPASSINFO_GRADE_FIELD.has_default_value = false
PVEPASSINFO_GRADE_FIELD.default_value = 0
PVEPASSINFO_GRADE_FIELD.type = 13
PVEPASSINFO_GRADE_FIELD.cpp_type = 3
PVEPASSINFO_FREE_FIELD.name = "free"
PVEPASSINFO_FREE_FIELD.full_name = ".Cmd.PvePassInfo.free"
PVEPASSINFO_FREE_FIELD.number = 17
PVEPASSINFO_FREE_FIELD.index = 16
PVEPASSINFO_FREE_FIELD.label = 1
PVEPASSINFO_FREE_FIELD.has_default_value = false
PVEPASSINFO_FREE_FIELD.default_value = false
PVEPASSINFO_FREE_FIELD.type = 8
PVEPASSINFO_FREE_FIELD.cpp_type = 7
PVEPASSINFO_STARS_FIELD.name = "stars"
PVEPASSINFO_STARS_FIELD.full_name = ".Cmd.PvePassInfo.stars"
PVEPASSINFO_STARS_FIELD.number = 18
PVEPASSINFO_STARS_FIELD.index = 17
PVEPASSINFO_STARS_FIELD.label = 3
PVEPASSINFO_STARS_FIELD.has_default_value = false
PVEPASSINFO_STARS_FIELD.default_value = {}
PVEPASSINFO_STARS_FIELD.type = 13
PVEPASSINFO_STARS_FIELD.cpp_type = 3
PVEPASSINFO_ACC_PASS_FIELD.name = "acc_pass"
PVEPASSINFO_ACC_PASS_FIELD.full_name = ".Cmd.PvePassInfo.acc_pass"
PVEPASSINFO_ACC_PASS_FIELD.number = 19
PVEPASSINFO_ACC_PASS_FIELD.index = 18
PVEPASSINFO_ACC_PASS_FIELD.label = 1
PVEPASSINFO_ACC_PASS_FIELD.has_default_value = false
PVEPASSINFO_ACC_PASS_FIELD.default_value = false
PVEPASSINFO_ACC_PASS_FIELD.type = 8
PVEPASSINFO_ACC_PASS_FIELD.cpp_type = 7
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.name = "astral_pray_group"
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.full_name = ".Cmd.PvePassInfo.astral_pray_group"
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.number = 20
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.index = 19
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.label = 1
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.has_default_value = false
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.default_value = 0
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.type = 13
PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD.cpp_type = 3
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.name = "astral_pray_id"
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.full_name = ".Cmd.PvePassInfo.astral_pray_id"
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.number = 21
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.index = 20
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.label = 1
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.has_default_value = false
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.default_value = 0
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.type = 13
PVEPASSINFO_ASTRAL_PRAY_ID_FIELD.cpp_type = 3
PVEPASSINFO_NO_SHOW_LABEL_FIELD.name = "no_show_label"
PVEPASSINFO_NO_SHOW_LABEL_FIELD.full_name = ".Cmd.PvePassInfo.no_show_label"
PVEPASSINFO_NO_SHOW_LABEL_FIELD.number = 22
PVEPASSINFO_NO_SHOW_LABEL_FIELD.index = 21
PVEPASSINFO_NO_SHOW_LABEL_FIELD.label = 1
PVEPASSINFO_NO_SHOW_LABEL_FIELD.has_default_value = false
PVEPASSINFO_NO_SHOW_LABEL_FIELD.default_value = false
PVEPASSINFO_NO_SHOW_LABEL_FIELD.type = 8
PVEPASSINFO_NO_SHOW_LABEL_FIELD.cpp_type = 7
PVEPASSINFO_ACT_END_TIME_FIELD.name = "act_end_time"
PVEPASSINFO_ACT_END_TIME_FIELD.full_name = ".Cmd.PvePassInfo.act_end_time"
PVEPASSINFO_ACT_END_TIME_FIELD.number = 23
PVEPASSINFO_ACT_END_TIME_FIELD.index = 22
PVEPASSINFO_ACT_END_TIME_FIELD.label = 1
PVEPASSINFO_ACT_END_TIME_FIELD.has_default_value = false
PVEPASSINFO_ACT_END_TIME_FIELD.default_value = 0
PVEPASSINFO_ACT_END_TIME_FIELD.type = 13
PVEPASSINFO_ACT_END_TIME_FIELD.cpp_type = 3
PVEPASSINFO_AFFIXIDS_FIELD.name = "affixids"
PVEPASSINFO_AFFIXIDS_FIELD.full_name = ".Cmd.PvePassInfo.affixids"
PVEPASSINFO_AFFIXIDS_FIELD.number = 24
PVEPASSINFO_AFFIXIDS_FIELD.index = 23
PVEPASSINFO_AFFIXIDS_FIELD.label = 3
PVEPASSINFO_AFFIXIDS_FIELD.has_default_value = false
PVEPASSINFO_AFFIXIDS_FIELD.default_value = {}
PVEPASSINFO_AFFIXIDS_FIELD.type = 13
PVEPASSINFO_AFFIXIDS_FIELD.cpp_type = 3
PVEPASSINFO.name = "PvePassInfo"
PVEPASSINFO.full_name = ".Cmd.PvePassInfo"
PVEPASSINFO.nested_types = {}
PVEPASSINFO.enum_types = {}
PVEPASSINFO.fields = {
  PVEPASSINFO_ID_FIELD,
  PVEPASSINFO_FIRSTPASS_FIELD,
  PVEPASSINFO_PASSTIME_FIELD,
  PVEPASSINFO_OPEN_FIELD,
  PVEPASSINFO_QUICK_FIELD,
  PVEPASSINFO_PICKUP_FIELD,
  PVEPASSINFO_NORLENFIRST_FIELD,
  PVEPASSINFO_PASS_FIELD,
  PVEPASSINFO_BOSSINFO_FIELD,
  PVEPASSINFO_SHOWBOSSIDS_FIELD,
  PVEPASSINFO_SHOWREWARDS_FIELD,
  PVEPASSINFO_RESET_TIME_FIELD,
  PVEPASSINFO_KILL_BOSS_NUM_FIELD,
  PVEPASSINFO_MVP_REST_TIME_FIELD,
  PVEPASSINFO_MINI_REST_TIME_FIELD,
  PVEPASSINFO_GRADE_FIELD,
  PVEPASSINFO_FREE_FIELD,
  PVEPASSINFO_STARS_FIELD,
  PVEPASSINFO_ACC_PASS_FIELD,
  PVEPASSINFO_ASTRAL_PRAY_GROUP_FIELD,
  PVEPASSINFO_ASTRAL_PRAY_ID_FIELD,
  PVEPASSINFO_NO_SHOW_LABEL_FIELD,
  PVEPASSINFO_ACT_END_TIME_FIELD,
  PVEPASSINFO_AFFIXIDS_FIELD
}
PVEPASSINFO.is_extendable = false
PVEPASSINFO.extensions = {}
OBMOVECAMERAPREPARECMD_CMD_FIELD.name = "cmd"
OBMOVECAMERAPREPARECMD_CMD_FIELD.full_name = ".Cmd.ObMoveCameraPrepareCmd.cmd"
OBMOVECAMERAPREPARECMD_CMD_FIELD.number = 1
OBMOVECAMERAPREPARECMD_CMD_FIELD.index = 0
OBMOVECAMERAPREPARECMD_CMD_FIELD.label = 1
OBMOVECAMERAPREPARECMD_CMD_FIELD.has_default_value = true
OBMOVECAMERAPREPARECMD_CMD_FIELD.default_value = 11
OBMOVECAMERAPREPARECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBMOVECAMERAPREPARECMD_CMD_FIELD.type = 14
OBMOVECAMERAPREPARECMD_CMD_FIELD.cpp_type = 8
OBMOVECAMERAPREPARECMD_PARAM_FIELD.name = "param"
OBMOVECAMERAPREPARECMD_PARAM_FIELD.full_name = ".Cmd.ObMoveCameraPrepareCmd.param"
OBMOVECAMERAPREPARECMD_PARAM_FIELD.number = 2
OBMOVECAMERAPREPARECMD_PARAM_FIELD.index = 1
OBMOVECAMERAPREPARECMD_PARAM_FIELD.label = 1
OBMOVECAMERAPREPARECMD_PARAM_FIELD.has_default_value = true
OBMOVECAMERAPREPARECMD_PARAM_FIELD.default_value = 108
OBMOVECAMERAPREPARECMD_PARAM_FIELD.enum_type = FUBENPARAM
OBMOVECAMERAPREPARECMD_PARAM_FIELD.type = 14
OBMOVECAMERAPREPARECMD_PARAM_FIELD.cpp_type = 8
OBMOVECAMERAPREPARECMD.name = "ObMoveCameraPrepareCmd"
OBMOVECAMERAPREPARECMD.full_name = ".Cmd.ObMoveCameraPrepareCmd"
OBMOVECAMERAPREPARECMD.nested_types = {}
OBMOVECAMERAPREPARECMD.enum_types = {}
OBMOVECAMERAPREPARECMD.fields = {
  OBMOVECAMERAPREPARECMD_CMD_FIELD,
  OBMOVECAMERAPREPARECMD_PARAM_FIELD
}
OBMOVECAMERAPREPARECMD.is_extendable = false
OBMOVECAMERAPREPARECMD.extensions = {}
OBCAMERAMOVEENDCMD_CMD_FIELD.name = "cmd"
OBCAMERAMOVEENDCMD_CMD_FIELD.full_name = ".Cmd.ObCameraMoveEndCmd.cmd"
OBCAMERAMOVEENDCMD_CMD_FIELD.number = 1
OBCAMERAMOVEENDCMD_CMD_FIELD.index = 0
OBCAMERAMOVEENDCMD_CMD_FIELD.label = 1
OBCAMERAMOVEENDCMD_CMD_FIELD.has_default_value = true
OBCAMERAMOVEENDCMD_CMD_FIELD.default_value = 11
OBCAMERAMOVEENDCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OBCAMERAMOVEENDCMD_CMD_FIELD.type = 14
OBCAMERAMOVEENDCMD_CMD_FIELD.cpp_type = 8
OBCAMERAMOVEENDCMD_PARAM_FIELD.name = "param"
OBCAMERAMOVEENDCMD_PARAM_FIELD.full_name = ".Cmd.ObCameraMoveEndCmd.param"
OBCAMERAMOVEENDCMD_PARAM_FIELD.number = 2
OBCAMERAMOVEENDCMD_PARAM_FIELD.index = 1
OBCAMERAMOVEENDCMD_PARAM_FIELD.label = 1
OBCAMERAMOVEENDCMD_PARAM_FIELD.has_default_value = true
OBCAMERAMOVEENDCMD_PARAM_FIELD.default_value = 109
OBCAMERAMOVEENDCMD_PARAM_FIELD.enum_type = FUBENPARAM
OBCAMERAMOVEENDCMD_PARAM_FIELD.type = 14
OBCAMERAMOVEENDCMD_PARAM_FIELD.cpp_type = 8
OBCAMERAMOVEENDCMD.name = "ObCameraMoveEndCmd"
OBCAMERAMOVEENDCMD.full_name = ".Cmd.ObCameraMoveEndCmd"
OBCAMERAMOVEENDCMD.nested_types = {}
OBCAMERAMOVEENDCMD.enum_types = {}
OBCAMERAMOVEENDCMD.fields = {
  OBCAMERAMOVEENDCMD_CMD_FIELD,
  OBCAMERAMOVEENDCMD_PARAM_FIELD
}
OBCAMERAMOVEENDCMD.is_extendable = false
OBCAMERAMOVEENDCMD.extensions = {}
KILLNUM_CAMP_FIELD.name = "camp"
KILLNUM_CAMP_FIELD.full_name = ".Cmd.KillNum.camp"
KILLNUM_CAMP_FIELD.number = 1
KILLNUM_CAMP_FIELD.index = 0
KILLNUM_CAMP_FIELD.label = 1
KILLNUM_CAMP_FIELD.has_default_value = false
KILLNUM_CAMP_FIELD.default_value = 0
KILLNUM_CAMP_FIELD.type = 13
KILLNUM_CAMP_FIELD.cpp_type = 3
KILLNUM_KILL_NUM_FIELD.name = "kill_num"
KILLNUM_KILL_NUM_FIELD.full_name = ".Cmd.KillNum.kill_num"
KILLNUM_KILL_NUM_FIELD.number = 2
KILLNUM_KILL_NUM_FIELD.index = 1
KILLNUM_KILL_NUM_FIELD.label = 1
KILLNUM_KILL_NUM_FIELD.has_default_value = false
KILLNUM_KILL_NUM_FIELD.default_value = 0
KILLNUM_KILL_NUM_FIELD.type = 13
KILLNUM_KILL_NUM_FIELD.cpp_type = 3
KILLNUM.name = "KillNum"
KILLNUM.full_name = ".Cmd.KillNum"
KILLNUM.nested_types = {}
KILLNUM.enum_types = {}
KILLNUM.fields = {
  KILLNUM_CAMP_FIELD,
  KILLNUM_KILL_NUM_FIELD
}
KILLNUM.is_extendable = false
KILLNUM.extensions = {}
RAIDKILLNUMSYNCCMD_CMD_FIELD.name = "cmd"
RAIDKILLNUMSYNCCMD_CMD_FIELD.full_name = ".Cmd.RaidKillNumSyncCmd.cmd"
RAIDKILLNUMSYNCCMD_CMD_FIELD.number = 1
RAIDKILLNUMSYNCCMD_CMD_FIELD.index = 0
RAIDKILLNUMSYNCCMD_CMD_FIELD.label = 1
RAIDKILLNUMSYNCCMD_CMD_FIELD.has_default_value = true
RAIDKILLNUMSYNCCMD_CMD_FIELD.default_value = 11
RAIDKILLNUMSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDKILLNUMSYNCCMD_CMD_FIELD.type = 14
RAIDKILLNUMSYNCCMD_CMD_FIELD.cpp_type = 8
RAIDKILLNUMSYNCCMD_PARAM_FIELD.name = "param"
RAIDKILLNUMSYNCCMD_PARAM_FIELD.full_name = ".Cmd.RaidKillNumSyncCmd.param"
RAIDKILLNUMSYNCCMD_PARAM_FIELD.number = 2
RAIDKILLNUMSYNCCMD_PARAM_FIELD.index = 1
RAIDKILLNUMSYNCCMD_PARAM_FIELD.label = 1
RAIDKILLNUMSYNCCMD_PARAM_FIELD.has_default_value = true
RAIDKILLNUMSYNCCMD_PARAM_FIELD.default_value = 110
RAIDKILLNUMSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDKILLNUMSYNCCMD_PARAM_FIELD.type = 14
RAIDKILLNUMSYNCCMD_PARAM_FIELD.cpp_type = 8
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.name = "kill_nums"
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.full_name = ".Cmd.RaidKillNumSyncCmd.kill_nums"
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.number = 3
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.index = 2
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.label = 3
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.has_default_value = false
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.default_value = {}
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.message_type = KILLNUM
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.type = 11
RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD.cpp_type = 10
RAIDKILLNUMSYNCCMD.name = "RaidKillNumSyncCmd"
RAIDKILLNUMSYNCCMD.full_name = ".Cmd.RaidKillNumSyncCmd"
RAIDKILLNUMSYNCCMD.nested_types = {}
RAIDKILLNUMSYNCCMD.enum_types = {}
RAIDKILLNUMSYNCCMD.fields = {
  RAIDKILLNUMSYNCCMD_CMD_FIELD,
  RAIDKILLNUMSYNCCMD_PARAM_FIELD,
  RAIDKILLNUMSYNCCMD_KILL_NUMS_FIELD
}
RAIDKILLNUMSYNCCMD.is_extendable = false
RAIDKILLNUMSYNCCMD.extensions = {}
LASTBOSSSCENEINFO_ID_FIELD.name = "id"
LASTBOSSSCENEINFO_ID_FIELD.full_name = ".Cmd.LastBossSceneInfo.id"
LASTBOSSSCENEINFO_ID_FIELD.number = 1
LASTBOSSSCENEINFO_ID_FIELD.index = 0
LASTBOSSSCENEINFO_ID_FIELD.label = 1
LASTBOSSSCENEINFO_ID_FIELD.has_default_value = false
LASTBOSSSCENEINFO_ID_FIELD.default_value = 0
LASTBOSSSCENEINFO_ID_FIELD.type = 13
LASTBOSSSCENEINFO_ID_FIELD.cpp_type = 3
LASTBOSSSCENEINFO_BOSSID_FIELD.name = "bossid"
LASTBOSSSCENEINFO_BOSSID_FIELD.full_name = ".Cmd.LastBossSceneInfo.bossid"
LASTBOSSSCENEINFO_BOSSID_FIELD.number = 2
LASTBOSSSCENEINFO_BOSSID_FIELD.index = 1
LASTBOSSSCENEINFO_BOSSID_FIELD.label = 1
LASTBOSSSCENEINFO_BOSSID_FIELD.has_default_value = false
LASTBOSSSCENEINFO_BOSSID_FIELD.default_value = 0
LASTBOSSSCENEINFO_BOSSID_FIELD.type = 13
LASTBOSSSCENEINFO_BOSSID_FIELD.cpp_type = 3
LASTBOSSSCENEINFO.name = "LastBossSceneInfo"
LASTBOSSSCENEINFO.full_name = ".Cmd.LastBossSceneInfo"
LASTBOSSSCENEINFO.nested_types = {}
LASTBOSSSCENEINFO.enum_types = {}
LASTBOSSSCENEINFO.fields = {
  LASTBOSSSCENEINFO_ID_FIELD,
  LASTBOSSSCENEINFO_BOSSID_FIELD
}
LASTBOSSSCENEINFO.is_extendable = false
LASTBOSSSCENEINFO.extensions = {}
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.cmd"
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.number = 1
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.index = 0
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.type = 14
SYNCPVEPASSINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.param"
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.default_value = 118
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.name = "passinfos"
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.passinfos"
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.number = 3
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.index = 2
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.label = 3
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.default_value = {}
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.message_type = PVEPASSINFO
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.type = 11
SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD.cpp_type = 10
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.name = "battletime"
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.battletime"
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.number = 4
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.index = 3
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.name = "totalbattletime"
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.totalbattletime"
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.number = 5
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.index = 4
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.name = "playtime"
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.playtime"
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.number = 6
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.index = 5
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.name = "totalplaytime"
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.totalplaytime"
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.number = 7
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.index = 6
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.name = "lastinfo"
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.lastinfo"
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.number = 8
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.index = 7
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.default_value = nil
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.message_type = LASTBOSSSCENEINFO
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.type = 11
SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD.cpp_type = 10
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.name = "quick_boss"
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.quick_boss"
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.number = 10
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.index = 8
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.label = 3
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.default_value = {}
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.name = "endlessrewardlayer"
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.endlessrewardlayer"
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.number = 11
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.index = 9
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.name = "all_crack_non_first"
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.all_crack_non_first"
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.number = 12
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.index = 10
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.name = "astral_season"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.astral_season"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.number = 13
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.index = 11
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.name = "astral_gotten_reward"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.astral_gotten_reward"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.number = 14
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.index = 12
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.label = 3
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.default_value = {}
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.name = "astral_pass_num"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.full_name = ".Cmd.SyncPvePassInfoFubenCmd.astral_pass_num"
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.number = 15
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.index = 13
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.label = 1
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.has_default_value = false
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.default_value = 0
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.type = 13
SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD.cpp_type = 3
SYNCPVEPASSINFOFUBENCMD.name = "SyncPvePassInfoFubenCmd"
SYNCPVEPASSINFOFUBENCMD.full_name = ".Cmd.SyncPvePassInfoFubenCmd"
SYNCPVEPASSINFOFUBENCMD.nested_types = {}
SYNCPVEPASSINFOFUBENCMD.enum_types = {}
SYNCPVEPASSINFOFUBENCMD.fields = {
  SYNCPVEPASSINFOFUBENCMD_CMD_FIELD,
  SYNCPVEPASSINFOFUBENCMD_PARAM_FIELD,
  SYNCPVEPASSINFOFUBENCMD_PASSINFOS_FIELD,
  SYNCPVEPASSINFOFUBENCMD_BATTLETIME_FIELD,
  SYNCPVEPASSINFOFUBENCMD_TOTALBATTLETIME_FIELD,
  SYNCPVEPASSINFOFUBENCMD_PLAYTIME_FIELD,
  SYNCPVEPASSINFOFUBENCMD_TOTALPLAYTIME_FIELD,
  SYNCPVEPASSINFOFUBENCMD_LASTINFO_FIELD,
  SYNCPVEPASSINFOFUBENCMD_QUICK_BOSS_FIELD,
  SYNCPVEPASSINFOFUBENCMD_ENDLESSREWARDLAYER_FIELD,
  SYNCPVEPASSINFOFUBENCMD_ALL_CRACK_NON_FIRST_FIELD,
  SYNCPVEPASSINFOFUBENCMD_ASTRAL_SEASON_FIELD,
  SYNCPVEPASSINFOFUBENCMD_ASTRAL_GOTTEN_REWARD_FIELD,
  SYNCPVEPASSINFOFUBENCMD_ASTRAL_PASS_NUM_FIELD
}
SYNCPVEPASSINFOFUBENCMD.is_extendable = false
SYNCPVEPASSINFOFUBENCMD.extensions = {}
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.name = "cmd"
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncPveRaidAchieveFubenCmd.cmd"
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.number = 1
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.index = 0
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.label = 1
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.has_default_value = true
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.default_value = 11
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.type = 14
SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.name = "param"
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncPveRaidAchieveFubenCmd.param"
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.number = 2
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.index = 1
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.label = 1
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.default_value = 126
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.type = 14
SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.name = "achieveinfos"
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.full_name = ".Cmd.SyncPveRaidAchieveFubenCmd.achieveinfos"
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.number = 3
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.index = 2
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.label = 3
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.has_default_value = false
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.default_value = {}
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.message_type = PVERAIDACHIEVE
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.type = 11
SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD.cpp_type = 10
SYNCPVERAIDACHIEVEFUBENCMD.name = "SyncPveRaidAchieveFubenCmd"
SYNCPVERAIDACHIEVEFUBENCMD.full_name = ".Cmd.SyncPveRaidAchieveFubenCmd"
SYNCPVERAIDACHIEVEFUBENCMD.nested_types = {}
SYNCPVERAIDACHIEVEFUBENCMD.enum_types = {}
SYNCPVERAIDACHIEVEFUBENCMD.fields = {
  SYNCPVERAIDACHIEVEFUBENCMD_CMD_FIELD,
  SYNCPVERAIDACHIEVEFUBENCMD_PARAM_FIELD,
  SYNCPVERAIDACHIEVEFUBENCMD_ACHIEVEINFOS_FIELD
}
SYNCPVERAIDACHIEVEFUBENCMD.is_extendable = false
SYNCPVERAIDACHIEVEFUBENCMD.extensions = {}
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.name = "cmd"
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.full_name = ".Cmd.QuickFinishCrackRaidFubenCmd.cmd"
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.number = 1
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.index = 0
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.label = 1
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.has_default_value = true
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.default_value = 11
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.type = 14
QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD.cpp_type = 8
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.name = "param"
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.QuickFinishCrackRaidFubenCmd.param"
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.number = 2
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.index = 1
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.label = 1
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.has_default_value = true
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.default_value = 127
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.type = 14
QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD.cpp_type = 8
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.name = "raidid"
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.full_name = ".Cmd.QuickFinishCrackRaidFubenCmd.raidid"
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.number = 3
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.index = 2
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.label = 1
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.has_default_value = false
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.default_value = 0
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.type = 13
QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD.cpp_type = 3
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.name = "use_sweep_ticket"
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.full_name = ".Cmd.QuickFinishCrackRaidFubenCmd.use_sweep_ticket"
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.number = 4
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.index = 3
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.label = 1
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.has_default_value = false
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.default_value = false
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.type = 8
QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.cpp_type = 7
QUICKFINISHCRACKRAIDFUBENCMD.name = "QuickFinishCrackRaidFubenCmd"
QUICKFINISHCRACKRAIDFUBENCMD.full_name = ".Cmd.QuickFinishCrackRaidFubenCmd"
QUICKFINISHCRACKRAIDFUBENCMD.nested_types = {}
QUICKFINISHCRACKRAIDFUBENCMD.enum_types = {}
QUICKFINISHCRACKRAIDFUBENCMD.fields = {
  QUICKFINISHCRACKRAIDFUBENCMD_CMD_FIELD,
  QUICKFINISHCRACKRAIDFUBENCMD_PARAM_FIELD,
  QUICKFINISHCRACKRAIDFUBENCMD_RAIDID_FIELD,
  QUICKFINISHCRACKRAIDFUBENCMD_USE_SWEEP_TICKET_FIELD
}
QUICKFINISHCRACKRAIDFUBENCMD.is_extendable = false
QUICKFINISHCRACKRAIDFUBENCMD.extensions = {}
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.name = "cmd"
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.full_name = ".Cmd.PickupPveRaidAchieveFubenCmd.cmd"
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.number = 1
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.index = 0
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.label = 1
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.has_default_value = true
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.default_value = 11
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.type = 14
PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD.cpp_type = 8
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.name = "param"
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.PickupPveRaidAchieveFubenCmd.param"
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.number = 2
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.index = 1
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.label = 1
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.has_default_value = true
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.default_value = 128
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.type = 14
PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD.cpp_type = 8
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.name = "groupid"
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.full_name = ".Cmd.PickupPveRaidAchieveFubenCmd.groupid"
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.number = 3
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.index = 2
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.label = 1
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.has_default_value = false
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.default_value = 0
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.type = 13
PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD.cpp_type = 3
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.name = "achieveid"
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.full_name = ".Cmd.PickupPveRaidAchieveFubenCmd.achieveid"
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.number = 4
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.index = 3
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.label = 1
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.has_default_value = false
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.default_value = 0
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.type = 13
PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD.cpp_type = 3
PICKUPPVERAIDACHIEVEFUBENCMD.name = "PickupPveRaidAchieveFubenCmd"
PICKUPPVERAIDACHIEVEFUBENCMD.full_name = ".Cmd.PickupPveRaidAchieveFubenCmd"
PICKUPPVERAIDACHIEVEFUBENCMD.nested_types = {}
PICKUPPVERAIDACHIEVEFUBENCMD.enum_types = {}
PICKUPPVERAIDACHIEVEFUBENCMD.fields = {
  PICKUPPVERAIDACHIEVEFUBENCMD_CMD_FIELD,
  PICKUPPVERAIDACHIEVEFUBENCMD_PARAM_FIELD,
  PICKUPPVERAIDACHIEVEFUBENCMD_GROUPID_FIELD,
  PICKUPPVERAIDACHIEVEFUBENCMD_ACHIEVEID_FIELD
}
PICKUPPVERAIDACHIEVEFUBENCMD.is_extendable = false
PICKUPPVERAIDACHIEVEFUBENCMD.extensions = {}
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgPointUpdateFubenCmd.cmd"
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.number = 1
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.index = 0
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.label = 1
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.default_value = 11
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.type = 14
GVGPOINTUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.name = "param"
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgPointUpdateFubenCmd.param"
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.number = 2
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.index = 1
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.label = 1
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.default_value = 119
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.type = 14
GVGPOINTUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.name = "info"
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.full_name = ".Cmd.GvgPointUpdateFubenCmd.info"
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.number = 3
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.index = 2
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.label = 3
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.has_default_value = false
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.default_value = {}
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.message_type = GVGPOINTINFO
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.type = 11
GVGPOINTUPDATEFUBENCMD_INFO_FIELD.cpp_type = 10
GVGPOINTUPDATEFUBENCMD.name = "GvgPointUpdateFubenCmd"
GVGPOINTUPDATEFUBENCMD.full_name = ".Cmd.GvgPointUpdateFubenCmd"
GVGPOINTUPDATEFUBENCMD.nested_types = {}
GVGPOINTUPDATEFUBENCMD.enum_types = {}
GVGPOINTUPDATEFUBENCMD.fields = {
  GVGPOINTUPDATEFUBENCMD_CMD_FIELD,
  GVGPOINTUPDATEFUBENCMD_PARAM_FIELD,
  GVGPOINTUPDATEFUBENCMD_INFO_FIELD
}
GVGPOINTUPDATEFUBENCMD.is_extendable = false
GVGPOINTUPDATEFUBENCMD.extensions = {}
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgRaidStateUpdateFubenCmd.cmd"
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.number = 1
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.index = 0
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.label = 1
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.default_value = 11
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.type = 14
GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.name = "param"
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgRaidStateUpdateFubenCmd.param"
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.number = 2
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.index = 1
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.label = 1
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.default_value = 122
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.type = 14
GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.name = "raidstate"
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.full_name = ".Cmd.GvgRaidStateUpdateFubenCmd.raidstate"
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.number = 3
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.index = 2
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.label = 1
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.has_default_value = false
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.default_value = nil
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.enum_type = EGVGRAIDSTATE
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.type = 14
GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD.cpp_type = 8
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.name = "perfect"
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.full_name = ".Cmd.GvgRaidStateUpdateFubenCmd.perfect"
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.number = 4
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.index = 3
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.label = 1
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.has_default_value = false
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.default_value = false
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.type = 8
GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD.cpp_type = 7
GVGRAIDSTATEUPDATEFUBENCMD.name = "GvgRaidStateUpdateFubenCmd"
GVGRAIDSTATEUPDATEFUBENCMD.full_name = ".Cmd.GvgRaidStateUpdateFubenCmd"
GVGRAIDSTATEUPDATEFUBENCMD.nested_types = {}
GVGRAIDSTATEUPDATEFUBENCMD.enum_types = {}
GVGRAIDSTATEUPDATEFUBENCMD.fields = {
  GVGRAIDSTATEUPDATEFUBENCMD_CMD_FIELD,
  GVGRAIDSTATEUPDATEFUBENCMD_PARAM_FIELD,
  GVGRAIDSTATEUPDATEFUBENCMD_RAIDSTATE_FIELD,
  GVGRAIDSTATEUPDATEFUBENCMD_PERFECT_FIELD
}
GVGRAIDSTATEUPDATEFUBENCMD.is_extendable = false
GVGRAIDSTATEUPDATEFUBENCMD.extensions = {}
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.name = "cmd"
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.full_name = ".Cmd.AddPveCardTimesFubenCmd.cmd"
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.number = 1
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.index = 0
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.label = 1
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.has_default_value = true
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.default_value = 11
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.type = 14
ADDPVECARDTIMESFUBENCMD_CMD_FIELD.cpp_type = 8
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.name = "param"
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.full_name = ".Cmd.AddPveCardTimesFubenCmd.param"
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.number = 2
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.index = 1
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.label = 1
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.has_default_value = true
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.default_value = 129
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.type = 14
ADDPVECARDTIMESFUBENCMD_PARAM_FIELD.cpp_type = 8
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.name = "addtimes"
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.full_name = ".Cmd.AddPveCardTimesFubenCmd.addtimes"
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.number = 3
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.index = 2
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.label = 1
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.has_default_value = false
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.default_value = 0
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.type = 13
ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD.cpp_type = 3
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.name = "battletime"
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.full_name = ".Cmd.AddPveCardTimesFubenCmd.battletime"
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.number = 4
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.index = 3
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.label = 1
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.has_default_value = false
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.default_value = 0
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.type = 13
ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD.cpp_type = 3
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.name = "totalbattletime"
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.full_name = ".Cmd.AddPveCardTimesFubenCmd.totalbattletime"
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.number = 5
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.index = 4
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.label = 1
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.has_default_value = false
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.default_value = 0
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.type = 13
ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD.cpp_type = 3
ADDPVECARDTIMESFUBENCMD.name = "AddPveCardTimesFubenCmd"
ADDPVECARDTIMESFUBENCMD.full_name = ".Cmd.AddPveCardTimesFubenCmd"
ADDPVECARDTIMESFUBENCMD.nested_types = {}
ADDPVECARDTIMESFUBENCMD.enum_types = {}
ADDPVECARDTIMESFUBENCMD.fields = {
  ADDPVECARDTIMESFUBENCMD_CMD_FIELD,
  ADDPVECARDTIMESFUBENCMD_PARAM_FIELD,
  ADDPVECARDTIMESFUBENCMD_ADDTIMES_FIELD,
  ADDPVECARDTIMESFUBENCMD_BATTLETIME_FIELD,
  ADDPVECARDTIMESFUBENCMD_TOTALBATTLETIME_FIELD
}
ADDPVECARDTIMESFUBENCMD.is_extendable = false
ADDPVECARDTIMESFUBENCMD.extensions = {}
PVECARDPASSINFO_ID_FIELD.name = "id"
PVECARDPASSINFO_ID_FIELD.full_name = ".Cmd.PveCardPassInfo.id"
PVECARDPASSINFO_ID_FIELD.number = 1
PVECARDPASSINFO_ID_FIELD.index = 0
PVECARDPASSINFO_ID_FIELD.label = 1
PVECARDPASSINFO_ID_FIELD.has_default_value = false
PVECARDPASSINFO_ID_FIELD.default_value = 0
PVECARDPASSINFO_ID_FIELD.type = 13
PVECARDPASSINFO_ID_FIELD.cpp_type = 3
PVECARDPASSINFO_OPEN_FIELD.name = "open"
PVECARDPASSINFO_OPEN_FIELD.full_name = ".Cmd.PveCardPassInfo.open"
PVECARDPASSINFO_OPEN_FIELD.number = 2
PVECARDPASSINFO_OPEN_FIELD.index = 1
PVECARDPASSINFO_OPEN_FIELD.label = 1
PVECARDPASSINFO_OPEN_FIELD.has_default_value = false
PVECARDPASSINFO_OPEN_FIELD.default_value = false
PVECARDPASSINFO_OPEN_FIELD.type = 8
PVECARDPASSINFO_OPEN_FIELD.cpp_type = 7
PVECARDPASSINFO.name = "PveCardPassInfo"
PVECARDPASSINFO.full_name = ".Cmd.PveCardPassInfo"
PVECARDPASSINFO.nested_types = {}
PVECARDPASSINFO.enum_types = {}
PVECARDPASSINFO.fields = {
  PVECARDPASSINFO_ID_FIELD,
  PVECARDPASSINFO_OPEN_FIELD
}
PVECARDPASSINFO.is_extendable = false
PVECARDPASSINFO.extensions = {}
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.name = "cmd"
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncPveCardOpenStateFubenCmd.cmd"
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.number = 1
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.index = 0
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.label = 1
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.has_default_value = true
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.default_value = 11
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.type = 14
SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.name = "param"
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncPveCardOpenStateFubenCmd.param"
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.number = 2
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.index = 1
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.label = 1
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.default_value = 130
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.type = 14
SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.name = "passinfos"
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.full_name = ".Cmd.SyncPveCardOpenStateFubenCmd.passinfos"
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.number = 3
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.index = 2
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.label = 3
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.has_default_value = false
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.default_value = {}
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.message_type = PVECARDPASSINFO
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.type = 11
SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD.cpp_type = 10
SYNCPVECARDOPENSTATEFUBENCMD.name = "SyncPveCardOpenStateFubenCmd"
SYNCPVECARDOPENSTATEFUBENCMD.full_name = ".Cmd.SyncPveCardOpenStateFubenCmd"
SYNCPVECARDOPENSTATEFUBENCMD.nested_types = {}
SYNCPVECARDOPENSTATEFUBENCMD.enum_types = {}
SYNCPVECARDOPENSTATEFUBENCMD.fields = {
  SYNCPVECARDOPENSTATEFUBENCMD_CMD_FIELD,
  SYNCPVECARDOPENSTATEFUBENCMD_PARAM_FIELD,
  SYNCPVECARDOPENSTATEFUBENCMD_PASSINFOS_FIELD
}
SYNCPVECARDOPENSTATEFUBENCMD.is_extendable = false
SYNCPVECARDOPENSTATEFUBENCMD.extensions = {}
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.name = "cmd"
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.cmd"
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.number = 1
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.index = 0
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.has_default_value = true
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.default_value = 11
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.type = 14
QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD.cpp_type = 8
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.name = "param"
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.param"
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.number = 2
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.index = 1
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.has_default_value = true
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.default_value = 131
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.type = 14
QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD.cpp_type = 8
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.name = "raidid"
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.raidid"
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.number = 3
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.index = 2
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.has_default_value = false
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.default_value = 0
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.type = 13
QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD.cpp_type = 3
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.name = "etype"
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.etype"
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.number = 4
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.index = 3
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.has_default_value = false
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.default_value = nil
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.enum_type = EPVEGROUPTYPE
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.type = 14
QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD.cpp_type = 8
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.name = "bossid"
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.bossid"
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.number = 5
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.index = 4
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.has_default_value = false
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.default_value = 0
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.type = 13
QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD.cpp_type = 3
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.name = "use_sweep_ticket"
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd.use_sweep_ticket"
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.number = 6
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.index = 5
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.label = 1
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.has_default_value = false
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.default_value = false
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.type = 8
QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD.cpp_type = 7
QUICKFINISHPVERAIDFUBENCMD.name = "QuickFinishPveRaidFubenCmd"
QUICKFINISHPVERAIDFUBENCMD.full_name = ".Cmd.QuickFinishPveRaidFubenCmd"
QUICKFINISHPVERAIDFUBENCMD.nested_types = {}
QUICKFINISHPVERAIDFUBENCMD.enum_types = {}
QUICKFINISHPVERAIDFUBENCMD.fields = {
  QUICKFINISHPVERAIDFUBENCMD_CMD_FIELD,
  QUICKFINISHPVERAIDFUBENCMD_PARAM_FIELD,
  QUICKFINISHPVERAIDFUBENCMD_RAIDID_FIELD,
  QUICKFINISHPVERAIDFUBENCMD_ETYPE_FIELD,
  QUICKFINISHPVERAIDFUBENCMD_BOSSID_FIELD,
  QUICKFINISHPVERAIDFUBENCMD_USE_SWEEP_TICKET_FIELD
}
QUICKFINISHPVERAIDFUBENCMD.is_extendable = false
QUICKFINISHPVERAIDFUBENCMD.extensions = {}
PVECARDREWARDTIMESITEM_DIFF_FIELD.name = "diff"
PVECARDREWARDTIMESITEM_DIFF_FIELD.full_name = ".Cmd.PveCardRewardTimesItem.diff"
PVECARDREWARDTIMESITEM_DIFF_FIELD.number = 1
PVECARDREWARDTIMESITEM_DIFF_FIELD.index = 0
PVECARDREWARDTIMESITEM_DIFF_FIELD.label = 1
PVECARDREWARDTIMESITEM_DIFF_FIELD.has_default_value = false
PVECARDREWARDTIMESITEM_DIFF_FIELD.default_value = 0
PVECARDREWARDTIMESITEM_DIFF_FIELD.type = 13
PVECARDREWARDTIMESITEM_DIFF_FIELD.cpp_type = 3
PVECARDREWARDTIMESITEM_TIMES_FIELD.name = "times"
PVECARDREWARDTIMESITEM_TIMES_FIELD.full_name = ".Cmd.PveCardRewardTimesItem.times"
PVECARDREWARDTIMESITEM_TIMES_FIELD.number = 2
PVECARDREWARDTIMESITEM_TIMES_FIELD.index = 1
PVECARDREWARDTIMESITEM_TIMES_FIELD.label = 1
PVECARDREWARDTIMESITEM_TIMES_FIELD.has_default_value = false
PVECARDREWARDTIMESITEM_TIMES_FIELD.default_value = 0
PVECARDREWARDTIMESITEM_TIMES_FIELD.type = 13
PVECARDREWARDTIMESITEM_TIMES_FIELD.cpp_type = 3
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.name = "firstpass"
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.full_name = ".Cmd.PveCardRewardTimesItem.firstpass"
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.number = 3
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.index = 2
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.label = 1
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.has_default_value = false
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.default_value = false
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.type = 8
PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD.cpp_type = 7
PVECARDREWARDTIMESITEM.name = "PveCardRewardTimesItem"
PVECARDREWARDTIMESITEM.full_name = ".Cmd.PveCardRewardTimesItem"
PVECARDREWARDTIMESITEM.nested_types = {}
PVECARDREWARDTIMESITEM.enum_types = {}
PVECARDREWARDTIMESITEM.fields = {
  PVECARDREWARDTIMESITEM_DIFF_FIELD,
  PVECARDREWARDTIMESITEM_TIMES_FIELD,
  PVECARDREWARDTIMESITEM_FIRSTPASS_FIELD
}
PVECARDREWARDTIMESITEM.is_extendable = false
PVECARDREWARDTIMESITEM.extensions = {}
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.name = "cmd"
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncPveCardRewardTimesFubenCmd.cmd"
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.number = 1
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.index = 0
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.label = 1
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.has_default_value = true
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.default_value = 11
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.type = 14
SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.name = "param"
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncPveCardRewardTimesFubenCmd.param"
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.number = 2
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.index = 1
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.label = 1
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.default_value = 132
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.type = 14
SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.name = "items"
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.full_name = ".Cmd.SyncPveCardRewardTimesFubenCmd.items"
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.number = 3
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.index = 2
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.label = 3
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.has_default_value = false
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.default_value = {}
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.message_type = PVECARDREWARDTIMESITEM
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.type = 11
SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD.cpp_type = 10
SYNCPVECARDREWARDTIMESFUBENCMD.name = "SyncPveCardRewardTimesFubenCmd"
SYNCPVECARDREWARDTIMESFUBENCMD.full_name = ".Cmd.SyncPveCardRewardTimesFubenCmd"
SYNCPVECARDREWARDTIMESFUBENCMD.nested_types = {}
SYNCPVECARDREWARDTIMESFUBENCMD.enum_types = {}
SYNCPVECARDREWARDTIMESFUBENCMD.fields = {
  SYNCPVECARDREWARDTIMESFUBENCMD_CMD_FIELD,
  SYNCPVECARDREWARDTIMESFUBENCMD_PARAM_FIELD,
  SYNCPVECARDREWARDTIMESFUBENCMD_ITEMS_FIELD
}
SYNCPVECARDREWARDTIMESFUBENCMD.is_extendable = false
SYNCPVECARDREWARDTIMESFUBENCMD.extensions = {}
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.name = "cmd"
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.GvgPerfectStateUpdateFubenCmd.cmd"
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.number = 1
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.index = 0
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.label = 1
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.has_default_value = true
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.default_value = 11
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.type = 14
GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD.cpp_type = 8
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.name = "param"
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.GvgPerfectStateUpdateFubenCmd.param"
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.number = 2
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.index = 1
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.label = 1
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.has_default_value = true
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.default_value = 133
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.type = 14
GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD.cpp_type = 8
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.name = "perfect_time"
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.full_name = ".Cmd.GvgPerfectStateUpdateFubenCmd.perfect_time"
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.number = 3
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.index = 2
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.label = 1
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.has_default_value = false
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.default_value = nil
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.message_type = ProtoCommon_pb.GVGPERFECTTIMEINFO
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.type = 11
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD.cpp_type = 10
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.name = "perfect"
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.full_name = ".Cmd.GvgPerfectStateUpdateFubenCmd.perfect"
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.number = 4
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.index = 3
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.label = 1
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.has_default_value = false
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.default_value = false
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.type = 8
GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD.cpp_type = 7
GVGPERFECTSTATEUPDATEFUBENCMD.name = "GvgPerfectStateUpdateFubenCmd"
GVGPERFECTSTATEUPDATEFUBENCMD.full_name = ".Cmd.GvgPerfectStateUpdateFubenCmd"
GVGPERFECTSTATEUPDATEFUBENCMD.nested_types = {}
GVGPERFECTSTATEUPDATEFUBENCMD.enum_types = {}
GVGPERFECTSTATEUPDATEFUBENCMD.fields = {
  GVGPERFECTSTATEUPDATEFUBENCMD_CMD_FIELD,
  GVGPERFECTSTATEUPDATEFUBENCMD_PARAM_FIELD,
  GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_TIME_FIELD,
  GVGPERFECTSTATEUPDATEFUBENCMD_PERFECT_FIELD
}
GVGPERFECTSTATEUPDATEFUBENCMD.is_extendable = false
GVGPERFECTSTATEUPDATEFUBENCMD.extensions = {}
BOSSSTATEINFO_BOSSID_FIELD.name = "bossid"
BOSSSTATEINFO_BOSSID_FIELD.full_name = ".Cmd.BossStateInfo.bossid"
BOSSSTATEINFO_BOSSID_FIELD.number = 1
BOSSSTATEINFO_BOSSID_FIELD.index = 0
BOSSSTATEINFO_BOSSID_FIELD.label = 1
BOSSSTATEINFO_BOSSID_FIELD.has_default_value = false
BOSSSTATEINFO_BOSSID_FIELD.default_value = 0
BOSSSTATEINFO_BOSSID_FIELD.type = 13
BOSSSTATEINFO_BOSSID_FIELD.cpp_type = 3
BOSSSTATEINFO_ISALIVE_FIELD.name = "isalive"
BOSSSTATEINFO_ISALIVE_FIELD.full_name = ".Cmd.BossStateInfo.isalive"
BOSSSTATEINFO_ISALIVE_FIELD.number = 2
BOSSSTATEINFO_ISALIVE_FIELD.index = 1
BOSSSTATEINFO_ISALIVE_FIELD.label = 1
BOSSSTATEINFO_ISALIVE_FIELD.has_default_value = false
BOSSSTATEINFO_ISALIVE_FIELD.default_value = false
BOSSSTATEINFO_ISALIVE_FIELD.type = 8
BOSSSTATEINFO_ISALIVE_FIELD.cpp_type = 7
BOSSSTATEINFO.name = "BossStateInfo"
BOSSSTATEINFO.full_name = ".Cmd.BossStateInfo"
BOSSSTATEINFO.nested_types = {}
BOSSSTATEINFO.enum_types = {}
BOSSSTATEINFO.fields = {
  BOSSSTATEINFO_BOSSID_FIELD,
  BOSSSTATEINFO_ISALIVE_FIELD
}
BOSSSTATEINFO.is_extendable = false
BOSSSTATEINFO.extensions = {}
QUERYELEMENTRAIDSTAT_CMD_FIELD.name = "cmd"
QUERYELEMENTRAIDSTAT_CMD_FIELD.full_name = ".Cmd.QueryElementRaidStat.cmd"
QUERYELEMENTRAIDSTAT_CMD_FIELD.number = 1
QUERYELEMENTRAIDSTAT_CMD_FIELD.index = 0
QUERYELEMENTRAIDSTAT_CMD_FIELD.label = 1
QUERYELEMENTRAIDSTAT_CMD_FIELD.has_default_value = true
QUERYELEMENTRAIDSTAT_CMD_FIELD.default_value = 11
QUERYELEMENTRAIDSTAT_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYELEMENTRAIDSTAT_CMD_FIELD.type = 14
QUERYELEMENTRAIDSTAT_CMD_FIELD.cpp_type = 8
QUERYELEMENTRAIDSTAT_PARAM_FIELD.name = "param"
QUERYELEMENTRAIDSTAT_PARAM_FIELD.full_name = ".Cmd.QueryElementRaidStat.param"
QUERYELEMENTRAIDSTAT_PARAM_FIELD.number = 2
QUERYELEMENTRAIDSTAT_PARAM_FIELD.index = 1
QUERYELEMENTRAIDSTAT_PARAM_FIELD.label = 1
QUERYELEMENTRAIDSTAT_PARAM_FIELD.has_default_value = true
QUERYELEMENTRAIDSTAT_PARAM_FIELD.default_value = 136
QUERYELEMENTRAIDSTAT_PARAM_FIELD.enum_type = FUBENPARAM
QUERYELEMENTRAIDSTAT_PARAM_FIELD.type = 14
QUERYELEMENTRAIDSTAT_PARAM_FIELD.cpp_type = 8
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.name = "current"
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.full_name = ".Cmd.QueryElementRaidStat.current"
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.number = 3
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.index = 2
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.label = 1
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.has_default_value = false
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.default_value = nil
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.type = 11
QUERYELEMENTRAIDSTAT_CURRENT_FIELD.cpp_type = 10
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.name = "total"
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.full_name = ".Cmd.QueryElementRaidStat.total"
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.number = 4
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.index = 3
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.label = 1
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.has_default_value = false
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.default_value = nil
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.type = 11
QUERYELEMENTRAIDSTAT_TOTAL_FIELD.cpp_type = 10
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.name = "history"
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.full_name = ".Cmd.QueryElementRaidStat.history"
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.number = 5
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.index = 4
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.label = 3
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.has_default_value = false
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.default_value = {}
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.message_type = GROUPRAIDTEAMSHOWDATA
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.type = 11
QUERYELEMENTRAIDSTAT_HISTORY_FIELD.cpp_type = 10
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.name = "raidtype"
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.full_name = ".Cmd.QueryElementRaidStat.raidtype"
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.number = 6
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.index = 5
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.label = 1
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.has_default_value = false
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.default_value = nil
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.enum_type = ERAIDTYPE
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.type = 14
QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD.cpp_type = 8
QUERYELEMENTRAIDSTAT.name = "QueryElementRaidStat"
QUERYELEMENTRAIDSTAT.full_name = ".Cmd.QueryElementRaidStat"
QUERYELEMENTRAIDSTAT.nested_types = {}
QUERYELEMENTRAIDSTAT.enum_types = {}
QUERYELEMENTRAIDSTAT.fields = {
  QUERYELEMENTRAIDSTAT_CMD_FIELD,
  QUERYELEMENTRAIDSTAT_PARAM_FIELD,
  QUERYELEMENTRAIDSTAT_CURRENT_FIELD,
  QUERYELEMENTRAIDSTAT_TOTAL_FIELD,
  QUERYELEMENTRAIDSTAT_HISTORY_FIELD,
  QUERYELEMENTRAIDSTAT_RAIDTYPE_FIELD
}
QUERYELEMENTRAIDSTAT.is_extendable = false
QUERYELEMENTRAIDSTAT.extensions = {}
EMOTIONFACTORS_ID_FIELD.name = "id"
EMOTIONFACTORS_ID_FIELD.full_name = ".Cmd.EmotionFactors.id"
EMOTIONFACTORS_ID_FIELD.number = 1
EMOTIONFACTORS_ID_FIELD.index = 0
EMOTIONFACTORS_ID_FIELD.label = 1
EMOTIONFACTORS_ID_FIELD.has_default_value = false
EMOTIONFACTORS_ID_FIELD.default_value = 0
EMOTIONFACTORS_ID_FIELD.type = 13
EMOTIONFACTORS_ID_FIELD.cpp_type = 3
EMOTIONFACTORS_COUNT_FIELD.name = "count"
EMOTIONFACTORS_COUNT_FIELD.full_name = ".Cmd.EmotionFactors.count"
EMOTIONFACTORS_COUNT_FIELD.number = 2
EMOTIONFACTORS_COUNT_FIELD.index = 1
EMOTIONFACTORS_COUNT_FIELD.label = 1
EMOTIONFACTORS_COUNT_FIELD.has_default_value = false
EMOTIONFACTORS_COUNT_FIELD.default_value = 0
EMOTIONFACTORS_COUNT_FIELD.type = 13
EMOTIONFACTORS_COUNT_FIELD.cpp_type = 3
EMOTIONFACTORS.name = "EmotionFactors"
EMOTIONFACTORS.full_name = ".Cmd.EmotionFactors"
EMOTIONFACTORS.nested_types = {}
EMOTIONFACTORS.enum_types = {}
EMOTIONFACTORS.fields = {
  EMOTIONFACTORS_ID_FIELD,
  EMOTIONFACTORS_COUNT_FIELD
}
EMOTIONFACTORS.is_extendable = false
EMOTIONFACTORS.extensions = {}
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.name = "cmd"
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncEmotionFactorsFuBenCmd.cmd"
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.number = 1
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.index = 0
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.label = 1
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.has_default_value = true
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.default_value = 11
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.type = 14
SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.name = "param"
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncEmotionFactorsFuBenCmd.param"
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.number = 2
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.index = 1
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.label = 1
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.default_value = 137
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.type = 14
SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.name = "factors"
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.full_name = ".Cmd.SyncEmotionFactorsFuBenCmd.factors"
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.number = 3
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.index = 2
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.label = 3
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.has_default_value = false
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.default_value = {}
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.message_type = EMOTIONFACTORS
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.type = 11
SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD.cpp_type = 10
SYNCEMOTIONFACTORSFUBENCMD.name = "SyncEmotionFactorsFuBenCmd"
SYNCEMOTIONFACTORSFUBENCMD.full_name = ".Cmd.SyncEmotionFactorsFuBenCmd"
SYNCEMOTIONFACTORSFUBENCMD.nested_types = {}
SYNCEMOTIONFACTORSFUBENCMD.enum_types = {}
SYNCEMOTIONFACTORSFUBENCMD.fields = {
  SYNCEMOTIONFACTORSFUBENCMD_CMD_FIELD,
  SYNCEMOTIONFACTORSFUBENCMD_PARAM_FIELD,
  SYNCEMOTIONFACTORSFUBENCMD_FACTORS_FIELD
}
SYNCEMOTIONFACTORSFUBENCMD.is_extendable = false
SYNCEMOTIONFACTORSFUBENCMD.extensions = {}
SYNCBOSSSCENEINFO_CMD_FIELD.name = "cmd"
SYNCBOSSSCENEINFO_CMD_FIELD.full_name = ".Cmd.SyncBossSceneInfo.cmd"
SYNCBOSSSCENEINFO_CMD_FIELD.number = 1
SYNCBOSSSCENEINFO_CMD_FIELD.index = 0
SYNCBOSSSCENEINFO_CMD_FIELD.label = 1
SYNCBOSSSCENEINFO_CMD_FIELD.has_default_value = true
SYNCBOSSSCENEINFO_CMD_FIELD.default_value = 11
SYNCBOSSSCENEINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCBOSSSCENEINFO_CMD_FIELD.type = 14
SYNCBOSSSCENEINFO_CMD_FIELD.cpp_type = 8
SYNCBOSSSCENEINFO_PARAM_FIELD.name = "param"
SYNCBOSSSCENEINFO_PARAM_FIELD.full_name = ".Cmd.SyncBossSceneInfo.param"
SYNCBOSSSCENEINFO_PARAM_FIELD.number = 2
SYNCBOSSSCENEINFO_PARAM_FIELD.index = 1
SYNCBOSSSCENEINFO_PARAM_FIELD.label = 1
SYNCBOSSSCENEINFO_PARAM_FIELD.has_default_value = true
SYNCBOSSSCENEINFO_PARAM_FIELD.default_value = 134
SYNCBOSSSCENEINFO_PARAM_FIELD.enum_type = FUBENPARAM
SYNCBOSSSCENEINFO_PARAM_FIELD.type = 14
SYNCBOSSSCENEINFO_PARAM_FIELD.cpp_type = 8
SYNCBOSSSCENEINFO_INFOS_FIELD.name = "infos"
SYNCBOSSSCENEINFO_INFOS_FIELD.full_name = ".Cmd.SyncBossSceneInfo.infos"
SYNCBOSSSCENEINFO_INFOS_FIELD.number = 3
SYNCBOSSSCENEINFO_INFOS_FIELD.index = 2
SYNCBOSSSCENEINFO_INFOS_FIELD.label = 3
SYNCBOSSSCENEINFO_INFOS_FIELD.has_default_value = false
SYNCBOSSSCENEINFO_INFOS_FIELD.default_value = {}
SYNCBOSSSCENEINFO_INFOS_FIELD.message_type = BOSSSTATEINFO
SYNCBOSSSCENEINFO_INFOS_FIELD.type = 11
SYNCBOSSSCENEINFO_INFOS_FIELD.cpp_type = 10
SYNCBOSSSCENEINFO.name = "SyncBossSceneInfo"
SYNCBOSSSCENEINFO.full_name = ".Cmd.SyncBossSceneInfo"
SYNCBOSSSCENEINFO.nested_types = {}
SYNCBOSSSCENEINFO.enum_types = {}
SYNCBOSSSCENEINFO.fields = {
  SYNCBOSSSCENEINFO_CMD_FIELD,
  SYNCBOSSSCENEINFO_PARAM_FIELD,
  SYNCBOSSSCENEINFO_INFOS_FIELD
}
SYNCBOSSSCENEINFO.is_extendable = false
SYNCBOSSSCENEINFO.extensions = {}
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.name = "cmd"
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncUnlockRoomIDsFuBenCmd.cmd"
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.number = 1
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.index = 0
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.label = 1
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.has_default_value = true
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.default_value = 11
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.type = 14
SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.name = "param"
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncUnlockRoomIDsFuBenCmd.param"
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.number = 2
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.index = 1
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.label = 1
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.default_value = 139
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.type = 14
SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.name = "roomids"
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.full_name = ".Cmd.SyncUnlockRoomIDsFuBenCmd.roomids"
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.number = 3
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.index = 2
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.label = 3
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.has_default_value = false
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.default_value = {}
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.type = 13
SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD.cpp_type = 3
SYNCUNLOCKROOMIDSFUBENCMD.name = "SyncUnlockRoomIDsFuBenCmd"
SYNCUNLOCKROOMIDSFUBENCMD.full_name = ".Cmd.SyncUnlockRoomIDsFuBenCmd"
SYNCUNLOCKROOMIDSFUBENCMD.nested_types = {}
SYNCUNLOCKROOMIDSFUBENCMD.enum_types = {}
SYNCUNLOCKROOMIDSFUBENCMD.fields = {
  SYNCUNLOCKROOMIDSFUBENCMD_CMD_FIELD,
  SYNCUNLOCKROOMIDSFUBENCMD_PARAM_FIELD,
  SYNCUNLOCKROOMIDSFUBENCMD_ROOMIDS_FIELD
}
SYNCUNLOCKROOMIDSFUBENCMD.is_extendable = false
SYNCUNLOCKROOMIDSFUBENCMD.extensions = {}
SYNCVISITNPCINFO_CMD_FIELD.name = "cmd"
SYNCVISITNPCINFO_CMD_FIELD.full_name = ".Cmd.SyncVisitNpcInfo.cmd"
SYNCVISITNPCINFO_CMD_FIELD.number = 1
SYNCVISITNPCINFO_CMD_FIELD.index = 0
SYNCVISITNPCINFO_CMD_FIELD.label = 1
SYNCVISITNPCINFO_CMD_FIELD.has_default_value = true
SYNCVISITNPCINFO_CMD_FIELD.default_value = 11
SYNCVISITNPCINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCVISITNPCINFO_CMD_FIELD.type = 14
SYNCVISITNPCINFO_CMD_FIELD.cpp_type = 8
SYNCVISITNPCINFO_PARAM_FIELD.name = "param"
SYNCVISITNPCINFO_PARAM_FIELD.full_name = ".Cmd.SyncVisitNpcInfo.param"
SYNCVISITNPCINFO_PARAM_FIELD.number = 2
SYNCVISITNPCINFO_PARAM_FIELD.index = 1
SYNCVISITNPCINFO_PARAM_FIELD.label = 1
SYNCVISITNPCINFO_PARAM_FIELD.has_default_value = true
SYNCVISITNPCINFO_PARAM_FIELD.default_value = 138
SYNCVISITNPCINFO_PARAM_FIELD.enum_type = FUBENPARAM
SYNCVISITNPCINFO_PARAM_FIELD.type = 14
SYNCVISITNPCINFO_PARAM_FIELD.cpp_type = 8
SYNCVISITNPCINFO_NPCTEMPID_FIELD.name = "npctempid"
SYNCVISITNPCINFO_NPCTEMPID_FIELD.full_name = ".Cmd.SyncVisitNpcInfo.npctempid"
SYNCVISITNPCINFO_NPCTEMPID_FIELD.number = 3
SYNCVISITNPCINFO_NPCTEMPID_FIELD.index = 2
SYNCVISITNPCINFO_NPCTEMPID_FIELD.label = 1
SYNCVISITNPCINFO_NPCTEMPID_FIELD.has_default_value = true
SYNCVISITNPCINFO_NPCTEMPID_FIELD.default_value = 0
SYNCVISITNPCINFO_NPCTEMPID_FIELD.type = 4
SYNCVISITNPCINFO_NPCTEMPID_FIELD.cpp_type = 4
SYNCVISITNPCINFO_CHARID_FIELD.name = "charid"
SYNCVISITNPCINFO_CHARID_FIELD.full_name = ".Cmd.SyncVisitNpcInfo.charid"
SYNCVISITNPCINFO_CHARID_FIELD.number = 4
SYNCVISITNPCINFO_CHARID_FIELD.index = 3
SYNCVISITNPCINFO_CHARID_FIELD.label = 1
SYNCVISITNPCINFO_CHARID_FIELD.has_default_value = true
SYNCVISITNPCINFO_CHARID_FIELD.default_value = 0
SYNCVISITNPCINFO_CHARID_FIELD.type = 4
SYNCVISITNPCINFO_CHARID_FIELD.cpp_type = 4
SYNCVISITNPCINFO_VISIT_FIELD.name = "visit"
SYNCVISITNPCINFO_VISIT_FIELD.full_name = ".Cmd.SyncVisitNpcInfo.visit"
SYNCVISITNPCINFO_VISIT_FIELD.number = 5
SYNCVISITNPCINFO_VISIT_FIELD.index = 4
SYNCVISITNPCINFO_VISIT_FIELD.label = 1
SYNCVISITNPCINFO_VISIT_FIELD.has_default_value = false
SYNCVISITNPCINFO_VISIT_FIELD.default_value = false
SYNCVISITNPCINFO_VISIT_FIELD.type = 8
SYNCVISITNPCINFO_VISIT_FIELD.cpp_type = 7
SYNCVISITNPCINFO.name = "SyncVisitNpcInfo"
SYNCVISITNPCINFO.full_name = ".Cmd.SyncVisitNpcInfo"
SYNCVISITNPCINFO.nested_types = {}
SYNCVISITNPCINFO.enum_types = {}
SYNCVISITNPCINFO.fields = {
  SYNCVISITNPCINFO_CMD_FIELD,
  SYNCVISITNPCINFO_PARAM_FIELD,
  SYNCVISITNPCINFO_NPCTEMPID_FIELD,
  SYNCVISITNPCINFO_CHARID_FIELD,
  SYNCVISITNPCINFO_VISIT_FIELD
}
SYNCVISITNPCINFO.is_extendable = false
SYNCVISITNPCINFO.extensions = {}
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.name = "cmd"
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncMonsterCountFuBenCmd.cmd"
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.number = 1
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.index = 0
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.label = 1
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.has_default_value = true
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.default_value = 11
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.type = 14
SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.name = "param"
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncMonsterCountFuBenCmd.param"
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.number = 2
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.index = 1
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.label = 1
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.default_value = 140
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.type = 14
SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.name = "count"
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.full_name = ".Cmd.SyncMonsterCountFuBenCmd.count"
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.number = 3
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.index = 2
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.label = 1
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.has_default_value = false
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.default_value = 0
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.type = 13
SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD.cpp_type = 3
SYNCMONSTERCOUNTFUBENCMD.name = "SyncMonsterCountFuBenCmd"
SYNCMONSTERCOUNTFUBENCMD.full_name = ".Cmd.SyncMonsterCountFuBenCmd"
SYNCMONSTERCOUNTFUBENCMD.nested_types = {}
SYNCMONSTERCOUNTFUBENCMD.enum_types = {}
SYNCMONSTERCOUNTFUBENCMD.fields = {
  SYNCMONSTERCOUNTFUBENCMD_CMD_FIELD,
  SYNCMONSTERCOUNTFUBENCMD_PARAM_FIELD,
  SYNCMONSTERCOUNTFUBENCMD_COUNT_FIELD
}
SYNCMONSTERCOUNTFUBENCMD.is_extendable = false
SYNCMONSTERCOUNTFUBENCMD.extensions = {}
SKIPANIMATIONFUBENCMD_CMD_FIELD.name = "cmd"
SKIPANIMATIONFUBENCMD_CMD_FIELD.full_name = ".Cmd.SkipAnimationFuBenCmd.cmd"
SKIPANIMATIONFUBENCMD_CMD_FIELD.number = 1
SKIPANIMATIONFUBENCMD_CMD_FIELD.index = 0
SKIPANIMATIONFUBENCMD_CMD_FIELD.label = 1
SKIPANIMATIONFUBENCMD_CMD_FIELD.has_default_value = true
SKIPANIMATIONFUBENCMD_CMD_FIELD.default_value = 11
SKIPANIMATIONFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SKIPANIMATIONFUBENCMD_CMD_FIELD.type = 14
SKIPANIMATIONFUBENCMD_CMD_FIELD.cpp_type = 8
SKIPANIMATIONFUBENCMD_PARAM_FIELD.name = "param"
SKIPANIMATIONFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SkipAnimationFuBenCmd.param"
SKIPANIMATIONFUBENCMD_PARAM_FIELD.number = 2
SKIPANIMATIONFUBENCMD_PARAM_FIELD.index = 1
SKIPANIMATIONFUBENCMD_PARAM_FIELD.label = 1
SKIPANIMATIONFUBENCMD_PARAM_FIELD.has_default_value = true
SKIPANIMATIONFUBENCMD_PARAM_FIELD.default_value = 141
SKIPANIMATIONFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SKIPANIMATIONFUBENCMD_PARAM_FIELD.type = 14
SKIPANIMATIONFUBENCMD_PARAM_FIELD.cpp_type = 8
SKIPANIMATIONFUBENCMD.name = "SkipAnimationFuBenCmd"
SKIPANIMATIONFUBENCMD.full_name = ".Cmd.SkipAnimationFuBenCmd"
SKIPANIMATIONFUBENCMD.nested_types = {}
SKIPANIMATIONFUBENCMD.enum_types = {}
SKIPANIMATIONFUBENCMD.fields = {
  SKIPANIMATIONFUBENCMD_CMD_FIELD,
  SKIPANIMATIONFUBENCMD_PARAM_FIELD
}
SKIPANIMATIONFUBENCMD.is_extendable = false
SKIPANIMATIONFUBENCMD.extensions = {}
RESETRAIDFUBENCMD_CMD_FIELD.name = "cmd"
RESETRAIDFUBENCMD_CMD_FIELD.full_name = ".Cmd.ResetRaidFubenCmd.cmd"
RESETRAIDFUBENCMD_CMD_FIELD.number = 1
RESETRAIDFUBENCMD_CMD_FIELD.index = 0
RESETRAIDFUBENCMD_CMD_FIELD.label = 1
RESETRAIDFUBENCMD_CMD_FIELD.has_default_value = true
RESETRAIDFUBENCMD_CMD_FIELD.default_value = 11
RESETRAIDFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RESETRAIDFUBENCMD_CMD_FIELD.type = 14
RESETRAIDFUBENCMD_CMD_FIELD.cpp_type = 8
RESETRAIDFUBENCMD_PARAM_FIELD.name = "param"
RESETRAIDFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ResetRaidFubenCmd.param"
RESETRAIDFUBENCMD_PARAM_FIELD.number = 2
RESETRAIDFUBENCMD_PARAM_FIELD.index = 1
RESETRAIDFUBENCMD_PARAM_FIELD.label = 1
RESETRAIDFUBENCMD_PARAM_FIELD.has_default_value = true
RESETRAIDFUBENCMD_PARAM_FIELD.default_value = 135
RESETRAIDFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
RESETRAIDFUBENCMD_PARAM_FIELD.type = 14
RESETRAIDFUBENCMD_PARAM_FIELD.cpp_type = 8
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.name = "entrance_id"
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.full_name = ".Cmd.ResetRaidFubenCmd.entrance_id"
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.number = 3
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.index = 2
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.label = 1
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.has_default_value = false
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.default_value = 0
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.type = 13
RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD.cpp_type = 3
RESETRAIDFUBENCMD.name = "ResetRaidFubenCmd"
RESETRAIDFUBENCMD.full_name = ".Cmd.ResetRaidFubenCmd"
RESETRAIDFUBENCMD.nested_types = {}
RESETRAIDFUBENCMD.enum_types = {}
RESETRAIDFUBENCMD.fields = {
  RESETRAIDFUBENCMD_CMD_FIELD,
  RESETRAIDFUBENCMD_PARAM_FIELD,
  RESETRAIDFUBENCMD_ENTRANCE_ID_FIELD
}
RESETRAIDFUBENCMD.is_extendable = false
RESETRAIDFUBENCMD.extensions = {}
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.cmd"
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.number = 1
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.index = 0
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.type = 14
SYNCSTARARKINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.param"
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.default_value = 142
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCSTARARKINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.name = "speed"
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.speed"
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.number = 3
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.index = 2
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_SPEED_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.name = "npcnum"
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.npcnum"
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.number = 4
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.index = 3
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.name = "boxnum"
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.boxnum"
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.number = 5
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.index = 4
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.name = "relivecount"
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.relivecount"
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.number = 6
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.index = 5
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.name = "begintime"
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.begintime"
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.number = 7
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.index = 6
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.name = "length"
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.length"
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.number = 8
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.index = 7
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.name = "boxtotalnum"
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.boxtotalnum"
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.number = 9
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.index = 8
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.name = "maxspeed"
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.maxspeed"
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.number = 10
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.index = 9
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.name = "fullspeed"
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.fullspeed"
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.number = 11
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.index = 10
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.name = "difficulty"
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd.difficulty"
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.number = 12
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.index = 11
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.label = 1
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.has_default_value = false
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.default_value = 0
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.type = 13
SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD.cpp_type = 3
SYNCSTARARKINFOFUBENCMD.name = "SyncStarArkInfoFuBenCmd"
SYNCSTARARKINFOFUBENCMD.full_name = ".Cmd.SyncStarArkInfoFuBenCmd"
SYNCSTARARKINFOFUBENCMD.nested_types = {}
SYNCSTARARKINFOFUBENCMD.enum_types = {}
SYNCSTARARKINFOFUBENCMD.fields = {
  SYNCSTARARKINFOFUBENCMD_CMD_FIELD,
  SYNCSTARARKINFOFUBENCMD_PARAM_FIELD,
  SYNCSTARARKINFOFUBENCMD_SPEED_FIELD,
  SYNCSTARARKINFOFUBENCMD_NPCNUM_FIELD,
  SYNCSTARARKINFOFUBENCMD_BOXNUM_FIELD,
  SYNCSTARARKINFOFUBENCMD_RELIVECOUNT_FIELD,
  SYNCSTARARKINFOFUBENCMD_BEGINTIME_FIELD,
  SYNCSTARARKINFOFUBENCMD_LENGTH_FIELD,
  SYNCSTARARKINFOFUBENCMD_BOXTOTALNUM_FIELD,
  SYNCSTARARKINFOFUBENCMD_MAXSPEED_FIELD,
  SYNCSTARARKINFOFUBENCMD_FULLSPEED_FIELD,
  SYNCSTARARKINFOFUBENCMD_DIFFICULTY_FIELD
}
SYNCSTARARKINFOFUBENCMD.is_extendable = false
SYNCSTARARKINFOFUBENCMD.extensions = {}
FIGHTUSERINFO_DAMAGE_FIELD.name = "damage"
FIGHTUSERINFO_DAMAGE_FIELD.full_name = ".Cmd.FightUserInfo.damage"
FIGHTUSERINFO_DAMAGE_FIELD.number = 1
FIGHTUSERINFO_DAMAGE_FIELD.index = 0
FIGHTUSERINFO_DAMAGE_FIELD.label = 1
FIGHTUSERINFO_DAMAGE_FIELD.has_default_value = false
FIGHTUSERINFO_DAMAGE_FIELD.default_value = 0
FIGHTUSERINFO_DAMAGE_FIELD.type = 4
FIGHTUSERINFO_DAMAGE_FIELD.cpp_type = 4
FIGHTUSERINFO_HEAL_FIELD.name = "heal"
FIGHTUSERINFO_HEAL_FIELD.full_name = ".Cmd.FightUserInfo.heal"
FIGHTUSERINFO_HEAL_FIELD.number = 2
FIGHTUSERINFO_HEAL_FIELD.index = 1
FIGHTUSERINFO_HEAL_FIELD.label = 1
FIGHTUSERINFO_HEAL_FIELD.has_default_value = false
FIGHTUSERINFO_HEAL_FIELD.default_value = 0
FIGHTUSERINFO_HEAL_FIELD.type = 4
FIGHTUSERINFO_HEAL_FIELD.cpp_type = 4
FIGHTUSERINFO_SUFFER_FIELD.name = "suffer"
FIGHTUSERINFO_SUFFER_FIELD.full_name = ".Cmd.FightUserInfo.suffer"
FIGHTUSERINFO_SUFFER_FIELD.number = 3
FIGHTUSERINFO_SUFFER_FIELD.index = 2
FIGHTUSERINFO_SUFFER_FIELD.label = 1
FIGHTUSERINFO_SUFFER_FIELD.has_default_value = false
FIGHTUSERINFO_SUFFER_FIELD.default_value = 0
FIGHTUSERINFO_SUFFER_FIELD.type = 4
FIGHTUSERINFO_SUFFER_FIELD.cpp_type = 4
FIGHTUSERINFO_DAMGENAME_FIELD.name = "damgename"
FIGHTUSERINFO_DAMGENAME_FIELD.full_name = ".Cmd.FightUserInfo.damgename"
FIGHTUSERINFO_DAMGENAME_FIELD.number = 4
FIGHTUSERINFO_DAMGENAME_FIELD.index = 3
FIGHTUSERINFO_DAMGENAME_FIELD.label = 1
FIGHTUSERINFO_DAMGENAME_FIELD.has_default_value = false
FIGHTUSERINFO_DAMGENAME_FIELD.default_value = ""
FIGHTUSERINFO_DAMGENAME_FIELD.type = 9
FIGHTUSERINFO_DAMGENAME_FIELD.cpp_type = 9
FIGHTUSERINFO_HEALNAME_FIELD.name = "healname"
FIGHTUSERINFO_HEALNAME_FIELD.full_name = ".Cmd.FightUserInfo.healname"
FIGHTUSERINFO_HEALNAME_FIELD.number = 5
FIGHTUSERINFO_HEALNAME_FIELD.index = 4
FIGHTUSERINFO_HEALNAME_FIELD.label = 1
FIGHTUSERINFO_HEALNAME_FIELD.has_default_value = false
FIGHTUSERINFO_HEALNAME_FIELD.default_value = ""
FIGHTUSERINFO_HEALNAME_FIELD.type = 9
FIGHTUSERINFO_HEALNAME_FIELD.cpp_type = 9
FIGHTUSERINFO_SUFFERNAME_FIELD.name = "suffername"
FIGHTUSERINFO_SUFFERNAME_FIELD.full_name = ".Cmd.FightUserInfo.suffername"
FIGHTUSERINFO_SUFFERNAME_FIELD.number = 6
FIGHTUSERINFO_SUFFERNAME_FIELD.index = 5
FIGHTUSERINFO_SUFFERNAME_FIELD.label = 1
FIGHTUSERINFO_SUFFERNAME_FIELD.has_default_value = false
FIGHTUSERINFO_SUFFERNAME_FIELD.default_value = ""
FIGHTUSERINFO_SUFFERNAME_FIELD.type = 9
FIGHTUSERINFO_SUFFERNAME_FIELD.cpp_type = 9
FIGHTUSERINFO_MVPUSERINFO_FIELD.name = "mvpuserinfo"
FIGHTUSERINFO_MVPUSERINFO_FIELD.full_name = ".Cmd.FightUserInfo.mvpuserinfo"
FIGHTUSERINFO_MVPUSERINFO_FIELD.number = 7
FIGHTUSERINFO_MVPUSERINFO_FIELD.index = 6
FIGHTUSERINFO_MVPUSERINFO_FIELD.label = 1
FIGHTUSERINFO_MVPUSERINFO_FIELD.has_default_value = false
FIGHTUSERINFO_MVPUSERINFO_FIELD.default_value = nil
FIGHTUSERINFO_MVPUSERINFO_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
FIGHTUSERINFO_MVPUSERINFO_FIELD.type = 11
FIGHTUSERINFO_MVPUSERINFO_FIELD.cpp_type = 10
FIGHTUSERINFO.name = "FightUserInfo"
FIGHTUSERINFO.full_name = ".Cmd.FightUserInfo"
FIGHTUSERINFO.nested_types = {}
FIGHTUSERINFO.enum_types = {}
FIGHTUSERINFO.fields = {
  FIGHTUSERINFO_DAMAGE_FIELD,
  FIGHTUSERINFO_HEAL_FIELD,
  FIGHTUSERINFO_SUFFER_FIELD,
  FIGHTUSERINFO_DAMGENAME_FIELD,
  FIGHTUSERINFO_HEALNAME_FIELD,
  FIGHTUSERINFO_SUFFERNAME_FIELD,
  FIGHTUSERINFO_MVPUSERINFO_FIELD
}
FIGHTUSERINFO.is_extendable = false
FIGHTUSERINFO.extensions = {}
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.name = "cmd"
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.cmd"
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.number = 1
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.index = 0
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.has_default_value = true
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.default_value = 11
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.type = 14
SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.name = "param"
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.param"
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.number = 2
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.index = 1
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.default_value = 143
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.type = 14
SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.name = "sailingtime"
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.sailingtime"
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.number = 3
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.index = 2
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.name = "sailingaddscore"
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.sailingaddscore"
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.number = 4
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.index = 3
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.name = "boxleftnum"
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.boxleftnum"
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.number = 5
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.index = 4
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.name = "boxtotalnum"
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.boxtotalnum"
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.number = 6
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.index = 5
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.name = "boxdecscore"
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.boxdecscore"
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.number = 7
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.index = 6
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.name = "relivecount"
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.relivecount"
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.number = 8
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.index = 7
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.name = "relivedecscore"
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.relivedecscore"
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.number = 9
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.index = 8
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.name = "grade"
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.grade"
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.number = 10
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.index = 9
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.name = "fightinfo"
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.fightinfo"
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.number = 11
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.index = 10
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.default_value = nil
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.message_type = FIGHTUSERINFO
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.type = 11
SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD.cpp_type = 10
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.name = "difficulty"
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd.difficulty"
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.number = 12
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.index = 11
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.label = 1
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.has_default_value = false
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.default_value = 0
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.type = 13
SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD.cpp_type = 3
SYNCSTARARKSTATISTICSFUBENCMD.name = "SyncStarArkStatisticsFuBenCmd"
SYNCSTARARKSTATISTICSFUBENCMD.full_name = ".Cmd.SyncStarArkStatisticsFuBenCmd"
SYNCSTARARKSTATISTICSFUBENCMD.nested_types = {}
SYNCSTARARKSTATISTICSFUBENCMD.enum_types = {}
SYNCSTARARKSTATISTICSFUBENCMD.fields = {
  SYNCSTARARKSTATISTICSFUBENCMD_CMD_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_PARAM_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_SAILINGTIME_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_SAILINGADDSCORE_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_BOXLEFTNUM_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_BOXTOTALNUM_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_BOXDECSCORE_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_RELIVECOUNT_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_RELIVEDECSCORE_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_GRADE_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_FIGHTINFO_FIELD,
  SYNCSTARARKSTATISTICSFUBENCMD_DIFFICULTY_FIELD
}
SYNCSTARARKSTATISTICSFUBENCMD.is_extendable = false
SYNCSTARARKSTATISTICSFUBENCMD.extensions = {}
OPENNTFFUBENCMD_CMD_FIELD.name = "cmd"
OPENNTFFUBENCMD_CMD_FIELD.full_name = ".Cmd.OpenNtfFuBenCmd.cmd"
OPENNTFFUBENCMD_CMD_FIELD.number = 1
OPENNTFFUBENCMD_CMD_FIELD.index = 0
OPENNTFFUBENCMD_CMD_FIELD.label = 1
OPENNTFFUBENCMD_CMD_FIELD.has_default_value = true
OPENNTFFUBENCMD_CMD_FIELD.default_value = 11
OPENNTFFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OPENNTFFUBENCMD_CMD_FIELD.type = 14
OPENNTFFUBENCMD_CMD_FIELD.cpp_type = 8
OPENNTFFUBENCMD_PARAM_FIELD.name = "param"
OPENNTFFUBENCMD_PARAM_FIELD.full_name = ".Cmd.OpenNtfFuBenCmd.param"
OPENNTFFUBENCMD_PARAM_FIELD.number = 2
OPENNTFFUBENCMD_PARAM_FIELD.index = 1
OPENNTFFUBENCMD_PARAM_FIELD.label = 1
OPENNTFFUBENCMD_PARAM_FIELD.has_default_value = true
OPENNTFFUBENCMD_PARAM_FIELD.default_value = 144
OPENNTFFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
OPENNTFFUBENCMD_PARAM_FIELD.type = 14
OPENNTFFUBENCMD_PARAM_FIELD.cpp_type = 8
OPENNTFFUBENCMD_RAIDTYPE_FIELD.name = "raidtype"
OPENNTFFUBENCMD_RAIDTYPE_FIELD.full_name = ".Cmd.OpenNtfFuBenCmd.raidtype"
OPENNTFFUBENCMD_RAIDTYPE_FIELD.number = 3
OPENNTFFUBENCMD_RAIDTYPE_FIELD.index = 2
OPENNTFFUBENCMD_RAIDTYPE_FIELD.label = 1
OPENNTFFUBENCMD_RAIDTYPE_FIELD.has_default_value = false
OPENNTFFUBENCMD_RAIDTYPE_FIELD.default_value = nil
OPENNTFFUBENCMD_RAIDTYPE_FIELD.enum_type = ERAIDTYPE
OPENNTFFUBENCMD_RAIDTYPE_FIELD.type = 14
OPENNTFFUBENCMD_RAIDTYPE_FIELD.cpp_type = 8
OPENNTFFUBENCMD.name = "OpenNtfFuBenCmd"
OPENNTFFUBENCMD.full_name = ".Cmd.OpenNtfFuBenCmd"
OPENNTFFUBENCMD.nested_types = {}
OPENNTFFUBENCMD.enum_types = {}
OPENNTFFUBENCMD.fields = {
  OPENNTFFUBENCMD_CMD_FIELD,
  OPENNTFFUBENCMD_PARAM_FIELD,
  OPENNTFFUBENCMD_RAIDTYPE_FIELD
}
OPENNTFFUBENCMD.is_extendable = false
OPENNTFFUBENCMD.extensions = {}
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.name = "cmd"
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.full_name = ".Cmd.RoadblocksChangeFubenCmd.cmd"
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.number = 1
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.index = 0
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.label = 1
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.has_default_value = true
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.default_value = 11
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.type = 14
ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD.cpp_type = 8
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.name = "param"
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.RoadblocksChangeFubenCmd.param"
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.number = 2
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.index = 1
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.label = 1
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.has_default_value = true
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.default_value = 145
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.type = 14
ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD.cpp_type = 8
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.name = "roadblock"
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.full_name = ".Cmd.RoadblocksChangeFubenCmd.roadblock"
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.number = 3
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.index = 2
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.label = 1
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.has_default_value = false
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.default_value = 0
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.type = 13
ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD.cpp_type = 3
ROADBLOCKSCHANGEFUBENCMD.name = "RoadblocksChangeFubenCmd"
ROADBLOCKSCHANGEFUBENCMD.full_name = ".Cmd.RoadblocksChangeFubenCmd"
ROADBLOCKSCHANGEFUBENCMD.nested_types = {}
ROADBLOCKSCHANGEFUBENCMD.enum_types = {}
ROADBLOCKSCHANGEFUBENCMD.fields = {
  ROADBLOCKSCHANGEFUBENCMD_CMD_FIELD,
  ROADBLOCKSCHANGEFUBENCMD_PARAM_FIELD,
  ROADBLOCKSCHANGEFUBENCMD_ROADBLOCK_FIELD
}
ROADBLOCKSCHANGEFUBENCMD.is_extendable = false
ROADBLOCKSCHANGEFUBENCMD.extensions = {}
PASSINFO_EQUIPS_FIELD.name = "equips"
PASSINFO_EQUIPS_FIELD.full_name = ".Cmd.PassInfo.equips"
PASSINFO_EQUIPS_FIELD.number = 1
PASSINFO_EQUIPS_FIELD.index = 0
PASSINFO_EQUIPS_FIELD.label = 3
PASSINFO_EQUIPS_FIELD.has_default_value = false
PASSINFO_EQUIPS_FIELD.default_value = {}
PASSINFO_EQUIPS_FIELD.message_type = _PASSEQUIP
PASSINFO_EQUIPS_FIELD.type = 11
PASSINFO_EQUIPS_FIELD.cpp_type = 10
PASSINFO_USERINFOS_FIELD.name = "userinfos"
PASSINFO_USERINFOS_FIELD.full_name = ".Cmd.PassInfo.userinfos"
PASSINFO_USERINFOS_FIELD.number = 2
PASSINFO_USERINFOS_FIELD.index = 1
PASSINFO_USERINFOS_FIELD.label = 3
PASSINFO_USERINFOS_FIELD.has_default_value = false
PASSINFO_USERINFOS_FIELD.default_value = {}
PASSINFO_USERINFOS_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
PASSINFO_USERINFOS_FIELD.type = 11
PASSINFO_USERINFOS_FIELD.cpp_type = 10
PASSINFO_SHADOW_EQUIPS_FIELD.name = "shadow_equips"
PASSINFO_SHADOW_EQUIPS_FIELD.full_name = ".Cmd.PassInfo.shadow_equips"
PASSINFO_SHADOW_EQUIPS_FIELD.number = 3
PASSINFO_SHADOW_EQUIPS_FIELD.index = 2
PASSINFO_SHADOW_EQUIPS_FIELD.label = 3
PASSINFO_SHADOW_EQUIPS_FIELD.has_default_value = false
PASSINFO_SHADOW_EQUIPS_FIELD.default_value = {}
PASSINFO_SHADOW_EQUIPS_FIELD.message_type = _PASSEQUIP
PASSINFO_SHADOW_EQUIPS_FIELD.type = 11
PASSINFO_SHADOW_EQUIPS_FIELD.cpp_type = 10
PASSINFO.name = "PassInfo"
PASSINFO.full_name = ".Cmd.PassInfo"
PASSINFO.nested_types = {}
PASSINFO.enum_types = {}
PASSINFO.fields = {
  PASSINFO_EQUIPS_FIELD,
  PASSINFO_USERINFOS_FIELD,
  PASSINFO_SHADOW_EQUIPS_FIELD
}
PASSINFO.is_extendable = false
PASSINFO.extensions = {}
PASSEQUIP_POS_FIELD.name = "pos"
PASSEQUIP_POS_FIELD.full_name = ".Cmd.PassEquip.pos"
PASSEQUIP_POS_FIELD.number = 1
PASSEQUIP_POS_FIELD.index = 0
PASSEQUIP_POS_FIELD.label = 1
PASSEQUIP_POS_FIELD.has_default_value = false
PASSEQUIP_POS_FIELD.default_value = 0
PASSEQUIP_POS_FIELD.type = 13
PASSEQUIP_POS_FIELD.cpp_type = 3
PASSEQUIP_CARD_FIELD.name = "card"
PASSEQUIP_CARD_FIELD.full_name = ".Cmd.PassEquip.card"
PASSEQUIP_CARD_FIELD.number = 2
PASSEQUIP_CARD_FIELD.index = 1
PASSEQUIP_CARD_FIELD.label = 3
PASSEQUIP_CARD_FIELD.has_default_value = false
PASSEQUIP_CARD_FIELD.default_value = {}
PASSEQUIP_CARD_FIELD.message_type = _PASSEQUIPITEM
PASSEQUIP_CARD_FIELD.type = 11
PASSEQUIP_CARD_FIELD.cpp_type = 10
PASSEQUIP_EQUIP_FIELD.name = "equip"
PASSEQUIP_EQUIP_FIELD.full_name = ".Cmd.PassEquip.equip"
PASSEQUIP_EQUIP_FIELD.number = 3
PASSEQUIP_EQUIP_FIELD.index = 2
PASSEQUIP_EQUIP_FIELD.label = 3
PASSEQUIP_EQUIP_FIELD.has_default_value = false
PASSEQUIP_EQUIP_FIELD.default_value = {}
PASSEQUIP_EQUIP_FIELD.message_type = _PASSEQUIPITEM
PASSEQUIP_EQUIP_FIELD.type = 11
PASSEQUIP_EQUIP_FIELD.cpp_type = 10
PASSEQUIP.name = "PassEquip"
PASSEQUIP.full_name = ".Cmd.PassEquip"
PASSEQUIP.nested_types = {}
PASSEQUIP.enum_types = {}
PASSEQUIP.fields = {
  PASSEQUIP_POS_FIELD,
  PASSEQUIP_CARD_FIELD,
  PASSEQUIP_EQUIP_FIELD
}
PASSEQUIP.is_extendable = false
PASSEQUIP.extensions = {}
PASSEQUIPITEM_ITEMID_FIELD.name = "itemid"
PASSEQUIPITEM_ITEMID_FIELD.full_name = ".Cmd.PassEquipItem.itemid"
PASSEQUIPITEM_ITEMID_FIELD.number = 1
PASSEQUIPITEM_ITEMID_FIELD.index = 0
PASSEQUIPITEM_ITEMID_FIELD.label = 1
PASSEQUIPITEM_ITEMID_FIELD.has_default_value = false
PASSEQUIPITEM_ITEMID_FIELD.default_value = 0
PASSEQUIPITEM_ITEMID_FIELD.type = 13
PASSEQUIPITEM_ITEMID_FIELD.cpp_type = 3
PASSEQUIPITEM_FREQUENCY_FIELD.name = "frequency"
PASSEQUIPITEM_FREQUENCY_FIELD.full_name = ".Cmd.PassEquipItem.frequency"
PASSEQUIPITEM_FREQUENCY_FIELD.number = 2
PASSEQUIPITEM_FREQUENCY_FIELD.index = 1
PASSEQUIPITEM_FREQUENCY_FIELD.label = 1
PASSEQUIPITEM_FREQUENCY_FIELD.has_default_value = false
PASSEQUIPITEM_FREQUENCY_FIELD.default_value = 0
PASSEQUIPITEM_FREQUENCY_FIELD.type = 13
PASSEQUIPITEM_FREQUENCY_FIELD.cpp_type = 3
PASSEQUIPITEM.name = "PassEquipItem"
PASSEQUIPITEM.full_name = ".Cmd.PassEquipItem"
PASSEQUIPITEM.nested_types = {}
PASSEQUIPITEM.enum_types = {}
PASSEQUIPITEM.fields = {
  PASSEQUIPITEM_ITEMID_FIELD,
  PASSEQUIPITEM_FREQUENCY_FIELD
}
PASSEQUIPITEM.is_extendable = false
PASSEQUIPITEM.extensions = {}
SYNCPASSUSERINFO_CMD_FIELD.name = "cmd"
SYNCPASSUSERINFO_CMD_FIELD.full_name = ".Cmd.SyncPassUserInfo.cmd"
SYNCPASSUSERINFO_CMD_FIELD.number = 1
SYNCPASSUSERINFO_CMD_FIELD.index = 0
SYNCPASSUSERINFO_CMD_FIELD.label = 1
SYNCPASSUSERINFO_CMD_FIELD.has_default_value = true
SYNCPASSUSERINFO_CMD_FIELD.default_value = 11
SYNCPASSUSERINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCPASSUSERINFO_CMD_FIELD.type = 14
SYNCPASSUSERINFO_CMD_FIELD.cpp_type = 8
SYNCPASSUSERINFO_PARAM_FIELD.name = "param"
SYNCPASSUSERINFO_PARAM_FIELD.full_name = ".Cmd.SyncPassUserInfo.param"
SYNCPASSUSERINFO_PARAM_FIELD.number = 2
SYNCPASSUSERINFO_PARAM_FIELD.index = 1
SYNCPASSUSERINFO_PARAM_FIELD.label = 1
SYNCPASSUSERINFO_PARAM_FIELD.has_default_value = true
SYNCPASSUSERINFO_PARAM_FIELD.default_value = 152
SYNCPASSUSERINFO_PARAM_FIELD.enum_type = FUBENPARAM
SYNCPASSUSERINFO_PARAM_FIELD.type = 14
SYNCPASSUSERINFO_PARAM_FIELD.cpp_type = 8
SYNCPASSUSERINFO_BRANCH_FIELD.name = "branch"
SYNCPASSUSERINFO_BRANCH_FIELD.full_name = ".Cmd.SyncPassUserInfo.branch"
SYNCPASSUSERINFO_BRANCH_FIELD.number = 3
SYNCPASSUSERINFO_BRANCH_FIELD.index = 2
SYNCPASSUSERINFO_BRANCH_FIELD.label = 1
SYNCPASSUSERINFO_BRANCH_FIELD.has_default_value = false
SYNCPASSUSERINFO_BRANCH_FIELD.default_value = 0
SYNCPASSUSERINFO_BRANCH_FIELD.type = 13
SYNCPASSUSERINFO_BRANCH_FIELD.cpp_type = 3
SYNCPASSUSERINFO_DATA_FIELD.name = "data"
SYNCPASSUSERINFO_DATA_FIELD.full_name = ".Cmd.SyncPassUserInfo.data"
SYNCPASSUSERINFO_DATA_FIELD.number = 4
SYNCPASSUSERINFO_DATA_FIELD.index = 3
SYNCPASSUSERINFO_DATA_FIELD.label = 1
SYNCPASSUSERINFO_DATA_FIELD.has_default_value = false
SYNCPASSUSERINFO_DATA_FIELD.default_value = nil
SYNCPASSUSERINFO_DATA_FIELD.message_type = ProtoCommon_pb.TRANSDATA
SYNCPASSUSERINFO_DATA_FIELD.type = 11
SYNCPASSUSERINFO_DATA_FIELD.cpp_type = 10
SYNCPASSUSERINFO.name = "SyncPassUserInfo"
SYNCPASSUSERINFO.full_name = ".Cmd.SyncPassUserInfo"
SYNCPASSUSERINFO.nested_types = {}
SYNCPASSUSERINFO.enum_types = {}
SYNCPASSUSERINFO.fields = {
  SYNCPASSUSERINFO_CMD_FIELD,
  SYNCPASSUSERINFO_PARAM_FIELD,
  SYNCPASSUSERINFO_BRANCH_FIELD,
  SYNCPASSUSERINFO_DATA_FIELD
}
SYNCPASSUSERINFO.is_extendable = false
SYNCPASSUSERINFO.extensions = {}
TRIPLEUSERDATA_CHARID_FIELD.name = "charid"
TRIPLEUSERDATA_CHARID_FIELD.full_name = ".Cmd.TripleUserData.charid"
TRIPLEUSERDATA_CHARID_FIELD.number = 1
TRIPLEUSERDATA_CHARID_FIELD.index = 0
TRIPLEUSERDATA_CHARID_FIELD.label = 1
TRIPLEUSERDATA_CHARID_FIELD.has_default_value = false
TRIPLEUSERDATA_CHARID_FIELD.default_value = 0
TRIPLEUSERDATA_CHARID_FIELD.type = 4
TRIPLEUSERDATA_CHARID_FIELD.cpp_type = 4
TRIPLEUSERDATA_USERNAME_FIELD.name = "username"
TRIPLEUSERDATA_USERNAME_FIELD.full_name = ".Cmd.TripleUserData.username"
TRIPLEUSERDATA_USERNAME_FIELD.number = 2
TRIPLEUSERDATA_USERNAME_FIELD.index = 1
TRIPLEUSERDATA_USERNAME_FIELD.label = 1
TRIPLEUSERDATA_USERNAME_FIELD.has_default_value = false
TRIPLEUSERDATA_USERNAME_FIELD.default_value = ""
TRIPLEUSERDATA_USERNAME_FIELD.type = 9
TRIPLEUSERDATA_USERNAME_FIELD.cpp_type = 9
TRIPLEUSERDATA_PROFESSION_FIELD.name = "profession"
TRIPLEUSERDATA_PROFESSION_FIELD.full_name = ".Cmd.TripleUserData.profession"
TRIPLEUSERDATA_PROFESSION_FIELD.number = 3
TRIPLEUSERDATA_PROFESSION_FIELD.index = 2
TRIPLEUSERDATA_PROFESSION_FIELD.label = 1
TRIPLEUSERDATA_PROFESSION_FIELD.has_default_value = false
TRIPLEUSERDATA_PROFESSION_FIELD.default_value = nil
TRIPLEUSERDATA_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
TRIPLEUSERDATA_PROFESSION_FIELD.type = 14
TRIPLEUSERDATA_PROFESSION_FIELD.cpp_type = 8
TRIPLEUSERDATA_PORTRAIT_FIELD.name = "portrait"
TRIPLEUSERDATA_PORTRAIT_FIELD.full_name = ".Cmd.TripleUserData.portrait"
TRIPLEUSERDATA_PORTRAIT_FIELD.number = 4
TRIPLEUSERDATA_PORTRAIT_FIELD.index = 3
TRIPLEUSERDATA_PORTRAIT_FIELD.label = 1
TRIPLEUSERDATA_PORTRAIT_FIELD.has_default_value = false
TRIPLEUSERDATA_PORTRAIT_FIELD.default_value = nil
TRIPLEUSERDATA_PORTRAIT_FIELD.message_type = ProtoCommon_pb.USERPORTRAITDATA
TRIPLEUSERDATA_PORTRAIT_FIELD.type = 11
TRIPLEUSERDATA_PORTRAIT_FIELD.cpp_type = 10
TRIPLEUSERDATA_KILLNUM_FIELD.name = "killnum"
TRIPLEUSERDATA_KILLNUM_FIELD.full_name = ".Cmd.TripleUserData.killnum"
TRIPLEUSERDATA_KILLNUM_FIELD.number = 5
TRIPLEUSERDATA_KILLNUM_FIELD.index = 4
TRIPLEUSERDATA_KILLNUM_FIELD.label = 1
TRIPLEUSERDATA_KILLNUM_FIELD.has_default_value = false
TRIPLEUSERDATA_KILLNUM_FIELD.default_value = 0
TRIPLEUSERDATA_KILLNUM_FIELD.type = 13
TRIPLEUSERDATA_KILLNUM_FIELD.cpp_type = 3
TRIPLEUSERDATA_DIENUM_FIELD.name = "dienum"
TRIPLEUSERDATA_DIENUM_FIELD.full_name = ".Cmd.TripleUserData.dienum"
TRIPLEUSERDATA_DIENUM_FIELD.number = 6
TRIPLEUSERDATA_DIENUM_FIELD.index = 5
TRIPLEUSERDATA_DIENUM_FIELD.label = 1
TRIPLEUSERDATA_DIENUM_FIELD.has_default_value = false
TRIPLEUSERDATA_DIENUM_FIELD.default_value = 0
TRIPLEUSERDATA_DIENUM_FIELD.type = 13
TRIPLEUSERDATA_DIENUM_FIELD.cpp_type = 3
TRIPLEUSERDATA_HELPNUM_FIELD.name = "helpnum"
TRIPLEUSERDATA_HELPNUM_FIELD.full_name = ".Cmd.TripleUserData.helpnum"
TRIPLEUSERDATA_HELPNUM_FIELD.number = 7
TRIPLEUSERDATA_HELPNUM_FIELD.index = 6
TRIPLEUSERDATA_HELPNUM_FIELD.label = 1
TRIPLEUSERDATA_HELPNUM_FIELD.has_default_value = false
TRIPLEUSERDATA_HELPNUM_FIELD.default_value = 0
TRIPLEUSERDATA_HELPNUM_FIELD.type = 13
TRIPLEUSERDATA_HELPNUM_FIELD.cpp_type = 3
TRIPLEUSERDATA_DAMAGE_FIELD.name = "damage"
TRIPLEUSERDATA_DAMAGE_FIELD.full_name = ".Cmd.TripleUserData.damage"
TRIPLEUSERDATA_DAMAGE_FIELD.number = 8
TRIPLEUSERDATA_DAMAGE_FIELD.index = 7
TRIPLEUSERDATA_DAMAGE_FIELD.label = 1
TRIPLEUSERDATA_DAMAGE_FIELD.has_default_value = false
TRIPLEUSERDATA_DAMAGE_FIELD.default_value = 0
TRIPLEUSERDATA_DAMAGE_FIELD.type = 13
TRIPLEUSERDATA_DAMAGE_FIELD.cpp_type = 3
TRIPLEUSERDATA_BEDAMAGE_FIELD.name = "bedamage"
TRIPLEUSERDATA_BEDAMAGE_FIELD.full_name = ".Cmd.TripleUserData.bedamage"
TRIPLEUSERDATA_BEDAMAGE_FIELD.number = 9
TRIPLEUSERDATA_BEDAMAGE_FIELD.index = 8
TRIPLEUSERDATA_BEDAMAGE_FIELD.label = 1
TRIPLEUSERDATA_BEDAMAGE_FIELD.has_default_value = false
TRIPLEUSERDATA_BEDAMAGE_FIELD.default_value = 0
TRIPLEUSERDATA_BEDAMAGE_FIELD.type = 13
TRIPLEUSERDATA_BEDAMAGE_FIELD.cpp_type = 3
TRIPLEUSERDATA_HEAL_FIELD.name = "heal"
TRIPLEUSERDATA_HEAL_FIELD.full_name = ".Cmd.TripleUserData.heal"
TRIPLEUSERDATA_HEAL_FIELD.number = 10
TRIPLEUSERDATA_HEAL_FIELD.index = 9
TRIPLEUSERDATA_HEAL_FIELD.label = 1
TRIPLEUSERDATA_HEAL_FIELD.has_default_value = false
TRIPLEUSERDATA_HEAL_FIELD.default_value = 0
TRIPLEUSERDATA_HEAL_FIELD.type = 13
TRIPLEUSERDATA_HEAL_FIELD.cpp_type = 3
TRIPLEUSERDATA_HIDENAME_FIELD.name = "hidename"
TRIPLEUSERDATA_HIDENAME_FIELD.full_name = ".Cmd.TripleUserData.hidename"
TRIPLEUSERDATA_HIDENAME_FIELD.number = 11
TRIPLEUSERDATA_HIDENAME_FIELD.index = 10
TRIPLEUSERDATA_HIDENAME_FIELD.label = 1
TRIPLEUSERDATA_HIDENAME_FIELD.has_default_value = false
TRIPLEUSERDATA_HIDENAME_FIELD.default_value = false
TRIPLEUSERDATA_HIDENAME_FIELD.type = 8
TRIPLEUSERDATA_HIDENAME_FIELD.cpp_type = 7
TRIPLEUSERDATA_SCORE_FIELD.name = "score"
TRIPLEUSERDATA_SCORE_FIELD.full_name = ".Cmd.TripleUserData.score"
TRIPLEUSERDATA_SCORE_FIELD.number = 12
TRIPLEUSERDATA_SCORE_FIELD.index = 11
TRIPLEUSERDATA_SCORE_FIELD.label = 1
TRIPLEUSERDATA_SCORE_FIELD.has_default_value = false
TRIPLEUSERDATA_SCORE_FIELD.default_value = 0
TRIPLEUSERDATA_SCORE_FIELD.type = 13
TRIPLEUSERDATA_SCORE_FIELD.cpp_type = 3
TRIPLEUSERDATA_ADDSCORE_FIELD.name = "addscore"
TRIPLEUSERDATA_ADDSCORE_FIELD.full_name = ".Cmd.TripleUserData.addscore"
TRIPLEUSERDATA_ADDSCORE_FIELD.number = 13
TRIPLEUSERDATA_ADDSCORE_FIELD.index = 12
TRIPLEUSERDATA_ADDSCORE_FIELD.label = 1
TRIPLEUSERDATA_ADDSCORE_FIELD.has_default_value = false
TRIPLEUSERDATA_ADDSCORE_FIELD.default_value = 0
TRIPLEUSERDATA_ADDSCORE_FIELD.type = 5
TRIPLEUSERDATA_ADDSCORE_FIELD.cpp_type = 1
TRIPLEUSERDATA.name = "TripleUserData"
TRIPLEUSERDATA.full_name = ".Cmd.TripleUserData"
TRIPLEUSERDATA.nested_types = {}
TRIPLEUSERDATA.enum_types = {}
TRIPLEUSERDATA.fields = {
  TRIPLEUSERDATA_CHARID_FIELD,
  TRIPLEUSERDATA_USERNAME_FIELD,
  TRIPLEUSERDATA_PROFESSION_FIELD,
  TRIPLEUSERDATA_PORTRAIT_FIELD,
  TRIPLEUSERDATA_KILLNUM_FIELD,
  TRIPLEUSERDATA_DIENUM_FIELD,
  TRIPLEUSERDATA_HELPNUM_FIELD,
  TRIPLEUSERDATA_DAMAGE_FIELD,
  TRIPLEUSERDATA_BEDAMAGE_FIELD,
  TRIPLEUSERDATA_HEAL_FIELD,
  TRIPLEUSERDATA_HIDENAME_FIELD,
  TRIPLEUSERDATA_SCORE_FIELD,
  TRIPLEUSERDATA_ADDSCORE_FIELD
}
TRIPLEUSERDATA.is_extendable = false
TRIPLEUSERDATA.extensions = {}
TRIPLECAMPDATA_ECAMP_FIELD.name = "ecamp"
TRIPLECAMPDATA_ECAMP_FIELD.full_name = ".Cmd.TripleCampData.ecamp"
TRIPLECAMPDATA_ECAMP_FIELD.number = 1
TRIPLECAMPDATA_ECAMP_FIELD.index = 0
TRIPLECAMPDATA_ECAMP_FIELD.label = 1
TRIPLECAMPDATA_ECAMP_FIELD.has_default_value = false
TRIPLECAMPDATA_ECAMP_FIELD.default_value = nil
TRIPLECAMPDATA_ECAMP_FIELD.enum_type = ETRIPLECAMP
TRIPLECAMPDATA_ECAMP_FIELD.type = 14
TRIPLECAMPDATA_ECAMP_FIELD.cpp_type = 8
TRIPLECAMPDATA_SCORE_FIELD.name = "score"
TRIPLECAMPDATA_SCORE_FIELD.full_name = ".Cmd.TripleCampData.score"
TRIPLECAMPDATA_SCORE_FIELD.number = 2
TRIPLECAMPDATA_SCORE_FIELD.index = 1
TRIPLECAMPDATA_SCORE_FIELD.label = 1
TRIPLECAMPDATA_SCORE_FIELD.has_default_value = false
TRIPLECAMPDATA_SCORE_FIELD.default_value = 0
TRIPLECAMPDATA_SCORE_FIELD.type = 13
TRIPLECAMPDATA_SCORE_FIELD.cpp_type = 3
TRIPLECAMPDATA_USERS_FIELD.name = "users"
TRIPLECAMPDATA_USERS_FIELD.full_name = ".Cmd.TripleCampData.users"
TRIPLECAMPDATA_USERS_FIELD.number = 3
TRIPLECAMPDATA_USERS_FIELD.index = 2
TRIPLECAMPDATA_USERS_FIELD.label = 3
TRIPLECAMPDATA_USERS_FIELD.has_default_value = false
TRIPLECAMPDATA_USERS_FIELD.default_value = {}
TRIPLECAMPDATA_USERS_FIELD.message_type = TRIPLEUSERDATA
TRIPLECAMPDATA_USERS_FIELD.type = 11
TRIPLECAMPDATA_USERS_FIELD.cpp_type = 10
TRIPLECAMPDATA.name = "TripleCampData"
TRIPLECAMPDATA.full_name = ".Cmd.TripleCampData"
TRIPLECAMPDATA.nested_types = {}
TRIPLECAMPDATA.enum_types = {}
TRIPLECAMPDATA.fields = {
  TRIPLECAMPDATA_ECAMP_FIELD,
  TRIPLECAMPDATA_SCORE_FIELD,
  TRIPLECAMPDATA_USERS_FIELD
}
TRIPLECAMPDATA.is_extendable = false
TRIPLECAMPDATA.extensions = {}
TRIPLECOMBODATA_CHARID_FIELD.name = "charid"
TRIPLECOMBODATA_CHARID_FIELD.full_name = ".Cmd.TripleComboData.charid"
TRIPLECOMBODATA_CHARID_FIELD.number = 1
TRIPLECOMBODATA_CHARID_FIELD.index = 0
TRIPLECOMBODATA_CHARID_FIELD.label = 1
TRIPLECOMBODATA_CHARID_FIELD.has_default_value = false
TRIPLECOMBODATA_CHARID_FIELD.default_value = 0
TRIPLECOMBODATA_CHARID_FIELD.type = 4
TRIPLECOMBODATA_CHARID_FIELD.cpp_type = 4
TRIPLECOMBODATA_COMBO_FIELD.name = "combo"
TRIPLECOMBODATA_COMBO_FIELD.full_name = ".Cmd.TripleComboData.combo"
TRIPLECOMBODATA_COMBO_FIELD.number = 2
TRIPLECOMBODATA_COMBO_FIELD.index = 1
TRIPLECOMBODATA_COMBO_FIELD.label = 1
TRIPLECOMBODATA_COMBO_FIELD.has_default_value = false
TRIPLECOMBODATA_COMBO_FIELD.default_value = 0
TRIPLECOMBODATA_COMBO_FIELD.type = 13
TRIPLECOMBODATA_COMBO_FIELD.cpp_type = 3
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.name = "lifekillnum"
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.full_name = ".Cmd.TripleComboData.lifekillnum"
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.number = 3
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.index = 2
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.label = 1
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.has_default_value = false
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.default_value = 0
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.type = 13
TRIPLECOMBODATA_LIFEKILLNUM_FIELD.cpp_type = 3
TRIPLECOMBODATA.name = "TripleComboData"
TRIPLECOMBODATA.full_name = ".Cmd.TripleComboData"
TRIPLECOMBODATA.nested_types = {}
TRIPLECOMBODATA.enum_types = {}
TRIPLECOMBODATA.fields = {
  TRIPLECOMBODATA_CHARID_FIELD,
  TRIPLECOMBODATA_COMBO_FIELD,
  TRIPLECOMBODATA_LIFEKILLNUM_FIELD
}
TRIPLECOMBODATA.is_extendable = false
TRIPLECOMBODATA.extensions = {}
TRIPLEUSERINFO_USER_FIELD.name = "user"
TRIPLEUSERINFO_USER_FIELD.full_name = ".Cmd.TripleUserInfo.user"
TRIPLEUSERINFO_USER_FIELD.number = 1
TRIPLEUSERINFO_USER_FIELD.index = 0
TRIPLEUSERINFO_USER_FIELD.label = 1
TRIPLEUSERINFO_USER_FIELD.has_default_value = false
TRIPLEUSERINFO_USER_FIELD.default_value = nil
TRIPLEUSERINFO_USER_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
TRIPLEUSERINFO_USER_FIELD.type = 11
TRIPLEUSERINFO_USER_FIELD.cpp_type = 10
TRIPLEUSERINFO_INDEX_FIELD.name = "index"
TRIPLEUSERINFO_INDEX_FIELD.full_name = ".Cmd.TripleUserInfo.index"
TRIPLEUSERINFO_INDEX_FIELD.number = 2
TRIPLEUSERINFO_INDEX_FIELD.index = 1
TRIPLEUSERINFO_INDEX_FIELD.label = 1
TRIPLEUSERINFO_INDEX_FIELD.has_default_value = false
TRIPLEUSERINFO_INDEX_FIELD.default_value = 0
TRIPLEUSERINFO_INDEX_FIELD.type = 13
TRIPLEUSERINFO_INDEX_FIELD.cpp_type = 3
TRIPLEUSERINFO_OFFLINE_FIELD.name = "offline"
TRIPLEUSERINFO_OFFLINE_FIELD.full_name = ".Cmd.TripleUserInfo.offline"
TRIPLEUSERINFO_OFFLINE_FIELD.number = 3
TRIPLEUSERINFO_OFFLINE_FIELD.index = 2
TRIPLEUSERINFO_OFFLINE_FIELD.label = 1
TRIPLEUSERINFO_OFFLINE_FIELD.has_default_value = false
TRIPLEUSERINFO_OFFLINE_FIELD.default_value = false
TRIPLEUSERINFO_OFFLINE_FIELD.type = 8
TRIPLEUSERINFO_OFFLINE_FIELD.cpp_type = 7
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.name = "choose_profession"
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.full_name = ".Cmd.TripleUserInfo.choose_profession"
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.number = 4
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.index = 3
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.label = 1
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.has_default_value = false
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.default_value = nil
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.type = 14
TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD.cpp_type = 8
TRIPLEUSERINFO.name = "TripleUserInfo"
TRIPLEUSERINFO.full_name = ".Cmd.TripleUserInfo"
TRIPLEUSERINFO.nested_types = {}
TRIPLEUSERINFO.enum_types = {}
TRIPLEUSERINFO.fields = {
  TRIPLEUSERINFO_USER_FIELD,
  TRIPLEUSERINFO_INDEX_FIELD,
  TRIPLEUSERINFO_OFFLINE_FIELD,
  TRIPLEUSERINFO_CHOOSE_PROFESSION_FIELD
}
TRIPLEUSERINFO.is_extendable = false
TRIPLEUSERINFO.extensions = {}
TRIPLEMODELDATA_ECAMP_FIELD.name = "ecamp"
TRIPLEMODELDATA_ECAMP_FIELD.full_name = ".Cmd.TripleModelData.ecamp"
TRIPLEMODELDATA_ECAMP_FIELD.number = 1
TRIPLEMODELDATA_ECAMP_FIELD.index = 0
TRIPLEMODELDATA_ECAMP_FIELD.label = 1
TRIPLEMODELDATA_ECAMP_FIELD.has_default_value = false
TRIPLEMODELDATA_ECAMP_FIELD.default_value = nil
TRIPLEMODELDATA_ECAMP_FIELD.enum_type = ETRIPLECAMP
TRIPLEMODELDATA_ECAMP_FIELD.type = 14
TRIPLEMODELDATA_ECAMP_FIELD.cpp_type = 8
TRIPLEMODELDATA_USERINFOS_FIELD.name = "userinfos"
TRIPLEMODELDATA_USERINFOS_FIELD.full_name = ".Cmd.TripleModelData.userinfos"
TRIPLEMODELDATA_USERINFOS_FIELD.number = 2
TRIPLEMODELDATA_USERINFOS_FIELD.index = 1
TRIPLEMODELDATA_USERINFOS_FIELD.label = 3
TRIPLEMODELDATA_USERINFOS_FIELD.has_default_value = false
TRIPLEMODELDATA_USERINFOS_FIELD.default_value = {}
TRIPLEMODELDATA_USERINFOS_FIELD.message_type = TRIPLEUSERINFO
TRIPLEMODELDATA_USERINFOS_FIELD.type = 11
TRIPLEMODELDATA_USERINFOS_FIELD.cpp_type = 10
TRIPLEMODELDATA.name = "TripleModelData"
TRIPLEMODELDATA.full_name = ".Cmd.TripleModelData"
TRIPLEMODELDATA.nested_types = {}
TRIPLEMODELDATA.enum_types = {}
TRIPLEMODELDATA.fields = {
  TRIPLEMODELDATA_ECAMP_FIELD,
  TRIPLEMODELDATA_USERINFOS_FIELD
}
TRIPLEMODELDATA.is_extendable = false
TRIPLEMODELDATA.extensions = {}
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.cmd"
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.param"
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.default_value = 146
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.name = "camps"
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.camps"
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.number = 3
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.index = 2
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.label = 3
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.has_default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.default_value = {}
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.message_type = TRIPLECAMPDATA
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.type = 11
SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD.cpp_type = 10
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.name = "mvpuserinfo"
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.mvpuserinfo"
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.number = 4
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.index = 3
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.has_default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.default_value = nil
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.message_type = ChatCmd_pb.QUERYUSERINFO
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.type = 11
SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD.cpp_type = 10
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.name = "isfinish"
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.isfinish"
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.number = 5
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.index = 4
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.has_default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.type = 8
SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD.cpp_type = 7
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.name = "wincamp"
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.wincamp"
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.number = 6
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.index = 5
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.has_default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.default_value = nil
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.enum_type = ETRIPLECAMP
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.type = 14
SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD.cpp_type = 8
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.name = "isrelax"
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd.isrelax"
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.number = 7
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.index = 6
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.label = 1
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.has_default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.default_value = false
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.type = 8
SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD.cpp_type = 7
SYNCTRIPLEFIREINFOFUBENCMD.name = "SyncTripleFireInfoFuBenCmd"
SYNCTRIPLEFIREINFOFUBENCMD.full_name = ".Cmd.SyncTripleFireInfoFuBenCmd"
SYNCTRIPLEFIREINFOFUBENCMD.nested_types = {}
SYNCTRIPLEFIREINFOFUBENCMD.enum_types = {}
SYNCTRIPLEFIREINFOFUBENCMD.fields = {
  SYNCTRIPLEFIREINFOFUBENCMD_CMD_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_PARAM_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_CAMPS_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_MVPUSERINFO_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_ISFINISH_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_WINCAMP_FIELD,
  SYNCTRIPLEFIREINFOFUBENCMD_ISRELAX_FIELD
}
SYNCTRIPLEFIREINFOFUBENCMD.is_extendable = false
SYNCTRIPLEFIREINFOFUBENCMD.extensions = {}
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleComboKillFuBenCmd.cmd"
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleComboKillFuBenCmd.param"
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.default_value = 147
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.name = "killerinfo"
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.full_name = ".Cmd.SyncTripleComboKillFuBenCmd.killerinfo"
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.number = 3
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.index = 2
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.label = 1
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.has_default_value = false
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.default_value = nil
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.message_type = TRIPLECOMBODATA
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.type = 11
SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD.cpp_type = 10
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.name = "sufferinfo"
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.full_name = ".Cmd.SyncTripleComboKillFuBenCmd.sufferinfo"
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.number = 4
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.index = 3
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.label = 1
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.has_default_value = false
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.default_value = nil
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.message_type = TRIPLECOMBODATA
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.type = 11
SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD.cpp_type = 10
SYNCTRIPLECOMBOKILLFUBENCMD.name = "SyncTripleComboKillFuBenCmd"
SYNCTRIPLECOMBOKILLFUBENCMD.full_name = ".Cmd.SyncTripleComboKillFuBenCmd"
SYNCTRIPLECOMBOKILLFUBENCMD.nested_types = {}
SYNCTRIPLECOMBOKILLFUBENCMD.enum_types = {}
SYNCTRIPLECOMBOKILLFUBENCMD.fields = {
  SYNCTRIPLECOMBOKILLFUBENCMD_CMD_FIELD,
  SYNCTRIPLECOMBOKILLFUBENCMD_PARAM_FIELD,
  SYNCTRIPLECOMBOKILLFUBENCMD_KILLERINFO_FIELD,
  SYNCTRIPLECOMBOKILLFUBENCMD_SUFFERINFO_FIELD
}
SYNCTRIPLECOMBOKILLFUBENCMD.is_extendable = false
SYNCTRIPLECOMBOKILLFUBENCMD.extensions = {}
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTriplePlayerModelFuBenCmd.cmd"
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTriplePlayerModelFuBenCmd.param"
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.default_value = 148
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.name = "myteam"
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.full_name = ".Cmd.SyncTriplePlayerModelFuBenCmd.myteam"
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.number = 3
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.index = 2
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.label = 1
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.has_default_value = false
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.default_value = nil
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.message_type = TRIPLEMODELDATA
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.type = 11
SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD.cpp_type = 10
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.name = "otherteams"
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.full_name = ".Cmd.SyncTriplePlayerModelFuBenCmd.otherteams"
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.number = 4
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.index = 3
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.label = 3
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.has_default_value = false
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.default_value = {}
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.message_type = TRIPLEMODELDATA
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.type = 11
SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD.cpp_type = 10
SYNCTRIPLEPLAYERMODELFUBENCMD.name = "SyncTriplePlayerModelFuBenCmd"
SYNCTRIPLEPLAYERMODELFUBENCMD.full_name = ".Cmd.SyncTriplePlayerModelFuBenCmd"
SYNCTRIPLEPLAYERMODELFUBENCMD.nested_types = {}
SYNCTRIPLEPLAYERMODELFUBENCMD.enum_types = {}
SYNCTRIPLEPLAYERMODELFUBENCMD.fields = {
  SYNCTRIPLEPLAYERMODELFUBENCMD_CMD_FIELD,
  SYNCTRIPLEPLAYERMODELFUBENCMD_PARAM_FIELD,
  SYNCTRIPLEPLAYERMODELFUBENCMD_MYTEAM_FIELD,
  SYNCTRIPLEPLAYERMODELFUBENCMD_OTHERTEAMS_FIELD
}
SYNCTRIPLEPLAYERMODELFUBENCMD.is_extendable = false
SYNCTRIPLEPLAYERMODELFUBENCMD.extensions = {}
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.cmd"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.param"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.default_value = 149
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.name = "phase_end_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.phase_end_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.number = 3
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.index = 2
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.has_default_value = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.default_value = 0
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.type = 13
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD.cpp_type = 3
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.name = "close"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.close"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.number = 4
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.index = 3
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.has_default_value = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.default_value = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.type = 8
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD.cpp_type = 7
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.name = "profession_begin_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.profession_begin_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.number = 5
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.index = 4
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.has_default_value = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.default_value = 0
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.type = 13
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD.cpp_type = 3
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.name = "fire_begin_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd.fire_begin_time"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.number = 6
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.index = 5
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.label = 1
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.has_default_value = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.default_value = 0
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.type = 13
SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD.cpp_type = 3
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.name = "SyncTripleProfessionTimeFuBenCmd"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.full_name = ".Cmd.SyncTripleProfessionTimeFuBenCmd"
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.nested_types = {}
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.enum_types = {}
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.fields = {
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CMD_FIELD,
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PARAM_FIELD,
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PHASE_END_TIME_FIELD,
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_CLOSE_FIELD,
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_PROFESSION_BEGIN_TIME_FIELD,
  SYNCTRIPLEPROFESSIONTIMEFUBENCMD_FIRE_BEGIN_TIME_FIELD
}
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.is_extendable = false
SYNCTRIPLEPROFESSIONTIMEFUBENCMD.extensions = {}
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd.cmd"
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd.param"
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.default_value = 150
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.name = "camps"
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd.camps"
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.number = 3
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.index = 2
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.label = 3
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.has_default_value = false
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.default_value = {}
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.message_type = TRIPLECAMPDATA
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.type = 11
SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD.cpp_type = 10
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.name = "endtime"
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd.endtime"
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.number = 4
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.index = 3
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.label = 1
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.has_default_value = false
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.default_value = 0
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.type = 13
SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD.cpp_type = 3
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.name = "isrelax"
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd.isrelax"
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.number = 5
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.index = 4
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.label = 1
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.has_default_value = false
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.default_value = false
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.type = 8
SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD.cpp_type = 7
SYNCTRIPLECAMPINFOFUBENCMD.name = "SyncTripleCampInfoFuBenCmd"
SYNCTRIPLECAMPINFOFUBENCMD.full_name = ".Cmd.SyncTripleCampInfoFuBenCmd"
SYNCTRIPLECAMPINFOFUBENCMD.nested_types = {}
SYNCTRIPLECAMPINFOFUBENCMD.enum_types = {}
SYNCTRIPLECAMPINFOFUBENCMD.fields = {
  SYNCTRIPLECAMPINFOFUBENCMD_CMD_FIELD,
  SYNCTRIPLECAMPINFOFUBENCMD_PARAM_FIELD,
  SYNCTRIPLECAMPINFOFUBENCMD_CAMPS_FIELD,
  SYNCTRIPLECAMPINFOFUBENCMD_ENDTIME_FIELD,
  SYNCTRIPLECAMPINFOFUBENCMD_ISRELAX_FIELD
}
SYNCTRIPLECAMPINFOFUBENCMD.is_extendable = false
SYNCTRIPLECAMPINFOFUBENCMD.extensions = {}
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleEnterCountFuBenCmd.cmd"
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleEnterCountFuBenCmd.param"
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.default_value = 151
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.name = "datas"
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.full_name = ".Cmd.SyncTripleEnterCountFuBenCmd.datas"
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.number = 3
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.index = 2
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.label = 3
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.has_default_value = false
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.default_value = {}
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.message_type = ProtoCommon_pb.USERPORTRAITDATA
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.type = 11
SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD.cpp_type = 10
SYNCTRIPLEENTERCOUNTFUBENCMD.name = "SyncTripleEnterCountFuBenCmd"
SYNCTRIPLEENTERCOUNTFUBENCMD.full_name = ".Cmd.SyncTripleEnterCountFuBenCmd"
SYNCTRIPLEENTERCOUNTFUBENCMD.nested_types = {}
SYNCTRIPLEENTERCOUNTFUBENCMD.enum_types = {}
SYNCTRIPLEENTERCOUNTFUBENCMD.fields = {
  SYNCTRIPLEENTERCOUNTFUBENCMD_CMD_FIELD,
  SYNCTRIPLEENTERCOUNTFUBENCMD_PARAM_FIELD,
  SYNCTRIPLEENTERCOUNTFUBENCMD_DATAS_FIELD
}
SYNCTRIPLEENTERCOUNTFUBENCMD.is_extendable = false
SYNCTRIPLEENTERCOUNTFUBENCMD.extensions = {}
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.name = "cmd"
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.full_name = ".Cmd.ChooseCurProfessionFuBenCmd.cmd"
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.number = 1
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.index = 0
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.label = 1
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.has_default_value = true
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.default_value = 11
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.type = 14
CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD.cpp_type = 8
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.name = "param"
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.full_name = ".Cmd.ChooseCurProfessionFuBenCmd.param"
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.number = 2
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.index = 1
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.label = 1
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.has_default_value = true
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.default_value = 153
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.type = 14
CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD.cpp_type = 8
CHOOSECURPROFESSIONFUBENCMD.name = "ChooseCurProfessionFuBenCmd"
CHOOSECURPROFESSIONFUBENCMD.full_name = ".Cmd.ChooseCurProfessionFuBenCmd"
CHOOSECURPROFESSIONFUBENCMD.nested_types = {}
CHOOSECURPROFESSIONFUBENCMD.enum_types = {}
CHOOSECURPROFESSIONFUBENCMD.fields = {
  CHOOSECURPROFESSIONFUBENCMD_CMD_FIELD,
  CHOOSECURPROFESSIONFUBENCMD_PARAM_FIELD
}
CHOOSECURPROFESSIONFUBENCMD.is_extendable = false
CHOOSECURPROFESSIONFUBENCMD.extensions = {}
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncTripleFightingInfoFuBenCmd.cmd"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.number = 1
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.index = 0
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.label = 1
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.type = 14
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncTripleFightingInfoFuBenCmd.param"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.default_value = 154
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.name = "camps"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.full_name = ".Cmd.SyncTripleFightingInfoFuBenCmd.camps"
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.number = 3
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.index = 2
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.label = 3
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.has_default_value = false
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.default_value = {}
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.message_type = TRIPLECAMPDATA
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.type = 11
SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD.cpp_type = 10
SYNCTRIPLEFIGHTINGINFOFUBENCMD.name = "SyncTripleFightingInfoFuBenCmd"
SYNCTRIPLEFIGHTINGINFOFUBENCMD.full_name = ".Cmd.SyncTripleFightingInfoFuBenCmd"
SYNCTRIPLEFIGHTINGINFOFUBENCMD.nested_types = {}
SYNCTRIPLEFIGHTINGINFOFUBENCMD.enum_types = {}
SYNCTRIPLEFIGHTINGINFOFUBENCMD.fields = {
  SYNCTRIPLEFIGHTINGINFOFUBENCMD_CMD_FIELD,
  SYNCTRIPLEFIGHTINGINFOFUBENCMD_PARAM_FIELD,
  SYNCTRIPLEFIGHTINGINFOFUBENCMD_CAMPS_FIELD
}
SYNCTRIPLEFIGHTINGINFOFUBENCMD.is_extendable = false
SYNCTRIPLEFIGHTINGINFOFUBENCMD.extensions = {}
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.name = "cmd"
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncFullFireStateFubenCmd.cmd"
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.number = 1
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.index = 0
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.label = 1
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.has_default_value = true
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.default_value = 11
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.type = 14
SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.name = "param"
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncFullFireStateFubenCmd.param"
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.number = 2
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.index = 1
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.label = 1
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.default_value = 155
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.type = 14
SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.name = "fullfire"
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.full_name = ".Cmd.SyncFullFireStateFubenCmd.fullfire"
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.number = 3
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.index = 2
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.label = 1
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.has_default_value = false
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.default_value = false
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.type = 8
SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD.cpp_type = 7
SYNCFULLFIRESTATEFUBENCMD.name = "SyncFullFireStateFubenCmd"
SYNCFULLFIRESTATEFUBENCMD.full_name = ".Cmd.SyncFullFireStateFubenCmd"
SYNCFULLFIRESTATEFUBENCMD.nested_types = {}
SYNCFULLFIRESTATEFUBENCMD.enum_types = {}
SYNCFULLFIRESTATEFUBENCMD.fields = {
  SYNCFULLFIRESTATEFUBENCMD_CMD_FIELD,
  SYNCFULLFIRESTATEFUBENCMD_PARAM_FIELD,
  SYNCFULLFIRESTATEFUBENCMD_FULLFIRE_FIELD
}
SYNCFULLFIRESTATEFUBENCMD.is_extendable = false
SYNCFULLFIRESTATEFUBENCMD.extensions = {}
EBFEVENTDATA_ID_FIELD.name = "id"
EBFEVENTDATA_ID_FIELD.full_name = ".Cmd.EBFEventData.id"
EBFEVENTDATA_ID_FIELD.number = 1
EBFEVENTDATA_ID_FIELD.index = 0
EBFEVENTDATA_ID_FIELD.label = 1
EBFEVENTDATA_ID_FIELD.has_default_value = false
EBFEVENTDATA_ID_FIELD.default_value = 0
EBFEVENTDATA_ID_FIELD.type = 13
EBFEVENTDATA_ID_FIELD.cpp_type = 3
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.name = "event_param_human"
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.full_name = ".Cmd.EBFEventData.event_param_human"
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.number = 2
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.index = 1
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.label = 1
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.has_default_value = false
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.default_value = 0
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.type = 3
EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD.cpp_type = 2
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.name = "event_param_vampire"
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.full_name = ".Cmd.EBFEventData.event_param_vampire"
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.number = 3
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.index = 2
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.label = 1
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.has_default_value = false
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.default_value = 0
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.type = 3
EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD.cpp_type = 2
EBFEVENTDATA_START_TIME_FIELD.name = "start_time"
EBFEVENTDATA_START_TIME_FIELD.full_name = ".Cmd.EBFEventData.start_time"
EBFEVENTDATA_START_TIME_FIELD.number = 4
EBFEVENTDATA_START_TIME_FIELD.index = 3
EBFEVENTDATA_START_TIME_FIELD.label = 1
EBFEVENTDATA_START_TIME_FIELD.has_default_value = false
EBFEVENTDATA_START_TIME_FIELD.default_value = 0
EBFEVENTDATA_START_TIME_FIELD.type = 13
EBFEVENTDATA_START_TIME_FIELD.cpp_type = 3
EBFEVENTDATA_IS_END_FIELD.name = "is_end"
EBFEVENTDATA_IS_END_FIELD.full_name = ".Cmd.EBFEventData.is_end"
EBFEVENTDATA_IS_END_FIELD.number = 5
EBFEVENTDATA_IS_END_FIELD.index = 4
EBFEVENTDATA_IS_END_FIELD.label = 1
EBFEVENTDATA_IS_END_FIELD.has_default_value = false
EBFEVENTDATA_IS_END_FIELD.default_value = false
EBFEVENTDATA_IS_END_FIELD.type = 8
EBFEVENTDATA_IS_END_FIELD.cpp_type = 7
EBFEVENTDATA_WINNER_FIELD.name = "winner"
EBFEVENTDATA_WINNER_FIELD.full_name = ".Cmd.EBFEventData.winner"
EBFEVENTDATA_WINNER_FIELD.number = 6
EBFEVENTDATA_WINNER_FIELD.index = 5
EBFEVENTDATA_WINNER_FIELD.label = 1
EBFEVENTDATA_WINNER_FIELD.has_default_value = false
EBFEVENTDATA_WINNER_FIELD.default_value = nil
EBFEVENTDATA_WINNER_FIELD.enum_type = ETEAMPWSCOLOR
EBFEVENTDATA_WINNER_FIELD.type = 14
EBFEVENTDATA_WINNER_FIELD.cpp_type = 8
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.name = "next_summon_time"
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.full_name = ".Cmd.EBFEventData.next_summon_time"
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.number = 7
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.index = 6
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.label = 1
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.has_default_value = false
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.default_value = 0
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.type = 13
EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD.cpp_type = 3
EBFEVENTDATA.name = "EBFEventData"
EBFEVENTDATA.full_name = ".Cmd.EBFEventData"
EBFEVENTDATA.nested_types = {}
EBFEVENTDATA.enum_types = {}
EBFEVENTDATA.fields = {
  EBFEVENTDATA_ID_FIELD,
  EBFEVENTDATA_EVENT_PARAM_HUMAN_FIELD,
  EBFEVENTDATA_EVENT_PARAM_VAMPIRE_FIELD,
  EBFEVENTDATA_START_TIME_FIELD,
  EBFEVENTDATA_IS_END_FIELD,
  EBFEVENTDATA_WINNER_FIELD,
  EBFEVENTDATA_NEXT_SUMMON_TIME_FIELD
}
EBFEVENTDATA.is_extendable = false
EBFEVENTDATA.extensions = {}
EBFEVENTDATAUPDATECMD_CMD_FIELD.name = "cmd"
EBFEVENTDATAUPDATECMD_CMD_FIELD.full_name = ".Cmd.EBFEventDataUpdateCmd.cmd"
EBFEVENTDATAUPDATECMD_CMD_FIELD.number = 1
EBFEVENTDATAUPDATECMD_CMD_FIELD.index = 0
EBFEVENTDATAUPDATECMD_CMD_FIELD.label = 1
EBFEVENTDATAUPDATECMD_CMD_FIELD.has_default_value = true
EBFEVENTDATAUPDATECMD_CMD_FIELD.default_value = 11
EBFEVENTDATAUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EBFEVENTDATAUPDATECMD_CMD_FIELD.type = 14
EBFEVENTDATAUPDATECMD_CMD_FIELD.cpp_type = 8
EBFEVENTDATAUPDATECMD_PARAM_FIELD.name = "param"
EBFEVENTDATAUPDATECMD_PARAM_FIELD.full_name = ".Cmd.EBFEventDataUpdateCmd.param"
EBFEVENTDATAUPDATECMD_PARAM_FIELD.number = 2
EBFEVENTDATAUPDATECMD_PARAM_FIELD.index = 1
EBFEVENTDATAUPDATECMD_PARAM_FIELD.label = 1
EBFEVENTDATAUPDATECMD_PARAM_FIELD.has_default_value = true
EBFEVENTDATAUPDATECMD_PARAM_FIELD.default_value = 156
EBFEVENTDATAUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
EBFEVENTDATAUPDATECMD_PARAM_FIELD.type = 14
EBFEVENTDATAUPDATECMD_PARAM_FIELD.cpp_type = 8
EBFEVENTDATAUPDATECMD_DATAS_FIELD.name = "datas"
EBFEVENTDATAUPDATECMD_DATAS_FIELD.full_name = ".Cmd.EBFEventDataUpdateCmd.datas"
EBFEVENTDATAUPDATECMD_DATAS_FIELD.number = 3
EBFEVENTDATAUPDATECMD_DATAS_FIELD.index = 2
EBFEVENTDATAUPDATECMD_DATAS_FIELD.label = 3
EBFEVENTDATAUPDATECMD_DATAS_FIELD.has_default_value = false
EBFEVENTDATAUPDATECMD_DATAS_FIELD.default_value = {}
EBFEVENTDATAUPDATECMD_DATAS_FIELD.message_type = EBFEVENTDATA
EBFEVENTDATAUPDATECMD_DATAS_FIELD.type = 11
EBFEVENTDATAUPDATECMD_DATAS_FIELD.cpp_type = 10
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.name = "all_sync"
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.full_name = ".Cmd.EBFEventDataUpdateCmd.all_sync"
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.number = 4
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.index = 3
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.label = 1
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.has_default_value = false
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.default_value = false
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.type = 8
EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD.cpp_type = 7
EBFEVENTDATAUPDATECMD.name = "EBFEventDataUpdateCmd"
EBFEVENTDATAUPDATECMD.full_name = ".Cmd.EBFEventDataUpdateCmd"
EBFEVENTDATAUPDATECMD.nested_types = {}
EBFEVENTDATAUPDATECMD.enum_types = {}
EBFEVENTDATAUPDATECMD.fields = {
  EBFEVENTDATAUPDATECMD_CMD_FIELD,
  EBFEVENTDATAUPDATECMD_PARAM_FIELD,
  EBFEVENTDATAUPDATECMD_DATAS_FIELD,
  EBFEVENTDATAUPDATECMD_ALL_SYNC_FIELD
}
EBFEVENTDATAUPDATECMD.is_extendable = false
EBFEVENTDATAUPDATECMD.extensions = {}
EBFMISCDATAUPDATE_CMD_FIELD.name = "cmd"
EBFMISCDATAUPDATE_CMD_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.cmd"
EBFMISCDATAUPDATE_CMD_FIELD.number = 1
EBFMISCDATAUPDATE_CMD_FIELD.index = 0
EBFMISCDATAUPDATE_CMD_FIELD.label = 1
EBFMISCDATAUPDATE_CMD_FIELD.has_default_value = true
EBFMISCDATAUPDATE_CMD_FIELD.default_value = 11
EBFMISCDATAUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EBFMISCDATAUPDATE_CMD_FIELD.type = 14
EBFMISCDATAUPDATE_CMD_FIELD.cpp_type = 8
EBFMISCDATAUPDATE_PARAM_FIELD.name = "param"
EBFMISCDATAUPDATE_PARAM_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.param"
EBFMISCDATAUPDATE_PARAM_FIELD.number = 2
EBFMISCDATAUPDATE_PARAM_FIELD.index = 1
EBFMISCDATAUPDATE_PARAM_FIELD.label = 1
EBFMISCDATAUPDATE_PARAM_FIELD.has_default_value = true
EBFMISCDATAUPDATE_PARAM_FIELD.default_value = 157
EBFMISCDATAUPDATE_PARAM_FIELD.enum_type = FUBENPARAM
EBFMISCDATAUPDATE_PARAM_FIELD.type = 14
EBFMISCDATAUPDATE_PARAM_FIELD.cpp_type = 8
EBFMISCDATAUPDATE_STATE_FIELD.name = "state"
EBFMISCDATAUPDATE_STATE_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.state"
EBFMISCDATAUPDATE_STATE_FIELD.number = 3
EBFMISCDATAUPDATE_STATE_FIELD.index = 2
EBFMISCDATAUPDATE_STATE_FIELD.label = 1
EBFMISCDATAUPDATE_STATE_FIELD.has_default_value = false
EBFMISCDATAUPDATE_STATE_FIELD.default_value = nil
EBFMISCDATAUPDATE_STATE_FIELD.enum_type = EEBFFIELDSTATE
EBFMISCDATAUPDATE_STATE_FIELD.type = 14
EBFMISCDATAUPDATE_STATE_FIELD.cpp_type = 8
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.name = "next_event_time"
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.next_event_time"
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.number = 4
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.index = 3
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.label = 1
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.has_default_value = false
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.default_value = 0
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.type = 13
EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD.cpp_type = 3
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.name = "next_event_id"
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.next_event_id"
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.number = 7
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.index = 4
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.label = 1
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.has_default_value = false
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.default_value = 0
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.type = 13
EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD.cpp_type = 3
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.name = "score_human"
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.score_human"
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.number = 5
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.index = 5
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.label = 1
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.has_default_value = false
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.default_value = 0
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.type = 13
EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD.cpp_type = 3
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.name = "score_vampire"
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.full_name = ".Cmd.EBFMiscDataUpdate.score_vampire"
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.number = 6
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.index = 6
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.label = 1
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.has_default_value = false
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.default_value = 0
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.type = 13
EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD.cpp_type = 3
EBFMISCDATAUPDATE.name = "EBFMiscDataUpdate"
EBFMISCDATAUPDATE.full_name = ".Cmd.EBFMiscDataUpdate"
EBFMISCDATAUPDATE.nested_types = {}
EBFMISCDATAUPDATE.enum_types = {}
EBFMISCDATAUPDATE.fields = {
  EBFMISCDATAUPDATE_CMD_FIELD,
  EBFMISCDATAUPDATE_PARAM_FIELD,
  EBFMISCDATAUPDATE_STATE_FIELD,
  EBFMISCDATAUPDATE_NEXT_EVENT_TIME_FIELD,
  EBFMISCDATAUPDATE_NEXT_EVENT_ID_FIELD,
  EBFMISCDATAUPDATE_SCORE_HUMAN_FIELD,
  EBFMISCDATAUPDATE_SCORE_VAMPIRE_FIELD
}
EBFMISCDATAUPDATE.is_extendable = false
EBFMISCDATAUPDATE.extensions = {}
OCCUPYPOINTDATA_POINT_ID_FIELD.name = "point_id"
OCCUPYPOINTDATA_POINT_ID_FIELD.full_name = ".Cmd.OccupyPointData.point_id"
OCCUPYPOINTDATA_POINT_ID_FIELD.number = 1
OCCUPYPOINTDATA_POINT_ID_FIELD.index = 0
OCCUPYPOINTDATA_POINT_ID_FIELD.label = 1
OCCUPYPOINTDATA_POINT_ID_FIELD.has_default_value = false
OCCUPYPOINTDATA_POINT_ID_FIELD.default_value = 0
OCCUPYPOINTDATA_POINT_ID_FIELD.type = 13
OCCUPYPOINTDATA_POINT_ID_FIELD.cpp_type = 3
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.name = "occupying_camp"
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.full_name = ".Cmd.OccupyPointData.occupying_camp"
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.number = 2
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.index = 1
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.label = 1
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.has_default_value = false
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.default_value = 0
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.type = 13
OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD.cpp_type = 3
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.name = "cur_occupy_score"
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.full_name = ".Cmd.OccupyPointData.cur_occupy_score"
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.number = 3
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.index = 2
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.label = 1
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.has_default_value = false
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.default_value = 0
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.type = 13
OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD.cpp_type = 3
OCCUPYPOINTDATA_OCCUPIED_FIELD.name = "occupied"
OCCUPYPOINTDATA_OCCUPIED_FIELD.full_name = ".Cmd.OccupyPointData.occupied"
OCCUPYPOINTDATA_OCCUPIED_FIELD.number = 4
OCCUPYPOINTDATA_OCCUPIED_FIELD.index = 3
OCCUPYPOINTDATA_OCCUPIED_FIELD.label = 1
OCCUPYPOINTDATA_OCCUPIED_FIELD.has_default_value = false
OCCUPYPOINTDATA_OCCUPIED_FIELD.default_value = false
OCCUPYPOINTDATA_OCCUPIED_FIELD.type = 8
OCCUPYPOINTDATA_OCCUPIED_FIELD.cpp_type = 7
OCCUPYPOINTDATA.name = "OccupyPointData"
OCCUPYPOINTDATA.full_name = ".Cmd.OccupyPointData"
OCCUPYPOINTDATA.nested_types = {}
OCCUPYPOINTDATA.enum_types = {}
OCCUPYPOINTDATA.fields = {
  OCCUPYPOINTDATA_POINT_ID_FIELD,
  OCCUPYPOINTDATA_OCCUPYING_CAMP_FIELD,
  OCCUPYPOINTDATA_CUR_OCCUPY_SCORE_FIELD,
  OCCUPYPOINTDATA_OCCUPIED_FIELD
}
OCCUPYPOINTDATA.is_extendable = false
OCCUPYPOINTDATA.extensions = {}
OCCUPYPOINTDATAUPDATE_CMD_FIELD.name = "cmd"
OCCUPYPOINTDATAUPDATE_CMD_FIELD.full_name = ".Cmd.OccupyPointDataUpdate.cmd"
OCCUPYPOINTDATAUPDATE_CMD_FIELD.number = 1
OCCUPYPOINTDATAUPDATE_CMD_FIELD.index = 0
OCCUPYPOINTDATAUPDATE_CMD_FIELD.label = 1
OCCUPYPOINTDATAUPDATE_CMD_FIELD.has_default_value = true
OCCUPYPOINTDATAUPDATE_CMD_FIELD.default_value = 11
OCCUPYPOINTDATAUPDATE_CMD_FIELD.enum_type = XCMD_PB_COMMAND
OCCUPYPOINTDATAUPDATE_CMD_FIELD.type = 14
OCCUPYPOINTDATAUPDATE_CMD_FIELD.cpp_type = 8
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.name = "param"
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.full_name = ".Cmd.OccupyPointDataUpdate.param"
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.number = 2
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.index = 1
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.label = 1
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.has_default_value = true
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.default_value = 158
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.enum_type = FUBENPARAM
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.type = 14
OCCUPYPOINTDATAUPDATE_PARAM_FIELD.cpp_type = 8
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.name = "update_datas"
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.full_name = ".Cmd.OccupyPointDataUpdate.update_datas"
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.number = 3
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.index = 2
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.label = 3
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.has_default_value = false
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.default_value = {}
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.message_type = OCCUPYPOINTDATA
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.type = 11
OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD.cpp_type = 10
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.name = "del_points"
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.full_name = ".Cmd.OccupyPointDataUpdate.del_points"
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.number = 4
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.index = 3
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.label = 3
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.has_default_value = false
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.default_value = {}
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.type = 13
OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD.cpp_type = 3
OCCUPYPOINTDATAUPDATE.name = "OccupyPointDataUpdate"
OCCUPYPOINTDATAUPDATE.full_name = ".Cmd.OccupyPointDataUpdate"
OCCUPYPOINTDATAUPDATE.nested_types = {}
OCCUPYPOINTDATAUPDATE.enum_types = {}
OCCUPYPOINTDATAUPDATE.fields = {
  OCCUPYPOINTDATAUPDATE_CMD_FIELD,
  OCCUPYPOINTDATAUPDATE_PARAM_FIELD,
  OCCUPYPOINTDATAUPDATE_UPDATE_DATAS_FIELD,
  OCCUPYPOINTDATAUPDATE_DEL_POINTS_FIELD
}
OCCUPYPOINTDATAUPDATE.is_extendable = false
OCCUPYPOINTDATAUPDATE.extensions = {}
PVPSTATDATA_CHARID_FIELD.name = "charid"
PVPSTATDATA_CHARID_FIELD.full_name = ".Cmd.PvpStatData.charid"
PVPSTATDATA_CHARID_FIELD.number = 1
PVPSTATDATA_CHARID_FIELD.index = 0
PVPSTATDATA_CHARID_FIELD.label = 1
PVPSTATDATA_CHARID_FIELD.has_default_value = false
PVPSTATDATA_CHARID_FIELD.default_value = 0
PVPSTATDATA_CHARID_FIELD.type = 4
PVPSTATDATA_CHARID_FIELD.cpp_type = 4
PVPSTATDATA_USERNAME_FIELD.name = "username"
PVPSTATDATA_USERNAME_FIELD.full_name = ".Cmd.PvpStatData.username"
PVPSTATDATA_USERNAME_FIELD.number = 2
PVPSTATDATA_USERNAME_FIELD.index = 1
PVPSTATDATA_USERNAME_FIELD.label = 1
PVPSTATDATA_USERNAME_FIELD.has_default_value = false
PVPSTATDATA_USERNAME_FIELD.default_value = ""
PVPSTATDATA_USERNAME_FIELD.type = 9
PVPSTATDATA_USERNAME_FIELD.cpp_type = 9
PVPSTATDATA_PROFESSION_FIELD.name = "profession"
PVPSTATDATA_PROFESSION_FIELD.full_name = ".Cmd.PvpStatData.profession"
PVPSTATDATA_PROFESSION_FIELD.number = 3
PVPSTATDATA_PROFESSION_FIELD.index = 2
PVPSTATDATA_PROFESSION_FIELD.label = 1
PVPSTATDATA_PROFESSION_FIELD.has_default_value = false
PVPSTATDATA_PROFESSION_FIELD.default_value = nil
PVPSTATDATA_PROFESSION_FIELD.enum_type = PROTOCOMMON_PB_EPROFESSION
PVPSTATDATA_PROFESSION_FIELD.type = 14
PVPSTATDATA_PROFESSION_FIELD.cpp_type = 8
PVPSTATDATA_HEAL_FIELD.name = "heal"
PVPSTATDATA_HEAL_FIELD.full_name = ".Cmd.PvpStatData.heal"
PVPSTATDATA_HEAL_FIELD.number = 4
PVPSTATDATA_HEAL_FIELD.index = 3
PVPSTATDATA_HEAL_FIELD.label = 1
PVPSTATDATA_HEAL_FIELD.has_default_value = false
PVPSTATDATA_HEAL_FIELD.default_value = 0
PVPSTATDATA_HEAL_FIELD.type = 13
PVPSTATDATA_HEAL_FIELD.cpp_type = 3
PVPSTATDATA_KILL_FIELD.name = "kill"
PVPSTATDATA_KILL_FIELD.full_name = ".Cmd.PvpStatData.kill"
PVPSTATDATA_KILL_FIELD.number = 5
PVPSTATDATA_KILL_FIELD.index = 4
PVPSTATDATA_KILL_FIELD.label = 1
PVPSTATDATA_KILL_FIELD.has_default_value = false
PVPSTATDATA_KILL_FIELD.default_value = 0
PVPSTATDATA_KILL_FIELD.type = 13
PVPSTATDATA_KILL_FIELD.cpp_type = 3
PVPSTATDATA_DEATH_FIELD.name = "death"
PVPSTATDATA_DEATH_FIELD.full_name = ".Cmd.PvpStatData.death"
PVPSTATDATA_DEATH_FIELD.number = 6
PVPSTATDATA_DEATH_FIELD.index = 5
PVPSTATDATA_DEATH_FIELD.label = 1
PVPSTATDATA_DEATH_FIELD.has_default_value = false
PVPSTATDATA_DEATH_FIELD.default_value = 0
PVPSTATDATA_DEATH_FIELD.type = 13
PVPSTATDATA_DEATH_FIELD.cpp_type = 3
PVPSTATDATA_ASSIST_FIELD.name = "assist"
PVPSTATDATA_ASSIST_FIELD.full_name = ".Cmd.PvpStatData.assist"
PVPSTATDATA_ASSIST_FIELD.number = 7
PVPSTATDATA_ASSIST_FIELD.index = 6
PVPSTATDATA_ASSIST_FIELD.label = 1
PVPSTATDATA_ASSIST_FIELD.has_default_value = false
PVPSTATDATA_ASSIST_FIELD.default_value = 0
PVPSTATDATA_ASSIST_FIELD.type = 13
PVPSTATDATA_ASSIST_FIELD.cpp_type = 3
PVPSTATDATA_DAMAGE_USER_FIELD.name = "damage_user"
PVPSTATDATA_DAMAGE_USER_FIELD.full_name = ".Cmd.PvpStatData.damage_user"
PVPSTATDATA_DAMAGE_USER_FIELD.number = 8
PVPSTATDATA_DAMAGE_USER_FIELD.index = 7
PVPSTATDATA_DAMAGE_USER_FIELD.label = 1
PVPSTATDATA_DAMAGE_USER_FIELD.has_default_value = false
PVPSTATDATA_DAMAGE_USER_FIELD.default_value = 0
PVPSTATDATA_DAMAGE_USER_FIELD.type = 13
PVPSTATDATA_DAMAGE_USER_FIELD.cpp_type = 3
PVPSTATDATA_DAMAGE_NPC_FIELD.name = "damage_npc"
PVPSTATDATA_DAMAGE_NPC_FIELD.full_name = ".Cmd.PvpStatData.damage_npc"
PVPSTATDATA_DAMAGE_NPC_FIELD.number = 9
PVPSTATDATA_DAMAGE_NPC_FIELD.index = 8
PVPSTATDATA_DAMAGE_NPC_FIELD.label = 1
PVPSTATDATA_DAMAGE_NPC_FIELD.has_default_value = false
PVPSTATDATA_DAMAGE_NPC_FIELD.default_value = 0
PVPSTATDATA_DAMAGE_NPC_FIELD.type = 13
PVPSTATDATA_DAMAGE_NPC_FIELD.cpp_type = 3
PVPSTATDATA_CAMP_FIELD.name = "camp"
PVPSTATDATA_CAMP_FIELD.full_name = ".Cmd.PvpStatData.camp"
PVPSTATDATA_CAMP_FIELD.number = 10
PVPSTATDATA_CAMP_FIELD.index = 9
PVPSTATDATA_CAMP_FIELD.label = 1
PVPSTATDATA_CAMP_FIELD.has_default_value = false
PVPSTATDATA_CAMP_FIELD.default_value = 0
PVPSTATDATA_CAMP_FIELD.type = 13
PVPSTATDATA_CAMP_FIELD.cpp_type = 3
PVPSTATDATA.name = "PvpStatData"
PVPSTATDATA.full_name = ".Cmd.PvpStatData"
PVPSTATDATA.nested_types = {}
PVPSTATDATA.enum_types = {}
PVPSTATDATA.fields = {
  PVPSTATDATA_CHARID_FIELD,
  PVPSTATDATA_USERNAME_FIELD,
  PVPSTATDATA_PROFESSION_FIELD,
  PVPSTATDATA_HEAL_FIELD,
  PVPSTATDATA_KILL_FIELD,
  PVPSTATDATA_DEATH_FIELD,
  PVPSTATDATA_ASSIST_FIELD,
  PVPSTATDATA_DAMAGE_USER_FIELD,
  PVPSTATDATA_DAMAGE_NPC_FIELD,
  PVPSTATDATA_CAMP_FIELD
}
PVPSTATDATA.is_extendable = false
PVPSTATDATA.extensions = {}
QUERYPVPSTATCMD_CMD_FIELD.name = "cmd"
QUERYPVPSTATCMD_CMD_FIELD.full_name = ".Cmd.QueryPvpStatCmd.cmd"
QUERYPVPSTATCMD_CMD_FIELD.number = 1
QUERYPVPSTATCMD_CMD_FIELD.index = 0
QUERYPVPSTATCMD_CMD_FIELD.label = 1
QUERYPVPSTATCMD_CMD_FIELD.has_default_value = true
QUERYPVPSTATCMD_CMD_FIELD.default_value = 11
QUERYPVPSTATCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
QUERYPVPSTATCMD_CMD_FIELD.type = 14
QUERYPVPSTATCMD_CMD_FIELD.cpp_type = 8
QUERYPVPSTATCMD_PARAM_FIELD.name = "param"
QUERYPVPSTATCMD_PARAM_FIELD.full_name = ".Cmd.QueryPvpStatCmd.param"
QUERYPVPSTATCMD_PARAM_FIELD.number = 2
QUERYPVPSTATCMD_PARAM_FIELD.index = 1
QUERYPVPSTATCMD_PARAM_FIELD.label = 1
QUERYPVPSTATCMD_PARAM_FIELD.has_default_value = true
QUERYPVPSTATCMD_PARAM_FIELD.default_value = 159
QUERYPVPSTATCMD_PARAM_FIELD.enum_type = FUBENPARAM
QUERYPVPSTATCMD_PARAM_FIELD.type = 14
QUERYPVPSTATCMD_PARAM_FIELD.cpp_type = 8
QUERYPVPSTATCMD_STATS_FIELD.name = "stats"
QUERYPVPSTATCMD_STATS_FIELD.full_name = ".Cmd.QueryPvpStatCmd.stats"
QUERYPVPSTATCMD_STATS_FIELD.number = 3
QUERYPVPSTATCMD_STATS_FIELD.index = 2
QUERYPVPSTATCMD_STATS_FIELD.label = 3
QUERYPVPSTATCMD_STATS_FIELD.has_default_value = false
QUERYPVPSTATCMD_STATS_FIELD.default_value = {}
QUERYPVPSTATCMD_STATS_FIELD.message_type = PVPSTATDATA
QUERYPVPSTATCMD_STATS_FIELD.type = 11
QUERYPVPSTATCMD_STATS_FIELD.cpp_type = 10
QUERYPVPSTATCMD.name = "QueryPvpStatCmd"
QUERYPVPSTATCMD.full_name = ".Cmd.QueryPvpStatCmd"
QUERYPVPSTATCMD.nested_types = {}
QUERYPVPSTATCMD.enum_types = {}
QUERYPVPSTATCMD.fields = {
  QUERYPVPSTATCMD_CMD_FIELD,
  QUERYPVPSTATCMD_PARAM_FIELD,
  QUERYPVPSTATCMD_STATS_FIELD
}
QUERYPVPSTATCMD.is_extendable = false
QUERYPVPSTATCMD.extensions = {}
EBFKICKTIMECMD_CMD_FIELD.name = "cmd"
EBFKICKTIMECMD_CMD_FIELD.full_name = ".Cmd.EBFKickTimeCmd.cmd"
EBFKICKTIMECMD_CMD_FIELD.number = 1
EBFKICKTIMECMD_CMD_FIELD.index = 0
EBFKICKTIMECMD_CMD_FIELD.label = 1
EBFKICKTIMECMD_CMD_FIELD.has_default_value = true
EBFKICKTIMECMD_CMD_FIELD.default_value = 11
EBFKICKTIMECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EBFKICKTIMECMD_CMD_FIELD.type = 14
EBFKICKTIMECMD_CMD_FIELD.cpp_type = 8
EBFKICKTIMECMD_PARAM_FIELD.name = "param"
EBFKICKTIMECMD_PARAM_FIELD.full_name = ".Cmd.EBFKickTimeCmd.param"
EBFKICKTIMECMD_PARAM_FIELD.number = 2
EBFKICKTIMECMD_PARAM_FIELD.index = 1
EBFKICKTIMECMD_PARAM_FIELD.label = 1
EBFKICKTIMECMD_PARAM_FIELD.has_default_value = true
EBFKICKTIMECMD_PARAM_FIELD.default_value = 160
EBFKICKTIMECMD_PARAM_FIELD.enum_type = FUBENPARAM
EBFKICKTIMECMD_PARAM_FIELD.type = 14
EBFKICKTIMECMD_PARAM_FIELD.cpp_type = 8
EBFKICKTIMECMD_KICK_TIME_FIELD.name = "kick_time"
EBFKICKTIMECMD_KICK_TIME_FIELD.full_name = ".Cmd.EBFKickTimeCmd.kick_time"
EBFKICKTIMECMD_KICK_TIME_FIELD.number = 3
EBFKICKTIMECMD_KICK_TIME_FIELD.index = 2
EBFKICKTIMECMD_KICK_TIME_FIELD.label = 1
EBFKICKTIMECMD_KICK_TIME_FIELD.has_default_value = false
EBFKICKTIMECMD_KICK_TIME_FIELD.default_value = 0
EBFKICKTIMECMD_KICK_TIME_FIELD.type = 13
EBFKICKTIMECMD_KICK_TIME_FIELD.cpp_type = 3
EBFKICKTIMECMD.name = "EBFKickTimeCmd"
EBFKICKTIMECMD.full_name = ".Cmd.EBFKickTimeCmd"
EBFKICKTIMECMD.nested_types = {}
EBFKICKTIMECMD.enum_types = {}
EBFKICKTIMECMD.fields = {
  EBFKICKTIMECMD_CMD_FIELD,
  EBFKICKTIMECMD_PARAM_FIELD,
  EBFKICKTIMECMD_KICK_TIME_FIELD
}
EBFKICKTIMECMD.is_extendable = false
EBFKICKTIMECMD.extensions = {}
EBFCONTINUECMD_CMD_FIELD.name = "cmd"
EBFCONTINUECMD_CMD_FIELD.full_name = ".Cmd.EBFContinueCmd.cmd"
EBFCONTINUECMD_CMD_FIELD.number = 1
EBFCONTINUECMD_CMD_FIELD.index = 0
EBFCONTINUECMD_CMD_FIELD.label = 1
EBFCONTINUECMD_CMD_FIELD.has_default_value = true
EBFCONTINUECMD_CMD_FIELD.default_value = 11
EBFCONTINUECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EBFCONTINUECMD_CMD_FIELD.type = 14
EBFCONTINUECMD_CMD_FIELD.cpp_type = 8
EBFCONTINUECMD_PARAM_FIELD.name = "param"
EBFCONTINUECMD_PARAM_FIELD.full_name = ".Cmd.EBFContinueCmd.param"
EBFCONTINUECMD_PARAM_FIELD.number = 2
EBFCONTINUECMD_PARAM_FIELD.index = 1
EBFCONTINUECMD_PARAM_FIELD.label = 1
EBFCONTINUECMD_PARAM_FIELD.has_default_value = true
EBFCONTINUECMD_PARAM_FIELD.default_value = 161
EBFCONTINUECMD_PARAM_FIELD.enum_type = FUBENPARAM
EBFCONTINUECMD_PARAM_FIELD.type = 14
EBFCONTINUECMD_PARAM_FIELD.cpp_type = 8
EBFCONTINUECMD.name = "EBFContinueCmd"
EBFCONTINUECMD.full_name = ".Cmd.EBFContinueCmd"
EBFCONTINUECMD.nested_types = {}
EBFCONTINUECMD.enum_types = {}
EBFCONTINUECMD.fields = {
  EBFCONTINUECMD_CMD_FIELD,
  EBFCONTINUECMD_PARAM_FIELD
}
EBFCONTINUECMD.is_extendable = false
EBFCONTINUECMD.extensions = {}
EBFEVENTAREAUPDATECMD_CMD_FIELD.name = "cmd"
EBFEVENTAREAUPDATECMD_CMD_FIELD.full_name = ".Cmd.EBFEventAreaUpdateCmd.cmd"
EBFEVENTAREAUPDATECMD_CMD_FIELD.number = 1
EBFEVENTAREAUPDATECMD_CMD_FIELD.index = 0
EBFEVENTAREAUPDATECMD_CMD_FIELD.label = 1
EBFEVENTAREAUPDATECMD_CMD_FIELD.has_default_value = true
EBFEVENTAREAUPDATECMD_CMD_FIELD.default_value = 11
EBFEVENTAREAUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
EBFEVENTAREAUPDATECMD_CMD_FIELD.type = 14
EBFEVENTAREAUPDATECMD_CMD_FIELD.cpp_type = 8
EBFEVENTAREAUPDATECMD_PARAM_FIELD.name = "param"
EBFEVENTAREAUPDATECMD_PARAM_FIELD.full_name = ".Cmd.EBFEventAreaUpdateCmd.param"
EBFEVENTAREAUPDATECMD_PARAM_FIELD.number = 2
EBFEVENTAREAUPDATECMD_PARAM_FIELD.index = 1
EBFEVENTAREAUPDATECMD_PARAM_FIELD.label = 1
EBFEVENTAREAUPDATECMD_PARAM_FIELD.has_default_value = true
EBFEVENTAREAUPDATECMD_PARAM_FIELD.default_value = 162
EBFEVENTAREAUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
EBFEVENTAREAUPDATECMD_PARAM_FIELD.type = 14
EBFEVENTAREAUPDATECMD_PARAM_FIELD.cpp_type = 8
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.name = "is_enter"
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.full_name = ".Cmd.EBFEventAreaUpdateCmd.is_enter"
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.number = 3
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.index = 2
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.label = 1
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.has_default_value = false
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.default_value = false
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.type = 8
EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD.cpp_type = 7
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.name = "event_id"
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.full_name = ".Cmd.EBFEventAreaUpdateCmd.event_id"
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.number = 4
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.index = 3
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.label = 1
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.has_default_value = false
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.default_value = 0
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.type = 13
EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD.cpp_type = 3
EBFEVENTAREAUPDATECMD.name = "EBFEventAreaUpdateCmd"
EBFEVENTAREAUPDATECMD.full_name = ".Cmd.EBFEventAreaUpdateCmd"
EBFEVENTAREAUPDATECMD.nested_types = {}
EBFEVENTAREAUPDATECMD.enum_types = {}
EBFEVENTAREAUPDATECMD.fields = {
  EBFEVENTAREAUPDATECMD_CMD_FIELD,
  EBFEVENTAREAUPDATECMD_PARAM_FIELD,
  EBFEVENTAREAUPDATECMD_IS_ENTER_FIELD,
  EBFEVENTAREAUPDATECMD_EVENT_ID_FIELD
}
EBFEVENTAREAUPDATECMD.is_extendable = false
EBFEVENTAREAUPDATECMD.extensions = {}
ASTRALINFOSYNCCMD_CMD_FIELD.name = "cmd"
ASTRALINFOSYNCCMD_CMD_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.cmd"
ASTRALINFOSYNCCMD_CMD_FIELD.number = 1
ASTRALINFOSYNCCMD_CMD_FIELD.index = 0
ASTRALINFOSYNCCMD_CMD_FIELD.label = 1
ASTRALINFOSYNCCMD_CMD_FIELD.has_default_value = true
ASTRALINFOSYNCCMD_CMD_FIELD.default_value = 11
ASTRALINFOSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTRALINFOSYNCCMD_CMD_FIELD.type = 14
ASTRALINFOSYNCCMD_CMD_FIELD.cpp_type = 8
ASTRALINFOSYNCCMD_PARAM_FIELD.name = "param"
ASTRALINFOSYNCCMD_PARAM_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.param"
ASTRALINFOSYNCCMD_PARAM_FIELD.number = 2
ASTRALINFOSYNCCMD_PARAM_FIELD.index = 1
ASTRALINFOSYNCCMD_PARAM_FIELD.label = 1
ASTRALINFOSYNCCMD_PARAM_FIELD.has_default_value = true
ASTRALINFOSYNCCMD_PARAM_FIELD.default_value = 163
ASTRALINFOSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
ASTRALINFOSYNCCMD_PARAM_FIELD.type = 14
ASTRALINFOSYNCCMD_PARAM_FIELD.cpp_type = 8
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.name = "kill_limit_time"
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.kill_limit_time"
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.number = 3
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.index = 2
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.label = 1
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.default_value = 0
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.type = 13
ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_ROUND_FIELD.name = "round"
ASTRALINFOSYNCCMD_ROUND_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.round"
ASTRALINFOSYNCCMD_ROUND_FIELD.number = 4
ASTRALINFOSYNCCMD_ROUND_FIELD.index = 3
ASTRALINFOSYNCCMD_ROUND_FIELD.label = 1
ASTRALINFOSYNCCMD_ROUND_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_ROUND_FIELD.default_value = 0
ASTRALINFOSYNCCMD_ROUND_FIELD.type = 13
ASTRALINFOSYNCCMD_ROUND_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.name = "total_monster"
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.total_monster"
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.number = 5
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.index = 4
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.label = 1
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.default_value = 0
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.type = 13
ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.name = "left_monster"
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.left_monster"
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.number = 6
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.index = 5
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.label = 1
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.default_value = 0
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.type = 13
ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.name = "pray_profession_num"
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.pray_profession_num"
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.number = 7
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.index = 6
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.label = 1
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.default_value = 0
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.type = 13
ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.name = "pray_profession_group"
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.pray_profession_group"
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.number = 8
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.index = 7
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.label = 1
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.default_value = 0
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.type = 13
ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.name = "pray_id"
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.pray_id"
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.number = 9
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.index = 8
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.label = 1
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.default_value = 0
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.type = 13
ASTRALINFOSYNCCMD_PRAY_ID_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.name = "boss_ids"
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.full_name = ".Cmd.AstralInfoSyncCmd.boss_ids"
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.number = 10
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.index = 9
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.label = 3
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.has_default_value = false
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.default_value = {}
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.type = 13
ASTRALINFOSYNCCMD_BOSS_IDS_FIELD.cpp_type = 3
ASTRALINFOSYNCCMD.name = "AstralInfoSyncCmd"
ASTRALINFOSYNCCMD.full_name = ".Cmd.AstralInfoSyncCmd"
ASTRALINFOSYNCCMD.nested_types = {}
ASTRALINFOSYNCCMD.enum_types = {}
ASTRALINFOSYNCCMD.fields = {
  ASTRALINFOSYNCCMD_CMD_FIELD,
  ASTRALINFOSYNCCMD_PARAM_FIELD,
  ASTRALINFOSYNCCMD_KILL_LIMIT_TIME_FIELD,
  ASTRALINFOSYNCCMD_ROUND_FIELD,
  ASTRALINFOSYNCCMD_TOTAL_MONSTER_FIELD,
  ASTRALINFOSYNCCMD_LEFT_MONSTER_FIELD,
  ASTRALINFOSYNCCMD_PRAY_PROFESSION_NUM_FIELD,
  ASTRALINFOSYNCCMD_PRAY_PROFESSION_GROUP_FIELD,
  ASTRALINFOSYNCCMD_PRAY_ID_FIELD,
  ASTRALINFOSYNCCMD_BOSS_IDS_FIELD
}
ASTRALINFOSYNCCMD.is_extendable = false
ASTRALINFOSYNCCMD.extensions = {}
GVGMVPINFOUPDATECMD_CMD_FIELD.name = "cmd"
GVGMVPINFOUPDATECMD_CMD_FIELD.full_name = ".Cmd.GvgMvpInfoUpdateCmd.cmd"
GVGMVPINFOUPDATECMD_CMD_FIELD.number = 1
GVGMVPINFOUPDATECMD_CMD_FIELD.index = 0
GVGMVPINFOUPDATECMD_CMD_FIELD.label = 1
GVGMVPINFOUPDATECMD_CMD_FIELD.has_default_value = true
GVGMVPINFOUPDATECMD_CMD_FIELD.default_value = 11
GVGMVPINFOUPDATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGMVPINFOUPDATECMD_CMD_FIELD.type = 14
GVGMVPINFOUPDATECMD_CMD_FIELD.cpp_type = 8
GVGMVPINFOUPDATECMD_PARAM_FIELD.name = "param"
GVGMVPINFOUPDATECMD_PARAM_FIELD.full_name = ".Cmd.GvgMvpInfoUpdateCmd.param"
GVGMVPINFOUPDATECMD_PARAM_FIELD.number = 2
GVGMVPINFOUPDATECMD_PARAM_FIELD.index = 1
GVGMVPINFOUPDATECMD_PARAM_FIELD.label = 1
GVGMVPINFOUPDATECMD_PARAM_FIELD.has_default_value = true
GVGMVPINFOUPDATECMD_PARAM_FIELD.default_value = 164
GVGMVPINFOUPDATECMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGMVPINFOUPDATECMD_PARAM_FIELD.type = 14
GVGMVPINFOUPDATECMD_PARAM_FIELD.cpp_type = 8
GVGMVPINFOUPDATECMD_HP_PER_FIELD.name = "hp_per"
GVGMVPINFOUPDATECMD_HP_PER_FIELD.full_name = ".Cmd.GvgMvpInfoUpdateCmd.hp_per"
GVGMVPINFOUPDATECMD_HP_PER_FIELD.number = 3
GVGMVPINFOUPDATECMD_HP_PER_FIELD.index = 2
GVGMVPINFOUPDATECMD_HP_PER_FIELD.label = 1
GVGMVPINFOUPDATECMD_HP_PER_FIELD.has_default_value = false
GVGMVPINFOUPDATECMD_HP_PER_FIELD.default_value = 0
GVGMVPINFOUPDATECMD_HP_PER_FIELD.type = 13
GVGMVPINFOUPDATECMD_HP_PER_FIELD.cpp_type = 3
GVGMVPINFOUPDATECMD_STATE_FIELD.name = "state"
GVGMVPINFOUPDATECMD_STATE_FIELD.full_name = ".Cmd.GvgMvpInfoUpdateCmd.state"
GVGMVPINFOUPDATECMD_STATE_FIELD.number = 4
GVGMVPINFOUPDATECMD_STATE_FIELD.index = 3
GVGMVPINFOUPDATECMD_STATE_FIELD.label = 1
GVGMVPINFOUPDATECMD_STATE_FIELD.has_default_value = false
GVGMVPINFOUPDATECMD_STATE_FIELD.default_value = nil
GVGMVPINFOUPDATECMD_STATE_FIELD.enum_type = GUILDCMD_PB_EMVPSTATE
GVGMVPINFOUPDATECMD_STATE_FIELD.type = 14
GVGMVPINFOUPDATECMD_STATE_FIELD.cpp_type = 8
GVGMVPINFOUPDATECMD.name = "GvgMvpInfoUpdateCmd"
GVGMVPINFOUPDATECMD.full_name = ".Cmd.GvgMvpInfoUpdateCmd"
GVGMVPINFOUPDATECMD.nested_types = {}
GVGMVPINFOUPDATECMD.enum_types = {}
GVGMVPINFOUPDATECMD.fields = {
  GVGMVPINFOUPDATECMD_CMD_FIELD,
  GVGMVPINFOUPDATECMD_PARAM_FIELD,
  GVGMVPINFOUPDATECMD_HP_PER_FIELD,
  GVGMVPINFOUPDATECMD_STATE_FIELD
}
GVGMVPINFOUPDATECMD.is_extendable = false
GVGMVPINFOUPDATECMD.extensions = {}
ASTRALPRAYGROUP_GROUP_FIELD.name = "group"
ASTRALPRAYGROUP_GROUP_FIELD.full_name = ".Cmd.AstralPrayGroup.group"
ASTRALPRAYGROUP_GROUP_FIELD.number = 1
ASTRALPRAYGROUP_GROUP_FIELD.index = 0
ASTRALPRAYGROUP_GROUP_FIELD.label = 1
ASTRALPRAYGROUP_GROUP_FIELD.has_default_value = false
ASTRALPRAYGROUP_GROUP_FIELD.default_value = 0
ASTRALPRAYGROUP_GROUP_FIELD.type = 13
ASTRALPRAYGROUP_GROUP_FIELD.cpp_type = 3
ASTRALPRAYGROUP_BRANCHES_FIELD.name = "branches"
ASTRALPRAYGROUP_BRANCHES_FIELD.full_name = ".Cmd.AstralPrayGroup.branches"
ASTRALPRAYGROUP_BRANCHES_FIELD.number = 2
ASTRALPRAYGROUP_BRANCHES_FIELD.index = 1
ASTRALPRAYGROUP_BRANCHES_FIELD.label = 3
ASTRALPRAYGROUP_BRANCHES_FIELD.has_default_value = false
ASTRALPRAYGROUP_BRANCHES_FIELD.default_value = {}
ASTRALPRAYGROUP_BRANCHES_FIELD.type = 13
ASTRALPRAYGROUP_BRANCHES_FIELD.cpp_type = 3
ASTRALPRAYGROUP.name = "AstralPrayGroup"
ASTRALPRAYGROUP.full_name = ".Cmd.AstralPrayGroup"
ASTRALPRAYGROUP.nested_types = {}
ASTRALPRAYGROUP.enum_types = {}
ASTRALPRAYGROUP.fields = {
  ASTRALPRAYGROUP_GROUP_FIELD,
  ASTRALPRAYGROUP_BRANCHES_FIELD
}
ASTRALPRAYGROUP.is_extendable = false
ASTRALPRAYGROUP.extensions = {}
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.name = "cmd"
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.full_name = ".Cmd.AstralPrayBranchSyncCmd.cmd"
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.number = 1
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.index = 0
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.label = 1
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.has_default_value = true
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.default_value = 11
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.type = 14
ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD.cpp_type = 8
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.name = "param"
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.full_name = ".Cmd.AstralPrayBranchSyncCmd.param"
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.number = 2
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.index = 1
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.label = 1
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.has_default_value = true
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.default_value = 165
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.type = 14
ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD.cpp_type = 8
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.name = "groups"
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.full_name = ".Cmd.AstralPrayBranchSyncCmd.groups"
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.number = 3
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.index = 2
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.label = 3
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.has_default_value = false
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.default_value = {}
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.message_type = ASTRALPRAYGROUP
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.type = 11
ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD.cpp_type = 10
ASTRALPRAYBRANCHSYNCCMD.name = "AstralPrayBranchSyncCmd"
ASTRALPRAYBRANCHSYNCCMD.full_name = ".Cmd.AstralPrayBranchSyncCmd"
ASTRALPRAYBRANCHSYNCCMD.nested_types = {}
ASTRALPRAYBRANCHSYNCCMD.enum_types = {}
ASTRALPRAYBRANCHSYNCCMD.fields = {
  ASTRALPRAYBRANCHSYNCCMD_CMD_FIELD,
  ASTRALPRAYBRANCHSYNCCMD_PARAM_FIELD,
  ASTRALPRAYBRANCHSYNCCMD_GROUPS_FIELD
}
ASTRALPRAYBRANCHSYNCCMD.is_extendable = false
ASTRALPRAYBRANCHSYNCCMD.extensions = {}
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.name = "cmd"
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.full_name = ".Cmd.SyncStartFightStateCmd.cmd"
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.number = 1
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.index = 0
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.label = 1
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.has_default_value = true
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.default_value = 11
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.type = 14
SYNCSTARTFIGHTSTATECMD_CMD_FIELD.cpp_type = 8
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.name = "param"
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.full_name = ".Cmd.SyncStartFightStateCmd.param"
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.number = 2
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.index = 1
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.label = 1
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.has_default_value = true
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.default_value = 166
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.type = 14
SYNCSTARTFIGHTSTATECMD_PARAM_FIELD.cpp_type = 8
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.name = "barstate"
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.full_name = ".Cmd.SyncStartFightStateCmd.barstate"
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.number = 3
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.index = 2
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.label = 1
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.has_default_value = false
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.default_value = nil
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.enum_type = EFIGHTBARSTATE
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.type = 14
SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD.cpp_type = 8
SYNCSTARTFIGHTSTATECMD.name = "SyncStartFightStateCmd"
SYNCSTARTFIGHTSTATECMD.full_name = ".Cmd.SyncStartFightStateCmd"
SYNCSTARTFIGHTSTATECMD.nested_types = {}
SYNCSTARTFIGHTSTATECMD.enum_types = {}
SYNCSTARTFIGHTSTATECMD.fields = {
  SYNCSTARTFIGHTSTATECMD_CMD_FIELD,
  SYNCSTARTFIGHTSTATECMD_PARAM_FIELD,
  SYNCSTARTFIGHTSTATECMD_BARSTATE_FIELD
}
SYNCSTARTFIGHTSTATECMD.is_extendable = false
SYNCSTARTFIGHTSTATECMD.extensions = {}
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.name = "cmd"
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.full_name = ".Cmd.SyncGvgFightPointCmd.cmd"
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.number = 1
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.index = 0
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.label = 1
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.has_default_value = true
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.default_value = 11
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.type = 14
SYNCGVGFIGHTPOINTCMD_CMD_FIELD.cpp_type = 8
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.name = "param"
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.full_name = ".Cmd.SyncGvgFightPointCmd.param"
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.number = 2
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.index = 1
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.label = 1
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.has_default_value = true
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.default_value = 167
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.type = 14
SYNCGVGFIGHTPOINTCMD_PARAM_FIELD.cpp_type = 8
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.name = "fight_points"
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.full_name = ".Cmd.SyncGvgFightPointCmd.fight_points"
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.number = 3
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.index = 2
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.label = 3
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.has_default_value = false
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.default_value = {}
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.type = 11
SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD.cpp_type = 10
SYNCGVGFIGHTPOINTCMD.name = "SyncGvgFightPointCmd"
SYNCGVGFIGHTPOINTCMD.full_name = ".Cmd.SyncGvgFightPointCmd"
SYNCGVGFIGHTPOINTCMD.nested_types = {}
SYNCGVGFIGHTPOINTCMD.enum_types = {}
SYNCGVGFIGHTPOINTCMD.fields = {
  SYNCGVGFIGHTPOINTCMD_CMD_FIELD,
  SYNCGVGFIGHTPOINTCMD_PARAM_FIELD,
  SYNCGVGFIGHTPOINTCMD_FIGHT_POINTS_FIELD
}
SYNCGVGFIGHTPOINTCMD.is_extendable = false
SYNCGVGFIGHTPOINTCMD.extensions = {}
GUILDLEADERPOS_GUILD_ID_FIELD.name = "guild_id"
GUILDLEADERPOS_GUILD_ID_FIELD.full_name = ".Cmd.GuildLeaderPos.guild_id"
GUILDLEADERPOS_GUILD_ID_FIELD.number = 1
GUILDLEADERPOS_GUILD_ID_FIELD.index = 0
GUILDLEADERPOS_GUILD_ID_FIELD.label = 1
GUILDLEADERPOS_GUILD_ID_FIELD.has_default_value = false
GUILDLEADERPOS_GUILD_ID_FIELD.default_value = 0
GUILDLEADERPOS_GUILD_ID_FIELD.type = 4
GUILDLEADERPOS_GUILD_ID_FIELD.cpp_type = 4
GUILDLEADERPOS_LEADER_POS_FIELD.name = "leader_pos"
GUILDLEADERPOS_LEADER_POS_FIELD.full_name = ".Cmd.GuildLeaderPos.leader_pos"
GUILDLEADERPOS_LEADER_POS_FIELD.number = 2
GUILDLEADERPOS_LEADER_POS_FIELD.index = 1
GUILDLEADERPOS_LEADER_POS_FIELD.label = 3
GUILDLEADERPOS_LEADER_POS_FIELD.has_default_value = false
GUILDLEADERPOS_LEADER_POS_FIELD.default_value = {}
GUILDLEADERPOS_LEADER_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
GUILDLEADERPOS_LEADER_POS_FIELD.type = 11
GUILDLEADERPOS_LEADER_POS_FIELD.cpp_type = 10
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.name = "guild_chairman_pos"
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.full_name = ".Cmd.GuildLeaderPos.guild_chairman_pos"
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.number = 3
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.index = 2
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.label = 1
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.has_default_value = false
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.default_value = nil
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.message_type = ProtoCommon_pb.SCENEPOS
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.type = 11
GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD.cpp_type = 10
GUILDLEADERPOS.name = "GuildLeaderPos"
GUILDLEADERPOS.full_name = ".Cmd.GuildLeaderPos"
GUILDLEADERPOS.nested_types = {}
GUILDLEADERPOS.enum_types = {}
GUILDLEADERPOS.fields = {
  GUILDLEADERPOS_GUILD_ID_FIELD,
  GUILDLEADERPOS_LEADER_POS_FIELD,
  GUILDLEADERPOS_GUILD_CHAIRMAN_POS_FIELD
}
GUILDLEADERPOS.is_extendable = false
GUILDLEADERPOS.extensions = {}
SYNCGVGLEADERPOSCMD_CMD_FIELD.name = "cmd"
SYNCGVGLEADERPOSCMD_CMD_FIELD.full_name = ".Cmd.SyncGvgLeaderPosCmd.cmd"
SYNCGVGLEADERPOSCMD_CMD_FIELD.number = 1
SYNCGVGLEADERPOSCMD_CMD_FIELD.index = 0
SYNCGVGLEADERPOSCMD_CMD_FIELD.label = 1
SYNCGVGLEADERPOSCMD_CMD_FIELD.has_default_value = true
SYNCGVGLEADERPOSCMD_CMD_FIELD.default_value = 11
SYNCGVGLEADERPOSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCGVGLEADERPOSCMD_CMD_FIELD.type = 14
SYNCGVGLEADERPOSCMD_CMD_FIELD.cpp_type = 8
SYNCGVGLEADERPOSCMD_PARAM_FIELD.name = "param"
SYNCGVGLEADERPOSCMD_PARAM_FIELD.full_name = ".Cmd.SyncGvgLeaderPosCmd.param"
SYNCGVGLEADERPOSCMD_PARAM_FIELD.number = 2
SYNCGVGLEADERPOSCMD_PARAM_FIELD.index = 1
SYNCGVGLEADERPOSCMD_PARAM_FIELD.label = 1
SYNCGVGLEADERPOSCMD_PARAM_FIELD.has_default_value = true
SYNCGVGLEADERPOSCMD_PARAM_FIELD.default_value = 168
SYNCGVGLEADERPOSCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCGVGLEADERPOSCMD_PARAM_FIELD.type = 14
SYNCGVGLEADERPOSCMD_PARAM_FIELD.cpp_type = 8
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.name = "guild_leader_pos"
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.full_name = ".Cmd.SyncGvgLeaderPosCmd.guild_leader_pos"
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.number = 3
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.index = 2
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.label = 3
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.has_default_value = false
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.default_value = {}
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.message_type = GUILDLEADERPOS
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.type = 11
SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD.cpp_type = 10
SYNCGVGLEADERPOSCMD.name = "SyncGvgLeaderPosCmd"
SYNCGVGLEADERPOSCMD.full_name = ".Cmd.SyncGvgLeaderPosCmd"
SYNCGVGLEADERPOSCMD.nested_types = {}
SYNCGVGLEADERPOSCMD.enum_types = {}
SYNCGVGLEADERPOSCMD.fields = {
  SYNCGVGLEADERPOSCMD_CMD_FIELD,
  SYNCGVGLEADERPOSCMD_PARAM_FIELD,
  SYNCGVGLEADERPOSCMD_GUILD_LEADER_POS_FIELD
}
SYNCGVGLEADERPOSCMD.is_extendable = false
SYNCGVGLEADERPOSCMD.extensions = {}
STISYNCSCORECMD_CMD_FIELD.name = "cmd"
STISYNCSCORECMD_CMD_FIELD.full_name = ".Cmd.STISyncScoreCmd.cmd"
STISYNCSCORECMD_CMD_FIELD.number = 1
STISYNCSCORECMD_CMD_FIELD.index = 0
STISYNCSCORECMD_CMD_FIELD.label = 1
STISYNCSCORECMD_CMD_FIELD.has_default_value = true
STISYNCSCORECMD_CMD_FIELD.default_value = 11
STISYNCSCORECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STISYNCSCORECMD_CMD_FIELD.type = 14
STISYNCSCORECMD_CMD_FIELD.cpp_type = 8
STISYNCSCORECMD_PARAM_FIELD.name = "param"
STISYNCSCORECMD_PARAM_FIELD.full_name = ".Cmd.STISyncScoreCmd.param"
STISYNCSCORECMD_PARAM_FIELD.number = 2
STISYNCSCORECMD_PARAM_FIELD.index = 1
STISYNCSCORECMD_PARAM_FIELD.label = 1
STISYNCSCORECMD_PARAM_FIELD.has_default_value = true
STISYNCSCORECMD_PARAM_FIELD.default_value = 169
STISYNCSCORECMD_PARAM_FIELD.enum_type = FUBENPARAM
STISYNCSCORECMD_PARAM_FIELD.type = 14
STISYNCSCORECMD_PARAM_FIELD.cpp_type = 8
STISYNCSCORECMD_SCORE_FIELD.name = "score"
STISYNCSCORECMD_SCORE_FIELD.full_name = ".Cmd.STISyncScoreCmd.score"
STISYNCSCORECMD_SCORE_FIELD.number = 3
STISYNCSCORECMD_SCORE_FIELD.index = 2
STISYNCSCORECMD_SCORE_FIELD.label = 1
STISYNCSCORECMD_SCORE_FIELD.has_default_value = false
STISYNCSCORECMD_SCORE_FIELD.default_value = 0
STISYNCSCORECMD_SCORE_FIELD.type = 13
STISYNCSCORECMD_SCORE_FIELD.cpp_type = 3
STISYNCSCORECMD.name = "STISyncScoreCmd"
STISYNCSCORECMD.full_name = ".Cmd.STISyncScoreCmd"
STISYNCSCORECMD.nested_types = {}
STISYNCSCORECMD.enum_types = {}
STISYNCSCORECMD.fields = {
  STISYNCSCORECMD_CMD_FIELD,
  STISYNCSCORECMD_PARAM_FIELD,
  STISYNCSCORECMD_SCORE_FIELD
}
STISYNCSCORECMD.is_extendable = false
STISYNCSCORECMD.extensions = {}
STISKILLINFO_SKILL_ID_FIELD.name = "skill_id"
STISKILLINFO_SKILL_ID_FIELD.full_name = ".Cmd.STISkillInfo.skill_id"
STISKILLINFO_SKILL_ID_FIELD.number = 1
STISKILLINFO_SKILL_ID_FIELD.index = 0
STISKILLINFO_SKILL_ID_FIELD.label = 1
STISKILLINFO_SKILL_ID_FIELD.has_default_value = false
STISKILLINFO_SKILL_ID_FIELD.default_value = 0
STISKILLINFO_SKILL_ID_FIELD.type = 13
STISKILLINFO_SKILL_ID_FIELD.cpp_type = 3
STISKILLINFO_SKILL_LEVEL_FIELD.name = "skill_level"
STISKILLINFO_SKILL_LEVEL_FIELD.full_name = ".Cmd.STISkillInfo.skill_level"
STISKILLINFO_SKILL_LEVEL_FIELD.number = 2
STISKILLINFO_SKILL_LEVEL_FIELD.index = 1
STISKILLINFO_SKILL_LEVEL_FIELD.label = 1
STISKILLINFO_SKILL_LEVEL_FIELD.has_default_value = false
STISKILLINFO_SKILL_LEVEL_FIELD.default_value = 0
STISKILLINFO_SKILL_LEVEL_FIELD.type = 13
STISKILLINFO_SKILL_LEVEL_FIELD.cpp_type = 3
STISKILLINFO_IS_RECOMMEND_FIELD.name = "is_recommend"
STISKILLINFO_IS_RECOMMEND_FIELD.full_name = ".Cmd.STISkillInfo.is_recommend"
STISKILLINFO_IS_RECOMMEND_FIELD.number = 3
STISKILLINFO_IS_RECOMMEND_FIELD.index = 2
STISKILLINFO_IS_RECOMMEND_FIELD.label = 1
STISKILLINFO_IS_RECOMMEND_FIELD.has_default_value = false
STISKILLINFO_IS_RECOMMEND_FIELD.default_value = false
STISKILLINFO_IS_RECOMMEND_FIELD.type = 8
STISKILLINFO_IS_RECOMMEND_FIELD.cpp_type = 7
STISKILLINFO_IS_NEW_SKILL_FIELD.name = "is_new_skill"
STISKILLINFO_IS_NEW_SKILL_FIELD.full_name = ".Cmd.STISkillInfo.is_new_skill"
STISKILLINFO_IS_NEW_SKILL_FIELD.number = 4
STISKILLINFO_IS_NEW_SKILL_FIELD.index = 3
STISKILLINFO_IS_NEW_SKILL_FIELD.label = 1
STISKILLINFO_IS_NEW_SKILL_FIELD.has_default_value = false
STISKILLINFO_IS_NEW_SKILL_FIELD.default_value = false
STISKILLINFO_IS_NEW_SKILL_FIELD.type = 8
STISKILLINFO_IS_NEW_SKILL_FIELD.cpp_type = 7
STISKILLINFO.name = "STISkillInfo"
STISKILLINFO.full_name = ".Cmd.STISkillInfo"
STISKILLINFO.nested_types = {}
STISKILLINFO.enum_types = {}
STISKILLINFO.fields = {
  STISKILLINFO_SKILL_ID_FIELD,
  STISKILLINFO_SKILL_LEVEL_FIELD,
  STISKILLINFO_IS_RECOMMEND_FIELD,
  STISKILLINFO_IS_NEW_SKILL_FIELD
}
STISKILLINFO.is_extendable = false
STISKILLINFO.extensions = {}
STISYNCSKILLCMD_CMD_FIELD.name = "cmd"
STISYNCSKILLCMD_CMD_FIELD.full_name = ".Cmd.STISyncSkillCmd.cmd"
STISYNCSKILLCMD_CMD_FIELD.number = 1
STISYNCSKILLCMD_CMD_FIELD.index = 0
STISYNCSKILLCMD_CMD_FIELD.label = 1
STISYNCSKILLCMD_CMD_FIELD.has_default_value = true
STISYNCSKILLCMD_CMD_FIELD.default_value = 11
STISYNCSKILLCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STISYNCSKILLCMD_CMD_FIELD.type = 14
STISYNCSKILLCMD_CMD_FIELD.cpp_type = 8
STISYNCSKILLCMD_PARAM_FIELD.name = "param"
STISYNCSKILLCMD_PARAM_FIELD.full_name = ".Cmd.STISyncSkillCmd.param"
STISYNCSKILLCMD_PARAM_FIELD.number = 2
STISYNCSKILLCMD_PARAM_FIELD.index = 1
STISYNCSKILLCMD_PARAM_FIELD.label = 1
STISYNCSKILLCMD_PARAM_FIELD.has_default_value = true
STISYNCSKILLCMD_PARAM_FIELD.default_value = 170
STISYNCSKILLCMD_PARAM_FIELD.enum_type = FUBENPARAM
STISYNCSKILLCMD_PARAM_FIELD.type = 14
STISYNCSKILLCMD_PARAM_FIELD.cpp_type = 8
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.name = "current_skills"
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.full_name = ".Cmd.STISyncSkillCmd.current_skills"
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.number = 3
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.index = 2
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.label = 3
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.has_default_value = false
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.default_value = {}
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.message_type = STISKILLINFO
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.type = 11
STISYNCSKILLCMD_CURRENT_SKILLS_FIELD.cpp_type = 10
STISYNCSKILLCMD.name = "STISyncSkillCmd"
STISYNCSKILLCMD.full_name = ".Cmd.STISyncSkillCmd"
STISYNCSKILLCMD.nested_types = {}
STISYNCSKILLCMD.enum_types = {}
STISYNCSKILLCMD.fields = {
  STISYNCSKILLCMD_CMD_FIELD,
  STISYNCSKILLCMD_PARAM_FIELD,
  STISYNCSKILLCMD_CURRENT_SKILLS_FIELD
}
STISYNCSKILLCMD.is_extendable = false
STISYNCSKILLCMD.extensions = {}
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.name = "cmd"
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.full_name = ".Cmd.STISyncAvailableUpgradeNumberCmd.cmd"
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.number = 1
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.index = 0
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.label = 1
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.has_default_value = true
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.default_value = 11
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.type = 14
STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD.cpp_type = 8
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.name = "param"
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.full_name = ".Cmd.STISyncAvailableUpgradeNumberCmd.param"
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.number = 2
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.index = 1
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.label = 1
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.has_default_value = true
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.default_value = 171
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.enum_type = FUBENPARAM
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.type = 14
STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD.cpp_type = 8
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.name = "available_upgrade_number"
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.full_name = ".Cmd.STISyncAvailableUpgradeNumberCmd.available_upgrade_number"
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.number = 3
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.index = 2
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.label = 1
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.has_default_value = false
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.default_value = 0
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.type = 13
STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD.cpp_type = 3
STISYNCAVAILABLEUPGRADENUMBERCMD.name = "STISyncAvailableUpgradeNumberCmd"
STISYNCAVAILABLEUPGRADENUMBERCMD.full_name = ".Cmd.STISyncAvailableUpgradeNumberCmd"
STISYNCAVAILABLEUPGRADENUMBERCMD.nested_types = {}
STISYNCAVAILABLEUPGRADENUMBERCMD.enum_types = {}
STISYNCAVAILABLEUPGRADENUMBERCMD.fields = {
  STISYNCAVAILABLEUPGRADENUMBERCMD_CMD_FIELD,
  STISYNCAVAILABLEUPGRADENUMBERCMD_PARAM_FIELD,
  STISYNCAVAILABLEUPGRADENUMBERCMD_AVAILABLE_UPGRADE_NUMBER_FIELD
}
STISYNCAVAILABLEUPGRADENUMBERCMD.is_extendable = false
STISYNCAVAILABLEUPGRADENUMBERCMD.extensions = {}
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.name = "cmd"
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.full_name = ".Cmd.STIGetUpgradeOptionsCmd.cmd"
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.number = 1
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.index = 0
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.label = 1
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.has_default_value = true
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.default_value = 11
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.type = 14
STIGETUPGRADEOPTIONSCMD_CMD_FIELD.cpp_type = 8
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.name = "param"
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.full_name = ".Cmd.STIGetUpgradeOptionsCmd.param"
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.number = 2
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.index = 1
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.label = 1
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.has_default_value = true
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.default_value = 172
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.enum_type = FUBENPARAM
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.type = 14
STIGETUPGRADEOPTIONSCMD_PARAM_FIELD.cpp_type = 8
STIGETUPGRADEOPTIONSCMD.name = "STIGetUpgradeOptionsCmd"
STIGETUPGRADEOPTIONSCMD.full_name = ".Cmd.STIGetUpgradeOptionsCmd"
STIGETUPGRADEOPTIONSCMD.nested_types = {}
STIGETUPGRADEOPTIONSCMD.enum_types = {}
STIGETUPGRADEOPTIONSCMD.fields = {
  STIGETUPGRADEOPTIONSCMD_CMD_FIELD,
  STIGETUPGRADEOPTIONSCMD_PARAM_FIELD
}
STIGETUPGRADEOPTIONSCMD.is_extendable = false
STIGETUPGRADEOPTIONSCMD.extensions = {}
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.name = "cmd"
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.full_name = ".Cmd.STIRetUpgradeOptionsCmd.cmd"
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.number = 1
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.index = 0
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.label = 1
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.has_default_value = true
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.default_value = 11
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.type = 14
STIRETUPGRADEOPTIONSCMD_CMD_FIELD.cpp_type = 8
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.name = "param"
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.full_name = ".Cmd.STIRetUpgradeOptionsCmd.param"
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.number = 2
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.index = 1
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.label = 1
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.has_default_value = true
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.default_value = 173
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.enum_type = FUBENPARAM
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.type = 14
STIRETUPGRADEOPTIONSCMD_PARAM_FIELD.cpp_type = 8
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.name = "skill_options"
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.full_name = ".Cmd.STIRetUpgradeOptionsCmd.skill_options"
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.number = 3
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.index = 2
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.label = 3
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.has_default_value = false
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.default_value = {}
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.message_type = STISKILLINFO
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.type = 11
STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD.cpp_type = 10
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.name = "available_refresh_all_skill_number"
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.full_name = ".Cmd.STIRetUpgradeOptionsCmd.available_refresh_all_skill_number"
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.number = 4
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.index = 3
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.label = 1
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.has_default_value = false
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.default_value = 0
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.type = 13
STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD.cpp_type = 3
STIRETUPGRADEOPTIONSCMD.name = "STIRetUpgradeOptionsCmd"
STIRETUPGRADEOPTIONSCMD.full_name = ".Cmd.STIRetUpgradeOptionsCmd"
STIRETUPGRADEOPTIONSCMD.nested_types = {}
STIRETUPGRADEOPTIONSCMD.enum_types = {}
STIRETUPGRADEOPTIONSCMD.fields = {
  STIRETUPGRADEOPTIONSCMD_CMD_FIELD,
  STIRETUPGRADEOPTIONSCMD_PARAM_FIELD,
  STIRETUPGRADEOPTIONSCMD_SKILL_OPTIONS_FIELD,
  STIRETUPGRADEOPTIONSCMD_AVAILABLE_REFRESH_ALL_SKILL_NUMBER_FIELD
}
STIRETUPGRADEOPTIONSCMD.is_extendable = false
STIRETUPGRADEOPTIONSCMD.extensions = {}
STIEXECSKILLUPGRADECMD_CMD_FIELD.name = "cmd"
STIEXECSKILLUPGRADECMD_CMD_FIELD.full_name = ".Cmd.STIExecSkillUpgradeCmd.cmd"
STIEXECSKILLUPGRADECMD_CMD_FIELD.number = 1
STIEXECSKILLUPGRADECMD_CMD_FIELD.index = 0
STIEXECSKILLUPGRADECMD_CMD_FIELD.label = 1
STIEXECSKILLUPGRADECMD_CMD_FIELD.has_default_value = true
STIEXECSKILLUPGRADECMD_CMD_FIELD.default_value = 11
STIEXECSKILLUPGRADECMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STIEXECSKILLUPGRADECMD_CMD_FIELD.type = 14
STIEXECSKILLUPGRADECMD_CMD_FIELD.cpp_type = 8
STIEXECSKILLUPGRADECMD_PARAM_FIELD.name = "param"
STIEXECSKILLUPGRADECMD_PARAM_FIELD.full_name = ".Cmd.STIExecSkillUpgradeCmd.param"
STIEXECSKILLUPGRADECMD_PARAM_FIELD.number = 2
STIEXECSKILLUPGRADECMD_PARAM_FIELD.index = 1
STIEXECSKILLUPGRADECMD_PARAM_FIELD.label = 1
STIEXECSKILLUPGRADECMD_PARAM_FIELD.has_default_value = true
STIEXECSKILLUPGRADECMD_PARAM_FIELD.default_value = 174
STIEXECSKILLUPGRADECMD_PARAM_FIELD.enum_type = FUBENPARAM
STIEXECSKILLUPGRADECMD_PARAM_FIELD.type = 14
STIEXECSKILLUPGRADECMD_PARAM_FIELD.cpp_type = 8
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.name = "slot_index"
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.full_name = ".Cmd.STIExecSkillUpgradeCmd.slot_index"
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.number = 3
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.index = 2
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.label = 1
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.has_default_value = false
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.default_value = 0
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.type = 13
STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD.cpp_type = 3
STIEXECSKILLUPGRADECMD.name = "STIExecSkillUpgradeCmd"
STIEXECSKILLUPGRADECMD.full_name = ".Cmd.STIExecSkillUpgradeCmd"
STIEXECSKILLUPGRADECMD.nested_types = {}
STIEXECSKILLUPGRADECMD.enum_types = {}
STIEXECSKILLUPGRADECMD.fields = {
  STIEXECSKILLUPGRADECMD_CMD_FIELD,
  STIEXECSKILLUPGRADECMD_PARAM_FIELD,
  STIEXECSKILLUPGRADECMD_SLOT_INDEX_FIELD
}
STIEXECSKILLUPGRADECMD.is_extendable = false
STIEXECSKILLUPGRADECMD.extensions = {}
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.name = "cmd"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.cmd"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.number = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.index = 0
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.label = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.has_default_value = true
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.default_value = 11
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.type = 14
SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.name = "param"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.param"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.number = 2
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.index = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.label = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.default_value = 175
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.type = 14
SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.name = "turn"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.turn"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.number = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.index = 2
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.label = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.type = 13
SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.name = "count"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.count"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.number = 4
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.index = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.label = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.type = 13
SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.name = "endtime"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.endtime"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.number = 5
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.index = 4
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.label = 1
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.type = 13
SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.name = "affixids"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd.affixids"
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.number = 6
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.index = 5
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.label = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.default_value = {}
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.type = 13
SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONINFOFUBENCMD.name = "SyncSpaceTimeIllusionInfoFuBenCmd"
SYNCSPACETIMEILLUSIONINFOFUBENCMD.full_name = ".Cmd.SyncSpaceTimeIllusionInfoFuBenCmd"
SYNCSPACETIMEILLUSIONINFOFUBENCMD.nested_types = {}
SYNCSPACETIMEILLUSIONINFOFUBENCMD.enum_types = {}
SYNCSPACETIMEILLUSIONINFOFUBENCMD.fields = {
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_CMD_FIELD,
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_PARAM_FIELD,
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_TURN_FIELD,
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_COUNT_FIELD,
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_ENDTIME_FIELD,
  SYNCSPACETIMEILLUSIONINFOFUBENCMD_AFFIXIDS_FIELD
}
SYNCSPACETIMEILLUSIONINFOFUBENCMD.is_extendable = false
SYNCSPACETIMEILLUSIONINFOFUBENCMD.extensions = {}
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.name = "cmd"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd.cmd"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.number = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.index = 0
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.label = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.has_default_value = true
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.default_value = 11
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.type = 14
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD.cpp_type = 8
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.name = "param"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd.param"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.number = 2
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.index = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.label = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.has_default_value = true
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.default_value = 176
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.enum_type = FUBENPARAM
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.type = 14
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD.cpp_type = 8
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.name = "curlevel"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd.curlevel"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.number = 3
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.index = 2
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.label = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.type = 13
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.name = "curexp"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd.curexp"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.number = 4
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.index = 3
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.label = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.type = 13
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.name = "needexp"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd.needexp"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.number = 5
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.index = 4
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.label = 1
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.has_default_value = false
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.default_value = 0
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.type = 13
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD.cpp_type = 3
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.name = "SyncSpaceTimeIllusionExpLevelFuBenCmd"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.full_name = ".Cmd.SyncSpaceTimeIllusionExpLevelFuBenCmd"
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.nested_types = {}
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.enum_types = {}
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.fields = {
  SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CMD_FIELD,
  SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_PARAM_FIELD,
  SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CURLEVEL_FIELD,
  SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_CUREXP_FIELD,
  SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD_NEEDEXP_FIELD
}
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.is_extendable = false
SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD.extensions = {}
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.name = "cmd"
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.full_name = ".Cmd.STIRefreshUpgradeOptionsCmd.cmd"
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.number = 1
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.index = 0
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.label = 1
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.has_default_value = true
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.default_value = 11
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.type = 14
STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD.cpp_type = 8
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.name = "param"
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.full_name = ".Cmd.STIRefreshUpgradeOptionsCmd.param"
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.number = 2
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.index = 1
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.label = 1
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.has_default_value = true
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.default_value = 177
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.enum_type = FUBENPARAM
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.type = 14
STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD.cpp_type = 8
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.name = "slot_index"
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.full_name = ".Cmd.STIRefreshUpgradeOptionsCmd.slot_index"
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.number = 3
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.index = 2
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.label = 1
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.has_default_value = false
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.default_value = 0
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.type = 13
STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD.cpp_type = 3
STIREFRESHUPGRADEOPTIONSCMD.name = "STIRefreshUpgradeOptionsCmd"
STIREFRESHUPGRADEOPTIONSCMD.full_name = ".Cmd.STIRefreshUpgradeOptionsCmd"
STIREFRESHUPGRADEOPTIONSCMD.nested_types = {}
STIREFRESHUPGRADEOPTIONSCMD.enum_types = {}
STIREFRESHUPGRADEOPTIONSCMD.fields = {
  STIREFRESHUPGRADEOPTIONSCMD_CMD_FIELD,
  STIREFRESHUPGRADEOPTIONSCMD_PARAM_FIELD,
  STIREFRESHUPGRADEOPTIONSCMD_SLOT_INDEX_FIELD
}
STIREFRESHUPGRADEOPTIONSCMD.is_extendable = false
STIREFRESHUPGRADEOPTIONSCMD.extensions = {}
STIDROPSKILLCMD_CMD_FIELD.name = "cmd"
STIDROPSKILLCMD_CMD_FIELD.full_name = ".Cmd.STIDropSkillCmd.cmd"
STIDROPSKILLCMD_CMD_FIELD.number = 1
STIDROPSKILLCMD_CMD_FIELD.index = 0
STIDROPSKILLCMD_CMD_FIELD.label = 1
STIDROPSKILLCMD_CMD_FIELD.has_default_value = true
STIDROPSKILLCMD_CMD_FIELD.default_value = 11
STIDROPSKILLCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
STIDROPSKILLCMD_CMD_FIELD.type = 14
STIDROPSKILLCMD_CMD_FIELD.cpp_type = 8
STIDROPSKILLCMD_PARAM_FIELD.name = "param"
STIDROPSKILLCMD_PARAM_FIELD.full_name = ".Cmd.STIDropSkillCmd.param"
STIDROPSKILLCMD_PARAM_FIELD.number = 2
STIDROPSKILLCMD_PARAM_FIELD.index = 1
STIDROPSKILLCMD_PARAM_FIELD.label = 1
STIDROPSKILLCMD_PARAM_FIELD.has_default_value = true
STIDROPSKILLCMD_PARAM_FIELD.default_value = 178
STIDROPSKILLCMD_PARAM_FIELD.enum_type = FUBENPARAM
STIDROPSKILLCMD_PARAM_FIELD.type = 14
STIDROPSKILLCMD_PARAM_FIELD.cpp_type = 8
STIDROPSKILLCMD_SKILL_ID_FIELD.name = "skill_id"
STIDROPSKILLCMD_SKILL_ID_FIELD.full_name = ".Cmd.STIDropSkillCmd.skill_id"
STIDROPSKILLCMD_SKILL_ID_FIELD.number = 3
STIDROPSKILLCMD_SKILL_ID_FIELD.index = 2
STIDROPSKILLCMD_SKILL_ID_FIELD.label = 1
STIDROPSKILLCMD_SKILL_ID_FIELD.has_default_value = false
STIDROPSKILLCMD_SKILL_ID_FIELD.default_value = 0
STIDROPSKILLCMD_SKILL_ID_FIELD.type = 13
STIDROPSKILLCMD_SKILL_ID_FIELD.cpp_type = 3
STIDROPSKILLCMD.name = "STIDropSkillCmd"
STIDROPSKILLCMD.full_name = ".Cmd.STIDropSkillCmd"
STIDROPSKILLCMD.nested_types = {}
STIDROPSKILLCMD.enum_types = {}
STIDROPSKILLCMD.fields = {
  STIDROPSKILLCMD_CMD_FIELD,
  STIDROPSKILLCMD_PARAM_FIELD,
  STIDROPSKILLCMD_SKILL_ID_FIELD
}
STIDROPSKILLCMD.is_extendable = false
STIDROPSKILLCMD.extensions = {}
FAIRYTALERAIDSYNCCMD_CMD_FIELD.name = "cmd"
FAIRYTALERAIDSYNCCMD_CMD_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.cmd"
FAIRYTALERAIDSYNCCMD_CMD_FIELD.number = 1
FAIRYTALERAIDSYNCCMD_CMD_FIELD.index = 0
FAIRYTALERAIDSYNCCMD_CMD_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_CMD_FIELD.has_default_value = true
FAIRYTALERAIDSYNCCMD_CMD_FIELD.default_value = 11
FAIRYTALERAIDSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FAIRYTALERAIDSYNCCMD_CMD_FIELD.type = 14
FAIRYTALERAIDSYNCCMD_CMD_FIELD.cpp_type = 8
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.name = "param"
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.param"
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.number = 2
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.index = 1
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.has_default_value = true
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.default_value = 179
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.type = 14
FAIRYTALERAIDSYNCCMD_PARAM_FIELD.cpp_type = 8
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.name = "train_arrival_count"
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.train_arrival_count"
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.number = 3
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.index = 2
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.has_default_value = false
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.default_value = 0
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.type = 13
FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD.cpp_type = 3
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.name = "train_damaged_count"
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.train_damaged_count"
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.number = 4
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.index = 3
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.has_default_value = false
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.default_value = 0
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.type = 13
FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD.cpp_type = 3
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.name = "next_wave_type"
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.next_wave_type"
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.number = 5
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.index = 4
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.has_default_value = false
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.default_value = nil
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.enum_type = EFAIRYTALEWAVETYPE
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.type = 14
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD.cpp_type = 8
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.name = "next_wave_time"
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.full_name = ".Cmd.FairyTaleRaidSyncCmd.next_wave_time"
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.number = 6
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.index = 5
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.label = 1
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.has_default_value = false
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.default_value = 0
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.type = 13
FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD.cpp_type = 3
FAIRYTALERAIDSYNCCMD.name = "FairyTaleRaidSyncCmd"
FAIRYTALERAIDSYNCCMD.full_name = ".Cmd.FairyTaleRaidSyncCmd"
FAIRYTALERAIDSYNCCMD.nested_types = {}
FAIRYTALERAIDSYNCCMD.enum_types = {}
FAIRYTALERAIDSYNCCMD.fields = {
  FAIRYTALERAIDSYNCCMD_CMD_FIELD,
  FAIRYTALERAIDSYNCCMD_PARAM_FIELD,
  FAIRYTALERAIDSYNCCMD_TRAIN_ARRIVAL_COUNT_FIELD,
  FAIRYTALERAIDSYNCCMD_TRAIN_DAMAGED_COUNT_FIELD,
  FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TYPE_FIELD,
  FAIRYTALERAIDSYNCCMD_NEXT_WAVE_TIME_FIELD
}
FAIRYTALERAIDSYNCCMD.is_extendable = false
FAIRYTALERAIDSYNCCMD.extensions = {}
RAIDSTARTFIGHTCMD_CMD_FIELD.name = "cmd"
RAIDSTARTFIGHTCMD_CMD_FIELD.full_name = ".Cmd.RaidStartFightCmd.cmd"
RAIDSTARTFIGHTCMD_CMD_FIELD.number = 1
RAIDSTARTFIGHTCMD_CMD_FIELD.index = 0
RAIDSTARTFIGHTCMD_CMD_FIELD.label = 1
RAIDSTARTFIGHTCMD_CMD_FIELD.has_default_value = true
RAIDSTARTFIGHTCMD_CMD_FIELD.default_value = 11
RAIDSTARTFIGHTCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
RAIDSTARTFIGHTCMD_CMD_FIELD.type = 14
RAIDSTARTFIGHTCMD_CMD_FIELD.cpp_type = 8
RAIDSTARTFIGHTCMD_PARAM_FIELD.name = "param"
RAIDSTARTFIGHTCMD_PARAM_FIELD.full_name = ".Cmd.RaidStartFightCmd.param"
RAIDSTARTFIGHTCMD_PARAM_FIELD.number = 2
RAIDSTARTFIGHTCMD_PARAM_FIELD.index = 1
RAIDSTARTFIGHTCMD_PARAM_FIELD.label = 1
RAIDSTARTFIGHTCMD_PARAM_FIELD.has_default_value = true
RAIDSTARTFIGHTCMD_PARAM_FIELD.default_value = 180
RAIDSTARTFIGHTCMD_PARAM_FIELD.enum_type = FUBENPARAM
RAIDSTARTFIGHTCMD_PARAM_FIELD.type = 14
RAIDSTARTFIGHTCMD_PARAM_FIELD.cpp_type = 8
RAIDSTARTFIGHTCMD.name = "RaidStartFightCmd"
RAIDSTARTFIGHTCMD.full_name = ".Cmd.RaidStartFightCmd"
RAIDSTARTFIGHTCMD.nested_types = {}
RAIDSTARTFIGHTCMD.enum_types = {}
RAIDSTARTFIGHTCMD.fields = {
  RAIDSTARTFIGHTCMD_CMD_FIELD,
  RAIDSTARTFIGHTCMD_PARAM_FIELD
}
RAIDSTARTFIGHTCMD.is_extendable = false
RAIDSTARTFIGHTCMD.extensions = {}
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.name = "cmd"
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.full_name = ".Cmd.FairyTaleRaidRewardSyncCmd.cmd"
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.number = 1
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.index = 0
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.label = 1
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.has_default_value = true
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.default_value = 11
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.type = 14
FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD.cpp_type = 8
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.name = "param"
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.full_name = ".Cmd.FairyTaleRaidRewardSyncCmd.param"
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.number = 2
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.index = 1
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.label = 1
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.has_default_value = true
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.default_value = 182
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.type = 14
FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD.cpp_type = 8
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.name = "reward_count"
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.full_name = ".Cmd.FairyTaleRaidRewardSyncCmd.reward_count"
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.number = 3
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.index = 2
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.label = 1
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.has_default_value = false
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.default_value = 0
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.type = 13
FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD.cpp_type = 3
FAIRYTALERAIDREWARDSYNCCMD.name = "FairyTaleRaidRewardSyncCmd"
FAIRYTALERAIDREWARDSYNCCMD.full_name = ".Cmd.FairyTaleRaidRewardSyncCmd"
FAIRYTALERAIDREWARDSYNCCMD.nested_types = {}
FAIRYTALERAIDREWARDSYNCCMD.enum_types = {}
FAIRYTALERAIDREWARDSYNCCMD.fields = {
  FAIRYTALERAIDREWARDSYNCCMD_CMD_FIELD,
  FAIRYTALERAIDREWARDSYNCCMD_PARAM_FIELD,
  FAIRYTALERAIDREWARDSYNCCMD_REWARD_COUNT_FIELD
}
FAIRYTALERAIDREWARDSYNCCMD.is_extendable = false
FAIRYTALERAIDREWARDSYNCCMD.extensions = {}
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.name = "cmd"
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.full_name = ".Cmd.FairyTaleRaidGetRewardCmd.cmd"
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.number = 1
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.index = 0
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.label = 1
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.has_default_value = true
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.default_value = 11
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.type = 14
FAIRYTALERAIDGETREWARDCMD_CMD_FIELD.cpp_type = 8
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.name = "param"
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.full_name = ".Cmd.FairyTaleRaidGetRewardCmd.param"
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.number = 2
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.index = 1
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.label = 1
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.has_default_value = true
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.default_value = 183
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.enum_type = FUBENPARAM
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.type = 14
FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD.cpp_type = 8
FAIRYTALERAIDGETREWARDCMD.name = "FairyTaleRaidGetRewardCmd"
FAIRYTALERAIDGETREWARDCMD.full_name = ".Cmd.FairyTaleRaidGetRewardCmd"
FAIRYTALERAIDGETREWARDCMD.nested_types = {}
FAIRYTALERAIDGETREWARDCMD.enum_types = {}
FAIRYTALERAIDGETREWARDCMD.fields = {
  FAIRYTALERAIDGETREWARDCMD_CMD_FIELD,
  FAIRYTALERAIDGETREWARDCMD_PARAM_FIELD
}
FAIRYTALERAIDGETREWARDCMD.is_extendable = false
FAIRYTALERAIDGETREWARDCMD.extensions = {}
MEMORYEQUIPREWARDINFO_INDEX_FIELD.name = "index"
MEMORYEQUIPREWARDINFO_INDEX_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.index"
MEMORYEQUIPREWARDINFO_INDEX_FIELD.number = 1
MEMORYEQUIPREWARDINFO_INDEX_FIELD.index = 0
MEMORYEQUIPREWARDINFO_INDEX_FIELD.label = 1
MEMORYEQUIPREWARDINFO_INDEX_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_INDEX_FIELD.default_value = 0
MEMORYEQUIPREWARDINFO_INDEX_FIELD.type = 13
MEMORYEQUIPREWARDINFO_INDEX_FIELD.cpp_type = 3
MEMORYEQUIPREWARDINFO_POS_FIELD.name = "pos"
MEMORYEQUIPREWARDINFO_POS_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.pos"
MEMORYEQUIPREWARDINFO_POS_FIELD.number = 2
MEMORYEQUIPREWARDINFO_POS_FIELD.index = 1
MEMORYEQUIPREWARDINFO_POS_FIELD.label = 1
MEMORYEQUIPREWARDINFO_POS_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_POS_FIELD.default_value = nil
MEMORYEQUIPREWARDINFO_POS_FIELD.enum_type = SCENEITEM_PB_EEQUIPPOS
MEMORYEQUIPREWARDINFO_POS_FIELD.type = 14
MEMORYEQUIPREWARDINFO_POS_FIELD.cpp_type = 8
MEMORYEQUIPREWARDINFO_STATE_FIELD.name = "state"
MEMORYEQUIPREWARDINFO_STATE_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.state"
MEMORYEQUIPREWARDINFO_STATE_FIELD.number = 3
MEMORYEQUIPREWARDINFO_STATE_FIELD.index = 2
MEMORYEQUIPREWARDINFO_STATE_FIELD.label = 1
MEMORYEQUIPREWARDINFO_STATE_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_STATE_FIELD.default_value = nil
MEMORYEQUIPREWARDINFO_STATE_FIELD.enum_type = EMEMORYEQUIPREWARDSTATE
MEMORYEQUIPREWARDINFO_STATE_FIELD.type = 14
MEMORYEQUIPREWARDINFO_STATE_FIELD.cpp_type = 8
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.name = "beginlevel"
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.beginlevel"
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.number = 4
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.index = 3
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.label = 1
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.default_value = 0
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.type = 13
MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD.cpp_type = 3
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.name = "endlevel"
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.endlevel"
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.number = 5
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.index = 4
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.label = 1
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.default_value = 0
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.type = 13
MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD.cpp_type = 3
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.name = "quality"
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.quality"
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.number = 6
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.index = 5
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.label = 1
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.default_value = 0
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.type = 13
MEMORYEQUIPREWARDINFO_QUALITY_FIELD.cpp_type = 3
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.name = "items"
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.full_name = ".Cmd.MemoryEquipRewardInfo.items"
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.number = 7
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.index = 6
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.label = 3
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.has_default_value = false
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.default_value = {}
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.message_type = REWARDITEMDATA
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.type = 11
MEMORYEQUIPREWARDINFO_ITEMS_FIELD.cpp_type = 10
MEMORYEQUIPREWARDINFO.name = "MemoryEquipRewardInfo"
MEMORYEQUIPREWARDINFO.full_name = ".Cmd.MemoryEquipRewardInfo"
MEMORYEQUIPREWARDINFO.nested_types = {}
MEMORYEQUIPREWARDINFO.enum_types = {}
MEMORYEQUIPREWARDINFO.fields = {
  MEMORYEQUIPREWARDINFO_INDEX_FIELD,
  MEMORYEQUIPREWARDINFO_POS_FIELD,
  MEMORYEQUIPREWARDINFO_STATE_FIELD,
  MEMORYEQUIPREWARDINFO_BEGINLEVEL_FIELD,
  MEMORYEQUIPREWARDINFO_ENDLEVEL_FIELD,
  MEMORYEQUIPREWARDINFO_QUALITY_FIELD,
  MEMORYEQUIPREWARDINFO_ITEMS_FIELD
}
MEMORYEQUIPREWARDINFO.is_extendable = false
MEMORYEQUIPREWARDINFO.extensions = {}
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.name = "cmd"
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.full_name = ".Cmd.SyncMemoryEquipRewardInfo.cmd"
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.number = 1
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.index = 0
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.label = 1
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.has_default_value = true
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.default_value = 11
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.type = 14
SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD.cpp_type = 8
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.name = "param"
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.full_name = ".Cmd.SyncMemoryEquipRewardInfo.param"
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.number = 2
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.index = 1
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.label = 1
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.has_default_value = true
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.default_value = 184
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.enum_type = FUBENPARAM
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.type = 14
SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD.cpp_type = 8
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.name = "infos"
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.full_name = ".Cmd.SyncMemoryEquipRewardInfo.infos"
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.number = 3
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.index = 2
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.label = 3
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.has_default_value = false
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.default_value = {}
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.message_type = MEMORYEQUIPREWARDINFO
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.type = 11
SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD.cpp_type = 10
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.name = "endtime"
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.full_name = ".Cmd.SyncMemoryEquipRewardInfo.endtime"
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.number = 4
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.index = 3
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.label = 1
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.has_default_value = false
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.default_value = 0
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.type = 13
SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD.cpp_type = 3
SYNCMEMORYEQUIPREWARDINFO.name = "SyncMemoryEquipRewardInfo"
SYNCMEMORYEQUIPREWARDINFO.full_name = ".Cmd.SyncMemoryEquipRewardInfo"
SYNCMEMORYEQUIPREWARDINFO.nested_types = {}
SYNCMEMORYEQUIPREWARDINFO.enum_types = {}
SYNCMEMORYEQUIPREWARDINFO.fields = {
  SYNCMEMORYEQUIPREWARDINFO_CMD_FIELD,
  SYNCMEMORYEQUIPREWARDINFO_PARAM_FIELD,
  SYNCMEMORYEQUIPREWARDINFO_INFOS_FIELD,
  SYNCMEMORYEQUIPREWARDINFO_ENDTIME_FIELD
}
SYNCMEMORYEQUIPREWARDINFO.is_extendable = false
SYNCMEMORYEQUIPREWARDINFO.extensions = {}
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.name = "cmd"
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.full_name = ".Cmd.ChooseMemoryEquipRewardInfo.cmd"
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.number = 1
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.index = 0
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.label = 1
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.has_default_value = true
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.default_value = 11
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.enum_type = XCMD_PB_COMMAND
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.type = 14
CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD.cpp_type = 8
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.name = "param"
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.full_name = ".Cmd.ChooseMemoryEquipRewardInfo.param"
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.number = 2
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.index = 1
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.label = 1
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.has_default_value = true
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.default_value = 185
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.enum_type = FUBENPARAM
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.type = 14
CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD.cpp_type = 8
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.name = "index"
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.full_name = ".Cmd.ChooseMemoryEquipRewardInfo.index"
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.number = 3
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.index = 2
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.label = 1
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.has_default_value = false
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.default_value = 0
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.type = 13
CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD.cpp_type = 3
CHOOSEMEMORYEQUIPREWARDINFO.name = "ChooseMemoryEquipRewardInfo"
CHOOSEMEMORYEQUIPREWARDINFO.full_name = ".Cmd.ChooseMemoryEquipRewardInfo"
CHOOSEMEMORYEQUIPREWARDINFO.nested_types = {}
CHOOSEMEMORYEQUIPREWARDINFO.enum_types = {}
CHOOSEMEMORYEQUIPREWARDINFO.fields = {
  CHOOSEMEMORYEQUIPREWARDINFO_CMD_FIELD,
  CHOOSEMEMORYEQUIPREWARDINFO_PARAM_FIELD,
  CHOOSEMEMORYEQUIPREWARDINFO_INDEX_FIELD
}
CHOOSEMEMORYEQUIPREWARDINFO.is_extendable = false
CHOOSEMEMORYEQUIPREWARDINFO.extensions = {}
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.name = "death_count"
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.full_name = ".Cmd.GvgDateBattleDeathInfo.death_count"
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.number = 1
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.index = 0
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.label = 1
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.has_default_value = false
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.default_value = 0
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.type = 13
GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD.cpp_type = 3
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.name = "death_limit"
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.full_name = ".Cmd.GvgDateBattleDeathInfo.death_limit"
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.number = 2
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.index = 1
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.label = 1
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.has_default_value = false
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.default_value = 0
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.type = 13
GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD.cpp_type = 3
GVGDATEBATTLEDEATHINFO.name = "GvgDateBattleDeathInfo"
GVGDATEBATTLEDEATHINFO.full_name = ".Cmd.GvgDateBattleDeathInfo"
GVGDATEBATTLEDEATHINFO.nested_types = {}
GVGDATEBATTLEDEATHINFO.enum_types = {}
GVGDATEBATTLEDEATHINFO.fields = {
  GVGDATEBATTLEDEATHINFO_DEATH_COUNT_FIELD,
  GVGDATEBATTLEDEATHINFO_DEATH_LIMIT_FIELD
}
GVGDATEBATTLEDEATHINFO.is_extendable = false
GVGDATEBATTLEDEATHINFO.extensions = {}
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.name = "atk_kill_count"
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.full_name = ".Cmd.GvgDateBattleBloodInfo.atk_kill_count"
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.number = 1
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.index = 0
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.label = 1
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.has_default_value = false
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.default_value = 0
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.type = 13
GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD.cpp_type = 3
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.name = "def_kill_count"
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.full_name = ".Cmd.GvgDateBattleBloodInfo.def_kill_count"
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.number = 2
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.index = 1
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.label = 1
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.has_default_value = false
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.default_value = 0
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.type = 13
GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD.cpp_type = 3
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.name = "kill_target"
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.full_name = ".Cmd.GvgDateBattleBloodInfo.kill_target"
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.number = 3
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.index = 2
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.label = 1
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.has_default_value = false
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.default_value = 0
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.type = 13
GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD.cpp_type = 3
GVGDATEBATTLEBLOODINFO.name = "GvgDateBattleBloodInfo"
GVGDATEBATTLEBLOODINFO.full_name = ".Cmd.GvgDateBattleBloodInfo"
GVGDATEBATTLEBLOODINFO.nested_types = {}
GVGDATEBATTLEBLOODINFO.enum_types = {}
GVGDATEBATTLEBLOODINFO.fields = {
  GVGDATEBATTLEBLOODINFO_ATK_KILL_COUNT_FIELD,
  GVGDATEBATTLEBLOODINFO_DEF_KILL_COUNT_FIELD,
  GVGDATEBATTLEBLOODINFO_KILL_TARGET_FIELD
}
GVGDATEBATTLEBLOODINFO.is_extendable = false
GVGDATEBATTLEBLOODINFO.extensions = {}
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.name = "cmd"
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd.cmd"
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.number = 1
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.index = 0
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.label = 1
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.has_default_value = true
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.default_value = 11
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.enum_type = XCMD_PB_COMMAND
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.type = 14
GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD.cpp_type = 8
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.name = "param"
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd.param"
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.number = 2
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.index = 1
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.label = 1
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.has_default_value = true
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.default_value = 181
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.enum_type = FUBENPARAM
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.type = 14
GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD.cpp_type = 8
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.name = "battle_type"
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd.battle_type"
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.number = 3
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.index = 2
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.label = 1
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.has_default_value = false
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.default_value = nil
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.enum_type = GUILDCMD_PB_EGUILDDATEBATTLETYPE
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.type = 14
GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD.cpp_type = 8
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.name = "death_info"
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd.death_info"
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.number = 4
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.index = 3
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.label = 1
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.has_default_value = false
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.default_value = nil
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.message_type = GVGDATEBATTLEDEATHINFO
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.type = 11
GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD.cpp_type = 10
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.name = "blood_info"
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd.blood_info"
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.number = 5
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.index = 4
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.label = 1
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.has_default_value = false
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.default_value = nil
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.message_type = GVGDATEBATTLEBLOODINFO
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.type = 11
GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD.cpp_type = 10
GVGDATEBATTLEINFOSYNCCMD.name = "GvgDateBattleInfoSyncCmd"
GVGDATEBATTLEINFOSYNCCMD.full_name = ".Cmd.GvgDateBattleInfoSyncCmd"
GVGDATEBATTLEINFOSYNCCMD.nested_types = {}
GVGDATEBATTLEINFOSYNCCMD.enum_types = {}
GVGDATEBATTLEINFOSYNCCMD.fields = {
  GVGDATEBATTLEINFOSYNCCMD_CMD_FIELD,
  GVGDATEBATTLEINFOSYNCCMD_PARAM_FIELD,
  GVGDATEBATTLEINFOSYNCCMD_BATTLE_TYPE_FIELD,
  GVGDATEBATTLEINFOSYNCCMD_DEATH_INFO_FIELD,
  GVGDATEBATTLEINFOSYNCCMD_BLOOD_INFO_FIELD
}
GVGDATEBATTLEINFOSYNCCMD.is_extendable = false
GVGDATEBATTLEINFOSYNCCMD.extensions = {}
ADD_PVECARD_TIMES = 129
ASTRAL_INFO_SYNC = 163
ASTRAL_PRAY_BRANCH_SYNC = 165
AchieveReward = protobuf.Message(ACHIEVEREWARD)
AddPveCardTimesFubenCmd = protobuf.Message(ADDPVECARDTIMESFUBENCMD)
AstralInfoSyncCmd = protobuf.Message(ASTRALINFOSYNCCMD)
AstralPrayBranchSyncCmd = protobuf.Message(ASTRALPRAYBRANCHSYNCCMD)
AstralPrayGroup = protobuf.Message(ASTRALPRAYGROUP)
BEGIN_FIRE_FUBENCMD = 49
BeginFireFubenCmd = protobuf.Message(BEGINFIREFUBENCMD)
BossDieFubenCmd = protobuf.Message(BOSSDIEFUBENCMD)
BossSceneInfo = protobuf.Message(BOSSSCENEINFO)
BossStateInfo = protobuf.Message(BOSSSTATEINFO)
BuildingHp = protobuf.Message(BUILDINGHP)
BuyExpRaidItemFubenCmd = protobuf.Message(BUYEXPRAIDITEMFUBENCMD)
CHOOSE_CUR_PROFESSION = 153
CHOOSE_MEMORY_EQUIP_REWARD_INFO = 185
COMODO_PHASE = 97
COMODO_STAT = 98
CampResultData = protobuf.Message(CAMPRESULTDATA)
ChooseCurProfessionFuBenCmd = protobuf.Message(CHOOSECURPROFESSIONFUBENCMD)
ChooseMemoryEquipRewardInfo = protobuf.Message(CHOOSEMEMORYEQUIPREWARDINFO)
ComodoPhaseFubenCmd = protobuf.Message(COMODOPHASEFUBENCMD)
ComodoTeamRaidStatData = protobuf.Message(COMODOTEAMRAIDSTATDATA)
EBFContinueCmd = protobuf.Message(EBFCONTINUECMD)
EBFEventAreaUpdateCmd = protobuf.Message(EBFEVENTAREAUPDATECMD)
EBFEventData = protobuf.Message(EBFEVENTDATA)
EBFEventDataUpdateCmd = protobuf.Message(EBFEVENTDATAUPDATECMD)
EBFKickTimeCmd = protobuf.Message(EBFKICKTIMECMD)
EBFMiscDataUpdate = protobuf.Message(EBFMISCDATAUPDATE)
EBF_CONTINUE = 161
EBF_EVENT_AREA_UPDATE = 162
EBF_EVENT_DATA_UPDATE = 156
EBF_KICK_TIME = 160
EBF_MISC_DATA_UPDATE = 157
ECOMODO_BOSS_CHESS = 2
ECOMODO_BOSS_DRAGON = 1
ECOMODO_BOSS_HERO = 3
ECOMODO_BOSS_MAX = 4
ECOMODO_BOSS_MIN = 0
ECOMODO_PHASE_CHESS = 2
ECOMODO_PHASE_DRAGON = 1
ECOMODO_PHASE_HERO = 3
ECOMODO_PHASE_MIN = 0
ECOMODO_PHASE_SAVE_NPC = 4
EDEADBOSSDIFF_HARD = 3
EDEADBOSSDIFF_MIN = 0
EDEADBOSSDIFF_NORMAL = 2
EDEADBOSSDIFF_SUPER = 4
EEBF_FIELD_EVENT = 1
EEBF_FIELD_FINAL = 2
EEBF_FIELD_WAITING = 0
EEENDLESSPRIVATE_MONSTER_ADVANCE = 1
EEENDLESSPRIVATE_MONSTER_NORMAL = 0
EFAIRYTALEWAVETYPE_MIN = 0
EFAIRYTALEWAVETYPE_MINI = 2
EFAIRYTALEWAVETYPE_MVP = 3
EFAIRYTALEWAVETYPE_NORMAL = 1
EFIGHT_BAR_STATE_BEGIN = 1
EFIGHT_BAR_STATE_DEL = 3
EFIGHT_BAR_STATE_MIN = 0
EFIGHT_BAR_STATE_PAUSE = 2
EGROUPCAMP_BLUE = 2
EGROUPCAMP_MIN = 0
EGROUPCAMP_OBSERVER = 3
EGROUPCAMP_RED = 1
EGROUPRAIDSCENE_FIRE = 1
EGROUPRAIDSCENE_MIN = 0
EGROUPRAIDSCENE_OVER = 2
EGUILDFIRERESULT_ATTACK = 3
EGUILDFIRERESULT_DEF = 1
EGUILDFIRERESULT_DEFSPEC = 2
EGUILDGATEOPT_ENTER = 3
EGUILDGATEOPT_OPEN = 2
EGUILDGATEOPT_OPEN_ENTER = 4
EGUILDGATEOPT_UNLOCK = 1
EGUILDGATESTATE_CLOSE = 2
EGUILDGATESTATE_LOCK = 1
EGUILDGATESTATE_MIN = 0
EGUILDGATESTATE_OPEN = 3
EGVGCITYTYPE_LARGE = 3
EGVGCITYTYPE_MAX = 4
EGVGCITYTYPE_MIDDLE = 2
EGVGCITYTYPE_MIN = 0
EGVGCITYTYPE_SMALL = 1
EGVGDATA_COIN = 10
EGVGDATA_DAMMETAL = 5
EGVGDATA_DAM_MVP = 13
EGVGDATA_DEF_POINT_TIME = 11
EGVGDATA_EXPEL = 4
EGVGDATA_HONOR = 8
EGVGDATA_KILLMETAL = 6
EGVGDATA_KILLMON = 2
EGVGDATA_KILLUSER = 7
EGVGDATA_MIN = 0
EGVGDATA_OCCUPY_POINT = 9
EGVGDATA_PARTINTIME = 1
EGVGDATA_PARTIN_KILLMETAL = 12
EGVGDATA_RELIVE = 3
EGVGPOINT_STATE_MIN = 0
EGVGPOINT_STATE_OCCUPIED = 1
EGVGRAIDSTATE_CALM = 3
EGVGRAIDSTATE_FIRE = 2
EGVGRAIDSTATE_MIN = 0
EGVGRAIDSTATE_PEACE = 1
EGVGRAIDSTATE_PERFECT = 4
EGVGTOWERSTATE_FREE = 3
EGVGTOWERSTATE_INITFREE = 1
EGVGTOWERSTATE_OCCUPY = 2
EGVGTOWERTYPE_CORE = 1
EGVGTOWERTYPE_EAST = 3
EGVGTOWERTYPE_MIN = 0
EGVGTOWERTYPE_WEST = 2
EKUMAMOTOOPER_CREATE = 1
EKUMAMOTOOPER_REWARD = 2
EKUMAMOTOOPER_SCORE = 3
ELEMENT_RAID_STAT = 136
EMAGICBALL_EARTH = 2
EMAGICBALL_FIRE = 4
EMAGICBALL_MIN = 0
EMAGICBALL_WATER = 3
EMAGICBALL_WIND = 1
EMEMORY_EQUIP_REWARD_EMPTY = 5
EMEMORY_EQUIP_REWARD_MAX_BREAK = 4
EMEMORY_EQUIP_REWARD_MAX_LEVEL = 3
EMEMORY_EQUIP_REWARD_MIN = 0
EMEMORY_EQUIP_REWARD_TO_BREAK = 2
EMEMORY_EQUIP_REWARD_UP_LEVEL = 1
ENDTIME_SYNC = 92
EPVEGROUPTYPE_ASTRAL_DEATH = 39
EPVEGROUPTYPE_ASTRAL_LIFE = 36
EPVEGROUPTYPE_ASTRAL_PASSION = 37
EPVEGROUPTYPE_ASTRAL_SPACETIME = 38
EPVEGROUPTYPE_BOSS_EIGHT = 31
EPVEGROUPTYPE_BOSS_FIVE = 27
EPVEGROUPTYPE_BOSS_FOUR = 26
EPVEGROUPTYPE_BOSS_NINE = 35
EPVEGROUPTYPE_BOSS_ONE = 20
EPVEGROUPTYPE_BOSS_OTHERWORLD = 43
EPVEGROUPTYPE_BOSS_SEVEN = 29
EPVEGROUPTYPE_BOSS_SIX = 28
EPVEGROUPTYPE_BOSS_THREE = 25
EPVEGROUPTYPE_BOSS_TWO = 21
EPVEGROUPTYPE_CARD = 4
EPVEGROUPTYPE_COMMON_MATERIALS = 32
EPVEGROUPTYPE_COMODO = 1
EPVEGROUPTYPE_CRACK_EIGHT = 16
EPVEGROUPTYPE_CRACK_FIVE = 13
EPVEGROUPTYPE_CRACK_FOUR = 12
EPVEGROUPTYPE_CRACK_NINE = 17
EPVEGROUPTYPE_CRACK_ONE = 9
EPVEGROUPTYPE_CRACK_SEVEN = 15
EPVEGROUPTYPE_CRACK_SIX = 14
EPVEGROUPTYPE_CRACK_TEN = 18
EPVEGROUPTYPE_CRACK_THREE = 11
EPVEGROUPTYPE_CRACK_TORTOISE = 23
EPVEGROUPTYPE_CRACK_TWO = 10
EPVEGROUPTYPE_DEADBOSS = 6
EPVEGROUPTYPE_ELEMENT = 22
EPVEGROUPTYPE_ENDLESS = 5
EPVEGROUPTYPE_EQUIP_UP_RAID = 24
EPVEGROUPTYPE_FAIRY_TALE = 45
EPVEGROUPTYPE_GUILD_RAID = 19
EPVEGROUPTYPE_HEADWEAR = 3
EPVEGROUPTYPE_HERO_JOURNEY = 34
EPVEGROUPTYPE_HERO_JOURNEY_SUNLIGHT = 42
EPVEGROUPTYPE_MAX = 46
EPVEGROUPTYPE_MEMORY = 40
EPVEGROUPTYPE_MEMORY_PALACE = 33
EPVEGROUPTYPE_MEMORY_THIRD = 41
EPVEGROUPTYPE_MIN = 0
EPVEGROUPTYPE_MULTIBOSS = 2
EPVEGROUPTYPE_ROGUELIKE = 8
EPVEGROUPTYPE_SPACETIME_ILLUSION = 44
EPVEGROUPTYPE_STAR_ARK = 30
EPVEGROUPTYPE_THANATOS = 7
ERAIDTYPE_ABYSS_DRAGON = 83
ERAIDTYPE_ALTMAN = 31
ERAIDTYPE_ASTRAL = 79
ERAIDTYPE_BOSS = 68
ERAIDTYPE_COMMON_MATERIALS = 73
ERAIDTYPE_COMODO_TEAM_RAID = 59
ERAIDTYPE_CRACK = 65
ERAIDTYPE_DATELAND = 24
ERAIDTYPE_DEADBOSS = 51
ERAIDTYPE_DISNEY_MUSIC = 61
ERAIDTYPE_DIVORCE_ROLLER_COASTER = 27
ERAIDTYPE_DOJO = 9
ERAIDTYPE_EINHERJAR = 52
ERAIDTYPE_ELEMENT = 70
ERAIDTYPE_ENDLESSTOWER_PRIVATE = 55
ERAIDTYPE_ENDLESS_BATTLE_FIELD = 75
ERAIDTYPE_EQUIP_UP = 69
ERAIDTYPE_EXCHANGE = 3
ERAIDTYPE_EXCHANGEGALLERY = 6
ERAIDTYPE_FAIRY_TALE = 82
ERAIDTYPE_FERRISWHEEL = 1
ERAIDTYPE_GARDEN = 41
ERAIDTYPE_GUILD = 10
ERAIDTYPE_GUILDFIRE = 14
ERAIDTYPE_GUILDRAID = 13
ERAIDTYPE_GUILD_DATE_BATTLE = 77
ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY = 78
ERAIDTYPE_GVG_LOBBY = 66
ERAIDTYPE_HEADWEAR = 43
ERAIDTYPE_HEADWEARACTIVITY = 64
ERAIDTYPE_HEART_LOCK = 63
ERAIDTYPE_HERO_JOURNEY = 76
ERAIDTYPE_HOUSE = 37
ERAIDTYPE_ITEMIMAGE = 12
ERAIDTYPE_JANUARY = 56
ERAIDTYPE_KUMAMOTO = 39
ERAIDTYPE_LABORATORY = 5
ERAIDTYPE_MANOR = 60
ERAIDTYPE_MAX = 84
ERAIDTYPE_MAY = 57
ERAIDTYPE_MEMORY_PALACE = 74
ERAIDTYPE_MEMORY_RAID = 80
ERAIDTYPE_MIN = 0
ERAIDTYPE_MONSTER_ANSWER = 47
ERAIDTYPE_MONSTER_PHOTO = 48
ERAIDTYPE_MVPBATTLE = 29
ERAIDTYPE_NORMAL = 2
ERAIDTYPE_OTHELLO = 44
ERAIDTYPE_PROFESSION_TRIAL = 67
ERAIDTYPE_PVECARD = 28
ERAIDTYPE_PVP_HLJS = 23
ERAIDTYPE_PVP_LLH = 21
ERAIDTYPE_PVP_POLLY = 25
ERAIDTYPE_PVP_SMZL = 22
ERAIDTYPE_QTE_CHASING = 53
ERAIDTYPE_RAIDTEMP2 = 8
ERAIDTYPE_RAIDTEMP4 = 11
ERAIDTYPE_ROGUELIKE = 46
ERAIDTYPE_SEAL = 7
ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID = 62
ERAIDTYPE_SLAYERS = 54
ERAIDTYPE_SPACETIME_ILLUSION = 81
ERAIDTYPE_SPRING = 45
ERAIDTYPE_STAR_ARK = 71
ERAIDTYPE_SUPERGVG = 30
ERAIDTYPE_TEAMEXP = 34
ERAIDTYPE_TEAMPWS = 32
ERAIDTYPE_THANATOS = 35
ERAIDTYPE_THANATOS_FOURTH = 40
ERAIDTYPE_THANATOS_MID = 36
ERAIDTYPE_THANATOS_SCENE3 = 38
ERAIDTYPE_THANKSGIVING = 42
ERAIDTYPE_TOWER = 4
ERAIDTYPE_TRANSFERFIGHT = 49
ERAIDTYPE_TRIPLE_PVP = 72
ERAIDTYPE_TWELVE_PVP = 50
ERAIDTYPE_WEDDING = 26
EREWARD_SHOW_FIRST = 3
EREWARD_SHOW_HEAD_WEAR = 5
EREWARD_SHOW_MIN = 0
EREWARD_SHOW_NORMAL = 1
EREWARD_SHOW_PROBABLY = 4
EREWARD_SHOW_WEEKLY = 2
EROLLRAIDREWARD_BOSS_SCENE_MINI = 10
EROLLRAIDREWARD_BOSS_SCENE_MVP = 9
EROLLRAIDREWARD_COMODO_TEAM_RAID = 6
EROLLRAIDREWARD_DEADBOSS = 4
EROLLRAIDREWARD_EQUIP_UP = 8
EROLLRAIDREWARD_GROUPRAID = 2
EROLLRAIDREWARD_GUILD = 5
EROLLRAIDREWARD_MEMORY = 12
EROLLRAIDREWARD_MEMORY_PALACE = 11
EROLLRAIDREWARD_MIN = 0
EROLLRAIDREWARD_PVERAID = 1
EROLLRAIDREWARD_SEVEN_ROYAL_TEAM_RAID = 7
EROLLRAIDREWARD_WORLDBOSS = 3
ETEAMPWS_BLUE = 2
ETEAMPWS_MIN = 0
ETEAMPWS_RED = 1
ETRIPLE_CAMP_BLUE = 3
ETRIPLE_CAMP_GREEN = 4
ETRIPLE_CAMP_MAX = 5
ETRIPLE_CAMP_MIN = 0
ETRIPLE_CAMP_RED = 1
ETRIPLE_CAMP_YELLOW = 2
ETWELVEPVP_DATA_BARRACK_HP = 10
ETWELVEPVP_DATA_CAMP = 9
ETWELVEPVP_DATA_CAR_POINT = 5
ETWELVEPVP_DATA_CRYSTAL_EXP = 3
ETWELVEPVP_DATA_CRYSTAL_HP = 11
ETWELVEPVP_DATA_CRYSTAL_LEVEL = 13
ETWELVEPVP_DATA_END_TIME = 7
ETWELVEPVP_DATA_GOLD = 4
ETWELVEPVP_DATA_KILL_NUM = 14
ETWELVEPVP_DATA_MAX = 15
ETWELVEPVP_DATA_MIN = 0
ETWELVEPVP_DATA_PUSH_PLAYER_NUM = 6
ETWELVEPVP_DATA_PVP_TYPE = 12
ETWELVEPVP_DATA_SHOP_CD = 8
ETWELVEPVP_OBSERVER_UI_ITEM = 1001
ETWELVEPVP_OBSERVER_UI_MIN = 1000
ETWELVEPVP_UI_CRYSTAL = 1
ETWELVEPVP_UI_MIN = 0
ETWELVEPVP_UI_SHOP = 2
EXIT_RAID_CMD = 48
EmotionFactors = protobuf.Message(EMOTIONFACTORS)
EndTimeSyncFubenCmd = protobuf.Message(ENDTIMESYNCFUBENCMD)
ExitMapFubenCmd = protobuf.Message(EXITMAPFUBENCMD)
FAIL_FUBEN_USER_CMD = 2
FAIRY_TALE_RAID_GET_REWARD = 183
FAIRY_TALE_RAID_REWARD_SYNC = 182
FAIRY_TALE_RAID_SYNC = 179
FUBEN_CLEAR_SYNC = 15
FUBEN_GOAL_SYNC = 13
FUBEN_RESULT_NTF = 91
FUBEN_STEP_SYNC = 12
FUBEN_USERNUM_COUNT = 31
FailFuBenUserCmd = protobuf.Message(FAILFUBENUSERCMD)
FairyTaleRaidGetRewardCmd = protobuf.Message(FAIRYTALERAIDGETREWARDCMD)
FairyTaleRaidRewardSyncCmd = protobuf.Message(FAIRYTALERAIDREWARDSYNCCMD)
FairyTaleRaidSyncCmd = protobuf.Message(FAIRYTALERAIDSYNCCMD)
FightUserInfo = protobuf.Message(FIGHTUSERINFO)
FuBenClearInfoCmd = protobuf.Message(FUBENCLEARINFOCMD)
FuBenProgressSyncCmd = protobuf.Message(FUBENPROGRESSSYNCCMD)
FubenResultNtf = protobuf.Message(FUBENRESULTNTF)
FubenStepSyncCmd = protobuf.Message(FUBENSTEPSYNCCMD)
GET_REWARD_STAGE_USER_CMD = 8
GUILD_FIRE_CALM = 22
GUILD_FIRE_CHANGE_GUILD = 23
GUILD_FIRE_CHANGE_GUILD_NAME = 28
GUILD_FIRE_DANGER = 20
GUILD_FIRE_INFO = 18
GUILD_FIRE_METALHP = 21
GUILD_FIRE_RESTART = 24
GUILD_FIRE_STATUS = 25
GUILD_FIRE_STOP = 19
GUILD_RAID_GATE_OPT = 17
GUILD_RAID_USER_INFO = 16
GVG_CANCEL_BUILDING = 122
GVG_CONSTRUCT_BUILDING = 120
GVG_DATA_SYNC_CMD = 26
GVG_DATA_UPDATE_CMD = 27
GVG_DATE_BATTLE_INFO_SYNC = 181
GVG_LEVELUP_BUILDING = 121
GVG_MORALE_UPDATE = 125
GVG_MVP_INFO_UPDATE = 164
GVG_PERFECT_STATE_UPDATE = 133
GVG_POINT_STATE_UPDATE = 119
GVG_ROADBLOCK_CHANGE = 145
GVG_STATE_UPDATE = 123
GVG_USE_BUILDING = 124
GetRewardStageUserCmd = protobuf.Message(GETREWARDSTAGEUSERCMD)
GroupRaidFourthGoOuterCmd = protobuf.Message(GROUPRAIDFOURTHGOOUTERCMD)
GroupRaidFourthShowData = protobuf.Message(GROUPRAIDFOURTHSHOWDATA)
GroupRaidShowData = protobuf.Message(GROUPRAIDSHOWDATA)
GroupRaidStateSyncFuBenCmd = protobuf.Message(GROUPRAIDSTATESYNCFUBENCMD)
GroupRaidTeamShowData = protobuf.Message(GROUPRAIDTEAMSHOWDATA)
GuildFireCalmFubenCmd = protobuf.Message(GUILDFIRECALMFUBENCMD)
GuildFireDangerFubenCmd = protobuf.Message(GUILDFIREDANGERFUBENCMD)
GuildFireInfoFubenCmd = protobuf.Message(GUILDFIREINFOFUBENCMD)
GuildFireMetalHpFubenCmd = protobuf.Message(GUILDFIREMETALHPFUBENCMD)
GuildFireNewDefFubenCmd = protobuf.Message(GUILDFIRENEWDEFFUBENCMD)
GuildFireRestartFubenCmd = protobuf.Message(GUILDFIRERESTARTFUBENCMD)
GuildFireStatusFubenCmd = protobuf.Message(GUILDFIRESTATUSFUBENCMD)
GuildFireStopFubenCmd = protobuf.Message(GUILDFIRESTOPFUBENCMD)
GuildGateData = protobuf.Message(GUILDGATEDATA)
GuildGateOptCmd = protobuf.Message(GUILDGATEOPTCMD)
GuildLeaderPos = protobuf.Message(GUILDLEADERPOS)
GvgCrystalInfo = protobuf.Message(GVGCRYSTALINFO)
GvgCrystalUpdateFubenCmd = protobuf.Message(GVGCRYSTALUPDATEFUBENCMD)
GvgData = protobuf.Message(GVGDATA)
GvgDataSyncCmd = protobuf.Message(GVGDATASYNCCMD)
GvgDataUpdateCmd = protobuf.Message(GVGDATAUPDATECMD)
GvgDateBattleBloodInfo = protobuf.Message(GVGDATEBATTLEBLOODINFO)
GvgDateBattleDeathInfo = protobuf.Message(GVGDATEBATTLEDEATHINFO)
GvgDateBattleInfoSyncCmd = protobuf.Message(GVGDATEBATTLEINFOSYNCCMD)
GvgDefNameChangeFubenCmd = protobuf.Message(GVGDEFNAMECHANGEFUBENCMD)
GvgGuildInfo = protobuf.Message(GVGGUILDINFO)
GvgMetalDieFubenCmd = protobuf.Message(GVGMETALDIEFUBENCMD)
GvgMvpInfoUpdateCmd = protobuf.Message(GVGMVPINFOUPDATECMD)
GvgPerfectStateUpdateFubenCmd = protobuf.Message(GVGPERFECTSTATEUPDATEFUBENCMD)
GvgPointInfo = protobuf.Message(GVGPOINTINFO)
GvgPointUpdateFubenCmd = protobuf.Message(GVGPOINTUPDATEFUBENCMD)
GvgRaidStateUpdateFubenCmd = protobuf.Message(GVGRAIDSTATEUPDATEFUBENCMD)
GvgTowerData = protobuf.Message(GVGTOWERDATA)
GvgTowerUpdateFubenCmd = protobuf.Message(GVGTOWERUPDATEFUBENCMD)
GvgTowerValue = protobuf.Message(GVGTOWERVALUE)
INVITE_ROLL_RAID_REWARD = 82
INVITE_SUMMON_DEADBOSS = 40
InviteRollRewardFubenCmd = protobuf.Message(INVITEROLLREWARDFUBENCMD)
InviteSummonBossFubenCmd = protobuf.Message(INVITESUMMONBOSSFUBENCMD)
JOIN_FUBEN_USER_CMD = 10
KUMAMOTO_OPER_CMD = 58
KillNum = protobuf.Message(KILLNUM)
KumamotoOperFubenCmd = protobuf.Message(KUMAMOTOOPERFUBENCMD)
LEAVE_FUBEN_USER_CMD = 3
LastBossSceneInfo = protobuf.Message(LASTBOSSSCENEINFO)
LayerMonsterTowerPrivate = protobuf.Message(LAYERMONSTERTOWERPRIVATE)
LayerRewardTowerPrivate = protobuf.Message(LAYERREWARDTOWERPRIVATE)
LeaveFuBenUserCmd = protobuf.Message(LEAVEFUBENUSERCMD)
MONSTER_COUNT_USER_CMD = 11
MULTI_BOSS_PHASE = 106
MULTI_BOSS_STAT = 107
MVPBATTLE_BOSS_DIE = 30
MVPBATTLE_END_REPORT = 38
MVPBATTLE_SYNC_MVPINFO = 29
MemoryEquipRewardInfo = protobuf.Message(MEMORYEQUIPREWARDINFO)
MonsterCountUserCmd = protobuf.Message(MONSTERCOUNTUSERCMD)
MultiBossPhaseFubenCmd = protobuf.Message(MULTIBOSSPHASEFUBENCMD)
MultiBossRaidStatData = protobuf.Message(MULTIBOSSRAIDSTATDATA)
MvpBattleReportFubenCmd = protobuf.Message(MVPBATTLEREPORTFUBENCMD)
MvpBattleTeamData = protobuf.Message(MVPBATTLETEAMDATA)
OBSERVER_ATTACH = 101
OBSERVER_FLASH = 100
OBSERVER_SELECT = 102
OB_CAMERA_MOVE_END = 109
OB_CAMERA_MOVE_PREPARE = 108
OB_HPSP_UPDATE = 104
OB_PLAYER_OFFLINE = 105
OCCUPY_POINT_DATA_UPDATE = 158
OPEN_NTF = 144
OTHELLO_END_REPORT = 67
OTHELLO_POINT_OCCUPY_POWER = 64
OTHELLO_SYNC_INFO = 65
ObCameraMoveEndCmd = protobuf.Message(OBCAMERAMOVEENDCMD)
ObHpspUpdateFubenCmd = protobuf.Message(OBHPSPUPDATEFUBENCMD)
ObMoveCameraPrepareCmd = protobuf.Message(OBMOVECAMERAPREPARECMD)
ObPlayerOfflineFubenCmd = protobuf.Message(OBPLAYEROFFLINEFUBENCMD)
ObserverAttachFubenCmd = protobuf.Message(OBSERVERATTACHFUBENCMD)
ObserverFlashFubenCmd = protobuf.Message(OBSERVERFLASHFUBENCMD)
ObserverSelectFubenCmd = protobuf.Message(OBSERVERSELECTFUBENCMD)
OccupyPointData = protobuf.Message(OCCUPYPOINTDATA)
OccupyPointDataUpdate = protobuf.Message(OCCUPYPOINTDATAUPDATE)
OpenNtfFuBenCmd = protobuf.Message(OPENNTFFUBENCMD)
OthelloInfoSyncData = protobuf.Message(OTHELLOINFOSYNCDATA)
OthelloInfoSyncFubenCmd = protobuf.Message(OTHELLOINFOSYNCFUBENCMD)
OthelloOccupyItem = protobuf.Message(OTHELLOOCCUPYITEM)
OthelloPointOccupyPowerFubenCmd = protobuf.Message(OTHELLOPOINTOCCUPYPOWERFUBENCMD)
OthelloRaidTeamInfo = protobuf.Message(OTHELLORAIDTEAMINFO)
OthelloRaidUserInfo = protobuf.Message(OTHELLORAIDUSERINFO)
OthelloReportFubenCmd = protobuf.Message(OTHELLOREPORTFUBENCMD)
PICKUP_PVE_RAID_ACHIEVE = 128
POS_SYNC = 87
PRE_REPLY_ROLL_RAID_REARD = 85
PVE_PASS_INFO = 118
PVE_RAID_ACHIEVE = 126
PassEquip = protobuf.Message(PASSEQUIP)
PassEquipItem = protobuf.Message(PASSEQUIPITEM)
PassInfo = protobuf.Message(PASSINFO)
PickupPveRaidAchieveFubenCmd = protobuf.Message(PICKUPPVERAIDACHIEVEFUBENCMD)
PlayerHpSpUpdate = protobuf.Message(PLAYERHPSPUPDATE)
PosData = protobuf.Message(POSDATA)
PosSyncFubenCmd = protobuf.Message(POSSYNCFUBENCMD)
PreReplyRollRewardFubenCmd = protobuf.Message(PREREPLYROLLREWARDFUBENCMD)
PveCardPassInfo = protobuf.Message(PVECARDPASSINFO)
PveCardRewardTimesItem = protobuf.Message(PVECARDREWARDTIMESITEM)
PvePassInfo = protobuf.Message(PVEPASSINFO)
PvePassShowReward = protobuf.Message(PVEPASSSHOWREWARD)
PveRaidAchieve = protobuf.Message(PVERAIDACHIEVE)
PvpStatData = protobuf.Message(PVPSTATDATA)
QUERY_PVP_STAT = 159
QUERY_RAID_OTHELLO_USERINFO = 66
QUERY_RAID_TEAMPWS_USERINFO = 42
QUICK_FINISH_CRACK = 127
QUICK_FINISH_PVERAID = 131
QueryComodoTeamRaidStat = protobuf.Message(QUERYCOMODOTEAMRAIDSTAT)
QueryElementRaidStat = protobuf.Message(QUERYELEMENTRAIDSTAT)
QueryGroupRaidFourthShowData = protobuf.Message(QUERYGROUPRAIDFOURTHSHOWDATA)
QueryGvgTowerInfoFubenCmd = protobuf.Message(QUERYGVGTOWERINFOFUBENCMD)
QueryMultiBossRaidStat = protobuf.Message(QUERYMULTIBOSSRAIDSTAT)
QueryOthelloUserInfoFubenCmd = protobuf.Message(QUERYOTHELLOUSERINFOFUBENCMD)
QueryPvpStatCmd = protobuf.Message(QUERYPVPSTATCMD)
QueryTeamGroupRaidUserInfo = protobuf.Message(QUERYTEAMGROUPRAIDUSERINFO)
QueryTeamPwsUserInfoFubenCmd = protobuf.Message(QUERYTEAMPWSUSERINFOFUBENCMD)
QuickFinishCrackRaidFubenCmd = protobuf.Message(QUICKFINISHCRACKRAIDFUBENCMD)
QuickFinishPveRaidFubenCmd = protobuf.Message(QUICKFINISHPVERAIDFUBENCMD)
RAID_KILL_NUM_SYNC = 110
RAID_STAGE_SYNC = 62
RAID_START_FIGHT = 180
RELIVE_CD = 86
REPLY_ROLL_RAID_REARD = 83
REPLY_SUMMON_DEADBOSS = 41
REQ_ENTER_TOWERPRIVATE = 88
RESET_RAID = 135
RESULT_SYNC = 93
ROGUELIKE_SYNC_UNLOCKSCENES = 68
RaidItemSyncCmd = protobuf.Message(RAIDITEMSYNCCMD)
RaidItemUpdateCmd = protobuf.Message(RAIDITEMUPDATECMD)
RaidKillNumSyncCmd = protobuf.Message(RAIDKILLNUMSYNCCMD)
RaidPConfig = protobuf.Message(RAIDPCONFIG)
RaidShopUpdateCmd = protobuf.Message(RAIDSHOPUPDATECMD)
RaidStageSyncFubenCmd = protobuf.Message(RAIDSTAGESYNCFUBENCMD)
RaidStartFightCmd = protobuf.Message(RAIDSTARTFIGHTCMD)
RankScore = protobuf.Message(RANKSCORE)
ReliveCdFubenCmd = protobuf.Message(RELIVECDFUBENCMD)
ReplyRollRewardFubenCmd = protobuf.Message(REPLYROLLREWARDFUBENCMD)
ReplySummonBossFubenCmd = protobuf.Message(REPLYSUMMONBOSSFUBENCMD)
ReqEnterTowerPrivate = protobuf.Message(REQENTERTOWERPRIVATE)
ResetRaidFubenCmd = protobuf.Message(RESETRAIDFUBENCMD)
ResultSyncFubenCmd = protobuf.Message(RESULTSYNCFUBENCMD)
RewardItemData = protobuf.Message(REWARDITEMDATA)
RoadblocksChangeFubenCmd = protobuf.Message(ROADBLOCKSCHANGEFUBENCMD)
RoguelikeUnlockSceneSync = protobuf.Message(ROGUELIKEUNLOCKSCENESYNC)
SKIL_ANIMATION = 141
STAGE_STEP_STAR_USER_CMD = 9
START_STAGE_USER_CMD = 7
STIDropSkillCmd = protobuf.Message(STIDROPSKILLCMD)
STIExecSkillUpgradeCmd = protobuf.Message(STIEXECSKILLUPGRADECMD)
STIGetUpgradeOptionsCmd = protobuf.Message(STIGETUPGRADEOPTIONSCMD)
STIRefreshUpgradeOptionsCmd = protobuf.Message(STIREFRESHUPGRADEOPTIONSCMD)
STIRetUpgradeOptionsCmd = protobuf.Message(STIRETUPGRADEOPTIONSCMD)
STISkillInfo = protobuf.Message(STISKILLINFO)
STISyncAvailableUpgradeNumberCmd = protobuf.Message(STISYNCAVAILABLEUPGRADENUMBERCMD)
STISyncScoreCmd = protobuf.Message(STISYNCSCORECMD)
STISyncSkillCmd = protobuf.Message(STISYNCSKILLCMD)
STI_DROP_SKILL = 178
STI_EXEC_SKILL_UPGRADE = 174
STI_GET_SKILL_UPGRADE_OPTIONS = 172
STI_REFRESH_SKILL_UPGRADE_OPTIONS = 177
STI_RET_SKILL_UPGRADE_OPTIONS = 173
STI_SYNC_AVAILABLE_UPGRADE_NUMBER = 171
STI_SYNC_SCORE = 169
STI_SYNC_SKILL = 170
SUB_STAGE_USER_CMD = 6
SUCCESS_FUBEN_USER_CMD = 4
SUPERGVG_INFO_SYNC = 32
SUPERGVG_METALINFO_UPDATE = 34
SUPERGVG_METAL_DIE = 39
SUPERGVG_QUERY_TOWERINFO = 35
SUPERGVG_QUERY_USER_DATA = 37
SUPERGVG_REWARD_INFO = 36
SUPERGVG_TOWERINFO_UPDATE = 33
SYNC_BOSS_SCENE_BOSS = 134
SYNC_EMOTION_FACTORS = 137
SYNC_FULL_FIRE_STATE = 155
SYNC_GVG_FIGHT_POINT = 167
SYNC_GVG_LEADER_POS = 168
SYNC_MEMORY_EQUIP_REWARD_INFO = 184
SYNC_MONSTER_COUNT = 140
SYNC_PASS_USER = 152
SYNC_PVECARD_DIFFTIMES = 132
SYNC_PVECARD_OPENSTATE = 130
SYNC_SPACETIME_ILLUSION_EXP_LEVEL = 176
SYNC_SPACETIME_ILLUSION_INFO = 175
SYNC_START_FIGHT_STATE = 166
SYNC_STAR_ARK_INFO = 142
SYNC_STAR_ARK_STATISTICS = 143
SYNC_TRIPLE_CAMP_INFO = 150
SYNC_TRIPLE_COMBO_KILL = 147
SYNC_TRIPLE_ENTER_COUNT = 151
SYNC_TRIPLE_FIGHTING_INFO = 154
SYNC_TRIPLE_FIRE_INFO = 146
SYNC_TRIPLE_PLAYER_MODEL = 148
SYNC_TRIPLE_PROFESSION_TIME = 149
SYNC_UNLOCK_ROOMIDS = 139
SYNC_VISIT_NPC = 138
SelectTeamPwsMagicFubenCmd = protobuf.Message(SELECTTEAMPWSMAGICFUBENCMD)
SkipAnimationFuBenCmd = protobuf.Message(SKIPANIMATIONFUBENCMD)
StageHardStepItem = protobuf.Message(STAGEHARDSTEPITEM)
StageNormalStepItem = protobuf.Message(STAGENORMALSTEPITEM)
StageStepItem = protobuf.Message(STAGESTEPITEM)
StageStepStarUserCmd = protobuf.Message(STAGESTEPSTARUSERCMD)
StageStepUserCmd = protobuf.Message(STAGESTEPUSERCMD)
StartStageUserCmd = protobuf.Message(STARTSTAGEUSERCMD)
SuccessFuBenUserCmd = protobuf.Message(SUCCESSFUBENUSERCMD)
SuperGvgQueryUserDataFubenCmd = protobuf.Message(SUPERGVGQUERYUSERDATAFUBENCMD)
SuperGvgRewardData = protobuf.Message(SUPERGVGREWARDDATA)
SuperGvgRewardInfoFubenCmd = protobuf.Message(SUPERGVGREWARDINFOFUBENCMD)
SuperGvgSyncFubenCmd = protobuf.Message(SUPERGVGSYNCFUBENCMD)
SyncBossSceneInfo = protobuf.Message(SYNCBOSSSCENEINFO)
SyncEmotionFactorsFuBenCmd = protobuf.Message(SYNCEMOTIONFACTORSFUBENCMD)
SyncFullFireStateFubenCmd = protobuf.Message(SYNCFULLFIRESTATEFUBENCMD)
SyncGvgFightPointCmd = protobuf.Message(SYNCGVGFIGHTPOINTCMD)
SyncGvgLeaderPosCmd = protobuf.Message(SYNCGVGLEADERPOSCMD)
SyncMemoryEquipRewardInfo = protobuf.Message(SYNCMEMORYEQUIPREWARDINFO)
SyncMonsterCountFuBenCmd = protobuf.Message(SYNCMONSTERCOUNTFUBENCMD)
SyncMvpInfoFubenCmd = protobuf.Message(SYNCMVPINFOFUBENCMD)
SyncPassUserInfo = protobuf.Message(SYNCPASSUSERINFO)
SyncPveCardOpenStateFubenCmd = protobuf.Message(SYNCPVECARDOPENSTATEFUBENCMD)
SyncPveCardRewardTimesFubenCmd = protobuf.Message(SYNCPVECARDREWARDTIMESFUBENCMD)
SyncPvePassInfoFubenCmd = protobuf.Message(SYNCPVEPASSINFOFUBENCMD)
SyncPveRaidAchieveFubenCmd = protobuf.Message(SYNCPVERAIDACHIEVEFUBENCMD)
SyncSpaceTimeIllusionExpLevelFuBenCmd = protobuf.Message(SYNCSPACETIMEILLUSIONEXPLEVELFUBENCMD)
SyncSpaceTimeIllusionInfoFuBenCmd = protobuf.Message(SYNCSPACETIMEILLUSIONINFOFUBENCMD)
SyncStarArkInfoFuBenCmd = protobuf.Message(SYNCSTARARKINFOFUBENCMD)
SyncStarArkStatisticsFuBenCmd = protobuf.Message(SYNCSTARARKSTATISTICSFUBENCMD)
SyncStartFightStateCmd = protobuf.Message(SYNCSTARTFIGHTSTATECMD)
SyncTripleCampInfoFuBenCmd = protobuf.Message(SYNCTRIPLECAMPINFOFUBENCMD)
SyncTripleComboKillFuBenCmd = protobuf.Message(SYNCTRIPLECOMBOKILLFUBENCMD)
SyncTripleEnterCountFuBenCmd = protobuf.Message(SYNCTRIPLEENTERCOUNTFUBENCMD)
SyncTripleFightingInfoFuBenCmd = protobuf.Message(SYNCTRIPLEFIGHTINGINFOFUBENCMD)
SyncTripleFireInfoFuBenCmd = protobuf.Message(SYNCTRIPLEFIREINFOFUBENCMD)
SyncTriplePlayerModelFuBenCmd = protobuf.Message(SYNCTRIPLEPLAYERMODELFUBENCMD)
SyncTripleProfessionTimeFuBenCmd = protobuf.Message(SYNCTRIPLEPROFESSIONTIMEFUBENCMD)
SyncUnlockRoomIDsFuBenCmd = protobuf.Message(SYNCUNLOCKROOMIDSFUBENCMD)
SyncVisitNpcInfo = protobuf.Message(SYNCVISITNPCINFO)
TEAMEXP_BUY_ITEM = 51
TEAMEXP_QUERY_INFO = 56
TEAMEXP_RAID_REPORT = 50
TEAMEXP_SYNC_CMD = 52
TEAMMEMBER_ROLL_PROCESS = 84
TEAMPWS_END_REPORT = 43
TEAMPWS_SELECT_MAGIC = 45
TEAMPWS_STATE_SYNC = 99
TEAMPWS_SYNC_INFO = 44
TEAMPWS_UPDATE_INFO = 47
TEAMPWS_UPDATE_MAGIC = 46
TEAM_GROUP_FOURTH_GOOUTER = 61
TEAM_GROUP_FOURTH_QUERY = 59
TEAM_GROUP_FOURTH_UPDATE = 60
TEAM_GROUP_RAID_CHIP = 54
TEAM_GROUP_RAID_QUERY_INFO = 55
TEAM_GROUP_RAID_STATE = 57
TEAM_RELIVE_COUNT = 53
THANKSGIVING_MONSTER_NUM = 63
TOWERPRIVATE_LAYER_COUNTDOWN_NTF = 90
TOWERPRIVATE_LAYINFO = 89
TRACK_FUBEN_USER_CMD = 1
TRANSFERFIGHT_CHOOSE = 69
TRANSFERFIGHT_END = 71
TRANSFERFIGHT_RANK = 70
TWELVEPVP_BUILDING_HP_UPDATE = 79
TWELVEPVP_DATA_SYNC = 72
TWELVEPVP_GROUP_INFO_QUERY = 77
TWELVEPVP_ITEM_SYNC = 73
TWELVEPVP_ITEM_UPDATE = 74
TWELVEPVP_QUERY_UI_OPER = 80
TWELVEPVP_QUEST_QUERY = 76
TWELVEPVP_RESULT = 78
TWELVEPVP_SHOP_UPDATE = 75
TWELVEPVP_USE_ITEM = 81
TeamExpQueryInfoFubenCmd = protobuf.Message(TEAMEXPQUERYINFOFUBENCMD)
TeamExpReportFubenCmd = protobuf.Message(TEAMEXPREPORTFUBENCMD)
TeamExpSyncFubenCmd = protobuf.Message(TEAMEXPSYNCFUBENCMD)
TeamGroupRaidUpdateChipNum = protobuf.Message(TEAMGROUPRAIDUPDATECHIPNUM)
TeamPwsInfoSyncData = protobuf.Message(TEAMPWSINFOSYNCDATA)
TeamPwsInfoSyncFubenCmd = protobuf.Message(TEAMPWSINFOSYNCFUBENCMD)
TeamPwsRaidTeamInfo = protobuf.Message(TEAMPWSRAIDTEAMINFO)
TeamPwsRaidUserInfo = protobuf.Message(TEAMPWSRAIDUSERINFO)
TeamPwsReportFubenCmd = protobuf.Message(TEAMPWSREPORTFUBENCMD)
TeamPwsStateSyncFubenCmd = protobuf.Message(TEAMPWSSTATESYNCFUBENCMD)
TeamReliveCountFubenCmd = protobuf.Message(TEAMRELIVECOUNTFUBENCMD)
TeamRollStatusFuBenCmd = protobuf.Message(TEAMROLLSTATUSFUBENCMD)
ThanksGivingMonsterFuBenCmd = protobuf.Message(THANKSGIVINGMONSTERFUBENCMD)
TowerPrivateLayerCountdownNtf = protobuf.Message(TOWERPRIVATELAYERCOUNTDOWNNTF)
TowerPrivateLayerInfo = protobuf.Message(TOWERPRIVATELAYERINFO)
TrackData = protobuf.Message(TRACKDATA)
TrackFuBenUserCmd = protobuf.Message(TRACKFUBENUSERCMD)
TransferFightChooseFubenCmd = protobuf.Message(TRANSFERFIGHTCHOOSEFUBENCMD)
TransferFightEndFubenCmd = protobuf.Message(TRANSFERFIGHTENDFUBENCMD)
TransferFightRankFubenCmd = protobuf.Message(TRANSFERFIGHTRANKFUBENCMD)
TripleCampData = protobuf.Message(TRIPLECAMPDATA)
TripleComboData = protobuf.Message(TRIPLECOMBODATA)
TripleModelData = protobuf.Message(TRIPLEMODELDATA)
TripleUserData = protobuf.Message(TRIPLEUSERDATA)
TripleUserInfo = protobuf.Message(TRIPLEUSERINFO)
TweItemInfo = protobuf.Message(TWEITEMINFO)
TwelvePvpBuildingHpUpdateCmd = protobuf.Message(TWELVEPVPBUILDINGHPUPDATECMD)
TwelvePvpData = protobuf.Message(TWELVEPVPDATA)
TwelvePvpGroupInfo = protobuf.Message(TWELVEPVPGROUPINFO)
TwelvePvpQueryGroupInfoCmd = protobuf.Message(TWELVEPVPQUERYGROUPINFOCMD)
TwelvePvpQuestData = protobuf.Message(TWELVEPVPQUESTDATA)
TwelvePvpQuestQueryCmd = protobuf.Message(TWELVEPVPQUESTQUERYCMD)
TwelvePvpResultCmd = protobuf.Message(TWELVEPVPRESULTCMD)
TwelvePvpSyncCmd = protobuf.Message(TWELVEPVPSYNCCMD)
TwelvePvpUIOperCmd = protobuf.Message(TWELVEPVPUIOPERCMD)
TwelvePvpUseItemCmd = protobuf.Message(TWELVEPVPUSEITEMCMD)
TwelvePvpUserInfo = protobuf.Message(TWELVEPVPUSERINFO)
UpdateGroupRaidFourthShowData = protobuf.Message(UPDATEGROUPRAIDFOURTHSHOWDATA)
UpdateTeamPwsInfoFubenCmd = protobuf.Message(UPDATETEAMPWSINFOFUBENCMD)
UpdateUserNumFubenCmd = protobuf.Message(UPDATEUSERNUMFUBENCMD)
UserGuildRaidFubenCmd = protobuf.Message(USERGUILDRAIDFUBENCMD)
WORLD_STAGE_USER_CMD = 5
WorldStageItem = protobuf.Message(WORLDSTAGEITEM)
WorldStageUserCmd = protobuf.Message(WORLDSTAGEUSERCMD)
