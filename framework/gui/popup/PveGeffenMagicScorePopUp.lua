local _bgTextureName = "magic_bg_01"
autoImport("PveGeffenMagicScoreCell")
PveGeffenMagicScorePopUp = class("PveGeffenMagicScorePopUp", ContainerView)
PveGeffenMagicScorePopUp.ViewType = UIViewType.PopUpLayer

function PveGeffenMagicScorePopUp:Init()
  self:AddCloseButtonEvent()
  self:FindObjs()
  self:AddEvt()
  self:UpdateView()
end

function PveGeffenMagicScorePopUp:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
  self:PlayUIEffect(EffectMap.UI.AsyncPvpRaid_Score, self.effectContainer)
  self.bgTex = self:FindComponent("BgTexture", UITexture)
  PictureManager.Instance:SetUI(_bgTextureName, self.bgTex)
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GeffenMagic_Title
  self.totalScoreLab = self:FindComponent("TotalScore", UILabel)
  self.closeBtnLab = self:FindComponent("CloseBtnLab", UILabel)
  self.closeBtnLab.text = ZhString.FloatAwardView_Confirm
  local scoreTable = self:FindComponent("ScoreTable", UITable)
  self.scoreCtl = UIGridListCtrl.new(scoreTable, PveGeffenMagicScoreCell, "PveGeffenMagicScoreCell")
end

function PveGeffenMagicScorePopUp:OnExit()
  PictureManager.Instance:UnLoadUI(_bgTextureName, self.bgTex)
end

function PveGeffenMagicScorePopUp:AddEvt()
  self:AddListenEvt(ServiceEvent.SceneUser3GeffenMagicWaveScoreQueryCmd, self.UpdateView)
end

function PveGeffenMagicScorePopUp:UpdateView()
  local totalScore = GeffenMagicWaveScoreProxy.Instance:GetWaveTotalScore()
  self.totalScoreLab.text = string.format(ZhString.GeffenMagic_Total_Score, totalScore)
  local waveScore = GeffenMagicWaveScoreProxy.Instance:GetWaveScore()
  self.scoreCtl:ResetDatas(waveScore)
end
