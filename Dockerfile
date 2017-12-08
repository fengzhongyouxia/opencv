# 执行命令 docker build -t opencv:v1 .

FROM ubuntu:16.04
MAINTAINER Mr.wu

# ENV HOME /root

RUN apt-get update && \
    apt-get upgrade && \
    apt-get remove x264 libx264-dev && \
    apt-get install build-essential checkinstall cmake pkg-config yasm gfortran git && \
    apt-get install libjpeg8-dev libjasper-dev libpng12-dev && \
    apt-get install libtiff5-dev && \
    apt-get install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev && \
    apt-get install libxine2-dev libv4l-dev && \
    apt-get install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev && \
    apt-get install libqt4-dev libgtk2.0-dev libtbb-dev && \
    apt-get install libatlas-base-dev && \
    apt-get install libfaac-dev libmp3lame-dev libtheora-dev && \
    apt-get install libvorbis-dev libxvidcore-dev && \
    apt-get install libopencore-amrnb-dev libopencore-amrwb-dev && \
    apt-get install x264 v4l-utils && \
    apt-get install libprotobuf-dev protobuf-compiler && \
    apt-get install libgoogle-glog-dev libgflags-dev && \
    apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen && \
    apt-get install python-dev python-pip python3-dev python3-pip && \
    pip2 install -U pip numpy && \
    pip3 install -U pip numpy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*

RUN mkdir ~/opencv
RUN cd ~/opencv && git clone https://github.com/Itseez/opencv_contrib.git
RUN cd ~/opencv && git clone https://github.com/Itseez/opencv.git

# 如果不支持cuda，移除 -D WITH_CUDA=ON
RUN cd ~/opencv/opencv && mkdir build && cd build && \
          cmake -D CMAKE_BUILD_TYPE=RELEASE \
	  -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D INSTALL_C_EXAMPLES=ON \
          -D INSTALL_PYTHON_EXAMPLES=ON \
          -D WITH_TBB=ON \
          -D WITH_V4L=ON \
          -D WITH_QT=ON \
          -D WITH_OPENGL=ON \
          -D WITH_CUDA=ON \
          -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
          -D BUILD_EXAMPLES=ON ..

RUN cd ~/opencv/opencv/build && make -j $(nproc) && make install
RUN sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig
