FROM nvidia/opengl:1.0-glvnd-devel-ubuntu14.04

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
    tzdata \
    lsb-release \
    gnupg \
 && ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get clean

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
 && apt-get update \
 && apt-get install -y \
    ros-indigo-desktop-full \
 && rosdep init \
 && apt-get clean

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-indigo-catkin

RUN rm -rf /var/lib/apt/lists

RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh	

RUN apt-get update && apt-get install -y \
	libeigen3-dev \
	build-essential software-properties-common \
	&& rm -rf /var/lib/apt/lists	

RUN apt-get update && apt-get install -y \
	ros-indigo-cv-bridge ros-indigo-image-transport \
	ros-indigo-interactive-markers ros-indigo-cmake-modules \
	libyaml-cpp-dev ros-indigo-rviz \
	&& rm -rf /var/lib/apt/lists	

RUN mkdir -p projects/tracking/src \
	&& cd projects/tracking/src \
	&& git clone https://github.com/filtering-library/fl.git \
	&& git clone https://github.com/ICRA2017/dbot.git \
	&& git clone https://github.com/ICRA2017/dbot_ros_msgs.git \
	&& git clone https://github.com/ICRA2017/dbot_ros.git
	
RUN source /opt/ros/indigo/setup.bash \
	&& cd projects/tracking \
	&& catkin_make -DCMAKE_BUILD_TYPE=Release -DDBOT_BUILD_GPU=On

RUN cd projects/tracking/src \
	&& git clone https://git-amd.tuebingen.mpg.de/open-source/dbot_getting_started.git

RUN source /opt/ros/indigo/setup.bash \
	&& cd projects/tracking \
	&& catkin_make -DCMAKE_BUILD_TYPE=Release -DDBOT_BUILD_GPU=On

CMD ["roslaunch", "dbot_example", "launch_example_gpu.launch"]
