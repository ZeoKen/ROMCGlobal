DifficultyPathNodeCell = class("DifficultyPathNodeCell", BaseCell)
DifficultyPathNodeCell.LevelIndex = {
  "Ⅰ",
  "Ⅱ",
  "Ⅲ",
  "Ⅳ",
  "Ⅴ",
  "Ⅵ",
  "Ⅶ",
  "Ⅷ",
  "Ⅸ",
  "Ⅹ",
  "Ⅺ",
  "Ⅻ"
}

function DifficultyPathNodeCell:ctor(prefab, parent)
  local go = self:LoadPrefab(prefab, parent)
  DifficultyPathNodeCell.super.ctor(self, go)
end

function DifficultyPathNodeCell:LoadPrefab(prefab, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(prefab))
  if cellpfb == nil then
    error("can not find cellpfb" .. prefab)
  end
  cellpfb.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionGO(cellpfb, 0, 0, 0)
  return cellpfb
end

function DifficultyPathNodeCell:Init()
  self:FindObjs()
end

function DifficultyPathNodeCell:FindObjs()
  self:AddCellClickEvent()
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.lock = self:FindGO("Lock")
  self.indexLabel = self:FindComponent("Index", UILabel)
  self.selectGO = self:FindGO("Select")
end

function DifficultyPathNodeCell:SetData(data)
  self.data = data
  if data then
    self.pvePassInfo = data.pvePassInfo
    self.level = data.level
    self.indexLabel.text = DifficultyPathNodeCell.LevelIndex[self.level]
    self.starCount = self.pvePassInfo:GetHeroRoadStarCount()
    self.bg.CurrentState = data.isUnlocked and 1 or 0
    self.lock:SetActive(not data.isUnlocked)
    local diffRaidId = self.pvePassInfo.staticEntranceData.difficultyRaid
    local mapConfig = Table_Map[diffRaidId]
    if mapConfig then
      self.name = mapConfig.NameZh
    end
  end
end

function DifficultyPathNodeCell:SetSelectState(selected)
  self.selectGO:SetActive(selected or false)
end

function DifficultyPathNodeCell:SetPos(pos)
  if pos then
    LuaGameObject.SetLocalPositionGO(self.gameObject, pos[1], pos[2], 0)
  end
end

function DifficultyPathNodeCell:GetPos()
  return self.gameObject.transform.position
end
