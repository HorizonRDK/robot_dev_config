# Changelog for Horizon Hobot Platform

v1.0.2 (2022-07-17)
------------------
- Apps

    无

- Boxs
    1. mono2d_body_detection，人体关键点感知结果中增加置信度信息
    2. audio_control，增加语音控制小车运动功能
    3. hobot_audio，增加语音识别功能
    4. hobot_websocket，优化显示卡顿，解决偶现加载失败问题
    5. hobot_msgs，更新Point.msg，增加audio_msg

- TogetherROS
    无

v1.0.1 (2022-06-23)
------------------
- Apps

    无

- Boxs
    1. HobotWebsocket，修复偶现内存泄漏问题
    2. HobotCodec，优化CPU占用
    3. 新增HobotHDMI功能，支持HDMI屏显展示
    4. mono2d_body_detection，更新性能统计方式，优化Log输出
    5. hand_lmk_detection，修复内存泄漏，优化推理性能
    6. hand_gesture_detection，解决画面中有多个人手的情况下部分人手无手势结果输出的问题，优化推理性能

- TogetherROS
    1. HobotDNN，优化异步推理性能，增加性能统计
    2. HobotCV，优化Log输出方式
    3. HobotSensor，修复rgbd sensor通过shared mem通信方式发布消息失败问题
 
