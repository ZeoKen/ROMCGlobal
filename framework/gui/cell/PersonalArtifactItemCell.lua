local _FramentColor = {
  Active = LuaColor.New(0.5019607843137255, 0.8352941176470589, 0.3176470588235294, 1),
  DeActive = LuaColor.New(0.7803921568627451, 0.7803921568627451, 0.7803921568627451, 1)
}
autoImport("BagItemCell")
PersonalArtifactItemCell = class("PersonalArtifactItemCell", BagItemCell)

function PersonalArtifactItemCell:Init()
  local bagItemCell = self:FindGO("Common_BagItemCell")
  if not bagItemCell then
    bagItemCell = self:LoadPreferb("cell/BagItemCell", self.gameObject)
    bagItemCell.name = "BagItemCell"
    bagItemCell.transform.localPosition = LuaGeometry.GetTempVector3()
  end
  PersonalArtifactItemCell.super.Init(self)
  self:FindPersonalArtifactObj()
end

function PersonalArtifactItemCell:FindPersonalArtifactObj()
  self.indexGo = self:FindGO("Index")
  self:InitAddBtn()
end

function PersonalArtifactItemCell:InitAddBtn()
  self.addBtn = self:FindGO("AddBtn")
  if not self.addBtn then
    return
  end
  self:AddClickEvent(self.addBtn, function()
    local guid = PersonalArtifactProxy.Instance:GetRealTargetGuid()
    local artifactID
    if not guid then
      artifactID = PersonalArtifactProxy.Instance:GetCurArtifactID()
    end
    helplog("CallArtifactFlagmentAdd: ", guid, self.fragmentGuid, self.costNum)
    local itemName = self.data and self.data.staticData and self.data.staticData.NameZh or ""
    MsgManager.ConfirmMsgByID(43203, function()
      ServiceItemProxy.Instance:CallArtifactFlagmentAdd(guid, self.fragmentGuid, self.costNum, artifactID)
    end, nil, nil, itemName, itemName)
  end)
end

function PersonalArtifactItemCell:UpdateAddBtn()
  if not self.addBtn then
    return
  end
  self:Hide(self.addBtn)
  if not self.data then
    return
  end
  local staticId = self.data and self.data.staticData and self.data.staticData.id
  if not staticId then
    return
  end
  if not self.framentIndex then
    return
  end
  self.costNum = PersonalArtifactProxy.Instance:GetCostNumByIndex(self.framentIndex)
  local ownNum
  ownNum, self.fragmentGuid = PersonalArtifactProxy.GetFragmentItemNumByStaticId(staticId)
  local inPreview = PersonalArtifactProxy.Instance:IsInPreview()
  self.addBtn:SetActive(not inPreview and ownNum >= self.costNum and not PersonalArtifactProxy.Instance:CheckFragmentActive(staticId))
end

function PersonalArtifactItemCell:SetData(data)
  PersonalArtifactItemCell.super.SetData(self, data)
  self:UpdateState()
  self:UpdateAddBtn()
  if not self.indexGo then
    return
  end
  self.indexGo:SetActive(nil ~= data and nil ~= data.staticData)
end

function PersonalArtifactItemCell:SetIndex(index)
  self.framentIndex = index
end

function PersonalArtifactItemCell:HideIndex()
  if not self.indexGo then
    return
  end
  self:Hide(self.indexGo)
end

function PersonalArtifactItemCell:UpdateState()
  local isInactive = self.data and self.data.CheckPersonalArtifactInActive and self.data:CheckPersonalArtifactInActive()
  self.icon.alpha = isInactive and 0.3 or 1
end
