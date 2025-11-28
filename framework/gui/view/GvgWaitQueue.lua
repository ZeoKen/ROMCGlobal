local _PrefabPath = "view/GvgWaitQueue"
GvgWaitQueue = class("GvgWaitQueue", SubView)

function GvgWaitQueue:Init()
  self:ReLoadPerferb(_PrefabPath, true)
  self:FindObj()
  self:AddUIEvt()
end

function GvgWaitQueue:FindObj()
  self.bgRoot = self:FindGO("Bg")
  self.numLab = self:FindComponent("WaitingNumLab", UILabel, self.bgRoot)
  self.nameLab = self:FindComponent("NameLab", UILabel, self.bgRoot)
  self.lineLab = self:FindComponent("LineLab", UILabel, self.bgRoot)
  self.cancelBtn = self:FindGO("CancelBtn", self.bgRoot)
end

function GvgWaitQueue:AddUIEvt()
  self:AddClickEvent(self.cancelBtn, function()
    GvgProxy.Instance:CancelQueue()
  end)
end

function GvgWaitQueue:Update()
  local _, num = GvgProxy.Instance:GetQueueInfo()
  self.numLab.text = string.format(ZhString.NewGVG_WaitQueueNum, num)
  local curRaidId = Game.MapManager:GetRaidID()
  self.nameLab.text = Game.Config_GuildStrongHold_Lobby[curRaidId] and Game.Config_GuildStrongHold_Lobby[curRaidId].Name or ""
  self.lineLab.text = GvgProxy.Instance:GetCurMapGvgGroupDesc()
end
