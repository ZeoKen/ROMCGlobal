autoImport("DialogView")
ExtendDialogView = class("ExtendDialogView", DialogView)
ExtendDialogView.ViewType = UIViewType.DialogLayer
local rootPath = "Public/ExtendDialog/ExtendDialogSlotRoot"
local scaleSpeed = 1
local scaleRatio = 1

function ExtendDialogView:Init()
  ExtendDialogView.super.Init(self)
  self.roleMap = {}
  self.roles = {}
  self.targetScale = {}
  self.originScale = {}
end

function ExtendDialogView:OnEnter()
  self:InitRoleSlot()
  ExtendDialogView.super.OnEnter(self)
  self:AddMonoUpdateFunction(self.Update)
end

function ExtendDialogView:OnExit()
  ExtendDialogView.super.OnExit(self)
  self:ClearRoles()
  self:ClearRoleSlot()
  self:ClearData()
end

function ExtendDialogView:UpdateViewData()
  ExtendDialogView.super.UpdateViewData(self)
  self.isExtendDialog = true
end

function ExtendDialogView:InitRoleSlot()
  if self.extendDialogSlotRoot then
    return
  end
  local asset = Game.AssetManager:Load(rootPath)
  self.extendDialogSlotRoot = GameObject.Instantiate(asset)
  local camera = Camera.main
  self.extendDialogSlotRoot.transform:SetParent(camera.transform)
  self.extendDialogSlotRoot.transform.localPosition = LuaGeometry.GetTempVector3()
  self.extendDialogSlotRoot.transform.localRotation = LuaGeometry.GetTempQuaternion()
  self.roleSlotRoot = self.extendDialogSlotRoot.transform:Find("slotRoot").gameObject
  local childCount = self.roleSlotRoot.transform.childCount
  local width = UIManagerProxy.Instance:GetUIRootSize()[1]
  local curFov = camera.fieldOfView
  local originFov = FunctionMindLocker.Me().isEntered and curFov or 55
  local fovFactor = math.tan(math.rad(originFov / 2)) / math.tan(math.rad(curFov / 2))
  for i = 1, childCount do
    local slot = self.roleSlotRoot.transform:GetChild(i - 1)
    local worldPos = LuaGeometry.TempGetPosition(slot)
    local x, y, z = LuaGameObject.WorldToViewportPointByVector3(camera, worldPos)
    x = 0.5 - (0.5 - x) / 1280 * width
    local vp = LuaGeometry.GetTempVector3(x, y, z)
    worldPos = camera:ViewportToWorldPoint(vp)
    slot.position = worldPos
    local localPos = LuaGeometry.TempGetLocalPosition(slot)
    localPos.z = localPos.z * fovFactor
    slot.localPosition = localPos
    local localEuler = LuaGeometry.TempGetLocalEulerAngles(slot)
    if i <= childCount / 2 then
      localEuler.y = localEuler.y - (curFov - originFov) / 2
    else
      localEuler.y = localEuler.y + (curFov - originFov) / 2
    end
    slot.localEulerAngles = localEuler
  end
  self.background = self.extendDialogSlotRoot.transform:Find("background")
  local localPos = LuaGeometry.TempGetLocalPosition(self.background)
  localPos.z = localPos.z * fovFactor
  self.background.localPosition = localPos
end

function ExtendDialogView:ClearRoleSlot()
  if self.extendDialogSlotRoot then
    GameObject.Destroy(self.extendDialogSlotRoot)
    self.extendDialogSlotRoot = nil
    self.roleSlotRoot = nil
    self.background = nil
  end
end

function ExtendDialogView:ClearRoles()
  TableUtility.TableClear(self.roles)
  TableUtility.TableClearByDeleter(self.roleMap, function(role)
    role:IgnoreTerrainLightColor(false)
    role:SetShadowCastMode(true)
    ReusableObject.Destroy(role)
  end)
end

function ExtendDialogView:ClearData()
  TableUtility.TableClearByDeleter(self.targetScale, function(scale)
    scale:Destroy()
  end)
  TableUtility.TableClear(self.originScale)
end

function ExtendDialogView:ResetViewData()
  ExtendDialogView.super.ResetViewData(self)
  self:ClearRoles()
  self:ClearData()
end

function ExtendDialogView:UpdateDialog(config, tasks)
  ExtendDialogView.super.UpdateDialog(self, config, tasks)
  if self.nowDialogData then
    local dialogId = self.nowDialogData.id
    local extendData = Table_ExtendDialog[dialogId]
    if extendData then
      local npcIds = extendData.npcId
      local offsetX = extendData.offsetX
      local offsetY = extendData.offsetY
      local scales = extendData.scale
      local angleY = extendData.angleY
      local actions = extendData.action
      local expression = extendData.expression
      local once = extendData.isOnce
      if npcIds then
        for slotId, id in pairs(npcIds) do
          if id == -1 then
            self:RemoveRole(slotId)
          end
        end
        local xOffset, yOffset, scale, angle, actionId, expressionId, isOnce
        for slotId, id in pairs(npcIds) do
          if offsetX then
            xOffset = offsetX[id]
          end
          if offsetY then
            yOffset = offsetY[id]
          end
          if scales then
            scale = scales[id]
          end
          if angleY then
            angle = angleY[id]
          end
          if actions then
            actionId = actions[id]
          end
          if expression then
            expressionId = expression[id]
          end
          if once then
            isOnce = once[id] == 1
          end
          local oldNpcId = self.roles[slotId]
          if id ~= -1 and oldNpcId ~= id then
            local oldRole = self.roleMap[oldNpcId]
            if oldRole then
              self:RemoveRole(slotId)
            end
            self:AddRole(slotId, id, xOffset, yOffset, angle, scale, actionId, expressionId, isOnce)
          end
          self:UpdateRole(id, angle, actionId, expressionId, isOnce)
        end
        for _, roleId in pairs(self.roles) do
          self:UpdateSpeaker(roleId)
        end
      end
      if extendData.background then
        local isShowBackground = extendData.background == 1
        self:ShowBackground(isShowBackground)
      end
    end
  end
end

local roleActionFinish = function(guid, args)
  local role = args[1]
  local isOnce = args[2]
  if role and isOnce then
    role:PlayAction_Idle()
  end
end

function ExtendDialogView:UpdateRole(id, angleY, actionId, expressionId, isOnce)
  local role = self.roleMap[id]
  if not role then
    return
  end
  if not role:_IsLoading() then
    self:RolePlayAction(role, actionId, expressionId, isOnce)
  end
  if angleY then
    role:SetEulerAngleY(angleY)
  end
end

function ExtendDialogView:UpdateSpeaker(id)
  local role = self.roleMap[id]
  if not role then
    return
  end
  local scale = self.originScale[id]
  if scale then
    local x, y, z = scale, scale, scale
    local isSpeaker = false
    if self.nowDialogData.Speaker == id then
      x, y, z = x * scaleRatio, y * scaleRatio, z * scaleRatio
      isSpeaker = true
    end
    if not role:_IsLoading() then
      if isSpeaker then
        role:DeactiveMulColor()
      else
        role:ActiveMulColor(LuaGeometry.GetTempColor(0.5, 0.5, 0.5, 1))
      end
    end
    if self.targetScale[id] then
      LuaVector3.Better_Set(self.targetScale[id], x, y, z)
    else
      self.targetScale[id] = LuaVector3.New(x, y, z)
    end
  end
end

function ExtendDialogView:AddRole(slotId, roleId, xOffset, yOffset, angleY, scale, actionId, expressionId, isOnce)
  local role = self.roleMap[roleId]
  if not role then
    local parts
    if 0 < roleId then
      parts = Asset_RoleUtility.CreateNpcRoleParts(roleId)
    elseif roleId == 0 then
      parts = Asset_RoleUtility.CreateMyRoleParts()
    end
    if parts then
      parts[Asset_Role.PartIndexEx.Download] = true
      role = Asset_Role.Create(parts, nil, function(assetRole, roleId)
        assetRole:IgnoreTerrainLightColor(true)
        if self.nowDialogData.Speaker == roleId then
          assetRole:DeactiveMulColor()
        else
          assetRole:ActiveMulColor(LuaGeometry.GetTempColor(0.5, 0.5, 0.5, 1))
        end
        assetRole:RefreshLightMapColor()
        assetRole:SetShadowCastMode(false)
        assetRole:SetWeaponDisplay(true)
        assetRole:SetLayer(LayerMask.NameToLayer("UIModel3D"))
        local modelOutlineLayer = LayerMask.NameToLayer("UIModel3DOutline")
        if assetRole.complete.faceRenderer ~= nil then
          assetRole.complete.faceRenderer.gameObject.layer = modelOutlineLayer
        end
        local hairRender = assetRole.complete:FindRendererByName("hair")
        hairRender = hairRender or assetRole.complete:FindRendererByName("h_")
        if hairRender then
          hairRender.gameObject.layer = modelOutlineLayer
        end
        local sData = Table_Npc[roleId]
        if sData then
          assetRole:SetNpcDefaultExpression(sData.DefaultExpression, sData.ReplaceActionExpresssion)
        end
        self:RolePlayAction(assetRole, actionId, expressionId, isOnce)
      end, roleId)
      self.roleMap[roleId] = role
    end
  end
  if role then
    self:AddRoleToSlot(slotId, role, xOffset, yOffset, angleY, scale)
  end
  self.roles[slotId] = roleId
  if not self.originScale[roleId] then
    self.originScale[roleId] = scale or 1
  end
end

function ExtendDialogView:RemoveRole(slotId)
  self:RemoveRoleFromSlot(slotId)
  self.roles[slotId] = nil
end

function ExtendDialogView:AddRoleToSlot(slotId, role, xOffset, yOffset, angleY, scale)
  if self.roleSlotRoot then
    local slot = self.roleSlotRoot.transform:GetChild(slotId - 1)
    if slot then
      role:SetParent(slot)
      xOffset = xOffset or 0
      yOffset = yOffset or 0
      role:SetPosition(LuaGeometry.GetTempVector3(xOffset, yOffset, 0))
      angleY = angleY or 0
      role:SetEulerAngleY(angleY)
      scale = scale or 1
      role:SetScale(scale)
    end
  end
end

function ExtendDialogView:RemoveRoleFromSlot(slotId)
  local roleId = self.roles[slotId]
  local role = self.roleMap[roleId]
  if role then
    role:SetParent(nil)
    role:SetPosition(LuaGeometry.GetTempVector3(1000, 0, 0))
  end
end

function ExtendDialogView:RolePlayAction(role, actionId, expressionId, isOnce)
  local actionData = Table_ActionAnime[actionId]
  local name = actionData and actionData.Name or Asset_Role.ActionName.Idle
  local params = Asset_Role.GetPlayActionParams(name, Asset_Role.ActionName.Idle, 1)
  params[7] = roleActionFinish
  params[8] = {role, isOnce}
  params[14] = true
  role:PlayAction(params)
  if expressionId then
    role:SetExpression(expressionId, true)
  end
end

function ExtendDialogView:ShowBackground(isShow)
  if not self.background then
    return
  end
  self.background.gameObject:SetActive(isShow)
end

function ExtendDialogView:Update(time, deltaTime)
  for _, id in pairs(self.roles) do
    local targetScale = self.targetScale[id]
    if targetScale then
      local role = self.roleMap[id]
      if role then
        local delta = scaleSpeed * deltaTime
        local currentScale = LuaGeometry.GetTempVector3(role:GetScaleXYZ())
        LuaVector3.SelfMoveTowards(currentScale, targetScale, delta)
        if VectorUtility.AlmostEqual_3(currentScale, targetScale) then
          VectorUtility.Asign_3(currentScale, targetScale)
          VectorUtility.Destroy(targetScale)
          self.targetScale[id] = nil
        end
        role:SetScaleXYZ(currentScale[1], currentScale[2], currentScale[3])
      end
    end
  end
end
