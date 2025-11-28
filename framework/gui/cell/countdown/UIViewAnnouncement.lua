UIViewAnnouncement = class("UIViewAnnouncement", MaintenanceMsg)

function UIViewAnnouncement:ctor(go)
  self.gameObject = go
  self:Init()
end
