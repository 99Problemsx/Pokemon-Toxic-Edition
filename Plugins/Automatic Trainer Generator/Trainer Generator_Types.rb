#===============================================================================
# Trainer Generator
#===============================================================================
# TRAINERS - Trainer types included
# GUARANTEED - A Pokemon guaranteed to have
# WHITELIST - All the Pokemon that can be used
# ONLYTYPE - The only type the trainer uses
# EGGGROUP - Filter by egg groups
# LEARNMOVE - Uses only Pokemon that can learn this move by level up
# MAINPOKEMON - Pokemon added to the list after all filters (Can be used to add new species or to increase the chances for a specie)
# POWER -Base total stats the Pokemon should have
# SPECIAL (VARIED) - Use different types over the party
# SPECIAL (COMBINATION) - Use a combination of types over the party
# SPECIAL (COLLECTOR) - All Pokemon in the party are the same specie
#===============================================================================
module TrainerClasses_Types
    ACETRAINER = {
        :TRAINERS => [:ACEDUO,:ACETRAINER_F,:ACETRAINER_F2,:ACETRAINER_3,:ACETRAINER_M,:ACETRAINER_M2,:ACETRAINER_M3,:COOLCOUPLE,:COOLTRAINER_M,:COOLTRAINER_F],
        :POWER => [450],
        :SPECIAL => [:VARIED]
    }
    AROMALADY = {
        :TRAINERS => [:AROMALADY,:AROMALADY2],
        :ONLYTYPE => [:GRASS],
        :MAINPOKEMON => [:ROSELIA,:SHROOMISH,:ODDISH]
    }
    ARTIST = {
        :TRAINERS => [:ARTIST_F,:ARTIST_M],
        :LEARNMOVE => [:COPYCAT,:MIMIC],
        :MAINPOKEMON => [:MRMIME,:BONSLY,:KRICKETOT,:SMEARGLE]
    }
    BACKPACKER = {
        :TRAINERS => [:BACKPACKER],
        :ONLYTYPE => [:NORMAL,:ROCK,:GROUND,:FLYING]
    }
    BATTLEGIRL = {
        :TRAINERS => [:BATTLEGIRL,:BATTLEGIRL2,:BATTLEGIRL3],
        :ONLYTYPE => [:FIGHTING],
        :MAINPOKEMON => [:MEDITITE,:MAKUHITA,:SHROOMISH,:MACHOP]
    }
    BEAUTY = {
        :TRAINERS => [:BEAUTY,:BEAUTY2,:BEAUTY3,:BEAUTY4],
        :WHITELIST => [:MARILL,:GOLDEEN,:WAILMER,:KECLEON,:SEVIPER,:LOTAD,:SHROOMISH,:NUMEL,:CARVANHA,:SPHEAL,:SPOINK,:POOCHYENA,:CLAMPERL,:CORPHISH,:HORSEA,:LUVDISC,
        :ODDISH,:BELLSPROUT,:NIDORANfE,:CLEFAIRY,:MEWOTH,:GLAMEOW,:BURMY,:FINNEON,:PSYDUCK,:ROSELIA,:BUNEARY,:SKITTY,:SENTRET]
    }
    BIKER = {
        :TRAINERS => [:BIKER,:BIKER2],
        :ONLYTYPE => [:POISON,:FIRE],
        :MAINPOKEMON => [:KOFFING,:GRIMER,:EKANS,:GULPIN]
    }
    BIRDKEEPER = {
        :TRAINERS => [:BIRDKEEPER,:BIRDKEEPER2,:BIRDKEEPER3,:BIRDKEEPER4],
        :ONLYTYPE => [:FLYING]
    }
    BLACKBELT = {
        :TRAINERS => [:BLACKBELT,:BLACKBELT2,:BLACKBELT3],
        :ONLYTYPE => [:FIGHTING]
    }
    BREEDER = {
        :TRAINERS => [:BREEDER_F,:BREEDER_F2,:BREEDER_F3,:BREEDER_F4,:BREEDER_M,:BREEDER_M2],
        :SPECIAL => [:VARIED]
    }
    BUGCATCHER = {
        :TRAINERS => [:BUGCATCHER,:BUGCATCHER2,:BUGCATCHER3,:BUGMANIAC],
        :ONLYTYPE => [:BUG]
    }
    BURGLAR = {
        :TRAINERS => [:BURGLAR,:BURGLAR2],
        :ONLYTYPE => [:FIRE],
        :MAINPOKEMON => [:KOFFING]
    }
    BUTLER = {
        :TRAINERS => [:BUTLER],
        :ONLYTYPE => [:FLYING]
    }
    CAMERAMAN = {
        :TRAINERS => [:CAMERAMAN],
        :ONLYTYPE => [:ELECTRIC]
    }
    CAMPER = {
        :TRAINERS => [:CAMPER_F,:CAMPER_M,:CAMPER_M2,:CAMPER_M3],
        :SPECIAL => [:VARIED]
    }
    CHANELLER = {
        :TRAINERS => [:CHANELLER],
        :ONLYTYPE => [:GHOST]
    }
    CHEF = {
        :TRAINERS => [:CHEF],
        :SPECIAL => [:COMBINATION,[:WATER,:FIRE,:GRASS]]
    }
    COLLECTOR = {
        :TRAINERS => [:COLLECTOR],
        :SPECIAL => [:COLLECTOR],
    }
    CRUSHTRAINER = {
        :TRAINERS => [:CRUSHGIRL,:CRUSHKIN,:CRUSHKIN2],
        :ONLYTYPE => [:FIGHTING]
    }
    CUEBALL = {
        :TRAINERS => [:CUEBALL],
        :ONLYTYPE => [:FIGHTING,:DARK]
    }
    CUTECOUPLE = {
        :TRAINERS => [:CUTECOUPLE],
        :GUARANTEED => [:SMEARGLE]
    }
    DELINQUENT = {
        :TRAINERS => [:DELINQUENT],
        :ONLYTYPE => [:DARK]
    }
    DIVER = {
        :TRAINERS => [:DIVER_F,:DIVER_M],
        :ONLYTYPE => [:WATER]
    }
    DRAGONTAMER = {
        :TRAINERS => [:DRAGONTAMER],
        :ONLYTYPE => [:DRAGON]
    }
    ENGINEER = {
        :TRAINERS => [:ENGINEER],
        :ONLYTYPE => [:ELECTRIC]
    }
    EXPERT = {
        :TRAINERS => [:EXPERT_F,:EXPERT_M],
        :ONLYTYPE => [:FIGHTING]
    }
    FAIRYTALEGIRL = {
        :TRAINERS => [:FAIRYTALEGIRL],
        :ONLYTYPE => [:PSYCHIC,:NORMAL]
    }
    FISHERMAN = {
        :TRAINERS => [:FISHERMAN,:FISHERMAN2,:FISHERMAN3,:FISHERMAN4],
        :ONLYTYPE => [:WATER]
    }
    FURISODEGIRL = {
        :TRAINERS => [:FURISODEGIRL,:FURISODEGIRL2,:FURISODEGIRL3,:FURISODEGIRL4],
        :WHITELIST => [:EEVEE]
    }
    GAMBLER = {
        :TRAINERS => [:GAMBLER],
        :LEARNMOVE => [:HORNDRILL]
    }
    GARDENER = {
        :TRAINERS => [:GARDENER],
        :ONLYTYPE => [:GRASS,:BUG]
    }
    GENTLEMAN = {
        :TRAINERS => [:GENTLEMAN,:GENTLEMAN2,:GENTLEMAN3,:GENTLEMAN4],
        :WHITELIST => [:ELECTRIKE,:ZIGZAGOON,:CHATOT,:ZANGOOSE,:NIDORANfE,:NIDORANmE,:PIKACHU,:EEVEE,:CUBONE,:PSYDUCK,:GROWLITH,:PONYTA,
        :STARLY,:HOOTHOOT,:MEWOTH,:ELECTRIKE,:MAREEP],
    }
    GUITARIST = {
        :TRAINERS => [:GUITARIST],
        :ONLYTYPE => [:ELECTRIC]
    }
    HEXMANIAC = {
        :TRAINERS => [:HEXMANIAC],
        :ONLYTYPE => [:PSYCHIC,:GHOST]
    }
    HIKER = {
        :TRAINERS => [:HIKER,:HIKER2,:HIKER3],
        :ONLYTYPE => [:FIGHTING,:ROCK,:GROUND]
    }
    INTERVIEWERS = {
        :TRAINERS => [:INTERVIEWERS]
    }
    JUGGLER = {
        :TRAINERS => [:JUGGLER],
        :ONLYTYPE => [:PSYCHIC],
        :GUARANTEED => [:VOLTORB]
    }
    KINDLER = {
        :TRAINERS => [:KINDLER],
        :ONLYTYPE => [:FIRE]
    }
    LADY = {
        :TRAINERS => [:LADY,:LADY2,:LADY3,:LADY4],
        :WEAKER => [420]
    }
    LASS = {
        :TRAINERS => [:LASS,:LASS2,:LASS3],
        :ONLYTYPE => [:NORMAL,:GRASS]
    }
    MAID = {
        :TRAINERS => [:MAID],
        :EGGGROUP => [:Field]
    }
    MEDIUM = {
        :TRAINERS => [:MEDIUM],
        :ONLYTYPE => [:PSYCHIC,:GHOST]
    }
    NINJABOY = {
        :TRAINERS => [:NINJABOY],
        :ONLYTYPE => [:POISON],
        :MAINPOKEMON => [:NINCADA,:NINJASK]
    }
    OFFICELADY = {
        :TRAINERS => [:OFFICELADY]
    }
    OWNER = {
        :TRAINERS => [:OWNER],
        :POWER => [450],
        :SPECIAL => [:VARIED]
    }
    PAINTER = {
        :TRAINERS => [:PAINTER,:PAINTER2],
        :WHITELIST => [:SMEARGLE]
    }
    PARASOLLADY = {
        :TRAINERS => [:PARASOLLADY],
        :ONLYTYPE => [:WATER]
    }
    PICNICKER = {
        :TRAINERS => [:PICNICKER,:PICNICKER2]
    }
    POKEFAN = {
        :TRAINERS => [:POKEFAN_F,:POKEFAN_F2,:POKEFAN_M,:POKEFAN_M2],
        :EGGGROUP => [:Fairy]
    }
    POKEMANIAC = {
        :TRAINERS => [:POKEMANIAC,:POKEMANIAC2],
        :EGGGROUP => [:Monster]
    }
    PRESCHOOLER = {
        :TRAINERS => [:PRESCHOOLER_F,:PRESCHOOLER_M],
        :WEAKER => [420]
    }
    PSYCHIC = {
        :TRAINERS => [:PSYCHIC_F,:PSYCHIC_F2,:PSYCHIC_F3,:PSYCHIC_M,:PSYCHIC_M2],
        :ONLYTYPE => [:PSYCHIC,:GHOST]
    }
    PUNKTRAINER = {
        :TRAINERS => [:PUNKTRAINER_F,:PUNKTRAINER_M],
        :ONLYTYPE => [:FIRE]    
    }
    RANGER = {
        :TRAINERS => [:RANGER_F,:RANGER_F2,:RANGER_F3,:RANGER_M,:RANGER_M2,:RANGER_M3],
        :ONLYTYPE => [:GRASS]
    }
    REPORTER = {
        :TRAINERS => [:REPORTER],
        :ONLYTYPE => [:ELECTRIC,:FLYING]
    }
    RICHBOY = {
        :TRAINERS => [:RICHBOY,:RICHBOY2],
        :WHITELIST => [:MARILL,:ZIGZAGOON,:SHINX,:SUDOWOODO,:PIPLUP]
    }
    RISINGSTAR = {
        :TRAINERS => [:RISINGSTAR_F,:RISINGSTAR_M],
        :WHITELIST => [:RELICANTH,:PIKACHU,:ABRA,:ELECTRIKE,:RIOLU,:PSYDUCK,:SOLROCK,:LUNATONE,:MAGNEMITE,:GOLDEEN,:BIDOOF,:ODDISH]
    }
    ROCKER = {
        :TRAINERS => [:ROCKER,:ROCKER2],
        :ONLYTYPE => [:ELECTRIC]
    }
    ROLLERSKATER = {
        :TRAINERS => [:ROLLERSKATER_F,:ROLLERSKATER_M],
        :ONLYTYPE => [:FLYING,:ELECTRIC]
    }
    ROUGHNECK = {
        :TRAINERS => [:ROUGHNECK],
        :ONLYTYPE => [:FIGHTING,:DARK]
    }
    RUINMANIAC = {
        :TRAINERS => [:RUINMANIAC,:RUINMANIAC2,:RUINMANIAC3],
        :ONLYTYPE => [:GROUND,:ROCK,:STEEL],
        :MAINPOKEMON => [:GEODUDE,:BRONZOR,:SANDSHREW,:SANDSLASH]
    }
    SAILOR = {
        :TRAINERS => [:SAILOR,:SAILOR2,:SAILOR3],
        :ONLYTYPE => [:WATER],
        :MAINPOKEMON => [:MACHOP,:RATICATE]
    }
    SCHOOLKID = {
        :TRAINERS => [:SCHOOLBOY,:SCHOOLBOY2,:SCHOOLBOY3,:SCHOOLBOY4,:SCHOOLBOY5,:SCHOOLGIRL,:SCHOOLGIRL2,:SCHOOLGIRL3,:SCHOOLGIRL4],
        :WHITELIST => [:SHROOMISH,:WURMPLE,:RALTS,:MEDITITE,:BANNETE,:WHISMUR,:NUMEL,:ODDISH,:WINGULL,:GASTLY,:ABRA,:WOOPER,:MRMIME,:DRIFLOON,:PACHIRISU,
        :TANGELA,:YANMA,:NATU,:PARAS,:DITTO,:POLIWAG,:MAGNEMITE,:ZIGZAGOON,:JYNX,:ELECTABUZZ,:MAGMAR,:VOLTORB,:EEVEE,:GROWLITH,:BELLSPROUT,:LEDYBA,:EXEGGCUTE,
        :AIPOM,:SENTRET,:PIDGEY,:SANDSHREW,:ZUBAT,:VULPIX,:ROSELIA]
    }
    SCIENTIST = {
        :TRAINERS => [:SCIENTIST_F,:SCIENTIST_M,:SCIENTIST_M2,:SCIENTIST_M3],
        :ONLYTYPE => [:PSYCHIC],
        :MAINPOKEMON => [:PORYGON,:MUK,:VOLTORB,:MAGNEMITE]
    }
    SISANDBRO = {
        :TRAINERS => [:SISANDBRO],
        :ONLYTYPE => [:WATER]
    }
    SKYTRAINER = {
        :TRAINERS => [:SKYTRAINER_F,:SKYTRAINER_M],
        :ONLYTYPE => [:FLYING]
    }
    SOCIALITE = {
        :TRAINERS => [:SOCIALITE],
        :WHITELIST => [:BUNEARY,:GLAMEOW,:ROSELIA]
    }
    STREETTHUG = {
        :TRAINERS => [:STREETTHUG],
        :ONLYTYPE => [:DARK]
    }
    SUPERNERD = {
        :TRAINERS => [:SUPERNERD,:SUPERNERD2,:SUPERNERD3],
        :ONLYTYPE => [:POISON,:ELECTRIC]
    }
    SWIMMER = {
        :TRAINERS => [:SWIMMER_F,:SWIMMER_F2,:SWIMMER_F3,:SWIMMER_F4,:SWIMMER_F5,:SWIMMER_M,:SWIMMER_M2,:SWIMMER_M3],
        :ONLYTYPE => [:WATER]
    }
    TAMER = {
        :TRAINERS => [:TAMER],
        :LEARNMOVE => [:SLASH,:CRABHAMMER]
    }
    TEACHER = {
        :TRAINERS => [:TEACHER],
        :WHITELIST => [:ZIGZAGOON,:ROSELIA,:CLEFAIRY,:AIPOM,:SUNKERN,:CHATOT,:JIGGLYPUFF]
    }
    TEAMMATES = {
        :TRAINERS => [:TEAMMATES],
        :SPECIAL => [:VARIED]
    }
    TOURIST = {
        :TRAINERS => [:TOURIST_F,:TOURIST_F2,:TOURIST_M]
    }
    TRIATHLETE_SWIMMING = {
        :TRAINERS => [:TRIATHLETE],
        :ONLYTYPE => [:WATER]
    }
    TRIATHLETE_RUNNING = {
        :TRAINERS => [:TRIATHLETE2],
        :WHITELIST => [:DODUO,:DODRIO]
    }
    TRIATHLETE_RIDING = {
        :TRAINERS => [:TRIATHLETE3],
        :ONLYTYPE => [:ELECTRIC]
    }
    TUBER = {
        :TRAINERS => [:TUBER_F,:TUBER_F2,:TUBER_F3,:TUBER_M,:TUBER_M2,:TUBER_M3],
        :ONLYTYPE => [:WATER,:NORMAL],
        :MAINPOKEMON => [:MARILL,:ZIGZAGOON]
    }
    TWINS = {
        :TRAINERS => [:TWINS,:TWINS2,:TWINS3],
        :WHITELIST => [:PLUSLE,:MINUN,:SEEDOT,:LOTAD,:WURMPLE,:WHISMUR,:CLEFAIRY,:JIGGLYPUFF,:EEVEE,:SUDOWOODO,:MRMIME,:PACHIRISU,:SPINARAK,:LEDYBA,:BELLSPROUT,:ODDISH,:WOOPER,
        :TEDDIURSA,:PHANPY,:MARILL,:MAREEP]
    }
    VETERAN = {
        :TRAINERS => [:VETERAN_F,:VETERAN_M]
    }
    WAITER = {
        :TRAINERS => [:WAITER,:WAITRESS],
        :ONLYTYPE => [:NORMAL]
    }
    WORKER = {
        :TRAINERS => [:WORKER,:WORKER2],
        :ONLYTYPE => [:ROCK,:FIGHTING,:STEEL,:GROUND]
    }
    YOUNGCOUPLE = {
        :TRAINERS => [:YOUNGCOUPLE,:YOUNGCOUPLE2]
    }
    YOUNGSTER = {
        :TRAINERS => [:YOUNGSTER,:YOUNGSTER2,:YOUNGSTER3],
        :ONLYTYPE => [:BUG,:NORMAL]
    }
end