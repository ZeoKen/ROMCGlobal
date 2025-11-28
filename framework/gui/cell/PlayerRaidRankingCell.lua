autoImport("BaseCell")
PlayerRaidRankingCell = class("PlayerRaidRankingCell", BaseCell)

function PlayerRaidRankingCell:Init()
  self:FindObjs()
end

function PlayerRaidRankingCell:FindObjs()
  self.bg = self:FindGO("bg"):GetComponent(UISprite)
  self.Name = self:FindGO("Name"):GetComponent(UILabel)
  self.value = self:FindGO("value"):GetComponent(UILabel)
  self.percentage = self:FindGO("Percentage"):GetComponent(UILabel)
  self.slider = self:FindGO("foreSp"):GetComponent(UISlider)
  self.foreSp = self:FindGO("foreSp"):GetComponent(UISprite)
  self.progress = self:FindGO("progress")
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindGO("Icon", self.profession):GetComponent(UISprite)
  self.proColor = self:FindGO("Color", self.profession):GetComponent(UISprite)
end

function PlayerRaidRankingCell:SetData(data)
  if data then
    self.Name.text = data.name
    if data.total then
      if data.total ~= 0 then
        self.slider.value = data.value / data.total
        self.percentage.text = string.format("%.2f%%", data.value / data.total * 100)
      else
        self.slider.value = 0
        self.percentage.text = "0%"
      end
    end
    self.value.text = data.value
    local proData = Table_Class[data.profession]
    if proData then
      if IconManager:SetNewProfessionIcon(proData.icon, self.proIcon) then
        self.profession.gameObject:SetActive(true)
        local colorKey = "CareerIconBg" .. proData.Type
        self.proColorSave = ColorUtil[colorKey]
        self.proColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
      else
        self.profession.gameObject:SetActive(false)
      end
    end
  else
    self.gameObject:SetActive(false)
  end
end
