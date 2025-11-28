autoImport("BaseTip")
autoImport("BuffTipCell")
FloatBuffTip = class("FloatBuffTip", BaseTip)
FloatBuffTip.MaxWidth = 133
local BuffCellHeight = 90
local STORAGE_FAKE_ID = "storage_fake_id"
local MaxBuffCellHeight = 4 * BuffCellHeight + 40

function FloatBuffTip:Init()
  self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideTip(FloatBuffTip)
  end
  
  self.buffTable = self:FindGO("BuffTable"):GetComponent(UITable)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.buffListCtrl = UIGridListCtrl.new(self.buffTable, BuffTipCell, "BuffTipCell")
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self:AddEventListener(MyselfEvent.MyDataChange, self.SetTempData, self)
  self:InitFoodBuffCell()
end

function FloatBuffTip:InitFoodBuffCell()
  self.foodBuffContainer = self:FindGO("FoodBuff")
  self.desc = self:FindComponent("Desc", UILabel)
  self.descTime = self:FindComponent("DescTime", UILabel)
  self.foodGrid = self:FindComponent("FoodGrid", UIGrid)
  if self.listControllerOfItems == nil then
    self.listControllerOfItems = UIGridListCtrl.new(self.foodGrid, FoodBuffCell, "FoodBuffCell")
  end
  self.bakBoxes = {}
  for i = 1, 6 do
    self.bakBoxes[#self.bakBoxes + 1] = self:FindGO("backBox" .. i)
  end
  self.foodContainer = self:FindGO("foodContainer"):GetComponent(UIWidget)
end

function FloatBuffTip:SetData(data, forceOpen)
  if not forceOpen and (not self.data or self.data == "") then
    TipsView.Me():HideTip(FloatBuffTip)
    return
  end
  self.data = data or self.data
  if data and data.isgain ~= nil then
    self.isgain = data and data.isgain
  end
  self.isgain = self.isgain or false
  local hasfood = false
  if self.isgain then
    hasfood = self:CheckFood()
  else
    self.foodBuffContainer:SetActive(false)
  end
  local bdata = FunctionBuff.Me():GetMyBuff(self.isgain) or {}
  table.sort(bdata, FloatBuffTip._SortBuffData)
  table.insert(bdata, {type = "SaveHp"})
  table.insert(bdata, {type = "SaveSp"})
  local num = #bdata + (hasfood and 1 or 0)
  local count = 4 < num and 4 or num
  self.buffListCtrl:ResetDatas(bdata)
  if count <= 0 then
    TipsView.Me():HideTip(FloatBuffTip)
    return
  end
  local totalHeight = 50
  local cells = self.buffListCtrl:GetCells()
  for i = 1, count do
    if cells[i] then
      totalHeight = totalHeight + cells[i]:GetHeight()
    end
  end
  if hasfood then
    totalHeight = totalHeight + self.foodContainer.height
  end
  if 4 < num and totalHeight < MaxBuffCellHeight then
    self.bg.height = MaxBuffCellHeight
  else
    self.bg.height = totalHeight > MaxBuffCellHeight and MaxBuffCellHeight or totalHeight
  end
end

function FloatBuffTip._SortBuffData(a, b)
  local aBuffCfg = Table_Buffer[a.id]
  local bBuffCfg = Table_Buffer[b.id]
  if aBuffCfg and aBuffCfg.BuffEffect.type == "MultiTime" or bBuffCfg and bBuffCfg.BuffEffect.type == "MultiTime" then
    local aSortNum = aBuffCfg and aBuffCfg.BuffEffect.type == "MultiTime" and aBuffCfg.BuffEffect.rate or 0
    local bSortNum = bBuffCfg and bBuffCfg.BuffEffect.type == "MultiTime" and bBuffCfg.BuffEffect.rate or 0
    return aSortNum > bSortNum
  end
  if a.endtime and b.endtime then
    if a.endtime and b.endtime then
      return a.endtime < b.endtime
    end
  else
    return a.endtime ~= nil
  end
  if aBuffCfg and bBuffCfg and aBuffCfg.IconType and bBuffCfg.IconType and aBuffCfg.IconType ~= bBuffCfg.IconType then
    return aBuffCfg.IconType > bBuffCfg.IconType
  end
  if a.isalways ~= nil or b.isalways ~= nil then
    return a.isalways == true
  end
  if a.id == STORAGE_FAKE_ID or b.id == STORAGE_FAKE_ID then
    return a.id == STORAGE_FAKE_ID
  end
  return a.id < b.id
end

function FloatBuffTip:CheckFood()
  local foodList = FoodProxy.Instance:GetEatFoods()
  local effectiveFoodCount = 0
  if foodList and 0 < #foodList then
    for i = 1, #foodList do
      local food = foodList[i]
      if food.itemid ~= 551019 then
        effectiveFoodCount = effectiveFoodCount + 1
      end
    end
  end
  self.foodBuffContainer:SetActive(0 < effectiveFoodCount)
  if 0 < effectiveFoodCount then
    self:GetFoodBuff()
  end
  return 0 < effectiveFoodCount
end

function FloatBuffTip:GetFoodBuff()
  local buffProps, buffInvalidTimeList = FoodProxy.Instance:GetMyFoodBuffProps()
  local curentSeverTime = ServerTime.CurServerTime()
  local buffDesc = ""
  local buffDescTime = ""
  for i = 1, #buffProps do
    local buffData = buffProps[i]
    if buffData.value > 0 then
      if buffData.propVO.isPercent then
        buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. "+" .. tostring(buffData.value / 10) .. "%"
      else
        buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. "+" .. tostring(buffData.value)
      end
    elseif buffData.propVO.isPercent then
      buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. tostring(buffData.value / 10) .. "%"
    else
      buffDesc = buffDesc .. OverSea.LangManager.Instance():GetLangByKey(buffData.propVO.displayName) .. tostring(buffData.value)
    end
    local lastTime = (buffInvalidTimeList[buffData.propVO.name] - curentSeverTime / 1000) / 60
    if 0 < lastTime then
      buffDescTime = buffDescTime .. math.floor(lastTime) .. ZhString.MainViewInfoPage_Min .. "\n"
    end
    if i < #buffProps then
      buffDesc = buffDesc .. "\n"
    end
  end
  self:SetFoodBuff(buffDesc, buffDescTime)
end

function FloatBuffTip:SetFoodBuff(desc, time)
  self.desc.text = desc
  self.descTime.text = time
  UIUtil.FitLabelHeight(self.desc, FloatBuffTip.MaxWidth)
  local foods = FoodProxy.Instance:GetEatFoods()
  self.listControllerOfItems:ResetDatas(foods)
  local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
  local tasteLvInfo = Table_TasterLevel[level]
  local boxCount = 3
  if tasteLvInfo then
    boxCount = tasteLvInfo.AddBuffs
  end
  for i = 1, 6 do
    self.bakBoxes[i]:SetActive(i <= boxCount)
  end
  self.foodContainer.height = 58 + self.desc.height
end

function FloatBuffTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function FloatBuffTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end

function FloatBuffTip:OnEnter()
  FloatBuffTip.super.OnEnter(self)
  EventManager.Me():AddEventListener(MyselfEvent.BuffChange, self.SetData, self)
  EventManager.Me():AddEventListener(MyselfEvent.AddBuffs, self.SetData, self)
  EventManager.Me():AddEventListener(MyselfEvent.RemoveBuffs, self.SetData, self)
  EventManager.Me():AddEventListener(MyselfEvent.MyDataChange, self.SetData, self)
  EventManager.Me():AddEventListener(MyselfEvent.SaveHSpUpdate, self.SetData, self)
end

function FloatBuffTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function FloatBuffTip:OnExit()
  self.data = nil
  EventManager.Me():RemoveEventListener(MyselfEvent.BuffChange, self.SetData, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.AddBuffs, self.SetData, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.RemoveBuffs, self.SetData, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.MyDataChange, self.SetData, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.SaveHSpUpdate, self.SetData, self)
  if self.buffListCtrl then
    self.buffListCtrl:RemoveAll()
  end
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  return true
end
