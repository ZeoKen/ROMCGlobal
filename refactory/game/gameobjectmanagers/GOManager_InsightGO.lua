GOManager_InsightGO = class("GOManager_InsightGO")

function GOManager_InsightGO:ctor()
  self.insightGO = {}
  self.outlines = {}
  self.npc = {}
  self.insightBlockInfo = {}
end

function GOManager_InsightGO:RegisterGameObject(obj)
  local objID = obj.ID
  if not objID then
    redlog("InsightGO:RegisterGameObject obj id nil")
    return
  end
  local lv = objID // 1000
  if not self.insightGO[lv] then
    self.insightGO[lv] = {}
  end
  self.insightGO[lv][objID % 1000] = obj
  if not self.outlines[lv] then
    self.outlines[lv] = {}
  end
  local ppo = obj:GetComponent(PostProcessOutline)
  ppo.enabled = false
  self.outlines[lv][objID % 1000] = ppo
  return true
end

function GOManager_InsightGO:UnregisterGameObject(obj)
  local objID = obj.ID
  if not objID then
    redlog("InsightGO:RegisterGameObject obj id nil")
    return
  end
  local lv = objID // 1000
  if not self.insightGO[lv] then
    return
  end
  self.insightGO[lv][objID % 1000] = nil
  self.outlines[lv][objID % 1000] = nil
  return true
end

function GOManager_InsightGO:GetObjByLv(lv)
  lv = lv or 0
  local mapid = Game.MapManager:GetMapID()
  if not (self.insightBlockInfo[mapid] and self.insightBlockInfo[mapid].OBJ) or not self.insightBlockInfo[mapid].OBJ[lv] then
    return self.insightGO[lv]
  end
  local blockList = self.insightBlockInfo[mapid].OBJ and self.insightBlockInfo[mapid].OBJ[lv]
  if self.insightGO[lv] then
    local result = {}
    for k, v in pairs(self.insightGO[lv]) do
      if not blockList[k] then
        result[k] = v
      end
    end
    return result
  end
  return nil
end

function GOManager_InsightGO:GetOutlineByLv(lv)
  lv = lv or 0
  return self.outlines[lv]
end

function GOManager_InsightGO:AddNPC(npcuid, menuID, outline, npcid, outlinecolor)
  if not npcuid or not outline then
    return
  end
  local single = {}
  single.menuID = menuID
  single.outline = outline
  single.id = npcid
  if outlinecolor then
    local _, outlineColor = ColorUtil.TryParseHtmlString(outlinecolor)
    single.OutlineColor = outlineColor
  end
  self.npc[npcuid] = single
end

function GOManager_InsightGO:RemoveNPC(npcuid)
  if self.npc and self.npc[npcuid] then
    self.npc[npcuid] = nil
  end
end

local DefaultNPCColor = LuaColor.New(0.29411764705882354, 0.7215686274509804, 0.8431372549019608, 1)

function GOManager_InsightGO:ShowNormalNPCOutline(checkRange)
  if not self.npc then
    return
  end
  local _NSceneNpcProxy = NSceneNpcProxy
  local myPos = Game.Myself:GetPosition()
  local diffColor = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(4608)
  for npcuid, npcInfo in pairs(self.npc) do
    if not self:CheckNpcOutlineBlock(npcInfo.id) and (not npcInfo.menuID or npcInfo.menuID and FunctionUnLockFunc.Me():CheckCanOpen(npcInfo.menuID)) then
      local ncreature = _NSceneNpcProxy.Instance:Find(npcuid)
      if ncreature and checkRange >= LuaVector3.Distance(myPos, ncreature:GetPosition()) then
        if diffColor and diffColor.lv and diffColor.lv > 0 then
          npcInfo.outline.OutlineColor = npcInfo.OutlineColor
        else
          npcInfo.outline.OutlineColor = DefaultNPCColor
        end
        npcInfo.outline.enabled = true
      else
        npcInfo.outline.enabled = false
      end
    end
  end
end

function GOManager_InsightGO:HideNormalNPCOutline()
  if not self.npc then
    return
  end
  for _, npcInfo in pairs(self.npc) do
    npcInfo.outline.enabled = false
  end
end

function GOManager_InsightGO:InsightBlock(data)
  local mapID = data.mapid
  if not self.insightBlockInfo[mapID] then
    self.insightBlockInfo[mapID] = {}
  end
  local hide = data.hide
  if hide then
    local npcids = data.npcid
    if npcids and 0 < #npcids then
      if not self.insightBlockInfo[mapID].NPC then
        self.insightBlockInfo[mapID].NPC = {}
      end
      for i = 1, #npcids do
        if TableUtility.ArrayFindIndex(self.insightBlockInfo[mapID].NPC, npcids[i]) == 0 then
          xdlog("添加屏蔽洞察NPC", mapID, npcids[i])
          table.insert(self.insightBlockInfo[mapID].NPC, npcids[i])
        end
      end
    end
    local objects = data.objectid
    if objects and 0 < #objects then
      if not self.insightBlockInfo[mapID].OBJ then
        self.insightBlockInfo[mapID].OBJ = {}
      end
      for i = 1, #objects do
        local single = objects[i]
        local lv = single // 1000
        local objId = single % 1000
        if not self.insightBlockInfo[mapID].OBJ[lv] then
          self.insightBlockInfo[mapID].OBJ[lv] = {}
        end
        xdlog("添加场景物件屏蔽", mapID, single, lv, objId)
        self.insightBlockInfo[mapID].OBJ[lv][objId] = 1
      end
    end
  else
    local npcids = data.npcid
    if npcids and 0 < #npcids and self.insightBlockInfo[mapID].NPC then
      local tempNpcs = {}
      for i = 1, #self.insightBlockInfo[mapID].NPC do
        if TableUtility.ArrayFindIndex(npcids, self.insightBlockInfo[mapID].NPC[i]) == 0 then
          table.insert(tempNpcs, self.insightBlockInfo[mapID].NPC[i])
        end
      end
      self.insightBlockInfo[mapID].NPC = tempNpcs
    end
    local objects = data.objectid
    if objects and 0 < #objects then
      for i = 1, #objects do
        local single = objects[i]
        local lv = single // 1000
        local objId = single % 1000
        if self.insightBlockInfo[mapID].OBJ[lv] and self.insightBlockInfo[mapID].OBJ[lv][objId] then
          redlog("移除物体屏蔽", mapID, single, lv, objId)
          self.insightBlockInfo[mapID].OBJ[lv][objId] = nil
        end
      end
    end
  end
end

function GOManager_InsightGO:CheckNpcOutlineBlock(npcid)
  local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  local mapid = Game.MapManager:GetMapID()
  if curImageId ~= 0 then
    mapid = curImageId
  end
  if not self.insightBlockInfo[mapid] or not self.insightBlockInfo[mapid].NPC then
    return false
  end
  local blockNpcList = self.insightBlockInfo[mapid].NPC
  if 0 < TableUtility.ArrayFindIndex(blockNpcList, npcid) then
    return true
  end
  return false
end
