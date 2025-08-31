table.insert(
  props,
  {
    Name = "IP Address",
    Type = "string",
    Value = "192.168.1.30"
  }
)

table.insert(
  props,
  {
    Name = "Model",
    Type = "enum",
    Choices = {"PLUTO","OSMIA","MINIMA","NEXUS","PLAYER_1", "PLAYER_2", "PLAYER_3", "PLAYER_4"},
    Value = "PLUTO"
  }
)

table.insert(
  props,
  {
    Name = "Media List Count",
    Type = "integer",
    Value = 20,
    Min = 1,
    Max = 128
  }
)
