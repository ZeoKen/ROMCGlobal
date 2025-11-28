MemoryEquipRewardCell = class("MemoryEquipRewardCell", BaseCell)
local QualityColor = {
  [1] = Color(0.9137254901960784, 0.5803921568627451, 0.13725490196078433, 1),
  [2] = Color(0.6666666666666666, 0.4627450980392157, 0.9411764705882353, 1),
  [3] = Color(0.054901960784313725, 0.6313725490196078, 0.8431372549019608, 1)
}
local LevelPosY, BreakPosY = 0, -21
local BgTexName = {
  [1] = "equip_Memory_bg_03",
  [2] = "equip_Memory_bg_02",
  [3] = "equip_Memory_bg_01"
}

function MemoryEquipRewardCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function MemoryEquipRewardCell:FindObjs()
  self:AddCellClickEvent()
  self.bgTex = self.gameObject:GetComponent(UITexture)
  self.title = self:FindComponent("Title", UILabel)
  self.posTitle = self:FindComponent("PosTitle", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.icon = self:FindComponent("Icon", UIWidget)
  local longPress = self.icon.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, isPress)
      if isPress then
        self:OnLongPress()
      end
    end
  end
  self.breakLabel = self:FindGO("BreakLabel")
  self.oldLevel = self:FindComponent("OldLevel", UILabel)
  self.newLevel = self:FindComponent("NewLevel", UILabel)
  self.rewardPart = self:FindGO("RewardPart")
  self.levelPart = self:FindGO("LevelPart")
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
  self.stateLabel = self:FindComponent("StateLabel", UILabel)
  self.choose = self:FindGO("Choose")
  self.levelGO = self:FindGO("LevelGO")
  self.levelBg = self:FindComponent("LevelBg", UIMultiSprite)
  self.rewardBg = self:FindComponent("RewardBg", UIMultiSprite)
  self.emptyBg = self:FindComponent("EmptyBg", UIMultiSprite)
  self.parentTrans = self.trans.parent
  self.upEffectTipLabel = self:FindComponent("UpEffectTip", UILabel)
end

function MemoryEquipRewardCell:SetData(data)
  self.data = data
  if data then
    if data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK or data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_MAX_BREAK then
      self.title.text = ZhString.MemoryEquipReward_Break
    else
      self.title.text = ZhString.MemoryEquipReward_Level
    end
    self.posTitle.text = GameConfig.EquipPosName[data.pos]
    self.posTitle.color = QualityColor[data.quality]
    self.oldLevel.text = string.format(ZhString.MemoryEquipReward_LevelFormat, data.oldLevel)
    self.newLevel.text = string.format(ZhString.MemoryEquipReward_LevelFormat, data.newLevel)
    self.levelBg.CurrentState = data.quality - 1
    self.rewardBg.CurrentState = data.quality - 1
    self.emptyBg.CurrentState = data.quality - 1
    self.levelPart:SetActive(data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_UP_LEVEL or data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK)
    self.rewardPart:SetActive(data.state ~= FuBenCmd_pb.EMEMORY_EQUIP_REWARD_UP_LEVEL and data.state ~= FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK)
    self.breakLabel:SetActive(data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK)
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.levelGO)
    y = data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK and BreakPosY or LevelPosY
    LuaGameObject.SetLocalPositionGO(self.levelGO, x, y, z)
    if data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_MAX_LEVEL then
      self.stateLabel.text = string.format(ZhString.MemoryEquipReward_MaxLevel, data.newLevel)
    elseif data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_EMPTY then
      self.stateLabel.text = ZhString.MemoryEquipReward_Empty
    elseif data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_MAX_BREAK then
      self.stateLabel.text = ZhString.MemoryEquipReward_MaxBreak
    end
    if data.rewards then
      local str = ""
      for i = 1, #data.rewards do
        local itemData = data.rewards[i]
        str = str .. string.format(ZhString.MemoryEquipReward_Reward, itemData:GetName(), itemData.num)
        if i < #data.rewards then
          str = str .. "\n"
        end
      end
      self.rewardLabel.text = str
    end
    PictureManager.Instance:SetEquipMemoryTexture(BgTexName[data.quality], self.bgTex)
    local memoryData = data:GetEquipMemoryData()
    if memoryData then
      local config = Table_Item[memoryData.staticId]
      if config then
        self.name.text = config.NameZh
      end
      local obj = self:LoadPreferb("cell/ItemCell", self.icon.gameObject)
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      local itemCell = ItemCell.new(obj)
      local itemData = ItemData.new("EquipMemory", memoryData.staticId)
      itemData.equipMemoryData = memoryData
      itemData.hideMemoryCorner = true
      itemCell:SetData(itemData)
      self.tipData.itemdata = itemData
      if data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_UP_LEVEL then
        self.upEffectTipLabel.text = ZhString.MemoryEquipReward_LevelUpEffectTip
      elseif data.state == FuBenCmd_pb.EMEMORY_EQUIP_REWARD_TO_BREAK then
        local excessConfig = GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
        if excessConfig then
          local entry = excessConfig[data.newLevel]
          entry = entry and entry // 10 or 0
          if 0 < entry then
            local attr = memoryData.memoryAttrs[entry]
            if attr then
              local effectConfig = Game.ItemMemoryEffect[attr.id]
              local configId = effectConfig and effectConfig.level[1]
              effectConfig = configId and Table_ItemMemoryEffect[configId]
              self.upEffectTipLabel.text = effectConfig and effectConfig.UpgradeDesc or ""
            end
          end
        end
      end
    end
  end
  self.isHighlight = false
end

function MemoryEquipRewardCell:SetChoose(isChoose)
  self.choose:SetActive(isChoose)
end

function MemoryEquipRewardCell:OnLongPress()
  if self.tipData.itemdata then
    local x, y, z = NGUIUtil.GetUIPositionXYZ(self.icon.gameObject)
    if 0 < x then
      self:ShowItemTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Left, {-280, 0})
    else
      self:ShowItemTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {280, 0})
    end
  end
end

function MemoryEquipRewardCell:OnCellDestroy()
  if self.data then
    PictureManager.Instance:UnloadEquipMemoryTexture(BgTexName[self.data.quality], self.bgTex)
  end
end

function MemoryEquipRewardCell:SetHighlight(parent)
  self.trans:SetParent(parent, false)
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
  self.isHighlight = true
end

function MemoryEquipRewardCell:ResetHighlight()
  if not self.isHighlight then
    return
  end
  self.trans:SetParent(self.parentTrans, false)
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
  self.isHighlight = false
end
