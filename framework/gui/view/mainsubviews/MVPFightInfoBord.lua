MVPFightInfoBord = class("MVPFightInfoBord", MainViewDungeonInfoSubPage)
local _MvpBattleActivityID = GameConfig.MvpBattle.ActivityID
local killConfig = GameConfig.MvpBattle.time_rank_desc
local currentCount = 0

function MVPFightInfoBord:Init()
  self:ReLoadPerferb("view/MVPFightInfoBord")
  self:AddViewEvts()
  self:initView()
  self:SetData()
end

function MVPFightInfoBord:SetData()
  self:HandleUserInfoUpdate()
  self:HandleNUserVarUpdate()
  self:HandleUpdateBossesInfo()
  self:HandleUpdateLeftTime()
end

function MVPFightInfoBord:initView()
  self.curPersonNum = self:FindComponent("curPersonNum", UILabel)
  self.mvpLeftNum = self:FindComponent("mvpLeftNum", UILabel)
  self.miniLeftNum = self:FindComponent("miniLeftNum", UILabel)
  self.leftTime = self:FindComponent("LeftTime", UILabel)
  self.hgTween = self:FindComponent("bg", TweenHeight)
  self.bg = self:FindComponent("bg", UISprite)
  self.content = self:FindGO("content")
  self.bgSizeX = self.bg.width
  local cellObj = self:FindGO("TipLabelCell")
  self.tiplabelCell = TipLabelCell.new(cellObj)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    self.onceTick = TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
      self:resizeContent()
    end, self, 11)
  end
  
  self.kill = self:FindGO("Kill")
  self.killTitle = self:FindGO("killTitle", self.gameObject):GetComponent(UILabel)
  self.KillCount = self:FindGO("KillCount", self.gameObject):GetComponent(UILabel)
  self.killRewardsp = self:FindGO("killReward", self.gameObject):GetComponent(UISprite)
  self.killRewardlb = self:FindGO("killRewardNum", self.gameObject):GetComponent(UILabel)
  self.killTip = self:FindGO("killTip", self.gameObject):GetComponent(UILabel)
  self.MaxCount = killConfig and killConfig[#killConfig].killcount
  self.forbidFunc = killConfig == nil
  if self.forbidFunc then
    self.kill:SetActive(false)
  end
  self.table = self:FindGO("Labels"):GetComponent(UITable)
end

function MVPFightInfoBord:AddViewEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, self.SetData)
  self:AddListenEvt(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, self.HandleUserInfoUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleNUserVarUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdBossDieFubenCmd, self.HandleUpdateBossesInfo)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartActCmd, self.HandleUpdateLeftTime)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.HandleUpdateLeftTime)
end

function MVPFightInfoBord:OnExit()
  self:ClearTick()
  MVPFightInfoBord.super.OnExit(self)
end

function MVPFightInfoBord:HandleUpdateBossesInfo(note)
  local contextlabel = {
    label = {},
    tiplabel = ZhString.MVPFightInfoBord_LeftMonster,
    color = ColorUtil.NGUIWhite
  }
  local bosses = PvpProxy.Instance.bosses
  local txt
  if bosses and next(bosses) then
    for k, v in pairs(bosses) do
      local npcData = Table_Monster[k]
      if npcData and npcData.NameZh ~= "" then
        if v.live and v.live > 0 then
          txt = string.format("◆%s X %s", npcData.NameZh, v.live)
        else
          txt = string.format("[c][9F9F9FFF] %s[-][/c]", npcData.NameZh)
        end
        table.insert(contextlabel.label, txt)
      end
    end
    self.tiplabelCell:SetData(contextlabel)
  else
    self.tiplabelCell:SetData()
  end
  self:resizeContent()
end

function MVPFightInfoBord:HandleNUserVarUpdate(note)
  if Var_pb.EVARTYPE_MVPREWARDNUM then
    local mvpLeft = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MVPREWARDNUM) or 0
    mvpLeft = GameConfig.MvpBattle.MvpRewardTimes - mvpLeft
    mvpLeft = 0 <= mvpLeft and mvpLeft or 0
    self.mvpLeftNum.text = string.format(ZhString.MVPFightInfoBord_MvpLeftTime, mvpLeft)
    local miniLeft = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MINIREWARDNUM) or 0
    miniLeft = GameConfig.MvpBattle.MiniRewardTimes - miniLeft
    miniLeft = 0 <= miniLeft and miniLeft or 0
    self.miniLeftNum.text = string.format(ZhString.MVPFightInfoBord_MiniLeftTime, miniLeft)
  end
  if Var_pb.EVARTYPE_MVPBATTLE_SKILL_NUM then
    currentCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MVPBATTLE_SKILL_NUM) or 0
    self:SetGuideReward(currentCount)
  end
  self:resizeContent()
end

function MVPFightInfoBord:HandleUserInfoUpdate(note)
  self.curPersonNum.text = string.format(ZhString.MVPFightInfoBord_LeftPerson, PvpProxy.Instance.usernum or 0)
end

function MVPFightInfoBord:HandleUpdateLeftTime(note)
  local running = FunctionActivity.Me():IsActivityRunning(_MvpBattleActivityID)
  if running then
    if self.timeTick == nil then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self)
    end
  else
    self:ClearTick()
  end
end

function MVPFightInfoBord:UpdateLeftTime()
  local actData = FunctionActivity.Me():GetActivityData(_MvpBattleActivityID)
  if actData ~= nil then
    local totalSec = actData:GetEndTime() - ServerTime.CurServerTime() / 1000
    if 0 < totalSec then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
      self.leftTime.text = string.format(ZhString.MVPFightInfoBord_LeftTime, hour, min, sec)
    end
  end
end

function MVPFightInfoBord:ClearTick()
  if self.timeTick ~= nil then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
  if self.onceTick then
    self.onceTick:Destroy()
    self.onceTick = nil
  end
end

function MVPFightInfoBord:resizeContent()
  if not self.container.gameObject.activeInHierarchy then
  end
  local height = 244
  self.bg.height = height + 10
  self.hgTween.from = height + 10
  if self.table then
    self.table:Reposition()
  end
end

function MVPFightInfoBord:SetGuideReward(count)
  if self.forbidFunc then
    return
  end
  if not count then
    return
  end
  if count >= self.MaxCount then
    self.kill:SetActive(false)
    self.killTip.text = ZhString.MVPFightInfoBord_FinishGuideReward
  else
    self.kill:SetActive(true)
    self.killTip.text = ""
    if killConfig then
      for i = 1, #killConfig do
        local kconfig = killConfig[i]
        if killConfig[i] and count < killConfig[i].killcount then
          self.killTitle.text = kconfig.title
          self.KillCount.text = string.format(ZhString.MVPFightInfoBord_KillCount, count, kconfig.killcount)
          IconManager:SetItemIcon(kconfig.rewardicon, self.killRewardsp)
          self.killRewardlb.text = string.format(ZhString.MVPFightInfoBord_killRewardNum, kconfig.num)
          return
        end
      end
    end
  end
end
