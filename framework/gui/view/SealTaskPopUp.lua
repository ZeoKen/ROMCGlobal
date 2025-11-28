autoImport("SimpleItemCell")
autoImport("SealMapCell")
SealTaskPopUp = class("SealTaskPopUp", ContainerView)
SealTaskPopUp.ViewType = UIViewType.PopUpLayer
local mapPic = "map"

function SealTaskPopUp:Init()
  self.costID = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.costID
  self:InitView()
  self:AddUIEvts()
  self:MapEvent()
end

function SealTaskPopUp:InitView()
  self.sealInfoBord = self:FindGO("SealInfoBord")
  self.sealInfoBord:SetActive(false)
  self.selectEffect = self:FindGO("SelectEffect")
  self:PlayUIEffect(EffectMap.UI.Selected, self.selectEffect)
  self.dailyTime = self:FindComponent("DailyTime", UILabel)
  self.posLabel = self:FindComponent("PosName", UILabel)
  self.sealTip = self:FindComponent("SealTip", UILabel)
  local dropGrid = self:FindComponent("DropGrid", UIGrid)
  self.dropCtl = UIGridListCtrl.new(dropGrid, SimpleItemCell, "SimpleItemCell")
  self.dropCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  self.getBtn = self:FindGO("GetButton")
  self.getButtonSprite = self.getBtn:GetComponent(UISprite)
  self.getBtnLab = self:FindComponent("Label", UILabel, self.getBtn)
  self:InitMap()
  self.addCountTip = self:FindComponent("AddCountTip", UILabel)
  self.sealBg = self:FindComponent("SealBg", UISprite)
  self.quickFinishRoot = self:FindGO("QuickFinishRoot")
  self.quickFinishRoot:SetActive(nil ~= self.costID)
  self.getBtn:SetActive(nil == self.costID)
  self.quickFinishBtn = self:FindGO("QuickFinishBtn")
  self.quickFinishCost = self:FindComponent("Cost", UILabel, self.quickFinishBtn)
  self.quickCostIcon = self:FindComponent("Icon", UISprite, self.quickFinishBtn)
  self.quickFinishAllBtn = self:FindGO("QuickFinishAllBtn")
  self.quickFinishAllCost = self:FindComponent("Cost", UILabel, self.quickFinishAllBtn)
  self.quickAllCostIcon = self:FindComponent("Icon", UISprite, self.quickFinishAllBtn)
  local quickFinishLab = self:FindComponent("Content", UILabel, self.quickFinishBtn)
  quickFinishLab.text = ZhString.SealTaskPopUp_QuickFinish
  quickFinishLab = self:FindComponent("Content", UILabel, self.quickFinishAllBtn)
  quickFinishLab.text = ZhString.SealTaskPopUp_QuickFinishAll
end

function SealTaskPopUp:AddUIEvts()
  self:AddClickEvent(self.quickFinishBtn, function(go)
    self:OnClickQuickFinish(false)
  end)
  self:AddClickEvent(self.quickFinishAllBtn, function(go)
    self:OnClickQuickFinish(true)
  end)
  self:AddClickEvent(self.getBtn, function(go)
    self:TakeSeal()
  end)
  self:AddButtonEvent("CloseSealInfo", function(go)
    self.selectData = nil
    self.selectEffect:SetActive(false)
    self:UpdateSelectSealInfo()
  end)
end

function SealTaskPopUp:OnClickQuickFinish(finishAll)
  if not self.selectData or not self.costPrice then
    return
  end
  local leftNum = GameConfig.Seal.maxSealNum - SealProxy.GetSealVarValue()
  if leftNum <= 0 then
    MsgManager.ShowMsgByID(38018)
    return
  end
  local own = BagProxy.Instance:GetItemNumByStaticID(self.costID, GameConfig.PackageMaterialCheck.default)
  local cost = finishAll and self.costPrice * leftNum or self.costPrice
  if own < cost then
    MsgManager.ShowMsgByID(38199)
    return
  elseif not LocalSaveProxy.Instance:GetDontShowAgain(1600) then
    MsgManager.DontAgainConfirmMsgByID(1600, function()
      ServiceSceneSealProxy.Instance:CallBeginSeal(self.selectData.sealData.id, SceneSeal_pb.EFINISHTYPE_QUICK_NOPROCESS, finishAll)
    end, nil, nil, cost)
  else
    ServiceSceneSealProxy.Instance:CallBeginSeal(self.selectData.sealData.id, SceneSeal_pb.EFINISHTYPE_QUICK_NOPROCESS, finishAll)
  end
end

function SealTaskPopUp:TakeSeal(cellctl)
  local aceptSeal = SealProxy.Instance.nowAcceptSeal
  local imLeader = TeamProxy.Instance:CheckIHaveLeaderAuthority()
  if TeamProxy.Instance:IHaveTeam() and imLeader then
    local data = self.selectData
    if data then
      local acceptSeal = data.acceptSeal
      local sealData = data.sealData
      if acceptSeal then
        MsgManager.ConfirmMsgByID(1609, function()
          if acceptSeal then
            self.abadonSealId = sealData.id
          else
            self.acceptSealId = sealData.id
          end
          ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal)
        end, nil, nil)
      elseif aceptSeal and aceptSeal ~= 0 then
        MsgManager.ConfirmMsgByID(1609, function()
          if acceptSeal then
            self.abadonSealId = sealData.id
          else
            self.acceptSealId = sealData.id
          end
          ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal)
        end, nil, nil)
      else
        if acceptSeal then
          self.abadonSealId = sealData.id
        else
          self.acceptSealId = sealData.id
        end
        ServiceSceneSealProxy.Instance:CallSealAcceptCmd(sealData.id, acceptSeal)
      end
    end
  else
    MsgManager.ShowMsgByIDTable(1611)
  end
end

function SealTaskPopUp:InitMap()
  self.map = self:FindComponent("Map", UITexture)
  self.mapGrid = self:FindComponent("MapGrid", UIGrid)
  self.mapGrid.maxPerLine = WorldMapProxy.Size_X
  PictureManager.Instance:SetMap(mapPic, self.map)
  self.mapCtl = UIGridListCtrl.new(self.mapGrid, SealMapCell, "SealMapCell")
  self.mapCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self)
  local sealMapDatas = {}
  local areaDatas = WorldMapProxy.Instance:GetMapAreaDatas()
  for i = 1, #areaDatas do
    local data = areaDatas[i]
    local sealMapData = {}
    if type(data) == "table" then
      sealMapData.index = data.index
      sealMapData.mapData = data
    elseif type(data) == "number" then
      sealMapData.index = data
    end
    table.insert(sealMapDatas, sealMapData)
  end
  self.mapCtl:ResetDatas(sealMapDatas)
end

function SealTaskPopUp:ClickMapCell(cellctl)
  local data = cellctl and cellctl.data
  if data and data.sealData then
    self.selectData = data
    self.selectEffect.transform:SetParent(cellctl.gameObject.transform, false)
    self.selectEffect:SetActive(true)
  end
  self:UpdateSelectSealInfo()
end

function SealTaskPopUp:ClickDropItem(cellctl)
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.gameObject
  local newChooseId = data and data.staticData.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
    local callback = function()
      self.chooseId = 0
    end
    local sdata = {
      itemdata = data,
      funcConfig = {},
      ignoreBounds = {go},
      hideGetPath = true,
      callback = callback
    }
    local stick = go:GetComponent(UIWidget)
    self:ShowItemTip(sdata, stick, nil, {200, -100})
  else
    self:ShowItemTip()
    self.chooseId = 0
  end
end

function SealTaskPopUp:GetMapCellByMapId(mapid)
  local mapdata = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapid)
  local cellIndex = (mapdata.y - 1) * WorldMapProxy.Size_X + mapdata.x
  local cells = self.mapCtl:GetCells()
  return cells[cellIndex]
end

function SealTaskPopUp:UpdateSealTasks()
  local list = SealProxy.Instance.nowSealTasks
  local aceptSealId, aceptSeal, firstSealMap = SealProxy.Instance.nowAcceptSeal
  for i = 1, #list do
    local sealid = list[i]
    local rsdata = sealid and Table_RepairSeal[sealid]
    if rsdata then
      local mapid = rsdata.MapID
      local mapCell = self:GetMapCellByMapId(mapid)
      if mapCell then
        local data = mapCell.data
        data.sealData = rsdata
        if rsdata.id == aceptSealId then
          data.acceptSeal = true
          aceptSeal = data
        else
          data.acceptSeal = false
        end
        mapCell:SetData(data)
        if i == 1 then
          firstSealMap = mapCell
        end
      end
    end
  end
  if self.selectData == nil then
    self:ClickMapCell(firstSealMap)
  end
end

function SealTaskPopUp:UpdateSealRepairTimes()
  local donetimes = SealProxy.GetSealVarValue()
  local maxtimes = GameConfig.Seal.maxSealNum
  donetimes = donetimes < maxtimes and donetimes or maxtimes
  self.dailyTime.text = donetimes .. "/" .. maxtimes
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.Seal)
  local extratimes = rewardInfo and rewardInfo:GetExtraTimes() or 0
  if 0 < extratimes then
    self.addCountTip.gameObject:SetActive(true)
    self.addCountTip.text = string.format(ZhString.SealTaskPopUp_ExtraTimesTip, extratimes)
  else
    self.addCountTip.gameObject:SetActive(false)
  end
  self:UpdateQuickFinishInfo()
end

function SealTaskPopUp:UpdateSelectSealInfo()
  local data = self.selectData
  if not data then
    self.sealInfoBord:SetActive(false)
    return
  end
  self.sealInfoBord:SetActive(true)
  if data.acceptSeal then
    self.getBtnLab.text = ZhString.SealTaskPopUp_GiveUp
    self.getBtnLab.effectColor = Color(0.8117647058823529, 0.10980392156862745, 0.058823529411764705)
    self.getButtonSprite.spriteName = "com_btn_0"
  else
    self.getBtnLab.text = ZhString.SealTaskPopUp_Accept
    self.getBtnLab.effectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882)
    self.getButtonSprite.spriteName = "com_btn_2s"
  end
  local sealData = data.sealData
  self.sealTip.text = sealData.Text or ""
  self.posLabel.text = data.sealData.Map
  local reward, chooseReward = {}, {}
  if sealData and sealData.reward then
    for _, rewardTeamId in pairs(sealData.reward) do
      local items = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamId)
      for _, item in pairs(items) do
        if Table_Item[item.id] then
          table.insert(reward, ItemData.new("SealReward", item.id))
        end
      end
    end
  end
  table.sort(reward, function(itemA, itemB)
    local isAEquip = itemA.equipInfo ~= nil
    local isBEquip = itemB.equipInfo ~= nil
    if isAEquip ~= isBEquip then
      return isAEquip
    end
    local aQuality = itemA.staticData.Quality
    local bQuality = itemB.staticData.Quality
    if aQuality ~= bQuality then
      return aQuality > bQuality
    end
    return itemA.staticData.id > itemB.staticData.id
  end)
  for i = 1, #reward do
    table.insert(chooseReward, reward[i])
    if 3 <= #chooseReward then
      break
    end
  end
  self.dropCtl:ResetDatas(chooseReward)
  self:UpdateQuickFinishInfo()
end

function SealTaskPopUp:UpdateQuickFinishInfo()
  local sealData = self.selectData and self.selectData.sealData
  if not self.costID or not sealData then
    return
  end
  self.costPrice = SealProxy.GetQuickCost(sealData.MapID)
  self.quickFinishCost.text = self.costPrice
  self.quickFinishAllCost.text = self.costPrice * (GameConfig.Seal.maxSealNum - SealProxy.GetSealVarValue())
  local iconName = Table_Item[self.costID] and Table_Item[self.costID].Icon
  IconManager:SetItemIcon(iconName, self.quickCostIcon)
  IconManager:SetItemIcon(iconName, self.quickAllCostIcon)
end

function SealTaskPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SceneSealSealQueryList, self.UpdateSealTasks)
  self:AddListenEvt(ServiceEvent.SceneSealSealAcceptCmd, self.HandleAcceptSeal)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateSealRepairTimes)
end

function SealTaskPopUp:HandleAcceptSeal(note)
  if self.acceptSealId then
    local sealData = Table_RepairSeal[self.acceptSealId]
    if sealData then
      MsgManager.ShowMsgByIDTable(1614, sealData.Map)
    end
  elseif self.abadonSealId then
    local sealData = Table_RepairSeal[self.abadonSealId]
    if sealData then
      MsgManager.ShowMsgByIDTable(1615, sealData.Map)
    end
  end
  self.acceptSealId = nil
  self.abadonSealId = nil
  self:UpdateSealTasks()
  self:UpdateSelectSealInfo()
end

function SealTaskPopUp:OnEnter()
  SealTaskPopUp.super.OnEnter(self)
  ServiceSceneSealProxy.Instance:CallSealQueryList()
  self:UpdateSealRepairTimes()
end

function SealTaskPopUp:OnExit()
  PictureManager.Instance:UnLoadMap(mapPic, self.map)
  SealTaskPopUp.super.OnExit(self)
end
