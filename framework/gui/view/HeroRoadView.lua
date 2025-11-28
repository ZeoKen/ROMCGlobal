autoImport("HeroRoadPicPopUp")
autoImport("HeroRoadSubPage")
autoImport("SweepTicketUtil")
HeroRoadView = class("HeroRoadView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("HeroRoadView")
local DetailViewEvent_CloseDetail = "DetailViewEvent_CloseDetail"
HeroRoad_OnDiffNodeClick = "HeroRoad_OnDiffNodeClick"
HeroRoad_OnBgClick = "HeroRoad_OnBgClick"

function HeroRoadView:Init(param)
  self.viewMap = {}
  self.shopMoney = {}
  self:LoadPrefab()
  self:FindObjs()
end

function HeroRoadView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.heroRoadViewRoot, true)
  obj.name = "HeroRoadView"
  self.gameObject = obj
  self.trans = obj.transform
end

function HeroRoadView:FindObjs()
  self:AddButtonEvent("HeroRoadCloseBtn", function()
    self.container:CloseSelf()
  end)
  self.pageRoot = self:FindGO("PageRoot")
  self.detailPanel = self:FindGO("DetailPanel")
  self.shopBtn = self:FindGO("ShopBtn")
  self.shopLabel = self:FindComponent("Label", UILabel, self.shopBtn)
  self:AddClickEvent(self.shopBtn, function()
    self:OnShopBtnClick()
  end)
  self.moneyLabel = self:FindComponent("MoneyLabel", UILabel)
  self.moneyIcon = self:FindComponent("MoneyIcon", UISprite)
  self.remainFreeLabel = self:FindComponent("RemainFree", UILabel)
  self.nameLabel = self:FindComponent("NameLabel", UILabel)
  self.helpBtn = self:FindGO("HelpTip")
  self:AddClickEvent(self.helpBtn, function()
    self:OnHelpBtnClick()
  end)
end

function HeroRoadView:OnEnter()
  HeroRoadView.super.OnEnter(self)
end

function HeroRoadView:OnExit()
  HeroRoadView.super.OnExit(self)
end

function HeroRoadView:RefreshView(groupId)
  if groupId then
    if not self.viewMap[groupId] then
      redlog("HeroRoadView:RefreshView", groupId, tostring(self.onEnterCalled))
      local subPage = self:AddSubView(groupId, HeroRoadSubPage, {
        parent = self.pageRoot.transform,
        groupId = groupId
      })
      subPage:AddEventListener(HeroRoad_OnDiffNodeClick, self.OnDiffNodeClick, self)
      subPage:AddEventListener(HeroRoad_OnBgClick, self.OnDragScrollClick, self)
    end
    if self.curGroupId ~= groupId then
      local curPage = self.viewMap[self.curGroupId]
      if curPage then
        curPage:Hide()
      end
      if self.detailView and self.detailView:IsShow() then
        self.detailView:Hide()
        if self.curNodeCell then
          self.curNodeCell:SetSelectState(false)
          self.curNodeCell = nil
        end
      end
      self.curGroupId = groupId
      self.viewMap[groupId]:Show()
    end
    self.viewMap[groupId]:RefreshView()
  end
  if self.curNodeCell then
    self.detailView:RefreshView(self.curNodeCell.data)
  end
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(groupId)
  local pvePassInfo = diffs[1]
  if pvePassInfo and pvePassInfo ~= PveEntranceProxy.EmptyDiff then
    local staticData = pvePassInfo.staticEntranceData.staticData
    local totalFreePassCount = staticData.FreeBattleTimeCount
    local curPassCount = pvePassInfo:GetPassTime()
    local remainFreePassCount = math.max(totalFreePassCount - curPassCount, 0)
    local str = "%s/%s"
    if remainFreePassCount == 0 then
      str = "[c][ff7b06]%s[-][/c]/%s"
    end
    str = string.format(str, remainFreePassCount, totalFreePassCount)
    self.remainFreeLabel.text = string.format(ZhString.HeroRoad_RemainFreeCount, str)
    self.nameLabel.text = staticData.Name
    local shop_id, shop_type = pvePassInfo.staticEntranceData.shopid, pvePassInfo.staticEntranceData.shoptype
    HappyShopProxy.Instance:InitShop(nil, shop_id, shop_type)
    local moneyId = self.shopMoney[groupId]
    if not moneyId then
      local npcFunc = Table_NpcFunction[shop_type]
      moneyId = npcFunc and npcFunc.Parama and npcFunc.Parama.ItemID and npcFunc.Parama.ItemID[1]
      self.shopMoney[groupId] = moneyId
    end
    if moneyId then
      IconManager:SetItemIconById(moneyId, self.moneyIcon)
      self:RefreshMoney()
      self.shopLabel.text = self:IsShopSoldOut() and ZhString.HappyShop_SoldOut or ZhString.HappyShop_Title
    end
  end
end

function HeroRoadView:RefreshMoney()
  local moneyId = self.shopMoney[self.curGroupId]
  if moneyId then
    local num = HappyShopProxy.Instance:GetItemNum(moneyId)
    self.moneyLabel.text = StringUtil.NumThousandFormat(num)
  end
end

function HeroRoadView:OnDiffNodeClick(cell)
  self.curNodeCell = cell
  if not self.detailView then
    self.detailView = HeroRoadDetailView.new(self.detailPanel)
    self.detailView:AddEventListener(DetailViewEvent_CloseDetail, self.OnDetailPanelClose, self)
  end
  self.detailView:Show()
  self.detailView:RefreshView(cell.data)
end

function HeroRoadView:OnDragScrollClick()
  if self.detailView then
    self.detailView:Hide()
  end
end

function HeroRoadView:OnDetailPanelClose()
  if self.curNodeCell then
    self.curNodeCell:SetSelectState(false)
    self.curNodeCell = nil
    if self.viewMap[self.curGroupId] then
      self.viewMap[self.curGroupId]:InvalidateNodeScrollBounds()
    end
  end
end

function HeroRoadView:OnShopBtnClick()
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.curGroupId)
  if 0 < #diffs then
    local pvePassInfo = diffs[1]
    if not pvePassInfo or not pvePassInfo.staticEntranceData:HasShopConfig() then
      return
    end
    local shop_id, shop_type = pvePassInfo.staticEntranceData.shopid, pvePassInfo.staticEntranceData.shoptype
    HappyShopProxy.Instance:InitShop(nil, shop_id, shop_type)
    local endCall = function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.PveView,
        viewdata = {
          initialGroupId = self.curGroupId
        }
      })
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {onExit = endCall})
  end
end

function HeroRoadView:HandleMyDataChange()
  self:RefreshMoney()
end

function HeroRoadView:HandleQueryShopConfig()
  self.shopLabel.text = self:IsShopSoldOut() and ZhString.HappyShop_SoldOut or ZhString.HappyShop_Title
end

function HeroRoadView:IsShopSoldOut()
  local totalCost = 0
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.curGroupId)
  local pvePassInfo = diffs[1]
  if pvePassInfo then
    local shop_id, shop_type = pvePassInfo.staticEntranceData.shopid, pvePassInfo.staticEntranceData.shoptype
    local costList = HappyShopProxy.Instance:GetTotalCost(shop_type, shop_id)
    for _, cost in pairs(costList) do
      totalCost = totalCost + cost
    end
  end
  return totalCost == 0
end

function HeroRoadView:OnHelpBtnClick()
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.curGroupId)
  if diffs[1] and diffs[1] ~= PveEntranceProxy.EmptyDiff then
    local staticData = Table_Help[diffs[1].staticEntranceData.staticData.HelpID]
    if staticData then
      TipsView.Me():ShowGeneralHelp(staticData.Desc, staticData.Title)
    end
  end
end

autoImport("HeroRoadAchievementCell")
autoImport("PveDropItemCell")
HeroRoadDetailView = class("HeroRoadDetailView", CoreView)
local lackOfBattleTimeCol = "e4593d"
local enoughBattleTimeCol = "555b6e"

function HeroRoadDetailView:ctor(go)
  HeroRoadDetailView.super.ctor(self, go)
  self:Init()
end

function HeroRoadDetailView:Init()
  self.costTime = 0
  self.differenceCostTime = 0
  self:FindObjs()
end

function HeroRoadDetailView:FindObjs()
  self:AddButtonEvent("CloseBtn", function()
    self:Hide()
  end)
  local achievementGrid = self:FindComponent("AchievementGrid", UIGrid)
  self.achievementListCtrl = UIGridListCtrl.new(achievementGrid, HeroRoadAchievementCell, "HeroRoadAchievementCell")
  local rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  self.sweepBtn = self:FindGO("SweepBtn")
  self:AddClickEvent(self.sweepBtn, function()
    self:OnSweepBtnClick()
  end)
  self.challengeBtn = self:FindGO("ChallengeBtn")
  self:AddClickEvent(self.challengeBtn, function()
    self:OnChallengeBtnClick()
  end)
  self.levelNameLabel = self:FindComponent("LevelName", UILabel)
  self.buttons = self:FindGO("Buttons")
  self.unlockTip = self:FindGO("UnlockTip")
  self.unlockTipLabel = self:FindComponent("Label", UILabel, self.unlockTip)
  self.costTimeLabel = self:FindComponent("CostTimeLabel", UILabel)
  self.addTimeBtn = self:FindGO("AddTimeBtn")
  self.addTimeBtnSp = self.addTimeBtn:GetComponent(UISprite)
  self:AddClickEvent(self.addTimeBtn, function()
    self:OnAddTimeBtnClick()
  end)
  self.happyShopPanel = self:FindGO("HappyShopPanel")
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"), self.happyShopPanel)
  if go then
    NGUIUtil.AdjustPanelDepthByParent(go)
    go.transform.localPosition = LuaGeometry.GetTempVector3(185, 40, 0)
    self.buyCell = HappyShopBuyItemCell.new(go)
    self.buyCell:Hide()
  end
end

function HeroRoadDetailView:Show()
  self.gameObject:SetActive(true)
end

function HeroRoadDetailView:Hide()
  self.gameObject:SetActive(false)
  self:PassEvent(DetailViewEvent_CloseDetail)
end

function HeroRoadDetailView:IsShow()
  return self.gameObject.activeSelf
end

function HeroRoadDetailView:RefreshView(data)
  if not data then
    return
  end
  self.data = data
  self.pvePassInfo = data.pvePassInfo
  if data.pvePassInfo then
    local staticData = data.pvePassInfo.staticEntranceData.staticData
    if staticData then
      local achievements = staticData.ShowAchievement
      if achievements then
        local datas = {}
        local stars = data.pvePassInfo.heroRoadStars
        for i = 1, #achievements do
          local id = achievements[i]
          local data = {}
          data.id = id
          data.isAchieved = TableUtility.ArrayFindIndex(stars, id) > 0
          datas[#datas + 1] = data
        end
        self.achievementListCtrl:ResetDatas(datas)
      end
      local rewards = data.pvePassInfo:GetAllRewards()
      self.rewardListCtrl:ResetDatas(rewards)
      self.costTime = staticData.TimeCost
      if not ISNoviceServerType then
        local time = BattleTimeDataProxy.Instance:GetLeftTime(nil, true)
        if time < self.costTime then
          local timeType = BattleTimeDataProxy.Instance:GetGameTimeSetting()
          local anotherTimeType = timeType == BattleTimeDataProxy.ETime.BATTLE and BattleTimeDataProxy.ETime.PLAY or BattleTimeDataProxy.ETime.BATTLE
          local anotherTime = BattleTimeDataProxy.Instance:GetLeftTime(anotherTimeType, true)
          if anotherTime + time >= self.costTime then
            self.differenceCostTime = (self.costTime - time) // 60
          else
            self.differenceCostTime = -1
          end
        else
          self.differenceCostTime = 0
        end
      end
    end
    self.buttons:SetActive(data.isUnlocked or false)
    self.unlockTip:SetActive(not data.isUnlocked)
    if not data.isUnlocked then
      local unlockLv = staticData and staticData.UnlockLv or 150
      self.unlockTipLabel.text = data.level == 1 and string.format(ZhString.HeroRoad_UnlockTipLv, unlockLv) or ZhString.HeroRoad_UnlockTipPreviousLevel
    end
    if data.pvePassInfo:GetQuick() then
      self:SetTextureWhite(self.sweepBtn, ColorUtil.ButtonLabelBlue)
    else
      self:SetTextureGrey(self.sweepBtn)
    end
    self.shopid = data.pvePassInfo.staticEntranceData.shopid
    self.shoptype = data.pvePassInfo.staticEntranceData.shoptype
    HappyShopProxy.Instance:InitShop(nil, self.shopid, self.shoptype)
    local diffRaidId = data.pvePassInfo.staticEntranceData.difficultyRaid
    local mapConfig = Table_Map[diffRaidId]
    if mapConfig then
      self.levelNameLabel.text = string.format("%s %s", DifficultyPathNodeCell.LevelIndex[data.level], mapConfig.NameZh)
    end
    if data.pvePassInfo:IsFree() then
      self.costTimeLabel.text = string.format(ZhString.PveView_CostPlayTime, ZhString.PveView_FreeTime)
    elseif 0 > self.differenceCostTime then
      self.costTimeLabel.text = string.format(ZhString.HeroRoad_BattleTimeCost, lackOfBattleTimeCol, self.costTime // 60)
    else
      self.costTimeLabel.text = string.format(ZhString.HeroRoad_BattleTimeCost, enoughBattleTimeCol, self.costTime // 60)
    end
    self.addTimeBtn:SetActive(not data.pvePassInfo:IsFree() and 0 > self.differenceCostTime)
  end
end

function HeroRoadDetailView:SetTextureWhite(btn, labelCol)
  local sp = btn:GetComponent(UIMultiSprite)
  sp.CurrentState = 1
  local label = self:FindComponent("Label", UILabel, btn)
  label.effectColor = labelCol
end

function HeroRoadDetailView:SetTextureGrey(btn)
  local sp = btn:GetComponent(UIMultiSprite)
  sp.CurrentState = 0
  local label = self:FindComponent("Label", UILabel, btn)
  label.effectColor = Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
end

function HeroRoadDetailView:OnSweepBtnClick()
  if self.call_lock then
    MsgManager.ShowMsgByID(49)
    return
  end
  if SweepTicketUtil.HasSweepTicket() and not self.pvePassInfo:IsFree() then
    if SweepTicketUtil.CheckSweepTicketValid(self.costTime, self.pvePassInfo:IsFree(), function(ignoreSufficientTime, ignoreMsg)
      return self:CheckSweepValid(ignoreSufficientTime, ignoreMsg)
    end) then
      SweepTicketUtil.HandleSweepTicketSweep(self.costTime, function(ticketCount, requiredTime, noTimeCost)
        self:ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost)
      end, function(ticketCount, requiredTime)
        self:ShowSweepTicketOverflowConfirm(ticketCount, requiredTime)
      end)
    else
      self:TrySweep()
    end
    return
  end
  self:TrySweep()
end

function HeroRoadDetailView:TrySweep()
  if not self:CheckSweepValid() then
    return
  end
  self:LockCall()
  self:ConfirmOption(function()
    self:DoSweep(false)
  end)
end

function HeroRoadDetailView:CheckSweepValid(ignoreSufficientTime, ignoreMsg)
  if not self.pvePassInfo then
    return false
  end
  if not self.pvePassInfo:GetQuick() then
    if not ignoreMsg then
      MsgManager.ShowMsgByID(43062)
    end
    return false
  end
  if not ignoreSufficientTime and not self.pvePassInfo:IsFree() and self.differenceCostTime < 0 then
    if not ignoreMsg then
      MsgManager.ShowMsgByID(43115)
    end
    return false
  end
  return true
end

function HeroRoadDetailView:DoSweep(use_sweep_ticket)
  if self.pvePassInfo then
    local timeType = BattleTimeDataProxy.Instance:GetGameTimeSetting()
    local msgID = timeType == BattleTimeDataProxy.ETime.BATTLE and 43113 or 43214
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(msgID)
    local entranceData = self.pvePassInfo.staticEntranceData
    local raidid = entranceData.difficultyRaid
    local groupid = entranceData.groupid
    if not dont and self.differenceCostTime == 0 and not self.pvePassInfo:IsFree() then
      MsgManager.DontAgainConfirmMsgByID(msgID, function()
        ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
      end, nil, nil, self.costTime // 60)
    else
      ServiceFuBenCmdProxy.Instance:CallQuickFinishPveRaidFubenCmd(raidid, groupid, nil, use_sweep_ticket)
    end
  end
end

function HeroRoadDetailView:OnChallengeBtnClick()
  if not self.data.isUnlocked then
    MsgManager.ShowMsgByID(43061)
    return
  end
  self:ConfirmOption(function()
    if FunctionPve.Me():DoChallenge() then
      self:sendNotification(UICloseEvent.CloseSubView)
    end
  end)
end

function HeroRoadDetailView:OnClickRewardItem(cellctl)
  local data = cellctl.data
  if data == PveDropItemCell.Empty then
    return
  end
  if cellctl and cellctl ~= self.chooseReward then
    local stick = cellctl.icon
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function HeroRoadDetailView:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function HeroRoadDetailView:ConfirmOption(handler)
  if self:CheckCoinIsFull() then
    local costList = HappyShopProxy.Instance:GetTotalCost(self.shoptype, self.shopid)
    local moneyId = next(costList)
    local config = Table_Item[moneyId]
    local name = config and config.NameZh
    MsgManager.ConfirmMsgByID(43512, handler, nil, nil, name)
    return
  end
  if not self.pvePassInfo:IsFree() and self.differenceCostTime > 0 then
    local timeType = BattleTimeDataProxy.Instance:GetGameTimeSetting()
    local msgID = timeType == BattleTimeDataProxy.ETime.PLAY and 43242 or 43243
    MsgManager.ConfirmMsgByID(msgID, function()
      handler()
    end, nil, nil, self.differenceCostTime)
  else
    handler()
  end
end

function HeroRoadDetailView:CheckCoinIsFull()
  if self.shopid and self.shoptype then
    HappyShopProxy.Instance:InitShop(nil, self.shopid, self.shoptype)
    local costList = HappyShopProxy.Instance:GetTotalCost(self.shoptype, self.shopid)
    local isFull = true
    for _moneyid, _cost in pairs(costList) do
      local _ownCount = HappyShopProxy.Instance:GetItemNum(_moneyid)
      if _cost > _ownCount then
        isFull = false
      end
    end
    return isFull
  end
  return false
end

function HeroRoadDetailView:OnAddTimeBtnClick()
  local itemId = GameConfig.Pve and GameConfig.Pve.AddPlayTimeItemId and GameConfig.Pve.AddPlayTimeItemId[1]
  local d = BagProxy.Instance:GetItemByStaticID(itemId)
  if not d then
    d = BagProxy.Instance:GetItemByStaticID(itemId, BagProxy.BagType.Storage)
    d = d or BagProxy.Instance:GetItemByStaticID(itemId, BagProxy.BagType.Barrow)
  end
  if d then
    local sdata = {
      itemdata = d,
      ignoreBounds = {
        self.addTimeBtnSp
      },
      applyClose = true,
      callback = function()
        BattleTimeDataProxy.QueryBattleTimelenUserCmd()
      end
    }
    sdata.funcConfig = FunctionItemFunc.GetItemFuncIds(itemId)
    self:ShowItemTip(sdata, self.addTimeBtnSp, NGUIUtil.AnchorSide.Right, {210, 300})
  else
    local shopCfg = GameConfig.Pve and GameConfig.Pve.AddPlayTimeDepositeId
    if shopCfg then
      local sType, sId = next(shopCfg)
      if sType and sId and type(sId) == "table" then
        HappyShopProxy.Instance:InitShop(Game.Myself, sId[1], sType)
        local shopData = ShopProxy.Instance:GetShopDataByTypeId(sType, sId[1])
        if shopData then
          local goods = shopData:GetGoods()
          for k, good in pairs(goods) do
            if good.id == sId[2] then
              self.buyCell:Show()
              self.buyCell:SetData(good)
              HappyShopProxy.Instance:SetSelectId(good.id)
              return
            end
          end
        end
      end
    end
  end
end

function HeroRoadDetailView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:CancelLockCall()
    end, self)
  end
end

function HeroRoadDetailView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function HeroRoadDetailView:ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost)
  SweepTicketUtil.ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost, function(use_sweep_ticket)
    self:DoSweep(use_sweep_ticket)
  end)
end

function HeroRoadDetailView:ShowSweepTicketOverflowConfirm(ticketCount, requiredTime)
  SweepTicketUtil.ShowSweepTicketOverflowConfirm(ticketCount, requiredTime, function(use_sweep_ticket)
    self:DoSweep(use_sweep_ticket)
  end)
end
