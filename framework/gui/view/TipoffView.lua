autoImport("TipoffReasonCell")
autoImport("PlayerFaceCell")
TipoffView = class("TipoffView", ContainerView)
TipoffView.ViewType = UIViewType.Lv4PopUpLayer
local _FunctionTipoff

function TipoffView:Init()
  _FunctionTipoff = FunctionTipoff.Me()
  TipoffView.super.Init(self)
  self:FindGOs()
  self:AddEvt()
  self.select_reason = {}
end

function TipoffView:FindGOs()
  self.titleLab = self:FindComponent("TitleLab", UILabel)
  self.titleLab.text = ZhString.Tip_off_Title
  self.contentLab = self:FindComponent("ContentLab", UILabel)
  self.contentLab.text = ZhString.Tip_off_Content
  self.blockBtn = self:FindGO("BlockBtn")
  self:AddClickEvent(self.blockBtn, function()
    self:DoBlock()
  end)
  self.tipoffBtn = self:FindComponent("TipoffBtn", UISprite)
  self.tipoffLab = self:FindComponent("Label", UILabel, self.tipoffBtn.gameObject)
  self:AddClickEvent(self.tipoffBtn.gameObject, function()
    self:DoTipoff()
  end)
  self.copyBtn = self:FindGO("CopyBtn")
  self:AddClickEvent(self.copyBtn, function()
    self:DoCopy()
  end)
  self.playerRoot = self:FindGO("PlayerRoot")
  self.headGO = self:FindGO("HeadIcon", self.playerRoot)
  self.faceCell = PlayerFaceCell.new(self.headGO)
  self.faceCell:HideHpMp()
  self.playerLvLab = self:FindComponent("LvLab", UILabel, self.playerRoot)
  self.playerIdLab = self:FindComponent("IDLab", UILabel, self.playerRoot)
  local reasonGrid = self:FindComponent("ReasonGrid", UIGrid)
  self.reasonCtrl = UIGridListCtrl.new(reasonGrid, TipoffReasonCell, "TipoffReasonCell")
  self.reasonCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickReason, self)
end

function TipoffView:AddEvt()
  self:AddListenEvt(ServiceEvent.UserEventQueryUserReportListUserEvent, self.UpdateView)
end

function TipoffView:OnClickReason(cell)
  local data = cell.data
  if data then
    local reason_id = data.id
    if self.select_reason[reason_id] then
      self.select_reason[reason_id] = nil
    else
      self.select_reason[reason_id] = reason_id
    end
  end
  self:UpdateTipoffBtn()
end

local _ButtonLabelRed = Color(0.49019607843137253, 0.027450980392156862, 0.01568627450980392, 1)

function TipoffView:UpdateTipoffBtn()
  local isEmpty = nil == next(self.select_reason)
  if isEmpty then
    self.tipoffBtn.spriteName = "com_btn_13"
    self.tipoffLab.effectColor = ColorUtil.NGUIGray
  else
    self.tipoffBtn.spriteName = "com_btn_0"
    self.tipoffLab.effectColor = _ButtonLabelRed
  end
end

function TipoffView:OnEnter()
  TipoffView.super.OnEnter(self)
  self.playerData = self.viewdata.viewdata and self.viewdata.viewdata.data
  if not self.playerData then
    return
  end
  local id = self.playerData.id
  _FunctionTipoff:SetCurPlayer(id)
  self.charId = id
  self.charName = self.playerData.name
  self.charLv = self.playerData.level
  self.str = self.playerData.str
  self:UpdateView()
end

local _format = "Lv.%d %s"

function TipoffView:UpdateView()
  if not self.playerData then
    return
  end
  self.faceCell:SetData(self.playerData.headData)
  self.playerLvLab.text = string.format(_format, self.charLv, self.charName)
  self.playerIdLab.text = tostring(self.charId)
  local reasons = _FunctionTipoff:GetReason()
  self.reasonCtrl:ResetDatas(reasons)
  local reasonMap = _FunctionTipoff:GetPlayerReasons()
  if reasonMap then
    for reason_id, _ in pairs(reasonMap) do
      self.select_reason[reason_id] = reason_id
    end
  end
  self:UpdateTipoffBtn()
end

function TipoffView:DoBlock()
  FriendProxy.Instance:Do_Block(self.charId, self.charName)
end

function TipoffView:DoCopy()
  if not self.charId then
    return
  end
  local _ = ApplicationInfo.CopyToSystemClipboard(self.charId)
  if _ then
    MsgManager.ShowMsgByID(40200)
  end
end

function TipoffView:DoTipoff()
  if nil == next(self.select_reason) then
    return
  end
  _FunctionTipoff:DoTipoff(self.charId, self.select_reason, self.charName, self.str)
end

function TipoffView:OnExit()
  _FunctionTipoff:SetCurPlayer(nil)
  self.faceCell:RemoveIconEvent()
  TipoffView.super.OnExit(self)
end
