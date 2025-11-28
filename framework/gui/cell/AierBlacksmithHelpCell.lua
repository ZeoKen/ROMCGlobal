local baseCell = autoImport("BaseCell")
AierBlacksmithHelpCell = class("AierBlacksmithHelpCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function AierBlacksmithHelpCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AierBlacksmithHelpCell:FindObjs()
  self.headContainer = self:FindGO("head")
  self.helpedMark = self:FindGO("helpedMark")
  self.finhelpMark = self:FindGO("finhelpMark")
  self.iconlock = self:FindGO("iconlock")
end

function AierBlacksmithHelpCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  end
  self:Show()
  self:SetNpcData(data.npcid)
  self.iconlock:SetActive(not data.unlocked)
  if data.unlocked then
  else
  end
  self.helpedMark:SetActive(data.help == true)
  self.finhelpMark:SetActive(data.help_fin == true)
end

function AierBlacksmithHelpCell:SetNpcData(npcId)
  local npcdata = Table_Monster[npcId] or Table_Npc[npcId]
  if npcdata then
    if not self.targetCell then
      self.targetCell = HeadIconCell.new()
      self.targetCell:CreateSelf(self.headContainer)
      self.targetCell:SetScale(1)
      self.targetCell:SetMinDepth(3)
      self.targetCell:HideFrame()
    end
    local data = ReusableTable.CreateTable()
    local hasSimpleIcon = npcdata.Icon and npcdata.Icon ~= ""
    local showDetailedIcon = npcdata.Body and npcdata.Hair and npcdata.HeadDefaultColor and npcdata.Gender and npcdata.Eye and npcdata.Head
    if showDetailedIcon or not hasSimpleIcon then
      data.bodyID = npcdata.Body or 0
      data.hairID = npcdata.Hair or 0
      data.haircolor = npcdata.HeadDefaultColor or 0
      data.gender = npcdata.Gender or -1
      data.eyeID = npcdata.Eye or 0
      data.headID = npcdata.Head or 0
      self.targetCell:SetData(data)
    else
      self.targetCell:SetSimpleIcon(npcdata.Icon)
    end
    ReusableTable.DestroyTable(data)
  end
end
