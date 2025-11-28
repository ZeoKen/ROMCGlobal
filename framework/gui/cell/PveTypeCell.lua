local baseCell = autoImport("BaseCell")
autoImport("PveTypeGridCell")
local _RaidTypeConfig = GameConfig.Pve.RaidType
local _RedTipProxy, _EntranceRedTipEnum
local gridCellHeight = 50
local gridCellHeightOffset = 55
PveTypeCell = class("PveTypeCell", baseCell)

function PveTypeCell:Init()
  _RedTipProxy = RedTipProxy.Instance
  _EntranceRedTipEnum = SceneTip_pb.EREDSYS_PVERAID_ENTRANCE
  PveTypeCell.super.Init(self)
  self:FindObj()
  self:InitGridUpdateFunc()
end

function PveTypeCell:InitGridUpdateFunc()
  self.gridUpdateFunc = {}
  self.gridUpdateFunc[PveRaidType.Crack] = self.UpdateCrackGrid
  self.gridUpdateFunc[PveRaidType.Boss] = self.UpdateBossGrid
  self.gridUpdateFunc[PveRaidType.RoadOfHero] = self.UpdateHeroRoadGrid
  self.gridUpdateFunc[PveRaidType.Astral] = self.UpdateAstralGrid
  self.gridUpdateFunc[PveRaidType.MemoryRaid] = self.UpdateMemoryRaidGrid
end

function PveTypeCell:FindObj()
  self.content = self:FindGO("Content")
  self.featureLab = self:FindComponent("FeatureLab", UILabel)
  self.gridArrowObj = self:FindGO("GridArrowObj", self.content)
  self.gridRoot = self:FindGO("GridRoot")
  self.grid = self:FindComponent("Grid", UIGrid, self.gridRoot)
  self.gridBg = self:FindComponent("GridBg", UISprite, self.gridRoot)
  self.gridCtl = UIGridListCtrl.new(self.grid, PveTypeGridCell, "PveTypeGridCell")
  self.gridCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickCrackCell, self)
  self.gridCells = self.gridCtl:GetCells()
  self.newObj = self:FindGO("New", self.content)
  self.nameLab = self:FindComponent("NameLab", UILabel, self.content)
  self.lockRoot = self:FindGO("LockRoot", self.content)
  self.lvLab = self:FindComponent("UnlockLv", UILabel, self.lockRoot)
  self.texture = self:FindComponent("Texture", UITexture, self.content)
  self.choosenObj = self:FindGO("Choosen", self.content)
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("muLabel", UILabel, self.multiplySymbol)
  self.bg = self:FindGO("Bg", self.content)
  self:SetEvent(self.bg, function()
    if self.groupid and not self:IsGridType() then
      _RedTipProxy:SeenNew(_EntranceRedTipEnum, self.groupid)
      self.redtip:SetActive(false)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.redtip = self:FindGO("redtip")
  self.gridRoot:SetActive(false)
  self.seasonLabel = self:FindComponent("Season", UILabel)
  self:Hide(self.seasonLabel)
  self.seasonRemainTimeLabel = self:FindComponent("SeasonRemainTime", UILabel)
end

function PveTypeCell:SetDragScrollView(sv)
  if self.gridCells then
    for i = 1, #self.gridCells do
      self.gridCells[i]:SetDragScrollView(sv)
    end
  end
end

function PveTypeCell:TrySeenRedTip()
  if self.gridCells then
    for i = 1, #self.gridCells do
      self.gridCells[i]:TrySeenRedTip()
    end
  end
end

function PveTypeCell:StopAutoScollView()
  if self.gridCells then
    for i = 1, #self.gridCells do
      if self.gridCells[i].data and self.gridCells[i].data.id == self.gridCells[i].chooseId then
        self.gridCells[i]:StopAutoScollView()
        break
      end
    end
  end
end

function PveTypeCell:StartAutoScrollView()
  if self.gridCells then
    for i = 1, #self.gridCells do
      if self.gridCells[i].data and self.gridCells[i].data.id == self.gridCells[i].chooseId then
        self.gridCells[i]:StartAutoScrollView()
        break
      end
    end
  end
end

function PveTypeCell:OnClickCrackCell(cell)
  self:SetData(cell.data)
  self:PassEvent(MouseEvent.MouseClick, self)
  self:UpdateGridChoose(self.data.id)
  if not self.data or not self.data.staticEntranceData then
    return
  end
  if self.data.staticEntranceData:IsBoss() then
    self:TrySeenRedTip()
  else
    cell:TrySeenRedTip()
  end
end

local tempV3, tempRot = LuaVector3(), LuaQuaternion()

function PveTypeCell:ReverseCrack(force_reverse)
  if force_reverse and not self.reverseActive then
    return
  end
  local active = self.gridRoot.activeSelf
  self.gridRoot:SetActive(not active)
  self.reverseActive = not active
  local zRotation = active and 0 or 180
  if active then
    self:StopAutoScollView()
  else
    self:StartAutoScrollView()
  end
  LuaVector3.Better_Set(tempV3, 0, 0, zRotation)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.gridArrowObj.transform.localRotation = tempRot
end

function PveTypeCell:TryUpdateGridCtl()
  if not self.raidType then
    return
  end
  local func = self.gridUpdateFunc[self.raidType]
  if nil ~= func then
    func(self)
    self:Show(self.gridArrowObj)
  else
    self:Hide(self.gridArrowObj)
  end
end

function PveTypeCell:TryStopAutoScollView()
  if not self.raidType then
    return
  end
  local func = self.gridUpdateFunc[self.raidType]
  if nil ~= func then
    self:StopAutoScollView()
  end
end

function PveTypeCell:TrySetDragScrollView(sv)
  if not self.raidType then
    return
  end
  local func = self.gridUpdateFunc[self.raidType]
  if nil ~= func then
    self:SetDragScrollView(sv)
  end
end

function PveTypeCell:UpdateCrackGrid()
  local crackData = PveEntranceProxy.Instance:GetAllCrackPveData()
  local entranceData = PveEntranceProxy.Instance:GetCurCrackRaidFirstEnternceData()
  self:UpdateSubGrid(crackData, entranceData.id)
end

function PveTypeCell:UpdateBossGrid()
  local bossData = PveEntranceProxy.Instance:GetAllBossPveData()
  local entranceData = PveEntranceProxy.Instance:GetCurBossFirstPveData()
  self:UpdateSubGrid(bossData, entranceData.id)
end

function PveTypeCell:UpdateHeroRoadGrid()
  local datas = PveEntranceProxy.Instance:GetAllRoadOfHeroData()
  self:UpdateSubGrid(datas, datas[1].id)
end

function PveTypeCell:UpdateAstralGrid()
  local datas = PveEntranceProxy.Instance:GetAllAstralData()
  local entranceData = PveEntranceProxy.Instance:GetCurAstralFirstPveData()
  self:UpdateSubGrid(datas, entranceData.id)
end

function PveTypeCell:UpdateMemoryRaidGrid()
  local datas = PveEntranceProxy.Instance:GetAllMemoryRaidData()
  local entranceData = PveEntranceProxy.Instance:GetCurMemoryFirstPveData()
  self:UpdateSubGrid(datas, entranceData.id)
end

function PveTypeCell:UpdateSubGrid(datas, chooseId)
  self.gridCtl:ResetDatas(datas)
  self.gridBg.height = #datas * gridCellHeight + gridCellHeightOffset
  self:UpdateGridChoose(chooseId)
end

function PveTypeCell:UpdateGridChoose(id)
  for i = 1, #self.gridCells do
    self.gridCells[i]:SetChoosen(id)
  end
end

function PveTypeCell:UpdateUnlock()
  if not self.data then
    return
  end
  local open = PveEntranceProxy.Instance:IsOpen(self.data.id)
  if not open then
    self:Show(self.lockRoot)
    self.lvLab.text = string.format(ZhString.Pve_Lv, tostring(self.data.staticEntranceData.UnlockLv))
  else
    self:Hide(self.lockRoot)
  end
end

function PveTypeCell:SetData(data)
  self.data = data
  if not data or not data.staticEntranceData then
    self.content:SetActive(false)
    return
  end
  local entrance_data = data.staticEntranceData
  self.raidType = entrance_data.raidType
  self.content:SetActive(true)
  self:UpdateUnlock()
  self:TryUpdateGridCtl()
  local _nameStr = entrance_data:IsCrack() and ZhString.Pve_TypeCrackNamePrefix or entrance_data:IsRoadOfHero() and ZhString.Pve_TypeHeroRoadNamePrefix or entrance_data:IsAstral() and ZhString.Pve_TypeAstralNamePrefix or ZhString.Pve_TypeNamePrefix
  self.nameLab.text = string.format(_nameStr, entrance_data.name)
  local nameStr = string.format(_nameStr, entrance_data.name)
  local _raidTypeConfig = _RaidTypeConfig[entrance_data.groupid]
  if not _raidTypeConfig then
    redlog("检查配置 GameConfig.Pve.RaidType , ID : ", self.raidType, entrance_data.groupid)
    return
  end
  self.groupid = entrance_data.groupid
  self.textureName = _raidTypeConfig.typeIcon
  if self.textureName then
    PictureManager.Instance:SetUI(self.textureName, self.texture)
  end
  self.newObj:SetActive(entrance_data:IsNew())
  self:UpdateChoose()
  self:UpdateRewardInfo(entrance_data.id)
  self:UpdateRedtip()
  if entrance_data.guideButtonId ~= nil then
    self:AddOrRemoveGuideId(self.bg, entrance_data.guideButtonId)
  end
  if entrance_data.feature and entrance_data.feature ~= "" then
    self.featureLab.gameObject:SetActive(true)
    self.featureLab.text = entrance_data.feature
  else
    self.featureLab.gameObject:SetActive(false)
  end
  if not self:IsGridType() then
    self:Hide(self.gridRoot)
    self.reverseActive = false
  end
  local isAstralRaid = entrance_data:IsAstral()
  self.seasonRemainTimeLabel.gameObject:SetActive(isAstralRaid)
  if isAstralRaid and not AstralProxy.Instance:IsSeasonNotOpen() then
    local season_suffix = string.format(ZhString.Pve_TypeNameAstralSuffix, AstralProxy.Instance:GetSeason())
    self.nameLab.text = nameStr .. season_suffix
  else
    self.nameLab.text = nameStr
  end
  if isAstralRaid then
    local season = AstralProxy.Instance:GetSeason()
    local config = Table_AstralSeason[season]
    local endTimeFormat = config and EnvChannel.IsTFBranch() and config.TfEndTime or config and config.EndTime
    local endTime = ClientTimeUtil.GetOSDateTime(endTimeFormat)
    local curTime = ServerTime.CurServerTime() / 1000
    if AstralProxy.Instance:IsSeasonEnd() then
      self.seasonRemainTimeLabel.text = ZhString.Pve_Astral_SeasonPrepareTime
    else
      local remainTime = endTime - curTime
      local day = math.floor(remainTime / 86400)
      if 1 <= day then
        local str = string.format(ZhString.Pve_Astral_SeasonRemainTime_Day, day)
        self.seasonRemainTimeLabel.text = string.format(ZhString.Pve_Astral_SeasonRemainTime, str)
      else
        local hour = math.floor(remainTime / 3600)
        if 1 <= hour then
          local str = string.format(ZhString.Pve_Astral_SeasonRemainTime_Hour, hour)
          self.seasonRemainTimeLabel.text = string.format(ZhString.Pve_Astral_SeasonRemainTime, str)
        else
          local min = math.floor(remainTime / 60)
          local str = string.format(ZhString.Pve_Astral_SeasonRemainTime_Min, min)
          self.seasonRemainTimeLabel.text = string.format(ZhString.Pve_Astral_SeasonRemainTime, str)
        end
      end
    end
  end
end

function PveTypeCell:GetGridCellById(id)
  local cells = self.gridCtl:GetCells()
  if cells then
    for i = 1, #cells do
      if cells[i].data.id == id then
        return cells[i]
      end
    end
  end
end

function PveTypeCell:UpdateRedtip()
  local hasRedTip = false
  if self.data.staticEntranceData:IsCrack() or self.data.staticEntranceData:IsBoss() or self.data.staticEntranceData:IsMemoryRaid() then
    local cells = self.gridCtl:GetCells()
    if cells then
      for _, cell in ipairs(cells) do
        cell:UpdateRedTip()
        if cell.data:HasRedTip() then
          hasRedTip = true
          break
        end
      end
    end
  else
    hasRedTip = self.data:HasRedTip()
  end
  self.redtip:SetActive(hasRedTip)
end

function PveTypeCell:OnCellDestroy()
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.texture)
  end
  self:_RemoveChoosenEntranceRedTip()
  if self.gridCtl then
    self.gridCtl:Destroy()
  end
end

function PveTypeCell:_RemoveChoosenEntranceRedTip()
  local isChoosenCell = self.data and self.chooseId and self.data.id == self.chooseId
  if not isChoosenCell then
    return
  end
  local isNewEntrance = _RedTipProxy:IsNew(_EntranceRedTipEnum, self.groupid)
  if not isNewEntrance then
    return
  end
  _RedTipProxy:SeenNew(_EntranceRedTipEnum, self.groupid)
end

function PveTypeCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
  if nil ~= self.gridUpdateFunc[self.raidType] then
    self:UpdateGridChoose(id)
  end
end

function PveTypeCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.choosenObj:SetActive(true)
  else
    self.choosenObj:SetActive(false)
  end
end

function PveTypeCell:UpdateRewardInfo(id)
  local multiply = PveEntranceProxy.Instance:TryGetRewardMultiply(id, true)
  if multiply then
    self:Show(self.multiplySymbol)
    self.multiplySymbol_label.text = "x" .. multiply
  else
    self:Hide(self.multiplySymbol)
  end
end

function PveTypeCell:IsGridType()
  if not self.data then
    return false
  end
  local entrance_data = self.data.staticEntranceData
  return entrance_data:IsCrack() or entrance_data:IsBoss() or entrance_data:IsRoadOfHero() or entrance_data:IsAstral() or entrance_data:IsMemoryRaid()
end
