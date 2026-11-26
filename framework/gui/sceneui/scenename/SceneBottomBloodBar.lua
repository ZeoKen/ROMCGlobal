SceneBottomBloodBar = class("SceneBottomBloodBar")
local TwelvePvpConfig = GameConfig.TwelvePvp.HpShow
local ColorRed = LuaColor.New(1, 0.4627450980392157, 0.7176470588235294, 1)
local ColorGreen = LuaColor.New(0.6627450980392157, 0.9411764705882353, 0.3058823529411765, 1)
local sliderLength = 115
local maxHpGridCount = 20
local PropertyProgress = GameConfig.PropertyProgress
local tempV3 = LuaVector3.Zero()
local Slider_Length = 113
local showShield, sliderValue, creatureid
local _Valid = function(go)
  return go ~= nil and not LuaGameObject.ObjectIsNull(go)
end
local _SetActive = function(canvasGroup, visible)
  if canvasGroup then
    canvasGroup.alpha = visible and 1 or 0
  end
end

function SceneBottomBloodBar:ctor(root, owner)
  self.root = root
  self.owner = owner
  self.destroyed = false
  self.hpbg = nil
  self.forceBgName = nil
  self.lastHpBg = nil
  self.isFirstHpInit = true
  self.nowHpValue = nil
  self.leftBossBgPrefabY = 0
  self.leftBossBgBaseY = 0
  self:Init()
end

function SceneBottomBloodBar:Init()
  if not _Valid(self.root) then
    return
  end
  local root = self.root
  local owner = self.owner
  self.bloodSlider = owner:FindComponent("BloodSlider", Slider, root)
  self.bloodGO = owner:FindGO("Blood", root)
  self.bloodImage = self.bloodGO and self.bloodGO:GetComponent(Image) or nil
  self.tweenBloodSlider = owner:FindComponent("TweenBloodSlider", Slider, root)
  self.campIcon = owner:FindComponent("PvpCamp", Image, root)
  self:InitDecorate()
  self:InitHpGrid()
  self:InitCamp()
  self:InitShield()
  self:SetPvpCamp()
  self:InitBlackMuck()
end

function SceneBottomBloodBar:IsValid()
  return not self.destroyed and _Valid(self.root)
end

function SceneBottomBloodBar:SetVisible(visible)
  if _Valid(self.root) then
    self.root:SetActive(visible)
  end
end

function SceneBottomBloodBar:IsVisible()
  return _Valid(self.root) and self.root.activeSelf
end

function SceneBottomBloodBar:RefreshBossDecor(ctx)
  if not _Valid(self.root) then
    return
  end
  ctx = ctx or {}
  local leftBossBg = self.leftBossBg
  local rightBossBg = self.rightBossBg
  if ctx.isMvpOrMini then
    if ctx.detailedType == NpcData.NpcDetailedType.MINI then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_1", leftBossBg)
    elseif ctx.detailedType == NpcData.NpcDetailedType.MVP then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1", leftBossBg)
    elseif ctx.detailedType == NpcData.NpcDetailedType.WorldBoss then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "map_worldboss", leftBossBg)
    end
    if ctx.bosstype and ctx.bosstype == 3 then
      SpriteManager.SetUISprite("sceneuicom", "Boss_head1", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_mvp_dead11_JM", leftBossBg)
    end
    _SetActive(self.decoratorCanvas, true)
    _SetActive(self.rightBossBgCanvas, true)
  elseif ctx.isRareElite then
    SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
    SpriteManager.SetUISprite("sceneuicom", "map_jingying", leftBossBg)
    _SetActive(self.decoratorCanvas, true)
    _SetActive(self.rightBossBgCanvas, true)
  elseif ctx.twelvePvp then
    if ctx.twelveBoss then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_boss", leftBossBg)
      _SetActive(self.rightBossBgCanvas, false)
      _SetActive(self.decoratorCanvas, true)
    elseif ctx.twelveBuildNpc then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_build", leftBossBg)
      _SetActive(self.rightBossBgCanvas, false)
      _SetActive(self.decoratorCanvas, true)
    else
      _SetActive(self.decoratorCanvas, false)
    end
  else
    _SetActive(self.decoratorCanvas, false)
  end
  if (ctx.resistActive or ctx.showBalance) and _Valid(self.bossBloodBg) then
    self.bossBloodBg.color = LuaGeometry.Const_Col_whiteClear
  end
  local baseY = (self.leftBossBgPrefabY or 0) + (ctx.showBalance and -3 or 0)
  if _Valid(leftBossBg) then
    leftBossBg.rectTransform.sizeDelta = LuaGeometry.GetTempVector2(ctx.showBalance and 38 or 32, ctx.showBalance and 38 or 32)
    leftBossBg.rectTransform.anchoredPosition = LuaGeometry.GetTempVector2(-67, baseY)
  end
  self.leftBossBgBaseY = baseY
  self.rightBossBgDefaultActive = self.rightBossBgCanvas ~= nil and self.rightBossBgCanvas.gameObject.activeSelf or false
end

function SceneBottomBloodBar:InitDecorate()
  local root = self.root
  local owner = self.owner
  local decoratorGO = owner:FindGO("Decorate", root)
  self.decoratorCanvas = decoratorGO and decoratorGO:GetComponent(CanvasGroup) or nil
  local rightBossBgGO = owner:FindGO("rightBossBg", root)
  self.rightBossBgGO = rightBossBgGO
  self.rightBossBgCanvas = rightBossBgGO and rightBossBgGO:GetComponent(CanvasGroup) or nil
  self.rightBossBg = rightBossBgGO and rightBossBgGO:GetComponent(Image) or nil
  self.leftBossBg = owner:FindComponent("leftBossBg", Image, root)
  self.leftBossBgPrefabY = 0
  if _Valid(self.leftBossBg) and self.leftBossBg.rectTransform then
    self.leftBossBgPrefabY = self.leftBossBg.rectTransform.anchoredPosition.y
  end
  self.leftBossBgBaseY = self.leftBossBgPrefabY
  self.bossBloodBg = owner:FindComponent("BossBloodBG", Image, root)
  if _Valid(self.bossBloodBg) then
    self.bossBloodBg.color = owner:isMvpOrMini() and LuaGeometry.Const_Col_white or LuaGeometry.Const_Col_whiteClear
  end
end

function SceneBottomBloodBar:RefreshCampBg()
  if not _Valid(self.bloodImage) then
    return
  end
  if self.owner.camp == RoleDefines_Camp.ENEMY then
    self:SetHpBg("com_bg_hp_4s")
  else
    self:SetHpBg("com_bg_hp_s")
  end
end

function SceneBottomBloodBar:SetHpBg(bgName)
  if self.forceBgName then
    bgName = self.forceBgName
  end
  if bgName ~= self.hpbg then
    self.hpbg = bgName
    SpriteManager.SetUISprite("sceneuicom", bgName, self.bloodImage)
  end
end

function SceneBottomBloodBar:SetBuffHpBg(on)
  if on then
    self.forceBgName = "com_bg_hp_3s"
    self.lastHpBg = self.hpbg
    self:SetHpBg(self.forceBgName)
  else
    self.forceBgName = nil
    self:SetHpBg(self.lastHpBg or "com_bg_hp_s")
    self.lastHpBg = nil
  end
end

function SceneBottomBloodBar:RefreshHpBgByValue()
  local owner = self.owner
  local low = self.bloodSlider ~= nil and self.bloodSlider.value <= 0.2 and self.bloodSlider.value > 0
  if low then
    if owner.camp == RoleDefines_Camp.ENEMY then
      if Game.MapManager:IsPvPMode_TeamTwelve() and owner:isMvpOrMini() then
        self:SetHpBg("com_bg_mp3")
      else
        self:SetHpBg("com_bg_hp_3s")
      end
    else
      self:SetHpBg("com_bg_hp_2s")
    end
  elseif owner.camp == RoleDefines_Camp.ENEMY then
    if Game.MapManager:IsPvPMode_TeamTwelve() and owner:isMvpOrMini() then
      self:SetHpBg("com_bg_mp2")
    else
      self:SetHpBg("com_bg_hp_4s")
    end
  else
    self:SetHpBg("com_bg_hp_s")
  end
end

function SceneBottomBloodBar:SetHpValue(hp, maxhp)
  local container = self.owner.uibloodcontainer
  if not _Valid(container) then
    return
  end
  TimeTickManager.Me():ClearTick(self.owner, 1)
  if container.activeSelf then
    local curHp = self.bloodSlider.value * maxhp
    if not self.isFirstHpInit then
      self:SetHpValueAndColor(hp / maxhp, hp)
      if hp < curHp then
        local time = 500 / (curHp / maxhp / (hp / maxhp))
        if time < 33 then
          self:SetTweenHpValueAndColor(hp / maxhp)
        else
          TimeTickManager.Me():CreateTickFromTo(0, curHp, hp, time, function(owner, deltaTime, curValue)
            if self.destroyed then
              return
            end
            self:SetTweenHpValueAndColor(curValue / maxhp)
          end, self.owner, 1)
        end
      else
        self:SetTweenHpValueAndColor(hp / maxhp)
      end
    else
      local value = hp / maxhp
      self:SetHpValueAndColor(value, hp)
      self:SetTweenHpValueAndColor(value)
      self.isFirstHpInit = false
    end
  else
    local value = hp == 0 and 0 or hp / maxhp
    self:SetHpValueAndColor(value, hp)
    self:SetTweenHpValueAndColor(value)
  end
end

function SceneBottomBloodBar:SetTweenHpValueAndColor(value)
  if _Valid(self.tweenBloodSlider) then
    self.tweenBloodSlider.value = value
  end
end

function SceneBottomBloodBar:SetHpValueAndColor(value, finalHp)
  local owner = self.owner
  local sliderlen = owner.creature and owner.creature.data.sliderlen
  sliderlen = sliderlen or 0.2
  if self.uiShieldHp then
    local shieldVal = self.uiShieldHp.value
    if 1 < value + shieldVal * sliderlen then
      value = 1 - shieldVal * sliderlen - 0.01
    end
  end
  self.nowHpValue = value
  if _Valid(self.bloodSlider) then
    self.bloodSlider.value = value
  end
  if owner.deadSlideAnim then
    self:SetTweenHpValueAndColor(0)
  end
  finalHp = math.floor(finalHp + 0.5)
  if value <= 0 and finalHp <= 0 then
    owner.deadSlideAnim = false
    owner:setHpSpVisible(false)
    if self.shieldbg then
      self.shieldbg:SetActive(false)
    end
    if self.shieldFrame then
      self.shieldFrame:SetActive(false)
    end
    if self.shield then
      self.shield:SetActive(false)
    end
    if self.frame then
      self.frame:SetActive(false)
    end
    return
  end
  self:RefreshHpBgByValue()
end

function SceneBottomBloodBar:InitHpGrid()
  self.hpGrid = self.owner:FindGO("hpGrid", self.root)
  if not self.hpGrid then
    return
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() then
    local owner = self.owner
    if owner.ismyself or owner:isPlayer() or owner:isMvpOrMini() or owner.staticID and TwelvePvpConfig[owner.staticID] then
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

function SceneBottomBloodBar:UpdateHpGrid(maxCount)
  maxCount = maxCount or self.defaultHpGridCount
  if not maxCount or maxCount == 0 then
    return
  end
  maxCount = math.min(maxCount, maxHpGridCount)
  if self.exMaxHp == maxCount then
    return
  end
  self.exMaxHp = maxCount
  if not self.hpGrid then
    return
  end
  if not self.hpGridElements then
    self.hpGridElements = {}
    self.hpSplitTemplate = self.owner:FindGO("hpSplit", self.hpGrid)
    self.hpGridLayerout = self.hpGrid:GetComponent(HorizontalLayoutGroup)
  end
  if self.hpSplitTemplate then
    for i = #self.hpGridElements + 1, maxCount - 1 do
      local clone = GameObject.Instantiate(self.hpSplitTemplate)
      clone.transform:SetParent(self.hpGrid.transform, false)
      clone.transform:SetAsLastSibling()
      self.hpGridElements[i] = clone
    end
  elseif #self.hpGridElements == 0 then
    local i = 1
    while 2 do
      local go = self.owner:FindGO(i, self.hpGrid)
      if not go then
        break
      end
      self.hpGridElements[i] = go
      i = i + 1
    end
  end
  local dis = (115 - maxCount * 2) / maxCount
  for i = 1, #self.hpGridElements do
    self.hpGridElements[i]:SetActive(maxCount > i)
  end
  if self.hpGridLayerout then
    local padding = self.hpGridLayerout.padding
    padding.left = math.ceil(dis)
    self.hpGridLayerout.padding = padding
    self.hpGridLayerout.spacing = dis
  end
end

function SceneBottomBloodBar:UpdateBuffHpGrid(hpGridCount)
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

function SceneBottomBloodBar:InitShield()
  local root = self.root
  self.shieldbg = self.owner:FindGO("shieldBG", root)
  self.shield = self.owner:FindGO("shield", root)
  self.shieldSlider = self.shieldbg and self.shieldbg:GetComponent(Slider) or nil
  self.shieldFrame = self.owner:FindGO("shieldFrame", root)
  self.frame = self.owner:FindGO("frame", root)
  self.frameSlider = self.shieldFrame and self.shieldFrame:GetComponent(Slider) or nil
  if self.shieldSlider then
    self.shieldSlider.value = 0
  end
  if self.frameSlider then
    self.frameSlider.value = 0
  end
end

function SceneBottomBloodBar:SetShieldHp(hp, maxhp)
  local owner = self.owner
  if Slua.IsNull(self.shieldPrefab) then
    self.shieldPrefab = owner:LoadPreferb("part/SceneBottomHpSpCell_Shield", self.bloodGO)
    if not _Valid(self.shieldPrefab) then
      return
    end
    self.shieldRect = self.shieldPrefab:GetComponent(RectTransform)
    self.shieldRect.anchoredPosition = LuaGeometry.Const_V3_zero
    self.uiShieldHp = self.shieldPrefab:GetComponent(Slider)
  end
  local sliderlen = owner.creature and owner.creature.data.sliderlen
  local multiShieldLevel = owner.creature and owner.creature.data.multiShieldLevel
  sliderlen = sliderlen or 0.2
  sliderlen = multiShieldLevel or sliderlen
  self.shieldRect.sizeDelta = LuaGeometry.GetTempVector2(sliderlen / 0.2 * 24, 10.8)
  hp = hp or 0
  maxhp = maxhp or 1
  local val = math.clamp(hp / maxhp, 0, 1)
  if self.nowHpValue and 1 < self.nowHpValue + val * sliderlen and _Valid(self.bloodSlider) then
    self.bloodSlider.value = 1 - val * sliderlen - 0.01
  end
  if 0 < hp then
    self.uiShieldHp.value = val
  else
    self:ResetShieldHp()
  end
end

function SceneBottomBloodBar:ResetShieldHp()
  if not self.shieldPrefab then
    return
  end
  if self.nowHpValue and self.bloodSlider then
    self.bloodSlider.value = self.nowHpValue
  end
  LuaGameObject.DestroyObject(self.shieldPrefab)
  self.shieldPrefab = nil
  self.uiShieldHp = nil
end

function SceneBottomBloodBar:SetNormalShield(shield, maxhp)
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

function SceneBottomBloodBar:UpdateShieldPos()
  if self.shieldSlider and self.shieldSlider.value > 0 then
    local bloodValue = self.bloodSlider and self.bloodSlider.value or 0
    tempV3[1] = Slider_Length * bloodValue
    if tempV3[1] + Slider_Length * self.shieldSlider.value > Slider_Length then
      tempV3[1] = Slider_Length - Slider_Length * self.shieldSlider.value
    end
    self.shieldbg.transform.localPosition = tempV3
    self.shieldFrame.transform.localPosition = tempV3
  end
end

function SceneBottomBloodBar:ResetNormalShield()
  if not self.shieldPrefab then
    return
  end
  if self.nowHpValue and self.bloodSlider then
    self.bloodSlider.value = self.nowHpValue
  end
  LuaGameObject.DestroyObject(self.shieldPrefab)
  self.shieldPrefab = nil
  self.uiShieldHp = nil
end

function SceneBottomBloodBar:RemoveShield()
  self.shieldbg = nil
  self.shield = nil
  self.shieldSlider = nil
  self.shieldFrame = nil
  self.frame = nil
  self.frameSlider = nil
end

function SceneBottomBloodBar:InitBlackMuck()
  if not self.blackMuck then
    self.blackMuck = self.owner:FindComponent("BlackM", Slider, self.root)
    if not self.blackMuck then
      return
    end
    self.blackMuck.value = 0
    self.blackMuck.gameObject:SetActive(false)
  end
end

function SceneBottomBloodBar:UpdateBlackMuck(muck, maxhp)
  if not self.blackMuck then
    self:InitBlackMuck()
  end
  if not self.blackMuck then
    return
  end
  if muck == 0 or maxhp == 0 then
    self.blackMuck.gameObject:SetActive(false)
  else
    self.blackMuck.gameObject:SetActive(true)
    self.blackMuck.value = muck / maxhp
  end
end

function SceneBottomBloodBar:RemoveBlackMuck()
  self.blackMuck = nil
end

function SceneBottomBloodBar:InitExecutePart()
  self.executePart = self.owner:FindGO("ExecuteLineSlider", self.root)
  if not self.executePart or self.owner:ObjIsNil(self.executePart) then
    return
  end
  if not self.executeCanvasGroup then
    self.executeCanvasGroup = self.executePart:GetComponent(CanvasGroup)
  end
  self.executeLine = self.executePart:GetComponent(Slider)
  self.executeLine.value = 0
  self.executeIcon = self.owner:FindGO("executeIcon", self.executePart)
  self.executeIcon = self.executeIcon and self.executeIcon:GetComponent(Image) or nil
  SpriteManager.SetUISprite("sceneuicom", "main_icon_purple", self.executeIcon)
  self.executeBg = self.owner:FindGO("executeBg", self.executePart)
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

function SceneBottomBloodBar:UpdateExecutePart()
  local owner = self.owner
  if not self.initExecute then
    self:InitExecutePart()
  end
  if owner.camp == RoleDefines_Camp.ENEMY and owner:isPlayer() then
    if not self.executePart or owner:ObjIsNil(self.executePart) then
      return
    end
    creatureid = owner.creature and owner.creature.data.id or 0
    local value = MyselfProxy.Instance:GetTarInterferenceValue(creatureid)
    _SetActive(self.executeCanvasGroup, 0 < value)
    local killline, isKill = CommonFun.calcKillLine(owner.creature, owner.creature.data)
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
    _SetActive(self.executeCanvasGroup, false)
  end
end

function SceneBottomBloodBar:InitCamp()
  local owner = self.owner
  local Camp = owner:FindGO("Camp", self.root)
  self.campGO = Camp
  if not Camp then
    return
  end
  local campBg = owner:FindGO("campBg", self.root)
  self.campBg = campBg and campBg:GetComponent(Image) or nil
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    Camp:SetActive(false)
    return
  end
  if owner.ismyself or owner:isPlayer() then
    SpriteManager.SetUISprite("sceneuicom", "com_mask", self.campBg)
    if owner.camp == RoleDefines_Camp.ENEMY then
      self.campBg.color = ColorRed
    else
      self.campBg.color = ColorGreen
    end
    Camp:SetActive(true)
  else
    Camp:SetActive(false)
  end
end

function SceneBottomBloodBar:SetPvpCamp()
  local owner = self.owner
  if not self.campIcon then
    return
  end
  self.campIcon.gameObject:SetActive(false)
  if Game.MapManager:IsPVPMode_EndlessBattleField() then
    local creature = owner.creature
    local camp = owner.creatureType == Creature_Type.Pet and creature.master_pvp_camp or creature.data:GetNormalPVPCamp()
    local config = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CampPosition
    redlog("camp", tostring(creature.data.name), camp)
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

function SceneBottomBloodBar:Destroy()
  self.destroyed = true
  TimeTickManager.Me():ClearTick(self.owner, 1)
  self:RemoveShield()
  self:RemoveBlackMuck()
  if self.shieldPrefab then
    LuaGameObject.DestroyObject(self.shieldPrefab)
    self.shieldPrefab = nil
  end
  self.uiShieldHp = nil
  if self.hpGridElements then
    for i = 1, #self.hpGridElements do
      if not Slua.IsNull(self.hpGridElements[i]) then
        GameObject.Destroy(self.hpGridElements[i])
      end
    end
  end
  self.hpGridElements = nil
  self.hpSplitTemplate = nil
  self.hpGridLayerout = nil
  self.hpGrid = nil
  self.root = nil
end
