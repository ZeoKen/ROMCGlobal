local baseCell = autoImport("BaseCell")
ThanatosGuildCell = class("ThanatosGuildCell", baseCell)

function ThanatosGuildCell:Init()
  self:FindObjs()
  EventManager.Me():AddEventListener(GuildPictureManager.ThumbnailDownloadCompleteCallback, self.HandleGuildIconDownloadComplete, self)
end

function ThanatosGuildCell:FindObjs()
  self.guildname = self:FindGO("guildName"):GetComponent(UILabel)
  self.guildIcon = self:FindGO("guildIcon"):GetComponent(UISprite)
  self.guildIcon_ = self:FindGO("guildIcon_"):GetComponent(UITexture)
  self.time = self:FindGO("time"):GetComponent(UILabel)
end

local TimeFormat = "%Y.%m.%d"

function ThanatosGuildCell:SetData(data)
  self.data = data
  if data then
    self.guildname.text = data.guildname
    if not self:SetGuildIcon() then
      self.guildIcon_.mainTexture = nil
      local guildportrait = tonumber(data.guildportrait) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.guildIcon)
    end
    if self.data.time then
      self.time.text = os.date(TimeFormat, self.data.time)
    end
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function ThanatosGuildCell:SetGuildIcon()
  if self.data and self.data.customIconIndex and self.data.customIconIndex ~= 0 then
    local customicon = self.data.customIconIndex
    local picType = self.data.picType
    if customicon ~= nil then
      self.guildIcon.spriteName = ""
      local texture = GuildPictureManager.Instance():GetThumbnailTexture(self.data.guildid, UnionLogo.CallerIndex.RoleFootDetail, customicon, self.data.customIconUpTime)
      if texture then
        self.guildIcon_.mainTexture = texture
        local lastCustomIconGuildID = self.customIconGuildID
        self.customIconGuildID = self.data.guildid
        if lastCustomIconGuildID ~= self.customIconGuildID then
          if lastCustomIconGuildID then
            GuildPictureManager.Instance():RemoveGuildPicRelative(lastCustomIconGuildID)
          end
          GuildPictureManager.Instance():AddGuildPicRelative(self.customIconGuildID)
        end
      else
        self.guildIcon_.mainTexture = nil
        GuildPictureManager.Instance():AddMyThumbnailInfos({
          {
            callIndex = UnionLogo.CallerIndex.RoleFootDetail,
            guild = self.data.guildid,
            index = customicon,
            time = self.data.customIconUpTime,
            picType = picType
          }
        })
      end
    end
    return true
  end
  return false
end

function ThanatosGuildCell:HandleGuildIconDownloadComplete()
  self:SetGuildIcon()
end

function ThanatosGuildCell:OnCellDestroy()
  if self.customIconGuildID then
    GuildPictureManager.Instance():RemoveGuildPicRelative(self.customIconGuildID)
  end
  self.customIconGuildID = nil
end
