local BaseCell = autoImport("BaseCell")
GvGHolyCell = class("GvGHolyCell", BaseCell)
local csv = GameConfig.GvGPvP_PrayType

function GvGHolyCell:Init()
  self.bg = self:FindComponent("Bg", UISprite)
  self.attriBg = self:FindComponent("AttriBg", UISprite)
  self.level = self:FindComponent("Level", UILabel)
  self.attLab = self:FindComponent("attLab", UILabel)
  self.costImg = self:FindComponent("Cost", UISprite)
  self.costNum = self:FindComponent("CostLab", UILabel, self.costImg.gameObject)
  self.costImg2 = self:FindComponent("Cost2", UISprite)
  self.costNum2 = self:FindComponent("CostLab", UILabel, self.costImg2.gameObject)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddCellClickEvent()
  self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex)
end

function GvGHolyCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  local colorID = data.staticData.ColorID
  if colorID then
    local colorCfg = Table_GFaithUIColorConfig[colorID]
    if colorCfg then
      local hasc, rc = ColorUtil.TryParseHexString(colorCfg.levelEffect_Color)
      self.level.effectColor = rc
      local hasc, rc = ColorUtil.TryParseHexString(colorCfg.iconBg_Color)
      self.attriBg.color = rc
    end
  end
  if not data.nextPray or 0 == data.nextPray.lv then
    self.level.text = data.curPray.lv
    self.attLab.text = data.curPray.staticData.AttrName
    local cost = data.curPray.itemCost
    self:Hide(self.costNum)
    IconManager:SetItemIcon(cost.staticData.Icon, self.costImg)
    cost = data.curPray.itemCost2
    IconManager:SetItemIcon(cost.staticData.Icon, self.costImg2)
    self:Hide(self.costNum2)
  else
    self.level.text = data.curPray.lv
    self.attLab.text = data.nextPray.staticData.AttrName
    local cost = data.nextPray.itemCost
    IconManager:SetItemIcon(cost.staticData.Icon, self.costImg)
    self:Show(self.costNum)
    self.costNum.text = cost.num
    cost = data.nextPray.itemCost2
    IconManager:SetItemIcon(cost.staticData.Icon, self.costImg2)
    self:Show(self.costNum2)
    self.costNum2.text = cost.num
  end
  self:UpdateChoose()
end

function GvGHolyCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function GvGHolyCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end

function GvGHolyCell:PlayPrayEffect()
  self:PlayUIEffect(EffectMap.UI.GodlessBlessing, self.effectBg.gameObject, true, GvGHolyCell.PrayEffectHandle, self)
end

function GvGHolyCell.PrayEffectHandle(effectHandle, owner)
  if effectHandle and not LuaGameObject.ObjectIsNull(effectHandle.gameObject) then
    owner.effectBg:AddChild(effectHandle.gameObject)
  end
end
