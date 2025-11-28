local BaseCell = autoImport("BaseCell")
MenuMsgCell = class("MenuMsgCell", BaseCell)

function MenuMsgCell:OnExit()
  self.animHelper.loopCountChangedListener = nil
end

local ExtraBgHeight = 250
local NormalBgHeight = 194
local ExtraInnerBgHeight = 132
local NormalInnerBgHeight = 84

function MenuMsgCell:Init()
  self:InitUI()
end

function MenuMsgCell:InitUI()
  self.bg = self:FindComponent("Bg", UISprite)
  self.innerBg = self:FindComponent("InnerBg", UISprite)
  self.tip = SpriteLabel.new(self:FindGO("MsgLabel"), nil, 50, 50, true)
  self.extraLabel = self:FindGO("ExtraLabel")
  self.extraLabel:SetActive(false)
  self.extraTip = SpriteLabel.new(self.extraLabel, nil, 30, 30, true, 0.7, "858585")
  self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
  self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.animHelper = self.animHelper.animatorHelper
  self:AddAnimatorEvent()
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("TitleEffect"), self:FindGO("EffectContainer"))
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 83.7, 0)
end

function MenuMsgCell:IsShowed()
  return self.isShowed
end

function MenuMsgCell:ResetAnim()
  self.isShowed = false
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ItemPopShowTimeLim, function(owner, deltaTime)
    self.isShowed = true
  end, self)
end

function MenuMsgCell:PlayHide()
  if self.isShowed then
    self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
  end
end

function MenuMsgCell:AddAnimatorEvent()
  function self.animHelper.loopCountChangedListener(state, oldLoopCount, newLoopCount)
    if not self.isShowed then
      self.isShowed = true
    end
  end
end

function MenuMsgCell:SetData(data)
  self.data = data
  self:ResetAnim()
  self.tip:Reset()
  local config = data.data
  if data.Type.isMenu then
    local msg = config.Tip
    if config.event and config.event.type == "scenery" then
      local _, viewindex = next(config.event.param)
      if viewindex and Table_Viewspot[viewindex] then
        local pointName = Table_Viewspot[viewindex].SpotName
        msg = string.format(msg, pointName)
      end
    end
    self.tip:SetText(msg, true)
    self:SetTitleIcon(config.Icon)
  else
    self.tip:SetText(config.text, true)
    self:SetTitleIcon(config.title)
  end
  if not StringUtil.IsEmpty(config.ExtraTip) then
    self.extraLabel:SetActive(true)
    self.extraTip:SetText(config.ExtraTip, true)
    self.bg.height = ExtraBgHeight
    self.innerBg.height = ExtraInnerBgHeight
  else
    self.extraLabel:SetActive(false)
    self.bg.height = NormalBgHeight
    self.innerBg.height = NormalInnerBgHeight
  end
  self.animHelper:Play("UnLockMsg1", 1, false)
  self:PlayUISound(AudioMap.Maps.FunctionUnlock)
end

local min = math.min
local MAX_SIZE = 100

function MenuMsgCell:SetTitleIcon(configIcon)
  local atlasStr
  local iconStr = ""
  if configIcon ~= nil then
    if type(configIcon) == "table" then
      atlasStr, iconStr = next(configIcon)
    else
      atlasStr, iconStr = MsgParserProxy.Instance:GetIconInfo(configIcon)
    end
    if atlasStr ~= nil and iconStr ~= nil then
      self:Show(self.icon)
      if atlasStr == "itemicon" then
        IconManager:SetItemIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      elseif atlasStr == "skillicon" then
        IconManager:SetSkillIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      elseif atlasStr == "mountfashion" then
        IconManager:SetMountFashionIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      else
        IconManager:SetUIIcon(iconStr, self.icon)
        self.icon:MakePixelPerfect()
      end
      self.icon.width = min(self.icon.width, MAX_SIZE)
      self.icon.height = min(self.icon.height, MAX_SIZE)
      self.icon.transform.localScale = LuaGeometry.GetTempVector3(1.3, 1.3, 1)
    else
      self:Hide(self.icon)
    end
  else
    self:Hide(self.icon)
  end
end
