MainViewClassicPvpFightPage = class("MainViewClassicPvpFightPage", MainViewDungeonInfoSubPage)
local pagePath = "view/MainView_ClassicPvpFightBord"
MainViewClassicPvpFightPage.TickType = {DesertWolfPvpCountDown = 1, GorgeousMetalPvpCount = 2}
MainViewClassicPvpFightPage.DouCointItemId = 150

function MainViewClassicPvpFightPage:Init()
  self.root = self.container.viewMap.TraceInfoBord and self.container.viewMap.TraceInfoBord.classicPvpFightBord and self.container.viewMap.TraceInfoBord.classicPvpFightBord.transform
  self:ReLoadPerferb(pagePath, false, nil, self.root)
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:resetData()
  redlog("MainViewClassicPvpFightPage Init done")
end

function MainViewClassicPvpFightPage:resetData()
  self.my_teamscore = nil
  self.enemy_teamscore = nil
  self.remain_hp = nil
  self.player_num = nil
  self.score = nil
  self.type = nil
  self.starttime = nil
  self.tickMg:ClearTick(self)
end

function MainViewClassicPvpFightPage:initData()
  local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[1] or nil
  self.yoyoPvpToalNumPl = pvpCg and pvpCg.PeopleLimit or 999
  pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[2] or nil
  self.DesertWolfPvpTotalScore = pvpCg and pvpCg.MaxScore or 999
  self.DesertWolfPvpTotalTime = pvpCg and pvpCg.Time or 999
  pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[3] or nil
  self.GorgeousMetalPvpTotalTime = pvpCg and pvpCg.Time or 999
  self.tickMg = TimeTickManager.Me()
end

function MainViewClassicPvpFightPage:OnEnter()
  MainViewClassicPvpFightPage.super.OnEnter(self)
  self:ItemUpdate()
  self:SetData()
end

function MainViewClassicPvpFightPage:OnExit()
  MainViewClassicPvpFightPage.super.OnExit(self)
  self:resetData()
end

function MainViewClassicPvpFightPage:SetData()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo then
    local type = fightInfo.pvp_type
    self:changeUIByPvpType(type)
    if type == PvpProxy.Type.Yoyo then
      self:SetYoyoData(fightInfo)
    elseif type == PvpProxy.Type.DesertWolf then
      self:SetDesertWolfData(fightInfo)
    elseif type == PvpProxy.Type.GorgeousMetal then
      self:SetGorgeousMetalData(fightInfo)
    end
    NGUITools.UpdateWidgetCollider(self.bg.gameObject)
    self:resizeContent()
  end
end

function MainViewClassicPvpFightPage:initView()
  self.name = self:FindComponent("Title", UILabel)
  self.countDownLabel = self:FindComponent("CountDownLabel", UILabel)
  self.scoreLabel = self:FindComponent("score", UILabel)
  self.coinCount = SpriteLabel.CreateAsTable()
  self.coinCountLable = self:FindComponent("coinCount", UIRichLabel)
  self.coinCount:Init(self.coinCountLable, nil, 20, 20)
  self.bg = self:FindComponent("bg", UISprite)
  self.content = self:FindGO("content")
  self.bgSizeX = self.bg.width
end

function MainViewClassicPvpFightPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.HandleMatchCCmdNtfFightStatCCmd)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.ItemUpdate)
end

function MainViewClassicPvpFightPage:ItemUpdate(note)
  local userdata = Game.Myself and Game.Myself.data.userdata
  local num = 0
  if userdata then
    num = userdata:Get(UDEnum.PVPCOIN) or 0
  end
  local str = "{itemicon=%s}%s:%s"
  self.coinCount:Reset()
  local itemData = Table_Item[MainViewClassicPvpFightPage.DouCointItemId]
  str = string.format(str, MainViewClassicPvpFightPage.DouCointItemId, itemData.NameZh, num)
  self.coinCount:SetText(str, true)
end

function MainViewClassicPvpFightPage:HandleMatchCCmdNtfFightStatCCmd(note)
  self:SetData()
end

function MainViewClassicPvpFightPage:changeUIByPvpType(type)
  if type ~= self.pvpType then
    self.pvpType = type
    local x, y, z = LuaGameObject.GetLocalPosition(self.scoreLabel.transform)
    if type == PvpProxy.Type.Yoyo then
      self:Hide(self.countDownLabel)
      self.name.text = ZhString.MainViewClassicPvpFightPage_YoyoPvpName
      self.scoreLabel.transform.localPosition = LuaGeometry.GetTempVector3(x, -52, z)
    elseif type == PvpProxy.Type.DesertWolf then
      self:Show(self.countDownLabel)
      self.scoreLabel.transform.localPosition = LuaGeometry.GetTempVector3(x, -82, z)
      self.name.text = ZhString.MainViewClassicPvpFightPage_DesertWolfPvpName
    elseif type == PvpProxy.Type.GorgeousMetal then
      self:Show(self.countDownLabel)
      self.scoreLabel.transform.localPosition = LuaGeometry.GetTempVector3(x, -82, z)
      self.name.text = ZhString.MainViewClassicPvpFightPage_GorgeousMetalPvpName
    else
      helplog("error unknow pvp type!!!", type)
    end
  end
end

function MainViewClassicPvpFightPage:SetYoyoData(fightInfo)
  if fightInfo.player_num ~= self.player_num or fightInfo.score ~= self.score then
    self.player_num = fightInfo.player_num
    self.score = fightInfo.score
    local score = self.score
    if 999 < score then
      score = "999+"
    end
    self.scoreLabel.text = string.format(ZhString.MainViewClassicPvpFightPage_YoyoPvpScore, fightInfo.player_num, self.yoyoPvpToalNumPl, score)
  end
  self:setScoreLabelX()
end

function MainViewClassicPvpFightPage:setScoreLabelX()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.scoreLabel.transform, true)
  local width = bd.size.x
  local x, y1, z = LuaGameObject.GetLocalPosition(self.scoreLabel.transform)
  self.scoreLabel.transform.localPosition = LuaGeometry.GetTempVector3((self.bgSizeX - width) / 2, y1, z)
  x, y, z = LuaGameObject.GetLocalPosition(self.coinCountLable.transform)
  self.coinCountLable.transform.localPosition = LuaGeometry.GetTempVector3(x, y1 - self.scoreLabel.height - 5, z)
end

function MainViewClassicPvpFightPage:resizeContent()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform, true)
  local height = bd.size.y
  self.bg.height = height + 20
end

function MainViewClassicPvpFightPage:SetDesertWolfData(fightInfo)
  if fightInfo.my_teamscore ~= self.my_teamscore or fightInfo.enemy_teamscore ~= self.enemy_teamscore then
    self.my_teamscore = fightInfo.my_teamscore
    self.enemy_teamscore = fightInfo.enemy_teamscore
    local my_teamscoreStr = self.my_teamscore
    if 999 < my_teamscoreStr then
      my_teamscoreStr = "999+"
    end
    local enemy_teamscoreStr = self.enemy_teamscore
    if 999 < enemy_teamscoreStr then
      enemy_teamscoreStr = "999+"
    end
    self.scoreLabel.text = string.format(ZhString.MainViewClassicPvpFightPage_DesertWolfPvpScore, my_teamscoreStr, self.DesertWolfPvpTotalScore, enemy_teamscoreStr, self.DesertWolfPvpTotalScore)
  end
  self:setScoreLabelX()
  if fightInfo.starttime ~= self.starttime then
    self.starttime = fightInfo.starttime
    self.tickMg:ClearTick(self)
    self.tickMg:CreateTick(0, 500, self.updateDesertWolfTime, self, MainViewClassicPvpFightPage.TickType.DesertWolfPvpCountDown)
  end
end

function MainViewClassicPvpFightPage:SetGorgeousMetalData(fightInfo)
  if fightInfo.remain_hp ~= self.remain_hp then
    self.remain_hp = fightInfo.remain_hp
    self.scoreLabel.text = string.format(ZhString.MainViewClassicPvpFightPage_GorgeousMetalPvpScore, fightInfo.remain_hp)
  end
  self:setScoreLabelX()
  if fightInfo.starttime ~= self.starttime then
    self.starttime = fightInfo.starttime
    self.tickMg:ClearTick(self)
    self.tickMg:CreateTick(0, 500, self.updateGorgeousMetalTime, self, MainViewClassicPvpFightPage.TickType.GorgeousMetalPvpCount)
  end
end

function MainViewClassicPvpFightPage:updatePvpTime(totalTime, type)
  local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
  local leftTime = totalTime - pastTime
  if leftTime < 0 then
    leftTime = 0
    self.tickMg:ClearTick(self, type)
  end
  leftTime = math.floor(leftTime)
  local m = math.floor(leftTime / 60)
  local mStr = m
  if m < 10 and 0 < m then
    mStr = "0" .. m
  elseif m == 0 then
    mStr = "00"
  end
  local sd = leftTime - m * 60
  local sdStr = sd
  if sd < 10 and 0 < sd then
    sdStr = "0" .. sd
  elseif sd == 0 then
    sdStr = "00"
  end
  leftTime = string.format("%s:%s", mStr, sdStr)
  self.countDownLabel.text = leftTime
end

function MainViewClassicPvpFightPage:updateGorgeousMetalTime()
  self:updatePvpTime(self.GorgeousMetalPvpTotalTime, MainViewClassicPvpFightPage.TickType.GorgeousMetalPvpCount)
end

function MainViewClassicPvpFightPage:updateDesertWolfTime()
  self:updatePvpTime(self.DesertWolfPvpTotalTime, MainViewClassicPvpFightPage.TickType.DesertWolfPvpCountDown)
end
