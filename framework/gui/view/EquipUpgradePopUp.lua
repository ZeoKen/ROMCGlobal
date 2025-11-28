autoImport("EquipUpgradeMaterialTipCell")
EquipUpgradePopUp = class("EquipUpgradePopUp", BaseView)
EquipUpgradePopUp.ViewType = UIViewType.PopUpLayer
EquipUpgradePopUp.TipCellPfb = "EquipUpgradeMaterialTipCell"
local _color = LuaColor.New()

function EquipUpgradePopUp:Init()
  self:InitView()
  self:MapEvent()
end

function EquipUpgradePopUp:InitView()
  local grid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(grid, EquipUpgradeMaterialTipCell, self.TipCellPfb)
  self.materialCtl:SetAddCellHandler(self.AddCellFunc, self)
  self.materialScrollView = self:FindComponent("ScrollView", UIScrollView)
  self.costZeny = self:FindComponent("CostZeny", UILabel)
  self.zenyCtrlSp = self:FindComponent("ZenyCtrl", UISprite)
  self.zenyCtrlLabel = self:FindComponent("ZenyCtrlLabel", UILabel)
  self.tipLab = self:FindComponent("TipLab", UILabel)
  self:InitCountCtrl()
  self:InitBtns()
  IconManager:SetItemIcon(Table_Item[100].Icon, self.zenyCtrlSp)
end

function EquipUpgradePopUp:InitCountCtrl()
  local countCtrl = self:FindGO("CountCtrl")
  self.countLabel = self:FindComponent("CountLabel", UILabel)
  self.countInput = countCtrl:GetComponent(UIInput)
  EventDelegate.Set(self.countInput.onChange, function()
    self:OnInputChange()
  end)
  local countSubtract = self:FindGO("CountSubtract", countCtrl)
  local countPlus = self:FindGO("CountPlus", countCtrl)
  self:AddClickEvent(countSubtract, function()
    self:OnClickCountSubtract()
  end)
  self:AddClickEvent(countPlus, function()
    self:OnClickCountPlus()
  end)
  self.countSubtractBg = countSubtract:GetComponent(UISprite)
  self.countSubtractSp = self:FindComponent("Subtract", UISprite, countSubtract)
  self.countPlusBg = countPlus:GetComponent(UISprite)
  self.countPlusSp = self:FindComponent("Plus", UISprite, countPlus)
end

function EquipUpgradePopUp:InitBtns()
  local confirmButton = self:FindGO("ConfirmButton")
  self.confirmLabel = self:FindComponent("Label", UILabel, confirmButton)
  self:AddClickEvent(confirmButton, function()
    FunctionSecurity.Me():LevelUpEquip(function()
      self:DoConfirm()
    end)
  end)
  self:AddButtonEvent("CancelButton", function()
    self:CloseSelf()
  end)
end

function EquipUpgradePopUp:AddCellFunc(cell)
  cell:SetUpgradeEquipId(self.equipItem and self.equipItem.id)
end

function EquipUpgradePopUp:DoConfirm()
  if #self.lackItems > 0 then
    QuickBuyProxy.Instance:SetEquipUpgradeExLevel(self.countInput.value)
    if QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage) then
      return
    end
  end
  if MyselfProxy.Instance:GetROB() < self:GetCurCostZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  local confirmHandler = function()
    self:_DoConfirm()
  end
  local needRecover, tipEquips = FunctionItemFunc.RecoverEquips(self.costEquips)
  if needRecover then
    return
  end
  if 0 < #tipEquips then
    MsgManager.ConfirmMsgByID(247, confirmHandler, nil, nil, tipEquips[1].equipInfo.refinelv)
    return
  end
  if self:GetCurLvOfEquipItem() >= self:GetUpgradeMaxLvOfEquipItem() then
    MsgManager.ConfirmMsgByID(25402, confirmHandler, nil, nil, Table_Item[self:GetProductIdOfEquipItem()].NameZh)
    return
  end
  confirmHandler()
end

function EquipUpgradePopUp:_DoConfirm()
  local count = self:GetCurCount()
  if count < 1 or count + self:GetCurLvOfEquipItem() > self:GetExpectedMaxLvOfEquipItem() then
    return
  end
  ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.equipItem.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP, nil, count)
  self:CloseSelf()
end

function EquipUpgradePopUp:UpdateMakeInfo()
  local equiplv = self:GetCurLvOfEquipItem()
  if not equiplv then
    return
  end
  local upgradeData = self.equipItem.equipInfo.upgradeData
  if not upgradeData then
    return
  end
  self.costEquips = self.costEquips or {}
  TableUtility.ArrayClear(self.costEquips)
  local _costs = ReusableTable.CreateArray()
  local count = self:GetCurCount()
  local costZeny, materialsKey, upgrade_checkBagTypes, cost, id, equips = 0
  local costEquipsNum = 0
  for i = 1, count do
    materialsKey = "Material_" .. equiplv + i
    cost = upgradeData[materialsKey]
    if cost then
      upgrade_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
      for i = 1, #cost do
        id = cost[i].id
        if id ~= 100 then
          if ItemData.CheckIsEquip(id) then
            equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, nil, upgrade_checkBagTypes)
            for j = 1, #equips do
              if costEquipsNum < cost[i].num then
                local newEquip
                if equips[j].id ~= self.equipItem.id then
                  newEquip = equips[j]:Clone()
                elseif 1 < equips[j].num then
                  newEquip = equips[j]:Clone()
                  newEquip.num = newEquip.num - 1
                end
                if newEquip then
                  costEquipsNum = newEquip.num + costEquipsNum
                  self:InsertOrAddNum(self.costEquips, newEquip)
                end
              end
            end
          end
          self:InsertOrAddNum(_costs, cost[i])
        else
          costZeny = costZeny + cost[i].num
        end
      end
    end
  end
  self.materialCtl:ResetDatas(_costs)
  if self.lastUpgradeCount and count < self.lastUpgradeCount then
    self.materialScrollView:ResetPosition()
  end
  self:UpdateCostZeny(costZeny)
  self:UpdateLackItems()
  self.lastUpgradeCount = count
  ReusableTable.DestroyAndClearArray(_costs)
end

function EquipUpgradePopUp:UpdateCostZeny(zeny)
  self.costZeny.text = zeny
  self.costZeny.color = zeny > MyselfProxy.Instance:GetROB() and ColorUtil.Red or ColorUtil.NGUIShaderGray
end

function EquipUpgradePopUp:UpdateLackItems()
  self.lackItems = self.lackItems or {}
  TableUtility.ArrayClear(self.lackItems)
  local cells, lackitemid, lacknum = self.materialCtl:GetCells()
  for i = 1, #cells do
    lackitemid, lacknum = cells[i]:GetLackMaterials()
    if lackitemid and lacknum then
      table.insert(self.lackItems, {id = lackitemid, count = lacknum})
    end
  end
  self.confirmLabel.text = #self.lackItems > 0 and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipUpgradePopUp_Upgrade
end

function EquipUpgradePopUp:GetCurLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.equiplv
end

function EquipUpgradePopUp:GetUpgradeMaxLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.upgrade_MaxLv
end

function EquipUpgradePopUp:GetExpectedMaxLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  local lv = 0
  while equipInfo:GetUpgradeMaterialsByEquipLv(lv + 1) ~= nil do
    lv = lv + 1
  end
  return lv
end

function EquipUpgradePopUp:GetProductIdOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  local upgradeData = equipInfo.upgradeData
  if not upgradeData then
    return
  end
  return upgradeData.Product
end

function EquipUpgradePopUp:GetEquipInfoOfEquipItem()
  if not self.equipItem then
    return
  end
  return self.equipItem.equipInfo
end

function EquipUpgradePopUp:IsAncientEquip()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if equipInfo and equipInfo.IsNextGen and equipInfo:IsNextGen() then
    return true
  end
  return false
end

function EquipUpgradePopUp:GetCurCount()
  return math.floor(tonumber(self.countInput.value) or 0)
end

function EquipUpgradePopUp:GetCurCostZeny()
  return tonumber(self.costZeny.text)
end

function EquipUpgradePopUp:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countSubtractBg, alpha)
    self:SetSpriteAlpha(self.countSubtractSp, alpha)
  end
end

function EquipUpgradePopUp:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countPlusBg, alpha)
    self:SetSpriteAlpha(self.countPlusSp, alpha)
  end
end

function EquipUpgradePopUp:SetSpriteAlpha(sprite, alpha)
  LuaColor.Better_Set(_color, sprite.color.r, sprite.color.g, sprite.color.b, alpha)
  sprite.color = _color
end

function EquipUpgradePopUp:InsertOrAddNum(array, item, idKey, numKey)
  if type(array) ~= "table" or type(item) ~= "table" then
    return
  end
  idKey = idKey or "id"
  numKey = numKey or "num"
  local element
  for i = 1, #array do
    element = array[i]
    if element[idKey] == item[idKey] then
      element[numKey] = element[numKey] + item[numKey]
      return
    end
  end
  local copy = {}
  copy.GetName = item.GetName
  TableUtility.TableShallowCopy(copy, item)
  TableUtility.ArrayPushBack(array, copy)
end

function EquipUpgradePopUp:MapEvent()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMakeInfo)
end

function EquipUpgradePopUp:OnZenyChange()
  self:UpdateCostZeny(self:GetCurCostZeny())
end

function EquipUpgradePopUp:OnEnter()
  EquipUpgradePopUp.super.OnEnter(self)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.zenyCtrlSp)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.equipItem = viewdata and viewdata.equipItem
  self.countInput.value = QuickBuyProxy.Instance.equipUpgradeExLevel or 1
  if self:IsAncientEquip() then
    self:Show(self.tipLab)
    self.tipLab.text = ZhString.AncientEquip_UpgradeTip
  else
    self:Hide(self.tipLab)
  end
  QuickBuyProxy.Instance:SetEquipUpgradeExLevel()
end

function EquipUpgradePopUp:OnExit()
  EquipUpgradePopUp.super.OnExit(self)
  QuickBuyProxy.Instance:SetEquipUpgradeExLevel(1)
end

function EquipUpgradePopUp:OnInputChange()
  local count = self:GetCurCount()
  if not count then
    return
  end
  local restLv = self:GetExpectedMaxLvOfEquipItem() - self:GetCurLvOfEquipItem()
  if count < 1 then
    self.countInput.value = 1
  elseif count > restLv then
    self.countInput.value = restLv
  end
  restLv = math.min(restLv, 999)
  count = self:GetCurCount()
  if not count then
    return
  end
  if restLv <= 1 then
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif restLv <= count then
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateMakeInfo()
end

function EquipUpgradePopUp:OnClickCountSubtract()
  self.countInput.value = self:GetCurCount() - 1
end

function EquipUpgradePopUp:OnClickCountPlus()
  if not self.equipItem then
    return
  end
  self.countInput.value = self:GetCurCount() + 1
end
