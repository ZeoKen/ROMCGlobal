autoImport("OthelloPVPBord")
OthelloPVPObBord = class("OthelloPVPObBord", OthelloPVPBord)

function OthelloPVPObBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath("GUI/v1/part/OthelloPVPObBord", parent, true)
  self:InitView()
end

function OthelloPVPObBord:InitView()
  OthelloPVPObBord.super.InitView(self)
  self.killNumHomeLabel = self:FindComponent("KillNum_Red", UILabel)
  self.killNumAwayLabel = self:FindComponent("KillNum_Blue", UILabel)
end

function OthelloPVPObBord:UpdateInfo()
  OthelloPVPObBord.super.UpdateInfo(self)
  local proxy = PvpObserveProxy.Instance
  self.killNumHomeLabel.text = proxy:GetKillNum(1)
  self.killNumAwayLabel.text = proxy:GetKillNum(2)
end

function OthelloPVPObBord:Hide()
  OthelloPVPObBord.super.Hide(self)
  self:RemoveTimeTick_Raid()
end
