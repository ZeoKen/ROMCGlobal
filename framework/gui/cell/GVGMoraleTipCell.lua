autoImport("GuildHeadCell")
local _MaxMorale = 100
local _BaseCell = autoImport("BaseCell")
GVGMoraleTipCell = class("GVGMoraleTipCell", _BaseCell)

function GVGMoraleTipCell:Init()
  self.nameLab = self:FindGO("Name"):GetComponent(UILabel)
  self.slider = self:FindGO("Slider"):GetComponent(UISlider)
  self.processLab = self:FindGO("Process"):GetComponent(UILabel)
  local headCellGO = self:FindGO("GuildHeadCell")
  self.guildHeadCell = GuildHeadCell.new(headCellGO)
end

function GVGMoraleTipCell:SetData(data)
  if data then
    self.data = data
    self.nameLab.text = data.guildName
    self.slider.value = data.morale / _MaxMorale
    self.processLab.text = tostring(data.morale) .. "/100"
    self.guildHeadCell:SetData(data.guildHeadData)
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end
