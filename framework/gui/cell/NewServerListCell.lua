local baseCell = autoImport("BaseCell")
autoImport("QuestData")
NewServerListCell = class("NewServerListCell", baseCell)

function NewServerListCell:Init()
  self:initView()
  self:AddCellClickEvent()
end

function NewServerListCell:initView()
  self.serverName = self:FindComponent("ServerName", UILabel)
  self.serverid = self:FindComponent("ServerID", UILabel)
  self.serverStateText = self:FindComponent("ServerStateText", UILabel)
  self.serverStateIcon = self:FindComponent("ServerStateIcon", UISprite)
end

function NewServerListCell:SetData(data)
  self.data = data
  self.serverName.text = data.name
  if data.servertype and data.servertype == "novice" then
    self.serverid.text = ""
  else
    self.serverid.text = data.linegroup
  end
  local spriteName = FunctionLogin.GetStateIcon(data.state)
  if spriteName ~= "" then
    self.serverStateIcon.gameObject:SetActive(true)
    self.serverStateIcon.spriteName = spriteName
    self.serverStateIcon:MakePixelPerfect()
  else
    self.serverStateIcon.gameObject:SetActive(false)
  end
  self.serverName.color = FunctionLogin.GetServerNameColor(data.state)
end
