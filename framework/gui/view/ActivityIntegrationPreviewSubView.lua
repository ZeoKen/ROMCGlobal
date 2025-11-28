ActivityIntegrationPreviewSubView = class("ActivityIntegrationPreviewSubView", SubView)
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationPreviewSubView")
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  [1] = {
    Gift_01 = "activityintegration_bg_gift_01",
    Gift_02 = "activityintegration_bg_gift_02",
    Gift_03 = "activityintegration_bg_gift_03",
    Ornament = "activityintegration_bg_ornament",
    Bg_title = "activityintegration_bg_title",
    Bg_01 = "activityintegration_bg_01"
  },
  [2] = {
    Bg_title = "paidactivity_bg_title_02"
  },
  [4] = {
    Bg_title = "paidactivity_bg_title_02"
  },
  [6] = {
    Gift_01 = "activityintegration_bg_gift_01",
    Gift_02 = "activityintegration_bg_gift_02",
    Gift_03 = "activityintegration_bg_gift_03",
    Ornament = "activityintegration_bg_ornament",
    Bg_title = "activityintegration_bg_title",
    Bg_01 = "activityintegration_bg_01"
  }
}

function ActivityIntegrationPreviewSubView:Init()
  if self.inited then
    return
  end
  self:LoadSubView()
  self.gameObject = self:FindGO("ActivityIntegrationPreviewSubView")
  self.inited = true
end

function ActivityIntegrationPreviewSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "ActivityIntegrationPreviewSubView"
end

function ActivityIntegrationPreviewSubView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function ActivityIntegrationPreviewSubView:FindObjs()
  for i = 1, 8 do
    local targetRoot = self:FindGO("Root" .. i, self.gameObject)
    if targetRoot then
      targetRoot:SetActive(i == self.showType)
      if i == self.showType then
        self.curRoot = targetRoot
      end
    elseif i == self.showType then
      local rootGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPart("ActivityIntegrationPreview_Root" .. self.showType))
      rootGO.name = "Root" .. i
      rootGO.transform:SetParent(self.gameObject.transform, false)
      rootGO:SetActive(true)
      self.curRoot = rootGO
      local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
      local panels = rootGO:GetComponentsInChildren(UIPanel)
      for i = 1, #panels do
        panels[i].depth = upPanel.depth + panels[i].depth
      end
    end
  end
  self.helpBtn = self:FindGO("HelpBtn", self.curRoot)
  local titleGO = self:FindGO("TitleLabel", self.curRoot)
  if titleGO then
    self.titleLabel = titleGO:GetComponent(UILabel)
    self.titleShadowLabel = self:FindGO("TitleLabelShadow", self.curRoot):GetComponent(UILabel)
  end
  self.bgTexture = self:FindGO("BgTexture", self.curRoot):GetComponent(UITexture)
  self.timeLabel = self:FindGO("TimeLabel", self.curRoot):GetComponent(UILabel)
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
  local childCount = self.shortCutContainer and self.shortCutContainer.gameObject.transform.childCount or 0
  if 0 < childCount then
    for i = 1, childCount do
      local go = self:FindGO("ShortCut" .. i, self.shortCutContainer)
      if go then
        self:AddClickEvent(go, function()
          xdlog("todo click", i)
          self:HandleClickShortCut(i, go)
        end)
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
    local childCount = 12
    if 0 < childCount then
      for i = 1, childCount do
        local collider = self:FindGO("Collider" .. i, self.itemTipContainer)
        if collider then
          self:AddClickEvent(collider, function()
            xdlog("click itemtip")
            self:HandleShowItemTip(i, collider)
          end)
          self.colliders[i] = collider
        end
      end
    end
  end
  self.infoLists = {}
  self.itemAndNameContainer = self:FindGO("IconNameContainer", self.curRoot)
  if self.itemAndNameContainer then
    local childCount = 12
    if 0 < childCount then
      for i = 1, childCount do
        local bgGO = self:FindGO("Icon" .. i, self.itemAndNameContainer)
        if bgGO then
          local singleInfo = self.infoLists[i]
          if not singleInfo then
            singleInfo = {
              go = bgGO,
              bg = bgGO:GetComponent(UISprite),
              icon = self:FindGO("Icon", bgGO):GetComponent(UISprite),
              label = self:FindGO("Label", bgGO):GetComponent(UILabel),
              labelBg = self:FindGO("LabelBG", bgGO) ~= nil and self:FindGO("LabelBG", bgGO):GetComponent(UISprite) or nil
            }
            self.infoLists[i] = singleInfo
          end
        end
      end
    end
  end
  if decorateTextureNameMap and decorateTextureNameMap[self.showType] then
    for objName, _ in pairs(decorateTextureNameMap[self.showType]) do
      self[objName] = self:FindComponent(objName, UITexture, self.curRoot)
    end
  end
end

function ActivityIntegrationPreviewSubView:AddViewEvts()
  if self.gotoBtn then
    self:AddClickEvent(self.gotoBtn, function()
      if self.gotomode then
        FuncShortCutFunc.Me():CallByID(self.gotomode)
        if self.container then
          self.container:CloseSelf()
        end
      end
    end)
  end
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self.container:HandleClickHelpBtn(self.helpID)
    end)
  end
end

function ActivityIntegrationPreviewSubView:AddMapEvts()
end

function ActivityIntegrationPreviewSubView:InitDatas()
end

function ActivityIntegrationPreviewSubView:RefreshPage()
  if self.titleLabel then
    self.titleLabel.text = self.staticData.TitleName
  end
  if self.titleShadowLabel then
    self.titleShadowLabel.text = self.staticData.TitleName
  end
  if self.descLabel then
    local descStr = self.staticData.Desc
    if descStr and descStr ~= "" then
      self.descLabel.gameObject:SetActive(true)
      self.descLabel.text = descStr
      local printedY = self.descLabel.printedSize.y
      if self.descInnerBg then
        self.descInnerBg.height = printedY + 14
      end
      if self.descOutline then
        self.descOutline.height = printedY + 16
      end
    else
      self.descLabel.gameObject:SetActive(false)
    end
  end
  self:UpdateTimeLabels()
  self:UpdateInfos()
  local helpID = self.staticData.HelpID
  if self.helpBtn then
    self.helpBtn:SetActive(helpID ~= nil or false)
  end
  local isTF = EnvChannel.IsTFBranch()
  local duration = isTF and self.staticData.TFDuration or self.staticData.Duration
  self.startTime = duration[1] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[1])
  self.endTime = duration[2] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[2])
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self)
end

function ActivityIntegrationPreviewSubView:UpdateTimeLabels()
  local params = self.staticData.Params
  local shortCutGroup = params and params.ShortCut or {}
  local isTF = EnvChannel.IsTFBranch()
  local textColor
  if params.TextColor then
    local _, _textColor = ColorUtil.TryParseHexString(params.TextColor)
    textColor = _textColor
  end
  if shortCutGroup and 0 < #shortCutGroup then
    for i = 1, #shortCutGroup do
      local data = shortCutGroup[i]
      local duration = isTF and data.TFDuration or data.Duration
      if duration then
        local startTime, endTime
        startTime = duration[1]
        endTime = duration[2]
        if startTime and endTime then
          local str = ""
          local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
          local year, month, day, hour, min, sec = startTime:match(p)
          str = str .. tonumber(month) .. "." .. tonumber(day) .. "~"
          year, month, day, hour, min, sec = endTime:match(p)
          str = str .. tonumber(month) .. "." .. tonumber(day)
          if self.timeLabels[i] then
            self.timeLabels[i].gameObject:SetActive(true)
            self.timeLabels[i].text = str
            if textColor then
              self.timeLabels[i].color = textColor
            end
          end
        end
      end
    end
  end
  for i = 8, #shortCutGroup + 1, -1 do
    if self.timeLabels[i] then
      self.timeLabels[i].gameObject:SetActive(false)
    end
  end
end

function ActivityIntegrationPreviewSubView:UpdateInfos()
  if not self.itemAndNameContainer then
    return
  end
  local params = self.staticData.Params
  local shortCutGroup = params and params.ShortCut or {}
  if shortCutGroup and 0 < #shortCutGroup then
    local _, textColor = ColorUtil.TryParseHexString(params.TextColor)
    local _, bgColor = ColorUtil.TryParseHexString(params.ItemBgColor)
    local _, textBgColor = ColorUtil.TryParseHexString(params.TextBgColor or "000000")
    for i = 1, 8 do
      if shortCutGroup[i] then
        self.infoLists[i].go:SetActive(true)
        self.infoLists[i].bg.color = bgColor
        self.infoLists[i].label.color = textColor
        self.infoLists[i].label.text = shortCutGroup[i].Desc or ""
        local setSuc, setFaceSuc = false, false
        local itemid = shortCutGroup[i].Item or 151
        local staticData = Table_Item[itemid]
        if staticData and staticData.Type == 1200 then
          setFaceSuc = IconManager:SetFaceIcon(staticData.Icon, self.infoLists[i].icon)
          if not setFaceSuc then
            setFaceSuc = IconManager:SetFaceIcon("boli", self.infoLists[i].icon)
          end
        else
          setSuc = IconManager:SetItemIcon(staticData.Icon, self.infoLists[i].icon)
          setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.infoLists[i].icon)
        end
        self.infoLists[i].icon:MakePixelPerfect()
        self.infoLists[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
      else
        self.infoLists[i].go:SetActive(false)
      end
    end
  else
    local itemIds = params and params.ItemIDs
    if itemIds and 0 < #itemIds then
      local _, textColor = ColorUtil.TryParseHexString(params.TextColor or "000000")
      local _, bgColor = ColorUtil.TryParseHexString(params.ItemBgColor or "000000")
      local _, textBgColor = ColorUtil.TryParseHexString(params.TextBgColor or "000000")
      for i = 1, 12 do
        if self.infoLists[i] then
          if itemIds[i] then
            self.infoLists[i].go:SetActive(true)
            if self.infoLists[i].labelBg then
              self.infoLists[i].labelBg.color = textBgColor
            end
            if self.infoLists[i].label then
              self.infoLists[i].label.color = textColor
            end
            if self.infoLists[i].bg then
              self.infoLists[i].bg.color = bgColor
            end
            local itemid = itemIds[i]
            local staticData = Table_Item[itemid]
            if not staticData then
              redlog("Item不存在", itemid)
              return
            end
            local setSuc, setFaceSuc = false, false
            if staticData and staticData.Type == 1200 then
              setFaceSuc = IconManager:SetFaceIcon(staticData.Icon, self.infoLists[i].icon)
              if not setFaceSuc then
                setFaceSuc = IconManager:SetFaceIcon("boli", self.infoLists[i].icon)
              end
            else
              setSuc = IconManager:SetItemIcon(staticData.Icon, self.infoLists[i].icon)
              setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.infoLists[i].icon)
            end
            self.infoLists[i].icon:MakePixelPerfect()
            self.infoLists[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
            self.infoLists[i].label.text = staticData.NameZh
            local width = self.infoLists[i].label.printedSize.x
            self.infoLists[i].labelBg.width = width + 10
            self.colliders[i].gameObject:SetActive(true)
          else
            self.infoLists[i].go:SetActive(false)
            self.colliders[i].gameObject:SetActive(false)
          end
        end
      end
    end
  end
end

function ActivityIntegrationPreviewSubView:HandleClickShortCut(index, go)
  local params = self.staticData.Params
  local shortCutGroup = params and params.ShortCut
  local isTF = EnvChannel.IsTFBranch()
  if shortCutGroup and 0 < #shortCutGroup then
    local data = shortCutGroup[index]
    if data then
      local duration = isTF and data.TFDuration or data.Duration
      if duration then
        local startTime, endTime
        startTime = duration[1]
        endTime = duration[2]
        if startTime and endTime then
          if KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) then
            local gotomode = data.GoToMode
            if gotomode then
              FuncShortCutFunc.Me():CallByID(gotomode)
              if self.container then
                self.container:CloseSelf()
              end
            else
              MsgManager.FloatMsg(nil, "未配置GoToMode")
            end
          else
            MsgManager.ShowMsgByID(43381)
          end
        end
      end
    end
  end
end

function ActivityIntegrationPreviewSubView:HandleShowItemTip(index, go)
  local params = self.staticData.Params
  local itemIds = params and params.ItemIDs
  if itemIds and itemIds[index] and itemIds[index] ~= 0 then
    self:ShowItemPreviewTip(itemIds[index], go)
  end
end

function ActivityIntegrationPreviewSubView:ShowItemPreviewTip(itemid, go)
  if not itemid then
    return
  end
  local sdata = {
    itemdata = ItemData.new("preview", itemid)
  }
  local widget = go:GetComponent(UIWidget)
  self:ShowItemTip(sdata, widget, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function ActivityIntegrationPreviewSubView:clickShortCutCell(cellCtrl)
  if not cellCtrl then
    return
  end
  xdlog("clickShortCutCell")
  local data = cellCtrl.data
  local gotomode = data and data.Gotomode
  if gotomode then
    FuncShortCutFunc.Me():CallByID(gotomode)
    if self.container then
      self.container:CloseSelf()
    end
  end
end

function ActivityIntegrationPreviewSubView:UpdateLeftTime()
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    if 0 < day then
      timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
      self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
    else
      timeText = string.format("%02d:%02d:%02d", hour, min, sec)
      self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
    end
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
  end
end

function ActivityIntegrationPreviewSubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  local params = self.staticData.Params
  self.gotomode = params and params.GoToMode
  self.helpID = params and self.staticData.HelpID
  ActivityIntegrationShopSubView.super.OnEnter(self)
  self.showType = params and params.ShowType or 1
  self:FindObjs()
  self:AddViewEvts()
  if decorateTextureNameMap[self.showType] then
    for objName, texName in pairs(decorateTextureNameMap[self.showType]) do
      picIns:SetUI(texName, self[objName])
    end
  end
  self.textureName = params and params.Texture
  picIns:SetUI(self.textureName, self.bgTexture)
  if self.textureName == "activityintegration_bg_pic01" then
    if self.Ornament then
      self.Ornament.gameObject:SetActive(true)
    end
  elseif self.Ornament then
    self.Ornament.gameObject:SetActive(false)
  end
  xdlog("showtype", self.showType)
  self:RefreshPage()
end

function ActivityIntegrationPreviewSubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  ActivityIntegrationShopSubView.super.OnExit(self)
  for i = 1, 3 do
    if decorateTextureNameMap[i] then
      for objName, texName in pairs(decorateTextureNameMap[i]) do
        picIns:UnLoadUI(texName, self[objName])
      end
    end
  end
  self.gotomode = nil
  self.helpID = nil
  picIns:UnLoadUI(self.textureName, self.bgTexture)
  self.textureName = nil
end
