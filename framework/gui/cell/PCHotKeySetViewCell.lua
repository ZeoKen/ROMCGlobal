local baseCell = autoImport("BaseCell")
autoImport("UIAutoScrollCtrl")
PCHotKeySetViewCell = class("PCHotKeySetViewCell", baseCell)
local keyNameColorNormal = LuaColor.New(0.17647058823529413, 0.4, 0.7647058823529411, 1)
local keyNameColorGray = LuaColor.New(0.73, 0.73, 0.73, 1)

function PCHotKeySetViewCell:Init()
  self:FindObjs()
end

function PCHotKeySetViewCell:FindObjs()
  self.nameLb = self:FindGO("Name"):GetComponent(UILabel)
  local namePanel = self:FindComponent("NamePanel", UIPanel)
  local parentPanel = UIUtil.GetComponentInParents(namePanel.gameObject, UIPanel)
  if parentPanel then
    namePanel.depth = parentPanel.depth + 1
  end
  self.nameScroll = namePanel.gameObject:GetComponent(UIScrollView)
  self.nameScrollCtrl = UIAutoScrollCtrl.new(self.nameScroll, self.nameLb)
  self.key1Btn = self:FindGO("Key1Btn")
  self.key1Lb = self:FindGO("Price", self.key1Btn):GetComponent(UILabel)
  self.key1Select = self:FindGO("Select", self.key1Btn)
  self.key1Lock = self:FindGO("Lock", self.key1Btn)
  self.key2Btn = self:FindGO("Key2Btn")
  self.key2Lb = self:FindGO("Price", self.key2Btn):GetComponent(UILabel)
  self.key2Select = self:FindGO("Select", self.key2Btn)
  self.key2Lock = self:FindGO("Lock", self.key2Btn)
  self:AddClickEvent(self.key1Btn, function()
    self:OnSelectKeySlot(1)
  end)
  self:AddClickEvent(self.key2Btn, function()
    self:OnSelectKeySlot(2)
  end)
end

function PCHotKeySetViewCell:OnSelectKeySlot(index)
  if self.isLock then
    MsgManager.ShowMsgByID(43460)
    return
  end
  self:PassEvent(MouseEvent.MouseClick, {self, index})
end

function PCHotKeySetViewCell:SetSelectKeySlot(select, index)
  select = select or false
  if index and 0 < index and index < 3 then
    if index == 1 then
      self.key1Select:SetActive(select)
    elseif index == 2 then
      self.key2Select:SetActive(select)
    end
  else
    self.key1Select:SetActive(select)
    self.key2Select:SetActive(select)
  end
end

local IsKeyCodeNone = function(name)
  if name == nil or name == "" or name == "None" then
    return true
  end
  return false
end
local GetDisplayHotKeyName = function(name)
  if IsKeyCodeNone(name) then
    return ZhString.PCHotKey_KeyCode_None, keyNameColorGray
  end
  local displayName = Game.WindowsHotKeyDisplay[name] and Game.WindowsHotKeyDisplay[name].Display
  name = not StringUtil.IsEmpty(displayName) and displayName or name
  return name, keyNameColorNormal
end

function PCHotKeySetViewCell:SetData(data)
  self.nameScrollCtrl:Stop(true)
  self.data = data
  if data.staticData.LimitType == "inner" then
    self:Hide()
    return
  end
  self:Show()
  self.nameLb.text = data.name
  self.isLock = data.staticData.LimitType == "fixed"
  self.key1Lock:SetActive(self.isLock)
  self.key2Lock:SetActive(self.isLock)
  self.isNone = IsKeyCodeNone(data.hotKey)
  local name, color = GetDisplayHotKeyName(data.hotKey)
  self.key1Lb.text = name
  self.key1Lb.color = color
  name, color = GetDisplayHotKeyName(data.hotKey2)
  self.key2Lb.text = name
  self.key2Lb.color = color
  self:SetSelectKeySlot(data.select > 0, data.select)
  self.nameScrollCtrl:Start(true, true, true)
end
