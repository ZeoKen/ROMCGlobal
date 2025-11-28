local BaseCell = autoImport("BaseCell")
NatureLevelCell = class("NatureLevelCell", BaseCell)
local NatureColorMap = {
  Wind = LuaColor.New(0.023529411764705882, 0.7098039215686275, 0.3568627450980392),
  Earth = LuaColor.New(0.7137254901960784, 0.35294117647058826, 0.18823529411764706),
  Water = LuaColor.New(0.058823529411764705, 0.5843137254901961, 0.8666666666666667),
  Fire = LuaColor.New(0.8784313725490196, 0.33725490196078434, 0.06666666666666667),
  Neutral = LuaColor.New(0.11372549019607843, 0.5294117647058824, 0.5647058823529412),
  Holy = LuaColor.New(0.8431372549019608, 0.5411764705882353, 0.27450980392156865),
  Shadow = LuaColor.New(0.3137254901960784, 0.26666666666666666, 0.47843137254901963),
  Ghost = LuaColor.New(0.9098039215686274, 0.4666666666666667, 0.7764705882352941),
  Undead = LuaColor.New(0.17254901960784313, 0.32941176470588235, 0.6823529411764706),
  Poison = LuaColor.New(0.6235294117647059, 0.30980392156862746, 0.803921568627451)
}

function NatureLevelCell:Init()
  self:FindObj()
end

function NatureLevelCell:FindObj()
  self.grid = self.gameObject:GetComponent(UIGrid)
  self.levels = {}
  self.labels = {}
  for i = 1, 4 do
    self.levels[i] = self:FindGO("nCell_" .. i)
    self.levels[i]:SetActive(false)
    self.labels[i] = self:FindGO("level_" .. i):GetComponent(UISprite)
  end
end

function NatureLevelCell:SetData(data)
  self.data = data
  if data and 1 < data then
    for i = 1, 4 do
      if self.levels[i] then
        self.levels[i]:SetActive(i <= data)
      end
      self.gameObject:SetActive(true)
    end
  else
    self.gameObject:SetActive(false)
  end
end

function NatureLevelCell:SetColor(nature)
  if nature and NatureColorMap[nature] then
    for i = 1, 4 do
      self.labels[i].color = NatureColorMap[nature]
    end
  else
    redlog("set color fail", nature)
  end
end
