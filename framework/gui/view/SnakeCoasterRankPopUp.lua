autoImport("MiniGameRankCell")
SnakeCoasterRankPopUp = class("SnakeCoasterRankPopUp", BaseView)
SnakeCoasterRankPopUp.ViewType = UIViewType.PopUpLayer
local RankPage = 1
local RankPageSize = 100
local GetZh = function(key, default)
  return ZhString and ZhString[key] or default
end
local IsEmptyRankInfo = function(data)
  return data == nil or next(data) == nil
end
local PickSelfRank = function(data)
  if data == nil then
    return nil
  end
  if not IsEmptyRankInfo(data.selfrank) then
    return data.selfrank
  end
  if not IsEmptyRankInfo(data.self) then
    return data.self
  end
  return nil
end
local IsValidRankRecord = function(data)
  if data == nil then
    return false
  end
  local rank = tonumber(data.rank) or 0
  local score = tonumber(data.score) or 0
  return 0 < rank or 0 < score
end

function SnakeCoasterRankPopUp:Init()
  self.rankItems = {}
  self.rankSelf = nil
  self:FindObjs()
  self:AddViewEvts()
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterQueryRankCmd(RankPage, GameConfig.SnakeCoaster and GameConfig.SnakeCoaster.RankDisplayCount or RankPageSize)
  local manager = SnakeCoasterManager and SnakeCoasterManager.Me()
  if manager and manager:GetServerRecord() == nil then
    manager:RequestServerInfo()
  end
  self:InitShow()
end

function SnakeCoasterRankPopUp:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.title.text = GetZh("SnakeCoaster_Title", "Snake Coaster")
  self.rankGrid = self:FindGO("rankGrid"):GetComponent(UIGrid)
  self.rankGridCtrl = UIGridListCtrl.new(self.rankGrid, MiniGameRankCell, "MiniGameRankCell")
  self.ScrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  local myContainer = self:FindGO("MyContainer")
  self.myrankCell = MiniGameRankCell.new(myContainer)
  myContainer:SetActive(false)
  self.empty = self:FindGO("Empty")
  self.empty:SetActive(true)
  local emptyLabel = self.empty:GetComponent(UILabel)
  if emptyLabel then
    emptyLabel.text = GetZh("SnakeCoaster_RankEmpty", "No rank")
  end
  self:HideOldTabs()
end

function SnakeCoasterRankPopUp:HideOldTabs()
  local tabNames = {
    "MonsterShotTab",
    "CardTab",
    "MonsterQATab"
  }
  for i = 1, #tabNames do
    local go = self:FindGO(tabNames[i])
    if go then
      go:SetActive(false)
    end
  end
end

function SnakeCoasterRankPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3SnakeCoasterQueryRankCmd, self.HandleQueryRankCmd)
  self:AddListenEvt(SnakeCoasterEvent.InfoUpdate, self.InitShow)
end

function SnakeCoasterRankPopUp:HandleQueryRankCmd(note)
  local data = note and note.body or note
  if data == nil then
    return
  end
  self.rankItems = data.items or {}
  self.rankSelf = PickSelfRank(data)
  self:InitShow()
end

function SnakeCoasterRankPopUp:BuildRankData(item)
  if not item then
    return nil
  end
  local rank = tonumber(item.rank) or 0
  return {
    rank = rank,
    rankText = 0 < rank and rank or "-",
    name = item.name or "",
    record = item.score or 0,
    recordtime = item.timestamp or 0,
    profession = item.profession,
    portrait = item.portrait or {},
    difficulty = item.difficulty
  }
end

function SnakeCoasterRankPopUp:BuildMyRecordData()
  local manager = SnakeCoasterManager and SnakeCoasterManager.Me()
  local record = manager and manager:GetServerRecord()
  local score = record and tonumber(record.score) or 0
  if score <= 0 then
    return nil
  end
  local myself = Game and Game.Myself
  local myselfData = myself and myself.data
  local userdata = myselfData and myselfData.userdata
  local portrait = {}
  if userdata then
    portrait = {
      body = userdata:Get(UDEnum.BODY),
      hair = userdata:Get(UDEnum.HAIR),
      head = userdata:Get(UDEnum.HEAD),
      face = userdata:Get(UDEnum.FACE),
      mouth = userdata:Get(UDEnum.MOUTH),
      eye = userdata:Get(UDEnum.EYE),
      haircolor = userdata:Get(UDEnum.HAIRCOLOR),
      gender = userdata:Get(UDEnum.SEX),
      portrait_frame = userdata:Get(UDEnum.PORTRAIT_FRAME)
    }
  end
  return {
    rank = 0,
    rankText = "-",
    name = myselfData and myselfData.name or "",
    record = score,
    recordtime = record.timestamp or 0,
    profession = userdata and userdata:Get(UDEnum.PROFESSION) or nil,
    portrait = portrait
  }
end

function SnakeCoasterRankPopUp:BuildRankList()
  local items = self.rankItems or {}
  local list = {}
  for i = 1, #items do
    local data = self:BuildRankData(items[i])
    if data and data.rank and data.rank > 0 then
      list[#list + 1] = data
    end
  end
  return list
end

function SnakeCoasterRankPopUp:SetupList()
  local list = self:BuildRankList()
  self.empty:SetActive(#list == 0)
  self.rankGridCtrl:ResetDatas(list)
  self.rankGridCtrl:ResetPosition()
end

function SnakeCoasterRankPopUp:SetupMyRecord()
  local data = IsValidRankRecord(self.rankSelf) and self:BuildRankData(self.rankSelf) or self:BuildMyRecordData()
  if data then
    self.myrankCell:SetData(data)
  else
    self.myrankCell:SetData(nil)
  end
end

function SnakeCoasterRankPopUp:InitShow()
  self:SetupList()
  self:SetupMyRecord()
end
