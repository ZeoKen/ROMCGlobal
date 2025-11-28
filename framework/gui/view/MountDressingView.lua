autoImport("MountFashionCell")
autoImport("MountFashionToggleCell")
autoImport("MountFashionActiveMaterialTipCell")
MountDressingView = class("MountDressingView", ContainerView)
local FashionType = {SKIN = 1, SUBPART = 2}
local ToggledCol = "4964bb"
local BgTexName = "tortoise_bg"
local BgTexName_S = "tortoise_bg2"
local BGHeight = {
  [1] = 355,
  [2] = 568
}
local Title = {
  [25229] = ZhString.MountFashion_Tortoise,
  [25234] = ZhString.MountFashion_LandBird
}

function MountDressingView:Init()
  self:AddListenEvts()
  self:InitData()
  self:FindObjs()
  self:InitActiveContainer()
  self:InitView()
  ServiceItemProxy.Instance:CallMountFashionQueryStateCmd(self.mountId)
end

function MountDressingView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ItemMountFashionChangeCmd, self.OnMountFashionChanged)
  self:AddListenEvt(ServiceEvent.ItemMountFashionActiveCmd, self.OnMountFashionActived)
  self:AddListenEvt(ServiceEvent.ItemMountFashionQueryStateCmd, self.OnMountFashionQueryState)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateZeny)
end

function MountDressingView:InitData()
  local mountId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.mountId
  self.mountId = mountId or GameConfig.MountFashion.DefaultFashionMountId
  self.curStyleId = nil
  local categories = Game.MountFashionCategories[self.mountId]
  if not categories then
    redlog("mountId not exists in Table_MountFashion! mountId = ", self.mountId)
    return
  end
  self.categories = {}
  TableUtil.InsertArray(self.categories, categories)
  self.selectedIndex = {}
  local _mountFashionProxy = MountFashionProxy.Instance
  for i = 1, #self.categories do
    local category = self.categories[i]
    self.selectedIndex[i] = _mountFashionProxy:GetEquipedIndex(self.mountId, category)
  end
end

function MountDressingView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  local toggleGrid = self:FindComponent("Toggle", UIGrid)
  self.toggleListCtrl = UIGridListCtrl.new(toggleGrid, MountFashionToggleCell, "MountFashionToggleCell")
  local grid = self:FindComponent("FashionGrid", UIGrid)
  self.fashionListCtrl = UIGridListCtrl.new(grid, MountFashionCell, "MountFashionCell")
  self.fashionListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnFashionClick, self)
  self.changeBtn = self:FindGO("ChangeBtn")
  self:AddClickEvent(self.changeBtn, function()
    self:OnChangeMountFashionClick()
  end)
  self:AddOrRemoveGuideId(self.changeBtn, 530)
  self.changeBtnDisable = self:FindGO("ChangeBtnGrey")
  self.equiped = self:FindGO("EquipedLabel")
  self.touchZone = self:FindGO("touchZone")
  self:AddDragEvent(self.touchZone, function(go, delta)
    self:OnRoleDrag(delta)
  end)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.unlockTipLabel = self:FindComponent("menuDes", UILabel)
  self.costBtn = self:FindGO("CostBtn")
  self:AddClickEvent(self.costBtn, function()
  end)
  self.fashionPanelBg = self:FindGO("FashionPanelBg"):GetComponent(UISprite)
  self.goZenyBalance = self:FindGO("ZenyBalance", self.gameObject)
  self.goLabZenyBalance = self:FindGO("Lab", self.goZenyBalance)
  self.labZenyBalance = self.goLabZenyBalance:GetComponent(UILabel)
  self.spZeny = self:FindGO("Icon", self.goZenyBalance):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.spZeny)
end

function MountDressingView:InitView()
  self.titleLabel.text = Title[self.mountId] or ""
  self:InitToggle()
  self:InitScene()
  self:InitRole()
  self:UpdateZeny()
end

function MountDressingView:InitToggle()
  local datas = ReusableTable.CreateArray()
  for i = 1, #self.categories do
    local data = {}
    data.mountId = self.mountId
    data.category = self.categories[i]
    datas[#datas + 1] = data
  end
  self.toggleListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
  local cells = self.toggleListCtrl:GetCells()
  for i = 1, #cells do
    self:AddTabChangeEvent(cells[i].gameObject, nil, i)
  end
end

function MountDressingView:InitRole()
  local subparts, partColors = {}, {}
  MountFashionProxy.Instance:SetMountSubParts(subparts, self.mountId)
  MountFashionProxy.Instance:SetMountPartColors(partColors, self.mountId)
  self.role = Asset_RolePart.Create(Asset_Role.PartIndex.Mount, self.mountId, function(rolePart, arg, assetRolePart)
    redlog("rolePos", tostring(assetRolePart.args[2]), tostring(self.rolePos.name))
    assetRolePart:ResetParent(self.rolePos.transform)
    local pos = GameConfig.MountFashion.ShowPos and GameConfig.MountFashion.ShowPos[self.mountId] and GameConfig.MountFashion.ShowPos[self.mountId] or LuaGeometry.Const_V3_zero
    assetRolePart:ResetLocalPositionXYZ(pos[1], pos[2], pos[3])
    assetRolePart:SetLayer(Game.ELayer.Outline)
    assetRolePart:ResetLocalEulerAnglesXYZ(0, 180, 0)
    assetRolePart:ResetLocalScaleXYZ(0.6, 0.6, 0.6)
  end, nil, Asset_RolePart.SkinQuality.Bone4, subparts, partColors)
end

function MountDressingView:InitScene()
  self.sceneObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIModel("MountDressingScene"))
  self.sceneObj.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePos = self:FindGO("RolePos", self.sceneObj)
  self.cameraPos = self:FindGO("CameraPos", self.sceneObj).transform
  self.roleBg = self:FindGO("Reloading_BG", self.sceneObj).transform
  UIManagerProxy.Instance:RefitSceneModel(self.cameraPos, self.roleBg)
end

function MountDressingView:OnMountFashionChanged()
  local config = Table_MountFashion[self.curStyleId]
  if config then
    MountFashionProxy.Instance:UpdateMountFashionData(self.mountId, config.Pos, self.curStyleId)
  end
  self:RefreshView(self.curTab)
end

function MountDressingView:OnMountFashionActived()
  MountFashionProxy.Instance:UpdateMountFashionState(self.mountId, self.curStyleId, true)
  self:RefreshView(self.curTab)
end

function MountDressingView:OnMountFashionQueryState()
  self:TabChangeHandler(1)
  self.inited = true
end

function MountDressingView:OnEnter()
  PictureManager.Instance:SetMountFashionTexture(BgTexName, self.bgTex)
  self:OnCameraEnter()
  MountDressingView.super.OnEnter(self)
end

function MountDressingView:OnExit()
  PictureManager.Instance:UnloadMountFashionTexture(BgTexName, self.bgTex)
  self:OnCameraExit()
  MountDressingView.super.OnExit(self)
end

function MountDressingView:OnDestroy()
  if self.role then
    ReusableObject.Destroy(self.role)
    self.role = nil
  end
  if self.effect and self.effect:Alive() then
    self.effect:Destroy()
  end
  self.effect = nil
  if self.sceneObj then
    LuaGameObject.DestroyObject(self.sceneObj)
    self.rolePos = nil
    self.cameraPos = nil
    self.roleBg = nil
  end
  MountDressingView.super.OnDestroy(self)
end

local DefaultCamPos = LuaVector3.Zero()
local DefaultCamRot = LuaQuaternion.Identity()

function MountDressingView:OnCameraEnter()
  self.camera = NGUITools.FindCameraForLayer(Game.ELayer.Default)
  self.cameraController = self.camera:GetComponent(CameraController)
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  end
  LuaVector3.Better_Set(DefaultCamPos, LuaGameObject.GetPositionGO(self.camera.gameObject))
  LuaQuaternion.Better_Set(DefaultCamRot, LuaGameObject.GetRotationGO(self.camera.gameObject))
  self.defaultFov = self.camera.fieldOfView
  self.camera.transform.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.cameraPos))
  self.camera.transform.rotation = LuaGeometry.GetTempQuaternion(LuaGameObject.GetRotation(self.cameraPos))
  self.camera.fieldOfView = 20
end

function MountDressingView:OnCameraExit()
  if self.camera then
    self.camera.transform.position = DefaultCamPos
    self.camera.transform.rotation = DefaultCamRot
    self.camera.fieldOfView = self.defaultFov
  end
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = false
    self.cameraController:InterruptSmoothTo()
    self.cameraController:RestoreDefault(0, nil)
    self.cameraController.enabled = true
  end
end

function MountDressingView:TabChangeHandler(key)
  self.curTab = key
  self:RefreshView(key)
  local _, c = ColorUtil.TryParseHexString(ToggledCol)
  local toggleCells = self.toggleListCtrl:GetCells()
  for i = 1, #toggleCells do
    local sp = toggleCells[i].icon
    if i == key then
      sp.color = c
    else
      sp.color = ColorUtil.NGUIWhite
    end
  end
  MountDressingView.super.TabChangeHandler(self, key)
end

function MountDressingView:RefreshView(tab)
  local toggleCells = self.toggleListCtrl:GetCells()
  local toggleCell = toggleCells[tab]
  local list = MountFashionProxy.Instance:GetFashionList(self.mountId, toggleCell.data.category)
  local datas = ReusableTable.CreateArray()
  for i = 1, #list do
    local data = {
      id = list[i],
      index = i
    }
    datas[#datas + 1] = data
  end
  self.fashionListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
  self:SelectFashion(self.selectedIndex[self.curTab])
end

function MountDressingView:SelectFashion(index)
  local cells = self.fashionListCtrl:GetCells()
  local cell = cells[index]
  if cell then
    self:OnFashionClick(cell)
  end
end

function MountDressingView:OnFashionClick(cell)
  self.curStyleId = cell.id
  redlog("curStyleId", tostring(self.curStyleId))
  self.selectedIndex[self.curTab] = cell.index
  self.isFashionLocked = cell.isLocked
  self.changeBtn:SetActive(not (cell.isEquiped or cell.isLocked) and cell.isActived or false)
  local needMat = MountFashionProxy.Instance:IsFashionNeedCostMaterial(self.curStyleId)
  self.changeBtnDisable:SetActive(not cell.isEquiped and cell.isLocked and not needMat or false)
  local showActive = not cell.isEquiped and needMat and not cell.isActived or false
  self.activeContainer:SetActive(showActive)
  self:SetActivecContainer(showActive)
  self.equiped:SetActive(cell.isEquiped or false)
  self:SetUnlockTipState(cell.isLocked and not needMat or false)
  local cells = self.fashionListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelectState(cells[i] == cell)
  end
  local config = Table_MountFashion[self.curStyleId]
  if config then
    self.nameLabel.text = config.Name
  end
  if self.inited then
    self:RefreshModel(cell.id)
    self:PlayFashionEffect()
    self:PlayRoleAction()
  end
end

function MountDressingView:RefreshModel(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    local type = config.Type
    if type == FashionType.SKIN then
      self:SetSkin(styleId)
    elseif type == FashionType.SUBPART then
      self:SetSubPart(styleId)
    end
    local pos = config.Pos
    local mountId = config.Mount
    if GameConfig.MountFashion.PartAudio[mountId] then
      local audio = GameConfig.MountFashion.PartAudio[mountId][pos]
      if AudioMap.UI[audio] then
        self:PlayUISound(AudioMap.UI[audio])
      else
        LogUtility.ErrorFormat("audio not exist! mountId={0}, pos={1}", mountId, pos)
      end
    end
  end
end

function MountDressingView:SetSkin(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    local skin = config.Skin
    if skin then
      for i = 1, #skin do
        if 0 < skin[i] then
          local partIndex = Asset_Role.EncodeSubPartIndex(Asset_Role.PartIndex.Mount, config.PartIndex[i])
          self.role:ResetPartColor(partIndex, skin[i])
        end
      end
    end
  end
end

function MountDressingView:SetSubPart(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    for i = 1, #config.PartIndex do
      local subPartIndex = config.PartIndex[i]
      local partIndex = Asset_Role.EncodeSubPartIndex(Asset_Role.PartIndex.Mount, subPartIndex)
      local partID = config.PartID[i]
      local skin = config.Skin and config.Skin[i]
      self.role:ResetSubPart(partIndex, partID, skin)
    end
  end
end

function MountDressingView:OnChangeMountFashionClick()
  if self.isFashionLocked then
    return
  end
  local config = Table_MountFashion[self.curStyleId]
  if config then
    redlog("CallMountFashionChangeCmd", tostring(self.mountId), tostring(config.Pos), tostring(self.curStyleId))
    ServiceItemProxy.Instance:CallMountFashionChangeCmd(self.mountId, config.Pos, self.curStyleId)
  end
end

function MountDressingView:OnRoleDrag(delta)
  if self.role then
    self.role:RotateDelta(-delta.x * 360 / 400)
  end
end

function MountDressingView:SetUnlockTipState(state)
  self.unlockTipLabel.gameObject:SetActive(state)
  local config = Table_MountFashion[self.curStyleId]
  local menuId = config and config.MenuID
  local menuConfig = Table_Menu[menuId]
  if menuConfig then
    self.unlockTipLabel.text = menuConfig.text
  end
end

function MountDressingView:PlayFashionEffect()
  if self.effect and self.effect:Alive() then
    self.effect:Destroy()
  end
  self.effect = Asset_Effect.PlayOneShotOn(EffectMap.UI.MountFashionEffect, self.rolePos.transform)
end

local roleActionFinish = function(args)
  local role = args[1]
  local isOnce = args[2]
  if role and isOnce then
    role:PlayAction_Idle()
  end
end

function MountDressingView:PlayRoleAction()
  local config = GameConfig.MountFashion.PartAnim[self.mountId]
  if config then
    if not self.role:GetPartAction() then
      self.role:SetPartAction(true)
    end
    local toggles = self.toggleListCtrl:GetCells()
    local toggle = toggles[self.curTab]
    local actionId = config[toggle.data.category]
    local actionData = Table_ActionAnime[actionId]
    if actionData then
      local args = {
        self.role,
        true
      }
      self.role:PlayAction(actionData.Name, Asset_Role.ActionName.Idle, 1, 0, roleActionFinish, args)
    end
  end
end

function MountDressingView:InitActiveContainer()
  self.activeContainer = self:FindGO("ActiveContainer")
  local grid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(grid, MountFashionActiveMaterialTipCell, "MountFashionActiveMaterialTipCell")
  self.costZeny = self:FindComponent("CostZeny", UILabel)
  self.zenyCtrlSp = self:FindComponent("ZenyCtrl", UISprite)
  local ActiveBtn = self:FindGO("ActiveBtn")
  self.confirmLabel = self:FindComponent("Label", UILabel, ActiveBtn)
  self:AddClickEvent(ActiveBtn, function()
    self:OnActiveBtnClick()
  end)
  self.materials = {}
  self.lackMats = {}
end

function MountDressingView:OnActiveBtnClick()
  self:Confirm()
end

function MountDressingView:Confirm()
  if #self.lackMats > 0 then
    QuickBuyProxy.Instance:TryOpenView(self.lackMats)
  else
    local myMoney = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.costItemId)
    if myMoney < self.cost then
      MsgManager.ShowMsgByID(40803)
    else
      local config = Table_MountFashion[self.curStyleId]
      if config then
        ServiceItemProxy.Instance:CallMountFashionActiveCmd(self.mountId, config.Pos, self.curStyleId)
      end
    end
  end
end

function MountDressingView:OnItemUpdate()
  self:RefreshView(self.curTab)
end

function MountDressingView:RefreshActiveContainer()
  self.materialCtl:ResetDatas(self.materials)
  local _bagProxy = BagProxy.Instance
  TableUtility.ArrayClear(self.lackMats)
  for i = 1, #self.materials do
    local data = self.materials[i]
    local myNum = _bagProxy:GetAllItemNumByStaticID(data.itemId)
    if myNum < data.num then
      self.lackMats[#self.lackMats + 1] = {
        id = data.itemId,
        count = data.num - myNum
      }
      break
    end
  end
  self.confirmLabel.text = #self.lackMats > 0 and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.AstrolabeView_Active
end

function MountDressingView:SetActivecContainer(showActive)
  if showActive then
    local config = Table_MountFashion[self.curStyleId]
    TableUtility.ArrayClear(self.materials)
    if config then
      local materials = config.ActiveMaterial
      self.costItemId = config.ActiveMoneyId or 100
      self.cost = config.ActiveMoney or 0
      if materials then
        for i = 1, #materials do
          local ret = materials[i]
          local data = {}
          data.itemId = ret[1]
          data.num = ret[2]
          self.materials[#self.materials + 1] = data
        end
      end
      IconManager:SetItemIconById(self.costItemId, self.zenyCtrlSp)
      self.costZeny.text = self.cost
      self:RefreshActiveContainer()
    end
    PictureManager.Instance:SetMountFashionTexture(BgTexName_S, self.bgTex)
    self.bgTex:MakePixelPerfect()
    self.fashionPanelBg.height = BGHeight[1]
  else
    PictureManager.Instance:SetMountFashionTexture(BgTexName, self.bgTex)
    self.bgTex:MakePixelPerfect()
    self.fashionPanelBg.height = BGHeight[2]
  end
end

function MountDressingView:UpdateZeny()
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetROB())
  if milCommaBalance then
    self.labZenyBalance.text = milCommaBalance
  else
    self.labZenyBalance.text = "0"
  end
end
