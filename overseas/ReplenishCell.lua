autoImport("BaseCell")
ReplenishCell = class("ReplenishCell", BaseCell)

function ReplenishCell:Init()
  self.idLabel = self:FindGO("index"):GetComponent(UILabel)
  self.orderIdLabel = self:FindGO("orderid"):GetComponent(UILabel)
  self.pLabel = self:FindGO("pLabel"):GetComponent(UILabel)
  self.actionBtn = self:FindGO("actionBtn")
  self:AddClickEvent(self.actionBtn, function(go)
    local serverID = 90001
    if BranchMgr.IsNA() then
      serverID = 96001
    elseif BranchMgr.IsEU() then
      serverID = 72001
    end
  end)
  self.actionLabel = self:FindGO("actionLabel")
end

function ReplenishCell:SetData(data)
  ReplenishCell.super.SetData(self, data)
  self.data = data
  self.idLabel.text = data.id
  self.orderIdLabel.text = data.orderid
  if data.status == 0 then
    self.actionBtn:SetActive(true)
    self.actionLabel:SetActive(false)
  else
    self.actionLabel:SetActive(true)
    self.actionBtn:SetActive(false)
  end
  local conf
  for _, v in pairs(Table_Deposit) do
    if v.ProductID == data.productid then
      conf = v
      break
    end
  end
  local pStr = ZhString.NotFindPrice
  if conf ~= nil then
    pStr = conf.priceStr ~= nil and conf.priceStr or "$" .. conf.Rmb
  end
  self.pLabel.text = pStr
end

function ReplenishCell:number_format(num, deperator)
  local str1 = ""
  local str = tostring(num)
  local strLen = string.len(str)
  if deperator == nil then
    deperator = ","
  end
  deperator = tostring(deperator)
  for i = 1, strLen do
    str1 = string.char(string.byte(str, strLen + 1 - i)) .. str1
    if math.fmod(i, 3) == 0 and strLen - i ~= 0 then
      str1 = "," .. str1
    end
  end
  return str1
end
