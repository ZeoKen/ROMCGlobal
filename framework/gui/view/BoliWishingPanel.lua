BoliWishingPanel = class("BoliWishingPanel", BaseView)
BoliWishingPanel.ViewType = UIViewType.NormalLayer
autoImport("WishingCardCell")
local tipData = {}
local funkey = {"ShowDetail", "AddFriend"}
local tempVector3 = LuaVector3.Zero()

function BoliWishingPanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
end

function BoliWishingPanel:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function BoliWishingPanel:FindObjs()
  self.myselfWish = self:FindGO("MyselfWish")
  self.playerWish = self:FindGO("PlayerWish")
  self.myselfDetailWish = self:FindGO("MyselfDetailWish")
  self.playerWishGrid = self:FindGO("PlayerWishGrid"):GetComponent(UIGrid)
  self.playerWishGridCtrl = UIGridListCtrl.new(self.playerWishGrid, WishingCardCell, "WishingCardCell")
  self.myWishBtn = self:FindGO("MyWishBtn")
  self.myWishClickLabel = self:FindGO("MyWishClickLabel"):GetComponent(UILabel)
  self.myWishClickLabel.text = ZhString.BoliWishingPanel_MyWish
  self.myWishCount = self:FindGO("Label", self.myWishBtn):GetComponent(UILabel)
  self.closeWishBtn = self:FindGO("CloseWishBtn")
  self.closeDetailBtn = self:FindGO("CloseDetailBtn")
  self.refreshBtn = self:FindGO("RefreshBtn")
  self.refreshBtn_BoxCollider = self.refreshBtn:GetComponent(BoxCollider)
  self.playerTipRoot = self:FindGO("PlayerTipRoot"):GetComponent(UIWidget)
  self.closeBtn = self:FindGO("CloseButton")
  self.playerWish_TweenAlpha = self.playerWish:GetComponent(TweenAlpha)
  self.myselfDetailWish_TweenAlpha = self.myselfDetailWish:GetComponent(TweenAlpha)
  self.myselfDetailWish_TweenScale = self.myselfDetailWish:GetComponent(TweenScale)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
end

function BoliWishingPanel:AddEvts()
  self:AddClickEvent(self.myWishBtn, function()
    self.pageMode = 3
    self:RefreshPage()
    self.myselfDetailWish_TweenAlpha.delay = 0.2
    self.myselfDetailWish_TweenAlpha:ResetToBeginning()
    self.myselfDetailWish_TweenAlpha:PlayForward()
    self.myselfDetailWish_TweenScale.delay = 0.2
    self.myselfDetailWish_TweenScale:ResetToBeginning()
    self.myselfDetailWish_TweenScale:PlayForward()
  end)
  self:AddClickEvent(self.closeWishBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.closeDetailBtn, function()
    self.myselfDetailWishCell:RemoveLikes()
    self.pageMode = 2
    self:RefreshPage()
  end)
  self:AddClickEvent(self.refreshBtn, function()
    xdlog("申请刷新")
    ServiceActivityCmdProxy.Instance:CallWishActivityInfoCmd()
    self:SetTextureGrey(self.refreshBtn)
    self.refreshBtn_BoxCollider.enabled = false
    self.refreshValidTime = ServerTime.CurServerTime() / 1000 + 1
    TimeTickManager.Me():CreateTick(0, 200, self.refreshBtnValid, self, 1)
  end)
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function BoliWishingPanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdWishActivityInfoCmd, self.GetWishInfo)
  self:AddListenEvt(ServiceEvent.ActivityCmdWishActivityWishCmd, self.RecvWishRefresh)
  self:AddListenEvt(ServiceEvent.ActivityCmdWishActivityLikeRecordCmd, self.RefreshLikeRecord)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
  self:AddListenEvt(UICellEvent.OnCellClicked, self.RefreshPlayerTipContainer)
  self:AddListenEvt(BoliWishingEvent.LikeMyself, self.LikeMyself)
end

function BoliWishingPanel:InitData()
  self.pageMode = 0
  self.playerWishInfo = {}
  self.likeRecords = {}
  self.recordid = 0
  local npcdata = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  local npcid = npcdata and npcdata.data and npcdata.data.staticData.id
  local curMapID = Game.MapManager:GetMapID()
  local cutSceneConfig = GameConfig.WishingTree and GameConfig.WishingTree.Map and GameConfig.WishingTree.Map[curMapID]
  if cutSceneConfig and npcid then
    self.cutSceneID = cutSceneConfig[npcid]
  end
end

function BoliWishingPanel:InitShow()
  if self.myselfWishInfo then
    self.pageMode = 2
    self:RefreshPage()
  else
    self.pageMode = 1
    self:RefreshPage()
  end
end

function BoliWishingPanel:GetWishInfo(note)
  local data = note.body
  local myWish = data.mywish
  xdlog("muywish", myWish.id)
  local myWishID = myWish and myWish.id or 0
  if myWishID == 0 then
    xdlog("无数据，进入许愿模式")
    self.pageMode = 1
  else
    xdlog("有许愿信息，默认为随机愿望页")
    self.pageMode = 2
  end
  local tempData, tempRandomData = {}, {}
  TableUtility.TableShallowCopy(tempData, myWish)
  self.myselfWishInfo = tempData
  TableUtility.TableShallowCopy(tempRandomData, data.randomwish)
  self.playerWishInfo = tempRandomData
  self:RefreshPage()
end

function BoliWishingPanel:RecvWishRefresh(note)
  if self.cutSceneID then
    local result = Game.PlotStoryManager:Start_SEQ_PQTLP({
      self.cutSceneID
    }, function()
      FunctionNpcFunc.JumpPanel(PanelConfig.BoliWishingPanel)
    end)
  end
  self:CloseSelf()
end

function BoliWishingPanel:RefreshLikeRecord(note)
  local data = note.body
  local myselfWishID = data.id
  self.recordid = data.recordid
  local records = data.record
  xdlog("我的点赞记录", self.recordid)
  if self.recordCount and self.recordCount < 100 and self.likeRecords[myselfWishID] then
    TableUtility.TableClear(self.likeRecords[myselfWishID])
  end
  if records and 0 < #records then
    for i = 1, #records do
      local single = records[i]
      if not self.likeRecords[myselfWishID] then
        self.likeRecords[myselfWishID] = {}
      end
      local tempData = {}
      TableUtility.TableShallowCopy(tempData, single)
      self.likeRecords[myselfWishID][single.charid] = tempData
    end
  end
  if self.myselfDetailWishCell then
    local result = {}
    if self.likeRecords[myselfWishID] then
      for k, v in pairs(self.likeRecords[myselfWishID]) do
        table.insert(result, v)
      end
      table.sort(result, function(l, r)
        return l.time > r.time
      end)
    end
    self.recordCount = #result
    if self.recordCount >= 100 then
      self.recordid = result[#result].recordid
    end
    self.myselfDetailWishCell:SetRecords(result)
  end
end

function BoliWishingPanel:RefreshPage()
  local pageIndex = self.pageMode or 1
  if pageIndex == 0 then
    return
  end
  xdlog("刷新页数", pageIndex)
  if pageIndex == 1 then
    self.myselfWish:SetActive(true)
    self.playerWish:SetActive(false)
    self.myselfDetailWish:SetActive(false)
    if not self.myselfWishCell then
      local go = self:LoadCellPfb("WishingCardCell", self.myselfWish)
      self.myselfWishCell = WishingCardCell.new(go)
    end
    self.myselfWishCell:SetPage(1)
  elseif pageIndex == 2 then
    self.myselfWish:SetActive(false)
    self.playerWish:SetActive(true)
    self.myselfDetailWish:SetActive(false)
    if self.playerWishInfo then
      self.playerWishGridCtrl:ResetDatas(self.playerWishInfo)
    end
    local myselfWishCount = self.myselfWishInfo and self.myselfWishInfo.likenum
    self.myWishCount.text = myselfWishCount
  elseif pageIndex == 3 then
    self.myselfWish:SetActive(false)
    self.playerWish:SetActive(false)
    self.myselfDetailWish:SetActive(true)
    if not self.myselfDetailWishCell then
      local go = self:LoadCellPfb("WishingCardCell", self.myselfDetailWish)
      self.myselfDetailWishCell = WishingCardCell.new(go)
    end
    self.myselfDetailWishCell:SetPage(3, self.myselfWishInfo)
    local targetID = self.myselfWishInfo and self.myselfWishInfo.id
    ServiceActivityCmdProxy.Instance:CallWishActivityLikeRecordCmd(targetID, self.recordid)
  end
end

function BoliWishingPanel:HandleQueryUserInfo(note)
  local data = note.body
  if data then
    if self.playerTipData == nil then
      self.playerTipData = PlayerTipData.new()
    end
    self.playerTipData:SetBySocialData(data.data)
    local _FunctionPlayerTip = FunctionPlayerTip.Me()
    _FunctionPlayerTip:CloseTip()
    local playerTip = _FunctionPlayerTip:GetPlayerTip(self.playerTipRoot, NGUIUtil.AnchorSide.Right, {-50, 0})
    tipData.playerData = self.playerTipData
    tipData.funckeys = funkey
    playerTip:SetData(tipData)
  end
end

function BoliWishingPanel:RefreshPlayerTipContainer()
  if self.uiCamera then
    local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    self.playerTipRoot.gameObject.transform.localPosition = tempVector3
  end
end

function BoliWishingPanel:LikeMyself(note)
  local data = note.body
  xdlog("点赞自己", data)
  if data then
    if self.myselfWishInfo then
      self.myselfWishInfo.likenum = self.myselfWishInfo.likenum + data
      local myselfWishCount = self.myselfWishInfo and self.myselfWishInfo.likenum
      self.myWishCount.text = myselfWishCount
    end
    if self.playerWishInfo then
      for i = 1, #self.playerWishInfo do
        local single = self.playerWishInfo[i]
        if single.charid == Game.Myself.data.id then
          single.likenum = single.likenum + data
          single.likeed = 0 < data
        end
      end
    end
  end
end

function BoliWishingPanel:refreshBtnValid()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.refreshValidTime then
    self:SetTextureWhite(self.refreshBtn, LuaGeometry.GetTempVector4(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1))
    self.refreshBtn_BoxCollider.enabled = true
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function BoliWishingPanel:OnEnter()
  BoliWishingPanel.super.OnEnter(self)
  ServiceActivityCmdProxy.Instance:CallWishActivityInfoCmd()
end

function BoliWishingPanel:OnExit()
  BoliWishingPanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
