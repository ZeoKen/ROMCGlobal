local baseCell = autoImport("BaseCell")
AierBlacksmithDetailSubTabCell = class("AierBlacksmithDetailSubTabCell", baseCell)
AierBlacksmithDetailSubTabCell.ColorTheme = {
  [1] = {
    color = LuaColor.New(1, 1, 1, 1)
  },
  [2] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [3] = {
    color = LuaColor.New(0, 0, 0, 1)
  },
  [4] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  },
  [5] = {
    color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
  }
}

function AierBlacksmithDetailSubTabCell:Init()
  self:initView()
end

function AierBlacksmithDetailSubTabCell:initView()
  self.tabName = self:FindComponent("TabName", UILabel)
  self.check_tabName = self:FindComponent("check_TabName", UILabel)
  self.checkmark = self:FindGO("Checkmark")
  self.bg = self:FindGO("bg")
  self.check_bg = self:FindGO("check_bg")
  self.gotomark = self:FindGO("gotoMark")
end

function AierBlacksmithDetailSubTabCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    self.check_bg:SetActive(isSelected)
    self.bg:SetActive(not isSelected)
    self.check_tabName.gameObject:SetActive(isSelected)
    self.tabName.gameObject:SetActive(not isSelected)
  end
end

function AierBlacksmithDetailSubTabCell:SetData(data)
  self.data = data
  self.tabName.text = data.Text
  self.check_tabName.text = data.Text
  self.gotomark:SetActive(data.Goto ~= nil)
end
