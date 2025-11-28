autoImport("BagItemNewCell")
autoImport("DyeMakeMaterialCell")
autoImport("EquipNewChooseBord")
DyeComposeView = class("DyeComposeView", ContainerView)
DyeComposeView.ViewType = UIViewType.NormalLayer
local _NumThousandFM = StringUtil.NumThousandFormat
local _MyselfProxy, _EquipMakeProxy
local _CType = SceneItem_pb.EPRODUCETYPE_COMMON
local _ZenyIcon = "item_100"
local _TickMgr
local _MaxCount = GameConfig.EquipMake and GameConfig.EquipMake.max_compose_count or 99999
local _TexBgName = "Dyesynthesis_bg_01"
local SetSpritAlpha = function(sp, alpha)
  sp.color = Color(sp.color.r, sp.color.g, sp.color.b, alpha)
end
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _InsertArray = TableUtility.ArrayPushBack
local _ClearArray = TableUtility.ArrayClear

function DyeComposeView:Init()
  _MyselfProxy = MyselfProxy.Instance
  _EquipMakeProxy = EquipMakeProxy.Instance
  _TickMgr = TimeTickManager.Me()
  self.composeTable = EquipMakeProxy.Instance:GetComposeTable()
  self.lackItems = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function DyeComposeView:FindObjs()
  self.silverLabel = self:FindGO("SilverLabel"):GetComponent(UILabel)
  self.costRoot = self:FindGO("CostRoot")
  self.silverCost = self:FindGO("CostLab"):GetComponent(UILabel)
  self.emptyTip = self:FindGO("EmptyRoot")
  self.makeBtn = self:FindGO("MakeBtn"):GetComponent(UISprite)
  self.makeBtnLab = self:FindGO("Lab", self.makeBtn.gameObject):GetComponent(UILabel)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.emptySite = self:FindGO("EmptySite")
  self.currentNameRoot = self:FindGO("CurrentNameRoot")
  self.curNameLab = self:FindComponent("CurNameLab", UILabel, self.currentNameRoot)
  self.matRoot = self:FindGO("MatRoot")
  self.operationRoot = self:FindGO("OperationRoot")
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.maskRoot = self:FindGO("MaskPanel")
  self.effContainer = self:FindGO("EffContainer")
  self:SetSpText()
end

function DyeComposeView:SetSpText()
  local makeFixedLab = self:FindGO("MakeFixedLab"):GetComponent(UILabel)
  makeFixedLab = ZhString.DyeComposeView_MakeCount
  local costFixedLab = self:FindGO("CostFixedLab"):GetComponent(UILabel)
  costFixedLab = ZhString.DyeComposeView_FixedCost
  local titleLab = self:FindGO("TitleLab"):GetComponent(UILabel)
  titleLab = ZhString.DyeComposeView_Title
  local emptyLab = self:FindGO("EmptyLab"):GetComponent(UILabel)
  emptyLab = ZhString.DyeComposeView_ReadyChoose
  self.makeBtnLab.text = ZhString.DyeComposeView_Btn
  local icon = self:FindComponent("Zeny", UISprite, self.costRoot)
  local symbol = self:FindComponent("symbol", UISprite, self:FindGO("Silver"))
  IconManager:SetItemIcon(Table_Item[100].Icon, icon)
  IconManager:SetItemIcon(Table_Item[100].Icon, symbol)
end

function DyeComposeView:AddEvts()
  self:AddClickEvent(self.makeBtn.gameObject, function()
    self:OnClickBtn()
  end)
  self:AddClickEvent(self.emptySite, function()
    self:UpdateMakeList()
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

function DyeComposeView:OnEnter()
  DyeComposeView.super.OnEnter(self)
  if self.npc then
    local viewPort = CameraConfig.HappyShop_ViewPort
    local rotation = CameraConfig.HappyShop_Rotation
    self:CameraFaceTo(self.npc.assetRole.completeTransform, viewPort, rotation)
  end
  PictureManager.Instance:SetUI(_TexBgName, self.bgTex)
  local uiMgr = UIManagerProxy.Instance
  if uiMgr:GetUIRootSize()[2] > 720 then
    self.maskRoot:SetActive(true)
  else
    self.maskRoot:SetActive(false)
  end
end

function DyeComposeView:OnExit()
  self:CameraReset()
  DyeComposeView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(_TexBgName, self.bgTex)
end

function DyeComposeView:OnClickBtn()
  if not self.curComposeData then
    return
  end
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.6
  local data = self.curComposeData.composeStaticData
  local robCost = data.ROB * tonumber(self.countInput.value) or 0
  if robCost > _MyselfProxy:GetROB() then
    MsgManager.ShowMsgByID(1)
    return
  elseif self.curComposeData:IsLock() then
    local menuSysId = self.curComposeData:GetMenuSysId()
    if menuSysId then
      MsgManager.ShowMsgByID(menuSysId)
    end
    return
  end
  if 0 < #self.lackItems then
    QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage)
    return
  end
  helplog("DyeComposeView call : ", self.curComposeId)
  ServiceItemProxy.Instance:CallProduce(_CType, self.curComposeId, self.npc.data.id, nil, tonumber(self.countInput.value))
end

function DyeComposeView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    _TickMgr:CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    _TickMgr:ClearTick(self, 1001)
  end
end

function DyeComposeView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    _TickMgr:CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    _TickMgr:ClearTick(self, 1002)
  end
end

function DyeComposeView:UpdateCount(change)
  local inputValue = tonumber(self.countInput.value)
  if nil == inputValue then
    self.countInput.value = 1
  end
  local count = inputValue + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  end
  if inputValue ~= count then
    self.countInput.value = count
  end
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  self:UpdateItem()
  self:UpdateCost()
end

function DyeComposeView:InputOnChange()
  local count = tonumber(self.countInput.value)
  if not count then
    self.countInput.value = 1
    return
  end
  if count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= _MaxCount then
    count = _MaxCount
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

function DyeComposeView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    SetSpritAlpha(self.countPlusBg, alpha)
  end
end

function DyeComposeView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    SetSpritAlpha(self.countSubtractBg, alpha)
  end
end

function DyeComposeView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateItem)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ItemProduceDone, self.OnSuccess)
end

function DyeComposeView:OnSuccess(note)
  local data = note.body
  if data.charid ~= Game.Myself.data.id then
    return
  end
  local num = self.curComposeData and self.curComposeData.itemData and self.curComposeData.itemData.num or 1
  _EquipMakeProxy:HandleProduceDone(data.type, data.itemid, data.delay, data.count, num)
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.effContainer, true)
end

function DyeComposeView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local matGrid = self:FindGO("MatGrid"):GetComponent(UIGrid)
  self.makeMatCtl = UIGridListCtrl.new(matGrid, DyeMakeMaterialCell, "DyeMakeMaterialCell")
  self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMakeMaterialItem, self)
  self.countInput.value = 1
  self.npc = self.viewdata.viewdata.npcdata
  _EquipMakeProxy:SetNpcId(self.npc.data.staticData.id)
  local targetCellGO = self:FindGO("TargetCellRoot")
  local itemobj = self:LoadPreferb("cell/BagItemNewCell", targetCellGO)
  self.targetCell = BagItemNewCell.new(itemobj)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.UpdateMakeList, self)
  self:Hide(self.targetCell)
  local chooseContainer = self:FindGO("ChooseContainer")
  local chooseBordDataFunc = function()
    return _EquipMakeProxy:GetMakeItemDatas()
  end
  self.maxInputCount = 1
  self.chooseBord = EquipNewChooseBord.new(chooseContainer, chooseBordDataFunc)
  self.chooseBord:SetBordTitle(ZhString.DyeComposeView_ChooseBoardTitle)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ClickMakeCell, self)
  self.chooseBord:Hide()
  self:UpdateCoins()
end

function DyeComposeView:ClickMakeCell(itemdata)
  local id = itemdata.composeId
  if id then
    self:Show(self.costRoot)
    self:Show(self.operationRoot)
    self:Show(self.matRoot)
    self:Hide(self.emptyTip)
    self:ResetCurCompose(id)
    self:UpdateTargetCell()
    self:UpdateItem()
    self:ResetInputCount()
    self:UpdateMakeBtnState()
    self.maxInputCount = self:CalcMaxProduceCount()
  end
end

function DyeComposeView:ResetCurCompose(id)
  if id then
    self.curComposeId = id
    self.curComposeData = _EquipMakeProxy:GetMakeData(id)
  else
    self.curComposeId = nil
    self.curComposeData = nil
  end
end

function DyeComposeView:ClickMakeMaterialItem(cellctl)
  self:ResetChooseBoardChooseItem()
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, cellctl.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
end

function DyeComposeView:ResetChooseBoardChooseItem()
  self.chooseBord.clickId = 0
  self.chooseBord:UpdateItemIconChoose()
end

local btnName = ZhString.DyeComposeView_Btn or ""

function DyeComposeView:UpdateMakeList()
  self.chooseBord:Show(true, nil, nil, nil, nil, nil, btnName)
  local data = _EquipMakeProxy:GetMakeItemDatas()
  local isEmpty = #data == 0
  if isEmpty then
    self:UpdateEmpty()
  end
end

function DyeComposeView:UpdateItem()
  self:UpdateMakeMaterial()
  self:UpdateMatEnough()
  self:UpdateMakeBtnState()
end

function DyeComposeView:UpdateMatEnough()
  _ClearArray(self.lackItems)
  local cells = self.makeMatCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if not cell:IsEnough() then
      _InsertArray(self.lackItems, cell:GetLackItems())
    end
  end
end

function DyeComposeView:UpdateMakeMaterial()
  local result = ReusableTable.CreateArray()
  local data = self.curComposeData and self.curComposeData.composeStaticData or nil
  if data then
    for i = 1, #data.BeCostItem do
      local tempItem = ItemData.new("DyeMakeMatItem", data.BeCostItem[i].id)
      tempItem:SetItemNum(data.BeCostItem[i].num * tonumber(self.countInput.value))
      result[#result + 1] = tempItem
    end
  end
  self.makeMatCtl:ResetDatas(result)
  ReusableTable.DestroyAndClearArray(result)
end

function DyeComposeView:CalcMaxProduceCount()
  if not self.curComposeData then
    return 1
  end
  local curComposeData = self.curComposeData
  local needROB = self.composeTable[self.curComposeId].ROB
  local nowRob = _MyselfProxy:GetROB()
  local costItem = curComposeData.composeStaticData.BeCostItem
  for i = 1, _MaxCount do
    if nowRob < needROB * i then
      return i
    end
    for j = 1, #costItem do
      local own = _EquipMakeProxy:GetItemNumByStaticID(costItem[j].id)
      if own < costItem[j].num * i then
        return i
      end
    end
  end
  return _MaxCount
end

function DyeComposeView:UpdateTargetCell()
  if self.curComposeData then
    self:Show(self.targetCell)
    self.targetCell:SetData(self.curComposeData.itemData)
    self.emptySite:SetActive(false)
    self.currentNameRoot:SetActive(true)
    self.curNameLab.text = self.curComposeData.itemData.staticData.NameZh
  else
    self.emptySite:SetActive(true)
    self:Hide(self.targetCell)
    self.currentNameRoot:SetActive(false)
  end
end

function DyeComposeView:UpdateCost()
  local data = self.composeTable[self.curComposeId]
  local cost = data and data.ROB * tonumber(self.countInput.value) or 0
  if cost <= _MyselfProxy:GetROB() then
    self.silverCost.text = cost
  else
    self.silverCost.text = string.format("[c][fb725f]%s[-][/c]", cost)
  end
  self:UpdateMakeBtnState()
end

function DyeComposeView:UpdateCoins()
  self.silverLabel.text = _NumThousandFM(_MyselfProxy:GetROB())
end

function DyeComposeView:ResetInputCount()
  self.countInput.value = 1
  self:UpdateCost()
end

function DyeComposeView:CanProduce()
  if self.curComposeId then
    local data = self.composeTable[self.curComposeId]
    local robCost = data.ROB * tonumber(self.countInput.value) or 0
    return nil ~= self.curComposeData and not self.curComposeData:IsLock() and 0 >= #self.lackItems and robCost <= _MyselfProxy:GetROB()
  else
    return false
  end
end

function DyeComposeView:UpdateMakeBtnState()
  if self:CanProduce() then
    self:_LightBtn(true)
    self.makeBtnLab.text = ZhString.DyeComposeView_Btn
  elseif #self.lackItems > 0 then
    self:_LightBtn(true)
    self.makeBtnLab.text = ZhString.EquipUpgradePopUp_QuickBuy
  else
    self:_LightBtn(false)
    self.makeBtnLab.text = ZhString.DyeComposeView_Btn
  end
end

function DyeComposeView:_LightBtn(var)
  if var then
    self.makeBtnLab.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
    self.makeBtnLab.color = ColorUtil.NGUIWhite
    self.makeBtn.spriteName = "new-com_btn_c"
  else
    self.makeBtnLab.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
    self.makeBtnLab.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
    self.makeBtn.spriteName = "new-com_btn_a_gray"
  end
end

function DyeComposeView:UpdateEmpty()
  self:ResetCurCompose(nil)
  self:UpdateTargetCell()
  self:UpdateItem()
  self:ResetInputCount()
end
