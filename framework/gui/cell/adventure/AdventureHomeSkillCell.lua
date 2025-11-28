local baseCell = autoImport("BaseCell")
AdventureHomeSkillCell = class("AdventureHomeSkillCell", baseCell)

function AdventureHomeSkillCell:Init()
  self:FindObjs()
  self:InitEvents()
end

function AdventureHomeSkillCell:FindObjs()
  self.skillItemGO = self:FindGO("SkillItem")
  self.itemContainer = self:FindComponent("ItemContainer", UIWidget, skillItemGO)
  self.skillIcon = self:FindComponent("SkillIcon", UISprite, self.skillItemGO)
  self.name = self:FindComponent("Name", UILabel, skillItemGO)
  self.level = self:FindComponent("Level", UILabel, skillItemGO)
  self.learnedGO = self:FindGO("Learned")
  self.showAllGO = self:FindGO("ShowAllBtn")
end

function AdventureHomeSkillCell:InitEvents()
  self:SetEvent(self.gameObject, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function AdventureHomeSkillCell:SetData(data)
  self.cellData = data
  if data then
    if data.isShowMore then
      if self.showAllGO then
        self.showAllGO:SetActive(true)
      end
      self.learnedGO:SetActive(false)
      self.skillItemGO:SetActive(false)
    elseif data.skillItemData then
      if self.showAllGO then
        self.showAllGO:SetActive(false)
      end
      self.skillItemGO:SetActive(true)
      local skillItemData = data.skillItemData
      if skillItemData.learned then
        self.learnedGO:SetActive(true)
        self.itemContainer.alpha = 0.5
      else
        self.learnedGO:SetActive(false)
        self.itemContainer.alpha = 1
      end
      self:UpdateSkillIcon()
      self.level.text = string.format("Lv.%s", data.unlockLevel or 0)
    end
  end
end

function AdventureHomeSkillCell:UpdateSkillIcon()
  if not self.cellData then
    return
  end
  local skillItemData = self.cellData.skillItemData
  local staticData = skillItemData and skillItemData.staticData
  if staticData then
    local profession = skillItemData.profession
    local professionData = profession and Table_Class[profession]
    local professionType = professionData and professionData.Type or MyselfProxy.Instance:GetMyProfessionType()
    if profession then
      IconManager:SetSkillIconByProfess(staticData.Icon, self.skillIcon, professionType, true)
    else
      IconManager:SetSkillIcon(staticData.Icon, self.skillIcon)
    end
  else
    self.skillIcon.spriteName = nil
  end
end
