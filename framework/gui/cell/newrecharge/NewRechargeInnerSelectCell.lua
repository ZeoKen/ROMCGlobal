local BaseCell = autoImport("BaseCell")
NewRechargeInnerSelectCell = class("NewRechargeInnerSelectCell", BaseCell)

function NewRechargeInnerSelectCell:Init()
  self:FindObj()
  self:AddUIEvents()
end

function NewRechargeInnerSelectCell:FindObj()
  self.selectGo = self:FindGO("select")
  self.icon = self:FindComponent("icon", UISprite)
  self.name_s = self:FindComponent("name_select", UILabel)
  self.name_us = self:FindComponent("name_unselect", UILabel)
end

function NewRechargeInnerSelectCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NewRechargeInnerSelectCell:SetData(data)
  self.data = data
  self.name_s.text = data.Name
  self.name_us.text = data.Name
  self:SetSelect(false)
  if self.data.Invalid then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
  end
end

function NewRechargeInnerSelectCell:SetSelect(isTrue)
  self.selectGo:SetActive(isTrue)
  self.name_s.gameObject:SetActive(isTrue)
  self.name_us.gameObject:SetActive(not isTrue)
end
