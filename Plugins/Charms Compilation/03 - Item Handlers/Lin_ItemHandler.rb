#===============================================================================
# * Lin ItemHandler
#===============================================================================

ItemHandlers::UseFromBag.add(:CORRUPTCHARM, proc { |item|
  if CharmConfig::ACTIVE_CHARM
    pbToggleCharm(item)
  end
  next 1
})

ItemHandlers::UseFromBag.copy(:CORRUPTCHARM, :EASYCHARM, :EFFORTCHARM, :FRIENDSHIPCHARM, :GENECHARM, :HARDCHARM,
                              :HERITAGECHARM, :HIDDENCHARM, :POINTSCHARM, :PURECHARM, :STEPCHARM)