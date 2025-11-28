autoImport("SceneBottomNameFactionCell")
DynamicSceneBottomUIPool = class("DynamicSceneBottomUIPool")

function DynamicSceneBottomUIPool.Me()
  if nil == DynamicSceneBottomUIPool.me then
    DynamicSceneBottomUIPool.me = DynamicSceneBottomUIPool.new()
  end
  return DynamicSceneBottomUIPool.me
end

function DynamicSceneBottomUIPool:ctor()
  self.m_go = GameObject()
  self.m_go.name = "_dynamicSceneUIPool"
  self.m_go:SetActive(false)
  GameObject.DontDestroyOnLoad(self.m_go)
  self.creatingMap = {}
  self.m_showList = {}
  self.m_cacheList = {}
end

function DynamicSceneBottomUIPool:create(_id, _parent, _creature)
  if #self.m_cacheList == 0 then
    local resId = SceneBottomNameFactionCell.resId
    self.creatingMap[_id] = 1
    Game.CreatureUIManager:AsyncCreateUIAsset(_id, resId, _parent, self.loadNameFactionFinish, {
      _creature,
      _id,
      self
    }, nil, SceneBottomNameFactionCell.OpitimizedMode)
  else
    local newUI = _creature:GetSceneUI().roleBottomUI
    local luaIObj = self.m_cacheList[1]
    newUI.nameFactionCell = luaIObj
    local isVisible = newUI:isNameFactionVisible(_creature)
    luaIObj:setNameFactionVisible(isVisible)
    local creatureType = _creature:GetCreatureType()
    local showPre = creatureType == Creature_Type.Npc
    if showPre and FunctionQuest.Me():checkShowMonsterNamePre(_creature) then
      luaIObj:SetQuestPrefixName(_creature, true)
    end
    luaIObj:refreshData(_parent, _creature)
    table.remove(self.m_cacheList, 1)
    table.insert(self.m_showList, luaIObj)
  end
end

function DynamicSceneBottomUIPool:removeWaiting(id)
  if self.creatingMap[id] then
    self.creatingMap[id] = nil
    Game.CreatureUIManager:RemoveCreatureWaitUI(id, SceneBottomNameFactionCell.resId)
    return true
  end
  return false
end

function DynamicSceneBottomUIPool:getShowList()
  return self.m_showList
end

function DynamicSceneBottomUIPool.loadNameFactionFinish(obj, param)
  if obj then
    local creature, id, self = param[1], param[2], param[3]
    self.creatingMap[id] = nil
    local data = {}
    data[1] = obj
    data[2] = creature
    local sceneUI = creature:GetSceneUI()
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      local luaObj = SceneBottomNameFactionCell.CreateAsArray(data)
      bottomUI.nameFactionCell = luaObj
      local isVisible = bottomUI:isNameFactionVisible(creature)
      bottomUI.nameFactionCell:setNameFactionVisible(isVisible)
      local creatureType = creature:GetCreatureType()
      local showPre = creatureType == Creature_Type.Npc
      if showPre and FunctionQuest.Me():checkShowMonsterNamePre(creature) then
        bottomUI.nameFactionCell:SetQuestPrefixName(creature, true)
      end
      table.insert(DynamicSceneBottomUIPool.Me().m_showList, luaObj)
    end
  end
end

function DynamicSceneBottomUIPool:cache(_value)
  for i = #self.m_showList, 1, -1 do
    if _value == self.m_showList[i] then
      _value:initSprite()
      SetParent(_value.gameObject, self.m_go.transform)
      table.insert(self.m_cacheList, self.m_showList[i])
      table.remove(self.m_showList, i)
      break
    end
  end
end

function DynamicSceneBottomUIPool:clear()
  for _, value in ipairs(self.m_showList) do
    self:cache(value)
  end
  self.m_showList = {}
  for i = #self.m_cacheList, 1, -1 do
    ReusableObject.Destroy(self.m_cacheList[i])
    table.remove(self.m_cacheList, i)
  end
  self.m_cacheList = {}
end
