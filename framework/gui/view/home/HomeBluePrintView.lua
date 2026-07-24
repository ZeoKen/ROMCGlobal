autoImport("HomeBluePrintRecommendPage")
autoImport("HomeBluePrintCollectionPage")
autoImport("HomeBluePrintMyPage")
autoImport("HomeBuildingSceneBPControl")
HomeBluePrintView = class("HomeBluePrintView", ContainerView)
HomeBluePrintView.ViewType = UIViewType.PopUpLayer
local TabName = {
  [1] = ZhString.HomeBluePrint_Recommend,
  [2] = ZhString.HomeBluePrint_Collection,
  [3] = ZhString.HomeBluePrint_My
}
local BpTexName = "home_compose_BG4"

function HomeBluePrintView:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function HomeBluePrintView:AddListenEvts()
end

function HomeBluePrintView:FindObjs()
  local toggleList = {}
  self.toggleIconList = {}
  for i = 1, 3 do
    local toggleObj = self:FindGO("Toggle" .. i)
    local toggleLongPress = toggleObj:GetComponent(UILongPress)
    local bg = self:FindComponent("Background", UISprite, toggleObj)
    
    function toggleLongPress.pressEvent(obj, state)
      self:OnToggleLongPress(bg, state, i)
    end
    
    local icon = self:FindComponent("Icon", UISprite, toggleObj)
    TabNameTip.SwitchShowTabIconOrLabel(icon.gameObject)
    toggleList[#toggleList + 1] = toggleObj
    self.toggleIconList[#self.toggleIconList + 1] = icon
  end
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
  self.recommendPage = self:AddSubView("HomeBluePrintRecommendPage", HomeBluePrintRecommendPage)
  self.collectionPage = self:AddSubView("HomeBluePrintCollectionPage", HomeBluePrintCollectionPage)
  self.myPage = self:AddSubView("HomeBluePrintMyPage", HomeBluePrintMyPage)
  self:AddTabChangeEvent(toggleList[1], self.recommendPage.gameObject, 1)
  self:AddTabChangeEvent(toggleList[2], self.collectionPage.gameObject, 2)
  self:AddTabChangeEvent(toggleList[3], self.myPage.gameObject, 3)
  self.bpTex = self:FindComponent("BpTex", UITexture)
  self.emptyTip = self:FindComponent("EmptyTip", UILabel)
  local btnHelp = self:FindGO("BtnHelp")
  self:RegistShowGeneralHelpByHelpID(10000, btnHelp)
end

function HomeBluePrintView:OnToggleLongPress(sp, state, index)
  TabNameTip.OnLongPress(state, TabName[index], false, sp)
end

function HomeBluePrintView:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  HomeBluePrintView.super.TabChangeHandler(self, key)
  self.bpTex.gameObject:SetActive(key ~= 1)
  if key == 1 then
    self.recommendPage:OnSwitch(true)
  elseif key == 2 then
    self.collectionPage:OnSwitch(true)
  elseif key == 3 then
    self.myPage:OnSwitch(true)
  end
  if not GameConfig.SystemForbid.TabNameTip then
    if self.curKey then
      local icon = self.toggleIconList[self.curKey]
      if icon then
        icon.color = ColorUtil.TabColor_White
      end
    end
    local icon = self.toggleIconList[key]
    if icon then
      icon.color = ColorUtil.TabColor_DeepBlue
    end
  end
  self.curKey = key
  self:RequestCurrentPage()
end

function HomeBluePrintView:OnEnter()
  self.initialRecommendHouseType = self:GetViewDataHouseType()
  if self.recommendPage then
    self.recommendPage:SetHouseType(self.initialRecommendHouseType)
  end
  PictureManager.Instance:SetHomeBluePrint(BpTexName, self.bpTex)
  self:TabChangeHandler(1)
  HomeBluePrintView.super.OnEnter(self)
end

function HomeBluePrintView:OnExit()
  PictureManager.Instance:UnLoadHomeBluePrint(BpTexName, self.bpTex)
  HomeBluePrintView.super.OnExit(self)
end

function HomeBluePrintView:GetViewDataHouseType()
  local viewData = self.viewdata and self.viewdata.viewdata
  return viewData and viewData.houseType
end

function HomeBluePrintView:GetCurrentContextHouseType()
  local cur = HomeProxy.Instance:GetCurHouseData()
  if cur and cur.houseType and cur.houseType ~= 0 then
    return cur.houseType
  end
  if HomeManager.Me():IsSnowRealmMap(Game.MapManager:GetMapID()) then
    return HomeCmd_pb.EHOUSETYPE_SNOW
  end
  return HomeCmd_pb.EHOUSETYPE_PRIVATE
end

function HomeBluePrintView:RequestCurrentPage()
  if self.curKey == 1 then
    self.recommendPage:RequestData()
  elseif self.curKey == 2 then
    ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_QUERY_SELF_COLLECTION)
  elseif self.curKey == 3 then
    ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_QUERY_SELF)
  end
end

function HomeBluePrintView:ApplyBlueprintFromCell(itemData)
  if not itemData then
    return
  end
  if not HomeManager.Me():IsInEditMode() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HomeBlueprintDetailPanel,
      viewdata = itemData
    })
    return
  end
  local curHouseType = self:GetCurrentContextHouseType()
  if itemData.houseType ~= curHouseType then
    MsgManager.ShowMsgByID(43679)
    return
  end
  if itemData.isOfficial then
    local officialBpData = itemData._officialBpData
    if not officialBpData or not officialBpData.inited then
      return
    end
    self:sendNotification(HomeBuildingSceneBPControl.ShowBluePrint, officialBpData)
    self:CloseSelf()
  else
    local bluePrintData = itemData._bpData
    if not bluePrintData then
      return
    end
    HomeBlueprintProxy.Instance:SetCurDisplayingItem(itemData)
    self:sendNotification(HomeBuildingSceneBPControl.ShowBluePrint, bluePrintData)
    self:CloseSelf()
  end
end
