IPRaidBord = class("IPRaidBord", CoreView)
local RES_PATH = ResourcePathHelper.UIV1("part/IPRaidBord")
local raidConfig = GameConfig.KumamotoBear

function IPRaidBord:ctor(parent)
  local go = IPRaidBord.LoadPreferb_ByFullPath(nil, RES_PATH, parent, true)
  go.transform.localPosition = LuaGeometry.Const_V3_zero
  IPRaidBord.super.ctor(self, go)
  self:Init()
end

local RANK_DESC = raidConfig.kill_rank_desc or _EmptyTable

function IPRaidBord:Init()
  self.titlelab = self:FindComponent("Title", UILabel)
  self.title_icon = self:FindComponent("TitleIcon", UILabel)
  self.lefttimelab = self:FindComponent("LeftTime", UILabel)
  self.monsternumlab = self:FindComponent("MonsterNum", UILabel)
  self.titlelab.text = raidConfig.name
  self.content2 = self:FindGO("Content2")
  self.content3 = self:FindGO("Content3")
  self.helpLabel = self:FindComponent("HelpLabel", UILabel)
  self.table = self:FindComponent("Table", UITable)
  self.bg2 = self:FindComponent("Bg2", UISprite)
  self.level_array = {}
  for i = 1, #RANK_DESC do
    self.level_array[i] = self:FindComponent("Level" .. i, UILabel, self.content2)
  end
  self.activeSelf = self.gameObject.activeInHierarchy
end

function IPRaidBord:RefreshRank(score)
  score = score or 0
  self.monsternumlab.text = string.format(ZhString.IPRaidBord_Score, score)
  if raidConfig.NoScore then
    self.monsternumlab.gameObject:SetActive(false)
  else
    self.monsternumlab.gameObject:SetActive(true)
  end
  local choosed = false
  for i = 1, #RANK_DESC do
    local rank_desc = RANK_DESC[i]
    if choosed == false and score >= rank_desc.score and score ~= 0 then
      choosed = true
      self.level_array[i].text = "[c][00ff00]" .. RANK_DESC[i].title .. "[-][/c]"
    else
      self.level_array[i].text = RANK_DESC[i].title
    end
  end
end

function IPRaidBord:Refresh()
  self:RefreshRank()
  self:UpdateLeftTime()
  self:UpdateShowInfo()
end

function IPRaidBord:UpdateLeftTime()
  self.starttime = ServerTime.CurServerTime()
  self.endtime = self.starttime + raidConfig.time * 1000
  if raidConfig.NoInitCountDown then
    self.endtime = 0
  end
  self.timeUpTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateLeftTimeTick, self, 10)
end

function IPRaidBord:RefreshLeftTime(endtime)
  self.endtime = endtime * 1000
  if not timeUpTick then
    self.timeUpTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateLeftTimeTick, self, 10)
  end
end

function IPRaidBord:_UpdateLeftTimeTick()
  local leftTime = math.max((self.endtime - ServerTime.CurServerTime()) / 1000, 0)
  local d, h, m, s = ClientTimeUtil.FormatTimeBySec(leftTime)
  self.lefttimelab.text = string.format(ZhString.IPRaidBord_Countdown, m, s)
  if leftTime <= 0 then
    TimeTickManager.Me():ClearTick(self, 10)
    self.timeUpTick = nil
    self.lefttimelab.text = string.format(ZhString.PlayerTip_ExpireTime, "--:--")
  end
end

function IPRaidBord:UpdateShowInfo()
  if raidConfig.NoShowRank then
    self.content2:SetActive(false)
  else
    self.content2:SetActive(true)
  end
  if raidConfig.HelpTip then
    self.helpLabel.text = raidConfig.HelpTip
    self.content3:SetActive(true)
  else
    self.content3:SetActive(false)
  end
  local height = 100
  if self.content2.activeSelf then
    height = height + 150
  end
  if self.content3.activeSelf then
    height = height + 150
  end
  self.bg2.height = height
end

function IPRaidBord:ShowSelf()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.activeSelf == true then
    return
  end
  self.activeSelf = true
  self.gameObject:SetActive(true)
end

function IPRaidBord:HideSelf()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.activeSelf == false then
    return
  end
  self.activeSelf = false
  self.gameObject:SetActive(false)
  if self.timeUpTick then
    TimeTickManager.Me():ClearTick(self, 10)
    self.timeUpTick = nil
  end
end

function IPRaidBord:OnEnter()
  IPRaidBord.super.OnEnter(self)
end

function IPRaidBord:OnExit()
  IPRaidBord.super.OnExit(self)
  if self.timeUpTick then
    TimeTickManager.Me():ClearTick(self, 10)
    self.timeUpTick = nil
  end
end
