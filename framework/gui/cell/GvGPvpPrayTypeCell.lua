local BaseCell = autoImport("BaseCell")
GvGPvpPrayTypeCell = class("GvGPvpPrayTypeCell", BaseCell)
local csv = GameConfig.GvGPvP_PrayType

function GvGPvpPrayTypeCell:Init()
  self.bg = self:FindComponent("Bg", UISprite)
  self.attriBg = self:FindComponent("AttriBg", UISprite)
  self.level = self:FindComponent("Level", UILabel)
  self.attLab = self:FindComponent("attLab", UILabel)
  self.costImg = self:FindComponent("Cost", UISprite)
  self.costNum = self:FindComponent("CostLab", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.maxFlag = self:FindGO("MaxFlag")
  self:AddCellClickEvent()
  self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex)
end

function GvGPvpPrayTypeCell:_setColor(colorID)
  if not colorID then
    return
  end
  local config = Table_GFaithUIColorConfig[colorID]
  if config then
    local _, rc = ColorUtil.TryParseHexString(config.levelEffect_Color)
    if _ then
      self.level.effectColor = rc
    end
    _, rc = ColorUtil.TryParseHexString(config.iconBg_Color)
    if _ then
      self.attriBg.color = rc
    end
  end
end

function GvGPvpPrayTypeCell:SetColor()
  if not self.data then
    return
  end
  local type = self.data.type
  if type and type <= #csv and csv[type] and csv[type].colorID then
    self:_setColor(csv[type].colorID)
  else
    local id = self.data.id
    local colorID = Table_Guild_Faith[id] and Table_Guild_Faith[id].ColorID
    self:_setColor(colorID)
  end
end

function GvGPvpPrayTypeCell:SetData(data)
  self.data = data
  if data then
    self:SetColor()
    local attr_name
    self.name = nil
    if not data.curPray or 0 == data.curPray.lv then
      self:Show(self.costImg)
      self:Hide(self.maxFlag)
      self.level.text = 0
      attr_name = data.nextPray.staticData.AttrName
      self.data.name = data.nextPray.staticData.Name
      local cost = data.nextPray.itemCost
      IconManager:SetItemIcon(cost.staticData.Icon, self.costImg)
      self.costNum.text = cost.num
    elseif data:IsMax() then
      self.level.text = data.curPray.lv
      attr_name = data.curPray.staticData.AttrName
      self.data.name = data.curPray.staticData.Name
      if data:IsRealMax() then
        self:Hide(self.costImg)
        self:Show(self.maxFlag)
      else
        self:Show(self.costImg)
        self:Hide(self.maxFlag)
        local cost = data.curPray.itemCost
        IconManager:SetItemIcon(cost.staticData.Icon, self.costImg)
        self.costNum.text = cost.num
      end
    else
      self:Show(self.costImg)
      self:Hide(self.maxFlag)
      self.level.text = data.curPray.lv
      attr_name = data.nextPray.staticData.AttrName
      self.data.name = data.nextPray.staticData.Name
      local cost = data.nextPray.itemCost
      IconManager:SetItemIcon(cost.staticData.Icon, self.costImg)
      self.costNum.text = cost.num
    end
    self:UpdateChoose()
    self:SetName(attr_name)
  end
end

function GvGPvpPrayTypeCell:SetName(name)
  self.attLab.text = name
end

function GvGPvpPrayTypeCell:SetChoose(value)
  if type(value) == "number" then
    self.chooseId = value
    self:UpdateChoose()
  elseif type(value) == "boolean" then
    self:ForceActive(value)
  end
end

function GvGPvpPrayTypeCell:ForceActive(var)
  if var then
    self.chooseSymbol:SetActive(true)
    self.chooseId = self.data.id
  else
    self.chooseSymbol:SetActive(false)
    self.chooseId = nil
  end
end

function GvGPvpPrayTypeCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end

function GvGPvpPrayTypeCell:PlayPrayEffect()
  local effectName
  if self.data and GuildPrayProxy.Instance:IsGvgPvpType(self.data.type) then
    effectName = EffectMap.UI.GodlessBlessing_long
  else
    effectName = EffectMap.UI.GodlessBlessing
  end
  self:PlayUIEffect(effectName, self.effectBg.gameObject, true, GvGPvpPrayTypeCell.PrayEffectHandle, self)
end

function GvGPvpPrayTypeCell.PrayEffectHandle(effectHandle, owner)
  if effectHandle and not LuaGameObject.ObjectIsNull(effectHandle.gameObject) then
    owner.effectBg:AddChild(effectHandle.gameObject)
  end
end
