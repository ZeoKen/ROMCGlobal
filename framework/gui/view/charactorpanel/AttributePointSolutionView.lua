AttributePointSolutionView = class("AttributePointSolutionView", SubView)
autoImport("AttributePointSolutionCell")
AttributePointSolutionView.SelectCell = "AttributePointSolutionCell_Select"
AttributePointSolutionView.config = {
  {
    textOutlineColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1),
    descColor = Color(0.19215686274509805, 0.5411764705882353, 0.043137254901960784, 1),
    textBg = "persona_bg_1",
    descBg = "persona_bg_1c",
    bg = "persona_bg_1b"
  },
  {
    textOutlineColor = Color(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1),
    descColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1),
    textBg = "persona_bg_2",
    descBg = "persona_bg_2c",
    bg = "persona_bg_2b"
  },
  {
    textOutlineColor = Color(0.4549019607843137, 0.01568627450980392, 0.01568627450980392, 1),
    descColor = Color(0.6470588235294118, 0.1607843137254902, 0.15294117647058825, 1),
    textBg = "persona_bg_3",
    descBg = "persona_bg_3c",
    bg = "persona_bg_3b"
  }
}

function AttributePointSolutionView:Init()
  self:initView()
  self:addViewEventListener()
  self:resetprofession()
  self:AddListenEvts()
end

function AttributePointSolutionView:initView()
  self.gameObject = self:FindChild("AttributePointSolutionView")
  local grid = self:FindChild("Grid"):GetComponent(UIGrid)
  self.gridList = UIGridListCtrl.new(grid, AttributePointSolutionCell, "AttributePointSolutionCell")
  local titleLabel = self:FindGO("titleLabel"):GetComponent(UILabel)
  titleLabel.text = ZhString.Charactor_TitleLabel
  local tipsLabel = self:FindGO("tipsLabel"):GetComponent(UILabel)
  tipsLabel.text = ZhString.Charactor_ProfessionTipText
  local myClass = MyselfProxy.Instance:GetMyProfession()
  local config = Table_Class[myClass]
  if config ~= nil and config.FeatureSkill ~= nil then
    local gotoSkillRoot = self:FindGO("GotoSkillRoot", self.gotoRoot)
    gotoSkillRoot:SetActive(false)
  else
    local skilltip = self:FindGO("skillTipLabel"):GetComponent(UILabel)
    skilltip.text = ZhString.SkillRecommendLabel
    local skillBtn = self:FindGO("GoTo")
    self:AddClickEvent(skillBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = FunctionUnLockFunc.Me():GetPanelConfigById(4)
      })
      local mySolution = ProfessionProxy.Instance:GetSkillPointSolution(myClass)
      if mySolution and 0 < #mySolution then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.SkillRecommendPopUp
        })
      end
    end)
  end
  if GameConfig.SystemForbid.OpenServantEquipRecommend or FunctionUnLockFunc.CheckForbiddenByFuncState("servant_improve_forbidden") then
    local equipRecommend = self:FindGO("EquipRecommend")
    equipRecommend:SetActive(false)
  else
    local goToEquip = self:FindGO("GoToEquip")
    self:AddClickEvent(goToEquip, function()
      if MyselfProxy.Instance:GetMyServantID() == 0 then
        MsgManager.ShowMsgByID(43162)
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ServantNewMainView,
        viewdata = {tab = 3}
      })
    end)
  end
end

function AttributePointSolutionView:resetprofession()
  local nowOcc = Game.Myself.data:GetCurOcc()
  if nowOcc ~= nil then
    local prodata = Table_Class[nowOcc.profession]
    if prodata and prodata.AddPointSolution then
    else
      helplog("这个id table_class表中没有 请策划检查！！！！" .. nowOcc.profession)
      return
    end
    local datas = prodata.AddPointSolution
    self.gridList:ResetDatas(datas)
  end
end

function AttributePointSolutionView:AddListenEvts()
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.resetprofession)
end

function AttributePointSolutionView:addViewEventListener()
  self.gridList:AddEventListener(MouseEvent.MouseClick, self.ClickHandler, self)
end

function AttributePointSolutionView:ClickHandler(obj)
  local cells = self.gridList:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelected(cells[i] == obj)
  end
  self:PassEvent(AttributePointSolutionView.SelectCell, obj.data)
end
