autoImport("DisneyResultCell")
DisneyResultView = class("DisneyResultView", ContainerView)
DisneyResultView.ViewType = UIViewType.NormalLayer
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}

function DisneyResultView:Init()
  self:FindObjs()
  self:InitData()
  self:AddViewEvts()
  self:AddEvts()
  self:InitView()
end

function DisneyResultView:LoadCellPfb(cName, holderObj)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(holderObj.transform, false)
  return cellpfb
end

function DisneyResultView:FindObjs()
  self.eff_go_win = self:FindGO("TopEffWin")
  self.eff_go_lose = self:FindGO("TopEffLose")
  self.resultGrid = self:FindGO("ResultGrid"):GetComponent(UIGrid)
  self.resultGridCtrl = UIGridListCtrl.new(self.resultGrid, DisneyResultCell, "DisneyResultCell")
  self.exitBtn = self:FindGO("ExitBtn")
  self.retryBtn = self:FindGO("RetryButton")
  self.exitCountDownLabel = self:FindComponent("Lab", UILabel, self.exitBtn)
  self:AddClickEvent(self.exitBtn, function(go)
  end)
  self:AddClickEvent(self.retryBtn, function(go)
  end)
end

function DisneyResultView:InitView()
  if self.resultWin then
  else
  end
end

function DisneyResultView:AddViewEvts()
end

function DisneyResultView:AddEvts()
end

function DisneyResultView:InitData()
  self.resultWin = self.viewdata.viewdata.is_win
  self.rivalsInfo = self.viewdata.viewdata.rival_info
end

function DisneyResultView:UpdateTipInfo(togId)
  if togId == 1 then
    self.tipTog.value = true
    self.tipinfoPanel:SetActive(true)
    self.listInfoPanel:SetActive(false)
  elseif togId == 2 then
    self.listTog.value = true
    self.tipinfoPanel:SetActive(false)
    self.listInfoPanel:SetActive(true)
  end
end

function DisneyResultView:UpdateRank()
  local data = DisneyProxy.Instance.allRankInfo
  self.itemWrapHelper:ResetDatas(data)
  self.itemWrapHelper:ResetPosition()
end

function DisneyResultView:UpdateIndicator()
end

function DisneyResultView:HandleClickHead(cellCtl)
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

function DisneyResultView:HandleClickRankCell(cellCtl)
  if cellCtl.data then
    local showData = cellCtl.data
    self:ShowPlayerModel(showData)
    self.playerName.text = showData.name
    self.playerGuildName.text = showData.guildname
  end
end

function DisneyResultView:ShowPlayerModel(rankShowData)
  if rankShowData then
    local parts = Asset_Role.CreatePartArray()
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    parts[partIndex.Body] = rankShowData.bodyID or 0
    parts[partIndex.Hair] = rankShowData.hairID or 0
    parts[partIndex.LeftWeapon] = rankShowData.lefthand or 0
    parts[partIndex.RightWeapon] = rankShowData.righthand or 0
    parts[partIndex.Head] = rankShowData.headID or 0
    parts[partIndex.Wing] = rankShowData.back or 0
    parts[partIndex.Face] = rankShowData.faceID or 0
    parts[partIndex.Tail] = rankShowData.tail or 0
    parts[partIndex.Eye] = rankShowData.eyeID or 0
    parts[partIndex.Mount] = rankShowData.mount or 0
    parts[partIndex.Mouth] = rankShowData.mouthID or 0
    parts[partIndexEx.Gender] = rankShowData.gender or 0
    parts[partIndexEx.HairColorIndex] = rankShowData.haircolor or 0
    parts[partIndexEx.EyeColorIndex] = rankShowData.eyecolor or 0
    parts[partIndexEx.BodyColorIndex] = rankShowData.clothcolor or 0
    UIModelUtil.Instance:ChangeBGMeshRenderer("Disney_bg_Roles", self.charModelTex)
    UIModelUtil.Instance:SetRoleModelTexture(self.charModelTex, parts, UIModelCameraTrans.BattlePassRank)
    Asset_Role.DestroyPartArray(parts)
  end
end

function DisneyResultView:OnEnter()
  DisneyResultView.super.OnEnter(self)
end

function DisneyResultView:OnExit()
  DisneyResultView.super.OnExit(self)
end
