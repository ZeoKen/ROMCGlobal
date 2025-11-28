autoImport("DialogCell")
CharacterEncounterDialogCell = class("CharacterEncounterDialogCell", DialogCell)
local bgTexName = "npc_bg_bottom_b"

function CharacterEncounterDialogCell:InitView()
  CharacterEncounterDialogCell.super.InitView(self)
  self:InitBackground()
end

function CharacterEncounterDialogCell:InitBackground()
  self.bgTex = self:FindComponent("Background", UITexture)
  PictureManager.Instance:SetUI(bgTexName, self.bgTex)
end

function CharacterEncounterDialogCell:OnExit()
  CharacterEncounterDialogCell.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(bgTexName, self.bgTex)
end
