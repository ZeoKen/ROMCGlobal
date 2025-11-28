MainViewTwelvePVPpage = class("MainViewTwelvePVPpage", SubView)
autoImport("TwelvePVPItemCell")
MainViewTwelvePVPpage.SyncDataType = {
  CRYSTAL_EXP = FuBenCmd_pb.ETWELVEPVP_DATA_CRYSTAL_EXP,
  GOLD = FuBenCmd_pb.ETWELVEPVP_DATA_GOLD,
  CAR_POINT = FuBenCmd_pb.ETWELVEPVP_DATA_CAR_POINT,
  PUSH_PLAYER_NUM = FuBenCmd_pb.ETWELVEPVP_DATA_PUSH_PLAYER_NUM,
  END_TIME = FuBenCmd_pb.ETWELVEPVP_DATA_END_TIME
}
local timeFormat = "%02d:%02d"
local LevelItem = GameConfig.TwelvePvp.ShopItemConfig.LevelItem
local TwelvePvpConfig = GameConfig.TwelvePvp
local CampConfig = TwelvePvpConfig.CampConfig
local hppercent, findOrder
local buildingid = 0
local npcid = 0
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
local _TwelvePvpProxy = TwelvePvPProxy.Instance
local _IsObserver = function()
  local _ob = PvpObserveProxy.Instance
  return _ob:IsRunning()
end

function MainViewTwelvePVPpage:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewTwelvePVPpage:Show()
  MainViewTwelvePVPpage.super.Show(self)
  self:ResetDatas()
end

function MainViewTwelvePVPpage:ResetDatas()
  self:UpdateGold()
  self:updateEndTime()
  self.packageToggle = false
  self:UpdateItems()
end

function MainViewTwelvePVPpage:Init()
  self:ReLoadPerferb("view/MainViewTwelvePVP")
  self:AddViewEvents()
  self:FindObjs()
  self:InitShow()
  self:InitView()
end

function MainViewTwelvePVPpage:FindObjs()
  self.countdown = self:FindGO("countdown"):GetComponent(UILabel)
  local count = self:FindGO("count"):GetComponent(UILabel)
  count.text = ZhString.TwelvePVP_CoinTip
  self.coin = self:FindGO("coin"):GetComponent(UILabel)
  self.coin.text = "0"
  self.effectContainer = self:FindGO("effectContainer")
  local defenseInfo = self:FindGO("DefenseInfo")
  self.towerName = {}
  self.towerName[1] = self:FindGO("name", defenseInfo):GetComponent(UILabel)
  self.hpProgress = {}
  self.hpProgress[1] = self:FindGO("HPProgress", defenseInfo):GetComponent(UISlider)
  self.hpPercent = {}
  self.hpPercent[1] = self:FindGO("HPPercent", defenseInfo):GetComponent(UILabel)
  local offenseInfo = self:FindGO("OffenseInfo")
  self.towerName[2] = self:FindGO("name", offenseInfo):GetComponent(UILabel)
  self.hpProgress[2] = self:FindGO("HPProgress", offenseInfo):GetComponent(UISlider)
  self.hpPercent[2] = self:FindGO("HPPercent", offenseInfo):GetComponent(UILabel)
  self.itemPanel = self:FindGO("ItemPanel")
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(self.itemContainer, TwelvePVPItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 3, 100, true)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.itemCtrl:AddEventListener(MouseEvent.DoubleClick, self.OnDoubleClickCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  local detailBtn = self:FindGO("detailBtn")
  self:AddClickEvent(detailBtn, function()
    ServiceFuBenCmdProxy.Instance:CallTwelvePvpQueryGroupInfoCmd()
  end)
  local packageBtn = self:FindGO("packageBtn")
  self:AddClickEvent(packageBtn, function()
    self.packageToggle = not self.packageToggle
    self:UpdateItems()
  end)
  local goalBtn = self:FindGO("goalBtn")
  self:AddClickEvent(goalBtn, function()
    if _IsObserver() then
      return
    end
    local mode = TwelvePvPProxy.Instance:GetPvpType()
    if PvpProxy.Type.TwelvePVPRelax == mode then
      MsgManager.ShowMsgByID(26251)
      return
    end
    ServiceFuBenCmdProxy.Instance:CallTwelvePvpQuestQueryCmd()
  end)
  self:AddClickEvent(count.gameObject, function()
    if _IsObserver() then
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TwelvePVPShopView
    })
  end)
end

function MainViewTwelvePVPpage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemSyncCmd, self.UpdateItems)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemUpdateCmd, self.UpdateItems)
  self:AddListenEvt(TwelvePVPEvent.UpdateGold, self.UpdateGold)
  self:AddListenEvt(TwelvePVPEvent.UpdateEndTime, self.updateEndTime)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd, self.HandleQueryGroupInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, self.HandleBuildingHpUpdate)
end

function MainViewTwelvePVPpage:InitView()
  self.towers = TwelvePvPProxy.Instance:GetCampTowers()
  self.packageToggle = false
  self:UpdateItems()
end

function MainViewTwelvePVPpage:HandleBuildingHpUpdate(note)
  if note and note.body then
    local serverdatas = note.body.data
    for i = 1, #serverdatas do
      buildingid = serverdatas[i].building_id
      for camp = 1, 2 do
        if TowerOrder[camp][buildingid] then
          self:UpdateTowerInfo(camp, buildingid)
        end
      end
    end
  end
end

function MainViewTwelvePVPpage:UpdateTowerInfo(camp, cid)
  if not self.towers then
    return
  end
  local towers = self.towers[camp] or {}
  local campTower = TowerOrder[camp]
  findid = cid
  if findid then
    findOrder = campTower[findid]
    currenthp = _TwelvePvpProxy:GetHPPercentByNPCID(findid)
    if currenthp <= 0 then
      findid = towers[findOrder + 1] or 0
      findOrder = campTower[findid]
    end
    if findOrder == 4 then
      findid = towers[findOrder + 1] or 0
      findOrder = campTower[findid]
    end
    if findid == 0 then
      self:SetBroken(camp)
      return
    end
    self:SetCurrent(camp, findid)
    return
  end
end

function MainViewTwelvePVPpage:SetBroken(camp)
  if not camp then
    return
  end
  local towers = self.towers[camp]
  local monsterid = towers[#towers]
  self.towerName[camp].text = Table_Monster[monsterid] and Table_Monster[monsterid].NameZh
  self.hpProgress[camp].value = 0
  self.hpPercent[camp].text = "0%"
  _TwelvePvpProxy:SetFrontlineData(camp, monsterid, 0)
end

function MainViewTwelvePVPpage:SetCurrent(camp, findid)
  if not camp then
    return
  end
  local towers = self.towers[camp]
  currenthp = _TwelvePvpProxy:GetHPPercentByNPCID(findid)
  self.towerName[camp].text = Table_Monster[findid] and Table_Monster[findid].NameZh
  self.hpProgress[camp].value = currenthp / 100
  self.hpPercent[camp].text = string.format("%d%%", currenthp)
  _TwelvePvpProxy:SetFrontlineData(camp, findid, currenthp)
end

function MainViewTwelvePVPpage:OnClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
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

function MainViewTwelvePVPpage:ResetChooseId()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end

function MainViewTwelvePVPpage:OnDoubleClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if not data then
    return
  end
  local func, funcId = FunctionItemFunc.Me():GetItemDefaultFunc(data)
  if func then
    if funcId == 1 then
      FunctionItemFunc.TryUseItem(data, nil, 1)
    else
      func(data)
    end
  end
  self.chooseId = 0
  self:ResetChooseId()
  self:ShowItemTip()
end

local tipOffset = {-210, 0}
local itemid, count

function MainViewTwelvePVPpage:ShowItemTip(data, ignoreBounds)
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
    funcConfig = FunctionItemFunc.GetItemFuncIds(data.staticData.id),
    ignoreBounds = ignoreBounds,
    callback = function()
      self.chooseId = 0
      self:ResetChooseId()
    end
  }
  MainViewTwelvePVPpage.super.ShowItemTip(self, sdata, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function MainViewTwelvePVPpage:UpdateItems()
  self.itemPanel:SetActive(self.packageToggle)
  if self.packageToggle then
    local itemDatas = TwelvePvPProxy.Instance:GetCurPlayerItems()
    self.itemCtrl:ResetDatas(itemDatas)
  end
  self:ShowItemTip()
end

function MainViewTwelvePVPpage:UpdateGold()
  self.coin.text = TwelvePvPProxy.Instance:GetGold()
  if not _IsObserver() then
    self:PlayUIEffect(EffectMap.UI.Gold_UI_12pvp, self.effectContainer, true)
  end
end

function MainViewTwelvePVPpage:updateEndTime()
  local time = TwelvePvPProxy.Instance:GetEndTime()
  if time == 0 then
    return
  end
  self.endtime = time
  if not self:_UpdateLeftTimeTick() then
    return
  end
  if self.timeUpTick then
    return
  end
  self.timeUpTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateLeftTimeTick, self, 1)
end

function MainViewTwelvePVPpage:_UpdateLeftTimeTick()
  local currenttime = ServerTime.CurServerTime()
  local startsec = (self.endtime * 1000 - currenttime) / 1000
  if startsec < 0 then
    self.countdown.text = string.format(timeFormat, 0, 0)
    self:RemoveUpdateLeftTimeTick()
    return false
  end
  local d, h, m, s = ClientTimeUtil.FormatTimeBySec(startsec)
  self.countdown.text = string.format(timeFormat, m, s)
  return true
end

function MainViewTwelvePVPpage:RemoveUpdateLeftTimeTick()
  if not self.timeUpTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.timeUpTick = nil
end

function MainViewTwelvePVPpage:HandleQueryGroupInfo()
  TipManager.Instance:CloseItemTip()
end

function MainViewTwelvePVPpage:OnExit()
  self:RemoveUpdateLeftTimeTick()
  TipManager.Instance:CloseItemTip()
end
