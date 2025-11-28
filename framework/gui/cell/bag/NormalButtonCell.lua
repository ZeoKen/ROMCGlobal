local BaseCell = autoImport("BaseCell")
NormalButtonCell = class("NormalButtonCell", BaseCell)
NormalButtonCell.ResPath = ResourcePathHelper.UICell("NormalButtonCell")

function NormalButtonCell.CreateButton(parent)
  local obj = Game.AssetManager_UI:CreateAsset(NormalButtonCell.ResPath, parent.gameObject)
  if obj then
    UIUtil.ChangeLayer(obj, parent.gameObject.layer)
    obj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  end
  return obj
end

function NormalButtonCell:Init()
  self.bg = self:FindComponent("Background", UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
end

function NormalButtonCell:SetData(data)
  if data then
    if data.isInvisible then
      self.bg.spriteName = nil
      self.label.gameObject:SetActive(false)
    end
    if data.buttonSize and self.boxCollider then
      self.boxCollider.size = LuaGeometry.GetTempVector3(data.buttonSize[1], data.buttonSize[2], 0)
    end
    if data.text then
      self.label.text = tostring(data.text)
    end
    if data.event then
      self:SetEvent(self.gameObject, data.event)
    end
  end
end
