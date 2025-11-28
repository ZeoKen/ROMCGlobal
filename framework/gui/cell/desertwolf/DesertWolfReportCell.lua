autoImport("DesertWolfReportData")
DesertWolfReportCell = class("DesertWolfReportCell", BaseCell)
local ColorRed = Color(1, 0.6862745098039216, 0.6862745098039216, 1)
local ColorBlue = Color(0.6235294117647059, 0.796078431372549, 1, 1)

function DesertWolfReportCell:Init()
  self:FindObjs()
end

function DesertWolfReportCell:FindObjs()
  self.objMvp = self:FindGO("MvpIcon")
  self.objLine = self:FindGO("Line")
  self.sprBG = self:FindComponent("Bg", UISprite)
  self.sprBGMyself = self:FindComponent("BgAdd", UISprite)
  self.labName = self:FindComponent("Lab1", UILabel)
  self.sprProfession = self:FindComponent("ProfessionIcon", UISprite)
  self.labKill = self:FindComponent("Lab2", UILabel)
  self.labDeath = self:FindComponent("Lab3", UILabel)
  self.labAssist = self:FindComponent("Lab4", UILabel)
  self.labCombo = self:FindComponent("Lab5", UILabel)
  self.labHeal = self:FindComponent("Lab6", UILabel)
  self.labDamage = self:FindComponent("Lab7", UILabel)
end

function DesertWolfReportCell:GetNumStr(num)
  num = num or 0
  return num < 100000 and num or string.format(ZhString.TeamPws_TenThousand, string.format("%.2f", num / 10000))
end

function DesertWolfReportCell:SetData(data)
  self.data = data
  self.id = data.charid
  self.labName.text = data.name or ""
  self.labKill.text = data.kill or 0
  self.labDeath.text = data.death or 0
  self.labAssist.text = data.assist or 0
  self.labCombo.text = data.combo or 0
  self.labHeal.text = self:GetNumStr(data.heal)
  self.labDamage.text = self:GetNumStr(data.damage)
  if type(data.profession) == "number" then
    local proData = Table_Class[data.profession]
    self.sprProfession.gameObject:SetActive(proData and IconManager:SetProfessionIcon(proData.icon, self.sprProfession) or false)
  elseif type(data.profession) == "string" then
    local success = IconManager:SetProfessionIcon(data.profession, self.sprProfession) or IconManager:SetUIIcon(data.profession, self.sprProfession)
    self.sprProfession.gameObject:SetActive(success)
  end
  local bgColor = data.teamColor == PvpProxy.TeamPws.TeamColor.Red and ColorRed or ColorBlue
  self.sprBG.color = bgColor
  if self.id == Game.Myself.data.id then
    self.sprBGMyself.color = bgColor
    self.sprBGMyself.gameObject:SetActive(true)
  else
    self.sprBGMyself.gameObject:SetActive(false)
  end
  self.objMvp:SetActive(data.ismvp or false)
end

function DesertWolfReportCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
