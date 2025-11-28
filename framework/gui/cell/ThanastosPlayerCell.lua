local baseCell = autoImport("BaseCell")
autoImport("HeadIconCell")
ThanastosPlayerCell = class("ThanastosPlayerCell", BaseCell)

function ThanastosPlayerCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:InitHeadIcon()
end

function ThanastosPlayerCell:FindObjs()
  self.level = self:FindGO("Level"):GetComponent(UILabel)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
end

function ThanastosPlayerCell:AddButtonEvt()
  self:AddClickEvent(self.gameObject, function()
    if self.parentView then
      self.parentView:OnClickPlayerCell(self)
    else
      redlog("parentView nil")
    end
  end)
end

local tempV3 = LuaVector3.One()

function ThanastosPlayerCell:InitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon:SetScale(0.55)
  self.headIcon:SetMinDepth(2)
  self.headIcon:DisableBoxCollider(false)
end

function ThanastosPlayerCell:SetData(data)
  ThanastosPlayerCell.super.SetData(self, data)
  self.data = data
  if data then
    self.level.text = string.format("Lv.%d", data.level)
    self.name.text = data.name
    self.guildName.text = data.guildname
    local headData = Table_HeadImage[data.portrait]
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
    else
      self.headIcon:SetData(data)
    end
    self.BaseFace = self:FindGO("BaseFace")
    if self.BaseFace then
      self.BaseFace.transform.localScale = tempV3
    end
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      local iconColor = ColorUtil["CareerIconBg" .. config.Type]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professIconBG.color = iconColor
    end
  end
end

function ThanastosPlayerCell:SetView(parentView)
  self.parentView = parentView
end
