BaseScreenQTECompLine = class("BaseScreenQTECompLine", BaseCell)

function BaseScreenQTECompLine:ctor(cName, holderObj)
  self.gameObject = self:LoadCellPfb(cName, holderObj)
  self.startAnchor = self:FindGO("StartPoint")
  self.endAnchor = self:FindGO("EndPoint")
  self.progress = self:FindComponent("Bg", UISlider)
  self.lineSp = self:FindComponent("Bg", UISprite)
  self.progressSp = self:FindComponent("Progress", UISprite)
  self.gameObject.transform.localPosition = LuaVector3.zero
end

function BaseScreenQTECompLine:SetLine(pos1x, pos1y, pos2x, pos2y, themeCfg)
  local lineMargin = themeCfg.line_margin
  local progressMargin = themeCfg.progress_margin
  self.pos1 = LuaVector3.New(pos1x, pos1y, 0)
  self.pos2 = LuaVector3.New(pos2x, pos2y, 0)
  self.startAnchor.transform.localPosition = self.pos1
  self.endAnchor.transform.localPosition = self.pos2
  self.lineSp.gameObject.transform.localPosition = LuaGeometry.GetTempVector3((pos1x + pos2x) / 2, (pos1y + pos2y) / 2, 0)
  self.lineSp.gameObject.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, math.deg(math.atan2(pos2y - pos1y, pos2x - pos1x)))
  local width = LuaVector3.Magnitude(self.pos1 - self.pos2) + lineMargin * 2
  self.lineSp.width = width
  if self.progressSp then
    self.progressSp.width = width + progressMargin * 2
  end
  self:SetProgress(0)
end

function BaseScreenQTECompLine:SetProgress(value)
  if not self.progressSp then
    return
  end
  self.progress.value = value
end

function BaseScreenQTECompLine:GetLerpPos(value)
  return self.pos1.x * (1 - value) + self.pos2.x * value, self.pos1.y * (1 - value) + self.pos2.y * value
end

function BaseScreenQTECompLine:GetLineDir()
  return self.lineSp.gameObject.transform.localEulerAngles.z
end

function BaseScreenQTECompLine:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  cellpfb.transform.localScale = LuaVector3.one
  return cellpfb
end

function BaseScreenQTECompLine:Destroy()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.DestroyImmediate(self.gameObject)
  end
end
