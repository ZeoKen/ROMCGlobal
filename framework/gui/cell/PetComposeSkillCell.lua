local BaseCell = autoImport("BaseCell")
PetComposeSkillCell = class("PetComposeSkillCell", BaseCell)
local allMonster = "pet_icon_all"
local _ContractBg = "pet_bg_skillqiyue_bg01"
local _EmptyParams = {}
local FormatSkillDesc = function(skillid, descid, descFormat, params)
  local success, result = pcall(string.format, descFormat, unpack(params or _EmptyParams))
  if success then
    return result
  end
  LogUtility.Error(string.format("PetComposeSkillCell skill desc format error, skillid:%s descid:%s error:%s desc:%s", tostring(skillid), tostring(descid), tostring(result), tostring(descFormat)))
  return descFormat
end

function PetComposeSkillCell:Init()
  self:FindObjs()
  self:AddEvt()
end

function PetComposeSkillCell:FindObjs()
  self.nameLab = self:FindGO("Name"):GetComponent(UILabel)
  self.descLab = self:FindComponent("Desc", UILabel)
  self.skillIcon = self:FindComponent("Icon", UISprite)
  self.content = self:FindGO("Content")
  self.line = self:FindGO("Line")
  self.contractBgTexture = self:FindComponent("ContractBg", UITexture)
  if self.contractBgTexture then
    PictureManager.Instance:SetUI(_ContractBg, self.contractBgTexture)
  end
end

function PetComposeSkillCell:AddEvt()
end

function PetComposeSkillCell:SetData(data)
  self.data = data
  if data then
    local id = data.skillid
    self.content:SetActive(true)
    if Table_Skill[id] then
      local config = Table_Skill[id]
      IconManager:SetSkillIcon(config.Icon, self.skillIcon)
      self.nameLab.text = config.NameZh
      local desc = ""
      local descCsv = Table_Skill[id].Desc
      if descCsv then
        for i = 1, #descCsv do
          local config = descCsv[i]
          if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
            desc = desc .. FormatSkillDesc(id, config.id, Table_SkillDesc[config.id].Desc, config.params) .. (i ~= #descCsv and "\n" or "")
          end
        end
      end
      self.descLab.text = desc
      if data.isContract then
        self:Show(self.contractBgTexture)
      else
        self:Hide(self.contractBgTexture)
      end
      local showLine = false
      if data.hasContractSkill then
        showLine = data.index > 2 and not data.isEnd
      else
        showLine = data.isEnd == false
      end
      if showLine then
        self:Show(self.line)
      else
        self:Hide(self.line)
      end
    end
  else
    self.content:SetActive(false)
  end
end

function PetComposeSkillCell:OnCellDestroy()
  if self.contractBgTexture then
    PictureManager.Instance:UnLoadUI(_ContractBg, self.contractBgTexture)
  end
end
