autoImport("PveAchievementCell")
PveAchievementView = class("CreateGuildPopUp", ContainerView)
PveAchievementView.ViewType = UIViewType.PopUpLayer

function PveAchievementView:Init()
  self:FindGO()
  self:AddEvts()
  self:ResetAchievement()
end

function PveAchievementView:FindGO()
  local title = self:FindComponent("Title", UILabel)
  title.text = ZhString.Pve_Title
  local grid = self:FindComponent("Grid", UIGrid)
  self.gridCtl = UIGridListCtrl.new(grid, PveAchievementCell, "PveAchievementCell")
end

function PveAchievementView:AddEvts()
end

function PveAchievementView:ResetAchievement()
  local testData = {
    {
      reward = {
        {20190, 1},
        {20194, 2}
      },
      desc = "完成xx任务解锁",
      done = 0
    },
    {
      reward = {
        {20190, 1},
        {20194, 2}
      },
      desc = "完成yy任务解锁",
      done = 0
    },
    {
      reward = {
        {20190, 1},
        {20194, 2}
      },
      desc = "完成zz任务解锁",
      done = 1
    }
  }
  self.gridCtl:ResetDatas(testData)
end
