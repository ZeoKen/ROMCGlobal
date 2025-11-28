EventDispatcherRobust = class("EventDispatcherRobust")

function EventDispatcherRobust.Me()
  if EventDispatcherRobust.me == nil then
    EventDispatcherRobust.me = EventDispatcherRobust.new()
  end
  return EventDispatcherRobust.me
end

function EventDispatcherRobust:DispatchEvent(eventType, obj)
  local evt = ReusableTable.CreateTable()
  evt.target, evt.data = self, obj
  self:PassEvent(eventType, evt)
  ReusableTable.DestroyAndClearTable(evt)
end

function EventDispatcherRobust:PassEvent(eventType, obj)
  if self.handlers ~= nil and eventType ~= nil then
    local eventHandlers = self.handlers[eventType]
    if eventHandlers ~= nil then
      local handlerCount = #eventHandlers
      local iHandler = 1
      while handlerCount >= iHandler do
        local handler = eventHandlers[iHandler]
        if handler == nil or handler.owners == nil or handler.func == nil then
          table.remove(eventHandlers, iHandler)
          handlerCount = handlerCount - 1
        else
          local owners = handler.owners
          local ownerCount = #owners
          local iOwner = 1
          while ownerCount >= iOwner do
            local owner = owners[iOwner]
            if owner == nil then
              table.remove(owners, iOwner)
              ownerCount = ownerCount - 1
            else
              handler.func(owner, obj)
              iOwner = iOwner + 1
            end
          end
          if ownerCount == 0 then
            table.remove(eventHandlers, iHandler)
            handlerCount = handlerCount - 1
          else
            iHandler = iHandler + 1
          end
        end
      end
    end
  end
end

local IndexOf = function(tab, handler, owner)
  for k, o in pairs(tab) do
    if o.func == handler then
      if owner then
        for i = 1, #o.owners do
          if o.owners[i] == owner then
            return k, i
          end
        end
      end
      return k, 0
    end
  end
  return 0, 0
end

function EventDispatcherRobust:AddEventListener(eventType, handler, owner)
  if self.handlers == nil then
    self.handlers = {}
  end
  local eventHandlers = self.handlers[eventType]
  if eventHandlers == nil then
    eventHandlers = {}
    self.handlers[eventType] = eventHandlers
  end
  local index, ownerIndex = IndexOf(eventHandlers, handler, owner)
  if index == 0 then
    eventHandlers[#eventHandlers + 1] = {
      func = handler,
      owners = {owner}
    }
  elseif ownerIndex == 0 and owner ~= nil then
    table.insert(eventHandlers[index].owners, owner)
  end
end

function EventDispatcherRobust:RemoveEventListener(eventType, handler, owner)
  if self.handlers ~= nil then
    local eventHandlers = self.handlers[eventType]
    if eventHandlers ~= nil then
      if handler == nil then
        self.handlers[eventType] = nil
      else
        local index, ownerIndex = EventDispatcher.IndexOf(eventHandlers, handler, owner)
        if 0 < index and 0 < ownerIndex then
          eventHandlers[index].owners[ownerIndex] = nil
        end
      end
    end
  end
end

function EventDispatcherRobust:ClearEvent()
  self.handlers = nil
end
