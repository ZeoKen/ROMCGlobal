local BaseCell = autoImport("BaseCell")
NewCreateRoleProfSelectCell = class("NewCreateRoleProfSelectCell", BaseCell)

function NewCreateRoleProfSelectCell:Init()
  self:FindObjs()
end

function NewCreateRoleProfSelectCell:FindObjs()
  self.profIcon = self:FindComponent("profIcon", UISprite)
  self.selectGo = self:FindGO("select")
  self.selectBg = self:FindComponent("selectbg", UISprite, self.selectGo)
  self.objEffect = self:FindGO("objEffect")
  self.effectClick = Asset_Effect.PlayOn(ResourcePathHelper.UIEffect("Eff_GenderChoice_juese"), self.objEffect.transform)
  self.effectClick:SetActive(false)
  self:AddClickEvent(self.gameObject, function()
    if FunctionNewCreateRole.Me().isFadeAnim then
      return
    end
    if self.effectClick then
      self.effectClick:SetActive(false)
      self.effectClick:SetActive(true)
    end
    FunctionNewCreateRole.Me().clickSound = true
    self:PassEvent(NewCreateRoleViewEvent.ProfRouletteSelect, self.id)
  end)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.infoLb = self:FindComponent("title", UILabel)
end

function NewCreateRoleProfSelectCell:SetData(data)
  self.data = data
  self.id = data.id
  self.prof = data.prof
  IconManager:SetProfessionIcon(data.icon, self.profIcon)
  local prof_color = FunctionNewCreateRole.Me().ProfConfig[self.id].dye_color
  self.selectBg.color = LuaColor.TryParseHtmlToColor(prof_color, 1, 1, 1, 1)
end

function NewCreateRoleProfSelectCell:SetOnSelect(isSelect)
  self.selectGo:SetActive(isSelect)
end

function NewCreateRoleProfSelectCell:SetAlpha(alpha)
  self.widget.alpha = alpha
end

function NewCreateRoleProfSelectCell:SetInfo(str)
  self.infoLb.text = str
end
