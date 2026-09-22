autoImport("ActivityIntegrationPreviewSubView")
LoopActPreviewSubView = class("LoopActPreviewSubView", ActivityIntegrationPreviewSubView)
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

function LoopActPreviewSubView:UnloadTextures()
  if self.loadedDecorateTextures then
    for objName, texName in pairs(self.loadedDecorateTextures) do
      picIns:UnLoadUI(texName, self[objName])
    end
    self.loadedDecorateTextures = nil
  end
  if self.textureName and self.bgTexture then
    picIns:UnLoadUI(self.textureName, self.bgTexture)
    self.textureName = nil
  end
end

function LoopActPreviewSubView:OnEnter(id)
  if not id then
    return
  end
  local sourceData = Table_ActivityNew[id]
  if not sourceData then
    redlog("Table_ActivityNew缺少Preview配置", id)
    return
  end
  local timeValid, realStartTime, realEndTime = LoopActIntegrationProxy.Instance:CheckTimeValid(sourceData)
  if not (timeValid and realStartTime) or not realEndTime then
    return
  end
  self:UnloadTextures()
  local staticData = {}
  for key, value in pairs(sourceData) do
    staticData[key] = value
  end
  local duration = {
    StringUtil.FormatTimeStamp2NormalTimeStr(realStartTime),
    StringUtil.FormatTimeStamp2NormalTimeStr(realEndTime)
  }
  local params = {}
  for key, value in pairs(sourceData.Params_Inte or _EmptyTable) do
    params[key] = value
  end
  if params.ShortCut then
    params.TextColor = params.TextColor or "FFFFFF"
    params.ItemBgColor = params.ItemBgColor or "000000"
    params.TextBgColor = params.TextBgColor or "000000"
  end
  staticData.Params = params
  staticData.Duration = duration
  staticData.TFDuration = duration
  self.staticData = staticData
  ActivityIntegrationPreviewSubView.super.OnEnter(self)
  local params = self.staticData.Params
  self.gotomode = params and params.GoToMode
  self.helpID = self.staticData.HelpID
  self.showType = params and params.ShowType or 1
  self:FindObjs()
  self:AddViewEvts()
  if decorateTextureNameMap and decorateTextureNameMap[self.showType] then
    self.loadedDecorateTextures = {}
    for objName, texName in pairs(decorateTextureNameMap[self.showType]) do
      picIns:SetUI(texName, self[objName])
      self.loadedDecorateTextures[objName] = texName
    end
  end
  self.textureName = params and params.Texture
  if self.textureName and self.textureName ~= "" then
    picIns:SetUIWithCallback(self.textureName, self.bgTexture, ActivityIntegrationPreviewSubView.FitBgTextureToOriginalSize, self)
  end
  if self.Ornament then
    self.Ornament.gameObject:SetActive(self.textureName == "activityintegration_bg_pic01")
  end
  self:RefreshPage()
end

function LoopActPreviewSubView:HandleClickShortCut(index, go)
  local params = self.staticData and self.staticData.Params
  local shortCutGroup = params and params.ShortCut
  local data = shortCutGroup and shortCutGroup[index]
  if not data then
    return
  end
  local duration = EnvChannel.IsTFBranch() and data.TFDuration or data.Duration
  duration = duration or self.staticData.Duration
  if not (duration and duration[1]) or not duration[2] then
    return
  end
  if KFCARCameraProxy.Instance:CheckDateValid(duration[1], duration[2]) then
    if data.GoToMode then
      FuncShortCutFunc.Me():CallByID(data.GoToMode)
      if self.container then
        self.container:CloseSelf()
      end
    end
  else
    MsgManager.ShowMsgByID(43381)
  end
end

function LoopActPreviewSubView:GetDisplayDay(day, hour, min, sec)
  return (0 < hour or 0 < min or 0 < sec) and day + 1 or day
end

function LoopActPreviewSubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:UnloadTextures()
  ActivityIntegrationPreviewSubView.super.OnExit(self)
end

return LoopActPreviewSubView
