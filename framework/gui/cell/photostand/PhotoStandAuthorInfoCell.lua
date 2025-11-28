autoImport("SocialBaseCell")
PhotoStandAuthorInfoCell = class("PhotoStandAuthorInfoCell", SocialBaseCell)

function PhotoStandAuthorInfoCell:Init()
  self:FindObjs()
  self:InitShow()
end

function PhotoStandAuthorInfoCell:FindObjs()
  PhotoStandAuthorInfoCell.super.FindObjs(self)
  self.simpleInfoLb = self:FindComponent("SimpleInfoLb", UILabel)
  self.detailInfo = self:FindGO("DetailInfo")
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.emptyGuild = self:FindGO("EmptyGuild")
end

function PhotoStandAuthorInfoCell:InitShow()
  PhotoStandAuthorInfoCell.super.InitShow(self)
end

function PhotoStandAuthorInfoCell:SetData(data)
  if not data or not data.detail_obtained then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  if data.official then
    self.simpleInfoLb.text = GameConfig.PhotoBoard.OUploadText
    self.detailInfo:SetActive(false)
  elseif not data:Author_CanCheckDetail() then
    self.simpleInfoLb.text = GameConfig.PhotoBoard.NoNameText
    self.detailInfo:SetActive(false)
  elseif data:Author_GetAuthorInfo(true) then
    self.simpleInfoLb.text = ""
    self.detailInfo:SetActive(true)
    if not self.headData then
      self.headData = {}
    end
    local data = data:Author_GetAuthorInfoRaw()
    self.TransBySocialData(data, self.headData)
    PhotoStandAuthorInfoCell.super.SetData(self, self.headData)
    if data.guildname ~= "" then
      self:SetGuild(true)
      self.guildName.text = data.guildname
      local guildportrait = tonumber(data.guildportrait) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.guildIcon)
    else
      self:SetGuild(false)
    end
  else
    self.simpleInfoLb.text = ""
    self.detailInfo:SetActive(false)
  end
end

function PhotoStandAuthorInfoCell:SetGuild(isActive)
  self.emptyGuild:SetActive(not isActive)
  self.guildIcon.gameObject:SetActive(isActive)
  self.guildName.gameObject:SetActive(isActive)
end

function PhotoStandAuthorInfoCell.TransBySocialData(data, tempData)
  for k, v in pairs(data) do
    tempData[k] = v
  end
  tempData.bodyID = data.body
  tempData.eyeID = data.eye
  tempData.faceID = data.face
  tempData.frame = data.frame
  tempData.frame = data.frame
  tempData.gender = data.gender
  tempData.hairID = data.hair
  tempData.haircolor = data.haircolor
  tempData.headID = data.head
  tempData.mouthID = data.mouth
  tempData.portraitframe = data.portrait
  tempData.profession = data.profession
end
