ShopDressingProxy = class("ShopDressingProxy", pm.Proxy)
ShopDressingProxy.Instance = nil
ShopDressingProxy.NAME = "ShopDressingProxy"
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
ShopDressingProxy.DressingType = {
  HAIR = SceneUser2_pb.EDRESSTYPE_HAIR,
  HAIRCOLOR = SceneUser2_pb.EDRESSTYPE_HAIRCOLOR,
  EYE = SceneUser2_pb.EDRESSTYPE_EYE,
  ClothColor = SceneUser2_pb.EDRESSTYPE_CLOTH
}
ShopDressingProxy.DressShopType = {
  Hair = 950,
  EyeLenses = 960,
  ClothColor = 961
}

function ShopDressingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShopDressingProxy.NAME
  if ShopDressingProxy.Instance == nil then
    ShopDressingProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ShopDressingProxy:Init()
  self.activeIDs = {}
  self.queryArgs = {}
  self:Preprocess_HairEyeUnlock()
end

function ShopDressingProxy:Preprocess_HairEyeUnlock()
  self.hairUnlockCostMap = {}
  self.eyeUnlockCostMap = {}
  local id
  local hair_unlock_config = GameConfig.HairEyeUnlock.HairUnlock
  if hair_unlock_config then
    for _, config in pairs(hair_unlock_config) do
      for i = 1, #config.item do
        id = config.item[i]
        self.hairUnlockCostMap[id] = config.cost
      end
    end
  end
  local eye_unlock_config = GameConfig.HairEyeUnlock.EyeUnlock
  if eye_unlock_config then
    for _, config in pairs(eye_unlock_config) do
      for i = 1, #config.item do
        id = config.item[i]
        self.eyeUnlockCostMap[id] = config.cost
      end
    end
  end
end

function ShopDressingProxy:GetHairUnlockItems(hairstyle_id)
  return self.hairUnlockCostMap[hairstyle_id]
end

function ShopDressingProxy:GetEyeUnlockItems(eye_style_id)
  return self.eyeUnlockCostMap[eye_style_id]
end

function ShopDressingProxy:InitOriginalDress()
  local userdata = Game.Myself.data and Game.Myself.data.userdata
  if not userdata then
    return
  end
  self.originalHair = userdata:Get(UDEnum.HAIR)
  self.originalHairColor = userdata:Get(UDEnum.HAIRCOLOR)
  self.originalBodyColor = userdata:Get(UDEnum.CLOTHCOLOR)
  self.originalBody = userdata:Get(UDEnum.BODY)
  self.originalHead = userdata:Get(UDEnum.HEAD)
  self.originalFace = userdata:Get(UDEnum.FACE)
  self:SetOriginalEye(userdata:Get(UDEnum.EYE))
end

function ShopDressingProxy:InitQueryDressing(args)
  self.shopID = args[1]
  self.shopType = args[2]
  self.shopID2 = args[3]
  self.shopType2 = args[4]
  self:InitOriginalDress()
  self:ResetQueryData()
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopID)
  ShopProxy.Instance:CallQueryShopConfig(self.shopType2, self.shopID2)
end

function ShopDressingProxy:InitProxy(shopID, shopType)
  self.shopID = shopID
  self.shopType = shopType
  self:InitOriginalDress()
  self:ResetQueryData()
  ShopProxy.Instance:CallQueryShopConfig(self.shopType, self.shopID)
end

function ShopDressingProxy:GetShopType()
  if self.shopType then
    return self.shopType
  end
end

function ShopDressingProxy:GetShopId()
  if self.shopID then
    return self.shopID
  end
end

function ShopDressingProxy:RecvNewDressing(data)
  if nil == self.activeIDs[data.type] then
    self.activeIDs[data.type] = {}
  end
  for i, v in ipairs(data.dressids) do
    local bContain = false
    for key, value in ipairs(self.activeIDs) do
      if value == v then
        bContain = true
        break
      end
    end
    if not bContain then
      table.insert(self.activeIDs[data.type], v)
    end
  end
end

function ShopDressingProxy:RecvDressingListUserCmd(data)
  if nil == self.activeIDs[data.type] then
    self.activeIDs[data.type] = {}
  end
  TableUtility.TableClear(self.activeIDs[data.type])
  for i, v in ipairs(data.dressids) do
    table.insert(self.activeIDs[data.type], v)
  end
end

function ShopDressingProxy:bActived(id, type)
  if self.activeIDs and self.activeIDs[type] then
    for k, v in ipairs(self.activeIDs[type]) do
      if v == id then
        return true
      end
    end
  end
  return false
end

function ShopDressingProxy:GetHairStyleIDByItemID(itemid)
  return Game.Item2Hair[itemid]
end

function ShopDressingProxy:SetOriginalEye(eyeId)
  local userSex = MyselfProxy.Instance:GetMySex()
  local eyeSex
  local bodyData = self.originalBody and Table_Body[self.originalBody] or nil
  local bodyFeature = bodyData and bodyData.Feature or nil
  if bodyFeature and bodyFeature & FeatureDefines_Body.Fashion > 0 then
    eyeSex = 0 < bodyFeature & FeatureDefines_Body.Female and Asset_Role.Gender.Female or Asset_Role.Gender.Male
  end
  if eyeSex and eyeSex ~= userSex then
    local parsedEyeId = Table_Eye[eyeId] and Table_Eye[eyeId].PairItemID or nil
    if parsedEyeId then
      self.originalEye = parsedEyeId
      return
    else
      redlog("EYE相关配置错误 检查Eye表及PairItemID字段，EyeID  ： ", eyeId)
    end
  end
  self.originalEye = eyeId
end

function ShopDressingProxy:ResetData(shoptype, shopid)
  self.staticData = {}
  local heroLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local csvData = ShopProxy.Instance:GetConfigByTypeId(shoptype, shopid)
  local userSex = MyselfProxy.Instance:GetMySex()
  local eyeSex
  local bodyData = Table_Body[self.originalBody]
  local bodyFeature = bodyData and bodyData.Feature or nil
  if bodyFeature and bodyFeature & FeatureDefines_Body.Fashion > 0 then
    eyeSex = 0 < bodyFeature & FeatureDefines_Body.Female and Asset_Role.Gender.Female or Asset_Role.Gender.Male
  end
  eyeSex = eyeSex or userSex
  for k, v in pairs(csvData) do
    local dressShopType = GameConfig.ShopDressingType or ShopDressingProxy.DressShopType
    if shoptype == dressShopType.ClothColor then
      if nil == self.staticData[ShopDressingProxy.DressingType.ClothColor] then
        self.staticData[ShopDressingProxy.DressingType.ClothColor] = {}
      end
      table.insert(self.staticData[ShopDressingProxy.DressingType.ClothColor], v)
    end
    local limitedLevel = 0
    if 0 < #v.LevelDes then
      local startIndex, endIndex = string.find(v.LevelDes, "%d+")
      limitedLevel = string.sub(v.LevelDes, startIndex, endIndex)
    end
    if heroLevel >= tonumber(limitedLevel) then
      if v.goodsID and v.goodsID ~= 0 then
        if shoptype == dressShopType.Hair then
          local hairid = self:GetHairStyleIDByItemID(v.goodsID)
          local hairStyleData = Table_HairStyle[hairid]
          if hairStyleData and hairStyleData.Sex and (userSex == hairStyleData.Sex or hairStyleData.Sex == 3) then
            local isActiveHair = ShopDressingProxy.IsActivityHair(hairid)
            if (not isActiveHair or self:bActived(hairid, ShopDressingProxy.DressingType.HAIR)) and hairStyleData.IsPro and hairStyleData.IsPro == 1 and hairStyleData.OnSale and hairStyleData.OnSale == 1 then
              if nil == self.staticData[ShopDressingProxy.DressingType.HAIR] then
                self.staticData[ShopDressingProxy.DressingType.HAIR] = {}
              end
              table.insert(self.staticData[ShopDressingProxy.DressingType.HAIR], v)
            end
          end
        elseif shoptype == dressShopType.EyeLenses then
          local eyeID = v.goodsID
          local eyeStaticData = Table_Eye[eyeID]
          if eyeStaticData and eyeStaticData.Sex and (userSex == eyeStaticData.Sex or eyeStaticData.Sex == 3) then
            local isActiveEye = ShopDressingProxy.IsActivityEye(v.goodsID)
            if (not isActiveEye or self:bActived(v.goodsID, ShopDressingProxy.DressingType.EYE)) and eyeStaticData.IsPro and eyeStaticData.IsPro == 1 and eyeStaticData.OnSale and eyeStaticData.OnSale == 1 then
              if nil == self.staticData[ShopDressingProxy.DressingType.EYE] then
                self.staticData[ShopDressingProxy.DressingType.EYE] = {}
              end
              table.insert(self.staticData[ShopDressingProxy.DressingType.EYE], v)
            end
          end
        end
      end
      if v.hairColorID and v.haircolorid ~= 0 then
        local hairColorID = v.hairColorID
        local hairColorData = Table_HairColor[hairColorID]
        if hairColorData then
          if nil == self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR] then
            self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR] = {}
          end
          table.insert(self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR], v)
        end
      end
    end
  end
  if shoptype == ShopDressingProxy.DressShopType.Hair then
    if self.staticData[ShopDressingProxy.DressingType.HAIR] then
      table.sort(self.staticData[ShopDressingProxy.DressingType.HAIR], function(l, r)
        return self:_sortHairFunc(l, r)
      end)
    end
    if self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR] then
      table.sort(self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR], function(l, r)
        return self:_colorSortFunc(l, r)
      end)
    end
  elseif self.staticData[ShopDressingProxy.DressingType.EYE] then
    table.sort(self.staticData[ShopDressingProxy.DressingType.EYE], function(l, r)
      return self:_sortEyelensesFunc(l, r)
    end)
  elseif self.staticData[ShopDressingProxy.DressingType.ClothColor] then
    table.sort(self.staticData[ShopDressingProxy.DressingType.ClothColor], function(l, r)
      return self:_sortClothFunc(l, r)
    end)
  end
end

function ShopDressingProxy:_sortHairFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  if not left.ShopOrder or not right.ShopOrder then
    helplog("Shop表中发型物品未配ShopOrder字段")
    return false
  end
  local leftHairId = self:GetHairStyleIDByItemID(left.goodsID)
  local bleftUnlock = self:bActived(leftHairId, ShopDressingProxy.DressingType.HAIR)
  local rightHairId = self:GetHairStyleIDByItemID(right.goodsID)
  local brightUnlock = self:bActived(rightHairId, ShopDressingProxy.DressingType.HAIR)
  if bleftUnlock and brightUnlock then
    return left.ShopOrder < right.ShopOrder
  elseif bleftUnlock and not brightUnlock then
    return true
  elseif not bleftUnlock and brightUnlock then
    return false
  else
    return left.ShopOrder < right.ShopOrder
  end
end

function ShopDressingProxy:_sortEyelensesFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  local bleftUnlock = self:bActived(left.goodsID, ShopDressingProxy.DressingType.EYE)
  local brightUnlock = self:bActived(right.goodsID, ShopDressingProxy.DressingType.EYE)
  if bleftUnlock and brightUnlock then
    return left.ShopOrder < right.ShopOrder
  elseif bleftUnlock and not brightUnlock then
    return true
  elseif not bleftUnlock and brightUnlock then
    return false
  else
    return left.ShopOrder < right.ShopOrder
  end
end

function ShopDressingProxy:_sortClothFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  local bleftUnlock = self:CheckCanOpen(left.MenuID)
  local brightUnlock = self:CheckCanOpen(right.MenuID)
  if bleftUnlock and brightUnlock then
    return left.ShopOrder < right.ShopOrder
  elseif bleftUnlock and not brightUnlock then
    return true
  elseif not bleftUnlock and brightUnlock then
    return false
  else
    return left.ShopOrder < right.ShopOrder
  end
end

function ShopDressingProxy:_colorSortFunc(left, right)
  if left == nil then
    return false
  elseif right == nil then
    return true
  end
  if not left.ShopOrder or not right.ShopOrder then
    helplog("Shop表发型颜色物品中未配ShopOrder字段.")
    return false
  end
  if left.ShopOrder ~= right.ShopOrder then
    return left.ShopOrder < right.ShopOrder
  else
    return left.id < right.id
  end
end

function ShopDressingProxy:SetHairCutQueryArgs(args)
  self.queryArgs[1] = args[1]
  self.queryArgs[2] = args[2]
  self.queryArgs[3] = args[3]
end

function ShopDressingProxy:SetHairColorQueryArgs(args)
  self.queryArgs[4] = args[1]
  self.queryArgs[5] = args[2]
end

function ShopDressingProxy:SetEyerQueryArgs(args)
  self.queryArgs[6] = args[1]
  self.queryArgs[7] = args[2]
end

function ShopDressingProxy:SetClothQueryArgs(args)
  self.queryArgs[8] = args[1]
  self.queryArgs[9] = args[2]
  self.queryArgs[10] = args[3]
  self.queryArgs[11] = args[4]
  self.queryArgs[12] = args[5]
  self.queryArgs[13] = args[6]
end

function ShopDressingProxy:ResetQueryData()
  TableUtility.TableClear(self.queryArgs)
end

function ShopDressingProxy:GetQueryArgs()
  return self.queryArgs
end

function ShopDressingProxy:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function ShopDressingProxy:CallReplaceDressing(id, count)
  ServiceSessionShopProxy.Instance:CallBuyShopItem(id, count)
end

local tempVector3 = LuaVector3.Zero()

function ShopDressingProxy:FakeDressingPreview(args)
  if nil == Game.Myself.assetRole then
    return
  end
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  LuaVector3.Better_Set(tempVector3, Game.Myself.assetRole:GetPositionXYZ())
  local parts = Asset_Role.CreatePartArray()
  parts[partIndex.Hair] = args[1]
  parts[partIndexEx.HairColorIndex] = args[2]
  parts[partIndex.Eye] = args[3]
  parts[partIndexEx.BodyColorIndex] = args[6]
  parts[partIndex.Body] = args[7]
  parts[partIndex.Head] = args[8]
  parts[partIndex.Face] = args[9]
  if nil == self.fakeAssetRole then
    self.fakeAssetRole = Asset_Role.Create(parts)
  end
  self.fakeAssetRole:SetPosition(tempVector3)
  self.fakeAssetRole:SetScale(1)
  self.fakeAssetRole:IgnoreHead(args[4])
  self.fakeAssetRole:IgnoreFace(args[5])
  self.fakeAssetRole:Redress(parts)
  self.fakeAssetRole:SetEpNodesDisplay(true)
  Asset_Role.DestroyPartArray(parts)
end

function ShopDressingProxy:DestroyFakeModel()
  if self.fakeAssetRole then
    self.fakeAssetRole:SetEpNodesDisplay(false)
    self.fakeAssetRole:Destroy()
    self.fakeAssetRole = nil
  end
end

function ShopDressingProxy:getBodyID()
  local bodyId = self.originalBody
  if self.shopType == ShopDressingProxy.DressShopType.ClothColor then
    local bodyData = Table_Body[self.originalBody]
    if bodyData and bodyData.Feature ~= nil and bodyData.Feature & FeatureDefines_Body.Fashion > 0 then
      local sex = Game.Myself.data.userdata:Get(UDEnum.SEX)
      local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
      bodyId = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
    end
  end
  return bodyId
end

function ShopDressingProxy:RedressModel(enterPreview)
  if not enterPreview then
    self:DestroyFakeModel()
    return
  end
  local userdata = Game.Myself.data.userdata
  local args = ReusableTable.CreateArray()
  args[1] = userdata:Get(UDEnum.HAIR) or 0
  args[2] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  args[3] = userdata:Get(UDEnum.EYE) or 0
  args[6] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  args[8] = userdata:Get(UDEnum.HEAD) or 0
  args[9] = userdata:Get(UDEnum.FACE) or 0
  args[4] = enterPreview
  args[5] = enterPreview
  if enterPreview then
    args[7] = self:getBodyID()
  end
  self:FakeDressingPreview(args)
  ReusableTable.DestroyAndClearArray(args)
end

function ShopDressingProxy:GetFakeRole()
  return self.fakeAssetRole
end

function ShopDressingProxy:bDyeMaterialEnough(csvID)
  if csvID then
    local hairColorData = Table_HairColor[csvID]
    if hairColorData and hairColorData.Money and #hairColorData.Money > 0 and hairColorData.Money[1].item and hairColorData.Money[1].num then
      local materialID = hairColorData.Money[1].item
      local needCount = hairColorData.Money[1].num
      if materialID then
        local itemData = BagProxy.Instance:GetItemByStaticID(materialID)
        if itemData and itemData.num and needCount <= itemData.num then
          return true
        end
      end
    end
  end
  return false
end

function ShopDressingProxy:GetCurMoneyByID(moneyID)
  if moneyID == GameConfig.MoneyId.Zeny then
    return MyselfProxy.Instance:GetROB()
  else
    errorLog(string.format("ShopDressingProxy :GetCurMoneyByID failed. moneyID is: ", tostring(moneyID)))
    return 0
  end
end

function ShopDressingProxy:IsSame(t)
  local itemID, originalID
  local args = self.queryArgs
  if ShopDressingProxy.DressingType.HAIR == t then
    itemID = args[1]
    originalID = self.originalHair
  elseif ShopDressingProxy.DressingType.HAIRCOLOR == t then
    itemID = args[4]
    originalID = self.originalHairColor
  elseif ShopDressingProxy.DressingType.EYE == t then
    itemID = args[6]
    originalID = self.originalEye
  elseif ShopDressingProxy.DressingType.ClothColor == t then
    itemID = args[8]
    originalID = self.originalBodyColor
  end
  if itemID and originalID then
    return itemID == originalID
  end
  return false
end

function ShopDressingProxy:CheckCanOpen(menuid)
  if menuid and 0 ~= menuid then
    return FunctionUnLockFunc.Me():CheckCanOpen(tonumber(menuid))
  end
  return true
end

function ShopDressingProxy:Clear()
  self.originalHair = nil
  self.originalHairColor = nil
  self.originalEye = nil
  self.originalBodyColor = nil
  self.originalBody = nil
  self:ResetQueryData()
  self:DestroyFakeModel()
end

function ShopDressingProxy.IsActivityHair(id)
  local data = Table_HairStyle[id]
  if not data then
    return
  end
  return data.Feature and data.Feature & FeatureDefines_HairStyle.Activity > 0
end

function ShopDressingProxy.IsActivityEye(id)
  local data = Table_Eye[id]
  if not data then
    return
  end
  return data.Feature and data.Feature & FeatureDefines_Eye.Activity > 0
end
