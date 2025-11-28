autoImport("EquipCombineTableCell")
autoImport("EquipComposeCell")
autoImport("EquipNewChooseBord")
autoImport("EquipUtil")
EquipComposeView = class("EquipComposeView", BaseView)
EquipComposeView.ViewType = UIViewType.NormalLayer
local PACKAGE_CFG = GameConfig.PackageMaterialCheck.equipcompose
local _PictureMrg = PictureManager.Instance
local _BgTexName = "Equipmentopen_bg_bottom_09"
local ACTION_NAME = "functional_action"

function EquipComposeView:Init()
  EquipComposeProxy.Instance:InitData()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitView()
  self:ClickMatToggle()
  self:SelectFirstMat()
end

function EquipComposeView:FindObjs()
  self.btn = self:FindComponent("Btn", UIMultiSprite)
  self.btnName = self:FindComponent("BtnName", UILabel)
  self.toggleName = self:FindComponent("ToggleName", UILabel)
  self.profressionToggle = self:FindComponent("Toggle", UIToggle)
  self.equipTable = self:FindComponent("EquipTable", UITable)
  self.equipScrollview = self:FindComponent("EquipScroll", UIScrollView)
  self.costScrollView = self:FindComponent("CostScrollView", UIScrollView)
  self.zenyLab = self:FindComponent("CostLab", UILabel)
  local tipMatLab = self:FindComponent("TipMatLab", UILabel)
  tipMatLab.text = ZhString.EquipCompose_Mat
  self.targetObj = self:FindGO("TargetCell")
  self.targetCell = EquipComposeCell.new(self.targetObj)
  self.targetMainObj = self:FindGO("TargetMainMatCell")
  self.targetMainCell = EquipComposeCell.new(self.targetMainObj)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.titleLab = self:FindComponent("TitleLab", UILabel)
  self.titleLab.text = ZhString.EquipCompose_Title
  self.coinIcon = self:FindComponent("CoinIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.coinIcon)
  self.leftPos = self:FindGO("LeftPos")
  self:FindCoin()
end

function EquipComposeView:FindCoin()
  local coins = self:FindChild("TopCoins")
  self.lottery = self:FindChild("Lottery", coins)
  self.lotterylabel = self:FindComponent("Label", UILabel, self.lottery)
  local icon = self:FindComponent("symbol", UISprite, self.lottery)
  IconManager:SetItemIcon(Table_Item[151].Icon, icon)
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  icon = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[100].Icon, icon)
end

function EquipComposeView:InitView()
  self.targetMatObj = {}
  self.targetMatData = {}
  for i = 1, 5 do
    self.targetMatObj[i] = self:FindGO("TargetMatCell" .. i)
    self.targetMatData[i] = EquipComposeCell.new(self.targetMatObj[i])
    self:AddClickEvent(self.targetMatObj[i], function()
      self:OnClickMat(self.targetMatData[i].data)
    end)
  end
  local costGrid = self:FindComponent("CostGrid", UIGrid)
  self.costCtl = UIGridListCtrl.new(costGrid, EquipComposeCell, "EquipComposeCell")
  self.costCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCostItem, self)
  if not self.equipList then
    local container = self:FindGO("EquipWrap")
    local wrapConfig = {
      wrapObj = container,
      pfbNum = 10,
      cellName = "EquipCombineTableCell",
      control = EquipCombineTableCell
    }
    self.equipList = WrapCellHelper.new(wrapConfig)
    self.equipList:AddEventListener(MouseEvent.MouseClick, self.ClickTabItem, self)
    self.equipList:AddEventListener(EquipCombineTableCell.ClickArrow, self.OnClickArrow, self)
  end
  local allData = EquipComposeProxy.Instance:GetTypeFilterData()
  self.equipList:ResetDatas(allData)
  local chooseContaienr = self:FindGO("ChooseContainer")
  local chooseBordDataFunc = function()
    return self:GetComposeEquips(self.curMatItemData.staticData.id)
  end
  self.chooseBord = EquipNewChooseBord.new(chooseContaienr, chooseBordDataFunc)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord.needSetCheckValidFuncOnShow = false
  self.chooseBord:Set_CheckValidFunc(self.CheckIsFavorite, self, ZhString.EquipCompose_BanFav, true)
  self.chooseBord:Hide()
end

function EquipComposeView:CheckIsFavorite(item)
  return not BagProxy.Instance:CheckIsFavorite(item)
end

function EquipComposeView:ClickCostItem(cellctl)
  if cellctl and cellctl.data then
    if self.curClickCost ~= cellctl.data then
      self.curClickCost = cellctl.data
      local stick = cellctl.gameObject:GetComponent(UIWidget)
      local sdata = {
        itemdata = cellctl.data,
        funcConfig = {},
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    else
      self.curClickCost = nil
      TipManager.Instance:CloseTip()
    end
  else
    TipManager.Instance:CloseTip()
  end
end

function EquipComposeView:SelectFirstMat()
  local cells = self.equipList:GetCellCtls()
  local cell = cells and 1 < #cells and cells[2] or nil
  if cell and #cell:GetCells() > 0 then
    local targetID = EquipComposeProxy.Instance:GetTargetID()
    if targetID then
      for i = 1, #cells do
        local cellGroup = cells[i]:GetCells()
        for j = 1, #cellGroup do
          if cellGroup[j].data.staticData.id == targetID then
            xdlog("初始选中目标", targetID)
            self:ClickTabItem(cellGroup[j], true)
            self:AutoChooseMat()
            self:ResetBtnState()
            return
          end
        end
      end
    else
      self:ClickTabItem(cell:GetCells()[1], true)
    end
  end
end

function EquipComposeView:ChooseItem(item)
  if BagProxy.Instance:CheckIsFavorite(item) then
    MsgManager.ShowMsgByID(40021)
    return
  end
  local equipInfo = item.equipInfo
  if equipInfo.strengthlv2 > 0 then
    MsgManager.ShowMsgByID(40005)
    return
  end
  local cardids = {}
  local equipedCards = item.equipedCardInfo
  if equipedCards then
    for j = 1, item.cardSlotNum do
      if equipedCards[j] then
        table.insert(cardids, equipedCards[j].id)
      end
    end
  end
  EquipComposeProxy.Instance:SetChooseMat(self.curMatIndex, item)
  local curData = EquipComposeProxy.Instance:GetCurData()
  if item.staticData.id == curData.mainMat.staticData.id then
    self.targetMainCell:SetData(curData.mainMat)
  else
    for i = 1, 5 do
      self.targetMatData[i]:SetData(curData.MatArray[i] or {})
    end
  end
  self.chooseBord:Hide()
  self:ResetBtnState()
end

function EquipComposeView:GetComposeEquips(staticID, all)
  local result = {}
  local bagEquips = BagProxy.Instance:GetMaterialItems_ByItemId(staticID, PACKAGE_CFG)
  local curData = EquipComposeProxy.Instance:GetCurData()
  local lackLvEquip
  if bagEquips then
    for i = 1, #bagEquips do
      local equipInfo = bagEquips[i].equipInfo
      if equipInfo then
        local equipLv = equipInfo.equiplv
        local isDamage = equipInfo.damage
        local lvLimited = curData:GetMatLimitedLv(bagEquips[i].staticData.id)
        if not isDamage and nil ~= equipLv then
          if equipLv == lvLimited then
            result[#result + 1] = bagEquips[i]
          elseif not lackLvEquip then
            lackLvEquip = bagEquips[i]
          elseif bagEquips[i].equipInfo.equiplv > lackLvEquip.equipInfo.equiplv then
            lackLvEquip = bagEquips[i]
          end
        end
      end
    end
  end
  return result, lackLvEquip
end

function EquipComposeView:OnClickMat(data)
  if not data or not data.staticData then
    return
  end
  self.curMatItemData = data
  self.curMatIndex = data.staticData.id
  local equipdatas, lackLvEquip = self:GetComposeEquips(data.staticData.id)
  local lackItems = {}
  local lvLimited = data.equipLvLimited
  local levelUpCount = lackLvEquip and lackLvEquip.equipInfo.equiplv and lvLimited - lackLvEquip.equipInfo.equiplv or lvLimited - 1
  local costs, costZeny = EquipUtil.CalcEquipUpgradeCost(data.staticData.id, lvLimited)
  for i = 1, #costs do
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costs[i].id, PACKAGE_CFG)
    if ownNum < costs[i].num then
      local lackItem = {
        id = costs[i].id,
        count = costs[i].num - ownNum
      }
      TableUtility.ArrayPushBack(lackItems, lackItem)
    end
  end
  if 0 < #equipdatas then
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:Show(true)
    self:Hide(self.leftPos)
  else
    if 0 < #lackItems then
      QuickBuyProxy.Instance:TryOpenView(lackItems, QuickBuyProxy.QueryType.NoDamage, true)
      return
    end
    if costZeny > MyselfProxy.Instance:GetROB() then
      MsgManager.ShowMsgByID(40014)
      return
    end
    MsgManager.ShowMsgByID(40011)
  end
end

function EquipComposeView:ClickTabItem(cellctl, isFirst)
  local data = cellctl and cellctl.data
  if not data then
    self:ResetRightView()
    return
  end
  EquipComposeProxy.Instance:SetCurrentData(data)
  local curData = EquipComposeProxy.Instance:GetCurData()
  for i = 1, 5 do
    self.targetMatData[i]:SetData(curData.MatArray[i] or {})
  end
  self.costCtl:ResetDatas(curData.material)
  self.costScrollView:ResetPosition()
  self.zenyLab.text = StringUtil.NumThousandFormat(curData.cost)
  self:RefreshChooseCell(curData.composeID)
  self.targetCell:SetData(curData.itemdata)
  self.targetMainCell:SetData(curData.mainMat)
  self:ResetBtnState()
  if not isFirst then
    self:Hide(self.leftPos)
    self.chooseBord:Hide()
  end
end

function EquipComposeView:OnClickArrow(tab)
  local data = EquipComposeProxy.Instance:GetTypeFilterData(self.profressionToggle.value)
  self.equipList:ResetDatas(data)
end

local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.26666666666666666, 0.37254901960784315, 0.6823529411764706), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)

function EquipComposeView:ResetBtnState()
  local curData = EquipComposeProxy.Instance:GetCurData()
  self.btn.CurrentState = curData and 1 or 0
  self.btnName.color = curData and ColorUtil.NGUIWhite or inactiveLabelColor
  self.btnName.effectColor = curData and activeLabelEffectColor or inactiveLabelEffectColor
  if not curData then
    self.btnName.text = ZhString.EquipCompose_BtnName
  else
    self.btnName.text = curData:IsMatLimited() and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipCompose_BtnName
  end
end

function EquipComposeView:ResetRightView()
  for i = 1, 5 do
    self.targetMatData[i]:SetData()
  end
  self.costCtl:ResetDatas()
  self.costScrollView:ResetPosition()
  self.zenyLab.text = ""
  self:RefreshChooseCell()
  self.targetCell:SetData()
  self.targetMainCell:SetData()
  self:ResetBtnState()
end

function EquipComposeView:RefreshChooseCell(id)
  local Cells = self.equipList:GetCellCtls()
  for i = 1, #Cells do
    local cell = Cells[i]:GetCells()
    for j = 1, #cell do
      cell[j]:SetChoose(id)
    end
  end
end

function EquipComposeView:OnEnter()
  EquipComposeView.super.OnEnter(self)
  self:UpdateCoin()
  _PictureMrg:SetUI(_BgTexName, self.bgTex)
end

function EquipComposeView:OnExit()
  EquipComposeProxy.Instance:SetCurrentData()
  EquipComposeProxy.Instance:ResetCategoryActive()
  EquipComposeProxy.Instance:ClearTargetID()
  _PictureMrg:UnLoadUI(_BgTexName, self.bgTex)
  EquipComposeView.super.OnExit(self)
end

function EquipComposeView:AddEvts()
  self:AddClickEvent(self.targetObj, function(go)
    self:Show(self.leftPos)
    do return end
    local stick = self.targetObj.gameObject:GetComponent(UIWidget)
    local sdata = {
      itemdata = self.targetCell.data,
      funcConfig = {}
    }
    self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
  end)
  self:AddClickEvent(self.btn.gameObject, function(g)
    self:OnBtn()
  end)
  EventDelegate.Add(self.profressionToggle.onChange, function()
    self:RefreshView()
  end)
  self:AddClickEvent(self.targetMainObj, function()
    self:OnClickMat(self.targetMainCell.data)
  end)
end

function EquipComposeView:UpdateCoin()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
  self.lotterylabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end

function EquipComposeView:ClickMatToggle()
  self.equipScrollview:ResetPosition()
  self:ResetPos()
end

function EquipComposeView:ResetPos()
  EquipComposeProxy.Instance:SetCurrentData()
  self:ResetRightView()
end

function EquipComposeView:RefreshView()
  local data = EquipComposeProxy.Instance:GetTypeFilterData(self.profressionToggle.value)
  self.equipList:ResetDatas(data)
  self.equipList:ResetPosition()
  self.equipScrollview:ResetPosition()
  if #data <= 1 then
    EquipComposeProxy.Instance:SetCurrentData()
    self:ResetRightView()
  else
    self:SelectFirstMat()
  end
end

function EquipComposeView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ItemEquipComposeItemCmd, self.HandleEquipCompose)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleEquipLevelUp)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoin)
end

function EquipComposeView:HandleEquipCompose(note)
  local msgID = note.body and note.body.retmsg
  if msgID ~= 0 then
    MsgManager.ShowMsgByID(msgID)
  else
    local npcs = NSceneNpcProxy.Instance:FindNpcs(4865)
    if npcs and 0 < #npcs then
      local npcdata = npcs[1]
      npcdata.assetRole:PlayAction_Simple(ACTION_NAME)
    end
    self:CloseSelf()
  end
end

function EquipComposeView:HandleEquipLevelUp()
  local curData = EquipComposeProxy.Instance:GetCurData()
  if not curData then
    return
  end
  self.costCtl:ResetDatas(curData.material)
  self:ResetBtnState()
end

function EquipComposeView:OnBtn()
  local curData = EquipComposeProxy.Instance:GetCurData()
  if not curData then
    return
  end
  local lackItems = self:TryGetCurrentLackItems()
  if 0 < #lackItems then
    QuickBuyProxy.Instance:TryOpenView(lackItems, QuickBuyProxy.QueryType.NoDamage, true)
    return
  end
  if curData:IsCostLimited() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if curData:IsMatLimited() then
    MsgManager.ShowMsgByID(40013)
    return
  end
  local chooseMat = curData:GetChooseMatArray()
  local sysmsgData = Table_Sysmsg[26001]
  local text = sysmsgData.Text
  local str = string.format(text, curData.itemStaticData.NameZh)
  UIUtil.PopUpConfirmYesNoView(sysmsgData.Title, str, function()
    ServiceItemProxy.Instance:CallEquipComposeItemCmd(curData.composeID, chooseMat)
  end, nil, nil, sysmsgData.button, sysmsgData.buttonF)
end

function EquipComposeView:TryGetCurrentLackItems()
  local lackItems = {}
  local curData = EquipComposeProxy.Instance:GetCurData()
  local curDataCostMat = curData.material
  local mainMatID = self.targetMainCell.data.staticData.id
  local mainMatEquipCount = self:GetComposeEquips(mainMatID)
  if not self.targetMainCell.choosed and #mainMatEquipCount <= 0 then
    local upgradeCount = self.targetMainCell.data.equipLvLimited
    if upgradeCount then
      local result = EquipUtil.CalcEquipUpgradeCost(mainMatID, upgradeCount)
      for i = 1, #result do
        local own = BagProxy.Instance:GetItemNumByStaticID(result[i].id, PACKAGE_CFG)
        local costNum = result[i].num
        if own < costNum then
          local lackItem = {
            id = result[i].id,
            count = costNum - own
          }
          lackItems[#lackItems + 1] = lackItem
        end
      end
    end
  end
  for i = 1, #self.targetMatData do
    if self.targetMatData[i].data and self.targetMatData[i].data.staticData then
      local equipid = self.targetMatData[i].data.staticData.id
      local equipdatas = self:GetComposeEquips(equipid)
      if not self.targetMatData[i].data:IsChoosed() and #equipdatas <= 0 then
        local upgradeCount = self.targetMatData[i].data.equipLvLimited
        if upgradeCount then
          local result = EquipUtil.CalcEquipUpgradeCost(equipid, upgradeCount)
          for i = 1, #result do
            local own = BagProxy.Instance:GetItemNumByStaticID(result[i].id, PACKAGE_CFG)
            local costNum = result[i].num
            if own < costNum then
              local lackItem = {
                id = result[i].id,
                count = costNum - own
              }
              lackItems[#lackItems + 1] = lackItem
            end
          end
        end
      end
    end
  end
  for i = 1, #curDataCostMat do
    local costStaticID = curDataCostMat[i].staticData.id
    local costNum = curDataCostMat[i].num
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costStaticID, PACKAGE_CFG)
    if costNum > ownNum then
      local lackItem = {
        id = costStaticID,
        count = costNum - ownNum
      }
      lackItems[#lackItems + 1] = lackItem
    end
  end
  return lackItems
end

function EquipComposeView:AutoChooseMat()
  local curData = EquipComposeProxy.Instance:GetCurData()
  if not curData then
    redlog("无选择目标 需要检查")
    return
  end
  local mainMatID = curData.mainMat.staticData.id
  local mainEquips = self:GetComposeEquips(mainMatID)
  if mainEquips and 0 < #mainEquips then
    for i = 1, #mainEquips do
      if self:CheckEquipCanAutoChoose(mainEquips[i]) then
        EquipComposeProxy.Instance:SetChooseMat(mainMatID, mainEquips[i])
        self.targetMainCell:SetData(curData.mainMat)
        xdlog("主装备选择", mainMatID, mainEquips[i].id)
        break
      end
    end
  end
  local subMatArray = curData.MatArray
  for i = 1, 5 do
    local subMatID = subMatArray[i] and subMatArray[i].staticData and subMatArray[i].staticData.id
    if subMatID then
      local subEquips = self:GetComposeEquips(subMatID)
      if subEquips and 0 < #subEquips then
        for j = 1, #subEquips do
          if self:CheckEquipCanAutoChoose(subEquips[j]) then
            EquipComposeProxy.Instance:SetChooseMat(subMatID, subEquips[j])
            xdlog("sub装备选择", subMatID, subEquips[j].id)
            self.targetMatData[i]:SetData(curData.MatArray[i] or {})
            break
          end
        end
      end
    end
  end
end

function EquipComposeView:CheckEquipCanAutoChoose(item)
  if BagProxy.Instance:CheckIsFavorite(item) then
    return false
  end
  local equipInfo = item.equipInfo
  if equipInfo.strengthlv2 > 0 then
    return false
  end
  local cardids = {}
  local equipedCards = item.equipedCardInfo
  if equipedCards then
    for j = 1, item.cardSlotNum do
      if equipedCards[j] then
        table.insert(cardids, equipedCards[j].id)
      end
    end
  end
  if 0 < #cardids then
    return false
  end
  return true
end
