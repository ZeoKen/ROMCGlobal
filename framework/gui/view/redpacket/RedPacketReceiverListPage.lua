autoImport("RedPacketReceiverCell")
RedPacketReceiverListPage = class("RedPacketReceiverListPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("RedPacketReceiverListPage")

function RedPacketReceiverListPage:Init()
  self:LoadPrefab()
  self:FindObjs()
  self.friendDatas = {}
  self.guildMemberDatas = {}
  self.guildJobDatas = {}
  self.gvgJobDatas = {}
end

function RedPacketReceiverListPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.anchorRight, true)
  obj.name = "RedPacketReceiverListPage"
  self.gameObject = obj
end

function RedPacketReceiverListPage:FindObjs()
  self:AddButtonEvent("closeButton", function()
    self:Hide()
    self:PassEvent(RedPacketEvent.OnReceiverListPageClose)
  end)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.scrollView = self:FindGO("ScrollView")
  local grid = self:FindComponent("Grid", UIGrid, self.scrollView)
  self.memberListCtrl = UIGridListCtrl.new(grid, RedPacketReceiverCell, "RedPacketReceiverCell")
  self.memberListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.gvgScrollView = self:FindGO("ScrollViewGvG")
  local gvgGrid = self:FindComponent("GridGvG", UIGrid, self.gvgScrollView)
  self.gvgMemberListCtrl = UIGridListCtrl.new(gvgGrid, RedPacketReceiverCell, "RedPacketReceiverCell")
  self.gvgMemberListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.channels = self:FindGO("channels")
  self.gvgToggle = self:FindComponent("GVGToggle", UIToggle, self.channels)
  EventDelegate.Set(self.gvgToggle.onChange, function()
    if self.gvgToggle.value then
      self:OnGVGSelected()
    end
  end)
  self.guildToggle = self:FindComponent("GuildToggle", UIToggle, self.channels)
  EventDelegate.Set(self.guildToggle.onChange, function()
    if self.guildToggle.value then
      self:OnGuildSelected()
    end
  end)
  self.empty = self:FindGO("Empty")
end

function RedPacketReceiverListPage:Show(channel, target)
  self.gameObject:SetActive(true)
  self:SetData(channel, target)
end

function RedPacketReceiverListPage:Hide()
  self.gameObject:SetActive(false)
end

function RedPacketReceiverListPage:OnExit()
  self:Clear()
end

function RedPacketReceiverListPage:Clear()
  TableUtility.ArrayClear(self.friendDatas)
  TableUtility.ArrayClear(self.guildMemberDatas)
  TableUtility.ArrayClear(self.guildJobDatas)
  TableUtility.ArrayClear(self.gvgJobDatas)
end

function RedPacketReceiverListPage:SetData(channel, target)
  self:Clear()
  local datas
  self.isShowChannels = false
  local _GuildProxy = GuildProxy.Instance
  if channel == ChatChannelEnum.Private then
    datas = self.friendDatas
    self.channels:SetActive(false)
    self.titleLabel.text = ZhString.RedPacket_FriendList
    local friends = FriendProxy.Instance:GetFriendData()
    for i = 1, #friends do
      datas[#datas + 1] = friends[i]
    end
    self:SortDatas(datas, function(l, r)
      local isFavoritel = FriendProxy.Instance:CheckIsFavorite(l.guid)
      local isFavoriter = FriendProxy.Instance:CheckIsFavorite(r.guid)
      local isMyGuildl = _GuildProxy:IsMyGuild(l.guildid)
      local isMyGuildr = _GuildProxy:IsMyGuild(r.guildid)
      if isFavoritel == isFavoriter then
        if isMyGuildl == isMyGuildr then
          return l.guid > r.guid
        else
          return isMyGuildl
        end
      else
        return isFavoritel
      end
    end)
    self.memberListCtrl:ResetDatas(datas)
    local isEmpty = not datas or #datas == 0
    self.empty:SetActive(isEmpty)
  else
    local guildData = not (not _GuildProxy:IsMyGuildHaveMercenary() or _GuildProxy:DoIHaveMercenaryGuild()) and _GuildProxy:GetMyMercenaryGuildData() or _GuildProxy.myGuildData
    local guildMembers = guildData:GetMemberList()
    if channel == ChatChannelEnum.Guild and target == 2 then
      self.titleLabel.text = ZhString.RedPacket_GuildMemberList
      self.channels:SetActive(false)
      datas = self.guildMemberDatas
      for i = 1, #guildMembers do
        if not guildMembers[i]:IsMercenary() or guildMembers[i]:IsMercenaryOfOtherGuild() then
          datas[#datas + 1] = guildMembers[i]
        end
      end
      self:SortDatas(datas, function(l, r)
        return l.job < r.job
      end)
      self.memberListCtrl:ResetDatas(datas)
      local isEmpty = not datas or #datas == 0
      self.empty:SetActive(isEmpty)
    elseif target == 3 then
      self.titleLabel.text = ZhString.RedPacket_GuildJobList
      local temp = ReusableTable.CreateTable()
      self.isShowChannels = self:IsShowChannels()
      self.channels:SetActive(self.isShowChannels)
      local setDatas = function(channel)
        local totalNum = 0
        for job, num in pairs(temp) do
          datas[#datas + 1] = {
            job = job,
            num = num,
            channel = channel
          }
          totalNum = totalNum + num
        end
        self:SortDatas(datas, function(l, r)
          return l.job < r.job
        end)
        if 0 < totalNum then
          table.insert(datas, 1, {num = totalNum, channel = channel})
        end
      end
      datas = self.guildJobDatas
      for i = 1, #guildMembers do
        if not guildMembers[i]:IsMercenary() or guildMembers[i]:IsMercenaryOfOtherGuild() then
          local job = guildMembers[i].job
          if not temp[job] then
            temp[job] = 0
          end
          temp[job] = temp[job] + 1
        end
      end
      setDatas(ChatChannelEnum.Guild)
      TableUtility.TableClear(temp)
      datas = self.gvgJobDatas
      for i = 1, #guildMembers do
        if not guildMembers[i]:IsMercenaryOfOtherGuild() then
          local job = guildMembers[i].job
          if not temp[job] then
            temp[job] = 0
          end
          temp[job] = temp[job] + 1
        end
      end
      setDatas(ChatChannelEnum.GVG)
      ReusableTable.DestroyTable(temp)
      if self.isShowChannels then
        if channel == ChatChannelEnum.GVG then
          self.gvgToggle.value = true
        elseif channel == ChatChannelEnum.Guild then
          self.guildToggle.value = true
        end
      else
        datas = channel == ChatChannelEnum.GVG and self.gvgJobDatas or self.guildJobDatas
        self.memberListCtrl:ResetDatas(datas)
        do
          local isEmpty = not datas or #datas == 0
          self.empty:SetActive(isEmpty)
        end
      end
    end
  end
end

function RedPacketReceiverListPage:SortDatas(datas, sortFunc)
  table.sort(datas, sortFunc)
end

function RedPacketReceiverListPage:OnClickItem(cell)
  local listCtrl = self.memberListCtrl
  if self.isShowChannels then
    listCtrl = self.gvgMemberListCtrl
  end
  local cells = listCtrl:GetCells()
  for i = 1, #cells do
    if cells[i] ~= cell then
      cells[i]:SetSelectState(false)
    end
  end
  self:PassEvent(RedPacketEvent.OnChooseReceiver, cell)
end

function RedPacketReceiverListPage:OnGVGSelected()
  self.gvgMemberListCtrl:ResetDatas(self.gvgJobDatas)
  self.empty:SetActive(#self.gvgJobDatas == 0)
end

function RedPacketReceiverListPage:OnGuildSelected()
  self.gvgMemberListCtrl:ResetDatas(self.guildJobDatas)
  self.empty:SetActive(#self.guildJobDatas == 0)
end

function RedPacketReceiverListPage:IsShowChannels()
  local hasGVG = false
  local config = Table_RedPacket[self.container.curRedPacketId]
  if config then
    hasGVG = TableUtility.ArrayFindIndex(config.channel, ChatChannelEnum.Guild) > 0 and 0 < TableUtility.ArrayFindIndex(config.channel, ChatChannelEnum.GVG)
  end
  local num = GuildProxy.Instance:GetMyGuildMercenaryCount()
  local AmIGuildMercenary = GuildProxy.Instance:DoIHaveMercenaryGuild()
  return hasGVG and num and 0 < num and not AmIGuildMercenary or false
end
