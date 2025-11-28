local BaseCell = autoImport("BaseCell")
PetInfoLabelCell = class("PetInfoLabelCell", BaseCell)
PetInfoLabelCell.Path_PetSkillsCell = ResourcePathHelper.UICell("PetSkillsCell")
PetInfoLabelCell.Type = {
  Attri = 1,
  Skill = 2,
  Diff = 3
}
local DEFAULT_POSITION_X = 396
autoImport("PetSkillsCell")

function PetInfoLabelCell:Init()
  self.type_Attri = self:FindGO("Type_Attri")
  self.type_Skill = self:FindGO("Type_Skill")
  self.type_Diff = self:FindGO("Type_Diff")
  self.tip = self:FindComponent("Tip", UILabel, self.type_Attri)
  self.tipWidth = self.tip.width
  self.value = self:FindComponent("Value", UILabel, self.type_Attri)
  self.diffTip = self:FindComponent("Tip", UILabel, self.type_Diff)
  self.diffOriginalValue = self:FindComponent("OriginalValue", UILabel, self.type_Diff)
  self.diffNewValue = self:FindComponent("NewValue", UILabel, self.type_Diff)
  self.slider = self:FindComponent("Slider", UISlider, self.type_Attri)
end

local tempVector3 = LuaVector3.Zero()
local defaulTipColor = Color(0.2, 0.2, 0.2, 1)
local defaulValueColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function PetInfoLabelCell:SetData(data)
  if data == nil then
    return
  end
  if data[1] == PetInfoLabelCell.Type.Skill then
    if self.skillGO == nil then
      self.skillGO = Game.AssetManager_UI:CreateAsset(self.Path_PetSkillsCell, self.type_Skill)
      self.skillsCell = PetSkillsCell.new(self.skillGO)
      self.skillsCell:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self)
    end
    if data[2] then
      self.skillsCell:SetData(data[2])
    elseif data[3] then
      self.skillsCell:SetData(data[3])
    end
    self.skillsCell:HideLine(data[4])
    self.type_Attri:SetActive(false)
    self.type_Skill:SetActive(true)
    self.type_Diff:SetActive(false)
  elseif data[1] == PetInfoLabelCell.Type.Attri then
    if self.skillGO ~= nil then
      GameObject.Destroy(self.skillGO)
      self.skillsCell = nil
    end
    self.tip.text = data[2]
    self.tip.fontSize = data[5] or 26
    self.type_Attri:SetActive(true)
    self.type_Skill:SetActive(false)
    self.type_Diff:SetActive(false)
    self.value.text = data[3] or ""
    self.value.fontSize = data[5] or 26
    local defaultX = data[4] or DEFAULT_POSITION_X
    tempVector3[1] = defaultX
    self.value.gameObject.transform.localPosition = tempVector3
    if not BranchMgr.IsChina() then
      if self.value.text == "" then
        self.tip.width = 400
        self.tip.fontSize = 20
      else
        self.tip.width = self.tipWidth
      end
    end
    self.tip.color = data[6] or defaulTipColor
    self.value.color = data[7] or defaulValueColor
    self.tip.effectStyle = data[8] or UILabel.Effect.None
    self.value.effectStyle = data[9] or UILabel.Effect.None
    self.tip.effectColor = data[10] or ColorUtil.NGUIBlack
    self.value.effectColor = data[11] or ColorUtil.NGUIBlack
    if data[12] then
      self.slider.gameObject:SetActive(true)
      self.slider.value = data[12]
    else
      self.slider.gameObject:SetActive(false)
    end
  elseif data[1] == PetInfoLabelCell.Type.Diff then
    if self.skillGO ~= nil then
      GameObject.Destroy(self.skillGO)
      self.skillsCell = nil
    end
    self.type_Attri:SetActive(false)
    self.type_Skill:SetActive(false)
    self.type_Diff:SetActive(true)
    self.diffTip.text = data[2]
    self.diffOriginalValue.text = data[3] or ""
    self.diffNewValue.text = data[4] or ""
  end
end

function PetInfoLabelCell:ClickSkill(skillCell)
  self:PassEvent(MouseEvent.MouseClick, skillCell)
end

function PetInfoLabelCell:PlayResetEffect()
  if self.skillsCell then
    local cells = self.skillsCell:GetCells()
    if cells then
      for i = 1, #cells do
        cells[i]:PlayResetEffect()
      end
    end
  end
end
