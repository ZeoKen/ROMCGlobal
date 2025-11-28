local baseCell = autoImport("BaseCell")
SevenRoyalFamilyTreeVolumeCell = class("SevenRoyalFamilyTreeVolumeCell", baseCell)
local bgName, maxIndicatorCount = "Sevenroyalfamilies_bg_card", 4
local completeIndicatorSpName, incompleteIndicatorSpName = "new-com_icon_card_3", "new-com_icon_card_6"
local picIns, familyIns

function SevenRoyalFamilyTreeVolumeCell:Init()
  if not picIns then
    picIns = PictureManager.Instance
    familyIns = ServiceFamilyCmdProxy.Instance
  end
  self:FindObjs()
  self:InitCell()
  self:AddCellClickEvent()
end

function SevenRoyalFamilyTreeVolumeCell:FindObjs()
  self.bgTex = self:FindComponent("FamilyBg", UITexture)
  self.cmSoon = self:FindGO("CmSoon")
  self.contentParent = self:FindGO("Content")
  self.choose = self:FindGO("ChooseSymbol")
  self.emblemSp = self:FindComponent("Emblem", UISprite)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.indicators = {}
  for i = 1, maxIndicatorCount do
    self.indicators[i] = self:FindComponent("Indicator" .. i, UISprite)
  end
  self.redTip = self:FindGO("RedTipCell")
end

function SevenRoyalFamilyTreeVolumeCell:InitCell()
  if self.bgTex then
    picIns:SetUI(bgName, self.bgTex)
  end
end

function SevenRoyalFamilyTreeVolumeCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  local isShowCmSoon = data.ToBeContinued == 1
  self.cmSoon:SetActive(isShowCmSoon)
  self.contentParent:SetActive(not isShowCmSoon)
  if not isShowCmSoon then
    self.nameLabel.text = data.FamilyName
    IconManager:SetUIIcon(data.Icon, self.emblemSp)
    self:UpdateIndicators()
    self:UpdateChoose()
    self:UpdateRedTip()
  end
end

function SevenRoyalFamilyTreeVolumeCell:OnExit()
  if self.bgTex then
    picIns:UnLoadUI(bgName, self.bgTex)
  end
end

function SevenRoyalFamilyTreeVolumeCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function SevenRoyalFamilyTreeVolumeCell:UpdateChoose()
  if not self.choose then
    return
  end
  local isChoose = self.data ~= nil and self.chooseId == self.data.id
  self.choose:SetActive(isChoose)
  self.emblemSp.color = isChoose and LuaGeometry.GetTempColor(0.9372549019607843, 0.8862745098039215, 0.7764705882352941) or LuaGeometry.GetTempColor(0.3843137254901961, 0.40784313725490196, 0.5058823529411764)
end

function SevenRoyalFamilyTreeVolumeCell:UpdateIndicators()
  local data = self.data
  if not data or not next(self.indicators) then
    return
  end
  local finishedCount = familyIns:GetFinishedClueCountOfFamily(data.id)
  for i = 1, data.ClueNum do
    self:SetActive(self.indicators[i], true)
    self.indicators[i].spriteName = i <= finishedCount and completeIndicatorSpName or incompleteIndicatorSpName
  end
  for i = data.ClueNum + 1, maxIndicatorCount do
    self:SetActive(self.indicators[i], false)
  end
end

function SevenRoyalFamilyTreeVolumeCell:UpdateRedTip()
  if not self.redTip then
    return
  end
  self.redTip:SetActive(false)
  if not self.data then
    return
  end
  local count = familyIns:GetAvailableClueCountOfFamily(self.data.id)
  if 0 < count then
    self.redTip:SetActive(true)
  end
end
