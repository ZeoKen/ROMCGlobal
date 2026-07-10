autoImport("BaseCell")
FashionStarTabCell = class("FashionStarTabCell", BaseCell)

function FashionStarTabCell:Init()
  self.background = self:FindComponent("Bg", UISprite)
  self.starLabelComp = self:FindComponent("StarLabel", UILabel)
  self.nameLabelComp = self:FindComponent("ContentLab", UILabel)
  self.lockIcon = self:FindGO("Lock")
  self.toggleComp = self.background.gameObject:GetComponent(UIToggle)
  self.isSelected = false
  self:SetEvent(self.background.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function FashionStarTabCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  self:UpdateDisplay()
end

function FashionStarTabCell:UpdateDisplay()
  if not self.data then
    return
  end
  local staticData = Table_FashionStar[self.data]
  if not staticData then
    return
  end
  self.batchId = staticData.BatchId
  self.star = staticData.Star
  self.starLabelComp.text = tostring(self.star)
  self.nameLabelComp.text = staticData.Desc
  self:UpdateLockState()
end

function FashionStarTabCell:UpdateLockState()
  if not self.data then
    return
  end
  local unlockedStar = FashionStarProxy.Instance:GetUnlockedStar(self.batchId)
  self.lockIcon:SetActive(not unlockedStar or unlockedStar < self.star)
end

local _SelectConfig = {
  Select = {
    atlas = "NewUI11",
    spriteName = "fashion_btn_02",
    Color = "593613",
    fontSize = 26,
    effectStyle = UILabel.Effect.None
  },
  UnSelect = {
    atlas = "NewUI11",
    spriteName = "fashion_btn_01",
    Color = "FFFFFF",
    EffectColor = "455FAE",
    fontSize = 26,
    effectStyle = UILabel.Effect.Outline
  }
}
local _SmallSelectConfig = {
  Select = {
    atlas = "NewUI10",
    spriteName = "sports_btn_liang",
    Color = "593613",
    fontSize = 22,
    effectStyle = UILabel.Effect.None
  },
  UnSelect = {
    atlas = "NewUI10",
    spriteName = "sports_btn_an",
    Color = "FFFFFF",
    EffectColor = "455FAE",
    fontSize = 22,
    effectStyle = UILabel.Effect.Outline
  }
}

function FashionStarTabCell:SetSelected(selected)
  self.isSelected = selected
  self.toggleComp.value = selected
  local selectConfig = self.star == 7 and _SelectConfig or _SmallSelectConfig
  local config = selectConfig[selected and "Select" or "UnSelect"]
  self.background.atlas = RO.AtlasMap.GetAtlas(config.atlas)
  self.background.spriteName = config.spriteName
  self.background.height = self.star == 7 and 120 or 69
  local result, c = ColorUtil.TryParseHexString(config.Color)
  if result then
    self.nameLabelComp.color = c
    self.starLabelComp.color = c
  end
  if config.EffectColor then
    result, c = ColorUtil.TryParseHexString(config.EffectColor)
    if result then
      self.nameLabelComp.effectColor = c
      self.starLabelComp.effectColor = c
    end
  end
  self.starLabelComp.fontSize = config.fontSize
  self.starLabelComp.effectStyle = config.effectStyle
end
