autoImport("BifrostMatSubmitCell")
BifrostMatSubmitView = class("BifrostMatSubmitView", ContainerView)
BifrostMatSubmitView.ViewType = UIViewType.NormalLayer
local maskReason = PUIVisibleReason.CatLitterBox
local PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.guildBuilding
local CELL_PREFAB_NAME = "GuildBuildingMatSubmitCell"
local DoMask = function(var)
  local _FunctionPlayerUI = FunctionPlayerUI.Me()
  local roles = NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    if var then
      _FunctionPlayerUI:MaskTopFrame(v, maskReason, false)
      _FunctionPlayerUI:MaskNameHonorFactionType(v, maskReason, false)
    else
      _FunctionPlayerUI:UnMaskTopFrame(v, maskReason, false)
      _FunctionPlayerUI:UnMaskNameHonorFactionType(v, maskReason, false)
    end
  end
end
local tempVector3 = LuaVector3.zero

function BifrostMatSubmitView:loadCellPfb()
  local cell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(CELL_PREFAB_NAME))
  if not cell then
    error("can not find cellpfb: " .. CELL_PREFAB_NAME)
    return
  end
  cell.transform:SetParent(self.gameObject.transform, false)
  tempVector3[2] = 206
  cell.transform.localPosition = tempVector3
  return cell
end

function BifrostMatSubmitView:Init()
  self:FindObjs()
  self:MapListenEvt()
  self.actData = FunctionActivity.Me():GetActivityData(ActivityCmd_pb.GACTIVITY_BIFROST)
  self.limitCount = GameConfig.BifrostEventActivity and GameConfig.BifrostEventActivity.DailyContributeMaxCount or 12
  self.clientCfg = GameConfig.BifrostEventActivity and GameConfig.BifrostEventActivity.Contribute_Client or {name = "", icon = ""}
  self:UpdateView()
end

function BifrostMatSubmitView:FindObjs()
  self.nameLv = self:FindComponent("NameLv", UILabel)
  self.buildIcon = self:FindComponent("buildIcon", UISprite)
  self.container = self:FindGO("Container")
  self.statusLab = self:FindComponent("status", UILabel)
  self.processSlider = self:FindComponent("processSlider", UISlider)
  self.submitCount = self:FindComponent("submitCount", UILabel)
  local go = self:loadCellPfb()
  if nil == go then
    return
  end
  self.MatSubmitCell = BifrostMatSubmitCell.new(go)
  self.MatSubmitCell:SetChoosed(0.9, true)
  self.MatSubmitCell:SetMobileScreenAdaptionEnabled(false)
  self.MatSubmitCell.gameObject:AddComponent(CloseWhenClickOtherPlace)
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.SubmitMaterial, self.OnSubmit, self)
  local closecomp = self.MatSubmitCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function closecomp.callBack(go)
    self:_showClickMat(false)
  end
  
  self.MatSubmitCell.gameObject:SetActive(false)
end

function BifrostMatSubmitView:MapListenEvt()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleClose)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleClose)
end

function BifrostMatSubmitView:UpdateUserVar()
  self.bifrost_contributeLimited = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_BIFROST_CONTRIBUTE_DAY) or 0
  self.submitCount.text = string.format(ZhString.GuildBuilding_Submit_Count, self.bifrost_contributeLimited, self.limitCount)
end

function BifrostMatSubmitView:HandleClose(note)
  self:CloseSelf()
end

function BifrostMatSubmitView:HandleBuildingNtf()
  self:UpdataUI()
end

function BifrostMatSubmitView:UpdateView()
  self:UpdateUserVar()
  if nil == self.wrapHelper then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 5,
      cellName = "GuildBuildingMatSubmitCell",
      control = BifrostMatSubmitCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
    self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ReadyChoose, self)
  end
  self:UpdataUI()
end

function BifrostMatSubmitView:ReadyChoose(cellCtl)
  local data = cellCtl and cellCtl.data
  if data then
    self:_showClickMat(false)
    self.clickCell = cellCtl.gameObject
    self:_showClickMat(true)
    self.MatSubmitCell:SetData(data)
  end
end

function BifrostMatSubmitView:_showClickMat(flag)
  if self.clickCell then
    self.clickCell:SetActive(not flag)
  end
  if self.MatSubmitCell then
    self.MatSubmitCell.gameObject:SetActive(flag)
  end
end

function BifrostMatSubmitView:OnSubmit(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  if self.bifrost_contributeLimited >= self.limitCount then
    MsgManager.ShowMsgByID(3702)
    return
  end
  local data = cellCtl.data
  local materialID = data.materials.id
  local needNum = data.materials.count
  local ownCount = BagProxy.Instance:GetItemNumByStaticID(materialID, PACKAGE_MATERIAL)
  if needNum > ownCount then
    MsgManager.ShowMsgByID(8)
    return
  end
  ServiceUserEventProxy.Instance:CallBifrostContributeItemUserEvent(data.id)
end

function BifrostMatSubmitView:UpdataUI()
  local key
  if self.bifrost_contributeLimited < 4 then
    key = 4
  elseif self.bifrost_contributeLimited < 8 then
    key = 8
  else
    key = 12
  end
  self.data = BifrostProxy.Instance:GetMatData(key)
  if nil == self.data or nil == self.data.uiMatData then
    return
  end
  self.wrapHelper:UpdateInfo(self.data.uiMatData)
  self:_showClickMat(false)
  self.nameLv.text = self.clientCfg.name
  IconManager:SetUIIcon(self.clientCfg.icon, self.buildIcon)
  self.statusLab.text = ZhString.GuildBuilding_isBuilding
  if nil == self.actData then
    return
  end
  self.processSlider.value = self.actData:GetProgress() or 1
end

function BifrostMatSubmitView:OnEnter()
  DoMask(true)
  BifrostMatSubmitView.super.OnEnter(self)
  self:DoCameraFocus()
end

function BifrostMatSubmitView:OnExit()
  DoMask(false)
  PictureManager.Instance:UnLoadUI()
  BifrostMatSubmitView.super.OnExit(self)
  self:CameraReset()
end

function BifrostMatSubmitView:DoCameraFocus()
  local npcdata = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  local npcTrans = npcdata and npcdata.assetRole and npcdata.assetRole.completeTransform
  if npcTrans then
    local viewPort, rotation = CameraConfig.BifrostMatSubmit_ViewPort, CameraConfig.BifrostMatSubmit_Rotation
    if viewPort and rotation then
      self:CameraFocusAndRotateTo(npcTrans, viewPort, rotation)
    end
  end
end
