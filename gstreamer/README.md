# Working with gstreamer on a docker container

## Create the image:
```
./build_image.sh
```

## Checkout gstreamer source code somewhere:
```
git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git
```

## Start the container passing the path to the gstreamer cloned repo
```
./start_container.sh PATH_TO_GSTREAMER_SOURCE_FOLDER
```

## Build gstreamer
Inside the container do:
```
cd ~/src/gstreamer
meson build
ninja -C build
```

## To prepare an env for use of gst
```
ninja -C build devenv
```

After the above, you can try things like:
```
gst-launch-1.0 -v videotestsrc pattern=snow ! video/x-raw,width=1280,height=720 ! autovideosink
```

However, they will not show anything as you are running on a container:
```
takeshi@2ba32eebeca9:~/gstreamer$ ninja -C build devenv
ninja: Entering directory `build'
[0/1] Running external command devenv (wrapped by meson to set env)
$ 

$ gst-launch-1.0 -v videotestsrc pattern=snow ! video/x-raw,width=1280,height=720 ! autovideosink
Fontconfig error: Cannot load default config file: No such file: (null)
Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...
WARNING: from element /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0: Resource not found.
Additional debug info:
../subprojects/gst-plugins-good/gst/autodetect/gstautodetect.c(343): gst_auto_detect_find_best (): /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0:
Failed to find a usable video sink
/GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0.GstPad:src: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
/GstPipeline:pipeline0/GstCapsFilter:capsfilter0.GstPad:src: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0.GstGhostPad:sink.GstProxyPad:proxypad0: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstFakeSink:fake-video-sink.GstPad:sink: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0.GstGhostPad:sink: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
/GstPipeline:pipeline0/GstCapsFilter:capsfilter0.GstPad:sink: caps = video/x-raw, format=(string)ABGR64_LE, width=(int)1280, height=(int)720, framerate=(fraction)30/1, multiview-mode=(string)mono, pixel-aspect-ratio=(fraction)1/1, interlace-mode=(string)progressive
Pipeline is PREROLLED ...
Setting pipeline to PLAYING ...
Redistribute latency...
New clock: GstSystemClock
^Chandling interrupt.
Interrupt: Stopping pipeline ...
Execution ended after 0:00:02.232820837
Setting pipeline to NULL ...
Freeing pipeline ...
$ 
```

So you would need to setup a remote gst sink in the host machine to see whatever it is being streamed.

## To make changes

As explained here:
  https://www.collabora.com/news-and-blog/blog/2020/03/19/getting-started-with-gstreamer-gst-build/

You can do something like this to test:
```
vim subprojects/gst-plugins-base/gst/videotestsrc/gstvideotestsrc.c
#Go to the method gst_video_test_src_start and add the line:

GST_ERROR_OBJECT (src, ""Starting to debug videotestsrc, is there an error ?");
#This will add a runtime log with the ERROR level. For more information about debugging facilities in GStreamer, visit the following page.

# save the changes

# build with
ninja -C build
```

