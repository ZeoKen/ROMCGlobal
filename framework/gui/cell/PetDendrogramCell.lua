local BaseCell = autoImport("BaseCell")
PetDendrogramCell = class("PetDendrogramCell", BaseCell)
PetDendrogramCell.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")

function PetDendrogramCell:Init()
  self:InitView()
  self:AddCellClickEvent()
end

function PetDendrogramCell:InitView()
  self.pos = self:FindGO("Item")
  self.icon = self:FindComponent("Icon", UISprite)
  self.plus = self:FindGO("Plus")
  self.friendlyImg = self:FindGO("FriendlyImg")
  self.lvLabel = self:FindComponent("LvLab", UILabel)
  self.matLab = self:FindComponent("MatLab", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.starSp = self:FindComponent("StarSp", UISprite)
  if self.starSp then
    self.baseStarWidth = self.starSp.width
  end
end

function PetDendrogramCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.pos)
    if "PetComposeDendrogram" == data.__cname then
      local obj = self:CreatSubTree()
      if obj then
        IconManager:SetNpcMonsterIconByID(data.rootId, self.icon)
        if self.starSp then
          self.starSp.width = self.baseStarWidth * Table_Pet[data.rootId].Star
        end
        self.subTree = PetComposePreviewCell.new(obj, data.rootId, data.needRecursive)
      end
    elseif "DendrogramPart" == data.__cname then
      IconManager:SetNpcMonsterIconByID(data.root, self.icon)
      if self.starSp then
        self.starSp.gameObject:SetActive(true)
        self.starSp.width = self.baseStarWidth * Table_Pet[data.root].Star
      end
      self:SetFriendLvl()
      if data.needRecursive then
        ColorUtil.WhiteUIWidget(self.icon)
        self:Hide(self.plus)
      elseif nil == PetComposeProxy.Instance:GetComposeGuid(data.index) then
        ColorUtil.ShaderLightGrayUIWidget(self.icon)
        self:Show(self.plus)
      else
        ColorUtil.WhiteUIWidget(self.icon)
        self:Hide(self.plus)
      end
      self:Hide(self.matLab)
    elseif "MaterialItemPart" == data.__cname then
      if self.starSp then
        self.starSp.gameObject:SetActive(false)
      end
      self:Hide(self.friendlyImg)
      self:Show(self.matLab)
      local sdata = Table_Item[data.itemid]
      if sdata then
        self.matLab.text = sdata.NameZh or ""
        IconManager:SetItemIcon(sdata.Icon, self.icon)
      end
      local have = PetComposeProxy.Instance:GetComposeMaterialItemGuid(data.itemid)
      self:Hide(self.lvLabel)
      if have or data.needRecursive then
        ColorUtil.WhiteUIWidget(self.icon)
        self:Hide(self.plus)
      else
        ColorUtil.ShaderLightGrayUIWidget(self.icon)
        self:Show(self.plus)
      end
    end
  else
    self:Hide(self.pos)
  end
end

function PetDendrogramCell:SetFriendLvl()
  if self.data.needRecursive then
    self:Hide(self.lvLabel)
    self:Hide(self.friendlyImg)
  elseif self.data.rootCsv.friendlv then
    self:Show(self.lvLabel)
    self:Show(self.friendlyImg)
    self.lvLabel.text = string.format("Lv.%s", self.data.rootCsv.friendlv)
  else
    self:Hide(self.lvLabel)
    self:Hide(self.friendlyImg)
  end
end

function PetDendrogramCell:PlayEff()
  self:PlayUIEffect(EffectMap.UI.PetFuse, self.effectContainer, false)
end

local tempVector3 = LuaVector3.Zero()

function PetDendrogramCell:CreatSubTree()
  if self.icon then
    local subTree = self:CreateObj(PetDendrogramCell.CellResID, self.icon.gameObject)
    tempVector3[2] = -288
    subTree.transform.localPosition = tempVector3
    return subTree
  end
  errorLog("PetDendrogramCell cannot find icon component")
  return nil
end
