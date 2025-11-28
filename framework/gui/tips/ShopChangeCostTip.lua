ShopChangeCostTip = class("ShopChangeCostTip", BaseTip)
autoImport("ShopChangeCostCell")

function ShopChangeCostTip:Init()
  ShopChangeCostTip.super.Init(self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.bgSprite = self:FindGO("Bg"):GetComponent(UISprite)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.cellCtrl = UIGridListCtrl.new(self.grid, ShopChangeCostCell, "ShopChangeCostCell")
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  local panel = self.gameObject:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 264
  end
end

function ShopChangeCostTip:SetData(data)
  self.data = data
  local changeCost = data.changeCost
  local costID = data.costID
  local result = {}
  for i = 1, #changeCost do
    local stepCost = changeCost[i]
    local singleData = {
      min = stepCost.mincount,
      max = stepCost.maxcount,
      price = stepCost.moneycount,
      costID = costID
    }
    table.insert(result, singleData)
  end
  self.cellCtrl:ResetDatas(result)
  local cells = self.cellCtrl:GetCells()
  local maxWidth = 0
  for i = 1, #cells do
    local width = cells[i]:GetPriceWidth()
    if maxWidth < width then
      maxWidth = width
    end
  end
  self.bgSprite.width = 315 + maxWidth
  self.bgSprite.height = 48 + #cells * 30
end

function ShopChangeCostTip:StartCountDown()
  self.endTimeStamp = ServerTime.CurServerTime() / 1000 + 3
  TimeTickManager.Me():CreateTick(0, 1000, self.updateShow, self, 1)
end

function ShopChangeCostTip:updateShow()
  local curTime = ServerTime.CurServerTime() / 1000
  if curTime > self.endTimeStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    self:CloseSelf()
  end
end

function ShopChangeCostTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function ShopChangeCostTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function ShopChangeCostTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TimeTickManager.Me():ClearTick(self)
  xdlog("ShopChangeCostTip:CloseSelf")
  TipsView.Me():HideCurrent()
end

function ShopChangeCostTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
