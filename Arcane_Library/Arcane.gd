extends Node

# This is enum to prevent user edit on inspector :/
#@export_enum("0.0.1") var LIBRARY_VERSION: String = "0.0.1" 

var LIBRARY_VERSION = '0.0.1'

#@export_enum("view", "pad")
#var deviceType: String = "view"

var utils: AUtils
var msg: AWebsocketService
var devices = []
var pads = []
var internalViewsIds = []
var internalPadsIds = []
var iframeViewsIds = []
var iframePadsIds = []
var pad:ArcanePad

var isIframe
var isWebEnv

var signals = ASignals.new()

var defaultParams = {
	'deviceType': 'view',
	'port': '3005',
	'reverseProxyPort': '3009',
	'hideMouse': true,
	'padOrientation': 'Landscape'
#	'arcaneCode': '',
	}
	
var initParams = defaultParams

func init(providedParams = defaultParams):
	
	# Merge the providedParams dictionary into the params dictionary
	for key in providedParams:
		initParams[key] = providedParams[key]
		
	utils = AUtils.new()
	self.add_child(utils)
	
	msg = AWebsocketService.new(initParams)
	self.add_child(msg)
	
	print('Using ArcaneLibrary version ', LIBRARY_VERSION)
	Arcane.signals.connect("Initialize", self, 'onInitialize')
	Arcane.signals.connect("RefreshGlobalState", self, '_refreshGlobalState')
	

func onInitialize(initializeEvent, _from):
	
	msg.onInitialize(initializeEvent)
	
	refreshGlobalState(initializeEvent.globalState)
	if msg.deviceType == "pad" && msg.clientType == "iframe": padInitialization()
	elif msg.deviceType == "view": viewInitialization()
	
	var initialState = AModels.InitialState.new(pads)
	signals.emit_signal('ArcaneClientInitialized', initialState)
	Arcane.signals.disconnect('Initialize', self, 'onInitialize')

func padInitialization(): 
	Arcane.utils.writeToScreen("aaaaaaaaa")
	
	for p in pads: 
		if p.deviceId == msg.deviceId:
			 pad = p

	if pad == null: 
		printerr('Pad is null on iframe pad initialization')
		return
	
	if initParams.padOrientation == 'Landscape': pad.setScreenOrientationLandscape()
	elif initParams.padOrientation == 'Portrait': pad.setScreenOrientationPortrait()
	
func viewInitialization():
	if(initParams.hideMouse == true):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _refreshGlobalState(e, _from):
	refreshGlobalState(e.refreshedGlobalState)

func refreshGlobalState(refreshedGlobalState):
	devices = refreshedGlobalState.devices
	refreshClientsIds(devices)
	pads = getPads(devices)


func refreshClientsIds(_devices: Array) -> void:
	var _internalPadsIds: Array = []
	var _internalViewsIds: Array = []
	var _iframePadsIds: Array = []
	var _iframeViewsIds: Array = []

	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalPadsIds.append(client.id)
				else:
					_iframePadsIds.append(client.id)

		elif device.deviceType == AModels.ArcaneDeviceType.view:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalViewsIds.append(client.id)
				else:
					_iframeViewsIds.append(client.id)

	internalPadsIds = _internalPadsIds
	internalViewsIds = _internalViewsIds
	iframePadsIds = _iframePadsIds
	iframeViewsIds = _iframeViewsIds

func getPads(_devices: Array) -> Array:
	var _pads:Array = []

	var padDevices = []
	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			var iframeClients = []
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.iframe:
					iframeClients.append(client)
			if iframeClients.size() > 0:
				padDevices.append(device)

	for padDevice in padDevices:
		var iframeClientId: String
		var internalClientId: String

		for client in padDevice.clients:
			if client.clientType == AModels.ArcaneClientType.iframe:
				iframeClientId = client.id
			elif client.clientType == AModels.ArcaneClientType.internal:
				internalClientId = client.id

		if iframeClientId == null or iframeClientId == "":
			printerr("Tried to set pad but iframeClientId was not found")

		if internalClientId == null or internalClientId == "":
			printerr("Tried to set pad but internalClientId was not found")

		if iframeClientId != null and internalClientId != null:
			var _pad = ArcanePad.new(padDevice.id, internalClientId, iframeClientId, true, padDevice.user)
			_pads.append(_pad)

	return _pads