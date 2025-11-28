local BaseCell = autoImport("BaseCell")
WildMvpSelectBuffCell = class("WildMvpSelectBuffCell", BaseCell)
local Quality = {
  [0] = {
    Texture = "GVG_rift_bg_card4",
    TitleColor = LuaColor.New(0.7176470588235294, 0.2823529411764706, 0.403921568627451, 1),
    InfoColor = LuaColor.New(0.7176470588235294, 0.2823529411764706, 0.403921568627451, 1)
  },
  [1] = {
    Texture = "GVG_rift_bg_card6",
    TitleColor = LuaColor.New(0.4235294117647059, 0.4196078431372549, 0.4196078431372549, 1),
    InfoColor = LuaColor.New(0.5529411764705883, 0.5686274509803921, 0.596078431372549, 1)
  },
  [2] = {
    Texture = "GVG_rift_bg_card1",
    TitleColor = LuaColor.New(0.03137254901960784, 0.5529411764705883, 0.3411764705882353, 1),
    InfoColor = LuaColor.New(0.03137254901960784, 0.5529411764705883, 0.3411764705882353, 1)
  },
  [3] = {
    Texture = "GVG_rift_bg_card3",
    TitleColor = LuaColor.New(0.2823529411764706, 0.5568627450980392, 0.7176470588235294, 1),
    InfoColor = LuaColor.New(0.25882352941176473, 0.4470588235294118, 0.7254901960784313, 1)
  },
  [4] = {
    Texture = "GVG_rift_bg_card2",
    TitleColor = LuaColor.New(0.6705882352941176, 0.40784313725490196, 0.23529411764705882, 1),
    InfoColor = LuaColor.New(0.6627450980392157, 0.3803921568627451, 0.19607843137254902, 1)
  },
  [5] = {
    Texture = "GVG_rift_bg_card4",
    TitleColor = LuaColor.New(0.7176470588235294, 0.2823529411764706, 0.403921568627451, 1),
    InfoColor = LuaColor.New(0.7176470588235294, 0.2823529411764706, 0.403921568627451, 1)
  }
}
local LimitType = {Time = 1, Count = 2}
local IconType = {Skill = 1, Item = 2}
local UIValueType = {
  Percent = 1,
  Absolute = 2,
  PercentFloat1 = 3
}

function WildMvpSelectBuffCell:Init()
  self.bg = self.gameObject:GetComponent(UITexture)
  self.tween = self.gameObject:GetComponent(TweenScale)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.info = self:FindGO("Info"):GetComponent(UILabel)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self:AddCellClickEvent()
end

function WildMvpSelectBuffCell:SetData(data)
  self.data = data
  if data ~= nil then
    local staticData = Table_BuffReward[data]
    if staticData == nil then
      return
    end
    local quality = Quality[staticData.Quality]
    if quality == nil then
      return
    end
    PictureManager.Instance:SetUI(quality.Texture, self.bg)
    self.title.text = staticData.Name
    self.title.color = quality.TitleColor
    if staticData.LimitType ~= nil then
      self.info.gameObject:SetActive(true)
      if staticData.LimitType == LimitType.Time then
        self.info.text = string.format(ZhString.WildMvpBuffLimitTime, staticData.LimitParam.interval / 60, 0)
      elseif staticData.LimitType == LimitType.Count then
        self.info.text = string.format(ZhString.WildMvpBuffLimitCount, staticData.LimitParam.count)
      end
      self.info.color = quality.InfoColor
    else
      self.info.gameObject:SetActive(false)
    end
    if staticData.IconType == IconType.Skill then
      IconManager:SetSkillIcon(staticData.Icon, self.icon)
      self.icon:SetMaskPath(UIMaskConfig.SkillMask)
      self.icon.OpenMask = true
      self.icon.OpenCompress = true
    elseif staticData.IconType == IconType.Item then
      if self.item == nil then
        local obj = self:LoadPreferb("cell/ItemCell", self.icon.gameObject)
        self.item = ItemCell.new(obj)
        self.itemData = ItemData.new(nil, tonumber(staticData.Icon))
      end
      self.item:SetData(self.itemData)
    end
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append(staticData.Desc)
    if staticData.UIValueType == UIValueType.Percent then
      if 0 < staticData.UIValue then
        sb:Append("+")
      end
      sb:Append(staticData.UIValue * 100)
      sb:Append("%")
    elseif staticData.UIValueType == UIValueType.Absolute then
      if 0 < staticData.UIValue then
        sb:Append("+")
      end
      sb:Append(staticData.UIValue)
    end
    if staticData.AccNum ~= nil then
      sb:Append(string.format(ZhString.WildMvpBuffAccNum, staticData.AccNum))
    end
    self.desc.text = sb:ToString()
    sb:Destroy()
  end
end

function WildMvpSelectBuffCell:OnCellDestroy()
  if self.data == nil then
    return
  end
  local staticData = Table_BuffReward[self.data]
  if staticData == nil then
    return
  end
  local quality = Quality[staticData.Quality]
  if quality == nil then
    return
  end
  PictureManager.Instance:UnLoadUI(quality.Texture, self.bg)
end

function WildMvpSelectBuffCell:PlayTween(isForward)
  if isForward then
    self.tween:PlayForward()
  else
    self.tween:PlayReverse()
  end
end
