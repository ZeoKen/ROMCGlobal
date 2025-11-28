local baseCell = autoImport("BaseCell")
UIViewRolesListMsgCell = class("UIViewRolesListMsgCell", baseCell)

function UIViewRolesListMsgCell:Init()
  self:FindObjs()
end

function UIViewRolesListMsgCell:FindObjs()
  self.textLabel = self:FindGO("Label"):GetComponent(UILabel)
end

function UIViewRolesListMsgCell:SetData(data)
  if data then
    self.textLabel.text = OverseaHostHelper:FilterLangStr((BranchMgr.IsChina() or BranchMgr.IsTW()) and data or string.gsub(data, "ï¼š", ":"))
  end
end
