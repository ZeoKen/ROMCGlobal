local _Ready_Sp = {
  "com_icon_check",
  "com_icon_off"
}
autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
PveInvitePlayerCell = class("PveInvitePlayerCell", BaseCell)

function PveInvitePlayerCell:Init()
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  self.readySp = self:FindGO("ReadySp"):GetComponent(UISprite)
  self.headContainer = self:FindGO("HeadContainer")
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.headContainer)
  self.headIconCell:SetMinDepth(30)
  self:AddCellClickEvent()
end

function PveInvitePlayerCell:SetData(teamMember)
  self.data = teamMember
  if self.data then
    self.charID = self.data.id
    if self.proColor then
      self.proColor.width = 32
      self.proColor.height = 32
      self.proColor.spriteName = "com_icon_profession"
      self.proColor.transform.localPosition = LuaGeometry.GetTempVector3(0, 4, 0)
    end
    local isOffline = self.data:IsOffline()
    local proData = Table_Class[self.data.profession]
    if proData then
      if IconManager:SetNewProfessionIcon(proData.icon, self.proIcon) then
        self.profession.gameObject:SetActive(true)
        local colorKey = "CareerIconBg" .. proData.Type
        self.proColorSave = ColorUtil[colorKey]
        if isOffline then
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
    local headData = HeadImageData.new()
    headData:TransByTeamMemberData(teamMember)
    local iconData = headData and headData.iconData
    if iconData then
      self.headContainer:SetActive(true)
      if iconData.type == HeadImageIconType.Avatar then
        self.headIconCell:SetData(iconData)
      elseif iconData.type == HeadImageIconType.Simple then
        self.headIconCell:SetSimpleIcon(iconData.icon, iconData.frameType)
        self.headIconCell:SetPortraitFrame(iconData.portraitframe)
      end
      self.headIconCell:SetActive(not isOffline)
    else
      self.headContainer:SetActive(false)
    end
  end
  self:UpdateReadyStatus()
end

function PveInvitePlayerCell:UpdateReadyStatus()
  local replyStatus = FunctionPve.Me():GetReplyStatus(self.charID)
  if nil == replyStatus then
    self:Hide(self.readySp)
  else
    self:Show(self.readySp)
    self.readySp.spriteName = replyStatus and _Ready_Sp[1] or _Ready_Sp[2]
    self.readySp:MakePixelPerfect()
  end
end

function PveInvitePlayerCell:OnCellDestroy()
  self.headIconCell:OnRemove()
end
