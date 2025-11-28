PveViewCardPopUp = class("PveViewCardPopUp", ContainerView)
PveViewCardPopUp.ViewType = UIViewType.PopUpLayer

function PveViewCardPopUp:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:AddEvt()
  self:UpdateView()
end

function PveViewCardPopUp:FindObjs()
  self.pveCard_AddTime = self:FindComponent("PveCard_AddTime", UILabel)
  self.pveCard_Battle = self:FindComponent("PveCard_Battle", UILabel)
  self.pveCard_Limited = self:FindComponent("PveCard_Limited", UILabel)
  self.pveCard_AddTime_ConfirmLab = self:FindComponent("PveCard_AddTime_Confirm", UILabel)
  self.pveCard_AddTime_ConfirmLab.text = ZhString.UniqueConfirmView_Confirm
  self.pveCard_AddTime_CancelLab = self:FindComponent("PveCard_AddTime_Cancel", UILabel)
  self.pveCard_AddTime_CancelLab.text = ZhString.UniqueConfirmView_CanCel
end

function PveViewCardPopUp:AddUIEvts()
  self:AddClickEvent(self.pveCard_AddTime_ConfirmLab.gameObject, function()
    if not PveEntranceProxy.Instance:CanAddPveCardTime(true) then
      return
    end
    ServiceFuBenCmdProxy.Instance:CallAddPveCardTimesFubenCmd()
  end)
  self:AddClickEvent(self.pveCard_AddTime_CancelLab.gameObject, function()
    self:CloseSelf()
  end)
end

local minSec = 60

function PveViewCardPopUp:UpdateView()
  local _EntranceProxy = PveEntranceProxy.Instance
  self.pveCard_AddTime.text = string.format(ZhString.Pve_PveCard_AddTime, math.floor(GameConfig.AddPveCardTimes.BattleTime / minSec))
  local usedBattleTime = math.floor((_EntranceProxy.pveCard_totalBattleTime - _EntranceProxy.pveCard_battleTime) / minSec)
  self.pveCard_Battle.text = string.format(ZhString.Pve_PveCard_BattleTime, usedBattleTime, math.floor(_EntranceProxy.pveCard_totalBattleTime / minSec))
  if _EntranceProxy.pvecard_noLimited then
    self.pveCard_Limited.text = ZhString.Pve_PveCard_timeNoLimited
  else
    self.pveCard_Limited.text = string.format(ZhString.Pve_PveCard_timeLimited, _EntranceProxy.pveCard_addTimes, GameConfig.AddPveCardTimes.LimitTimes)
  end
end

function PveViewCardPopUp:AddEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdAddPveCardTimesFubenCmd, self.UpdateView)
end
