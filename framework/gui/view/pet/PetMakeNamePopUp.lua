PetMakeNamePopUp = class("PetMakeNamePopUp", BaseView)
PetMakeNamePopUp.ViewType = UIViewType.PopUpLayer

function PetMakeNamePopUp:Init()
  self.nameInput = self:FindComponent("NameInput", UIInput)
  self.nameInputColider = self:FindComponent("NameInput", BoxCollider)
  local limitNum = GameConfig.Pet and GameConfig.Pet.petname_max or 8
  self.nameInput.characterLimit = limitNum
  self.nameTip = self:FindComponent("NameTip", UILabel)
  self.nameTip.text = ZhString.PetMakeNamePopUp_NameTip
  self.nameTipSp = self:FindComponent("NameTip (1)", UISprite)
  self.confirmButton = self:FindGO("ConfirmButton")
  self.modelContainer = self:FindGO("ModelContainer")
  local closeButton = self:FindGO("CloseButton")
  self.cancel_label = self:FindComponent("Label", UILabel, closeButton)
  self.confirm_label = self:FindComponent("Label", UILabel, self.confirmButton)
  self.modelTexture = self.modelContainer:GetComponent(UITexture)
  self.maskTexture = self:FindComponent("MaskTexture", UITexture)
  self.filterType = GameConfig.MaskWord.PetName
  self:AddClickEvent(self.confirmButton, function(go)
    self:DoHatch()
  end)
end

function PetMakeNamePopUp:PreprocessChangeName(petid)
  local forbidden = FunctionPet.Me():IsChangeNameForbidden(petid)
  if forbidden then
    self:Hide(self.nameTip)
    self:Hide(self.nameTipSp)
  else
    self:Show(self.nameTip)
    self:Show(self.nameTipSp)
  end
  self.nameInputColider.enabled = not forbidden
end

function PetMakeNamePopUp:DoHatch()
  local petInfoData = PetProxy.Instance:GetMyPetInfoData()
  if self.etype == 1 then
    if BagProxy.Instance:CheckPetBagIsFull() then
      MsgManager.ShowMsgByID(43465)
      return
    end
    local nameValue = self.nameInput.value
    if nameValue ~= "" then
      if FunctionMaskWord.Me():CheckMaskWord(nameValue, self.filterType) then
        MsgManager.ShowMsgByIDTable(1005)
        return
      end
      local id = self.item.id
      if id == "Fake" then
        local item = FunctionPet.Me():GetNewestEgg(self.item.staticData.id)
        id = item.id
      end
      helplog("Hatch", id)
      ServiceScenePetProxy.Instance:CallEggHatchPetCmd(nameValue, id)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(1006)
    end
  elseif self.etype == 2 then
    local nameValue = self.nameInput.value
    if nameValue ~= "" then
      if FunctionMaskWord.Me():CheckMaskWord(nameValue, self.filterType) then
        MsgManager.ShowMsgByIDTable(1005)
        return
      end
      ServiceScenePetProxy.Instance:CallChangeNamePetCmd(petInfoData.petid, nameValue)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(1006)
    end
  end
end

function PetMakeNamePopUp:UpdateView()
  helplog("PetMakeNamePopUp UpdateView", self.etype)
  local petid
  if self.etype == 1 then
    local item = self.item
    petid = item and item.petEggInfo and item.petEggInfo.petid
    if petid == nil then
      local petData = PetProxy.Instance:GetPetDataByEggID(item.staticData.id)
      if petData then
        petid = petData.id
      end
    end
    self.cancel_label.text = ZhString.PetMakeNamePopUp_PutInBag
    self.confirm_label.text = ZhString.PetMakeNamePopUp_Hatch
  elseif self.etype == 2 then
    petid = self.petid
    self.cancel_label.text = ZhString.PetMakeNamePopUp_Cancle
    self.confirm_label.text = ZhString.PetMakeNamePopUp_Confirm
  end
  self:UpdateModel(petid)
  self:PreprocessChangeName(petid)
end

function PetMakeNamePopUp:UpdateModel(petid)
  helplog("UpdateModel", petid)
  if petid and petid ~= 0 then
    local parts = Asset_RoleUtility.CreateMonsterRoleParts(petid)
    if self.model then
      self.model:Redress(parts)
      self:UpdateModelCallBack(petid)
    else
      UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.PetNamePopUp, nil, nil, nil, nil, function(obj)
        self.model = obj
        UIModelUtil.Instance:ChangeBGMeshRenderer("pet_bg_effect_b", self.modelTexture)
        self:UpdateModelCallBack(petid)
      end)
    end
  else
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
  end
end

function PetMakeNamePopUp:UpdateModelCallBack(petid)
  local monsterData = Table_Monster[petid]
  local petStatic = Table_Pet[petid]
  if nil == petStatic then
    redlog("Pet表未配ID： ", petid)
  end
  self.nameInput.value = OverSea.LangManager.Instance():GetLangByKey(petStatic.Name)
  local scale = monsterData.LoadShowSize or 1
  self.model:SetScale(scale)
  self.model:PlayAction_Idle()
  self.model:SetShadowEnable(false)
end

function PetMakeNamePopUp:OnEnter()
  PetMakeNamePopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.etype = viewdata.etype
  self.item = viewdata.item
  self.petid = viewdata.petid
  PictureManager.Instance:SetUI("pet_bg_effect_a", self.maskTexture)
  self:UpdateView()
end

function PetMakeNamePopUp:OnExit()
  PictureManager.Instance:UnLoadUI("pet_bg_effect_a", self.maskTexture)
  self.modelTexture = nil
  self.model = nil
  PetMakeNamePopUp.super.OnExit(self)
end
