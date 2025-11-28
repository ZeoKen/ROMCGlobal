autoImport("HeadwearRaidShortCutSkill")
autoImport("UIGridListCtrl")
MainViewHeadwearRaidPage_Activity = class("MainViewHeadwearRaidPage_Activity", MainViewDungeonInfoSubPage)
local proxyInstance, tickInstance
local countdownTid = 1
local updatetowerTid = 2

function MainViewHeadwearRaidPage_Activity:Init()
  proxyInstance = HeadwearRaidProxy.Instance
  tickInstance = TimeTickManager.Me()
  self:ReLoadPerferb("view/MainViewHeadwearRaidPage_Activity")
  self:InitView()
  self:AddViewEvents()
end

function MainViewHeadwearRaidPage_Activity:InitView()
  self.hptext = self:FindComponent("hptext", UILabel)
  self.timetext = self:FindComponent("timetext", UILabel)
  self.detailtext = self:FindComponent("detailtext", UILabel)
  self.hptext.text = ZhString.MainViewHeadwearRaidPage_hptext
  self.timetext.text = ZhString.MainViewHeadwearRaidPage_skipTime
  self.detailtext.text = ZhString.MainViewHeadwearRaidPage_detailtext
  self.round = self:FindComponent("round", UILabel)
  self.hpSlider = self:FindComponent("hpSlider", UISlider)
  self.hpLabel = self:FindComponent("hpLabel", UILabel)
  self.timeSlider = self:FindComponent("timeSlider", UISlider)
  self.timeLabel = self:FindComponent("timeLabel", UILabel)
  self.cr1s = self:FindComponent("cr1s", UISprite)
  self.cr2s = self:FindComponent("cr2s", UISprite)
  self.cr3s = self:FindComponent("cr3s", UISprite)
  self.cr1t = self:FindComponent("cr1t", UILabel)
  self.cr2t = self:FindComponent("cr2t", UILabel)
  self.cr3t = self:FindComponent("cr3t", UILabel)
  self.infoViewBtn = self:FindGO("btn")
  self.infoViewBtnBC = self.infoViewBtn:GetComponent(BoxCollider)
  self.infoViewBtnBC.enabled = false
  self:SetTextureGrey(self.infoViewBtn)
  self:AddClickEvent(self.infoViewBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HeadwearRaidMonsterInfoView
    })
  end)
  self.skillgrid = self:FindComponent("skills", UIGrid)
  self.skillShotCutList = UIGridListCtrl.new(self.skillgrid, HeadwearRaidShortCutSkill, "ShortCutSkill")
  self.leftGo = self:LoadPreferb("view/MainViewHeadwearRaidPage2", self:FindGO("Anchor_Left", self.gameObject.transform.parent.parent.parent.gameObject))
  local leftTitle = self:FindComponent("lefttitle", UILabel, self.leftGo)
  leftTitle.text = ZhString.HeadwearRaid_LeftBordTitle
  local leftPanel = self.leftGo:GetComponent(UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.leftGo, UIPanel)
  if upPanel then
    leftPanel.depth = 12 + upPanel.depth
  end
  self.towerInfoBtn = self:FindGO("HWTowerBtn", self.leftGo)
  self.towerInfo = self:FindGO("HWTowerInfo", self.leftGo)
  self:AddClickEvent(self.towerInfoBtn, function()
    if self.towerInfo.activeSelf then
      self.towerInfoBtn.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      self.towerInfo:SetActive(false)
    else
      self.towerInfoBtn.transform.localScale = LuaGeometry.GetTempVector3(-1, 1, 1)
      self.towerInfo:SetActive(true)
    end
  end)
  local tower1, tower2, tower3
  tower1 = self:FindGO("Tower1", self.leftGo)
  tower2 = self:FindGO("Tower2", self.leftGo)
  tower3 = self:FindGO("Tower3", self.leftGo)
  self.tower = {
    tower1,
    tower2,
    tower3
  }
  self.towericon = {
    self:FindComponent("towericon", UISprite, tower1),
    self:FindComponent("towericon", UISprite, tower2),
    self:FindComponent("towericon", UISprite, tower3)
  }
  self.towerlevel = {
    self:FindComponent("towerlevel", UILabel, tower1),
    self:FindComponent("towerlevel", UILabel, tower2),
    self:FindComponent("towerlevel", UILabel, tower3)
  }
  self.towerres1s = {
    self:FindComponent("res1icon", UISprite, tower1),
    self:FindComponent("res1icon", UISprite, tower2),
    self:FindComponent("res1icon", UISprite, tower3)
  }
  self.towerres1t = {
    self:FindComponent("res1text", UILabel, tower1),
    self:FindComponent("res1text", UILabel, tower2),
    self:FindComponent("res1text", UILabel, tower3)
  }
  self.towerres2s = {
    self:FindComponent("res2icon", UISprite, tower1),
    self:FindComponent("res2icon", UISprite, tower2),
    self:FindComponent("res2icon", UISprite, tower3)
  }
  self.towerres2t = {
    self:FindComponent("res2text", UILabel, tower1),
    self:FindComponent("res2text", UILabel, tower2),
    self:FindComponent("res2text", UILabel, tower3)
  }
end

function MainViewHeadwearRaidPage_Activity:AddViewEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.RecvPlayerMapChange)
  self:AddListenEvt(ServiceEvent.RaidCmdHeadwearActivityNpcUserCmd, self.RecvHeadwearNpcUserCmd)
  self:AddListenEvt(ServiceEvent.RaidCmdHeadwearActivityRoundUserCmd, self.RecvHeadwearRoundUserCmd)
  self:AddListenEvt(ServiceEvent.RaidCmdHeadwearActivityTowerUserCmd, self.RecvHeadwearTowerUserCmd)
end

function MainViewHeadwearRaidPage_Activity:OnExit()
  tickInstance:ClearTick(self)
  self.skillShotCutList:RemoveAll()
  self.countdownTick = nil
  self.updatetowerTick = nil
  if not Slua.IsNull(self.leftGo) then
    GameObject.DestroyImmediate(self.leftGo)
  end
  MainViewHeadwearRaidPage_Activity.super.OnExit(self)
end

function MainViewHeadwearRaidPage_Activity:RecvHeadwearNpcUserCmd(data)
  if HeadwearRaidProxy.Instance.monsters and #HeadwearRaidProxy.Instance.monsters > 0 then
    self.infoViewBtnBC.enabled = true
    self:SetTextureWhite(self.infoViewBtn, Color(0.1568627450980392, 0.4823529411764706, 0.6705882352941176))
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HeadwearRaidMonsterInfoView,
    viewdata = {autoHide = 5}
  })
end

function MainViewHeadwearRaidPage_Activity:RecvHeadwearRoundUserCmd(data)
  if not self.roundUserCmdReceived then
    self.roundUserCmdReceived = true
    self:RefreshAll()
    return
  end
  if proxyInstance.refreshRound then
    self:RefreshRoundInfo()
    proxyInstance.refreshRound = nil
  end
  if proxyInstance.refreshTime then
    self:RefreshTimeInfo()
    proxyInstance.refreshTime = nil
  end
  if proxyInstance.refreshHp then
    self:RefreshBaseHP()
    proxyInstance.refreshHp = nil
  end
  if proxyInstance.refreshSkill then
    self:RefreshSkills()
    proxyInstance.refreshSkill = nil
  end
  if proxyInstance.refreshCrystal then
    self:RefreshCrystals()
    self:RefreshSkills()
    proxyInstance.refreshCrystal = nil
  end
end

function MainViewHeadwearRaidPage_Activity:RefreshAll()
  self:RefreshRoundInfo()
  self:RefreshBaseHP()
  self:RefreshTimeInfo()
  self:RefreshSkills()
  self:RefreshCrystals()
  self:SetTowerUpdateTick()
  self:RefreshTowers()
end

function MainViewHeadwearRaidPage_Activity:RecvHeadwearTowerUserCmd()
  self:RefreshTowers()
end

function MainViewHeadwearRaidPage_Activity:RecvPlayerMapChange(note)
  if note.type == LoadSceneEvent.StartLoad then
    for i = 1, #proxyInstance.skills do
      local skilldata = SkillProxy.Instance:GetLearnedSkill(proxyInstance.skills[i])
      if skilldata then
        SkillProxy.Instance:RemoveLearnedSkill(skilldata)
      end
    end
  end
end

local dosth = function(towerinfo, staticinfo, i)
  local itemid = towerinfo.crystalInfo[i]
  local curNum = towerinfo.crystals[itemid]
  local nextLv = towerinfo.level + 1
  local needNum = staticinfo.upgrade[nextLv] and staticinfo.upgrade[nextLv][i] or 0
  local curLvNum = staticinfo.upgrade[towerinfo.level] and staticinfo.upgrade[towerinfo.level][i] or 0
  local color = curNum >= needNum and "FFFFFF" or "FF0000"
  if needNum == 0 then
    return "max"
  else
    return "[" .. color .. "]" .. tostring(curNum - curLvNum) .. "[-]/" .. tostring(needNum - curLvNum)
  end
end

function MainViewHeadwearRaidPage_Activity:RefreshTowers()
  local towerid, towerinfo, staticinfo
  for i = 1, #proxyInstance.config.thumbTowers do
    towerid = proxyInstance.config.thumbTowers[i]
    towerinfo = proxyInstance:GetTowerInfo(towerid)
    staticinfo = proxyInstance.config.tower[towerid]
    if towerinfo then
      if not self.tower[i].activeSelf then
        self.tower[i]:SetActive(true)
        self.towericon[i].spriteName = staticinfo.thumbicon
        IconManager:SetItemIcon(Table_Item[towerinfo.crystalInfo[1]].Icon, self.towerres1s[i])
        IconManager:SetItemIcon(Table_Item[towerinfo.crystalInfo[2]].Icon, self.towerres2s[i])
      end
      self.towerlevel[i].text = "Lv." .. tostring(towerinfo.level)
      self.towerres1t[i].text = dosth(towerinfo, staticinfo, 1)
      self.towerres2t[i].text = dosth(towerinfo, staticinfo, 2)
    else
      self.tower[i]:SetActive(false)
    end
  end
end

function MainViewHeadwearRaidPage_Activity:SetTowerUpdateTick()
  self.updatetowerTick = tickInstance:CreateTick(0, 300, self.UpdateTowers, self, updatetowerTid)
end

function MainViewHeadwearRaidPage_Activity:UpdateTowers()
  HeadwearRaidProxy.Instance:UpdateTowers()
end

function MainViewHeadwearRaidPage_Activity:RefreshRoundInfo()
  self.round.text = string.format(ZhString.MainViewHeadwearRaidPage_round, proxyInstance.round)
end

function MainViewHeadwearRaidPage_Activity:RefreshTimeInfo()
  if self.countdownTick then
    tickInstance:ClearTick(self, countdownTid)
    self.countdownTick = nil
  end
  if proxyInstance.skip_time > 0 then
    self.endTime = ServerTime.CurServerTime() / 1000 + proxyInstance.skip_time
    self.countdownTick = tickInstance:CreateTick(0, 300, self.UpdateCountdown, self, countdownTid)
    self.timetext.text = ZhString.MainViewHeadwearRaidPage_skipTime
    self.timefull = proxyInstance.config.skipTime
  elseif 0 < proxyInstance.rage_time then
    self.endTime = ServerTime.CurServerTime() / 1000 + proxyInstance.rage_time
    self.countdownTick = tickInstance:CreateTick(0, 300, self.UpdateCountdown, self, countdownTid)
    self.timetext.text = proxyInstance.round == 1 and ZhString.MainViewHeadwearRaidPage_furyTime1 or ZhString.MainViewHeadwearRaidPage_furyTime
    self.timefull = proxyInstance.config.furyTime - proxyInstance.config.skipTime
  else
    self.timetext.text = ZhString.MainViewHeadwearRaidPage_infuryTime
    self.timefull = 1
  end
end

function MainViewHeadwearRaidPage_Activity:UpdateCountdown()
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    leftTime = 0
    if self.timetext.text == ZhString.MainViewHeadwearRaidPage_skipTime then
      proxyInstance.skip_time = 0
      self:RefreshTimeInfo()
    elseif self.timetext.text == ZhString.MainViewHeadwearRaidPage_furyTime or self.timetext.text == ZhString.MainViewHeadwearRaidPage_furyTime1 then
      proxyInstance.rage_time = 0
      self:RefreshTimeInfo()
    end
  end
  leftTime = math.floor(leftTime)
  self.timeLabel.text = leftTime
  redlog("---------------------UpdateCountdown leftTime； ", leftTime)
  self.timeSlider.value = leftTime / self.timefull
end

function MainViewHeadwearRaidPage_Activity:RefreshBaseHP()
  self.hpLabel.text = proxyInstance.hp_pct .. "%"
  redlog("---------------------RefreshBaseHP hp_pct: ", proxyInstance.hp_pct)
  self.hpSlider.value = proxyInstance.hp_pct / 100
end

function MainViewHeadwearRaidPage_Activity:RefreshSkills()
  local skilldatas = {}
  for i = 1, #proxyInstance.skills do
    local skilldata = SkillItemData.new(proxyInstance.skills[i], 0, 0, 0, 0)
    skilldata.learned = true
    if not SkillProxy.Instance:HasLearnedSkill(proxyInstance.skills[i]) then
      SkillProxy.Instance:LearnedSkill(skilldata)
    end
    TableUtility.ArrayPushBack(skilldatas, skilldata)
  end
  self.skillShotCutList:ResetDatas(skilldatas)
end

function MainViewHeadwearRaidPage_Activity:RefreshCrystals()
  local crs = {
    self.cr1s,
    self.cr2s,
    self.cr3s
  }
  local crt = {
    self.cr1t,
    self.cr2t,
    self.cr3t
  }
  for i = 1, #crs do
    local crid = proxyInstance.config.crystalIDs[i]
    IconManager:SetItemIcon(Table_Item[crid].Icon, crs[i])
    crt[i].text = proxyInstance.crystals[crid]
  end
end
