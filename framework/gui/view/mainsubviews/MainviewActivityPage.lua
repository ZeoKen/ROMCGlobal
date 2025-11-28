MainviewActivityPage = class("MainviewActivityPage", SubView)
autoImport("ActivityButtonCell")
autoImport("ActivityTextureManager")
if not GameConfig.HotEntrance then
  GameConfig.HotEntrance = {
    MoreButton = {
      Recharge = {
        name = "打赏",
        icon = "tab_icon_60",
        sortid = 7,
        panelid = 722,
        redtiptype = {10600, 10740},
        Enterhide = _EmptyTable,
        BranchHide = 2,
        GroupID = _EmptyTable,
        Sound = "UI/UI_fun_reward"
      },
      Auction = {
        name = "拍卖行",
        icon = "tab_icon_Pocket",
        sortid = 12,
        redtiptype = {84},
        Enterhide = _EmptyTable,
        GroupID = _EmptyTable,
        Sound = "UI/UI_fun_auction"
      }
    },
    Order = {
      "tab_icon_60",
      "tab_icon_Pocket"
    }
  }
end
_NoviceBattlePassProxy = NoviceBattlePassProxy.Instance
local HeroShopTip = SceneTip_pb.EREDSYS_HEROSHOP

function MainviewActivityPage:Init()
  self.keepActivityCells = {}
  self:initView()
  self:AddViewListen()
  self:RegisterHotEntranceRedtip()
end

function MainviewActivityPage:OnEnter()
  self.super.OnEnter(self)
  self:UpdateActivityInfos()
  self:UpdateMoreInfo()
end

function MainviewActivityPage:SetSpriteAndLabel(cellGO, spriteName, labelText, _makePixel)
  if _makePixel == nil then
  end
  local makePixel = _makePixel
  local sprite = self:FindComponent("Sprite", UISprite, cellGO)
  if sprite then
    IconManager:SetUIIcon(spriteName, sprite)
    if makePixel then
      sprite:MakePixelPerfect()
    end
  end
  local label = self:FindComponent("Label", UILabel, cellGO)
  if label then
    label.text = labelText
  end
end

function MainviewActivityPage:initAddCreditButton()
  if not BranchMgr.IsJapan() then
    return
  end
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  if not Slua.IsNull(self.addCreditButton) then
    return
  end
  self.addCreditButton = self:CopyGameObject(self.doujinshiButton, self:FindComponent("TopRightFunc", UIGrid))
  self.addCreditButton.name = "AddCreditButton"
  self.addCreditButton:SetActive(true)
  self.addCreditButton.transform:SetSiblingIndex(0)
  self:SetSpriteAndLabel(self.addCreditButton, "tab_icon_61", ZhString.PocketLottery_AddCredit)
  self.addCreditNode = self:FindGO("DoujinshiNode", self.addCreditButton)
  self.addCreditNode.name = "AddCreditNode"
  self.addCreditGrid = self:FindComponent("ContentCt", UIGrid, self.addCreditNode)
  self.addCreditGridBg = self:FindComponent("bg", UISprite, self.addCreditNode)
  local childCount = self.addCreditGrid.transform.childCount
  if 0 < childCount then
    for i = childCount - 1, 0, -1 do
      GameObject.DestroyImmediate(self.addCreditGrid.transform:GetChild(i).gameObject)
    end
  end
  self:AddClickEvent(self.addCreditButton, function()
    self.container.menuPage:SetAddCreditNodeActive(not self.addCreditNode.activeSelf)
  end)
end

function MainviewActivityPage:initView()
  self.doujinshiButton = self:FindGO("DoujinshiButton")
  self.DoujinshiNode = self:FindGO("DoujinshiNode")
  self:initAddCreditButton()
  local node = GameConfig.System.ShieldMaskDoujinshi == 1 and self:FindGO("AddCreditNode") or self.DoujinshiNode
  self.activityGrid = self:FindComponent("ContentCt", UIGrid, node)
  self.activityTrans = self.activityGrid.transform
  self.activityGridList = UIGridListCtrl.new(self.activityGrid, ActivityButtonCell, "ActivityButtonCell")
  self.activityGridList:AddEventListener(MainViewEvent.GetIconTexture, self.GetIconTexture, self)
  self.activityGridList:AddEventListener(MouseEvent.MouseClick, self.ActivityCellClick, self)
  local topRFuncGrid2GO = self:FindGO("TopRightFunc2")
  self.topRFuncGrid2 = topRFuncGrid2GO:GetComponent(UIGrid)
  self.saveKapraButton = self:FindGO("SaveKapraButton", topRFuncGrid2GO)
  self:AddClickEvent(self.saveKapraButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SaveKapraEnterView
    })
  end)
  self.bigCatInvadeBtn = self:FindGO("BigCatInvadeBtn")
  self:AddClickEvent(self.bigCatInvadeBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.BigCatInvadeEnterView
    })
  end)
  self:InitMoreInfo()
  self:UpdateSaveKapraButton()
  self:UpdateReturnBattlePassButton()
  self:UpdateBigCatInvadeButton()
end

function MainviewActivityPage:UpdateSaveKapraButton()
  local actId = GameConfig.Activity.SaveCapra.ActivityID
  local open = FunctionActivity.Me():IsActivityRunning(actId)
  self.saveKapraButton:SetActive(open)
  self.topRFuncGrid2:Reposition()
end

function MainviewActivityPage:UpdateBigCatInvadeButton()
  local actId = GameConfig.Activity.BigCatInvade and GameConfig.Activity.BigCatInvade.ActivityID
  local open = FunctionActivity.Me():IsActivityRunning(actId)
  self.bigCatInvadeBtn:SetActive(open)
  self.topRFuncGrid2:Reposition()
end

function MainviewActivityPage:RegisterHotEntranceRedtip()
  if _NoviceBattlePassProxy:IsReturnBPAvailable() then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_RETURN_BP, self.doujinshiButton, 42)
  end
end

function MainviewActivityPage:UpdateReturnBattlePassButton()
  local gConfig = GameConfig.ReturnBattlePass
  if not gConfig then
    return
  end
  if _NoviceBattlePassProxy:IsReturnBPAvailable() then
    if not self.returnBPButton then
      self.returnBPButton = self:CreateDoujinshiButton(gConfig.Name, gConfig.Icon, function()
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.NoviceBattlePassView,
          viewdata = {bPType = 2}
        })
      end)
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_RETURN_BP, self.returnBPButton, 42)
      self:RegisterRedTipCheck(10729, self.returnBPButton, 42)
    end
  elseif self.returnBPButton then
    self.returnBPButton:SetActive(false)
  end
end

function MainviewActivityPage:ActivityCellClick(cellCtl)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ActivityDetailPanel,
    viewdata = {
      groupId = cellCtl.data.id
    }
  })
end

function MainviewActivityPage:GetIconTexture(cellCtl)
  if cellCtl and cellCtl.data then
    ActivityTextureManager.Instance():AddActivityPicInfos({
      cellCtl.data.iconurl
    })
  end
end

function MainviewActivityPage:AddViewListen()
  self:AddListenEvt(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd, self.HandleOperActivityNtfSocialCmd)
  self:AddListenEvt(ActivityTextureManager.ActivityPicCompleteCallbackMsg, self.picCompleteCallback)
  self:AddListenEvt(MainViewEvent.SaveKapraUpdate, self.UpdateSaveKapraButton)
  self:AddListenEvt(ServiceEvent.NoviceBattlePassReturnBpTargetUpdateCmd, self.UpdateReturnBattlePassButton)
  self:AddListenEvt(NoviceBattlePassEvent.ReturnBPEnd, self.UpdateReturnBattlePassButton)
  self:AddListenEvt(MainViewEvent.BigCatInvadeUpdate, self.UpdateBigCatInvadeButton)
end

function MainviewActivityPage:picCompleteCallback(note)
  local data = note.body
  local cell = self:GetItemCellById(data.picUrl)
  if cell then
    cell:setTextureByBytes(data.byte)
  end
end

function MainviewActivityPage:GetItemCellById(picUrl)
  local cells = self.activityGridList:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].data.iconurl == picUrl then
        return cells[i]
      end
    end
  end
end

function MainviewActivityPage:HandleOperActivityNtfSocialCmd()
  self:UpdateActivityInfos()
end

function MainviewActivityPage:updateActivityTime()
  local cells = self.activityGridList:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:updateTime()
    end
  end
end

function MainviewActivityPage:updateCellPosition()
  local cells = self.activityGridList:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if BranchMgr.IsJapan() then
        cells[i].gameObject.transform:SetAsLastSibling()
      else
        cells[i].gameObject.transform:SetAsFirstSibling()
      end
    end
    self.activityGridList:Layout()
  end
end

function MainviewActivityPage:UpdateActivityInfos()
  TimeTickManager.Me():ClearTick(self)
  local activities = ActivityDataProxy.Instance:getActiveActivitys()
  if type(activities) == "table" and next(activities) then
    self.activityGridList:ResetDatas(activities)
    self:updateCellPosition()
    TimeTickManager.Me():CreateTick(0, 1000, self.updateActivityTime, self)
  else
    self.activityGridList:RemoveAll()
  end
end

function MainviewActivityPage:InitMoreInfo()
  local moreButton = GameConfig.HotEntrance and GameConfig.HotEntrance.MoreButton
  if not moreButton then
    return
  end
  local recharge = moreButton.Recharge
  if recharge then
    local button, buttonCell = self:CreateDoujinshiButton(recharge.name, recharge.icon, function(button, recharge)
      if recharge.Sound and recharge.Sound ~= "" then
        self:PlayUISound(recharge.Sound)
      end
      FunctionNewRecharge.Instance():OpenUIDefaultPage()
    end, recharge)
    Game.HotKeyTipManager:RegisterHotKeyTip(56, buttonCell.holderSp, NGUIUtil.AnchorSide.TopLeft)
    if recharge.redtiptype then
      self:RegisterRedTipCheckByIds(recharge.redtiptype, self.doujinshiButton, 42)
      self:RegisterRedTipCheckByIds(recharge.redtiptype, button, 42)
      local tip = NewRechargeProxy.Instance:GetHeroRedTip()
      if tip then
        RedTipProxy.Instance:UpdateRedTip(HeroShopTip)
      else
        RedTipProxy.Instance:RemoveWholeTip(HeroShopTip)
      end
    end
    self.rechargeCell = buttonCell
  end
  local auction = moreButton.Auction
  if auction then
    local valid = not FunctionUnLockFunc.CheckForbiddenByFuncState("Auction")
    if valid then
      local button, buttonCell = self:CreateDoujinshiButton(auction.name, auction.icon, function(button, auction)
        if auction.Sound and auction.Sound ~= "" then
          self:PlayUISound(auction.Sound)
        end
        FunctionSecurity.Me():TryDoRealNameCentify(self._doAuction)
      end, auction)
      if auction.redtiptype then
        self:RegisterRedTipCheckByIds(auction.redtiptype, self.doujinshiButton, 42)
        self:RegisterRedTipCheckByIds(auction.redtiptype, button, 42)
      end
      self.auctionCell = buttonCell
    end
  end
end

function MainviewActivityPage:UpdateMoreInfo()
  if not BranchMgr.IsJapan() then
    return
  end
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return
  end
  local depositGO = self.rechargeCell.gameObject
  self.rechargeCell:SetCustomOrder(0)
  depositGO.name = "Deposit"
  depositGO.transform:SetParent(self.addCreditGrid.transform, false)
  table.insert(self.keepActivityCells, 1, self.rechargeCell)
  local auctionCell = self.auctionCell
  if auctionCell then
    depositGO = auctionCell.gameObject
    depositGO.name = "Auction"
    depositGO.transform:SetParent(self.addCreditGrid.transform, false)
    table.insert(self.keepActivityCells, 2, auctionCell)
  end
  self.doujinshiButton:SetActive(false)
end

function MainviewActivityPage._doAuction()
  ServiceAuctionCCmdProxy.Instance:CallReqAuctionInfoCCmd()
end

function MainviewActivityPage:CreateDoujinshiButton(name, icon, event, evenParam)
  local button = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityButtonCell"))
  button.transform:SetParent(self.activityTrans, false)
  button.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  local buttonCtrl = DoujinshiButtonCell.new(button)
  if name and icon then
    buttonCtrl:SetData({name = name, icon = icon})
  end
  self:AddClickEvent(button, function(go)
    event(go, evenParam)
  end)
  self:Reposition()
  local order = buttonCtrl:GetOrder()
  for i = #self.keepActivityCells, 1, -1 do
    local cell = self.keepActivityCells[i]
    if Slua.IsNull(cell.gameObject) then
      table.remove(self.keepActivityCells, i)
    end
  end
  local insertIndex
  for i = 1, #self.keepActivityCells do
    if order < self.keepActivityCells[i]:GetOrder() then
      insertIndex = i
      break
    end
  end
  if not insertIndex then
    table.insert(self.keepActivityCells, buttonCtrl)
  else
    table.insert(self.keepActivityCells, insertIndex, buttonCtrl)
  end
  for i = 1, #self.keepActivityCells do
    self.keepActivityCells[i]:UpdateOrder()
  end
  return button, buttonCtrl
end

function MainviewActivityPage:Reposition()
  if self.activityGrid then
    self.activityGrid:Reposition()
  end
end
