local BaseCell = autoImport("BaseCell")
CoinPopView = class("CoinPopView", BaseCell)

function CoinPopView:Init()
  self:InitUI()
end

function CoinPopView:InitUI()
  local bg = self:FindGO("InnerBg"):GetComponent(UISprite)
  self.bgWidth = bg.width
  self.innerTable = self:FindComponent("InnerTable", UITable)
  self.coinNum1 = self:FindComponent("coinLabel1", UILabel)
  self.coinNum2 = self:FindComponent("coinLabel2", UILabel)
  self.coinIcon1 = self:FindComponent("coinIcon1", UISprite)
  self.coinIcon2 = self:FindComponent("coinIcon2", UISprite)
  self.icon = self:FindGO("TitleIcon"):GetComponent(UISprite)
  self.uiEquipIcon = self:FindGO("EquipUIIcon"):GetComponent(UISprite)
  self.animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.animHelper = self.animHelper.animatorHelper
  self.TitleEffectContanter = self:FindGO("TitleEffectContanter")
  self:AddAnimatorEvent()
  self:PlayUISound(AudioMap.UI.GiftGet)
end

function CoinPopView:IsShowed()
  return self.isShowed
end

function CoinPopView:ResetAnim()
  self.isShowed = false
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ItemPopShowTimeLim * 1000, function(owner, deltaTime)
    self.isShowed = true
  end, self)
end

function CoinPopView:PlayHide()
  if self.isShowed then
    self:PassEvent(SystemUnLockEvent.ShowNextEvent, self.data)
  end
end

function CoinPopView:AddAnimatorEvent()
end

function CoinPopView:SetData(data)
  self.data = data
  local itemDatas = data.data
  self:ResetAnim()
  if not itemDatas then
    return
  end
  self.coinIcon2.gameObject:SetActive(2 <= #itemDatas)
  self.coinNum2.gameObject:SetActive(2 <= #itemDatas)
  if #itemDatas == 1 then
    local itemData = itemDatas[1]
    IconManager:SetItemIcon(itemData.staticData.Icon, self.coinIcon1)
    self:_SetLabelColorByItemData(self.coinNum1, itemData)
    self.coinNum1.text = itemData.num
  else
    local itemData1 = itemDatas[1]
    local itemData2 = itemDatas[2]
    self:_SetLabelColorByItemData(self.coinNum1, itemData1)
    IconManager:SetItemIcon(itemData1.staticData.Icon, self.coinIcon1)
    self.coinNum1.text = itemData1.num
    self:_SetLabelColorByItemData(self.coinNum2, itemData2)
    IconManager:SetItemIcon(itemData2.staticData.Icon, self.coinIcon2)
    self.coinNum2.text = itemData2.num
  end
  self.innerTable:Reposition()
  self.innerTable.repositionNow = true
  if itemDatas.showType == PopUp10View.ItemCoinShowType.Decompose then
    if itemDatas.params == SceneItem_pb.EDECOMPOSERESULT_FAIL then
      self:Hide(self.TitleEffectContanter)
      self:Hide(self.icon.gameObject)
      self:Show(self.uiEquipIcon.gameObject)
      IconManager:SetArtFontIcon("equip_tex_01", self.uiEquipIcon)
      self.uiEquipIcon:MakePixelPerfect()
    else
      self:Hide(self.uiEquipIcon.gameObject)
      self:Show(self.TitleEffectContanter)
      self:TrySetServerTitleIcon(Table_Item[100].Icon)
    end
  else
    self:Show(self.TitleEffectContanter)
    self:Show(self.icon.gameObject)
    self:Hide(self.uiEquipIcon.gameObject)
    self:TrySetServerTitleIcon()
  end
end

function CoinPopView:TrySetServerTitleIcon(default)
  local icon = ServiceItemProxy.spec_icon
  if StringUtil.IsEmpty(icon) then
    if not default then
      return
    end
    icon = default
  end
  if not IconManager:SetItemIcon(icon, self.icon) then
    IconManager:SetUIIcon(icon, self.icon)
  end
end

local labelColorForGold = LuaColor.New(1, 0.9176470588235294, 0.5254901960784314, 1)

function CoinPopView:_SetLabelColorByItemData(label, data)
  if not label or type(data) ~= "table" then
    return
  end
  label.color = data.staticData.Type == 130 and labelColorForGold or ColorUtil.NGUIWhite
end

function CoinPopView:OnEnter()
  local parent = self:FindComponent("TitleEffectContanter", ChangeRqByTex)
  self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("TitleEffect"), parent.transform)
  parent.excute = true
end
