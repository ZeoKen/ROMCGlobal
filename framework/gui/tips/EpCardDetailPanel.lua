EpCardDetailPanel = class("EpCardDetailPanel", ContainerView)
EpCardDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("BeautifulAreaPhotoHandler")

function EpCardDetailPanel:Init()
  self:initView()
  self:initData()
end

function EpCardDetailPanel:initData()
  self.data = self.viewdata.monthCardData
  if GameConfig.EpCardTexture and GameConfig.EpCardTexture[self.data.staticId] then
    self.epLabel.text = self.data:GetName()
    PictureManager.Instance:SetEPCardUI(GameConfig.EpCardTexture[self.data.staticId], self.ModelTexture)
  end
end

function EpCardDetailPanel:initView()
  self.ModelTexture = self:FindComponent("photo", UITexture)
  self.epLabel = self:FindComponent("epLabel", UILabel)
end

function EpCardDetailPanel:OnExit()
  if self.data and GameConfig.EpCardTexture and GameConfig.EpCardTexture[self.data.staticId] then
    PictureManager.Instance:UnLoadEPCard(GameConfig.EpCardTexture[self.data.staticId], self.ModelTexture)
  end
end
