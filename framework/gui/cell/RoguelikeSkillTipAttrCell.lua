RoguelikeSkillTipAttrCell = class("RoguelikeSkillTipAttrCell", BaseCell)
local PurpleLv = 5
local OrangeLv = 10
local NormalColor = "4571c2"
local PurpleColor = "aa65be"
local OrangeColor = "e38445"
local SpecialColor = {
  [PurpleLv] = PurpleColor,
  [OrangeLv] = OrangeColor
}

function RoguelikeSkillTipAttrCell:Init()
  self:FindObjs()
end

function RoguelikeSkillTipAttrCell:FindObjs()
  self.attrLabel = self.gameObject:GetComponent(UILabel)
  self.levelBg = self:FindComponent("LevelBg", UISprite)
  self.levelLabel = self:FindComponent("Level", UILabel)
end

function RoguelikeSkillTipAttrCell:SetData(data)
  self.data = data
  if data then
    local colStr = NormalColor
    if SpecialColor[data.SkillLevel] then
      colStr = SpecialColor[data.SkillLevel]
    end
    local _, c = ColorUtil.TryParseHexString(colStr)
    self.levelBg.color = c
    self.levelLabel.text = string.format(ZhString.RoguelikeSkill_Level, data.SkillLevel)
    local str = data.SkillAttrDesc
    if data.CurDescVal and data.CurDescVal ~= _EmptyTable then
      str = string.format(str, unpack(data.CurDescVal))
    end
    self.attrLabel.text = str
  end
end
