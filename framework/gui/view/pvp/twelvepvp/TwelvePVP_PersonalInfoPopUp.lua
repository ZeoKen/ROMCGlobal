autoImport("TwelvePVPDetailCell")
TwelvePVP_PersonalInfoPopUp = class("TwelvePVP_PersonalInfoPopUp", BaseView)
TwelvePVP_PersonalInfoPopUp.ViewType = UIViewType.PopUpLayer
local WinEffectMap = {
  [1] = "pvp_bg_win_red",
  [2] = "pvp_bg_win_blue"
}
local WinBG = "pvp_bg_win"
local CampConfig = GameConfig.TwelvePvp.CampConfig
local isFinal, camp
local IsFinalResult = function()
  local _proxy = TwelvePvPProxy.Instance
  return _proxy:CheckFinalResult()
end

function TwelvePVP_PersonalInfoPopUp:Init()
  self:FindObjects()
  self:AddListEventListener()
end

function TwelvePVP_PersonalInfoPopUp:OnEnter()
  TipManager.Instance:CloseItemTip()
  self:UpdateUI()
end

function TwelvePVP_PersonalInfoPopUp:UpdateUI()
  local dataList = TwelvePvPProxy.Instance:GetUserList()
  self.infoGridCtrl:ResetDatas(dataList)
  local isFinal, winCamp = IsFinalResult()
  if self.isFinal ~= isFinal then
    self.isFinal = isFinal
    self.winCamp = winCamp
    self:UpdateBtn()
  end
end

function TwelvePVP_PersonalInfoPopUp:OnExit()
  if self.isFinal then
    PictureManager.Instance:UnLoadPVP(WinBG, self.bgTexture)
    PictureManager.Instance:UnLoadPVP(WinEffectMap[self.winCamp], self.bannerTexture)
  end
end

function TwelvePVP_PersonalInfoPopUp:FindObjects()
  self.infoScrollView = self:FindGO("InfoScrollView"):GetComponent(UIScrollView)
  self.infoGrid = self:FindGO("InfoGrid"):GetComponent(UIGrid)
  self.infoGridCtrl = UIGridListCtrl.new(self.infoGrid, TwelvePVPDetailCell, "TwelvePVPDetailCell")
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.title.text = ZhString.TwelvePVPInfoTip_Title
  self.effectWinGO = self:FindGO("WinEffect")
  self.bgTexture = self:FindGO("bgTexture", self.effectWinGO):GetComponent(UITexture)
  self.bannerTexture = self:FindGO("bannerTexture", self.effectWinGO):GetComponent(UITexture)
  self.shadow = self:FindGO("shadow"):GetComponent(UILabel)
  self.winText = self:FindGO("winText"):GetComponent(UILabel)
  self:AddButtonEvent("CloseButton", function(go)
    if self.isFinal then
      ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    end
    self:CloseSelf()
  end)
  self.exitBtn = self:FindGO("ExitButton")
  self:AddClickEvent(self.exitBtn, function(go)
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
end

function TwelvePVP_PersonalInfoPopUp:AddListEventListener()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpQueryGroupInfoCmd, self.UpdateUI)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpResultCmd, self.UpdateUI)
end

function TwelvePVP_PersonalInfoPopUp:UpdateBtn()
  isFinal, camp = self.isFinal, self.winCamp
  self.title.gameObject:SetActive(not isFinal)
  self.exitBtn:SetActive(isFinal)
  self.effectWinGO:SetActive(isFinal)
  if isFinal then
    PictureManager.Instance:SetPVP(WinBG, self.bgTexture)
    PictureManager.Instance:SetPVP(WinEffectMap[camp], self.bannerTexture)
    local str = string.format(ZhString.TwelvePVP_VictoryTip, CampConfig[camp].name)
    self.shadow.text = str
    self.winText.text = str
  else
    self.shadow.text = ""
    self.winText.text = ""
  end
end
