# Changelog for TogetherROS

v1.0.5 (2022-08-26)
------------------

  1. hobot_dnn，example示例修复发布的ROS Msg中算法推理输出帧率数据错误的问题。
  2. parking_perception，新增用于停车场场景的算法示例，支持行人、汽车、停车地锁等目标检测，以及道路、车道线、车位区域等语义分割。
  3. hobot_image_publisher，新增本地图片发布工具，可用于算法测评。
  4. hobot_cv，新增neon加速高斯滤波和均值滤波功能。
  5. hobot_codec，修复发布的bgr8和rgb8格式图片消息中step参数错误导致的图片无法展示的问题。
  6. mono2d_body_detection，支持启动时选择使用MIPI/USB类型摄像头；修复发布的ROS Msg中算法推理输出帧率数据错误的问题。
  7. hand_lmk_detection，支持启动时选择使用MIPI/USB类型摄像头；修复rqt_graph工具展示的Node graph不连续的问题。
  8. hand_gesture_detection，支持启动时选择使用MIPI/USB类型摄像头；修复特定场景下发布的ROS Msg中算法推理输出帧率数据错误的问题。

v1.0.4 (2022-08-18)
------------------

  1. hobot_dnn，升级预测库，修复偶现算法推理输出异常的问题，以及加密芯片访问报错的问题
  3. audio_control，更新说明文档中的唤醒词说明
  4. hobot_hdmi，增加启动的launch文件，更新文档
  5. hobot_sensor，优化NV转RGB效率，更新RGBD驱动
  6. ORB SLAM3，新增v-slam功能
  7. lttng，新增trace工具lttng支持

v1.0.3 (2022-07-29)
------------------

  1. ros-perception,增加ROS2 vision_opencv适配
  3. hobot_audio，优化识别效果，更换配置默认唤醒词“精灵精灵”为“地平线你好”
  4. hobotcv，新增图片rotate，crop&resize&rotate接口
  5. hobot_sensor，优化NV转RGB效率，更新RGBD驱动

v1.0.2 (2022-07-17)
------------------

  1. mono2d_body_detection，人体关键点感知结果中增加置信度信息
  2. audio_control，增加语音控制小车运动功能
  3. hobot_audio，增加语音识别功能
  4. hobot_websocket，优化显示卡顿，解决偶现加载失败问题
  5. hobot_msgs，更新Point.msg，增加audio_msg

v1.0.1 (2022-06-23)
------------------
  1. HobotWebsocket，修复偶现内存泄漏问题
  2. HobotCodec，优化CPU占用
  3. 新增HobotHDMI功能，支持HDMI屏显展示
  4. mono2d_body_detection，更新性能统计方式，优化Log输出
  5. hand_lmk_detection，修复内存泄漏，优化推理性能
  6. hand_gesture_detection，解决画面中有多个人手的情况下部分人手无手势结果输出的问题，优化推理性能
  7. HobotDNN，优化异步推理性能，增加性能统计
  8. HobotCV，优化Log输出方式
  9. HobotSensor，修复rgbd sensor通过shared mem通信方式发布消息失败问题
 
