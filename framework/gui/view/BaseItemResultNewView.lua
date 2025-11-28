autoImport("BaseItemResultView")
autoImport("BaseItemResultNewCell")
BaseItemResultNewView = class("BaseItemResultNewView", BaseItemResultView)
BaseItemResultNewView.CellControl = BaseItemResultNewCell
BaseItemResultNewView.CellPrefabName = "BaseItemResultNewCell"
BaseItemResultNewView.ViewType = UIViewType.PopUpLayer
