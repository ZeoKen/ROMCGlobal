TipoffReason = class("TipoffReason")

function TipoffReason:ctor(server_data)
  self.reason_id = server_data.reason_id
  self.data = server_data.data
  self.report_count = server_data.report_count
end
