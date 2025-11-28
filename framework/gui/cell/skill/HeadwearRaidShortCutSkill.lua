HeadwearRaidShortCutSkill = class("HeadwearRaidShortCutSkill", ShortCutSkill)

function HeadwearRaidShortCutSkill:Init()
  self.super.Init(self)
  self.cdMask.width = 90
  self.cdMask.height = 90
  self.leadMask.width = 90
  self.leadMask.height = 90
  local exinfo = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HeadwearRaidShortCutSkillCell"))
  exinfo.transform:SetParent(self.gameObject.transform, false)
  self.needCr = self:FindComponent("cr", UISprite, exinfo)
  self.needNum = self:FindComponent("num", UILabel, exinfo)
  local press = function(obj, state)
    if state then
      if self.data ~= nil and self.data.staticData ~= nil then
        TipsView.Me():ShowStickTip(ShotCutSkillTip, self.data, NGUIUtil.AnchorSide.Left, self.bgSp, {-205, -100})
      else
        TipsView.Me():HideTip(ShotCutSkillTip)
      end
    end
  end
  self.longPress = self.clickObj:GetComponent(UILongPress)
  self.longPress.pressEvent = press
end

function HeadwearRaidShortCutSkill:SetData(obj)
  self.super.SetData(self, obj)
  if self.data ~= nil and self.data.staticData ~= nil then
    IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.cdMask, MyselfProxy.Instance:GetMyProfessionType(), true)
    IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.innercdMask, MyselfProxy.Instance:GetMyProfessionType(), true)
    IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.leadMask, MyselfProxy.Instance:GetMyProfessionType(), true)
    IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.preCondNotFit, MyselfProxy.Instance:GetMyProfessionType(), true)
    IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.bgSp, MyselfProxy.Instance:GetMyProfessionType(), true)
  end
  self.preCondNotFit.alpha = 0.6
  self.cdMask:MakePixelPerfect()
  self.innercdMask:MakePixelPerfect()
  self.leadMask:MakePixelPerfect()
  self.preCondNotFit:MakePixelPerfect()
  self.bgSp:MakePixelPerfect()
  self.iconCover:SetActive(false)
  self:UpdateExInfo()
end

function HeadwearRaidShortCutSkill:UpdateExInfo()
  local firstItemCost = self.data.staticData.SkillCost and self.data.staticData.SkillCost[1]
  if firstItemCost then
    self:Show(self.needCr.gameObject)
    self:Show(self.needNum.gameObject)
    IconManager:SetItemIcon(Table_Item[firstItemCost.itemID].Icon, self.needCr)
    self.needNum.text = firstItemCost.num
  else
    self:Hide(self.needCr.gameObject)
    self:Hide(self.needNum.gameObject)
  end
end

function HeadwearRaidShortCutSkill:SetSkillIcon(icon, profess)
  IconManager:SetSkillIconByProfess(icon, self.icon, profess, true)
  self.icon:MakePixelPerfect()
end
