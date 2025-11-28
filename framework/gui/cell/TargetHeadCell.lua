autoImport("PlayerFaceCell")
autoImport("NatureLevelCell")
TargetHeadCell = class("TargetHeadCell", PlayerFaceCell)
TargetHeadEvent = {
  CancelChoose = "TargetHeadEvent_CancelChoose"
}
MonsterTextColorConfig = {
  Level = {H = 15, L = 20},
  Color = {
    H = Color(0.9882352941176471, 0.1607843137254902, 0.20392156862745098),
    N = Color(1, 1, 1),
    L = Color(1, 1, 1)
  },
  EffectColor = {
    H = Color(0.3686274509803922, 0 / 255, 0.03137254901960784),
    N = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922),
    L = Color(0.4549019607843137, 0.6039215686274509, 0.7686274509803922)
  }
}
local _PrestigeOutlineColor = {
  [1] = LuaColor.New(0.8, 0.2549019607843137, 0.24705882352941178, 1),
  [2] = LuaColor.New(0.7568627450980392, 0.17647058823529413, 0.4470588235294118, 1)
}

function TargetHeadCell:ctor(go)
  local contentGO = self:FindGO("Content", go)
  TargetHeadCell.super.ctor(self, contentGO)
end

function TargetHeadCell:Init()
  TargetHeadCell.super.Init(self)
  self.lvmat = "%s"
  self.headIconCell:HideFrame()
  self.headBg = self:FindComponent("HeadBg", UISprite)
  self.restTip = self:FindGO("RestTip")
  self.restTime = self:FindComponent("RestTime", UILabel)
  self.levelObj = self:FindGO("level")
  self:SetData(nil)
  self.cancelChoose = self:FindGO("CancelChoose")
  self:AddClickEvent(self.cancelChoose, function(go)
    self:PassEvent(TargetHeadEvent.CancelChoose, self)
  end)
  self.redFrame = self:FindGO("Red")
  self.nature = self:FindComponent("nature", UISprite)
  local natureLv = self:FindGO("natureLevel")
  if natureLv then
    self.natureLevelCell = NatureLevelCell.new(natureLv)
  end
  local resistanceGO = self:FindGO("resistanceSlider")
  if resistanceGO then
    self.resistanceSlider = resistanceGO:GetComponent(UISlider)
    if self.resistanceSlider then
      self.resistanceSlider.value = 0
    end
    self.resistanceFg1 = self:FindComponent("foreground", UISprite, resistanceGO)
    self.resistanceFg2 = self:FindComponent("foreground2", UISprite, resistanceGO)
  end
  self.prestigeGO = self:FindGO("PrestigeLevelBG")
  self.prestigeBg = self.prestigeGO:GetComponent(UIMultiSprite)
  self.prestigeLevel = self:FindGO("PrestigeLevel", self.prestigeGO):GetComponent(UILabel)
end

function TargetHeadCell:InitHeadIconCell()
  self.headIconCell = MainViewHeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
  self.headIconCell:IsPet(true)
end

function TargetHeadCell:SetData(data)
  TargetHeadCell.super.SetData(self, data)
  self:UpdateNature()
  if self.resistanceSlider and data and data.creatureId then
    local target = SceneCreatureProxy.FindCreature(data.creatureId)
    if target then
      self:SetResistanceValue(target)
    end
  end
end

function TargetHeadCell:UpdateNature()
  if not self.nature then
    return
  end
  local natureIcon, natureLevel
  local creatureId = self.data and self.data.creatureId
  local target = SceneCreatureProxy.FindCreature(creatureId)
  if target and target.data:IsMonster() and target.data.isSkada then
    local furnitureData = HomeProxy.Instance:FindFurnitureData(target.data.furnitureID)
    if furnitureData and furnitureData.woodType == EWOODTYPE.EWOODTYPE_SPEC_MONSTER then
      natureLevel = self.data.natureLv
    end
  end
  if not natureLevel and creatureId then
    local props = target and target.data.props
    local defAttr = props and props:GetPropByName("DefAttr"):GetValue()
    if defAttr then
      for nameEn, id in pairs(CommonFun.Nature) do
        if defAttr == id then
          natureIcon = nameEn
          break
        end
      end
      natureLevel = CommonFun.GetUserDefLevel(target.data, defAttr)
    end
  end
  natureIcon = natureIcon or self.data and self.data.isMonster and self.data.nature
  local isPvP, isGvG = Game.MapManager:IsPVPMode(), Game.MapManager:IsInGVG()
  local showAttr = target and target.data and target.data:GetBuffEffectByType(BuffType.ShowDefAttr)
  if self.nature then
    if natureIcon and natureIcon ~= "" and (showAttr or not isPvP and not isGvG) then
      if self.natureLevelCell then
        local creatureId = self.data and self.data.creatureId
        if creatureId then
          self.nature.gameObject:SetActive(true)
          IconManager:SetUIIcon(natureIcon, self.nature)
          if natureLevel then
            self.natureLevelCell:SetData(natureLevel)
            self.natureLevelCell:SetColor(natureIcon)
          end
        end
      end
    else
      self.nature.gameObject:SetActive(false)
    end
  else
    self.nature.gameObject:SetActive(false)
  end
end

function TargetHeadCell:RefreshSelf(data)
  local data = data or self.data
  self.parentObj = self.gameObject.transform.parent.gameObject
  if data == nil or data:IsEmpty() then
    self.parentObj:SetActive(false)
    return
  end
  self.parentObj:SetActive(true)
  TargetHeadCell.super.RefreshSelf(self, data)
  if data.isMonster then
    self:RefreshLevelColor()
    local boss = Table_Boss[data.id]
    if boss and boss.Type == 4 then
      self:UpdateHeadBg(4)
    else
      self:UpdateHeadBg(2)
    end
    local monster = Table_Monster[data.id]
    if monster and monster.Features and monster.Features & 1024 > 0 then
      self.level.text = "Lv.???"
    end
  elseif data.camp == RoleDefines_Camp.ENEMY then
    self:UpdateHeadBg(3)
  else
    self:UpdateLevelColor(MonsterTextColorConfig.Color.N, MonsterTextColorConfig.EffectColor.N)
    self:UpdateHeadBg(2)
  end
  local headType = data:GetCustomParam("HeadType")
  if headType == MainViewHeadPage.HeadType.Pet or headType == MainViewHeadPage.HeadType.Being or headType == MainViewHeadPage.HeadType.Pippi then
    self:UpdatePetHead()
    self:UpdateHeadBg(2)
  elseif headType == MainViewHeadPage.HeadType.Boki then
    self:UpdatePetHead()
  end
  if self.hp then
    self.hp.gameObject:SetActive(headType == MainViewHeadPage.HeadType.Pet or headType == MainViewHeadPage.HeadType.Being or headType == MainViewHeadPage.HeadType.Boki or headType == MainViewHeadPage.HeadType.Pippi)
  end
  if data.isNpc or data.isPippi then
    self.level.text = ""
    self.levelObj:SetActive(false)
  else
    self.levelObj:SetActive(true)
  end
  self.cancelChoose:SetActive(headType == MainViewHeadPage.HeadType.LockTarget)
  self:RefreshPrestigeLevel()
end

function TargetHeadCell:UpdateHeadBg(headType)
  if self.headBg == nil then
    return
  end
  if headType == 3 then
    self.redFrame:SetActive(true)
  else
    self.redFrame:SetActive(false)
  end
end

function TargetHeadCell:UpdateSpecialFrame(headType)
  if headType == MainViewHeadPage.HeadType.Pet then
    self.headBg.spriteName = "new-main_bg_headframe_pet"
    self.headBg.color = LuaGeometry.GetTempColor()
  else
    self.headBg.spriteName = "new-main_bg_headframe_02"
  end
end

function TargetHeadCell:RefreshLevelColor()
  if self.data and self.data.level and self.level then
    local myself = Game.Myself
    local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL)
    local deltalv = mylv - self.data.level
    if deltalv >= MonsterTextColorConfig.Level.L then
      self:UpdateLevelColor(MonsterTextColorConfig.Color.L, MonsterTextColorConfig.EffectColor.L)
    elseif deltalv <= -1 * MonsterTextColorConfig.Level.H then
      self:UpdateLevelColor(MonsterTextColorConfig.Color.H, MonsterTextColorConfig.EffectColor.H)
    else
      self:UpdateLevelColor(MonsterTextColorConfig.Color.N, MonsterTextColorConfig.EffectColor.N)
    end
  end
end

function TargetHeadCell:RefreshPrestigeLevel()
  local mapConfig = GameConfig.Prestige.ValidMap
  if not mapConfig then
    if self.prestigeGO then
      self.prestigeGO:SetActive(false)
    end
    return
  end
  local curMap = Game.MapManager:GetMapID()
  local prestigeVersion = mapConfig[curMap]
  if not prestigeVersion then
    if self.prestigeGO then
      self.prestigeGO:SetActive(false)
    end
    return
  end
  if self.data and self.data.prestigeLevel and self.data.prestigeLevel > 0 then
    if self.prestigeGO then
      self.prestigeGO:SetActive(true)
    end
    self.prestigeBg.CurrentState = prestigeVersion - 1
    self.prestigeLevel.text = self.data.prestigeLevel
    self.prestigeLevel.effectColor = _PrestigeOutlineColor[prestigeVersion]
  elseif self.prestigeGO then
    self.prestigeGO:SetActive(false)
  end
end

function TargetHeadCell:UpdateLevelColor(levelColor, levelEffectColor)
  if self._levelColor == levelColor and self._levelEffectColor == levelEffectColor then
    return
  end
  self._levelColor = levelColor
  self._levelEffectColor = levelEffectColor
  self.level.color = self._levelColor
  self.level.effectColor = self._levelEffectColor
end

function TargetHeadCell:UpdatePetHead()
  self:UpdateRestTip(self.data:GetCustomParam("relivetime"))
  self:UpdateHp()
end

function TargetHeadCell:UpdateRestTip(resttime)
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  resttime = resttime or 0
  local curtime = ServerTime.CurServerTime() / 1000
  local restSec = resttime - curtime
  if 0 < restSec then
    self.restTip:SetActive(true)
    if not self.restTimeTick then
      self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self, 1111)
    end
    self:SetIconActive(false)
    self.name.gameObject:SetActive(false)
    if self.hp then
      self.hp.gameObject:SetActive(false)
    end
  else
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    if self.hp then
      self.hp.gameObject:SetActive(true)
    end
  end
end

function TargetHeadCell:UpdateRestTime()
  if type(self.data) ~= "table" then
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
    return
  end
  local resttime = self.data and self.data:GetCustomParam("relivetime")
  resttime = resttime or 0
  local restSec = resttime - ServerTime.CurServerTime() / 1000
  if 0 < restSec then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restSec)
    self.restTime.text = string.format(ZhString.TMInfoCell_RestTip, min, sec)
  else
    self:RemoveRestTimeTick()
  end
end

function TargetHeadCell:RemoveRestTimeTick()
  if self.restTimeTick then
    TimeTickManager.Me():ClearTick(self, 1111)
    self.restTimeTick = nil
    self.restTime.text = ""
  end
  if self.data and self.data.offline ~= true then
    self:SetIconActive(true, true)
  else
    self:SetIconActive(false, false)
  end
  self.name.gameObject:SetActive(true)
end

function TargetHeadCell:UpdateHp()
  if self.data == nil then
    return
  end
  local headType = self.data:GetCustomParam("HeadType")
  if headType ~= MainViewHeadPage.HeadType.Pet and headType ~= MainViewHeadPage.HeadType.Being and headType ~= MainViewHeadPage.HeadType.Boki and headType ~= MainViewHeadPage.HeadType.Pippi then
    return
  end
  local npet = NScenePetProxy.Instance:Find(self.data.guid)
  if npet then
    local props = npet.data.props
    if props then
      local hp = props:GetPropByName("Hp"):GetValue()
      local maxhp = props:GetPropByName("MaxHp"):GetValue()
      self.data.hp = hp / maxhp
      if headType == MainViewHeadPage.HeadType.Boki then
        self:SetIconActive(0 ~= hp, 0 ~= hp)
      end
    end
  else
    self.data.hp = 0
    if headType == MainViewHeadPage.HeadType.Pippi then
      local pippi_state = self.data:GetCustomParam("pippi_state")
      self:SetIconActive(pippi_state ~= 2 or pippi_state ~= 3, false)
    else
      self:SetIconActive(false, false)
    end
  end
  TargetHeadCell.super.UpdateHp(self, self.data.hp)
end

function TargetHeadCell:SetIconActive(b1, b2)
  TargetHeadCell.super.SetIconActive(self, b1, b2)
end

function TargetHeadCell:ClearResistanceTick()
  if self.resistanceTick then
    TimeTickManager.Me():ClearTick(self, 121)
    self.resistanceTick = nil
  end
end

local MaxResistanceVal = GameConfig.MonsterControl.AttributeBar and GameConfig.MonsterControl.AttributeBar.MaxValue or 120

function TargetHeadCell:SetResistanceValue(creature)
  if not self.resistanceSlider or not creature then
    return
  end
  self:ClearResistanceTick()
  if creature.data and creature.data.staticData and creature.data.staticData.AttributeBar then
  else
    self.resistanceSlider.value = 0
    return
  end
  local value, speed = creature.data:GetAttributeValue()
  if not value or not speed then
    self.resistanceSlider.value = 0
    return
  end
  if speed < 0 or value == MaxResistanceVal then
    self.resistanceFg1.fillAmount = math.clamp(value / MaxResistanceVal, 0, 1)
    self.resistanceFg2.fillAmount = 0
    self.resistanceSlider.foregroundWidget = self.resistanceFg1
  else
    self.resistanceFg1.fillAmount = 0
    self.resistanceFg2.fillAmount = math.clamp(value / MaxResistanceVal, 0, 1)
    self.resistanceSlider.foregroundWidget = self.resistanceFg2
  end
  self.resistanceSlider.value = math.clamp(value / MaxResistanceVal, 0, 1)
  if speed < 0 and 0 <= value or 0 < speed and value <= MaxResistanceVal then
    self.resistanceTick = TimeTickManager.Me():CreateTick(0, 33, function(owner, deltatime)
      if not creature or not creature.data then
        self:ClearResistanceTick()
        return
      end
      value, speed = creature.data:GetAttributeValue()
      if not value or not speed then
        self.resistanceSlider.value = 0
        return
      end
      if speed < 0 and value <= 0 then
        self.resistanceSlider.value = 0
        self:ClearResistanceTick()
      elseif 0 < speed and value >= MaxResistanceVal then
        self.resistanceFg1.fillAmount = 1
        self.resistanceFg2.fillAmount = 0
        self.resistanceSlider.foregroundWidget = self.resistanceFg1
        self.resistanceSlider.value = 1
        self:ClearResistanceTick()
      else
        self.resistanceSlider.value = math.clamp(value / MaxResistanceVal, 0, 1)
      end
    end, self, 121)
  end
end

function TargetHeadCell:OnCellDestroy()
  self:ClearResistanceTick()
end
