EffectShowDataWraper = class("EffectShowDataWraper")
autoImport("CardNCell")
autoImport("ItemCell")
EffectShowDataWraper.IconType = {
  item = 1,
  skill = 2,
  ui = 3,
  career = 4,
  head = 5
}
EffectShowDataWraper.DefaultWidth = 380
EffectShowDataWraper.DefaultHeight = 380
EffectShowDataWraper.Default = 1
EffectShowDataWraper.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")
EffectShowDataWraper.ItemCellResPath = ResourcePathHelper.UICell("AwardItemCell")

function EffectShowDataWraper:ctor(itemData, effectPath, showType, from, argumentTable)
  self.itemData = itemData
  self.effectPath = effectPath
  self.showType = showType
  self.effectFromType = from
  self.obj = nil
  self.resPath = nil
  if argumentTable then
    self.rightBtnText = argumentTable.rightBtnText
    self.rightBtnCallback = argumentTable.rightBtnCallback
    self.leftBtnText = argumentTable.leftBtnText
    self.leftBtnRichText = argumentTable.leftBtnRichText
    self.leftBtnCallback = argumentTable.leftBtnCallback
    self.hideEquipBtn = argumentTable.hideEquipBtn
    self.audioEffect = argumentTable.audioEffect
  end
  if itemData.staticData then
    self.dataName = itemData:GetName()
    self.canBeShare = itemData.staticData.Share == 1
  else
    self.tb = TableUtil.unserialize(itemData.data)
    self.dataName = self.tb.text
  end
end

function EffectShowDataWraper:canBeShared()
  return self.canBeShare
end

function EffectShowDataWraper:adjustDepth(obj)
  local max = -999
  if obj then
    local objs = Game.GameObjectUtil:GetAllChildren(obj)
    for i = 1, #objs do
      local child = objs[i]
      local widget = child:GetComponent(UIWidget)
      if widget then
        if widget.depth < 50 then
          widget.depth = widget.depth + 50
        end
        if max < widget.depth then
          max = widget.depth
        end
      end
    end
  end
  return max
end

function EffectShowDataWraper:getModelObj(parent)
  self:ClearObj()
  local obj
  if self.showType == FloatAwardView.ShowType.ModelType then
    obj = ItemUtil.getAssetPartByItemData(self.itemData.staticData.id, parent)
  elseif self.showType == FloatAwardView.ShowType.ItemType then
    self.resPath = EffectShowDataWraper.ItemCellResPath
    obj = Game.AssetManager_UI:CreateAsset(self.resPath, parent)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    obj.transform.localScale = LuaGeometry.Const_V3_one
    obj.name = "ItemCell"
    self.cell = ItemCell.new(obj)
    self.cell:ResetBG()
    self.cell:SetData(self.itemData)
    local max = self:adjustDepth(parent)
    local tx = Game.GameObjectUtil:DeepFind(parent.transform.parent.gameObject, "Texture")
    if tx then
      tx = tx:GetComponent(UITexture)
      tx.depth = max + 1
    end
  elseif self.showType == FloatAwardView.ShowType.CardType then
    self.resPath = EffectShowDataWraper.CardNCellResPath
    obj = Game.AssetManager_UI:CreateAsset(self.resPath, parent)
    obj.transform.localPosition = LuaGeometry.GetTempVector3(0, 35)
    obj.transform.localScale = LuaGeometry.Const_V3_one
    obj.name = "CardNCell"
    self.cell = CardNCell.new(obj)
    self.cell:SetData(nil)
    self.cell:SetData(self.itemData, false)
    self.cell:Hide(self.cell.useButton.gameObject)
    local max = self:adjustDepth(parent)
    local tx = Game.GameObjectUtil:DeepFind(parent.transform.parent.gameObject, "Texture")
    if tx then
      tx = tx:GetComponent(UITexture)
      tx.depth = max + 1
    end
  elseif self.showType == FloatAwardView.ShowType.IconType then
    obj = GameObject("tmp")
    obj.transform:SetParent(parent.transform)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    local cpn = obj:AddComponent(UISprite)
    cpn.depth = 3
    if self.itemData.type == EffectShowDataWraper.IconType.skill then
      IconManager:SetSkillIcon(self.tb.icon, cpn)
    elseif self.itemData.type == EffectShowDataWraper.IconType.career then
      IconManager:SetProfessionIcon(self.tb.icon, cpn)
    elseif self.itemData.type == EffectShowDataWraper.IconType.ui then
      IconManager:SetUIIcon(self.tb.icon, cpn)
    elseif self.itemData.type == EffectShowDataWraper.IconType.item then
      IconManager:SetItemIcon(self.tb.icon, cpn)
    elseif self.itemData.type == EffectShowDataWraper.IconType.head then
      IconManager:SetFaceIcon(self.tb.icon, cpn)
    end
    cpn:MakePixelPerfect()
    local scale = self.tb.scale or EffectShowDataWraper.Default
    local cpnWidth = cpn.width * scale
    local cpnHeight = cpn.height * scale
    if cpnWidth > EffectShowDataWraper.DefaultWidth or cpnHeight > EffectShowDataWraper.DefaultHeight then
      local orginRatio = EffectShowDataWraper.DefaultWidth / EffectShowDataWraper.DefaultHeight
      local textureRatio = cpnWidth / cpnHeight
      local wRatio = math.min(orginRatio, textureRatio) == orginRatio
      local height = EffectShowDataWraper.DefaultHeight
      local width = EffectShowDataWraper.DefaultWidth
      if wRatio then
        height = EffectShowDataWraper.DefaultWidth / textureRatio
      else
        width = EffectShowDataWraper.DefaultHeight * textureRatio
      end
      cpn.width = width
      cpn.height = height
      obj.transform.localScale = LuaGeometry.Const_V3_one
    else
      obj.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
    end
  end
  self.obj = obj
  return obj
end

function EffectShowDataWraper:ClearObj()
  if self.obj and self.showType == FloatAwardView.ShowType.ModelType then
    self.obj:Destroy()
  elseif self.obj and self.resPath then
    Game.GOLuaPoolManager:AddToUIPool(self.resPath, self.obj)
  elseif self.obj then
    GameObject.DestroyImmediate(self.obj)
  end
end

function EffectShowDataWraper:Exit()
  if self.cell then
    self.cell:SetData(nil)
    if self.cell.numLab then
      self.cell.numLab.text = ""
    end
    if self.cell.ClearAllCellParts then
      self.cell:ClearAllCellParts()
    end
    if self.cell.OnCellDestroy then
      self.cell:OnCellDestroy()
    end
  end
  self:ClearObj()
  self.cell = nil
  self.obj = nil
  self.leftBtnCallback = nil
  self.rightBtnCallback = nil
end

function EffectShowDataWraper:clone()
  local showData = EffectShowDataWraper.new(self.itemData, self.effectPath, self.showType, self.effectFromType)
  return showData
end
