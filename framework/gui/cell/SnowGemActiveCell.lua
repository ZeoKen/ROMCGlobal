SnowGemActiveCell = class("SnowGemActiveCell", BaseCell)

function SnowGemActiveCell:Init()
  SnowGemActiveCell.super.Init(self)
  self:FindObjs()
end

function SnowGemActiveCell:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
  self.icon = self:FindComponent("Icon", UISprite)
  self.levelBG = self:FindGO("LevelBG")
  if self.levelBG then
    self.levelLabel = self:FindComponent("Level", UILabel, self.levelBG)
  end
  self.starGridGO = self:FindGO("StarGrid")
  self.starGrid = self.starGridGO:GetComponent(UIGrid)
  if self.starGrid then
    self.stars = {}
    for i = 1, 5 do
      local star = self:FindGO("Star" .. i, self.starGridGO)
      if star then
        self.stars[i] = star
      end
    end
  end
end

function SnowGemActiveCell:SetData(data)
  self.data = data
  if not (data and data.id) or data.id <= 0 then
    self:HideCell()
    return
  end
  self:ShowCell()
  self:SetIcon(data.id)
  self:SetLevel(data.level or 1)
  self:SetStarLevel(data.starLevel or 0)
end

function SnowGemActiveCell:HideCell()
  if self.gameObject then
    self.gameObject:SetActive(false)
  end
end

function SnowGemActiveCell:ShowCell()
  if self.gameObject then
    self.gameObject:SetActive(true)
  end
end

function SnowGemActiveCell:SetIcon(itemId)
  if not self.icon or not itemId then
    return
  end
  local itemConfig = Table_Item[itemId]
  if itemConfig and itemConfig.Icon then
    IconManager:SetItemIcon(itemConfig.Icon, self.icon)
    self.icon:MakePixelPerfect()
  else
    IconManager:SetItemIconById(itemId, self.icon)
    self.icon:MakePixelPerfect()
  end
end

function SnowGemActiveCell:SetLevel(level)
  if not self.levelLabel then
    return
  end
  self.levelLabel.text = tostring(level or 1)
end

function SnowGemActiveCell:SetStarLevel(starLevel)
  if not self.stars then
    return
  end
  starLevel = starLevel or 0
  for i = 1, 5 do
    if self.stars[i] then
      self.stars[i]:SetActive(i <= starLevel)
    end
  end
  self.starGrid:Reposition()
end

function SnowGemActiveCell:GetData()
  return self.data
end

function SnowGemActiveCell:ClearData()
  self.data = nil
  self:HideCell()
  self:ClearEffect()
end

function SnowGemActiveCell:SetEquipRefineLv(refineLv)
  if not self.effectContainer then
    return
  end
  refineLv = refineLv or 0
  self:ClearEffect()
  if 10 <= refineLv then
    self.slotEffect = self:PlayUIEffect(EffectMap.UI.SnowGem_SlotGrade2, self.effectContainer)
  elseif 5 <= refineLv then
    self.slotEffect = self:PlayUIEffect(EffectMap.UI.SnowGem_SlotGrade1, self.effectContainer)
  end
end

function SnowGemActiveCell:ClearEffect()
  if self.slotEffect and self.slotEffect:Alive() then
    self.slotEffect:Destroy()
  end
  self.slotEffect = nil
end
