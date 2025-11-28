autoImport("SevenRoyalFamilyTreeAttrCell")
SevenRoyalFamilyTreeAttrPage = class("SevenRoyalFamilyTreeAttrPage", SubView)
local aPush, langManager, isEmpty = TableUtility.ArrayPushBack, OverSea.LangManager.Instance(), StringUtil.IsEmpty

function SevenRoyalFamilyTreeAttrPage:Init()
  self:ReLoadPerferb("view/SevenRoyalFamilyTreeAttrPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.noneTip = self:FindGO("NoneTip")
  self.listCtrl = ListCtrl.new(self:FindComponent("Table", UITable), SevenRoyalFamilyTreeAttrCell, "SevenRoyalFamilyTreeAttrCell")
  self:AddEvents()
end

function SevenRoyalFamilyTreeAttrPage:AddEvents()
  self:AddListenEvt(ServiceEvent.FamilyCmdClueDataNtfFamilyCmd, self.UpdatePage)
  self:AddListenEvt(ServiceEvent.FamilyCmdClueUnlockFamilyCmd, self.UpdatePage)
  self:AddListenEvt(ServiceEvent.FamilyCmdClueRewardFamilyCmd, self.UpdatePage)
end

function SevenRoyalFamilyTreeAttrPage:OnActivate()
  self:UpdatePage()
end

function SevenRoyalFamilyTreeAttrPage:UpdatePage()
  local arr, tmp = ReusableTable.CreateArray(), ReusableTable.CreateTable()
  local effects, data = ServiceFamilyCmdProxy.Instance:GetUnlockedMapEffectIds()
  for i = 1, #effects do
    data = Table_AssetEffect[effects[i]]
    if data then
      self:SplitAndAggregate(data.Desc, tmp)
    end
  end
  for prop, vData in pairs(tmp) do
    data = ReusableTable.CreateTable()
    data.desc, data.value = prop, table.concat(vData)
    aPush(arr, data)
  end
  self.listCtrl:ResetDatas(arr)
  self.noneTip:SetActive(#arr == 0)
  for i = 1, #arr do
    ReusableTable.DestroyAndClearTable(arr[i])
  end
  ReusableTable.DestroyAndClearArray(arr)
  for _, list in pairs(tmp) do
    ReusableTable.DestroyAndClearArray(list)
  end
  ReusableTable.DestroyAndClearTable(tmp)
end

function SevenRoyalFamilyTreeAttrPage:SplitAndAggregate(str, tmp)
  if isEmpty(str) or not tmp then
    return
  end
  if not BranchMgr.IsChina() then
    str = langManager:GetLangByKey(str):gsub("＋", "+"):gsub("－", "-")
  end
  for prop, oper, v, percent in string.gmatch(str, "(.+)([+-])(%w+)(%%?)") do
    if not isEmpty(prop) then
      v = tonumber(v) or 0
      if tmp[prop] then
        tmp[prop][2] = tmp[prop][2] + v
      else
        local list = ReusableTable.CreateArray()
        aPush(list, oper or "")
        aPush(list, v)
        aPush(list, percent)
        tmp[prop] = list
      end
    end
  end
end
