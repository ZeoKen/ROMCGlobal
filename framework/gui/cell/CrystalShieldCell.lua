autoImport("BaseCell")
CrystalShieldCell = class("CrystalShieldCell", BaseCell)
local redCrystalSP = "team_icon_crystal_red"
local blueCrystalSP = "team_icon_crystal_blue"

function CrystalShieldCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  if tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
  end
  self.selected = false
end

function CrystalShieldCell:FindObjs()
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.crystal = self:FindGO("crystal"):GetComponent(UISprite)
  self.shield = self:FindGO("shield")
  self.energyProgress = self:FindGO("EnergyProgress"):GetComponent(UISlider)
  self.energyPercent = self:FindGO("energyPercent"):GetComponent(UILabel)
  self.broken = self:FindGO("broken"):GetComponent(UILabel)
end

function CrystalShieldCell:SetData(data)
  self.data = data
  if data then
    self.name.text = self.data.name
    self:UpdateStatus()
  else
    self.gameObject:SetActive(false)
    return
  end
end

function CrystalShieldCell:UpdateStatus()
  if not self.data then
    return
  end
  local crystalnpcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.data.crystalid)
  if crystalnpcs[1] and crystalnpcs[1].data.staticData.id == self.ConfigThanatos.BlueCrystalID then
    self.crystal.spriteName = blueCrystalSP
  elseif crystalnpcs[1] and crystalnpcs[1].data.staticData.id == self.ConfigThanatos.RedCrystalID then
    self.crystal.spriteName = redCrystalSP
  end
  local crystalnpc = crystalnpcs and crystalnpcs[1] or {}
  local shieldnpcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.data.shieldid)
  local shieldnpc = shieldnpcs and shieldnpcs[1] or {}
  local shieldprops = shieldnpc and shieldnpc.data and shieldnpc.data.props or nil
  local crystalprops = crystalnpc and crystalnpc.data and crystalnpc.data.props or nil
  local shieldhp = shieldprops and shieldprops:GetPropByName("Hp"):GetValue() or 0
  local crystalhp = crystalprops and crystalprops:GetPropByName("Hp"):GetValue() or 0
  local shiedlmax = shieldprops and shieldprops:GetPropByName("MaxHp"):GetValue() or 1
  if shieldhp ~= 0 and crystalhp ~= 0 then
    local value = shieldhp / shiedlmax
    self.energyProgress.value = value
    self.energyPercent.text = string.format("%d%%", value * 100)
  elseif crystalhp == 0 then
    self.broken.text = ZhString.Thanatos_Broken
  else
    self.broken.text = ZhString.Thanatos_Breakable
  end
  self.shield:SetActive(shieldhp ~= 0)
  self.energyProgress.gameObject:SetActive(shieldhp ~= 0 and crystalhp ~= 0)
  self.broken.gameObject:SetActive(shieldhp == 0 or crystalhp == 0)
end

function CrystalShieldCell:OnExit()
  CrystalShieldCell.super.OnExit(self)
end
