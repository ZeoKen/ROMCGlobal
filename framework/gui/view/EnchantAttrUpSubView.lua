autoImport("EnchantAttrUpView")
EnchantAttrUpSubView = class("EnchantAttrUpSubView", EnchantAttrUpView)
EnchantAttrUpSubView.ViewType = UIViewType.NormalLayer
autoImport("EnchantNewCombineView")
EnchantAttrUpSubView.BrotherView = EnchantIntegerCombineView
EnchantAttrUpSubView.EquipChooseControl = EquipChooseBord_CombineSize
