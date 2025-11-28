autoImport("HitPollyRewardCell")
ActivityPollyRoundRewardCell = class("ActivityPollyRoundRewardCell", ItemCell)
local BIG_POLLY_REWARD = "activity_boli-king_1"
local POLLT_REWARD = "activity_boli_pink"
local BG_TX = "activity_bg"

function ActivityPollyRoundRewardCell:Init()
  self.bgTx = self:FindComponent("BgTexture", UITexture)
  self.kingTx = self:FindComponent("KingPolly", UITexture)
  self.clickEffectContainer = self:FindGO("ClickEffectContainer")
  self.nextEffectContainer = self:FindGO("NextEffectContainer")
  self.pollyTex = {}
  self.rewards = {}
  self.rewardTipEffectContainer = {}
  self.effectTip = {}
  ActivityPollyRoundRewardCell.super.Init(self)
end

function ActivityPollyRoundRewardCell:InitTex()
  PictureManager.Instance:SetHitPolly(BG_TX, self.bgTx)
  local pollyRoot = self:FindGO("Polly")
  for i = 1, pollyRoot.transform.childCount do
    local pos = self:FindGO("Pos" .. i)
    self.pollyTex[i] = pos.transform:GetComponentInChildren(UITexture, true)
    self:AddClickEvent(self.pollyTex[i].gameObject, function(g)
      self:OnHitPolly(i)
    end)
    local texName = i == 9 and BIG_POLLY_REWARD or POLLT_REWARD .. i
    self.rewardTipEffectContainer[i] = pos.transform:GetComponentInChildren(ChangeRqByTex, true)
    PictureManager.Instance:SetHitPolly(texName, self.pollyTex[i])
    local rewardCell = self:FindGO("HitPollyRewardCell" .. i, pos)
    if not rewardCell then
      local go = self:LoadPreferb("cell/HitPollyRewardCell", pos)
      go.name = "HitPollyRewardCell" .. i
      self.rewards[i] = HitPollyRewardCell.new(go)
    end
    self.pollyTex[i].gameObject:SetActive(nil == self.data.rewardData[i].itemdata)
    self.rewards[i]:SetData(self.data.rewardData[i])
    self:AddClickEvent(self.rewards[i].gameObject, function(g)
      self:OnHitRewards(self.rewards[i])
    end)
  end
end

function ActivityPollyRoundRewardCell:ResetRewardHit(round, forbidden)
  local pollyRoot = self:FindGO("Polly")
  for i = 1, 8 do
    local IsActivityDateValid = ActivityHitPollyProxy.Instance:IsActivityDateValid()
    local isCurrentRound = self.data.round == ActivityHitPollyProxy.Instance.currentRound and self.data.round == round
    local costID = ActivityHitPollyProxy.Instance:GetCoinID()
    local num = BagProxy.Instance:GetItemNumByStaticID(costID, ActivityHitPollyProxy.PACKAGE_CHECK)
    local costNum = ActivityHitPollyProxy.Instance:GetPosCost(self.data.round, i)
    if isCurrentRound and IsActivityDateValid and num >= costNum and nil == self.data.rewardData[i].itemdata then
      if nil == self.effectTip[i] then
        self.effectTip[i] = self:PlayUIEffect(EffectMap.UI.HitPollyActivity_HasReward, self.rewardTipEffectContainer[i].gameObject)
        self.effectTip[i]:SetActive(not forbidden)
      else
        self.effectTip[i]:SetActive(not forbidden)
      end
    elseif self.effectTip[i] then
      self.effectTip[i]:SetActive(false)
    end
  end
end

function ActivityPollyRoundRewardCell:PlayNextRoundEff()
  self:PlayUIEffect(EffectMap.UI.HitPollyActivity_GetBigReward, self.nextEffectContainer, true)
end

function ActivityPollyRoundRewardCell:OnHitRewards(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UISprite)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function ActivityPollyRoundRewardCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function ActivityPollyRoundRewardCell:OnHitPolly(pos)
  if pos == 9 then
    return
  end
  if self.data.round > 1 and ActivityHitPollyProxy.Instance:HasRoundRewardLeft(self.data.round - 1) then
    MsgManager.ShowMsgByID(40998)
    return
  end
  if not ActivityHitPollyProxy.Instance:IsActivityDateValid() then
    MsgManager.ShowMsgByID(40973)
    return
  end
  local costID = ActivityHitPollyProxy.Instance:GetCoinID()
  local num = BagProxy.Instance:GetItemNumByStaticID(costID, ActivityHitPollyProxy.PACKAGE_CHECK)
  local costNum = ActivityHitPollyProxy.Instance:GetPosCost(self.data.round, pos)
  if num < costNum then
    MsgManager.ShowMsgByID(40972)
    return
  end
  if self.data and self.data.round then
    self.clickEffectContainer.transform.position = self.pollyTex[pos].gameObject.transform.position
    self:PlayUIEffect(EffectMap.UI.HitPollyActivity_ClickReward, self.clickEffectContainer, true)
    ServiceActHitPollyProxy.Instance:CallActivityHitPolly(self.data.round, pos)
  end
end

function ActivityPollyRoundRewardCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.gameObject.name = "ActivityPollyRoundRewardCell" .. data.round
    self:InitTex()
    self.pollyTex[9].alpha = data.rewardData[9].itemdata == nil and 0.5 or 1
  else
    self.gameObject:SetActive(false)
  end
end

function ActivityPollyRoundRewardCell:OnCellDestroy()
  ActivityPollyRoundRewardCell.super.OnCellDestroy(self)
  PictureManager.Instance:UnLoadHitPolly(BG_TX, self.bgTx)
  for i = 1, #self.pollyTex do
    PictureManager.Instance:UnLoadHitPolly(POLLT_REWARD .. i, self.pollyTex[i])
  end
  if not self.data or not self.data.round then
    return
  end
end
