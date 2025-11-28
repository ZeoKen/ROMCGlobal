autoImport("EquipStrengthExtraAttriCell")
autoImport("EquipChooseBord")
autoImport("EquipSiteChooseCell")
EquipStrengthView = class("EquipStrengthView", ContainerView)
EquipStrengthView.ViewType = UIViewType.NormalLayer
autoImport("EquipIntegrateView")
EquipStrengthView.BrotherView = EquipIntegrateView
local _StrengthenProxy
local _TYPE = SceneItem_pb.ESTRENGTHTYPE_NORMAL
local ViewConfig = {
  pos = {
    Right = {130, -63.9},
    Mid = {-3.5, -63.9}
  },
  color = {
    Color(0.3176470588235294, 0.30980392156862746, 0.4823529411764706, 1),
    Color(1.0, 0.3764705882352941, 0.12941176470588237, 1)
  }
}

function EquipStrengthView:Init()
  _StrengthenProxy = StrengthProxy.Instance
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self:InitView()
  self:MapEvent()
end

function EquipStrengthView:InitView()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(not self.isCombine)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and -50 or 0, 0, 0)
  self.equipStrengthExtra = self:FindGO("EquipStrengthExtra")
  self.resultGrid = self:FindGO("ResultGrid", self.equipStrengthExtra):GetComponent(UIGrid)
  self.extraCtrl = UIGridListCtrl.new(self.resultGrid, EquipStrengthExtraAttriCell, "EquipStrengthExtraAttriCellType2")
  self.extraCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.handleEquipCard, self)
  self.extraCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.handleRemoveCard, self)
  self.equipStrengthExtra:SetActive(false)
  self.closeExtraBtn = self:FindGO("CloseExtraBtn")
  self:AddClickEvent(self.closeExtraBtn, function()
    self.equipStrengthExtra:SetActive(false)
  end)
  self.strengthenRewardBtn = self:FindGO("StrengthenRewardBtn")
  self:AddClickEvent(self.strengthenRewardBtn, function()
    self.equipStrengthExtra:SetActive(true)
  end)
  self.targetCell = self:FindGO("TargetCell")
  self:AddClickEvent(self.targetCell, function(go)
    self:ClickTargetCell()
  end)
  local obj = self:FindGO("ItemCell", self.targetCell)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.itemCell = ItemCell.new(obj)
  self.itemCell:InitEquipPart()
  local sps = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIWidget, true)
  for i = 1, #sps do
    sps[i].depth = 10 + sps[i].depth
  end
  self.symbol = self:FindGO("Symbol"):GetComponent(UISprite)
  self.item_empty = self:FindGO("Plus", obj)
  self.attrGrid = self:FindGO("AttriGrid"):GetComponent(UIGrid)
  self.attrisGO = self:FindGO("Attris")
  self.attriCell = {}
  for i = 1, 4 do
    local go = self:FindGO("AttriCell" .. i)
    local name = self:FindGO("Name", go):GetComponent(UILabel)
    local oldValue = self:FindGO("OldValue", go):GetComponent(UILabel)
    local arrow = self:FindGO("Arrow", go)
    local targetValue = self:FindGO("TargetValue", go):GetComponent(UILabel)
    self.attriCell[i] = {
      go = go,
      name = name,
      oldValue = oldValue,
      arrow = arrow,
      targetValue = targetValue
    }
  end
  self.strengthMulityBtn = self:FindGO("StrengthMulityBtn")
  self.strengthMulity_Lab = self:FindComponent("StrengthMulity", UILabel, self.strengthMulityBtn)
  self.strengthMulity_Lab.text = ZhString.EquipStrength_StrengthAll
  self.strengthOneBtn = self:FindGO("StrengthOneBtn")
  self:AddOrRemoveGuideId(self.strengthOneBtn, 1004)
  self:AddClickEvent(self.strengthMulityBtn, function(go)
    self:OnButtonStrengthOnceClick(self.strengthMaxLv)
  end)
  self:AddClickEvent(self.strengthOneBtn, function(go)
    self:OnButtonStrengthOnceClick()
  end)
  self.operatePart = self:FindGO("OperatePart")
  self.multiOper = self:FindGO("MultiOper", self.operatePart)
  self.oneOper = self:FindGO("OneOper", self.operatePart)
  self.strengthMultiCostIcon = self:FindGO("MultiCostIcon", self.operatePart):GetComponent(UISprite)
  self.strengthOneCostIcon = self:FindGO("OneCostIcon", self.operatePart):GetComponent(UISprite)
  self.strengthMultiCostLabel = self:FindGO("MultiCostLabel", self.operatePart):GetComponent(UILabel)
  self.strengthOneCostLabel = self:FindGO("OneCostLabel", self.operatePart):GetComponent(UILabel)
  IconManager:SetItemIconById(100, self.strengthOneCostIcon)
  IconManager:SetItemIconById(100, self.strengthMultiCostIcon)
  self.finishPart = self:FindGO("FinishPart")
  self.finishPart_Label = self:FindGO("Label", self.finishPart):GetComponent(UILabel)
  self.leftBord = self:FindGO("LeftBord")
  self.siteBtn1 = self:FindGO("Btn1", self.leftBord)
  self.siteBtn1_Active = self:FindGO("Active", self.siteBtn1)
  self.siteBtn1_Inactive = self:FindGO("Inactive", self.siteBtn1)
  self.siteBtn2 = self:FindGO("Btn2", self.leftBord)
  self.siteBtn2_Active = self:FindGO("Active", self.siteBtn2)
  self.siteBtn2_Inactive = self:FindGO("Inactive", self.siteBtn2)
  self:PlayUIEffect(EffectMap.UI.MiyinEquipStreng, self.targetCell, false)
  self.helpBtn = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(32601, nil, self.helpBtn)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.sitePanel = self:FindGO("SitePanel")
  self.scrollView = self:FindGO("ScrollView", self.sitePanel):GetComponent(UIScrollView)
  self.siteCtrl = WrapListCtrl.new(self:FindGO("ChooseGrid", self.sitePanel), EquipSiteChooseCell, "EquipSiteChooseCell", nil, 1, 0, true)
  self.siteCtrl:AddEventListener(MouseEvent.MouseClick, self.ChooseItem, self)
end

function EquipStrengthView:MapEvent()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCost)
  self:AddListenEvt(ItemEvent.StrengthLvUpdate, self.HandleStrenghtLvUpdate)
  self:AddListenEvt(ItemEvent.StrengthLvReinit, self.HandleStrenghtLvUpdate)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipStrengthView:OnEnter()
  EquipStrengthView.super.OnEnter(self)
  StrengthProxy.Instance:ResetStrengthType(SceneItem_pb.ESTRENGTHTYPE_NORMAL)
  local targetEquip = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.itemdata
  if targetEquip then
    local sitePos = ItemUtil.EquipPosConfig[targetEquip.index] and targetEquip.index or nil
    xdlog("index", targetEquip.index, sitePos)
    if sitePos then
      self.site = sitePos
    else
      local siteIndex = 1
      local sites = targetEquip and targetEquip.equipInfo and targetEquip.equipInfo:GetEquipSite()
      if sites and 1 < #sites then
        for i = 1, #sites do
          local site = sites[i]
          local siteData = _StrengthenProxy:GetStrengthenData(_TYPE, site)
          local isMax = siteData and siteData:IsMax()
          if not isMax then
            siteIndex = i
            break
          end
        end
      end
      self.site = sites and sites[siteIndex]
    end
    self:UpdateView(targetEquip)
  else
    self:ClickTargetCell()
  end
  self.extraCtrl:ResetDatas(StrengthProxy.Instance:GetExtraAttriList())
  self:CameraFocusToMe()
end

function EquipStrengthView:OnExit()
  EquipStrengthView.super.OnExit(self)
  StrengthProxy.Instance:ResetStrengthType(nil)
  self.itemCell = nil
  self:CameraReset()
end

function EquipStrengthView:UpdateView(data)
  self.itemdata = data
  self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  self.siteData = self.site and _StrengthenProxy:GetStrengthenData(_TYPE, self.site)
  if not self.siteData then
    self.itemCell:SetData()
    redlog("装备格子信息缺少", self.siteIndex)
    self.attrisGO:SetActive(false)
    self.strengthenRewardBtn:SetActive(false)
    self.operatePart:SetActive(false)
    self.finishPart:SetActive(true)
    self.finishPart_Label.text = ZhString.EquipIntegrate_ChooseEquip
    self.symbol.gameObject:SetActive(false)
    return
  end
  self.attrisGO:SetActive(true)
  self.strengthenRewardBtn:SetActive(true)
  self.finishPart_Label.text = ZhString.AncientRandom_Maxed
  self.itemCell:SetData(self.itemdata)
  self.itemCell:UpdateNumLabel(1)
  self.itemCell:ActiveNewTag(false)
  if not self.itemdata then
    xdlog("没有道具")
    if self.site then
      self.item_empty:SetActive(false)
      self.symbol.gameObject:SetActive(true)
      xdlog("无道具  且有site")
      local spriteName
      if self.site == 5 or self.site == 6 then
        spriteName = "bag_equip_6"
      else
        spriteName = "bag_equip_" .. self.site
      end
      IconManager:SetUIIcon(spriteName, self.symbol)
      self.symbol:MakePixelPerfect()
    else
      self.item_empty:SetActive(true)
      self.symbol.gameObject:SetActive(false)
    end
  end
  local upgradeInfo = self.siteData:GetUpgradeInfo()
  for i = 1, 4 do
    if upgradeInfo[i] then
      self.attriCell[i].go:SetActive(true)
      self.attriCell[i].name.text = upgradeInfo[i].name
      self.attriCell[i].oldValue.text = upgradeInfo[i].oldValue
      self.attriCell[i].targetValue.text = upgradeInfo[i].newValue
      if upgradeInfo[i].isMax then
        self.attriCell[i].arrow:SetActive(false)
        self.attriCell[i].targetValue.color = LuaGeometry.GetTempVector4(0.5647058823529412, 0.5647058823529412, 0.5647058823529412, 1)
      else
        self.attriCell[i].arrow:SetActive(true)
        self.attriCell[i].targetValue.color = LuaGeometry.GetTempVector4(0.3803921568627451, 0.6588235294117647, 0.2784313725490196, 1)
      end
    else
      self.attriCell[i].go:SetActive(false)
    end
  end
  local isMax = self.siteData:IsMax()
  self.operatePart:SetActive(not isMax)
  self.finishPart:SetActive(isMax)
  self:UpdateCost()
  self.sitePanel:SetActive(false)
end

function EquipStrengthView:RefreshSelf()
  self:UpdateView(self.itemdata)
end

function EquipStrengthView:UpdateCost()
  local siteData = self.siteData
  if not siteData then
    return
  end
  local oneNeed, maxNeed, maxLv = StrengthProxy.CheckEquipCost(siteData.lv, siteData.site)
  self.strengthMaxLv = maxLv
  self.strengthOneCostLabel.text = StringUtil.NumThousandFormat(oneNeed)
  self.strengthOneCostLabel.color = oneNeed <= MyselfProxy.Instance:GetROB() and ViewConfig.color[1] or ViewConfig.color[2]
  local costEnough = 0 < maxLv
  self.strengthMultiCostLabel.text = costEnough and StringUtil.NumThousandFormat(maxNeed) or StringUtil.NumThousandFormat(oneNeed)
  self.strengthMultiCostLabel.color = costEnough and ViewConfig.color[1] or ViewConfig.color[2]
  local hasMaxLv = self.strengthMaxLv > 0
  self.multiOper:SetActive(hasMaxLv)
  local posConfig = hasMaxLv and ViewConfig.pos.Right or ViewConfig.pos.Mid
  self.oneOper.transform.localPosition = LuaGeometry.GetTempVector3(posConfig[1], posConfig[2])
end

function EquipStrengthView:RefreshSites()
end

function EquipStrengthView:UpdateSiteBtns()
  if not self.site then
    return
  end
  if #self.site > 1 and TableUtility.ArrayFindIndex(self.site, 5) > 0 then
    self.leftBord:SetActive(true)
  else
    self.leftBord:SetActive(false)
  end
end

function EquipStrengthView:SwitchSite(index)
  self.siteBtn1_Active:SetActive(index == 1)
  self.siteBtn1_Inactive:SetActive(index ~= 1)
  self.siteBtn2_Active:SetActive(index ~= 1)
  self.siteBtn2_Inactive:SetActive(index == 1)
  if self.siteIndex and self.siteIndex == index then
    return
  end
  self.siteIndex = index
  self:RefreshSelf()
end

function EquipStrengthView:OnButtonStrengthOnceClick(count)
  count = count or 1
  local siteData = self.siteData
  if not siteData then
    MsgManager.ShowMsgByIDTable(216)
    return
  end
  if siteData:IsMax() then
    MsgManager.ShowMsgByIDTable(210)
    return
  end
  local _, _, maxLv = StrengthProxy.CheckEquipCost(siteData.lv, siteData.site)
  if maxLv < 1 then
    if BranchMgr.IsJapan() then
      return
    end
    MsgManager.ConfirmMsgByID(41326, function()
      EventManager.Me():PassEvent(UIEvent.ExitCallback)
      local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.NormalLayer)
      if layer then
        local panelCtrl = layer:FindNodeByName("EquipIntegrateView")
        if panelCtrl and panelCtrl.viewCtrl then
          UIManagerProxy.Instance:CloseUI(panelCtrl.viewCtrl)
        end
      end
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
    end)
    return
  end
  _StrengthenProxy:DoStrenghten(siteData.site, count + siteData:GetLv())
end

function EquipStrengthView:HandleStrenghtLvUpdate(note)
  self:RefreshSelf()
  self:PlayUIEffect(EffectMap.UI.upgrade_success, self.targetCell, true, EquipStrengthen.Upgrade_successEffectHandle, self)
end

function EquipStrengthView.Upgrade_successEffectHandle(effectHandle, owner)
  NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end

function EquipStrengthView:ChooseItem(cell)
  local data = cell and cell.data
  local itemData = data and data.itemdata
  self.site = data and data.site
  self:UpdateView(itemData)
end

function EquipStrengthView:ClickTargetCell()
  xdlog("ClickTargetCell")
  self.equipStrengthExtra:SetActive(false)
  self:ChooseItem(nil)
  local equipdatas = self:GetValidEquips()
  if 0 < #equipdatas then
    self.sitePanel:SetActive(true)
    self:UpdateSites()
  else
    MsgManager.ShowMsgByIDTable(43489)
    self.sitePanel:SetActive(false)
  end
end

function EquipStrengthView:UpdateSites()
  local normalStrengthMap = _StrengthenProxy.strengthMap[_TYPE]
  if normalStrengthMap and 0 < #normalStrengthMap then
    local result = {}
    for i = 1, #normalStrengthMap do
      local siteStrengthData = normalStrengthMap[i]
      local _site = siteStrengthData.site
      local _tempData = {
        site = _site,
        lv = siteStrengthData.lv
      }
      local equipData = BagProxy.Instance:GetEquipBySite(_site)
      _tempData.itemdata = equipData
      table.insert(result, _tempData)
    end
    self.siteCtrl:ResetDatas(result)
  end
end

local _PACKAGECHECK = {
  2,
  1,
  20
}

function EquipStrengthView:GetValidEquips()
  local _BagProxy = BagProxy.Instance
  local validType = {}
  for k, v in pairs(GameConfig.EquipChooseFilter) do
    local types = v.types
    for i = 1, #types do
      validType[types[i]] = 1
    end
  end
  local result = {}
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      local data = items[j]
      local equipType = data and data.staticData and data.staticData.Type
      if validType[equipType] then
        TableUtility.ArrayPushBack(result, data)
      end
    end
  end
  return result
end
