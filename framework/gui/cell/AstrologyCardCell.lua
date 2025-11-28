local BaseCell = autoImport("BaseCell")
AstrologyCardCell = class("AstrologyCardCell", BaseCell)
local astorlogyConfig = GameConfig.Astrology.SignConfig
local activityConfig = GameConfig.Astrology.ActivityConfig
local colorConfig = {
  [1] = {
    titleTop = LuaColor.New(0.9725490196078431, 0.5411764705882353, 0.47058823529411764, 1),
    titleBot = LuaColor.New(0.8549019607843137, 0.33725490196078434, 0.40784313725490196, 1),
    nameColor = LuaColor.New(0.9686274509803922, 0.8470588235294118, 0.8470588235294118, 1)
  },
  [2] = {
    titleTop = LuaColor.New(0.8666666666666667, 0.6745098039215687, 0.25882352941176473, 1),
    titleBot = LuaColor.New(0.7725490196078432, 0.4588235294117647, 0.11764705882352941, 1),
    nameColor = LuaColor.New(0.984313725490196, 0.984313725490196, 0.8549019607843137, 1)
  },
  [3] = {
    titleTop = LuaColor.New(0.3137254901960784, 0.796078431372549, 0.4392156862745098, 1),
    titleBot = LuaColor.New(0.16862745098039217, 0.6039215686274509, 0.1411764705882353, 1),
    nameColor = LuaColor.New(0.9607843137254902, 0.9882352941176471, 0.9137254901960784, 1)
  },
  [4] = {
    titleTop = LuaColor.New(0.20784313725490197, 0.6392156862745098, 0.7450980392156863, 1),
    titleBot = LuaColor.New(0.1411764705882353, 0.26666666666666666, 0.6862745098039216, 1),
    nameColor = LuaColor.New(0.9607843137254902, 0.9882352941176471, 0.9137254901960784, 1)
  }
}
local AstrologyType = {
  Normal = SceneAugury_pb.EASTROLOGYTYPE_CONSTELLATION,
  Activity = SceneAugury_pb.EASTROLOGYTYPE_ACTIVITY
}

function AstrologyCardCell:Init()
  self.list = {}
  self:FindObjs()
end

function AstrologyCardCell:FindObjs()
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.texture = self:FindGO("Texture"):GetComponent(UITexture)
  for i = 1, 3 do
    local single = self:FindGO("icon" .. i)
    self.list[i] = single
  end
end

function AstrologyCardCell:SetData(groupid, astrotype)
  if astrotype == AstrologyType.Normal then
    local config = astorlogyConfig[groupid]
    if config then
      self.title.gameObject:SetActive(true)
      self.title.text = config.title
      self.title.gradientBottom = colorConfig[groupid].titleBot
      self.title.gradientTop = colorConfig[groupid].titleTop
      PictureManager.Instance:SetUI(config.Pic, self.texture)
      local lisconfig = config.list
      for k, v in pairs(self.list) do
        v.gameObject:SetActive(true)
        local icon = v:GetComponent(UISprite)
        icon.spriteName = lisconfig[k].icon
        local name = self:FindGO("name", v):GetComponent(UILabel)
        name.text = lisconfig[k].name
        name.color = colorConfig[groupid].nameColor
      end
    end
  elseif astrotype == AstrologyType.Activity then
    PictureManager.Instance:SetUI(activityConfig.Pic, self.texture)
    self.title.gameObject:SetActive(false)
    for k, v in pairs(self.list) do
      v.gameObject:SetActive(false)
    end
  end
end
