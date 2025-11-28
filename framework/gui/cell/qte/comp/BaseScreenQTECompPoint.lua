BaseScreenQTECompPoint = class("BaseScreenQTECompPoint", BaseCell)

function BaseScreenQTECompPoint:ctor(cName, holderObj)
  self.gameObject = self:LoadCellPfb(cName, holderObj)
  self.markSp = self:FindComponent("MarkSp", UIMultiSprite)
  self.markText = self:FindComponent("MarkText", UILabel)
  self.timeoutRing = self:FindGO("Ring")
  self.markText.text = ""
  self.timeoutRing.transform.localScale = LuaVector3.one
end

function BaseScreenQTECompPoint:SetWithCfg(cfg)
  self.beginScale = cfg.click_ring_scale_range[1]
  self.endScale = cfg.click_ring_scale_range[2]
end

function BaseScreenQTECompPoint:SetPos(x, y, isWorld)
  if isWorld then
    self.gameObject.transform.position = LuaGeometry.GetTempVector3(x, y, 0)
  else
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
  end
end

function BaseScreenQTECompPoint:GetPos()
  return self.gameObject.transform.localPosition.x, self.gameObject.transform.localPosition.y
end

function BaseScreenQTECompPoint:ShowTimeOut(isShow)
  self.timeoutRing:SetActive(isShow)
end

function BaseScreenQTECompPoint:SetTimeOut(pct)
  local scale = self.beginScale * (1 - pct) + self.endScale * pct
  self.timeoutRing.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
end

function BaseScreenQTECompPoint:SetText(text)
  self.markText.text = text
end

function BaseScreenQTECompPoint:SetMarkSp(sp, dir)
  if type(sp) == "number" then
    self.markSp.CurrentState = sp
  elseif type(sp) == "string" then
    IconManager:SetUIIcon(sp, self.markSp)
  end
  self.markSp:MakePixelPerfect()
  dir = dir or 0
  self.markSp.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, dir)
end

function BaseScreenQTECompPoint:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  cellpfb.transform.localScale = LuaVector3.one
  return cellpfb
end

function BaseScreenQTECompPoint:Destroy()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.DestroyImmediate(self.gameObject)
  end
end
