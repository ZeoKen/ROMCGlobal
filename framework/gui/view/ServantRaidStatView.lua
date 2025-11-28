autoImport("BagItemCell")
autoImport("ServantRaidStatIconCell")
autoImport("ServantRaidStatInfoCell")
autoImport("ServantRaidStatDropCardCell")
ServantRaidStatView = class("ServantRaidStatView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ServantRaidStatView")
local mapBgName = "calendar_statistics_bg1"
local ColorSet1 = {
  [3] = Color(0.9803921568627451, 0.7725490196078432, 0.7333333333333333, 1),
  [1] = Color(0.9176470588235294, 0.6784313725490196, 0.8196078431372549, 1),
  [2] = Color(0.7686274509803922, 0.7686274509803922, 0.9215686274509803, 1),
  [4] = Color(0.9568627450980393, 0.7372549019607844, 0.8509803921568627, 1)
}
local ColorSet2 = {
  [3] = Color(0.49019607843137253, 0.29411764705882354, 0.2549019607843137, 1),
  [1] = Color(0.4196078431372549, 0.27450980392156865, 0.33725490196078434, 1),
  [2] = Color(0.2784313725490196, 0.2784313725490196, 0.5607843137254902, 1),
  [4] = Color(0.2784313725490196, 0.2784313725490196, 0.5607843137254902, 1)
}
local ColorSet3 = {
  [3] = Color(0.9764705882352941, 0.8313725490196079, 0.8, 1),
  [1] = Color(0.9176470588235294, 0.6784313725490196, 0.8196078431372549, 1),
  [2] = Color(0.7607843137254902, 0.7607843137254902, 0.9176470588235294, 1),
  [4] = Color(0.7607843137254902, 0.7607843137254902, 0.9176470588235294, 1)
}
local ColorSet4 = {
  [3] = Color(0.9529411764705882, 0.8470588235294118, 0.8352941176470589, 1),
  [1] = Color(0.9215686274509803, 0.7686274509803922, 0.8627450980392157, 1),
  [2] = Color(0.8156862745098039, 0.803921568627451, 0.8980392156862745, 1),
  [4] = Color(0.8156862745098039, 0.8, 0.8941176470588236, 1)
}
local ColorBg = {
  [1] = "calendar_statistics_letter_bg1",
  [2] = "calendar_statistics_letter_bg2",
  [3] = "calendar_statistics_letter_bg3",
  [4] = "calendar_statistics_letter_bg4"
}

function ServantRaidStatView:LoadSubView()
  local container = self:FindGO("raidstatViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantRaidStatView"
end

function ServantRaidStatView:Init()
  self:LoadSubView()
  self:InitView()
  self:InitData()
end

function ServantRaidStatView:OnExit()
  self.letterPopup:SetActive(false)
  self.raidStat:SetActive(false)
  self.raidInfo:SetActive(false)
  PictureManager.Instance:UnLoadUI(mapBgName, self.mapBgTex)
  ServantRaidStatView.super.OnExit(self)
end

function ServantRaidStatView:OnDestroy()
  for i = 1, #ColorBg do
    PictureManager.Instance:UnLoadServantBG(ColorBg[i], self.lptex)
  end
end

function ServantRaidStatView:InitView()
  local ltTitle = self:FindComponent("ltTitle", UILabel)
  ltTitle.text = ZhString.Servant_RaidStat_ltTitle
  local lbText1 = self:FindComponent("lbText1", UILabel)
  lbText1.text = ZhString.Servant_RaidStat_lbText1
  local lbText2 = self:FindComponent("lbText2", UILabel)
  lbText2.text = ZhString.Servant_RaidStat_lbText2
  local raidText1 = self:FindComponent("raidText1", UILabel)
  raidText1.text = ZhString.Servant_RaidStat_raidText1
  local raidText2 = self:FindComponent("raidText2", UILabel)
  raidText2.text = ZhString.Servant_RaidStat_raidText2
  local raidText3 = self:FindComponent("raidText3", UILabel)
  raidText3.text = ZhString.Servant_RaidStat_raidText3
  local raidText4 = self:FindComponent("raidText4", UILabel)
  raidText4.text = ZhString.Servant_RaidStat_raidText4
  local raidText5 = self:FindComponent("raidText5", UILabel)
  raidText5.text = ZhString.Servant_RaidStat_raidText5
  self.letter = self:FindGO("Letter")
  self.letterPopup = self:FindGO("LetterPopup")
  self.lptex = self:FindComponent("Tex", UITexture, self.letterPopup)
  self.lpcontent = self:FindComponent("lettertext", UILabel, self.letterPopup)
  self.lpsp1 = self:FindComponent("lpsp1", UISprite, self.letterPopup)
  self.lpsp2 = self:FindComponent("lpsp2", UISprite, self.letterPopup)
  self.lpsp3 = self:FindComponent("DropInfo", UISprite, self.letterPopup)
  self.lpsp4 = self:FindComponent("title", UISprite, self.letterPopup)
  self.lptextsv = self:FindComponent("textScrollview", UIScrollView, self.letterPopup)
  self.lpcardsv = self:FindComponent("CardScrollview", UIScrollView, self.letterPopup)
  self.lpcardgrid = self:FindComponent("CardGrid", UIGrid, self.letterPopup)
  self.lpcardListCtl = UIGridListCtrl.new(self.lpcardgrid, ServantRaidStatDropCardCell, "ServantRaidStatDropCardCell")
  self.lpcardListCtl:AddEventListener(ServantRaidStatEvent.DropCardCellClick, self.ClickRaidDropCardHandler, self)
  self:AddClickEvent(self:FindGO("letterPopupClose"), function()
    self.letterPopup:SetActive(false)
  end)
  self:AddClickEvent(self.letter, function()
    self:ShowLetterPopup()
  end)
  self.raidStat = self:FindGO("RaidStatPanel")
  self.raidTitle = self:FindComponent("title", UILabel, self.raidStat)
  self.rscellsv = self:FindComponent("ServantScrollview", UIScrollView, self.raidStat)
  self.rscellgrid = self:FindComponent("ServantGrid", UIGrid, self.raidStat)
  self.rscellListCtl = UIGridListCtrl.new(self.rscellgrid, ServantRaidStatInfoCell, "ServantRaidStatInfoCell")
  self.rscellListCtl:AddEventListener(ServantRaidStatEvent.GetRewardClick, self.StatCellGetRewardHandler, self)
  self.rscellListCtl:AddEventListener(ServantRaidStatEvent.GoToBtnClick, self.StatCellGotoRaidHandler, self)
  self.rsdropsv = self:FindComponent("DropScrollview", UIScrollView, self.raidStat)
  local itemContainer = self:FindGO("bag_itemContainer")
  self.rsdropwrap = WrapListCtrl.new(itemContainer, BagItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 5, 98, true)
  self.rsdropwrap:AddEventListener(MouseEvent.MouseClick, self.ClickRaidDropItemHandler, self)
  self.rsdroptextsv = self:FindComponent("DropTextScrollview", UIScrollView, self.raidStat)
  self.droptext = self:FindComponent("droptext", UILabel, self.raidStat)
  self:AddClickEvent(self:FindGO("RaidStatPanelinfo"), function()
    self:ShowRaidInfoPanel()
  end)
  self:AddClickEvent(self:FindGO("RaidStatPanelClose"), function()
    self:HideRaidStatPanel()
  end)
  self.raidInfo = self:FindGO("RaidInfoPanel")
  self.ritextsv = self:FindComponent("textScrollview", UIScrollView, self.raidInfo)
  self.ricontent = self:FindComponent("text", UILabel, self.ritextsv.gameObject)
  self:AddClickEvent(self:FindGO("RaidInfoPanelClose"), function()
    self.raidInfo:SetActive(false)
  end)
  self:AddClickEvent(self:FindGO("RaidInfoPanelmskillBtn"), function()
  end)
  self:InitMap()
end

function ServantRaidStatView:InitMap()
  self.mapBgTex = self:FindComponent("MapBg", UITexture)
  PictureManager.Instance:SetUI(mapBgName, self.mapBgTex)
  self.mapCells = {}
  local raidCells = self:FindGO("RaidCells").transform
  local mapcell, mapcellgo, id, mapcelldata
  for i = 0, raidCells.childCount - 1 do
    mapcellgo = raidCells:GetChild(i).gameObject
    id = tonumber(mapcellgo.name)
    mapcelldata = ServantRaidStatProxy.Instance:GetMapData(id)
    if mapcelldata then
      mapcell = ServantRaidStatIconCell.new(mapcellgo)
      self.mapCells[id] = mapcell
      mapcell:SetData(mapcelldata)
      mapcell:AttachClickEvent(function(go)
        self:OnSelectRaidMapCell(tonumber(go.name))
      end)
    else
      mapcellgo:SetActive(false)
    end
  end
end

function ServantRaidStatView:InitData()
  if not ServantRaidStatProxy.Instance:IsNewMail() then
    self.letter:SetActive(false)
  else
    self.letter:SetActive(true)
  end
end

function ServantRaidStatView:UpdateMap()
  local mapdata = ServantRaidStatProxy.Instance:GetMapData()
  for k, v in pairs(self.mapCells) do
    if mapdata and mapdata[k] then
      v:SetData(mapdata[k])
    end
  end
end

function ServantRaidStatView:OnSelectRaidMapCell(id)
  self.curSelectRaidId = id
  self.curSelectRaidMapType = Table_DeaconStatistics and Table_DeaconStatistics[id] and Table_DeaconStatistics[id].PageType
  self:ShowRaidStatPanel()
end

function ServantRaidStatView:ShowRaidStatPanel()
  if self.curSelectRaidId and self.curSelectRaidMapType then
    if self.curSelectRaidMapType == FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or self.curSelectRaidMapType == FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID then
      self.curSelectRaidData = ServantRaidStatProxy.Instance:GetComodoRaidData(self.curSelectRaidMapType)
    else
      self.curSelectRaidData = ServantRaidStatProxy.Instance:GetRaidData(self.curSelectRaidMapType)
    end
    self.curSelectMapData = ServantRaidStatProxy.Instance:GetMapData(self.curSelectRaidId)
  end
  if not self.curSelectRaidData or not self.curSelectMapData then
    return
  end
  self.raidStat:SetActive(true)
  self.raidTitle.text = self.curSelectMapData.staticData.Area_Name
  self.rscellListCtl:ResetDatas(self.curSelectRaidData)
  self.rscellsv:ResetPosition()
  if #self.curSelectMapData.staticData.Falling > 0 and self.curSelectMapData.staticData.Falling[1] ~= 0 then
    self.rsdropsv.gameObject:SetActive(true)
    self.rsdroptextsv.gameObject:SetActive(false)
    self.rsdropwrap:ResetDatas(self:CreateDropItemData(), true)
  else
    self.rsdropsv.gameObject:SetActive(false)
    self.rsdroptextsv.gameObject:SetActive(true)
    self.droptext.text = self.curSelectMapData.staticData.Text
    self.rsdroptextsv:ResetPosition()
  end
  if self.raidInfo.activeSelf then
    self:ShowRaidInfoPanel()
  end
end

function ServantRaidStatView:CreateDropItemData()
  if not self.dropItemData then
    self.dropItemData = {}
  else
    TableUtility.ArrayClear(self.dropItemData)
  end
  local staticid
  for i = 1, #self.curSelectMapData.staticData.Falling do
    staticid = self.curSelectMapData.staticData.Falling[i]
    TableUtility.ArrayPushBack(self.dropItemData, ItemData.new("", staticid))
  end
  return self.dropItemData
end

function ServantRaidStatView:HideRaidStatPanel()
  self.raidStat:SetActive(false)
  self.raidInfo:SetActive(false)
  self.curSelectRaidData = nil
  self.curSelectMapData = nil
end

function ServantRaidStatView:ShowRaidInfoPanel()
  self.raidInfo:SetActive(true)
  self.ricontent.text = self.curSelectMapData.staticData.Desc
  self.ritextsv:ResetPosition()
end

function ServantRaidStatView:ShowLetterPopup()
  self.letter:SetActive(false)
  local mail = ServantRaidStatProxy.Instance:GetMail()
  if mail then
    local content, color = ServantRaidStatProxy.Instance:GenerateMailContent()
    self.letterPopup:SetActive(true)
    self.lpcontent.text = content
    self.lptextsv:ResetPosition()
    self.lpcardListCtl:ResetDatas(mail.cards)
    self.lpcardsv:ResetPosition()
    PictureManager.Instance:SetServantBG(ColorBg[color], self.lptex)
    ServantRaidStatProxy.Instance:SetMailReaded()
    self.lpsp3.gameObject:SetActive(#mail.cards > 0)
  end
end

function ServantRaidStatView:StatCellGotoRaidHandler(cellctl)
  local shortcutPowerId = cellctl.data and next(cellctl.data.staticData.GotoMode) and tonumber(cellctl.data.staticData.GotoMode[1])
  if shortcutPowerId then
    FuncShortCutFunc.Me():CallByID(shortcutPowerId)
  end
end

function ServantRaidStatView:StatCellGetRewardHandler(cellctl)
  if cellctl.data and cellctl.data.staticData.PageType == 28 then
    ServicePveCardProxy.Instance:CallGetPveCardRewardCmd()
  end
end

local tipData = {}
tipData.funcConfig = {}

function ServantRaidStatView:ClickRaidDropItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end

function ServantRaidStatView:ClickRaidDropCardHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = ItemData.new("", cellctl.data.staticData.id)
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end

function ServantRaidStatView:RecvServantStatisticsUserCmd(data)
  self:UpdateMap()
  if self.raidStat.activeSelf then
    self:ShowRaidStatPanel()
  end
end

function ServantRaidStatView:RecvServantStatisticsMailUserCmd(data)
  if not ServantRaidStatProxy.Instance:IsNewMail() then
    self.letter:SetActive(false)
  else
    self.letter:SetActive(true)
  end
end
