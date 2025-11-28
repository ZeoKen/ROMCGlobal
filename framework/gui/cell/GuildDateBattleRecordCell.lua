local bgName = {
  default = "com_bg_bottom6",
  highlight = "pvp_yuezhan_bg_01"
}
local stateColor = {going = "D19B0E", default = "497CC2"}
local InviteRed = SceneTip_pb.EREDSYS_GUILD_DATEBATTLE_INVITE
local ReadyRed = SceneTip_pb.EREDSYS_GUILD_DATEBATTLE_READY
local BaseCell = autoImport("BaseCell")
autoImport("GuildHeadData")
GuildDateBattleRecordCell = class("GuildDateBattleRecordCell", BaseCell)

function GuildDateBattleRecordCell:Init()
  self.root = self:FindGO("Root")
  self.bg = self:FindComponent("Bg", UISprite)
  self.dateLab = self:FindComponent("Date", UILabel)
  self.modeLab = self:FindComponent("Mode", UILabel)
  self.stateLab = self:FindComponent("State", UILabel)
  self.guildNameLab = self:FindComponent("GuildName", UILabel)
  self.checkBtn = self:FindComponent("CheckBtn", UIWidget)
  self:SetEvent(self.checkBtn.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.headRoot = self:FindGO("Head")
  self.icon = self:FindComponent("Icon", UISprite, self.headRoot)
  self.customPic = self:FindComponent("CustomPic", UITexture, self.headRoot)
end

function GuildDateBattleRecordCell:SetData(data)
  self.data = data
  if not data then
    self:Hide(self.root)
    self:UnRegisterRedTip()
    return
  end
  self:Show(self.root)
  self.stateLab.text = self.data:GetStateStr()
  self.modeLab.text = self.data:GetModeName()
  self.dateLab.text = self.data:GetDateStampStr()
  self.bg.alpha = self.data:IsDeActive() and 0.5 or 1
  local isGoing = self.data:IsGoing()
  local bgSpriteName = isGoing and bgName.highlight or bgName.default
  local uiAtlas = isGoing and RO.AtlasMap.GetAtlas("NewUI11") or RO.AtlasMap.GetAtlas("NewCom")
  if uiAtlas then
    self.bg.atlas = uiAtlas
    self.bg.spriteName = bgSpriteName
  end
  local state_color = isGoing and stateColor.going or stateColor.default
  local _, c = ColorUtil.TryParseHexString(state_color)
  if _ then
    self.stateLab.color = c
  end
  local name, id, portrait = self.data:GetOppositeGuild()
  self.guildNameLab.text = name
  self:SetGuildIcon(id, portrait)
  self:UnRegisterRedTip()
  self:TryRegisterRedTip()
end

function GuildDateBattleRecordCell:TryRegisterRedTip()
  RedTipProxy.Instance:RegisterUI(ReadyRed, self.checkBtn, 10, {-5, -5}, nil, self.data.id)
  RedTipProxy.Instance:RegisterUI(InviteRed, self.checkBtn, 10, {-5, -5}, nil, self.data.id)
end

function GuildDateBattleRecordCell:UnRegisterRedTip()
  RedTipProxy.Instance:UnRegisterUI(InviteRed, self.checkBtn)
  RedTipProxy.Instance:UnRegisterUI(ReadyRed, self.checkBtn)
end

function GuildDateBattleRecordCell:OnCellDestroy()
  self:UnRegisterRedTip()
end

function GuildDateBattleRecordCell:SetGuildIcon(guildid, portrait)
  local headId = portrait or 1
  local guildHeadData = GuildHeadData.new()
  guildHeadData:SetBy_InfoId(headId)
  guildHeadData:SetGuildId(guildid)
  self.index = guildHeadData.index
  if guildHeadData.type == GuildHeadData_Type.Config then
    local sdata = guildHeadData.staticData
    if sdata then
      self.icon.gameObject:SetActive(true)
      self.customPic.gameObject:SetActive(false)
      IconManager:SetGuildIcon(sdata.Icon, self.icon)
      self.icon.width = 32
      self.icon.height = 32
    end
  elseif guildHeadData.type == GuildHeadData_Type.Custom then
    if not self.customPic then
      return
    end
    self.icon.gameObject:SetActive(false)
    self.customPic.gameObject:SetActive(true)
    local pic = FunctionGuild.Me():GetCustomPicCache(guildHeadData.guildid, guildHeadData.index)
    if pic then
      local time_name = pic.name
      if tonumber(time_name) == guildHeadData.time then
        self.customPic.mainTexture = pic
      else
        self:SetCustomPic(guildHeadData, self.customPic)
      end
    else
      self:SetCustomPic(guildHeadData, self.customPic)
    end
  end
  self.guildHeadData = nil
end

function GuildDateBattleRecordCell:SetCustomPic(data)
  if not data or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(128, 128, TextureFormat.RGB24, false)
    pic.name = data.time
    local bRet = ImageConversion.LoadImage(pic, bytes)
    FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic)
    if self.index == data.index and self.customPic then
      self.customPic.mainTexture = pic
    end
  end
  local pic_type = data.pic_type
  if pic_type == nil or pic_type == "" then
    pic_type = PhotoFileInfo.PictureFormat.JPG
  end
  UnionLogo.Ins():SetUnionID(data.guildid)
  UnionLogo.Ins():GetOriginImage(UnionLogo.CallerIndex.LogoEditor, data.index, data.time, pic_type, nil, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback)
end
