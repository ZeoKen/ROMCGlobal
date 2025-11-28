Astrolabe_Handle_PointType = {
  Reset = 1,
  Active_NotCan = 2,
  Active_Can = 3,
  Simulate_Save = 4,
  Simulate_New = 5
}
Astrolabe_Plate_BgMap = {
  [1] = "xingpan_ditu02",
  [2] = "xingpan_ditu03",
  [3] = "xingpan_ditu04",
  [4] = "xingpan_ditu05"
}
if not AstrolabeCellPool then
  autoImport("AstrolabeCellPool")
  AstrolabeCellPool.new()
end
Astrolabe_PlateZoom_Param = 0.5
AstrolabeView = class("AstrolabeView", BaseView)
AstrolabeView.ViewType = UIViewType.NormalLayer
AstrolabeView.HandleSate = {
  None = 1,
  Active = 2,
  Reset = 3,
  Simulate = 4
}
local _AstrolabeProxy
local tempVector3 = LuaVector3.Zero()

function AstrolabeView:Init()
  autoImport("FunctionAstrolabe")
  autoImport("AstrolabeView_MiniMap")
  autoImport("AstrolabeView_Active")
  autoImport("Astrolabe_ScreenView")
  autoImport("Astrolabe_PlateCell")
  autoImport("CostInfoCell")
  if not _AstrolabeProxy then
    _AstrolabeProxy = AstrolabeProxy.Instance
  end
  self:InitView()
  self:InitMiniMap()
  self:InitActive()
end

function AstrolabeView:InitView()
  self.maskPointsDirty = true
  self.cache_PointState_GuidMap = {}
  self:MapEvent()
  self.root = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIRoot)
  local coinsGrid = self:FindComponent("TopCoins", UIGrid)
  self.coinsCtl = UIGridListCtrl.new(coinsGrid, CostInfoCell, "CostInfoCell")
  self.coinsCtl:AddEventListener(MouseEvent.MouseClick, self.clickCostCell, self)
  self.sliverNum = self:FindComponent("Label", UILabel, self:FindGO("Sliver"))
  self.contributeNum = self:FindComponent("Label", UILabel, self:FindGO("Contribute"))
  self.collider = self:FindGO("Collider")
  self.mapBg = self:FindGO("MapBg")
  self.mapBord = self:FindGO("MapBord")
  self.centerTarget = self:FindGO("CenterTarget", self.mapBord)
  self.effectContainer = self:FindGO("EffectContainer")
  self.platePool = {}
  self.plateCellMap = {}
  self.plateBgMap = {}
  self.outerlineMap = {}
  self.animlines = {}
  local scrollView = self:FindComponent("ContentScrollView", UIScrollViewEx)
  self.screenView = Astrolabe_ScreenView.new(scrollView, self.mapBord, 9, 9)
  self.screenView:AddEventListener(Astrolabe_ScreenView_Event.RefreshDraw, self.RefreshDraw, self)
  self.scrollBound = self:FindComponent("ScrollBound", UIWidget)
  local attriInfoButton = self:FindGO("AttriIInfoButton")
  self.attriInfo_Symbol = self:FindComponent("Symbol", UISprite, attriInfoButton)
  self.attriInfo_Symbol.spriteName = "xingpan_icon_HIDDEN"
  self:AddClickEvent(attriInfoButton, function()
    self:ActiveAttriInfo(not self.isAttriInfoActive)
  end)
  self:ActiveAttriInfo(false)
  self.selectEffect = self:FindGO("SelectEffect")
  local customTouchUpCall = self.selectEffect:GetComponent(CustomTouchUpCall)
  
  function customTouchUpCall.call(go)
    if self.__destroyed then
      return
    end
    self:CancelChoosePoint()
  end
  
  function customTouchUpCall.check()
    if self.__destroyed then
      return false
    end
    if self.waitCancelChooseOnect == true then
      self.waitCancelChooseOnect = false
      return true
    end
    local click = UICamera.selectedObject
    if click then
      for _, plateCell in pairs(self.plateCellMap) do
        for _, pointCell in pairs(plateCell.pointMap) do
          if pointCell:IsClickMe(click) then
            return true
          end
        end
      end
      if click == self.activeButtonGO then
        return true
      end
    end
    return false
  end
  
  self.playingAnim = false
  self.frontPanel = self:FindGO("FrontPanel")
  self.getPathContainer = self:FindGO("GetPathContainer", self.frontPanel)
end

function AstrolabeView:InitPlateDatas()
  self.screenView:InitPlateDatas(self.curBordData:GetPlateMap())
  self.screenView:InitBgDatas(self.curBordData:GetPlateBgDatas())
  self.screenView:RefreshDraw()
  self:UpdateScrollBound()
end

function AstrolabeView:GetNowLocalCenter()
  return self.screenView.localCenter
end

function AstrolabeView:GetAstrolabeMaskMap()
  if not self.maskPointsDirty then
    return self.maskPointsMap
  end
  self.maskPointsDirty = false
  if self.maskPointsMap == nil then
    self.maskPointsMap = {}
  else
    TableUtility.TableClear(self.maskPointsMap)
  end
  for id, state in pairs(self.savePointsMap) do
    self.maskPointsMap[id] = state
  end
  for id, state in pairs(self.handlePointsMap) do
    self.maskPointsMap[id] = state
  end
  return self.maskPointsMap
end

function AstrolabeView:RedrawHandlePoints()
  local maskPointsMap = self:GetAstrolabeMaskMap()
  for _, plateCell in pairs(self.plateCellMap) do
    plateCell:SetMaskInfo(maskPointsMap)
  end
  local p1_id, p2_id, p1_mtype, p2_mtype
  for _, lineCell in pairs(self.outerlineMap) do
    p1_id, p2_id = lineCell.point1.guid, lineCell.point2.guid
    p1_mtype, p2_mtype = maskPointsMap[p1_id], maskPointsMap[p2_id]
    if p1_mtype and p2_mtype then
      lineCell:SetMaskType(math.min(p1_mtype, p2_mtype))
    else
      lineCell:SetMaskType(nil)
    end
  end
  self.screenView.mPanel:SetDirty()
end

function AstrolabeView:ActiveAttriInfo(active)
  if active then
    self.attriInfo_Symbol.spriteName = "xingpan_icon_property"
  else
    self.attriInfo_Symbol.spriteName = "xingpan_icon_HIDDEN"
  end
  for key, plateCell in pairs(self.plateCellMap) do
    plateCell:ActiveAttriInfo(active)
  end
  self.isAttriInfoActive = active
end

function AstrolabeView:clickCostCell(cellCtrl)
  local costID = cellCtrl.id
  if costID then
    local lpos = cellCtrl.gameObject.transform.position
    LuaVector3.Better_Set(tempVector3, lpos[1], lpos[2] - 30, 0)
    self.getPathContainer.transform.position = tempVector3
    self:ShowGetPathOfCost(costID, self.getPathContainer)
  end
end

function AstrolabeView:ShowGetPathOfCost(itemID, parent)
  if self.bdt then
    self.bdt:OnExit()
  elseif itemID then
    self.bdt = GainWayTip.new(parent)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(itemID)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function AstrolabeView:GetPathCloseCall()
  self.bdt = nil
end

function AstrolabeView:GetPolateCell_FromPool()
  local plateCell = table.remove(self.platePool, 1)
  if plateCell == nil then
    local obj = Game.AssetManager_UI:CreateAstrolabeAsset(ResourcePathHelper.UICell("Astrolabe_PlateCell"), self.mapBord)
    plateCell = Astrolabe_PlateCell.new(obj)
    plateCell:Hide()
    plateCell:AddEventListener(Astrolabe_PlateCell_Event.ClickPoint, self.ClickPoint, self)
  end
  plateCell:OnCreate()
  return plateCell
end

function AstrolabeView:ClickPoint(params)
  local pointCell = params[2]
  local pointData = pointCell.data
  if pointData ~= self.choosePointData then
    self.choosePointData = pointData
    self:PlayUISound(AudioMap.UI.SelectRune)
    self.selectEffect.gameObject:SetActive(true)
    self.selectEffect.transform.localPosition = LuaGeometry.GetTempVector3(pointData:GetWorldPos_XYZ())
    TipManager.CloseTip()
    if pointData.guid ~= Astrolabe_Origin_PointID then
      local bg = pointCell.bg
      local is_recommend = (not self.searchPoints or #self.searchPoints == 0) and 0 < TableUtility.ArrayFindIndex(self.curBordData:GetAllRecommendPoints(), pointData)
      local tip = TipManager.Instance:ShowAstrobeTip({pointData, is_recommend}, bg, NGUIUtil.AnchorSide.Left)
      if tip then
        local tip_width, tip_heght = tip:GetSize()
        local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, bg.gameObject.transform, Space.World)
        local anchorSide, offset_x
        if 0 < x then
          anchorSide = NGUIUtil.AnchorSide.Left
          offset_x = -tip_width / 2
        else
          anchorSide = NGUIUtil.AnchorSide.Right
          offset_x = tip_width / 2
        end
        if self.islarge == false then
          offset_x = offset_x / Astrolabe_PlateZoom_Param
        end
        tip:SetPos(NGUIUtil.GetAnchorPoint(nil, bg, anchorSide, {offset_x, 0}))
        TipsView.Me():ConstrainCurrentTip()
        tip:SetCheckClick(self:TipClickCheck())
      end
    end
  end
  if self.isPreview then
    return
  end
  if self.FromProfessionInfoViewMP then
    return
  end
  self:ClickPoint_Active(pointData)
end

function AstrolabeView:TipClickCheck()
  if self.tipCheck ~= nil then
    return self.tipCheck, self.plateCellMap
  end
  
  function self.tipCheck(plateCellMap)
    local click = UICamera.selectedObject
    if click == nil then
      return false
    end
    for _, plateCell in pairs(plateCellMap) do
      for _, pointCell in pairs(plateCell.pointMap) do
        if pointCell.data and pointCell.data.guid == Astrolabe_Origin_PointID then
          return false
        end
        if pointCell:IsClickMe(click) then
          return true
        end
      end
    end
  end
  
  return self.tipCheck, self.plateCellMap
end

function AstrolabeView:AddPlateCell_ToPool(plateCell)
  if plateCell then
    plateCell:OnDestroy()
    self.platePool[#self.platePool + 1] = plateCell
  end
end

function AstrolabeView:RefreshDraw(param)
  local mem = collectgarbage("count")
  local time = os.clock()
  local drawPlateMap = param[1]
  for id, plateCell in pairs(self.plateCellMap) do
    if drawPlateMap[id] == nil then
      self:AddPlateCell_ToPool(plateCell)
      self.plateCellMap[id] = nil
    end
  end
  local maskMap = self:GetAstrolabeMaskMap()
  local cacheStateMap = self.inSaveMode and self.inSaveModePriStateMap or self.cache_PointState_GuidMap
  local plateCell
  for id, plateData in pairs(drawPlateMap) do
    plateCell = self.plateCellMap[id]
    if plateCell == nil then
      plateCell = self:GetPolateCell_FromPool()
      self.plateCellMap[id] = plateCell
    end
    plateCell:SetData(plateData, cacheStateMap, self.curBordData)
    plateCell:ActiveAttriInfo(self.isAttriInfoActive == true)
    plateCell:SetMaskInfo(maskMap)
  end
  self:RedrawPlateBg(param[2])
  self:RedrawOuterLine()
  self:RefreshMiniMap()
  helplog(string.format("AstrolabeView RefreshDraw 2: mem:%s time:%s", collectgarbage("count") - mem, os.clock() - time))
end

local Astrolabe_BgPath = ResourcePathHelper.UICell("Astrolabe_bg")

function AstrolabeView.DeleteBg(bg)
  bg.gameObject:SetActive(false)
  Game.GOLuaPoolManager:AddToAstrolabePool(Astrolabe_BgPath, bg.gameObject)
end

function AstrolabeView:ClearBgs()
  TableUtility.TableClearByDeleter(self.plateBgMap, AstrolabeView.DeleteBg)
end

function AstrolabeView:RedrawPlateBg(drawBgMap)
  for cid, bg in pairs(self.plateBgMap) do
    if drawBgMap[cid] == nil then
      AstrolabeView.DeleteBg(bg)
      self.plateBgMap[cid] = nil
    end
  end
  for cid, bgData in pairs(drawBgMap) do
    local bg = self.plateBgMap[cid]
    if Slua.IsNull(bg) then
      bg = Game.AssetManager_UI:CreateAstrolabeAsset(Astrolabe_BgPath, self.mapBord)
      bg.name = "Bg" .. cid
      bg.gameObject:SetActive(true)
      bg.transform.localScale = LuaGeometry.Const_V3_one
      bg = bg:GetComponent(UISprite)
      self.plateBgMap[cid] = bg
    end
    local iconIndex = math.floor(cid / 10000) + 1
    local sName = Astrolabe_Plate_BgMap[iconIndex] or Astrolabe_Plate_BgMap[0]
    if sName then
      bg.spriteName = sName
      bg:MakePixelPerfect()
    end
    local tempV3 = LuaGeometry.GetTempVector3()
    tempV3:Set(bgData[1], bgData[2], bgData[3])
    bg.transform.localPosition = tempV3
    if bgData[4] then
      tempV3:Set(bgData[4], bgData[5], bgData[6])
    else
      tempV3:Set(0, 0, 0)
    end
    bg.transform.localEulerAngles = tempV3
    if bgData[7] then
      tempV3:Set(bgData[7], bgData[8], bgData[9])
      bg.transform.localScale = tempV3
    else
      bg.transform.localScale = LuaGeometry.Const_V3_one
    end
  end
end

function AstrolabeView.DeleteLine(lineCell)
  AstrolabeCellPool.Instance:AddLineCellToPool(lineCell)
end

function AstrolabeView:ClearLines()
  TableUtility.TableClearByDeleter(self.outerlineMap, AstrolabeView.DeleteLine)
end

function AstrolabeView:RedrawOuterLine()
  self:ClearLines()
  local bordData = self.curBordData
  local plateMap = bordData:GetPlateMap()
  local plateData, outPlateData, pointMap, outerConnect, outerPointData
  for plateid, _ in pairs(self.plateCellMap) do
    plateData = plateMap[plateid]
    if plateData:IsUnlock() then
      pointMap = plateData:GetPointMap()
      for _, pointData in pairs(pointMap) do
        outerConnect = pointData:GetOuterConnect()
        if outerConnect then
          for _, outerid in pairs(outerConnect) do
            outerPointData = bordData:GetPointByGuid(outerid)
            outerid = math.floor(outerid / 10000)
            outPlateData = plateMap[outerid]
            if outPlateData:IsUnlock() then
              self:DrawOuterLineByPoint(pointData, outerPointData)
            end
          end
        end
      end
    end
  end
end

function AstrolabeView:GetOuterLine(point1, point2)
  local lpoint, bpoint
  if point1.guid < point2.guid then
    lpoint = point1
    bpoint = point2
  else
    lpoint = point2
    bpoint = point1
  end
  local cid = lpoint.guid .. "_" .. bpoint.guid
  local lineCell = self.outerlineMap[cid]
  if lineCell == nil then
    lineCell = AstrolabeCellPool.Instance:GetLineCellFromPool(self.mapBord)
    local x1, y1, z1 = lpoint:GetWorldPos_XYZ()
    local x2, y2, z2 = bpoint:GetWorldPos_XYZ()
    lineCell:ReSetPos(x1, y1, z1, x2, y2, z2)
    self.outerlineMap[cid] = lineCell
  end
  return lineCell
end

function AstrolabeView:DrawOuterLineByPoint(point1, point2)
  if point1 == nil or point2 == nil then
    return
  end
  local lineCell = self:GetOuterLine(point1, point2)
  local cacheStateMap = self.inSaveMode and self.inSaveModePriStateMap or self.cache_PointState_GuidMap
  lineCell:SetData(point1, point2, cacheStateMap)
  local maskPointsMap = self:GetAstrolabeMaskMap()
  local p1_mtype, p2_mtype = maskPointsMap[point1.guid], maskPointsMap[point2.guid]
  if p1_mtype and p2_mtype then
    lineCell:SetMaskType(math.min(p1_mtype, p2_mtype))
  else
    lineCell:RemoveMask()
  end
end

function AstrolabeView:UpdateScrollBound()
  local activePlates = self.curBordData:GetPlateMap()
  local min_x, max_x, min_y, max_y = 0, 0, 0, 0
  for pid, pdata in pairs(activePlates) do
    if pdata:IsUnlock() then
      min_x = math.min(min_x, pdata.min_x)
      min_y = math.min(min_y, pdata.min_y)
      max_x = math.max(max_x, pdata.max_x)
      max_y = math.max(max_y, pdata.max_y)
    end
  end
  self.scrollBound.transform.localPosition = LuaGeometry.GetTempVector3((min_x + max_x) * 0.5, (min_y + max_y) * 0.5)
  self.scrollBound.width = max_x - min_x
  self.scrollBound.height = max_y - min_y
end

function AstrolabeView:UpdateCoins()
  local showCoins = GameConfig.Astrolabe.ShowCostInfo
  self.coinsCtl:ResetDatas(showCoins)
end

function AstrolabeView:MapEvent()
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.HandleProfessionChange)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(MyselfEvent.ContributeChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins)
  self:AddListenEvt(AstrolabeEvent.TipClose, self.HandleTipClose)
end

function AstrolabeView:HandleProfessionChange(note)
  self:CloseSelf()
end

function AstrolabeView:HandleTipClose(note)
end

function AstrolabeView:QueueShowMsg(id, param, time)
  MsgManager.ShowMsgByIDTable(id, param)
end

function AstrolabeView:_QueueShowMsg()
  if #self.msgWaitQueue > 0 then
    self.showingMsg = true
    local msgData = table.remove(self.msgWaitQueue, 1)
    MsgManager.ShowMsgByIDTable(msgData[1], msgData[2])
    self:CancelShowMsg()
    local waittime = msgData[3] or 1
    self.showMsglt = TimeTickManager.Me():CreateOnceDelayTick(waittime * 1000, function(owner, deltaTime)
      self.showMsglt = nil
      self:_QueueShowMsg()
    end, self)
  else
    self.showingMsg = false
  end
end

function AstrolabeView:CancelShowMsg()
  if self.showMsglt then
    self.showMsglt:Destroy()
    self.showMsglt = nil
  end
  self.showingMsg = false
end

function AstrolabeView:CancelHandleAnims()
  if self.animlt then
    self.animlt:Destroy()
    self.animlt = nil
  end
end

function AstrolabeView:PlayHandleAnims(pointDatas, effectName, endCall, endCallParam)
  for i = 1, #pointDatas do
    local plateid = pointDatas[i].plateid
    if plateid and self.plateCellMap[plateid] then
      self:PlayLineRuneEffect(pointDatas[i], effectName)
    end
  end
  self:CancelHandleAnims()
  self.animlt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:HandleAnimEnd(endCall, endCallParam)
  end, self)
end

function AstrolabeView:HandleAnimEnd(endCall, endCallParam)
  if endCall then
    endCall(endCallParam)
  end
  self.animlt = nil
end

function AstrolabeView:PlayLineRuneEffect(pointData, effectName)
  local pos = {
    pointData:GetWorldPos_XYZ()
  }
  self:PlayUIEffect(effectName, self.effectContainer, true, AstrolabeView.LineRuneHandle, pos)
end

function AstrolabeView.LineRuneHandle(effectHandle, pos)
  effectHandle.transform.localPosition = LuaGeometry.GetTempVector3(pos[1], pos[2], pos[3])
end

function AstrolabeView:CancelChoosePoint()
  if self.handleState ~= AstrolabeView.HandleSate.None then
    return
  end
  self.handleState = AstrolabeView.HandleSate.None
  TipManager.CloseTip()
  self.choosePointData = nil
  self.selectEffect.gameObject:SetActive(false)
  self:HideActiveBord()
end

function AstrolabeView:OnEnter()
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  AstrolabeView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  local saveInfoData
  if viewdata and viewdata.FromProfessionInfoViewMP ~= true then
    if viewdata.isFromMP then
      ROLogger.Log("AstrolabeView 1")
      saveInfoData = viewdata.saveInfoData
    elseif viewdata.storageId then
      ROLogger.Log("AstrolabeView 2")
      saveInfoData = SaveInfoProxy.Instance:GetUsersaveData(viewdata.storageId, SaveInfoEnum.Record)
    elseif viewdata.saveId then
      ROLogger.Log("AstrolabeView 3")
      saveInfoData = SaveInfoProxy.Instance:GetUsersaveData(viewdata.saveId, SaveInfoEnum.Branch)
    end
  end
  self.isPreview = saveInfoData ~= nil
  if viewdata and viewdata.FromProfessionInfoViewMP == true then
    self.FromProfessionInfoViewMP = true
  else
    self.FromProfessionInfoViewMP = nil
  end
  if self.isPreview then
    self.curBordData = _AstrolabeProxy:GetBordData_BySaveInfo(saveInfoData, viewdata.saveId ~= nil)
  else
    self.curBordData = _AstrolabeProxy:GetCurBordData()
    self.curBordData:CheckNeed_DoServer_InitPlate()
  end
  FunctionAstrolabe.SetBordData(self.curBordData)
  self:InitPlateDatas()
  FunctionBGMCmd.Me():PlayUIBgm("AtharStone", 0)
  local oriPoint = self.curBordData:GetPointByGuid(Astrolabe_Origin_PointID)
  self:CenterOnLocalPos(oriPoint:GetWorldPos_XYZ())
  self:UpdateCoins()
  Game.TransformFollowManager:RegisterFollowPos(self.mapBg.transform, self.mapBord.transform, LuaGeometry.GetTempVector3(), nil, nil)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(false)
  self:UpdateActiveInfo()
  self:OnEnter_Active()
end

function AstrolabeView:CenterOnLocalPos(x, y, z)
  self.screenView:CenterOnLocalPos(x, y, z)
end

function AstrolabeView:ZoomScrollView(endScale, time, onfinish)
  self.screenView:ZoomScrollView(endScale, time, onfinish)
end

function AstrolabeView:OnExit()
  AstrolabeView.super.OnExit(self)
  FunctionBGMCmd.Me():StopUIBgm()
  self:ClearBgs()
  self:ClearLines()
  AstrolabeCellPool.Instance:ClearPointCellPool()
  AstrolabeCellPool.Instance:ClearLineCellPool()
  TableUtility.TableClear(self.cache_PointState_GuidMap)
  self:CancelHandleAnims()
  self:CancelShowMsg()
  self.curBordData:ClearRecommendPointsCache()
  self.curBordData:ClearTarjanCache()
  FunctionAstrolabe.ClearCache()
  FunctionAstrolabe.ReSetBordData()
  UIUtil.ClearFloatMiddleBottom()
  Game.TransformFollowManager:UnregisterFollow(self.mapBg.transform)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(true)
  self:OnExit_Active()
  ResourceManager.Instance:GC()
end
