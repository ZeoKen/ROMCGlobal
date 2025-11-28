MountLotteryData = class("MountLotteryData")

function MountLotteryData:ctor(data)
  self:SetData(data)
end

function MountLotteryData:SetData(data)
  if data then
    self.round = data.round
    self.itemid = data.itemid
    self.count = data.count
    self.weight = data.weight
    self.got = data.sold
    self.id = data.id
    self.card_index = self.id % 13
  end
end

function MountLotteryData:GetItemData()
  if self.itemData == nil then
    self.itemData = ItemData.new("LotteryItem", self.itemid)
    self.itemData.num = self.count
  end
  return self.itemData
end

MountLotteryProxy = class("MountLotteryProxy", pm.Proxy)
local endV3 = LuaVector3()
local cardeffectPath = "Common/flowinglight_tail2"
local cateffectPath = "Skill/CardSelected"
local disapperEffectPath = "Skill/Card_disappear"
local bornEffectPath = "Skill/Card_born"
local appearEffectPath = "Skill/LuckyCat_card_Appear"
local RideConfig = GameConfig.RideLottery
local ballRootsName = {
  [1] = "LuckyCat1",
  [2] = "LuckyCat2",
  [3] = "w_guangyun_21_add2 (2)"
}

function MountLotteryProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "MountLotteryProxy"
  if not MountLotteryProxy.Instance then
    MountLotteryProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function MountLotteryProxy:Init()
  self.lotteryItemRMap = {}
  self.weightMap = {}
  self.currentRound = 1
  self.cardMap = {}
  self.totalGot = 0
  self.chooseids = {}
  self.ballRoots = {}
  self.isFinished = false
  self.showGift = false
  self.isNewRound = false
  self.isInit = false
end

function MountLotteryProxy:ResetChooseids()
  for i = 1, 13 do
    self.chooseids[i] = false
  end
end

function MountLotteryProxy:RecvQueryRideLotteryInfo(serverdata)
  local datas = serverdata.infos
  if serverdata.update then
  else
    if serverdata.finished then
      self.isFinished = serverdata.finished
    end
    if not self.isInit and self:InitConfig(serverdata) then
      self.isInit = true
    end
    self:InitLotteryItems(datas)
    self:ResetChooseids()
  end
  local choose = serverdata.chooseids
  if choose then
    if self.chooseids then
      TableUtility.TableClear(self.chooseids)
    end
    for i = 1, #choose do
      self.chooseids[choose[i]] = true
    end
  end
  self.skipanimation = serverdata.skipanimation
  self.lastClick = nil
  GameFacade.Instance:sendNotification(ServiceEvent.ItemQueryRideLotteryInfo, serverdata)
end

function MountLotteryProxy:InitConfig(serverdata)
  if not serverdata then
    return
  end
  local linegroup = self:GetCurrentLineGroup()
  if not linegroup then
    return
  end
  local batch = serverdata.batch
  local configkey = linegroup * 10 + batch
  if not configkey then
    return
  end
  local configIndex = GameConfig.RideLotteryConfig[configkey]
  if not configIndex then
    return
  end
  self.RideConfig = RideConfig[configIndex]
  self.batchCount = self.RideConfig.BatchCount
  self.batchStep = {
    [0] = 0
  }
  for i = 1, #self.batchCount do
    self.batchStep[i] = self.batchStep[i - 1] + self.batchCount[i]
  end
  self.Maximum = self.batchStep[#self.batchCount]
end

function MountLotteryProxy:GetCurrentLineGroup()
  local serverData = FunctionLogin.Me():getCurServerData()
  if not serverData then
    return false
  end
  return serverData.linegroup or 1
end

function MountLotteryProxy:InitLotteryItems(datas)
  self:InitLotteryItems(datas, serverdata.update)
end

function MountLotteryProxy:InitLotteryItems(datas, isupdate)
  if not datas then
    return
  end
  if self.lotteryItemRMap then
    TableUtility.TableClear(self.lotteryItemRMap)
  end
  if self.weightMap then
    TableUtility.TableClear(self.weightMap)
  end
  self.totalGot = 0
  self.currentRound = 1
  local n = #datas
  self.gotMount = false
  for i = 1, n do
    local single = datas[i]
    if not isupdate then
      if not self.lotteryItemRMap[single.round] then
        self.lotteryItemRMap[single.round] = {}
      end
      if not self.weightMap[single.round] then
        self.weightMap[single.round] = 0
      end
      local data = MountLotteryData.new(single)
      if data.got then
        self.totalGot = self.totalGot + 1
        if single.round > self.currentRound then
          self.currentRound = single.round
        end
        if single.itemid == self.RideConfig.Cumulative[4] then
          self.gotMount = true
        end
      else
        self.weightMap[single.round] = self.weightMap[single.round] + single.weight
      end
      table.insert(self.lotteryItemRMap[single.round], data)
    end
  end
  self.isNewRound = false
  for i = #self.batchStep, 1, -1 do
    if self.batchStep[i] == self.totalGot and self.totalGot < self.Maximum then
      self.isNewRound = true
      break
    end
  end
  if self.isNewRound and self.totalGot ~= 0 and self.totalGot < self.Maximum then
    self.currentRound = self.currentRound + 1
  end
  if not self.RideConfig.LastBuySkin and self.totalGot == self.Maximum then
    self.isFinished = true
  end
  if self.totalGot == self.Maximum and not self.isFinished then
    self.showGift = true
  else
    self.showGift = false
  end
  self:RefreshCards()
  if self.batchStep[self.currentRound] - self.totalGot >= 11 then
    self.needLotteryTenBtn = true
  else
    self.needLotteryTenBtn = false
  end
end

function MountLotteryProxy:GetCurrentRoundLeft()
  if self.currentRound then
    return self.batchStep[self.currentRound] - self.totalGot
  else
    return 0
  end
end

function MountLotteryProxy:RefreshCards()
  if not self.cardpointMap or not self.chooseids then
    return
  end
  for k, v in pairs(self.cardpointMap) do
    if self.isFinished then
      self.cardpointMap[k]:SetActive(false)
    elseif self.chooseids[k] then
      self.cardpointMap[k]:SetActive(not v)
    elseif self:GetCurrentRoundLeft() >= 1 and not self.isNewRound then
      self:_playAction(self.cardObjMap[k], "wait")
    end
  end
end

function MountLotteryProxy:GetLotteryItemsByIndex(index)
  if self.lotteryItemRMap then
    return self.lotteryItemRMap[index]
  end
end

function MountLotteryProxy:GetWeightByIndex(index)
  if self.weightMap then
    return self.weightMap[index]
  end
end

function MountLotteryProxy:GetCurrentRound()
  return self.currentRound
end

function MountLotteryProxy:GetCurrentCards()
  TableUtility.TableClear(self.cardMap)
  if self.currentRound and self.lotteryItemRMap then
    local items = self.lotteryItemRMap[self.currentRound]
    if items then
      for k, v in pairs(items) do
        if not v.got then
          self.cardMap[v.card_index] = v
        end
      end
    end
  end
end

function MountLotteryProxy:CheckIsFisrtTime(round)
  if self.lotteryItemRMap then
    for k, v in pairs(self.lotteryItemRMap[round]) do
      if v.got then
        return false
      end
    end
    return true
  end
end

local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()

function MountLotteryProxy:LoadNPC(npcid)
  if self.npcModel then
    self.npcModel:Redress(parts, true)
  else
    self:CreateFakeCat()
    self:CreateRealCat(npcid)
  end
  return self.npcModel
end

function MountLotteryProxy:CreateFakeCat()
  local parts = Asset_Role.CreatePartArray()
  self.npcModel = Asset_Role.Create(parts)
  LuaVector3.Better_Set(tempV3, 4.4, 155, 0)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.npcModel:SetRotation(tempRot)
  self.npcModel:SetScale(1)
  self.npcModel:SetPosition({
    300,
    -100,
    40
  })
  Asset_Role.DestroyPartArray(parts)
end

function MountLotteryProxy:CreateRealCat(npcid)
  local parts = Asset_RoleUtility.CreateNpcRoleParts(npcid)
  self.npcModel:Redress(parts, true)
  self.isCreate = true
  Asset_Role.DestroyPartArray(parts)
end

function MountLotteryProxy:StartSetting()
  if not self.showGift and not self:CheckFinishAll() then
    self:_playAction(self.npcModel, "wait", true)
    self:PreprocessRoot()
    self:LoadCards()
    self:SetGift(self.showGift)
  elseif self.showGift and not self:CheckFinishAll() then
    self:PreprocessGift()
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:FinishLottery()
    end, self)
  elseif self:CheckFinishAll() then
    GameFacade.Instance:sendNotification(MountLotteryEvent.EndAll)
  end
end

function MountLotteryProxy:PreprocessGift()
  if not self.RideConfig.LastBuySkin then
    return
  end
  local bodyroot = Game.GameObjectUtil:DeepFind(self.npcModel.completeTransform.gameObject, "1689(Clone)")
  for k, v in pairs(ballRootsName) do
    if bodyroot then
      table.insert(self.ballRoots, Game.GameObjectUtil:DeepFind(bodyroot, v))
    end
  end
  self.giftRoot = GameObject(tostring(self.RideConfig.LastBuySkin))
  self.giftRoot.transform.parent = self.npcModel:GetCPOrRoot(RoleDefines_CP.RightHand)
  self.giftRoot.transform.localPosition = LuaGeometry.Const_V3_zero
  self.giftRoot.transform.localScale = LuaGeometry.Const_V3_zero
  self.giftRoot.transform.localRotation = LuaGeometry.Const_Qua_identity
  local tempGift = self.giftRoot:AddComponent(LuaGameObjectClickable)
  tempGift.type = 16
  tempGift.ID = self.RideConfig.LastBuySkin
  local giftcollider = self.giftRoot:AddComponent(BoxCollider)
  LuaVector3.Better_Set(tempV3, 0.5, 0.5, 0.5)
  giftcollider.size = tempV3
  giftcollider.isTrigger = true
  giftcollider.center = LuaGeometry.Const_V3_zero
  NGUITools.SetLayer(self.giftRoot, 11)
end

local rootName = "cardpoint_"

function MountLotteryProxy:PreprocessRoot()
  if self.npcModel then
    if not self.cardpointMap then
      self.cardpointMap = {}
    end
    local temp = {}
    for i = 1, 13 do
      local trans = Game.GameObjectUtil:DeepFind(self.npcModel.completeTransform.gameObject, rootName .. i)
      temp[i] = trans.transform
    end
    local newroot = GameObject("CardRoot")
    local bodyroot = Game.GameObjectUtil:DeepFind(self.npcModel.completeTransform.gameObject, "1689(Clone)")
    newroot.transform.parent = bodyroot.transform
    newroot.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    LuaVector3.Better_Set(tempV3, 0, 0, 0)
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
    newroot.transform.localRotation = tempRot
    self.newroot = newroot
    if temp then
      for k, v in pairs(temp) do
        local newpoint = GameObject(tostring(k))
        newpoint.transform.parent = newroot.transform
        newpoint.transform.localPosition = v.localPosition
        newpoint.transform.localRotation = LuaGeometry.GetTempVector3(0, 0, 0)
        newpoint:AddComponent(LookAtCamera)
        local tempCp = newpoint:AddComponent(LuaGameObjectClickable)
        tempCp.type = 16
        tempCp.ID = k
        self.cardpointMap[k] = newpoint
        local collider = newpoint:AddComponent(BoxCollider)
        LuaVector3.Better_Set(tempV3, 0.5, 0.5, 0.1)
        collider.size = tempV3
        collider.isTrigger = true
        LuaVector3.Better_Set(tempV3, 5.329071E-15, -1.490116E-8, 2.427707E-15)
        collider.center = tempV3
        NGUITools.SetLayer(newpoint, 11)
      end
    end
    for k, v in pairs(ballRootsName) do
      if bodyroot then
        table.insert(self.ballRoots, Game.GameObjectUtil:DeepFind(bodyroot, v))
      end
    end
    if self.RideConfig.LastBuySkin then
      self.giftRoot = GameObject(tostring(self.RideConfig.LastBuySkin))
      self.giftRoot.transform.parent = self.npcModel:GetCPOrRoot(RoleDefines_CP.RightHand)
      self.giftRoot.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
      self.giftRoot.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      self.giftRoot.transform.localRotation = LuaGeometry.GetTempVector3(0, 0, 0)
      local tempGift = self.giftRoot:AddComponent(LuaGameObjectClickable)
      tempGift.type = 16
      tempGift.ID = self.RideConfig.LastBuySkin
      local giftcollider = self.giftRoot:AddComponent(BoxCollider)
      LuaVector3.Better_Set(tempV3, 0.5, 0.5, 0.5)
      giftcollider.size = tempV3
      giftcollider.isTrigger = true
      giftcollider.center = LuaGeometry.GetTempVector3(0, 0, 0)
      NGUITools.SetLayer(self.giftRoot, 11)
    end
  end
end

function MountLotteryProxy:SetGift(isShow)
  if not self.RideConfig.LastBuySkin then
    return
  end
  for k, v in pairs(self.ballRoots) do
    v:SetActive(not isShow)
  end
  if self.showGift and self.cardpointMap then
    for k, v in pairs(self.cardpointMap) do
      v:SetActive(not isShow)
    end
  elseif self.cardpointMap then
    for k, v in pairs(self.cardpointMap) do
      if self.chooseids[k] then
        self.cardpointMap[k]:SetActive(not v)
      end
    end
  end
  self.giftRoot:SetActive(isShow)
  self:LoadGift()
end

function MountLotteryProxy:LoadGift()
  if not self.giftModel then
    local itemId = self.RideConfig.MountModelID
    local partsfake = Asset_Role.CreatePartArray()
    local parts = Asset_RoleUtility.CreateNpcRoleParts(itemId)
    self.giftModel = Asset_Role.Create(partsfake)
    self.giftModel:SetParent(self.giftRoot.transform, true)
    self.giftModel:SetEulerAngles(self.RideConfig.MountModelRotation)
    self.giftModel:SetScale(self.RideConfig.MountModelScale)
    self.giftModel:SetPosition(self.RideConfig.MountModelPos)
    self.giftModel:SetShadowEnable(false)
    self.giftModel:Redress(parts, true)
    Asset_Role.DestroyPartArray(parts)
    Asset_Role.DestroyPartArray(partsfake)
  end
  TimeTickManager.Me():CreateOnceDelayTick(400, function(owner, deltaTime)
    if self.giftModel then
      self:_playAction(self.giftModel, "functional_action")
    end
  end, self)
end

function MountLotteryProxy:LoadCards()
  local cardset = self.RideConfig.CardID
  if self.cardpointMap then
    if not self.cardObjMap then
      self.cardObjMap = {}
    end
    local partsfake = Asset_Role.CreatePartArray()
    for i = 1, 13 do
      local bodyid = cardset[self.currentRound]
      local parts = Asset_RoleUtility.CreateNpcRoleParts(bodyid)
      if self.cardObjMap[i] then
        self:_playAction(self.cardObjMap[i], "wait")
      else
        self.cardObjMap[i] = Asset_Role.Create(partsfake)
        self.cardObjMap[i].completeTransform.parent = self.cardpointMap[i].transform
        self.cardObjMap[i].completeTransform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
        self.cardObjMap[i].completeTransform.localRotation = LuaGeometry.GetTempVector3(0, 0, 0)
        self.cardObjMap[i].completeTransform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
        self.cardObjMap[i]:Redress(parts, true)
      end
      Asset_Role.DestroyPartArray(parts)
    end
    Asset_Role.DestroyPartArray(partsfake)
    if self:CheckFinishAll() then
      self:HideCards()
    else
      for k, v in pairs(self.cardpointMap) do
        if self.chooseids[k] then
          self.cardpointMap[k]:SetActive(not v)
        else
          self:_playAction(self.cardObjMap[k], "wait")
          self.cardpointMap[k]:SetActive(true)
        end
      end
    end
  end
end

function MountLotteryProxy:RemoveNPC()
  if self.npcModel then
    self.npcModel:Destroy()
    self.npcModel = nil
  end
end

function MountLotteryProxy:RemoveCards()
  if self.cardObjMap then
    for k, v in pairs(self.cardObjMap) do
      self.cardObjMap[k]:Destroy()
      self.cardObjMap[k] = nil
    end
  end
end

function MountLotteryProxy:GetNpcModel()
  return self.npcModel
end

function MountLotteryProxy:OnClickCard(id)
  if id ~= self.lastClick then
    if self.lastClick then
      local animParams = Asset_Role.GetPlayActionParams("born", nil, 1)
      animParams[7] = function()
        animParams = Asset_Role.GetPlayActionParams("wait", nil, 1)
        self:_playAction(self.cardObjMap[self.lastClick], animParams)
      end
      self:_playAction(self.cardObjMap[self.lastClick], animParams)
    end
    self:_playAction(self.cardObjMap[id], "disappear")
    local endEPTransform = self.cardObjMap[id]:GetEPOrRoot(RoleDefines_EP.Middle)
    LuaVector3.Better_Set(endV3, LuaGameObject.GetPosition(endEPTransform))
    Asset_Effect.PlayOneShotAt(disapperEffectPath, endV3)
    local NPCEPTransform = self.npcModel:GetEPOrRoot(RoleDefines_EP.Middle)
    LuaVector3.Better_Set(endV3, LuaGameObject.GetPosition(NPCEPTransform))
    Asset_Effect.PlayOneShotAt(cateffectPath, endV3)
    LuaVector3.Better_Set(tempV3, LuaGameObject.GetLocalPosition(self.cardpointMap[id].transform))
    self.disppearEffect = Asset_Effect.PlayOneShotAt(cardeffectPath, endV3)
    self.startTrans = endEPTransform
    self.targetTrans = NPCEPTransform
    self.disppearEffect:ResetParent(endEPTransform)
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.lastClick = id
    end, self)
    if self.firstClick then
      self:_playAction(self.npcModel, "attack_wait")
      self.firstClick = false
    end
  end
end

function MountLotteryProxy:ResetLastClick()
  self.lastClick = nil
  self.firstClick = true
end

function MountLotteryProxy:_playAction(role, actionName)
  local actionParam = Asset_Role.GetPlayActionParams(actionName, nil, 1)
  actionParam[6] = true
  if role then
    role:PlayActionRaw(actionParam)
  end
end

function MountLotteryProxy:GetSelectedCard()
  if self.lastClick then
    return self.cardObjMap[self.lastClick]
  end
end

function MountLotteryProxy:GetChooseIDs()
  return self.chooseids
end

function MountLotteryProxy:ResetCards()
  self:ResetChooseids()
  self:LoadCards()
  self:ResetLastClick()
end

function MountLotteryProxy:SwitchRound()
  local interval = self.RideConfig.PopupInterval or 0.1
  local newRounddelay = self.RideConfig.NewRoundDelay or 0.1
  if self.npcModel then
    self:_playAction(self.npcModel, "functional_action")
    TimeTickManager.Me():CreateOnceDelayTick(self.RideConfig.SwitchActionDalay * 1000, function(owner, deltaTime)
      self:_playAction(self.npcModel, "wait")
    end, self)
  end
  if self.cardObjMap then
    for k, v in pairs(self.cardpointMap) do
      v:SetActive(false)
    end
    local bodyid = self.RideConfig.CardID[self.currentRound]
    for k, v in pairs(self.cardObjMap) do
      local parts = Asset_RoleUtility.CreateNpcRoleParts(bodyid)
      v:Redress(parts, true)
    end
    for i = 1, 13 do
      local delayTime = (newRounddelay + i * interval) * 1000
      TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(owner, deltaTime)
        if not Slua.IsNull(self.cardpointMap[i]) then
          self.cardpointMap[i]:SetActive(true)
          local animParams = Asset_Role.GetPlayActionParams("born", nil, 1)
          animParams[7] = function()
            animParams = Asset_Role.GetPlayActionParams("wait", nil, 1)
            self:_playAction(self.cardObjMap[i], animParams)
          end
          self:_playAction(self.cardObjMap[i], animParams)
          local endEPTransform = self.cardObjMap[i]:GetEPOrRoot(RoleDefines_EP.Middle)
          LuaVector3.Better_Set(endV3, LuaGameObject.GetPosition(endEPTransform))
          Asset_Effect.PlayOneShotAt(bornEffectPath, endV3)
        end
      end, self)
    end
  end
end

function MountLotteryProxy:FinishLottery()
  if self.npcModel then
    self:_playAction(self.npcModel, "functional_action6")
  end
  if self.showGift and self.RideConfig.LastBuySkin then
    self:SetGift(true)
  end
end

function MountLotteryProxy:PlayLotteryAnimation()
  if self.npcModel then
    self:_playAction(self.npcModel, "functional_action3")
    TimeTickManager.Me():CreateOnceDelayTick(self.RideConfig.LotterActionDelay * 1000, function(owner, deltaTime)
      self:_playAction(self.npcModel, "wait")
    end, self)
  end
end

function MountLotteryProxy:SetMountActivity(data)
  self.isOpen = data.open
  self.starttime = data.starttime
  self.endtime = data.endtime
end

function MountLotteryProxy:CheckMountActivity()
  local cur = ServerTime.CurServerTime() / 1000
  return self.isOpen and cur <= self.endtime and cur >= self.starttime
end

function MountLotteryProxy:Clear()
  if self.giftModel then
    self.giftModel:Destroy()
    self.giftModel = nil
  end
  if self.giftRoot then
    LuaGameObject.DestroyObject(self.giftRoot)
  end
  if self.newroot then
    LuaGameObject.DestroyObject(self.newroot)
  end
  if self.ballRoots then
    TableUtility.TableClear(self.ballRoots)
  end
  if self.cardObjMap then
    TableUtility.TableClear(self.cardObjMap)
  end
  if self.cardpointMap then
    TableUtility.TableClear(self.cardpointMap)
  end
  self.isCreate = false
  self.isInit = false
end

function MountLotteryProxy:HideCards()
  if self.cardpointMap then
    for k, v in pairs(self.cardpointMap) do
      self.cardpointMap[k]:SetActive(false)
    end
  end
end

function MountLotteryProxy:ResetToNormal()
  if not Slua.IsNull(self.giftRoot) then
    self.giftRoot:SetActive(false)
  end
  if self.ballRoots then
    for k, v in pairs(self.ballRoots) do
      v:SetActive(true)
    end
  end
  if self.npcModel then
    self:_playAction(self.npcModel, "wait")
  end
end

function MountLotteryProxy:PlayBuyGiftAnim()
  self:_playAction(self.npcModel, "functional_action4")
end

function MountLotteryProxy:PlayDone()
  if self.npcModel then
    self:_playAction(self.npcModel, "functional_action5")
  end
end

function MountLotteryProxy:Reset()
  self:RemoveNPC()
  self:RemoveCards()
  self:Clear()
end

function MountLotteryProxy:CheckShowSkin()
  return not self.isFinished and self.totalGot < self.Maximum and self.gotMount and self.RideConfig.LastBuySkin
end

function MountLotteryProxy:CheckBackTocards()
  return self.isFinished and self.totalGot < self.Maximum
end

function MountLotteryProxy:CheckFinishAll()
  return self.isFinished and self.totalGot >= self.Maximum
end

function MountLotteryProxy:AutoRefillCard(cardindex)
  local gotCount = 0
  if self.currentRound and self.lotteryItemRMap then
    local items = self.lotteryItemRMap[self.currentRound]
    if items then
      for k, v in pairs(items) do
        if v.got then
          gotCount = gotCount + 1
        end
      end
    end
  end
  if gotCount < 14 and 0 <= gotCount and self.cardObjMap[cardindex] then
    local animParams = Asset_Role.GetPlayActionParams("born", nil, 1)
    animParams[7] = function()
      animParams = Asset_Role.GetPlayActionParams("wait", nil, 1)
      self:_playAction(self.cardObjMap[cardindex], animParams)
    end
    self:_playAction(self.cardObjMap[cardindex], animParams)
    LuaVector3.Better_Set(endV3, self.cardObjMap[cardindex]:GetEPOrRootPosition(RoleDefines_EP.Middle))
    Asset_Effect.PlayOneShotAt(appearEffectPath, endV3)
  end
end
