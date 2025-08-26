extends Node
#al usar este singleton se debe llamar a la funcion .screen_shake(10, 0.5) de la camara shakeable_camera2D con camera_shake_intensity_param y camera_shake_duration_param como parametros

var camera_shake_trigger: bool = false #decidir cuando hacer un solo camera shake
var camera_shake_intensity_param: float = 0.0
var camera_shake_duration_param: float = 0.0
