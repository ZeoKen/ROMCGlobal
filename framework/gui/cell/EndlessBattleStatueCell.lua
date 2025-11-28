local BgCamp = {
  [Camp_Vampire] = "ac3226",
  [Camp_Human] = "4862d4"
}
local HpSpriteName = {
  [Camp_Vampire] = "battlefield_bg_bottem_15",
  [Camp_Human] = "battlefield_bg_bottem_14"
}
local HpEffectColor = {
  [Camp_Vampire] = "ac3226",
  [Camp_Human] = "4862d4"
}
local IconBgName = {
  [Camp_Vampire] = "battlefield_frame_red",
  [Camp_Human] = "battlefield_frame_blue"
}
local StarPrefix = "battlefield_star_"
local WinTextureName = "battlefield_bg_win"
local BgTextureName = "battlefield_frame_bottem"
local BaseCell = autoImport("BaseCell")
EndlessBattleStatueCell = class("EndlessBattleStatueCell", BaseCell)

function EndlessBattleStatueCell:Init()
  self:FindObjs()
end

function EndlessBattleStatueCell:FindObjs()
  self.widgetRoot = self.gameObject:GetComponent(UIWidget)
  self.headIcon = self:FindComponent("HeadIcon", UISprite)
  self.headBg = self:FindComponent("Sprite", UISprite, self.headIcon.gameObject)
  self.name = self:FindComponent("Name", UILabel)
  self.inactiveRoot = self:FindGO("Inactive")
  local starGrid = self:FindGO("StarGrid", self.inactiveRoot)
  self.stars = {}
  for i = 1, EndlessEventCountExceptStatue do
    self.stars[i] = self:FindComponent("Star" .. tostring(i), UISprite, starGrid)
  end
  self.activeRoot = self:FindGO("Active")
  local progressBar = self:FindGO("Hp", self.activeRoot)
  self.hpSlider = progressBar:GetComponent(UIProgressBar)
  self.hpSp = progressBar:GetComponent(UISprite)
  self.hpLab = self:FindComponent("Lab", UILabel, progressBar)
  self.bg = self:FindComponent("BgTexture", UITexture)
  self.win = self:FindComponent("Win", UITexture)
  PictureManager.Instance:SetBattleFieldTexture(BgTextureName, self.bg)
  PictureManager.Instance:SetBattleFieldTexture(WinTextureName, self.win)
end

function EndlessBattleStatueCell:SetHeadIcon()
  if not self.headIcon then
    return
  end
  if not self.data then
    return
  end
  local head_icon = self.data:GetHeadIcon()
  if self.headIcon.spriteName == head_icon then
    return
  end
  IconManager:SetFaceIcon(head_icon, self.headIcon)
  self.headIcon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
  self.headIcon.OpenMask = true
  self.headIcon.OpenCompress = false
  self.headIcon.NeedOffset2 = false
  local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_simple"
  Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.headIcon)
end

function EndlessBattleStatueCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  if data.state == StatueNpcState.Calm then
    return
  end
  self:SetHeadIcon()
  self.name.text = self.data.name
  if data.state == StatueNpcState.InActive then
    self:Show(self.inactiveRoot)
    self:Hide(self.activeRoot)
    self:SetInActiveState()
  else
    self:Show(self.activeRoot)
    self:Hide(self.inactiveRoot)
    self:SetActiveState()
  end
  self:SetBg()
  self:SetWinFlag()
end

function EndlessBattleStatueCell:SetBg()
  if self.camp == self.data.camp then
    return
  end
  self.camp = self.data.camp
  local color = BgCamp[self.data.camp]
  local _, c = ColorUtil.TryParseHexString(color)
  if _ then
    self.bg.color = c
  end
  self.hpSp.spriteName = HpSpriteName[self.camp]
  local _, c = ColorUtil.TryParseHexString(HpEffectColor[self.camp])
  if _ then
    self.hpLab.effectColor = c
  end
  self.headBg.spriteName = IconBgName[self.camp]
end

function EndlessBattleStatueCell:SetWinFlag()
  if self.data.winner == FuBenCmd_pb.ETEAMPWS_MIN then
    self.widgetRoot.alpha = 1
    self:Hide(self.win)
  elseif self.data.winner == self.data.camp then
    self.widgetRoot.alpha = 1
    self:Show(self.win)
  else
    self.widgetRoot.alpha = 0.5
    self:Hide(self.win)
  end
end

function EndlessBattleStatueCell:SetInActiveState()
  for i = 1, EndlessEventCountExceptStatue do
    local index
    if i > self.data.score then
      index = 3
    else
      index = self.data.camp == Camp_Human and 2 or 1
    end
    self.stars[i].spriteName = StarPrefix .. tostring(index)
  end
end

function EndlessBattleStatueCell:SetActiveState()
  local ratio = self.data.value
  EndlessBattleDebug("[无尽战场] 雕像UI界面刷新血量百分比 value  ", ratio)
  local real_ratio = ratio / 1000
  self.hpSlider.value = real_ratio
  self.hpLab.text = string.format(ZhString.Finance_Ratio, real_ratio * 100)
end

function EndlessBattleStatueCell:OnCellDestroy()
  PictureManager.Instance:UnloadBattleFieldTexture(WinTextureName, self.win)
  PictureManager.Instance:UnloadBattleFieldTexture(BgTextureName, self.bg)
end
