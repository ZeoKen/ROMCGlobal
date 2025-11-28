LotterySafetyTip = class("LotterySafetyTip", BaseTip)
local CardConfig = GameConfig.Lottery.CardLottery
local SafetyInheritTips

function LotterySafetyTip:Init()
  LotterySafetyTip.super.Init(self)
  SafetyInheritTips = {
    [2] = {
      [0] = ZhString.CardLottery_MVPSafetyNotInherit,
      [1] = ZhString.CardLottery_MVPSafetyInherit
    },
    [3] = {
      [0] = ZhString.CardLottery_MINISafetyNotInherit,
      [1] = ZhString.CardLottery_MINISafetyInherit
    }
  }
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.title = {}
  self.progress = {}
  self.desc = {}
  local safetyInfo1 = self:FindGO("safetyInfo1")
  self.title[1] = self:FindGO("title", safetyInfo1):GetComponent(UILabel)
  self.progress[1] = self:FindGO("Progress", safetyInfo1):GetComponent(UILabel)
  self.desc[1] = self:FindGO("desc", safetyInfo1):GetComponent(UIRichLabel)
  local safetyInfo2 = self:FindGO("safetyInfo2")
  self.title[2] = self:FindGO("title", safetyInfo2):GetComponent(UILabel)
  self.progress[2] = self:FindGO("Progress", safetyInfo2):GetComponent(UILabel)
  self.desc[2] = self:FindGO("desc", safetyInfo2):GetComponent(UIRichLabel)
  self:Hide(safetyInfo2)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function LotterySafetyTip:SetData(data)
  local lotteryType = data
  if not lotteryType then
    return
  end
  local data = LotteryProxy.Instance:GetInfo(lotteryType)
  local sConfig = CardConfig[lotteryType]
  local newConfig = GameConfig.CardLotteryNew and GameConfig.CardLotteryNew.TypeCfg and GameConfig.CardLotteryNew.TypeCfg[lotteryType]
  local isInherit = newConfig and newConfig.PrayCountInherit or false
  if data then
    for i = 2, 3 do
      local tConfig = sConfig.Tips
      local count = data:GetSafetyInfoByType(i)
      self.title[i - 1].text = tConfig[i].title
      local inheritTips = SafetyInheritTips[i][isInherit and 1 or 0]
      self.desc[i - 1].text = tConfig[i].desc .. "\n" .. inheritTips
      if count then
        if count <= 0 then
          self.progress[i - 1].text = ZhString.CardLottery_InSafety
        else
          self.progress[i - 1].text = string.format(ZhString.CardLottery_ToSafety, count)
        end
      end
    end
  end
end

function LotterySafetyTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function LotterySafetyTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function LotterySafetyTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
