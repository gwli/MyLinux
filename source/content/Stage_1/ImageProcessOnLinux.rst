#. eog  gnome image player.
#. ImageMagic   
   * display 显示
   * import  截图
#. ffmpeg 可以打录摄像头。
   *　ffmpeg -video_size 1024x768 -framerate 25 -f x11grab -i :0.0+100,200 output.mp4　https://trac.ffmpeg.org/wiki/Capture/Desktop
#. 或者使用gstreamer :gst-launch-1.0 ximagesrc startx=1280 use-damage=0 ! video/x-raw,framerate=30/1 ! videoscale method=0 ! video/x-raw,width=640,height=480  ! ximagesink
