autoImport("GOManager_Base")
GOManager_StealthGame = class("GOManager_StealthGame", GOManager_Base)
local DoorOptDialog = {
  Use = 393753,
  NoGet = 393754,
  TakeOut = 393755
}

function GOManager_StealthGame:ctor()
  GOManager_StealthGame.super.ctor(self)
  self.doorMap = {}
  self.normalObjects = {}
end

function GOManager_StealthGame:RegisterGameObject(obj)
  if not obj then
    return false
  end
  if obj.properties == nil then
    clogError("注册场景物件" .. obj.name .. " properties = null")
    return false
  end
  redlog("注册场景物件", obj, obj.ID, #obj.properties)
  local len = #obj.properties
  if obj:GetProperty(0) == "door" then
    redlog("注册门", obj, obj.ID)
    local info = {}
    info.canOpen = true
    info.state = "Close"
    info.plotIdMap = {}
    local plotIdStr = obj:GetProperty(1)
    if plotIdStr then
      local idStrs = string.split(plotIdStr, ",")
      info.plotIdMap.Open = tonumber(idStrs[1])
      info.plotIdMap.Close = tonumber(idStrs[2])
      info.plotIdMap.Equiped = tonumber(idStrs[3])
      info.plotIdMap.TakeOut = tonumber(idStrs[4])
    else
      info.plotIdMap.Open = 1
      info.plotIdMap.Close = 2
      info.plotIdMap.Equiped = 3
      info.plotIdMap.TakeOut = 4
    end
    local dialogIdStr = obj:GetProperty(2)
    info.dialog = {}
    if dialogIdStr then
      local idStrs = string.split(dialogIdStr, ",")
      info.dialog.Use = tonumber(idStrs[1])
      info.dialog.NoGet = tonumber(idStrs[2])
      info.dialog.TakeOut = tonumber(idStrs[3])
    else
      info.dialog.Use = 393753
      info.dialog.NoGet = 393754
      info.dialog.TakeOut = 393755
    end
    local needItemStr = obj:GetProperty(3)
    if needItemStr then
      local idStrs = string.split(needItemStr, ",")
      info.needItem = {}
      for i = 1, #idStrs do
        local itemID = tonumber(idStrs[i])
        info.needItem[itemID] = 1
        info.canOpen = false
      end
    end
    info.outline = obj:GetComponent(PostProcessOutline)
    if info.outline then
      info.outlineColor = info.outline.OutlineColor
      info.outline.enabled = false
    end
    info.boxCollider = obj:GetComponent(BoxCollider)
    self.doorMap[obj.ID] = info
  elseif obj:GetProperty(0) == "object" then
    local info = {}
    info.object = obj
    info.outline = obj:GetComponent(PostProcessOutline)
    info.boxCollider = obj:GetComponent(BoxCollider)
    if info.outline then
      info.outlineColor = info.outline.OutlineColor
      info.outline.enabled = false
    end
    self.normalObjects[obj.ID] = info
  elseif obj:GetProperty(0) == "fixedstate" then
    if not self.fixedObjects then
      self.fixedObjects = {}
    end
    local t = {}
    t[1] = obj:GetComponentProperty(0)
    for i = 1, len - 1 do
      t[i + 1] = obj:GetProperty(i)
    end
    self.fixedObjects[obj.ID] = t
  end
  return GOManager_StealthGame.super.RegisterGameObject(self, obj)
end

function GOManager_StealthGame:GetObject(objID)
  return self.objMap[objID]
end

function GOManager_StealthGame:ClickObject(obj)
  SgAIManager.Me():getInstance():OnShowClickEffect(obj.gameObject, 0.2, 0.2)
  self:handlerDoorOpt(obj.ID)
end

function GOManager_StealthGame:playDoorDialog(dialogID, doorID, doorInfo)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialogID},
    keepOpen = true,
    callback = GOManager_StealthGame.handlerDialogOption,
    callbackData = {
      self,
      doorID,
      doorInfo
    }
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function GOManager_StealthGame.handlerDialogOption(params, optionId)
  local self = params[1]
  local doorID = params[2]
  local doorInfo = params[3]
  local needDisplay
  if optionId == 1 then
    if not SgAIManager.Me():checkDoorCanEquip(id, doorInfo.needItem) then
      self:playDoorDialog(doorInfo.dialog.NoGet, doorID, doorInfo)
      return false
    end
    for itemID, count in pairs(doorInfo.needItem) do
      SgAIManager.Me():playerUseDoorItem(doorID, itemID, count)
    end
    needDisplay = true
  elseif optionId == 2 then
  elseif optionId == 3 then
  elseif optionId == 4 then
    for itemID, count in pairs(doorInfo.needItem) do
      SgAIManager.Me():playerTakeOutDoorItem(doorID, itemID, count)
    end
    needDisplay = true
  end
  if needDisplay then
    self:DisplayDoorEquipPlot(doorID)
  end
  return true
end

function GOManager_StealthGame:showDoorOperateUI(id, doorInfo)
  local canOpen = SgAIManager.Me():checkDoorCanOpen(id, doorInfo.needItem)
  if canOpen then
    self:playDoorDialog(doorInfo.dialog.TakeOut, id, doorInfo)
  else
    self:playDoorDialog(doorInfo.dialog.Use, id, doorInfo)
  end
end

local doorDirPos = LuaVector3()

function GOManager_StealthGame:handlerDoorOpt(id)
  local doorInfo = self.doorMap[id]
  if not doorInfo then
    return
  end
  if not doorInfo.needItem then
    return
  end
  if doorInfo.state == "Open" then
    return
  end
  local obj = self.objMap[id]
  LuaVector3.Better_Set(doorDirPos, LuaGameObject.GetPosition(obj.transform))
  local distance = LuaVector3.Distance(doorDirPos, Game.Myself:GetPosition())
  if distance < 3 then
    self:showDoorOperateUI(id, doorInfo)
  else
    Game.Myself:Client_MoveTo(doorDirPos, nil, function()
      self:showDoorOperateUI(id, doorInfo)
    end, nil, nil, 3)
  end
end

function GOManager_StealthGame:DisplayDoorEquipPlot(id)
  local doorInfo = self.doorMap[id]
  if not doorInfo then
    return
  end
  local curEquiped = SgAIManager.Me():checkDoorCanOpen(id, doorInfo.needItem)
  if curEquiped == doorInfo.equiped then
    return
  end
  doorInfo.equiped = curEquiped
  if doorInfo.equiped then
    Game.PlotStoryManager:Start_PQTLP(doorInfo.plotIdMap.Equiped, nil, nil, nil, false, nil, {
      obj = {id = id, type = 25}
    }, false)
    redlog("播放 装备门道具", id, doorInfo.plotIdMap.Equiped)
  else
    if not doorInfo.plotIdMap.TakeOut then
      error(string.format("该门没有配置拆卸道具的剧情.(id:%s)", id))
    end
    Game.PlotStoryManager:Start_PQTLP(doorInfo.plotIdMap.TakeOut, nil, nil, nil, false, nil, {
      obj = {id = id, type = 25}
    }, false)
    redlog("播放 拆卸门道具", id, doorInfo.plotIdMap.TakeOut)
  end
end

function GOManager_StealthGame:SwitchDoor(id, open)
  local info = self.doorMap[id]
  if not info then
    return false
  end
  if info.needItem then
    if info.equiped == nil then
      info.equiped = SgAIManager.Me():checkDoorCanOpen(id, info.needItem)
    end
    info.open = info.equiped and open or false
  else
    info.open = open
  end
  self:RefreshDoorAnimation(id)
  return info.open
end

function GOManager_StealthGame:UnregisterGameObject(obj)
  self.doorMap[obj.ID] = nil
  self.normalObjects[obj.ID] = nil
  return GOManager_StealthGame.super.UnregisterGameObject(self, obj)
end

function GOManager_StealthGame:RefreshDoorAnimation(id)
  local doorInfo = self.doorMap[id]
  if not doorInfo then
    return
  end
  if doorInfo.open then
    if doorInfo.state ~= "Open" then
      doorInfo.state = "Open"
      Game.PlotStoryManager:Start_PQTLP(doorInfo.plotIdMap.Open, nil, nil, nil, false, nil, {
        obj = {id = id, type = 25}
      }, false)
      redlog("打开门", id, doorInfo.plotIdMap.Open)
      if doorInfo.boxCollider ~= nil then
        doorInfo.boxCollider.enabled = false
      end
    end
  elseif doorInfo.state ~= "Close" then
    doorInfo.state = "Close"
    if doorInfo.boxCollider ~= nil then
      doorInfo.boxCollider.enabled = true
    end
    if doorInfo.needItem then
      doorInfo.equiped = SgAIManager.Me():checkDoorCanOpen(id, doorInfo.needItem)
      if doorInfo.equiped then
        Game.PlotStoryManager:Start_PQTLP(doorInfo.plotIdMap.Equiped, nil, nil, nil, false, nil, {
          obj = {id = id, type = 25}
        }, false)
        redlog("装备门道具", id, doorInfo.plotIdMap.Equiped)
        return
      end
    end
    Game.PlotStoryManager:Start_PQTLP(doorInfo.plotIdMap.Close, nil, nil, nil, false, nil, {
      obj = {id = id, type = 25}
    }, false)
    redlog("关闭门", id, doorInfo.plotIdMap.Close)
  end
end

local DoorShowColor = {
  CanEquip = LuaColor.New(0.611764705882353, 0.9921568627450981, 0.6039215686274509, 1),
  Equiped = LuaColor.New(0.7529411764705882, 0.7529411764705882, 0.7529411764705882, 1),
  DefaultColor = LuaColor.New(0.9725490196078431, 0.35294117647058826, 0.35294117647058826, 1)
}
local DiffDefaultColor = LuaColor.New(0.29411764705882354, 0.7215686274509804, 0.8431372549019608, 1)

function GOManager_StealthGame:ShowDoorOutline(dis, diff)
  local _SgAIManager = SgAIManager.Me()
  local myPos = Game.Myself:GetPosition()
  for doorID, doorInfo in pairs(self.doorMap) do
    local obj = self.objMap[doorID]
    LuaVector3.Better_Set(doorDirPos, LuaGameObject.GetPosition(obj.transform))
    local distance = LuaVector3.Distance(doorDirPos, myPos)
    if dis >= distance then
      if diff then
        if _SgAIManager:checkDoorCanOpen(doorID, doorInfo.needItem) then
          if doorInfo.outline then
            doorInfo.outline.OutlineColor = DoorShowColor.CanEquip
            doorInfo.outline.enabled = true
          end
        elseif _SgAIManager:checkDoorCanEquip(doorID, doorInfo.needItem) then
          if doorInfo.outline then
            doorInfo.outline.OutlineColor = DoorShowColor.Equiped
            doorInfo.outline.enabled = true
          end
        elseif doorInfo.outline then
          doorInfo.outline.OutlineColor = DoorShowColor.DefaultColor
          doorInfo.outline.enabled = true
        end
      elseif doorInfo.outline then
        doorInfo.outline.OutlineColor = DiffDefaultColor
        doorInfo.outline.enabled = true
      end
    end
  end
  for id, objInfo in pairs(self.normalObjects) do
    local obj = objInfo.object
    LuaVector3.Better_Set(doorDirPos, LuaGameObject.GetPosition(obj.transform))
    local distance = LuaVector3.Distance(doorDirPos, myPos)
    if dis >= distance and objInfo.outline then
      objInfo.outline.enabled = true
    end
  end
end

function GOManager_StealthGame:HideDoorOutline()
  for _, doorInfo in pairs(self.doorMap) do
    if doorInfo.outline then
      doorInfo.outline.enabled = false
    end
  end
  for _, objInfo in pairs(self.normalObjects) do
    if objInfo.outline then
      objInfo.outline.enabled = false
    end
  end
end

function GOManager_StealthGame:RegisterMachineInfo(id, machineTrigger)
  if not self.objMap[id] then
    return
  end
  if not self.machineMap then
    self.machineMap = {}
  end
  self.machineMap[id] = machineTrigger
end

function GOManager_StealthGame:UnRegisterMachineInfo(id)
  if self.machineMap then
    self.machineMap[id] = nil
  end
end

function GOManager_StealthGame:ShowMachineOutline(active)
  if not self.machineMap then
    return
  end
  for id, sgMachineTrigger in pairs(self.machineMap) do
    local state = sgMachineTrigger:GetMachineState()
  end
end

function GOManager_StealthGame:IsFixedStateCorrect(id)
  local info = self.fixedObjects[id]
  if not info or Slua.IsNull(info[1]) or not info[2] then
    return true
  end
  local state = info[1]:GetCurrentAnimatorStateInfo(0)
  if state then
    for i = 2, #info do
      if state:IsName(info[i]) then
        return false
      end
    end
  end
  return true
end
