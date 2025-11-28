autoImport("MidSummerRewardCell")
MidSummerDesireCell = class("MidSummerDesireCell", CoreView)
MidSummerDesireCell.FavorabilityType = SceneItem_pb.EFAVORITEDESIRE_TYPE_LEVELUP
local tempVector3 = LuaVector3.Zero()

function MidSummerDesireCell:ctor(obj)
  MidSummerDesireCell.super.ctor(self, obj)
  self:InitData()
  self:FindObjs()
  self:InitCell()
end

function MidSummerDesireCell:InitData()
  self.ins = MidSummerActProxy.Instance
  self.actId = self.ins.showingActId
  self.tipData = {
    funcConfig = _EmptyTable
  }
end

function MidSummerDesireCell:FindObjs()
  self.indexLabel = self:FindComponent("Index", UILabel)
  self.unlock = self:FindGO("Unlock")
  self.lock = self:FindGO("Lock")
  self.itemGrid = self:FindComponent("ItemGrid", UIGrid)
  self.normalDesc = self:FindComponent("NormalDesc", UILabel)
  self.favorabilityDescGo = self:FindGO("FavorabilityDesc")
  self.favorabilityDescLabel = self.favorabilityDescGo and self.favorabilityDescGo:GetComponent(UILabel)
  self.favorabilitySp = self:FindGO("FavorabilitySp", self.favorabilityDescGo)
  self.heartCountLabel = self:FindComponent("HeartCount", UILabel)
  self.getBtn = self:FindGO("GetBtn")
  self.got = self:FindGO("Got")
  self.progressObj = self:FindGO("Progress")
  self.progressSlider = self:FindComponent("ProgressSlider", UISlider)
  self.progressLabel = self:FindComponent("ProgressLabel", UILabel)
  if self.favorabilityDescLabel then
    self.favorabilityDescLabel.text = ZhString.MidSummerAct_FavorTarget
  end
end

function MidSummerDesireCell:InitCell()
  self.tipData.ignoreBounds = {
    self.itemGrid.gameObject
  }
  self.rewardCtrl = ListCtrl.new(self.itemGrid, MidSummerRewardCell, "MidSummerRewardCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self:AddClickEvent(self.getBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MidSummerDesireCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  if self.indexLabel then
    self.indexLabel.text = data.__displayIndex or ""
  end
  if self.lock and self.unlock then
    local isUnlock = self.ins:CheckDesireUnlock(self.actId, data.id)
    self.lock:SetActive(not isUnlock)
    self.unlock:SetActive(isUnlock)
  end
  self:UpdateReward()
  self:UpdateDesc()
  self:UpdateRight()
end

function MidSummerDesireCell:UpdateReward()
  self.rewardCtrl:ResetDatas(self:GetRewardDatas())
end

function MidSummerDesireCell:GetRewardDatas()
  self.rewardDatas = self.rewardDatas or {}
  local reward, item = self.data.Reward
  for i = 1, #reward do
    item = type(self.rewardDatas[i]) == "table" and self.rewardDatas[i] or ItemData.new()
    item:ResetData("Reward", reward[i][1])
    item.num = reward[i][2]
    self.rewardDatas[i] = item
  end
  for i = #reward + 1, #self.rewardDatas do
    self.rewardDatas[i] = nil
  end
  return self.rewardDatas
end

function MidSummerDesireCell:UpdateDesc()
  if not self.favorabilityDescGo then
    self.normalDesc.text = self:GetNormalDesc()
    return
  end
  local isFavorability = self.data.Type == MidSummerDesireCell.FavorabilityType
  self.favorabilityDescGo.gameObject:SetActive(isFavorability)
  self.normalDesc.gameObject:SetActive(not isFavorability)
  if isFavorability then
    if self.heartCountLabel then
      self.heartCountLabel.text = string.format("x%s", self.data.Count)
    end
  else
    self.normalDesc.text = self:GetNormalDesc()
  end
  local width = self.favorabilityDescLabel.printedSize.x
  local x, y, z = LuaGameObject.GetLocalPosition(self.favorabilitySp.transform)
  LuaVector3.Better_Set(tempVector3, width + 20, y, z)
  self.favorabilitySp.transform.localPosition = tempVector3
end

function MidSummerDesireCell:UpdateRight()
  local isReceived = self.ins:CheckDesireReceived(self.actId, self.data.id)
  local isComplete = self.ins:CheckDesireComplete(self.actId, self.data.id)
  local isProgress = not isReceived and not isComplete
  self.got:SetActive(isReceived)
  self.getBtn:SetActive(isComplete)
  self.progressObj:SetActive(isProgress)
  if isProgress then
    local map = self.ins:GetDesireData().desireCountMap
    local count = map and map[self.data.Type] or 0
    self.progressLabel.text = string.format("%s/%s", count, self.data.Count)
    self.progressSlider.value = count / self.data.Count
  end
end

function MidSummerDesireCell:GetNormalDesc()
  return self.data and string.format(self.data.Desc, self.data.Count) or ""
end

local tipOffset = {-240, 180}

function MidSummerDesireCell:OnClickItem(cell)
  if type(cell.data) == "table" then
    self.tipData.itemdata = cell.data
    self:ShowItemTip(self.tipData, cell.itemIcon, NGUIUtil.AnchorSide.Left, tipOffset)
  elseif type(cell.data) == "string" then
    MsgManager.FloatMsg(nil, ZhString.MidSummerAct_MoreAction)
  end
end
