GuildApplyListPopUp = class("GuildApplyListPopUp", SubView)
autoImport("GuildApplyCell")
local apply_view_Path = ResourcePathHelper.UIView("GuildApplyListPopUp")

function GuildApplyListPopUp:Init()
  self:LoadSubView()
  self:InitUI()
  self:MapListenEvt()
end

function GuildApplyListPopUp:LoadSubView()
  local container = self:FindGO("ApplyView")
  local obj = self:LoadPreferb_ByFullPath(apply_view_Path, container, true)
  obj.name = "GuildApplyListView"
end

function GuildApplyListPopUp:InitUI()
  self.funkey = {"ShowDetail", "ShowGUID"}
  self.tipData = {}
  self.ApplyTip = self:FindGO("ApplyTip")
  self.ApplyTip:SetActive(false)
  self:AddButtonEvent("CloseButton", function()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  end)
  local grid = self:FindComponent("grid", UIGrid)
  self.applyList = UIGridListCtrl.new(grid, GuildApplyCell, "GuildApplyCell")
  self.applyList:SetDisableDragIfFit()
  self.applyList:AddEventListener(GuildApplyCell.DoProgress, self.DoProgress, self)
  self.applyList:AddEventListener(GuildApplyCell.SelectHead, self.HandleSelectHead, self)
  self.applyList:AddEventListener(GuildApplyCell.ShowDetail, self.HandleShowDetail, self)
  local igNoreButton = self:FindGO("IgnoreButton")
  self:AddClickEvent(igNoreButton, function()
    local applyDatas = GuildProxy.Instance.myGuildData:GetApplyList()
    for i = 1, #applyDatas do
      local applyData = applyDatas[i]
      self:HandleMemberApply(applyData.id, false, applyData.job)
    end
  end)
  self:UpdateApplyList()
end

function GuildApplyListPopUp:DoProgress(parama)
  if parama then
    local ctl, opt = parama[1], parama[2]
    if ctl and ctl.data then
      self:HandleMemberApply(ctl.data.id, opt, ctl.data.job)
    end
  end
end

function GuildApplyListPopUp:HandleSelectHead(cellctl)
  local playerData = PlayerTipData.new()
  playerData:SetByGuildApplyData(cellctl.data)
  FunctionPlayerTip.Me():CloseTip()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellctl.headCell.headIconCell.clickObj, NGUIUtil.AnchorSide.Left, {-600, 100})
  TableUtility.TableClear(self.tipData)
  self.tipData.playerData = playerData
  self.tipData.funckeys = self.funkey
  playerTip:SetData(self.tipData)
end

function GuildApplyListPopUp:HandleShowDetail(cellctl)
  ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(cellctl.data.id, nil, ChatCmd_pb.EUSERINFOTYPE_CHAT)
end

function GuildApplyListPopUp:HandleMemberApply(id, agree, job)
  ServiceGuildCmdProxy.Instance:CallProcessApplyGuildCmd(agree, id, job)
end

function GuildApplyListPopUp:UpdateApplyList()
  local applyDatas = GuildProxy.Instance.myGuildData:GetApplyList()
  if 0 < #applyDatas then
    self.ApplyTip:SetActive(false)
  else
    self.ApplyTip:SetActive(true)
  end
  self.applyList:ResetDatas(applyDatas)
end

function GuildApplyListPopUp:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd, self.UpdateApplyList)
end

function GuildApplyListPopUp:OnEnter()
  GuildApplyListPopUp.super.OnEnter(self)
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_GUILD_APPLY)
  RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GUILD_APPLY)
end
