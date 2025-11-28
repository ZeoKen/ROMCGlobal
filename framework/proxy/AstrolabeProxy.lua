AstrolabeProxy = class("AstrolabeProxy", pm.Proxy)
AstrolabeProxy.Instance = nil
AstrolabeProxy.NAME = "AstrolabeProxy"
AstrolabeProxy.ContributeItemId = 140
AstrolabeProxy.GoldMedalItemId = 5261
autoImport("Astrolabe_BordData")

function AstrolabeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AstrolabeProxy.NAME
  if AstrolabeProxy.Instance == nil then
    AstrolabeProxy.Instance = self
  end
  self:Init()
end

function AstrolabeProxy:Init()
  self:TryPreprocessTableAstrolabe()
  self.curBord = Astrolabe_BordData.new()
  if not AstrolabeProxy.BindedContributeItemId then
    AstrolabeProxy.BindedContributeItemId = GameConfig.BindItem[AstrolabeProxy.ContributeItemId]
  end
  if not AstrolabeProxy.BindedGoldMedalItemId then
    AstrolabeProxy.BindedGoldMedalItemId = GameConfig.BindItem[AstrolabeProxy.GoldMedalItemId]
  end
end

function AstrolabeProxy:TryPreprocessTableAstrolabe()
  if GameConfig.Astrolabe.UseWebConnect ~= 1 then
    return
  end
  local t = Table_Astrolabe
  for _, data in pairs(t) do
    local stars = data.stars
    for id, v in pairs(stars) do
      v[3] = v[1]
    end
    for id, v in pairs(stars) do
      local innerConnect = {}
      v[1] = innerConnect
      local pos_Width, dir_index = 0, 0
      if 0 < id then
        pos_Width = math.floor((id - 1) / 6) + 1
        dir_index = id % 6
        dir_index = dir_index == 0 and 6 or dir_index
      end
      local min, max = 0, 3
      if id == 0 then
        for i = 1, 6 do
          for j = pos_Width + 1, max do
            local k = i + 6 * (j - 1)
            if stars[k] then
              innerConnect[#innerConnect + 1] = k
              break
            end
          end
        end
      else
        local i = dir_index
        for j = pos_Width - 1, min, -1 do
          local k = math.max(i + 6 * (j - 1), 0)
          if stars[k] then
            innerConnect[#innerConnect + 1] = k
            break
          end
        end
        for j = pos_Width + 1, max do
          local k = i + 6 * (j - 1)
          if stars[k] then
            innerConnect[#innerConnect + 1] = k
            break
          end
        end
      end
      if id ~= 0 then
        local max = pos_Width * 6
        local min = max - 5
        local k = id
        while true do
          k = k + 1
          if max < k then
            k = min
          end
          if k == id or 0 < TableUtility.ArrayFindIndex(innerConnect, k) then
            break
          end
          if stars[k] then
            innerConnect[#innerConnect + 1] = k
            break
          end
        end
        k = id
        while true do
          k = k - 1
          if min > k then
            k = max
          end
          if k == id or 0 < TableUtility.ArrayFindIndex(innerConnect, k) then
            break
          end
          if stars[k] then
            innerConnect[#innerConnect + 1] = k
            break
          end
        end
      end
    end
  end
end

function AstrolabeProxy:GetActiveStarPoints()
  local total = 0
  for k, pointData in pairs(self:GetActivePointsMap()) do
    total = total + 1
  end
  return total
end

function AstrolabeProxy:GetActivePointsMap()
  return self.curBord:GetActivePointsMap()
end

function AstrolabeProxy:GetPlanIdsMap()
  return self.curBord:GetPlanIdsMap()
end

function AstrolabeProxy:GetTotalPointCount(rolelv, profession)
  if rolelv == nil then
    rolelv = MyselfProxy.Instance:RoleLevel()
  end
  if profession == nil then
    profession = MyselfProxy.Instance:GetMyProfession()
  end
  return self.curBord:GetTotalPointCount(rolelv, profession)
end

function AstrolabeProxy:InitProfessionPlate_PropData(profession)
  self.curBord:InitPlates_Prop(profession)
end

function AstrolabeProxy:UnlockPlateByMenuId(menuid)
  self.curBord:UnlockPlateByMenuId(menuid)
end

function AstrolabeProxy:GetCurBordData()
  return self.curBord
end

function AstrolabeProxy:Server_SetActivePoints(pids, actType)
  self.curBord:Server_SetActivePoints(pids, actType)
end

function AstrolabeProxy:Server_ResetPoints(server_stars, noReset)
  self.curBord:Server_ResetPoints(server_stars)
end

function AstrolabeProxy:ResetPlate()
  self.curBord:Reset()
end

function AstrolabeProxy:GetEffectMap(plate)
  return self.curBord:GetAdd_EffectMap()
end

function AstrolabeProxy:GetSkill_SpecialEffect(skillid)
  return self.curBord:GetSkill_SpecialEffect(skillid)
end

function AstrolabeProxy:GetSpecialEffectCount(specialEffectId)
  return self.curBord:GetSpecialEffectCount(specialEffectId)
end

function AstrolabeProxy:SkillSetSpecialEnable(specialEffectId, enabled)
  self.curBord:SkillSetSpecialEnable(specialEffectId, enabled)
end

function AstrolabeProxy:CheckNeed_DoServer_InitPlate()
  self.curBord:CheckNeed_DoServer_InitPlate()
end

function AstrolabeProxy:CheckCanActive_AnyAstrolabePoint()
  local offMap = self.curBord:GetOffPointsIDMap()
  local hasOff, pointData, cost = false
  local rob = MyselfProxy.Instance:GetROB()
  local contribute, bindedContribute = AstrolabeProxy.GetContributeNum(), AstrolabeProxy.GetBindedContributeNum()
  local goldMedal, bindedGoldMedal = AstrolabeProxy.GetGoldMedalNum(), AstrolabeProxy.GetBindedGoldMedalNum()
  for guid, _ in pairs(offMap) do
    hasOff = true
    pointData = self:GetPoint(nil, guid)
    cost = pointData:GetCost()
    for j = 1, #cost do
      if cost[j][1] == 100 then
        if rob < cost[j][2] then
          return false
        end
      elseif cost[j][1] == AstrolabeProxy.ContributeItemId then
        if contribute + bindedContribute < cost[j][2] then
          return false
        end
      elseif cost[j][1] == AstrolabeProxy.GoldMedalItemId and goldMedal + bindedGoldMedal < cost[j][2] then
        return false
      end
    end
  end
  return hasOff
end

function AstrolabeProxy:CheckPlateIsUnlock(plateid, bordData)
  bordData = bordData or self.curBord
  return bordData:CheckPlateIsUnlock(plateid)
end

function AstrolabeProxy.GetContributeNum()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CONTRIBUTE) or 0
end

function AstrolabeProxy.GetBindedContributeNum()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BIND_CONTRIBUTE) or 0
end

function AstrolabeProxy.GetGoldMedalNum()
  return BagProxy.Instance:GetItemNumByStaticID(AstrolabeProxy.GoldMedalItemId, GameConfig.PackageMaterialCheck.default)
end

function AstrolabeProxy.GetBindedGoldMedalNum()
  return BagProxy.Instance:GetItemNumByStaticID(AstrolabeProxy.BindedGoldMedalItemId, GameConfig.PackageMaterialCheck.default)
end

function AstrolabeProxy.TryConvertBindedCostMap(costMap)
  if type(costMap) ~= "table" then
    return false
  end
  local contributeCost, goldMedalCost = costMap[AstrolabeProxy.ContributeItemId], costMap[AstrolabeProxy.GoldMedalItemId]
  if contributeCost then
    costMap[AstrolabeProxy.BindedContributeItemId] = math.min(contributeCost, AstrolabeProxy.GetBindedContributeNum())
    costMap[AstrolabeProxy.ContributeItemId] = contributeCost - costMap[AstrolabeProxy.BindedContributeItemId]
    if costMap[AstrolabeProxy.ContributeItemId] <= 0 then
      costMap[AstrolabeProxy.ContributeItemId] = nil
    end
  end
  if goldMedalCost then
    costMap[AstrolabeProxy.BindedGoldMedalItemId] = math.min(goldMedalCost, AstrolabeProxy.GetBindedGoldMedalNum())
    costMap[AstrolabeProxy.GoldMedalItemId] = goldMedalCost - costMap[AstrolabeProxy.BindedGoldMedalItemId]
    if costMap[AstrolabeProxy.GoldMedalItemId] <= 0 then
      costMap[AstrolabeProxy.GoldMedalItemId] = nil
    end
  end
end

function AstrolabeProxy:GetBordData_BySaveInfo(saveInfoData, useBranch)
  if saveInfoData == nil then
    return
  end
  local bordData = Astrolabe_BordData.new()
  local professionId
  if useBranch then
    professionId = saveInfoData:GetProfession()
  else
    professionId = saveInfoData:GetProfession()
  end
  bordData:InitPlates_Prop(professionId)
  bordData:InitUnlockParam(saveInfoData:GetProfession(), 200)
  local astrolabeSaveData = saveInfoData:GetAstroble()
  if astrolabeSaveData == nil then
    return bordData
  end
  local server_stars = astrolabeSaveData:GetActiveStars()
  local temp = {}
  TableUtility.ArrayShallowCopy(temp, server_stars)
  if #temp == 0 then
    table.insert(temp, Astrolabe_Origin_PointID)
  end
  bordData:Server_SetActivePoints(temp)
  return bordData
end

function AstrolabeProxy:GetStorageActivePointsCost(storageId)
  local server_stars = MultiProfessionSaveProxy.Instance:GetActiveStars(storageId)
  return self:GetPoints_ActiveCosts(server_stars)
end

function AstrolabeProxy:GetStorageActivePointsCost_BySaveInfo(saveInfoData)
  local server_stars = saveInfoData:GetActiveStars()
  return self:GetPoints_ActiveCosts(server_stars)
end

function AstrolabeProxy:GetPoints_ActiveCosts(active_stars)
  local resultCost = {}
  for i = 1, #active_stars do
    local cost = Astrolabe_GetPointCost(active_stars[i])
    if cost then
      for k, v in pairs(cost) do
        local itemid, num = v[1], v[2]
        if resultCost[itemid] == nil then
          resultCost[itemid] = num
        else
          resultCost[itemid] = resultCost[itemid] + num
        end
      end
    end
  end
  return resultCost
end

function AstrolabeProxy:GetStorageActivePointsCost_ByPlate()
  local activePointsMap = self:GetActivePointsMap()
  local resultCost = {}
  for k, pointData in pairs(activePointsMap) do
    local cost = pointData:GetCost()
    for k, v in pairs(cost) do
      local itemid, num = v[1], v[2]
      if resultCost[itemid] == nil then
        resultCost[itemid] = num
      else
        resultCost[itemid] = resultCost[itemid] + num
      end
    end
  end
  return resultCost
end

function AstrolabeProxy:GetPoints_CostGoldMedalCount(saveInfoData)
  local server_stars = saveInfoData:GetActiveStars()
  local count = 0
  for i = 1, #server_stars do
    local cost = Astrolabe_GetPointCost(server_stars[i])
    if cost then
      for k, v in pairs(cost) do
        if v[1] == AstrolabeProxy.GoldMedalItemId then
          count = count + 1
        end
      end
    end
  end
  return count
end

function AstrolabeProxy:GetPoints_CostGoldMedalCount_ByPlate()
  local activePointsMap = self:GetActivePointsMap()
  local count = 0
  for k, pointData in pairs(activePointsMap) do
    local cost = pointData:GetCost()
    for k, v in pairs(cost) do
      local itemid, num = v[1], v[2]
      if itemid == AstrolabeProxy.GoldMedalItemId then
        count = count + 1
      end
    end
  end
  return count
end

local confirmConvertPopUpData = {
  convert = {}
}

function AstrolabeProxy.ConfirmAstrolMaterialOnChange(targetContribute, targetGoldMedal, confirmHandler, bypass)
  targetContribute = targetContribute or 0
  targetGoldMedal = targetGoldMedal or 0
  if bypass == nil then
    bypass = true
  end
  local myCost = AstrolabeProxy.Instance:GetStorageActivePointsCost_ByPlate()
  local bindedContribute, bindedGoldMedal = AstrolabeProxy.GetBindedContributeNum() + (myCost[AstrolabeProxy.ContributeItemId] or 0), AstrolabeProxy.GetBindedGoldMedalNum() + (myCost[AstrolabeProxy.GoldMedalItemId] or 0)
  local totalContribute, totalGoldMedal = AstrolabeProxy.GetContributeNum() + bindedContribute, AstrolabeProxy.GetGoldMedalNum() + bindedGoldMedal
  if targetContribute > totalContribute and targetGoldMedal > totalGoldMedal then
    MsgManager.ConfirmMsgByID(25411, confirmHandler, nil, nil, targetGoldMedal, targetContribute)
  elseif targetContribute > totalContribute then
    MsgManager.ConfirmMsgByID(41121, confirmHandler, nil, nil, targetContribute)
  elseif targetGoldMedal > totalGoldMedal then
    MsgManager.ConfirmMsgByID(41120, confirmHandler, nil, nil, targetGoldMedal)
  elseif targetContribute > bindedContribute or targetGoldMedal > bindedGoldMedal then
    confirmConvertPopUpData.convert[AstrolabeProxy.ContributeItemId] = math.max(targetContribute - bindedContribute, 0)
    confirmConvertPopUpData.convert[AstrolabeProxy.GoldMedalItemId] = math.max(targetGoldMedal - bindedGoldMedal, 0)
    confirmConvertPopUpData.confirmFunc = confirmHandler
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstrolabeAskForConvertPopUp,
      viewdata = confirmConvertPopUpData
    })
  elseif bypass then
    confirmHandler()
  end
end
