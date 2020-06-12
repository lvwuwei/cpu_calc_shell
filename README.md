# cpu_calc_shell
cpu compte shell   cpu_calc.sh
最近试验要统计linux系统中的空闲资源(主要是内存和CPU资源)。空闲内存比较容易直接一个free函数就好！但是空闲cpu就比较麻烦了，不像是windows环境下有很多工具和函数可以使用。通过不停的搜索终于找到了求linux环境中空闲CPU的方法。

 

1. Linux下空闲内存

 

      虽然linux中的空闲内存可以通过free命令获得，不过不建议这么做，因为free出来一堆东西，格式处理不方便。其实linux中的内存信息都存储在/proc/meminfo中。空闲内存的信息就在第二行。如下：

MemTotal： ****** KB

MemFree： ****** KB

      所以通过该文件很容易就可以得到空闲内存了！

 

2. Linux下空闲CPU

 

 

      在Linux/Unix下，CPU利用率分为用户态，系统态和空闲态，分别表示CPU处于用户态执行的时间，系统内核执行的时间，和空闲系统进程执行的时间。平时所说的CPU利用率是指：CPU执行非系统空闲进程的时间 / CPU总的执行时间。

      在Linux的内核中，有一个全局变量：Jiffies。 Jiffies代表时间。它的单位随硬件平台的不同而不同。系统里定义了一个常数HZ，代表每秒种最小时间间隔的数目。这样jiffies的单位就是1/HZ。Intel平台jiffies的单位是1/100秒，这就是系统所能分辨的最小时间间隔了。每个CPU时间片，Jiffies都要加1。 CPU的利用率就是用执行用户态+系统态的Jiffies除以总的Jifffies来表示。

      在Linux系统中，可以用/proc/stat文件来计算cpu的利用率这个文件包含了所有CPU活动的信息，该文件中的所有值都是从系统启动开始累计到当前时刻。（详细信息可以参考http://www.linuxhowtos.org/System/procstat.htm）

 

 

输出解释

CPU 以及CPU0、CPU1、CPU2、CPU3每行的每个参数意思（以第一行为例）为：

 

参数	解释
user (432661) 

nice (13295) 

system (86656) 
idle (422145968) 

iowait (171474) 

irq (233) 
softirq (5346) 
 	从系统启动开始累计到当前时刻，用户态的CPU时间（单位：jiffies） ，不包含 nice值为负进程。1jiffies=0.01秒
从系统启动开始累计到当前时刻，nice值为负的进程所占用的CPU时间（单位：jiffies）
从系统启动开始累计到当前时刻，核心时间（单位：jiffies）
从系统启动开始累计到当前时刻，除硬盘IO等待时间以外其它等待时间（单位：jiffies）
从系统启动开始累计到当前时刻，硬盘IO等待时间（单位：jiffies） ，
从系统启动开始累计到当前时刻，硬中断时间（单位：jiffies）
从系统启动开始累计到当前时刻，软中断时间（单位：jiffies） 
 

 

CPU时间=user+system+nice+idle+iowait+irq+softirq

“intr”这行给出中断的信息，第一个为自系统启动以来，发生的所有的中断的次数；然后每个数对应一个特定的中断自系统启动以来所发生的次数。

“ctxt”给出了自系统启动以来CPU发生的上下文交换的次数。

“btime”给出了从系统启动到现在为止的时间，单位为秒。

“processes (total_forks) 自系统启动以来所创建的任务的个数目。

“procs_running”：当前运行队列的任务的数目。

“procs_blocked”：当前被阻塞的任务的数目。

那么CPU利用率可以使用以下两个方法。先取两个采样点，然后计算其差值。

 

 

以下计算空闲CPU的shell脚本。

根据网上流传的进行了一定的改写，增加了一个GROUP3，因为原来网上的代码在做减法运算时会出现参数错误，这个原因是因为在计算CPU时间连加时会超过了表达范围。所以改写了下：

 

$SYS_IDLE是空闲CPU，$Total是全部CPU。

如果是计算空闲率可以利用$SYS_IDLE/$Toal

