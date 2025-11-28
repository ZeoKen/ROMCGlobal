MainViewInfoPage = class("MainViewInfoPage", SubView)
autoImport("BaseItemCell")
autoImport("PlayerFaceCell")
autoImport("BuffCell")
autoImport("FloatBuffTip")
local SpecialBuffType = {
  MultiTime = {
    Desc = ZhString.BuffCell_DELeftTimeTip
  },
  MultiExp = {
    Desc = ZhString.BuffCell_OffLineExpLeftTimeTip
  },
  MultiItem = {
    Desc = ZhString.BuffCell_OffLineItemLeftTimeTip
  }
}
local STORAGE_FAKE_ID = "storage_fake_id"
local EmptyBuffData = {id = "EmptyBuff"}

function MainViewInfoPage:Init()
  self:Init_RecallBuffMap()
  self:InitGvgDroiyanTriggerInfo()
  self:InitOthelloTriggerInfo()
  self:FindObjs()
  self:AddViewListen()
  self.buffs = {}
  self.guideList = {}
  self.weak_dialog_queue = {}
  self.isLandscapeLeft = true
  self.effectiveFoodCount = 0
end

local RECALL_BUFF_REFLECT_MAP
local RECALL_BUFF_REWARD_MAP = {}
local recall_buffmap = {}

function MainViewInfoPage:Init_RecallBuffMap()
  RECALL_BUFF_REFLECT_MAP = GameConfig.Recall.reward_buff_reflectshow or _EmptyTable
  local ZhTip_Map = {
    seal = ZhString.MainViewInfoPage_seal,
    board = ZhString.MainViewInfoPage_board,
    laboratory = ZhString.MainViewInfoPage_laboratory,
    tower = ZhString.MainViewInfoPage_tower,
    donate = ZhString.MainViewInfoPage_donate
  }
  local reward_bufflayer = GameConfig.Recall.reward_bufflayer or _EmptyTable
  for k, v in pairs(reward_bufflayer) do
    RECALL_BUFF_REWARD_MAP[v.id] = {
      v.layer,
      ZhTip_Map[k]
    }
  end
end

function MainViewInfoPage:OnEnter()
  self.super.OnEnter(self)
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  EventManager.Me():AddEventListener(SkillEvent.ClearLockTarget, self.HandleSkillClearLockTarget, self)
  self:UpdateAllInfo()
end

function MainViewInfoPage:OnExit()
  self.super.OnExit(self)
  local _TimeTickManager = TimeTickManager.Me()
  _TimeTickManager:ClearTick(self, 1)
  _TimeTickManager:ClearTick(self, 2)
  _TimeTickManager:ClearTick(self, 3)
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  EventManager.Me():RemoveEventListener(SkillEvent.ClearLockTarget, self.HandleSkillClearLockTarget, self)
end

function MainViewInfoPage:FindObjs()
  self.buffDatas = {}
  self.buffListDatas = {}
  self.debuffListDatas = {}
  self.sceneMapName = self:FindComponent("SceneMapName", UILabel)
  self.buffScrollView = self:FindComponent("BuffScrollView", UITable)
  self.buffContainer = self:FindGO("BuffContainer")
  self.buffGrids = self:FindGO("BuffGrids", self.buffContainer):GetComponent(UIGrid)
  self.buffCtl = UIGridListCtrl.new(self.buffGrids, BuffCell, "BuffCell")
  self.buffCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.buffCtl:AddEventListener(BuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.debuffContainer = self:FindGO("DebuffContainer")
  self.debuffGrids = self:FindGO("DebuffGrids", self.debuffContainer):GetComponent(UIGrid)
  self.debuffCtl = UIGridListCtrl.new(self.debuffGrids, BuffCell, "BuffCell")
  self.debuffCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDebuffEvent, self)
  self.debuffCtl:AddEventListener(BuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.foldbord = self:FindChild("foldBord")
  self.foldSymbol = self:FindChild("foldSymbol")
  self.currentLine = self:FindComponent("CurrentLine", UILabel)
  self.objCurrentLine = self:FindGO("WorldLine")
  self.map_currentLine = self:FindComponent("Map_CurrentLine", UILabel)
  self.objMap_currentLine = self:FindGO("Map_WorldLine")
  self:InitSysInfo()
  self.endlessTower = self:FindComponent("EndLessTowerLevel", UILabel)
  self.fullProgress = self:FindGO("FullProgress")
  self:AddClickEvent(self.fullProgress, function(go)
    self:ClickFullProgress()
  end)
  self.eatFoodCount = self:FindComponent("FoodCount", UILabel)
  self.fullProgress_Icon = self:FindComponent("Icon", UISprite, self.fullProgress)
  IconManager:SetSkillIcon("Food_buff", self.fullProgress_Icon)
  self.skillAssist = self:FindGO("SkillAssist")
  self.autoBattleButton = self:FindGO("AutoBattleButton")
  self.autoBattleButton_Ec = self:FindComponent("EC", ChangeRqByTex, self.autoBattleButton)
  self.baseBg = self:FindComponent("BaseBg", UISprite)
  self.jobBg = self:FindComponent("JobBg", UISprite)
end

function MainViewInfoPage:InitSysInfo()
  self.sysTimeLab = self:FindComponent("SysTime", UILabel)
  self.sysTimeLab.skipTranslation = true
  self.batterySlider = self:FindComponent("BatteryPctSlider", UISlider)
  self.batterySlider_Foreground = self:FindComponent("Foreground", UISprite, self.batterySlider.gameObject)
  self.battery_IsCharge = self:FindGO("BatteryChargeSymbol")
  self.wifiSymbols = {}
  self.sysInfoRoot = self.batterySlider.gameObject.transform.parent
  for i = 1, 4 do
    table.insert(self.wifiSymbols, self:FindGO("Wifi" .. i))
  end
  self.weather = self:FindComponent("Weather", UISprite)
  self.infoGrid = self:FindGO("InfoGrid"):GetComponent(UIGrid)
  local weatherid = ServiceWeatherProxy.Instance.weatherID
  local staticData = Table_Weather[weatherid]
  if not staticData or staticData.Icon == "" then
    self.weather.gameObject:SetActive(false)
  else
    local atlas = RO.AtlasMap.GetAtlas("Weather")
    self.weather.atlas = atlas
    self.weather.spriteName = staticData.Icon
    self.weather.gameObject:SetActive(weatherid and weatherid ~= 0)
  end
  self.infoGrid:Reposition()
  if ApplicationInfo.IsRunOnWindowns() then
    self.wifiSymbols[1]:SetActive(false)
    self.batterySlider.gameObject:SetActive(false)
  end
  self.signal = self:FindComponent("Signal", UIMultiSprite)
  self.ping = self:FindComponent("ping", UILabel)
  self.ping.skipTranslation = true
  if not BranchMgr.IsChina() then
    self.signal.gameObject:SetActive(false)
  end
  self.serverTimePanel = self:FindGO("ServerTimePanel")
  self.serverTimeLab = self:FindComponent("ServerTime", UILabel)
  self.serverTimePanel:SetActive(GameConfig.System.ShowServerTime == 1)
end

function MainViewInfoPage:ClickFullProgress()
  TipsView.Me():ShowStickTip(FloatBuffTip, {desc = "", isgain = true}, NGUIUtil.AnchorSide.Right, self.fullProgress_Icon, {0, 0})
end

function MainViewInfoPage:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatBuffTip, {desc = oriDec, isgain = true}, NGUIUtil.AnchorSide.Right, cellCtl.icon, {0, 0})
  end
end

function MainViewInfoPage:ClickDebuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatBuffTip, {desc = oriDec, isgain = false}, NGUIUtil.AnchorSide.Right, cellCtl.icon, {0, 0})
  end
end

function MainViewInfoPage.UpdateBuffTip(data)
  if data == nil then
    return true, "NO DATA"
  end
  if data.storage then
    return true, MainViewInfoPage.GetStorgeDesc(data.storage)
  end
  local staticData = data.staticData
  if staticData == nil then
    return true, "No Buff StaticData"
  end
  local desc, text = staticData.BuffDesc
  if data.fromname and data.fromname ~= "" then
    desc = string.format(desc, data.fromname)
  end
  if data.isRecallBuff then
    local tempArray = {}
    for id, layer in pairs(recall_buffmap) do
      local info = RECALL_BUFF_REWARD_MAP[id]
      table.insert(tempArray, {
        id,
        string.format(info[2], info[1] - layer, info[1])
      })
    end
    table.sort(tempArray, function(a, b)
      return a[1] < b[1]
    end)
    local recall_desc = ""
    for i = 1, #tempArray do
      recall_desc = recall_desc .. tempArray[i][2]
      if i < #tempArray then
        recall_desc = recall_desc .. "\n"
      end
    end
    return true, desc .. recall_desc
  end
  if data.isEquipBuff and desc ~= "" then
    desc = string.gsub(desc, "%[OffingEquipPoses%]", MainViewInfoPage.GetOffingEquipPoses())
    desc = string.gsub(desc, "%[ProtectEquipPoses%]", MainViewInfoPage.GetProtectEquipPoses())
    desc = string.gsub(desc, "%[BreakEquipPoses%]", MainViewInfoPage.GetBreakEquipPoses())
  end
  desc = string.format("%s", desc)
  local betype = staticData.BuffEffect.type
  if SpecialBuffType[betype] then
    if data.active then
      text = string.format("%s%s", staticData.BuffName, ZhString.BuffCell_BuffActive .. [[


]])
    else
      text = string.format("%s%s", staticData.BuffName, ZhString.BuffCell_BuffInActive .. [[


]])
    end
    local leftTime = math.ceil(data.layer / 60)
    if betype == "MultiTime" and ISNoviceServerType then
      extend = string.format("%s%s[-][/c]", colorTip, string.format(ZhString.BuffCell_DELeftTimeTip_Novice, data.layer, ZhString.MainViewInfoPage_Count))
    else
      text = text .. desc .. [[


]] .. string.format(SpecialBuffType[betype].Desc, leftTime)
    end
  else
    if data.isalways then
      return true, desc
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local endtime = data.endtime and data.endtime / 1000
    if endtime then
      if curServerTime > endtime then
        return true, text
      else
        local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(math.floor(endtime - curServerTime))
        local leftStr = ""
        if 0 < day then
          leftStr = day .. ZhString.MainViewInfoPage_Day
        elseif 0 < hour then
          leftStr = hour .. ZhString.MainViewInfoPage_Hour
          leftStr = leftStr .. min .. ZhString.MainViewInfoPage_Min
        else
          if 0 < min then
            leftStr = min .. ZhString.MainViewInfoPage_Min
          end
          leftStr = leftStr .. sec .. ZhString.MainViewInfoPage_Sec
        end
        text = desc .. [[


]] .. string.format(ZhString.MainViewInfoPage_BuffLeftTimeTip, leftStr)
      end
    else
      return true, desc
    end
  end
  return false, text
end

function MainViewInfoPage.GetOffingEquipPoses()
  local offPoses = MyselfProxy.Instance:GetOffingEquipPoses()
  local resultStr = ""
  for i = 1, #offPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(offPoses[i])
    if i < #offPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function MainViewInfoPage.GetProtectEquipPoses()
  local protectPoses = MyselfProxy.Instance:GetProtectEquipPoses()
  local resultStr = ""
  for i = 1, #protectPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(protectPoses[i])
    if i < #protectPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function MainViewInfoPage.GetBreakEquipPoses()
  local breakInfos = BagProxy.Instance.roleEquip:GetBreakEquipSiteInfo()
  local resultStr = ""
  for i = 1, #breakInfos do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(breakInfos[i].index)
    if i < #breakInfos then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function MainViewInfoPage.GetStorgeDesc(storage)
  local desc = ""
  if storage[1] then
    local desc1 = OverSea.LangManager.Instance():GetLangByKey(Table_Buffer[storage[1][1]].BuffDesc)
    desc1 = string.gsub(desc1, "%[HPStorage%]", storage[1][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc1
  end
  if storage[2] then
    local desc2 = OverSea.LangManager.Instance():GetLangByKey(Table_Buffer[storage[2][1]].BuffDesc)
    desc2 = string.gsub(desc2, "%[SPStorage%]", storage[2][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc2
  end
  return desc
end

function MainViewInfoPage.GetHPStorage(data)
  return data.storage or 0
end

function MainViewInfoPage.GetSPStorage(data)
  return data.storage or 0
end

function MainViewInfoPage:UpdateAllInfo()
  self:UpdateJobSlider()
  self:UpdateExpSlider()
  self:UpdateSysInfo()
  if BranchMgr.IsChina() then
    self:UpdateNetDelayInfo()
  end
  self:UpdateCurrentLine()
  self:UpdateFoodCount()
  self.battlePoint = Game.Myself.data.userdata:Get(UDEnum.BATTLEPOINT)
end

function MainViewInfoPage:OnShow()
  self:UpdateBaseJobAnchors()
  local baseGrid = self:FindComponent("BaseExpGrid", UIGrid)
  baseGrid.cellWidth = (self.baseBg.width - 50) / 10
  baseGrid:Reposition()
  local jobGrid = self:FindComponent("JobExpGrid", UIGrid)
  jobGrid.cellWidth = (self.jobBg.width - 50) / 10
  jobGrid:Reposition()
  if self.buffGrids then
    self.buffGrids:Reposition()
  end
  if self.debuffGrids then
    self.debuffGrids:Reposition()
  end
  if self.buffScrollView then
    self.buffScrollView:Reposition()
  end
end

function MainViewInfoPage:UpdateCurrentLine()
  if Game.MapManager:IsPVPMode_MvpFight() or Game.MapManager:IsPVPMode_TeamPws() or Game.MapManager:IsPVPMode_EndlessBattleField() then
    self.objCurrentLine:SetActive(false)
    self.objMap_currentLine:SetActive(false)
    return
  end
  self.objCurrentLine:SetActive(false)
  self.objMap_currentLine:SetActive(true)
  if Game.MapManager:IsPveMode_Arena() then
    local str = ZhString.ChangeZoneProxy_PvpLine
    self.currentLine.text = str
    self.map_currentLine.text = str
    return
  end
  local myzoneId = MyselfProxy.Instance:GetZoneId()
  local str_zoneNum = ChangeZoneProxy.Instance:ZoneNumToString(myzoneId)
  self.currentLine.text = str_zoneNum
  self.map_currentLine.text = str_zoneNum
end

function MainViewInfoPage:UpdateFoodCount()
  local foodList = FoodProxy.Instance:GetEatFoods()
  self.effectiveFoodCount = 0
  if foodList and 0 < #foodList then
    for i = 1, #foodList do
      local food = foodList[i]
      if food.itemid ~= 551019 then
        self.effectiveFoodCount = self.effectiveFoodCount + 1
      end
    end
  end
  if self.effectiveFoodCount > 0 then
    self.eatFoodCount.text = self.effectiveFoodCount
  else
    self.eatFoodCount.text = ""
  end
  if self.effectiveFoodCount > 0 then
  end
  self.fullProgress:SetActive(self.effectiveFoodCount > 0)
end

function MainViewInfoPage:RemoveTimeEndBuff(buffdata)
  self:ResetBuffData()
end

function MainViewInfoPage:AddViewListen()
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
  self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
  self:AddListenEvt(MyselfEvent.ZoneIdChange, self.UpdateCurrentLine)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdateCurrentLine)
  self:AddListenEvt(ServiceEvent.SceneFoodFoodInfoNtf, self.UpdateFoodCount)
  self:AddListenEvt(ServiceEvent.SceneFoodUpdateFoodInfo, self.UpdateFoodCount)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded)
  self:AddListenEvt(MyselfEvent.AddBuffs, self.ResetBuffData)
  self:AddListenEvt(MyselfEvent.RemoveBuffs, self.ResetBuffData)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.ResetBuffData)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePoringFightLaunch)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePoringFightShutdown)
  self:AddListenEvt(PVPEvent.PVP_TransferFightLaunch, self.HandlePoringFightLaunch)
  self:AddListenEvt(PVPEvent.PVP_TransferFightShutDown, self.HandlePoringFightShutdown)
  self:AddListenEvt(PVEEvent.IPRaid_Launch, self.HandleIPRaidLaunch)
  self:AddListenEvt(PVEEvent.IPRaid_Shutdown, self.HandleIPRaidShutdown)
  self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.ClearBuffCache)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleReconnect)
  self:AddListenEvt(ServiceEvent.WeatherWeatherChange, self.UpdateWeather)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(MyselfEvent.ObservationModeStart, self.HandleObservationModeStart)
  self:AddListenEvt(MyselfEvent.ObservationModeEnd, self.HandleObservationModeEnd)
end

function MainViewInfoPage:HandleObservationModeStart()
  self:Hide(self.sysInfoRoot)
  self:Hide(self.baseBg)
  self:Hide(self.jobBg)
  self:Hide(self.buffScrollView)
  self.forceHideExpBar = true
end

function MainViewInfoPage:HandleObservationModeEnd()
  self:Show(self.sysInfoRoot)
  self:Show(self.baseBg)
  self:Show(self.jobBg)
  self:Show(self.buffScrollView)
  self.forceHideExpBar = false
end

function MainViewInfoPage:ClearBuffCache()
  TableUtility.ArrayClear(recall_buffmap)
  self:ResetBuffData()
end

function MainViewInfoPage:UpdateSysInfo()
  local _TimeTickManager = TimeTickManager.Me()
  _TimeTickManager:ClearTick(self, 1)
  _TimeTickManager:CreateTick(0, 1000, function()
    self.sysTimeLab.text = ClientTimeUtil.GetNowHourMinStr()
    if self.serverTimePanel.activeSelf then
      self.serverTimeLab.text = string.format(ZhString.MainViewInfoPage_ServerTime, ClientTimeUtil.GetServerHourMinStr(), ServerTime.SERVER_TIMEZONE)
    end
  end, self, 1)
  if ApplicationInfo.IsRunOnWindowns() then
    return
  end
  _TimeTickManager:ClearTick(self, 2)
  _TimeTickManager:CreateTick(0, 30000, function()
    local btvalue = ExternalInterfaces.GetSysBatteryPct() / 100
    self.batterySlider.value = btvalue
    if btvalue <= 0.1 then
      self.batterySlider_Foreground.color = LuaGeometry.GetTempColor(0.6784313725490196, 0 / 255, 0 / 255, 1)
    else
      self.batterySlider_Foreground.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    end
    local isCharge = ExternalInterfaces.GetSysBatteryIsCharge()
    self.battery_IsCharge:SetActive(isCharge)
  end, self, 2)
end

local LowDelayCol = "5de36a"
local MidDelayCol = "ff8543"
local HighDelayCol = "f42828"
local pingNetDelay
local totalNetDelay = 0
local totalPingCount = 0

function MainViewInfoPage:UpdateNetDelayInfo()
  local socketInfo = FunctionGetIpStrategy.Me():getCurrentSocketInfo()
  local ip = socketInfo and socketInfo.ip
  if not ip then
    local serverData = FunctionLogin.Me():getCurServerData()
    ip = serverData and serverData.serverip and serverData.serverip[1] or ""
  end
  redlog("UpdateNetDelayInfo ip", tostring(ip))
  local getPingAction = function(isDone, time)
    if isDone then
      time = 0 <= time and time or 999
      totalNetDelay = totalNetDelay + time
      totalPingCount = totalPingCount + 1
      pingNetDelay = totalNetDelay // totalPingCount
      if 10 <= totalPingCount then
        totalPingCount = 0
        totalNetDelay = 0
      end
    end
  end
  local interval = GameConfig.NetDelay and GameConfig.NetDelay.PingInterval and GameConfig.NetDelay.PingInterval * 1000 or 1000
  TimeTickManager.Me():CreateTick(0, interval, function(owner)
    InternetUtil.Ins:GetPing(ip, getPingAction, 5)
    owner:ShowPing()
  end, self, 3)
end

function MainViewInfoPage:ShowPing()
  local delay = pingNetDelay or 999
  local maxDelay = GameConfig.NetDelay and GameConfig.NetDelay.Max and GameConfig.NetDelay.Max or 999
  delay = math.min(delay, maxDelay)
  self.ping.text = orginStringFormat("%2d", delay) .. "ms"
  local color
  local lowDelay = GameConfig.NetDelay and GameConfig.NetDelay.Low and GameConfig.NetDelay.Low or 60
  local highDelay = GameConfig.NetDelay and GameConfig.NetDelay.High and GameConfig.NetDelay.High or 120
  if 0 <= delay and delay <= lowDelay then
    self.signal.CurrentState = 2
    _, color = ColorUtil.TryParseHexString(LowDelayCol)
  elseif delay > lowDelay and delay <= highDelay then
    self.signal.CurrentState = 1
    _, color = ColorUtil.TryParseHexString(MidDelayCol)
  else
    self.signal.CurrentState = 0
    _, color = ColorUtil.TryParseHexString(HighDelayCol)
  end
  self.ping.color = color
end

function MainViewInfoPage:HandleMapLoaded(note)
  self:HandleSceneMapName(note)
end

function MainViewInfoPage:HandleMapLoaded(note)
  self:HandleSceneMapName(note)
end

local MapManager = Game.MapManager

function MainViewInfoPage:HandleSceneMapName(note)
  if MapManager:IsRaidMode() then
    local mapid = MapManager:GetMapID()
    local raidData = Table_MapRaid[mapid]
    if raidData then
      if raidData.Type == FunctionDungen.EndlessTowerType then
        self:Show(self.sceneMapName)
        self.sceneMapName.text = Game.MapManager:GetMapName()
        return
      elseif raidData.Type == FunctionDungen.DojoType then
        self:Show(self.sceneMapName)
        self.sceneMapName.text = raidData.NameZh
        return
      end
    end
  end
  self:Hide(self.sceneMapName)
end

function MainViewInfoPage:UpdateExpSlider(note)
  if not self.roleSlider then
    self.roleSlider = self:FindComponent("BaseExpSlider", UISlider)
  end
  local userdata = Game.Myself.data.userdata
  local roleExp = userdata:Get(UDEnum.ROLEEXP)
  local nowrolelv = userdata:Get(UDEnum.ROLELEVEL)
  if nowrolelv then
    local upExp = 1
    if Table_BaseLevel[nowrolelv + 1] ~= nil then
      upExp = Table_BaseLevel[nowrolelv + 1].NeedExp
    end
    self.roleSlider.value = roleExp / upExp
  end
end

local tempColor = LuaColor(1, 1, 1, 1)

function MainViewInfoPage:UpdateJobSlider(note)
  if not self.jobSlider then
    self.jobSlider = self:FindComponent("JobExpSlider", UISlider)
  end
  local userdata = Game.Myself.data.userdata
  local jobExp = userdata:Get(UDEnum.JOBEXP)
  local nowJobLevel = userdata:Get(UDEnum.JOBLEVEL)
  if nowJobLevel then
    local referenceValue = Table_JobLevel[nowJobLevel + 1]
    if MyselfProxy.Instance:IsHero() then
      referenceValue = referenceValue and referenceValue.HeroJobExp
    else
      referenceValue = referenceValue and referenceValue.JobExp
    end
    referenceValue = referenceValue == nil and 1 or referenceValue
    self.jobSlider.value = jobExp / referenceValue
    if not self.jobSliderSps then
      self.jobSliderSps = {}
      local jobBg = self:FindGO("JobBg")
      for i = 1, 9 do
        table.insert(self.jobSliderSps, self:FindComponent(tostring(i), UISprite, jobBg))
      end
    end
    for i = 1, #self.jobSliderSps do
      local sp = self.jobSliderSps[i]
      if self.jobSlider.value >= i * 0.1 then
        sp.color = tempColor
      else
        sp.color = tempColor
      end
    end
  end
end

function MainViewInfoPage._SortBuffData(a, b)
  local topBuff = GameConfig.GvgNewConfig.unactive_buffid
  if a.id == topBuff or b.id == topBuff then
    return a.id == topBuff
  end
  if a.endtime and b.endtime then
    if a.endtime and b.endtime then
      return a.endtime < b.endtime
    end
  else
    return a.endtime ~= nil
  end
  local aBuffCfg = Table_Buffer[a.id]
  local bBuffCfg = Table_Buffer[b.id]
  if aBuffCfg and bBuffCfg and aBuffCfg.IconType and bBuffCfg.IconType and aBuffCfg.IconType ~= bBuffCfg.IconType then
    return aBuffCfg.IconType > bBuffCfg.IconType
  end
  if a.isalways ~= nil or b.isalways ~= nil then
    return a.isalways == true
  end
  if a.id == STORAGE_FAKE_ID or b.id == STORAGE_FAKE_ID then
    return a.id == STORAGE_FAKE_ID
  end
  return a.id < b.id
end

function MainViewInfoPage:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  TableUtility.ArrayClear(self.debuffListDatas)
  TableUtility.ArrayShallowCopy(self.buffListDatas, FunctionBuff.Me():GetMyBuff(true, true))
  TableUtility.ArrayShallowCopy(self.debuffListDatas, FunctionBuff.Me():GetMyBuff(false, true))
  table.sort(self.buffListDatas, MainViewInfoPage._SortBuffData)
  table.sort(self.debuffListDatas, MainViewInfoPage._SortBuffData)
  local limit = 7 - (self.effectiveFoodCount > 0 and 1 or 0)
  if limit < #self.buffListDatas then
    for i = #self.buffListDatas, limit + 1, -1 do
      table.remove(self.buffListDatas, i)
    end
    TableUtility.ArrayPushBack(self.buffListDatas, EmptyBuffData)
  end
  self.buffCtl:ResetDatas(self.buffListDatas)
  local debufflimit = 3
  if debufflimit < #self.debuffListDatas then
    for i = #self.debuffListDatas, debufflimit + 1, -1 do
      table.remove(self.debuffListDatas, i)
    end
    TableUtility.ArrayPushBack(self.debuffListDatas, EmptyBuffData)
  end
  self.debuffCtl:ResetDatas(self.debuffListDatas)
  self.buffScrollView:Reposition()
end

local PoringFight_ForbidView = {
  1,
  4,
  181,
  320,
  400,
  101,
  480,
  520,
  720,
  920,
  83,
  11,
  351,
  352,
  354
}

function MainViewInfoPage:HandlePoringFightLaunch(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:SetForbidView(PoringFight_ForbidView[i], 3606, true)
  end
  self.fullProgress:SetActive(false)
  self.skillAssist:SetActive(false)
  self.autoBattleButton:SetActive(false)
end

function MainViewInfoPage:HandlePoringFightShutdown(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:UnSetForbidView(PoringFight_ForbidView[i])
  end
  self.fullProgress:SetActive(true)
  self.skillAssist:SetActive(true)
  self.autoBattleButton:SetActive(true)
end

function MainViewInfoPage:HandleIPRaidLaunch(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:SetForbidView(PoringFight_ForbidView[i], 3606, true)
  end
  self.fullProgress:SetActive(false)
end

function MainViewInfoPage:HandleIPRaidShutdown(note)
  for i = 1, #PoringFight_ForbidView do
    UIManagerProxy.Instance:UnSetForbidView(PoringFight_ForbidView[i])
  end
  self.fullProgress:SetActive(true)
end

function MainViewInfoPage:InitGvgDroiyanTriggerInfo()
  self:AddListenEvt(TriggerEvent.Enter_GDFightForArea, self.HandleEnterGDFightforArea)
  self:AddListenEvt(TriggerEvent.Leave_GDFightForArea, self.HandleLeaveOrRemoveGDFightforArea)
  self:AddListenEvt(TriggerEvent.Remove_GDFightForArea, self.HandleLeaveOrRemoveGDFightforArea)
end

function MainViewInfoPage:GetGvgDroiyanOccupyInfoCell()
  if self.gvg_OccupyInfoCell ~= nil then
    return self.gvg_OccupyInfoCell
  end
  local obj = self:LoadPreferb("cell/GvgDroiyan_OccupyInfoCell", self.gameObject)
  if GvgDroiyan_OccupyInfoCell == nil then
    autoImport("GvgDroiyan_OccupyInfoCell")
  end
  self.gvg_OccupyInfoCell = GvgDroiyan_OccupyInfoCell.new(obj)
  return self.gvg_OccupyInfoCell
end

function MainViewInfoPage:HandleEnterGDFightforArea(note)
  local id = note.body
  if id == nil then
    return
  end
  local occupyInfoCell = self:GetGvgDroiyanOccupyInfoCell()
  occupyInfoCell:SetData(id)
end

function MainViewInfoPage:HandleLeaveOrRemoveGDFightforArea(note)
  local occupyInfoCell = self:GetGvgDroiyanOccupyInfoCell()
  occupyInfoCell:HideSelf()
end

function MainViewInfoPage:HandleBooth(note)
end

function MainViewInfoPage:HandleReconnect(note)
  if Game.Myself:IsInBooth() then
    BoothProxy.Instance:ClearMyselfBooth()
  end
end

function MainViewInfoPage:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  self.isLandscapeLeft = note.data
  self:OnShow()
end

function MainViewInfoPage:HandleSkillClearLockTarget(note)
  local creature = note and note.data
  if not creature then
    return
  end
  local npcId = creature.data and creature.data:GetNpcID()
  if npcId then
    local myself = Game.Myself
    local lockids = myself:Client_GetAutoBattleLockIDs()
    local nowTarget = Game.Myself:GetLockTarget()
    if nowTarget and nowTarget.data.GetNpcID and nowTarget.data:GetNpcID() == npcId then
      Game.Myself:Logic_SetAttackTarget(nil)
      Game.Myself:Client_LockTarget(nil)
      FunctionSystem.InterruptMyself(true)
    end
    if lockids and lockids[npcId] then
      myself:Client_UnSetAutoBattleLockID(npcId)
      self:sendNotification(EmojiEvent.PlayEmoji, {
        roleid = myself.data.id,
        emoji = 1
      })
      ServiceNUserProxy.Instance:CallUserActionNtf(myself.data.id, 1, SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION)
      MsgManager.ShowMsgByID(43261)
      self:PlayUIEffect(EffectMap.UI.AutoBattleBreak, self.autoBattleButton_Ec)
    end
  end
end

function MainViewInfoPage:UpdateBaseJobAnchors()
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    self.baseBg:ResetAndUpdateAnchors()
    self.jobBg:ResetAndUpdateAnchors()
    return
  end
  local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  local hasMobileScreenAdaption = SafeArea.on and l ~= nil and (l ~= 0 or r ~= 0)
  if hasMobileScreenAdaption then
    self.baseBg.leftAnchor.absolute = r
    self.jobBg.rightAnchor.absolute = -l
    local anchorDownOffset = (r - l) / 2
    self.baseBg.rightAnchor.absolute = 3 + anchorDownOffset
    self.jobBg.leftAnchor.absolute = -3 + anchorDownOffset
  end
  self.baseBg.anchorsCached = false
  self.jobBg.anchorsCached = false
  self.baseBg:Update()
  self.jobBg:Update()
  if hasMobileScreenAdaption then
    UIUtil.ResetAndUpdateAllAnchors(self.baseBg.gameObject)
    UIUtil.ResetAndUpdateAllAnchors(self.jobBg.gameObject)
  end
  self.baseBg.gameObject:SetActive(false)
  self.jobBg.gameObject:SetActive(false)
  if not self.forceHideExpBar then
    self.baseBg.gameObject:SetActive(true)
    self.jobBg.gameObject:SetActive(true)
  end
end

function MainViewInfoPage:UpdateWeather()
  local weatherid = ServiceWeatherProxy.Instance.weatherID
  local staticData = Table_Weather[weatherid]
  if not staticData or staticData.Icon == "" then
    self.weather.gameObject:SetActive(false)
  else
    local atlas = RO.AtlasMap.GetAtlas("Weather")
    self.weather.atlas = atlas
    self.weather.gameObject:SetActive(weatherid and weatherid ~= 0)
    self.weather.spriteName = staticData.Icon
  end
  self.infoGrid:Reposition()
end

function MainViewInfoPage:UpdateDayNight()
  if self.daynightick then
    TimeTickManager.Me():ClearTick(self, 101)
  end
  if self.daynight then
    self.daynightick = TimeTickManager.Me():CreateTick(0, 1000, function()
      self.daynight.text = ServerTime.GetDayOrNightString()
    end, self, 101)
  end
end

function MainViewInfoPage:InitOthelloTriggerInfo()
  self:AddListenEvt(TriggerEvent.Enter_OthelloCheckpoint, self.HandleEnterOthelloCheckpoint)
  self:AddListenEvt(TriggerEvent.Leave_OthelloCheckpoint, self.HandleLeaveOrRemoveOthelloCheckpoint)
  self:AddListenEvt(TriggerEvent.Remove_OthelloCheckpoint, self.HandleLeaveOrRemoveOthelloCheckpoint)
end

function MainViewInfoPage:GetOthelloOccupyInfoCell()
  if self.othello_OccupyInfoCell then
    return self.othello_OccupyInfoCell
  end
  local obj = self:LoadPreferb("cell/OthelloOccupyInfoCell", self.gameObject)
  if not OthelloOccupyInfoCell then
    autoImport("OthelloOccupyInfoCell")
  end
  self.othello_OccupyInfoCell = OthelloOccupyInfoCell.new(obj)
  return self.othello_OccupyInfoCell
end

function MainViewInfoPage:HandleEnterOthelloCheckpoint(note)
  local id = note.body
  if id == nil then
    return
  end
  local occupyInfoCell = self:GetOthelloOccupyInfoCell()
  occupyInfoCell:SetData(id)
end

function MainViewInfoPage:HandleLeaveOrRemoveOthelloCheckpoint(note)
  local occupyInfoCell = self:GetOthelloOccupyInfoCell()
  occupyInfoCell:HideSelf()
end

function MainViewInfoPage:HandleHideUIUserCmd(note)
  local data = note.body
  local ui = data.ui
  local on = data.open
  if on and on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 2) > 0 then
      self.buffContainer:SetActive(false)
      self.debuffContainer:SetActive(false)
    end
  else
    self.buffContainer:SetActive(true)
    self.debuffContainer:SetActive(true)
  end
end
