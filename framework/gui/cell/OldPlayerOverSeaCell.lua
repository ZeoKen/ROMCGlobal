local baseCell = autoImport("BaseCell")
OldPlayerOverSeaCell = class("OldPlayerOverSeaCell", baseCell)
autoImport("InviteItemCell")
local tempVector3 = LuaVector3.Zero()

function OldPlayerOverSeaCell:Init()
  OldPlayerOverSeaCell.super.Init(self)
  self:FindObjs()
  self:InitData()
end

function OldPlayerOverSeaCell:FindObjs()
end

function OldPlayerOverSeaCell:InitData()
end

function OldPlayerOverSeaCell:SetData(data)
  local stageLbl = self:FindGO("StageLbl"):GetComponent(UILabel)
  if data.count then
    stageLbl.text = string.format(ZhString.ReturnActivityPanel_BindPlayer, data.count)
  end
  if data.lv then
    stageLbl.text = string.format(ZhString.ReturnActivityPanel_Lv, data.count, data.lv)
  end
  local getBtnSprite = self:FindGO("Bg", getReward):GetComponent(UISprite)
  getBtnSprite.color = ColorUtil.NGUIShaderGray
  local getBtn = self:FindGO("GetBtn")
  self:AddClickEvent(getBtn, function()
    if #ReturnActivityProxy.Instance.userInviteData.awardid >= self.indexInList then
      local awardid = {
        self.indexInList
      }
      ServiceActivityCmdProxy.Instance:CallUserInviteAwardCmd(awardid, ReturnActivityProxy.Instance.recommendactData.id)
      ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_GLOBAL_RECOMMEND, ReturnActivityProxy.Instance.recommendactData.id)
    end
  end)
  local getedFlag = self:FindGO("GetedFlag")
  local awardid = ReturnActivityProxy.Instance.userInviteData.awardid
  if awardid and awardid[self.indexInList] then
    if awardid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_PROHIBIT then
      local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
      getBtnSprite.color = ColorUtil.NGUIShaderGray
      local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
      getBtnLbl.effectColor = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
      getBtn:SetActive(true)
      getedFlag:SetActive(false)
    elseif awardid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_CANGET then
      local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
      getBtnSprite.color = ColorUtil.NGUIWhite
      local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
      getBtnLbl.effectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882)
      getBtn:SetActive(true)
      getedFlag:SetActive(false)
    elseif awardid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_RECEIVED then
      getBtn:SetActive(false)
      getedFlag:SetActive(true)
    end
  else
    local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
    getBtnSprite.color = ColorUtil.NGUIShaderGray
    local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
    getBtnLbl.effectColor = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
    getBtn:SetActive(true)
    getedFlag:SetActive(false)
  end
  for i = 1, 3 do
    local itemCellGO = self:FindGO("ActiveItemCell" .. i)
    itemCellGO:SetActive(false)
  end
  if data.reward then
    local reward = ItemUtil.GetRewardItemIdsByTeamId(data.reward)
    if reward then
      for i = 1, 3 do
        if reward[i] then
          local itemCellGO = self:FindGO("ActiveItemCell" .. i)
          itemCellGO:SetActive(true)
          local cell = InviteItemCell.new(itemCellGO)
          local itemdata = ItemData.new("active", reward[i].id)
          itemdata.num = reward[i].num
          cell:SetData(itemdata)
          cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
        else
          local itemCellGO = self:FindGO("ActiveItemCell" .. i)
          itemCellGO:SetActive(false)
        end
      end
    end
  end
end

function OldPlayerOverSeaCell:OnClickCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end
