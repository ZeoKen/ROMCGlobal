GameHealthWorker_ClickButton = class("GameHealthWorker_ClickButton")
GameHealthWorker_ClickButton.Level = 1

function GameHealthWorker_ClickButton:ctor()
end

function GameHealthWorker_ClickButton:SetLevel(manager, level)
  self.manager = manager
end

function GameHealthWorker_ClickButton:SetWorkStatus(isActive)
end

function GameHealthWorker_ClickButton:OnClick(gameObject)
  local objName = gameObject.name
  local transform = gameObject.transform
  local vecPos = self.manager:GetMouseWorldPosition()
  local mainView = self.manager:FindView("MainView", UIViewType.MainLayer)
  if mainView then
    if string.find(objName, "MiniMapButton") and self.manager:IsChild(transform, mainView.trans) then
      self.manager:AddEventRecord(6, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      return
    end
    if string.find(objName, "NearlyButton") and self.manager:IsChild(transform, mainView.trans) then
      self.manager:AddEventRecord(7, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      return
    end
    if string.find(objName, "NPCTog") and self.manager:IsChild(transform, mainView.trans) then
      self.manager:AddEventRecord(8, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      return
    end
    if string.find(objName, "NearlyCreatureCell") and self.manager:IsChild(transform, mainView.trans) then
      local obj = Game.GameObjectUtil:DeepFind(gameObject, "Symbol")
      local sprIcon = obj and obj:GetComponent(UISprite)
      obj = Game.GameObjectUtil:DeepFind(gameObject, "Name")
      local labName = obj and obj:GetComponent(UILabel)
      if sprIcon and sprIcon.spriteName == "map_kapula" and labName and labName.text == OverSea.LangManager.Instance():GetLangByKey("卡普拉服务人员") then
        self.manager:AddEventRecord(9, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      end
      return
    end
  end
  if string.find(objName, "CloseButton") and self.manager:ObjIsChildOfView(gameObject, "BossView", UIViewType.NormalLayer) then
    self.manager:AddEventRecord(4, GameHealthProtector.E_EvtType.Count)
    return
  end
  local dialogView = self.manager:FindView("DialogView", UIViewType.DialogLayer)
  if dialogView and self.manager:IsAtMainCity() and dialogView.npcdata and dialogView.npcdata.NameZh == "卡普拉服务人员" and string.find(objName, "Button") and self.manager:IsChild(transform, dialogView.trans) then
    local obj = Game.GameObjectUtil:DeepFind(gameObject, "Label")
    local labName = obj and obj:GetComponent(UILabel)
    if labName and labName.text == OverSea.LangManager.Instance():GetLangByKey("传送") then
      local objDialogContent = Game.GameObjectUtil:DeepFind(dialogView.gameObject, "DialogContent")
      local labDialogContent = objDialogContent and objDialogContent:GetComponent(UILabel)
      if not labDialogContent then
        redlog("Cannot Find DialogContent in DialogView")
      end
      if labDialogContent and labDialogContent.text == OverSea.LangManager.Instance():GetLangByKey("请选择传送的服务类型") then
        self.manager:AddEventRecord(11, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      else
        self.manager:AddEventRecord(10, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
      end
      return
    end
    if labName and labName.text == OverSea.LangManager.Instance():GetLangByKey("组队传送") then
      self.manager:AddEventRecord(11, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
    end
    return
  end
end

function GameHealthWorker_ClickButton:OnPress(gameObject, isPress)
  local vecPos = self.manager:GetMouseWorldPosition()
  if not isPress then
    if self.dragBossView then
      self.manager:AddEventRecord(5, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
    end
    self.prepareDrag = false
    self.dragBossView = false
    return
  end
  local objName = gameObject.name
  if string.find(objName, "BossCell") and self.manager:ObjIsChildOfView(gameObject, "BossView", UIViewType.NormalLayer) then
    self.prepareDrag = true
  end
  self.dragBossView = false
end

function GameHealthWorker_ClickButton:OnScroll(gameObject, delta)
end

function GameHealthWorker_ClickButton:OnDrag(gameObject, deltaV2)
  if self.prepareDrag then
    if string.find(gameObject.name, "BossCell") and self.manager:ObjIsChildOfView(gameObject, "BossView", UIViewType.NormalLayer) then
      self.dragBossView = true
      local vecPos = self.manager:GetMouseWorldPosition()
      self.manager:AddEventRecord(3, GameHealthProtector.E_EvtType.Pos, vecPos.x, vecPos.y, vecPos.z)
    end
    self.prepareDrag = false
  end
end
