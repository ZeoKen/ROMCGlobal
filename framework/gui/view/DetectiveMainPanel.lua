autoImport("DetectiveEvidencePage")
autoImport("DetectiveFilePage")
autoImport("DetectiveSkillPage")
DetectiveMainPanel = class("DetectiveMainPanel", ContainerView)
DetectiveMainPanel.ViewType = UIViewType.NormalLayer
local bgTexturePath = "Sevenroyalfamilies_bg"
local decorateTextureNameMap = {
  Decorate7 = "Sevenroyalfamilies_bg_decoration7",
  Decorate8 = "Sevenroyalfamilies_bg_decoration8"
}
local pageName = {
  [1] = ZhString.DetectiveMainPanel_Evidence,
  [2] = ZhString.DetectiveMainPanel_File,
  [3] = ZhString.DetectiveMainPanel_Skills
}
local uiFocusPosVec
local picIns = PictureManager.Instance

function DetectiveMainPanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
  self:RegisterGuide()
end

function DetectiveMainPanel:FindObjs()
  self.closeBtn = self:FindGO("CloseButton")
  self.pageTogGrid = self:FindGO("pageTogGrid", self.gameObject)
  self.dotLine = self:FindGO("DotLine"):GetComponent(UISprite)
  self.dotLine.height = 510
  self.bgTexture = self:FindGO("bgTexture"):GetComponent(UITexture)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.evidencePageObj = self:FindGO("EvidencePage")
  self.filePageObj = self:FindGO("FilePage")
  self.skillPageObj = self:FindGO("SkillPage")
  self.evidencePageTog = self:FindGO("evidencePageTog")
  self.filePageTog = self:FindGO("filePageTog")
  self.skillPageTog = self:FindGO("skillPageTog")
  self.evidencePage = self:AddSubView("DetectiveEvidencePage", DetectiveEvidencePage)
  self:AddTabChangeEvent(self.evidencePageTog, self.evidencePageObj, PanelConfig.DetectiveEvidencePage)
  self:AddTabChangeEvent(self.filePageTog, self.filePageObj, PanelConfig.DetectiveFilePage)
  self:AddTabChangeEvent(self.skillPageTog, self.skillPageObj, PanelConfig.DetectiveSkillPage)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SECRET_ENLIGHT, self.filePageTog, 10, {-27, -19})
  self.loading = self:FindGO("Loading")
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
  self.helperContainer = self:FindGO("HelperContainer")
  self.dragModelCell = self:FindGO("DragModelCell")
end

function DetectiveMainPanel:TabChangeHandler(key)
  xdlog("TabChangeHandler", key)
  if not DetectiveMainPanel.super.TabChangeHandler(self, key) then
    redlog("return")
    return
  end
  if key == PanelConfig.DetectiveFilePage.tab then
    xdlog("FilePage")
    if not self.filePage then
      self.filePage = self:AddSubView("DetectiveFilePage", DetectiveFilePage)
    end
  elseif key == PanelConfig.DetectiveSkillPage.tab then
    xdlog("SkillPage")
    if not self.skillPage then
      self.skillPage = self:AddSubView("DetectiveSkillPage", DetectiveSkillPage)
    end
  elseif key == PanelConfig.DetectiveEvidencePage.tab then
    self.evidencePage:RefreshModel()
  end
end

function DetectiveMainPanel:AddEvts()
end

function DetectiveMainPanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SkillSkillPerceptAbilityNtf)
  self:AddListenEvt(ServiceEvent.SkillSkillPerceptAbilityLvUpCmd)
  self:AddListenEvt(ServiceEvent.QuestQueryCharacterInfoCmd, self.closeLoading)
  self:AddListenEvt(ServiceEvent.QuestEnlightSecretCmd)
  self:AddListenEvt(ServiceEvent.QuestEvidenceHintCmd)
  self:AddListenEvt(MyselfEvent.MyDataChange)
end

function DetectiveMainPanel:InitDatas()
  local viewdata = self.viewdata.viewdata
  self.defaultPage = viewdata and viewdata.ui
end

function DetectiveMainPanel:InitShow()
  if self.defaultPage then
    self:TabChangeHandler(self.defaultPage)
  else
    self:TabChangeHandler(PanelConfig.DetectiveEvidencePage.tab)
  end
  self.loading:SetActive(not SevenRoyalFamiliesProxy.Instance:IsDataInited())
end

function DetectiveMainPanel:closeLoading()
  self.loading:SetActive(false)
end

function DetectiveMainPanel:ClickPageTog(cellCtrl)
end

function DetectiveMainPanel:RegisterGuide()
  self:AddOrRemoveGuideId(self.filePageTog, 203)
  self:AddOrRemoveGuideId(self.closeBtn, 204)
end

function DetectiveMainPanel:OnEnter()
  DetectiveMainPanel.super.OnEnter(self)
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  ServiceQuestProxy.Instance:CallEvidenceQueryCmd()
  ServiceQuestProxy.Instance:CallQueryCharacterInfoCmd()
  ServiceSkillProxy.Instance:CallSkillPerceptAbilityNtf()
end

function DetectiveMainPanel:OnExit()
  DetectiveMainPanel.super.OnExit(self)
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
end
