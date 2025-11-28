local BaseCell = autoImport("BaseCell")
SceneBottomHpSpCell = reusableClass("SceneBottomHpSpCell", BaseCell)
autoImport("SceneTimeDiskInfo")
autoImport("SceneStarMap")
autoImport("SceneFeatherGrid")
autoImport("SceneEnergyGrid")
autoImport("SceneBalanceBar")
autoImport("SceneSolarEnergy")
SceneBottomHpSpCell.resId = ResourcePathHelper.UIPrefab_Cell("SceneBottomHpSpCell")
local tempVector3 = LuaVector3.Zero()
SceneBottomHpSpCell.PoolSize = 30
local TwelvePvpConfig = GameConfig.TwelvePvp.HpShow
local ColorRed = LuaColor.New(1, 0.4627450980392157, 0.7176470588235294, 1)
local ColorGreen = LuaColor.New(0.6627450980392157, 0.9411764705882353, 0.3058823529411765, 1)

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
end

function SceneBottomHpSpCell:Deconstruct(asArray)
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
  if self.exMaxHp and self.exMaxHp > 0 then
    self.exMaxHp = nil
    if not Slua.IsNull(self.hpGrid) then
      self.hpGrid:SetActive(false)
    end
  end
  self.hpGrid = nil
  self.hpGridElements = nil
  self.spGrid = nil
  self.spGridElements = nil
  self.bulletsContainer = nil
  self.bulletsPrefab = nil
  self.bulletsNum = nil
  self.frenzyContainer = nil
  self.frenzyCanvasGroup = nil
  self.myFrenzySlider = nil
  self.frenzyLayer = nil
  self.timeDiskContainer = nil
  self.starMapContainer = nil
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
  self:RemoveFeatherGrid()
  self:ResetShieldHp()
  self:ResetResistance()
  self:RemoveBalance()
  self:RemoveShield()
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
  self.bosstype = creature:GetBossType()
  self.staticID = creature.data.staticData and creature.data.staticData.id
  self.resistanceBar = creature.data.staticData and creature.data.staticData.ResistanceBar or nil
  self.showBalance = creature.data.staticData and creature.data.staticData.BalanceBar
  self.creature = creature
end

function SceneBottomHpSpCell:initHpView()
  self.uibloodcontainer = self:FindGO("BloodContainer")
  self.uibloodslider = self:FindGO("BloodSlider"):GetComponent(Slider)
  self.uibloodGO = self:FindGO("Blood", self.uibloodcontainer)
  self.uiblood = self.uibloodGO:GetComponent(Image)
  self.tweenbloodslider = self:FindGO("TweenBloodSlider"):GetComponent(Slider)
  self.campIcon = self:FindComponent("PvpCamp", Image)
  self:initCreateBg()
  self:initDecorate()
  self:initHpValueLabel()
  self:InitHpGrid()
  self:InitCamp()
  self:InitShield()
  self:SetPvpCamp()
  self:InitBlackMuck()
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
  self:tweenHpSlider(hp, maxhp)
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
  self:UpdateExecutePart()
  self:UpdateShieldPos()
  if self.creature then
    local userdata = self.creature.data.userdata
    local shieldHp = userdata:Get(UDEnum.SHIELD_HP)
    local shieldMaxHp = userdata:Get(UDEnum.SHIELD_MAXHP)
    if shieldMaxHp and 0 < shieldMaxHp then
      self:SetShieldHp(shieldHp, shieldMaxHp)
    end
    if self.creature then
      local userdata = self.creature.data.userdata
      local MaxHp = self.creature.data.props:GetPropByName("MaxHp"):GetValue()
      local blackMuck = userdata:Get(UDEnum.BLACK_MUCK)
      if blackMuck and 0 < blackMuck then
        self:UpdateBlackMuck(blackMuck, MaxHp)
      end
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
      LeanTween.sliderUGUI(self.spSlider, curSp / maxSp, sp / maxSp, math.abs((sp - curSp) / maxSp) * 0.5)
    else
      self.spSlider.value = sp / maxSp
      self.isFirstSpInit = false
    end
  end
end

function SceneBottomHpSpCell:tweenHpSlider(hp, maxhp)
  local objNull = self:ObjIsNil(self.uibloodcontainer)
  if objNull then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  if self.uibloodcontainer.activeSelf then
    local curHp = self.uibloodslider.value * maxhp
    if not self.isFirstHpInit then
      self:setHpValueAndColor(hp / maxhp, hp)
      if hp < curHp then
        local time = 500 / (curHp / maxhp / (hp / maxhp))
        if time < 33 then
          self:SetTweenHpValueAndColor(hp / maxhp)
        else
          TimeTickManager.Me():CreateTickFromTo(0, curHp, hp, time, function(owner, deltaTime, curValue)
            self:SetTweenHpValueAndColor(curValue / maxhp)
          end, self, 1)
        end
      else
        self:SetTweenHpValueAndColor(hp / maxhp)
      end
    else
      local value = hp / maxhp
      self:setHpValueAndColor(value, hp)
      self:SetTweenHpValueAndColor(value)
      self.isFirstHpInit = false
    end
  else
    local value = hp == 0 and 0 or hp / maxhp
    self:setHpValueAndColor(value, hp)
    self:SetTweenHpValueAndColor(value)
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
      return
    end
  end
  self.uiWuDi:SetActive(false)
end

function SceneBottomHpSpCell:UpdateBuffHpGrid(hpGridCount)
  if not self.hpGrid then
    return
  end
  if hpGridCount then
    self.hpGrid:SetActive(true)
    self:UpdateHpGrid(hpGridCount)
  elseif self.exMaxHp and self.exMaxHp ~= 0 then
    if not self.defaultHpGridCount then
      self.hpGrid:SetActive(false)
    else
      self:UpdateHpGrid(self.defaultHpGridCount)
    end
  else
    self.hpGrid:SetActive(false)
  end
end

function SceneBottomHpSpCell:SetBuffHpBg(go)
  if go then
    self.forceBgName = "com_bg_hp_3s"
    self.lastHpBg = self.hpbg
    self:SetHpBg(self.forceBgName)
  else
    self.forceBgName = nil
    self:SetHpBg(self.lastHpBg or "com_bg_hp_s")
    self.lastHpBg = nil
  end
end

function SceneBottomHpSpCell:setHpValueAndColor(value, finalHp)
  local sliderlen = self.creature and self.creature.data.sliderlen
  sliderlen = sliderlen or 0.2
  if self.uiShieldHp then
    local shieldVal = self.uiShieldHp.value
    if 1 < value + shieldVal * sliderlen then
      value = 1 - shieldVal * sliderlen - 0.01
    end
  end
  self.nowHpValue = value
  self.uibloodslider.value = value
  if self.deadSlideAnim then
    self:SetTweenHpValueAndColor(0)
  end
  finalHp = math.floor(finalHp + 0.5)
  if value <= 0 and finalHp <= 0 then
    self.deadSlideAnim = false
    self:setHpSpVisible(false)
    return
  end
  if 0.2 >= self.uibloodslider.value and self.uibloodslider.value > 0 then
    if self.camp == RoleDefines_Camp.ENEMY then
      if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
        self:SetHpBg("com_bg_mp3")
      elseif "com_bg_hp_3s" ~= self.hpbg then
        self:SetHpBg("com_bg_hp_3s")
      end
    else
      self:SetHpBg("com_bg_hp_2s")
    end
  elseif self.camp == RoleDefines_Camp.ENEMY then
    if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
      self:SetHpBg("com_bg_mp2")
    else
      self:SetHpBg("com_bg_hp_4s")
    end
  else
    self:SetHpBg("com_bg_hp_s")
  end
end

function SceneBottomHpSpCell:SetTweenHpValueAndColor(value)
  self.tweenbloodslider.value = value
end

function SceneBottomHpSpCell:SetHpBg(bgName)
  if self.forceBgName then
    bgName = self.forceBgName
  end
  if bgName ~= self.hpbg then
    self.hpbg = bgName
    SpriteManager.SetUISprite("sceneuicom", bgName, self.uiblood)
  end
end

function SceneBottomHpSpCell:SetShieldHp(hp, maxhp)
  if Slua.IsNull(self.shieldPrefab) then
    self.shieldPrefab = self:LoadPreferb("part/SceneBottomHpSpCell_Shield", self.uibloodGO)
    self.shieldRect = self.shieldPrefab:GetComponent(RectTransform)
    self.shieldRect.anchoredPosition = LuaGeometry.Const_V3_zero
    self.uiShieldHp = self.shieldPrefab:GetComponent(Slider)
  end
  local sliderlen = self.creature and self.creature.data.sliderlen
  local multiShieldLevel = self.creature and self.creature.data.multiShieldLevel
  sliderlen = sliderlen or 0.2
  sliderlen = multiShieldLevel or sliderlen
  self.shieldRect.sizeDelta = LuaGeometry.GetTempVector2(sliderlen / 0.2 * 24, 10.8)
  hp = hp or 0
  maxhp = maxhp or 1
  local val = math.clamp(hp / maxhp, 0, 1)
  if self.nowHpValue and 1 < self.nowHpValue + val * sliderlen then
    self.uibloodslider.value = 1 - val * sliderlen - 0.01
  end
  if 0 < hp then
    self.uiShieldHp.value = val
  else
    self:ResetShieldHp()
  end
end

function SceneBottomHpSpCell:ResetShieldHp()
  if not self.shieldPrefab then
    return
  end
  if self.nowHpValue and self.uibloodslider then
    self.uibloodslider.value = self.nowHpValue
  end
  LuaGameObject.DestroyObject(self.shieldPrefab)
  self.shieldPrefab = nil
  self.uiShieldHp = nil
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
  local decoratorCanvas = self:FindGO("Decorate"):GetComponent(CanvasGroup)
  local rightBossBgGO = self:FindGO("rightBossBg")
  local rightBossBgCanvas = rightBossBgGO:GetComponent(CanvasGroup)
  local rightBossBg = rightBossBgGO:GetComponent(Image)
  local leftBossBg = self:FindGO("leftBossBg"):GetComponent(Image)
  if self:isMvpOrMini() then
    if self.detailedType == NpcData.NpcDetailedType.MINI then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_1", leftBossBg)
    elseif self.detailedType == NpcData.NpcDetailedType.MVP then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1", leftBossBg)
    elseif self.detailedType == NpcData.NpcDetailedType.WorldBoss then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "map_worldboss", leftBossBg)
    end
    if self.bosstype and self.bosstype == 3 then
      SpriteManager.SetUISprite("sceneuicom", "Boss_head1", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_mvp_dead11_JM", leftBossBg)
    end
    self:SetActive(rightBossBgCanvas, true)
    self:SetActive(decoratorCanvas, true)
  elseif self:isRareElite() then
    SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
    SpriteManager.SetUISprite("sceneuicom", "map_jingying", leftBossBg)
    self:SetActive(rightBossBgCanvas, true)
    self:SetActive(decoratorCanvas, true)
  elseif Game.MapManager:IsPvPMode_TeamTwelve() then
    if self.staticID and TwelvePvpConfig[self.staticID] then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_boss", leftBossBg)
      self:SetActive(rightBossBgCanvas, false)
      self:SetActive(decoratorCanvas, true)
    elseif self:IsTwelveBuildNPC() then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_build", leftBossBg)
      self:SetActive(rightBossBgCanvas, false)
      self:SetActive(decoratorCanvas, true)
    else
      self:SetActive(decoratorCanvas, false)
    end
  else
    self:SetActive(decoratorCanvas, false)
  end
  local uibloodBg = self:FindComponent("BossBloodBG", Image)
  if uibloodBg then
    if self:isMvpOrMini() then
      uibloodBg.color = LuaGeometry.Const_Col_white
    else
      uibloodBg.color = LuaGeometry.Const_Col_whiteClear
    end
  end
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
      self.resistanceGO = self:LoadPreferb("part/SceneBottomHpSpCell_Resistance", self:FindGO("ResistanceContainer"))
      self.uiSliderResistance = self:FindComponent("ResistanceSlider", Slider, self.resistanceGO)
      self.uiSliderFg = self:FindComponent("Sp", Image, self.resistanceGO)
      self.uiSliderFgBlink = self:FindGO("SpBlink", self.resistanceGO)
      self.uiResistanceHandle = self:FindGO("Handle", self.resistanceGO)
    else
      leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(32, 32)
      leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, 0)
    end
    self:SetResistance(self.creature)
  end
  if resistActive then
    leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(38, 38)
    leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, -3)
    if uibloodBg then
      uibloodBg.color = LuaGeometry.Const_Col_whiteClear
    end
    self:SetActive(rightBossBgCanvas, false)
  else
    leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(32, 32)
    leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, 0)
  end
  if self.showBalance then
    leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(38, 38)
    leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, -3)
    self:InitBalanceBar()
    if uibloodBg then
      uibloodBg.color = LuaGeometry.Const_Col_whiteClear
    end
    self:SetActive(rightBossBgCanvas, false)
    self:SetBalance(self.creature)
  else
    leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(32, 32)
    leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, 0)
  end
end

function SceneBottomHpSpCell:InitHpGrid()
  self.hpGrid = self:FindGO("hpGrid")
  if not self.hpGrid then
    return
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() then
    if self.ismyself or self:isPlayer() or self:isMvpOrMini() or self.staticID and TwelvePvpConfig[self.staticID] then
      self.hpGrid:SetActive(true)
      self.defaultHpGridCount = 4
      self:UpdateHpGrid(4)
    else
      self.hpGrid:SetActive(false)
    end
  else
    self.hpGrid:SetActive(false)
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
  self.hpGrid:SetActive(mode ~= SceneBottomHpSpCell.HpSpGridMode.None)
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
  maxCount = maxCount or self.defaultHpGridCount
  if not maxCount or maxCount == 0 then
    return
  end
  if self.exMaxHp == maxCount then
    return
  end
  self.exMaxHp = maxCount
  if not self.hpGrid then
    return
  end
  if not self.hpGridElements then
    self.hpGridElements = {}
    for i = 1, 9 do
      self.hpGridElements[i] = self:FindGO(i, self.hpGrid)
    end
    self.hpGridLayerout = self.hpGrid:GetComponent(HorizontalLayoutGroup)
  end
  local dis = (115 - maxCount * 2) / maxCount
  for i = 1, 9 do
    self.hpGridElements[i]:SetActive(maxCount > i)
  end
  local padding = self.hpGridLayerout.padding
  padding.left = math.ceil(dis)
  self.hpGridLayerout.padding = padding
  self.hpGridLayerout.spacing = dis
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
  local Camp = self:FindGO("Camp")
  if not Camp then
    return
  end
  local campBg = self:FindGO("campBg"):GetComponent(Image)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    Camp:SetActive(false)
    return
  end
  if self.ismyself or self:isPlayer() then
    SpriteManager.SetUISprite("sceneuicom", "com_mask", campBg)
    if self.camp == RoleDefines_Camp.ENEMY then
      campBg.color = ColorRed
    else
      campBg.color = ColorGreen
    end
    Camp:SetActive(true)
  else
    Camp:SetActive(false)
  end
end

function SceneBottomHpSpCell:setCamp(camp)
  self.camp = camp
  self:initCreateBg()
  self:UpdateExecutePart()
end

function SceneBottomHpSpCell:initCreateBg()
  local camp = self.camp
  if camp == RoleDefines_Camp.ENEMY then
    if "com_bg_hp_4s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_4s", self.uiblood)
      self.hpbg = "com_bg_hp_4s"
    end
  elseif "com_bg_hp_s" ~= self.hpbg then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_s", self.uiblood)
    self.hpbg = "com_bg_hp_s"
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
end

function SceneBottomHpSpCell:UpdateSanityPostion(needReposition)
  if self:ObjIsNil(self.mySanity) then
    return
  end
  if not self.spContainer or not self.spContainer.activeSelf then
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, -44, 0)
  elseif not self.hasFrenzy then
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, needReposition and -74 or -52, 0)
  else
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, needReposition and -84 or -62, 0)
  end
end

function SceneBottomHpSpCell:ClearSanity()
  if self.mySanity and not self:ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
    self.mySanity = nil
  end
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
  if self.uibloodslider.value <= 0.2 and self.uibloodslider.value > 0 then
    if self.camp == RoleDefines_Camp.ENEMY then
      if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
        if "com_bg_mp3" ~= self.hpbg then
          SpriteManager.SetUISprite("sceneuicom", "com_bg_mp3", self.uiblood)
          self.hpbg = "com_bg_mp3"
        end
      elseif "com_bg_hp_3s" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_3s", self.uiblood)
        self.hpbg = "com_bg_hp_3s"
      end
    elseif "com_bg_hp_2s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_2s", self.uiblood)
      self.hpbg = "com_bg_hp_2s"
    end
  elseif self.camp == RoleDefines_Camp.ENEMY then
    if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
      if "com_bg_mp2" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_mp2", self.uiblood)
        self.hpbg = "com_bg_mp2"
      end
    elseif "com_bg_hp_4s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_4s", self.uiblood)
      self.hpbg = "com_bg_hp_4s"
    end
  elseif "com_bg_hp_s" ~= self.hpbg then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_s", self.uiblood)
    self.hpbg = "com_bg_hp_s"
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
  self.frenzyContainer = self:FindGO("FrenzyContainer")
  if not self.frenzyContainer or self:ObjIsNil(self.frenzyContainer) then
    return
  end
  if not self.frenzyCanvasGroup then
    self.frenzyCanvasGroup = self.frenzyContainer:GetComponent(CanvasGroup)
  end
  local prefab = self:LoadPreferb("part/FrenzyBar", self.frenzyContainer)
  if prefab then
    self.myFrenzySlider = self:FindGO("FrenzySlider", prefab):GetComponent(Slider)
    self.frenzyLayer = self:FindGO("FrenzyLayer", prefab):GetComponent(Text)
    self.frenzyLayer.text = layer or 0
    self.myFrenzySlider.value = 0
  end
end

function SceneBottomHpSpCell:UpdateFrenzyLayer(layer, maxLayer)
  if not self.frenzyContainer then
    self:InitFrenzy()
  end
  self.frenzyLayer.text = layer or 0
  self.myFrenzySlider.value = (layer or 0) / (maxLayer ~= 0 and maxLayer or 1)
  self:ShowFrenzy(true)
end

function SceneBottomHpSpCell:ShowFrenzy(value)
  if self.frenzyContainer then
    if value and not self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(true)
    elseif false == value and self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(false)
    end
  else
    self:InitFrenzy()
  end
  self.hasFrenzy = value
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
end

local PropertyProgress = GameConfig.PropertyProgress

function SceneBottomHpSpCell:InitExecutePart()
  self.executePart = self:FindGO("ExecuteLineSlider")
  if not self.executePart or self:ObjIsNil(self.executePart) then
    return
  end
  if not self.executeCanvasGroup then
    self.executeCanvasGroup = self.executePart:GetComponent(CanvasGroup)
  end
  self.executeLine = self.executePart:GetComponent(Slider)
  self.executeLine.value = 0
  self.executeIcon = self:FindGO("executeIcon", self.executePart):GetComponent(Image)
  SpriteManager.SetUISprite("sceneuicom", "main_icon_purple", self.executeIcon)
  self.executeBg = self:FindGO("executeBg", self.executePart)
  self.progressList = {}
  for value, icon in pairs(PropertyProgress) do
    table.insert(self.progressList, {value = value, icon = icon})
  end
  table.sort(self.progressList, function(l, r)
    return l.value < r.value
  end)
  self.initExecute = true
  self:UpdateExecutePart()
end

local creatureid

function SceneBottomHpSpCell:UpdateExecutePart()
  if not self.initExecute then
    self:InitExecutePart()
  end
  if self.camp == RoleDefines_Camp.ENEMY and self:isPlayer() then
    if not self.executePart or self:ObjIsNil(self.executePart) then
      return
    end
    creatureid = self.creature and self.creature.data.id or 0
    local value = MyselfProxy.Instance:GetTarInterferenceValue(creatureid)
    self:SetActive(self.executeCanvasGroup, 0 < value)
    local killline, isKill = CommonFun.calcKillLine(self.creature, self.creature.data)
    self.executeLine.value = killline / 100
    local setIcon = false
    for i = 1, #self.progressList do
      if value < self.progressList[i].value then
        setIcon = true
        SpriteManager.SetUISprite("sceneuicom", self.progressList[i].icon, self.executeIcon)
        break
      end
    end
    if not setIcon then
      SpriteManager.SetUISprite("sceneuicom", self.progressList[#self.progressList].icon, self.executeIcon)
    end
    self.executeBg:SetActive(isKill == 1)
  else
    self:SetActive(self.executeCanvasGroup, false)
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
end

function SceneBottomHpSpCell:ShowFeather(value)
  if self.featherContainer then
    if value and not self.featherContainer.activeSelf then
      self.featherContainer:SetActive(true)
    elseif false == value and self.featherContainer.activeSelf then
      self.featherContainer:SetActive(false)
    end
  else
    self:InitFeatherGrid()
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
end

function SceneBottomHpSpCell:ShowEnergy(value)
  if self.energyContainer then
    if value and not self.energyContainer.activeSelf then
      self.energyContainer:SetActive(true)
    elseif false == value and self.energyContainer.activeSelf then
      self.energyContainer:SetActive(false)
    end
  else
    self:InitEnergyGrid()
  end
end

function SceneBottomHpSpCell:InitBalanceBar()
  if not self.sceneBalanceBar then
    self.balanceContainer = self:FindGO("BalanceContainer")
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
  self.sceneBalanceBar:SetBalance(value)
end

function SceneBottomHpSpCell:RemoveBalance()
  if self.sceneBalanceBar then
    self.sceneBalanceBar:Destroy()
    self.sceneBalanceBar = nil
  end
end

local tempV3 = LuaVector3.Zero()
local Slider_Length = 113
local showShield, sliderValue

function SceneBottomHpSpCell:SetNormalShield(shield, maxhp)
  if not self.shieldSlider then
    return
  end
  shield = shield or 0
  showShield = shield ~= 0 and maxhp ~= 0
  self.shieldbg:SetActive(showShield)
  self.shieldFrame:SetActive(showShield)
  if shield == 0 or maxhp == 0 then
    return
  end
  sliderValue = shield / (shield + maxhp)
  self.shieldSlider.value = sliderValue
  self.frameSlider.value = sliderValue
  if 0 < shield then
    self:UpdateShieldPos()
    self.shield:SetActive(true)
    self.frame:SetActive(true)
  else
    self.shield:SetActive(false)
    self.frame:SetActive(false)
  end
end

function SceneBottomHpSpCell:UpdateShieldPos()
  if self.shieldSlider and self.shieldSlider.value > 0 then
    tempV3[1] = Slider_Length * (self.uibloodslider.value or 0)
    if tempV3[1] + Slider_Length * self.shieldSlider.value > Slider_Length then
      tempV3[1] = Slider_Length - Slider_Length * self.shieldSlider.value
    end
    self.shieldbg.transform.localPosition = tempV3
    self.shieldFrame.transform.localPosition = tempV3
  end
end

function SceneBottomHpSpCell:ResetNormalShield()
  if not self.shieldPrefab then
    return
  end
  if self.nowHpValue and self.uibloodslider then
    self.uibloodslider.value = self.nowHpValue
  end
  LuaGameObject.DestroyObject(self.shieldPrefab)
  self.shieldPrefab = nil
  self.uiShieldHp = nil
end

function SceneBottomHpSpCell:InitShield()
  self.shieldbg = self:FindGO("shieldBG")
  self.shield = self:FindGO("shield")
  self.shieldSlider = self.shieldbg:GetComponent(Slider)
  self.shieldFrame = self:FindGO("shieldFrame")
  self.frame = self:FindGO("frame")
  self.frameSlider = self.shieldFrame:GetComponent(Slider)
  self.shieldSlider.value = 0
  self.frameSlider.value = 0
end

function SceneBottomHpSpCell:RemoveShield()
  self.shieldbg = nil
  self.shield = nil
  self.shieldSlider = nil
  self.shieldFrame = nil
  self.frame = nil
  self.frameSlider = nil
end

function SceneBottomHpSpCell:ResetRidePos(reset)
  if reset then
    self.transform.localPosition = LuaGeometry.GetTempVector3(-80, 100, 0)
  else
    self.transform.localPosition = LuaGeometry.Const_V3_zero
  end
end

function SceneBottomHpSpCell:SetPvpCamp()
  self.campIcon.gameObject:SetActive(false)
  if Game.MapManager:IsPVPMode_EndlessBattleField() then
    local camp = self.creatureType == Creature_Type.Pet and self.creature.master_pvp_camp or self.creature.data:GetNormalPVPCamp()
    local config = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CampPosition
    redlog("camp", tostring(self.creature.data.name), camp)
    if config then
      local spriteName = config[camp] and config[camp].mapSymbol
      if spriteName then
        local result = SpriteManager.SetUISprite("sceneui", spriteName, self.campIcon)
        if result then
          self.campIcon.gameObject:SetActive(true)
        end
      end
    end
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
  end
end

function SceneBottomHpSpCell:UpdateSolarEnergy(bufflayer, maxLayer)
  if not self.sceneSolarEnergy then
    self:InitSolarEnergy()
  end
  self.sceneSolarEnergy:UpdateSolarEnergy(bufflayer, maxLayer)
end

function SceneBottomHpSpCell:RemoveSolarEnergy()
  if self.sceneSolarEnergy then
    self.sceneSolarEnergy:Destroy()
    self.sceneSolarEnergy = nil
  end
end

function SceneBottomHpSpCell:ShowSolarEnergy(value)
  if self.frenzyContainer then
    if value and not self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(true)
    elseif false == value and self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(false)
    end
  else
    self:InitSolarEnergy()
  end
end

function SceneBottomHpSpCell:InitBlackMuck()
  if not self.blackMuck then
    self.blackMuck = self:FindGO("BlackM"):GetComponent(Slider)
    self.blackMuck.value = 0
    self.blackMuck.gameObject:SetActive(false)
  end
end

function SceneBottomHpSpCell:UpdateBlackMuck(muck, maxhp)
  if muck == 0 or maxhp == 0 then
    self.blackMuck.gameObject:SetActive(false)
  else
    self.blackMuck.gameObject:SetActive(true)
    self.blackMuck.value = muck / maxhp
  end
end

function SceneBottomHpSpCell:RemoveBlackMuck()
  self.blackMuck = nil
end
