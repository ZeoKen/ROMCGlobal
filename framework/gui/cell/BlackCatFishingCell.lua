local BaseCell = autoImport("BaseCell")
BlackCatFishingCell = class("BlackCatFishingCell", BaseCell)
local _PrefixOfTexture = "Sevenroyalfamilies_card_0"
local _UnChooseSizeRidio = 0.95
local _CenterIndex = 2
local _TempVector3 = LuaVector3.Zero()
local _BuffStaticData, _AssetEffectStaticData
local _cfg = GameConfig.FishingBuff and GameConfig.FishingBuff.Probability
local _cfgIcon = GameConfig.FishingBuff and GameConfig.FishingBuff.Icon
local _LabEffColor = {
  [1] = "3d552f",
  [2] = "224662",
  [3] = "5e5381"
}

function BlackCatFishingCell:Init()
  self:FindObjs()
end

function BlackCatFishingCell:FindObjs()
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.nameLab.text = ""
  self.descLab.text = ""
end

function BlackCatFishingCell:SetData(id, i)
  self.sort = i
  self.index = Game.Config_FishingBuff[id] or 1
  local _, c = ColorUtil.TryParseHexString(_LabEffColor[self.index])
  self.descLab.effectColor = c
  self.texName = _PrefixOfTexture .. tostring(self.index)
  PictureManager.Instance:SetUI(self.texName, self.bgTex)
  self.id = id
  if not id then
    return
  end
  _BuffStaticData = Table_Buffer[id]
  if not _BuffStaticData then
    redlog("检查配置，客户端Buff表 未找到ID :", id)
    return
  end
  if not StringUtil.IsEmpty(_BuffStaticData.BuffName) then
    self.nameLab.text = OverSea.LangManager.Instance():GetLangByKey(_BuffStaticData.BuffName)
  end
  if _cfgIcon then
    IconManager:SetSkillIcon(_cfgIcon[id], self.icon)
  end
  if not StringUtil.IsEmpty(_BuffStaticData.BuffDesc) then
    self.descLab.text = OverSea.LangManager.Instance():GetLangByKey(_BuffStaticData.BuffDesc)
  end
end

function BlackCatFishingCell:AllowTransformAnimation()
  return self.sort and self.sort ~= _CenterIndex
end

function BlackCatFishingCell:OnChoosed(id)
  if self.id and self.id == id then
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  else
    LuaVector3.Better_Set(_TempVector3, _UnChooseSizeRidio, _UnChooseSizeRidio, _UnChooseSizeRidio)
    self.gameObject.transform.localScale = _TempVector3
  end
end

function BlackCatFishingCell:OnCellDestroy()
  if self.texName then
    PictureManager.Instance:UnLoadUI(self.texName, self.bgTex)
  end
  BlackCatFishingCell.super.OnCellDestroy(self)
end
