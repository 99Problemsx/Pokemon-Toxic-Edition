module Settings

  # 1 - Show trainer's name.
  # 2 - Show trainer's icon.
  # 3 - Show both.
  PANELSTYLE = 3

  #File path (UI for Essentials v21+ or Pictures for Essentials v20.1-)
  FILEPATH = "Graphics/UI/Result Panel/"

  #Max rows of trainers' template
  TEMPLATEROWS = 6

  #The trainers' file name
  TEMPLATENAME = "Trainers_Vanilla"

  #Whether the champion icon will be displayed in the last round or not (Default = true).
  SHOWWINER = true
  
  #Whether the "Cancel" and "Details" buttons will be displayed or not (Default = true).
  SHOWBUTTONS = true

  #Whether the new functions will be activated or not (Default = true).
  CURSORFUNCTIONS = true

  #1: Gen 3- style trainers (128 x 128).
  #2: Gen 4+ style trainers (160 x 160).
  TRAINERSTYLE = 1

  PHRASES = [["A team with average potential.", "A candidate to finish first.", "A team with top-class potential.", "A sure-finalist team.", "The best candidate to be a champ!", "The perfect, invicible superstar!"], ["A team with average potential.", "A team to finish first.", "A team with top-class potential.", "A sure-finalist team.", "The best team to be champ!", "The perfect, invicible superstars!"]]

  #Whether the trainer's team will be shown only after the 1st round. (Default = false).
  HIDETEAMSROUND1 = false

  # RESULTPANEL_8, RESULTPANEL_16 or RESULTPANEL_DOUBLE = {
  #   :Panel name (the same name you call on pbResultPanel) => {
  #
  #     :Trainers => ["Trainer1", "Trainer2", "Trainer3" ...] the names of the trainers. You can also use an integer value to use a name stored in a corresponding
  # variable.
  #     
  # OR
  #
  #     :Trainers => ["Trainer's name", "Trainer's type", "Trainer's version"] if CURSORFUNCTIONS = true. You use an integer value to use a name stored in a
  # corresponding variable for the Trainer's Name. You can also enclose the value of “Trainer’s Version” in quotes to use a corresponding variable.
  #
  # In both cases, use "Player" to inform the player position. 
  #
  #     :Icons => [Icon1, Icon2, Icon3 ...] the icon position of each trainer (you don't need to infom this if your panel style = 1). You can also enclose the value
  # in quotes to use a corresponding variable.
  #
  #   If your panel's size = 8, you must inform 8 trainers/icons on RESULTPANEL_8 or 16 if the size is 16 on RESULTPANEL_16 / RESULTPANEL_DOUBLE.
  #
  #     :Teams => exclusive to DOUBLE panels. This is the name of the duo’s team and is only necessary if the CURSORFUNCTIONS = true. You can also use an integer
  # value to use a name stored in a corresponding variable.
  #
  #     :RoundX => [...] On these you must inform the position on the panel for each trainer who passes to the next round.
  #   For example: Round2 => [1,4,6,7] means that the trainers on positions 1, 4, 6, and 7 on the panel are classified to the second round. If using CURSORFUNCTIONS
  # you must include the round tittle in the end of each round.
  #   Note that the number of classified participants in each round is half the previous round. Sized 16 panels have one more round than sized 8 and double ones.
  # You can see some examples below.

  # This first example is a sized 8 panel, with CURSORFUNCTIONS = true and the second example with CURSORFUNCTIONS = false:
  
  RESULTPANEL_8 = {
    :Test => {
      :Trainers => [["Leaf", "POKEMONTRAINER_Leaf", 0], ["Bianca", "COOLTRAINER_F", 0], [12, "CHAMPION", 0], ["Brendan", "POKEMONTRAINER_Brendan", 0],
 		    ["Roberto", "BURGLAR", 0], ["May", "POKEMONTRAINER_May", 0], ["Player"], ["Regis", "COOLTRAINER_M", 0]],
      :Icons => [2, 18, 5, 3, 15, 4, 1, 19],
      :Round2 => [1,4,6,7,"Quarterfinals"],
      :Round3 => [1,7,"Semifinals"],
      :Round4 => [7,"Final"]
    },

    #:YourPanelName => {
    #  :Trainers => ["Trainer1", "Trainer2", "Player", "Trainer4", "Trainer5", "Trainer6", "Trainer7", "Trainer8"],
    #  :Icons => [Icon1, Icon2, Icon3, Icon4, Icon5, Icon6, Icon7, Icon8],
    #  :Round2 => [2,3,5,8],
    #  :Round3 => [3,8],
    #  :Round4 => [3]
    #},

  }

  # This first example is a sized 16 panel, with CURSORFUNCTIONS = true and the second example with CURSORFUNCTIONS = false:

  RESULTPANEL_16 = {
    :Test => {
      :Trainers => [["Paula", "AROMALADY", 0], ["Player"], ["Brendan", "POKEMONTRAINER_Brendan", "7"], ["Bianca", "COOLTRAINER_F", 0],
                    ["Icaro", "SWIMMER_M", 0], ["Regis", "COOLTRAINER_M", 0], ["Gean", "YOUNGSTER", 0], [12, "CHAMPION", 0],
                    ["Renan", "BIRDKEEPER", 0], ["May", "POKEMONTRAINER_May", 0], ["Everton", "BLACKBELT", 0], ["Victor", "TAMER", 0],
                    ["Leaf", "POKEMONTRAINER_Leaf", 0], ["Roberto", "BURGLAR", 0], ["Kelvin", "BUGCATCHER", 0], ["Adam", "SAILOR", 0]],
      :Icons => [9, 1, 3, 18, 32, 19, 37, 5, 12, 4, 13, 33, 2, 15, 14, 29,],
      :Round2 => [2,3,6,7,9,12,13,15, "Round of 16"],
      :Round3 => [2,7,9,13, "Quarterfinals"],
      :Round4 => [2,13,"Semifinals"],
      :Round5 => [2,"Final"]
    },

    #:YourPanelName => {
    #  :Trainers => ["Trainer1", "Trainer2", "Player", "Trainer4", "Trainer5", "Trainer6", "Trainer7", "Trainer8", ... , "Trainer16"],
    #  :Icons => [Icon1, Icon2, Icon3, Icon4, Icon5, Icon6, Icon7, Icon8, ... , Icon16],
    #  :Round2 => [2,3,5,8,10,11,13,16],
    #  :Round3 => [3,8,10,13],
    #  :Round4 => [3,10],
    #  :Round5 => [3]
    #},

  }

  # This first example is a double panel, with CURSORFUNCTIONS = true and the second example with CURSORFUNCTIONS = false:

  RESULTPANEL_DOUBLE = {
    :Test => {
      :Trainers => [["Paula", "AROMALADY", 0, "Player", "", 0], ["Brendan", "POKEMONTRAINER_Brendan", "7", "Bianca", "COOLTRAINER_F", 0],
                    ["Icaro", "SWIMMER_M", 0, "Regis", "COOLTRAINER_M", 0], ["Gean", "YOUNGSTER", 0, 12, "CHAMPION", 0],
                    ["Renan", "BIRDKEEPER", 0, "May", "POKEMONTRAINER_May", 0], ["Everton", "BLACKBELT", 0, "Victor", "TAMER", 0],
                    ["Leaf", "POKEMONTRAINER_Leaf", 0, "Roberto", "BURGLAR", 0], ["Kelvin", "BUGCATCHER", 0, "Adam", "SAILOR", 0]],
      :Teams => ["Team A", "Team B", "Team C", "Team D", "Team E", "Team F", "Team G", "Team H"],
      :Icons => [9, "26", 3, 18, 32, 19, 37, 5, 12, 4, 13, 33, 2, 15, 14, 29,],
      :Round2 => [1,3,5,8,"Quarterfinals"],
      :Round3 => [1,5,"Semifinals"],
      :Round4 => [1,"Final"]
    },

    #:YourPanelName => {
    #  :Trainers => [["Trainer1", "Trainer2"], ["Player", "Trainer4"], ["Trainer5", "Trainer6"], ["Trainer7", "Trainer8"], ... , ["Trainer15", "Trainer16"]],
    #  :Icons => [Icon1, Icon2, Icon3, Icon4, Icon5, Icon6, Icon7, Icon8, ... , Icon16],
    #  :Round2 => [2,3,5,8],
    #  :Round3 => [3,8],
    #  :Round4 => [3]
    #},
  
  }
  
end