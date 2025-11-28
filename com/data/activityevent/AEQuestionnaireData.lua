AEQuestionnaireData = class("AEQuestionnaireData")

function AEQuestionnaireData:ctor(data)
  self.id = data.id
  self.data = data.questionnaire
end

function AEQuestionnaireData:SetTime(data)
  self.beginTime = data.begintime
  self.endTime = data.endtime
end
