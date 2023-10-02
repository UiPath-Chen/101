### Signal: 0
> If sig is 0, then no signal is send, but error checking is still performed; this can be used to check for the existence of a process ID or process group ID
```bash
exists=`killall -0 program; echo $?`
```

这里的信号0，并不表示要关闭某个程序，而表示对程序（进程）运行状态进行监控，如果发现进程关闭或其他异常，将返回状态码1，反之，如果发现进程运行正常，将返回状态码0. 相当于ps


