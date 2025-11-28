local baseCell = autoImport("BaseCell")
QuestManualLabelCell = class("QuestManualLabelCell", baseCell)

function QuestManualLabelCell:Init()
  self:FindObjs()
end

function QuestManualLabelCell:FindObjs()
  self.subTitle = self:FindGO("SubTitle"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self.table = self.gameObject:GetComponent(UITable)
end

function QuestManualLabelCell:SetData(data)
  self.data = data
  self.subTitle.text = self.data.QuestName
  local storyDesc = ""
  local dialogData = DialogUtil.GetDialogData(self.data.Mstory[1])
  local indent = UIUtil.GetIndentString()
  storyDesc = storyDesc .. indent .. OverSea.LangManager.Instance():GetLangByKey(dialogData.Text)
  if data.SubTitle ~= nil then
    storyDesc = storyDesc .. "\n"
  end
  self.desc.text = storyDesc
  UIUtil.FitLableSpaceChangeLine(self.desc)
  self.subTitle.gameObject:SetActive(data.SubTitle ~= nil)
  self.table:Reposition()
end
