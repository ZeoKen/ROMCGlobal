autoImport("AsyncPvpRaidWaveResultCell")
AsyncPvpRaidWaveResultPopup = class("AsyncPvpRaidWaveResultPopup", ContainerView)
AsyncPvpRaidWaveResultPopup.ViewType = UIViewType.PopUpLayer
local StatTypeMap = {
  [1] = FuBenCmd_pb.ESTAT_TYPE_TIME,
  [2] = FuBenCmd_pb.ESTAT_TYPE_DAMAGE,
  [3] = FuBenCmd_pb.ESTAT_TYPE_TAKE_DAMAGE,
  [4] = FuBenCmd_pb.ESTAT_TYPE_RELIVE
}
local StatNameMap = {
  [1] = ZhString.AsyncPvpRaidWaveResultPopup_TimeInterval,
  [2] = ZhString.AsyncPvpRaidWaveResultPopup_Damage,
  [3] = ZhString.AsyncPvpRaidWaveResultPopup_TakeDamage,
  [4] = ZhString.AsyncPvpRaidWaveResultPopup_Revive,
  [5] = ZhString.GeffenMagic_Score_Rate
}
local LogoTexName = "magic_victory_04"

function AsyncPvpRaidWaveResultPopup:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function AsyncPvpRaidWaveResultPopup:FindObjs()
  self.logoTex = self:FindComponent("LogoTex", UITexture)
  self.waveLabel = self:FindComponent("Wave", UILabel)
  local grid = self:FindComponent("Grid", UIGrid)
  self.statListCtrl = UIGridListCtrl.new(grid, AsyncPvpRaidWaveResultCell, "AsyncPvpRaidWaveResultCell")
  self.totalScoreLabel = self:FindComponent("TotalScore", UILabel)
  local confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirmBtn, function()
    self:CloseSelf()
  end)
  self.newTag = self:FindGO("NewTag")
  self.effectContainer = self:FindGO("EffectContainer")
end

function AsyncPvpRaidWaveResultPopup:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdGeffenMagicInfoSyncCmd, self.HandleSyncGeffenMagicInfo)
end

function AsyncPvpRaidWaveResultPopup:HandleSyncGeffenMagicInfo(data)
  local isInBattle = AsyncPvpRaidProxy.Instance:IsInBattle()
  if isInBattle then
    self:CloseSelf()
  end
end

function AsyncPvpRaidWaveResultPopup:OnEnter()
  self.waveLabel.text = string.format(ZhString.AsyncPvpRaidDiffSetView_Wave, ZhString.ChinaNumber[AsyncPvpRaidProxy.Instance:GetCurWave()])
  self.totalScoreLabel.text = string.format(ZhString.AsyncPvpRaidWaveResultPopup_TotalScore, AsyncPvpRaidProxy.Instance:GetScore())
  local datas = {}
  for i = 1, 5 do
    if i ~= 2 then
      local data = {}
      local type = StatTypeMap[i]
      data.name = StatNameMap[i]
      if i ~= 5 then
        local statData = AsyncPvpRaidProxy.Instance:GetStatData(type)
        if type == FuBenCmd_pb.ESTAT_TYPE_TIME then
          local time = statData and statData.value or 0
          local min = math.floor(time / 60)
          local sec = time % 60
          data.value = string.format("%02d:%02d", min, sec)
        else
          data.value = statData and statData.value or 0
        end
        local score = statData and statData.score or 0
        score = 0 < score and "+" .. score or score
        data.score = score
      else
        data.value = ""
        local scoreRatePercent = NumberUtility.RoundToInt(AsyncPvpRaidProxy.Instance:GetScoreRate() * 100)
        data.score = string.format("x%d%%", scoreRatePercent)
      end
      datas[#datas + 1] = data
    end
  end
  self.statListCtrl:ResetDatas(datas)
  PictureManager.Instance:SetGeffenMagicTexture(LogoTexName, self.logoTex)
  self.newTag:SetActive(AsyncPvpRaidProxy.Instance:IsNewRecord())
  self:PlayUIEffect(EffectMap.UI.AsyncPvpRaid_Win, self.effectContainer)
end

function AsyncPvpRaidWaveResultPopup:OnExit()
  PictureManager.Instance:UnloadGeffenMagicTexture(LogoTexName, self.logoTex)
end
