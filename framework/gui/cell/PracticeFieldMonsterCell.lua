local BaseCell = autoImport("BaseCell")
PracticeFieldMonsterCell = class("PracticeFieldMonsterCell", BaseCell)

function PracticeFieldMonsterCell:Init()
  self:FindObjs()
end

local monsterTypeIcon = {
  [1] = "Practice-field_icon_life-value",
  [2] = "Practice-field_icon_Magic-attack",
  [3] = "Practice-field_icon_Magic-defense",
  [4] = "Practice-field_icon_Physical-attack",
  [5] = "Practice-field_icon_Physical-defense"
}

function PracticeFieldMonsterCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.statusIcon = self:FindGO("StatusIcon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self.levelLabel = self:FindGO("LevelLabel"):GetComponent(UILabel)
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
end

function PracticeFieldMonsterCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(true)
  self.count.text = self.data.count
  if self.data.id and Table_Monster[self.data.id] then
    local staticData = Table_Monster[self.data.id]
    IconManager:SetFaceIcon(staticData.Icon, self.icon)
    self.levelLabel.text = staticData.Level
    if self.data.type == 0 then
      if self.data.icon and monsterTypeIcon[self.data.icon] then
        self.statusIcon.spriteName = monsterTypeIcon[self.data.icon]
      else
        redlog("缺少怪物类型" .. self.data.icon .. "的配置")
      end
    else
      self.statusIcon.spriteName = "Practice-field_icon_boss"
    end
  end
end
