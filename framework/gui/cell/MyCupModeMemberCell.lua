autoImport("MyWarbandMemberCell")
MyCupModeMemberCell = class("MyCupModeMemberCell", MyWarbandMemberCell)

function MyCupModeMemberCell:Init()
  MyCupModeMemberCell.super.Init(self)
  self.proxy = CupMode6v6Proxy.Instance
end
