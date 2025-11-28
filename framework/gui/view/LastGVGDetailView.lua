autoImport("GVGDetailView")
LastGVGDetailView = class("LastGVGDetailView", GVGDetailView)

function LastGVGDetailView:InitView()
  self.uiGridOfItems = self.goItemsRoot:GetComponent(UIGrid)
  if self.listControllerOfItems == nil then
    self.listControllerOfItems = UIGridListCtrl.new(self.uiGridOfItems, GVGDetailViewItem, "GVGDetailViewItem")
  end
  ServiceGuildCmdProxy.Instance:CallQuerySuperGvgStatCmd()
  xdlog("请求上期数据")
end

function LastGVGDetailView:addListEventListener()
  self:AddListenEvt(ServiceEvent.GuildCmdQuerySuperGvgStatCmd, self.SetContent)
end

function LastGVGDetailView:SetContent()
  local guildUserdata = SuperGvgProxy.Instance:GetLastUserDetails()
  local userName = Game.Myself.data:GetName()
  self.dataFirst = {}
  local df = self.dataFirst
  for i = 1, #guildUserdata do
    local userData = guildUserdata[i].detailData
    if userData[1] == userName then
      df[9] = userData
    end
    for j = 2, 8 do
      local lastFirstData = df[j]
      if not lastFirstData then
        df[j] = userData
      elseif lastFirstData[j] < userData[j] then
        df[j] = userData
      end
    end
  end
  self:SetIndexArangement(2)
end

function LastGVGDetailView:SetIndexArangement(index)
  local guildUserdata = SuperGvgProxy.Instance:GetLastUserDetails()
  table.sort(guildUserdata, function(x, y)
    return x.detailData[index] > y.detailData[index]
  end)
  self.listControllerOfItems:ResetDatas(guildUserdata)
  self.itemsController = self.listControllerOfItems:GetCells()
  local df = self.dataFirst
  for i = 2, 8 do
    local firstData = df[i]
    if firstData and firstData[i] ~= 0 then
      local cell = self.listControllerOfItems:FindCellByData(firstData)
      if cell then
        cell:ActiveMax(i)
      end
    end
  end
  if self.lastArrow then
    self.lastArrow:SetActive(false)
  end
  self.lastArrow = self.arrowList[index]
  self.lastArrow:SetActive(true)
  self:SetIsSelfGuild()
end
