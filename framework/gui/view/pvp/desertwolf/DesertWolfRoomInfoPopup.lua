autoImport("TeamPwsCustomRoomInfoPopup")
DesertWolfRoomInfoPopup = class("DesertWolfRoomInfoPopup", TeamPwsCustomRoomInfoPopup)
DesertWolfRoomInfoPopup.ViewType = UIViewType.PopUpLayer

function DesertWolfRoomInfoPopup:OnSettingClicked()
  if not self:CheckSettingClickValid() then
    return
  end
  local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  local mode = not roomData:IsHost(Game.Myself.data.id) and PvpCustomRoomProxy.CreateRoomMode.InRoomPreview
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DesertWolfCreateRoomPopup,
    viewdata = {roomdata = roomData, mode = mode}
  })
end
