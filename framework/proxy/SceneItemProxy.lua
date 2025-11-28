autoImport("SceneObjectProxy")
autoImport("SceneDropItem")
SceneItemProxy = class("SceneItemProxy", SceneObjectProxy)
SceneItemProxy.Instance = nil
SceneItemProxy.NAME = "SceneItemProxy"

function SceneItemProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneItemProxy.NAME
  self.userMap = {}
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneItemProxy.Instance == nil then
    SceneItemProxy.Instance = self
  end
  self:InitConfig()
end

function SceneItemProxy:InitConfig()
  self.typeConfig = {}
  for k, v in pairs(GameConfig.SceneDropItem) do
    if type(v) == "table" then
      local types = v.Types
      if types ~= nil then
        for i = 1, #types do
          self.typeConfig[types[i]] = v
        end
      end
    end
  end
end

function SceneItemProxy:Add(data)
  local item = self.userMap[data.guid]
  if item == nil then
    local staticData = Table_Item[data.id]
    if not staticData then
      error(string.format("服务器要求添加道具%s,配置未找到", data.id))
    end
    item = SceneDropItem.CreateAsTable()
    item:ResetData(data.guid, staticData, Table_Equip[data.id], data.time, data.disappear_time, data.pos, data.owners, self.typeConfig[staticData.Type], data.sourceid, data.refinelv, data.stage, data.from_pos)
    self.userMap[data.guid] = item
  else
    item = nil
  end
  if item and FunctionPurify.Me():MonsterNeedPurify(item.sourceID) then
    FunctionPurify.Me():AddDrops(item)
    item = nil
  end
  return item
end

function SceneItemProxy:PureAddSome(datas)
  local items = {}
  local item
  for i = 1, #datas do
    item = self:Add(datas[i])
    if item ~= nil then
      items[#items + 1] = item
    end
  end
  return items
end

function SceneItemProxy:DropItems(datas)
  local items = self:AddSome(datas)
  FunctionSceneItemCommand.Me():DropItems(items)
end

function SceneItemProxy:RefreshAdd(datas)
end

function SceneItemProxy:Remove(guid)
  local item = self.userMap[guid]
  if item then
    self.userMap[guid] = nil
  end
  return item
end

function SceneItemProxy:SetRemoveFlags(guids)
  if guids ~= nil and 0 < #guids then
    for i = 1, #guids do
      self:SetRemoveFlag(guids[i])
    end
  end
end

function SceneItemProxy:SetRemoveFlag(guid)
  if self:Remove(guid) then
    FunctionSceneItemCommand.Me():SetRemoveFlag(guid)
  end
end

function SceneItemProxy:RemoveSome(guids)
end

function SceneItemProxy:Clear()
  self.userMap = {}
  FunctionSceneItemCommand.Me():Clear()
end
