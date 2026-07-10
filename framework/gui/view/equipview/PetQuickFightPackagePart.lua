autoImport("CoreView")
PetQuickFightPackagePart = class("PetQuickFightPackagePart", CoreView)
autoImport("BagItemCell")
autoImport("PetBagItemCell")

function PetQuickFightPackagePart:ctor()
end

local PetPackagePart_Path = "GUI/v1/part/PetQuickFightPackagePart"

function PetQuickFightPackagePart:CreateSelf(parent)
  if self.inited == true then
    return
  end
  self.inited = true
  self.gameObject = self:LoadPreferb_ByFullPath(PetPackagePart_Path, parent, true)
  self:UpdateLocalPosCache()
  self:InitPart()
end

function PetQuickFightPackagePart:InitPart()
  self.tipLab = self:FindComponent("Tip", UILabel)
  self.tipLab.text = ZhString.FightPet_Tip
  self.quickGrid = self:FindGO("QuickItemGrid"):GetComponent(UIGrid)
  self.quickItemCtrl = UIGridListCtrl.new(self.quickGrid, PetBagItemCell, "BagItemCell")
  self.quickItemCtrl:SetAddCellHandler(self.HandleAddQuickItemCell, self)
  self.quickItemCtrl:SetNoScrollView(true)
  self.quickItemCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickQuickItemCell, self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
  
  self:MapEvent()
end

function PetQuickFightPackagePart:HandleAddQuickItemCell(cell)
  cell:SetShowMonsterIcon(true)
end

function PetQuickFightPackagePart:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PetQuickFightPackagePart:ClickQuickItemCell(cellCtl)
  local data = cellCtl.data
  if not BagItemCell.CheckData(data) then
    return
  end
  local eggInfo = data.petEggInfo
  if not eggInfo then
    return
  end
  if eggInfo:IsFighting() then
    return
  end
  ServiceScenePetProxy.Instance:CallEggHatchPetCmd(nil, data.id, eggInfo.petid)
end

function PetQuickFightPackagePart:UpdateInfo()
  local petBag = BagProxy.Instance.petBagData
  local quickItems = petBag:GetQuickItems()
  self.quickItemCtrl:ResetDatas(quickItems)
end

local tempV3 = LuaVector3()

function PetQuickFightPackagePart:SetPos(x, y, z)
  if self.gameObject then
    LuaVector3.Better_Set(tempV3, x, y, z)
    self.gameObject.transform.position = tempV3
    self:UpdateLocalPosCache()
  end
end

function PetQuickFightPackagePart:UpdateLocalPosCache()
  self.localPos_x, self.localPos_y, self.localPos_z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
end

function PetQuickFightPackagePart:SetLocalOffset(x, y, z)
  LuaVector3.Better_Set(tempV3, self.localPos_x + x, self.localPos_y + y, self.localPos_z + z)
  self.gameObject.transform.localPosition = tempV3
end

function PetQuickFightPackagePart:MapEvent()
end

function PetQuickFightPackagePart:Show()
  if not self.inited then
    return
  end
  self.gameObject:SetActive(true)
  EventManager.Me():AddEventListener(ItemEvent.PetUpdate, self.UpdateInfo, self)
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.UpdateInfo, self)
  EventManager.Me():AddEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():AddEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
  self:UpdateInfo()
  self.quickItemCtrl:ResetPosition()
end

function PetQuickFightPackagePart:Hide()
  if not self.inited then
    return
  end
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_PET)
  self.gameObject:SetActive(false)
  EventManager.Me():RemoveEventListener(ItemEvent.PetUpdate, self.UpdateInfo, self)
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.UpdateInfo, self)
  EventManager.Me():RemoveEventListener(UICloseEvent.PetPackagePopViewClose, self.ResetClosecomp, self)
  EventManager.Me():RemoveEventListener(PetEvent.CallbackPetConfirm, self.HandleEnableCloseComp, self)
end

function PetQuickFightPackagePart:ResetClosecomp()
  self:HandleEnableCloseComp(true)
end

function PetQuickFightPackagePart:HandleEnableCloseComp(var)
  self.closecomp.enabled = var
end
