----------------------------------------------
2022/09/14 takeshi:

I prepared the Dockerfile and it successfully built unimrcp and swig-wrapper.
But when I tried to test with the Python sample I got:

```
root@e74c71dca30e:~/src/git/swig-wrapper/Python# PYTHONPATH=wrapper ./UniSynth.py "The text to synthesize..."
Traceback (most recent call last):
  File "./UniSynth.py", line 20, in <module>
    from UniMRCP import *
  File "/root/src/git/swig-wrapper/Python/wrapper/UniMRCP.py", line 28, in <module>
    _UniMRCP = swig_import_helper()
  File "/root/src/git/swig-wrapper/Python/wrapper/UniMRCP.py", line 20, in swig_import_helper
    import _UniMRCP
ImportError: /usr/local/unimrcp/lib/libunimrcpclient.so.0: undefined symbol: apr_pool_mutex_set
root@e74c71dca30e:~/src/git/swig-wrapper/Python# 
```

Doing a wide search for *.so* files, I found apr_pool_mutex_set on
```
  /usr/local/apr/lib/libapr-1.so.0.4.6
```
  
Then checking which libs _UniMRCP.so is loading I got:  

```
root@e74c71dca30e:~/src/git/swig-wrapper# ldd Python/_UniMRCP.so 
	linux-vdso.so.1 (0x00007fffd6956000)
	libunimrcpclient.so.0 => /usr/local/unimrcp/lib/libunimrcpclient.so.0 (0x00007f35cded2000)
	libaprutil-1.so.0 => /usr/lib/x86_64-linux-gnu/libaprutil-1.so.0 (0x00007f35cdca9000)
	libapr-1.so.0 => /usr/lib/x86_64-linux-gnu/libapr-1.so.0 (0x00007f35cda74000)
	libsofia-sip-ua.so.0 => /usr/local/lib/libsofia-sip-ua.so.0 (0x00007f35cd6de000)
	libpython2.7.so.1.0 => /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 (0x00007f35cd159000)
	libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f35cce4e000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f35ccb4d000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f35cc937000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f35cc58c000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f35cc36f000)
	libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1 (0x00007f35cc16a000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f35cbf62000)
	libcrypt.so.1 => /lib/x86_64-linux-gnu/libcrypt.so.1 (0x00007f35cbd2b000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f35cbb27000)
	libexpat.so.1 => /lib/x86_64-linux-gnu/libexpat.so.1 (0x00007f35cb8fe000)
	libssl.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 (0x00007f35cb69d000)
	libcrypto.so.1.0.0 => /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007f35cb2a0000)
	libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f35cb085000)
	libutil.so.1 => /lib/x86_64-linux-gnu/libutil.so.1 (0x00007f35cae82000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f35ce3a8000)
root@e74c71dca30e:~/src/git/swig-wrapper# 
````

Then checking /usr/lib/x86_64-linux-gnu/libapr-1.so.0:

```
root@e74c71dca30e:~/src/git/swig-wrapper# file /usr/lib/x86_64-linux-gnu/libapr-1.so.0
/usr/lib/x86_64-linux-gnu/libapr-1.so.0: symbolic link to libapr-1.so.0.5.1

root@e74c71dca30e:~/src/git/swig-wrapper# find / -name libapr-1.so.0.5.1
/usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1

root@e74c71dca30e:~/src/git/swig-wrapper# file /usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1
/usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, BuildID[sha1]=ee3a091400dbd6ffe0fd07d575c15e7585c4e126, stripped
```

But this doesn't have symbols:
```
root@e74c71dca30e:~/src/git/swig-wrapper# nm /usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1
nm: /usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1: no symbols
```

Then comparing the so files:
```
root@e74c71dca30e:~/src/git/swig-wrapper# ldd /usr/lib/x86_64-linux-gnu/libapr-1.so.0.5.1
	linux-vdso.so.1 (0x00007ffd23b11000)
	libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1 (0x00007f3db5035000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f3db4e2d000)
	libcrypt.so.1 => /lib/x86_64-linux-gnu/libcrypt.so.1 (0x00007f3db4bf6000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f3db49d9000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f3db47d5000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f3db442a000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f3db546f000)


root@e74c71dca30e:~/src/git/swig-wrapper# ldd /usr/local/apr/lib/libapr-1.so.0.4.6       
	linux-vdso.so.1 (0x00007ffe8f5d6000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f049fe71000)
	libcrypt.so.1 => /lib/x86_64-linux-gnu/libcrypt.so.1 (0x00007f049fc3a000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f049fa1d000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f049f819000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f049f46e000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f04a02a8000)
```

So i am not sure what is libapr-1.so.0.5.1 and how or why it was created.

But anyway I solved the issue by forcing the process search for libs at /usr/local/apr/lib:
```
root@e74c71dca30e:~/src/git/swig-wrapper/Python# LD_LIBRARY_PATH=/usr/local/apr/lib PYTHONPATH=wrapper ./UniSynth.py "The text to synthesize..."
This is a sample Python UniMRCP client synthesizer scenario.
Wrapper version: 0.4.5
Use client configuration from ../../../../unimrcp/conf/unimrcpclient.xml
Use profile uni1
Synthesize text: `The text to synthesize...'
Write output to file: ../../../../unimrcp/data/UniSynth.pcm

Press enter to start the session...
```

But to not require LD_LIBRARY_PATH I specified 
```
APR_LIBRARY=/usr/local/apr/lib/libapr-1.so.0.4.6 
```
instead of 
```
APR_LIBRARY=/usr/local/apr/lib/libapr-1.so
```
and it worked:
```
root@2cde789caac1:~/src/git/swig-wrapper/Python# PYTHONPATH=wrapper ./UniSynth.py "The text to synthesize..."
This is a sample Python UniMRCP client synthesizer scenario.
Wrapper version: 0.4.5
Use client configuration from ../../../../unimrcp/conf/unimrcpclient.xml
Use profile uni1
Synthesize text: `The text to synthesize...'
Write output to file: ../../../../unimrcp/data/UniSynth.pcm

Press enter to start the session...
```
----------------------------------------------
2022/09/14 takeshi:

Beware that 'make clean' is removing versioned files:
```
root@2cde789caac1:~/src/git/swig-wrapper# make clean

root@2cde789caac1:~/src/git/swig-wrapper# cmake -D APR_LIBRARY=/usr/local/apr/lib/libapr-1.so -D APR_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D APU_LIBRARY=/usr/local/apr/lib/libaprutil-1.so -D APU_INCLUDE_DIR=/usr/local/apr/include/apr-1 -D UNIMRCP_SOURCE_DIR=/usr/local/src/git/unimrcp -D SOFIA_INCLUDE_DIRS=/usr/include/sofia-sip-1.12 -D WRAP_CPP=OFF -D WRAP_JAVA=OFF-D BUILD_C_EXAMPLE=OFF .
-- Building UniMRCP wrapper version [0.4.5]
-- Could NOT find JNI (missing:  JAVA_AWT_LIBRARY JAVA_JVM_LIBRARY JAVA_INCLUDE_PATH JAVA_INCLUDE_PATH2 JAVA_AWT_INCLUDE_PATH) 
-- Could NOT find Doxygen (missing:  DOXYGEN_EXECUTABLE) 
-- Configuring done
-- Generating done
-- Build files have been written to: /root/src/git/swig-wrapper

root@2cde789caac1:~/src/git/swig-wrapper# make
[  6%] Swig source
UniMRCP-wrapper.h:1179: Warning 473: Returning a pointer or reference in a director method is not recommended.
UniMRCP-wrapper.h:1185: Warning 473: Returning a pointer or reference in a director method is not recommended.
make[2]: Circular CSharp/UniSynth.cs <- CSharp/UniSynth.cs dependency dropped.
[ 12%] Copying example CSharp/UniSynth.cs
Error copying file "/root/src/git/swig-wrapper/CSharp/UniSynth.cs" to "/root/src/git/swig-wrapper/CSharp/UniSynth.cs".
CMakeFiles/UniMRCP-NET.dir/build.make:53: recipe for target 'CSharp/UniSynth.cs' failed
make[2]: *** [CSharp/UniSynth.cs] Error 1
CMakeFiles/Makefile2:60: recipe for target 'CMakeFiles/UniMRCP-NET.dir/all' failed
make[1]: *** [CMakeFiles/UniMRCP-NET.dir/all] Error 2
Makefile:76: recipe for target 'all' failed
make: *** [all] Error 2
root@2cde789caac1:~/src/git/swig-wrapper# git status
HEAD detached at 01af0d8
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    CSharp/UniRecog.bat
	deleted:    CSharp/UniRecog.cs
	deleted:    CSharp/UniRecog.sh
	deleted:    CSharp/UniSynth.bat
	deleted:    CSharp/UniSynth.cs
	deleted:    CSharp/UniSynth.sh
	deleted:    Python/UniRecog.bat
	deleted:    Python/UniRecog.py
	deleted:    Python/UniSynth.bat
	deleted:    Python/UniSynth.py

```

If you do it by mistake just revert it by doing:
```
   git checkout CSharp
   git checkout Python
```
