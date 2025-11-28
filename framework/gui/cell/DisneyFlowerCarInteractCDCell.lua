autoImport("BaseCDCell")
DisneyFlowerCarInteractCDCell = class("DisneyFlowerCarInteractCDCell", BaseCDCell)

function DisneyFlowerCarInteractCDCell:ctor(go, interactID, cfg)
  self.gameObject = go
  self.id = interactID
  self.data = {}
  self.data.cfg = cfg
  self:FindObjs()
  self:Init()
end

function DisneyFlowerCarInteractCDCell:Init()
  IconManager:SetUIIcon(self.data.cfg.icon, self.actionIcon)
  self:SetcdCtl(FunctionCDCommand.Me():GetCDProxy(ShotCutSkillCDRefresher))
  self:TryStartCd()
end

function DisneyFlowerCarInteractCDCell:FindObjs()
  self.actionIcon = self:FindComponent("Sprite", UISprite)
  self.actionCdSp = self:FindComponent("Sprite (1)", UISprite)
  self:AddClickEvent(self.gameObject, function(go)
    self:PlayAction()
  end)
end

function DisneyFlowerCarInteractCDCell:CDCtrl_Start()
  self.cdCtrl:Add(self)
end

function DisneyFlowerCarInteractCDCell:CDCtrl_End()
  self.cdCtrl:Remove(self)
end

function DisneyFlowerCarInteractCDCell:TryStartCd()
  if self:GetCD() > 0 then
    self:CDCtrl_Start()
  else
    self:CDCtrl_End()
  end
end

function DisneyFlowerCarInteractCDCell:PlayAction()
  if self:GetCD() > 0 then
    return
  end
  ServiceInteractCmdProxy.Instance:CallInteractNpcActionInterCmd(self.id, self.data.cfg.interactid, Game.Myself.data.id)
  self:PlayActionEffect()
end

function DisneyFlowerCarInteractCDCell:PlayActionEffect()
  local interactFC = Game.InteractNpcManager.interactNpcMap[self.data.cfg.interactid]
  if not interactFC then
    redlog("PlayActionEffect", "no interactFC")
    return
  end
  interactFC:PlayEffectOnCp(self.data.cfg.effect, self.data.cfg.cp or 1)
end

function DisneyFlowerCarInteractCDCell:GetCD()
  local cdinfo = CDProxy.Instance:GetCD(SceneUser2_pb.CD_TYPE_TRAINACTION, self.id)
  return cdinfo and cdinfo.cd or 0
end

function DisneyFlowerCarInteractCDCell:GetMaxCD()
  return self.data.cfg and self.data.cfg.cd
end

function DisneyFlowerCarInteractCDCell:RefreshCD(f)
  self.actionCdSp.fillAmount = 1 - f
  return f <= 0
end

function DisneyFlowerCarInteractCDCell:ClearCD()
  self:RefreshCD(0)
end
