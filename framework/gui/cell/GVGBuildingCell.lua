autoImport("GvgBuildingItemCell")
local _BaseCell = autoImport("BaseCell")
local _IconBgTex = "guild_bg_05"
local _LvPrefix = " Lv."
GVGBuildingCell = class("GVGBuildingCell", _BaseCell)
GVGBuildingCell.BtnState = {
  Sp = {"com_btn_1", "com_btn_13"},
  Color = {
    LuaColor(0 / 255, 0.12549019607843137, 0.6039215686274509, 1),
    LuaColor(0.24705882352941178, 0.7607843137254902, 0.25882352941176473, 1)
  }
}

function GVGBuildingCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function GVGBuildingCell:FindObjs()
  self.name = self:FindGO("NameLv"):GetComponent(UILabel)
  self.tipObj = self:FindGO("Tip")
  self:AddClickEvent(self.tipObj, function(go)
    self:OnClickTip()
  end)
  self.icon = self:FindComponent("Icon", UITexture)
  self.iconBg = self:FindComponent("IconBg", UITexture)
  self.btnSp = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("Label", UILabel, self.btnSp.gameObject)
  self.itemGrid = self:FindComponent("Grid", UIGrid)
  self.itemCtrl = UIGridListCtrl.new(self.itemGrid, GvgBuildingItemCell, "ItemCell")
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialItem, self)
end

function GVGBuildingCell:OnClickMaterialItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.bg
    if data then
      local callback = function()
        self:CancelChooseItem()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChooseItem()
  end
end

function GVGBuildingCell:CancelChooseItem()
  self.chooseItem = nil
  self:ShowItemTip()
end

function GVGBuildingCell:AddEvts()
  self:AddClickEvent(self.btnSp.gameObject, function()
    if self.data then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function GVGBuildingCell:OnClickTip()
  local desc = self.data and self.data.desc or ""
  TipsView.Me():ShowGeneralHelp(desc)
end

function GVGBuildingCell:SetBtnState()
  if self.data.isMaxLv then
    self.btnLab.text = ZhString.GvgBuilding_MaxLv
    self.btnLab.effectStyle = UILabel.Effect.None
    self.btnLab.color = GVGBuildingCell.BtnState.Color[2]
    self:Hide(self.btnSp)
  elseif self.data:CanOption() then
    self:setOptionBtnLab()
    self:Show(self.btnSp)
    self.btnSp.spriteName = GVGBuildingCell.BtnState.Sp[1]
    self.btnLab.effectStyle = UILabel.Effect.Outline
    self.btnLab.effectColor = GVGBuildingCell.BtnState.Color[1]
    self.btnLab.color = ColorUtil.NGUIWhite
  else
    self:Show(self.btnSp)
    self.btnSp.spriteName = GVGBuildingCell.BtnState.Sp[2]
    self.btnLab.text = ZhString.GvgBuilding_LackMaterial
    self.btnLab.effectStyle = UILabel.Effect.Outline
    self.btnLab.effectColor = ColorUtil.NGUIGray
    self.btnLab.color = ColorUtil.NGUIWhite
  end
end

function GVGBuildingCell:setOptionBtnLab()
  if self.data:InUpdate() then
    self.btnLab.text = ZhString.GvgBuilding_CancelUpgrade
  elseif self.data:InBuilding() then
    self.btnLab.text = ZhString.GvgBuilding_CancelBuild
  elseif self.data.level > 1 then
    self.btnLab.text = ZhString.GvgBuilding_Upgrade
  else
    self.btnLab.text = ZhString.GvgBuilding_Build
  end
end

function GVGBuildingCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(nil ~= data)
  if data then
    local iconName = data.icon
    if not StringUtil.IsEmpty(iconName) then
      PictureManager.Instance:SetGuildBuilding(iconName, self.icon)
    end
    PictureManager.Instance:SetGuildBuilding(_IconBgTex, self.iconBg)
    self:SetName()
    self:SetBtnState()
    local itemCost = data:GetItemCostData()
    self.itemCtrl:ResetDatas(itemCost)
  end
end

function GVGBuildingCell:SetName()
  if not self.data then
    return
  end
  if self.data.guid and self.data.guid ~= 0 then
    self.name.text = self.data.name .. _LvPrefix .. self.data.level
  else
    self.name.text = self.data.name
  end
end
