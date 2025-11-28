ResourcePathHelper = {}
USE_RO_ANIMSYS = true
local PATH_PUBLIC = "Public/"
local PATH_GUI = "GUI"
local PATH_GUI_V1 = "GUI/v1/"
local PATH_GUI_pic_Model_Texture = "GUI/pic/Model/"
local PATH_EFFECT_ROOT = "Public/Effect/"
local PATH_EFFECT_COMMON = "Public/Effect/Common/"
local PATH_EFFECT_SKILL = "Public/Effect/Skill/"
local PATH_EFFECT_UI = "Public/Effect/UI/"
local PATH_EFFECT_WEATHER = "Public/Effect/Weather/"
local PATH_EFFECT_SPINE = "Public/SpineEffect/"
local PATH_EMOJI = "Public/Emoji/"
local PATH_SCENE_EMOJI = "Public/Emoji_Scene/"
local Path_RoleBody = "Role/Body/"
local Path_RoleHair = "Role/Hair/"
local Path_RoleHead = "Role/Head/"
local Path_RoleWeapon = "Role/Weapon/"
local Path_RoleWing = "Role/Wing/"
local Path_RoleFace = "Role/Face/"
local Path_RoleTail = "Role/Tail/"
local Path_RoleEye = "Role/Eye/"
local Path_RoleMouth = "Role/Mouth/"
local Path_RoleMount = "Role/Mount/"
local Path_RoleMountPart = "Role/MountPart/"
local Path_StagePart = "Public/StageParts/"
local Path_AudioBGM = "Public/Audio/BGM/"
local Path_AudioBGM_HD = "Public/Audio/BGM_HD/"
local Path_AudioSE = "Public/Audio/SE/"
local Path_AudioSE_JP = "Public/Audio/SE_JP/"
local Path_AudioSE_KR = "Public/Audio/SE_KR/"
local Path_AudioPoemStory = "Public/Audio/PoemStory/"
local Path_BusCarrier = "Public/BusCarrier/"
local Path_Item = "Public/Item/"
local Path_BarrageAdornment = "Public/BarrageAdorment/"
local Path_Material = "Public/Material/"
local Path_Furniture = "Public/Home/Furniture/"
local Path_HomeMaterial = "Public/Home/FurnitureMaterial/"
local Path_HomeWorldGrid = "Public/Home/Prefabs/WorldGrid/"
local Path_GardenHouse = "Public/Home/Prefabs/GardenHouse/"
local Path_UIModel = "Public/UIModel/"
local Path_FaceMaterial = "Role/FaceMaterial/"
local Path_BrickObj = "Public/Bricks/PuzzleObj/"
local Path_BrickOutline = "Public/Bricks/PuzzleOutline/"
local Path_BrickShadow = "Public/Bricks/PuzzleShadow/"
local uiEffectPath = {}

function ResourcePathHelper.UIEffect(effect)
  local path = uiEffectPath[effect]
  if path == nil then
    path = "UI/" .. effect
    uiEffectPath[effect] = path
  end
  return path
end

function ResourcePathHelper.ModelMainTexture(txtureName)
  return PATH_GUI_pic_Model_Texture .. txtureName
end

function ResourcePathHelper.UIV1(name)
  return PATH_GUI_V1 .. name
end

function ResourcePathHelper.UICell(cellName)
  return "GUI/v1/cell/" .. cellName
end

function ResourcePathHelper.UITip(tipName)
  return "GUI/v1/tip/" .. tipName
end

function ResourcePathHelper.UIView(viewName)
  return "GUI/v1/view/" .. viewName
end

function ResourcePathHelper.UIPopup(viewName)
  return "GUI/v1/popup/" .. viewName
end

function ResourcePathHelper.UIPart(viewName)
  return "GUI/v1/part/" .. viewName
end

function ResourcePathHelper.Public(name)
  return PATH_PUBLIC .. name
end

function ResourcePathHelper.UIPrefab(name)
  return "GUI/v1/prefab/" .. name
end

function ResourcePathHelper.UIPrefab_Root(name)
  return "GUI/v1/prefab/root/" .. name
end

function ResourcePathHelper.UIPrefab_Cell(name)
  return "GUI/v1/prefab/cell/" .. name
end

function ResourcePathHelper.UIPrefab_Plot(name)
  return "GUI/v1/prefab/plot/" .. name
end

function ResourcePathHelper.UIPrefab_Chapter(name)
  return "GUI/v1/prefab/chapter/" .. name
end

function ResourcePathHelper.Effect(name)
  return PATH_EFFECT_ROOT .. name
end

function ResourcePathHelper.EffectCommon(name)
  return PATH_EFFECT_COMMON .. name
end

function ResourcePathHelper.EffectSkill(name)
  return PATH_EFFECT_SKILL .. name
end

function ResourcePathHelper.EffectUI(name)
  return PATH_EFFECT_UI .. name
end

function ResourcePathHelper.EffectWeather(name)
  return PATH_EFFECT_WEATHER .. name
end

function ResourcePathHelper.EffectSpine(name)
  return PATH_EFFECT_SPINE .. name
end

function ResourcePathHelper.Emoji(name)
  return PATH_EMOJI .. name
end

function ResourcePathHelper.SceneEmoji(name)
  return PATH_SCENE_EMOJI .. name
end

function ResourcePathHelper.RoleBody(ID)
  return Path_RoleBody .. ID
end

function ResourcePathHelper.RoleHair(ID)
  return Path_RoleHair .. ID
end

function ResourcePathHelper.RoleHead(ID)
  return Path_RoleHead .. ID
end

function ResourcePathHelper.RoleWeapon(ID)
  return Path_RoleWeapon .. ID
end

function ResourcePathHelper.RoleWing(ID)
  return Path_RoleWing .. ID
end

function ResourcePathHelper.RoleFace(ID)
  return Path_RoleFace .. ID
end

function ResourcePathHelper.RoleTail(ID)
  return Path_RoleTail .. ID
end

function ResourcePathHelper.RoleEye(ID)
  return Path_RoleEye .. ID
end

function ResourcePathHelper.RoleMouth(ID)
  return Path_RoleMouth .. ID
end

function ResourcePathHelper.RoleMount(ID)
  return Path_RoleMount .. ID
end

function ResourcePathHelper.RoleMountPart(ID)
  return Path_RoleMountPart .. ID
end

function ResourcePathHelper.StagePart(ID)
  return Path_StagePart .. ID
end

function ResourcePathHelper.AudioBGM(ID)
  return Path_AudioBGM .. ID
end

function ResourcePathHelper.AudioBGM_HD(ID)
  return Path_AudioBGM_HD .. ID
end

function ResourcePathHelper.AudioSE(ID)
  return ID
end

function ResourcePathHelper.NewAudioSE(ID)
  return Path_AudioSE .. ID
end

function ResourcePathHelper.AudioSE_JP(ID)
  return Path_AudioSE_JP .. ID
end

function ResourcePathHelper.AudioPoemStory(name)
  return Path_AudioPoemStory .. name
end

function ResourcePathHelper.AudioSE_KR(ID)
  return Path_AudioSE_KR .. ID
end

function ResourcePathHelper.RelativeAudioPoemStory(name)
  return "PoemStory/" .. name
end

function ResourcePathHelper.BrickObj(ID)
  return Path_BrickObj .. ID
end

function ResourcePathHelper.BrickShadow(ID)
  return Path_BrickShadow .. ID .. "_s"
end

function ResourcePathHelper.BrickOutline(ID)
  return Path_BrickOutline .. ID .. "_o"
end

function ResourcePathHelper.GetAudioSESubPath(resPath)
  local sps = string.split(resPath, Path_AudioSE)
  if 1 < #sps then
    return sps[2]
  end
end

function ResourcePathHelper.BusCarrier(ID)
  return Path_BusCarrier .. ID
end

function ResourcePathHelper.Item(ID)
  return Path_Item .. ID
end

function ResourcePathHelper.BarrageAdorment(name)
  return Path_BarrageAdornment .. name
end

function ResourcePathHelper.Furniture(ID)
  local data = Table_HomeFurniture[ID]
  local typeData = Table_FurnitureType[data.Type]
  if not typeData then
    LogUtility.ErrorFormat("没有找到家具类型: %s", tostring(data.Type))
    return nil
  end
  return data and string.format("%s%s/%s/%s", Path_Furniture, typeData.Type, data.Name, data.Name) or nil
end

function ResourcePathHelper.HomeMaterial(ID, folderName)
  if StringUtil.IsEmpty(folderName) then
    LogUtility.Error("folderName为空，无法加载材质")
    return nil
  end
  local data = Table_HomeFurnitureMaterial[ID]
  local typeData = Table_FurnitureType[data.Type]
  if not typeData then
    LogUtility.ErrorFormat("没有找到材质类型: %s", tostring(data.Type))
    return nil
  end
  return data and string.format("%s%s/%s/%s", Path_HomeMaterial, typeData.Type, folderName, data.NameEn) or nil
end

function ResourcePathHelper.HomeWorldGrid(mapName, floorIndex)
  if not mapName or not floorIndex then
    LogUtility.Error("缺少参数，加载失败！")
    return nil
  end
  return string.format("%s%s_floor%s", Path_HomeWorldGrid, mapName, floorIndex)
end

function ResourcePathHelper.GardenHouse(ID)
  local data = Table_GardenHouseType and Table_GardenHouseType[ID]
  if not data then
    LogUtility.Error("没有找到花园房屋：" .. tostring(ID))
  end
  return Path_GardenHouse .. data.Prefab
end

function ResourcePathHelper.UIModel(ID)
  return Path_UIModel .. ID
end

function ResourcePathHelper.FaceMaterial(race, isFemale, index)
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(Path_FaceMaterial)
  if race == 1 then
    sb:Append("Doram_")
  end
  sb:Append("Face")
  if race > Asset_Role.BodyType.Max then
    sb:Append(tostring(race))
  end
  if race ~= 1 then
    sb:Append(isFemale and "_F" or "_M")
  end
  if 1 < index then
    sb:Append("_")
    sb:Append(tostring(index))
  end
  local path = sb:ToString()
  sb:Destroy()
  return path
end

function ResourcePathHelper.FaceMaterialNew(key)
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(Path_FaceMaterial)
  sb:Append(key)
  local path = sb:ToString()
  sb:Destroy()
  return path
end

function ResourcePathHelper.PublicMaterial(name)
  local path = ""
  if name then
    path = Path_Material .. name
  end
  return path
end

function ResourcePathHelper.CurveSprite2D(cellName)
  return "Public/2DSpriteCurve/Prefab/" .. cellName
end

function ResourcePathHelper.ResourcePath(path)
  return "Resources/" .. path
end

function ResourcePathHelper.ResourcePathIncludeSuffix(path)
  return ResourcePathHelper.ResourcePath(path) .. ".unity3d"
end

function ResourcePathHelper.MapRegion(name)
  return "Public/MapRegion/" .. name
end
