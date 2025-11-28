autoImport("ShortCutData")
ShortCutProxy = class("ShortCutProxy", pm.Proxy)
ShortCutProxy.Instance = nil
ShortCutProxy.NAME = "ShortCutProxy"
ShortCutProxy.ShortCutEnum = {
  ID1 = SceneSkill_pb.ESKILLSHORTCUT_NORMAL,
  ID2 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND,
  ID3 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_2,
  ID4 = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_3
}
ShortCutProxy.SwitchList = {
  [1] = SceneSkill_pb.ESKILLSHORTCUT_NORMAL,
  [2] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND,
  [3] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_2,
  [4] = SceneSkill_pb.ESKILLSHORTCUT_EXTEND_3
}
ShortCutProxy.AutoList = {
  [1] = SceneSkill_pb.ESKILLSHORTCUT_AUTO,
  [2] = SceneSkill_pb.ESKILLSHORTCUT_AUTO_2
}
ShortCutProxy.SkillShortCut = {
  Auto = SceneSkill_pb.ESKILLSHORTCUT_AUTO,
  BeingAuto = SceneSkill_pb.ESKILLSHORTCUT_BEINGAUTO,
  Auto2 = SceneSkill_pb.ESKILLSHORTCUT_AUTO_2
}
local PACKAHECHECK = {
  1,
  2,
  4,
  6,
  7,
  8,
  9,
  17,
  18
}

function ShortCutProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShortCutProxy.NAME
  if ShortCutProxy.Instance == nil then
    ShortCutProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.shortCutData = ShortCutData.new()
  self.itemShortMap = {}
  self.itemShortItemIdMap = {}
  self.currentAutoEnum = ShortCutProxy.AutoList[1]
end

function ShortCutProxy:GetUseBagTab()
  if self.bagTab == nil then
    self.bagTab = BagProxy.Instance.bagData:GetTab(GameConfig.ItemPage[4])
  end
  return self.bagTab
end

function ShortCutProxy:onRegister()
end

function ShortCutProxy:onRemove()
end

function ShortCutProxy:UnLockSkillShortCuts(serviceData)
  self.shortCutData:ResetSkillShortCuts()
  local hasExtendPos = false
  for i = 1, #serviceData.shortcuts do
    local shortcut = serviceData.shortcuts[i]
    self.shortCutData:UnLockSkillShortCuts(shortcut)
    if not hasExtendPos and (shortcut.type == self.ShortCutEnum.ID2 or shortcut.type == self.ShortCutEnum.ID3 or shortcut.type == self.ShortCutEnum.ID4) then
      hasExtendPos = true
    end
  end
  if hasExtendPos then
    GameFacade.Instance:sendNotification(SkillEvent.SkillUnlockPos)
  end
end

function ShortCutProxy:GetUnLockSkillMaxIndex(id)
  return self.shortCutData:GetUnLockSkillMaxIndex(id)
end

function ShortCutProxy:GetAutoUnLockSkillMaxIndex()
  return self.shortCutData:GetAutoSkillUnlockMaxIndex()
end

function ShortCutProxy:SetCacheListToRealList()
  self.shortCutData:SetCacheListToRealList()
end

function ShortCutProxy:SkillIsLocked(index, id)
  return self.shortCutData:SkillIsLocked(index, id)
end

function ShortCutProxy:AutoSkillIsLocked(index)
  return self.shortCutData:AutoSkillIsLocked(index)
end

function ShortCutProxy:SetShortCuts(shortCuts)
  if type(shortCuts) == "table" then
    for i = 1, #shortCuts do
      self:SetShortCut(shortCuts[i])
    end
  end
  TableUtility.TableClear(self.itemShortItemIdMap)
  for _, data in pairs(self.itemShortMap) do
    if data.type and data.type ~= 0 then
      self.itemShortItemIdMap[data.type] = 1
    end
  end
end

function ShortCutProxy:IsQuickUseItem(id)
  return nil ~= self.itemShortItemIdMap[id]
end

function ShortCutProxy:HandleServerShortCut(checkequip)
  local _BagProxy = BagProxy.Instance
  local staticData
  for _, v in pairs(self.itemShortMap) do
    staticData = v.type and Table_Item[v.type] or nil
    if staticData then
      if nil ~= Table_Equip[v.type] and staticData.Type ~= 550 then
        if checkequip and 0 >= _BagProxy:GetItemNumByStaticID(v.type, PACKAHECHECK) then
          v.type = 0
          v.guid = ""
        end
      elseif StringUtil.IsEmpty(v.guid) then
        local mainBagItem = _BagProxy:GetItemByStaticID(v.type)
        if nil ~= mainBagItem then
          v.guid = mainBagItem.id
        end
      elseif 0 >= _BagProxy:GetItemNumByStaticID(v.type, GameConfig.PackageMaterialCheck.default) and staticData.Type ~= 550 then
        v.guid = ""
      end
    end
  end
end

function ShortCutProxy:SetShortCut(data)
  if data then
    local cutData = {
      pos = data.pos,
      guid = data.guid,
      preguid = data.preguid,
      type = data.type
    }
    self.itemShortMap[cutData.pos + 1] = cutData
    self.itemShortItemIdMap[cutData.type] = 1
    GameFacade.Instance:sendNotification(MyselfEvent.ResetHpShortCut)
  end
end

function ShortCutProxy:MulRowShortCutItems()
  if not self.itemShortMap or #self.itemShortMap < 6 then
    return false
  end
  for i = 6, #self.itemShortMap do
    if nil ~= self.itemShortMap[i] and not StringUtil.IsEmpty(self.itemShortMap[i].guid) then
      return true
    end
  end
  return false
end

local Table_Equip = Table_Equip
local Table_Mount = Table_Mount

function ShortCutProxy:GetShorCutItem(needPos)
  local result = {}
  local _BagProxy = BagProxy.Instance
  for i = 1, #self.itemShortMap do
    local data = self.itemShortMap[i]
    if data then
      local item = _BagProxy.bagData:GetItemByGuid(data.guid)
      if not item then
        item = _BagProxy.personalArtifactBagData:GetItemByGuid(data.guid)
        if not item then
          item = _BagProxy.roleEquip:GetItemByGuid(data.guid)
          if not item then
            if data.preguid and data.preguid ~= "" and Table_Equip[data.type] and not Table_Mount[data.type] then
              item = _BagProxy:GetItemByStaticID(data.type, BagProxy.BagType.RoleEquip)
              if item and item:IsPileStringMatch(data.preguid) then
              else
                local items = _BagProxy:GetItemsByStaticID(data.type, BagProxy.BagType.MainBag)
                if items then
                  for j = 1, #items do
                    if items[j]:IsPileStringMatch(data.preguid) then
                      item = items[j]
                      break
                    end
                  end
                end
              end
            else
              item = _BagProxy.fashionEquipBag:GetItemByGuid(data.guid)
              if not item then
                item = _BagProxy.walletBagData:GetItemByGuid(data.guid)
                item = item or _BagProxy:GetItemByStaticID(data.type)
              end
            end
          end
        end
      end
      if not item and data.type and Table_Item[data.type] then
        item = ItemData.new("Shadow", data.type)
      end
      if needPos then
        result[data.pos + 1] = item
      else
        table.insert(result, item)
      end
    end
  end
  return result
end

function ShortCutProxy:GetValidShortItem(staticId)
  local items = self:GetShorCutItem()
  for i = 1, #items do
    local item = items[i]
    if item.staticData.id == staticId and item:CanUse() then
      return item
    end
  end
end

function ShortCutProxy:ShortCutListIsEnable(id)
  return self.shortCutData:ShortCutListIsEnable(id)
end

function ShortCutProxy:AutoShortCutListIsEnable()
  return FunctionUnLockFunc.Me():CheckCanOpen(6207, false)
end

function ShortCutProxy:SetCurrentAuto(auto)
  if auto ~= self.currentAutoEnum then
    SkillProxy.Instance:SetEquipedAutoArrayDirty(true)
  end
  self.currentAutoEnum = auto
  local fakeDeadSkillID = SkillProxy.Instance:GetFakeDeadSkill(auto)
  Game.Myself:Client_SetAutoFakeDead(fakeDeadSkillID)
end

function ShortCutProxy:GetCurrentAuto()
  return self.currentAutoEnum or ShortCutProxy.AutoList[1]
end
