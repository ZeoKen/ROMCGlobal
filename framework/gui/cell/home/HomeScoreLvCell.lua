HomeScoreLvCell = class("HomeScoreLvCell", BaseCell)
local color_LvActive = LuaColor(1.0, 0.4235294117647059, 0.10980392156862745, 1)
local gray = LuaColor.Gray()

function HomeScoreLvCell:Init()
  HomeScoreLvCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeScoreLvCell:FindObjs()
  self.labLv = self:FindComponent("labLv", UILabel)
  self.labAttri = self:FindComponent("labAttri", UILabel)
  self.sprBG = self:FindComponent("BG", UISprite)
  
  function self.labAttri.onChange()
    if self.sprBG then
      self.sprBG:ResetAndUpdateAnchors()
    end
  end
end

function HomeScoreLvCell:AddEvts()
end

function HomeScoreLvCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.labLv.text = string.format("[Lv.%s]", data.id)
  self.labAttri.text = data.Desc
  self.sprBG:ResetAndUpdateAnchors()
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if myHouseData and myHouseData.lv >= data.id then
    self.labAttri.color = LuaColor.black
    self.labLv.color = color_LvActive
  else
    self.labAttri.color = gray
    self.labLv.color = gray
  end
end
