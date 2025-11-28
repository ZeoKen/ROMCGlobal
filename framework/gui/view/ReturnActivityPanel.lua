ReturnActivityPanel = class("ReturnActivityPanel", ContainerView)
ReturnActivityPanel.ViewType = UIViewType.NormalLayer
autoImport("ReturnActivityTaskPage")
autoImport("ReturnActivityShopPage")
autoImport("ReturnActivityDepositPage")
local picIns = PictureManager.Instance
local bgTexturePath = "Sevenroyalfamilies_bg"
local decorateTextureNameMap = {
  DecorateBoli3 = "returnactivity_bg_boli_03",
  Decorate1 = "returnactivity_bg_decorate_01",
  Decorate2 = "returnactivity_bg_decorate_02",
  Decorate3 = "returnactivity_bg_decorate_03",
  Decorate4 = "returnactivity_bg_decorate_04",
  Decorate5 = "returnactivity_bg_decorate_05",
  Coin3 = "returnactivity_bg_coin_03"
}
local decorateTextureNameMap2 = {
  Decorate13 = "Sevenroyalfamilies_bg_decoration13",
  Decorate14 = "Sevenroyalfamilies_bg_decoration14"
}

function ReturnActivityPanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function ReturnActivityPanel:FindObjs()
  self.bgTexture = self:FindGO("bgTexture"):GetComponent(UITexture)
  self.taskPageObj = self:FindGO("TaskPage")
  self.shopPageObj = self:FindGO("ShopPage")
  self.depositPageObj = self:FindGO("DepositPage")
  self.taskPageTog = self:FindGO("taskPageTog")
  self.shopPageTog = self:FindGO("shopPageTog")
  self.depositPageTog = self:FindGO("depositPageTog")
  self.taskPage = self:AddSubView("ReturnActivityTaskPage", ReturnActivityTaskPage)
  self.shopPage = self:AddSubView("ReturnActivityShopPage", ReturnActivityShopPage)
  self.depositPage = self:AddSubView("ReturnActivityDepositPage", ReturnActivityDepositPage)
  self:AddTabChangeEvent(self.taskPageTog, self.taskPageObj, PanelConfig.ReturnActivityTaskPage)
  self:AddTabChangeEvent(self.shopPageTog, self.shopPageObj, PanelConfig.ReturnActivityShopPage)
  self:AddTabChangeEvent(self.depositPageTog, self.depositPageObj, PanelConfig.ReturnActivityDepositPage)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.ReturnActivityTaskPage.tab)
  end
  self.closeBtn = self:FindGO("CloseButton")
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  for objName, _ in pairs(decorateTextureNameMap2) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  self.innerBg = self:FindGO("InnerBg", self.gameObject):GetComponent(UITexture)
  self.activityName = self:FindGO("ActivityName"):GetComponent(UILabel)
  self.costGO = self:FindGO("Cost")
  self.costLabel = self:FindGO("CostLabel", self.costGO):GetComponent(UILabel)
  self.costIcon = self:FindGO("CostIcon", self.costGO):GetComponent(UISprite)
  self.leftTimeLabel = self:FindGO("TimeLeftLabel"):GetComponent(UILabel)
  self.returnBindBtn = self:FindGO("ReturnBindBtn")
  self.returnBindIcon = self:FindGO("BindIcon", self.returnBindBtn):GetComponent(UISprite)
  IconManager:SetUIIcon("icon_130", self.returnBindIcon)
  self.returnBindIcon_TweenRot = self:FindGO("BindIcon", self.returnBindBtn):GetComponent(TweenRotation)
  self.returnBindLight = self:FindGO("BindLight", self.returnBindBtn)
  self.returnBindBtn:SetActive(false)
end

function ReturnActivityPanel:TabChangeHandler(key)
  if not ReturnActivityPanel.super.TabChangeHandler(self, key) then
    return
  end
  if key == PanelConfig.ReturnActivityShopPage.tab then
    if not self.shopPage then
      self.shopPage = self:AddSubView("ReturnActivityShopPage", ReturnActivityShopPage)
    end
    self.shopPage:OnEnter()
  elseif key == PanelConfig.ReturnActivityTaskPage.tab then
    if self.taskPage then
      self.taskPage:OnEnter()
    end
  elseif key == PanelConfig.ReturnActivityDepositPage.tab and self.depositPage then
    self.depositPage:OnEnter()
  end
end

function ReturnActivityPanel:AddEvts()
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
  local helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:RegistShowGeneralHelpByHelpID(35094, helpBtn)
  self:AddClickEvent(self.returnBindBtn, function()
    if ReturnActivityProxy.Instance.isFirstOpen then
      self.returnBindIcon_TweenRot.enabled = false
      self.returnBindIcon.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 26.38)
      self.returnBindLight:SetActive(false)
      ReturnActivityProxy.Instance.isFirstOpen = false
    end
    if not ReturnActivityProxy.Instance.bBind then
      local invitationID = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_USERRETURN_FLAG) or 0
      if invitationID and invitationID ~= 0 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.InviteCodePopView,
          viewdata = {
            BindReward = GameConfig.Return.Feature[invitationID].BindReward
          }
        })
      end
    else
      MsgManager.ShowMsgByID(43126)
    end
  end)
end

function ReturnActivityPanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInfoCmd, self.RefreshLeftTimeLabel)
end

function ReturnActivityPanel:InitDatas()
  local globalActID = ReturnActivityProxy.Instance.curActID
  self.config = globalActID and GameConfig.Return.Feature[globalActID]
  self.costID = self.config and self.config.ShopItemID
  xdlog("当前活动id", globalActID)
  self.activityName.text = GameConfig.Return.Common and GameConfig.Return.Common.ActivityName
end

function ReturnActivityPanel:InitShow()
  local itemData = Table_Item[self.costID]
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
  self:UpdateMoney()
  local type2Shop = self.config and self.config.ShopType2
  local type2Deposit = self.config and self.config.DepositIDs
  if type2Shop or type2Deposit and 0 < #type2Deposit then
    self.depositPageTog.gameObject:SetActive(true)
    self.dotLine = self:FindGO("DotLine"):GetComponent(UISprite)
    self.dotLine.height = 510
  else
    self.depositPageTog.gameObject:SetActive(false)
    self.dotLine = self:FindGO("DotLine"):GetComponent(UISprite)
    self.dotLine.height = 340
  end
end

function ReturnActivityPanel:UpdateMoney()
  local own = BagProxy.Instance:GetItemNumByStaticID(self.costID) or 0
  self.costLabel.text = StringUtil.NumThousandFormat(own)
end

function ReturnActivityPanel:RefreshLeftTimeLabel()
  local day, hour, min, sec = ReturnActivityProxy.Instance:GetActivityEndTime()
  if day and 0 < day then
    self.leftTimeLabel.text = string.format(ZhString.ReturnActivityPanel_LeftTimeDay, day, ZhString.ItemTip_DelRefreshTip_Day)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshLeftTime, self, 1)
  end
  if not BranchMgr.IsJapan() and ReturnActivityProxy.Instance:CheckInvitationValid(ReturnActivityProxy.Instance.curActID) then
    if not ReturnActivityProxy.Instance.bBind then
      self.returnBindBtn:SetActive(true)
      if ReturnActivityProxy.Instance.isFirstOpen then
        self.returnBindIcon_TweenRot.enabled = true
        self.returnBindLight:SetActive(true)
      end
    end
  else
    self.returnBindBtn:SetActive(false)
  end
end

function ReturnActivityPanel:RefreshLeftTime()
  local day, hour, min, sec = ReturnActivityProxy.Instance:GetActivityEndTime()
  self.leftTimeLabel.text = string.format(ZhString.ReturnActivityPanel_LeftTimeHourMin, hour, min)
  if hour <= 0 and min <= 0 and sec <= 0 then
    self:CloseSelf()
  end
end

function ReturnActivityPanel:OnEnter()
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetReturnActivityTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateTextureNameMap2) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  picIns:SetUI("calendar_bg1_picture2", self.innerBg)
end

function ReturnActivityPanel:OnExit()
  ReturnActivityPanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self, 1)
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadReturnActivityTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateTextureNameMap2) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  picIns:UnLoadUI("calendar_bg1_picture2", self.innerBg)
end
