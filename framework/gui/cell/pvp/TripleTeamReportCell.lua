TripleTeamReportCell = class("TripleTeamReportCell", BaseCell)
local CampColor = {
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = "ffafaf",
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = "ffee5a",
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = "9fcbff",
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = "a4ff9f"
}

function TripleTeamReportCell:Init()
  self:FindObjs()
end

function TripleTeamReportCell:FindObjs()
  self.objMvp = self:FindGO("objMvp")
  self.objLine = self:FindGO("objLine")
  self.sprBG = self:FindComponent("Bg", UISprite)
  self.sprBGMyself = self:FindComponent("BgAdd", UISprite)
  self.labName = self:FindComponent("labName", UILabel)
  self.sprProfession = self:FindComponent("sprProfession", UISprite)
  self.labKill = self:FindComponent("labKill", UILabel)
  self.labDeath = self:FindComponent("labDeath", UILabel)
  self.labHeal = self:FindComponent("labHeal", UILabel)
  self.labHelp = self:FindComponent("labHelp", UILabel)
  self.labDamage = self:FindComponent("labDamage", UILabel)
  self.labBeDamaged = self:FindComponent("labBeDamaged", UILabel)
end

function TripleTeamReportCell:SetData(data)
  self.data = data
  self.id = data.charid
  self:SetLabelData(data)
  if type(data.profession) == "number" then
    local proData = Table_Class[data.profession]
    self.sprProfession.gameObject:SetActive(proData and IconManager:SetProfessionIcon(proData.icon, self.sprProfession) or false)
  elseif type(data.profession) == "string" then
    local success = IconManager:SetProfessionIcon(data.profession, self.sprProfession) or IconManager:SetUIIcon(data.profession, self.sprProfession)
    self.sprProfession.gameObject:SetActive(success)
  end
  local bgColor = CampColor[data.camp]
  local _, c = ColorUtil.TryParseHexString(bgColor)
  self.sprBG.color = c
  if self.id == Game.Myself.data.id then
    self.sprBGMyself.color = c
    self.sprBGMyself.gameObject:SetActive(true)
  else
    self.sprBGMyself.gameObject:SetActive(false)
  end
  self.objMvp:SetActive(data.isMvp or false)
end

function TripleTeamReportCell:SetLabelData(data)
  if data.hideName then
    self.labName.text = FunctionAnonymous.Me():GetAnonymousName(data.profession)
  else
    self.labName.text = data.username
  end
  self.labKill.text = data.kill
  self.labDeath.text = data.death
  self.labHeal.text = StringUtil.FormatMillionNumToStr(data.heal)
  self.labHelp.text = data.help
  self.labDamage.text = StringUtil.FormatMillionNumToStr(data.damage)
  self.labBeDamaged.text = StringUtil.FormatMillionNumToStr(data.bedamaged)
end

function TripleTeamReportCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
