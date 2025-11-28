autoImport("FunctionCD")
BagItemDataFunctionCD = class("BagItemDataFunctionCD", FunctionCD)

function BagItemDataFunctionCD:ctor()
  BagItemDataFunctionCD.super.ctor(self)
  self.clientUseSkillItemMap = {}
  self.links = {}
end

function BagItemDataFunctionCD:Link(otherFunctionCD)
  if otherFunctionCD.Link == nil and TableUtil.ArrayIndexOf(self.links, otherFunctionCD) == 0 then
    self.links[#self.links + 1] = otherFunctionCD
  end
end

function BagItemDataFunctionCD:UnLink(otherFunctionCD)
  if otherFunctionCD.Link == nil then
    TableUtil.Remove(self.links, otherFunctionCD)
  end
end

function BagItemDataFunctionCD:Add(obj)
  if self:GetItemClientUseSkillId(obj) then
    self.clientUseSkillItemMap[obj.id] = obj
  end
  BagItemDataFunctionCD.super.Add(self, obj)
end

function BagItemDataFunctionCD:Remove(obj)
  self.clientUseSkillItemMap[obj.id] = nil
  BagItemDataFunctionCD.super.Remove(self, obj)
  for i = 1, #self.links do
    self.links:Remove(obj)
  end
end

function BagItemDataFunctionCD:RemoveAll()
  BagItemDataFunctionCD.super.RemoveAll(self)
  for i = 1, #self.links do
    self.links:Reset()
  end
end

local id_removes, group_removes = {}, {}

function BagItemDataFunctionCD:Update(deltaTime)
  local cdProxy = CDProxy.Instance
  local hasItemInCd = cdProxy:HasItemInCD()
  for _, item in pairs(self.clientUseSkillItemMap) do
    hasItemInCd = hasItemInCd or self:TryGetItemClientUseSkillInId(item) ~= nil
  end
  if not hasItemInCd and not self.lastHasItemInCd then
    return
  end
  local cd
  TableUtility.TableClear(id_removes)
  TableUtility.TableClear(group_removes)
  for id, item in pairs(self.objs) do
    if self.clientUseSkillItemMap[id] then
      cd = self:TryGetItemClientUseSkillInId(item)
    elseif item.cdGroup then
      cd = cdProxy:GetItemGroupInCD(item.cdGroup)
    else
      cd = cdProxy:GetItemInCD(item.staticData.id)
    end
    cd = cd and cd:GetCd()
    if cd then
      item:SetCdTime(cd)
      if cd < 0 then
        if item.cdGroup then
          group_removes[item.cdGroup] = 1
        else
          id_removes[id] = 1
        end
      end
    else
      item:SetCdTime(0)
    end
  end
  for id, _ in pairs(id_removes) do
    cdProxy:RemoveItemCD(id)
  end
  for group, _ in pairs(group_removes) do
    cdProxy:RemoveItemGroupCD(group)
  end
  self.lastHasItemInCd = hasItemInCd
end

function BagItemDataFunctionCD:TryGetItemClientUseSkillInId(item)
  local id = self:GetItemClientUseSkillId(item)
  if id then
    return CDProxy.Instance:GetSkillInCD(math.floor(id / 1000))
  end
end

function BagItemDataFunctionCD:GetItemClientUseSkillId(item)
  local sId = item and item.staticData.id
  if not sId then
    return
  end
  self.itemClientUseSkillIdMap = self.itemClientUseSkillIdMap or {}
  if self.itemClientUseSkillIdMap[sId] == nil then
    local useEffect = Table_UseItem[sId] and Table_UseItem[sId].UseEffect
    if useEffect and useEffect.type == "client_useskill" then
      self.itemClientUseSkillIdMap[sId] = useEffect.id
    else
      self.itemClientUseSkillIdMap[sId] = false
    end
  end
  return self.itemClientUseSkillIdMap[sId] or nil
end
