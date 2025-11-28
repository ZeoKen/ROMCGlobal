InviteConfirmCtl = class("InviteConfirmCtl", CoreView)
autoImport("QueueWaitCtrl")
autoImport("InviteConfirmCell")
autoImport("VoteConfirmCell")
autoImport("RollRewardCell")
autoImport("HelpConfirmCell")
autoImport("LoveChallengeConfirmCell")
InviteType = {
  Team = "teamInviteMap",
  Group = "groupTeamInviteMap",
  Guild = "guildInviteMap",
  Mercenary = "mercenaryInviteMap",
  Carrier = "carrierInviteMap",
  JoinHand = "carrierInviteMap",
  Dojo = "dojoInviteMap",
  Augury = "auguryMap",
  EndlessTower = "endlessTowerInviteMap",
  FerrisWheel = "ferrisWheelMap",
  Follow = "Follow",
  TmLeaderAcp = "TmLeaderAcp",
  Courtship = "Courtship",
  WeddingCemoney = "WeddingCemoney",
  Engage = "Engage",
  ConsentDivorce = "ConsentDivorce",
  DesertWolf = "DesertWolf",
  RaidCard = "RaidCard",
  DoubleAction = "DoubleAction",
  AltMan = "AltMan",
  PveCard = "PveCard",
  InviteWithMe = "InviteWithMe",
  HelpFinishQuest = "HelpFinishQuest",
  VoteKickOutTeamMember = "VoteKickOutTeamMember",
  MidMatch = "MidMatch",
  Roguelike = "Roguelike",
  RollReward = "RollReward",
  Warband = "Warband",
  NewbieCollegeFake = "NewbieCollegeFake",
  CustomRoom = "CustomRoom",
  AssistantInvite = "AssistantInvite",
  LoveChallenge = "LoveChallenge"
}

function InviteConfirmCtl:ctor(go)
  self.gameObject = go
  self.grid = go:GetComponent(UIGrid)
  self.queue = QueueWaitCtrl.CreateAsArray(3)
  
  function self.queue.OnChange()
    self.grid:Reposition()
  end
  
  for _, key in pairs(InviteType) do
    self[key] = {}
  end
end

function InviteConfirmCtl:AddInvite(type, data)
  if not self[type] then
    return
  end
  local cellctl = self[type][data.playerid]
  if type == InviteType.AssistantInvite then
    local clist = self[type]
    if next(clist) then
      return
    end
  end
  if not cellctl then
    if type == InviteType.VoteKickOutTeamMember then
      cellctl = VoteConfirmCell.new(self.gameObject, data)
      redlog("VoteConfirmCell ctor")
    elseif type == InviteType.RollReward then
      cellctl = RollRewardCell.new(self.gameObject, data)
    elseif type == InviteType.AssistantInvite then
      cellctl = HelpConfirmCell.new(self.gameObject, data)
    elseif type == InviteType.LoveChallenge then
      xdlog("爱情挑战弹窗")
      cellctl = LoveChallengeConfirmCell.new(self.gameObject, data)
    else
      cellctl = InviteConfirmCell.new(self.gameObject, data)
    end
    self[type][data.playerid] = cellctl
    cellctl:AddEventListener(InviteConfirmEvent.Agree, function()
      if not data.agreeNoClose then
        self:ClearInviteMap(type, cellctl)
      end
    end, self)
    cellctl:AddEventListener(InviteConfirmEvent.Refuse, function()
      self:RemoveInviteCell(type, cellctl)
    end, self)
    cellctl:AddEventListener(QueueBaseCell.EXIT, function()
      self:RemoveInviteCell(type, cellctl)
    end, self)
    self.queue:AddCell(cellctl)
  end
  self.grid:Reposition()
end

function InviteConfirmCtl:RemoveInviteById(type, id)
  local cells = self[type]
  if cells == nil then
    return
  end
  if cells[id] then
    self:RemoveInviteCell(type, cells[id])
  end
end

function InviteConfirmCtl:RemoveInviteCell(type, cellctl)
  for k, v in pairs(self[type]) do
    if v == cellctl then
      self[type][k] = nil
    end
  end
  self.grid:Reposition()
end

function InviteConfirmCtl:ClearInviteMap(type, cellctl)
  if not self[type] then
    return
  end
  for k, v in pairs(self[type]) do
    if v ~= cellctl then
      v:Exit()
    end
  end
  self[type] = {}
end
