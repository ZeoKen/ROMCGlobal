SubViewMap = class("SubViewMap")
SubViewMap.Instance = nil
autoImport("ProfessionInfoPanel")
autoImport("SkyWheelInviteView")
autoImport("ChangeGuildZoneView")
autoImport("TransSexPreView")
autoImport("ServantSubView")
autoImport("ManorPartnerGiftPopUp")
autoImport("DialogPurchaseConfirmView")
autoImport("ChangeGvgLineView")

function SubViewMap:ctor()
  self.subMap = {}
  self.subMap[1] = SkyWheelInviteView
  self.subMap[2] = ProfessionInfoPanel
  self.subMap[3] = ChangeGuildZoneView
  self.subMap[4] = SkyWheelInviteView
  self.subMap[5] = SkyWheelInviteView
  self.subMap[6] = TransSexPreView
  self.subMap[7] = ServantSubView
  self.subMap[8] = ServantSubView
  self.subMap[9] = ManorPartnerGiftPopUp
  self.subMap[10] = SkyWheelInviteView
  self.subMap[11] = DialogPurchaseConfirmView
  self.subMap[12] = ChangeGvgLineView
  SubViewMap.Instance = self
end

function SubViewMap:GetSubView(id)
  return self.subMap[id]
end
