autoImport("BaseCell")
AutoHealingPotionCell = class("AutoHealingPotionCell", BaseCell)
local normalCol = LuaColor(0.2196078431372549, 0.2196078431372549, 0.2196078431372549, 1)
local disableCol = LuaColor(1, 0.2196078431372549, 0.2196078431372549, 1)

function AutoHealingPotionCell:Init()
  AutoHealingPotionCell.super.Init(self)
  self:FindObjs()
end

function AutoHealingPotionCell:FindObjs()
  self.titleLabel = self:FindComponent("title", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
  self.numLabel = self:FindComponent("num", UILabel)
  self.descLabel = self:FindComponent("desc", UILabel)
  self.descRangeLabel = self:FindComponent("descRange", UILabel)
  self.checkMark = self:FindGO("checkmark")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AutoHealingPotionCell:SetData(data)
  if data then
    self.id = data.id
    self.type = data.type
    local config = Table_Item[self.id]
    if config then
      self.titleLabel.text = config.NameZh
      IconManager:SetItemIcon(config.Icon, self.icon)
      local num = BagProxy.Instance:GetItemNumByStaticID(self.id)
      if 0 < num then
        self.numLabel.color = normalCol
      else
        self.numLabel.color = disableCol
      end
      num = num ~= 1 and num or ""
      self.numLabel.text = num
      local desc = self.type == 1 and ZhString.HealingHP or ZhString.HealingSP
      self.descLabel.text = desc
      local useItemConfig = Table_UseItem[self.id]
      if useItemConfig then
        local useEffect = useItemConfig.UseEffect
        if useEffect then
          local range = self.type == 1 and useEffect.hpvalue or useEffect.spvalue
          if range then
            self.descRangeLabel.text = range[1] .. "~" .. range[2]
          end
        end
      end
      self:SetUsedState()
    end
  end
end

function AutoHealingPotionCell:SetUsedState()
  local isUsed = AutoHealingProxy.Instance:IsPotionUsed(self.type, self.id)
  self.checkMark:SetActive(isUsed)
end
