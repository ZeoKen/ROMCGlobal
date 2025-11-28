local m_photoType = FunctionPhotoStorage.PhotoType.UnionWall
FunctionPhotoStorage.UnionWallType = {
  Personal = 1,
  Senic = 2,
  Senic_Account = 3
}

function FunctionPhotoStorage.GetUnionWallType(source, isAcc)
  if source == ProtoCommon_pb.ESOURCE_PHOTO_SELF then
    return FunctionPhotoStorage.UnionWallType.Personal
  elseif source == ProtoCommon_pb.ESOURCE_PHOTO_SCENERY then
    if isAcc then
      return FunctionPhotoStorage.UnionWallType.Senic_Account
    else
      return FunctionPhotoStorage.UnionWallType.Senic
    end
  end
end

function FunctionPhotoStorage.GetUnionWallPhotoID(uPhotoType, identityID, sid_or_pindex)
  if uPhotoType == FunctionPhotoStorage.UnionWallType.Personal then
    return string.format("%s_%s_p", identityID, sid_or_pindex)
  elseif uPhotoType == FunctionPhotoStorage.UnionWallType.Senic then
    return string.format("%s_%s_s", identityID, sid_or_pindex)
  elseif uPhotoType == FunctionPhotoStorage.UnionWallType.Senic_Account then
    return string.format("%s_%s_s_a", identityID, sid_or_pindex)
  end
end

function FunctionPhotoStorage:RemoveUnionWallPhotoData(uPhotoType, identityID, photoIndex, time)
  self:CancelPhotoUpload(m_photoType, photoIndex, uPhotoType)
  self:CancelPhotoDownload(m_photoType, photoIndex, uPhotoType)
  self:DeleteLocalPhoto(m_photoType, FunctionPhotoStorage.GetUnionWallPhotoID(uPhotoType, identityID, photoIndex), photoIndex, uPhotoType)
end

function FunctionPhotoStorage:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, extension, isThumb)
  local folderPath = isThumb and self.photoThumbPath[m_photoType] or self.photoPath[m_photoType]
  local photoID = FunctionPhotoStorage.GetUnionWallPhotoID(uPhotoType, identityID, photoIndex)
  return string.format("%s/%s/%s%s%s.%s", ApplicationHelper.persistentDataPath, folderPath, photoID, FunctionPhotoStorage.DivideCharacter, timestamp, extension)
end

function FunctionPhotoStorage:GetUnionWallPhotoUrlPath(uPhotoType)
  if uPhotoType == FunctionPhotoStorage.UnionWallType.Personal then
    return self.urlPathMap[self.photoServerType[FunctionPhotoStorage.PhotoType.Personal]]
  elseif uPhotoType == FunctionPhotoStorage.UnionWallType.Senic then
    return self.urlPathMap[self.photoServerType[FunctionPhotoStorage.PhotoType.SceneryRole]]
  elseif uPhotoType == FunctionPhotoStorage.UnionWallType.Senic_Account then
    return self.urlAccPathMap[self.photoServerType[FunctionPhotoStorage.PhotoType.SceneryShare]]
  end
end

function FunctionPhotoStorage:GetUnionWallPhotoDownloadUrl(uPhotoType, identityID, photoIndex, timestamp, extension, isThumb)
  local url = string.format("%s/%s%s/%s.%s", XDCDNInfo.GetFileServerURL(), self:GetUnionWallPhotoUrlPath(uPhotoType), identityID, photoIndex, extension)
  if BranchMgr.IsChina() then
    if isThumb then
      url = url .. "!100"
    end
    return string.format("%s?t=%s", url, timestamp)
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    if isThumb then
      url = url .. "!33"
    end
    return string.format("%s?timestamp=%s", url, timestamp)
  end
  return url
end

function FunctionPhotoStorage:LoadUnionWallPhotoFromLocal(uPhotoType, identityID, photoIndex, timestamp, isThumb, funcOnFinish)
  if not uPhotoType then
    redlog("No Union Wall Photo Type!")
    return
  end
  local path = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  return self:LoadFromLocal(path, funcOnFinish) or uPhotoType ~= FunctionPhotoStorage.UnionWallType.Senic_Account and self:LoadFromLocal(oldPath, funcOnFinish)
end

function FunctionPhotoStorage:GetUnionWallPhoto(uPhotoType, identityID, photoIndex, timestamp, isThumb, funcOnProgress, funcOnFinish)
  if not uPhotoType then
    redlog("No Union Wall Photo Type!")
    return
  end
  local path = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local downloadUrl = self:GetUnionWallPhotoDownloadUrl(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.Extension, isThumb)
  local oldPath = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
  local funcOnLocalLoadFinish = function(bytes)
    if funcOnFinish then
      funcOnFinish(bytes)
    end
    self:SendDownloadFinishMsg(m_photoType, photoIndex, timestamp, isThumb, bytes, uPhotoType)
  end
  if self:LoadFromLocal(path, funcOnLocalLoadFinish) or uPhotoType ~= FunctionPhotoStorage.UnionWallType.Senic_Account and self:LoadFromLocal(oldPath, funcOnLocalLoadFinish) then
    return
  end
  self:DownloadPhoto(m_photoType, photoIndex, timestamp, isThumb, downloadUrl, path, uPhotoType, funcOnProgress, function(bytes, errorMsg)
    if bytes or uPhotoType == FunctionPhotoStorage.UnionWallType.Senic_Account then
      if bytes or not isThumb then
        if funcOnFinish then
          funcOnFinish(bytes, errorMsg)
        end
        return
      end
      local originPath = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.Extension, false)
      if not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originPath, 0.1, funcOnFinish) and funcOnFinish then
        funcOnFinish(bytes, errorMsg)
      end
    else
      local oldDownloadUrl = self:GetUnionWallPhotoDownloadUrl(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.OldExtension, isThumb)
      self:DownloadPhoto(m_photoType, photoIndex, timestamp, isThumb, oldDownloadUrl, oldPath, uPhotoType, funcOnProgress, function(bytes_old, errorMsg_old)
        if bytes_old or not isThumb then
          if funcOnFinish then
            funcOnFinish(bytes_old, errorMsg_old)
          end
          return
        end
        local originPath = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.Extension, false)
        local originOldPath = self:GetUnionWallPhotoPath(uPhotoType, identityID, photoIndex, timestamp, PhotoFileInfo.OldExtension, false)
        if not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originPath, 0.1, funcOnFinish) and not self:GenerateThumbByPath(m_photoType, photoIndex, timestamp, nil, originOldPath, 0.1, funcOnFinish) and funcOnFinish then
          funcOnFinish(bytes_old, errorMsg_old)
        end
      end)
    end
  end)
end

function FunctionPhotoStorage:FindUnionWallPhotoPath(uPhotoType, identityID, photoIndex, isThumb)
  if not uPhotoType then
    redlog("No Union Wall Photo Type!")
    return
  end
  return self:FindPhotoPathFromLocal(m_photoType, FunctionPhotoStorage.GetUnionWallPhotoID(uPhotoType, identityID, photoIndex), isThumb)
end
