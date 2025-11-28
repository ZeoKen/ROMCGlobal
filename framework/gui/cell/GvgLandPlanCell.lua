local _grayColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
local _spriteName = {
  "com_btn_13s",
  "com_btn_2s"
}
local _baseCell = autoImport("BaseCell")
GvgLandPlanCell = class("GvgLandPlanCell", _baseCell)
autoImport("GuildHeadCell")

function GvgLandPlanCell:Init()
  self:FindObj()
end

function GvgLandPlanCell:FindObj()
  self.cityName = self:FindComponent("CityName", UILabel)
  self.cityIcon = self:FindComponent("CityIcon", UISprite)
  self.myGuildLastCityRoot = self:FindGO("MyGuildCityRoot")
  self.guildNameLab = self:FindComponent("GuildName", UILabel, self.myGuildLastCityRoot)
  self.occupiedLabelFixed = self:FindComponent("OccupiedLabelFixed", UILabel, self.myGuildLastCityRoot)
  self.occupiedLabelFixed.text = ZhString.GvgLandPlanView_Fixed_Occupied
  local guildHeadCellGO = self:FindGO("GuildHeadCell", self.myGuildLastCityRoot)
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.lastWeekCityRoot = self:FindGO("LastWeekCityRoot")
  self.flagLabel = self:FindComponent("FlagLabel", UILabel, self.lastWeekCityRoot)
  self.flagLabel.text = ZhString.GvgLandPlanView_OldCity
  self.firstOption = self:FindComponent("FirstOption", UILabel, self.lastWeekCityRoot)
  self.firstOption.text = ZhString.GvgLandPlanView_FirstOption
  self.myGuildHoldBtn = self:FindComponent("HoldBtn", UISprite, self.lastWeekCityRoot)
  self.myGuildHoldBtnLab = self:FindComponent("Label", UILabel, self.myGuildHoldBtn.gameObject)
  self.myGuildHoldBtnLab.text = ZhString.GvgLandPlanView_Hold
  self:AddClickEvent(self.myGuildHoldBtn.gameObject, function(go)
    self:OnClickHoldBtn()
  end)
  self.firstOptionTog = self:FindComponent("FirstOptionTog", UIToggle, self.firstOption.gameObject)
  self.firstOptionTogColider = self:FindComponent("FirstOptionTog", BoxCollider, self.firstOption.gameObject)
  self:AddClickEvent(self.firstOptionTog.gameObject, function()
    if not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity) then
      return
    end
    local _eventStr = self.firstOptionTog.value and GVGEvent.GVG_FirstOptionLaunch or GVGEvent.GVG_FirstOptionShutDown
    GameFacade.Instance:sendNotification(_eventStr)
  end)
  self.lastCityWaitLab = self:FindComponent("WaitLab", UILabel, self.lastWeekCityRoot)
  self.waitRoot = self:FindGO("WaitRoot")
  self.waitRootLab = self:FindComponent("Lab", UILabel, self.waitRoot)
  self.waitRootLab.text = ZhString.GvgLandPlanView_Optional
  self.tempOccupyRoot = self:FindGO("TempOccupyRoot")
  self.alternativeBtn = self:FindGO("AlternativeBtn", self.tempOccupyRoot)
  self:AddClickEvent(self.alternativeBtn, function(go)
    self:OnClickAlternativeBtn()
  end)
  local alternativeLab = self:FindComponent("Label", UILabel, self.alternativeBtn)
  alternativeLab.text = ZhString.GvgLandPlanView_Optional
  self.holdBtn = self:FindComponent("HoldBtn", UISprite, self.tempOccupyRoot)
  self:AddClickEvent(self.holdBtn.gameObject, function(go)
    self:OnClickHoldBtn()
  end)
  self.holdBtnLab = self:FindComponent("Label", UILabel, self.holdBtn.gameObject)
  self.holdBtnLab.text = ZhString.GvgLandPlanView_Hold
  self.prepareRoot = self:FindGO("PrepRoot")
end

function GvgLandPlanCell:RefreshTempOccupyBtn(toggleOpen)
  if not self.data or not self.data:IsTempOccupy() then
    return
  end
  if toggleOpen then
    self:Show(self.alternativeBtn)
  else
    self:Hide(self.alternativeBtn)
  end
  self.forbiddenClickHoldBtn = toggleOpen or not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity)
  self:RefreshOccupyBtn(self.holdBtn, self.holdBtnLab, self.forbiddenClickHoldBtn)
end

function GvgLandPlanCell:RefreshOccupyBtn(btnsprite, btnlabel, forbidden)
  if forbidden then
    btnsprite.spriteName = _spriteName[1]
    btnlabel.effectColor = _grayColor
  else
    btnsprite.spriteName = _spriteName[2]
    btnlabel.effectColor = ColorUtil.ButtonLabelOrange
  end
end

function GvgLandPlanCell:SetGuildHeadIcon()
  self.headCell:SetData(self:GetMyGuildHeadData())
end

function GvgLandPlanCell:GetMyGuildHeadData()
  if not self.myGuildHeadData then
    self.myGuildHeadData = GuildHeadData.new()
  end
  self.myGuildHeadData:SetBy_InfoId(GuildProxy.Instance.myGuildData.portrait)
  self.myGuildHeadData:SetGuildId(GuildProxy.Instance.guildId)
  return self.myGuildHeadData
end

function GvgLandPlanCell:SetCityIcon()
  local cityConfig = self.data and self.data.cityConfig
  if cityConfig then
    self:Show(self.cityIcon)
    if cityConfig.Icon then
      IconManager:SetUIIcon(cityConfig.Icon, self.cityIcon)
    end
    if cityConfig.IconColor then
      local hasC, resultC = ColorUtil.TryParseHexString(cityConfig.IconColor)
      self.cityIcon.color = resultC
    end
  else
    self:Hide(self.cityIcon)
  end
end

function GvgLandPlanCell:OnClickAlternativeBtn()
  if not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity) then
    return
  end
  local waitOptionCity = self.data and self.data.cityId
  if not waitOptionCity then
    return
  end
  local lastWeekGuildName = GvgProxy.Instance:GetLastWeekGuildName()
  local lastWeekCityName = GvgProxy.Instance:GetLastWeekCityName()
  local cityname = self.data.cityName
  MsgManager.ConfirmMsgByID(2239, function()
    ServiceGuildCmdProxy.Instance:CallGvgSettleSelectGuildCmd(waitOptionCity, nil)
  end, nil, nil, lastWeekGuildName, lastWeekCityName, cityname)
end

function GvgLandPlanCell:OnClickHoldBtn()
  if self.forbiddenClickHoldBtn then
    return
  end
  local occupyCity = self.data and self.data.cityId
  if not occupyCity then
    return
  end
  local param = self.data.cityName
  MsgManager.ConfirmMsgByID(2238, function()
    ServiceGuildCmdProxy.Instance:CallGvgSettleSelectGuildCmd(nil, occupyCity)
  end, nil, nil, param)
end

function GvgLandPlanCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.cityName.text = data.cityName
  self:SetCityIcon()
  if data:IsLastCity() then
    self:Show(self.lastWeekCityRoot)
    self:Hide(self.waitRoot)
    self:Hide(self.tempOccupyRoot)
    self:Hide(self.prepareRoot)
    if data:IsMyLastGuildCity() then
      self:Hide(self.lastCityWaitLab)
      self:Show(self.myGuildLastCityRoot)
      self.guildNameLab.text = GvgProxy.Instance:GetLastWeekGuildName()
      redlog("GvgProxy.Instance:GetLastWeekGuildName()", GvgProxy.Instance:GetLastWeekGuildName())
      self:SetGuildHeadIcon()
      self:Hide(self.firstOption)
      self:Show(self.myGuildHoldBtn)
      self.forbiddenClickHoldBtn = not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity)
      self:RefreshOccupyBtn(self.myGuildHoldBtn, self.myGuildHoldBtnLab, self.forbiddenClickHoldBtn)
    else
      self:Show(self.firstOption)
      self:Hide(self.myGuildHoldBtn)
      if not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GvgCity) then
        self.firstOptionTog:Set(false)
        self.firstOptionTogColider.enabled = false
      elseif not GvgProxy.Instance:HasSelectCitys() then
        self.firstOptionTog:Set(true)
        self.firstOptionTogColider.enabled = false
      else
        self.firstOptionTog:Set(false)
        self.firstOptionTogColider.enabled = true
      end
      self:Hide(self.myGuildLastCityRoot)
      local lastWeekGuildName = GvgProxy.Instance:GetLastWeekGuildName()
      self:Show(self.lastCityWaitLab)
      self.lastCityWaitLab.text = string.format(ZhString.GvgLandPlanView_Wait, lastWeekGuildName)
    end
  elseif data:IsWait() then
    self:Show(self.waitRoot)
    self:Hide(self.tempOccupyRoot)
    self:Hide(self.lastWeekCityRoot)
    self:SetGuildHeadIcon()
    self:Hide(self.myGuildLastCityRoot)
    self:Hide(self.prepareRoot)
  elseif data:IsTempOccupy() then
    self:Show(self.tempOccupyRoot)
    self:Hide(self.lastWeekCityRoot)
    self:Hide(self.waitRoot)
    self:Hide(self.prepareRoot)
    self:RefreshTempOccupyBtn()
    self:SetGuildHeadIcon()
    self:Show(self.myGuildLastCityRoot)
    redlog("GuildProxy.Instance.myGuildData.name: ", GuildProxy.Instance.myGuildData.name)
    self.guildNameLab.text = GuildProxy.Instance.myGuildData.name or ""
  elseif data:IsPrepare() then
    self:Hide(self.tempOccupyRoot)
    self:Hide(self.lastWeekCityRoot)
    self:Hide(self.waitRoot)
    self:Show(self.prepareRoot)
    self:Hide(self.myGuildLastCityRoot)
  end
end
