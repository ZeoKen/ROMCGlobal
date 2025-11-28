autoImport("TechTreeAttributeCombineCell")
autoImport("TechTreeToyPage")
TechTreeAttributePage = class("TechTreeAttributePage", SubView)
TechTreeAttributePage.ColumnNum = 3
TechTreeAttributePage.MapToggle = {
  [102] = 1,
  [105] = 2
}

function TechTreeAttributePage:Init()
  self:ReLoadPerferb("view/TechTreeAttributePage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:FindObjs()
  self:InitData()
  self:InitPage()
  self:AddEvents()
end

function TechTreeAttributePage:FindObjs()
  self.noneTip = self:FindGO("NoneTip")
  self.catTex = self:FindComponent("Cat", UITexture)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.panel = self.scrollView.panel
  self.toggles = self:FindGO("Toggles")
  self.toggles:SetActive(false)
end

function TechTreeAttributePage:InitData()
  self.treeId = self.container.treeId or 3
  self.mapHeaderData = {
    header = ZhString.TechTree_AttributeMapTab
  }
  self.fieldHeaderData = {
    header = ZhString.TechTree_FieldBuff
  }
  self.personalHeaderData = {
    header = ZhString.TechTree_AttributePersonalTab
  }
end

function TechTreeAttributePage:InitPage()
  self.catTexName = "pic_jiali"
  self.attrCtl = UIGridListCtrl.new(self.grid, TechTreeAttributeCombineCell, "TechTreePageCombineCell")
  self.attrCtl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
  local _, h = UIManagerProxy.Instance:GetMyMobileScreenSize()
  local tmpClipRegion = self.panel.baseClipRegion
  tmpClipRegion.w = h - 100
  self.panel.baseClipRegion = tmpClipRegion
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.grid.transform))
  tempV3.y = h / 2 - 43
  self.grid.transform.localPosition = tempV3
  self.hideMapAttr = false
  self.hideFieldAttr = false
  self.hidePersonalAttr = false
end

function TechTreeAttributePage:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, self.UpdatePage)
end

local getAttributeState = function(staticData)
  if TableUtility.ArrayFindIndex(TechTreeMapEffectTypes, staticData.Type) > 0 or 0 < TableUtility.ArrayFindIndex(TechTreeFieldEffectType, staticData.Type) then
    return TechTreeAttributeCellState.Map
  elseif 0 < TableUtility.ArrayFindIndex(TechTreePersonalEffectTypes, staticData.Type) then
    return TechTreeAttributeCellState.Personal
  elseif staticData.Type == 4 then
    return TechTreeAttributeCellState.Personal
  else
    LogUtility.WarningFormat("Cannot get TechTreeAttributeCellState of TechTreeEffect id:{0}", staticData.id)
  end
end
local getAttributeValue = function(staticData, state)
  state = state or getAttributeState(staticData)
  if not state then
    return
  end
  local prop, value, isfakevalue
  if state == TechTreeAttributeCellState.Map then
    value = staticData.Params.ratio or staticData.Params[1] and staticData.Params[1].ratio or staticData.Params[1] and staticData.Params[1].extra_ratio
    if value then
      return value, true
    end
    if staticData.Type == "map_buff" then
      if GameConfig.TechTree.MapBuffTexture and GameConfig.TechTree.MapBuffTexture[staticData.id] then
        isfakevalue = GameConfig.TechTree.MapBuffTexture[staticData.id].IsPercent
        value = GameConfig.TechTree.MapBuffTexture[staticData.id].Value
      else
        local buffIds = staticData.Params.buffid
        if type(buffIds) == "table" then
          for k, v in pairs(Table_Buffer[buffIds[1]].BuffEffect) do
            if type(v) == "number" then
              prop, value = k, v
              break
            end
          end
        end
      end
    elseif staticData.Type == "produce_speed" then
      return staticData.Params.speed, false
    elseif staticData.Type == "produce_upperlimit" then
      return staticData.Params.num, false
    end
  elseif state == TechTreeAttributeCellState.Personal then
    prop, value = next(staticData.Params)
  end
  local propData = prop and Game.Config_PropName[prop]
  if propData then
    return value, propData.IsPercent == 1 and true or false
  elseif isfakevalue then
    return value, isfakevalue == 1 and true or false
  else
    LogUtility.WarningFormat("Cannot get RoleData with VarName:{0} of TechTreeEffect id:{1}", prop, staticData.id)
  end
end
local createTempAttribute = function(staticData)
  local a = {}
  a.state = getAttributeState(staticData)
  a.value, a.isPercent = getAttributeValue(staticData, a.state)
  a.desc = staticData.Desc
  return a
end
local groups, groupTempAttributeMap, tempAttributes = {}, {}, {}

function TechTreeAttributePage:AddUnlockedEffects(cacheArr, effectGetFuncKey, headerData, hideAttrKey)
  local ins, oldCacheEffCount = TechTreeProxy.Instance, #cacheArr
  local effects, reunited, group = ins[effectGetFuncKey](ins, self.treeId)
  if effects and 0 < #effects then
    headerData.hide = self[hideAttrKey]
    TableUtility.ArrayPushBack(cacheArr, headerData)
    TableUtility.ArrayClear(groups)
    TableUtility.TableClear(groupTempAttributeMap)
    TableUtility.TableClear(tempAttributes)
    if not self[hideAttrKey] then
      for i = 1, #effects do
        group = effects[i].GroupId
        if group then
          if groupTempAttributeMap[group] then
            groupTempAttributeMap[group].value = groupTempAttributeMap[group].value + getAttributeValue(effects[i]) or 0
          else
            groupTempAttributeMap[group] = createTempAttribute(effects[i])
            TableUtility.ArrayPushBack(groups, group)
          end
        else
          TableUtility.ArrayPushBack(tempAttributes, createTempAttribute(effects[i]))
        end
      end
      table.sort(groups)
      for i = 1, #groups do
        TableUtility.ArrayPushBack(tempAttributes, groupTempAttributeMap[groups[i]])
      end
      reunited = self:ReUnitData(tempAttributes)
      for i = 1, #reunited do
        TableUtility.ArrayPushBack(cacheArr, reunited[i])
      end
    end
  end
  return #cacheArr - oldCacheEffCount
end

function TechTreeAttributePage:UpdatePage()
  local data, effectCount = ReusableTable.CreateArray(), 0
  effectCount = effectCount + self:AddUnlockedEffects(data, "GetUnlockedMapEffects", self.mapHeaderData, "hideMapAttr")
  effectCount = effectCount + self:AddUnlockedEffects(data, "GetUnlockedFieldEffects", self.fieldHeaderData, "hideFieldAttr")
  effectCount = effectCount + self:AddUnlockedEffects(data, "GetUnlockedPersonalEffects", self.personalHeaderData, "hidePersonalAttr")
  self.noneTip:SetActive(effectCount == 0)
  self.scrollView.gameObject:SetActive(0 < effectCount)
  if 0 < effectCount then
    self.attrCtl:ResetDatas(data)
  end
  ReusableTable.DestroyAndClearArray(data)
  self.scrollView:ResetPosition()
end

local reunited = {}

function TechTreeAttributePage:ReUnitData(datas)
  TableUtility.TableClear(reunited)
  local i1, i2
  if datas and 0 < #datas then
    for i = 1, #datas do
      i1 = math.floor((i - 1) / TechTreeAttributePage.ColumnNum) + 1
      i2 = math.floor((i - 1) % TechTreeAttributePage.ColumnNum) + 1
      reunited[i1] = reunited[i1] or {}
      reunited[i1][i2] = datas[i]
    end
  end
  return reunited
end

function TechTreeAttributePage:OnEnter()
  TechTreeAttributePage.super.OnEnter(self)
  PictureManager.Instance:SetUI(self.catTexName, self.catTex)
end

function TechTreeAttributePage:OnActivate()
  self:UpdatePage()
end

function TechTreeAttributePage:OnExit()
  PictureManager.Instance:UnLoadUI(self.catTexName, self.catTex)
  TechTreeAttributePage.super.OnExit(self)
end

function TechTreeAttributePage:OnMouseClick(str)
  if str == ZhString.TechTree_AttributeMapTab then
    self.hideMapAttr = not self.hideMapAttr
  elseif str == ZhString.TechTree_AttributePersonalTab then
    self.hidePersonalAttr = not self.hidePersonalAttr
  elseif str == ZhString.TechTree_FieldBuff then
    self.hideFieldAttr = not self.hideFieldAttr
  end
  self:UpdatePage()
end
