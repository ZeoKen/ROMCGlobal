GuildApprovePopUp = class("GuildApprovePopUp", SubView)
local approved_view_Path = ResourcePathHelper.UIView("GuildApprovePopUp")
autoImport("GuildHeadCell")

function GuildApprovePopUp:Init()
  self:LoadSubView()
  self.maxcount = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL_MAX)
  self:FindObjs()
  self:AddUIEvt()
  self:AddEvt()
end

function GuildApprovePopUp:FindObjs()
  local titleLab = self:FindComponent("Title", UILabel)
  titleLab.text = ZhString.GuildApproved_Title
  local acceptApplyObj = self:FindGO("AcceptApply")
  local acceptApplyLab = acceptApplyObj:GetComponent(UILabel)
  acceptApplyLab.text = ZhString.GuildApproved_AcceptApply
  self.acceptApplyToggle = self:FindComponent("AcceptApplyToggle", UIToggle, acceptApplyObj)
  local acceptMerApplyObj = self:FindGO("AcceptMercenaryApply")
  local acceptMerApplyLab = acceptMerApplyObj:GetComponent(UILabel)
  acceptMerApplyLab.text = ZhString.GuildApproved_AcceptMercenaryApply
  self.acceptMerApplyToggle = self:FindComponent("AcceptMercenaryApplyToggle", UIToggle, acceptMerApplyObj)
  local acceptApprovedObj = self:FindGO("AcceptApproved")
  local acceptApprovedLab = acceptApprovedObj:GetComponent(UILabel)
  acceptApprovedLab.text = ZhString.GuildApproved_AcceptApproved
  self.acceptApprovedToggle = self:FindComponent("AcceptApprovedToggle", UIToggle, acceptApprovedObj)
  local memberNumObj = self:FindGO("MemberNum")
  local memberNum = memberNumObj:GetComponent(UILabel)
  memberNum.text = ZhString.GuildApproved_MemberNum
  self.memberNumLab = self:FindComponent("MemberNumLab", UILabel, memberNumObj)
  local merNumObj = self:FindGO("MerNum")
  local merNum = merNumObj:GetComponent(UILabel)
  merNum.text = ZhString.GuildApproved_MercenaryNum
  self.merNumLab = self:FindComponent("MerNumLab", UILabel, merNumObj)
  self.limitedLv = self:FindComponent("LimitedLv", UILabel)
  local infoObj = self:FindGO("Info")
  self.guildName = self:FindComponent("GuildName", UILabel, infoObj)
  self.guildLv = self:FindComponent("GuildLv", UILabel, infoObj)
  self.guildLine = self:FindComponent("GuildLine", UILabel, infoObj)
  self.gender = self:FindComponent("Gender", UISprite, infoObj)
  local headCellObj = self:FindGO("GuildHeadContainer", infoObj)
  local itemGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GuildHeadCell"), headCellObj)
  self.headCell = GuildHeadCell.new(itemGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.headCell:DeleteGO("choose")
  self.limitedLvLab = self:FindComponent("LimitedLvBg", UIInput, self.limitedLv.gameObject)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.countInput = self:FindGO("LimitedLvBg"):GetComponent(UIInput)
  self.countInput.value = 1
end

function GuildApprovePopUp:AddUIEvt()
  self:AddButtonEvent("ConfirmButton", function(go)
    self:DoApply()
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  self:AddButtonEvent("CloseButto", function()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  end)
end

function GuildApprovePopUp:AddEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateGuildInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateGuildInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryCheckInfoGuildCmd, self.UpdateGuildInfo)
end

function GuildApprovePopUp:LoadSubView()
  local container = self:FindGO("ApproveView")
  local obj = self:LoadPreferb_ByFullPath(approved_view_Path, container, true)
  obj.name = "GuildApprovedView"
end

function GuildApprovePopUp:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function GuildApprovePopUp:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function GuildApprovePopUp:UpdateCount(change)
  if nil == tonumber(self.countInput.value) then
    self.countInput.value = 1
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function GuildApprovePopUp:InputOnChange()
  local count = tonumber(self.countInput.value)
  if not count then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function GuildApprovePopUp:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function GuildApprovePopUp:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function GuildApprovePopUp:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function GuildApprovePopUp:DoApply()
  local result = {}
  local guildProxy = GuildProxy.Instance
  local myGuildData = guildProxy.myGuildData
  local needlevel = self.countInput.value
  local applied = self.acceptApplyToggle.value and 1 or 2
  local mercenary = self.acceptMerApplyToggle.value and 1 or 2
  local checked = self.acceptApprovedToggle.value and 1 or 2
  ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(nil, nil, nil, nil, needlevel, applied, checked, mercenary)
end

function GuildApprovePopUp:UpdateOption()
  self.approvedInfo = GuildProxy.Instance.myGuildData.approvedInfo
  if not self.approvedInfo then
    return
  end
  self.acceptApplyToggle.value = self.approvedInfo.applied == 1
  self.acceptMerApplyToggle.value = self.approvedInfo.mercenary == 1
  self.acceptApprovedToggle.value = self.approvedInfo.checked == 1
  self.limitedLvLab.value = self.approvedInfo.needlevel
end

function GuildApprovePopUp:UpdateGuildInfo()
  local myGuildData = GuildProxy.Instance.myGuildData
  if not myGuildData then
    return
  end
  local headId = GuildProxy.Instance.myGuildData.portrait or 1
  local headData = GuildHeadData.new()
  headData:SetBy_InfoId(headId)
  headData:SetGuildId(myGuildData.id)
  self.headCell:SetData(headData)
  self.guildLine.text = ChangeZoneProxy.Instance:ZoneNumToString(myGuildData.zoneid)
  self.guildLv.text = string.format("Lv.%s", tostring(myGuildData.level))
  local chairMan = myGuildData:GetChairMan()
  self.gender.spriteName = chairMan:IsBoy() and "friend_icon_man" or "friend_icon_woman"
  self.memberNumLab.text = string.format("%s/%s", tostring(myGuildData.memberNum), tostring(myGuildData.maxMemberNum))
  self.merNumLab.text = string.format("%s/%s", tostring(myGuildData.mercenaryNum or 0), tostring(myGuildData.maxMercenaryNum or 0))
  self.guildName.text = myGuildData.name
  self:UpdateOption()
end

function GuildApprovePopUp:OnEnter()
  GuildApprovePopUp.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallQueryCheckInfoGuildCmd()
end

function GuildApprovePopUp:OnExit()
  GuildApprovePopUp.super.OnExit(self)
end
