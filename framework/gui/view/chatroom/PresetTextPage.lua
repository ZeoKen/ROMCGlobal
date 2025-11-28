autoImport("WrapCellHelper")
autoImport("PresetTextCell")
PresetTextPage = class("PresetTextPage", SubView)

function PresetTextPage:OnExit()
  self:SavePresetText()
end

function PresetTextPage:Init()
  self:FindObjs()
  self:InitShow()
end

function PresetTextPage:FindObjs()
  self.contentScrollView = self:FindGO("PresetTextScrollView", self.container.PopUpWindow):GetComponent(UIScrollView)
end

function PresetTextPage:InitShow()
  self.localData = {}
  local container = self:FindGO("PresetText_Container", self.container.PopUpWindow)
  self.itemWrapHelper = WrapListCtrl.new(container, PresetTextCell, "PresetTextCell", WrapListCtrl_Dir.Vertical, 2, 620)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:UpdatePresetTextInfo()
end

function PresetTextPage:UpdatePresetTextInfo(datas)
  local datas = ChatRoomProxy.Instance.presetTextData
  self.itemWrapHelper:ResetDatas(datas)
end

function PresetTextPage:HandleClickItem(cellctl)
  if self.container.contentInput.gameObject.activeInHierarchy then
    self.container:SetContent(OverSea.LangManager.Instance():GetLangByKey(cellctl.textInput.value))
  end
end

function PresetTextPage:SavePresetText()
  if ChatRoomProxy.Instance.isEditorPresetText then
    local datas = ChatRoomProxy.Instance.presetTextData
    TableUtility.TableClear(self.localData)
    for i = 1, 5 do
      if datas[i] then
        table.insert(self.localData, datas[i].msg)
      else
        table.insert(self.localData, "")
      end
    end
    ServiceNUserProxy.Instance:CallPresetMsgCmd(self.localData)
    ChatRoomProxy.Instance.isEditorPresetText = false
  end
end
