local BaseCell = autoImport("BaseCell")
MatchInfoCell = class("MatchInfoCell", BaseCell)
MatchInfoCell_Event = {
  Cancel = "MatchInfoCell_Event_Cancel"
}
MatchInfo_Type = {PoringFight = 1, TransferFight = 2}

function MatchInfoCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.cancel = self:FindGO("CancelButton")
  self:AddClickEvent(self.cancel, function()
    self:PassEvent(MatchInfoCell_Event.Cancel, self)
  end)
end

function MatchInfoCell:SetData(active, mtype)
  if active then
    self.gameObject:SetActive(true)
    if mtype == MatchInfo_Type.PoringFight or mtype == MatchInfo_Type.TransferFight then
      self.label.text = ZhString.MatchInfoCell_PoringInfo
    end
  else
    self.gameObject:SetActive(false)
  end
end
