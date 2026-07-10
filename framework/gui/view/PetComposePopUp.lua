autoImport("PetComposePreviewCell")
autoImport("PetComposeChooseCell")
autoImport("PetComposeMaterialChooseCell")
PetComposePopUp = class("PetComposePopUp", ContainerView)
PetComposePopUp.ViewType = UIViewType.PopUpLayer
PetComposePopUp.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")
local CFG_FIELD = "MaterialPet"
local packageCheck = GameConfig.PackageMaterialCheck.pet_workspace
local TEX = {
  "pet_bg_bg02",
  "pet_bg_bg03",
  "pet_bg_bg04"
}
local SortPet = function(a, b)
  if a == nil or b == nil then
    return false
  end
  if a.unlocked ~= b.unlocked then
    return a.unlocked
  end
  if a.friendlv ~= b.friendlv then
    return a.friendlv > b.friendlv
  end
  return a.petid < b.petid
end

function PetComposePopUp:Init(parent)
  local petID = self.viewdata.viewdata
  self.petid = petID
  self.staticData = Table_PetCompose[petID]
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:SetData()
end

function PetComposePopUp:FindObjs()
  self.rootIcon = self:FindComponent("Root", UISprite)
  self.starSp = self:FindComponent("StarSp", UISprite)
  if self.starSp then
    self.baseStarWidth = self.starSp.width
  end
  self.composeBtn = self:FindComponent("ComposeBtn", UISprite)
  self.composeLab = self:FindComponent("ComposeLab", UILabel)
  self.costLab = self:FindComponent("CostLab", UILabel)
  self.costIcon = self:FindComponent("CostIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.costIcon)
  self.petChoosePanel = self:FindGO("PetChoosePos")
  self.closePetChoose = self:FindGO("closePetChoose")
  self.petChooseTitle = self:FindComponent("petChooseTitle", UILabel, self.petChoosePanel)
  self.materialItemWrapObj = self:FindGO("MaterialItemWrap", self.petChoosePanel)
  self.effContainer = self:FindGO("EffContainer")
  self.closecomp = self.petChoosePanel:GetComponent(CloseWhenClickOtherPlace)
  self.petChooseNone = self:FindGO("PetChooseNone", self.petChoosePanel)
  self.petChooseNoneTip = self:FindComponent("PetChooseNoneTip", UILabel, self.petChooseNone)
  self.petChooseNoneTip.text = ZhString.PetCompose_NoPet
  self.petbg2 = self:FindComponent("petbg2", UITexture)
  self.petbg3 = self:FindComponent("petbg3", UITexture)
  self.petbg4 = self:FindComponent("petbg4", UITexture)
end

function PetComposePopUp:AddEvts()
  self:AddClickEvent(self.composeBtn.gameObject, function(g)
    self:OnCompose()
  end)
  self:AddClickEvent(self.closePetChoose, function(g)
    self:Hide(self.petChoosePanel)
  end)
end

function PetComposePopUp:InitView()
  PetComposeProxy.Instance:ResetComposeGuilds()
  local PetWrapObj = self:FindGO("PetWrap")
  self.petChooseWrap = PetWrapObj
  local petConfig = {
    wrapObj = PetWrapObj,
    pfbNum = 6,
    cellName = "PetComposeChooseCell",
    control = PetComposeChooseCell,
    dir = 1
  }
  self.petlist = WrapCellHelper.new(petConfig)
  self.petlist:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
  self.petlist:AddEventListener(PetEvent.ClickPetAdventureIcon, self.ShowPetHeadTips, self)
  if self.materialItemWrapObj then
    local itemConfig = {
      wrapObj = self.materialItemWrapObj,
      pfbNum = 6,
      cellName = "PetComposeMaterialChooseCell",
      control = PetComposeMaterialChooseCell,
      dir = 1
    }
    self.materialItemlist = WrapCellHelper.new(itemConfig)
    self.materialItemlist:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenMaterialItemCell, self)
  end
  self:SetComposeBtnState()
  PictureManager.Instance:SetUI(TEX[1], self.petbg2)
  PictureManager.Instance:SetUI(TEX[2], self.petbg3)
  PictureManager.Instance:SetUI(TEX[3], self.petbg4)
end

function PetComposePopUp:SetData()
  if self.staticData then
    local id = self.staticData.id
    IconManager:SetNpcMonsterIconByID(id, self.rootIcon)
    if self.starSp then
      self.starSp.width = self.baseStarWidth * Table_Pet[id].Star
    end
    self.costLab.text = self.staticData.ZenyCost or 0
    local obj = Game.AssetManager_UI:CreateAsset(PetComposePopUp.CellResID, self.gameObject)
    obj.transform.localPosition = LuaGeometry.GetTempVector3(0, -77, 0)
    self.root = PetComposePreviewCell.new(obj, id, false)
    self.root:SetClickEvent(self.HandleComposePreviewClick, self)
  end
end

function PetComposePopUp:HandleComposePreviewClick(data, cellCtl)
  if data and data.__cname == "MaterialItemPart" then
    self:ShowMaterialItemChooseView(data, cellCtl)
  else
    self:ShowPetChooseView(data)
  end
end

function PetComposePopUp:ShowMaterialItemChooseView(partData, cellCtl)
  if partData == nil then
    return
  end
  if not self.materialItemlist then
    MsgManager.FloatMsg(nil, ZhString.PetCompose_NoMaterialItem)
    return
  end
  self.curMaterialPartData = partData
  local items = BagProxy.Instance:GetItemsByStaticID(partData.itemid) or {}
  self:Show(self.petChoosePanel)
  self.petChooseTitle.text = ZhString.PetCompose_ChooseMaterialItem
  self.petChooseWrap:SetActive(false)
  local hasItems = 0 < #items
  self.materialItemWrapObj:SetActive(hasItems)
  self.petChooseNone:SetActive(not hasItems)
  if not hasItems then
    self.petChooseNoneTip.text = ZhString.PetCompose_NoMaterialItem
  end
  if hasItems then
    local needCount = partData.needCount or 1
    local wrapped = {}
    for i = 1, #items do
      wrapped[#wrapped + 1] = {
        item = items[i],
        needCount = needCount
      }
    end
    self.materialItemlist:UpdateInfo(wrapped)
    self.materialItemlist:ResetPosition()
  end
end

function PetComposePopUp:ClickChoosenMaterialItemCell(cellctl)
  local wrap = cellctl and cellctl.data
  local itemData = wrap and wrap.item
  local partData = self.curMaterialPartData
  if not itemData or not partData then
    return
  end
  PetComposeProxy.Instance:SetComposeMaterialItemGuid(itemData.staticData.id, itemData.id)
  if self.root then
    self.root:ResetDatas()
  end
  self:SetComposeBtnState()
  self:Hide(self.petChoosePanel)
end

function PetComposePopUp:ClickChoosenPetCell(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  if not data.unlocked then
    if Table_Pet[data.petid] and Table_Pet[data.petid].ContractSkill and not data:IsContractSkillMaxForCompose() then
      MsgManager.ShowMsgByIDTable(43700)
    end
    return
  end
  local guid = cellctl.data.guid
  PetComposeProxy.Instance:AddComposeGuid(self.curIndex, guid)
  self:Hide(self.petChoosePanel)
  self.root:ResetDatas()
  self:SetComposeBtnState()
end

function PetComposePopUp:ShowPetHeadTips(cellctl)
  if cellctl then
    local stickPos = cellctl.headTipStick
    local tipData = cellctl.data
    TipManager.Instance:ShowPetAdventureHeadTip(tipData, stickPos, NGUIUtil.AnchorSide.Right, {205, -120})
  end
end

function PetComposePopUp:GetPets()
  local allPets = {}
  if not self.curCfg or not self.curCfg.id then
    return allPets
  end
  local needPetId = self.curCfg.id
  local addedGuids = {}
  local AddPetItem = function(item)
    if not item or type(item) ~= "table" then
      return
    end
    local pet = item.petEggInfo
    if not pet or pet.petid ~= needPetId or pet.name == nil or pet.name == "" then
      return
    end
    local guid = item.id or pet.guid
    if not guid or addedGuids[guid] then
      return
    end
    addedGuids[guid] = true
    pet.guid = guid
    pet.unlocked = self:IsUnlock(pet)
    allPets[#allPets + 1] = pet
  end
  local bagPet = BagProxy.Instance:GetMyPetEggs()
  if bagPet then
    for i = 1, #bagPet do
      AddPetItem(bagPet[i])
    end
  end
  local petBagData = BagProxy.Instance.petBagData
  if petBagData then
    local quickPets = petBagData:GetQuickItems()
    if quickPets then
      for i = 1, #quickPets do
        AddPetItem(quickPets[i])
      end
    end
  end
  return allPets
end

function PetComposePopUp:IsUnlock(pet)
  if not pet or not self.curCfg then
    return false
  end
  if pet.petid ~= self.curCfg.id then
    return false
  end
  if self.curCfg.friendlv and self.curCfg.friendlv > pet.friendlv then
    return false
  end
  if not pet:IsContractSkillMaxForCompose() then
    return false
  end
  return true
end

function PetComposePopUp:ShowPetChooseView(data)
  self.curMaterialPartData = nil
  self.curIndex = data.index
  local mat = CFG_FIELD .. self.curIndex
  self.curCfg = self.staticData[mat]
  if not self.curCfg or not self.curCfg.id then
    return
  end
  local pets = self:GetPets()
  self:Show(self.petChoosePanel)
  self.petChooseTitle.text = ZhString.PetAdventure_ChoosePet
  self.materialItemWrapObj:SetActive(false)
  local hasPet = pets and 0 < #pets
  if self.petChooseWrap then
    self.petChooseWrap:SetActive(hasPet)
  end
  self.petChooseNone:SetActive(not hasPet)
  self.petChooseNoneTip.text = ZhString.PetCompose_NoPet
  if hasPet then
    table.sort(pets, function(a, b)
      return SortPet(a, b)
    end)
    self.petlist:UpdateInfo(pets)
    self.petlist:ResetPosition()
  end
end

function PetComposePopUp:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PetComposePopUp:SetComposeBtnState()
  local c = PetComposeProxy.Instance:CanCompose()
  if c then
    ColorUtil.WhiteUIWidget(self.composeBtn)
    ColorUtil.WhiteUIWidget(self.composeLab)
  else
    ColorUtil.ShaderLightGrayUIWidget(self.composeBtn)
    ColorUtil.ShaderLightGrayUIWidget(self.composeLab)
  end
  self.composeLab.effectStyle = c and UILabel.Effect.Outline or UILabel.Effect.None
end

function PetComposePopUp:OnCompose()
  if self.forbiddenFlag then
    return
  end
  local canCompose = PetComposeProxy.Instance:CanCompose()
  if not canCompose then
    return
  end
  if self.staticData.ZenyCost > MyselfProxy.Instance:GetROB() then
    MsgManager.ShowMsgByID(1)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25713)
  if nil == dont then
    MsgManager.DontAgainConfirmMsgByID(25713, function()
      self:_CloseUI()
    end)
  else
    self:_CloseUI()
  end
end

function PetComposePopUp:_CloseUI()
  self.root:PlayComposeEffect()
  self:PlayUIEffect(EffectMap.UI.NewPet, self.effContainer, false)
  self.forbiddenFlag = true
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    local guids = PetComposeProxy.Instance:GetGuids()
    if nil == self.staticData then
      redlog("宠物id未配置在PetCompose", self.petid)
    end
    ServiceScenePetProxy.Instance:CallComposePetCmd(self.staticData.id, guids)
    MsgManager.ShowMsgByID(25714)
    self:CloseSelf()
    self.forbiddenFlag = false
  end, self)
end
