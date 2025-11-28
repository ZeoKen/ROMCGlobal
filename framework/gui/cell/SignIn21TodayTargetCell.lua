local baseCell = autoImport("BaseCell")
SignIn21TodayTargetCell = class("SignIn21TodayTargetCell", baseCell)
local sign21Ins

function SignIn21TodayTargetCell:Init()
  if not sign21Ins then
    sign21Ins = SignIn21Proxy.Instance
  end
  self.icon = self:FindComponent("Icon", UISprite)
  self.label1 = self:FindComponent("Label1", UILabel)
  self.label2 = self:FindComponent("Label2", UILabel)
  self.rewardLabel = SpriteLabel.new(self:FindGO("Reward"), nil, nil, nil, true)
  self.getBtn = self:FindGO("GetBtn")
  self.gotoBtn = self:FindGO("GotoBtn")
  self.got = self:FindGO("Got")
  self.tips = self:FindGO("Tips")
  self.challenge = self:FindGO("Challenge")
  self.locked = self:FindGO("Locked")
  self:AddClickEvent(self.gotoBtn, function()
    if not self.data then
      return
    end
    self:PassEvent(ServantRaidStatEvent.GoToBtnClick, self.data)
  end)
  self:AddClickEvent(self.getBtn, function()
    if not self.data then
      return
    end
    ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(self.data.id)
  end)
  self:AddCellClickEvent()
end

function SignIn21TodayTargetCell:SetData(data)
  self.data = data
  self.rewardLabel:Reset()
  if not data then
    return
  end
  IconManager:SetUIIcon(data.Icon, self.icon)
  self.icon:MakePixelPerfect()
  local scale = data.IconScale or 1
  self.icon.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.label1.text = data.Title
  self.label2.text = string.format(data.SubTitle, tostring(sign21Ins:GetTargetProgress(data.id)) or 0)
  self:UpdateReward(data.Reward)
  local state = sign21Ins:GetTargetState(data.id)
  self.got:SetActive(state == SceneUser2_pb.ENOVICE_TARGET_REWARDED)
  self.getBtn:SetActive(state == SceneUser2_pb.ENOVICE_TARGET_FINISH)
  self.gotoBtn:SetActive(state == SceneUser2_pb.ENOVICE_TARGET_GO)
  if state == SceneUser2_pb.ENOVICE_TARGET_LOCKED then
    local preData = Table_NoviceTarget[data.PreID]
    if preData then
      self.label2.text = string.format(ZhString.SignIn21View_PreTargetLocked, preData.Day, preData.Title)
    end
    self.locked:SetActive(true)
    self.icon.color = ColorUtil.NGUIShaderGray
  else
    self.locked:SetActive(false)
    self.icon.color = ColorUtil.NGUIWhite
  end
  self.tips:SetActive(false)
  self.challenge:SetActive(data.Chanllenge ~= nil)
end

function SignIn21TodayTargetCell:UpdateReward(rewardTable)
  local arr = ReusableTable.CreateArray()
  if type(rewardTable) == "table" then
    for _, id in pairs(rewardTable) do
      local rewardItemIds = ItemUtil.GetRewardItemIdsByTeamId(id)
      if rewardItemIds then
        for _, rewardItemInfo in pairs(rewardItemIds) do
          TableUtility.ArrayPushBack(arr, rewardItemInfo)
        end
      end
    end
  end
  local sb = LuaStringBuilder.CreateAsTable()
  for i = 1, #arr do
    sb:Append(string.format(ZhString.SignIn21View_RewardLabelFormat, arr[i].id, arr[i].num))
  end
  if sb:GetCount() > 0 then
    self.rewardLabel:SetText(sb:ToString())
  else
    self.rewardLabel:SetText("")
  end
  sb:Destroy()
end
