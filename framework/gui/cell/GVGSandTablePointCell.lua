BaseCell = autoImport("BaseCell")
GVGSandTablePointCell = class("GVGSandTablePointCell", BaseCell)
local tempV3 = LuaVector3()
local Color = {
  Blue = Color(0.11372549019607843, 0.8431372549019608, 1, 1),
  Gray = Color(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
}

function GVGSandTablePointCell:Init()
  self:FindObjs()
end

function GVGSandTablePointCell:FindObjs()
  self.statusIcon = self.gameObject:GetComponent(UIMultiSprite)
  self.guildInfo = self:FindGO("GuildInfo")
  self.guildFlag = self:FindGO("GuildFlag"):GetComponent(UIMultiSprite)
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildTexture = self:FindGO("GuildTexture"):GetComponent(UITexture)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.hp = self:FindGO("HP")
  self.hpSlider = self.hp:GetComponent(UISlider)
  self.hpLabel = self:FindGO("Label", self.hp):GetComponent(UILabel)
  self.pointScore = self:FindGO("PointScore"):GetComponent(UISprite)
  self.uiTable = self:FindComponent("Table", UITable)
  self.ratioLab = self:FindComponent("RatioLab", UILabel)
end

function GVGSandTablePointCell:UpdatePointScore(id, score, hasPointScore)
  if self.pointScore then
    self:Hide(self.pointScore)
    self.uiTable:Reposition()
  end
end

local ratio_format = "x%d"

function GVGSandTablePointCell:UpdateRatio()
  if self.ratioLab then
    self:Hide(self.ratioLab)
    self.uiTable:Reposition()
  end
end

function GVGSandTablePointCell:SetData(data, defguild, noMoreMetal, hasPointScore, ratio)
  self.isClassic = data.isClassic
  if self.isClassic then
    self.ratio = math.min(GvgProxy.Instance:GetMaxPointScore(), data.ratio)
  end
  local pointID = data.id
  self:UpdatePointScore(pointID, data.score, hasPointScore)
  local has_occupied = data.has_occupied
  if pointID == 0 then
    self.statusIcon.CurrentState = has_occupied and 0 or 1
  elseif noMoreMetal then
    self.statusIcon.CurrentState = 3
  else
    self.statusIcon.CurrentState = has_occupied and 3 or 2
  end
  self.statusIcon:MakePixelPerfect()
  local colorIndex = 0
  local guildData = data.guildData
  local guildportrait = 1
  if not guildData or guildData.id == 0 then
    if defguild and defguild.id ~= 0 then
      colorIndex = 1
      self.guildIcon.gameObject:SetActive(true)
      self.guildName.text = defguild.name
      self.guildName.color = LuaColor.white
      self.guildName.effectColor = LuaGeometry.GetTempColor(0.12549019607843137, 0.10588235294117647, 0.08235294117647059, 1)
      guildportrait = tonumber(defguild.image)
    else
      colorIndex = 0
      self.guildName.text = ZhString.GVGSandTable_Neutral
      self.guildName.color = LuaGeometry.GetTempColor(0.6352941176470588, 0.9450980392156862, 0.6274509803921569, 1)
      self.guildName.effectColor = LuaGeometry.GetTempColor(0.2196078431372549, 0.34509803921568627, 0.1803921568627451, 1)
      self.guildIcon.gameObject:SetActive(false)
    end
  else
    if not defguild or guildData.id ~= defguild.id then
      colorIndex = 2
    else
      colorIndex = 1
    end
    self.guildIcon.gameObject:SetActive(true)
    self.guildName.text = guildData.name
    self.guildName.color = LuaColor.white
    self.guildName.effectColor = LuaGeometry.GetTempColor(0.12549019607843137, 0.10588235294117647, 0.08235294117647059, 1)
    guildportrait = tonumber(guildData.image)
  end
  self:SetColor(colorIndex)
  guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
  IconManager:SetGuildIcon(guildportrait, self.guildIcon)
  self.guildInfo.transform.localPosition = LuaGeometry.GetTempVector3(0, self.statusIcon.height - 10, 0)
  self:UpdateRatio()
end

function GVGSandTablePointCell:SetEmpty(noMoreMetal)
  self.statusIcon.CurrentState = noMoreMetal and 3 or 2
  self.guildName.text = "--"
  self:SetColor(0)
  self.guildInfo.transform.localPosition = LuaGeometry.GetTempVector3(0, self.statusIcon.height - 10, 0)
end

function GVGSandTablePointCell:SetCrystalData(data)
end

function GVGSandTablePointCell:SetColor(index)
  self.guildFlag.CurrentState = index
  self.guildFlag.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
end

function GVGSandTablePointCell:SetPos(pos)
  if pos then
    LuaVector3.Better_Set(tempV3, pos[1], pos[2], 0)
    self.gameObject.transform.localPosition = tempV3
  end
end

function GVGSandTablePointCell:SetGuildInfo(name, icon)
  self.guildName.text = name
end

function GVGSandTablePointCell:SetHPSliderEnable(bool)
  self.hp:SetActive(bool)
end

function GVGSandTablePointCell:SetMainCrystalHP(percent)
  self.hpSlider.value = percent / 100
  self.hpLabel.text = percent .. "%"
  self.statusIcon.CurrentState = percent ~= 0 and 0 or 1
end

function GVGSandTablePointCell:SetHP(percent)
  self.hpSlider.value = percent / 100
  self.hpLabel.text = percent .. "%"
  self.statusIcon.CurrentState = percent ~= 0 and 2 or 3
end

function GVGSandTablePointCell:SetEnable(var)
  if var then
    self:Show(self.pointScore)
    self.statusIcon.enabled = true
    self.guildInfo:SetActive(true)
  else
    self:Hide(self.pointScore)
    self.statusIcon.enabled = false
    self.statusIcon.CurrentState = 3
    self.guildInfo:SetActive(false)
  end
end
