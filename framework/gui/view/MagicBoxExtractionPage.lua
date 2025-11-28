MagicBoxExtractionPage = class("MagicBoxExtractionPage", SubView)
autoImport("ExtractionSlotCell")
autoImport("EquipChooseBord")
autoImport("ExtractionData")
autoImport("ExtractionAttrCell")
local prefabPath = ResourcePathHelper.UIView("MagicBoxExtractionPage")
local ExtractionCheckBagTypes = GameConfig.PackageMaterialCheck.extraction
local BagProxy = BagProxy.Instance
local EquipExtractionConfig = GameConfig.EquipExtraction
local ExtractionCostItem = EquipExtractionConfig.ExtractionCostItem
local ExtraCost = EquipExtractionConfig.ExtraCost
local RefreshCost = EquipExtractionConfig.RefreshCost
local black = LuaColor.New(0.08627450980392157, 0.08627450980392157, 0.08627450980392157)
local red = LuaColor.New(0.8117647058823529, 0.10980392156862745, 0.058823529411764705)
local grey = LuaColor.New(0.4470588235294118, 0.4470588235294118, 0.4470588235294118)
local orange = LuaColor.New(0.6196078431372549, 0.27450980392156865, 0)
local mine = 0
local discount = 1
local gridid, itemid

function MagicBoxExtractionPage:Init()
  self:LoadSubView()
  self:InitUI()
  self:AddViewEvent()
  self:AddListener()
  self.lotteryName = Table_Item[151].NameZh
  self.iconName = Table_Item[ExtractionCostItem].NameZh
end

function MagicBoxExtractionPage:LoadSubView()
  local container = self:FindGO("MagicBoxExtractionPage")
  local obj = self:LoadPreferb_ByFullPath(prefabPath, container, true)
  obj.name = "MagicBoxExtractionPage"
end

function MagicBoxExtractionPage:InitUI()
  self.scrollView = self:FindGO("SlotScrollview"):GetComponent(UIScrollView)
  self.slotGrid = self:FindGO("slotGrid"):GetComponent(UIGrid)
  self.slotGridCtrl = UIGridListCtrl.new(self.slotGrid, ExtractionSlotCell, "ExtractionSlotCell")
  self.slotGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickSlotCell, self)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord.new(chooseContaienr, function()
    return self:GetValidEquips()
  end)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  local currentItemContainer = self:FindGO("currentItemContainer")
  self.hideContainer = self:FindGO("hideContainer")
  local tip1 = self:FindGO("tip1"):GetComponent(UILabel)
  local tip2 = self:FindGO("tip2"):GetComponent(UILabel)
  tip1.text = ZhString.MagicBox_Tip1
  tip2.text = ZhString.MagicBox_Tip2
  self.equipName = self:FindGO("equipName"):GetComponent(UILabel)
  self.infoTable = self:FindGO("Table"):GetComponent(UITable)
  self.infoTableCtrl = UIGridListCtrl.new(self.infoTable, ExtractionAttrCell, "ExtractionAttrCell")
  self.chooseItemIcon = self:FindGO("chooseItem"):GetComponent(UISprite)
  self.currentContainer = self:FindGO("currentContainer")
  self.costContainer = self:FindGO("CostContainer")
  self.costNum = self:FindGO("costNum"):GetComponent(UILabel)
  self.costNum.text = ""
  self.costIcon = self:FindGO("costIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(ExtractionCostItem, self.costIcon)
  self.activeBtn = self:FindGO("ActiveBtn")
  self.activeBtnLabel = self:FindGO("Label", self.activeBtn):GetComponent(UILabel)
  self.noRefreshTip = self:FindGO("NoRefreshTip")
  local noRefreshTipLabel = self:FindGO("Label", self.noRefreshTip):GetComponent(UILabel)
  noRefreshTipLabel.text = ZhString.MagicBox_NoRefreshTip
  self.currentTip = self:FindGO("currentTip"):GetComponent(UILabel)
  self.discount = self:FindGO("discount")
  self.discountLabel = self:FindGO("Label", self.discount):GetComponent(UILabel)
  self.lvTip = self:FindGO("lvTip"):GetComponent(UILabel)
  self.effect = self:FindGO("effect")
  self:PlayUIEffect(EffectMap.UI.Eff_53EquipStreng, self.effect, false)
  self.halo = {}
  for i = 1, 3 do
    self.halo[i] = self:FindComponent("halo" .. i, UITexture)
    PictureManager.Instance:SetUI("equip_bg_halo", self.halo[i])
  end
  self.texture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI("magicbox_bg_matrix", self.texture)
  HappyShopProxy.Instance:InitShop(nil, 1, 650)
  self.addCostButton = self:FindGO("addcostbutton")
  if BranchMgr.IsJapan() then
    self.addCostButton:SetActive(false)
  else
    self:AddClickEvent(self.addCostButton, function()
      local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
      local buyGood
      if shopData then
        local goods = shopData:GetGoods()
        for k, good in pairs(goods) do
          if good.id == 201340 then
            buyGood = good
          end
        end
      end
      if buyGood then
        local buyCell = TipsView.Me():HappyShopBuyItem(self.addCostButton, {-420, 200}, buyGood)
        buyCell:UpdateOwnInfo(ExtractionCheckBagTypes)
      else
        MsgManager.ShowMsgByID(3626)
      end
    end)
  end
end

function MagicBoxExtractionPage:AddViewEvent()
  self.addBtn = self:FindGO("AddBtn")
  self:AddClickEvent(self.addBtn, function(go)
    if not self.currentCell then
      return
    end
    self:ShowEquipBord()
  end)
  self:AddClickEvent(self.chooseItemIcon.gameObject, function(go)
    if not self.currentCell then
      return
    end
    if self.currentCell.data.itemid == 0 then
      self:ShowEquipBord()
    end
  end)
  self.extractBtn = self:FindGO("ExtractBtn")
  self.extractButton = self.extractBtn:GetComponent(UIButton)
  self:AddClickEvent(self.extractBtn, function(go)
    local single = self.currentCell and self.currentCell.data
    if single and single.itemStaticData then
      self:CallRefresh()
    else
      FunctionSecurity.Me():EquipExtraction(self.CallExtract, self)
    end
    self:LockCall()
  end)
  self.extractBtnLabel = self:FindGO("Label", self.extractBtn):GetComponent(UILabel)
  self:AddClickEvent(self.activeBtn, function(go)
    self:CallActive()
  end)
  self.emptyBtn = self:FindGO("EmptyBtn")
  self:AddClickEvent(self.emptyBtn, function(go)
    self:CallEmpty()
  end)
  self:AddClickEvent(self:FindGO("CloseButton"), function(go)
    self:sendNotification(MagicBoxEvent.CloseContainerview)
  end)
  local helpBtn = self:FindGO("HelpBtn")
  local penelID = PanelConfig.MagicBoxPanel.id
  self:RegistShowGeneralHelpByHelpID(penelID, helpBtn)
end

function MagicBoxExtractionPage:AddListener()
  self:AddListenEvt(ServiceEvent.NUserExtractionQueryUserCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.NUserExtractionOperateUserCmd, self.OperateResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionActiveUserCmd, self.ActiveResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionRemoveUserCmd, self.RemoveResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionGridBuyUserCmd, self.PurchaseResult)
  self:AddListenEvt(ServiceEvent.NUserExtractionRefreshUserCmd, self.RefreshResult)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleUpdateCurrentCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleUpdateCurrentCost)
end

function MagicBoxExtractionPage:InitView()
  local showdata = {}
  showdata.data = AttrExtractionProxy.Instance:GetExtractionDataByGrid(1)
  self:ClickSlotCell(showdata)
end

function MagicBoxExtractionPage:ClickSlotCell(cell)
  if not cell then
    return
  end
  if not cell.data.got then
    if BranchMgr.IsJapan() then
      OverseaHostHelper:ExtractionSlotConfirm({
        costid = EquipExtractionConfig.GridBuyCostItem,
        costnum = EquipExtractionConfig.GridBuyCostCount
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ExtractionSlotPopUp,
        viewdata = {
          costid = EquipExtractionConfig.GridBuyCostItem,
          costnum = EquipExtractionConfig.GridBuyCostCount
        }
      })
    end
    return
  end
  self.currentCell = cell
  local cells = self.slotGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i].data.gridid == cell.data.gridid)
  end
  self.equipName.text = ""
  self.hideContainer:SetActive(true)
  self.currentContainer:SetActive(false)
  self:UpdateInfoContainer()
  self:UpdateButton()
end

function MagicBoxExtractionPage:UpdateInfoContainer()
  local single = self.currentCell and self.currentCell.data
  if not single or single.itemid == 0 then
    self.hideContainer:SetActive(true)
    self.currentContainer:SetActive(false)
    self.noRefreshTip:SetActive(false)
    self.extractBtn:SetActive(true)
    self.extractBtnLabel.text = ZhString.MagicBox_Extract
    self.extractButton.isEnabled = false
    self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
    self.extractBtnLabel.effectColor = grey
    self.equipName.text = ""
    self.chooseItemIcon.gameObject:SetActive(false)
    self.discount:SetActive(false)
    local iconsp = Table_Item[ExtractionCostItem].Icon
    IconManager:SetItemIcon(iconsp, self.costIcon)
    self.costNum.text = "0"
    self.addCostButton:SetActive(true)
  else
    self.hideContainer:SetActive(false)
    self.extractButton.isEnabled = true
    self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
    self.extractBtnLabel.effectColor = orange
    self.currentContainer:SetActive(true)
    self.equipName.text = single.itemStaticData.NameZh
    self:UpdateBuffInfo(single.itemid)
    if single.itemStaticData then
      IconManager:SetItemIcon(single.itemStaticData.Icon, self.chooseItemIcon)
      self.equipName.text = single.itemStaticData.NameZh
      self.chooseItemIcon.gameObject:SetActive(true)
    end
    self:SetUpRefresh()
    self.addCostButton:SetActive(false)
  end
end

function MagicBoxExtractionPage:UpdateButton()
  local single = self.currentCell and self.currentCell.data
  if single and single.active then
    self.activeBtnLabel.text = ZhString.MagicBox_Deactive
  else
    self.activeBtnLabel.text = ZhString.MagicBox_Active
  end
end

local contextlabel

function MagicBoxExtractionPage:UpdateBuffInfo(equipID)
  self.costContainer:SetActive(false)
  if contextlabel then
    TableUtility.ArrayClear(contextlabel)
  else
    contextlabel = {}
  end
  local str = Table_EquipExtraction[equipID].Dsc
  local bufferStrs = string.split(str, "\n")
  for j = 1, #bufferStrs do
    table.insert(contextlabel, bufferStrs[j])
  end
  self.infoTableCtrl:ResetDatas(contextlabel)
end

function MagicBoxExtractionPage:ShowEquipBord()
  local datas = self:GetValidEquips()
  self.chooseBord:ResetDatas(datas, true)
  self.chooseBord:Show(false, function(self, data)
    self:SetTargetItem(data)
    self.chooseBord:Hide()
  end, self)
  local nowData = self:GetNowItemData()
  if nowData then
    self.chooseBord:SetChoose(nowData)
  end
  self.chooseBord:SetNoneTip(ZhString.MagicBox_NoneTip)
  self.chooseBord:SetBordTitle(ZhString.NpcRefinePanel_ChooseEquip)
end

local equipID = 0
local refreshType = 0

function MagicBoxExtractionPage:SetUpRefresh()
  if not self.currentCell then
    redlog("not self.currentCell")
    return
  end
  local single = self.currentCell.data
  equipID = single.itemid
  refreshType = Table_EquipExtraction[equipID].RefreshType
  if refreshType == 1 and single.refinelv > single.extractionLv then
    self.extractBtnLabel.text = ZhString.MagicBox_Refresh
    self.currentCost = RefreshCost
    self:UpdateCurrentCost(true)
    self.costContainer:SetActive(true)
    self.noRefreshTip:SetActive(false)
    self.extractBtn:SetActive(true)
    self.currentTip.text = string.format(ZhString.MagicBox_RefreshTip, single.refinelv, single.extractionLv)
    self.lvTip.text = string.format(ZhString.MagicBox_LvTip, single.extractionLv, single.refinelv)
  else
    if refreshType == 1 and single.refinelv ~= 0 then
      self.currentTip.text = string.format(ZhString.MagicBox_RefreshTip, single.refinelv, single.extractionLv)
      self.lvTip.text = string.format(ZhString.MagicBox_LvTip, single.extractionLv, single.refinelv)
    else
      self.currentTip.text = ""
      self.lvTip.text = ""
    end
    self.costNum.text = ""
    self.costContainer:SetActive(false)
    self.noRefreshTip:SetActive(true)
    self.extractBtn:SetActive(false)
  end
end

function MagicBoxExtractionPage:SetTargetItem(data)
  self.itemdata = data
end

function MagicBoxExtractionPage:GetNowItemData()
  return self.itemdata
end

function MagicBoxExtractionPage:ChooseItem(itemdata)
  if not self.currentCell then
    redlog("not self.currentCell")
    return
  end
  self.itemdata = itemdata
  local single = self.currentCell and self.currentCell.data
  IconManager:SetItemIcon(self.itemdata.staticData.Icon, self.chooseItemIcon)
  self.chooseItemIcon.gameObject:SetActive(true)
  local equipid = self.itemdata.staticData.id
  local config = Table_EquipExtraction[equipid] and Table_EquipExtraction[equipid].RefineLvCost
  local refinelv = self.itemdata.equipInfo.refinelv or 0
  self.equipName.text = self.itemdata.staticData.NameZh
  refreshType = Table_EquipExtraction[equipid].RefreshType
  if refreshType == 1 then
    self.currentTip.text = string.format(ZhString.MagicBox_RefreshTip, refinelv, "?")
    self.lvTip.text = string.format(ZhString.MagicBox_LvTip, "?", refinelv)
  else
    self.currentTip.text = string.format(ZhString.MagicBox_NoRefreshTip2)
    self.lvTip.text = string.format("[c][39E0F3]%s[-][/c]", refinelv)
  end
  self.currentContainer:SetActive(true)
  self:UpdateBuffInfo(equipid)
  self.costContainer:SetActive(true)
  self.hideContainer:SetActive(false)
  self.discount:SetActive(false)
  refinelv = refinelv + 1
  self.currentCost = config and config[refinelv]
  self:UpdateCurrentCost(false)
end

function MagicBoxExtractionPage:UpdateCurrentCost(setRefresh)
  self.currentCost = self.currentCost or 0
  if setRefresh ~= nil then
    self.setRefresh = setRefresh
  end
  local costitem = ExtractionCostItem
  mine = BagProxy.Instance:GetItemNumByStaticID(costitem, ExtractionCheckBagTypes)
  if self.setRefresh then
    discount = AttrExtractionProxy.Instance:GetDiscount(costitem)
  else
    discount = 1
  end
  if mine >= self.currentCost * discount and self.currentCost > 0 then
    self.extractButton.isEnabled = true
    self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
    self.extractBtnLabel.effectColor = orange
    self.costNum.color = black
    self.discount:SetActive(discount ~= 1)
    self.discountLabel.text = string.format(ZhString.MagicBox_Discount, 100 - discount * 100)
  elseif self.setRefresh and not BranchMgr.IsJapan() then
    self.extractButton.isEnabled = true
    self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
    self.extractBtnLabel.effectColor = orange
    mine = MyselfProxy.Instance:GetLottery()
    discount = AttrExtractionProxy.Instance:GetDiscount(151)
    self.currentCost = ExtraCost
    if mine >= self.currentCost * discount then
      self.costNum.color = black
    else
      self.costNum.color = red
    end
    costitem = 151
    self.discount:SetActive(discount ~= 1)
    self.discountLabel.text = string.format(ZhString.MagicBox_Discount, 100 - discount * 100)
  else
    self.discount:SetActive(discount ~= 1)
    self.discountLabel.text = string.format(ZhString.MagicBox_Discount, 100 - discount * 100)
    self.extractButton.isEnabled = false
    self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
    self.extractBtnLabel.effectColor = grey
    self.costNum.color = red
  end
  iconsp = Table_Item[costitem].Icon
  IconManager:SetItemIcon(iconsp, self.costIcon)
  self.costNum.text = math.ceil(self.currentCost * discount)
end

function MagicBoxExtractionPage:HandleUpdateCurrentCost()
  self:UpdateCurrentCost()
end

local _isEquipClean

function MagicBoxExtractionPage:GetValidEquips()
  local result = {}
  if not _isEquipClean then
    _isEquipClean = BagProxy.CheckEquipIsClean
  end
  for k, v in pairs(Table_EquipExtraction) do
    local equiplist = BagProxy:GetItemsByStaticID(v.id) or {}
    for i = 1, #equiplist do
      if not BagProxy:CheckIsFavorite(equiplist[i]) and _isEquipClean(equiplist[i], true) and not equiplist[i].equipInfo.damage then
        if v.RefreshType == 1 and equiplist[i].equipInfo.refinelv > 0 then
          table.insert(result, equiplist[i])
        elseif v.RefreshType == 0 then
          table.insert(result, equiplist[i])
        end
      end
    end
  end
  return result
end

function MagicBoxExtractionPage:CheckEquipValid(item)
  local equipInfo = item.equipInfo
  local enchantInfo = item.enchantInfo
  local nocards = not item:HasEquipedCard()
  if equipInfo and equipInfo.strengthlv <= 0 and 0 >= equipInfo.strengthlv2 and 0 >= equipInfo.equiplv and nocards and (not enchantInfo or not enchantInfo:HasAttri()) then
    if expRefine == true then
      return true
    else
      return 0 >= equipInfo.refinelv
    end
  end
  return false
end

function MagicBoxExtractionPage:UpdateView(note)
  if note and note.body then
    self:UpdateSlotList()
  end
  self:InitView()
end

function MagicBoxExtractionPage:UpdateSlotList()
  local gridlist = AttrExtractionProxy.Instance:GetExtractDataList()
  self.slotGridCtrl:ResetDatas(gridlist)
end

function MagicBoxExtractionPage:OnEnter()
  MagicBoxExtractionPage.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallExtractionQueryUserCmd()
end

function MagicBoxExtractionPage:CallExtract()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid and self.itemdata then
    gridid = self.currentCell.data.gridid
    itemid = self.itemdata.id
    FunctionSecurity.Me():NormalOperation(function()
      MsgManager.ConfirmMsgByID(40988, function()
        ServiceNUserProxy.Instance:CallExtractionOperateUserCmd(gridid, itemid)
      end)
    end)
  end
end

function MagicBoxExtractionPage:CallActive()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.itemid == 0 then
      MsgManager.ShowMsgByIDTable(40917)
    else
      ServiceNUserProxy.Instance:CallExtractionActiveUserCmd(self.currentCell.data.gridid)
    end
  end
end

function MagicBoxExtractionPage:CallEmpty()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.itemid == 0 then
      return
    end
    if self.currentCell.data.active then
      MsgManager.ShowMsgByIDTable(40915)
    else
      gridid = self.currentCell.data.gridid
      FunctionSecurity.Me():NormalOperation(function()
        MsgManager.ConfirmMsgByID(40987, function()
          ServiceNUserProxy.Instance:CallExtractionRemoveUserCmd(gridid)
        end)
      end)
    end
  else
    redlog("self.currentCell nil")
  end
end

function MagicBoxExtractionPage:CallRefresh()
  if self.currentCell and self.currentCell.data and self.currentCell.data.gridid then
    if self.currentCell.data.active then
      MsgManager.ShowMsgByIDTable(41110)
      return
    end
    gridid = self.currentCell.data.gridid
    mine = BagProxy.Instance:GetItemNumByStaticID(ExtractionCostItem, ExtractionCheckBagTypes)
    local discount = AttrExtractionProxy.Instance:GetDiscount(ExtractionCostItem)
    if mine < RefreshCost * discount then
      mine = MyselfProxy.Instance:GetLottery()
      discount = AttrExtractionProxy.Instance:GetDiscount(151)
      if mine < ExtraCost * discount then
        MsgManager.ConfirmMsgByID(3551, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
        return
      else
        gridid = self.currentCell.data.gridid
        FunctionSecurity.Me():NormalOperation(function()
          local text = Table_Sysmsg[40984] and Table_Sysmsg[40984].Text or ""
          local str = string.format(text, self.iconName, ExtraCost * discount, self.lotteryName)
          UIUtil.PopUpConfirmYesNoView("", str, function()
            ServiceNUserProxy.Instance:CallExtractionRefreshUserCmd(self.currentCell.data.gridid, true)
          end, nil, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
        end)
        return
      end
    else
      FunctionSecurity.Me():NormalOperation(function()
        ServiceNUserProxy.Instance:CallExtractionRefreshUserCmd(gridid)
      end)
    end
  else
    redlog("self.currentCell nil")
  end
end

function MagicBoxExtractionPage:OperateResult(note)
  if note and note.body and note.body.data then
    self:UpdateSlotList()
    self:ClickSlotCell(self.currentCell)
    self:SetUpRefresh()
  end
  self:CancelLockCall()
end

function MagicBoxExtractionPage:CheckShare()
  if self.currentCell and self.currentCell.data then
    local single = self.currentCell.data
    if single.refinelv == single.extractionLv then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.MagicBoxExtractionShareView,
        viewdata = single
      })
    end
  end
end

function MagicBoxExtractionPage:ActiveResult(note)
  if note and note.body then
    self:UpdateSlotList()
    self:UpdateButton()
  end
end

function MagicBoxExtractionPage:RemoveResult(note)
  if note and note.body and note.body.success then
    self:UpdateSlotList()
    self:UpdateInfoContainer()
  end
end

function MagicBoxExtractionPage:PurchaseResult(note)
  if note and note.body then
    self:UpdateSlotList()
  else
    redlog("not nil")
  end
end

function MagicBoxExtractionPage:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function MagicBoxExtractionPage:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function MagicBoxExtractionPage:OnExit()
  self:CancelLockCall()
  if self.slotGridCtrl then
    self.slotGridCtrl:Destroy()
  end
  for i = 1, 3 do
    if self.halo[i] then
      PictureManager.Instance:UnLoadUI("equip_bg_halo", self.halo[i])
    end
  end
  PictureManager.Instance:UnLoadUI("magicbox_bg_matrix", self.texture)
  MagicBoxExtractionPage.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function MagicBoxExtractionPage:RefreshResult(note)
  if note and note.body and note.body.data then
    self:UpdateSlotList()
    self:ClickSlotCell(self.currentCell)
    self:SetUpRefresh()
    self:CheckShare()
  end
  self:CancelLockCall()
end
