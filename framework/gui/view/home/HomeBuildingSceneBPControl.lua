autoImport("NFurniture_BluePrint")
HomeBuildingSceneBPControl = class("HomeBuildingSceneBPControl", SubView)
local m_color_yellowBP = LuaColor(1, 1, 0, 1)
local m_color_blueBP = LuaColor(0, 0.19607843137254902, 1, 1)
HomeBuildingSceneBPControl.ShowBluePrint = "HomeBuildingSceneBPControl_ShowBluePrint"
HomeBuildingSceneBPControl.ExitBluePrint = "HomeBuildingSceneBPControl_ExitBluePrint"

function HomeBuildingSceneBPControl:Init()
  self.bpFurnitureMap = {}
  self.bpFinishNumMap = {}
  self.bpFurnitureOutlineMap = {}
  self.bpContentDatas = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeBuildingSceneBPControl:FindObjs()
  self.tsfFurnituresRoot = HomeManager.Me():GetFurnitureRootTransform()
  self.objFurnituresRoot = self.tsfFurnituresRoot.gameObject
  self.tsfBPFurnitureRoot = HomeManager.Me():FindOrCreateTransform("BPFurnitureRoot", self:FindGO("WorldRoot"))
  self.tsfBPFurnitureRoot.rotation = self.tsfFurnituresRoot.rotation
  self.objBuildUI = self:FindGO("BuildUI")
  self.objListItem = self:FindGO("ListItem", self.objBuildUI)
  self.objHideInBPMode = self:FindGO("HideInBluePrint", self.objBuildUI)
  self.objBtnShowBPOnly = self:FindGO("BtnShowBPOnly", self.objBuildUI)
  self.sprBtnShowBPOnly = self:FindComponent("Icon", UISprite, self.objBtnShowBPOnly)
  self.objBtnExitBP = self:FindGO("BtnExitBP", self.objBuildUI)
  self.btnApply = self:FindGO("BtnApply", self.objBuildUI)
end

function HomeBuildingSceneBPControl:AddEvts()
  self:AddClickEvent(self:FindGO("BtnBluePrint", self.objBuildUI), function()
    self:OpenBPSelectView()
  end)
  self:AddClickEvent(self.objBtnShowBPOnly, function()
    self:SwitchShowBPOnly()
  end)
  self:AddClickEvent(self.objBtnExitBP, function()
    self:ExitBPMode()
  end)
  self:AddClickEvent(self.btnApply, function()
    self:ApplyBluePrintMap()
  end)
end

function HomeBuildingSceneBPControl:AddViewEvts()
  self:AddListenEvt(HomeBuildingSceneBPControl.ShowBluePrint, self.ShowBluePrint)
  self:AddListenEvt(HomeBuildingSceneBPControl.ExitBluePrint, self.ExitBPMode)
  self:AddListenEvt(ServiceEvent.HomeCmdFurnitureUpdateHomeCmd, self.RefreshStatus)
end

function HomeBuildingSceneBPControl:InitView()
  self.objBtnShowBPOnly:SetActive(false)
  self.objBtnExitBP:SetActive(false)
  self.btnApply:SetActive(false)
end

function HomeBuildingSceneBPControl:OnEnter()
  HomeBuildingSceneBPControl.super.OnEnter(self)
  self:InitView()
end

function HomeBuildingSceneBPControl:OnExit()
  self:ClearBPFurnitures()
  self:ResetScene()
  self.selectBlueData = nil
  HomeBuildingSceneBPControl.super.OnExit(self)
end

function HomeBuildingSceneBPControl:ExitBPMode()
  if HomeManager.Me():IsBluePrintMode() then
    self:ExitBluePrint()
  end
end

function HomeBuildingSceneBPControl:GetCurrentContextLocalHouseType()
  local cur = HomeProxy.Instance:GetCurHouseData()
  if cur and cur.houseType == HomeCmd_pb.EHOUSETYPE_SNOW then
    return HomeProxy.HouseType.Snow
  end
  if cur and cur.houseType == HomeCmd_pb.EHOUSETYPE_PRIVATE then
    return HomeProxy.HouseType.Home
  end
end

function HomeBuildingSceneBPControl:OpenBPSelectView()
  if self.container.guideView and self.container.guideView:CheckOperateForbid() then
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeBluePrintView,
    viewdata = {
      houseType = self:GetCurrentContextLocalHouseType()
    }
  })
end

function HomeBuildingSceneBPControl:ShowBluePrint(note)
  local bluePrintData = note and note.body
  if not bluePrintData then
    LogUtility.Error("蓝图数据为空")
    return
  end
  local curMapData = HomeManager.Me():GetCurMapSData()
  if curMapData.id ~= bluePrintData.mapID then
    LogUtility.Error("此蓝图不可在当前地图使用", tostring(curMapData.id), tostring(bluePrintData.mapID))
    MsgManager.ShowMsgByID(43679)
    return
  end
  self:ClearBPFurnitures()
  if self.isShowBPOnly then
    self:SwitchShowBPOnly()
  end
  TableUtility.ArrayClear(self.bpContentDatas)
  TableUtility.TableClear(self.bpFinishNumMap)
  self.selectBlueData = bluePrintData
  self:CreateBP(bluePrintData, 1, #bluePrintData.furnitureBPStaticDatas, function()
    self:RefreshStatus(nil, true)
  end)
  local furnitureContentDatas = HomeProxy.Instance:GetDatasByType(HomeProxy.BuildType.Furniture, HomeProxy.FurnitureSpecialCatagory.All)
  local typeDatas, singleContentData
  for furnitureId, furnitureInfo in pairs(bluePrintData.furnitureInfoMap) do
    typeDatas = furnitureContentDatas and furnitureContentDatas[furnitureInfo.staticData.Type or HomeContentData.DefaultDataType]
    singleContentData = typeDatas and typeDatas[furnitureInfo.staticID]
    if singleContentData then
      singleContentData:RefreshStatus()
      self.bpContentDatas[#self.bpContentDatas + 1] = singleContentData
    else
      helplog("Cannot Find BP ContentData!")
      singleContentData = HomeContentData.new(furnitureInfo.staticData, HomeProxy.BuildType.Furniture)
      singleContentData:RefreshStatus()
      self.bpContentDatas[#self.bpContentDatas + 1] = singleContentData
    end
  end
  self.objHideInBPMode:SetActive(false)
  self.objBtnShowBPOnly:SetActive(true)
  self.objBtnExitBP:SetActive(true)
  self.btnApply:SetActive(true)
  self.isShowBPOnly = false
  self.container:ClearSelectContent()
  HomeManager.Me():SetBluePrintMode(bluePrintData)
  for id, renovationInfo in pairs(self.container.renovationOutlineMap) do
    HomeFurniturOutLine.Me():RemoveTarget(id)
  end
  TableUtility.TableClear(self.container.renovationOutlineMap)
  self.container.listHomeContentCells:ResetDatas(self.container:SortContentDatas(self.bpContentDatas))
end

function HomeBuildingSceneBPControl:CreateBP(bluePrintData, index, count, finishedCall)
  local singleBpFurniture = bluePrintData.furnitureBPStaticDatas[index]
  NFurniture_BluePrint.new(index, singleBpFurniture.FurnitureId, self.tsfBPFurnitureRoot, function(nFurniture_BluePrint)
    if not self.bpFurnitureMap then
      return
    end
    if nFurniture_BluePrint.index > #self.selectBlueData.furnitureBPStaticDatas then
      nFurniture_BluePrint:Destroy()
      return
    end
    local nFurniture_BluePrintTemp = bluePrintData.furnitureBPStaticDatas[nFurniture_BluePrint.index]
    if nFurniture_BluePrintTemp and nFurniture_BluePrintTemp.FurnitureId ~= nFurniture_BluePrint.staticID then
      nFurniture_BluePrint:Destroy()
      return
    end
    nFurniture_BluePrint:SetRotationAngle(singleBpFurniture.Angle)
    if nFurniture_BluePrint:GetRotationAngle() ~= singleBpFurniture.Angle then
      LogUtility.Warning(string.format("蓝图家具%s角度出错: %s", tostring(singleBpFurniture.FurnitureId), tostring(singleBpFurniture.Angle)))
    end
    if self.bpFurnitureMap[nFurniture_BluePrint.id] then
      self.bpFurnitureMap[nFurniture_BluePrint.id]:Destroy(true)
      LogUtility.Warning("Already have bp furniture with id: " .. nFurniture_BluePrint.id)
    end
    self.bpFurnitureMap[nFurniture_BluePrint.id] = nFurniture_BluePrint
    local result, right, wrong, placeRow, placeCol, isNearWall = HomeManager.Me():PlaceFurniture_T(nFurniture_BluePrint, singleBpFurniture.Floor, singleBpFurniture.Row, singleBpFurniture.Col, nFurniture_BluePrint:GetRotationAngle(), true)
    nFurniture_BluePrint.assetFurniture:ShowSideShadow(isNearWall == true)
    local pos = HomeManager.Me():GetBuildPosByCells(nFurniture_BluePrint.placeFloor, right, wrong)
    nFurniture_BluePrint.assetFurniture:SetPosition(pos)
    if nFurniture_BluePrint:IsHideWithWall() then
      nFurniture_BluePrint.assetFurniture:SetParent(HomeManager.Me():GetNearestWall(nFurniture_BluePrint.placeFloor, pos.x, pos.z).transform, true)
    end
    self:ApplyShowBPOnlyDisplay(nFurniture_BluePrint)
    if index < count then
      index = index + 1
      self:CreateBP(bluePrintData, index, count, finishedCall)
    elseif finishedCall then
      finishedCall()
    end
  end)
end

function HomeBuildingSceneBPControl:ApplyBluePrintMap()
  local blueprints = self.bpFurnitureMap
  if not blueprints or not next(blueprints) then
    return
  end
  MsgManager.ConfirmMsgByID(43682, function()
    self:DoApplyBluePrintMap()
  end)
end

function HomeBuildingSceneBPControl:DoApplyBluePrintMap()
  local blueprints = self.bpFurnitureMap
  if not blueprints or not next(blueprints) then
    return
  end
  local homeManager = HomeManager.Me()
  local buildingGrid = homeManager:GetCurrentBuildingGrid()
  if not buildingGrid then
    return
  end
  local satisfiedBPs = {}
  local usedSceneFurnitures = {}
  local furnitureMap = homeManager:GetFurnituresMap()
  for bpID, bpNFurniture in pairs(blueprints) do
    for fID, nFurniture in pairs(furnitureMap) do
      if not usedSceneFurnitures[fID] and nFurniture.staticID == bpNFurniture.staticID and nFurniture.placeFloor == bpNFurniture.placeFloor and nFurniture.placeRow == bpNFurniture.placeRow and nFurniture.placeCol == bpNFurniture.placeCol and nFurniture:GetRotationAngle() == bpNFurniture.placeAngle then
        satisfiedBPs[bpID] = true
        usedSceneFurnitures[fID] = true
        break
      end
    end
  end
  local bpBlockers = {}
  local potentialBlockers = {}
  for fID, nFurniture in pairs(furnitureMap) do
    if not usedSceneFurnitures[fID] then
      table.insert(potentialBlockers, nFurniture)
    end
  end
  local occupancyMap = {}
  for _, nFurniture in ipairs(potentialBlockers) do
    local floor, cells = buildingGrid:GetPlacedFurnitureCells(nFurniture.tag)
    if floor and cells then
      if not occupancyMap[floor] then
        occupancyMap[floor] = {}
      end
      local floorMap = occupancyMap[floor]
      for _, cell in ipairs(cells) do
        if not floorMap[cell.row] then
          floorMap[cell.row] = {}
        end
        floorMap[cell.row][cell.col] = nFurniture
      end
    end
  end
  local unsatisfiedBPs = {}
  for bpID, bpNFurniture in pairs(blueprints) do
    if not satisfiedBPs[bpID] then
      table.insert(unsatisfiedBPs, {id = bpID, data = bpNFurniture})
      local blockers = {}
      local templateData = buildingGrid.m_TemplateFurnitures[bpNFurniture.staticID]
      if templateData then
        local placeData = buildingGrid:CalculatePlacedFurnitureData(bpNFurniture.placeRow, bpNFurniture.placeCol, bpNFurniture.placeAngle, templateData)
        if placeData and placeData.cells and occupancyMap[bpNFurniture.placeFloor] then
          local floorMap = occupancyMap[bpNFurniture.placeFloor]
          local seenBlockers = {}
          for _, cell in ipairs(placeData.cells) do
            if floorMap[cell.row] then
              local blocker = floorMap[cell.row][cell.col]
              if blocker and not seenBlockers[blocker.id] then
                seenBlockers[blocker.id] = true
                table.insert(blockers, blocker)
              end
            end
          end
        end
      end
      bpBlockers[bpID] = blockers
    end
  end
  local bagPool = {}
  local bagItems = BagProxy.Instance.bagMap[BagProxy.BagType.Furniture].wholeTab:GetItems()
  for i = 1, #bagItems do
    local item = bagItems[i]
    local sid = item.staticData.id
    if not bagPool[sid] then
      bagPool[sid] = {}
    end
    for j = 1, item.num do
      table.insert(bagPool[sid], item.id)
    end
  end
  local recycledPool = {}
  local feasibleBPs = {}
  local usedResources = {}
  local recycledSet = {}
  while true do
    local progress = false
    for _, bpInfo in ipairs(unsatisfiedBPs) do
      local bpID = bpInfo.id
      if not feasibleBPs[bpID] then
        local bpData = bpInfo.data
        local sid = bpData.staticID
        local resource, mode
        local blockers = bpBlockers[bpID]
        if blockers then
          for _, blocker in ipairs(blockers) do
            if blocker.staticID == sid and not usedResources[blocker.id] then
              resource = blocker
              mode = "Edit"
              break
            end
          end
        end
        if not resource and recycledPool[sid] then
          for i, recycled in ipairs(recycledPool[sid]) do
            if not usedResources[recycled.id] then
              resource = recycled
              mode = "Edit"
              break
            end
          end
        end
        if not resource and bagPool[sid] and 0 < #bagPool[sid] then
          local guid = table.remove(bagPool[sid])
          resource = {id = guid}
          mode = "PutOn"
        end
        if resource then
          feasibleBPs[bpID] = {mode = mode, resource = resource}
          usedResources[resource.id] = true
          progress = true
          if blockers then
            for _, blocker in ipairs(blockers) do
              if not usedResources[blocker.id] and not recycledSet[blocker.id] then
                recycledSet[blocker.id] = true
                if not recycledPool[blocker.staticID] then
                  recycledPool[blocker.staticID] = {}
                end
                table.insert(recycledPool[blocker.staticID], blocker)
              end
            end
          end
        end
      end
    end
    if not progress then
      break
    end
  end
  local putOffList = {}
  local editList = {}
  local putOnList = {}
  for sid, list in pairs(recycledPool) do
    for _, furniture in ipairs(list) do
      if not usedResources[furniture.id] then
        local pb = self:CreateSceneItemFurniture(furniture.id)
        table.insert(putOffList, pb)
      end
    end
  end
  for bpID, alloc in pairs(feasibleBPs) do
    local bpData = self.bpFurnitureMap[bpID]
    local guid = alloc.resource.id
    local pb = self:CreateSceneItemFurniture(guid, bpData.placeFloor, bpData.placeRow, bpData.placeCol, bpData.placeAngle)
    if alloc.mode == "Edit" then
      table.insert(editList, pb)
    else
      table.insert(putOnList, pb)
    end
  end
  if 0 < #putOffList then
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTOFF, putOffList)
  end
  if 0 < #editList then
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_EDIT, editList)
  end
  if 0 < #putOnList then
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTON, putOnList)
  end
end

function HomeBuildingSceneBPControl:CreateSceneItemFurniture(guid, floor, row, col, angle)
  local tb
  if not NetConfig.PBC then
    tb = SceneItem_pb.Furniture()
    tb.guid = guid
    tb.row = row
    tb.col = col
    tb.angle = angle
    tb.floor = floor
  else
    tb = {}
    tb.guid = guid
    tb.row = row
    tb.col = col
    tb.angle = angle
    tb.floor = floor
  end
  return tb
end

function HomeBuildingSceneBPControl:SelectFurnitureContent(contentData)
  if not HomeManager.Me():IsBluePrintMode() then
    return
  end
  for i = #self.bpFurnitureOutlineMap, 1, -1 do
    if not self.bpFurnitureOutlineMap[i].isSelect and self.bpFurnitureOutlineMap[i]:GetInstanceID() then
      HomeFurniturOutLine.Me():RemoveTarget(self.bpFurnitureOutlineMap[i]:GetInstanceID())
    end
    self.bpFurnitureOutlineMap[i] = nil
  end
  if not contentData or contentData.type ~= HomeContentData.Type.Furniture then
    return
  end
  local curContentStaticID = contentData.staticID
  for id, bpNFurniture in pairs(self.bpFurnitureMap) do
    if bpNFurniture.staticID == curContentStaticID then
      HomeFurniturOutLine.Me():AddTarget(bpNFurniture.gameObject, bpNFurniture:GetInstanceID(), m_color_yellowBP)
      self.bpFurnitureOutlineMap[#self.bpFurnitureOutlineMap + 1] = bpNFurniture
    end
  end
  local furnitureMap = HomeManager.Me():GetFurnituresMap()
  for guid, nFurniture in pairs(furnitureMap) do
    if nFurniture.staticID == curContentStaticID then
      HomeFurniturOutLine.Me():AddTarget(nFurniture.gameObject, nFurniture:GetInstanceID(), m_color_blueBP)
      self.bpFurnitureOutlineMap[#self.bpFurnitureOutlineMap + 1] = nFurniture
    end
  end
  local furnitureMap = HomeManager.Me():GetClientFurnituresMap()
  for guid, nFurniture in pairs(furnitureMap) do
    if nFurniture.staticID == curContentStaticID then
      HomeFurniturOutLine.Me():AddTarget(nFurniture.gameObject, nFurniture:GetInstanceID(), m_color_blueBP)
      self.bpFurnitureOutlineMap[#self.bpFurnitureOutlineMap + 1] = nFurniture
    end
  end
end

function HomeBuildingSceneBPControl:TrySelectBPFurniture(id)
  local bpNFurniture = id and self.bpFurnitureMap[id]
  if not bpNFurniture then
    return
  end
  local staticID = bpNFurniture.staticID
  local datas = self.container.listHomeContentCells:GetDatas()
  local single, found
  for i = 1, #datas do
    single = datas[i]
    for j = 1, #single do
      if single[j].staticID == staticID then
        self.container.listHomeContentCells:SetStartPositionByIndex(i)
        found = true
        break
      end
    end
    if found then
      break
    end
  end
  local contentCells = self.container.listHomeContentCells:GetCells()
  for i = 1, #contentCells do
    if contentCells[i].isActive and contentCells[i].data.staticID == staticID then
      self.container:OnClickContentCell(contentCells[i])
      break
    end
  end
end

function HomeBuildingSceneBPControl:ApplyShowBPOnlyDisplay(bpNFurniture)
  if not self.isShowBPOnly then
    return
  end
  if bpNFurniture then
    if bpNFurniture.assetFurniture then
      bpNFurniture.assetFurniture:SetActive(true)
      bpNFurniture.assetFurniture:SetAlpha(1)
    end
    return
  end
  for id, bpNFurniture in pairs(self.bpFurnitureMap) do
    if bpNFurniture and bpNFurniture.assetFurniture then
      bpNFurniture.assetFurniture:SetActive(true)
      bpNFurniture.assetFurniture:SetAlpha(1)
    end
  end
end

function HomeBuildingSceneBPControl:RefreshStatus(note, refreshOnly)
  if not HomeManager.Me():IsBluePrintMode() then
    return
  end
  TableUtility.TableClear(self.bpFinishNumMap)
  local finished = true
  local staticID
  for id, bpNFurniture in pairs(self.bpFurnitureMap) do
    staticID = bpNFurniture.staticID
    if bpNFurniture:RefreshStatus() then
      if self.bpFinishNumMap[staticID] then
        self.bpFinishNumMap[staticID] = self.bpFinishNumMap[staticID] + 1
      else
        self.bpFinishNumMap[staticID] = 1
      end
    else
      finished = false
    end
  end
  if finished and not refreshOnly then
    MsgManager.ShowMsgByID(38008)
    self:ExitBluePrint()
  else
    HomeManager.Me():SetBluePrintFinishNumMap(self.bpFinishNumMap)
    local contentCells = self.container.listHomeContentCells:GetCells()
    for i = 1, #contentCells do
      if contentCells[i].isActive then
        contentCells[i]:RefreshBPStatus()
      end
    end
    self:ApplyShowBPOnlyDisplay()
  end
end

function HomeBuildingSceneBPControl:ClearBPFurnitures()
  for i = #self.bpFurnitureOutlineMap, 1, -1 do
    if not self.bpFurnitureOutlineMap[i].isSelect and self.bpFurnitureOutlineMap[i]:GetInstanceID() then
      HomeFurniturOutLine.Me():RemoveTarget(self.bpFurnitureOutlineMap[i]:GetInstanceID())
    end
    self.bpFurnitureOutlineMap[i] = nil
  end
  for id, bpNFurniture in pairs(self.bpFurnitureMap) do
    if bpNFurniture then
      bpNFurniture:Destroy(true)
    end
    self.bpFurnitureMap[id] = nil
  end
end

function HomeBuildingSceneBPControl:SwitchShowBPOnly()
  self.isShowBPOnly = not self.isShowBPOnly
  self.objListItem:SetActive(not self.isShowBPOnly)
  self.objFurnituresRoot:SetActive(not self.isShowBPOnly)
  self.sprBtnShowBPOnly.spriteName = self.isShowBPOnly and "com_icon_hide" or "com_icon_show"
  if self.isShowBPOnly then
    self:ApplyShowBPOnlyDisplay()
    for i = 1, #self.bpFurnitureOutlineMap do
      if not self.bpFurnitureOutlineMap[i].isSelect then
        HomeFurniturOutLine.Me():RemoveTarget(self.bpFurnitureOutlineMap[i]:GetInstanceID())
      end
    end
  else
    for id, bpNFurniture in pairs(self.bpFurnitureMap) do
      bpNFurniture.assetFurniture:SetActive(not bpNFurniture:IsPlacedSuccess())
      bpNFurniture.assetFurniture:SetAlpha(0.5)
    end
    for i = 1, #self.bpFurnitureOutlineMap do
      HomeFurniturOutLine.Me():AddTarget(self.bpFurnitureOutlineMap[i].gameObject, self.bpFurnitureOutlineMap[i]:GetInstanceID(), m_color_yellowBP)
    end
  end
end

function HomeBuildingSceneBPControl:ExitBluePrint()
  self:ClearBPFurnitures()
  self.objHideInBPMode:SetActive(true)
  self.objBtnShowBPOnly:SetActive(false)
  self.objBtnExitBP:SetActive(false)
  self.btnApply:SetActive(false)
  self.objListItem:SetActive(true)
  self.isShowBPOnly = false
  self:ResetScene()
  if self.container.curDataTypeCell then
    self.container:OnClickDataTypeCell(self.container.curDataTypeCell, true)
  else
    self.container:OnClickBtnEditFurniture()
  end
end

function HomeBuildingSceneBPControl:ResetScene()
  if not LuaGameObject.ObjectIsNull(self.objFurnituresRoot) then
    self.objFurnituresRoot:SetActive(true)
  end
  HomeManager.Me():SetBluePrintMode()
end
