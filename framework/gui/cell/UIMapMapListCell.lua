autoImport("UIModelKaplaTransmit")
autoImport("ActivityEventProxy")
local baseCell = autoImport("BaseCell")
UIMapMapListCell = class("UIMapMapListCell", baseCell)

function UIMapMapListCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  local l_zenyIcon = self:FindComponent("Icon", UISprite, self.goCurrency)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self.labCurrencyCount = self:FindGO("Count", self.goCurrency):GetComponent(UILabel)
  self.goTransfer = self:FindGO("Transfer")
  self.goTransferBoxCollider = self.goTransfer:GetComponent(BoxCollider)
  self.spTransferBG = self:FindGO("BG", self.goTransfer):GetComponent(UISprite)
  self.labTransferTitle = self:FindGO("Title", self.goTransfer):GetComponent(UILabel)
  self.mapTypeIcon = self:FindGO("MapTypeIcon"):GetComponent(UISprite)
  self:AddClickEvent(self.gameObject, function(go)
    self:OnClick(go)
  end)
  self:AddEvts()
  self.clone = self:FindGO("Clone")
  self.lv = self:FindGO("Lv"):GetComponent(UILabel)
end

function UIMapMapListCell:SetData(data)
  self.mapInfo = data
  if self.mapInfo then
    self.labName.text = self.mapInfo.NameZh
    local isFree = ActivityEventProxy.Instance:IsFreeTransferMap(self.mapInfo.id, UIMapMapList.transmitType)
    self.currencyCount = isFree and 0 or self.mapInfo.Money or 0
    if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
      local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
      if handInHandPlayerID ~= nil then
        self.currencyCount = self.currencyCount * GameConfig.MapTrans.HandRate
      end
    elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
      local followingTeammatesID = UIModelKaplaTransmit.Ins():GetFollowingTeammates()
      if followingTeammatesID ~= nil then
        local followingTeammateCount = #followingTeammatesID
        self.currencyCount = (1 + followingTeammateCount) * self.currencyCount
      end
    end
    if self.currencyCount then
      if self.currencyCount > 0 then
        self.currencyCount = math.floor(self.currencyCount)
        self.labCurrencyCount.text = self.currencyCount
        self.goCurrency:SetActive(true)
        self.labTransferTitle.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-45, 3, 0)
      else
        self.labCurrencyCount.text = 0
        self.goCurrency:SetActive(false)
        self.labTransferTitle.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 3, 0)
      end
    end
    self.clone:SetActive(self.mapInfo.CloneMap ~= nil)
    local levelRange = self.mapInfo.LvRange
    if levelRange[1] then
      local formatStr = "Lv%s~%s"
      self.lv.text = string.format(formatStr, levelRange[1], levelRange[2])
      self.labName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-185.3, -24.4, 0)
    else
      self.lv.text = ""
      self.labName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-185.3, -36, 0)
    end
  end
  if self:IsActive() then
    self.spTransferBG.spriteName = "com_btn_2s"
    self.labTransferTitle.applyGradient = true
    self.labTransferTitle.effectColor = LuaGeometry.GetTempVector4(0.6431372549019608, 0.37254901960784315, 0.047058823529411764, 1)
    self.goTransferBoxCollider.enabled = true
  else
    self.spTransferBG.spriteName = "com_btn_13s"
    self.labTransferTitle.applyGradient = false
    self.labTransferTitle.effectColor = Color.gray
    self.goTransferBoxCollider.enabled = false
  end
  self:SetMapTypeIcon()
end

function UIMapMapListCell:SetMapTypeIcon()
  local mapType = self.mapInfo.TeleportMapType or 1
  if mapType == 1 then
    self.mapTypeIcon.spriteName = "map_icon_main-city"
  elseif mapType == 2 then
    self.mapTypeIcon.spriteName = "map_icon_field"
  elseif mapType == 3 then
    self.mapTypeIcon.spriteName = "map_icon_special"
  elseif mapType == 4 then
    self.mapTypeIcon.spriteName = "map_icon_fb"
  end
end

function UIMapMapListCell:AddEvts()
  self:AddClickEvent(self.goTransfer, function(go)
    if self.mapInfo.CloneMap ~= nil then
      MsgManager.ConfirmMsgByID(43149, function()
        self:OnButtonTransferClick(SceneUser2_pb.EGOTOGEARDEFINE_CLONEMAP_CONVERT)
      end, function()
        self:OnButtonTransferClick()
      end, nil)
    else
      self:OnButtonTransferClick()
    end
  end)
end

function UIMapMapListCell:OnClick(go)
end

function UIMapMapListCell:OnButtonTransferClick(convert)
  local mapid = convert and self.mapInfo.id * convert or self.mapInfo.id
  local ticketCount = 0
  local ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.MainBag)
  if ticketCount1 ~= nil then
    ticketCount = ticketCount + ticketCount1
  end
  ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.Storage)
  if ticketCount1 ~= nil then
    ticketCount = ticketCount + ticketCount1
  end
  ticketCount1 = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.PersonalStorage)
  if ticketCount1 ~= nil then
    ticketCount = ticketCount + ticketCount1
  end
  local isROBEnough = false
  if self.mapInfo.Money == nil then
    isROBEnough = true
  else
    isROBEnough = CostUtil.CheckROB(self.currencyCount or self.mapInfo.Money)
  end
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
    local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
    if handInHandPlayerID ~= nil then
      if isROBEnough then
        ServiceNUserProxy.Instance:CallGoToGearUserCmd(mapid, SceneUser2_pb.EGoToGearType_Hand, {handInHandPlayerID})
        self:Notify("UIMapMapList.CloseSelf", {})
      else
        MsgManager.ShowMsgByIDTable(1)
      end
    elseif 0 < ticketCount then
      ServiceNUserProxy.Instance:CallGoToGearUserCmd(mapid, SceneUser2_pb.EGoToGearType_Single, nil)
      self:Notify("UIMapMapList.CloseSelf", {})
    elseif isROBEnough then
      ServiceNUserProxy.Instance:CallGoToGearUserCmd(mapid, SceneUser2_pb.EGoToGearType_Single, nil)
      self:Notify("UIMapMapList.CloseSelf", {})
    else
      MsgManager.ShowMsgByIDTable(1)
    end
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    if isROBEnough then
      local followingTeammatesID = UIModelKaplaTransmit.Ins():GetFollowingTeammates()
      ServiceNUserProxy.Instance:CallGoToGearUserCmd(mapid, SceneUser2_pb.EGoToGearType_Team, followingTeammatesID)
      self:Notify("UIMapMapList.CloseSelf", {})
    else
      MsgManager.ShowMsgByIDTable(1)
    end
  end
end

function UIMapMapListCell:IsActive()
  local isActive
  local activeMaps = WorldMapProxy.Instance.activeMaps
  if activeMaps == nil then
    isActive = false
  else
    isActive = activeMaps[self.mapInfo.id] == 1
  end
  return isActive
end

function UIMapMapListCell:IsCurrentMap()
  if self.mapInfo == nil then
    return false
  end
  return self.mapInfo.id == Game.MapManager:GetMapID()
end
