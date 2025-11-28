autoImport("BattlePassLevelRewardCell")
autoImport("WrapCellHelper")
BattlePassLevelView = class("BattlePassLevelView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("BattlePassLevelView")
local tickInstance
local upgradeNames = {
  ZhString.BattlePassLevelView_name_index1,
  ZhString.BattlePassLevelView_name_index2
}
local onekeyPos = {
  [0] = -284.77,
  [1] = -246.6
}
local scrollviewPos = {
  [0] = -146,
  [1] = -192
}
local scrollviewOffset = {
  [0] = 33,
  [1] = 120
}
local replaceBeforeObj = -50
local tempV3 = LuaVector3()

function BattlePassLevelView:LoadSubView()
  local container = self:FindGO("levelViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "BattlePassLevelView"
  self.gameObject = obj
end

function BattlePassLevelView:Init()
  tickInstance = TimeTickManager.Me()
  self:LoadSubView()
  self:InitView()
end

function BattlePassLevelView:InitView()
  self:FindComponent("text1", UILabel).text = ZhString.BattlePassLevelView_text1
  self:FindComponent("text2", UILabel).text = ZhString.BattlePassLevelView_text2
  self:FindComponent("text6", UILabel).text = ZhString.BattlePassLevelView_text6
  self:FindComponent("text4", UILabel).text = ZhString.BattlePassLevelView_text4
  self:FindComponent("text5", UILabel).text = ZhString.BattlePassLevelView_text5
  self.advLock = self:FindGO("advLock")
  self.collLock = self:FindGO("collLock")
  self.upgradeBtn = self:FindGO("upgradeBtn")
  self.upgradeBtnLabel = self:FindComponent("text3", UILabel)
  self.upgradeBtnLabel.text = ""
  self.onekeyBtn = self:FindGO("onekeyBtn")
  self.onekeyUIButton = self.onekeyBtn:GetComponent(BoxCollider)
  self.previewBtn = self:FindGO("previewBtn")
  self.previewBtn:SetActive(false)
  self.collObj = self:FindGO("text6")
  local hasColl = BattlePassProxy.Instance:HasColPass()
  self.collObj:SetActive(hasColl)
  local pos = self.onekeyBtn.transform.localPosition
  if hasColl then
    LuaVector3.Better_Set(tempV3, pos[1], onekeyPos[0], pos[3])
  else
    LuaVector3.Better_Set(tempV3, pos[1], onekeyPos[1], pos[3])
  end
  self.onekeyBtn.transform.localPosition = tempV3
  self.before = self:FindGO("before")
  pos = self.before.transform.localPosition
  if hasColl then
    LuaVector3.Better_Set(tempV3, pos[1], 0, pos[3])
  else
    LuaVector3.Better_Set(tempV3, pos[1], replaceBeforeObj, pos[3])
  end
  self.before.transform.localPosition = tempV3
  local scrollview = self:FindGO("LevelRewardScrollview")
  pos = scrollview.transform.localPosition
  local panel = scrollview:GetComponent(UIPanel)
  if hasColl then
    LuaVector3.Better_Set(tempV3, pos[1], scrollviewPos[0], pos[3])
    panel.clipOffset = LuaVector2(62, scrollviewOffset[0])
  else
    LuaVector3.Better_Set(tempV3, pos[1], scrollviewPos[1], pos[3])
    panel.clipOffset = LuaVector2(62, scrollviewOffset[1])
  end
  scrollview.transform.localPosition = tempV3
  self:AddClickEvent(self.advLock, function()
    self:ToUpgradeView()
  end)
  self:AddClickEvent(self.collLock, function()
    self:ToUpgradeView()
  end)
  self:AddClickEvent(self.upgradeBtn, function()
    self:ToUpgradeView()
  end)
  self:AddClickEvent(self.onekeyBtn, function()
    ServiceBattlePassProxy.Instance:CallGetRewardBattlePassCmd(true, nil, nil, nil)
  end)
  self:AddClickEvent(self.previewBtn, function()
    EventManager.Me():DispatchEvent(BattlePassEvent.ShowRewardPreview)
  end)
  self.bigLevelRewardHolder = self:FindGO("bigLevelRewardHolder")
  self.bigLevelRewardCell = nil
  self.lrcellsv = self:FindComponent("LevelRewardScrollview", UIScrollView)
  local wrapCfg = {
    wrapObj = self:FindGO("LevelRewardGrid"),
    pfbNum = 7,
    cellName = "BattlePassLevelRewardCell",
    control = BattlePassLevelRewardCell,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.itemWrapHelper:AddEventListener(BattlePassEvent.LevelViewSelectRewardIcon, self.HandleSelectRewardIcon, self)
  self:SetLevelReward()
  local go = self:LoadCellPfb("BattlePassNextLevelRewardCell", self:FindGO("bigLevelRewardHolder"))
  self.nextLevelRewardCell = BattlePassLevelRewardCell.new(go)
  local box = go:GetComponent(BoxCollider)
  if box then
    box.enabled = false
  end
  self:UpdateShowNextLevelReward()
end

function BattlePassLevelView:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function BattlePassLevelView:SetLevelReward()
  local levelRewards = {}
  local maxLv = BattlePassProxy.Instance.maxBpLevel or 0
  for i = 1, maxLv do
    TableUtility.ArrayPushBack(levelRewards, BattlePassProxy.Instance:LevelConfig(i))
  end
  self.itemWrapHelper:UpdateInfo(levelRewards)
  
  function self.lrcellsv.onDragStarted()
    self:OnScrollStart()
  end
  
  function self.lrcellsv.onStoppedMoving()
    self:OnScrollStop()
  end
end

function BattlePassLevelView:HandleSelectRewardIcon(itemid)
  self:SetAllRewardUnSelect()
  EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
    type = "item",
    data = {itemid = itemid}
  })
end

function BattlePassLevelView:SetAllRewardUnSelect()
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:SetAllRewardUnSelect()
  end
  self.nextLevelRewardCell:SetAllRewardUnSelect()
end

function BattlePassLevelView:OnEnter()
  EventManager.Me():AddEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  BattlePassLevelView.super.OnEnter(self)
  self:UpdateLevelView()
  self:SetAllRewardUnSelect()
  if BattlePassProxy.Instance:GetUpgradeDepositToBuy(false) then
    self.upgradeStatusObtained = false
    ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  end
  local startLv = BattlePassProxy.BPLevel()
  self.itemWrapHelper:SetStartPositionByIndex(startLv, true)
end

function BattlePassLevelView:OnExit()
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.SelectEvent, self.OnChargeLimitConfirm, self)
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.RefreshZenyCell, self.OnChargeLimitSelect, self)
  if self.nextLevelRewardCell then
    self.nextLevelRewardCell:OnCellDestroy()
    self.nextLevelRewardCell = nil
  end
  BattlePassLevelView.super.OnExit(self)
  tickInstance:ClearTick(self)
  self.scrollUpdateTick = nil
end

function BattlePassLevelView:UpdateLevelView()
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:UpdateStatus()
  end
  self.onekeyBtn:SetActive(true)
  if BattlePassProxy.Instance:HasAvailReward() then
    self.onekeyUIButton.enabled = true
    self:SetTextureWhite(self.onekeyBtn, ColorUtil.ButtonLabelGreen)
  else
    self.onekeyUIButton.enabled = false
    self:SetTextureGrey(self.onekeyBtn)
  end
  if BattlePassProxy.Instance:AdvLevel() > 0 then
    self.advLock:SetActive(false)
  else
    self.advLock:SetActive(true)
  end
  if 0 < BattlePassProxy.Instance:SuLevel() then
    self.collLock:SetActive(false)
  else
    self.collLock:SetActive(true)
  end
  if self.upgradeStatusObtained then
    self:SetUpgradeBtnStatus()
  else
    self.upgradeBtn:SetActive(false)
  end
  self:UpdateShowNextLevelReward()
end

function BattlePassLevelView:OnScrollStart()
  self.scrollUpdateTick = tickInstance:CreateTick(0, 500, self.UpdateShowNextLevelReward, self, 998)
end

function BattlePassLevelView:OnScrollStop()
  tickInstance:ClearTick(self, 998)
end

function BattlePassLevelView:UpdateShowNextLevelReward()
  local maxShowLv = 0
  local cells = self.itemWrapHelper:GetCellCtls()
  local cell
  for i = 1, #cells do
    cell = cells[i]
    if cell.gameObject.activeSelf and maxShowLv < cell.level then
      maxShowLv = cell.level
    end
  end
  local nextLv = BattlePassProxy.Instance:GetNextImportantLv(maxShowLv)
  if self.nextLevelRewardCell.level ~= nextLv then
    self.nextLevelRewardCell:SetData(BattlePassProxy.Instance:LevelConfig(nextLv))
    self.nextLevelRewardCell:SetShowType(1, self.HandleSelectRewardIcon, self)
  end
end

function BattlePassLevelView:ObtainUpgradeStatus()
  self:SetUpgradeBtnStatus()
  self.upgradeStatusObtained = true
end

function BattlePassLevelView:SetUpgradeBtnStatus()
  self.upgradeBtn:SetActive(false)
  if BattlePassProxy.Instance:GetUpgradeDepositToBuy(false) then
    self.upgradeBtn:SetActive(true)
    self.upgradeBtnLabel.text = ZhString.BattlePassLevelView_text3
  end
end

function BattlePassLevelView:ToUpgradeView()
  if BranchMgr.IsJapan() then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ChargeLimitPanel"
    })
  else
    self:ShowUpgrade()
  end
end

function BattlePassLevelView:ShowUpgrade()
  local tobuy, reason_notInSale = BattlePassProxy.Instance:GetUpgradeDepositToBuy(true, true)
  if tobuy then
    EventManager.Me():DispatchEvent(BattlePassEvent.ShowUpgrade)
  elseif reason_notInSale then
    MsgManager.ShowMsgByID(40572)
  else
    MsgManager.ShowMsgByID(41139)
  end
end

function BattlePassLevelView:OnChargeLimitConfirm(id)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "ChargeComfirmPanel",
    cid = id
  })
end

function BattlePassLevelView:OnChargeLimitSelect()
  self:ShowUpgrade()
end
