autoImport("RedPacketRestItemCell")
RedPacketDetailPage = class("RedPacketDetailPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("RedPacketDetailPage")

function RedPacketDetailPage:Init(initParama)
  self:LoadPrefab()
  self:FindObjs()
  self:InitData(initParama)
end

function RedPacketDetailPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.anchorRight, true)
  obj.name = "RedPacketDetailPage"
  self.gameObject = obj
end

function RedPacketDetailPage:FindObjs()
  local grid = self:FindComponent("Grid", UIGrid)
  self.itemListCtrl = UIGridListCtrl.new(grid, RedPacketRestItemCell, "RedPacketRestItemCell")
  self:AddButtonEvent("closeBtn", function()
    self:Hide()
    self:PassEvent(RedPacketEvent.OnDetailPageClose)
  end)
end

function RedPacketDetailPage:InitData(initParama)
  local redPacketId = initParama[1]
  local restMultiItems = initParama[2]
  local redPacketGUID = initParama[3]
  local redPacketConfig = Table_RedPacket[redPacketId]
  local ratio = 1
  local datas = ReusableTable.CreateArray()
  if redPacketConfig.source == "gvg_new" then
    local maxBlessNum = RedPacketProxy.Instance:GetBlessedPlayerNum(redPacketGUID)
    local maxRedPacketNum = RedPacketProxy.Instance:GetGVGNewMaxRedPacketNum()
    local gvgPlayerNum = RedPacketProxy.Instance:GetGVGPlayerNum(redPacketGUID)
    ratio = (gvgPlayerNum + maxBlessNum) / maxRedPacketNum
  end
  local multiItems = redPacketConfig.multi_item
  for i = 1, #multiItems do
    local item = multiItems[i]
    local totalNum = item.item_count * math.floor(item.group_count * ratio)
    if 0 < totalNum then
      local data = {}
      data.itemid = item.itemid
      data.totalNum = totalNum
      local restItem = TableUtility.ArrayFindByPredicate(restMultiItems, function(v, args)
        return v.itemid == args
      end, item.itemid)
      data.restNum = item.item_count * (restItem and restItem.group_count or 0)
      datas[#datas + 1] = data
    end
  end
  self.itemListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
end

function RedPacketDetailPage:Show()
  self.gameObject:SetActive(true)
end

function RedPacketDetailPage:Hide()
  self.gameObject:SetActive(false)
end
