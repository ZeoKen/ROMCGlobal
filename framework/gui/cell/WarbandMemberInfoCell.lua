autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
WarbandMemberInfoCell = class("WarbandMemberInfoCell", BaseCell)

function WarbandMemberInfoCell:Init()
  local portrait = self:FindGO("Portrait")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self.portraitCell:SetMinDepth(4)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.texture = self:FindComponent("Texture", UITexture)
  self.memberState = self:FindGO("MemberState")
  self.modelCameraConfig = UIModelCameraTrans.Raid
end

function WarbandMemberInfoCell:SetData(data)
  self.data = data
  if not data then
    self.memberState:SetActive(false)
    return
  end
  self.memberState:SetActive(true)
  self.lv.text = "Lv." .. tostring(data.level)
  self.name.text = AppendSpace2Str(data.name)
  local headData = HeadImageData.new()
  headData:TransByWarbandData(data)
  self.portraitCell:SetData(headData)
  local offline = not data:IsOffline()
  self.portraitCell:SetIconActive(offline, true)
  self:SetModel()
end

function WarbandMemberInfoCell:SetModel()
  if nil == self.parts then
    self.parts = Asset_Role.CreatePartArray()
  end
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  self.parts[partIndex.Body] = self.data.bodyID or 0
  self.parts[partIndex.Hair] = self.data.hairID or 0
  self.parts[partIndex.LeftWeapon] = 0
  self.parts[partIndex.RightWeapon] = 0
  self.parts[partIndex.Head] = self.data.headID or 0
  self.parts[partIndex.Face] = self.data.faceID or 0
  self.parts[partIndex.Tail] = self.data.tail or 0
  self.parts[partIndex.Eye] = self.data.eyeID or 0
  self.parts[partIndex.Mount] = 0
  self.parts[partIndex.Mouth] = self.data.mouthID or 0
  self.parts[partIndexEx.Gender] = self.data.gender or 0
  self.parts[partIndexEx.HairColorIndex] = self.data.haircolor or 0
  self.parts[partIndexEx.BodyColorIndex] = self.data.bodycolor or 0
  UIModelUtil.Instance:SetRoleModelTexture(self.texture, self.parts, self.modelCameraConfig, nil, nil, WarbandMemberTip.ShowStaticPicture)
end

function WarbandMemberInfoCell:OnCellDestroy()
  if self.parts then
    Asset_Role.DestroyPartArray(self.parts)
    self.parts = nil
  end
  if self.texture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.texture)
    self.texture = nil
  end
end
