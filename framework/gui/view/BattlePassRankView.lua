autoImport("BattlePassRankCell")
autoImport("WrapCellHelper")
BattlePassRankView = class("BattlePassRankView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("BattlePassRankView")
local COLOR_GRAY = ColorUtil.TitleGray
local COLOR_BLUE = ColorUtil.TitleBlue
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}

function BattlePassRankView:LoadSubView()
  local container = self:FindGO("rankViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "BattlePassRankView"
  self.gameObject = obj
end

function BattlePassRankView:Init()
  self:LoadSubView()
  self:InitView()
  self:InitData()
end

function BattlePassRankView:InitView()
  self:FindComponent("text1", UILabel).text = ZhString.BattlePassRankView_text1
  self:FindComponent("text2", UILabel).text = ZhString.BattlePassRankView_text2
  self:FindComponent("text3", UILabel).text = ZhString.BattlePassRankView_text3
  self:FindComponent("norank", UILabel).text = ZhString.BattlePassRankView_norankdata
  self.norank = self:FindGO("norank")
  self.loading = self:FindGO("Loading")
  local go = self:LoadCellPfb("BattlePassRankCell", self:FindGO("selfRankHolder"))
  self.selfRankCell = BattlePassRankCell.new(go)
  self.rcellsv = self:FindComponent("RankScrollview", UIScrollView)
  local wrapCfg = {
    wrapObj = self:FindGO("RankGrid"),
    pfbNum = 6,
    cellName = "BattlePassRankCell",
    control = BattlePassRankCell,
    dir = 1,
    disableDragIfFit = false
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.itemWrapHelper:AddEventListener(BattlePassEvent.RankViewSelectHead, self.HandleClickHead, self)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickRankCell, self)
  self.allrankTog = self:FindComponent("allrank", UIToggle)
  self:FindComponent("allrank", UILabel).text = ZhString.BattlePassRankView_allrank
  self.friendrankTog = self:FindComponent("friendrank", UIToggle)
  self:FindComponent("friendrank", UILabel).text = ZhString.BattlePassRankView_friendrank
  self:AddToggleChange(self.allrankTog, self.OnToggleChange, true)
  self:AddToggleChange(self.friendrankTog, self.OnToggleChange, false)
end

function BattlePassRankView:InitData()
  self.playerTipOffset = {-70, 14}
  self.playerTipInitData = {}
end

function BattlePassRankView:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function BattlePassRankView:AddToggleChange(toggle, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    local label = toggle.gameObject:GetComponent(UILabel)
    if toggle.value then
      label.color = COLOR_BLUE
      if handler ~= nil then
        handler(self, param)
      end
    else
      label.color = COLOR_GRAY
    end
  end)
end

function BattlePassRankView:OnToggleChange(isallrank)
  if self.isallrank ~= isallrank then
    self.isallrank = isallrank
    self:UpdateRank()
  end
end

function BattlePassRankView:OnEnter()
  BattlePassRankView.super.OnEnter(self)
  self.itemWrapHelper:ResetPosition()
  self:UpdateRank()
end

function BattlePassRankView:UpdateRank()
  if self.isallrank then
    self:UpdateByAllRank()
  else
    self:UpdateByFriendRank()
  end
end

function BattlePassRankView:UpdateByAllRank()
  if not self.isallrank then
    return
  end
  self.selfrank = nil
  local isQueryAllRankData = BattlePassProxy.Instance:IsAllBattlePassRankValid() or false
  self.loading:SetActive(not isQueryAllRankData)
  self.rcellsv.gameObject:SetActive(isQueryAllRankData)
  if isQueryAllRankData then
    local data = BattlePassProxy.Instance.allrankinfo
    self.itemWrapHelper:ResetDatas(data)
    self.rcellsv:ResetPosition()
    self.selfRankCell:SetData(BattlePassRankShowData.new(1, nil, BattlePassProxy.Instance.rankinAll))
    if data and next(data) then
      EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
        type = "char",
        data = {
          showData = data[1]
        }
      })
      self.norank:SetActive(false)
    else
      EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
        type = "char",
        data = {
          showData = self.selfRankCell.data
        }
      })
      self.norank:SetActive(true)
    end
  else
    ServiceMatchCCmdProxy.Instance:CallQueryBattlePassRankMatchCCmd()
  end
end

function BattlePassRankView:UpdateByFriendRank()
  if self.isallrank then
    return
  end
  self.selfrank = nil
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData() or false
  self.loading:SetActive(not isQuerySocialData)
  self.rcellsv.gameObject:SetActive(isQuerySocialData)
  if isQuerySocialData then
    local data = BattlePassProxy.Instance:GenerateFriendRankData()
    self.itemWrapHelper:ResetDatas(data)
    self.rcellsv:ResetPosition()
    self.selfRankCell:SetData(BattlePassRankShowData.new(1, nil, BattlePassProxy.Instance.rankinFriend))
    if data and next(data) then
      EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
        type = "char",
        data = {
          showData = data[1]
        }
      })
      self.norank:SetActive(false)
    else
      EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
        type = "char",
        data = {
          showData = self.selfRankCell.data
        }
      })
      self.norank:SetActive(true)
    end
  else
    ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
  end
end

function BattlePassRankView:HandleClickHead(cellCtl)
  local cellData = cellCtl.data
  if cellCtl == self.curCell or cellData.charID == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, self.playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByBattlePassRankShowData(cellData)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(cellData.charID) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:OnExit()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function BattlePassRankView:HandleClickRankCell(cellCtl)
  EventManager.Me():DispatchEvent(BattlePassEvent.UpdateExhibition, {
    type = "char",
    data = {
      showData = cellCtl.data
    }
  })
end
