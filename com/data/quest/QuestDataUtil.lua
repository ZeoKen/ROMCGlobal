QuestDataUtil = {}
QuestDataUtil.KeyValuePair = {
  {
    name = "id",
    type = "string",
    stepType = "illustration"
  },
  {
    name = "type",
    type = "string",
    stepType = "carrier"
  },
  {
    name = "button",
    type = "number",
    stepType = "guide"
  },
  {name = "pos", type = "table"},
  {name = "tarpos", type = "table"},
  {
    name = "peopletosubgroup",
    type = "table"
  },
  {name = "dialog", type = "table"},
  {name = "method", type = "string"},
  {name = "GM", type = "string"},
  {name = "attention", type = "string"},
  {name = "itemIcon", type = "string"},
  {name = "skillIcon", type = "string"},
  {name = "uiIcon", type = "string"},
  {name = "npcIcon", type = "string"},
  {
    name = "interactiveIcon",
    type = "string"
  },
  {name = "name", type = "string"},
  {name = "button", type = "string"},
  {name = "text", type = "string"},
  {
    name = "guide_quest_symbol",
    type = "string"
  },
  {name = "teleMap", type = "table"},
  {name = "ShowSymbol", type = "number"},
  {name = "Icon", type = "table"},
  {
    name = "id",
    type = "string",
    stepType = "picture"
  },
  {
    name = "text",
    type = "string",
    stepType = "addbutton"
  },
  {
    name = "eventtype",
    type = "string",
    stepType = "addbutton"
  },
  {
    name = "qteType",
    type = "string",
    stepType = "game"
  },
  {
    name = "qtePos",
    type = "table",
    stepType = "game"
  },
  {
    name = "ids",
    type = "table",
    stepType = "killorder"
  },
  {
    name = "effect",
    type = "string",
    stepType = "shot"
  },
  {
    name = "filter",
    type = "number",
    stepType = "shot"
  },
  {
    name = "monster",
    type = "table",
    stepType = "shot"
  },
  {
    name = "range",
    type = "number",
    stepType = "shot"
  },
  {
    name = "faceDir",
    type = "table",
    stepType = "shot"
  },
  {
    name = "effect",
    type = "string",
    stepType = "shot_advanced"
  },
  {
    name = "filter",
    type = "number",
    stepType = "shot_advanced"
  },
  {
    name = "monster",
    type = "table",
    stepType = "shot_advanced"
  },
  {
    name = "range",
    type = "number",
    stepType = "shot_advanced"
  },
  {
    name = "faceDir",
    type = "table",
    stepType = "shot_advanced"
  },
  {
    name = "target",
    type = "number",
    stepType = "shot_advanced"
  },
  {
    name = "action",
    type = "string",
    stepType = "simulation"
  },
  {
    name = "invite_name",
    type = "string",
    stepType = "simulation"
  },
  {
    name = "team_name",
    type = "string",
    stepType = "simulation"
  },
  {
    name = "member",
    type = "table",
    stepType = "simulation"
  },
  {
    name = "noskip",
    type = "number",
    stepType = "cutscene"
  },
  {name = "Version", type = "string"},
  {
    name = "action",
    type = "string",
    stepType = "puzzle"
  },
  {
    name = "action",
    type = "string",
    stepType = "puzzle_refresh"
  },
  {name = "targetname", type = "string"},
  {name = "opt", type = "string"},
  {name = "ids", type = "table"},
  {name = "viewName", type = "string"},
  {name = "BeamPos", type = "table"},
  {name = "npcids", type = "table"},
  {name = "npcpos", type = "table"},
  {
    name = "cutscene_id",
    type = "number"
  },
  {
    name = "partnerid",
    type = "table",
    stepType = "partner_move"
  },
  {
    name = "evidenceList",
    type = "table"
  },
  {
    name = "type",
    type = "string",
    stepType = "client"
  },
  {
    name = "range",
    type = "table",
    stepType = "tapping"
  },
  {
    name = "msg",
    type = "string",
    stepType = "tapping"
  },
  {
    name = "lockers",
    type = "table",
    "mind_enter"
  },
  {
    name = "effect",
    type = "string",
    stepType = "mind_play_effect"
  },
  {
    name = "pos",
    type = "table",
    stepType = "mind_play_effect"
  },
  {
    name = "buttonPos",
    type = "table",
    stepType = "mind_play_effect"
  },
  {
    name = "buttonSize",
    type = "table",
    stepType = "mind_play_effect"
  },
  {
    name = "anim",
    type = "string",
    stepType = "mind_scene_anim"
  },
  {name = "bgm", type = "string"},
  {name = "guidekey", type = "string"},
  {name = "endstep", type = "number"},
  {name = "jump", type = "table"},
  {name = "call_ids", type = "table"},
  {name = "rectPos", type = "table"},
  {name = "nobody", type = "number"},
  {name = "waittime", type = "number"},
  {name = "is_single", type = "number"},
  {
    name = "skip_broadcast",
    type = "number"
  },
  {name = "ShowPic", type = "string"},
  {
    name = "action",
    type = "string",
    stepType = "area"
  },
  {
    name = "type",
    type = "string",
    stepType = "interact_local_ai"
  },
  {
    name = "npcid",
    type = "number",
    stepType = "interact_local_ai"
  },
  {
    name = "uid",
    type = "number",
    stepType = "interact_local_ai"
  },
  {
    name = "on_act",
    type = "string",
    stepType = "interact_local_ai"
  },
  {
    name = "off_act",
    type = "string",
    stepType = "interact_local_ai"
  },
  {
    name = "fin_act",
    type = "string",
    stepType = "interact_local_ai"
  },
  {
    name = "fail_act",
    type = "string",
    stepType = "interact_local_ai"
  },
  {
    name = "keepOnSuccess",
    type = "number",
    stepType = "interact_local_ai"
  },
  {
    name = "type",
    type = "string",
    stepType = "add_local_interact"
  },
  {
    name = "uid",
    type = "number",
    stepType = "add_local_interact"
  },
  {
    name = "members",
    type = "table",
    stepType = "add_local_interact"
  },
  {
    name = "member_uids",
    type = "table",
    stepType = "add_local_interact"
  },
  {
    name = "check_quest",
    type = "table",
    stepType = "add_local_interact"
  },
  {
    name = "on_act",
    type = "string",
    stepType = "add_local_interact"
  },
  {
    name = "off_act",
    type = "string",
    stepType = "add_local_interact"
  },
  {
    name = "fin_act",
    type = "string",
    stepType = "add_local_interact"
  },
  {
    name = "fail_act",
    type = "string",
    stepType = "add_local_interact"
  },
  {
    name = "keepOnSuccess",
    type = "number",
    stepType = "add_local_interact"
  },
  {
    name = "close",
    type = "number",
    stepType = "open_cannon"
  },
  {
    name = "offset",
    type = "table",
    stepType = "open_cannon"
  },
  {
    name = "rotation",
    type = "table",
    stepType = "open_cannon"
  },
  {
    name = "locked",
    type = "table",
    stepType = "open_cannon"
  },
  {
    name = "se",
    type = "string",
    stepType = "use"
  },
  {
    name = "effect",
    type = "string",
    stepType = "use"
  },
  {
    name = "NpcId",
    type = "table",
    stepType = "activate_transfer"
  },
  {name = "playTL", type = "string"},
  {
    name = "se",
    type = "string",
    stepType = "effect"
  }
}

function QuestDataUtil.getTypeBykeyAndStepType(key, stepType)
  for i = 1, #QuestDataUtil.KeyValuePair do
    local single = QuestDataUtil.KeyValuePair[i]
    if single.stepType and stepType == single.stepType and single.name == key then
      return single.type
    elseif key == single.name and single.stepType == nil then
      return single.type
    end
  end
end

function QuestDataUtil.getMethod(valueType)
  if valueType == "string" then
    return tostring
  elseif valueType == "number" then
    return tonumber
  end
end

function QuestDataUtil.parseParams(params, stepType)
  local param = {}
  if params and 0 < #params then
    for i = 1, #params do
      local key = params[i].key
      local valueType = QuestDataUtil.getTypeBykeyAndStepType(key, stepType)
      local valueMethod = QuestDataUtil.getMethod(valueType)
      local value = params[i].value
      local items = params[i].items
      if key == "npc" then
        if items and 0 < #items then
          local table = QuestDataUtil.getLuaNumTable(items[1].items)
          param.npc = table
        else
          param.npc = tonumber(value)
        end
      elseif key == "Icon" then
        if items and 0 < #items then
          local table = QuestDataUtil.getLuaStringTable(items[1].items)
          param.Icon = table
        end
      elseif key == "item" or key == "telePath" then
        if items and items[1] and items[1].items and items[1].items[1] and items[1].items[1].items then
          local data = {}
          local tempTb = items[1].items
          for j = 1, #tempTb do
            local item = tempTb[j]
            local childKey = item.key
            local childValues = item.items
            local table = {}
            for k = 1, #childValues do
              local childchildKey = childValues[k].key
              local childchildValue = childValues[k].value
              table[childchildKey] = tonumber(childchildValue)
            end
            data[tonumber(childKey)] = table
          end
          param.item = data
        end
      elseif key == "ShowSymbol" or key == "showsymbol" then
        if value then
          param.ShowSymbol = tonumber(value)
        end
      elseif stepType == "random_buff" then
        param[key .. tostring(i)] = tonumber(value)
      elseif key == "checkpos" and (stepType == "puzzle_npc_sync_move" or stepType == "partner_move") then
        local data = {}
        local tempTb = items and items[1] and items[1].items
        if tempTb then
          for i = 1, #tempTb do
            data[i] = QuestDataUtil.getLuaNumTable(tempTb[i].items)
          end
        end
        param.checkpos = data
      elseif key == "cutscene_id" then
        if value then
          param.cutscene_id = tonumber(value)
          param.ids = {
            param.cutscene_id
          }
        end
      elseif key == "group_id" then
        if items and items[1] and items[1].items then
          local table = QuestDataUtil.getLuaNumTable(items[1].items)
          param[key] = table
        else
          param[key] = tonumber(value)
        end
      elseif key == "args" and stepType == "interact_local_ai" then
        local table = QuestDataUtil.parseActionParams(items[1].items)
        local data = {}
        for k, v in pairs(table) do
          data[k] = tonumber(v)
        end
        param[key] = data
      elseif key == "npcCfg" and stepType == "interact_local_ai" then
        local data = {}
        local tempTb = items and items[1] and items[1].items
        if tempTb then
          for i = 1, #tempTb do
            data[i] = QuestDataUtil.getLuaNumTable(tempTb[i].items)
          end
        end
        param[key] = data
      elseif (key == "pos" or key == "slots" or key == "check") and stepType == "add_local_interact" then
        local data = {}
        local tempTb = items and items[1] and items[1].items
        if tempTb then
          for i = 1, #tempTb do
            data[i] = QuestDataUtil.getLuaNumTable(tempTb[i].items)
          end
        end
        param[key] = data
      elseif key == "skills" and stepType == "open_cannon" then
        if items and items[1] and items[1].items then
          local table = QuestDataUtil.getLuaNumTable(items[1].items)
          param[key] = table
        else
          param[key] = tonumber(value)
        end
      elseif valueType and valueMethod then
        if value then
          param[key] = valueMethod(value)
        end
      elseif valueType then
        if items and items[1] and items[1].items then
          local table = QuestDataUtil.getLuaNumTable(items[1].items)
          param[key] = table
        end
      elseif value then
        param[key] = tonumber(value)
      end
    end
  end
  return param
end

local counts = 0

function QuestDataUtil.parseSingleParams(item, array)
  local key = item.key
  local value = item.value
  local items = item.items
  if items and 0 < #items then
    for i = 1, #items do
      counts = counts + 1
      if 10 < counts then
        redlog("循环次数大于10次，清检查")
        break
      end
      if key and key ~= "" then
        if not array[key] then
          array[key] = {}
        end
        QuestDataUtil.parseSingleParams(items[i], array[key])
      else
        QuestDataUtil.parseSingleParams(items[i], array)
      end
    end
  else
    array[key] = value
  end
end

function QuestDataUtil.parseActionParams(params)
  local param = {}
  if params and 0 < #params then
    for i = 1, #params do
      counts = 0
      QuestDataUtil.parseSingleParams(params[i], param)
    end
  end
  return param
end

function QuestDataUtil.getLuaNumTable(items)
  local table = {}
  for j = 1, #items do
    local single = items[j]
    local key = single.key
    local value = single.value
    table[tonumber(key)] = tonumber(value)
  end
  return table
end

function QuestDataUtil.getLuaStringTable(items)
  local table = {}
  for j = 1, #items do
    local single = items[j]
    local key = single.key
    local value = single.value
    table[tonumber(key)] = tostring(value)
  end
  return table
end

function QuestDataUtil.getTranceInfoTable(questData, data, questType, process)
  local table = {}
  if data == nil then
    return table
  end
  local process = process and process or questData.process
  local questType = questType or questData.questDataStepType
  if questType == QuestDataStepType.QuestDataStepType_VISIT then
    local npc = data.npc
    local id = 0
    if type(npc) == "table" then
      id = npc[1]
    else
      id = npc
    end
    local infoTable = Table_Npc[id]
    if infoTable == nil then
      infoTable = Table_Monster[id]
    end
    if infoTable ~= nil then
      table = {
        param2 = nil,
        npcName = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
      }
    else
      errorLog("invalid visit questType:. npcId:")
      errorLog(id)
    end
    if questData.names then
      local itemName = questData.names[1]
      table.itemName = itemName
    end
  elseif questType == QuestDataStepType.QuestDataStepType_KILL then
    local id = data.monster or data.call_id
    local groupId = data.groupId
    local totalNum = data.num
    local anyMonster = data.any_monster
    local call_ids = data.call_ids
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    if infoTable ~= nil then
      table = {
        num = process .. "/" .. totalNum,
        monsterName = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
      }
    elseif groupId then
      table = {
        num = process .. "/" .. totalNum
      }
    elseif anyMonster then
      table = {
        num = process .. "/" .. totalNum
      }
    elseif call_ids then
      table = {
        num = process .. "/" .. totalNum
      }
    else
      if process and totalNum then
        table = {
          num = process .. "/" .. totalNum
        }
      end
      errorLog("invalid kill or collect questType:. id:" .. questData.id)
    end
  elseif questType == QuestDataStepType.QuestDataStepType_COLLECT then
    local id = data.monster
    local groupId = data.groupId
    local totalNum = data.num
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    if infoTable ~= nil then
      table = {
        num = process .. "/" .. totalNum,
        monsterName = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
      }
    elseif groupId then
      table = {
        num = process .. "/" .. totalNum
      }
    else
      errorLog("invalid kill or collect questType:. id:" .. questData.id)
    end
  elseif questType == QuestDataStepType.QuestDataStepType_GATHER then
    local items = ItemUtil.GetRewardItemIdsByTeamId(data.reward)
    if not items or not items[1] then
      helplog("questId:" .. questData.id .. "rewardId:" .. (data.reward or 0) .. " 该奖励任务不存在此奖励")
      return
    end
    local itemId = items[1].id
    local totalNum = data.num
    local infoTable = Table_Item[tonumber(itemId)]
    if infoTable ~= nil then
      table = {
        num = process .. "/" .. totalNum,
        itemName = infoTable.NameZh
      }
    else
      helplog("invalid itemId:" .. itemId)
    end
  elseif questType == QuestDataStepType.QuestDataStepType_ITEM then
    local item = data.item and data.item[1]
    local itemId = item and item.id or 0
    local totalNum = item and item.num or 0
    local infoTable = Table_Item[tonumber(itemId)]
    if infoTable and infoTable.Type == 160 then
      process = BagProxy.Instance:GetItemNumByStaticID(itemId, BagProxy.BagType.Quest) or 0
    else
      process = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
    end
    questData.itemId = itemId
    questData.process = process
    questData.totalNum = totalNum
    itemName = infoTable and infoTable.NameZh or nil
    table = {
      num = process .. "/" .. totalNum,
      itemName = itemName
    }
  elseif questType == QuestDataStepType.QuestDataStepType_ADVENTURE then
    local totalNum = data.num and data.num or 0
    table = {
      num = process .. "/" .. totalNum
    }
  elseif questType == QuestDataStepType.QuestDataStepType_CHECKPROGRESS then
    local id = data.monster
    local groupId = data.groupId
    local totalNum = data.num and data.num or 0
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    if infoTable ~= nil then
      table = {
        num = process .. "/" .. totalNum,
        monsterName = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
      }
    elseif groupId then
      table = {
        num = process .. "/" .. totalNum
      }
    else
      errorLog("invalid check_progress questType:. id:" .. questData.id)
    end
  elseif questType == QuestDataStepType.QuestDataStepType_MONEY then
    local itemType = data.moneytype
    local totalNum = data.num
    if itemType == ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP then
      process = BagProxy.Instance:GetItemNumByStaticID(itemType)
    elseif itemType == ProtoCommon_pb.EMONEYTYPE_GARDEN then
      process = BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
    else
      local enum = QuestDataUtil.getUserDataEnum(itemType)
      process = Game.Myself.data.userdata:Get(enum)
    end
    process = process and process or 0
    table = {
      num = process .. "/" .. totalNum
    }
  elseif questType == QuestDataStepType.QuestDataStepType_ITEM_USE or questType == QuestDataStepType.QuestDataStepType_MUSIC or questType == QuestDataStepType.QuestDataStepType_HAND or questType == QuestDataStepType.QuestDataStepType_PHOTO or questType == QuestDataStepType.QuestDataStepType_CARRIER then
    process = process and process or 0
    table = {num = process}
    if questData.names then
      local name = questData.names[1]
      table.name = name
    end
  elseif questType == QuestDataStepType.QuestDataStepType_BATTLE then
    process = process and process or 0
    local monsterName
    local id = data.monster
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    if infoTable ~= nil then
      monsterName = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
    end
    table = {num = process, monsterName = monsterName}
    if questData.names then
      local name = questData.names[1]
      table.name = name
    end
  elseif questType == QuestDataStepType.QuestDataStepType_RAID then
    table.mapRaid = data.id
  elseif questType == QuestDataStepType.QuestDataStepType_ActivateTransfer then
    local totalNum = data.num
    table = {
      num = process .. "/" .. totalNum
    }
  elseif questType == "item_num" then
    local item = data.item and data.item[1]
    local totalNum = item and item.num
    if process and totalNum then
      table = {
        num = process .. "/" .. totalNum
      }
    end
  else
    local totalNum = data.num
    if process and totalNum then
      table = {
        num = process .. "/" .. totalNum
      }
    else
      table = {}
    end
  end
  return table
end

function QuestDataUtil.getUserDataEnum(moneyType)
  if moneyType == ProtoCommon_pb.EMONEYTYPE_DIAMOND then
    return UDEnum.DIAMOND
  elseif moneyType == ProtoCommon_pb.EMONEYTYPE_SILVER then
    return UDEnum.SILVER
  elseif moneyType == ProtoCommon_pb.EMONEYTYPE_GOLD then
    return UDEnum.GOLD
  elseif moneyType == ProtoCommon_pb.EMONEYTYPE_GARDEN then
    return UDEnum.GARDEN
  elseif moneyType == ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP then
    return UDEnum.FRIENDSHIP
  elseif moneyType == ProtoCommon_pb.EMONEYTYPE_DEADCOIN then
    return UDEnum.DEADCOIN
  end
end

function QuestDataUtil.parseWantedQuestTranceInfo(questData, wantedData)
  local params = wantedData.Params
  local tableValue = QuestDataUtil.getTranceInfoTable(questData, params, wantedData.Content)
  if tableValue == nil then
    return "parse table text is nil:" .. wantedData.Target
  end
  local result = string.gsub(wantedData.Target, "%[(%w+)]", tableValue)
  local index = 1
  result = string.gsub(result, "%[(%w+)]", function(str)
    local value = self.names[index]
    index = index + 1
    return value
  end)
  return result
end

QuestDataUtil.BossKeyValuePair = {
  {name = "id", type = "string"},
  {name = "npcid", type = "number"},
  {name = "num", type = "number"},
  {name = "monsterid", type = "number"},
  {name = "monsternum", type = "number"},
  {
    name = "dialog_select",
    type = "number"
  },
  {
    name = "yes_dialogs",
    type = "table"
  },
  {name = "no_dialogs", type = "table"}
}

function QuestDataUtil.getTypeBykeyAndContent(key, bossStepType)
  for i = 1, #QuestDataUtil.BossKeyValuePair do
    local single = QuestDataUtil.BossKeyValuePair[i]
    if single.bossStepType and bossStepType == single.content and single.name == key then
      return single.type
    elseif key == single.name and single.bossStepType == nil then
      return single.type
    end
  end
end

function QuestDataUtil.parseBossStepParams(params, bossStepType)
  local param = {}
  if params and 0 < #params then
    for i = 1, #params do
      local key = params[i].key
      local valueType = QuestDataUtil.getTypeBykeyAndContent(key, bossStepType)
      local valueMethod = QuestDataUtil.getMethod(valueType)
      local value = params[i].value
      local items = params[i].items
      if valueType and valueMethod then
        if value then
          param[key] = valueMethod(value)
        end
      elseif valueType then
        if items and items[1] and items[1].items then
          local table = QuestDataUtil.getLuaNumTable(items[1].items)
          param[key] = table
        end
      elseif value then
        param[key] = tonumber(value)
      end
    end
  end
  return param
end
