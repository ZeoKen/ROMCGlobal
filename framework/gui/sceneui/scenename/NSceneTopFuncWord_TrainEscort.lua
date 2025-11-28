NSceneTopFuncWord_TrainEscort = reusableClass("NSceneTopFuncWord_TrainEscort")
NSceneTopFuncWord_TrainEscort.PoolSize = 5
NSceneTopFuncWord_TrainEscort.ResID = ResourcePathHelper.UIPrefab_Cell("SceneTopFuncWord_TrainEscort")
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function NSceneTopFuncWord_TrainEscort:InitCellGO()
  if LuaGameObject.ObjectIsNull(self.gameObject) then
    return
  end
  LuaGameObject.SetLocalPositionGO(self.gameObject, 0, 0, 0)
  LuaGameObject.SetLocalRotationGO(self.gameObject, 0, 0, 0, 1)
  LuaGameObject.SetLocalScaleGO(self.gameObject, 1, 1, 1)
  self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)
  self.labelGo = func_deepFind(_gameUtilInstance, self.gameObject, "Label")
  self.label = self.labelGo:GetComponent(Text)
  self.labelCanvas = self.labelGo:GetComponent(CanvasGroup)
  self.labelOriginalDepth = self.label.depth
  self.label2Go = func_deepFind(_gameUtilInstance, self.gameObject, "Label2")
  self.label2 = self.label2Go:GetComponent(Text)
  self.label2Canvas = self.label2Go:GetComponent(CanvasGroup)
  self.label2OriginalDepth = self.label2.depth
  self.label3Go = func_deepFind(_gameUtilInstance, self.gameObject, "Label3")
  self.label3 = self.label3Go:GetComponent(Text)
  self.label3Canvas = self.label3Go:GetComponent(CanvasGroup)
  self.label3OriginalDepth = self.label3.depth
  self.symbolGO = func_deepFind(_gameUtilInstance, self.gameObject, "Symbol")
  self.symbol = self.symbolGO:GetComponent(Image)
  self.symbolCanvas = self.symbolGO:GetComponent(CanvasGroup)
  self.symbolOriginalDepth = self.symbol.depth
  self.symbol2GO = func_deepFind(_gameUtilInstance, self.gameObject, "Symbol2")
  self.symbol2 = self.symbol2GO:GetComponent(Image)
  self.symbol2Canvas = self.symbol2GO:GetComponent(CanvasGroup)
  self.symbol2OriginalDepth = self.symbol2.depth
  self.symbol3GO = func_deepFind(_gameUtilInstance, self.gameObject, "Symbol3")
  self.symbol3 = self.symbol3GO:GetComponent(Image)
  self.symbol3Canvas = self.symbol3GO:GetComponent(CanvasGroup)
  self.symbol3OriginalDepth = self.symbol3.depth
  self.bg = func_deepFind(_gameUtilInstance, self.gameObject, "Bg1"):GetComponent(Image)
  self.bgOriginalDepth = self.bg.depth
  self:SetActive(self.canvasGroup, true, true)
end

function NSceneTopFuncWord_TrainEscort:SetMinDepth(mindepth)
end

function NSceneTopFuncWord_TrainEscort:Active(b)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    self:SetActive(self.canvasGroup, b, true)
  end
end

function NSceneTopFuncWord_TrainEscort:SetActive(canvasGroup, visible, isRoot)
  if not canvasGroup then
    return
  end
  if isRoot then
    self.bg.raycastTarget = visible
  end
  canvasGroup.alpha = visible and 1 or 0
end

function NSceneTopFuncWord_TrainEscort:DoConstruct(asArray, args)
  self.gameObject = args[1]
  self:InitCellGO()
  local text = args[2]
  local icon = args[3]
  local clickFunc = args[4]
  local clickArgs = args[5]
  self.creature = args[6]
  self:SetActive(self.labelCanvas, true)
  self:SetActive(self.label2Canvas, true)
  self:SetActive(self.label3Canvas, true)
  self.label.text = text[1]
  self.label2.text = text[2]
  self.label3.text = text[3]
  self:SetActive(self.symbolCanvas, true)
  SpriteManager.SetUISprite("sceneui", tostring(icon[1]), self.symbol)
  self:SetActive(self.symbol2Canvas, true)
  SpriteManager.SetUISprite("sceneui", tostring(icon[2]), self.symbol2)
  self:SetActive(self.symbol3Canvas, true)
  SpriteManager.SetUISprite("sceneui", tostring(icon[3]), self.symbol3)
  if clickFunc and self.bg then
    self:AddClickEvent(self.bg.gameObject, function(go)
      clickFunc(clickArgs)
    end)
  end
end

function NSceneTopFuncWord_TrainEscort:DoDeconstruct(asArray)
  self.parent = nil
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(NSceneTopFuncWord_TrainEscort.ResID, self.gameObject)
    self:AddClickEvent(self.bg.gameObject, nil)
  end
  self.label = nil
  self.labelGo = nil
  self.labelCanvas = nil
  self.label2 = nil
  self.label2Go = nil
  self.label2Canvas = nil
  self.label3 = nil
  self.label3Go = nil
  self.label3Canvas = nil
  self.symbol = nil
  self.symbolGO = nil
  self.symbolCanvas = nil
  self.symbol2 = nil
  self.symbol2GO = nil
  self.symbol2Canvas = nil
  self.symbol3 = nil
  self.symbol3GO = nil
  self.symbol3Canvas = nil
  self.bg = nil
  self.gameObject = nil
  self.canvasGroup = nil
  self.symbolCanvas = nil
  self.isVisible = nil
end

function NSceneTopFuncWord_TrainEscort:AddClickEvent(obj, event)
  if event == nil then
    UGUIEventListener.Get(obj).onClick = nil
    return
  end
  UGUIEventListener.Get(obj).onClick = function(go)
    if UICamera.isOverUI then
      return
    end
    if event then
      event(go)
    end
  end
end
