EndlessBattleFieldBannerView = class("EndlessBattleFieldBannerView", ContainerView)
EndlessBattleFieldBannerView.ViewType = UIViewType.PopUpLayer
local BannerName = {
  [FuBenCmd_pb.ETEAMPWS_RED] = "battlefield_bg_bottem_10",
  [FuBenCmd_pb.ETEAMPWS_BLUE] = "battlefield_bg_bottem_09"
}

function EndlessBattleFieldBannerView:Init()
  self:FindObjs()
  self:AddListenEvt(PVPEvent.PVP_CampChange, self.OnCampChange)
end

function EndlessBattleFieldBannerView:FindObjs()
  self.tweenAlpha = self:FindComponent("TweenRoot", TweenAlpha)
  self.campLabel = self:FindComponent("Camp", UILabel)
  self.headIcon = self:FindComponent("HeadIcon", UISprite)
  self.bannerTex = self:FindComponent("BgTexture", UITexture)
end

function EndlessBattleFieldBannerView:OnEnter()
  local camp = Game.Myself.data:GetNormalPVPCamp()
  if not camp or camp == 0 then
    self:Hide()
    return
  end
  self:ShowView(camp)
end

function EndlessBattleFieldBannerView:OnExit()
  local camp = Game.Myself.data:GetNormalPVPCamp()
  PictureManager.Instance:UnloadBattleFieldTexture(BannerName[camp], self.bannerTex)
  TimeTickManager.Me():ClearTick(self)
end

function EndlessBattleFieldBannerView:ShowView(camp)
  camp = camp or Game.Myself.data:GetNormalPVPCamp()
  if not camp or camp == 0 then
    return
  end
  self:Show()
  PictureManager.Instance:SetBattleFieldTexture(BannerName[camp], self.bannerTex)
  self.campLabel.text = camp == FuBenCmd_pb.ETEAMPWS_RED and ZhString.EndlessBattleEvent_Camp_Human or ZhString.EndlessBattleEvent_Camp_Vampire
  local icon = GameConfig.EndlessBattleField.CampHeadIcon and GameConfig.EndlessBattleField.CampHeadIcon[camp] or ""
  IconManager:SetFaceIcon(icon, self.headIcon)
  TimeTickManager.Me():CreateOnceDelayTick(6000, function()
    TweenAlpha.Begin(self.tweenAlpha.gameObject, 1, 0)
    self.tweenAlpha:SetOnFinished(function()
      self:CloseSelf()
    end)
  end, self)
end

function EndlessBattleFieldBannerView:OnCampChange(note)
  local ncreature = note.body
  if ncreature == Game.Myself then
    self:ShowView()
  end
end
