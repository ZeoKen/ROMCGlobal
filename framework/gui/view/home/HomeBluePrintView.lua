autoImport("HomeBluePrintCell")
autoImport("PageSymbolCell")
HomeBluePrintView = class("HomeBluePrintView", BaseView)
HomeBluePrintView.ViewType = UIViewType.NormalLayer
HomeBluePrintView.BrotherView = HomeBuildingView
HomeBluePrintView.TexName = {
  bgUp = "home_blueprint_bg_paper2_upper",
  bgDown = "home_blueprint_bg_paper2_lower",
  bgLeft = "home_blueprint_bg_paper2_left",
  bgRight = "home_blueprint_bg_paper2_right"
}
local vec_arrowEulerOpen = LuaVector3(0, 0, 180)
local vec_arrowEulerClose = LuaVector3.Zero()
HomeBluePrintView.SortType = {
  Default = ZhString.Home_Default,
  Like = ZhString.Home_LikeLevel,
  Score = ZhString.Home_Score
}
HomeBluePrintView.CurSortType = HomeBluePrintView.SortType.Default

function HomeBluePrintView:Init()
  self.bpDatas = {}
  self.pageIndexDatas = {}
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeBluePrintView:InitUI()
  local l_objPopSort = self:FindGO("popSort")
  self.popSort = l_objPopSort:GetComponent(UIPopupList)
  self.tsfPopArrow = self:FindGO("Arrow", l_objPopSort).transform
  self.objPopSortSelect = self:FindGO("ItemTabsBgSelect", l_objPopSort)
  self.popSort:AddItem(HomeBluePrintView.SortType.Default)
  self.popSort:AddItem(HomeBluePrintView.SortType.Like)
  self.popSort:AddItem(HomeBluePrintView.SortType.Score)
  self.popSort.value = HomeBluePrintView.CurSortType
  self.objNoneTip = self:FindGO("NoneTip")
  self.listBluePrints = WrapListCtrl.new(self:FindGO("wrapBP"), HomeBluePrintCell, "HomeBluePrintCell", WrapListCtrl_Dir.Horizontal, 2, 267)
  self.listPageSymbols = UIGridListCtrl.new(self:FindComponent("gridPageSymbol", UIGrid), PageSymbolCell, "PageSymbolCell")
  self.itemSize = self.listBluePrints.wrap.itemSize
end

function HomeBluePrintView:AddEvts()
  self.listBluePrints:AddEventListener(MouseEvent.MouseClick, self.ClickBPCell, self)
  self.listBluePrints:AddEventListener(HomeBluePrintCell.ClickLike, self.ClickBPCellLike, self)
  EventDelegate.Add(self.popSort.onChange, function()
    self:UpdateBPInfos(true)
  end)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
end

function HomeBluePrintView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.HandlePrintUpdateHomeCmd)
end

function HomeBluePrintView:ReloadBPInfos()
  local showMapIDs = ReusableTable.CreateArray()
  if HomeManager.Me():IsInEditMode() then
    local curHouseData = HomeProxy.Instance:GetCurHouseData()
    showMapIDs[#showMapIDs + 1] = curHouseData and curHouseData.mapID
  else
    for k, v in pairs(HomeProxy.HouseType) do
      local myHouseData = HomeProxy.Instance:GetMyHouseData(v)
      if myHouseData and myHouseData.mapID then
        showMapIDs[#showMapIDs + 1] = myHouseData.mapID
      end
    end
  end
  TableUtility.TableClear(self.bpDatas)
  if Table_HomeOfficialBluePrint then
    for id, data in pairs(Table_HomeOfficialBluePrint) do
      if TableUtility.ArrayFindIndex(showMapIDs, data.MapID) > 0 then
        self.bpDatas[#self.bpDatas + 1] = data
      end
    end
  end
  ReusableTable.DestroyAndClearArray(showMapIDs)
  self.listBluePrints:ResetDatas(self.bpDatas)
  self.objNoneTip:SetActive(1 > #self.bpDatas)
  TableUtility.ArrayClear(self.pageIndexDatas)
  for i = 1, math.ceil(#self.bpDatas / 6) do
    self.pageIndexDatas[i] = i
  end
  self.listPageSymbols:ResetDatas(self.pageIndexDatas)
end

function HomeBluePrintView:UpdateBPInfos(keepPos)
  HomeBluePrintView.CurSortType = self.popSort.value
  if HomeBluePrintView.CurSortType == HomeBluePrintView.SortType.Default then
    table.sort(self.bpDatas, function(l, r)
      return l.id < r.id
    end)
  elseif HomeBluePrintView.CurSortType == HomeBluePrintView.SortType.Like then
    table.sort(self.bpDatas, function(l, r)
      local lLikeNum, rLikeNum = HomeProxy.Instance:GetBluePrintLikeNum(l.id), HomeProxy.Instance:GetBluePrintLikeNum(r.id)
      if lLikeNum == rLikeNum then
        return l.id < r.id
      end
      return lLikeNum > rLikeNum
    end)
  elseif HomeBluePrintView.CurSortType == HomeBluePrintView.SortType.Score then
    table.sort(self.bpDatas, function(l, r)
      if l.TotalScore == r.TotalScore then
        return l.id < r.id
      end
      return l.TotalScore > r.TotalScore
    end)
  end
  self.listBluePrints:ResetDatas(self.bpDatas, not keepPos)
end

function HomeBluePrintView:HandlePrintUpdateHomeCmd(note)
  local cells = self.listBluePrints:GetCells()
  for i = 1, #cells do
    if cells[i].isActive then
      cells[i]:RefreshLikeStatus()
    end
  end
  if not self.serverInited and HomeBluePrintView.CurSortType == HomeBluePrintView.SortType.Like then
    self:UpdateBPInfos(true)
  end
  self.serverInited = true
end

function HomeBluePrintView:ClickBPCell(cell)
  if not cell.bpData then
    return
  end
  if HomeManager.Me():IsInEditMode() then
    if cell.isUsing then
      MsgManager.ShowMsgByID(38007)
      return
    end
    if cell.bpData:CheckIsFinished() then
      MsgManager.ShowMsgByID(38009)
      return
    end
    local curMapData = HomeManager.Me():GetCurMapSData()
    if not curMapData or curMapData.id ~= cell.data.MapID then
      redlog("此蓝图不能在当前地图使用", tostring(curMapData and curMapData.id), tostring(cell.data.MapID))
      return
    end
    self:sendNotification(HomeBuildingSceneBPControl.ShowBluePrint, cell.bpData)
    self:CloseSelf()
  else
    self.keepBPCache = true
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HomeBPDetailView,
      viewdata = cell.bpData
    })
  end
end

function HomeBluePrintView:ClickBPCellLike(cell)
  if self.ltForbidClick then
    MsgManager.ShowMsgByID(49)
    return
  end
  local likeIDConfig = GameConfig.Home.BluePrintLikeID
  local realID = likeIDConfig and likeIDConfig[cell.data.id] or cell.data.id
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(cell.isLike and HomeCmd_pb.EPRINTACTION_UNPRAISE or HomeCmd_pb.EPRINTACTION_PRAISE, realID)
  self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.ltForbidClick = nil
  end, self)
end

function HomeBluePrintView:UpdatePage()
  if self.popSort.isOpen ~= self.isPopOpen then
    self.isPopOpen = self.popSort.isOpen
    self.objPopSortSelect:SetActive(self.isPopOpen == true)
    self.tsfPopArrow.localEulerAngles = self.isPopOpen and vec_arrowEulerOpen or vec_arrowEulerClose
  end
  if #self.pageIndexDatas < 1 then
    return
  end
  local index = math.ceil(self.listBluePrints.panel.clipOffset.x / self.itemSize / 3)
  local cells = self.listPageSymbols:GetCells()
  cells[math.clamp(index, 1, #cells)]:Select()
end

function HomeBluePrintView:OnEnter()
  HomeBluePrintView.super.OnEnter(self)
  self.serverInited = false
  PictureManager.Instance:SetHome(HomeBluePrintView.TexName.bgUp, self:FindComponent("texUp", UITexture))
  PictureManager.Instance:SetHome(HomeBluePrintView.TexName.bgDown, self:FindComponent("texDown", UITexture))
  PictureManager.Instance:SetHome(HomeBluePrintView.TexName.bgLeft, self:FindComponent("texLeft", UITexture))
  PictureManager.Instance:SetHome(HomeBluePrintView.TexName.bgRight, self:FindComponent("texRight", UITexture))
  self:ReloadBPInfos()
  TimeTickManager.Me():CreateTick(0, 100, self.UpdatePage, self, 1)
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_QUERY)
end

function HomeBluePrintView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  for k, v in pairs(HomeBluePrintView.TexName) do
    PictureManager.Instance:UnLoadHome(v)
  end
  PictureManager.Instance:UnLoadHomeBluePrint()
  if not self.keepBPCache then
    HomeProxy.Instance:ClearBluePrintsInfoCache()
    HomeProxy.Instance:ClearBPLikeInfo()
    HomeBluePrintView.CurSortType = HomeBluePrintView.SortType.Default
  end
  self.keepBPCache = false
  if self.ltForbidClick then
    self.ltForbidClick:Destroy()
    self.ltForbidClick = nil
  end
  HomeBluePrintView.super.OnExit(self)
end

function HomeBluePrintView:OnDestroy()
  self.listBluePrints:Destroy()
  self.listPageSymbols:Destroy()
  HomeBluePrintView.super.OnDestroy(self)
end
