autoImport("MvpCardComposeNewPage")
DungeonMvpCardComposeNewPage = class("DungeonMvpCardComposeNewPage", MvpCardComposeNewPage)
local Prefab_Path = ResourcePathHelper.UIView("MvpCardComposeNewPage")

function DungeonMvpCardComposeNewPage:Init(initParam)
  self.makeType = CardMakeProxy.MakeType.DungeonMvpCardCompose
  self.upTimesVarType = Var_pb.EACCVARTYPE_BOSSCARD_MVPCOMPOSE_UPTIMES_2
  self.firstUpVarType = Var_pb.EACCVARTYPE_BOSSCARD_MVPCOMPOSE_UP_FIRST_CHANCE_2
  MvpCardComposeNewPage.super.Init(self, initParam)
  self.skipType = SKIPTYPE.DungeonMvpCardCompose
end

function DungeonMvpCardComposeNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container.container, true)
  obj.name = "DungeonMvpCardComposeNewPage"
  self.gameObject = obj
end

function DungeonMvpCardComposeNewPage:UpdateCardList()
  local items = CardMakeProxy.Instance:FilterDungeonMvpComposeCardByTypes(self.filterTipData.curCustomProps)
  local data = AdventureDataProxy.Instance:getItemsByFilterData(nil, items, self.filterTipData.curPropData, self.filterTipData.curKeys)
  if data and 0 < #data then
    self.cardListCtl:ResetDatas(data)
  end
end

function DungeonMvpCardComposeNewPage:OnHelpBtnClick()
  local helpData = Table_Help[32635]
  if helpData then
    TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
  end
end
