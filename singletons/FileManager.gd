extends Node

# const _dataFilePath : String = "user://data.dat"
const _configFilePath : String = "user://settings.cfg"

func _ready() -> void:
    connect("tree_exiting", self, "_on_exiting_tree")

func _on_exiting_tree() -> void:
    var file : File = File.new()
    if file.file_exists(_configFilePath) and file.is_open():
        file.close()

# func saveData() -> void:
#     var data : Dictionary = {}
#     var nodesToSave : Array = SceneManager.getLoadAndSaveNode()
#     for node in nodesToSave:
#         var dictionaryToSave : Dictionary = node.saveData()
#         for key in dictionaryToSave:
#             data[key] = dictionaryToSave[key]
#     var file : File = File.new()
#     file.open(_configFilePath, File.WRITE)
#     file.store_line(to_json(data))
#     file.close()
#     emit_signal("save_finished")

# func getData() -> Dictionary:
#     var data : Dictionary = {}
#     var file : File = File.new()
#     if file.file_exists(_configFilePath):
#         file.open(_configFilePath, File.READ)
#         while not file.eof_reached():
#             var line : String  = file.get_line()
#             if line == null or line.empty():
#                 break
#             data = parse_json(line)
#             file.close()
#     emit_signal("load_finished")
#     return data

func saveSettingData() -> void:
    var configDatas : Array = getConfigDatasFromNodeToSave()
    createConfigFile()
    var config : ConfigFile = ConfigFile.new()
    var error : int = config.load(_configFilePath)
    assert(error == OK)
    if error != OK:
        return
    for configData in configDatas:
        var data : Dictionary = configData.data
        for key in data.keys():
            config.set_value(configData.section, key, data[key])
    config.save(_configFilePath)

func getSettingData(sectionConfig : String) -> Dictionary:
    var config : ConfigFile = ConfigFile.new()
    createConfigFile()
    var error : int = config.load(_configFilePath)
    var data : Dictionary = {}
    assert(error == OK)
    if error == OK and config.has_section(sectionConfig):
        for key in config.get_section_keys(sectionConfig):
            data[str(key)] = config.get_value(sectionConfig, key)
    return data

func createConfigFile() -> void:
    var file : File = File.new()
    if not file.file_exists(_configFilePath):
        file.open(_configFilePath, File.WRITE)
        file.close()

func createFile(filePath : String) -> void:
    var file : File = File.new()
    file.open(filePath, File.WRITE)
    file.close()

func doesFileExist(filePath : String) -> bool:
    var file : File = File.new()
    return file.file_exists(filePath)

func getConfigDatasFromNodeToSave() -> Array:
    var configDatas : Array = []
    var nodesToSave : Array = SceneManager.getLoadAndSaveNode()
    for node in nodesToSave:
        var configDatasFromNode : Array = node.saveData()
        configDatas += configDatasFromNode
    return configDatas