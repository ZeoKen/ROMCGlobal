autoImport("RecallTaskCell")
RecallPrivilegeView = class("RecallPrivilegeView", ContainerView)
RecallPrivilegeView.ViewType = UIViewType.NormalLayer
local textTable = {
  [1] = "recall_bg_bottom",
  [2] = "recall_bg_star02",
  [3] = "recall_npc",
  [4] = "recall_bg_star01"
}

function RecallPrivilegeView:OnExit()
  for i = 1, 4 do
    local texture = self:FindGO("bgTexture" .. i):GetComponent(UITexture)
    PictureManager.Instance:UnLoadRecall(textTable[i], self.texture)
  end
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 11)
    self.timeTick = nil
  end
  RecallPrivilegeView.super.OnExit(self)
end

function RecallPrivilegeView:Init()
  self:FindObj()
  self:InitShow()
  self:AddCloseButtonEvent()
end

function RecallPrivilegeView:FindObj()
  self.texturelist = {}
  for i = 1, 4 do
    local texture = self:FindGO("bgTexture" .. i):GetComponent(UITexture)
    table.insert(self.texturelist, texture)
    if textTable[i] then
      PictureManager.Instance:SetRecall(textTable[i], texture)
    end
  end
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.tipText = self:FindGO("tipText"):GetComponent(UILabel)
  self.time = self:FindGO("time"):GetComponent(UILabel)
  self.taskScrollview = self:FindGO("taskScrollview"):GetComponent(UIScrollView)
  local taskGrid = self:FindGO("taskGrid"):GetComponent(UIGrid)
  self.taskCtrl = UIGridListCtrl.new(taskGrid, RecallTaskCell, "RecallTaskCell")
end

function RecallPrivilegeView:InitShow()
  local _GameConfigRecall = GameConfig.Recall
  if Table_Recall then
    self.taskCtrl:ResetDatas(Table_Recall)
  end
  local greeting = _GameConfigRecall.RecallWord or {}
  local randomIndex = math.random(1, #greeting)
  self.tipText.text = greeting[randomIndex]
  self.title.text = _GameConfigRecall.RecalllabelText
  local time1 = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RECALL_PRIVILEGE_TIME)
  local time2 = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_RECALL_PRIVILEGE_TIME)
  if time1 == time2 and time1 ~= 0 and not self.timeTick then
    self.endtime = time1
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 11)
  end
end

local day, hour, min, sec
local DAY_SECOND = 86400

function RecallPrivilegeView:UpdateCountDown()
  if self.endtime then
    local lefttime = self.endtime - ServerTime.CurServerTime() / 1000
    if 0 < lefttime then
      day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(lefttime)
    else
      min = 0
      sec = 0
    end
    if lefttime >= DAY_SECOND then
      self.time.text = string.format(ZhString.EVA_EndInDays, day)
    else
      self.time.text = string.format(ZhString.EVA_EndInHours, hour, min, sec)
    end
  end
end
