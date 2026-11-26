local BaseCell = autoImport("BaseCell")
SceneBottomHpSpCell = reusableClass("SceneBottomHpSpCell", BaseCell)
autoImport("SceneTimeDiskInfo")
autoImport("SceneStarMap")
autoImport("SceneFeatherGrid")
autoImport("SceneEnergyGrid")
autoImport("SceneBalanceBar")
autoImport("SceneSolarEnergy")
autoImport("SceneChargeBar")
autoImport("SceneKickCountBar")
autoImport("SceneBottomBloodBar")
SceneBottomHpSpCell.resId = ResourcePathHelper.UIPrefab_Cell("SceneBottomHpSpCell")
local tempVector3 = LuaVector3.Zero()
SceneBottomHpSpCell.PoolSize = 30
local TwelvePvpConfig = GameConfig.TwelvePvp.HpShow
local sliderLength = 115
local DynamicLayoutMetrics = {
  Resistance = {height = 10, move = 29},
  BloodDetail = {height = 10, move = 13},
  Blood = {height = 10, move = 10},
  ExtraBar = {height = 10, move = 12},
  Balance = {height = 10, move = 12},
  Charge = {height = 10, move = 12},
  ResistanceBar = {height = 10, move = 12},
  Sp = {height = 10, move = 12},
  Frenzy = {height = 10, move = 12},
  Energy = {height = 10, move = 12},
  TimeDisk = {height = 10, move = 12},
  StarMap = {height = 10, move = 12},
  Feather = {height = 10, move = 12},
  KickCount = {height = 10, move = 12},
  Name = {height = 13, move = 13},
  Sanity = {height = 10, move = 10}
}
local DynamicLayoutBarHeight = DynamicLayoutMetrics.ExtraBar.height
local DynamicLayoutTextHeight = DynamicLayoutMetrics.Name.height
local DynamicLayoutNameGap = DynamicLayoutMetrics.ExtraBar.move - DynamicLayoutMetrics.ExtraBar.height + 2
local DynamicLayoutDefaultBloodY = -10
local DynamicLayoutGetMetricHeight = function(metric, fallback)
  local config = DynamicLayoutMetrics[metric]
  return config and config.height or fallback or DynamicLayoutBarHeight
end
local DynamicLayoutGetMetricMove = function(metric)
  local config = DynamicLayoutMetrics[metric]
  return config and config.move or DynamicLayoutMetrics.ExtraBar.move
end
local DynamicLayoutIsValidGO = function(go)
  return go and not LuaGameObject.ObjectIsNull(go)
end
local DynamicLayoutSetY = function(go, y)
  if not DynamicLayoutIsValidGO(go) then
    return
  end
  local rect = go:GetComponent(RectTransform)
  if not rect then
    return
  end
  local pos = rect.anchoredPosition
  rect.anchoredPosition = LuaGeometry.GetTempVector2(pos.x, y)
end

function SceneBottomHpSpCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function SceneBottomHpSpCell:DoConstruct(asArray, args)
  self._alive = true
  local gameObject = args[1]
  local creature = args[2]
  self.gameObject = gameObject
  self.transform = self.gameObject.transform
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  self.transform.localPosition = tempVector3
  self.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.canvasGroup = gameObject:GetComponent(CanvasGroup)
  self.deadSlideAnim = false
  self:initData(creature)
  if self:isPushMinion() then
    LuaVector3.Better_Set(tempVector3, 0.5, 1, 1)
  else
    LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  end
  self.transform.localScale = tempVector3
  self:initHpView()
  self:initSpView()
  local buffhp, buffmaxhp = creature.data:GetBuffHpVals()
  if buffhp then
    self:SetHp(buffhp, buffmaxhp or 1)
  else
    local value = creature.data:GetHP()
    local MaxValue = creature.data.props:GetPropByName("MaxHp"):GetValue()
    self:SetHp(value, MaxValue)
  end
  value = creature.data.props:GetPropByName("Sp"):GetValue()
  MaxValue = creature.data.props:GetPropByName("MaxSp"):GetValue()
  local spTrans = creature.data.spTrans
  self:SetSp(value, MaxValue, spTrans)
  if self.mySanity and not self.ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
    self.mySanity = nil
    self.sanityPrefab = nil
  end
  self.scaleTween = self.gameObject:GetComponent(TweenScale)
  if self:isPushMinion() then
    self.scaleTween.from = LuaGeometry.GetTempVector3(0.7, 1, 1)
    self.scaleTween.to = LuaGeometry.GetTempVector3(0.5, 1, 1)
  else
    self.scaleTween.from = LuaGeometry.GetTempVector3(1.5, 1.5, 1.5)
    self.scaleTween.to = LuaGeometry.GetTempVector3(1, 1, 1)
  end
  self:InitExecutePart()
  self:InitDynamicLayout()
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:Deconstruct(asArray)
  self:ResetDynamicLayoutPositions()
  self:_RemoveKickCountBar(SceneKickCountBar.Kind.Wall)
  self:_RemoveKickCountBar(SceneKickCountBar.Kind.Entity)
  self.kickCountRowCount = 0
  self.kickCountRowHeight = nil
  self.kickCountBars = nil
  if self.bossBloodBar then
    self.bossBloodBar:Destroy()
    self.bossBloodBar = nil
  end
  if self.bossBloodBarGO then
    LuaGameObject.DestroyObject(self.bossBloodBarGO)
    self.bossBloodBarGO = nil
  end
  if self.bloodBar then
    self.bloodBar:SetVisible(true)
    self.bloodBar:Destroy()
    self.bloodBar = nil
  end
  self.isBossBloodBarActive = false
  self.buffHpGridCount = nil
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    if self.spSliderObj and not LuaGameObject.ObjectIsNull(self.spSliderObj) then
      LeanTween.cancel(self.spSliderObj)
    end
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomHpSpCell.resId, self.gameObject)
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.canvasGroup = nil
  self.spCanvasGroup = nil
  self.sanityCanvasGroup = nil
  self.uibloodcontainer = nil
  self.bloodDetailCanvasGroup = nil
  self.uibloodslider = nil
  self.uibloodGO = nil
  self.uiblood = nil
  if self.uiWuDi then
    self.uiWuDi:SetActive(false)
    self.uiWuDi = nil
  end
  self.tweenbloodslider = nil
  self.tweenbloodslider = nil
  self.bloodDetailContainer = nil
  self.bloodVolume = nil
  self.spContainer = nil
  self.spSlider = nil
  self.spSliderObj = nil
  self.gameObject = nil
  self.transform = nil
  self.hpbg = nil
  self._alive = false
  if not self:ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
  end
  self.sanityContainer = nil
  self.sanityPrefab = nil
  self.mySanity = nil
  self.sanityPercent = nil
  self.forebg = nil
  self.scaleTween = nil
  if self.exMaxHp and 0 < self.exMaxHp then
    self.exMaxHp = nil
    if not Slua.IsNull(self.hpGrid) then
      self.hpGrid:SetActive(false)
    end
  end
  if self.hpGridElements then
    for i = 1, #self.hpGridElements do
      if not Slua.IsNull(self.hpGridElements[i]) then
        GameObject.Destroy(self.hpGridElements[i])
      end
    end
  end
  self.hpGrid = nil
  self.hpGridElements = nil
  self.hpSplitTemplate = nil
  self.spGrid = nil
  self.spGridElements = nil
  self.bulletsContainer = nil
  self.bulletsPrefab = nil
  self.bulletsNum = nil
  if self.sceneSolarEnergy then
    self.sceneSolarEnergy:Destroy()
    self.sceneSolarEnergy = nil
  end
  self:RemoveFrenzy()
  self.frenzyContainer = nil
  self.hasFrenzy = nil
  self.hasSolarEnergy = nil
  self.hasEnergy = nil
  self.hasFeather = nil
  self.frenzyCanvasGroup = nil
  self.myFrenzySlider = nil
  self.frenzyLayer = nil
  self.timeDiskContainer = nil
  self.starMapContainer = nil
  self.extraBgContainer = nil
  self.extraBgPrefab = nil
  self.extraBgRect = nil
  self.extraContainer = nil
  self.resistanceContainer = nil
  self.dynamicLayoutRows = nil
  self.dynamicLayoutBottomCursor = nil
  self.dynamicLayoutTopCursor = nil
  self.dynamicLayoutBloodY = nil
  self.dynamicLayoutInitialized = nil
  self.dynamicLayoutDefaultRows = nil
  self:RemoveTimeDisk()
  self:RemoveStarMap()
  self.executePart = nil
  self.executeCanvasGroup = nil
  self.executeLine = nil
  self.executeIcon = nil
  self.initExecute = false
  self.executeBg = nil
  self.hpGridLayerout = nil
  self.balanceContainer = nil
  self.chargeContainer = nil
  self:RemoveFeatherGrid()
  self:ResetShieldHp()
  self:RemoveExtraBars()
  self:RemoveShield()
  self.chargeConfig = nil
  self.campIcon = nil
  self:RemoveBlackMuck()
end

function SceneBottomHpSpCell:Exit()
  TableUtility.TableClear(tempTable)
end

function SceneBottomHpSpCell:initData(creature)
  if not creature.GetCreatureType then
    Debug.LogError(string.format("No Find CreatureType:%s", creature.__cname))
  end
  self.creatureType = creature:GetCreatureType()
  self.camp = creature.data:GetCamp()
  self.detailedType = creature.data.detailedType
  self.ismyself = self.creatureType == Creature_Type.Me
  self.isFirstSpInit = true
  self.isFirstHpInit = true
  self.isBeHi = false
  self.hasFrenzy = false
  self.hasSolarEnergy = false
  self.hasEnergy = false
  self.hasFeather = false
  self.bosstype = creature:GetBossType()
  self.staticID = creature.data.staticData and creature.data.staticData.id
  self.resistanceBar = creature.data.staticData and creature.data.staticData.ResistanceBar or nil
  self.showBalance = creature.data.staticData and creature.data.staticData.BalanceBar
  self.chargeConfig = creature.data:HasChargeBar() and self:CreateChargeConfig(creature) or nil
  self.creature = creature
end

function SceneBottomHpSpCell:initHpView()
  self.uibloodcontainer = self:FindGO("BloodContainer")
  self.bloodBar = SceneBottomBloodBar.new(self:FindGO("BloodBar", self.uibloodcontainer), self)
  self.isBossBloodBarActive = false
  self.bloodBar:SetVisible(true)
  self.bloodBar:RefreshCampBg()
  self:initDecorate()
  self:initHpValueLabel()
end

function SceneBottomHpSpCell:initHpValueLabel()
  self.bloodDetailContainer = self:FindGO("BloodDetailContainer")
  if not self.bloodDetailCanvasGroup then
    self.bloodDetailCanvasGroup = self.bloodDetailContainer:GetComponent(CanvasGroup)
  end
  if Game.MapManager:IsPVEMode() and self:isMvpOrMini() or GvgProxy.Instance:IsFireState() and self:isPlayer() then
    self.bloodVolume = self:FindComponent("BloodVolume", Text)
    self.bloodVolume.text = ""
    self:SetActive(self.bloodDetailCanvasGroup, true)
  else
    self:SetActive(self.bloodDetailCanvasGroup, false)
    self.bloodVolume = nil
  end
end

function SceneBottomHpSpCell:initSpView()
  local spContainer = self:FindGO("SpContainer")
  if not self.spCanvasGroup then
    self.spCanvasGroup = spContainer:GetComponent(CanvasGroup)
  end
  if self.ismyself then
    self:SetActive(self.spCanvasGroup, true)
    self.spContainer = spContainer
    local spSlider = self:FindGO("SpSlider"):GetComponent(Slider)
    self.spSlider = spSlider
    self.spSliderObj = spSlider.gameObject
  else
    self:SetActive(self.spCanvasGroup, false)
  end
end

function SceneBottomHpSpCell:SetActive(canvasGroup, visible, isRoot)
  if not canvasGroup then
    return
  end
  canvasGroup.alpha = visible and 1 or 0
end

function SceneBottomHpSpCell:InitDynamicLayout()
  if self.dynamicLayoutInitialized then
    return
  end
  self.dynamicLayoutInitialized = true
  self.extraBgContainer = self:FindGO("ExtraBgContainer")
  self.extraContainer = self:FindGO("ExtraContainer")
  self.resistanceContainer = self:FindGO("ResistanceContainer")
  self.dynamicLayoutDefaultRows = {}
  local addDefaultContainer = function(go)
    if DynamicLayoutIsValidGO(go) then
      local rect = go:GetComponent(RectTransform)
      if rect then
        table.insert(self.dynamicLayoutDefaultRows, {
          go = go,
          y = rect.anchoredPosition.y
        })
      end
    end
  end
  addDefaultContainer(self.resistanceContainer)
  addDefaultContainer(self.bloodDetailContainer)
  addDefaultContainer(self.uibloodcontainer)
  addDefaultContainer(self.extraContainer)
  addDefaultContainer(self.spContainer or self:FindGO("SpContainer"))
  addDefaultContainer(self.frenzyContainer or self:FindGO("FrenzyContainer"))
  addDefaultContainer(self.energyContainer or self:FindGO("EnergyContainer"))
  addDefaultContainer(self.timeDiskContainer or self:FindGO("TimeDiskContainer"))
  addDefaultContainer(self.starMapContainer or self:FindGO("StarMapContainer"))
  addDefaultContainer(self.featherContainer or self:FindGO("FeatherContainer"))
  self.kickCountContainer = self:FindGO("KickCountContainer")
  addDefaultContainer(self.kickCountContainer)
  addDefaultContainer(self.sanityContainer or self:FindGO("SanityContainer"))
  addDefaultContainer(self.extraBgContainer)
  if DynamicLayoutIsValidGO(self.extraBgContainer) then
    self.extraBgPrefab = self:FindGO("SceneBottomHpSpCell_ExtraBg", self.extraBgContainer)
    if self.extraBgPrefab then
      self.extraBgRect = self.extraBgPrefab:GetComponent(RectTransform)
    end
  end
  self.dynamicLayoutBloodY = DynamicLayoutDefaultBloodY
  local extraRect = self.extraContainer and self.extraContainer:GetComponent(RectTransform)
  self.dynamicLayoutExtraY = extraRect and extraRect.anchoredPosition.y or 0
end

function SceneBottomHpSpCell:ResetDynamicLayoutPositions()
  if not self.dynamicLayoutDefaultRows then
    return
  end
  for i = 1, #self.dynamicLayoutDefaultRows do
    local row = self.dynamicLayoutDefaultRows[i]
    DynamicLayoutSetY(row.go, row.y)
  end
end

function SceneBottomHpSpCell:IsDynamicContainerVisible(go, canvasGroup)
  if not DynamicLayoutIsValidGO(go) then
    return false
  end
  if canvasGroup then
    return canvasGroup.alpha > 0.001
  end
  return go.activeSelf
end

function SceneBottomHpSpCell:GetLeftBossBgChainOffset(leftBossBg)
  if not DynamicLayoutIsValidGO(leftBossBg) then
    return 0
  end
  local container = self.uibloodcontainer
  local node = leftBossBg.transform.parent
  local offset = 0
  while node ~= nil and (not DynamicLayoutIsValidGO(container) or node.gameObject ~= container) do
    offset = offset + node.localPosition.y
    node = node.parent
  end
  return offset
end

function SceneBottomHpSpCell:AlignLeftBossBgToExtraBg(coreTop, coreBottom)
  local bar = self:GetActiveBloodBar()
  local leftBossBg = bar and bar.leftBossBg
  if not DynamicLayoutIsValidGO(leftBossBg) then
    return
  end
  local rect = leftBossBg.rectTransform
  if rect == nil then
    return
  end
  local y
  if coreTop ~= nil and coreBottom ~= nil then
    local container = self.uibloodcontainer
    if not DynamicLayoutIsValidGO(container) then
      return
    end
    local containerRect = container:GetComponent(RectTransform)
    local containerY = containerRect and containerRect.anchoredPosition.y or 0
    y = (coreTop + coreBottom) / 2 - containerY - self:GetLeftBossBgChainOffset(leftBossBg)
  else
    y = bar.leftBossBgBaseY
  end
  if y == nil then
    return
  end
  local pos = rect.anchoredPosition
  rect.anchoredPosition = LuaGeometry.GetTempVector2(pos.x, y)
end

function SceneBottomHpSpCell:GetDynamicExtraHeight()
  if not DynamicLayoutIsValidGO(self.extraContainer) then
    return 0, 0
  end
  if not self.extraContainer.activeSelf then
    return 0, 0
  end
  local height = 0
  local count = 0
  for i = 0, self.extraContainer.transform.childCount - 1 do
    local child = self.extraContainer.transform:GetChild(i).gameObject
    if DynamicLayoutIsValidGO(child) and child.activeSelf then
      local childHeight = DynamicLayoutGetMetricHeight("ExtraBar")
      height = height + childHeight
      count = count + 1
    end
  end
  if 1 < count then
    height = height + (count - 1) * (DynamicLayoutMetrics.ExtraBar.move - DynamicLayoutMetrics.ExtraBar.height)
  end
  return height, count
end

function SceneBottomHpSpCell:UpdateDynamicExtraChildren(extraHeight, centerY)
  if not DynamicLayoutIsValidGO(self.extraContainer) then
    return
  end
  local activeRows = {}
  for i = 0, self.extraContainer.transform.childCount - 1 do
    local child = self.extraContainer.transform:GetChild(i).gameObject
    if DynamicLayoutIsValidGO(child) and child.activeSelf then
      table.insert(activeRows, {
        go = child,
        height = DynamicLayoutGetMetricHeight("ExtraBar"),
        move = DynamicLayoutGetMetricMove("ExtraBar")
      })
    end
  end
  local cursor = (extraHeight or 0) / 2
  centerY = centerY or self.dynamicLayoutExtraY or 0
  for i = 1, #activeRows do
    local row = activeRows[i]
    local y = centerY + cursor - row.height / 2
    DynamicLayoutSetY(row.go, y)
    cursor = cursor - row.move
  end
end

function SceneBottomHpSpCell:UpdateDynamicExtraBackground(extraHeight, extraCount, coreTop, coreBottom)
  if not DynamicLayoutIsValidGO(self.extraBgContainer) then
    return
  end
  if extraCount <= 0 then
    if self.extraBgPrefab then
      self.extraBgPrefab:SetActive(false)
    end
    return
  end
  if not self.extraBgPrefab then
    self.extraBgPrefab = self:LoadPreferb("part/SceneBottomHpSpCell_ExtraBg", self.extraBgContainer)
    if self.extraBgPrefab then
      self.extraBgRect = self.extraBgPrefab:GetComponent(RectTransform)
    end
  end
  if self.extraBgPrefab then
    self.extraBgPrefab:SetActive(true)
    local coreHeight = math.max(0, (coreTop or 0) - (coreBottom or 0))
    local coreCenter = ((coreTop or 0) + (coreBottom or 0)) / 2
    DynamicLayoutSetY(self.extraBgContainer, coreCenter)
    local bg = self:FindGO("Bg", self.extraBgPrefab)
    local bgRect = bg and bg:GetComponent(RectTransform)
    if bgRect then
      local size = bgRect.sizeDelta
      bgRect.sizeDelta = LuaGeometry.GetTempVector2(size.x, coreHeight + (DynamicLayoutMetrics.ExtraBar.move - DynamicLayoutMetrics.ExtraBar.height) * 2)
    end
  end
end

function SceneBottomHpSpCell:AddDynamicLayoutRow(rows, go, height)
  if DynamicLayoutIsValidGO(go) then
    table.insert(rows, {
      go = go,
      height = height,
      move = height
    })
  end
end

function SceneBottomHpSpCell:AddDynamicLayoutMetricRow(rows, go, metric)
  if DynamicLayoutIsValidGO(go) then
    local config = DynamicLayoutMetrics[metric] or DynamicLayoutMetrics.ExtraBar
    table.insert(rows, {
      go = go,
      height = config.height,
      move = config.move
    })
  end
end

function SceneBottomHpSpCell:IsDynamicExtraChild(go)
  if not DynamicLayoutIsValidGO(go) or not DynamicLayoutIsValidGO(self.extraContainer) then
    return false
  end
  local parent = go.transform.parent
  return parent and parent.gameObject == self.extraContainer
end

function SceneBottomHpSpCell:RefreshDynamicLayout()
  if not DynamicLayoutIsValidGO(self.gameObject) then
    return
  end
  if not self.dynamicLayoutInitialized then
    self:InitDynamicLayout()
  end
  local bloodContainer = self.uibloodcontainer or self:FindGO("BloodContainer")
  local bloodHeight = DynamicLayoutGetMetricHeight("Blood")
  local bloodBaseY = self.dynamicLayoutBloodY or DynamicLayoutDefaultBloodY
  local aboveRows = {}
  local belowRows = {}
  if self:IsDynamicContainerVisible(self.uiWuDi) then
    self:AddDynamicLayoutMetricRow(aboveRows, self.resistanceContainer, "Resistance")
  end
  if self:IsDynamicContainerVisible(self.bloodDetailContainer, self.bloodDetailCanvasGroup) then
    self:AddDynamicLayoutMetricRow(aboveRows, self.bloodDetailContainer, "BloodDetail")
  end
  local extraHeight, extraCount = self:GetDynamicExtraHeight()
  local activeBar = self:GetActiveBloodBar()
  if activeBar ~= nil and activeBar.rightBossBgCanvas ~= nil and activeBar.rightBossBgDefaultActive ~= nil then
    self:SetActive(activeBar.rightBossBgCanvas, activeBar.rightBossBgDefaultActive and extraCount <= 0)
  end
  local spVisible = self:IsDynamicContainerVisible(self.spContainer, self.spCanvasGroup)
  local frenzyVisible = self.hasFrenzy or self.hasSolarEnergy
  local coreBarCount = 1 + extraCount
  if spVisible then
    coreBarCount = coreBarCount + 1
  end
  if frenzyVisible then
    coreBarCount = coreBarCount + 1
  end
  local globalOffset = math.max(0, coreBarCount - 2) * DynamicLayoutGetMetricMove("ExtraBar") / 2
  local bloodY = bloodBaseY + globalOffset
  if 0 < extraCount then
    local extraRect = self.extraContainer:GetComponent(RectTransform)
    if extraRect then
      local size = extraRect.sizeDelta
      extraRect.sizeDelta = LuaGeometry.GetTempVector2(size.x, extraHeight)
    end
    table.insert(belowRows, {
      go = self.extraContainer,
      height = extraHeight,
      move = extraHeight + (DynamicLayoutMetrics.ExtraBar.move - DynamicLayoutMetrics.ExtraBar.height)
    })
  end
  if spVisible then
    self:AddDynamicLayoutMetricRow(belowRows, self.spContainer, "Sp")
  end
  if frenzyVisible then
    self:AddDynamicLayoutMetricRow(belowRows, self.frenzyContainer, "Frenzy")
  end
  if self.hasEnergy then
    self:AddDynamicLayoutMetricRow(belowRows, self.energyContainer, "Energy")
  end
  if self.sceneTimeDisk then
    self:AddDynamicLayoutMetricRow(belowRows, self.timeDiskContainer, "TimeDisk")
  end
  if self.sceneStarMap then
    self:AddDynamicLayoutMetricRow(belowRows, self.starMapContainer, "StarMap")
  end
  if self.hasFeather then
    self:AddDynamicLayoutMetricRow(belowRows, self.featherContainer, "Feather")
  end
  local kickRows = self.kickCountRowCount or 0
  local cursor = bloodY - bloodHeight / 2
  local extraCenterY = self.dynamicLayoutExtraY or 0
  for i = 1, #belowRows do
    local row = belowRows[i]
    local y = cursor - row.move + row.height / 2
    if row.go == self.extraContainer then
      extraCenterY = y
    else
      DynamicLayoutSetY(row.go, y)
    end
    cursor = cursor - row.move
  end
  self.dynamicLayoutBottomCursor = cursor
  if 0 < kickRows then
    self:UpdateDynamicKickCountChildren(kickRows)
  end
  if 0 < extraCount then
    self:UpdateDynamicExtraChildren(extraHeight, extraCenterY)
    local extraY = extraCenterY
    local coreTop = bloodY + bloodHeight / 2
    local coreBottom = extraY - extraHeight / 2
    self:UpdateDynamicExtraBackground(extraHeight, extraCount, coreTop, coreBottom)
    self:AlignLeftBossBgToExtraBg(coreTop, coreBottom)
  else
    self:UpdateDynamicExtraBackground(0, 0)
    self:AlignLeftBossBgToExtraBg()
  end
  cursor = bloodY + bloodHeight / 2
  for i = #aboveRows, 1, -1 do
    local row = aboveRows[i]
    local y = cursor + row.move - row.height / 2
    DynamicLayoutSetY(row.go, y)
    cursor = cursor + row.move
  end
  self.dynamicLayoutTopCursor = cursor
  DynamicLayoutSetY(bloodContainer, bloodY)
  self.dynamicLayoutRows = #aboveRows + #belowRows + 1
  return {
    top = self.dynamicLayoutTopCursor,
    bottom = self.dynamicLayoutBottomCursor,
    height = self.dynamicLayoutTopCursor - self.dynamicLayoutBottomCursor,
    coreBarCount = coreBarCount,
    globalOffset = globalOffset,
    hasDynamicRows = 0 < #aboveRows + #belowRows,
    hasBottomRows = 0 < #belowRows
  }
end

function SceneBottomHpSpCell:GetDynamicNamePosition(nameHeight)
  local bottom = self.dynamicLayoutBottomCursor or 0
  return bottom - DynamicLayoutNameGap
end

function SceneBottomHpSpCell:ApplyDynamicNamePosition(nameY, nameHeight)
  local anchorY = nameY or self.dynamicLayoutBottomCursor or 0
  local anchorHeight = nameHeight or DynamicLayoutTextHeight
  local cursor = anchorY - anchorHeight / 2
  local kickRows = self.kickCountRowCount or 0
  if 0 < kickRows and DynamicLayoutIsValidGO(self.kickCountContainer) then
    self:UpdateDynamicKickCountChildren(kickRows)
    local kickHeight = self.kickCountRowHeight or DynamicLayoutGetMetricHeight("KickCount")
    local kickMove = DynamicLayoutGetMetricMove("KickCount")
    if kickHeight > kickMove then
      kickMove = kickHeight
    end
    local kickY = cursor - kickMove + kickHeight / 2
    DynamicLayoutSetY(self.kickCountContainer, kickY)
    cursor = cursor - kickMove * kickRows
  end
  local sanityHeight = DynamicLayoutGetMetricHeight("Sanity")
  if self:IsDynamicContainerVisible(self.sanityContainer, self.sanityCanvasGroup) then
    local sanityY = cursor - DynamicLayoutGetMetricMove("Sanity") + sanityHeight / 2
    DynamicLayoutSetY(self.sanityContainer, sanityY)
  end
end

function SceneBottomHpSpCell:setHpSpVisible(visible, isSelect)
  local objNull = self:ObjIsNil(self.gameObject)
  if objNull then
    return
  end
  if self.deadSlideAnim then
    return
  end
  self:SetActive(self.canvasGroup, visible, true)
  if isSelect and self.creature == Game.Myself:GetLockTarget() then
    self.scaleTween:ResetToBeginning()
    self.scaleTween:PlayForward()
  end
end

function SceneBottomHpSpCell:SetHpLabel(hp)
  if self.bloodVolume then
    hp = hp == 0 and "" or hp
    self.bloodVolume.text = hp
  end
end

function SceneBottomHpSpCell:SetHp(hp, maxhp)
  if self:ObjIsNil(self.uibloodcontainer) then
    return
  end
  if maxhp == 0 then
    LogUtility.Warning("Trying to set maxhp = 0!!")
    return
  end
  local bar = self:GetActiveBloodBar()
  if bar == nil then
    return
  end
  bar:SetHpValue(hp, maxhp)
  local isLowBlood
  if hp / maxhp <= 0.2 and hp ~= 0 then
    isLowBlood = true
  else
    isLowBlood = false
  end
  if self.ismyself and isLowBlood then
    if not LowBloodBlinkView.Instance then
      LowBloodBlinkView.ShowLowBloodBlink()
    end
  elseif self.ismyself and not isLowBlood and LowBloodBlinkView.Instance then
    LowBloodBlinkView.closeBloodBlink()
  end
  self:SetHpLabel(hp)
  bar:UpdateHpGrid(maxhp)
  bar:UpdateExecutePart()
  bar:UpdateShieldPos()
  if self.creature then
    local userdata = self.creature.data.userdata
    local shieldHp = userdata:Get(UDEnum.SHIELD_HP)
    local shieldMaxHp = userdata:Get(UDEnum.SHIELD_MAXHP)
    if shieldMaxHp and 0 < shieldMaxHp then
      bar:SetShieldHp(shieldHp, shieldMaxHp)
    end
    local MaxHp = self.creature.data.props:GetPropByName("MaxHp"):GetValue()
    local blackMuck = userdata:Get(UDEnum.BLACK_MUCK)
    if blackMuck and 0 < blackMuck then
      bar:UpdateBlackMuck(blackMuck, MaxHp)
    end
  end
end

function SceneBottomHpSpCell:SetSp(sp, maxSp, spTrans)
  if self.ismyself then
    if self:ObjIsNil(self.spContainer) then
      return
    end
    maxSp = maxSp == 0 and 99999999999 or maxSp
    local curbuff = 1
    if spTrans then
      sp = maxSp
    end
    local curSp = self.spSlider.value * maxSp
    if self.spContainer.activeSelf and not self.isFirstSpInit then
      LeanTween.cancel(self.spSlider.gameObject)
      LeanTween.sliderUGUI(self.spSlider, curSp / maxSp, sp / maxSp, math.abs((sp - curSp) / maxSp) * 0.5)
    else
      self.spSlider.value = sp / maxSp
      self.isFirstSpInit = false
    end
  end
end

function SceneBottomHpSpCell:ClearResistanceTick()
  if self.resistanceTick then
    TimeTickManager.Me():ClearTick(self, 1225)
    self.resistanceTick = nil
  end
end

local MaxResistanceVal = GameConfig.MonsterControl.ResistanceBar and GameConfig.MonsterControl.ResistanceBar.MaxValue or 120

function SceneBottomHpSpCell:SetResistance(ncreature)
  if not self.resistanceBar then
    return
  end
  local value, speed = ncreature.data:GetResistanceValue()
  if not value or not speed then
    self:ClearResistanceTick()
    return
  end
  if speed < 0 or value >= MaxResistanceVal then
    self:ActiveWD(true, "slider")
  else
    self:ActiveWD(false, "slider")
  end
  if self.uiSliderResistance then
    self.uiSliderResistance.value = math.clamp(value / MaxResistanceVal, 0, 1)
    if speed < 0 or value >= MaxResistanceVal then
      SpriteManager.SetUISprite("sceneuicom", "mowu_line_bg3", self.uiSliderFg)
      self.uiSliderFgBlink:SetActive(true)
    else
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_3s", self.uiSliderFg)
      self.uiSliderFgBlink:SetActive(false)
    end
    self.uiResistanceHandle:SetActive(value < MaxResistanceVal)
  end
  if speed ~= 0 then
    if value >= MaxResistanceVal and 0 < speed or value <= 0 and speed < 0 then
      self:ClearResistanceTick()
    else
      self.resistanceTick = TimeTickManager.Me():CreateTick(0, 33, function(owner, deltaTime)
        value, speed = ncreature.data:GetResistanceValue()
        if self.uiSliderResistance then
          self.uiSliderResistance.value = math.clamp(value / MaxResistanceVal, 0, 1)
        end
        if value >= MaxResistanceVal and 0 < speed or value <= 0 and speed < 0 then
          self:ClearResistanceTick()
          if value >= MaxResistanceVal then
            if self.uiSliderResistance then
              SpriteManager.SetUISprite("sceneuicom", "mowu_line_bg3", self.uiSliderFg)
              self.uiResistanceHandle:SetActive(false)
              self.uiSliderFgBlink:SetActive(true)
            end
            self:ActiveWD(true, "slider")
          end
        end
      end, self, 1225)
    end
  else
    self:ClearResistanceTick()
  end
end

function SceneBottomHpSpCell:ResetResistance()
  self:ClearResistanceTick()
  self.resistanceBar = nil
  if self.resistanceGO then
    LuaGameObject.DestroyObject(self.resistanceGO)
    self.resistanceGO = nil
    self.uiSliderResistance = nil
    self.uiSliderFg = nil
    self.uiSliderFgBlink = nil
    self.uiResistanceHandle = nil
  end
end

function SceneBottomHpSpCell:ActiveWD(b, reason)
  if not self.uiWuDi then
    return
  end
  if not self.wdReasons then
    self.wdReasons = {}
  end
  self.wdReasons[reason] = b
  for k, v in pairs(self.wdReasons) do
    if v then
      self.uiWuDi:SetActive(true)
      if self.dynamicLayoutInitialized then
        self:RefreshDynamicLayout()
      end
      return
    end
  end
  self.uiWuDi:SetActive(false)
  if self.dynamicLayoutInitialized then
    self:RefreshDynamicLayout()
  end
end

function SceneBottomHpSpCell:UpdateBuffHpGrid(hpGridCount)
  self.buffHpGridCount = hpGridCount
  self:RefreshBossBloodBar()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:UpdateBuffHpGrid(hpGridCount)
  end
  if self.dynamicLayoutInitialized then
    self:RefreshDynamicLayout()
  end
end

function SceneBottomHpSpCell:SetBuffHpBg(on)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetBuffHpBg(on)
  end
end

function SceneBottomHpSpCell:setHpValueAndColor(value, finalHp)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetHpValueAndColor(value, finalHp)
  end
end

function SceneBottomHpSpCell:SetTweenHpValueAndColor(value)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetTweenHpValueAndColor(value)
  end
end

function SceneBottomHpSpCell:SetHpBg(bgName)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetHpBg(bgName)
  end
end

function SceneBottomHpSpCell:SetShieldHp(hp, maxhp)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetShieldHp(hp, maxhp)
  end
end

function SceneBottomHpSpCell:ResetShieldHp()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:ResetShieldHp()
  end
end

function SceneBottomHpSpCell:isMvpOrMini()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP or detailedType == NpcData.NpcDetailedType.WorldBoss then
    return true
  end
  return false
end

function SceneBottomHpSpCell:isMvp()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.MVP then
    return true
  end
  return false
end

function SceneBottomHpSpCell:isRareElite()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.RareElite then
    return true
  end
  return false
end

function SceneBottomHpSpCell:isPlayer()
  if self.creatureType == Creature_Type.Player then
    return true
  end
  return false
end

function SceneBottomHpSpCell:isCopyNpc()
  if self.detailedType == NpcData.NpcDetailedType.CopyNpc then
    return true
  end
  return false
end

function SceneBottomHpSpCell:isFollowMaster()
  if self.detailedType == NpcData.NpcDetailedType.FollowMaster then
    return true
  end
  return false
end

function SceneBottomHpSpCell:IsTwelveBuildNPC()
  return self.detailedType == NpcData.NpcDetailedType.TwelveBase or self.detailedType == NpcData.NpcDetailedType.TwelveBarrack or self.detailedType == NpcData.NpcDetailedType.DefenseTower
end

function SceneBottomHpSpCell:initDecorate()
  local resistActive = false
  if self.resistanceBar then
    self.uiWuDi = self:FindGO("WD")
    if self.uiWuDi then
      local uiWuDiText = self:FindComponent("Text", ROText, self.uiWuDi)
      if uiWuDiText then
        uiWuDiText.text = ZhString.SceneBottomHpSpCell_WuDi
      end
    end
    if self.resistanceBar == 2 then
      resistActive = true
      self.resistanceGO = self:LoadPreferb("part/ExtraBar", self:FindGO("ExtraContainer"))
      if self.resistanceGO then
        self.resistanceGO.name = "ExtraBar_Resistance"
      end
      self.uiSliderResistance = self:FindComponent("ExtraSlider", Slider, self.resistanceGO)
      self.uiSliderFg = self:FindComponent("Sp", Image, self.resistanceGO)
      self.uiSliderFgBlink = self:FindGO("SpBlink", self.resistanceGO)
      self.uiResistanceHandle = self:FindGO("Handle", self.resistanceGO)
    end
    self:SetResistance(self.creature)
  end
  if self.chargeConfig then
    self:InitChargeBar()
  end
  if self.showBalance then
    self:InitBalanceBar()
    self:SetBalance(self.creature)
  end
  self:RefreshBloodBarDecor(resistActive)
  if self.bossBloodBar then
    self:RefreshBloodBarDecor(nil, self.bossBloodBar)
  end
end

function SceneBottomHpSpCell:InitHpGrid()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:InitHpGrid()
  end
end

function SceneBottomHpSpCell:InitSpGrid()
  self.spGrid = self:FindGO("spGrid")
  if not self.spGrid then
    return
  end
  self:SetSpGridMode(SceneBottomHpSpCell.HpSpGridMode.None)
  local mapManager, funcName = Game.MapManager
  for raid, mode in pairs(SceneBottomHpSpCell.RaidGridModeMap) do
    funcName = "Is" .. raid
    if mapManager[funcName] and mapManager[funcName](mapManager) then
      self:SetSpGridMode(mode)
      break
    end
  end
  self.spGridElements = {}
  local i, element = 0
  while true do
    i = i + 1
    element = self:FindComponent(tostring(i), RectTransform, self.spGrid)
    if element then
      self.spGridElements[i] = element
    else
      break
    end
  end
end

function SceneBottomHpSpCell:SetHpGridMode(mode)
  local bar = self:GetActiveBloodBar()
  if bar and bar.hpGrid then
    bar.hpGrid:SetActive(mode ~= SceneBottomHpSpCell.HpSpGridMode.None)
  end
  self.hpGridMode = mode
end

function SceneBottomHpSpCell:SetSpGridMode(mode)
  self.spGrid:SetActive(mode ~= SceneBottomHpSpCell.HpSpGridMode.None)
  self.spGridMode = mode
end

local fmod = math.fmod
local getPartCount = function(mode, max, elements)
  local partCount, result = #elements + 1
  if mode == SceneBottomHpSpCell.HpSpGridMode.Flexible then
    for i = partCount, 1, -1 do
      result = fmod(max, i)
      if result == 0 then
        partCount = i
        break
      end
    end
  end
  return partCount
end
local updateGrid = function(mode, max, elements)
  local partCount, result, element = getPartCount(mode, max, elements)
  for i = 1, partCount - 1 do
    element = elements[i]
    element.gameObject:SetActive(true)
    result = sliderLength / partCount * i - sliderLength / 2
    element.anchoredPosition = LuaGeometry.GetTempVector3(result)
  end
end

function SceneBottomHpSpCell:UpdateHpGrid(maxCount)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:UpdateHpGrid(maxCount)
  end
end

function SceneBottomHpSpCell:UpdateSpGrid(max)
  if not self.spGridElements or self.spGridMode == SceneBottomHpSpCell.HpSpGridMode.None then
    return
  end
  if self.exMaxSp == max then
    return
  end
  self.exMaxSp = max
  updateGrid(self.spGridMode, max, self.spGridElements)
end

function SceneBottomHpSpCell:InitCamp()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:InitCamp()
  end
end

function SceneBottomHpSpCell:setCamp(camp)
  self.camp = camp
  self:initCreateBg()
  self:UpdateExecutePart()
end

function SceneBottomHpSpCell:initCreateBg()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:RefreshCampBg()
  end
end

function SceneBottomHpSpCell:Alive()
  return self._alive
end

function SceneBottomHpSpCell:InitSanity()
  self.sanityContainer = self:FindGO("SanityContainer")
  if not self.sanityContainer or self:ObjIsNil(self.sanityContainer) then
    return
  end
  if not self.sanityCanvasGroup then
    self.sanityCanvasGroup = self.sanityContainer:GetComponent(CanvasGroup)
  end
  self.sanityPrefab = self:LoadPreferb("part/SanityBarPart", self.sanityContainer)
  self.mySanity = self:FindGO("MySanity", self.sanityPrefab):GetComponent(Slider)
  self.sanityPercent = self:FindGO("sanityPercent", self.sanityPrefab):GetComponent(Text)
  self.forebg = self:FindGO("Sanity", self.mySanity.gameObject):GetComponent(Image)
  self.isFirstInitSanity = true
end

function SceneBottomHpSpCell:UpdateSanity(value)
  if not self.isFirstInitSanity and self:ObjIsNil(self.mySanity) then
    self:InitSanity()
    local guildData = Game.Myself.data:GetGuildData()
    self:UpdateSanityPostion(guildData ~= nil)
  end
  if self:ObjIsNil(self.mySanity) then
    return
  end
  if not value or value == 0 then
    self:SetActive(self.sanityCanvasGroup, false)
    self:RefreshDynamicLayout()
    return
  else
    self:SetActive(self.sanityCanvasGroup, true)
  end
  value = value < 1 and value or 1
  if 0.4 < value then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_2s", self.forebg)
  else
    SpriteManager.SetUISprite("sceneuicom", "com_bg_kl", self.forebg)
  end
  self.mySanity.value = value
  self.sanityPercent.text = string.format("%d%%", value * 100)
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:UpdateSanityPostion(needReposition)
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:ClearSanity()
  if self.mySanity and not self:ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
    self.mySanity = nil
  end
  self:SetActive(self.sanityCanvasGroup, false)
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:isPushMinion()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.PushMinion and self.staticID and not TwelvePvpConfig[self.staticID] then
    return true
  end
  return false
end

function SceneBottomHpSpCell:UpdateHpColor(camp)
  self.camp = camp
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:RefreshHpBgByValue()
  end
end

function SceneBottomHpSpCell:InitBullets()
  self.bulletsContainer = self:FindGO("BulletsContainer")
  if not self.bulletsContainer or self:ObjIsNil(self.bulletsContainer) then
    return
  end
  self.bulletsPrefab = self:LoadPreferb("part/BulletsPart", self.bulletsContainer)
  self.bulletsNum = self:FindGO("num", self.bulletsPrefab):GetComponent(Text)
  self.bulletsNum.text = MyselfProxy.Instance:GetCurBullets()
  local bulletbg = self:FindGO("bg", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_bg_bullet", bulletbg)
  local bulleticon = self:FindGO("bullet", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_icon_bullet", bulleticon)
  local bulleticon2 = self:FindGO("img", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_icon_bullet2", bulleticon2)
  self.bulletsContainer.transform.localPosition = LuaGeometry.GetTempVector3(-75, -10, 0)
  self.bulletsContainer:SetActive(true)
end

function SceneBottomHpSpCell:UpdateBulletsNum(num)
  if not self.bulletsContainer then
    self:InitBullets()
  end
  self.bulletsNum.text = num
  self:ShowBullets(true)
end

function SceneBottomHpSpCell:ShowBullets(value)
  redlog("ShowBullets", value)
  if self.bulletsContainer and value ~= nil then
    self.bulletsContainer:SetActive(value)
  elseif value then
    self:InitBullets()
  else
    redlog("not self.bulletsContainer")
  end
end

function SceneBottomHpSpCell:InitFrenzy()
  if self.frenzyLayer and not self:ObjIsNil(self.frenzyLayer) then
    return
  end
  if not self.frenzyContainer or self:ObjIsNil(self.frenzyContainer) then
    self.frenzyContainer = self:FindGO("FrenzyContainer")
  end
  if not self.frenzyContainer or self:ObjIsNil(self.frenzyContainer) then
    return
  end
  if not self.frenzyCanvasGroup then
    self.frenzyCanvasGroup = self.frenzyContainer:GetComponent(CanvasGroup)
  end
  local prefab = self:LoadPreferb("part/FrenzyBar", self.frenzyContainer)
  if prefab then
    self.frenzyBarGO = prefab
    self:_ClearLoadedFrenzyParts(prefab)
    local sliderGO = self:FindGO("FrenzySlider", prefab)
    if sliderGO then
      self.myFrenzySlider = sliderGO:GetComponent(Slider)
    end
    local layerGO = self:FindGO("FrenzyLayer", prefab)
    if layerGO then
      self.frenzyLayer = layerGO:GetComponent(Text)
      self.frenzyLayer.text = 0
    end
    if self.myFrenzySlider then
      self.myFrenzySlider.value = 0
    end
  end
end

function SceneBottomHpSpCell:UpdateFrenzyLayer(layer, maxLayer)
  if not self.frenzyLayer or self:ObjIsNil(self.frenzyLayer) then
    self:InitFrenzy()
  end
  if not (self.frenzyLayer and not self:ObjIsNil(self.frenzyLayer) and self.myFrenzySlider) or self:ObjIsNil(self.myFrenzySlider) then
    return
  end
  self.frenzyLayer.text = layer or 0
  self.myFrenzySlider.value = (layer or 0) / (maxLayer ~= 0 and maxLayer or 1)
  self:ShowFrenzy(true)
end

function SceneBottomHpSpCell:UpdateFrenzyContainerVisible()
  if self.frenzyContainer and not self:ObjIsNil(self.frenzyContainer) then
    self.frenzyContainer:SetActive(self.hasFrenzy or self.hasSolarEnergy)
  end
end

function SceneBottomHpSpCell:ShowFrenzy(value)
  if value and (not self.frenzyLayer or self:ObjIsNil(self.frenzyLayer)) then
    self:InitFrenzy()
  end
  self.hasFrenzy = value == true
  self:UpdateFrenzyContainerVisible()
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:RemoveFrenzy()
  if self.frenzyBarGO and not LuaGameObject.ObjectIsNull(self.frenzyBarGO) then
    LuaGameObject.DestroyObject(self.frenzyBarGO)
  end
  self.frenzyBarGO = nil
  self.myFrenzySlider = nil
  self.frenzyLayer = nil
  self.hasFrenzy = false
end

function SceneBottomHpSpCell:_ClearLoadedFrenzyParts(keepGO)
  local container = self.frenzyContainer
  if not container or self:ObjIsNil(container) then
    return
  end
  local t = container.transform
  for i = t.childCount - 1, 0, -1 do
    local child = t:GetChild(i).gameObject
    if child ~= keepGO then
      local n = child.name or ""
      if string.find(n, "SolarEnergyBar", 1, true) then
        if self.sceneSolarEnergy and self.sceneSolarEnergy.gameObject == child then
          self.sceneSolarEnergy:Destroy()
          self.sceneSolarEnergy = nil
        else
          LuaGameObject.DestroyObject(child)
        end
      elseif string.find(n, "FrenzyBar", 1, true) then
        if self.frenzyBarGO == child then
          self:RemoveFrenzy()
        else
          LuaGameObject.DestroyObject(child)
        end
      end
    end
  end
end

function SceneBottomHpSpCell:InitTimeDiskInfo()
  if not self.sceneTimeDisk then
    self.timeDiskContainer = self:FindGO("TimeDiskContainer")
    if not self.timeDiskContainer or self:ObjIsNil(self.timeDiskContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.timeDiskContainer
    args[2] = info and info.isSun
    args[3] = self
    self.sceneTimeDisk = SceneTimeDiskInfo.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    self:RefreshDynamicLayout()
  end
end

function SceneBottomHpSpCell:UpdateRotation(isSun, now, curGrid)
  if not self.sceneTimeDisk then
    self:InitTimeDiskInfo()
  end
  self.sceneTimeDisk:UpdateRotation(isSun, now, curGrid)
end

function SceneBottomHpSpCell:RemoveTimeDisk()
  if self.sceneTimeDisk then
    self.sceneTimeDisk:Destroy()
    self.sceneTimeDisk = nil
  end
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:InitStarMap()
  if not self.sceneStarMap then
    self.starMapContainer = self:FindGO("StarMapContainer")
    if not self.starMapContainer or self:ObjIsNil(self.starMapContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.starMapContainer
    self.sceneStarMap = SceneStarMap.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    self:RefreshDynamicLayout()
  end
end

function SceneBottomHpSpCell:UpdateStar(bufflayer)
  if not self.sceneStarMap then
    self:InitStarMap()
  end
  self.sceneStarMap:UpdateStar(bufflayer)
end

function SceneBottomHpSpCell:RemoveStarMap()
  if self.sceneStarMap then
    self.sceneStarMap:Destroy()
    self.sceneStarMap = nil
  end
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:InitExecutePart()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:InitExecutePart()
  end
end

function SceneBottomHpSpCell:UpdateExecutePart()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:UpdateExecutePart()
  end
end

function SceneBottomHpSpCell:InitFeatherGrid()
  if not self.sceneFeatherGrid then
    self.featherContainer = self:FindGO("FeatherContainer")
    if not self.featherContainer or self:ObjIsNil(self.featherContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.featherContainer
    self.sceneFeatherGrid = SceneFeatherGrid.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function SceneBottomHpSpCell:UpdateFeatherBuff(bufflayer)
  if not self.sceneFeatherGrid then
    self:InitFeatherGrid()
  end
  self.sceneFeatherGrid:UpdateFeather(bufflayer)
end

function SceneBottomHpSpCell:RemoveFeatherGrid()
  if self.sceneFeatherGrid then
    self.sceneFeatherGrid:Destroy()
    self.sceneFeatherGrid = nil
  end
  self.hasFeather = false
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:ShowFeather(value)
  self.hasFeather = value == true
  if self.featherContainer then
    if value and not self.featherContainer.activeSelf then
      self.featherContainer:SetActive(true)
    elseif false == value and self.featherContainer.activeSelf then
      self.featherContainer:SetActive(false)
    end
  else
    self:InitFeatherGrid()
  end
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:InitBalanceBar()
  if not self.sceneBalanceBar then
    self.balanceContainer = self:FindGO("ExtraContainer")
    if not self.balanceContainer or self:ObjIsNil(self.balanceContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.balanceContainer
    self.sceneBalanceBar = SceneBalanceBar.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function SceneBottomHpSpCell:SetBalance(value)
  if not self.sceneBalanceBar then
    self:InitBalanceBar()
  end
  if not self.sceneBalanceBar then
    return
  end
  self.sceneBalanceBar:SetBalance(value)
end

function SceneBottomHpSpCell:RemoveBalance()
  if self.sceneBalanceBar then
    self.sceneBalanceBar:Destroy()
    self.sceneBalanceBar = nil
  end
end

function SceneBottomHpSpCell:SetResistanceVisible(visible)
  if DynamicLayoutIsValidGO(self.resistanceGO) then
    self.resistanceGO:SetActive(visible ~= false)
  end
end

function SceneBottomHpSpCell:IsResistanceVisible()
  return DynamicLayoutIsValidGO(self.resistanceGO) and self.resistanceGO.activeSelf
end

function SceneBottomHpSpCell:SetBalanceVisible(visible)
  local bar = self.sceneBalanceBar
  if bar == nil then
    if visible == false then
      return
    end
    self:InitBalanceBar()
    bar = self.sceneBalanceBar
  end
  if bar then
    bar:SetVisible(visible)
  end
end

function SceneBottomHpSpCell:IsBalanceVisible()
  local bar = self.sceneBalanceBar
  return bar ~= nil and bar:IsVisible()
end

function SceneBottomHpSpCell:IsChargeVisible()
  local bar = self.sceneChargeBar
  return bar ~= nil and bar:IsVisible()
end

function SceneBottomHpSpCell:RemoveExtraBars()
  self:RemoveCharge()
  self:RemoveBalance()
  self:ResetResistance()
end

function SceneBottomHpSpCell:CreateChargeConfig(creature)
  local data = creature and creature.data
  return data and data:GetChargeBarConfig() or nil
end

function SceneBottomHpSpCell:GetChargeConfig()
  return self.chargeConfig
end

function SceneBottomHpSpCell:InitChargeBar()
  if not self.chargeConfig then
    return
  end
  if not self.sceneChargeBar then
    self.chargeContainer = self.extraContainer or self:FindGO("ExtraContainer")
    if not self.chargeContainer or self:ObjIsNil(self.chargeContainer) then
      return
    end
    local args = ReusableTable.CreateArray()
    args[1] = self.chargeContainer
    args[2] = self.chargeConfig
    self.sceneChargeBar = SceneChargeBar.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    local data = self.creature and self.creature.data
    if data then
      self.sceneChargeBar:SetVisible(data:IsChargeBarVisible())
      local value, delta = data:GetChargeBar()
      if value ~= nil then
        self.sceneChargeBar:SetChargeSpeed(value, nil, delta)
      end
    end
    self:RefreshBossBloodBar()
  end
end

function SceneBottomHpSpCell:SetCharge(value, maxValue)
  if not self.sceneChargeBar then
    self:InitChargeBar()
  end
  if self.sceneChargeBar then
    self.sceneChargeBar:SetCharge(value, maxValue)
  end
end

function SceneBottomHpSpCell:SetChargeSpeed(value, maxValue, speed)
  if not self.sceneChargeBar then
    self:InitChargeBar()
  end
  if self.sceneChargeBar then
    self.sceneChargeBar:SetChargeSpeed(value, maxValue, speed)
  end
end

function SceneBottomHpSpCell:SetChargeVisible(visible)
  if not self.sceneChargeBar then
    self:InitChargeBar()
  end
  if self.sceneChargeBar then
    self.sceneChargeBar:SetVisible(visible)
    self:RefreshBossBloodBar()
    self:RefreshDynamicLayout()
  end
end

function SceneBottomHpSpCell:SetChargeState(value, state)
  if not self:GetChargeConfig() then
    return
  end
  if not self.sceneChargeBar then
    self:InitChargeBar()
  end
  if self.sceneChargeBar then
    self.sceneChargeBar:SetChargeState(value, nil, state)
  end
end

function SceneBottomHpSpCell:StopCharge()
  if self.sceneChargeBar then
    self.sceneChargeBar:StopCharge()
  end
end

function SceneBottomHpSpCell:SetChargeBlinkActive(active)
  if self.sceneChargeBar then
    self.sceneChargeBar:SetBlinkActive(active)
  end
end

function SceneBottomHpSpCell:RemoveCharge()
  if self.sceneChargeBar then
    self.sceneChargeBar:Destroy()
    self.sceneChargeBar = nil
  end
end

function SceneBottomHpSpCell:_EnsureKickCountBar(kind)
  if self.kickCountBars == nil then
    self.kickCountBars = {}
  end
  local bar = self.kickCountBars[kind]
  if bar ~= nil then
    return bar
  end
  if not DynamicLayoutIsValidGO(self.kickCountContainer) then
    return nil
  end
  local go = self:LoadPreferb("part/KickCountBar", self.kickCountContainer)
  if go == nil then
    return nil
  end
  bar = SceneKickCountBar:Create(go)
  bar:SetType(kind)
  self.kickCountBars[kind] = bar
  return bar
end

function SceneBottomHpSpCell:_RemoveKickCountBar(kind)
  if self.kickCountBars == nil then
    return
  end
  local bar = self.kickCountBars[kind]
  if bar == nil then
    return
  end
  self.kickCountBars[kind] = nil
  local go = bar.gameObject
  bar:Destroy()
  if go ~= nil and not LuaGameObject.ObjectIsNull(go) then
    LuaGameObject.DestroyObject(go)
  end
end

local KICK_COUNT_BAR_VISIBLE = false

function SceneBottomHpSpCell:SetKickCount(wallCount, wallMax, hitCount, hitMax)
  if not KICK_COUNT_BAR_VISIBLE then
    self:RemoveKickCount()
    return
  end
  local _ShouldShow = function(cur, maxCount)
    return (tonumber(maxCount) or 0) > 1 and 0 < (tonumber(cur) or 0)
  end
  local showWall = _ShouldShow(wallCount, wallMax)
  local showEntity = _ShouldShow(hitCount, hitMax)
  if showWall then
    local bar = self:_EnsureKickCountBar(SceneKickCountBar.Kind.Wall)
    if bar then
      bar:SetCount(wallCount, wallMax)
    end
  else
    self:_RemoveKickCountBar(SceneKickCountBar.Kind.Wall)
  end
  if showEntity then
    local bar = self:_EnsureKickCountBar(SceneKickCountBar.Kind.Entity)
    if bar then
      bar:SetCount(hitCount, hitMax)
    end
  else
    self:_RemoveKickCountBar(SceneKickCountBar.Kind.Entity)
  end
  self:_ReorderKickCountBars()
  self.kickCountRowCount = (showWall and 1 or 0) + (showEntity and 1 or 0)
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:RemoveKickCount()
  self:_RemoveKickCountBar(SceneKickCountBar.Kind.Wall)
  self:_RemoveKickCountBar(SceneKickCountBar.Kind.Entity)
  self.kickCountRowCount = 0
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:_ReorderKickCountBars()
  if self.kickCountBars == nil then
    return
  end
  local _SetIndex = function(bar, index)
    if bar ~= nil and DynamicLayoutIsValidGO(bar.gameObject) then
      bar.gameObject.transform:SetSiblingIndex(index)
    end
  end
  _SetIndex(self.kickCountBars[SceneKickCountBar.Kind.Wall], 0)
  _SetIndex(self.kickCountBars[SceneKickCountBar.Kind.Entity], 1)
end

function SceneBottomHpSpCell:UpdateDynamicKickCountChildren(rowCount)
  if not DynamicLayoutIsValidGO(self.kickCountContainer) or (rowCount or 0) <= 0 then
    return
  end
  local move = DynamicLayoutGetMetricMove("KickCount")
  local measure = 0
  for i = 0, self.kickCountContainer.transform.childCount - 1 do
    local child = self.kickCountContainer.transform:GetChild(i).gameObject
    if DynamicLayoutIsValidGO(child) then
      local r = child:GetComponent(RectTransform)
      local h = r and r.rect.height or 0
      if measure < h then
        measure = h
      end
    end
  end
  if move < measure then
    move = measure
  end
  self.kickCountRowHeight = move
  local contRect = self.kickCountContainer:GetComponent(RectTransform)
  local y = 0
  for i = 0, self.kickCountContainer.transform.childCount - 1 do
    local child = self.kickCountContainer.transform:GetChild(i).gameObject
    if DynamicLayoutIsValidGO(child) then
      DynamicLayoutSetY(child, y)
      y = y - move
    end
  end
end

function SceneBottomHpSpCell:InitEnergyGrid()
  if not self.sceneEnergyGrid then
    self.energyContainer = self:FindGO("EnergyContainer")
    if not self.energyContainer or self:ObjIsNil(self.energyContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.energyContainer
    self.sceneEnergyGrid = SceneEnergyGrid.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end

function SceneBottomHpSpCell:UpdateEnergyBuff(bufflayer)
  if not self.sceneEnergyGrid then
    self:InitEnergyGrid()
  end
  self.sceneEnergyGrid:UpdateEnergy(bufflayer)
end

function SceneBottomHpSpCell:RemoveEnergyGrid()
  if self.sceneEnergyGrid then
    self.sceneEnergyGrid:Destroy()
    self.sceneEnergyGrid = nil
  end
  self.hasEnergy = false
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:ShowEnergy(value)
  self.hasEnergy = value == true
  if self.energyContainer then
    if value and not self.energyContainer.activeSelf then
      self.energyContainer:SetActive(true)
    elseif false == value and self.energyContainer.activeSelf then
      self.energyContainer:SetActive(false)
    end
  else
    self:InitEnergyGrid()
  end
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:SetNormalShield(shield, maxhp)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetNormalShield(shield, maxhp)
  end
end

function SceneBottomHpSpCell:UpdateShieldPos()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:UpdateShieldPos()
  end
end

function SceneBottomHpSpCell:ResetNormalShield()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:ResetNormalShield()
  end
end

function SceneBottomHpSpCell:InitShield()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:InitShield()
  end
end

function SceneBottomHpSpCell:RemoveShield()
  if self.bloodBar then
    self.bloodBar:RemoveShield()
  end
end

function SceneBottomHpSpCell:SetPvpCamp()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:SetPvpCamp()
  end
end

function SceneBottomHpSpCell:ResetRidePos(reset)
  if reset then
    self.transform.localPosition = LuaGeometry.GetTempVector3(-80, 100, 0)
  else
    self.transform.localPosition = LuaGeometry.Const_V3_zero
  end
end

function SceneBottomHpSpCell:InitSolarEnergy()
  if not self.sceneSolarEnergy then
    self.frenzyContainer = self:FindGO("FrenzyContainer")
    if not self.frenzyContainer or self:ObjIsNil(self.frenzyContainer) then
      return
    end
    local args = ReusableTable.CreateArray()
    args[1] = self.frenzyContainer
    self.sceneSolarEnergy = SceneSolarEnergy.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
    self:_ClearLoadedFrenzyParts(self.sceneSolarEnergy and self.sceneSolarEnergy.gameObject)
  end
end

function SceneBottomHpSpCell:UpdateSolarEnergy(bufflayer, maxLayer)
  if not self.sceneSolarEnergy then
    self:InitSolarEnergy()
  end
  if not self.sceneSolarEnergy then
    return
  end
  self.sceneSolarEnergy:UpdateSolarEnergy(bufflayer, maxLayer)
  self.hasSolarEnergy = true
  self:UpdateFrenzyContainerVisible()
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:RemoveSolarEnergy()
  if self.sceneSolarEnergy then
    self.sceneSolarEnergy:Destroy()
    self.sceneSolarEnergy = nil
  end
  self.hasSolarEnergy = false
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:ShowSolarEnergy(value)
  self.hasSolarEnergy = value == true
  if not self.frenzyContainer then
    self:InitSolarEnergy()
  end
  self:UpdateFrenzyContainerVisible()
  self:RefreshDynamicLayout()
end

function SceneBottomHpSpCell:InitBlackMuck()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:InitBlackMuck()
  end
end

function SceneBottomHpSpCell:UpdateBlackMuck(muck, maxhp)
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:UpdateBlackMuck(muck, maxhp)
  end
end

function SceneBottomHpSpCell:RemoveBlackMuck()
  local bar = self:GetActiveBloodBar()
  if bar then
    bar:RemoveBlackMuck()
  end
end

function SceneBottomHpSpCell:RefreshBloodBarHp()
  local creature = self.creature
  if creature == nil then
    return
  end
  local buffhp, buffmaxhp = creature.data:GetBuffHpVals()
  if buffhp then
    self:SetHp(buffhp, buffmaxhp or 1)
  else
    local maxHp = creature.data.props:GetPropByName("MaxHp"):GetValue()
    self:SetHp(creature.data:GetHP(), maxHp)
  end
end

function SceneBottomHpSpCell:GetActiveBloodBar()
  if self.isBossBloodBarActive and self.bossBloodBar then
    return self.bossBloodBar
  end
  return self.bloodBar
end

function SceneBottomHpSpCell:RefreshBloodBarDecor(resistActive, bar)
  bar = bar or self.bloodBar
  if bar == nil then
    return
  end
  if resistActive ~= nil then
    self.resistActive = resistActive
  end
  bar:RefreshBossDecor({
    detailedType = self.detailedType,
    bosstype = self.bosstype,
    isMvpOrMini = self:isMvpOrMini(),
    isRareElite = self:isRareElite(),
    twelvePvp = Game.MapManager:IsPvPMode_TeamTwelve(),
    twelveBoss = self.staticID ~= nil and TwelvePvpConfig[self.staticID] ~= nil,
    twelveBuildNpc = self:IsTwelveBuildNPC(),
    resistActive = self.resistActive,
    showBalance = self.showBalance
  })
end

function SceneBottomHpSpCell:IsMultiLayerBoss()
  if self:IsChargeVisible() then
    return true
  end
  return (tonumber(self.buffHpGridCount) or 0) > 1
end

function SceneBottomHpSpCell:RefreshBossBloodBar()
  local multi = self:IsMultiLayerBoss()
  if multi == self.isBossBloodBarActive then
    return
  end
  if multi then
    if self.bossBloodBar == nil then
      local go = self:LoadPreferb("part/BossBloodBar", self.uibloodcontainer)
      if go == nil then
        return
      end
      self.bossBloodBarGO = go
      self.bossBloodBar = SceneBottomBloodBar.new(go, self)
      self.bossBloodBar:RefreshCampBg()
    end
    self.isBossBloodBarActive = true
    if self.bloodBar then
      self.bloodBar:SetVisible(false)
    end
    self.bossBloodBar:SetVisible(true)
    self:RefreshBloodBarDecor(nil, self.bossBloodBar)
    self:RefreshBloodBarHp()
  else
    self.isBossBloodBarActive = false
    if self.bloodBar then
      self.bloodBar:SetVisible(true)
    end
    if self.bossBloodBar then
      self.bossBloodBar:SetVisible(false)
    end
    self:RefreshBloodBarHp()
  end
end
