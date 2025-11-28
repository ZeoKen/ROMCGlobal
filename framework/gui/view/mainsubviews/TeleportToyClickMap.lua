autoImport("WorldMapMiniMapWindow")
TeleportToyClickMap = class("TeleportToyClickMap", WorldMapMiniMapWindow)
local tempV3 = LuaVector3()

function TeleportToyClickMap:AddMapClick()
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:AddClickEvent(self.mapTexture.gameObject, function(go)
    helplog("TeleportToyClickMap:MapClick")
    if self.lock then
      return
    end
    local inputWorldPos = uiCamera:ScreenToWorldPoint(Input.mousePosition)
    tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos)
    local p = self:MapPosToScene(tempV3)
    if p then
      local pos = {}
      pos.x = p[1]
      pos.y = p[2]
      pos.z = p[3]
      self.choosePos = p
      self.savedPos = pos
      self:UpdateClickPosIcon(p)
    else
      redlog("p is nil")
    end
  end)
end

function TeleportToyClickMap:UpdateClickPosIcon(pos)
  if not self.clickPos then
    self:CreateClickPosIcon()
  else
    helplog("刷新点击位置")
    self:HelpUpdatePos(self.clickPos, self.choosePos)
  end
end

function TeleportToyClickMap:CreateClickPosIcon()
  self.clickPos = self:GetMapSymbol("main_blue_02", 10)
  self:HelpUpdatePos(self.clickPos, self.choosePos)
end
