autoImport("MainViewHeadIconCell")
autoImport("RoleReadyForLogin")
UIListItemViewControllerRoleSlot = class("UIListItemViewControllerRoleSlot", BaseCell)
local universalTable = {}

function UIListItemViewControllerRoleSlot:Init()
  self:GetGameObjects()
  self:RegisterClickEvent()
end

function UIListItemViewControllerRoleSlot:SetData(itemData)
  if itemData ~= nil then
    self.itemData = itemData
    self:GetModel()
    self:LoadView()
  end
end

function UIListItemViewControllerRoleSlot:GetGameObjects()
  self.spAdd = self:FindComponent("SpAdd", UISprite)
  self.spLock = self:FindComponent("SpLock", UISprite)
  self.goRoleIcon = self:FindGO("RoleIcon", self.gameObject)
  self.goLevel = self:FindGO("Level", self.gameObject)
  self.labLevel = self:FindComponent("Lab", UILabel)
  self.goDelete = self:FindGO("Delete", self.gameObject)
  self.labDeleteTime = self:FindComponent("Time", UILabel)
  self.spBG = self:FindComponent("BG", UISprite)
  self.spDeleteTime = self:FindComponent("TimeSprite", UISprite)
  self.selectedEffContainer = self:FindGO("SelectedEff")
end

function UIListItemViewControllerRoleSlot:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:OnClickForView()
  end)
end

function UIListItemViewControllerRoleSlot:OnClickForView()
  EventManager.Me():PassEvent(LoginRoleEvent.UIRoleBeSelected, self)
end

function UIListItemViewControllerRoleSlot:GetModel()
  self.roleID = self.itemData.roleID
  self.index = self.itemData.index
end

function UIListItemViewControllerRoleSlot:LoadView()
  if self:IsLock() then
    self:SetLock()
  elseif self:IsNormal() then
    self:SetNormal()
    self:LoadViewOfRoleDetail()
  elseif self:IsEmpty() then
    self:SetEmpty()
  elseif self:IsDelete() then
    self:SetDelete()
    self:LoadViewOfRoleDetail()
    self:UpdateDeleteLeftTime()
    if self.tick == nil and (self.leftTime == nil or self.leftTime > 0) then
      self.tick = TimeTickManager.Me():CreateTick(0, 1000, self.OnTick, self, 1)
    end
  end
end

function UIListItemViewControllerRoleSlot.ToHMS(pSeconds)
  local hour, minutes, seconds = 0, 0, 0
  if 0 < pSeconds then
    local value = pSeconds
    while 60 <= value do
      value = value - 60
      minutes = minutes + 1
    end
    seconds = value
    value = minutes
    while 60 <= value do
      value = value - 60
      hour = hour + 1
    end
    minutes = value
  end
  return hour, minutes, seconds
end

function UIListItemViewControllerRoleSlot:UpdateDeleteLeftTime()
  if self.leftTime ~= nil then
    return
  end
  if ServerTime.CurServerTime() == nil then
    return
  end
  local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(self.roleID)
  if roleDetail ~= nil then
    self.leftTime = math.floor(ServerTime.ServerDeltaSecondTime(roleDetail.deletetime * 1000))
  end
end

function UIListItemViewControllerRoleSlot:LoadDeleteTime()
  local hour, minutes, seconds = UIListItemViewControllerRoleSlot.ToHMS(self.leftTime)
  if 1 <= hour then
    self.labDeleteTime.text = string.format(ZhString.Hours, hour)
  else
    self.labDeleteTime.text = minutes .. ":" .. seconds
  end
  self.leftHour = hour
  self.leftMinutes = minutes
  self.leftSeconds = seconds
end

function UIListItemViewControllerRoleSlot:LoadViewOfRoleDetail()
  if self.headIconCell == nil then
    self.headIconCell = MainViewHeadIconCell.new()
    self.headIconCell:CreateSelf(self.goRoleIcon)
    local bc = self.headIconCell.gameObject:GetComponent(BoxCollider)
    if bc ~= nil then
      bc.enabled = false
    end
    self.headIconCell:SetMinDepth(2)
    self.headIconCell:SetScale(0.58)
    local goFrame = self:FindGO("Frame", self.headIconCell.gameObject)
    goFrame:SetActive(false)
  end
  local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(self.roleID)
  local afkProxy = AfkProxy.Instance
  local showAfk = afkProxy.isAfk and afkProxy.charId and afkProxy.charId == roleDetail.id and 1 or 0
  if roleDetail.portrait and 0 < roleDetail.portrait then
    local headImageConfig = Table_HeadImage[roleDetail.portrait]
    if headImageConfig then
      self.headIconCell:SetSimpleIcon(headImageConfig.Picture)
      self.headIconCell:SetAfkIcon(showAfk)
    end
  else
    universalTable.hairID = roleDetail.hair
    universalTable.haircolor = roleDetail.haircolor
    local gender = roleDetail.gender
    if gender == ProtoCommon_pb.EGENDER_FEMALE then
      universalTable.gender = RoleConfig.Gender.Female
    elseif gender == ProtoCommon_pb.EGENDER_MALE then
      universalTable.gender = RoleConfig.Gender.Male
    end
    universalTable.bodyID = roleDetail.body
    universalTable.headID = roleDetail.head
    universalTable.faceID = roleDetail.face
    universalTable.mouthID = roleDetail.mouth
    universalTable.eyeID = roleDetail.eye
    universalTable.professionID = roleDetail.profession
    universalTable.id = roleDetail.id
    universalTable.afk = showAfk
    self.headIconCell:SetData(universalTable)
    TableUtility.TableClear(universalTable)
  end
  self.labLevel.text = tostring(roleDetail.baselv)
end

function UIListItemViewControllerRoleSlot:SetNormal(roleID)
  self.spLock.enabled = false
  self.spAdd.enabled = false
  self.goRoleIcon:SetActive(true)
  self.goLevel:SetActive(true)
  self.goDelete:SetActive(false)
  self.spBG.enabled = false
end

function UIListItemViewControllerRoleSlot:SetEmpty()
  self.spLock.enabled = false
  self.spAdd.enabled = true
  self.goRoleIcon:SetActive(false)
  self.goLevel:SetActive(false)
  self.goDelete:SetActive(false)
  self.spBG.enabled = true
end

function UIListItemViewControllerRoleSlot:SetLock()
  self.spLock.enabled = true
  self.spAdd.enabled = false
  self.goRoleIcon:SetActive(false)
  self.goLevel:SetActive(false)
  self.goDelete:SetActive(false)
  self.spBG.enabled = true
end

function UIListItemViewControllerRoleSlot:SetDelete()
  self.spLock.enabled = false
  self.spAdd.enabled = false
  self.goRoleIcon:SetActive(true)
  self.goLevel:SetActive(true)
  self.goDelete:SetActive(true)
  self.spBG.enabled = false
end

function UIListItemViewControllerRoleSlot:SetSelected()
  if not self.isSelected then
    if not Game.GameObjectUtil:ObjectIsNULL(self.selectedEffContainer) then
      self.selectedEffContainer:SetActive(true)
      if not self.selectedEffect and not self.selectedEffectLocked then
        self.selectedEffectLocked = true
        self:PlayUIEffect(EffectMap.UI.RolesListClickEff, self.selectedEffContainer, false, function(obj, args, assetEffect)
          if not self or not self.selectedEffContainer then
            return
          end
          self.selectedEffect = assetEffect
          self.selectedEffectLocked = nil
        end)
      end
    end
    self.isSelected = true
  end
end

function UIListItemViewControllerRoleSlot:CancelSelected()
  if self.isSelected then
    if not Game.GameObjectUtil:ObjectIsNULL(self.selectedEffContainer) then
      self.selectedEffContainer:SetActive(false)
    end
    self.isSelected = false
  end
end

function UIListItemViewControllerRoleSlot:IsEmpty()
  if self.itemData ~= nil then
    if self.itemData.roleID <= 0 and not self.itemData.lock then
      return true
    else
      return false
    end
  else
    return false
  end
end

function UIListItemViewControllerRoleSlot:IsNormal()
  if self.itemData ~= nil then
    if self.itemData.deletetime == 0 then
      return 0 < self.itemData.roleID
    else
      return false
    end
  else
    return false
  end
end

function UIListItemViewControllerRoleSlot:IsLock()
  if self.itemData ~= nil then
    return self.itemData.lock == true
  else
    return false
  end
end

function UIListItemViewControllerRoleSlot:IsDelete()
  if self.itemData ~= nil then
    return self.itemData.deletetime ~= 0
  else
    return false
  end
end

function UIListItemViewControllerRoleSlot:OnTick()
  if self.leftTime == nil then
    self:UpdateDeleteLeftTime()
    return
  end
  if self.leftTime > 0 then
    self.leftTime = self.leftTime - 1
    self:LoadDeleteTime()
  else
    self:OnClickForView()
    self:CloseMyTick()
  end
end

function UIListItemViewControllerRoleSlot:CloseMyTick()
  if self.tick ~= nil then
    TimeTickManager.Me():ClearTick(self, 1)
    self.tick = nil
  end
end

function UIListItemViewControllerRoleSlot:OnCellDestroy()
  if self.selectedEffect then
    self.selectedEffect:Destroy()
    self.selectedEffect = nil
  end
end
