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
cd build
ninja
```

