local _ArrayClear = TableUtility.ArrayClear
local _ArrayShallowCopy = TableUtility.ArrayShallowCopy
local _ArrayPushBack = TableUtility.ArrayPushBack
local _GetTempVector3 = LuaGeometry.GetTempVector3
local _ProfessionProxy, _PictureManager
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _GetTempQuaternion = LuaGeometry.GetTempQuaternion
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _SetPositionGO = LuaGameObject.SetPositionGO
local _LuaDestroyObject = LuaGameObject.DestroyObject
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _MyGender, _MyRace
local _SceneName = "Scenesc_chuangjue"
local _EnviromentID = 231
local _Textures = {
  AttrTexture = "login_new_bg_data",
  BtnTexture = "fb_bg_line2"
}
local _SubClassColor = {
  Choose = LuaColor.New(0.2196078431372549, 0.38823529411764707, 0.5294117647058824, 1),
  UnChoose = LuaColor.New(0.8862745098039215, 0.9882352941176471, 1.0, 1)
}
local transferQuestID = 11000001
autoImport("WrapInfiniteListCtrl")
autoImport("TransferClassCell")
TransferProfessionView = class("TransferProfessionView", ContainerView)
TransferProfessionView.ViewType = UIViewType.NormalLayer

function TransferProfessionView:Init()
  _MyGender = MyselfProxy.Instance:GetMySex()
  _MyRace = MyselfProxy.Instance:GetMyRace()
  _ProfessionProxy = ProfessionProxy.Instance
  _PictureManager = PictureManager.Instance
  self:AddEvts()
  ServiceMessCCmdProxy.Instance:CallChooseNewProfessionMessCCmd()
end

function TransferProfessionView:HandleRecvBornProfession()
  self:InitData()
  self:InitScene(function()
    self:InitRight()
    self:InitLeft()
    _PictureManager:SetUI(_Textures.AttrTexture, self.attrTexture)
    _PictureManager:SetUI(_Textures.BtnTexture, self.btnTexture)
    self:FocusCameraToScene()
  end)
end

function TransferProfessionView:InitData()
  _ProfessionProxy:InitFirstTransferClass()
  self.listDatas = _ProfessionProxy:GetGroupClassList()
  self.listSelectionIndexOnEnter = _ProfessionProxy:GetFirstSelectionViewIndex()
  self.subClassList = {}
end

function TransferProfessionView:GoTo()
  local classStaticData = Table_Class[self.staticData.GroupClassID]
  if not classStaticData then
    return
  end
  local className = classStaticData.NameZh
  MsgManager.ConfirmMsgByID(296, function()
    local excuteQuest = self:TransferQuestNotify(true)
    if excuteQuest then
      self:CloseSelf()
      return
    end
    local gomode = self.staticData and self.staticData.Gotomode
    if not gomode then
      return
    end
    FuncShortCutFunc.Me():CallByID(gomode)
    self:CloseSelf()
  end, nil, nil, className)
end

function TransferProfessionView:TryUse()
  local tryPro = self.staticData and self.staticData.id
  if not tryPro then
    return
  end
  if Game.MapManager:IsPVEMode_DemoRaid() then
    ServiceMessCCmdProxy.Instance:CallChooseNewProfessionMessCCmd(nil, tryPro)
    self:TryRunQuestJump(1)
  else
    ProfessionProxy.Instance:SaveChooseClassID(tryPro)
    ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_NEWPRO)
  end
  self:TransferQuestNotify(false)
  self:CloseSelf()
end

function TransferProfessionView:AddEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.MessCCmdChooseNewProfessionMessCCmd, self.HandleRecvBornProfession)
end

function TransferProfessionView:InitLeft()
  local leftRoot = self:FindGO("LeftRoot")
  local listContainer = self:FindGO("ListContainer", leftRoot)
  self.listCtrl = WrapInfiniteListCtrl.new(listContainer, TransferClassCell)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddStoppedMovingCall(self.OnListCtrlStoppedMoving, self)
  self.listCells = self.listCtrl:GetCells()
  self.subClassSelectRoot = self:FindGO("SubClassSelectCtrl", leftRoot)
  self.subClassSelectBtns, self.subClassSps, self.subClassChooses, self.subClassStarSps = {}, {}, {}, {}
  for i = 1, 2 do
    self.subClassSelectBtns[i] = self:FindGO("SubClassSelectBtn" .. i, self.subClassSelectRoot)
    self.subClassSps[i] = self:FindComponent("SubClass" .. i, GradientUISprite, self.subClassSelectBtns[i])
    self.subClassChooses[i] = self:FindGO("SubClassChoose" .. i, self.subClassSelectBtns[i])
    self.subClassStarSps[i] = self:FindGO("SubClassStarSp" .. i, self.subClassSelectBtns[i])
    self:AddClickEvent(self.subClassSelectBtns[i], function()
      self:OnClickSubClassSelectBtn(i)
    end)
  end
  self:InitSelect()
end

function TransferProfessionView:InitRight()
  self.rightRoot = self:FindGO("RightRoot")
  self.classSp = self:FindComponent("ClassSprite", UISprite, self.rightRoot)
  self.profNameLabel = self:FindComponent("ClassName", UILabel, self.rightRoot)
  self:InitPolygon()
  local gotoBtn = self:FindGO("GotoBtn", self.rightRoot)
  local gotoBtnLab = self:FindComponent("Label", UILabel, gotoBtn)
  local gotoBtnBC = gotoBtn:GetComponent(BoxCollider)
  gotoBtnLab.text = ZhString.TransferClass_Go
  self.attriRoot = self:FindGO("AttrRoot", self.rightRoot)
  self.descRoot = self:FindGO("descroot", self.rightRoot)
  self.descContent = self:FindComponent("scrollview/content", UILabel, self.descRoot)
  self.descTags = {}
  for i = 1, 4 do
    self.descTags[i] = {}
    self.descTags[i].go = self:FindGO("taggrid/tag" .. i, self.descroot)
    self.descTags[i].label = self.descTags[i].go:GetComponent(UILabel)
  end
  self.attriToggle = self:FindGO("attritoggle", self.rightRoot)
  self.attriToggle_mark = self:FindGO("mark", self.attriToggle)
  self:AddClickEvent(self.attriToggle, function()
    self:ClickDescToggle(1)
  end)
  self.descToggle = self:FindGO("desctoggle", self.rightRoot)
  self.descToggle_mark = self:FindGO("mark", self.descToggle)
  self:AddClickEvent(self.descToggle, function()
    self:ClickDescToggle(2)
  end)
  local useBtn = self:FindGO("UseBtn", self.rightRoot)
  local useBtnLab = self:FindComponent("Label", UILabel, useBtn)
  local funcGrid = self:FindGO("Funcs"):GetComponent(UIGrid)
  if Game.MapManager:IsRaidMode() then
    gotoBtn:SetActive(false)
    useBtnLab.text = ZhString.TransferClass_TryInRaid
  else
    self:SetTextureWhite(gotoBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
    gotoBtn:SetActive(true)
    useBtnLab.text = ZhString.TransferClass_Try
  end
  funcGrid:Reposition()
  self:AddClickEvent(gotoBtn, function()
    self:GoTo()
  end)
  self.btnTexture = self:FindComponent("BtnTexture", UITexture, self.rightRoot)
  self:AddClickEvent(useBtn, function()
    self:TryUse()
  end)
  self:AddButtonEvent("CloseButton", function()
    self:TransferQuestNotify(false)
    self:TryRunQuestFail()
    self:CloseSelf()
  end)
  self:ClickDescToggle(1)
end

function TransferProfessionView:ClickDescToggle(index)
  if index == 1 then
    self.attriToggle_mark:SetActive(true)
    self.descToggle_mark:SetActive(false)
    self.attriRoot:SetActive(true)
    self.descRoot:SetActive(false)
  else
    self.attriToggle_mark:SetActive(false)
    self.descToggle_mark:SetActive(true)
    self.attriRoot:SetActive(false)
    self.descRoot:SetActive(true)
  end
end

function TransferProfessionView:InitScene(sucCall)
  if self.sceneAdded then
    return
  end
  self.sceneAdded = true
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  SceneProxy.Instance.sceneLoader:AddSubScene(_SceneName, function(sceneName, ret)
    if ret then
      local root = GameObject.Find("sc_chuangjue")
      self.rolePos = self:FindGO("RolePos", root)
      self.cameraPos = self:FindGO("CamerePos", root).transform
      self.recordEnviromentID = Game.MapManager.enviromentManager.baseID
      Game.MapManager:SetEnviroment(_EnviromentID)
      if sucCall then
        sucCall()
      end
    else
      self:CloseSelf()
    end
  end)
end

function TransferProfessionView:InitSelect()
  self.listCtrl:ResetDatas(self.listDatas)
  self.listCtrl:SetStartPositionByIndex(self.listSelectionIndexOnEnter)
  local targetGroup = self.listDatas[self.listSelectionIndexOnEnter]
  for _, cell in pairs(self.listCells) do
    if cell.data == targetGroup then
      self:OnClickListCell(cell)
      break
    end
  end
end

function TransferProfessionView:UpdateRole()
  local parts = Asset_Role.CreatePartArray()
  if not self.assetRole then
    parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
    self.assetRole = Asset_Role_UI.Create(parts)
    self.assetRole:SetParent(self.rolePos.transform, false)
    self.assetRole:SetLayer(Game.ELayer.Outline)
    self.assetRole:SetPosition(_Const_V3_zero)
    self.assetRole:SetEulerAngleY(180)
    self.assetRole:SetScale(1)
    self.assetRole:SetShadowEnable(false)
    self.assetRole:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.assetRole:RegisterWeakObserver(self)
  end
  local classStaticData = Table_Class[self.staticData.id]
  if not classStaticData then
    return
  end
  local classBody = _MyGender == ProtoCommon_pb.EGENDER_MALE and classStaticData.MaleBody or classStaticData.FemaleBody
  parts[_PartIndex.Body] = classBody
  local hair, eye = _ProfessionProxy:GetProfessionRaceFaceInfo(_MyRace)
  parts[_PartIndex.Hair] = hair
  parts[_PartIndex.Eye] = eye
  self.assetRole:Redress(parts, true)
  Asset_Role.DestroyPartArray(parts)
  self.assetRole:SetEpNodesDisplay(true)
  self.assetRole:PlayAction_PlayShow()
end

function TransferProfessionView:DestroyRole()
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:SetEpNodesDisplay(false)
    self.assetRole:Destroy()
  end
  self.assetRole = nil
end

function TransferProfessionView:ObserverDestroyed(obj)
  if self.assetRole == obj then
    self.assetRole:UnregisterWeakObserver(self)
    self.assetRole = nil
  end
end

function TransferProfessionView:ObserverEvent(asset_role, param)
  if asset_role ~= self.assetRole then
    return
  end
  if type(param) ~= "table" then
    return
  end
  local evt, _, part = param[1], param[2], param[3]
  if part == Asset_Role.PartIndex.Body and self.assetRole then
    self.assetRole:PlayAction_PlayShow()
  end
  if evt == Asset_Role_UI_Event.PartCreated then
    UIUtil.NormalizedSortingOrder(partObj)
  elseif evt == Asset_Role_UI_Event.PartCreated then
    UIUtil.RevertSortingOrder(partObj.gameObject)
  end
end

function TransferProfessionView:InitPolygon()
  self.polygonDots = {}
  local attrRoot = self:FindGO("AttrRoot", self.rightRoot)
  self.attrTexture = self:FindComponent("AttrTexture", UITexture, attrRoot)
  local dotRoot = self:FindGO("DotRoot", attrRoot)
  _ArrayPushBack(self.polygonDots, self:FindGO("Str", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Int", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Vit", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Agi", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Dex", dotRoot).transform:GetChild(0))
  _ArrayPushBack(self.polygonDots, self:FindGO("Luk", dotRoot).transform:GetChild(0))
  self.polygon = self:FindComponent("PowerPolyGo", PolygonSprite, attrRoot)
  self.polygon:ReBuildPolygon()
end

function TransferProfessionView:SetPolygon(classid)
  if not classid then
    return
  end
  local config = Table_Class[classid]
  if not config then
    return
  end
  local initialAttr = config.InitialAttr
  if initialAttr and 0 < #initialAttr then
    local v = {}
    for i = 1, #initialAttr do
      v[i] = initialAttr[i].value / 100
      local value = v[i] * 79
      self.polygon:SetLength(i - 1, value)
      self.polygonDots[i].localPosition = _GetTempVector3(value, 0, 0)
    end
  end
end

function TransferProfessionView:SetRightTransferDesc(classid)
  if not classid then
    return
  end
  local config = Table_Class[classid]
  if not config then
    return
  end
  local transferDesc = config.TransferDesc or {
    "Tag1-Tag2-Tag3-Tag4",
    "No Desc."
  }
  local tags = string.split(transferDesc[1], "-")
  for i = 1, 4 do
    if tags[i] then
      self.descTags[i].go:SetActive(true)
      self.descTags[i].label.text = tags[i]
    else
      self.descTags[i].go:SetActive(false)
    end
  end
  self.descContent.text = transferDesc[2]
end

function TransferProfessionView:FocusCameraToScene()
  if self.isCameraOnModel then
    return
  end
  if self.ltInitCamera then
    return
  end
  if not self.cameraWorld or _ObjectIsNull(self.cameraWorld) then
    self.cameraWorld = NGUITools.FindCameraForLayer(Game.ELayer.Default)
    if not self.cameraWorld then
      self.initRetryCount = self.initRetryCount + 1
      if self.initRetryCount > 9 then
        return
      end
      self.ltInitCamera = TimeTickManager.Me():CreateOnceDelayTick(self.initRetryCount * 100, function(owner, deltaTime)
        self.ltInitCamera = nil
        self:FocusCameraToScene()
      end, self, 3)
      return
    end
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.cameraWorld.gameObject:GetComponent(CameraController)
  if not self.cameraController then
    redlog("没有在主摄像机上找到CameraController. Map ID：  ", Game.MapManager:GetMapID())
    return
  end
  self.tsfCameraWorld = self.cameraWorld.transform
  self.fovRecord = self.cameraWorld.fieldOfView
  self.cameraController.applyCurrentInfoPause = true
  self.cameraController.enabled = false
  LuaVector3.Better_Set(self.vecCameraPosRecord, _GetPosition(self.tsfCameraWorld))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, _GetRotation(self.tsfCameraWorld))
  self.tsfCameraWorld.position = _GetTempVector3(_GetPosition(self.cameraPos))
  self.tsfCameraWorld.rotation = _GetTempQuaternion(_GetRotation(self.cameraPos))
  self.cameraWorld.fieldOfView = 35
  self.isCameraOnModel = true
end

function TransferProfessionView:OnExit()
  TransferProfessionView.super.OnExit(self)
  _PictureManager:UnLoadUI(_Textures.AttrTexture, self.attrTexture)
  _PictureManager:UnLoadUI(_Textures.BtnTexture, self.btnTexture)
  self:DestroyRole()
  self:ResetCameraToDefault()
  self:DestroySceneObj()
  self:CameraReset()
  local mapid = Game.MapManager:GetMapID()
  if mapid ~= nil then
    local config = Table_Map[mapid]
    if config ~= nil then
      FunctionChangeScene.Me():ReplaceCurrentBgm(config.NameEn)
    end
  end
end

function TransferProfessionView:ResetCameraToDefault()
  if not self.isCameraOnModel then
    return
  end
  TimeTickManager.Me():ClearTick(self)
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.cameraWorld and not _ObjectIsNull(self.cameraWorld) then
    self.tsfCameraWorld.position = self.vecCameraPosRecord
    self.tsfCameraWorld.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.cameraWorld.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      local mount = BagProxy.Instance.roleEquip:GetMount()
      local vp = nil ~= mount and CameraConfig.UI_WithMount_ViewPort or CameraConfig.UI_ViewPort
      self:CameraRotateToMe(false, vp, nil, nil, 0)
    end
  end
  self.fovRecord = nil
  self.isCameraOnModel = false
end

function TransferProfessionView:DestroySceneObj()
  if not self.sceneAdded then
    return
  end
  self.sceneAdded = nil
  SceneProxy.Instance.sceneLoader:RemoveSubScene(_SceneName)
  if self.recordEnviromentID then
    Game.MapManager:SetEnviroment(self.recordEnviromentID)
    self.recordEnviromentID = nil
  end
  self.rolePos = nil
  self.cameraPos = nil
end

function TransferProfessionView:OnClickListCell(cellCtl)
  local group_classid = cellCtl and cellCtl.data
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(group_classid)
  end
  if self.isOnListCtrlStoppedMoving then
    self.isOnListCtrlStoppedMoving = nil
  else
    self.listCtrl:ScrollTowardsCell(cellCtl)
  end
  self:UpdateSubClassByGroup(group_classid)
  self.staticData = Table_TransferClass[group_classid]
  self:UpdateRight(group_classid)
  self:UpdateSubClassInfo(0)
end

function TransferProfessionView:OnClickSubClassSelectBtn(choose_index)
  if #self.subClassList == 0 then
    self.staticData = Table_TransferClass[self.singleGroupClassID]
    self:UpdateRight(self.singleGroupClassID)
    return
  end
  if choose_index > #self.subClassList then
    return
  end
  local classid = self.subClassList[choose_index]
  self.staticData = Table_TransferClass[classid]
  self:UpdateSubClassInfo(choose_index)
  self:UpdateRight(classid)
end

function TransferProfessionView:UpdateSubClassInfo(choose_index)
  for i = 1, #self.subClassChooses do
    self.subClassChooses[i]:SetActive(i == choose_index)
  end
  for i = 1, #self.subClassStarSps do
    self.subClassStarSps[i]:SetActive(i == choose_index)
  end
  for i = 1, #self.subClassSps do
    self.subClassSps[i].color = i == choose_index and _SubClassColor.Choose or _SubClassColor.UnChoose
  end
end

function TransferProfessionView:UpdateRight(classid)
  IconManager:SetNewProfessionIcon(Table_Class[classid].icon, self.classSp)
  self.profNameLabel.text = ProfessionProxy.GetProfessionName(classid, _MyGender)
  self:SetPolygon(classid)
  self:SetRightTransferDesc(classid)
  self:UpdateRole()
end

function TransferProfessionView:OnListCtrlStoppedMoving(currentCellCtl)
  if not self.firstStopMoving then
    self.firstStopMoving = true
    return
  end
  self.isOnListCtrlStoppedMoving = true
  self:OnClickListCell(currentCellCtl)
end

function TransferProfessionView:UpdateSubClassByGroup(groupid)
  _ArrayClear(self.subClassList)
  local _subClassList = _ProfessionProxy:GetSubClassList(groupid)
  if _subClassList and 0 < #_subClassList then
    self.subClassSelectRoot:SetActive(true)
    _ArrayShallowCopy(self.subClassList, _subClassList)
    local index = 1
    local subCount = #self.subClassList
    for i = 1, subCount do
      local icon_name = Table_Class[self.subClassList[i]].icon
      IconManager:SetNewProfessionIcon(icon_name, self.subClassSps[index])
      index = index + 1
    end
    for i = 1, #self.subClassSelectBtns do
      self.subClassSelectBtns[i]:SetActive(i <= subCount)
    end
  else
    self.subClassSelectRoot:SetActive(false)
    self.singleGroupClassID = groupid
  end
end

function TransferProfessionView:TransferQuestNotify(bool)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(transferQuestID)
  if questData then
    local jumpTarget = self.staticData and self.staticData.id
    if not jumpTarget then
      redlog("Table_TransferClass职业错误")
    end
    if bool then
      ServiceQuestProxy.Instance:CallRunQuestStep(questData.id, jumpTarget, questData.staticData.FinishJump, questData.step)
      return true
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return false
    end
  end
  return false
end

function TransferProfessionView:OnEnter()
  TransferProfessionView.super.OnEnter(self)
  self.questData = self.viewdata.viewdata.questData
  self.questId = self.questData and self.questData.id
end

function TransferProfessionView:TryRunQuestJump(jumpId)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
  if questData then
    local jumpList = questData.params.jump
    if jumpList and 0 < #jumpList and jumpList[jumpId] then
      xdlog("有对应配置 并执行跳转", jumpList[jumpId])
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, jumpList[jumpId])
    end
  end
end

function TransferProfessionView:TryRunQuestFail()
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
  end
end
