autoImport("PersonalPictureCell")
PostcardListCell = class("PostcardListCell", PersonalPictureCell)

function PostcardListCell:initView()
  PostcardListCell.super.initView(self)
  self.postcardMark = self:FindGO("postcardMark")
  self.postcardMark:SetActive(false)
end

function PostcardListCell:setMode(mode)
  if not self.data then
    return
  end
  self.mode = mode
  self:RefreshStatus()
end

function PostcardListCell:setIsPick(isPick)
  if isPick then
    self:Show(self.pickMark)
  else
    self:Hide(self.pickMark)
  end
end

function PostcardListCell:setDownloadProgress(progress)
  FunctionCloudFile.Me():log("setDownloadProgress:", progress)
  progress = 1 <= progress and 1 or progress
  local value = progress * 100
  value = math.floor(value)
  self.stateDes.text = string.format(ZhString.PersonalPictureCell_Downloading, value)
end

function PostcardListCell:setDownloadFailure()
  self.status = PersonalPictureCell.PhotoStatus.DownloadFailure
  self:RefreshStatus()
end

function PostcardListCell:SetData(data)
  self.data = data
  if not data then
    self:Hide()
    return
  end
  self:Show()
  local time = data.save_time or 0
  local timeStr = os.date("%Y.%m.%d", time)
  if time == 0 then
    timeStr = ZhString.PersonalPictureCell_PictureDesNotime
  end
  self.pictureDesLabel.text = data.senderName or ""
  self.timeLabel.text = timeStr
  self.postcardMark:SetActive(self.data.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL)
  if self.data:Tex_IsLocalRes() then
    self:Show(self.textureCt)
    self.localResTexureName = self.data:Tex_GetLocalResPath()
    PictureManager.Instance:SetPostcardTexture(self.localResTexureName, self.texture)
    self.status = PersonalPictureCell.PhotoStatus.Success
  else
    self:Hide(self.textureCt)
    self.status = PersonalPictureCell.PhotoStatus.Downloading
    self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail, self)
  end
  self:RefreshStatus()
end

function PostcardListCell:setTexture(texture)
  if texture then
    self:Show(self.textureCt)
    self:ClearTheTexture()
    self.texture.mainTexture = texture
    if self.status == PersonalPictureCell.PhotoStatus.Downloading then
      self.status = PersonalPictureCell.PhotoStatus.Success
    end
  else
    self.status = PersonalPictureCell.PhotoStatus.DownloadFailure
  end
  self:RefreshStatus()
end

function PostcardListCell:OnExit()
  self:ClearTheTexture()
  self.super.OnExit(self)
end

function PostcardListCell:ClearTheTexture()
  local tex = self.texture.mainTexture
  if tex then
    if self.localResTexureName then
      PictureManager.Instance:UnloadPostcardTexture(self.localResTexureName, self.texture)
    else
      self.texture.mainTexture = nil
      Object.DestroyImmediate(tex)
    end
  end
end

function PostcardListCell:OnCellDestroy()
  self:ClearTheTexture()
  self.super.OnCellDestroy(self)
end

function PostcardListCell:RefreshStatus()
  if not self.data then
    return
  end
  if self.mode == PersonalPicturePanel.ShowMode.NormalMode then
    self:Hide(self.replaceSp)
    self:Hide(self.delBtn)
    self:Hide(self.cancelBtn)
  elseif self.mode == PersonalPicturePanel.ShowMode.EditorMode then
    self:Hide(self.replaceSp)
    if self.data.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
      self:Hide(self.delBtn)
    else
      self:Show(self.delBtn)
    end
    self:Hide(self.cancelBtn)
  elseif self.mode == PersonalPicturePanel.ShowMode.PickMode then
    self:Hide(self.replaceSp)
    self:Hide(self.delBtn)
    self:Hide(self.cancelBtn)
  else
    if self.data.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
      self:Hide(self.replaceSp)
    else
      self:Show(self.replaceSp)
    end
    self:Hide(self.delBtn)
    self:Hide(self.cancelBtn)
  end
  if self.status == PersonalPictureCell.PhotoStatus.Success then
    self:Hide(self.errorCt)
    self:Hide(self.maskContainer)
  elseif self.status == PersonalPictureCell.PhotoStatus.Downloading then
    self:Show(self.maskContainer)
    self.stateDes.text = ZhString.PersonalPictureCell_LoadingText
    self:Hide(self.errorCt)
  elseif self.status == PersonalPictureCell.PhotoStatus.DownloadFailure then
    self:Hide(self.maskContainer)
    self:Show(self.errorCt)
    self:Show(self.errorTip.gameObject)
    self:Hide(self.reUploadContainer)
  end
end
