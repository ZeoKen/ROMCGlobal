PassUserData = class("PassUserData")
local _Extra_Off = 101
local _Extra_Def = 102
local parseItemDataFromServer = function(srcData, dest)
  local itemData = ItemData.new()
  itemData:ParseFromServerData(srcData)
  if itemData.index then
    dest[itemData.index] = itemData
  else
    TableUtility.ArrayPushBack(dest, itemData)
  end
end

function PassUserData:ctor(serverdata)
  self.equips = {}
  self.shadows = {}
  self.extractions = {}
  self.extra_off = ExtractionData.new(_Extra_Off)
  self.extra_def = ExtractionData.new(_Extra_Def)
  self.playerData = nil
  self:SetData(serverdata)
end

function PassUserData:SetData(serverdata)
  if serverdata then
    self.id = serverdata.charid
    self.playerData = PlayerData.CreateAsTable(serverdata)
    local userData = self.playerData.userdata
    for i = 1, #serverdata.datas do
      local data = serverdata.datas[i]
      userData:SetByID(data.type, data.value, data.data)
    end
    local props = self.playerData.props
    for i = 1, #serverdata.attrs do
      local attr = serverdata.attrs[i]
      props:SetValueById(attr.type, attr.value)
    end
    if serverdata.equip then
      for i = 1, #serverdata.equip do
        parseItemDataFromServer(serverdata.equip[i], self.equips)
      end
    end
    if serverdata.shadow then
      for i = 1, #serverdata.shadow do
        parseItemDataFromServer(serverdata.shadow[i], self.shadows)
      end
    end
    if serverdata.extraction then
      for i = 1, #serverdata.extraction do
        local gridid = serverdata.extraction[i].gridid
        local itemid = serverdata.extraction[i].itemid
        local config = Table_EquipExtraction[itemid]
        local attrType = config and config.AttrType
        local extractionData
        if attrType == 1 then
          extractionData = self.extra_off
          gridid = _Extra_Off
        elseif attrType == 2 then
          extractionData = self.extra_def
          gridid = _Extra_Def
        end
        if extractionData then
          extractionData:Update(serverdata.extraction[i])
          local data = ExtractionItemData.new("PlayerExtractionItemData_" .. gridid, itemid)
          data:ParseFromExtractionData(extractionData)
          self.extractions[gridid] = data
        end
      end
    end
    self.source = userData:GetById(ProtoCommon_pb.EUSERDATATYPE_RAIDID)
  end
end

function PassUserData:GetProfession()
  if self.playerData then
    return self.playerData.userdata:Get(UDEnum.PROFESSION)
  end
end

function PassUserData:GetEquips()
  return self.equips
end

function PassUserData:GetShadows()
  return self.shadows
end

function PassUserData:GetExtractions()
  return self.extractions
end

function PassUserData:GetSource()
  return self.source
end

function PassUserData:IsFromPvp()
  local mapInfo = Table_Map[self.source]
  return mapInfo and mapInfo.PVPmap == 1 or false
end
