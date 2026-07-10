LoopActIntegrationView = class("LoopActIntegrationView", ContainerView)
LoopActIntegrationView.ViewType = UIViewType.NormalLayer
autoImport("ActivityIntegrationTabCell")
autoImport("ActivityBattlePassView")
autoImport("ActivityFlipCardView")
autoImport("ActivityIntegrationTaskSubView")
autoImport("ActivityIntegrationTaskSubViewType2")
autoImport("LoopActBannerSubView")
autoImport("LoopActIntegrationProxy")
autoImport("ActivityIntegrationShopSubView")
autoImport("ActivityIntegrationLotteryRaidShopSubView")
autoImport("ActivityDungeonMvpCardView")
autoImport("ActivityPaySignView")
local picIns = PictureManager.Instance
local DefaultDecorateTexName = "activityintegration_bg_bottom_01"

function LoopActIntegrationView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function LoopActIntegrationView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.u_bgTex = self:FindComponent("MainBG", UITexture, self.gameObject)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.tabLine = self:FindGO("TabLine", self.gameObject):GetComponent(UISprite)
  self.tagScrollView = self:FindGO("TagScrollView"):GetComponent(UIScrollView)
  self.tabGrid = self:FindGO("TabGrid"):GetComponent(UIGrid)
  self.tabSelectListCtrl = UIGridListCtrl.new(self.tabGrid, ActivityIntegrationTabCell, "ActivityIntegrationTabCell")
  self.tabSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTabCell, self)
  self.bottom_01 = self:FindComponent("bottom_01", UITexture, self.gameObject)
end

function LoopActIntegrationView:AddMapEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function LoopActIntegrationView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function LoopActIntegrationView:OnEnter()
  if not self.uiMediator then
    self.uiMediator = UIMediator.new(self.__cname, self)
  end
  if self.uiMediator then
    GameFacade.Instance:registerMediator(self.uiMediator)
  end
end

function LoopActIntegrationView:OnExit()
  if self.uiMediator then
    GameFacade.Instance:removeMediator(self.uiMediator.mediatorName)
  end
  LoopActIntegrationView.super.OnExit(self)
end

function LoopActIntegrationView:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.currentTab = viewdata and viewdata.tab
  self.groupID = viewdata and viewdata.group or 1
  local groupInfo = LoopActIntegrationProxy.Instance:GetGroupInfo(self.groupID)
  self.activityIDs = groupInfo and groupInfo.activityIDs
  self.bannerActivityID = groupInfo and groupInfo.bannerActivityID
  self.validIDs = viewdata and viewdata.ids
end

function LoopActIntegrationView:CheckIdValid(id)
  if not self.validIDs then
    return false
  end
  if TableUtility.ArrayFindIndex(self.validIDs, id) > 0 then
    return true
  end
  return false
end

local RedTipMap = {
  [1] = SceneTip_pb.EREDSYS_ACT_BP,
  [2] = SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE,
  [3] = ActivityFlipCardProxy.RedTipId,
  [ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN] = SceneTip_pb.EREDSYS_ACT_PAY_SIGN
}

function LoopActIntegrationView:InitShow()
  self:InitSubViewLoaders()
  local tabList = {}
  if self.bannerActivityID then
    local bannerStaticData = Table_ActivityNew[self.bannerActivityID]
    if bannerStaticData then
      local groupID = bannerStaticData.Group or 1
      local monthlyRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
      local hasRewards = monthlyRewards and 0 < #monthlyRewards
      if hasRewards then
        local timeValid, realStartTime, realEndTime = LoopActIntegrationProxy.Instance:CheckTimeValid(bannerStaticData)
        local startTimeStr, endTimeStr
        if timeValid and realStartTime and realEndTime then
          local format = "%d-%d-%d %d:%d:%d"
          local startTimeTable = ServerTime.Ori_OsDate("*t", realStartTime)
          local endTimeTable = ServerTime.Ori_OsDate("*t", realEndTime)
          startTimeStr = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
          endTimeStr = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
        end
        local bannerData = {
          startTime = startTimeStr,
          endTime = endTimeStr,
          id = self.bannerActivityID,
          staticData = bannerStaticData,
          isBanner = true
        }
        table.insert(tabList, bannerData)
      end
    end
  end
  if self.activityIDs and 0 < #self.activityIDs then
    for i = 1, #self.activityIDs do
      local activityID = self.activityIDs[i]
      local staticData = Table_ActivityNew[activityID]
      if staticData then
        local subType = LoopActIntegrationProxy.Instance:GetSubType(staticData)
        local isValid = LoopActIntegrationProxy.Instance:CheckActivityValid(activityID)
        redlog("CheckActivityValid", activityID, tostring(isValid))
        if subType and self.subViews[subType] and (isValid or self:CheckIdValid(activityID)) then
          local redtip = RedTipMap[subType]
          local subRedtip
          if subType == 1 then
            subRedtip = staticData.id
          elseif subType == 2 then
            subRedtip = staticData.id
          elseif subType == 3 then
            subRedtip = staticData.Params and staticData.Params.ActivityId or staticData.id
          elseif subType == ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN then
            subRedtip = activityID
          end
          local startTime, endTime = LoopActIntegrationProxy.Instance:GetActivityTime(staticData)
          local startTimeStr, endTimeStr
          if startTime and endTime then
            local format = "%d-%d-%d %d:%d:%d"
            local startTimeTable = ServerTime.Ori_OsDate("*t", startTime)
            local endTimeTable = ServerTime.Ori_OsDate("*t", endTime)
            startTimeStr = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
            endTimeStr = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
          end
          local data = {
            startTime = startTimeStr,
            endTime = endTimeStr,
            id = activityID,
            staticData = staticData,
            Redtip = redtip,
            subRedtip = subRedtip
          }
          table.insert(tabList, data)
        end
      end
    end
  end
  if 1 < #tabList then
    local bannerTab = tabList[1].isBanner and table.remove(tabList, 1) or nil
    table.sort(tabList, function(a, b)
      if a.startTime and b.startTime then
        return a.startTime < b.startTime
      elseif a.startTime then
        return true
      elseif b.startTime then
        return false
      else
        return a.id < b.id
      end
    end)
    if bannerTab then
      table.insert(tabList, 1, bannerTab)
    end
  end
  self.tabList = tabList
  self.tabSelectListCtrl:ResetDatas(self.tabList)
  self.tabLine.width = 42 + (#tabList - 1) * 148.2
  self:LoadSubViews(tabList)
  local cells = self.tabSelectListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data.Redtip then
      self:RegisterRedTipCheck(cells[i].data.Redtip, cells[i].gameObject, 42, {-90, -30}, nil, cells[i].data.subRedtip)
    end
  end
  if self.currentTab then
    local cells = self.tabSelectListCtrl:GetCells()
    for i = 1, #self.tabList do
      if self.tabList[i].id == self.currentTab then
        if cells[i] then
          self:handleClickTabCell(cells[i])
        end
        return
      end
    end
  end
  if 0 < #self.tabList then
    local cells = self.tabSelectListCtrl:GetCells()
    if cells[1] then
      self:handleClickTabCell(cells[1])
    end
  end
end

function LoopActIntegrationView:InitSubViewLoaders()
  if self.subViews then
    return
  end
  self.subViews = {}
  local loadBannerView = function(viewdata)
    if not self.bannerView then
      self.bannerView = self:AddSubView("LoopActBannerSubView", LoopActBannerSubView, self.subViewContainer, viewdata)
      self.bannerView.parentView = self
      self.bannerView.gameObject:SetActive(false)
    end
    return self.bannerView
  end
  local loadBPView = function(viewdata)
    if not self.bpView then
      self.bpView = self:AddSubView("ActivityBattlePassView", ActivityBattlePassView, nil, viewdata)
      self.bpView.parentView = self
      self.bpView.gameObject:SetActive(false)
    end
    return self.bpView
  end
  local loadTaskView = function(viewdata)
    local taskType = viewdata and viewdata.Type
    if taskType == 2 then
      if not self.taskViewType2 then
        self.taskViewType2 = self:AddSubView("ActivityIntegrationTaskSubViewType2", ActivityIntegrationTaskSubViewType2, nil, viewdata)
        self.taskViewType2.parentView = self
        self.taskViewType2.gameObject:SetActive(false)
      end
      return self.taskViewType2
    else
      if not self.taskView then
        self.taskView = self:AddSubView("ActivityIntegrationTaskSubView", ActivityIntegrationTaskSubView, nil, viewdata)
        self.taskView.parentView = self
        self.taskView.gameObject:SetActive(false)
      end
      return self.taskView
    end
  end
  local loadFlipCardView = function(viewdata)
    if not self.flipCardView then
      self.flipCardView = self:AddSubView("ActivityFlipCardView", ActivityFlipCardView, nil, viewdata)
      self.flipCardView.parentView = self
      self.flipCardView.gameObject:SetActive(false)
    end
    return self.flipCardView
  end
  local loadShopView = function(viewdata)
    if not self.shopView then
      self.shopView = self:AddSubView("ActivityIntegrationShopSubView", ActivityIntegrationShopSubView, nil, viewdata)
      self.shopView.parentView = self
      self.shopView.gameObject:SetActive(false)
    end
    return self.shopView
  end
  local loadLotteryRaidShopView = function(viewdata)
    if not self.lotteryRaidShopView then
      self.lotteryRaidShopView = self:AddSubView("ActivityIntegrationLotteryRaidShopSubView", ActivityIntegrationLotteryRaidShopSubView, nil, viewdata)
      self.lotteryRaidShopView.parentView = self
      self.lotteryRaidShopView.gameObject:SetActive(false)
    end
    return self.lotteryRaidShopView
  end
  local loadDungeonMvpCardView = function(viewdata)
    if not self.dungeonMvpCardView then
      self.dungeonMvpCardView = self:AddSubView("ActivityDungeonMvpCardView", ActivityDungeonMvpCardView, nil, viewdata)
      self.dungeonMvpCardView.parentView = self
      self.dungeonMvpCardView.gameObject:SetActive(false)
    end
    return self.dungeonMvpCardView
  end
  local loadPaySignView = function(viewdata)
    if not self.paySignView then
      self.paySignView = self:AddSubView("ActivityPaySignView", ActivityPaySignView, nil, viewdata)
      self.paySignView.parentView = self
      self.paySignView.gameObject:SetActive(false)
    end
    return self.paySignView
  end
  self.subViews.banner = loadBannerView
  self.subViews[1] = loadBPView
  self.subViews[2] = loadTaskView
  self.subViews[3] = loadFlipCardView
  self.subViews[4] = loadShopView
  self.subViews[14] = loadLotteryRaidShopView
  self.subViews[12] = loadDungeonMvpCardView
  self.subViews[ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN] = loadPaySignView
end

function LoopActIntegrationView:LoadSubViews(tabList)
  if not tabList or #tabList == 0 then
    return
  end
  self:InitSubViewLoaders()
  for i = 1, #tabList do
    local data = tabList[i]
    local staticData = data.staticData
    if staticData then
      if data.isBanner then
        if self.subViews.banner then
          local viewdata = data
          self.subViews.banner(viewdata)
        end
      else
        local subType = LoopActIntegrationProxy.Instance:GetSubType(staticData)
        if subType and self.subViews[subType] then
          local viewdata = self:GetViewDataForSubType(subType, staticData)
          self.subViews[subType](viewdata)
        end
      end
    end
  end
end

function LoopActIntegrationView:GetViewDataForSubType(subType, staticData)
  local activityId = staticData.Params and staticData.Params.ActivityId or staticData.id
  if subType == 1 then
    return {ActivityId = activityId}
  elseif subType == 2 then
    return {
      activityId = staticData.id,
      Type = staticData.Params_Inte and staticData.Params_Inte.Type
    }
  elseif subType == 3 then
    return {ActivityId = activityId}
  elseif subType == 12 then
    local bgName = staticData.Params_Inte and staticData.Params_Inte.Texture or ""
    local gotoMode = staticData.Misc and staticData.Misc.ShortCutPower
    local cardId = LoopActIntegrationProxy.Instance:GetBossSceneSeasonCardId(staticData.id)
    return {
      Texture = bgName,
      Item = cardId,
      GoToMode = gotoMode
    }
  elseif subType == ActivityCmd_pb.GACTIVITY_ACT_PAY_SIGN then
    return {ActivityId = activityId}
  end
  return {}
end

function LoopActIntegrationView:handleClickTabCell(cellCtrl)
  if not cellCtrl then
    return
  end
  local data = cellCtrl.data
  if not data then
    return
  end
  local staticData = data.staticData
  if not staticData then
    return
  end
  local id = data.id
  local subType
  if data.isBanner then
    subType = "banner"
  else
    subType = LoopActIntegrationProxy.Instance:GetSubType(staticData)
  end
  if not (subType and self.subViews) or not self.subViews[subType] then
    return
  end
  local viewdata
  if data.isBanner then
    viewdata = data
  else
    viewdata = self:GetViewDataForSubType(subType, staticData)
  end
  local subView = self.subViews[subType](viewdata)
  if self.currentSubView and self.currentSubView ~= subView then
    self.currentSubView.gameObject:SetActive(false)
    if self.currentSubView.OnHide then
      self.currentSubView:OnHide()
    end
  elseif self.currentSubType and self.currentSubType ~= subType then
    local prevSubView = self.subViews[self.currentSubType]()
    if prevSubView then
      prevSubView.gameObject:SetActive(false)
      if prevSubView.OnHide then
        prevSubView:OnHide()
      end
    end
  end
  self.currentSubType = subType
  self.currentSubView = subView
  self.currentTab = id
  self.currentData = data
  if subView then
    subView.gameObject:SetActive(true)
    if subView.OnShow then
      subView:OnShow()
    end
    if subView.OnEnter then
      if data.isBanner then
        subView:OnEnter(data)
      else
        subView:OnEnter(staticData.id)
      end
    end
  end
  self:ChangeSubSelectorOnSelect(staticData.id)
  local bgTextureName = staticData.BgTextture
  if not bgTextureName or bgTextureName == "" then
    bgTextureName = "mall_twistedegg_bg_bottom"
  end
  self:HandleSwitchBG(bgTextureName)
end

function LoopActIntegrationView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.tabSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local sstab = ssCells[i].data.staticData.id
    ssCells[i]:SetSelect(sstab == id)
  end
end

function LoopActIntegrationView:HandleSwitchBG(textureName)
  if self.textureName and textureName == self.textureName then
    return
  end
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.u_bgTex)
  end
  self.textureName = textureName
  PictureManager.Instance:SetUI(self.textureName, self.u_bgTex)
end

function LoopActIntegrationView:Destroy()
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.u_bgTex)
    self.textureName = nil
  end
  if self.bpView then
    self.bpView:CloseSelf()
    self.bpView = nil
  end
  if self.taskView then
    self.taskView:CloseSelf()
    self.taskView = nil
  end
  if self.taskViewType2 then
    self.taskViewType2:CloseSelf()
    self.taskViewType2 = nil
  end
  if self.flipCardView then
    self.flipCardView:CloseSelf()
    self.flipCardView = nil
  end
  if self.tabSelectListCtrl then
    self.tabSelectListCtrl:Destroy()
    self.tabSelectListCtrl = nil
  end
  self.subViews = nil
  self.currentSubType = nil
  self.currentSubView = nil
end

return LoopActIntegrationView
