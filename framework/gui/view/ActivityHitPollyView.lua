autoImport("DotCell")
autoImport("ActivityPollyRoundRewardCell")
autoImport("ActivityHitPollyQuestCell")
autoImport("HitPollyRewardPreviewCell")
ActivityHitPollyView = class("ActivityHitPollyView", ContainerView)
ActivityHitPollyView.ViewType = UIViewType.NormalLayer

function ActivityHitPollyView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitQuestRoot()
  self:InitView()
end

function ActivityHitPollyView:OnEnter()
  self.super.OnEnter(self)
  if ActivityHitPollyProxy.Instance:IsRoundInited(ActivityHitPollyProxy.Instance.currentRound) then
    if ActivityHitPollyProxy.Instance:NeedQueryNextRound() then
      self.viewIndex = ActivityHitPollyProxy.Instance.currentRound + 1
      self:Query()
    else
      self.viewIndex = ActivityHitPollyProxy.Instance.currentRound
      self:RefreshUI()
    end
  else
    self:Query()
  end
end

function ActivityHitPollyView:OnExit()
  LeanTween.cancel(self.gameObject)
  TipsView.Me():HideCurrent()
  TimeTickManager.Me():ClearTick(self)
  self.super.OnExit(self)
end

function ActivityHitPollyView:FindObjs()
  self.loadingPos = self:FindGO("Loading")
  self.pos = self:FindGO("Pos")
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.ActivityHitPolly_Title
  self.validDateLab = self:FindComponent("ValidDate", UILabel)
  self.roundGrid = self:FindGO("RoundGrid"):GetComponent(UIGrid)
  self.centerOnChild = self.roundGrid.gameObject:GetComponent("UICenterOnChild")
  local wayRoot = self:FindGO("Way")
  self.wayLab = self:FindComponent("WayLab", UILabel, wayRoot)
  self.wayLab.text = ZhString.ActivityHitPolly_GainWay
  local coinRoot = self:FindGO("CoinRoot", wayRoot)
  self.coinLeftFixedLab = self:FindComponent("CoinLeft_Fixed", UILabel, coinRoot)
  self.coinLeftFixedLab.text = ZhString.ActivityHitPolly_Balance
  self.coinLeftLab = self:FindComponent("CoinLeft_Num", UILabel, coinRoot)
  self.coinIcon = self:FindComponent("CoinIcon", UISprite, coinRoot)
  local coinid = ActivityHitPollyProxy.Instance:GetCoinID()
  IconManager:SetItemIcon(Table_Item[coinid].Icon, self.coinIcon)
  self.scrollView = self:FindComponent("PollyScrollView", UIScrollView)
  self.scrollView.enabled = true
  self.scrollView.smoothDragStart = true
end

function ActivityHitPollyView:InitQuestRoot()
  self.questTable = self:FindGO("QuestTable"):GetComponent(UITable)
  self.ongoingGrid = self:FindGO("OngoingGrid"):GetComponent(UIGrid)
  if self.ongoingCtrl == nil then
    self.ongoingCtrl = UIGridListCtrl.new(self.ongoingGrid, ActivityHitPollyQuestCell, "ActivityHitPollyQuestCell")
    self.ongoingCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickQuestDesc, self)
    self.ongoingCtrl:AddEventListener(ActivityHitPollyQuestCellEvent.ClickGo, self.OnGoModel, self)
  end
  self.ongoingLab = self:FindComponent("OnGoingLab", UILabel)
  self.ongoingLab.text = ZhString.ActivityHitPolly_Ongoing
  self.noOpenLab = self:FindComponent("NoOpenLab", UILabel)
  self.noOpenLab.text = ZhString.ActivityHitPolly_NoOpen
  self.finished = self:FindComponent("FinishedLab", UILabel)
  self.finished.text = ZhString.ActivityHitPolly_Finished
  
  function self.ongoingGrid.onReposition()
    self.questTable:Reposition()
  end
  
  local togA = true
  self.ongoingGrid.gameObject:SetActive(true)
  local cur = self:FindGO("OnGoingExp"):GetComponent(UISprite)
  cur.flip = 0
  self:AddClickEvent(self.ongoingLab.gameObject, function(go)
    self.ongoingGrid.gameObject:SetActive(not togA)
    self.questTable:Reposition()
    togA = not togA
    cur.flip = togA and 0 or 2
  end)
  self.noOpenGrid = self:FindGO("noOpenGrid"):GetComponent(UIGrid)
  if self.noOpenCtl == nil then
    self.noOpenCtl = UIGridListCtrl.new(self.noOpenGrid, ActivityHitPollyQuestCell, "ActivityHitPollyQuestCell")
    self.noOpenCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickQuestDesc, self)
    self.noOpenCtl:AddEventListener(ActivityHitPollyQuestCellEvent.ClickGo, self.OnGoModel, self)
  end
  
  function self.noOpenGrid.onReposition()
    self.questTable:Reposition()
  end
  
  local togB = true
  local noOpenExp = self:FindGO("NoOpenExp"):GetComponent(UISprite)
  noOpenExp.flip = 0
  self.noOpenGrid.gameObject:SetActive(true)
  self:AddClickEvent(self.noOpenLab.gameObject, function(go)
    self.noOpenGrid.gameObject:SetActive(not togB)
    self.questTable:Reposition()
    togB = not togB
    noOpenExp.flip = togB and 0 or 2
  end)
  self.finishedGrid = self:FindGO("FinishedGrid"):GetComponent(UIGrid)
  if self.pastGoalCtrl == nil then
    self.pastGoalCtrl = UIGridListCtrl.new(self.finishedGrid, ActivityHitPollyQuestCell, "ActivityHitPollyQuestCell")
    self.pastGoalCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickQuestDesc, self)
    self.pastGoalCtrl:AddEventListener(ActivityHitPollyQuestCellEvent.ClickGo, self.OnGoModel, self)
  end
  
  function self.finishedGrid.onReposition()
    self.questTable:Reposition()
  end
  
  local togC = true
  local finishedExp = self:FindGO("FinishedExp"):GetComponent(UISprite)
  finishedExp.flip = 0
  self.finishedGrid.gameObject:SetActive(true)
  self:AddClickEvent(self.finished.gameObject, function(go)
    self.finishedGrid.gameObject:SetActive(not togC)
    self.questTable:Reposition()
    togC = not togC
    finishedExp.flip = togC and 0 or 2
  end)
end

function ActivityHitPollyView:UpdateCoin()
  local num = BagProxy.Instance:GetItemNumByStaticID(ActivityHitPollyProxy.Instance:GetCoinID(), ActivityHitPollyProxy.PACKAGE_CHECK) or 0
  self.coinLeftLab.text = "x" .. num
  self:RefreshRewardHit()
end

function ActivityHitPollyView:Query()
  ActivityHitPollyProxy.Instance:CallQueryActivityList()
end

function ActivityHitPollyView:AddEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoin)
  self:AddListenEvt(ServiceEvent.ActHitPollyActityQueryHitedList, self.HandleQueryServerList)
  self:AddListenEvt(ServiceEvent.ActHitPollyActivityHitPolly, self.HandleHitPolly)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvShopQueryShopConfig)
  self:AddListenEvt(ServiceEvent.ActHitPollyActityHitPollyNtfQuest, self.UpdateQuest)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.Query)
  
  function self.centerOnChild.onCenter(centeredObject)
    if self.centeredTrans and self.centeredTrans.gameObject ~= centeredObject then
      self:CenterOn(self.centeredTrans)
      return
    end
    if self.lastCenteredObject == centeredObject then
      self.centeredTrans = nil
      return
    end
    for i = 1, #self.roundCtl:GetCells() do
      local cell = self.roundCtl:GetCells()[i]
      if cell.gameObject == centeredObject then
        self:SelectDotCell(i)
        self.viewIndex = i
        self.centeredTrans = nil
        self.lastCenteredObject = centeredObject
        if i < ActivityHitPollyProxy.Instance.currentRound and not ActivityHitPollyProxy.Instance:IsRoundInited(i) then
          ServiceActHitPollyProxy.Instance:CallActityQueryHitedList(i)
        end
        break
      end
    end
    self:RefreshRewardHit()
  end
  
  function self.scrollView.onDragStarted()
    self.forbiddenEffect = true
    self:RefreshRewardHit()
  end
  
  function self.scrollView.onStoppedMoving()
    self.forbiddenEffect = false
    self:RefreshRewardHit()
  end
end

function ActivityHitPollyView:HandleHitPolly()
  self:RefreshUI()
  if ActivityHitPollyProxy.Instance:NoRewardLeft() then
    local cell = self.roundCtl:GetCells()[ActivityHitPollyProxy.Instance.currentRound]
    cell:PlayNextRoundEff()
  end
  if ActivityHitPollyProxy.Instance:NeedQueryNextRound() then
    self.scrollView.enabled = false
    TimeTickManager.Me():ClearTick(self)
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      ServiceActHitPollyProxy.Instance:CallActityQueryHitedList(ActivityHitPollyProxy.Instance.currentRound + 1)
      self.scrollView.enabled = true
    end, self)
  end
end

function ActivityHitPollyView:RefreshRewardHit()
  for i = 1, #self.roundCtl:GetCells() do
    local cell = self.roundCtl:GetCells()[i]
    cell:ResetRewardHit(self.viewIndex, self.forbiddenEffect)
  end
end

function ActivityHitPollyView:CenterOn(t)
  self.centeredTrans = t
  self.centerOnChild:CenterOn(t)
end

function ActivityHitPollyView:InitView()
  local actTime = ActivityHitPollyProxy.Instance:GetActDuringTime()
  self.validDateLab.text = actTime
  local rewardPreviewGrid = self:FindComponent("RewardPreview", UIGrid)
  self.rewardPreviewCtrl = UIGridListCtrl.new(rewardPreviewGrid, HitPollyRewardPreviewCell, "HitPollyRewardPreviewCell")
  self.rewardPreviewCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  self.roundCtl = UIGridListCtrl.new(self.roundGrid, ActivityPollyRoundRewardCell, "ActivityPollyRoundRewardCell")
  local dotgrid = self:FindGO("DotGrid"):GetComponent(UIGrid)
  self.dotCtl = UIGridListCtrl.new(dotgrid, DotCell, "ChatDotCell")
  self:UpdateCoin()
end

function ActivityHitPollyView:OnClickQuestDesc(cellctl)
  local desc = cellctl.data and cellctl.data.staticData and cellctl.data.staticData.QuestDesc
  if desc then
    TipsView.Me():ShowGeneralHelp(desc, ZhString.ActivityPuzzle_QuestDesc)
  end
end

function ActivityHitPollyView:OnGoModel(cellctl)
  local mode = cellctl.data.staticData.GotoMode
  if mode then
    FuncShortCutFunc.Me():CallByID(mode)
    self:CloseSelf()
  end
end

function ActivityHitPollyView:SelectDotCell(index)
  local cells = self.dotCtl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetChoose(index == i)
    end
  end
end

function ActivityHitPollyView:HandleQueryServerList(note)
  local data = note.body
  if data then
    self.viewIndex = data.round
  end
  self.loadingPos:SetActive(false)
  self.pos:SetActive(true)
  self:RefreshUI()
end

function ActivityHitPollyView:ClickPreviewRewardItem(cellctl)
  if cellctl and cellctl ~= self.choosePreview then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChoosePreview()
      end
      local sdata = {
        itemdata = data.itemdata,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
    end
    self.choosePreview = cellctl
  else
    self:CancelChoosePreview()
  end
end

function ActivityHitPollyView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
end

function ActivityHitPollyView:RefreshUI()
  local previewData = ActivityHitPollyProxy.Instance:GetPreviewRewards() or {}
  self.rewardPreviewCtrl:ResetDatas(previewData)
  local roundData = ActivityHitPollyProxy.Instance:GetRoundDatas()
  if roundData then
    self.roundCtl:ResetDatas(roundData)
    self.dotCtl:ResetDatas(roundData)
  end
  self:UpdateQuest()
  local cells = self.roundCtl:GetCells()
  if 0 < #cells then
    self:CenterOn(cells[self.viewIndex].trans)
  end
end

function ActivityHitPollyView:RecvShopQueryShopConfig(note)
  local shopcfg = ActivityHitPollyProxy.Instance:GetActivityCFG()
  local targetID = shopcfg and shopcfg.coin.ItemID
  if targetID and note.body and note.body.goods and #note.body.goods > 0 then
    local data = note.body.goods[1]
    if data and data.itemid == targetID then
      ActivityHitPollyProxy.Instance:AddShopQuest(data)
      self:UpdateQuest()
    end
  end
end

function ActivityHitPollyView:UpdateQuest()
  local nopen, ongoing, finished = ActivityHitPollyProxy.Instance:GetQuests()
  self.noOpenCtl:ResetDatas(nopen)
  self.pastGoalCtrl:ResetDatas(finished)
  self.ongoingCtrl:ResetDatas(ongoing)
end

function ActivityHitPollyView:OnPurchase()
  if not ActivityHitPollyProxy.Instance:CanPurchase() then
    return
  end
end

function ActivityHitPollyView:OpenHelpView(data)
  local linkInfos = ActivityEventProxy.Instance:GetTapTapLinkInfo()
  if data ~= nil or not self.viewdata.view.id then
    if self.m_helpId == nil then
    end
    local helpId = self.m_helpId
  end
  local url
  if helpId ~= nil and linkInfos ~= nil then
    local types = GameConfig.TapTapLink[helpId]
    if types ~= nil then
      for _, info in pairs(linkInfos) do
        for _, v in pairs(types) do
          if info.activitytype == v then
            url = info.url
          end
        end
      end
    end
  end
  if not StringUtil.IsEmpty(url) then
    Application.OpenURL(url)
  else
    ActivityHitPollyView.super.OpenHelpView(self, data)
  end
end
