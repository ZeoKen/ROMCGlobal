CookMasterManager = class("CookMasterManager")
local FoodMaterialSeperate = {
  [1] = {
    startIndex = 1,
    endIndex = 16,
    count = 0
  },
  [2] = {
    startIndex = 21,
    endIndex = 31,
    count = 0
  },
  [3] = {
    startIndex = 32,
    endIndex = 68,
    count = 2
  },
  [4] = {
    startIndex = 69,
    endIndex = 104,
    count = 1
  },
  [5] = {
    startIndex = 105,
    endIndex = 128,
    count = 0
  }
}
local guideQuestId = 1002250001

function CookMasterManager.Me()
  if nil == CookMasterManager.me then
    CookMasterManager.me = CookMasterManager.new()
  end
  return CookMasterManager.me
end

function CookMasterManager:ctor()
  self.totalMaterialList = {}
  self.randomMaterialList = {}
  self.playerMaterialList = {}
  self.enemyMaterialList = {}
  self.recommendRecipeList = {}
  self.playerCookStyle = 1
  self.enemyCookStyle = 1
  self.round = 1
  self.myTurn = true
  self.gameExtraRule = 0
  self.playerCheat = false
  self.enemyCookStyleTurnEnd = false
end

function CookMasterManager:SetGameRule(param)
  local difficulty, ruleid
  if param == 0 then
    local config = GameConfig.CookGame.dailyRandom
    if not config then
      return
    end
    local randomId = math.random(1, #config)
    ruleid = config[randomId]
  else
    ruleid = param
  end
  if ruleid and 3 < ruleid then
    self.gameExtraRule = 1
    difficulty = ruleid - 3
  else
    difficulty = ruleid
  end
  self.difficulty = difficulty
  xdlog("难度、模式", self.difficulty, self.gameExtraRule)
end

function CookMasterManager:GameStart()
  xdlog("gamestart")
  TableUtility.TableClear(self.randomMaterialList)
  TableUtility.TableClear(self.totalMaterialList)
  TableUtility.TableClear(self.playerMaterialList)
  TableUtility.TableClear(self.enemyMaterialList)
  TableUtility.TableClear(self.recommendRecipeList)
  self.round = 1
  self.myTurn = true
  self.playerCookStyle = 1
  self.enemyCookStyle = 1
  self.enemyCookStyleTurnEnd = false
  self.gameExtraRule = 0
  for i = 1, 5 do
    if FoodMaterialSeperate[i].count and 0 < FoodMaterialSeperate[i].count then
      local count = FoodMaterialSeperate[i].count
      for j = 1, count do
        local randomID = math.random(FoodMaterialSeperate[i].startIndex, FoodMaterialSeperate[i].endIndex)
        xdlog("随机食物ID", randomID)
        local recipeData = Table_Recipe[randomID]
        local materials = recipeData.Material
        for k = 1, #materials do
          local singleMaterial = materials[k][2]
          if #self.randomMaterialList > 12 then
            break
          end
          local data = {id = singleMaterial, exist = true}
          table.insert(self.randomMaterialList, data)
          table.insert(self.totalMaterialList, singleMaterial)
        end
      end
    end
  end
  while #self.randomMaterialList < 12 do
    local randomID = math.random(1, #self.totalMaterialList)
    local data = {
      id = self.totalMaterialList[randomID],
      exist = true
    }
    table.insert(self.randomMaterialList, data)
  end
end

function CookMasterManager:PlayerTurn(index)
  if not self.randomMaterialList or #self.randomMaterialList == 0 then
    redlog("食物列表没有内容！")
    return
  end
  if self.randomMaterialList[index] and self.randomMaterialList[index].exist == true then
    self.randomMaterialList[index].exist = false
    local data = {
      itemId = self.randomMaterialList[index].id,
      num = 1
    }
    if self.gameExtraRule == 1 then
      local _, extra = math.modf(self.round / 2)
      if extra ~= 0 then
        xdlog("奇数回合，替换")
        table.insert(self.enemyMaterialList, data)
      else
        table.insert(self.playerMaterialList, data)
      end
    else
      table.insert(self.playerMaterialList, data)
    end
  end
  GameFacade.Instance:sendNotification("CookMasterPlayerTurnEnd")
end

function CookMasterManager:PlayerRandomTurn(round)
  if not self.randomMaterialList or #self.randomMaterialList == 0 then
    redlog("食物列表没有内容！")
    return
  end
  local leftCount = #self.randomMaterialList
  local randomTarget = math.random(1, leftCount)
  local itemId = self.randomMaterialList[randomTarget]
  table.remove(self.randomMaterialList, randomTarget)
  local data = {itemId = itemId, num = 1}
  table.insert(self.playerMaterialList, data)
end

function CookMasterManager:EnemyTurn(round)
  if not self.randomMaterialList or #self.randomMaterialList == 0 then
    redlog("食物列表没有内容！")
    return
  end
  local targetIndex = 0
  self.randomTryCount = 0
  if self.gameExtraRule == 1 then
    local _, extra = math.modf(self.round / 2)
    if extra ~= 0 then
      targetIndex = self:EnemyRandomChoose()
      local data = {
        itemId = self.randomMaterialList[targetIndex].id,
        num = 1
      }
      table.insert(self.playerMaterialList, data)
    else
      targetIndex = self:EnemyAIChoose()
      local data = {
        itemId = self.randomMaterialList[targetIndex].id,
        num = 1
      }
      table.insert(self.enemyMaterialList, data)
    end
  else
    targetIndex = self:EnemyAIChoose()
    local data = {
      itemId = self.randomMaterialList[targetIndex].id,
      num = 1
    }
    table.insert(self.enemyMaterialList, data)
  end
  self.randomMaterialList[targetIndex].exist = false
  GameFacade.Instance:sendNotification("CookMasterEnemyTurnEnd")
end

function CookMasterManager:EnemyRandomChoose()
  local targetIndex = 0
  while targetIndex == 0 do
    local randomNum = math.random(1, 12)
    if self.randomMaterialList[randomNum] and self.randomMaterialList[randomNum].exist then
      targetIndex = randomNum
      return targetIndex
    end
  end
end

function CookMasterManager:EnemyAIChoose()
  local curList = {}
  if self.enemyMaterialList and #self.enemyMaterialList > 0 then
    for i = 1, #self.enemyMaterialList do
      table.insert(curList, self.enemyMaterialList[i].itemId)
    end
  end
  local leftList = {}
  if self.randomMaterialList and 0 < #self.randomMaterialList then
    for i = 1, #self.randomMaterialList do
      if self.randomMaterialList[i].exist then
        table.insert(leftList, self.randomMaterialList[i].id)
      end
    end
  end
  local targetId
  if not self.enemyTargetFood then
    local random = math.random(1, #self.recommendRecipeList)
    self.enemyTargetFood = self.recommendRecipeList[random]
  end
  if self.enemyTargetFood then
    local recipeData = Table_Recipe[self.enemyTargetFood]
    if recipeData then
      local material = recipeData.Material
      for i = 1, #material do
        local targetMaterial = material[i][2]
        if #curList == 0 or TableUtility.ArrayFindIndex(curList, targetMaterial) == 0 then
          xdlog(TableUtility.ArrayFindIndex(leftList, targetMaterial), targetMaterial)
          if 0 < TableUtility.ArrayFindIndex(leftList, targetMaterial) then
            targetId = targetMaterial
            break
          end
        end
      end
    end
  end
  if targetId then
    for k, v in pairs(self.randomMaterialList) do
      if v.id == targetId and v.exist then
        return k
      end
    end
  else
    self.randomTryCount = self.randomTryCount + 1
    if self.randomTryCount > 5 then
      redlog("尝试次数上限- > 随机选取")
      return self:EnemyRandomChoose()
    end
    self.enemyTargetFood = nil
    return self:EnemyAIChoose()
  end
end

function CookMasterManager:SetEnemyID(npcid)
  self.enemyID = npcid
end

function CookMasterManager:SetPlayerCookStyle(id)
  if self.gameExtraRule == 2 then
    self.enemyCookStyle = id
  else
    self.playerCookStyle = id
  end
end

function CookMasterManager:SetEnemyCookStyle()
  if self.enemyCookStyleTurnEnd then
    return
  end
  if self.gameExtraRule == 2 then
    local result = math.random(1, 4)
    self.playerCookStyle = result
  else
    self.enemyCookStyle = self:EnemyAIChooseCookStyle()
  end
  self.enemyCookStyleTurnEnd = true
  GameFacade.Instance:sendNotification("CookMasterEnemyCookStyleChooseEnd")
end

function CookMasterManager:EnemyAIChooseCookStyle()
  if self.enemyTargetFood then
    local recipeData = Table_Recipe[self.enemyTargetFood]
    redlog("AI选烹饪方式", recipeData.Type)
    return recipeData.Type
  else
    return math.random(1, 4)
  end
end

function CookMasterManager:GetResult()
  if not (#self.playerMaterialList > 0) or not (0 < #self.enemyMaterialList) then
    redlog("有一方没有选择素材")
    return
  end
  local playerRecipe = FunctionFood.Me():MatchRecipe(self.playerCookStyle, self.playerMaterialList)
  local playerProductId = 551019
  local enemyProductId = 551019
  if playerRecipe and 0 < #playerRecipe then
    playerProductId = Table_Recipe[playerRecipe[1].recipeId].Product
  end
  local enemyRecipe = FunctionFood.Me():MatchRecipe(self.enemyCookStyle, self.enemyMaterialList)
  if enemyRecipe and 0 < #enemyRecipe then
    enemyProductId = Table_Recipe[enemyRecipe[1].recipeId].Product
  end
  if self.inMode7 then
    enemyProductId = Table_Recipe[self.inMode7Data.params.recipe_id2].Product
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CookMasterResultView,
      viewdata = {
        enemyId = self.enemyID,
        playerFoodId = playerProductId,
        enemyFoodId = enemyProductId,
        difficulty = self.difficulty,
        inMode7Context = {
          isWin = playerRecipe and 0 < #playerRecipe and playerRecipe[1].recipeId == self.inMode7Data.params.recipe_id1
        }
      }
    })
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CookMasterResultView,
    viewdata = {
      enemyId = self.enemyID,
      playerFoodId = playerProductId,
      enemyFoodId = enemyProductId,
      difficulty = self.difficulty
    }
  })
end

function CookMasterManager:CheckGuideQuest(result)
  local questList = QuestProxy.Instance:getQuestListByStepType(QuestDataStepType.QuestDataStepType_WAITCLIENT)
  if questList and 0 < #questList then
    for i = 1, #questList do
      local questData = questList[i]
      xdlog("waitclient任务", questData.id, questData.staticData.FinishJump, questData.staticData.FailJump)
      if result then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        return
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        return
      end
    end
  end
  ServiceNUserProxy.Instance:CallCookGameFinishUserCmd(nil, nil, result)
  if result then
    MsgManager.ShowMsgByID(28098)
  end
end

function CookMasterManager:RefreshAvailableFoodRecipe()
  if not self.totalMaterialList then
    redlog("无食材")
    return
  end
  for i = 2, 5 do
    local startIndex = FoodMaterialSeperate[i].startIndex
    local endIndex = FoodMaterialSeperate[i].endIndex
    for j = startIndex, endIndex do
      local recipeData = Table_Recipe[j]
      if recipeData then
        local materials = recipeData.Material
        local enable = true
        for k = 1, #materials do
          if TableUtility.ArrayFindIndex(self.totalMaterialList, materials[k][2]) == 0 then
            enable = false
            break
          end
        end
        if enable then
          xdlog("可制作列表", recipeData.id)
          table.insert(self.recommendRecipeList, recipeData.id)
        end
      else
        redlog("Recipe表缺少ID", j)
      end
    end
  end
end

function CookMasterManager:GetPlayerMaterialList()
  return self.playerMaterialList
end

function CookMasterManager:GetEnemyMaterialList()
  return self.enemyMaterialList
end

function CookMasterManager:GetTotalMaterials()
  return self.totalMaterialList
end

function CookMasterManager:GetLeftMaterials()
  return self.randomMaterialList
end

function CookMasterManager:GetGameRound()
  return self.round
end

function CookMasterManager:GetCurTurn()
  return self.myTurn
end

function CookMasterManager:SetCurTurn(bool)
  self.myTurn = bool
end

function CookMasterManager:GetExtraRule()
  return self.gameExtraRule
end

function CookMasterManager:NextRound()
  self.round = self.round + 1
end

function CookMasterManager:GetPlayerCookStyle()
  return self.playerCookStyle
end

function CookMasterManager:GetEnemyCookStyle()
  return self.enemyCookStyle
end

function CookMasterManager:GetAvailableFoodRecipe()
  return self.recommendRecipeList
end

function CookMasterManager:GameStart7(questData)
  xdlog("RO-196746厨王争霸玩法优化 专用的Mode7")
  xdlog("gamestart7")
  TableUtility.TableClear(self.randomMaterialList)
  TableUtility.TableClear(self.totalMaterialList)
  TableUtility.TableClear(self.playerMaterialList)
  TableUtility.TableClear(self.enemyMaterialList)
  TableUtility.TableClear(self.recommendRecipeList)
  self.round = 1
  self.myTurn = true
  self.playerCookStyle = 1
  self.enemyCookStyle = 1
  self.enemyCookStyleTurnEnd = false
  self.gameExtraRule = 0
  self.inMode7Data = questData
  local specifiedRecipe = questData.params.recipe_id1
  local recipeData = Table_Recipe[specifiedRecipe]
  local materials = recipeData.Material
  for k = 1, #materials do
    local singleMaterial = materials[k][2]
    if #self.randomMaterialList > 12 then
      break
    end
    local data = {id = singleMaterial, exist = true}
    table.insert(self.randomMaterialList, data)
    table.insert(self.totalMaterialList, singleMaterial)
  end
  while #self.randomMaterialList < 12 do
    local randomID = math.random(1, #self.totalMaterialList)
    local data = {
      id = self.totalMaterialList[randomID],
      exist = true
    }
    table.insert(self.randomMaterialList, data)
  end
end

function CookMasterManager:RefreshAvailableFoodRecipe7()
  self:RefreshAvailableFoodRecipe()
end

function CookMasterManager:SetGameRule7()
  self.inMode7 = true
  self.difficulty = 1
  self.gameExtraRule = 1
end
