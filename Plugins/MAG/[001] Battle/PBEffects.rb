
module PBEffects
  QueensShield        = 1000 
  MagicTampering      = 1001
  LimitBreak          = 1002
  FaintedLast         = 1003
  Vengence            = 1004
  VinyHold            = 1005
  BallFetch           = 1006
         
  GoldHoard           = 1100
  # Entry Hazards
  # Starting at 1200 to avoid conflicts with new effects that maybe added in the future
  TerrainSmash        = 1200
  RestictiveWinds     = 1201
  HauntedOrbs         = 1202
  SharpSteel          = 1203
  BurningDebris       = 1204
  WaterChannel        = 1205
  RoseField           = 1206
  ProtonOverload      = 1207
  MindField           = 1208
  IceRing             = 1209
  DraconicRift        = 1210
  DarkMist            = 1211    
  ManaFlux            = 1212
  Miasma              = 1213
  # Status
  Winded              = 1214
  #OP
  ProhibitorySignboard = 3000
end






module Battle::DebugVariables
BATTLER_EFFECTS[PBEffects::QueensShield]        = {name: "Queen's Shield applies this round",                default: false}
BATTLER_EFFECTS[PBEffects::MagicTampering]      = {name: "Magic Tampering number of rounds remaining",       default: 0}
BATTLER_EFFECTS[PBEffects::LimitBreak]          = {name: "Limit Break locked into battle",                   default: false}
BATTLER_EFFECTS[PBEffects::Vengence]            = {name: "State of Vengence",                                default: 0}
BATTLER_EFFECTS[PBEffects::VinyHold]            = {name: "State of Viny Hold",                               default: 0}
BATTLER_EFFECTS[PBEffects::BallFetch]           = {name: "The move Ball Fetch copies",                       default: false}

BATTLER_EFFECTS[PBEffects::ProhibitorySignboard] = {name: "Prohibitory Signboard active",                    default: false}


  # Entry Hazards
SIDE_EFFECTS[PBEffects::GoldHoard]              = {name: "Gold Hoard exists",                                default: 0}
SIDE_EFFECTS[PBEffects::FaintedLast]            = {name: "Pokemon Fainted last turn",                        default: 0}
SIDE_EFFECTS[PBEffects::TerrainSmash]           = {name: "Terrain Smash exists",                             default: false}
SIDE_EFFECTS[PBEffects::RestictiveWinds]        = {name: "Restictive Winds exists",                          default: false}
SIDE_EFFECTS[PBEffects::HauntedOrbs]            = {name: "Haunted Orbs exists",                              default: false}
SIDE_EFFECTS[PBEffects::SharpSteel]             = {name: "Sharp Steel exists",                               default: false}
SIDE_EFFECTS[PBEffects::BurningDebris]          = {name: "Burning Debris exists",                            default: false}
SIDE_EFFECTS[PBEffects::WaterChannel]           = {name: "Water Channel exists",                             default: false}
SIDE_EFFECTS[PBEffects::RoseField]              = {name: "Rose Field exists",                                default: false}
SIDE_EFFECTS[PBEffects::ProtonOverload]         = {name: "Proton Overload exists",                           default: false}
SIDE_EFFECTS[PBEffects::MindField]              = {name: "Mind Field exists",                                default: false}
SIDE_EFFECTS[PBEffects::IceRing]                = {name: "Ice Ring exists",                                  default: false}
SIDE_EFFECTS[PBEffects::DraconicRift]           = {name: "Draconic Rift exists",                             default: false}
SIDE_EFFECTS[PBEffects::DarkMist]               = {name: "Dark Mist exists",                                 default: false}
SIDE_EFFECTS[PBEffects::ManaFlux]               = {name: "Mana Flux exists",                                 default: false}
SIDE_EFFECTS[PBEffects::Miasma]                 = {name: "Miasma exists",                                    default: false}

  # Status
BATTLER_EFFECTS[PBEffects::Winded]            = {name: "How long is Winded",                                 default: 0}  


end