OricalCardInfoView = class("OricalCardInfoView", ContainerView)
OricalCardInfoView.ViewType = UIViewType.NormalLayer
local loadDetailGO = function(parent)
  local cell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("OricalCardDetailInfo"))
  if not cell then
    return
  end
  cell.transform:SetParent(parent.transform, false)
  cell.transform.localPosition = LuaGeometry.Const_V3_zero
  return cell
end
autoImport("WrapListCtrl")
autoImport("OricalCardCell")
autoImport("OricalCardDetailInfo")
local unlock2OutlineColor = Color(0.2980392156862745, 0.2549019607843137, 0.7725490196078432, 1)
local unlockOutlineColor = Color(0.3803921568627451, 0.3803921568627451, 0.3803921568627451, 1)

function OricalCardInfoView:Init()
  self:InitView()
  self:MapEvent()
end

function OricalCardInfoView:InitView()
  self.titleName = self:FindComponent("TitleName", UILabel)
  self.diffLabel = self:FindComponent("DiffLabel", UILabel)
  local wrap = self:FindGO("CardContent")
  self.cardInfoCtl = WrapListCtrl.new(wrap, OricalCardCell, "OricalCardCell", WrapListCtrl_Dir.Vertical)
  self.cardInfoCtl:AddEventListener(MouseEvent.MouseClick, self.ClickOricalCard, self)
  local cardDetailGO = loadDetailGO(self:FindGO("BeforePanel"))
  self.cardDetailInfo = OricalCardDetailInfo.new(cardDetailGO)
  self.cardDetailInfo.gameObject:AddComponent(CloseWhenClickOtherPlace)
  self.cardDetailInfo:Hide()
end

function OricalCardInfoView:ClickOricalCard(cell)
  self:ShowCardDetailInfo(cell.data)
end

function OricalCardInfoView:ShowCardDetailInfo(data)
  if data == nil then
    return
  end
  local cardId, num = data.id, data.num
  if cardId == nil then
    return
  end
  local cardData = Table_PveCard[cardId]
  if cardData == nil then
    self.cardDetailInfo:Hide()
    return
  end
  self.cardDetailInfo:Show()
  self.cardDetailInfo:SetData(cardData, num)
end

function OricalCardInfoView:Update()
  local cardIds
  if Game.MapManager:IsPveMode_PveCard() then
    cardIds = DungeonProxy.Instance:GetSelectCardIds()
  else
    cardIds = DungeonProxy.Instance:GetCardData(self.index)
  end
  if cardIds == nil then
    return
  end
  if self.index ~= nil then
    cardIds = self:PreHandleHandIds(cardIds)
  end
  self.cardInfoCtl:ResetDatas(cardIds)
  local myName = Game.Myself.data:GetName()
  self.titleName.text = string.format(ZhString.OricalCardInfoView_TitleName, myName)
  local diff_Index = self.index or DungeonProxy.Instance:GetNowPveCardPlayingIndex()
  self.diffLabel.text = StringUtil.IntToRoman(diff_Index % 10000)
  local pvecardLayer = math.floor(diff_Index / 10000)
  self.diffLabel.effectColor = 0 < pvecardLayer and unlock2OutlineColor or unlockOutlineColor
end

local CardTypeWeight = {
  Boss = 1,
  Environment = 2,
  Monster = 3,
  Item = 4
}

function OricalCardInfoView.CardSortFunc(a, b)
  local cardA = Table_PveCard[a]
  local cardB = Table_PveCard[b]
  local weightA = CardTypeWeight[cardA.Type]
  local weightB = CardTypeWeight[cardB.Type]
  if weightA ~= weightB then
    return weightA < weightB
  end
  return cardA.id < cardB.id
end

function OricalCardInfoView:PreHandleHandIds(cardIds)
  table.sort(cardIds, self.CardSortFunc)
  local result = {}
  for i = 1, #cardIds do
    local id = cardIds[i]
    local combineCount = #result
    if combineCount == 0 then
      local data = {id = id, num = 1}
      table.insert(result, data)
    else
      local lastData = result[combineCount]
      if lastData.id == id then
        lastData.num = lastData.num + 1
      else
        local data = {id = id, num = 1}
        table.insert(result, data)
      end
    end
  end
  return result
end

function OricalCardInfoView:MapEvent()
  self:AddListenEvt(ServiceEvent.PveCardQueryCardInfoCmd, self.HandleOpenBarrowBag)
end

function OricalCardInfoView:HandleOpenBarrowBag(note)
  self:Update()
end

function OricalCardInfoView:OnEnter()
  OricalCardInfoView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.index = viewdata.index
  self:Update()
  ServicePveCardProxy.Instance:CallQueryCardInfoCmd()
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(false)
end

function OricalCardInfoView:OnExit()
  self.cardDetailInfo:Destroy()
  OricalCardInfoView.super.OnExit(self)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(true)
end
