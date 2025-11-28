local BaseCell = autoImport("BaseCell")
PlayerInfoCell = class("PlayerInfoCell", BaseCell)
local buffID = GameConfig.Thanatos[2] and GameConfig.Thanatos[2].MadBuffID
local buffLimit = GameConfig.Thanatos[2] and GameConfig.Thanatos[2].MadBuffLimit

function PlayerInfoCell:Init()
  self.sanity = self:FindGO("sanity"):GetComponent(UISlider)
  self.forebg = self:FindGO("forebg"):GetComponent(UISprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
  self.statusSP = self:FindGO("status"):GetComponent(UIMultiSprite)
  self.sanity.value = 0
end

function PlayerInfoCell:SetData(data)
  if data then
    if self.charid ~= data.charid then
      self.charid = data.charid
    end
    if self.profession ~= data.profession then
      self.profession = data.profession
      local config = Table_Class[data.profession]
      if config then
        IconManager:SetNewProfessionIcon(config.icon, self.Profession)
        local iconColor = ColorUtil["CareerIconBg" .. config.Type]
        if iconColor == nil then
          iconColor = ColorUtil.CareerIconBg0
        end
        self.professIconBG.color = iconColor
      end
    end
    if self.name.text ~= data.name then
      self.name.text = data.name
      UIUtil.WrapLabel(self.name)
    end
    local creature = NSceneUserProxy.Instance:Find(self.charid)
    local bufflayer = 0
    if creature ~= nil then
      bufflayer = creature:GetBuffLayer(buffID)
      self:UpdateLayer(bufflayer / buffLimit)
    end
    if data.layer then
      bufflayer = data.layer
      self:UpdateLayer(bufflayer)
    end
    self:UpdateStatus(data.status)
    if not self.gameObject.activeInHierarchy then
      self.gameObject:SetActive(true)
    end
  else
    self.gameObject:SetActive(false)
  end
end

function PlayerInfoCell:UpdateLayer(value)
  if self.sanityValue ~= value then
    self.sanityLayer = value or 0
    if self.sanityLayer > 0.4 then
      self.forebg.spriteName = "com_bg_hp_2s"
    else
      self.forebg.spriteName = "com_bg_kl"
    end
    self.sanity.value = self.sanityLayer
  end
end

function PlayerInfoCell:UpdateStatus(status)
  if status and self.status ~= status then
    self.status = status
    self.statusSP.CurrentState = self.status
    if not self.statusSP.gameObject.activeInHierarchy then
      self.statusSP.gameObject:SetActive(true)
    end
  elseif not status then
    self.statusSP.gameObject:SetActive(false)
  end
end
