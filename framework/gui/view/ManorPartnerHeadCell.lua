local BaseCell = autoImport("BaseCell")
ManorPartnerHeadCell = class("ManorPartnerHeadCell", BaseCell)

function ManorPartnerHeadCell:Init()
  ManorPartnerHeadCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function ManorPartnerHeadCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.redtip = self:FindGO("RedTip")
end

function ManorPartnerHeadCell:SetData(data)
  self.data = data
  self.id = data.id
  if self.id then
    IconManager:SetNpcMonsterIconByID(self.id, self.icon)
  end
  if not data.isUnlock then
    self.icon.alpha = 0.4
  else
    self.icon.alpha = 1
  end
end

function ManorPartnerHeadCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end

function ManorPartnerHeadCell:RegisterRedtip()
  local ERedsys = SceneTip_pb.EREDSYS_MANOR_PARTNER_STORY
  local isNew = RedTipProxy.Instance:IsNew(ERedsys, self.id) or false
  self.redtip:SetActive(isNew)
end
