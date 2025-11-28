BFBuildingProxy = class("BFBuildingProxy", pm.Proxy)
BFBuildingProxy.Instance = nil
BFBuildingProxy.NAME = "BFBuildingProxy"
BFBuildingProxy.Type = {
  Toy = 1,
  Block = 2,
  Summon = 3,
  Weather = 4,
  Transform = 5,
  Revive = 7
}
local fdata = {
  pos = {},
  items = {},
  elements = {},
  weather = {},
  block = {},
  timer = {
    datas = {
      pos = {}
    }
  }
}

function BFBuildingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BFBuildingProxy.NAME
  if BFBuildingProxy.Instance == nil then
    BFBuildingProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:ResetBuildData()
end

function BFBuildingProxy:ResetBuildData()
  self.buildData = self.buildData or {}
  TableUtility.TableClear(self.buildData)
end

function BFBuildingProxy:RecvBuildDataQueryUserCmd(data)
  self:SetBuildData(data.data)
end

function BFBuildingProxy:RecvBuildContributeUserCmd(data)
  if data.success then
    MsgManager.FloatMsg("", ZhString.BFBuilding_donate_success)
    self:SetBuildData(data.data)
  else
    MsgManager.FloatMsg("", ZhString.BFBuilding_donate_fail)
    ServiceNUserProxy.Instance:CallBuildDataQueryUserCmd(fdata)
  end
end

function BFBuildingProxy:RecvBuildOperateUserCmd(data)
  local btype = BFBuildingProxy.GetBuildingType(data.data and data.data.npcid)
  if data.success then
    if btype == BFBuildingProxy.Type.Toy then
      MsgManager.ShowMsgByID(40908, Table_Item[data.id] and Table_Item[data.id].NameZh or "")
    else
      MsgManager.FloatMsg("", ZhString.BFBuilding_oper_success)
    end
  else
    MsgManager.FloatMsg("", ZhString.BFBuilding_oper_fail)
    ServiceNUserProxy.Instance:CallBuildDataQueryUserCmd(fdata)
  end
  if btype == BFBuildingProxy.Type.Toy or btype == BFBuildingProxy.Type.Transform then
    self:PlayBuildingAnimOneShot(data.data.npcid, EBUILDSTATUS.EBUILDSTATUS_OPER)
  end
  self:SetBuildData(data.data)
end

function BFBuildingProxy:SetBuildData(data)
  if not (data and data.id) or data.id == 0 then
    return
  end
  self.buildData[data.id] = self.buildData[data.id] or {}
  local idata = self.buildData[data.id]
  idata.id = data.id
  idata.bid = data.npcid
  idata.mapid = data.mapid
  idata.time = data.time
  idata.status = data.status
  if not idata.sdata then
    idata.sdata = Table_BuildingCooperate and Table_BuildingCooperate[idata.bid]
  end
  if not idata.items then
    idata.items = {}
  end
  TableUtility.TableClear(idata.items)
  idata.curCount = 0
  for i = 1, #data.items do
    local it = data.items[i]
    idata.items[it.id] = it.count
    idata.curCount = idata.curCount + it.count
  end
  idata.elements = idata.elements or {}
  if data.weather then
    idata.wid = data.weather.id
    idata.wtime = data.weather.time + GameConfig.BuildingCooperate.WeatherDuration
  else
    idata.wid = nil
    idata.wtime = nil
  end
  if idata.sdata.BuildingType == BFBuildingProxy.Type.Revive and data.timer then
    idata.elementsDirty = true
    idata.r_times = data.timer.times
    if not idata.r_elements then
      idata.r_elements = {}
    else
      TableUtility.TableClear(idata.r_elements)
    end
    for i = 1, #data.timer.datas do
      local r_data = data.timer.datas[i]
      local r_ele = {}
      r_ele.npcid = r_data.npcid
      r_ele.status = r_data.status
      r_ele.lefttime = r_data.lefttime
      if r_data.pos then
        r_ele.pos = {
          x = r_data.pos.x,
          y = r_data.pos.y,
          z = r_data.pos.z
        }
      end
      idata.r_elements[i] = r_ele
    end
  else
    idata.elementsDirty = false
    if #idata.elements ~= #data.elements then
      idata.elementsDirty = true
      TableUtility.TableClear(idata.elements)
    end
    for i = 1, #data.elements do
      if idata.elements[i] ~= data.elements[i] then
        idata.elements[i] = data.elements[i]
        idata.elementsDirty = true
      end
    end
  end
  if not idata.nitems then
    idata.totalCount = 0
    idata.nitems = {}
    for i = 1, #idata.sdata.ItemNeed do
      local ni = idata.sdata.ItemNeed[i]
      idata.nitems[ni.id] = ni.num
      idata.totalCount = idata.totalCount + ni.num
    end
  end
  idata.time = idata.time == 0 and 0 or idata.sdata.RunTime + idata.time
  idata.progress = idata.totalCount == 0 and 1 or idata.curCount / idata.totalCount
end

function BFBuildingProxy:GetBuildData(id)
  return self.buildData and self.buildData[id]
end

function BFBuildingProxy:SetBuildDataElementsDirty(id, isDirty)
  if self.buildData and self.buildData[id] then
    self.buildData[id].elementsDirty = isDirty
  end
end

function BFBuildingProxy:GetDonateData(id)
  local idata = self.buildData[id]
  if not idata then
    return
  end
  local donateList, ni, cnum = {}
  for i = 1, #idata.sdata.ItemNeed do
    ni = idata.sdata.ItemNeed[i]
    TableUtility.ArrayPushBack(donateList, {
      build_id = id,
      id = ni.id,
      num = ni.num
    })
  end
  return donateList
end

function BFBuildingProxy.IsBFBuilding(npcid)
  if not Table_BuildingCooperate or not Table_BuildingCooperate[npcid] then
    return false
  end
  local npcfunc, nf = Table_Npc and Table_Npc[npcid] and Table_Npc[npcid].NpcFunction
  if npcfunc then
    for i = 1, #npcfunc do
      nf = npcfunc[i].type
      if Table_NpcFunction and Table_NpcFunction[nf] and Table_NpcFunction[nf].Type == "BFBuilding" then
        return true
      end
    end
  end
  return false
end

function BFBuildingProxy.GetBuildingType(npcid)
  return Table_BuildingCooperate and Table_BuildingCooperate[npcid] and Table_BuildingCooperate[npcid].BuildingType
end

function BFBuildingProxy.GetBuildingUnlockMenu(npcid)
  return Table_BuildingCooperate and Table_BuildingCooperate[npcid] and Table_BuildingCooperate[npcid].UnlockMenu
end

function BFBuildingProxy:SetCurBuildingUICtrl(uictrl)
  self.curBuildingUICtrl = uictrl
  self.curBuilding = uictrl and uictrl.id or nil
end

function BFBuildingProxy:GetCurBuildingUICtrl()
  return self.curBuildingUICtrl
end

function BFBuildingProxy:GetCurBuildingData()
  return self:GetBuildData(self.curBuilding)
end

function BFBuildingProxy:CheckFunctionInUse(bid, element_id)
  local buildData = self:GetBuildData(bid)
  local buildType = buildData.sdata.BuildingType
  if buildType == BFBuildingProxy.Type.Toy then
    local checkSkill = GameConfig.BuildingCooperate.TechToSkill[element_id]
    if checkSkill and checkSkill.skillid then
      return SkillProxy.Instance:HasLearnedSkill(checkSkill.skillid)
    end
  elseif buildType == BFBuildingProxy.Type.Transform then
    local checkBuff = GameConfig.BuildingCooperate.TransformMachine[element_id]
    if checkBuff then
      return Game.Myself:GetBuffLayer(checkBuff) > 0
    end
  end
end

function BFBuildingProxy:PlayBuildingAnimOneShot(nnpcid, status)
  local nnpc = NSceneNpcProxy.Instance:FindNpcs(nnpcid)
  nnpc = nnpc and nnpc[1]
  if nnpc then
    self:SwitchBuildingAnimByStatus(nnpc, status, true, false, EBUILDSTATUS.EBUILDSTATUS_RUN)
  end
end

local pendingCheckTickId, tickManager = 1

function BFBuildingProxy:SwitchBuildingAnimByStatus(nnpc, status, formerStatus, waitModel, cbStatus)
  local npcid = nnpc and nnpc.data and nnpc.data.staticData and nnpc.data.staticData.id
  if not status then
    return
  end
  if not BFBuildingProxy.IsBFBuilding(npcid) then
    return
  end
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  local actionName = Table_BuildingCooperate[npcid].IdleAction
  local normalizedTime = formerStatus and 0 or 1
  if status == EBUILDSTATUS.EBUILDSTATUS_INIT then
    if formerStatus == EBUILDSTATUS.EBUILDSTATUS_RUN or formerStatus == EBUILDSTATUS.EBUILDSTATUS_OPER then
      actionName = Table_BuildingCooperate[npcid].DeadAction
    else
      actionName = Table_BuildingCooperate[npcid].IdleAction
    end
  elseif status == EBUILDSTATUS.EBUILDSTATUS_RUN then
    actionName = Table_BuildingCooperate[npcid].OnAction
  elseif status == EBUILDSTATUS.EBUILDSTATUS_OPER then
    actionName = Table_BuildingCooperate[npcid].RunAction
  end
  actionName = actionName and Table_ActionAnime[actionName]
  actionName = actionName and actionName.Name
  if actionName then
    local animParams = ReusableTable.CreateArray()
    animParams[1] = actionName
    animParams[2] = actionName
    animParams[3] = 1
    animParams[4] = normalizedTime
    animParams[5] = false
    animParams[6] = false
    animParams[11] = true
    animParams[13] = 0
    if nnpc.assetRole then
      if not nnpc.assetRole.complete.body then
        if waitModel then
          if not self.pendingAnims then
            self.pendingAnims = {}
          end
          self.pendingAnims[#self.pendingAnims + 1] = {
            nnpc,
            animParams,
            status,
            cbStatus
          }
          if self.pendingCheckTick == nil then
            self.pendingCheckTick = tickManager:CreateTick(0, 330, self._PendingAnimCheck, self, pendingCheckTickId)
          end
        end
      else
        self:_PlayBuildAction(nnpc, animParams, status, cbStatus)
      end
    end
  end
end

function BFBuildingProxy:_PendingAnimCheck()
  if self.pendingAnims and #self.pendingAnims > 0 then
    for i = #self.pendingAnims, 1, -1 do
      local p = self.pendingAnims[i]
      if not p[1] or not p[1].assetRole then
        table.remove(self.pendingAnims, i)
      elseif p[1].assetRole.complete and self:_PlayBuildAction(p[1], p[2], p[3], p[4]) then
        table.remove(self.pendingAnims, i)
      end
    end
  end
  if (not self.pendingAnims or not (#self.pendingAnims > 0)) and self.pendingCheckTick then
    tickManager:ClearTick(self, pendingCheckTickId)
    self.pendingCheckTick = nil
  end
end

function BFBuildingProxy:_PlayBuildAction(nnpc, animParams, status, cbStatus)
  if not (nnpc and nnpc.assetRole) or not nnpc.assetRole.PlayAction then
    return false
  end
  nnpc.assetRole:PlayAction(animParams)
  local npcId = nnpc.data.id
  self:SetBuildAnimStatus(npcId, status)
  tickManager:ClearTick(self, npcId)
  tickManager:CreateOnceDelayTick(6000, function(self)
    self:SwitchBuildingAnimByStatus(nnpc, cbStatus, status, false)
  end, self, npcId)
  return true
end

function BFBuildingProxy:SetBuildAnimStatus(id, status)
  if not self.buildAnimStatus then
    self.buildAnimStatus = {}
  end
  self.buildAnimStatus[id] = status
end

function BFBuildingProxy:GetBuildAnimStatus(id)
  return self.buildAnimStatus and self.buildAnimStatus[id]
end

function BFBuildingProxy:SecretGetTodayCount()
  return self.secretTodayCount or 0
end

function BFBuildingProxy:SecretGetHistory()
  return self.secretAlready
end

function BFBuildingProxy:SecretGetNew()
  return self.secretNewGet
end

function BFBuildingProxy:RecvUserSecretQueryMapCmd(data)
  self.secretNewGet = nil
  if not self.secretAlready then
    self.secretAlready = {}
  end
  TableUtility.ArrayClear(self.secretAlready)
  for i = 1, #data.ids do
    TableUtility.ArrayPushBack(self.secretAlready, data.ids[i])
  end
  self.secretTodayCount = data.day_count
end

function BFBuildingProxy:RecvUserSecretGetMapCmd(data)
  self.secretNewGet = data.id
end

function BFBuildingProxy:NightmareExchangeCount()
  if not self.nightmareExchangeCount then
    self.nightmareExchangeCount = 0
  end
  return self.nightmareExchangeCount
end

function BFBuildingProxy:SetNightmareGetPending()
  self.nightmareGetPending = true
  self.nightmareGetResult = nil
end

function BFBuildingProxy:RecvNightmareAttrQueryUserCmd(data)
  self.nightmareExchangeCount = data.count
end

function BFBuildingProxy:RecvNightmareAttrGetUserCmd(data)
  self.nightmareGetPending = false
  self.nightmareGetResult = data.success
  if data.success then
    if not self.nightmareExchangeCount then
      self.nightmareExchangeCount = 0
    end
    self.nightmareExchangeCount = self.nightmareExchangeCount + data.count
  end
end
