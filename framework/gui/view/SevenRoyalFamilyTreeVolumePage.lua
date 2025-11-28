autoImport("SevenRoyalFamilyTreeVolumeCell")
autoImport("SevenRoyalFamilyTreeClueCell")
autoImport("ItemCell")
SevenRoyalFamilyTreeVolumePage = class("SevenRoyalFamilyTreeVolumePage", SubView)
local picIns, familyIns
local texObjStaticNameMap = {
  DetailBg2 = "Sevenroyalfamilies_bg_02",
  DetailBg3 = "Sevenroyalfamilies_bg_03",
  DetailBg4 = "Sevenroyalfamilies_bg_04",
  DetailBg5 = "Sevenroyalfamilies_bg_05",
  Feather = "Sevenroyalfamilies_bg_feather",
  Check = "Sevenroyalfamilies_icon_check",
  Pic = "Sevenroyalfamilies_bg_pic"
}

function SevenRoyalFamilyTreeVolumePage:Init()
  if not picIns then
    picIns = PictureManager.Instance
    familyIns = ServiceFamilyCmdProxy.Instance
  end
  self:ReLoadPerferb("view/SevenRoyalFamilyTreeVolumePage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.trans.localPosition = LuaGeometry.Const_V3_zero
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self:FindObjs()
  self:InitPage()
  self:AddEvents()
end

function SevenRoyalFamilyTreeVolumePage:FindObjs()
  self.tween = self.gameObject:GetComponent(TweenPosition)
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.title = self:FindComponent("Title", UILabel)
  self.pre = self:FindComponent("Pre", UILabel)
  self.unlockEffect = self:FindComponent("UnlockEffect", UILabel)
  self.unlockUnderlinesParent = self:FindGO("UnderlineGrid")
  self.unlockUnderlines = {}
  for i = 1, 4 do
    self.unlockUnderlines[i] = self:FindGO("Underline" .. i)
  end
  self.desc = self:FindComponent("Desc", UILabel)
  self.rewardBg = self:FindComponent("RewardBg", UISprite)
  self.rewardIcon = self:FindComponent("RewardIcon", UISprite)
  self.rewardNumLabel = self:FindComponent("RewardNumLabel", UILabel)
  self.rewardMask = self:FindGO("RewardMask")
  self.rewardEffContainer = self:FindGO("RewardEffContainer")
  self.costParent = self:FindGO("CostIndicator")
  self.costIcon = self:FindComponent("CostIndicator", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.unlockBtn = self:FindGO("UnlockBtn")
  self.unlockUnavailableBtn = self:FindGO("UnlockUnavailableBtn")
  self.gotoBtn = self:FindGO("GotoBtn")
  self.recvBtn = self:FindGO("RecvBtn")
  self.swipeLongPress = self:FindComponent("SwipeZone", UILongPress)
  self.clueCellGrid = self:FindComponent("ClueCellGrid", UIGrid)
end

function SevenRoyalFamilyTreeVolumePage:InitPage()
  self.familyCells, self.familyMicroCells, self.clueCells, self.cluePaths = {}, {}, {}, {}
  local cell
  for id, data in pairs(Table_FamilyTree) do
    cell = SevenRoyalFamilyTreeVolumeCell.new(self:FindGO("Family" .. id))
    cell:SetData(data)
    cell:AddEventListener(MouseEvent.MouseClick, self.OnClickFamilyCell, self)
    self.familyCells[id] = cell
    cell = SevenRoyalFamilyTreeVolumeCell.new(self:FindGO("Micro" .. id))
    cell:SetData(data)
    cell:AddEventListener(MouseEvent.MouseClick, self.OnClickFamilyMicroCell, self)
    self.familyMicroCells[id] = cell
  end
  for i = 1, 4 do
    cell = SevenRoyalFamilyTreeClueCell.new(self:FindGO("ClueCell" .. i))
    cell:AddEventListener(MouseEvent.MouseClick, self.OnClickClueCell, self)
    self.clueCells[i] = cell
  end
  for i = 2, 4 do
    self.cluePaths[i] = self:FindGO("Path" .. i)
  end
end

local rewardTipOffset = {220, 170}

function SevenRoyalFamilyTreeVolumePage:AddEvents()
  self:AddClickEvent(self.unlockBtn, function()
    local rslt, cfg = self:CheckCost()
    if not rslt then
      if cfg then
        MsgManager.ShowMsgByIDTable(25418, Table_Item[cfg[1]].NameZh)
      end
      return
    end
    familyIns:CallClueUnlockFamilyCmd(self.detailClueData.id)
  end)
  self:AddClickEvent(self.unlockUnavailableBtn, function()
    MsgManager.FloatMsg(nil, ZhString.FamilyTree_FinishPreTip)
  end)
  self:AddClickEvent(self.gotoBtn, function()
    if not self.detailClueData then
      return
    end
    local t, questData = ReusableTable.CreateArray()
    local servantQuestStepList = Table_ServantQuestfinishStep[self.detailClueData.UnlockGiveQuest]
    if servantQuestStepList then
      local stepList = servantQuestStepList.QuestStep
      if stepList and 0 < #stepList then
        for j = 1, #stepList do
          questData = QuestProxy.Instance:GetQuestDataBySameQuestID(stepList[j])
          if questData then
            TableUtility.ArrayPushBack(t, questData)
          end
        end
      end
    end
    if t[1] then
      FuncShortCutFunc.Me():CallByQuestFinishID(nil, nil, t[1])
    else
      FuncShortCutFunc.Me():CallByID(self.detailClueData.GotoMode)
    end
    ReusableTable.DestroyAndClearArray(t)
    if self and self.container then
      self:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    end
  end)
  self:AddClickEvent(self.recvBtn, function()
    if not self.detailClueData then
      return
    end
    self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.rewardEffContainer, true)
    familyIns:CallClueRewardFamilyCmd(self.detailClueData.id)
  end)
  self:AddButtonEvent("DetailCloseBtn", function()
    self:Switch()
  end)
  self:AddButtonEvent("RewardBg", function()
    if not self.rewardId then
      return
    end
    if not self.tipData.itemdata then
      self.tipData.itemdata = ItemData.new()
    end
    self.tipData.itemdata:ResetData("Reward", self.rewardId)
    self:ShowItemTip(self.tipData, self.rewardIcon, NGUIUtil.AnchorSide.Up, rewardTipOffset)
  end)
  
  function self.swipeLongPress.pressEvent(longPress, isPressing)
    if isPressing then
      self.swipeBeginPosX, self.swipeBeginPosY = LuaGameObject.GetMousePosition()
    else
      if not self.swipeBeginPosX or not self.swipeBeginPosY then
        return
      end
      local endPosX, endPosY = LuaGameObject.GetMousePosition()
      local deltaX, deltaY = endPosX - self.swipeBeginPosX, endPosY - self.swipeBeginPosY
      if deltaY < -Screen.height / 24 then
        if self.isDetail then
          self:Switch()
        end
      elseif deltaX * deltaX + deltaY * deltaY < 15 then
        local cam = self.container.uiCamera
        local ray = cam:ScreenPointToRay(LuaGeometry.GetTempVector3(endPosX, endPosY))
        local hits = Physics.RaycastAll(ray, cam.farClipPlane - cam.nearClipPlane, cam.cullingMask)
        if hits then
          local widgets = ReusableTable.CreateArray()
          local obj, widget, listener
          for i = 1, #hits do
            widget = hits[i].collider.gameObject:GetComponent(UIWidget)
            TableUtility.ArrayPushBack(widgets, widget)
          end
          table.sort(widgets, function(l, r)
            return l.depth > r.depth
          end)
          for i = 1, #widgets do
            obj = widgets[i].gameObject
            if obj.name ~= self.swipeLongPress.gameObject.name then
              listener = UIEventListener.Get(obj)
              if listener then
                listener:SendMessage("OnClick", obj, 1)
              end
              break
            end
          end
          ReusableTable.DestroyAndClearArray(widgets)
        end
      end
      self.swipeBeginPosX, self.swipeBeginPosY = nil, nil
    end
  end
  
  self:AddListenEvt(ServiceEvent.FamilyCmdClueDataNtfFamilyCmd, self.UpdatePage)
  self:AddListenEvt(ServiceEvent.FamilyCmdClueUnlockFamilyCmd, self.UpdatePage)
  self:AddListenEvt(ServiceEvent.FamilyCmdClueRewardFamilyCmd, self.UpdatePage)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function SevenRoyalFamilyTreeVolumePage:OnEnter()
  SevenRoyalFamilyTreeVolumePage.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  self:UpdatePage()
end

function SevenRoyalFamilyTreeVolumePage:OnExit()
  for _, c in pairs(self.familyCells) do
    c:OnExit()
  end
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  SevenRoyalFamilyTreeVolumePage.super.OnExit(self)
end

function SevenRoyalFamilyTreeVolumePage:OnClickFamilyCell(cell)
  if cell.data.ToBeContinued == 1 then
    MsgManager.FloatMsg(nil, ZhString.Warband_Empty_NoSeason)
    return
  end
  self.detailFamilyData = cell.data
  self.detailClueData = nil
  self:Switch()
end

function SevenRoyalFamilyTreeVolumePage:OnClickFamilyMicroCell(cell)
  if cell.data.ToBeContinued == 1 then
    MsgManager.FloatMsg(nil, ZhString.Warband_Empty_NoSeason)
    return
  end
  if cell.data.id == cell.chooseId then
    return
  end
  self.detailFamilyData = cell.data
  self.detailClueData = nil
  self:UpdatePage()
end

function SevenRoyalFamilyTreeVolumePage:OnClickClueCell(cell)
  if cell.data.id == cell.chooseId then
    return
  end
  self.detailClueData = cell.data
  self:UpdatePage()
end

function SevenRoyalFamilyTreeVolumePage:OnItemUpdate()
  self:UpdateCostLabel()
end

function SevenRoyalFamilyTreeVolumePage:UpdatePage()
  if self.isDetail then
    local family = self.detailFamilyData.id
    for _, c in pairs(self.familyMicroCells) do
      c:UpdateRedTip()
      c:SetChoose(family)
    end
    local clues = familyIns:GetClueListOfFamily(family)
    local min = math.min(#clues, #self.clueCells)
    if not self.detailClueData then
      local i = 1
      while clues[i] and familyIns:GetClueState(clues[i]) == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD do
        i = i + 1
      end
      self.detailClueData = Table_FamilyClue[clues[math.min(min, i)]]
    end
    for i = 1, min do
      self.clueCells[i].gameObject:SetActive(true)
      self.clueCells[i]:SetData(Table_FamilyClue[clues[i]])
      self.clueCells[i]:SetChoose(self.detailClueData and self.detailClueData.id)
      if self.cluePaths[i] then
        self.cluePaths[i]:SetActive(true)
      end
    end
    for i = min + 1, #self.clueCells do
      self.clueCells[i].gameObject:SetActive(false)
      if self.cluePaths[i] then
        self.cluePaths[i]:SetActive(false)
      end
    end
    self.clueCellGrid.cellHeight = 1 < min and 297 / (min - 1) or 0
    self.clueCellGrid:Reposition()
    self:UpdateClueDetail()
  else
    for _, c in pairs(self.familyCells) do
      c:UpdateIndicators()
      c:UpdateRedTip()
    end
  end
end

function SevenRoyalFamilyTreeVolumePage:UpdateClueDetail()
  local data = self.detailClueData
  if not data then
    LogUtility.Warning("What happened? There's no detailClueData!")
    return
  end
  local preId = data.PreID[1]
  local preData = preId and Table_FamilyClue[preId]
  self.pre.text = preData and string.format(ZhString.FamilyTree_PreFormat, preData.Name) or ""
  self:UpdateUnlockEffect()
  self:UpdateRewardAndControl()
  self.desc.text = data.Desc
  IconManager:SetItemIcon(Table_Item[data.UnlockCost[1][1]].Icon, self.costIcon)
  self:UpdateCostLabel()
end

function SevenRoyalFamilyTreeVolumePage:UpdateCostLabel()
  local rslt, cfg = self:CheckCost()
  local costStr = cfg and tostring(cfg[2]) or ""
  self.costLabel.text = rslt and costStr or string.format("[c][FF6021]%s[-][/c]", costStr)
end

function SevenRoyalFamilyTreeVolumePage:UpdateUnlockEffect()
  local effectId = self.detailClueData.EffectId
  local sData = Table_AssetEffect[self.detailClueData.EffectId]
  if not sData then
    LogUtility.WarningFormat("Cannot find static data of AssetEffect with id = {0}", effectId)
    self.unlockUnderlinesParent:SetActive(false)
    self.unlockEffect.text = ""
    return
  end
  local targetStr, bWrap, outStr = string.format(ZhString.FamilyTree_EffectFormat, sData.Desc)
  bWrap, outStr = self.unlockEffect:Wrap(targetStr, outStr, self.unlockEffect.height)
  self.unlockUnderlinesParent:SetActive(bWrap)
  if bWrap then
    local rowNum = 1
    for word in string.gmatch(outStr, "\n") do
      rowNum = rowNum + 1
    end
    for i = 1, rowNum do
      self.unlockUnderlines[i]:SetActive(true)
    end
    for i = rowNum + 1, #self.unlockUnderlines do
      self.unlockUnderlines[i]:SetActive(false)
    end
    self.unlockEffect.text = outStr
  else
    self.unlockEffect.text = targetStr
  end
end

function SevenRoyalFamilyTreeVolumePage:UpdateRewardAndControl()
  local id = self.detailClueData.id
  local state, canGetReward = familyIns:GetClueState(id), familyIns:ClueCanGetRewardPredicate(id)
  local preId = self.detailClueData.PreID[1]
  local isLocked = state ~= FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK and state ~= FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD
  local isFinished = state == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD
  local isPreFinished = not preId or familyIns:GetClueState(preId) == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD
  self.title.text = string.format("%s%s", self.detailClueData.Name, isLocked and ZhString.HappyShop_LockSuffix or "")
  self.unlockBtn:SetActive(isLocked and isPreFinished)
  self.unlockUnavailableBtn:SetActive(isLocked and not isPreFinished)
  self.costParent:SetActive(isLocked)
  self.gotoBtn:SetActive(state == FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK and not canGetReward)
  self.recvBtn:SetActive(canGetReward)
  self.Check.gameObject:SetActive(isFinished)
  self.rewardMask:SetActive(not isFinished)
  self.rewardId = nil
  local rewards = ItemUtil.GetRewardItemIdsByTeamId(self.detailClueData.FinishReward)
  if isFinished and rewards and 0 < #rewards then
    self.rewardId = rewards[1].id
  end
  if self.rewardId then
    local rewardSData = Table_Item[self.rewardId]
    ItemCell.SetBgIcon(self.rewardBg, rewardSData.Type, function(bgSp)
      bgSp.atlas = RO.AtlasMap.GetAtlas("NewCom")
      bgSp.spriteName = "new-com_bg_icon_01"
    end)
    IconManager:SetItemIcon(rewardSData.Icon, self.rewardIcon)
    self.rewardIcon.height = 80
    self.rewardIcon.width = 80
    local num = rewards[1].num
    self.rewardNumLabel.text = num and 1 < num and tostring(num) or ""
  else
    local unlockIconCfg = GameConfig.Family.UnlockClueIcon[self.detailClueData.UnlockIcon]
    IconManager:SetUIIcon(unlockIconCfg.bg, self.rewardBg)
    IconManager:SetUIIcon(unlockIconCfg.icon, self.rewardIcon)
    self.rewardIcon.height = 88
    self.rewardIcon.width = 88
    self.rewardNumLabel.text = ""
  end
end

function SevenRoyalFamilyTreeVolumePage:CheckCost()
  if not self.detailClueData then
    return false
  end
  local cost = self.detailClueData.UnlockCost[1]
  local num = HappyShopProxy.Instance:GetItemNum(cost[1])
  return num >= cost[2], cost
end

function SevenRoyalFamilyTreeVolumePage:Switch()
  self.isDetail = not self.isDetail
  self:PlayTween(self.isDetail)
  self:UpdatePage()
end

local _tweenPlay = function(tween, isForward)
  if isForward then
    tween:PlayForward()
  else
    tween:PlayReverse()
  end
end

function SevenRoyalFamilyTreeVolumePage:PlayTween(isDetail)
  local t = self.tween
  t.enabled = true
  _tweenPlay(t, isDetail)
  t:ResetToBeginning()
  t:SetOnFinished(function()
    t.enabled = false
  end)
  _tweenPlay(t, isDetail)
end
