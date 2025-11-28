autoImport("DynamicSkillEffTableCell")
DynamicSkillEffView = class("DynamicSkillEffView", SubView)
DynamicSkillEffView.ViewType = UIViewType.NormalLayer
local SUB_VIEW_PATH = ResourcePathHelper.UIView("DynamicSkillEffView")

function DynamicSkillEffView:Init()
  self:AddEvts()
  self.pageInited = false
end

function DynamicSkillEffView:LoadSubView()
  self.objRoot = self:FindGO("DynamicSkillEffView")
  local obj = self:LoadPreferb_ByFullPath(SUB_VIEW_PATH, self.container.composeObj, true)
  obj.name = "DynamicSkillEffView"
end

function DynamicSkillEffView:FindObjs()
  self:ReLoadPerferb("view/DynamicSkillEffView", true)
  self.table = self:FindComponent("Table", UITable)
  self.noneTip = self:FindComponent("NoneTip", UILabel)
  self.noneTip.text = ZhString.Warband_DynamicEff_Empty
  local panel = self.container.gameObject:GetComponent(UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
end

function DynamicSkillEffView:InitView()
  if nil == self.tableCtl then
    self.tableCtl = UIGridListCtrl.new(self.table, DynamicSkillEffTableCell, "DynamicSkillEffTableCell")
    self.tableCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  end
end

function DynamicSkillEffView:UpdateView()
  if not self.pageInited then
    return
  end
  local data = WarbandProxy.Instance:GetEffectList()
  self.noneTip.gameObject:SetActive(#data == 0)
  self.tableCtl:ResetDatas(data)
  self.table:Reposition()
end

function DynamicSkillEffView:Switch(show)
  if show then
    if not self.pageInited then
      self:FindObjs()
      self:InitView()
      self.pageInited = true
    end
    self.gameObject:SetActive(true)
    self:UpdateView()
  elseif self.pageInited then
    self.gameObject:SetActive(false)
  end
end

function DynamicSkillEffView:AddEvts()
  self:AddListenEvt(ServiceEvent.SkillSyncSkillEffectSkillCmd, self.UpdateView)
end

function DynamicSkillEffView:OnClickVideoBtn()
  local proeffects = {
    {
      eprofession = self.curChooseCtl.pro,
      seffect = {
        {
          id = self.curChooseCtl.itemId,
          effect = self.curChooseCtl.sendStatus
        }
      }
    }
  }
  redlog("CallSyncSkillEffectSkillCmd    ", self.curChooseCtl.pro, self.curChooseCtl.itemId, self.curChooseCtl.sendStatus)
  ServiceSkillProxy.Instance:CallSyncSkillEffectSkillCmd(proeffects)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.Lv4PopUpLayer)
end

function DynamicSkillEffView:OnClickItem(cellctl)
  local itemId = cellctl and cellctl.itemId
  self.curItemId = itemId
  self.curChooseCtl = cellctl
  self:OpenVideoPreview()
end

function DynamicSkillEffView:OpenVideoPreview()
  local url = self.curItemId and GameConfig.TwelvePvpVideo and GameConfig.TwelvePvpVideo[self.curItemId]
  if not url then
    redlog("杯赛奖励预览视频未配置 ID ： ", self.curItemId)
  end
  local btnText = self.curChooseCtl.effectStatus == 0 and ZhString.Warband_DynamicEff_Use or ZhString.Warband_DynamicEff_UnUse
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.VideoPreview,
    viewdata = {
      url = url,
      btnText = btnText,
      btnFunc = function(uiLabel)
        self:OnClickVideoBtn()
      end
    }
  })
end

function DynamicSkillEffView:SetChoose(id)
  local cell = self.tableCtl:GetCells()
  if nil == cell then
    return
  end
  for _, cells in pairs(cell) do
    for k, cell in pairs(cells:GetCells()) do
      cell:SetChoose(id)
    end
  end
end
