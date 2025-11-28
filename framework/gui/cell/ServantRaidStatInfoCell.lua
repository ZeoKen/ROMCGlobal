ServantRaidStatInfoCell = class("ServantRaidStatInfoCell", BaseCell)

function ServantRaidStatInfoCell:Init()
  ServantRaidStatInfoCell.super.Init(self)
  self:FindObjs()
end

function ServantRaidStatInfoCell:FindObjs()
  self.selfwidget = self.gameObject:GetComponent(UIWidget)
  self.raidicon = self:FindComponent("raidicon", UISprite)
  self.info1 = self:FindComponent("info1", UILabel)
  self.info2 = self:FindComponent("info2", UILabel)
  self.received = self:FindGO("received")
  IconManager:SetArtFontIcon("Rewardtask_txt_1", self.received:GetComponent(UISprite))
  self.giftBtn = self:FindGO("GiftButton")
  self.goBtn = self:FindGO("GOButton")
  self.giftSp = self.giftBtn:GetComponent(UISprite)
  self.giftCl = self.giftBtn:GetComponent(BoxCollider)
  self.giftlight = self:FindGO("giftlight")
  self:AddClickEvent(self.giftBtn, function()
    self:PassEvent(ServantRaidStatEvent.GetRewardClick, self)
  end)
  self:AddClickEvent(self.goBtn, function()
    self:PassEvent(ServantRaidStatEvent.GoToBtnClick, self)
  end)
end

function ServantRaidStatInfoCell:SetData(data)
  self.data = data
  IconManager:SetUIIcon(data.staticData.Sub_Icon, self.raidicon)
  self.info1.text = data.staticData.Title
  if data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_GO then
    self.selfwidget.alpha = 1
    self.goBtn:SetActive(true)
    self.giftlight:SetActive(false)
    self.giftBtn:SetActive(false)
    self.received:SetActive(false)
  elseif data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_FINISH then
    self.selfwidget.alpha = 1
    self.goBtn:SetActive(false)
    self.giftlight:SetActive(false)
    self.giftBtn:SetActive(false)
    self.giftSp.spriteName = "growup2"
    self.giftCl.enabled = false
    self.received:SetActive(true)
  elseif data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_REWARD then
    self.selfwidget.alpha = 1
    self.goBtn:SetActive(false)
    self.giftlight:SetActive(true)
    self.giftBtn:SetActive(true)
    self.giftSp.spriteName = "growup1"
    self.giftCl.enabled = true
    self.received:SetActive(false)
  else
    self.selfwidget.alpha = 0.5
    self.goBtn:SetActive(false)
    self.giftlight:SetActive(false)
    self.giftBtn:SetActive(false)
    self.received:SetActive(false)
  end
  if data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_GO or data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_FINISH or data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_REWARD then
    if data.staticData.PageType == 4 then
      self.info2.text = string.format(ZhString.Servant_RaidStat_tower_info, data.passtimes, data.staticData.Difficulty)
    elseif data.staticData.PageType == 10 then
      local exinfo = ServantRaidStatProxy.Instance:GetSingleRaidData(data.staticData.PageType, data.staticData.Difficulty)
      exinfo = exinfo and exinfo.exinfo and exinfo.exinfo[1] or 0
      self.info2.text = ZhString.Servant_RaidStat_guild_info .. string.format(data.staticData.Progress, exinfo)
    elseif data.staticData.PageType == 51 then
      self.info2.text = ZhString.Servant_RaidStat_DeadBoss .. string.format(data.staticData.Progress, data.passtimes)
    elseif data.staticData.PageType == FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or data.staticData.PageType == FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID then
      self.info2.text = ZhString.Servant_RaidStat_Comodo_info .. string.format(data.staticData.Progress, data.passtimes)
    else
      self.info2.text = ZhString.Servant_RaidStat_passtimes .. ((data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_GO or data.status == 0) and "0/1" or "1/1")
    end
  else
    self.info2.text = ZhString.Servant_RaidStat_notunlock
  end
end
