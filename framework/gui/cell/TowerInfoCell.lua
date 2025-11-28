local BaseCell = autoImport("BaseCell")
TowerInfoCell = class("TowerInfoCell", BaseCell)
local TwelvePvpConfig = GameConfig.TwelvePvp
local CampConfig = TwelvePvpConfig.CampConfig
TowerInfoCell.towerOrder = {
  [1] = {
    [CampConfig[1].DefenseTower[1]] = 1,
    [CampConfig[1].DefenseTower[2]] = 2,
    [CampConfig[1].DefenseTower[3]] = 3,
    [CampConfig[1].BarrackID.defense] = 4.1,
    [CampConfig[1].CrystalID] = 4.2
  },
  [2] = {
    [CampConfig[2].DefenseTower[1]] = 1,
    [CampConfig[2].DefenseTower[2]] = 2,
    [CampConfig[2].DefenseTower[3]] = 3,
    [CampConfig[2].BarrackID.defense] = 4.1,
    [CampConfig[2].CrystalID] = 4.2
  }
}
local CampUIConfig = {
  [1] = {
    icon = "6v6_bg_White-crystal"
  },
  [2] = {
    icon = "6v6_bg_black-crystal"
  }
}
local Max = 100

function TowerInfoCell:Init()
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.hpPercent = self:FindGO("HPPercent"):GetComponent(UILabel)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.forebg = self:FindGO("forebg"):GetComponent(UISprite)
  self.shield = self:FindGO("shield")
end

local npcMapSymbols = GameConfig.TwelvePvp.MiniMapSymbol

function TowerInfoCell:SetData(data)
  if data then
    self.data = data
    self.campid = data.campid
    self.npcid = data.npcid
    self.order = data.order
    self.forebg.spriteName = CampUIConfig[self.campid].icon
    IconManager:SetMapIcon(npcMapSymbols[self.npcid] or "", self.icon)
    self.icon:MakePixelPerfect()
    self:UpdateStatus()
  else
    self.gameObject:SetActive(false)
  end
end

local currentid, currenthp

function TowerInfoCell:UpdateStatus(currentid)
  local order = TowerInfoCell.towerOrder[self.campid]
  currentid = currentid or 0
  if not order[currentid] or 1 <= self.order - order[currentid] then
    self:SetFull()
  elseif order[currentid] == self.order then
    self:SetCurrent()
  else
    self:SetBroken()
  end
end

function TowerInfoCell:SetCurrent(npcid, setHP)
  if not npcid then
    return
  end
  currenthp = TwelvePvPProxy.Instance:GetHPPercentByNPCID(npcid) or setHP or 0
  self.hpProgress.value = currenthp / 100
  self.hpPercent.text = string.format("%d%%", currenthp)
  self.shield:SetActive(false)
end

function TowerInfoCell:SetBroken()
  self.hpProgress.value = 0
  self.hpPercent.text = "0%"
  self.shield:SetActive(false)
end

function TowerInfoCell:SetFull()
  self.hpProgress.value = 1
  self.hpPercent.text = "100%"
  self.shield:SetActive(true)
end
