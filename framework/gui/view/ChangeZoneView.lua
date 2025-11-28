autoImport("ChangeZoneCombineCell")
autoImport("ZoneLangCombineCell")
ChangeZoneView = class("ChangeZoneView", ContainerView)
ChangeZoneView.ViewType = UIViewType.NormalLayer

function ChangeZoneView:OnEnter()
  ChangeZoneView.super.OnEnter(self)
  if self.npcid then
    local npc = NSceneNpcProxy.Instance:Find(self.npcid)
    if npc then
      local viewPort = CameraConfig.HappyShop_ViewPort
      local rotation = CameraConfig.HappyShop_Rotation
      self:CameraFaceTo(npc.assetRole.completeTransform, viewPort, rotation)
    end
  else
    self:CameraRotateToMe()
  end
end

function ChangeZoneView:OnExit()
  self:CameraReset()
  self.contentInput = nil
  ChangeZoneView.super.OnExit(self)
end

function ChangeZoneView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function ChangeZoneView:XDEUpdateInfo()
  self.contentInput = self:FindComponent("ContentInput", UIInput)
  if self.contentInput.value == "" then
    if self.contentInput.label.fontSize ~= 22 then
      self.contentInput.label.fontSize = 22
    end
    if self.submitSprite.activeInHierarchy then
      self.submitSprite:SetActive(false)
    end
    self:UpdateTips(true)
    if self.targetZoneAni then
      self.targetZoneAni.enabled = true
    end
  else
    if self.contentInput.label.fontSize ~= 36 then
      self.contentInput.label.fontSize = 36
    end
    if not self.submitSprite.activeInHierarchy then
      self.submitSprite:SetActive(true)
    end
    local num
    if self.LanguageZoneSelect and self.languageZoneCell.value then
      local zoneName = self.languageZoneCell.value .. self.contentInput.value
      num = ChangeZoneProxy.Instance:ZoneStringToNum(zoneName)
    else
      num = ChangeZoneProxy.Instance:ZoneStringToNum(self.contentInput.value)
    end
    self:UpdateCost(num)
    self:UpdateTip()
    if self.targetZoneAni then
      self.targetZoneAni.enabled = false
    end
  end
end

function ChangeZoneView:FindObjs()
  local silver = self:FindGO("Silver")
  self.silverLabel = self:FindGO("SilverLabel"):GetComponent(UILabel)
  self.silverIcon = self:FindGO("symbol", silver):GetComponent(UISprite)
  local itemId = 100
  local itemData = Table_Item[itemId]
  IconManager:SetItemIcon(itemData.Icon, self.silverIcon)
  self.currentZone = self:FindGO("CurrentZone"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.statusTip = self:FindGO("StatusTip"):GetComponent(UILabel)
  self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
  self.submitSprite = self:FindGO("SubmitSprite")
  self.emptyRecent = self:FindGO("EmptyRecent")
  self.costLabel = self:FindGO("Cost"):GetComponent(UILabel)
  self.costSprite = self:FindGO("CostSprite"):GetComponent(UISprite)
  self.costInfo = self:FindGO("CostInfo")
  self.costTip = self:FindGO("CostTip")
  self.changeBtn = self:FindGO("ChangeBtn")
  self.changeBtnLabel = self:FindGO("Label", self.changeBtn):GetComponent(UILabel)
  self.targetZoneObj = self:FindGO("TargetZoneBg")
  self:PlayUIEffect(EffectMap.UI.ChangeZoneView, self.targetZoneObj, false, function(obj, args, assetEffect)
    self.targetZoneAni = obj:GetComponent(Animator)
  end)
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() or BranchMgr.IsNO() or BranchMgr.IsNOEN() then
    self.LanguageZoneSelect = true
  else
    self.LanguageZoneSelect = false
  end
  self.ZoneSelect = self:FindGO("ZoneSelect")
  self.ZoneSelect.gameObject:SetActive(self.LanguageZoneSelect)
  if self.LanguageZoneSelect then
    self.chooseLanguageGo = self:FindGO("ZoneLangboard")
    self.languageZoneCell = ZoneLangCombineCell.new(self.chooseLanguageGo)
  end
end

function ChangeZoneView:AddEvts()
  self:AddClickEvent(self.changeBtn, function()
    if self.isBusy then
      MsgManager.FloatMsg(nil, ZhString.ChangeZone_VeryBusyNotice)
    else
      self:ClickChangeBtn()
    end
  end)
  EventDelegate.Set(self.contentInput.onChange, function()
    if self.contentInput.value == "" then
      if self.contentInput.label.fontSize ~= 22 then
        self.contentInput.label.fontSize = 22
      end
      if self.submitSprite.activeInHierarchy then
        self.submitSprite:SetActive(false)
      end
      self:UpdateTips(true)
      if self.targetZoneAni then
        self.targetZoneAni.enabled = true
      end
    else
      if self.contentInput.label.fontSize ~= 36 then
        self.contentInput.label.fontSize = 36
      end
      if not self.submitSprite.activeInHierarchy then
        self.submitSprite:SetActive(true)
      end
      local num
      if self.LanguageZoneSelect and self.languageZoneCell.value then
        local zoneName = self.languageZoneCell.value .. self.contentInput.value
        num = ChangeZoneProxy.Instance:ZoneStringToNum(zoneName)
      else
        num = ChangeZoneProxy.Instance:ZoneStringToNum(self.contentInput.value)
      end
      self:UpdateCost(num)
      self:UpdateTip()
      if self.targetZoneAni then
        self.targetZoneAni.enabled = false
      end
    end
  end)
end

function ChangeZoneView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.NUserQueryZoneStatusUserCmd, self.UpdateRecent)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ChangeZoneEvent.ZoneLanguageSetData, self.XDEUpdateInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function ChangeZoneView:InitShow()
  self.npcid = self.viewdata.viewdata and self.viewdata.viewdata.data.id
  self.tip.text = string.format(ZhString.ChangeZone_Tip)
  local recentZoneGrid = self:FindGO("RecentZoneGrid"):GetComponent(UIGrid)
  self.recentCtl = UIGridListCtrl.new(recentZoneGrid, ChangeZoneCombineCell, "ChangeZoneCombineCell")
  self.recentCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRecentZoneItem, self)
  self:UpdateCoins()
  self:UpdateCurrentZone()
  self:UpdateRecent()
  self:UpdateCost()
  self:UpdateChangeBtn()
end

function ChangeZoneView:UpdateCoins()
  self.silverLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function ChangeZoneView:UpdateCurrentZone()
  self.currentZone.text = MyselfProxy.Instance:GetZoneString()
end

function ChangeZoneView:UpdateRecent()
  local data = ChangeZoneProxy.Instance:GetRecents()
  if 0 < #data then
    self.emptyRecent:SetActive(false)
  else
    self.emptyRecent:SetActive(true)
  end
  local newData = self:ReUniteCellData(data, 2)
  self.recentCtl:ResetDatas(newData)
end

function ChangeZoneView:UpdateCost(zoneid)
  self.cost = nil
  if MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_FIRST_EXCHANGEZONE) == 1 then
    self.costTip:SetActive(false)
    local data = ChangeZoneProxy.Instance:GetInfos(zoneid)
    if data then
      if GuildProxy.Instance:IHaveGuild() then
        if zoneid ~= GuildProxy.Instance.myGuildData.zoneid then
          self:SetCost(data)
        else
          self.costInfo:SetActive(false)
        end
      else
        self:SetCost(data)
      end
    else
      self.costInfo:SetActive(false)
    end
  else
    self.costInfo:SetActive(false)
    self.costTip:SetActive(true)
  end
  if self.cost then
    for i = 1, #self.cost do
      local cost = self.cost[i]
      local itemData = Table_Item[cost[1]]
      IconManager:SetItemIcon(itemData.Icon, self.costSprite)
      self.costLabel.text = tostring(cost[2])
    end
  end
end

function ChangeZoneView:SetCost(data)
  if not self.costInfo.activeInHierarchy then
    self.costInfo:SetActive(true)
  end
  if data.status == ZoneData.ZoneStatus.Free then
    self.cost = GameConfig.Zone.free.cost
  elseif data.status == ZoneData.ZoneStatus.Busy then
    self.cost = GameConfig.Zone.busy.cost
  elseif data.status == ZoneData.ZoneStatus.VeryBusy then
    self.cost = GameConfig.Zone.verybusy.cost
  end
end

function ChangeZoneView:UpdateChangeBtn()
  self.changeBtnLabel.text = ZhString.ChangeZone_ChangeLine
end

function ChangeZoneView:UpdateTip()
  local value = self.contentInput.value
  local num
  self.isBusy = false
  local num
  if self.LanguageZoneSelect and self.languageZoneCell.value then
    local zoneName = self.languageZoneCell.value .. self.contentInput.value
    num = ChangeZoneProxy.Instance:ZoneStringToNum(zoneName)
  else
    num = ChangeZoneProxy.Instance:ZoneStringToNum(self.contentInput.value)
  end
  local data = ChangeZoneProxy.Instance:GetInfos(num)
  if data then
    local colorId
    if data.status == ZoneData.ZoneStatus.Free then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_FreeTip, value)
      colorId = ZoneData.ZoneColor.Free
    elseif data.status == ZoneData.ZoneStatus.Busy then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_BusyTip, value)
      colorId = ZoneData.ZoneColor.Busy
    elseif data.status == ZoneData.ZoneStatus.VeryBusy then
      self:UpdateTips(false)
      self.statusTip.text = string.format(ZhString.ChangeZone_VeryBusyTip, value)
      colorId = ZoneData.ZoneColor.VeryBusy
      self.isBusy = BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()
    else
      self:UpdateTips(true)
    end
    if colorId then
      local colorData = Table_GFaithUIColorConfig[colorId]
      if colorData then
        local hasc, rc = ColorUtil.TryParseHexString(colorData.name_Color)
        self.statusTip.color = rc
      end
    end
  else
    self:UpdateTips(true)
  end
end

function ChangeZoneView:UpdateTips(isShow)
  self.tip.gameObject:SetActive(isShow)
  self.statusTip.gameObject:SetActive(not isShow)
end

function ChangeZoneView:ClickRecentZoneItem(cellctl)
  if cellctl.data then
    self.currentZoneId = cellctl.data
    if self.LanguageZoneSelect then
      local zoneName = ChangeZoneProxy.Instance:ZoneNumToString(self.currentZoneId)
      self.contentInput.value = string.sub(zoneName, 3)
      local lang = string.sub(zoneName, 1, 2)
      local serverNameList = ChangeZoneProxy.Instance.serverNames
      if serverNameList and #serverNameList then
        for k, v in pairs(serverNameList) do
          if v.name_prefix == lang then
            self.languageZoneCell:SetData(k)
            break
          end
        end
      end
    else
      self.contentInput.value = ChangeZoneProxy.Instance:ZoneNumToString(self.currentZoneId)
    end
    self:UpdateCost(self.currentZoneId)
  end
end

function ChangeZoneView:ClickChangeBtn()
  local value = self.contentInput.value
  if value == "" then
    MsgManager.ShowMsgByID(3087)
    return
  end
  if value == self.currentZone.text and (not (self.languageZoneCell and self.languageZoneCell.value) or self.languageZoneCell.value == value) then
    MsgManager.ShowMsgByID(3084)
    return
  end
  local num
  if self.LanguageZoneSelect and self.languageZoneCell.value then
    local name, id = string.match(self.contentInput.value, "(%a+)(%d+)")
    local zoneName
    if name and id then
      zoneName = self.contentInput.value
    else
      zoneName = self.languageZoneCell.value .. self.contentInput.value
    end
    num = ChangeZoneProxy.Instance:ZoneStringToNum(zoneName)
  else
    num = ChangeZoneProxy.Instance:ZoneStringToNum(self.contentInput.value)
  end
  if num == nil then
    return
  end
  local info = ChangeZoneProxy.Instance:GetInfos(num)
  if info == nil then
    MsgManager.ShowMsgByID(3088)
    return
  end
  if not LocalSaveProxy.Instance:GetDontShowAgain(3093) then
    MsgManager.DontAgainConfirmMsgByID(3093, function()
      self:CheckCostAndJumpZone(num, value)
    end)
  else
    self:CheckCostAndJumpZone(num, value)
  end
end

function ChangeZoneView:CheckCostAndJumpZone(zoneId, value)
  if self.cost then
    for i = 1, #self.cost do
      local cost = self.cost[i]
      if MyselfProxy.Instance:GetROB() < cost[2] then
        MsgManager.ShowMsgByID(1)
        return
      end
    end
  end
  ServiceNUserProxy.Instance:CallJumpZoneUserCmd(self.npcid, zoneId, self.npcid == nil)
  self:CloseSelf()
end

function ChangeZoneView:HandleRemoveNpc(note)
  if self.npcid then
    local npc = NSceneNpcProxy.Instance:Find(self.npcid)
    if npc == nil then
      self:CloseSelf()
    end
  end
end

local newData = {}

function ChangeZoneView:ReUniteCellData(datas, perRowNum)
  TableUtility.TableClear(newData)
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
