#!/bin/bash

build_path=""
install_path=""
current_path=`pwd`

function cp_gtest_file() {
  cp $build_path/test_* $install_path
  cd $install_path
  for files in $(ls test_*)
    do mv $files "gtest_"$files
  done
  cd ${current_path}
  return $?
}

#ros/class_loader
mkdir install/lib/class_loader
cp build/class_loader/test/*.so install/lib/
cp build/class_loader/test/class_loader_utest install/lib/class_loader/gtest_class_loader_utest
cp build/class_loader/test/class_loader_unique_ptr_test install/lib/class_loader/gtest_class_loader_unique_ptr_test

cp build/class_loader/test/fviz_case_study/*.so install/lib
cp build/class_loader/test/fviz_case_study/class_loader_fviz_test install/lib/class_loader/gtest_class_loader_fviz_test

#ros/pluginlib
mkdir install/lib/pluginlib
cp build/pluginlib/pluginlib_unique_ptr_test install/lib/pluginlib/gtest_pluginlib_unique_ptr_test
cp build/pluginlib/pluginlib_utest install/lib/pluginlib/gtest_pluginlib_utest

#ros/resource_retriever
mkdir install/lib/resource_retriever
cp build/resource_retriever/resource_retriever_test install/lib/resource_retriever/gtest_resource_retriever_test

#ros/robot_state_publisher
mkdir install/lib/robot_state_publisher/gtest
install_path=install/lib/robot_state_publisher/gtest
build_path=build/robot_state_publisher/
cp_gtest_file
# cp ..build/robot_state_publisher/test_* install/lib/robot_state_publisher/gtest_*
# for files in $(ls build/robot_state_publisher/test_*)
#     do mv $files "gtest_"$files
# done
#for f in * ; do mv -- "$f" "PRE_$f" ; done
#for i in `ls`; do mv -f $i 'echo "gt_"$i`; done

#ros/urdfdom
# mkdir install/lib/urdfdom
cp build/urdfdom/bin/urdf_unit_test install/lib/urdfdom/gtest_urdf_unit_test

#tros/sensor_msgs
mkdir install/lib/sensor_msgs
cp build/sensor_msgs/test_sensor_msgs install/lib/sensor_msgs/gtest_test_sensor_msgs

#tros/geometry2/test_tf2
cp build/test_tf2/test_message_filter install/lib/test_tf2/gtest_test_message_filter
cp build/test_tf2/buffer_core_test install/lib/test_tf2/gtest_buffer_core_test
cp build/test_tf2/test_static_publisher install/lib/test_tf2/gtest_test_static_publisher
cp build/test_tf2/test_utils install/lib/test_tf2/gtest_test_utils

#tros/geometry2/tf2
mkdir install/lib/tf2
# cp build/tf2/test_* install/lib/tf2/gtest_*
install_path=install/lib/tf2
build_path=build/tf2
cp_gtest_file

#tros/geometry2/tf2_bullet
mkdir install/lib/tf2_bullet
cp build/tf2_bullet/test_bullet install/lib/tf2_bullet/gtest_test_bullet

#tros/geometry2/tf2_eigen
mkdir install/lib/tf2_eigen
cp build/tf2_eigen/tf2_eigen-test install/lib/tf2_eigen/gtest_tf2_eigen-test

#tros/geometry2/tf2_eigen_kdl
mkdir install/lib/tf2_eigen_kdl
cp build/tf2_eigen_kdl/tf2_eigen_kdl_test install/lib/tf2_eigen_kdl/gtest_tf2_eigen_kdl_test

#tros/geometry2/tf2_geometry_msgs
mkdir install/lib/tf2_geometry_msgs
cp build/tf2_geometry_msgs/test_tf2_geometry_msgs install/lib/tf2_geometry_msgs/gtest_test_tf2_geometry_msgs

#tros/geometry2/tf2_kdl
mkdir install/lib/tf2_kdl
cp build/tf2_kdl/test_kdl install/lib/tf2_kdl/gtest_test_kdl

#tros/geometry2/tf2_ros
cp build/tf2_ros/test_buffer install/lib/tf2_ros/gtest_test_buffer
cp build/tf2_ros/test_buffer_client install/lib/tf2_ros/gtest_test_buffer_client
cp build/tf2_ros/test_buffer_server install/lib/tf2_ros/gtest_test_buffer_server
cp build/tf2_ros/tf2_ros_test_listener install/lib/tf2_ros/gtest_tf2_ros_test_listener
cp build/tf2_ros/tf2_ros_test_message_filter install/lib/tf2_ros/gtest_tf2_ros_test_message_filter
cp build/tf2_ros/tf2_ros_test_static_transform_broadcaster install/lib/tf2_ros/gtest_tf2_ros_test_static_transform_broadcaster
cp build/tf2_ros/tf2_ros_test_time_reset install/lib/tf2_ros/gtest_tf2_ros_test_time_reset
cp build/tf2_ros/tf2_ros_test_transform_broadcaster install/lib/tf2_ros/gtest_tf2_ros_test_transform_broadcaster
cp build/tf2_ros/tf2_ros_test_transform_listener install/lib/tf2_ros/gtest_tf2_ros_test_transform_listener

#tros/launch/test_launch_testing
mkdir install/lib/test_launch_testing
cp build/test_launch_testing/dummy install/lib/test_launch_testing/gtest_dummy
# this case is block
# cp build/test_launch_testing/locking install/lib/test_launch_testing/gtest_locking

#tros/libyaml_vendor
mkdir install/lib/libyaml_vendor
cp build/libyaml_vendor/test_yaml_reader install/lib/libyaml_vendor/gtest_test_yaml_reader

#tros/message_filters
mkdir install/lib/message_filters
cp build/message_filters/message_filters-msg_cache_unittest install/lib/message_filters/gtest_message_filters-msg_cache_unittest
cp build/message_filters/message_filters-test_approximate_time_policy install/lib/message_filters/gtest_message_filters-test_approximate_time_policy
cp build/message_filters/message_filters-test_chain install/lib/message_filters/gtest_message_filters-test_chain
cp build/message_filters/message_filters-test_exact_time_policy install/lib/message_filters/gtest_message_filters-test_exact_time_policy
cp build/message_filters/message_filters-test_fuzz install/lib/message_filters/gtest_message_filters-test_fuzz
cp build/message_filters/message_filters-test_simple install/lib/message_filters/gtest_message_filters-test_simple
cp build/message_filters/message_filters-test_subscriber install/lib/message_filters/gtest_message_filters-test_subscriber
cp build/message_filters/message_filters-test_synchronizer install/lib/message_filters/gtest_message_filters-test_synchronizer
cp build/message_filters/message_filters-test_time_sequencer install/lib/message_filters/gtest_message_filters-test_time_sequencer
cp build/message_filters/message_filters-time_synchronizer_unittest install/lib/message_filters/gtest_message_filters-time_synchronizer_unittest

#tros/rcl/
mkdir install/lib/rcl
cp build/rcl/test/test_client__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_client__rmw_cyclonedds_cpp
cp build/rcl/test/test_client__rmw_fastrtps_cpp install/lib/rcl/gtest_test_client__rmw_fastrtps_cpp
cp build/rcl/test/test_client__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_client__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_time__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_time__rmw_cyclonedds_cpp
cp build/rcl/test/test_time__rmw_fastrtps_cpp install/lib/rcl/gtest_test_time__rmw_fastrtps_cpp
cp build/rcl/test/test_time__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_time__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_timer__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_timer__rmw_cyclonedds_cpp
cp build/rcl/test/test_timer__rmw_fastrtps_cpp install/lib/rcl/gtest_test_timer__rmw_fastrtps_cpp
cp build/rcl/test/test_timer__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_timer__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_context__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_context__rmw_cyclonedds_cpp
cp build/rcl/test/test_context__rmw_fastrtps_cpp install/lib/rcl/gtest_test_context__rmw_fastrtps_cpp
cp build/rcl/test/test_context__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_context__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_get_node_names__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_get_node_names__rmw_cyclonedds_cpp
cp build/rcl/test/test_get_node_names__rmw_fastrtps_cpp install/lib/rcl/gtest_test_get_node_names__rmw_fastrtps_cpp
cp build/rcl/test/test_get_node_names__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_get_node_names__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_lexer__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_lexer__rmw_cyclonedds_cpp
cp build/rcl/test/test_lexer__rmw_fastrtps_cpp install/lib/rcl/gtest_test_lexer__rmw_fastrtps_cpp
cp build/rcl/test/test_lexer__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_lexer__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_lexer_lookahead__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_lexer_lookahead__rmw_cyclonedds_cpp
cp build/rcl/test/test_lexer_lookahead__rmw_fastrtps_cpp install/lib/rcl/gtest_test_lexer_lookahead__rmw_fastrtps_cpp
cp build/rcl/test/test_lexer_lookahead__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_lexer_lookahead__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_graph__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_graph__rmw_cyclonedds_cpp
cp build/rcl/test/test_graph__rmw_fastrtps_cpp install/lib/rcl/gtest_test_graph__rmw_fastrtps_cpp
cp build/rcl/test/test_graph__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_graph__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_info_by_topic__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_info_by_topic__rmw_cyclonedds_cpp
cp build/rcl/test/test_info_by_topic__rmw_fastrtps_cpp install/lib/rcl/gtest_test_info_by_topic__rmw_fastrtps_cpp
cp build/rcl/test/test_info_by_topic__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_info_by_topic__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_count_matched__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_count_matched__rmw_cyclonedds_cpp
cp build/rcl/test/test_count_matched__rmw_fastrtps_cpp install/lib/rcl/gtest_test_count_matched__rmw_fastrtps_cpp
cp build/rcl/test/test_count_matched__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_count_matched__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_get_actual_qos__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_get_actual_qos__rmw_cyclonedds_cpp
cp build/rcl/test/test_get_actual_qos__rmw_fastrtps_cpp install/lib/rcl/gtest_test_get_actual_qos__rmw_fastrtps_cpp
cp build/rcl/test/test_get_actual_qos__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_get_actual_qos__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_init__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_init__rmw_cyclonedds_cpp
cp build/rcl/test/test_init__rmw_fastrtps_cpp install/lib/rcl/gtest_test_init__rmw_fastrtps_cpp
cp build/rcl/test/test_init__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_init__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_node__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_node__rmw_cyclonedds_cpp
cp build/rcl/test/test_node__rmw_fastrtps_cpp install/lib/rcl/gtest_test_node__rmw_fastrtps_cpp
cp build/rcl/test/test_node__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_node__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_arguments__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_arguments__rmw_cyclonedds_cpp
cp build/rcl/test/test_arguments__rmw_fastrtps_cpp install/lib/rcl/gtest_test_arguments__rmw_fastrtps_cpp
cp build/rcl/test/test_arguments__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_arguments__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_remap__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_remap__rmw_cyclonedds_cpp
cp build/rcl/test/test_remap__rmw_fastrtps_cpp install/lib/rcl/gtest_test_remap__rmw_fastrtps_cpp
cp build/rcl/test/test_remap__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_remap__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_remap_integration__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_remap_integration__rmw_cyclonedds_cpp
cp build/rcl/test/test_remap_integration__rmw_fastrtps_cpp install/lib/rcl/gtest_test_remap_integration__rmw_fastrtps_cpp
cp build/rcl/test/test_remap_integration__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_remap_integration__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_guard_condition__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_guard_condition__rmw_cyclonedds_cpp
cp build/rcl/test/test_guard_condition__rmw_fastrtps_cpp install/lib/rcl/gtest_test_guard_condition__rmw_fastrtps_cpp
cp build/rcl/test/test_guard_condition__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_guard_condition__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_publisher__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_publisher__rmw_cyclonedds_cpp
cp build/rcl/test/test_publisher__rmw_fastrtps_cpp install/lib/rcl/gtest_test_publisher__rmw_fastrtps_cpp
cp build/rcl/test/test_publisher__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_publisher__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_service__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_service__rmw_cyclonedds_cpp
cp build/rcl/test/test_service__rmw_fastrtps_cpp install/lib/rcl/gtest_test_service__rmw_fastrtps_cpp
cp build/rcl/test/test_service__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_service__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_subscription__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_subscription__rmw_cyclonedds_cpp
cp build/rcl/test/test_subscription__rmw_fastrtps_cpp install/lib/rcl/gtest_test_subscription__rmw_fastrtps_cpp
cp build/rcl/test/test_subscription__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_subscription__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_events__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_events__rmw_cyclonedds_cpp
cp build/rcl/test/test_events__rmw_fastrtps_cpp install/lib/rcl/gtest_test_events__rmw_fastrtps_cpp
cp build/rcl/test/test_events__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_events__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_wait__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_wait__rmw_cyclonedds_cpp
cp build/rcl/test/test_wait__rmw_fastrtps_cpp install/lib/rcl/gtest_test_wait__rmw_fastrtps_cpp
cp build/rcl/test/test_wait__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_wait__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_logging_rosout__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_logging_rosout__rmw_cyclonedds_cpp
cp build/rcl/test/test_logging_rosout__rmw_fastrtps_cpp install/lib/rcl/gtest_test_logging_rosout__rmw_fastrtps_cpp
cp build/rcl/test/test_logging_rosout__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_logging_rosout__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_namespace__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_namespace__rmw_cyclonedds_cpp
cp build/rcl/test/test_namespace__rmw_fastrtps_cpp install/lib/rcl/gtest_test_namespace__rmw_fastrtps_cpp
cp build/rcl/test/test_namespace__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_namespace__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_rmw_impl_id_check_func__rmw_cyclonedds_cpp install/lib/rcl/gtest_test_rmw_impl_id_check_func__rmw_cyclonedds_cpp
cp build/rcl/test/test_rmw_impl_id_check_func__rmw_fastrtps_cpp install/lib/rcl/gtest_test_rmw_impl_id_check_func__rmw_fastrtps_cpp
cp build/rcl/test/test_rmw_impl_id_check_func__rmw_fastrtps_dynamic_cpp install/lib/rcl/gtest_test_rmw_impl_id_check_func__rmw_fastrtps_dynamic_cpp
cp build/rcl/test/test_validate_enclave_name install/lib/rcl/gtest_test_validate_enclave_name
cp build/rcl/test/test_domain_id install/lib/rcl/gtest_test_domain_id
cp build/rcl/test/test_localhost install/lib/rcl/gtest_test_localhost
cp build/rcl/test/test_logging install/lib/rcl/gtest_test_logging
cp build/rcl/test/test_validate_topic_name install/lib/rcl/gtest_test_validate_topic_name
cp build/rcl/test/test_expand_topic_name install/lib/rcl/gtest_test_expand_topic_name
cp build/rcl/test/test_security install/lib/rcl/gtest_test_security
cp build/rcl/test/test_common install/lib/rcl/gtest_test_common

#tros/rcl/rcl_action
#mkdir install/lib/rcl_action
mkdir install/lib/rcl_action
install_path=install/lib/rcl_action
build_path=build/rcl_action
cp_gtest_file

#tros/rcl/rcl_lifecycle
mkdir install/lib/rcl_lifecycle
install_path=install/lib/rcl_lifecycle
build_path=build/rcl_lifecycle/
cp_gtest_file
# cp build/rcl_lifecycle/test_* install/lib/rcl_lifecycle
# cd install/lib/rcl_lifecycle
# for files in $(ls test_*)
#     do mv $files "gtest_"$files
# done
# cd ../../../

#tros/rcl/rcl_yaml_param_parser
mkdir install/lib/rcl_yaml_param_parser
install_path=install/lib/rcl_yaml_param_parser
build_path=build/rcl_yaml_param_parser
cp_gtest_file

#tros/rcl_interfaces/test_msgs
mkdir install/lib/test_msgs
cp build/test_msgs/test_action_typesupport_c_builds install/lib/test_msgs/gtest_test_action_typesupport_c_builds
cp build/test_msgs/test_action_typesupport_cpp_builds install/lib/test_msgs/gtest_test_action_typesupport_cpp_builds

#tros/rcl_logging/rcl_logging_spdlog
mkdir install/lib/rcl_logging_spdlog
cp build/rcl_logging_spdlog/test_logging_interface install/lib/rcl_logging_spdlog/gtest_test_logging_interface

#tros/rclcpp/rclcpp
mkdir install/lib/rclcpp
cp build/rclcpp/test/test_rclcpp_gtest_macros install/lib/rclcpp/gtest_test_rclcpp_gtest_macros
cp build/rclcpp/test/rclcpp/*.so install/lib
build_path=build/rclcpp/test/rclcpp
install_path=install/lib/rclcpp
cp_gtest_file

#tros/rclcpp/rclcpp_action
mkdir install/lib/rclcpp_action
build_path=build/rclcpp_action
install_path=install/lib/rclcpp_action
cp_gtest_file

#tros/rclcpp/rclcpp_components
cp build/rclcpp_components/test_component_manager install/lib/rclcpp_components/gtest_test_component_manager
cp build/rclcpp_components/test_component_manager_api install/lib/rclcpp_components/gtest_test_component_manager_api

#tros/rclcpp/rclcpp_lifecycle
mkdir install/lib/rclcpp_lifecycle
build_path=build/rclcpp_lifecycle
install_path=install/lib/rclcpp_lifecycle
cp_gtest_file

#tros/rclpy/rclpy
mkdir install/lib/rclpy
cp build/rclpy/test_c_handle install/lib/rclpy/gtest_test_c_handle

#tros/rcpputils
mkdir install/lib/rcpputils
build_path=build/rcpputils
install_path=install/lib/rcpputils
cp_gtest_file

#tros/rcutils
mkdir install/lib/rcutils
build_path=build/rcutils
install_path=install/lib/rcutils
cp_gtest_file

#tros/realtime_support/rttest
mkdir install/lib/rttest
cp build/rttest/gtest_rttest_api install/lib/rttest/

#tros/realtime_support/tlsf_cpp
mkdir install/lib/tlsf_cpp
cp build/tlsf_cpp/test_tlsf__rmw_cyclonedds_cpp install/lib/tlsf_cpp/gtest_test_tlsf__rmw_cyclonedds_cpp
cp build/tlsf_cpp/test_tlsf__rmw_fastrtps_cpp install/lib/tlsf_cpp/gtest_test_tlsf__rmw_fastrtps_cpp
cp build/tlsf_cpp/test_tlsf__rmw_fastrtps_dynamic_cpp install/lib/tlsf_cpp/gtest_test_tlsf__rmw_fastrtps_dynamic_cpp

#tros/rmw/rmw
mkdir install/lib/rmw
build_path=build/rmw/test
install_path=install/lib/rmw
cp_gtest_file

#tros/rmw_dds_common/rmw_dds_common
mkdir install/lib/rmw_dds_common
cp build/rmw_dds_common/test_gid_utils install/lib/rmw_dds_common/gtest_test_gid_utils
cp build/rmw_dds_common/test_graph_cache install/lib/rmw_dds_common/gtest_test_graph_cache

#tros/rmw_fastrtps/rmw_fastrtps_cpp
mkdir install/lib/rmw_fastrtps_cpp
cp build/rmw_fastrtps_cpp/test_get_native_entities install/lib/rmw_fastrtps_cpp/gtest_test_get_native_entities
cp build/rmw_fastrtps_cpp/test_logging install/lib/rmw_fastrtps_cpp/gtest_test_logging

#tros/rmw_fastrtps/rmw_fastrtps_dynamic_cpp
mkdir install/lib/rmw_fastrtps_dynamic_cpp
cp build/rmw_fastrtps_dynamic_cpp/test_get_native_entities install/lib/rmw_fastrtps_dynamic_cpp/gtest_test_get_native_entities
cp build/rmw_fastrtps_dynamic_cpp/test_logging install/lib/rmw_fastrtps_dynamic_cpp/gtest_test_logging

#tros/rmw_fastrtps/rmw_fastrtps_shared_cpp
mkdir install/lib/rmw_fastrtps_shared_cpp
build_path=build/rmw_fastrtps_shared_cpp/test
install_path=install/lib/rmw_fastrtps_shared_cpp
cp_gtest_file

#tros/rosbag2/rosbag2_compression
mkdir install/lib/rosbag2_compression
cp build/rosbag2_compression/*.so install/lib/
build_path=build/rosbag2_compression
install_path=install/lib/rosbag2_compression
cp_gtest_file

#tros/rosbag2/rosbag2_converter_default_plugins
mkdir install/lib/rosbag2_converter_default_plugins
cp build/rosbag2_converter_default_plugins/test_cdr_converter install/lib/rosbag2_converter_default_plugins/gtest_test_cdr_converter

#tros/rosbag2/rosbag2_cpp
mkdir install/lib/rosbag2_cpp
cp build/rosbag2_cpp/*.so install/lib
build_path=build/rosbag2_cpp/
install_path=install/lib/rosbag2_cpp
cp_gtest_file

#tros/rosbag2/rosbag2_storage
mkdir install/lib/rosbag2_storage
cp build/rosbag2_storage/*.so install/lib/
build_path=build/rosbag2_storage
install_path=install/lib/rosbag2_storage
cp_gtest_file

#tros/rosbag2/rosbag2_storage_default_plugins
mkdir install/lib/rosbag2_storage_default_plugins
cp build/rosbag2_storage_default_plugins/test_sqlite_storage install/lib/rosbag2_storage_default_plugins/gtest_test_sqlite_storage
cp build/rosbag2_storage_default_plugins/test_sqlite_wrapper install/lib/rosbag2_storage_default_plugins/gtest_test_sqlite_wrapper

#tros/rosbag2/rosbag2_tests
mkdir install/lib/rosbag2_tests
build_path=build/rosbag2_tests
install_path=install/lib/rosbag2_tests
cp_gtest_file
rm install/lib/rosbag2_tests/gtest_test_rosbag2_play_end_to_end # this case is block

#tros/rosbag2/rosbag2_transport
mkdir install/lib/rosbag2_transport
build_path=build/rosbag2_transport
install_path=install/lib/rosbag2_transport
cp_gtest_file

#tros/rosidl/rosidl_generator_cpp
mkdir install/lib/rosidl_generator_cpp
build_path=build/rosidl_generator_cpp
install_path=install/lib/rosidl_generator_cpp
cp_gtest_file

#tros/rosidl/rosidl_runtime_cpp
mkdir install/lib/rosidl_runtime_cpp
build_path=build/rosidl_runtime_cpp
install_path=install/lib/rosidl_runtime_cpp
cp_gtest_file

#tros/rosidl/rosidl_typesupport_interface
mkdir install/lib/rosidl_typesupport_interface
cp build/rosidl_typesupport_interface/test_macros install/lib/rosidl_typesupport_interface/gtest_test_macros

#tros/rosidl_typesupport/rosidl_typesupport_c
# mkdir install/lib/rosidl_typesupport_c
cp build/rosidl_typesupport_c/test_libs/*.so install/lib
cp build/rosidl_typesupport_c/test_message_type_support install/lib/rosidl_typesupport_c/gtest_test_message_type_support
cp build/rosidl_typesupport_c/test_service_type_support install/lib/rosidl_typesupport_c/gtest_test_service_type_support

#tros/rosidl_typesupport/rosidl_typesupport_cpp
cp build/rosidl_typesupport_cpp/test_libs/*.so install/lib
cp build/rosidl_typesupport_cpp/test_message_type_support install/lib/rosidl_typesupport_cpp/gtest_test_message_type_support
cp build/rosidl_typesupport_cpp/test_service_type_support install/lib/rosidl_typesupport_cpp/gtest_test_service_type_support

#tros/rosidl_typesupport_fastrtps/rosidl_typesupport_fastrtps_c
cp build/rosidl_typesupport_fastrtps_c/test_wstring_conversion install/lib/rosidl_typesupport_fastrtps_c/gtest_test_wstring_conversion
cp build/rosidl_typesupport_fastrtps_c/test_wstring_conversion_mem install/lib/rosidl_typesupport_fastrtps_c/gtest_test_wstring_conversion_mem

#tros/rosidl_typesupport_fastrtps/rosidl_typesupport_fastrtps_cpp
cp build/rosidl_typesupport_fastrtps_cpp/test_wstring_conversion install/lib/rosidl_typesupport_fastrtps_cpp/gtest_test_wstring_conversion
cp build/rosidl_typesupport_fastrtps_cpp/test_wstring_conversion_mem install/lib/rosidl_typesupport_fastrtps_cpp/gtest_test_wstring_conversion_mem

#tros/system_tests/test_communication
mkdir install/lib/test_communication
build_path=build/test_communication
install_path=install/lib/test_communication
cp ${build_path}/*.so install/lib
cp ${build_path}/test_messages_c__rmw_cyclonedds_cpp ${install_path}/gtest_test_messages_c__rmw_cyclonedds_cpp
cp ${build_path}/test_messages_c__rmw_fastrtps_cpp ${install_path}/gtest_test_messages_c__rmw_fastrtps_cpp
cp ${build_path}/test_messages_c__rmw_fastrtps_dynamic_cpp ${install_path}/gtest_test_messages_c__rmw_fastrtps_dynamic_cpp
cp ${build_path}/test_publisher_subscriber_serialized__rmw_cyclonedds_cpp ${install_path}/gtest_test_publisher_subscriber_serialized__rmw_cyclonedds_cpp
cp ${build_path}/test_publisher_subscriber_serialized__rmw_fastrtps_cpp ${install_path}/gtest_test_publisher_subscriber_serialized__rmw_fastrtps_cpp
cp ${build_path}/test_publisher_subscriber_serialized__rmw_fastrtps_dynamic_cpp ${install_path}/gtest_test_publisher_subscriber_serialized__rmw_fastrtps_dynamic_cpp
cp ${build_path}/test_serialize__rmw_cyclonedds_cpp ${install_path}/gtest_test_serialize__rmw_cyclonedds_cpp
cp ${build_path}/test_serialize__rmw_fastrtps_cpp ${install_path}/gtest_test_serialize__rmw_fastrtps_cpp
cp ${build_path}/test_serialize__rmw_fastrtps_dynamic_cpp ${install_path}/gtest_test_serialize__rmw_fastrtps_dynamic_cpp

#tros/system_tests/test_quality_of_service

#tros/system_tests/test_rclcpp
cp build/test_rclcpp/*.so install/lib
mkdir install/lib/test_rclcpp
cp build/test_rclcpp/gtest_* install/lib/test_rclcpp

