local BaseCell = autoImport("BaseCell")
DetectiveSkillCell = class("DetectiveSkillCell", BaseCell)

function DetectiveSkillCell:Init()
  DetectiveSkillCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DetectiveSkillCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.skillLock = self:FindGO("SkillLock")
  self.skillLevelRoot = self:FindGO("LevelRoot")
  self.levelIcon = {}
  for i = 1, 3 do
    self.levelIcon[i] = self:FindGO("Level" .. i, self.skillLevelRoot):GetComponent(UISprite)
  end
  self.levelGrid = self:FindGO("LevelGrid"):GetComponent(UIGrid)
  self.skillLevelLock = self:FindGO("Lock")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseTexture = self:FindGO("ChooseTexture"):GetComponent(UITexture)
end

function DetectiveSkillCell:SetData(data)
  self.data = data
  local skillStaticData = data.staticData
  self.staticData = skillStaticData[data.level] or skillStaticData[1]
  if not IconManager:SetUIIcon(self.staticData.Icon, self.icon) then
    IconManager:SetSkillIcon(self.staticData.Icon, self.icon)
  end
  self.icon:SetMaskPath(UIMaskConfig.SkillMask)
  self.icon.OpenMask = true
  self.icon.OpenCompress = true
  self.level = data.level or 0
  self.lock = data.state or 0
  self.skillId = data.skillId
  if self.lock == 0 then
    self:SetTextureGrey(self.icon)
    self.skillLevelRoot:SetActive(false)
    self.skillLevelLock:SetActive(true)
    self.skillLock:SetActive(true)
    return
  else
    if self.level > 0 then
      self:SetTextureWhite(self.icon)
    else
      self:SetTextureGrey(self.icon)
    end
    self.skillLevelRoot:SetActive(true)
    self.skillLevelLock:SetActive(false)
    self.skillLock:SetActive(false)
  end
  local maxLevel = #skillStaticData
  for i = 1, 3 do
    self.levelIcon[i].gameObject:SetActive(i <= maxLevel)
    if i <= self.level then
      self.levelIcon[i].spriteName = "Sevenroyalfamilies_bg_point1"
    else
      self.levelIcon[i].spriteName = "Sevenroyalfamilies_bg_point2"
    end
  end
  self.levelGrid:Reposition()
  PictureManager.Instance:SetReturnActivityTexture("returnactivity_bg_08", self.chooseTexture)
end

function DetectiveSkillCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end

function DetectiveSkillCell:OnDestroy()
  PictureManager.Instance:UnloadReturnActivityTexture("returnactivity_bg_08", self.chooseTexture)
end
