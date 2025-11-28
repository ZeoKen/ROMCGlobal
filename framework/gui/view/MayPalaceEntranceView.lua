autoImport("RewardGridCell")
MayPalaceEntranceView = class("MayPalaceEntranceView", ContainerView)
MayPalaceEntranceView.ViewType = UIViewType.NormalLayer
local normalBoxId = 817508
local luxuryBoxId = 817507

function MayPalaceEntranceView:Init()
  self:InitDatas()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitStatic()
end

function MayPalaceEntranceView:InitDatas()
  self.saveRaidId = 1003515
  if self.saveRaidId < 2 then
    self.saveRaidId = 1003515
  end
  self.curRaidId = self.saveRaidId
  self.totalChapter = 0
  self.floorInfo = {}
  for k, v in pairs(GameConfig.RaidPuzzle) do
    if type(k) == "number" then
      if v.floor then
        self.floorInfo[v.floor] = {raidid = k}
        self.totalChapter = self.totalChapter + 1
      end
      if self.saveRaidId == k then
        self.curFloor = v.floor
      end
    end
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.luxuryBoxMax = 0
  self.normalBoxMax = 0
end

function MayPalaceEntranceView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self.raidTexture = self:FindGO("RaidTexture"):GetComponent(UITexture)
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.leftIndicator_Icon = self.leftIndicator:GetComponent(UISprite)
  self.leftIndicator_bc = self.leftIndicator:GetComponent(BoxCollider)
  self.leftIndicator_TweenPos = self.leftIndicator:GetComponent(TweenPosition)
  self.rightIndicator = self:FindGO("RightIndicator")
  self.rightIndicator_Icon = self.rightIndicator:GetComponent(UISprite)
  self.rightIndicator_bc = self.rightIndicator:GetComponent(BoxCollider)
  self.rightIndicator_TweenPos = self.rightIndicator:GetComponent(TweenPosition)
  self.rewardProcess = self:FindGO("RewardProcess")
  self.luxuryBox = self:FindGO("LuxuryBox")
  self.luxuryBoxIcon = self:FindGO("Icon", self.luxuryBox):GetComponent(UISprite)
  self.luxurySlider = self:FindGO("SliderBar", self.luxuryBox):GetComponent(UISlider)
  self.luxuryLabel = self:FindGO("Label", self.luxuryBox):GetComponent(UILabel)
  self.normalBox = self:FindGO("NormalBox")
  self.normalBoxIcon = self:FindGO("Icon", self.normalBox):GetComponent(UISprite)
  self.normalSlider = self:FindGO("SliderBar", self.normalBox):GetComponent(UISlider)
  self.normalLabel = self:FindGO("Label", self.normalBox):GetComponent(UILabel)
  self.rewardPanel = self:FindGO("RewardPanel")
  self.rewardPanel:SetActive(false)
  self.rewardPanelComp = self.rewardPanel:GetComponent(CloseWhenClickOtherPlace)
  self.rewardGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.resetBtn = self:FindGO("ResetBtn")
  self.statrBtn = self:FindGO("StartBtn")
  self.statrBtn_BC = self.statrBtn:GetComponent(BoxCollider)
  self.resetBtn_BC = self.resetBtn:GetComponent(BoxCollider)
  self.statrBtn_Sp = self.statrBtn:GetComponent(UISprite)
  self.resetBtn_Sp = self.resetBtn:GetComponent(UISprite)
  self.statrBtn_Lb = self:FindComponent("Label", UILabel, self.statrBtn)
  self.resetBtn_Lb = self:FindComponent("Label", UILabel, self.resetBtn)
end

function MayPalaceEntranceView:AddEvts()
  self:AddClickEvent(self.resetBtn, function()
    helplog("申请重置副本", self.curRaidId)
    local valid = self:CheckCurFloorApplyValid()
    if valid then
      MsgManager.ConfirmMsgByID(41242, function()
        ServiceRaidCmdProxy.Instance:CallRaidPuzzleActionRaidCmd(2, self.curRaidId)
      end)
    end
  end)
  self:AddClickEvent(self.statrBtn, function()
    helplog("申请进入副本", self.curRaidId)
    local valid = self:CheckCurFloorApplyValid()
    if valid then
      ServiceRaidCmdProxy.Instance:CallRaidPuzzleActionRaidCmd(1, self.curRaidId)
    end
  end)
  self:AddClickEvent(self.luxuryBox, function()
    self:ShowRewardPanel(1)
  end)
  self:AddClickEvent(self.normalBox, function()
    self:ShowRewardPanel(2)
  end)
  
  function self.rewardPanelComp.callBack(go)
    self.rewardPanel:SetActive(false)
  end
  
  self:AddClickEvent(self.leftIndicator, function()
    self.curFloor = self.curFloor - 1
    if self.curFloor <= 0 then
      self.curFloor = 1
    end
    self:ChangePage()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self.curFloor = self.curFloor + 1
    if self.curFloor == self.totalChapter then
      self.curFloor = self.totalChapter
    end
    self:ChangePage()
  end)
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function MayPalaceEntranceView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.RaidCmdQueryRaidPuzzleListRaidCmd, self.RefreshPage)
end

function MayPalaceEntranceView:InitStatic()
  IconManager:SetItemIcon("item_6746", self.luxuryBoxIcon)
  IconManager:SetItemIcon("item_6745", self.normalBoxIcon)
  self:RefreshStaticInfo()
  ServiceRaidCmdProxy.Instance:CallQueryRaidPuzzleListRaidCmd(0)
end

function MayPalaceEntranceView:RefreshPage()
  redlog("重置后刷新界面")
  self:RefreshCurFloor()
  self:RefreshBoxInfo()
end

function MayPalaceEntranceView:RefreshCurFloor()
  local raidInfo = RaidPuzzleProxy.Instance.raidInfo
  local targetFloor = 1
  local targetRaidId = 1003515
  for k, v in pairs(self.floorInfo) do
    if raidInfo[v.raidid] then
      v.status = raidInfo[v.raidid].status
    end
  end
  for k, v in pairs(self.floorInfo) do
    local config = GameConfig.RaidPuzzle[v.raidid]
    if config and config.visibleMenuId and FunctionUnLockFunc.Me():CheckCanOpen(config.visibleMenuId) then
      targetFloor = k
    end
  end
  xdlog("目标floor", targetFloor)
  if self.curFloor ~= targetFloor then
    self.curFloor = targetFloor
    self:RefreshStaticInfo()
  end
end

function MayPalaceEntranceView:RefreshBoxInfo()
  local raidInfo = RaidPuzzleProxy.Instance.raidInfo[self.curRaidId] or {}
  local boxes = raidInfo.leftBoxes
  if not boxes then
    self.luxuryLabel.text = "0/" .. self.luxuryBoxMax
    self.normalLabel.text = "0/" .. self.normalBoxMax
    return
  end
  self.luxuryBoxMax = raidInfo.luxuryBoxMax
  self.normalBoxMax = raidInfo.normalBoxMax
  local leftLuxuryBoxNum = 0
  local leftNormalBoxNum = 0
  if boxes and 0 < #boxes then
    for i = 1, #boxes do
      if Table_RaidPushAreaObj[self.curRaidId][boxes[i]].NpcID == luxuryBoxId then
        leftLuxuryBoxNum = leftLuxuryBoxNum + 1
      elseif Table_RaidPushAreaObj[self.curRaidId][boxes[i]].NpcID == normalBoxId then
        leftNormalBoxNum = leftNormalBoxNum + 1
      end
    end
  end
  self.luxuryLabel.text = self.luxuryBoxMax - leftLuxuryBoxNum .. "/" .. self.luxuryBoxMax
  local luxPercent = (self.luxuryBoxMax - leftLuxuryBoxNum) / self.luxuryBoxMax
  self.luxurySlider.value = luxPercent
  self.normalLabel.text = self.normalBoxMax - leftNormalBoxNum .. "/" .. self.normalBoxMax
  local normalPercent = (self.normalBoxMax - leftNormalBoxNum) / self.normalBoxMax
  self.normalSlider.value = normalPercent
  local preFloor = self.curFloor - 1
  local preRaidId = self.floorInfo[preFloor] and self.floorInfo[preFloor].raidid or 0
  local preRaidInfo = RaidPuzzleProxy.Instance.raidInfo[preRaidId]
  local enterMenuId = self.config.enterMenuId
  local noEntryMenuId = self.config.NoEntryMenuID
  if raidInfo.allClear and raidInfo.status == 2 and (not noEntryMenuId or FunctionUnLockFunc.Me():CheckCanOpen(noEntryMenuId)) then
    self.curFloorAllClear = true
  else
    self.curFloorAllClear = false
  end
  if not preRaidInfo or preRaidInfo and preRaidInfo.allClear then
    self.preFloorAllClear = true
  else
    self.preFloorAllClear = false
  end
  if not preRaidInfo or preRaidInfo and preRaidInfo.status and preRaidInfo.status == 2 then
    self.preFloorPassed = true
  else
    self.preFloorPassed = false
  end
  if not enterMenuId or enterMenuId and FunctionUnLockFunc.Me():CheckCanOpen(enterMenuId) then
    self.curFloorEnterValid = true
  else
    self.curFloorEnterValid = false
  end
  if not self.curFloorAllClear and (preRaidId == 0 or self.preFloorAllClear and self.preFloorPassed and self.curFloorEnterValid) then
    self.statrBtn_Sp.spriteName = "new-com_btn_a"
    self.statrBtn_Lb.color = LuaGeometry.GetTempColor()
    self.statrBtn_Lb.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
    self.resetBtn_Sp.spriteName = "new-com_btn_red"
    self.resetBtn_Lb.color = LuaGeometry.GetTempColor()
    self.resetBtn_Lb.effectColor = LuaGeometry.GetTempColor(0.7019607843137254, 0.2549019607843137, 0.2549019607843137)
  else
    self.statrBtn_Sp.spriteName = "new-com_btn_a_gray"
    self.statrBtn_Lb.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
    self.statrBtn_Lb.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
    self.resetBtn_Sp.spriteName = "new-com_btn_a_gray"
    self.resetBtn_Lb.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
    self.resetBtn_Lb.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
  end
end

function MayPalaceEntranceView:RefreshStaticInfo()
  self.curRaidId = self.floorInfo[self.curFloor] and self.floorInfo[self.curFloor].raidid or 1003515
  xdlog("CurRaidId", self.curRaidId)
  self.config = GameConfig.RaidPuzzle[self.curRaidId]
  self.curFloor = self.config.floor or 1
  self.titleLabel.text = string.format(ZhString.MayPalace_Title, self.curFloor)
  if self.mapTexture then
    PictureManager.Instance:UnLoadUI(self.mapTexture, self.raidTexture)
    self.mapTexture = nil
  end
  self.mapTexture = self.config.pic
  PictureManager.Instance:SetUI(self.mapTexture, self.raidTexture)
  self.desc.text = self.config.desc
  self:UpdateIndicator()
  local raidRewardIds = RaidPuzzleProxy.Instance.raidPuzzleRewards[self.curRaidId]
  if not raidRewardIds then
    redlog("没有当前副本id", self.curRaidId, "对应的奖励ids")
    self.luxuryBoxMax = 0
    self.normalBoxMax = 0
    self:RefreshBoxInfo()
    return
  end
  local raidInfo = RaidPuzzleProxy.Instance.raidInfo[self.curRaidId]
  if raidInfo then
    self.luxuryBoxMax = raidInfo.luxuryBoxMax
    self.normalBoxMax = raidInfo.normalBoxMax
  end
  self:RefreshBoxInfo()
end

function MayPalaceEntranceView:ChangePage()
  self:RefreshStaticInfo()
  PlayerPrefs.SetInt(LocalSaveProxy.SAVE_KEY.RaidPuzzleEntranceFloor, self.curRaidId)
  local curRaidInfo = RaidPuzzleProxy.Instance.raidInfo[self.curRaidId]
  if not curRaidInfo then
    helplog("当前层数没有信息，申请")
    ServiceRaidCmdProxy.Instance:CallQueryRaidPuzzleListRaidCmd(self.curRaidId)
    return
  end
end

function MayPalaceEntranceView:UpdateIndicator()
  if self.curFloor == 1 then
    self.leftIndicator_Icon.alpha = 0.3
    self.leftIndicator_bc.enabled = false
    self.leftIndicator_TweenPos.enabled = false
    self.leftIndicator_TweenPos:ResetToBeginning()
  else
    self.leftIndicator_Icon.alpha = 1
    self.leftIndicator_bc.enabled = true
    self.leftIndicator_TweenPos.enabled = true
  end
  if self.totalChapter > self.curFloor then
    local nextRaidId = self.floorInfo[self.curFloor + 1] and self.floorInfo[self.curFloor + 1].raidid
    if nextRaidId and GameConfig.RaidPuzzle[nextRaidId] then
      local menuid = GameConfig.RaidPuzzle[nextRaidId].visibleMenuId
      local raidInfo = RaidPuzzleProxy.Instance.raidInfo[self.curRaidId]
      if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) and raidInfo and raidInfo.status == 2 then
        self.rightIndicator_Icon.alpha = 1
        self.rightIndicator_bc.enabled = true
        self.rightIndicator_TweenPos.enabled = true
      else
        self.rightIndicator_Icon.alpha = 0.3
        self.rightIndicator_bc.enabled = false
        self.rightIndicator_TweenPos.enabled = false
        self.rightIndicator_TweenPos:ResetToBeginning()
      end
    end
  else
    self.rightIndicator_Icon.alpha = 0.3
    self.rightIndicator_bc.enabled = false
    self.rightIndicator_TweenPos.enabled = false
    self.rightIndicator_TweenPos:ResetToBeginning()
  end
end

function MayPalaceEntranceView:ShowRewardPanel(boxType)
  local rewardList = {}
  local raidInfo = RaidPuzzleProxy.Instance.raidInfo[self.curRaidId] or {}
  local boxes = raidInfo.leftBoxes
  if not boxes then
    redlog("奖励已全部领完")
    return
  end
  if boxType == 1 then
    for i = 1, #boxes do
      local config = Table_RaidPushAreaObj[self.curRaidId][boxes[i]]
      if config and config.NpcID == 817507 then
        table.insert(rewardList, config.RewardId)
      end
    end
  elseif boxType == 2 then
    for i = 1, #boxes do
      local config = Table_RaidPushAreaObj[self.curRaidId][boxes[i]]
      if config.NpcID == 817508 then
        table.insert(rewardList, config.RewardId)
      end
    end
  end
  if rewardList and 0 < #rewardList then
    self.rewardPanel:SetActive(true)
  else
    self.rewardPanel:SetActive(false)
    MsgManager.ShowMsgByID(41410)
    return
  end
  local tempItemList = {}
  self:UpdateItemsListByRewardGroup(rewardList, tempItemList)
  self.rewardGridCtrl:ResetDatas(tempItemList)
  self.rewardScrollView:ResetPosition()
end

function MayPalaceEntranceView:UpdateItemsListByRewardGroup(rewardids, array)
  if rewardids and 0 < #rewardids then
    for i = 1, #rewardids do
      local singleRewardID = rewardids[i]
      local list = ItemUtil.GetRewardItemIdsByTeamId(singleRewardID)
      if list then
        for j = 1, #list do
          local single = list[j]
          local hasAdd = false
          for j = 1, #array do
            local temp = array[j]
            if temp.itemData.id == single.id then
              temp.num = temp.num + single.num
              hasAdd = true
              break
            end
          end
          if not hasAdd then
            local data = {}
            data.itemData = ItemData.new("Reward", single.id)
            if data.itemData then
              data.num = single.num
              table.insert(array, data)
            end
          end
        end
      end
    end
  end
end

function MayPalaceEntranceView:CheckCurFloorApplyValid()
  if not self.config then
    return
  end
  if self.curFloorAllClear then
    local completeMsgId = GameConfig.RaidPuzzle.floorFinishMsgId or 41416
    MsgManager.ShowMsgByID(completeMsgId)
    return
  end
  if not self.preFloorAllClear then
    local boxCompleteSysmsgId = self.config.boxCompleteSysmsgId or 41415
    MsgManager.ShowMsgByID(boxCompleteSysmsgId)
    return
  end
  if not self.curFloorEnterValid then
    local unvalidSysmsgId = self.config.unvalidSysmsgId
    MsgManager.ShowMsgByID(unvalidSysmsgId)
    return
  end
  if not self.preFloorPassed then
    MsgManager.ShowMsgByID(41419)
    return
  end
  return true
end

function MayPalaceEntranceView:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0})
  end
end

function MayPalaceEntranceView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  MayPalaceEntranceView.super.OnExit(self)
  if self.mapTexture then
    PictureManager.Instance:UnLoadUI(self.mapTexture, self.raidTexture)
  end
end
