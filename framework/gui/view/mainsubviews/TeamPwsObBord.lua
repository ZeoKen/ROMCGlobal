autoImport("TeamPwsBord")
TeamPwsObBord = class("TeamPwsObBord", TeamPwsBord)

function TeamPwsObBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/TeamPwsObBord", parent, true)
  self:InitView()
end

function TeamPwsObBord:InitView()
  TeamPwsObBord.super.InitView(self)
  self.killNumHomeLabel = self:FindComponent("KillNum_Red", UILabel)
  self.killNumAwayLabel = self:FindComponent("KillNum_Blue", UILabel)
end

function TeamPwsObBord:UpdateInfo()
  TeamPwsObBord.super.UpdateInfo(self)
  local proxy = PvpObserveProxy.Instance
  self.killNumHomeLabel.text = proxy:GetKillNum(1)
  self.killNumAwayLabel.text = proxy:GetKillNum(2)
end

function TeamPwsObBord:Hide()
  TeamPwsObBord.super.Hide(self)
  self:RemoveTimeTick_Raid()
end

function TeamPwsObBord:OnBuffRedClicked()
  if self.red_BuffID == nil then
    return
  end
  local desc = Table_Buffer[self.red_BuffID].BuffDesc
  local normalTip = TipManager.Instance:ShowNormalTip(desc, self.stick, NGUIUtil.AnchorSide.Left, {10, 0})
  normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
end

function TeamPwsObBord:OnBuffBlueClicked()
  if self.blue_BuffID == nil then
    return
  end
  local desc = Table_Buffer[self.blue_BuffID].BuffDesc
  local normalTip = TipManager.Instance:ShowNormalTip(desc, self.stick, NGUIUtil.AnchorSide.Left, {10, 0})
  normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
end
