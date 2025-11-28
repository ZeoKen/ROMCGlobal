autoImport("HomeBPDetailCell")
HomeBPInfoPage = class("HomeBPInfoPage", SubView)
HomeBPInfoPage.texName_BPFrame = "home_blueprint_bg_b"

function HomeBPInfoPage:Init()
  self.detailDatas = {}
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeBPInfoPage:InitUI()
  self.gameObject = self:FindGO("BPInfo")
  self.texBP = self:FindComponent("texBP", UITexture)
  self.objBtnLike = self:FindGO("btnLike")
  self.objLikeIcon = self:FindGO("iconLike", self.objBtnLike)
  self.labLikeNum = self:FindComponent("labLikeNum", UILabel)
  self.labProgress = self:FindComponent("labProgress", UILabel)
  self.labBPName = self:FindComponent("labBPName", UILabel)
  self.listDetailInfos = UIGridListCtrl.new(self:FindComponent("detailTable", UITable), HomeBPDetailCell, "HomeBPDetailCell")
  self.objBPShow = self:FindGO("BPShow")
  self.texBPShow = self:FindComponent("texBPShow", UITexture, self.objBPShow)
end

function HomeBPInfoPage:AddEvts()
  self:AddClickEvent(self.texBP.gameObject, function(go)
    self.objBPShow:SetActive(true)
  end)
  self:AddClickEvent(self:FindGO("mask", self.objBPShow), function(go)
    self.objBPShow:SetActive(false)
  end)
  self:AddClickEvent(self.objBtnLike, function()
    if not self.curBPStaticID then
      redlog("ID为空！")
      return
    end
    if self.ltForbidLike then
      MsgManager.ShowMsgByID(49)
      return
    end
    local likeIDConfig = GameConfig.Home.BluePrintLikeID
    local realID = likeIDConfig and likeIDConfig[self.curBPStaticID] or self.curBPStaticID
    ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(self.isLike and HomeCmd_pb.EPRINTACTION_UNPRAISE or HomeCmd_pb.EPRINTACTION_PRAISE, realID)
    self.ltForbidLike = TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.ltForbidLike = nil
    end, self)
  end)
end

function HomeBPInfoPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.RefeshBPLikeInfo)
end

function HomeBPInfoPage:ClickHelp()
  local helpData = Table_Help[1]
  self:OpenHelpView(helpData)
end

function HomeBPInfoPage:SetData(bluePrintData)
  local bpStaticData = bluePrintData.staticData
  self.curBPStaticID = bpStaticData.id
  TableUtility.ArrayClear(self.detailDatas)
  local format = "[000000ff][ff6c1cff][%s][-]%s[-]"
  self.detailDatas[1] = string.format(format, ZhString.HomeBP_Score, "  " .. bpStaticData.TotalScore)
  self.detailDatas[2] = string.format(format, ZhString.HomeBP_Reward, "\n" .. OverSea.LangManager.Instance():GetLangByKey(bpStaticData.RewardTip))
  self.detailDatas[3] = string.format(format, ZhString.HomeBP_Desc, "\n" .. OverSea.LangManager.Instance():GetLangByKey(bpStaticData.Desc))
  self.listDetailInfos:ResetDatas(self.detailDatas)
  PictureManager.Instance:SetHomeBluePrint(bpStaticData.BPName, self.texBP)
  PictureManager.Instance:SetHomeBluePrint(bpStaticData.BPName, self.texBPShow)
  self.labBPName.text = bpStaticData.NameZh
  self.labProgress.text = string.format("%d/%d", bluePrintData.haveFurnitureNum, bluePrintData.totalFurnitureNum)
  self:RefeshBPLikeInfo()
end

function HomeBPInfoPage:RefeshBPLikeInfo()
  self.isLike = HomeProxy.Instance:IsILikeBluePrint(self.curBPStaticID)
  self.labLikeNum.text = HomeProxy.Instance:GetBluePrintLikeNum(self.curBPStaticID)
  self.objLikeIcon:SetActive(self.isLike == true)
end

function HomeBPInfoPage:OnEnter()
  HomeBPInfoPage.super.OnEnter(self)
  PictureManager.Instance:SetHome(HomeBPInfoPage.texName_BPFrame, self:FindComponent("texBPFrame", UITexture))
end

function HomeBPInfoPage:OnExit()
  PictureManager.Instance:UnLoadHome(HomeBPInfoPage.texName_BPFrame)
  if self.ltForbidLike then
    self.ltForbidLike:Destroy()
    self.ltForbidLike = nil
  end
  HomeBPInfoPage.super.OnExit(self)
end
