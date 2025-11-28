HomeBuildingWorldGridControl = class("HomeBuildingWorldGridControl", SubView)
local m_worldGridHeight = 0.01
local m_furnitureExtendGridHeight = 0.02
local m_buildSignHeight = 0.15
local m_color_red = LuaColor.Red()
local m_color_green = LuaColor.Green()

function HomeBuildingWorldGridControl:Init()
  self.tabUsableBuildSign = {}
  self.tabUsingBuildSign = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeBuildingWorldGridControl:FindObjs()
  local l_objWorldRoot = self:FindGO("WorldRoot")
  self.tsfWorldRoot = l_objWorldRoot.transform
  self.objWorldGridRoot = self:FindGO("WorldGridRoot", l_objWorldRoot)
  self.tsfBuildSignPool = self:FindGO("BuildSignPool", self.objWorldGridRoot).transform
  local l_objBuildSign = self:FindGO("BuildSign", self.objWorldGridRoot)
  self.tabBuildSign = {
    gameObject = l_objBuildSign,
    transform = l_objBuildSign.transform
  }
  self.objGridShowRoot = self:FindGO("GridShowRoot", self.objWorldGridRoot)
  local l_objItemExtentGrid = self:FindGO("FurnitureExtentGrid", self.objGridShowRoot)
  local l_tsfItemExtentGrid = l_objItemExtentGrid.transform
  self.tabItemExtentGrid = {gameObject = l_objItemExtentGrid}
  Game.AssetManager_Furniture:CreateBuildGridMask(l_tsfItemExtentGrid, function(obj)
    self.tabItemExtentGrid.horizontal = {
      gameObject = obj,
      transform = obj.transform,
      material = obj:GetComponent(Renderer).material
    }
  end)
  Game.AssetManager_Furniture:CreateBuildGridMask(l_tsfItemExtentGrid, function(obj)
    self.tabItemExtentGrid.verticle = {
      gameObject = obj,
      transform = obj.transform,
      material = obj:GetComponent(Renderer).material
    }
  end)
end

function HomeBuildingWorldGridControl:AddEvts()
end

function HomeBuildingWorldGridControl:AddViewEvts()
end

function HomeBuildingWorldGridControl:InitView()
  self.mapInfo = HomeManager.Me():GetMapInfo()
  local cellSize = self.container.CellSize
  self.objWorldGridRoot.transform.localScale = LuaGeometry.GetTempVector3(cellSize, cellSize, cellSize)
  self:CreateGroundGrids()
end

function HomeBuildingWorldGridControl:CreateGroundGrids()
  local tsfWorldGrid = self:FindGO("WorldGrid", self.objGridShowRoot).transform
  local curMapSData = HomeManager.Me():GetCurMapSData()
  local info, objGroundGrid, tsfGroundGird
  for i = 1, #self.mapInfo do
    info = self.mapInfo[i]
    objGroundGrid = Game.AssetManager_Furniture:CreateWorldGrid(curMapSData.NameEn, i)
    if objGroundGrid then
      objGroundGrid.name = tostring(i)
      tsfGroundGird = objGroundGrid.transform
      tsfGroundGird.position = LuaGeometry.GetTempVector3(info.x, info.y + m_worldGridHeight, info.z)
      tsfGroundGird.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
      tsfGroundGird.parent = tsfWorldGrid
    else
      LogUtility.Error("加载HomeWorldGrid失败！")
    end
  end
end

function HomeBuildingWorldGridControl:ShowWorldGrid(isShow)
  if self.isWoldGridShow == isShow then
    return
  end
  self.isWoldGridShow = isShow ~= false
  self.objGridShowRoot:SetActive(self.isWoldGridShow)
end

local vecExentGridPos = LuaVector3(0, 0, 0)

function HomeBuildingWorldGridControl:ShowCurItemExtentGrid(isShow, itemGridPos, right, wrong)
  local curOperateItem = self.container.curOperateItem
  isShow = isShow and curOperateItem ~= nil
  if self.tabItemExtentGrid.isActive ~= isShow then
    self.tabItemExtentGrid.gameObject:SetActive(isShow)
    self.tabItemExtentGrid.isActive = isShow
  end
  if not isShow then
    return
  end
  local cellSize = self.container.CellSize
  itemGridPos = itemGridPos or LuaGeometry.GetTempVector3(curOperateItem.assetFurniture:GetPositionXYZ(), vecExentGridPos)
  local floorInfo = self.mapInfo[curOperateItem.curFloor]
  local angle = curOperateItem:GetRotationAngle()
  local isHoriAngle = angle == BuildingGrid.EBuildingRotation.E0 or angle == BuildingGrid.EBuildingRotation.E180
  local worldPosY = HomeManager.Me():GetWorldPosYByXZ(curOperateItem.curFloor, itemGridPos[1], itemGridPos[3]) + m_furnitureExtendGridHeight
  local scaleZ = isHoriAngle and curOperateItem.data.staticData.Row or curOperateItem.data.staticData.Col
  local horiStartValue = itemGridPos[3] - (scaleZ - 1) * cellSize / 2
  local isOffsetCenter = math.fmod(isHoriAngle and curOperateItem.data.staticData.Col or curOperateItem.data.staticData.Row, 2) == 0
  local maxPos = itemGridPos[1] + self:CalSingleOffset(true, true, floorInfo.col, horiStartValue, itemGridPos[1], scaleZ, itemGridPos[2], isOffsetCenter) * cellSize
  local minPos = itemGridPos[1] + self:CalSingleOffset(true, false, floorInfo.col, horiStartValue, itemGridPos[1], scaleZ, itemGridPos[2], isOffsetCenter) * cellSize
  self:SetSingleItemExtentGrid(self.tabItemExtentGrid.horizontal, math.round((maxPos - minPos) / cellSize), scaleZ, (minPos + maxPos) / 2, worldPosY, itemGridPos[3])
  local scaleX = isHoriAngle and curOperateItem.data.staticData.Col or curOperateItem.data.staticData.Row
  horiStartValue = itemGridPos[1] - (scaleX - 1) * cellSize / 2
  isOffsetCenter = math.fmod(isHoriAngle and curOperateItem.data.staticData.Row or curOperateItem.data.staticData.Col, 2) == 0
  maxPos = itemGridPos[3] + self:CalSingleOffset(false, true, floorInfo.row, horiStartValue, itemGridPos[3], scaleX, itemGridPos[2], isOffsetCenter) * cellSize
  minPos = itemGridPos[3] + self:CalSingleOffset(false, false, floorInfo.row, horiStartValue, itemGridPos[3], scaleX, itemGridPos[2], isOffsetCenter) * cellSize
  self:SetSingleItemExtentGrid(self.tabItemExtentGrid.verticle, scaleX, math.round((maxPos - minPos) / cellSize), itemGridPos[1], worldPosY, (minPos + maxPos) / 2)
end

function HomeBuildingWorldGridControl:CalSingleOffset(isHorizontal, plus, maxValue, horiStartValue, vertStartValue, maxHoriNum, centerY, isOffsetCenter)
  local curOperateItem = self.container.curOperateItem
  if maxValue < 1 or maxHoriNum < 1 then
    return 0
  end
  local cellSize = self.container.CellSize
  local checkOffset, offsetSign = 0, plus and 1 or -1
  vertStartValue = vertStartValue + (isOffsetCenter and cellSize / 2 or 0) * offsetSign
  maxValue = maxValue + 1
  while checkOffset < maxValue do
    local curVertValue = vertStartValue + checkOffset * cellSize * offsetSign
    for i = 0, maxHoriNum - 1 do
      local curHoriValue = horiStartValue + i * cellSize
      local curX = isHorizontal and curVertValue or curHoriValue
      local curZ = isHorizontal and curHoriValue or curVertValue
      if math.abs(HomeManager.Me():GetWorldPosYByXZ(curOperateItem.curFloor, curX, curZ) - centerY) > 0.5 or not HomeManager.Me():IsCellAvaliableTypeByPos(curOperateItem.curFloor, curX, curZ) then
        if 0 < checkOffset then
          checkOffset = checkOffset + 0.5
        end
        return math.max(checkOffset - 1 + (isOffsetCenter and 0.5 or 0), 0) * offsetSign
      end
    end
    checkOffset = checkOffset + 1
  end
  if 0 < checkOffset then
    checkOffset = checkOffset + 0.5
  end
  return math.max(checkOffset - 1 + (isOffsetCenter and 0.5 or 0), 0) * offsetSign
end

function HomeBuildingWorldGridControl:SetSingleItemExtentGrid(tabExtentGrid, scaleX, scaleZ, worldPosX, worldPosY, worldPosZ)
  if not tabExtentGrid then
    return
  end
  if tabExtentGrid.scaleX ~= scaleX or tabExtentGrid.scaleZ ~= scaleZ then
    tabExtentGrid.transform.localScale = LuaGeometry.GetTempVector3(scaleX, scaleZ, 1)
    if 0 < scaleX and 0 < scaleZ then
      tabExtentGrid.material.mainTextureScale = LuaGeometry.GetTempVector2(scaleX, scaleZ)
    end
    tabExtentGrid.scaleX = scaleX
    tabExtentGrid.scaleZ = scaleZ
  end
  if 0 < scaleX and 0 < scaleZ then
    tabExtentGrid.transform.position = LuaGeometry.GetTempVector3(worldPosX, worldPosY, worldPosZ)
  end
end

function HomeBuildingWorldGridControl:GetPosAndShowBuildSignsByCells(floorIndex, right, wrong, onlyCalPos)
  local buildPos = HomeManager.Me():GetBuildPosByCells(floorIndex, right, wrong)
  if onlyCalPos then
    return buildPos
  end
  local i = 1
  local posX, posZ
  if right then
    for j = 1, #right do
      posX, posZ = HomeManager.Me():ConvertRowAndColToWorldPosition(floorIndex, right[j].row, right[j].col)
      if i > #self.tabUsingBuildSign then
        self.tabUsingBuildSign[i] = self:GetNewBuildSign()
      end
      self.tabUsingBuildSign[i].material:SetColor("_TintColor", m_color_green)
      self.tabUsingBuildSign[i].transform.position = LuaGeometry.GetTempVector3(posX, buildPos[2] + m_buildSignHeight, posZ)
      i = i + 1
    end
  end
  if wrong then
    for j = 1, #wrong do
      posX, posZ = HomeManager.Me():ConvertRowAndColToWorldPosition(floorIndex, wrong[j].row, wrong[j].col)
      if i > #self.tabUsingBuildSign then
        self.tabUsingBuildSign[i] = self:GetNewBuildSign()
      end
      self.tabUsingBuildSign[i].material:SetColor("_TintColor", m_color_red)
      self.tabUsingBuildSign[i].transform.position = LuaGeometry.GetTempVector3(posX, buildPos[2] + m_buildSignHeight, posZ)
      i = i + 1
    end
  end
  for j = i, #self.tabUsingBuildSign do
    self.tabUsingBuildSign[j].transform.parent = self.tsfBuildSignPool
    self.tabUsingBuildSign[#self.tabUsableBuildSign + 1] = self.tabUsingBuildSign[j]
    self.tabUsingBuildSign[j] = nil
  end
  buildPos[2] = buildPos[2] + HomeBuildingView.SelectHeight
  return buildPos
end

function HomeBuildingWorldGridControl:InitUsingBuildSignAsync(floorIndex, tabPosition, m_color, buildPosY, tabIndex, buildIndex, callBack)
  if tabPosition then
    if tabIndex <= #tabPosition then
      local posX, posZ = HomeManager.Me():ConvertRowAndColToWorldPosition(floorIndex, tabPosition[tabIndex].row, tabPosition[tabIndex].col)
      if buildIndex > #self.tabUsingBuildSign then
        self:GetNewBuildSign(function(tabSign)
          self.tabUsingBuildSign[buildIndex] = tabSign
          self.tabUsingBuildSign[buildIndex].material:SetColor("_TintColor", m_color)
          self.tabUsingBuildSign[buildIndex].transform.position = LuaGeometry.GetTempVector3(posX, buildPosY + m_buildSignHeight, posZ)
          buildIndex = buildIndex + 1
          tabIndex = tabIndex + 1
          self:InitUsingBuildSignAsync(floorIndex, tabPosition, m_color, buildPosY, tabIndex, buildIndex, callBack)
        end)
      end
    elseif callBack then
      if m_color == m_color_green then
        callBack()
      elseif m_color == m_color_red then
        callBack(buildIndex)
      end
    end
  end
end

function HomeBuildingWorldGridControl:GetNewBuildSign(callBack)
  if #self.tabUsableBuildSign > 0 then
    local tabSign = self.tabUsableBuildSign[#self.tabUsableBuildSign]
    tabSign.transform.parent = self.tabBuildSign.transform
    self.tabUsableBuildSign[#self.tabUsableBuildSign] = nil
    return tabSign
  end
  local objSign = Game.AssetManager_Furniture:CreateBuildSign(self.tabBuildSign.transform)
  return {
    material = objSign:GetComponent(Renderer).material,
    gameObject = objSign,
    transform = objSign.transform
  }
end

function HomeBuildingWorldGridControl:RecycleBuildSigns()
  for i = 1, #self.tabUsingBuildSign do
    self.tabUsingBuildSign[i].transform.parent = self.tsfBuildSignPool
    self.tabUsableBuildSign[#self.tabUsableBuildSign + 1] = self.tabUsingBuildSign[i]
    self.tabUsingBuildSign[i] = nil
  end
end

function HomeBuildingWorldGridControl:ShowBuildSigns(isShow)
  self.tabBuildSign.gameObject:SetActive(isShow ~= false)
end

function HomeBuildingWorldGridControl:OnEnter()
  HomeBuildingWorldGridControl.super.OnEnter(self)
  self:ShowWorldGrid(false)
  self.tabItemExtentGrid.gameObject:SetActive(false)
  self:InitView()
end

function HomeBuildingWorldGridControl:OnExit()
  HomeBuildingWorldGridControl.super.OnExit(self)
end
