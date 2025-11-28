MainViewFairylandPage = class("MainViewFairylandPage", SubMediatorView)
autoImport("SpaceTimeAffixCell")
autoImport("RoguelikeSkillCell")
local LevelUpAddColor = Color(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1)
local LevelUpGreyColor = Color(1, 1, 1, 1)

function MainViewFairylandPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewFairylandPage:Init()
  self:ReLoadPerferb("view/MainViewFairylandPage")
  self:FindObjs()
  self:AddListener()
  self:InitShow()
end

function MainViewFairylandPage:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self.batchLabel = self:FindComponent("Batch", UILabel)
  self.countDownLabel = self:FindComponent("CountDownLabel", UILabel)
  self.monsterCountLabel = self:FindComponent("MonsterCountLabel", UILabel)
  self.reviveCountLabel = self:FindComponent("ReviveCountLabel", UILabel)
  self.leftGo = self:LoadPreferb("view/MainViewFairylandPage_Left", self:FindGO("Anchor_Left", self.gameObject.transform.parent.parent.parent.gameObject))
  self.levelLabel = self:FindComponent("Level", UILabel, self.leftGo)
  self.expLabel = self:FindComponent("Exp", UILabel, self.leftGo)
  self.expSlider = self:FindComponent("ExpSlider", UISlider, self.leftGo)
  self.expSlider.value = 0
  local grid = self:FindComponent("Grid", UIGrid, self.leftGo)
  self.skillListCtrl = UIGridListCtrl.new(grid, RoguelikeSkillCell, "RoguelikeSkillCell")
  self.skillListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSkillCellClick, self)
  self.levelUpBtn = self:FindGO("LevelUpBtn", self.leftGo)
  self.levelUpBtnBC = self.levelUpBtn:GetComponent(BoxCollider)
  self.levelUpBtnBC.enabled = false
  self.levelUpAdd = self:FindComponent("LevelUpAdd", UISprite, self.levelUpBtn)
  self:SetTextureGrey(self.levelUpBtn, nil, LevelUpGreyColor)
  self:AddClickEvent(self.levelUpBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeSkillChooseView
    })
  end)
  self.levelUpLabel = self:FindComponent("LevelUpLabel", UILabel, self.leftGo)
  self.affixPart = self:FindGO("AffixPart")
  self.affixGrid = self:FindComponent("InfoCells", UIGrid, self.affixPart)
  self.affixCtrl = UIGridListCtrl.new(self.affixGrid, SpaceTimeAffixCell, "SpaceTimeAffixCell")
  self.affixBtn = self:FindGO("AffixCollider", self.affixPart)
  self:AddClickEvent(self.affixBtn, function()
    local affixDatas = {}
    for i = 1, #self.affixIds do
      if Table_MonsterAffix[self.affixIds[i]] then
        table.insert(affixDatas, WildMvpAffixData.new(Table_MonsterAffix[self.affixIds[i]]))
      end
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveAffixPopUp,
      viewdata = {
        AffixData = affixDatas,
        AffixDetailData = WildMvpProxy.Instance:GetPveAffixDatas2()
      }
    })
  end)
end

function MainViewFairylandPage:AddListener()
  self:AddListenEvt(ServiceEvent.FuBenCmdSTISyncAvailableUpgradeNumberCmd, self.HandleRandomPointUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncSpaceTimeIllusionInfoFuBenCmd, self.HandleUpdateRaidInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncSpaceTimeIllusionExpLevelFuBenCmd, self.UpdateRaidSkillLevelUp)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.HandleUpdateReviveCount)
  self:AddListenEvt(ServiceEvent.FuBenCmdSTISyncSkillCmd, self.UpdateSkillList)
end

function MainViewFairylandPage:InitShow()
  self.batchLabel.text = ZhString.Warband_StageReady
  self.monsterCountLabel.text = "--"
  self.countDownLabel.text = "--"
  self.reviveCountLabel.text = "--"
  self.levelLabel.text = string.format(ZhString.RoguelikeRaid_Level, 0)
  self.expLabel.text = "--/--"
  self.expSlider.value = 0
  self:UpdateSkillList()
  self.levelUpLabel.text = 0
end

function MainViewFairylandPage:HandleRandomPointUpdate(data)
  local randomPoint = RoguelikeSkillProxy.Instance:GetRandomSkillPoint() or 0
  if 0 < randomPoint then
  end
  self.levelUpLabel.text = randomPoint
  self.levelUpBtnBC.enabled = 0 < randomPoint
  if 0 < randomPoint then
    self:SetTextureWhite(self.levelUpBtn, nil, LevelUpAddColor)
    self.levelUpAdd.color = LevelUpAddColor
  else
    self:SetTextureGrey(self.levelUpBtn, nil, LevelUpGreyColor)
  end
end

function MainViewFairylandPage:HandleUpdateRaidInfo(note)
  local data = note.body
  xdlog("HandleUpdateRaidInfo")
  self.batchLabel.text = string.format(ZhString.RoguelikeRaid_Batch, data.turn or 0, 10)
  self.monsterCountLabel.text = data.count or 0
  self.endTimeStamp = data.endtime or 0
  local curServerTime = ServerTime.CurServerTime() / 1000
  if self.endTimeStamp == 0 or curServerTime > self.endTimeStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    self.countDownLabel.text = "--"
  else
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 333, self.UpdateLeftTime, self, 1)
  end
  local affixs = data.affixids
  if affixs and 0 < #affixs then
    self.affixPart:SetActive(true)
    self.bg.height = 311
    if not self.affixIds then
      self.affixIds = {}
      TableUtility.ArrayShallowCopy(self.affixIds, affixs)
      self.affixCtrl:ResetDatas(self.affixIds)
    elseif affixs and affixs ~= self.affixIds then
      TableUtility.ArrayShallowCopy(self.affixIds, affixs)
      self.affixCtrl:ResetDatas(self.affixIds)
    end
  else
    self.affixPart:SetActive(false)
    self.bg.height = 220
  end
end

function MainViewFairylandPage:UpdateLeftTime()
  local leftTime = self.endTimeStamp - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    self.countDownLabel.text = string.format("%02d:%02d", min, sec)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.countDownLabel.text = "--"
  end
end

function MainViewFairylandPage:UpdateRaidSkillLevelUp(note)
  local data = note.body
  local curlevel = data.curlevel or 0
  local curexp = data.curexp or 0
  local needexp = data.needexp or 0
  self.levelLabel.text = string.format(ZhString.RoguelikeRaid_Level, curlevel)
  self.expLabel.text = string.format("%d/%d", curexp, needexp)
  self.expSlider.value = curexp / needexp
end

function MainViewFairylandPage:HandleUpdateReviveCount()
  local reviveCount, maxCount = DungeonProxy.Instance:GetReviveCount()
  self.reviveCountLabel.text = string.format("%d/%d", math.max(0, maxCount - reviveCount), maxCount)
end

function MainViewFairylandPage:UpdateSkillList()
  local datas = {}
  local curSkillList = RoguelikeSkillProxy.Instance:GetCurrentSkillList()
  for i = 1, 4 do
    if curSkillList[i] then
      datas[i] = curSkillList[i]
    else
      datas[i] = RoguelikeSkillCell.Empty
    end
  end
  self.skillListCtrl:ResetDatas(datas)
end

function MainViewFairylandPage:HandleSkillCellClick(cell)
  if cell.data and cell.data ~= RoguelikeSkillCell.Empty then
    TipsView.Me():ShowTip(RoguelikeSkillTip, cell.data)
  end
end

function MainViewFairylandPage:OnExit()
  if not Slua.IsNull(self.leftGo) then
    GameObject.DestroyImmediate(self.leftGo)
  end
  TimeTickManager.Me():ClearTick(self)
  MainViewFairylandPage.super.OnExit(self)
end
