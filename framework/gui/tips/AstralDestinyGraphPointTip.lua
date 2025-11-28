autoImport("AstralDestinyGraphPointBuffCell")
autoImport("AstralRewardItemCell")
autoImport("BaseTip")
AstralDestinyGraphPointTip = class("AstralDestinyGraphPointTip", BaseTip)
local IndexName = {
  "Ⅰ",
  "Ⅱ",
  "Ⅲ",
  "Ⅳ",
  "Ⅴ",
  "Ⅵ",
  "Ⅶ",
  "Ⅷ",
  "Ⅸ",
  "Ⅹ"
}

function AstralDestinyGraphPointTip:Init()
  self:FindObjs()
end

function AstralDestinyGraphPointTip:FindObjs()
  local closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
  self.bg = self:FindComponent("Bg", UISprite)
  self.titleLabel = self:FindComponent("Title", UILabel)
  local grid = self:FindComponent("BuffGrid", UIGrid)
  self.buffListCtrl = UIGridListCtrl.new(grid, AstralDestinyGraphPointBuffCell, "AstralDestinyGraphPointBuffCell")
  grid = self:FindComponent("CostGrid", UIGrid)
  self.costListCtrl = UIGridListCtrl.new(grid, AstralRewardItemCell, "AstralRewardItemCell")
  self.costPart = self:FindGO("CostItemPart")
  self.tipLabel = self:FindComponent("Tips", UILabel)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:PassEvent(UIEvent.JumpPanel)
  end)
  self.lightenBtn = self:FindGO("LightenBtn")
  self:AddClickEvent(self.lightenBtn, function()
    if self.data then
      local curSeason = AstralProxy.Instance:GetSeason()
      local costNum = self.data:GetLightenCost()
      local oldCostItem = GameConfig.Astral and GameConfig.Astral.OldMedalID
      local curCostItem = GameConfig.Astral and GameConfig.Astral.NewMedalID
      local myOldNum = BagProxy.Instance:GetItemNumByStaticID(oldCostItem, GameConfig.PackageMaterialCheck.destiny_graph)
      local myCurNum = BagProxy.Instance:GetItemNumByStaticID(curCostItem, GameConfig.PackageMaterialCheck.destiny_graph)
      if curSeason > self.data.season then
        if costNum > myOldNum then
          local deltaNum = costNum - myOldNum
          if myCurNum < deltaNum then
            MsgManager.ShowMsgByID(43576)
            return
          end
          MsgManager.ConfirmMsgByID(43575, function()
            redlog("CallLightenDestinyGraphMessCCmd", self.data.season, self.data.index)
            self:PassEvent(AstralGraphEvent.LightenPoint, self.data)
          end, nil, nil, deltaNum)
          return
        end
        self:PassEvent(AstralGraphEvent.LightenPoint, self.data)
      else
        if costNum > myCurNum then
          MsgManager.ShowMsgByID(43576)
          return
        end
        self:PassEvent(AstralGraphEvent.LightenPoint, self.data)
      end
    end
  end)
  self.lightenBtnGrey = self:FindGO("LightenBtnGrey")
  self.greyBtnLabel = self:FindComponent("Label", UILabel, self.lightenBtnGrey)
end

function AstralDestinyGraphPointTip:SetData(data)
  self.data = data
  if data then
    local season = data.season
    local index = data.index
    self.titleLabel.text = string.format(ZhString.AstralGraph_PointName, season, IndexName[index] or "")
    local buffEffects = data:GetBuffEffects()
    local datas = ReusableTable.CreateArray()
    for k, v in pairs(buffEffects) do
      local data = {}
      data.name = k
      data.value = v
      datas[#datas + 1] = data
    end
    local orderConfig = GameConfig.Astral and GameConfig.Astral.GraphPointAttrOrder
    if orderConfig then
      table.sort(datas, function(l, r)
        return orderConfig[l.name] < orderConfig[r.name]
      end)
    end
    self.buffListCtrl:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    local curSeason = AstralProxy.Instance:GetSeason()
    if not curSeason then
      redlog("当前赛季不存在!!")
      return
    end
    datas = ReusableTable.CreateArray()
    local itemId = season < curSeason and GameConfig.Astral.OldMedalID or GameConfig.Astral.NewMedalID
    local itemData = ItemData.new("", itemId)
    itemData.num = data:GetLightenCost()
    datas[#datas + 1] = itemData
    self.costListCtrl:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    local costCells = self.costListCtrl:GetCells()
    for i = 1, #costCells do
      LuaGameObject.SetLocalScaleGO(costCells[i].gameObject, 0.7, 0.7, 1)
    end
    if data:IsLocked() then
      local config = Game.AstralDestinyGraphSeasonPointMap and Game.AstralDestinyGraphSeasonPointMap[season] and Game.AstralDestinyGraphSeasonPointMap[season][index]
      local unlockNum = config and config.UnlockPassNum or ""
      local str = season < curSeason and ZhString.AstralGraph_NewSeasonUnlock or string.format(ZhString.AstralGraph_PassLevelUnlock, unlockNum)
      self.tipLabel.text = str
    elseif data:IsNoLighten() and not data:CanLighten() then
      self.tipLabel.text = ZhString.AstralGraph_NeedPreviousPoint
    end
    self.gotoBtn:SetActive(data:IsLocked() and season == curSeason)
    self.lightenBtn:SetActive(data:CanLighten())
    self.lightenBtnGrey:SetActive(not data:CanLighten() and (not data:IsLocked() or season ~= curSeason))
    self.tipLabel.gameObject:SetActive(not data:IsLighten() and not data:CanLighten())
    local greyBtnStr = data:IsLighten() and ZhString.AstralGraph_Lighted or ZhString.AstralGraph_Lighten
    self.greyBtnLabel.text = greyBtnStr
    self.costPart:SetActive(not data:IsLighten())
    self.bg.height = data:IsLighten() and 348 or 505
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.lightenBtnGrey)
    y = data:IsLighten() and -33 or -185
    LuaGameObject.SetLocalPositionGO(self.lightenBtnGrey, x, y, z)
  end
end

function AstralDestinyGraphPointTip:CloseSelf()
  self:PassEvent(UIEvent.CloseUI)
end

function AstralDestinyGraphPointTip:OnExit()
  self.buffListCtrl:Destroy()
  self.costListCtrl:Destroy()
  return AstralDestinyGraphPointTip.super.OnExit(self)
end
