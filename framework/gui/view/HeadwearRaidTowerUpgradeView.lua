autoImport("HeadwearRaidTowerUpgradeCell")
HeadwearRaidTowerUpgradeView = class("HeadwearRaidTowerUpgradeView", ContainerView)
HeadwearRaidTowerUpgradeView.ViewType = UIViewType.NormalLayer

function HeadwearRaidTowerUpgradeView:Init()
  self:InitData()
  self:InitView()
  self:AddEvents()
end

function HeadwearRaidTowerUpgradeView:InitData()
  self.cr = {}
  self.upgrade_cr = {}
  self.upgrade_info = {}
end

function HeadwearRaidTowerUpgradeView:InitView()
  self.btn1 = self:FindGO("btn1")
  self.btn2 = self:FindGO("btn2")
  local hideType = {hideClickSound = true, hideClickEffect = true}
  self:AddPressEvent(self.btn1, function(go, press)
    self:PressDelayUpgrade(press, 1)
  end, hideType)
  self:AddPressEvent(self.btn2, function(go, press)
    self:PressDelayUpgrade(press, 2)
  end, hideType)
  self.res1Sp = self:FindComponent("res1", UISprite)
  self.res2Sp = self:FindComponent("res2", UISprite)
  self.res1numLb = self:FindComponent("res1num", UILabel)
  self.res2numLb = self:FindComponent("res2num", UILabel)
  self.btn1Sp = self:FindComponent("Sprite", UISprite, self.btn1)
  self.btn2Sp = self:FindComponent("Sprite", UISprite, self.btn2)
  self.upgrade1Lb = self:FindComponent("CountdownLabel1", UILabel)
  self.upgrade2Lb = self:FindComponent("CountdownLabel2", UILabel)
  self.upgrade1Slider = self:FindComponent("CountdownSlider1", UISlider)
  self.upgrade2Slider = self:FindComponent("CountdownSlider2", UISlider)
  self.btn = {
    self.btn1,
    self.btn2
  }
  self.resSp = {
    self.res1Sp,
    self.res2Sp
  }
  self.resnumLb = {
    self.res1numLb,
    self.res2numLb
  }
  self.btnSp = {
    self.btn1Sp,
    self.btn2Sp
  }
  self.upgradeLb = {
    self.upgrade1Lb,
    self.upgrade2Lb
  }
  self.upgradeSlider = {
    self.upgrade1Slider,
    self.upgrade2Slider
  }
  self.title = self:FindComponent("title", UILabel)
  self.upgradeScrollView = self:FindComponent("ItemScrollView", UIScrollView)
  self.upgradeGrid = self:FindComponent("shop_itemContainer", UITable)
  self.upgradeListCtl = UIGridListCtrl.new(self.upgradeGrid, HeadwearRaidTowerUpgradeCell, "HeadwearRaidTowerUpgradeCell")
  self.upgradeListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self)
  local longpresshint = self:FindComponent("longpresshint", UILabel)
  longpresshint.text = ZhString.HeadwearRaid_TowerUpgradeLongPressHint
end

function HeadwearRaidTowerUpgradeView:OnEnter()
  HeadwearRaidTowerUpgradeView.super.OnEnter(self)
  self.npcdata = self.viewdata.npcdata
  self.towerid = self.npcdata.data.staticData.id
  self.isactivity = HeadwearRaidProxy.Instance.isActivityRaid
  if self.isactivity then
    self.config = GameConfig.HeadWearActivity
  else
    self.config = GameConfig.HeadWear
  end
  local sceneUI = self.npcdata:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleBottomUI:ShowHeadwearRaidTowerInfo(false)
  end
  self.isEverAutoBattle = Game.AutoBattleManager.on
  FunctionSystem.InterruptMyselfAI()
  self:CameraFaceTo(self.npcdata.assetRole.completeTransform, CameraConfig.HappyShop_ViewPort, CameraConfig.HappyShop_Rotation)
  self.title.text = OverSea.LangManager.Instance():GetLangByKey(self.npcdata.data.staticData.NameZh)
  self:UpdateInfo()
end

function HeadwearRaidTowerUpgradeView:OnExit()
  self:CameraReset()
  local sceneUI = self.npcdata:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleBottomUI:ShowHeadwearRaidTowerInfo(true)
  end
  if self.delayUpgradeId then
    self:CallUpgrade()
  end
  if self.pressedTimer then
    TimeTickManager.Me():ClearTick(self, self.pressedTimer.id)
    self.pressedTimer = nil
  end
  if self.isEverAutoBattle then
    Game.AutoBattleManager:AutoBattleOn()
  end
end

function HeadwearRaidTowerUpgradeView:AddEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.RaidCmdHeadwearActivityTowerUserCmd, self.UpdateInfo)
end

function HeadwearRaidTowerUpgradeView:UpdateInfo()
  local info = HeadwearRaidProxy.Instance:GetTowerInfo(self.towerid)
  if self.delayUpgradeId then
    TimeTickManager.Me():ClearTick(self, self.delayUpgradeId.id)
    self.delayUpgradeId = nil
  end
  self:SetLv(info)
  self:SetCr(info)
end

local str_format = "%s Lv.%d"

function HeadwearRaidTowerUpgradeView:SetLv(info)
  TableUtility.ArrayClear(self.upgrade_info)
  local towerinfo = self.config.tower[info.id]
  for k, v in ipairs(towerinfo.upgrade) do
    TableUtility.ArrayPushBack(self.upgrade_info, {
      curlevel = info.level,
      level = k,
      info = v,
      lastinfo = towerinfo.upgrade[k - 1],
      cr1 = towerinfo.crystlA,
      cr2 = towerinfo.crystlB
    })
  end
  self.upgradeListCtl:ResetDatas(self.upgrade_info)
  self.upgradeScrollView:ResetPosition()
  self.title.text = string.format(str_format, self.npcdata.data.staticData.NameZh, info.level)
end

function HeadwearRaidTowerUpgradeView:SetCr(info)
  TableUtility.ArrayClear(self.cr)
  TableUtility.TableClear(self.upgrade_cr)
  for i = 1, #info.crystalInfo do
    local id = info.crystalInfo[i]
    local num = info.crystals[id]
    TableUtility.ArrayPushBack(self.cr, {k = id, v = num})
    self.upgrade_cr[id] = 0
  end
  local towerInfo = self.config.tower[info.id]
  local crneed = {}
  for i = 1, 2 do
    local itemid = info.crystalInfo[i]
    local icon = Table_Item[itemid].Icon
    IconManager:SetItemIcon(icon, self.resSp[i])
    IconManager:SetItemIcon(icon, self.btnSp[i])
    self.resnumLb[i].text = HeadwearRaidProxy.Instance.crystals[itemid]
    local curNum = info.crystals[itemid]
    local nextLv = info.level + 1
    local needNum = towerInfo.upgrade[nextLv] and towerInfo.upgrade[nextLv][i] or 0
    local curLvNum = towerInfo.upgrade[info.level] and towerInfo.upgrade[info.level][i] or 0
    if needNum == 0 then
      self.upgradeLb[i].text = "max"
      self.upgradeSlider[i].value = 1
      self:SetTextureGrey(self.btn[i])
    else
      self.upgradeLb[i].text = tostring(curNum - curLvNum) .. "/" .. tostring(needNum - curLvNum)
      self.upgradeSlider[i].value = (curNum - curLvNum) / (needNum - curLvNum)
      self:SetTextureWhite(self.btn[i])
    end
    crneed[i] = math.max(0, needNum - curNum)
  end
  TableUtility.ArrayClear(self.upgrade_info)
  local towerinfo = self.config.tower[info.id]
  for k, v in ipairs(towerinfo.upgrade) do
    TableUtility.ArrayPushBack(self.upgrade_info, {
      curlevel = info.level,
      level = k,
      info = v,
      lastinfo = towerinfo.upgrade[k - 1],
      cr1 = towerinfo.crystlA,
      cr2 = towerinfo.crystlB,
      cr1n = crneed[1],
      cr2n = crneed[2]
    })
  end
  self.upgradeListCtl:ResetDatas(self.upgrade_info)
end

function HeadwearRaidTowerUpgradeView:PressDelayUpgrade(isPressed, i)
  if isPressed then
    if self.pressedIndex ~= i then
      if self.pressedTimer then
        TimeTickManager.Me():ClearTick(self, self.pressedTimer.id)
        self.pressedTimer = nil
      end
      self.pressedIndex = i
      self.pressedTimer = TimeTickManager.Me():CreateTick(0, 100, function()
        self:DelayUpgrade(i)
      end, self)
    end
  elseif self.pressedIndex == i then
    if self.pressedTimer then
      TimeTickManager.Me():ClearTick(self, self.pressedTimer.id)
      self.pressedTimer = nil
    end
    self.pressedIndex = nil
  end
end

function HeadwearRaidTowerUpgradeView:DelayUpgrade(i)
  if not self.cr or not self.cr[i] then
    return
  end
  local k = self.cr[i].k
  if self.upgrade_cr[k] and self.upgrade_cr[k] >= HeadwearRaidProxy.Instance.crystals[k] then
    return
  end
  if self.upgrade_cr[k] then
    self.upgrade_cr[k] = self.upgrade_cr[k] + 1
  else
    self.upgrade_cr[k] = 1
  end
  if self.delayUpgradeId then
    TimeTickManager.Me():ClearTick(self, self.delayUpgradeId.id)
    self.delayUpgradeId = nil
  end
  self:CallUpgrade()
end

function HeadwearRaidTowerUpgradeView:CallUpgrade()
  local info = HeadwearRaidProxy.Instance:GetTowerInfo(self.towerid)
  local towerInfo = self.config.tower[info.id]
  if info and towerInfo and towerInfo.upgrade and info.level and towerInfo.upgrade[info.level + 1] then
    HeadwearRaidProxy.Instance:CallUpgradeTower(self.towerid, self.upgrade_cr)
  end
  for k, _ in pairs(self.upgrade_cr) do
    self.upgrade_cr[k] = 0
  end
end

function HeadwearRaidTowerUpgradeView:ClickSkill(skillCell)
  local skillData = skillCell.data
  if type(skillData) == "number" then
    TipManager.Instance:ShowPetSkillTip(SkillItemData.new(skillCell.data), self.skillTipStick, NGUIUtil.AnchorSide.TopLeft, {-185, 0})
  end
end
