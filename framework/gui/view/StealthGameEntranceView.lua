autoImport("StealthGameEntranceGameCell")
autoImport("BaseRewardItemCell")
autoImport("StealthGameEntranceAchievementCell")
StealthGameEntranceView = class("StealthGameEntranceView", BaseView)
StealthGameEntranceView.ViewType = UIViewType.NormalLayer
StealthGameEntranceView.ViewMaskAdaption = {all = 1}
local texObjStaticNameMap = {
  UIBgTex = "Sevenroyalfamilies_bg",
  SRPatternTex = "Sevenroyalfamilies_bg_decoration20",
  UIPatternTex = "calendar_bg1_picture2",
  SRPatternTex2 = "Sevenroyalfamilies_bg_decoration13"
}
local maxGameCount, sliderFullWidth, maxSliderRewardCount = 4, 700, 3
local picIns, dungeonIns

function StealthGameEntranceView:Init()
  if not picIns then
    picIns = PictureManager.Instance
    dungeonIns = DungeonProxy.Instance
  end
  StealthGameEntranceView.super.Init(self)
  self.tipData = {
    funcConfig = _EmptyTable,
    itemdata = ItemData.new()
  }
  self.infoQueriedMap = {}
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function StealthGameEntranceView:FindObjs()
  self.gpContainer = self:FindGO("GetPathContainer")
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.bannerTex = self:FindComponent("BannerTex", UITexture)
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.costSp = self:FindComponent("CostCtrl", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.gameCells = {}
  for i = 1, maxGameCount do
    self.gameCells[i] = StealthGameEntranceGameCell.new(self:FindGO("Game" .. i))
  end
  self.leftEffContainer = self:FindGO("LeftEffContainer")
  self.title = self:FindComponent("Title", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.controlToAchievement = self:FindGO("ControlToAchievement")
  self.controlToBanner = self:FindGO("ControlToBanner")
  self.achievementParent = self:FindGO("AchievementPanel")
  self.slider = self:FindComponent("Slider", UISlider)
  self.sliderRewards, self.sliderRewardLabels = {}, {}
  local obj
  for i = 1, maxSliderRewardCount do
    self.sliderRewards[i] = self:FindComponent("SliderRewards" .. i, UISprite)
    obj = self.sliderRewards[i].gameObject
    self.sliderRewardLabels[i] = self:FindComponent("Label", UILabel, obj)
    self:AddClickEvent(obj, function()
      self:OnClickSliderReward(i)
    end)
  end
  self.sliderRewardPreview = self:FindGO("SliderRewardPreview")
  self.sliderRewardsEffContainer = self:FindGO("SliderRewardsEffContainer")
end

function StealthGameEntranceView:InitView()
  self:RegistShowGeneralHelpByHelpID(35089, self:FindGO("HelpButton"))
  self.costItemId = GameConfig.Family.ItemCost
  IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costSp)
  self:UpdateCostCtrl()
  self:UpdateLeft()
  self.achievementCtrl = ListCtrl.new(self:FindComponent("Table", UITable, self.achievementParent), StealthGameEntranceAchievementCell, "StealthGameEntranceAchievementCell")
end

local costTipOffset = {160, -340}

function StealthGameEntranceView:AddEvents()
  self:AddClickEvent(self.costSp.gameObject, function()
    self:ShowItemTip(self.costItemId, self.costSp, NGUIUtil.AnchorSide.Down, costTipOffset)
  end)
  self:AddButtonEvent("CostAddBtn", function()
    local moneyCfg = GameConfig.MoneyId
    if self.costItemId == moneyCfg.Zeny then
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
    elseif self.costItemId == moneyCfg.Lottery then
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
    else
      self:ShowGetPathOfCost()
    end
  end)
  self:AddButtonEvent("EnterBtn", function()
    local id = self.raidSData and self.raidSData.id
    if not id or not self.infoQueriedMap[id] then
      LogUtility.Warning("Raid info not received. Nothing will happen.")
      return
    end
    ServiceRaidCmdProxy.Instance:CallPersonalRaidEnterCmd(id)
  end)
  self:AddButtonEvent("ResetBtn", function()
    local id = self.raidSData and self.raidSData.id
    if not id or not self.infoQueriedMap[id] then
      LogUtility.Warning("Raid info not received. Nothing will happen.")
      return
    end
    DungeonProxy.Instance:ResetClientRaid(id)
  end)
  self:AddButtonEvent("ToAchievementBtn", function()
    self:SwitchAchievement(true)
  end)
  self:AddButtonEvent("ToBannerBtn", function()
    self:SwitchAchievement(false)
  end)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ServiceEvent.RaidCmdClientQueryRaidCmd, self.OnQueryRaid)
  self:AddListenEvt(ServiceEvent.RaidCmdClientRaidAchRewardCmd, self.OnAchReward)
end

function StealthGameEntranceView:OnEnter()
  StealthGameEntranceView.super.OnEnter(self)
  local find = string.find
  for objName, texName in pairs(texObjStaticNameMap) do
    if find(objName, "UI") then
      picIns:SetUI(texName, self[objName])
    elseif find(objName, "SR") then
      picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
    end
  end
  PictureManager.ReFitFullScreen(self.UIBgTex)
  self:UpdateCostCtrl()
  self:OnClickGameCell(self.gameCells[1])
  self:SwitchAchievement(false)
end

function StealthGameEntranceView:OnExit()
  self:TryRemoveBannerTex()
  local find = string.find
  for objName, texName in pairs(texObjStaticNameMap) do
    if find(objName, "UI") then
      picIns:UnLoadUI(texName, self[objName])
    elseif find(objName, "SR") then
      picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
    end
  end
  for _, c in pairs(self.gameCells) do
    c:OnExit()
  end
  StealthGameEntranceView.super.OnExit(self)
end

function StealthGameEntranceView:OnItemUpdate()
  self:UpdateCostCtrl()
end

function StealthGameEntranceView:OnZenyChange()
  self:UpdateCostCtrl()
end

function StealthGameEntranceView:OnQueryRaid(note)
  local id = note and note.body and note.body.raidid
  if not id then
    return
  end
  self.infoQueriedMap[id] = true
  self:UpdateRight(Table_ClientRaidAchReward[id])
end

function StealthGameEntranceView:OnAchReward(note)
  local id = note and note.body and note.body.raidid
  if not id then
    return
  end
  self:UpdateSliderRewards()
end

function StealthGameEntranceView:OnClickGameCell(cell)
  local data = cell and cell.data
  if not data then
    return
  end
  if self.infoQueriedMap[data.id] then
    self:UpdateRight(data)
  else
    ServiceRaidCmdProxy.Instance:CallClientQueryRaidCmd(data.id, true)
  end
  for _, c in pairs(self.gameCells) do
    c:SetChoose(data.id)
  end
end

function StealthGameEntranceView:OnClickSliderReward(index)
  if self:CheckCanGetSliderReward(index) then
    ServiceRaidCmdProxy.Instance:CallClientRaidAchRewardCmd(self.raidSData.id, self:GetSliderRewardScore(index))
  else
    self:ShowSliderRewardPreview(index)
  end
end

function StealthGameEntranceView:OnClickSliderRewardItemCell(cell)
  if not cell.data then
    return
  end
  self:ShowItemTip(cell.itemId, cell.itemIcon, NGUIUtil.AnchorSide.Left)
end

function StealthGameEntranceView:UpdateCostCtrl()
  self.costLabel.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(self.costItemId)) or 0
end

local basicComparer = function(l, r)
  return l.id < r.id
end

function StealthGameEntranceView:UpdateLeft()
  local arr, cell = ReusableTable.CreateArray()
  for _, d in pairs(Table_ClientRaidAchReward) do
    TableUtility.ArrayPushBack(arr, d)
  end
  table.sort(arr, basicComparer)
  for i = 1, maxGameCount do
    cell = self.gameCells[i]
    if arr[i] then
      cell:Show()
      cell:SetData(arr[i])
      cell:AddEventListener(MouseEvent.MouseClick, self.OnClickGameCell, self)
    else
      cell:Hide()
    end
  end
  ReusableTable.DestroyAndClearArray(arr)
end

function StealthGameEntranceView:UpdateRight(data)
  if not data then
    LogUtility.Error("ArgumentNilException: data")
    return
  end
  self.raidSData = data
  self.title.text = Table_Map[data.id].NameZh
  self.desc.text = data.Desc
  self.sliderRewardPreview:SetActive(false)
  self:UpdateSliderRewards()
  if self.isShowAchievement then
    self:UpdateAchievements()
  end
  self:TryRemoveBannerTex()
  self.bannerTexName = data.Pic
  picIns:SetSevenRoyalFamiliesTexture(self.bannerTexName, self.bannerTex)
end

function StealthGameEntranceView:UpdateSliderRewards()
  local score, maxScore, target, canGet = dungeonIns:GetClientRaidAchievementScore(self.raidSData.id), DungeonProxy.GetClientRaidAchievementMaxScore(self.raidSData.id)
  self.slider.value = score / maxScore
  self.sliderRewardEffects = self.sliderRewardEffects or {}
  for i = 1, maxSliderRewardCount do
    target = self:GetSliderRewardScore(i)
    self.sliderRewardLabels[i].text = target
    self.sliderRewards[i].spriteName = self:CheckGotSliderReward(i) and "growup2" or "growup1"
    self.sliderRewards[i].transform.localPosition = LuaGeometry.GetTempVector3(target / maxScore * sliderFullWidth - sliderFullWidth / 2, 0)
    canGet = self:CheckCanGetSliderReward(i)
    if canGet and not self.sliderRewardEffects[i] then
      self:PlayUIEffect(EffectMap.UI.SignIn21Hint, self.sliderRewardsEffContainer, false, function(obj, args, assetEffect)
        if not self then
          assetEffect:Destroy()
          return
        end
        self.sliderRewardEffects[i] = assetEffect
        assetEffect.effectObj.transform.localPosition = self.sliderRewards[i].transform.localPosition
      end)
    elseif not canGet and self.sliderRewardEffects[i] then
      self.sliderRewardEffects[i]:Destroy()
      self.sliderRewardEffects[i] = nil
    end
  end
end

function StealthGameEntranceView:UpdateAchievements()
  if not self.achievementParent.activeSelf then
    return
  end
  local arr = ReusableTable.CreateArray()
  DungeonProxy.ForEachClientRaidAchievement(function(achData)
    TableUtility.ArrayPushBack(arr, achData)
  end, self.raidSData.id)
  table.sort(arr, basicComparer)
  self.achievementCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray(arr)
end

function StealthGameEntranceView:ShowSliderRewardPreview(index)
  local box = index and self.sliderRewards[index]
  self.sliderRewardPreview:SetActive(box ~= nil)
  if not box then
    return
  end
  if not self.sliderRewardItemCtrl then
    self.sliderRewardItemCtrl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.sliderRewardPreview), BaseRewardItemCell, "BaseRewardItemCell")
    self.sliderRewardItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSliderRewardItemCell, self)
    self.sliderRewardItemDatas = {}
  end
  local rewardId = self:GetSliderRewardId(index)
  local items = rewardId and ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if items and next(items) then
    for i = 1, #items do
      if not self.sliderRewardItemDatas[i] then
        self.sliderRewardItemDatas[i] = {}
        self.sliderRewardItemDatas[i].gotPredicate = function(rewId, itemId, num)
          return self:CheckGotSliderReward(index)
        end
      end
      self.sliderRewardItemDatas[i].rewardId = rewardId
      self.sliderRewardItemDatas[i].itemid = items[i].id
      self.sliderRewardItemDatas[i].num = items[i].num
    end
    for i = #items + 1, #self.sliderRewardItemDatas do
      self.sliderRewardItemDatas[i] = nil
    end
  end
  self.sliderRewardItemCtrl:ResetDatas(self.sliderRewardItemDatas)
  self.sliderRewardPreview.transform.position = box.transform.position
end

function StealthGameEntranceView:SwitchAchievement(isOn)
  isOn = isOn and true or false
  self.isShowAchievement = isOn
  self.controlToAchievement:SetActive(not isOn)
  self.controlToBanner:SetActive(isOn)
  self.achievementParent:SetActive(isOn)
  if isOn then
    self:UpdateAchievements()
  end
end

function StealthGameEntranceView:CheckCanGetSliderReward(index)
  local id = self.raidSData and self.raidSData.id
  if not id then
    return false
  end
  return self:GetSliderRewardScore(index) <= dungeonIns:GetClientRaidAchievementScore(id) and not self:CheckGotSliderReward(index)
end

function StealthGameEntranceView:CheckGotSliderReward(index)
  local id = self.raidSData and self.raidSData.id
  if not id then
    return true
  end
  return dungeonIns:CheckClientRaidAchRewarded(id, self:GetSliderRewardScore(index))
end

function StealthGameEntranceView:GetSliderRewardScore(index)
  local cfg = self:GetSliderRewardConfig(index)
  return cfg and cfg.Point
end

function StealthGameEntranceView:GetSliderRewardId(index)
  local cfg = self:GetSliderRewardConfig(index)
  return cfg and cfg.Reward
end

function StealthGameEntranceView:GetSliderRewardConfig(index)
  return index and self.raidSData and self.raidSData.PointToReward[index]
end

function StealthGameEntranceView:ShowGetPathOfCost()
  if self.bdt then
    self.bdt:OnExit()
  elseif self.costItemId then
    self.bdt = GainWayTip.new(self.gpContainer)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(self.costItemId)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function StealthGameEntranceView:GetPathCloseCall()
  self.bdt = nil
end

function StealthGameEntranceView:TryRemoveBannerTex()
  if not self.bannerTexName then
    return
  end
  picIns:UnloadSevenRoyalFamiliesTexture(self.bannerTexName, self.bannerTex)
end

local defaultTipOffset = {0, 0}

function StealthGameEntranceView:ShowItemTip(itemId, stick, side, offset)
  self.tipData.itemdata:ResetData("Tip", itemId)
  if not offset then
    offset = defaultTipOffset
    offset[1] = side == NGUIUtil.AnchorSide.Left and -220 or 260
  end
  StealthGameEntranceView.super.ShowItemTip(self, self.tipData, stick, side, offset)
end
