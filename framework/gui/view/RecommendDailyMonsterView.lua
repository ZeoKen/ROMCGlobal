autoImport("RecommendDailyMonsterCell")
RecommendDailyMonsterView = class("RecommendDailyMonsterView", BaseView)
RecommendDailyMonsterView.ViewType = UIViewType.PopUpLayer

function RecommendDailyMonsterView:Init()
  self:FindObjs()
end

function RecommendDailyMonsterView:OnEnter()
  RecommendDailyMonsterView.super.OnEnter(self)
  self:UpdateView()
end

function RecommendDailyMonsterView:OnExit()
  self.wrapCtl:Destroy()
  RecommendDailyMonsterView.super.OnExit(self)
end

function RecommendDailyMonsterView:FindObjs()
  self.titleLab = self:FindComponent("TitleLab", UILabel)
  self.titleLab.text = ZhString.RecommendDailyMonster_Title
  local container = self:FindGO("Wrap")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 7,
    cellName = "RecommendDailyMonsterCell",
    control = RecommendDailyMonsterCell
  }
  self.wrapCtl = WrapCellHelper.new(wrapConfig)
  self.wrapCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickGoBtn, self)
end

function RecommendDailyMonsterView:OnClickGoBtn(cellctl)
  local data = cellctl.data
  if not data then
    return
  end
  local manualMap = data.manualMap
  if not manualMap then
    return
  end
  local cmdArgs = {
    targetMapID = manualMap,
    npcID = data.id
  }
  local oriMonster = Table_MonsterOrigin[data.id] or {}
  local oriPos
  for i = 1, #oriMonster do
    if oriMonster[i].mapID == manualMap then
      oriPos = oriMonster[i].pos
      break
    end
  end
  if oriPos then
    cmdArgs.targetPos = TableUtil.Array2Vector3(oriPos)
  end
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
  if cmd then
    Game.Myself:TryUseQuickRide()
    Game.Myself:Client_SetMissionCommand(cmd)
    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end
end

function RecommendDailyMonsterView:UpdateView()
  local data = ServantRecommendProxy.Instance:GetDailyMonsterBaseOnLv()
  self.wrapCtl:ResetDatas(data, true)
end
