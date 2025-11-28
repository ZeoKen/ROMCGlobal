local _CacheTime = 60
local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
autoImport("ItemData")
UserGemInfo = class("UserGemInfo")

function UserGemInfo:ctor(server_data)
  self.query_servertime = ServerTime.CurServerTime() / 1000
  self.charid = server_data.charid
  self.accid = server_data.accid
  self.featureLv = server_data.extra_feature_level or 0
  self:_SetGemInfo(server_data.info)
end

function UserGemInfo:IsDirty()
  local now = ServerTime.CurServerTime() / 1000
  if now - self.query_servertime > _CacheTime then
    return true
  end
  return false
end

function UserGemInfo:_ResetGems()
  if self.userAttrGems then
    _ArrayClear(self.userAttrGems)
  else
    self.userAttrGems = {}
  end
  if self.userSkillGems then
    _ArrayClear(self.userSkillGems)
  else
    self.userSkillGems = {}
  end
end

function UserGemInfo:_SetGemInfo(server_info)
  self:_ResetGems()
  if not server_info then
    return
  end
  local _itemData
  local _server_AttrGems = server_info.attrgems
  if _server_AttrGems then
    for i = 1, #_server_AttrGems do
      _itemData = ItemData.new()
      _itemData:ParseFromServerData(_server_AttrGems[i])
      _ArrayPushBack(self.userAttrGems, _itemData)
    end
  end
  local _server_SkillGems = server_info.skillgems
  if _server_SkillGems then
    for i = 1, #_server_SkillGems do
      _itemData = ItemData.new()
      _itemData:ParseFromServerData(_server_SkillGems[i])
      _ArrayPushBack(self.userSkillGems, _itemData)
    end
  end
end

function UserGemInfo:GetGems()
  return self.userAttrGems, self.userSkillGems
end

function UserGemInfo:GetFeatureLv()
  return self.featureLv
end
