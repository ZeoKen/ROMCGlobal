DetectiveFilePage = class("DetectiveFilePage", SubView)
DetectiveFilePage.ViewType = UIViewType.NormalLayer
autoImport("FileTipCell")
local viewPath = ResourcePathHelper.UIView("DetectiveFilePage")
local relationShopMapPath = ResourcePathHelper.UIView("SevenRoyalFamiliesRelationShopMap")
local textureDecoratePath = "Sevenroyalfamilies_bg_decoration"
local tempScale = LuaVector3.One()
local posVec = LuaVector3.Zero()
local decorateTextureNameMap = {
  Decorate15 = "Sevenroyalfamilies_bg_decoration15",
  Decorate14 = "Sevenroyalfamilies_bg_decoration14",
  Decorate15_2 = "Sevenroyalfamilies_bg_decoration15",
  Decorate13 = "Sevenroyalfamilies_bg_decoration13",
  FileTexture = "Sevenroyalfamilies_bg_bottom3"
}
local decorateCommonMap = {
  DecorateBG3 = "calendar_bg1_picture2"
}
local picIns = PictureManager.Instance

function DetectiveFilePage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function DetectiveFilePage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.filePageObj, true)
  obj.name = "DetectiveFilePage"
end

function DetectiveFilePage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("DetectiveFilePage")
  self.scrollViewGO = self:FindGO("FileScrollView")
  self.fileScrollView = self.scrollViewGO:GetComponent(UIScrollView)
  self.detailPanel = self:FindGO("DetailPanel")
  self.maskCollider = self:FindGO("MaskCollider", self.detailPanel)
  self.detailPanel:SetActive(false)
  self.roleTexture = self:FindGO("RoleTexture", self.detailPanel):GetComponent(UITexture)
  self.modelTexture = self:FindGO("ModelTexture", self.detailPanel):GetComponent(UITexture)
  self.infoContainer = self:FindGO("InfoContainer")
  self.closeDetail = self:FindGO("CloseDetail")
  self.fileName = self:FindGO("FileName", self.infoContainer):GetComponent(UILabel)
  self.sex = self:FindGO("Sex", self.infoContainer):GetComponent(UILabel)
  self.royalRegion = self:FindGO("RoyalRegion", self.infoContainer):GetComponent(UILabel)
  self.age = self:FindGO("Age", self.infoContainer):GetComponent(UILabel)
  self.previewDesc = self:FindGO("Desc", self.infoContainer):GetComponent(UILabel)
  self.secretScrollView = self:FindGO("SecretScrollView", self.infoContainer):GetComponent(UIScrollView)
  self.secretTable = self:FindGO("SecretTable", self.infoContainer):GetComponent(UITable)
  self.secretGridCtrl = UIGridListCtrl.new(self.secretTable, FileTipCell, "FileTipCell")
  self.secretGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleEnlightEvent, self)
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.rightIndicator = self:FindGO("RightIndicator")
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  for objName, _ in pairs(decorateCommonMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.seal = self:FindGO("Seal")
  self.seal_TweenScale = self.seal:GetComponent(TweenScale)
  self.seal_TweenScale:SetOnFinished(function()
    self:PlayInfoTween()
  end)
  self.bg2 = self:FindGO("FileBg")
  self.bg2_TweenPos = self.bg2:GetComponent(TweenPosition)
  self.bg2_TweenAlpha = self.bg2:GetComponent(TweenAlpha)
  self.infoContainer_TweenAlpha = self.infoContainer:GetComponent(TweenAlpha)
  self.fileTexture_TweenPos = self:FindGO("FileTexture"):GetComponent(TweenPosition)
  self.fileTexture_TweenRot = self:FindGO("FileTexture"):GetComponent(TweenRotation)
  self.fileTexture_TweenAlpha = self:FindGO("FileTexture"):GetComponent(TweenAlpha)
  self.band_TweenScale = self:FindGO("Band"):GetComponent(TweenScale)
  self.band_TweenAlpha = self:FindGO("Band"):GetComponent(TweenAlpha)
  self.leftInfo_TweenAlpha = self:FindGO("InfoPart", self.infoContainer):GetComponent(TweenAlpha)
  self.relationMapObj = self:LoadPreferb_ByFullPath(relationShopMapPath, self.scrollViewGO, true)
  self.relationMapObj.name = "RelationMap"
  self:ResetInfoTween()
end

function DetectiveFilePage:AddEvts()
  self:AddClickEvent(self.closeDetail, function()
    self.secretGridCtrl:RemoveAll()
    self.detailPanel:SetActive(false)
  end)
  self:AddClickEvent(self.leftIndicator, function()
    self.curPage = self.curPage - 1
    if self.curPage < 1 then
      self.curPage = 1
    end
    local targetID = self.unlockCharacter[self.curPage]
    if targetID then
      self:RefreshDetailInfo(targetID)
    end
    xdlog("目标ID", targetID)
    self:ResetInfoTween()
    self:PlayInfoTween()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self.curPage = self.curPage + 1
    if self.curPage > self.unlockedCharacterCount then
      self.curPage = self.unlockedCharacterCount
    end
    local targetID = self.unlockCharacter[self.curPage]
    if targetID then
      self:RefreshDetailInfo(targetID)
    end
    xdlog("目标ID", targetID)
    self:ResetInfoTween()
    self:PlayInfoTween()
  end)
  self:AddClickEvent(self.maskCollider, function()
    self.secretGridCtrl:RemoveAll()
    self.detailPanel:SetActive(false)
  end)
  local helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:RegistShowGeneralHelpByHelpID(35092, helpBtn)
  self:AddDragEvent(self.modelTexture.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
end

function DetectiveFilePage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.QuestQueryCharacterInfoCmd, self.InitShow)
  self:AddListenEvt(ServiceEvent.QuestEnlightSecretCmd, self.HandleEnlightUpdate)
end

function DetectiveFilePage:InitDatas()
  self.relationData = SevenRoyalFamiliesProxy.Instance:GetRelation()
  local unlockedCharacter = SevenRoyalFamiliesProxy.Instance.unlockCharacter
  self.unlockCharacter = {}
  for k, v in pairs(unlockedCharacter) do
    self.unlockCharacter[#self.unlockCharacter + 1] = k
  end
  self.unlockedCharacterCount = #self.unlockCharacter
  self.curPage = 1
end

function DetectiveFilePage:InitShow()
  self:InitDatas()
  self:InitRelation()
  self:RefreshRedTips()
end

function DetectiveFilePage:InitRelation()
  self.characters = {}
  local fileTransform = self.relationMapObj.transform
  local offsetX = {}
  for i = 0, fileTransform.childCount - 1 do
    local child = fileTransform:GetChild(i)
    local npcId = tonumber(child.name)
    self.characters[npcId] = {
      go = child,
      redtip = self:FindGO("Redtip", child.gameObject)
    }
    local npcData = Table_Npc[npcId]
    local characterData = Table_SevenRoyalCharacter[npcId]
    if npcData then
      local icon = self:FindGO("Icon", child.gameObject):GetComponent(UISprite)
      icon.spriteName = characterData.Icon
      icon.width = 92
      icon.height = 92
      icon.transform.localPosition = LuaGeometry.GetTempVector3(3.9, -53.85, 0)
      local nameLabel = child.transform:Find("NameLabel"):GetComponent(UILabel)
      local boxCollider = child.gameObject:AddComponent(BoxCollider)
      boxCollider.size = LuaGeometry.GetTempVector3(100, 100, 1)
      if 0 < TableUtility.ArrayFindIndex(self.unlockCharacter, npcId) then
        icon.color = LuaColor.White()
        nameLabel.text = npcData.NameZh
        self:AddClickEvent(child.gameObject, function()
          self.seal_TweenScale:ResetToBeginning()
          self.seal_TweenScale:PlayForward()
          self:ResetInfoTween()
          self:RefreshDetailInfo(npcId)
        end)
        local panel = self.fileScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, child.gameObject.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        table.insert(offsetX, offset.x)
      else
        icon.color = LuaGeometry.GetTempVector4(0, 0, 0, 0.39215686274509803)
        nameLabel.text = "???"
        self:AddClickEvent(child.gameObject, function()
          MsgManager.ShowMsgByIDTable(41513)
        end)
      end
    end
    self:InitRelatedRelation(child)
  end
  if offsetX and 0 < #offsetX then
    local tempOffsetX = 0
    for i = 1, #offsetX do
      tempOffsetX = tempOffsetX + offsetX[i]
    end
    tempOffsetX = tempOffsetX / #offsetX
    LuaVector3.Better_Set(posVec, tempOffsetX, 0, 0)
    self.fileScrollView:MoveRelative(posVec)
  else
    self.fileScrollView:ResetPosition()
  end
end

function DetectiveFilePage:InitRelatedRelation(obj)
  local objTransform = obj.transform
  if self.relationData[tonumber(obj.name)] then
    for i = 0, objTransform.childCount - 1 do
      local child = objTransform:GetChild(i)
      local childName = tonumber(child.name)
      local lines = child:GetComponentsInChildren(UISprite)
      if self.relationData[tonumber(obj.name)][childName] then
        local relationData = self.relationData[tonumber(obj.name)][childName]
        if lines and 0 < #lines then
          for j = 1, #lines do
            if relationData.Name ~= "" then
              if relationData.State == 0 then
                lines[j].color = LuaGeometry.GetTempVector4(0.8, 0.8, 0.8, 1)
              else
                lines[j].color = LuaGeometry.GetTempVector4(0.26666666666666666, 0.7333333333333333, 0.30196078431372547, 1)
              end
            else
              lines[j].color = LuaGeometry.GetTempVector4(0, 0, 0, 0)
            end
          end
        end
        local relationLabel = child.transform:Find("Relation"):GetComponent(UILabel)
        relationLabel.text = relationData.Name
      elseif child.transform.childCount > 1 then
        local labelObj = child.transform:Find("Relation")
        if labelObj then
          local relationLabel = labelObj:GetComponent(UILabel)
          relationLabel.text = ""
        end
        for i = 1, #lines do
          lines[i].color = LuaGeometry.GetTempVector4(0, 0, 0, 0)
        end
      end
    end
  end
end

function DetectiveFilePage:RefreshDetailInfo(id)
  xdlog("RefreshDetailInfo", id)
  self.detailPanel:SetActive(true)
  local staticData = Table_SevenRoyalCharacter[id]
  if not staticData then
    redlog("无相关人员信息")
    return
  end
  self.curCharacterID = id
  self.staticData = staticData
  self.fileName.text = staticData.Name or "???"
  self.age.text = string.format(ZhString.DetectiveMainPanel_Age, staticData.Age or "???")
  local sex = staticData.Sex or 1
  self.sex.text = string.format(ZhString.DetectiveMainPanel_Sex, sex == 1 and ZhString.DetectiveMainPanel_Male or ZhString.DetectiveMainPanel_Female)
  self.royalRegion.text = string.format(ZhString.DetectiveMainPanel_RoyalRegion, staticData.RoyalName or "???")
  self.previewDesc.text = staticData.Desc
  self:RefreshCharacterSecrets()
  self:RefreshIndicator()
  self:Show3DModel(id)
end

function DetectiveFilePage:RefreshCharacterSecrets()
  if not self.staticData then
    return
  end
  local totalSecrets = self.staticData.Secrets and #self.staticData.Secrets or 0
  self.secretGridCtrl:SetEmptyDatas(totalSecrets)
  local characterSecret = SevenRoyalFamiliesProxy.Instance:GetCharacterSecret(self.curCharacterID)
  local unlockCharacterSecrets = characterSecret and characterSecret.unlockSecrets
  if unlockCharacterSecrets and 0 < #unlockCharacterSecrets then
    local cells = self.secretGridCtrl:GetCells()
    for i = 1, #cells do
      local targetSecret = self.staticData.Secrets[i]
      for j = 1, #unlockCharacterSecrets do
        if unlockCharacterSecrets[j].secret_id == targetSecret then
          cells[i]:SetData(unlockCharacterSecrets[j])
          break
        end
      end
    end
  end
  self.secretTable:Reposition()
  self.secretScrollView:ResetPosition()
end

function DetectiveFilePage:RefreshIndicator()
  if self.curPage == 1 then
    self.leftIndicator:SetActive(false)
  else
    self.leftIndicator:SetActive(true)
  end
  if self.curPage < self.unlockedCharacterCount then
    self.rightIndicator:SetActive(true)
  else
    self.rightIndicator:SetActive(false)
  end
end

function DetectiveFilePage:HandleEnlightEvent(cellCtrl)
  local id = cellCtrl.id
  local enlight = cellCtrl.lighted
  xdlog("解锁", id, enlight)
  if id and not enlight then
    xdlog("申请解锁", self.curCharacterID, id)
    ServiceQuestProxy.Instance:CallEnlightSecretCmd(self.curCharacterID, id)
  end
end

function DetectiveFilePage:HandleEnlightUpdate()
  xdlog("高亮状态更新")
  if self.curCharacterID and self.detailPanel.activeSelf then
    self:RefreshDetailInfo(self.curCharacterID)
  end
  self:RefreshRedTips()
end

function DetectiveFilePage:RefreshRedTips()
  local allCharacterInfo = SevenRoyalFamiliesProxy.Instance.characterSecret
  for k, v in pairs(allCharacterInfo) do
    local unlockSecrets = v.unlockSecrets
    local isNew = false
    if unlockSecrets and 0 < #unlockSecrets then
      for i = 1, #unlockSecrets do
        if not unlockSecrets[i].lighted then
          isNew = true
        end
      end
    end
    if self.characters[k] and self.characters[k].redtip then
      self.characters[k].redtip:SetActive(isNew)
    end
  end
end

function DetectiveFilePage:Show3DModel(npcid)
  if not npcid then
    return
  end
  local sdata = Table_Npc[npcid]
  local characterData = Table_SevenRoyalCharacter[npcid]
  if not sdata or not characterData then
    return
  end
  local otherScale = 1
  if sdata.Shape then
    otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
  else
    helplog(string.format("Npc:%s Not have Shape", sdata.id))
  end
  if sdata.Scale then
    otherScale = sdata.Scale
  end
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  if self.model and self.model:Alive() then
    local npcParts = Asset_RoleUtility.CreateNpcRoleParts(sdata.id)
    self.model:Redress(npcParts)
    Asset_Role.DestroyPartArray(npcParts)
  else
    self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modelTexture, sdata.id)
  end
  local showPos = sdata.LoadShowPose
  if showPos and #showPos == 3 then
    self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
  end
  if characterData.LoadShowRotate then
    self.model:SetEulerAngleY(characterData.LoadShowRotate)
  elseif sdata.LoadShowRotate then
    self.model:SetEulerAngleY(sdata.LoadShowRotate)
  end
  if characterData.LoadShowSize then
    otherScale = characterData.LoadShowSize
  elseif sdata.LoadShowSize then
    otherScale = sdata.LoadShowSize
  end
  self.model:SetScale(otherScale)
  UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
end

function DetectiveFilePage:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function DetectiveFilePage:ResetInfoTween()
  self.fileTexture_TweenPos:ResetToBeginning()
  self.fileTexture_TweenRot:ResetToBeginning()
  self.fileTexture_TweenAlpha:ResetToBeginning()
  self.band_TweenScale:ResetToBeginning()
  self.band_TweenAlpha:ResetToBeginning()
  self.leftInfo_TweenAlpha:ResetToBeginning()
end

function DetectiveFilePage:PlayInfoTween()
  xdlog("PlayInfoTween")
  self.fileTexture_TweenPos:PlayForward()
  self.fileTexture_TweenRot:PlayForward()
  self.fileTexture_TweenAlpha:PlayForward()
  self.band_TweenScale:PlayForward()
  self.band_TweenAlpha:PlayForward()
  self.leftInfo_TweenAlpha:PlayForward()
end

function DetectiveFilePage:OnEnter()
  DetectiveFilePage.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function DetectiveFilePage:OnExit()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  DetectiveFilePage.super.OnExit(self)
end
