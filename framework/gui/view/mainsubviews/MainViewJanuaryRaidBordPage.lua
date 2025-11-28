MainViewJanuaryRaidBordPage = class("MainViewJanuaryRaidBordPage", CoreView)

function MainViewJanuaryRaidBordPage:ctor(go)
  MainViewJanuaryRaidBordPage.super.ctor(self, go)
  self:Init()
end

function MainViewJanuaryRaidBordPage:Init()
  self:FindObjs()
  self:AddMapEvts()
end

function MainViewJanuaryRaidBordPage:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.title_Icon = self:FindGO("titleIcon"):GetComponent(UISprite)
  self.info = self:FindGO("Info")
  self.leftTime = self:FindGO("LeftTime"):GetComponent(UILabel)
  self.scoreLabel = self:FindGO("Score"):GetComponent(UILabel)
  self.raidTipLabel = self:FindGO("Tips"):GetComponent(UILabel)
  self.raidTipLabel.text = ZhString.JanuaryRaid_RaidTip
end

function MainViewJanuaryRaidBordPage:AddMapEvts()
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdEndTimeSyncFubenCmd, self.StartCountDown, self)
  EventManager.Me():AddEventListener(MyselfEvent.MyDataChange, self.UpdateScoreInfo, self)
end

function MainViewJanuaryRaidBordPage:Show(tarObj)
  MainViewJanuaryRaidBordPage.super.Show(self, tarObj)
  if not tarObj then
    self:SetData()
  end
end

function MainViewJanuaryRaidBordPage:Hide(tarObj)
  MainViewJanuaryRaidBordPage.super.Hide(self, tarObj)
  if not tarObj then
    self.tickMg:ClearTick(self)
  end
end

function MainViewJanuaryRaidBordPage:StartCountDown(data)
  local endtime = data.endtime
  helplog("结束时间戳", endtime)
  self.endTimeStamp = endtime
  self.tickMg:ClearTick(self)
  self.tickMg:CreateTick(0, 500, self.updateLeftTime, self)
end

function MainViewJanuaryRaidBordPage:updateLeftTime()
  local leftTime = self.endTimeStamp - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    leftTime = 0
    self.tickMg:ClearTick(self)
  end
  leftTime = math.floor(leftTime)
  local m = math.floor(leftTime / 60)
  local sd = leftTime - m * 60
  local leftTimeStr = string.format("%02d:%02d", m, sd)
  self.progressLabel.text = string.format(ZhString.PlayerTip_ExpireTime, leftTimeStr)
end

function MainViewJanuaryRaidBordPage:UpdateScoreInfo()
  local score = Game.Myself.data.userdata:Get(UDEnum.JANUARY_SCORE) or 0
  self.scoreLabel.text = string.format(ZhString.ExpRaid_InfoBordScoreLabel, score)
end

function MainViewJanuaryRaidBordPage:OnHide()
  EventManager.Me():RemoveEventListener("InfoUpdate", self.UpdateTreasureInfos, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.RaidCmdRaidPuzzleDataUpdateRaidCmd, self.UpdateTarget, self)
end
