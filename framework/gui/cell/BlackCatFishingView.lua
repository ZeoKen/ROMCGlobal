BlackCatFishingView = class("BlackCatFishingView", ContainerView)
BlackCatFishingView.ViewType = UIViewType.NormalLayer
autoImport("BlackCatFishingCell")
local _buffLength = 3
local _tempVector3 = LuaVector3.Zero()
local _fishingConfig = GameConfig.BlackCatFishing
local _btnState = {
  [1] = {
    "new-com_btn_a_gray",
    "646876"
  },
  [2] = {
    "new-com_btn_a",
    "455FAE"
  }
}

function BlackCatFishingView:Init()
  self.selected = false
  self:FindObjs()
  self:AddEvents()
  self:InitView()
end

function BlackCatFishingView:FindObjs()
  self.confirmButton = self:FindGO("ConfirmButton")
  self.confirmBtnSP = self:FindComponent("Background", UISprite, self.confirmButton)
  self.confirmBtnLab = self:FindComponent("Label", UILabel, self.confirmButton)
  self.confirmBtnSP.spriteName = _btnState[1][1]
  local _, c = ColorUtil.TryParseHexString(_btnState[1][2])
  self.confirmBtnLab.effectColor = c
  self.descRoot = self:FindGO("DescRoot")
  self.descRoot:SetActive(true)
  self.confirmButton:SetActive(true)
  self.descTitleLab = self:FindComponent("TitleLab", UILabel, self.descRoot)
  self.descTitleLab.alpha = 0
  self.contentLab = self:FindComponent("ContentLab", UILabel, self.descRoot)
  self.descTitleLab.text = ""
  self.contentLab.text = ""
  self.contentLab.alpha = 0
end

function BlackCatFishingView:AddEvents()
  self:AddClickEvent(self.confirmButton, function(go)
    if self.selected then
      ServiceQuestProxy.Instance:CallRunQuestStep(self.data.id, self.selectedBuff.id)
      self:CloseSelf()
    else
      self:OnConfirm()
    end
  end)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function BlackCatFishingView:InitView()
  self.selectedBuff = nil
  self.buffCellCtl = {}
  self.cartRoot = self:FindGO("CardRoot")
  self.cartRoot:SetActive(true)
  local buffcellObj
  for i = 1, _buffLength do
    buffcellObj = self:FindGO("Buff" .. tostring(i), self.cardRoot)
    self.buffCellCtl[i] = BlackCatFishingCell.new(buffcellObj)
  end
  for i = 1, _buffLength do
    self:AddClickEvent(self.buffCellCtl[i].bgTex.gameObject, function()
      if not self.selected then
        self:OnChooseBuff(i)
      end
    end)
  end
end

function BlackCatFishingView:OnChooseBuff(index)
  self.selectedBuff = self.buffCellCtl[index]
  self:ChooseBuffCell(self.selectedBuff.id)
  self.confirmButton:SetActive(true)
  self.confirmBtnSP.spriteName = _btnState[2][1]
  local _, c = ColorUtil.TryParseHexString(_btnState[2][2])
  self.confirmBtnLab.effectColor = c
end

function BlackCatFishingView:ChooseBuffCell(id)
  for i = 1, _buffLength do
    self.buffCellCtl[i]:OnChoosed(id)
  end
end

function BlackCatFishingView:ClearTick()
  if not self.delayTick then
    return
  end
  self.delayTick:Destroy()
  self.delayTick = nil
end

function BlackCatFishingView:OnConfirm()
  if not self.selectedBuff then
    return
  end
  if not self.data then
    return
  end
  self.selected = true
  self:HideOther()
  self:ShowDescInfo()
end

function BlackCatFishingView:HideOther()
  for i = 1, _buffLength do
    if self.buffCellCtl[i].id ~= self.selectedBuff.id then
      self.buffCellCtl[i].gameObject:SetActive(false)
    end
  end
end

function BlackCatFishingView:ShowDescInfo()
  self.descRoot:SetActive(true)
  if not _fishingConfig then
    redlog("GameConfig.BlackCatFishing 配置未找到")
    return
  end
  if not self.selectedBuff.index then
    return
  end
  local classifiedConfig = _fishingConfig[self.selectedBuff.index]
  if not classifiedConfig then
    redlog("检查GameConfig.BlackCatFishing 配置.index : ", self.selectedBuff.index)
    return
  end
  local r = math.random(1, #classifiedConfig)
  self.descTitleLab.text = classifiedConfig[r].title or ""
  self.contentLab.text = classifiedConfig[r].desc or ""
  if self.selectedBuff:AllowTransformAnimation() then
    TweenPosition.Begin(self.selectedBuff.gameObject, 0.5, _tempVector3, false)
  end
  TweenAlpha.Begin(self.descTitleLab.gameObject, 0.5, 1)
  TweenAlpha.Begin(self.contentLab.gameObject, 0.5, 1)
end

function BlackCatFishingView:OnExit()
  BlackCatFishingView.super.OnExit(self)
  self:ClearTick()
end

function BlackCatFishingView:OnEnter()
  self.data = self.viewdata.viewdata.questData
  if self.data then
    local params = self.data.params
    local serverBuffs = {
      params.buffid1,
      params.buffid2,
      params.buffid3
    }
    for i = 1, _buffLength do
      self.buffCellCtl[i]:SetData(serverBuffs[i], i)
    end
  end
  BlackCatFishingView.super.OnEnter(self)
end
