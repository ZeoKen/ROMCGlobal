autoImport("BaseCell")
MessageCell = class("MessageCell", BaseCell)

function MessageCell:Init()
  self.label = self:FindGO("Label")
  self.labelText = self.label:GetComponent(UILabel)
end

function MessageCell:SetData(data)
  local houseData = HomeProxy.Instance:GetCurHouseData()
  local str = ""
  local name = data.charname
  local msg = data.msg
  if houseData.accid == data.accid then
    str = "[c][1B5EB1]" .. str .. "Re：" .. msg .. "[/c]"
  else
    str = str .. name .. "：" .. msg
  end
  self.labelText.text = str
end
