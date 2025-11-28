autoImport("RaidPuzzleBuffCell")
autoImport("RaidPuzzleInfoCell")
autoImport("RewardGridCell")
MainViewRaidPuzzleBordPage = class("MainViewRaidPuzzleBordPage", CoreView)
local normalBoxId = 817508
local luxuryBoxId = 817507
local treasureInfo = {
  [1] = {icon = "item_may1", checkItem = 6766},
  [2] = {icon = "item_may2", checkItem = 6767},
  [3] = {icon = "item_6746"},
  [4] = {icon = "item_6745"}
}

function MainViewRaidPuzzleBordPage:ctor(go)
  MainViewRaidPuzzleBordPage.super.ctor(self, go)
  self:Init()
end

function MainViewRaidPuzzleBordPage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddMapEvts()
end

function MainViewRaidPuzzleBordPage:FindObjs()
  self.subTitle = self:FindGO("SubTitle"):GetComponent(UILabel)
  self.detailBtn = self:FindGO("DetailBtn")
  self.detailBtnRedTip = self:FindGO("RedTipCell", self.detailBtn)
  self.treasureInfoCells = {}
  for i = 1, 4 do
    self.treasureInfoCells[i] = {}
    self.treasureInfoCells[i].obj = self:FindGO("ItemCell" .. i)
    self.treasureInfoCells[i].icon = self:FindGO("Icon", self.treasureInfoCells[i].obj):GetComponent(UISprite)
    self.treasureInfoCells[i].num = self:FindGO("Num", self.treasureInfoCells[i].obj):GetComponent(UILabel)
  end
  self.detailPanel = self:FindGO("MayPalaceDetailInfoBord")
  self.detailPanelComp = self.detailPanel:GetComponent(CloseWhenClickOtherPlace)
  self.detailPanel:SetActive(false)
  local detailBuffTog = self:FindGO("BuffTog")
  self.buffTog = detailBuffTog:GetComponent(UIToggle)
  local detailInfoTog = self:FindGO("InfoTog")
  self.infoTog = detailInfoTog:GetComponent(UIToggle)
  self.infoRedTip = self:FindGO("RedTipCell", detailInfoTog)
  local detailRewardTog = self:FindGO("RewardTog")
  self.rewardTog = detailRewardTog:GetComponent(UIToggle)
  self.infoScrollView = self:FindGO("InfoScrollView"):GetComponent(UIScrollView)
  self.buffTable = self:FindGO("buffTable")
  local grid1 = self.buffTable:GetComponent(UITable)
  self.buffCtl = UIGridListCtrl.new(grid1, RaidPuzzleBuffCell, "RaidPuzzleBuffCell")
  self.infoTable = self:FindGO("InfoTable")
  local grid2 = self.infoTable:GetComponent(UITable)
  self.infoCtl = UIGridListCtrl.new(grid2, RaidPuzzleInfoCell, "RaidPuzzleBuffCell")
  self.rewardGrid = self:FindGO("rewardGrid")
  local grid3 = self.rewardGrid:GetComponent(UIGrid)
  self.rewardCtl = UIGridListCtrl.new(grid3, RewardGridCell, "RewardGridCell")
  
  function self.detailPanelComp.callBack(go)
    self.detailPanel:SetActive(false)
  end
  
  self:AddClickEvent(detailBuffTog, function(go)
    self:UpdateDetailInfo(1)
  end)
  self:AddClickEvent(detailInfoTog, function(go)
    self:UpdateDetailInfo(2)
  end)
  self:AddClickEvent(detailRewardTog, function(go)
    self:UpdateDetailInfo(3)
  end)
  self:AddClickEvent(self.detailBtn, function()
    self.detailPanel:SetActive(not self.detailPanel.activeSelf)
    self:UpdateDetailInfo(self.curTog)
  end)
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function MainViewRaidPuzzleBordPage:AddMapEvts()
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.UpdateTreasureInfos, self)
  EventManager.Me():AddEventListener(PVEEvent.RaidPuzzle_RefreshBordInfos, self.HandleInfoUpdate, self)
  EventManager.Me():AddEventListener(PVEEvent.RaidPuzzle_RefreshDescInfos, self.HandleDescUpdate, self)
end

function MainViewRaidPuzzleBordPage:InitDatas()
  local curMapid = Game.MapManager:GetMapID()
  self.config = GameConfig.RaidPuzzle[curMapid]
  local raidRewardIds = RaidPuzzleProxy.Instance.raidPuzzleRewards[curMapid]
  if not raidRewardIds then
    redlog("没有当前副本id", self.curRaidId, "对应的奖励ids")
    return
  end
  local luxuryBoxNum = 0
  local normalBoxNum = 0
  for i = 1, #raidRewardIds do
    if Table_RaidPushAreaObj[curMapid][raidRewardIds[i]].NpcID == luxuryBoxId then
      luxuryBoxNum = luxuryBoxNum + 1
    elseif Table_RaidPushAreaObj[curMapid][raidRewardIds[i]].NpcID == normalBoxId then
      normalBoxNum = normalBoxNum + 1
    end
  end
  self.luxuryBoxMax = luxuryBoxNum
  self.normalBoxMax = normalBoxNum
  local keyLimit = self.config.keyItemLimit
  for i = 1, 4 do
    IconManager:SetItemIcon(treasureInfo[i].icon, self.treasureInfoCells[i].icon)
    if treasureInfo[i].checkItem then
      local ownCount = BagProxy.Instance:GetItemNumByStaticID(treasureInfo[i].checkItem, GameConfig.PackageMaterialCheck.Exist)
      local maxLimit = keyLimit and keyLimit[treasureInfo[i].checkItem] or 99
      self.treasureInfoCells[i].num.text = ownCount .. "/" .. maxLimit
    end
  end
  self:RefreshBoxInfo()
  self.curTog = 1
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.initInfo = false
end

function MainViewRaidPuzzleBordPage:UpdateTreasureInfos()
  redlog("道具刷新，刷新钥匙持有情况")
  local keyLimit = self.config.keyItemLimit
  for i = 1, 2 do
    if treasureInfo[i].checkItem then
      local ownCount = BagProxy.Instance:GetItemNumByStaticID(treasureInfo[i].checkItem, GameConfig.PackageMaterialCheck.Exist)
      local maxLimit = keyLimit and keyLimit[treasureInfo[i].checkItem] or 99
      self.treasureInfoCells[i].num.text = ownCount .. "/" .. maxLimit
    end
  end
  self:RefreshBoxInfo()
end

function MainViewRaidPuzzleBordPage:RefreshBoxInfo()
  local curMapid = Game.MapManager:GetMapID()
  local boxes = RaidPuzzleProxy.Instance.puzzleRaidBoxes or {}
  local getLuxuryBoxNum = 0
  local getNormalBoxNum = 0
  local mapInfo = Table_RaidPushAreaObj[curMapid]
  if not mapInfo then
    redlog("当前地图不属于美之宫")
    return
  end
  if boxes and 0 < #boxes then
    for i = 1, #boxes do
      if mapInfo and mapInfo[boxes[i]] and mapInfo[boxes[i]].NpcID == luxuryBoxId then
        getLuxuryBoxNum = getLuxuryBoxNum + 1
      elseif mapInfo and mapInfo[boxes[i]] and mapInfo[boxes[i]].NpcID == normalBoxId then
        getNormalBoxNum = getNormalBoxNum + 1
      end
    end
  end
  self.treasureInfoCells[3].num.text = getLuxuryBoxNum .. "/" .. self.luxuryBoxMax
  self.treasureInfoCells[4].num.text = getNormalBoxNum .. "/" .. self.normalBoxMax
end

function MainViewRaidPuzzleBordPage:HandleInfoUpdate()
  helplog("美之宫状态信息刷新")
  self:RefreshBoxInfo()
  self:UpdateTarget()
end

function MainViewRaidPuzzleBordPage:HandleDescUpdate()
  self:UpdateInfoTogRedTip()
end

function MainViewRaidPuzzleBordPage:UpdateTarget()
  local targetStr = RaidPuzzleProxy.Instance.puzzleRaidTarget
  if targetStr and targetStr ~= "" then
    if self.subTitle.text ~= targetStr then
      MsgManager.FloatRainbowMsgTableParam("", targetStr)
    end
    self.subTitle.text = targetStr
  else
    self.subTitle.text = ZhString.NpcTip_None
  end
end

function MainViewRaidPuzzleBordPage:UpdateDetailInfo(id)
  if id == 1 then
    self.buffTog.value = true
    self.buffTable:SetActive(true)
    self.infoTable:SetActive(false)
    self.rewardGrid:SetActive(false)
    local buffData = RaidPuzzleProxy.Instance.puzzleRaidBuffs
    if not buffData then
      return
    end
    self.buffCtl:ResetDatas(buffData)
  elseif id == 2 then
    self.infoTog.value = true
    self.buffTable:SetActive(false)
    self.infoTable:SetActive(true)
    self.rewardGrid:SetActive(false)
    local infoDatas = RaidPuzzleProxy.Instance.puzzleRaidDescs
    self.infoCtl:ResetDatas(infoDatas)
    self.infoRedTip:SetActive(false)
    self.detailBtnRedTip:SetActive(false)
  elseif id == 3 then
    self.rewardTog.value = true
    self.buffTable:SetActive(false)
    self.infoTable:SetActive(false)
    self.rewardGrid:SetActive(true)
    local tempItemList = {}
    self:UpdateTreasures(tempItemList)
    self.rewardCtl:ResetDatas(tempItemList)
  end
  self.infoScrollView:ResetPosition()
  self.curTog = id
end

function MainViewRaidPuzzleBordPage:UpdateTreasures(itemList)
  local curMapid = Game.MapManager:GetMapID()
  if self.config then
    local targetList = self.config.show_item
    if targetList and 0 < #targetList then
      for i = 1, #targetList do
        local single = targetList[i]
        local ownCount = BagProxy.Instance:GetItemNumByStaticID(single, GameConfig.PackageMaterialCheck.Exist)
        if 0 < ownCount then
          local data = {}
          data.itemData = ItemData.new("Reward", single)
          data.num = ownCount
          table.insert(itemList, data)
        end
      end
    end
  else
    redlog("noconfig")
  end
end

function MainViewRaidPuzzleBordPage:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, -150})
  end
end

function MainViewRaidPuzzleBordPage:UpdateInfoTogRedTip()
  if self.initInfo == false then
    self.initInfo = true
    return
  end
  self.infoRedTip:SetActive(true)
  self.detailBtnRedTip:SetActive(true)
end

function MainViewRaidPuzzleBordPage:OnHide()
  redlog("关闭美之宫界面")
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.UpdateTreasureInfos, self)
  EventManager.Me():RemoveEventListener(PVEEvent.RaidPuzzle_RefreshBordInfos, self.HandleInfoUpdate, self)
  EventManager.Me():RemoveEventListener(PVEEvent.RaidPuzzle_RefreshDescInfos, self.HandleDescUpdate, self)
end
