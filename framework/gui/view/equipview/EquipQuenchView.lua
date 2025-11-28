autoImport("EquipNewChooseBord")
autoImport("MaterialItemNewCell1")
EquipQuenchView = class("EquipQuenchView", BaseView)
EquipQuenchView.BrotherView = QuenchCombineView
EquipQuenchView.ViewType = UIViewType.NormalLayer
local tempVector3 = LuaVector3.Zero()

function EquipQuenchView:OnEnter()
  if self.npcdata then
    local npcRootTrans = self.npcdata.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
  if self.isCombine then
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(-72, 0, 0)
    self.closeButton:SetActive(false)
  else
    self.content.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.closeButton:SetActive(true)
  end
  local OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
  if OnClickChooseBordCell_data then
    self:ChooseItem(OnClickChooseBordCell_data)
    self.chooseBord:Hide()
  end
  PictureManager.Instance:SetUI("anying_cuilian_bg_cuillian_", self.bg3Texture)
end

function EquipQuenchView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipQuenchView:OnExit()
  if self.infoTipCell then
    self.infoTipCell:OnDestroy()
  end
  self:CameraReset()
  PictureManager.Instance:UnLoadUI("anying_cuilian_bg_cuillian_", self.bg3Texture)
  TipsView.Me():HideCurrent()
  EquipQuenchView.super.OnExit(self)
  ItemUtil.SetManualQuenchValue(nil)
  ItemUtil.SetQuenchViewOpen(nil)
end

function EquipQuenchView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self.mincount = 1
  self.maxcount = 10
  self.count = 1
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function EquipQuenchView:FindObjs()
  self.content = self:FindGO("Content")
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.EquipQuench_Title
  self.addItemButton = self:FindGO("AddItemInButton")
  self.targetBtn = self:FindGO("TargetCell")
  self.effectContainer = self:FindGO("EffectContainer"):GetComponent(ChangeRqByTex)
  self.totalCost = self:FindGO("PriceNum"):GetComponent(UILabel)
  local sprite = self:FindComponent("PriceIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, sprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countLabel = self:FindGO("Count"):GetComponent(UILabel)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countTitle = self:FindGO("CountTitle"):GetComponent(UILabel)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.staticCost = self:FindGO("StaticCost")
  self.costScrollView = self:FindGO("ScrollView", self.staticCost):GetComponent(UIScrollView)
  self.staticCostCtl = ListCtrl.new(self:FindComponent("ScrollView/Grid", UIGrid, self.staticCost), MaterialItemNewCell1, "MaterialItemNewCell1")
  self.staticCostCtl:AddEventListener(MouseEvent.MouseClick, self.ClickStaticMatItem, self)
  self.priceIndicator = self:FindGO("PriceIndicator")
  self.priceTable = self.priceIndicator:GetComponent(UITable)
  self.priceSp = self:FindComponent("PriceIcon", UISprite)
  self.priceNumLabel = self:FindComponent("PriceNum", UILabel)
  self.itemNameBg = self:FindGO("NameBg"):GetComponent(UISprite)
  self.processStr1 = self:FindGO("string1"):GetComponent(UILabel)
  self.processStr2 = self:FindGO("string2"):GetComponent(UILabel)
  self.processStr3 = self:FindGO("string3"):GetComponent(UILabel)
  self.processBg = self:FindGO("tip1Bg"):GetComponent(UISprite)
  self.processStr1.text = ZhString.EquipQuench_CurProcess
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.emptyTip = self:FindGO("EmptyTip")
  self.bg3Texture = self:FindGO("Bg3"):GetComponent(UITexture)
  self.maxLabel = self:FindGO("MaxLabel")
  self.maxLabel:SetActive(false)
  self.itemTipContainer = self:FindGO("ItemTipContainer"):GetComponent(UIWidget)
  self.targetBtn:SetActive(false)
  self.emptyTip:SetActive(true)
  self:AddOrRemoveGuideId(self.addItemButton, 532)
  self:AddOrRemoveGuideId(self.confirmBtn, 534)
end

function EquipQuenchView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.confirmBtn, function(go)
    self:DoQuench()
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  EventDelegate.Set(self.countInput.onSubmit, function()
    self:InputOnSubmit()
  end)
end

function EquipQuenchView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RecvUpdateQuench)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.RecvUpdateQuench)
end

function EquipQuenchView:InitView()
  ItemUtil.SetQuenchViewOpen(true)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContaienr, function()
    return self:GetValidEquips()
  end)
  self.chooseBord:SetFilterPopData(GameConfig.QuenchFilter or GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.targetCell = BaseItemCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  self:ClickTargetCell()
end

function EquipQuenchView:DoQuench()
  xdlog("淬炼")
  if MyselfProxy.Instance:GetROB() < self.zenyCost then
    MsgManager.ShowMsgByID(1)
    return
  end
  local materialLack = false
  local cells = self.staticCostCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local data = cells[i].data
      if data.neednum > data.num then
        materialLack = true
        break
      end
    end
  end
  if materialLack then
    MsgManager.ShowMsgByID(3703)
    return
  end
  xdlog("淬炼目标", self.nowdata.id, self.count * 5)
  FunctionSecurity.Me():NormalOperation(function()
    ServiceItemProxy.Instance:CallQuenchEquipItemCmd(self.nowdata.id, self.count * 5)
  end)
  self:PlayEffect()
end

function EquipQuenchView:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess_Old, self.effectContainer.gameObject, true, self.ForgingSuccessEffectHandle, self)
end

function EquipQuenchView.ForgingSuccessEffectHandle(effectHandle, owner)
  if owner then
    owner.effectContainer:AddChild(effectHandle.gameObject)
  end
end

function EquipQuenchView:ChooseItem(itemData)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  self.title.text = itemData:GetName()
  self.chooseBord:Hide()
  self.targetBtn:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
  self.emptyTip:SetActive(itemData == nil)
  self:SetQuenchProgress(itemData)
  self:UpdateQuenchCost()
  self:ShowCurItemTip(nil, true)
end

function EquipQuenchView:SetQuenchProgress(itemData)
  local sites = itemData.equipInfo.site
  if not sites then
    redlog("no site")
  end
  local maxcount = ItemUtil.GetMaxQuenchPer(sites[1])
  self.maxcount = maxcount / 5
  local curProgress = itemData:GetQuenchPer() or 0
  self.mincount = curProgress / 5 + 1
  self.count = curProgress / 5 + 1
  if self.mincount > self.maxcount then
    self.mincount = self.maxcount
  end
  self.processStr2.text = curProgress
  self.processStr3.text = "%"
  local width1 = self.processStr1.printedSize.x
  local width2 = self.processStr2.printedSize.x
  local width3 = self.processStr3.printedSize.x
  local totalWidth = width1 + width2 + width3
  local offsetX = totalWidth / 2 - width2 - width3
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.processStr2.transform))
  tempVector3[1] = offsetX
  self.processStr2.transform.localPosition = tempVector3
  self.processStr1:ResetAndUpdateAnchors()
  self.processStr3:ResetAndUpdateAnchors()
  if 200 < totalWidth then
    self.processBg.width = totalWidth + 100
  end
  self.countInput.value = math.modf(self.mincount * 5) .. "%"
end

function EquipQuenchView:ClickTargetCell()
  local equipdatas = self:GetValidEquips()
  if 0 < #equipdatas then
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:Show(false)
  else
    MsgManager.ShowMsgByIDTable(43342)
    self.chooseBord:Hide()
  end
  if self.infoTipCell then
    self.infoTipCell.gameObject:SetActive(false)
  end
end

function EquipQuenchView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function EquipQuenchView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function EquipQuenchView:UpdateCount(change)
  self.count = self.count + self.countChangeRate * change
  if self.count < self.mincount then
    self.countChangeRate = 1
    self.count = self.mincount
  elseif self.count > self.maxcount then
    self.countChangeRate = 1
    self.count = self.maxcount
  end
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  if self.countInput.value ~= math.modf(self.count * 5) .. "%" then
    self.countInput.value = math.modf(self.count * 5) .. "%"
  end
end

function EquipQuenchView:InputOnChange()
  local value = string.gsub(self.countInput.value, "%%", "")
  local count = math.modf(tonumber(value))
  if count == nil then
    return
  end
  local count = count / 5
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  else
    if count <= self.mincount then
      self:SetCountSubtract(0.5)
    else
      self:SetCountSubtract(1)
    end
    if count >= self.maxcount then
      self:SetCountPlus(0.5)
    else
      self:SetCountPlus(1)
    end
  end
  self:UpdateQuenchCost()
  self:UpdateQuenchPreview(count * 5)
end

function EquipQuenchView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function EquipQuenchView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function EquipQuenchView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function EquipQuenchView:UpdateQuenchCost()
  local sites = self.nowdata.equipInfo.site
  if not sites then
    redlog("no site")
  end
  local config = GameConfig.ShadowEquip.Upgrade
  local posCostConfig = config and config[sites[1]]
  if not posCostConfig then
    redlog("缺少Upgrade pos配置", sites[1])
    return
  end
  self.confirmBtn:SetActive(true)
  self.maxLabel:SetActive(false)
  self.staticCost:SetActive(true)
  local startProgress = self.mincount * 5
  local curProgress = self.count * 5
  local items = {}
  local zenyCost = 0
  for k, costs in pairs(posCostConfig) do
    if k >= startProgress and k <= curProgress then
      local materials = costs.Material
      for i = 1, #materials do
        if materials[i][1] == 100 then
          zenyCost = zenyCost + materials[i][2]
        elseif not items[materials[i][1]] then
          items[materials[i][1]] = materials[i][2]
        else
          items[materials[i][1]] = items[materials[i][1]] + materials[i][2]
        end
      end
    end
  end
  local curProcess = self.nowdata:GetQuenchPer() or 0
  curProcess = curProcess / 5
  if curProcess >= self.maxcount then
    redlog("升满了")
    self.staticCostCtl:ResetDatas(_EmptyTable)
    self.staticCost:SetActive(false)
    self.priceIndicator:SetActive(false)
    self.confirmBtn:SetActive(false)
    self.maxLabel:SetActive(true)
    return
  end
  local result = {}
  for itemid, num in pairs(items) do
    local itemData = ItemData.new("Cost", itemid)
    itemData.neednum = num
    local bagItems = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, GameConfig.PackageMaterialCheck.refine)
    local totalNum = 0
    for i = 1, #bagItems do
      totalNum = totalNum + bagItems[i].num
    end
    if itemid == 151 then
      totalNum = MyselfProxy.Instance:GetLottery()
    elseif itemid == 100 then
      totalNum = MyselfProxy.Instance:GetROB()
    end
    itemData.num = totalNum
    table.insert(result, itemData)
  end
  self.priceIndicator:SetActive(0 < zenyCost and true or false)
  if zenyCost > MyselfProxy.Instance:GetROB() then
    self.priceNumLabel.text = string.format("[c][fb725f]%s[-][/c]", StringUtil.NumThousandFormat(zenyCost))
  else
    self.priceNumLabel.text = StringUtil.NumThousandFormat(zenyCost)
  end
  self.zenyCost = zenyCost
  self.staticCostCtl:ResetDatas(result)
  self.costScrollView:ResetPosition()
end

function EquipQuenchView:UpdateQuenchPreview(quenchPreview)
  self:ShowCurItemTip(quenchPreview)
end

function EquipQuenchView:ClickStaticMatItem(cellCtl)
  self:ShowItemInfoTip(cellCtl)
end

function EquipQuenchView:ShowItemInfoTip(cell)
  if not self.ShowTip then
    if not self.tipdata then
      self.tipdata = {
        callback = function()
          self.ShowTip = false
        end
      }
    end
    self.tipdata.itemdata = cell.data
    self.tipdata.ignoreBounds = cell.gameObject
    self:ShowItemTip(self.tipdata, self.tipStick, NGUIUtil.AnchorSide.Left, itemTipOffset)
  else
    self:ShowItemTip()
  end
end

function EquipQuenchView:ShowCurItemTip(quenchPreview, resetPos)
  if not self.nowdata then
    return
  end
  local itemData = self.nowdata:Clone()
  local equipInfo = itemData.equipInfo
  if quenchPreview then
    if equipInfo then
      ItemUtil.SetManualQuenchValue(quenchPreview / 100)
      equipInfo.inQuenchPreview = true
    end
  else
    equipInfo.inQuenchPreview = true
  end
  if not self.infoTipCell then
    local obj = self:LoadPreferb("cell/ItemTipComCell", self.itemTipContainer)
    self.infoTipCell = ItemTipComCell.new(obj)
    self.infoTipCell:DisableAttrReposition()
    self.infoTipCell:SetData(itemData, nil, nil, nil, nil, false)
    self.infoTipCell:UpdateTipButtons(_EmptyTable)
    self.infoTipCell:UpdateBgHeight()
    self.infoTipCell:HideGetPath()
    self.infoTipCell:HidePreviewButton()
    self.infoTipCell:TrySetShowUpBtnActive(false)
    self.infoTipCell:TrySetShowTpBtnActive(false)
  else
    self.infoTipCell.gameObject:SetActive(true)
    self.infoTipCell.attriCtl:RemoveAll()
    self.infoTipCell:SetData(itemData, nil, nil, nil, nil, not resetPos)
    self.infoTipCell:HideGetPath()
    self.infoTipCell:HidePreviewButton()
    self.infoTipCell:TrySetShowUpBtnActive(false)
    self.infoTipCell:TrySetShowTpBtnActive(false)
  end
end

local packageCheck = {
  1,
  2,
  20
}
local previewItem = {42692}

function EquipQuenchView:GetValidEquips()
  local _BagProxy = BagProxy.Instance
  local result = {}
  for i = 1, #packageCheck do
    local items = _BagProxy:GetBagByType(packageCheck[i]):GetItems()
    for j = 1, #items do
      local equip = items[j]
      if equip and equip.equipInfo and equip.equipInfo:CanQuench_ByStaticData() then
        TableUtility.ArrayPushBack(result, equip)
      end
    end
  end
  table.sort(result, function(l, r)
    local l_isPreviewItem = TableUtility.ArrayFindIndex(previewItem, l.staticData.id)
    local r_isPreviewItem = TableUtility.ArrayFindIndex(previewItem, r.staticData.id)
    if l_isPreviewItem ~= r_isPreviewItem then
      return l_isPreviewItem > r_isPreviewItem
    end
    local l_QuenchPer = l:GetQuenchPer() or 0
    local r_QuenchPer = r:GetQuenchPer() or 0
    if l_QuenchPer ~= r_QuenchPer then
      return l_QuenchPer > r_QuenchPer
    end
  end)
  return result
end

function EquipQuenchView:RecvUpdateQuench()
  xdlog("更新淬炼结果")
  self:ChooseItem(self.nowdata)
end
