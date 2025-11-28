local _IndexPos = {
  [1] = {-130, -140},
  [2] = {116, -140},
  [3] = {396, -140}
}
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
autoImport("YmirTipView")
YmirTipView_TriplePvp = class("YmirTipView_TriplePvp", YmirTipView)
YmirTipView_TriplePvp.ViewType = UIViewType.PopUpLayer

function YmirTipView_TriplePvp:Init()
  YmirTipView_TriplePvp.super.Init(self)
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.panel.alpha = 0
  LeanTweenUtil.UIAlpha(self.panel, 0, 1, 2, 2)
  if self.bookGO then
    self.bookGO:SetActive(false)
  end
  if self.quickSaveBtn then
    self.quickSaveBtn:SetActive(false)
  end
  self.confirmProBtn = self:FindGO("ConfirmProBtn")
  if self.confirmProBtn then
    self:AddClickEvent(self.confirmProBtn, function()
      if not TriplePlayerPvpProxy.Instance:CheckNeedConfirmChangePro() then
        return
      end
      local myPro = MyselfProxy.Instance:GetMyProfession()
      if TriplePlayerPvpProxy.Instance:CheckMyTeamRepetitiveProfession(myPro) then
        MsgManager.ShowMsgByID(28123)
        return
      end
      MsgManager.ConfirmMsgByID(26291, function()
        ServiceFuBenCmdProxy.Instance:CallChooseCurProfessionFuBenCmd()
      end)
    end)
  end
end

function YmirTipView_TriplePvp:OnCellClicked(cell)
  if not TriplePlayerPvpProxy.Instance:CheckNeedConfirmChangePro() then
    return
  end
  local pro = cell.data.profession
  if pro and TriplePlayerPvpProxy.Instance:CheckMyTeamRepetitiveProfession(pro) then
    MsgManager.ShowMsgByID(28123)
    return
  end
  MsgManager.ConfirmMsgByID(26291, function()
    YmirTipView_TriplePvp.super.OnCellClicked(self, cell)
  end)
end

function YmirTipView_TriplePvp:OnBookClicked()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MultiProfessionNewView,
    viewdata = {tab = 1}
  })
  self:CloseSelf()
end

function YmirTipView_TriplePvp:UpdateTipPosition()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if not viewdata then
    return
  end
  local index = viewdata.index
  local pos_config = _IndexPos[index]
  _SetLocalPositionGO(self.mainPanel, pos_config[1], pos_config[2], 0)
end
