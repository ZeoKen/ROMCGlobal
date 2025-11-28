TwelvePVPInfoTip = class("TwelvePVPInfoTip", CoreView)
autoImport("TowerInfoCell")
local UIType = FuBenCmd_pb.ETWELVEPVP_UI_CRYSTAL
local TwelvePvpConfig = GameConfig.TwelvePvp
local CampConfig = TwelvePvpConfig.CampConfig
local camp, value
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
local _twelvePvpProxy = TwelvePvPProxy.Instance

function TwelvePVPInfoTip:ctor(go)
  TwelvePVPInfoTip.super.ctor(self, go)
  self:Init()
end

function TwelvePVPInfoTip:Init()
  self:FindObjects()
  self:InitView()
end

function TwelvePVPInfoTip:FindObjects()
  local Title = self:FindComponent("Title", UILabel)
  Title.text = ZhString.TwelvePVPInfoTip_Title
  self.infoGridCtrl = {}
  local infoGrid1 = self:FindGO("infoGrid1"):GetComponent(UIGrid)
  self.infoGridCtrl[1] = UIGridListCtrl.new(infoGrid1, TowerInfoCell, "TowerInfoCell")
  local infoGrid2 = self:FindGO("infoGrid2"):GetComponent(UIGrid)
  self.infoGridCtrl[2] = UIGridListCtrl.new(infoGrid2, TowerInfoCell, "TowerInfoCell")
  self.lv = {}
  self.progress = {}
  local blueCrystalInfo = self:FindGO("blueCrystalInfo")
  self.lv[1] = self:FindGO("lv", blueCrystalInfo):GetComponent(UILabel)
  self.progress[1] = self:FindGO("progress", blueCrystalInfo):GetComponent(UISprite)
  local redCrystalInfo = self:FindGO("redCrystalInfo")
  self.lv[2] = self:FindGO("lv", redCrystalInfo):GetComponent(UILabel)
  self.progress[2] = self:FindGO("progress", redCrystalInfo):GetComponent(UISprite)
end

function TwelvePVPInfoTip:OnShow()
  if not self.isQurryedCrystalInfo then
    ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(UIType, true)
    self.isQurryedCrystalInfo = true
  end
  self.isIn = true
  for camp = 1, 2 do
    self:UpdateTowerInfo(camp)
    if self.lv[camp] then
      self.lv[camp].text = string.format(ZhString.TwelvePVPInfoTip_LV, _twelvePvpProxy:GetCrystalLv(camp))
    end
    if self.progress[camp] then
      self.progress[camp].fillAmount = _twelvePvpProxy:GetCrystalProgress(camp)
    end
  end
  EventManager.Me():AddEventListener(TwelvePVPEvent.UpdateCrystalExp, self.UpdateCrystalExp, self)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, self.UpdateBuildingHp, self)
end

function TwelvePVPInfoTip:InitView()
  self:InitCamp()
  self:InitConfig()
end

function TwelvePVPInfoTip:InitConfig()
  if self.guidMap then
    TableUtility.ArrayClear(self.guidMap)
  else
    self.guidMap = {}
  end
  if self.towers then
    TableUtility.ArrayClear(self.towers)
  else
    self.towers = {}
  end
  for i = 1, 2 do
    local towerConfig = CampConfig[i].DefenseTower
    self.towers[i] = {}
    self.guidMap[i] = {}
    if towerConfig then
      for j = 1, #towerConfig do
        TableUtility.ArrayPushBack(self.towers[i], towerConfig[j])
        self.guidMap[towerConfig[j]] = 0
      end
    end
    local BarrackConfig = CampConfig[i].BarrackID or {}
    if BarrackConfig.defense then
      TableUtility.ArrayPushBack(self.towers[i], BarrackConfig.defense)
      self.guidMap[BarrackConfig.defense] = 0
    end
    if CampConfig[i].CrystalID then
      TableUtility.ArrayPushBack(self.towers[i], CampConfig[i].CrystalID)
      self.guidMap[CampConfig[i].CrystalID] = 0
    end
  end
end

function TwelvePVPInfoTip:InitCamp()
  if not self.cells then
    self.cells = {}
  else
    TableUtility.ArrayClear(self.cells)
  end
  for campid = 1, 2 do
    local order = TowerOrder[campid]
    local infolist = {}
    for k, v in pairs(order) do
      local entry = {}
      entry.campid = campid
      entry.npcid = k
      entry.order = v
      TableUtility.ArrayPushBack(infolist, entry)
    end
    if campid and self.infoGridCtrl[campid] then
      table.sort(infolist, function(a, b)
        return a.order < b.order
      end)
      self.infoGridCtrl[campid]:ResetDatas(infolist)
      self:UpdateTowerInfo(campid)
      self.cells[campid] = self.infoGridCtrl[campid]:GetCells()
    end
  end
end

function TwelvePVPInfoTip:OnHide()
  if self.isQurryedCrystalInfo then
    ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(UIType, false)
    self.isQurryedCrystalInfo = false
  end
  self.isIn = false
  for camp = 1, 2 do
    if camp and self.lv[camp] then
      self.lv[camp].text = string.format(ZhString.TwelvePVPInfoTip_LV, 1)
    end
    if camp and self.progress[camp] then
      self.progress[camp].fillAmount = 0
    end
  end
  EventManager.Me():RemoveEventListener(TwelvePVPEvent.UpdateCrystalExp, self.UpdateCrystalExp, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, self.UpdateBuildingHp, self)
end

function TwelvePVPInfoTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function TwelvePVPInfoTip:UpdateCrystalExp(data)
  if not self.isIn then
    return
  end
  if not data then
    return
  end
  camp = data[1]
  value = data[2]
  if camp and self.lv[camp] then
    self.lv[camp].text = string.format(ZhString.TwelvePVPInfoTip_LV, _twelvePvpProxy:GetCrystalLv(camp))
  end
  if camp and self.progress[camp] then
    self.progress[camp].fillAmount = _twelvePvpProxy:GetCrystalProgress(camp)
  end
end

local cells, towers, frontline, campTower, findOrder, npcid, findid, order, currentid, currentOrder

function TwelvePVPInfoTip:UpdateTowerInfo(camp)
  if not (self.isIn and self.infoGridCtrl and camp) or not self.cells then
    return
  end
  campTower = TowerOrder[camp]
  if not campTower then
    return
  end
  cells = self.cells[camp]
  if not cells then
    return
  end
  towers = self.towers[camp]
  if not towers then
    return
  end
  frontline = _twelvePvpProxy:GetFrontline()
  for i = 1, #frontline do
    findid = frontline[i]
    if findid == 0 then
      for i = 1, #towers do
        if cells[i] then
          cells[i]:SetBroken()
        end
      end
      return
    end
    findOrder = campTower[findid]
    if findOrder then
      currenthp = _twelvePvpProxy:GetHPPercentByNPCID(findid) or 0
      if 0 >= currenthp then
        findid = towers[findOrder + 1] or 0
        currenthp = 100
        findOrder = campTower[findid]
      end
      if findid == 0 then
        for i = 1, #towers do
          if cells[i] then
            cells[i]:SetBroken()
          end
        end
        return
      end
      if findOrder then
        currentid = 0
        for i = 1, #towers do
          if cells[i] then
            currentOrder = campTower[towers[i]]
            if findOrder > currentOrder then
              if 4 <= currentOrder then
                cells[i]:SetCurrent(towers[i], currenthp)
              else
                cells[i]:SetBroken()
              end
            elseif findOrder == currentOrder then
              cells[i]:SetCurrent(findid, currenthp)
            elseif findOrder < currentOrder then
              if 4 <= findOrder then
                cells[i]:SetCurrent(towers[i], currenthp)
              else
                cells[i]:SetFull()
              end
            end
          end
        end
      end
    end
  end
end

function TwelvePVPInfoTip:UpdateBuildingHp(data)
  if self.isIn then
    for i = 1, #data.data do
      for j = 1, 2 do
        if TowerOrder[j][data.data[i].building_id] then
          self:UpdateTowerInfo(j)
        end
      end
    end
  end
end
