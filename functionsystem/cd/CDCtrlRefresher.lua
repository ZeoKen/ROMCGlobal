autoImport("FunctionCD")
CDCtrlRefresher = class("CDCtrlRefresher", FunctionCD)

function CDCtrlRefresher:Add(obj)
  local id = obj.id
  if not id and obj.data then
    id = obj.data.id
  end
  if id then
    self.objs[obj.data.id] = obj
  else
    error("cd刷新ctrl类中的元素未找到id")
  end
end

function CDCtrlRefresher:Remove(obj)
  if obj and obj.data and type(obj) == "table" then
    obj = obj.data.id
  end
  self.objs[obj] = nil
end

LeanTweenCDCellRefresher = class("LeanTweenCDCellRefresher", FunctionCD)

function LeanTweenCDCellRefresher:ctor(interval)
  self:Reset()
end

function LeanTweenCDCellRefresher:Add(cell)
  if cell.gameObject then
    local cding = self.objs[cell]
    TimeTickManager.Me():ClearTick(cell)
    if cding then
      TimeTickManager.Me():ClearTick(cding)
    end
    self.objs[cell] = cell
    local now = cell:GetCD()
    local max = cell:GetMaxCD()
    if now == nil then
      return
    end
    if max == nil or max == 0 then
      return
    end
    cell.timeTickId = cell.timeTickId == nil and 1 or cell.timeTickId + 1
    cell.cdTimeTick = TimeTickManager.Me():CreateTickFromTo(0, now / max, 0, now * 1000, function(owner, deltaTime, curValue)
      if cell:RefreshCD(curValue) then
        self:Remove(cell)
      end
    end, cell, cell.timeTickId):SetCompleteFunc(function(owner, id)
      self:Remove(cell)
    end)
    if cell.AddCD then
      cell:AddCD()
    end
  else
    error("cd刷新ctrl类中的元素未找到id")
  end
end

function LeanTweenCDCellRefresher:Remove(cell)
  if cell and cell.gameObject then
    TimeTickManager.Me():ClearTick(cell)
    local removed = self.objs[cell]
    if removed and removed.ClearCD then
      TimeTickManager.Me():ClearTick(removed)
      removed:ClearCD()
    end
  end
  self.objs[cell] = nil
end

function LeanTweenCDCellRefresher:RemoveAll()
  for k, v in pairs(self.objs) do
    self:Remove(v)
  end
  LeanTweenCDCellRefresher.super.RemoveAll(self)
end

function LeanTweenCDCellRefresher:IsRefreshing(cell)
  return self.objs[cell] ~= nil
end

BagCDRefresher = class("BagCDRefresher", LeanTweenCDCellRefresher)
EquippedEffectCDRefresher = class("EquippedEffectCDRefresher", LeanTweenCDCellRefresher)
