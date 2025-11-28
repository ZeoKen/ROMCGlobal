local BaseCell = autoImport("BaseCell")
TeamPwsCustomRoomInfoCell = class("TeamPwsCustomRoomInfoCell", BaseCell)

function TeamPwsCustomRoomInfoCell:Init()
  self.modeLabel = self:FindComponent("ModeName", UILabel)
  self.teamIconGO = self:FindGO("TeamIcon")
  self.portraitCell = PlayerFaceCell.new(self.teamIconGO)
  self.portraitCell:SetMinDepth(4)
  self.portraitCell.headIconCell:SetScale(0.76)
  self.roomNameLabel = self:FindComponent("RoomName", UILabel)
  self.pwdIconGO = self:FindGO("PwdIcon")
  self.freeFireGO = self:FindGO("FreeFireIcon")
  self.team1CountLabel = self:FindComponent("Team1Count", UILabel)
  self.team2CountLabel = self:FindComponent("Team2Count", UILabel)
  self.team3CountLabel = self:FindComponent("Team3Count", UILabel)
  self.ob = self:FindGO("Team3")
  self.joinBtnGO = self:FindGO("JoinButton")
  self.joinBtnMultiSprite = self.joinBtnGO:GetComponent(UIMultiSprite)
  self.joinBtnLabel = self:FindComponent("Label", UILabel, self.joinBtnGO)
  self:AddClickEvent(self.joinBtnGO, function()
    self:OnJoinClicked()
  end)
  self.serverLab = self:FindComponent("ServerLab", UILabel)
  self.titleTable = self:FindComponent("TitleTable", UITable)
end

local labelRedEffect = Color(0.7529411764705882, 0.09411764705882353, 0.03137254901960784, 1)

function TeamPwsCustomRoomInfoCell:SetData(data)
  self.data = data
  if data then
    local proxy = PvpCustomRoomProxy.Instance
    local raidConfig = proxy:GetRaidConfigByRaidId(data.raidid, data.pvptype)
    self.modeLabel.text = raidConfig and raidConfig.name or ""
    self.roomNameLabel.text = data:GetRoomName() or ""
    self.portraitCell:SetData(data.portrait)
    self.pwdIconGO:SetActive(data:NeedPasswd())
    self.freeFireGO:SetActive(data:IsFreeFire())
    local maxTeamCount = data:GetMaxTeamCout()
    self.team1CountLabel.text = string.format("%d/%d", data.teamonenum or 0, maxTeamCount)
    self.team2CountLabel.text = string.format("%d/%d", data.teamtwonum or 0, maxTeamCount)
    local obCnt = data:GetMaxObCount()
    if 0 < obCnt then
      self:Show(self.ob)
      self.team3CountLabel.text = string.format("%d/%d", data.teamobnum or 0, obCnt)
    else
      self:Hide(self.ob)
    end
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
    self.titleTable:Reposition()
  end
end

function TeamPwsCustomRoomInfoCell:OnJoinClicked()
  if not self.data or self.data:IsFull() then
    MsgManager.ShowMsgByID(472)
    return
  end
  self:PassEvent(UICellEvent.OnRightBtnClicked, self)
end
