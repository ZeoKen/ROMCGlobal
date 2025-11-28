autoImport("TaskQuestCell")
autoImport("UIAutoScrollCtrl")
TaskQuestCell_SpaceDragon = class("TaskQuestCell_SpaceDragon", TaskQuestCell)
local MaxRewardNum = 8
local Yellow = LuaColor.New(1, 0.796078431372549, 0.40784313725490196, 1)
local Grey = LuaColor.New(0.4, 0.4235294117647059, 0.48627450980392156, 1)

function TaskQuestCell_SpaceDragon:ctor(go)
  self.gameObject = go
  self:Init()
end

function TaskQuestCell_SpaceDragon:Init()
  TaskQuestCell_SpaceDragon.super.initView(self)
  self.gradonSlider = self:FindComponent("DragonProgress", UISlider)
  self.dragonHp = self:FindComponent("DragonHp", UILabel)
  self.cdSlider = self:FindComponent("CountDown", UISlider)
  self.cdTime = self:FindComponent("CountdownTime", UILabel)
  self.tipScroll = self:FindComponent("StageTipPanel", UIScrollView)
  self.stageTip = self:FindComponent("StageTip", UILabel)
  self.stageTipCtrl = UIAutoScrollCtrl.new(self.tipScroll, self.stageTip, 8, 40)
  self:SetEvent(self.bgSprite.gameObject, function()
    self:sendNotification(MainViewEvent.SpaceDragonCellClick, {cellCtrl = self})
    self:OnClick()
  end)
  self.taskQuestType = "SpaceDragon"
  self.data = {}
  self.data.type = QuestDataType.QuestDataType_SPACEDRAGON
  self.rewardSps = {}
  for i = 1, MaxRewardNum do
    local sp = self:FindGO("AbyssRewardIcon" .. i):GetComponent(UISprite)
    self.rewardSps[i] = sp
  end
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
  self.rewardLabel.text = string.format("%d/%d", 0, MaxRewardNum)
  self.rewardProgressGO = self:FindGO("RewardProgress")
  self.rewardProgressSlider = self:FindComponent("RewardProgress", UISlider)
  local dragonGO = self:FindGO("DragonProgress")
  self.dragon_fg = self:FindComponent("fg", UISprite, dragonGO)
  self.dragon_icon = self:FindComponent("icon", UISprite, dragonGO)
end

function TaskQuestCell_SpaceDragon:AddLongPress()
end

function TaskQuestCell_SpaceDragon:AddCellClickEvent()
end

function TaskQuestCell_SpaceDragon:OnClick()
  local targetMap, targetPos = AbyssFakeDragonProxy.Instance:GetTracePos()
  targetPos = targetPos and LuaVector3.New(targetPos.x, targetPos.y, targetPos.z)
  redlog("OnClick", targetMap, targetPos)
  if targetMap and targetPos then
    FuncShortCutFunc.Me():MoveToPos({
      Event = {mapid = targetMap, pos = targetPos}
    })
  end
end

function TaskQuestCell_SpaceDragon:SetData(data)
  if not GameConfig.AbyssDragon then
    self.gameObject:SetActive(false)
    return
  end
  if not self.Inited then
    self.data.id = "SpaceDragon"
    self.gameObject:SetActive(true)
    self:OverSeaStopTweenLable()
    if not self.container.activeSelf then
      self.container:SetActive(true)
    end
    if self.widget.gameObject.activeSelf then
      self.widget.gameObject:SetActive(false)
    end
    self:SetTitleIcon(true)
    self.IconFromServer = nil
    self.ColorFromServer = nil
    self.specialIcon = nil
    self.groupid = nil
    self.nInvadeStyle = nil
    self.nInvadeItemId = nil
    self.nInvadeFinishTraceList = nil
    self.titleBg = nil
    self.iconStr = nil
    self.questList = nil
    local name = GameConfig.AbyssDragon.activityTitle or ""
    self:SetTitleText(name)
    self.iconStr = "renwu_icon_shikonglong"
    self:SetMyIconByServer(self.iconStr)
    self:SetIconObj(false)
    if StringUtil.ChLength(name) > 18 then
      self.title.fontSize = 18
    else
      self.title.fontSize = 20
    end
    if BranchMgr.IsChina() then
      UIUtil.WrapLabel(self.title)
    else
      self:OverSeaTweenLable()
    end
    self.desc:SetText("")
    self:initColor()
    self.ColorFromServer = 1
    self:ShowTitleColor()
  end
  if not self.Inited then
    self.Inited = true
  end
  local descHeight = self.desc.richLabel.height
  self:SetDetail()
end

function TaskQuestCell_SpaceDragon:SetDetail()
  local dragonConfig = GameConfig.AbyssDragon
  local info = AbyssFakeDragonProxy.Instance:GetDragonInfos()
  self:UpdateHp()
  if info then
    self.curPhase = info.dragonStage or 1
    if self.curPhase == 3 then
      self.dragon_fg.color = Grey
      IconManager:SetUIIcon("miniro_icon_shikonglong_zhihui", self.dragon_icon)
    else
      self.dragon_fg.color = Yellow
      IconManager:SetUIIcon("miniro_icon_shikonglong", self.dragon_icon)
    end
    if self.curPhase == 2 then
      local bp = info.endBp or 12
      local format = dragonConfig.StageDesc[self.curPhase]
      local bpName = GameConfig.AbyssDragon.bpName or {}
      local mapConfig = Table_BWMapZone[bpName[bp] or 61]
      local mapName = mapConfig.NameZh
      self.stageTip.text = string.format(format, mapName)
    else
      self.stageTip.text = dragonConfig.StageDesc[self.curPhase]
    end
    if self.stageTipCtrl then
      self.stageTipCtrl:Start(true, true)
    end
    self:SetTimeTick()
  end
  self:SetRewardGrid()
end

function TaskQuestCell_SpaceDragon:UpdateHp()
  local dragon_hp, dragon_maxhp = AbyssFakeDragonProxy.Instance:GetDragonHp()
  local hpPercent = dragon_hp / dragon_maxhp
  self.gradonSlider.value = hpPercent
  self.dragonHp.text = string.format("%d%%", dragon_hp / dragon_maxhp * 100)
  local rewardNum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_DRAGON_STAGE_REWARD) or 0
  self.rewardProgressGO:SetActive(rewardNum < MaxRewardNum and 0 < hpPercent and self.curPhase ~= 3)
  if rewardNum < MaxRewardNum then
    local value = 0
    if 0.1 < hpPercent then
      local step = math.ceil((hpPercent - 0.1) * 10)
      step = math.max(1, math.min(9, step))
      value = step * 0.1
    end
    self.rewardProgressSlider.value = value
  end
end

function TaskQuestCell_SpaceDragon:SetTimeTick()
  local duration = AbyssFakeDragonProxy.Instance:GetCountDownTime()
  if not duration then
    if self.tick then
      self.cdSlider.value = 0
      self.cdTime.text = ""
      TimeTickManager.Me():ClearTick(self)
      self.tick = nil
    end
    return
  end
  self.targetTime = duration + ServerTime.CurServerTime() / 1000
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTime()
  end, self)
end

function TaskQuestCell_SpaceDragon:UpdateTime()
  local duration = AbyssFakeDragonProxy.Instance:GetCountDownTime()
  local passedTime = AbyssFakeDragonProxy.Instance:GetPassedTime()
  local remainTime = self.targetTime - ServerTime.CurServerTime() / 1000
  local minutes = math.floor(remainTime / 60)
  local seconds = remainTime % 60
  self.cdTime.text = string.format("%d:%02d", minutes, seconds)
  self.cdSlider.value = remainTime / duration
end

function TaskQuestCell_SpaceDragon:DestroySelf()
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
  end
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
  TableUtility.TableClear(self)
  if self.stageTipCtrl then
    self.stageTipCtrl:Destroy()
    self.stageTipCtrl = nil
  end
end

function TaskQuestCell_SpaceDragon:SetRewardGrid()
  local rewardNum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_DRAGON_STAGE_REWARD) or 0
  for i = 1, MaxRewardNum do
    self.rewardSps[i].alpha = i <= rewardNum and 1 or 0.4
  end
  self.rewardLabel.text = string.format("%d/%d", rewardNum, MaxRewardNum)
end
