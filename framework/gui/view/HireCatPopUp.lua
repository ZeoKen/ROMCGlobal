autoImport("HireCatSkillCell")
HireCatPopUp = class("HireCatPopUp", BaseView)
HireCatPopUp.ViewType = UIViewType.NormalLayer
local TEXTURE_ARRAY = {
  "shop_bg_02",
  "shop_bg_03",
  "shop_bg_01"
}

function HireCatPopUp:Init()
  self.confirmButton = self:FindGO("ConfirmBtn")
  self.confirmButton_Label = self:FindComponent("Label", UILabel, self.confirmButton)
  self.confirmButton_Label.text = ZhString.HireCatPopUp_Hire
  self:AddClickEvent(self.confirmButton, function(go)
    self:DoHire()
  end)
  local closeButton = self:FindGO("CloseButton")
  local closeButton_Label = self:FindComponent("Label", UILabel, closeButton)
  closeButton_Label.text = ZhString.HireCatPopUp_Cancel
  local hire_1 = self:FindGO("HireDayTog_1")
  local l_zenyIcon = self:FindComponent("Sprite", UISprite, hire_1)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self.hireDay_1_TipLabel = self:FindComponent("TipLabel", UILabel, hire_1)
  self.hireDay_1_Label = self:FindComponent("Label", UILabel, hire_1)
  self.hireDay_1_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 1)
  self.hireDay_1_Label.text = 0
  self.hireDay_1_Tog = self:FindComponent("Tog_1", UIToggle, hire_1)
  local hire_7 = self:FindGO("HireDayTog_7")
  l_zenyIcon = self:FindComponent("Sprite", UISprite, hire_7)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self.hireDay_7_TipLabel = self:FindComponent("TipLabel", UILabel, hire_7)
  self.hireDay_7_Label = self:FindComponent("Label", UILabel, hire_7)
  self.hireDay_7_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 7)
  self.hireDay_7_Label.text = 0
  self.hireDay_7_Tog = self:FindComponent("Tog_7", UIToggle, hire_7)
  self.modelTexture = self:FindComponent("ModelContainer", UITexture)
  local titleObj = self:FindGO("Title")
  self.titleLab = titleObj:GetComponent(UILabel)
  self.descLab = self:FindComponent("Desc", UILabel, titleObj)
  self.name = self:FindComponent("NameLab", UILabel)
  self.pro = self:FindComponent("ProLab", UILabel)
  self.skillIcon = self:FindComponent("SkillIcon", UISprite)
  self.skillName = self:FindComponent("SkillName", UILabel)
  local portrait = self:FindGO("Portrait")
  self.faceCell = PlayerFaceCell.new(portrait)
  self.skllCtl = self:FindComponent("SkillGrid", UIGrid)
  self.skllCtl = UIGridListCtrl.new(self.skllCtl, HireCatSkillCell, "HireCatSkillCell")
  self.bgFrameTexture = self:FindComponent("BgFrame", UITexture)
  self.topTexture = self:FindComponent("TopBg", UITexture)
  self.buttomBgTexture = self:FindComponent("ButtomBg", UITexture)
  self:MapEvent()
end

function HireCatPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.UpdateHirePrice)
end

function HireCatPopUp:UpdateHirePrice(note)
  local data = note.body
  local dataType = data.type
  if dataType == SceneQuest_pb.EOTHERDATA_CAT then
    local ddata = data.data
    local dayType = ddata.param2
    local price = ddata.param3
    if dayType == 1 then
      self.hireDay_1_price = price
      self.hireDay_1_Label.text = price
    elseif dayType == 2 then
      self.hireDay_7_price = price
      self.hireDay_7_Label.text = price
    end
  end
end

function HireCatPopUp:DoHire()
  local hireDay = self.hireDay_1_Tog.value and ScenePet_pb.EEMPLOYTYPE_DAY or ScenePet_pb.EEMPLOYTYPE_WEEK
  ServiceScenePetProxy.Instance:CallHireCatPetCmd(self.catid, hireDay)
  self:CloseSelf()
end

local tempRot = LuaQuaternion()
local tempV3 = LuaVector3(0, -16, 0)

function HireCatPopUp:RefreshMonsterModel(mid)
  local parts = Asset_RoleUtility.CreateMonsterRoleParts(mid)
  if self.role then
    self.role:Redress(parts)
    self:RefreshMonsterModelCallBack()
  else
    UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.Role, nil, nil, nil, nil, function(obj)
      self.role = obj
      UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
      self:RefreshMonsterModelCallBack()
    end)
  end
end

function HireCatPopUp:RefreshMonsterModelCallBack()
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.role:SetRotation(tempRot)
  self.role:PlayAction_AttackIdle()
end

function HireCatPopUp:DestroyRoleModel()
  if self.role then
    self.role = nil
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
    self.modelTexture = nil
  end
end

function HireCatPopUp:OnEnter()
  HireCatPopUp.super.OnEnter(self)
  PictureManager.Instance:SetUI(TEXTURE_ARRAY[1], self.bgFrameTexture)
  PictureManager.Instance:SetUI(TEXTURE_ARRAY[2], self.topTexture)
  PictureManager.Instance:SetUI(TEXTURE_ARRAY[3], self.buttomBgTexture)
  self.catid = self.viewdata and self.viewdata.catid
  if self.catid then
    self.catData = Table_MercenaryCat[self.catid]
    if self.catData then
      self:SetCatInfo()
      self:RefreshMonsterModel(self.catData.MonsterID)
    end
  end
  self.hireDay_1_price = 0
  self.hireDay_7_price = 0
  self.confirmButton_Label.text = self.viewdata.isNewHire and ZhString.HireCatPopUp_NewHire or ZhString.HireCatPopUp_Hire
  ServiceQuestProxy.Instance:CallQueryCatPrice(self.catid, 1)
  ServiceQuestProxy.Instance:CallQueryCatPrice(self.catid, 2)
end

function HireCatPopUp:SetCatInfo()
  self.descLab.text = self.catData.Introduction
  self.titleLab.text = ZhString.HireCatPopUp_Title
  local headImageData = HeadImageData.new()
  local monsterStaticData = Table_Monster[self.catData.MonsterID]
  if not monsterStaticData then
    redlog("佣兵猫ID未在Monster表中找到，ID: ", self.catData.MonsterID)
    return
  end
  headImageData:TransByMonsterData(monsterStaticData)
  self.faceCell:SetData(headImageData)
  self.name.text = monsterStaticData.NameZh
  self.pro.text = OverSea.LangManager.Instance():GetLangByKey(ZhString.ItemTip_Profession) .. OverSea.LangManager.Instance():GetLangByKey(self.catData.Job)
  local mercenaryCat = MercenaryCatProxy.Instance:GetMercenaryCatById(self.catid)
  local skillids = mercenaryCat and mercenaryCat:GetViewSkillTab() or {}
  self.skllCtl:ResetDatas(skillids)
end

function HireCatPopUp:OnExit()
  HireCatPopUp.super.OnExit(self)
  PictureManager.Instance:UnLoadUI()
  self:DestroyRoleModel()
end
