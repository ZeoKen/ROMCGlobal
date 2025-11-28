TechTreeProxy = class("TechTreeProxy", pm.Proxy)
TechTreeMapEffectTypes = {
  "quest_reward",
  "box_reward",
  "map_buff",
  "spec_reward_ratio",
  "map_deadreward",
  "extra_item",
  "produce_speed",
  "produce_upperlimit"
}
TechTreeFieldEffectType = {
  "raid_extra_item"
}
TechTreePersonalEffectTypes = {"attr"}
local tempArr, arrayClear, arrayPushBack, arrayFindIndex, tableClear
local toyEffectType = "toy_drawing"

function TechTreeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "TechTreeProxy"
  if not TechTreeProxy.Instance then
    TechTreeProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function TechTreeProxy:Init()
  tempArr = {}
  arrayClear = TableUtility.ArrayClear
  arrayPushBack = TableUtility.ArrayPushBack
  arrayFindIndex = TableUtility.ArrayFindIndex
  tableClear = TableUtility.TableClear
  self.unlockedLeaves = {}
  self.unlockedToys = {}
  self.unlockedTechTreeLevels = {}
  self.browsedQuestLevelNode = {}
  self.branchList = {}
  self.newbieTechTreeInjectInfo = {}
  self.techTreeLevelInfo = {}
  self:InitStaticData()
end

function TechTreeProxy:InitStaticData()
  self.staticLeaves = {}
  self.staticToys_UnlockByLeaf = {}
  local leaf, effect, drawingId, treeId
  for _, v in pairs(Table_TechTreeLeaf) do
    if v.LeafID and v.TreeID and v.Branch then
      leaf = self.staticLeaves[v.LeafID] or {}
      leaf[v.Level or 1] = v
      self.staticLeaves[v.LeafID] = leaf
      for i = 1, #v.TreeID do
        treeId = v.TreeID[i]
        if not self.unlockedLeaves[treeId] then
          self.unlockedLeaves[treeId] = {}
        end
      end
      for i = 1, #v.Effects do
        effect = Table_TechTreeEffect[v.Effects[i]]
        if effect and effect.Type == toyEffectType then
          drawingId = effect.Params.drawid
          if drawingId and arrayFindIndex(self.staticToys_UnlockByLeaf, drawingId) == 0 then
            arrayPushBack(self.staticToys_UnlockByLeaf, drawingId)
          end
        end
      end
      if not self.branchList[v.Branch] then
        self.branchList[v.Branch] = {}
      end
      arrayPushBack(self.branchList[v.Branch], v.LeafID)
    end
  end
  local maxLevel = 0
  for k, v in pairs(Table_TechTreeLevel) do
    if v.Tree and not v.Hide and v.Level then
      if not self.techTreeLevelInfo[v.Tree] then
        self.techTreeLevelInfo[v.Tree] = {
          maxLevel = v.Level
        }
      end
      if not v.Hide and v.Level and v.Tree and self.techTreeLevelInfo[v.Tree].maxLevel < v.Level then
        self.techTreeLevelInfo[v.Tree].maxLevel = v.Level
      end
    end
  end
end

function TechTreeProxy:CheckPreviousLeavesUnlock(preleafID, treeId)
  if not preleafID then
    return true
  end
  if not self:IsLeafUnlocked(preleafID, treeId) then
    return false
  end
  local pPreId = self:GetPreIdOfLeaf(preleafID, treeId)
  if pPreId == nil then
    return true
  end
  return self:CheckPreviousLeavesUnlock(pPreId, treeId)
end

function TechTreeProxy:CheckLeafIdValid(leafId)
  if not leafId then
    return false
  end
  if type(self.staticLeaves[leafId]) ~= "table" then
    return false
  end
  return true
end

function TechTreeProxy.CheckMaterialsAdequate(materialDatas, packageCheck)
  if type(materialDatas) ~= "table" then
    return false
  end
  if #materialDatas == 0 then
    return true
  end
  local isAdequate, sId, needNum, num = true
  for i = 1, #materialDatas do
    sId, needNum = materialDatas[i].itemid, materialDatas[i].num
    if not sId or not needNum then
      LogUtility.Error("Cannot find info of unlock items!")
      return
    end
    num = BagProxy.Instance:GetItemNumByStaticID(sId, packageCheck or GameConfig.PackageMaterialCheck.techtree_unlock)
    isAdequate = isAdequate and needNum <= num
  end
  return isAdequate
end

function TechTreeProxy:GetStaticValueOfLeaf(leafId, level, key)
  if not self:CheckLeafIdValid(leafId) then
    return
  end
  if level then
    local maxLevel = self:GetMaxLevelOfLeaf(leafId)
    if not maxLevel then
      level = 1
    elseif maxLevel < level then
      LogUtility.WarningFormat("You're trying to get leaf {0} static value of level {1} while the max level is only {2}!", leafId, level, maxLevel)
      return
    end
    return self.staticLeaves[leafId][level][key]
  else
    local map = self.staticLeaves[leafId]
    for _, data in pairs(map) do
      if data[key] then
        return data[key]
      end
    end
  end
end

function TechTreeProxy:GetStaticTreeIdsOfLeaf(leafId)
  local t = self:GetStaticValueOfLeaf(leafId, nil, "TreeID")
  if not t then
    LogUtility.ErrorFormat("Cannot find tree id of leaf {0}!", leafId)
    return _EmptyTable
  end
  return t
end

function TechTreeProxy:GetBranchIdOfLeaf(leafId)
  local b = self:GetStaticValueOfLeaf(leafId, nil, "Branch")
  if not b then
    LogUtility.ErrorFormat("Cannot find branch id of leaf {0}!", leafId)
  end
  return b
end

function TechTreeProxy:GetNameOfLeaf(leafId, lv)
  return self:GetStaticValueOfLeaf(leafId, lv or 1, "Name") or ""
end

function TechTreeProxy:GetIconNameOfLeaf(leafId, lv)
  return self:GetStaticValueOfLeaf(leafId, lv, "Icon")
end

function TechTreeProxy:GetDescOfLeaf(leafId, lv, treeId)
  local d = self:GetStaticValueOfLeaf(leafId, lv, "Desc")
  if self:IsLeafUnlocked(leafId, treeId) then
    return d
  end
  local pLeafId = self:GetPreIdOfLeaf(leafId, treeId)
  if pLeafId and self:IsLeafUnlocked(pLeafId, treeId) then
    if #self:GetStaticTreeIdsOfLeaf(pLeafId) > 1 then
      while pLeafId do
        pLeafId = self:GetPreIdOfLeaf(pLeafId, treeId)
        if not (not pLeafId or self:IsLeafUnlocked(pLeafId, treeId)) then
          break
        end
      end
    else
      pLeafId = nil
    end
  end
  if pLeafId then
    d = string.format(ZhString.TechTree_LeafDescWithPreviousLockedFormat, d, self:GetNameOfLeaf(pLeafId))
  end
  return d
end

function TechTreeProxy:GetStaticPreIdsOfLeaf(leafId)
  return self:GetStaticValueOfLeaf(leafId, nil, "PreID")
end

function TechTreeProxy:GetPreIdOfLeaf(leafId, treeId)
  local preIds = self:GetStaticPreIdsOfLeaf(leafId)
  if 1 < #preIds then
    return preIds[treeId]
  elseif #preIds == 1 then
    return preIds[1]
  end
end

function TechTreeProxy:GetUnlockItemsOfLeaf(leafId, lv, cacheArr)
  local items = self:GetStaticValueOfLeaf(leafId, lv, "UnlockItems")
  cacheArr = cacheArr or tempArr
  if type(items) ~= "table" or #items <= 0 then
    arrayClear(cacheArr)
    return
  end
  local sId, needNum, itemData
  for i = 1, #items do
    sId, needNum = items[i].itemid, items[i].num
    itemData = cacheArr[i] or ItemData.new()
    itemData:ResetData(MaterialItemCell.MaterialType.Material, sId)
    itemData.num = BagProxy.Instance:GetItemNumByStaticID(sId, GameConfig.PackageMaterialCheck.techtree_unlock)
    itemData.neednum = needNum
    cacheArr[i] = itemData
  end
  for i = #items + 1, #cacheArr do
    cacheArr[i] = nil
  end
  return cacheArr
end

function TechTreeProxy:GetUnlockedMapEffects(treeId)
  return self:GetEffectsOfUnlockedLeafByTypes(treeId, TechTreeMapEffectTypes)
end

function TechTreeProxy:GetUnlockedFieldEffects(treeId)
  return self:GetEffectsOfUnlockedLeafByTypes(treeId, TechTreeFieldEffectType)
end

function TechTreeProxy:GetUnlockedPersonalEffects(treeId)
  local array = ReusableTable.CreateArray()
  local leafEffect = self:GetEffectsOfUnlockedLeafByTypes(treeId, TechTreePersonalEffectTypes) or {}
  for i = 1, #leafEffect do
    arrayPushBack(array, leafEffect[i])
  end
  local levelEffect = self:GetTechTreeLevelEffects(treeId) or {}
  for i = 1, #levelEffect do
    arrayPushBack(array, levelEffect[i])
  end
  arrayClear(tempArr)
  TableUtility.ArrayShallowCopy(tempArr, array)
  ReusableTable.DestroyAndClearArray(array)
  return tempArr
end

function TechTreeProxy:GetEffectsOfUnlockedLeafByTypes(treeId, effectTypes)
  local leaves = self.unlockedLeaves[treeId]
  if not leaves then
    LogUtility.ErrorFormat("Cannot get unlock leaves of tree {0}", treeId)
    return
  end
  local array, effects = ReusableTable.CreateArray()
  for leafId, curLevel in pairs(leaves) do
    for i = 1, curLevel do
      effects = self:GetEffectsOfLeaf(leafId, i)
      for j = 1, #effects do
        if arrayFindIndex(effectTypes, effects[j].Type) > 0 then
          arrayPushBack(array, effects[j])
        end
      end
    end
  end
  arrayClear(tempArr)
  TableUtility.ArrayShallowCopy(tempArr, array)
  ReusableTable.DestroyAndClearArray(array)
  return tempArr
end

function TechTreeProxy:GetEffectsOfLeaf(leafId, lv)
  local effects = self:GetStaticValueOfLeaf(leafId, lv, "Effects")
  if type(effects) ~= "table" then
    return
  end
  arrayClear(tempArr)
  local eff
  for i = 1, #effects do
    eff = Table_TechTreeEffect[effects[i]]
    if eff then
      arrayPushBack(tempArr, eff)
    end
  end
  return tempArr
end

function TechTreeProxy:GetTechTreeLevelEffects(treeId)
  if not self.unlockedTechTreeLevels[treeId] then
    return
  end
  local array = ReusableTable.CreateArray()
  local nodeinfo = self.unlockedTechTreeLevels[treeId].nodeinfo or {}
  for id, info in pairs(nodeinfo) do
    local config = Table_TechTreeLevel[id]
    if config and config.Type == 4 then
      arrayPushBack(array, config)
    end
  end
  arrayClear(tempArr)
  TableUtility.ArrayShallowCopy(tempArr, array)
  ReusableTable.DestroyAndClearArray(array)
  return tempArr
end

function TechTreeProxy:GetLeafsByBranch(branchId)
  if not self.branchList[branchId] then
    return
  end
  return self.branchList[branchId]
end

function TechTreeProxy:IsLeafUnlocked(leafId, treeId)
  if not self:CheckLeafIdValid(leafId) then
    return false
  end
  local trees = self:GetStaticTreeIdsOfLeaf(leafId)
  if not trees then
    return false
  end
  local flag = false
  if 1 < #trees then
    if self.unlockedLeaves[treeId][leafId] then
      flag = true or flag
    end
  else
    flag = #trees == 1 and self.unlockedLeaves[trees[1]][leafId] and true or flag
  end
  return flag
end

function TechTreeProxy:IsLeafAvailable(leafId, treeId)
  if not self:CheckLeafIdValid(leafId) then
    return false
  end
  local trees = self:GetStaticTreeIdsOfLeaf(leafId)
  if not trees or #trees == 0 then
    return false
  end
  for i = 1, #trees do
    if self.unlockedLeaves[trees[i]] and self.unlockedLeaves[trees[i]][leafId] then
      return false
    end
  end
  if not TechTreeProxy.CheckMaterialsAdequate(self:GetStaticValueOfLeaf(leafId, 1, "UnlockItems"), GameConfig.PackageMaterialCheck.techtree_unlock) then
    return false
  end
  local prevLeafId = self:GetPreIdOfLeaf(leafId, treeId)
  if prevLeafId == nil then
    return true
  end
  return self:CheckPreviousLeavesUnlock(prevLeafId, treeId)
end

function TechTreeProxy:IsLeafUpgradeable(leafId)
  local curLevel = self:GetCurLevelOfLeaf(leafId)
  if not curLevel or curLevel == self:GetMaxLevelOfLeaf(leafId) then
    return false
  end
  return TechTreeProxy.CheckMaterialsAdequate(self:GetStaticValueOfLeaf(leafId, curLevel + 1, "UnlockItems"), GameConfig.PackageMaterialCheck.techtree_unlock)
end

function TechTreeProxy:IsToyLeaf(leafId)
  local effects = self:GetEffectsOfLeaf(leafId)
  if type(effects) ~= "table" or #effects <= 0 then
    return false
  end
  for i = 1, #effects do
    if effects[i].Type == toyEffectType then
      return true, effects[i].Params.drawid
    end
  end
  return false
end

function TechTreeProxy:IsToyToUnlockByLeaf(id)
  return arrayFindIndex(self.staticToys_UnlockByLeaf, id) > 0
end

function TechTreeProxy:IsToyUnlocked(id)
  return arrayFindIndex(self.unlockedToys, id) > 0
end

function TechTreeProxy:IsBranchValid(branch)
  local config = GameConfig.TechTree.TechTree_UnlockMenuid
  for menuid, branches in pairs(config) do
    if TableUtility.ArrayFindIndex(branches, branch) > 0 and FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
      return true
    end
  end
  return false
end

function TechTreeProxy:IsTechTreeLevelRewardValid(treeid)
  if not self.unlockedTechTreeLevels[treeid] then
    return false
  end
  local isValid = false
  local nodeinfo = self.unlockedTechTreeLevels[treeid].nodeinfo
  if nodeinfo then
    for k, v in pairs(nodeinfo) do
      if not v.awarded and TableUtility.ArrayFindIndex(self.browsedQuestLevelNode, k) == 0 then
        isValid = true
      end
    end
  end
  return isValid
end

function TechTreeProxy:RefreshTechTreeRewardRedtip(treeid)
  local redtipID
  if treeid == 3 then
    redtipID = SceneTip_pb.EREDSYS_TECHTREE_LEVEL_AWARD
  elseif treeid == 4 then
    redtipID = SceneTip_pb.EREDSYS_NEWBIETECHTREE_LEVEL_AWARD
  end
  local rewardValid = self:IsTechTreeLevelRewardValid(treeid)
  if rewardValid then
    RedTipProxy.Instance:UpdateRedTip(redtipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(redtipID)
  end
end

function TechTreeProxy:BrowseLevelQuestRedTip(treeid)
  if not self.unlockedTechTreeLevels[treeid] then
    return false
  end
  local nodeinfo = self.unlockedTechTreeLevels[treeid].nodeinfo
  for k, v in pairs(nodeinfo) do
    if not v.awarded and (v.queststate == 1 or v.queststate == 2) then
      table.insert(self.browsedQuestLevelNode, k)
    end
  end
  self:RefreshTechTreeRewardRedtip(treeid)
end

function TechTreeProxy:GetCurLevelOfLeaf(leafId)
  local maxLevel = self:GetMaxLevelOfLeaf(leafId)
  if not maxLevel then
    return
  end
  local trees = self:GetStaticTreeIdsOfLeaf(leafId)
  if not trees or #trees == 0 then
    return
  end
  local curLevel, treeId
  for i = 1, #trees do
    treeId = trees[i]
    if self.unlockedLeaves[treeId] then
      curLevel = self.unlockedLeaves[treeId][leafId]
      break
    end
  end
  if curLevel and (curLevel <= 0 or maxLevel < curLevel) then
    LogUtility.ErrorFormat("Invalid level {0} of leaf {1}", curLevel, leafId)
    return
  end
  return curLevel
end

function TechTreeProxy:GetMaxLevelOfLeaf(leafId)
  if not self:CheckLeafIdValid(leafId) then
    return
  end
  if #self.staticLeaves[leafId] <= 1 then
    return
  end
  return #self.staticLeaves[leafId]
end

function TechTreeProxy:TrySetLeafIcon(leafId, sprite)
  if not sprite then
    return
  end
  local iconName = self:GetIconNameOfLeaf(leafId, self:GetCurLevelOfLeaf(leafId))
  if not IconManager:SetItemIcon(iconName, sprite) then
    IconManager:SetItemIcon("item_45001", sprite)
  end
end

function TechTreeProxy:GetTreeLevelInfo(treeid)
  if self.unlockedTechTreeLevels[treeid] then
    return self.unlockedTechTreeLevels[treeid]
  end
end

function TechTreeProxy:GetTechTreeLevelInfo(treeId)
  if self.techTreeLevelInfo[treeId] then
    return self.techTreeLevelInfo[treeId]
  end
end

function TechTreeProxy:RecvSyncLeaf(data)
  for _, v in pairs(self.unlockedLeaves) do
    tableClear(v)
  end
  local treeinfo = data.treeinfo
  if treeinfo and 0 < #treeinfo then
    for i = 1, #treeinfo do
      local treeId = treeinfo[i].treeid
      if not self.unlockedTechTreeLevels[treeId] then
        self.unlockedTechTreeLevels[treeId] = {}
      end
      local leafnode = treeinfo[i].leafnode
      local tree, leaf, trees
      for j = 1, #leafnode do
        leaf = leafnode[j]
        trees = self:GetStaticTreeIdsOfLeaf(leaf)
        for k = 1, #trees do
          tree = self.unlockedLeaves[trees[k]] or {}
          tree[leaf] = 1
          self.unlockedLeaves[trees[k]] = tree
        end
      end
      local nodeinfo = treeinfo[i].nodeinfo
      local tempTable = {}
      for j = 1, #nodeinfo do
        local single = nodeinfo[j]
        tempTable[single.id] = {
          awarded = single.awarded,
          queststate = single.queststate
        }
        local level = Table_TechTreeLevel[single.id] and Table_TechTreeLevel[single.id].Level
        if level then
          if not self.techTreeLevelInfo[treeId].treeLevel then
            self.techTreeLevelInfo[treeId].treeLevel = level
          end
          if level > self.techTreeLevelInfo[treeId].treeLevel then
            self.techTreeLevelInfo[treeId].treeLevel = level
          end
        end
      end
      self.unlockedTechTreeLevels[treeId].nodeinfo = tempTable
      self:RefreshTechTreeRewardRedtip(treeId)
    end
  end
end

function TechTreeProxy:RecvUnlockLeaf(leafId, level, nodeinfo)
  local trees = self:GetStaticTreeIdsOfLeaf(leafId)
  local treeId
  for i = 1, #trees do
    treeId = trees[i]
    local tree = self.unlockedLeaves[treeId] or {}
    tree[leafId] = 1
    self.unlockedLeaves[treeId] = tree
  end
  if not self.unlockedTechTreeLevels[treeId] then
    self.unlockedTechTreeLevels[treeId] = {}
  end
  local tempTable = {}
  local nodeInfoList = self.unlockedTechTreeLevels[treeId].nodeinfo or {}
  if nodeinfo and 0 < #nodeinfo then
    for i = 1, #nodeinfo do
      local single = nodeinfo[i]
      nodeInfoList[single.id] = {
        awarded = single.awarded,
        queststate = single.queststate
      }
      self.unlockedTechTreeLevels[treeId].nodeinfo = nodeInfoList
      local level = Table_TechTreeLevel[single.id] and Table_TechTreeLevel[single.id].Level
      if level then
        if not self.techTreeLevelInfo[treeId] then
          self.techTreeLevelInfo[treeId] = {}
        end
        if not self.techTreeLevelInfo[treeId].treeLevel then
          self.techTreeLevelInfo[treeId].treeLevel = level
        end
        if level > self.techTreeLevelInfo[treeId].treeLevel then
          self.techTreeLevelInfo[treeId].treeLevel = level
        end
      end
    end
  end
  self:RefreshTechTreeRewardRedtip(treeId)
end

function TechTreeProxy:RecvSyncToy(drawingIds)
  arrayClear(self.unlockedToys)
  for i = 1, #drawingIds do
    self.unlockedToys[i] = drawingIds[i]
  end
end

function TechTreeProxy:RecvAddToy(drawingId)
  if not drawingId then
    return
  end
  self.unlockedToys = self.unlockedToys or {}
  arrayPushBack(self.unlockedToys, drawingId)
  local output = Table_ToyDrawing[drawingId] and Table_ToyDrawing[drawingId].Output
  if output then
    MsgManager.ShowMsgByIDTable(40921, Table_Item[output] and Table_Item[output].NameZh .. ZhString.TechTree_ToyDrawingSuffix or "")
  end
end

function TechTreeProxy:RecvTechTreeReward(data)
  local treeid = data.treeid
  local levelnode = data.levelnode
  if not levelnode or #levelnode == 0 then
    return
  end
  if self.unlockedTechTreeLevels[treeid] then
    local nodeinfo = self.unlockedTechTreeLevels[treeid] and self.unlockedTechTreeLevels[treeid].nodeinfo
    for i = 1, #levelnode do
      local level = levelnode[i]
      if nodeinfo[level] then
        nodeinfo[level].awarded = true
      else
        redlog("科技树等级信息未下发", level)
      end
    end
  else
    redlog("科技树未解锁", treeid)
  end
  self:RefreshTechTreeRewardRedtip(treeid)
end

function TechTreeProxy:RecvTechTreeProduceInfo(data)
  self.techTreeProduceInfo = {
    producenum = data.producenum,
    produceupperlimit = data.produceupperlimit,
    prodecespeed = data.prodecespeed
  }
  self.isFirstOpen = data.firstopen
end

function TechTreeProxy:RecvTechTreeInjectInfoCmd(data)
  local treeid = data.treeid
  if not self.newbieTechTreeInjectInfo[treid] then
    self.newbieTechTreeInjectInfo[treeid] = {}
  end
  local tempData = {
    treeid = data.treeid,
    leafnode = data.leafnode,
    injectNum = data.injected_num
  }
  xdlog("依米尔之心当前数值", tempData.leafnode, tempData.injectNum)
  self.newbieTechTreeInjectInfo[treeid] = tempData
end

function TechTreeProxy.CallUnlockLeaf(leafId, level, treeId)
  local leaf = NetConfig.PBC and {} or TechTreeCmd_pb.TechTreeLeafInfo()
  leaf.leafid = leafId
  leaf.level = level or 1
  ServiceTechTreeCmdProxy.Instance:CallTechTreeUnlockLeafCmd(leaf, treeId)
end

function TechTreeProxy.CallMakeToy(drawingId, count)
  ServiceTechTreeCmdProxy.Instance:CallTechTreeMakeToyCmd(drawingId, count)
end

function TechTreeProxy.CallSandExchange(items)
  arrayClear(tempArr)
  local item, sitem
  for i = 1, #items do
    item = items[i]
    if item.num and item.num > 0 then
      sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sitem.id, sitem.count = item.staticData.id, item.num
      arrayPushBack(tempArr, sitem)
    end
  end
  ServiceItemProxy.Instance:CallSandExchangeItemCmd(tempArr)
end

function TechTreeProxy.CallTechTreeLevelReward(treeid, levels)
  ServiceTechTreeCmdProxy.Instance:CallTechTreeLevelAwardCmd(treeid, levels)
end

function TechTreeProxy.CallTechTreeProduceCollectCmd()
  ServiceTechTreeCmdProxy.Instance:CallTechTreeProduceCollectCmd()
end

function TechTreeProxy.CallTechTreeProdecInfoCmd()
  ServiceTechTreeCmdProxy.Instance:CallTechTreeProdecInfoCmd()
end

function TechTreeProxy.CallMapRareElite()
  if Table_MonsterList then
    local mapList = {}
    for id, config in pairs(Table_MonsterList) do
      if table.ContainsValue(GameConfig.TechTree.IconShowMap, config.MapID) and TableUtility.ArrayFindIndex(mapList, config.MapID) == 0 then
        TableUtility.ArrayPushBack(mapList, config.MapID)
      end
    end
    ServiceBossCmdProxy.Instance:CallQuerySpecMapRareEliteCmd(mapList)
  end
end

local spriteLabelWithGotoModeClickUrlSetup = function(sp, color, scale, xOffset, yOffset)
  color = color or ColorUtil.NGUIWhite
  scale = scale or 1
  xOffset = xOffset or 0
  yOffset = yOffset or 0
  sp.color = color
  sp.width = math.ceil(sp.width * scale)
  sp.height = math.ceil(sp.height * scale)
  local trans = sp.transform
  local x, y = LuaGameObject.GetLocalPosition(trans)
  trans.localPosition = LuaGeometry.GetTempVector3(x + xOffset, y + yOffset)
end

function TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(spriteLabel, str)
  if not spriteLabel then
    return
  end
  spriteLabel:Reset()
  str = StringUtil.AdaptGotoModeClickUrl(str) or ""
  local exUseLua = SpriteLabel.useLuaVersion
  SpriteLabel.useLuaVersion = true
  spriteLabel:SetText(str)
  SpriteLabel.useLuaVersion = exUseLua
  UIUtil.AdaptGotoModeClickUrl(spriteLabel.richLabel.gameObject, str)
  spriteLabel:ForEachSprite(spriteLabelWithGotoModeClickUrlSetup, LuaGeometry.GetTempColor(0.3176470588235294, 0.8627450980392157, 1), 0.7, 0, 4)
end

function TechTreeProxy:CheckCanOpen()
  return FunctionUnLockFunc.Me():CheckCanOpen(10012)
end

function TechTreeProxy:CheckTechTreeUnlock()
  for k, v in pairs(GameConfig.TechTree.TechTree_UnlockMenuid) do
    if FunctionUnLockFunc.Me():CheckCanOpen(k) then
      return true
    end
  end
  return false
end

function TechTreeProxy:CheckTreeHasReachMaxLevel(treeid)
  if not self.techTreeLevelInfo then
    return false
  end
  local treeLevelInfo = self.techTreeLevelInfo[treeid]
  if not treeLevelInfo then
    return false
  end
  local maxLevel = treeLevelInfo.maxLevel
  local curLevel = treeLevelInfo.treeLevel or 0
  return maxLevel <= curLevel
end
