local page_prefab_name = "view/MainViewHeroJourneyPage"
local BgTextureName = "battlefield_frame_bottem"
MainViewHeroJourneyPage = class("MainViewHeroJourneyPage", SubMediatorView)

function MainViewHeroJourneyPage:Init()
  self:InitPage()
end

function MainViewHeroJourneyPage:UpdatePage(param)
  self:InitData(param)
  self:InitShow()
end

function MainViewHeroJourneyPage:InitPage()
  local anchor = self.container:FindGO("Anchor_Left").transform
  self:ReLoadPerferb(page_prefab_name)
  self:ResetParent(anchor)
  self.progressBar = self:FindComponent("ProgressBar", UIProgressBar)
  self.progressText = self:FindComponent("Lab", UILabel, self.progressBar.gameObject)
  self.title = self:FindComponent("Title", UILabel)
  self.headIcon = self:FindComponent("HeadIcon", UISprite)
  self.bgTexture = self:FindComponent("Bg", UITexture)
  PictureManager.Instance:SetBattleFieldTexture(BgTextureName, self.bgTexture)
end

function MainViewHeroJourneyPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewHeroJourneyPage:InitData(param)
  self.endTime, self.npcId, self.duration = param[1], param[2], param[3]
end

function MainViewHeroJourneyPage:InitShow()
  if not self.endTime or not self.npcId then
    return
  end
  self:SetHeadIcon()
  self:RemoveTick()
  self:AddTick()
end

function MainViewHeroJourneyPage:SetHeadIcon()
  if not self.headIcon then
    return
  end
  if not self.npcId then
    return
  end
  local static_npc = Table_Npc[self.npcId]
  if not static_npc then
    return
  end
  local name = static_npc.NameZh
  self.title.text = string.format(ZhString.MainViewHeroJourneyPage_Title, name)
  local head_icon = static_npc.Icon
  if StringUtil.IsEmpty(head_icon) then
    head_icon = "Man"
    redlog("未配置Icon，NPC ID", self.npcId)
  end
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

function MainViewHeroJourneyPage:AddTick()
  if self.tick then
    return
  end
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCD, self, 1)
end

function MainViewHeroJourneyPage:RemoveTick()
  if not self.tick then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.tick = nil
end

function MainViewHeroJourneyPage:PauseTick()
  if not self.tick then
    return
  end
  self.tick:StopTick()
end

local _format = "%.2f%%"

function MainViewHeroJourneyPage:_updateCD()
  local delta = self.endTime - ServerTime.CurServerTime() / 1000
  if 0 <= delta then
    local ratio = delta / self.duration
    self.progressBar.value = ratio
    self.progressText.text = string.format(_format, ratio * 100)
  else
    self:RemoveTick()
    GameFacade.Instance:sendNotification(PVEEvent.HeroJourney_RemoveCD)
  end
end

function MainViewHeroJourneyPage:OnExit()
  self:RemoveTick()
  PictureManager.Instance:UnloadBattleFieldTexture(BgTextureName, self.bgTexture)
  MainViewHeroJourneyPage.super.OnExit(self)
end
