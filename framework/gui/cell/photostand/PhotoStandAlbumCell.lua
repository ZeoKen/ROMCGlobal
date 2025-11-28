local baseCell = autoImport("BaseCell")
PhotoStandAlbumCell = class("PhotoStandAlbumCell", baseCell)
PhotoStandAlbumCell.PhotoStatus = {
  UnderInit = 99999,
  DownloadFailure = 4,
  Success = 5,
  Downloading = 6
}

function PhotoStandAlbumCell:Init()
  PhotoStandAlbumCell.super.Init(self)
  self:initView()
  self:initData()
  self:AddViewEvent()
end

function PhotoStandAlbumCell:AddViewEvent()
  self:AddClickEvent(self:FindGO("background"), function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddCellClickEvent()
end

function PhotoStandAlbumCell:initData()
  self.status = PhotoStandAlbumCell.PhotoStatus.UnderInit
end

function PhotoStandAlbumCell:initView()
  self.dlCt = self:FindGO("dlCt")
  self.reDlContainer = self:FindGO("reDlContainer")
  self:AddClickEvent(self.reDlContainer, function()
    local picData = self.data and self.data.id and self.data.accid and PhotoStandProxy.Instance:_GetPicData(self.data.id, self.data.accid)
    if picData then
      self.status = PhotoStandAlbumCell.PhotoStatus.Downloading
      picData:DownloadTex(true)
    end
  end)
  self.dlTip = self:FindComponent("dlTip", UILabel)
  self.dlTip.text = ZhString.PhotoStandAlbumCell_Init
  self.texture = self:FindGO("texture"):GetComponent(UITextureEx)
  self.textureCt = self:FindGO("textureCt")
end

function PhotoStandAlbumCell:RefreshStatus()
  if self.status == PhotoStandAlbumCell.PhotoStatus.Success then
    self:Hide(self.dlCt)
  elseif self.status == PhotoStandAlbumCell.PhotoStatus.Downloading then
    self.dlTip.text = ZhString.PhotoStandAlbumCell_Dl .. ":" .. self.data.id .. "/" .. self.data.accid
    self:Show(self.dlCt)
    self:Hide(self.reDlContainer)
  elseif self.status == PhotoStandAlbumCell.PhotoStatus.DownloadFailure then
    self:Show(self.dlCt)
    self:Show(self.reDlContainer)
  elseif self.status == PhotoStandAlbumCell.PhotoStatus.UnderInit then
    self.dlTip.text = ZhString.PhotoStandAlbumCell_Init
    self:Show(self.dlCt)
    self:Hide(self.reDlContainer)
  end
end

function PhotoStandAlbumCell:setDownloadProgress(progress)
end

function PhotoStandAlbumCell:setDownloadFailure()
  self.status = PhotoStandAlbumCell.PhotoStatus.DownloadFailure
  self:RefreshStatus()
end

function PhotoStandAlbumCell:SetData(data)
  self.data = data
  if not data then
    self:Hide()
    return
  end
  self:Show()
  self:RefreshCellView()
end

function PhotoStandAlbumCell:RefreshCellView()
  self:Hide(self.textureCt)
  local picData = self.data and self.data.id and self.data.accid and PhotoStandProxy.Instance:_GetPicData(self.data.id, self.data.accid)
  if not picData then
    self.status = PhotoStandAlbumCell.PhotoStatus.UnderInit
    self:RefreshStatus()
    return
  end
  local tex = picData:GetTex()
  if tex then
    self.status = PhotoStandAlbumCell.PhotoStatus.Success
    self:Show(self.textureCt)
    self.texture.mainTexture = tex
  elseif picData.fs_status == PhotoStandPicData.Status.Pending then
    self.status = PhotoStandAlbumCell.PhotoStatus.Downloading
  else
    self.status = PhotoStandAlbumCell.PhotoStatus.DownloadFailure
  end
  self:RefreshStatus()
end

function PhotoStandAlbumCell:OnExit()
  self:ClearTempTexture()
  self.super.OnExit(self)
end

function PhotoStandAlbumCell:ClearTempTexture()
  if self.tempTexture then
    Object.DestroyImmediate(self.tempTexture)
    self.tempTexture = nil
  end
end

function PhotoStandAlbumCell:OnCellDestroy()
  self:ClearTempTexture()
end
