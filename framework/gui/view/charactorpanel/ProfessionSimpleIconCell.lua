local BaseCell = autoImport("BaseCell")
ProfessionSimpleIconCell = class("ProfessionSimpleIconCell", BaseCell)
ProfessionSimpleIconCell.AttrLightColor = Color(0.17254901960784313, 0.39215686274509803, 0.9215686274509803)

function ProfessionSimpleIconCell:Init()
  self:initView()
  self:initData()
end

function ProfessionSimpleIconCell:initData()
end

function ProfessionSimpleIconCell:initView()
  self.Node = self:FindGO("Node")
  self.ProfessIcon = self:FindGO("ProfessIcon", self.Node)
  self.ProfessIcon_UISprite = self.ProfessIcon:GetComponent(UISprite)
  self.CareerBg = self:FindGO("CareerBg", self.Node)
  self.CareerBord = self:FindGO("CareerBord", self.CareerBg)
  self.CareerBg_UISprite = self.CareerBg:GetComponent(UISprite)
end

function ProfessionSimpleIconCell:addViewEventListener()
end

function ProfessionSimpleIconCell:SetData(data)
  self.data = data
  if self.data ~= nil then
    local thisidClass = Table_Class[self.data]
    if thisidClass then
      local iconName = "icon_1_0"
      if id == 1 then
        iconName = "icon_1_0"
      else
        iconName = thisidClass.icon
      end
      local thisidType = thisidClass.Type
      local colorKey = "CareerIconBg" .. thisidType
      if colorKey and ColorUtil[colorKey] then
        self.CareerBg_UISprite.color = ColorUtil[colorKey]
      else
        helplog("colorKey" .. colorKey .. "不存在")
      end
      IconManager:SetNewProfessionIcon(iconName, self.ProfessIcon_UISprite)
      self.ProfessIcon_UISprite.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      if ProfessionProxy.Instance:IsThisIdYiGouMai(self.data) == false then
        self.CareerBg_UISprite.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      end
    end
  else
    helplog("review code !!")
  end
end

function ProfessionSimpleIconCell:initHead()
end
