local baseCell = autoImport("BaseCell")
EquipRecoverCell = class("EquipRecoverCell", baseCell)

function EquipRecoverCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function EquipRecoverCell:FindObjs()
  self.desc = self.gameObject:GetComponent(UILabel)
  self.toggle = self:FindGO("Toggle"):GetComponent(UIToggle)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.costIcon = self:FindGO("Sprite", self.cost.gameObject):GetComponent(UISprite)
end

function EquipRecoverCell:AddEvts()
  EventDelegate.Add(self.toggle.onChange, function()
    self:PassEvent(EquipRecoverEvent.Select, self)
  end)
end

function EquipRecoverCell:SetData(data)
  self.data = data
  if data then
    local currency = EquipRecoverProxy.Instance:GetCurrency()
    local _EquipRecover = GameConfig.EquipRecover
    if data == EquipRecoverProxy.RecoverType.EmptyCard then
      self:HandleEmpty(ZhString.EquipRecover_EmptyCard)
      self.type = EquipRecoverProxy.RecoverType.EmptyCard
    elseif data == EquipRecoverProxy.RecoverType.Enchant then
      self:HandleCell(ZhString.EquipRecover_Enchant, _EquipRecover.Enchant, false)
      self.type = EquipRecoverProxy.RecoverType.Enchant
    elseif data == EquipRecoverProxy.RecoverType.EmptyEnchant then
      self:HandleEmpty(ZhString.EquipRecover_Enchant)
      self.type = EquipRecoverProxy.RecoverType.EmptyEnchant
    elseif data == EquipRecoverProxy.RecoverType.EmptyUpgrade then
      self:HandleEmpty(ZhString.EquipRecover_Upgrade)
      self.type = EquipRecoverProxy.RecoverType.EmptyUpgrade
    elseif data == EquipRecoverProxy.RecoverType.Quench then
      self:HandleCell(ZhString.EquipRecover_Quench, _EquipRecover.Quench, false)
      self.type = EquipRecoverProxy.RecoverType.Quench
    elseif data == EquipRecoverProxy.RecoverType.EmptyQuench then
      self:HandleEmpty(ZhString.EquipRecover_Quench)
      self.type = EquipRecoverProxy.RecoverType.EmptyQuench
    elseif data == EquipRecoverProxy.RecoverType.Refine then
      self:HandleCell(ZhString.EquipRecover_Refine, _EquipRecover.Refine, false)
      self.type = EquipRecoverProxy.RecoverType.Refine
    elseif data == EquipRecoverProxy.RecoverType.EquipMemory then
      self:HandleCell(ZhString.EquipRecover_EquipMemory, _EquipRecover.Memory, false)
      xdlog("EquipMemory还原")
      self.type = EquipRecoverProxy.RecoverType.EquipMemory
    elseif type(data) == "table" then
      local staticData = data.staticData
      if staticData then
        local card = _EquipRecover.Card
        if card then
          local chaika_cost = NewRechargeProxy.Ins:AmIMonthlyVIP() and 0 or card[staticData.Quality]
          self:HandleCell(string.format(ZhString.EquipRecover_Card, staticData.NameZh), chaika_cost, true)
          self.type = EquipRecoverProxy.RecoverType.Card
        end
      else
        self:HandleEmpty(ZhString.EquipRecover_EmptyCard)
        self.type = EquipRecoverProxy.RecoverType.EmptyCard
      end
    else
      local equiplv = math.clamp(data, 1, #_EquipRecover.Upgrade)
      self:HandleCell(ZhString.EquipRecover_Upgrade .. StringUtil.IntToRoman(data), _EquipRecover.Upgrade[equiplv], false)
      self.type = EquipRecoverProxy.RecoverType.Upgrade
    end
    if currency then
      local item = Table_Item[currency]
      if item then
        IconManager:SetItemIcon(item.Icon, self.costIcon)
      end
    end
  end
end

function EquipRecoverCell:HandleEmpty(desc)
  self.desc.text = desc
  self.cost.text = 0
  self.toggle:Set(false)
  self.toggle.enabled = false
end

function EquipRecoverCell:HandleCell(desc, cost, toggle)
  self.desc.text = desc
  self.cost.text = cost
  self.toggle.enabled = true
  self.toggle:Set(toggle)
end
