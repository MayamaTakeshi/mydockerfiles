FROM mayamatakeshi/base-dev-bullseye:1.0.0

LABEL repo_url = https://github.com/MayamaTakeshi/mydockerfiles

SHELL ["/bin/bash", "--login", "-c"]

# creating folder for src 
RUN mkdir -p /usr/local/src/git


RUN <<EOF

echo building/installing libks
cd /usr/local/src/git
rm -fr libks
git clone https://github.com/signalwire/libks
cd libks
git checkout 0e9ebc75812c2d73263d06a3ef11f7fedb762133
cmake . -DCMAKE_INSTALL_PREFIX=/usr -DWITH_LIBBACKTRACE=1
make install

EOF

RUN <<EOF

echo building/installing sofia-sip
cd /usr/local/src/git
rm -fr sofia-sip
git clone https://github.com/freeswitch/sofia-sip
cd sofia-sip
git checkout 1fef149e81414f3cd4d7651eb399ce4ffaee878b
./bootstrap.sh
./configure CFLAGS="-g -ggdb" --with-pic --with-glib=no --without-doxygen --disable-stun
make -j`nproc --all`
make install

EOF

RUN <<EOF

echo building/installing spandsp
cd /usr/local/src/git
rm -fr spandsp
git clone https://github.com/freeswitch/spandsp
cd spandsp
git checkout e59ca8fb8b1591e626e6a12fdc60a2ebe83435ed
./bootstrap.sh
./configure CFLAGS="-g -ggdb" --with-pic
make -j`nproc --all`
make install

EOF

RUN <<EOF

echo building/installing signalwire-c
cd /usr/local/src/git
rm -fr signalwire-c
git clone https://github.com/signalwire/signalwire-c
cd signalwire-c
git checkout 03827ee3c4834b21b0b5c67027eed3cc009be0ce
PKG_CONFIG_PATH=/usr/lib/pkgconfig cmake . -DCMAKE_INSTALL_PREFIX=/usr
make install

EOF

RUN <<EOF

echo buiding/installing freeswitch
cd /usr/local/src/git
git clone https://github.com/signalwire/freeswitch
cd freeswitch
git checkout dd2411336fbb17be120801f8d26cfed01e0e6740


cat > /usr/local/src/git/freeswitch/modules.conf <<END_OF_LINE
loggers/mod_console
loggers/mod_logfile
loggers/mod_syslog
applications/mod_commands
applications/mod_conference
applications/mod_dptools
applications/mod_enum
applications/mod_fifo
applications/mod_curl
applications/mod_db
applications/mod_hash
applications/mod_voicemail
applications/mod_directory
applications/mod_limit
applications/mod_expr
applications/mod_esf
applications/mod_spandsp
applications/mod_spy
applications/mod_cluechoo
applications/mod_valet_parking
applications/mod_httapi
codecs/mod_g723_1
codecs/mod_amr
codecs/mod_amrwb
codecs/mod_g729
codecs/mod_h26x
codecs/mod_celt
codecs/mod_opus
codecs/mod_isac
dialplans/mod_dialplan_xml
dialplans/mod_dialplan_asterisk
endpoints/mod_sofia
endpoints/mod_loopback
endpoints/mod_verto
asr_tts/mod_unimrcp
asr_tts/mod_flite
asr_tts/mod_pocketsphinx
event_handlers/mod_event_socket
event_handlers/mod_cdr_csv
formats/mod_native_file
formats/mod_sndfile
formats/mod_shout
formats/mod_local_stream
formats/mod_tone_stream
formats/mod_shell_stream
xml_int/mod_xml_rpc
xml_int/mod_xml_curl
xml_int/mod_xml_cdr
say/mod_say_en
say/mod_say_ja
say/mod_say_de
say/mod_say_es
say/mod_say_fr
say/mod_say_it
say/mod_say_nl
say/mod_say_ru
say/mod_say_zh
say/mod_say_hu
say/mod_say_th
databases/mod_mariadb

END_OF_LINE

./bootstrap.sh -j
./configure -C
make -j`nproc`
make install
ldconfig

EOF

RUN <<EOF

echo installing freeswitch extras
for cmd in "sounds-install" "make moh-install" "make samples";
do
	echo "Executing '$cmd'"
	cd /usr/local/src/git/freeswitch

	$cmd 2> temp_result #redirect strerr to temp_result

	set +o errexit
	grep -i "[^\.\t_ ]error[^\.\t_ ]" temp_result #check if there is error in temp_result
	result=$?
	set -o errexit
        if [[ $result == 1 ]]
        then
		echo "Call to grep failed because of no match (no string "error" in temp_result. So cmd='$cmd' was successful"
                echo "OK"
        else
		echo "String error was found in file temp_result"
		exit 1;
        fi
done

EOF

RUN <<EOF
cat > /usr/local/freeswitch/conf/autoload_configs/pre_load_modules.conf.xml <<END_OF_LINE
<configuration name="pre_load_modules.conf" description="Modules">
  <modules>
    <load module="mod_mariadb"/>
  </modules>
</configuration>
END_OF_LINE
EOF

RUN <<EOF
  cd /usr/local/src/git/
  git clone https://github.com/amigniter/mod_audio_stream
  cd mod_audio_stream
  git checkout b261b06bd35b5614f052f7fdd2fedea2100af731
  git submodule init
  git submodule update
  export PKG_CONFIG_PATH=/usr/local/freeswitch/lib/pkgconfig # adjust if necessary
  mkdir build && cd build
  cmake -DCMAKE_BUILD_TYPE=Release ..
  make
  sudo make install
EOF

CMD ["tail", "-f", "/dev/null"]

