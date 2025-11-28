local ElementTypeMap = {
  [1] = "sceneui"
}
local ElementTypeDefaultMap = {}
SpriteText = class("SpriteText")
SpriteText.SpResID = ResourcePathHelper.UIPrefab_Cell("SpriteTextCell")

function SpriteText:ctor(text, width, iconWidth, iconHeight, iconCenterInLine)
  if text == nil then
    return
  end
  self.sps = {}
  self.text = text
  self.trans = self.text.transform
  
  function text.EmojiHandler(emojiElementDatas)
    for i = 0, emojiElementDatas.Count - 1 do
      self:CreateElementData(emojiElementDatas[i])
    end
  end
end

function SpriteText:CreateElementData(elmData)
  local eleType = elmData.ElementType
  local atlasType = ElementTypeMap[eleType]
  local spriteName
  if atlasType == nil then
    if ElementTypeDefaultMap[eleType] then
      atlasType = ElementTypeDefaultMap[eleType][1]
      spriteName = ElementTypeDefaultMap[eleType][2]
    end
  else
    spriteName = elmData.Id
  end
  if atlasType == nil or spriteName == nil then
    return
  end
  local sp = Game.AssetManager_UI:CreateSceneUIAsset(SpriteText.SpResID, self.trans)
  sp = sp:GetComponent(Image)
  sp.rectTransform:SetParent(self.trans, false)
  local pos = elmData.CenterPosition
  local tempV3 = LuaGeometry.GetTempVector3(pos.x, pos.y, 0)
  sp.rectTransform.localPosition = tempV3
  local tempV2 = LuaGeometry.GetTempVector2(elmData.PixelWidth, elmData.PixelHeight)
  sp.rectTransform.sizeDelta = tempV2
  SpriteManager.SetUISprite(atlasType, spriteName, sp:GetComponent(Image))
  table.insert(self.sps, sp)
end

function SpriteText:SetValue(value)
  self:Reset()
  self.text.text = value
end

function SpriteText:Reset()
  if self.text then
    self.text.EmojiHandler = nil
  end
  for i = #self.sps, 1, -1 do
    Game.GOLuaPoolManager:AddToSceneUIPool(SpriteText.SpResID, self.sps[i])
    self.sps[i] = nil
  end
end

function SpriteText:Destroy()
  self:Reset()
end
