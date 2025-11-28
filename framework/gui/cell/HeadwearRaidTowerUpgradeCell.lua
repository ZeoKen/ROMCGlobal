autoImport("HeadwearRaidTowerUpgradeSkillCell")
HeadwearRaidTowerUpgradeCell = class("HeadwearRaidTowerUpgradeCell", BaseCell)

function HeadwearRaidTowerUpgradeCell:Init()
  self.lvlb = self:FindComponent("lv", UILabel)
  self.costGrid = self:FindGO("CostGrid")
  self.cr1sp = self:FindComponent("cr1", UISprite)
  self.cr1numlb = self:FindComponent("cr1num", UILabel)
  self.cr2sp = self:FindComponent("cr2", UISprite)
  self.cr2numlb = self:FindComponent("cr2num", UILabel)
  self.curMark = self:FindGO("cur")
  self.curlvMark = self:FindGO("curlv", self.curMark)
  self.locklvMark = self:FindGO("locklv", self.curMark)
  self.outerGrid = self:FindComponent("SkillList0", UITable)
  self.skillGrid = self:FindComponent("SkillList1", UITable)
  self.skilllistCtl = UIGridListCtrl.new(self.skillGrid, HeadwearRaidTowerUpgradeSkillCell, "HeadwearRaidTowerUpgradeSkillCell")
end

function HeadwearRaidTowerUpgradeCell:SetData(data)
  self.lvlb.text = "Lv." .. tostring(data.level)
  IconManager:SetItemIcon(Table_Item[data.cr1].Icon, self.cr1sp)
  IconManager:SetItemIcon(Table_Item[data.cr2].Icon, self.cr2sp)
  self.cr1numlb.text = data.info[1] - (data.lastinfo and data.lastinfo[1] or 0)
  self.cr2numlb.text = data.info[2] - (data.lastinfo and data.lastinfo[2] or 0)
  local skilldatas = {}
  for i = 4, #data.info do
    TableUtility.ArrayPushBack(skilldatas, data.info[i])
  end
  self.skilllistCtl:ResetDatas(skilldatas)
  self.outerGrid:Reposition()
  local nextlv = data.curlevel + 1
  if nextlv > data.level then
    self.costGrid:SetActive(false)
    self.curMark:SetActive(false)
    self:SetGrey(false)
  elseif nextlv == data.level then
    self.costGrid:SetActive(true)
    self.curMark:SetActive(true)
    self.curlvMark:SetActive(true)
    self.locklvMark:SetActive(false)
    self:SetGrey(false)
    if data.cr1n then
      self.cr1numlb.text = data.cr1n
    end
    if data.cr2n then
      self.cr2numlb.text = data.cr2n
    end
  else
    self.costGrid:SetActive(true)
    self.curMark:SetActive(true)
    self.curlvMark:SetActive(false)
    self.locklvMark:SetActive(true)
    self:SetGrey(true)
  end
end

local normal = Color(1, 1, 1, 1)
local normalGrey = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local textNormal = Color(0.16862745098039217, 0.16862745098039217, 0.16862745098039217, 1)
local text = Color(0.12941176470588237, 0.39215686274509803, 0.788235294117647, 1)
local sp = Color(1, 0.788235294117647, 0.27058823529411763, 1)
local spGrey = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
local textGrey = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
local spsp = {
  "cur0",
  "curlv",
  "locklv"
}
local sptext = {
  "lv",
  "cr1num",
  "cr2num"
}

function HeadwearRaidTowerUpgradeCell:SetGrey(isTrue)
  local sprites = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UISprite, true)
  local labels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UILabel, true)
  if isTrue then
    for i = 1, #sprites do
      if TableUtility.ArrayFindIndex(spsp, sprites[i].name) > 0 then
        sprites[i].color = spGrey
      else
        sprites[i].color = normalGrey
      end
    end
    for i = 1, #labels do
      if TableUtility.ArrayFindIndex(sptext, labels[i].name) > 0 then
        labels[i].color = textGrey
      else
        labels[i].color = textGrey
      end
    end
  else
    for i = 1, #sprites do
      if TableUtility.ArrayFindIndex(spsp, sprites[i].name) > 0 then
        sprites[i].color = sp
      else
        sprites[i].color = normal
      end
    end
    for i = 1, #labels do
      if TableUtility.ArrayFindIndex(sptext, labels[i].name) > 0 then
        labels[i].color = text
      else
        labels[i].color = textNormal
      end
    end
  end
end

function HeadwearRaidTowerUpgradeCell:ClickSkill(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end
