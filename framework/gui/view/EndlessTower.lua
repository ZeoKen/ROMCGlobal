autoImport("EndlessTowerCell")
autoImport("EndlessTowermemberCell")
EndlessTower = class("EndlessTower", ContainerView)
EndlessTower.ViewType = UIViewType.PopUpLayer

function EndlessTower:OnEnter()
  EndlessTower.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local npcData = viewdata.npcdata
    if npcData then
      self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
    end
  else
    self:CameraRotateToMe()
  end
end

function EndlessTower:OnExit()
  self:CameraReset()
  FunctionCameraEffect.Me():End(self.cft)
  self.cft = nil
  TimeTickManager.Me():ClearTick(self)
  EndlessTower.super.OnExit(self)
end

function EndlessTower:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitItemList()
  self:InitShow()
end

function EndlessTower:FindObjs()
  self.itemGrid = self:FindGO("contentGrid"):GetComponent(UIGrid)
  self.ChooseSymbolGo = self:FindGO("ChooseSymbol")
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.springPanel = self.ItemScrollView:GetComponent(SpringPanel)
  self.centerOnChild = self.ItemScrollView:GetComponent(MyUICenterOnChild)
  self.cachedPanel = self.ItemScrollView:GetComponent(UIPanel)
  self.refreshtime = self:FindGO("Refreshtime"):GetComponent(UILabel)
end

function EndlessTower:AddEvts()
  function self.ItemScrollView.onDragFinished()
    if self.curCell then
      local pCorners = self.cachedPanel.worldCorners
      
      local centerCorner = (pCorners[1] + pCorners[3]) * 0.5
      centerCorner = self.ItemScrollView.transform:InverseTransformPoint(centerCorner)
      local curCellPos = self.curCell.gameObject.transform.localPosition
      local offset = centerCorner.y - curCellPos.y
      if 0 < offset then
        self:ScrollTower()
      end
    else
      self:ScrollTower()
    end
  end
end

function EndlessTower:AddViewEvts()
  self:AddListenEvt(ServiceEvent.InfiniteTowerTowerInfoCmd, self.RecvTowerInfoCmd)
end

function EndlessTower:InitItemList()
  self.itemList = UIGridListCtrl.new(self.itemGrid, EndlessTowerCell, "EndlessTowerCell")
  self.itemList:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function EndlessTower:InitShow()
  self.ItemScrollView.contentPivot = 6
  local offset = 3
  local activeH = Game.GameObjectUtil:GetUIActiveHeight(self.gameObject)
  offset = math.ceil(offset * activeH / 720)
  self.maxOffsetIndex = EndlessTowerProxy.Instance.maxlayer - offset + 1
  self.minOffsetIndex = offset
  self.selectCellData = EndlessTowerProxy.Instance:GetNextLayer()
  self:UpdateTowerInfo()
  self:SetSelectState()
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:ScrollTower()
  end, self, 101)
  self:CheckActivityText()
  if EndlessTowerProxy.Instance.refreshtime then
    self.refreshtime.gameObject:SetActive(true)
    TimeTickManager.Me():CreateTick(0, 60000, self.UpdateRefreshtime, self, 102)
  else
    self.refreshtime.gameObject:SetActive(false)
  end
end

local concatTable = {}

function EndlessTower:UpdateRefreshtime()
  local refreshtime = EndlessTowerProxy.Instance.refreshtime
  if self.actStartTime and self.actEndTime and refreshtime > self.actStartTime and refreshtime < self.actEndTime then
    self.refreshtime.text = GameConfig.EndlessTower.ActivityText.Text
    return
  end
  local refreshDay, refreshHour, refreshMin = ClientTimeUtil.GetFormatRefreshTimeStr(refreshtime)
  local str = ""
  TableUtility.ArrayClear(concatTable)
  if refreshDay ~= 0 then
    concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshDay, tostring(refreshDay))
  end
  if refreshHour ~= 0 then
    concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshHour, tostring(refreshHour))
  end
  concatTable[#concatTable + 1] = string.format(ZhString.EndlessTower_refreshTime, tostring(refreshMin))
  str = table.concat(concatTable)
  self.refreshtime.text = str
end

function EndlessTower:CheckActivityText()
  local config = GameConfig.EndlessTower.ActivityText
  if not config then
    return false
  end
  local curTime = ServerTime.CurServerTime() / 1000
  if EnvChannel.IsTFBranch() then
    self.actStartTime = config.TfStartTime
    self.actEndTime = config.TfEndTime
  else
    self.actStartTime = config.StartTime
    self.actEndTime = config.EndTime
  end
  local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(self.actStartTime)
  self.actStartTime = os.time({
    day = st_day,
    month = st_month,
    year = st_year,
    hour = st_hour,
    min = st_min,
    sec = st_sec
  })
  st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(self.actEndTime)
  self.actEndTime = os.time({
    day = st_day,
    month = st_month,
    year = st_year,
    hour = st_hour,
    min = st_min,
    sec = st_sec
  })
end

function EndlessTower:SetSelectState()
  local cells = self.itemList:GetCells()
  for i = 1, #cells do
    if self.selectCellData == cells[i].data then
      self:SetChooseSymbol(cells[i].gameObject)
      self.curIndex = i
      break
    end
  end
end

function EndlessTower:SetChooseSymbol(go)
  self.ChooseSymbolGo:SetActive(true)
  self.ChooseSymbolGo.transform:SetParent(go.transform, false)
  self.ChooseSymbolGo.transform.localPosition = Vector3(0, 2, 0)
end

function EndlessTower:RecvTowerInfoCmd(note)
  self.selectCellData = EndlessTowerProxy.Instance:GetNextLayer()
  self:UpdateTowerInfo()
  self:SetSelectState()
end

function EndlessTower:ScrollTower()
  local centerIndex = self.curIndex
  self.curCell = self.itemList:GetCells()[centerIndex]
  if self.curIndex < self.minOffsetIndex then
    centerIndex = self.minOffsetIndex
  elseif self.curIndex > self.maxOffsetIndex then
    centerIndex = self.maxOffsetIndex
  end
  local curCell = self.itemList:GetCells()[centerIndex]
  if curCell then
    self.centerOnChild:CenterOn(curCell.gameObject.transform)
  end
end

function EndlessTower:UpdateTowerInfo()
  local datas = EndlessTowerProxy.Instance:GetTowerInfoData()
  self.itemList:ResetDatas(datas)
end

function EndlessTower:HandleClickItem(cellctl)
  local data = cellctl.data
  local go = cellctl.gameObject
  self.selectCellCtl = cellctl
  self.selectCellData = data
  if data and go then
    self:SetChooseSymbol(go)
    self:ClickChallenge()
  end
end

function EndlessTower:ClickChallenge(go)
  if TeamProxy.Instance:IHaveTeam() then
    if EndlessTowerProxy.Instance:IsTeamMembersFighting() then
      if EndlessTowerProxy.Instance:IsCurLayerCanChallenge(self.selectCellData) then
        ServiceInfiniteTowerProxy.Instance:CallEnterTower(EndlessTowerProxy.Instance.curChallengeLayer, Game.Myself.data.id)
        self:CloseSelf()
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.EndlessTower_cantChallenge)
      end
    elseif TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      if EndlessTowerProxy.Instance:IsCurLayerCanChallenge(self.selectCellData) then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.EndlessTowerWaitView,
          viewdata = self.selectCellData
        })
        ServiceInfiniteTowerProxy.Instance:CallTeamTowerInviteCmd()
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.EndlessTower_cantChallenge)
      end
    else
      MsgManager.ShowMsgByIDTable(1301)
    end
  else
    MsgManager.ShowMsgByIDTable(1302)
  end
end
