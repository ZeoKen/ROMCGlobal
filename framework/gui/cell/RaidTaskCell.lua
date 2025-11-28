local baseCell = autoImport("BaseCell")
RaidTaskCell = class("RaidTaskCell", baseCell)
autoImport("QuestData")
local tempVector3 = LuaVector3.Zero()
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull

function RaidTaskCell:Init()
  self:initView()
  self:initData()
end

function RaidTaskCell:initData()
  self.bgSizeChanged = false
end

function RaidTaskCell:initView()
  self.content = self:FindGO("content")
  self.TitleCt = self:FindGO("TitleCt", self.content)
  self.TitleIcon = self:FindGO("TitleIcon")
  if self.TitleIcon then
    self.TitleIcon_UISprite = self.TitleIcon:GetComponent(UISprite)
  end
  self.title = self:FindComponent("CNTitle", UILabel)
  self.titleTrans = self.title.gameObject.transform
  self.desc = self:FindComponent("Desc", UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20)
  self.bgSprite = self:FindComponent("bg", UISprite)
  self.disLabel = self:FindComponent("currentDisLb", UILabel)
  self.selectorSp = self:FindGO("selector"):GetComponent(UISprite)
  local click = function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end
  self:SetEvent(self.bgSprite.gameObject, click)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    self:resetBgSize()
  end
  
  self.disObj = self.disLabel.gameObject
  self.disObjTrans = self.disObj.transform
  self.richObjTrans = self.desc.richLabel.gameObject.transform
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  local frame = self:FindGO("frame")
  if frame then
    frame:SetActive(false)
  end
end

function RaidTaskCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  local name = ZhString.TaskQuestCell_TracingTarget
  local desStr = data:parseTranceInfo()
  self.title.text = name
  self.desc:SetText(desStr)
  self:ShowTaskIcon()
  self:resetBgSize()
end

function RaidTaskCell:ShowTaskIcon()
  local atlasStr = "Effect"
  local iconScale = 0.85
  local spriteNameStr = "new-main_icon_copy"
  if IconManager:SetIconByType(spriteNameStr, self.TitleIcon_UISprite, atlasStr) then
    self:SetTitleIcon(true)
    self.TitleIcon_UISprite:MakePixelPerfect()
    if iconScale then
      self.TitleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
    elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
      self.TitleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
    end
    return
  end
  local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
  if ui1Atlas then
    self.TitleIcon_UISprite.atlas = ui1Atlas
    self.TitleIcon_UISprite.spriteName = spriteNameStr
    self:SetTitleIcon(true)
    self.TitleIcon_UISprite:MakePixelPerfect()
    if iconScale then
      self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
      self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
    end
    return
  end
  self:SetTitleIcon(false)
end

function RaidTaskCell:SetTitleIcon(bool)
  if bool then
    self:Show(self.TitleIcon)
  else
    self:Hide(self.TitleIcon)
  end
end

function RaidTaskCell:resetBgSize()
  self.bgSizeChanged = false
  if not self.disLabel then
    return
  end
  if not self.disObj then
    return
  end
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.disObjTrans))
  local _, y, _ = getlocalPos(self.richObjTrans)
  local deshg = self.desc.richLabel.height
  y = y - deshg - 14
  tempVector3[2] = y
  self.disObjTrans.localPosition = tempVector3
  local height = calSize(self.content.transform)
  height = height.size.y
  height = height + 4
  local originHeight = self.bgSprite.height
  if 2 < math.abs(originHeight - height) then
    self.bgSizeChanged = true
  end
  self.bgSprite.height = height
  height = height + 8
  self.selectorSp.height = height + 25
end

function RaidTaskCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
  self.selectorSp.color = bool and Color(1, 1, 1, 1) or Color(1, 1, 1, 0.00392156862745098)
end

function RaidTaskCell:OnExit()
  if self.data then
    FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
  end
  self.type = nil
  RaidTaskCell.super.OnExit(self)
end
