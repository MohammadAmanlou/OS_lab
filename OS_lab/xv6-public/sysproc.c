#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "fcntl.h"
#include "fs.h"
#include "spinlock.h"
//#include "file.h"
#include "sleeplock.h"
#include "stat.h"



/*int sys_get_process_lifetime(void){
  int pid;
  
  if(argint(0, &pid) < 0)
    return -1;
  //cprintf("sysproc.h %d", pid);
  return get_process_lifetime(pid);
}*/

int sys_get_process_lifetime(void){
  return get_process_lifetime();
}

int sys_get_uncle_count(void){
  int pid;
  if(argint(0, &pid) < 0){
    return -1;
  }
  return get_uncle_count(pid);
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_find_digital_root(void)
{
  int n = myproc()->tf->ebx;
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
  return find_digital_root(n);

}


// int sys_copy_file(void) {
//   char* src_path
//   char* dst_path;
//   struct file* f_dst;
//   struct file* f_src;
//   struct inode* ip_dst;
//   struct inode* ip_src;

//   if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
//     return -1;
//   begin_op();
//   if ((ip_src = namei(src_path)) == 0) { // Check if source file exists
//     end_op();
//     return -1;
//   }
//   ilock(ip_src);
//   ip_dst = namei(dst_path);
//   if (ip_dst) { // Check if destination file already exists
//     // Release destination file's resources
//     iunlockput(ip_dst);
//     end_op();
//     return -1;
//   }
//   ilock(ip_dst);

//   // Open source and destination files
//   if ((f_src = filealloc()) == 0 || (f_dst = filealloc()) == 0) {
//     end_op();
//     return -1;
//   }
//   fileref(f_src);
//   fileref(f_dst);
//   f_src->type = FD_INODE;
//   f_dst->type = FD_INODE;
//   f_src->ip = ip_src;
//   f_dst->ip = create(dst_path, T_FILE, 0, 0); // Create destination file

//   // Copy file contents from source to destination
//   filecopy(f_src, f_dst);

//   // Unlock and release resources
//   iunlockput(ip_src);
//   iunlockput(f_dst->ip);
//   end_op();

//   return 0;
// }


