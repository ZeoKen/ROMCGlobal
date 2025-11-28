autoImport("MakeMaterialCell")
autoImport("EquipMakeCell")
EquipMakeView = class("EquipMakeView", ContainerView)
EquipMakeView.ViewType = UIViewType.NormalLayer

function EquipMakeView:OnEnter()
  EquipMakeView.super.OnEnter(self)
  if self.npc then
    local viewPort = CameraConfig.HappyShop_ViewPort
    local rotation = CameraConfig.HappyShop_Rotation
    self:CameraFaceTo(self.npc.assetRole.completeTransform, viewPort, rotation)
  end
end

function EquipMakeView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipMakeView:OnExit()
  self:CameraReset()
  self:SetChooseMakeData(false)
  EquipMakeView.super.OnExit(self)
  self.selfProfession = nil
end

function EquipMakeView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function EquipMakeView:FindObjs()
  self.silverLabel = self:FindGO("SilverLabel"):GetComponent(UILabel)
  self.selfProfession = self:FindGO("SelfProfession"):GetComponent(UIToggle)
  self.makeTitle = self:FindGO("MakeTitle"):GetComponent(UILabel)
  self.costInfo = self:FindGO("CostInfo")
  self.silverCost = self:FindGO("ZenyCost"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  self.emptyTip = self:FindGO("EmptyTip")
  self.makeBtn = self:FindGO("MakeBtn"):GetComponent(UISprite)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countInput.value = 1
  self.liziParent = self:FindGO("lizi")
  self:PlayUIEffect(EffectMap.UI.EquipMakeView, self.liziParent)
end

function EquipMakeView:AddEvts()
  self:AddClickEvent(self.makeBtn.gameObject, function()
    if self.curComposeId == nil then
      return
    end
    if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
      return
    end
    self.validStamp = ServerTime.CurServerTime() / 1000 + 0.2
    local enoughMaterial = self.total - self.need
    local data = Table_Compose[self.curComposeId]
    local robCost = data.ROB * tonumber(self.countInput.value) or 0
    local enoughROB = MyselfProxy.Instance:GetROB() - robCost
    local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
    if enoughMaterial < 0 then
      local needList = ReusableTable.CreateArray()
      local cells = self.makeMatCtl:GetCells()
      for i = 1, #cells do
        local needCount = cells[i]:NeedCount()
        if 0 < needCount then
          local needData = ReusableTable.CreateTable()
          needData.id = cells[i].data.id
          needData.count = needCount
          TableUtility.ArrayPushBack(needList, needData)
        end
      end
      if not QuickBuyProxy.Instance:TryOpenView(needList) then
        MsgManager.ShowMsgByID(8)
      end
      for i = 1, #needList do
        ReusableTable.DestroyAndClearTable(needList[i])
      end
      ReusableTable.DestroyArray(needList)
      return
    elseif enoughROB < 0 then
      MsgManager.ShowMsgByID(1)
      return
    elseif makeData:IsLock() then
      local composeData = Table_Compose[self.curComposeId]
      if composeData and composeData.MenuID then
        local menuData = Table_Menu[composeData.MenuID]
        if menuData and menuData.sysMsg and menuData.sysMsg.id then
          MsgManager.ShowMsgByID(menuData.sysMsg.id)
        end
      end
      return
    end
    ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_EQUIP, self.curComposeId, self.npc.data.id, nil, tonumber(self.countInput.value))
  end)
  EventDelegate.Add(self.selfProfession.onChange, function()
    if self.isSelfProfession ~= self.selfProfession.value then
      self.isSelfProfession = self.selfProfession.value
      self:UpdateMakeList()
      self.itemWrapHelper:ResetPosition()
      self:SelectFirstMakeCell()
    end
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
end

function EquipMakeView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function EquipMakeView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function EquipMakeView:UpdateCount(change)
  if nil == tonumber(self.countInput.value) then
    self.countInput.value = 1
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  if tonumber(self.countInput.value) ~= count then
    self.countInput.value = count
  end
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  self:UpdateItem()
  self:UpdateCost()
end

function EquipMakeView:InputOnChange()
  local count = tonumber(self.countInput.value)
  if not count then
    self.countInput.value = 1
    return
  end
  if count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  self:UpdateItem()
  self:UpdateCost()
end

function EquipMakeView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function EquipMakeView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function EquipMakeView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function EquipMakeView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateItem)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
end

function EquipMakeView:InitShow()
  self.isSelfProfession = true
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.maxcount = 99
  self.npc = self.viewdata.viewdata.npcdata
  EquipMakeProxy.Instance:SetNpcId(self.npc.data.staticData.id)
  local targetCellGO = self:FindGO("TargetCell")
  self.targetCell = BaseItemCell.new(targetCellGO)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local makeInfo = self:FindGO("MakeInfo")
  self.materialScrollView = self:FindGO("ScrollView", makeInfo):GetComponent(UIScrollView)
  local makeMaterialGrid = self:FindGO("MakeMaterialGrid"):GetComponent(UIGrid)
  self.makeMatCtl = UIGridListCtrl.new(makeMaterialGrid, MakeMaterialCell, "MakeMaterialCell")
  self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMakeMaterialItem, self)
  local makeListContainer = self:FindGO("MakeListContainer")
  local wrapConfig = {
    wrapObj = makeListContainer,
    pfbNum = 6,
    cellName = "EquipMakeCell",
    control = EquipMakeCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickMakeCell, self)
  self.countInput.value = 1
  local isEmpty = self:UpdateMakeList()
  if isEmpty then
    self.selfProfession.value = false
  end
  self:UpdateCoins()
  self:SelectFirstMakeCell()
  local icon = self:FindComponent("moneySprite", UISprite, self.costInfo)
  local symbol = self:FindComponent("symbol", UISprite, self:FindGO("Silver"))
  IconManager:SetItemIcon(Table_Item[100].Icon, icon)
  IconManager:SetItemIcon(Table_Item[100].Icon, symbol)
end

function EquipMakeView:SelectFirstMakeCell()
  local itemCells = self.itemWrapHelper:GetCellCtls()
  if 0 < #itemCells then
    self:ClickMakeCell(itemCells[1])
  end
end

function EquipMakeView:ClickMakeCell(cellctl)
  local data = cellctl.data
  if data then
    if self.curComposeId and self.curComposeId ~= data then
      self:SetChooseMakeData(false)
      self:SetChooseCell(false)
    end
    self.curComposeId = data
    self:SetChooseMakeData(true)
    cellctl:SetChoose(true)
    self:UpdateTargetCell()
    self:UpdateItem()
    local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
    if makeData and makeData:IsLock() then
      self.tip.gameObject:SetActive(true)
      self.costInfo:SetActive(false)
      self:UpdateTip()
    else
      self.tip.gameObject:SetActive(false)
      self.costInfo:SetActive(true)
      self:UpdateCost()
    end
  end
end

function EquipMakeView:ClickTargetCell(cellctl)
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, cellctl.icon, NGUIUtil.AnchorSide.Left, {-170, 0})
end

function EquipMakeView:ClickMakeMaterialItem(cellctl)
  self.tipData.itemdata = cellctl.itemData
  self:ShowItemTip(self.tipData, cellctl.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
end

function EquipMakeView:UpdateMakeList()
  local data = EquipMakeProxy.Instance:GetMakeList()
  if self.isSelfProfession then
    data = EquipMakeProxy.Instance:GetSelfProfessionMakeList()
  end
  self.itemWrapHelper:UpdateInfo(data)
  local isEmpty = #data == 0
  if isEmpty then
    self:UpdateEmpty()
  end
  self.emptyTip:SetActive(isEmpty)
  return isEmpty
end

function EquipMakeView:UpdateMakeMaterial()
  local result = {}
  local data = Table_Compose[self.curComposeId]
  if data then
    for i = 1, #data.BeCostItem do
      result[#result + 1] = {
        id = data.BeCostItem[i].id,
        num = data.BeCostItem[i].num * tonumber(self.countInput.value)
      }
    end
  end
  self.makeMatCtl:ResetDatas(result)
  self.materialScrollView:ResetPosition()
end

function EquipMakeView:UpdateTargetCell()
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if makeData then
    self.targetCell:SetData(makeData.itemData)
  else
    self.targetCell.nameLab.text = ""
    self.targetCell.normalItem:SetActive(false)
  end
end

function EquipMakeView:UpdateMakeTitle()
  local cells = self.makeMatCtl:GetCells()
  self.need = #cells
  self.total = 0
  for i = 1, self.need do
    local cell = cells[i]
    if cell:IsEnough() then
      self.total = self.total + 1
    end
  end
  self.makeTitle.text = string.format(ZhString.EquipMake_Title, self.total, self.need)
end

function EquipMakeView:UpdateCost()
  local data = Table_Compose[self.curComposeId]
  local cost = data and data.ROB * tonumber(self.countInput.value) or 0
  local rob = MyselfProxy.Instance:GetROB()
  self.silverCost.text = cost
  if cost > rob then
    ColorUtil.RedLabel(self.silverCost)
  else
    ColorUtil.BlackLabel(self.silverCost)
  end
end

function EquipMakeView:UpdateTip()
  local data = Table_Compose[self.curComposeId]
  self.tip.text = data and data.MenuDes or ""
end

function EquipMakeView:UpdateCoins()
  local rob = MyselfProxy.Instance:GetROB()
  self.silverLabel.text = StringUtil.NumThousandFormat(rob)
end

function EquipMakeView:MyDataChange()
  self:UpdateCoins()
end

function EquipMakeView:UpdateItem()
  self:UpdateMakeMaterial()
  self:UpdateMakeTitle()
end

function EquipMakeView:SetChooseMakeData(isChoose)
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if makeData then
    makeData:SetChoose(isChoose)
  end
end

function EquipMakeView:SetChooseCell(isChoose)
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    if cells[i].data == self.curComposeId then
      cells[i]:SetChoose(isChoose)
      break
    end
  end
end

function EquipMakeView:UpdateEmpty()
  if self.curComposeId then
    self:SetChooseMakeData(false)
    self:SetChooseCell(false)
  end
  self.curComposeId = nil
  self.countInput.value = 1
  self:UpdateTargetCell()
  self:UpdateItem()
  self.tip.gameObject:SetActive(false)
  self.costInfo:SetActive(true)
  self:UpdateCost()
end
