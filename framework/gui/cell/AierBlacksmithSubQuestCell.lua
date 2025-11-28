AierBlacksmithSubQuestCell = class("AierBlacksmithSubQuestCell", AierBlacksmithQuestCell)

function AierBlacksmithSubQuestCell:FindObjs()
  AierBlacksmithSubQuestCell.super.FindObjs(self)
  self.qidaiMark = self:FindGO("qidaiMark")
  self.lockMark = self:FindGO("lockMark")
  self.lockMarkLb = self.lockMark:GetComponent(UILabel)
  self.name.transform.localPosition = LuaVector3(-271, 6, 0)
  self.normal = self:FindGO("normal")
end

function AierBlacksmithSubQuestCell:SetData(data)
  self.data = data
  local info = data.info
  self.normal:SetActive(true)
  self.name.text = info.Desc
  self.desc.text = ""
  self.descicon.gameObject:SetActive(false)
  self.finishMark:SetActive(false)
  self.helpMark:SetActive(false)
  self.btn:SetActive(false)
  self.qidaiMark:SetActive(false)
  self.lockMark:SetActive(false)
  self.btnText.text = ZhString.AierBlacksmithBtn_Goto
  if info.NextVersion == 1 then
    self.qidaiMark:SetActive(true)
    self.normal:SetActive(false)
    return
  end
  self.name.color = LuaGeometry.GetTempColor(0.23137254901960785, 0.13725490196078433, 0.027450980392156862, 1)
  if not data.level_ok or not data.pre_quest_ok then
    self.lockMark:SetActive(true)
    self.name.color = LuaGeometry.GetTempColor(0.5764705882352941, 0.4823529411764706, 0.27058823529411763, 1)
    if not data.level_ok and data.pre_quest_ok then
      self.lockMarkLb.text = string.format(ZhString.AierBlacksmith_UnlockWhenLv, info.UnlockLevel)
    elseif data.level_ok and not data.pre_quest_ok then
      self.lockMarkLb.text = string.format(ZhString.AierBlacksmith_UnlockWhenPreQuest, info.PreQuestName)
    else
      self.lockMarkLb.text = string.format(ZhString.AierBlacksmith_UnlockWhenLvAndPreQuest, info.PreQuestName, info.UnlockLevel)
    end
    return
  end
  if data.finished then
    self.finishMark:SetActive(true)
    return
  end
  self.btn:SetActive(true)
end
