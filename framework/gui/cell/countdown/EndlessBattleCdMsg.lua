local textureName = "battlefield_bg_bottem_12"
autoImport("CountDownMsg")
EndlessBattleCdMsg = class("EndlessBattleCdMsg", CountDownMsg)

function EndlessBattleCdMsg:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("EndlessBattleCdMsg"), parent)
end

function EndlessBattleCdMsg:Init()
  EndlessBattleCdMsg.super.Init(self)
  self.desc = self:FindComponent("Desc", UILabel)
  self.desc.text = ZhString.EndlessBattleEvent_CDDesc
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  PictureManager.Instance:SetBattleFieldTexture(textureName, self.bgTexture)
end

function EndlessBattleCdMsg:DestroySelf()
  PictureManager.Instance:UnloadBattleFieldTexture(textureName, self.bgTexture)
  EndlessBattleCdMsg.super.DestroySelf(self)
  self.desc = nil
end
