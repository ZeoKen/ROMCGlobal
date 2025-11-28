autoImport("DisneyRankShowData")
DriftBottleProxy = class("DriftBottleProxy", pm.Proxy)
DriftBottleProxy.Instance = nil
DriftBottleProxy.NAME = "DriftBottleProxy"

function DriftBottleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DriftBottleProxy.NAME
  if DriftBottleProxy.Instance == nil then
    DriftBottleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function DriftBottleProxy:Init()
  self.bottle_finishs = {}
  self.bottle_accepts = {}
  self.bottleGroupList = {}
  self:InitGroupList()
end

function DriftBottleProxy:InitGroupList()
  if Table_Bottle then
    for k, v in pairs(Table_Bottle) do
      local group = v.Group
      if not self.bottleGroupList[group] then
        self.bottleGroupList[group] = {}
      end
      table.insert(self.bottleGroupList[group], v.id)
    end
  end
end

function DriftBottleProxy:GetGroupList(group)
  if self.bottleGroupList[group] then
    return self.bottleGroupList[group]
  end
end

function DriftBottleProxy:RecvQueryBottleInfoQuestCmd(data)
  xdlog("recvQueryBottleInfo")
  local acceptsList = data.accepts
  local finishsList = data.finishs
  if acceptsList and 0 < #acceptsList then
    for i = 1, #acceptsList do
      local data = {
        bottleid = acceptsList[i].bottleid,
        status = acceptsList[i].status
      }
      self.bottle_accepts[acceptsList[i].bottleid] = data
    end
  end
  if finishsList and 0 < #finishsList then
    for i = 1, #finishsList do
      local data = {
        bottleid = finishsList[i].bottleid,
        status = finishsList[i].status
      }
      self.bottle_finishs[finishsList[i].bottleid] = data
    end
  end
end

function DriftBottleProxy:RecvBottleUpdateQuestCmd(data)
  local status = data.status
  local updates = data.updates
  local delids = data.delids
  if status == 1 then
    if updates and 0 < #updates then
      for i = 1, #updates do
        local data = {
          bottleid = updates[i].bottleid,
          status = updates[i].status
        }
        self.bottle_accepts[updates[i].bottleid] = data
      end
    end
    if delids and 0 < #delids then
      for i = 1, #delids do
        if self.bottle_accepts[delids[i]] then
          self.bottle_accepts[delids[i]] = nil
        end
      end
    end
  elseif status == 2 then
    if updates and 0 < #updates then
      for i = 1, #updates do
        local data = {
          bottleid = updates[i].bottleid,
          status = updates[i].status
        }
        self.bottle_finishs[updates[i].bottleid] = data
      end
    end
    if delids and 0 < #delids then
      for i = 1, #delids do
        if self.bottle_finishs[delids[i]] then
          self.bottle_finishs[delids[i]] = nil
        end
      end
    end
  end
end

function DriftBottleProxy:GetAcceptBottleList(onlyquesttype)
  if self.bottle_accepts then
    return self.bottle_accepts
  end
end

function DriftBottleProxy:GetFinishedBottleList()
  if self.bottle_finishs then
    return self.bottle_finishs
  end
end

function DriftBottleProxy:GetCurPieceData(id)
  if self.bottle_accepts and self.bottle_accepts[id] then
    return self.bottle_accepts[id]
  end
  if self.bottle_finishs and self.bottle_finishs[id] then
    return self.bottle_finishs[id]
  end
end
