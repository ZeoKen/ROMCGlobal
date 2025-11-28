autoImport("HomeScoreLvCell")
HomeScoreLvPopUp = class("HomeScoreLvPopUp", BaseView)
HomeScoreLvPopUp.ViewType = UIViewType.PopUpLayer

function HomeScoreLvPopUp:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeScoreLvPopUp:FindObjs()
  self.labHomeLv = self:FindComponent("labHomeLv", UILabel)
  self.labHomeScore = self:FindComponent("labHomeScore", UILabel)
  self.sliderHomeScore = self:FindComponent("sliderHomeScore", UISlider)
  self.listHomeScores = UIGridListCtrl.new(self:FindComponent("HomeInfoContainer", UITable), HomeScoreLvCell, "HomeScoreLvCell")
  self.noneTip = self:FindGO("NoneTip")
end

function HomeScoreLvPopUp:AddEvts()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
end

function HomeScoreLvPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.UpdateHomeInfo)
end

function HomeScoreLvPopUp:ClickHelp()
  local helpData = Table_Help[1]
  self:OpenHelpView(helpData)
end

function HomeScoreLvPopUp:UpdateHomeInfo()
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if myHouseData then
    self.labHomeLv.text = string.format(ZhString.Home_Lv, myHouseData.lv or 0)
    if myHouseData:IsMaxLv() then
      self.labHomeScore.text = "max"
      self.sliderHomeScore.value = 1
    else
      local curExp, needExp = myHouseData:GetCurLvScore(), myHouseData:GetCurLvNeedScore()
      self.labHomeScore.text = string.format("%s/%s", myHouseData.score, myHouseData:GetCurLvNeedTotalScore())
      self.sliderHomeScore.value = 0 < needExp and curExp / needExp or 0
    end
  else
    self.labHomeLv.text = string.format(ZhString.Home_Lv, 0)
    self.labHomeScore.text = "0/100"
    self.sliderHomeScore.value = 0
  end
  self.listHomeScores:ResetDatas(Table_HomeBuff)
end

function HomeScoreLvPopUp:OnEnter()
  HomeScoreLvPopUp.super.OnEnter(self)
  self:UpdateHomeInfo()
end

function HomeScoreLvPopUp:OnExit()
  HomeScoreLvPopUp.super.OnExit(self)
end
