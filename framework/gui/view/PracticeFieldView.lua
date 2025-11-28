autoImport("PracticeFieldMonsterCell")
autoImport("RewardGridCell")
PracticeFieldView = class("PracticeFieldView", ContainerView)
PracticeFieldView.ViewType = UIViewType.NormalLayer
local passedColor = {
  [1] = "B96756",
  [2] = "649EBC",
  [3] = "56A56C"
}
local _RaidID = GameConfig.endlessPrivate and GameConfig.endlessPrivate.mapraidid or 115

function PracticeFieldView:Init()
  self:InitDatas()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:StartLoading()
end

function PracticeFieldView:InitDatas()
  self.rewardItemList = {}
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function PracticeFieldView:FindObjs()
  self.dialogCell = self:FindGO("DialogCell")
  self.purikura = self:FindGO("Purikura"):GetComponent(UITexture)
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.talkLabel = self:FindGO("TalkLabel"):GetComponent(UILabel)
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.passLabel = self:FindGO("PassLabel"):GetComponent(UILabel)
  self.loadingPanel = self:FindGO("LoadingPanel")
  local monsterInfo = self:FindGO("MonsterInfo")
  self.monsterGrid = self:FindGO("MonsterGrid"):GetComponent(UIGrid)
  self.monsterInfoCtrl = UIGridListCtrl.new(self.monsterGrid, PracticeFieldMonsterCell, "PracticeFieldMonsterCell")
  self.bossContainer = self:FindGO("BossContainer")
  local rewardInfo = self:FindGO("RewardInfo")
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardInfoCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.startBtn = self:FindGO("StartBtn")
  self.itemTipContainer = self:FindGO("ItemTipContainer"):GetComponent(UISprite)
  self.helpBtn = self:FindGO("HelpBtn")
end

function PracticeFieldView:AddEvts()
  self:AddClickEvent(self.startBtn, function()
    helplog("申请进入单人爬塔")
    local limitLv = GameConfig.endlessPrivate.limitlv or 100
    local curLv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if limitLv > curLv then
      MsgManager.ShowMsgByID(2950)
      return
    end
    if TeamProxy.Instance:IHaveTeam() then
      MsgManager.ShowMsgByID(41401)
      return
    end
    ServiceFuBenCmdProxy.Instance:CallReqEnterTowerPrivate(_RaidID)
  end)
  self.rewardInfoCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:TryOpenHelpViewById(2, nil, self.helpBtn)
end

function PracticeFieldView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdTowerPrivateLayerInfo, self.InitShow)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function PracticeFieldView:StartLoading()
  local layer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
  helplog("当前通过层数信息", layer)
  ServiceFuBenCmdProxy.Instance:CallTowerPrivateLayerInfo(_RaidID, layer + 1)
  self.loadingPanel:SetActive(true)
  self:UpdateNpcPurikura()
end

function PracticeFieldView:InitShow()
  self.loadingPanel:SetActive(false)
  local currentFloor = 1
  local curInfo = EndlessTowerProxy.Instance.currentFloorInfo
  local curFloor = curInfo.currentFloor
  local monsterList = curInfo.curFloorMonsters
  local rewardList = curInfo.curFloorReward
  local bossData = curInfo.curFloorBoss
  local layer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
  local maxLayer = GameConfig.endlessPrivate.MaxLevel or 100
  self.titleLabel.text = string.format(ZhString.PracticeField_Layer, curFloor)
  local colorLabel = "[c][%s]%s[-][/c]"
  local layerText = layer .. "/" .. maxLayer
  if layer == 0 then
    layertext = string.format(colorLabel, passedColor[1], layerText)
  elseif layer < maxLayer then
    layertext = string.format(colorLabel, passedColor[2], layerText)
  else
    layertext = string.format(colorLabel, passedColor[3], layerText)
  end
  self.passLabel.text = ZhString.PracticeField_Passed .. layertext
  self.monsterInfoCtrl:ResetDatas(monsterList)
  self:UpdateItems(rewardList, self.rewardItemList)
  self.rewardInfoCtrl:ResetDatas(self.rewardItemList)
  if bossData then
    local bossCell = self:LoadPreferb_ByFullPath("GUI/v1/cell/PracticeFieldMonsterCell", self.bossContainer)
    self.bossCellCtrl = PracticeFieldMonsterCell.new(bossCell)
    self.bossCellCtrl:SetData(bossData)
  end
  self.talkLabel.text = ZhString.PracticeField_NpcTalk
end

function PracticeFieldView:UpdateItems(items, rewardItemDataList)
  if items and 0 < #items then
    for i = 1, #items do
      local data = {}
      data.itemData = ItemData.new("Reward", items[i].itemid)
      data.num = items[i].count
      table.insert(rewardItemDataList, data)
    end
  end
end

function PracticeFieldView:UpdateNpcPurikura()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local npc = viewdata and viewdata.npcdata
  if npc then
    self.purikuraTexture = npc.data.staticData.Purikura
  end
  if npc and self.nameLabel then
    self.nameLabel.text = npc.data.name
  end
  if self.purikuraTexture and self.purikuraTexture ~= "" then
    PictureManager.Instance:SetNPCLiHui(self.purikuraTexture, self.purikura)
  end
end

function PracticeFieldView:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, self.itemTipContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end

function PracticeFieldView:OnEnter()
  PracticeFieldView.super.OnEnter(self)
  self:CameraRotateToMe()
end

function PracticeFieldView:OnExit()
  PracticeFieldView.super.OnExit(self)
  self:CameraReset()
  if self.purukuraTexture and self.purukuraTexture ~= "" then
    PictureManager.Instance:UnLoadNPCLiHui(self.purikuraTexture, self.purikura)
  end
end
