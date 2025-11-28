GemAttrData = class("GemAttrData")

function GemAttrData:ctor(guid, attrData)
  self.itemGuid = guid or nil
  self.propDescs = {}
  self.valueDescs = {}
  self:SetData(attrData)
end

function GemAttrData:SetData(data)
  if type(data) ~= "table" or not next(data) then
    LogUtility.Warning("Cannot set GemAttrData when data is nil or non-table!")
    return
  end
  self.id = data.id
  self.pos = data.pos
  self.time = data.time
  self.charId = data.charid or data.charId
  self.staticDatas = GemProxy.Instance:GetStaticDatasOfAttributeGem(self.id)
  if not self.staticDatas then
    LogUtility.WarningFormat("Cannot get static data of attribute gem with id = {0}!", self.id)
    self.staticDatas = {}
  end
  self.maxLv = #self.staticDatas
  self:SetLevelAndExp(data.lv, data.exp)
  self.type = self.staticDatas[1] and self.staticDatas[1].Type
end

function GemAttrData:SetLevelAndExp(lv, exp)
  self.lv = lv
  self.exp = exp
  self:UpdateAttrDescs()
end

function GemAttrData:UpdateAttrDescs()
  TableUtility.ArrayClear(self.propDescs)
  TableUtility.ArrayClear(self.valueDescs)
  local staticData = self:GetStaticDataOfCurLevel()
  if not staticData or not staticData.Dsc then
    LogUtility.WarningFormat("Cannot get attr static data from Table_GemUpgrade when GemAttrData id = {0}, lv = {1} and exp = {2}", self.id, self.lv, self.exp)
    return
  end
  local attrDescs = string.split(staticData.Dsc, "\n")
  local attrDescElements
  for i = 1, #attrDescs do
    attrDescElements = string.split(attrDescs[i], "$")
    if attrDescElements and #attrDescElements == 2 then
      self.propDescs[i] = attrDescElements[1]
      self.valueDescs[i] = attrDescElements[2]
    end
  end
end

function GemAttrData:SetTotalExp(exp)
  if not self.staticDatas or not next(self.staticDatas) then
    LogUtility.ErrorFormat("There's no staticData when you're trying to set total exp of gem with id = {0}!", self.id)
    return
  end
  local i, data, data1 = 1
  while true do
    data = self.staticDatas[i]
    if not data then
      break
    end
    data1 = self.staticDatas[i + 1]
    if exp < data.ExpAll then
      self:SetLevelAndExp(0, exp)
      break
    elseif not data1 then
      self:SetLevelAndExp(i, exp - data.ExpAll)
      break
    elseif exp == data.ExpAll then
      self:SetLevelAndExp(i, 0)
      break
    elseif exp > data.ExpAll and exp < data1.ExpAll then
      self:SetLevelAndExp(i, exp - data.ExpAll)
      break
    end
    i = i + 1
  end
end

function GemAttrData:GetTotalExp()
  return self:GetExpAll() + self.exp
end

function GemAttrData:GetExpAll()
  local curStaticData = self:GetStaticDataOfCurLevel()
  if not curStaticData then
    return 0
  end
  return curStaticData.ExpAll
end

function GemAttrData:GetStaticDataOfCurLevel()
  return self.staticDatas[self.lv]
end

function GemAttrData:GetExpForNextLevel()
  local nextLvData = self.staticDatas[self.lv + 1]
  if not nextLvData then
    return 0
  end
  return nextLvData.Exp
end

function GemAttrData:GetExpInfoDescArray()
  if #self.propDescs ~= #self.valueDescs then
    LogUtility.ErrorFormat("Length of PropDescs and length of ValueDescs is not equal when gem attr id = {0}", self.id)
    return
  end
  local descTable = {}
  for i = 1, #self.propDescs do
    TableUtility.ArrayPushBack(descTable, self.propDescs[i] .. self.valueDescs[i])
  end
  return descTable
end

function GemAttrData:IsMax()
  return self.lv >= self.maxLv
end

function GemAttrData:IsOverflow()
  return self:IsMax() and self.exp > 0
end

function GemAttrData:Clone()
  return GemAttrData.new(self.itemGuid, self)
end
