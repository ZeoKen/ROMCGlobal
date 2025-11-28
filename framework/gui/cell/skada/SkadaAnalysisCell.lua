SkadaAnalysisCell = class("SkadaAnalysisCell", BaseCell)
SkadaAnalysisCell.ClickShare = "SkadaAnalysisCell_ClickShare"

function SkadaAnalysisCell:Init()
  SkadaAnalysisCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function SkadaAnalysisCell:FindObjs()
  self.sprSkillIcon = self:FindComponent("sprSkillIcon", UISprite)
  self.labCastCount = self:FindComponent("labCount", UILabel)
  self.labTotalDamage = self:FindComponent("labTotalDamage", UILabel)
  self.labDPS = self:FindComponent("labDPS", UILabel)
  self.labPercent = self:FindComponent("labPercent", UILabel)
  self.sliderPercent = self:FindComponent("sliderPercent", UISlider)
end

function SkadaAnalysisCell:AddEvts()
  self:AddClickEvent(self.sprSkillIcon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self:FindGO("btnShare"), function()
    self:PassEvent(SkadaAnalysisCell.ClickShare, self)
  end)
end

function SkadaAnalysisCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  local skillSData = data.skillID and Table_Skill[data.skillID]
  local professionData = data.profession and Table_Class[data.profession]
  if skillSData and professionData then
    IconManager:SetSkillIconByProfess(skillSData.Icon, self.sprSkillIcon, professionData and professionData.Type, true)
  else
    LogUtility.Error(string.format("设置技能图标失败！技能ID:%s, 职业:%s", tostring(data.skillID), tostring(data.profession)))
  end
  self.labCastCount.text = data.atkCount
  if data.totalDamage < 10000 then
    self.labTotalDamage.text = string.format("%.1f", data.totalDamage)
  else
    local millionNum = math.modf(data.totalDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.totalDamage, 1000000) / 1000) .. "K"
    self.labTotalDamage.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  if 10000 > data.averageDamage then
    self.labDPS.text = string.format("%.1f", data.averageDamage)
  else
    local millionNum = math.modf(data.averageDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.averageDamage, 1000000) / 1000) .. "K"
    self.labDPS.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  self.labPercent.text = math.modf(data.percent * 100) .. "%"
  self.sliderPercent.value = data.percent
end
