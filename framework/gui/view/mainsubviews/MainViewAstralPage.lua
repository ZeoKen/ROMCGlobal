MainViewAstralPage = class("MainViewAstralPage", SubView)
local PageState = {Normal = 1, Short = 2}

function MainViewAstralPage:Init()
  self:InitData()
  self:InitView()
  self:FindObjs()
  self:AddListenEvts()
end

function MainViewAstralPage:InitData()
  self.raidId = Game.MapManager:GetRaidID()
  self.roundConfigs = {}
  self.bossMap = {}
  for _, v in pairs(Table_MapRaid) do
    if v.RaidID == self.raidId then
      self.roundConfigs[v.Round] = v
    end
  end
end

function MainViewAstralPage:InitView()
  local parent = self:FindGO("AstralPageRoot")
  self:ReLoadPerferb("view/MainViewAstralPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function MainViewAstralPage:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.normalParent = self:FindGO("NormalParent")
  self.remainTimeLabel = self:FindComponent("RemainTime", UILabel)
  self.killMonsterLabel = self:FindComponent("KillMonster", UILabel)
  self.prayLevelLabel = self:FindComponent("PrayLevel", UILabel)
  self.prayBuffIcon = self:FindComponent("PrayIcon", UISprite)
  self:AddClickEvent(self.prayBuffIcon.gameObject, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstralPrayPopUp
    })
  end)
  self.reviveNumLabel = self:FindComponent("ReviveNum", UILabel)
  self.statBtn = self:FindGO("StatBtn")
  self:AddClickEvent(self.statBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstralStaticsView
    })
  end)
  self.bossGrid = self:FindComponent("BossGrid", UIGrid)
  self.bossListCtrl = UIGridListCtrl.new(self.bossGrid, ComodoBossHeadCell, "ComodoBossHeadCell")
  self.bossGrid.gameObject:SetActive(false)
  self.line = self:FindGO("MidLine")
end

function MainViewAstralPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdAstralInfoSyncCmd, self.RefreshView)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs)
end

function MainViewAstralPage:OnEnter()
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateReliveCount, self)
  local mapRaidConf = Table_MapRaid[self.raidId]
  self.titleLabel.text = mapRaidConf and mapRaidConf.NameZh or ""
  local prayId = AstralProxy.Instance:GetTeamPrayId()
  local config = Table_AstralPray[prayId]
  if config then
    self.prayBuffIcon.spriteName = config.BuffIcon
  end
  self:RefreshView()
  self:UpdateReliveCount()
end

function MainViewAstralPage:OnExit()
  self:ClearTimeTick()
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateReliveCount, self)
end

function MainViewAstralPage:SwitchPage(state)
  if not self.pageState then
    if state == AstralProxy.RoundState.RoundStart or state == AstralProxy.RoundState.InRound then
      self:SwitchToNormal()
    else
      self:SwitchToShort()
    end
  elseif state == AstralProxy.RoundState.RoundStart then
    self:SwitchToNormal()
  else
    self:SwitchToShort()
  end
end

function MainViewAstralPage:SwitchToNormal()
  local bossIds = AstralProxy.Instance:GetBossIds()
  local bossCount = #bossIds
  local deltaY = 0
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.statBtn)
  LuaGameObject.SetLocalPositionGO(self.statBtn, x, -45 - deltaY, z)
  x, y, z = LuaGameObject.GetLocalPositionGO(self.reviveNumLabel.gameObject)
  LuaGameObject.SetLocalPositionGO(self.reviveNumLabel.gameObject, x, -45 - deltaY, z)
  self.reviveNumLabel.gameObject:SetActive(true)
  x, y, z = LuaGameObject.GetLocalPositionGO(self.line)
  LuaGameObject.SetLocalPositionGO(self.line, x, 20 - deltaY, z)
  x, y, z = LuaGameObject.GetLocalPositionGO(self.prayLevelLabel.gameObject)
  LuaGameObject.SetLocalPositionGO(self.prayLevelLabel.gameObject, x, -2.4 - deltaY, z)
  self.bg.height = 202 + deltaY
  self.normalParent:SetActive(true)
  self.pageState = PageState.Normal
end

function MainViewAstralPage:SwitchToShort()
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.statBtn)
  LuaGameObject.SetLocalPositionGO(self.statBtn, x, 36, z)
  x, y, z = LuaGameObject.GetLocalPositionGO(self.reviveNumLabel.gameObject)
  LuaGameObject.SetLocalPositionGO(self.reviveNumLabel.gameObject, x, 36, z)
  self.reviveNumLabel.gameObject:SetActive(false)
  x, y, z = LuaGameObject.GetLocalPositionGO(self.prayLevelLabel.gameObject)
  LuaGameObject.SetLocalPositionGO(self.prayLevelLabel.gameObject, x, 78, z)
  self.bg.height = 123
  self.normalParent:SetActive(false)
  self.pageState = PageState.Short
end

function MainViewAstralPage:ClearTimeTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function MainViewAstralPage:HandleAddNpcs(note)
  local npcs = note and note.body
  if npcs then
    local updateBoss = false
    for i = 1, #npcs do
      local npc = npcs[i]
      local staticId = npc.data.staticData.id
      if npc.data:IsBoss() or npc.data:IsMini() then
        self.bossMap[staticId] = npc.data.id
        updateBoss = true
      end
    end
    if updateBoss then
      self:UpdateBoss()
    end
  end
end

function MainViewAstralPage:RefreshView()
  local state = AstralProxy.Instance:GetRoundState()
  redlog("MainViewAstralPage:RefreshView", state)
  if not self.pageState or state == AstralProxy.RoundState.RoundStart or state == AstralProxy.RoundState.RoundEnd then
    self:SwitchPage(state)
  end
  local totalMonster = AstralProxy.Instance:GetTotalMonsterNum()
  local leftMonster = AstralProxy.Instance:GetLeftMonsterNum()
  local killMonster = totalMonster - leftMonster
  local str = 0 < leftMonster and string.format("[c][ff8534]%s[-][/c]/%s", killMonster, totalMonster) or string.format("%s/%s", killMonster, totalMonster)
  self.killMonsterLabel.text = string.format(ZhString.Pve_Astral_KillMonster, str)
  local prayLevel = AstralProxy.Instance:GetCurPrayedLevel()
  self.prayLevelLabel.text = string.format(ZhString.Pve_Astral_PrayLevel, prayLevel)
  local endTime = AstralProxy.Instance:GetRoundEndTime()
  if 0 < endTime then
    if self.endTime ~= endTime then
      self.endTime = endTime
      local curTime = ServerTime.CurServerTime() / 1000
      redlog("MainViewAstralPage:SwitchPage", endTime, curTime)
      local remainTime = math.floor(endTime - curTime)
      if 0 < remainTime then
        self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
          self:SetRemainTime(remainTime)
          if remainTime <= 0 then
            self:ClearTimeTick()
            return
          end
          remainTime = remainTime - 1
        end, self)
      else
        self:ClearTimeTick()
      end
    end
  else
    self:ClearTimeTick()
    local round = AstralProxy.Instance:GetCurRound()
    local config = self.roundConfigs[round]
    local remainTime = config and config.LimitTime or 0
    self:SetRemainTime(remainTime)
  end
  self:UpdateBoss()
end

function MainViewAstralPage:SetRemainTime(remainTime)
  local min = remainTime // 60
  local sec = remainTime % 60
  self.remainTimeLabel.text = string.format(ZhString.Pve_Astral_RemainTime, min, sec)
end

function MainViewAstralPage:UpdateReliveCount()
  local reviveNum, maxReviveNum = DungeonProxy.Instance:GetReviveCount()
  redlog("MainViewAstralPage:UpdateReliveCount", reviveNum, maxReviveNum)
  self.reviveNumLabel.text = string.format("%s/%s", reviveNum, maxReviveNum)
end

function MainViewAstralPage:UpdateBoss()
  local bossIds = AstralProxy.Instance:GetBossIds()
  local datas = ReusableTable.CreateArray()
  for i = 1, #bossIds do
    local bossId = bossIds[i]
    local single = {}
    single.staticID = bossId
    single.guid = self.bossMap[bossId]
    table.insert(datas, single)
  end
  self.bossListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
end
