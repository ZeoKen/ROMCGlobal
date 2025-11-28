autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
GroupPlayerCell = class("GroupPlayerCell", BaseCell)
local readyicon = "com_icon_check"
local waitingicon = "com_icon_off"

function GroupPlayerCell:Init()
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  self.playername = self:FindGO("name"):GetComponent(UILabel)
  self.check = self:FindGO("check"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function GroupPlayerCell:SetData(data)
  self.data = data
  if self.data then
    self.charID = self.data.id
    if self.proColor then
      self.proColor.width = 32
      self.proColor.height = 32
      self.proColor.spriteName = "com_icon_profession"
      self.proColor.transform.localPosition = LuaGeometry.GetTempVector3(0, 4, 0)
    end
    local proData = Table_Class[self.data.profession]
    if proData then
      if IconManager:SetNewProfessionIcon(proData.icon, self.proIcon) then
        self.profession.gameObject:SetActive(true)
        local colorKey = "CareerIconBg" .. proData.Type
        self.proColorSave = ColorUtil[colorKey]
        if self.data:IsOffline() then
          self.proColor.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
          self.proIcon.color = LuaColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
        else
          self.proColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
          self.proIcon.color = LuaColor(1.0, 1.0, 1.0)
        end
      else
        self.profession.gameObject:SetActive(false)
      end
    end
    self.playername.text = self.data.name
  end
  if self.data:IsRobotMember() then
    self:SetStatus(b)
  else
    self.check.spriteName = ""
  end
end

function GroupPlayerCell:SetStatus(b)
  if b then
    self.check.spriteName = readyicon
  else
    self.check.spriteName = waitingicon
  end
end
