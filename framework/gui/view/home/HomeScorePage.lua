autoImport("HomeScoreCombineCell")
autoImport("WrapTagListCtrl")
HomeScorePage = class("HomeScorePage", SubView)

function HomeScorePage:Init()
  self:InitTagDatas()
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function HomeScorePage:InitTagDatas()
  self.tagDatas = {
    {
      id = HomeProxy.HouseType.Home,
      name = ZhString.Home_IndoorScore,
      dataList = {}
    },
    {
      id = HomeProxy.HouseType.Garden,
      name = ZhString.Home_OutdoorScore,
      dataList = {}
    },
    {
      id = 10086,
      name = ZhString.Home_FurnitureSetScore,
      dataList = {}
    }
  }
end

function HomeScorePage:InitUI()
  self.gameObject = self:FindGO("HomeScorePage")
  self.labTotalScore = self:FindComponent("labTotalScore", UILabel)
  self.noneTip = self:FindGO("NoneTip")
  self.listHomeScores = WrapTagListCtrl.new(self:FindGO("ScoreWrap"), HomeScoreCombineCell, "HomeScoreCombineCell", WrapListCtrl_Dir.Vertical)
  self.listHomeScores:SetColNum(2)
end

function HomeScorePage:AddEvts()
  self:AddClickEvent(self:FindGO("BtnUseScore"), function(go)
  end)
  self:AddClickEvent(self:FindGO("BtnHelp"), function(go)
    self:ClickHelp()
  end)
end

function HomeScorePage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdOptUpdateHomeCmd, self.UpdateHomeScores)
end

function HomeScorePage:InitView()
  self.listHomeScores:SetTagList(self.tagDatas, self.GetFurnitureDatasByTag, self)
  self.listHomeScores:AddEventListener(MouseEvent.MouseClick, self.ClickScoreCell, self)
  self.itemDataCache = {}
end

function HomeScorePage:ClickHelp()
  local helpData = Table_Help[PanelConfig.HomeScorePage.id]
  self:OpenHelpView(helpData)
end

function HomeScorePage:UpdateHomeScores()
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if not myHouseData then
    redlog("Cannot Find My House Data!")
    return
  end
  self:GenerateHomeScoreList_Client()
  self.labTotalScore.text = myHouseData.score
  self.listHomeScores:UpdateList(true)
  self.noneTip:SetActive(#self.listHomeScores.datas < 1)
end

function HomeScorePage:GenerateHomeScoreList_Client()
  local homeScoreMap, homeInvalidMap = ReusableTable.CreateTable(), ReusableTable.CreateTable()
  local gardenScoreMap, gardenInvalidMap = ReusableTable.CreateTable(), ReusableTable.CreateTable()
  HomeProxy.Instance:GenerateSingleHouseScoreMap_Client(HomeProxy.HouseType.Home, homeScoreMap, homeInvalidMap)
  HomeProxy.Instance:GenerateSingleHouseScoreMap_Client(HomeProxy.HouseType.Garden, gardenScoreMap, gardenInvalidMap)
  self:ProcessSingleScoreMap(gardenScoreMap, homeScoreMap)
  self:ProcessSingleScoreMap(homeScoreMap, gardenScoreMap)
  self:ProcessSingleInvalidMap(gardenInvalidMap, homeScoreMap, homeInvalidMap)
  self:ProcessSingleInvalidMap(homeInvalidMap, gardenScoreMap, gardenInvalidMap)
  self:ProcessSingleTagData(self.tagDatas[HomeProxy.HouseType.Home], homeScoreMap, homeInvalidMap)
  self:ProcessSingleTagData(self.tagDatas[HomeProxy.HouseType.Garden], gardenScoreMap, gardenInvalidMap)
  ReusableTable.DestroyAndClearTable(homeScoreMap)
  ReusableTable.DestroyAndClearTable(homeInvalidMap)
  ReusableTable.DestroyAndClearTable(gardenScoreMap)
  ReusableTable.DestroyAndClearTable(gardenInvalidMap)
end

function HomeScorePage:ProcessSingleScoreMap(scoreMap, compareMap)
  local compareData
  for typeID, furnitureSData in pairs(scoreMap) do
    compareData = compareMap[typeID]
    if compareData and compareData.HomeScore >= furnitureSData.HomeScore then
      scoreMap[typeID] = nil
    end
  end
end

function HomeScorePage:ProcessSingleInvalidMap(invalidMap, compareMap1, compareMap2)
  local compareData
  for typeID, furnitureSData in pairs(invalidMap) do
    compareData = compareMap1[typeID]
    if compareData and compareData.HomeScore >= furnitureSData.HomeScore then
      invalidMap[typeID] = nil
    else
      compareData = compareMap2[typeID]
      if compareData and compareData.HomeScore >= furnitureSData.HomeScore then
        invalidMap[typeID] = nil
      end
    end
  end
end

function HomeScorePage:ProcessSingleTagData(tagData, scoreMap, invalidMap)
  self:ClearListInvalidSign(tagData.dataList)
  TableUtility.ArrayClear(tagData.dataList)
  tagData.totalScore = 0
  tagData.invalidScore = 0
  for typeID, furnitureSData in pairs(scoreMap) do
    furnitureSData.IsInvalidInHomeScorePage = false
    tagData.dataList[#tagData.dataList + 1] = furnitureSData
    tagData.totalScore = tagData.totalScore + furnitureSData.HomeScore
  end
  for typeID, furnitureSData in pairs(invalidMap) do
    furnitureSData.IsInvalidInHomeScorePage = true
    tagData.dataList[#tagData.dataList + 1] = furnitureSData
    tagData.invalidScore = tagData.invalidScore + furnitureSData.HomeScore
  end
end

function HomeScorePage:GetFurnitureDatasByTag(tagData)
  return tagData.dataList
end

function HomeScorePage:ClickScoreCell(cell)
  local itemData = self.itemDataCache[cell.staticID]
  if not itemData then
    itemData = ItemData.new("BPFurnitureItem", cell.staticID)
    self.itemDataCache[cell.staticID] = itemData
  end
  local tab = ReusableTable.CreateTable()
  tab.itemdata = itemData
  self:ShowItemTip(tab, cell.sprHeadIcon, NGUIUtil.AnchorSide.Right, {200, -220})
  ReusableTable.DestroyAndClearTable(tab)
end

function HomeScorePage:OnSwitch(isOpen)
  self:UpdateHomeScores()
  self.listHomeScores:UpdateList(true)
  self.noneTip:SetActive(#self.listHomeScores.datas < 1)
end

function HomeScorePage:OnEnter()
  HomeScorePage.super.OnEnter(self)
  self:GenerateHomeScoreList_Client()
end

function HomeScorePage:OnExit()
  HomeScorePage.super.OnExit(self)
end

function HomeScorePage:ClearListInvalidSign(dataList)
  if not dataList then
    return
  end
  for i = 1, #dataList do
    dataList[i].IsInvalidInHomeScorePage = nil
  end
end

function HomeScorePage:OnDestroy()
  for k, tagData in pairs(self.tagDatas) do
    self:ClearListInvalidSign(tagData.dataList)
  end
  self.listHomeScores:Destroy()
  HomeScorePage.super.OnDestroy(self)
end
