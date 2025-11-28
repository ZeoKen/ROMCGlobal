autoImport("RoguelikeItemCell")
MainViewRoguelikePage = class("MainViewRoguelikePage", SubView)
local dungeonIns, tickIns

function MainViewRoguelikePage:Init()
  if not dungeonIns then
    dungeonIns = DungeonProxy.Instance
    tickIns = TimeTickManager.Me()
  end
  self:ReLoadPerferb("view/MainViewRoguelikePage")
  self:InitView()
  self:ResetData()
  self:Hide()
end

function MainViewRoguelikePage:InitView()
  self.mainViewTrans = self.gameObject.transform.parent
  self.traceInfoParent = Game.GameObjectUtil:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(self.traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(-115, -106, 0)
  self.contentParent = self:FindGO("Content")
  self.foldSymbolSp = self:FindComponent("FoldSymbol", UISprite)
  self:AddClickEvent(self.foldSymbolSp.gameObject, function()
    self.isShowContent = not self.isShowContent
    self:UpdateContent()
  end)
  self.labelGrid = self:FindComponent("LabelGrid", UIGrid)
  self.timeLabel = self:FindComponent("TimeLabel", UILabel)
  self.curLevelLabel = self:FindComponent("CurLevelLabel", UILabel)
  self.coinLabel = self:FindComponent("CoinLabel", UILabel)
  self.keysLabel = self:FindComponent("KeysLabel", UILabel)
  self.deathLabel = self:FindComponent("DeathLabel", UILabel)
  self.scoreLabel = self:FindComponent("ScoreLabel", UILabel)
  self.itemsBtnSp = self:FindComponent("Items", UISprite)
  self.itemsLabel = self:FindComponent("Label", UILabel, self.itemsBtnSp.gameObject)
  self:AddClickEvent(self.itemsBtnSp.gameObject, function()
    self.isShowItemPanel = not self.isShowItemPanel
    self:UpdateItems()
  end)
  self:AddButtonEvent("ActInfo", function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RoguelikeStatisticsView
    })
  end)
  self.itemPanelParent = self:FindGO("ItemPanel")
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(self.itemContainer, RoguelikeItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 3, 100, true)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.itemCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
end

function MainViewRoguelikePage:ResetData()
  self.isShowContent = true
  self.isShowItemPanel = false
  tickIns:ClearTick(self)
  self.tick = nil
  self.timing = nil
  self:UpdateAll()
end

function MainViewRoguelikePage:Show(tarObj)
  MainViewRoguelikePage.super.Show(self, tarObj)
  if not tarObj then
    self:ResetData()
  end
end

function MainViewRoguelikePage:OnExit()
  self.chooseId = 0
  self:ShowItemTip()
  self:ResetChooseId()
end

function MainViewRoguelikePage:OnClickCell(cellCtl)
  if not self:_CheckOnCellEvent(cellCtl) then
    return
  end
  if self.onClickDisabled then
    return
  end
  local data = cellCtl.data
  local func, funcId = FunctionItemFunc.Me():GetItemDefaultFunc(data)
  if func then
    if funcId == 1 then
      FunctionItemFunc.TryUseItem(data, nil, 1)
    else
      func(data)
    end
  end
end

function MainViewRoguelikePage:OnLongPressCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if not self:_CheckOnCellEvent(cellCtl) then
    return
  end
  if not isPressing then
    self.onClickDisabled = true
    self:DelayCall(function()
      self.onClickDisabled = nil
    end, 50)
    return
  end
  self:ShowItemTip(cellCtl.data, {
    cellCtl and cellCtl.gameObject
  })
end

function MainViewRoguelikePage:_CheckOnCellEvent(cellCtl)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return false
  end
  local data = cellCtl and cellCtl.data
  if data == BagItemEmptyType.Empty or data == BagItemEmptyType.Grey then
    data = nil
  end
  if not data then
    return false
  end
  local newChooseId = data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
  end
  self:ResetChooseId()
  return true
end

local tipOffset = {-210, 0}

function MainViewRoguelikePage:ShowItemTip(data, ignoreBounds)
  if not data then
    TipManager.Instance:CloseItemTip()
    return
  end
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
  MainViewRoguelikePage.super.ShowItemTip(self, sdata, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function MainViewRoguelikePage:UpdateAll()
  self.isScoreMode = dungeonIns.isRoguelikeScoreMode and true or false
  if not dungeonIns.roguelikeRaid then
    return
  end
  self.scoreModeTime = dungeonIns.roguelikeRaid.scoreModeTime
  local subScenes, curRoomIndex = SceneProxy.Instance.currentScene.subScenes, dungeonIns.roguelikeRaid.curRoomIndex
  if subScenes and curRoomIndex and 0 < curRoomIndex then
    local cfg = Table_RoguelikeRoom[subScenes[curRoomIndex]]
    self.timing = cfg and cfg.Timing and 0 < cfg.Timing or false
    if self.timing and not self.tick then
      self.tick = tickIns:CreateTick(0, 300, self.UpdateTick, self)
    elseif not self.timing and self.tick then
      tickIns:ClearTick(self)
      self.tick = nil
    end
  else
    self.timing = nil
  end
  self:UpdateContent()
  self:UpdateLabels(dungeonIns.roguelikeRaid)
  self:UpdateItems()
  self:OnExit()
end

function MainViewRoguelikePage:UpdateTick(interval)
  if not self.timing then
    return
  end
  self:TryUpdateTime()
  self.scoreModeTime = self.scoreModeTime + interval / 1000
end

function MainViewRoguelikePage:TryUpdateTime()
  if not self.isScoreMode then
    return
  end
  local t = math.floor(self.scoreModeTime or 0)
  local min = math.floor(t / 60)
  local s = t - min * 60
  self.timeLabel.text = string.format("%02d:%02d", min, s)
end

function MainViewRoguelikePage:UpdateLabels(raidData)
  self.timeLabel.gameObject:SetActive(self.isScoreMode)
  self:TryUpdateTime()
  self.curLevelLabel.text = raidData.realLayer
  self.coinLabel.text = raidData.coinCount
  local layerConfig = Table_RoguelikeLayer[raidData.realLayer]
  self.keysLabel.text = string.format("%s/%s", raidData.keyCount, layerConfig and layerConfig.NeedKeyNum or 0)
  self.deathLabel.text = string.format("%s/%s", raidData.reliveCount or 0, raidData.reliveAllCount or 0)
  self.scoreLabel.gameObject:SetActive(self.isScoreMode)
  if self.isScoreMode then
    self.scoreLabel.text = raidData.score
  end
  self.labelGrid.cellHeight = self.isScoreMode and 28 or 40
  self.labelGrid:Reposition()
  self.labelGrid.repositionNow = true
end

function MainViewRoguelikePage:UpdateItems()
  self.itemPanelParent:SetActive(self.isShowItemPanel)
  if self.isShowItemPanel then
    self.itemCtrl:ResetDatas(dungeonIns.roguelikeRaid and dungeonIns.roguelikeRaid.items or _EmptyTable)
  end
  self.itemsBtnSp.spriteName = self.isShowItemPanel and "com_btn_2s" or "com_btn_14"
  self.itemsBtnSp.height = self.isShowItemPanel and 36 or 46
  self.itemsLabel.effectColor = self.isShowItemPanel and ColorUtil.DiscountLabel_Yellow or ColorUtil.ButtonLabelBlue
  self:ShowItemTip()
end

function MainViewRoguelikePage:UpdateContent()
  self.contentParent:SetActive(self.isShowContent)
  self.foldSymbolSp.flip = self.isShowContent and 1 or 0
end

function MainViewRoguelikePage:ResetChooseId()
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
end
