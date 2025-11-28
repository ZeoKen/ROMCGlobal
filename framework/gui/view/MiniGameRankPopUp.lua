MiniGameRankPopUp = class("MiniGameRankPopUp", BaseView)
autoImport("MiniGameRankCell")
MiniGameRankPopUp.ViewType = UIViewType.PopUpLayer
local PhotoGametype = MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_PHOTO
local CardGametype = MiniGameCmd_pb.EMINIGAMETYPE_CARD_PAIR
local QAGametype = MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_ANSWER

function MiniGameRankPopUp:Init()
  self:FindObjs()
  self.currenttype = self.viewdata.viewdata or PhotoGametype
  if self.currenttype == PhotoGametype then
    self.monsterShotTab.value = true
  elseif self.currenttype == CardGametype then
    self.cardTab.value = true
  elseif self.currenttype == QAGametype then
    self.monsterQATab.value = true
  end
  self:AddViewEvts()
end

function MiniGameRankPopUp:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.rankGrid = self:FindGO("rankGrid"):GetComponent(UIGrid)
  self.rankGridCtrl = UIGridListCtrl.new(self.rankGrid, MiniGameRankCell, "MiniGameRankCell")
  self.ScrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  local myContainer = self:FindGO("MyContainer")
  self.myrankCell = MiniGameRankCell.new(myContainer)
  myContainer:SetActive(false)
  self.empty = self:FindGO("Empty")
  self.empty:SetActive(true)
  local emtyplable = self.empty:GetComponent(UILabel)
  emtyplable.text = ZhString.MiniGame_Rank_Empty
  self.monsterShotTab = self:FindGO("MonsterShotTab"):GetComponent(UIToggle)
  EventDelegate.Set(self.monsterShotTab.onChange, function()
    if self.monsterShotTab.value then
      self.currenttype = PhotoGametype
      ServiceMiniGameCmdAutoProxy:CallMiniGameQueryRank(PhotoGametype)
      self.title.text = ZhString.MiniGame_GameName1
    end
  end)
  self.cardTab = self:FindGO("CardTab"):GetComponent(UIToggle)
  EventDelegate.Set(self.cardTab.onChange, function()
    if self.cardTab.value then
      self.currenttype = CardGametype
      ServiceMiniGameCmdAutoProxy:CallMiniGameQueryRank(CardGametype)
      self.title.text = ZhString.MiniGame_GameName2
    end
  end)
  self.monsterQATab = self:FindGO("MonsterQATab"):GetComponent(UIToggle)
  EventDelegate.Set(self.monsterQATab.onChange, function()
    if self.monsterQATab.value then
      self.currenttype = QAGametype
      ServiceMiniGameCmdAutoProxy:CallMiniGameQueryRank(QAGametype)
      self.title.text = ZhString.MiniGame_GameName3
    end
  end)
end

function MiniGameRankPopUp:ClearView()
  self.rankGridCtrl:ResetDatas({})
end

function MiniGameRankPopUp:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameQueryRank, self.InitShow)
end

function MiniGameRankPopUp:SetUpMonsterShotList()
  self.currenttype = PhotoGametype
  self:SetupList()
end

function MiniGameRankPopUp:SetUpMonsterQAList()
  self.currenttype = CardGametype
  self:SetupList()
end

function MiniGameRankPopUp:SetUpCardList()
  self.currenttype = QAGametype
  self:SetupList()
end

function MiniGameRankPopUp:SetupList()
  local list = MiniGameProxy.Instance:GetMiniGameRank(self.currenttype) or {}
  self.empty:SetActive(not list or #list == 0)
  self.rankGridCtrl:ResetDatas(list)
  self.rankGridCtrl:ResetPosition()
end

function MiniGameRankPopUp:SetupMyRecord()
  local data = MiniGameProxy.Instance:GetMyRank(self.currenttype)
  self.myrankCell:SetData(data)
end

function MiniGameRankPopUp:InitShow()
  self:ClearView()
  self:SetupList()
  self:SetupMyRecord()
end

function MiniGameRankPopUp:OnExit()
end
