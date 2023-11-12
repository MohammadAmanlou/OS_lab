#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
	int pid = fork();
	if(pid < 0){
	   printf(1, "Fork failed.\n");
	  }
	 else if(pid == 0){
	   sleep(100);
	   exit();
	 }
	 else{
	   wait();
	   
	     int lifetime = get_process_lifetime(pid);
	     if(lifetime >= 0){
	       printf(1, "child process lifetime: %d ticks\n", lifetime);
	     }
	     else{
	       printf(1, "error getting process lifetime.\n");
	   }
	 //}
	 }
	
	exit();
}
