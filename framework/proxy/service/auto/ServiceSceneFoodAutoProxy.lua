ServiceSceneFoodAutoProxy = class("ServiceSceneFoodAutoProxy", ServiceProxy)
ServiceSceneFoodAutoProxy.Instance = nil
ServiceSceneFoodAutoProxy.NAME = "ServiceSceneFoodAutoProxy"

function ServiceSceneFoodAutoProxy:ctor(proxyName)
  if ServiceSceneFoodAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneFoodAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneFoodAutoProxy.Instance = self
  end
end

function ServiceSceneFoodAutoProxy:Init()
end

function ServiceSceneFoodAutoProxy:onRegister()
  self:Listen(29, 1, function(data)
    self:RecvCookStateNtf(data)
  end)
  self:Listen(29, 2, function(data)
    self:RecvPrepareCook(data)
  end)
  self:Listen(29, 3, function(data)
    self:RecvSelectCookType(data)
  end)
  self:Listen(29, 4, function(data)
    self:RecvStartCook(data)
  end)
  self:Listen(29, 5, function(data)
    self:RecvPutFood(data)
  end)
  self:Listen(29, 6, function(data)
    self:RecvEditFoodPower(data)
  end)
  self:Listen(29, 8, function(data)
    self:RecvQueryFoodNpcInfo(data)
  end)
  self:Listen(29, 9, function(data)
    self:RecvStartEat(data)
  end)
  self:Listen(29, 10, function(data)
    self:RecvStopEat(data)
  end)
  self:Listen(29, 7, function(data)
    self:RecvEatProgressNtf(data)
  end)
  self:Listen(29, 11, function(data)
    self:RecvFoodInfoNtf(data)
  end)
  self:Listen(29, 16, function(data)
    self:RecvUpdateFoodInfo(data)
  end)
  self:Listen(29, 12, function(data)
    self:RecvUnlockRecipeNtf(data)
  end)
  self:Listen(29, 13, function(data)
    self:RecvQueryFoodManualData(data)
  end)
  self:Listen(29, 14, function(data)
    self:RecvNewFoodDataNtf(data)
  end)
  self:Listen(29, 15, function(data)
    self:RecvClickFoodManualData(data)
  end)
end

function ServiceSceneFoodAutoProxy:CallCookStateNtf(state, charid)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.CookStateNtf()
    if state ~= nil and state.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.state = state.state
    end
    if state ~= nil and state.cooktype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.cooktype = state.cooktype
    end
    if state ~= nil and state.progress ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.progress = state.progress
    end
    if state ~= nil and state.success ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.success = state.success
    end
    if state ~= nil and state.foodid ~= nil then
      if msg.state == nil then
        msg.state = {}
      end
      if msg.state.foodid == nil then
        msg.state.foodid = {}
      end
      for i = 1, #state.foodid do
        table.insert(msg.state.foodid, state.foodid[i])
      end
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CookStateNtf.id
    local msgParam = {}
    if state ~= nil and state.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.state = state.state
    end
    if state ~= nil and state.cooktype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.cooktype = state.cooktype
    end
    if state ~= nil and state.progress ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.progress = state.progress
    end
    if state ~= nil and state.success ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.success = state.success
    end
    if state ~= nil and state.foodid ~= nil then
      if msgParam.state == nil then
        msgParam.state = {}
      end
      if msgParam.state.foodid == nil then
        msgParam.state.foodid = {}
      end
      for i = 1, #state.foodid do
        table.insert(msgParam.state.foodid, state.foodid[i])
      end
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallPrepareCook(start)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.PrepareCook()
    if start ~= nil then
      msg.start = start
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrepareCook.id
    local msgParam = {}
    if start ~= nil then
      msgParam.start = start
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallSelectCookType(cooktype)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.SelectCookType()
    if cooktype ~= nil then
      msg.cooktype = cooktype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectCookType.id
    local msgParam = {}
    if cooktype ~= nil then
      msgParam.cooktype = cooktype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallStartCook(cooktype, material, recipe, skipanimation, recipes, automatch)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.StartCook()
    if cooktype ~= nil then
      msg.cooktype = cooktype
    end
    if material ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.material == nil then
        msg.material = {}
      end
      for i = 1, #material do
        table.insert(msg.material, material[i])
      end
    end
    if recipe ~= nil then
      msg.recipe = recipe
    end
    if skipanimation ~= nil then
      msg.skipanimation = skipanimation
    end
    if recipes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.recipes == nil then
        msg.recipes = {}
      end
      for i = 1, #recipes do
        table.insert(msg.recipes, recipes[i])
      end
    end
    if automatch ~= nil then
      msg.automatch = automatch
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartCook.id
    local msgParam = {}
    if cooktype ~= nil then
      msgParam.cooktype = cooktype
    end
    if material ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.material == nil then
        msgParam.material = {}
      end
      for i = 1, #material do
        table.insert(msgParam.material, material[i])
      end
    end
    if recipe ~= nil then
      msgParam.recipe = recipe
    end
    if skipanimation ~= nil then
      msgParam.skipanimation = skipanimation
    end
    if recipes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.recipes == nil then
        msgParam.recipes = {}
      end
      for i = 1, #recipes do
        table.insert(msgParam.recipes, recipes[i])
      end
    end
    if automatch ~= nil then
      msgParam.automatch = automatch
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallPutFood(foodguid, power, foodnum, peteat)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.PutFood()
    if foodguid ~= nil then
      msg.foodguid = foodguid
    end
    if power ~= nil then
      msg.power = power
    end
    if foodnum ~= nil then
      msg.foodnum = foodnum
    end
    if peteat ~= nil then
      msg.peteat = peteat
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PutFood.id
    local msgParam = {}
    if foodguid ~= nil then
      msgParam.foodguid = foodguid
    end
    if power ~= nil then
      msgParam.power = power
    end
    if foodnum ~= nil then
      msgParam.foodnum = foodnum
    end
    if peteat ~= nil then
      msgParam.peteat = peteat
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallEditFoodPower(npcguid, power)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.EditFoodPower()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if power ~= nil then
      msg.power = power
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EditFoodPower.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if power ~= nil then
      msgParam.power = power
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallQueryFoodNpcInfo(npcguid, eating_people, itemid, ownerid, itemnum)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.QueryFoodNpcInfo()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if eating_people ~= nil then
      msg.eating_people = eating_people
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if ownerid ~= nil then
      msg.ownerid = ownerid
    end
    if itemnum ~= nil then
      msg.itemnum = itemnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFoodNpcInfo.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if eating_people ~= nil then
      msgParam.eating_people = eating_people
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if ownerid ~= nil then
      msgParam.ownerid = ownerid
    end
    if itemnum ~= nil then
      msgParam.itemnum = itemnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallStartEat(npcguid, pet, eatnum)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.StartEat()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if pet ~= nil then
      msg.pet = pet
    end
    if eatnum ~= nil then
      msg.eatnum = eatnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartEat.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if pet ~= nil then
      msgParam.pet = pet
    end
    if eatnum ~= nil then
      msgParam.eatnum = eatnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallStopEat(npcguid)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.StopEat()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopEat.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallEatProgressNtf(progress, npcguid)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.EatProgressNtf()
    if progress ~= nil then
      msg.progress = progress
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EatProgressNtf.id
    local msgParam = {}
    if progress ~= nil then
      msgParam.progress = progress
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallFoodInfoNtf(recipeids, last_cooked_foods, eat_foods)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.FoodInfoNtf()
    if recipeids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.recipeids == nil then
        msg.recipeids = {}
      end
      for i = 1, #recipeids do
        table.insert(msg.recipeids, recipeids[i])
      end
    end
    if last_cooked_foods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_cooked_foods == nil then
        msg.last_cooked_foods = {}
      end
      for i = 1, #last_cooked_foods do
        table.insert(msg.last_cooked_foods, last_cooked_foods[i])
      end
    end
    if eat_foods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.eat_foods == nil then
        msg.eat_foods = {}
      end
      for i = 1, #eat_foods do
        table.insert(msg.eat_foods, eat_foods[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FoodInfoNtf.id
    local msgParam = {}
    if recipeids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.recipeids == nil then
        msgParam.recipeids = {}
      end
      for i = 1, #recipeids do
        table.insert(msgParam.recipeids, recipeids[i])
      end
    end
    if last_cooked_foods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_cooked_foods == nil then
        msgParam.last_cooked_foods = {}
      end
      for i = 1, #last_cooked_foods do
        table.insert(msgParam.last_cooked_foods, last_cooked_foods[i])
      end
    end
    if eat_foods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.eat_foods == nil then
        msgParam.eat_foods = {}
      end
      for i = 1, #eat_foods do
        table.insert(msgParam.eat_foods, eat_foods[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallUpdateFoodInfo(last_cooked_foods, eat_foods, del_eat_foods)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.UpdateFoodInfo()
    if last_cooked_foods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_cooked_foods == nil then
        msg.last_cooked_foods = {}
      end
      for i = 1, #last_cooked_foods do
        table.insert(msg.last_cooked_foods, last_cooked_foods[i])
      end
    end
    if eat_foods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.eat_foods == nil then
        msg.eat_foods = {}
      end
      for i = 1, #eat_foods do
        table.insert(msg.eat_foods, eat_foods[i])
      end
    end
    if del_eat_foods ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_eat_foods == nil then
        msg.del_eat_foods = {}
      end
      for i = 1, #del_eat_foods do
        table.insert(msg.del_eat_foods, del_eat_foods[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateFoodInfo.id
    local msgParam = {}
    if last_cooked_foods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_cooked_foods == nil then
        msgParam.last_cooked_foods = {}
      end
      for i = 1, #last_cooked_foods do
        table.insert(msgParam.last_cooked_foods, last_cooked_foods[i])
      end
    end
    if eat_foods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.eat_foods == nil then
        msgParam.eat_foods = {}
      end
      for i = 1, #eat_foods do
        table.insert(msgParam.eat_foods, eat_foods[i])
      end
    end
    if del_eat_foods ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_eat_foods == nil then
        msgParam.del_eat_foods = {}
      end
      for i = 1, #del_eat_foods do
        table.insert(msgParam.del_eat_foods, del_eat_foods[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallUnlockRecipeNtf(recipe)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.UnlockRecipeNtf()
    if recipe ~= nil then
      msg.recipe = recipe
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockRecipeNtf.id
    local msgParam = {}
    if recipe ~= nil then
      msgParam.recipe = recipe
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallQueryFoodManualData(cookerexp, cookerlv, tasterexp, tasterlv, items)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.QueryFoodManualData()
    if cookerexp ~= nil then
      msg.cookerexp = cookerexp
    end
    if cookerlv ~= nil then
      msg.cookerlv = cookerlv
    end
    if tasterexp ~= nil then
      msg.tasterexp = tasterexp
    end
    if tasterlv ~= nil then
      msg.tasterlv = tasterlv
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFoodManualData.id
    local msgParam = {}
    if cookerexp ~= nil then
      msgParam.cookerexp = cookerexp
    end
    if cookerlv ~= nil then
      msgParam.cookerlv = cookerlv
    end
    if tasterexp ~= nil then
      msgParam.tasterexp = tasterexp
    end
    if tasterlv ~= nil then
      msgParam.tasterlv = tasterlv
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallNewFoodDataNtf(items)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.NewFoodDataNtf()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewFoodDataNtf.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:CallClickFoodManualData(type, itemid)
  if not NetConfig.PBC then
    local msg = SceneFood_pb.ClickFoodManualData()
    if type ~= nil then
      msg.type = type
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClickFoodManualData.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneFoodAutoProxy:RecvCookStateNtf(data)
  self:Notify(ServiceEvent.SceneFoodCookStateNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvPrepareCook(data)
  self:Notify(ServiceEvent.SceneFoodPrepareCook, data)
end

function ServiceSceneFoodAutoProxy:RecvSelectCookType(data)
  self:Notify(ServiceEvent.SceneFoodSelectCookType, data)
end

function ServiceSceneFoodAutoProxy:RecvStartCook(data)
  self:Notify(ServiceEvent.SceneFoodStartCook, data)
end

function ServiceSceneFoodAutoProxy:RecvPutFood(data)
  self:Notify(ServiceEvent.SceneFoodPutFood, data)
end

function ServiceSceneFoodAutoProxy:RecvEditFoodPower(data)
  self:Notify(ServiceEvent.SceneFoodEditFoodPower, data)
end

function ServiceSceneFoodAutoProxy:RecvQueryFoodNpcInfo(data)
  self:Notify(ServiceEvent.SceneFoodQueryFoodNpcInfo, data)
end

function ServiceSceneFoodAutoProxy:RecvStartEat(data)
  self:Notify(ServiceEvent.SceneFoodStartEat, data)
end

function ServiceSceneFoodAutoProxy:RecvStopEat(data)
  self:Notify(ServiceEvent.SceneFoodStopEat, data)
end

function ServiceSceneFoodAutoProxy:RecvEatProgressNtf(data)
  self:Notify(ServiceEvent.SceneFoodEatProgressNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvFoodInfoNtf(data)
  self:Notify(ServiceEvent.SceneFoodFoodInfoNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvUpdateFoodInfo(data)
  self:Notify(ServiceEvent.SceneFoodUpdateFoodInfo, data)
end

function ServiceSceneFoodAutoProxy:RecvUnlockRecipeNtf(data)
  self:Notify(ServiceEvent.SceneFoodUnlockRecipeNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvQueryFoodManualData(data)
  self:Notify(ServiceEvent.SceneFoodQueryFoodManualData, data)
end

function ServiceSceneFoodAutoProxy:RecvNewFoodDataNtf(data)
  self:Notify(ServiceEvent.SceneFoodNewFoodDataNtf, data)
end

function ServiceSceneFoodAutoProxy:RecvClickFoodManualData(data)
  self:Notify(ServiceEvent.SceneFoodClickFoodManualData, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneFoodCookStateNtf = "ServiceEvent_SceneFoodCookStateNtf"
ServiceEvent.SceneFoodPrepareCook = "ServiceEvent_SceneFoodPrepareCook"
ServiceEvent.SceneFoodSelectCookType = "ServiceEvent_SceneFoodSelectCookType"
ServiceEvent.SceneFoodStartCook = "ServiceEvent_SceneFoodStartCook"
ServiceEvent.SceneFoodPutFood = "ServiceEvent_SceneFoodPutFood"
ServiceEvent.SceneFoodEditFoodPower = "ServiceEvent_SceneFoodEditFoodPower"
ServiceEvent.SceneFoodQueryFoodNpcInfo = "ServiceEvent_SceneFoodQueryFoodNpcInfo"
ServiceEvent.SceneFoodStartEat = "ServiceEvent_SceneFoodStartEat"
ServiceEvent.SceneFoodStopEat = "ServiceEvent_SceneFoodStopEat"
ServiceEvent.SceneFoodEatProgressNtf = "ServiceEvent_SceneFoodEatProgressNtf"
ServiceEvent.SceneFoodFoodInfoNtf = "ServiceEvent_SceneFoodFoodInfoNtf"
ServiceEvent.SceneFoodUpdateFoodInfo = "ServiceEvent_SceneFoodUpdateFoodInfo"
ServiceEvent.SceneFoodUnlockRecipeNtf = "ServiceEvent_SceneFoodUnlockRecipeNtf"
ServiceEvent.SceneFoodQueryFoodManualData = "ServiceEvent_SceneFoodQueryFoodManualData"
ServiceEvent.SceneFoodNewFoodDataNtf = "ServiceEvent_SceneFoodNewFoodDataNtf"
ServiceEvent.SceneFoodClickFoodManualData = "ServiceEvent_SceneFoodClickFoodManualData"
