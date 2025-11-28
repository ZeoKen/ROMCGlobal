IconManager = {}
autoImport("UIAtlasConfig")
autoImport("ItemAtlasConfig")
autoImport("PictureManager")
IconManager.Client_Icon_Atlas = {
  ArtFont = {
    "GUI/atlas/preferb/UI_ArtFonts"
  }
}

function IconManager:Init()
  PictureManager.new()
end

function IconManager:SetNpcMonsterIconByID(id, sprite)
  id = tonumber(id)
  local data = Table_Npc[id] or Table_Monster[id]
  if data then
    return self:SetFaceIcon(data.Icon, sprite)
  end
end

function IconManager:SetUIIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.uiicon)
end

function IconManager:SetItemIconById(itemId, sprite)
  local itemConfig = Table_Item[itemId]
  if itemConfig then
    self:SetItemIcon(itemConfig.Icon, sprite)
  end
end

function IconManager:SetItemIcon(sName, sprite)
  local index = StringUtil.GetNumberInString(sName)
  local success = false
  local l_config = ItemAtlasConfig
  if not l_config then
    LogUtility.Error("没有找到ItemAtlasConfig!")
    return false
  end
  if index then
    local found = false
    for i = 1, #l_config do
      if index < l_config[i].StartIndex then
        found = true
        if 1 < i then
          success = self:SetIcon(sName, sprite, l_config[i - 1].Atlas)
          if not success and 2 < i and l_config[i - 1].StartIndex == index then
            success = self:SetIcon(sName, sprite, l_config[i - 2].Atlas)
          end
          break
        end
        LogUtility.Error(string.format("设置Icon: %s时，找到index为%s，但index的最小值为%s，icon设置失败并回滚到旧版", sName, index, l_config[1].StartIndex))
        success = self:SetIcon(sName, sprite, l_config.All)
        break
      end
    end
    if not found and 0 < #l_config then
      success = self:SetIcon(sName, sprite, l_config[#l_config].Atlas)
    end
  else
    success = self:SetIcon(sName, sprite, l_config.Special)
  end
  if not success and not BranchMgr.IsChina() and UIAtlasConfig.IconAtlas.OverseaItem then
    success = self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.OverseaItem)
  end
  if not success and ApplicationInfo.IsRunOnEditor() and UIAtlasConfig.IconAtlas.EditorItem then
    success = self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.EditorItem)
  end
  return success
end

function IconManager:SetSkillIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.Skill)
end

local skillAtlasName = {}

function IconManager:SetSkillIconByProfess(sName, sprite, professType, rollBackFindAll)
  local atlas = skillAtlasName[professType]
  if atlas == nil then
    atlas = UIAtlasConfig.IconAtlas["SkillProfess_" .. professType]
    skillAtlasName[professType] = atlas
  end
  local res = self:SetIcon(sName, sprite, atlas)
  if not res and rollBackFindAll then
    res = self:SetSkillIcon(sName, sprite)
  end
  return res
end

function IconManager:SetKeyIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.keyword)
end

function IconManager:SetActionIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.Action)
end

function IconManager:SetMapIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.Map)
end

function IconManager:SetEffectIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.Effect)
end

function IconManager:SetProfessionIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.career)
end

function IconManager:SetNewProfessionIcon(sName, sprite)
  if IconManager:SetProfessionIcon("new_" .. sName, sprite) then
    return true
  else
    return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.career)
  end
end

function IconManager:SetBodyIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.body)
end

function IconManager:SetFaceIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.face)
end

function IconManager:SetFrameIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.frame)
end

function IconManager:SetHairStyleIcon(sName, sprite)
  return self:SetItemIcon(sName, sprite)
end

function IconManager:SetGuildIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.guild)
end

function IconManager:SetHeadAccessoryFrontIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadAccessoryFront)
end

function IconManager:SetHeadAccessoryBackIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadAccessoryBack)
end

function IconManager:SetHeadFaceMouthIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadFaceMouth)
end

function IconManager:SetEyeIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadEye)
end

function IconManager:SetPuzzleIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.puzzle)
end

function IconManager:SetHomeBuildingIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HomeBuilding)
end

function IconManager:SetArtFontIcon(sName, sprite)
  return self:SetIcon(sName, sprite, IconManager.Client_Icon_Atlas.ArtFont)
end

function IconManager:SetZenyShopItem(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.ZenyShopItem)
end

function IconManager:SetLotteryIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.NewLottery)
end

function IconManager:SetMountFashionIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.MountFashion)
end

function IconManager:SetChapterIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.ChapterIcon)
end

local AtlasCache = {}

function IconManager:GetAtlasByType(type)
  if not type then
    redlog("Cannot find atlas config!")
    return
  end
  local atlases = AtlasCache[type]
  if atlases ~= nil then
    return atlases
  end
  atlases = {}
  for k, v in pairs(type) do
    local atlasObj
    if not BranchMgr.IsChina() then
      local rID = OverSea.LangManager.Instance():PathWithLanguage(v .. ".prefab")
      rID = string.gsub(rID, "\\", "/")
      rID = string.sub(rID, 18, string.len(rID) - 7)
      if ResourceManager.Instance:ExistAssets(rID, "resources/", "") then
        atlasObj = ResourceManager.Instance:SLoad(rID)
      end
    end
    atlasObj = atlasObj or ResourceManager.Instance:SLoad(v)
    if atlasObj ~= nil then
      atlases[k] = atlasObj:GetComponent(UIAtlas)
    else
      print("can not find atlas " .. tostring(v))
    end
  end
  AtlasCache[type] = atlases
  return atlases
end

local IsNull = Slua.IsNull

function IconManager.ClearAtlasCaches()
  for atlasType, atlases in pairs(AtlasCache) do
    for k, atlas in pairs(atlases) do
      ResourceManager.Instance:SUnLoad(atlasType[k], false)
    end
  end
  AtlasCache = {}
end

function IconManager:SetIconByType(sName, sprite, atlasTypeName, defaultTypeName)
  if atlasTypeName == "Item" or atlasTypeName == "hairStyle" then
    return self:SetItemIcon(sName, sprite)
  else
    local atlasType = UIAtlasConfig.IconAtlas[atlasTypeName] or UIAtlasConfig.IconAtlas[defaultTypeName]
    if atlasType then
      return self:SetIcon(sName, sprite, atlasType)
    else
    end
  end
  return false
end

function IconManager:SetIcon(sName, sprite, atlasType)
  sName = tostring(sName)
  local atlases = self:GetAtlasByType(atlasType)
  if atlases ~= nil then
    for k, v in pairs(atlases) do
      local getSData = v:GetSprite(sName)
      if getSData ~= nil and sprite ~= nil then
        sprite.atlas = v
        sprite.spriteName = sName
        return true
      else
      end
    end
  end
  return false
end

function IconManager:SetMoneyIcon(moneyType, sprite)
  if moneyType and sprite then
    local item = ItemData.new(0, 100)
    if moneyType == ProtoCommon_pb.EMONEYTYPE_DIAMOND then
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_SILVER then
      item = ItemData.new(0, 100)
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_GOLD then
      item = ItemData.new(0, 105)
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_GARDEN then
      item = ItemData.new(0, 110)
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_LABORATORY then
      item = ItemData.new(0, 115)
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP then
      item = ItemData.new(0, 147)
    elseif moneyType == ProtoCommon_pb.EMONEYTYPE_BATTLEPASS then
      item = ItemData.new(0, 5841)
    end
    IconManager:SetItemIcon(item.staticData.Icon, sprite)
  end
end

function IconManager:SetPetMountIcon(itemData, sprite)
  if not itemData or not itemData.staticData then
    return
  end
  local sIcon = GameConfig.Pet.PetMountIcon[itemData.staticData.id] or itemData.staticData.Icon
  local setSuc = self:SetItemIcon(sIcon, sprite)
  setSuc = setSuc or self:SetItemIcon("item_45001", sprite)
  sprite:MakePixelPerfect()
  return setSuc
end

function IconManager:SetAvatarIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.AvatarBox)
end

function IconManager:SetColorFillingIcon(sName, sprite)
  return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.ColorFilling)
end

function IconManager:FitAspect(sprite)
  if not sprite then
    return
  end
  local height = sprite.height
  local pixelSize = sprite.pixelSize
  local sp = sprite:GetAtlasSprite()
  local x = pixelSize * (sp.width + sp.paddingLeft + sp.paddingRight)
  local y = pixelSize * (sp.height + sp.paddingTop + sp.paddingBottom)
  sprite.width = height * x / y
end

IconManager:Init()
