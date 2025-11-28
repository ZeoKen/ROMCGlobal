local baseCell = autoImport("BaseCell")
BattlePassUpgradeDescCell = class("BattlePassUpgradeDescCell", baseCell)

function BattlePassUpgradeDescCell:Init()
  self:FindObjs()
end

function BattlePassUpgradeDescCell:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.titleIcon1 = self:FindGO("picon1")
  self.titleIcon2 = self:FindGO("picon2")
  self.sub1 = self:FindComponent("Sub1", UILabel)
  self.sub2 = self:FindComponent("Sub2", UILabel)
  self.sub3 = self:FindComponent("Sub3", UILabel)
  self.sub4 = self:FindComponent("Sub4", UILabel)
  self.sub5 = self:FindComponent("Sub5", UILabel)
end

function BattlePassUpgradeDescCell:SetData(data)
  self.title.text = data[2] or ""
  self.sub1.text = data[3] or ""
  self.sub1.gameObject:SetActive(data[3] ~= nil)
  self.sub2.text = data[4] or ""
  self.sub2.gameObject:SetActive(data[4] ~= nil)
  self.sub3.text = data[5] or ""
  self.sub3.gameObject:SetActive(data[5] ~= nil)
  self.sub4.text = data[6] or ""
  self.sub4.gameObject:SetActive(data[6] ~= nil)
  self.sub5.text = data[7] or ""
  self.sub5.gameObject:SetActive(data[7] ~= nil)
  self.titleIcon1:SetActive(data[1] == 1)
  self.titleIcon2:SetActive(data[1] == 2)
end
