autoImport("GemExhibitCell")
GemSkillProfitCell = class("GemSkillProfitCell", GemExhibitCell)

function GemSkillProfitCell:Init()
  GemSkillProfitCell.super.Init(self)
  self.invalidTip = self:FindGO("InvalidTip")
  self.bg = self:FindComponent("Bg", UISprite)
end

function GemSkillProfitCell:SetData(itemData)
  self.gameObject:SetActive(itemData ~= nil)
  if type(itemData) ~= "table" then
    LogUtility.Warning("Cannot set data of GemSkillProfitCell when data is nil or non-table!")
    return
  end
  GemSkillProfitCell.super.SetData(self, Table_GemRate[itemData.staticData.id])
  self.data = itemData
  if not itemData.gemSkillData then
    LogUtility.WarningFormat("Cannot set data of GemSkillProfitCell when gemSkillData is nil and staticID = {0}!", itemData.staticData.id)
    return
  end
  local descArray = itemData.gemSkillData:GetEffectDescArray()
  for i = #descArray, 2, -1 do
    table.insert(descArray, i, "、")
  end
  self.descLabel.text = table.concat(descArray)
  if self.descLabel.height < 40 then
    self.descLabel.text = string.format("%s%s", self.descLabel.text, string.rep(" ", math.floor(self.descLabel.width / 4)))
  end
  if self.bg then
    self.bg.height = 40 + self.descLabel.height
  end
  self.invalidTip:SetActive(false)
end

function GemSkillProfitCell:UpdateInvalidByGemPageData(pageData)
  if not self.invalidTip then
    return
  end
  if type(pageData) ~= "table" or pageData.__cname ~= "GemPageData" then
    LogUtility.Error("Invalid argument!")
    return
  end
  self.invalidTip:SetActive(not pageData:CheckIsSkillEffectValid(self.data.id))
end
