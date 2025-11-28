local BaseCell = autoImport("BaseCell")
ActivityIntegrationShortCutCell = class("ActivityIntegrationShortCutCell", BaseCell)

function ActivityIntegrationShortCutCell:Init()
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("ItemIcon"):GetComponent(UISprite)
  self.headIcon = self:FindGO("HeadIcon"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function ActivityIntegrationShortCutCell:SetData(data)
  self.data = data
  local monsterID = data.MonsterID
  local itemID = data.ItemID
  local npcID = data.NpcID
  self.headIcon.gameObject:SetActive(false)
  self.itemIcon.gameObject:SetActive(false)
  if itemID then
    self.itemIcon.gameObject:SetActive(true)
    local itemData = Table_Item[itemID]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
    else
      redlog("缺少ITEM配置", itemID)
    end
  elseif monsterID then
    self.headIcon.gameObject:SetActive(true)
    local monsterData = Table_Monster[monsterID]
    if monsterData then
      IconManager:SetFaceIcon(monsterData.Icon, self.headIcon)
      self.headIcon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
      self.headIcon.OpenMask = true
      self.headIcon.OpenCompress = false
      self.headIcon.NeedOffset2 = false
      local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_simple"
      Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.headIcon)
    else
      redlog("Monster表缺少配置", monsterID)
    end
  elseif npcID then
    self.headIcon.gameObject:SetActive(true)
    local npcData = Table_Npc[npcID]
    if npcData then
      IconManager:SetFaceIcon(npcData.Icon, self.headIcon)
      self.headIcon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
      self.headIcon.OpenMask = true
      self.headIcon.OpenCompress = false
      self.headIcon.NeedOffset2 = false
      local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_simple"
      Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.headIcon)
    else
      redlog("Npc表缺少配置", npcID)
    end
  end
  self.nameLabel.text = data.Name or "?"
  local isTF = EnvChannel.IsTFBranch()
  local duration = isTF and data.TFDuration or data.Duration
  if duration then
    local startTime, endTime
    startTime = duration[1]
    endTime = duration[2]
    if startTime and endTime then
      local str = ""
      local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
      local year, month, day, hour, min, sec = startTime:match(p)
      str = str .. tonumber(month) .. "." .. tonumber(day) .. "~"
      year, month, day, hour, min, sec = endTime:match(p)
      str = str .. tonumber(month) .. "." .. tonumber(day)
      self.timeLabel.text = str
    end
  end
  local posOffset = data.pos
  if posOffset then
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(posOffset[1], posOffset[2], 0)
  end
end
