autoImport("ServantRecommendCell")
NoviceTarget2023Cell = class("NoviceTarget2023Cell", ServantRecommendCell)

function NoviceTarget2023Cell:FindObjs()
  NoviceTarget2023Cell.super.FindObjs(self)
  self.bgDecorate = self:FindGO("BGDecorate"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("calendar_bg04", self.bgDecorate)
  self.titleBg = self:FindGO("TitleBg"):GetComponent(UISprite)
end

function NoviceTarget2023Cell:OnClickBtn()
  redlog("NoviceTarget2023Cell:OnClickBtn")
  NoviceTarget2023Cell.super.OnClickBtn(self)
end

function NoviceTarget2023Cell:SetData(data)
  self.data = data
  NoviceTarget2023Cell.super.SetData_project(self, data)
  self:UpdateRegisterGuideTarget()
  self.titleBg.width = 662
  self.rewardScrollView:ResetPosition()
  self.refreshEffectContainer_project:SetActive(false)
end

function NoviceTarget2023Cell:_getProjectProxy()
  return NoviceTarget2023Proxy.Instance
end

local defaultX = 479.1

function NoviceTarget2023Cell:_defaultX()
  return defaultX
end

function NoviceTarget2023Cell:_PlayReceiveEffect()
  self.refreshEffectContainer_project:SetActive(true)
  self:PlayUIEffect(EffectMap.UI.ufx_deacon_refresh_prf, self.refreshEffectContainer_project, true, function(go, args, assetEffect)
    go.transform.localPosition = Vector3(0, 0, 0)
    go.transform.localScale = Vector3.one
  end)
end

local GuideTargetMap = {
  [700] = ClientGuide.TargetType.novicetarget2023view_getbutton1
}

function NoviceTarget2023Cell:UpdateRegisterGuideTarget()
  local guideType = GuideTargetMap[self.data and self.data.id]
  if guideType then
    self:RegisterGuideTarget(guideType, self.btn.gameObject)
  else
    self:UnRegisterAllGuideTarget()
  end
end

function NoviceTarget2023Cell:OnCellDestroy()
  NoviceTarget2023Cell.super.OnCellDestroy(self)
  PictureManager.Instance:UnLoadUI("calendar_bg04", self.bgDecorate)
  self:UnRegisterAllGuideTarget()
end
