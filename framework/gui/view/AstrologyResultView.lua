AstrologyResultView = class("AstrologyResultView", ContainerView)
AstrologyResultView.ViewType = UIViewType.PopUpLayer
autoImport("ColliderItemCell")
local colorConfig = {
  [1] = {
    titleTop = LuaColor.New(0.9725490196078431, 0.5411764705882353, 0.47058823529411764, 1),
    titleBot = LuaColor.New(0.8549019607843137, 0.33725490196078434, 0.40784313725490196, 1),
    textColor = LuaColor.New(0.7490196078431373, 0.27450980392156865, 0.27450980392156865, 1)
  },
  [2] = {
    titleTop = LuaColor.New(0.8666666666666667, 0.6745098039215687, 0.25882352941176473, 1),
    titleBot = LuaColor.New(0.7725490196078432, 0.4588235294117647, 0.11764705882352941, 1),
    textColor = LuaColor.New(0.7686274509803922, 0.4823529411764706, 0.16470588235294117, 1)
  },
  [3] = {
    titleTop = LuaColor.New(0.3137254901960784, 0.796078431372549, 0.4392156862745098, 1),
    titleBot = LuaColor.New(0.16862745098039217, 0.6039215686274509, 0.1411764705882353, 1),
    textColor = LuaColor.New(0.25882352941176473, 0.5215686274509804, 0.2549019607843137, 1)
  },
  [4] = {
    titleTop = LuaColor.New(0.20784313725490197, 0.6392156862745098, 0.7450980392156863, 1),
    titleBot = LuaColor.New(0.1411764705882353, 0.26666666666666666, 0.6862745098039216, 1),
    textColor = LuaColor.New(0.25098039215686274, 0.34901960784313724, 0.6588235294117647, 1)
  }
}
local AstrologyConfig = GameConfig.Astrology
local AstrologyType = {
  Normal = SceneAugury_pb.EASTROLOGYTYPE_CONSTELLATION,
  Activity = SceneAugury_pb.EASTROLOGYTYPE_ACTIVITY
}

function AstrologyResultView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddCloseButtonEvent()
end

function AstrologyResultView:FindObj()
  self.cardbg = self:FindGO("cardbg"):GetComponent(UITexture)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.pattern1 = self:FindGO("pattern1"):GetComponent(UISprite)
  self.pattern2 = self:FindGO("pattern2"):GetComponent(UISprite)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.text = self:FindGO("text"):GetComponent(UIRichLabel)
  self.reward = self:FindGO("reward"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectLoop = self:FindGO("EffectLoop")
  self.list = self:FindGO("list"):GetComponent(UIGrid)
  self.listctrl = UIGridListCtrl.new(self.list, ColliderItemCell, "ColliderItemCell")
  self.listctrl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function AstrologyResultView:AddEvt()
end

function AstrologyResultView:OnEnter()
  AstrologyResultView.super.OnEnter(self)
  self.id = self.viewdata.viewdata and self.viewdata.viewdata.id
  self.buffid = self.viewdata.viewdata and self.viewdata.viewdata.buffid
  self:InitView()
end

function AstrologyResultView:InitView()
  if not self.id or not self.buffid then
    return
  end
  local config = Table_Astrology[self.id]
  if not config then
    return
  end
  if config.Type == AstrologyType.Normal then
    local colormap = colorConfig[config.Group]
    self.title.text = config.Title
    self.title.gradientTop = colormap.titleTop
    self.title.gradientBottom = colormap.titleBot
    self.pattern1.color = colormap.textColor
    self.pattern2.color = colormap.textColor
    self.desc.color = colormap.textColor
    self.text.text = Table_Buffer[self.buffid].BuffDesc
    self.text.color = colormap.textColor
    self.reward.color = colormap.textColor
  elseif config.Type == AstrologyType.Activity then
    local aConfig = AstrologyConfig.ActivityConfig
    local colormap = colorConfig[1]
    self.title.text = config.Title
    self.title.gradientTop = colormap.titleTop
    self.title.gradientBottom = colormap.titleBot
    self.pattern1.color = colormap.textColor
    self.pattern2.color = colormap.textColor
    self.desc.color = colormap.textColor
    self.desc.text = string.format("【%s】", aConfig.desc)
    self.text.text = Table_Buffer[self.buffid].BuffDesc
    self.text.color = colormap.textColor
    self.reward.text = string.format("【%s】", aConfig.reward)
    self.reward.color = colormap.textColor
  end
  PictureManager.Instance:SetUI(config.Pic, self.cardbg)
  self:PlayUIEffect(EffectMap.UI.Eff_divine, self.effectContainer, true)
  self:PlayUIEffect(EffectMap.UI.Eff_divine_Loop, self.effectLoop)
  local itemList = ItemUtil.GetRewardItemIdsByTeamId(config.Reward)
  local itemDataList = {}
  if itemList and 0 < #itemList then
    for i = 1, #itemList do
      local itemInfo = itemList[i]
      local tempItem = ItemData.new("", itemInfo.id)
      tempItem.num = itemInfo.num
      if itemInfo.refinelv and tempItem:IsEquip() then
        tempItem.equipInfo:SetRefine(itemInfo.refinelv)
      end
      itemDataList[#itemDataList + 1] = tempItem
    end
    self.listctrl:ResetDatas(itemDataList)
  end
end

function AstrologyResultView:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end
