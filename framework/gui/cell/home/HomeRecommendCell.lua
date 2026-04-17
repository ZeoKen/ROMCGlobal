HomeRecommendCell = class("HomeRecommendCell", BaseCell)
local PhotoFrameMap = {
  [HomeCmd_pb.EHOUSETYPE_PRIVATE] = "home_blueprint_bg_s",
  [HomeCmd_pb.EHOUSETYPE_SNOW] = "home_blueprint_bg_01"
}
local _, SnowNameColor = ColorUtil.TryParseHexString("5975c0")

function HomeRecommendCell:Init()
  self:FindObjs()
end

function HomeRecommendCell:FindObjs()
  self.frameBg = self.gameObject:GetComponent(UISprite)
  self.name = self:FindComponent("Name", UILabel)
  local namePanel = self:FindComponent("NameScroll", UIPanel)
  local nameScroll = self:FindComponent("NameScroll", UIScrollView)
  local parentPanel = UIUtil.GetComponentInParents(nameScroll.gameObject, UIPanel)
  if parentPanel then
    namePanel.depth = parentPanel.depth + 1
  end
  self.nameScrollCtrl = UIAutoScrollCtrl.new(nameScroll, self.name)
  self.hotLabel = self:FindComponent("Hot", UILabel)
  self.photoTex = self:FindComponent("PhotoTex", UITexture)
  self:AddCellClickEvent()
end

function HomeRecommendCell:SetData(data)
  self.data = data
  if data then
    self.frameBg.spriteName = PhotoFrameMap[data.photoId] or ""
    local homeName = not StringUtil.IsEmpty(data.homeName) and data.homeName or data.photoId == HomeCmd_pb.EHOUSETYPE_SNOW and ZhString.HomeMainView_TabSnow or ""
    self.nameScrollCtrl:Stop(true)
    self.name.text = string.format(ZhString.HomeRecommend_HomeName, data.userName, homeName)
    self.name.color = data.photoId == HomeCmd_pb.EHOUSETYPE_SNOW and SnowNameColor or ColorUtil.NGUIWhite
    self.name:UpdateNGUIText()
    self.nameScrollCtrl:Start(true, true, true)
    self.hotLabel.text = data.hot
    self:GetPhoto()
  end
end

function HomeRecommendCell:GetPhoto()
  if self.data then
    local photoId = self.data.photoId
    local urlPath = self.data:GetPhotoUrl()
    local timeStamp = self.data.timeStamp
    FunctionPhotoStorage.Me():GetHomePhoto(FunctionPhotoStorage.PhotoType.HomeRecommend, photoId, timeStamp, true, urlPath, self.data.index, nil, nil, self.data.index)
  end
end

function HomeRecommendCell:SetPhoto(bytes)
  if bytes then
    local width = self.photoTex.width
    local height = self.photoTex.height
    local texture = Texture2D(width, height, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      local oldTexture = self.photoTex.mainTexture
      if oldTexture ~= nil then
        Object.DestroyImmediate(oldTexture)
      end
      self.photoTex.mainTexture = texture
    else
      Object.DestroyImmediate(texture)
    end
  end
end

function HomeRecommendCell:ClearPhoto()
  local oldTexture = self.photoTex.mainTexture
  if oldTexture ~= nil then
    Object.DestroyImmediate(oldTexture)
  end
  self.photoTex.mainTexture = nil
end

function HomeRecommendCell:OnCellDestroy()
  self:ClearPhoto()
end
