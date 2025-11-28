local IsNull = Slua.IsNull
SpriteManager = {}
local mSpriteAtlasMap

function SpriteManager.GetSpriteAtlasMap()
  if not IsNull(mSpriteAtlasMap) then
    return mSpriteAtlasMap
  end
  mSpriteAtlasMap = ResourceManager.Instance:SLoadByType("GUI/atlas/SpriteAtlasMap", SpriteAtlasMap)
  return mSpriteAtlasMap
end

local errorSpsMap
local recordErrorSprites = function(spName)
  if not Application.isEditor then
    return
  end
  if spName == nil then
    return
  end
  local filePath = Application.dataPath .. "/../SceneErrorSprites.txt"
  if errorSpsMap == nil then
    local wfile = io.open(filePath, "r")
    if wfile then
      local fileStr = wfile:read("a")
      wfile:close()
      local t = loadstring(fileStr)
      if type(t) == "function" then
        errorSpsMap = t()
      end
    end
    if errorSpsMap == nil then
      errorSpsMap = {}
    end
  end
  if not errorSpsMap then
    return
  end
  if not errorSpsMap[spName] then
    errorSpsMap[spName] = 1
  end
  local wfile = io.open(filePath, "w+")
  if wfile == nil then
    redlog(string.format("not find file:%s", filePath))
  end
  wfile:write("return " .. Serialize(errorSpsMap))
  wfile:close()
end

function SpriteManager.SetUISprite(atlasName, spriteName, sprite)
  if sprite == nil then
    redlog("sprite is nil.")
    return false
  end
  if spriteName == nil then
    error("设置场景UI SpriteName不能为空.")
  end
  if IsNull(mSpriteAtlasMap) then
    SpriteManager.GetSpriteAtlasMap()
  end
  local spriteData
  local atlas = mSpriteAtlasMap:GetAtlas(atlasName)
  if atlas ~= nil then
    spriteData = atlas:GetSprite(spriteName)
  end
  if spriteData == nil then
    LogUtility.Error(string.format("没找到场景UI：<color=red>%s</color>.(场景UI需要放到目录Art/Public/Texture/GUI/sceneui/下)", spriteName))
    return false
  end
  sprite.sprite = spriteData
  spriteData = nil
  return true
end
