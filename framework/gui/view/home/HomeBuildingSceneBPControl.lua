autoImport("NFurniture_BluePrint")
HomeBuildingSceneBPControl = class("HomeBuildingSceneBPControl", SubView)
local m_color_yellowBP = LuaColor(1, 1, 0, 1)
local m_color_blueBP = LuaColor(0, 0.19607843137254902, 1, 1)
HomeBuildingSceneBPControl.ShowBluePrint = "HomeBuildingSceneBPControl_ShowBluePrint"

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
end

function HomeBuildingSceneBPControl:AddViewEvts()
  self:AddListenEvt(HomeBuildingSceneBPControl.ShowBluePrint, self.ShowBluePrint)
  self:AddListenEvt(ServiceEvent.HomeCmdFurnitureUpdateHomeCmd, self.RefreshStatus)
end

function HomeBuildingSceneBPControl:InitView()
  self.objBtnShowBPOnly:SetActive(false)
  self.objBtnExitBP:SetActive(false)
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

function HomeBuildingSceneBPControl:OpenBPSelectView()
  if self.container.guideView and self.container.guideView:CheckOperateForbid() then
    return
  end
  local curMapData = HomeManager.Me():GetCurMapSData()
  local curMapID = curMapData and curMapData.id
  local found = false
  if Table_HomeOfficialBluePrint then
    for id, data in pairs(Table_HomeOfficialBluePrint) do
      if curMapID == data.MapID then
        found = true
        break
      end
    end
  end
  if not found then
    MsgManager.ShowMsgByID(40558)
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeBluePrintView
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
    self:RefreshStatus()
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
    if index < count then
      index = index + 1
      self:CreateBP(bluePrintData, index, count, finishedCall)
    elseif finishedCall then
      finishedCall()
    end
  end)
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

function HomeBuildingSceneBPControl:RefreshStatus()
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
  if finished then
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
    for id, bpNFurniture in pairs(self.bpFurnitureMap) do
      bpNFurniture.assetFurniture:SetActive(true)
      bpNFurniture.assetFurniture:SetAlpha(1)
    end
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
