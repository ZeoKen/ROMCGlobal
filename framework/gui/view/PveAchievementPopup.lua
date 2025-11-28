autoImport("PveAchievementCell")
PveAchievementPopup = class("PveAchievementPopup", ContainerView)
PveAchievementPopup.ViewType = UIViewType.PopUpLayer

function PveAchievementPopup:Init()
  self:FindGameObjects()
  self:AddEvts()
end

function PveAchievementPopup:FindGameObjects()
  local title = self:FindComponent("Title", UILabel)
  title.text = ZhString.Pve_Title
  local grid = self:FindComponent("Grid", UIGrid)
  self.gridCtl = UIGridListCtrl.new(grid, PveAchievementCell, "PveAchievementCell")
end

function PveAchievementPopup:AddEvts()
  self:AddCloseButtonEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPveRaidAchieveFubenCmd, self.ResetAchievement)
end

function PveAchievementPopup:OnEnter()
  self.pveId = self.viewdata and self.viewdata.viewdata.id
  redlog("self.pveId", self.pveId)
  self:ResetAchievement()
end

function PveAchievementPopup:ResetAchievement()
  if self.pveId then
    local datas = Table_PveRaidEntrance[self.pveId]
    if datas and datas.ShowAchievement then
      self.gridCtl:ResetDatas(datas.ShowAchievement)
    end
  end
end
