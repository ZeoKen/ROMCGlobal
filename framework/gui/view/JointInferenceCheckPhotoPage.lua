JointInferenceCheckPhotoPage = class("JointInferenceCheckPhotoPage", SubView)
JointInferenceCheckPhotoPage.ViewType = UIViewType.NormalLayer
autoImport("PhotoEvidenceCell")
local viewPath = ResourcePathHelper.UIView("JointInferenceCheckPhotoPage")
local decorateTextureNameMap = {
  Decorate13 = "Sevenroyalfamilies_bg_decoration13"
}
local decorateCommonMap = {
  DecorateBG = "calendar_bg1_picture2"
}
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function JointInferenceCheckPhotoPage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function JointInferenceCheckPhotoPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.checkPhotoPageObj, true)
  obj.name = "JointInferenceCheckPhotoPage"
end

function JointInferenceCheckPhotoPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("JointInferenceCheckPhotoPage")
  self.questionLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.evidenceTable = self:FindGO("UITable"):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceTable, PhotoEvidenceCell, "PhotoEvidenceCell")
  self.rightPart = self:FindGO("Right", self.gameObject)
  self.photo = self:FindGO("Photo"):GetComponent(UITexture)
  self.marksContainer = self:FindGO("MarksContainer", self.gameObject)
  self.colliderArea = self:FindGO("ColliderArea", self.gameObject)
  self:AddClickEvent(self.colliderArea, function()
    self:CheckClickResult()
  end)
  self.tipsContainer = self:FindGO("TipsContainer", self.gameObject)
  self.tipLabelGO = self:FindGO("TipLabel")
  self.tipLabel = self.tipLabelGO:GetComponent(UILabel)
  self.tipLabel_BG = self:FindGO("Bg", self.tipLabelGO):GetComponent(UISprite)
  self.tipLabel_TweenAlpha = self.tipLabelGO:GetComponent(TweenAlpha)
  self.tipLabel_TweenAlpha:ResetToBeginning()
  self.clickCollider = self:FindGO("ClickCollider", self.tipsContainer):GetComponent(BoxCollider)
  self.clickCollider.enabled = false
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  for objName, _ in pairs(decorateCommonMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
end

function JointInferenceCheckPhotoPage:AddEvts()
end

function JointInferenceCheckPhotoPage:AddMapEvts()
end

function JointInferenceCheckPhotoPage:InitDatas()
  self.answers = {}
  self.unlockInfo = {}
  self.totalEvidence = 0
  self.unlockEvidence = 0
  self.finished = false
end

function JointInferenceCheckPhotoPage:InitShow()
end

function JointInferenceCheckPhotoPage:RefreshQuestion(id)
  self:Reset()
  local questionId = id
  local staticData = Table_JointInference[id]
  if not staticData then
    return
  end
  self.staticData = staticData
  self.tipsList = staticData.Tips
  self.questionLabel.text = staticData.Title or "???"
  local answers = staticData.Answer
  for i = 1, #answers do
    local single = answers[i]
    local data = {}
    data.pos = single.pos
    data.tip = single.tip
    table.insert(self.answers, data)
    self.totalEvidence = self.totalEvidence + 1
  end
  self.evidenceGridCtrl:SetEmptyDatas(self.totalEvidence)
  self.evidenceTable:Reposition()
  self.resultMessage = staticData.Message
  self.photoPath = staticData.EvidenceList and staticData.EvidenceList[1]
  if self.photoPath then
    picIns:SetSevenRoyalFamiliesTexture(self.photoPath, self.photo)
  end
  self:PlayDefaultQuestion()
end

function JointInferenceCheckPhotoPage:CheckAnswers(id)
  if not id then
    return
  end
  self.clickCollider.enabled = true
  if self.tempCell then
    local sprite = self.tempCell.obj:GetComponent(UISprite)
    if sprite then
      sprite.atlas = nil
      sprite.spriteName = nil
    end
    self.tempCell = nil
  end
  if self.answers[id] then
    if not self.unlockInfo[id] then
      self.unlockInfo[id] = self.answers[id]
      xdlog("首次添加解锁", id, self.answers[id])
      self.unlockEvidence = self.unlockEvidence + 1
      self:RefreshUnlockInfos()
      self:PlayTips(1)
    end
    local cell = self.colliders[id]
    if cell then
      local sprite = cell.obj:GetComponent(UISprite)
      sprite = sprite or cell.obj:AddComponent(UISprite)
      sprite.atlas = RO.AtlasMap.GetAtlas("UI_SevenRoyalFamilies")
      sprite.spriteName = "Sevenroyalfamilies_icon_b"
      sprite.color = LuaGeometry.GetTempVector4(0.14901960784313725, 0.8941176470588236, 0.23529411764705882, 1)
      sprite.depth = 10
      sprite:MakePixelPerfect()
    end
  else
    self:PlayTips(2)
    local cell = self.colliders[id]
    self.tempCell = cell
    if cell then
      local sprite = cell.obj:GetComponent(UISprite)
      sprite = sprite or cell.obj:AddComponent(UISprite)
      sprite.atlas = RO.AtlasMap.GetAtlas("UI_SevenRoyalFamilies")
      sprite.spriteName = "Sevenroyalfamilies_icon_a"
      sprite.color = LuaGeometry.GetTempVector4(0.5725490196078431, 0.10980392156862745, 0.07058823529411765, 1)
      sprite.depth = 10
      sprite:MakePixelPerfect()
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self.clickCollider.enabled = false
  end, self, 4)
  if self:CheckFinish() then
    self.finished = true
    self:PlayTips(5)
    TimeTickManager.Me():CreateOnceDelayTick(2500, function(owner, deltaTime)
      self.container:ProcessFinish(self.resultMessage)
    end, self, 5)
  end
end

function JointInferenceCheckPhotoPage:CheckClickResult()
  local pos = self:GetClickPos()
  if not pos then
    return
  end
  pos[1] = pos[1] - 235
  self.clickCollider.enabled = true
  for i = 1, #self.answers do
    local single = self.answers[i]
    local targetPos = single.pos
    local delta_x = math.abs(targetPos[1] - pos[1])
    local delta_y = math.abs(targetPos[2] - pos[2])
    if delta_x < 40 and delta_y < 40 then
      local data = {}
      table.insert(self.unlockInfo, single.tip)
      table.remove(self.answers, i)
      self.unlockEvidence = self.unlockEvidence + 1
      self:RefreshUnlockInfos()
      self:PlayTips(1)
      local obj = GameObject("CorrectMark")
      obj.transform:SetParent(self.marksContainer.transform)
      obj.transform.localPosition = pos
      local sprite = obj:AddComponent(UISprite)
      sprite.atlas = RO.AtlasMap.GetAtlas("UI_SevenRoyalFamilies")
      sprite.spriteName = "Sevenroyalfamilies_icon_b"
      sprite.color = LuaGeometry.GetTempVector4(0.14901960784313725, 0.8941176470588236, 0.23529411764705882, 1)
      sprite.depth = 10
      sprite:MakePixelPerfect()
    else
      self:PlayTips(2)
      if not self.wrongMark then
        self.wrongMark = GameObject("WrongMark")
        self.wrongMark.transform:SetParent(self.marksContainer.transform)
      end
      self.wrongMark.transform.localPosition = pos
      local sprite = self.wrongMark:GetComponent(UISprite)
      sprite = sprite or self.wrongMark:AddComponent(UISprite)
      sprite.atlas = RO.AtlasMap.GetAtlas("UI_SevenRoyalFamilies")
      sprite.spriteName = "Sevenroyalfamilies_icon_a"
      sprite.color = LuaGeometry.GetTempVector4(0.5725490196078431, 0.10980392156862745, 0.07058823529411765, 1)
      sprite.depth = 10
      sprite:MakePixelPerfect()
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self.clickCollider.enabled = false
  end, self, 4)
  if self:CheckFinish() then
    self.finished = true
    self:PlayTips(5)
    self.clickCollider.enabled = true
    TimeTickManager.Me():ClearTick(self, 4)
    TimeTickManager.Me():ClearTick(self, 6)
    TimeTickManager.Me():CreateOnceDelayTick(2500, function(owner, deltaTime)
      self.container:ProcessFinish(self.resultMessage)
    end, self, 5)
  end
end

function JointInferenceCheckPhotoPage:GetClickPos()
  if self.uiCamera then
    local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
    LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
    return tempVector3
  end
end

function JointInferenceCheckPhotoPage:Reset()
  self.wrongMark = nil
  Game.GameObjectUtil:DestroyAllChildren(self.marksContainer)
  self.clickCollider.enabled = false
  self:InitDatas()
end

function JointInferenceCheckPhotoPage:RefreshUnlockInfos()
  local data = {}
  local cells = self.evidenceGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetData(self.unlockInfo[i])
  end
end

function JointInferenceCheckPhotoPage:CheckFinish()
  if self.unlockEvidence >= self.totalEvidence then
    return true
  end
  return false
end

function JointInferenceCheckPhotoPage:PlayTips(type)
  xdlog("播放提示", type)
  if not self.tipsList then
    return
  end
  if self.tipsList[type] then
    local tipID = self.tipsList[type]
    local dialogData = DialogUtil.GetDialogData(tipID)
    if dialogData then
      if dialogData.Voice and dialogData.Voice ~= "" then
        FunctionPlotCmd.Me():PlayNpcVisitVocal(dialogData.Voice)
      end
      self.tipLabel.text = dialogData.Text
    end
    self.tipLabel_BG.height = self.tipLabel.printedSize.y + 20
    self.tipLabel_BG.width = self.tipLabel.printedSize.x + 30
    xdlog("printSize", self.tipLabel.printedSize.x, self.tipLabel.printedSize.y)
    self.tipLabel_TweenAlpha:ResetToBeginning()
    self.tipLabel_TweenAlpha:PlayForward()
    if not self.finished then
      TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
        self:PlayDefaultQuestion()
      end, self, 6)
    end
  end
end

function JointInferenceCheckPhotoPage:PlayDefaultQuestion()
  self.tipLabel_TweenAlpha:ResetToBeginning()
  self.tipLabel_TweenAlpha:PlayForward()
  local tipID = self.tipsList[3]
  local dialogData = DialogUtil.GetDialogData(tipID)
  if dialogData then
    if dialogData.Voice and dialogData.Voice ~= "" then
      FunctionPlotCmd.Me():PlayNpcVisitVocal(dialogData.Voice)
    end
    self.tipLabel.text = dialogData.Text
  end
  self.tipLabel_BG.height = self.tipLabel.printedSize.y + 20
  self.tipLabel_BG.width = self.tipLabel.printedSize.x + 30
end

function JointInferenceCheckPhotoPage:OnEnter()
  JointInferenceCheckPhotoPage.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function JointInferenceCheckPhotoPage:OnExit()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  if self.photoPath then
    picIns:UnloadSevenRoyalFamiliesTexture(self.photoPath, self.photo)
  end
  TimeTickManager.Me():ClearTick(self)
  JointInferenceCheckPhotoPage.super.OnExit(self)
end

function JointInferenceCheckPhotoPage:CloseSelf()
  JointInferenceCheckPhotoPage.super.CloseSelf(self)
end
