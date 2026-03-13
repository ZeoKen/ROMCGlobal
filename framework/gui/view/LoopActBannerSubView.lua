LoopActBannerSubView = class("LoopActBannerSubView", SubView)
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationPreviewSubView")
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  Gift_01 = "activityintegration_bg_gift_01",
  Gift_02 = "activityintegration_bg_gift_02",
  Gift_03 = "activityintegration_bg_gift_03",
  Ornament = "activityintegration_bg_ornament",
  Bg_title = "activityintegration_bg_title",
  Bg_01 = "activityintegration_bg_01"
}

function LoopActBannerSubView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self.inited = true
end

function LoopActBannerSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "LoopActBannerSubView"
  self.gameObject = obj
end

function LoopActBannerSubView:FindObjs()
  self:LoadSubView()
  local rootGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPart("ActivityIntegrationPreview_Root6"))
  rootGO.name = "Root"
  rootGO.transform:SetParent(self.gameObject.transform, false)
  rootGO:SetActive(true)
  self.curRoot = rootGO
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  if upPanel then
    local panels = rootGO:GetComponentsInChildren(UIPanel)
    for i = 1, #panels do
      panels[i].depth = upPanel.depth + panels[i].depth
    end
  end
  self.helpBtn = self:FindGO("HelpBtn", self.curRoot)
  local titleGO = self:FindGO("TitleLabel", self.curRoot)
  if titleGO then
    self.titleLabel = titleGO:GetComponent(UILabel)
    local shadowGO = self:FindGO("TitleLabelShadow", self.curRoot)
    if shadowGO then
      self.titleShadowLabel = shadowGO:GetComponent(UILabel)
    end
  end
  local bgGO = self:FindGO("BgTexture", self.curRoot)
  if bgGO then
    self.bgTexture = bgGO:GetComponent(UITexture)
  end
  local timeGO = self:FindGO("TimeLabel", self.curRoot)
  if timeGO then
    self.timeLabel = timeGO:GetComponent(UILabel)
  end
  local descGO = self:FindGO("DescLabel", self.curRoot)
  if descGO then
    self.descLabel = descGO:GetComponent(UILabel)
  end
  local innerBGGO = self:FindGO("DescInnerBg", self.curRoot)
  if innerBGGO then
    self.descInnerBg = innerBGGO:GetComponent(UISprite)
  end
  local descOutlineGO = self:FindGO("DescOutline", self.curRoot)
  if descOutlineGO then
    self.descOutline = descOutlineGO:GetComponent(UISprite)
  end
  self.gotoBtn = self:FindGO("GoToBtn", self.curRoot)
  self.shortCutContainer = self:FindGO("ShortCutContainer", self.curRoot)
  if self.shortCutContainer then
    local childCount = self.shortCutContainer.gameObject.transform.childCount or 0
    if 0 < childCount then
      for i = 1, childCount do
        local go = self:FindGO("ShortCut" .. i, self.shortCutContainer)
        if go then
          self:AddClickEvent(go, function()
            self:HandleClickShortCut(i, go)
          end)
        end
      end
    end
  end
  self.timeLabels = {}
  self.timeLabelContainer = self:FindGO("TimeLabelContainer", self.curRoot)
  if self.timeLabelContainer then
    local childCount = self.timeLabelContainer.gameObject.transform.childCount or 0
    if 0 < childCount then
      for i = 1, childCount do
        local go = self:FindGO("Label" .. i, self.timeLabelContainer)
        if go then
          local label = go:GetComponent(UILabel)
          self.timeLabels[i] = label
        end
      end
    end
  end
  self.colliders = {}
  self.itemTipContainer = self:FindGO("ItemTipContainer", self.curRoot)
  if self.itemTipContainer then
    local childCount = 8
    for i = 1, childCount do
      local collider = self:FindGO("Collider" .. i, self.itemTipContainer)
      if collider then
        self:AddClickEvent(collider, function()
          self:HandleShowItemTip(i, collider)
        end)
        self.colliders[i] = collider
      end
    end
  end
  self.infoLists = {}
  self.itemAndNameContainer = self:FindGO("IconNameContainer", self.curRoot)
  if self.itemAndNameContainer then
    local childCount = 12
    for i = 1, childCount do
      local bgGO = self:FindGO("Icon" .. i, self.itemAndNameContainer)
      if bgGO then
        local singleInfo = {
          go = bgGO,
          bg = bgGO:GetComponent(UISprite),
          icon = self:FindGO("Icon", bgGO):GetComponent(UISprite),
          label = self:FindGO("Label", bgGO):GetComponent(UILabel)
        }
        local labelBgGO = self:FindGO("LabelBG", bgGO)
        if labelBgGO then
          singleInfo.labelBg = labelBgGO:GetComponent(UISprite)
        end
        self.infoLists[i] = singleInfo
      end
    end
  end
  if decorateTextureNameMap then
    for objName, _ in pairs(decorateTextureNameMap) do
      local obj = self:FindComponent(objName, UITexture, self.curRoot)
      if obj then
        self[objName] = obj
      end
    end
  end
end

function LoopActBannerSubView:AddViewEvts()
  if self.gotoBtn then
    self:AddClickEvent(self.gotoBtn, function()
      self:OnClickGotoBtn()
    end)
  end
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self:OnClickHelpBtn()
    end)
  end
end

function LoopActBannerSubView:AddMapEvts()
end

function LoopActBannerSubView:OnEnter(bannerData)
  LoopActBannerSubView.super.OnEnter(self)
  if not bannerData then
    return
  end
  self.bannerData = bannerData
  self.staticData = self.bannerData.staticData
  self.activityID = self.bannerData.id
  xdlog("OnEnter", self.activityID, self.staticData.TitleName)
  self:RefreshPage()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeLabel()
  end, self, 1)
end

function LoopActBannerSubView:RefreshPage()
  if not self.staticData then
    return
  end
  if self.gameObject then
    self.gameObject:SetActive(true)
  end
  if self.titleLabel and self.staticData.TitleName then
    self.titleLabel.text = self.staticData.TitleName
    if self.titleShadowLabel then
      self.titleShadowLabel.text = self.staticData.TitleName
    end
  end
  if self.descLabel then
    local descStr = self.staticData.Desc or self.staticData.TabDesc or ""
    if descStr and descStr ~= "" then
      self.descLabel.gameObject:SetActive(true)
      self.descLabel.text = descStr
      if self.descInnerBg then
        local printedY = self.descLabel.printedSize.y
        self.descInnerBg.height = printedY + 40
      end
      if self.descOutline then
        local printedY = self.descLabel.printedSize.y
        self.descOutline.height = printedY + 48
      end
    else
      self.descLabel.gameObject:SetActive(false)
    end
  end
  if self.timeLabel then
    self:UpdateTimeLabel()
  end
  self:UpdateTimeLabels()
  if self.bgTexture and self.staticData.Params_Inte and self.staticData.Params_Inte.Texture and self.staticData.Params_Inte.Texture ~= "" then
    self:LoadBgTexture(self.staticData.Params_Inte.Texture)
  end
  self:UpdateDecorateTextures()
  self:UpdateItemIcons()
  self:UpdateShortCuts()
  if self.gotoBtn then
    local gotoShortcut = self.staticData.Params_Inte and self.staticData.Params_Inte.GotoShortcut
    self.gotoBtn:SetActive(gotoShortcut ~= nil)
  end
  if self.helpBtn then
    local helpId = self.staticData.Params_Inte and self.staticData.Params_Inte.HelpId
    self.helpBtn:SetActive(helpId ~= nil)
  end
end

function LoopActBannerSubView:UpdateTimeLabel()
  if not self.timeLabel or not self.staticData then
    return
  end
  local timeValid, realStartTime, realEndTime = LoopActIntegrationProxy.Instance:CheckTimeValid(self.staticData)
  if timeValid and realStartTime and realEndTime then
    local currentTime = ServerTime.CurServerTime() / 1000
    local leftTime = realEndTime - currentTime
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      local timeText
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
    end
  else
    self.timeLabel.text = ""
  end
end

function LoopActBannerSubView:LoadBgTexture(textureName)
  if not self.bgTexture or not textureName then
    return
  end
  self.bgTextureName = textureName
  picIns:SetUI(textureName, self.bgTexture)
end

function LoopActBannerSubView:UpdateTimeLabels()
  if not self.timeLabels or #self.timeLabels == 0 then
    return
  end
  local timeLabels = {}
  if LoopActIntegrationProxy.Instance then
    local groupID = self.staticData and self.staticData.Group or 1
    local currentMonthRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
    if currentMonthRewards and 0 < #currentMonthRewards then
      for i, reward in ipairs(currentMonthRewards) do
        if reward.realStartTime and reward.realEndTime then
          local startDate = ServerTime.Ori_OsDate("*t", reward.realStartTime)
          local endDate = ServerTime.Ori_OsDate("*t", reward.realEndTime)
          local timeStr = string.format("%02d.%02d ~ %02d.%02d", startDate.month, startDate.day, endDate.month, endDate.day)
          table.insert(timeLabels, timeStr)
        end
      end
    end
  end
  if #timeLabels == 0 and self.staticData.Params_Inte and self.staticData.Params_Inte.TimeLabels then
    timeLabels = self.staticData.Params_Inte.TimeLabels
  end
  if 0 < #timeLabels then
    for i = 1, #self.timeLabels do
      if timeLabels[i] then
        self.timeLabels[i].gameObject:SetActive(true)
        self.timeLabels[i].text = timeLabels[i]
      else
        self.timeLabels[i].gameObject:SetActive(false)
      end
    end
  else
    for i = 1, #self.timeLabels do
      self.timeLabels[i].gameObject:SetActive(false)
    end
  end
end

function LoopActBannerSubView:UpdateItemIcons()
  if not self.infoLists or #self.infoLists == 0 then
    return
  end
  local itemList = {}
  if LoopActIntegrationProxy.Instance then
    local groupID = self.staticData and self.staticData.Group or 1
    local currentMonthRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
    if currentMonthRewards and 0 < #currentMonthRewards then
      for _, reward in ipairs(currentMonthRewards) do
        table.insert(itemList, {
          reward.item,
          1,
          reward.name,
          reward.actID
        })
      end
    end
  end
  if #itemList == 0 and self.staticData.Params_Inte and self.staticData.Params_Inte.ShowItems then
    itemList = self.staticData.Params_Inte.ShowItems
  end
  for i = 1, #self.infoLists do
    local info = self.infoLists[i]
    if itemList[i] then
      local itemId = itemList[i][1]
      local itemCount = itemList[i][2] or 1
      local itemName = itemList[i][3]
      local actID = itemList[i][4]
      info.go:SetActive(true)
      if info.icon then
        local itemConfig = Table_Item[itemId]
        if itemConfig then
          local setSuc = false
          if itemConfig.Type == 1200 then
            setSuc = IconManager:SetFaceIcon(itemConfig.Icon, info.icon)
            if not setSuc then
              setSuc = IconManager:SetFaceIcon("boli", info.icon)
            end
          else
            setSuc = IconManager:SetItemIcon(itemConfig.Icon, info.icon)
            setSuc = setSuc or IconManager:SetItemIcon("item_45001", info.icon)
          end
          info.icon:MakePixelPerfect()
          info.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
        end
      end
      if info.label then
        if itemName and itemName ~= "" then
          info.label.gameObject:SetActive(true)
          info.label.text = itemName
        else
          local itemConfig = Table_Item[itemId]
          if itemConfig and itemConfig.Name then
            info.label.gameObject:SetActive(true)
            info.label.text = itemConfig.Name
          else
            info.label.gameObject:SetActive(false)
          end
        end
      end
      if self.colliders[i] then
        self.colliders[i]:SetActive(true)
      end
    else
      info.go:SetActive(false)
      if self.colliders[i] then
        self.colliders[i]:SetActive(false)
      end
    end
  end
end

function LoopActBannerSubView:UpdateShortCuts()
  if not self.shortCutContainer then
    return
  end
  local currentMonthRewards = {}
  if LoopActIntegrationProxy.Instance then
    local groupID = self.staticData and self.staticData.Group or 1
    currentMonthRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
  end
  local childCount = self.shortCutContainer.gameObject.transform.childCount or 0
  for i = 1, childCount do
    local go = self:FindGO("ShortCut" .. i, self.shortCutContainer)
    if go then
      if currentMonthRewards[i] then
        go:SetActive(true)
      else
        go:SetActive(false)
      end
    end
  end
end

function LoopActBannerSubView:UpdateDecorateTextures()
  if not decorateTextureNameMap or not self.staticData then
    return
  end
  self.decorateTextures = {}
  for objName, textureName in pairs(decorateTextureNameMap) do
    local texture = self[objName]
    if texture then
      self.decorateTextures[objName] = textureName
      picIns:SetUI(textureName, texture)
    end
  end
  if self.staticData.Params_Inte and self.staticData.Params_Inte.DecorateTextures then
    local customDecorateTextures = self.staticData.Params_Inte.DecorateTextures
    for objName, textureName in pairs(customDecorateTextures) do
      local texture = self[objName]
      if texture and textureName ~= "" then
        self.decorateTextures[objName] = textureName
        picIns:SetUI(textureName, texture)
      end
    end
  end
end

function LoopActBannerSubView:HandleShowItemTip(index, collider)
  local groupID = self.staticData and self.staticData.Group or 1
  local currentMonthRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
  if not currentMonthRewards or not currentMonthRewards[index] then
    return
  end
  local reward = currentMonthRewards[index]
  local actID = reward.actID
  local itemId = reward.item
  if itemId then
    MsgManager.ShowItemTipById(itemId, collider)
  end
end

function LoopActBannerSubView:HandleClickShortCut(index, go)
  local groupID = self.staticData and self.staticData.Group or 1
  local currentMonthRewards = LoopActIntegrationProxy.Instance:GetMonthlyShowInfo(groupID)
  if not currentMonthRewards or not currentMonthRewards[index] then
    return
  end
  local reward = currentMonthRewards[index]
  local actID = reward.actID
  local activityConfig = Table_ActivityNew[actID]
  if not activityConfig then
    redlog("LoopActBannerSubView:HandleClickShortCut 找不到活动配置, actID:", actID)
    return
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  local realStartTime = reward.realStartTime
  local realEndTime = reward.realEndTime
  if realStartTime and currentTime < realStartTime then
    redlog("活动未开始", currentTime, realStartTime, actID)
    MsgManager.FloatMsg(nil, ZhString.DisneyOverview_Time_OpenLater)
    return
  end
  if realEndTime and currentTime > realEndTime then
    MsgManager.FloatMsg(nil, ZhString.DisneyOverview_Time_Closed)
    return
  end
  local handleNpcPathfinding = function(activityConfig, actID)
    local npcs = activityConfig.Npcs
    if npcs and next(npcs) then
      local npcConfig = npcs[1]
      if npcConfig then
        local cmdArgs = {}
        cmdArgs.targetMapID = npcConfig.map
        if npcConfig.pos and #npcConfig.pos >= 3 then
          local tempPos = LuaVector3.Zero()
          LuaVector3.Better_Set(tempPos, npcConfig.pos[1], npcConfig.pos[2], npcConfig.pos[3])
          cmdArgs.targetPos = tempPos
        end
        cmdArgs.npcID = npcConfig.id
        cmdArgs.distance = 2
        local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)
        if cmd then
          Game.Myself:TryUseQuickRide()
          Game.Myself:Client_SetMissionCommand(cmd)
          if self.parentView then
            self.parentView:CloseSelf()
          end
          return true
        else
          redlog("LoopActBannerSubView:HandleClickShortCut 创建MissionCommand失败, actID:", actID)
          return false
        end
      else
        redlog("LoopActBannerSubView:HandleClickShortCut NPC配置为空, actID:", actID)
        return false
      end
    else
      redlog("LoopActBannerSubView:HandleClickShortCut 活动缺少Npcs配置, actID:", actID)
      return false
    end
  end
  local actType = activityConfig.Type
  local groupID = activityConfig.Group or 1
  if actType == 1043 or actType == "1043" then
    if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < 12 then
      MsgManager.ShowMsgByID(3250)
      return
    end
    local realActivityId = activityConfig.ID or actID
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DayloginNewbiePanel,
      viewdata = {id = realActivityId}
    })
  elseif actType == 1021 or actType == "1021" or actType == "exchange_gifts" then
    handleNpcPathfinding(activityConfig, actID)
  elseif actType == "new_server_challenge" or actType == "act_bp" or actType == "flip_card" or actType == "boss_scene_season" then
    if self.parentView and self.parentView.tabList then
      local targetCell
      local cells = self.parentView.tabSelectListCtrl:GetCells()
      for i = 1, #self.parentView.tabList do
        if self.parentView.tabList[i].id == actID then
          targetCell = cells[i]
          break
        end
      end
      if targetCell then
        self.parentView:handleClickTabCell(targetCell)
      else
        redlog("LoopActBannerSubView:HandleClickShortCut 未找到对应页签, actID:", actID)
      end
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LoopActIntegrationView,
        viewdata = {group = groupID, tab = actID}
      })
    end
  else
    redlog("LoopActBannerSubView:HandleClickShortCut 未处理的活动类型, Type:", actType)
  end
end

function LoopActBannerSubView:OnClickGotoBtn()
  if not self.staticData or not self.staticData.Params_Inte then
    return
  end
  local gotoShortcut = self.staticData.Params_Inte.GotoShortcut
  if gotoShortcut then
    FuncShortCutFunc.Me():CallByID(gotoShortcut)
    if self.parentView then
      self.parentView:CloseSelf()
    end
  end
end

function LoopActBannerSubView:OnClickHelpBtn()
  if not self.staticData or not self.staticData.Params_Inte then
    return
  end
  local helpId = self.staticData.Params_Inte.HelpId
  if helpId then
    MsgManager.ShowMsgByIDTable(helpId)
  end
end

function LoopActBannerSubView:RegisterMapEvts()
  SubView.RegisterMapEvts(self)
end

function LoopActBannerSubView:UnRegisterMapEvts()
  SubView.UnRegisterMapEvts(self)
end

function LoopActBannerSubView:OpenView()
  SubView.OpenView(self)
  self:InitShow()
end

function LoopActBannerSubView:CloseView()
  SubView.CloseView(self)
end

function LoopActBannerSubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.bgTextureName and self.bgTexture then
    picIns:UnLoadUI(self.bgTextureName, self.bgTexture)
    self.bgTextureName = nil
  end
  if self.decorateTextures then
    for objName, texName in pairs(self.decorateTextures) do
      local texture = self[objName]
      if texture then
        picIns:UnLoadUI(texName, texture)
      end
    end
    self.decorateTextures = nil
  end
  SubView.OnExit(self)
end

return LoopActBannerSubView
