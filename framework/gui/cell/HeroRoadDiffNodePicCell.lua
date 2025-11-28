HeroRoadDiffNodePicCell = class("HeroRoadDiffNodePicCell", BaseCell)
local LockedBgName = "hero3_bg_pic_null"

function HeroRoadDiffNodePicCell:ctor(prefab, parent)
  local go = self:LoadPrefab(prefab, parent)
  HeroRoadDiffNodePicCell.super.ctor(self, go)
end

function HeroRoadDiffNodePicCell:LoadPrefab(prefab, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(prefab))
  if cellpfb == nil then
    error("can not find cellpfb" .. prefab)
  end
  cellpfb.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionGO(cellpfb, 0, 0, 0)
  return cellpfb
end

function HeroRoadDiffNodePicCell:Init()
  self:InitData()
  self:FindObjs()
end

function HeroRoadDiffNodePicCell:InitData()
  self.lockedBgName = LockedBgName
end

function HeroRoadDiffNodePicCell:FindObjs()
  self:AddCellClickEvent()
  self.bgTex = self.gameObject:GetComponent(UITexture)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.stars = {}
  for i = 1, 3 do
    self.stars[i] = self:FindComponent("Star" .. i, UIMultiSprite)
  end
end

function HeroRoadDiffNodePicCell:SetData(data)
  self.data = data
  if data then
    self.pvePassInfo = data.pvePassInfo
    self.level = data.level
    self.id = self.pvePassInfo.id
    local starCount = self.pvePassInfo:GetHeroRoadStarCount()
    for i = 1, #self.stars do
      if i <= starCount then
        self.stars[i].CurrentState = 1
      else
        self.stars[i].CurrentState = 0
      end
    end
    local config = Table_HeroJourneyNode[self.id]
    local bgName = self.pvePassInfo:CheckAccPass() and config and config.Picture or self.lockedBgName
    if self.bgName ~= bgName then
      if not StringUtil.IsEmpty(self.bgName) then
        PictureManager.Instance:UnloadHeroRoadTexture(self.bgName, self.bgTex)
      end
      if not StringUtil.IsEmpty(bgName) then
        PictureManager.Instance:SetHeroRoadTexture(bgName, self.bgTex)
        self.bgTex:MakePixelPerfect()
      end
      self.bgName = bgName
    end
    local diffRaidId = self.pvePassInfo.staticEntranceData.difficultyRaid
    local mapConfig = Table_Map[diffRaidId]
    self.name = mapConfig and mapConfig.NameZh or ""
    self.nameLabel.text = self.pvePassInfo:CheckAccPass() and config and config.PictureName or ZhString.HeroRoad_Locked
  end
end

function HeroRoadDiffNodePicCell:SetPos(pos)
  if pos then
    LuaGameObject.SetLocalPositionGO(self.gameObject, pos[1], pos[2], 0)
  end
end

function HeroRoadDiffNodePicCell:OnCellDestroy()
  if not StringUtil.IsEmpty(self.bgName) then
    PictureManager.Instance:UnloadHeroRoadTexture(self.bgName, self.bgTex)
  end
end

HeroRoadDiffNodeSpecPicCell = class("HeroRoadDiffNodeSpecPicCell", HeroRoadDiffNodePicCell)
local LockedBgName_Spec = "hero3_bg_pic_nulls"

function HeroRoadDiffNodeSpecPicCell:InitData()
  self.lockedBgName = LockedBgName_Spec
end
