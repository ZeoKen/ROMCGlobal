FastClassChangeGetGemCell = class("FastClassChangeGetGemCell", GemCell)

function FastClassChangeGetGemCell:Init()
  self.super.Init(self)
  local exinfo = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("FastClassChangeGetGemCell"))
  exinfo.transform:SetParent(self.gameObject.transform, false)
  self.nameLb = self:FindComponent("gemName", UILabel, exinfo)
  self.gameObject:GetComponent(BoxCollider).size = LuaGeometry.GetTempVector3(130, 130, 0)
end

function FastClassChangeGetGemCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.super.SetData(self, data)
  self.nameLb.text = self.data.staticData.NameZh
end
