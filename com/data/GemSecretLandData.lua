local _ArrayPushBack = TableUtility.ArrayPushBack
local normalColor = "FF3115"
local changedColor = "F87739"
local labColor = LuaColor.New(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
GemSecretLandData = class("GemSecretLandData")
GemSecretLandData.SortID = {Unlock = 1, Lock = 2}
GemSecretLandData.LvRange = {
  First_Range = 1,
  Second_Range = 30,
  Third_Range = 60,
  _Length = 3
}
local GetIndexByLv = function(lv)
  if lv >= GemSecretLandData.LvRange.First_Range and lv <= GemSecretLandData.LvRange.Second_Range then
    return 1
  elseif lv > GemSecretLandData.LvRange.Second_Range and lv <= GemSecretLandData.LvRange.Third_Range then
    return 2
  else
    return 3
  end
end

function GemSecretLandData:ctor(id)
  self.id = id
  self.lv = 1
  self.maxLv = 2
  self.exp = 0
  self.buffs = {}
  self.charDataMap = {}
  local sData = Table_SecretLandGem[id]
  if not sData then
    redlog("服务器客户端SecretLandGem表不一致,id: ", id)
    return
  end
  self.sData = sData
  self:SetStaticData()
end

function GemSecretLandData:SetStaticData()
  if not self.sData then
    return
  end
  self.color = self.sData.Color
  self:setBuff(self.sData.Buffs)
  self:setDesc()
  self:setNextLv()
  self.sortId = GemSecretLandData.SortID.Lock
end

function GemSecretLandData:SetServerData(guid, server_data)
  self.guid = guid
  if not StringUtil.IsEmpty(guid) then
    self.unlock = true
    self.sortId = GemSecretLandData.SortID.Unlock
  end
  if not server_data then
    return
  end
  self.lv = server_data.lv
  self.maxLv = server_data.max_lv
  self:setNextLv()
  self:setTotalExp()
  self:setDesc()
  self:setBuff(server_data.buffs)
  self.exp = server_data.exp
  TableUtility.TableClear(self.charDataMap)
  local charid, pos
  if server_data.char_data then
    for i = 1, #server_data.char_data do
      charid = server_data.char_data[i].charid
      pos = server_data.char_data[i].pos
      if charid and 0 < charid and pos and 0 < pos then
        self.charDataMap[charid] = pos
      end
    end
  end
end

function GemSecretLandData:CanUpMax()
  if self:IsMaxLv() then
    return false
  end
  local maxLvUpConfig = self.maxLvUpConfig
  if not (maxLvUpConfig and maxLvUpConfig.BreakMaxLvCost) or nil == next(maxLvUpConfig.BreakMaxLvCost) then
    return false
  end
  local cost = maxLvUpConfig.BreakMaxLvCost
  for i = 1, #cost do
    local own = BagProxy.Instance:GetItemNumByStaticID(cost[i][1])
    if own < cost[i][2] then
      return false
    end
  end
  return true
end

function GemSecretLandData:CanUpExp()
  if self:IsMaxLv() and self:IsMax() then
    return false
  end
  local lvUpConfig = self.lvUpConfig
  if not lvUpConfig or not lvUpConfig.NeedExp then
    return false
  end
  local exp_cost = GameConfig.Gem.SecretLandGemExpItem and GameConfig.Gem.SecretLandGemExpItem.ItemID
  local exp_cost_ratio = GameConfig.Gem.SecretLandGemExpItem and GameConfig.Gem.SecretLandGemExpItem.Ratio
  if not exp_cost or not exp_cost_ratio then
    return false
  end
  local own = BagProxy.Instance:GetItemNumByStaticID(exp_cost)
  local addExp = own * exp_cost_ratio
  return 0 < addExp
end

function GemSecretLandData:setNextLv()
  local maxLv = GemProxy.Instance.maxSecretLandLv
  if maxLv <= self.lv then
    self.nextLv = nil
    self.lvUpConfig = nil
  else
    self.nextLv = self.lv + 1
    self.lvUpConfig = GemProxy.Instance:GetStaticLvUp(self.nextLv)
  end
  if self:IsMaxLv() then
    self.maxLvUpConfig = nil
  else
    self.maxLvUpConfig = GemProxy.Instance:GetStaticLvUp(self.maxLv + 1)
  end
  self.isMax = self.lv >= self.maxLv
end

function GemSecretLandData:setTotalExp()
  self.totalExp = 0
  local config = Table_SecretLandGemLvUp
  if self.lv == self.maxLv then
    local maxLv = math.max(2, self.maxLv)
    self.totalExp = config[maxLv].NeedExp - 1
  elseif self.maxLv >= 2 then
    for i = self.lv, self.maxLv do
      if config[i] then
        self.totalExp = self.totalExp + config[i].NeedExp
      end
    end
    if self.maxLv < GemProxy.Instance.maxSecretLandLv then
      self.totalExp = self.totalExp + (config[self.maxLv + 1].NeedExp - 1)
    end
  else
    self.totalExp = config[2].NeedExp - 1
  end
end

function GemSecretLandData:IsMax()
  return self.isMax == true
end

function GemSecretLandData:IsMaxLv()
  return self.maxLv >= GemProxy.Instance.maxSecretLandLv
end

function GemSecretLandData:HasBuff()
  return nil ~= next(self.buffs)
end

function GemSecretLandData:GetIcon()
  if not self.icon then
    local itemData = self:GetItemData()
    if itemData then
      self.icon = itemData.staticData.Icon
    end
  end
  return self.icon or ""
end

function GemSecretLandData:GetName()
  if not self.name then
    local itemData = self:GetItemData()
    if itemData then
      self.name = GemProxy.GetSimpleGemName(itemData.staticData)
    end
  end
  return self.name or ""
end

function GemSecretLandData:GetBuff()
  return self.buffs
end

function GemSecretLandData:setBuff(buffs)
  TableUtility.ArrayClear(self.buffs)
  if not self.sData then
    return
  end
  if not buffs then
    return
  end
  for i = 1, #buffs do
    self.buffs[#self.buffs + 1] = buffs[i]
  end
end

function GemSecretLandData:setDesc()
  local parse_param = self:ParseParam(self.lv, normalColor)
  if nil == next(parse_param) then
    return
  end
  self.desc = string.format(self.sData.Desc, unpack(parse_param))
  self:SetSpDesc()
end

function GemSecretLandData:GetDesc()
  local array = {}
  TableUtility.ArrayShallowCopy(array, self.descArray)
  return array
end

function GemSecretLandData:SetSpDesc()
  local result = ""
  local desc = string.split(self.desc, "\n")
  self.descArray = {}
  self.contextDatas = {}
  for i = 1, #desc do
    self.descArray[i] = desc[i]
    self.contextDatas[i] = {
      label = ItemTipDefaultUiIconPrefix .. desc[i],
      fontsize = 20,
      color = labColor,
      hideline = true,
      labelConfig = {labwidth = 480}
    }
  end
end

function GemSecretLandData:ParseParam(lv, color)
  if not self.sData then
    return
  end
  local desc = self.sData.Desc
  if not desc then
    return
  end
  local param = self.sData.Param
  if not param then
    return
  end
  local parse_param = {}
  for i = 1, #param do
    _ArrayPushBack(parse_param, color)
    if #param[i] == GemSecretLandData.LvRange._Length then
      local value = ItemUtil.calcSecretLandBuff(lv, param[i])
      _ArrayPushBack(parse_param, value)
    else
      local value = ItemUtil.calcSecretLandHpBuff(lv, param[i])
      _ArrayPushBack(parse_param, value)
    end
  end
  return parse_param
end

function GemSecretLandData:SetChangedContextDatas(lv)
  local parse_param = self:ParseParam(lv, changedColor)
  if nil == next(parse_param) then
    return
  end
  local desc = string.format(self.sData.Desc, unpack(parse_param))
  self.changedContextDatas = {}
  desc = string.split(desc, "\n")
  for i = 1, #desc do
    self.changedContextDatas[i] = {
      label = ItemTipDefaultUiIconPrefix .. desc[i],
      fontsize = 20,
      color = labColor,
      hideline = true,
      labelConfig = {labwidth = 480}
    }
  end
end

function GemSecretLandData:GetItemData()
  local data
  if self.guid then
    data = BagProxy.Instance:GetItemByGuid(self.guid, BagProxy.BagType.SecretLand)
  end
  if not data then
    data = ItemData.new("secretLandData" .. self.id, self.sData.ItemID)
    data.secretLandDatas = self
  end
  return data
end

function GemSecretLandData:GetPosByID(id)
  return self.charDataMap[id]
end

function GemSecretLandData:GetPos()
  local my_id = Game.Myself.data.id
  return self.charDataMap[my_id] or 0
end

function GemSecretLandData:CheckCharIdIsValid()
  return true
end
