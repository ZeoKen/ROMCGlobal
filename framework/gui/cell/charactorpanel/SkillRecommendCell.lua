local baseCell = autoImport("BaseCell")
autoImport("ProfessionSkillCell")
SkillRecommendCell = class("SkillRecommendCell", baseCell)
local BgTextureName = "returnactivity_bg_boli_02"
local TextureName = "skill_bg_001"
local TeamRole = GameConfig.TeamRole
local ExtraSkillID = GameConfig.ExtraSkill.skillid

function SkillRecommendCell:Init()
  self.bgTexture = self:FindGO("bgTexture"):GetComponent(UITexture)
  self.texture = self:FindGO("Texture"):GetComponent(UITexture)
  self.icon = self:FindGO("icon"):GetComponent(UIMultiSprite)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.basePoint = self:FindGO("bannerTitle"):GetComponent(UILabel)
  local gotoBtn = self:FindGO("GoTo")
  self:AddClickEvent(gotoBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Charactor,
      viewdata = {tab = 1}
    })
    GameFacade.Instance:sendNotification(SkillRecommendEvent.CloseRecommendView)
  end)
  if GameConfig.SystemForbid.OpenServantEquipRecommend or ServantRecommendProxy.Instance:CheckForbiddenByNoviceServer() then
    local equipRecommend = self:FindGO("EquipRecommend")
    equipRecommend:SetActive(false)
  else
    local goToEquip = self:FindGO("GoToEquip")
    self:AddClickEvent(goToEquip, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ServantNewMainView,
        viewdata = {tab = 3}
      })
      GameFacade.Instance:sendNotification(SkillRecommendEvent.CloseRecommendView)
    end)
  end
  local confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirmBtn, function()
    GameFacade.Instance:sendNotification(SkillRecommendEvent.SelectSolution, self.id)
    GameFacade.Instance:sendNotification(SkillRecommendEvent.CloseRecommendView)
  end)
  PictureManager.Instance:SetReturnActivityTexture(BgTextureName, self.bgTexture)
  PictureManager.Instance:SetUI(TextureName, self.texture)
  self.grid = self:FindGO("previewGrid"):GetComponent(UIGrid)
  self.gridCtrl = UIGridListCtrl.new(self.grid, ProfessionSkillCell, "ProfessionSkillCell")
  self.gridCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self:AddEventListener(MouseEvent.MouseClick)
end

local tempArray = {}

function SkillRecommendCell:SetData(data)
  if data then
    self.data = data
    self.id = data.solutionid
    self.pro = data.professionid
    local solutionData = Table_SkillRecommedSolution[self.id]
    if solutionData then
      self.title.text = solutionData.Title
      self.desc.text = solutionData.Desc
      self.basePoint.text = string.format(ZhString.SkillRecommend_basePoint, solutionData.RecAddPoint)
      TableUtility.ArrayClear(tempArray)
      local skills = Game.SkillRecommend["Solution_" .. self.id]
      if skills then
        for i = #skills - 1, #skills - 6, -1 do
          if ExtraSkillID ~= skills[i] then
            local data = {}
            data[1] = self.pro
            data[2] = skills[i]
            tempArray[#tempArray + 1] = data
          end
        end
        self.gridCtrl:ResetDatas(tempArray)
        self.icon.CurrentState = solutionData.Icon or 0
      end
    else
      redlog("solutionData nil", self.id)
    end
  end
end

function SkillRecommendCell:OnClickCell(cell)
  local skillId = cell.data
  local skillItem = SkillItemData.new(skillId, nil, nil, self.pro)
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tip.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  end
end

function SkillRecommendCell:OnCellDestroy()
  PictureManager.Instance:UnloadReturnActivityTexture(BgTextureName, self.bgTexture)
  PictureManager.Instance:UnLoadUI(TextureName, self.texture)
end
