local Event_name = {
  [EGuildDateBattleTip.SecendStamp] = GuildDateBattleEvent.ChooseDate,
  [EGuildDateBattleTip.Clock] = GuildDateBattleEvent.ChooseClock,
  [EGuildDateBattleTip.Mode] = GuildDateBattleEvent.ChooseMode
}
autoImport("BaseTip")
autoImport("GuildDateBattleTipCell")
GuildDateBattleDateTip = class("GuildDateBattleDateTip", BaseTip)

function GuildDateBattleDateTip:Init()
  self:FindObj()
end

function GuildDateBattleDateTip:FindObj()
  local grid = self:FindComponent("Grid", UIGrid)
  self.ctrl = UIGridListCtrl.new(grid, GuildDateBattleTipCell, "GuildDateBattleTipCell")
  self.ctrl:AddEventListener(MouseEvent.MouseClick, self.OnClickDate, self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  GuildDateBattleDateTip.super.Init(self)
end

function GuildDateBattleDateTip:OnClickDate(cellctl)
  local cell_data = cellctl.data
  if not cell_data then
    return
  end
  if cellctl.inValid then
    MsgManager.ShowMsgByID(43548)
    return
  end
  if cell_data[1] then
    local event_name = Event_name[cell_data[1]]
    if event_name then
      GameFacade.Instance:sendNotification(event_name, cell_data[2])
    end
  end
  self:CloseSelf()
end

function GuildDateBattleDateTip:SetData(tip_data)
  if not tip_data then
    return
  end
  self.data = tip_data.data
  self.callback = tip_data.callback
  self.callbackParam = tip_data.callbackParam
  self.ctrl:ResetDatas(self.data)
end

function GuildDateBattleDateTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GuildDateBattleDateTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function GuildDateBattleDateTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
