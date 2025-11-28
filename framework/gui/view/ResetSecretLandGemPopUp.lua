local _Exp_cost_id = 8280
local _ResetServerEnum = SceneItem_pb.ESECRETLANDGEMCMD_RESET
local _NumThousandFormat = StringUtil.NumThousandFormat
local _septer = ","
local _Table_Item = Table_Item
autoImport("PveDropItemCell")
ResetSecretLandGemPopUp = class("ResetSecretLandGemPopUp", ContainerView)
ResetSecretLandGemPopUp.ViewType = UIViewType.PopUpLayer

function ResetSecretLandGemPopUp:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:InitView()
end

function ResetSecretLandGemPopUp:FindObjs()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.Gem_SecretLand_Reset_Title
  self.contentLab = self:FindComponent("Content", UILabel)
  self.cancelBtn = self:FindGO("CancelBtn")
  self.cancelLab = self:FindComponent("Label", UILabel, self.cancelBtn)
  self.cancelLab.text = ZhString.UniqueConfirmView_CanCel
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmLab = self:FindComponent("Label", UILabel, self.confirmBtn)
  self.confirmLab.text = ZhString.UniqueConfirmView_Confirm
  self.matGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.matCtrl = UIGridListCtrl.new(self.matGrid, PveDropItemCell, "PveDropItemCell")
  self.matCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
end

local itemTipOffset = {210, -30}

function ResetSecretLandGemPopUp:OnClickMaterialCell(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, cellCtl.flagSp, nil, itemTipOffset)
  end
end

function ResetSecretLandGemPopUp:AddUIEvts()
  self:AddClickEvent(self.cancelBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:OnClickConfirm()
  end)
end

function ResetSecretLandGemPopUp:InitView()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.data = self.viewdata and self.viewdata.viewdata
  if not self.data then
    return
  end
  self:UpdateContent()
  self:UpdateMaterial()
end

function ResetSecretLandGemPopUp:UpdateContent()
  self.resetCostMaterialMap = {}
  local sb = LuaStringBuilder.CreateAsTable()
  local resetCostConfig = GameConfig.Gem.SecretlandGemResetCost
  if resetCostConfig then
    local _configLength = #resetCostConfig
    local num, id, name
    for i = 1, _configLength do
      num = resetCostConfig[i][2]
      id = resetCostConfig[i][1]
      name = _Table_Item[id].NameZh
      self.resetCostMaterialMap[id] = num
      sb:Append(_NumThousandFormat(num))
      sb:Append(name)
      if i ~= _configLength then
        sb:Append(_septer)
      end
    end
  end
  local cost_str = sb:ToString() or ""
  self.contentLab.text = string.format(ZhString.Gem_SecretLand_Reset_Content, self.data:GetName(), cost_str)
  sb:Destroy()
end

function ResetSecretLandGemPopUp:UpdateMaterial()
  local lv = self.data and self.data.lv
  local maxLv = self.data and self.data.maxLv
  local _Table_SecretLandGemLvUp = Table_SecretLandGemLvUp
  local costMap = {
    [_Exp_cost_id] = self.data.exp
  }
  local _id, _num
  for i = 2, maxLv do
    local config = _Table_SecretLandGemLvUp[i]
    if config then
      local BreakMaxLvCost = config.BreakMaxLvCost
      for j = 1, #BreakMaxLvCost do
        _id = BreakMaxLvCost[j][1]
        _num = BreakMaxLvCost[j][2]
        if not costMap[_id] then
          costMap[_id] = _num
        else
          costMap[_id] = costMap[_id] + _num
        end
      end
      if i <= lv then
        costMap[_Exp_cost_id] = costMap[_Exp_cost_id] + config.NeedExp
      end
    end
  end
  self.materials = {}
  if costMap and nil ~= next(costMap) then
    for id, num in pairs(costMap) do
      local item_data = ItemData.new("ResetSecretLandGem", id)
      item_data:SetItemNum(num)
      self.materials[#self.materials + 1] = item_data
    end
  end
  self.matCtrl:ResetDatas(self.materials)
end

function ResetSecretLandGemPopUp:OnClickConfirm()
  local guid = self.data and self.data.guid
  if not guid then
    return
  end
  local _BagProxy = BagProxy.Instance
  local lack_of = false
  for k, v in pairs(self.resetCostMaterialMap) do
    if v > _BagProxy:GetItemNumByStaticID(k) then
      lack_of = true
      break
    end
  end
  if lack_of then
    MsgManager.ShowMsgByID(8)
    return
  end
  ServiceItemProxy.Instance:CallSecretLandGemCmd(_ResetServerEnum, guid)
  self:CloseSelf()
end
