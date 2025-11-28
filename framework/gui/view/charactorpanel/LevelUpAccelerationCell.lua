autoImport("FloatTableTip")
LevelUpAccelerationCell = class("LevelUpAccelerationCell", BaseCell)
local unactiveTitleCol = "5b7d9a"
local unactiveDescCol = "888787"
local activeTitleCol = "1f74bf"
local activeDescCol = "383838"
local AccelerationType = {
  BASE = 1,
  JOB = 2,
  RUNE = 3
}
local unactiveBgHeightShort = 217
local unactiveBgHeightNormal = 262
local iconWidth = 80
local iconHeight = 80

function LevelUpAccelerationCell:Init()
  self.tableRows = {}
  self:FindObjs()
  local parentPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  if parentPanel then
    self.descPanel.depth = parentPanel.depth + 1
  end
end

function LevelUpAccelerationCell:FindObjs()
  self.titleLabel = self:FindComponent("title", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
  self.speedUpSp = self:FindComponent("speedUp", UISprite)
  self.speedUpLabel = self:FindComponent("ratio", UILabel)
  self.descPanel = self:FindComponent("DescScrollPanel", UIPanel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.unactivePart = self:FindGO("unactivePart")
  self.monthCardPart = self:FindGO("monthCardPart", self.unactivePart)
  self.advancedExtraTipLabel = self:FindComponent("tip", UILabel, self.monthCardPart)
  self:AddButtonEvent("monthCardBtn", function()
    self:OnBuyMonthCardBtnClick()
  end)
  self.shopPart = self:FindGO("shopPart", self.unactivePart)
  self:AddButtonEvent("buyBtn", function()
    self:OnBuyItemBtnClick()
  end)
  self.unactiveLabelPart = self:FindGO("lineBg", self.unactivePart)
  self.unactiveLabel = self:FindComponent("unactiveLabel", UILabel, self.unactiveLabelPart)
  self.activePart = self:FindGO("activePart")
  self.activeLabel = self:FindComponent("activeLabel", UILabel, self.activePart)
  self.unactiveBg = self:FindComponent("unactiveBg", UISprite, self.unactivePart)
  self.helpBtn = self:FindGO("help")
  self.helpSp = self.helpBtn:GetComponent(UISprite)
  self:AddClickEvent(self.helpBtn, function()
    self:OnHelpBtnClick()
  end)
end

function LevelUpAccelerationCell:SetData(data)
  self.data = data
  self.staticData = Table_SpeedUp[data.id]
  self.titleLabel.text = self.staticData.Title
  IconManager:SetItemIcon(self.staticData.Icon, self.icon)
  local scale = self.staticData.IconScale or 1
  self.icon.width = math.floor(iconWidth * scale + 0.5)
  self.icon.height = math.floor(iconHeight * scale + 0.5)
  self.speedUpLabel.text = self.data.addper .. "%"
  self.helpBtn:SetActive(false)
  local maxJobLevel = GameConfig.System.maxjoblevel
  local isMonthCard = MyselfProxy.Instance.month_card_effect
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local isHero = MyselfProxy.Instance:IsHero()
  if self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER then
    local requiredLevel, typeConfig
    local server_open_day = MyselfProxy.Instance.server_open_day
    local openDay = server_open_day < #Table_ExpectedLevel and server_open_day or #Table_ExpectedLevel
    local config = Table_ExpectedLevel[openDay]
    if config then
      local desc
      if self.data.type == AccelerationType.JOB then
        typeConfig = GameConfig.SpeedUp.job
        requiredLevel = config.JobLevel
        local deltaLv = isMonthCard and typeConfig.deposit_card.server_delta_lv or typeConfig.normal.server_delta_lv
        requiredLevel = math.min(requiredLevel - deltaLv, maxJobLevel)
        local jobLevelConfig = Table_JobLevel[requiredLevel]
        local jobPhase = jobLevelConfig and jobLevelConfig.JobPhase or ""
        local showLevel = jobLevelConfig and jobLevelConfig.ShowLevel or requiredLevel
        local ratio = (isMonthCard and typeConfig.deposit_card.server_add_per or typeConfig.normal.server_add_per) .. "%"
        desc = string.format(self.staticData.Desc, jobPhase, showLevel, ratio)
      elseif self.data.type == AccelerationType.BASE then
        typeConfig = GameConfig.SpeedUp.base
        requiredLevel = config.BaseLevel
        local deltaLv = isMonthCard and typeConfig.deposit_card.server_delta_lv or typeConfig.normal.server_delta_lv
        local freeRequiredLevel = math.min(requiredLevel - deltaLv, GameConfig.System.maxbaselevel)
        local ratio = (isMonthCard and typeConfig.deposit_card.server_add_per or typeConfig.normal.server_add_per) .. "%"
        desc = string.format(self.staticData.Desc, freeRequiredLevel, ratio)
      elseif self.data.type == AccelerationType.RUNE then
        TableUtility.ArrayClear(self.tableRows)
        local weekday_when_server_open = ServerTime.GetServerOpenWeekday()
        local curWeek = math.floor(server_open_day / 7)
        curWeek = 7 < server_open_day % 7 + (weekday_when_server_open - 1) and curWeek + 1 or curWeek
        local week = curWeek < #Table_GemSpeedUp and curWeek or #Table_GemSpeedUp
        local config = Table_GemSpeedUp[week]
        local runeExp = config and config.value or 0
        local myRuneExp = BagProxy.Instance:GetTotalGemExp()
        local rune_exp_speedup = GameConfig.SpeedUp.gem_exp_speedup
        local bound_per = rune_exp_speedup.rate
        local addper = 0
        for i = 1, #bound_per do
          local ratioMin = bound_per[i - 1] and bound_per[i - 1][1] or 0
          local ratioMax = bound_per[i][1]
          local min = math.floor(ratioMin / 100 * runeExp + 0.5)
          local max = math.floor(ratioMax / 100 * runeExp + 0.5)
          if myRuneExp >= min and myRuneExp < max then
            addper = bound_per[i][2]
          end
          local row = {}
          row.key = min .. "-" .. max - 1
          row.value = "+" .. bound_per[i][2]
          self.tableRows[#self.tableRows + 1] = row
        end
        desc = string.format(self.staticData.Desc, addper)
        self.helpBtn:SetActive(true)
      end
      self.descLabel.text = desc
    end
  elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM then
    local useItem = MyselfProxy.Instance:IsProfessionSpeedUp(myPro)
    if self.data.type == AccelerationType.BASE then
      local maxBaseLevel = self.staticData.Param.max_base_lv
      local ratio = GameConfig.SpeedUp.base.buy_item_per .. "%"
      if useItem then
        local desc = not StringUtil.IsEmpty(self.staticData.WorkedDesc) and self.staticData.WorkedDesc or self.staticData.Desc
        self.descLabel.text = string.format(desc, maxBaseLevel, ratio)
      else
        self.descLabel.text = string.format(self.staticData.Desc, maxBaseLevel, ratio)
      end
    else
      local ratio = GameConfig.SpeedUp.job.buy_item_per .. "%"
      local proName = MyselfProxy.Instance:GetMyProfessionName()
      local branchName = proName
      local typeBranchNameIdMap = GameConfig.NewClassEquip.typeBranchNameIdMap
      local typeBranch
      if myPro == 150 then
        typeBranch = 81
      else
        typeBranch = ProfessionProxy.GetTypeBranchFromProf(myPro)
      end
      local classId = typeBranchNameIdMap[typeBranch]
      if classId then
        local className = ProfessionProxy.GetProfessionName(classId, MyselfProxy.Instance:GetMySex())
        branchName = className .. ZhString.ItemTip_ProSeriesPrefix
      end
      if useItem then
        local config = Table_Class[myPro]
        local advanceClass = config.AdvanceClass
        local maxLevel = config.MaxPeak or config.MaxJobLevel
        local classId = myPro
        local _myselfProxy = MyselfProxy.Instance
        while advanceClass and advanceClass ~= _EmptyTable do
          for i = 1, #advanceClass do
            classId = advanceClass[i]
            if _myselfProxy:IsProfessionSpeedUp(classId) then
              break
            end
          end
          config = Table_Class[classId]
          advanceClass = config.AdvanceClass
          maxLevel = config.MaxPeak or config.MaxJobLevel
        end
        local desc = not StringUtil.IsEmpty(self.staticData.WorkedDesc) and self.staticData.WorkedDesc or self.staticData.Desc
        if isHero then
          self.descLabel.text = string.format(desc, proName, "Lv." .. maxLevel, ratio)
        else
          local jobLevelConfig = Table_JobLevel[maxLevel]
          local jobPhase = jobLevelConfig and jobLevelConfig.JobPhase or ""
          local showLevel = jobLevelConfig and jobLevelConfig.ShowLevel or ""
          showLevel = string.format("%sLv.%s", jobPhase, showLevel)
          self.descLabel.text = string.format(desc, branchName, showLevel, ratio)
        end
      else
        self.descLabel.text = string.format(self.staticData.Desc, ratio)
      end
    end
  elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_CARD_NOT_TIRE then
    local config = Table_DepositFunction[1]
    local ratio = config.DescArgument[1] .. "%"
    self.descLabel.text = string.format(self.staticData.Desc, ratio)
  elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_CARD_COMMON then
    local configid = self.data.type == AccelerationType.BASE and 2 or 3
    local config = Table_DepositFunction[configid]
    local ratio = config.DescArgument[1] .. "%"
    self.descLabel.text = string.format(self.staticData.Desc, ratio)
  elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_DIFF_JOB then
    local typeConfig = GameConfig.SpeedUp.job
    local ratio = (isMonthCard and typeConfig.deposit_card.self_job_per or typeConfig.normal.self_job_per) .. "%"
    self.descLabel.text = string.format(self.staticData.Desc, ratio)
  elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_CARD_RAID then
    local config = Table_DepositFunction[32]
    local ratio = config.DescArgument[1] .. "%"
    self.descLabel.text = string.format(self.staticData.Desc, ratio)
  end
  local active = self.data.addper > 0
  local isExpItem = MyselfProxy.Instance:IsProfessionSpeedUp(myPro)
  local isHighestJob = MyselfProxy.Instance.in_max_profession
  self:SetAccelerationState(active, isMonthCard, isExpItem, isHighestJob, isHero, maxJobLevel)
end

function LevelUpAccelerationCell:SetAccelerationState(active, isMonthCard, isExpItem, isHighestJob, isHero, maxJobLevel)
  self.speedUpSp.color = active and ColorUtil.NGUIWhite or ColorUtil.NGUIShaderGray
  self.icon.color = active and ColorUtil.NGUIWhite or ColorUtil.NGUIShaderGray
  local titleColStr = active and activeTitleCol or unactiveTitleCol
  local descColStr = active and activeDescCol or unactiveDescCol
  local _, tc = ColorUtil.TryParseHexString(titleColStr)
  self.titleLabel.color = tc
  local _, dc = ColorUtil.TryParseHexString(descColStr)
  self.descLabel.color = dc
  self.unactiveBg.height = unactiveBgHeightNormal
  local server_open_day = MyselfProxy.Instance.server_open_day
  local openDay = server_open_day < #Table_ExpectedLevel and server_open_day or #Table_ExpectedLevel
  if self.data.type == AccelerationType.JOB then
    local typeConfig = GameConfig.SpeedUp.job
    local depositDeltaLv = typeConfig.deposit_card.server_delta_lv
    if isHero and (self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_DIFF_JOB or self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER) then
      self.unactivePart:SetActive(true)
      self.unactiveLabelPart:SetActive(true)
      self.activePart:SetActive(false)
      self.monthCardPart:SetActive(false)
      self.shopPart:SetActive(false)
      self.unactiveLabel.text = self.staticData.IneligibleTip
      self.advancedExtraTipLabel.text = ""
      self.unactiveBg.height = unactiveBgHeightShort
      return
    end
    if isHighestJob then
      if self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER then
        local myJob = MyselfProxy.Instance:JobLevel()
        local config = Table_ExpectedLevel[openDay]
        if config then
          local requiredLevel = config.JobLevel
          local depositRequiredLevel = math.min(requiredLevel - depositDeltaLv, maxJobLevel)
          local depositRatio = typeConfig.deposit_card.server_add_per
          if myJob < depositRequiredLevel then
            self.unactivePart:SetActive(not isMonthCard)
            self.activePart:SetActive(isMonthCard)
            self.monthCardPart:SetActive(not isMonthCard)
            self.shopPart:SetActive(false)
            self.unactiveLabelPart:SetActive(false)
            self.activeLabel.text = self.staticData.AdvancedWorkedTip
            local jobLevelConfig = Table_JobLevel[depositRequiredLevel]
            local jobPhase = jobLevelConfig and jobLevelConfig.JobPhase or ""
            local showLevel = jobLevelConfig and jobLevelConfig.ShowLevel or depositRequiredLevel
            self.advancedExtraTipLabel.text = string.format(self.staticData.AdvancedExtraTip, jobPhase, showLevel, depositRatio .. "%")
          else
            self.unactivePart:SetActive(true)
            self.activePart:SetActive(false)
            self.monthCardPart:SetActive(false)
            self.shopPart:SetActive(false)
            self.unactiveLabelPart:SetActive(true)
            self.unactiveLabel.text = self.staticData.IneligibleTip
            self.unactiveBg.height = unactiveBgHeightShort
          end
        end
        return
      elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_DIFF_JOB then
        self.unactivePart:SetActive(true)
        self.activePart:SetActive(false)
        self.monthCardPart:SetActive(false)
        self.shopPart:SetActive(false)
        self.unactiveLabelPart:SetActive(true)
        self.unactiveLabel.text = self.staticData.IneligibleTip
        self.unactiveBg.height = unactiveBgHeightShort
        return
      end
    elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER then
      self.unactivePart:SetActive(true)
      self.activePart:SetActive(false)
      self.monthCardPart:SetActive(false)
      self.shopPart:SetActive(false)
      self.unactiveLabelPart:SetActive(true)
      self.unactiveLabel.text = self.staticData.IneligibleTip
      self.unactiveBg.height = unactiveBgHeightShort
      return
    elseif self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_DIFF_JOB then
      self.unactivePart:SetActive(not isMonthCard)
      self.activePart:SetActive(isMonthCard)
      self.monthCardPart:SetActive(not isMonthCard)
      self.shopPart:SetActive(false)
      self.unactiveLabelPart:SetActive(false)
      self.activeLabel.text = self.staticData.AdvancedWorkedTip
      self.advancedExtraTipLabel.text = string.format(self.staticData.AdvancedExtraTip, typeConfig.deposit_card.self_job_per .. "%")
      return
    end
  elseif self.data.type == AccelerationType.BASE then
    if self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER then
      local typeConfig = GameConfig.SpeedUp.base
      local depositDeltaLv = typeConfig.deposit_card.server_delta_lv
      local myLevel = MyselfProxy.Instance:RoleLevel()
      local config = Table_ExpectedLevel[openDay]
      if config then
        local requiredLevel = config.BaseLevel
        local depositRequiredLevel = math.min(requiredLevel - depositDeltaLv, GameConfig.System.maxbaselevel)
        local depositRatio = typeConfig.deposit_card.server_add_per
        if myLevel < depositRequiredLevel then
          self.unactivePart:SetActive(not isMonthCard)
          self.activePart:SetActive(isMonthCard)
          self.monthCardPart:SetActive(not isMonthCard)
          self.shopPart:SetActive(false)
          self.unactiveLabelPart:SetActive(false)
          self.activeLabel.text = self.staticData.AdvancedWorkedTip
          self.advancedExtraTipLabel.text = string.format(self.staticData.AdvancedExtraTip, depositRequiredLevel, depositRatio .. "%")
        else
          self.unactivePart:SetActive(true)
          self.activePart:SetActive(false)
          self.monthCardPart:SetActive(false)
          self.shopPart:SetActive(false)
          self.unactiveLabelPart:SetActive(true)
          self.unactiveLabel.text = self.staticData.IneligibleTip
          self.unactiveBg.height = unactiveBgHeightShort
        end
      end
      return
    end
  elseif self.data.type == AccelerationType.RUNE then
    self.unactivePart:SetActive(not active)
    self.activePart:SetActive(active)
    self.monthCardPart:SetActive(false)
    self.shopPart:SetActive(false)
    self.unactiveLabelPart:SetActive(not active)
    if active then
      self.activeLabel.text = string.format(self.staticData.AdvancedWorkedTip)
    else
      self.unactiveLabel.text = string.format(self.staticData.IneligibleTip)
      self.unactiveBg.height = unactiveBgHeightShort
    end
    return
  end
  local isActive
  if self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM and self.data.type == AccelerationType.BASE then
    isActive = active
  else
    isActive = active and (isMonthCard or isExpItem) or false
  end
  self.unactivePart:SetActive(not isActive)
  self.activePart:SetActive(isActive)
  if not active then
    local showMonthCardPart = self.data.category ~= ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM and not isMonthCard
    self.monthCardPart:SetActive(showMonthCardPart)
    local showShopPart = self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM and not isExpItem
    self.shopPart:SetActive(showShopPart)
    self.unactiveLabelPart:SetActive(true)
    if not showMonthCardPart and not showShopPart then
      self.unactiveBg.height = unactiveBgHeightShort
    end
    if self.data.category ~= ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM and isMonthCard or self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_ITEM and isExpItem then
      self.unactiveLabel.text = self.staticData.IneligibleTip
    else
      self.unactiveLabel.text = self.staticData.NoAdvancedTip
    end
  else
    self.activeLabel.text = self.staticData.AdvancedWorkedTip
  end
end

function LevelUpAccelerationCell:OnBuyMonthCardBtnClick()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard, FunctionNewRecharge.InnerTab.Card_MonthlyVIP)
end

function LevelUpAccelerationCell:OnBuyItemBtnClick()
  local jumpToShopItem = self.data.type == AccelerationType.BASE and GameConfig.SpeedUp.base.buy_item_shop_id or GameConfig.SpeedUp.job.buy_item_shop_id
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THot, FunctionNewRecharge.InnerTab.Shop_Normal1, {jumpToShopItem = jumpToShopItem})
end

function LevelUpAccelerationCell:OnHelpBtnClick()
  if self.data.category == ESPEEDUPTYPE.ESPEEDUP_TYPE_SERVER and self.data.type == AccelerationType.RUNE then
    local data = {}
    local myRuneExp = BagProxy.Instance:GetTotalGemExp()
    data.desc = string.format(ZhString.SpeedUp_MyRuneExp, myRuneExp)
    data.columnTitle1 = ZhString.SpeedUp_ExpInterval
    data.columnTitle2 = ZhString.SpeedUp_AddExp
    data.tableRows = self.tableRows
    TipsView.Me():ShowStickTip(FloatTableTip, data, NGUIUtil.AnchorSide.TopRight, self.helpSp)
  end
end
