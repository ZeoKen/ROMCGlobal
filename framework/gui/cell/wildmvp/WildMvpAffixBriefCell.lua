autoImport("UIAutoScrollCtrl")
local BaseCell = autoImport("BaseCell")
WildMvpAffixBriefCell = class("WildMvpAffixBriefCell", BaseCell)

function WildMvpAffixBriefCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.descScroll = self:FindComponent("DescScroll", UIScrollView)
  self.desc = self:FindComponent("Desc", UILabel)
  self.autoScrollCtrl = UIAutoScrollCtrl.new(self.descScroll, self.desc, 3, 10)
  self:AddGameObjectComp()
  self:AddCellClickEvent()
end

function WildMvpAffixBriefCell:OnDestroy()
  WildMvpAffixBriefCell.super.OnDestroy(self)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Destroy()
  end
end

function WildMvpAffixBriefCell:OnDisable()
  WildMvpAffixBriefCell.super.OnDisable(self)
  self:StopScroll(true)
end

function WildMvpAffixBriefCell:StartScroll(immediate)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Start(immediate)
  end
end

function WildMvpAffixBriefCell:StopScroll(resetPosition)
  if self.autoScrollCtrl then
    self.autoScrollCtrl:Stop(resetPosition)
  end
end

function WildMvpAffixBriefCell:SetData(data)
  self.data = data
  if data and data.staticData then
    local staticData = data.staticData
    self.title.text = staticData.Name or ""
    self.desc.text = staticData.Desc or ""
    if self.autoScrollCtrl then
      self.autoScrollCtrl:Stop(true)
    end
    if staticData.Icon then
      IconManager:SetSkillIcon(staticData.Icon, self.icon)
      self.icon:SetMaskPath(UIMaskConfig.SkillMask)
      self.icon.OpenMask = true
      self.icon.OpenCompress = true
    end
  end
end

function WildMvpAffixBriefCell:OnCollapsed(b)
  if b then
    self:StopScroll(true)
  end
end
