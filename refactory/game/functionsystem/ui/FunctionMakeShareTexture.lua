FunctionMakeShareTexture = class("FunctionMakeShareTexture")
FunctionMakeShareTexture.ins = nil

function FunctionMakeShareTexture:Ins()
  if FunctionMakeShareTexture.ins == nil then
    FunctionMakeShareTexture.ins = FunctionMakeShareTexture.new()
  end
  return FunctionMakeShareTexture.ins
end

local _goShareScenicSpotPhoto, _camera, _uiTexture, _uiLab, _screenShotHelper

function FunctionMakeShareTexture:StartMake(texture2D, complete_callback)
  if _goShareScenicSpotPhoto == nil then
    _goShareScenicSpotPhoto = GameObject.Find("ShareScenicSpotPhoto")
    _screenShotHelper = _goShareScenicSpotPhoto:GetComponent(ScreenShotHelper)
    local transCamera = _goShareScenicSpotPhoto.transform:FindChild("Camera")
    _camera = transCamera:GetComponent(Camera)
    _camera.hideFlags = HideFlags.HideAndDontSave
    _camera.enabled = false
    local transUITexture = _goShareScenicSpotPhoto.transform:FindChild("Texture")
    _uiTexture = transUITexture:GetComponent(UITexture)
    local transUILabel = _goShareScenicSpotPhoto.transform:FindChild("Lab")
    _uiLab = transUILabel:GetComponent(UILabel)
    local roleName = Game.Myself and Game.Myself.data and Game.Myself.data:GetName() or nil
    if roleName ~= nil then
      _uiLab.text = roleName
    end
  end
  local texWidth = texture2D.width
  local texHeight = texture2D.height
  local ratio = texWidth / texHeight
  _camera.aspect = ratio
  _uiTexture.mainTexture = texture2D
  _uiTexture.height = _camera.pixelHeight * 1280 / _camera.pixelWidth
  _uiTexture.width = math.floor(_uiTexture.height * ratio)
  _screenShotHelper:Setting(texWidth, texHeight, TextureFormat.RGB24, 24, ScreenShot.AntiAliasing.None)
  _screenShotHelper:GetScreenShot(function(x)
    _uiTexture.mainTexture = nil
    if complete_callback ~= nil then
      complete_callback(x)
    end
  end, _camera)
end
