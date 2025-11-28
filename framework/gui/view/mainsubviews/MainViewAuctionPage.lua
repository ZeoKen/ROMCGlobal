autoImport("MainViewAuctionCell")
MainViewAuctionPage = class("MainViewAuctionPage", SubView)
local SHOWTYPE = {More = 1, Public = 2}
local weakDialog = {}

function MainViewAuctionPage:OnExit()
  self:ClearTimeTick()
  MainViewAuctionPage.super.OnExit(self)
end

function MainViewAuctionPage:Init()
  self:AddViewEvt()
  self:InitShow()
end

function MainViewAuctionPage:AddViewEvt()
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, self.UpdateAuction)
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd, self.HandleWeakDialog)
  self:AddListenEvt(ServiceEvent.AuctionCCmdAuctionDialogCCmd, self.HandleAuctionDialog)
  self:AddListenEvt(ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd, self.HandleOverTakePrice)
end

function MainViewAuctionPage:InitShow()
  self.topRightFuncGrid = self:FindGO("TopRightFunc2"):GetComponent(UIGrid)
  self.activityCtl = UIGridListCtrl.new(self.topRightFuncGrid, MainViewAuctionCell, "MainViewAuctionCell")
  self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)
  self.mianViewCountdownData = {}
  self.mianViewCountdownData.type = MainViewButtonType.Auction
  self.mianViewCountdownData.Name = ZhString.Auction_MainViewCountdownName
  self.activityDatas = {}
  self:UpdateAuction()
end

function MainViewAuctionPage:GetAuctionCell()
  return self.container.activityPage.auctionCell
end

function MainViewAuctionPage:InitMoreDatas(isAdd, str)
  local cell = self:GetAuctionCell()
  if cell then
    if isAdd then
      cell:Show()
      if str then
        cell:UpdateLabel(str)
      else
        cell:UpdateLabel(cell.data.Name)
      end
    else
      cell:Hide()
    end
  end
  self.container.activityPage:Reposition()
end

function MainViewAuctionPage:InitActivityDatas(isAdd)
  TableUtility.ArrayClear(self.activityDatas)
  if isAdd then
    TableUtility.ArrayPushBack(self.activityDatas, self.mianViewCountdownData)
  end
  self.activityCtl:ResetDatas(self.activityDatas)
  self.topRightFuncGrid.repositionNow = true
end

function MainViewAuctionPage:UpdateAuction()
  local curState = AuctionProxy.Instance:GetCurrentState()
  if curState == AuctionState.Close then
    self:Clear()
    return
  elseif curState == AuctionState.SignUp or curState == AuctionState.SignUpVerify then
    self.mianViewCountdownData.Name = ZhString.Auction_MainViewCountdownName
  elseif curState == AuctionState.Auction then
    self:AuctionProgress()
    return
  elseif curState == AuctionState.AuctionEnd then
    self:AuctionEnd()
    return
  end
  local totalSec, hour, min, sec = AuctionProxy.Instance:GetAuctionFormatTime()
  if totalSec == nil then
    self:Clear()
    return
  elseif 0 <= totalSec and self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self)
  end
end

function MainViewAuctionPage:UpdateCountdown()
  if GameConfig.Auction == nil or GameConfig.Auction.PublicTime == nil then
    helplog("GameConfig.Auction.PublicTime is nil")
    return
  end
  local showType
  local totalSec, hour, min, sec = AuctionProxy.Instance:GetAuctionFormatTime()
  if totalSec > GameConfig.Auction.PublicTime then
    showType = SHOWTYPE.More
  else
    showType = SHOWTYPE.Public
  end
  if showType ~= self.auctionShowType then
    if showType == SHOWTYPE.More then
      self:IsShowPublic(false)
    elseif showType == SHOWTYPE.Public then
      self:IsShowPublic(true)
      self:SetNormalWeakDialog(93)
    end
  end
  if totalSec then
    local cell = self:GetAuctionCell()
    if cell then
      cell:UpdateAuction(totalSec, hour, min, sec)
    end
    local activityCells = self.activityCtl:GetCells()
    for i = 1, #activityCells do
      activityCells[i]:UpdateAuction(totalSec, min, sec)
    end
  end
  if totalSec < 0 then
    self:ClearTimeTick()
  end
end

function MainViewAuctionPage:AuctionProgress()
  self:ClearTimeTick()
  self.mianViewCountdownData.Name = ZhString.Auction_MainViewProgressName
  self:IsShowPublic(true, ZhString.Auction_ProgressName)
end

function MainViewAuctionPage:AuctionEnd()
  self:ClearTimeTick()
  self.mianViewCountdownData.Name = ZhString.Auction_MainViewEndName
  self:IsShowPublic(false, ZhString.Auction_EndName)
end

function MainViewAuctionPage:IsShowPublic(isShow, str)
  self:InitMoreDatas(true, str)
  self:InitActivityDatas(isShow)
  if isShow then
    self.auctionShowType = SHOWTYPE.Public
  else
    self.auctionShowType = SHOWTYPE.More
  end
end

function MainViewAuctionPage:Clear()
  self:InitMoreDatas(false)
  self:InitActivityDatas(false)
  self:ClearTimeTick()
end

function MainViewAuctionPage:ClearTimeTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function MainViewAuctionPage:ClickButton(cellctl)
  FunctionSecurity.Me():TryDoRealNameCentify(self._clickButton, cellctl.data)
end

function MainViewAuctionPage._clickButton(data)
  if data and data.type == MainViewButtonType.Auction then
    ServiceAuctionCCmdProxy.Instance:CallReqAuctionInfoCCmd()
  end
end

function MainViewAuctionPage:SetNormalWeakDialog(dialogId)
  self:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(dialogId))
end

function MainViewAuctionPage:HandleWeakDialog(note)
  local data = note.body
  if data then
    local dialog = DialogUtil.GetDialogData(92)
    if dialog then
      local itemData = Table_Item[data.itemid]
      if itemData then
        TableUtility.TableClear(weakDialog)
        weakDialog.Speaker = dialog.Speaker
        weakDialog.Text = string.format(dialog.Text, itemData.NameZh)
        self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
      end
    end
  end
end

function MainViewAuctionPage:HandleAuctionDialog(note)
  local data = note.body
  if data then
    local dialog = DialogUtil.GetDialogData(data.msg_id)
    if dialog then
      TableUtility.TableClear(weakDialog)
      weakDialog.Speaker = dialog.Speaker
      weakDialog.Text = string.format(dialog.Text, unpack(data.params))
      self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
    end
  end
end

function MainViewAuctionPage:HandleOverTakePrice(note)
  local data = note.body
  if data then
    self:SetNormalWeakDialog(95)
  end
end
