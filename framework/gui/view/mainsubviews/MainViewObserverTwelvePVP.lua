autoImport("TwelvePvpObserverHeadCell")
autoImport("TwelvePVPItemCell")
MainViewObserverTwelvePVP = class("MainViewObserverTwelvePVP", SubView)
local _TwelvePvpProxy = TwelvePvPProxy.Instance
local _ObserverProxy = PvpObserveProxy.Instance
local TwelvePvpConfig = GameConfig.TwelvePvp
local LevelItem = TwelvePvpConfig.ShopItemConfig.LevelItem
local CampConfig = TwelvePvpConfig.CampConfig
local findOrder
local buildingid = 0
local TowerOrder = {
  [1] = {
    [CampConfig[1].DefenseTower[1]] = 1,
    [CampConfig[1].DefenseTower[2]] = 2,
    [CampConfig[1].DefenseTower[3]] = 3,
    [CampConfig[1].BarrackID.defense] = 4,
    [CampConfig[1].CrystalID] = 5
  },
  [2] = {
    [CampConfig[2].DefenseTower[1]] = 1,
    [CampConfig[2].DefenseTower[2]] = 2,
    [CampConfig[2].DefenseTower[3]] = 3,
    [CampConfig[2].BarrackID.defense] = 4,
    [CampConfig[2].CrystalID] = 5
  }
}
local _cdTimeFormat = "%02d:%02d"
local _zeroPercent = "0%"
local _posConfig = {
  [1] = {
    {
      -920,
      -156,
      0
    },
    {
      -653,
      -156,
      0
    }
  },
  [2] = {
    {
      623,
      -156,
      0
    },
    {
      358,
      -156,
      0
    }
  },
  [3] = {
    {
      -719,
      175,
      0
    },
    {
      -564,
      175,
      0
    }
  }
}
local _movingXAxisOffset = {
  [1] = {-262, 262},
  [2] = {262, -262},
  [3] = {-155, 155}
}
local _tempV3 = LuaVector3()
local _tempRot = LuaQuaternion()

function MainViewObserverTwelvePVP:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "MainViewObserverTwelvePVP")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaVector3.zero
end

function MainViewObserverTwelvePVP:Show()
  self.obRoot:SetActive(true)
  self:ResetDatas()
end

function MainViewObserverTwelvePVP:Hide()
  self.obRoot:SetActive(false)
end

function MainViewObserverTwelvePVP:ResetDatas()
  self:UpdateGold()
  self:UpdateEndTime()
  self.packageToggle = false
  self:UpdateItems()
  self:CampPlayerInit()
end

function MainViewObserverTwelvePVP:Init()
  self:ReLoadPerferb("view/MainViewObserverTwelvePVP", true)
  self.obRoot = self:FindGO("MainViewObserverTwelvePVP")
  self:AddViewEvents()
  self:FindObjs()
  self:AddUIEvts()
  self:InitView()
end

function MainViewObserverTwelvePVP:FindObjs()
  self.cdTimeLab = self:FindGO("CDTimeLab"):GetComponent(UILabel)
  local fixedCDLab = self:FindGO("FixedCDLab"):GetComponent(UILabel)
  fixedCDLab.text = ZhString.TwelvePVP_CDTime
  local goldFixedLab = self:FindGO("GoldFixedLab"):GetComponent(UILabel)
  goldFixedLab.text = ZhString.TwelvePVP_CoinTip
  self.goldLab = self:FindGO("GoldLab"):GetComponent(UILabel)
  self.goldLab.text = "0"
  self.effectContainer = self:FindGO("EffectContainer")
  self.towerNameLab = {}
  self.towerNameMap = {}
  self.hpProgress = {}
  self.hpPercent = {}
  local defenseInfo = self:FindGO("DefenseInfo")
  self.towerNameLab[1] = self:FindGO("Name", defenseInfo):GetComponent(UILabel)
  self.hpProgress[1] = self:FindGO("HPProgress", defenseInfo):GetComponent(UISlider)
  self.hpPercent[1] = self:FindGO("HPPercent", defenseInfo):GetComponent(UILabel)
  local offenseInfo = self:FindGO("OffenseInfo")
  self.towerNameLab[2] = self:FindGO("Name", offenseInfo):GetComponent(UILabel)
  self.hpProgress[2] = self:FindGO("HPProgress", offenseInfo):GetComponent(UISlider)
  self.hpPercent[2] = self:FindGO("HPPercent", offenseInfo):GetComponent(UILabel)
  self.itemPanel = self:FindGO("ItemPanel")
  local itemContainer = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(itemContainer, TwelvePVPItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 3, 100, true)
  self.itemCells = self.itemCtrl:GetCells()
  self.normalStick = self:FindComponent("ObNormalStick", UISprite)
  local leftHeadGrid = self:FindComponent("HeadLeftGrid", UIGrid)
  self.leftPlayers = UIGridListCtrl.new(leftHeadGrid, TwelvePvpObserverHeadCell, "TwelvePvpObserverHeadCell")
  self.leftPlayerCells = self.leftPlayers:GetCells()
  local rightHeadGrid = self:FindComponent("HeadRightGrid", UIGrid)
  self.rightPlayers = UIGridListCtrl.new(rightHeadGrid, TwelvePvpObserverHeadCell, "TwelvePvpObserverHeadCell")
  self.rightPlayerCells = self.rightPlayers:GetCells()
  self.todoTweenObj, self.todoTweenBtn, self.tweenImg, self.tweenFlag = {}, {}, {}, {}
  self.todoTweenObj[1] = self:FindGO("HeadRoot_Left")
  self.todoTweenObj[2] = self:FindGO("HeadRoot_Right")
  self.todoTweenObj[3] = self:FindGO("LeftTopRoot")
  self.todoTweenBtn[1] = self:FindGO("HideLeftBtn")
  self.todoTweenBtn[2] = self:FindGO("HideRightBtn")
  self.todoTweenBtn[3] = self:FindGO("HideLeftTopBtn")
  self.tweenImg[1] = self:FindGO("HideLeftImg")
  self.tweenImg[2] = self:FindGO("HideRightImg")
  self.tweenImg[3] = self:FindGO("HideTopImg")
  for i = 1, 3 do
    self.tweenFlag[i] = false
  end
  self:InitCampKillObj()
end

function MainViewObserverTwelvePVP:InitCampKillObj()
  local parentObj = self.todoTweenObj[3]
  local campKillRoot = self:FindGO("CampKillNumRoot", parentObj)
  if not campKillRoot then
    return
  end
  self.campKillNumLabs = {}
  for camp = 1, 2 do
    local cellCampRoot = self:FindGO("Camp" .. tostring(camp), campKillRoot)
    local fixedLab = self:FindComponent("FixedLabel", UILabel, cellCampRoot)
    fixedLab.text = ZhString.TwelvePVP_CampKill
    self.campKillNumLabs[camp] = self:FindComponent("KillNumLab", UILabel, cellCampRoot)
  end
end

function MainViewObserverTwelvePVP:AddUIEvts()
  local btnRoot = self:FindGO("BtnRoot")
  local detailBtn = self:FindGO("DetailBtn", btnRoot)
  self:AddClickEvent(detailBtn, function()
    ServiceFuBenCmdProxy.Instance:CallTwelvePvpQueryGroupInfoCmd()
  end)
  local packageBtn = self:FindGO("PackageBtn", btnRoot)
  self:AddClickEvent(packageBtn, function()
    self.packageToggle = not self.packageToggle
    if self.packageToggle then
      _ObserverProxy:CallBeginCheckUI(PvpObserveProxy.UIType.Item)
    else
      _ObserverProxy:CallEndCheckUI(PvpObserveProxy.UIType.Item)
    end
    self:UpdateItems()
  end)
  local settingBtn = self:FindGO("SettingBtn", btnRoot)
  self:AddClickEvent(settingBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SetView
    })
  end)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.leftPlayers:AddEventListener(MouseEvent.MouseClick, self.OnClickPlayer, self)
  self.rightPlayers:AddEventListener(MouseEvent.MouseClick, self.OnClickPlayer, self)
  for i = 1, 3 do
    self:AddClickEvent(self.todoTweenBtn[i], function()
      local curx, cury, curz = LuaGameObject.GetLocalPosition(self.todoTweenObj[i].transform)
      curx = self.tweenFlag[i] and curx + _movingXAxisOffset[i][2] or curx + _movingXAxisOffset[i][1]
      local pos = self.tweenFlag[i] and _posConfig[i][2] or _posConfig[i][1]
      LuaVector3.Better_Set(_tempV3, curx, cury, curz)
      TweenPosition.Begin(self.todoTweenObj[i], 0.2, _tempV3, false)
      local zAxis = self.tweenFlag[i] and 0 or 180
      LuaVector3.Better_Set(_tempV3, 0, 0, zAxis)
      LuaQuaternion.Better_SetEulerAngles(_tempRot, _tempV3)
      self.tweenImg[i].transform.localRotation = _tempRot
      self.tweenFlag[i] = not self.tweenFlag[i]
    end)
  end
end

function MainViewObserverTwelvePVP:AddViewEvents()
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemSyncCmd, self.UpdateItems)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemUpdateCmd, self.UpdateItems)
  self:AddListenEvt(TwelvePVPEvent.UpdateEndTime, self.UpdateEndTime)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd, self.HandleQueryGroupInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, self.HandelBuildingHpUpdate)
  self:AddDispatcherEvt(MyselfEvent.ObservationClearItem, self.UpdateItems)
  self:AddDispatcherEvt(MyselfEvent.ObservationGoldUpdate, self.UpdateGold)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdObserverAttachFubenCmd, self.HandleAttachPlayer)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdObserverSelectFubenCmd, self.HandleSelectPlayer)
  self:AddDispatcherEvt(ServiceEvent.MatchCCmdObInitInfoFubenCmd, self.CampPlayerInit)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerHpSpUpdate, self.HandlePlayerHpSpUpdate)
  self:AddDispatcherEvt(MyselfEvent.ObservationPlayerOffline, self.HandleObPlayerOffline)
  self:AddDispatcherEvt(TwelvePVPEvent.UpdateCrystalLv, self.HandelCrystalLvUpdate)
  self:AddDispatcherEvt(TwelvePVPEvent.UpdateKillNum, self.UpdateCampKill)
end

function MainViewObserverTwelvePVP:InitView()
  self.towers = _TwelvePvpProxy:GetCampTowers()
  self.packageToggle = false
  self:UpdateItems()
  self:UpdateCampKill()
end

function MainViewObserverTwelvePVP:CampPlayerInit()
  local datas = _ObserverProxy:GetPlayerDataByCamp(1)
  self.leftPlayers:ResetDatas(datas)
  local datas2 = _ObserverProxy:GetPlayerDataByCamp(2)
  self.rightPlayers:ResetDatas(datas2)
end

function MainViewObserverTwelvePVP:HandlePlayerHpSpUpdate(note)
  local ids = note
  if not ids then
    return
  end
  local updateCount = 0
  for i = 1, #ids do
    if updateCount == #ids then
      break
    end
    for _, player in pairs(self.leftPlayerCells) do
      if player.playerid == ids[i] then
        local data = _ObserverProxy:GetPlayerDataById(ids[i])
        if data then
          player:UpdateHpSp(data.hp, data.mp)
          updateCount = updateCount + 1
        end
      end
    end
    for _, player in pairs(self.rightPlayerCells) do
      if player.playerid == ids[i] then
        local data = _ObserverProxy:GetPlayerDataById(ids[i])
        if data then
          player:UpdateHpSp(data.hp, data.mp)
          updateCount = updateCount + 1
        end
      end
    end
  end
end

function MainViewObserverTwelvePVP:HandleObPlayerOffline(note)
  local id = note
  if not id then
    return
  end
  local offlineUpdated = false
  for _, player in pairs(self.leftPlayerCells) do
    if player.playerid == id then
      local data = _ObserverProxy:GetPlayerDataById(id)
      if data then
        player:UpdateOffline()
        offlineUpdated = true
        break
      end
    end
  end
  if offlineUpdated then
    return
  end
  for _, player in pairs(self.rightPlayerCells) do
    if player.playerid == id then
      local data = _ObserverProxy:GetPlayerDataById(id)
      if data then
        player:UpdateOffline()
        break
      end
    end
  end
end

function MainViewObserverTwelvePVP:HandleAttachPlayer()
  local attchPlayerId = _ObserverProxy:GetAttachPlayer()
  for _, player in pairs(self.leftPlayerCells) do
    player:SetAttach(attchPlayerId)
  end
  for _, player in pairs(self.rightPlayerCells) do
    player:SetAttach(attchPlayerId)
  end
end

function MainViewObserverTwelvePVP:HandleSelectPlayer()
  local chooseId = _ObserverProxy:GetSelectPlayer()
  for _, player in pairs(self.leftPlayerCells) do
    player:SetChoosen(chooseId)
  end
  for _, player in pairs(self.rightPlayerCells) do
    player:SetChoosen(chooseId)
  end
end

function MainViewObserverTwelvePVP:OnClickPlayer(cellCtl)
  local playerid = cellCtl.data and cellCtl.data.playerid
  if not playerid then
    return
  end
  _ObserverProxy:TryAttach(playerid)
end

function MainViewObserverTwelvePVP:HandelBuildingHpUpdate(note)
  if note and note.body then
    local serverdatas = note.body.data
    for i = 1, #serverdatas do
      buildingid = serverdatas[i].building_id
      for j = 1, 2 do
        if TowerOrder[j][buildingid] then
          self:UpdateTowerInfo(j, buildingid)
        end
      end
    end
  end
end

function MainViewObserverTwelvePVP:UpdateCampKill()
  if not self.campKillNumLabs then
    return
  end
  for camp, lab in pairs(self.campKillNumLabs) do
    lab.text = _TwelvePvpProxy:GetCampKill(camp)
  end
end

function MainViewObserverTwelvePVP:UpdateTowerInfo(camp, cid)
  if not self.towers then
    return
  end
  local towers = self.towers[camp] or {}
  local campTower = TowerOrder[camp]
  findid = cid
  if findid then
    findOrder = campTower[findid]
    currenthp = _TwelvePvpProxy:GetHPPercentByNPCID(findid) or 0
    if currenthp <= 0 then
      findid = towers[findOrder + 1] or 0
      findOrder = campTower[findid]
    end
    if findOrder == 4 then
      findid = towers[findOrder + 1] or 0
      findOrder = campTower[findid]
    end
    if findid == 0 then
      self:_SetBroken(camp)
      return
    end
    self:_SetCurrent(camp, findid)
  end
end

function MainViewObserverTwelvePVP:_SetBroken(camp)
  if not camp then
    return
  end
  local towers = self.towers[camp]
  local crystalLv = string.format(ZhString.TwelvePVPInfoTip_LV, _TwelvePvpProxy:GetCrystalLv(camp))
  self.towerNameMap[camp] = Table_Monster[towers[#towers]].NameZh
  self.towerNameLab[camp].text = self.towerNameMap[camp] .. crystalLv
  self.hpProgress[camp].value = 0
  self.hpPercent[camp].text = _zeroPercent
end

function MainViewObserverTwelvePVP:_SetCurrent(camp, findid)
  if not camp then
    return
  end
  local towers = self.towers[camp]
  currenthp = _TwelvePvpProxy:GetHPPercentByNPCID(findid) or 0
  local crystalLv = string.format(ZhString.TwelvePVPInfoTip_LV, _TwelvePvpProxy:GetCrystalLv(camp))
  self.towerNameMap[camp] = Table_Monster[findid].NameZh
  self.towerNameLab[camp].text = self.towerNameMap[camp] .. crystalLv
  self.hpProgress[camp].value = currenthp / 100
  self.hpPercent[camp].text = tostring(currenthp) .. "%"
end

function MainViewObserverTwelvePVP:OnClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    return
  end
  if not data then
    return
  end
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    self:ShowItemTip(data, {
      cellCtl and cellCtl.gameObject
    })
  else
    self.chooseId = 0
    self:ShowItemTip()
  end
  self:ResetChooseId()
end

function MainViewObserverTwelvePVP:ResetChooseId()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

local tipOffset = {-210, 0}
local itemid, count

function MainViewObserverTwelvePVP:ShowItemTip(data, ignoreBounds)
  if not data or not data.staticData then
    TipManager.Instance:CloseItemTip()
    return
  end
  itemid = data.staticData.id
  count = data.num
  data.staticData.Desc = LevelItem[itemid] and LevelItem[itemid][count] and LevelItem[itemid][count].desc or data.staticData.Desc
  local sdata = {
    itemdata = data,
    showUpTip = true,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    callback = function()
      self.chooseId = 0
      self:ResetChooseId()
    end
  }
  MainViewObserverTwelvePVP.super.ShowItemTip(self, sdata, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function MainViewObserverTwelvePVP:UpdateItems()
  self.itemPanel:SetActive(self.packageToggle)
  if self.packageToggle then
    local items = _TwelvePvpProxy:GetCurPlayerItems()
    self.itemCtrl:ResetDatas(items)
  end
  self:ShowItemTip()
end

function MainViewObserverTwelvePVP:UpdateGold()
  self.goldLab.text = PvpObserveProxy.Instance:GetCheckingPlayerGold()
end

function MainViewObserverTwelvePVP:UpdateEndTime()
  local time = _TwelvePvpProxy:GetEndTime()
  if not time or time == 0 then
    return
  end
  self.endtime = time
  if not self:_UpdateTimeTick() then
    return
  end
  if self.timeUpTick then
    return
  end
  self.timeUpTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTimeTick, self, 1)
end

function MainViewObserverTwelvePVP:HandelCrystalLvUpdate(data)
  if not data then
    return
  end
  local eventData = data.body or data
  if not eventData then
    return
  end
  camp = eventData[1]
  value = eventData[2]
  local lvStr = string.format(ZhString.TwelvePVPInfoTip_LV, value)
  local cacheName = self.towerNameMap[camp]
  if cacheName then
    self.towerNameLab[camp].text = cacheName .. lvStr
  else
    self.towerNameLab[camp].text = lvStr
  end
end

function MainViewObserverTwelvePVP:_UpdateTimeTick()
  local currenttime = ServerTime.CurServerTime()
  local startsec = (self.endtime * 1000 - currenttime) / 1000
  if startsec < 0 then
    self.cdTimeLab.text = string.format(_cdTimeFormat, 0, 0)
    self:ClearTimeTick()
    return false
  end
  local _, _, m, s = ClientTimeUtil.FormatTimeBySec(startsec)
  self.cdTimeLab.text = string.format(_cdTimeFormat, m, s)
  return true
end

function MainViewObserverTwelvePVP:ClearTimeTick()
  if not self.timeUpTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.timeUpTick = nil
end

function MainViewObserverTwelvePVP:HandleQueryGroupInfo()
  TipManager.Instance:CloseItemTip()
end

function MainViewObserverTwelvePVP:OnExit()
  self:ClearTimeTick()
  TipManager.Instance:CloseItemTip()
  self.leftPlayers:Destroy()
  self.rightPlayers:Destroy()
  MainViewObserverTwelvePVP.super.OnExit(self)
end
