autoImport("RepositoryDragItemCell")
RepositoryBagCell = class("RepositoryBagCell", RepositoryDragItemCell)

function RepositoryBagCell:SetData(data)
  RepositoryBagCell.super.SetData(self, data)
  self:SetCellLock()
end

function RepositoryBagCell:IsLock()
  if self:IsLockByLevel() or self:IsLockByStrength() then
    return true
  end
  local viewTab = RepositoryViewProxy.Instance:GetViewTab()
  if viewTab == RepositoryView.Tab.RepositoryTab then
    if not self.data:CanStorage(BagProxy.BagType.PersonalStorage) then
      return true
    end
  elseif viewTab == RepositoryView.Tab.CommonTab then
    if not self.data:CanStorage(BagProxy.BagType.Storage) then
      return true
    end
  elseif viewTab == RepositoryView.Tab.HomeTab and not self.data:CanStorage(BagProxy.BagType.Home) then
    return true
  end
  return false
end

function RepositoryBagCell:IsLockByLevel()
  return RepositoryViewProxy.Instance:CheckLockByLevel()
end

function RepositoryBagCell:IsLockByStrength()
  return RepositoryViewProxy.Instance:CheckLockByStrength(self.data)
end

function RepositoryBagCell:SetCellLock()
  if self.data then
    self:SetIconGrey(self:IsLock())
  end
end
