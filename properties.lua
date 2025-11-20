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
    Choices = {"PLUTO", "OSMIA", "MINIMA", "NEXUS", "PLAYER_1", "PLAYER_2", "PLAYER_3", "PLAYER_4"},
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
    Max = 255
  }
)

table.insert(
  props,
  {
    Name = "Output Video Preview",
    Type = "enum",
    Choices = {"Disabled", "Enabled"},
    Value = "Disabled"
  }
)

table.insert(
  props,
  {
    Name = "Preview Refresh",
    Type = "enum",
    Choices = {"0.1 fps", "0.5 fps", "1 fps", "2 fps", "5 fps", "10 fps", "15 fps"},
    Value = "1 fps"
  }
)

table.insert(
  props,
  {
    Name = "Enable JSON Data Pins (WARNING)",
    Type = "enum",
    Choices = {"Disabled", "Enabled"},
    Value = "Disabled"
  }
)

table.insert(
  props,
  {
    Name = "Logging Level",
    Type = "enum",
    Choices = {"Normal", "Errors Only", "Debug"},
    Value = "Normal"
  }
)
