BossView = class("BossView", BaseView)
autoImport("BossCell")
autoImport("BaseItemCell")
BossView.ViewType = UIViewType.NormalLayer
BossFliterOptIndex = {
  All = 1,
  Mvp = 2,
  Mini = 3,
  Death = 4
}
BossFliterOpt = {
  ZhString.BossView_All,
  "Mvp",
  "Mini"
}
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local deathBossHelpId = 640
local tickManager
local TopContainerHeight = {
  [1] = 318,
  [2] = 257
}
local ScollviewConfig = {
  [1] = {
    posY = 0,
    offsetY = 0,
    sizeY = 594
  },
  [2] = {
    posY = -30,
    offsetY = 36,
    sizeY = 530
  }
}
local MaxMVP, MaxMini

function BossView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitView()
  self:MapViewListen()
  self.tipOffset = {300, 60}
  self.playerTipData = {}
end

local tempArgs = {}

function BossView:InitView()
  self:InitFakeToggles()
  self.listbg = self:FindGO("listBg"):GetComponent(UITexture)
  self.bossLoading = self:FindGO("BossLoadingRoot")
  self.bossTexture = self:FindComponent("BossTexture", UITexture)
  self.bossname = self:FindComponent("BossName", UILabel)
  self.bossElement = self:FindComponent("BossElement", UISprite)
  local bossInfo = self:FindGO("BossInfo")
  self.bossPosition = self:FindComponent("position", UILabel, bossInfo)
  self.bossDesc = self:FindComponent("Desc", UILabel, bossInfo)
  self.chooseSymbol = self:FindGO("BossChooseSymbol")
  local gobutton = self:FindGO("goButton")
  self:AddClickEvent(gobutton, function(go)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
    elseif self.chooseBoss ~= nil then
      TableUtility.TableClear(tempArgs)
      tempArgs.targetMapID = self.chooseBoss.mapid
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
      if cmd then
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      self:CloseSelf()
    end
  end)
  local container = self:FindGO("BossWrap")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "BossCell",
    control = BossCell,
    dir = 1
  }
  self.bosslist = WrapCellHelper.new(wrapConfig)
  self.bosslist:AddEventListener(MouseEvent.MouseClick, self.ClickBossCell, self)
  self.listbg.gameObject:SetActive(false)
  self:QueryMVPBoss()
  self.helpBtn = self:FindGO("helpBtn")
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.DeadBoss
  local deadBossOpen = menuid ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(menuid) == true
  self:ActiveDeadBossTog(deadBossOpen)
  self:RegistShowGeneralHelpByHelpID(deathBossHelpId, self.helpBtn, deadBossOpen and FunctionUnLockFunc.checkFuncStateValid(116))
  self.specialRewardRatio = self:FindComponent("SpecialRewardRatio", UILabel)
  self.bossScrollPanel = self:FindComponent("BossScroll", UIPanel)
  self.bossScrollGO = self:FindGO("Scrolls")
  self.limitContainer = self:FindGO("LimitContainer")
  self.limitLabel = self:FindComponent("LimitLabel", UILabel)
  self.mvpLimitLabel = self:FindComponent("MVPLimitLabel", UILabel)
  self.miniLimitLabel = self:FindComponent("MiniLimitLabel", UILabel)
  self.topContainer = self:FindGO("TopContainer")
  if ISNoviceServerType then
    self.limitContainer:SetActive(true)
    self.bossScrollGO.transform.localPosition = LuaGeometry.GetTempVector3(0, ScollviewConfig[2].posY, 0)
    local clipOffset = self.bossScrollPanel.clipOffset
    clipOffset[2] = ScollviewConfig[2].offsetY
    self.bossScrollPanel.clipOffset = clipOffset
    self.limitLabel.text = ZhString.BossView_Limit
    self.bossScrollPanel:SetRect(self.bossScrollPanel.baseClipRegion.x, self.bossScrollPanel.baseClipRegion.y, self.bossScrollPanel.baseClipRegion.z, ScollviewConfig[2].sizeY)
    self.topContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, TopContainerHeight[2], 0)
    self:SetLimitData()
  else
    self.limitContainer:SetActive(false)
    self.bossScrollGO.transform.localPosition = LuaGeometry.GetTempVector3(0, ScollviewConfig[1].posY, 0)
    local clipOffset = self.bossScrollPanel.clipOffset
    clipOffset[2] = ScollviewConfig[1].offsetY
    self.bossScrollPanel.clipOffset = clipOffset
    self.bossScrollPanel:SetRect(self.bossScrollPanel.baseClipRegion.x, self.bossScrollPanel.baseClipRegion.y, self.bossScrollPanel.baseClipRegion.z, ScollviewConfig[1].sizeY)
    self.topContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, TopContainerHeight[1], 0)
  end
end

function BossView:SetLimitData()
  if not ISNoviceServerType then
    return
  end
  local mvpNum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_DAY_MVP_COUNT) or 0
  local miniNum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_DAY_MINI_COUNT) or 0
  MaxMVP = GameConfig.MvpLimit.MvpRewardTimes
  MaxMini = GameConfig.MvpLimit.MiniRewardTimes
  self.mvpLimitLabel.text = string.format(ZhString.BossView_LimitCount, mvpNum, MaxMVP or 5)
  self.miniLimitLabel.text = string.format(ZhString.BossView_LimitCount, miniNum, MaxMini or 10)
end

function BossView:InitFakeToggles()
  local fakeToggleGO = self:FindGO("FakeToggles")
  self.fakeToggle_Sprite = self:FindGO("ToggleBg", fakeToggleGO):GetComponent(UISprite)
  self.toggleGrid = self:FindGO("ToggleGrid", fakeToggleGO):GetComponent(UIGrid)
  self.deadTogSp = self:FindComponent("DeadBossTog", UISprite)
  local deadBossForbid = FunctionUnLockFunc.CheckForbiddenByFuncState("deadboss_forbidden")
  self.deadTogSp.gameObject:SetActive(not deadBossForbid)
  self.fakeToggle_Sprite.width = deadBossForbid and 174 or 240
  if not deadBossForbid then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_DEAD_BOSS, self.deadTogSp.gameObject, 26, {25, 20})
  end
  self.miniTogSp = self:FindComponent("MiniTog", UISprite)
  self.deadCheckmark = self:FindGO("DeadBossCheckmark")
  self.mvpCheckmark = self:FindGO("MvpCheckmark")
  self.miniCheckmark = self:FindGO("MiniCheckmark")
  self:AddClickEvent(self.deadTogSp.gameObject, function()
    self:OnClickDeadTog()
  end)
  self:AddButtonEvent("MvpTog", function()
    self:OnClickMvpTog()
  end)
  self:AddClickEvent(self.miniTogSp.gameObject, function()
    self:OnClickMiniTog()
  end)
end

function BossView:QueryMVPBoss()
  ServiceBossCmdProxy.Instance:CallBossListUserCmd()
end

local currentMonsterLv = 1

function BossView:ClickBossCell(cellctl, forceUpdate)
  local data = cellctl and cellctl.data
  if data then
    self.chooseBoss = data
    currentMonsterLv = data.lv
    if self.chooseId ~= data.id or self.chooseMap ~= data.mapid or forceUpdate == true then
      self:UpdateBossInfo(data)
      local isSpecial = cellctl.isSpecial and GameConfig.CommuteBoss ~= nil
      local isShow = isSpecial and (GameConfig.CommuteBoss.isopen and GameConfig.CommuteBoss.isopen > 0 or false)
      self.specialRewardRatio.gameObject:SetActive(isShow)
      if isShow then
        self.specialRewardRatio.text = string.format("%s%%", GameConfig.CommuteBoss.mvpdead_ratio * 100)
      end
      self.chooseId = data.id
      self.chooseMap = data.mapid
      for _, cell in pairs(self.bossCells) do
        cell:SetChoose(self.chooseId, self.chooseMap)
      end
    else
      self.chooseId = 0
      self.chooseMap = 0
    end
  end
end

function BossView:UpdateBossList(force)
  if self.mvplist == nil then
    helplog("BossList is nil!")
    return
  end
  self.datas = self.datas or {}
  TableUtility.TableClear(self.datas)
  self.bosslist:ResetPosition()
  self.listbg.gameObject:SetActive(false)
  if self.mvpCheckmark.activeSelf then
    TableUtility.ArrayShallowCopy(self.datas, self.mvplist)
  elseif self.deadCheckmark.activeSelf and self.deathlist and #self.deathlist ~= 0 then
    self.listbg.gameObject:SetActive(true)
    TableUtility.ArrayShallowCopy(self.datas, self.deathlist)
  elseif self.miniCheckmark.activeSelf and self.minilist then
    for i = 1, #self.minilist do
      table.insert(self.datas, self.minilist[i])
    end
  else
    TableUtility.TableClear(self.datas)
  end
  if force then
    local favoriteMap = ServiceBossCmdProxy.Instance.favoriteMap or {}
    local tempV = 0
    for i = 1, #self.datas do
      tempV = favoriteMap[self.datas[i].id] or 0
      self.datas[i].ispreference = tempV
    end
  end
  table.sort(self.datas, BossView.BossSortFunc)
  self.bosslist:UpdateInfo(self.datas, true)
  if self.bossCells == nil then
    self.bossCells = self.bosslist:GetCellCtls()
  end
  if self.currentCellID then
    for i = 1, #self.bossCells do
      if self.currentCellID == self.bossCells[i].data.id then
        self:ClickBossCell(self.bossCells[i], true)
        break
      end
    end
  else
    self:ClickBossCell(self.bossCells[1], true)
  end
  for i = 1, #self.bossCells do
    self.bossCells[i]:SetView(self)
  end
end

function BossView.BossSortFunc(a, b)
  if a.ispreference == b.ispreference then
    if a.priority == b.priority then
      local bossA = Table_Boss[a.id]
      local bossB = Table_Boss[b.id]
      local monsterA = Table_Monster[a.id]
      local monsterB = Table_Monster[b.id]
      if bossA.MvpID and bossA.Type == 3 then
        monsterA = Table_Monster[bossA.MvpID]
      end
      if bossB.MvpID and bossB.Type == 3 then
        monsterB = Table_Monster[bossB.MvpID]
      end
      local levela = monsterA.Level
      local levelb = monsterB.Level
      if levela ~= levelb then
        return levela < levelb
      end
      local isAMvp = monsterA.Type == "MVP"
      local isBMvp = monsterB.Type == "MVP"
      if isAMvp ~= isBMvp then
        return isAMvp
      end
      return a.id < b.id
    else
      return a.priority > b.priority
    end
  else
    return a.ispreference > b.ispreference
  end
end

function BossView:UpdateBossInfo(data)
  local bossStaticdata = data.staticData
  self.bossname.text = bossStaticdata.NameZh
  local mapid = data.mapid or bossStaticdata.Map
  local mapIds = {}
  if type(mapid) == "number" then
    table.insert(mapIds, mapid)
  elseif type(mapid) == "table" then
    mapIds = mapid
  end
  local posDesc = ""
  for i = 1, #mapIds do
    local id = mapIds[i]
    if Table_Map[id] then
      posDesc = Table_Map[id].CallZh
    end
    if i < #mapIds then
      posDesc = posDesc .. ", "
    end
  end
  self.bossPosition.text = string.format(ZhString.Boss_AppearPosition, posDesc)
  local mdata
  mdata = Table_Monster[bossStaticdata.id]
  local deadreward = {}
  if bossStaticdata.Type ~= 3 then
    deadreward = mdata.Dead_Reward
  else
    local deadbossCfg = Game.Config_Deadboss[bossStaticdata.id]
    deadbossCfg = deadbossCfg and deadbossCfg[data.lv]
    if deadbossCfg then
      TableUtility.ArrayShallowCopy(deadreward, deadbossCfg.Dead_Reward)
      local extraReward = deadbossCfg.ExtraReward
      for i = 1, #extraReward do
        TableUtility.ArrayPushBack(deadreward, extraReward[i])
      end
    else
      return
    end
  end
  local dropItems = {}
  if deadreward then
    local funcStateId, bannedItemIds, id = 115
    if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
      bannedItemIds = Table_FuncState[funcStateId] and Table_FuncState[funcStateId].ItemID
    end
    for k, v in pairs(deadreward) do
      local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(v)
      for _, data in pairs(rewardTeamids) do
        id = data.id
        if not bannedItemIds or not (TableUtility.ArrayFindIndex(bannedItemIds, id) > 0) then
          local item = ItemData.new("Reward", id)
          item.num = data.num
          local iStaticdata = item.staticData
          if iStaticdata and iStaticdata.MonsterLevel and iStaticdata.MonsterLevel > currentMonsterLv then
            item.needLocker = true
          else
            item.needLocker = false
          end
          table.insert(dropItems, item)
        end
      end
    end
  end
  table.sort(dropItems, function(a, b)
    if a.staticData and b.staticData then
      if a.staticData.Quality == nil then
        helplog(a.staticData.NameZh .. " no quality!")
      end
      return a.staticData.Quality > b.staticData.Quality
    else
      return false
    end
  end)
  if self.drop == nil then
    local dropScrollObj = self:FindGO("DropItemScroll")
    self.dropScroll = dropScrollObj:GetComponent(UIScrollView)
    local dropGrid = self:FindGO("Grid", dropScrollObj):GetComponent(UIGrid)
    self.drop = UIGridListCtrl.new(dropGrid, BaseItemCell, "DropItemCell")
    self.drop:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  end
  self.dropScroll:ResetPosition()
  self.drop:ResetDatas(dropItems)
  self.bossDesc.text = mdata.Desc
  UIUtil.WrapLabel(self.bossDesc)
  self:UpdateBossAgent(mdata, data.bosstype)
  self.bossElement.spriteName = ""
end

function BossView:ClickDropItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponentInChildren(UISprite)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local iStaticdata = data.staticData
      local locker = false
      if iStaticdata and iStaticdata.MonsterLevel and iStaticdata.MonsterLevel > currentMonsterLv then
        locker = true
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        },
        needLocker = locker
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChoose()
  end
end

function BossView:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end

local monsterPos = LuaVector3()

function BossView:UpdateBossAgent(monsterData, bosstype)
  UIModelUtil.Instance:ResetTexture(self.bossTexture)
  if bosstype == 3 then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing_1", self.bossTexture)
  else
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.bossTexture)
  end
  UIModelUtil.Instance:SetMonsterModelTexture(self.bossTexture, monsterData.id, nil, nil, function(obj)
    local model = obj
    local showPos = monsterData.LoadShowPose
    LuaVector3.Better_Set(monsterPos, showPos[1], showPos[2], showPos[3])
    model:SetPosition(monsterPos)
    model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
    local size = monsterData.LoadShowSize or 1
    model:SetScale(size)
  end)
end

function BossView:MapViewListen()
  self:AddListenEvt(ServiceEvent.BossCmdBossListUserCmd, self.HandleBosslstUpdate)
  self:AddListenEvt(ServiceEvent.BossCmdQueryKillerInfoBossCmd, self.OnRecvQueryKillerInfoBoss)
  self:AddListenEvt(ServiceEvent.BossCmdQueryFavaouiteBossCmd, self.HandleBosslstUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.SetLimitData)
end

function BossView:HandleBosslstUpdate(note)
  if note then
    local bossDatas = note.body
    self.mvplist = bossDatas[1]
    self.minilist = bossDatas[2]
    self.deathlist = bossDatas[3]
  end
  self:UpdateBossList()
end

local activeSpColor = LuaColor.New(0.3215686274509804, 0.4392156862745098, 0.7529411764705882)
local activeTog = function(togSp, checkmark, b)
  b = b and true or false
  togSp.color = b and activeSpColor or ColorUtil.TitleGray
  if not b then
    checkmark:SetActive(false)
  end
end

function BossView:ActiveDeadBossTog(b)
  self.deadTogEnabled = b
  activeTog(self.deadTogSp, self.deadCheckmark, b)
end

function BossView:ActiveMiniTog(b)
  self.miniTogEnabled = b
  activeTog(self.miniTogSp, self.miniCheckmark, b)
end

function BossView:OnClickCellKillerName(cell)
  FunctionPlayerTip.Me():CloseTip()
  local id = cell.killerID
  if not id or 0 == id then
    return
  end
  self.queryCell = cell
  local data = self.playerTipData[id]
  if data then
    self:ShowPlayerTip(data)
  else
    self.bossLoading:SetActive(true)
    ServiceBossCmdProxy.Instance:CallQueryKillerInfoBossCmd(id)
    tickManager:CreateOnceDelayTick(10000, function(self)
      if self.bossLoading.gameObject then
        self.bossLoading:SetActive(false)
      end
    end, self, 3)
  end
end

function BossView:OnClickCellFavoriteBtn(cell)
  if not cell then
    return
  end
  local id = cell.data.id
  self.currentCellID = id
  self:ClickBossCell(cell)
  if not id or 0 == id then
    return
  end
  local wasFavorite = cell:IsFavorite()
  local msgId = wasFavorite and 40578 or 40577
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(msgId)
  local favoriteMap = ServiceBossCmdProxy.Instance.favoriteMap
  if not dont then
    MsgManager.DontAgainConfirmMsgByID(msgId, function()
      cell:NegateFavoriteTip()
      local newFavorite = cell:GetFavoriteTipActive()
      if wasFavorite ~= newFavorite then
        favoriteMap[id] = newFavorite and 1 or 0
      end
      self:UpdateBossList(true)
    end)
  else
    cell:NegateFavoriteTip()
    local newFavorite = cell:GetFavoriteTipActive()
    if wasFavorite ~= newFavorite then
      favoriteMap[id] = newFavorite and 1 or 0
    end
    self:UpdateBossList(true)
  end
end

function BossView:OnClickDeadTog()
  if not self.deadTogEnabled then
    MsgManager.ShowMsgByID(26123)
    return
  end
  self.deadCheckmark:SetActive(true)
  self.mvpCheckmark:SetActive(false)
  self.miniCheckmark:SetActive(false)
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_DEAD_BOSS)
  self:OnceDelayAction(20, self.UpdateBossList)
end

function BossView:OnClickMvpTog()
  self.deadCheckmark:SetActive(false)
  self.mvpCheckmark:SetActive(true)
  self.miniCheckmark:SetActive(false)
  self:OnceDelayAction(20, self.UpdateBossList)
end

function BossView:OnClickMiniTog()
  if not self.miniTogEnabled then
    MsgManager.ShowMsgByID(581)
    return
  end
  self.deadCheckmark:SetActive(false)
  self.mvpCheckmark:SetActive(false)
  self.miniCheckmark:SetActive(true)
  self:OnceDelayAction(20, self.UpdateBossList)
end

function BossView:OnRecvQueryKillerInfoBoss(note)
  tickManager:ClearTick(self, 3)
  self.bossLoading:SetActive(false)
  local id = note.body and note.body.charid
  if not id or id == 0 then
    MsgManager.ShowMsgByID(5030)
    return
  end
  local player = PlayerTipData.new()
  player:SetByBossKillerData(note.body)
  local tipData = ReusableTable.CreateTable()
  tipData.playerData = player
  tipData.funckeys = FriendProxy.Instance:IsFriend(id) and playerTipFunc_Friend or playerTipFunc
  if self.playerTipData[id] then
    ReusableTable.DestroyTable(self.playerTipData[id])
  end
  self.playerTipData[id] = tipData
  if self.queryCell.killerID == id then
    self:ShowPlayerTip(tipData)
  end
end

function BossView:ShowPlayerTip(data)
  FunctionPlayerTip.Me():CloseTip()
  FunctionPlayerTip.Me():GetPlayerTip(self.queryCell.icon, NGUIUtil.AnchorSide.Right, self.tipOffset, data)
end

function BossView:ClearPlayerTipDatas()
  for k, v in pairs(self.playerTipData) do
    if v then
      ReusableTable.DestroyAndClearTable(v)
    end
  end
end

function BossView:OnEnter()
  BossView.super.OnEnter(self)
  self:OnClickMvpTog()
  self:ActiveMiniTog(NewRechargeProxy.Ins:AmIMonthlyVIP())
  PictureManager.Instance:SetUI("ui_mvp_dead7_JM", self.listbg)
end

function BossView:OnExit()
  self:ClearPlayerTipDatas()
  self:TrySendFavorite()
  if self.bossCells then
    for i = 1, #self.bossCells do
      self.bossCells[i]:OnExit()
    end
    self.bossCells = nil
  end
  tickManager:ClearTick(self)
  if self.bossTexture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.bossTexture)
  end
  PictureManager.Instance:UnLoadUI("ui_mvp_dead7_JM", self.listbg)
  BossView.super.OnExit(self)
end

function BossView:OnDestroy()
  self.bosslist:Destroy()
  BossView.super.OnDestroy(self)
end

function BossView:TrySendFavorite()
  local favoriteMap = ServiceBossCmdProxy.Instance.favoriteMap or {}
  local bossids = {}
  for k, v in pairs(favoriteMap) do
    if v == 1 then
      table.insert(bossids, k)
    end
  end
  ServiceBossCmdProxy.Instance:CallModifyFavouriteBossCmd(bossids)
end

function BossView:OnceDelayAction(time, action)
  tickManager:CreateOnceDelayTick(time, action, self, 1)
end
