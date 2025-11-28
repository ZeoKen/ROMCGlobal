EventDispatcher = class("EventDispatcher")

function EventDispatcher:DispatchEvent(eventType, obj)
  if self.handlers ~= nil and eventType ~= nil then
    local eventHandlers = self.handlers[eventType]
    if eventHandlers ~= nil then
      local evt = ReusableTable.CreateTable()
      evt.target, evt.data = self, obj
      for i = #eventHandlers, 1, -1 do
        local e = eventHandlers[i]
        if e and e.owners then
          for j = 1, #e.owners do
            e.func(e.owners[j], evt)
          end
        end
      end
      ReusableTable.DestroyAndClearTable(evt)
    end
  end
end

function EventDispatcher:PassEvent(eventType, obj)
  if self.handlers ~= nil and eventType ~= nil then
    local eventHandlers = self.handlers[eventType]
    if eventHandlers ~= nil then
      for i = #eventHandlers, 1, -1 do
        local e = eventHandlers[i]
        if e and e.owners then
          for j = 1, #e.owners do
            e.func(e.owners[j], obj)
          end
        end
      end
    end
  end
end

function EventDispatcher:AddEventListener(eventType, handler, handlerOwner)
  if self.handlers == nil then
    self.handlers = {}
  end
  local eventHandlers = self.handlers[eventType]
  if eventHandlers == nil then
    eventHandlers = ReusableTable.CreateArray()
    self.handlers[eventType] = eventHandlers
  end
  local index, ownerIndex = EventDispatcher.IndexOf(eventHandlers, handler, handlerOwner)
  if index == 0 then
    local eventHandler = ReusableTable.CreateTable()
    eventHandler.func = handler
    eventHandler.owners = ReusableTable.CreateArray()
    eventHandler.owners[1] = handlerOwner
    eventHandlers[#eventHandlers + 1] = eventHandler
  elseif ownerIndex == 0 and handlerOwner ~= nil then
    table.insert(eventHandlers[index].owners, handlerOwner)
  end
end

function EventDispatcher.IndexOf(tab, obj, owner)
  for _, o in pairs(tab) do
    if o.func == obj then
      if owner then
        for i = 1, #o.owners do
          if o.owners[i] == owner then
            return _, i
          end
        end
      end
      return _, 0
    end
  end
  return 0, 0
end

function EventDispatcher:RemoveEventListener(eventType, handler, handlerOwner)
  if self.handlers ~= nil then
    local eventHandlers = self.handlers[eventType]
    if eventHandlers ~= nil then
      if handler == nil then
        self:DestroyEvent(eventType, eventHandlers)
      else
        local index, ownerIndex = EventDispatcher.IndexOf(eventHandlers, handler, handlerOwner)
        if ownerIndex == 0 then
          if 0 < index then
            table.remove(eventHandlers, index)
            if #eventHandlers == 0 then
              self:DestroyEvent(eventType, eventHandlers)
            end
          end
        else
          table.remove(eventHandlers[index].owners, ownerIndex)
          if #eventHandlers[index].owners == 0 then
            ReusableTable.DestroyArray(eventHandlers[index].owners)
            ReusableTable.DestroyAndClearTable(eventHandlers[index])
            table.remove(eventHandlers, index)
            if #eventHandlers == 0 then
              self:DestroyEvent(eventType, eventHandlers)
            end
          end
        end
      end
    end
  end
end

function EventDispatcher:DestroyEvent(eventType, eventHandlers)
  for i = #eventHandlers, 1, -1 do
    ReusableTable.DestroyAndClearArray(eventHandlers[i].owners)
    ReusableTable.DestroyAndClearTable(eventHandlers[i])
    eventHandlers[i] = nil
  end
  ReusableTable.DestroyArray(eventHandlers)
  self.handlers[eventType] = nil
end

function EventDispatcher:ClearEvent()
  self.handlers = nil
end
