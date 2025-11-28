autoImport("EnchantNewView")
EnchantSubView = class("EnchantSubView", EnchantNewView)
EnchantSubView.ViewType = UIViewType.NormalLayer
autoImport("EnchantNewCombineView")
EnchantSubView.BrotherView = EnchantIntegerCombineView
EnchantSubView.EquipChooseControl = EquipChooseBord_CombineSize
