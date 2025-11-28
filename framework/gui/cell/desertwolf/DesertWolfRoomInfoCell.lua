local BaseCell = autoImport("BaseCell")
DesertWolfRoomInfoCell = class("DesertWolfRoomInfoCell", BaseCell)

function DesertWolfRoomInfoCell:Init()
  self.teamIconGO = self:FindGO("TeamIcon")
  self.portraitCell = PlayerFaceCell.new(self.teamIconGO)
  self.portraitCell:SetMinDepth(4)
  self.portraitCell.headIconCell:SetScale(0.55)
  self.titleTable = self:FindComponent("TitleTable", UITable)
  self.roomNameLabel = self:FindComponent("RoomName", UILabel)
  self.pwdIconGO = self:FindGO("Lock")
  self.freeFireGO = self:FindGO("FreeFireIcon")
  self.serverLab = self:FindComponent("ServerLab", UILabel)
  self.team1CountLabel = self:FindComponent("Team1Count", UILabel)
  self.team2CountLabel = self:FindComponent("Team2Count", UILabel)
  self.team3CountLabel = self:FindComponent("Team3Count", UILabel)
  self.joinBtnGO = self:FindGO("JoinButton")
  self.joinBtnMultiSprite = self.joinBtnGO:GetComponent(UIMultiSprite)
  self.joinBtnLabel = self:FindComponent("Label", UILabel, self.joinBtnGO)
  self:AddClickEvent(self.joinBtnGO, function()
    self:OnJoinClicked()
  end)
end

local labelRedEffect = Color(0.7529411764705882, 0.09411764705882353, 0.03137254901960784, 1)

function DesertWolfRoomInfoCell:SetData(data)
  self.data = data
  if data then
    self.roomNameLabel.text = data:GetRoomName() or ""
    self.portraitCell:SetData(data.portrait)
    self.pwdIconGO:SetActive(data:NeedPasswd())
    self.freeFireGO:SetActive(data:IsFreeFire())
    self.titleTable:Reposition()
    local maxTeamCount = data:GetMaxTeamCout()
    self.team1CountLabel.text = string.format("%d/%d", data.teamonenum or 0, maxTeamCount)
    self.team2CountLabel.text = string.format("%d/%d", data.teamtwonum or 0, maxTeamCount)
    self.team3CountLabel.text = string.format("%d/%d", data.teamobnum or 0, data:GetMaxObCount())
    if data:IsFull() then
      self.joinBtnMultiSprite.CurrentState = 0
      self.joinBtnLabel.text = ZhString.PvpCustomRoom_Full
      self.joinBtnLabel.effectColor = labelRedEffect
    else
      self.joinBtnMultiSprite.CurrentState = 1
      self.joinBtnLabel.text = ZhString.PvpCustomRoom_Join
      self.joinBtnLabel.effectColor = ColorUtil.ButtonLabelOrange
    end
    self.serverLab.text = data.server or ""
  end
end

function DesertWolfRoomInfoCell:OnJoinClicked()
  if not self.data or self.data:IsFull() then
    MsgManager.ShowMsgByID(472)
    return
  end
  self:PassEvent(UICellEvent.OnRightBtnClicked, self)
end
