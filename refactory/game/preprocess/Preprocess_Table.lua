function Game.Preprocess_Table()
  Game.Preprocess_BranchConfig()
  
  Game.Preprocess_Table_ActionAnime()
  Game.Preprocess_Table_Achievement()
  Game.Preprocess_Table_BuffState()
  Game.Preprocess_Table_BuffStateOdds()
  Game.Preprocess_Table_RoleData()
  Game.Preprocess_Table_ItemType()
  Game.Preprocess_Table_Reward()
  Game.Preprocess_Table_ActionEffect()
  Game.Preprocess_Table_Deadboss()
  Game.Preprocess_EquipRecovery()
  Game.Preprocess_Menu()
  Game.Preprocess_Pet()
  Game.Preprocess_PoemStep()
  Game.Preprocess_FuncState()
  Game.Preprocess_CameraPlot()
  Game.Preprocess_PaySign()
  Game.Preprocess_GuildFunction()
  Game.Preprocess_HairStyle()
  Game.Preprocess_PveEntrance()
  Game.Preprocess_GuildStrongHold()
  Game.Preprocess_DateBattleCity()
  Game.Preprocess_BossSceneMonster()
  Game.Preprocess_HeadwearRepair()
  Game.Preprocess_Card()
  Game.Preprocess_AppleStore_Verify()
  Game.Preprocess_Table_Deposit()
  Game.Preprocess_Table_Wallet()
  Game.Preprocess_EnchantMustBuff()
  Game.Preprocess_ChatKeyEffect()
  Game.Preprocess_TaskLimit()
  Game.Preprocess_VersionGoal()
  Game.Preprocess_ActivityJournal()
  Game.Preprocess_FishingBuff()
  Game.Preprocess_SkillSolution()
  Game.Preprocess_MatchRaid()
  Game.Preprocess_Table_AfricanPoringPos()
  Game.Preprocess_Table_MountFashion()
  Game.Preprocess_Table_HeadwearRepair()
  Game.Preprocess_Table_BWMapZone()
  Game.Preprocess_Table_WindowsHotKeyDisplay()
  Game.Preprocess_Table_FateSelectPool()
  Game.Preprocess_Table_WindowsHotKey()
  Game.Preprocess_ItemMemory()
  Game.Preprocess_Table_EndlessBattleFieldEvent()
  Game.Preprocess_Table_HeroJourney()
  Game.Preprocess_Table_AstralDestinyGraph()
  Game.Preprocess_Table_TriplePvpRobot()
  Game.Preprocess_Table_CardLevel()
  Game.Preprocess_Table_SpaceTimeIllusionSkills()
end

function Game.Preprocess_TableByTime()
  Game.Preprocess_FuncTime()
end

local starttime = 1
local endtime = 1
local EffectLodPaths = Table_EffectLodPaths or {}
local PreprocessEffectPaths = function(paths, prefix)
  if nil ~= paths then
    if prefix then
      paths[1] = prefix .. paths[1]
    end
    local cachedPaths = EffectLodPaths[paths[1]]
    if cachedPaths then
      return cachedPaths
    end
    if paths[3] ~= nil then
      for i = 2, 3 do
        if paths[i] == "none" or paths[i] == nil or paths[i] == "" then
          paths[i] = paths[1]
        else
          paths[i] = prefix and prefix .. paths[i] or paths[i]
        end
      end
    else
      if paths[2] == "none" or paths[2] == nil or paths[2] == "" then
        paths[3] = paths[1]
      else
        paths[3] = prefix and prefix .. paths[2] or paths[2]
      end
      paths[2] = paths[1]
    end
    EffectLodPaths[paths[1]] = paths
  end
  return paths
end
Game.PreprocessEffectPaths = PreprocessEffectPaths
local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]
local RemoveConfigByBranch = function(mapConfig, config, tablename)
  if mapConfig and config then
    for k, v in pairs(mapConfig) do
      if 0 < v & myBranchValue then
        config[k] = nil
      end
    end
  end
end
local g_table
local forbidCfg = GameConfig.Forbid
local HandleForbidByType1 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, indexCfg in pairs(cfg) do
      if type(indexCfg) ~= "table" or #indexCfg ~= 2 then
        redlog("配置格式出错，ftype_start_end 类型只能配置table类型,只有起始ID、截止ID")
        return
      end
      if 0 < bit & myBranchValue then
        for tabKey, _ in pairs(tab) do
          if tabKey >= indexCfg[1] and tabKey <= indexCfg[2] then
            if nil == tab[tabKey] then
              redlog("屏蔽配置为空! ", tabName, " 屏蔽类型ftype_start_end，错误ID: ", tabKey)
            else
              tab[tabKey] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType2 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, startID in pairs(cfg) do
      if type(startID) ~= "number" then
        redlog("配置格式出错，ftype_start 类型只能配置number类型起始ID）")
        return
      end
      if 0 < bit & myBranchValue then
        for tabKey, _ in pairs(tab) do
          if startID <= tabKey then
            if nil == tab[tabKey] then
              redlog("屏蔽配置为空! ", tabName, " 类型ftype_start，错误ID: ", tabKey)
            else
              tab[tabKey] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType3 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, ftab in pairs(cfg) do
      if 0 < bit & myBranchValue then
        if type(ftab) ~= "table" then
          redlog("配置格式出错，ftype_id 类型只能配置table类型的ID集合")
          return
        end
        for i = 1, #ftab do
          if nil == tab[ftab[i]] then
            redlog("屏蔽配置为空! ", tabName, " 类型ftype_id，错误ID: ", ftab[i])
          else
            tab[ftab[i]] = nil
          end
        end
      end
    end
  end
end
local HandleForbidByType4 = function(cfg, tab, tabName)
  if cfg and tab then
    local tName = "Table_" .. tabName
    local exitSTab = nil ~= _G[tName .. "_s"]
    tab = exitSTab and _G[tName .. "_s"] or tab
    for bit, singleCfg in pairs(cfg) do
      if 0 < bit & myBranchValue then
        for i = 1, #singleCfg do
          local cfg = singleCfg[i]
          local dirtyArray = {}
          for k, v in pairs(tab) do
            dirtyArray[k] = false
          end
          for cfgK, cfgV in pairs(cfg) do
            for tabK, tabV in pairs(tab) do
              local tV = exitSTab and StrTablesManager.GetData(tName, tabK) or tabV
              if tV[cfgK] ~= cfgV then
                dirtyArray[tabK] = true
              end
            end
          end
          for key, flag in pairs(dirtyArray) do
            if false == flag then
              tab[key] = nil
            end
          end
        end
      end
    end
  end
end
local HandleForbidByType5 = function(cfg, tab, tabName)
  if cfg and tab then
    for bit, ftab in pairs(cfg) do
      if 0 < bit & myBranchValue then
        if type(ftab) ~= "table" then
          redlog("配置格式出错，ftype_petAvatar 类型只能配置table类型的ID集合")
          return
        end
        for i = 1, #ftab do
          for bodyID, bodyTab in pairs(tab) do
            for partId, partTab in pairs(bodyTab) do
              for k, v in pairs(partTab) do
                if v.id == ftab[i] then
                  tab[bodyID][partId][k].forbidFlag = true
                end
              end
            end
          end
        end
      end
    end
  end
end

function Game.Preprocess_BranchConfig()
  if GameConfig.BranchForbid then
    local g_table
    for k, v in pairs(GameConfig.BranchForbid) do
      for tablename, t in pairs(v) do
        g_table = _G["Table_" .. tablename]
        if g_table then
          RemoveConfigByBranch(t, g_table)
        end
      end
    end
  end
  local forbidHandle = {}
  forbidHandle.ftype_start_end = HandleForbidByType1
  forbidHandle.ftype_start = HandleForbidByType2
  forbidHandle.ftype_id = HandleForbidByType3
  forbidHandle.ftype_params = HandleForbidByType4
  forbidHandle.ftype_petAvatar = HandleForbidByType5
  if forbidCfg then
    for tabName, forbid_cfg in pairs(forbidCfg) do
      g_table = _G["Table_" .. tabName]
      if g_table then
        for ftype, v in pairs(forbid_cfg) do
          local call = forbidHandle[ftype]
          if call then
            call(v, g_table, tabName)
          else
            redlog("屏蔽配置类型填写错误，", tabName, "错误类型：", ftype)
          end
        end
      end
    end
  end
  if GameConfig.SystemForbid then
    for k, v in pairs(GameConfig.SystemForbid) do
      GameConfig.SystemForbid[k] = 0 < v & myBranchValue and true or false
    end
  else
    GameConfig.SystemForbid = {}
  end
end

function Game.Preprocess_Table_RoleData()
  local propNameConfig = {}
  for k, v in pairs(Table_RoleData) do
    propNameConfig[v.VarName] = v
  end
  Game.Config_PropName = propNameConfig
end

function Game.Preprocess_Table_ActionAnime()
  local actionConfig = {}
  for k, v in pairs(Table_ActionAnime) do
    actionConfig[v.Name] = v
  end
  Game.Config_Action = actionConfig
  local buffMap, buffConfig = {}, GameConfig.TwinsAction.ready_buff
  if buffConfig then
    for actId, buff in pairs(buffConfig) do
      buffMap[buff] = actId
    end
  end
  Game.Config_DoubleActionBuff = buffMap
  local actionMap, pairConfig = {}, GameConfig.TwinsAction.pair
  if pairConfig then
    for active, passive in pairs(pairConfig) do
      actionMap[passive] = active
    end
  end
  Game.Config_PassiveDoubleAction = actionMap
end

function Game.Preprocess_Table_Deposit()
  for k, v in pairs(Table_Deposit) do
    if v.IsHide and v.IsHide == 1 then
      Table_Deposit[k] = nil
    end
  end
  if BranchMgr.IsChina() then
    return
  end
  local suffixs
  if BranchMgr.IsNO() then
    suffixs = {"_WW"}
  else
    if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android or ApplicationInfo:IsWindows() then
      return
    end
    suffixs = {"_iOS", "_VN"}
  end
  for _, v in pairs(Table_Deposit) do
    for ik, _ in pairs(v) do
      for _, suffix in pairs(suffixs) do
        local nik = ik .. suffix
        if not v[nik] or type(v[nik]) == "string" and v[nik] == "" then
        else
          v[ik] = v[nik]
          v[nik] = nil
        end
      end
    end
  end
end

function Game.Preprocess_Table_Wallet()
  local config = {}
  for k, v in pairs(Table_Wallet) do
    config[v.ItemID] = v
  end
  Game.Config_Wallet = config
end

function Game.Preprocess_Table_Achievement()
  local titleAchievemnetConfig = {}
  for k, v in pairs(Table_Achievement) do
    if v.RewardItems and v.RewardItems[1] and v.RewardItems[1][1] then
      local titleID = v.RewardItems[1][1]
      titleAchievemnetConfig[titleID] = v
    end
  end
  Game.Config_TitleAchievemnet = titleAchievemnetConfig
end

function Game.Preprocess_Table_BuffState()
  local buffConfig = {}
  for k, v in pairs(Table_BuffState) do
    local config = {
      Effect_start = PreprocessEffectPaths(StringUtil.Split(v.Effect_start, ",")),
      Effect_startAt = PreprocessEffectPaths(StringUtil.Split(v.Effect_startAt, ",")),
      Effect_hit = PreprocessEffectPaths(StringUtil.Split(v.Effect_hit, ",")),
      Effect_end = PreprocessEffectPaths(StringUtil.Split(v.Effect_end, ",")),
      Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
      Effect_around = PreprocessEffectPaths(StringUtil.Split(v.Effect_around, ",")),
      EffectGroup = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup, ",")),
      EffectGroup_around = PreprocessEffectPaths(StringUtil.Split(v.EffectGroup_around, ","))
    }
    buffConfig[k] = config
  end
  Game.Config_BuffState = buffConfig
end

function Game.Preprocess_Table_BuffStateOdds()
  local buffConfig = {}
  for k, v in pairs(Table_BuffStateOdds) do
    local config = {
      Effect = PreprocessEffectPaths(StringUtil.Split(v.Effect, ",")),
      EP = v.EP
    }
    buffConfig[k] = config
  end
  Game.Config_BuffStateOdds = buffConfig
end

function Game.Preprocess_Table_Reward()
  Game.Config_RewardTeam = Table_Reward
end

function Game.Preprocess_Table_ItemType()
  local types = {}
  local t
  for k, v in pairs(Table_ItemType) do
    if v.Typegroup then
      t = types[v.Typegroup]
      if t == nil then
        t = {}
        types[v.Typegroup] = t
      end
      t[#t + 1] = v.id
    end
  end
  Game.Config_ItemTypeGroup = types
end

function Game.Preprocess_Table_ActionEffect()
  local actionConfig = {}
  for k, v in pairs(Table_ActionEffect) do
    local config = actionConfig[v.BodyID]
    if config == nil then
      config = {}
      actionConfig[v.BodyID] = config
    end
    config[#config + 1] = v.id
  end
  Game.Config_ActionEffect = actionConfig
end

function Game.Preprocess_Table_Deadboss()
  local cfg = {}
  for _, v in pairs(Table_Deadboss) do
    local config = cfg[v.MonsterID]
    if not config then
      config = {}
      cfg[v.MonsterID] = config
    end
    config[v.DeadBoss_lv] = v
  end
  Game.Config_Deadboss = cfg
end

function Game.Preprocess_AppleStore_Verify()
  if not Game.inAppStoreReview then
    return
  end
  if Table_Npc then
    local npc_2156 = Table_Npc[2156]
    local npcFunction = npc_2156 and npc_2156.NpcFunction
    if npcFunction then
      for i = #npcFunction, 1, -1 do
        if npcFunction[i] and npcFunction[i].type == 4025 then
          table.remove(npcFunction, i)
          break
        end
      end
    end
  end
end

function Game._deepCopy(srt, ret)
  for k, v in pairs(srt) do
    if type(v) == "table" then
      if type(ret[k]) == "table" then
        Game._deepCopy(v, ret[k])
      else
        ret[k] = v
      end
    else
      ret[k] = v
    end
  end
end

function Game.Preprocess_Equip()
  Game.Config_BodyGender = {}
  for _, v in pairs(Table_Class) do
    if v.MaleBody then
      Game.Config_BodyGender[v.MaleBody] = 1
    end
    if v.FemaleBody and not Game.Config_BodyGender[v.FemaleBody] then
      Game.Config_BodyGender[v.FemaleBody] = 2
    end
  end
  Game.Config_BodyDisplay = {}
  for _, v in pairs(Table_Equip) do
    if v.Body then
      for _, value in pairs(v.Body) do
        Game.Config_BodyGender[value] = v.SexEquip or 1
        if v.display and v.display[1] and v.display[1] > 0 then
          Game.Config_BodyDisplay[value] = v.display[1]
        end
      end
    end
  end
  Game.Config_EquipGender = {}
  Game.Config_EquipMale2FemaleMap = {}
  for k, v in pairs(Table_EquipGender) do
    Game.Config_EquipGender[v.male] = v.female
    Game.Config_EquipMale2FemaleMap[v.male] = v.female
    Game.Config_EquipGender[v.female] = v.male
  end
  ClearTableFromG("Table_EquipGender")
end

function Game.Preprocess_EquipRecovery()
  local cfg, equipId, lv, config = {}
  for k, v in pairs(Table_EquipRecovery) do
    equipId = math.floor(k / 100)
    lv = k - equipId * 100
    config = cfg[equipId]
    if not config then
      config = {}
      cfg[equipId] = config
    end
    config[lv] = v
  end
  Game.Config_EquipRecovery = cfg
  ClearTableFromG("Table_EquipRecovery")
end

function Game.Preprocess_Pet()
  local map = {}
  for k, v in pairs(Table_Pet) do
    if v.EggID then
      if map[v.EggID] == nil then
        map[v.EggID] = v
      else
        redlog("One pet egg ID corresponds to multiple pet eggs", v.EggID)
      end
    end
  end
  Game.Config_EggPet = map
end

function Game.Preprocess_Menu()
  Game.Config_UnlockActionIds = {}
  Game.Config_UnlockEmojiIds = {}
  Game.FoundElfConfigs = {}
  Game.abyssLakeFoundElfConfigs = {}
  for k, v in pairs(Table_Menu) do
    local evt = v.event
    if evt then
      if evt.type == "unlockaction" then
        if evt.param then
          for k1, v1 in pairs(evt.param) do
            Game.Config_UnlockActionIds[v1] = 1
          end
        end
      elseif evt.type == "unlockexpression" and evt.param then
        for k1, v1 in pairs(evt.param) do
          Game.Config_UnlockEmojiIds[v1] = 1
        end
      end
    end
    if v.Condition then
      if v.Condition.found_elf_num then
        table.insert(Game.FoundElfConfigs, v)
      end
      if v.Condition.found_abyss_lake_elf_num then
        table.insert(Game.abyssLakeFoundElfConfigs, v)
      end
    end
  end
  table.sort(Game.FoundElfConfigs, function(l, r)
    return l.Condition.found_elf_num < r.Condition.found_elf_num
  end)
  table.sort(Game.abyssLakeFoundElfConfigs, function(l, r)
    return l.Condition.found_abyss_lake_elf_num < r.Condition.found_abyss_lake_elf_num
  end)
end

function Game.Preprocess_PoemStory()
  local qid = 0
  for k, v in pairs(Table_PomeStory) do
    local checkmap = {}
    if v.QuestID then
      for i = 1, #v.QuestID do
        qid = math.modf(v.QuestID[i] / 10000)
        if not checkmap[qid] then
          checkmap[qid] = qid
        end
      end
    end
    if v.NoMustQuestID then
      for i = 1, #v.NoMustQuestID do
        local Nolist1 = v.NoMustQuestID[1]
        local Nolist2 = v.NoMustQuestID[2]
        for j = 1, #Nolist1 do
          qid = math.modf(Nolist1[j] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
        for k = 1, #Nolist2 do
          qid = math.modf(Nolist2[k] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
      end
    end
    if not v.CheckList then
      v.CheckList = {}
      for n, m in pairs(checkmap) do
        table.insert(v.CheckList, m)
      end
    end
  end
end

function Game.Preprocess_PoemStep()
  Game.PoemStepDic = {}
  for k, v in pairs(Table_PoemStep) do
    if not Game.PoemStepDic[v.Questid] then
      Game.PoemStepDic[v.Questid] = {}
    end
    table.insert(Game.PoemStepDic[v.Questid], v.id)
  end
  for k, v in pairs(Table_PomeStory) do
    local showlist = {}
    local option1 = {}
    local option2 = {}
    if v.QuestID then
      for i = 1, #v.QuestID do
        local steplist = Game.PoemStepDic[v.QuestID[i]]
        if steplist then
          for j = 1, #steplist do
            showlist[#showlist + 1] = steplist[j]
          end
        end
      end
    end
    if v.NoMustQuestID then
      local n1 = v.NoMustQuestID[1]
      local n2 = v.NoMustQuestID[2]
      if n1 then
        for i = 1, #n1 do
          local steplistn1 = Game.PoemStepDic[n1[i]]
          if steplistn1 then
            for i = 1, #steplistn1 do
              option1[#option1 + 1] = steplistn1[i]
            end
          end
        end
      end
      if n1 then
        for i = 1, #n2 do
          local steplistn2 = Game.PoemStepDic[n2[i]]
          if steplistn2 then
            for i = 1, #steplistn2 do
              option2[#option2 + 1] = steplistn2[i]
            end
          end
        end
      end
    end
    table.sort(showlist, function(l, r)
      return l < r
    end)
    table.sort(option1, function(l, r)
      return l < r
    end)
    table.sort(option2, function(l, r)
      return l < r
    end)
    v.ShowList = showlist
    v.Option1 = option1
    v.Option2 = option2
  end
end

function Game.Preprocess_PoemStory()
  local qid = 0
  for k, v in pairs(Table_PomeStory) do
    local checkmap = {}
    if v.QuestID then
      for i = 1, #v.QuestID do
        qid = math.modf(v.QuestID[i] / 10000)
        if not checkmap[qid] then
          checkmap[qid] = qid
        end
      end
    end
    if v.NoMustQuestID then
      for i = 1, #v.NoMustQuestID do
        local Nolist1 = v.NoMustQuestID[1]
        local Nolist2 = v.NoMustQuestID[2]
        for j = 1, #Nolist1 do
          qid = math.modf(Nolist1[j] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
        for k = 1, #Nolist2 do
          qid = math.modf(Nolist2[k] / 10000)
          if not checkmap[qid] then
            checkmap[qid] = qid
          end
        end
      end
    end
    table.sort(showlist, function(l, r)
      return l < r
    end)
    table.sort(option1, function(l, r)
      return l < r
    end)
    table.sort(option2, function(l, r)
      return l < r
    end)
    v.ShowList = showlist
    v.Option1 = option1
    v.Option2 = option2
    if not v.CheckList then
      v.CheckList = {}
      for n, m in pairs(checkmap) do
        table.insert(v.CheckList, m)
      end
    end
  end
end

function Game.Preprocess_GuildFunction()
  Game.Config_UniqueGuildFunction = {}
  for k, v in pairs(Table_GuildFunction) do
    if v.UniqueID then
      Game.Config_UniqueGuildFunction[v.UniqueID] = v
    end
  end
end

function Game.Preprocess_BossSceneMonster()
  Game.BossSceneMonster = {}
  if not Table_BossSceneMonster then
    return
  end
  for k, v in pairs(Table_BossSceneMonster) do
    if v.MonsterID then
      Game.BossSceneMonster[v.MonsterID] = v
    else
      redlog("Can not find MonsterID in Table_BossSceneMonster.ID :", v.id)
    end
  end
end

function Game.Preprocess_HeadwearRepair()
  Game.HeadwearRepairTypeTable = {}
  local _config = GameConfig.MixLottery and GameConfig.MixLottery.LotteryFilter
  if not _config then
    return
  end
  for k, v in pairs(_config) do
    if v.Type then
      for i = 1, #v.Type do
        Game.HeadwearRepairTypeTable[v.Type[i]] = v
      end
    end
  end
end

function Game.Preprocess_Card()
  Game.weightCards = {}
  for k, v in pairs(Table_Card) do
    if v.Weight and v.Weight > 0 then
      table.insert(Game.weightCards, v.id)
    end
  end
end

function Game.Preprocess_PaySign()
  if not Table_PaySign then
    return
  end
  Game.Config_PaySign = {}
  local acts = {}
  for k, v in pairs(Table_PaySign) do
    if nil ~= v.ActivityID then
      acts = Game.Config_PaySign[v.ActivityID]
      if not acts then
        acts = {}
        Game.Config_PaySign[v.ActivityID] = acts
      end
      acts[#acts + 1] = v
    end
  end
end

function Game.Preprocess_HairStyle()
  Game.Item2Hair = {}
  for k, v in pairs(Table_HairStyle) do
    if v.ItemID then
      Game.Item2Hair[v.ItemID] = v.id
    end
  end
end

function Game.Preprocess_PveEntrance()
  Game.difficultyRaidMap = {}
  for k, v in pairs(Table_PveRaidEntrance) do
    if v.DifficultyName and #v.DifficultyName > 1 and v.DifficultyName[2] > 10000 then
      Game.difficultyRaidMap[v.RaidType] = 1
    end
  end
end

function Game.Preprocess_GuildStrongHold()
  Game.Config_GuildStrongHold_Lobby = {}
  Game.Config_GuildStrongHold_RaidMap = {}
  for k, v in pairs(Table_Guild_StrongHold) do
    if v.LobbyRaidID then
      Game.Config_GuildStrongHold_Lobby[v.LobbyRaidID] = v
    end
    if v.RaidId then
      Game.Config_GuildStrongHold_RaidMap[v.RaidId] = v
    end
  end
end

function Game.Preprocess_DateBattleCity()
  Game.Config_DateBattleCity_Lobby = {}
  Game.Config_DateBattleCity_RaidMap = {}
  for k, v in pairs(Table_DateBattleCity) do
    if v.LobbyRaidID then
      Game.Config_DateBattleCity_Lobby[v.LobbyRaidID] = v
    end
    if v.RaidId then
      Game.Config_DateBattleCity_RaidMap[v.RaidId] = v
    end
  end
end

function Game.Preprocess_CameraPlot()
  if not Table_CameraPlot then
    return
  end
  Game.Config_CameraPlot = {}
  local map = {}
  for k, v in pairs(Table_CameraPlot) do
    if v.groupid then
      map = Game.Config_CameraPlot[v.groupid]
      if not map then
        map = {}
        Game.Config_CameraPlot[v.groupid] = map
      end
      map[#map + 1] = v.id
    end
  end
  for k, map in pairs(Game.Config_CameraPlot) do
    table.sort(map, function(l, r)
      return l < r
    end)
  end
end

local starttime = 1
local endtime = 1

function Game.Preprocess_FuncTime()
  for k, v in pairs(Table_FuncTime) do
    if EnvChannel.IsTFBranch() then
      if v.TFStartTime then
        local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(v.TFStartTime)
        starttime = os.time({
          day = st_day,
          month = st_month,
          year = st_year,
          hour = st_hour,
          min = st_min,
          sec = st_sec
        })
        v.StartTimeStamp = starttime
      end
      if v.TFEndTime then
        local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(v.TFEndTime)
        endtime = os.time({
          day = end_day,
          month = end_month,
          year = end_year,
          hour = end_hour,
          min = end_min,
          sec = end_sec
        })
        v.EndTimeStamp = endtime
      end
    else
      if v.StartTime then
        local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(v.StartTime)
        starttime = os.time({
          day = st_day,
          month = st_month,
          year = st_year,
          hour = st_hour,
          min = st_min,
          sec = st_sec
        })
        v.StartTimeStamp = starttime
      end
      if v.EndTime then
        local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(v.EndTime)
        endtime = os.time({
          day = end_day,
          month = end_month,
          year = end_year,
          hour = end_hour,
          min = end_min,
          sec = end_sec
        })
        v.EndTimeStamp = endtime
      end
    end
  end
end

function Game.Preprocess_FuncState()
  local inputMap = {}
  local equipComposeForbidMap = {}
  local professionForbiddenMap = {}
  local branchForbiddenMap = {}
  local cacheFuncStateNpcMap = {}
  for k, v in pairs(Table_FuncState) do
    if v.NpcFunction then
      if not GameConfig.FuncStateChecklist then
        GameConfig.FuncStateChecklist = {}
      end
      local single = {}
      single.NpcFunction = v.NpcFunction
      single.id = k
      table.insert(GameConfig.FuncStateChecklist, single)
    end
    if v.NpcID and nil ~= next(v.NpcID) then
      for i = 1, #v.NpcID do
        cacheFuncStateNpcMap[v.NpcID[i]] = v.id
      end
    end
    if v.Type == "Input" then
      for i = 1, #v.Param do
        if nil == inputMap[v.Param[i]] then
          inputMap[v.Param[i]] = k
        end
      end
    elseif v.Type == "monengguanzhu" or v.Type == "monengguanzhu_2.0" or v.Type == "monengguanzhu_3.0" or v.Type == "monengguanzhu2" or v.Type == "equip_compose_forbidden" then
      for i = 1, #v.ItemID do
        equipComposeForbidMap[v.ItemID[i]] = k
      end
    elseif v.Type == "profession_Fireman_forbid" then
      for i = 1, #v.Param do
        professionForbiddenMap[v.Param[i]] = k
      end
    elseif v.Type == "equip_recommend_Fireman_forbid" then
      for i = 1, #v.Param do
        branchForbiddenMap[v.Param[i]] = k
      end
    end
    if not StringUtil.IsEmpty(v.Type) and nil ~= next(v.Param) then
      Game[v.Type] = Game[v.Type] or {}
      for i = 1, #v.Param do
        Game[v.Type][v.Param[i]] = k
      end
    end
    if not StringUtil.IsEmpty(v.Type) and nil == next(v.Param) then
      Game[v.Type] = k
    end
  end
  Game.Config_EquipComposeIDForbidMap = equipComposeForbidMap
  Game.Config_ProfessionForbidMap = professionForbiddenMap
  Game.Config_BranchForbidMap = branchForbiddenMap
  Game.Config_InputFuncState = inputMap
  Game.Config_FuncStateNpcMap = cacheFuncStateNpcMap
end

function Game.Preprocess_ChatKeyEffect()
  local pattern = "(%d+)/(%d+)/(%d+)/(%d+)"
  for _, v in pairs(Table_KeywordAnimation) do
    if type(v.Time) ~= "string" then
      redlog("Table_KeywordAnimation Time字段类型错误！！type = ", type(v.Time))
      return
    end
    if not StringUtil.IsEmpty(v.Time) then
      local ret = string.split(v.Time, ";")
      local startTimeStr = ret[1]
      local endTimeStr = ret[2]
      local startYear, startMonth, startDay, startHour = startTimeStr:match(pattern)
      if startYear and startMonth and startDay then
        v.startTime = os.time({
          year = startYear,
          month = startMonth,
          day = startDay,
          hour = startHour
        })
      end
      local endYear, endMonth, endDay, endHour = endTimeStr:match(pattern)
      if endYear and endMonth and endDay then
        v.endTime = os.time({
          year = endYear,
          month = endMonth,
          day = endDay,
          hour = endHour
        })
      end
    end
  end
end

function Game.Preprocess_TaskLimit()
  if not Table_TaskLimit then
    return
  end
  Game.Config_TaskLimit = {}
  local map = {}
  for k, v in pairs(Table_TaskLimit) do
    if v.MapRaid then
      map = Game.Config_TaskLimit[v.MapRaid]
      if not map then
        map = {}
        Game.Config_TaskLimit[v.MapRaid] = map
      end
      map[#map + 1] = k
    end
  end
end

function Game.Preprocess_FishingBuff()
  Game.Config_FishingBuff = {}
  local cfg = GameConfig.FishingBuff and GameConfig.FishingBuff.Probability
  if cfg then
    for k, v in pairs(cfg) do
      for i = 2, #v do
        Game.Config_FishingBuff[v[i]] = k
      end
    end
  end
end

function Game.Preprocess_ActivityJournal()
  if not Table_ActivityJournal then
    return
  end
  Game.Config_ActivityJournal = {}
  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  for index, data in ipairs(Table_ActivityJournal) do
    local activityMap = Game.Config_ActivityJournal[data.GlobalActivityID]
    if not activityMap then
      activityMap = {}
      Game.Config_ActivityJournal[data.GlobalActivityID] = activityMap
    end
    local pageList = activityMap[data.ChapterID]
    if not pageList then
      pageList = {}
      activityMap[data.ChapterID] = pageList
    end
    pageList[#pageList + 1] = index
    if #pageList == 1 then
      local startYear, startMonth, startDay, startHour = data.StartTime:match(pattern)
      local endYear, endMonth, endDay, endHour = data.EndTime:match(pattern)
      local _, unlockMonth, unlockDay, unlockHour = data.AutoUnlockTime:match(pattern)
      if EnvChannel.IsTFBranch() then
        if not StringUtil.IsEmpty(data.TfStartTime) then
          startYear, startMonth, startDay, startHour = data.TfStartTime:match(pattern)
        end
        if not StringUtil.IsEmpty(data.TfEndTime) then
          endYear, endMonth, endDay, endHour = data.TfEndTime:match(pattern)
        end
        if not StringUtil.IsEmpty(data.TfAutoUnlockTime) then
          _, unlockMonth, unlockDay, unlockHour = data.TfAutoUnlockTime:match(pattern)
        end
      end
      if startYear and startMonth and startDay and startHour then
        data.StartTime = os.time({
          year = startYear,
          month = startMonth,
          day = startDay,
          hour = startHour
        })
      end
      if endYear and endMonth and endDay and endHour then
        data.EndTime = os.time({
          year = endYear,
          month = endMonth,
          day = endDay,
          hour = endHour
        })
      end
      data.StartTimeStr = startMonth .. "." .. startDay
      data.EndTimeStr = endMonth .. "." .. endDay
      data.AutoUnlockTimeStr = string.format(ZhString.JournalChapterAutoUnlockTime, unlockMonth, unlockDay, unlockHour)
    end
  end
end

function Game.Preprocess_VersionGoal()
  if not Table_VersionGoal then
    return
  end
  Game.Config_VersionGoal = {}
  local map = {}
  for k, v in pairs(Table_VersionGoal) do
    if v.Version then
      map = Game.Config_VersionGoal[v.Version]
      if not map then
        map = {}
        Game.Config_VersionGoal[v.Version] = map
      end
      map[#map + 1] = k
    end
  end
end

function Game.Preprocess_SkillSolution()
  if Table_SkillRecommed then
    local solutions = {}
    for index, v in ipairs(Table_SkillRecommed) do
      for key, value in pairs(v) do
        if key ~= "id" then
          local solution = solutions[key]
          if not solution then
            solutions[key] = {}
          end
          table.insert(solutions[key], value)
        end
      end
    end
    Game.SkillRecommend = solutions
  end
end

function Game.Preprocess_MatchRaid()
  local matchGoalID = {}
  for index, v in pairs(Table_MatchRaid) do
    if not matchGoalID[v.Type] then
      matchGoalID[v.Type] = {}
    end
    matchGoalID[v.Type][v.RaidConfigID] = index
  end
  Game.MatchGoals = matchGoalID
  local raidtype = 0
  for index, v in pairs(Table_TeamGoals) do
    raidtype = v.RaidType
    if raidtype and Table_MatchRaid[raidtype] then
      Table_MatchRaid[raidtype].TeamGoalID = index
    end
  end
end

function Game.Preprocess_EnchantMustBuff()
  if Table_EnchantMustBuff then
    local map = {}
    for _, v in pairs(Table_EnchantMustBuff) do
      map[v.ItemID] = v
    end
    Game.EnchantMustBuff = map
  end
end

function Game.Preprocess_Table_AfricanPoringPos()
  local config = {}
  for _, v in pairs(Table_AfricanPoringPos) do
    local groupConfig = config[v.GroupID]
    if not groupConfig then
      groupConfig = {}
      config[v.GroupID] = groupConfig
    end
    groupConfig[v.Pos] = v
  end
  Game.AfricanPoringPosConfig = config
end

local mountFashionSortFunc = function(l, r)
  return r < l
end

function Game.Preprocess_Table_MountFashion()
  if Table_MountFashion then
    local t = {}
    local categories = {}
    for id, config in pairs(Table_MountFashion) do
      local mountId = config.Mount
      if not t[mountId] then
        t[mountId] = {}
      end
      if config.Default == 1 then
        table.insert(t[mountId], id)
      end
      if not categories[mountId] then
        categories[mountId] = {}
      end
      if TableUtility.ArrayFindIndex(categories[mountId], config.Pos) == 0 then
        TableUtility.InsertSort(categories[mountId], config.Pos, mountFashionSortFunc)
      end
    end
    Game.MountDefaultFashion = t
    Game.MountFashionCategories = categories
  end
end

function Game.Preprocess_RefineTicket()
  if Game.RefineTicketMap then
    return
  end
  Game.RefineTicketMap = {}
  Game.OldRefineTicketMap = {}
  local t
  for k, data in pairs(Table_UseItem) do
    if data.UseEffect then
      if data.UseEffect.type == "refine_new_ticket" then
        if data.UseEffect.ticket_type then
          t = Game.RefineTicketMap[data.UseEffect.ticket_type]
          if not t then
            t = {}
            Game.RefineTicketMap[data.UseEffect.ticket_type] = t
          end
          t[data.id] = data
        end
      elseif data.UseEffect.type == "refine" then
        Game.OldRefineTicketMap[k] = data
      end
    end
  end
end

function Game.Preprocess_Table_HeadwearRepair()
  if Table_HeadwearRepair then
    local t = {}
    for id, config in pairs(Table_HeadwearRepair) do
      if config.BoxID and config.BoxID ~= _EmptyTable then
        for i = 1, #config.BoxID do
          local boxId = config.BoxID[i]
          local items = t[boxId]
          if not items then
            items = {}
            t[boxId] = items
          end
          items[#items + 1] = id
        end
      end
    end
    Game.HeadwearBoxItems = t
  end
end

function Game.Preprocess_Table_BWMapZone()
  autoImport("Table_BWMapZone")
  if not Table_BWMapZone then
    return
  end
  Game.BWRegionMap = {}
  Game.BWRegionGroupMap = {}
  for id, zoneData in pairs(Table_BWMapZone) do
    local mapId = zoneData.MapId
    if mapId then
      local regionMap = Game.BWRegionMap[mapId]
      if not regionMap then
        regionMap = {}
        Game.BWRegionMap[mapId] = regionMap
      end
      regionMap[id] = zoneData
      local groupId = zoneData.GroupId
      if groupId then
        local groupMap = {}
        if not groupMap then
          groupMap = {}
          Game.BWRegionGroupMap[mapId] = groupMap
        end
        if not groupMap[groupId] then
          groupMap[groupId] = {}
        end
        table.insert(groupMap[groupId], zoneData)
      end
    end
  end
end

function Game.Preprocess_Table_WindowsHotKeyDisplay()
  local t = {}
  for _, data in pairs(Table_WindowsHotKeyDisplay) do
    t[data.Hotkey] = data
  end
  Game.WindowsHotKeyDisplay = t
end

function Game.Preprocess_GameConfig()
  Game.Preprocess_GameConfig_RolePartOffsetTable()
end

function Game.Preprocess_GameConfig_RolePartOffsetTable()
  local t = GameConfig and GameConfig.RolePartOffsetTable
  if t then
    local partMap, partIDMap, bodyIDMap, part, partID, bodyID = {}
    for _, data in pairs(t) do
      part = data.part
      partID = data.partID
      bodyID = data.bodyID or 0
      if part and partID then
        if not partMap[part] then
          partMap[part] = {}
        end
        partIDMap = partMap[part]
        if not partIDMap[partID] then
          partIDMap[partID] = {}
        end
        bodyIDMap = partIDMap[partID]
        bodyIDMap[bodyID] = data.offset
      end
    end
    GameConfig.RolePartOffset = partMap
    GameConfig.RolePartOffsetTable = nil
  end
end

function Game.Preprocess_Table_EndlessBattleFieldEvent()
  if not Table_EndlessBattleFieldEvent then
    return
  end
  local pointMap = {}
  local alterPointCount = {}
  local minimapArea = {}
  local statueEventId
  for k, v in pairs(Table_EndlessBattleFieldEvent) do
    if v.Type == "occupy" then
      local points = v.Misc and v.Misc.occupy_points
      if points then
        local count = 0
        for id, data in pairs(points) do
          pointMap[id] = {
            eventId = v.id,
            config = data
          }
          count = count + 1
        end
        alterPointCount[v.id] = count
      end
    elseif v.Type == "statue" then
      statueEventId = v.id
    end
    if v.MapId then
      for i = 1, #v.MapId do
        local mapId = v.MapId[i]
        if not minimapArea[mapId] then
          minimapArea[mapId] = {}
        end
        minimapArea[mapId][k] = v
      end
    end
  end
  Game.AltarPoint = pointMap
  Game.AltarCnt = alterPointCount
  Game.EBFMinimapArea = minimapArea
  Game.EB_StatueEventId = statueEventId
end

function Game.Preprocess_Table_HeroJourney()
  local cdMap = {}
  if Table_HeroJourneyAchievement then
    for _, config in pairs(Table_HeroJourneyAchievement) do
      if config.achieveParams and config.achieveParams.npcId then
        cdMap[config.RaidID] = {
          config.achieveParams.timeLimit,
          config.achieveParams.npcId
        }
      end
    end
  end
  Game.PveStartFightCD = cdMap
end

function Game.Process_Table_BattlePassLevel()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local date = os.date("*t", curServerTime)
  local y, m, d, h = date.year, date.month, date.day, date.hour
  if d == 1 and h < 5 then
    y = 1 < m and y or y - 1
    m = 1 < m and m - 1 or 12
  end
  local replaceReward = function(srcRewards, destRewards)
    for i = 1, #srcRewards do
      local reward = srcRewards[i]
      if reward.year == y and reward.month == m then
        destRewards[1] = {}
        destRewards[1].itemid = reward.itemid
        destRewards[1].num = reward.num
        return
      end
    end
  end
  for _, data in pairs(Table_BattlePassLevel) do
    local server_rewardItems = data.Server_RewardItems
    if server_rewardItems and server_rewardItems ~= _EmptyTable then
      local replaceRewardItems = {}
      replaceReward(server_rewardItems, replaceRewardItems)
      if 0 < #replaceRewardItems then
        data.ReplaceRewardItems = replaceRewardItems
      end
    end
    local server_proRewardItems = data.Server_ProRewardItems
    if server_proRewardItems and server_proRewardItems ~= _EmptyTable then
      local replaceProRewardItems = {}
      replaceReward(server_proRewardItems, replaceProRewardItems)
      if 0 < #replaceProRewardItems then
        data.ReplaceProRewardItems = replaceProRewardItems
      end
    end
    local server_superRewardItems = data.Server_SuperRewardItems
    if server_superRewardItems and server_superRewardItems ~= _EmptyTable then
      local replaceSuperRewardItems = {}
      replaceReward(server_superRewardItems, replaceSuperRewardItems)
      if 0 < #replaceSuperRewardItems then
        data.ReplaceSuperRewardItems = replaceSuperRewardItems
      end
    end
  end
end

function Game.Preprocess_Table_FateSelectPool()
  if not Table_FateSelectPool then
    return
  end
  local t = {}
  for _, data in pairs(Table_FateSelectPool) do
    t[data.ActID] = t[data.ActID] or {}
    t[data.ActID][data.ItemID] = data
  end
  Game.FateSelectPool = t
end

function Game.Preprocess_Table_WindowsHotKey()
  if not Table_WindowsHotKey then
    return
  end
  local t = {}
  for _, v in pairs(Table_WindowsHotKey) do
    local cmd = v.Cmd
    if (cmd == "open_view2" or cmd == "open_view" or cmd == "open_teamview") and v.Param then
      local panelid = v.Param.panelid
      if panelid and type(panelid) == "table" then
        for i = 1, #panelid do
          t[#t + 1] = panelid[i]
        end
      else
        t[#t + 1] = v.Param.panelid
      end
    end
  end
  Game.WindowsEscPanel = t
end

function Game.Preprocess_ItemMemory()
  if not Table_ItemMemoryEffect then
    redlog("缺少表Table_ItemMemoryEffect")
    return
  end
  if not Table_ItemMemoryLibrary then
    redlog("缺少表Table_ItemMemoryLibrary")
    return
  end
  if not Table_ItemMemory then
    redlog("缺少表Table_ItemMemory")
    return
  end
  local EquipPosGroup = {
    WEAPON = 1,
    ARMOR = 2,
    ACCESSORY = 3,
    SPECIAL = 4
  }
  local GetEquipPosGroupEnum = function(equipPos)
    if type(equipPos) == "table" and #equipPos == 3 then
      local sortedPos = {}
      for i = 1, #equipPos do
        sortedPos[i] = equipPos[i]
      end
      table.sort(sortedPos)
      local pos1, pos2, pos3 = sortedPos[1], sortedPos[2], sortedPos[3]
      if pos1 == 1 and pos2 == 11 and pos3 == 12 then
        return EquipPosGroup.SPECIAL
      elseif pos1 == 2 and pos2 == 3 and pos3 == 4 then
        return EquipPosGroup.ARMOR
      elseif pos1 == 5 and pos2 == 6 and pos3 == 7 then
        return EquipPosGroup.WEAPON
      elseif pos1 == 8 and pos2 == 9 and pos3 == 10 then
        return EquipPosGroup.ACCESSORY
      end
    elseif type(equipPos) == "number" then
      if equipPos == 1 or equipPos == 11 or equipPos == 12 then
        return EquipPosGroup.SPECIAL
      elseif equipPos == 2 or equipPos == 3 or equipPos == 4 then
        return EquipPosGroup.ARMOR
      elseif equipPos == 5 or equipPos == 6 or equipPos == 7 then
        return EquipPosGroup.WEAPON
      elseif equipPos == 8 or equipPos == 9 or equipPos == 10 then
        return EquipPosGroup.ACCESSORY
      end
    end
    return nil
  end
  local itemMemoryEffect = {}
  local _colors = {}
  local groupToEffectIds = {}
  local effectToMemoryIds = {}
  local posGroupMap = {}
  for _, v in pairs(Table_ItemMemoryLibrary) do
    local effectID = v.EffectID
    local type = v.Type
    local groupID = v.GroupID
    if not _colors[effectID] then
      _colors[effectID] = {
        type = type,
        group = {}
      }
    end
    _colors[effectID].group[groupID] = 1
    if type == "special" and groupID and effectID then
      if not groupToEffectIds[groupID] then
        groupToEffectIds[groupID] = {}
      end
      groupToEffectIds[groupID][effectID] = true
    end
  end
  for k, v in pairs(Table_ItemMemoryEffect) do
    local effectId = v.EffectID
    if not itemMemoryEffect[effectId] then
      itemMemoryEffect[effectId] = {
        Color = _colors[effectId] and _colors[effectId].type,
        Group = _colors[effectId] and _colors[effectId].group,
        level = {}
      }
    end
    local level = v.Level or 1
    itemMemoryEffect[effectId].level[level] = k
    if effectId and v.PreviewDesc and v.PreviewDesc ~= "" then
      if not effectToMemoryIds[effectId] then
        effectToMemoryIds[effectId] = {}
      end
      effectToMemoryIds[effectId][k] = true
    end
  end
  for itemId, config in pairs(Table_ItemMemory) do
    local canEquip = config.CanEquip
    if canEquip and canEquip.EquipPos then
      local equipPos = canEquip.EquipPos
      if #equipPos == 3 then
        local groupEnum = GetEquipPosGroupEnum(equipPos)
        if groupEnum then
          local randomAttr = config.RandomAttr
          if randomAttr and randomAttr[30] and randomAttr[30].group then
            local groupId = randomAttr[30].group
            if not posGroupMap[groupEnum] then
              posGroupMap[groupEnum] = {}
            end
            posGroupMap[groupEnum][groupId] = true
          end
        end
      end
    end
  end
  local specialEffectMap = {}
  for groupEnum, groups in pairs(posGroupMap) do
    local memoryIds = {}
    for groupId, _ in pairs(groups) do
      local effectIds = groupToEffectIds[groupId]
      if effectIds then
        for effectId, _ in pairs(effectIds) do
          local memoryIdMap = effectToMemoryIds[effectId]
          if memoryIdMap then
            for memoryId, _ in pairs(memoryIdMap) do
              table.insert(memoryIds, memoryId)
            end
          end
        end
      end
    end
    table.sort(memoryIds)
    specialEffectMap[groupEnum] = memoryIds
  end
  Game.ItemMemoryEffect = itemMemoryEffect
  Game.EquipPosGroup = EquipPosGroup
  Game.EquipMemorySpecialEffectMap = specialEffectMap
  Game.GetEquipPosGroupEnum = GetEquipPosGroupEnum
  
  function Game.GetSpecialEffectIdsByEnum(groupEnum)
    return specialEffectMap[groupEnum] or {}
  end
  
  function Game.GetSpecialEffectIds(equipPos)
    local groupEnum = GetEquipPosGroupEnum(equipPos)
    if groupEnum then
      return specialEffectMap[groupEnum] or {}
    end
    return {}
  end
end

function Game.Preprocess_Table_AstralDestinyGraph()
  if not Table_AstralDestinyGraph then
    return
  end
  local t = {}
  for _, v in pairs(Table_AstralDestinyGraph) do
    t[v.Season] = t[v.Season] or {}
    t[v.Season][v.Point] = v
  end
  Game.AstralDestinyGraphSeasonPointMap = t
end

function Game.Preprocess_Table_TriplePvpRobot()
  if not Table_TriplePvpRobot then
    return
  end
  local t = {}
  for _, v in pairs(Table_TriplePvpRobot) do
    t[v.MonsterID] = v.Profession
  end
  Game.TriplePvpRobotProfessionMap = t
end

function Game.Preprocess_Table_CardLevel()
  if not Table_CardLevel then
    return
  end
  local t = {}
  for _, v in pairs(Table_CardLevel) do
    t[v.CardID] = t[v.CardID] or {}
    t[v.CardID][v.Level] = v
  end
  Game.CardUpgradeMap = t
end

function Game.Preprocess_Table_SpaceTimeIllusionSkills()
  if not Table_SpaceTimeIllusionSkills then
    return
  end
  local t = {}
  for _, v in pairs(Table_SpaceTimeIllusionSkills) do
    if v.SkillID then
      if not t[v.SkillID] then
        t[v.SkillID] = {}
      end
      t[v.SkillID][v.SkillLevel] = v
    end
  end
  Game.SpaceTimeIllusionSkills = t
end
