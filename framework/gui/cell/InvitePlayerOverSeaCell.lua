local baseCell = autoImport("BaseCell")
InvitePlayerOverSeaCell = class("InvitePlayerOverSeaCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function InvitePlayerOverSeaCell:Init()
  InvitePlayerOverSeaCell.super.Init(self)
  self:FindObjs()
  self:InitData()
  self:AddCellClickEvent()
end

function InvitePlayerOverSeaCell:FindObjs()
  self.RoleNameLbl = self:FindGO("Name"):GetComponent(UILabel)
  self.clickUrl = self:FindGO("Name"):GetComponent(UILabelClickUrl)
  self.TimeLbl = self:FindGO("Time"):GetComponent(UILabel)
end

function InvitePlayerOverSeaCell:InitData()
end

function InvitePlayerOverSeaCell:SetData(data)
  self.charid = data.charid
  self.RoleNameLbl.text = string.format("[u][url=%s]%s[/url][/u]", self.charid, AppendSpace2Str(data.name))
  self.TimeLbl.text = ClientTimeUtil.GetFormatTimeStr(data.time)
  if data.portrait ~= nil then
    self:TryInitHeadIcon()
    self.headData = HeadImageData.new()
    self.headData:TransByPortraitData(data.portrait)
    if self.headData.iconData.type == HeadImageIconType.Avatar then
      self.headIcon:SetData(self.headData.iconData)
    elseif self.headData.iconData.type == HeadImageIconType.Simple then
      self.headIcon:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType, self.headData.iconData.isMyself)
      self.headIcon:SetPortraitFrame(self.headData.iconData.portraitframe)
      self.headIcon:SetAfkIcon(self.headData.iconData.afk)
    end
  end
end

function InvitePlayerOverSeaCell:AddCellClickEvent()
  function self.clickUrl.callback(url)
    if url ~= nil and self.charid ~= nil then
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.charid)
    end
  end
end

function InvitePlayerOverSeaCell:TryInitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon:SetIconLoaclPosXYZ(0, 0, 0)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(1)
end
