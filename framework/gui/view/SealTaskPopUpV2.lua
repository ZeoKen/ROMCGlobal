autoImport("SimpleItemCell")
autoImport("SealMapCell")
autoImport("SealTaskPopUp")
autoImport("BagItemNewCell")
autoImport("RewardGridCell")
SealTaskPopUpV2 = class("SealTaskPopUpV2", SealTaskPopUp)
SealTaskPopUpV2.ViewType = UIViewType.PopUpLayer
local mapPic = "map"

function SealTaskPopUpV2:Init()
  self.costID = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.costID or 5503
  self:InitView()
  self:AddUIEvts()
  self:MapEvent()
end

function SealTaskPopUpV2:InitView()
  self.sealInfoBord = self:FindGO("SealInfoBord")
  self.sealInfoBord:SetActive(false)
  self.selectEffect = self:FindGO("SelectEffect")
  self:PlayUIEffect(EffectMap.UI.Selected, self.selectEffect)
  self.dailyTime = self:FindComponent("DailyTime", UILabel)
  self.dailyTimesTip = self:FindGO("DTTip"):GetComponent(UILabel)
  self.dailyTimesTip.text = ZhString.SealTaskPopUp_dailyTimesTip
  self.posLabel = self:FindComponent("PosName", UILabel)
  self.tipScrollView = self:FindGO("Scroll View"):GetComponent(UIScrollView)
  self.sealTip = self:FindComponent("SealTip", UILabel)
  local dropGrid = self:FindComponent("DropGrid", UIGrid)
  self.dropCtl = UIGridListCtrl.new(dropGrid, SimpleItemCell, "SimpleItemCell")
  self.dropCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  local getBtn = self:FindGO("GetButton")
  local getButtonSprite = getBtn:GetComponent(UISprite)
  local getBtnLab = self:FindComponent("Label", UILabel, self.getBtn)
  getBtn:SetActive(false)
  self:InitMap()
  self.addCountTip = self:FindComponent("AddCountTip", UILabel)
  self.sealBg = self:FindComponent("SealBg", UISprite)
  local quickFinishRoot = self:FindGO("QuickFinishRoot")
  quickFinishRoot:SetActive(false)
  self.sealV2Root = self:FindGO("SealV2Root")
  self.goBtn = self:FindGO("GoBtn", self.sealV2Root)
  self.quickFinishAllBtnNew = self:FindGO("QuickFinishAllBtn", self.sealV2Root)
  self.quickFinish_BoxCollider = self.quickFinishAllBtnNew:GetComponent(BoxCollider)
  self.disableLabel = self:FindGO("DisableLabel", self.sealV2Root)
  self.disableLabel_Text = self.disableLabel:GetComponent(UILabel)
  self.giftIcon = self:FindGO("GiftStatus"):GetComponent(UISprite)
  self:Show(self.giftIcon)
  self.helpBtn = self:FindGO("BtnHelp")
  self:Show(self.helpBtn)
  self:UpdateSealTasks()
  self.giftBtn = self:FindGO("GiftStatus")
  self.rewardPanel = self:FindGO("WeeklyRewardPanel")
  self.rewardPanel:SetActive(false)
  self.closeRewardBtn = self:FindGO("CloseButton", self.rewardPanel)
  self.commonGrid = self:FindGO("CommonGrid"):GetComponent(UIGrid)
  self.commonRewardCtrl = UIGridListCtrl.new(self.commonGrid, BagItemNewCell, "BagItemNewCell")
  self.commonRewardItem = self:FindGO("CommonReward")
  self.commonRewardCell = RewardGridCell.new(self.commonRewardItem)
  self.randomGrid = self:FindGO("RandomGrid"):GetComponent(UIGrid)
  self.randomRewardCtrl = UIGridListCtrl.new(self.randomGrid, BagItemNewCell, "BagItemNewCell")
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.tipStick = self:FindComponent("TipStick", UISprite)
end

function SealTaskPopUpV2:AddUIEvts()
  self:AddButtonEvent("CloseSealInfo", function(go)
    self.selectData = nil
    self.selectEffect:SetActive(false)
    self:UpdateSelectSealInfo()
  end)
  self:AddClickEvent(self.goBtn, function(go)
    self:ClickGoBtn()
  end)
  self:AddClickEvent(self.quickFinishAllBtnNew, function()
    if self.notChallenged then
      MsgManager.ShowMsgByIDTable(1624)
      return
    end
    if self.noLeftTimes then
      MsgManager.ShowMsgByIDTable(1625)
      return
    end
    self:OnClickQuickFinish(true)
  end)
  self:RegistShowGeneralHelpByHelpID(300, self.helpBtn)
  self:AddClickEvent(self.giftBtn, function()
    self:ShowRewardPanel()
  end)
  self:AddClickEvent(self.closeRewardBtn, function()
    self.rewardPanel:SetActive(false)
  end)
  self.commonRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.randomRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function SealTaskPopUpV2:MapEvent()
  self:AddListenEvt(ServiceEvent.SceneSealSealQueryList, self.HandleRefreshQuickFinishStatus)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateSealRepairTimes)
end

function SealTaskPopUpV2:ClickGoBtn()
  if not self.selectData then
    return
  end
  local goToModeID = self.selectData.sealData.GoToMode
  if goToModeID then
    FuncShortCutFunc.Me():CallByID(goToModeID)
    self:CloseSelf()
  end
end

function SealTaskPopUpV2:UpdateSealTasks()
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local firstSealMap
  if Table_RaidSeal then
    for k, v in pairs(Table_RaidSeal) do
      local position = v.Position
      local mapCell = self:GetMapCellByMapId(position)
      if mapCell then
        local data = mapCell.data
        data.sealData = v
        data.newGenSeal = true
        if playerLevel < v.UnlockLevel then
          data.Unlock = false
        else
          data.Unlock = true
        end
        local enableQuickFinish = SealProxy.Instance:GetQuickFinishForbid(v.id)
        data.enableQuickFinish = enableQuickFinish
        mapCell:SetData(data)
        if v.id == 1 then
          firstSealMap = mapCell
        end
      end
    end
  end
  if self.selectData == nil then
    self:ClickMapCell(firstSealMap)
  end
end

function SealTaskPopUpV2:ClickMapCell(cellctl)
  local data = cellctl and cellctl.data
  if data and data.sealData then
    self.selectData = data
    self.selectEffect.transform:SetParent(cellctl.gameObject.transform, false)
    self.selectEffect:SetActive(true)
    local targetMap = data.sealData.MapID
    local mapData = Table_Map[targetMap]
    local nameStr = ""
    if mapData then
      nameStr = mapData.NameZh
    end
    local length = StringUtil.Utf8len(nameStr)
    local pos = cellctl.gameObject.transform.localPosition
    if pos[1] >= 70 then
      TipManager.Instance:ShowSealAreaTip(nameStr, cellctl.multiSymbol, NGUIUtil.AnchorSide.Center, {
        -90 - length * 3,
        0
      })
    else
      TipManager.Instance:ShowSealAreaTip(nameStr, cellctl.multiSymbol, NGUIUtil.AnchorSide.Center, {
        90 + length * 3,
        0
      })
    end
  end
  self:UpdateSelectSealInfo()
end

function SealTaskPopUpV2:GetMapCellByMapId(position)
  local x = position[1] + WorldMapProxy.Ori_X
  local y = position[2] + WorldMapProxy.Ori_Y
  local cellIndex = (y - 1) * WorldMapProxy.Size_X + x
  local cells = self.mapCtl:GetCells()
  return cells[cellIndex]
end

function SealTaskPopUpV2:UpdateSealRepairTimes()
  SealTaskPopUpV2.super.UpdateSealRepairTimes(self)
  local donetimes = SealProxy.GetSealVarValue()
  local maxtimes = GameConfig.Seal.maxSealNum
  redlog("次数显示", donetimes, maxtimes)
  if 5 <= donetimes then
    self.giftIcon.spriteName = "growup2"
  else
    self.giftIcon.spriteName = "growup1"
  end
end

function SealTaskPopUpV2:UpdateSelectSealInfo()
  local data = self.selectData
  if not data then
    self.sealInfoBord:SetActive(false)
    return
  end
  self.sealInfoBord:SetActive(true)
  local sealData = data.sealData
  self.sealTip.text = sealData.Text or ""
  self.posLabel.text = data.sealData.Name
  self.tipScrollView:ResetPosition()
  local reward, chooseReward = {}, {}
  if sealData and sealData.DisplayProps then
    for _, itemid in pairs(sealData.DisplayProps) do
      if Table_Item[itemid] then
        table.insert(reward, ItemData.new("SealReward", itemid))
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

function SealTaskPopUpV2:HandleRefreshQuickFinishStatus()
  self:UpdateSealTasks()
  self:UpdateQuickFinishInfo()
end

function SealTaskPopUpV2:UpdateQuickFinishInfo()
  local sealData = self.selectData and self.selectData.sealData
  if not self.costID or not sealData then
    return
  end
  self.costPrice = SealProxy.GetQuickCost(sealData.MapID)
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local limitLevel = sealData.UnlockLevel or 999
  if playerLevel >= limitLevel then
    self:SwitchLevelLimitShow(true)
  else
    self:SwitchLevelLimitShow(false)
    self.disableLabel_Text.text = string.format(ZhString.SealTaskPopUp_LevelLimit, limitLevel)
  end
  local leftNum = GameConfig.Seal.maxSealNum - SealProxy.GetSealVarValue()
  local enableQuickFinish = SealProxy.Instance:GetQuickFinishForbid(sealData.id)
  if leftNum <= 0 or not enableQuickFinish then
    self:SetTextureGrey(self.quickFinishAllBtnNew)
  else
    self:SetTextureWhite(self.quickFinishAllBtnNew, LuaGeometry.GetTempColor(0.6235294117647059, 0.30980392156862746, 0.03529411764705882, 1))
  end
  if leftNum <= 0 then
    self.noLeftTimes = true
  else
    self.noLeftTimes = false
  end
  if not enableQuickFinish then
    self.notChallenged = true
  else
    self.notChallenged = false
  end
end

function SealTaskPopUpV2:SwitchLevelLimitShow(show)
  self.goBtn.gameObject:SetActive(show)
  self.quickFinishAllBtnNew.gameObject:SetActive(show)
  self.disableLabel.gameObject:SetActive(not show)
end

function SealTaskPopUpV2:ShowRewardPanel()
  self.rewardPanel:SetActive(true)
  local commonReward = {}
  commonReward.itemData = ItemData.new("Reward", 110)
  local num = self:GetCommonRewardNum()
  commonReward.num = num
  self.commonRewardCell:SetData(commonReward)
  self.randomRewardList = {}
  self:UpdateRewards(self.randomRewardList)
  self.randomRewardCtrl:ResetDatas(self.randomRewardList)
end

function SealTaskPopUpV2:GetCommonRewardNum()
  local rewardid = GameConfig.Seal.dailyExtraReward or {4585}
  if rewardid then
    local list = ItemUtil.GetRewardItemIdsByTeamId(rewardid[1])
    local num = 0
    for i = 1, #list do
      local single = list[i]
      if single.id == 110 then
        num = num + single.num
      end
    end
    return num
  end
end

function SealTaskPopUpV2:UpdateRewards(rewardItemDataList)
  local rewardid = GameConfig.Seal.dailyExtraReward or {4585}
  if rewardid then
    for i = 1, #rewardid do
      local rewarditemids = ItemUtil.GetRewardItemIdsByTeamId(rewardid[i])
      if rewarditemids and next(rewarditemids) then
        for _, data in pairs(rewarditemids) do
          if data.id ~= 110 then
            local item = ItemData.new("Reward", data.id)
            table.insert(rewardItemDataList, item)
          end
        end
      end
    end
  end
end

function SealTaskPopUpV2:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end
