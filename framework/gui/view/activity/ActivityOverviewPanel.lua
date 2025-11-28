ActivityOverviewPanel = class("ActivityOverviewPanel", ContainerView)
ActivityOverviewPanel.ViewType = UIViewType.NormalLayer
autoImport("ActivityNodeCell")

function ActivityOverviewPanel:Init()
  self:AddViewEvts()
  self:initData()
  self:InitView()
end

function ActivityOverviewPanel:initData()
  self:ResetData()
end

function ActivityOverviewPanel:ResetData()
  self.rewardList = {}
  self.layoutFinish = false
end

function ActivityOverviewPanel:InitView()
  self.tag = self:FindGO("Tag")
  self.tagLabel = self:FindGO("Label", self.tag):GetComponent(UILabel)
  self.exit = self:FindGO("ExitBtn")
  self:AddClickEvent(self.exit, function()
    self:CloseSelf()
  end)
  self.purikura = self:FindGO("Purikura"):GetComponent(UITexture)
  self.container = self:FindGO("PanelContainer")
  self.activityNodeCtrl = UIGridListCtrl.new(self.container, ActivityNodeCell, "ActivityNodeCell")
  self.detailView = self:FindGO("DetailPanel")
  self.detailView.gameObject:SetActive(false)
  local activityDesBoard = self:FindGO("ActivityDiscription", self.detailView)
  self.activityDes = self:FindGO("Label", activityDesBoard):GetComponent(UILabel)
  self.activityTime = self:FindGO("ActivityTime", activityDesBoard):GetComponent(UILabel)
  self.activityTitle = self:FindGO("ActivityTitle", activityDesBoard):GetComponent(UILabel)
  self.goBtn = self:FindGO("GoBtn")
  self:AddClickEvent(self.goBtn, function()
    self:HandleClickGoBtn(self.currentCell)
  end)
  local reward = self:FindGO("Reward", self.detailView)
  self.rewardGrid = self:FindGO("Grid", reward):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, BagItemCell, "BagItemCell")
  self.tipData = {}
  self.activityNodeCtrl:AddEventListener(MouseEvent.MouseClick, self.ShowDetailPanel, self)
  self.activityNodeCtrl:AddEventListener(ActivityNodeCellEvent.ClickGoBtn, self.HandleClickGoBtn, self)
  self.activityNodeCtrl:AddEventListener(ActivityNodeCellEvent.GetIconTexture, self.getSubActTextures, self)
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickRewardItem, self)
  self:ShowActivityBoard()
end

function ActivityOverviewPanel:ShowActivityBoard()
  local activityData = ActivityDataProxy.Instance:getCurrentTimeLimitActivity()
  local subActivities = activityData and activityData.items
  self.activityNodeCtrl:ResetDatas(subActivities, nil, false)
  local cells = self.activityNodeCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:LoadTexture()
  end
  self.nodeNum = #subActivities
  helplog(self.nodeNum)
  self.tagLabel.text = activityData:GetActivityName()
  local url = activityData:GetActivityPurikuraPath()
  ActivityTextureManager.Instance():AddActivityPicInfos({url})
end

function ActivityOverviewPanel:AddViewEvts()
  EventManager.Me():AddEventListener(ActivityTextureManager.ActivityPicCompleteCallbackMsg, self.subActPicCompleteCallback, self)
end

function ActivityOverviewPanel:subActPicCompleteCallback(note)
  local data = note.data
  local activityData = ActivityDataProxy.Instance:getCurrentTimeLimitActivity()
  local mainTextureUrl = activityData:GetActivityPurikuraPath()
  if mainTextureUrl == data.picUrl then
    self:completeCallbackBytes(data.byte)
    return
  end
  local cell = self:GetItemCellById(data.picUrl)
  if cell then
    cell:setTextureByBytes(data.byte)
  end
  self.nodeNum = #activityData.items
  local cells = self.activityNodeCtrl:GetCells()
  if cells and #cells and not self.layoutFinish then
    for i = 1, #cells do
      cells[i]:RefreshCellSize(self.nodeNum)
    end
    self.layoutFinish = true
  end
end

function ActivityOverviewPanel:GetItemCellById(photourls)
  local cells = self.activityNodeCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].data.photourls == photourls then
        return cells[i]
      end
    end
  end
end

function ActivityOverviewPanel:completeCallbackBytes(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:setTexture(texture)
  else
    ActivityTextureManager.Instance():log("ActivityDetailPanel:completeCallbackBytes LoadImage failure")
    Object.DestroyImmediate(texture)
  end
end

function ActivityOverviewPanel:getSubActTextures(cellCtl)
  if cellCtl and cellCtl.data then
    ActivityTextureManager.Instance():AddActivityPicInfos({
      cellCtl.data.photourls
    })
  end
end

function ActivityOverviewPanel:HandleClickGoBtn(cell)
  local data = cell.data
  if data.tracetype == 1 then
    FuncShortCutFunc.Me():JumpPanel(data.traceinfo)
  elseif data.tracetype == 2 then
    FuncShortCutFunc.Me():MoveToPos(data.traceinfo)
  end
  self:CloseSelf()
  return
end

function ActivityOverviewPanel:setTexture(texture)
  Object.DestroyImmediate(self.purikura.mainTexture)
  self.purikura.mainTexture = texture
  self.purikura.width = texture.width or 471
  self.purikura.height = texture.height or 515
end

function ActivityOverviewPanel:UpdateReward()
  self.rewardItemDataList = ReusableTable.CreateArray()
  for i = 1, #self.rewardList do
    local item = ItemData.new("JobExp", self.rewardList[i])
    table.insert(self.rewardItemDataList, item)
  end
  self.rewardCtrl:ResetDatas(self.rewardItemDataList)
end

function ActivityOverviewPanel:ShowDetailPanel(cell)
  local data = cell.data
  self.currentCell = cell
  self.rewardList = data.rewards
  if data then
    self:ShowDetailInfo(data)
  end
  if data.tracetype == 0 then
    self.goBtn.gameObject:SetActive(false)
  end
end

function ActivityOverviewPanel:ShowDetailInfo(data)
  self.detailView.gameObject:SetActive(true)
  local nodeActTitle = data.title
  self.activityTitle.text = nodeActTitle
  local nodeActDes = data.desc
  self.activityDes.text = nodeActDes
  local startTime = data.starttime
  local endTime = data.endtime
  local combineTime = string.format(startTime, endTime)
  self.activityTime.text = string.format(ZhString.ActivityData_Time, startTime, endTime)
  self:UpdateReward()
end

function ActivityOverviewPanel:HandleClickRewardItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end

function ActivityOverviewPanel:OnExit()
  ReusableTable.DestroyAndClearArray(self.rewardItemDataList)
  EventManager.Me():RemoveEventListener(ActivityTextureManager.ActivityPicCompleteCallbackMsg, self.subActPicCompleteCallback, self)
  Object.DestroyImmediate(self.purikura.mainTexture)
  ActivityOverviewPanel.super.OnExit(self)
end
