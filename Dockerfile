FROM ros:indigo

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-indigo-catkin \
	&& rm -rf /var/lib/apt/lists

RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh	

RUN apt-get update && apt-get install -y \
	libeigen3-dev \
	build-essential software-properties-common \
	&& rm -rf /var/lib/apt/lists	

RUN mkdir -p projects/tracking/src \
	&& cd projects/tracking/src \
	&& git clone https://github.com/filtering-library/fl.git \
	&& git clone https://github.com/bayesian-object-tracking/dbot.git \
	&& git clone https://github.com/bayesian-object-tracking/dbot_ros_msgs.git \
	&& git clone https://github.com/bayesian-object-tracking/dbot_ros.git
	
RUN source /ros_entrypoint.sh \
	&& cd projects/tracking \
	&& catkin_make -DCMAKE_BUILD_TYPE=Release -DDBOT_BUILD_GPU=Off
