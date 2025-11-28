local baseCell = autoImport("BaseCell")
MainViewChatCell = class("MainViewChatCell", baseCell)

function MainViewChatCell:Init()
  self:FindObjs()
end

function MainViewChatCell:FindObjs()
  self.label = self.gameObject:GetComponent(UILabel)
end

function MainViewChatCell:SetData(data)
  self.label.text = OverseaHostHelper:FilterLangStr((BranchMgr.IsChina() or BranchMgr.IsTW()) and data or string.gsub(data, "：", ":"))
end
