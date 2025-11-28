DisneyHappyPointPanel = class("DisneyHappyPointPanel", BaseView)
DisneyHappyPointPanel.ViewType = UIViewType.PopUpLayer
autoImport("DisneyHappyGoodCell")
autoImport("DisneyHappyPointRewardCell")
autoImport("HappyShopBuyItemCell")
local tempVector3 = LuaVector3.Zero()
local DisneyHappyValueShopType = GameConfig.HappyValue.ShopType or 20171
local DisneyHappyValueShopId = GameConfig.HappyValue.ShopId or 1

function DisneyHappyPointPanel:Init()
  self:InitUI()
  self:AddEvts()
  self:AddListenEvts()
  self:InitData()
  self:InitShow()
end

function DisneyHappyPointPanel:InitUI()
  self.helpBtn = self:FindGO("HelpBtn")
  self.closeBtn = self:FindGO("CloseBtn")
  local scorePart = self:FindGO("ScorePart")
  self.scoreIcon = self:FindGO("IconSprite", scorePart):GetComponent(UISprite)
  self.scoreLabel = self:FindGO("Score", scorePart):GetComponent(UILabel)
  local itemId = 165
  local itemData = Table_Item[itemId]
  if not itemData then
    redlog("Item表缺少配置", itemId)
  end
  IconManager:SetItemIcon(itemData.Icon, self.scoreIcon)
  local scoreLimit = self:FindGO("ScoreLimit")
  self.scoreLimitLabel = scoreLimit:GetComponent(UILabel)
  self.scoreLimitTip = self:FindGO("ScoreLimitTip", scoreLimit):GetComponent(UILabel)
  self.shopScrollView = self:FindGO("ShopScrollView"):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("ShopGrid"):GetComponent(UIGrid)
  self.shopCtrl = UIGridListCtrl.new(self.shopGrid, DisneyHappyGoodCell, "DisneyHappyGoodCell")
  self.shopCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  
  function self.shopScrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
  
  self.timeLimitTip = self:FindGO("TimeLimitTip"):GetComponent(UILabel)
  self.sliderScrollView = self:FindGO("SliderScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, DisneyHappyPointRewardCell, "DisneyHappyPointRewardCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickRewardItem, self)
  local allServerProcess = self:FindGO("AllServerProcess")
  self.processLabel = self:FindGO("ProcessLabel", allServerProcess):GetComponent(UILabel)
  self.processTip = self:FindGO("ProcessTip", allServerProcess):GetComponent(UILabel)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
end

function DisneyHappyPointPanel:InitShow()
  self:RefreshHappyValue()
end

function DisneyHappyPointPanel:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function DisneyHappyPointPanel:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.buyCell.gameObject:SetActive(false)
end

function DisneyHappyPointPanel:AddEvts()
  self:TryOpenHelpViewById(1594, nil, self.helpBtn)
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function DisneyHappyPointPanel:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserHappyValueUserCmd, self.RefreshHappyValue)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateMoney)
end

function DisneyHappyPointPanel:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.rewardIndices = {}
end

function DisneyHappyPointPanel:RecvQueryShopConfig(note)
  xdlog("迪士尼欢乐值界面刷新商店")
  self:UpdateShopInfo()
end

function DisneyHappyPointPanel:UpdateShopInfo()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(DisneyHappyValueShopType, DisneyHappyValueShopId)
  if not self.shopItems then
    self.shopItems = {}
  else
    TableUtility.ArrayClear(self.shopItems)
  end
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, k)
    end
  end
  table.sort(self.shopItems, HappyShopProxy._SortItem)
  self.shopCtrl:ResetDatas(self.shopItems)
end

function DisneyHappyPointPanel:UpdateRewardInfo()
  local curServer = FunctionLogin.Me():getCurServerData()
  local curServerID = curServer.linegroup or 1
  local config = GameConfig.HappyValue.ServerHappy
  if not config then
    redlog("GameConfig缺少HappyValue.ServerHappy")
    return
  end
  local happyValueList = config[curServerID]
  if not happyValueList then
    redlog("ServerHappy缺少服务器信息", curServerID)
    return
  end
  local datas = {}
  for i = 1, #happyValueList do
    local lastProcess = 0
    if i - 1 > 0 then
      lastProcess = happyValueList[i - 1][2]
    end
    local isGot = 0 < TableUtility.ArrayFindIndex(self.rewardIndices, happyValueList[i][1])
    local data = {
      id = happyValueList[i][1],
      lastProcess = lastProcess,
      process = happyValueList[i][2],
      itemId = happyValueList[i][3],
      canGet = not isGot
    }
    table.insert(datas, data)
  end
  self.rewardCtrl:ResetDatas(datas)
end

function DisneyHappyPointPanel:RefreshHappyValue(data)
  xdlog("全服进度更新", DisneyProxy.Instance.allServerHappyValue)
  self.totalServerProcess = DisneyProxy.Instance.allServerHappyValue or 0
  self.rewardIndices = DisneyProxy.Instance.happyValueIndices or {}
  local tempValue = self.totalServerProcess
  if self.totalServerProcess < 10000 then
    self.processLabel.text = self.totalServerProcess
  elseif self.totalServerProcess > 10000 then
    local millionNum = math.modf(tempValue / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(tempValue, 1000000) / 1000) .. "K"
    self.processLabel.text = 0 < millionNum and millionNum .. "M\n" .. thousandStr or thousandStr
  end
  self:UpdateMoney()
  self:UpdateRewardInfo()
end

function DisneyHappyPointPanel:UpdateMoney()
  local own = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HAPPYVALUE) or 0
  local dailyOwn = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_HAPPYVALUE_DAY) or 0
  self.scoreLabel.text = own
  local maxLimit = GameConfig.HappyValue.DailyLimit or 100
  self.scoreLimitLabel.text = dailyOwn .. "/" .. maxLimit
end

function DisneyHappyPointPanel:HandleClickGood(cellctl)
  xdlog("点选商品")
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(DisneyHappyValueShopType, DisneyHappyValueShopId, cellctl.goodsID)
  local itemdata = data:GetItemData()
  if data and data.goodsID and itemdata then
    self.tipData.itemdata = itemdata
    if LevelItem[data.goodsID] then
      local count = TwelvePvPProxy.Instance:GetRaidItemNum(data.goodsID) + 1
      if count > #LevelItem[data.goodsID] then
        count = count - 1
      end
      self.tipData.itemdata.staticData.Desc = LevelItem[data.goodsID][count] and LevelItem[data.goodsID][count].desc or self.tipData.itemdata.staticData.Desc
    end
    self:ShowItemTip(self.tipData, self.LeftStick)
  end
end

function DisneyHappyPointPanel:HandleClickItem(cellctl)
  xdlog("点选商品", cellctl.data)
  if self.currentItem ~= cellctl then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.currentItem = cellctl
  end
  local id = cellctl.data
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(DisneyHappyValueShopType, DisneyHappyValueShopId, id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

function DisneyHappyPointPanel:HandleClickRewardItem(cellctl)
  local data = cellctl.data
  local targetId = data.id
  xdlog("点选奖励", targetId)
  local enableGetReward = cellctl.enableGetReward
  if enableGetReward then
    ServiceNUserProxy.Instance:CallHappyValueUserCmd(nil, {targetId})
  else
    local rewardItemId = data.itemId
    self.tipData.itemdata = ItemData.new("Reward", rewardItemId)
    self:ShowItemTip(self.tipData, cellctl.itemIcon, NGUIUtil.AnchorSide.Center, {200, -50})
  end
end

function DisneyHappyPointPanel:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      local positionX, positionY = self:GetScreenTouchedPos()
      if 0 < positionX then
        self.buyCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-217, 0, 0)
      elseif positionX < 0 then
        self.buyCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(300, 0, 0)
      end
      self.buyCell:SetData(data)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end

function DisneyHappyPointPanel:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("HarpView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function DisneyHappyPointPanel:OnEnter()
  DisneyHappyPointPanel.super.OnEnter(self)
  ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(DisneyHappyValueShopType, DisneyHappyValueShopId)
  ServiceNUserProxy.Instance:CallHappyValueUserCmd()
  HappyShopProxy.Instance:InitShop(nil, DisneyHappyValueShopId, DisneyHappyValueShopType)
end

function DisneyHappyPointPanel:OnExit()
  DisneyHappyPointPanel.super.OnExit(self)
end
