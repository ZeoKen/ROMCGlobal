AuthUserCountryCodeCell = class("AuthUserCountryCodeCell", BaseCell)

function AuthUserCountryCodeCell:Init()
  self:FindObjs()
end

function AuthUserCountryCodeCell:FindObjs()
  self.contentLabel = self.gameObject:GetComponent(UILabel)
  self:AddCellClickEvent()
end

function AuthUserCountryCodeCell:SetData(data)
  local countryName = data.countryName
  self.code = data.countryCode
  self.content = string.format(ZhString.AuthUser_CountryCode, countryName, self.code)
  self.contentLabel.text = self.content
end
